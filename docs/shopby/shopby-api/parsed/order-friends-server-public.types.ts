// Auto-generated TypeScript types from order-friends-server

export interface statistics-sales-product1026505609 {
  /** 판매통계 상품별 목록 */
  contents: any[];
  /** 판매통계 상품별 총 개수 */
  totalCount: number;
}

export interface statistics-sales-period163244397 {
  /** 판매통계 일자별 목록 */
  contents: any[];
  /** 판매통계 일자별 총 개수 */
  totalCount: number;
}

export interface cs1493835005 {
  /** 조회 결과 */
  contents: any[];
  /** 전체 조회건수 */
  totalCount: number;
}

export interface settlement292649878 {
}

export interface orders-sales547821119 {
  /** 총 조회 건수^|1 */
  totalCount: number;
  /** 쇼핑몰 매출 데이터 */
  items?: any[];
}

export interface statistics-sales-period-summary2027962557 {
  /** 판매통계 요약정보 */
  summary: Record<string, any>;
  /** 파트너번호 */
  partnerNo: number;
  /** 조회시작일^|2020-04-22 */
  startYmd: string;
  /** 조회종료일^|2020-05-22 */
  endYmd: string;
  /** 전시브랜드 번호 */
  displayBrandNo: number;
  /** 몰번호 */
  mallNo: number;
  /** 판매통계 프로모션 요약정보 */
  promotionSummary: Record<string, any>;
}

export interface settlement-detail-1949787227 {
  /** 데이터 */
  contents: any[];
  /** 총 페이지 수^|10 */
  totalPage: number;
  /** 총 데이터 개수^|100 */
  totalCount: number;
}

export interface statistics-promotions-337367269 {
  /** 프로모션 통계 주문 쿠폰 목록 */
  contents: any[];
  /** 프로모션 통계 주문 쿠폰 총 개수 */
  totalCount: number;
}

export interface statistics-promotions-detail999899910 {
}

