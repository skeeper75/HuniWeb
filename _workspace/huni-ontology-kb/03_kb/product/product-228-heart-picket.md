---
id: product-228-heart-picket
type: product
anchor: t_prd_products/PRD_000228
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000228 (prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈 226~229 미러/이미지피켓 family·§0.1 use_yn=N 미출시·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000228 unit_price=8500.00·reg_dt=2026-07-03·frm 0행(고정가룩업)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000198, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-material-contamination, note: "자재 1행(양면유광)=인쇄면/코팅을 자재로 등록(비-소재 값 자재화·GP-ST-003)·substrate 아님"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(가격 원천 부재)"
  use_yn: "N"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  미출시: "use_yn=N — 라이브 미출시(팬텀 가격 금지·정직 표기)"
  fixed_price: "8500원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·8500원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: "Product", xjdf: "Product(하트이미지피켓/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(하트 이미지피켓 구성)", "미출시 상품 상태 확인"]
tags: ["#굿즈", "#피켓", "#응원", "#NEITHER-gap", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 하트 이미지피켓 (product-228-heart-picket)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 8500원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


하트 이미지피켓(PRD_000228)은 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·[[product-type-classification-sot]]).
라이브 실측상 `t_prd_product_sets` 등록이 없어 단품(셋트 아님)이다. **`use_yn=N` = 라이브 미출시** —
노드는 생성하되 미출시로 정직 표기(팬텀 가격 금지). 파일 업로드·에디터 지원. 최소 1·최대 10000·증분 1.
자매 상품 229 이미지피켓(use_yn=Y·활성)의 하트 형상 변형.

- **가격 경계(D-18)/고정가룩업(07-04 재프라이싱 정정):** 가격공식·고정가 **둘 다 0행** = 견적 원천 부재(고정가룩업(07-04 재프라이싱 정정)) →
  [[gap-goods-fixed-lookup-no-formula]](공유 GAP·정직 선언).
- **판형 없음:** 이미지피켓(아크릴/PVC 성형·비종이)이라 판형·판걸이수 해당 없음
  ([[rule/rules#RULE_plate_paper_only]]·`t_prd_product_plate_sizes` 0행).
- **공정·인쇄옵션·사이즈 0행:** 셋 다 라이브 0행.

## 카테고리 — 관찰 전사 (축 노드 미민팅·배선 대기)

<!-- transcribed-by: awk t_prd_product_categories.csv+t_cat_categories.csv PRD_000228 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| cat_cd | 이름 | 부모 | main_cat_yn | disp |
|---|---|---|---|---|
| CAT_000010 | 라이프 | (root) | Y | 33 |
| CAT_000198 | 응원/시즌 | CAT_000010 | N | |

카테고리 축 노드 미민팅 → `in_category` 배선 대기(needs_axis 반환). main = 라이프(CAT_000010).

## 자재(BOM) — 관찰 전사 (인쇄면/코팅을 자재로 등록·GP-ST-003)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000228 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| mat_cd | 이름 | mat_typ | usage_cd |
|---|---|---|---|
| MAT_000316 | 양면유광 | MAT_TYPE.09 | USAGE.07 |

활성 1행. 자재명 "양면유광"=인쇄면+코팅 사양을 자재로 등록(비-소재 값 자재화·GP-ST-003) → `uses_material`
배선 안 함(관찰 권위=전사·[[gap-goods-material-contamination]]). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

## 옵션·제약·추가상품

- **CPQ 옵션그룹:** 라이브 정규 옵션 레이어 미적재 → 활성 옵션그룹 노드 미등재.
- **제약규칙:** `t_prd_product_constraints` 0행 → 활성 제약 없음.
- **추가상품:** `t_prd_product_addons` 0행.
