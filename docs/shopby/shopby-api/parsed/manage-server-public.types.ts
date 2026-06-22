// Auto-generated TypeScript types from manage-server

export interface profile-accumulations872905094 {
  /** 외부 키(조회용)(최대 60자) (nullable) */
  externalKey?: string;
  /** 회원 번호(회원 조회용) */
  memberNo?: number;
  /** 지급 상세사유. 생략하면 '운영자 지급' 으로 저장. 200자까지 입력가능. (nullable) */
  reasonDetail?: string;
  /** 적립금 지급 금액 */
  accumulationAmt?: number;
  /** 적립금 만료일. 생략하면 몰 적립금 기본 설정의 적립금 유효기간 반영 */
  expireYmd?: string;
  /** 만료 알림 수단 (복수 설정) [EMAIL, SMS] */
  notificationChannels?: any[];
  /** 회원 아이디(회원 조회용) (nullable) */
  memberId?: string;
}

export interface inquiries-714021068 {
  /** 조회 결과 */
  contents?: any[];
  /** 전체 조회건수 */
  totalCount?: number;
}

export interface profile-accumulations1700228947 {
  /** 차감금액 */
  subtractedAmt?: number;
  /** 회원번호 */
  memberNo?: number;
  /** 생성된 적립금 번호(차감) */
  accumulationNo?: number;
  /** 차감 적립금 관련 적립금정보 */
  subtractionRelatedAccumulations?: any[];
}

export interface kakao-send296080162 {
  /** 치환 텍스트(1depth만 허용합니다.) */
  replaceMap?: Record<string, any>;
  /** 수신자 번호 */
  phoneNum?: string;
  /** 템플릿 코드 */
  templateCode?: string;
  /** 예약전송 시간 */
  reservedTime?: string;
}

export interface inquiries-inquiryNo-answer-495205860 {
  /** 파일 목록 */
  files?: any[];
  /** 임시저장 여부 */
  completed?: boolean;
  /** 답변자 전화번호 */
  mobileNo?: string;
  /** 답변자 이메일 */
  email?: string;
  /** 답변 내용 */
  content?: string;
}

export interface accumulations-assembles1635087197 {
  /** 조회 결과 */
  contents?: any[];
  /** 전체 조회건수 */
  totalCount?: number;
}

export interface profile-accumulations-339742700 {
  /** 회원번호 */
  memberNo?: number;
  /** 생성된 적립금 번호 */
  accumulationNo?: number;
}

export interface accumulations-externals320580630 {
  /** 전체 조회건수 */
  totalCount?: number;
  /** 적립금 내역 */
  items?: any[];
}

export interface profile-accumulations-301787378 {
  /** 회원 번호 */
  memberNo?: number;
  /** 전체 기간 중 해당 고객이 최종적으로 사용 가능한 적립금 금액 */
  totalAmt?: number;
  /** 검색조건을 기준으로 조회된 items 목록의 restAccumulationAmt의 합계금액 */
  itemsTotalRestAmt?: number;
  /** 전체 조회건수 */
  totalCount?: number;
  /** 적립금 내역 */
  items?: any[];
}

export interface accumulations-members-available634575164 {
  /** 회원 아이디 리스트(콤마 구분, 최대 500개) */
  memberIds?: string;
}

export interface accumulations-settlement345426681 {
  /** 전체 조회건수 */
  totalCount?: number;
  /** 적립금 지급/차감 내역 */
  items?: any[];
}

export interface accumulations177281248 {
  /** 전체 조회건수 */
  totalCount?: number;
  /** 적립금 내역 */
  items?: any[];
}

export interface inquiries-types-1290331578 {
  /** 1:1문의 유형 설명 */
  inquiryTypeDescription?: string;
  /** 1:1문의 유형 제목 */
  inquiryTypeName?: string;
}

export interface terms1632415514 {
}

export interface accumulations-members-available-1413144932 {
  /** 조회된 항목 수 */
  count?: number;
  /** 조회 결과 목록 */
  items?: any[];
}

export interface inquiries-types15782989 {
}

export interface accumulations-usage-1532805667 {
}

export interface terms-custom-customTermsNo-members2042102439 {
  /** 회원 목록 */
  contents?: any[];
  /** 전체 데이터 개수 */
  totalCount?: number;
}

