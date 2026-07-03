---
id: product-214-magnet-bookmark
type: product
anchor: t_prd_products/PRD_000214
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000214(prd_nm=자석북마크·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(과업명시 214 자석북마크)·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
  - {source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000214 unit_price=2500.00·reg_dt=2026-07-03·frm 0행(고정가룩업)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000134, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000008, note: "문구(main·CAT_000008)·데스크소품(CAT_000134·축 미민팅)"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
  fixed_price: "2500원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·2500원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#자석북마크", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 자석북마크 (product-214-magnet-bookmark)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 2500원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


자석북마크(PRD_000214)는 **문구/데스크소품 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 자석 책갈피 굿즈.

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = 고정가룩업(07-04 재프라이싱 정정) → [[gap-goods-fixed-lookup-no-formula]](O5 `derived_from` 예외)·
  채움 [[gap-goods-fixed-lookup-no-formula]].
- **자재**: active 1행 MAT_000294(2개1팩·MAT_TYPE.09)는 **묶음 규격 변형값**이지 substrate 아님 → `uses_material` 미배선.
- **비종이 → 판형 없음**(도메인 [HARD]): 공정 0행·옵션그룹 0행·`has_plate_size` 미배선.
- **카테고리**: 문구(CAT_000008·main) 배선. 데스크소품(CAT_000134) 미민팅 → needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000214 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |

## 자재행(전사) — 규격 변형값

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000214 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ | usage | del_yn |
|---|---|---|---|---|
| MAT_000294 | 2개1팩 | MAT_TYPE.09 | USAGE.07 | N |
