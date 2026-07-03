---
id: product-166-acrylic-carabiner
type: product
anchor: t_prd_products/PRD_000166
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000166(prd_nm=아크릴카라비너·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·editor_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "prd:PRD_000166→PRF_ACRYL_CARABINER→COMP_ACRYL_CARABINER·PRICE_TYPE.02·use_dims [siz_cd,min_qty]·4셀 5800~6900", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live SELECT t_prd_product_categories/materials/processes/sizes", source_locator: "PRD_000166 cat CAT_000322·mat 043·proc 0행·siz 366~369(re-measured 2026-07-04)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M3 고정가형 by-siz·§4 고정가형 견적가능·T-7·§3.6 공정 MISSING(153/166)", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, qualifier: main, note: "단품형 아크릴(상위 CAT_000009·live re-measured 2026-07-04)"}
  - {rel: has_size, target: size-SIZ_000366, note: "40x69mm자물쇠(dflt_yn=Y·가격 siz_cd 차원)"}
  - {rel: has_size, target: size-SIZ_000367, note: "43x71mm하트자물쇠(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000368, note: "59x54mm하트(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000369, note: "68x70mm원형(dflt_yn=Y)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm·MAT_TYPE.03·USAGE.07·dflt_yn=Y(substrate 두께)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_CARABINER, note: "고정가형 by-siz 공식(component_prices 기반·직접룩업 아님·T-7·완전 미적재 해소 R1). SA-3 공유공식"}
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
  editor_yn: "Y"
  nonspec_yn: "Y (live re-measured 2026-07-04·universe cache=N 드리프트·가격축은 siz_cd 룩업 4종)"
  가격상태: "견적가능·고정가형 by-siz(PRF_ACRYL_CARABINER→COMP_ACRYL_CARABINER·4셀 5,800~6,900·값 미전사·evaluate_price 권위)"
  공정: "미적재(t_prd_product_processes 활성 0행·MISSING·정직·153과 동류)"
standards: {schema_org: "Product", xjdf: "Product(아크릴카라비너/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴카라비너 가격 경로)", "조건 탐색(카라비너 형상 4종)"]
tags: ["#굿즈", "#아크릴", "#카라비너", "#고정가형", "#비종이", "#단품형"]
updated: 2026-07-04
---

# 아크릴카라비너 (product-166-acrylic-carabiner)

아크릴카라비너(PRD_000166)는 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이). 손님이 **형상
규격(자물쇠/하트자물쇠/하트/원형 4종)** 을 고르면 **고정가형 by-siz 공식**에서 완제품 단가를 조회한다
(sets 0행·단품). 에디터 지원(`editor_yn=Y`·이 클러스터에서 유일).

## 정체·유형 (SOT 준수)
- 완제품(.01) 일반 단일 제조상품 — 셋트 아님. has_member 없음.
- 카테고리 = **단품형 `CAT_000322`**(상위 아크릴 `CAT_000009`·live 재측정 2026-07-04).

## 차원
- **사이즈:** 형상 규격 4행(40x69mm자물쇠 `SIZ_000366` / 43x71mm하트자물쇠 `SIZ_000367` / 59x54mm하트
  `SIZ_000368` / 68x70mm원형 `SIZ_000369`·전부 dflt_yn=Y·del_yn=N). siz_cd = **가격 차원**(use_dims=`[siz_cd,min_qty]`·4셀).
  형상(자물쇠/하트/원형)이 siz 라벨에 녹아 있음. live `nonspec_yn=Y`(캐시=N 드리프트).
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01·수량 티어 min_qty).

## 자재·공정
- **자재(substrate):** `MAT_000043 아크릴 투명 3mm`(MAT_TYPE.03·USAGE.07·dflt_yn=Y·pack §3.5). IMPORT 자재 삭제 금지.
- **공정:** `t_prd_product_processes` 활성 **0행(MISSING·정직·153과 동류)** — UV/레이저커팅 미적재([GAP-AC-2]·pack §3.6).
  값 부재의 정직 표기(가격은 공식 완제품가라 공정 미적재가 견적 0을 유발하지 않음).

## 판형 (★비종이류 — 해당 없음·양면)
- `t_prd_product_plate_sizes` = **166 행 없음(0행)**. 비종이라 판형 로직 미적용([[rule/rules#RULE_plate_paper_only]]).
  `has_plate_size` 미배선(T-9·pack §3.8).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-166 --priced_by--> [[formula-PRF_ACRYL_CARABINER]] --has_component--> [[component-COMP_ACRYL_CARABINER]]`.
  **연결됨**(4셀·5,800~6,900·완전 미적재 해소 R1). 고정가형 by-siz(`[siz_cd,min_qty]`)·★직접단가룩업 아님
  (t_prd_product_prices 0행·T-7). 값 미전사(evaluate_price).

## 옵션·제약·추가상품
- 옵션그룹 **0행**·제약규칙 **0행**·추가상품 **0행**(라이브 실측).

## 승계·freshness 메모
- M3·substrate·공정 MISSING·판형 없음 = pack §1.1·§3.5·§3.6·§3.8(07-04 라이브 재측정). 공식/구성요소 = SA-3 공유축.
- ★live-snapshot 가격 정본 금지(H-1·T-2) — 07-04 신규 SELECT 인용.

## 이 상품 전용 하위 노드 (product-local 사이즈 — 가격 siz_cd 차원)

### [size-SIZ_000366] 40x69mm자물쇠 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000366
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000166,SIZ_000366) siz_nm=40x69mm자물쇠·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "40x69mm자물쇠", dflt_yn: "Y", note: "카라비너 형상 규격. 가격 siz_cd 차원."}
- 본문: 아크릴카라비너 자물쇠형 40x69mm. [[product-166-acrylic-carabiner]] has_size 대상.

### [size-SIZ_000367] 43x71mm하트자물쇠 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000367
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000166,SIZ_000367) siz_nm=43x71mm하트자물쇠·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "43x71mm하트자물쇠", dflt_yn: "Y", note: "카라비너 형상 규격. 가격 siz_cd 차원."}
- 본문: 아크릴카라비너 하트자물쇠형 43x71mm. has_size 대상.

### [size-SIZ_000368] 59x54mm하트 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000368
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000166,SIZ_000368) siz_nm=59x54mm하트·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "59x54mm하트", dflt_yn: "Y", note: "카라비너 형상 규격. 가격 siz_cd 차원."}
- 본문: 아크릴카라비너 하트형 59x54mm. has_size 대상.

### [size-SIZ_000369] 68x70mm원형 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000369
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000166,SIZ_000369) siz_nm=68x70mm원형·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "68x70mm원형", dflt_yn: "Y", note: "카라비너 형상 규격. 가격 siz_cd 차원."}
- 본문: 아크릴카라비너 원형 68x70mm. has_size 대상.
