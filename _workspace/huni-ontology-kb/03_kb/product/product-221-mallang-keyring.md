---
id: product-221-mallang-keyring
type: product
anchor: t_prd_products/PRD_000221
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000221(prd_nm=말랑키링·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(말랑류·과업명시 221 말랑키링 gap)·§3.5 자재·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
  - {source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000221 unit_price=10000.00·reg_dt=2026-07-03·frm 0행(고정가룩업)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000189, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-material-contamination, note: "형상 변형값(원형/사각/꽃/별/하트) MAT_000304~308은 del_yn=Y 은퇴(active 0)·substrate 아님"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
  fixed_price: "10000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·10000원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#말랑키링", "#NEITHER-gap", "#비종이", "#자재오염주의"]
updated: 2026-07-04
---

# 말랑키링 (product-221-mallang-keyring)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 10000원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


말랑키링(PRD_000221)은 **라이프/기념품 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 실리콘 말랑 굿즈 계열
(형제 223 포카홀더·224 네임택·225 여권케이스는 고정가·221/222는 gap).

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = 고정가룩업(07-04 재프라이싱 정정) → [[gap-goods-fixed-lookup-no-formula]](O5 `derived_from` 예외)·
  채움 [[gap-goods-fixed-lookup-no-formula]].
- **★자재(은퇴)**: MAT_000304~308(원형/사각/꽃/별/하트)은 **형상 변형값이자 del_yn=Y 은퇴**로 active substrate 0
  ([[gap-goods-material-contamination]]) → `uses_material` 미배선.
- **비종이(실리콘) → 판형 없음**(도메인 [HARD]): 공정 0행·옵션그룹 0행·`has_plate_size` 미배선.
- **카테고리**: 라이프(CAT_000010·main)·기념품/액세서리(CAT_000189) — 축 노드 미민팅 → `in_category` 미배선·needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000221 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |

## 자재행(전사·은퇴) — 형상 변형값

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000221 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ | usage | del_yn |
|---|---|---|---|---|
| MAT_000304 | 원형 | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |
| MAT_000305 | 사각 | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |
| MAT_000306 | 꽃 | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |
| MAT_000307 | 별 | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |
| MAT_000308 | 하트 | MAT_TYPE.09 | USAGE.07 | Y(은퇴) |
