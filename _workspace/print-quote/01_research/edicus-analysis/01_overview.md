# 01. Overview — `docs/edicus.man/` 정체성 검증

생성일: 2026-05-27
대상: `/Users/innojini/Dev/HuniWeb/docs/edicus.man/`

---

## Blockers (없음)

- 모든 핵심 파일(.ts/.tsx, README, CLAUDE.md, ref) 접근 가능
- `ref/edicus-dev/` 디렉터리는 비어있는 것으로 확인됨 (실제 SDK 파일은 `ref/RedEditorSDK.js` 614KB로 별도 존재)

---

## 1. 프로젝트 식별

| 항목 | 값 |
|------|-----|
| package.json `name` | `edicus-man` |
| version | `0.1.0` (private) |
| README 한국어 제목 | "후니프린팅 (edicus.man)" |
| README 요약 | "웹-투-프린트 SaaS 플랫폼 … Edicus SDK를 활용한 브라우저 기반 인쇄 디자인 편집" |
| 환경변수 partner 기본값 | **`hunip`** (`NEXT_PUBLIC_EDICUS_PARTNER`, `docs/deployment-guide.md`) |
| Edicus 베이스 URL | `https://edicusbase.firebaseapp.com` |

## 2. 기술 스택

| 카테고리 | 라이브러리 / 버전 | 비고 |
|---------|-------------------|------|
| Framework | Next.js **15.3.1** (App Router, Turbopack dev) | `package.json:20` |
| UI 런타임 | React **19** | `package.json:21-22` |
| 언어 | TypeScript **5** (strict) | `tsconfig.json` |
| 스타일 | Tailwind CSS **3.4.19**, class-variance-authority, tailwind-merge | |
| 상태 관리 | Zustand 5, TanStack React Query 5 | |
| 스키마 검증 | **Zod 3.24** | env, 모든 API route 입력 검증 |
| 인증 | **Firebase 12.10** (로그인/세션) | `src/lib/firebase/` |
| 아이콘 | lucide-react | |
| 테스트 | Vitest 3, Testing Library, Playwright 1.58 | |

캔버스/도형 라이브러리(Konva/Fabric/PIXI 등) **없음**. 빌더 캔버스는 외부 iframe (Edicus/RedEditor)에 위임.

## 3. 코드 규모

- 총 .ts/.tsx 라인: **12,001** (테스트 포함)
- 소스 파일: 84개 (README 기준), 실제 디렉터리에는 131개 파일 (.gitkeep, .DS_Store 포함)
- 디렉터리 구조:
  - `src/app/` — Next.js App Router (페이지 34개 ≈ admin 14 + mobile 3 + 일반 5 + dynamic 등)
  - `src/components/` — UI 21개 (huni-ui 8 + editor + product + order + admin + mobile + auth)
  - `src/hooks/` — `useAuth`, `useEdicus`, `useHuniEditor`, `useOrder` (4개)
  - `src/lib/edicus/` — Edicus SDK 통합 핵심 (`client.ts`, `server-api.ts`, `resource-api.ts`, `huni-editor-sdk.ts`, `custom-css.ts`, `mobile-config.ts`, `env.ts`)
  - `src/lib/red-editor/` — RedEditorSDK 분석/래퍼 (`wrapper.ts`, `red-editor-sdk.d.ts`, `analyzed/*.js`)
  - `src/types/` — `edicus.ts` (~350 LOC, SDK 타입 풀세트), `order.ts`
  - `src/app/api/edicus/` — 10개 라우트
  - `ref/RedEditorSDK.js` — 614KB 원본 SDK (분석 대상)
  - `docs/red-editor-sdk-analysis.md` — RedEditorSDK v6.6.48 리버스 엔지니어링 결과
  - `scripts/analyze-*.ts` — SDK 분석/추출 스크립트 13개

## 4. "에디쿠스" / "EDICUS" / "edicus" 참조

소스 전반에 `edicus`로 도배되어 있음:

- 패키지명: `edicus-man`
- 모든 API route 경로: `/api/edicus/auth`, `/api/edicus/projects`, `/api/edicus/orders`, `/api/edicus/products`, `/api/edicus/templates`, `/api/edicus/resource/...`, `/api/edicus/css` (`src/app/api/edicus/**`)
- 환경변수: `EDICUS_API_KEY`, `EDICUS_API_HOST`, `EDICUS_RESOURCE_HOST`, `NEXT_PUBLIC_EDICUS_PARTNER`, `NEXT_PUBLIC_EDICUS_BASE_URL` (`src/lib/edicus/env.ts`)
- 타입: `EdicusContext`, `EdicusProject`, `EdicusTemplate`, `EdicusProduct`, `EdicusCallbackData`, `EdicusApiResponse` (`src/types/edicus.ts`)
- 클래스: `EdicusClient` (`src/lib/edicus/client.ts:116`), `HuniEditorSDK`가 합성으로 사용
- 컴포넌트: `EdicusEditor` (`src/components/editor/EdicusEditor.tsx`)
- README에 "Edicus SDK 통합 (SPEC-REDSDK-001)" 명시

## 5. 빌더/에디터 아키텍처

이 앱은 **자체 캔버스 빌더를 구현하지 않는다**. 대신:

1. 외부 호스팅된 Edicus 편집기(iframe at `https://edicusbase.firebaseapp.com/ed#/editor_landing`)를 SDK로 로드
2. `EdicusClient` (`src/lib/edicus/client.ts`)가 `window.edicusSDK.init({base_url})`을 호출하여 iframe 생성, postMessage 통신
3. `useEdicus` / `useHuniEditor` 훅이 React 생명주기와 통합
4. `EdicusEditor` 컴포넌트가 토큰 발급 → `createProject` / `openProject` 호출
5. 편집 결과는 Edicus 서버 (`api-dot-edicusbase.appspot.com`)에 저장, `project_id`만 보관

핵심: **빌더 엔진은 외부(motion-one/edicusbase) 소유. 이 코드베이스는 통합 계층(integration layer) + 후니프린팅 도메인 셸(쇼핑/주문/관리)이다.**

## 6. 초기 판정 (verdict v0)

**`docs/edicus.man/`은 buysangsang.com이 사용하는 "엠샵 에디쿠스 (EDICUS) v1.2.4" WordPress 플러그인의 직접적인 재작성(rewrite)이 아니다. 동일한 외부 Edicus SDK(motion-one 운영)를 사용하는 후니프린팅 전용 Next.js 신규 프론트엔드/통합 셸이다.** 두 시스템 모두 "엠샵 에디쿠스 = Edicus SDK 클라이언트"이며, 같은 백엔드(`edicusbase.firebaseapp.com`)를 호출한다. 즉:

- WordPress 측 mshop-edicus 1.2.4 = PHP 기반 Edicus SDK 통합 (WooCommerce 옵션폼 + iframe 임베드)
- `docs/edicus.man/` = Next.js 15 + React 19 기반 Edicus SDK 통합 (전체 쇼핑/관리/주문 + iframe 임베드)

**핵심 가치는 "빌더 도메인 모델의 완전 재발명"이 아니라 "Edicus를 어떻게 통합/주문/관리하는가"의 검증된 패턴 — 후니프린팅 브랜드용 토큰·CSS·partner 코드(`hunip`)까지 박혀 있어 거의 그대로 흡수 가능**. 다만 가격 엔진(TM Extra Product Options + Tiered Pricing)과 옵션 폼 빌더는 **여기 존재하지 않으며**, 그 부분은 As-Is에서 별도로 재현해야 한다.

증거 강도: **강함**.
