---
name: hcc-price-engine-conformance
description: >-
  후니프린팅 카탈로그 종단 정합 하네스의 가격엔진 항목 정합 검사 방법론. ★기존 가격엔진 하네스 산출물
  (§13 engine-contract·§14 진단·§18 설계)을 재사용해(재조사 금지) 가격엔진(evaluate_price)이 가격 산출에
  필요한 항목을 권위 엑셀대로 처리하는지 검사 — 상품-공식 바인딩·공식→formula_components→price_components→
  component_prices 배선·use_dims 차원 3원 충전·수량구간 할인. 그리고 기초데이터/CPQ 축을 가격까지 종단 연결
  (옵션→차원→단가행→final_price 골든 e2e 추적)한다. 트리거: 가격엔진 항목 정합, 가격 처리 검사, 공식 구성요소
  단가행 검사, use_dims 차원 충전, 수량구간 할인 검사, 종단 가격 연결, 골든 e2e 추적, 가격엔진 검사 다시.
  생성측·돈 크리티컬·교정 인간 승인. 기초데이터는 hcc-basedata-conformance, CPQ는 hcc-cpq-link-conformance.
---

# hcc-price-engine-conformance — 가격엔진 항목 정합 검사 방법론

## 목적

가격엔진이 **가격에 필요한 항목을 제대로 처리하는가**(사용자 요구)를 검사하고, 기초데이터/CPQ 축을
**가격까지 종단 연결**한다. **생성측** — 돈이 오가므로 신중히, 게이트가 재계산으로 독립 재실측.

## ★조사 반복 금지 [HARD] (사용자 directive)

가격엔진은 §13·§14·§18이 이미 충분히 산출했다. evaluate_price를 새로 해부하지 말고 **engine-contract.md
계약을 인용**해 "그 설계대로 라이브가 적재·처리되는가"의 정합만 본다. 같은 분석 반복 금지.

## 검사 항목 (engine-contract 계약 기준)

| 항목 | 라이브 | 정합 핵심 |
|------|--------|----------|
| 상품-공식 바인딩 | t_prd_product_price_formulas | 옳은 공식에 묶였나(미바인딩=가격 0·[[huni-widget-red-price-never-zero]]) |
| 공식→구성요소 | t_prc_formula_components | 시트 차원경계 안(silent 합산 방지·U-7 계승·[[huni-price-engine-diag-harness]]) |
| 구성요소→단가행 | t_prc_component_prices | 단가값 verbatim·단가행 0=가격 못 냄 |
| use_dims 3원 | component_prices 충전 차원 | 선언↔충전↔권위 일치·판별차원 없음(항상매칭=과대)·동시매칭(ERR_AMBIGUOUS=차단) |
| 수량구간 할인 | t_prd_product_discount_tables·t_dsc_* | 구간·할인율 정합([[dbmap-discount-authority]]) |

## 종단 연결 검사 [HARD] (이 검사의 차별점)

basedata가 확인한 차원 + cpq-link가 확인한 옵션→차원 연결이 **가격 단가행으로 끝까지 환원되어
evaluate_price가 가격을 내는가**. 대표 케이스 1건에 대해 `옵션 선택 → 차원 환원 → 단가행 매칭 →
final_price`를 단계별로 추적(정합의 정석). 이 추적이 끊기는 지점 = 가장 비싼 결함(견적 안 나옴).

## 워크플로

1. engine-contract.md·binding_validity 산출 로드(권위 기준·재사용).
2. 상품별 공식 바인딩·formula_components 배선을 라이브 psql로 확인(진단 뷰 price_comp_usage·price_dup_check 재사용).
3. use_dims 3원 매트릭스(선언↔충전↔권위 가격축).
4. 종단 추적: 대표 상품 옵션 선택값을 차원으로 환원→단가행 매칭→final_price 산출 경로 점검.
5. 돈영향 분류(과대합산/과소/차단)·셀 채움(빈 셀 0).

## 산출 (`_workspace/huni-catalog-conformance/04_price_engine/`)

`price-engine-defect-board.md`(결함·돈영향·재현 쿼리·라우팅) · `dimension-to-price-trace.md`(종단 골든 e2e 추적) · `price-cells.csv`.

## 라우팅·안전

직접 교정 금지. 가격 정립→dbm-price-arbiter · 교정 적재→dbm-load-execution. 단가값 날조 0·v03/STALE 인용 금지.
