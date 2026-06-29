---
name: huni-set-product-orchestrator
description: >-
  후니프린팅 셋트상품 구성·설계·라이브 적재 하네스 오케스트레이터. 기초마스터~상품정보~상품뷰어~셋트상품관리
  4계층을 종합해 셋트상품(부품조립형: 셋트 완제품 prd_cd ← 반제품 구성원 sub_prd_cd, t_prd_product_sets)
  구성 데이터를 설계하고 라이브 DB에 실제 적재한다(자체 load-executor·인간 승인 게이트). 권위=상품마스터
  엑셀(260610)·참조=인쇄도메인+경쟁사(레드프린팅·와우프레스)·가격은 evaluate_set_price 정합(가격 구성 가능성).
  상품유형: 기성·디자인 제외·완제품=단일 제조상품(셋트 아님)·반제품=셋트 구성원. 흐름: 권위 큐레이션
  (hsp-authority-curator) ∥ 도메인/경쟁사 참조(hsp-domain-researcher) → 셋트 설계(hsp-set-designer) → codex
  독립 2차(hsp-codex-verifier) → 독립 게이트(hsp-set-gate, S1~S8·evaluate_set_price 재계산·DRY-RUN) →
  승인 후 안전 적재(hsp-load-executor·백업·멱등·사후검증). 생성≠검증·codex 주장=가설·search-before-mint·
  권위 절대·라이브 읽기전용(적재만 승인 후 COMMIT)·파일럿(책자/엽서북/떡메) 완주→동형 전파. 트리거:
  셋트상품 구성, 셋트상품 설계, 세트상품 설계, 부품조립 셋트, t_prd_product_sets 적재, 셋트 구성 데이터,
  셋트상품 라이브 적재, 셋트 가격 구성, 셋트상품 하네스 실행/재실행/업데이트/보완, 특정 셋트만 구성/설계.
  가격공식 설계 자체는 huni-price-engine-design(§18), 전 상품 정합은 huni-catalog-conformance(§21),
  CPQ 옵션 매핑은 dbmap이 담당. 단순 질문은 직접 응답.
---

# huni-set-product-orchestrator — 셋트상품 구성·설계·라이브 적재 하네스

기초마스터~상품정보~상품뷰어~셋트상품관리 4계층을 종합해 **셋트상품(부품조립형) 구성 데이터를 설계하고
라이브에 실제 적재**한다. 권위=상품마스터·참조=인쇄도메인+경쟁사·가격=evaluate_set_price 정합.

## 정체성 (기존 하네스와 경계)

| 하네스 | 무엇 | 본 하네스와 차이 |
|--------|------|-----------------|
| §18 Price-Engine-Design | 셋트 **가격공식** 설계(DB 미적재) | 본 하네스는 셋트 **구성 데이터** 설계 + **실 적재** |
| §7 dbmap | CPQ/templates **스키마** 설계 | 본 하네스는 t_prd_product_sets **행 적재** |
| §21 Catalog-Conformance | 추가물(addon) **정합 검증** | 본 하네스는 셋트 **구성·조립·적재** |
| §11 rpmeta | 세트 **메타모델** 발굴 | 본 하네스는 후니 셋트 **실데이터** |

→ 본 하네스 = 위 설계 산출물을 **입력으로 종합** → 셋트 구성 데이터 조립 → evaluate_set_price 가격 정합 검증 → **라이브 COMMIT**(인간 승인). ★조사 반복 금지(기존 산출물 재사용).

## 셋트 모델 (사용자 확정 directive)

- **셋트 = 부품조립형.** 셋트 완제품(prd_cd) ← 반제품 구성원(sub_prd_cd) × qty + min/max/incr (`t_prd_product_sets`, models.py:464).
- **상품유형**: 기성상품(제조불필요)·디자인상품 = **제외**. 완제품 = 셋트 아닌 **단일 제조상품**. 반제품 = 셋트 **구성원**.
- webadmin이 이미 셋트 인라인 sub_prd_cd를 반제품으로만 필터(admin.py:1082)·전용 화면 `/admin/set-products/`(views.py:622).
- **가격** = evaluate_set_price(pricing.py:718) = 구성원별 evaluate_price 합산 + 셋트 완제품 공식 + 할인. 가격을 구성할 수 있어야 한다(사용자 directive).

## 실행 모드: 하이브리드 (기준점 팬아웃 → 설계 → codex 독립 → 게이트 → 적재)

- Phase 1 기준점: `hsp-authority-curator` ∥ `hsp-domain-researcher` **병렬**(서브) — 권위 추출 + 도메인/경쟁사 보강.
- Phase 2 설계: `hsp-set-designer` 단일(서브) — 셋트 구성 적재본 조립.
- Phase 3 codex 교차: `hsp-codex-verifier` 단일(서브) — **Claude 판정 비노출**(독립).
- Phase 4 게이트: `hsp-set-gate` 단일(서브) — 라이브 재실측·evaluate_set_price 재계산·DRY-RUN·S1~S8.
- Phase 5 적재: `hsp-load-executor` 단일(서브) — 게이트 GO + **인간 승인** 후 COMMIT.
- 모든 Agent 호출 `model: "opus"`. 신규 hsp-* 에이전트가 레지스트리 미로드면 `general-purpose`로 정의파일을 읽혀 실행.

## 워크플로

### Phase 0: 컨텍스트 + 스코프
1. `_workspace/huni-set-product/` 존재로 모드 판별: 미존재=초기, 존재+부분요청=부분 재실행(해당 셋트만), 존재+재실행=새 실행(이전 `_prev`).
2. 스코프 확정: 파일럿 우선(책자류·엽서북·떡메 — 부품조립 셋트의 정석) → 완주 후 동형 전파. 사용자가 특정 셋트만 요청하면 그 범위. 모델 범위(부품조립 우선·보조 테이블 포함 여부)는 사용자 directive 따름.
3. 자격증명 확인(`.env.local RAILWAY_DB_*`). 부재 시 AskUserQuestion(서브는 질문 금지).

### Phase 1: 기준점 팬아웃 (병렬)
- 단일 메시지 2 Agent 병렬.
- `hsp-authority-curator` → `01_authority/`: set-authority-spec·product-type-board(라이브 실측 분류)·set-checklist(누락 0의 자)·reuse-map.
- `hsp-domain-researcher` → `02_reference/`: domain-set-bom·competitor-set-reference(레드/와우 흡수)·gap-fill-candidates. 권위 CONFIRM/모호분 보강.

### Phase 2: 셋트 설계 (생성)
- `hsp-set-designer` → `03_design/`: set-composition-design·t_prd_product_sets.csv·apply.sql(복합PK 멱등)·blocked-board. set-checklist 전수 채움(빈 셀 0). search-before-mint(반제품 미등록·공식 부재는 BLOCKED).

### Phase 3: codex 독립 2차 교차
- `hsp-codex-verifier` → `04_codex/`: codex-review.sh로 설계 독립 재판정 + reconcile(오구성·가격결함·false-positive 양방향). codex 미가용 시 "Claude 단독" 명시 폴백(pending 금지).

### Phase 4: 독립 게이트
- `hsp-set-gate` → `05_gate/`: 라이브 재실측 + evaluate_set_price 재계산(S4 돈크리티컬) + 롤백 DRY-RUN(S6) + S1~S8 → GO/NO-GO. price-e2e-trace(셋트 가격 종단 재현)·remediation-spec.
- NO-GO면 결함을 set-designer로 되돌려 보정(루프) 후 재게이트.

### Phase 5: 승인 후 안전 적재 [HARD — 인간 승인 게이트]
- 게이트 GO 큐를 **사용자에게 보고하고 적재 승인을 받는다**(AskUserQuestion). 승인 전 COMMIT 금지.
- `hsp-load-executor` → `06_load/`: FK 선행 확인 → 물리 백업 → 롤백 DRY-RUN 멱등 실증 → 트랜잭션 래핑 COMMIT → 사후 재실측(evaluate_set_price 무손상) → undo 보유. BLOCKED/미승인 행 제외. 대상 0건=NO-OP.

### Phase 6: 종합 보고 + 진화
- 메인이 적재 행수·백업명·게이트 결과·BLOCKED 라우팅·미해결을 요약 보고. 피드백 수집 → CLAUDE.md §24 변경 이력 갱신·메모리 갱신.

## 데이터 전달 프로토콜
- 파일 기반: `_workspace/huni-set-product/{01_authority,02_reference,03_design,04_codex,05_gate,06_load,_meta}/`.
- 핸드오프 자: `set-checklist.csv`(전수 셀) ← 설계가가 채움 ← 게이트 S1이 빈 셀 0 검증.
- 각 셋트·결함에 재현 SQL/계산·확신도·돈영향.

## 권위·안전 규칙 [HARD]
- 권위: 상품마스터(260610) 절대. 인쇄도메인·경쟁사(레드/와우)=보강 렌즈(권위 덮어쓰기 금지·naming/codes 유입 금지). v03/STALE 인용 금지.
- 셋트 = 부품조립형·구성원=반제품만(완제품/기성/디자인 혼입 0). search-before-mint(반제품 신규 mint 금지·미등록은 BLOCKED).
- ★**상품별 구성요소 경계 (옵션 오염 방지) [HARD·사용자 directive]**: 각 상품(셋트 완제품·각 반제품 구성원)은 상품마스터 **자기 시트가 허용하는 구성요소**(자재·사이즈·도수·인쇄옵션·공정·옵션)만 가진다. 엑셀의 각 상품 시트 = 그 상품이 선택 가능한 구성요소의 **권위 경계**다. 다른 상품의 구성요소·가공방식을 끌어오면 "**옵션 오염**"이며 금지. 공유 가격공식·공유 구성요소를 쓰더라도 각 상품은 **자기 시트 허용 분기만** 매칭/배선해야 하며(제본 공유공식이라도 중철 책자엔 중철만·무선엔 무선만), 공유로 인해 한 상품의 옵션이 다른 상품에 silent 적용되는 것을 적발·차단한다. (현황판 B-4 `PRF_BIND_SUM` 공유 오염의 근본 가드 — 게이트 S8.)
- 가격 정합: evaluate_set_price로 PRICE≠0 계산 가능해야 GO. 이중합산 0.
- ★BLOCKED-PRICE 2층 구분 [HARD]: 라이브 t_prc_* 0행을 "진성 부재"로 단정 금지. 먼저 상품마스터 계산공식집 시트(`calc-formula-draft-l1.csv`)+§18 PRF_BIND_*로 **권위 공식 유무**를 확정 — 권위 존재+라이브 미적재="적재 대상"(전사), 권위에도 없음=신설.
- 생성≠검증: 설계(생성)/codex(독립 2차)/게이트(검증)/적재(실행) 분리. 자기 산출 자기 승인 금지.
- codex 주장=가설(환각 경계·라이브/권위 검증 전 채택 금지).
- 라이브 읽기전용 SELECT(Phase 1~4)·**적재(Phase 5)만 인간 승인 후 COMMIT**·DRY-RUN 롤백전용·물리 DELETE 금지(del_yn 논리). 비밀값(_workspace·stdout·codex 프롬프트) 비노출·`.env.local RAILWAY_DB_*`만.
- 적재 후 git 커밋 시 .env.local IGNORED 확인.

## 기존 자산 재사용 (조사 반복 회피)
- 셋트/부품 캐시: `_workspace/huni-dbmap/00_schema/ref-product-sets.csv`·`ref-product-addons.csv`·`ref-product-bundle-qtys.csv`.
- 권위 캐시: `_workspace/huni-dbmap/24_master-extract-260610/`(booklet-l1=구성 + ★`calc-formula-draft-l1.csv`=셋트 권위 가격공식 [필수]·BLOCKED-PRICE 판정 전 반드시 대조).
- 셋트 가격공식: `_workspace/huni-price-engine-design/03_design/`(PRF_BIND_*). CPQ: `_workspace/huni-dbmap/10_configurator/`. 메타모델: `_workspace/huni-rpmeta/02_metamodel/`.
- 권위 코드: `raw/webadmin/catalog/{models.py:464,pricing.py:718,admin.py:1041,views.py:622}`.
- 스킬: `dbm-schema-extract`·`dbm-excel-parse`·`dbm-load-execution`·`hpe-competitor-benchmark`·`rpm-live-reverse`·`dbm-domain-researcher`. codex 헬퍼: `hqv-codex-cross-verify/scripts/codex-review.sh`.

## 테스트 시나리오
- **정상**: "책자류 셋트상품 구성해서 라이브에 넣어줘" → P1 큐레이션(상품유형 분류·셋트 BOM)∥참조(레드/와우 책자) → P2 설계(t_prd_product_sets 적재본·search-before-mint) → P3 codex 교차 → P4 게이트(evaluate_set_price 재계산·DRY-RUN·S1~S8) → 인간 승인 → P5 적재(백업·멱등 COMMIT·사후검증). 산출: `06_load/exec-report.md`.
- **에러1**: codex 데드락/인증만료 → codex-verifier "미가용·Claude 단독" 폴백 → P3 reconcile Claude 단독 마감(pending 금지).
- **에러2**: 반제품 구성원이 라이브 미등록 → 설계가 blocked-board 분리 → 게이트 CONDITIONAL(해당 셋트 제외) → dbmap 라우팅(반제품 등록 선행).
- **에러3**: 구성원/셋트 가격공식 부재 → S4 NO-GO(가격계산 불가) → §18 가격공식 설계 라우팅 후 재게이트.
- **부분 재실행**: "엽서북 셋트만 다시" → checklist의 엽서북 셀만 재설계 → 영향 게이트만 재판정 → 승인 후 추가 적재(멱등).
