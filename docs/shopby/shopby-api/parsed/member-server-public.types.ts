// Auto-generated TypeScript types from member-server

export interface configurations-member-common-join-config18446488 {
  /** 생년월일^|NOT_USED */
  birthday: string;
  /** 주소^|USED */
  address: string;
  /** 성별^|NOT_USED */
  sex: string;
  /** 이름^|REQUIRED */
  memberName: string;
  /** 휴대폰번호^|REQUIRED */
  mobileNo: string;
  /** 설정 사용 여부^|true */
  used: boolean;
  /** 전화번호^|NOT_USED */
  phoneNo: string;
  /** 이메일 수신 동의 사용^|USED */
  emailAgreement: string;
  /** 비밀번호^|REQUIRED */
  password: string;
  /** SMS 수신 동의 사용^|USED */
  smsAgreement: string;
  /** 닉네임^|NOT_USED */
  nickname: string;
  /** 이메일^|REQUIRED */
  email: string;
  /** 아이디^|REQUIRED */
  memberId: string;
}

export interface profile-bulk-786404190 {
  /** 회원 번호 목록^|[90001, 90002] */
  memberNos: any[];
}

export interface profile-groups-64494364 {
  /** 회원 번호^|111 */
  memberNo: number;
}

export interface members1756520566 {
  /** 조회 결과 */
  contents: any[];
  /** keySet 조회시 사용. searchAfter 파라미터 값으로 사용 */
  lastId?: string;
  /** 전체 조회건수 - includesCount false의 경우 null */
  totalCount?: number;
}

export interface members-external1437284076 {
  /** 생년월일 (nullable) */
  birthday?: string;
  /** 우편번호 (nullable) */
  zipCode?: string;
  /** 성별 (nullable) */
  gender?: string;
  /** 도, 시 (nullable) */
  city?: string;
  /** 국가 코드 (nullable) */
  nation?: string;
  /** 사업자 명 (nullable) */
  businessName?: string;
  /** 회원 등급 (nullable) */
  gradeNo?: number;
  /** 광고성 SMS 수신동의 여부 (nullable) */
  smsPolicyAgreed?: boolean;
  /** 성인 인증 여부 (nullable) */
  adultCertified?: boolean;
  /** 사용자 별명, 별칭 (nullable) */
  nickname?: string;
  /** 구, 군, 읍 (nullable) */
  state?: string;
  /** 회원 아이디(업체에서 관리하는 회원의 유일값)^|test1234 */
  id: string;
  /** 지번 주소 (nullable) */
  landLotAddress?: string;
  /** 도로명 상세 주소 (nullable) */
  streetAddressDetail?: string;
  /** 본인 인증 여부 (nullable) */
  privacyPolicyAgreed?: boolean;
  /** 이메일 (nullable) */
  email?: string;
  /** 앱푸시 동의 여부 (nullable) */
  pushPolicyAgreed?: boolean;
  /** ci (nullable) */
  ci?: string;
  /** 광고성 Email 수신동의 여부 (nullable) */
  emailPolicyAgreed?: boolean;
  /** 도로명 주소 (nullable) */
  streetAddress?: string;
  /** 휴대전화번호 (nullable) */
  phone?: string;
  /** 사업자 등록번호 (nullable) */
  businessRegistrationNumber?: string;
  /** 사용자 이름 (nullable) */
  name?: string;
  /** 지번 상세 주소 (nullable) */
  landLotAddressDetail?: string;
  /** 추가정보 (입점사 회원 커스텀 정보) (nullable) */
  extraJson?: string;
  /** 회원 그룹 (nullable) */
  groupNos?: any[];
}

export interface profile-grades1340609570 {
  /** 등급 변경완료 회원번호목록^|[1] */
  memberNos: any[];
}

export interface members-external-562353168 {
  /** 가입된 회원 번호 */
  memberNo: number;
}

export interface configurations-member-app-card-743079106 {
  /** 앱카드 store id (nullable) */
  storeId?: string;
}

export interface profile-bulk1699245403 {
}

export interface member-groups-groupNo-1944155955 {
  /** 회원 그룹 번호^|1 */
  no: number;
  /** 회원 그룹 이름^|임직원 */
  name: string;
  /** 회원 그룹 상세 설명^|임직원 확인용 그룹 */
  description: string;
  /** 적립금 혜택 정보 */
  reserveBenefit: Record<string, any>;
}

export interface configurations-member-open-id-providerType-371719732 {
  /** 간편로그인 client id^|123 */
  clientId: string;
  /** 간편로그인 clientSecret - 마스킹^|456 */
  clientSecret?: string;
  /** 간편로그인 scopes^|[id, name] */
  scopes?: any[];
  /** 애플인 경우 config^|com.ncp.member.presentation.request.OpenIdConfigClientRequest$AppleLoginConfigRequest@338179fe */
  appleConfig?: Record<string, any>;
}

export interface member-groups-969948294 {
}

export interface members-expelled-members-520853343 {
}

export interface profile-1775399877 {
  /** 회원 번호^|90001 */
  memberNo: number;
}

export interface profile-dormant-release909502051 {
  /** 회원 번호 (nullable) */
  memberNo?: number;
  /** 회원 아이디 (nullable) */
  memberId?: string;
}

export interface profile1753227609 {
  /** 생년월일 (nullable) */
  birthday?: string;
  /** 성별 (nullable) */
  gender?: string;
  /** 사업자 회원 회사명 (nullable) */
  businessName?: string;
  /** 회원 상태 (대기: WAITING, 가입완료: ACTIVE, 휴면: FREEZE or DORMANT, 이용정지: PAUSED)^|ACTIVE */
  memberStatus: string;
  /** 회원이름 (nullable) */
  memberName?: string;
  /** 대표몰 회원번호 (nullable) */
  representativeMemberNo?: number;
  /** 푸시 알림 동의 여부^|true */
  pushNotificationAgreed: boolean;
  /** 마지막 연동 SNS (nullable) */
  providerType?: string;
  /** 본인인증 여부(true|false)^|true */
  principalCertificated: boolean;
  /** 마지막 접속 IP^|127.0.0.1 */
  lastLoginIp: string;
  /** 광고 우편물(DM) 수신 동의 시각 (nullable) */
  directMailAgreeYmdt?: string;
  /** 광고 우편물(DM) 수신 동의 여부^|true */
  directMailAgreed: boolean;
  /** 추가 정보 (nullable) */
  additionalInfo?: string;
  /** 닉네임 (nullable) */
  nickname?: string;
  /** 가입 일시^|2021-01-01 00:00 */
  joinYmdt: string;
  /** 회원 그룹 목록 */
  memberGroups: any[];
  /** 이메일 (nullable) */
  email?: string;
  /** 아이디^|test */
  memberId: string;
  /** 기본 동의 항목 목록^|[AgreedTerms(termsNo=2, termsType=TRANSFER_AGREE, isAgree=true, agreementYmdt=2025-10-28T10:09:32.810446202)] */
  agreedTerms: any[];
  /** 최근 접속 시간 (nullable) */
  lastLoginYmdt?: string;
  /** 성인 인증 여부^|true */
  adultCertificated: boolean;
  /** 국제전화번호 코드 (nullable) */
  mobileCountryCode?: string;
  /** CI (nullable) */
  ci?: string;
  /** 성인 인증 일시 (nullable) */
  adultCertificatedYmdt?: string;
  /** 단문메시지서비스(SMS) 동의 여부^|true */
  smsAgreed: boolean;
  /** 가입 경로 (nullable) */
  joinTypeName?: string;
  /** 단문메시지서비스(SMS) 동의 시각 (nullable) */
  smsAgreeYmdt?: string;
  /** 추가 동의 항목 목록^|[CustomAgreedTerms(customTermsNo=20, isAgree=true, agreementYmdt=2025-10-28T10:09:32.810419189)] */
  customAgreedTerms: any[];
  /** 휴대폰번호 (nullable) */
  mobileNo?: string;
  /** 로그인 횟수^|10 */
  loginCount: number;
  /** 회원번호^|12345 */
  memberNo: number;
  /** 블랙리스트 여부^|false */
  blacklisted: boolean;
  /** 회원 등급 이름^|테스트 등급 */
  memberGradeName: string;
  /** 회원 등급 번호^|1 */
  memberGradeNo: number;
  /** 사업자 회원 사업자등록번호 (nullable) */
  registrationNo?: string;
  /** 외부 서비스 고유 식별값 (nullable) */
  oauthIdNo?: string;
  /** 푸시 알림 동의 시각 (nullable) */
  pushNotificationAgreeYmdt?: string;
  /** 회원 구분^|MALL */
  memberType: string;
  /** 회원 추가항목 정보 */
  extraInfo: any[];
  /** 회원 그룹 이름^|그룹 1 */
  memberGroupNames: string;
}

export interface configurations-member-open-id-providerType351872100 {
  /** 간편로그인 client id^|123 */
  clientId: string;
  /** 간편로그인 clientSecret - 마스킹^|456 */
  clientSecret?: string;
  /** 간편로그인 scopes^|[id, name] */
  scopes?: any[];
  /** 애플인 경우 config^|com.ncp.member.presentation.response.OpenIdConfigClientResponse$AppleLoginConfigResponse@4df0ae40 */
  appleConfig?: Record<string, any>;
}

export interface profile-dormant-release486549215 {
}

export interface profile-grades508071144 {
  /** 쿠폰 발행 여부 (nullable) */
  issueCoupon?: boolean;
  members?: any[];
  /** 변경 등급 번호^|2 */
  gradeNo: number;
}

export interface profile-groups-1583052347 {
  /** 회원 번호^|111 */
  memberNo: number;
  /** 회원 아이디^|younghee */
  memberId: string;
  /** 회원 그룹번호^|1234 */
  memberGroupNo: number;
}

export interface grades1273037573 {
}

export interface members-prohibit-849892994 {
  /** 정지 사유 (nullable) */
  reason?: string;
  /** 정지시킬 회원번호 리스트^|1,2,3 */
  memberNos: any[];
  /** 회원 정지 (true), 정지 해제 (false)^|true */
  prohibition: boolean;
  /** 회원 이용 정지 기간 (nullable) */
  expireDate?: string;
  /** 알림 종류 (nullable) */
  notificationTypes?: any[];
  /** 변경시킬 회원 상태 (nullable) */
  status?: string;
}

export interface profile-blocked-release452550290 {
  /** 차단자 회원 번호^|1 */
  memberNo: number;
  /** 차단 대상 회원 아이디 (nullable) */
  targetMemberId?: string;
  /** 차단 대상 회원 번호 (nullable) */
  targetMemberNo?: number;
}

export interface configurations-member-extra-info-config-1692811019 {
  /** 회원정보 추가항목 목록^|[ExtraInfoSummaryContent(extraInfoNo=1, extraInfoName=추가항목 항목명, status=USED, extraInfoType=TEXTBOX, extraInfoOptions=[ExtraInfoOptionSummary(extraInfoOptionNo=10, extraInfoOptionName=옵션명-1), ExtraInfoOptionSummary(extraInfoOptionNo=11, extraInfoOptionName=옵션명-2)])] */
  extraInfoContents: any[];
}

export interface profile-dormant9804281 {
  /** 전체 페이지 수 */
  totalPages: number;
  /** 조회 결과 */
  content: any[];
  /** 전체 조회건수 */
  totalElements: number;
}

export interface profile1934915172 {
  /** 생일 yyyyMMdd (nullable) */
  birthday?: string;
  /** 성 (nullable) */
  lastName?: string;
  /** (국내, 해외 겸용) 도시 (nullable) */
  city?: string;
  /** 회사명 (nullable) */
  businessName?: string;
  /** 회원 성명 (nullable) */
  memberName?: string;
  /** 우편번호 (nullable) */
  zipCd?: string;
  /** 푸시 알림 동의 여부 (nullable) */
  pushNotificationAgreed?: boolean;
  /** 거주 국가 (nullable) */
  countryCode?: string;
  /** 이메일 알림 동의 여부 (nullable) */
  directMailAgreed?: boolean;
  /** 추가 정보 (JSON) (nullable) */
  additionalInfo?: string;
  /** 닉네임 (nullable) */
  nickname?: string;
  /** 추가 선택 동의 항목 (nullable) */
  customTermsNos?: any[];
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable) */
  state?: string;
  /** 이메일 주소 (nullable) */
  email?: string;
  /** 도로명 주소 상세 (지번 주소) (nullable) */
  jibunDetailAddress?: string;
  /** 회원 아이디 (nullable) */
  memberId?: string;
  /** 도로명 주소 (nullable) */
  address?: string;
  /** 국제전화번호 코드 (nullable) */
  mobileCountryCode?: string;
  /** 인증확인 여부 (nullable) */
  certificated?: boolean;
  /** CI (nullable) */
  ci?: string;
  /** SMS 알림 동의 여부 (nullable) */
  smsAgreed?: boolean;
  /** 성별 (F:여성/M:남성) (nullable) */
  sex?: string;
  /** 도로명 주소 (지번 주소) (nullable) */
  jibunAddress?: string;
  /** 휴대전화번호 (nullable) */
  mobileNo?: string;
  /** 환불 계좌 은행 (nullable) */
  refundBank?: string;
  /** 이름 (nullable) */
  firstName?: string;
  /** 회원 번호 (nullable) */
  memberNo?: number;
  /** 환불 계좌 예금주명 (nullable) */
  refundBankDepositorName?: string;
  /** 일반전화번호 (nullable) */
  telephoneNo?: string;
  /** 사업자 등록 번호 (nullable) */
  registrationNo?: string;
  /** 선택동의항목 */
  joinTermsAgreements?: string;
  /** 도로명 주소 상세 (nullable) */
  detailAddress?: string;
  /** 환불 계좌 번호 (nullable) */
  refundBankAccount?: string;
  /** 추가 항목 정보 */
  extraInfo?: any[];
}

export interface profile-bulk-delete-722054971 {
  /** 회원 번호 리스트^|[1004] */
  memberNos: any[];
}

export interface profile-groups-1410096186 {
  /** 회원 번호^|123 */
  memberNo: number;
  items?: any[];
}

export interface members-prohibit1975347019 {
  /** 회원 정지(정지 해제) 결과 */
  rows: any[];
  /** 회원 정지 / 정지 해제^|일시 이용정지 */
  value: string;
}

export interface member-groups-67331454 {
  /** 회원 그룹 이름^|임직원 */
  name: string;
  /** 회원 그룹 상세 설명^|임직원 확인용 그룹 */
  description: string;
  /** 적립금 혜택 정보 */
  reserveBenefit: Record<string, any>;
}

