// Red 어댑터 — data-adapter.md §2 매핑표 구현. BFF 레이어(서버측)에 사는 코드.
// [HARD] Red 고유 필드명은 이 파일 + red-types.ts 안에만. 출력은 전부 정규화 계약 타입.
import type {
  NormalizedProduct,
  OptionGroup,
  OptionValue,
  ProductSide,
  SideKey,
  NormalizedConstraints,
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

  const optionGroups = mapOptionGroups(data, hasInner);
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

function mapOptionGroups(data: RedProductData, hasInner: boolean): OptionGroup[] {
  const groups: OptionGroup[] = [];

  // 규격 (option-button)
  const visibleSizes = data.pdt_size_info.filter((s) => s.HIDE_YN !== 'Y');
  if (visibleSizes.length > 0) {
    groups.push({
      id: 'GRP_SIZE',
      side: 'default',
      label: '규격',
      componentType: DATASET_COMPONENT_TYPE.size,
      required: true,
      visible: true,
      values: visibleSizes.map(sizeValue),
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
  }

  return groups;
}

function mapConstraints(data: RedProductData): NormalizedConstraints {
  const base = data.pdt_base_info[0];
  const prn = data.pdt_prn_cnt_info[0];

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
    quantity: {
      default: prn
        ? {
            min: prn.MIN_PRN_CNT,
            first: prn.FIR_CNT,
            increment: prn.INC_CNT,
            step: prn.INC_STEP,
            default: prn.DFT_PRN_CNT,
            pageMin: prn.MIN_INN_PAGE,
            pageMax: prn.MAX_INN_PAGE,
            pageStep: prn.STEP_INN_PAGE,
          }
        : undefined,
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
