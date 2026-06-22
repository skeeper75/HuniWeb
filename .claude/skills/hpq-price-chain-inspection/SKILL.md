---
name: hpq-price-chain-inspection
description: >-
  라이브 t_prc_* 가격사슬이 권위 엑셀·엔진 계약에 맞는지 전수 대조하는 방법론 스킬(가격계산 검증 하네스).
  검사 축: ① 공식↔구성요소 배선·상품-공식 바인딩 정합 ② 불필요분(판별차원 없는 구성요소·동시매칭 유발 중복행·
  중복 단가행·고아 공식·배선됐으나 단가행 0·권위에 없는 차원 배선) ③ 가격테이블 각 차원(siz_cd·mat_cd·proc_cd·
  opt_cd·print_opt_cd·bdl_qty·siz_width/height·min_qty)↔component_prices 매핑(use_dims↔단가행↔권위 가격축 3원)
  ④ 사이즈 중복(동의어 중복·siz_cd 이산축↔siz_width/height 구간축 혼동·비규격). 진단 뷰(price_dup_check·
  price_comp_usage·price_diagram) 재사용·결함마다 재현 쿼리·생성측·결함 보드까지만(교정 인간 승인). 트리거:
  가격사슬 검사, 가격사슬 정합, 불필요 구성요소, 판별차원 없음, 차원 매핑 검사, 사이즈 중복 검사, 가격 결함 보드,
  가격사슬 다시. 옵션/제약 검사는 hpq-option-constraint-mapping, 독립 재계산·게이트는 hpq-quote-gate-validation이 담당.
---

# hpq-price-chain-inspection — 라이브 가격사슬 정합 검사 방법론

## 목적

`engine-contract`(엔진이 데이터를 어떻게 읽는가)와 `authority-golden`(엑셀 정답)을 기준으로 라이브
가격사슬을 전수 대조해, 권위와 어긋난 결함을 보드로 만든다(사용자 요구 3·4·7). **생성측** — 판정은
게이트가 독립 재실측한다.

## 3원 정합 원칙
모든 결함은 ① 권위 엑셀 ② 엔진 계약 ③ 라이브 실측(psql) **세 면을 대조**해 판정한다. 한 면만 보고
단정 금지. 결함마다 **재현 쿼리(psql 한 줄)**를 붙여 검증자가 그대로 돌릴 수 있게 한다.

## 검사 축

### ① 배선 정합
- t_prc_formula_components가 권위 가격축대로 배선됐는지(공식에 들어갈 구성요소만 들어갔나).
- t_prd_product_price_formulas 상품-공식 바인딩 정합(상품이 옳은 공식에 묶였나).

### ② "불필요" 전수 스캔 (요구 3)
| 결함 유형 | 판정 | 도구 |
|----------|------|------|
| 판별차원 없는 구성요소 | use_dims 비수량 차원이 단가행에서 전부 NULL → 항상 매칭(pricing.py non_qty_dims 빈 경우). 의도된 고정비 vs 오염을 권위로 판별 | psql |
| 동시매칭 유발(ERR_AMBIGUOUS) | 같은 선택값에 비수량 차원조합 2+ 매칭(공통 NULL행+전용행 공존) | price_dup_check |
| 중복 단가행(ERR_DUPLICATE) | 동일 (조합·구간·적용일) 중복 | price_dup_check |
| 고아/미사용 | 미배선 구성요소·단가행 0 구성요소·미바인딩 공식 | price_comp_usage |
| 불필요 배선 | 권위 가격축에 없는 차원을 쓰는 구성요소 배선 | 권위 대조 |

> **왜 중요**: 불필요분은 엔진에서 오작동(동시매칭=계산 차단, 항상매칭=과대합산)을 일으켜 견적을
> 틀리게 한다. "있어도 그만"이 아니라 **돈을 틀리게 만드는 결함**이다.

### ③ 차원↔데이터 매핑 (요구 4)
각 구성요소의 `use_dims` 선언 차원 ↔ component_prices 단가행 실제 충전 차원 ↔ 권위 가격축, **3원 일치**
전수 검사. 불일치 유형: 선언했으나 미충전 / 충전했으나 미선언 / 권위에 없는 차원 충전 / 권위 차원 누락.
→ `dimension-mapping-matrix.md`(구성요소 × 차원 매트릭스).

### ④ 사이즈 중복 (요구 7)
- t_siz_sizes 동의어 중복(동일 규격·작업사이즈인데 siz_cd 중복 등록).
- siz_cd 이산축 ↔ siz_width/siz_height 구간축 혼동(같은 상품이 두 축으로 가격됨).
- 비규격 가로/세로(nonspec_*) 속성이 권위와 정합한지.
→ `size-dedup-report.md`. [[dbmap-area-matrix-wh-dimension]] 정합.

## 산출
`_workspace/huni-price-quote/03_chain/`: chain-defect-board.md · dimension-mapping-matrix.md · size-dedup-report.md

## 결함 포맷
각 결함: `{위치(t_*·코드) · 증상 · 권위 정답 · 원인 가설 · 재현 쿼리 · 라우팅(dbmap 트랙)}`.
직접 교정(UPDATE/DELETE/DDL) 금지. 권위/라이브 충돌이 불명확하면 `CONFIRM` 큐로 분리(결함 단정 금지).
