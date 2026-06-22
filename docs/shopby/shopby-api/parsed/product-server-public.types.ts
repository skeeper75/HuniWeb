// Auto-generated TypeScript types from product-server

export interface products-productNo-histories-2022409867 {
}

export interface brands-displayBrandNo-306351940 {
  /** 전시브랜드 번호 */
  no?: number;
  /** depth */
  depth?: number;
  /** 하위 브랜드 목록(상위 브랜드 정보와 동일한 정보를 갖습니다.) */
  children?: any[];
  /** 부가 브랜드명 */
  subName?: string;
  /** 메인 브랜드명 */
  mainName?: string;
  /** 브랜드 상세 설명 */
  detailContents?: string;
  /** 브랜드 추가 설명 */
  description?: string;
  /** 브랜드 이미지 또는 브랜드 관련 동영상 url */
  displayAreaContentUrl?: string;
  /** 브랜드 설명 */
  mainImageContents?: string;
  /** 브랜드관련 추가 정보 */
  extraInfo?: string;
}

export interface products-inspections-productNo-view1549628254 {
  /** 수정된 항목 */
  modifiedParam?: any[];
  /** 심사중인 상품 정보 */
  originProductInfo?: Record<string, any>;
  /** 승인상태 (APPROVAL_READY: 승인대기, APPROVAL_REJECTION: 승인거부, AFTER_APPROVAL_READY: 수정 후 승인대기, AFTER_APPROVAL_REJECTION: 수정 후 승인거부) */
  inspectionStatus?: string;
  /** 실제 값이 존재하지 않는 항목, (ADMIN: 담당자, CATEGORY: 표준카테고리, DISPLAY_CATEGORY: 전시카테고리, DELIVERY_TEMPLATE: 배송비템플릿, MEMBER_GROUP: 회원그룹, MEMBER_GRADE: 회원등급) */
  invalidParams?: any[];
  /** 심사중인 상품 정보 */
  inspectionProductInfo?: Record<string, any>;
}

export interface brands--1089473782 {
}

export interface products-partial-quick-799755428 {
  /** 업데이트 실패한 리스트 */
  failureList?: any[];
  /** 업데이트 성공한 리스트 */
  successList?: any[];
  /** 성공여부 */
  status?: string;
}

export interface products-global-by-product-nos1507519571 {
  items?: any[];
}

export interface products-search-by-nos1924553784 {
}

export interface products-partial-quick-345918480 {
}

export interface products-global-by-global-nos1146104130 {
  items?: any[];
}

export interface products-sale-agreements-561508834 {
  failures?: any[];
  /** 수정에 성공한 상품 번호 리스트 */
  successProductNos?: any[];
  /** 총 상품 개수 */
  totalCount?: number;
}

export interface brands-216860027 {
}

export interface products-inspections-reject-420480137 {
  reasons?: any[];
}

export interface products1785670262 {
  /** 매입처 상품명(nullable) */
  supplierProductName?: string;
  /** 상품 안내 템플릿 정보 */
  productGuides?: any[];
  /** 판매수수료타입 - 상품수수료, 카테고리수수료, 파트너수수료, 공급가입력(nullable) */
  commissionRateType?: string;
  /** 장바구니 불가 기간 설정(Y일경우 장바구니 시작,종료일 입력) */
  cartOffPeriodYn?: string;
  /** 프로모션 적용 가능여부 */
  promotionYn?: string;
  /** 상품상세 헤더(HTML)(nullable) */
  contentHeader?: string;
  /** 매입가(유효상황: 판매방식-사입, 옵션-없음)/공급가(유효상황: 판매방식-위탁, 판매수수료-공급가입력, 옵션-없음)(nullable) */
  purchasePrice?: number;
  /** 상품 번호 */
  mallProductNo?: number;
  /** 상품명 */
  productName?: string;
  /** 단축URL 사용여부 */
  urlShorteningYn?: string;
  /** 배송 여부 */
  deliveryYn?: string;
  /** 프로모션 홍보문구 노출 종료(nullable) */
  promotionTextEndYmdt?: string;
  /** 미성년자 구매가능 여부 */
  minorPurchaseYn?: string;
  /** 표준카테고리 */
  categoryNo?: number;
  /** 장바구니 사용 여부 */
  cartUseYn?: string;
  /** 스티커 정보 */
  stickers?: any[];
  /** 검색어(,로 구분)(nullable) */
  keyword?: string;
  /** 브랜드 번호 */
  brandNo?: number;
  /** 단위 가격(nullable) */
  unitPrice?: number;
  /** 출고지 파트너 번호(nullable) */
  shippingAreaPartnerNo?: number;
  /** 브랜드 이름 */
  brandName?: string;
  /** 1회최대구매수량 (없으면 0) */
  maxBuyTimeCnt?: number;
  /** 단위 값(nullable) */
  unitName?: string;
  /** 리스트 이미지 URL(productListImageInfo 사용 시, null) */
  productListImage?: string;
  /** 최대구매기간(수량, 없으면 0) */
  maxBuyPeriodCnt?: number;
  /** 적립금 사용여부(사용하지 않을경우 0) */
  accumulationUseYn?: string;
  /** 출고유형(nullable) */
  shippingAreaType?: string;
  /** 즉시할인 단위 */
  immediateDiscountUnitType?: string;
  /** 환불가능여부 */
  refundableYn?: string;
  /** 관련 상품 정보 - 설정하지 않을경우 null 설정 */
  relatedProductInfo?: Record<string, any>;
  /** 적립률(%), 사용하지 않을경우 null */
  accumulationRate?: number;
  /** 단위(개, 대, 마리, 매, 발, 봉, 쌍, 알, 입, 장, 정, 켤레, 포
, a, ah, box, cc, cm, ea, g, gal, gb, inch, kg, L
, lb, m, mah, mb, mg, ml, mm, oz, pack, pc, pg, psi
, R, T, tb, v, w, 캡슐, Vcap, soft gel, 구미, P, 권)
순서대로 NAME + 순서로 보내주세요.
만약 단위가 '마리’면 NAME3입니다(nullable) */
  unitNameType?: string;
  /** 재입고 알림 사용설정 (default: N) - Y(사용), N(미사용)(nullable) */
  useRestockNotiYn?: string;
  /** 판매시작일 */
  saleStartYmdt?: string;
  /** 상품군 */
  classType?: string;
  /** 추가 정보(nullable) */
  extraInfo?: string;
  /** 플랫폼 - 검색엔진 노출 여부 */
  searchengineDisplayYn?: string;
  /** 판매자 관리코드(nullable) */
  productManagementCd?: string;
  /** 최소구매수량 (2이상만 입력하세요. 없으면 0) */
  minBuyCnt?: number;
  /** 판매수수료(nullable) */
  commissionRate?: number;
  /** 상품분류 */
  groupType?: string;
  /** 프로모션 기간 사용 여부 */
  promotionTextYn?: string;
  /** 플랫폼 - 모바일 웹 노출 여부 */
  platformDisplayMobileWebYn?: string;
  /** 1인최대구매수량 (없으면 0) */
  maxBuyPersonCnt?: number;
  /** 상품정보고시(json 문자열) - 상품 정보 고시 항목 조회하기 API 참조(nullable) */
  dutyInfo?: string;
  /** 적립금 사용 한도율 */
  accumulationLimitInfo?: Record<string, any>;
  /** 옵션타입이 조합형일 경우 옵션 재고의 합이 자동으로 입력됨(단독형일 경우에만 전송, 조합형일 경우 0) */
  productStockCnt?: number;
  /** 추가관리코드(옵션없음 상품의 추가관리코드를 설정하는 필드)(nullable) */
  extraManagementCd?: string;
  /** 장바구니 불가 종료일자(nullable) */
  cartOffEndYmdt?: string;
  /** 대표 전시카테고리 */
  representativeDisplayCategoryNo?: number;
  /** 플랫폼 - 모바일 앱 노출 여부 */
  platformDisplayMobileYn?: string;
  /** 플랫폼 노출 설정 여부('Y’일 경우 전체, 'N’일 경우 개별) */
  platformDisplayYn?: string;
  /** 묶음배송 가능 여부 */
  deliveryCombinationYn?: string;
  /** 상품상세 본문(nullable) */
  content?: string;
  /** 비회원 구매가능 여부 */
  nonmemberPurchaseYn?: string;
  /** 전시카테고리 */
  displayCategoryNo?: any[];
  /** 판매방식 - 사입, 위탁(nullable) */
  saleMethodType?: string;
  /** 정산시 파트너 분담금 */
  partnerChargeAmt?: number;
  /** 추가설정 */
  extraJsonMap?: Record<string, any>;
  /** 해외배송 여부 */
  deliveryInternationalYn?: string;
  /** 리스트 이미지 정보(외부 이미지 여부, 이미지 타입 여부 설정) */
  productListImageInfo?: Record<string, any>;
  /** 옵션 사용 유무 */
  isOptionUsed?: boolean;
  /** 배송관련 판매자 특이사항/고객안내사항(nullable) */
  deliveryCustomerInfo?: string;
  /** 등록된 옵션이미지사용. default = N */
  addOptionImageYn?: string;
  /** 배송비 템플릿 번호(없을경우 기본 배송비 템플릿 번호로 매핑됩니다)
배송여부가 '배송안함’일 경우 0 */
  deliveryTemplateNo?: number;
  /** 장바구니 불가 시작일자(nullable) */
  cartOffStartYmdt?: string;
  /** 상품항목추가정보 */
  customProperty?: any[];
  /** 즉시할인 값 */
  immediateDiscountValue?: number;
  /** 유효기간(유통기한)(nullable) */
  expirationYmdt?: string;
  /** 환불가능 세부정보 */
  refundableInfo?: Record<string, any>;
  /** 즉시할인 기간 설정 여부(기간 설정을 하지 않을 경우 N로 전송) */
  immediateDiscountPeriodYn?: string;
  /** 상품상세 푸터(HTML)(nullable) */
  contentFooter?: string;
  /** 상품 담당자(nullable) */
  merchandiserNo?: number;
  /** 플랫폼 - PC 노출 여부 */
  platformDisplayPcYn?: string;
  /** 판매가 */
  salePrice?: number;
  /** 제조일자(nullable) */
  manufactureYmdt?: string;
  optionData?: Record<string, any>;
  /** 즉시할인 시작일자(nullable) */
  immediateDiscountStartYmdt?: string;
  /** 프론트 미노출 여부 - Y(미노출), N(노출)(nullable) */
  urlDirectDisplayYn?: string;
  /** 판매종료일 */
  saleEndYmdt?: string;
  /** 과세 적용 기준(nullable) */
  valueAddedTaxType?: string;
  /** 홍보문구(nullable) */
  promotionText?: string;
  /** 판매기간설정 */
  salePeriodType?: string;
  productImages?: any[];
  /** hs code(nullable) */
  hsCode?: string;
  /** 즉시할인 종료일자(nullable) */
  immediateDiscountEndYmdt?: string;
  /** 최대구매기간(일, 없으면 0) */
  maxBuyDays?: number;
  /** 영문상품명(nullable) */
  productNameEn?: string;
  /** 원산지 정보^|PlaceOriginInfo(placeOriginSeq=90002, placeOriginsYn=N, placeOrigin=) */
  placeOriginInfo?: Record<string, any>;
  /** 프로모션 홍보문구 노출 시작일(nullable) */
  promotionTextStartYmdt?: string;
}

export interface products-stock-with-product-management-code1048443623 {
  failures?: any[];
}

export interface products-partial-1673963495 {
  price?: Record<string, any>;
  options?: any[];
  saleStatus?: Record<string, any>;
  /** 상품번호 */
  mallProductNo?: number;
}

export interface products-inspections-confirm-1625766215 {
  failures?: any[];
  /** 수정에 성공한 상품 번호 리스트 */
  successNos?: any[];
  /** 수정 요청한 상품 수 */
  totalCount?: number;
}

export interface purchase-permission-product-permissionNo1697306124 {
  /** 구매가능시작일 yyyy-MM-dd HH:mm:ss */
  purchaseStartAt?: string;
  /** 구매가능종료일 yyyy-MM-dd HH:mm:ss */
  purchaseEndAt?: string;
  /** 옵션번호 */
  optionNo?: number;
  /** 재고반영여부 */
  stockChangeable?: boolean;
  /** 상품번호 */
  productNo?: number;
}

export interface products-mallProductNo--142780588 {
  /** 부모 상품 번호, 0 이면 master 상품 */
  parentNo?: number;
  /** 판매 설정 상태, Enum: [ AVAILABLE_FOR_SALE: 판매가능, STOP_SELLING: 판매중지, PROHIBITION_SALE: 판매금지 ] */
  saleSettingStatusType?: string;
  /** 매입처 상품명 */
  supplierProductName?: string;
  /** 메인몰상품여부 */
  isMainMall?: boolean;
  /** 검색어 */
  keywords?: any[];
  /** 전시브랜드 번호, 미설정 0 */
  displayBrandNo?: number;
  /** 상품정보고시 */
  dutyContent?: Record<string, any>;
  /** 상품 안내 */
  productGuides?: any[];
  /** 홍보문구 등록 정보 */
  promotionTextInfo?: Record<string, any>;
  /** 상품 상세 상단 */
  contentHeader?: string;
  /** 공급/매입가 - 사입(공급가), 위탁(매입가) */
  purchasePrice?: number;
  /** 배송지정일 */
  deliveryDueDate?: Record<string, any>;
  /** 상품번호 */
  mallProductNo?: number;
  /** 상품명 */
  productName?: string;
  /** 옵션타입, Enum: [ STANDARD: 단독형 옵션(샵바이프로: 텍스트 옵션), COMBINATION: 조합형 옵션, DEFAULT: 옵션 사용안함, MAPPING: 맵핑(샵바이 엔터프라이즈 전용), REQUIRED: 필수/선택형 옵션 ] */
  optionType?: string;
  /** 옵션 사용 여부(Y/N) */
  optionUseYn?: string;
  /** 최대 구매수량 정보 */
  maxBuyCountInfo?: Record<string, any>;
  /** 배송 여부 - Y(배송), N(배송안함) */
  deliveryYn?: string;
  /** 미성년자 구매 가능 여부 - Y(가능), N(불가능), 불가능 설정 시 비회원은 구매 불가합니다. */
  minorPurchaseYn?: string;
  /** 옵션정보 */
  options?: any[];
  /** 표준 카테고리 번호 */
  categoryNo?: number;
  /** 리스트 이미지 URL */
  mallProductListImage?: string;
  /** 상품 이미지 */
  mallProductImages?: any[];
  /** 판매수수료 정보 */
  commissionInfo?: Record<string, any>;
  /** 브랜드 번호, 미설정 0 */
  brandNo?: number;
  /** 판매기간 정보 */
  salePeriodInfo?: Record<string, any>;
  /** 글로벌상품번호 */
  globalProductNo?: number;
  /** 상품 단축URL */
  shortenUrl?: string;
  /** 배송지 파트너 번호 */
  shippingAreaPartnerNo?: number;
  /** 브랜드명 */
  brandName?: string;
  /** 인증정보 */
  certificationInfo?: Record<string, any>;
  /** 적립금 사용 가능 여부 - Y(가능), N(불가능) */
  accumulationUseYn?: string;
  /** 배송 구분, Enum: [ PARTNER_SHIPPING_AREA: 파트너사 배송, MALL_SHIPPING_AREA: 쇼핑몰 배송 ] */
  shippingAreaType?: string;
  /** 환불가능여부 - Y(환불가능), N(불가) */
  refundableYn?: string;
  /** 즉시할인 정보 */
  immediateDiscountInfo?: Record<string, any>;
  /** 결제수단제어 여부 - Y(설정), N(전체가능), 설정 시 장바구니는 사용 불가능 */
  paymentMeansControlYn?: string;
  /** 관련 상품 정보 */
  relatedProductInfo?: Record<string, any>;
  /** 적립금적립 - %, 0 이면 설정안함 */
  accumulationRate?: number;
  /** 글로벌 카테고리 번호, TYPE: List<Int> */
  globalDisplayCategoryNos?: any[];
  /** 플랫폼별 노출 설정 정보 */
  platformDisplayInfo?: Record<string, any>;
  /** 전시가능여부 - Y(가능), N(불가능) */
  frontDisplayYn?: string;
  /** 장바구니 정보 */
  cartInfo?: Record<string, any>;
  /** 재입고 알림 기능 사용 설정 */
  useRestockNotiYn?: string;
  /** 결제수단항목, Enum: [ PAYCO: 페이코, CREDIT: 신용카드, REALTIME_TRANSFER: 실시간계좌이체, DEPOSIT: 가상계좌, ESCROW_REALTIME_TRANSFER: 실시간계좌이체-에스크로, ESCROW_VIRTUAL_ACCOUNT: 가상계좌-에스크로, RENTAL: 이니렌탈 ] */
  paymentMeans?: any[];
  /** 상품유형, Enum: [ DEFAULT: 일반상품, EVENT: 이벤트상품, OFFLINE: 오프라인상품, RENTAL: 렌탈상품 ] */
  classType?: string;
  /** 추가정보 */
  extraInfo?: string;
  /** 구매자 작성형 */
  customerDemands?: any[];
  /** 전시 카테고리 번호, TYPE: List<Int> */
  displayCategoryNos?: any[];
  /** 상품관리코드 */
  productManagementCd?: string;
  /** 검색엔진 미노출 여부 - Y(미노출), N(노출) */
  searchengineDisplayYn?: string;
  /** 최소 구매수량 - 0 : 최소구매수량 설정 안함 */
  minBuyCnt?: number;
  /** 상품군, Enum: [ DELIVERY: 배송상품군, SERVICE: 서비스상품군 ] */
  groupType?: string;
  /** 예약판매 정보 */
  reservationInfo?: Record<string, any>;
  /** 적립금 사용 한도율 (nullable) */
  accumulationLimitInfo?: Record<string, any>;
  /** 추가관리코드(옵션없음인 경우) */
  extraManagementCd?: string;
  /** 상품 재고수량 */
  productStockCnt?: number;
  /** 묶음배송 가능여부 */
  deliveryCombinationYn?: string;
  /** 상품 상세 */
  content?: string;
  /** 상품정보고시 수정팝업 노출시의 데이터 (변경안 반영되어 있는 고시) */
  willDutyContent?: Record<string, any>;
  /** 비회원구매 가능여부 - Y(가능), N(불가능) */
  nonmemberPurchaseYn?: string;
  /** 옵션 선택 유형 (df: MULTI), Enum: [ MULTI: 분리형, FLAT: 일체형 ] */
  optionSelectType?: string;
  /** 판매방식, Enum: [ PURCHASE: 사입, CONSIGNMENT: 위탁 ] */
  saleMethodType?: string;
  /** 파트너사 분담금 */
  partnerChargeAmt?: number;
  /** 파트너사 번호 */
  partnerNo?: number;
  /** 해외배송 여부 */
  deliveryInternationalYn?: string;
  /** EAN CODE */
  eanCode?: string;
  /** 판매자 특이사항/고객안내사항 */
  deliveryCustomerInfo?: string;
  /** 배송 템플릿 번호 */
  deliveryTemplateNo?: number;
  /** 등록된 옵션 이미지 사용 여부 */
  addOptionImageYn?: string;
  /** 회원등급 노출 설정 정보 */
  memberGradeDisplayInfo?: Record<string, any>;
  /** 수정가능 여부 */
  modifiable?: boolean;
  /** 리스트 이미지 URL 타입, Enum: [ IMAGE_URL: 이미지, VIDEO_URL: 비디오 ] */
  mallProductListImageUrlType?: string;
  /** 상품추가항목 */
  customPropertyValues?: any[];
  /** 상품타입, Enum: [ SINGLE: 단일상품, MAPPING: 맵핑상품 ] */
  productType?: string;
  /** 환불가능여부 상세 */
  refundableInfo?: Record<string, any>;
  /** 유효일자 */
  expirationYmdt?: string;
  /** 상품 상세 하단 */
  contentFooter?: string;
  /** 담당자 번호 */
  adminNo?: number;
  /** 재고 연동 여부 (true: 재고연동, false: 재고미연동) */
  synced?: boolean;
  /** 제조일자 */
  manufactureYmdt?: string;
  /** 판매가 */
  salePrice?: number;
  /** 프론트 미노출 여부 - Y(미노출), N(노출) */
  urlDirectDisplayYn?: string;
  /** 판매 중지시 대체 문구 */
  contentsIfPausing?: string;
  /** 프로모션 적용 정보 */
  promotionInfo?: Record<string, any>;
  /** 회원그룹 노출 설정 정보 */
  memberGroupDisplayInfo?: Record<string, any>;
  /** 부가세, Enum: [ DUTY: 과세, DUTYFREE: 면세, SMALL: 영세 ] */
  valueAddedTaxType?: string;
  /** 스티커 정보 */
  stickerInfos?: any[];
  /** HS CODE */
  hsCode?: string;
  /** 단위별 가격 정보 */
  unitPriceInfo?: Record<string, any>;
  /** 상품중량 */
  totalWeight?: number;
  /** 승인상태, Enum: [ REGISTRATION_READY: 등록대기, APPROVAL_READY: 승인대기, APPROVAL_REJECTION: 승인거부, SALE_AGREEMENT_READY: 판매합의대기, SALE_AGREEMENT_REJECTION: 판매합의거부, FINISHED: 승인완료, AFTER_APPROVAL_READY: 수정 후 승인대기, AFTER_APPROVAL_REJECTION: 수정 후 승인거부 ] */
  applyStatusType?: string;
  /** 영문 상품명 */
  productNameEn?: string;
  /** 상품 추가 정보들 : json string */
  extraJson?: Record<string, any>;
  /** 원산지번호 */
  placeOriginInfo?: Record<string, any>;
  /** 몰 번호 */
  mallNo?: number;
  /** 판매상태, Enum: [ PRE_APPROVAL_STATUS: 승인완료이전, ON_PRE_SALE: 예약판매중, WAITING_SALE: 판매대기, ON_SALE: 판매중, END_SALE: 판매종료 ] */
  saleStatusType?: string;
}

export interface products--1371578602 {
  /** 유효기간(유통기한)(YYYY-MM-DD HH:00:00)(nullable) */
  expirationDateTime?: string;
  /** 매입처 상품명 (nullable)(nullable) */
  supplierProductName?: string;
  /** 상품군 - Enum: [ DELIVERY: 배송상품군, SERVICE: 서비스상품군 ] (default: DELIVERY)(nullable) */
  groupType?: string;
  /** 검색어 리스트 */
  keywords?: any[];
  /** 상품정보고시 (상품 정보 고시 항목 조회하기 API 참조) (nullable) */
  dutyContent?: Record<string, any>;
  /** 상품 안내 정보 (상단 내용 참고) */
  productGuides?: any[];
  /** 재고 수량 (옵션 사용 시, 옵션 재고 사용) */
  stockQuantity?: number;
  /** 상품 내용 설정 */
  contentDetail?: Record<string, any>;
  /** 대표 전시 카테고리(nullable) */
  representativeDisplayCategoryNo?: number;
  /** 상품명 */
  productName?: string;
  /** 판매방식 - Enum: [ PURCHASE: 사입, CONSIGNMENT: 위탁 ] (default: CONSIGNMENT(nullable) */
  saleMethodType?: string;
  /** 옵션 유형(COMBINATION: 조합형, NONE: 기본생성, REQUIRED: 필수/선택형) */
  optionType?: string;
  /** 단축URL 사용여부 */
  urlShorteningYn?: string;
  /** 가격 관련 설정 */
  price?: Record<string, any>;
  stickers?: any[];
  /** 판매자 관리 코드 (nullable) */
  managementCode?: string;
  /** 표준 카테고리(nullable) */
  standardCategoryNo?: number;
  /** 브랜드 정보 (nullable) */
  brand?: Record<string, any>;
  /** 판매 기간 정보 */
  salePeriodInfo?: Record<string, any>;
  refundableInfo?: Record<string, any>;
  /** 제조일자 (YYYY-MM-DD HH:00:00) (nullable) */
  manufacturedDateTime?: string;
  /** 배송 관련 설정 */
  delivery?: Record<string, any>;
  /** 상품 이미지 관련 설정 */
  image?: Record<string, any>;
  /** 상품 담당자 */
  merchandiserNo?: number;
  /** 재입고 알림 사용설정 (Y: 사용, N: 미사용 - default) */
  usesRestockNotification?: boolean;
  /** 노출 관련 설정 */
  display?: Record<string, any>;
  /** 구매 수량 제한 설정 */
  purchaseLimitQuantity?: Record<string, any>;
  /** 관련 상품 정보 (설정 안함 null) */
  relatedProductInfo?: Record<string, any>;
  cartInfo?: Record<string, any>;
  /** 마케팅 관련 설정 */
  marketing?: Record<string, any>;
  customProperties?: any[];
  /** hs code */
  hsCode?: string;
  /** 영문 상품명 (nullable)(nullable) */
  productNameEn?: string;
  /** 추가설정 (nullable) */
  extraJson?: Record<string, any>;
  /** 원산지 정보 */
  placeOriginInfo?: Record<string, any>;
  /** 추가관리코드(옵션없음 상품의 추가관리코드를 설정하는 필드)(nullable) */
  extraManagementCode?: string;
  /** 상품분류 - Enum: [ DEFAULT: 일반상품, EVENT: 이벤트상품, OFFLINE: 오프라인상품, RENTAL: 렌탈상품 ] (default: DEFAULT(nullable) */
  classType?: string;
  /** 추가 정보 (nullable) */
  extraInfo?: string;
  /** 옵션 정보 (옵션 유형이 NONE인 경우 nullable) */
  option?: Record<string, any>;
  /** 전시 카테고리 리스트(nullable) */
  displayCategoryNos?: any[];
}

export interface purchase-permission114528248 {
  /** 상품우선구매권한 번호 */
  permissionNo?: number;
}

export interface brands-1872141758 {
  brands?: any[];
}

export interface products-search-engine1188042876 {
  /** 페이지 수 */
  pageCount?: number;
  brands?: any[];
  depth4Categories?: any[];
  /** 검색 기준 값 */
  lastId?: string;
  depth3Categories?: any[];
  depth2Categories?: any[];
  /** 전체 상품 수 */
  totalCount?: number;
  multiLevelCategories?: any[];
  /** 최소 가격 */
  minPrice?: number;
  depth1Categories?: any[];
  /** 재고 노출 여부 (false:재고 미노출 / true:재고 노출) */
  displayableStock?: boolean;
  /** 최대 가격 */
  maxPrice?: number;
  clickUrlPrefix?: Record<string, any>;
  items?: any[];
  depth5Categories?: any[];
}

export interface brands1003777638 {
  brands?: any[];
  failureBrands?: any[];
}

export interface brands-845298002 {
}

export interface products-746924980 {
  /** 저장된 구매자작성 번호(등록한 순서대로) */
  mallProductInputNos?: any[];
  /** 저장된 옵션번호(등록한 순서대로) */
  mallProductOptionNos?: any[];
  /** 저장된 상품번호 */
  mallProductNo?: number;
}

export interface custom-properties-859033228 {
}

export interface products-productNo--1826691289 {
  /** 유효기간(유통기한)(YYYY-MM-DD HH:00:00)(nullable) */
  expirationDateTime?: string;
  /** 매입처 상품명 (nullable)(nullable) */
  supplierProductName?: string;
  /** 상품군 - Enum: [ DELIVERY: 배송상품군, SERVICE: 서비스상품군 ] (default: DELIVERY)(nullable) */
  groupType?: string;
  /** 검색어 리스트 */
  keywords?: any[];
  /** 상품정보고시 (상품 정보 고시 항목 조회하기 API 참조) (nullable) */
  dutyContent?: Record<string, any>;
  /** 상품 안내 정보 (상단 내용 참고) */
  productGuides?: any[];
  /** 재고 수량 (옵션 사용 시, 옵션 재고 사용) */
  stockQuantity?: number;
  /** 상품 내용 설정 */
  contentDetail?: Record<string, any>;
  /** 대표 전시 카테고리(nullable) */
  representativeDisplayCategoryNo?: number;
  /** 상품명 */
  productName?: string;
  /** 판매방식 - Enum: [ PURCHASE: 사입, CONSIGNMENT: 위탁 ] (default: CONSIGNMENT(nullable) */
  saleMethodType?: string;
  /** 옵션 유형(COMBINATION: 조합형, NONE: 기본생성, REQUIRED: 필수/선택형) */
  optionType?: string;
  /** 단축URL 사용여부 */
  urlShorteningYn?: string;
  /** 가격 관련 설정 */
  price?: Record<string, any>;
  stickers?: any[];
  /** 판매자 관리 코드 (nullable) */
  managementCode?: string;
  /** 표준 카테고리(nullable) */
  standardCategoryNo?: number;
  /** 브랜드 정보 (nullable) */
  brand?: Record<string, any>;
  /** 판매 기간 정보 */
  salePeriodInfo?: Record<string, any>;
  refundableInfo?: Record<string, any>;
  /** 제조일자 (YYYY-MM-DD HH:00:00) (nullable) */
  manufacturedDateTime?: string;
  /** 배송 관련 설정 */
  delivery?: Record<string, any>;
  /** 상품 이미지 관련 설정 */
  image?: Record<string, any>;
  /** 상품 담당자 */
  merchandiserNo?: number;
  /** 재입고 알림 사용설정 (Y: 사용, N: 미사용 - default) */
  usesRestockNotification?: boolean;
  /** 노출 관련 설정 */
  display?: Record<string, any>;
  /** 구매 수량 제한 설정 */
  purchaseLimitQuantity?: Record<string, any>;
  /** 관련 상품 정보 (설정 안함 null) */
  relatedProductInfo?: Record<string, any>;
  cartInfo?: Record<string, any>;
  /** 마케팅 관련 설정 */
  marketing?: Record<string, any>;
  customProperties?: any[];
  /** hs code */
  hsCode?: string;
  /** 영문 상품명 (nullable)(nullable) */
  productNameEn?: string;
  /** 추가설정 (nullable) */
  extraJson?: Record<string, any>;
  /** 원산지 정보 */
  placeOriginInfo?: Record<string, any>;
  /** 추가관리코드(옵션없음 상품의 추가관리코드를 설정하는 필드)(nullable) */
  extraManagementCode?: string;
  /** 상품분류 - Enum: [ DEFAULT: 일반상품, EVENT: 이벤트상품, OFFLINE: 오프라인상품, RENTAL: 렌탈상품 ] (default: DEFAULT(nullable) */
  classType?: string;
  /** 추가 정보 (nullable) */
  extraInfo?: string;
  /** 옵션 정보 (옵션 유형이 NONE인 경우 nullable) */
  option?: Record<string, any>;
  /** 전시 카테고리 리스트(nullable) */
  displayCategoryNos?: any[];
}

export interface products-stock-with-product-management-code-747958319 {
  products?: any[];
}

export interface products-search-engine-835619697 {
  /** 페이지 수 */
  pageCount?: number;
  /** 검색 기준 값 */
  lastId?: string;
  /** 재고 노출 여부 (false:재고 미노출 / true:재고 노출) */
  displayableStock?: boolean;
  /** 전체 상품 수 */
  totalCount?: number;
  items?: any[];
}

export interface products-options-1969028125 {
  /** 구매자작성형번호 */
  mallProductInputNos?: any[];
  /** 옵션번호 */
  mallProductOptionNos?: any[];
  /** 상품번호 */
  mallProductNo?: number;
}

export interface products-productNo--343697088 {
  /** 유효기간(유통기한)(YYYY-MM-DD HH:00:00)(nullable) */
  expirationDateTime?: string;
  /** 매입처 상품명 (nullable)(nullable) */
  supplierProductName?: string;
  /** 상품군 - Enum: [ DELIVERY: 배송상품군, SERVICE: 서비스상품군 ] (default: DELIVERY)(nullable) */
  groupType?: string;
  /** 검색어 리스트 */
  keywords?: any[];
  /** 상품정보고시 (상품 정보 고시 항목 조회하기 API 참조) (nullable) */
  dutyContent?: Record<string, any>;
  /** 상품 안내 정보 (상단 내용 참고) */
  productGuides?: any[];
  /** 재고 수량 (옵션 사용 시, 옵션 재고 사용) */
  stockQuantity?: number;
  /** 상품 내용 설정 */
  contentDetail?: Record<string, any>;
  /** 대표 전시 카테고리(nullable) */
  representativeDisplayCategoryNo?: number;
  /** 상품명 */
  productName?: string;
  /** 판매방식 - Enum: [ PURCHASE: 사입, CONSIGNMENT: 위탁 ] (default: CONSIGNMENT(nullable) */
  saleMethodType?: string;
  /** 옵션 유형(COMBINATION: 조합형, NONE: 기본생성, REQUIRED: 필수/선택형) */
  optionType?: string;
  /** 단축URL 사용여부 */
  urlShorteningYn?: string;
  /** 가격 관련 설정 */
  price?: Record<string, any>;
  stickers?: any[];
  /** 판매자 관리 코드 (nullable) */
  managementCode?: string;
  /** 표준 카테고리(nullable) */
  standardCategoryNo?: number;
  /** 브랜드 정보 (nullable) */
  brand?: Record<string, any>;
  /** 판매 기간 정보 */
  salePeriodInfo?: Record<string, any>;
  refundableInfo?: Record<string, any>;
  /** 제조일자 (YYYY-MM-DD HH:00:00) (nullable) */
  manufacturedDateTime?: string;
  /** 배송 관련 설정 */
  delivery?: Record<string, any>;
  /** 상품 이미지 관련 설정 */
  image?: Record<string, any>;
  /** 상품 담당자 */
  merchandiserNo?: number;
  /** 재입고 알림 사용설정 (Y: 사용, N: 미사용 - default) */
  usesRestockNotification?: boolean;
  /** 노출 관련 설정 */
  display?: Record<string, any>;
  /** 구매 수량 제한 설정 */
  purchaseLimitQuantity?: Record<string, any>;
  /** 관련 상품 정보 (설정 안함 null) */
  relatedProductInfo?: Record<string, any>;
  cartInfo?: Record<string, any>;
  /** 마케팅 관련 설정 */
  marketing?: Record<string, any>;
  customProperties?: any[];
  /** hs code */
  hsCode?: string;
  /** 영문 상품명 (nullable)(nullable) */
  productNameEn?: string;
  /** 추가설정 (nullable) */
  extraJson?: Record<string, any>;
  /** 원산지 정보 */
  placeOriginInfo?: Record<string, any>;
  /** 추가관리코드(옵션없음 상품의 추가관리코드를 설정하는 필드)(nullable) */
  extraManagementCode?: string;
  /** 상품분류 - Enum: [ DEFAULT: 일반상품, EVENT: 이벤트상품, OFFLINE: 오프라인상품, RENTAL: 렌탈상품 ] (default: DEFAULT(nullable) */
  classType?: string;
  /** 추가 정보 (nullable) */
  extraInfo?: string;
  /** 옵션 정보 (옵션 유형이 NONE인 경우 nullable) */
  option?: Record<string, any>;
  /** 전시 카테고리 리스트(nullable) */
  displayCategoryNos?: any[];
}

export interface products-mallProductNo-1033838555 {
  /** 구매자 작성형 정보 */
  mallProductInputs?: any[];
  /** 옵션 정보 */
  mallProductOptionWebModels?: any[];
  mallProduct?: Record<string, any>;
  /** 상품 이미지 */
  mallProductImages?: any[];
}

export interface products-1516827439 {
  /** 매입처 상품명(nullable) */
  supplierProductName?: string;
  /** 상품 안내 정보 */
  productGuides?: any[];
  /** 판매수수료타입(nullable) */
  commissionRateType?: string;
  /** 장바구니 불가 기간 설정(Y일경우 장바구니 시작,종료일 입력  default : N)(nullable) */
  cartOffPeriodYn?: string;
  /** 프로모션 적용 가능여부 (default : Y)(nullable) */
  promotionYn?: string;
  /** 상품상세 헤더(HTML)(nullable) */
  contentHeader?: string;
  /** 매입가(유효상황: 판매방식-사입, 옵션-없음)/공급가(유효상황: 판매방식-위탁, 판매수수료-공급가입력, 옵션-없음)(nullable) */
  purchasePrice?: number;
  /** 상품명 */
  productName?: string;
  /** 단축URL 사용여부 */
  urlShorteningYn?: string;
  /** 배송 여부 (default: N)(nullable) */
  deliveryYn?: string;
  /** 프로모션 홍보문구 노출 종료(YYYY-MM-DD HH:00:00) - 프로모션 사용 시 입력(nullable) */
  promotionTextEndYmdt?: string;
  /** 미성년자 구매가능 여부 */
  minorPurchaseYn?: string;
  /** 표준카테고리 */
  categoryNo?: number;
  /** 장바구니 사용 여부 (default : Y)(nullable) */
  cartUseYn?: string;
  /** 스티커 정보 */
  stickers?: any[];
  /** 검색어(,로 구분)(nullable) */
  keyword?: string;
  /** 브랜드 번호 (default : 0 / null 또는 0이 아닌 경우, brandName보다 우선으로 반영)(nullable) */
  brandNo?: number;
  /** 단위 가격(nullable) */
  unitPrice?: number;
  /** 브랜드 이름 (brandNo가 우선으로 반영 - brandNo가 null or 0이 아닌 경우, brandNo 값이 없으면 해당 상품의 브랜드는 '없음'으로 반영)(nullable) */
  brandName?: string;
  /** 1회최대구매수량 (없으면 0)(nullable) */
  maxBuyTimeCnt?: number;
  /** 단위 값(nullable) */
  unitName?: string;
  /** 원산지 직접입력 값(nullable) */
  placeOrigin?: string;
  /** 리스트 이미지 URL(productListImageInfo 사용 시, null / productListImage와 productListImageInfo를 모두 기입하는 경우, productListImageInfo가 우선 적용됩니다.) */
  productListImage?: string;
  /** 최대구매기간(수량, 없으면 0)(nullable) */
  maxBuyPeriodCnt?: number;
  /** 적립금 사용여부 (default : Y)(nullable) */
  accumulationUseYn?: string;
  /** 출고유형 */
  shippingAreaType?: string;
  /** 즉시할인 단위 */
  immediateDiscountUnitType?: string;
  /** 환불가능여부 (default : Y)(nullable) */
  refundableYn?: string;
  /** 관련 상품 정보 - 설정하지 않을경우 null 설정 */
  relatedProductInfo?: Record<string, any>;
  /** 적립률(%), 사용하지 않을경우 null(nullable) */
  accumulationRate?: number;
  /** 단위(개, 대, 마리, 매, 발, 봉, 쌍, 알, 입, 장, 정, 켤레, 포
, a, ah, box, cc, cm, ea, g, gal, gb, inch, kg, L
, lb, m, mah, mb, mg, ml, mm, oz, pack, pc, pg, psi
, R, T, tb, v, w, 캡슐, Vcap, soft gel, 구미, P, 권)
순서대로 NAME + 순서로 보내주세요.
만약 단위가 '마리’면 NAME3입니다(nullable) */
  unitNameType?: string;
  /** 재입고 알림 사용설정 (Y: 사용, N: 미사용 - default)(nullable) */
  useRestockNotiYn?: string;
  /** 판매시작일(YYYY-MM-DD HH:00:00) */
  saleStartYmdt?: string;
  /** 상품분류(nullable) */
  classType?: string;
  /** 추가 정보(nullable) */
  extraInfo?: string;
  /** 플랫폼 - 검색엔진 노출 여부 (PC, 모바일 웹, 모바일 앱, 검색엔진 중 적어도 하나는 노출되어야 함. default : N)(nullable) */
  searchengineDisplayYn?: string;
  /** 판매자 관리코드(nullable) */
  productManagementCd?: string;
  /** 최소구매수량 (2이상만 입력하세요. 없으면 0)(nullable) */
  minBuyCnt?: number;
  /** 판매수수료 비율 - 파트너수수료인 경우는 파트너계약 수수료로 들어갑니다(nullable) */
  commissionRate?: number;
  /** 상품군 (default : DELIVERY)(nullable) */
  groupType?: string;
  /** 프로모션 기간 사용 여부 (default : N)(nullable) */
  promotionTextYn?: string;
  /** 플랫폼 - 모바일 웹 노출 여부 (PC, 모바일 웹, 모바일 앱, 검색엔진 중 적어도 하나는 노출되어야 함. default : N)(nullable) */
  platformDisplayMobileWebYn?: string;
  /** 1인최대구매수량 (없으면 0)(nullable) */
  maxBuyPersonCnt?: number;
  /** 상품정보고시(json 문자열) - 상품 정보 고시 항목 조회하기 API 참조(nullable) */
  dutyInfo?: string;
  /** 적립금 사용 한도율 (nullable) */
  accumulationLimitInfo?: Record<string, any>;
  /** 옵션타입이 조합형일 경우 옵션 재고의 합이 자동으로 입력됨(단독형일 경우에만 전송, 조합형일 경우 0  / default : 0)(nullable) */
  productStockCnt?: number;
  /** 추가관리코드(옵션없음 상품의 추가관리코드를 설정하는 필드)(nullable) */
  extraManagementCd?: string;
  /** 장바구니 불가 종료일자(YYYY-MM-DD HH:00:00)(nullable) */
  cartOffEndYmdt?: string;
  /** 대표 전시카테고리 */
  representativeDisplayCategoryNo?: number;
  /** 플랫폼 - 모바일 앱 노출 여부 (PC, 모바일 웹, 모바일 앱, 검색엔진 중 적어도 하나는 노출되어야 함. default : N)(nullable) */
  platformDisplayMobileYn?: string;
  /** 플랫폼 노출 설정 여부('Y’일 경우 전체, 'N’일 경우 개별 default : N)(nullable) */
  platformDisplayYn?: string;
  /** 묶음배송 가능 여부 */
  deliveryCombinationYn?: string;
  /** 상품상세 본문(nullable) */
  content?: string;
  /** 비회원 구매가능 여부 */
  nonmemberPurchaseYn?: string;
  /** 전시카테고리 */
  displayCategoryNo?: any[];
  /** 판매방식 ( default - CONSIGNMENT )(nullable) */
  saleMethodType?: string;
  /** 정산시 파트너 분담금 (default : 0)(nullable) */
  partnerChargeAmt?: number;
  /** 추가설정 */
  extraJsonMap?: Record<string, any>;
  /** 해외배송 여부 */
  deliveryInternationalYn?: string;
  /** 리스트 이미지 정보(외부 이미지 여부, 이미지 타입 여부 설정) */
  productListImageInfo?: Record<string, any>;
  /** 옵션 사용 유무 (default : false)(nullable) */
  isOptionUsed?: boolean;
  /** 배송관련 판매자 특이사항/고객안내사항(nullable) */
  deliveryCustomerInfo?: string;
  /** 등록된 옵션이미지사용. default = N(nullable) */
  addOptionImageYn?: string;
  /** 배송비 템플릿 번호(없을경우 기본 배송비 템플릿 번호로 매핑됩니다)
배송여부가 '배송안함’일 경우 0 */
  deliveryTemplateNo?: number;
  /** 장바구니 불가 시작일자(YYYY-MM-DD HH:00:00)(nullable) */
  cartOffStartYmdt?: string;
  /** 상품항목추가정보 */
  customProperty?: any[];
  /** 즉시할인 값 (default: 0)(nullable) */
  immediateDiscountValue?: number;
  /** 원본 이미지 url 그대로 사용하는지 여부(nhn cdn 사용 X) default : false(nullable) */
  useOriginProductImageUrl?: boolean;
  /** 유효기간(유통기한)(YYYY-MM-DD HH:00:00)(nullable) */
  expirationYmdt?: string;
  /** 환불가능 세부정보 */
  refundableInfo?: Record<string, any>;
  /** 즉시할인 기간 설정 여부(default : N)(nullable) */
  immediateDiscountPeriodYn?: string;
  /** 상품상세 푸터(HTML)(nullable) */
  contentFooter?: string;
  /** 상품 담당자(nullable) */
  merchandiserNo?: number;
  /** 플랫폼 - PC 노출 여부 (PC, 모바일 웹, 모바일 앱, 검색엔진 중 적어도 하나는 노출되어야 함. default : N)(nullable) */
  platformDisplayPcYn?: string;
  /** 판매가 */
  salePrice?: number;
  /** 제조일자(YYYY-MM-DD HH:00:00)(nullable) */
  manufactureYmdt?: string;
  optionData?: Record<string, any>;
  /** 즉시할인 시작일자(YYYY-MM-DD HH:00:00)(nullable) */
  immediateDiscountStartYmdt?: string;
  /** 판매종료일(YYYY-MM-DD HH:00:00) */
  saleEndYmdt?: string;
  /** 과세 적용 기준(nullable) */
  valueAddedTaxType?: string;
  /** 홍보문구(nullable) */
  promotionText?: string;
  /** 판매기간설정 */
  salePeriodType?: string;
  productImages?: any[];
  /** hs code(nullable) */
  hsCode?: string;
  /** 즉시할인 종료일자(YYYY-MM-DD HH:00:00)(nullable) */
  immediateDiscountEndYmdt?: string;
  /** 최대구매기간(일, 없으면 0)(nullable) */
  maxBuyDays?: number;
  /** 영문상품명(nullable) */
  productNameEn?: string;
  /** 프로모션 홍보문구 노출 시작일(YYYY-MM-DD HH:00:00) - 프로모션 사용 시 입력(nullable) */
  promotionTextStartYmdt?: string;
}

export interface brands826544395 {
}

export interface products-inspections-approval-waiting-1644247378 {
  contents?: any[];
  /** 전체 페이지수 */
  totalPage?: number;
  /** 전체 상품수 */
  totalCount?: number;
}

export interface products-options-915318368 {
  /** 구매자작성형 데이터 */
  inputs?: any[];
  /** 옵션 데이터 */
  options?: any[];
  /** 상품번호 */
  mallProductNo?: number;
}

export interface products-options-stock-with-id326558369 {
  options?: any[];
}

export interface purchase-permission-member-permissionNo-710942392 {
}

export interface purchase-permission-1922018647 {
  memberPermissions?: any[];
  productPermission?: Record<string, any>;
}

export interface products-productNo405578742 {
  /** 매입처 상품명(nullable) */
  supplierProductName?: string;
  /** 상품 안내 템플릿 정보 */
  productGuides?: any[];
  /** 판매수수료타입 - 상품수수료, 카테고리수수료, 파트너수수료, 공급가입력(nullable) */
  commissionRateType?: string;
  /** 장바구니 불가 기간 설정(Y일경우 장바구니 시작,종료일 입력)(nullable) */
  cartOffPeriodYn?: string;
  /** 프로모션 적용 가능여부(nullable) */
  promotionYn?: string;
  /** 상품상세 헤더(HTML)(nullable) */
  contentHeader?: string;
  /** 매입가(유효상황: 판매방식-사입, 옵션-없음, 옵션 있음인 경우 옵션의 purchasePrice 사용)/공급가(유효상황: 판매방식-위탁, 판매수수료-공급가입력, 옵션-없음)(nullable) */
  purchasePrice?: number;
  /** 상품명(nullable) */
  productName?: string;
  /** 옵션 유형(COMBINATION: 조합형, NONE: 기본생성, REQUIRED: 필수/선택형)} */
  optionType?: string;
  /** 배송 여부(nullable) */
  deliveryYn?: string;
  /** 프로모션 홍보문구 노출 종료(nullable) */
  promotionTextEndYmdt?: string;
  /** 미성년자 구매가능 여부(nullable) */
  minorPurchaseYn?: string;
  /** 프론트 미노출 여부 [true - 미노출, false - 노출](nullable) */
  urlDirectDisplayable?: boolean;
  /** 표준카테고리(nullable) */
  categoryNo?: number;
  /** 장바구니 사용 여부(nullable) */
  cartUseYn?: string;
  /** 스티커 정보 */
  stickers?: any[];
  /** 검색어(,로 구분)(nullable) */
  keyword?: string;
  /** 브랜드 번호(nullable) */
  brandNo?: number;
  /** 단위 가격(nullable) */
  unitPrice?: number;
  /** 출고지 파트너 번호(nullable) */
  shippingAreaPartnerNo?: number;
  /** 브랜드 이름(nullable) */
  brandName?: string;
  /** 1회최대구매수량 (없으면 0)(nullable) */
  maxBuyTimeCnt?: number;
  /** 단위 값(nullable) */
  unitName?: string;
  /** 리스트 이미지 URL */
  productListImage?: string;
  /** 최대구매기간(수량, 없으면 0)(nullable) */
  maxBuyPeriodCnt?: number;
  /** 적립금 사용여부(사용하지 않을경우 0)(nullable) */
  accumulationUseYn?: string;
  /** 출고유형(nullable) */
  shippingAreaType?: string;
  /** 즉시할인 단위(nullable) */
  immediateDiscountUnitType?: string;
  /** 환불가능여부(deprecated - refundableInfo.refundableYn 으로 사용)(nullable) */
  refundableYn?: string;
  /** 관련 상품 정보 - 설정하지 않을경우 null 설정" */
  relatedProductInfo?: Record<string, any>;
  /** 적립률(%), 사용하지 않을경우 null(nullable) */
  accumulationRate?: number;
  /** 단위(개, 대, 마리, 매, 발, 봉, 쌍, 알, 입, 장, 정, 켤레, 포
, a, ah, box, cc, cm, ea, g, gal, gb, inch, kg, L
, lb, m, mah, mb, mg, ml, mm, oz, pack, pc, pg, psi
, R, T, tb, v, w, 캡슐, Vcap, soft gel, 구미, P, 권)
순서대로 NAME + 순서로 보내주세요.
만약 단위가 '마리’면 NAME3입니다(nullable) */
  unitNameType?: string;
  /** 재입고 알림 사용설정 (default: N) - Y(사용), N(미사용)(nullable) */
  useRestockNotiYn?: string;
  /** 판매시작일(nullable) */
  saleStartYmdt?: string;
  /** 상품분류(nullable) */
  classType?: string;
  /** 추가 정보(nullable) */
  extraInfo?: string;
  /** 전시카테고리(nullable) */
  displayCategoryNos?: any[];
  /** 플랫폼 - 검색엔진 노출 여부(nullable) */
  searchengineDisplayYn?: string;
  /** 판매자 관리코드(nullable) */
  productManagementCd?: string;
  /** 최소구매수량 (2이상만 입력하세요. 없으면 0)(nullable) */
  minBuyCnt?: number;
  /** 판매수수료(nullable) */
  commissionRate?: number;
  /** 상품군(nullable) */
  groupType?: string;
  /** 프로모션 기간 사용 여부(nullable) */
  promotionTextYn?: string;
  /** 플랫폼 - 모바일 웹 노출 여부(nullable) */
  platformDisplayMobileWebYn?: string;
  /** 1인최대구매수량 (없으면 0)(nullable) */
  maxBuyPersonCnt?: number;
  /** 상품정보고시(json 문자열) - 상품 정보 고시 항목 조회하기 API 참조(nullable) */
  dutyInfo?: string;
  /** 적립금 사용 한도율 */
  accumulationLimitInfo?: Record<string, any>;
  /** 옵션타입이 조합형일 경우 옵션 재고의 합이 자동으로 입력됨(단독형일 경우에만 전송, 조합형일 경우 0)(nullable) */
  productStockCnt?: number;
  /** 추가관리코드(옵션없음 상품의 추가관리코드를 설정하는 필드)(nullable) */
  extraManagementCd?: string;
  /** 장바구니 불가 종료일자(nullable) */
  cartOffEndYmdt?: string;
  /** 대표 전시카테고리(nullable) */
  representativeDisplayCategoryNo?: number;
  /** 플랫폼 - 모바일 앱 노출 여부(nullable) */
  platformDisplayMobileYn?: string;
  /** 플랫폼 노출 설정 여부('Y’일 경우 전체, 'N’일 경우 개별)(nullable) */
  platformDisplayYn?: string;
  /** 묶음배송 가능 여부(nullable) */
  deliveryCombinationYn?: string;
  /** 상품상세 본문(nullable) */
  content?: string;
  /** 비회원 구매가능 여부(nullable) */
  nonmemberPurchaseYn?: string;
  /** 판매방식 - 사입, 위탁(nullable) */
  saleMethodType?: string;
  /** 정산시 파트너 분담금(nullable) */
  partnerChargeAmt?: number;
  /** 추가설정 */
  extraJsonMap?: Record<string, any>;
  /** 해외배송 여부(nullable) */
  deliveryInternationalYn?: string;
  /** 리스트 이미지 정보(외부 이미지 여부, 이미지 타입 여부 설정) */
  productListImageInfo?: Record<string, any>;
  /** 배송관련 판매자 특이사항/고객안내사항(nullable) */
  deliveryCustomerInfo?: string;
  /** 회원 등급 노출 설정 정보 */
  memberGradeDisplayInfo?: Record<string, any>;
  /** 등록된 옵션이미지사용. default = N */
  addOptionImageYn?: string;
  /** 배송비 템플릿 번호(없을경우 기본 배송비 템플릿 번호로 매핑됩니다)
배송여부가 '배송안함’일 경우 0(nullable) */
  deliveryTemplateNo?: number;
  /** 장바구니 불가 시작일자(nullable) */
  cartOffStartYmdt?: string;
  /** 상품항목추가정보 */
  customProperty?: any[];
  /** 즉시할인 값(nullable) */
  immediateDiscountValue?: number;
  /** 유효기간(유통기한)(nullable) */
  expirationYmdt?: string;
  refundableInfo?: Record<string, any>;
  /** 즉시할인 기간 설정 여부(기간 설정을 하지 않을 경우 N로 전송)(nullable) */
  immediateDiscountPeriodYn?: string;
  /** 상품상세 푸터(HTML)(nullable) */
  contentFooter?: string;
  /** 플랫폼 - PC 노출 여부(nullable) */
  platformDisplayPcYn?: string;
  /** 상품 담당자(nullable) */
  merchandiserNo?: number;
  /** 판매가(nullable) */
  salePrice?: number;
  /** 제조일자(nullable) */
  manufactureYmdt?: string;
  optionData?: Record<string, any>;
  /** 즉시할인 시작일자(nullable) */
  immediateDiscountStartYmdt?: string;
  /** 회원 그룹 노출 설정 정보 */
  memberGroupDisplayInfo?: Record<string, any>;
  /** 판매종료일(nullable) */
  saleEndYmdt?: string;
  /** 과세 적용 기준(nullable) */
  valueAddedTaxType?: string;
  /** 홍보문구(nullable) */
  promotionText?: string;
  /** 판매기간설정(nullable) */
  salePeriodType?: string;
  productImages?: any[];
  /** hs code(nullable) */
  hsCode?: string;
  /** 즉시할인 종료일자(nullable) */
  immediateDiscountEndYmdt?: string;
  /** 최대구매기간(일, 없으면 0)(nullable) */
  maxBuyDays?: number;
  /** 영문상품명(nullable) */
  productNameEn?: string;
  /** 원산지 정보^|PlaceOriginInfo(placeOriginSeq=90002, placeOriginsYn=N, placeOrigin=) */
  placeOriginInfo?: Record<string, any>;
  /** 프로모션 홍보문구 노출 시작일(nullable) */
  promotionTextStartYmdt?: string;
}

export interface products972845600 {
  /** 상품 응답 객체 */
  productDetailResponses?: any[];
}

export interface products-temporary1430542233 {
  /** 매입처 상품명(nullable) */
  supplierProductName?: string;
  /** 상품 안내 템플릿 정보 */
  productGuides?: any[];
  /** 장바구니 불가 기간 설정(Y: 장바구니 시작,종료일 입력)(nullable) */
  cartOffPeriodYn?: string;
  /** 프로모션 적용 가능여부(nullable) */
  promotionYn?: string;
  /** 상품상세 헤더(HTML)(nullable) */
  contentHeader?: string;
  /** 상품명 */
  productName?: string;
  /** 배송 여부(nullable) */
  deliveryYn?: string;
  /** 프로모션 홍보문구 노출 종료(nullable) */
  promotionTextEndYmdt?: string;
  /** 미성년자 구매가능 여부(nullable) */
  minorPurchaseYn?: string;
  /** 표준카테고리(nullable) */
  categoryNo?: number;
  /** 장바구니 사용 여부(nullable) */
  cartUseYn?: string;
  /** 스티커 정보 */
  stickers?: any[];
  /** 검색어(,로 구분)(nullable) */
  keyword?: string;
  /** 브랜드 번호(nullable) */
  brandNo?: number;
  /** 단위 가격(nullable) */
  unitPrice?: number;
  /** 1회최대구매수량 (없으면 0)(nullable) */
  maxBuyTimeCnt?: number;
  /** 단위 값(nullable) */
  unitName?: string;
  /** 리스트 이미지 URL(productListImageInfo 사용 시, null) */
  productListImage?: string;
  /** 최대구매기간(수량, 없으면 0)(nullable) */
  maxBuyPeriodCnt?: number;
  /** 적립금 사용 여부 (Y:사용가능 , N:사용불가능)(nullable) */
  accumulationUseYn?: string;
  /** 출고유형(nullable) */
  shippingAreaType?: string;
  /** 즉시할인 단위(nullable) */
  immediateDiscountUnitType?: string;
  /** 환불가능여부(nullable) */
  refundableYn?: string;
  /** 관련 상품 정보 - 설정하지 않을경우 null 설정 */
  relatedProductInfo?: Record<string, any>;
  /** 적립률(%)(nullable) */
  accumulationRate?: number;
  /** 단위(개, 대, 마리, 매, 발, 봉, 쌍, 알, 입, 장, 정, 켤레, 포
, a, ah, box, cc, cm, ea, g, gal, gb, inch, kg, L
, lb, m, mah, mb, mg, ml, mm, oz, pack, pc, pg, psi
, R, T, tb, v, w, 캡슐, Vcap, soft gel, 구미, P, 권)
순서대로 NAME + 순서로 보내주세요.
만약 단위가 '마리’면 NAME3입니다(nullable) */
  unitNameType?: string;
  /** 재입고 알림 사용설정 (default: N) - Y(사용), N(미사용)(nullable) */
  useRestockNotiYn?: string;
  /** 판매시작일(nullable) */
  saleStartYmdt?: string;
  /** 상품분류(nullable) */
  classType?: string;
  /** 추가 정보(nullable) */
  extraInfo?: string;
  /** 플랫폼 - 검색엔진 노출 여부(nullable) */
  searchengineDisplayYn?: string;
  /** 판매자 관리코드(nullable) */
  productManagementCd?: string;
  /** 최소구매수량 (2이상만 입력하세요. 없으면 0)(nullable) */
  minBuyCnt?: number;
  /** 상품군(nullable) */
  groupType?: string;
  /** 프로모션 기간 사용 여부(nullable) */
  promotionTextYn?: string;
  /** 플랫폼 - 모바일 웹 노출 여부(nullable) */
  platformDisplayMobileWebYn?: string;
  /** 1인최대구매수량 (없으면 0)(nullable) */
  maxBuyPersonCnt?: number;
  /** 상품정보고시(json 문자열) - 상품 정보 고시 항목 조회하기 API 참조(nullable) */
  dutyInfo?: string;
  /** 적립금 사용 한도율 (nullable) */
  accumulationLimitInfo?: Record<string, any>;
  /** 옵션타입이 조합형일 경우 옵션 재고의 합이 자동으로 입력됨(단독형일 경우에만 전송, 조합형일 경우 0)(nullable) */
  productStockCnt?: number;
  /** 추가관리코드(옵션없음상품)(nullable) */
  extraManagementCd?: string;
  /** 장바구니 불가 종료일자(nullable) */
  cartOffEndYmdt?: string;
  /** 대표 전시 카테고리(nullable) */
  representativeDisplayCategoryNo?: number;
  /** 플랫폼 - 모바일 앱 노출 여부(nullable) */
  platformDisplayMobileYn?: string;
  /** 플랫폼 노출 설정 여부(Y: 전체, N: 개별)(nullable) */
  platformDisplayYn?: string;
  /** 묶음배송 가능 여부(nullable) */
  deliveryCombinationYn?: string;
  /** 상품상세 본문(nullable) */
  content?: string;
  /** 비회원 구매가능 여부(nullable) */
  nonmemberPurchaseYn?: string;
  /** 전시 카테고리(nullable) */
  displayCategoryNo?: any[];
  /** 정산시 파트너 분담금(nullable) */
  partnerChargeAmt?: number;
  /** 추가설정 */
  extraJsonMap?: Record<string, any>;
  /** 해외배송 여부(nullable) */
  deliveryInternationalYn?: string;
  /** 리스트 이미지 정보(외부 이미지 여부, 이미지 타입 여부 설정) */
  productListImageInfo?: Record<string, any>;
  /** 옵션 사용 유무(nullable) */
  isOptionUsed?: boolean;
  /** 배송관련 판매자 특이사항/고객안내사항(nullable) */
  deliveryCustomerInfo?: string;
  /** 등록된 옵션이미지사용. default = N */
  addOptionImageYn?: string;
  /** 배송비 템플릿 번호(없을경우 기본 배송비 템플릿 번호로 매핑됩니다)
배송여부가 '배송안함’일 경우 0 */
  deliveryTemplateNo?: number;
  /** 장바구니 불가 시작일자(nullable) */
  cartOffStartYmdt?: string;
  /** 상품항목추가정보 */
  customProperty?: any[];
  /** 즉시할인 값(nullable) */
  immediateDiscountValue?: number;
  /** 유효기간(유통기한)(nullable) */
  expirationYmdt?: string;
  /** 즉시할인 기간 설정 여부(기간 설정을 하지 않을 경우 N)(nullable) */
  immediateDiscountPeriodYn?: string;
  /** 상품상세 푸터(HTML)(nullable) */
  contentFooter?: string;
  /** 플랫폼 - PC 노출 여부(nullable) */
  platformDisplayPcYn?: string;
  /** 판매가(nullable) */
  salePrice?: number;
  /** 제조일자(nullable) */
  manufactureYmdt?: string;
  /** 옵션 정보 */
  optionData?: Record<string, any>;
  /** 즉시할인 시작일자(nullable) */
  immediateDiscountStartYmdt?: string;
  /** 판매종료일(nullable) */
  saleEndYmdt?: string;
  /** 과세 적용 기준(nullable) */
  valueAddedTaxType?: string;
  /** 홍보문구(nullable) */
  promotionText?: string;
  /** 판매기간설정(nullable) */
  salePeriodType?: string;
  /** 상품 이미지 */
  productImages?: any[];
  /** hs code(nullable) */
  hsCode?: string;
  /** 즉시할인 종료일자(nullable) */
  immediateDiscountEndYmdt?: string;
  /** 최대구매기간(일, 없으면 0)(nullable) */
  maxBuyDays?: number;
  /** 영문상품명(nullable) */
  productNameEn?: string;
  /** 프로모션 홍보문구 노출 시작일(nullable) */
  promotionTextStartYmdt?: string;
}

export interface products-sale-agreements-1750270989 {
  /** 상품판매합의 거절 시 사용되는 항목, 합의시에는 reason 항목 없이 사용 */
  reason?: string;
  /** 합의여부 */
  isConfirm?: boolean;
  /** 상품번호 */
  productNos?: any[];
}

export interface products-extraInfo1091613775 {
}

export interface products-changed-756650823 {
  contents?: any[];
  /** 전체 페이지수 */
  totalPage?: number;
  /** 검색 기준 값 */
  lastId?: string;
  /** 전체 상품수 */
  totalCount?: number;
}

export interface products-mallProductNo-1604771271 {
  /** 매입처 상품명 */
  supplierProductName?: string;
  /** 검색어 */
  keywords?: any[];
  productGuides?: any[];
  /** 홍보문구 등록 정보 */
  promotionTextInfo?: Record<string, any>;
  /** 상품 상세 상단 */
  contentHeader?: string;
  /** 공급/매입가 - 사입(공급가), 위탁(매입가) */
  purchasePrice?: number;
  /** 상품명 */
  productName?: string;
  /** 옵션 타입(COMBINATION: 조합형, DEFAULT: 기본생성, REQUIRED: 필수/선택형) */
  optionType?: string;
  /** 최대 구매수량 정보 */
  maxBuyCountInfo?: Record<string, any>;
  /** 배송 여부 - Y(배송), N(배송안함) */
  deliveryYn?: string;
  /** 미성년자 구매 가능 여부 - Y(가능), N(불가능), 불가능 설정 시 비회원은 구매 불가합니다. */
  minorPurchaseYn?: string;
  options?: any[];
  /** 표준 카테고리 번호 */
  categoryNo?: number;
  /** 리스트 이미지 URL */
  mallProductListImage?: string;
  mallProductImages?: any[];
  /** 판매수수료 정보 */
  commissionInfo?: Record<string, any>;
  /** 판매기간 정보 */
  salePeriodInfo?: Record<string, any>;
  /** 배송지 파트너 번호 */
  shippingAreaPartnerNo?: number;
  /** 브랜드 이름 */
  brandName?: string;
  /** 적립금 사용 가능 여부 - Y(가능), N(불가능) */
  accumulationUseYn?: string;
  /** 배송 구분, Enum: [ PARTNER_SHIPPING_AREA: 파트너사 배송, MALL_SHIPPING_AREA: 쇼핑몰 배송 ] */
  shippingAreaType?: string;
  /** 환불가능여부 - Y(환불가능), N(불가) */
  refundableYn?: string;
  /** 즉시할인 정보 */
  immediateDiscountInfo?: Record<string, any>;
  /** 관련 상품 정보 */
  relatedProductInfo?: Record<string, any>;
  /** 적립금적립 - %, 0 이면 설정안함 */
  accumulationRate?: number;
  /** 플랫폼별 노출 설정 정보 */
  platformDisplayInfo?: Record<string, any>;
  /** 장바구니 정보 */
  cartInfo?: Record<string, any>;
  /** 재입고 알림 사용설정 (default: N) - Y(사용), N(미사용) */
  useRestockNotiYn?: string;
  /** 상품유형, Enum: [ DEFAULT: 일반상품, OFFLINE: 오프라인상품, RENTAL: 렌탈상품 ] */
  classType?: string;
  /** 상품 추가 정보(양식 없음) */
  extraInfo?: string;
  customerDemands?: any[];
  /** 전시 카테고리 번호, TYPE: List<Int> */
  displayCategoryNos?: any[];
  /** 상품관리코드 */
  productManagementCd?: string;
  /** 검색엔진 미노출 여부 - Y(미노출), N(노출) */
  searchengineDisplayYn?: string;
  /** 최소 구매수량 - 0 : 최소구매수량 설정 안함 */
  minBuyCnt?: number;
  /** 상품군, Enum: [ DELIVERY: 배송상품군, SERVICE: 서비스상품군 ] */
  groupType?: string;
  /** 상품정보고시 정보 */
  dutyInfo?: Record<string, any>;
  /** 적립금 사용 한도율 (nullable) */
  accumulationLimitInfo?: Record<string, any>;
  /** 추가관리코드(옵션 없는 상품인 경우 추가관리코드 설정 필드값) */
  extraManagementCd?: string;
  /** 상품 재고수량 */
  productStockCnt?: number;
  /** 묶음배송 가능여부 */
  deliveryCombinationYn?: string;
  /** 상품 상세 */
  content?: string;
  /** 비회원구매 가능여부 - Y(가능), N(불가능) */
  nonmemberPurchaseYn?: string;
  /** 옵션 선택 유형 (df: MULTI), Enum: [ MULTI: 분리형, FLAT: 일체형 ] */
  optionSelectType?: string;
  /** 판매방식, Enum: [ PURCHASE: 사입, CONSIGNMENT: 위탁 ] */
  saleMethodType?: string;
  /** 파트너사 분담 */
  partnerChargeAmt?: number;
  /** 파트너사 번호 */
  partnerNo?: number;
  /** 해외배송 여부 */
  deliveryInternationalYn?: string;
  /** 판매자 특이사항/고객안내사항 */
  deliveryCustomerInfo?: string;
  /** 배송 템플릿 번호 */
  deliveryTemplateNo?: number;
  /** 등록된 옵션 이미지 사용 여부 */
  addOptionImageYn?: string;
  /** 회원등급 노출 설정 정보 */
  memberGradeDisplayInfo?: Record<string, any>;
  /** 환불가능여부 상세 */
  refundableInfo?: Record<string, any>;
  /** 유효일자 */
  expirationYmdt?: string;
  /** 상품 상세 하단 */
  contentFooter?: string;
  /** 담당자 번호 */
  adminNo?: number;
  /** 제조일자 */
  manufactureYmdt?: string;
  /** 판매가 */
  salePrice?: number;
  /** 프론트 미노출 여부 - Y(미노출), N(노출) */
  urlDirectDisplayYn?: string;
  /** 프로모션 적용 정보 */
  promotionInfo?: Record<string, any>;
  /** 회원그룹 노출 설정 정보 */
  memberGroupDisplayInfo?: Record<string, any>;
  /** 부가세, Enum: [ DUTY: 과세, DUTYFREE: 면세, SMALL: 영세 ] */
  valueAddedTaxType?: string;
  stickerInfos?: any[];
  /** HS CODE */
  hsCode?: string;
  /** 단위별 가격 정보 */
  unitPriceInfo?: Record<string, any>;
  /** 영문 상품명 */
  productNameEn?: string;
  /** 상품 추가 정보들 : json string */
  extraJson?: Record<string, any>;
  /** 원산지번호 */
  placeOriginInfo?: Record<string, any>;
}

export interface products-inspections-confirm-663728110 {
  /** 상품번호 */
  productNos?: any[];
}

export interface products-productNo-options-1952793223 {
  /** 일체형 옵션 */
  flatOptions?: any[];
  /** 구매자 작성형 정보(텍스트 옵션 내 기입문장) */
  inputs?: any[];
  /** 분리형 옵션 */
  multiLevelOptions?: any[];
  /** 옵션 선택 타입 */
  selectType?: string;
  /** 옵션 타입 Enum: [ STANDARD: 단독형 옵션(샵바이프로: 텍스트 옵션), COMBINATION: 조합형 옵션, DEFAULT: 옵션 사용안함, MAPPING: 맵핑(샵바이 엔터프라이즈 전용), REQUIRED: 필수/선택형 옵션 ] */
  type?: string;
  /** 옵션명 목록 */
  labels?: any[];
}

export interface products-by-stickers2017030490 {
  contents?: any[];
  /** 총 페이지 수 */
  totalPage?: number;
  /** 검색 기준 값 */
  lastId?: string;
  /** 총 상품 개수 */
  totalCount?: number;
}

export interface products-mallProductNo-status62757076 {
  /** 전시여부 */
  display?: boolean;
  /** 품절처리 : TRUE일 경우만 품절처리 */
  soldout?: boolean;
  /** 판매상태 (기존 판매금지인 상품은 변경불가하고, 판매금지로 변경 시 전시여부가 false로 저장됨) */
  saleStatusType?: string;
}

export interface products-options-stock-with-management-code373219157 {
  failures?: any[];
}

export interface products-guides488466038 {
  /** 파트너 번호 (nullable) */
  partnerNo?: number;
  /** 안내 타입 */
  type?: string;
  /** 내용 */
  content?: string;
}

export interface like-products-83346460 {
  /** 전체 상품 수 */
  totalCount?: number;
  /** 회원이 좋아한 상품 결과 */
  items?: any[];
}

export interface products-search879922975 {
  /** 총 페이지 수 */
  totalPage?: number;
  elements?: any[];
  /** 검색 기준 값(상품번호) */
  lastId?: number;
  /** 총 개수 */
  totalCount?: number;
}

export interface purchase-permission-productNo-1130673558 {
}

export interface products-productNo1456766630 {
  /** 매입처 상품명 (nullable) */
  supplierProductName?: string;
  /** 검색어 (nullable) */
  keywords?: any[];
  /** 전시브랜드 번호 */
  displayBrandNo?: number;
  /** 상품 안내 (nullable) */
  productGuides?: any[];
  /** 홍보문구 등록 정보 (nullable) */
  promotionTextInfo?: Record<string, any>;
  /** 상품 상세 상단 (nullable) */
  contentHeader?: string;
  /** 공급/매입가 - 사입(공급가), 위탁(매입가) (nullable) */
  purchasePrice?: number;
  /** 배송지정일 (nullable) */
  deliveryDueDate?: Record<string, any>;
  /** 상품평 복사 여부 (nullable) */
  copiesReview?: boolean;
  /** 상품명 */
  productName?: string;
  /** 옵션타입(COMBINATION: 조합형, DEFAULT: 기본생성, REQUIRED: 필수/선택형) */
  optionType?: string;
  /** 최대 구매수량 정보 (nullable) */
  maxBuyCountInfo?: Record<string, any>;
  /** 배송 여부 - Y(배송), N(배송안함) */
  deliveryYn?: string;
  /** 미성년자 구매 가능 여부 - Y(가능), N(불가능), 불가능 설정 시 비회원은 구매 불가합니다. */
  minorPurchaseYn?: string;
  /** 옵션정보 (nullable) */
  options?: any[];
  /** 표준 카테고리 번호 */
  categoryNo?: number;
  /** 리스트 이미지 URL (nullable) */
  mallProductListImage?: string;
  /** 마케팅 채널 별 설정 정보 (nullable) */
  marketingSettings?: any[];
  /** 상품 이미지 */
  mallProductImages?: any[];
  /** 판매수수료 정보 */
  commissionInfo?: Record<string, any>;
  /** 브랜드 번호 */
  brandNo?: number;
  /** 판매기간 정보 */
  salePeriodInfo?: Record<string, any>;
  /** 배송지 파트너 번호 (nullable) */
  shippingAreaPartnerNo?: number;
  /** 홍보문구 등록 여부 - Y(등록), N(등록안함) */
  promotionTextUseYn?: string;
  /** 브랜드 이름 */
  brandName?: string;
  /** 인증정보 */
  certificationInfo?: Record<string, any>;
  /** 적립금 사용 가능 여부 - Y(가능), N(불가능) */
  accumulationUseYn?: string;
  /** 배송 구분, Enum: [ PARTNER_SHIPPING_AREA: 파트너사 배송, MALL_SHIPPING_AREA: 쇼핑몰 배송 ] (nullable) */
  shippingAreaType?: string;
  /** 환불가능여부 - Y(환불가능), N(불가) */
  refundableYn?: string;
  /** 가격비교사이트 정보(deprecated - 사용하지 않는 필드) */
  comparingPriceSiteInfo?: Record<string, any>;
  /** 즉시할인 정보 */
  immediateDiscountInfo?: Record<string, any>;
  /** 결제수단제어 여부 - Y(설정), N(전체가능), 설정 시 장바구니는 사용 불가능 */
  paymentMeansControlYn?: string;
  /** 관련 상품 정보 (nullable) */
  relatedProductInfo?: Record<string, any>;
  /** 적립금적립 - %, 0 이면 설정안함 (nullable) */
  accumulationRate?: number;
  /** 플랫폼별 노출 설정 정보 */
  platformDisplayInfo?: Record<string, any>;
  /** 장바구니 정보 */
  cartInfo?: Record<string, any>;
  /** 재입고 알림 사용설정 (default: N) - Y(사용), N(미사용) (nullable) */
  useRestockNotiYn?: string;
  /** 결제수단항목, Enum: [ PAYCO: 페이코, CREDIT: 신용카드, REALTIME_TRANSFER: 실시간계좌이체, DEPOSIT: 가상계좌, ESCROW_REALTIME_TRANSFER: 실시간계좌이체-에스크로, ESCROW_VIRTUAL_ACCOUNT: 가상계좌-에스크로, RENTAL: 이니렌탈 ] */
  paymentMeans?: any[];
  /** 상품유형, (DEFAULT: 일반상품, OFFLINE: 오프라인상품, RENTAL: 렌탈상품) */
  classType?: string;
  /** 추가 정보 (nullable) */
  extraInfo?: string;
  /** 구매자 작성형 (nullable) */
  customerDemands?: any[];
  /** 전시 카테고리 번호, TYPE: List<Int> */
  displayCategoryNos?: any[];
  /** 상품관리코드 (nullable) */
  productManagementCd?: string;
  /** 검색엔진 미노출 여부 - Y(미노출), N(노출) */
  searchengineDisplayYn?: string;
  /** 최소 구매수량 - 0 : 최소구매수량 설정 안함 (nullable) */
  minBuyCnt?: number;
  /** 상품군, Enum: [ DELIVERY: 배송상품군, SERVICE: 서비스상품군 ] */
  groupType?: string;
  /** 상품정보고시 정보 */
  dutyInfo?: Record<string, any>;
  /** 추가관리코드 (nullable) */
  extraManagementCd?: string;
  /** 상품 재고수량 */
  productStockCnt?: number;
  /** 묶음배송 가능여부 (nullable) */
  deliveryCombinationYn?: string;
  /** 상품 상세, 등록된 옵션 이미지 사용여부가 N 인경우 필수값. (nullable) */
  content?: string;
  /** 비회원구매 가능여부 - Y(가능), N(불가능) */
  nonmemberPurchaseYn?: string;
  /** 옵션 선택 유형(df: MULTI), Enum: [ MULTI: 분리형, FLAT: 일체형 ] (nullable) */
  optionSelectType?: string;
  /** 판매방식, Enum: [ PURCHASE: 사입, CONSIGNMENT: 위탁 ] */
  saleMethodType?: string;
  /** 파트너사 분담금 (nullable) */
  partnerChargeAmt?: number;
  /** 파트너사 번호 */
  partnerNo?: number;
  /** 해외배송 여부 (nullable) */
  deliveryInternationalYn?: string;
  /** EAN CODE (nullable) */
  eanCode?: string;
  /** 판매자 특이사항/고객안내사항 (nullable) */
  deliveryCustomerInfo?: string;
  /** 배송 템플릿 번호 (nullable) */
  deliveryTemplateNo?: number;
  /** 등록된 옵션 이미지 사용 여부 */
  addOptionImageYn?: string;
  /** 회원등급 노출 설정 정보 */
  memberGradeDisplayInfo?: Record<string, any>;
  /** 상품추가항목 (nullable) */
  customPropertyValues?: any[];
  /** 임시저장여부 (nullable) */
  tempSave?: boolean;
  /** 유효일자 (nullable) */
  expirationYmdt?: string;
  /** 상품 상세 하단 (nullable) */
  contentFooter?: string;
  /** 담당자 번호 */
  adminNo?: number;
  /** 제조일자 (nullable) */
  manufactureYmdt?: string;
  /** 판매가 */
  salePrice?: number;
  /** 예약판매 정보 (nullable) */
  reservationInfoModel?: Record<string, any>;
  /** 프론트 미노출 여부 - Y(미노출), N(노출) */
  urlDirectDisplayYn?: string;
  /** 프로모션 적용 정보 */
  promotionInfo?: Record<string, any>;
  /** 회원그룹 노출 설정 정보 */
  memberGroupDisplayInfo?: Record<string, any>;
  /** 부가세, Enum: [ DUTY: 과세, DUTYFREE: 면세, SMALL: 영세 ] */
  valueAddedTaxType?: string;
  /** 스티커 정보, TYPE: List<Int> (nullable) */
  stickerInfos?: any[];
  /** HS CODE (nullable) */
  hsCode?: string;
  /** 단위별 가격 정보 */
  unitPriceInfo?: Record<string, any>;
  /** 영문 상품명 (nullable) */
  productNameEn?: string;
  /** 상품 추가 정보들 : json string (nullable) */
  extraJson?: Record<string, any>;
  /** 원산지번호 */
  placeOriginInfo?: Record<string, any>;
  /** 몰 번호 */
  mallNo?: number;
}

export interface duty-categories-1578255591 {
}

export interface products-mallProductNo-status1116014589 {
}

export interface products-options-stock-with-id323914550 {
  failures?: any[];
}

export interface products-options-stocks-140334247 {
  stockViews?: any[];
  /** 조회된 상품 개수 */
  mallProductCount?: number;
}

export interface products-options-stock-with-management-code1772066786 {
  options?: any[];
}

