---
id: product-015-refill-ink
type: product
anchor: t_prd_products/PRD_000015
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000015 (prd_typ_cd=PRD_TYPE.03·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 015 리필잉크(addon성)·§3.12 굿즈 addon(리필잉크)·§0.1 기성상품", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: references, target: gap-goods-neither, note: "가격 원천 부재(price_formulas 0행·prices 0행)=NEITHER-gap. O5 충족"}
  - {rel: references, target: gap-goods-material-contamination, note: "015 자재 7행이 무관 부속 grab-bag(카드봉투/케이스/끈/액자/판넬)=비-substrate 오염 의심"}
props:
  prd_typ_cd: "PRD_TYPE.03"
  archetype: "기성(제조없음)·addon성·NEITHER-gap(가격 원천 부재)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 100
  qty_incr: 1
  file_upload_yn: "N"
  editor_yn: "N"
standards: {schema_org: "Product", xjdf: "Product(기성 소모품)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(만년스탬프 리필잉크)"]
tags: ["#기성상품", "#addon성", "#NEITHER-gap", "#자재오염의심"]
updated: 2026-07-04
---

# 만년스탬프 리필잉크 (product-015-refill-ink)

만년스탬프 리필잉크(PRD_000015)는 **기성상품**(`prd_typ_cd=PRD_TYPE.03`·제조 없음). 만년스탬프(217)의
소모품 리필잉크로, 팩 §1.2/§3.12에서 **addon성**(다른 상품에 딸리는 추가 소모품)으로 분류된다.
`t_prd_product_sets` 미등재·파일 업로드/에디터 미사용. 최소 1·최대 100·증분 1.

- **정체:** 라이브 `t_prd_products`(기성.03·addon성 소모품).
- **NEITHER-gap:** 가격공식·고정가 **둘 다 0행** → [[gap-goods-neither]]. 값 있는 것처럼 표기 금지.
- **사이즈·공정 없음:** `t_prd_product_sizes` 0행·`t_prd_product_processes` 0행(소모품·규격 없음).
  판형 없음(비종이·plate_sizes 0행).

## 자재(BOM) — 관찰 전사 (★비-substrate 오염 의심)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000015 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
활성 7행 · USAGE.07. 그런데 자재명이 리필잉크와 **무관한 부속 grab-bag**이다: 카드봉투(MAT_000232)·
캘린더봉투(234)·투명PP케이스(235)·행택끈(236)·만년스탬프 리필잉크(237)·레더아트액자(238)·나무판넬(239).
substrate 자재(잉크 소재)가 아니라 서로 다른 굿즈/부속을 자재 슬롯에 묶어 놓은 것 → 자재 오염 의심
([[gap-goods-material-contamination]]·T-4 "부속=자재 함정"). `uses_material` 배선하지 않음(오염 전파 방지).
정리 판정은 §17 huni-basedata-dedup·실무진 소관(★[HARD] 실무진 IMPORT 자재는 배선 안 됨을 사유로 삭제 금지).

## 옵션·제약·추가상품
- CPQ 옵션그룹·제약규칙·추가상품(피참조) 라이브 행 **없음**. 실체는 만년스탬프(217) 소모품 addon으로
  살아 있으나 has_addon 배선은 217 노드 부재로 대기(굿즈 addon 링크 MISSING·pack GAP-GD-6 동류).
  카테고리 = 상품액세서리(CAT_000287·main_cat_yn=Y·축 노드 미민팅=needs_axis).
