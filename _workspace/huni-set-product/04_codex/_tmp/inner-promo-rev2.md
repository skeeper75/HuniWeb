You are an INDEPENDENT 2nd-opinion reviewer (round 2) of a CORRECTED PostgreSQL data-load
design for a Korean print-on-demand commerce DB. Reach your OWN verdict. Do NOT assume the
authors fixed things correctly — verify against the engine code and the actual SQL.

You have read-only access to this repo. Read these CORRECTED files yourself:
- _workspace/huni-set-product/06_load/inner-promotion/inner-promotion-design.md  (esp. §3.5, §5.3, §6)
- _workspace/huni-set-product/06_load/inner-promotion/apply.sql
- _workspace/huni-set-product/06_load/inner-promotion/dryrun.sql
- _workspace/huni-set-product/06_load/inner-promotion/inner-size-authority.md
Engine: raw/webadmin/webadmin/catalog/pricing.py (lines ~395-580, 702-827),
        raw/webadmin/webadmin/catalog/price_views.py (lines ~1501-1726)

================================================================================
## BACKGROUND: what this load does
================================================================================
A set product PRD_000072 (하드커버책자 / hardcover-musen booklet) is composed of semi-product
members in t_prd_product_sets. The pricing engine evaluate_set_price prices each member by its own
formula (evaluate_price) with a caller-supplied qty, then adds the set body's own formula at qty=copies.
The inner (내지) was previously embedded in the body, causing inner-print undercharge because the body
formula only sees copies (no page multiplication). The fix promotes the inner into a separate
SEMI_ROLE.01 member (PRD_000284) so the view can pass qty = derive_inner_sheets(copies,pages,pansu).
This load builds only the "vessel" (product + dims + sets row); PRF (price formula) minting is a
SEPARATE later track explicitly OUT of scope here.

A round-1 review raised these 3 blockers; the authors claim to have corrected them:
- BLOCKER 1 (A5 soft-delete): round-1 spec copied SIZ_000170 (A5) and SIZ_000172 (A4) onto the inner;
  SIZ_000170 is logically deleted (del_yn=Y) at the size master, and _set_members_meta does not filter
  master del_yn, so a dead size would surface. CLAIMED FIX: replace inner sizes with canonical active
  twins SIZ_000007 (A5, del_yn=N) and SIZ_000050 (A4, del_yn=N, note "책자내지"), with a 4-source
  authority analysis (inner-size-authority.md); price impact claimed 0 (siz_cd not in any inner comp's
  use_dims); new dryrun assert P1-e.
- BLOCKER 2 (채번 race): round-1 used hard-coded PRD_000284 + WHERE NOT EXISTS, so a foreign PRD_000284
  could get dims/sets attached. CLAIMED FIX: pg_advisory_xact_lock + exact-match abort (prd_typ/semi_role/
  prd_nm) + MAX re-assert (=283) + a second 의미 guard before dims; disp_seq changed from +1 to CASE
  target-assignment (idempotent under partial failure).
- BLOCKER 3 (double pansu-conversion, Critical): the view passes qty=derive_inner_sheets (already
  ÷pansu) AND injects plt_siz_cd; then _evaluate_formula re-applies plate_qty(qty,pansu)=ceil(qty/pansu)
  for plt_siz_cd comps (S2/COMP_PAPER) → divides by pansu TWICE → ~1/pansu undercharge. CLAIMED
  "FIX": this is declared a PRF-track pre-req (NOT a vessel-stage issue), documented in design §3.5
  guard② with two candidate solutions (a) pass member qty = copies×pages, or (b) inner comp use_dims
  drops plt_siz_cd — explicitly left undecided for the PRF track and flagged "codex re-verify". §5.3
  now shows both the correct 412,500 and the trap 313판.

================================================================================
## INDEPENDENTLY JUDGE (your own verdict — verify, don't trust)
================================================================================
1. BLOCKER 1 resolved? Read inner-size-authority.md + apply.sql (B-1) + dryrun P1-e. Are SIZ_000007/
   SIZ_000050 genuinely the right canonical active sizes? Is the "price impact = 0" claim sound (check
   inner comp use_dims for siz_cd)? Does P1-e actually catch a soft-deleted size? Any NEW problem from
   the swap (e.g. work-size / pansu differences between SIZ_000170 and SIZ_000007 that change판수,
   margin/impos differences, A4 default disp_seq)? Is using SIZ_000007 whose note says "적용=엽서"
   (not 책자) for a booklet inner a defensible choice or a leap?
2. BLOCKER 2 resolved? Read apply.sql chaebeon guard + inner_guard + disp_seq CASE. Is the advisory
   lock + exact-match abort + MAX re-assert actually robust? Any hole (e.g. lock scope, the guard runs
   inside the same txn as the INSERT?, the CASE idempotency, what if MAX≠283 because a LATER prd exists,
   does the exact-match abort cover the dims/sets attachment path)? Is the disp_seq CASE truly idempotent
   across the dryrun 2-pass and under partial failure?
3. BLOCKER 3 handoff sufficiency: Is declaring DBLPANSU a PRF-track pre-req (NOT a vessel issue) CORRECT,
   or does the vessel stage itself need to do more? Specifically: the vessel registers plate_sizes
   (국4절) on the inner and the sets row. Does shipping the vessel with国4절 plate + a derived-qty sets
   row pre-commit the PRF track into the double-conversion trap, or is the handoff guard② (candidates
   a/b, undecided) an honest and sufficient hand-off? Is there anything the vessel could/should encode
   now to make the trap impossible (vs. leaving it to PRF design)? Verify the code claim (view 1707-1709
   sets eff_qty=derive_inner_sheets AND sel[plt_siz_cd]=plate; pricing.py 561/574 re-divides).
4. NEW defects / false-positives introduced by the corrections? (e.g. the 의미 guard aborts legitimate
   idempotent re-runs? the CASE breaks if a member was soft-deleted? P1-e hard-codes the expected
   size set and would fail a legitimate future change? advisory lock hashtext collision? the smoke
   now reports S2 header del_yn=Y — does that change the vessel verdict?)
5. VESSEL-STAGE GO or NO-GO (for the structural load only, given PRF minting is a separate gated track)?
   List the top blocking reasons if NO-GO, or the residuals if GO. Be explicit whether each round-1
   blocker is now CLOSED, PARTIALLY-CLOSED, or OPEN.

Output: per-issue (STATUS: CLOSED/PARTIAL/OPEN — WHY — any NEW finding), then OVERALL vessel-stage
GO or NO-GO with reasons. Tight and evidence-based, cite file:line.
