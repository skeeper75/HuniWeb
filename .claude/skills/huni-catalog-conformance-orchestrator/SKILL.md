---
name: huni-catalog-conformance-orchestrator
description: >-
  후니프린팅 카탈로그 종단 정합 검증 하네스 오케스트레이터. 전 라이브 DB 상품에 등록된 12축(사이즈코드·도수·
  인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰·옵션그룹·제약규칙·추가상품 템플릿) + 가격엔진 항목이 두
  권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)과 일치하는지 ★기존 가격엔진 하네스 산출물을 재사용해
  (조사 반복 금지) 종단 검증하고 개선/보완/수정 명세를 낸다. 흐름: 권위 기준·커버리지 큐레이션(authority-curator)
  → 인스펙터 3종 병렬(basedata·cpq-link·price-engine, 옵션→차원·템플릿→추가상품 연결 포함) → codex 독립
  2차 교차(codex-verifier) → 독립 게이트(conformance-gate, gstack product-viewer 라이브 3원 대조·K1~K8·종단
  e2e 골든 추적). 인쇄 도메인 우선·생성≠검증·codex 주장=가설·누락 0·라이브 읽기전용·검증+교정명세+codex합의
  까지(실 COMMIT 인간 승인·dbmap 위임). 트리거: 카탈로그 정합 검증, 전 상품 등록 데이터 정합 검증, 등록 데이터 권위 일치
  확인, 12축 정합, 옵션 차원 연결 검증, 템플릿 추가상품 연결 검증, 가격엔진 항목 정합, 누락 없는 검증,
  codex 교차 정합, product-viewer 확인 검증, 정합 하네스 실행/재실행/업데이트/보완, 특정 축/상품만 정합 검증.
  단일 상품 온디맨드는 huni-quote-verify, 대표 파일럿 가격 게이트는 huni-price-quote, 표시중복은
  huni-basedata-dedup가 담당. 단순 질문은 직접 응답.
---

# huni-catalog-conformance-orchestrator — 카탈로그 종단 정합 검증 하네스

전 라이브 상품의 12축 + 가격엔진이 두 권위 엑셀과 **일치하는지 누락 0으로 종단 검증**하고 개선/보완/
수정 명세를 낸다. e2e 베스트프랙티스의 정석을 보인다.

## 정체성 (기존 하네스와 경계)

| 하네스 | 무엇 | 본 하네스와 차이 |
|--------|------|-----------------|
| §7 Coverage | 전상품×축 **존재**만 | 본 하네스는 값 일치·연결·가격 **계산**까지 |
| §13 Price-Quote | **대표** 파일럿 가격 | 본 하네스는 **전 상품 × 전 축** |
| §15 Quote-Verify | **단일** 상품 3축 | 본 하네스는 전 상품 12축 + CPQ 연결 |
| §17 Dedup | 6축 **표시중복** | 본 하네스는 권위 일치·종단 정합 |

→ 본 하네스 = "L1 권위데이터 → L2 옵션/템플릿 연결 → evaluate_price 계산 → 최종가격 → 라이브 화면"의
**전 상품·전 축 종단 정합 검증 + 교정 명세**. ★기존 가격엔진 산출물을 재사용(조사 반복 금지).

## 실행 모드: 하이브리드 (큐레이션 → 인스펙터 팬아웃 → codex 독립 → 게이트 독립)

- Phase 1 큐레이션: `hcc-authority-curator` 단일(서브) — 기준점.
- Phase 2 인스펙터: `hcc-basedata-inspector` ∥ `hcc-cpq-link-inspector` ∥ `hcc-price-engine-inspector` **병렬 팬아웃**(서브). 같은 기준·서로 다른 축. price-engine은 종단 연결 위해 다른 둘의 셀을 입력으로(약한 의존 — 큐레이터 체크리스트로 동기, 종단 추적만 후행).
- Phase 3 codex 교차: `hcc-codex-verifier` 단일(서브) — 결함 보드 입력, **Claude 판정 비노출**(독립).
- Phase 4 게이트: `hcc-conformance-gate` 단일(서브) — 라이브+gstack 독립 재실측, K1~K8, 교정 명세.
- 모든 Agent 호출 `model: "opus"`. 신규 hcc-* 에이전트가 레지스트리 미로드면 `general-purpose`로 정의파일을 읽혀 실행.

## 워크플로

### Phase 0: 컨텍스트 + 스코프
1. `_workspace/huni-catalog-conformance/` 존재로 모드 판별: 미존재=초기, 존재+부분요청=부분 재실행(해당 축/상품만), 존재+재검증=새 실행(이전 `_prev`).
2. 스코프 확정(사용자 directive): **기존 가격엔진 산출물 재사용·불필요 조사 반복 금지.** 대표 상품군→동형 전파로 효율화하되 최종 모집단은 전 상품(누락 0). 사용자가 특정 축/상품만 요청하면 그 범위.
3. 자격증명 확인(`.env.local RAILWAY_DB_*`·`HUNI_ADMIN_*`). 부재 시 AskUserQuestion(서브는 질문 금지).

### Phase 1: 권위 기준·커버리지 큐레이션
- `hcc-authority-curator` → `01_authority/`: authority-spec·conformance-checklist(전 상품×12축, 누락 0의 자)·domain-lens(인쇄 도메인 먼저)·reuse-map(중복 조사 회피 증거).

### Phase 2: 인스펙터 3종 병렬 (생성측)
- 단일 메시지 3 Agent 병렬.
- basedata → `02_basedata/`(8축 결함 보드·셀) · cpq-link → `03_cpq_link/`(옵션→차원·템플릿→추가상품 연결 무결성·셀) · price-engine → `04_price_engine/`(가격엔진 항목·종단 추적·셀).
- 각자 checklist의 owner 셀을 빠짐없이 채움(빈 셀 0). 못 채운 셀은 BLOCKED 명시.

### Phase 3: codex 독립 2차 교차
- `hcc-codex-verifier` → `05_codex/`: codex-review.sh로 결함 보드 독립 재판정 + reconcile(놓친 결함·false-positive 양방향). codex 미가용 시 "Claude 단독" 명시 폴백(pending 금지).

### Phase 4: 독립 게이트 + 교정 명세
- `hcc-conformance-gate` → `06_gate/`: 라이브 재실측 + gstack product-viewer 3원 대조 + evaluate_price 재계산 + K1~K8 → GO/NO-GO. e2e-golden-trace(정석). remediation-spec(교정 명세·인간 승인 큐·dbmap 라우팅).
- NO-GO면 결함을 인스펙터로 되돌려 보정(루프) 후 재게이트.

### Phase 5: 종합 보고 + 진화
- 메인이 verdict·교정 명세·누락 0 커버리지·인간 승인 큐를 요약 보고. 피드백 수집(7-1) → CLAUDE.md §22 변경 이력 갱신.

## 데이터 전달 프로토콜
- 파일 기반: `_workspace/huni-catalog-conformance/{01_authority,02_basedata,03_cpq_link,04_price_engine,05_codex,06_gate}/`.
- 핸드오프 자: `conformance-checklist.csv`(전수 셀) ← 인스펙터가 `*-cells.csv`로 채움 ← 게이트 K1이 빈 셀 0 검증.
- 각 결함에 재현 SQL/셀 출처·확신도·돈영향.

## 권위·안전 규칙 [HARD]
- 권위: 상품마스터(260610)+인쇄상품 가격표(260527) 절대 권위. 라이브·기존 산출물·codex=입력/렌즈. v03/STALE 인용 금지.
- 인쇄 도메인 먼저: 판단 전 domain-lens 정립(코드 표면 대조 금지).
- 생성≠검증: 인스펙터(생성) / codex(독립 2차) / 게이트(검증) 분리. 자기 셀 자기 승인 금지.
- codex 주장=가설(환각 경계·라이브/권위 검증 전 채택 금지).
- 누락 0: 빈 셀 = NO-GO. 전수 열거 강제.
- 라이브 읽기전용 SELECT만·gstack 읽기 탐색만(저장/삭제 금지)·codex `-s read-only`. 비밀값(_workspace·stdout·codex 프롬프트·스크린샷) 비노출.
- DB 미적재: 검증+교정명세+codex합의까지. 실 COMMIT/교정/DDL은 인간 승인 후 dbmap 트랙 위임.
- ★조사 반복 금지: 기존 가격엔진/매핑 산출물 재사용(reuse-map에 증거).

## 기존 자산 재사용 (조사 반복 회피)
- 권위 캐시: `_workspace/huni-dbmap/24_master-extract-260610/`·`00_schema/ref-*.csv`·`columns.csv`.
- 가격엔진(인용): `_workspace/huni-price-quote/{01_engine,02_authority,03_chain}/`·`_workspace/huni-price-engine-diag/{03_synthesis,04_binding_validity}/`·`_workspace/huni-price-engine-design/03_design/`.
- 스킬: `dbm-schema-extract`·`dbm-excel-parse`·`dbm-price-arbiter`·`browse`(gstack)·`codex-cli`. codex 헬퍼: `hqv-codex-cross-verify/scripts/codex-review.sh`(내부 `rpm-visualize/scripts/codex-preflight.sh`).
- 권위 코드: `raw/webadmin/catalog/pricing.py`(evaluate_price)·product-viewer 캡처 `_workspace/huni-admin-manual/captures/`.

## 테스트 시나리오
- **정상**: "전체 라이브 상품 12축이 권위 엑셀과 일치하는지 검증" → P1 큐레이션(전 상품×12축 checklist) → P2 인스펙터 3 병렬(셀 채움·결함 보드) → P3 codex 교차(reconcile) → P4 게이트(K1~K8·gstack 3원·종단 추적·교정 명세) → GO/NO-GO. 산출: `06_gate/conformance-verdict.md`.
- **에러1**: codex 데드락/인증만료 → codex-verifier "미가용·Claude 단독" 폴백 → P3 reconcile을 Claude 단독으로 마감(pending 금지).
- **에러2**: `HUNI_ADMIN_*` 부재 → 게이트 K6를 BLOCKED 명시 → 나머지 게이트로 CONDITIONAL 판정(추측 로그인 금지).
- **부분 재실행**: "자재 축만 다시 검증" → checklist의 자재 셀만 basedata-inspector 재실측 → 영향받는 게이트만 재판정.
