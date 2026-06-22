// Auto-generated TypeScript types from marketing-server

export interface campaigns869981354 {
  /** 연동정보(고도 상점번호) */
  godosno?: number;
  /** 캠페인 상태 */
  status?: string;
}

export interface marketing-products-settings1592297693 {
  /** 네이버 쇼핑 설정 상품^|[MarketingProductSettings(productNo=10000001, additionalInfo={}), MarketingProductSettings(productNo=10000002, additionalInfo={})] */
  marketingProductSettings?: any[];
}

export interface marketing-display-1028540568 {
  exposureProducts?: any[];
}

export interface campaigns1904911364 {
  /** 캠페인 시작일시 */
  startDateTime?: string;
  /** 캠페인 종료일 */
  endDate?: string;
  /** 일 단위의 캠페인 평균 예산 */
  dailyBudget?: number;
  /** 캠페인 이름 */
  name?: string;
  /** 캠페인 종료일시 */
  endDateTime?: string;
  /** 캠페인이 속한 쇼핑몰 번호 */
  mallNo?: number;
  /** 캠페인 번호 */
  campaignNo?: number;
  /** 캠페인 시작일 */
  startDate?: string;
  /** 캠페인 상태 */
  status?: string;
}

export interface marketing-product273182022 {
  /** 네이버쇼핑 추가 정보 */
  additionalInfo?: Record<string, any>;
  /** 마케팅채널에 노출 여부 */
  displayable?: string;
  /** 마케팅 채널 타입(NAVER_SHOPPING, FACEBOOK) */
  channelType?: string;
  /** 쇼핑몰 번호 */
  mallNo?: number;
  /** 상품 번호 */
  productNo?: number;
}

