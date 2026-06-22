# 변경 로그

[Keep a Changelog](https://keepachangelog.com/ko/1.0.0/) 형식을 따릅니다.

## [0.1.0] - 2026-03-17

### 추가 (Added)

#### Phase A: RedEditorSDK 분석 및 문서화
- RedEditorSDK.js (615KB) 난독화 해제 및 분석
- Prettier 포매팅으로 가독성 개선
- lebab를 통한 ES5→ES6+ 역변환
- Babel 런타임 헬퍼 분리 (`babel-helpers.js`)
  - `_slicedToArray`, `_extends`, `_createClass`, `_typeof`, `_toConsumableArray`, `_defineProperty`, `_classCallCheck`
- 모듈 경계 식별 및 분리
  - Sentry 스타일 에러 리포팅 (`error-reporting.js`)
  - 핵심 유틸리티 함수 (`core-utils.js`)
  - RedEditorSDK 메인 클래스 (`red-editor-class.js`)
- 모든 모듈에 상세한 한글 JSDoc 주석 추가
- TypeScript 타입 선언 파일 작성 (`red-editor-sdk.d.ts`)
  - 공개 API 전체 타입 정의
  - 메서드 시그니처 및 콜백 타입 명시
- TypeScript 래퍼 작성 (`wrapper.ts`)
  - Next.js 환경에서 안전한 SDK 사용
  - 타입 안전성 강화
- SDK 분석 문서 작성 (`docs/red-editor-sdk-analysis.md`)
  - 모듈 구조도
  - 공개 API 목록
  - VDP(Variable Data Printing) 기능 설명

#### Phase B: 후니프린팅 테스트 사이트 구현
- Next.js 15 App Router 기반 프로젝트 초기화
- TypeScript 5.x 및 Tailwind CSS v4 설정
- ESLint 9 및 Prettier 린팅/포매팅 설정
- React 19 및 Vitest 테스트 환경 구성

##### API 프록시 구현
- `/api/edicus/auth` - 토큰 발급 엔드포인트
- `/api/edicus/projects` - 프로젝트 CRUD 프록시
- `/api/edicus/orders` - 주문 처리 프록시
- `/api/edicus/templates` - 템플릿 조회 프록시
- `/api/edicus/products` - 상품 조회 프록시
- Server-side에서만 API 키 사용 (클라이언트 번들 제외)

##### Edicus SDK 통합
- Edicus JavaScript SDK v2 초기화 (`lib/edicus/client.ts`)
- Server API 클라이언트 구현 (`lib/edicus/server-api.ts`)
- Resource API 클라이언트 구현 (`lib/edicus/resource-api.ts`)

##### 페이지 구현
- 메인 페이지 (`app/page.tsx`)
  - Resource API에서 후니프린팅 상품 및 템플릿 목록 조회
  - 카드 형태로 템플릿 표시
- 편집기 페이지 (`app/editor/[templateId]/page.tsx`)
  - Edicus SDK를 통해 편집기 iframe 로드
  - 새 프로젝트 생성
- VDP 편집기 페이지 (`app/vdp/[templateId]/page.tsx`)
  - 가변 데이터 인쇄(Variable Data Printing) 편집 인터페이스
- 프로젝트 관리 페이지 (`app/projects/page.tsx`)
  - 사용자의 모든 프로젝트 조회
  - 프로젝트별 상태(editing, ordering, ordered) 표시
- 주문 이력 페이지 (`app/orders/page.tsx`)
  - 완료된 주문 목록 표시

##### 컴포넌트 구현
- Edicus 편집기 래퍼 (`components/editor/EdicusEditor.tsx`)
  - iframe 기반 편집기 로드
  - `request-user-token` 이벤트 처리
  - `send-user-token` 액션 구현
- VDP 편집기 래퍼 (`components/editor/VdpEditor.tsx`)
  - 가변 데이터 입력 인터페이스
- 상품 그리드 (`components/products/ProductGrid.tsx`)
  - 반응형 그리드 레이아웃
- 템플릿 카드 (`components/products/TemplateCard.tsx`)
  - 템플릿 미리보기 및 선택
- 주문 패널 (`components/orders/OrderPanel.tsx`)
  - 주문 정보 표시 및 확인
- 주문 상태 배지 (`components/orders/OrderStatusBadge.tsx`)
  - 상태에 따른 색상 구분

##### 훅 구현
- `useEdicus()` - Edicus SDK 초기화 및 토큰 관리
- `useOrder()` - 주문 프로세스 (잠정주문 → 확정주문)

##### 타입 정의
- Edicus 관련 타입 (`types/edicus.ts`)
  - 템플릿, 프로젝트, 사용자 토큰 타입
- 주문 관련 타입 (`types/order.ts`)
  - 주문 상태, 주문 항목 타입

##### 상태 관리 및 데이터 페칭
- Zustand로 전역 상태 관리
- TanStack React Query v5로 서버 데이터 동기화
- Zod로 API 응답 유효성 검증

##### UI/UX
- Tailwind CSS v4로 반응형 디자인 구현
- 모바일/데스크톱 완벽 지원
- Lucide React 아이콘 통합
- 접근성 고려한 컴포넌트 설계

#### Phase C: Vercel 배포
- `next.config.ts` 작성 및 Vercel 배포 설정
- 환경 변수 관리 설정
  - `NEXT_PUBLIC_EDICUS_PARTNER`
  - `NEXT_PUBLIC_EDICUS_BASE_URL`
  - `EDICUS_API_HOST`
  - `EDICUS_RESOURCE_HOST`
  - `EDICUS_API_KEY` (Server-side only)
- `.env.example` 작성으로 개발 환경 가이드 제공
- 배포 후 메인 페이지, 편집기, 주문 프로세스 검증

### 기술 스택
- **런타임**: Node.js, Next.js 15.3.1
- **프레임워크**: React 19, TypeScript 5.x
- **스타일링**: Tailwind CSS v4
- **상태 관리**: Zustand v5
- **데이터 페칭**: TanStack React Query v5
- **유효성 검증**: Zod v3
- **테스팅**: Vitest v3, React Testing Library v16
- **린팅/포매팅**: ESLint 9, Prettier v3
- **빌드**: Turbopack 지원

### 수용 기준 (Acceptance Criteria)
- [x] AC-1: RedEditorSDK.js 주요 모듈(3개 이상) 분리 및 한글 주석 추가
- [x] AC-2: TypeScript 타입 선언 파일이 RedEditorSDK 공개 API 커버
- [x] AC-3: TypeScript 래퍼가 핵심 메서드 타입 안전하게 래핑
- [x] AC-4: 후니프린팅 상품/템플릿 목록이 웹 UI에서 카드 형태로 표시
- [x] AC-5: 템플릿 선택 → 편집기 열기 → 저장 프로세스 정상 동작
- [x] AC-6: 잠정주문 → 확정주문 프로세스 정상 동작
- [x] AC-7: API 키가 클라이언트 번들에 포함되지 않음
- [x] AC-8: Vercel 배포 URL에서 메인 페이지 정상 로드
- [x] AC-9: SDK 분석 문서(docs/red-editor-sdk-analysis.md) 생성

---

## 향후 계획

### v0.2.0 (예정)
- E2E 테스트 추가 (Cypress/Playwright)
- 사용자 인증 시스템 통합
- 주문 히스토리 상세 페이지
- 고급 필터링 및 검색 기능
- 다국어 지원 (i18n)

### v0.3.0 (예정)
- 대량 주문 기능
- 템플릿 커스터마이징 저장
- 협업 편집 기능
- 모바일 네이티브 앱

---

## 기여자

- 지니 (@skeeper75) - 프로젝트 주도 및 구현

## 라이선스

MIT

---

**마지막 업데이트**: 2026-03-17
