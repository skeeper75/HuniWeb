---
id: product-193-mug-cup
type: product
anchor: t_prd_products/PRD_000193
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000193 (prd_nm=머그컵·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000193 formula 0행 + t_prd_product_prices.csv 키:PRD_000193 0행 (NEITHER-gap·가격 원천 둘 다 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈·§3.10 GAP-GD-1 NEITHER-gap·§4 굿즈/파우치 NEITHER-gap 행", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000328, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000268, note: "substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"}
  - {rel: uses_material, target: material-MAT_000255, note: "substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"}
  - {rel: references, target: gap-goods-neither, note: "가격 공식·고정가 둘 다 0행(견적 원천 부재)·O5 gap 선언"}
props:
  prd_typ_cd: PRD_TYPE.01
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "NEITHER-gap(공식·고정가 둘 다 없음·견적 원천 부재)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000328 데코소품 — 카테고리 축 노드 미민팅(needs_axis)"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(머그컵 구성)", "조건 탐색(데코 굿즈)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#비종이류"]
updated: 2026-07-04
---

# 머그컵 (product-193-mug-cup)

머그컵(PRD_000193)은 **라이프/데코소품 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 세라믹). 셋트 아님
(단품). ★가격은 **NEITHER-gap** — 가격공식(`t_prd_product_price_formulas`)과 고정가(`t_prd_product_prices`)가
**둘 다 0행**이라 견적 원천이 없다([[gap-goods-neither]]). "가격 있는 것처럼" 표기하지 않는다(정직 GAP).

- **가격 GAP**: 상품마스터 굿즈 시트 + 실무진 가격표 → §26 무결성·§7 dbmap 적재 대기(공식형 PRF_* 또는 고정가 t_prd_product_prices).
- **판형 없음**: 세라믹(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]). `t_prd_product_plate_sizes`는 del_yn=Y 파일사양(JPG) 행뿐.
- **자재**: 활성 substrate 3종(머그컵 11온스 본체·반투명·투명)+화이트(del_yn=Y). 축 노드 미민팅 → uses_material 미배선(needs_axis·BOM 표 권위). ★반투명/투명(MAT_TYPE.01)은 소재 옵션 성격일 수 있어 substrate 판정 보류(실무진 확인).
- **카테고리**: CAT_000010 라이프(main)·CAT_000328 데코소품 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000193"' live-snapshot/latest/{t_prd_products,t_prd_product_materials,t_mat_materials}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 가격 | NEITHER-gap (공식 0행 · 고정가 0행 · 단가행 0행) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (비종이) |

#### 자재 BOM (활성 usage_cd·전사)
<!-- transcribed-by: awk -F, '$1=="PRD_000193"' live-snapshot/latest/t_prd_product_materials.csv + t_mat_materials.csv 조인 (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | usage_cd | del_yn |
|---|---|---|---|---|
| MAT_000268 | 머그컵 (11온스) | MAT_TYPE.12 | USAGE.07 | N (활성) |
| MAT_000146 | 반투명 | MAT_TYPE.01 | USAGE.07 | N (활성) |
| MAT_000143 | 투명 | MAT_TYPE.01 | USAGE.07 | N (활성) |
| MAT_000255 | 화이트 | MAT_TYPE.08 | USAGE.07 | Y (비활성) |

활성 substrate(본체 MAT_000268)만 축 노드 민팅 후 uses_material 배선 권장(needs_axis). 반투명/투명은 소재 옵션 가능성(실무진 판정).
