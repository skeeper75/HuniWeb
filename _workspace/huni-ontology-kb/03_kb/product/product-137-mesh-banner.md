---
id: product-137-mesh-banner
type: product
anchor: t_prd_products/PRD_000137
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000137(prd_nm=메쉬배너·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 고정가형 15상품 중 메쉬배너137(B29)·§3.1·§3.8(비종이류 판형없음)·§3.12(부속붙는 8상품 137→우드거치대012)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_MESH_BANNER use_dims=[siz_cd,min_qty](고정가 규격×수량구간 룩업·면적매트릭스 아님)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000315, note: "배너/현수막(cat_lvl=2·부모 CAT_000005 사인·main_cat_yn(링크)=N·신규노드 06-19·136 PET배너 canonical 재사용)"}
  - {rel: has_size, target: size-SIZ_000321, note: "600x1800mm 이산 단일 규격(dflt_yn=Y·del_yn=N·impos_yn=N·136 PET배너 canonical 재사용)"}
  - {rel: uses_material, target: material-MAT_000183, note: "메쉬(USAGE.07·dflt_yn=Y·★MAT_TYPE.08 미교정·128 canonical 재사용)"}
  - {rel: has_process, target: process-PROC_000079, note: "타공(4구 아일렛·mand_proc_yn=N·구수 param min1/max8·axis/processes 재사용)"}
  - {rel: has_qty_rule, target: qty-137, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: has_option_group, target: optgroup-137-holepunch, note: "가공(4구타공 필수·택1·mand Y)→PROC_000079"}
  - {rel: has_option_group, target: optgroup-137-standoff, note: "추가(배너거치대·택1·mand N)·★template BLOCKED(거치대없음만·부속 미연결)"}
  - {rel: priced_by, target: formula-PRF_POSTER_MESH_BANNER, note: "완제품가 고정가 룩업형(규격×수량구간 셀단가·면적매트릭스 아님)"}
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
  archetype: "고정가 룩업형(fixed·use_dims=[siz_cd,min_qty]·규격×수량구간 셀단가·면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(배너/Banner·LayoutIntent FinishedDimensions·타공 후가공)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(메쉬배너 가격 경로)", "조건 탐색(배너 소재·규격·타공)"]
tags: ["#실사", "#배너", "#메쉬배너", "#고정가룩업", "#비종이류", "#부속붙는상품"]
updated: 2026-07-03
---

# product-137 메쉬배너 (PRD_000137)

메쉬배너는 **실사(대형 실사 출력물·사인 배너류)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(600×1800mm)** 을 고르고 **수량**을 정하면, `(사이즈 siz_cd × 수량구간 min_qty)`
**고정가 룩업**에서 **완제품 통가격**(출력+코팅+가공(4구 아일렛 타공) 포함가)을 조회한다. 파일 업로드
방식(`file_upload_yn=Y`, 에디터 미사용·`nonspec_yn=N`이라 비규격 자유치수 없음). 그물망 **메쉬 소재**
대형 롤 출력이라 비종이류(판형 없음). 수치는 [[product-137-mesh-banner-nodes]] 전사표가 권위(스크립트
전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 메쉬배너는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안). 부속(배너거치대)을 얹는 "단품+부속" 정체이나
  현재 라이브는 addon/set 0행이라 물리 부속 미연결(pack §3.12·아래 GAP).
- 상품군 = **실사**(카테고리 005 사인 하위 315 배너/현수막). 사인 배너류 완제품 — 굿즈/포장재 아님.
- 카테고리: 배너/현수막 `CAT_000315`(leaf·lvl2·부모 CAT_000005 사인·main_cat_yn(링크)=N). 137은
  junction 1행(CAT_000315)만 연결·부모 CAT_000005는 카테고리 계층(upr_cat_cd)이지 상품 junction 링크
  아님. ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은
  `del_yn=Y` 논리삭제(06-18)됐고 137은 신규 카테고리 노드 CAT_000315(06-19)로 재연결됨(pack §1.1·§4
  T-1). 현재 상태=정상연결(defect 아님·양면 불요). CAT_000315는 신규노드라 leaf 귀속 정밀도만 확인 대상.

## 차원
- **사이즈:** 이산 **단일 규격 1행**(600×1800mm `SIZ_000321`·dflt_yn=Y·del_yn=N·impos_yn=N·tags["배너"]).
  `nonspec_yn=N`이라 **비규격 연속범위가 없다**(118/126의 사용자입력 치수 UX와 차이·pack §3.2 부수). 배너
  단일 규격만 등록(면적매트릭스 상품처럼 여러 이산 규격+nonspec 범위를 갖지 않음).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 137 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  137 행 **없음**(제품 레벨 규칙만). ★130 포맥스보드와 달리 137 구성요소 use_dims에는 **수량구간
  min_qty 축이 있다**(규격×수량구간 블록) — 다만 라이브 격자는 min_qty=1 단일 tier라 사실상 수량무관
  flat 가격(수량구간 할인 없음·t_dsc_* 0행). 수량 UI 권위=제품 수량규칙(가격 구간과 역할 분리·
  pack §3.4·[[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정
- **자재:** **메쉬 단일 소재계열**(낱장 완제품·내지/표지 없음·pack §3.5) — 부모 `MAT_000183`(메쉬·
  upr_mat_cd 공백·USAGE.07·dflt_yn=Y). ★자재유형이 현재 **`MAT_TYPE.08 실사소재`(미교정 잔존)** —
  형제 레더 `MAT_000186`은 06-27 `.05`로 교정됐으나 메쉬는 잔존(pack §1.1·§3.5 그래픽천/현수막천/메쉬
  3소재 미교정). DB note의 "→원단(.05)" 목표 라벨은 MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재)으로
  **STALE**(pack T-2). "현재값 .08 확정·정정 목표유형 미확정"이라 양면(defect)이 아니라 GAP으로 정직 선언 —
  이 material-MAT_000183 노드와 그 GAP은 **128 메쉬프린트가 canonical 정의**([[product-128-mesh-print-nodes#material-MAT_000183]]·
  [[product-128-mesh-print-nodes#gap-128-mesh-mattype-correction]])이므로 137은 재사용만(재정의 안 함·L-3).
  ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** **타공 `PROC_000079`**(4구 아일렛·상위공정 없음·mand_proc_yn=N·del_yn=N·prcs_dtl_opt "구수"
  min1/max8·axis/processes.md canonical 재사용·[[axis/processes#process-PROC_000079]]). 메쉬배너는 걸이용
  4구 아일렛 타공이 붙는다. ★단 구수(구멍 개수) param이 옵션 아이템에 미지정 → GAP(아래
  [[product-137-mesh-banner-nodes#gap-137-holepunch-param]]·pack §3.6 GAP-SL-2). 실사 대형 잉크젯 인쇄방식
  공정(PROC_000006)은 라이브에 137 행이 없다(실사 공통·po=0·정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 137에 1행(SIZ_000321) 있으나 `output_paper_typ_cd`가 **공백**이고
  용도가 "파일사양"(output_file_typ=JPG)이며 **`del_yn=Y`(2026-06-30 정리)** — 판걸이수 산정용 출력용지
  판형이 아니라 삭제된 파일 규격 플레이스홀더다. ★실사 배너는 **비종이류**(그물망 메쉬 대형 롤)라 절수
  기반 전지 규격이 무의미(낱장 임포지션 없음·impos_yn=N) → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·
  t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·
  [[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·130/131 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-137 --priced_by--> formula-PRF_POSTER_MESH_BANNER --has_component--> component-COMP_POSTER_MESH_BANNER`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components·pack §27 배선 정합).
- **고정가 룩업형** = 면적매트릭스형(118/122/126·128 메쉬프린트 포스터·가로×세로)·원자합산형(디지털 인쇄+용지+공정 합산)과
  **다른 아키타입**. ★같은 메쉬 소재라도 **128 메쉬프린트는 면적매트릭스**(use_dims=[siz_width,siz_height,min_qty]·
  동형결합 COMP_POSTER_CANVAS_FABRIC)인 반면 **137 메쉬배너는 고정가 규격×수량구간 룩업**(use_dims=[siz_cd,min_qty])이다 —
  소재는 같아도 상품 정체(포스터 vs 배너)와 가격모델이 다름(적대적 주의: "메쉬=면적매트릭스" 일괄 금지). 단일 구성요소
  `COMP_POSTER_MESH_BANNER`를 use_dims 2축(**사이즈 siz_cd × 수량구간 min_qty**)으로 조회한다. 격자=**유효 1셀**
  (규격1 × 수량구간1)이 이 빠짐 없이 충전(전사표 cells_present=combos_potential·격자완전).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527 verbatim(comp note)이며 계산은 엔진 권위.

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 137 행 **2**(★130/131 포맥스보드/우드액자와 차이·실사 CPQ
  실재 사례). ① **가공**(`OPT_000020`·SEL_TYPE.01·min/max_sel 1/1·mand_yn=Y)=4구타공 필수(택1) →
  option_item이 공정 `PROC_000079`를 가리킴(R11 option_refs·OPT_REF_DIM.04·[[product-137-mesh-banner-nodes#optgroup-137-holepunch]]).
  ② **추가**(`OPT_000021`·SEL_TYPE.01·min/max_sel 0/1·mand_yn=N)=배너거치대 추가(택1) — ★현재
  "거치대없음"(OPV_000041) 단일 옵션만 있고 option_item이 없어 **배너거치대 template BLOCKED**
  ([[product-137-mesh-banner-nodes#optgroup-137-standoff]]·부속 우드거치대 미연결).
- **제약규칙:** `t_prd_product_constraints` = 137 행 **0**. 137은 pack §1.1의 constraints 신규 발현
  7상품(118/120/121/122/124/125/139)에 **포함되지 않는다** — 0행이 현재값(nonspec_yn=N이라 사용자입력
  치수 범위 제약 자체가 불필요·defect 아님·양면 불요). ★인접 139 메쉬현수막은 constraints 1행이나 137
  메쉬배너는 별개 상품(0행·혼동 금지).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 137 행 **없음**(★부속붙는 8상품인데도 0행).
  pack §3.12에 따르면 137 메쉬배너는 **우드거치대 `PRD_000012`** 재연결 대상이나 라이브 addon=0·set=0
  잔존(SL-DEF-005 미교정)·옵션그룹 OPT_000021도 template BLOCKED로 물리 부속 미연결(아래
  [[product-137-mesh-banner-nodes#gap-137-standoff-addon-blocked]]). 부속 PRD_000012 실재(search-before-mint
  충족·재연결만·신규 mint 금지).

## 승계·freshness 메모
- 정체·소재계열·고정가형 분기는 pack §3.1·§3.8·§3.10(FRESH·INHERIT) 승계·재검증. 137=고정가 15상품(B29).
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 137은 정상 카테고리 연결(배너/현수막 CAT_000315). 부속 addon/set(SL-DEF-005)는 **여전히 0행
  잔존**(미교정·재연결 대기·GAP으로 정직 선언). 메쉬 자재유형 .08 미교정(SL-DEF-002 부분해소 잔존)은
  128이 canonical GAP으로 선언(양면 아님). round-13/위키를 그대로 옮기면 오염이라 live-snapshot
  20260702_1119 실측으로 재판정(현재값=정답).
- ★면적매트릭스 오모델 회피(T-4·T-5): 137은 **면적매트릭스가 아니라 고정가 규격×수량구간 룩업**
  (use_dims=[siz_cd,min_qty])임을 라이브 실측으로 확정 — 공식 frm_nm이 "(면적/규격 단가)"로 명명됐으나
  실 use_dims는 [siz_cd,min_qty] 고정 룩업(전사표 검증). "29 실사 전부 면적매트릭스로 일괄"(round-2
  오모델·pack §3.10 적대적 주의) + "메쉬=면적매트릭스"(128 오전이) 둘 다에 넘어가지 않음.
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5·§5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 배너 완제품 통가격 산정 근거는 엑셀 미기재 암묵지 GAP
  ([[product-137-mesh-banner-nodes#gap-137-fixedprice-basis]]).
