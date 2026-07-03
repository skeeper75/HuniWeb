---
id: product-155-acrylic-ballpen
type: product
anchor: t_prd_products/PRD_000155
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000155(prd_nm=아크릴볼펜·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "prd:PRD_000155→PRF_ACRYL_BALLPEN→COMP_ACRYL_BALLPEN·PRICE_TYPE.02·use_dims [siz_cd,min_qty]·3셀 1800~2700", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live SELECT t_prd_product_categories/materials/processes/sizes", source_locator: "PRD_000155 cat CAT_000322·mat 043·proc PROC_000002·siz 336/330/333(re-measured 2026-07-04)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-live0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M3 고정가형 by-siz·§4 고정가형 견적가능·T-7·§3.5 substrate 두께(3mm)", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, qualifier: main, note: "단품형 아크릴(상위 CAT_000009·live re-measured 2026-07-04)"}
  - {rel: has_size, target: size-SIZ_000336, note: "20x20(dflt_yn=Y·가격 siz_cd 차원)"}
  - {rel: has_size, target: size-SIZ_000330, note: "30x30mm(dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000333, note: "40x40mm(dflt_yn=Y)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm·MAT_TYPE.03·USAGE.07·dflt_yn=Y(substrate 두께)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV(mand_proc_yn=Y·아크릴 정체 인쇄공정)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_BALLPEN, note: "고정가형 by-siz 공식(component_prices 기반·직접룩업 아님·T-7). SA-3 공유공식"}
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
  nonspec_yn: "Y (live re-measured 2026-07-04·universe cache=N 드리프트·가격축은 siz_cd 룩업 3종)"
  가격상태: "견적가능·고정가형 by-siz(PRF_ACRYL_BALLPEN→COMP_ACRYL_BALLPEN·3셀 1,800~2,700·값 미전사·evaluate_price 권위)"
  아크릴부속: "볼펜심(펜 본체 부속)은 uses_material 아님(pack §5 CL-3 지침·substrate=아크릴판 3mm)"
standards: {schema_org: "Product", xjdf: "Product(아크릴볼펜/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴볼펜 가격 경로)", "조건 탐색(볼펜 규격 3종)"]
tags: ["#굿즈", "#아크릴", "#볼펜", "#고정가형", "#비종이", "#단품형"]
updated: 2026-07-04
---

# 아크릴볼펜 (product-155-acrylic-ballpen)

아크릴볼펜(PRD_000155)은 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이). 손님이 **규격
(20x20/30x30mm/40x40mm)** 을 고르면 **고정가형 by-siz 공식**에서 완제품 단가를 조회한다(sets 0행·단품).

## 정체·유형 (SOT 준수)
- 완제품(.01) 일반 단일 제조상품 — 셋트 아님. has_member 없음.
- 카테고리 = **단품형 `CAT_000322`**(상위 아크릴 `CAT_000009`·live 재측정 2026-07-04).

## 차원
- **사이즈:** 규격 3행(20x20 `SIZ_000336` / 30x30mm `SIZ_000330` / 40x40mm `SIZ_000333`·dflt_yn=Y·del_yn=N).
  siz_cd = **가격 차원**(use_dims=`[siz_cd,min_qty]`). live `nonspec_yn=Y`(캐시=N 드리프트)이나 가격은 규격 룩업.
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01·수량 티어 min_qty).

## 자재·공정
- **자재(substrate):** `MAT_000043 아크릴 투명 3mm`(MAT_TYPE.03·USAGE.07·dflt_yn=Y) — 아크릴 본판 두께(pack §3.5).
  ★**볼펜심(펜 본체 부속)은 substrate/uses_material 아님**(CL-3 지침·자재 오염 금지). IMPORT 자재 삭제 금지.
- **공정:** `PROC_000002 UV`(mand_proc_yn=Y) — 아크릴 UV 평판 인쇄. 정체 공정 실재(153/166과 달리 MISSING 아님).

## 판형 (★비종이류 — 해당 없음·양면)
- `t_prd_product_plate_sizes` = **3행 실재하나 전부 `del_yn=Y`(논리삭제·활성 0)**. 비종이라 판형 로직 미적용
  ([[rule/rules#RULE_plate_paper_only]]). 공식 use_dims에 plt_siz_cd 없음 → **가격영향 없음**·`has_plate_size` 미배선(T-9).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-155 --priced_by--> [[formula-PRF_ACRYL_BALLPEN]] --has_component--> [[component-COMP_ACRYL_BALLPEN]]`.
  **연결됨**(3셀·1,800~2,700). 고정가형 by-siz(`[siz_cd,min_qty]`)·★직접단가룩업 아님(t_prd_product_prices 0행·T-7).
  값 미전사(evaluate_price).

## 옵션·제약·추가상품
- 옵션그룹 **0행**·제약규칙 **0행**·추가상품 **0행**(부속 없음·라이브 실측).

## 승계·freshness 메모
- M3·substrate·판형 양면 = pack §1.1·§3.5·§3.8(07-04 라이브 재측정). 공식/구성요소 = SA-3 공유축.
- ★live-snapshot 가격 정본 금지(H-1·T-2) — 07-04 신규 SELECT 인용.

## 이 상품 전용 하위 노드 (product-local 사이즈 — 가격 siz_cd 차원)
