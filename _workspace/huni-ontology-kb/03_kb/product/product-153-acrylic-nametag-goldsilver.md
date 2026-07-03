---
id: product-153-acrylic-nametag-goldsilver
type: product
anchor: t_prd_products/PRD_000153
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000153(prd_nm=아크릴명찰(골드실버)·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "prd:PRD_000153→PRF_ACRYL_NAMETAG_GS→COMP_ACRYL_NAMETAG_GS·PRICE_TYPE.02·use_dims [siz_cd,min_qty]·3셀 3400~4700", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live SELECT t_prd_product_categories/materials/processes/sizes", source_locator: "PRD_000153 cat CAT_000322·mat 195/196·proc 0행·siz 346/348/350(re-measured 2026-07-04)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M3 고정가형 by-siz·§4 고정가형 견적가능·T-7(직접룩업 아님)·§3.5 골드실버 substrate", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, qualifier: main, note: "단품형 아크릴(상위 CAT_000009·live re-measured 2026-07-04·main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000346, note: "60x20(dflt_yn=Y·가격 siz_cd 차원)"}
  - {rel: has_size, target: size-SIZ_000348, note: "70x25(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000350, note: "80x30(dflt_yn=Y)"}
  - {rel: uses_material, target: material-MAT_000196, note: "아크릴(실버)·MAT_TYPE.20·USAGE.07·dflt_yn=Y(substrate 색상판 택1·부속 아님)"}
  - {rel: uses_material, target: material-MAT_000195, note: "아크릴(골드)·MAT_TYPE.20·USAGE.07·dflt_yn=Y(substrate 색상판 택1)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_NAMETAG_GS, note: "고정가형 by-siz 공식(component_prices 기반·직접단가룩업 아님·T-7). SA-3 공유공식(acrylic-formulas.md)"}
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
  nonspec_yn: "Y (live re-measured 2026-07-04·universe cache=N 드리프트·가격축은 siz_cd 룩업이라 실질 규격 3종)"
  가격상태: "견적가능·고정가형 by-siz(PRF_ACRYL_NAMETAG_GS→COMP_ACRYL_NAMETAG_GS·3셀 3,400~4,700·값 미전사·evaluate_price 권위)"
  공정: "미적재(t_prd_product_processes 활성 0행·MISSING·정직)"
standards: {schema_org: "Product", xjdf: "Product(아크릴명찰/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴명찰 골드실버 가격 경로)", "조건 탐색(골드/실버 색상·규격 3종)"]
tags: ["#굿즈", "#아크릴", "#명찰", "#고정가형", "#비종이", "#단품형"]
updated: 2026-07-04
---

# 아크릴명찰(골드실버) (product-153-acrylic-nametag-goldsilver)

아크릴명찰(골드실버)(PRD_000153)은 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이).
손님이 **규격(60x20/70x25/80x30)** 과 **색상판(골드/실버)** 을 고르면 **고정가형 by-siz 공식**에서
완제품 단가를 조회한다(`t_prd_product_sets` 부모 없음 → 단품·[[product-type-classification-sot]]).

## 정체·유형 (SOT 준수)
- 완제품(.01) 일반 단일 제조상품 — 셋트 아님(sets 0행). has_member 없음.
- 카테고리 = **단품형 `CAT_000322`**(상위 아크릴 `CAT_000009`·live 재측정 2026-07-04·main_cat_yn=N).

## 차원
- **사이즈:** 규격 3행(60x20 `SIZ_000346` / 70x25 `SIZ_000348` / 80x30 `SIZ_000350`·전부 dflt_yn=Y·del_yn=N).
  이 siz_cd가 **가격 차원**(공식 use_dims=`[siz_cd,min_qty]`). ★live `nonspec_yn=Y`(universe 캐시=N와 드리프트·
  2026-07-04 재측정) — 자유치수 UI 플래그이나 가격 권위는 규격 siz_cd 룩업(3셀).
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01). use_dims에 `min_qty` 포함(수량 티어).
- **도수:** 아크릴 UV 평판이라 도수 컬럼 축 얕음(단가에 흡수·pack §3.3).

## 자재·공정
- **자재(substrate):** `MAT_000196 아크릴(실버)` + `MAT_000195 아크릴(골드)` — **둘 다 `MAT_TYPE.20 아크릴`·USAGE.07·
  dflt_yn=Y**. 색상판 택1(골드/실버)이 **substrate(아크릴 본판)** 이지 부속(addon)이 아니다(pack §3.5·T-8). 색상값을
  부속으로 오모델 금지. ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** `t_prd_product_processes` 활성 **0행(MISSING·정직)** — UV/레이저커팅 등 미적재([GAP-AC-2]·pack §3.6).
  결함 후보이나 값 부재의 정직 표기(가격은 공식 완제품가라 공정 미적재가 견적 0을 유발하지 않음).

## 판형 (★비종이류 — 해당 없음·양면)
- `t_prd_product_plate_sizes` = **3행 실재하나 전부 `del_yn=Y`(논리삭제·활성 0행)**. 아크릴은 비종이(UV 평판)라
  판형·판걸이수(`fn_calc_pansu`·t_siz_pansu)는 종이류 전용([[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]).
  고정가형 공식 use_dims에 `plt_siz_cd` 없음 → **가격영향 없음**. `has_plate_size` 미배선(pack §3.8·T-9).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-153 --priced_by--> [[formula-PRF_ACRYL_NAMETAG_GS]] --has_component--> [[component-COMP_ACRYL_NAMETAG_GS]]`.
  **가격 경로 연결됨**(고아 아님) — 공식이 완제품가 구성요소 1건(3셀·3,400~4,700) 배선.
- **고정가형 by-siz** = 원자합산형·면적매트릭스형과 다른 아키타입. `[siz_cd,min_qty]` 차원으로 규격별 완제품 단가 조회.
  ★**직접단가룩업(`t_prd_product_prices`) 아님**(아크릴 전량 0행·T-7). 값(unit_price)은 미전사(evaluate_price 권위).

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` **0행**(색상판은 자재 dflt로 표현·정규 옵션 미적재).
- **제약규칙:** `t_prd_product_constraints` **0행**(활성 제약 없음).
- **추가상품:** `t_prd_product_addons` **0행**(부속 없음).

## 승계·freshness 메모
- 가격모델·substrate·판형 양면 = pack §1.1 M3·§3.5·§3.8(FRESH·07-04 라이브 재측정). 공식/구성요소 = SA-3 공유축
  [[formula-PRF_ACRYL_NAMETAG_GS]]/[[component-COMP_ACRYL_NAMETAG_GS]](acrylic-formulas.md·acrylic-components.md).
- ★live-snapshot 가격 정본 금지(H-1·T-2) — 가격 사슬은 07-04 신규 SELECT/`acryl-price-chain-260704.csv` 인용.

## 이 상품 전용 하위 노드 (product-local 사이즈 — 가격 siz_cd 차원)

<!-- ★고정가형 use_dims=[siz_cd,min_qty]라 siz_cd가 가격 차원 → 규격 3행 product-local 민팅(search-before-mint: kb 미존재 확인). -->
<!-- 값(unit_price)은 미전사(D-18·evaluate_price). siz 라벨은 live t_siz_sizes verbatim. -->

### [size-SIZ_000346] 60x20 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000346
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000153,SIZ_000346) siz_nm=60x20·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "60x20", dflt_yn: "Y", note: "명찰 규격. 가격 siz_cd 차원(PRF_ACRYL_NAMETAG_GS)."}
- 본문: 아크릴명찰 규격 60x20. [[product-153-acrylic-nametag-goldsilver]] has_size 대상·고정가 룩업 키.

### [size-SIZ_000348] 70x25 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000348
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000153,SIZ_000348) siz_nm=70x25·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "70x25", dflt_yn: "Y", note: "명찰 규격. 가격 siz_cd 차원."}
- 본문: 아크릴명찰 규격 70x25. has_size 대상.

### [size-SIZ_000350] 80x30 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000350
- src: {source_file: "live SELECT t_prd_product_sizes+t_siz_sizes", source_locator: "키:(PRD_000153,SIZ_000350) siz_nm=80x30·dflt_yn=Y·del_yn=N", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
- props: {siz_nm: "80x30", dflt_yn: "Y", note: "명찰 규격. 가격 siz_cd 차원."}
- 본문: 아크릴명찰 규격 80x30. has_size 대상.
