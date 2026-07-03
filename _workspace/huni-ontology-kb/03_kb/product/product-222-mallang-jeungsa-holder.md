---
id: product-222-mallang-jeungsa-holder
type: product
anchor: t_prd_products/PRD_000222
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000222(prd_nm=말랑증사홀더·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(말랑류 222 gap)·§0.1 use_yn=N 미출시·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000189, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  use_yn: "N"          # 미출시(팬텀 가격 금지)
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#말랑증사홀더", "#NEITHER-gap", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 말랑증사홀더 (product-222-mallang-jeungsa-holder)

말랑증사홀더(PRD_000222)는 **라이프/기념품 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 실리콘 말랑 계열
증명사진 홀더. ★현재 **use_yn=N 미출시**(정직 표기·팬텀 가격 금지).

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = NEITHER-gap → [[gap-goods-neither]](O5 `derived_from` 예외)·
  채움 [[gap-goods-price-unloaded]]. 형제 223/224/225는 고정가이나 222는 미적재.
- **자재·공정 empty-shell**: 자재 0행·공정 0행·옵션그룹 0행.
- **비종이 → 판형 없음**(도메인 [HARD]): `has_plate_size` 미배선.
- **카테고리**: 기념품/액세서리(CAT_000189)·라이프(CAT_000010) — 축 노드 미민팅 → `in_category` 미배선·needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000222 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |
