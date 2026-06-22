# 01. Aurora React Skin — Overview

생성일: 2026-05-27
조사자: pq-researcher (Aurora 적합성 분석 트랙)
입력 자료: `docs/shopby/aurora-react-skin-guide/오로라_리액트_스킨개발가이드/**` (공식 가이드, 한국어 mdx)

---

## 1. Aurora React Skin이란 무엇인가?

### 정체 (Identity)

- **공식 명칭**: Aurora React (오로라 리액트)
- **제공 주체**: NHN커머스 (Shopby 본사 직접 제작·관리)
- **포지셔닝**: Shopby 신규 쇼핑몰 생성 시 자동으로 세팅되는 **샘플 스킨(sample skin)**. shop by basic / pro / premium 전 라인업에 적용 가능. premium의 경우 생성 시 디폴트로 "스킨" 운영방식이 적용되며, 별도로 "헤드리스(headless)"로 전환할 수 있음(전환 시 가이드 무효, REST API 직접 호출 필요).
- **소스 공개**: 누구나 참고·포크 가능. 저장소: `https://skins.shopby.co.kr/shopby/aurora-skin` (GitLab).
- **PC/모바일 형태**: 통합형(integrated) = 반응형 단일 코드베이스. 모바일 퍼스트(mobile-first). 별도 개별형(separate PC/Mobile) 브랜치(`feat/pc-main`)도 존재.

### 기술 스택 (확인된 사실 + 추정)

| 항목 | 값 | 근거 |
|------|-----|------|
| 언어 | TypeScript | `@shopby/shared`가 "타입스크립트 기반 패키지"로 명시 |
| UI 프레임워크 | React (정확한 버전 미명시) | "react 기반" 언급 |
| 빌드 체계 | **CRA/Vite 등 명시 없음 (추정 필요)** | 문서에는 빌드 도구가 노출되지 않음. 공식 저장소 접근 시 `package.json` 확인 필요 |
| 렌더링 | **CSR 추정** (SSR/SSG 언급 0건) | "javascript와 react만 안다면 쉽게 화면 커스텀 가능"이라는 표현 + 클라이언트에서 직접 API 호출하는 예제 코드 |
| 상태 관리 | 자체 `ShopbyQuery` (React Query 유사) + Context API (`useStateContext`/`useActionContext`) | `@shopby/shared` 문서 |
| 데이터 페치 | `fetch` API 래퍼(`ShopbyQuery.executeQuery/executeMutation`) | `@shopby/shared` 문서 |
| HTTP 인증 | OAuth 2.0 (accessToken + refreshToken) | 기본 샵바이 API 가이드 |
| 라우팅 | **명시 없음 (React Router 추정)** | 가이드에 URL 라우트 매핑은 없고 화면 단위로만 설명 |
| 의존성 패키지 | `@shopby/shared`, `@shopby/react-components` (private npm registry, `.npmrc` 토큰 필요) | 공식 문서 |
| **추정 근거 불충분 항목** | Next.js 여부, SSR/SSG, Vite/CRA/Webpack, React 버전, i18n 라이브러리, CSS 시스템(CSS-in-JS? Tailwind? SCSS?) | 가이드 mdx만으로는 확인 불가. GitLab 저장소 직접 클론 후 `package.json` 정독 필요 |

→ **첫 번째 검증 필수 항목**: `https://skins.shopby.co.kr/shopby/aurora-skin`에 접근하여 `package.json` / `vite.config.*` / `next.config.*` 확인.

### 코드 크기

- **추정 불가 (직접 확인 필요)**. 가이드 문서는 22개 mdx 파일(주로 API 활용 안내)이며 코드 베이스 LOC는 노출되지 않음.
- 화면 수 기준 간접 추정: 메인/로그인/회원가입/간편로그인/휴대폰인증/상품리스트/상품상세/장바구니/주문서/마이페이지(회원정보/혜택/주문/게시글/배송지) 약 **15개 주요 화면** × 통합형 단일 코드. 각 화면 평균 500~800 LOC로 추정하면 **8K~12K LOC** 수준의 중규모 React 앱으로 보임. **근거 불충분, 검증 필요**.

### 의존성 트리 (확인된 항목)

가이드에서 명시된 자체 패키지 2종 외, 외부 의존성은 명시되지 않음:

1. `@shopby/shared` — 서버 상태/비즈니스 로직 (TypeScript)
2. `@shopby/react-components` — UI 컴포넌트 + Provider (React)

→ **두 패키지 모두 Shopby 사내 private npm registry**에서 배포. `.npmrc`에 토큰 삽입 필요. **외부 개발자가 자체 빌드 환경에서 토큰 발급 받지 못하면 빌드 자체가 실패**할 가능성 있음. 이는 채택 시 운영 리스크의 핵심.

가장 큰 외부 dep 10개: **확인 불가** (저장소 클론 + `package.json` 정독 필요).

### 라이선스·소유권

- **명시적 라이선스 표기 없음** (가이드 문서 어디에도 MIT/Apache/GPL 등의 단어 등장 0회).
- "누구나 참고할 수 있도록 공개"라는 표현은 있지만 라이선스 ≠ 공개. **수정·재배포·상업적 이용 가능 여부는 별도 약관(NHN커머스 솔루션 약관) 확인 필요**.
- 셀러어드민에서 "단순복사" 또는 "단순복사+디자인 수정" 옵션으로 본인의 쇼핑몰에 설치하는 흐름이 강제됨 → **NHN커머스의 셀러 어드민을 거치지 않은 외부 배포는 사실상 불가**한 구조.

### 제공 형태 + 업데이트 흐름

- **형태**: GitLab 저장소 형태(`skins.shopby.co.kr`).
- **설치 흐름**: 워크스페이스 → 셀러어드민 → 주문/디자인에 "스킨 등록 주문" → 쇼핑몰번호·기본도메인 입력 → "단순복사" 또는 "단순복사+디자인 수정" 선택 → 자동/수동 설치 → 쇼핑몰 어드민 [디자인 > 디자인 관리 > 디자인 스킨 리스트 > 보유 스킨]에서 확인 → "사용 스킨"으로 직접 변경.
- **업스트림 업데이트 흐름**: `git remote add upstream https://skins.shopby.co.kr/shopby/aurora-skin.git` 한 뒤 일반 git 패치 워크플로(`fetch`/`merge`)로 변경분을 흡수. 단, 사용자가 커스텀한 부분과 충돌 시 수동 머지가 필요하다는 점 명시(PC 버전 가이드에서 패치 절차 안내).
- **푸시 권한**: 본 저장소(`aurora-skin`)에 직접 push 불가(권한 오류). 포크 또는 사용자 자체 저장소로 분기 필요.

→ **두 번째 운영 리스크**: 업스트림이 NHN커머스 권한 안에 있고, 변경분을 사용자가 수동 머지로 따라가야 함. 인쇄 견적 사이트의 옵션 폼 같은 큰 영역을 갈아끼웠다면 머지 충돌 비용이 누적적으로 발생.

---

## 2. 핵심 화면 인벤토리

가이드가 명시적으로 다루는 화면 목록 (스킨 개발 API 활용 가이드 목차 기준):

| # | 영역 | 화면 | 주요 호출 API | 비고 |
|---|------|------|--------------|------|
| 1 | 공통 | 메인화면 레이아웃 / 공통영역 / 배너영역 / 상품진열영역 | `GET /malls`, `GET /skin-banners`, 상품진열 API | 어드민에서 설정한 진열/배너를 그대로 표출 |
| 2 | 회원 | 회원가입 | (별도 API) | 한국형 약관 동의 흐름 포함 |
| 3 | 회원 | 로그인 | OAuth 2.0 accessToken/refreshToken | localStorage 토큰 캐시 |
| 4 | 회원 | 간편로그인 | 소셜 계정 연동 | 회원명/휴대폰/이메일이 없을 수 있음 |
| 5 | 회원 | 휴대폰 본인인증 | KCP 본인인증 모듈 (iOS/AOS도 별도 가이드) | |
| 6 | 상품 | 상품 리스트 | 상품 진열/검색 API | |
| 7 | 상품 | 상품 상세 (기본정보/옵션/쿠폰/좋아요/장바구니/바로구매) | `GET /products/{productNo}`, `GET /products/{productNo}/options`, `GET /coupons/products/issuable/coupons`, `POST /profile/like-products`, `POST /cart`, `POST /order-sheets` | **인쇄 견적과 직접 충돌하는 영역. §03에서 상세 평가** |
| 8 | 상품 | 추가상품 (Extra Products) | `GET /products/{productNo}/extra-products` | 본상품과 함께만 결제 가능 (단독 결제 불가) |
| 9 | 주문 | 장바구니 | `GET /cart`, `POST /guest/cart`(비회원), `PUT /cart`, `DELETE /cart`, `GET /cart/calculate` | 회원은 서버, **비회원은 localStorage** 자체 관리 |
| 10 | 주문 | 주문서 (주문자/배송지/상품/혜택/사은품/결제정보/결제수단/약관/결제버튼) | `POST /order-sheets`, `GET /order-sheets/{no}`, `POST /order-sheets/{no}/calculate`, `POST /payments/reserve` | 한국형 약관·해외배송·통관·주류·NCPPay 모듈 통합 |
| 11 | 마이페이지 | 회원정보 | profile API | |
| 12 | 마이페이지 | 혜택관리 (쿠폰·적립금) | | |
| 13 | 마이페이지 | 주문정보 / 주문배송 상세 | | |
| 14 | 마이페이지 | 나의 게시글 | 게시판 API | |
| 15 | 마이페이지 | 배송지 관리 | `GET /profile/shipping-addresses` | |

→ **인벤토리는 전형적인 일반 B2C 쇼핑몰 구조**. 인쇄 견적 사이트가 필요로 하는 (1) 디자인 에디터, (2) 견적 마법사, (3) 파일 업로드 + 검수, (4) 사양별 공정 분기 라우트는 **0건**.

### 어드민 의존도 — 자유도 제약의 핵심

가이드 전체에 걸쳐 반복되는 패턴은 "어드민에서 X 설정 → 스킨이 응답 값을 받아 렌더링". 예를 들어:
- 상품 옵션의 노출 방식(분리형/일체형, 텍스트 옵션 유무, 매칭 타입)이 **어드민 설정으로 결정** → 스킨은 응답 enum(`TYPE`, `flatOptions`, `multiLevelOptions`, `input`)을 분기.
- 약관 종류(개인정보/판매자제공/국외이전/통관/주류)가 어드민에서 노출 토글되고, 스킨은 그 enum(`PI_COLLECTION_AND_USE_REQUIRED`, `CLEARANCE_INFO_COLLECTION_AND_USE`, ...)을 매핑.
- 사은품 지급 옵션(`ALL` vs `SELECT`)도 백엔드 enum.

→ **함의**: Aurora는 "Shopby 백엔드의 화면 표현"에 가깝다. 백엔드가 모르는 도메인 객체(가령 "후가공 옵션 그룹", "용지 사양", "구간별 단가 룰")는 스킨만 갈아끼워서는 표현할 수 없고 **어드민·API 자체를 확장하거나 별도 백엔드를 옆에 두는 방식**이 필요하다. (이 결론은 §03에서 점수화)

---

## 3. 핵심 발견 5가지

1. **Aurora는 Shopby 운영방식이 "스킨"인 몰을 위한 React 템플릿이다.** "헤드리스(headless)"로 전환하면 본 가이드가 무효가 되고 별도 REST API 직접 호출 방식이 됨. 즉 Aurora는 헤드리스가 아니라 "스킨 모드 + React 화면"의 조합.
2. **빌드 환경에서 `.npmrc` 토큰을 요구하는 사내 private npm registry 의존**. 외부 개발자/CI 가 토큰 발급을 받지 못하면 빌드 불가 → 운영 리스크.
3. **렌더링 방식은 CSR로 강하게 추정**. SSR/SSG/Next.js 언급이 0회. 인쇄 견적 사이트가 SEO·OG 메타·딥링크가 중요하다면(buysangsang의 `/shop/{id}/{name}/` URL이 활성) 추가 부담.
4. **장바구니의 비회원 처리는 localStorage 자체 관리** (회원만 서버 cart). 견적의 "임시저장" 같은 비로그인 워크플로는 자체 구현 필요.
5. **업스트림 패치 흐름이 git remote 머지 방식**. 사용자가 옵션 폼 같은 큰 영역을 갈아끼웠다면, NHN커머스가 옵션 가이드를 변경할 때마다 머지 충돌이 누적된다.

---

Version: 1.0.0
Status: 1차 분석 완료. 코드베이스 직접 확인은 별도 단계.
Next: `02_extensibility-points.md` — 확장 가능 영역 vs 고정 영역
