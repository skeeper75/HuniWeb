# 정책 · 회원·인증 (membership-auth)

> 엔티티 페이지. 원천: `pq/02_business/policy-checklist.md §3.1`(A-1·A-2·B-6 1순위 미결정).
> 경쟁사 참조: 레드=이메일·SNS4종, 와우=아이디·6등급. tags: #정책 #회원 #인증

### [MEM-01] 로그인 식별자  {🟡권장}
- 내용: 이메일 권장(기존회원 마이그레이션 이슈 없으면). 레드=이메일, 와우=아이디.
- 출처: policy-checklist §3.1 A-1-1 · answers_cq: CQ-POL-01 · tags: #로그인

### [MEM-02] 아이디/비밀번호 찾기  {🟡권장}
- 내용: 아이디=일부 마스킹 / 비번=이메일 재설정 링크 권장(알림톡 계약 필요).
- 출처: policy-checklist §3.1 A-1-2·A-1-3 · tags: #로그인

### [MEM-03] SNS 로그인  {🟡권장}
- 내용: 1차 카카오+네이버(shopby NATIVE) 우선, 2차 구글/애플(EXTERNAL). 레드=4종 전부.
- 출처: policy-checklist §3.1 A-1-SNS·A-1-SNS2 · tags: #SNS

### [MEM-04] 약관·인증  {🔴미결정}
- 내용: 전체동의 버튼 제공(안). 14세 미만·휴대전화 인증(SMS vs PASS) 미정. 1인1계정 제한.
- 출처: policy-checklist §3.1 A-2-1·A-2-4 · tags: #약관 #본인인증

### [MEM-05] 비회원 주문  {🟡권장}
- 내용: 허용 권장(주문번호+휴대전화). 레드=가능.
- 출처: policy-checklist §3.1 A-2-GUEST · 연결: [[order-payment]] · tags: #비회원

### [MEM-06] 회원등급 체계  {🟡권장}
- 내용: 4단계 권장. 와우=6단계(3개월 접수액 기준). 등급별 쿠폰 연동.
- 출처: policy-checklist §3.1 B-6-GRADE · 연결: [[coupon#CPN-04]] · tags: #등급

### [MEM-07] 가입완료 혜택  {🟡권장}
- 내용: 쿠폰+적립금 복합(권장). 와우=쿠폰4종+무료배송.
- 출처: policy-checklist §3.1 A-2-5 · 연결: [[coupon#CPN-01]] · tags: #가입혜택
