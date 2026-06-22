// Auto-generated TypeScript types from display-shop

export interface skin-banners-groups-by-skin-2014462740 {
  decorationConfig?: Record<string, any>;
  /** 바로가기 아이콘 (현재 모바일만 설정하고 있음) */
  appIcon?: string;
  /** 작업중인 스킨 여부 */
  isWorkSkin?: boolean;
  /** 사용중인 스킨 여부 */
  isLiveSkin?: boolean;
  /** 스킨 번호 */
  skinCode?: string;
  /** 플랫폼 유형 */
  platformType?: string;
  /** 스킨명 */
  skinName?: string;
  /** 스킨 수정 일자 */
  updateDateTime?: string;
  /** 스킨 배너 그룹 리스트 */
  bannerGroups?: any[];
}

export interface products-productNo-product-reviews-reviewNo-report-416765909 {
  /** 신고사유(저작권 침해: COPYRIGHT , 비방: SLANDER) */
  reportReasonCd?: string;
  /** 신고내용 */
  content?: string;
}

export interface display-sections-sectionNo-products1684402017 {
  /** 전체 상품 수 */
  productTotalCount?: number;
  /** 
 재고 노출 여부 (false:재고 미노출 / true:재고 노출)<br><br>
 false로 재고를 숨김처리 한 경우,
 1) 재고 관련 필드는(실제 재고가 있더라도) -999로 고정으로 리턴하며 실재고 값은 따로 내려주지 않아 조회 불가합니다.    
 2) 실재고가 0인 경우에만 0으로 응답합니다.      
   만약 재고 숨김처리 시, front에서 [-999]로 표시되도록 처리되고 있는게 있다면 재고노출여부(displayableStock)를 기준으로 수정 작업이 필요합니다.    
   만약 재고 숨김처리 시, front에서 [품절]로 표시되도록 처리되고 있는게 있다면 재고/예약재고값을 기준이 아닌, 품절상태(isSoldOut)값을 기준으로 처리되도록 수정 작업이 필요합니다.
  */
  displayableStock?: boolean;
  /** 상품목록 */
  products?: any[];
}

export interface display-events-sections-701678552 {
}

export interface display-events-search-by-nos480155160 {
}

export interface products-inquiries-tags1654561557 {
  /** 상품문의 태그정보 */
  inquiryTags?: any[];
}

export interface display-popups-1991835955 {
}

export interface display-events-eventNo-47777354 {
  /** 쿠폰 정보 */
  coupon?: Record<string, any>;
  /** 섹션 정보 */
  section?: any[];
  /** 전시 종료일 */
  endYmdt?: string;
  /** 기획전 명 */
  label?: string;
  /** 전시기간 타입 */
  displayPeriodType?: string;
  /** 기획전 url */
  url?: string;
  /** 홍보문구 */
  promotionText?: string;
  /** 기획전 번호 */
  eventNo?: number;
  /** 기획전 이미지 URL(PC) */
  pcImageUrl?: string;
  /** 전시 시작일 */
  startYmdt?: string;
  /** URL 타입 */
  urlType?: string;
  top?: Record<string, any>;
  /** 기획전 이미지 URL(MOBILE) */
  mobileimageUrl?: string;
  /** 쿠폰, 상단 노출 정보 정렬순서(배열 순서대로 프론트에서 노출, 몰마다 정책이 다를수 있음) */
  orders?: any[];
  /** 이벤트 여부 */
  eventYn?: string;
  /** 검색용 태그값 */
  tag?: string;
  /** 기획전 ID */
  id?: string;
  /** 카테고리 번호(배열) */
  categoryNos?: any[];
}

export interface display-events-eventNo-sections-sectionNo446847667 {
  /** 전체 상품 개수 */
  totalCount?: number;
  /** 상품진열 번호 */
  sectionNo?: number;
  /** 상품목록, hasProductDetail 이 false 경우 empty list */
  products?: any[];
}

export interface display-events-search-by-name431158817 {
}

export interface categories-search-by-management-code-86517568 {
  /** 관리코드 */
  codes?: any[];
}

export interface categories-simple-1depth1847237122 {
}

export interface profile-product-reviews596967437 {
  /** 작성한 상품평 수  */
  totalCount?: number;
  items?: any[];
}

export interface category-product-reviews1179982837 {
  /** 리뷰 평점 */
  rate?: number;
  /** 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface display-popups-popupNos923861041 {
}

export interface categories-search-by-management-code-1582853242 {
}

export interface profile-order-options-product-reviewable1059879305 {
  /** 작성 가능한 상품평 개수 */
  totalCount?: number;
  items?: any[];
}

export interface display-banners-extraInfos-1899231130 {
}

export interface categories418912338 {
  /** 카테고리 목록(계층) */
  multiLevelCategories?: any[];
  /** 카테고리 목록 */
  flatCategories?: any[];
}

export interface products-productNo-inquiries-187429000 {
  /** 상품문의 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface products-productNo-product-reviews-reviewNo-100549583 {
  /** 상품평 총 개수 */
  productTotalCount?: number;
  /** 본인 여부 */
  myReview?: boolean;
  /** 작성 플랫폼 */
  platformType?: string;
  /** 외부 사이트 명 */
  siteName?: string;
  /** 작성자 이름 */
  memberName?: string;
  /** 상품평 내용 */
  content?: string;
  /** 공급자 유형 */
  providerType?: string;
  /** 상품명 */
  productName?: string;
  /** 태그값 번호 */
  tagValueNos?: any[];
  /** 수정일 */
  updateYmdt?: string;
  /** 베스트 상품평 여부 ( 우수상품평:Y , 일반상품평:N ) */
  bestReviewYn?: string;
  /** 평점 */
  rate?: number;
  /** 상품 대표 이미지 */
  imageUrl?: string;
  /** 리뷰 번호 */
  reviewNo?: number;
  /** 작성자 닉네임 */
  nickname?: string;
  /** 회원등급 노출 설정 (null 인경우 비회원 포함 노출) */
  memberGradeDisplayInfo?: Record<string, any>;
  tagValues?: any[];
  /** 상품 번호 */
  productNo?: number;
  /** 등록일 */
  registerYmdt?: string;
  /** 회원 id */
  memberId?: string;
  /** 브랜드 명 */
  brandName?: string;
  /** 추천가능여부 */
  recommendable?: boolean;
  /** 블라인드 수 */
  blindReportCnt?: number;
  /** 신고 취소 여부 */
  cancelReportable?: string;
  /** 외부 사이트에서 작성된 리뷰 날짜 (nullable) */
  originRegisterYmdt?: string;
  /** 휴면 회원 여부 */
  expelled?: boolean;
  /** 신고 수 */
  reportCnt?: number;
  /** 첨부파일 url 리스트 */
  fileUrls?: any[];
  /** 상품 이미지 URL 타입 */
  imageUrlType?: string;
  /** 신고가능여부 */
  reportable?: boolean;
  /** 회원그룹 노출 설정 (null 인경우 비회원 포함 노출) */
  memberGroupDisplayInfo?: Record<string, any>;
  /** 외부 작성 여부 */
  externalReview?: boolean;
  orderedOption?: Record<string, any>;
  /** 추천 수 */
  recommendCnt?: number;
  /** 상품평의 댓글 개수 */
  commentCount?: number;
  /** 외부 상품 상세 url */
  productDetailUrl?: string;
  /** 상품 삭제 여부 */
  isDeletedProductReview?: boolean;
  /** 상품 할인 가격 */
  productDiscountPrice?: number;
  /** 브랜드 명(영문) */
  brandNameEn?: string;
  /** 상품 평점 */
  productRate?: number;
  /** 영문상품명 */
  productNameEn?: string;
  /** 적립금 지급 여부 */
  givenAccumulationYn?: string;
  /** 상품평 작성 리뷰 */
  extraJson?: string;
  /** 작성자 명 */
  registerName?: string;
  /** 판매상태 */
  saleStatusType?: string;
}

export interface products-productNo-inquiries-report-435925452 {
  /** 신고타입 (COPYRIGHT: 저작권 침해 및 기타사유, SLANDER: 욕설 또는 비방, ETC: 기타) */
  reportType?: string;
  /** 신고사유 상세 */
  reason?: string;
  /** 상품평 번호 */
  inquiryNo?: number;
}

export interface display-events-238668938 {
  contents?: any[];
  /** 총 페이지 수 */
  totalPage?: number;
  /** 총 이벤트 수 */
  totalCount?: number;
}

export interface reviews-tags2060315899 {
  /** 상품문의 태그정보 */
  reviewTags?: any[];
}

export interface products-productNo-inquiries-inquiryNo-589368729 {
  /** 상품관리코드 */
  productManagementCd?: string;
  /** 답변 여부 */
  replied?: boolean;
  answers?: any[];
  /** 상품문의 타입 */
  type?: string;
  /** 문의 제목 */
  title?: string;
  /** 상품명 */
  productName?: string;
  /** provider Type (페이코:PAYCO, 네이버:NAVER, 카카오:KAKAO, 페이스북:FACEBOOK, 아이엠스쿨:IAMSCHOOL,리브메이트:LIIVMATE, 엔에이치엔엔터:NHNENT, 유니원:UNIONE, 라인:LINE, 엔씨피스토어:NCPSTORE, 카카오싱크:KAKAO_SYNC) */
  providerType?: string;
  /** 문의 내용 */
  content?: string;
  /** 회원번호 */
  registerNo?: number;
  /** 태그값번호 */
  tagValueNos?: any[];
  /** 관리자 여부 */
  administrator?: boolean;
  /** 상품문의 수정 일자 */
  updateYmdt?: string;
  /** 차단여부 */
  blocked?: boolean;
  /** 상품 이미지 url */
  imageUrl?: string;
  /** 상품문의 수정 가능 여부 */
  modifiable?: boolean;
  imageUrlInfo?: Record<string, any>;
  /** 상품번호 */
  productNo?: number;
  /** 상품문의 등록 일자 */
  registerYmdt?: string;
  /** 작성자 아이디 */
  memberId?: string;
  /** 작성자 등급 */
  gradeLabel?: string;
  /** 상품 브랜드명 */
  brandName?: string;
  /** 신고 취소 여부 */
  cancelReportable?: string;
  /** 주문번호 */
  orderNo?: string;
  /** 작성자 탈퇴 여부 */
  expelled?: boolean;
  /** 작성자 닉네임 */
  nickName?: string;
  /** 내 상품문의 여부 */
  myInquiry?: boolean;
  /** 비밀글 여부 */
  secreted?: boolean;
  /** 상품 브랜드 영문명 */
  brandNameEn?: string;
  /** 영문상품명 */
  productNameEn?: string;
  /** 작성자 명 */
  registerName?: string;
  /** 전시 상태 */
  displayStatusType?: string;
  /** 상품문의 번호 */
  inquiryNo?: number;
}

export interface products-productNo-product-reviews-696898356 {
  /** 태그값 번호 */
  tagValueNos?: any[];
  /** 첨부파일 url 리스트 */
  urls?: any[];
  /** 상품평 평점 */
  rate?: number;
  /** 상품평 선택 옵션 */
  extraJson?: string;
  /** 옵션 번호 */
  optionNo?: number;
  /** 주문 옵션 번호 */
  orderOptionNo?: number;
  /** 상품평 내용 */
  content?: string;
}

export interface products-productNo-product-reviews-summary674175892 {
  /** 상품리뷰 평점 구간별 매칭 상품수 */
  summaryCount?: any[];
}

export interface display-banners-id-bannerSectionIds-1694323649 {
}

export interface products-productNo-inquiries-1927689253 {
  /** 상품문의 태그값 번호 */
  tagValueNos?: any[];
  /** 대댓글 경우만 전송(부모 상품문의 번호) */
  parentInquiryNo?: number;
  /** 상품문의 유형 (상품: PRODUCT, 배송: DELIVERY, 취소: CANCEL, 반품: RETURN, 교환: EXCHANGE, 환불: REFUND, 기타: OTHER) */
  type?: string;
  /** 상품문의 제목(선택) */
  title?: string;
  /** 비밀글 여부 */
  secreted?: boolean;
  /** 이메일 (입력시 회원 정보의 이메일이 아닌 입력한 주소로 답변 발송) */
  email?: string;
  /** 상품문의 내용(필수) */
  content?: string;
  /** 상품번호 */
  productNo?: number;
}

export interface products-productNo-product-reviews2040766945 {
  /** 리뷰 평점 */
  rate?: number;
  reviewRatingResponses?: any[];
  /** 총 개수 (nullable) */
  totalCount?: number;
  items?: any[];
}

export interface skin-banners843334151 {
}

export interface products-productNo-product-reviews-reviewNo-comments1059775209 {
  contents?: any[];
  /** 총 페이지수 */
  totalPage?: number;
  /** 총 개수 */
  totalCount?: number;
}

export interface reviews-boards-reviewed-products-514787436 {
  /** 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface display-sections-sectionNo1573109124 {
  /** 진열 이미지 - 오른쪽 여백 색상 */
  rightSpaceColor?: string;
  /** 진열 이미지 - 왼쪽 여백 색상 */
  leftSpaceColor?: string;
  /** 상품 진열 설명 */
  sectionExplain?: string;
  /** 진열 이미지 URL */
  imageUrl?: string;
  /** 진열명 */
  label?: string;
  /** 진열번호 */
  sectionNo?: number;
  /** 홍보문구 */
  promotionText?: string;
}

export interface profile-product-inquiries1476880079 {
  /** 상품문의 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface product-reviews-configurations2007988454 {
  /** 답글 사용 가능 여부 */
  canReply?: boolean;
  /** 게시판 게시판 유형 */
  boardType?: string;
  /** 게시판 이미지 유형 */
  boardImageType?: string;
  /** 게시판 설명 */
  description?: string;
  /** 상품평 게시판 사용 여부 */
  boardUsable?: boolean;
  /** 첨부 사용 가능 여부 */
  canAttach?: boolean;
  /** 게시판 추가 설정 */
  expandedReviewConfig?: Record<string, any>;
  /** 회원 작성 가능 여부 */
  memberWriteable?: boolean;
  /** 비밀글 사용 가능 여부 */
  secretUsable?: boolean;
  /** 게시판 명 */
  name?: string;
  /** 댓글 사용 가능 여부 */
  canComment?: boolean;
  /** 비회원 작성 가능 여부 */
  guestWriteable?: boolean;
  /** 적립금 정보 */
  reviewAccumulationInfo?: Record<string, any>;
}

export interface products-productNo-inquiries-1347180552 {
  /** 문의 번호 */
  inquiryNo?: number;
}

export interface display-events-close2003620640 {
  /** 종료된 이벤트 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface categories-categoryNo723451856 {
  /** 카테고리 목록(계층) */
  multiLevelCategories?: any[];
  /** 요청한 카테고리 번호 */
  requestedCategoryNo?: number;
  /** 카테고리 목록 */
  flatCategories?: any[];
}

export interface design-popups1978681768 {
}

export interface design-popups-1787544529 {
  /** 노출 URL - 현재 접속 경로 (도메인 제외) */
  displayUrl?: string;
  /** 팝업ID (nullable) */
  popupId?: string;
  /** 파라미터 - 현재 접속한 경로의 파라미터가 존재할 경우 (urlencoded UTF-8) (nullable) */
  parameter?: string;
}

export interface products-productNo-product-reviews-358814467 {
  /** 리뷰 평점 */
  rate?: number;
  /** 총 개수 (nullable) */
  totalCount?: number;
  items?: any[];
}

export interface products-productNo-product-reviews-summary-1039766810 {
  /** 리뷰평점 범위(미요청시 0.0-1.0, 1.0-2.0, 2.0-3.0, 3.0-4.0, 4.0-5.0) */
  ranges?: any[];
}

export interface products-inquiries-inquiryNo-334387342 {
  /** 상품문의 태그값번호 */
  tagValueNos?: any[];
  /** 상품문의 유형 (상품: PRODUCT, 배송: DELIVERY, 취소: CANCEL, 반품: RETURN, 교환: EXCHANGE, 환불: REFUND, 기타: OTHER) */
  type?: string;
  /** 상품문의 제목(선택) */
  title?: string;
  /** 비밀글 여부 */
  secreted?: boolean;
  /** 상품문의 내용(필수) */
  content?: string;
}

export interface products-productNo-product-reviews1565975090 {
  /** 상품평 번호 */
  reviewNo?: number;
}

export interface stickers-1137518374 {
}

export interface products-productNo-photo-reviews-47897267 {
  contents?: any[];
  /** 총 페이지수 */
  totalPage?: number;
  /** 총 개수 */
  totalCount?: number;
}

export interface products-inquiries-634019235 {
  /** 상품문의 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface reviews-boards405455552 {
  /** 총 개수 */
  totalCount?: number;
  items?: any[];
}

export interface display-sections-981228947 {
  /** 진열정보 */
  sections?: any[];
}

export interface products-inquiries-configurations-1676498461 {
  /** 답글 사용 가능 여부 (true: 답글 가능, false:답글 불가) */
  canReply?: boolean;
  /** 게시판 게시판 유형 */
  boardType?: string;
  /** 회원 작성 가능 여부 (true: 회원 작성가능, false:회원 작성불가 */
  memberWriteable?: boolean;
  /** 게시판 이미지 유형 */
  boardImageType?: string;
  /** 비밀글 사용 가능 여부 (true: 비밀글 사용가능, false:비밀글 사용불가 */
  secretUsable?: boolean;
  /** 게시판 명 */
  name?: string;
  /** 게시판 설명 */
  description?: string;
  /** 상품평 게시판 사용 여부 (true: 사용가능, false: 사용불가 */
  boardUsable?: boolean;
  /** 비회원 작성 가능 여부 (true: 비회원 작성가능, false:비회원 작성불가 */
  guestWriteable?: boolean;
  /** 첨부 사용 가능 여부 (true: 첨부 기능 사용가능, false:첨부 기능 사용불가) */
  canAttach?: boolean;
}

export interface profile-product-inquiries-count1116014589 {
}

export interface display-events-products-1412841423 {
}

export interface display-events-ids-eventId-1198910990 {
  /** 쿠폰 정보 */
  coupon?: Record<string, any>;
  /** 섹션 정보 */
  section?: any[];
  /** 전시 종료일 */
  endYmdt?: string;
  /** 기획전 명 */
  label?: string;
  /** 전시기간 타입 */
  displayPeriodType?: string;
  /** 기획전 url */
  url?: string;
  /** 홍보문구 */
  promotionText?: string;
  /** 기획전 번호 */
  eventNo?: number;
  /** 기획전 이미지 URL(PC) */
  pcImageUrl?: string;
  /** 전시 시작일 */
  startYmdt?: string;
  /** URL 타입 */
  urlType?: string;
  top?: Record<string, any>;
  /** 기획전 이미지 URL(MOBILE) */
  mobileimageUrl?: string;
  /** 쿠폰, 상단 노출 정보 정렬순서(배열 순서대로 프론트에서 노출, 몰마다 정책이 다를수 있음) */
  orders?: any[];
  /** 이벤트 여부 */
  eventYn?: string;
  /** 검색용 태그값 */
  tag?: string;
  /** 기획전 ID */
  id?: string;
  /** 카테고리 번호(배열) */
  categoryNos?: any[];
}

export interface products-productNo-reviewable-options985499075 {
  item?: any[];
  /** 상품평 가능 여부 (상품평 작성 불가능한 상품 여부 관계없이 구매이력이 있고 해당 구매건의 리뷰를 작성하지 않은 경우에 true 로 표기) */
  reviewable?: boolean;
}

export interface display-events-ids-eventId1326201074 {
  /** 쿠폰 정보 */
  coupon?: Record<string, any>;
  /** 섹션 정보 */
  section?: any[];
  /** 전시 종료일 */
  endYmdt?: string;
  /** 기획전 명 */
  label?: string;
  /** 전시기간 타입 */
  displayPeriodType?: string;
  /** 기획전 url */
  url?: string;
  /** 홍보문구 */
  promotionText?: string;
  /** 기획전 번호 */
  eventNo?: number;
  /** 기획전 이미지 URL(PC) */
  pcImageUrl?: string;
  /** 전시 시작일 */
  startYmdt?: string;
  /** URL 타입 */
  urlType?: string;
  top?: Record<string, any>;
  /** 기획전 이미지 URL(MOBILE) */
  mobileimageUrl?: string;
  /** 쿠폰, 상단 노출 정보 정렬순서(배열 순서대로 프론트에서 노출, 몰마다 정책이 다를수 있음) */
  orders?: any[];
  /** 이벤트 여부 */
  eventYn?: string;
  /** 검색용 태그값 */
  tag?: string;
  /** 기획전 ID */
  id?: string;
  /** 카테고리 번호(배열) */
  categoryNos?: any[];
}

export interface categories-new-product-categories1488064972 {
}

export interface products-productNo-product-reviews-reviewNo-277044605 {
  /** 태그값번호 */
  tagValueNos?: any[];
  /** 첨부파일 url 리스트 */
  urls?: any[];
  /** 상품평 평점 */
  rate?: number;
  /** 상품평 내용 */
  content?: string;
}

