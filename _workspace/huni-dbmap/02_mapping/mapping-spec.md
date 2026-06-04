# 매핑 명세 — 수량 구간 할인 (FINAL · Round 1e)

Excel 할인 그룹 **7종** 전체를 DB 할인 구간 패턴으로 매핑하고 `load/` 아래에 적재 가능한 CSV를
산출한다. **범위: 시트 우선 — 라이브 DB에 기록하지 않음.** 적재는 이후 별도로 승인되는
기계적 단계다.

권위 순서: 라이브 DB 스키마 > `00_schema/columns.csv` + `discount-domain-detail.md` +
`code-values.md` > 본 명세. Excel 원본 셀 > `01_excel/discount-brackets.csv`.
범위/상품 해소 권위: `00_schema/product-resolution.md` + `00_schema/resolved-prd.csv`.

## CONFIRMED 최종 결정 (이번 적재에 적용)

- **D1 (요율 단위) — CONFIRMED PERCENT.** `dsc_rate` = `rate_pct` (예: 0.05→5.00, 0.5→50.00).
  `dsc_amt` = 항상 NULL. `dsc_typ_cd` = 모든 행에 대해 `DSC_TYPE.01` (정률).
- **D3 (최상위 구간 max) — CONFIRMED OPEN.** 모든 그룹의 최상위 구간 → `max_qty` = 빈값 (NULL).
  시트의 `10000`/`까지` 표시값은 제거한다.
- **D5 (squishy 첫 구간) — CONFIRMED SINGLE-QTY.** `min_qty=1, max_qty=1, rate=0.00`.
- **범위 (7개 테이블 + 상품 링크) — CONFIRMED** 아래 표대로.
- **use_yn — CONFIRMED 'Y'** 7개 헤더 전체.
- **apply_ymd / apply_bgn_ymd — 플레이스홀더 `20260601`** (YYYYMMDD). DESIGN DECISIONS D2 참고.

## 빈 문자열 = NULL 규약

세 개의 적재 CSV 전체에서 **빈 필드 = SQL NULL**. 구체적으로:
- `t_dsc_discount_details.max_qty` 빈값 → NULL (개방형 최상위 구간).
- `t_dsc_discount_details.dsc_amt` 항상 빈값 → NULL (요율 경로; NAND CHECK 충족).
- `note` 빈값 → NULL.
로더는 반드시 `""` → NULL로 변환해야 한다 (리터럴 빈 문자열이 아님). `max_qty`/`dsc_amt`는
숫자형이므로 빈 문자열은 타입 캐스트에 실패하기 때문이다.

---

## 7개 그룹 → 테이블 (범위 + 링크 소스)

| group | dsc_tbl_cd | 구간 소스 (discount-brackets.csv) | #brkt | 링크 소스 (resolved-prd.csv) | #prd |
|-------|------------|--------------------------------------|:-----:|---------------------------------|:----:|
| acrylic_general   | `DSC_ACR_QTY`     | acrylic_general 6br        | 6 | category_wide, 카라비너 제외        | 11 |
| acrylic_carabiner | `DSC_ACRCARA_QTY` | acrylic_carabiner 3br (0/10/20) | 3 | PRD_000166 only (general에서 제외) | 1 |
| fabric            | `DSC_FABRIC_QTY`  | pouch_eco 5br              | 5 | category_wide, 부자재 PRD_000280 제외 | 50 |
| stationery        | `DSC_STAT_QTY`    | stationery 5br            | 5 | master_column                   | 6 |
| goods_a           | `DSC_GOODSA_QTY`  | goods_a 5br               | 5 | master_column                   | 15 |
| goods_b           | `DSC_GOODSB_QTY`  | goods_b 3br               | 3 | master_column                   | 11 |
| squishy           | `DSC_SQUISHY_QTY` | squishy 8br               | 8 | master_column                   | 5 |
| **total**         | 7 headers          | —                         | **35** | —                            | **99** |

---

## 대상 테이블 1 — `t_dsc_discount_tables` (헤더) · 7행

| DB 컬럼 | 소스 | 변환 / 값 | 예시 |
|-----------|--------|-------------------|---------|
| `dsc_tbl_cd` | 자체 생성 코드 (dsc-code-proposals.md 참고) | 명명 `DSC_<SCOPE>_QTY` | `DSC_ACR_QTY` |
| `dsc_tbl_nm` | 블록 제목 / 범위 텍스트 | 한국어 이름 그대로, ≤100자 | `아크릴 카테고리 수량별 구간할인` |
| `note` | 범위 텍스트 (유용한 경우) | 짧은 범위 설명 또는 NULL | `아크릴 카테고리 전체(아크릴카라비너 제외) 적용` |
| `use_yn` | 설계 기본값 | `'Y'` (CHECK `IN ('Y','N')`) | `Y` |
| `reg_dt` | — | DB 기본값 `now()` — CSV에서 생략 | — |
| `upd_dt` | — | NULL — CSV에서 생략 | — |

준수 제약: PK `(dsc_tbl_cd)` 유일 (7개 distinct); `use_yn IN ('Y','N')`;
`dsc_tbl_nm` 최장 = `굿즈상품 A타입 수량별 구간할인` (≤100). `reg_dt`/`upd_dt` 제외 (DB 기본값).

---

## 대상 테이블 2 — `t_dsc_discount_details` (구간) · 35행

| DB 컬럼 | 소스 | 변환 | 적용 예시 |
|-----------|--------|-----------|----------------|
| `dsc_tbl_cd` | group → 코드 | 범위 표대로 | `DSC_ACR_QTY` |
| `apply_ymd` | 플레이스홀더 | `20260601` (varchar(10), YYYYMMDD) | `20260601` |
| `min_qty` | `min_qty` | integer, 그대로 | `50` |
| `max_qty` | `max_qty` | integer; **빈값 (최상위 구간) → NULL** | `99`; 최상위 행 → `` (NULL) |
| `dsc_typ_cd` | 설계 | 항상 `DSC_TYPE.01` (정률) | `DSC_TYPE.01` |
| `dsc_rate` | `rate_pct` | 퍼센트 → numeric(5,2), 소수 2자리 | `0.05`→`5.00`; `0.5`→`50.00` |
| `dsc_amt` | — | 항상 NULL (빈값) | `` (NULL) |
| `note` | — | NULL, 단 squishy qty=1 행은 `단일수량 구간(qty=1)` 보유 | |

### 변환 규칙 (테스트 가능)

1. **범위 파싱.** `discount-brackets.csv`는 이미 `"50~99"` → `min_qty=50, max_qty=99`로 사전 파싱됨.
   본 명세는 파싱된 컬럼을 직접 소비한다 (재파싱 없음). 개방형 행은 `max_qty`가 빈값이다.
2. **퍼센트.** `dsc_rate = rate_pct`를 소수 2자리로 렌더링. `rate_raw` (분수)는 출처 추적용으로만 쓰고
   적재하지 않는다. 적용: pouch 50~99 `rate_pct=5.0` → `dsc_rate=5.00`; acrylic 최상위 `rate_pct=50.0` →
   `50.00`. 전체 그룹 최대값 = `50.00` ≤ numeric(5,2) 최대값 (999.99) — 들어맞음.
3. **개방형 최상위 구간.** 각 그룹의 최고 `min_qty` 행 → `max_qty = NULL` (CSV 빈 필드).
   적용: acrylic `1000,` → `min_qty=1000, max_qty=NULL`; goods_b `500,` → `500, NULL`.
4. **단일수량 구간 (squishy).** squishy 첫 행 `1,1` → `min_qty=1, max_qty=1, dsc_rate=0.00`.
   이는 폭 1의 닫힌 밴드 (qty가 정확히 1)이며 개방형이 아니다. 설명용 `note`를 보유한다.
5. **0% 첫 구간.** 모든 그룹의 첫 구간은 `rate_pct=0.0` → `dsc_rate=0.00`
   (실제 0% 단계, NULL 아님). `dsc_amt`는 여전히 NULL → NAND 충족, 정확히-하나-채움이 유지됨
   (요율이 0.00으로 채워짐).

### 그룹별 구간 상세 (적재됨)

- **DSC_ACR_QTY (6):** 1–49=0 / 50–99=10 / 100–299=20 / 300–499=30 / 500–999=40 / 1000–NULL=50
- **DSC_ACRCARA_QTY (3):** 1–49=0 / 50–99=10 / 100–NULL=20
- **DSC_FABRIC_QTY (5):** 1–49=0 / 50–99=5 / 100–499=10 / 500–999=15 / 1000–NULL=20
- **DSC_STAT_QTY (5):** 1–49=0 / 50–99=5 / 100–499=10 / 500–999=15 / 1000–NULL=20
- **DSC_GOODSA_QTY (5):** 1–49=0 / 50–99=5 / 100–499=10 / 500–999=15 / 1000–NULL=20
- **DSC_GOODSB_QTY (3):** 1–99=0 / 100–499=5 / 500–NULL=10
- **DSC_SQUISHY_QTY (8):** 1–1=0 / 2–9=10 / 10–29=15 / 30–49=20 / 50–99=25 / 100–499=30 / 500–999=40 / 1000–NULL=50

준수 제약:
- **PK `(dsc_tbl_cd, apply_ymd, min_qty)`** — 35행 모두 distinct (검증됨; 테이블당 단일
  apply_ymd, 각 테이블 내 distinct min_qty).
- **CHECK `(dsc_rate IS NULL) OR (dsc_amt IS NULL)` (NAND)** — 모든 행이 `dsc_rate`를 설정하고
  `dsc_amt`는 NULL → 충족. 로더는 스키마가 허용하지만 우리가 금지하는 둘-다-NULL 함정을 피해
  **정확히 하나**(요율)만 채워지도록 보장한다.
- **FK `dsc_tbl_cd` → tables** — 모든 코드가 테이블 1에 존재 (적재 순서 헤더 우선).
- **FK `dsc_typ_cd` → t_cod_base_codes** — `DSC_TYPE.01` 존재 (code-values.md에서 검증).
- **numeric(5,2)** — 모든 요율 ≤ 50.00, 정수부 + 소수 2자리 → 들어맞음.

---

## 대상 테이블 3 — `t_prd_product_discount_tables` (상품 링크) · 99행

| DB 컬럼 | 소스 | 변환 | 예시 |
|-----------|--------|-----------|---------|
| `prd_cd` | `resolved-prd.csv` prd_cd | 그대로 | `PRD_000160` |
| `dsc_tbl_cd` | group → 코드 | 범위 표대로 | `DSC_ACR_QTY` |
| `apply_bgn_ymd` | 플레이스홀더 | `20260601` (varchar(10), YYYYMMDD) | `20260601` |
| `note` | — | NULL | |
| `reg_dt` / `upd_dt` | — | DB 기본값 / NULL — 생략 | — |

`resolved-prd.csv`로부터 기계적으로 생성 ((prd_cd, group)당 한 행), group→코드는 위 범위 표대로.
그룹별 건수: ACR 11 · ACRCARA 1 · FABRIC 50 · STAT 6 · GOODSA 15 ·
GOODSB 11 · SQUISHY 5 = **99**.

**PRD_000166 (아크릴카라비너)는 카라비너 전용:** 한 번만 등장하여 `DSC_ACRCARA_QTY`에 연결되고,
`DSC_ACR_QTY`에는 **부재** (프로그래밍적으로 검증). 이중 할인 없음. 11개 ACR 링크는
PRD_000160–165, 167–171 (166 제외). 50개 FABRIC 링크는 PRD_000230–279 (부자재 PRD_000280
제외).

준수 제약:
- **PK `(prd_cd, dsc_tbl_cd, apply_bgn_ymd)`** — 99행 모두 distinct (검증됨).
- **FK `prd_cd` → t_prd_products** — 99개 prd_cd 전부 resolved-prd.csv에서 유래하며, 이는
  라이브 `t_prd_products`에 대해 해소됨 (product-resolution.md 기준 미해소 0건).
- **FK `dsc_tbl_cd` → tables** — 7개 코드 모두 테이블 1에 존재.

---

## 적재 순서 (FK-safe)

```
1. t_dsc_discount_tables            (7 headers)   — FK 의존 없음
2. t_dsc_discount_details           (35 brackets) — FK dsc_tbl_cd → table 1; FK dsc_typ_cd → t_cod_base_codes (존재)
3. t_prd_product_discount_tables    (99 links)    — FK prd_cd → t_prd_products (존재); FK dsc_tbl_cd → table 1
```

이유: details와 links 모두 FK `dsc_tbl_cd → t_dsc_discount_tables`를 갖고 있으므로 헤더 테이블이
반드시 먼저 적재되어야 한다. details와 links 사이에는 FK가 없어 헤더 이후 어느 순서로든 적재 가능하다.
`t_cod_base_codes` (DSC_TYPE.01)와 `t_prd_products`는 이미 존재한다.

`reg_dt`는 DB 기본값 (`now()`); `upd_dt`는 NULL로 둔다 — 둘 다 모든 적재 CSV에서 생략한다.

---

## 그룹별 건수 (요약)

| group | header | details | links |
|-------|:------:|:-------:|:-----:|
| acrylic_general   | 1 | 6 | 11 |
| acrylic_carabiner | 1 | 3 | 1  |
| fabric            | 1 | 5 | 50 |
| stationery        | 1 | 5 | 6  |
| goods_a           | 1 | 5 | 15 |
| goods_b           | 1 | 3 | 11 |
| squishy           | 1 | 8 | 5  |
| **total**         | **7** | **35** | **99** |

---

## DESIGN DECISIONS — 잔여 (사용자 확인 필요)

- **D2 (적용일) — OPEN.** `apply_ymd` (details)와 `apply_bgn_ymd` (links)는 플레이스홀더
  `20260601`. 스키마상 둘 다 `varchar(10)` 확인됨; `20260601` (8자 YYYYMMDD) 들어맞음. **실제
  오픈 일자가 필요.** 모든 행이 한 날짜를 공유하므로 날짜 확정 시 전역 치환으로 충분하다. 그룹마다
  오픈 일자가 다르다면 그룹별로 날짜를 설정해야 한다.
- **D-INCLUSIVITY — OPEN (저위험).** 구간 경계는 **포함** (`min ≤ qty ≤ max`)으로 가정. 7개 그룹
  전체에서 구간이 빈틈/중복 없이 연속이므로 (예: 49→50, 99→100) 포함 경계를 강하게 시사하지만,
  가격 엔진의 비교 연산자는 본 하네스 범위 밖이다. 엔진이 `[min, max]`를 포함으로 처리하는지
  확인할 것 (특히 squishy 1–1 밴드와 각 개방형 `min..∞` 최상위 구간).
- **D-RESIDUAL (note 컬럼) — OPEN (외형).** `dsc_tbl_nm`/`note` 한국어 텍스트는 블록 제목 +
  범위 텍스트에서 설정. 데이터 위험 없음; 관리자 표시용 문구가 수용 가능한지 확인할 것.

### CONFIRMED (이번 라운드 해소 — 조치 불필요)

- D1 요율 단위 = PERCENT · D3 최상위 max = NULL · D5 squishy 첫 구간 = 단일수량 · 7개 테이블 범위 ·
  use_yn='Y' · 카라비너 general과 상호 배타 · 부자재 PRD_000280 fabric에서 제외.
