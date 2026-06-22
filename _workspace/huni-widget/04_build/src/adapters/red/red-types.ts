// Red 원시 shape 타입 — [HARD] Red 고유 필드명(PCS_COD/MTRL_CD/ORD_INFO/price_gbn...)은
// 오직 이 파일 + red-adapter.ts 내부에만 존재한다. 위젯/계약은 절대 이 타입을 import 하지 않는다.
// 근거: 01_reverse/captures/*.json 실측 shape.

export interface RedDigitalProductResponse {
  retCode: number;
  msg: string;
  result: {
    product_option: { option: RedOption };
    product_data: RedProductData;
    member_info: RedMemberInfo;
  };
}

export interface RedOption {
  pdt_cod: string;
  pdt_nme: string;
  item_gbn: string;
  price_gbn: string;
  order_yn: string;
  useKoiEditor: string; // "Y" | "N"
  useRPEditor: string;
  usePDF: string;
  [k: string]: unknown;
}

export interface RedBaseInfo {
  PDT_CD: string;
  PDT_UNIT: string;
  MIN_CUT_WDT: string;
  MIN_CUT_HGH: string;
  MAX_CUT_WDT: string;
  MAX_CUT_HGH: string;
  CUT_MRG: string;
  NO_STD_ABL_YN: string; // "Y"=비표준 허용, "N"=불가
  FIR_CNT: number;
  INC: number;
  INC_STEP: number;
}

export interface RedMtrlInfo {
  MTRL_CD: string;
  MTRL_NM?: string;
  PTT_NME?: string;
  WGT_COD?: string;
  HIDE_YN: string;
  CLR_HEX_CD?: string;
  // N1: 추가색(별색/형광) 가용 자재 플래그. "Y"인 자재는 사용자 추가색 토글 시 PRN_CLR_CNT 가
  //  SID_S→6 / SID_D→12 로 상향(가격 증가). 근거 = pdt_mtrl_info[].ADD_CLR_YN(product_PRBKYPR.json:111)
  //  + widget.deob.js:15758(자재 게이트 addClrMtrlList.find(MTRL_CD===mtrlCd).ADD_CLR_YN==="Y").
  ADD_CLR_YN?: string;
}

export interface RedSizeInfo {
  DIV_NM: string;
  DIV_SEQ: number;
  WRK_WDT: string;
  WRK_HGH: string;
  CUT_WDT: string;
  CUT_HGH: string;
  DFT_YN: string;
  HIDE_YN: string;
  PDT_SIZE_INFO?: string;
}

export interface RedDosuInfo {
  COD: string;
  COD_NME: string;
  PRN_CLR_CNT: number;
}

export interface RedPcsInfo {
  PCS_CD: string;
  PCS_GRP_NM: string;
  PCS_DTL_CD: string;
  PCS_DTL_NM: string;
  VIEW_YN: string; // "Y" | "N"
  ESN_YN: string; // "Y" | "N"
  // L-1 속성칩 shape (b): RIN_DFT 류는 선택 옵션 그리드가 아니라 가격측 ATTB 단일 echo
  //  (ATTB_CD=속성코드 예 RIN_SLV, ATTB_NM=속성명 예 은색). major_attbchip_HLCLWAL.json 실측.
  //  shape (a) FOI/박은 ATTB_CD 부재(선택 그리드) — 어댑터가 둘을 구분.
  ATTB_CD?: string | null;
  ATTB_NM?: string | null;
  // W2-a discriminator(SUB_MTR 이중의미): material-multi(다종 자재선택)는 엔트리별 *비어있지 않은*
  //  MTRL_CD 를 갖는다(ACPDSTD SXAPR005 등 12종). 단일 add-on(AIPPCUT 에코백)은 MTRL_CD=""(빈값).
  //  근거: fixtures/product_ACPDSTD.json(MTRL_CD 12종 distinct) vs product_AIPPCUT.json(MTRL_CD 전부 "").
  MTRL_CD?: string | null;
}

export interface RedDisablePcs {
  MTRL_CD: string;
  PCS_CD: string;
  PCS_DTL_CD: string | null;
}

export interface RedPrnCntInfo {
  DFT_PRN_CNT: number;
  FIR_CNT: number | null;
  INC_CNT: number | null;
  INC_STEP: number | null;
  MIN_PRN_CNT: number | null;
  MIN_INN_PAGE: number | null;
  MAX_INN_PAGE: number | null;
  STEP_INN_PAGE: number | null;
  // S6 옵셋 캘린더(offset2023_price): 폐쇄 인쇄수량 래더. FIR/INC/MIN 이 모두 null 이고
  //  PRN_CNT(행별 고정 수량값) + DFT_YN 으로 enum 을 구성한다(자유 counter 가 아닌 select 래더).
  PRN_CNT?: number | string;
  DFT_YN?: string;
}

// N3 수량모델 A 래더(pdt_add_option_info): 떡메(TPBLMEO/TPBLPST)·PDT_VER_SIZE형 굿즈는
//  pdt_prn_cnt_info 행기반(모델B)이 아니라 PDT_VER_SIZE별 `MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h`
//  (h=0..9, 10단계) 산술 래더로 수량 enum 을 생성한다. 근거 = widget.deob.js:15428-15445(래더 산술)·
//  L19664(렌더 게이트 `pdt_add_option_info?.length`). PACK_PRN_CNT 는 라벨 표시("약 N장")용.
export interface RedAddOptionInfo {
  PDT_VER_SIZE: string;
  MIN_ORD_PRN_CNT: number;
  ADD_ORD_PRN_CNT: number;
  PACK_PRN_CNT?: number;
}

export interface RedProductData {
  pdt_base_info: RedBaseInfo[];
  pdt_mtrl_info: RedMtrlInfo[];
  pdt_size_info: RedSizeInfo[];
  pdt_dosu_info: RedDosuInfo[];
  pdt_dosu_bnc_info: Array<{ PRN_CLR_CNT: number; COD: string; COD_NME: string }>;
  pdt_pcs_info: RedPcsInfo[];
  // S6: 옵셋 캘린더는 null 로 옴(빈 비활성 규칙). 어댑터가 null→[] 평탄화.
  pdt_disable_pcs_info: RedDisablePcs[] | null;
  pdt_prn_cnt_info: RedPrnCntInfo[];
  // N3: 수량모델 A 래더 소스(보유 시 모델B 대신 이 래더로 수량 enum 생성). 미보유 상품군 = undefined.
  pdt_add_option_info?: RedAddOptionInfo[];
  inner_pdt_mtrl_info?: RedMtrlInfo[];
  inner_pdt_dosu_info?: RedDosuInfo[];
  // Wave C 의류(clothes2025): apparel_info 6블록(print_type/print_area/apparel_color/size_info/size_color_info/pantone_color).
  //  타입은 apparel.ts 의 ApparelInfo. red-types 는 존재만 선언(상세는 apparel 모듈).
  apparel_info?: unknown;
}

export interface RedMemberInfo {
  mb_cust_cod: string;
}

// 가격 응답 (price_q*.json 실측)
export interface RedPriceLine {
  PCS_CD: string;
  PCS_DTL_CD: string;
  PRICE: number;
  PRICE_VAT: number;
  PRICE_MALL: number;
  PRICE_MALL_VAT: number;
  ORG_PRICE: number;
  ORG_PRICE_VAT: number;
}

export interface RedPriceResponse {
  retCode: number;
  result: RedPriceLine[];
  result_sum: {
    PRICE: number;
    PRICE_VAT: number;
    PRICE_MALL: number;
    PRICE_MALL_VAT: number;
    ORG_PRICE: number;
    ORG_PRICE_VAT: number;
  };
  // result_log 는 책자 응답에만 존재 — 디지털인쇄(get_ajax_price_vTmpl) 캡처에는 부재. optional.
  result_log?: { list: unknown[] };
  book_info?: { DLVR_AMT: number };
}

// presigned 응답 (presigned_response_sample.json 실측)
export interface RedPresignedResponse {
  filename: string;
  presignedURL: string;
}

// ── 가격 요청 reqBody shape (get_ajax_price* 실측, s5_pouch_GSPUFBC/s3_rp_GSTGMIC 캡처) ──
// [HARD] ORD_CNT/PRN_CNT/ORD_INFO/price_gbn 등 Red 고유 필드는 이 파일 + red-adapter.ts 안에만.
// [S5 실측] tmpl/tiered_price 서버는 ORD_INFO[0]에 ORD_CNT(주문건수) + PRN_CNT(인쇄수량) 둘 다 요구.
//  둘 중 하나라도 없거나 0이면 PRICE=0(침묵). 캡처 incompleteReqBody/completeReqBody 근거.
export interface RedPriceReqOrdInfo {
  PDT_CD: string;
  CUT_WDT: number;
  CUT_HGH: number;
  WRK_WDT: number;
  WRK_HGH: number;
  ORD_CNT: number; // 주문건수 (정규화 quantity)
  PRN_CNT: number; // 인쇄수량 (정규화 printCount, 미전달 시 1)
  PRN_CLR_CNT?: number;
  MTRL_CD?: string;
  DOSU_COD?: string;
  // N1: 추가색 토글. 비book2025 빌더는 항상 emit(deob L13982·라이브 NCCDDFT reqBody ADD_CLR_YN="N").
  //  자재 ADD_CLR_YN="Y" + 사용자 추가색 ON 이면 "Y", 그 외 "N". "Y"일 때 PRN_CLR_CNT 가 6/12 로 상향.
  ADD_CLR_YN?: string;
  // ── 책자 분리필드 (data-adapter.md:80-86) — 표지/내지 색·자재 분리 + 면수.
  //  단일면 상품엔 부재(undefined → JSON 직렬화 시 생략). 책자(inner side 보유)에서만 출력.
  PAGE_CNT?: number;
  CVR_CLR_CNT?: number;
  INN_CLR_CNT?: number;
  CVR_MTRL_CD?: string;
  INN_MTRL_CD?: string;
}

// 가격요청 내부 페이로드 — 캡처 실측 reqBody 는 항상 `{dataJson:{...}}` 래핑 + mb_cust_cod 포함.
//  근거: captures/b1_AIPPCUT.json reqBody, data-adapter.md:80-86.
export interface RedPriceReqInner {
  ORD_INFO: RedPriceReqOrdInfo[];
  // L-1: ATTB 는 다형 불투명 문자열(속성칩값·수량 등). ATTB_2/ATTB_3 슬롯은 SUB_MTR 류가 운용(현 빈값).
  PCS_INFO: Array<{ PCS_COD: string; PCS_DTL_COD: string; ATTB?: string; ATTB_2?: string; ATTB_3?: string }>;
  price_gbn: string; // 불투명 가격체계 echo (tmpl_price / tiered_price / ...)
  mb_cust_cod: string; // 고객 등급 (정규화 customerTier ?? '10000000'). 누락 시 Red 침묵 0 위험.
}

// [HARD] 캡처 reqBody field-for-field 정합 — 최상위는 `{dataJson:{...}}` 래퍼.
//  이전(F-2): bare {ORD_INFO,PCS_INFO,price_gbn} → 실 Red 엔드포인트 거부/침묵0 위험.
export interface RedPriceReqBody {
  dataJson: RedPriceReqInner;
}
