# CPQ 컨피규레이터 — 라이브 스키마 정본 + 설계 정합 검증 (2026-06-06)

> 후니 railway DB(PostgreSQL 18) **라이브 직접 추출** 기준. CPQ 설계(`10_configurator/cpq-design.md`)가 **실제 구현됨**을 확인하고, 설계/검증 문서와 라이브의 차이를 판정한다.
> [HARD] 추출 = read-only. 식별자/컬럼/코드 영어, 설명 한국어. 라이브 실재만 권위(추출본 stale 주의). 원시 덤프 = `_live-schema-dump-260606.txt`(t_* 34테이블 컬럼·제약·트리거).

## 0. 한 줄 현황

라이브 DB는 **44테이블**(Django 10 + t_* 도메인 34). 이전 추출(2026-06-03) 이후 **CPQ 설계가 라이브로 구현**됨 — 옵션 레이어 3 + 템플릿 2 + 제약 1 + 카테고리 1 = **신규 7테이블** + `t_prd_product_addons` 변경 + `t_prd_product_process_excl_groups` 제거(흡수) + 전 도메인 테이블 `del_yn/del_dt` 소프트삭제 추가. **스키마는 완비, 적재는 부분**(택일그룹 마이그·템플릿 헤더·카테고리만, 옵션항목/선택/제약은 0행).

## 1. CPQ 신규/변경 테이블 (라이브 DDL)

### 1.1 옵션 레이어 (3 신규)

| 테이블 | PK | 핵심 컬럼 | FK | 적재 |
|--------|----|-----|-----|----|
| `t_prd_product_option_groups` | (prd_cd, opt_grp_cd) | opt_grp_nm vc100 · **sel_typ_cd**(→SEL_TYPE) · min_sel_cnt · max_sel_cnt · mand_yn · disp_seq | prd_cd→products · sel_typ_cd→cod | **13행** |
| `t_prd_product_options` | (prd_cd, opt_cd) | **opt_grp_cd**(그룹) · opt_nm vc100 · dflt_yn · disp_seq | opt_grp_cd→option_groups · prd_cd→products | 0행 |
| `t_prd_product_option_items` | (prd_cd, opt_cd, item_seq) | **ref_dim_cd**(→OPT_REF_DIM) · **ref_key1 NOT NULL** · ref_key2 · qty | opt(prd_cd,opt_cd)→options · ref_dim_cd→cod · **+검증 트리거** | 0행 |

- 전 테이블 공통: `use_yn` ch1 NN dflt 'Y' · **`del_yn` ch1 NN dflt 'N' · `del_dt`**(소프트삭제) · reg_dt/upd_dt.
- 설계 §3.1 대비 **차이**: ① 설계의 `ref_param_json`(jsonb, 공정 파라미터 보존) **미구현** — option_items엔 `qty`만. ② ref_dim_cd가 텍스트('size')가 아닌 **코드 FK**(OPT_REF_DIM.01~.07).

### 1.2 추가상품 템플릿 (2 신규 + addons 변경)

| 테이블 | PK | 핵심 컬럼 | FK | 적재 |
|--------|----|-----|-----|----|
| `t_prd_templates` | tmpl_cd | base_prd_cd · tmpl_nm vc200 · dflt_qty | base_prd_cd→products | **11행** |
| `t_prd_template_selections` | (tmpl_cd, sel_seq) | ref_dim_cd · ref_key1/2 · **opt_cd** · **sel_val** · qty | tmpl_cd→templates · ref_dim_cd→cod | 0행 |
| `t_prd_product_addons` **변경** | (prd_cd, tmpl_cd) | **`addon_prd_cd` → `tmpl_cd` 교체 완료** | prd_cd→products · **tmpl_cd→templates** | 34행 |

- 설계 §3.2 대비 **차이**: 설계의 `t_prd_templates.price`(잠정 추가가격) **미구현**. template_selections는 설계(opt 또는 차원)보다 풍부 — polymorphic(ref_dim/key) + opt_cd + sel_val 동시 보유.

### 1.3 제약 (1 신규 + products 캐시)

| 테이블 | PK | 핵심 컬럼 | FK | 적재 |
|--------|----|-----|-----|----|
| `t_prd_product_constraints` | (prd_cd, rule_cd) | rule_nm vc200 · **rule_typ_cd**(→RULE_TYPE) · **logic jsonb NN** · err_msg | prd_cd→products · rule_typ_cd→cod | 0행 |
| `t_prd_products.constraint_json` | — | **jsonb**(compile 캐시) | — | non-null 0행 |

- 설계 §3.3 대비 **차이**: 설계 `rule_typ` → 라이브 **`rule_typ_cd`(코드 FK→RULE_TYPE)**. `constraint_json`(compile 캐시) 실재(설계대로) — 단 현재 채워진 행 0.

### 1.4 카테고리 (1 신규 — 설계 범위 밖)

| 테이블 | PK | 컬럼 | FK | 적재 |
|--------|----|-----|-----|----|
| `t_prd_product_categories` | (prd_cd, cat_cd) | **main_cat_yn** · disp_seq | prd_cd→products · cat_cd→t_cat_categories | **274행** |

- cpq-design 설계에 **없던 테이블**. 상품 ↔ 카테고리 M:N(대표 카테고리 main_cat_yn). 별도 라인으로 분석 문서화 대상.

### 1.5 제거: `t_prd_product_process_excl_groups`

- 라이브에서 **삭제됨**. 설계 D-2 "흡수/마이그레이션" 대로 → `option_groups`로 변환. **실증**: `GRP-BOOK-제본`(책자 제본 택일, SEL_TYPE.01 max=1, PRD_000068~100 10상품) · `GRP-CAL-가공`(캘린더 가공 택일, PRD_000110~112 3상품) 적재 = 설계 미실증 GAP-2가 라이브에서 **해소**.

## 2. polymorphic 검증 트리거 (라이브 `fn_chk_opt_item_ref`)

`t_prd_product_option_items` BEFORE INSERT/UPDATE → ref_dim_cd별 "그 상품에 등록된 차원 행" EXISTS 검사:

| ref_dim_cd | 의미 | 검사 대상(prd_cd + 키) |
|------------|------|----------------------|
| `OPT_REF_DIM.01` | 사이즈 | t_prd_product_sizes(siz_cd=ref_key1) |
| `OPT_REF_DIM.02` | 판형 | t_prd_product_plate_sizes(siz_cd=ref_key1) |
| `OPT_REF_DIM.03` | 자재 | t_prd_product_materials(mat_cd=ref_key1, **usage_cd=ref_key2**) |
| `OPT_REF_DIM.04` | 공정 | t_prd_product_processes(proc_cd=ref_key1) |
| `OPT_REF_DIM.05` | 묶음수 | t_prd_product_bundle_qtys(bdl_qty=ref_key1::int) |
| `OPT_REF_DIM.06` | **도수** | t_prd_product_print_options(**opt_id=ref_key1::int**) |
| `OPT_REF_DIM.07` | 셋트 | t_prd_product_sets(sub_prd_cd=ref_key1) |
| ELSE | — | RAISE '미지원 ref_dim_cd' |

- 위반 시 `RAISE EXCEPTION 'opt_item ref 무결성 위반…'`. DB FK 불가한 polymorphic 참조를 트리거로 강제(설계 §4 그대로 구현).
- **도수=opt_id**(OPT_REF_DIM.06): 설계 검증 MISMATCH-1 정정(clr_cd 아님)이 **라이브에 반영됨**.

## 3. 신규 코드값 (t_cod_base_codes 실재)

| 그룹 | 자식 |
|------|------|
| `OPT_REF_DIM` 옵션참조차원유형 | .01 사이즈 · .02 판형 · .03 자재 · .04 공정 · .05 묶음수 · .06 도수 · .07 셋트 (**7종 — addon 없음**) |
| `SEL_TYPE` 선택유형 | .01 단일 · .02 다중 |
| `RULE_TYPE` 제약규칙유형 | .01 호환 · .02 금지 · .03 필수동반 |

## 4. 설계/검증 문서 ↔ 라이브 정합 판정

`cpq-design.md`·`banner-walkthrough.md`·`postcard-walkthrough.md` 인용을 라이브와 대조한 결과:

| # | 설계/검증 요소 | 라이브 | 판정 |
|---|---------------|--------|------|
| ✅1 | 옵션 3 + 템플릿 2 + 제약 1 테이블 | 전건 실재 | **정합** |
| ✅2 | polymorphic + 검증 트리거(§4) | `fn_chk_opt_item_ref` 7종 | **정합** |
| ✅3 | color-count 키 = opt_id (MISMATCH-1 정정) | OPT_REF_DIM.06 도수→opt_id | **정합(정정 반영)** |
| ✅4 | addon = tmpl_cd(D-4) | addons.tmpl_cd FK→templates | **정합** |
| ✅5 | constraint = JSONLogic + constraint_json 캐시 | logic jsonb + products.constraint_json | **정합** |
| ✅6 | excl_groups 흡수(GAP-2 미실증) | 제본/캘린더 마이그 실증 | **해소(라이브 우위)** |
| ✅7 | SEL_TYPE/OPT_REF_DIM/RULE_TYPE 코드 | 전건 실재 | **정합** |
| 🔴8 | **`ref_param_json`**(공정 파라미터 보존 — 타공 4/6/8을 PROC 1행+`{"구수":N}` 재사용; banner 7회·postcard 2회 인용) | **미구현**(option_items=qty만) | **불일치 — 보강 필요** |
| 🟡9 | `t_prd_templates.price`(추가가격; 3회 인용) | 미구현 | 불일치(잠정→미반영) |
| ⚠️10 | ref_dim **8종**(addon 포함) | **7종**(addon 제외) | 라이브 정제(addon은 tmpl로 분리, walkthrough도 누락 지적함) |
| ⚠️11 | `rule_typ`(텍스트) | `rule_typ_cd`(코드 FK) | 코드화 |
| ➕12 | (설계 범위 밖) | `del_yn`/`del_dt` 소프트삭제 · `t_prd_product_categories` | 라이브 신규 |

**종합:** 검증 문서의 **사실 인용은 정확**(prd_cd/proc_cd 등 MISMATCH 0 — 기존 검증 유효). 설계 의도 대비 라이브는 **대부분 구현 + 일부 정제(addon/코드화) + 일부 미구현(ref_param_json/price) + 추가(소프트삭제/카테고리)**. **핵심 보강점 = ref_param_json 부재**: walkthrough의 "공정 파라미터 재사용"(타공 구수) 설계가 라이브 미구현이라, 현재는 타공 4/6/8을 공정 행 분리 또는 qty 사용으로 풀어야 함 → 재검토 필요.

## 5. 적재 현황 + 미해결

- **적재됨**: option_groups 13(제본10/캘린더3) · templates 11(헤더) · categories 274 · addons 34.
- **미적재(스키마만)**: options 0 · option_items 0 · template_selections 0 · constraints 0 · products.constraint_json 0. → CPQ는 **택일그룹 마이그 + 템플릿/카테고리 헤더까지만 운영 적재**, 실제 옵션 구성·제약은 미투입.
- **미해결**:
  - 🔴 `ref_param_json` 부재 → 공정 파라미터(타공 구수·봉제 유형) 보존 메커니즘 결정(컬럼 추가 재제안 vs qty/별도 공정행).
  - 🟡 `templates.price` 부재 → 추가상품 추가가격 보관처(가격엔진 t_prc_* 연계 vs 컬럼).
  - 템플릿 selections 0행 → 적재된 templates 11행의 구성 내용 미투입(헤더만).
  - constraints 0 + constraint_json 0 → 교차 제약 미투입(설계 검증한 JSONLogic 룰 미적재).
