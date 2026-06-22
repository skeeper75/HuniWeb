You are an independent print-domain data-modeling reviewer. I will give you evidence about one product category from RedPrinting (a Korean print-on-demand site) and the accumulated 17-axis option-management metamodel a separate team has built. You must render YOUR OWN verdict. I am deliberately NOT telling you the other team's conclusion — do not try to guess and agree with it; reason from the evidence only.

# The accumulated 17-axis metamodel (frame — these axes ALREADY EXIST)
Among the 17 management axes already in the dictionary, the relevant ones:
- #2  공정 (Process) — die-cutting(도무송), creasing/scoring(오시), folding(접지), embossing(형압), perforation, coating, foil(박). A box's cut-line/crease-line is a process facet.
- #6  도수 (print color count, e.g. 단면/양면 = single/double sided).
- #7  카테고리 (Category — product taxonomy / product-code split).
- #8  부속물 (Addon — handle, ribbon, divider, insert via product_addons / templates BOM).
- #13 사이즈 (Size) — t_siz_sizes carries work_width/height, cut_width/height, margin_top/bot/lft/rgt in a SINGLE row. So one size row already holds BOTH the cut dimensions AND the work (bleed) dimensions AND margins.
- #14 형태가공 (Form-processing) — where RP itself transforms flat->3D (e.g. sewing a pouch). This is a POSITIVE axis only when RP produces the 3D form.
- #16 TemplateAsset — the design template the editor loads (artwork file, price 0, a design-seed resource), table t_prd_templates (tmpl_cd, base_prd_cd, tags).
- #17 형상 SHAPE — a dedicated shape_info slot (was promoted earlier for stickers, which had a dedicated 1-to-many shape slot AND a KB defect where shape fit no existing axis).

The team uses a HARD promotion rule for a NEW distinct axis: BOTH must hold — (1) a dedicated option slot is OBSERVED live, AND (2) the huni knowledge-base has a real defect (existing axes cannot hold it without distortion). If an existing axis absorbs it without distortion -> ABSORBED (not a new axis).

# Evidence: OT (boxes / packaging), 7 products, 6 captured live read-only 2026-06-19
Capture mechanism: /product/item/OT/{code}/detail renders a legacy SSR <select> form (NO Vue infoCall). Option model = same slots as flat print products.

## Box products (OTPKCAK cake box, OTPKFLT flat box, OTPKHMN half-moon box, OTPKENV envelope box, OTPKARP gift box)
All 5 boxes have IDENTICAL option slots:
- paper (e.g. BV box board — single fixed choice)
- paper_sub_select (weight, e.g. 350g — fixed)
- sodu (print sides — single fixed for boxes)
- size (a PRESET dropdown, e.g. "cake box small (495 X 280)", "(med) (553 X 296)", "(large) (694 X 336)")
- number2_sel (design count) / number1_sel (quantity)
Differences between the 5 boxes are ONLY the size-preset labels/dimensions (flat / half-moon / envelope / lid / wing etc.).
Displayed spec TEXT for OTPKCAK: "product-size 130 X 105mm (height:80mm) / cut-size 485 X 270mm / work-size 495 X 280mm". The "product-size" (3D product W x D x H) is DISPLAY TEXT only — the user only SELECTS the size preset (whose bracketed value = work-size = the flat unfolded die-cut sheet dimension). The 3D dimension is derived/display, not a selectable option.
optBlock text on OTPKCAK: "ships folded flat, please assemble into a box" — RP produces only the flat (die-cut + scored) sheet; 3D assembly is done by the customer.
specKw counts on captures: {crease:1, size:11, height:4, coating:2, foil:2, paper:3}.
Box dieline artwork: provided via makers.redprinting.net/v1/templates/{code} + /editor (the editor design-seed = a TemplateAsset the editor downloads). makers response surface for OTPKCAK = {list:[{template_uri (a gcs JSON pointer), layout_uris:[], unresolved_font_group_ids:[], resource_id, token}]} — NO fold-line/glue-tab coordinates, NO cut/crease/perf line-type fields, NO CAD export field on the response surface (the actual dieline geometry, if any, would be inside the gcs JSON the template_uri points to — not observed).

## Non-box (OTPOCLP clapper = a flat hand-held cheer picket, NOT a box)
Slots: paper [2 choices], paper_sub [300], sodu [double-sided], size [single], coating-finish [coating both/matte/gloss — absent on boxes; price = print 31,100 + finish 10,600 separate add-on sum], number2/number1. specKw die-cut-line:1 (die-cut hand-shape). Cascade: one paper disables coating; >500ea routes to a separate offset product code.
(OTCPHOL air-holder cup-holder: NOT captured — unobserved.)

# YOUR INDEPENDENT VERDICT — answer each explicitly
1. NEW-AXIS or ABSORBED: Does this box/packaging category introduce a genuinely NEW distinct management axis beyond the existing 17 — specifically a "dieline / structural-net" (unfolding-structure) axis — OR do the existing axes absorb it without distortion? Give NEW-AXIS or ABSORBED + reasoning against the promotion rule (dedicated slot OBSERVED? KB defect?).
2. Are the box dieline / 3D box dimensions (W x D x H) / die-cut knife / glue-tab joining a NEW management axis, or are they values/expressiveness of the existing Size #13 / Process #2 / Shape #17 / TemplateAsset #16 axes? Map each to where it belongs.
3. Soundness flags: any sign of fabrication, overfit (an axis only one product needs without clean generalization), or an implausible gap/PASS judgment against print-domain expectation in this analysis?

Be decisive. If you think a new axis IS warranted, say so plainly — do not hedge to match an assumed answer. Output a short structured verdict.
