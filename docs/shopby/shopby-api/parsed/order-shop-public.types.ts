// Auto-generated TypeScript types from order-shop

export interface order-sheets-orderSheetNo-coupons-maximum-303567390 {
  /** 주문서번호^|202001012000000009 */
  orderSheetNo: string;
  /** buyAmt[장바구니 금액] = totalStandardAmt[최종상품금액] - totalImmediateDiscountAmt[즉시할인가] - totalAdditionalDiscountAmt[추가할인가] - productCouponAmt[상품쿠폰할인금액]^|2500 */
  cartAmt: number;
  /** 배송비^|2500 */
  deliveryAmt: number;
  /** 장바구니쿠폰할인금액^|0 */
  cartCouponDiscountAmt: number;
  /** 장바구니 쿠폰 */
  cartCoupons: any[];
  /** 상품쿠폰할인금액^|0 */
  productCouponDiscountAmt: number;
  /** 상품 정보 */
  products: any[];
}

export interface recurring-payments-close-recurring-payment-id935753167 {
  /** 정기결제 해지 사유 */
  closeReasonType: string;
  /** 정기결제 신청번호 리스트 (bulk api에 사용) (nullable)^|[] */
  recurringPaymentIds?: any[];
  /** 해지 사유(closeReasonType.etc 일 경우만) (nullable)^|너무 비싸요 */
  closeReason?: string;
}

export interface app-card-pay-cards-946465379 {
  /** 가맹점 회원 기준 원클릭 설정 상태^|OFF */
  oneClickOnOff: string;
  /** 간편결제 카드 리스트 */
  cards: any[];
  /** 결제 UI 구분 (원클릭 설정: Y)^|N */
  uiType: string;
  /** 간편결제 계정 개수 (최대 10개)^|2 */
  listCount: number;
}

export interface guest-orders-orderNo-1818402154 {
  /** 주문옵션타입^|ALL */
  orderRequestType: string;
  /** 비회원 주문 비밀번호 (nullable)^|12345 */
  password?: string;
  /** 주문자명 (nullable) */
  name?: string;
  /** 핸드폰번호 (nullable) */
  mobileNo?: string;
  /** 이메일 (nullable) */
  email?: string;
}

export interface guest-orders-orderNo-cashReceipt-1729704969 {
  /** 현금영수증 발급 키 타입 (nullable)^|MOBILE_NO */
  cashReceiptKeyType?: string;
  /** 발급 용도에 따른 키(소득공제용: 휴대폰번호, 지출증빙용: 사업자번호)^|123456 */
  cashReceiptKey: string;
  /** 발급용도^|INCOME_TAX_DEDUCTION */
  cashReceiptIssuePurposeType: string;
}

export interface profile-previous-orders-summary-1407177678 {
  /** 수량^|0 */
  count: number;
}

export interface recurring-payments-cart246616480 {
  /** 회원의 총 Cart 상품수^|1 */
  count: number;
}

export interface my-pay-payment-infos1316359 {
  /** 결제정보 리스트(아래필드) */
  paymentInfos: any[];
  /** 결과코드^|0000 */
  resultCode: string;
  /** 결과메시지^|URLEncoding(정상 처리되었습니다.) */
  resultMsg: string;
}

export interface recurring-payments-card-880282222 {
  /** 결과^|SUCCESS */
  result: string;
}

export interface order-sheets-orderSheetNo1186835880 {
  rentalInfos?: any[];
  /** 합배송 그룹별 상품 목록 */
  deliveryGroups: any[];
  /** 개인정보 사용 파트너 */
  sellerPrivacyUsagePartners: any[];
  /** 적용된 쿠폰 (nullable) */
  appliedCoupons?: Record<string, any>;
  /** 사용가능한 결제정보 <br /> 쇼핑몰에서 다양한 PG사와 계약해서 결제수단을 제공할 수 있기 때문에, payType을 기준으로 pgTypes를 내려주고 있으니 프론트에서 구현 시 내려온 pgTypes에 따라 결제모듈을 제공할 수 있습니다. */
  availablePayTypes: any[];
  /** 거래은행 정보 */
  tradeBankAccountInfos: any[];
  /** 유효하지 않은 상품 (nullable) */
  invalidProducts?: any[];
  freeGiftInfos?: any[];
  /** 주문자 연락처 (nullable) */
  ordererContact?: Record<string, any>;
  /** 쿠폰, 적립금 동시 사용 차단 여부^|false */
  blockUseAccumulationWhenUseCoupon: boolean;
  /** 필수동의항목^|TERMS_OF_USE */
  agreementTypes: any[];
  /** 개인통관고유부호필요여부 (true: 필요, false: 불필요)^|false */
  requireCustomsIdNumber: boolean;
  /** 배송 불가능한 국가 목록 (ISO 3166-1 alpha-2)^|[KR, CN, JP] */
  undeliverableCountries: any[];
  /** 최근사용한 결제수단^|CREDIT_CARD */
  lastPayType?: string;
  /** 프로모션 정보 요약 (nullable) */
  orderSheetPromotionSummary?: Record<string, any>;
  /** 무통장입금 거래 시 현금영수증 사용 여부 (true: 사용, false: 미사용)^|false */
  applyCashReceiptForAccount: boolean;
  /** 필수 약관 동의 항목 리스트 */
  termsInfos: any[];
  /** 외부결제수단정보 (nullable) */
  externalPaymentInfos?: any[];
  /** 추가 약관 동의 항목 리스트 */
  customTermsInfos: any[];
  myPayInfo?: Record<string, any>;
  /** 해외결제 결제정보 (nullable) */
  internationalPaymentInfo?: Record<string, any>;
  /** 배송지 */
  orderSheetAddress: Record<string, any>;
  /** 결제정보 */
  paymentInfo: Record<string, any>;
  /** 해외 파트너 */
  foreignPartners: any[];
}

export interface guest-orders-orderNo-cashReceipt2050717985 {
  /** 신청 결과 ( ISSUE: 발행완료, REQUEST_ONLY: 응답없음, FAIL: 실패 )^|ISSUE */
  resultType: string;
  /** 결과 상세 메시지 (resultType이 ISSUE가 아닐때 값 존재 (nullable)^|현금 영수증 발급 가능 상태가 아닙니다. */
  resultMsg?: string;
}

export interface payments-reserve487730185 {
  /** 주문서번호^|20170100000000001 */
  orderSheetNo: string;
  /** 외부 PG사^|123456 */
  pgType: string;
  /** 각 PG사에서 요구하는 특수 정보 */
  extraData?: Record<string, any>;
  /** client화면이 전환될 URL^|https://localhost.com/ */
  clientReturnUrl: string;
  /** 결제키 환경 (nullable)^|ALPHA */
  profile?: string;
  /** confirm redirect url (nullable)^|https://api.e-ncp.com/payments/confirm-redirect */
  confirmUrl?: string;
  /** PG사에서 전달 받은 결제 URL (nullable)^|https://alpha-bill.payco.com */
  returnUrl?: string;
  /** PG사에서 전달 받은 예약 승인 키 값 (nullable)^|39XAYgaTMcGjzM8E-H75zO44GAYfEDTk1tw5F2q9Q8uVDkrPWU1s4SwpEeQEwp2tr */
  key?: string;
}

export interface guest-orders-orderNo-322429229 {
  /** deprecated(더 이상 제공하지 않는 개체항목입니다) */
  insurance?: Record<string, any>;
  /** 결제완료시 PG사에서 전달 받는 암호키(지원 PG: 토스간편결제) (nullable)^|order-certify-key */
  orderCertifyKey?: string;
  /** 추가 정보 (nullable) */
  extraData?: Record<string, any>;
  /** 구매확정 시 적립예정 적립금^|0 */
  accumulationAmtWhenBuyConfirm: number;
  /** 기본 주문 상태^|DEPOSIT_WAIT */
  defaultOrderStatusType: string;
  /** PG사 결제키^|testtest */
  pgMallKey: string;
  /** 배송지 메모^|배송지 메모 내용 */
  memo: string;
  /** 최초주문금액정보 */
  firstOrderAmount: Record<string, any>;
  /** 주문메모 (nullable)^|선물포장 부탁드립니다 */
  orderMemo?: string;
  /** 개인통관고유부호필요여부(true: 필요, false: 불필요)^|false */
  requireCustomsIdNumber: boolean;
  /** 환불(예상)방법(PG)(deprecated: refundTypeLabel 사용)^|PG */
  refundType: string;
  /** 결제 영수증 정보 */
  receiptInfos: any[];
  /** 교환추가결제 정보 (nullable) */
  exchangePayInfos?: any[];
  /** 결제수단 (nullable)^|CREDIT_CARD */
  payType?: string;
  /** 현금영수증 발행 정보 */
  cashReceiptInfo?: Record<string, any>;
  /** 회원여부(true: 회원, false: 비회원)^|true */
  member: boolean;
  /** 다음에 할 수 있는 작업 */
  nextActions: any[];
  /** 에스크로 여부(true: 에스크로, false: 비에스크로)^|false */
  escrow: boolean;
  /** 선택가능한 은행 */
  availableBanks: any[];
  /** 비회원-인증토큰 (nullable)^|121212 */
  guestToken?: string;
  /** (예상)환불방법(노출용) */
  refundTypeLabel: string;
  /** 외부 PG사^|PAYCO */
  pgType: string;
  /** 주문번호^|202012341234 */
  orderNo: string;
  /** 최종주문금액정보 */
  lastOrderAmount: Record<string, any>;
  /** 환불정보 (nullable) */
  refundInfos?: any[];
  /** 추가결제정보 (nullable) */
  additionalPayInfos?: any[];
  /** 해외결제정보 */
  internationalPayInfo?: Record<string, any>;
  /** 배송지 메모^|빠른 배송 부탁드립니다. */
  deliveryMemo: string;
  /** 환불결제방법(deprecated: refundTypeLabel 사용)^|CANCEL_DEPOSIT */
  refundPayType: string;
  /** 선택가능한 사유 목록 */
  claimReasonTypes: any[];
  /** 주문만료 일자 - (가상계좌 전용) (nullable)^|YYYY-MM-DD hh:mm:ss */
  paymentExpirationYmdt?: string;
  /** 현재 주문에 대한 클레임 정보 (nullable) */
  claimHistories?: any[];
  /** 주문자정보 */
  orderer: Record<string, any>;
  /** PG사 결제번호(주문번호) - 매출전표등 확인용 (nullable)^|202012341234 */
  pgOrderNo?: string;
  /** 파트너별주문리스트 */
  orderOptionsGroupByPartner: any[];
  /** 배송지정보 */
  shippingAddress: Record<string, any>;
  /** 주문일자^|YYYY-MM-DD hh:mm:ss */
  orderYmdt: string;
  /** 결제지 주소 */
  billingAddress?: Record<string, any>;
  /** 결제수단라벨 (nullable)^|신용카드 */
  payTypeLabel?: string;
  /** 결제정보 */
  payInfo?: Record<string, any>;
}

export interface wish566396638 {
}

export interface recurring-payments-recurringPaymentId263338414 {
  /** 상태 변경 사유 (nullable)^|결제 실패 */
  statusChangeReason?: string;
  adjustableDeliveryCycle?: Record<string, any>;
  deliveryInfo?: Record<string, any>;
  cardInfo?: Record<string, any>;
  /** 정기결제 신청번호^|recurring-12345 */
  recurringPaymentId: string;
  deliveryCycle?: Record<string, any>;
  /** 다음 정기 결제 배송일지^|2024-04-22 */
  nextDeliveryDate: string;
  /** 정기결제 선물하기 여부^|false */
  isPresent: boolean;
  /** 정기결제 상태^|ACTIVE */
  status: string;
  /** 정기결제 종료 회차 (nullable)^|10 */
  lastRound?: number;
  productInfo?: Record<string, any>;
}

export interface recurring-payments-guest-cart681064580 {
}

export interface profile-shipping-addresses-addressNo-default-60033717 {
  /** 성 (nullable)^|홍 */
  lastName?: string;
  /** 기본 배송지 여부^|Y */
  defaultYn: string;
  /** 도시 (nullable)^|Los Angeles */
  city?: string;
  /** 국가코드 (nullable)^|KR */
  countryCd?: string;
  /** 배송지 우편 번호^|13487 */
  receiverZipCd: string;
  /** [개발중] 연락처 국가코드 (nullable)^|null */
  receiverMobileCountryCd?: string;
  /** 주/지역 (nullable)^|CA */
  state?: string;
  /** 연락처1^|010-0000-0000 */
  receiverContact1: string;
  /** 연락처2 (nullable)^|010-0000-0000 */
  receiverContact2?: string;
  /** 배송지 등록일 (nullable)^|YYYY-MM-DD hh:mm:ss */
  registerYmdt?: string;
  /** 배송지 지번 (nullable)^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress?: string;
  /** 수령자 명^|홍길동 */
  receiverName: string;
  /** 배송지타입^|RECENT */
  addressType: string;
  /** 개인고유통관부호 (nullable)^|P12341234 */
  customsIdNumber?: string;
  /** 배송지 마지막 사용일 (nullable)^|YYYY-MM-DD hh:mm:ss */
  lastUseYmdt?: string;
  /** 외부회원 번호 (nullable)^|M001 */
  externalMemberNo?: string;
  /** 배송지 메모 (nullable)^|공동 현관 비밀번호: 1234 */
  addressMemo?: string;
  /** 배송지 상세 주소 (nullable)^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress?: string;
  /** 배송지 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** 해외배송지 기타정보 */
  shippingEtcInfo?: Record<string, any>;
  /** 이름 (nullable)^|길동 */
  firstName?: string;
  /** 회원 번호^|1 */
  memberNo: number;
  /** 배송지 번호^|1 */
  addressNo: number;
  /** 주소록명^|홍길동집 */
  addressName: string;
  /** 쇼핑몰 번호^|1 */
  mallNo: number;
}

export interface order-sheets-orderSheetNo-calculate-895073402 {
  /** 합배송 그룹별 상품 목록 */
  deliveryGroups: any[];
  /** 적용된 쿠폰 */
  appliedCoupons: Record<string, any>;
  /** 사용가능한 결제정보 <br /> 쇼핑몰에서 다양한 PG사와 계약해서 결제수단을 제공할 수 있기 때문에, payType을 기준으로 pgTypes를 내려주고 있으니 프론트에서 구현 시 내려온 pgTypes에 따라 결제모듈을 제공할 수 있습니다. */
  availablePayTypes: any[];
  freeGiftInfos?: any[];
  /** 해외결제 결제정보 (nullable) */
  internationalPaymentInfo?: Record<string, any>;
  /** 결제정보 */
  paymentInfo: Record<string, any>;
}

export interface recurring-payments-recurringPaymentId-gifts791737874 {
  /** 정기결제 신청번호^|recurring-12345 */
  recurringPaymentId: string;
  freeGiftCondition?: Record<string, any>;
  freeGifts?: any[];
  selectedFreeGifts?: any[];
}

export interface payments-naver-ordersheet127871417 {
  /** 주문서 번호. items[].channelType 이 존지해는 경우 서버에서 주문서번호 생성함. (nullable)^|202001010101 */
  orderSheetNo?: string;
  /** 쇼핑몰에서 사용 할 extraData (nullable)^|{} */
  extraData?: string;
  /** 이동URL^|http://localhost:8080 */
  clientReturnUrl: string;
  /** SA CLICK ID. 네이버 검색광고 이용 가맹점 중 광고주 센터의 광고 효과 보고서를 통해 네이버페이 전환 데이터를 확인하길 원하는 가맹점은 SA로부터 받은 추적 URL 파라미터 중 NVADID를 입력. (nullable)^|nvadid */
  nvadid?: string;
  /** 네이버 서비스 유입 경로 코드. (nullable)^|naCo */
  naCo?: string;
  /** 구매상품 */
  items: any[];
}

export interface wish-154609169 {
}

export interface order-sheets1946220584 {
  /** 주문서번호^|202001012000000009 */
  orderSheetNo: string;
}

export interface cart-subset592056677 {
  /** 배송 그룹 */
  deliveryGroups: any[];
  /** 가격 정보 */
  price?: Record<string, any>;
  /** 유효하지 않은 상품 */
  invalidProducts: any[];
}

export interface recurring-payments-recurringPaymentGroupNo-guest1973833865 {
  /** 토큰^|guest-token */
  guestToken: string;
}

export interface wish-1240815813 {
  /** 가격 정보 */
  price: Record<string, any>;
  /** 주문 상품 옵션 */
  orderProductOptions: any[];
}

export interface order-sheets-427257668 {
  /** 상품 쿠폰 (nullable) */
  productCoupons?: any[];
  /** 쇼핑채널링-추적키^|10a00a00-a00a-00a0-a000-000000aa0000 */
  trackingKey?: string;
  /** 장바구니 번호 리스트 (장바구니 통해서 구매한 경우 - 구매 완료 시 해당 장바구니를 삭제합니다.) (nullable)^|[1, 2, 3] */
  cartNos?: any[];
  /** 쇼핑채널링-채널타입 (nullable)^|NAVER_EP */
  channelType?: string;
  /** 상품 정보 */
  products: any[];
}

export interface order-sheets-orderSheetNo-coupons-apply-861210721 {
  /** 합배송 그룹별 상품 목록 */
  deliveryGroups: any[];
  /** 적용된 쿠폰 */
  appliedCoupons: Record<string, any>;
  /** 사용가능한 결제정보 <br /> 쇼핑몰에서 다양한 PG사와 계약해서 결제수단을 제공할 수 있기 때문에, payType을 기준으로 pgTypes를 내려주고 있으니 프론트에서 구현 시 내려온 pgTypes에 따라 결제모듈을 제공할 수 있습니다. */
  availablePayTypes: any[];
  freeGiftInfos?: any[];
  /** 해외결제 결제정보 (nullable) */
  internationalPaymentInfo?: Record<string, any>;
  /** 결제정보 */
  paymentInfo: Record<string, any>;
}

export interface guest-orders-orderNo-deliveries-1049392314 {
  /** (해외배송 / 글로벌결제 시 필수) 수령인 LastName (nullable) */
  receiverLastName?: string;
  /** 지번주소(대한민국 주소의 경우는 필수 값) (nullable) */
  receiverJibunAddress?: string;
  /** 수령자명 */
  receiverName: string;
  /** 개인통관고유부호 (nullable) */
  customsIdNumber?: string;
  /** 국가코드(default:mall의 국가코드) (nullable) */
  countryCd?: string;
  /** 우편번호 */
  receiverZipCd: string;
  /** 상세주소 */
  receiverDetailAddress: string;
  /** 배송메모 (nullable) */
  deliveryMemo?: string;
  /** (해외) 도시 (nullable) */
  receiverCity?: string;
  /** 연락처 국가코드 (nullable) */
  receiverMobileCountryCd?: string;
  /** 주소 */
  receiverAddress: string;
  /** (해외) 주 (nullable) */
  receiverState?: string;
  /** (해외배송 / 글로벌결제 시 필수) 수령인 FirstName (nullable) */
  receiverFirstName?: string;
  /** 수령자연락처1 */
  receiverContact1: string;
  /** 수령자연락처2 (nullable) */
  receiverContact2?: string;
}

export interface profile-orders-orderNo-payment-receipt-url-1184129186 {
  /** url^|receipt-url */
  url: string;
}

export interface recurring-payments-gifts-1116559547 {
  /** 정기결제 번호 리스트^|[recurring-12345] */
  recurringPaymentIds: any[];
  /** 변경하려는 정기결제 사은품 옵션 리스트^|[1, 2, 3] */
  freeGiftOptionNos: any[];
}

export interface profile-orders-summary-amount1819825472 {
  /** 최종 결제 금액 */
  lastPayAmt: number;
  /** 최종 배송 금액 */
  lastDeliveryAmt: number;
  /** 최종 보조 결제 금액 */
  lastSubPayAmt: number;
  /** 최종 지역별 추가 배송 금액 */
  lastRemoteDeliveryAmt: number;
  /** 최종 추가 할인 금액 */
  lastAdditionalDiscountAmt: number;
  /** 주문 수량 */
  orderCnt: number;
  /** 최종 즉시 할인 금액 */
  lastImmediateDiscountAmt: number;
  /** 최종 배송 쿠폰 할인 금액 */
  lastDeliveryCouponDiscountAmt: number;
  /** 최종 상품 금액 (할인 제외) */
  lastStandardAmt: number;
  /** 최종 상품 쿠폰 할인 금액 */
  lastProductCouponDiscountAmt: number;
  /** 최종 주문 쿠폰 할인 금액 */
  lastCartCouponDiscountAmt: number;
}

export interface recurring-payments-order-sheets-orderSheetNo1239120353 {
  rentalInfos?: any[];
  /** 합배송 그룹별 상품 목록 */
  deliveryGroups: any[];
  /** 개인정보 사용 파트너 */
  sellerPrivacyUsagePartners: any[];
  /** 적용된 쿠폰 (nullable) */
  appliedCoupons?: Record<string, any>;
  /** 사용가능한 결제정보 <br /> 쇼핑몰에서 다양한 PG사와 계약해서 결제수단을 제공할 수 있기 때문에, payType을 기준으로 pgTypes를 내려주고 있으니 프론트에서 구현 시 내려온 pgTypes에 따라 결제모듈을 제공할 수 있습니다. */
  availablePayTypes: any[];
  /** 거래은행 정보 */
  tradeBankAccountInfos: any[];
  /** 유효하지 않은 상품 (nullable) */
  invalidProducts?: any[];
  freeGiftInfos?: any[];
  /** 주문자 연락처 (nullable) */
  ordererContact?: Record<string, any>;
  /** 쿠폰, 적립금 동시 사용 차단 여부^|false */
  blockUseAccumulationWhenUseCoupon: boolean;
  /** 필수동의항목^|TERMS_OF_USE */
  agreementTypes: any[];
  /** 개인통관고유부호필요여부 (true: 필요, false: 불필요)^|false */
  requireCustomsIdNumber: boolean;
  /** 배송 불가능한 국가 목록 (ISO 3166-1 alpha-2)^|[KR, CN, JP] */
  undeliverableCountries: any[];
  /** 최근사용한 결제수단^|CREDIT_CARD */
  lastPayType?: string;
  /** 프로모션 정보 요약 (nullable) */
  orderSheetPromotionSummary?: Record<string, any>;
  /** 무통장입금 거래 시 현금영수증 사용 여부 (true: 사용, false: 미사용)^|false */
  applyCashReceiptForAccount: boolean;
  /** 필수 약관 동의 항목 리스트 */
  termsInfos: any[];
  /** 외부결제수단정보 (nullable) */
  externalPaymentInfos?: any[];
  /** 추가 약관 동의 항목 리스트 */
  customTermsInfos: any[];
  myPayInfo?: Record<string, any>;
  /** 해외결제 결제정보 (nullable) */
  internationalPaymentInfo?: Record<string, any>;
  /** 배송지 */
  orderSheetAddress: Record<string, any>;
  /** 결제정보 */
  paymentInfo: Record<string, any>;
  /** 해외 파트너 */
  foreignPartners: any[];
}

export interface recurring-payments-status-2092976123 {
  /** 정기결제 신청번호 리스트 (bulk api에 사용) (nullable)^|[recurring-12345, recurring-67890] */
  recurringPaymentIds?: any[];
  /** 정기결제 신청번호^|ACTIVE */
  changeStatusType: string;
}

export interface order-sheets-orderSheetNo-coupons-calculate515259533 {
  /** 상품 쿠폰 */
  productCoupons: any[];
  /** 장바구니 쿠폰 발행 번호^|12121212 */
  cartCouponIssueNo: number;
  /** 쿠폰 할인 코드^|1258932 */
  promotionCode: string;
  /** 쇼핑채널링-채널타입 (nullable)^|NAVER_EP */
  channelType?: string;
}

export interface profile-shipping-addresses-addressNo-1926931355 {
  /** (해외배송 / 글로벌결제 시 필수)  수령인 LastName (nullable)^|null */
  receiverLastName?: string;
  /** 배송지 지번 (nullable)^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress?: string;
  /** 기본 배송지 여부^|Y */
  defaultYn: string;
  /** 수령자 명^|홍길동 */
  receiverName: string;
  /** 배송지타입^|RECENT */
  addressType: string;
  /** 개인고유통관부호 (nullable)^|P12341234 */
  customsIdNumber?: string;
  /** 국가코드 (nullable)^|KR */
  countryCd?: string;
  /** 배송지 우편 번호^|13487 */
  receiverZipCd: string;
  /** 배송지 메모 (nullable)^|공동 현관 비밀번호: 1234 */
  addressMemo?: string;
  /** 배송지 상세 주소 (nullable)^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress?: string;
  /** (해외) 도시 (nullable)^|null */
  receiverCity?: string;
  /** [개발중] 연락처 국가코드 (nullable)^|null */
  receiverMobileCountryCd?: string;
  /** 배송지 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** (해외) 주 (nullable)^|null */
  receiverState?: string;
  /** 주소록명 (nullable)^|홍길동집 */
  addressName?: string;
  /** (해외배송 / 글로벌결제 시 필수)  수령인 FirstName (nullable)^|null */
  receiverFirstName?: string;
  /** 연락처1^|010-0000-0000 */
  receiverContact1: string;
  /** 연락처2 (nullable)^|010-0000-0000 */
  receiverContact2?: string;
}

export interface recurring-payments1187310464 {
  /** 주문자 이메일^|gildong.hong@nhn.com */
  ordererEmail: string;
  /** 필수 약관 동의 항목 리스트 */
  agreementTermsAgrees?: any[];
  /** 주문서번호^|123123 */
  orderSheetNo: string;
  /** 선물 수령자 정보 */
  receiverInfoForPresent?: Record<string, any>;
  /** 정기결제 사은품 정보 */
  freeGifts?: any[];
  /** 주소 번호^|1 */
  addressNo: number;
  /** 추가 약관 동의 항목 번호 리스트 */
  customTermsAgrees?: any[];
  /** 메인 카드로 사용할 카드번호 (nullable)^|1 */
  cardNo?: number;
  /** 결제 금액 (주문서 금액과 실제 결제 금액이 맞는지 검증에 사용됨) (nullable)^|10000 */
  paymentAmount?: number;
}

export interface recurring-payments-cart-calculate582355184 {
  /** 구매금액 합^|0 */
  buyAmt: number;
  /** 할인금액^|0 */
  discountAmt: number;
  /** 총 구매금액 합(구매금액 합 + 총 선불배송비 합)^|0 */
  totalAmt: number;
  /** 구매확정 시 적립금 합^|0 */
  accumulationAmtWhenBuyConfirm: number;
  /** 추가할인금액의 합^|0 */
  totalAdditionalDiscountAmt: number;
  /** 정상금액(상품판매가 + 옵션추가금액) * 주문수량^|0 */
  standardAmt: number;
  /** 총 착불배송비 합^|0 */
  totalPayOnDeliveryAmt: number;
  /** 총 배송비 합^|0 */
  totalDeliveryAmt: number;
  /** 총 선불배송비 합^|0 */
  totalPrePaidDeliveryAmt: number;
}

export interface recurring-payments-close-959177316 {
  /** 정기결제 해지 사유 */
  closeReasonType: string;
  /** 정기결제 신청번호 리스트 (bulk api에 사용) (nullable)^|[202101011230001, 202101011230002] */
  recurringPaymentIds?: any[];
  /** 해지 사유(closeReasonType.etc 일 경우만) (nullable)^|너무 비싸요 */
  closeReason?: string;
}

export interface profile-orders-orderNo-simple-receipt2055349963 {
  /** 거래 명세서 주문 옵션 */
  orderOptions: any[];
  /** 주문 번호^|1234567890 */
  orderNo: string;
  /** 사업(서비스 어드민) */
  business: Record<string, any>;
  /** 배송비 쿠폰 할인금액^|6000 */
  deliveryCouponDiscountAmt: number;
  /** 회사명(서비스 어드민)^|company-name */
  companyName: string;
  /** 지역별 배송비^|2000 */
  remoteDeliveryAmt: number;
  /** 장바구니 쿠폰 할인금액^|5000 */
  cartCouponDiscountAmt: number;
  /** 사무실(서비스 어드민) */
  office: Record<string, any>;
  /** 추가 할인금액^|3000 */
  additionalDiscountAmt: number;
  /** 주문일자^|2025-04-02 */
  orderYmd: string;
  /** 배송비^|1000 */
  deliveryAmt: number;
  /** 적립금^|7000 */
  subPayAmt: number;
  /** 상품 쿠폰 할인금액^|4000 */
  productCouponDiscountAmt: number;
  /** 쇼핑몰 번호^|1 */
  mallNo: number;
  /** 주문자 명 (nullable)^|orderer-name */
  ordererName?: string;
  /** 대표(서비스 어드민) */
  representative: Record<string, any>;
  /** 외부 결제 수단 */
  externalPayInfo: any[];
}

export interface my-pay-register-payment-1933099637 {
  /** 암호화된 이니시스에서 발행한 SEED wpayUserKey^|82fGOwir8hlYR2aboH/vkw== */
  wpayUserKey: string;
  /** 검증 hash 값^|b687a5dd63a49d713e08e98fe1008493860bcfeaa80da362e01e25410279f1cf */
  signature: string;
  /** webUI url^|https://webUI.com */
  webUrl: string;
  /** 가맹점 ID^|INIwpayT03 */
  mid: string;
  /** 결과전달 URL^|https://callback.com */
  returnUrl: string;
}

export interface guest-orders-orderNo-cashReceipt1367785163 {
  /** 현금영수증 발급 키 타입^|MOBILE_NO */
  cashReceiptKeyType: string;
  /** 발급용도에 따른 키 (휴대폰번호, 사업자번호 등)^|01012345678 */
  cashReceiptKey: string;
  /** 현금영수증 발급 타입^|INCOME_TAX_DEDUCTION */
  cashReceiptIssuePurposeType: string;
}

export interface guest-cart294369222 {
  /** 배송 그룹 */
  deliveryGroups: any[];
  /** 가격 정보 */
  price?: Record<string, any>;
  /** 유효하지 앟은 상품 */
  invalidProducts: any[];
}

export interface later-input-shippings-178575596 {
  /** (해외배송 / 글로벌결제 시 필수) 수령인 LastName (nullable)^|null */
  receiverLastName?: string;
  /** 배송지 지번(지역 추가 배송비 계산시 사용)^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress: string;
  /** 수령자 명^|홀길동 */
  receiverName: string;
  /** 국가 코드 (nullable)^|KR */
  countryCd?: string;
  /** 배송지 우편 번호^|13487 */
  receiverZipCd: string;
  /** 배송지 상세 주소^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress: string;
  /** 문앞에 놓아주세요. (nullable)^|13487 */
  deliveryMemo?: string;
  /** (해외) 도시 (nullable)^|null */
  receiverCity?: string;
  /** [개발중] 연락처 국가코드 (nullable)^|null */
  receiverMobileCountryCd?: string;
  /** 배송지 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** (해외) 주 (nullable)^|null */
  receiverState?: string;
  /** (해외배송 / 글로벌결제 시 필수) 수령인 FirstName (nullable)^|null */
  receiverFirstName?: string;
  /** 연락처1^|010-0000-0000 */
  receiverContact1: string;
}

export interface recurring-payments-cart-492699406 {
}

export interface my-pay-modify-main-payment2136326669 {
  /** 이니시스에서 발행한 SEED wpaytoken^|LL3E994QcmzSFH0JCiZOFw== */
  payToken: string;
}

export interface recurring-payments-cart-368867490 {
}

export interface previous-orders1159530623 {
  contents?: any[];
  /** 전체 주문수^|10 */
  totalCount: number;
}

export interface recurring-payments-skip-next2090175478 {
  /** 정기결제 신청번호 리스트^|[recurring-12345, recurring-67890] */
  recurringPaymentIds: any[];
}

export interface cart-validate-1611636330 {
  /** 구매 가능 여부^|false */
  result: boolean;
}

export interface my-pay-register-user-with-payment652620695 {
  /** 고객 실명 */
  userNm: string;
  /** 암호화된 생년월일 (YYYYMMDD) */
  birthDay: string;
  /** 검증 hash 값^|b687a5dd63a49d713e08e98fe1008493860bcfeaa80da362e01e25410279f1cf */
  signature: string;
  /** 가맹점 id^|INIwpayT03 */
  mid: string;
  /** 휴대폰통신사 */
  hCorp: string;
  /** 암호화된 가맹점 유저 id^|rw8yiQE00dA5Bzi4J+GVDg== */
  userId: string;
  /** 외국인여부 */
  frnrYn: string;
  /** 암호화된 고객 휴대폰번호 */
  hNum: string;
  /** webUI url^|https://webUI.com */
  webUrl: string;
  /** 약관에 노출할 url^|https://agreeUrl.com */
  agreeUrl: string;
  /** 주민번호 뒤 첫자리 */
  socialNo2: string;
  /** 결과전달 URL^|https://callbackUrl.com */
  returnUrl: string;
  /** 약관에 노출할 페이명^|마이페이 */
  agreePayNm: string;
}

export interface previous-orders-guest-orderNo144029665 {
  firstPayment?: Record<string, any>;
  /** 수령자 정보 */
  receiver: any[];
  /** 적립혜택^|12340 */
  accumulationAmt: number;
  orderer?: Record<string, any>;
  paymentMethod?: Record<string, any>;
  lastPayment?: Record<string, any>;
  /** 주문상품 정보 */
  orderProduct: any[];
  /** 몰 번호 */
  mallNo: number;
  /** 비회원 주문 토큰^|12345 */
  guestToken?: string;
  refund?: Record<string, any>;
}

export interface recurring-payments-recurringPaymentGroupNo-guest642354480 {
  /** 비밀번호^|1234 */
  password: string;
  /** 이름^|홍길동 */
  name: string;
}

export interface recurring-payments-cards469961343 {
}

export interface app-card-cards1239894424 {
  /** 간편결제 카드 리스트 */
  cards: any[];
}

export interface shippings-encryptedShippingNo-later-input1227388841 {
  /** 배송지 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** 배송지 지번(지역 추가 배송비 계산시 사용)^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress: string;
  /** 수령자 명^|홍길동 */
  receiverName: string;
  /** 배송지 우편 번호^|13487 */
  receiverZipCd: string;
  /** 파트너 번호 리스트^|[1, 2, 3] */
  partnerNos: any[];
  /** 배송지 입력 완료 여부^|true */
  laterInputCompleted: boolean;
  /** 배송지 상세 주소^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress: string;
  /** 배송 메모^|문앞에 놓아주세요. */
  deliveryMemo: string;
  /** 쇼핑몰 번호^|1 */
  mallNo: number;
  /** 연락처1 (nullable)^|010-0000-0000 */
  receiverContact1?: string;
  /** 배송 번호 리스트^|[1, 2, 3] */
  deliveryNos: any[];
}

export interface guest-orders-orderNo-cashReceipt-75229945 {
  /** 현금영수증 발급 키 타입 (nullable)^|MOBILE_NO */
  cashReceiptKeyType?: string;
  /** 발급용도에 따른 키 (휴대폰번호, 사업자번호 등) (nullable)^|01012345678 */
  cashReceiptKey?: string;
  /** 현금영수증 발급 타입 (nullable)^|INCOME_TAX_DEDUCTION */
  cashReceiptIssuePurposeType?: string;
}

export interface order-sheets-orderSheetNo-coupons-calculate-13651290 {
  /** 주문서번호^|202001012000000009 */
  orderSheetNo: string;
  /** buyAmt[장바구니 금액] = totalStandardAmt[최종상품금액] - totalImmediateDiscountAmt[즉시할인가] - totalAdditionalDiscountAmt[추가할인가] - productCouponAmt[상품쿠폰할인금액]^|2500 */
  cartAmt: number;
  /** 배송비^|2500 */
  deliveryAmt: number;
  /** 장바구니쿠폰할인금액^|0 */
  cartCouponDiscountAmt: number;
  /** 장바구니 쿠폰 */
  cartCoupons: any[];
  /** 상품쿠폰할인금액^|0 */
  productCouponDiscountAmt: number;
  /** 상품 정보 */
  products: any[];
}

export interface order-sheets-orderSheetNo-calculate177283610 {
  /** 주소 */
  addressRequest: Record<string, any>;
  /** 쿠폰 */
  couponRequest: Record<string, any>;
  /** 적립금 사용액^|0 */
  accumulationUseAmt: number;
  /** 복수 배송지 정보 */
  shippingAddresses: any[];
  /** 외부결제수단정보 (nullable) */
  externalPayInfos?: any[];
}

export interface recurring-payments-card-priority-1985403867 {
}

export interface later-input-areafees-166625636 {
}

export interface cart1293580171 {
}

export interface payments-naver-validate1564577237 {
  /** 검증 결과^|true */
  result: boolean;
}

export interface recurring-payments-recurringPaymentGroupNo-guest697768705 {
  /** 배송지 정보 */
  deliveryInfo: Record<string, any>;
  /** 주문 리스트 */
  orders: any[];
  /** 정기결제 리스트 */
  recurringPayments: any[];
  /** 주문자 이름^|홍길동 */
  ordererName: string;
  /** 정기결제 그룹번호^|1 */
  recurringPaymentGroupNo: string;
  /** 정기결제 그룹 신청 일자^|2025-01-01 */
  registerDate: string;
}

export interface profile-shipping-addresses17931654 {
  /** 최근 배송지 */
  recentAddresses?: any[];
  /** 정기결제배송지(샵바이 엔터프라이즈 전용) */
  recurringPaymentAddresses?: any[];
  /** 저장된 배송지 */
  bookedAddresses?: any[];
  /** 기본 배송지 */
  defaultAddress?: Record<string, any>;
}

export interface unidentifiedDepositors1881331843 {
  /** 미확인 입금자 목록 */
  contents: any[];
  /** 100 */
  totalCount: number;
}

export interface my-pay-modify-password1447810286 {
  /** 암호화된 이니시스에서 발행한 SEED wpayUserKey^|82fGOwir8hlYR2aboH/vkw== */
  wpayUserKey: string;
  /** 검증 hash 값 (nullable)^|b687a5dd63a49d713e08e98fe1008493860bcfeaa80da362e01e25410279f1cf */
  signature?: string;
  /** webUI url^|https://webUI.com */
  webUrl: string;
  /** 가맹점 ID^|INIwpayT03 */
  mid: string;
  /** 결과전달 URL^|https://callback.com */
  returnUrl: string;
}

export interface profile-shipping-addresses1962426718 {
  /** (해외배송 / 글로벌결제 시 필수)  수령인 LastName (nullable)^|null */
  receiverLastName?: string;
  /** 배송지 지번^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress: string;
  /** 기본 배송지 여부^|Y */
  defaultYn: string;
  /** 수령자 명^|홍길동 */
  receiverName: string;
  /** 배송지타입^|RECENT */
  addressType: string;
  /** 개인고유통관부호 (nullable)^|P12341234 */
  customsIdNumber?: string;
  /** 국가코드 (nullable)^|KR */
  countryCd?: string;
  /** 배송지 우편 번호^|13487 */
  receiverZipCd: string;
  /** 배송지 메모 (nullable)^|공동 현관 비밀번호: 1234 */
  addressMemo?: string;
  /** 배송지 상세 주소^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress: string;
  /** (해외) 도시 (nullable)^|null */
  receiverCity?: string;
  /** [개발중] 연락처 국가코드 (nullable)^|null */
  receiverMobileCountryCd?: string;
  /** 배송지 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** (해외) 주 (nullable)^|null */
  receiverState?: string;
  /** 주소록명 (nullable)^|홍길동집 */
  addressName?: string;
  /** (해외배송 / 글로벌결제 시 필수)  수령인 FirstName (nullable)^|null */
  receiverFirstName?: string;
  /** 연락처1^|010-0000-0000 */
  receiverContact1: string;
  /** 연락처2 (nullable)^|010-0000-0000 */
  receiverContact2?: string;
}

export interface profile-shipping-addresses-recent628548828 {
}

export interface later-input-shippings-1860205388 {
  /** 배송지 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** 배송지 지번(지역 추가 배송비 계산시 사용)^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress: string;
  /** 수령자 명^|홍길동 */
  receiverName: string;
  /** 배송지 우편 번호^|13487 */
  receiverZipCd: string;
  /** 파트너 번호 리스트^|[1, 2, 3] */
  partnerNos: any[];
  /** 배송지 입력 완료 여부^|true */
  laterInputCompleted: boolean;
  /** 배송지 상세 주소^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress: string;
  /** 배송 메모^|문앞에 놓아주세요. */
  deliveryMemo: string;
  /** 몰 번호^|1 */
  mallNo: number;
  /** 연락처1 (nullable)^|010-0000-0000 */
  receiverContact1?: string;
  /** 배송 번호 리스트^|[1, 2, 3] */
  deliveryNos: any[];
}

export interface cart-1115878954 {
}

export interface order-sheets-orderSheetNo-coupons-maximum568526927 {
  /** 외부 주문 유입 경로 (nullable)^|PAYCO_MALL */
  channelType?: string;
}

export interface guest-cart337708942 {
}

export interface profile-orders-orderNo-specifications1346496753 {
  /** 거래 명세서 주문 옵션 */
  orderOptions: any[];
  /** 배송 요청 일자 (nullable)^|03.26(수) */
  requestShippingDate?: string;
  /** 주문 번호^|1234567890 */
  orderNo: string;
  /** 사업 */
  business: Record<string, any>;
  /** 배송비 쿠폰 할인금액 (field: DISCOUNT_AMT) (nullable)^|6000 */
  deliveryCouponDiscountAmt?: number;
  /** 회사명^|company-name */
  companyName: string;
  /** 배송비 (field: DELIVERY_AMT) (nullable)^|2000 */
  remoteDeliveryAmt?: number;
  /** 장바구니 쿠폰 할인금액 (field: DISCOUNT_AMT) (nullable)^|5000 */
  cartCouponDiscountAmt?: number;
  /** 사무실 */
  office: Record<string, any>;
  /** 주문 메모 (nullable)^|order-memo */
  orderMemo?: string;
  /** 수령자 주소 */
  receiverAddress: Record<string, any>;
  /** 추가 할인금액 (field: DISCOUNT_AMT) (nullable)^|3000 */
  additionalDiscountAmt?: number;
  /** 배송비 (field: DELIVERY_AMT) (nullable)^|1000 */
  deliveryAmt?: number;
  /** 배송 메모 (nullable)^|shipping-memo */
  shippingMemo?: string;
  /** 배송 번호^|2 */
  shippingNo: number;
  /** 적립금 (field: SUB_PAY_AMT) (nullable)^|7000 */
  subPayAmt?: number;
  /** 상품 쿠폰 할인금액 (field: DISCOUNT_AMT) (nullable)^|4000 */
  productCouponDiscountAmt?: number;
  /** 쇼핑몰 번호^|1 */
  mallNo: number;
  /** 주문자 명 (nullable)^|orderer-name */
  ordererName?: string;
  /** 대표 */
  representative: Record<string, any>;
  /** 외부 결제 수단 (field: EXTERNAL_PAY_INFO) */
  externalPayInfo: any[];
}

export interface unidentifiedDepositors-config-891844508 {
  /** 입금 금액 숨김^|false */
  depositAmtDisplay: boolean;
  /** pc웹 미확인 입금자 디자인 설정 - 팝업 상단 배너^|DEFAULT */
  pcDesignPopupTopBanner: string;
  /** 리스트 노출 기간^|3 */
  listDisplayPeriod: number;
  /** 입금 은행 숨김^|false */
  depositBankDisplay: boolean;
  /** 모바일웹 미확인 입금자 디자인 설정 - 메인 배너^|DEFAULT */
  mobileDesignMainBanner: string;
  /** 연동 제한금액^|0 */
  limitDisplayDepositAmt: number;
  /** pc웹 미확인 입금자 디자인 설정 - 메인 배너 이미지 url (nullable)^|http://image.com/abc */
  pcDesignMainBannerImageUrl?: string;
  /** 배너 노출 설정^|NONE */
  bannerDisplayType: string;
  /** 모바일웹 미확인 입금자 디자인 설정 - 메인 배너 이미지 url (nullable)^|http://image.com/abc */
  mobileDesignMainBannerImageUrl?: string;
  /** 무통장 자동입금확인 서비스 연동^|false */
  bankdaUse: boolean;
  /** 모바일웹 미확인 입금자 디자인 설정 - 팝업 상단 배너^|DEFAULT */
  mobileDesignPopupTopBanner: string;
  /** pc웹 미확인 입금자 디자인 설정 - 팝업 상단 배너 이미지 url (nullable)^|http://image.com/abc */
  pcDesignPopupTopBannerImageUrl?: string;
  /** 모바일웹 미확인 입금자 디자인 설정 - 팝업 상단 배너 이미지 url (nullable)^|http://image.com/abc */
  mobileDesignPopupTopBannerImageUrl?: string;
  /** pc웹 미확인 입금자 디자인 설정 - 메인 배너^|DEFAULT */
  pcDesignMainBanner: string;
}

export interface recurring-payments-1747912347 {
  /** 구매금액 (배송비 별도 standardAmt - discountAmt) (nullable)^|10000 */
  buyAmt?: number;
  /** 수령자 지번주소 (nullable)^|645-16 */
  receiverJibunAddress?: string;
  /** 할인금액 (nullable)^|5000 */
  discountAmt?: number;
  /** 카드명 (nullable)^|신한카드 */
  cardName?: string;
  /** 수령자 휴대폰번호 (nullable)^|010-1234-1234 */
  receiverContact?: string;
  /** 수령자 이름 (nullable)^|홍길동 */
  receiverName?: string;
  /** 수령자 상세주소 (nullable)^|커머스개발실 */
  receiverDetailAddress?: string;
  /** 정기 결제 카드 번호^|1 */
  cardNo: number;
  /** 상품정보^|{} */
  products: any[];
  /** 수령자 주소 (nullable)^|성남시 분당구 대왕판교로 */
  receiverAddress?: string;
  /** 배송비 (nullable)^|2500 */
  deliveryAmt?: number;
  /** 할인 전 금액 (nullable)^|15000 */
  standardAmt?: number;
  /** 장바구니 리스트 (nullable)^|[1, 2, 3] */
  cartNos?: any[];
  /** 주문자 이름 (nullable)^|홍길동 */
  ordererName?: string;
  /** 카드 마지막 4자리 (nullable)^|1234 */
  cardEndDigit?: string;
}

export interface recurring-payments-later-input-shippings-127236649 {
  /** (해외배송 시 필수) 수령인 LastName */
  receiverLastName: string;
  /** 수령자 이름^|홍길동 */
  receiverName: string;
  /** 약관 정보 */
  termsInfos: any[];
  /** (해외배송 시 필수) 수령인 FirstName */
  receiverFirstName: string;
  /** 정기결제 리스트 */
  recurringPayments: any[];
  /** 주문자 이름 */
  ordererName: string;
  /** 수령자 연락처^|01000000000 */
  receiverContact1: string;
  /** 정기결제 그룹번호^|1 */
  recurringPaymentGroupNo: string;
  /** 정기결제 신청 일자^|2025-01-01 00:00:00 */
  registerYmdt: string;
}

export interface recurring-payments-next-recurring-date1385951321 {
  /** 정기결제 일자 (nullable)^|1 */
  date?: number;
  /** 정기결제 타입 (nullable)^|MONTH */
  cycleType?: string;
  /** 정기결제 요일 (nullable)^|MONDAY */
  dayOfWeek?: string;
  /** 다다음 정기결제 일자^|YYYY-MM-DD */
  afterNextRecurringDate: string;
  /** 정기결제 신청번호^|202108251705594 */
  recurringPaymentId: string;
  /** 정기결제 상태^|ACTIVE */
  recurringPaymentStatus?: string;
  /** 다음 정기결제 일자 (nullable)^|YYYY-MM-DD */
  nextRecurringDate?: string;
  /** 정기결제 주기 (nullable)^|1 */
  cycle?: number;
}

export interface recurring-payments-order-sheets-371931376 {
  /** 상품 쿠폰 (nullable) */
  productCoupons?: any[];
  /** 쇼핑채널링-추적키^|10a00a00-a00a-00a0-a000-000000aa0000 */
  trackingKey?: string;
  /** 정기결제 선물하기 여부 (nullable)^|false */
  isPresent?: boolean;
  /** 장바구니 번호 리스트 (장바구니 통해서 구매한 경우 - 구매 완료 시 해당 장바구니를 삭제합니다.) (nullable)^|[1, 2, 3] */
  cartNos?: any[];
  /** 쇼핑채널링-채널타입 (nullable)^|NAVER_EP */
  channelType?: string;
  /** 상품 정보 */
  products: any[];
}

export interface order-sheets-orderSheetNo-coupons-apply666167410 {
  /** 상품 쿠폰 (nullable) */
  productCoupons?: any[];
  /** 장바구니 쿠폰 발행 번호^|12121212 */
  cartCouponIssueNo: number;
  /** 쿠폰 할인 코드^|1258932 */
  promotionCode: string;
  /** 쇼핑채널링-채널타입 (nullable)^|NAVER_EP */
  channelType?: string;
}

export interface payments-reserve-2101669004 {
  /** 결제완료 API 호출 후 다시 전달 받을 값(NCPPay script에서 넣음) (nullable)^|{"mallNo" : "1", "orderName" : "주문테스트"} */
  clientParams?: Record<string, any>;
  /** 추가 정보<br />(ex : Stripe결제수단의 경우 카드 정보 or 저장된 카드의 cardId) (nullable)^|{'cardNumber':4242424242424242, 'cardExpMonth':12, 'cardExpYear':'2020', 'cardCvc':'123', 'saveYn':'Y'} or {'cardId':'card_12354123124'} */
  extraData?: Record<string, any>;
  /** 배송정보에 회원정보 사용 여부 (nullable)^|false */
  useMemberInfo?: boolean;
  /** 추가 약관 동의 항목 번호 리스트 */
  customTermsAgrees?: any[];
  /** 필수 약관 동의 항목 리스트(deprecated: agreementTermsAgrees 사용) */
  agreementTypes?: string;
  /** 주문메모 (nullable)^|빠른 배송 부탁 드립니다. */
  orderMemo?: string;
  /** 앱카드 정보 */
  appCardInfo?: Record<string, any>;
  /** 무통장 입금 정보 */
  bankAccountToDeposit?: Record<string, any>;
  /** 렌탈 상품 정보 */
  rentalInfo?: Record<string, any>;
  /** 결제수단^|CREDIT_CARD */
  payType: string;
  /** 결제 완료 후 리턴되는 쇼핑몰의 URL<br />URL 의 파라미터중<br />result=SUCCESS 인 경우 : 성공 페이지 구현 (orderNo 파라미터로 주문정보 출력가능)<br />result=FAIL 인 경우 : message 값을 화면이나 경고창으로 출력함^|http://쇼핑몰 URL/return.html */
  clientReturnUrl: string;
  /** 쿠폰 */
  coupons?: Record<string, any>;
  /** 기본 주소지 설정 여부 (true: 선택한 배송지 정보가 기본주소지로 설정, false: 미설정) (nullable)^|true */
  useDefaultAddress?: boolean;
  /** 회원 여부^|true */
  member: boolean;
  /** 앱내 결제 여부, Y인 경우 extraData.appUrl에 결제완료 후 돌아갈 app scheme을 넣어야 함 (nullable)^|Y */
  inAppYn?: string;
  /** 무통장 거래 시 현금영수증 발행 신청 여부(true: 신청, false: 미신청) (nullable)^|false */
  applyCashReceipt?: boolean;
  /** PG 명세서에 표시될 주문명 - null일 경우 [첫번째상품명 외 2건]으로 기본 생성됩니다. (nullable)^|테스트상품 외 2건 */
  orderTitle?: string;
  /** 임시주문비밀번호(비회원인경우 필수) (nullable)^|1212 */
  tempPassword?: string;
  /** 주소록에 등록 여부 <br />(true 이면 선택한 배송지 정보가 주소록에 저장된다. <br />이미 저장된 주소록을 선택하여 주소를 수정했다면, <br />변경한 주소로 수정되어 저장한다)^|true */
  saveAddressBook: boolean;
  /** true 인 경우 주문자 정보로 회원의 정보를 수정함. 몰설정에서 회원의 점유인증을 하지 않는 경우에만 update 된다.^|false */
  updateMember: boolean;
  /** 주문서번호^|202001012000000009 */
  orderSheetNo: string;
  /** 외부 PG사^|KCP */
  pgType: string;
  /** 무통장 입금 시 입금할 입금자 이름 (nullable)^|홍길동 */
  remitter?: string;
  /** 선택한 사은품 정보 (사은품 선택이 가능한 경우 사용) */
  freeGiftInfos?: any[];
  /** 옵션별 사용가능 적립금 정보 */
  availableAccumulationByOptions?: any[];
  /** 배송메모 (nullable)^|문앞에 놔주세요 */
  deliveryMemo?: string;
  /** 필수 약관 동의 항목 리스트 */
  agreementTermsAgrees?: any[];
  /** 주문자 정보 */
  orderer: Record<string, any>;
  /** 검증을위한 결제예정금액(적립금사용후) */
  paymentAmtForVerification?: number;
  /** 배송지 정보 */
  shippingAddress?: Record<string, any>;
  /** 선택한 결제수단 사용여부(true: 사용, false: 미사용) (nullable)^|false */
  savesLastPayType?: boolean;
  /** 마이페이 결제인증 정보 (nullable) */
  myPayInfo?: Record<string, any>;
  /** 보조결제 수단 결제액(적립금 사용액)^|0 */
  subPayAmt: number;
  /** 현금영수증 신청정보 */
  cashReceipt?: Record<string, any>;
  /** 복수 배송지 */
  shippingAddresses?: any[];
}

export interface profile-orders-2018894727 {
  /** 총 수량^|12 */
  totalCount: number;
  /** 주문 내역 */
  items: any[];
}

export interface cart-coupons-maximum-283799103 {
  /** 최적 상품쿠폰 정보 */
  productCoupons: any[];
  /** 전체 할인 금액 */
  totalDiscountAmt: number;
  /** 최적 장바구니쿠폰 정보 */
  cartCoupons: any[];
}

export interface profile-orders-orderNo-deliveries-761195399 {
  /** (해외배송 / 글로벌결제 시 필수) 수령인 LastName (nullable) */
  receiverLastName?: string;
  /** 지번주소(대한민국 주소의 경우는 필수 값) (nullable) */
  receiverJibunAddress?: string;
  /** 수령자명 */
  receiverName: string;
  /** 개인통관고유부호 (nullable) */
  customsIdNumber?: string;
  /** 국가코드(default:mall의 국가코드) (nullable) */
  countryCd?: string;
  /** 우편번호 */
  receiverZipCd: string;
  /** 상세주소 */
  receiverDetailAddress: string;
  /** 배송메모 (nullable) */
  deliveryMemo?: string;
  /** (해외) 도시 (nullable) */
  receiverCity?: string;
  /** 연락처 국가코드 (nullable) */
  receiverMobileCountryCd?: string;
  /** 주소 */
  receiverAddress: string;
  /** (해외) 주 (nullable) */
  receiverState?: string;
  /** (해외배송 / 글로벌결제 시 필수) 수령인 FirstName (nullable) */
  receiverFirstName?: string;
  /** 수령자연락처1 */
  receiverContact1: string;
  /** 수령자연락처2 (nullable) */
  receiverContact2?: string;
}

export interface recurring-payments-recurringPaymentId-info-768688394 {
  product?: Record<string, any>;
  /** 배송지 번호^|1 */
  addressNo: number;
  cycle?: Record<string, any>;
  /** 카드 번호^|1 */
  cardNo: number;
  /** 정기결제 종료 회차 (nullable)^|1 */
  lastRound?: number;
}

export interface recurring-payments-card607762147 {
  /** 생년월일^|960101 */
  birthday: string;
  expiryDate?: Record<string, any>;
  /** 카드 비밀번호 앞 2자리^|00 */
  password: string;
  /** PG 구분^|KSNET */
  pgType: string;
  /** 카드 번호^|0000111122223333 */
  cardNo: string;
}

export interface recurring-payments-card-789328600 {
  /** 카드사 명 (nullable)^|NH농협카드 */
  cardName?: string;
  /** 카드 우선순위^|1 */
  priority: number;
  /** 카드 번호^|1 */
  cardNo: number;
  /** 카드 등록일^|2025-10-24 */
  registerDate: string;
  /** 카드 마지막 4자리 (nullable)^|1234 */
  cardEndDigit?: string;
}

export interface app-card-auth-orderNo-1770967382 {
  /** 앱카드 소유자의 성별 (nullable)^|M */
  gender?: string;
  /** 앱카드 소유자의 내/외국인 구분값 (nullable)^|0 */
  nation?: string;
  /** 앱카드 결제 인증 서비스 식별번호 (nullable)^|test-di */
  di?: string;
  /** CI (nullable)^|test-ci */
  ci?: string;
  /** 간편결제 회원번호 (nullable)^|T567856785678 */
  userNo?: string;
  /** 앱카드 소유자의 이름 (nullable)^|홍길동 */
  name?: string;
  /** 앱카드 소유자의 생년월일 (nullable)^|19001231 */
  birthDate?: string;
  /** 앱카드 소유자의 이메일 (nullable)^|test@nhn-commerce.com */
  email?: string;
  /** 앱카드 소유자의 휴대폰 번호 (nullable)^|01012345678 */
  phoneNo?: string;
  /** 간편결제계정 ID (nullable)^|123412341234 */
  acntId?: string;
}

export interface recurring-payments-later-input-shippings-1500072629 {
  /** (해외배송 시 필수) 수령인 LastName (nullable)^|Doe */
  receiverLastName?: string;
  /** 지번 주소^|경기도 성남시 분당구 삼평동 629번지 NHN 플레이뮤지엄 */
  receiverJibunAddress: string;
  /** 수령자 이름^|홍길동 */
  receiverName: string;
  /** 국가 (nullable)^|KR */
  countryCd?: string;
  /** 추가 약관 동의 항목 번호 리스트 */
  customTermsAgrees?: any[];
  /** 우편 번호^|12345 */
  receiverZipCd: string;
  /** 상세 주소^|16 NHN 플레이뮤지엄 */
  receiverDetailAddress: string;
  /** 배송 메모^|경비실에 맡겨주세요 */
  deliveryMemo: string;
  /** (해외) 도시 (nullable)^|Los Angeles */
  receiverCity?: string;
  /** 주소^|경기도 성남시 분당구 대왕판교로645번길 12 */
  receiverAddress: string;
  /** 필수 약관 리스트 */
  agreementTermsAgrees?: any[];
  /** 비밀번호 (nullable)^|1234 */
  password?: string;
  /** 비밀번호 확인 (nullable)^|1234 */
  passwordConfirm?: string;
  /** (해외) 주 (nullable)^|CA */
  receiverState?: string;
  /** (해외배송 시 필수) 수령인 FirstName (nullable)^|John */
  receiverFirstName?: string;
  /** 수령자 연락처1^|010-0000-0000 */
  receiverContact1: string;
  /** 사은품 정보 */
  gifts?: any[];
  /** 수령자 연락처2 (nullable)^|010-0000-0000 */
  receiverContact2?: string;
}

export interface recurring-payments-recurringPaymentId-status1579374590 {
  /** 정기결제 신청번호 리스트 (bulk api에 사용) (nullable)^|[] */
  recurringPaymentIds?: any[];
  /** 정기결제 신청번호^|ACTIVE */
  changeStatusType: string;
}

export interface payments-naver-ordersheet486549215 {
}

export interface app-card-inst-plan1540047407 {
  /** 조회 PG 사 명^|KGI */
  pg: string;
  /** 할부정보 */
  instInfo: any[];
}

export interface profile-shipping-addresses-booked-1292237025 {
  /** 배송지 내역 */
  contents: any[];
  /** 총 수량 */
  totalCount: number;
}

export interface profile-orders-summary-status-1218498888 {
  /** 배송완료수^|0 */
  deliveryDoneCnt: number;
  /** 교환완료수^|0 */
  exchangeDoneCnt: number;
  /** 반품 진행중 수^|0 */
  returnProcessingCnt: number;
  /** 상품준비중수^|0 */
  productPrepareCnt: number;
  /** 배송중수^|0 */
  deliveryIngCnt: number;
  /** 취소 진행중 수^|0 */
  cancelProcessingCnt: number;
  /** 결제완료수^|0 */
  payDoneCnt: number;
  /** 배송준비중수^|0 */
  deliveryPrepareCnt: number;
  /** 구매확정수

구매확정수는 옵션단위로 카운트됩니다.

(ex) 한 번에 3개의 상품을 주문하는 경우: 1개의 상품을 구매확정하면 buyConfirmCnt는1, 모든 상품을 구매확정하면 buyConfirmCnt는 3.

(ex) 1개의 상품의 서로 다른 옵션을 각각 주문하는 경우: 주문한 옵션 개수에 따라 카운트.

단, 동일 옵션 주문시 개수를 기준으로 카운트 되지 않습니다.

(ex) 특정 상품의 동일 옵션 1가지를 여러 개 주문하는 경우: buyConfirmCnt는 1^|0 */
  buyConfirmCnt: number;
  /** 입금대기수^|0 */
  depositWaitCnt: number;
  /** 취소완료수^|0 */
  cancelDoneCnt: number;
  /** 반품완료수^|0 */
  returnDoneCnt: number;
  /** 교환 진행중 수^|0 */
  exchangeProcessingCnt: number;
}

export interface payments-naver-wish-list1437311046 {
  /** 상품번호^|123 */
  productNo: number;
}

export interface profile-orders-orderNo-claim-653937674 {
  /** deprecated(더 이상 제공하지 않는 개체항목입니다) */
  insurance?: Record<string, any>;
  /** 결제완료시 PG사에서 전달 받는 암호키(지원 PG: 토스간편결제) (nullable)^|order-certify-key */
  orderCertifyKey?: string;
  /** 추가 정보 (nullable) */
  extraData?: Record<string, any>;
  /** 구매확정 시 적립예정 적립금^|0 */
  accumulationAmtWhenBuyConfirm: number;
  /** 기본 주문 상태^|DEPOSIT_WAIT */
  defaultOrderStatusType: string;
  /** PG사 결제키^|testtest */
  pgMallKey: string;
  /** 배송지 메모^|배송지 메모 내용 */
  memo: string;
  /** 최초주문금액정보 */
  firstOrderAmount: Record<string, any>;
  /** 주문메모 (nullable)^|선물포장 부탁드립니다 */
  orderMemo?: string;
  /** 개인통관고유부호필요여부(true: 필요, false: 불필요)^|false */
  requireCustomsIdNumber: boolean;
  /** 환불(예상)방법(PG)(deprecated: refundTypeLabel 사용)^|PG */
  refundType: string;
  /** 결제 영수증 정보 */
  receiptInfos: any[];
  /** 교환추가결제 정보 (nullable) */
  exchangePayInfos?: any[];
  /** 결제수단 (nullable)^|CREDIT_CARD */
  payType?: string;
  /** 현금영수증 발행 정보 */
  cashReceiptInfo?: Record<string, any>;
  /** 회원여부(true: 회원, false: 비회원)^|true */
  member: boolean;
  /** 다음에 할 수 있는 작업 */
  nextActions: any[];
  /** 에스크로 여부(true: 에스크로, false: 비에스크로)^|false */
  escrow: boolean;
  /** 선택가능한 은행 */
  availableBanks: any[];
  /** 비회원-인증토큰 (nullable)^|121212 */
  guestToken?: string;
  /** (예상)환불방법(노출용) */
  refundTypeLabel: string;
  /** 외부 PG사^|PAYCO */
  pgType: string;
  /** 주문번호^|202012341234 */
  orderNo: string;
  /** 최종주문금액정보 */
  lastOrderAmount: Record<string, any>;
  /** 환불정보 (nullable) */
  refundInfos?: any[];
  /** 추가결제정보 (nullable) */
  additionalPayInfos?: any[];
  /** 해외결제정보 */
  internationalPayInfo?: Record<string, any>;
  /** 배송지 메모^|빠른 배송 부탁드립니다. */
  deliveryMemo: string;
  /** 환불결제방법(deprecated: refundTypeLabel 사용)^|CANCEL_DEPOSIT */
  refundPayType: string;
  /** 선택가능한 사유 목록 */
  claimReasonTypes: any[];
  /** 주문만료 일자 - (가상계좌 전용) (nullable)^|YYYY-MM-DD hh:mm:ss */
  paymentExpirationYmdt?: string;
  /** 현재 주문에 대한 클레임 정보 (nullable) */
  claimHistories?: any[];
  /** 주문자정보 */
  orderer: Record<string, any>;
  /** PG사 결제번호(주문번호) - 매출전표등 확인용 (nullable)^|202012341234 */
  pgOrderNo?: string;
  /** 파트너별주문리스트 */
  orderOptionsGroupByPartner: any[];
  /** 배송지정보 */
  shippingAddress: Record<string, any>;
  /** 주문일자^|YYYY-MM-DD hh:mm:ss */
  orderYmdt: string;
  /** 결제지 주소 */
  billingAddress?: Record<string, any>;
  /** 결제수단라벨 (nullable)^|신용카드 */
  payTypeLabel?: string;
  /** 결제정보 */
  payInfo?: Record<string, any>;
}

export interface wish-525767844 {
  /** 회원의 총 Wish 상품수 (최대 100개 가능)^|1 */
  count: number;
}

export interface profile-orders-orderNo-cashReceipt-cancel-1780899540 {
  /** 신청 결과 ( ISSUE: 발행완료, REQUEST_ONLY: 응답없음, FAIL: 실패, CANCEL: 취소완료 )^|CANCEL */
  resultType: string;
  /** 결과 상세 메시지 (resultType이 ISSUE가 아닐때 값 존재 (nullable)^|현금 영수증 발급 가능 상태가 아닙니다. */
  resultMsg?: string;
}

export interface order-configs-1934478780 {
  /** pg사^|KCP, INICIS, TOSS_PAYMENTS */
  pgType: string;
  /** 쇼핑몰 이전 일자^|2022-03-31 00:00:000 */
  mallTransferYmdt: string;
  /** 거래명세서 쇼핑몰 출력 항목 설정 */
  shopSpecificationFields: any[];
  /** 네이버페이 설정정보(사용안함 설정이거나 설정이 없을 경우 null 반환) */
  naverPay?: Record<string, any>;
  /** 무통장입금 시 현금영수증 신청 필수 여부^|false */
  cashReceiptRequired: boolean;
  /** [개발중] 앱카드 사용 여부^|false */
  useAppCard: boolean;
  /** 영수증 보기 버튼 사용 여부 */
  visibleReceiptBtn: Record<string, any>;
  /** 이전주문 내역 존재 여부^|true */
  includesPreviousOrder: boolean;
  shippingEmptyAutoCancel?: Record<string, any>;
  /** 마이페이 사용여부^|false */
  useMyPay: boolean;
  /** 거래명세서 하단 추가 정보 (빈값: 사용안함) */
  specificationAdditionalInfo: string;
  /** 결제영수증 사용 여부^|false */
  usePaymentReceipt: boolean;
  /** 몰 정기배송(결제) 사용 여부^|true */
  useRecurringPayment: boolean;
  /** 에스크로 설정 정보 */
  escrow?: Record<string, any>;
  /** 간이영수증 사용 여부^|false */
  useSimpleReceipt: boolean;
  /** 정기결제 사은품 지급 기준^|RECURRING_PAYMENT_GROUP_NO */
  recurringPaymentFreeGiftIssueType: string;
  /** 거래명세서 쇼핑몰 노출 설정^|false */
  viewShopSpecification: boolean;
  /** 무통장입금 시 현금영수증 사용 여부^|true */
  cashReceipt: boolean;
}

export interface recurring-payments-cart-953781281 {
  /** 회원의 총 Cart 상품수^|2 */
  count: number;
}

export interface payments-naver-validate-337567464 {
}

export interface profile-orders-orderNo-cashReceipt102827997 {
  /** 현금영수증 발급 키 타입 (nullable)^|MOBILE_NO */
  cashReceiptKeyType?: string;
  /** 발급 용도에 따른 키(소득공제용: 휴대폰번호, 지출증빙용: 사업자번호)^|123456 */
  cashReceiptKey: string;
  /** 발급 용도^|INCOME_TAX_DEDUCTION */
  cashReceiptIssuePurposeType: string;
}

export interface profile-orders-orderNo-cashReceipt-401340952 {
  /** 신청 결과^|ISSUE */
  resultType: string;
  /** 결과 상세 메시지 (resultType이 ISSUE가 아닐때 값 존재 (nullable)^|현금 영수증 발급 가능 상태가 아닙니다. */
  resultMsg?: string;
}

export interface shippings-enums-1588224597 {
  /** 일본 주(state) 코드 */
  jpStateCd: any[];
  /** 미국 주(state) 코드 */
  usStateCd: any[];
  /** 국가 코드 */
  countryCd: any[];
  /** 캐나다 주(state) 코드 */
  caStateCd: any[];
}

export interface recurring-payments-1497532350 {
  /** 정기결제 주문 */
  contents: any[];
  /** 총 개수 */
  totalCount: number;
}

