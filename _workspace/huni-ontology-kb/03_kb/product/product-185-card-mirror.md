---
id: product-185-card-mirror
type: product
anchor: t_prd_products/PRD_000185
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000185 (prd_typ_cd=PRD_TYPE.01·min_qty=3·qty_incr=3·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "키:PRD_000185 unit_price=2500.00·apply_ymd=2026-06-10·note 'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 거울류·§3.10 고정가룩업(t_prd_product_prices 단일 unit_price)·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000323, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업·공식 아키타입 부재→공유 gap 표준화(로컬 gap 은퇴·C2 260704)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 3
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "고정가룩업(t_prd_product_prices·2,500원·transcribed·260610 verbatim)"
  가격아키타입: "fixed-lookup(단일 unit_price·frm_cd 없음)"
  구분: "거울류 완제품 단품(비종이·유리/금속)"
  fixed_price: "2500원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·거울)", config_ont: "component type"}
answers_cq: ["카드거울 가격(고정가 조회)"]
tags: ["#굿즈", "#거울류", "#고정가룩업", "#비종이"]
updated: 2026-07-04
---

# 카드거울 (product-185-card-mirror)

카드거울(PRD_000185)은 **굿즈 완제품 단품**(PRD_TYPE.01·비종이). 이 클러스터에서 **유일하게 가격이
실재**하는 상품 — **고정가룩업**(`t_prd_product_prices` 단일 unit_price **2,500원**·260610 verbatim).
가격공식(`t_prd_product_price_formulas`)은 없다(frm_cd 미바인딩). 온톨로지는 "가격이 존재한다"는 사실까지만
기록하고 값 계산은 엔진 권위([[rule/rules#RULE_price_value_boundary]]).

- **★고정가룩업 아키타입(첫 사례)**: 앞선 고정가 상품(024 포토카드·134 족자)은 모두 **공식**(PRF_*)을 거쳤으나, 185는 공식 없이 `t_prd_product_prices`에서 직접 단일가를 읽는다. `priced_by` 엣지를 걸 대상(price_formula)이 없어 O5(priced_by≥1)와 어긋난다 → [[gap-goods-fixed-lookup-no-formula]]로 정직 선언(가격은 verified·아키타입 모델만 공백). architect O5 예외/fixed-lookup 정책 대기.
- **비종이=판형 없음**: plate 행(SIZ_000383·"JPG x 3P")은 del_yn=Y 파일업로드 규격 → `has_plate_size` 0.
- **없는 축(정직)**: 자재 product_materials 0행·도수·인쇄옵션·CPQ·제약·추가상품·product_sizes 전부 0행.
- 수량규칙: **3개 단위 주문**(min 3·incr 3·max 10000·QTY_UNIT.01·bundle_qtys 0행).

## 가격 전사 (권위 = 라이브 스냅샷·awk 전사)

<!-- transcribed-by: awk t_prd_product_prices.csv from live-snapshot/latest (snap_20260702_1119) PRD_000185 @ 2026-07-04 -->
| prd_cd | apply_ymd | unit_price | note |
|---|---|---|---|
| PRD_000185 | 2026-06-10 | 2500.00 | GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim) |

260702 diff 미해당(§3.10 T-3) → 260702 권위와 동일 확증·badge=verified.

---

## 이 상품 전용 하위 노드