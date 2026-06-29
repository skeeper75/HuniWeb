You are an INDEPENDENT 2nd-opinion reviewer of a PRICE-FORMULA (PRF) track design for a Korean
print-on-demand commerce DB. Reach your OWN verdict from the engine code + live data + the design.
Do NOT assume the authors are right. You have read-only repo access — verify by reading code/files.

Read these files yourself:
- _workspace/huni-set-product/06_load/inner-promotion/prf-track-design.md
- _workspace/huni-set-product/06_load/inner-promotion/prf-apply.sql
- _workspace/huni-set-product/06_load/inner-promotion/prf-dryrun.sql
Engine: raw/webadmin/webadmin/catalog/pricing.py  (esp. lines 42-94 NON_QTY_DIMS/_row_matches,
        122-178 match_component, 181-213 component_subtotal/plate_qty, 540-600 _evaluate_formula,
        695-715 derive_inner_sheets + its docstring/intent comment, 718-827 evaluate_set_price)
        raw/webadmin/webadmin/catalog/price_views.py (1696-1726 price_simulate_set derived branch)

================================================================================
## CONTEXT
================================================================================
A set product PRD_000072 (hardcover-musen booklet) is priced by evaluate_set_price: each member
(inner/cover/endpaper) is priced by its own formula via evaluate_price(member, selections, qty), then
the set body's own formula at qty=copies; discount once. An earlier "vessel" load promoted the inner
into a separate member PRD_000284 (its own dims). NOW this PRF track binds 3 price formulas + revives a
disabled component, to make end-to-end pricing correct.

KNOWN DEFECT being addressed (call it DBLPANSU): in price_views.py the derived-qty branch computes
member qty = derive_inner_sheets(copies, pages, pansu) = copies*ceil(pages/pansu) (already ÷pansu),
AND injects selections.plt_siz_cd. Then evaluate_price → _evaluate_formula re-applies
plate_qty(qty, pansu) = ceil(qty/pansu) for any comp whose use_dims contains plt_siz_cd → divides by
pansu TWICE → inner undercharge.

================================================================================
## THE DESIGN'S CLAIMS (verify each independently)
================================================================================
CLAIM 1 — DBLPANSU resolution: The designer concludes DBLPANSU CANNOT be cleanly fixed in data and the
  canonical fix is a ONE-LINE code change to the view: price_views.py:1707
  `eff_qty = derive_inner_sheets(copies, pages, pansu)` → `eff_qty = copies * pages` (unconverted page
  sheets), keeping plt_siz_cd injection, so _evaluate_formula's plate_qty divides by pansu exactly once.
  They REJECT a data-only fix (option b = give the inner its own comps with plt_siz_cd removed from
  use_dims) as over-minting. Their reasoning hinges on: _row_matches (pricing.py:82-94) iterates the
  hard-coded NON_QTY_DIMS tuple (line 42, which includes plt_siz_cd) — NOT the comp's use_dims — so
  removing plt_siz_cd from use_dims does NOT remove it from price-row matching; use_dims only controls
  (1) plate_qty triggering and (2) a "no discriminating dim" note. Therefore data-only would need NEW
  inner-only comps + duplicated price rows (~113-265 rows), violating search-before-mint.

CLAIM 2 — Golden answer: case = A5 inner, duplex-color 100p, single-side-color matte cover, 50 copies.
  Verbatim live unit prices: inner S2 국4절 POPT_000002 tier(1200)=326; inner paper MAT_000073=36.88;
  cover print S1 50=550; cover coat matte 50=700; cover paper art150 MAT_000078=46.65; bind SSABARI
  PROC_000023 50=9000. inner pansu fn_calc_pansu(국4절,A5)=4, cover pansu (spread siz)=1.
  Correct PRICE = 968,432.5 (cover 64,832.5 + inner 453,600 [print 407,500 + paper 46,100] + bind
  450,000). DBLPANSU trap = 695,395.94 (inner collapses to 313 sheets). Verify the arithmetic, the tier
  selection (max min_qty ≤ qty), plate_qty math, no double-counting, cover spread 1-up.

CLAIM 3 — 3 PRF + S2 revive: PRF_HC_INNER (bound to 284: inner print S1+S2 + inner paper COMP_PAPER),
  PRF_HC_COVER (bound to 073: cover print S1 + matte coat + cover paper), PRF_HC_BODY (bound to 072:
  bind ONLY, no inner/cover comp → double-eval guard). S2 (COMP_PRINT_DIGITAL_S2) revived del_yn Y→N;
  claimed side-effect 0 because t_prc_formula_components referencing S2 = 0 rows. Binding (§D) is
  COMMENTED OUT until DBLPANSU code fix + cover spread siz exist. Check: search-before-mint (any
  over-mint? all comps reused?), double-eval guard soundness, S2 revive safety, the S1+S2 both-wired
  trick (does print_opt + comp suffix really select exactly one? does evaluate sum both or just one?).

CLAIM 4 — Residual NO-GO items: CFM-COVER-SPREAD-SIZ (cover spread size not registered → cover would
  use finished A5 4-up = ~3.8x undercharge, so binding blocked); CFM-COVER-A4PLT (A4 cover 3절 절가
  89.54 absent + 3절 impos_yn=N → A4 cover BLOCKED); binding hold justified. Are these correctly
  blocking, or over/under-cautious?

================================================================================
## INDEPENDENTLY JUDGE (verify, don't trust)
================================================================================
1. DBLPANSU final call: Is the view-contract code change (option a) genuinely the canonical fix, or can
   it be solved in DATA without over-minting? Read _row_matches/NON_QTY_DIMS/_evaluate_formula yourself.
   Is removing plt_siz_cd from use_dims viable (what exactly breaks)? Is there a THIRD option (e.g. a
   comp-level flag, passing pansu=1, an inner-specific dim, a different qty contract)? Does changing the
   view break OTHER callers of derive_inner_sheets? Verify the intent comment at ~695-699 actually says
   the caller passes already-converted sheets (i.e. is the docstring itself the bug, or the code?).
   FINAL: is DBLPANSU a DATA-track or a webadmin-CODE-track problem? Is routing it to code correct?
2. Golden recompute: independently recompute the 968,432.5 from the verbatim prices and engine semantics
   (tier rule, plate_qty, component_subtotal unit×qty, set sum, discount). Does it match? Is the trap
   695,395.94 right? Any rounding/tier/pansu error? Is cover spread 1-up and inner 1,250 sheets correct?
3. 3 PRF + S2: any over-mint (vs search-before-mint)? Is BODY=bind-only a sound double-eval guard given
   the body still carries inner dims? Does wiring BOTH S1 and S2 into PRF_HC_INNER cause double-charge
   (both match?) or correct exclusive selection? Is S2 revive truly side-effect-0? Is the commented-out
   binding the right safety posture?
4. Residual NO-GO: are CFM-COVER-SPREAD-SIZ and CFM-COVER-A4PLT correctly blocking? Any residual the
   design MISSED?
5. NEW defects / false-positives introduced by this PRF design.

Output: per-claim (STATUS: CONFIRMED / REFUTED / PARTIAL — WHY with file:line — any NEW finding), then
OVERALL PRF-track GO or NO-GO with the top reasons, and your explicit DBLPANSU DATA-vs-CODE verdict.
Tight, evidence-based, cite file:line.
