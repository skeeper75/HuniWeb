---
name: huni-price-engine-diag-orchestrator
description: 후니프린팅 가격엔진 이해·진단 하네스 오케스트레이터. 가격계산엔진을 이루는 5개 장치(① 가격공식 ② 가격구성요소 ③ 할인테이블=수량구간 ④ 가격뷰어 ⑤ 가격시뮬레이터)의 역할·조합 메커니즘을 원리적으로 정의하고, 프로그램 코드(pricing.py·price_views.py)가 DB 엔티티 각 속성에 맞게 제대로 구현됐는지 진단하며, 결론을 내리기 전에 "원리상 아는 것 vs 모르는 것"을 지식맵으로 분리하는 이해·진단 전용 하네스. huni-price-quote(검증·게이트)와 분리된 선행 트랙 — 검증·결론이 아니라 이해·정의·진단까지. 3인 에이전트(hped-mechanism-researcher 장치 역할 원리 정의·지식격차 / hped-code-schema-auditor 코드↔DB 속성 정합 진단 / hped-binding-validity-designer 구성요소↔상품군 유효성 정합 설계=U-7 배선레벨 제약)가 협업하고, 리더가 통합 진단으로 종합한다. '가격엔진 이해', '가격엔진 진단', '가격 장치 역할', '공식 구성요소 할인 뷰어 시뮬레이터 역할', '가격엔진 원리', '조합 메커니즘', '코드 DB 정합', '속성 단위 구현 진단', '설계 산출물 반영', '아는것 모르는것', '지식격차 리서치', '가격 원리 이해', '배선 유효성', '구성요소 상품군 유효성', 'comp 상품 정합', '오배선 적발', '시트 차원경계 위반', '제약 정합 명세', 'U-7', '배선제약 설계', '가격엔진 이해 하네스 실행/재실행/업데이트/보완', '특정 장치만 진단', '가격 진단 다시' 작업 시 반드시 이 스킬을 사용. 권위 엑셀 대비 정합 검증·P1~P7 게이트·골든 재계산·결함 교정은 huni-price-quote-orchestrator(검증 트랙)가 담당하므로 그 작업에는 트리거하지 않는다. 본 스킬은 그 앞단의 "장치 역할을 정확히 정의하고 코드↔DB 구현을 진단하는 이해 레이어"다.
---

# huni-price-engine-diag-orchestrator — 가격엔진 이해·진단 하네스

가격엔진을 이루는 5개 장치의 역할을 원리적으로 정의하고, 코드↔DB 속성 정합을 진단하며, 아는 것과 모르는 것을 분리한다. **결론(검증)이 아니라 이해·진단**이 목적.

## 정체성 (왜 이 하네스인가)

기존 huni-price-quote 하네스는 "evaluate_price 권위 고정 → 라이브 정합 냉철 검증(게이트·결론)"이다. 그런데 직전 검증에서 검증자조차 도수축을 오해하고 엉뚱한 사이즈를 짚었다. 즉 **장치의 역할을 정확히 정의하지 않으면 검증조차 오판한다.** 본 하네스는 그 앞단을 책임진다:

> **가격엔진 5장치의 역할·조합 메커니즘을 원리로 정의 + 코드↔DB 엔티티 속성 정합 진단 + 결론 전에 "아는 것 vs 모르는 것" 분리. 잘못 적재되지 않도록 각 장치/요소를 정확히 정의하고 구현 정합을 이해하는 레이어.**

## 5개 장치 (진단 대상)
1. **가격공식** `t_prc_price_formulas` (+ 상품 바인딩 `t_prd_product_price_formulas`)
2. **가격구성요소** `t_prc_price_components`·`t_prc_formula_components`(배선)·`t_prc_component_prices`(단가행)
3. **할인테이블(수량구간)** `t_dsc_*`
4. **가격뷰어** `price_viewer`·`price_diagram` (적재 확인 UI)
5. **가격시뮬레이터** `price_simulator`·`evaluate_price` (선택→견적 재계산)

## 실행 모드: 에이전트 팀 (팬아웃 + 교차참조)

- **Phase 1 (이해·진단 팬아웃 + 상호 grounding)**: `hped-mechanism-researcher`(장치 역할 원리 정의·조합 메커니즘·지식맵) + `hped-code-schema-auditor`(코드↔DB 속성 정합·3-way 추적) 병렬. 두 에이전트는 SendMessage로 교차참조 — 역할 정의가 진단 기준이 되고, 코드-DB 사실이 확신도를 올린다.
- **Phase 2 (통합 진단)**: 리더가 두 산출을 종합해 `03_synthesis/`에 통합 진단서 + 확정/미지 종합 + 검증 트랙(huni-price-quote)으로 넘길 인계 항목.

> 검증·결론은 본 하네스 밖(huni-price-quote). 본 하네스는 이해·정의·진단까지만.

## 워크플로

### Phase 0: 컨텍스트 확인
1. `_workspace/huni-price-engine-diag/` 존재 여부로 모드 판별:
   - 미존재 → **초기 실행**(Phase 1부터).
   - 존재 + 부분 수정 요청 → **부분 재실행**(해당 에이전트만 재호출).
   - 존재 + 새 입력 → **새 실행**(기존을 `_workspace_prev/`로 이동).
2. 1차 범위 = 분석된 파일럿 상품군(엽서 합산형·현수막/실사 면적매트릭스·아크릴 면적+두께) 기준으로 5장치를 구체화. 추상 일반론 금지 — 실제 상품군이 장치를 어떻게 타는지로 정의.

### Phase 1: 이해·진단 팬아웃 (에이전트 팀)
- `hped-mechanism-researcher` → `01_mechanism/`: device-roles·combination-mechanism·knowledge-map.
- `hped-code-schema-auditor` → `02_code_schema/`: code-schema-matrix·impl-gap-board·design-artifact-trace.
- 단일 메시지 2 Agent 호출로 병렬 스폰(`model: "opus"`). 두 에이전트가 SendMessage로 교차참조.

### Phase 2: 통합 진단 + 인계
- 리더가 `03_synthesis/`에 종합:
  - `engine-comprehension.md` — 5장치 역할 + 조합 메커니즘 통합본(확신도 표기).
  - `known-vs-unknown.md` — 확정 / 미지·추정 종합 + 컨펌큐.
  - `verify-handoff.md` — 검증 트랙(huni-price-quote)으로 넘길 항목(무엇을 검증해야 하는지·진단으로 좁혀진 의심점).

### Phase 3: 구성요소↔상품군 유효성 정합 설계 (U-7·선택)
진단으로 오적재 병인(formula_components prd_cd 부재)이 확정된 뒤, 그것을 닫는 정답 데이터를 설계할 때:
- `hped-binding-validity-designer` → `04_binding_validity/`: comp-product-validity-matrix·binding-violation-board·validity-constraint-spec.
- ★초점[HARD]: 코드(트리거/DDL) 구현이 아니라 **데이터 정합**(구성요소·데이터가 정합해 제대로된 가격이 나오는 것). SOT 1(시트=차원경계) 권위. DDL 형태는 dbm-ddl-proposer, 검증은 hpq 트랙 위임.
- 단독 트리거 가능('U-7', '배선 유효성', '오배선 적발' 등) — 이때 Phase 0(컨텍스트) → Phase 3 직행(이전 진단 산출 입력).

## 데이터 전달 프로토콜
- **파일 기반**: `_workspace/huni-price-engine-diag/{01_mechanism,02_code_schema,03_synthesis,04_binding_validity}/`.
- **메시지 기반**: 교차참조·미지 질의는 SendMessage.
- 각 정의/진단 항목에 **확신도 표기 + 코드/문서/스키마 출처**(file:line·DDL 라인·재현 SQL).

## 권위·안전 규칙 [HARD]
- 권위 순서: ① 라이브 코드(실제 동작) ② 설계 산출물(docs/prcx01-pricing-model.md·pricing-erd.md = 의도) ③ 라이브 스키마/데이터 ④ 인쇄 도메인 원리(보강). 코드와 설계가 어긋나면 그 자체가 발견.
- 라이브 DB는 `.env.local` `RAILWAY_DB_*`로 **읽기전용 SELECT만**. DB 미적재·실 교정 0.
- **추정과 확정 분리** — 이 하네스의 존재 이유. 미지를 결론으로 위장 금지.
- 검증·결론·교정은 huni-price-quote 트랙 위임.

## 기존 자산 재사용
- 인용(권위 아님): `_workspace/huni-price-quote/01_engine/`(engine-contract)·`05_gate/`(검증 발견·오판 사례).
- 스킬: `dbm-schema-extract`(읽기전용 psql).
- 메모리: [[huni-price-quote-harness]]·[[dbmap-schema-design-intent-first]]·[[dbmap-schema-change-round14]].

## 테스트 시나리오
- **정상 흐름**: "가격엔진 5장치 역할 진단" → Phase 1 mechanism(역할정의+지식맵) + code-schema(속성정합) 팬아웃 → 교차참조로 미지 해소 → Phase 2 통합 진단 + known-vs-unknown + 검증 인계.
- **에러 흐름**: code-schema-auditor가 코드-DB 불일치 발견(코드가 없는 컬럼 참조) → mechanism-researcher의 역할 정의 확신도 하향(`[미지]`로 재분류) → 컨펌큐로 인계(결론 강행 안 함).
