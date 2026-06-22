# ADR-002: Edicus SDK 통합 전략

- 상태: **Accepted** (전제: 외부 Edicus SDK 의존 유지)
- 작성일: 2026-05-27
- 관련 ADR: ADR-001 (프론트엔드 옵션), ADR-003 (데이터 레이어)

---

## 1. Context

`docs/edicus.man/` 흡수 분석에서 **외부 Edicus 백엔드(`api-dot-edicusbase.appspot.com`)와 SDK iframe(`edicusbase.firebaseapp.com`)에 디자인 에디터를 위임하는 모델을 유지**하기로 결정됨 (참조: `edicus-analysis/05_verdict-and-recommendations.md`). 자체 캔버스 엔진 재구현은 범위 외.

도메인 분석 결과 SDK는 17가지 편집 모드(create_project, open_project, edit_template, design/recycle/reform/fit/preview/tnview/gallery/lite 등)를 노출하며, 단일 `EdicusCommonUrlParams`(약 40+ 필드)가 모든 모드의 URL/iframe 파라미터 계약을 표현한다 (참조: `02_domain-model.md` A.5/A.6). Project 상태머신은 `editing → ordering → ordered`(FROZEN, A.4), Order 상태머신은 `tentative → definitive → cancelled / processing / completed`(B.1)로 분리되어 공존한다.

본 ADR은 To-Be 빌더에서 Edicus를 **어떻게 배치하고, 자격증명을 어떻게 보호하고, 우리 도메인 상태와 어떻게 이중장부 없이 동기화할지**를 정의한다. 본 ADR은 ADR-001의 옵션 A/B/C 모두에 적용된다 (옵션과 무관한 통합 계약).

---

## 2. Decision

### D1. 코드 자산 이식: edicus.man S1 스택을 그대로 ingest

다음 경로를 To-Be 빌더(`/Users/innojini/Dev/HuniWeb` 신규 앱)로 1:1 이식한다 (디렉토리명 유지 권장):

| 분류 | 경로 | 처리 |
|---|---|---|
| 타입 | `src/types/edicus.ts`, `src/types/order.ts` | as-is 이식 |
| SDK 클라이언트 | `src/lib/edicus/{client,server-api,resource-api,huni-editor-sdk,custom-css,env,mobile-config}.ts` | as-is 이식 |
| React 훅 | `src/hooks/{useEdicus,useHuniEditor,useOrder}.ts` | as-is 이식 |
| 에디터 컴포넌트 | `src/components/editor/{EdicusEditor,VdpEditor,PCPassiveEditor,PCPassiveToolbar}.tsx` | as-is 이식 |
| BFF 라우트 | `src/app/api/edicus/**` (10개 route) | as-is 이식 후 인증 미들웨어 보강 (D3) |
| 디자인 시스템 | `src/components/ui/` 8 컴포넌트 + 테스트 161개 | as-is 이식 |

근거: `05_verdict-and-recommendations.md` S1/S2/S3, 85% 테스트 커버리지, partner=`hunip` 하드코딩이 후니 전용.

### D2. BFF 프록시 레이어 — 자격증명 노출 방지

브라우저는 Edicus 외부 API(`EDICUS_API_HOST`, `EDICUS_RESOURCE_HOST`)를 **직접 호출하지 않는다**. 모든 호출은 자체 Next.js Route Handler(`src/app/api/edicus/**`)를 경유한다.

- 환경변수 분리:
  - **서버 전용** (브라우저 노출 금지): `EDICUS_API_KEY`, `EDICUS_API_HOST`, `EDICUS_RESOURCE_HOST`
  - **공개 가능**: `NEXT_PUBLIC_EDICUS_PARTNER`(=`hunip`), `NEXT_PUBLIC_EDICUS_BASE_URL`
- BFF는 요청에 `edicus-api-key`, `edicus-uid` 헤더를 부여하여 `ServerApiClient`/`ResourceApiClient` 호출 (참조: `02_domain-model.md` E.3 `server-api.ts:42-48`)
- Zod 검증을 모든 입력단에 유지 (이미 적용됨)

### D3. 인증/세션 정책

- BFF Route Handler는 자체 세션(쿠키 기반)에서 `uid`를 추출하여 Edicus 호출의 `edicus-uid` 헤더로 사용한다.
- 게스트 모드(비로그인) 견적 진행이 필요할 경우, 임시 `uid`(예: `guest_<UUID>`)를 발급하고 24시간 TTL의 게스트 세션을 유지한다. 잠정주문 이전에 회원 전환 필수.
- ADR-003에서 회원 마스터(Shopby vs Neon) 결정 후 `uid` 발급 주체 확정.

### D4. 에디터 실행 모드 결정 매트릭스

SDK는 본질적으로 **iframe 임베드(`edicusbase.firebaseapp.com` origin)** 방식이며 (참조: `02_domain-model.md` E.2 `TRUSTED_ORIGIN`, postMessage origin 검증), 자체 호스팅/inline 옵션은 현 SDK 계약상 없음. SSO는 `token` 파라미터로 처리.

| 모드 | 사용 시나리오 | 진입 컴포넌트 | 비고 |
|---|---|---|---|
| iframe + token (SSO) | 일반 (PC/모바일 공통) | `EdicusEditor` | 표준. SSO 토큰은 BFF에서 `getToken(uid)`로 발급 |
| passive (운영자 사전 디자인) | 가변데이터(VDP) 입력만 허용 | `VdpEditor` / `PCPassiveEditor` | `run_mode=passive`, `edit_lock=edit-group` 등 |
| lite | 명함/스티커 등 단순상품 빠른 진입 | `LiteProjectParams` 변형 | 모바일 우선 |
| inline DOM | 미지원 | — | 현 SDK 계약 외. 향후 RedEditorSDK 자체 호스팅(`docs/red-editor-sdk-analysis.md`) 협의 시 재평가 |
| 풀스크린 SSO 리다이렉트 | 미지원/비권장 | — | 우리 헤더/푸터를 잃음 |

기본 채택: **iframe + token**. passive와 lite는 상품 카탈로그의 product type에 따라 라우팅(상품 메타에 `editor_mode` 필드 추가, ADR-003).

### D5. 상태 머신 채택: 이중 상태 (Project / Order)

edicus.man의 두 상태머신을 **그대로 채택**하고, 자체 Neon PG의 `orders` 테이블(베이스라인 17-state)과 매핑한다.

- `ProjectStatus`(SDK 소유): `editing` → `ordering` → `ordered`
- `OrderStatus`(우리 소유): `tentative` → `definitive` → `cancelled` / `processing` → `completed`
- 매핑 규칙:
  - `tentativeOrder()` 호출 성공 → `ProjectStatus=ordering` AND Neon `orders.status='tentative'`
  - `definitiveOrder()` 호출 성공 → `ProjectStatus=ordered` AND Neon `orders.status='definitive'`
  - `cancelOrder()` 호출 성공 → Neon `orders.status='cancelled'` (Edicus Project 상태는 SDK 정책상 되돌릴 수 없음 — orphan project로 잔존)
- 후속 단계(`processing`, `completed`)는 자체 생산 워크플로(`production_jobs`, `job_stage_status`)가 소유. Edicus는 모름.

근거: `02_domain-model.md` A.4, B.1. 베이스라인 ERD의 `orders` (17-state) + `order_status_history`.

### D6. 데이터 영속 분산 인정

- **Edicus 외부 백엔드 소유**: 캔버스 본문(`template_uri`, `content_uri`), 프로젝트 메타, 미리보기 URL, 인쇄파일 렌더링
- **Neon PG 소유**: 견적, 주문, 작업파일 검수 상태, 생산 워크플로, 회원, 가격표, 옵션
- **양쪽 모두 보관 (중복)**: `project_id`(Edicus 발급, 우리는 `orders` 또는 별도 `edicus_projects` 테이블에 FK처럼 보관), `order_id`(Edicus 발급 vs 우리 발급 — D7 참조)

### D7. order_id 발급 주체

Edicus `ServerApiClient.tentativeOrder()`가 `OrderResponse { order_id, project_id, status }`를 반환 (참조: `02_domain-model.md` B.3, E.3). 본 ADR은 **Edicus order_id를 외부 ID로 보관**하고, 우리 Neon `orders.id`(BIGSERIAL)를 1차키로 사용. 매핑 테이블 `edicus_order_mapping(internal_order_id, edicus_order_id, edicus_project_id)`를 추가한다.

### D8. 동기화 전략

- **Write-through**: 사용자 액션(잠정/확정/취소)은 BFF가 (1) Edicus 호출 → (2) 성공 시 Neon update 순서로 처리. 1번 실패 시 Neon 변경 없음. 2번 실패 시 Edicus 상태와 Neon 상태 불일치 → 보정 잡(D9).
- **Polling 보정 잡**: 매 N분 주기로 `ProjectStatus`/Edicus `Order.status`를 Neon 상태와 대조. 불일치 발견 시 Edicus 측을 진실로 간주(SDK가 인쇄 파일 렌더링까지 진행할 권한 보유). 운영 알림 발송.
- **Webhook**: Edicus가 webhook을 제공하면 polling 대체. 현 SDK 문서/코드에는 webhook 흔적 없음 — 검증 필요 (Open Question Q3).

### D9. 장애 대응 / Fallback

Edicus 외부 SDK는 단일 외부 의존이며 가용성 SLA가 자체 통제 밖. Fallback 정책:

| 장애 유형 | 대응 |
|---|---|
| Edicus API 응답 실패 (5xx, timeout) | BFF는 최대 3회 지수 backoff 재시도. 실패 시 사용자에게 "에디터 일시 점검" 안내 페이지. 이미 잠정주문 상태인 경우 결제는 진행 가능 |
| iframe 로딩 실패 | `HuniEditorSDK`의 `onError` 콜백으로 감지. 사용자에게 "디자인 파일 직접 업로드" 대체 흐름 제시 (`artwork_files` 직업로드 경로 — 베이스라인 Order 도메인) |
| postMessage origin 위반 | 무시 + 로깅 (이미 `huni-editor-sdk.ts:278`에서 검증) |
| Edicus 백엔드 장기 중단 (계약/요금 변동) | 비상 계획: RedEditorSDK 자체 호스팅 협의(`docs/red-editor-sdk-analysis.md`). 본 ADR 범위 외, R5 리스크로 등록 |

---

## 3. Consequences

### 긍정
- edicus.man의 S1 스택(약 4K LOC 추정) 즉시 활용으로 디자인 에디터 통합 슬라이스 50%+ 완성
- 자격증명이 BFF에 집중되어 보안 경계 명확
- 상태머신 이중성을 인정함으로써 "외부 SDK 진실" vs "자체 비즈니스 진실"이 충돌 없이 공존
- 옵션 A/B/C 모두에 무수정 적용

### 부정
- 데이터가 Edicus(에디터 산출물 메타) + Neon(인쇄 비즈니스) + Firebase(에디터 자산 스토리지, Edicus가 보유)로 3분산. 어떤 영역도 단독으로 전체 진실을 가지지 않음
- 외부 SDK 가용성에 사용자 핵심 흐름이 묶임 (R5)
- order_id 매핑 오버헤드, 보정 잡 운영 부담
- iframe origin 정책 변경 시(예: Edicus가 도메인 마이그레이션) `TRUSTED_ORIGIN` 상수 변경 필요

### 영향받는 ADR
- ADR-003: 데이터 레이어 — `edicus_projects`, `edicus_order_mapping` 테이블 추가 필요
- ADR-001: 옵션 무관

---

## 4. Open Questions

1. **Q1**: Edicus가 webhook을 제공하는가? 없다면 polling 보정 잡의 주기·비용은?
2. **Q2**: `partner=hunip` 코드의 유효 기간/계약 조건은? motion-one과 라이선스 재확인 필요 (R5)
3. **Q3**: passive/lite 모드의 상품 카탈로그 라우팅 키(`editor_mode`)는 Neon `products` 테이블의 추가 컬럼인가, `widget_configs`의 일부인가?
4. **Q4**: 게스트 잠정주문 후 회원 전환 시 `uid` 마이그레이션 정책 (Edicus 측 프로젝트 소유자 변경 API 존재 여부)
5. **Q5**: Edicus 외부 장애 시 결제·생산 워크플로는 계속 진행되어야 하는가, 중단되어야 하는가? (운영 정책)
6. **Q6**: RedEditorSDK v6.6.48 자체 호스팅 옵션의 라이선스/기술 조건 — 별도 ADR 후보

---

REQ coverage: REQ-EDICUS-001 ~ REQ-EDICUS-006
References: edicus-analysis/02_domain-model.md (A.4 ProjectStatus, A.5 EdicusCommonUrlParams, B.1 OrderStatus, E.2 HuniEditorSDK, E.3 ServerApiClient), edicus-analysis/05_verdict-and-recommendations.md (S1, R5), docs/edicus.man/src/**
