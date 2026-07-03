---
id: product-162-acrylic-photocard-stand
type: product
anchor: t_prd_products/PRD_000162
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000162(prd_nm=아크릴포카스탠드·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N·min1/max10000/incr1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "행:PRD_000162 frm PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적 277셀·2,000~32,700)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/pack-acrylic.md", source_locator: "§1.1 M1·§3.9 옵션 items 0(GAP-AC-4)·§5.1 CL-1", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000155, qualifier: main, note: "조합형(아크릴 CAT_000009 하위·main_cat_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000364, note: "68x103(면적매트릭스 W×H)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm=substrate(dflt_yn=Y·유일 자재)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV 인쇄(mand_proc_yn=Y)"}
  - {rel: priced_by, target: formula-PRF_CLR_ACRYL, note: "컬러아크릴 면적매트릭스(공유 M1)"}
  - {rel: has_option_group, target: optgroup-162-size, note: "사이즈 택1(OPT_000078·items 0=GAP-AC-4)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  nonspec_yn: "N"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  editor_yn: "N"
  archetype: "면적매트릭스형(area-matrix·규격 스탠드 사이즈 단일·조합형)"
  plate_sizes_note: "plate_sizes 0행(판형 미실재)·비종이 → 판형 무관(T-9)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴)", config_ont: "component type"}
answers_cq: ["아크릴포카스탠드 가격 경로(면적매트릭스)", "조건 탐색(포카스탠드 크기)"]
tags: ["#굿즈", "#아크릴", "#면적매트릭스", "#비종이류"]
updated: 2026-07-04
---

# product-162 아크릴포카스탠드 (PRD_000162)

아크릴포카스탠드는 **아크릴 굿즈 완제품 단품**(비종이·UV 평판·조합형·규격형 nonspec_yn=N). 규격
(68x103) 선택 → 컬러아크릴 **면적매트릭스** 통가격 조회. `t_prd_product_sets` 부모 없음 = 일반 단일
완제품(has_member 없음).

## 차원
- **사이즈:** 규격 1행(68x103 `SIZ_000364`). nonspec_yn=N(규격 단일). 가격은 면적매트릭스(W×H) 조회.
  상세=[[product-162-acrylic-photocard-stand-nodes]].
- **수량규칙:** min 1·max 10000·incr 1.

## 자재·공정
- **substrate:** 아크릴 투명 3mm(`MAT_000043`·dflt_yn=Y·유일 자재·[[material-MAT_000043]]).
- **공정:** UV 인쇄(`PROC_000002`·mand).

## 판형 (★비종이 — 해당 없음)
- `t_prd_product_plate_sizes` = 162에 0행(판형 미실재). 비종이라 판형 무관(T-9). `has_plate_size` 미배선.

## 옵션·제약·추가상품
- **옵션그룹 1:** 사이즈 택1(`OPT_000078`·SEL_TYPE.01·mand_yn=Y). ★option_items **0행**([GAP-AC-4]) →
  option_refs 미배선. 상세=[[product-162-acrylic-photocard-stand-nodes]]. **제약:** 0행. **addon:** 0행.

## 가격 경로 (D-18)
- `product-162 --priced_by--> formula-PRF_CLR_ACRYL --has_component--> component-COMP_ACRYL_CLEAR3T`
  (면적매트릭스 277셀). `t_prd_product_prices` 0행 = 직접룩업 아님(T-7). 값=evaluate_price 권위.

## 승계·freshness 메모
- 07-04 신규 SELECT 캐시(pack §0.2). snapshot 가격 금지(T-2).
