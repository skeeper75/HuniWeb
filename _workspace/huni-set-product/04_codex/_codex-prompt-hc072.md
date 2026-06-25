You are an INDEPENDENT 2nd-opinion reviewer (gpt-5.5) auditing a print-shop SET-PRODUCT price-formula design for money-critical defects. You are read-only. Do NOT trust the design narrative — judge each item yourself from the FACTS below and the source files. Korean output OK (identifiers/SQL in English).

# CONTEXT
Huni printing has a SET product PRD_000072 "하드커버책자" (hardcover bound booklet). A SET = a finished product (prd_typ=01) assembled from sub-products (prd_typ=02 semi-finished members). Price is computed by a single live engine `evaluate_set_price` (pricing.py:718) = sum of each member's `evaluate_price` + the SET parent's own price_formula. The parent formula is a 원자합산형 (atomic-sum) formula: a `t_prc_price_formulas` row + N `t_prc_formula_components` rows, each referencing a `t_prc_price_components` (comp) that has dimensioned unit-price rows in `t_prc_component_prices`.

Authority Excel (상품마스터 260610 계산공식집) says the 하드커버무선 (hardcover perfect-bound) sale price = 6 line items:
  판매가 = 내지인쇄비(inner-page print) + 표지인쇄비(cover print) + 표지코팅비(cover coating) + 제본비(binding) + 용지비(paper) + 후가공비(post-process foil)

# GROUND-TRUTH FACTS (I re-measured these LIVE via read-only SELECT 2026-06-25 — treat as fact, not the design's claim)

## F1. Binding comp del_yn + price identity
- COMP_BIND_HC_MUSEON: del_yn='Y' (logically deleted), comp_nm="제본비 하드커버무선"
- COMP_BIND_SSABARI:   del_yn='N' (active),            comp_nm="제본비 싸바리바인더"
- For proc_cd=PROC_000023, BOTH comps have IDENTICAL 6 price rows: min_qty 1=30000, 4=20000, 10=14000, 50=9000, 100=7000, 1000=6000 (byte-identical).
- COMP_BIND_SSABARI holds price rows for THREE procs: PROC_000023 (6 rows), PROC_000024 (6 rows), PROC_000098 (6 rows). It is NOT single-proc.
- COMP_BIND_SSABARI use_dims = ["proc_cd","min_qty","proc_grp:PROC_000017"] (NO plt_siz_cd).
- Engine code pricing.py/models.py reference `del_yn` ZERO times (per prior verification) → the engine does NOT filter on del_yn (it would still price a deleted comp).

## F2. Print comp del_yn
- COMP_PRINT_DIGITAL_S1: del_yn='N' (active). use_dims=["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]
- COMP_PRINT_DIGITAL_S2: del_yn='Y' (deleted)
- The ONLY active general digital-print comps are: COMP_PRINT_DIGITAL_S1 and COMP_PRINT_SPOT_WHITE_S1 (별색/spot-white). All other active "print" comps are product-specific (명함 namecard whole-product, 아크릴 acrylic). There is NO second active general digital-print comp equivalent to S1.

## F3. formula_components primary key
- PK of t_prc_formula_components = (frm_cd, comp_cd). Across ALL live formulas, ZERO formulas contain the same comp_cd twice (verified). So a single formula physically cannot list COMP_PRINT_DIGITAL_S1 twice.

## F4. search-before-mint / bindings
- t_prc_price_formulas LIKE 'PRF_HC%' = 0 rows (new mint of PRF_HC_MUSEON_SUM has no conflict).
- PRD_000072 binding (t_prd_product_price_formulas) = 0 rows.
- Members of PRD_000072 set: PRD_000073(표지/cover), 074/075/076(면지/lining white/black/grey) — ALL prd_typ=02 semi-finished. Members' price-formula bindings = 0 rows (members contribute 0).
- 074/075/076 are sub_prd_qty=1 each, disp_seq 2/3/4 = a pick-ONE color choice (white/black/grey), all unprinted (무지).

## F5. Coating / paper unit prices (verbatim)
- COMP_PAPER use_dims=["plt_siz_cd","mat_cd"] (no min_qty → flat 절가). Art-paper 150g (MAT_000078) at SIZ_000499 (국4절) = unit_price 46.65 (single row).
- COMP_PAPER for MAT_000246 (하드커버전용지 "전용지+무광코팅") = 0 rows (not loaded).
- COMP_COAT_MATTE use_dims=["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]. Rows exist for PROC_000015(무광/matte)/SIZ_000499/coat_side_cnt=1: min_qty 1=2000,2=1500,5=1200,10=1000,20=800,30=800,40=700,50=700.
- The Excel row for 하드커버전용지 names the paper "하드커버전용지+무광코팅" and its 가격(국4절) cell = the literal Korean word "계산식" (="computed", a placeholder, NOT an Excel formula). The base paper noted is "아트150".

## F6. Processes registered on PRD_000072
- {PROC_000014 유광, PROC_000015 무광, PROC_000023 하드커버무선제본, PROC_000076 수축포장}. NO foil(박) process registered.
- PRD_000072 discount_tables = 0 rows.

# THE DESIGN UNDER REVIEW (read these files in workdir — but judge independently)
- 06_load/hc072-final-design.md (main design)
- 06_load/cover-paper-calc-derivation.md (cover paper "계산식" derivation → reuse COMP_PAPER art150 46.65)
- 06_load/lining-price-derivation-method.md (lining/면지 = free, 3-way concordance)
- 06_load/price-pilot-hc072/apply.sql + CSVs
- 01_authority/set-price-authority.md (authority §1.1, 6 line items)

The design wires 4 formula_components into a NEW formula PRF_HC_MUSEON_SUM:
  seq1 COMP_BIND_SSABARI (binding), seq2 COMP_PRINT_DIGITAL_S1 (cover print),
  seq3 COMP_COAT_MATTE (cover coating), seq4 COMP_PAPER (cover paper).
It marks 내지인쇄비(inner-page print) as BLOCKED and 후가공박(foil) as N/A, and HOLDS the product→formula binding until inner-page is resolved.

# YOUR INDEPENDENT JUDGMENT — answer each, give VERDICT (AGREE / DISAGREE / UNSURE-NEEDS-LIVE) + reasoning + any money risk

Q1. DELETED-COMP SUBSTITUTION: Is replacing the deleted COMP_BIND_HC_MUSEON with the active COMP_BIND_SSABARI for the binding line a correct/safe choice (same price, semantically OK)? Note SSABARI's name is "싸바리바인더" and it holds 3 procs. Any risk you see (e.g. multi-proc match if proc_cd not injected; semantic confusion; wrong proc)?

Q2. INNER-PAGE PRINT = BLOCKED?: The design says inner-page print cannot be added because (a) S2 is deleted, (b) S1 already occupies seq2 and PK=(frm_cd,comp_cd) forbids S1 twice, (c) even if PK avoided, one formula_component is evaluated once with one selections-set, but cover-print and inner-print need different plt_siz/quantity. Do you AGREE inner-page print is genuinely BLOCKED, or is there ANOTHER solution (reuse some existing comp, a different modeling) that the design missed? Is BLOCKED over-cautious?

Q3. COATING DOUBLE-COUNT = ZERO?: Paper line (COMP_PAPER, pure art150 절가 46.65) + cover-coating line (COMP_COAT_MATTE, separate) — is there any HIDDEN double-count? The paper MAT label "전용지+무광코팅" includes the word coating; could the 46.65 already include coating, making coating counted twice? Or any other double-count across the 4 components?

Q4. LINING FREE + COVER 46.65: Is "면지 무료" (lining contributes 0 — no line item in the 6-item authority formula, members 074/075/076 unprinted) and "cover paper = art150 46.65" well-grounded by authority + price table? Any flaw?

Q5. BINDING-HOLD: With inner-page print BLOCKED, is HOLDING the PRD_000072→PRF binding the correct guard (against under-charging the book's largest line item)? Or could the binding proceed safely some other way?

Q6. FALSE-POSITIVE / FALSE-NEGATIVE GUARD: Of the 4 READY items, is any actually BLOCKED (should not be wired)? Of the BLOCKED/N-A items (inner-print, inner-paper, foil), is any actually READY (wrongly held)? Specifically: is foil really N/A, and is "inner paper" correctly bundled as BLOCKED with inner-print?

Q7. ANY OTHER MONEY-CRITICAL DEFECT you independently find (e.g. quantity multiplication, comp_qty semantics for flat 절가 COMP_PAPER vs per-qty rows, addtn_yn flags, silent multi-row match risk if a dimension is not injected).

End with a one-paragraph OVERALL VERDICT: is this design safe to load (the 4 READY components) and correct to HOLD the binding? List your top money risks ranked.
