---
name: dbm-cpq-option-mapping
description: 후니프린팅 상품마스터·가격표의 옵션성 속성을 라이브 CPQ 옵션 레이어(t_prd_product_option_groups/options/option_items·templates/template_selections·constraints)에 매핑하는 L2 설계·검증 방법론 스킬. 이미 적재된 차원행을 polymorphic ref_dim_cd(OPT_REF_DIM 7종)로 참조해 option_groups(택1/택N)→options→option_items로 재구성하는 절차, 속성→엔티티(차원/CPQ옵션/가격/제약) 결정 규칙, WowPress 흡수원칙(형상→규격·본체색→재질 합성, 과분할 금지)+RedPrinting 캐스케이드 6종→JSONLogic constraints 변환, 검증 트리거 fn_chk_opt_item_ref 무결성 준수, ref_param_json/hidden-essential GAP 처리, FK 위상정렬(차원행 선적재), 경계면 교차검증을 제공한다. DB 직접 적재는 하지 않는다. 'CPQ 옵션 매핑', '옵션 레이어 매핑', '속성 엔티티 매핑 지도', 'option_groups 설계', 'polymorphic ref_dim_cd 매핑', '옵션 캐스케이드 매핑', '상품군 옵션 파일럿', 'CPQ 옵션 검증', 'CPQ 매핑 다시', '옵션 매핑 검증' 작업 시 반드시 이 스킬을 사용. 차원·가격 매핑(L1)은 dbm-mapping/dbm-price-formula, 이미 적재된 DB↔엑셀 정합 검증은 dbm-mapping-audit이 담당하므로 그 작업에는 트리거하지 않는다.
---

# CPQ Option-Layer (L2) Mapping Methodology

[HARD] Write all deliverable docs (.md: attribute-entity-map, option-layer, gaps, validation) in KOREAN (project documentation language). Keep identifiers, table/column names, code values, CSV headers, JSONLogic, and status tokens (PASS/FAIL/GO/NO-GO/BLOCKER/CONFIRM) in English.

This skill is shared by `dbm-option-mapper` (designs the option layer + emits load CSV) and `dbm-validator` (cross-checks it). Harness scope: produce a complete, loadable CPQ option mapping, but DO NOT write to the live DB. Real INSERT / code-row registration / DDL = a later, separately human-approved step.

## Why this is a separate track from L1

The earlier rounds map **L1** — Excel cell values → normalized dimension tables (`t_prd_product_sizes/materials/processes/print_options/bundle_qtys/sets/plate_sizes`) + the price engine (`t_prc_*`). That work is mostly done and loaded.

**L2 is different in kind.** The CPQ option layer does NOT carry new source data. It is a layer *on top of* the already-loaded dimension rows: it groups them into user-facing选택 options and records cross-dimension constraints. An `option_item` is a *pointer* to an existing dimension row, not a new copy of it. Confusing L2 with L1 (re-loading dimension data into option_items) is the primary failure mode — guard against it.

## The two deliverables

### A. Attribute→entity master map (`attribute-entity-map.md`)

For every 옵션성 attribute across the 13 상품마스터 sheets, decide its **target entity**. This is the reference that answers "각 속성을 어디에 매핑하나". Four possible targets:

| Target | When | Example |
|--------|------|---------|
| **Dimension table (L1)** | physical/orderable axis already modeled | 사이즈→sizes, 소재→materials, 도수→print_options, 공정→processes |
| **CPQ option layer (L2)** | the attribute is a *user选택* over dimension rows, or a 택1/택N group | 가공 택일그룹, 추가옵션, 복합옵션(각목+끈) |
| **Price engine (t_prc_*)** | the attribute drives price, not selection identity | 수량구간 단가, 면적 매트릭스 |
| **Constraint (JSONLogic)** | the attribute is a cross-axis rule | 자재→후가공 disable, 각목규격↔세로 정합, 사이즈 범위 |

Most attributes are *both* an L1 dimension row AND an L2 option (the dimension stores the orderable value; the option_group makes it selectable). Record both. The verdict per attribute = {primary entity, option_group needed?, sel_typ, constraint needed?, WowPress축 대응, Red제약 대응, GAP?}.

### B. Per-상품군 option-layer pilot (`<family>-option-layer.md`)

Instantiate the master map on ONE product family, end-to-end and load-ready. The `banner-walkthrough.md` and `postcard-walkthrough.md` are worked examples of this shape — follow their structure (Step 0 차원행 전제 → option_groups → options → option_items → constraints → templates → MES 환원 trace).

## The CPQ option layer structure

```
t_prd_product_option_groups  (prd_cd, opt_grp_cd)   sel_typ_cd·min_sel_cnt·max_sel_cnt·mand_yn·disp_seq
   └─< t_prd_product_options  (prd_cd, opt_cd)       opt_grp_cd·opt_nm·dflt_yn·disp_seq
        └─< t_prd_product_option_items (prd_cd, opt_cd, item_seq)   ref_dim_cd·ref_key1·ref_key2·qty
t_prd_templates (tmpl_cd) base_prd_cd·tmpl_nm·dflt_qty   └─< t_prd_template_selections (tmpl_cd, sel_seq)
t_prd_product_addons (prd_cd, tmpl_cd)   [addon = tmpl_cd, NOT addon_prd_cd]
t_prd_product_constraints (prd_cd, rule_cd) rule_typ_cd·logic jsonb   → t_prd_products.constraint_json (compile cache)
```

A complex option is **multiple option_items** (각목+끈 = item_seq 1 끈[process] + item_seq 2 각목[set]). The polymorphic `ref_dim_cd` lets one option carry heterogeneous dimensions (process + set) that typed FKs could not.

## ref_dim_cd polymorphic mapping (match the live trigger exactly)

`fn_chk_opt_item_ref` (BEFORE INSERT/UPDATE) enforces that the referenced dimension row exists for that prd_cd. Match its dispatch — a wrong key slot = trigger rejection:

| ref_dim_cd | 의미 | dimension table | ref_key1 | ref_key2 |
|------------|------|-----------------|----------|----------|
| `OPT_REF_DIM.01` | 사이즈 | t_prd_product_sizes | siz_cd | — |
| `OPT_REF_DIM.02` | 판형 | t_prd_product_plate_sizes | siz_cd | — |
| `OPT_REF_DIM.03` | 자재 | t_prd_product_materials | mat_cd | **usage_cd** |
| `OPT_REF_DIM.04` | 공정 | t_prd_product_processes | proc_cd | — |
| `OPT_REF_DIM.05` | 묶음수 | t_prd_product_bundle_qtys | bdl_qty::int | — |
| `OPT_REF_DIM.06` | **도수** | t_prd_product_print_options | **opt_id::int** | — |
| `OPT_REF_DIM.07` | 셋트 | t_prd_product_sets | sub_prd_cd | — |

[HARD] 도수 = `opt_id` (NOT `clr_cd`) — this was design MISMATCH-1, corrected and live. There is NO `addon` ref_dim (8th) — add-ons go through `templates`, not option_items. Authority: `00_schema/cpq-schema.md §2`.

## Granularity: absorb vs split (WowPress rule, the "과분할 금지" answer)

WowPress fixes 7 semantic axes and *absorbs* new properties into them rather than minting new axes. Apply the same to 후니:

| 후니 속성 | 결정 | 근거(WowPress) | 후니 적용 |
|-----------|------|----------------|-----------|
| 본체색 (파우치 블랙, 머그 화이트) | **COMPOSE — 재질행 1행** | 소재+본체색=한 재질행 | mat_cd 합성. 색 독립축 신설 금지 |
| 형상 (원형/하트/별) | **COMPOSE — 규격(siz) 융합** | sizeinfo에 형상 융합 | siz_nm에 형상. 형상축 신설 금지 |
| 사이즈+방향 (가로L/세로M) | **COMPOSE — 규격 1행** | 함께 고르는 물리속성 1행 | siz_nm="가로형 L" |
| 인쇄면 (단/양면), 잉크색 | **SPLIT — 도수축** | 인쇄 면/잉크=colorinfo | print_options. 본체색과 의미 다름 |
| 구수/개수 (1구~4구, 타공 N) | **SPLIT — 개수형 공정** | awkjob namestep2 개수형 | 공정 + 개수 파라미터(→ ref_param_json GAP) |
| 포장/구성 (OPP봉투, N개팩) | **묶음수 or 옵션그릇** | optioninfo flat | bundle_qtys 또는 GAP-OPT |

한 줄 지침: **함께 고르는 물리 속성은 한 행으로 합성하라(소재+본체색=재질, 형상+치수+방향=규격). 색을 무조건 분리하지 말 것 — 본체색은 재질, 잉크색/인쇄면만 도수.**

## Cascade → constraint (RedPrinting 6종 → JSONLogic)

RedPrinting drives the option UI with 6 cascade constraint types. Each maps to a 후니 representation:

| Red 캐스케이드 | 후니 표현 | 비고 |
|----------------|-----------|------|
| material→pcs disable | constraint(forbidden) JSONLogic | 자재 선택 시 특정 후가공 금지 |
| dosu↔bnc 매핑 | constraint(required/compatible) | 도수→제본그룹·내지표지 색도 |
| size 제약 | constraint(compatible) + nonspec 범위 | 규격 CUT/WRK·비표준 허용 |
| quantity 제약 | t_prd_products MIN/FIR/INC/STEP 컬럼 | 옵션 아님 — products 범위 |
| pcs essential/hidden | option_groups.mand_yn + (hidden=GAP) | 필수 자동적용·미표시 → hidden-essential GAP |
| base 제약 | t_prd_products / t_siz_sizes margin | 단위·재단마진·최소/최대 |

JSONLogic rules are stored per-row in `t_prd_product_constraints.logic`, then active rows are compiled (AND-combined) into `t_prd_products.constraint_json`. POD evaluates with `json-logic-js`, backend with `json-logic-py` — same result. Final price-validity is the price engine (a non-priced combo = unorderable), NOT an enumerated constraint table.

## GAP handling (flag, never fabricate)

Two live-confirmed GAPs (`cpq-schema.md §4`). Route to `dbm-ddl-proposer` — do NOT smear into existing columns:

- **ref_param_json 미구현** — 공정 파라미터(타공 4/6/8 구수, 봉제 유형/폭) 보존 컬럼 없음. Without it, 타공 4/6/8 must become 3 separate process rows (master pollution). Do not abuse `qty` to encode 구수. Flag.
- **hidden-essential 미명시** — Red ESN_YN=Y/VIEW_YN=N (필수이나 자동적용·미표시, 예 재단 CUT_DFT). 후니 option_groups has mand_yn but no "auto-apply hidden" flag. Flag.
- **GAP-OPT (포장/자유옵션)** — WowPress optioninfo(포장·각인·잉크색팩)에 대응하는 후니 OPT_REF_DIM 차원 없음. Flag.
- **비치수 size** — 형상(원형/별)·용량(11온스)을 siz로 등록 시 width/height 부재. Already identified in round-5 DDL proposals.

## Load order: dimension rows first, then option layer (FK-topo)

The trigger `fn_chk_opt_item_ref` rejects an option_item whose dimension row is absent. So:
1. dimension rows (sizes/materials/processes/...) — L1, mostly already live.
2. `t_prd_product_option_groups` → `t_prd_product_options` → `t_prd_product_option_items`.
3. `t_prd_templates` → `t_prd_template_selections` → `t_prd_product_addons`(tmpl_cd).
4. `t_prd_product_constraints` → compile → `t_prd_products.constraint_json`.

If a referenced dimension row is missing, the option_item is BLOCKED (needs L1 pre-load) — list it, don't invent the dimension code.

## Load CSV format

Write to `_workspace/huni-dbmap/10_configurator/load/<table>.csv`:
- Header row = DB column names, exactly. NULL = empty string. `[CONFIRM]` for unresolved codes (never fabricate).
- One CSV per target table; filename = table name.

## Validation: boundary cross-comparison

The validator proves agreement across every boundary (not just existence):

1. **Excel 옵션성 컬럼 ↔ attribute-entity-map** — every 옵션성 attribute has a target-entity verdict + rationale; no attribute silently dropped.
2. **option_items ↔ live dimension rows** — every `(ref_dim_cd, ref_key1[, ref_key2])` resolves to an existing dimension row for that prd_cd (the trigger's exact check, read-only lookup). Catch wrong key slot (도수≠clr_cd), absent dimension row (BLOCKED), wrong table dispatch.
3. **option layer ↔ live CPQ schema** — type/length, NOT NULL (ref_key1, sel_typ_cd), FK (opt_grp_cd→groups, sel_typ_cd/ref_dim_cd→codes), PK uniqueness within CSV.
4. **constraints ↔ JSONLogic semantics** — each `logic` is valid JSONLogic; hand-evaluate a sample selection and confirm the rule passes/fails as intended; the compiled `constraint_json` = AND of active rules.
5. **load order ↔ FK + trigger** — dimension rows precede option layer; templates before addons.

### Loadability DRY-RUN (only if lead-authorized, never commit)
A transaction that inserts the option layer and rolls back proves trigger-passing + insertability without persisting. The trigger `fn_chk_opt_item_ref` fires inside the transaction, so a DRY-RUN is the strongest proof an option_item's ref resolves. Prefer local read-only dimension-row lookups first. If a DRY-RUN runs, it MUST end in ROLLBACK and MUST be lead-authorized. NEVER COMMIT.

## Validation output

Write to `_workspace/huni-dbmap/03_validation/cpq-option-validation.md`: per boundary PASS/FAIL, findings with severity (BLOCKER/MAJOR/MINOR) + evidence (file/row/column/trigger/constraint) + suggested fix, and a final GO / NO-GO verdict with an insertable / BLOCKED(needs L1) / GAP tally.

## Authority order (for conflict resolution)

Excel 명시값 > 추출 스냅샷(`ref-*.csv` stale — 등록/존재 판정은 라이브 권위). Live schema + trigger `fn_chk_opt_item_ref` > design doc. `cpq-schema.md §4` (design↔live 정합) wins on design-vs-live conflicts. The authority side wins; the other side is the bug.
