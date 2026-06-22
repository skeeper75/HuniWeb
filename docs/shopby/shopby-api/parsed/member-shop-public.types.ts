// Auto-generated TypeScript types from member-shop

export interface profile-address-1789523818 {
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 도로명 주소 (nullable)^|경기도 성남시 대왕판교로645번길 16 */
  streetAddress?: string;
  /** 거주 국가 (nullable)^|KR */
  countryCode?: string;
  /** 지번 주소 (nullable)^|경기도 성남시 분당구 삼평동 629 */
  jibunAddress?: string;
  /** 우편번호 (nullable)^|13487 */
  zipCd?: string;
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 지번 상세 주소 (nullable)^|NHN */
  jibunAddressDetail?: string;
  /** 도로명 상세 주소 (nullable)^|삼평동, NHN 플레이뮤지엄 */
  streetAddressDetail?: string;
}

export interface profile-ci-exists768970653 {
  /** 존재 여부^|false */
  exist: boolean;
  /** 회원 상태 (대기: WAITING, 가입완료: ACTIVE, 휴면: FREEZE or DORMANT, 이용정지: PAUSED, 탈퇴 : WITHDRAWN) (nullable)^|null */
  status?: string;
}

export interface profile-id-1482004638 {
  []?: Record<string, any>;
  /** 회원명^|홍길동 */
  memberName: string;
  /** 가입일^|2021-01-01T00:00:00 */
  joinYmdt: string;
  /** 휴대전화 번호^|010-1234-5678 */
  mobileNo: string;
  /** 아이디^|test01 */
  id: string;
  /** 이메일^|test@shopby.com */
  email: string;
  /** 회원 상태 (대기: WAITING, 가입완료: ACTIVE, 휴면: FREEZE or DORMANT, 이용정지: PAUSED)^|ACTIVE */
  status: string;
}

export interface profile-check-password-1287854604 {
  /** message^|로그인을 10회 이상 실패하였습니다. 자동등록방지 문자 입력 후 다시 시도해주세요. */
  message: string;
  /** key^|member:PasswordCheck:mallNo:id */
  key: string;
}

export interface profile-id-email1770998150 {
  /** 메일 발송 대상 이메일^|email@nhn.com */
  result: string;
}

export interface profile-brand-oauth330380794 {
  /** 생년월일 (nullable)^|19900101 */
  birthday?: string;
  /** 쇼핑몰 이름^|테스트몰 */
  mallName: string;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 거주 국가 (nullable)^|null */
  countryCd?: string;
  /** 회원 상태^|ACTIVE */
  memberStatus: string;
  /** 회원 이름 (nullable)^|홍길동 */
  memberName?: string;
  /** 우편번호 (nullable)^|null */
  zipCd?: string;
  /** 푸시 알림 동의 여부^|false */
  pushNotificationAgreed: boolean;
  /** 본인인증 여부^|false */
  principalCertificated: boolean;
  /** 마지막으로 연동된 외부 IDP (nullable)^|null */
  providerType?: string;
  /** 최근 접속 IP (nullable)^|127.0.0.1 */
  lastLoginIp?: string;
  /** 이메일 알림 동의 일시^|2025-10-29 17:04 */
  directMailAgreeYmdt?: string;
  /** 이메일 알림 동의 여부^|false */
  directMailAgreed: boolean;
  /** 추가정보 (nullable)^|null */
  additionalInfo?: string;
  /** 닉네임 (nullable)^|null */
  nickname?: string;
  /** 그룹 목록 */
  memberGroups: any[];
  /** 가입일시^|2025-10-29 17:04 */
  joinYmdt: string;
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 이메일 (nullable)^|01012345678 */
  email?: string;
  /** 선택 동의 항목 정보 */
  agreedTermsInfos: any[];
  /** 지번주소 상세 (nullable)^|null */
  jibunDetailAddress?: string;
  /** 회원 아이디 (nullable)^| */
  memberId?: string;
  /** 선택 동의 항목 정보(deprecated) */
  agreedTerms: string;
  /** 최근 접속시각 */
  lastLoginYmdt?: string;
  /** 도로명주소 (nullable)^|null */
  address?: string;
  /** 성인인증 여부^|false */
  adultCertificated: boolean;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** SMS 알림 동의 여부^|false */
  smsAgreed: boolean;
  /** 성인인증 일시^|2025-10-29 17:04 */
  adultCertificatedYmdt?: string;
  /** 성별 (nullable)^|X */
  sex?: string;
  /** 연동된 간편로그인 서비스 목록^|[] */
  providerTypes: any[];
  /** 가입 경로 (nullable)^|PC */
  joinTypeName?: string;
  /** 지번주소 (nullable)^|null */
  jibunAddress?: string;
  /** SMS 알림 동의 일시^|2025-10-29 17:04 */
  smsAgreeYmdt?: string;
  /** 휴대폰번호 (nullable)^|null */
  mobileNo?: string;
  /** 로그인 횟수^|1 */
  loginCount: number;
  /** 환불 계좌 은행 (nullable)^|null */
  refundBank?: string;
  /** 회원번호^|1000 */
  memberNo: number;
  /** 환불 계좌 예금주명 (nullable)^|null */
  refundBankDepositorName?: string;
  /** 등급 이름^|기본등급 */
  memberGradeName: string;
  /** 전화번호 (nullable)^|null */
  telephoneNo?: string;
  /** IDP 아이디 (nullable)^|12345678 */
  oauthIdNo?: string;
  /** 도로명주소 상세 (nullable)^|null */
  detailAddress?: string;
  /** 푸시 알림 동의 일시^|2025-10-29 17:04 */
  pushNotificationAgreeYmdt?: string;
  /** 회원 유형^|OPEN_ID */
  memberType: string;
  /** 환불 계좌번호 (nullable)^|null */
  refundBankAccount?: string;
  /** 전체 그룹 이름(, 로 구분)^|신규회원 */
  memberGroupNames: string;
}

export interface profile-1900618566 {
  /** 광고 우편물(DM) 수신 거부 일시 (nullable)^|2025-10-29 17:05 */
  directMailDisagreeYmdt?: string;
  /** 회사명 (nullable)^|null */
  businessName?: string;
  /** 거주 국가 (nullable)^|null */
  countryCd?: string;
  /** 우편번호 (nullable)^|null */
  zipCd?: string;
  /** 푸쉬 알림 동의 여부 - deprecated^|false */
  pushNotificationAgreed: boolean;
  /** 회원 등급 이미지 (nullable)^|uploadedFileName.jpg */
  memberGradeImageUrl?: string;
  /** 광고 우편물(DM) 수신 동의 일시 (nullable)^|2025-10-29 17:05 */
  directMailAgreeYmdt?: string;
  /** 광고 우편물(DM) 수신 동의 여부^|false */
  directMailAgreed: boolean;
  /** 추가 정보 - jsonString 형태, server api 조회 시 additionalInfo 로 바이 패스 해줍니다. (nullable)^|{"hello":"value"} */
  additionalInfo?: string;
  /** 가입 일시^|2025-10-29 17:05 */
  joinYmdt: string;
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 회원 아이디^|gildong */
  memberId: string;
  /** 최근 접속 시간 (nullable)^|2025-10-29T17:05:00.794329127 */
  lastLoginYmdt?: string;
  /** 인증 타입 (nullable)^|MOBILE/SMS/EMAIL */
  certificationType?: string;
  /** 연동된 SNS 리스트 (nullable)^|["NAVER"] */
  providerTypes?: any[];
  /** 단문메시지서비스(SMS) 동의 여부^|false */
  smsAgreed: boolean;
  /** 도로명 주소 (지번 주소) (nullable)^|null */
  jibunAddress?: string;
  /** 단문메시지서비스(SNS) 동의 일시 (nullable)^|2025-10-29 17:05 */
  smsAgreeYmdt?: string;
  /** 환불 계좌 은행 (nullable)^|null */
  refundBank?: string;
  /** 이름 (nullable)^|홍길동 */
  firstName?: string;
  /** 회원 번호^|1 */
  memberNo: number;
  /** 환불 계좌 예금주명 (nullable)^|null */
  refundBankDepositorName?: string;
  /** 일반 전화 번호 (nullable)^|03111111111 */
  telephoneNo?: string;
  customTermsAgreement?: any[];
  /** 푸쉬 알림 거부 일시 - deprecated (nullable)^|2025-10-29 17:05 */
  pushNotificationDisagreeYmdt?: string;
  /** 환불 계좌 번호 */
  refundBankAccount?: string;
  /** 회원 추가항목 정보 */
  extraInfo: any[];
  /** 회원 그룹 이름 (nullable)^|테스트그룹 */
  memberGroupNames?: string;
  /** 생년월일. yyyyMMdd (nullable)^|null */
  birthday?: string;
  /** 쇼핑몰 이름 (nullable)^|길동몰 */
  mallName?: string;
  /** 성 (nullable)^|홍길동 */
  lastName?: string;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 회원 상태^|ACTIVE */
  memberStatus: string;
  /** 회원 이름 (nullable)^|홍길동 */
  memberName?: string;
  /** 마지막 연동 SNS (nullable)^|NAVER */
  providerType?: string;
  /** 인증 여부^|false */
  principalCertificated: boolean;
  /** 마지막 접속 IP (nullable)^|127.0.0.1 */
  lastLoginIp?: string;
  /** 닉네임 (nullable)^|null */
  nickname?: string;
  /** 회원 그룹 */
  memberGroups: any[];
  /** 추천한 회원 아이디 (nullable)^|null */
  recommender?: string;
  /** 이메일 주소 (nullable)^|gildong2@nhn.com */
  email?: string;
  /** 선택 동의 항목 상세 */
  agreedTermsInfos: any[];
  /** 도로명 주소 상세 (지번 주소) (nullable)^|null */
  jibunDetailAddress?: string;
  /** 선택 동의 항목^|ACCESS_GUIDE */
  agreedTerms: any[];
  /** 도로명 주소 (nullable)^|null */
  address?: string;
  /** 성인 인증 여부^|false */
  adultCertificated: boolean;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** 성인 인증 일시 (nullable)^|2025-10-29 17:05 */
  adultCertificatedYmdt?: string;
  /** 성별 (F, M) (nullable)^|M */
  sex?: string;
  /** 가입 경로 (nullable)^|PC_WEB */
  joinTypeName?: string;
  /** 핸드폰 번호 (nullable)^|01011112222 */
  mobileNo?: string;
  /** 단문메시지서비스(SNS) 거부 일시 (nullable)^|2025-10-29 17:05 */
  smsDisagreeYmdt?: string;
  /** 로그인 횟수 (nullable)^|1 */
  loginCount?: number;
  /** 회원 등급 이름 (nullable)^|VVIP */
  memberGradeName?: string;
  /** 회원 등급 번호^|1 */
  memberGradeNo: number;
  /** 사업자 등록번호 (nullable)^|null */
  registrationNo?: string;
  /** Open Id Key (nullable)^|123456 */
  oauthIdNo?: string;
  /** 도로명 주소 상세 (nullable)^|null */
  detailAddress?: string;
  /** 푸쉬 알림 동의 일시 - deprecated (nullable)^|2025-10-29 17:05 */
  pushNotificationAgreeYmdt?: string;
  /** 회원 구분 */
  memberType: string;
}

export interface profile-grade-1017060239 {
  /** 등급 이미지 URL (nullable)^|null */
  memberGradeImageUrl?: string;
  /** 적립금 자동지급 */
  reserveAutoSupplying: Record<string, any>;
  /** 회원 등급 평가 조건 */
  evaluationCondition: Record<string, any>;
  /** 회원 등급에 발급된 쿠폰 */
  coupons: any[];
  /** 등급 설명 (deprecated: description ENUM으로 대체 되었습니다.)^| */
  gradeDescription: string;
  /** 등급 설명^| */
  description: string;
  /** 등급별 적립금 적립율(%) (deprecated: reserveBenefit.reserveRate 값으로 대체 되었습니다.)^|0 */
  accumulationRate: number;
  /** 등급명^| */
  label: string;
  /** 적립금 혜택 */
  reserveBenefit: Record<string, any>;
  /** 등급 조건(최소 구매 수량) (deprecated: valuationCondition.minimumCount 값으로 대체 되었습니다.)^|0 */
  minOrderCnt: number;
  /** 등급 조건(최수 구매 금액) (deprecated: evaluationCondition.minimumPayment 값으로 대체 되었습니다.)^|0 */
  minOrderAmt: number;
  /** 등급별 포인트 적립율(%) (deprecate)^|0 */
  pointRate: number;
}

export interface profile-ci-myself2067648940 {
  /** 일치 여부^|true */
  matched: boolean;
}

export interface profile-change-password-after-cert-1055517755 {
  /** 비밀번호 찾기 방법^|MOBILE */
  findMethod: string;
  /** 인증번호^|123456 */
  certificationNumber: string;
  /** 변경할 비밀번호^|passowrd */
  newPassword: string;
  /** 본인인증 키^|ABCDEFGH */
  key: string;
  /** 아이디^|nhncommerce */
  memberId: string;
}

export interface profile-non-masking-1321884890 {
  /** 비밀번호^|password */
  password: string;
}

export interface profile-brand-oauth-355872038 {
  /** 선택 동의 항목 (nullable)^|[PERSONAL_PROCESS_CONSIGNMENT, PERSONAL_THIRD_PARTY_PROVISION] */
  joinTermsAgreements?: any[];
  /** 이메일 알림 수신 동의 여부 (nullable)^|null */
  directMailAgreed?: boolean;
  /** SMS 알림 수신 동의 여부 (nullable)^|null */
  smsAgreed?: boolean;
  /** 푸시 알림 수신 동의 여부 (nullable)^|null */
  pushNotificationAgreed?: boolean;
}

export interface member-grades494184672 {
}

export interface profile-1202369534 {
  /** 생년월일. yyyyMMdd (nullable)^|19950403 */
  birthday?: string;
  /** 성 (nullable)^|null */
  lastName?: string;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 거주 국가 (nullable)^|null */
  countryCd?: string;
  /** 회사명 (nullable)^|null */
  businessName?: string;
  /** SMS 인증번호 (nullable)^|123456 */
  smsAuthKey?: string;
  /** 회원 이름 (nullable)^|홍길동 */
  memberName?: string;
  /** 우편번호 (nullable)^|12345 */
  zipCd?: string;
  /** 푸쉬앱 알람 동의 여부 (nullable)^|false */
  pushNotificationAgreed?: boolean;
  /** 비밀번호 (nullable)^|1q2w3e4r1! */
  password?: string;
  /** 이메일 알람 동의 여부 (nullable)^|false */
  directMailAgreed?: boolean;
  /** 추가 정보 - jsonString 형태, server api 조회 시 additionalInfo 로 바이 패스 해줍니다. (nullable)^|{"hello":"value"} */
  additionalInfo?: string;
  /** 회원 닉네임 (nullable)^|길동 */
  nickname?: string;
  /** 추가 동의 항목 (nullable)^|[1,2,3] */
  customTermsNos?: any[];
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 이메일 주소 (nullable)^|gildong@nhn.com */
  email?: string;
  /** 지번 주소 상세 (nullable)^|NHN */
  jibunDetailAddress?: string;
  /** 도로명 주소 (nullable)^|경기도 성남시 대왕판교로645번길 16 */
  address?: string;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** 인증확인 여부 (nullable)^|false */
  certificated?: boolean;
  /** SMS 알림 동의 여부 (nullable)^|false */
  smsAgreed?: boolean;
  /** 성별 (nullable)^|F */
  sex?: string;
  /** 지번 주소 (nullable)^|성남시 분당구 삼평동 629 */
  jibunAddress?: string;
  /** 핸드폰 번호 (nullable)^|01012345678 */
  mobileNo?: string;
  /** 환불 계좌 은행 (nullable)^|WOORI */
  refundBank?: string;
  /** 현재 비밀번호 (nullable)^|12345678 */
  currentPassword?: string;
  /** 이름 (nullable)^|null */
  firstName?: string;
  /** 환불 계좌 예금주명 (nullable)^|홍길동 */
  refundBankDepositorName?: string;
  /** 전화번호 (nullable)^|03111112222 */
  telephoneNo?: string;
  /** 선택 동의 항목 (nullable)^|["PI_COLLECTION_AND_USE_OPTIONAL","PI_PROCESS_CONSIGNMENT","PI_THIRD_PARTY_PROVISION"] */
  joinTermsAgreements?: any;
  /** 도로명 주소 상세 (nullable)^|NHN */
  detailAddress?: string;
  /** 환불 계좌번호 (nullable)^|100010001000 */
  refundBankAccount?: string;
  /** 회원 추가항목 정보 */
  extraInfo: any[];
}

export interface profile-find-id-372189944 {
}

export interface profile-openid-858639222 {
  /** 생년월일 (nullable)^|null */
  birthday?: string;
  /** 성 (nullable)^|null */
  lastName?: string;
  /** 도로명주소 (nullable)^|null */
  address?: string;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** 인증확인 여부 (nullable)^|null */
  certificated?: boolean;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** SMS 알림 수신 동의 여부 (nullable)^|null */
  smsAgreed?: boolean;
  /** 성별 (nullable)^|null */
  sex?: string;
  /** 거주 국가 (nullable)^|null */
  countryCd?: string;
  /** 지번주소 (nullable)^|null */
  jibunAddress?: string;
  /** 이름 (nullable)^|null */
  memberName?: string;
  /** 우편번호 (nullable)^|null */
  zipCd?: string;
  /** 휴대폰번호 (nullable)^|null */
  mobileNo?: string;
  /** 푸시 알림 수신 동의 여부 (nullable)^|null */
  pushNotificationAgreed?: boolean;
  /** 이름) (nullable)^|null */
  firstName?: string;
  /** 전화번호 (nullable)^|null */
  telephoneNo?: string;
  /** 선택 동의 항목 (nullable)^|[PERSONAL_PROCESS_CONSIGNMENT, PERSONAL_THIRD_PARTY_PROVISION] */
  joinTermsAgreements?: any[];
  /** 이메일 알림 수신 동의 여부 (nullable)^|null */
  directMailAgreed?: boolean;
  /** 닉네임 (nullable)^|null */
  nickname?: string;
  /** 도로명주소 상세 (nullable)^|null */
  detailAddress?: string;
  /** 추가 선택 동의 항목 (nullable)^|[] */
  customTermsNos?: any[];
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 이메일 (nullable)^|null */
  email?: string;
  /** 지번주소 상세 (nullable)^|null */
  jibunDetailAddress?: string;
}

export interface profile-id-email1633415553 {
  /** 아이디 변경 화면 url^|https://www.shoppingmall.com/member/id */
  url: string;
}

export interface profile-blocked-members1076412467 {
  /** 개수^|1 */
  totalCount: number;
  /** 차단된 사용자 */
  items?: any[];
}

export interface member-groups-2025495528 {
}

export interface profile-expel1984732883 {
  /** 탈퇴 사유 (nullable)^|테스트 */
  reason?: string;
  /** 비밀번호 (Mall 회원의 경우만 필수) (nullable)^|password */
  password?: string;
}

export interface profile-next-grade221226160 {
  /** 회원 등급 평가 조건 (PAY_AMT : 구매금액, PAY_CNT : 구매횟수, AMT_AND_CNT : 구매금액 and 구매횟수, AMT_OR_CNT : 구매금액 or 구매횟수) (nullable)^|null */
  gradeEvaluationConfig?: Record<string, any>;
  /** 현재 등급 번호^|10 */
  currentGradeNo: number;
  /** 다음 등급 번호^|11 */
  nextGradeNo: number;
  /** 현재 실적 (nullable)^|null */
  currentPerformance?: Record<string, any>;
  /** 다음 예상 등급 평가일 (nullable)^|2025-10-29 */
  nextGradeEvaluationDate?: string;
}

export interface profile-password-no-authentication-certificated-by-email-645209750 {
  /** 인증번호^|123456 */
  certificationNumber: string;
  /** 변경할 비밀번호^|newPassword */
  newPassword: string;
  /** 변경 대상 아이디^|memberId */
  memberId: string;
}

export interface profile-member-extra-infos-1686285859 {
  /** 회원 요약 추가항목 목록 */
  memberSummaryExtraInfos: any[];
}

export interface profile-synchronize-1039092624 {
  /** 비밀번호^|password */
  password: string;
  /** 회원 아이디^|account */
  id: string;
}

export interface profile-1232778972 {
  /** 광고 우편물(DM) 수신 거부 일시 (nullable)^|2025-10-29 17:04 */
  directMailDisagreeYmdt?: string;
  /** 회사명 (nullable)^|(주)새회사 */
  businessName?: string;
  /** 거주 국가 (nullable)^|KR */
  countryCd?: string;
  /** 우편번호 (nullable)^|우편번호 */
  zipCd?: string;
  /** 푸쉬 알림 동의 여부 - deprecated^|false */
  pushNotificationAgreed: boolean;
  /** 회원 등급 이미지 (nullable)^|uploadedFileName.jpg */
  memberGradeImageUrl?: string;
  /** 광고 우편물(DM) 수신 동의 일시 (nullable)^|2025-10-29 17:04 */
  directMailAgreeYmdt?: string;
  /** 광고 우편물(DM) 수신 동의 여부^|false */
  directMailAgreed: boolean;
  /** 추가 정보 - jsonString 형태, server api 조회 시 additionalInfo 로 바이 패스 해줍니다. (nullable)^|{"hello":"value"} */
  additionalInfo?: string;
  /** 가입 일시^|2025-10-29 17:04 */
  joinYmdt: string;
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 회원 아이디^|hongman1 */
  memberId: string;
  /** 최근 접속 시간 (nullable)^|2025-10-29T17:04:53.929323036 */
  lastLoginYmdt?: string;
  /** 인증 타입 (nullable)^|MOBILE/SMS/EMAIL */
  certificationType?: string;
  /** 연동된 SNS 리스트 (nullable)^|["PAYCO","NAVER"] */
  providerTypes?: any[];
  /** 단문메시지서비스(SMS) 동의 여부^|false */
  smsAgreed: boolean;
  /** 도로명 주소 (지번 주소) (nullable)^|지번 주소 */
  jibunAddress?: string;
  /** 단문메시지서비스(SNS) 동의 일시 (nullable)^|2025-10-29 17:04 */
  smsAgreeYmdt?: string;
  /** 환불 계좌 은행 (nullable)^|KB */
  refundBank?: string;
  /** 이름 (nullable)^|홍길동 */
  firstName?: string;
  /** 회원 번호^|12345 */
  memberNo: number;
  /** 환불 계좌 예금주명 (nullable)^|홍길동 */
  refundBankDepositorName?: string;
  /** 일반 전화 번호 (nullable)^|01012341234 */
  telephoneNo?: string;
  customTermsAgreement?: any[];
  /** 푸쉬 알림 거부 일시 - deprecated (nullable)^|2025-10-29 17:04 */
  pushNotificationDisagreeYmdt?: string;
  /** 환불 계좌 번호 */
  refundBankAccount?: string;
  /** 회원 추가항목 정보 */
  extraInfo: any[];
  /** 회원 그룹 이름 (nullable)^|샘플그룹 */
  memberGroupNames?: string;
  /** 생년월일. yyyyMMdd (nullable)^|19900406 */
  birthday?: string;
  /** 쇼핑몰 이름 (nullable)^|테스트 몰 */
  mallName?: string;
  /** 성 (nullable)^|홍길동 */
  lastName?: string;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 회원 상태^|ACTIVE */
  memberStatus: string;
  /** 회원 이름 (nullable)^|홍길동 */
  memberName?: string;
  /** 마지막 연동 SNS (nullable)^|PAYCO */
  providerType?: string;
  /** 인증 여부^|false */
  principalCertificated: boolean;
  /** 마지막 접속 IP (nullable)^|127.0.0.1 */
  lastLoginIp?: string;
  /** 닉네임 (nullable)^|hongman */
  nickname?: string;
  /** 회원 그룹 */
  memberGroups: any[];
  /** 추천한 회원 아이디 (nullable)^|null */
  recommender?: string;
  /** 이메일 주소 (nullable)^|hong@nhn.com */
  email?: string;
  /** 선택 동의 항목 상세 */
  agreedTermsInfos: any[];
  /** 도로명 주소 상세 (지번 주소) (nullable)^|지번 상세 주소 */
  jibunDetailAddress?: string;
  /** 선택 동의 항목^|ACCESS_GUIDE */
  agreedTerms: any[];
  /** 도로명 주소 (nullable)^|도로명 주소 */
  address?: string;
  /** 성인 인증 여부^|false */
  adultCertificated: boolean;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** 성인 인증 일시 (nullable)^|2025-10-29 17:04 */
  adultCertificatedYmdt?: string;
  /** 성별 (F, M) (nullable)^|M */
  sex?: string;
  /** 가입 경로 (nullable)^|PC_WEB */
  joinTypeName?: string;
  /** 핸드폰 번호 (nullable)^|01012341234 */
  mobileNo?: string;
  /** 단문메시지서비스(SNS) 거부 일시 (nullable)^|2025-10-29 17:04 */
  smsDisagreeYmdt?: string;
  /** 로그인 횟수 (nullable)^|10 */
  loginCount?: number;
  /** 회원 등급 이름 (nullable)^|VVIP */
  memberGradeName?: string;
  /** 회원 등급 번호^|1 */
  memberGradeNo: number;
  /** 사업자 등록번호 (nullable)^|1231212345 */
  registrationNo?: string;
  /** Open Id Key (nullable)^|123456789 */
  oauthIdNo?: string;
  /** 도로명 주소 상세 (nullable)^|도로명 상세 주소 */
  detailAddress?: string;
  /** 푸쉬 알림 동의 일시 - deprecated (nullable)^|2025-10-29 17:04 */
  pushNotificationAgreeYmdt?: string;
  /** 회원 구분 */
  memberType: string;
}

export interface profile-find-password1588305481 {
  /** 비밀번호 변경 화면 uri^|https://www.shoppingmall.com/member/resetPassword */
  uri: string;
  /** 추가로 전달할 내용 (nullable)^|null */
  content?: string;
  /** 회원 ID^|memberId */
  memberId: string;
}

export interface profile-dormancy1343096684 {
  /** 인증 번호^| */
  certificationNumber: string;
  /** 휴대폰 번호^| */
  mobileNo: string;
  /** 인증 타입^|NONE */
  authType: string;
  /** 이메일 주소^| */
  email: string;
}

export interface profile1847516858 {
  /** 생년월일. yyyyMMdd (nullable)^|19881115 */
  birthday?: string;
  /** 성 (nullable)^|홍 */
  lastName?: string;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 사업자 회원 회사명 (nullable)^|null */
  businessName?: string;
  /** 거주 국가 (nullable)^|KR */
  countryCd?: string;
  /** 이름(nullable 하고 firstName, lastName 으로 대체 가능) (nullable)^|홍길동 */
  memberName?: string;
  /** 우편번호 (nullable)^|13487 */
  zipCd?: string;
  /** 푸시 알림 수신 동의 여부 (nullable)^|false */
  pushNotificationAgreed?: boolean;
  /** 비밀번호^|asdf!@#123 */
  password: string;
  /** 추천인 아이디 (nullable)^|추천인01 */
  recommenderId?: string;
  /** 관계사 회원 회사번호 (nullable)^|null */
  companyNo?: number;
  /** 이메일 알림 수신 동의 여부 (nullable)^|false */
  directMailAgreed?: boolean;
  /** 추가 정보(JSON) (nullable)^|{ "key" : "value" } */
  additionalInfo?: string;
  /** 닉네임 (nullable)^|닉네임 */
  nickname?: string;
  /** 가입시 동의한 추가 선택 동의 항목 (nullable)^|[1] */
  customTermsNos?: any[];
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 그룹 번호 (nullable)^|null */
  groupNo?: string;
  /** 이메일^|abcd@abc.com */
  email: string;
  /** 회원 아이디^|test01 */
  memberId: string;
  /** 지번주소 상세 (nullable)^|629 NHN 플레이뮤지엄 */
  jibunDetailAddress?: string;
  /** 도로명주소 (nullable)^|성남시 분당구 대왕판교로 15 */
  address?: string;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** 유저가 회원가입 시, 점유인증 했는지 여부 (이메일 or 휴대폰 SMS로 인증번호 발송하여 인증하는 방식을 의미. NHN KCP 휴대폰 본인인증과는 별개) (nullable)^|false */
  certificated?: boolean;
  /** 본인인증 정보 (CI) <br> 이미 NHN KCP 본인인증을 진행한 경우, CI 값 필수입력 (nullable)^|test-ci */
  ci?: string;
  /** SMS 알림 수신 동의 여부 (nullable)^|false */
  smsAgreed?: boolean;
  /** 성별 <br> - F: 여성 <br> - M: 남성 (nullable)^|M */
  sex?: string;
  /** 지번주소 (nullable)^|성남시 분당구 삼평동 */
  jibunAddress?: string;
  /** openId 액세스 토큰 (nullable)^|test-access-token */
  openIdAccessToken?: string;
  /** 휴대폰번호(필수 권장) (nullable)^|01012344321 */
  mobileNo?: string;
  /** 이름(성) (nullable)^|길동 */
  firstName?: string;
  /** 전화번호 (nullable)^|0213243422 */
  telephoneNo?: string;
  /** 사업자 회원 사업자등록번호 (nullable)^|null */
  registrationNo?: string;
  /** 가입시 동의한 선택 동의 항목 */
  joinTermsAgreements?: string;
  /** 도로명주소 상세 (nullable)^|NHN 플레이 뮤지엄 */
  detailAddress?: string;
  /** 회원 추가항목 목록 */
  extraInfo?: any[];
}

export interface profile-find-password-260111847 {
  /** 휴대전화 번호^| */
  mobileNo: string;
  /** 패스워드 변경 메일 수신 이메일^|te****@nhn.com */
  email: string;
}

export interface profile-password-no-authentication-after-certification1510601967 {
  /** 변경할 비밀번호^|password */
  newPassword: string;
  /** 본인인증 키^|ABCDEFGH */
  key: string;
}

export interface companies-business-exist-1571895320 {
  /** 존재 여부 */
  exist: boolean;
}

export interface config-member-extra-info495587874 {
  /** 회원정보 추가항목 목록^|[ExtraInfoSummaryContent(extraInfoNo=1, extraInfoName=항목명, status=USED, extraInfoType=DROPDOWN, extraInfoOptions=[ExtraInfoOptionSummary(extraInfoOptionNo=10, extraInfoOptionName=옵션값-1), ExtraInfoOptionSummary(extraInfoOptionNo=11, extraInfoOptionName=옵션값-2)])] */
  extraInfoContents: any[];
}

export interface profile-password-sending-email-with-url-1261280262 {
  /** 추가로 전달할 내용 (nullable)^| */
  content?: string;
  /** 비밀번호 변경 화면 uri^|https://www.shoppingmall.com/member/resetPassword */
  url: string;
  /** 회원 ID^|memberId */
  memberId: string;
}

export interface profile-synchronize391953204 {
  /** 액세스 토큰 만료시간^|10000 */
  expiresIn: number;
  /** 리프레시 토큰 만료시간 (nullable)^|null */
  refreshTokenExpiresIn?: number;
  /** 액세스 토큰^|test-access-token */
  accessToken: string;
  /** 토큰 타입 (nullable)^|null */
  tokenType?: string;
  /** 리프레시 토큰 (nullable)^|null */
  refreshToken?: string;
}

export interface profile-report724740315 {
  /** 신고 타입^|ETC */
  reportType: string;
  /** 신고 대상 번호^|1001 */
  accusedMemberNo: number;
  /** 신고 내용^|신고 이유 */
  reportReason: string;
}

export interface profile-find-id2068054830 {
  /** 성 (nullable)^|null */
  lastName?: string;
  /** 이름 (nullable)^|null */
  firstName?: string;
  /** 아이디 찾기 방법^|MOBILE */
  findMethod: string;
  /** 인증번호 (nullable)^|null */
  certificationNo?: string;
  /** 성명 (nullable)^|이쇼핑 */
  memberName?: string;
  /** 휴대폰번호^|01012345678 */
  mobileNo: string;
  /** 본인인증 키^|asdf */
  key: string;
  /** 이메일 주소^|commerce@nhn-commerce.com */
  email: string;
}

export interface profile-mobile-exist578354644 {
  /** 번호 존재 여부^|true */
  mobileNoExist: boolean;
  /** 회원 상태^|ACTIVE */
  status: string;
  /** 해당 휴대폰 번호로 등록되어있는 마스킹된 회원 ID^|membe*** */
  memberId: string;
}

export interface profile-non-masking355828953 {
  /** 광고 우편물(DM) 수신 거부 일시 (nullable)^|2025-10-29 17:05 */
  directMailDisagreeYmdt?: string;
  /** 회사명 (nullable)^|(주)새회사 */
  businessName?: string;
  /** 거주 국가 (nullable)^|KR */
  countryCd?: string;
  /** 우편번호 (nullable)^|우편번호 */
  zipCd?: string;
  /** 푸쉬 알림 동의 여부 - deprecated^|false */
  pushNotificationAgreed: boolean;
  /** 회원 등급 이미지 (nullable)^|uploadedFileName.jpg */
  memberGradeImageUrl?: string;
  /** 광고 우편물(DM) 수신 동의 일시 (nullable)^|2025-10-29 17:05 */
  directMailAgreeYmdt?: string;
  /** 광고 우편물(DM) 수신 동의 여부^|false */
  directMailAgreed: boolean;
  /** 추가 정보 - jsonString 형태, server api 조회 시 additionalInfo 로 바이 패스 해줍니다. (nullable)^|{"hello":"value"} */
  additionalInfo?: string;
  /** 가입 일시^|2025-10-29 17:05 */
  joinYmdt: string;
  /** (국내, 해외 겸용) 국내: 군/구, 해외: 주 (nullable)^|null */
  state?: string;
  /** 회원 아이디^|hongman1 */
  memberId: string;
  /** 최근 접속 시간 (nullable)^|2025-10-29T17:04:53.929323036 */
  lastLoginYmdt?: string;
  /** 인증 타입 (nullable)^|MOBILE/SMS/EMAIL */
  certificationType?: string;
  /** 연동된 SNS 리스트 (nullable)^|["PAYCO","NAVER"] */
  providerTypes?: any[];
  /** 단문메시지서비스(SMS) 동의 여부^|false */
  smsAgreed: boolean;
  /** 도로명 주소 (지번 주소) (nullable)^|지번 주소 */
  jibunAddress?: string;
  /** 단문메시지서비스(SNS) 동의 일시 (nullable)^|2025-10-29 17:05 */
  smsAgreeYmdt?: string;
  /** 환불 계좌 은행 (nullable)^|KB */
  refundBank?: string;
  /** 이름 (nullable)^|홍길동 */
  firstName?: string;
  /** 회원 번호^|12345 */
  memberNo: number;
  /** 환불 계좌 예금주명 (nullable)^|홍길동 */
  refundBankDepositorName?: string;
  /** 일반 전화 번호 (nullable)^|01012341234 */
  telephoneNo?: string;
  customTermsAgreement?: any[];
  /** 푸쉬 알림 거부 일시 - deprecated (nullable)^|2025-10-29 17:05 */
  pushNotificationDisagreeYmdt?: string;
  /** 환불 계좌 번호 */
  refundBankAccount?: string;
  /** 회원 추가항목 정보 */
  extraInfo: any[];
  /** 회원 그룹 이름 (nullable)^|샘플그룹 */
  memberGroupNames?: string;
  /** 생년월일. yyyyMMdd (nullable)^|19900406 */
  birthday?: string;
  /** 쇼핑몰 이름 (nullable)^| */
  mallName?: string;
  /** 성 (nullable)^|홍길동 */
  lastName?: string;
  /** (국내, 해외 겸용) 도시 (nullable)^|null */
  city?: string;
  /** 회원 상태^|ACTIVE */
  memberStatus: string;
  /** 회원 이름 (nullable)^|홍길동 */
  memberName?: string;
  /** 마지막 연동 SNS (nullable)^|PAYCO */
  providerType?: string;
  /** 인증 여부^|false */
  principalCertificated: boolean;
  /** 마지막 접속 IP (nullable)^|127.0.0.1 */
  lastLoginIp?: string;
  /** 닉네임 (nullable)^|hongman */
  nickname?: string;
  /** 회원 그룹 */
  memberGroups: any[];
  /** 추천한 회원 아이디 (nullable)^|null */
  recommender?: string;
  /** 이메일 주소 (nullable)^|hong@nhn.com */
  email?: string;
  /** 선택 동의 항목 상세 */
  agreedTermsInfos: any[];
  /** 도로명 주소 상세 (지번 주소) (nullable)^|지번 상세 주소 */
  jibunDetailAddress?: string;
  /** 선택 동의 항목^|ACCESS_GUIDE */
  agreedTerms: any[];
  /** 도로명 주소 (nullable)^|도로명 주소 */
  address?: string;
  /** 성인 인증 여부^|false */
  adultCertificated: boolean;
  /** 국제전화번호 코드 (nullable)^|null */
  mobileCountryCode?: string;
  /** 성인 인증 일시 (nullable)^|2025-10-29 17:05 */
  adultCertificatedYmdt?: string;
  /** 성별 (F, M) (nullable)^|M */
  sex?: string;
  /** 가입 경로 (nullable)^|PC_WEB */
  joinTypeName?: string;
  /** 핸드폰 번호 (nullable)^|01012341234 */
  mobileNo?: string;
  /** 단문메시지서비스(SNS) 거부 일시 (nullable)^|2025-10-29 17:05 */
  smsDisagreeYmdt?: string;
  /** 로그인 횟수 (nullable)^|10 */
  loginCount?: number;
  /** 회원 등급 이름 (nullable)^|VVIP */
  memberGradeName?: string;
  /** 회원 등급 번호^|1 */
  memberGradeNo: number;
  /** 사업자 등록번호 (nullable)^|1231212345 */
  registrationNo?: string;
  /** Open Id Key (nullable)^|123456789 */
  oauthIdNo?: string;
  /** 도로명 주소 상세 (nullable)^|도로명 상세 주소 */
  detailAddress?: string;
  /** 푸쉬 알림 동의 일시 - deprecated (nullable)^|2025-10-29 17:05 */
  pushNotificationAgreeYmdt?: string;
  /** 회원 구분 */
  memberType: string;
}

export interface profile-email-exist1345433695 {
  /** 존재 여부^|false */
  exist: boolean;
  /** 회원 상태 (nullable)^|null */
  status?: string;
}

export interface profile-external-member-exist19885919 {
  /** 메일 발송 대상 이메일^|true */
  result: string;
}

export interface profile-blocked-members-605522724 {
  /** 차단 대상 회원 번호^|123 */
  blockedMemberNo: number;
}

export interface profile-rename-29683380 {
  /** 본인인증 확인 키^|20210101000000 */
  key: string;
}

export interface profile-dormancy436655230 {
  /** 최근 접속 일시(nullable)^|2025-10-29 17:04 */
  lastLoginDateTime: string;
  /** joinDateTime으로 대체됨. 가입 일시^|2025-10-29 17:04 */
  joinDate: string;
  /** dormantDateTime으로 대체됨. 휴면 전환 일시^|2025-10-29 17:04 */
  dormantDate: string;
  /** 가입 일시^|2025-10-29 17:04 */
  signUpDateTime: string;
  /** 휴면 전환 일시^|2025-10-29 17:04 */
  dormantDateTime: string;
  /** 이름 (nullable)^|홍길동 */
  memberName?: string;
}

export interface profile-id414893891 {
  /** 이메일 변경 여부 ( true : 이메일 변경 함 (이메일 주소로 newMemberId값으로 변경) , false : 이메일 변경 안함)^|false */
  updatesEmail: boolean;
  /** 회원 ID^|memberId */
  currentMemberId: string;
  /** 변경할 회원 ID^|newMemberId */
  newMemberId: string;
  /** 인증번호^|123456 */
  certificationNumber: string;
}

export interface profile-password-1031112528 {
  /** 변경할 비밀번호 (willChangeNextTime true이면 넣지 않아도 됨) (nullable)^|password1 */
  newPassword?: string;
  /** 다음에 변경 여부^|false */
  willChangeNextTime: boolean;
  /** 기존 비밀번호^|password */
  currentPassword: string;
}

export interface profile-password-search-account784713147 {
  /** 회원번호^|1 */
  memberNo: number;
  /** 본인인증 식별정보 유무^|false */
  hasCI: boolean;
  /** 이름^|테*터 */
  name: string;
  /** 휴대폰번호^|01012**56** */
  mobileNo: string;
  /** 이메일^|em***@email.com */
  email: string;
  /** 회원 상태^|ACTIVE */
  status: string;
}

export interface profile-external-member-exist1934641967 {
  /** IdP(Identity Provider, 아이디 제공자) 엑세스 토큰^|test-access-token */
  openAccessToken: string;
}

