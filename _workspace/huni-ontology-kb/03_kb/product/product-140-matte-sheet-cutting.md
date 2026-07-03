---
id: product-140-matte-sheet-cutting
type: product
anchor: t_prd_products/PRD_000140
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000140(prd_nm=무광시트커팅·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 고정가형 15상품 중 무광시트커팅140·§3.1·§3.5(시트커팅지 .19)·§3.8(비종이류 판형없음)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_SHEETCUT_MATTE use_dims=[siz_cd](고정가 룩업·단일축·면적매트릭스 아님)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000092, note: "시트커팅/스티커(부모 CAT_000005 사인·lvl2·main_cat_yn=N·라이브 유일 카테고리 junction)"}
  - {rel: has_size, target: size-SIZ_000258, note: "A4(210x297) 이산 규격·가격키 siz_cd·활성(★134 canonical 재사용·중복 mint 없음·2026-07-01 재키잉 대상)"}
  - {rel: has_size, target: size-SIZ_000315, note: "A3(297x420) 이산 규격·가격키 siz_cd·활성(★118 canonical 재사용)"}
  - {rel: has_size, target: size-SIZ_000198, note: "A2(420x594) 이산 규격·가격키 siz_cd·활성(★118 canonical 재사용)"}
  - {rel: uses_material, target: material-MAT_000388, note: "시트커팅지(화이트)·MAT_TYPE.19 시트커팅지·상위 MAT_000189·USAGE.07 낱장 단일·색상 옵션 참조대상"}
  - {rel: uses_material, target: material-MAT_000389, note: "시트커팅지(블랙)·MAT_TYPE.19 시트커팅지·상위 MAT_000189·USAGE.07 낱장 단일·색상 옵션 참조대상"}
  - {rel: has_process, target: process-PROC_000125, qualifier: {mand: "Y"}, note: "시트커팅(상위 PROC_000121 커팅·필수공정 mand Y·06-29 신설)·통가격 baked"}
  - {rel: has_qty_rule, target: qty-140, note: "상품레벨 수량규칙(min1·max10000·incr1·QTY_UNIT.01)·bundle_qtys 0행·고정가라 수량축=가격 차원 아님"}
  - {rel: has_option_group, target: optgroup-140-color, note: "색상(화이트/블랙 택1·mand Y·자재 참조 OPT_REF_DIM.03→MAT_000388/389·가격 무관)"}
  - {rel: priced_by, target: formula-PRF_POSTER_SHEETCUT_MATTE, note: "★고정가 룩업형(use_dims=[siz_cd] 단일축·A4/A3/A2 셀단가 완제품 통가격·수량축 없음·색상 무관)"}
  - {rel: references, target: gap-140-fixedprice-basis, note: "완제품 통가격 산정 근거 엑셀 미기재 암묵지(실사 전체 공통·source-registry §9 GAP-2)"}
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
  archetype: "고정가 룩업형(fixed·use_dims=[siz_cd] 단일축·규격별 셀단가·수량축 없음·색상 비가격축)"
standards: {schema_org: Product, xjdf: "Product(시트커팅/Sheet-Cut·CuttingIntent·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(무광시트커팅 가격 경로)", "조건 탐색(시트커팅 규격·색상)"]
tags: ["#실사", "#시트커팅", "#무광시트커팅", "#고정가룩업", "#비종이류", "#CPQ색상옵션"]
updated: 2026-07-03
---

# product-140 무광시트커팅 (PRD_000140)

무광시트커팅은 **실사(대형 실사 출력물·시트커팅)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(A4/A3/A2)** 과 **색상(화이트/블랙)** 을 고르면, `(siz_cd)` **단일축 고정가 룩업**
에서 **완제품 통가격**(소재+출력+가공 포함·시트커팅 가공 포함)을 조회한다. ★130 포맥스보드가
`[mat_cd,siz_cd]` 2축인 것과 달리 140은 **use_dims=`[siz_cd]` 단일축**이라 **색상은 가격에 무관**(화이트/블랙
동가). 파일 업로드 방식(`file_upload_yn=Y`·에디터 미사용·`nonspec_yn=N`이라 비규격 자유치수 없음).
수치는 [[product-140-matte-sheet-cutting-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 무광시트커팅은 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 005 사인 하위 092 시트커팅/스티커). 시트커팅 완제품 — 굿즈/포장재 아님.
- 카테고리: 시트커팅/스티커 `CAT_000092`(leaf·lvl2·upr=CAT_000005 사인·main_cat_yn=N). 라이브
  junction은 **CAT_000092 단일**(130처럼 root까지 이중 링크하지 않음 — 닫힌세계 D-6에 따라 실재 junction만
  in_category). 부모 사인 CAT_000005는 CAT_000092 props에 기록(별도 노드 미생성·고아 회피).
  ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — CAT_000298은
  `del_yn=Y` 논리삭제(06-18)됐고 140은 정상 카테고리 노드로 재연결됨(pack §1.1·§4 T-1). 현재
  상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 이산 규격 **3행**(A4 `SIZ_000258` / A3 `SIZ_000315` / A2 `SIZ_000198`·전부 활성). ★2026-07-01
  **재키잉** — 구 A4/A3/A2(`SIZ_000172/174/197`)는 링크 `del_yn=Y`로 삭제되고 스티커·시트커팅 태그
  사이즈(258/315/198)로 교체됨(전사표 del 표기). `nonspec_yn=N`이라 **비규격 연속범위가 아예 없다**
  (면적매트릭스 118/126의 사용자입력 치수 UX와 차이·pack §3.2). 규격 3종이 곧 가격축(use_dims=[siz_cd]).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 140 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·§3.7·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖). ★"색상(화이트/블랙)"은 도수가 아니라 **소재 색상**
  (시트커팅지 화이트지 vs 블랙지)이며 CPQ 옵션그룹(색상)으로 자재를 참조한다(아래 옵션 절).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  140 행 **없음**(제품 레벨 규칙만). ★고정가 룩업형이라 **수량축이 가격 차원이 아니다** —
  구성요소 use_dims=[siz_cd]에 수량축이 없고 3셀 전부 min_qty NULL(수량무관 통가격). 셀단가는
  시트 1장가이며 총액=셀단가×수량(수량구간 할인 없음·t_dsc_* 0행). 수량 UI 권위=제품 수량규칙(가격
  구간과 역할 분리·pack §3.4).

## 자재·공정
- **자재:** **시트커팅지 2종**(낱장 완제품·내지/표지 없음·pack §3.5) — 부모 `MAT_000189`(시트커팅지)
  아래 자식 2종: `MAT_000388`(화이트)·`MAT_000389`(블랙). 전부 `MAT_TYPE.19 시트커팅지`(06-27 신설
  전용 유형)·USAGE.07 단일 슬롯. ★2026-07-01 재키잉: 구 자재 `MAT_000255`(화이트)·`MAT_000256`(블랙)은
  `MAT_TYPE.08 실사소재`였고 06-16 마스터 논리삭제(del_yn=Y)됐으며, 시트커팅지 전용 유형 `.19`의
  388/389로 교체됨(전사표). ★140 자재는 **시트커팅지(.19 전용소재)** 이며, 실사 팩이 경고한 **레더
  `MAT_000186` .08→.05 교정 crosscut과 완전 무관**(pack §1.1·§3.5·T-2 — 레더는 100/126/296/298
  횡단이고 140은 시트커팅지다). 시트커팅지 .19 = 현재값이자 정답(양면 불요). ★IMPORT 등록 자재
  삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** **시트커팅 `PROC_000125`**(상위 `PROC_000121` 커팅·`mand_proc_yn=Y`·06-29 신설·del_yn=N)
  단 1개 = **필수 공정**. ★130 포맥스보드(라미 2종·mand N·선택)와 달리 140은 시트커팅이 필수
  공정으로 통가격에 녹아 있다(comp note "소재+출력+가공 포함 통가격"). 손님 선택 대상이 아니라
  모든 주문에 강제 적용되므로 CPQ 옵션 불필요(선택형 라미의 130 gap-130-lamination과 다른 정합
  상태). 실사 대형 잉크젯 인쇄방식 공정(PROC_000006)은 라이브에 140 행이 없다(실사 공통·po=0·정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 140에 3행(SIZ_000050/052/198) 있으나 `output_paper_typ_cd`가
  **전부 공란**이고 용도가 "파일사양"(output_file_typ=AI)이며 **전부 `del_yn=Y`(2026-06-30 정리)** —
  판걸이수 산정용 출력용지 판형이 아니라 삭제된 파일 규격 플레이스홀더다. ★실사 시트커팅은 **비종이류**라
  절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·
  t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·
  [[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·118/130 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-140 --priced_by--> formula-PRF_POSTER_SHEETCUT_MATTE --has_component--> component-COMP_POSTER_SHEETCUT_MATTE`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components 06-17 배선·pack §27 배선 정합).
- **고정가 룩업형** = 면적매트릭스형(118/122/126 포스터·가로×세로)·원자합산형(디지털 인쇄+용지+공정 합산)과
  **다른 아키타입**. 단일 구성요소 `COMP_POSTER_SHEETCUT_MATTE`를 use_dims **1축**(**사이즈 siz_cd**)으로
  조회한다. ★130 포맥스보드가 [mat_cd,siz_cd] 2축인 것과 달리 140은 [siz_cd] **단일축** — 색상(화이트/블랙)이
  자재를 바꾸지만 가격은 규격만으로 결정된다(화이트/블랙 동가). 격자=**유효 3셀**(A4/A3/A2)이 상품 활성
  사이즈에 전부 도달(전사표 도달 3/3·수량축 없음·min_qty NULL). ★재키잉 잔여: 격자에는 구 규격
  siz_cd(172/174/197) 행도 3개 남아 있으나 상품이 더 이상 참조하지 않는다(2026-07-01 dedup rekey→258/315/198·
  기능 영향 없음·전사표 legacy siz).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note)이며 계산은 엔진 권위.

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 140 행 **1**(`OPT_000068` 색상·SEL_TYPE.01 단일·min1/max1·
  mand_yn=Y). ★130(옵션그룹 0행)과 달리 140은 **색상 선택 CPQ 옵션 레이어가 라이브에 실재**한다 —
  옵션값 화이트(`OPV_000448`·dflt)/블랙(`OPV_000449`)이 `OPT_REF_DIM.03`(자재)로 자재 `MAT_000388/389`를
  참조한다(ref_key1=mat_cd·ref_key2=USAGE.07·옵션=자재 참조 BUNDLE·pack §3.9·L-18 부모 uses_material 정합).
  ★pack §3.9는 "실사 옵션은 일반현수막138만"이라 서술했으나 140 색상 옵션이 라이브 CPQ 레이어 실례로
  발현(현재값 관찰·138 외 사례). 상세 [[optgroup-140-color]].
- **제약규칙:** `t_prd_product_constraints` = 140 행 **0**. 140은 pack §1.1의 constraints 신규 발현
  7상품(118/120/121/122/124/125/139)에 **포함되지 않는다** — 0행이 현재값(nonspec_yn=N이라 사용자입력
  치수 범위 제약 자체가 불필요·defect 아님·양면 불요·T-3 재조준 결과 140=무관).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 140 행 **없음**. 140은 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·소재계열(시트커팅지 .19)·고정가형 분기는 pack §3.1·§3.5·§3.8·§3.10(FRESH·INHERIT) 승계·재검증.
  140=고정가 15상품(무광시트커팅·pack §3.10 명시).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 140은 정상 카테고리 연결(시트커팅/스티커 CAT_000092). constraints는 140이 신규 발현 7상품에
  없어 0행이 정당(SL-CPQ-003 재조준 결과 140=무관). CPQ 옵션(SL-DEF-006)은 위키가 "138만"이라 했으나
  140 색상 옵션이 실재(현재값·확장). round-13/위키를 그대로 옮기면 오염이라 live-snapshot
  20260702_1119 실측으로 재판정(현재값=정답).
- ★면적매트릭스 오모델 회피(T-4·T-5): 140은 **면적매트릭스가 아니라 고정가 룩업**(use_dims=[siz_cd] 단일축)
  임을 라이브 실측으로 확정 — "29 실사 전부 면적매트릭스로 일괄"(round-2 오모델·pack §3.10 적대적 주의)에
  넘어가지 않음. 공식 frm_nm이 "(면적/규격 단가)"로 명명됐으나 실 use_dims는 [siz_cd] 고정 룩업(전사표 검증).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5·§5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 시트 완제품 통가격 산정 근거는 엑셀 미기재 암묵지 GAP([[product-140-matte-sheet-cutting-nodes#gap-140-fixedprice-basis]]).
