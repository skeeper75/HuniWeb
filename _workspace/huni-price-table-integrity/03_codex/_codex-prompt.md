You are an INDEPENDENT 2nd-opinion verifier (codex, read-only) auditing whether an authority price table (Korean acrylic print products) is fully and correctly loaded into a live DB. A separate AI (Claude) already produced a defect board; your job is to reach your OWN conclusions from the raw inputs, then I will reconcile. Be adversarial: find BOTH missed gaps AND false-positives (over-flagged defects). Treat every claim as a HYPOTHESIS until grounded in the files you can read. Do not invent facts.

## What you can read (read-only)
- Authority answer grid (absolute truth, 433 cells): `_workspace/huni-price-table-integrity/01_authority/acrylic-authority-grid.csv` (columns: block,dim_type,axis1,axis2,qty_band,value,note)
- Authority dimension classification: `_workspace/huni-price-table-integrity/01_authority/acrylic-authority-dims.md`
- The LIVE pricing engine source code: `raw/webadmin/webadmin/catalog/pricing.py` — read `match_component` (around line 133), TIER_DIMS/TIER_UPPER (line 47-50), and `evaluate_price`. This is the algorithm that consumes the loaded price rows.

## The 7 authority blocks (from the grid)
- B01 area: transparent acrylic 3T, gates by width(w) x height(h) mm, 14x14=196 cells, SYMMETRIC (w20h30 = w30h20).
- B02 area: transparent 1.5T, 9x9=81 cells, symmetric.
- B03 area: mirror 3T, 9x9=81 cells, each cell = B01 same-coord x2.
- B04a qty_discount: common quantity discount, 6 tiers (0/0.1/0.2/0.3/0.4/0.5).
- B04b addon_option: 26 finishing options across product groups (keyring/badge/magnet/clip/nametag/smarttok/jibbitz/pen/hairband/carabiner-color).
- B05 area: corotto, 6x6=36 cells, asymmetric grid.
- B06 fixed_shape: carabiner 4 shapes fixed price (5800/5800/6300/6900).
- B07 qty_discount: carabiner-only discount, 3 tiers (0/0.1/0.2 cap).

## LIVE LOAD STATE as observed (you cannot query the DB, so treat this observed shape as reported input, but you CAN verify the engine logic against it):
- B01 COMP_ACRYL_CLEAR3T mat_cd=MAT_000043 use_dims=[mat_cd,siz_width,siz_height,min_qty]: only 113 of 196 cells loaded. The 83 missing = ALL w>h (lower triangle). Their symmetric pair (h,w) IS present.
- B02 COMP_ACRYL_CLEAR3T mat_cd=MAT_000042: 52 of 81; missing 29 = lower triangle.
- B03 COMP_ACRYL_MIRROR3T use_dims=[siz_width,siz_height]: 52 of 81; missing 29 lower triangle. ALSO: COMP_ACRYL_MIRROR3T is bound to ZERO formula via t_prc_formula_components (orphan component).
- B04a DSC_ACR_QTY: 6 tiers loaded as dsc_rate percent-scale (0.00/10.00/20.00/30.00/40.00/50.00). Engine assumed to read /100.
- B04b: only 4 of 26 options loaded. keyring has 2/4 (missing 고리없음=0, 은색구슬줄=300). 머리끈 has option item but 0 price rows. badge/magnet/clip/nametag/smarttok/jibbitz/pen/carabiner-color components absent.
- B05 COMP_ACRYL_COROTTO: 21 of 36; missing 15.
- B06: carabiner product PRD_000166 exists but 0 option groups, 0 formula binding, NO fixed-shape price component. Completely unloaded.
- B07 DSC_ACRCARA_QTY: 3 tiers loaded correctly (0/0.1/0.2).

## YOUR INDEPENDENT TASKS — answer each with a verdict + evidence
1. MISSED GAPS: Are there any unload/missing-dimension/mismatch defects NOT in the observed list above that you can infer from the authority grid or engine code? Consider especially: finishing-option product-group attribution, corotto dimension shape, carabiner shape grid, mirror orphan binding, any OTHER orphan or chain break.

2. FALSE-POSITIVES (over-flagging): For each, is it a REAL defect or a legitimate semantic-axis difference?
   a. B01/B02 lower-triangle (w>h) missing cells: READ `match_component` in pricing.py. Does the engine normalize/swap (w,h) so that an order with w>h still resolves to the symmetric (h,w) row? Look at TIER_DIMS, TIER_UPPER, and how siz_width/siz_height tiers are each selected INDEPENDENTLY (lines ~159-179). State decisively: is the lower-triangle absence a real quotation-blocking defect, or does the engine route around it? Show the exact code lines.
   b. Color-degree "통용" (common across degree combos) = single price (no print_opt_cd/clr_cd in price axis): is treating this as a single price correct, or a missed dimension?
   c. The discount 0.1 -> 10.00 percent-scale (engine reads /100): is this a legitimate scale convention or a mismatch defect? What evidence in pricing.py confirms or refutes the /100 assumption?

3. MONEY-IMPACT PRIORITY: Of the 6 money-critical defects (B01/B02/B03 missing cells, B03 orphan binding, B05 missing cells, B06 fully unloaded, B04b under-charge), which is MOST urgent? Compare: mirror orphan (quote-impossible) vs area missing cells (under-charge or quote-impossible) vs B06 fully unloaded. Rank by severity.

## Output format
For each item give: VERDICT (CONFIRM defect / REFUTE=false-positive / NEW gap / UNCERTAIN), short evidence (cite pricing.py line or grid block), and one-line reasoning. Be concise. End with a ranked money-impact list and your single biggest disagreement (if any) with the observed defect list.
