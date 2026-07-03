---
id: product-136-pet-banner
type: product
anchor: t_prd_products/PRD_000136
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000136(prd_nm=PET배너·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·file_upload_yn=Y·editor_yn=N·min1/max10000/incr1·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1·§5 PET배너=고정가형 15상품([수량×규격] 블록·포스터사인 B12~B25/B28~B31)·면적매트릭스 13상품 아님(BLOCKED-OUT-OF-SCOPE 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10·§3.12·§0 실사 정체·고정가형(수량×규격)·부속붙는 8상품(PET배너136→거치대)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000315, note: "배너/현수막(cat_lvl=2·upr=CAT_000005 사인·main_cat_yn=N·136 companion mint)"}
  - {rel: has_size, target: size-SIZ_000321, note: "600x1800mm 단일 규격(del_yn=N·고정가 셀 실재)"}
  - {rel: uses_material, target: material-MAT_000601, note: "PET(본체·부모 MAT_000178·dflt_yn=Y·07-01 재키잉 신설)"}
  - {rel: uses_material, target: material-MAT_000409, note: "실내용거치대(거치대 옵션 자재·MAT_TYPE.16 실사부자재)"}
  - {rel: uses_material, target: material-MAT_000410, note: "실외용거치대(거치대 옵션 자재·MAT_TYPE.16 실사부자재)"}
  - {rel: has_process, target: process-PROC_000115, note: "유광코팅(선택·통가격 baked·118-nodes 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000116, note: "무광코팅(선택·통가격 baked·118-nodes 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000135, note: "실사가공(4구타공 대체·129-nodes 정의 재사용·구수 param 손실 GAP)"}
  - {rel: has_qty_rule, target: qty-136, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_PET_BANNER, note: "완제품가 고정가형(본체 siz_cd 룩업) + 거치대 가산(mat_cd)"}
  - {rel: has_option_group, target: optgroup-136-coating, note: "코팅 택0~1(없음/무광/유광)"}
  - {rel: has_option_group, target: optgroup-136-gagong, note: "가공 택1 필수(4구타공→실사가공)"}
  - {rel: has_option_group, target: optgroup-136-stand, note: "거치대 필수(없음/실내용/실외용→가산가격)"}
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
  archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd,min_qty]) + 거치대 가산(mat_cd) — 실사 2 가격모델 중 고정가(면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(배너/Banner·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(PET배너 가격 경로)", "조건 탐색(배너 규격·수량·거치대)"]
tags: ["#실사", "#배너", "#PET배너", "#고정가형", "#비종이류"]
updated: 2026-07-03
---

# product-136 PET배너 (PRD_000136)

PET배너는 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(600×1800mm 단일)·수량**과 **코팅·거치대**를 고르면, 포스터사인
**고정가 [규격(siz_cd)×수량]** 단가표에서 **본체 완제품 통가격**(출력+코팅+가공(4구아일렛) 포함가)을
조회하고, **거치대(실내/실외)** 선택 시 자재별(`mat_cd`) 가산가격을 더한다. ★118 아트프린트포스터가
**면적매트릭스형**([가로×세로] 셀단가)인 것과 달리, 136은 실사 2 가격모델 중 **고정가형**(등록 규격
룩업·use_dims=`[siz_cd,min_qty]`)이며 **거치대 가산 구성요소**(use_dims=`[mat_cd]`)가 하나 더 붙는다
(pack §3.10 "고정가 15상품"). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용). 수치(규격·고정가/가산
SHAPE·옵션)는 [[product-136-pet-banner-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. PET배너는 `t_prd_product_sets` 부모 등록이
  없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 005 사인 하위 배너/현수막). 굿즈/포장재 아님(정체 오분류 위험 없음).
- 카테고리: **배너/현수막 `CAT_000315`**(cat_lvl 2·상위 `CAT_000005` 사인·main_cat_yn=N·06-19 신규노드·
  [[product-136-pet-banner-nodes]]). ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는
  **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 136은 정상 배너/현수막 노드로 재연결됨
  (pack §1.1·§4 T-1). 현재 상태=정상연결(defect 아님·양면 불요·단 314/315 신규노드 leaf 정밀도만 확인 대상).

## 차원
- **사이즈:** 등록 규격 **1행**(600×1800mm `SIZ_000321`·master del_yn=N·junction del_yn=N). ★**nonspec_yn=N** —
  118·125 등 면적매트릭스 형제와 달리 136은 **사용자입력 치수가 없다**(등록 규격 1종만 선택). 그래서 nonspec
  연속범위·치수 입력 UX가 없고, 규격 1행이 고정가 본체 단가표의 1 셀(600×1800)과 정확히 일치(전사표 규격=가격셀
  정합=True).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 136 행 **없음**. 실사는 **대형 잉크젯 풀컬러**라
  도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  136 행 **없음**(제품 레벨 규칙만). ★고정가형 본체 단가표의 수량축은 **1 밴드(min_qty=1)만 충전**(전사표
  수량축충전=False) — 규격당 단일 통가격이며 수량구간 할인 없음. 총액=규격 통가격×수량(+거치대 가산). 수량 UI
  권위=제품 수량규칙(가격구간과 역할 분리·pack §3.4). ★max_qty=10000(형제 실사 1000과 다름·배너 대량 주문 허용).

## 자재·공정
- **자재:** **본체 PET 단일 소재 + 거치대 부자재 2종**(낱장 완제품·내지/표지 없음·pack §3.5). 본체 =
  `MAT_000601` PET(부모 `MAT_000178`의 자식·07-01 재키잉 신설·`MAT_TYPE.08 실사소재`·dflt_yn=Y·USAGE.07).
  거치대 = `MAT_000409` 실내용거치대 / `MAT_000410` 실외용거치대(둘 다 `MAT_TYPE.16 실사부자재`·부모
  `MAT_000227 배너거치대`·거치대 옵션값 참조대상). ★**07-01 재키잉으로 구 자재가 승계삭제**: 구 PET 부모
  `MAT_000178`(상품 junction del_yn=Y·자식 601로 대체)·`MAT_000223 우드거치대`(마스터+junction del_yn=Y·
  실내/실외 거치대로 대체) → **노드 미생성**(환각 차단). ★IMPORT 등록 자재 삭제 금지 원칙과 별개로, 여기 삭제는
  라이브 재키잉 승계삭제다([[rule/rules#RULE_import_material_no_delete]] 적용 대상 아님).
- **공정:** 코팅 2종(유광 `PROC_000115` / 무광 `PROC_000116`·둘 다 상위 PROC_000114 쿨코팅·junction del_yn=N·
  mand=N) + 실사가공 `PROC_000135`(상위 PROC_000083 가공·junction del_yn=N). ★**07-01 재키잉**: 구 라미네이팅
  (유광 PROC_000014·무광 PROC_000015·상위 013)이 상품에서 `del_yn=Y` 논리삭제되고 코팅으로, 구 타공
  `PROC_000079`(구수 param 보유)이 실사가공 `PROC_000135`(generic·param 없음)으로 교체됨(전사표). 코팅·4구타공은
  **본체 고정가 통가격에 포함**(component note "출력+코팅+가공(4구아일렛) 포함가"·pack §3.10)이라 별도 원자합산이
  아니다. 실사 대형 잉크젯 인쇄방식 공정(PROC_000006)은 라이브에 136 행이 없다(실사 공통·po=0·설계상 정당·pack §3.7).
  ★코팅 공정 115/116은 상품에 붙어(통가격 baked) 있으나 **코팅 옵션그룹의 참조가 삭제된 라미(014/015)를 가리키는
  재키잉 불일치**가 있다([[product-136-pet-banner-nodes#gap-136-coating-optref-stale]]).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 136에 1행(SIZ_000321) 있으나 `output_paper_typ_cd`가 **공란**이고
  용도가 "파일사양"(output_file_typ=JPG)이다 — 판걸이수 산정용 출력용지 판형이 아니라 **파일 규격
  플레이스홀더**다. ★실사는 **대형 롤 출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형
  (`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**
  (pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서
  `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·118/131 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-136 --priced_by--> formula-PRF_POSTER_PET_BANNER --has_component--> {COMP_POSTER_PET_BANNER(본체),
  COMP_POSTEROPT_PET_BANNER_STAND_SEL(거치대 가산)}`. **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이
  구성요소 2건을 배선한다(formula_components 실측 2행·전사표).
- ★**고정가형(fixed-price·siz_cd 룩업) + 가산(mat_cd)** = 원자합산형(디지털)·면적매트릭스형(118 가로×세로)·
  고정룩업형(스티커 siz_cd)과 대비되는 아키타입. 본체 구성요소 `COMP_POSTER_PET_BANNER`를 use_dims 2축(**규격
  siz_cd × 수량 min_qty**)으로 조회하고(단가표=규격 1셀×수량 1밴드=1행 완전격자·grid_full=True), 거치대 구성요소
  `COMP_POSTEROPT_PET_BANNER_STAND_SEL`을 use_dims 1축(**자재 mat_cd**)으로 조회한다(실내용409·실외용410 = 2셀).
  면적(가로×세로) 셀이 아니라 **등록 규격/자재 키** 룩업이라 off-grid ceiling·비대칭 개념이 없다(nonspec_yn=N).
- ★거치대 가산 사슬 = `optgroup-136-stand`(거치대 옵션) → `uses_material MAT_000409/410` → 본체 공식의
  `COMP_POSTEROPT_PET_BANNER_STAND_SEL`(mat_cd 키)에서 자재별 가산가 조회. 옵션 선택이 자재 차원으로 환원되어
  가산 구성요소를 구동하는 **깨끗한 CPQ→가격 배선**이다.
- ★공식/구성요소는 **136 전용 신규**(실사 고정가+가산 첫 노드) — [[product-136-pet-banner-nodes]]에 mint. 실사
  고정가 15상품(129/130/131/…·pack §3.10) 및 거치대 가산 형제(137 메쉬배너)의 공유 축 승격 후보(→ needed_shared).
- ★**orphan 거치대 구성요소 3건**(STAND_IN·STAND_OUT_S1·STAND_OUT_S2)이 공식 미배선(공식은 STAND_SEL만
  배선)으로 잔존하며, 그 중 실내용 orphan이 배선된 STAND_SEL 실내값과 **불일치 CONFIRM**·실외 양면용 orphan은
  mat_cd 키 붕괴로 미포착이다([[product-136-pet-banner-nodes#gap-136-stand-orphan-components]]).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹 3(활성):** 코팅(`OPT_000017`·SEL_TYPE.01·min0/max1·mand=N — 없음/무광/유광) + 가공(`OPT_000018`·
  min1/max1·mand=Y — 4구타공→실사가공) + 거치대(`OPT-000009`·mand=Y — 없음/실내용/실외용). 코팅 item은 공정을,
  가공 item은 공정(PROC_000135)을, 거치대 item은 자재(MAT_000409/410)를 가리켜 선택이 has_process·uses_material
  차원으로 환원된다(R11 option_refs·L-18 부모정합). ★**추가 옵션그룹 `OPT_000019`(배너거치대 추가·template·
  BLOCKED)는 `del_yn=Y` 논리삭제** — 구 template 기반 거치대 addon 방식이 거치대 옵션그룹(009)+가산 구성요소로
  대체됨(노드 미생성). 상세=[[product-136-pet-banner-nodes]].
- **제약규칙:** `t_prd_product_constraints` = 136에 **0행**. ★118·125 등 면적매트릭스 형제는 nonspec 치수범위
  제약(RULE_001) 1행을 갖지만, 136은 **nonspec_yn=N**(사용자입력 치수 없음)이라 검증할 범위가 없어 제약 0행이
  **정당**하다(defect 아님). pack §1.1의 constraints 신규 발현 7상품(118/120/121/122/124/125/139)에 136이
  **포함되지 않는 것**과 정합(nonspec 상품만 범위 제약 보유). 131 동형.
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 136 행 **없음**. ★pack §3.12는 "PET배너136→
  우드거치대012 addon 재연결 대기"로 기록하나, 라이브는 **거치대를 CPQ 옵션그룹(009)+거치대 가산 구성요소로
  이미 표현**하고 우드거치대 자재(MAT_000223)는 승계삭제됨 — 즉 addon 0행이 결함이 아니라 **다른 메커니즘으로
  해소**된 상태다(pack §3.12 기대와 델타). 이 귀속 판정은 [[product-136-pet-banner-nodes#gap-136-stand-attribution]]로
  정직 선언(단정 금지·GAP-SL-4 계열).

## 승계·freshness 메모
- 정체·고정가형 분기(면적매트릭스 아님)는 pack §3.10·§5.2(FRESH·INHERIT) + mapping.md §1.1·§5 승계·재검증.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미 해소** —
  136은 정상 배너/현수막 연결. constraints는 136이 nonspec_yn=N이라 애초에 해당 없음(0행 정당). 부속 addon
  (SL-DEF-005)은 **CPQ 옵션+가산으로 해소**(pack §3.12 addon 기대와 델타·GAP 정직 선언). round-13/위키를 그대로
  옮기면 오염이라 live-snapshot 20260702_1119 실측으로 재판정.
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5)·"29 실사 전부 면적매트릭스 일괄"(T-5)은 인용 안 함 — 136은 명시
  고정가 1셀 완전격자 + 거치대 2셀 가산(전사표)만 승계(mapping.md §5 고정가 분류·BLOCKED-OUT-OF-SCOPE 존중).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 잔존 GAP = 코팅 옵션 참조 재키잉 불일치·4구타공 구수 param 손실·거치대 귀속·orphan
  거치대 구성요소 CONFIRM·롤 소재 가격 산정 로직 암묵지([[product-136-pet-banner-nodes]] GAP 5).
