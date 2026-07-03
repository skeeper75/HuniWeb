---
id: product-131-frameless-wood-frame
type: product
anchor: t_prd_products/PRD_000131
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000131(prd_nm=프레임리스우드액자·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N·editor_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1·§5 프레임리스우드액자131=고정가형 15상품([수량×규격] 블록·B14 포스터사인)·면적매트릭스 13상품 아님", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10·§3.12·§0 실사 정체·고정가형(수량×규격)·액자 귀속 AMBIGUOUS(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(cat_lvl=2·upr=CAT_000004 포스터·main_cat_yn=N·131 유일 등록 분류)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 규격(297x420·del_yn=N·고정가 셀 실재)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 규격(420x594·del_yn=N·고정가 셀 실재)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(mand=N·CPQ 미노출·통가격 baked 추정)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(mand=N·CPQ 미노출·통가격 baked 추정)"}
  - {rel: has_qty_rule, target: qty-131, note: "제품레벨 min1/max1000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_FRAMELESS, note: "완제품가 고정가형(규격 siz_cd×수량 룩업·통가격)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd,min_qty]) — 실사 2 가격모델 중 고정가(면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(액자/Frame·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(프레임리스우드액자 가격 경로)", "조건 탐색(액자 규격·수량)"]
tags: ["#실사", "#액자", "#프레임리스우드액자", "#고정가형", "#비종이류"]
updated: 2026-07-03
---

# product-131 프레임리스우드액자 (PRD_000131)

프레임리스우드액자는 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(A3/A2)**과 **수량**을 고르면, 포스터사인 **고정가 [규격(siz_cd)×수량]** 단가표에서
**완제품 통가격**(출력+코팅+가공 포함가)을 조회한다. ★118 아트프린트포스터가 **면적매트릭스형**([가로×세로]
셀단가)인 것과 달리, 131은 실사 2 가격모델 중 **고정가형**(등록 규격 룩업·use_dims=`[siz_cd,min_qty]`)이다
(pack §3.10 "고정가 15상품"·B14 포스터사인). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용).
수치(규격·고정가 SHAPE)는 [[product-131-frameless-wood-frame-nodes]] 전사표가 권위(스크립트 전사·손전사
금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 프레임리스우드액자는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 004 포스터 하위 보드액자). 굿즈/포장재 아님.
- 카테고리: **보드액자 `CAT_000080`**(cat_lvl 2·상위 `CAT_000004` 포스터·main_cat_yn=N·131 유일 등록
  분류·[[product-131-frameless-wood-frame-nodes]]). ★[REVERIFY→해소] round-13 "실사 28상품 전부
  CAT_000298 고아"는 **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 131은 정상 보드액자
  노드로 재연결됨(pack §1.1·§4 T-1). 현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 등록 규격 **2행**(A3 `SIZ_000174` / A2 `SIZ_000197`·둘 다 master·junction del_yn=N).
  ★**nonspec_yn=N** — 118·125 등 면적매트릭스 형제와 달리 131은 **사용자입력 치수가 없다**(등록 규격만
  선택). 그래서 nonspec 연속범위·치수 입력 UX가 없고, A1 규격도 미등록(A3/A2 2종만). 규격 2행이 고정가
  단가표의 2 셀(A3·A2)과 정확히 일치(전사표 규격=가격셀 정합=True).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 131 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max1000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  131 행 **없음**(제품 레벨 규칙만). ★고정가형 단가표의 수량축은 **1 밴드(min_qty=1)만 충전**(전사표
  수량축충전=False) — 규격당 단일 통가격이며 수량구간 할인 없음. 총액=규격 통가격×수량. 수량 UI 권위=제품
  수량규칙(가격구간과 역할 분리·pack §3.4).

## 자재·공정
- **자재:** ★`t_prd_product_materials` = 131 행 **0개**(전사표). 우드 프레임 본체 소재가 등록되지 않았고,
  완제품가가 **출력+코팅+가공 포함 통가격**(component note)이라 소재비가 통가격에 baked된 것으로 보인다.
  pack §3.5는 **보드/우드 5상품 소재 L1 빈값**(원본 미명시·정당·AMBIGUOUS)이라 기록한다 — 결함으로 단정
  하지 않고 [[product-131-frameless-wood-frame-nodes#gap-131-material-absent]]로 정직 선언(우드 프레임을
  자재로 등록할지, 통가격에 baked로 둘지 미결).
- **공정:** 라미네이팅 2종(유광 `PROC_000014` / 무광 `PROC_000015`·둘 다 상위 PROC_000013·junction
  del_yn=N·mand_proc_yn=N). ★118은 07-01 재키잉으로 이 라미 공정을 코팅(PROC_000115/116)으로 교체했으나
  131은 **라미 공정을 그대로 보유**(마스터 활성). ★단, 이 라미 공정을 참조하는 **CPQ 옵션그룹이 없다**
  (option_groups 0행) — 손님이 코팅을 고르는 축이 아니라 상품에 붙은 채 통가격에 baked된 것으로 보인다
  (118은 코팅 옵션그룹 보유·131은 미보유). 이 "붙었으나 미노출" 상태의 의도는
  [[product-131-frameless-wood-frame-nodes#gap-131-lamination-no-option]]로 정직 선언. 실사 대형 잉크젯
  인쇄방식 공정(PROC_000006)은 라이브에 131 행이 없다(실사 공통·po=0·설계상 정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 131에 2행(SIZ_000175 303x426·SIZ_000303 426x600) 있으나
  `output_paper_typ_cd`가 **전부 공란**이고 용도가 "파일사양"(output_file_typ=JPG)이다 — 판걸이수 산정용
  출력용지 판형이 아니라 **파일 규격 플레이스홀더**다. ★실사는 **대형 롤/우드 출력**이라 절수 기반 전지
  규격이 무의미(낱장 임포지션 없음) → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는
  **종이류 전용 로직이므로 실사에 적용 금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·
  [[harness-domain-rules-12-260701]]). 그래서 `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·
  118 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-131 --priced_by--> formula-PRF_POSTER_FRAMELESS --has_component--> component-COMP_POSTER_FRAMELESS_WOOD`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components
  실측 1행·전사표).
- ★**고정가형(fixed-price·siz_cd 룩업)** = 원자합산형(디지털 인쇄+용지+공정 합산)·면적매트릭스형(포스터
  가로×세로 셀)·고정룩업형(스티커 siz_cd)과 대비되는 **실사 두 번째 아키타입**. 단일 구성요소
  `COMP_POSTER_FRAMELESS_WOOD`를 use_dims 2축(**규격 siz_cd × 수량 min_qty**)으로 조회한다. 단가표=**규격
  2셀(A3·A2) × 수량 1밴드 = 2행 완전격자**(grid_full=True·전사표). 면적(가로×세로) 셀이 아니라 **등록
  규격(siz_cd) 키** 룩업이라 off-grid ceiling·비대칭 개념이 없다(nonspec_yn=N).
- ★공식/구성요소는 **131 전용 신규**(실사 고정가형 첫 노드) — [[product-131-frameless-wood-frame-nodes]]에
  mint. 실사 고정가 15상품(129/130/131/132/… pack §3.10) 공유 축 승격 후보(→ needed_shared_nodes).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 131 행 **없음**(CPQ 옵션 0). 손님 선택축은 규격·수량뿐이며
  코팅/소재 선택 옵션이 없다(라미 공정은 붙었으나 옵션 미노출·위 공정 절). 실사 CPQ는 일반현수막138
  파일럿만 적재된 상태라(pack §1.1·§3.9) 131 옵션 0행은 실사 공통(BATCH-6 대기·설계상 해당 없음).
- **제약규칙:** `t_prd_product_constraints` = 131에 **0행**. ★118·125 등 면적매트릭스 형제는 nonspec
  치수범위 제약(RULE_001) 1행을 갖지만, 131은 **nonspec_yn=N**(사용자입력 치수 없음)이라 검증할 범위가
  없어 제약 0행이 **정당**하다(defect 아님). pack §1.1의 constraints 신규 발현 7상품(118/120/121/122/124/
  125/139)에 131이 **포함되지 않는 것**과 정합(nonspec 상품만 범위 제약 보유).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 131 행 **없음**. ★단 pack §3.12는
  **액자 131/132의 귀속을 AMBIGUOUS**로 남긴다 — 액자 완성이 **공정(액자가공)**인지 **부속(프레임 별매
  addon)**인지 미결(C-14). 우드 프레임 자재 미등록(위 자재 절)과 맞물린 미결이라
  [[product-131-frameless-wood-frame-nodes#gap-131-frame-attribution]]로 정직 선언(단정 금지·GAP-SL-4).

## 승계·freshness 메모
- 정체·고정가형 분기(면적매트릭스 아님)는 pack §3.10·§5.2(FRESH·INHERIT) + mapping.md §1.1 승계·재검증.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미
  해소** — 131은 정상 보드액자 연결. constraints는 131이 nonspec_yn=N이라 애초에 해당 없음(0행 정당). 부속
  addon(SL-DEF-005)·액자 귀속(SL-DEF-007)은 **잔존/미결**(GAP 선언). round-13/위키를 그대로 옮기면 오염
  이라 live-snapshot 20260702_1119 실측으로 재판정(현재값=정답 or GAP).
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5)·"29 실사 전부 면적매트릭스 일괄"(T-5)은 인용 안 함 — 131은
  명시 고정가 2셀 완전격자(전사표)만 승계(mapping.md §1.1 고정가 분류).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정·양면 노드 없음). 고정가 완제품가 산정 근거(우드액자 규격별 통가격이 어떤
  원가/규칙으로 도출됐나)는 엑셀 미기재 암묵지 GAP([[product-131-frameless-wood-frame-nodes#gap-131-price-basis]]).
