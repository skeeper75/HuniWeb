// Auto-generated TypeScript types from workspace-server

export interface app-installed-status1982038195 {
  /** 앱 만료일시^|2025-11-06T11:37:12.241064129 */
  expireDateTime: string;
  /** 앱 설치 상태 - (ACTIVE: 사용중, EXPIRED: 만료(결제대기), DELETED: 삭제)^|ACTIVE */
  currentStatus: string;
  /** 앱 이름^|appName */
  appName: string;
  /** 앱 일련번호^|1 */
  appNo: number;
}

export interface auth-token-long-lived-2112938244 {
  /** accessToken 값 (유효기간 : 무기한)^|abc123 */
  access_token: string;
  /** refreshToken 값 (null)^| */
  refresh_token: string;
  /** access 권한^|[] */
  scopes: string;
  /** 토큰 유효기간^|yyyy-MM-dd HH:mm:ss */
  expire_in: string;
  /** 토큰타입 - Bearer로 고정^|Bearer */
  token_type: string;
  /** 발급일시^|yyyy-MM-dd HH:mm:ss */
  issued_at: string;
}

export interface webhooks-failed-1319741198 {
  /** 조회 결과 */
  contents: any[];
  /** 전체 조회건수 */
  totalCount: number;
}

export interface auth-token1244629579 {
  /** accessToken 값 (5분)^|abc123 */
  access_token: string;
  /** refreshToken 값 (24시간)^|test-refreshToken */
  refresh_token: string;
  /** access 권한^|[] */
  scopes: string;
  /** 유효기간^|yyyy-MM-dd HH:mm:ss */
  expire_in: string;
  /** 토큰타입 - Bearer로 고정^|Bearer */
  token_type: string;
  /** 발급일시^|yyyy-MM-dd HH:mm:ss */
  issued_at: string;
}

export interface external-script-936175978 {
}

export interface auth-token-long-lived1568104223 {
  /** null (장기토큰은 별도 refresh_token이 없습니다)^|test-code */
  refresh_token?: string;
  /** 
 authorization code

 - 확인 방법: authorization code는 워크스페이스>셀러어드민에서 등록한 앱(App)을 설치한 쇼핑몰 어드민 내
 앱서비스>앱리스트>해당 앱 '실행'버튼 클릭 시 
 https://$\{app url}?code=$\{authorization Code}형태로 확인가능합니다.
^|test-code */
  code?: string;
  /** 'authorization_code' 입력^|authorization_code */
  grant_type: string;
  /** 워크스페이스>셀러어드민> 앱 상세페이지 내 'secretKey' 확인가능^|test-secretKey */
  client_secret: string;
  /** 리다이렉트 URI^|http://hello.com */
  redirect_uri?: string;
  /** 워크스페이스>셀러어드민> 앱 상세페이지 내 'systemKey' 확인가능^|test-systemKey */
  client_id: string;
}

export interface auth-token-revoke1044698510 {
  /** 제거할 장기토큰^|access-token */
  token: string;
}

export interface app-installed-extend-186163940 {
  /** 주문 번호^|1 */
  orderNo: string;
  /** 가격(실제 결제된 금액)^|10000 */
  price: number;
  /** 만료일 요청날짜(YYYY-MM-DD hh:mm:ss 외 포맷은 에러. 현재보다 과거시점 지정불가)^|2025-10-27 11:37:13 */
  requestDateTime: string;
  /** 결제 타입 - (TRIAL: 무료 체험, CHARGE: 인앱 유료결제)^|TRIAL */
  paymentType: string;
}

export interface auth-me-746827232 {
  /** 어드민에 로그인한 유저의 소속(개발중)^|운영1파트 */
  departmentName: string;
  partner?: Record<string, any>;
  business?: Record<string, any>;
  mall?: Record<string, any>;
  /** 어드민에 로그인한 유저의 휴대폰번호^|01012341234 */
  mobile: string;
  /** 어드민에 로그인한 유저의 이름^|홍길동 */
  name: string;
  /** 어드민에 로그인한 유저의 롤
(샵바이: MASTER, NORMAL)
(고도몰: SUPER_ADMIN, CS, ADMIN)^|MASTER */
  adminRole: string;
  /** 어드민에 로그인한 유저의 직책(개발중)^|파트장 */
  jobDutyName: string;
  /** 어드민에 로그인한 유저의 아이디^|test */
  id: string;
  /** 솔루션 구분(SHOPBY, GODOMALL)^|SHOPBY */
  solutionType?: string;
  /** 어드민에 로그인한 유저의 직급(개발중)^|부장 */
  jobPositionName: string;
  /** 어드민에 로그인한 유저의 이메일^|abc@nhn-commerce.com */
  email: string;
}

export interface external-script-1063508270 {
  scriptContents?: any[];
}

export interface auth-token-4075154 {
  /** 
리프레시 토큰 (grant_type case②인 경우, 필수 입력 파라미터)<br>
grant_type case①을 통해 발급받은 access_token(5분) 만료 시, 함께 응답받은 refresh_token(24시간)을 보내<br>
grant_type case② 방법으로 access_token을 다시 응답받습니다.
^|test-code */
  refresh_token?: string;
  /**  authorization code (grant_type case①인 경우, 필수 입력 파라미터)

 - 확인 방법: authorization code는 워크스페이스>셀러어드민에서 등록한 앱(App)을 설치한 쇼핑몰 어드민 내
 앱서비스>앱리스트>해당 앱 '실행' 버튼 클릭 시 <br>
 http://$\{app url}?code=$\{authorization Code}형태로 확인가능합니다.
 ^|test-code */
  code?: string;
  /** 2가지 case 중 필요에 따라 ①번> ②번 순으로 진행하실 수 있습니다.

case① authorization_code (authorization code를 통해 access_token을 응답받고자하는 경우)<br>
case② refresh_token (발급된 refresh_token을 통해 만료된 access_token을 응답받고자 하는경우)
^|authorization_code */
  grant_type: string;
  /** 워크스페이스>셀러어드민> 앱 상세페이지 내 'secretKey' 확인가능^|test-secretKey */
  client_secret: string;
  /** 리다이렉트 URI (grant_type case①인 경우, 필수 입력 파라미터)^|http://hello.com */
  redirect_uri?: string;
  /** 워크스페이스>셀러어드민> 앱 상세페이지 내 'systemKey' 확인가능^|test-systemKey */
  client_id: string;
}

