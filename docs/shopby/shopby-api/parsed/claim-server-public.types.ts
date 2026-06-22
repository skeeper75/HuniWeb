// Auto-generated TypeScript types from claim-server

export interface cancel-exchanges1646626756 {
  /** 상품조정금액입력사유 */
  productAdjustReason?: string;
  /** 입금자명(추가결제시) */
  additionalPayRemitter?: string;
  /** 클레임사유-상세 */
  reasonDetail?: string;
  /** 추가결제입금계좌(추가결제시) (nullable)^|KB */
  additionalPayBankAccount?: Record<string, any>;
  /** 추가결제방법 (nullable)^|CASH,ACCUMULATION */
  additionalPayType?: string;
  /** 계산값 */
  calculateParam: Record<string, any>;
  /** 구매자 작성형 옵션 */
  purchaserInputs: any[];
  /** 클레임사유^|CHANGE_MIND, DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, CANCEL_BEFORE_PAY, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER, OTHERS_BUYER, LATER_INPUT_ORDER, LATER_INPUT_ORDER_RECEIVER_CANCEL */
  reasonType: string;
  /** 환불계좌(환불시) (nullable)^|KB */
  refundBankAccount?: Record<string, any>;
}

export interface option-cancels-sold-out2041411915 {
  /** 품절 주문 옵션번호^|[1,2,3] */
  orderOptionNos: any[];
}

export interface option-cancels-sold-out-set-option1925829967 {
  /** 품절 주문 옵션 */
  orderOptions: any[];
}

export interface return-exchanges-no-confirm-deposit934552446 {
  /** 입금자명(추가결제시) */
  additionalPayRemitter?: string;
  /** 추가결제입금계좌(추가결제시) (nullable)^|KB */
  additionalPayBankAccount?: Record<string, any>;
}

export interface claims-694067701 {
  /** 클레임목록 */
  contents: any[];
  /** 클레임개수^|1 */
  totalCount: number;
}

export interface claims-claimNo-assign-return-invoice1153638030 {
  /** 반품 송장번호 */
  returnInvoiceNo: string;
  /** 택배사^|CJ */
  deliveryCompanyType: string;
}

export interface claims-orderNo-exchange-infos-1914356139 {
}

export interface claims-claimNo-already-delivery-235042226 {
  /** 택배사 타입 (nullable)^|CJ,POST,HANJIN,GTX,LOTTE,KGB,LOGEN,CJHBL,GSI,KGL,INTRAS,UPS,JAPANPOST,YAMATO,SAGAWA,CHUNIL,KDEXP,HDEXP,ILYANG,POST_EMS,DAESIN,CVS,DHL,FEDEX,GSM,WARPEX,WIZWA,ACI,PANTOS,CJ_INTERNATIONAL,TNT,CU,KUNYOUNG,LOTTE_INTERNATIONAL,HONAM,HANIPS,IPARCEL,SLX,USPS,WONDERS */
  deliveryCompanyType?: string;
  /** 출고일시(yyyy-MM-dd)^|2020-05-31 */
  releaseYmd: string;
  /** 송장번호 (nullable)^|123455 */
  invoiceNo?: string;
}

export interface return-exchanges925138161 {
  /** 입금자명(추가결제시) */
  additionalPayRemitter?: string;
  /** 교환 배송메모 */
  exchangeDeliveryNote?: string;
  /** 구매자 작성형 옵션 */
  purchaserInputs: any[];
  /** 택배사 */
  deliveryCompanyType?: string;
  /** 교환배송비조정사유 */
  exchangeDeliveryAdjustReason?: string;
  /** 반품 배송메모 */
  returnDeliveryNote?: string;
  /** 클레임사유^|CHANGE_MIND, DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, CANCEL_BEFORE_PAY, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER, OTHERS_BUYER, LATER_INPUT_ORDER, LATER_INPUT_ORDER_RECEIVER_CANCEL */
  reasonType: string;
  /** 반품교환 이미지 */
  returnExchangeImages?: any[];
  /** 상품조정금액입력사유 */
  productAdjustReason?: string;
  /** 클레임사유-상세 */
  reasonDetail?: string;
  /** 추가결제입금계좌(추가결제시) (nullable)^|KB */
  additionalPayBankAccount?: Record<string, any>;
  /** 추가결제방법 (nullable)^|CASH,ACCUMULATION */
  additionalPayType?: string;
  /** 계산값 */
  calculateParam: Record<string, any>;
  /** 반품배송비조정사유 */
  returnDeliveryAdjustReason?: string;
  /** 반품송장 번호 */
  invoiceNo?: string;
  /** 환불계좌(환불시) (nullable)^|KB */
  refundBankAccount?: Record<string, any>;
}

export interface returns-no-collect-880281392 {
  /** 환불보류사유 (nullable)^|제품 확인 필요 */
  refundOnHoldReason?: string;
  /** 재고복원하는 옵션번호^|[1,2,3] */
  restoreStockOrderOptionNos: any[];
  /** 환불보류 여부^|false */
  refundOnHold: boolean;
  /** 환불보류 조정 요청금액^|2000 */
  refundHoldProposedAmt: number;
}

export interface option-cancels-1028891945 {
  /** 귀책사유^|BUYER, SELLER */
  responsibleObjectType: string;
  /** 클레임사유-상세 */
  reasonDetail?: string;
  /** 주문번호^|202003171021582677 */
  orderNo: string;
  /** 결제수단 별 환불금액 */
  complexRefundAdjust?: Record<string, any>;
  /** 초도배송비 판매자 부담 여부(true이면 판매자가 추가되는 초도배송비를 부담)^|false */
  sellerPaysClaimedDelivery: boolean;
  /** 클레임 옵션 정보 */
  orderOptionParams: any[];
  /** 클레임사유 (nullable)^|CHANGE_MIND, DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, CANCEL_BEFORE_PAY, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER, OTHERS_BUYER, LATER_INPUT_ORDER, LATER_INPUT_ORDER_RECEIVER_CANCEL */
  reasonType?: string;
  /** 환불계좌(환불시) (nullable)^|KB */
  refundBankAccount?: Record<string, any>;
}

export interface returns209153868 {
  /** 상세사유 (nullable)^|변심 */
  claimReasonDetail?: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 환불계좌정보 */
  bankAccountInfo?: Record<string, any>;
  /** 클레임사유 (nullable)^|CHANGE_MIND */
  claimReasonType?: string;
  /** 반품상품 수거방법 (nullable)^|SELLER_COLLECT */
  returnWayType?: string;
  /** 반품 택배사타입 (nullable)^|CJ */
  deliveryCompanyType?: string;
  /** 환불 조정 사유 (배송안함 상품만 환불 조정 가능) */
  refundAdjustReason?: string;
  /** 첨부파일 url 리스트 (nullable)^|url1,url2 */
  claimImageUrls?: any[];
  /** 반품주소(배송상품인 경우 필수, 배송안함상품인 경우 null 가능) */
  returnAddress?: Record<string, any>;
  /** 주문상품 옵션정보 */
  claimedProductOptions: any[];
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수)^|true */
  saveBankAccountInfo: boolean;
  /** 판매자 환불 조정 요청금액 (배송안함 상품만 환불 조정 가능) (nullable)^|1000 */
  refundAdjustRequestAmt?: number;
  /** 환불 조정 여부 (배송안함 상품만 환불 조정 가능) (nullable)^|false */
  isRefundAdjust?: boolean;
  /** 반품 송장번호 (nullable)^|123455 */
  invoiceNo?: string;
  /** 결제수단 별 환불금액 */
  complexRefundRequest?: Record<string, any>;
}

export interface return-exchanges-no-collect-1943409195 {
  /** 재고복원여부 - 교환은 대상상품이 1개이기 때문에 true/false로만 선택합니다. */
  restoresStock: boolean;
}

export interface order-cancels1915139160 {
  /** 귀책^|BUYER */
  responsibleObjectType: string;
  /** 환불방법^|PG,ACCOUNT,ZERO_REFUND */
  refundType: string;
  /** 취소사유-상세 */
  reasonDetail?: string;
  /** 주문번호 */
  orderNo: string;
  /** 취소사유 */
  reasonType: string;
  /** 환불계좌 */
  refundBankAccount?: Record<string, any>;
}

