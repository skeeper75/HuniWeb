---
id: product-183-tin-mirror
type: product
anchor: t_prd_products/PRD_000183
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000183 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 거울류(183~187)·§3.10 가격아키타입(고정가룩업/NEITHER-gap)·§4 정직표기", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
  - {source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000183 unit_price=3000.00·reg_dt=2026-07-03·frm 0행(고정가룩업)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000323, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000262, note: "틴거울 소재(MAT_TYPE.12·금속·활성)·USAGE.07"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "NEITHER-gap(t_prd_product_price_formulas 0행·t_prd_product_prices 0행)"
  구분: "거울류 완제품 단품(비종이·금속·셋트 아님)"
  fixed_price: "3000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·거울)", config_ont: "component type"}
tags: ["#굿즈", "#거울류", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 틴거울 (product-183-tin-mirror)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 3000원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


틴거울(PRD_000183)은 **굿즈 완제품 단품**(prd_typ_cd=PRD_TYPE.01·비종이·금속). `t_prd_product_sets`
부모/구성원 등록 없음(단품·셋트 아님)·기성/디자인 아님. 본체 소재는 **틴거울(MAT_000262·MAT_TYPE.12·활성)**
1종(USAGE.07). 가격은 **고정가룩업(07-04 재프라이싱 정정)** — 가격공식(`t_prd_product_price_formulas`)도 고정가
(`t_prd_product_prices`)도 라이브에 없다(견적 원천 부재) → [[gap-goods-fixed-lookup-no-formula]]로 정직 선언(가격 있는
것처럼 넣지 않음).

- **비종이=판형 없음**([[rule/rules#RULE_plate_paper_only]]): plate 행(SIZ_000017·JPG 파일사양)은 del_yn=Y·output_paper_typ 공란인 파일업로드 규격일 뿐 종이 판형 아님 → `has_plate_size` 엣지 0(정상).
- **없는 축(정직)**: 도수·인쇄옵션 0행·CPQ 옵션그룹 0행·제약 0행·추가상품 0행·사이즈 product_sizes 0행. 얕은 굿즈 데이터(pack §1.2·§4).
- 수량규칙=상품 컬럼(min 1·max 10000·incr 1·QTY_UNIT.01)·bundle_qtys 0행.

## 자재 BOM (권위 = 라이브 스냅샷·awk 전사)

<!-- transcribed-by: awk t_prd_product_materials.csv + t_mat_materials.csv from live-snapshot/latest (snap_20260702_1119) PRD_000183 @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | usage_cd | master del_yn |
|---|---|---|---|---|
| MAT_000262 | 틴거울 | MAT_TYPE.12 | USAGE.07 | N (활성) |

활성 substrate 1종 → `uses_material`로 배선(아래 축 노드). 굿즈 부속 오염 없음(pack §3.5 T-4 해당 없음).

---

## 이 상품이 canonical 소유하는 공유 하위 노드

> 틴거울 소재는 183·184가 공유하나 `axis/materials.md`에 미민팅이라 여기서 canonical 선언(134 린넨 선례·공유 파일 미수정). needs_axis로 consolidate 신호.

### [material-MAT_000262] 틴거울 (MAT_TYPE.12·금속 거울 소재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000262
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000262 mat_nm=틴거울·mat_typ_cd=MAT_TYPE.12·width=75.00·height=75.00·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.12", 규격_ref: "width×height 75×75(전사표)", note: "금속 거울 본체 소재·비종이(판형 없음)·183 틴거울·184 컴팩트거울 공유"}
- 본문: 틴거울 본체 소재(금속·활성). 183·184가 USAGE.07 단일 슬롯으로 참조(fn_chk_opt_item_ref 무관·옵션참조 아님). ★IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
