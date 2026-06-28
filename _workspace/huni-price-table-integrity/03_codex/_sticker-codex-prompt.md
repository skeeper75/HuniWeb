# Independent cross-verification task — sticker price-table load integrity

You are an INDEPENDENT 2nd-opinion verifier (gpt-5.5, read-only). Another analyst (Claude)
audited whether the authority Excel price-grid for the "sticker" sheet was loaded into a
live PostgreSQL DB without missing/wrong cells. You must reach your OWN independent verdict.
Do NOT defer to the other analyst's confidence — confirm, refute, or find what they missed.

## What "correct load" means (3 defect types)
1. MISSING CELL — an authority price cell has no matching live unit-price row (sparse grid).
   Symptom: quote = no_match / 0 / minimum-price.
2. DIMENSION GAP — an authority price axis (size/material/qty tier) is absent from the live
   pricing dimension rows, so the customer can't select it / engine can't resolve it.
3. CONFORMANCE MISMATCH — loaded value ≠ authority, or material/size code mis-bound, or a
   display↔actual mis-load.
Also guard against FALSE-POSITIVES: a legitimate non-price axis difference flagged as a defect
(e.g. shape = cutting option not a price axis; coating = material-variant; same-price material
groups; tattoo/pack bundle = fixed total). Flag any over-detection you find.

## Authority grid facts (260527 인쇄상품가격표 "스티커" + "합판도무송스티커")
- Total 1089 authority price cells. Source = sticker-authority-grid.csv (block,product_group,
  dim_type,price_model,siz_label,mat_group,mat_codes,qty_band,value,source,note).
- Price models: only TWO. (A) fixed-price by discrete siz_cd (B01~B04 + GANGPAN, 1084 cells);
  (B) pack/set fixed total "합가형" (.02) (tattoo B05/B06, sticker-pack B07, 5 cells).
- B01 "반칼 자유형/규격" = the SHARED price table: siz(6 sheet-sizes)×material-group×qty(36 tiers).
  - 6 siz_labels: A5_124x186_4판, A4_2판, A3_1판, 90x190_6판, 100x148_8판, 90x110_12판.
    These are imposition (판걸이) sheet sizes — NOT the product display size (A6/A5/A4).
  - 3 material GROUPS expand to 7 materials at SAME price within group:
    grp1 = MAT153유포/MAT084비코팅/MAT242미색 (same price)
    grp2 = MAT155무광/MAT156유광 (same price)
    grp3 = MAT162투명/MAT163홀로그램 (same price)  ← grp3 holds BOTH transparent AND hologram.
  - 36 asymmetric qty tiers (1,2,3,4,5,6,8,10,15,20,...,500,100000). verbatim only, no interpolation.
- B02 낱장(완칼) = siz5(A4/B4/A3/B3/A2)×qty6, single material (유포지+엠보). 판걸이 무관.
- B03 낱장 투명 = siz5×qty6, single material (투명전용지). 판걸이 무관.
- B04 대형(완칼) = siz1(400x600)×qty6, single material.
- B05/B06 타투 = 90x190, 기본가2000 + 3장당4000 + 1000장4000 → set fixed (합가형 .02). "기본가 2000" semantics unresolved.
- B07 스티커팩 = 75x110, 54장1세트=4000 (qty 1~1000 all 4000) → set fixed (합가형 .02).
- GANGPAN (합판도무송) = shape(siz_cd)×mat-group2×qty5. 37 shapes (원형11+정사각12+직사각14).
  - mat-group2: grpA = 비코팅/무광코팅/유광코팅 (same price); grpB = 유포/투명데드롱/은데드롱 (same price).
    => 6 materials total, but authority table only lists 2 group columns (same price within group).
  - qty 5 tiers: 1000/2000/3000/4000/5000.

## Live DB shape (as reported by the SELECT-based audit — treat as OBSERVED input, not yet truth)
- 16 products PRD_052~067, 4 formulas: PRF_STK_FIXED (052~064), PRF_STK_PACK (065),
  PRF_GANGPAN_FIXED (066), PRF_STK_TATTOO (067). 16/16 bound, 1 comp per formula.
- COMP_STK_PRINT use_dims=[siz_cd,mat_cd,min_qty], 2694 rows. Materials present: 153/084/242/155/156/162/163 (7).
- COMP_GANGPAN_PRINT 370 rows = 37 siz × mat{084,153} × 5 qty (only 2 of 6 materials present in price rows).
- min_qty: 36 tiers verbatim. siz_width unused (0 rows) = discrete siz_cd, not area grid.
- Live findings reported:
  * MAT163(홀로그램) unit-price rows exist only on siz {059,060,518,519}. Product PRD_054(홀로그램)
    binds siz {170,172,196} → those have NO mat163 row.
  * PRD_055(낱장유포) product material = MAT154, but COMP_STK_PRINT has 0 rows for mat154 (낱장 rows use 153/084/242).
  * PRD_056(낱장투명) product material = MAT243, but transparent price rows use mat162; 0 rows for mat243.
  * PRD_057(대형) product material = MAT154; SIZ_199 only has mat153 (16000), 0 rows for mat154.
  * PRD_052(반칼 A4) binds SIZ_172 (a 낱장/완칼 key, note="낱장(완칼) A4"); SIZ_172 holds only mat{153,162} at 6 tiers,
    mat153 qty1 = 4000 (낱장 price). The rebar A4 should be SIZ_520 → 5000 (so 052 is undercharged -1000/sheet,
    and 084/155/156/242 give no_match on SIZ_172).
  * PRD_053(반칼투명) binds siz{170,196} for mat162 → 0 rows (only SIZ_172 matches, 낱장 6-tier).
  * SIZ_196 (A6) = 0 rows entirely across COMP_STK_PRINT. SIZ_058 (100x140) = 0 rows.
  * GANGPAN: COMP_GANGPAN_PRINT distinct mat = {084,153}; but PRD_066 product offers 6 materials
    (084/153/155/156/170/171). Selecting 155/156/170/171 → no_match on each of 37 shapes.
  * COMP_STK_TATTOO = 1 row (min3, 4000); 기본가2000 not represented.
  * MAT154 product-material del_yn observed = N (active), even though an earlier design verdict
    had marked mat154 del_yn=Y and recommended rebinding to 153.

## Your questions (answer each independently; cite authority facts above)
For each of these claims by the other analyst, give: CONFIRM defect / REFUTE (false-positive or wrong) /
or "needs live re-measure" — and WHY (from authority grid logic + engine semantics):

Q1. STK-D01: PRD_054 holo is no_match because it binds siz{170/172/196} but mat163 rows exist
    only on {059,060,518,519}. Is this a real load defect? (Note grp3 holds mat162 AND mat163 at
    same price — does authority require mat163 rows on the bound sizes?)
Q2. STK-D08/09/10: PRD_055→MAT154, PRD_056→MAT243, PRD_057→MAT154 product-material bindings vs
    price rows that only carry 153/162. Are these conformance mismatches (wrong material code bound)?
    Or could the price rows be missing instead? Which is the right correction?
Q3. STK-D03+D04: PRD_052 rebar A4 bound to SIZ_172 (낱장 key) → undercharge 4000 vs 5000 and
    4-of-5 materials no_match. Real defect? Is SIZ_172↔SIZ_520 the right root cause?
Q4. STK-D02: PRD_053 transparent siz{170/196} = 0 mat162 rows. Real missing-cell defect?
Q5. STK-D13 (GANGPAN 6-material): authority has 2 same-price groups; live has only mat{084,153};
    product offers 6. Is the collapse a FALSE-POSITIVE (same price so 2 reps enough) or a REAL
    defect (customer offered 155/156/170/171 → no_match)? Key question: does no_match depend on
    whether the engine resolves material to the group-representative, or on the exact mat_cd row?
Q6. Confirm-needed items (NOT defects, authority gives no price): SIZ_196 A6 (052/053/054),
    SIZ_058 100x140 (062/063), tattoo 기본가2000 (067). Agree these are "price absent in authority"
    → must NOT invent a price (no speculative load)? Or is any of them actually a real missing cell
    that authority DOES price?
Q7. FALSE-POSITIVE hunt: did the analyst wrongly flag any legitimate non-price axis as a defect?
    (shape=cutting option; coating=material variant; same-price group; clr_cd=NULL 도수 무관;
    addon block=0). Conversely, did the analyst MISS any cell / dimension / product / material
    that the authority prices but live likely lacks? E.g. B02/B03/B04 size coverage, GANGPAN
    37-shape completeness, the 8 missing qty-tier risk, any product 058~064 not covered.

## Output format
- A short verdict table: {claim/area | your verdict CONFIRM/REFUTE/RE-MEASURE | one-line reason}.
- A "NEW candidates" section: anything the analyst missed (cells/dims/products/materials), each
  marked as a HYPOTHESIS needing live re-measure.
- A "false-positive" section: any over-detection.
- Be terse and concrete. Cite the authority facts. State assumptions explicitly.
