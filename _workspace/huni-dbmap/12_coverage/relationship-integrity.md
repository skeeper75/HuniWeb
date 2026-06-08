# 엔티티 관계 무결성 리포트 — round-7 입체 커버리지

> 권위: `docs/goal-2026-06-08-01.md` C5. 매트릭스는 셀(존재)뿐 아니라 **셀 사이의 선(관계)**도 본다.
> 모든 검사는 라이브 DB 읽기전용 SELECT. 검사일 2026-06-08. 재현 쿼리는 각 절에 인용.

## 검사 요약

| ID | 검사 | 결과 | 위반 행 |
|----|------|:----:|:------:|
| R1 | FK 고아 — 16 자식 테이블 `prd_cd` → `t_prd_products` | ✅ PASS | 0 |
| R2 | 코드 FK — `sizes.siz_cd`/`materials.mat_cd` → 마스터 | ✅ PASS | 0 |
| R3 | CPQ polymorphic — `option_items` 참조 해소 | ⚠️ VACUOUS | items 0행 (해소할 대상 없음) |
| R4 | 가격 사슬 — 공식 → formula_components → component_prices | ✅ PASS | 0 끊김 |
| R5 | 코드 FK — `categories.cat_cd`·`processes.proc_cd`·`print.clr_cd`·`materials.usage_cd` | ✅ PASS | 0 |
| R6 | 셋트 self-ref — `sets.sub_prd_cd` → `t_prd_products` | ✅ PASS | 0 |
| R7 | CPQ 사슬 완결성 — `options` 중 `option_items` 없는 고아 | ❌ FAIL | 5/5 options 가 items 0 |

## R1 — FK 고아 (자식 → 부모 prd_cd)

16개 상품 자식 테이블 각각 `prd_cd`가 `t_prd_products`에 실재하는지.

```sql
SELECT count(*) FROM <child> c LEFT JOIN t_prd_products p ON p.prd_cd=c.prd_cd WHERE p.prd_cd IS NULL;
```

| 테이블 | 고아 |
|--------|:---:|
| sizes·materials·print_options·processes·plate_sizes·bundle_qtys·page_rules·sets·addons·categories·price_formulas·discount_tables·option_groups·options·option_items·constraints | **전부 0** |

**PASS** — 어떤 자식 행도 존재하지 않는 상품을 가리키지 않는다.

## R2 / R5 — 코드 FK (차원행 → 마스터/코드)

```sql
-- siz_cd
SELECT count(*) FROM t_prd_product_sizes s LEFT JOIN t_siz_sizes z ON z.siz_cd=s.siz_cd WHERE z.siz_cd IS NULL;            -- 0
-- mat_cd
SELECT count(*) FROM t_prd_product_materials m LEFT JOIN t_mat_materials t ON t.mat_cd=m.mat_cd WHERE t.mat_cd IS NULL;    -- 0
-- cat_cd
SELECT count(*) FROM t_prd_product_categories c LEFT JOIN t_cat_categories m ON m.cat_cd=c.cat_cd WHERE m.cat_cd IS NULL;  -- 0
-- proc_cd
SELECT count(*) FROM t_prd_product_processes p LEFT JOIN t_proc_processes m ON m.proc_cd=p.proc_cd WHERE m.proc_cd IS NULL;-- 0
-- 인쇄 도수 front/back clr_cd → t_clr_color_counts.clr_cd
SELECT count(*) FROM t_prd_product_print_options p WHERE p.front_colrcnt_cd IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM t_clr_color_counts c WHERE c.clr_cd=p.front_colrcnt_cd);                                   -- 0 (front), 0 (back)
-- materials.usage_cd → t_cod_base_codes.cod_cd (USAGE.0x)
SELECT count(*) FROM t_prd_product_materials m WHERE m.usage_cd IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM t_cod_base_codes b WHERE b.cod_cd=m.usage_cd);                                             -- 0
```

**PASS** — siz/mat/cat/proc/도수/usage 코드 FK 전부 0 고아. 적재된 차원행은 모두 유효한 마스터/코드를 가리킨다.

## R3 / R7 — CPQ polymorphic 참조 + 사슬 완결성

라이브 CPQ 옵션 레이어 전역 실측:

| 테이블 | 행수 |
|--------|----:|
| `t_prd_product_option_groups` | 2 |
| `t_prd_product_options` | 5 |
| `t_prd_product_option_items` | **0** |

```sql
-- R3: option_items polymorphic 해소 (ref_dim_cd+ref_key1[,ref_key2] → 라이브 차원행)
SELECT count(*) FROM t_prd_product_option_items;   -- 0 → 해소 검사 대상 없음 (VACUOUS)
-- R7: items 없는 option 고아
SELECT count(*) FROM t_prd_product_options o
  WHERE NOT EXISTS(SELECT 1 FROM t_prd_product_option_items i WHERE i.prd_cd=o.prd_cd AND i.opt_cd=o.opt_cd);  -- 5/5
```

- **R3 VACUOUS** — `option_items`가 0행이므로 polymorphic 참조(`ref_dim_cd`+`ref_key`)를 해소할 대상이
  없다. 트리거 `fn_chk_opt_item_ref`의 검증 대상 자체가 부재. "무결"이 아니라 "미적재"다.
- **R7 FAIL** — 존재하는 5개 option(2개 상품: PRD_000138 일반현수막, PRD_000002 OPP비접착봉투)이
  **전부 option_items 0** → CPQ 사슬이 group→option 에서 끊겨 있다. 옵션이 선택지(items) 없이 껍데기만
  적재된 상태. round-6 일반현수막 파일럿이 설계 GO 후 **실 COMMIT 미완**임을 라이브가 확증.

> 영향: 매트릭스에서 opt_groups/options 가 silsa·product-accessory 에 1행씩 보이지만(PARTIAL/DB-ONLY),
> 실사용 불가(items 없음). gap-board §2·§6 으로 라우팅(dbm-option-mapper).

## R4 — 가격 사슬 연결 (상품 → 공식 → 구성요소 → 단가)

```sql
WITH pf AS (SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas)
SELECT count(*) FROM pf
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
  JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
  WHERE fc.frm_cd=pf.frm_cd);   -- 0
-- component_prices 코드 FK
SELECT count(*) FROM t_prc_component_prices cp WHERE cp.siz_cd IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM t_siz_sizes z WHERE z.siz_cd=cp.siz_cd);   -- 0
SELECT count(*) FROM t_prc_component_prices cp WHERE cp.mat_cd IS NOT NULL
  AND NOT EXISTS(SELECT 1 FROM t_mat_materials m WHERE m.mat_cd=cp.mat_cd);-- 0
```

**PASS** — 라이브에 바인딩된 모든 가격 공식은 `formula_components`를 거쳐 `component_prices`로 끊김
없이 해소된다(끊김 0). component_prices의 siz/mat 코드 FK도 0 고아.

> 주의: 이것은 "적재된 공식"의 사슬이 온전하다는 뜻. 미적재 상품군(포토북·캘린더·아크릴·굿즈파우치·
> 상품악세사리)은 공식 자체가 없다 — **사슬 부재**이지 **사슬 단절**이 아니다(gap-board §3, DIM-UNLOADED).

## R6 — 셋트 self-reference

```sql
SELECT count(*) FROM t_prd_product_sets s LEFT JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd
WHERE s.sub_prd_cd IS NOT NULL AND p.prd_cd IS NULL;   -- 0
```

**PASS** — 셋트 구성품(`sub_prd_cd`)이 모두 실재 상품을 가리킨다(고아 0).

## 종합

- **참조 무결성(R1·R2·R4·R5·R6) 전건 PASS** — 적재된 것은 전부 유효하게 연결돼 있다. 잘못 연결된
  고아·끊긴 가격사슬·무효 코드 FK는 **0**.
- **유일한 FAIL(R7) + VACUOUS(R3)** = CPQ 옵션 레이어가 **사슬 미완(option_items 0)**. 이는 무결성
  결함이라기보다 **미적재의 관계적 증거**다 — 옵션이 껍데기만 있고 선택지가 없다. 갭 보드 §2/§6 라우팅.
- 결론: 라이브 DB의 **적재된 부분은 관계적으로 건전**하다. 문제는 광범위한 **미적재**(특히 CPQ 옵션·
  6 상품군 가격)이며, 이는 매트릭스 MISSING/PARTIAL 과 gap-board 가 입체적으로 포착한다.
