---
id: product-283-tracing-paper-envelope
type: product
anchor: t_prd_products/PRD_000283
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000283 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N·min/max/incr 공란)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.4 봉투류 283 트레싱지봉투(기성·가격없음)·§0.1 기성.03", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000276, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(price_formulas 0행·prices 0행)=NEITHER-gap. O5 충족"}
props:
  prd_typ_cd: "PRD_TYPE.03"
  archetype: "기성(제조없음)·NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: null
  max_qty: null
  qty_incr: null
  file_upload_yn: "N"
  editor_yn: "N"
  addon_target_of: "016 프리미엄엽서(TMPL-000009 트레싱지봉투 160x110 20장) base_prd"
standards: {schema_org: "Product", xjdf: "Product(봉투/Envelope)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(트레싱지봉투 규격)", "봉투 추가상품 대상 확인"]
tags: ["#봉투", "#기성상품", "#NEITHER-gap", "#addon대상"]
updated: 2026-07-04
---

# 트레싱지봉투 (product-283-tracing-paper-envelope)

트레싱지봉투(PRD_000283)는 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음). 반투명 트레싱지 카드봉투
완성품이다. `t_prd_product_sets` 미등재·파일 업로드/에디터 미사용. 상품 레벨 수량규칙(min/max/incr) 공란
(제조 없는 기성이라 수량 그릇 미설정).

- **정체:** 라이브 `t_prd_products`(기성.03). 팩 §1.4가 283을 기성으로 명시(정합).
- **NEITHER-gap:** 가격공식·고정가 **둘 다 0행** → [[gap-goods-neither]]. 값 있는 것처럼 표기 금지.
  (자재명이 "…(20장/40장/100장)" 장수 변형을 담으나 단가/공식은 미적재.)
- **판형 없음:** 트레싱지 특수 + 완성 기성품 → 판형·판걸이수 해당 없음(plate_sizes 0행).

## 규격(사이즈) — 관찰 전사

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv (del_yn≠Y) PRD_000283 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| siz_cd | 라벨 |
|---|---|
| SIZ_000102 | 70x100mm |
| SIZ_000096 | 160x110mm |
| SIZ_000083 | 100x100mm |

활성 3행(SIZ_000113은 del_yn=Y 은퇴). 사이즈 축 미민팅 → `has_size` 배선 대기(전사표 관찰 권위).

## 자재(BOM) — 관찰 전사 (규격×장수 변형 SKU)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000283 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
활성 8행 · USAGE.07. 자재명=트레싱지 카드봉투 규격×장수 변형(160x110/100x100/70x100 × 20/30/40/100장·
MAT_000520~527) = 기성 자기참조 SKU. `uses_material` 배선은 미민팅 대기. ★장수(20/40/100장)가 판매
단위 변형이나 이를 단가로 잇는 공식/고정가가 없어 견적 원천 부재(gap-goods-neither).

## 옵션·제약·추가상품

- **CPQ 옵션그룹·제약규칙:** 라이브 행 **없음**.
- **추가상품(피참조):** 283은 봉투 추가상품 대상(base_prd) — 016(TMPL-000009 트레싱지봉투 160x110
  20장)이 이 상품을 가리킨다. `has_addon`은 016 쪽에서 배선. 이 노드 생성으로 [[gap-016-addon-target]]
  대상 부재 일부 해소 가능(엣지 배선은 검증가/Stage C 소관).
