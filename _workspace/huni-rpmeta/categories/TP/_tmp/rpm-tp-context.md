# TP (Design-Template) category — deep-check consult context

You are an independent senior print-domain + commercial-print-MIS architect giving a SECOND OPINION.
We reverse-engineered RedPrinting's "design-template" product category (TP, 23 products) to build an
"option-management metamodel" and to design DB "vessels" (schema axes) for a Korean print shop (Huni).
Below is OUR analysis. Your job: find what WE MISSED — option axes, materials, processes, management
axes, constraints, edge cases, and domain facts that our pipeline did NOT surface. Be SPECIFIC and
CHECKABLE (claims we can verify against a live site / spreadsheet / DB), not platitudes. If something is
already covered below, do NOT repeat it as "new". Push for things genuinely absent.

## What TP is (RedPrinting design-template category)
TP = print products where the differentiator is HOW THE DESIGN IS INPUT (editor channel + template
assets), not the substrate/finish. Same server base-data schema as other categories; the difference is a
flag bundle in `product_option.option`. 23 products: design business cards, design coupons, design
wristbands, design slogans, tickets (M/I/boarding), foil tickets, design calendars (desk/wall-hole/
wall-hanging/eco/big filial/scheduler), postcard-book, photo-book, photocard-white, wobbler, premium
memo-pad (떡메), premium sticky-memo (점메), table-setting paper, name-sticker, package-sticker,
deco-paper, award certificate (상장).

## Editor channel (the TP essence — encoded as flags, orthogonal to option tree)
- `item_gbn`: vDigital_item (KOI editor) / edicus_item (Edicus SDK, VDP) / offset2023_item (no editor, PDF only)
- flags: useKoiEditor, useRPEditor, useTemplateDownload, usePDF, usePDFordCnt/useEditorOrdCnt,
  koi_template_resource_id, koiOption[]
- Direct twin proof: same "desk vertical calendar" = TPCLSTD(TP, KOI editor + ready templates) vs
  HLCLSTD(non-TP, offset, PDF only). Material/size/finish/price IDENTICAL — only the design-input layer differs.
- Price proof: design editor/template contribute PRICE=0; price = print/material/finish only.

## Our 16-axis metamodel (3 product groups: BN area-banner / GS finished-goods / TP design-input)
7 static: material, process, option, template/SKU, constraint, base-code/enum, category.
4 relational: addon, process-parameter, quantity-model, constraint-logic-type.
2 cross-cutting: pricing-role, print-method-recipe.
GS new: production-type (#15), body-form-assembly (#14).
TP new: #16 DESIGN-INPUT CHANNEL (distinct). + size axis (#13).

## TP-specific facets WE already judged (NOT new — do not repeat):
- Template asset (koi_template_resource_id) = facet of #16 (editor design proofs), kept SEPARATE from #4
  template/SKU which is a finished-order bundle (봉투/OTC). Double-meaning split flagged HARD.
- VDP (setVariableData / variable data print) = #16 data-binding facet x quantity. Candidates: name on
  business card, awardee name on 상장.
- Page hierarchy INN_PAGE (calendar months 2~200, book signatures) = quantity-model slot + min/max/step.
- Ticket form variant (M/I/boarding), calendar form (desk/wall) = size preset + die-cut process.
- Special print PRT_WHT (white underbase) / PRT_MAG (metallic) / foil (FOI) / 미싱(perforation) /
  numbering = process axis (numbering may be VDP). "별색=공정" (spot color = process), not material/ink.
- Double quantity: ORD_CNT (design count) x PRN_CNT (print count), usePDFordCnt-linked.

## Gap verdicts vs Huni live DB (information_schema, read-only 2026-06-17):
- #16 design-input channel = GAP (vessel-gap). Huni `t_prd_products` has only `editor_yn` + `file_upload_yn`
  booleans. No item_gbn / editor-type enum / template_resource_id / VDP columns or tables anywhere.
- Template asset (T-A) = WEAK (no dedicated grail; risk = mapping TP design proofs into `t_prd_templates`
  which is finished-SKU 봉투 — semantic pollution).
- Page hierarchy = PASS (t_prd_product_page_rules exists).
- Special print / foil / white = PASS (PROC_000007 spot, 008 white, 009 clear, 033~049 foil exist).

## Vessel proposals (design-stage, not loaded):
- V-10 (P1): design-input-channel grail — EDITOR_CHANNEL enum + product columns
  (design_input_channel_cd, template_resource_id, ord_cnt_source, vdp_yn) + TemplateAsset table + VDP schema.
- V-11: TemplateAsset table separate from t_prd_templates (avoid double-meaning pollution).

## Open unobserved items we already know about (NOT new):
template asset catalog, VDP variable schema (koiOption[] empty when not logged in), ticket numbering rule,
INN_PAGE-to-price coupling.

## DELIVER — gap-finding questions (answer each with SPECIFIC, CHECKABLE claims):

Q1. EDITOR/TEMPLATE management axes we missed. What management axes/options/constraints does a
print-shop design-template/online-editor product line TYPICALLY have that are ABSENT from our 16 axes? Think:
template category/tag taxonomy, design-proof/approval workflow (시안 confirmation, 교정 round limits),
design reuse on reorder (saved design / my-design library), font/asset licensing & embedding, multilingual
text, color-profile/bleed/safe-zone validation in editor, image DPI/resolution gating, page/spread model
for books, master pages, layer/object limits, watermark/preview vs print-ready export, design fee vs free
template, copyright/stock-asset metadata. For EACH: is it an option axis, a constraint, a process step, or
a workflow-state axis? Which are genuinely NOT in our list?

Q2. STRUCTURALLY-DIFFERENT TP products our 3 samples (design business card / ticket / desk calendar)
missed. Of the 23, what unique axes do these likely add: award certificate (상장 — certificate-frame/seal/
gold-foil/serial?), deco paper (데코페이퍼 — repeat-pattern/roll?), table-setting paper (세팅지 — placemat
sizing/food-safe?), postcard-book (엽서북 — perforated tear-out + binding?), photo-book (사진북 — spread
editor / lay-flat binding / cover wrap?), photocard-white (white-ink layering), name/package sticker
(kiss-cut vs die-cut, sticker sheet layout, roll vs sheet), wobbler (와블러 — spring/adhesive arm),
premium memo/sticky pad (padding glue / tear count)? Name the axis each adds and whether our metamodel
already has a slot for it.

Q3. Errors/omissions/alternatives you see in our axis system. Specifically: (a) Is "design-input channel"
correctly distinct, or should editor-channel and template-asset-catalog be TWO axes? (b) Is page-hierarchy
really just a quantity slot, or is there a spread/imposition axis we collapsed wrongly? (c) Is approval/
proof workflow a missing STATE axis (order lifecycle) orthogonal to all 16 — print order = design →
proof → approve → produce? (d) Does VDP need its own data-schema axis (variable fields, data-feed CSV
mapping) rather than being a facet? (e) Any axis that breaks when a product is BOTH editor-input AND
PDF-upload (TPCLECO has both useKoiEditor=Y and usePDF=Y)?

Q4. Domain facts a design-template product line normally encodes that we did not mention. e.g. editor
template versioning, template-to-product binding rules, print-ready preflight rules, ICC/overprint for
spot/white/foil layering order, calendar start-month/year as editor-internal vs option, lamination/coating
interaction with editor preview, minimum-resolution per output size, proof-PDF watermarking, reorder design
retention period, GDPR/PII for VDP name data, food-contact certification for table-setting paper, archival/
lightfastness for awards/certificates, perforation/microperf specs for tickets, numbering sequence rules
(start number, increment, prefix, check-digit).

Format: numbered list per question. For each finding: a one-line CHECKABLE claim + WHERE to verify
(redprinting live editor / Huni admin / Huni live DB / spreadsheet / general print-domain fact). Mark any
claim you are UNSURE about as [uncertain]. Be concise — bullet claims, no preamble.
