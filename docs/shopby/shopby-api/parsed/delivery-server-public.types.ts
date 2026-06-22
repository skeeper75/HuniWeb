// Auto-generated TypeScript types from delivery-server

export interface deliveries-323369351 {
}

export interface deliveries-template-groups-templateGroupNo1392913703 {
  /** 배송 불가능한 국가 리스트^|[KR, CN, JP] */
  undeliverableCountries?: any[];
  /** 사용할 지역별 추가배송비 번호^|1 */
  areaFeeNo?: number;
  /** 배송비 템플릿 그룹 선택 유형^|MINIMUM_SELECTED */
  groupDeliveryAmtType?: string;
  /** 수정할 템플릿 리스트 */
  modifyTemplates?: any[];
  /** 그룹명^|그룹1 */
  name?: string;
  /** 지역별 추가배송비 사용 여부^|false */
  usesAreaFee?: boolean;
  /** 배송비 결제 선불 여부^|true */
  prepaid?: boolean;
  /** 삭제할 템플릿 번호^|[1,2,3] */
  deleteTemplateNos?: any[];
  /** 추가할 템플릿 리스트 */
  addTemplates?: any[];
}

export interface deliveries-template-groups1608125329 {
  /** 배송 불가능한 국가 리스트^|[KR, CN, JP] */
  undeliverableCountries?: any[];
  /** 사용할 지역별 추가배송비 번호^|1 */
  areaFeeNo?: number;
  /** 배송비 템플릿 그룹 선택 유형^|MINIMUM_SELECTED */
  groupDeliveryAmtType?: string;
  /** 추가할 템플릿 내역 */
  templates?: any[];
  /** 그룹명^|그룹1 */
  name?: string;
  /** 지역별 추가배송비 사용 여부^|false */
  usesAreaFee?: boolean;
  /** 배송비 결제 선불 여부^|true */
  prepaid?: boolean;
  /** 통화 정보 (nullable)^|KRW */
  currencyCode?: string;
}

export interface areafees-82223564 {
  /** 지역별 추가배송비 내역 */
  contents?: any[];
  /** 지역별 추가배송비 설정 개수^|2 */
  totalCount?: number;
}

export interface areafees20396953 {
  /** 국가코드^|KR */
  countryCd?: string;
  /** 지역별 추가배송비 명^|testArea */
  name?: string;
  /** 지역별 추가배송비 상세 */
  details?: any[];
  /** 통화 정보 (nullable)^|KRW */
  currencyCode?: string;
}

export interface deliveries-template-groups1180750672 {
  /** 배송비 템플릿 그룹 요약^|묶음배송비 산출방식: 최대부과, 결제방식: 선결제, 지역별 추가배송비: 사용안함 */
  summary?: string;
  /** 그룹 노출 순서^|1 */
  displayNo?: number;
  /** 배송비 템플릿 그룹 선택 유형^|MINIMUM_SELECTED */
  groupDeliveryAmtType?: string;
  /** 템플릿 내역 */
  templates?: any[];
  /** 지역별 추가배송비 상세 */
  areaFee?: Record<string, any>;
  /** 배송비 템플릿 그룹명^|테스트그룹 */
  name?: string;
  /** 배송비 선결제 여부^|true */
  prepaid?: boolean;
  /** 배송비 템플릿 그룹번호^|152 */
  templateGroupNo?: number;
  /** 통화 정보 (nullable)^|KRW */
  currencyCode?: string;
}

export interface deliveries-template-groups1699109495 {
}

export interface warehouses530577803 {
  /** 요약 */
  summary?: string;
  /** 대표 출고지 여부^|false */
  defaultReleaseWarehouse?: boolean;
  /** 주소 */
  address?: Record<string, any>;
  /** 입출고 주소명^|한강뷰 창고 */
  name?: string;
  /** 대체문구^|우체국 택배로 빠른시간에 보내드립니다. */
  substitutionText?: string;
  /** 대표 반품지 여부^|false */
  defaultReturnWarehouse?: boolean;
  /** 등록일 */
  registerYmdt?: string;
  /** 입출고 주소 번호^|1 */
  warehouseNo?: number;
}

export interface areas864143670 {
}

export interface areafees-areaFeeNo-642934700 {
  /** 지역별 추가배송비 번호^|1 */
  areaFeeNo?: number;
  /** 국가명^|대한민국 */
  countryCdLabel?: string;
  /** 국가코드^|KR */
  countryCd?: string;
  /** 지역별 추가배송비 명^|testArea */
  name?: string;
  /** 지역별 추가배송비 상세 */
  details?: any[];
  /** 추가배송비 설정 지역수^|1 */
  areaCnt?: number;
  /** 통화 정보 (nullable)^|KRW */
  currencyCode?: string;
  /** 등록일시 */
  registerYmdt?: string;
}

export interface deliveries-templates-templateNo-820869304 {
  /** 파트너번호^|1 */
  partnerNo?: number;
  /** 배송비 템플릿 번호^|1 */
  templateNo?: number;
  /** 배송 그룹 명^|기본그룹 */
  groupName?: string;
  /** 기본 템플릿 여부 */
  default?: boolean;
  /** 출고지 */
  releaseWarehouse?: Record<string, any>;
  /** 배송비설정 */
  deliveryFee?: Record<string, any>;
  /** 배송비 템플릿명^|템플릿1 */
  name?: string;
  /** 배송방법 - PARCEL_DELIVERY(택배/등기/소포), DIRECT_DELIVERY(직접배달(화물배송))^|PARCEL_DELIVERY */
  deliveryType?: string;
  /** 배송회사^|CJ */
  deliveryCompanyType?: string;
  /** 반품지 */
  returnWarehouse?: Record<string, any>;
}

export interface warehouses-445768110 {
  /** 입출고 주소 내역 */
  contents?: any[];
  /** 입출고 주소 개수^|2 */
  totalCount?: number;
}

export interface warehouses-605800327 {
  /** 대표 출고지 여부^|false */
  defaultReleaseWarehouse?: boolean;
  /** 대체문구 사용 여부^|false */
  usesSubstitutionText?: boolean;
  /** 주소(대체문구 사용하지 않을 시) */
  address?: Record<string, any>;
  /** 입출고 주소명^|한강뷰 창고 */
  name?: string;
  /** 대체문구(대체문구 사용 시)^|우체국 택배로 빠른시간에 보내드립니다. */
  substitutionText?: string;
  /** 대표 반품/교환지 여부^|false */
  defaultReturnWarehouse?: boolean;
}

