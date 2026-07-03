---
id: product-229-image-picket
type: product
anchor: t_prd_products/PRD_000229
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000229 (prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈 226~229 미러/이미지피켓 family·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(t_prd_product_price_formulas 0행·t_prd_product_prices 0행)=NEITHER-gap. O5 충족(priced_by 없음)"}
  - {rel: references, target: gap-goods-material-contamination, note: "자재 2행(양면유광 M/L)=사이즈+인쇄면/코팅을 자재로 등록(비-소재 값 자재화·GP-ST-003)·substrate 아님"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  출시상태: "use_yn=Y — 본 family에서 유일한 활성 상품(226/227/228은 use_yn=N 미출시)"
standards: {schema_org: "Product", xjdf: "Product(이미지피켓/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(이미지피켓 구성)", "활성 상품이나 가격 미적재 확인"]
tags: ["#굿즈", "#피켓", "#응원", "#NEITHER-gap", "#활성", "#비종이"]
updated: 2026-07-04
---

# 이미지피켓 (product-229-image-picket)

이미지피켓(PRD_000229)은 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·[[product-type-classification-sot]]).
라이브 실측상 `t_prd_product_sets` 등록이 없어 단품(셋트 아님)이다. **`use_yn=Y` = 라이브 활성** —
본 미러/피켓 family(226/227/228은 미출시)에서 **유일하게 출시된 상품**이다. 파일 업로드·에디터 지원.
최소 1·최대 10000·증분 1. 자매 228 하트 이미지피켓의 표준 형상 버전.

- **가격 경계(D-18)/NEITHER-gap:** 활성 상품임에도 가격공식(`t_prd_product_price_formulas`)·고정가
  (`t_prd_product_prices`) **둘 다 0행** = 견적 원천 부재(NEITHER-gap) → [[gap-goods-neither]](공유 GAP·정직 선언).
  ★활성(use_yn=Y)인데 가격 미적재라 실제 견적 불가 — 우선 채움 대상(gap_owner=staff/dbmap).
- **판형 없음:** 이미지피켓(아크릴/PVC 성형·비종이)이라 판형·판걸이수 해당 없음
  ([[rule/rules#RULE_plate_paper_only]]·`t_prd_product_plate_sizes` 0행).
- **공정·인쇄옵션·사이즈 0행:** 셋 다 라이브 0행(사이즈는 자재 M/L로 대행·아래).

## 카테고리 — 관찰 전사 (축 노드 미민팅·배선 대기)

<!-- transcribed-by: awk t_prd_product_categories.csv+t_cat_categories.csv PRD_000229 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| cat_cd | 이름 | 부모 | main_cat_yn | disp |
|---|---|---|---|---|
| CAT_000010 | 라이프 | (root) | Y | 34 |
| CAT_000198 | 응원/시즌 | CAT_000010 | N | |

카테고리 축 노드 미민팅 → `in_category` 배선 대기(needs_axis 반환). main = 라이프(CAT_000010).

## 자재(BOM) — 관찰 전사 (사이즈+코팅을 자재로 등록·GP-ST-003)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000229 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| mat_cd | 이름 | mat_typ | usage_cd |
|---|---|---|---|
| MAT_000317 | 양면유광 M | MAT_TYPE.09 | USAGE.07 |
| MAT_000318 | 양면유광 L | MAT_TYPE.09 | USAGE.07 |

활성 2행. 자재명 "양면유광 M/L"=사이즈(M/L)+인쇄면/코팅을 자재로 등록(비-소재 값 자재화·GP-ST-003) →
`uses_material` 배선 안 함(관찰 권위=전사·[[gap-goods-material-contamination]]). ★사이즈 축이 자재로 대행되어
`t_prd_product_sizes`가 0행인 구조(사이즈 정규화 대상). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

## 옵션·제약·추가상품

- **CPQ 옵션그룹:** 사이즈(M/L)가 옵션 축이나 정규 옵션 레이어 미적재(자재 대행) → 활성 옵션그룹 노드 미등재.
- **제약규칙:** `t_prd_product_constraints` 0행 → 활성 제약 없음.
- **추가상품:** `t_prd_product_addons` 0행.
