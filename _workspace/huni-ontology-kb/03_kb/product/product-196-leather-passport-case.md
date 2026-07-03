---
id: product-196-leather-passport-case
type: product
anchor: t_prd_products/PRD_000196
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000196 (prd_nm=레더여권케이스·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "키:PRD_000196 unit_price=5000.00 apply_ymd=2026-06-10 (GP-1 base 단일고정가·260610 verbatim)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈/악세사리·§3.10 고정가룩업·§4 굿즈 고정가 행", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-stn}
props:
  prd_typ_cd: PRD_TYPE.01
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "고정가룩업(t_prd_product_prices·5,000원·transcribed·공식 없음)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000181 여행/아웃도어 — 카테고리 축 노드 미민팅(needs_axis)"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(레더여권케이스 가격)", "조건 탐색(여행 굿즈 고정가)"]
tags: ["#굿즈", "#패브릭의류패드", "#고정가룩업", "#비종이류"]
updated: 2026-07-04
---

# 레더여권케이스 (product-196-leather-passport-case)

레더여권케이스(PRD_000196)는 **라이프/여행 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이류). 셋트 아님
(`t_prd_product_sets` 미등록·단품). 가격은 **고정가룩업**(`t_prd_product_prices` 단일 unit_price 5,000원·
공식 없음)이다 — 온톨로지는 "가격 존재" 사실까지만 표기하고 값 계산은 evaluate_price 권위(D-18 경계).

- **가격 경계**: 공식(`t_prd_product_price_formulas`) 0행·단가행(`t_prc_component_prices`) 0행 → priced_by 공식 미배선(고정가룩업이라 정상). ★O5 참고: 고정가룩업 상품은 priced_by/gap 대신 고정단가 원천이 가격을 잇는다(gate 처리·notes 참조).
- **판형 없음**: 비종이(레더)라 판형 불필요([[rule/rules#RULE_plate_paper_only]]). `t_prd_product_plate_sizes` 행은 del_yn=Y 파일사양(JPG/PDF)뿐·실 판형 아님.
- **자재**: 레더(MAT_000008·MAT_TYPE.06)는 del_yn=Y(2026-06-27 논리삭제)라 활성 substrate 아님 → uses_material 미배선(정직).
- **카테고리**: CAT_000010 라이프(main)·CAT_000181 여행/아웃도어 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000196"' live-snapshot/latest/{t_prd_products,t_prd_product_prices,t_prd_product_materials}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 고정가 | 5,000원 (unit_price 5000.00·apply 2026-06-10·260610 verbatim) |
| 공식/단가행 | t_prd_product_price_formulas 0행 · t_prc_component_prices 0행 |
| 자재 | MAT_000008 레더(MAT_TYPE.06)·del_yn=Y(비활성) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (del_yn=Y 파일사양 JPG/PDF 행만·비종이) |
