---
id: product-011-magnet-rubber-plate
type: product
anchor: t_prd_products/PRD_000011
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000011 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 011 자석고정용고무판(기성.03·min1~max100)·§0.1 기성상품 인쇄 BOM N/A", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000285, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
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
standards: {schema_org: "Product", xjdf: "Product(기성 부자재)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(자석고정용고무판)"]
tags: ["#기성상품", "#포장부자재", "#NEITHER-gap"]
updated: 2026-07-04
---

# 자석고정용고무판 (product-011-magnet-rubber-plate)

자석고정용고무판(PRD_000011)은 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음·인쇄 BOM N/A). 자석
고정용 고무판 완성품(포장부자재 계열)이다. `t_prd_product_sets` 미등재·파일 업로드/에디터 미사용. 최소
1·최대 100·증분 1.

- **정체:** 라이브 `t_prd_products`(기성.03). 팩 §0.1 "기성상품 → 인쇄 BOM N/A"(011 명시).
- **NEITHER-gap:** 가격공식·고정가 **둘 다 0행** → [[gap-goods-neither]]. 값 있는 것처럼 표기 금지.
- **자재·공정 empty-shell:** `t_prd_product_materials` 0행·`t_prd_product_processes` 0행(제조 없는
  기성이라 BOM 비어 있음이 정상). 판형 없음(비종이·plate_sizes 0행).

## 규격(사이즈) — 관찰 전사

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv (del_yn≠Y) PRD_000011 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 |
|---|---|
| SIZ_000111 | 20x20(20개입) |

활성 1행. 사이즈 축 미민팅 → `has_size` 배선 대기(전사표 관찰 권위).

## 옵션·제약·추가상품
- CPQ 옵션그룹·제약규칙·추가상품 라이브 행 **없음**. 카테고리 = 포장부자재(CAT_000285·main_cat_yn=Y·
  축 노드 미민팅=needs_axis).
