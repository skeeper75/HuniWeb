// Auto-generated TypeScript types from product-shop

export interface products-best-seller-search1936398570 {
  /** 페이지 수 */
  pageCount?: number;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 전체 상품 수 */
  totalCount?: number;
  items?: any[];
}

export interface products-productNo-display-categories-1237636422 {
}

export interface profile-like-brands-1214266850 {
  /** 총 브랜드 수 */
  totalCount?: number;
  items?: any[];
}

export interface products-search1304546243 {
  /** 페이지 수 */
  pageCount?: number;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 전체 상품 수 */
  totalCount?: number;
  clickUrlPrefix?: Record<string, any>;
  items?: any[];
}

export interface profile-like-products-1687063304 {
}

export interface products-productNo-options676330184 {
  /** 필수 옵션 여부 */
  isRequiredOption?: boolean;
  /** 상품 판매가 */
  productSalePrice?: number;
  /** 즉시 할인가 */
  immediateDiscountAmt?: number;
  /** 일체형 옵션 */
  flatOptions?: any[];
  /** 구매자 작성형 정보(텍스트 옵션 내 기입문장) */
  inputs?: any[];
  /** 분리형 옵션 */
  multiLevelOptions?: any[];
  /** 옵션 선택 타입 */
  selectType?: string;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(saleType>SOLD_OUT)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 옵션 타입 (STANDARD: 단독형 옵션(샵바이프로: 텍스트 옵션), COMBINATION: 조합형 옵션, DEFAULT: 옵션 사용안함, MAPPING: 맵핑(샵바이 엔터프라이즈 전용), REQUIRED: 필수/선택형 옵션) */
  type?: string;
  /** 옵션명 목록 */
  labels?: any[];
}

export interface products-regular-delivery-search243194228 {
}

export interface profile-like-brands--941076231 {
  items?: any[];
}

export interface profile-like-products-110141960 {
}

export interface products-best-review-search1323865931 {
  /** 페이지 수 */
  pageCount?: number;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 전체 상품 수 */
  totalCount?: number;
  items?: any[];
}

export interface profile-like-products-2097794731 {
  /** 상품 번호 리스트 (배열) */
  productNos?: any[];
}

export interface free-gift-condition-order-amount-1823649687 {
  /** 사은품 지급 조건 리스트 */
  freeGiftConditions?: any[];
  /** 전체 사은품지급조건 수 */
  totalCount?: number;
}

export interface display-brands-search-860864492 {
}

export interface products-options-279656068 {
  optionInfos?: any[];
}

export interface products-regular-delivery-1597014301 {
  recurringDeliveryProductViews?: any[];
  /** 검색한 페이지 */
  totalPage?: number;
  /** 총 개수 */
  totalCount?: number;
}

export interface products-productNo-related-products1184136101 {
}

export interface profile-like-brands-member1424116560 {
  items?: any[];
}

export interface profile-like-brands-count1719610570 {
}

export interface products-productNo-standard-category1365440212 {
  /** 첫번쩨 표준카테고리 번호 */
  depth1No?: number;
  /** 표준카테고리 전체 이름 */
  fullCategoryName?: string;
  /** 두번째 표준카테고리 번호 */
  depth2No?: number;
  /** 세번째 표준카테고리 번호 */
  depth3No?: number;
  /** 마지막 표준카테고리 번호 (최하위 뎁스로 만약 뎁스가 4개가 아니더라도 마지막의 뎁스 번호로 인식 */
  depth4No?: number;
}

export interface display-brands-search-by-nos-460729423 {
  brands?: any[];
}

export interface display-brands-displayBrandNo-1536879905 {
  /** 브랜드명 노출타입 */
  nameType?: string;
  /** 서브 브랜드명 */
  subBrandName?: string;
  /** 브랜드 설명 */
  description?: string;
  /** 브랜드 이미지 또는 브랜드 관련 동영상 url */
  displayAreaContentUrl?: string;
  /** 브랜드번호 */
  brandNo?: number;
  /** 메인 브랜드명 */
  mainBrandName?: string;
  /** 브랜드 추가 설명 */
  extraInfo?: string;
}

export interface products-extraInfo375807320 {
}

export interface products-productNo-purchasable-1211254388 {
}

export interface products-custom-properties-640819701 {
  /** 상품항목 */
  customProperties?: any[];
}

export interface profile-recent-products-524943492 {
  /** 상품 번호 */
  productNo?: number;
}

export interface additional-discounts-by-product-no-632583040 {
  /** 할인율 (수량할인 사용시 수량1개 기준 정보) (nullable) */
  discountRate?: number;
  /** 추가 할인 번호 */
  discountNo?: number;
  /** 최소 기준 금액 (nullable) */
  minSalePrice?: number;
  /** 할인액 (수량할인 사용시 수량1개 기준 정보) (nullable) */
  discountAmount?: number;
  /** 추가 할인 종료일 */
  endDateTime?: string;
  /** 구매수량할인 사용여부 */
  isQuantityDiscount?: boolean;
  /** 최대 기준 금액 (nullable) */
  maxSalePrice?: number;
  /** 추가 할인명 */
  discountName?: string;
  /** 추가 할인 시작일 */
  startDateTime?: string;
  /** 고객등급별할인 사용여부 */
  isMemberDiscount?: boolean;
  /** 최대 할인 금액 (수량할인 사용시 수량1개 기준 정보) (nullable) */
  maxDiscountAmount?: number;
  /** 정액 할인 여부 (수량할인 사용시 수량1개 기준 정보) */
  isFixedDiscount?: boolean;
  /** 구매수량할인 설정 정보 */
  quantityDiscountInfos?: any[];
  /** 고객등급별할인 설정 정보 */
  memberDiscountInfos?: any[];
}

export interface profile-like-products-231588225 {
  items?: any[];
}

export interface display-brands-extraInfo-1018337533 {
}

export interface products-productNo-options-images-1053841668 {
}

export interface products-search-keywords226225576 {
}

export interface display-brands-tree-1949059840 {
}

export interface products-shipping-info1753277011 {
}

export interface products-search-summary-2039606728 {
  brands?: any[];
  depth4Categories?: any[];
  depth3Categories?: any[];
  depth2Categories?: any[];
  /** 총 개수 */
  totalCount?: number;
  /** 상품추가항목 */
  customProperties?: any[];
  multiLevelCategories?: any[];
  /** 최소 가격 */
  minPrice?: number;
  depth1Categories?: any[];
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 최대 가격 */
  maxPrice?: number;
  clickUrlPrefix?: Record<string, any>;
  depth5Categories?: any[];
}

export interface products-restock1510916953 {
  /** 개인정보 수집 동의여부 (true:개인정보 수집 동의 ,false:개인정보 수집 비동의 - default) */
  privacyInfoAgreement?: boolean;
  /** 옵션번호 */
  optionNos?: any[];
  /** 휴대폰번호: -(하이픈) 제외 */
  phone?: string;
  /** 신청자명 */
  name?: string;
}

export interface profile-like-products504560329 {
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 전체 상품 수 */
  totalCount?: number;
  items?: any[];
}

export interface products-productNo-url-shortening-1808461975 {
  /** 단축URL */
  url?: string;
}

export interface profile-like-products-count1871095000 {
  /** 좋아요 수 */
  likedCount?: number;
}

export interface products-bundle-shipping-183018637 {
  /** 페이지  */
  pageCount?: number;
  /** 브랜드 */
  brands?: any[];
  depth4Categories?: any[];
  depth3Categories?: any[];
  depth2Categories?: any[];
  /** 검색된 상품 총 개수 */
  totalCount?: number;
  multiLevelCategories?: any[];
  depth1Categories?: any[];
  /** 가장 낮은 가격 */
  minPrice?: number;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 가장 높은 가격 */
  maxPrice?: number;
  /** 상품 목록 */
  items?: any[];
  depth5Categories?: any[];
}

export interface products-productNo-options-optionNo-images-589532874 {
}

export interface products-configuration-naver-shopping-293908981 {
  /** 네이버 쇼핑 설정 여부 */
  supportsNaverShopping?: boolean;
  /** CPA 주문수집 동의여부 */
  agreedToCollectingCPAOrder?: boolean;
  /** 네이버 공통 인증키 */
  authenticationKey?: string;
}

export interface display-brands-displayBrandNo-children124042645 {
}

export interface products-productNo-636886533 {
  /** 렌탈 정보 (옵션 유무에 상관없이 상품의 렌탈 정보 조회 - 즉시할인 및 추가할인 모두 적용. 옵션은 API(/products/{productNo}/options) 에서 렌탈 정보 조회 가능) */
  rentalInfos?: any[];
  /** 예약판매정보 */
  reservationData?: Record<string, any>;
  /** 상품 기본 정보 */
  baseInfo?: Record<string, any>;
  /** 그룹관리코드 노출명 (nullable) */
  groupManagementCodeName?: string;
  /** 배송 관련 정보 */
  shippingInfo?: Record<string, any>;
  /** 배송 안내 (nullable) */
  deliveryGuide?: string;
  /** 그룹관리코드 (nullable) */
  groupManagementCode?: string;
  /** 관련 상품 번호 */
  relatedProductNos?: any[];
  /** 좋아요 여부(accessToken 없을 시 false) */
  liked?: boolean;
  /** 사입 위탁 구분 값 */
  saleMethodType?: string;
  /** 교환 안내 (nullable) */
  exchangeGuide?: string;
  /** 환불 안내 (nullable) */
  refundGuide?: string;
  /** 가격 정보 */
  price?: Record<string, any>;
  /** 리뷰 작성 가능 여부 */
  reviewAvailable?: boolean;
  /** 카테고리 목록 */
  categories?: any[];
  /** 재고정보 */
  stock?: Record<string, any>;
  /** 상품 배송일 */
  deliveryDate?: Record<string, any>;
  /** 브랜드 정보 */
  brand?: Record<string, any>;
  /** 구매제한 */
  limitations?: Record<string, any>;
  /** 상품평 평균점 */
  reviewRate?: number;
  /** 메인 베스트 상품 여부 */
  mainBestProductYn?: boolean;
  /** 정기 결제 정보 (nullable) <br /> 해당 값이 null로 오느냐에 따라서 정기결제상품인지 아닌지 여부를 판단 */
  regularDelivery?: Record<string, any>;
  /** 상품 카운트 정보 */
  counter?: Record<string, any>;
  /** 파트너사 공지 */
  partnerNotice?: Record<string, any>;
  /** AS 안내 (nullable) */
  afterServiceGuide?: string;
  /** 배송 정보 */
  deliveryFee?: Record<string, any>;
  /** 판매자 정보 */
  partner?: Record<string, any>;
  /** 주류 통신판매 명령 위임고시 (nullable) */
  liquorDelegationGuide?: string;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br /><br />
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(status>soldout)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 상품 상태 */
  status?: Record<string, any>;
}

export interface products-group-management-code-1465298211 {
}

export interface products-group-management-code-959194716 {
  /** 그룹관리코드 */
  groupManagementCodes?: string;
  /** 품절상품 포함 여부(true: 품절상품 포함, false: 품절상품 비포함 - default) (nullable) */
  isSoldOut?: string;
  /** 판매 상태 ( 전체 판매 상태 조회: ALL_CONDITIONS, 판매대기와 판매중 상품 조회: READY_ONSALE, 판매중 상품만 조회: ONSALE - default, 예약판매중인 상품과 판매중인 상품만 조회: RESERVATION_AND_ONSALE) (nullable) */
  saleStatus?: string;
}

export interface products-search-by-nos1116014589 {
}

export interface products-favoriteKeywords682143570 {
}

export interface products-search-by-nos582657089 {
  /** 유효하지 않은 상품 번호 */
  invalidProductsNos?: any[];
  /** 상품 목록 */
  products?: any[];
}

export interface display-brands-764911083 {
  /** 전체 브랜드 수 */
  totalCount?: number;
  items?: any[];
}

export interface profile-recent-products332560431 {
}

export interface products-productNo-extra-products1903198862 {
  /** 추가상품정보 */
  extraProducts?: any[];
  /** 추가상품명 */
  extraProductTitle?: string;
}

export interface products-public-info1328647758 {
}

