# 할인 / 수량구간 도메인 — 전체 상세

할인 + 구간 패턴에 대한 테이블별 권위 상세. 모든 컬럼 타입, PK, FK(ON UPDATE/DELETE 포함), CHECK, 인덱스는 실제 DB에서 그대로 가져왔다. 아래 5개 테이블은 현재 모두 **비어 있다**(로드 대상이다); 구조를 전체 문서화하는 것이 이 하네스의 목적이기 때문이다.

범례: 타입은 선언된 대로; `varchar(N)` = `character varying(N)`; `char(1)` = `character(1)`; `numeric(p,s)`.

---

## 1. `t_dsc_discount_tables` — 수량구간할인 마스터 (구간 테이블 헤더) · 0행

| Column | Type | Null | Default |
|--------|------|:----:|---------|
| `dsc_tbl_cd` | varchar(50) | NO | — |
| `dsc_tbl_nm` | varchar(100) | NO | — |
| `note` | varchar(500) | YES | — |
| `use_yn` | char(1) | NO | — |
| `reg_dt` | timestamp | NO | `now()` |
| `upd_dt` | timestamp | YES | — |

- **PK:** `pk_t_dsc_discount_tables (dsc_tbl_cd)`
- **FK:** 없음
- **CHECK:** `use_yn IN ('Y','N')`
- **인덱스:** PK 유니크 인덱스만.

---

## 2. `t_dsc_discount_details` — 수량구간할인상세, 시계열 (구간 행) · 0행

| Column | Type | Null | Default | 비고 |
|--------|------|:----:|---------|------|
| `dsc_tbl_cd` | varchar(50) | NO | — | 할인테이블코드 (→ 헤더) |
| `apply_ymd` | varchar(10) | NO | — | 적용일자 (시계열 키, 예: `2026-06-01` — D-E 확정 yyyy-MM-dd) |
| `min_qty` | integer | NO | — | 수량구간하한 |
| `max_qty` | integer | YES | — | 수량구간상한 (NULL = 상한 없는 최상위 구간) |
| `dsc_typ_cd` | varchar(50) | YES | — | 할인유형코드 (→ DSC_TYPE.*) |
| `dsc_rate` | numeric(5,2) | YES | — | 할인율 (퍼센트; amt와 XOR) |
| `dsc_amt` | numeric(12,2) | YES | — | 할인액 (절대값; rate와 XOR) |
| `note` | varchar(500) | YES | — | |
| `reg_dt` | timestamp | NO | `now()` | |
| `upd_dt` | timestamp | YES | — | |

- **PK:** `pk_t_dsc_discount_details (dsc_tbl_cd, apply_ymd, min_qty)`
- **FK:**
  - `fk_dsc_discount_details_dsc_tbl_cd`: `dsc_tbl_cd` → `t_dsc_discount_tables(dsc_tbl_cd)` — **ON UPDATE CASCADE / ON DELETE CASCADE** (헤더를 삭제하면 그에 딸린 구간이 모두 삭제됨).
  - `fk_dsc_discount_details_dsc_typ_cd`: `dsc_typ_cd` → `t_cod_base_codes(cod_cd)` — ON UPDATE CASCADE / ON DELETE RESTRICT.
- **CHECK:** `ck_t_dsc_discount_details_amt_excl`: `(dsc_rate IS NULL) OR (dsc_amt IS NULL)` — rate/amt 중 최대 하나만 설정 가능. **주의: 이것은 NAND이지 엄격한 XOR가 아니다** — *둘 다* NULL(할인값이 없는 행)도 허용한다. 값이 비어 있지 않음은 스키마가 강제하지 않으므로, 로더가 정확히 하나만 채워지도록 보장해야 한다.
- **인덱스:**
  - `pk_t_dsc_discount_details` (유니크) on `(dsc_tbl_cd, apply_ymd, min_qty)`
  - `ix_t_dsc_discount_details_tbl_apply` on `(dsc_tbl_cd, apply_ymd DESC)` — 최신 유효일자 조회
  - `ix_t_dsc_discount_details_dsc_typ_cd` on `(dsc_typ_cd)`

**구간 의미:** 하나의 `(dsc_tbl_cd, apply_ymd)` 그룹이 N개의 행을 담으며, 각 행은 rate XOR amount를 가진 `[min_qty, max_qty]` 구간이다. 최상위 구간은 `max_qty = NULL`이다. `apply_ymd`로 시계열 처리(유효일자 기준, 주문일자 이하의 최신값이 적용됨).

---

## 3. `t_dsc_grade_discount_rates` — 등급별할인율, 시계열 · 0행

> 수량 구간이 아니다 — 고객등급 × 카테고리 할인이다. 할인 도메인과 rate/amt XOR 패턴을 공유하므로 문서화하지만, 수량구간 매핑은 이 테이블을 **로드하지 않는다**.

| Column | Type | Null | Default | 비고 |
|--------|------|:----:|---------|------|
| `grade_cd` | varchar(50) | NO | — | 등급코드 (→ CUS_GRADE.*) |
| `cat_cd` | varchar(50) | NO | — | 카테고리코드 (→ t_cat_categories) |
| `apply_ymd` | varchar(10) | NO | — | 적용일자 (시계열) |
| `dsc_typ_cd` | varchar(50) | YES | — | 할인유형코드 (→ DSC_TYPE.*) |
| `dsc_rate` | numeric(5,2) | YES | — | 할인율 |
| `dsc_amt` | numeric(12,2) | YES | — | 할인액 |
| `note` | varchar(500) | YES | — | |
| `reg_dt` | timestamp | NO | `now()` | |
| `upd_dt` | timestamp | YES | — | |

- **PK:** `pk_t_dsc_grade_discount_rates (grade_cd, cat_cd, apply_ymd)`
- **FK:**
  - `grade_cd` → `t_cod_base_codes(cod_cd)` — ON UPDATE CASCADE / **ON DELETE CASCADE**
  - `cat_cd` → `t_cat_categories(cat_cd)` — ON UPDATE CASCADE / **ON DELETE CASCADE**
  - `dsc_typ_cd` → `t_cod_base_codes(cod_cd)` — ON UPDATE CASCADE / ON DELETE RESTRICT
- **CHECK:** `ck_t_dsc_grade_dsc_rates_amt_excl`: `(dsc_rate IS NULL) OR (dsc_amt IS NULL)` (동일한 NAND 유의사항).
- **인덱스:** PK 유니크; `ix_..._cat_cd (cat_cd)`; `ix_..._dsc_typ_cd (dsc_typ_cd)`; `ix_..._grd_cat_apply (grade_cd, cat_cd, apply_ymd DESC)`.

---

## 4. `t_prd_product_discount_tables` — 상품별할인테이블 (상품 → 구간 테이블 적용 범위) · 0행

| Column | Type | Null | Default | 비고 |
|--------|------|:----:|---------|------|
| `prd_cd` | varchar(50) | NO | — | 상품코드 (→ t_prd_products) |
| `dsc_tbl_cd` | varchar(50) | NO | — | 할인테이블코드 (→ t_dsc_discount_tables) |
| `apply_bgn_ymd` | varchar(10) | NO | — | 적용시작일자 |
| `note` | varchar(500) | YES | — | |
| `reg_dt` | timestamp | NO | `now()` | |
| `upd_dt` | timestamp | YES | — | |

- **PK:** `t_prd_product_discount_tables_pkey (prd_cd, dsc_tbl_cd, apply_bgn_ymd)`
- **FK:**
  - `prd_cd` → `t_prd_products(prd_cd)` — ON UPDATE CASCADE / ON DELETE RESTRICT
  - `dsc_tbl_cd` → `t_dsc_discount_tables(dsc_tbl_cd)` — ON UPDATE CASCADE / ON DELETE RESTRICT
- **CHECK:** 없음.
- **인덱스:** PK 유니크; `ix_t_prd_dsc_tbls_dsc_tbl_cd (dsc_tbl_cd)`.

**적용 범위는 카테고리 단위가 아니라 상품 단위다.** 할인 테이블은 `prd_cd`에 붙는다. 여기에는 카테고리 컬럼이 없다. 구간 테이블을 카테고리 전체(예: 아크릴 전부)에 적용하려면 로더가 카테고리 서브트리 → 상품 목록으로 전개하여(`target-keys.md` 참고) 상품마다 한 행씩 삽입해야 한다. (카테고리 단위 할인은 `t_dsc_grade_discount_rates`에만 존재하며, 이는 등급 기반이지 수량구간이 아니다.)

---

## 5. `t_prd_product_bundle_qtys` — 상품별묶음수 (묶음수량 가격 입력) · 4행

| Column | Type | Null | Default | 비고 |
|--------|------|:----:|---------|------|
| `prd_cd` | varchar(50) | NO | — | 상품코드 (→ t_prd_products) |
| `bdl_qty` | integer | NO | — | 묶음수 |
| `bdl_unit_typ_cd` | varchar(50) | YES | — | 묶음단위유형코드 (→ QTY_UNIT.* — 플래그 참고) |
| `dflt_yn` | char(1) | NO | — | 기본여부 |
| `disp_seq` | integer | YES | — | 표시순서 |
| `reg_dt` | timestamp | NO | `now()` | |
| `upd_dt` | timestamp | YES | — | |

- **PK:** `t_prd_product_bundle_qtys_pkey (prd_cd, bdl_qty)`
- **FK:**
  - `prd_cd` → `t_prd_products(prd_cd)` — ON UPDATE CASCADE / ON DELETE RESTRICT
  - `bdl_unit_typ_cd` → `t_cod_base_codes(cod_cd)` — ON UPDATE CASCADE / ON DELETE RESTRICT
- **CHECK:** `dflt_yn IN ('Y','N')`.
- **인덱스:** PK 유니크; `ix_t_prd_product_bdl_qtys_bdl_unit_typ_cd (bdl_unit_typ_cd)`.

**현재 데이터 (4행 전체):**
| prd_cd | bdl_qty | bdl_unit_typ_cd | dflt_yn |
|--------|--------:|-----------------|:-------:|
| PRD_000097 (떡메모지) | 50 | QTY_UNIT.03 (권) | Y |
| PRD_000097 (떡메모지) | 100 | QTY_UNIT.03 (권) | Y |
| PRD_000182 | 50 | QTY_UNIT.03 (권) | Y |
| PRD_000182 | 100 | QTY_UNIT.03 (권) | Y |

> 묶음수량을 사용하는 상품은 단 2개뿐이다. `bdl_unit_typ_cd`는 `QTY_UNIT.*` 코드 패밀리로 해석된다 — 전용 묶음단위 코드 그룹은 없다.
> **데이터 품질 주의:** 각 상품의 두 `bdl_qty` 행 모두 `dflt_yn='Y'`다(상품당 기본값 2개). 스키마는 단일 기본값을 강제하지 않으므로, 매핑/로더가 이것이 의도된 것인지 판단해야 한다.

---

## 테이블 간 로드 순서 (FK 안전)

`t_cod_base_codes` (존재) → `t_cat_categories` / `t_prd_products` (존재) → **`t_dsc_discount_tables`** → **`t_dsc_discount_details`** → **`t_prd_product_discount_tables`**. 등급 할인율: 코드 + 카테고리 → **`t_dsc_grade_discount_rates`**. 묶음수량은 기존 상품 + 코드에만 의존한다.
