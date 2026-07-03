---
id: product-005-calendar-envelope
type: product
anchor: t_prd_products/PRD_000005
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000005 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.4 봉투류 005 캘린더봉투(NEITHER-gap)·§0.1 기성.03", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000276, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(price_formulas 0행·prices 0행)=NEITHER-gap. O5 충족"}
props:
  prd_typ_cd: "PRD_TYPE.03"
  archetype: "기성(제조없음)·NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 100
  qty_incr: 1
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product", xjdf: "Product(봉투/Envelope)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(캘린더봉투 규격)"]
tags: ["#봉투", "#기성상품", "#NEITHER-gap"]
updated: 2026-07-04
---

# 캘린더봉투 (product-005-calendar-envelope)

캘린더봉투(PRD_000005)는 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음). 캘린더 완제품 포장용
봉투 완성품이다. `t_prd_product_sets` 미등재·파일 업로드/에디터 미사용. 최소 1·최대 100·증분 1. 규격
2종(240x230·150x310mm)에서 고른다.

- **정체:** 라이브 `t_prd_products`(기성.03·라이브 정직 표기).
- **NEITHER-gap:** 가격공식·고정가 **둘 다 0행** → [[gap-goods-neither]]. 값 있는 것처럼 표기 금지.
- **판형 없음:** 비종이/특수 + 완성 기성품 → 판형·판걸이수 해당 없음(plate_sizes 0행).

## 규격(사이즈) — 관찰 전사

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv (del_yn≠Y) PRD_000005 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 |
|---|---|
| SIZ_000106 | 240x230mm |
| SIZ_000107 | 150x310mm |

활성 2행. 사이즈 축 미민팅 → `has_size` 배선 대기(전사표 관찰 권위).

## 자재(BOM) — 관찰 전사 (자기참조 변형 SKU)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000005 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
활성 2행 · USAGE.07. 자재명=봉투 규격 변형(MAT_000530 캘린더봉투 240x230·MAT_000531 150x310) =
기성 자기참조 SKU(substrate 아님). `uses_material` 배선은 미민팅 대기.

## 옵션·제약·추가상품
- CPQ 옵션그룹·제약규칙·추가상품(피참조) 라이브 행 **없음**(005는 봉투 addon 대상에도 미포함).
