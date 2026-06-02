// Red 어댑터 — data-adapter.md §2 매핑표 구현. BFF 레이어(서버측)에 사는 코드.
// [HARD] Red 고유 필드명은 이 파일 + red-types.ts 안에만. 출력은 전부 정규화 계약 타입.
import type {
  NormalizedProduct,
  OptionGroup,
  OptionValue,
  ProductSide,
  SideKey,
  NormalizedConstraints,
  QuantityRule,
  InputSpec,
  DisableRule,
  SizeRule,
  NormalizedPriceRequest,
  NormalizedPriceBreakdown,
  PriceLine,
  NormalizedPresignedRequest,
  NormalizedPresigned,
  NormalizedUploadResult,
  NormalizedEditorConfig,
  NormalizedCartHandoff,
} from '@/contract';
import type {
  ProductAdapter,
  PriceAdapter,
  UploadAdapter,
  EditorAdapter,
  CartAdapter,
  DataAdapter,
} from '@/adapters/types';
import type {
  RedDigitalProductResponse,
  RedProductData,
  RedMtrlInfo,
  RedSizeInfo,
  RedPcsInfo,
  RedPriceResponse,
  RedPresignedResponse,
  RedPriceReqBody,
  RedPriceReqOrdInfo,
} from './red-types';
import { DATASET_COMPONENT_TYPE, pcsComponentType } from './component-type-map';

const num = (s: string | number | undefined): number => {
  if (typeof s === 'number') return s;
  const n = parseFloat(s ?? '0');
  return Number.isFinite(n) ? n : 0;
};

// ── Product: get_digital_product_info → NormalizedProduct (data-adapter §2.1) ────────
export function mapProduct(res: RedDigitalProductResponse): NormalizedProduct {
  const opt = res.result.product_option.option;
  const data = res.result.product_data;

  const hasInner = Array.isArray(data.inner_pdt_mtrl_info) && data.inner_pdt_mtrl_info.length > 0;
  const sides: ProductSide[] = hasInner
    ? [
        // 면별 uploadType 분기 [동작분석 runtime §3]: 표지=editor, 내지=pdf.
        // @MX:WARN exterior.uploadType 라이브 미확정(O3) — Red 캡처에 면별 uploadType 명시 필드 부재.
        // KOI 에디터 가용(useKoiEditor=Y) + 책자 표지=editor, 내지=pdf 로 잠정. 빌드타임 검증 필요.
        { key: 'default', label: '표지', uploadType: 'editor' },
        { key: 'inner', label: '내지', uploadType: 'pdf' },
      ]
    : [{ key: 'default', label: '기본', uploadType: opt.usePDF === 'Y' ? 'pdf' : 'editor' }];

  const optionGroups = mapOptionGroups(data, hasInner, opt.price_gbn);
  const constraints = mapConstraints(data);

  return {
    code: opt.pdt_cod,
    name: opt.pdt_nme,
    unit: data.pdt_base_info[0]?.PDT_UNIT ?? '개',
    priceSchemeKey: opt.price_gbn, // 불투명 echo
    sides,
    optionGroups,
    constraints,
    editors: {
      koi: opt.useKoiEditor === 'Y',
      rp: opt.useRPEditor === 'Y',
      pdf: opt.usePDF === 'Y',
    },
    // cta: DESIGN 부록A 상품군별. 책자 기본값(에디터+PDF+장바구니). 어댑터 책임.
    cta: {
      pdfUpload: opt.usePDF === 'Y',
      designEditor: opt.useKoiEditor === 'Y' || opt.useRPEditor === 'Y',
      cart: true,
      estimate: true,
    },
  };
}

function mtrlValue(m: RedMtrlInfo): OptionValue {
  return {
    id: m.MTRL_CD,
    label: m.MTRL_NM ?? m.PTT_NME ?? m.MTRL_CD,
    colorHex: m.CLR_HEX_CD || undefined,
    disabled: false,
  };
}

function sizeValue(s: RedSizeInfo): OptionValue {
  return { id: `SIZE_${s.DIV_SEQ}`, label: s.DIV_NM, disabled: false };
}

// PCS 그룹화: PCS_CD 별로 묶고, 각 PCS_DTL_CD 를 OptionValue 로.
function mapPcsGroups(pcsInfo: RedPcsInfo[], side: SideKey): OptionGroup[] {
  const byGroup = new Map<string, RedPcsInfo[]>();
  for (const p of pcsInfo) {
    const arr = byGroup.get(p.PCS_CD) ?? [];
    arr.push(p);
    byGroup.set(p.PCS_CD, arr);
  }
  const groups: OptionGroup[] = [];
  for (const [pcsCd, items] of byGroup) {
    const first = items[0];
    const values: OptionValue[] = items.map((it) => ({
      id: it.PCS_DTL_CD,
      label: it.PCS_DTL_NM,
      disabled: false,
    }));
    groups.push({
      id: `PCS_${pcsCd}`,
      side,
      label: first.PCS_GRP_NM,
      componentType: pcsComponentType(false), // colorHex 부재 → finish-button (RULE-2)
      required: first.ESN_YN === 'Y',
      visible: first.VIEW_YN === 'Y', // VIEW_YN=N = hidden essential (자동적용)
      multiple: false,
      values,
    });
  }
  return groups;
}

// 수량/내지장수 스펙(pdt_prn_cnt_info) → QuantityRule. mapOptionGroups·mapConstraints 공용.
// FIR/INC/STEP/DFT 와 책자 내지(MIN/MAX/STEP_INN_PAGE)를 한 곳에서 추출해 UI 그룹과 제약이 동일 소스를 본다.
function buildQuantityRule(data: RedProductData): QuantityRule | undefined {
  const prn = data.pdt_prn_cnt_info[0];
  if (!prn) return undefined;
  return {
    min: prn.MIN_PRN_CNT,
    first: prn.FIR_CNT,
    increment: prn.INC_CNT,
    step: prn.INC_STEP,
    default: prn.DFT_PRN_CNT,
    pageMin: prn.MIN_INN_PAGE,
    pageMax: prn.MAX_INN_PAGE,
    pageStep: prn.STEP_INN_PAGE,
  };
}

function mapOptionGroups(data: RedProductData, hasInner: boolean, priceScheme: string): OptionGroup[] {
  const groups: OptionGroup[] = [];
  const q = buildQuantityRule(data);

  // 규격
  const visibleSizes = data.pdt_size_info.filter((s) => s.HIDE_YN !== 'Y');
  if (visibleSizes.length > 0) {
    // NC-1: real_price(실사·배너, SizeMatrix2D) + 자유입력 sentinel("사이즈직접입력")이 있으면
    //  dimension-matrix-input(프리셋 칩 + 가로×세로 자유입력)로 라우팅. 그 외(digital S1/S2)는 option-button 유지.
    const hasFreeInput = visibleSizes.some(
      (s) => num(s.CUT_WDT) === 0 && num(s.CUT_HGH) === 0,
    );
    const isDimensionMatrix = priceScheme === 'real_price' && hasFreeInput;
    const base = data.pdt_base_info[0];
    // dimension-matrix 는 기본 선택이 기본규격(DFT_YN=Y)이 되도록 정렬(자유입력 sentinel 후순위).
    // store.defaultSelections 가 첫 값을 기본 선택하므로 — 첫 진입 = 기본규격(캡처: 5000X900), 빈 자유입력 아님.
    const orderedSizes = isDimensionMatrix
      ? [...visibleSizes].sort((a, b) => (b.DFT_YN === 'Y' ? 1 : 0) - (a.DFT_YN === 'Y' ? 1 : 0))
      : visibleSizes;
    groups.push({
      id: 'GRP_SIZE',
      side: 'default',
      label: '규격',
      componentType: isDimensionMatrix ? 'dimension-matrix-input' : DATASET_COMPONENT_TYPE.size,
      required: true,
      visible: true,
      values: orderedSizes.map(sizeValue),
      // 자유입력 범위(MIN/MAX_CUT) — dimension-matrix 일 때만. axis2=세로(InputSpec 기존 슬롯).
      ...(isDimensionMatrix
        ? {
            inputSpec: {
              min: num(base?.MIN_CUT_WDT),
              max: num(base?.MAX_CUT_WDT),
              step: 1,
              defaultValue: 0,
              axis2: {
                min: num(base?.MIN_CUT_HGH),
                max: num(base?.MAX_CUT_HGH),
                label: '세로',
              },
              helpText: `가로 ${num(base?.MIN_CUT_WDT)}~${num(base?.MAX_CUT_WDT)}mm · 세로 ${num(base?.MIN_CUT_HGH)}~${num(base?.MAX_CUT_HGH)}mm`,
            } satisfies InputSpec,
          }
        : {}),
    });
  }

  // 표지 용지 (select-box, 값 多)
  const covers = data.pdt_mtrl_info.filter((m) => m.HIDE_YN !== 'Y');
  if (covers.length > 0) {
    groups.push({
      id: 'GRP_MTRL_COVER',
      side: 'default',
      label: hasInner ? '표지 용지' : '용지',
      componentType: DATASET_COMPONENT_TYPE.material,
      required: true,
      visible: true,
      values: covers.map(mtrlValue),
    });
  }

  // 도수 (option-button) — priceColorCount 평면화 (data-adapter §2.2)
  if (data.pdt_dosu_info.length > 0) {
    groups.push({
      id: 'GRP_DOSU_COVER',
      side: 'default',
      label: '인쇄 도수',
      componentType: DATASET_COMPONENT_TYPE.dosu,
      required: true,
      visible: true,
      values: data.pdt_dosu_info.map((d) => ({
        id: d.COD,
        label: d.COD_NME,
        priceColorCount: d.PRN_CLR_CNT, // dosu↔bnc 평면화
        disabled: false,
      })),
    });
  }

  // 후가공 (finish-button, PCS_CD 그룹화)
  groups.push(...mapPcsGroups(data.pdt_pcs_info, 'default'));

  // 내지 (책자)
  if (hasInner && data.inner_pdt_mtrl_info) {
    const innerCovers = data.inner_pdt_mtrl_info.filter((m) => m.HIDE_YN !== 'Y');
    groups.push({
      id: 'GRP_MTRL_INNER',
      side: 'inner',
      label: '내지 용지',
      componentType: DATASET_COMPONENT_TYPE.material,
      required: true,
      visible: true,
      values: innerCovers.map(mtrlValue),
    });
    if (data.inner_pdt_dosu_info && data.inner_pdt_dosu_info.length > 0) {
      groups.push({
        id: 'GRP_DOSU_INNER',
        side: 'inner',
        label: '내지 인쇄 도수',
        componentType: DATASET_COMPONENT_TYPE.dosu,
        required: true,
        visible: true,
        values: data.inner_pdt_dosu_info.map((d) => ({
          id: `INNER_${d.COD}`,
          label: d.COD_NME,
          priceColorCount: d.PRN_CLR_CNT,
          disabled: false,
        })),
      });
    }

    // 내지 장수 (page-counter-input) — 책자만. MIN/MAX/STEP_INN_PAGE 기반 입력형 그룹.
    // [D1] 이전에는 mapConstraints 의 quantity 객체로만 들어가 UI 가 렌더되지 못했다.
    if (q?.pageMin != null && q?.pageMax != null) {
      groups.push({
        id: 'GRP_INNER_PAGE',
        side: 'inner',
        label: '내지 장수',
        componentType: DATASET_COMPONENT_TYPE.innerPage, // 'page-counter-input'
        required: true,
        visible: true,
        values: [], // 입력형 — values 대신 inputSpec 사용. 빈 배열로 계약 타입 충족(반복 시 no-op).
        inputSpec: {
          min: q.pageMin,
          max: q.pageMax,
          step: q.pageStep ?? 1,
          defaultValue: q.pageMin,
        } satisfies InputSpec,
      });
    }
  }

  // 수량 (counter-input) — 전 상품 공통. FIR/INC/STEP/DFT 기반 입력형 그룹.
  // [D1] 이전에는 mapConstraints 의 quantity 객체로만 들어가 OptionPanel 이 렌더할 그룹이 없었다.
  // 이 그룹이 UI 표면, mapConstraints 의 quantity 는 검증(clamp/snap) 소스 — 둘 다 같은 buildQuantityRule 사용.
  if (q) {
    groups.push({
      id: 'GRP_QUANTITY',
      side: 'default',
      label: '수량',
      componentType: DATASET_COMPONENT_TYPE.quantity, // 'counter-input'
      required: true,
      visible: true,
      values: [], // 입력형 — values 대신 inputSpec 사용. 빈 배열로 계약 타입 충족(반복 시 no-op).
      inputSpec: {
        min: q.min,
        max: Number.MAX_SAFE_INTEGER, // Red FIR/INC 기반 — 상한 미명시. 실상한은 가격 API/검증이 판단.
        step: q.step,
        first: q.first,
        defaultValue: q.default,
      } satisfies InputSpec,
    });
  }

  return groups;
}

function mapConstraints(data: RedProductData): NormalizedConstraints {
  const base = data.pdt_base_info[0];

  const disableRules: DisableRule[] = data.pdt_disable_pcs_info.map((r) => ({
    triggerValueId: r.MTRL_CD,
    // PCS_DTL_CD null = 그룹 전체 비활성. 그룹 id 는 mapPcsGroups 와 동일 규칙(PCS_ prefix).
    disablesGroupId: r.PCS_DTL_CD === null ? `PCS_${r.PCS_CD}` : undefined,
    disablesValueId: r.PCS_DTL_CD !== null ? r.PCS_DTL_CD : undefined,
  }));

  const sizeRules: SizeRule[] = data.pdt_size_info.map((s) => ({
    valueId: `SIZE_${s.DIV_SEQ}`,
    cutW: num(s.CUT_WDT),
    cutH: num(s.CUT_HGH),
    workW: num(s.WRK_WDT),
    workH: num(s.WRK_HGH),
  }));

  return {
    disableRules,
    // UI 그룹(GRP_QUANTITY/GRP_INNER_PAGE)과 동일 소스 — 그룹은 표면, 이 객체는 검증(clamp/snap).
    quantity: {
      default: buildQuantityRule(data),
    },
    sizeRules,
    base: {
      unit: base?.PDT_UNIT ?? '개',
      cutMargin: num(base?.CUT_MRG),
      minCutW: num(base?.MIN_CUT_WDT),
      minCutH: num(base?.MIN_CUT_HGH),
      maxCutW: num(base?.MAX_CUT_WDT),
      maxCutH: num(base?.MAX_CUT_HGH),
      nonStandardAllowed: base?.NO_STD_ABL_YN === 'Y',
    },
  };
}

// ── Price 직렬화: NormalizedPriceRequest → Red reqBody (data-adapter §2.4, S5 §2.3) ──
// [HARD] quantity↔ORD_CNT / printCount↔PRN_CNT 분리. 위젯은 두 수치를 각자 echo만,
//  ORD_INFO 직렬화는 어댑터(서버) 책임(INV-1). printCount 미전달(S0~S4) → PRN_CNT=1(하위호환).
// [S5 실측] tmpl/tiered_price 는 ORD_INFO[0]에 ORD_CNT+PRN_CNT 둘 다 있어야 PRICE>0(둘 다 누락 시 침묵 0).
export function serializeRedPriceRequest(req: NormalizedPriceRequest): RedPriceReqBody {
  const d = req.dimensions[0];
  const ord: RedPriceReqOrdInfo = {
    PDT_CD: req.productCode,
    CUT_WDT: d?.cutW ?? 0,
    CUT_HGH: d?.cutH ?? 0,
    WRK_WDT: d?.workW ?? 0,
    WRK_HGH: d?.workH ?? 0,
    ORD_CNT: req.quantity, // 주문건수(굿즈=디자인 수)
    PRN_CNT: req.printCount ?? 1, // 인쇄수량(미전달 상품군 = 1, 책자/디지털 하위호환)
    PRN_CLR_CNT: req.colorCounts.default,
    MTRL_CD: req.materials.default,
  };
  return {
    ORD_INFO: [ord],
    PCS_INFO: req.selectedFinishes.map((f) => ({
      // PCS_<CD> 그룹 id 에서 Red PCS_COD 복원(어댑터 내부 역매핑).
      PCS_COD: f.groupId.startsWith('PCS_') ? f.groupId.slice(4) : f.groupId,
      PCS_DTL_COD: f.valueId,
      ATTB: '',
    })),
    price_gbn: req.priceSchemeKey, // 불투명 echo (tmpl_price / tiered_price)
  };
}

// 가격호출 가드 — ORD_CNT≥1 && PRN_CNT≥1 (s5-pouch-live-note §②: Red 침묵 PRICE=0 결함 재현 금지).
// 위반 시 명시적 미견적(ok:false) 반환 — 침묵 0 아님. 어댑터(서버) 책임(위젯은 가격 의미 모름, INV-1).
function isPriceRequestQuotable(req: NormalizedPriceRequest): boolean {
  return (req.quantity ?? 0) >= 1 && (req.printCount ?? 1) >= 1;
}

const UNQUOTABLE_BREAKDOWN: NormalizedPriceBreakdown = {
  ok: false,
  finalPrice: 0,
  vat: 0,
  shipping: 0,
  lines: [],
};

// ── Price: NormalizedPriceRequest → Red → NormalizedPriceBreakdown (data-adapter §2.4) ──
// [HARD] 3단 워터폴은 어댑터가 finalPrice 로 평면화. 위젯은 산정 방식 모름.
export function mapPriceResponse(res: RedPriceResponse): NormalizedPriceBreakdown {
  const sum = res.result_sum;
  // finalPrice = PRICE_MALL≠PRICE ? PRICE_MALL : ORG_PRICE≠PRICE ? PRICE : ORG_PRICE
  let finalPrice: number;
  let vat: number;
  if (sum.PRICE_MALL !== sum.PRICE) {
    finalPrice = sum.PRICE_MALL;
    vat = sum.PRICE_MALL_VAT;
  } else if (sum.ORG_PRICE !== sum.PRICE) {
    finalPrice = sum.PRICE;
    vat = sum.PRICE_VAT;
  } else {
    finalPrice = sum.ORG_PRICE;
    vat = sum.ORG_PRICE_VAT;
  }

  const lines: PriceLine[] = res.result.map((l) => ({
    code: l.PCS_CD,
    label: l.PCS_CD, // 한글 label 은 result_log 에서 추출 가능하나 본 패스는 code 로(투명성 행은 선택적)
    amount: l.PRICE,
  }));

  return {
    ok: res.retCode === 200,
    finalPrice,
    vat,
    shipping: res.book_info?.DLVR_AMT ?? 0,
    lines,
    raw: res,
  };
}

// ── 어댑터 클래스 (fixture/실 BFF 데이터소스를 주입으로 분리) ───────────────────────
export interface RedDataSource {
  fetchProduct(code: string): Promise<RedDigitalProductResponse>;
  fetchPrice(req: NormalizedPriceRequest): Promise<RedPriceResponse>;
  fetchPresigned(req: NormalizedPresignedRequest): Promise<RedPresignedResponse>;
  fetchFileMeta(storedFileName: string): Promise<{ pageCount?: number; sizeBytes?: number }>;
  fetchEditorConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig>;
  postCartHandoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }>;
}

class RedProductAdapter implements ProductAdapter {
  constructor(private ds: RedDataSource) {}
  async getProduct(code: string): Promise<NormalizedProduct> {
    return mapProduct(await this.ds.fetchProduct(code));
  }
}

class RedPriceAdapter implements PriceAdapter {
  constructor(private ds: RedDataSource) {}
  async quote(req: NormalizedPriceRequest): Promise<NormalizedPriceBreakdown> {
    // 가드: ORD_CNT/PRN_CNT 누락(0) → 명시적 미견적(침묵 PRICE=0 재현 금지, s5 §2.4).
    if (!isPriceRequestQuotable(req)) return UNQUOTABLE_BREAKDOWN;
    return mapPriceResponse(await this.ds.fetchPrice(req));
  }
}

class RedUploadAdapter implements UploadAdapter {
  constructor(private ds: RedDataSource) {}
  async issuePresigned(req: NormalizedPresignedRequest): Promise<NormalizedPresigned> {
    const r = await this.ds.fetchPresigned(req);
    return { uploadUrl: r.presignedURL, storedFileName: r.filename, expiresInSec: 3600 };
  }
  async getFileMeta(
    storedFileName: string,
  ): Promise<Pick<NormalizedUploadResult, 'pageCount' | 'sizeBytes'>> {
    return this.ds.fetchFileMeta(storedFileName);
  }
}

class RedEditorAdapter implements EditorAdapter {
  constructor(private ds: RedDataSource) {}
  async getConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig> {
    return this.ds.fetchEditorConfig(code, side);
  }
}

class RedCartAdapter implements CartAdapter {
  constructor(private ds: RedDataSource) {}
  async handoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }> {
    // [UNDECIDED] 커머스 바인딩. 본 패스는 데이터소스로 위임(stub).
    return this.ds.postCartHandoff(payload);
  }
}

export function createRedAdapter(ds: RedDataSource): DataAdapter {
  return {
    product: new RedProductAdapter(ds),
    price: new RedPriceAdapter(ds),
    upload: new RedUploadAdapter(ds),
    editor: new RedEditorAdapter(ds),
    cart: new RedCartAdapter(ds),
  };
}
