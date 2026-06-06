# 적재 실행 매니페스트 — round-5 가격(t_prc_*) (`_exec_price/`)

> round-4 GO 가격 적재본(`09_load/_assembled_price/`, 2,320행)을 멱등 실행 SQL + 로더로 완성.
> 상세 실행법·충돌키·제외는 본 디렉터리 `README.md`와 동일 권위. 본 매니페스트는 실행 순서 요약본.
> 권위: `docs/goal-2026-06-06-02.md` · `_assembled_price/load-manifest.md`(GO) ·
> `03_validation/price-load-validation-final.md`(GO) · `../_exec/constraints-live.md`(충돌키 근거).

## 실행 순서 (FK 위상정렬) + ON CONFLICT 충돌키

| 단계 | 파일 | 대상 테이블 | 행수 | ON CONFLICT 키 | 백킹 라이브 제약 |
|------|------|------------|------|----------------|-----------------|
| 00 | `00_prc_component_type.sql` | `t_cod_base_codes` | 1 | `(cod_cd)` | PK `pk_t_cod_base_codes` |
| 01 | `01_prc_price_formulas.sql` | `t_prc_price_formulas` | 10 | `(frm_cd)` | PK `pk_t_prc_price_formulas` |
| 02 | `02_prc_price_components.sql` | `t_prc_price_components` | 143 | `(comp_cd)` | PK `pk_t_prc_price_components` |
| 03 | `03_prc_formula_components.sql` | `t_prc_formula_components` | 13 | `(frm_cd, comp_cd)` | PK `t_prc_formula_components_pkey` |
| 04 | `04_prc_component_prices.sql` | `t_prc_component_prices` | 2,108 | `(comp_price_id)` ※ | PK `t_prc_component_prices_pkey` |
| 05 | `05_prd_product_price_formulas.sql` | `t_prd_product_price_formulas` | 45 | `(prd_cd, frm_cd)` | PK `t_prd_product_price_formulas_pkey` |

총 INSERT 2,320. 상위 래퍼 = `apply.sql`(`BEGIN; \i 00 … \i 05`).

※ **04 충돌키 = PK comp_price_id** (자연키 unique idx `ux_t_prc_comp_prices_nat_key`가 NULLS
DISTINCT라 NULL 포함 행에서 멱등 미보장 → PK 채택). 상세 분석 `../_exec/constraints-live.md §2`.

## 멱등·원자·재현

- 전 INSERT `ON CONFLICT (PK) DO NOTHING`. 충돌키=라이브 PK(추측 0).
- `apply.sql` 단일 `BEGIN`+`ON_ERROR_STOP=1`. 부분커밋 경로 0. COMMIT/ROLLBACK은 로더 주입.
- `gen_load_sql.py` 생성(손편집 0)·행수 어서트(2,320)·`*.provenance.csv`.

## 제외 (재포장 금지)

- component_prices placeholder siz 2,697행(siz_cd=`SIZ_PENDING%`, 후니 등록 대기).
- 박 시트 2단 룩업 GAP 1건(ddl-proposer).

## 실행법 / 승인

`./apply.sh`(기본 DRY-RUN 롤백) · `./apply.sh commit`(인간 승인). `python3 gen_load_sql.py`(재생성).
인간 승인 체크포인트: 라이브 DRY-RUN 직전 · 코드행 등록(`PRC_COMPONENT_TYPE.06`) · 실제 COMMIT.
검증 = `dbm-validator` R1~R6 → `03_validation/load-execution-gate.md`. 자기승인 금지.
