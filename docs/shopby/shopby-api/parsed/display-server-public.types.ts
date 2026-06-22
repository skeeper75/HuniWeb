// Auto-generated TypeScript types from display-server

export interface reviews-product-reviews756382224 {
}

export interface reviews-best-review1374636712 {
  /** 베스트 리뷰 여부 */
  bestReviewYn?: string;
  /** 상품평 번호 리스트 (배열 : [1,2,3]) */
  reviewNos?: any[];
}

export interface reviews-product-reviews-1210174375 {
  /** 수정 실패 */
  failures?: any[];
  /** 수정된 리뷰 번호 */
  successNos?: any[];
  /** 요청 개수 */
  totalCount?: number;
}

export interface banners-groups-1471844524 {
}

export interface reviews-external-site1712498945 {
  /** 등록 실패 */
  failures?: any[];
  /** 생성된 리뷰 번호 */
  successNos?: any[];
  /** 요청 개수 */
  totalCount?: number;
}

export interface reviews-1312461930 {
  /** 컨텐츠 */
  contents?: any[];
  /** 전체 페이지 수 */
  totalPage?: number;
  /** 검색 기준 값 */
  lastId?: string;
  /** 전체 상품평 수 */
  totalCount?: number;
}

export interface banners-extraInfo1993007774 {
}

export interface banners1910677108 {
}

export interface reviews-extraJson1198411255 {
}

export interface categories-display-categories-1596596913 {
}

export interface banners1049799116 {
  /** 배너 섹션 ID */
  bannerSectionId?: string;
  bannerAccounts?: any[];
  /** 배너 섹션명 */
  bannerSectionName?: string;
  memberGradeDisplayInfo?: Record<string, any>;
  memberGroupDisplayInfo?: Record<string, any>;
  platformDisplay?: Record<string, any>;
  /** 배너그룹 번호 */
  groupNo?: number;
}

export interface stickers-1355996430 {
  contents?: any[];
  /** 전체 페이지 수 */
  totalPage?: number;
  /** 전체 스티커 수 */
  totalCount?: number;
}

export interface reviews-product-reviews-2114200230 {
  /** 삭제 실패 */
  failures?: any[];
  /** 삭제된 리뷰 번호 */
  successNos?: any[];
  /** 요청 개수 */
  totalCount?: number;
}

export interface categories-1596124036 {
}

export interface reviews-external-site-1657229360 {
}

export interface events1968241914 {
  contents?: any[];
  /** 전체 페이지 수 */
  totalPage?: number;
  /** 전체 게시물 수 */
  totalCount?: number;
}

export interface inquiry-replies-1796672765 {
}

export interface reviews-status1927414927 {
  /** 상품평 번호 리스트 (배열 : [1,2,3]) */
  reviewNos?: any[];
  /** 전시 상태 */
  displayStatusType?: string;
}

export interface reviews-product-reviews-531311430 {
}

export interface events-eventNo1459448141 {
  /** 모바일 상단이미지 노출 설정 */
  mobileImageDetail?: Record<string, any>;
  /** 수정자번호 */
  updateAdminNo?: number;
  /** 기획전 번호 */
  eventNo?: number;
  eventSections?: any[];
  eventConfigDisplayOrder?: Record<string, any>;
  /** 기획전 이름 (nullable) */
  eventName?: string;
  memberGradeDisplayInfo?: Record<string, any>;
  /** 태그 (nullable) */
  tag?: string;
  /** 등록일 */
  registerYmdt?: string;
  /** 기획전 ID (nullable) */
  eventId?: string;
  /** 담당자 번호 */
  adminNo?: number;
  /** 기획전 상세 URL (nullable) */
  eventUrl?: string;
  eventCoupons?: any[];
  eventDisplayPeriod?: Record<string, any>;
  memberGroupDisplayInfo?: Record<string, any>;
  /** 기획전 유형 */
  eventType?: string;
  /** 모바일 대표 이미지 (nullable)^|https://shopby-images.cdn-nhncommerce.com/SERVICE/20190527/c393484292d4130e99bdce6e2e5566c9(1).jpg */
  mainMobileImageUrl?: string;
  platformDisplay?: Record<string, any>;
  /** 홍보문구 (nullable) */
  promotionText?: string;
  eventCommonCouponImage?: Record<string, any>;
  /** 기획전 상세 URL 타입 (nullable) */
  eventUrlType?: string;
  /** 연관 전시 카테고리 리스트 */
  displayCategoryMappings?: any[];
  /** PC 상단이미지 노출 설정 */
  pcImageDetail?: Record<string, any>;
  /** 쿠폰 사용여부 */
  couponYn?: string;
  /** 서비스번호 */
  serviceNo?: number;
  /** 이벤트 여부 */
  eventYn?: string;
  /** 몰번호 */
  mallNo?: number;
  /** PC 대표 이미지 (nullable)^|https://shopby-images.cdn-nhncommerce.com/SERVICE/20190527/c393484292d4130e99bdce6e2e5566c9(1).jpg */
  mainPcImageUrl?: string;
}

export interface inquiry-1510229302 {
}

export interface inquiry-inquiryNo-display-status-1294323154 {
  /** 전시 상태 변경 사유 */
  reason?: string;
  /** 변경할 전시 상태 */
  displayStatusType?: string;
}

export interface reviews-991924649 {
  /** 삭제된 상품평 조회 여부 (default:false) (nullable) */
  hasDeleted?: string;
  /** 작성일시 시작 (입력 안 할 경우 3개월 전) (nullable) */
  startYmd?: string;
  /** 작성일시 끝 (입력 안 할 경우 오늘) (nullable) */
  endYmd?: string;
  /** 한 페이지에 조회되는 상품평 갯수 (nullable) */
  size?: number;
  /** 전체카운트 수 조회 여부 (default:false) (nullable) */
  hasTotalCount?: number;
  /** 검색 유형 [REVIEW_NO: 상품평번호(default) | PRODUCT_NO:상품번호] (nullable) */
  searchType?: string;
  /** 회원검색조건 */
  member?: Record<string, any>;
  /** 검색 기준 값(lastId) (nullable) */
  searchAfter?: string;
  /** 날짜 검색 유형 [REGISTER:등록일(default) | UPDATE:수정일] (nullable) */
  dateSearchType?: string;
  /** 페이지 번호 (nullable) */
  page?: number;
  /** 검색하고자하는 번호 (여러건의 경우','로 연결하여 입력) (nullable) */
  keyword?: string;
}

export interface inquiry-inquiryNo-reply1116014589 {
}

export interface categories-display-categories-tree-1227132063 {
}

export interface reviews-product-reviews-792514440 {
  /** 등록 실패 */
  failures?: any[];
  /** 생성된 리뷰 번호 */
  successNos?: any[];
  /** 요청 개수 */
  totalCount?: number;
}

export interface reviews473435012 {
  /** 컨텐츠 */
  contents?: any[];
  /** 전체 페이지 수 */
  totalPage?: number;
  /** 검색 기준 값 */
  lastId?: string;
  /** 전체 상품평 수 */
  totalCount?: number;
}

export interface banners-simple-infos139954922 {
  contents?: any[];
}

export interface reviews-best-review2140100592 {
  /** 변경 성공한 상품평 번호 */
  successReviewNos?: any[];
  /** 변경 성공한 상품평 작성자 번호 */
  updatedRegisterNos?: any[];
  /** 변경 실패한 상품평 정보^|[UpdateReviewResult(reviewNo=2, updateResultCode=NOT_EXIST), UpdateReviewResult(reviewNo=3, updateResultCode=ALREADY_DELETED)] */
  failReviewResults?: any[];
}

export interface banners-bannerNo77497825 {
  /** 배너 섹션 ID */
  bannerSectionId?: string;
  bannerAccounts?: any[];
  /** 배너 섹션명 */
  bannerSectionName?: string;
  memberGradeDisplayInfo?: Record<string, any>;
  memberGroupDisplayInfo?: Record<string, any>;
  platformDisplay?: Record<string, any>;
  /** 배너그룹 번호 */
  groupNo?: number;
}

