---
id: product-143-mirror-acrylic-sticker
type: product
anchor: t_prd_products/PRD_000143
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000143(prd_nm=미러아크릴스티커·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 고정가형 15상품 중 미러아크릴스티커143·§3.1·§3.7(아크릴 UV 라우팅)·§3.8(비종이류 판형없음)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_ACRYLSTK_MIRROR use_dims=[siz_cd](고정가 룩업·siz 단일축·면적매트릭스 아님)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000005, note: "사인(cat_lvl=1 root·main_cat_yn=Y·143-nodes 첫 정의)"}
  - {rel: in_category, target: category-CAT_000092, note: "시트커팅/스티커(cat_lvl=2·upr=CAT_000005·main_cat_yn=N·143-nodes 첫 정의)"}
  - {rel: has_size, target: size-SIZ_000324, note: "290x90mm(dflt_yn=Y·del_yn=N·아크릴스티커 규격)"}
  - {rel: has_size, target: size-SIZ_000325, note: "290x190mm(dflt_yn=Y·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000326, note: "390x290mm(dflt_yn=Y·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000327, note: "590x390mm(dflt_yn=Y·del_yn=N·최대 규격)"}
  - {rel: uses_material, target: material-MAT_000377, note: "아크릴(골드) 3mm(USAGE.07·MAT_TYPE.20 아크릴·구 골드 .08에서 07-01 재키잉)"}
  - {rel: uses_material, target: material-MAT_000378, note: "아크릴(실버) 3mm(USAGE.07·MAT_TYPE.20 아크릴·구 실버 .08에서 07-01 재키잉)"}
  - {rel: has_process, target: process-PROC_000124, qualifier: mandatory, note: "레이저커팅(mand_proc_yn=Y·상위 PROC_000121 커팅·아크릴 절단)"}
  - {rel: has_qty_rule, target: qty-143, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: has_option_group, target: optgroup-143-color, note: "칼라(골드/실버 아크릴 택1·option_refs→자재·가격 무관)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ACRYLSTK_MIRROR, note: "완제품가 고정가 룩업형(siz_cd 셀단가·수량축/자재축 없음)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "고정가 룩업형(fixed·use_dims=[siz_cd]·규격별 셀단가·수량축/자재축 없음·골드/실버 동일가)"
standards: {schema_org: Product, xjdf: "Product(아크릴 스티커/Sign·LayoutIntent FinishedDimensions·CuttingParams 레이저)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(미러아크릴스티커 가격 경로)", "조건 탐색(아크릴 사인·골드/실버 칼라·규격)"]
tags: ["#실사", "#사인", "#아크릴스티커", "#미러아크릴", "#고정가룩업", "#비종이류"]
updated: 2026-07-03
---

# product-143 미러아크릴스티커 (PRD_000143)

미러아크릴스티커는 **실사(대형 실사 출력물·사인 계열)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(290x90/290x190/390x290/590x390)** 과 **칼라(골드/실버 아크릴)** 를 고르면,
`(사이즈 siz_cd)` **고정가 룩업**에서 **완제품 통가격**(아크릴 소재+출력+레이저커팅 포함)을 조회한다.
★칼라(골드/실버)는 자재 선택이지만 **가격을 바꾸지 않는다**(use_dims=[siz_cd]·골드/실버 동일가). 파일 업로드
방식(`file_upload_yn=Y`, 에디터 미사용·`nonspec_yn=N`이라 비규격 자유치수 없음). 수치는
[[product-143-mirror-acrylic-sticker-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 미러아크릴스티커는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 005 사인 하위 092 시트커팅/스티커). 아크릴 스티커 완제품 — 굿즈/포장재 아님.
- 카테고리: 사인 `CAT_000005`(root·main_cat_yn=Y) + 시트커팅/스티커 `CAT_000092`(leaf·lvl2·upr=CAT_000005).
  ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은
  `del_yn=Y` 논리삭제(06-18)됐고 143은 정상 카테고리 노드로 재연결됨(pack §1.1·§4 T-1). 현재
  상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 이산 규격 **4행**(SIZ_000324 290x90 / SIZ_000325 290x190 / SIZ_000326 390x290 /
  SIZ_000327 590x390·전부 dflt_yn=Y·del_yn=N·태그 아크릴스티커). `nonspec_yn=N`이라 **비규격 연속범위가
  아예 없다**(118/126 포스터의 사용자입력 치수 UX와 차이·pack §3.2 부수). ★이 4규격이 곧 가격
  룩업 키(use_dims=[siz_cd]·off-grid 없음).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 143 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖). ★상품의 "칼라" 옵션그룹은 도수가 아니라 **소재(골드/실버) 선택**(아래 옵션 절).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  143 행 **없음**(제품 레벨 규칙만). ★고정가 룩업형이라 **수량축이 가격 차원이 아니다** —
  구성요소 use_dims=[siz_cd]에 수량축이 없고 4셀 전부 min_qty NULL(수량무관 통가격). 셀단가는
  아크릴스티커 1장가이며 총액=셀단가×수량(수량구간 할인 없음·t_dsc_* 0행). 수량 UI 권위=제품 수량규칙(가격
  구간과 역할 분리·pack §3.4).

## 자재·공정
- **자재:** **아크릴 2종(골드/실버·3mm·낱장 완제품·내지/표지 없음·pack §3.5)** — `MAT_000377`(아크릴 골드
  3mm·상위 MAT_000195)·`MAT_000378`(아크릴 실버 3mm·상위 MAT_000196). 둘 다 `MAT_TYPE.20 아크릴`·
  USAGE.07 단일 슬롯. ★**재키잉 이력("레더 .08→.06 주의"의 아크릴판):** 구 골드 `MAT_000258`·실버
  `MAT_000259`(둘 다 `MAT_TYPE.08 실사소재`)가 07-01 상품에서 언링크(del_yn=Y)·마스터도 06-16 논리삭제
  됐고, `.20 아크릴` 전용 자재로 교체됐다. **현행 .20 = 현재값이자 정합**(권위가 지목한 목표 라벨 충돌
  없음·양면 defect 아님·전사표 이력 보존). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 레이저커팅 `PROC_000124`(상위 PROC_000121 커팅·**mand_proc_yn=Y**·del_yn=N·06-29 신설) —
  아크릴 판재를 규격대로 절단하는 **필수공정**. ★pack §3.7이 아크릴스티커(142/143)를 **UV `PROC_000002`
  인쇄 라인**으로 지목하나, 라이브 `t_prd_product_processes`엔 레이저커팅만 부착되고 **UV 인쇄방식 공정
  행은 부재**(print_options=0·실사 도수 없음)(→[[product-143-mirror-acrylic-sticker-nodes#gap-143-uv-print-routing]]·pack Q-SL-A·영향 작음). 가격은
  (규격) 완제품 통가격이라 레이저커팅·출력이 통가격에 포함(comp note "소재+출력+가공 포함 통가격"·pack §3.10).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 143에 4행(SIZ_000324~327) 있으나 `output_paper_typ_cd`가
  **전부 공란**이고 용도가 "파일사양"(output_file_typ=AI)이며 **전부 `del_yn=Y`(2026-06-30 정리)** —
  판걸이수 산정용 출력용지 판형이 아니라 삭제된 파일 규격 플레이스홀더다. ★아크릴 스티커는 **비종이류**라
  절수 기반 전지 규격이 무의미(낱장 임포지션 없음·레이저 절단) → 판형(`fn_best_plate`)·판걸이수
  (`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·
  [[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를
  걸지 않는다(정직 표기·환각 방지·130 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-143 --priced_by--> formula-PRF_POSTER_ACRYLSTK_MIRROR --has_component--> component-COMP_POSTER_ACRYLSTK_MIRROR`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components 실측·pack §27 배선 정합).
- **고정가 룩업형** = 면적매트릭스형(118/122/126 포스터·가로×세로)·원자합산형(디지털 인쇄+용지+공정 합산)과
  **다른 아키타입**. 단일 구성요소 `COMP_POSTER_ACRYLSTK_MIRROR`를 use_dims **1축(사이즈 siz_cd)** 으로
  조회한다. ★130(mat_cd×siz_cd 2축)보다 단순한 **siz 단일축** — 골드/실버(칼라 옵션)는 단가행 mat_cd 컬럼이
  공란이라 **가격을 바꾸지 않는다**(동일가). 격자=**유효 4셀**(규격 4종)이 이 빠짐 없이 충전(전사표 grid_full·
  수량축 없음·min_qty NULL).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note)이며 계산은 엔진 권위.

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 143 행 **1**(칼라 `OPT-000046`·SEL_TYPE.01·min0/max1·mand N).
  ★130(옵션그룹 0행)과 달리 143은 손님 선택 CPQ 축이 실재한다 — 골드아크릴(`OPV-000095`)·실버아크릴
  (`OPV-000096`) 택1. 두 옵션의 option_items가 `OPT_REF_DIM.03(자재)`로 `MAT_000377`/`MAT_000378`을 참조
  (다형참조). ★타깃 자재가 부모 상품 143의 uses_material 차원에 실재하므로 `fn_chk_opt_item_ref` 무결성 정합
  (L-18 통과·[[product-143-mirror-acrylic-sticker-nodes#optgroup-143-color]]). ★칼라 선택이 가격을 바꾸지 않음(가격 use_dims=[siz_cd]·골드/실버 동일가).
- **제약규칙:** `t_prd_product_constraints` = 143 행 **0**. 143은 pack §1.1의 constraints 신규 발현
  7상품(118/120/121/122/124/125/139)에 **포함되지 않는다** — 0행이 현재값(nonspec_yn=N이라 사용자입력
  치수 범위 제약 자체가 불필요·defect 아님·양면 불요).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 143 행 **없음**. 143은 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·소재계열·고정가형 분기는 pack §3.1·§3.7·§3.8·§3.10(FRESH·INHERIT) 승계·재검증. 143=고정가 15상품(아크릴스티커).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 143은 정상 카테고리 연결(사인+시트커팅/스티커). constraints는 143이 신규 발현 7상품에 없어 0행이
  정당(SL-CPQ-003 재조준 결과 143=무관). round-13/위키를 그대로 옮기면 오염이라 live-snapshot
  20260702_1119 실측으로 재판정(현재값=정답).
- ★면적매트릭스 오모델 회피(T-4·T-5): 143은 **면적매트릭스가 아니라 고정가 룩업**(use_dims=[siz_cd])
  임을 라이브 실측으로 확정 — "29 실사 전부 면적매트릭스로 일괄"(round-2 오모델·pack §3.10 적대적 주의)에
  넘어가지 않음. 공식 frm_nm이 "(면적/규격 단가)"로 명명됐으나 실 use_dims는 [siz_cd] 단일축 고정 룩업(전사표 검증).
- ★자재 재키잉(pack §3.5·T-2 "레더 .08→.06 주의"의 아크릴 사례): 구 골드/실버(.08 실사소재)가 은퇴하고
  아크릴(골드/실버) .20으로 교체됐다. 현행 .20이 현재값이자 정합이라 **양면 defect 아님**(권위 목표 라벨 충돌
  없음). 은퇴 자재는 노드화하지 않고 전사표 이력으로만 보존(del표기).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5·§5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 아크릴 완제품 통가격 산정 근거는 엑셀 미기재 암묵지 GAP([[product-143-mirror-acrylic-sticker-nodes#gap-143-fixedprice-basis]]).
