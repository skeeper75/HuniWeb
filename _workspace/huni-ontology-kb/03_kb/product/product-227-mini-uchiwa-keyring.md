---
id: product-227-mini-uchiwa-keyring
type: product
anchor: t_prd_products/PRD_000227
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000227 (prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈 227 미니우치와키링(use_yn=N·gap)·§0.1 use_yn=N 미출시·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(t_prd_product_price_formulas 0행·t_prd_product_prices 0행)=NEITHER-gap. O5 충족(priced_by 없음)"}
  - {rel: references, target: gap-goods-material-contamination, note: "자재 3행(양면/반투명/블랙)=인쇄면·색을 자재로 등록(비-소재 값 자재화·GP-ST-003)·substrate 아님"}
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
standards: {schema_org: "Product", xjdf: "Product(미니우치와/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(미니우치와키링 구성)", "미출시 상품 상태 확인"]
tags: ["#굿즈", "#우치와", "#응원", "#NEITHER-gap", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 미니우치와키링 (product-227-mini-uchiwa-keyring)

미니우치와키링(PRD_000227)은 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·[[product-type-classification-sot]]).
라이브 실측상 `t_prd_product_sets` 등록이 없어 단품(셋트 아님)이다. **`use_yn=N` = 라이브 미출시** —
노드는 생성하되 미출시로 정직 표기(팬텀 가격 금지). 파일 업로드·에디터 지원. 최소 1·최대 10000·증분 1.

- **가격 경계(D-18)/NEITHER-gap:** 가격공식·고정가 **둘 다 0행** = 견적 원천 부재(NEITHER-gap) →
  [[gap-goods-neither]](공유 GAP·정직 선언).
- **판형 없음:** 우치와(부채·비종이 성형)라 판형·판걸이수 해당 없음([[rule/rules#RULE_plate_paper_only]]·`t_prd_product_plate_sizes` 0행).
- **공정·인쇄옵션·사이즈 0행:** 셋 다 라이브 0행.

## 카테고리 — 관찰 전사 (축 노드 미민팅·배선 대기)

<!-- transcribed-by: awk t_prd_product_categories.csv+t_cat_categories.csv PRD_000227 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| cat_cd | 이름 | 부모 | main_cat_yn | disp |
|---|---|---|---|---|
| CAT_000010 | 라이프 | (root) | Y | 32 |
| CAT_000198 | 응원/시즌 | CAT_000010 | N | |

카테고리 축 노드 미민팅 → `in_category` 배선 대기(needs_axis 반환). main = 라이프(CAT_000010).

## 자재(BOM) — 관찰 전사 (인쇄면·색을 자재로 등록·GP-ST-003)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000227 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| mat_cd | 이름 | mat_typ | usage_cd |
|---|---|---|---|
| MAT_000272 | 양면 | MAT_TYPE.09 | USAGE.07 |
| MAT_000146 | 반투명 | MAT_TYPE.01 | USAGE.07 |
| MAT_000256 | 블랙 | MAT_TYPE.08 | USAGE.07 |

활성 3행. 자재명이 인쇄면(양면)·소재느낌 색(반투명/블랙)이라 선택 옵션을 자재로 등록(비-소재 값 자재화·
GP-ST-003) → `uses_material` 배선 안 함(관찰 권위=전사·[[gap-goods-material-contamination]]). MAT_000146(반투명)만
공유 [[axis/materials]] 축 노드 실재하나, 이 상품 맥락에서는 옵션-자재라 본 노드는 전사 권위로만 기록(배선 판단은
consolidation/검증가 소관). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

## 옵션·제약·추가상품

- **CPQ 옵션그룹:** 인쇄면·색이 옵션 축이나 정규 옵션 레이어 미적재(자재 대행) → 활성 옵션그룹 노드 미등재.
- **제약규칙:** `t_prd_product_constraints` 0행 → 활성 제약 없음.
- **추가상품:** `t_prd_product_addons` 0행.
