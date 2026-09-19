# -*- coding: utf-8 -*-
"""t62 프로세스 정의 1/3 — P01~P09 (회원·인증 · 마이페이지 앞단)."""

SPEC = {}

SPEC['P01'] = dict(
    name='회원가입(이메일 식별자)', l1='회원·인증', l2='가입',
    oneline='처음 온 고객이 약관에 동의하고 휴대전화 본인인증을 거쳐 huni-mall 계정을 만들고, 가입 혜택까지 받는 한 흐름.',
    start='고객이 `/signup` 진입', end='샵바이에 회원 생성 + 가입완료 메일·쿠폰/적립금 지급',
    actors=['고객', 'huni-mall(`/signup`)', '샵바이(member-shop `POST /profile`)', '운영자(셀러어드민 — 약관·혜택 설정)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant M as huni-mall
    participant S as 샵바이
    C->>M: /signup 진입
    M->>C: step1 약관 3종(age14·terms·privacy) + 마케팅 수신동의
    C->>M: 동의 후 다음
    C->>M: step2 이메일·비밀번호·이름·휴대전화
    M->>S: SMS 인증번호 발송 요청
    S-->>C: SMS 인증번호
    C->>M: 인증번호 입력
    M->>S: 인증번호 검증
    M->>S: POST /profile (email·memberId=email·password·mobileNo·certificationNumber)
    Note over M,S: 약관 동의값·마케팅 수신동의는 이 요청에 실리지 않는다(미연동)
    S-->>M: 회원 생성
    M->>C: 가입 완료 화면
    S-->>C: 가입완료 안내 메일(미확인)
    S-->>C: 가입 혜택 쿠폰·적립금(미구현)''',
    flow='''flowchart TD
    A["/signup 진입"] --> B{약관 3종 모두 동의?}
    B -- 아니오 --> B1[다음 버튼 비활성]
    B1 --> B
    B -- 예 --> C{만 14세 이상 체크}
    C -- 아니오 --> C1[가입 차단]
    C -- 예 --> D[필수정보 입력]
    D --> E{휴대전화 SMS 인증 성공?}
    E -- 실패 --> E1[재발송·재입력]
    E1 --> E
    E -- 성공 --> F[POST /profile]
    F --> G{이메일·휴대폰 중복?}
    G -- 중복 --> G1[에러 메시지 · 로그인 유도]
    G -- 없음 --> H[회원 생성]
    H --> I[가입완료 메일 발송]
    H --> J[가입 혜택 자동지급]
    I --> K[[가입 완료]]
    J --> K''',
    steps=[
        ('0. 로그인 식별자 정책 확정(선행)', 'STD-MEM-022', '결정(PM·지니)'),
        ('1. 약관 동의·전체동의', 'STD-MEM-002', 'huni-mall'),
        ('2. 만 14세 미만 가입 제한', 'STD-MEM-004', 'huni-mall'),
        ('3. 휴대전화 본인인증(SMS/PASS)', 'STD-MEM-003', 'huni-mall → 샵바이'),
        ('4. 1인 1계정 중복가입 제한', 'STD-MEM-005', '샵바이'),
        ('5. 회원가입 생성', 'STD-MEM-001', 'huni-mall → 샵바이'),
        ('6. 가입완료 안내 메일 발송', 'STD-MEM-021', '샵바이'),
        ('7. 가입완료 혜택 자동지급(쿠폰+적립금)', 'STD-MEM-006', '샵바이'),
    ],
    gaps=[
        ('다', '약관 동의값(`joinTermsAgreements`)·마케팅 수신동의(`smsAgreed`·`directMailAgreed`)를 폼이 수집하지만 가입 요청에 싣지 않는다 — 몰 약관 ID 매핑이 없다. 샵바이 `POST /profile` 스펙에는 세 필드가 모두 있다.', '김동학', '운영자가 셀러어드민에서 약관 ID 확정'),
        ('나', '가입완료 혜택 자동지급(`STD-MEM-006`) 행은 있으나 코드·설정 지점을 찾지 못했다 — 샵바이 네이티브 혜택인지 별도 구현인지 미확정.', '최숙진', '쿠폰 발행 설계(P19) 확정'),
        ('라', '로그인 식별자 정책(이메일 전용 vs 아이디)이 미확정 — 현재 코드는 `memberId = email` 로 고정돼 있다.', '지니·신우진', '없음'),
    ],
    fill=[
        '김동학: 셀러어드민 약관 목록에서 약관 ID를 받아 `signup/route.ts` 의 `shopbySignup` 호출에 `joinTermsAgreements`·`smsAgreed`·`directMailAgreed` 를 추가한다.',
        '최숙진: 셀러어드민에서 가입완료 쿠폰·적립금 자동지급 설정이 가능한지 확인하고, 불가하면 `/coupons/issues` 호출 잡을 요청한다.',
        '지니·신우진: 식별자 정책을 확정해 `STD-MEM-022` 를 닫는다.',
    ],
    unknown=[
        '가입완료 안내 메일이 샵바이 네이티브로 자동 발송되는지 — 셀러어드민 메일 템플릿 설정을 확인하지 못했다.',
        '몰 설정의 "가입 시 본인인증 필수" 값 — 코드 주석이 두 경우를 모두 대비하고 있어 실제 설정을 확인하지 못했다.',
    ],
    cross={'STD-MEM-006': '프로모션 P19(쿠폰 발행)와 맞물림 — 같은 카드 t62 안'},
)

SPEC['P02'] = dict(
    name='소셜 로그인 가입·연결', l1='회원·인증', l2='로그인',
    oneline='고객이 카카오·네이버·구글·애플 계정으로 최초 로그인해 추가정보를 채우고 정회원(ACTIVE)이 되는 흐름.',
    start='고객이 로그인 화면에서 소셜 버튼 클릭', end='`POST /profile/openid` 로 WAITING → ACTIVE 전환',
    actors=['고객', 'huni-mall(`/oauth/callback`·`/social-join`)', '샵바이(member-shop `/profile/openid`)', '운영자(셀러어드민 간편로그인 앱 등록)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant M as huni-mall
    participant P as 소셜 제공자
    participant S as 샵바이
    C->>M: 소셜 버튼 클릭
    M->>S: openId 로그인 URL 요청
    S-->>M: 제공자 인가 URL
    M->>P: 리다이렉트
    P-->>M: /oauth/callback?code=...
    M->>S: openId 토큰 교환
    S-->>M: accessToken + 회원상태(WAITING/ACTIVE)
    alt WAITING(최초)
        M->>C: /social-join 추가정보 화면
        C->>M: 약관·필수항목 입력
        M->>S: POST /profile/openid (Version 1.1)
        S-->>M: ACTIVE 전환
    end
    M->>C: 로그인 완료''',
    flow='''flowchart TD
    A[소셜 버튼] --> B{셀러어드민 간편로그인 앱 등록?}
    B -- 미등록 --> B1[제공자 오류 · 로그인 불가]
    B -- 등록 --> C[제공자 인가]
    C --> D{Redirect URI 일치?}
    D -- 불일치 --> D1[콜백 실패]
    D -- 일치 --> E[토큰 교환]
    E --> F{회원상태}
    F -- ACTIVE --> H[[로그인 완료]]
    F -- WAITING --> G["/social-join 추가정보"]
    G --> G1{약관 타입·필수항목이 몰 설정과 일치?}
    G1 -- 불일치 --> G2[가입 완료 실패]
    G1 -- 일치 --> H''',
    steps=[
        ('0. 간편로그인 앱 등록·Redirect URI 등록(전제)', 'STD-MEM-023', '운영자(셀러어드민·제공자 개발자센터)'),
        ('1. 카카오 소셜 로그인', 'STD-MEM-010', 'huni-mall'),
        ('2. 네이버 소셜 로그인', 'STD-MEM-011', 'huni-mall'),
        ('3. 구글/애플 소셜 로그인', 'STD-MEM-012', 'huni-mall'),
        ('4. 최초 로그인 가입완료(WAITING→ACTIVE) 추가정보', 'STD-MEM-024', 'huni-mall → 샵바이'),
    ],
    gaps=[
        ('나', '`STD-MEM-023`(앱 등록·Redirect URI `{origin}/oauth/callback`)은 코드가 아니라 설정 작업 — 셀러어드민과 각 개발자센터에서 등록됐는지 확인하지 못했다.', '최숙진', '몰 도메인(origin) 확정'),
        ('라', '소셜 계정 연결 해제(unlink)·같은 이메일의 일반가입 계정과의 병합 정책이 원장에 없고 결정도 없다.', '신우진', '식별자 정책(`STD-MEM-022`) 확정'),
    ],
    fill=[
        '최숙진: 셀러어드민 간편로그인 앱 3종 등록 상태와 각 개발자센터 Redirect URI 를 캡처로 확인한다.',
        '김동학: `/social-join` 의 약관 타입·필수항목을 몰 설정과 대조해 실검증한다(`STD-MEM-024`).',
    ],
    unknown=[
        '애플 로그인이 실제로 활성인지 — 코드의 `SOCIAL_PROVIDER_MAP` 에는 있으나 몰 설정을 확인하지 못했다.',
    ],
    cross={},
)

SPEC['P03'] = dict(
    name='로그인·세션 유지·비회원 세션', l1='회원·인증', l2='로그인·세션',
    oneline='회원이 로그인해 토큰을 유지하고, 로그인하지 않은 고객도 장바구니·주문까지 갈 수 있게 게스트 세션을 잡아주는 흐름.',
    start='고객이 `/login` 진입 또는 비회원으로 상품 담기', end='세션 유효(자동 갱신) 또는 게스트 식별자 발급',
    actors=['고객', 'huni-mall(NextAuth)', '샵바이(로그인·토큰 갱신)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant M as huni-mall(NextAuth)
    participant S as 샵바이
    C->>M: 아이디(이메일)·비밀번호
    M->>S: 로그인 요청
    S-->>M: accessToken(+expireIn)
    M->>C: 세션 쿠키
    loop 만료 임박
        M->>S: 토큰 갱신(shopbyRefresh)
        S-->>M: 새 accessToken
    end
    C->>M: 로그아웃
    M->>S: POST /api/auth/shopby-logout''',
    flow='''flowchart TD
    A[진입] --> B{로그인 상태?}
    B -- 아니오 --> C{로그인 시도}
    C -- 성공 --> D[세션 발급]
    C -- 실패 --> C1[오류 메시지]
    C -- 건너뜀 --> E[게스트 세션 발급]
    B -- 예 --> D
    D --> F{토큰 만료 임박?}
    F -- 예 --> F1[자동 갱신]
    F1 --> D
    F -- 아니오 --> G[[정상 이용]]
    E --> G
    D --> H{휴면 응답?}
    H -- 예 --> H1[휴면 해제 안내 · P06]''',
    steps=[
        ('1. 아이디/비밀번호 로그인', 'STD-MEM-007', 'huni-mall → 샵바이'),
        ('2. 로그인 세션 유지·자동 갱신', 'STD-MEM-013', 'huni-mall'),
        ('3. 비회원 게스트 세션 처리', 'STD-MEM-014', 'huni-mall'),
    ],
    gaps=[
        ('다', '휴면(dormant) 응답 필드(`expireIn`)를 타입에는 두었으나 휴면 안내·해제 화면으로 이어지는 분기를 찾지 못했다 — P06 과 끊겨 있다.', '김동학', '휴면 정책(`STD-MEM-019`) 확정'),
    ],
    fill=[
        '김동학: 로그인 응답이 휴면일 때 `/profile/dormancy` 해제 화면으로 보내는 분기를 추가한다.',
    ],
    unknown=[
        '게스트 세션이 주문까지 어디서 끊기는지 — 비회원 주문 경로는 t63(장바구니·주문) 범위라 여기서 끝까지 따라가지 않았다.',
    ],
    cross={'STD-MEM-014': 't63 장바구니·주문(비회원 주문)'},
)

SPEC['P04'] = dict(
    name='계정 찾기(아이디·비밀번호)', l1='회원·인증', l2='로그인',
    oneline='로그인하지 못하는 고객이 아이디를 마스킹된 형태로 찾거나, 이메일 링크로 비밀번호를 재설정하는 흐름.',
    start='고객이 `/find-id` 진입', end='마스킹 아이디 노출 또는 재설정 메일 발송',
    actors=['고객', 'huni-mall(`/find-id`)', '샵바이(member-shop `/profile/find-id`·`/profile/find-password`)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant M as huni-mall
    participant S as 샵바이
    C->>M: /find-id 진입 · 이름·휴대전화 입력
    M-->>C: 현재 "준비 중입니다" 토스트(호출 없음)
    Note over M,S: 아래는 스펙상 있어야 할 호출 — 코드 0
    M->>S: POST /profile/find-id
    S-->>M: 마스킹 아이디
    M->>S: POST /profile/password/sending-email-with-url
    S-->>C: 재설정 링크 메일''',
    flow='''flowchart TD
    A["/find-id"] --> B{탭 선택}
    B -- 아이디 찾기 --> C[이름·휴대전화 인증]
    C --> D[마스킹 아이디 노출]
    B -- 비밀번호 --> E[아이디·이메일 입력]
    E --> F[재설정 링크 메일]
    F --> G[새 비밀번호 저장]
    D -.현재.-> X[준비 중입니다 토스트]
    G -.현재.-> X''',
    steps=[
        ('1. 아이디 찾기(마스킹)', 'STD-MEM-008', 'huni-mall → 샵바이'),
        ('2. 비밀번호 재설정(이메일 링크)', 'STD-MEM-009', 'huni-mall → 샵바이'),
    ],
    gaps=[
        ('나', '화면·폼은 있으나 두 기능 모두 "준비 중입니다" 토스트로 끝난다. 샵바이 shop API 에는 `/profile/find-id`·`/profile/find-password`·`/profile/password/sending-email-with-url` 이 모두 있다 — 배선만 남았다.', '김동학', '없음'),
    ],
    fill=[
        '김동학: `find-id-form.tsx` 의 두 분기를 샵바이 shop API 호출로 교체한다. 본인확인 방식(SMS vs 이메일)은 `/profile/password/no-authentication/certificated-by-sms|email` 중 몰 설정에 맞는 쪽을 고른다.',
    ],
    unknown=[
        '아이디 찾기의 본인확인 수단(SMS·CI·이메일) 중 어떤 것이 몰 설정에서 허용되는지 확인하지 못했다.',
    ],
    cross={},
)

SPEC['P05'] = dict(
    name='회원정보 변경·탈퇴', l1='회원·인증', l2='회원',
    oneline='회원이 내 정보를 고치고, 비밀번호를 바꾸고, 필요하면 탈퇴하는 흐름.',
    start='마이페이지 → 회원정보', end='정보 갱신 또는 탈퇴 완료(되돌릴 수 없음)',
    actors=['고객', 'huni-mall(`/mypage/account`·`/mypage/withdraw`)', '샵바이(`GET/PUT/DELETE /profile`)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant M as huni-mall
    participant S as 샵바이
    C->>M: /mypage/account
    M->>S: GET /profile
    S-->>M: 현재 값
    C->>M: 수정 후 저장
    M->>S: PUT /profile (조회값 라운드트립 + 덮어쓰기)
    C->>M: 비밀번호 변경
    M->>S: PUT /profile/password
    C->>M: /mypage/withdraw · 사유 입력
    M->>S: DELETE /profile?reason=...
    S-->>M: 탈퇴 완료''',
    flow='''flowchart TD
    A["/mypage/account"] --> B{비밀번호 재확인 통과?}
    B -- 아니오 --> B1[진입 차단]
    B -- 예 --> C[정보 수정]
    C --> D[PUT /profile]
    A --> E[비밀번호 변경]
    E --> F{현재 비밀번호 일치?}
    F -- 아니오 --> F1[오류]
    F -- 예 --> G[PUT /profile/password]
    A --> H["/mypage/withdraw"]
    H --> I{탈퇴 동의 + 사유}
    I -- 미동의 --> I1[차단]
    I -- 동의 --> J[DELETE /profile]
    J --> K[[탈퇴 완료 · 되돌릴 수 없음]]''',
    steps=[
        ('1. 회원정보 수정(비밀번호 재확인)', 'STD-MEM-015', 'huni-mall → 샵바이'),
        ('2. 비밀번호 변경', 'STD-MEM-016', 'huni-mall → 샵바이'),
        ('3. 회원탈퇴', 'STD-MEM-017', 'huni-mall → 샵바이'),
    ],
    gaps=[
        ('다', '비밀번호 재확인 게이트(`/profile/check-password`)가 샵바이 스펙에는 있으나 `/mypage/account` 진입에 걸려 있는지 확인하지 못했다.', '김동학', '없음'),
        ('라', '탈퇴 시 프린팅머니 잔액·미사용 쿠폰 처리 규칙이 원장에도 결정에도 없다.', '최숙진·신우진', '프린트머니 원장 소유 결정(`STD-MYP-051`)'),
    ],
    fill=[
        '김동학: `/mypage/account` 진입 전 `/profile/check-password` 를 태우고, 탈퇴 전 잔액 경고를 붙인다(정책 확정 후).',
        '최숙진: 탈퇴 시 잔액·쿠폰 처리 규칙을 정해 원장 행으로 올린다(gaps 제안).',
    ],
    unknown=[
        '탈퇴 후 재가입 제한 기간이 몰 설정에 있는지 확인하지 못했다.',
    ],
    cross={'STD-MEM-017': 'P10 프린팅머니(잔액 처리 미정)'},
)

SPEC['P06'] = dict(
    name='회원등급·휴면 생애주기', l1='회원·인증', l2='회원',
    oneline='구매 실적에 따라 등급이 오르내리고, 오래 쓰지 않으면 휴면으로 내려갔다가 본인확인으로 돌아오는 흐름.',
    start='등급 산정 배치 또는 최종 로그인 후 경과', end='등급 갱신·혜택 지급 또는 휴면 전환·복구',
    actors=['고객', '샵바이(`/grades`·`/profile/grades`·`/profile/dormant`)', '운영자(셀러어드민 — 수동 조정)'],
    seq='''sequenceDiagram
    autonumber
    participant S as 샵바이
    actor C as 고객
    actor A as 운영자
    S->>S: 등급 산정 배치(기간·실적 기준)
    S-->>C: 등급 승급 안내 · 등급 쿠폰(P19)
    A->>S: 예외 회원 등급 수동 조정
    S->>S: 최종 로그인 N개월 경과 판정
    S-->>C: 휴면 전환 사전 고지(미확인)
    S->>S: 휴면 전환
    C->>S: 본인확인 후 휴면 해제(/profile/dormancy)''',
    flow='''flowchart TD
    A[등급 산정 주기] --> B{실적 기준 충족}
    B -- 예 --> C[자동 승급]
    B -- 아니오 --> D[등급 유지·강등]
    C --> E[등급 쿠폰 발행 · P19]
    F[최종 로그인 경과] --> G{휴면 기준 도달?}
    G -- 예 --> H[사전 고지]
    H --> I[휴면 전환]
    I --> J{본인확인 복구 시도}
    J -- 성공 --> K[[정상 복구]]
    J -- 미시도 --> L[휴면 유지]
    M[운영자 수동 조정] --> C''',
    steps=[
        ('1. 회원등급 산정·자동 승급', 'STD-MEM-018', '샵바이'),
        ('2. 회원등급 수동 조정', 'STD-ADC-002', '운영자(셀러어드민)'),
        ('3. 휴면계정 전환·복구', 'STD-MEM-019', '샵바이'),
    ],
    gaps=[
        ('나', '등급·휴면 모두 샵바이 server API(`/grades`·`/profile/grades`·`/profile/dormant`·`/profile/dormant-release`)와 shop API(`/member-grades`·`/profile/dormancy`)가 있으나 huni-mall·webadmin 어디에서도 호출 지점을 찾지 못했다.', '서희항·최숙진', '등급 체계(등급 수·기준) 확정'),
        ('라', '등급 체계 자체(몇 등급·기준 금액·혜택)가 원장에도 결정 문서에도 없다.', '지니·최숙진', '없음'),
        ('가', '휴면 전환 사전 고지(메일·SMS) 발송이 원장에 행으로 없다 — 정보통신망법상 사전 통지가 필요하다.', '최숙진', '휴면 정책 확정'),
    ],
    fill=[
        '최숙진: 셀러어드민 등급·휴면 설정 화면을 캡처해 현 설정을 확정한다.',
        '김동학: 휴면 로그인 응답 → `/profile/dormancy` 해제 화면 분기를 붙인다(P03 과 같은 결함).',
    ],
    unknown=[
        '등급 산정이 샵바이 네이티브 배치로 도는지, 별도 호출이 필요한지 확인하지 못했다.',
    ],
    cross={'STD-MEM-018': 'P19 쿠폰 발행(등급 쿠폰)'},
)

SPEC['P07'] = dict(
    name='구 사이트 회원·프린트머니 잔액 이관', l1='회원·인증', l2='회원',
    oneline='구 ASP 사이트의 회원과 프린트머니 잔액을 새 몰로 한 번에 옮기는, 되돌릴 수 없는 일회성 흐름.',
    start='구 사이트 회원·잔액 스냅샷 수령', end='샵바이 회원 생성 + 프린트머니 시드 적재 + 대사(reconcile)',
    actors=['운영자', '샵바이(`/profile/bulk`)', 'webadmin(프린트머니 원장)', 'PitStop Server(구 잔액 원천)'],
    seq='''sequenceDiagram
    autonumber
    actor A as 운영자
    participant O as 구 사이트/PitStop
    participant S as 샵바이
    participant W as webadmin
    A->>O: 회원·잔액 스냅샷 요청
    O-->>A: CSV 스냅샷(코드·DB 미제공)
    A->>S: POST /profile/bulk (회원 일괄 생성)
    S-->>A: 생성 결과·실패 목록
    A->>W: 프린트머니 시드 적재(M5)
    W-->>A: 잔액 대사표
    A->>A: 건수·합계 대사 후 확정''',
    flow='''flowchart TD
    A[스냅샷 수령] --> B{식별자 매칭 가능?}
    B -- 불가 --> B1[미매칭 원장 · 수동 처리]
    B -- 가능 --> C[회원 일괄 생성]
    C --> D{생성 실패 행}
    D -- 있음 --> D1[재시도·수동]
    D -- 없음 --> E[프린트머니 시드 적재]
    E --> F{잔액 합계 = 스냅샷 합계?}
    F -- 불일치 --> F1[중단 · 원인 추적]
    F -- 일치 --> G[[이관 확정]]''',
    steps=[
        ('0. 구 ASP 코드·DB 미제공 전제 확정', 'STD-MYP-026', '결정(최숙진)'),
        ('1. 이관·PitStop 연동 담당 확정', 'STD-MYP-024', '결정(미정)'),
        ('2. 기존 회원 데이터 이관', 'STD-MEM-020', '운영자 → 샵바이'),
        ('3. 기존 프린트머니 잔액 이관', 'STD-MYP-009', 'webadmin'),
        ('4. 프린트머니 M5 — 마이그레이션 시드 실행', 'STD-MYP-047', 'webadmin'),
    ],
    gaps=[
        ('라', '이관·PitStop 연동 담당이 `미정` 이다(`STD-MYP-024`). 담당이 없으면 시작할 수 없다.', '신우진', '없음'),
        ('나', '프린트머니 시드를 받을 그릇(`t_pm_charge_txn`)이 webadmin 에 없다 — 저장소 전체 검색에서 한 건도 찾지 못했다.', '서희항', '`STD-MYP-043`(M1 원장 생성)'),
        ('라', '이관 시점의 잔액 기준일·동결 구간(구 사이트 사용 중지 시각)이 정해져 있지 않다.', '신우진·지니', '컷오버 일정'),
    ],
    fill=[
        '신우진: `STD-MYP-024`·`STD-MYP-023` 담당을 배정한다.',
        '서희항: `t_pm_charge_txn` 을 먼저 만들고(P10 M1), 그 위에 시드를 적재한다.',
        '최숙진: 구 사이트 잔액 스냅샷의 포맷·전달 시점을 확정한다.',
    ],
    unknown=[
        'PitStop Server 가 잔액 원천인지, 구 ASP DB 가 원천인지 — 두 표현이 원장에 섞여 있고 실물을 확인하지 못했다.',
        '구 회원의 비밀번호 이관 가능 여부(해시 호환) — 확인하지 못했다.',
    ],
    cross={'STD-MEM-020': 't65 시스템·플랫폼(컷오버 일정)'},
)

SPEC['P08'] = dict(
    name='마이페이지 주문 조회·상세', l1='마이페이지', l2='주문',
    oneline='회원이 마이페이지에서 내 주문을 목록·상세로 확인하고, 편집상품이면 만든 시안을 다시 보는 흐름.',
    start='로그인 후 `/mypage` 진입', end='주문 상세(사양·파일·상태) 확인 또는 시안 미리보기',
    actors=['고객', 'huni-mall(`/mypage`·`/mypage/orders`)', '샵바이(`/profile/orders`)', '위젯/Edicus(시안)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant M as huni-mall
    participant S as 샵바이
    participant E as Edicus/위젯
    C->>M: /mypage
    M->>S: GET /profile/orders/summary/status
    M->>S: GET /profile/orders (최근 2건)
    M->>C: 대시보드(주문요약·머니·쿠폰)
    C->>M: /mypage/orders
    M->>S: GET /profile/orders?months=3
    C->>M: 주문 상세
    M->>S: GET /profile/orders/{orderNo}
    C->>M: 편집상품 미리보기 클릭
    M-->>E: onClick 없음(데드 버튼)''',
    flow='''flowchart TD
    A["/mypage"] --> B[대시보드 요약]
    B --> C["/mypage/orders"]
    C --> D{조회 기간·상태 필터}
    D --> E[주문 목록]
    E --> F[주문 상세]
    F --> G{편집상품?}
    G -- 예 --> H[시안 미리보기]
    G -- 아니오 --> I[사양·파일·상태 표시]
    H -.현재.-> H1[버튼에 onClick 없음]
    A --> J[통합 검색결과 LIST]
    J -.현재.-> J1[화면 없음]''',
    steps=[
        ('1. 마이페이지 메인 대시보드', 'STD-MYP-017', 'huni-mall'),
        ('2. 마이페이지 서브메인(기능군 랜딩)', 'STD-MYP-018', 'huni-mall'),
        ('3. 주문 목록 조회', 'STD-MYP-001', 'huni-mall → 샵바이'),
        ('4. 주문 상세 조회(사양·파일·상태)', 'STD-MYP-002', 'huni-mall → 샵바이'),
        ('5. 편집상품 미리보기', 'STD-MYP-003', 'huni-mall + 위젯/Edicus'),
        ('6. 마이페이지 통합 검색결과 LIST', 'STD-MYP-019', 'huni-mall'),
    ],
    gaps=[
        ('다', '편집상품 미리보기 버튼이 데드 버튼이다 — `configurator-actions.tsx:170-176` 에 `onClick` 이 없다. 미리보기 산출물 자체는 Edicus/위젯 몫이라 양쪽이 끊겨 있다.', '김동학 + 서희항', 'Edicus 미리보기 URL 계약 확정'),
        ('나', '마이페이지 통합 검색결과 LIST 화면(`STD-MYP-019`)의 코드를 찾지 못했다.', '김동학', 'IA 확정'),
        ('라', '주문 상세에 "사양"(위젯 옵션 조합)을 어디서 읽어올지 — 샵바이 주문 옵션인지 webadmin 위젯 주문인지 확정되지 않았다.', '김동학·서희항', 'order/register 경로 선택(t61 결정 안건)'),
    ],
    fill=[
        '서희항: Edicus 시안 미리보기 URL(또는 썸네일) 계약을 제시한다.',
        '김동학: 그 계약으로 `configurator-actions.tsx` 버튼을 배선하고, 주문 상세에 사양 블록을 붙인다.',
    ],
    unknown=[
        '통합 검색 대상이 주문만인지 쿠폰·문의까지인지 — IA 원본을 확인하지 못했다.',
    ],
    cross={'STD-MYP-003': 't63 원고·파일(에디터·시안)'},
)

SPEC['P09'] = dict(
    name='편집 디자인·옵션 보관함', l1='마이페이지', l2='보관함',
    oneline='고객이 에디터에서 만든 시안과 견적 옵션 조합을 저장해 두었다가 나중에 불러와 장바구니로 잇는 흐름.',
    start='에디터 편집 종료 또는 위젯 옵션 선택 완료', end='보관함에서 불러와 장바구니 담기 또는 보관기간 만료',
    actors=['고객', 'huni-mall(보관함 화면)', '위젯/webadmin(옵션·시안 원천)', 'Edicus(편집 산출물)'],
    seq='''sequenceDiagram
    autonumber
    actor C as 고객
    participant E as Edicus/위젯
    participant M as huni-mall
    participant W as webadmin
    C->>E: 편집 종료
    E->>M: 시안 식별자 전달
    M->>W: 보관 저장(저장 시점 미확정)
    C->>M: 보관함 열기
    M->>W: 보관 목록 조회
    C->>M: 불러오기 → 장바구니
    W->>W: 보관기간 만료 정리(미구현)''',
    flow='''flowchart TD
    A[편집 종료] --> B{저장 시점 규칙}
    B -- 저장 버튼 --> C[명시 저장]
    B -- 자동 --> C
    B -- 미정 --> B1[[결정 필요]]
    C --> D[보관함 목록]
    D --> E{보관기간 내?}
    E -- 만료 --> E1[만료 처리·삭제]
    E -- 유효 --> F[불러오기]
    F --> G{장바구니 담기}
    G -- 담음 --> H[[주문 흐름 · t63]]
    G -- 이탈 --> I[이탈 고객 안내]
    I -.현재.-> I1[안내 방법 미정]''',
    steps=[
        ('1. 편집 디자인 보관함(편집 종료 후 보관)', 'STD-MYP-030', 'huni-mall + 위젯'),
        ('2. 보관함 저장 시점 결정', 'STD-MYP-031', '결정(신우진)'),
        ('3. 옵션보관함 저장/불러오기', 'STD-MYP-004', 'huni-mall'),
        ('4. 보관 기간 정책 적용·만료 처리', 'STD-MYP-005', 'huni-mall/webadmin'),
        ('5. 편집 후 이탈 고객 안내 방법', 'STD-MYP-032', 'huni-mall'),
        ('6. 보관함을 일반 상품까지 확대할지', 'STD-MYP-033', '결정(신우진)'),
    ],
    gaps=[
        ('라', '저장 시점(저장 버튼 vs 편집 종료 자동)·확대 범위(편집상품만 vs 일반상품)가 모두 미결이다. 두 결정이 없으면 화면을 그릴 수 없다.', '신우진', '없음'),
        ('나', '보관함 저장·조회를 받을 API·테이블을 huni-mall·webadmin 어디에서도 찾지 못했다.', '김동학·서희항', '저장 시점 결정'),
        ('가', '보관기간 만료 사전 안내(만료 D-N 알림) 행이 원장에 없다.', '최숙진', '보관 기간 정책 확정'),
    ],
    fill=[
        '신우진: 저장 시점·확대 범위 2건을 결정한다.',
        '서희항: 보관 대상(시안 식별자·옵션 조합 JSON)의 저장 그릇을 webadmin 에 제안한다.',
        '김동학: 보관함 화면과 불러오기 → 장바구니 배선을 만든다.',
    ],
    unknown=[
        '현재 에디터 산출물이 어디에 남는지(Edicus 계정 저장소 vs 후니 S3) 확인하지 못했다 — t63/t64 범위와 겹친다.',
    ],
    cross={'STD-MYP-030': 't63 원고·파일(에디터·업로드)'},
)
