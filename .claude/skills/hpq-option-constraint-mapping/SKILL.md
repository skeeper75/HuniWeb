---
name: hpq-option-constraint-mapping
description: >-
  라이브 CPQ 레이어(옵션·템플릿·제약·공정 json)가 사용자 정의 의미대로 적재됐는지 검사하는 방법론 스킬(가격계산
  검증 하네스). 사용자 정의[HARD]: 옵션=선택→자재(mat_cd)/공정(proc_cd) BUNDLE을 생산에 전달 / 템플릿=같이 팔
  상품 연결 / 제약=사이즈→추가상품·접지·박 min-max / 공정 상세옵션=json. 검사: ① option_items가 자재·공정 BUNDLE을
  올바로 참조(다중 seq·polymorphic ref_dim_cd·트리거 fn_chk_opt_item_ref 무결성) ② templates/template_prices
  연결상품·엔진 1순위 템플릿단가 정합 ③ product_constraints JSONLogic이 사이즈→추가상품/접지/박 min-max 표현 ④
  component_prices.dim_vals·proc_sels 다중공정 평가 정합. 권위=상품마스터·가격표+engine-contract·결함마다 재현
  쿼리·생성측·교정 인간 승인. 트리거: 옵션 정합, 템플릿 정합, 제약조건 검사, 공정 json 검사, 옵션 자재 공정
  BUNDLE, dim_vals 공정 상세, 옵션 제약 다시. 가격사슬 검사는 hpq-price-chain-inspection, 게이트는
  hpq-quote-gate-validation이 담당.
---

# hpq-option-constraint-mapping — 옵션·템플릿·제약·공정 정합 검사 방법론

## 목적

사용자가 옵션을 선택하면 가격이 산출되는 흐름에서 **선택의 의미 레이어**(옵션·템플릿·제약·공정 상세)가
라이브에 올바로 적재됐는지 검사(사용자 요구 5·6). **생성측** — 판정은 게이트가 독립 재실측.

## 사용자 정의[HARD] — 검사의 절대 기준

| 개념 | 정의 (임의 해석 금지) |
|------|----------------------|
| 옵션 | 사용자가 **선택** → **자재(mat_cd) or 공정(proc_cd), 자재+공정**을 **생산에 전달**. 한 항목이 자재+공정 묶음 가능 |
| 템플릿 | 상품에서 **같이 팔고자 하는 상품을 연결** |
| 제약조건 | 특정 사이즈 클릭 시 **추가상품**, 특정 사이즈 **접지**, 특정 사이즈 **박 최소/최대** |
| 공정 상세옵션 | 공정은 다양한 상세옵션 발생 → **json**(dim_vals) |

## 검사 축

### ① 옵션 = 자재/공정 BUNDLE (요구 5)
- option_items가 mat_cd·proc_cd를 올바로 참조하는가. 자재+공정 묶음이면 두 seq 모두 적재됐나.
- polymorphic ref_dim_cd(OPT_REF_DIM)가 목적 차원을 정확히 가리키나.
- 검증 트리거 `fn_chk_opt_item_ref` 무결성 만족하나.
- 순수 공정(열재단·타공 — 자재 없음) vs 자재+공정 혼동 금지. [[dbmap-option-material-process-bundle]].

### ② 템플릿 = 연결상품 (요구 5)
- t_prd_templates·template_selections가 "같이 파는 상품"을 올바로 연결. base_prd_cd 바인딩.
- template_prices(엔진 1순위 템플릿단가)가 권위 가격과 정합.

### ③ 제약 = 사이즈 조건 (요구 5)
product_constraints JSONLogic이 세 유형을 표현하는지 전수: 사이즈→추가상품 / 사이즈→접지 / 사이즈→박
min·max. 라이브 admin product-viewer 제약 폼빌더 대조([[dbmap-live-admin-product-viewer]], gstack 읽기만).

### ④ 공정 상세 json (요구 6)
- component_prices.dim_vals(공정 상세 파라미터 JSON) ↔ 엔진 proc_sels 다중공정 평가(pricing.py
  `_evaluate_formula` is_proc 분기) ↔ 라이브 공정 json 구조 정합.
- 공정 상세 키가 selections로 흘러 단가행 dim_vals와 매칭되는 경로 검증.

## 산출
`_workspace/huni-price-quote/04_option/`: option-bundle-board.md · template-constraint-board.md · process-json-report.md

## 결함 포맷
각 결함에 **재현 쿼리/화면경로** 첨부(게이트 독립 재실측 가능하게). 트리거 무결성 실패·불명확은
`CONFIRM` 큐로 분리(단정 금지). gstack 라이브 탐색 시 저장/삭제 클릭 금지(읽기만).
