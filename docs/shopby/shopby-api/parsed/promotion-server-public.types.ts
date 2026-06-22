// Auto-generated TypeScript types from promotion-server

export interface coupons-couponNo-1369532420 {
  /** 상품 쿠폰 상세 */
  productCouponDetail?: Record<string, any>;
  /** 장바구니 쿠폰 상세 */
  cartCouponDetail?: Record<string, any>;
  /** 쿠폰 사유^|for test */
  reason?: string;
  /** 쿠폰명^|test coupon */
  couponName?: string;
  /** 기프트 쿠폰 상세 */
  giftCouponDetail?: Record<string, any>;
  /** 혜택 구분 타입^|CART */
  couponType?: string;
  /** 사용 제약사항 */
  usableConstraint?: Record<string, any>;
  /** 쿠폰 할인정보 */
  discount?: Record<string, any>;
  /** 발급 제약사항 */
  issuableConstraint?: Record<string, any>;
}

export interface coupons-issues-1004695170 {
  contents?: any[];
  /** 총 개수^|1 */
  totalCount?: number;
}

export interface coupons-targets616348469 {
  contents?: any[];
  /** 총 페이지^|1 */
  totalPage?: number;
  /** 총 개수^|1 */
  totalCount?: number;
}

export interface coupons-issues-1903045413 {
  /** 발급 사유^|생일쿠폰 발급 */
  reason?: string;
  /** 회원 번호 리스트 (최대 1,000명)^|[1,2,3] */
  memberNos?: any[];
  /** 쿠폰 번호^|1 */
  couponNo?: number;
  /** 어드민 발급 여부 (개발중)^|true */
  isAdminIssue?: boolean;
  /** 쿠폰 번호 리스트 (최대 10건)^|[1,2,3] */
  couponNos?: any[];
  /** [개발중] 발급 수량 (기본값: 1)^|1 */
  issueCount?: number;
  /** 회원 ID 리스트^|["test1","test2","test3"] */
  memberIds?: any[];
}

export interface coupons-1711516014 {
  /** 생성된 쿠폰 번호^|1 */
  couponNo?: number;
}

export interface coupons-use-458945078 {
}

export interface coupons-use-1764910307 {
}

export interface coupons-couponNo-1535876060 {
  /** 장바구니 쿠폰상세 */
  cartCouponDetail?: Record<string, any>;
  /** 쿠폰 사유^|for test */
  reason?: string;
  /** 쿠폰 이름^|test coupon name */
  couponName?: string;
  /** 쿠폰상태^|ISSUE_END */
  statusType?: string;
  /** 쿠폰 요약 */
  couponSummary?: Record<string, any>;
  /** 사용 제약사항 */
  usableConstraint?: Record<string, any>;
  /** 쿠폰 할인정보 (nullable) */
  discount?: Record<string, any>;
  /** 발급 제약사항 */
  issuableConstraint?: Record<string, any>;
  /** 상품쿠폰 상세 */
  productCouponDetail?: Record<string, any>;
  /** 예약 지급 여부(true: 예약지급, false: 예약지급 아님)^|false */
  isScheduledIssuePlan?: boolean;
  /** 기프트 쿠폰 상세 */
  giftCouponDetail?: Record<string, any>;
  /** 수량 만료 여부(true: 만료, false: 만료 아님)^|false */
  isCountOver?: boolean;
  /** 쿠폰 하위 타입 - CART(장바구니 쿠폰), DELIVERY_DEFAULT(기본 배송비 쿠폰), DELIVERY_ALL(전체 배송비 쿠폰), NONE(장바구니 쿠폰 외)^|NONE */
  couponSubType?: string;
  /** 오늘 발급 수^|1 */
  todayIssueCnt?: number;
  /** 혜택 구분 타입^|CART */
  couponType?: string;
}

export interface coupons-withdraw187298523 {
  /** 철회 사유^|테스트 */
  reason?: string;
  /** 쿠폰 지급 번호^|1 */
  couponIssueNo?: number;
}

export interface coupons-issues-194375905 {
}

export interface coupons-use-rollback-141309845 {
  /** 쿠폰 지급 번호 리스트^|1 */
  couponIssueNos?: any[];
}

export interface coupons-186158211 {
  contents?: any[];
  /** 전체 쿠폰 수^|544844 */
  totalCount?: number;
}

export interface coupons-couponNo-use-stop1789105598 {
  /** 쿠폰 사용중지 여부 (사용중지 : true, 사용재개 : false)^|true */
  useStopped?: boolean;
}

export interface coupons-withdraw-bulk765073540 {
  /** 지급 철회 사유^|지급 오류 */
  withdrawReason?: string;
  /** 지급 조회 시작일^|2025-09-29 */
  issueStartYmd?: string;
  /** 쿠폰 번호^|1 */
  couponNo?: number;
  /** 지급 조회 종료일^|2025-09-29 */
  issueEndYmd?: string;
}

export interface coupons-2077927525 {
  /** 상품쿠폰 상세 */
  productCouponDetail?: Record<string, any>;
  /** 장바구니 쿠폰상세 */
  cartCouponDetail?: Record<string, any>;
  /** 쿠폰 발급 사유^|for test */
  reason?: string;
  /** 쿠폰 이름^|test coupon name */
  couponName?: string;
  /** 기프트 쿠폰 상세 */
  giftCouponDetail?: Record<string, any>;
  /** 쿠폰 하위 타입 - CART(장바구니 쿠폰), DELIVERY_DEFAULT(기본 배송비 쿠폰), DELIVERY_ALL(전체 배송비 쿠폰), NONE(장바구니 쿠폰 외)^|NONE */
  couponSubType?: string;
  /** 혜택 구분 타입^|CART */
  couponType?: string;
  /** 사용 제약사항 */
  usableConstraint?: Record<string, any>;
  /** 쿠폰 할인정보 (nullable) */
  discount?: Record<string, any>;
  /** 발급 제약사항 */
  issuableConstraint?: Record<string, any>;
  /** 몰정보^|1 */
  mallNo?: number;
}

export interface coupons-codes-958981943 {
  contents?: any[];
  /** 전체 쿠폰 수^|544844 */
  totalCount?: number;
}

