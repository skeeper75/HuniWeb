# 05. Verdict & Recommendations — pq-pm 1-pager

생성일: 2026-05-27
대상 코드베이스: `/Users/innojini/Dev/HuniWeb/docs/edicus.man/` (Next.js 15, React 19, TypeScript 5, 12K LOC)

---

## 최종 판정

**`docs/edicus.man/`은 buysangsang의 mshop-edicus 플러그인을 "rewrite"한 것이 아니라, 동일한 Edicus 외부 SDK(motion-one 운영, `edicusbase.firebaseapp.com`)를 사용하는 후니프린팅 전용 Next.js 신규 프론트엔드/통합 셸이다.** WordPress 플러그인과 Next.js 앱은 동일한 백엔드를 호출하므로 도메인 모델(프로젝트/주문/템플릿/파트너)이 자연스럽게 정합한다.

**분류**: 부분 흡수 가능 (Edicus 통합 슬라이스에 한해서). 커머스 본체는 별도 신규 구현 필요.

---

## 즉시 흡수 가능한 서브시스템 (Top 3)

### S1. Edicus SDK Integration Stack — 거의 그대로 이식
**경로**:
- `src/types/edicus.ts` (~350 LOC) — SDK 전체 타입 (`EdicusContext`, `EdicusCommonUrlParams`, 10가지 파라미터 변형, `ProjectStatus`)
- `src/lib/edicus/client.ts` — `EdicusClient` 싱글턴 (init, createProject, openProject, postToEditor)
- `src/lib/edicus/server-api.ts` — `ServerApiClient` (토큰, 프로젝트 CRUD, 주문)
- `src/lib/edicus/resource-api.ts` — `ResourceApiClient` (템플릿/상품 카탈로그)
- `src/lib/edicus/huni-editor-sdk.ts` — `HuniEditorSDK` (이벤트 시스템, passive 모드, postMessage origin 검증)
- `src/lib/edicus/env.ts` — Zod 환경변수 스키마
- `src/hooks/useEdicus.ts`, `useHuniEditor.ts` — React 통합 훅
- `src/components/editor/EdicusEditor.tsx`, `VdpEditor.tsx`, `PCPassiveEditor.tsx`, `PCPassiveToolbar.tsx`
- `src/app/api/edicus/**` — 10개 API route (Zod 검증 포함)

**가치**: To-Be 빌더의 "디자인 편집 슬라이스" 50%+ 즉시 완성. partner=`hunip` 하드코딩까지 후니프린팅에 맞춰져 있음.

### S2. Huni Design System v6.0 컴포넌트 셋
**경로**: `src/components/ui/` — 8개 (HuniButton, HuniInput, HuniSelect, HuniCheckbox, HuniRadio, HuniBadge, HuniCard, HuniTab) + 각 컴포넌트 unit test (`__tests__/`)
+ `src/lib/edicus/custom-css.ts` — Huni 디자인 토큰 (`#5538B6` 보라색, `--huni-primary*` CSS 변수, Noto Sans KR)
+ `tailwind.config.ts` — Huni 토큰 매핑

**가치**: To-Be 사이트의 디자인 시스템 베이스라인. 테스트도 같이 옴(161 tests / 85% coverage).

### S3. Project / Order 도메인 모델 + 워크플로
**경로**:
- `src/types/edicus.ts` (`EdicusProject`, `ProjectStatus`)
- `src/types/order.ts` (`OrderStatus`, `Order`, `*OrderRequest`, `OrderResponse`)
- `src/hooks/useOrder.ts` — tentative/definitive/cancel
- `src/components/orders/OrderPanel.tsx`, `OrderStatusBadge.tsx`
- `src/app/api/edicus/orders/route.ts`, `src/app/api/edicus/projects/route.ts`

**가치**: "잠정주문 → 확정주문 → 취소" 워크플로가 검증된 UX와 함께 완성된 형태로 존재.

---

## 흡수 전 해결해야 할 Top 5 리스크/갭

### R1. 가격·옵션 엔진 완전 부재 (CRITICAL)
As-Is의 핵심인 **TM Extra Product Options + Tiered Price Table**에 해당하는 코드가 0%. To-Be 빌더의 "옵션 폼 빌더 + 구간 할인 룰 엔진"은 별도 SPEC(`pq-architect` 책임)으로 신규 설계 필요. 이 부분이 빠지면 견적/주문이 불가능.

### R2. 자체 영속 계층 없음
Edicus 외부 백엔드(`api-dot-edicusbase.appspot.com`)가 모든 프로젝트/주문 데이터를 보관. `DATABASE_URL` 환경변수는 정의만 되어있고 미사용. 후니프린팅이 자체 견적·옵션·고객 데이터를 보유하려면 자체 DB(Postgres/Supabase 등) 도입 필요.

### R3. Firebase Auth 종속 vs NextAuth 마이그레이션
현재 인증이 Firebase 12.10에 묶여있고 README에 "NextAuth.js v5 예정"이라 적혀있음. 후니프린팅의 인증·세션·SSO 전략을 먼저 결정해야 흡수 가능.

### R4. 관리자 페이지 14개 중 실 구현 비율 불명
admin 라우트(템플릿/상품/주문/CSS) 4개는 API 호출 코드 확인. 나머지(billing/shipping/stats/insights/sms/profile/assets/settings/shop) 9개는 라우트만 있고 셸/플레이스홀더일 가능성 높음. 흡수 시 "어디까지 작동하는가" 정밀 점검 필요.

### R5. Edicus 외부 SDK 라이프사이클 의존
빌더 캔버스 전체가 외부 iframe(`edicusbase.firebaseapp.com`)에 위임돼 있어, motion-one이 SDK를 종료/요금 변경/API 변경하면 즉시 영향. RedEditorSDK v6.6.48(`ref/RedEditorSDK.js`, 614KB)이 차세대인지, 후니프린팅이 자체 호스팅할 수 있는지 별도 협의/계약 필요. `docs/red-editor-sdk-analysis.md`가 상세 분석 보유.

---

## 권장 다음 연구 단계

1. **SPEC drop**: pq-architect가 `docs/edicus.man/`을 `_workspace/print-quote/02_design/edicus-integration/`로 매핑하는 흡수 SPEC 작성. S1·S2·S3 단위로 분리.
2. **옵션 엔진 라운드**: pq-researcher가 buysangsang의 단일 상품 `tm_meta_cpf` 페이로드를 1~2개 더 수집(다른 상품 표본)하여 옵션 폼 builder DSL 추정 + Tiered Pricing 룰 구조 구체화.
3. **Edicus 라이선스 확인**: motion-one과의 계약 조건, partner=`hunip` 코드의 유효성, RedEditorSDK 자체 호스팅 가능 여부.
4. **데이터 영속화 결정**: 자체 DB 도입 여부 + Edicus 백엔드 의존도 분리 전략.
5. **관리자 14페이지 실제 동작 점검**: 코드 ≠ README. 어디까지가 셸인지 1시간 정도 추가 탐사.
