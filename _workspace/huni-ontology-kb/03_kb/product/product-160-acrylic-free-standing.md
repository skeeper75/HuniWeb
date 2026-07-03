---
id: product-160-acrylic-free-standing
type: product
anchor: t_prd_products/PRD_000160
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000160(prd_nm=아크릴자유형스탠드·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "prd:PRD_000160→PRF_ACRYL_FREESTAND→COMP_ACRYL_FREESTAND·PRICE_TYPE.02·use_dims [siz_cd,min_qty]·5셀 8800~22600", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live SELECT t_prd_product_categories/materials/processes/sizes", source_locator: "PRD_000160 cat CAT_000155·mat 043·proc PROC_000002·siz 357~361(re-measured 2026-07-04)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M3 고정가형 by-siz·§4 고정가형 견적가능·T-7·§3.5 substrate 두께(3mm)", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000155, qualifier: main, note: "조합형 아크릴(상위 CAT_000009·live re-measured 2026-07-04·disp_seq 1)"}
  - {rel: has_size, target: size-SIZ_000357, note: "120x60(dflt_yn=Y·가격 siz_cd 차원)"}
  - {rel: has_size, target: size-SIZ_000358, note: "120x90(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000359, note: "120x120(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000360, note: "120x150(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000361, note: "120x180(dflt_yn=Y)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm·MAT_TYPE.03·USAGE.07·dflt_yn=Y(substrate 두께)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV(mand_proc_yn=Y·아크릴 정체 인쇄공정)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_FREESTAND, note: "고정가형 by-siz 공식(component_prices 기반·직접룩업 아님·T-7). SA-3 공유공식"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "고정가형 by-siz(공식기반·COMP use_dims=[siz_cd,min_qty]·직접룩업 아님·T-7)"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "N"
  nonspec_yn: "N (live re-measured 2026-07-04·universe 캐시와 일치)"
  가격상태: "견적가능·고정가형 by-siz(PRF_ACRYL_FREESTAND→COMP_ACRYL_FREESTAND·5셀 8,800~22,600·값 미전사·evaluate_price 권위)"
  카테고리성격: "조합형(CAT_000155)이나 옵션그룹 0행 — 규격 siz_cd 5종 직접선택(옵션 레이어 미적재)"
standards: {schema_org: "Product", xjdf: "Product(아크릴스탠드/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴자유형스탠드 가격 경로)", "조건 탐색(스탠드 규격 5종)"]
tags: ["#굿즈", "#아크릴", "#스탠드", "#고정가형", "#비종이", "#조합형"]
updated: 2026-07-04
---

# 아크릴자유형스탠드 (product-160-acrylic-free-standing)

아크릴자유형스탠드(PRD_000160)는 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이). 손님이
**규격(120x60 ~ 120x180 5종)** 을 고르면 **고정가형 by-siz 공식**에서 완제품 단가를 조회한다(sets 0행·단품).

## 정체·유형 (SOT 준수)
- 완제품(.01) 일반 단일 제조상품 — 셋트 아님. has_member 없음.
- 카테고리 = **조합형 `CAT_000155`**(상위 아크릴 `CAT_000009`·live 재측정 2026-07-04·disp_seq 1). ★조합형이나
  라이브 옵션그룹 0행 — 규격 siz_cd 5종을 product_sizes로 직접 선택(정규 옵션 레이어 미적재).

## 차원
- **사이즈:** 규격 5행(120x60 `SIZ_000357` / 120x90 `SIZ_000358` / 120x120 `SIZ_000359` / 120x150 `SIZ_000360` /
  120x180 `SIZ_000361`·전부 dflt_yn=Y·del_yn=N). siz_cd = **가격 차원**(use_dims=`[siz_cd,min_qty]`·5셀). live
  `nonspec_yn=N`(규격 고정).
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01·수량 티어 min_qty).

## 자재·공정
- **자재(substrate):** `MAT_000043 아크릴 투명 3mm`(MAT_TYPE.03·USAGE.07·dflt_yn=Y·pack §3.5). IMPORT 자재 삭제 금지.
- **공정:** `PROC_000002 UV`(mand_proc_yn=Y·아크릴 UV 평판 인쇄·정체 공정 실재).

## 판형 (★비종이류 — 해당 없음·양면)
- `t_prd_product_plate_sizes` = **5행 실재하나 전부 `del_yn=Y`(논리삭제·활성 0)**. 비종이라 판형 로직 미적용
  ([[rule/rules#RULE_plate_paper_only]])·공식 use_dims에 plt_siz_cd 없음 → **가격영향 없음**·`has_plate_size` 미배선(T-9).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-160 --priced_by--> [[formula-PRF_ACRYL_FREESTAND]] --has_component--> [[component-COMP_ACRYL_FREESTAND]]`.
  **연결됨**(5셀·8,800~22,600). 고정가형 by-siz(`[siz_cd,min_qty]`)·★직접단가룩업 아님(t_prd_product_prices 0행·T-7).
  값 미전사(evaluate_price).

## 옵션·제약·추가상품
- 옵션그룹 **0행**(조합형이나 옵션 미적재)·제약규칙 **0행**·추가상품 **0행**(라이브 실측).

## 승계·freshness 메모
- M3·substrate·판형 양면 = pack §1.1·§3.5·§3.8(07-04 라이브 재측정). 공식/구성요소 = SA-3 공유축.
- ★live-snapshot 가격 정본 금지(H-1·T-2) — 07-04 신규 SELECT 인용.

## 이 상품 전용 하위 노드 (product-local 사이즈 — 가격 siz_cd 차원)

### [size-SIZ_000357] 120x60 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000357
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000160,SIZ_000357) siz_nm=120x60·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "120x60", dflt_yn: "Y", note: "스탠드 규격. 가격 siz_cd 차원."}
- 본문: 아크릴자유형스탠드 규격 120x60. [[product-160-acrylic-free-standing]] has_size 대상.

### [size-SIZ_000358] 120x90 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000358
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000160,SIZ_000358) siz_nm=120x90·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "120x90", dflt_yn: "Y", note: "스탠드 규격. 가격 siz_cd 차원."}
- 본문: 아크릴자유형스탠드 규격 120x90. has_size 대상.

### [size-SIZ_000359] 120x120 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000359
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000160,SIZ_000359) siz_nm=120x120·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "120x120", dflt_yn: "Y", note: "스탠드 규격. 가격 siz_cd 차원."}
- 본문: 아크릴자유형스탠드 규격 120x120. has_size 대상.

### [size-SIZ_000360] 120x150 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000360
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000160,SIZ_000360) siz_nm=120x150·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "120x150", dflt_yn: "Y", note: "스탠드 규격. 가격 siz_cd 차원."}
- 본문: 아크릴자유형스탠드 규격 120x150. has_size 대상.

### [size-SIZ_000361] 120x180 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000361
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000160,SIZ_000361) siz_nm=120x180·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "120x180", dflt_yn: "Y", note: "스탠드 규격. 가격 siz_cd 차원."}
- 본문: 아크릴자유형스탠드 규격 120x180. has_size 대상.
