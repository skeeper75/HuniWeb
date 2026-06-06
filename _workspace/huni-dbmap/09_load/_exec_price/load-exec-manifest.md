# 적재 실행 매니페스트 — round-5 가격(t_prc_*) (`_exec_price/`)

> round-4 GO 가격 적재본(`09_load/_assembled_price/`)을 멱등 실행 SQL + 로더로 완성.
> **siz 교정 통합(2026-06-06): GUK4 870 + GP원형35mm 10 = 880행을 차단→적재가능으로 승격**
> (기존 라이브 siz 재사용·무발명). 총 적재 2,320→**3,200**, component_prices 2,108→**2,988**,
> 차단 2,697→**1,817**. 상세 실행법·충돌키·제외는 본 디렉터리 `README.md`와 동일 권위.
> 권위: `docs/goal-2026-06-06-02.md` · `02_mapping/price-siz-mapping-inspection.md`(siz 교정 §1-1/§1-4) ·
> `_assembled_price/load-manifest.md`(GO) · `03_validation/price-load-validation-final.md`(GO) ·
> `../_exec/constraints-live.md`(충돌키 근거).

## 실행 순서 (FK 위상정렬) + ON CONFLICT 충돌키

| 단계 | 파일 | 대상 테이블 | 행수 | ON CONFLICT 키 | 백킹 라이브 제약 |
|------|------|------------|------|----------------|-----------------|
| 00 | `00_prc_component_type.sql` | `t_cod_base_codes` | 1 | `(cod_cd)` | PK `pk_t_cod_base_codes` |
| 01 | `01_prc_price_formulas.sql` | `t_prc_price_formulas` | 10 | `(frm_cd)` | PK `pk_t_prc_price_formulas` |
| 02 | `02_prc_price_components.sql` | `t_prc_price_components` | 143 | `(comp_cd)` | PK `pk_t_prc_price_components` |
| 03 | `03_prc_formula_components.sql` | `t_prc_formula_components` | 13 | `(frm_cd, comp_cd)` | PK `t_prc_formula_components_pkey` |
| 04 | `04_prc_component_prices.sql` | `t_prc_component_prices` | 2,988 ※siz | `(comp_price_id)` ※ | PK `t_prc_component_prices_pkey` |
| 05 | `05_prd_product_price_formulas.sql` | `t_prd_product_price_formulas` | 45 | `(prd_cd, frm_cd)` | PK `t_prd_product_price_formulas_pkey` |

총 INSERT **3,200**. 상위 래퍼 = `apply.sql`(`BEGIN; \i 00 … \i 05`).

※ **04 충돌키 = PK comp_price_id** (자연키 unique idx `ux_t_prc_comp_prices_nat_key`가 NULLS
DISTINCT라 NULL 포함 행에서 멱등 미보장 → PK 채택). 상세 분석 `../_exec/constraints-live.md §2`.

※siz **04 = 2,988 (즉시 2,108 + siz 교정 880)**. 교정분 = `siz_cd` 1:1 치환만
(GUK4 870→`SIZ_000499`[316x467], GP원형35mm 10→`SIZ_000422`[원형35x35] — 둘 다 라이브
`t_siz_sizes` 실존·`del_yn=N`, FK `fk_prc_comp_prices_siz_cd` PASS, 무발명/search-before-mint).
교정 행은 `note`에 `[siz-corrected: <placeholder>→<siz_cd>]` 프로비넌스 접두 + SQL `-- src:` 주석에
`siz:<placeholder>-><siz_cd>` 표기. 잔여 placeholder 1,817행은 차단 유지(`_assembled_price/blocked-and-gaps.md §A`).
04는 `gen_load_sql.py`가 원천 `02_mapping/load_price/t_prc_component_prices.csv`에서 직접
파티셔닝(real 1,313 + null 795 + 교정 880 = 2,988, 차단 1,817 제외)하므로 재현적(손편집 0).

## 멱등·원자·재현

- 전 INSERT `ON CONFLICT (PK) DO NOTHING`. 충돌키=라이브 PK(추측 0).
- `apply.sql` 단일 `BEGIN`+`ON_ERROR_STOP=1`. 부분커밋 경로 0. COMMIT/ROLLBACK은 로더 주입.
- `gen_load_sql.py` 생성(손편집 0)·행수 어서트(2,320)·`*.provenance.csv`.

## 제외 (재포장 금지)

- component_prices 잔여 placeholder siz **1,817행**(siz_cd=`SIZ_PENDING%`, 후니 등록 대기).
  내역: 3JEOL 304 + STK 456 + POSTER 680 + ACRYL 237 + GP(원형35mm 제외) 100 + ENV 40.
  (GUK4 870 + GP원형35mm 10 = 880행은 siz 교정으로 적재 승격됨 — 더이상 차단 아님.)
- 박 시트 2단 룩업 GAP 1건(ddl-proposer).

## 실행법 / 승인

`./apply.sh`(기본 DRY-RUN 롤백) · `./apply.sh commit`(인간 승인). `python3 gen_load_sql.py`(재생성).
인간 승인 체크포인트: 라이브 DRY-RUN 직전 · 코드행 등록(`PRC_COMPONENT_TYPE.06`) · 실제 COMMIT.
검증 = `dbm-validator` R1~R6 → `03_validation/load-execution-gate.md`. 자기승인 금지.
