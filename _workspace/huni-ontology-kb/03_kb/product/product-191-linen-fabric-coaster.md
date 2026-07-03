---
id: product-191-linen-fabric-coaster
type: product
anchor: t_prd_products/PRD_000191
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000191 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000191,MAT_000184 린넨 활성 / MAT_000265 사각110mm del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 코스터류·§3.5 자재 오염·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
  - {source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000191 unit_price=4500.00·reg_dt=2026-07-03·frm 0행(고정가룩업)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000328, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000184, note: "린넨(MAT_TYPE.05 원단·활성·134 canonical 재사용)·USAGE.07"}
  - {rel: references, target: gap-goods-material-contamination, note: "MAT_000265 사각110mm=형상값 .09·del_yn=Y(린넨 substrate와 별개 오염)"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "NEITHER-gap(공식 0행·고정가 0행)"
  자재상태: "활성 substrate 1(린넨 MAT_000184)·형상값 오염 1(사각110mm del_yn=Y)"
  구분: "코스터류 완제품 단품(비종이·린넨 원단)"
  fixed_price: "4500원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·코스터)", config_ont: "component type"}
tags: ["#굿즈", "#코스터류", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 린넨패브릭코스터 (product-191-linen-fabric-coaster)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 4500원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


린넨패브릭코스터(PRD_000191)은 **굿즈 완제품 단품**(PRD_TYPE.01·비종이·린넨 원단). 단품(셋트 아님).
가격은 **고정가룩업(07-04 재프라이싱 정정)**(공식·고정가 부재) → [[gap-goods-fixed-lookup-no-formula]]. 자재는 코스터류 중 **유일하게 활성
substrate 실재** — **린넨(MAT_000184·MAT_TYPE.05 원단·활성)**을 `uses_material`로 배선(축 노드는
134 족자가 canonical 소유·재사용). 단, 함께 걸린 MAT_000265 "사각 110mm"는 형상값 오염(별도 처리).

- **린넨 자재(정합)**: MAT_000184는 06-14 정정(실사소재 .08→원단 .05)된 활성 자재로 실 substrate → 배선. ★IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **자재 오염 1건(T-4·[GP-ST-003])**: MAT_000265 "사각 110mm"=MAT_TYPE.09 형상 descriptor(master del_yn=Y) → `uses_material` 제외·[[gap-goods-material-contamination]].
- **비종이=판형 없음**: plate 행(SIZ_000004·JPG) del_yn=Y → `has_plate_size` 0.
- **없는 축(정직)**: 도수·인쇄옵션·CPQ·제약·추가상품·product_sizes 전부 0행.
- 수량규칙=상품 컬럼(min 1·max 10000·incr 1·QTY_UNIT.01).

## 자재 BOM (권위 = 라이브 스냅샷·awk 전사·오염 판정)

<!-- transcribed-by: awk t_prd_product_materials.csv + t_mat_materials.csv from live-snapshot/latest (snap_20260702_1119) PRD_000191 @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | master del_yn | 판정 |
|---|---|---|---|---|
| MAT_000184 | 린넨 | MAT_TYPE.05 | N | 활성 substrate → uses_material 배선 |
| MAT_000265 | 사각 110mm | MAT_TYPE.09 | Y | 형상값 오염(비-소재)·제외 |

`uses_material` = MAT_000184(린넨) 1종만. 축 노드 canonical=product-134(린넨 우드봉 족자)·재-mint 없음(L-3 회피).
