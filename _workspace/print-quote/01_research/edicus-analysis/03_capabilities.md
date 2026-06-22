# 03. Capabilities — 라우트, API, 플로우, 통합

생성일: 2026-05-27

---

## 1. Next.js 페이지 라우트 (App Router, `src/app/`)

| URL 패턴 | 파일 | 역할 |
|----------|------|------|
| `/` | `app/page.tsx` | 홈. 히어로 + 카테고리 필터(`명함/전단지/포스터/배너/스티커`) + `ProductGrid` (RSC) |
| `/login` | `app/login/page.tsx` | Firebase 이메일/비밀번호 로그인 |
| `/register` | `app/register/page.tsx` | 회원가입 |
| `/projects` | `app/projects/page.tsx` | 내 프로젝트 목록 (테이블, 편집 재개/주문하기 액션) |
| `/orders` | `app/orders/page.tsx` | 주문 내역 |
| `/editor/[templateId]` | `app/editor/[templateId]/page.tsx` (+loading/error) | `EdicusEditor` 풀스크린 |
| `/vdp/[templateId]` | `app/vdp/[templateId]/page.tsx` (+loading/error) | `VdpEditor` (가변 데이터 입력 사이드바 + iframe) |
| `/mobile` | `app/mobile/page.tsx` (+layout) | 모바일 홈 (카테고리 탭, ProductCard) |
| `/mobile/[productId]` | `app/mobile/[productId]/page.tsx` | 모바일 상품 상세 + `MobileEditor` |
| `/admin` | `app/admin/page.tsx` (+layout) | 관리자 대시보드 |
| `/admin/templates` + `[id]` | admin/templates/* | 템플릿 목록/상세 (Resource API 호출) |
| `/admin/products` | admin/products/page.tsx | 상품 카탈로그 관리 |
| `/admin/orders` | admin/orders/page.tsx | 주문 모니터링 + 잠정/확정 상태 변경 |
| `/admin/shop`, `/admin/billing`, `/admin/shipping`, `/admin/stats`, `/admin/insights`, `/admin/sms`, `/admin/profile`, `/admin/assets`, `/admin/settings` | admin/*/page.tsx | 운영 보조 페이지 9개 (대부분 셸/플레이스홀더 가능성) |

총 34개 페이지 라우트 (README 주장 일치).

## 2. API 엔드포인트 (`src/app/api/edicus/`)

| Method | 경로 | 파일 | 역할 |
|--------|------|------|------|
| POST | `/api/edicus/auth` | api/edicus/auth/route.ts | 사용자 토큰 발급 (Edicus `POST /api/auth/token`) |
| POST | `/api/edicus/auth/staff` | api/edicus/auth/staff/route.ts | 스태프 토큰 발급 |
| GET | `/api/edicus/projects?uid=` | projects/route.ts | uid 프로젝트 목록 |
| POST | `/api/edicus/projects` | projects/route.ts | 프로젝트 복제 |
| DELETE | `/api/edicus/projects` | projects/route.ts | 프로젝트 삭제 |
| POST | `/api/edicus/orders` | orders/route.ts | `{projectId, type: 'tentative' \| 'definitive'}` 주문 생성 |
| DELETE | `/api/edicus/orders` | orders/route.ts | `{orderId}` 주문 취소 |
| GET | `/api/edicus/products?partner=` | products/route.ts | 상품 목록 (Resource API `getProductList`) |
| GET | `/api/edicus/templates?partner=&category=&page=&limit=` | templates/route.ts | 템플릿 쿼리 |
| GET | `/api/edicus/resource/[id]` | resource/[id]/route.ts | 개별 리소스 |
| GET | `/api/edicus/resource/products` | resource/products/route.ts | 리소스 기반 상품 |
| GET | `/api/edicus/resource/query` | resource/query/route.ts | 일반 쿼리 |
| GET, POST | `/api/edicus/css?partner=` | css/route.ts | 파트너 CSS 조회/저장(stub) |

**모든 POST/GET 라우트는 Zod로 입력 검증**. 서버는 `createServerApiClient()`(API 키 헤더) 또는 `createResourceApiClient()`(공개)로 분리.

## 3. 사용자 플로우

### F1. 일반 사용자: 탐색 → 편집 → 주문
1. `/` (홈) — `ProductGrid` RSC가 `GET /api/edicus/products`로 카탈로그 로드
2. `TemplateCard` 클릭 → `/editor/[templateId]` 진입
3. `EdicusEditor` 마운트:
   - `fetchUserToken()` → `POST /api/edicus/auth`
   - `useEdicus` 훅이 `EdicusClient.init()` → 외부 SDK 스크립트 로드
   - `createProject(token, ps_code, title, parent_element)` → iframe 생성
4. 사용자가 iframe 내부에서 편집. SDK 이벤트:
   - `request-user-token` → 토큰 갱신 후 `post_to_editor('send-user-token', {token})`
   - `goto-cart` → `/orders`로 이동
   - `close` → `router.back()`
5. `/orders` 또는 `OrderPanel` (project 상태별 UI):
   - `editing` → 잠정주문 버튼 → `POST /api/edicus/orders {type:'tentative'}`
   - `ordering` → 확정주문/취소 두 버튼
   - `ordered` → 완료 메시지

### F2. VDP 사용자: 가변 데이터 + 편집
1. `/vdp/[templateId]` 진입
2. 사이드바에 `fields[]` (text/number/date) 입력 UI
3. "데이터 적용" → `post_to_editor('set-variable-data', { variableData: fieldValues })`
4. 이후 일반 편집과 동일 (저장/주문)

### F3. 모바일 사용자
1. `/mobile` — 카테고리 탭 + 상품 그리드
2. `/mobile/[productId]` — `MobileEditor` (passive 모드 가능)
3. 하단 `MobileBottomTabBar`, 상단 `PassiveToolbar`

### F4. PC Passive 사용자 (디자인 잠금)
1. `PCPassiveEditor` 컴포넌트 (`HuniEditorSDK`, `passiveMode: true`, `run_mode: 'passive'`)
2. 키보드 단축키: Cmd/Ctrl+Z/Y/S, Esc(닫기 확인)
3. PCPassiveToolbar (Undo/Redo/Save/Done/Close)

### F5. 관리자
1. `/admin` 로그인 → 사이드바 14개 메뉴
2. `/admin/templates` 클릭 → `POST /api/edicus/resource/query` (Resource API)
3. `/admin/products` → `GET /api/edicus/resource/products`
4. `/admin/orders` → `/api/edicus/projects` + `/api/edicus/orders` 호출, 잠정/확정 전환
5. `/admin/settings` → `/api/edicus/css` GET/POST로 파트너 CSS 편집

## 4. 통합 / 외부 의존성

| 외부 서비스 | 용도 | 통합 위치 |
|-------------|------|-----------|
| **Edicus API** (`https://api-dot-edicusbase.appspot.com`) | 프로젝트 CRUD, 주문(잠정/확정/취소), 미리보기, 토큰 발급 | `src/lib/edicus/server-api.ts` |
| **Edicus Resource API** (`https://resource-dot-edicusbase.appspot.com`) | 템플릿/상품 카탈로그 쿼리 | `src/lib/edicus/resource-api.ts` |
| **Edicus Editor iframe** (`https://edicusbase.firebaseapp.com/ed#/...`) | 실제 디자인 캔버스 (외부 호스팅) | `src/lib/edicus/client.ts` (postMessage) |
| **RedEditorSDK v6.6.48** (614KB) | 차세대 SDK 분석 대상 | `ref/RedEditorSDK.js` + `src/lib/red-editor/` (래퍼 + 타입 + 분석본) |
| **Firebase Auth** (v12.10) | 이메일/비밀번호 로그인 | `src/lib/firebase/auth.ts`, `useAuth` 훅 |
| **(예약) DATABASE_URL** | 자체 DB | 환경변수만 존재, 실제 사용 코드 없음 |

**WooCommerce API 클라이언트 없음. S3 직접 업로드 없음 (Edicus가 모두 처리). PDF 생성 없음 (Edicus 백엔드 책임). 인쇄 검수 파이프라인 없음** — As-Is의 WooCommerce File Approval에 해당하는 기능은 본 코드베이스에 부재.

## 5. 미들웨어 / 인프라

- `src/middleware.ts` — Next.js 미들웨어 (인증/라우팅 보호; 추후 확인 가능)
- `playwright.config.ts` — E2E 테스트
- `vitest.config.ts` — 단위 테스트 (161개 통과, 85% 커버리지 주장)
- 배포: **Vercel** (`docs/deployment-guide.md` 상세)

## 6. SPEC 이력 (`README.md`)

| SPEC | 상태 | 내용 |
|------|------|------|
| SPEC-REDSDK-001 | 완료 | Edicus SDK 통합 (EdicusEditor, 토큰 인증, iframe) |
| SPEC-MANAGER-001 | 완료 | 관리자 14개 페이지 |
| SPEC-MOBILE-001 | 완료 | 모바일 에디터, 커스텀 CSS, SDK 분석 자동화 |
| SPEC-CSS-001 | (커밋됨) | 파트너 CSS 프리셋 |
| SPEC-PCPASSIVE-001 | 진행 | PC passive 모드 + 키보드 단축키 |
| SPEC-DESIGN-001 | 진행 | Huni Design System v6.0 (#5538B6 전면 적용) |

이 SPEC들은 본 코드베이스 자체 기록 — 흡수 시 SPEC ID는 폐기/재명명 필요.
