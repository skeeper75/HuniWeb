# Independent review request — print-shop "banner" (현수막/배너) product category option model

You are an independent domain expert. We reverse-engineered a Korean print-shop's
"banner" (현수막/대형 실사 배너) product category to build a base-data (option management)
metamodel. Below is a CONCISE summary of what WE already found. Your job: find what we MISSED.

Do NOT just agree. Give SPECIFIC, CHECKABLE claims (something we can verify against a
live site or product spec), not platitudes. If our model already covers something, skip it.

## Category scope
Large-format banners printed by area (가로 x 세로 면적 기반 가격). Sub-products observed:
plain vinyl banner (현수막/타포린), PET banner, X-banner (스탠드 배너), shoulder sash (어깨띠),
roll-up banner, mesh banner (매쉬), tent-cloth heavy banner (텐트천). Print methods: 수성(aqueous)/
라텍스(latex), inkjet large-format. Input = PDF upload only (no online editor). Single-side print 4-color typical.

## Option AXES we already captured (15-axis metamodel)
1. Material — composite code = TYPE + substrate(타포린/PET/매쉬/텐트천/부직포) + body-color + weight + print-method(aqueous/latex). Materials can be 1 or 2 choices per product.
2. Process / finishing — groups: 재단(cut, mandatory), 코팅(coating, mandatory for PET), 아일렛(eyelet), 각목(wood baton), 큐방(Q-ring/grommet), 로프(rope), 봉제(sewing: hem/line-stitch/edge-stitch), 고리(loops), 추가부자재(extra sub-material e.g. double-sided tape), 포장(packaging). Pure process vs sub-material-consuming process (eyelet = metal ring + punching) distinguished by a flag.
3. Option — pure independent selections (most things split into other axes).
4. Template/SKU — bundle unit (banner + stand = 1 set).
5. Constraint — 6 logic types: disable / force(require) / match / exclude(pick-1) / essential(mandatory) / min-max(range).
6. Base-code/enum — size presets, dosu(color-count) enum, code groups.
7. Category — product tree + multi-classification.
8. Addon — stands/holders as separate finished SKUs (indoor/outdoor types, roll-up holder 600/850/1000 matched to size).
9. Process parameter — qty slot tied to a process (e.g. rope quantity 1-10).
10. Quantity model — dual: ORD_CNT (number of designs/건수) x PRN_CNT (print quantity), plus process-bound qty.
11. Pricing role — each axis tags how it contributes to price (area / multiplier / fixed / unit-matrix). Banner = area-based SizeMatrix2D.
12. Print-method recipe — print method gates allowed processes / file formats / production team.
13. Size — preset enum + non-spec free input (min/max 0-5000mm). work-size = cut-size + 4mm bleed auto. Shape (sash) absorbed into size presets.
14. Body form-assembly — flat->3D assembly (mostly goods; banners minimal).
15. Production type — finished/semi/integrated/ready-made/design, orthogonal to category.

## Material->forced-process rules we found
- PET material -> coating MANDATORY.
- Tent-cloth (thick) -> packaging "rolled" MANDATORY.
- Same substrate splits by print method: 블락아웃PET aqueous(BOP) vs latex(BOPTEX); 텐트천 aqueous(TFC) vs latex(TFL).

## Known gaps we already flagged (don't re-report these)
- nonspec free-size range per material (we have the mechanism).
- holder<->size cascade match (roll-up 600 <-> holder 600).
- area-matrix price with off-grid ceiling (next larger size).
- design-count vs print-quantity dual pricing.

## QUESTIONS — answer each with specific checkable claims
A. OPTION AXES: What order-option axes do banner/large-format print products TYPICALLY offer
   that are ABSENT from our 15-axis list above? (e.g. lamination types, edge finishing variants,
   hanging hardware we missed, indoor vs outdoor durability/ink class, anti-curl, fire-retardant cert.)
B. MATERIALS: What banner substrates / sub-materials / hardware are we likely missing?
   (specific named materials: e.g. specific tarpaulin weights, backlit film, double-sided blockout,
   specific eyelet/grommet sizes, pole-pocket vs eyelet, bungee/zip-tie, etc.)
C. PROCESSES / FINISHING: What finishing/post-processes for banners are we missing?
   (welded hem vs sewn hem, pole pockets/sleeves, reinforced corners, wind slits/vents,
   heat cutting, contour cutting, etc.) — and what ordering/sequence dependencies exist?
D. CONSTRAINTS / EDGE CASES: What edge cases or variant patterns would BREAK an area-based
   size-matrix pricing model for banners? (e.g. max printable width vs roll width / seams/welds for
   oversize, min charge, double-sided print doubling, mesh wind-load, weight-based shipping.)
E. DOMAIN FACTS: What industry-standard domain facts about large-format banner production should
   inform a base-data schema that our model may not encode? (material weight units gsm/oz,
   resolution/DPI, ink type vs material compatibility matrix, ICC/color, finishing lead-time tiers,
   indoor/outdoor lifespan, grommet spacing standards.)

Be concise but specific. Group your answer by A/B/C/D/E. For each item state: the claim + why it
matters for an option/base-data schema + (if known) how it is usually modeled.
