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
  NormalizedOrderReadiness,
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
  RedPrnCntInfo,
  RedPriceResponse,
  RedPresignedResponse,
  RedPriceReqBody,
  RedPriceReqOrdInfo,
} from './red-types';
import {
  DATASET_COMPONENT_TYPE,
  pcsComponentType,
  pcsColorHexMap,
  roundingRadius,
} from './component-type-map';
import { accFilterConfig, ACC_PANEL_COMPONENT_TYPE } from './acc-config';
import type { AccPanelSpec, AccFilterGroup, VisibilityRule } from '@/contract';
import { buildApparelGroups, isApparelItemGroup, type ApparelInfo } from './apparel';

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

  // Wave C 의류: clothes2025 면 apparel_info → 의류 OptionGroup + visibilityRules(PTP_SLK 토글).
  const apparel =
    isApparelItemGroup(opt.item_gbn) && data.apparel_info
      ? buildApparelGroups(data.apparel_info as ApparelInfo)
      : undefined;
  // pttCode(부자재 config 키) — Red 위젯 init 파라미터. product_option.ptt_cod 가 있으면 사용(L-12).
  const pttCode = typeof opt.ptt_cod === 'string' ? opt.ptt_cod : undefined;
  const optionGroups = apparel
    ? apparel.groups
    : mapOptionGroups(data, hasInner, opt.price_gbn, opt.pdt_cod, pttCode);
  const constraints = mapConstraints(data, apparel?.visibilityRules);

  return {
    code: opt.pdt_cod,
    name: opt.pdt_nme,
    unit: data.pdt_base_info[0]?.PDT_UNIT ?? '개',
    priceSchemeKey: opt.price_gbn, // 불투명 echo
    // D-L2: itemGroup 불투명 분류 echo(Red item_gbn) — 스키마 분기 권위. 위젯 무계산.
    itemGroup: opt.item_gbn,
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

// L-2: 복합 2축 후가공(단/양면 × 코팅) — PCS_DTL_CD 가 `coating(slice0,4)+side(slice-1)` 합성코드.
//  Red(mod_07:2247~2249) 는 이를 단/양면 라디오 + 코팅 그리드 2축으로 렌더하고 가격 시 재합성.
//  우리도 어댑터가 2 OptionGroup(side=option-button, coating=finish-button)으로 분해하고,
//  serializeRedPriceRequest 가 `coating+side` 로 재합성한다(신규 leaf 불필요).
const COMPOSITE_PCS = new Set(['COT_DFT', 'SCO_DFT']);
// L-1 ATTB 후가공 — ATTB 는 PCS_DTL_COD/속성보유별 *다형*(단일 권위 없음).
//  [W1-c 권위 정정] 이전 주석의 mod_07:2597/2954/2470/3572("ATTB=orderQty")는 deob 소스에
//  *부존재*(deob_07=2607줄/deob_06=1392줄에서 종료, 인용 라인은 ATTB 대입 아님). 실재 deob
//  ATTB 대입은 4곳뿐이며 어느 것도 ORD_CNT(주문수량) 아님:
//    deob_07:1008  DIR_MTR  = materialMap[code].quantity  (선택자재 size-combo **장수**)
//    deob_07:2162  SUB_MTR  = ""                          (material-multi 빈문자열)
//    deob_07:2387  BID_SIL  = newValue                    (사용자 **속성값**)
//    deob_06:1250  material = orderData.quantityInfo.prnCnt(**PRN_CNT**, ORD_CNT 아님)
//  캡처 실측: 전 quantity-echo PCS 에서 ORD_CNT 는 항상 1 또는 부재 → ATTB=ORD_CNT 권위 0건.
//    PDT_WRK: GSPUFBC×2·GSTGMIC(PKT01) 4/4 ATTB='' (ORD_CNT=1 에도 '') → echo 대상 아님(W1-b 제외).
//  [D-1 RESOLVED 2026-06-04 qty-sweep] WRK_MTR/DIR_MTR ATTB = 사용자 건수(N) echo 라이브 검증:
//   GSTGMIC·ACNTHAP·GSPDLNG·GSTBMWM 에서 ATTB 가 {2,10} 로 PRN_CNT(건수)를 따라 변하고 PRICE 선형.
//   우리 String(req.quantity)=사용자 건수 N → Red ATTB(=건수 N)와 값 일치 → 현 동작 정당.
//  ※ 단 굿즈 건수의 *필드축*은 별건(G-6, 잠복/컨버전 게이트): Red 는 건수를 PRN_CNT 에 싣고 ORD_CNT=1,
//   우리는 ORD_CNT 에 실음. ATTB 값은 옳으나 실 HTTP 가격권위(PRN_CNT) 배선은 컨버전 시 정렬 필요.
//  INN_DFT 는 노트류 요청 shape 결함으로 scaling 미검증 유지(W2-b). SUB_MTR 은 W2-a(엔트리-shape).
const QUANTITY_ECHO_PCS = new Set(['SUB_MTR', 'INN_DFT', 'WRK_MTR', 'DIR_MTR']);
// W2-a(A-2 발현) SUB_MTR 이중의미 해소 — `QUANTITY_ECHO_PCS` 단일 Set 이 SUB_MTR 의 두 의미를
//  평면화한다: (a)다종 자재선택형(ACPDSTD: 엔트리별 distinct MTRL_CD·ATTB_CD None·VIEW_YN=Y) 은
//  Red 권위(deob_07:2162 material-multi)상 ATTB="" / (b)단일 add-on(AIPPCUT SUB_MTR EC001: MTRL_CD="")
//  은 라이브 캡처(05_qa/captures/b1_AIPPCUT.json)상 ATTB=1(=quantity echo). 단일 PCS_COD Set 으로는
//  둘을 못 가른다 → 의미는 PCS_COD 단일축이 아니라 *엔트리 shape*(MTRL_CD 보유/다종 여부).
//  [discriminator] material-multi = SUB_MTR 그룹의 엔트리가 *모두* 비어있지 않은 MTRL_CD 를 갖고
//   distinct MTRL_CD 가 2종 이상이며 어떤 엔트리도 ATTB_CD 를 갖지 않음(=가시 자재선택 리스트).
//   근거: fixtures/product_ACPDSTD.json(MTRL_CD 12종 distinct, ATTB_CD None) vs
//         product_AIPPCUT.json(MTRL_CD 전부 "" → 단일 add-on, 캡처 ATTB=1 유지).
//  [어댑터 전용 해법, INV-3] 이 판정은 mapProduct 시점(mapPcsGroups)에 데이터가 있으므로 어댑터 내부에서
//   material-multi 엔트리의 OptionValue.attb 슬롯에 '' 를 명시 적재한다. serialize 의 `f.attb ?? (echo)` 는
//   '' 가 nullish 아님이라 ATTB="" 로 단락(short-circuit) → 캡처/store/계약 무변경(코어 0줄).
//  [HARD] 새 권위 생성 아님 — ATTB="" 는 deob_07:2162, ATTB=1 echo 는 b1_AIPPCUT 캡처. 둘 다 실측.
//  [잔여·정직표기] material-multi 의 ATTB_2/ATTB_3 빈슬롯 동작은 캡처 0건(ACPDSTD 가격경로 미캡처)이라
//   권위 부재 → 현 quantity-echo 경로의 빈슬롯('')을 보존(무해한 빈문자열). 값 동작(ATTB="")만 보정.
function isMaterialMultiSubMtr(pcsCd: string, items: RedPcsInfo[]): boolean {
  if (pcsCd !== 'SUB_MTR') return false;
  const mtrlCds = items.map((it) => (it.MTRL_CD ?? '').trim());
  const allHaveMtrl = mtrlCds.every((c) => c.length > 0);
  const distinct = new Set(mtrlCds).size;
  const noAttbCd = items.every((it) => it.ATTB_CD == null);
  return allHaveMtrl && distinct >= 2 && noAttbCd;
}
// L-3a 멀티선택 후가공 — 귀돌이(ROU_DFT) 4귀 부분집합 선택(mod_07:3325 u=선택목록 배열).
const MULTI_SELECT_PCS = new Set(['ROU_DFT']);
// 합성그룹 식별 suffix — 직렬화 재합성이 이 규칙으로 짝을 찾는다.
const COMPOSITE_SIDE_SUFFIX = '__side';
const COMPOSITE_COATING_SUFFIX = '__coating';
// side 코드(slice -1) → 표시 라벨. (단면 S / 양면 D)
const COMPOSITE_SIDE_LABEL: Record<string, string> = { S: '단면', D: '양면' };

function splitCoatingSide(pcsDtlCd: string): { coating: string; side: string } {
  // coating = 앞 4자(TCMA/DFXX...), side = 마지막 1자(S/D).
  return { coating: pcsDtlCd.slice(0, 4), side: pcsDtlCd.slice(-1) };
}

// 복합 2축 후가공 1 PCS_CD → 2 OptionGroup(side option-button + coating finish-button).
function mapCompositePcsGroup(pcsCd: string, items: RedPcsInfo[], side: SideKey): OptionGroup[] {
  const first = items[0];
  // distinct side / coating 축 추출(중복 제거, 입력 순서 보존).
  const sideSeen = new Map<string, string>(); // sideCode → label
  const coatSeen = new Map<string, string>(); // coatingCode → label(첫 등장 PCS_DTL_NM)
  for (const it of items) {
    const { coating, side: sd } = splitCoatingSide(it.PCS_DTL_CD);
    if (!sideSeen.has(sd)) sideSeen.set(sd, COMPOSITE_SIDE_LABEL[sd] ?? sd);
    if (!coatSeen.has(coating)) coatSeen.set(coating, it.PCS_DTL_NM);
  }
  const required = first.ESN_YN === 'Y';
  const visible = first.VIEW_YN === 'Y';
  const sideGroup: OptionGroup = {
    id: `PCS_${pcsCd}${COMPOSITE_SIDE_SUFFIX}`,
    side,
    label: `${first.PCS_GRP_NM} 면`,
    componentType: 'option-button',
    required,
    visible,
    multiple: false,
    values: [...sideSeen].map(([id, label]) => ({ id, label, disabled: false })),
  };
  const coatingGroup: OptionGroup = {
    id: `PCS_${pcsCd}${COMPOSITE_COATING_SUFFIX}`,
    side,
    label: first.PCS_GRP_NM,
    componentType: pcsComponentType(false), // finish-button
    required,
    visible,
    multiple: false,
    values: [...coatSeen].map(([id, label]) => ({ id, label, disabled: false })),
  };
  return [sideGroup, coatingGroup];
}

// PCS 그룹화: PCS_CD 별로 묶고, 각 PCS_DTL_CD 를 OptionValue 로.
function mapPcsGroups(pcsInfo: RedPcsInfo[], side: SideKey, pdtCode: string): OptionGroup[] {
  const byGroup = new Map<string, RedPcsInfo[]>();
  for (const p of pcsInfo) {
    const arr = byGroup.get(p.PCS_CD) ?? [];
    arr.push(p);
    byGroup.set(p.PCS_CD, arr);
  }
  const groups: OptionGroup[] = [];
  for (const [pcsCd, items] of byGroup) {
    // L-2: 복합 2축 후가공은 side/coating 2그룹으로 분해.
    if (COMPOSITE_PCS.has(pcsCd)) {
      groups.push(...mapCompositePcsGroup(pcsCd, items, side));
      continue;
    }
    const first = items[0];
    // L-4: 색상 후가공(END_PAP 등) hex 상수맵 보유 시 colorHex 주입 → color-chip 라우팅.
    //  ColorChip 은 colorHex 를 이미 렌더하므로 데이터만 채우면 즉시 동작(D4 SPEC-L4).
    const hexMap = pcsColorHexMap(pcsCd);
    // L-3a: 귀돌이(ROU_DFT)는 4귀 부분집합 선택(멀티). multiple:true → MultiCheckGroup 렌더 + 배열선택.
    const isMulti = MULTI_SELECT_PCS.has(pcsCd);
    // L-3b: ROU_DFT 반경 ATTB 주입(번들 상수 roundingConfigMap 이식, mod_07:3300~3344).
    //  factor!=='size' 또는 미등록 상품(BCFOXXX/BCSPDFT)은 고정 default '4'. size-linked(GSCDPOP)는
    //  사이즈 DIV_SEQ 의존 — 로드 시엔 DFT 사이즈 DIV_SEQ 기준 초기값, 사이즈 변경 시 cascade 가 재계산.
    const rouRadius = isMulti && pcsCd === 'ROU_DFT' ? roundingRadius(pdtCode) : undefined;
    // W2-a: material-multi SUB_MTR(다종 자재선택)면 ATTB="" 권위(deob_07:2162) 적재 → quantity echo 차단.
    //  단일 add-on SUB_MTR(AIPPCUT, MTRL_CD="")은 false → attb=undefined 유지 → 캡처 ATTB=1 echo 보존.
    const materialMultiSubMtr = isMaterialMultiSubMtr(pcsCd, items);
    const values: OptionValue[] = items.map((it) => {
      // L-1 shape (b): ATTB_CD 보유(RIN_DFT 등) → 가격측 속성 echo 를 attb 슬롯에 적재.
      //  shape (a) FOI/박은 ATTB_CD 부재 → 일반 선택 그리드(attb 없음, PCS_DTL_COD 자체가 선택축).
      const attbCd = it.ATTB_CD ?? undefined;
      // W2-a: material-multi 는 빈문자열 명시(serialize 에서 '' 가 echo 를 단락) > rouRadius > 속성칩 > undefined.
      const attb = materialMultiSubMtr ? '' : (rouRadius ?? attbCd ?? undefined);
      return {
        id: it.PCS_DTL_CD,
        label: it.PCS_DTL_NM,
        colorHex: hexMap?.[it.PCS_DTL_CD],
        ...(attb != null ? { attb } : {}),
        disabled: false,
      };
    });
    groups.push({
      id: `PCS_${pcsCd}`,
      side,
      label: first.PCS_GRP_NM,
      // hexMap 있으면 color-chip, 아니면 finish-button (RULE-2/RULE-4).
      componentType: pcsComponentType(Boolean(hexMap)),
      required: first.ESN_YN === 'Y',
      visible: first.VIEW_YN === 'Y', // VIEW_YN=N = hidden essential (자동적용)
      multiple: isMulti,
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
  // S6: 옵셋 캘린더는 FIR/INC/MIN 이 null(폐쇄 래더 = select enum). 이때 counter 규칙은 GRP_PRN_CNT
  //  select 가 대체하므로 null→0 평탄화로 충분(계약 QuantityRule 은 number — clamp/snap 가드가 0 을 흡수).
  return {
    min: prn.MIN_PRN_CNT ?? 0,
    first: prn.FIR_CNT ?? 0,
    increment: prn.INC_CNT ?? 0,
    step: prn.INC_STEP ?? 0,
    default: prn.DFT_PRN_CNT,
    pageMin: prn.MIN_INN_PAGE ?? undefined,
    pageMax: prn.MAX_INN_PAGE ?? undefined,
    pageStep: prn.STEP_INN_PAGE ?? undefined,
  };
}

// S6 옵셋 캘린더(offset2023_price): pdt_prn_cnt_info 가 자유 counter(FIR/INC 보유)가 아니라
//  폐쇄 인쇄수량 래더(FIR/INC/MIN 모두 null + 행별 PRN_CNT 고정값)인지 판정. 그렇다면 PRN_CNT 는
//  counter-input 이 아니라 select-box enum 으로 렌더해야 한다(임의값 PRICE=0 방지, 명세 §3.3-A).
function prnCntLadder(data: RedProductData): RedPrnCntInfo[] {
  const rows = data.pdt_prn_cnt_info ?? [];
  const ladder = rows.filter(
    (r) => r.FIR_CNT == null && r.INC_CNT == null && r.PRN_CNT != null && num(r.PRN_CNT) > 0,
  );
  return ladder;
}

function mapOptionGroups(
  data: RedProductData,
  hasInner: boolean,
  priceScheme: string,
  pdtCode: string,
  pttCode?: string,
): OptionGroup[] {
  const groups: OptionGroup[] = [];
  const q = buildQuantityRule(data);
  const prnLadder = prnCntLadder(data);

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
  groups.push(...mapPcsGroups(data.pdt_pcs_info, 'default', pdtCode));

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

  // 수량/인쇄수량.
  // (A) S6 옵셋 캘린더: PRN_CNT 가 폐쇄 래더(FIR/INC null)면 counter-input 이 아니라 select-box enum.
  //     임의 수량 입력 시 PRICE=0(서버가 등록 래더값만 단가 보유) → 자유입력 왜곡 금지(명세 §3.3-A, 선택지 A).
  //     componentType 은 기존 select-box 재사용(신규 타입 0). 값 = pdt_prn_cnt_info[].PRN_CNT.
  // (B) 그 외(책자/디지털/굿즈): 기존 counter-input GRP_QUANTITY 유지.
  if (prnLadder.length > 0) {
    // store.defaultSelections 가 첫 값을 기본 선택하므로 기본값(DFT_YN=Y)을 선두로 정렬.
    const ordered = [...prnLadder].sort(
      (a, b) => (b.DFT_YN === 'Y' ? 1 : 0) - (a.DFT_YN === 'Y' ? 1 : 0),
    );
    groups.push({
      id: 'GRP_PRN_CNT',
      side: 'default',
      label: '수량',
      componentType: DATASET_COMPONENT_TYPE.material, // 'select-box' (폐쇄 enum, 신규 타입 아님)
      required: true,
      visible: true,
      values: ordered.map((r) => ({
        id: String(num(r.PRN_CNT)),
        label: String(num(r.PRN_CNT)),
        disabled: false,
      })),
    });
  } else if (q) {
    // [D1] 이전에는 mapConstraints 의 quantity 객체로만 들어가 OptionPanel 이 렌더할 그룹이 없었다.
    // 이 그룹이 UI 표면, mapConstraints 의 quantity 는 검증(clamp/snap) 소스 — 둘 다 같은 buildQuantityRule 사용.
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

  // L-12 ACC 부자재 다단 캐스케이드/멀티 — accFilterConfigMap 등록 상품만 acc-panel 그룹 추가.
  //  미등록(ACPDSTD 류 단순 add-on)은 SUM_MTR finish-button 으로 이미 흡수 → 본 패널 미생성.
  const accCfg = accFilterConfig(pdtCode, pttCode);
  if (accCfg) {
    const accGroups: AccFilterGroup[] = accCfg.filters.map((f, idx) => ({
      id: `ACC_F${idx}`,
      label: f.GRP_NME,
      kind: f.GRP_TYPE === 'MTRL_MULTI_GRP' ? 'multi-group' : 'cascade-step',
      // cascade: 옵션 부재(기종/패턴/컬러) 단계는 직전 단계 선택에 의존(동적).
      dependsOn: f.GRP_TYPE === 'MTRL_SUB_GRP' && !f.options ? `ACC_F${idx - 1}` : undefined,
      groupCode: f.GRP_COD,
      values: (f.options ?? []).map((o) => ({ id: o.COD, label: o.COD_NME, disabled: false })),
    }));
    const accSpec: AccPanelSpec = { uiType: accCfg.uiType, groups: accGroups };
    groups.push({
      id: 'ACC_PANEL',
      side: 'default',
      label: '부자재',
      componentType: ACC_PANEL_COMPONENT_TYPE, // 'acc-panel'
      required: false,
      visible: true,
      values: [], // 패널 — values 대신 accSpec 사용.
      accSpec,
    });
  }

  return groups;
}

function mapConstraints(data: RedProductData, extraVisibilityRules?: VisibilityRule[]): NormalizedConstraints {
  const base = data.pdt_base_info[0];

  // S6: 일부 상품(옵셋 캘린더)은 pdt_disable_pcs_info 가 null(빈 비활성 규칙). null→[] 평탄화.
  const disableRules: DisableRule[] = (data.pdt_disable_pcs_info ?? []).map((r) => ({
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
    // P4: VIEW_YN 동적 add/remove 룰. 일반 상품은 product_info 에 명시 룰 부재(Red 런타임 v()) → 빈 배열.
    //  Wave C 의류: PTP_SLK 선택 시 multiSize/pantone 토글 룰을 어댑터(apparel.ts)가 산출해 주입.
    visibilityRules: extraVisibilityRules ?? [],
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
// [HARD] 출력 shape = 캡처 실측 reqBody(captures/b1_AIPPCUT.json) field-for-field 정합:
//  `{dataJson:{ORD_INFO:[{...}], PCS_INFO, price_gbn, mb_cust_cod}}`.
//  - dataJson 래퍼 + mb_cust_cod(customerTier??'10000000') 필수 — 누락 시 실 Red 거부/침묵0(F-2).
//  - 책자(inner side 보유 → materials.inner/colorCounts.inner 존재)는 표지/내지 분리필드(CVR_/INN_*)
//    + PAGE_CNT 출력(data-adapter.md:80-86). 단일면 상품은 undefined → JSON 직렬화 시 생략.
//  - DOSU_COD 는 의도 omit(OPEN-1) — PRN_CLR_CNT 가 도수 가격의미 운반(테스트 입증, 회귀 가드 유지).
export function serializeRedPriceRequest(req: NormalizedPriceRequest): RedPriceReqBody {
  const d = req.dimensions[0];
  // D-L2: 책자 판정 권위 = itemGroup(book2025 분류, 명시값). Red 는 item_gbn 으로 스키마 분기(mod_05:1859).
  //  itemGroup 미전달(레거시) 시에만 inner/pageCount 형상 휴리스틱 fallback(취약성 격리).
  const isBook =
    req.itemGroup != null
      ? req.itemGroup.startsWith('book2025')
      : req.materials.inner !== undefined ||
        req.colorCounts.inner !== undefined ||
        req.pageCount !== undefined;
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
  if (isBook) {
    // 책자 표지/내지 분리 (data-adapter.md:81-84). 표지=default, 내지=inner.
    ord.PAGE_CNT = req.pageCount;
    ord.CVR_CLR_CNT = req.colorCounts.default;
    ord.INN_CLR_CNT = req.colorCounts.inner;
    ord.CVR_MTRL_CD = req.materials.default;
    ord.INN_MTRL_CD = req.materials.inner;
  }
  return {
    dataJson: {
      ORD_INFO: [ord],
      PCS_INFO: req.selectedFinishes.map((f) => {
        // PCS_<CD> 그룹 id 에서 Red PCS_COD 복원(어댑터 내부 역매핑).
        //  L-2: 복합 2축 그룹은 store 가 base groupId(PCS_COT_DFT) + 재합성 valueId(coating+side)로 emit.
        const pcsCod = f.groupId.startsWith('PCS_') ? f.groupId.slice(4) : f.groupId;
        // L-1 ATTB(QUANTITY_ECHO_PCS): String(req.quantity) echo + ATTB_2/3 빈슬롯.
        //  [W1-c] mod_07:2586/2467 인용은 deob 부존재(상단 set 정의 주석 참조). ATTB scaling 미검증 —
        //  qty=1 캡처 우연일치, qty>1 재캡처/컨버전 게이트(D-1) 전까지 값 동작 보존.
        //  Red 코드지식은 어댑터에만(INV-1) — 위젯/store 는 수량을 ATTB 로 계산하지 않음.
        const isQuantityEchoPcs = QUANTITY_ECHO_PCS.has(pcsCod);
        const entry: { PCS_COD: string; PCS_DTL_COD: string; ATTB: string; ATTB_2?: string; ATTB_3?: string } = {
          PCS_COD: pcsCod,
          PCS_DTL_COD: f.valueId,
          // L-1: ATTB 다형 불투명 echo(속성칩값=f.attb / 수량형=quantity). 미보유 후가공은 ''(하위호환).
          ATTB: f.attb ?? (isQuantityEchoPcs ? String(req.quantity) : ''),
        };
        // ATTB_2/ATTB_3 슬롯: 수량형 후가공은 빈슬롯 운용(mod_07:2598). 그 외는 explicit attb2/3 만.
        if (f.attb2 != null) entry.ATTB_2 = f.attb2;
        else if (isQuantityEchoPcs) entry.ATTB_2 = '';
        if (f.attb3 != null) entry.ATTB_3 = f.attb3;
        else if (isQuantityEchoPcs) entry.ATTB_3 = '';
        return entry;
      }),
      price_gbn: req.priceSchemeKey, // 불투명 echo (tmpl_price / tiered_price)
      // W1-a(G-INT-2): `||` 로 빈문자열까지 falsy 처리. `??` 는 null/undefined 만 catch 하여
      //  customerTier:'' 가 mb_cust_cod:'' 로 직렬화 → 캡처 실증상 Red 침묵 PRICE=0 유발
      //  ([HARD] PRICE=0=우리측 결함). 빈문자열은 비회원 공개가(10000000)로 대체.
      mb_cust_cod: req.customerTier || '10000000', // 고객등급 (미전달/빈값 시 비회원 공개가)
    },
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

  // [D-L3 정합] Red 는 `!result_sum.PRICE → 주문불가`(mod_06:1167). retCode===200 이어도 PRICE 가
  //  0/누락이면 침묵 0원이 주문으로 빠져나갈 수 있다 → 어댑터가 ok 게이트로 차단.
  //  finalPrice(워터폴 평면화) > 0 을 ok 조건에 포함해 0원 응답이 절대 ok:true 로 통과하지 못하게 한다.
  const ok = res.retCode === 200 && finalPrice > 0;

  // [HARD 도메인 재정의] RedPrinting 위젯은 PRICE=0 을 정상 반환하지 않는다 — 0 은 항상 우리측
  //  요청/세션/스펙선택 결함 신호(정상 "미가격 빈상태" 아님). 0 을 침묵 처리하지 않고 진단 사유를 명시.
  //  비치명적(throw 안 함) — 미캡처 fixture(포스터/의류/ACC, PRICE=0)의 렌더를 깨지 않기 위함.
  //  [TODO 재캡처] 그 fixture 들의 0 은 우리 캡처공백(비로그인/세션)이지 Red 미가격이 아니다 →
  //  PRICE>0 재캡처 필요: BNBNFBL/BNPTPET(포스터), CLSTSHS(의류), ACPDSTD/GSSBMTL(ACC).
  let priceUnavailableReason: string | undefined;
  if (finalPrice <= 0) {
    priceUnavailableReason =
      'Red 위젯은 PRICE=0 을 정상 반환하지 않음 — 세션 만료/필수필드 누락/스펙선택 결함 또는 우리측 가격캡처 공백 가능성';
    if (typeof console !== 'undefined' && typeof console.warn === 'function') {
      console.warn(`[price] PRICE=0 진단: ${priceUnavailableReason} (retCode=${res.retCode})`);
    }
  }

  return {
    ok,
    finalPrice,
    vat,
    shipping: res.book_info?.DLVR_AMT ?? 0,
    lines,
    raw: res,
    ...(priceUnavailableReason ? { priceUnavailableReason } : {}),
  };
}

// ── 어댑터 클래스 (fixture/실 BFF 데이터소스를 주입으로 분리) ───────────────────────
export interface RedDataSource {
  fetchProduct(code: string): Promise<RedDigitalProductResponse>;
  fetchPrice(req: NormalizedPriceRequest): Promise<RedPriceResponse>;
  fetchPresigned(req: NormalizedPresignedRequest): Promise<RedPresignedResponse>;
  fetchFileMeta(storedFileName: string): Promise<{ pageCount?: number; sizeBytes?: number }>;
  fetchEditorConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig>;
  // L-D3-1: 서버 주문가능 판정(isReadyToOrder → can_order/doc_rev).
  fetchOrderReadiness(payload: NormalizedCartHandoff): Promise<NormalizedOrderReadiness>;
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
  async isReadyToOrder(payload: NormalizedCartHandoff): Promise<NormalizedOrderReadiness> {
    // L-D3-1: 서버 주문가능 판정 위임(Red isReadyToOrder → can_order/doc_rev).
    return this.ds.fetchOrderReadiness(payload);
  }
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
