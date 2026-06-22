---
name: huni-price-quote-orchestrator
description: >-
  후니프린팅 "상품군 옵션 선택→가격계산" 검증·뼈대 하네스 오케스트레이터. 라이브 가격엔진(pricing.py
  evaluate_price 단일 권위)과 라이브 t_prc_* 가격 데이터가 권위 엑셀(상품마스터 260610·가격표 260527)에 맞게
  적재됐는지 냉철하게 평가·검증하고, 옵션선택→가격구성요소→가격공식→시뮬레이터→위젯 계약의 단단한 뼈대를
  명세한다. 5인 팀(engine-cartographer 엔진 계약 / authority-curator 권위 골든 / price-chain-inspector 가격사슬·
  불필요분·차원매핑·사이즈중복 / option-constraint-mapper 옵션·템플릿·제약 / quote-gate-validator P1~P7 게이트).
  생성≠검증·권위 엑셀 절대권위·라이브 읽기전용·DB 미적재(실 교정 인간 승인)·대표 상품군 파일럿 우선·dbm-price-*
  6종 재사용. 트리거: 가격계산 하네스, 옵션 가격 검증, 가격엔진 검증, 가격공식 가격구성요소 검증, 권위 엑셀 매핑
  검증, 시뮬레이터 검증, 옵션 템플릿 제약 검증, 사이즈 중복 점검, 가격 뼈대, 특정 상품군만 가격검증, 하네스
  실행/재실행. 단순 질문은 직접 응답.
---

# huni-price-quote-orchestrator — 가격계산 검증·뼈대 하네스

후니 가격계산 시스템의 **냉철한 정합 검증**과 **옵션→가격 뼈대 명세**를 5인 에이전트 팀으로 수행한다.

## 정체성 (왜 이 하네스인가)

기존 huni-dbmap에 가격 에이전트 6종(arbiter·engine-verify·formula·formula-audit·import-prep·cpq-option)이
있으나, 그들은 **분석·논의·제안·적재** 위주였다. 본 하네스는 그 산출을 **입력·도구로 재사용**하되,
정체성은 다르다:

> **라이브 가격엔진(evaluate_price)을 권위 알고리즘으로 고정하고, 라이브 데이터가 그 엔진이 올바른
> 견적을 내도록·권위 엑셀과 일치하게 적재됐는지를 생성≠검증 분리로 냉철하게 판정하는 검증 관문 +
> 옵션선택→가격계산→시뮬레이터→위젯의 계약 뼈대 명세.**

**경계 (vs §15 huni-quote-verify):** 본 하네스(§13)는 **대표 상품군 동형 커버리지를 냉철한 P1~P7 게이트**로 판정한다(여러 상품군 파일럿·생성≠검증 팀). §15 `huni-quote-verify`는 사용자가 준 **단일 상품을 온디맨드로 검증 + Codex(gpt-5.5) 병행** 2nd opinion한다. 서로 보완(커버리지 게이트 vs 단일 상품 온디맨드)·중복 아님.

핵심 자산(Phase 0 실측):
- `pricing.py`의 `evaluate_price` = 단일 권위 알고리즘(차원 자동매칭·우선순위·할인 순차곱).
- 라이브 적재됨: 공식 48·formula_components 301·구성요소 146·단가행 7,293·상품-공식 76·사이즈 520.
  직접단가(t_prd_product_prices) 0 → **전 상품 공식 기반**.
- 라이브 진단 뷰 실재: `price_dup_check`·`price_comp_usage`·`price_diagram`(검증 재사용).

## 실행 모드: 에이전트 팀 (하이브리드 파이프라인 + 생성-검증)

- **Phase 1 (기준점 팬아웃)**: `hpq-engine-cartographer` + `hpq-authority-curator` 병렬 — 코드 권위와
  엑셀 권위를 동시에 고정.
- **Phase 2 (생성 검사 팬아웃)**: `hpq-price-chain-inspector` + `hpq-option-constraint-mapper` 병렬 —
  기준점 대조로 결함 보드 생성.
- **Phase 3 (냉철한 게이트)**: `hpq-quote-gate-validator` — 생성측과 독립으로 재실측·재계산·P1~P7 판정.
- **Phase 4 (수렴 루프)**: NO-GO 시 생성측 보정 → 재게이트, 수렴까지 반복.

> 생성(Phase 2)과 검증(Phase 3)은 반드시 다른 에이전트. 같은 컨텍스트 자기승인 금지(사용자 "냉철" 강조).

## 워크플로

### Phase 0: 컨텍스트 확인
1. `_workspace/huni-price-quote/` 존재 여부로 실행 모드 판별:
   - 미존재 → **초기 실행**(Phase 1부터).
   - 존재 + 부분 수정 요청 → **부분 재실행**(해당 에이전트만 재호출).
   - 존재 + 새 입력/버전 → **새 실행**(기존을 `_workspace_prev/`로 이동).
2. 1차 범위 = **대표 상품군 파일럿 우선**(사용자 확정). 가격산정 4구조(MATRIX·합산형·면적매트릭스·
   2단룩업)를 대표하는 2~3 상품군을 골라 종단 검증 후 동형 확대. 전 11상품군 일괄 금지(거짓 GO 위험).
3. 산출 깊이 = **냉철한 검증·명세 중심·DB 미적재**(사용자 확정). 실 COMMIT/교정은 인간 승인 후 dbmap 위임.

### Phase 1: 기준점 수립 (팬아웃)
- `hpq-engine-cartographer`: `01_engine/`에 engine-contract·price-flow-map·widget-price-contract.
- `hpq-authority-curator`: `02_authority/`에 authority-golden·golden-cases·authority-gaps.
- 두 에이전트를 단일 메시지 2 Agent 호출로 병렬 스폰(`model: "opus"`).

### Phase 2: 정합 검사 (팬아웃)
- `hpq-price-chain-inspector`: `03_chain/`에 chain-defect-board·dimension-mapping-matrix·size-dedup-report
  (요구 3·4·7).
- `hpq-option-constraint-mapper`: `04_option/`에 option-bundle-board·template-constraint-board·
  process-json-report(요구 5·6).
- 병렬 스폰. 경계(옵션↔가격사슬) 겹침은 두 에이전트가 SendMessage로 조율.

### Phase 3: 냉철한 게이트 (검증)
- `hpq-quote-gate-validator`: `05_gate/`에 gate-verdict(P1~P7)·recompute-log·confirmed-defects.
- 생성측 결함을 독립 재현·재계산. 라이브 evaluate_price 호출/재구현(P1 동치 입증 선행).

### Phase 4: 수렴 + 보고
- NO-GO면 막힌 게이트를 생성측에 피드백 → 보정 → 재게이트(수렴까지).
- GO면 리더가 종합: 확정 결함 + 권위정합 현황 + 위젯 계약 뼈대 + 인간 승인 큐(실 교정 위임 대상).

## 데이터 전달 프로토콜
- **파일 기반**(산출물): `_workspace/huni-price-quote/{01_engine,02_authority,03_chain,04_option,05_gate}/`.
- **태스크 기반**(조율): TaskCreate로 Phase 의존성 관리.
- **메시지 기반**(실시간): 경계 조율·NO-GO 피드백은 SendMessage.
- 각 결함/골든값에 **재현 쿼리/셀 출처**를 붙여 검증자가 역추적 가능하게 한다.

## 권위·안전 규칙 [HARD]
- 권위 순서: 상품마스터(260610)+인쇄상품 가격표(260527)가 **절대 권위**. 라이브·역공학·경쟁사는 갭
  헌팅·보강(권위 덮어쓰기 금지). v03 마이그레이션·STALE 원천 정답 참조 금지.
- 라이브 DB는 `.env.local` `RAILWAY_DB_*`로 **읽기전용 SELECT만**. 라이브 화면은 `HUNI_ADMIN_*`로 읽기
  탐색만(저장/삭제 클릭 금지). 비밀값은 `_workspace`(git 추적)·stdout·캡처에 비노출.
- **생성≠검증**: Phase 2 생성자와 Phase 3 검증자는 다른 에이전트. 자기승인 금지.
- **DB 미적재**: 본 하네스는 분석·검증·명세 전용. 실 COMMIT/교정/DDL은 인간 승인 후 dbmap 트랙
  (dbm-axis-staged-load·dbm-load-execution·dbm-price-arbiter)에 위임.

## 기존 자산 재사용
- 스킬: `dbm-schema-extract`(읽기전용 psql)·`dbm-excel-parse`·`dbm-price-import-prep`·`dbm-price-formula`·
  `dbm-cpq-option-mapping`·`dbm-price-arbiter`.
- 산출 인용: dbmap round-2/16(가격표 평면화)·round-17/18(공식·사슬 진단)·33_silsa-price-quote(골든)·
  메모리 [[dbmap-area-matrix-wh-dimension]]·[[dbmap-price-chain-dwire-per-product-formula]]·
  [[dbmap-option-material-process-bundle]].

## 테스트 시나리오
- **정상 흐름**: "엽서(합산형) 가격검증" → Phase 1 엔진계약+엽서 골든값 → Phase 2 엽서 가격사슬·옵션
  결함 → Phase 3 evaluate_price로 엽서 200매 재계산 = 엑셀 골든 → P1~P7 판정 → GO/결함 큐.
- **에러 흐름**: Phase 3에서 재계산값 ≠ 골든 → 어느 구성요소·차원에서 갈렸는지 recompute-log로 지목 →
  NO-GO → 생성측에 "그 구성요소 use_dims↔단가행 차원 재검" 피드백 → 보정 → 재게이트.
