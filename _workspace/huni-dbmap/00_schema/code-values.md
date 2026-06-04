# 기초코드 — `t_cod_base_codes` (58행)

자기참조형 enum 사전. 구조: **부모코드 11개**(`upr_cod_cd IS NULL`)가 코드 그룹을 정의하고, **자식코드 47개**가 실제 enum 값을 담는다(`upr_cod_cd` = 부모 그룹). PK `cod_cd`; FK `upr_cod_cd` → 자기참조(ON UPDATE CASCADE / ON DELETE RESTRICT); CHECK `use_yn IN ('Y','N')`. 58행 모두 `use_yn='Y'`, `note`는 비어 있다.

## 부모 그룹 (11)

| cod_cd | cod_nm | 자식 수 | 사용처 (column → table) |
|--------|--------|:----------:|--------------------------|
| `PRD_TYPE` | 상품유형 | 4 | `t_prd_products.prd_typ_cd` |
| `SEMI_ROLE` | 반제품역할 | 5 | `t_prd_products.semi_role_cd` |
| `CUS_GRADE` | 고객등급 | 2 | `t_cus_customers.grade_cd`, `t_dsc_grade_discount_rates.grade_cd` |
| `MAT_TYPE` | 자재유형 | 11 | `t_mat_materials.mat_typ_cd` |
| `PRC_COMPONENT_TYPE` | 가격구성요소유형 | 5 | `t_prc_price_components.comp_typ_cd` |
| `OUTPUT_PAPER_TYPE` | 출력용지유형 | 3 | `t_prd_product_plate_sizes.output_paper_typ_cd` |
| **`DSC_TYPE`** | **할인유형** | **2** | **`t_dsc_discount_details.dsc_typ_cd`, `t_dsc_grade_discount_rates.dsc_typ_cd`** |
| `SEL_TYPE` | 선택유형 | 2 | `t_mat_materials.sel_typ_cd`, `t_prd_product_process_excl_groups.sel_typ_cd` |
| `USAGE` | 용도 | 7 | `t_prd_product_materials.usage_cd` |
| `QTY_UNIT` | 수량단위 | 4 | `t_prd_products.qty_unit_typ_cd`, **`t_prd_product_bundle_qtys.bdl_unit_typ_cd`** |
| `FRM_TYPE` | 공식유형 | 2 | `t_prc_price_formulas.frm_typ_cd` |

## 핵심 주의 — 할인유형 코드 부분집합 (`dsc_typ_cd`)

`dsc_typ_cd`(`t_dsc_discount_details`와 `t_dsc_grade_discount_rates` 양쪽)는 `t_cod_base_codes(cod_cd)`로 일반적으로 FK가 걸리며 — FK 자체는 부분집합으로 **제한하지 않는다**. 의도된 부분집합은 `DSC_TYPE` 부모 그룹으로 결정된다.

| cod_cd | cod_nm | 의미 |
|--------|--------|---------|
| `DSC_TYPE.01` | 정률 | **rate** — `dsc_rate`(numeric(5,2), 퍼센트)와 짝지으며 `dsc_amt`는 NULL로 둔다 |
| `DSC_TYPE.02` | 정액 | **amount** — `dsc_amt`(numeric(12,2))와 짝지으며 `dsc_rate`는 NULL로 둔다 |

> 할인유형 부분집합은 스키마로부터(`upr_cod_cd='DSC_TYPE'`을 통해) 결정 **가능**하다. 정확히 이 두 개다. rate/amt CHECK 제약과도 정렬된다: `DSC_TYPE.01`→`dsc_rate`, `DSC_TYPE.02`→`dsc_amt`. 로더는 `dsc_typ_cd`와 채워진 숫자 컬럼을 일관되게 유지해야 한다(스키마는 이 짝짓기를 강제하지 않는다 — rate/amt NAND만 강제한다).

## 핵심 주의 — 묶음단위 코드 부분집합 (`bdl_unit_typ_cd`)

**`BDL_UNIT` 부모 그룹은 없다.** `t_prd_product_bundle_qtys.bdl_unit_typ_cd`는 **`QTY_UNIT`** 그룹을 재사용한다.

| cod_cd | cod_nm |
|--------|--------|
| `QTY_UNIT.01` | EA |
| `QTY_UNIT.02` | 매 |
| `QTY_UNIT.03` | 권 *(현재 실제로 사용되는 유일한 값)* |
| `QTY_UNIT.04` | 세트 |

> 스키마로부터는 간접적으로만 결정 가능하다("bundle"에 대한 이름 매칭이 없음); 실데이터로 확인됨 — 모든 묶음 행이 `QTY_UNIT.03`을 사용한다. 유효한 묶음단위 부분집합은 `QTY_UNIT.*` 전체 패밀리로 취급한다.

## 그룹별 전체 자식

**PRD_TYPE:** .01 완제품 · .02 반제품 · .03 기성상품 · .04 디자인상품
**SEMI_ROLE:** .01 내지 · .02 표지 · .03 면지 · .04 간지 · .05 투명커버
**CUS_GRADE:** .01 VIP · .02 일반
**MAT_TYPE:** .01 종이 · .02 필름 · .03 아크릴 · .04 금속 · .05 원단 · .06 가죽 · .07 부속 · .08 실사소재 · .09 파우치 · .10 악세사리 · .11 스티커
**PRC_COMPONENT_TYPE:** .01 인쇄비 · .02 코팅비 · .03 용지비 · .04 후가공비 · .05 박형압비
**OUTPUT_PAPER_TYPE:** .01 국전계열 · .02 46계열 · .03 기타
**DSC_TYPE:** .01 정률 · .02 정액
**SEL_TYPE:** .01 단일 · .02 다중
**USAGE:** .01 내지 · .02 표지 · .03 면지 · .04 간지 · .05 투명커버 · .06 표지타입 · .07 공통
**QTY_UNIT:** .01 EA · .02 매 · .03 권 · .04 세트
**FRM_TYPE:** .01 합산형 · .02 단순형
