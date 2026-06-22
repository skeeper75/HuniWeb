# Deep-Augmentation Consult — RedPrinting ST(스티커) category reverse-engineering

You are an independent expert reviewer (OpenAI model) giving a SECOND OPINION on a print-domain
option-management metamodel reverse-engineered from RedPrinting (redprinting.co.kr, a Korean print
e-commerce site). The team has already produced a deep analysis. Your job: **find what they MISSED**
— option axes, materials, processes, management axes, constraints, edge cases, domain facts that
the analysis did NOT surface. Be ADVERSARIAL and SPECIFIC. Generic platitudes are useless.

## Context: what the team is building
A "base-data management metamodel" — how a print shop should normalize its catalog into management
axes (material / process / option / template-SKU / constraint / base-code / category + DISCOVERED
extra axes). RedPrinting is a validated reference model. The goal is a schema "vessel" for the
client (Huni Printing). The team samples representative products per category and abstracts a
metamodel, then gap-checks against Huni's live DB.

## Current metamodel state (17 axes after ST)
7 base buckets: material(#1), process(#2), option(#3), template/SKU(#4), constraint(#5),
base-code/enum(#6), category(#7).
Discovered distinct axes: addon(D-1/#8), process-parameter(D-4/#9), quantity-model(D-5/#10),
pricing-role(D-6/#11), print-method-recipe(D-7/#12), size(#13), body-form-assembly(D-10/#14),
production-type(D-9/#15), design-input-channel(D-11/#16), **shape(D-12/#17 — NEW from ST)**.

ST broke a claimed "16-axis saturation" (PR had added 0 distinct axes, suggesting the model was
saturated). ST introduced exactly ONE new distinct axis: **shape(#17)**. The team adversarially
judged 4 ST distinct-candidates: ① shape = distinct(#17) · ② cutting-mechanism = facet of process ·
③ cut-granularity(half-cut/full-cut) = facet of process · ④ adhesive/weatherability = facet of material.

## ST category key findings (the team's analysis)

### Shape(#17) — the new distinct axis
- `option_info.shape_info` holds shape enum SQ(square)/CL(circle)/EL(ellipse)/RC(rounded-rect)/FR(free-form)
  as a DEDICATED slot separate from size.
- Shape→size is 1:多 (one CL circle shape spans cut-dies CL001~CL010 = 10X10~100X100mm; RC spans RC001~RC025).
- STDCFBR (fabric deco sticker) holds ALL 5 shapes in one product = shape superset.
- Shape gates cutting: FR→THO_GRA(free die-cut following design outline=도무송), SQ/CL/RC→THO_DFT(preset cut-die).
- Prior categories (BN/GS/TP/PR) absorbed shape into size as 1:1 cut-die presets; ST shows 1:多 so shape
  becomes distinct. Huni KB G-SK-2 confirms "shape enum has no home axis" — live schema has NO shape
  column/table/enum (vessel-gap).

### Cutting & cut-granularity (judged = process facet)
- THO_GRA(free die-cut/도무송) vs THO_DFT(preset cut-die enum: circle CL001~010, rounded RC001~025).
- CUT_DFT: DFXXX 묶음재단(batch-cut = kiss-cut sheet, half-cut to peel off) / DFITM 개별재단(full-cut singles).
- "반칼"(half-cut/kiss-cut) = batch-cut default; live processes PROC_000053 완칼(full-cut)/000054 반칼(kiss-cut)/
  000055 스티커완칼 exist. NOTE: free die-cut(도무송) has NO dedicated process row in live.

### Adhesive/weatherability materials (judged = material composition facet)
- 26-material enum on one product: 일반 art-label / 초강접(extra-strong) / PET투명(transparent) / 리무버블(removable) /
  유포(synthetic-paper outdoor) / 금은동(metallic) / 한지(traditional paper) / 자석(magnet) / 저온(low-temp freezer).
- Adhesion+weatherability encoded BOTH as material-variant AND as specialized products (STRMDFT removable,
  STOTDFT outdoor, STMADFT magnet, STLTDFT freezer, STBKDFT motorcycle/vehicle PVC).
- Team proposes material composition adds adhesion_grade + weather_grade decomposition axes.

### Print-method branching (judged = print-method-recipe #12 facet, joins PR)
- General(STTH*/STCU*) digital_price / UV(STPAU*) / DTF heat-transfer(STPAD*) vTmpl_price / 후지(STBPDFT photo-print).
- DTF: single dedicated film material, dosu hidden, PRT_WHT white-underbase FORCED(ESN_YN=Y), vTmpl_price engine.

### Other facets
- Plate-sticker(판) vs die-cut: 판 = fixed sheet size 140X200/A4, per-sheet, vTmpl_price = SKU-like; die-cut = free
  size + cut-die + digital_price.
- White underbase PRT_WHT: optional for normal / forced for DTF (transparent/fabric base).
- disable_pcs 227 rules (26 materials × finishings; special materials disable coating/foil/emboss/perforation).
- Numbering NUM_DFT (serial number variable print) — could be process or VDP.
- Tape/band/card-sticker (STTPMSK masking tape roll, STTPBND band) = complete-SKU form (not die-cut, not plate).

### 33-product cross-tag groups
A 형상/칼선(8) · B 패브릭/다양한모양(4) · C 점착특화(7: removable/outdoor/freezer/magnet/motorcycle/scratch) ·
D 특수후가공/고급소재(5: foil-emboss/금은동formed/metal/Gmund premium-paper/한지) ·
E 인쇄방식(8: UV/DTF/후지/수정correction) · F 기타완제(4: card-sticker/띠부/masking-tape/band).

### Gap analysis verdict (vs Huni live DB)
- Shape #17 = GAP (vessel-gap, new — live has 0 shape column/table/enum).
- Cut-granularity(S-3) = PASS (PROC_053/054/055 exist live).
- Adhesive(S-4) = WEAK (= existing material decompose-axis gap; ST materials are in clean MAT_TYPE.11 bucket).
- disable(S-8) = WEAK (logic jsonb can hold scale, but RULE_TYPE only 3, no disable type).
- Print-method(S-5) = GAP (= existing #12 gap; no PrintMethod entity).

## YOUR TASK — answer these adversarial gap-finding questions. Be specific & checkable.

**Q1. Is there an #18 distinct axis hiding here?** The team found exactly ONE new axis (shape) and
forced everything else to facet. Adversarially: is there a management axis ST exhibits that genuinely
canNOT be absorbed by the 17 existing axes without distortion? Candidates to scrutinize: cut-granularity
(half/full-cut), adhesive-class, print-method (could it be more than #12 facet?), numbering/VDP, plate-vs-die-cut.
For each, say distinct-or-facet AND why, with the distinctness test (unique attribute/lifecycle/relation
that no existing axis holds). If NO #18 exists, say so plainly — do not invent one to please.

**Q2. Did they mis-judge any of the 4 distinct-candidates?** Especially: is "shape" really distinct, or
is it a facet of cut-die/size that they over-promoted (over-fitting on one category)? Conversely, is
cut-granularity or adhesive WRONGLY demoted to facet when it deserves distinct status? Give the
strongest counter-argument to each judgment.

**Q3. What ST-typical options/materials/processes/constraints are ABSENT from this analysis?** Think as
a sticker-printing domain expert. Examples to probe (verify against what's listed): lamination types
(gloss/matte/soft-touch/holographic), substrate finishes, application/transfer types (transfer tape,
application-paper), corner-rounding, bleed/safe-area rules, color-profile/CMYK-vs-spot, varnish/spot-UV
nuances, anti-counterfeit features, weeding(scrap removal), reverse/mirror print for window-stickers,
roll vs sheet delivery, minimum-cut-size constraints, gap-between-stickers on sheet, registration. Name
specific ones the team did NOT mention and which management axis each would belong to.

**Q4. Domain facts / edge cases the team may have wrong or missing.** E.g. is "반칼=kiss-cut, 완칼=full-cut"
correct? Is DTF white-underbase always forced? Is 도무송(Thomson) die-cut the same as free-form contour cut?
Are there sticker types (e.g. dome/epoxy stickers, security/void stickers, thermal/heat-sensitive, glow-in-dark,
reflective) the analysis missed? Any constraint cascade (material→finishing) that is industry-standard but absent?

For EACH item give: (a) the specific claim, (b) which pipeline stage should verify it
(reverse-engineer / metamodel-architect / gap-analyst / vessel-designer), (c) HOW to verify it
(RedPrinting live page / Huni live schema / Huni Excel / domain reference). Prefer checkable claims.
