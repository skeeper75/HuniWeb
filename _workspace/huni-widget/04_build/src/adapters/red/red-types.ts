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
}

export interface RedDisablePcs {
  MTRL_CD: string;
  PCS_CD: string;
  PCS_DTL_CD: string | null;
}

export interface RedPrnCntInfo {
  DFT_PRN_CNT: number;
  FIR_CNT: number;
  INC_CNT: number;
  INC_STEP: number;
  MIN_PRN_CNT: number;
  MIN_INN_PAGE: number;
  MAX_INN_PAGE: number;
  STEP_INN_PAGE: number;
}

export interface RedProductData {
  pdt_base_info: RedBaseInfo[];
  pdt_mtrl_info: RedMtrlInfo[];
  pdt_size_info: RedSizeInfo[];
  pdt_dosu_info: RedDosuInfo[];
  pdt_dosu_bnc_info: Array<{ PRN_CLR_CNT: number; COD: string; COD_NME: string }>;
  pdt_pcs_info: RedPcsInfo[];
  pdt_disable_pcs_info: RedDisablePcs[];
  pdt_prn_cnt_info: RedPrnCntInfo[];
  inner_pdt_mtrl_info?: RedMtrlInfo[];
  inner_pdt_dosu_info?: RedDosuInfo[];
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
  result_log: { list: unknown[] };
  book_info?: { DLVR_AMT: number };
}

// presigned 응답 (presigned_response_sample.json 실측)
export interface RedPresignedResponse {
  filename: string;
  presignedURL: string;
}
