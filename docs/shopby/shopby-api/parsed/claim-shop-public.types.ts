// Auto-generated TypeScript types from claim-shop

export interface guest-order-options-orderOptionNo-claims-estimate974114982 {
  /** 차감금액정보 */
  subtractionAmtInfo: Record<string, any>;
  /** 환불방법(노출용)^|신용카드 */
  refundTypeLabel: string;
  /** 환불금액(적립금제외)^|1000 */
  refundMainPayAmt: number;
  /** 배송비정보 */
  deliveryAmtInfo: Record<string, any>;
  /** 외부결제 환불 정보 (nullable)^|1000 */
  refundExternalPayInfos?: any[];
  /** 적립금환불금액^|1000 */
  refundSubPayAmt: number;
  /** 환불금액(적립금포함)^|1000 */
  refundPayAmt: number;
  /** 추가결제금액^|1000 */
  additionalPayAmt: number;
  /** 환불결제방법^|CREDIT_CARD */
  refundPayType: string;
  /** 외부결제 환불금액^|1000 */
  refundExternalPayAmt: number;
  /** 상품금액정보 */
  productAmtInfo: Record<string, any>;
}

export interface guest-claims-claimNo-check-withdraw-980884798 {
  /** 클레임 번호^|1 */
  claimNo: number;
  /** 이후 클레임 번호^|1, 2 */
  afterClaimNos: any[];
  /** 철회 시 유효성 검증 타입^|EXISTS_AFTER_CLAIM_WITH_CART_COUPON */
  validationType: string;
  /** 배송 번호^|1, 2 */
  shippingNos: any[];
}

export interface profile-order-options-orderOptionNo-claims-1445504772 {
  /** 택배사타입^|CJ */
  deliveryCompanyTypes: any[];
  /** 클레임 대상 상품 */
  originalOption: Record<string, any>;
  /** 클레임 사유 목록 */
  claimReasonTypes: any[];
  /** 수거지(반품할 물건을 수거하러 갈 주소) (nullable) */
  returnAddress?: Record<string, any>;
  /** 클레임 불가 사유 - ORDER_STATUS_TYPE(주문상태가 클레임 불가), NAVER_PAY(네이버페이 주문), NON_CLAIM_PRODUCT(클레임 불가 상품) (nullable) */
  nonClaimReason?: string;
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 결제수단 (nullable)^|CREDIT_CARD */
  payType?: string;
  /** 교환배송지 (nullable) */
  exchangeAddress?: Record<string, any>;
  /** 같이 클레임 가능한 상품 */
  claimableOptions: any[];
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER)^|BUYER */
  responsibleObjectTypes: any[];
  /** 환불 가능한 은행 */
  availableBanks: any[];
  /** 등록되어 있는 환불계좌 (nullable) */
  refundAccount?: Record<string, any>;
  /** 택배사 목록 */
  deliveryCompanyTypeWithLabels: any[];
  /** 반품할 물건을 보낼 주소 (nullable) */
  returnWarehouse?: Record<string, any>;
}

export interface profile-claims-estimate-373007703 {
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 주문상품옵션정보 */
  claimedProductOptions: any[];
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 취소/반품할 제품수량 */
  productCnt: number;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 반품상품 수거방법 (nullable)^|SELLER_COLLECT */
  returnWayType?: string;
}

export interface guest-order-options-orderOptionNo-claims-return-1392338352 {
  /** 상세사유 (nullable)^|변심 */
  claimReasonDetail?: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수)^|true */
  saveBankAccountInfo: boolean;
  /** 환불계좌정보 (nullable) */
  bankAccountInfo?: Record<string, any>;
  /** 취소/반품할 제품수량^|1 */
  productCnt: number;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 반품상품 수거방법 (nullable)^|SELLER_COLLECT */
  returnWayType?: string;
  /** 반품택배사타입 (nullable)^|CJ */
  deliveryCompanyType?: string;
  /** 첨부파일 url 리스트 (nullable)^|url1,url2 */
  claimImageUrls?: any[];
  /** 반품송장번호 (nullable)^|1234555 */
  invoiceNo?: string;
  /** 반품 주소(배송상품인 경우 필수, 배송안함상품인 경우 null 가능) (nullable) */
  returnAddress?: Record<string, any>;
}

export interface profile-orders-orderNo-claims-cancel-744213769 {
  /** 상세사유^|다른상품구매 */
  claimReasonDetail: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수)^|true */
  saveBankAccountInfo: boolean;
  /** 계좌정보 (nullable) */
  bankAccountInfo?: Record<string, any>;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 즉시환불여부(기본 값: true)(주문상태가 결제완료인 옵션인 경우 즉시환불 가능)^|true */
  refundsImmediately: boolean;
}

export interface profile-claims-free-gifts-satisfy1138615305 {
}

export interface profile-order-options-orderOptionNo-claims-cancel-1041878093 {
  /** 상세사유^|다른상품구매 */
  claimReasonDetail: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수)^|true */
  saveBankAccountInfo: boolean;
  /** 계좌정보 (nullable) */
  bankAccountInfo?: Record<string, any>;
  /** 취소 제품수량 */
  productCnt: number;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 즉시환불여부(기본 값: true)(주문상태가 결제완료인 옵션인 경우 즉시환불 가능)^|true */
  refundsImmediately: boolean;
}

export interface guest-claims-return537786107 {
  /** 상세사유 (nullable)^|변심 */
  claimReasonDetail?: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 주문상품 옵션정보 */
  claimedProductOptions: any[];
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수)^|true */
  saveBankAccountInfo: boolean;
  /** 환불계좌정보(가상계좌 주문은 필수) (nullable) */
  bankAccountInfo?: Record<string, any>;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 반품상품 수거방법 (nullable)^|SELLER_COLLECT */
  returnWayType?: string;
  /** 반품 택배사타입 (nullable)^|CJ */
  deliveryCompanyType?: string;
  /** 첨부파일 url 리스트 (nullable)^|url1,url2 */
  claimImageUrls?: any[];
  /** 반품 송장번호 (nullable)^|123455 */
  invoiceNo?: string;
  /** 반품주소(배송상품인 경우 필수, 배송안함상품인 경우 null 가능) (nullable) */
  returnAddress?: Record<string, any>;
}

export interface profile-claims145926277 {
  /** 총갯수^|0 */
  totalCount: number;
  /** 유저 클레임 (nullable) */
  items?: any[];
}

export interface profile-claims-free-gifts-satisfy-23813812 {
}

export interface profile-claims-cancel-2023591141 {
  /** 상세사유^|다른상품구매 */
  claimReasonDetail: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 주문상품옵션정보 */
  claimedProductOptions: any[];
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수)^|true */
  saveBankAccountInfo: boolean;
  /** 계좌정보 (nullable) */
  bankAccountInfo?: Record<string, any>;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 즉시환불여부(기본 값: true)(주문상태가 결제완료인 옵션인 경우 즉시환불 가능)^|true */
  refundsImmediately: boolean;
}

export interface guest-order-options-orderOptionNo-claims-result380162098 {
  /** 클레임사유상세 (nullable)^|다른상품구매 */
  claimReasonDetail?: string;
  /** 반품배송정보 (nullable) */
  returnDelivery?: Record<string, any>;
  /** 취소/상품상품 리스트 */
  claimedOptions: any[];
  /** 클레임번호^|1 */
  claimNo: number;
  /** 교환상품 (nullable) */
  exchangedOption?: Record<string, any>;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 반품상품 수거방법 (nullable)^|SELLER_COLLECT */
  returnWayType?: string;
  /** 주문옵션번호^|1 */
  orderProductOptionNo: number;
  /** 클레임신청일시^|YYYY-MM-DD hh:mm:ss */
  claimYmdt: string;
  /** 교환 추가금액 결제 정보 (nullable) */
  exchangePayInfo?: Record<string, any>;
  /** 출고전교환인경우 true^|true */
  exchangeBeforeDelivery: boolean;
  /** 반품/교환 이미지 첨부파일 url 리스트 (nullable)^|url1,url2 */
  claimImageUrls?: any[];
  /** 취소/반품상품 */
  claimedOption: Record<string, any>;
  /** 반품수거지 (nullable) */
  returnAddress?: Record<string, any>;
  /** 클레임타입^|CANCEL */
  claimType: string;
  /** 교환출고배송지 (nullable) */
  exchangeAddress?: Record<string, any>;
  /** 클레임종류^|OPTION_CANCEL */
  claimClassType: string;
  /** 금액정보 */
  claimPriceInfo: Record<string, any>;
  /** 환불계좌 정보(무통장 및 가상계좌) (nullable) */
  refundBankAccount?: Record<string, any>;
}

export interface guest-order-options-orderOptionNo-claims-return1157243429 {
  /** 클레임된 옵션 목록 */
  claimedOptions: any[];
  /** 클레임 번호^|1 */
  claimNo: number;
}

export interface profile-claims-claimNo-account1993194450 {
  /** 계좌소유자명 (nullable)^|홍길동 */
  depositorName?: string;
  /** 은행코드 (nullable)^|KB */
  bank?: string;
  /** 계좌번호 (nullable)^|123-12-1234 */
  account?: string;
}

export interface profile-order-options-orderOptionNo-claims-exchange-42712885 {
  /** 상세사유^|다른상품구매 */
  claimReasonDetail: string;
  /** 귀책 - responsibleObjectType이 null이면 ClaimReasonType에 매핑되는 귀책 적용(CHANGE_MIND, CANCEL_BEFORE_PAY, OTHERS_BUYER -> BUYER / DEFECTIVE_PRODUCT, WRONG_DELIVERY, OUT_OF_STOCK_SYSTEM, WRONG_PRODUCT_DETAIL, DELAY_DELIVERY, OUT_OF_STOCK, OTHERS_SELLER -> SELLER) (nullable)^|BUYER */
  responsibleObjectType?: string;
  /** 입금자명(추가결제시) (nullable)^|홍길동 */
  additionalPayRemitter?: string;
  /** 환불계좌정보 (nullable) */
  bankAccountInfo?: Record<string, any>;
  /** 취소/반품할 제품수량^|1 */
  productCnt: number;
  /** 현재 주문 상태 (nullable) */
  orderStatusType?: string;
  /** 클레임사유^|CHANGE_MIND */
  claimReasonType: string;
  /** 반품수거방법(SELLER_COLLECT 일 경우 returnAddress(반품수거주소지) 입력 필요) (nullable)^|SELLER_COLLECT */
  returnWayType?: string;
  /** 택배사타입 (nullable)^|CJ */
  deliveryCompanyType?: string;
  /** 첨부파일 url 리스트 (5개까지 가능, 취소교환은 무시되며, 반품교환만 저장합니다.) (nullable)^|url1,url2 */
  claimImageUrls?: any[];
  /** 반품수거 주소지(배송상품인 경우 필수, 배송안함상품인 경우 null 가능) (nullable) */
  returnAddress?: Record<string, any>;
  /** 추가결제입금계좌(추가결제시) (nullable) */
  additionalPayBankAccount?: Record<string, any>;
  /** 환불계좌정보 저장 여부(true일 경우 bankAccountInfo 필수) (nullable)^|true */
  saveBankAccountInfo?: boolean;
  /** 추가결제방법 (nullable)^|CASH */
  additionalPayType?: string;
  /** 교환출고지주소 (nullable) */
  exchangeAddress?: Record<string, any>;
  /** 교환할 옵션 */
  exchangeOption: Record<string, any>;
  /** 송장번호 (nullable)^|123455 */
  invoiceNo?: string;
}

