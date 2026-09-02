# L4b — 상태 뒤집힘 (status flip)

> 카드 t31-b · legacy 원판정과 L2 코드 실측이 어긋난 항목. **양방향 전부 기록**한다.
> [HARD] `done` 판정은 전건 L2 file:line 인용. §4-4 경고 유지 — 여기서 `done` 은 **「코드 경로가 배선돼 있다」**이지 「운영에서 성공한다」가 아니다. 서버를 띄워 관찰한 것이 아니다.

---

## A. 정방향 — legacy 미착수/PARTIAL → 실측 `done` (표준 15행)

원장이 「미착수」로 세어둔 것 중 실제로는 이미 배선된 항목이다. 10/6 잔여량 산정에 직접 영향.

| std_id | 표준 기능 | 뒤집힌 legacy_id (원판정) | L2 근거 file:line |
|---|---|---|---|
| STD-MEM-001 | 회원가입(이메일 식별자) | F-005·IA-005 (미착수) · SCOPE-005 (PARTIAL) | `huni-skin-shopby/src/app/api/auth/signup/route.ts:8-33` |
| STD-MEM-007 | 아이디/비밀번호 로그인 | IA-001 (미착수) | `src/lib/auth/auth.config.ts:12-22` · `src/lib/auth/shopby-auth.ts:1` |
| STD-MEM-014 | 비회원 게스트 세션 처리 | IA-073 (미착수) | `src/lib/guest-cart.ts:1-31` · `src/components/checkout/guest-checkout-form.tsx:9-10` · `src/components/order/guest-order-lookup.tsx:4-9` |
| STD-MEM-015 | 회원정보 수정(비밀번호 재확인) | F-021·IA-021 (미착수) · SCOPE-021 (PARTIAL) | `src/lib/api/hooks/use-profile.ts:42` |
| STD-MEM-016 | 비밀번호 변경 | IA-023 (미착수) | `src/lib/api/hooks/use-profile.ts:42` |
| STD-MEM-017 | 회원탈퇴 | IA-024 (미착수) | `src/lib/api/hooks/use-profile.ts:112` · `src/components/mypage/withdraw-section.tsx:4` |
| STD-MYP-001 | 주문 목록 조회 | IA-009 (미착수) | `src/lib/api/hooks/use-my-orders.ts:84` |
| STD-MYP-006 | 프린팅머니 잔액·내역 조회 | **F-014 (미착수·돈)** · IA-014 (대기) · SCOPE-014 (PARTIAL) | `src/lib/api/hooks/use-points.ts:22` |
| STD-MYP-010 | 보유 쿠폰 목록 | IA-012 (미착수) | `src/lib/api/hooks/use-coupons.ts:71` |
| STD-MYP-011 | 쿠폰 번호 등록 | IA-013 (미착수) | `src/lib/api/hooks/use-coupons.ts:71` |
| STD-MYP-012 | 내 리뷰 작성·조회 | **F-018 (미착수·돈)** · IA-017/018 (미착수) | `src/lib/api/hooks/use-review-write.ts:38` · `use-my-reviews.ts:84` |
| STD-PRM-007 | 장바구니/주문서 쿠폰 적용 | **F-126 (미착수·돈)** · IA-126 (미착수) | `src/lib/api/hooks/use-order-coupons.ts:34` |
| STD-SYS-007 | 커머스 API 인증·토큰 관리 | X-OPS-TOKEN-01 · X-SHOPBY-IPALLOW-01 (미착수·주문) | `src/app/api/shopby/[...path]/route.ts:21-45` · `src/app/api/shop/[...path]/route.ts:27-48` |
| **STD-SYS-009** | **가격 계산 결과 카트 주입 브리지** | **X-PRICE-BRIDGE-01 (미착수·돈·주문) · X-BFF-ENDPOINT-01 (돈) · X-NHN-POLICY-01 (돈·주문) · F-049 (돈)** | `src/lib/api/widget-order.ts:26-35` · `src/components/product/huni-widget.tsx:257-265` · `src/app/api/printly/requote/route.ts:16-50` |
| STD-SYS-010 | 원고 저장소(스토리지) 연동 | X-WGTF-S3-01 · X-FILEMETA-01 (검증대기) | `raw/webadmin/webadmin/config/urls.py:250-252` · `catalog/s3_artwork.py:208-280` · `catalog/artwork_promote.py:1` |

### ★ 가장 값나가는 한 건 — STD-SYS-009

원장이 **「1차 최대 리스크 · 양측 독립 동일 지목」**으로 올려둔 `X-PRICE-BRIDGE-01`(동적 계산가 무손실 환원 경로 미확정)이, L2 실측에서는 **위젯 견적가 → shopby 금액 적재(10원×orderCnt) + 수량변경 재견적 라우트**까지 배선돼 있다.

- 이것은 「리스크가 해소됐다」는 뜻이 **아니다**. 배선이 있다는 사실과 그 배선이 금액을 무손실로 옮긴다는 사실은 다르다.
- 돈이 걸린 경로이므로 **L5 P0 테스트 시나리오에서 실제 금액 일치를 관측**해야 한다(§4-4 정적 판독 한계).
- `X-NHN-POLICY-01`(NHN 공식 회신: 동적 가격 산정은 샵바이 미제공)과 정면으로 만나는 지점이다 — 미제공 기능을 우회 배선으로 구현한 상태.

---

## B. 역방향 — legacy `SOLVED` → 실측 stub/absent (표준 12행)

원장이 「해결됨」으로 세어둔 것 중 실제로는 안 되는 항목. **잔여량이 늘어나는 방향**이라 A보다 위험하다.

| std_id | 표준 기능 | legacy (SOLVED) | 실측 | L2 근거 |
|---|---|---|---|---|
| STD-MEM-002 / 004 | 약관 동의 · 14세 제한 | SCOPE-004 | partial | `src/components/auth/signup-form.tsx:24-25,75-76` — "shopby 로 전달하지 않는다(joinTermsAgreements 미연동)" 주석 명시 |
| STD-MEM-006 | 가입완료 혜택 자동지급 | SCOPE-008 | todo | L2 무근거 · X-SHOPBY-NATIVE-01 native 범위 미확인 |
| STD-MEM-008 | 아이디 찾기 | SCOPE-002 | todo | SB-042 stub — `src/components/auth/find-id-form.tsx:50-56` ("준비 중" 토스트) |
| STD-MEM-010/011/012 | 카카오·네이버·구글 소셜 로그인 | SCOPE-145 | todo | SB-041 stub — `src/components/auth/sns-buttons.tsx:74-80` (signIn 미호출) · D-16 providers 빈 배열 |
| STD-MEM-019 | 휴면계정 전환·복구 | SCOPE-147 | todo | `src/lib/auth/shopby-auth.ts:28` 휴면 응답 주석만 · 전환/복구 화면 0건 |
| STD-MYP-013 | 내 상품Q&A / 1:1문의 | SCOPE-016 · SCOPE-020 | todo | SB-056 absent — `src/app/(main)` 하위 inquiry/qna 라우트 부재 |
| STD-PRM-010 | 기획전/할인 이벤트 페이지 | SCOPE-155 | todo | SB-001 partial — `src/lib/legacy-data/hooks.ts:352-360` (프로모 데이터원 빈배열) |
| STD-SYS-001 / 002 | 관리자 계정·권한 | SCOPE-094 | partial | SB-059 stub `src/app/(admin)/admin/page.tsx:1-8` · SB-060 `src/proxy.ts:21-23` ADMIN 검사 미활성 |
| STD-SYS-018 | 개인정보 보관·파기 정책 | SCOPE-084 · SCOPE-085 | partial | SB-057 done(게시) — 게시는 되나 보관·파기 절차 적용은 미확인 |

**공통 패턴**: legacy 의 `SOLVED` 는 대체로 「샵바이가 native 로 준다」는 **전제**였고, 실제 스킨에서는 그 native 를 **호출하지 않았다**. 소셜 로그인·휴면·1:1문의·기획전 운영툴이 모두 같은 모양이다. 이 전제를 다시 쓰지 말고 L5 에서 개별 확인해야 한다.

---

## C. 판정 규칙 공시 (lead 감사용)

L2 의 5상태를 표준 4상태로 옮길 때 쓴 규칙:

| L2 상태 | L4b 판정 | 이유 |
|---|---|---|
| `done` | `done` | file:line 인용 그대로 |
| `partial` | `partial` | 그대로 |
| **`stub`** | **`todo`** | 화면 껍데기만 있고 기능 배선 0건인 것을 `partial` 로 세면 낙관 판정이다(카드 §L4 금지). 사유 칸에 원 L2 상태를 `stub` 으로 남겨 되추적 가능하게 했다 |
| `absent` | `todo` | 그대로 |
| (L2 미커버) | `todo` | 미상을 `done`/`partial` 로 올리지 않는다. 사유 칸에 "L2 무근거" 명시 |
