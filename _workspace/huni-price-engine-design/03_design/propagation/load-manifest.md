# 적재 매니페스트 — 박류 동형 전파 (6상품)

> dbm-load-builder · 2026-06-30 · t_* 화이트리스트 충족(t_prc_*·t_prd_*)·FK 위상정렬·DB 미적재(COMMIT 0).
> 생성기 `gen_foil_prop.py`(결정론·재현가능). 검증 위임 → dbm-validator R1~R6.

## 적재 순서 (FK 위상정렬)

| # | 대상 t_* 테이블 | 소스 | 행수 | FK 엣지(위치 고정 사유) | 즉시적재 | 차단 | GAP |
|---|---|---|---|---|---|---|---|
| 00 | (코드행 선적재) | — | 0 | PRICE_TYPE.03·PRC_COMPONENT_TYPE.05/.01 라이브 실재 → 선적재 불요 | — | — | — |
| 01 | `t_prc_price_components` | `foil-prop-body.sql` STEP1 | **3** | (없음·루트) — component_prices·formula_components의 부모 | 3 | 0 | 0 |
| 02 | `t_prc_component_prices` | STEP2 | **7,168** | `comp_cd→price_components`(step01)·`proc_cd→t_proc_processes`(037~044 실재) | 7,168 | 0 | 0 |
| 03 | `t_prc_price_formulas` | STEP3 | **5** | (없음·루트) — formula_components·product_price_formulas의 부모 | 5 | 0 | 0 |
| 04 | `t_prc_formula_components` | STEP4 | **38** | `frm_cd→price_formulas`(step03)·`comp_cd→price_components`(박:step01·base:라이브 실재) | 38 | 0 | 0 |
| 05 | `t_prd_product_price_formulas` | STEP5 | **6** | `frm_cd→price_formulas`(step03)·`prd_cd→t_prd_products`(라이브 실재) | 6 | 0 | 0 |

**합계: 7,220 INSERT · 즉시적재 7,220 · 차단 0 · GAP 0.**

## step01 — 대형 박 comp 3종

| comp_cd | prc_typ | use_dims | search-before-mint |
|---|---|---|---|
| COMP_FOIL_SETUP_LARGE | PRICE_TYPE.03 | `["proc_cd","siz_width","siz_height"]` | 라이브 `COMP_FOIL%LARGE%` = 0건 확인 |
| COMP_FOIL_PROC_LARGE_STD | PRICE_TYPE.03 | `["proc_cd","siz_width","siz_height","min_qty"]` | 동일 |
| COMP_FOIL_PROC_LARGE_SPECIAL | PRICE_TYPE.03 | `["proc_cd","siz_width","siz_height","min_qty"]` | 동일 |

## step02 — 대형 단가행 7,168 (등록색상만)

| comp_cd | 분해 | 행수 |
|---|---|---|
| COMP_FOIL_SETUP_LARGE | 64 면적셀(8×8) × 8 등록색상 | 512 |
| COMP_FOIL_PROC_LARGE_STD | 64셀 × 13 수량밴드 × 4 STD 등록색상(038·039·041·043) | 3,328 |
| COMP_FOIL_PROC_LARGE_SPECIAL | 64셀 × 13밴드 × 4 SPECIAL 등록색상(037·040·042·044) | 3,328 |

단가 verbatim = `price-foil-large-l1.csv` B01(동판)·B03(일반)·B05(특수). 미등록 색상(048·049·046·047) 단가행 미생성.

## step03~05 — 분기 공식 + 바인딩 (per-product)

| prd_cd | base 공식 | 분기 공식 | base 분기 여부 | formula_components | 바인딩(apply_bgn_ymd=2026-07-01) |
|---|---|---|---|---|---|
| PRD_000034 펄명함 | PRF_NAMECARD_PEARL | **PRF_NAMECARD_PEARL_FOIL** | ✅ 분기 | base 2 + 소형박 3 = 5 | rebind 034만 |
| PRD_000029 3단접지 | PRF_DGP_E | **PRF_DGP_E_FOIL** | ✅ 분기(027과 공유) | base 9 + 대형박 3 = 12 | rebind 029만 |
| PRD_000027 2단접지 | PRF_DGP_E | PRF_DGP_E_FOIL(029 분기 재사용) | (공유 분기) | (위와 동일) | rebind 027만 |
| PRD_000042 쿠폰 | PRF_DGP_A(10상품 공유) | **PRF_DGP_A_FOIL** | ✅ 분기 | base 10 + 대형박 3 = 13 | rebind 042만(나머지 9상품 base 유지) |
| PRD_000069 무선책자 | PRF_BIND_MUSEON | **PRF_BIND_MUSEON_FOIL** | ✅ 분기 | base 1 + 대형박 3 = 4 | rebind 069만 |
| PRD_000070 PUR책자 | PRF_BIND_PUR | **PRF_BIND_PUR_FOIL** | ✅ 분기 | base 1 + 대형박 3 = 4 | rebind 070만 |

**분기 공식 5종**(027·029 공유 PRF_DGP_E_FOIL 1벌). formula_components 합계 = 5+12+13+4+4 = **38행**.
★형제 공유공식 보호: PRF_DGP_E(027/029 외 형제)·PRF_DGP_A(042 외 9상품)·PRF_NAMECARD_PEARL(034 외)·PRF_BIND_* 전부 base 행 미터치, 2026-06-01/06-27 바인딩 보존(엔진 최신 2026-07-01 분기 선택).

## 멱등/검증

- 멱등: NOT EXISTS NULL-safe(nat-key NULLS DISTINCT 대응)·재실행 0행.
- 골든 재계산 10/10 PASS(`golden_recalc_large.py`): G-F1 138,000·G-F2 168,000·G-F3 66,000·G-F7 314,000·G-F6 off-grid 138,000·.03 FLAT off-band·박 미선택 0·미등록색상 0.
- 라이브 DRY-RUN(완주·exit 0·`foil-prop-dryrun-result.txt`): PASS1 카운트 512/3328/3328·PASS2 delta 전부 0 → **IDEMPOTENT: PASS**·제약위반 0·ROLLBACK(무변경).
- DDL 불요·코드행 선적재 불요.
