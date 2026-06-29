---
name: huni-shopby-orchestrator
description: >-
  후니프린팅 Shopby 커머스 통합 하네스 오케스트레이터. 라이브 Railway DB 상품/가격(t_prd_*·t_prc_*·
  evaluate_price 계산가·CPQ)을 Shopby(NHN Commerce) 장바구니→주문으로 보내고, 추후 위젯이 고객의 구성요소
  선택을 카트를 통해 주문 완료까지 잇도록, ★선행 토대(webadmin 상품+구성요소 선택→가격계산 흐름·라이브 DB
  적재 현황) + Shopby 전수 리서치 + 라이브DB→카트→주문 종단 통합 설계서·아키텍처·API 계약·시퀀스를 산출한다.
  흐름: 선행 토대 큐레이션(hsb-foundation-curator) ∥ 커머스 흐름 리서치(hsb-commerce-researcher) → 상품·가격
  브리지(hsb-product-bridge-analyst) → 종단 통합 설계(hsb-integration-architect) → codex 독립 2차
  (hsb-codex-verifier) → 독립 게이트(hsb-integration-gate·SB1~SB7·스펙 필드 재대조·종단 라운드트립). 토대=기존
  가격/정합/dbmap 하네스 산출 재사용·문서 권위(OpenAPI 24종+enterprise)+라이브 갭필·브리지 전략은 하네스가
  리서치 후 권고·생성≠검증·codex 주장=가설·라이브 읽기전용(주문/결제 submit 금지)·DB 미적재(실 구현은 §6
  huni-widget 위임·인간 승인). 트리거: Shopby 통합, Shopby 장바구니 연동, 라이브DB 카트 전달, 카트 주문 흐름,
  위젯 주문 연동, 상품 가격 카트 브리지, webadmin 가격계산 흐름, 라이브 적재 현황, Shopby 커머스 설계, 주문
  완료 흐름, NHN Commerce 연동, 커머스 통합 하네스 실행/재실행/업데이트/보완, 특정 흐름만 설계. 위젯 UI 구현은
  §6 huni-widget, 가격공식 설계는 §18, 사이트 설계 문서는 §5 print-quote가 담당. 단순 질문은 직접 응답.
---

# huni-shopby-orchestrator — Shopby 커머스 통합 하네스

라이브 DB 상품/가격을 **Shopby 장바구니→주문**으로 보내고, 위젯의 고객 구성요소 선택을 카트를 통해 주문
완료까지 잇는 **종단 통합 설계**를 산출한다. ★선행 토대(후니 측 가격계산 흐름·라이브 적재 현황)를 먼저 못박고
Shopby 측 리서치와 종합한다. 권위=Shopby OpenAPI 스펙+enterprise 문서(+라이브 갭필)·후니 가격 권위=
evaluate_price·상품 권위=상품마스터/가격표. 리서치+설계 전용(실 구현은 §6 위임).

## 정체성 (기존 하네스와 경계)

| 하네스 | 무엇 | 본 하네스와 차이 |
|--------|------|-----------------|
| §6 huni-widget | 위젯 **구현**(정규화 계약·백엔드 미정) | 본 하네스가 **백엔드=Shopby**로 확정·카트/주문 계약을 설계→위젯이 입력으로 소비 |
| §5 print-quote | 신규 사이트 **설계 문서**(IA/DB/API) | 본 하네스는 그 흐름을 **실제 Shopby API 계약**에 그라운딩 |
| §13/§14 가격 | evaluate_price 계약·5장치 **이해** | 본 하네스가 **선행 토대로 재사용**해 카트 가격 원천 확정 |
| §21 catalog-conformance | 전 상품×축 **적재 정합** | 본 하네스가 **토대(적재 현황)로 재사용**해 "카트 전달 가능 상태" 분류 |
| §18 price-engine-design | 가격공식 **설계** | 본 하네스는 그 **계산가를 카트로 주입**하는 경로 설계 |

→ 본 하네스 = 선행 토대(후니) + Shopby 리서치 + 라이브DB↔Shopby 브리지 + 위젯→카트→주문 종단 설계. ★조사 반복 금지(기존 가격/위젯/dbmap/정합 산출물 재사용).

## 통합 모델 (확정 directive)

- **Shopby = 커머스 백엔드.** admin-analysis 방향: 주문/회원/정산/배송=Shopby 네이티브, 상품등록·인쇄옵션·생산워크플로우·파일업로드=커스텀. 메모리 `shopby-excluded-from-scope`는 백엔드=Shopby로 갱신됨.
- **★선행 토대 [HARD].** Shopby 연동 설계 전, 후니 측 ① webadmin 상품+구성요소 선택→`evaluate_price`→final_price 가격계산 흐름 ② 라이브 DB 실제 적재 현황(결함/갭)을 기존 하네스 산출 재사용으로 못박는다. 토대 없이는 "무엇을·어떤 가격으로 카트에 보낼지"가 공중에 뜬다.
- **흐름.** 위젯 구성 → evaluate_price 계산가 → 브리지 → `post-cart`(`/cart`·`/guest/cart`) → `cart/validate`·`cart/calculate` → `post-order-sheet` → `payments/reserve` → 주문 완료. (Shop API=`shop-api.e-ncp.com`.)
- **브리지 전략 = 하네스가 리서치 후 권고**(A 동기화·B 컨테이너·C 커스텀가·D 혼합). 핵심 난제=동적 계산가 무손실 주입.
- **라이브 접근 = 문서 권위 + 라이브 갭필.** 게이트는 스펙 기반 라운드트립 추적(실호출은 라이브 자격증명 보유 시에만 읽기/검증).

## 실행 모드: 하이브리드 (선행 토대 ∥ 커머스 리서치 → 브리지 → 설계 → codex 독립 → 게이트)

- Phase 1 기준점 팬아웃(병렬·서브): `hsb-foundation-curator`(후니 측 선행 토대) ∥ `hsb-commerce-researcher`(Shopby 측 커머스 흐름).
- Phase 2 브리지(서브): `hsb-product-bridge-analyst` — 토대 + 커머스 종합 → 라이브DB↔카트 매핑·동적 계산가 주입 전략 후보.
- Phase 3 설계(서브): `hsb-integration-architect` — 종단 아키텍처·계약·시퀀스·전략 권고.
- Phase 4 codex 교차(서브): `hsb-codex-verifier` — **Claude 판정 비노출**(독립).
- Phase 5 게이트(서브): `hsb-integration-gate` — 스펙 필드 재대조·종단 라운드트립·SB1~SB7.
- 모든 Agent 호출 `model: "opus"`. 신규 hsb-* 에이전트가 레지스트리 미로드면 `general-purpose`로 정의파일(`.claude/agents/huni-shopby/<name>.md`)을 읽혀 실행.

## 워크플로

### Phase 0: 컨텍스트 + 스코프
1. `_workspace/huni-shopby/` 존재로 모드 판별: 미존재=초기, 존재+부분요청=부분 재실행(해당 흐름만), 존재+재실행=새 실행(이전 `_prev`).
2. 스코프 확정: 파일럿 우선(토대에서 "카트 전달 가능 상태"로 분류된 대표 상품군 1종 종단) → 완주 후 동형 전파. 사용자가 특정 흐름(회원/게스트·결제·클레임)만 요청하면 그 범위.
3. 자격증명 확인: 문서 권위 기본. 라이브 갭필은 WebFetch(docs.shopby.co.kr). 라이브 DB는 `.env.local RAILWAY_DB_*`(읽기전용, shape 확인용).

### Phase 1: 선행 토대 ∥ 커머스 리서치 (병렬)
- 단일 메시지 2 Agent 병렬.
- `hsb-foundation-curator` → `00_foundation/`: webadmin-pricecalc-flow(상품+구성요소 선택→evaluate_price→final_price·위젯 호출 가능성)·live-db-loaded-state(적재 현황·카트 전달 가능 분류)·foundation-reuse-map(freshness)·open-questions. ★기존 §13/§14/§21/§7 산출 재사용.
- `hsb-commerce-researcher` → `01_research/`: commerce-flow-contract(Cart→OrderSheet→Purchase 시퀀스·operationId·shape)·auth-session-model·open-questions.

### Phase 2: 상품·가격 브리지 (생성 입력)
- `hsb-product-bridge-analyst` → `02_bridge/`: 토대 팩(00_foundation) + 커머스 계약(01_research)을 종합. shopby-product-model·product-price-bridge-spec(매핑 매트릭스)·bridge-strategy-options(A~D × 5축)·open-questions. 핵심=동적 계산가 무손실 주입 경로.

### Phase 3: 종단 통합 설계 (생성)
- `hsb-integration-architect` → `03_design/`: integration-architecture(브리지 전략 권고)·e2e-sequences(회원/게스트 mermaid)·widget-cart-contract(§6 입력용)·open-issues. 각 단계 실제 operationId 바인딩·dead link 0·가격 권위(evaluate_price) 정합.

### Phase 4: codex 독립 2차 교차
- `hsb-codex-verifier` → `04_codex/`: codex-review.sh로 설계 독립 재판정 + reconcile(계약 환각·실현불가 가격주입·정산 구멍·false-positive 양방향). codex 미가용 시 "Claude 단독" 명시 폴백(pending 금지).

### Phase 5: 독립 게이트
- `hsb-integration-gate` → `05_gate/`: 실제 *.yml operationId 필드 단위 재대조 + 종단 라운드트립 추적 + 라이브 shape 확인 + codex 수렴 → SB1~SB7 GO/NO-GO. e2e-golden-trace·remediation-spec.
- NO-GO면 결함을 architect로 되돌려 보정(루프) 후 재게이트.

### Phase 6: 종합 보고 + 진화
- 메인이 GO/NO-GO·브리지 전략 권고·종단 계약 요약·미해결(라이브 갭필·인간 승인 결정)·§6 위임 항목을 보고. 피드백 수집 → CLAUDE.md 변경 이력·메모리 갱신.

## 데이터 전달 프로토콜
- 파일 기반: `_workspace/huni-shopby/{00_foundation,01_research,02_bridge,03_design,04_codex,05_gate,_meta}/`.
- 핸드오프 자: `00_foundation/live-db-loaded-state.md`(카트 전달 가능 상태) → `02_bridge/`(매핑) → `03_design/widget-cart-contract.md`(위젯 입력 계약) ← gate SB2/SB3 종단 검증.
- 각 계약 주장에 `스펙: <파일>:<operationId>` 또는 `파일:라인` 근거·미상은 "모름"·확신도.

## 권위·안전 규칙 [HARD]
- 권위: Shopby OpenAPI 스펙(`docs/shopby/shopby-api/*.yml`) 1차 + enterprise 문서. 라이브(docs.shopby.co.kr)=갭필만. 후니 가격 권위=evaluate_price·상품 권위=상품마스터(260610)/가격표(260527).
- 토대 재사용: §13/§14/§21/§7 산출을 재사용하되 freshness/STALE 표기·v03/STALE 인용 금지·의심분만 라이브 스팟 재실측.
- 브리지=변환 계층. Shopby naming/codes를 후니로 유입 금지. evaluate_price 단일 권위 보존(이중계산 0·PRICE≠0).
- 생성≠검증: 토대/리서치(기준점)·브리지·설계(생성)·codex(독립 2차)·게이트(검증) 분리. 자기 산출 자기 승인 금지.
- codex 주장=가설(환각 경계·스펙/라이브 검증 전 채택 금지). 미가용 시 Claude 단독 명시(pending 금지).
- 라이브 읽기전용: Shopby 라이브는 문서/예시 읽기만(실 주문/결제/장바구니 submit 금지). 라이브 DB는 읽기전용 SELECT(shape 확인). DB 미적재·실 구현/연동은 인간 승인 후 §6 huni-widget 위임·webadmin 코드 직접수정 금지.
- 비밀값(`.env.local` RAILWAY_DB_*·Shopby clientId/토큰)은 `_workspace`(git 추적)·stdout·codex 프롬프트·스크린샷 비노출.

## 기존 자산 재사용 (조사 반복 회피)
- Shopby 문서: `docs/shopby/shopby-api/*.yml`(OpenAPI 24종)·`shopby-api-docs-complete/`·`shopby_enterprise_docs/`·`aurora-react-skin-guide/`·`admin-analysis/`.
- 후니 가격계산 흐름(토대 ①): `raw/webadmin/webadmin/catalog/{pricing.py,price_views.py}`·`templates/catalog/{product_viewer.html,price_viewer.html}`·`_workspace/huni-price-quote/01_engine/`·`_workspace/huni-price-engine-diag/03_synthesis/`.
- 라이브 적재 현황(토대 ②): `_workspace/huni-catalog-conformance/{01_authority/conformance-checklist.csv,06_gate/conformance-final-summary.md}`·`_workspace/huni-dbmap/{10_configurator,00_schema,24_master-extract-260610}/`·`_workspace/huni-price-engine-design/03_design/`.
- 위젯/사이트: `_workspace/huni-widget/`(DESIGN.md·정규화 계약·componentType)·`_workspace/print-quote/04_design/`(ia·api).
- codex 헬퍼: `.claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh`(내부 codex-preflight.sh).

## 테스트 시나리오
- **정상**: "라이브DB 상품/가격을 Shopby 카트로 보내고 위젯 주문까지 흐름 설계해줘" → P1 선행 토대(webadmin 가격계산 흐름·라이브 적재 현황) ∥ 커머스 흐름 리서치 → P2 브리지(토대+커머스 종합·전략 후보) → P3 종단 설계(전략 권고·widget-cart-contract) → P4 codex 교차 → P5 게이트(스펙 재대조·종단 라운드트립·SB1~SB7) → 보고(GO/NO-GO·§6 위임). 산출: `05_gate/gate-verdict.md`.
- **에러1**: codex 데드락/인증만료 → codex-verifier "미가용·Claude 단독" 폴백 → P4 reconcile Claude 단독 마감(pending 금지).
- **에러2**: 동적 계산가 주입 경로를 스펙에서 못 찾음 → bridge open-questions 분리 → 게이트 SB2 CONDITIONAL(전략별 미검증 표기)·라이브 갭필 후속 큐.
- **에러3**: 토대에서 대표 상품군이 결함/갭으로 "카트 전달 불가" 판정 → 파일럿을 가능 상태 상품군으로 재선정·막힌 상품군은 §21/dbmap 라우팅.
- **에러4**: 설계 계약이 실제 operationId와 불일치 → 게이트 SB1 NO-GO → architect 보정 루프 후 재게이트.
- **부분 재실행**: "게스트 주문 흐름만 다시" → 해당 시퀀스만 재설계 → 영향 게이트만 재판정.
