---
id: product-192-diatomite-coaster
type: product
anchor: t_prd_products/PRD_000192
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000192 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000192,MAT_000266/267) — 원형102mm·사각100mm master del_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 코스터류·§3.5 자재 오염·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
  - {source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000192 unit_price=5000.00·reg_dt=2026-07-03·frm 0행(고정가룩업)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000328, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-material-contamination, note: "원형/사각 .09 형상값·del_yn=Y·규조토 실 substrate 부재"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "NEITHER-gap(공식 0행·고정가 0행)"
  자재상태: "활성 substrate 0(참조 2종 형상값·del_yn=Y·규조토 소재 미적재)"
  구분: "코스터류 완제품 단품(비종이·규조토)"
  fixed_price: "5000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·코스터)", config_ont: "component type"}
tags: ["#굿즈", "#코스터류", "#NEITHER-gap", "#자재오염", "#비종이"]
updated: 2026-07-04
---

# 규조토코스터 (product-192-diatomite-coaster)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 5000원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


규조토코스터(PRD_000192)은 **굿즈 완제품 단품**(PRD_TYPE.01·비종이·규조토). 단품(셋트 아님). 가격은
**고정가룩업(07-04 재프라이싱 정정)** → [[gap-goods-fixed-lookup-no-formula]]. product_materials 2행(MAT_000266 원형102mm·MAT_000267
사각100mm)은 MAT_TYPE.09 **형상값 오염**(비-소재·master del_yn=Y)이라 **규조토 실 substrate가 없다** →
[[gap-goods-material-contamination]] 정직 선언(`uses_material` 없음).

- **자재 오염(T-4·pack §3.5·[GP-ST-003])**: "원형 102mm"·"사각 100mm"=형상 descriptor 오적재(del_yn=Y). 규조토 소재 미적재.
- **비종이=판형 없음**: plate 행(SIZ_000390/391·PDF) del_yn=Y → `has_plate_size` 0.
- **없는 축(정직)**: 도수·인쇄옵션·CPQ·제약·추가상품·product_sizes 전부 0행.
- 수량규칙=상품 컬럼(min 1·max 10000·incr 1·QTY_UNIT.01).

## 자재 BOM (권위 = 라이브 스냅샷·awk 전사·오염 판정)

<!-- transcribed-by: awk t_prd_product_materials.csv + t_mat_materials.csv from live-snapshot/latest (snap_20260702_1119) PRD_000192 @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | master del_yn | 판정 |
|---|---|---|---|---|
| MAT_000266 | 원형 102mm | MAT_TYPE.09 | Y | 형상값 오염(비-소재) |
| MAT_000267 | 사각 100mm | MAT_TYPE.09 | Y | 형상값 오염(비-소재) |

활성 substrate 0 → `uses_material` 없음. 규조토 소재 충전=실무진/dbmap 대기.
