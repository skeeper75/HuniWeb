---
name: hpq-engine-cartography
description: >
  후니 가격엔진의 흐름과 권위 계약을 추출하는 방법론(가격계산 검증 하네스). raw/webadmin pricing.py(evaluate_price
  단일 권위)·price_views.py·price_*.html을 읽어 가격공식/구성요소/뷰어/시뮬레이터 역할과 데이터 흐름을 mermaid로
  도해하고, evaluate_price 계약(NON_QTY_DIMS/TIER_DIMS 차원 자동매칭·가격 우선순위·단가형/합가형·수량구간·할인 순차곱)을
  검증 가능한 명제로 추출(pricing.py:line 인용)·위젯 가격계약 명세.
  트리거: 가격엔진 흐름, 엔진 지도, 공식 구성요소 뷰어 시뮬레이터 역할, evaluate_price 계약, 위젯 가격계약, 가격 흐름 도해, 흐름 분석 다시.
  권위 골든값은 hpq-authority-curation, 가격사슬 정합 검사는 hpq-price-chain-inspection.
---

# hpq-engine-cartography — 가격엔진 흐름·계약 추출 방법론

## 목적

라이브 데이터의 정합을 판정하려면 먼저 **엔진이 데이터를 어떻게 읽는가**가 권위로 고정돼야 한다.
`evaluate_price`를 권위 알고리즘으로 명세해, 이후 모든 검증의 자(尺)를 만든다.

## 절차

### 1. 4구성물 역할 분리
각 구성물을 소스 근거로 역할 명세한다(추측 금지·pricing.py:line / price_views.py:line 인용):

| 구성물 | 라이브 t_* | 소스 | 역할 |
|--------|-----------|------|------|
| 가격공식 | t_prc_price_formulas + t_prd_product_price_formulas | _evaluate_formula | 공식=구성요소 합산, 상품 바인딩(가격소스 3순위) |
| 가격구성요소 | t_prc_price_components + formula_components + component_prices | _component_rows·match_component | use_dims 차원 자동매칭, 단가형/합가형 |
| 가격뷰어 | (조회) | price_viewer·price_grid·price_dup_check·price_comp_usage·price_diagram | 적재 확인·편집·진단 |
| 가격시뮬레이터 | (계산) | evaluate_price·price_simulator.html | 선택값+수량→final_price+단계내역, what-if |

### 2. 데이터 흐름 도해 (mermaid)
권위엑셀 → 적재 → 공식/구성요소/단가행 → 뷰어(확인) → 시뮬레이터(재계산) → 위젯(주문)까지 한 장.
각 화살표에 전달 페이로드를 적는다.

### 3. evaluate_price 계약을 명제로 추출
각 규칙을 **검증 가능한 명제**(참/거짓 판정 가능)로 적고 pricing.py:line을 박는다. 필수 항목:
- 차원 축: NON_QTY_DIMS(정확매칭·NULL=와일드카드) vs TIER_DIMS(siz_width/height '이하' 상한, min_qty '이상' 하한).
- 가격 우선순위: 템플릿단가 > 상품 직접단가 > 상품 공식 > 없음.
- 단가형(PRICE_TYPE.01)=장당가×수량 / 합가형(PRICE_TYPE.02)=구간총액÷min_qty 환산×수량.
- 데이터 오류: 동시매칭(ERR_AMBIGUOUS)·중복행(ERR_DUPLICATE)·최소수량미달(ERR_BELOW_MIN)·사이즈상한초과(ERR_ABOVE_MAX).
- 공정 다중평가: proc_sels·dim_vals(공정 상세 파라미터, 와일드카드 없음).
- 시계열(apply_ymd ≤ as_of 최신)·할인 순차곱(수량구간 정률/정액 → 등급)·round_won.

> **왜 명제로 적나**: 검사·검증 에이전트가 "이 명제가 라이브에서 참인가"를 직접 판정할 수 있어야
> 결함이 객관화된다. 산문 설명은 검증 불가능하다.

### 4. 위젯 가격계약 명세
옵션 UI 선택 → evaluate_price 입력 정규화 계약:
- selections 딕셔너리 키(차원) ← 옵션 선택값 매핑
- qty·grade_cd·proc_sels·target(prd_cd vs tmpl_cd) 채우는 규칙
- 응답(final_price·base.components·discounts·warnings·errors) → 위젯 표시 계약
- **위젯 코드 자체는 huni-widget 하네스 영역** — 여기서는 인터페이스(계약)만.

## 산출
`_workspace/huni-price-quote/01_engine/`: engine-contract.md · price-flow-map.md · widget-price-contract.md

## 주의
- 소스 라인 못 찾으면 `UNVERIFIED` 표기(추측 금지).
- frm_typ는 폐기됨(공식은 항상 합산) — 옛 frm_typ 기반 설명 인용 금지.
