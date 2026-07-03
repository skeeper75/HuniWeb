---
id: product-148-acrylic-badge
type: product
anchor: t_prd_products/PRD_000148
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000148(prd_nm=아크릴뱃지·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N·min1/max10000/incr1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "행:PRD_000148 frm PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적 277셀·2,000~32,700)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/pack-acrylic.md", source_locator: "§1.1 M1 면적매트릭스 본체·§3.5 substrate 두께·§3.8 판형 양면·§5.1 CL-1", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, note: "단품형(아크릴 CAT_000009 하위·main_cat_yn=N·live 유일 분류)"}
  - {rel: has_size, target: size-SIZ_000330, note: "30x30(면적매트릭스 W×H 입력)"}
  - {rel: has_size, target: size-SIZ_000333, note: "40x40"}
  - {rel: has_size, target: size-SIZ_000011, note: "50x50(재사용·product-046-label-tag-nodes 정의)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm=substrate 두께(dflt_yn=Y·면적매트릭스 mat_cd 차원). 부속(원형핀/1구자석)은 substrate 아님(T-8)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV 인쇄(mand_proc_yn=Y·정체 공정)"}
  - {rel: priced_by, target: formula-PRF_CLR_ACRYL, note: "컬러아크릴 면적매트릭스(공유 M1·has_component→COMP_ACRYL_CLEAR3T)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  nonspec_yn: "Y"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  editor_yn: "N"
  archetype: "면적매트릭스형(area-matrix·use_dims=[mat_cd,siz_width,siz_height,min_qty]·silsa 동형·off-grid ceiling)"
  plate_sizes_note: "plate_sizes 3행 실재하나 면적공식 미참조 → 가격영향 없음(비종이·T-9·fn_calc_pansu 금지)"
  addon_templates: "원형핀 TMPL-000019(600)·1구자석 TMPL-000020(1,000) — 부속(t_prd_templates·has_addon 대상 product 노드 없음·props 인용·GAP-AC-6)"
  부자재_note: "원형핀 MAT_000047·1구자석 MAT_000048 = dflt_yn=N 부속(MAT_TYPE.07)·substrate 아님·uses_material 미배선(오염 방지·T-8)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴)", config_ont: "component type"}
answers_cq: ["아크릴뱃지 가격 경로(면적매트릭스 조회)", "조건 탐색(아크릴 두께·크기)"]
tags: ["#굿즈", "#아크릴", "#면적매트릭스", "#비종이류"]
updated: 2026-07-04
---

# product-148 아크릴뱃지 (PRD_000148)

아크릴뱃지는 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이·UV 평판). 손님이
**크기(30x30·40x40·50x50 또는 자유치수)** 를 고르면 컬러아크릴 **[가로×세로] 면적매트릭스**에서
완제품 통가격을 조회한다. `t_prd_product_sets` 부모 등록이 없어 **일반 단일 완제품**(SOT 정합·
has_member 없음).

## 차원
- **사이즈:** 규격 3행(30x30 `SIZ_000330`·40x40 `SIZ_000333`·50x50 `SIZ_000011`) + **비규격 연속**
  (nonspec_yn=Y). 면적매트릭스는 siz_width×siz_height 격자(off-grid=한 단계 큰 규격 ceiling·앱 계산).
  규격 사이즈 노드 SIZ_000330/333은 병렬 아크릴 빌더(146/155/156/164)가 공유 정의(재-mint 회피)·
  SIZ_000011은 [[product-046-label-tag-nodes]] 재사용.
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01). 면적매트릭스 use_dims에 min_qty 포함(수량 티어).

## 자재·공정 (★substrate 두께 vs 부속·T-8)
- **substrate:** 아크릴 투명 3mm(`MAT_000043`·dflt_yn=Y). 면적매트릭스 `mat_cd` 차원 = **두께**이지
  색상값 아님(T-8). 공유 축 [[material-MAT_000043]] 재사용.
- **부속(substrate 아님):** 원형핀(`MAT_000047`)·1구자석(`MAT_000048`)은 dflt_yn=N 부자재(MAT_TYPE.07).
  addon 템플릿(TMPL-000019 원형핀 600·TMPL-000020 1구자석 1,000)로 별도 가산. `uses_material`에 배선하지
  않는다(오염 방지·pack §3.5·GAP-AC-6 부속 이중표현).
- **공정:** UV 인쇄(`PROC_000002`·mand_proc_yn=Y). 도수는 면적단가에 흡수(clr_cd=NULL·pack §3.3).

## 판형 (★비종이류 — 가격축 아님)
- `t_prd_product_plate_sizes` = 148에 3행 실재하나 면적공식(`COMP_ACRYL_CLEAR3T`) use_dims
  `[mat_cd,siz_width,siz_height,min_qty]`에 `plt_siz_cd` **없음** → 판형은 **가격영향 없음**(생산
  임포지션 메타 or 오적재 의심·[GAP-AC-3]). 종이류 `fn_calc_pansu` 로직 이식 금지(T-9·
  [[harness-domain-rules-12-260701]]). `has_plate_size` 미배선(정직).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-148 --priced_by--> formula-PRF_CLR_ACRYL --has_component--> component-COMP_ACRYL_CLEAR3T`.
  **면적매트릭스형**(silsa 포스터사인 [가로×세로] off-grid ceiling 동형). 단가행 277셀(2,000~32,700)은
  구성요소 속성으로 접음(D-22·값 미전사). ★`t_prd_product_prices` 0행 = 직접단가룩업 미사용 —
  `gap-goods-fixed-lookup` 아키타입 아님(T-7). 값 계산=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).

## 승계·freshness 메모
- 가격/자재/공정 = 07-04 신규 라이브 SELECT 캐시(pack §0.2·H-1 회피). live-snapshot 20260702_1119은
  아크릴 가격 정본 금지(T-2). 과업 대형 부속가(480k 등)는 라이브 부재=STALE(T-1).
