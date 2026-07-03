---
id: product-223-mallang-poca-holder
type: product
anchor: t_prd_products/PRD_000223
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000223(prd_nm=말랑포카홀더·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "테이블:t_prd_product_prices 키:PRD_000223(unit_price·GP-1 base 단일고정가 260610 verbatim)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(말랑류 223 고정가 14,000)·§3.10 고정가룩업(t_prd_product_prices)·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000189, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: derived_from, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업·공식 아키타입 부재→공유 gap 표준화(로컬 gap 은퇴·C2 260704)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "고정가룩업(t_prd_product_prices 단일 unit_price)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
  fixed_price: "14000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·14000원(unit_price·transcribed·07-04 live·reg_dt=2026-06-22)"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#말랑포카홀더", "#고정가룩업", "#비종이"]
updated: 2026-07-04
---

# 말랑포카홀더 (product-223-mallang-poca-holder)

말랑포카홀더(PRD_000223)는 **라이프/기념품 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 실리콘 말랑 계열
포토카드 홀더.

- **가격(고정가룩업·verified)**: `t_prd_product_prices` 단일 고정가 실재(GP-1 base·260610 verbatim·값=아래 전사표).
  값 계산=엔진 권위(D-18). ★`price_formula` 바인딩 0행 → 공식 그릇 미표현 [[gap-goods-fixed-lookup-no-formula]]
  (O5 `derived_from` 예외).
- **비종이 → 판형 없음**(도메인 [HARD]): 자재 0행·공정 0행·옵션그룹 0행·`has_plate_size` 미배선.
- **카테고리**: 라이프(CAT_000010·main)·기념품/액세서리(CAT_000189) — 축 노드 미민팅 → `in_category` 미배선·needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000223 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |

## 고정가(전사)

<!-- transcribed-by: awk t_prd_product_prices.csv PRD_000223 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_cd | apply_ymd | unit_price | note |
|---|---|---|---|
| PRD_000223 | 2026-06-10 | 14000.00 | GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim) |

## 이 상품 전용 하위 노드