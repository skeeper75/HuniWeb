# 스키마 개요 — Railway `railway` DB

PostgreSQL 18.4 · 스키마 `public` · 테이블 29개 · 읽기 전용 추출.

행 수는 실제 `count(*)`로 검증함(캐시된 `n_live_tup`이 아님). 테이블 접두사 도메인별로 묶음.

## 도메인 맵

| 접두사 | 도메인 | 상태 |
|--------|--------|------|
| `t_cat_` | 카테고리 (마스터 참조, lvl 3까지 자기참조 트리) | 채워짐 |
| `t_cod_` | 기초코드 (enum 사전; 모든 `*_typ_cd` / `grade_cd`의 FK 대상) | 채워짐 |
| `t_clr_` | 색상 / 채널 도수 (마스터) | 채워짐 |
| `t_mat_` | 자재 (마스터) | 채워짐 |
| `t_siz_` | 사이즈 (마스터) | 채워짐 |
| `t_proc_` | 공정 (마스터) | 채워짐 |
| `t_prd_` | 상품 + 관계 테이블 | 대부분 채워짐; 가격/공식 연결은 비어 있음 |
| `t_prc_` | 가격 공식 / 구성요소 / 단가 | **전부 비어 있음 (로드 대상)** |
| `t_dsc_` | 할인 (구간 + 등급) | **전부 비어 있음 (로드 대상 — 이 하네스)** |
| `t_cus_` | 고객 | 비어 있음 |

## 전체 29개 테이블

| Table | Rows | 용도 (DB 코멘트) |
|-------|-----:|----------------------|
| `t_cat_categories` | 306 | 카테고리 — 자기참조 트리 (`upr_cat_cd`), lvl 1–3 |
| `t_clr_color_counts` | 5 | 도수정보 (색상/채널 도수) |
| `t_cod_base_codes` | 58 | 기초코드정보 — enum 사전 (부모 11 + 자식 47) |
| `t_cus_customers` | 0 | 고객 (customers; `grade_cd` → CUS_GRADE) |
| `t_dsc_discount_details` | 0 | 수량구간할인상세, 시계열 — **구간 행 (min/max qty → rate XOR amt)** |
| `t_dsc_discount_tables` | 0 | 수량구간할인 마스터 — **구간 테이블 헤더** |
| `t_dsc_grade_discount_rates` | 0 | 등급별할인율, 시계열 — 등급×카테고리 할인 (수량구간 아님) |
| `t_mat_materials` | 336 | 자재정보 (materials) |
| `t_prc_component_prices` | 0 | 구성요소 다차원 단가 — 시계열 |
| `t_prc_formula_components` | 0 | 공식별구성요소 |
| `t_prc_price_components` | 0 | 가격구성요소 |
| `t_prc_price_formulas` | 0 | 가격공식 |
| `t_prd_product_addons` | 34 | 상품별추가상품 |
| `t_prd_product_bundle_qtys` | 4 | 상품별묶음수 — **묶음수량 행 (수량 기반 가격 입력)** |
| `t_prd_product_categories` | 280 | 상품별카테고리 — **유일한 상품↔카테고리 연결 경로** |
| `t_prd_product_discount_tables` | 0 | 상품별할인테이블 — **상품 → 구간 테이블 연결 (적용 범위)** |
| `t_prd_product_materials` | 406 | 상품별자재 |
| `t_prd_product_page_rules` | 11 | 상품별페이지룰 |
| `t_prd_product_plate_sizes` | 509 | 상품별판형사이즈 |
| `t_prd_product_price_formulas` | 0 | 상품별가격공식 |
| `t_prd_product_prices` | 0 | 상품단가, 시계열 |
| `t_prd_product_print_options` | 172 | 상품별인쇄옵션 |
| `t_prd_product_process_excl_groups` | 13 | 상품별공정택일그룹 |
| `t_prd_product_processes` | 196 | 상품별공정 |
| `t_prd_product_sets` | 28 | 상품셋트정보 |
| `t_prd_product_sizes` | 444 | 상품별사이즈 |
| `t_prd_products` | 280 | 상품정보 (products master; `prd_cd` PK) |
| `t_proc_processes` | 83 | 공정정보 |
| `t_siz_sizes` | 497 | 사이즈정보 |

## 불일치 플래그 (이름-vs-스키마 / 작업-vs-스키마)

1. **`BDL_UNIT` 코드 부모가 존재하지 않는다.** `t_prd_product_bundle_qtys.bdl_unit_typ_cd`는 `t_cod_base_codes`로 일반적으로 FK가 걸리지만, 실제 사용 중인 값은 `QTY_UNIT.03`(권)뿐이다. 따라서 유효한 묶음단위 부분집합은 별도 코드 그룹이 아니라 **`QTY_UNIT.*`** 패밀리(EA/매/권/세트)다. 매핑은 `QTY_UNIT.*`을 재사용해야 한다.
2. **DB에 "굿즈" 카테고리가 없다.** 작업 범위 "굿즈·파우치"는 스키마 내에서 **파우치**로만 해소된다(파우치 이름의 리프 카테고리 전반에 걸친 구별되는 상품 26개, 모두 에코백 `CAT_000011` 아래에 중첩됨). `cat_nm ~ '굿즈'` 행은 없다. 매핑 설계자 / 오케스트레이터에게 플래그.
3. **파우치 범위가 명시된 것보다 넓다.** 작업은 `CAT_000213..CAT_000228`이라 했지만, 실제 파우치 리프 카테고리는 `CAT_000213`–`CAT_000242`, `CAT_000305`, 그리고 에코백 아래 혼합된 형제들에 걸쳐 있다. `target-keys.md` 참고.
4. **상품은 L1 카테고리에 절대 연결되지 않는다.** `CAT_000008/9/11`은 직접 상품 연결이 **0**이다; 상품은 리프 카테고리에만 부착된다. 최상위 카테고리에서의 할인 적용 범위는 `t_cat_categories.upr_cat_cd`의 **재귀 서브트리 순회**가 필요하다.
5. **`MES_ITEM_CD`는 대소문자 혼합 / 따옴표 처리됨.** 컬럼 `t_prd_products."MES_ITEM_CD"`은 유일한 대문자 식별자이며, 부분 UNIQUE 인덱스(`WHERE MES_ITEM_CD IS NOT NULL`)를 가진다. 로더는 이것을 따옴표로 감싸야 한다.
