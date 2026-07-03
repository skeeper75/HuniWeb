---
id: product-130-formax-board
type: product
anchor: t_prd_products/PRD_000130
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000130(prd_nm=포맥스보드·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 고정가형 15상품 중 포맥스보드130(B14)·§3.1·§3.8(비종이류 판형없음)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_FOMEXBOARD_BOARD use_dims=[mat_cd,siz_cd](고정가 룩업·면적매트릭스 아님)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(cat_lvl=1 root·main_cat_yn=Y·disp_seq=13)"}
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(cat_lvl=2·upr=CAT_000004·main_cat_yn=N·130-nodes 첫 정의)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 규격(297x420·dflt_yn=Y·del_yn=N·047 정의 재사용)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 규격(420x594·dflt_yn=Y·del_yn=N·axis/sizes 정의 재사용)"}
  - {rel: uses_material, target: material-MAT_000022, note: "포맥스(화이트) 3mm A3(USAGE.07·MAT_TYPE.16)"}
  - {rel: uses_material, target: material-MAT_000023, note: "포맥스(화이트) 5mm A3(USAGE.07·MAT_TYPE.16)"}
  - {rel: uses_material, target: material-MAT_000554, note: "포맥스(화이트) 3mm A2(USAGE.07·MAT_TYPE.16)"}
  - {rel: uses_material, target: material-MAT_000555, note: "포맥스(화이트) 5mm A2(USAGE.07·MAT_TYPE.16)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(선택·mand N·axis/processes 재사용)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(선택·mand N·axis/processes 재사용)"}
  - {rel: has_qty_rule, target: qty-130, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_FOMEXBOARD, note: "완제품가 고정가 룩업형(두께×사이즈 셀단가·수량축 없음)"}
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
  archetype: "고정가 룩업형(fixed·use_dims=[mat_cd,siz_cd]·두께×사이즈 셀단가·수량축 없음)"
standards: {schema_org: Product, xjdf: "Product(보드/Board·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(포맥스보드 가격 경로)", "조건 탐색(보드 소재·두께·규격)"]
tags: ["#실사", "#보드", "#포맥스보드", "#고정가룩업", "#비종이류"]
updated: 2026-07-03
---

# product-130 포맥스보드 (PRD_000130)

포맥스보드는 **실사(대형 실사 출력물·보드류)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(A3/A2)** 과 **두께(3mm/5mm)** 를 고르면, `(자재 mat_cd × 사이즈 siz_cd)`
**고정가 룩업**에서 **완제품 통가격**(소재+출력+가공 포함·라미네이팅 통가격 포함)을 조회한다. 파일 업로드
방식(`file_upload_yn=Y`, 에디터 미사용·`nonspec_yn=N`이라 비규격 자유치수 없음). 수치는
[[product-130-formax-board-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 포맥스보드는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 004 포스터 하위 080 보드액자). 보드류 완제품 — 굿즈/포장재 아님.
- 카테고리: 포스터 `CAT_000004`(root·main_cat_yn=Y) + 보드액자 `CAT_000080`(leaf·lvl2·upr=CAT_000004).
  ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은
  `del_yn=Y` 논리삭제(06-18)됐고 130은 정상 카테고리 노드로 재연결됨(pack §1.1·§4 T-1). 현재
  상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 이산 규격 **2행**(A3 `SIZ_000174` / A2 `SIZ_000197`·전부 dflt_yn=Y·del_yn=N). ★118과
  달리 130은 A3/A2가 재키잉되지 **않았다** — 구 코드 SIZ_000174/197를 그대로 활성으로 쓴다(전사표).
  `nonspec_yn=N`이라 **비규격 연속범위가 아예 없다**(118/126의 사용자입력 치수 UX와 차이·pack §3.2 부수).
  A1 규격 없음(폼보드류는 A3/A2 2규격만).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 130 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  130 행 **없음**(제품 레벨 규칙만). ★고정가 룩업형이라 **수량축이 가격 차원이 아니다** —
  구성요소 use_dims=[mat_cd,siz_cd]에 수량축이 없고 4셀 전부 min_qty NULL(수량무관 통가격). 셀단가는
  보드 1장가이며 총액=셀단가×수량(수량구간 할인 없음·t_dsc_* 0행). 수량 UI 권위=제품 수량규칙(가격
  구간과 역할 분리·pack §3.4).

## 자재·공정
- **자재:** **포맥스(화이트) 보드 4종**(낱장 완제품·내지/표지 없음·pack §3.5) — 부모 `MAT_000021`(포맥스)
  아래 자식 4종이 **두께(3mm/5mm) × 사이즈(A3/A2)를 자재코드에 내장**한다: `MAT_000022`(3mm A3)·
  `MAT_000023`(5mm A3)·`MAT_000554`(3mm A2)·`MAT_000555`(5mm A2). 전부 `MAT_TYPE.16 실사부자재`·
  USAGE.07 단일 슬롯. ★130 자재는 **포맥스 보드(.16 정당)** 이며, 실사 팩이 경고한 **레더 `MAT_000186`
  .08→.05 교정 crosscut과 완전 무관**(pack §1.1·§3.5·T-2 — 레더는 100/126/296/298 횡단이고 130은
  보드다). 포맥스 .16 = 현재값이자 정답(양면 불요). ★IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라미네이팅 2종(유광 `PROC_000014` / 무광 `PROC_000015`·둘 다 상위 PROC_000013·mand_proc_yn=N·
  del_yn=N). ★118은 07-01에 라미(014/015)→코팅(115/116)으로 **재키잉**됐으나 130은 **구 라미 코드를
  그대로 유지**한다(전사표·실측 차이). ★단 130은 `t_prd_product_option_groups` **0행**이라 라미를 고르는
  CPQ 옵션 UI가 없다(공정 부착만) — 라미 선택/가산 여부가 불명(→[[product-130-formax-board-nodes#gap-130-lamination-no-optiongroup]]).
  가격은 (두께×사이즈) 완제품 통가격이라 라미네이팅이 통가격에 포함이라면 별도 가산 아님(comp note "가공 포함
  통가격"·pack §3.10). 실사 대형 잉크젯 인쇄방식 공정(PROC_000006)은 라이브에 130 행이 없다(실사 공통·po=0·정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 130에 2행(SIZ_000175/303) 있으나 `output_paper_typ_cd`가
  **전부 공란**이고 용도가 "파일사양"(output_file_typ=JPG)이며 **둘 다 `del_yn=Y`(2026-06-30 정리)** —
  판걸이수 산정용 출력용지 판형이 아니라 삭제된 파일 규격 플레이스홀더다. ★실사 보드는 **비종이류**라
  절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·
  t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·
  [[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·118 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-130 --priced_by--> formula-PRF_POSTER_FOMEXBOARD --has_component--> component-COMP_POSTER_FOMEXBOARD_BOARD`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components 07-02 배선·pack §27 배선 정합).
- **고정가 룩업형** = 면적매트릭스형(118/122/126 포스터·가로×세로)·원자합산형(디지털 인쇄+용지+공정 합산)과
  **다른 아키타입**. 단일 구성요소 `COMP_POSTER_FOMEXBOARD_BOARD`를 use_dims 2축(**자재 mat_cd × 사이즈
  siz_cd**)으로 조회한다. 격자=**유효 4셀**(두께2 × 사이즈2)이 이 빠짐 없이 충전(전사표 grid_full·수량축
  없음·min_qty NULL). 자재코드가 사이즈를 내장(3mm-A3/5mm-A3→SIZ_000174·3mm-A2/5mm-A2→SIZ_000197)이라
  (mat_cd,siz_cd) 4셀만 유효(잠재 8 중).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note)이며 계산은 엔진 권위.

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 130 행 **0**. 118(코팅/소재 옵션그룹 보유)과 달리 130은
  손님 선택 CPQ 축이 없다 — 두께/규격은 **자재(mat_cd) 선택 = uses_material 차원**으로 환원되나 옵션그룹
  UI가 없어 선택 경로가 불명(→[[product-130-formax-board-nodes#gap-130-cpq-option-layer]]·pack §3.9 GAP-SL-6 BATCH-6 대기).
- **제약규칙:** `t_prd_product_constraints` = 130 행 **0**. 130은 pack §1.1의 constraints 신규 발현
  7상품(118/120/121/122/124/125/139)에 **포함되지 않는다** — 0행이 현재값(nonspec_yn=N이라 사용자입력
  치수 범위 제약 자체가 불필요·defect 아님·양면 불요).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 130 행 **없음**. 130은 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·소재계열·고정가형 분기는 pack §3.1·§3.8·§3.10(FRESH·INHERIT) 승계·재검증. 130=고정가 15상품(B14).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 130은 정상 카테고리 연결(포스터+보드액자). constraints는 130이 신규 발현 7상품에 없어 0행이
  정당(SL-CPQ-003 재조준 결과 130=무관). round-13/위키를 그대로 옮기면 오염이라 live-snapshot
  20260702_1119 실측으로 재판정(현재값=정답).
- ★면적매트릭스 오모델 회피(T-4·T-5): 130은 **면적매트릭스가 아니라 고정가 룩업**(use_dims=[mat_cd,siz_cd])
  임을 라이브 실측으로 확정 — "29 실사 전부 면적매트릭스로 일괄"(round-2 오모델·pack §3.10 적대적 주의)에
  넘어가지 않음. 공식 frm_nm이 "(면적/규격 단가)"로 명명됐으나 실 use_dims는 [mat_cd,siz_cd] 고정 룩업(전사표 검증).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5·§5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 보드 완제품 통가격 산정 근거는 엑셀 미기재 암묵지 GAP([[product-130-formax-board-nodes#gap-130-fixedprice-basis]]).
