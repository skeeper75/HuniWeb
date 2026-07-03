---
id: product-159-acrylic-coaster
type: product
anchor: t_prd_products/PRD_000159
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000159(prd_nm=아크릴 코스터·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=N·del_yn=N·min1/max10000/incr1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "행:PRD_000159 frm PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적 277셀·2,000~32,700)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/pack-acrylic.md", source_locator: "§4 미출시(use_yn=N)·§1.1 M1·§3.9 옵션 items 0·§5.1 CL-1", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, note: "단품형(아크릴 CAT_000009 하위·main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000328, note: "데코소품(보조·main_cat_yn=N·굿즈 축 재사용)"}
  - {rel: has_size, target: size-SIZ_000355, note: "100x100mm원형(면적매트릭스 W×H)"}
  - {rel: has_size, target: size-SIZ_000356, note: "100x100mm사각"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm=substrate(dflt_yn=Y·유일 자재)"}
  - {rel: priced_by, target: formula-PRF_CLR_ACRYL, note: "컬러아크릴 면적매트릭스(공유 M1·미출시라도 공식 바인딩됨)"}
  - {rel: has_option_group, target: optgroup-159-size, note: "사이즈 택1(OPT_000074·items 0=GAP-AC-4)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  nonspec_yn: "N"
  use_yn: "N"
  del_yn: "N"
  status: "미출시(use_yn=N)"
  추천노출: "추천 결과 제외(미출시·use_yn=N)·팬텀 가격 금지 — 미출시 형제(164/165/168/169/170/226)와 badge=candidate 통일(L-AC 일관성·D-AC LOW-1)"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  editor_yn: "N"
  archetype: "면적매트릭스형(area-matrix·규격 코스터 사이즈 2종·미출시)"
  plate_sizes_note: "plate_sizes 1행 실재·면적공식 미참조 → 가격영향 없음(비종이·T-9)"
  process_note: "공정 0행(MISSING·[GAP-AC-2])·UV 미배선(미출시 미완비)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴)", config_ont: "component type"}
answers_cq: ["아크릴 코스터 상태(미출시)", "조건 탐색(코스터 규격)"]
tags: ["#굿즈", "#아크릴", "#면적매트릭스", "#비종이류", "#미출시"]
updated: 2026-07-04
---

# product-159 아크릴 코스터 (PRD_000159) — ★미출시(use_yn=N)

아크릴 코스터는 **아크릴 굿즈 완제품 단품**(비종이·UV 평판)이나 라이브에서 **미출시**(`use_yn=N`·
`del_yn=N`·정상 등록·미노출). **추천 결과에서 제외**한다(팬텀 가격 금지·정직 표기·pack §4). 가격
공식은 바인딩됐으므로(면적매트릭스 277셀) 출시 시 견적 가능. `t_prd_product_sets` 부모 없음 = 일반
단일 완제품(has_member 없음).

## 차원
- **사이즈:** 규격 2행(100x100mm원형 `SIZ_000355`·100x100mm사각 `SIZ_000356`). nonspec_yn=N.
  가격은 면적매트릭스(W×H) 조회. 상세=[[product-159-acrylic-coaster-nodes]].
- **수량규칙:** min 1·max 10000·incr 1.

## 자재·공정
- **substrate:** 아크릴 투명 3mm(`MAT_000043`·dflt_yn=Y·유일 자재·[[material-MAT_000043]]).
- **공정:** ★`t_prd_product_processes` = 159에 **0행**(MISSING·[GAP-AC-2]). UV 공정 미배선(미출시
  미완비·출시 시 필요). `has_process` 미배선(정직).

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 1행 실재·면적공식 미참조 → 가격영향 없음([GAP-AC-3]·T-9). `has_plate_size` 미배선.

## 옵션·제약·추가상품
- **옵션그룹 1:** 사이즈 택1(`OPT_000074`·SEL_TYPE.01·mand_yn=Y). ★option_items **0행**([GAP-AC-4]) →
  option_refs 미배선. 상세=[[product-159-acrylic-coaster-nodes]]. **제약:** 0행. **addon:** 0행.

## 가격 경로 (D-18)
- `product-159 --priced_by--> formula-PRF_CLR_ACRYL --has_component--> component-COMP_ACRYL_CLEAR3T`
  (면적매트릭스 277셀). 공식 바인딩 실재하나 **미출시**라 손님 노출 안 됨. `t_prd_product_prices`
  0행 = 직접룩업 아님(T-7). 값=evaluate_price 권위.

## 승계·freshness 메모
- 07-04 신규 SELECT 캐시(pack §0.2·§4 미출시표). snapshot 가격 금지(T-2). 미출시=정직(팬텀 금지).
