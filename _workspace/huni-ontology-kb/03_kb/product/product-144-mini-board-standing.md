---
id: product-144-mini-board-standing
type: product
anchor: t_prd_products/PRD_000144
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000144(prd_nm=미니보드스탠딩·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N·editor_yn=N·min_qty=1·max_qty=10000·qty_incr=1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1·§3.10·§5 고정가형 15상품([수량×규격] 블록·수량축 보유·포스터사인)·미니보드스탠딩144=면적매트릭스 13상품 아님(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10·§3.12·§0 실사 정체·고정가형(수량×규격)·부속(거치대) 귀속 AMBIGUOUS(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000005, note: "사인(cat_lvl=1·root·main_cat_yn=Y — 144 대표분류)"}
  - {rel: in_category, target: category-CAT_000097, note: "POP(cat_lvl=2·upr=CAT_000005 사인·main_cat_yn=N·leaf)"}
  - {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)·★공유 axis/sizes 양면 defect(master del_yn=Y·junction 활성)·144도 활성 참조+가격셀 5밴드 실재(defect 보강)"}
  - {rel: has_size, target: size-SIZ_000172, note: "A4(210x297)·047 owner 재사용·고정가 셀 실재"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)·047 owner 재사용·고정가 셀 실재"}
  - {rel: has_qty_rule, target: qty-144, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)·★가격 5밴드는 별개(가격구간)"}
  - {rel: priced_by, target: formula-PRF_POSTER_MINI_STANDBOARD, note: "완제품가 고정가형(규격 siz_cd×수량밴드 룩업·통가격[출력+코팅+가공(보드접착+거치대)])"}
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
  archetype: "고정가형(fixed-price·siz_cd×수량밴드 룩업·use_dims=[siz_cd,min_qty]) — ★131(수량 단일밴드)과 달리 수량축 5밴드 실충전([수량×규격] 블록). 실사 2 가격모델 중 고정가(면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(POP 스탠딩보드·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(미니보드스탠딩 가격 경로)", "조건 탐색(POP 규격·수량밴드)"]
tags: ["#실사", "#사인", "#POP", "#미니보드스탠딩", "#고정가형", "#비종이류"]
updated: 2026-07-03
---

# product-144 미니보드스탠딩 (PRD_000144)

미니보드스탠딩은 **실사(대형 실사 출력물)** — **사인/POP** 계열의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 출력물을 보드에 접착하고 **거치대**를 달아 세워 두는 매장/행사용 POP 스탠딩보드다. 손님이
**규격(A5/A4/A3)**과 **수량**을 고르면, 포스터사인 **고정가 [규격(siz_cd)×수량밴드]** 단가표에서 **완제품
통가격**(출력+코팅+가공(보드접착+거치대) 포함가)을 조회한다. ★131 프레임리스우드액자가 **고정가·수량
단일밴드**인 것과 달리, 144는 같은 고정가형이면서 **수량축을 5밴드로 실충전**한다(pack §3.10 "고정가 15상품
= [수량×규격] 블록·수량축 보유"). ★118 아트프린트포스터의 **면적매트릭스형**([가로×세로] 셀단가)과도 다른
아키타입(등록 규격 siz_cd 키·off-grid ceiling 없음·nonspec_yn=N). 파일 업로드 방식(`file_upload_yn=Y`,
에디터 미사용). 수치(규격·수량밴드·고정가 SHAPE)는 [[product-144-mini-board-standing-nodes]] 전사표가 권위
(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 미니보드스탠딩은 `t_prd_product_sets` 부모 등록이
  없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안). 거치대가 통가격에 baked라 부속(반제품 구성원)으로 분해되지
  않는다(부속 귀속 미결은 아래 추가상품 절·GAP).
- 상품군 = **실사**(카테고리 005 사인/POP). 굿즈/포장재 아님(product-master 권위0 일관 확정).
- 카테고리: **사인 `CAT_000005`**(root·cat_lvl 1·main_cat_yn=Y=144 대표분류) + **POP `CAT_000097`**
  (cat_lvl 2·상위 CAT_000005 사인·main_cat_yn=N·leaf). ★[REVERIFY→해소] round-13 "실사 28상품 전부
  CAT_000298 고아"는 **STALE** — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 144는 정상 사인/POP 노드로
  재연결됨(pack §1.1·§4 T-1). 현재 상태=정상연결(defect 아님·양면 불요). 사인(CAT_000005) root 직결은
  pack §1.1의 "일부가 root 직결(004/005)" 관찰과 정합.

## 차원
- **사이즈:** 등록 규격 **3행**(A5 `SIZ_000170` / A4 `SIZ_000172` / A3 `SIZ_000174`·junction del_yn=N).
  ★**nonspec_yn=N** — 118·125 등 면적매트릭스 형제와 달리 144는 **사용자입력 치수가 없다**(등록 규격만
  선택). nonspec 연속범위·치수 입력 UX가 없다. 규격 3행이 고정가 단가표의 규격 3셀(A5·A4·A3)과 정확히
  일치(전사표 규격=가격셀 정합=True).
  - ★**A5 `SIZ_000170` = 공유 axis/sizes 양면 defect 노드**(master del_yn=Y 06-17 논리삭제 · junction 활성).
    144도 이 마스터-삭제 규격을 **활성 참조**하며(junction del_yn=N) 고정가 단가표에 A5 5밴드가 실재해
    가격 산출 가능한 상태다 — 즉 052 스티커에 이어 **144가 SIZ_000170 defect의 또 다른 활성 참조자**다
    (양면 어느 쪽도 삭제 금지·정리 워크리스트·[[axis/sizes#size-SIZ_000170]]). 신규 노드 mint 안 함(공유
    노드 소유권=axis/sizes·재사용 참조만·L-3).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 144 행 **없음**(전사표 0행). 실사는 **대형
  잉크젯 풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  144 행 **없음**(제품 레벨 규칙만). ★131과 달리 고정가 단가표의 **수량축이 5밴드로 실충전**(전사표
  수량축충전=True·밴드 하한 4/19/49/99/10000 — 코드값만 전사·단가 미전사·수량구간 할인 있음). ★단
  가격 밴드 하한(4) ≠ 상품 min_qty(1)라 수량 1~3 구간의 가격 밴드가 명시 부재 — 수량 UI 권위(상품레벨
  min1)와 가격구간(밴드 하한 4)의 역할 분리(pack §3.4)이자 폴백 거동 미확증이라
  [[product-144-mini-board-standing-nodes#gap-144-qty-band-floor]]로 정직 선언(단정 금지).

## 자재·공정
- **자재:** ★`t_prd_product_materials` = 144 행 **0개**(전사표). 보드/출력물 소재가 등록되지 않았고,
  완제품가 note가 **"출력+코팅+가공(보드접착+거치대) 포함 통가격"**이라 소재비가 통가격에 baked된 것으로
  보인다. pack §3.5는 **보드/우드 5상품 소재 L1 빈값**(원본 미명시·정당·AMBIGUOUS)이라 기록한다 — 결함으로
  단정하지 않고 [[product-144-mini-board-standing-nodes#gap-144-material-absent]]로 정직 선언(자재 날조 금지).
- **공정:** ★`t_prd_product_processes` = 144 행 **0개**(전사표). 보드접착·거치대 조립 등 가공이 통가격에
  baked라 별도 공정(supr proc)이 상품에 붙지 않았다(131은 라미 공정 2종을 붙여둔 것과 대비 — 144는 가공도
  통가격에 흡수). 실사 대형 잉크젯 인쇄방식 공정(PROC_000006)도 144 행이 없다(실사 공통·po=0·설계상 정당·
  pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 144에 3행(SIZ_000007·SIZ_000050·SIZ_000052) 있으나
  `output_paper_typ_cd`가 **전부 공란**이고 용도가 "파일사양"(output_file_typ=JPG)이며 **junction del_yn=Y
  논리삭제(06-30)** 상태다 — 판걸이수 산정용 출력용지 판형이 아니라 **파일 규격 플레이스홀더**(이미 은퇴).
  ★실사는 **대형 출력+보드+거치대**라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음) → 판형
  (`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용 금지**
  (pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서
  `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·131 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-144 --priced_by--> formula-PRF_POSTER_MINI_STANDBOARD --has_component--> component-COMP_POSTER_MINI_STANDBOARD`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(formula_components
  실측 1행·전사표·disp_seq 1·addtn_yn=Y).
- ★**고정가형(fixed-price·siz_cd×수량밴드 룩업)** = 원자합산형(디지털 인쇄+용지+공정 합산)·면적매트릭스형
  (포스터 가로×세로 셀)·고정룩업형(스티커 siz_cd)과 대비되는 **실사 고정가 아키타입**(131과 공유). 단일
  구성요소 `COMP_POSTER_MINI_STANDBOARD`를 use_dims 2축(**규격 siz_cd × 수량 min_qty**)으로 조회한다.
  단가표=**규격 3셀(A5·A4·A3) × 수량 5밴드 = 15행 완전격자**(grid_full=True·전사표). ★131(수량 단일밴드
  ·2셀)과 달리 144는 **수량축이 진짜 있는** 고정가([수량×규격] 블록)라 수량밴드 간 단가차가 존재한다(값
  =evaluate_price). 면적(가로×세로) 셀이 아니라 **등록 규격(siz_cd) 키** 룩업이라 off-grid ceiling·비대칭
  개념이 없다(nonspec_yn=N).
- ★공식/구성요소는 **144 전용 신규**(실사 고정가형·131 형제) — [[product-144-mini-board-standing-nodes]]에
  mint. 실사 고정가 15상품(129/130/131/132/…/144/145 pack §3.10) 공유 축 승격 후보(→ needed_shared_nodes).
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹:** `t_prd_product_option_groups` = 144 행 **없음**(CPQ 옵션 0). 손님 선택축은 규격·수량뿐이며
  거치대/코팅 선택 옵션이 없다(통가격 baked). 실사 CPQ는 일반현수막138 파일럿만 적재된 상태라(pack §1.1·
  §3.9) 144 옵션 0행은 실사 공통(BATCH-6 대기·설계상 해당 없음).
- **제약규칙:** `t_prd_product_constraints` = 144에 **0행**. ★118·125 등 면적매트릭스 형제는 nonspec
  치수범위 제약(RULE_001) 1행을 갖지만, 144는 **nonspec_yn=N**(사용자입력 치수 없음)이라 검증할 범위가
  없어 제약 0행이 **정당**하다(defect 아님). pack §1.1의 constraints 신규 발현 7상품(118/120/121/122/124/
  125/139)에 144가 **포함되지 않는 것**과 정합(nonspec 상품만 범위 제약 보유).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 144 행 **없음**. ★거치대가 통가격에 baked
  (완제품가 note)라 현재는 단품 통가격 상품이나, pack §3.12는 **거치대류 부속의 귀속을 AMBIGUOUS**로 남긴다
  — 거치대 완성이 **공정(통가격 baked)**인지 **부속(거치대 별매 addon/set)**인지 미결(GAP-SL-4·형제 136/137
  PET/메쉬배너의 우드거치대 재연결 후보와 대비). [[product-144-mini-board-standing-nodes#gap-144-stand-attribution]]로
  정직 선언(단정 금지).

## 승계·freshness 메모
- 정체·고정가형 분기(면적매트릭스 아님)는 pack §3.10·§5.2(FRESH·INHERIT) + mapping.md §1.1 승계·재검증.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 **라이브 COMMIT으로 이미 해소**
  — 144는 정상 사인/POP 연결. constraints는 144가 nonspec_yn=N이라 애초에 해당 없음(0행 정당). 부속 addon
  (SL-DEF-005)·거치대 귀속(SL-DEF-007 계열)은 **잔존/미결**(GAP 선언). round-13/위키를 그대로 옮기면 오염
  이라 live-snapshot 20260702_1119 실측으로 재판정(현재값=정답 or GAP).
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5)·"29 실사 전부 면적매트릭스 일괄"(T-5)은 인용 안 함 — 144는
  명시 고정가 15셀 완전격자(전사표)만 승계(mapping.md §1.1 고정가 분류).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정·양면 노드 없음 — 단 A5 SIZ_000170은 공유 축 소유 양면 defect·144는 활성 참조자).
  고정가 완제품가 산정 근거(규격/수량밴드별 통가격이 어떤 원가/규칙으로 도출됐나)는 엑셀 미기재 암묵지 GAP
  ([[product-144-mini-board-standing-nodes#gap-144-price-basis]]).
