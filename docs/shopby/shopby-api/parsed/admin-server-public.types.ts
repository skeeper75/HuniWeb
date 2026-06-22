// Auto-generated TypeScript types from admin-server

export interface admins1091512367 {
  /** 권한그룹명 */
  authorityGroupName?: string;
  /** 개인정보 열람가능 여부 */
  permitsPrivateInformation?: boolean;
}

export interface partners-exist-admin-id1887798343 {
  /** 중복 확인 결과 */
  result?: boolean;
}

export interface services-1386425601 {
  address?: Record<string, any>;
  /** 서비스 플랜 */
  servicePlan?: string;
  business?: Record<string, any>;
  /** 서비스 이름 */
  serviceName?: string;
  representative?: Record<string, any>;
}

export interface admins-merchandisers-1458267913 {
}

export interface malls-shopby-partner1061824175 {
  /** 파트너 번호 */
  partnerNo?: number;
  /** 파트너 이름 */
  partnerName?: string;
}

export interface partners-partnerNo-12575770 {
  /** 고객 CS 운영자 정보 (nullable)^|CsManagerUpdateRequest(name=홍길동, phoneNo=1800-3859, email=nhn@nhn.com, operationInfo=평일 10:00 ~ 19:00) */
  csManager?: Record<string, any>;
  /** 담당자 정보 (nullable)^|ManagerUpdateRequest(name=최매니저, jobDuty=매니저, jobPosition=대리, department=전자판매A, phoneNo=010-1111-1111, email=) */
  manager?: Record<string, any>;
  /** 사업자 정보 (nullable)^|BusinessUpdateRequest(registrationNo=1234567890, condition=업태, type=업종, onlineMarketingDeclarationNo=111) */
  business?: Record<string, any>;
  /** 접속 허용 IP 주소 (nullable) */
  permittedIpAddress?: string;
  /** 개인정보 관리 책임자 정보 (nullable)^|PrivacyManagerUpdateRequest(name=개인정보책임자, phoneNo=01012341234) */
  privacyManager?: Record<string, any>;
  /** 과세 형태 (nullable) */
  sellerTaxationType?: string;
  /** 회사명(제약조건 - 최대길이: 45) (nullable) */
  companyName?: string;
  /** 정산 담당자 정보 (nullable)^|SettlementManagerUpdateRequest(name=정산담당자, phoneNo=01012341234, email=abcd@gmail.com) */
  settlementManager?: Record<string, any>;
  /** 사무실 주소 정보 (nullable)^|PartnerAddressUpdateRequest(zipCode=12345, address=서울시 구로구 디지털로 26길, detailAddress=72, jibun=도로명 주소, jibunDetail=도로명 주소 상세) */
  office?: Record<string, any>;
  /** 샘플 URL (nullable) */
  sampleUrl?: string;
  /** 팩스 번호(제약조건 -최대길이: 50 ) (nullable) */
  faxNo?: string;
  /** 계좌정보 (nullable)^|BankUpdateRequest(bank=KB, bankName=국민은행, account=12341234, depositorName=홍길동) */
  tradeBank?: Record<string, any>;
  /** 대표자 정보 (nullable)^|RepresentativeUpdateRequest(name=대표자이름, phoneNo=01012341234, email=abcd@gmail.com) */
  representative?: Record<string, any>;
}

export interface contracts-partnerNo-51369225 {
  /** 거래일시 (nullable) */
  startedDateTime?: string;
  /** 수수료율 */
  commissionRate?: number;
  /** 담당MD 번호 */
  merchandiserNo?: number;
  /** 거래 상태 */
  contractStatus?: string;
  /** 거래 유형 (nullable) */
  contractType?: string;
  /** 계약번호 */
  contractNo?: number;
  /** 프로모션 동의 여부 */
  promotionAgreed?: boolean;
  /** 생성일시 */
  createdDateTime?: string;
  /** 쇼핑몰 외부 연동 키 */
  externalApiKey?: string;
  /** 파트너 번호 */
  partnerNo?: number;
  /** 정산 설정 */
  settlementConfig?: Record<string, any>;
  entryContracts?: any[];
  /** 쇼핑몰 번호 */
  mallNo?: number;
}

export interface configurations-admin-domains1790762806 {
}

export interface admins-adminNo933950945 {
  /** 부서 */
  departmentName?: string;
  /** 만료일 (nullable) */
  expireDateTime?: string;
  /** 어드민 번호 */
  adminNo?: number;
  /** 어드민 타입 */
  adminType?: string;
  /** 어드민 권한 */
  adminRole?: string;
  /** 휴대전화번호 */
  mobileNo?: string;
  /** 직급 */
  jobPositionName?: string;
  /** 전화번호 */
  phoneNo?: string;
  /** 운영자명 */
  adminName?: string;
  /** 파트너 번호 (nullable) */
  partnerNo?: number;
  /** 접속 가능 IP */
  permittedIpAddresses?: any[];
  /** 휴대폰 인증 여부 */
  phoneCertificationYn?: boolean;
  /** 어드민 상태 */
  adminStatus?: string;
  /** 어드민 Id */
  adminId?: string;
  /** 서비스 번호 (nullable) */
  serviceNo?: number;
  /** 직책 */
  jobDutyName?: string;
  /** 이메일 */
  email?: string;
  /** 외부접속 가능 여부 */
  externalAccessEnabled?: boolean;
}

export interface malls-1901494364 {
  productDetailUrl?: Record<string, any>;
  /** 몰 이름 */
  mallName?: string;
  url?: Record<string, any>;
  /** 몰 타입(deprecated) */
  mallType?: string;
}

export interface partners-partnerNo-1680407816 {
  /** 고객 CS 운영자 정보(개발중 - 현재 사용불가)^|PartnerCsManager(name=홍길동, phoneNo=1800-3859, email=nhn@nhn.com, operationInfo=평일 10:00 ~ 19:00) */
  csManager?: Record<string, any>;
  /** 파트너 상태 */
  partnerStatus?: string;
  /** 계약 담당자(마스터 어드민) 번호 (nullable) */
  masterAdminNo?: number;
  manager?: Record<string, any>;
  business?: Record<string, any>;
  /** 접속 허용 IP 주소 */
  permittedIpAddress?: string;
  /** 파트너명 (nullable) */
  partnerName?: string;
  internationalCode?: Record<string, any>;
  privacyManager?: Record<string, any>;
  /** 과세 형태 (nullable) */
  sellerTaxationType?: string;
  /** 회사명 (nullable) */
  companyName?: string;
  settlementManager?: Record<string, any>;
  office?: Record<string, any>;
  /** 해외배송 여부 */
  supportsInternationalShipping?: boolean;
  /** 파트너 번호 */
  partnerNo?: number;
  /** 샘플 URL (nullable) */
  sampleUrl?: string;
  /** 정산 설정^|SettlementConfigDetail(settlementPeriodType=MONTH, domesticProvisionRate=100, domesticSettlementDay=5, domesticSettlementHolidayType=YESTERDAY, domesticSettlementDayOfWeek=null, overseasProvisionRate=100, overseasSettlementDay=5, overseasSettlementHolidayType=YESTERDAY, overseasSettlementDayOfWeek=null) */
  settlementConfig?: Record<string, any>;
  /** 팩스 번호 (nullable) */
  faxNo?: string;
  /** 국가 코드 */
  countryCode?: string;
  masterAdminSummary?: Record<string, any>;
  tradeBank?: Record<string, any>;
  /** 파트너 타입 */
  partnerType?: string;
  representative?: Record<string, any>;
}

export interface partners-temp970273924 {
  /** 생성된 파트너 번호 */
  partnerNo?: number;
}

export interface contracts-1572845133 {
  /** 조회 결과 */
  contents?: any[];
  /** 전체 조회건수 */
  totalCount?: number;
}

export interface partners-temp-486261392 {
  /** 운영자명 */
  adminName?: string;
  /** 수수료율 */
  commissionRate?: number;
  /** 담당MD 운영자 번호 */
  merchandiserNo?: number;
  /** 정산 설정 */
  settlementConfig?: Record<string, any>;
  /** 파트너명 */
  partnerName?: string;
  /** 파트너 노출 설정 여부(해당 파트너가 몰에 종속적인지 여부, true: 노출안함, false: 노출함) (nullable) */
  dependencyYn?: boolean;
  /** 전달 메모 (nullable) */
  memo?: string;
  /** 입점 계약서 (nullable) */
  contractContent?: string;
  /** 운영자 이메일 */
  adminEmail?: string;
}

export interface contracts594295227 {
  /** 파트너 번호 */
  partnerNo?: number;
  /** 수수료율 */
  commissionRate?: number;
  /** 신규 거래 진행 쇼핑몰 MD 의 운영자 번호 - null인 경우 해당 몰의 대표 운영자로 지정 (nullable) */
  merchandiserNo?: number;
  /** 정산 설정 */
  settlementConfig?: Record<string, any>;
  /** 계약 유형 - (ELECTRONIC: 전자계약, HANDWRITING: 수기계약) (nullable) */
  contractType?: string;
  /** 추가 정보(jsonString 형식) (nullable) */
  additionalInfo?: string;
  /** 전달 메모 (nullable) */
  memo?: string;
  /** 입점 계약서 (nullable) */
  contractContent?: string;
}

export interface malls-contracts-partners-1832611812 {
}

export interface currencies-currencyCode-1479264625 {
  /** 비율 */
  exchangeRate?: number;
}

export interface partners-669982228 {
  csManager?: Record<string, any>;
  /** 수수료율 (default : 0, 졔약조건 - 최소: 0.00, 최대:99.9) */
  commissionRate?: number;
  /** 담당 MD */
  merchandiserNo?: number;
  manager?: Record<string, any>;
  business?: Record<string, any>;
  /** 파트너명(제약 조건 - 파트너명 최대길이:63 */
  partnerName?: string;
  privacyManager?: Record<string, any>;
  /** 과세 형태 (nullable) */
  sellerTaxationType?: string;
  /** 회사명(제약조건 - 최대길이: 45) */
  companyName?: string;
  admin?: Record<string, any>;
  /** 파트너 매핑키 (nullable) */
  partnerMappingKey?: string;
  settlementManager?: Record<string, any>;
  office?: Record<string, any>;
  settlementConfig?: Record<string, any>;
  /** 팩스 번호(제약조건 -최대길이: 50 ) (nullable) */
  faxNo?: string;
  tradeBank?: Record<string, any>;
  /** 마케팅 수신동의 여부 (default : true) */
  promotionAgreedYn?: boolean;
  representative?: Record<string, any>;
}

export interface contracts-925074272 {
  /** 계약서 번호 목록 */
  contractNos?: any[];
  /** 변경할 상태 - (APPROVAL: 계약 동의, DISAPPROVAL: 계약 반려, SUSPEND: 계약 일시정지, UNSUSPEND: 계약 일시정지 해제) */
  status?: string;
}

export interface currencies495944049 {
}

export interface contracts-partnerNo-1265137783 {
  /** 수수료율 ( null일 시, 변경 없음 ) (nullable) */
  commissionRate?: number;
  /** 신규 거래 진행 쇼핑몰 MD 의 운영자 번호 */
  merchandiserNo?: number;
  /** 정산 설정 */
  settlementConfig?: Record<string, any>;
  /** 계약 유형 - (ELECTRONIC: 전자계약, HANDWRITING: 수기계약) (nullable) */
  contractType?: string;
  /** 추가 정보(jsonString 형식) (nullable) */
  additionalInfo?: string;
  /** 전달 메모 (nullable) */
  memo?: string;
  /** 입점 계약서 (nullable) */
  contractContent?: string;
}

