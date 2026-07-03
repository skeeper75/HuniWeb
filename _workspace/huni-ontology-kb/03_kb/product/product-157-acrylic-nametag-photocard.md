---
id: product-157-acrylic-nametag-photocard
type: product
anchor: t_prd_products/PRD_000157
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000157(prd_nm=아크릴네임택·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N·min1/max10000/incr1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "행:PRD_000157 frm PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적 277셀·2,000~32,700)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/pack-acrylic.md", source_locator: "§1.1 M1·§3.2 규격 사이즈·§3.9 옵션 items 0(GAP-AC-4)·§5.1 CL-1", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, note: "단품형(아크릴 CAT_000009 하위·main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000181, note: "여행/아웃도어(보조·main_cat_yn=N·product-051-suncap 소유 재사용)"}
  - {rel: has_size, target: size-SIZ_000148, note: "60x60(재사용·product-146-acrylic-keyring-nodes)"}
  - {rel: has_size, target: size-SIZ_000012, note: "55x86 포토카드(재사용·product-024-photocard)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm=substrate(dflt_yn=Y·유일 자재)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV 인쇄(mand_proc_yn=Y)"}
  - {rel: priced_by, target: formula-PRF_CLR_ACRYL, note: "컬러아크릴 면적매트릭스(공유 M1·BYSIZ 폐기→면적공식 환원)"}
  - {rel: has_option_group, target: optgroup-157-size, note: "사이즈 택1(OPT_000075·items 0=GAP-AC-4)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  nonspec_yn: "N"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  editor_yn: "N"
  archetype: "면적매트릭스형(area-matrix·규격 사이즈 2종·BYSIZ 폐기 후 면적공식 환원)"
  plate_sizes_note: "plate_sizes 2행 실재·면적공식 미참조 → 가격영향 없음(비종이·T-9)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴)", config_ont: "component type"}
answers_cq: ["아크릴네임택 가격 경로(면적매트릭스)", "조건 탐색(네임택 크기)"]
tags: ["#굿즈", "#아크릴", "#면적매트릭스", "#비종이류"]
updated: 2026-07-04
---

# product-157 아크릴네임택 (PRD_000157)

아크릴네임택은 **아크릴 굿즈 완제품 단품**(비종이·UV 평판·규격 사이즈형 nonspec_yn=N). 규격
(60x60·55x86 포토카드) 선택 → 컬러아크릴 **면적매트릭스** 통가격 조회. `t_prd_product_sets` 부모
없음 = 일반 단일 완제품(has_member 없음).

## 차원
- **사이즈:** 규격 2행(60x60 `SIZ_000148`·55x86 포토카드 `SIZ_000012`·전부 재사용). nonspec_yn=N(자유치수
  없음·규격 택1). ★가격은 여전히 면적매트릭스(W×H) 조회(BYSIZ 폐기·면적공식 환원 배포·prod-formulas note).
- **수량규칙:** min 1·max 10000·incr 1.

## 자재·공정
- **substrate:** 아크릴 투명 3mm(`MAT_000043`·dflt_yn=Y·유일 자재·[[material-MAT_000043]]).
- **공정:** UV 인쇄(`PROC_000002`·mand).

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 2행 실재·면적공식 미참조 → 가격영향 없음([GAP-AC-3]·T-9). `has_plate_size` 미배선.

## 옵션·제약·추가상품
- **옵션그룹 1:** 사이즈 택1(`OPT_000075`·SEL_TYPE.01·mand_yn=Y). ★option_items **0행**(og만 있고 oi 없음·
  [GAP-AC-4]) → option_refs 엣지 미배선(가리킬 item 부재). 상세=[[product-157-acrylic-nametag-photocard-nodes]].
- **제약:** `t_prd_product_constraints` = 아크릴 전 상품 0행(pack §3.9). **추가상품:** addon 0행.

## 가격 경로 (D-18)
- `product-157 --priced_by--> formula-PRF_CLR_ACRYL --has_component--> component-COMP_ACRYL_CLEAR3T`
  (면적매트릭스 277셀·silsa 동형). `t_prd_product_prices` 0행 = 직접룩업 아님(T-7). 값=evaluate_price 권위.

## 승계·freshness 메모
- 07-04 신규 SELECT 캐시(pack §0.2·note 'BYSIZ폐기·환원배포'). snapshot 가격 금지(T-2).
