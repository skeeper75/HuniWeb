---
id: product-129-foam-board
type: product
anchor: t_prd_products/PRD_000129
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000129(prd_nm=폼보드·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·file_upload_yn=Y·editor_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§5 고정가형 16상품(수량×규격)·폼보드=BLOCKED-OUT-OF-SCOPE from 면적매트릭스(round-2 트랩 재발 방지·D-OOS)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10·§3.1 실사 고정가형 15상품(폼보드129)·소재/사이즈별 완제품 통가격·실사 inline price 권위 아님(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(root·main_cat_yn=Y·disp_seq=12·118/119 정의 재사용)"}
  - {rel: in_category, target: category-CAT_000080, note: "보드액자(leaf·cat_lvl=2·upr=CAT_000004·병렬 실사 companion canonical 재사용)"}
  - {rel: has_size, target: size-SIZ_000315, note: "A3 규격(del_yn=N·07-01 재키잉·118 정의 재사용)"}
  - {rel: has_size, target: size-SIZ_000198, note: "A2 규격(del_yn=N·118 정의 재사용)"}
  - {rel: uses_material, target: material-MAT_000398, note: "A3 폼보드(화이트) 5mm·MAT_TYPE.16"}
  - {rel: uses_material, target: material-MAT_000399, note: "A3 폼보드(블랙) 5mm·MAT_TYPE.16"}
  - {rel: uses_material, target: material-MAT_000612, note: "A2 폼보드(화이트) 5mm·MAT_TYPE.16"}
  - {rel: uses_material, target: material-MAT_000613, note: "A2 폼보드(블랙) 5mm·MAT_TYPE.16"}
  - {rel: has_process, target: process-PROC_000115, note: "유광코팅(선택·mand N·118 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000116, note: "무광코팅(선택·mand N·118 정의 재사용)"}
  - {rel: has_process, target: process-PROC_000135, note: "실사가공(선택·mand N·보드칼라 옵션 참조·129 companion mint)"}
  - {rel: has_qty_rule, target: qty-129, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_FOAMBOARD, note: "완제품가 고정가형(소재/사이즈별 통가격 룩업)"}
  - {rel: has_option_group, target: optgroup-129-boardcolor, note: "보드칼라 택1(화이트/블랙·mand Y)"}
  - {rel: has_option_group, target: optgroup-129-coating, note: "코팅 택1(없음/무광/유광·mand N)"}
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
  archetype: "고정가형(fixed-lookup·use_dims=[mat_cd,siz_cd]·소재/사이즈별 완제품 통가격)"
standards: {schema_org: Product, xjdf: "Product(보드·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(폼보드 가격 경로)", "조건 탐색(보드 규격·색상·코팅)"]
tags: ["#실사", "#보드", "#폼보드", "#고정가형", "#비종이류"]
updated: 2026-07-03
---

# product-129 폼보드 (PRD_000129)

폼보드는 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`) 상품이다.
손님이 **규격(A3/A2)·보드 색상(화이트/블랙)·코팅**을 고르면 **소재(mat_cd)×사이즈(siz_cd) 고정가
룩업**에서 **완제품 통가격(출력+코팅+가공 포함)** 을 조회한다. ★118 아트프린트포스터가 **면적매트릭스형**
(가로×세로 셀단가)인 것과 달리, 폼보드는 **자유치수 없는(nonspec_yn=N) 고정가형**(이산 규격 룩업)이다
— 실사 2 모델 공존의 다른 축(pack §3.10·mapping.md §5). 파일 업로드 방식(`file_upload_yn=Y`·에디터 미사용).
수치(치수·자재·격자 SHAPE)는 [[product-129-foam-board-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 폼보드는 `t_prd_product_sets` 부모 등록이
  없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합).
- 상품군 = **실사**(카테고리 004 포스터). 보드류(폼보드/포맥스보드) — 굿즈/포장재 아님.
- 카테고리: 포스터 `CAT_000004`(root·main_cat_yn=Y·disp_seq=12) + 보드액자 `CAT_000080`(leaf·
  cat_lvl=2·upr=CAT_000004). ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE**
  — `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 129는 정상 카테고리 노드로 재연결됨(pack §1.1·§4 T-1).
  현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 이산 규격 **2행**(A3 `SIZ_000315` / A2 `SIZ_000198`·전부 링크 del_yn=N). ★**자유치수
  없음**(`nonspec_yn=N`) — 118 포스터의 nonspec 연속범위와 다르다(고정가형 정체). 118은 A1까지 3규격이나
  폼보드는 **A1 미연결**(A3/A2만·전사표). 구 코드(SIZ_000174/197)는 07-01 재키잉되어 상품에서 논리삭제됨.
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 129 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  129 행 **없음**(제품 레벨 규칙만). ★가격 구성요소 use_dims=`[mat_cd,siz_cd]`에 **min_qty가 없다** —
  즉 수량은 가격 차원이 아니고 총액=완제품 단가×수량(수량구간 할인 없음). 공식명은 "소재/사이즈/**수량별**"
  이라 표현하나 격자에 수량축 부재 → [[gap-129-qty-band-absent]](권위 260527 수량축 대조 필요·정직 GAP).

## 자재·공정
- **자재:** **폼보드 4종 = 색상(화이트/블랙) × 규격(A3/A2)**·전부 `MAT_TYPE.16 실사부자재`·USAGE.07 단일
  슬롯·부모 `MAT_000004`(전사표). ★**자재명에 사이즈가 내장**(A3 폼보드 / A2 폼보드) — 이 모델이 아래
  가격 엇갈림의 근원([[gap-129-matsize-mismatch]]). ★자재유형 `MAT_TYPE.16`은 **현재값=정답**(실사부자재·
  06-26 신설 코드) — 실사 팩이 경고한 **레더 `MAT_000186` .05/.08 crosscut(pack §1.1·T-2)과 무관**하다
  (폼보드는 보드류 .16·레더 아님·양면 불요·false-defect 방지). ★IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 코팅 2종(유광 `PROC_000115` / 무광 `PROC_000116`·둘 다 상위 PROC_000114 쿨코팅·mand N) +
  **실사가공 `PROC_000135`**(상위 PROC_000083 가공·mand N·보드칼라 옵션이 참조). ★07-01 **재키잉**: 구
  라미네이팅(유광 PROC_000014·무광 PROC_000015)이 상품에서 `del_yn=Y` 논리삭제되고 코팅 공정으로 교체됨
  (전사표). 코팅·가공은 **고정가 통가격에 포함**(구성요소 note "출력+코팅+가공 포함"·pack §3.10)이라 별도
  원자합산이 아니라 소재/사이즈별 셀단가에 녹아 있다. 실사 대형 잉크젯 인쇄방식 공정(PROC_000006)은
  라이브에 129 행이 없다(실사 공통·po=0·설계상 정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 129에 2행(SIZ_000052/198) 있으나 `output_paper_typ_cd`가 **공란**
  이고 용도가 "파일사양"(output_file_typ=JPG)이며 **둘 다 del_yn=Y**(06-30 삭제) — 판걸이수 산정용 출력용지
  판형이 아니라 **파일 규격 플레이스홀더**다. ★실사=**대형 보드 출력**이라 절수 기반 전지 규격이 무의미
  → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에 적용
  금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]). 그래서
  `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·118/050 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-129 --priced_by--> formula-PRF_POSTER_FOAMBOARD --has_component--> component-COMP_POSTER_FOAMBOARD_BOARD`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(O5·O6 충족).
- **고정가형(fixed-lookup)** = 원자합산형(디지털 인쇄+용지+공정 합산)·면적매트릭스형(포스터 가로×세로)과
  **다른 아키타입**(pack §3.10 2 모델 공존). 단일 구성요소 `COMP_POSTER_FOAMBOARD_BOARD`를 use_dims 2축
  (**자재 mat_cd × 사이즈 siz_cd**)으로 룩업한다(PRICE_TYPE.01·PRC_COMPONENT_TYPE.01). off-grid ceiling
  없음(정확 매칭 룩업).
- ★**동형결합 구성요소:** `COMP_POSTER_FOAMBOARD_BOARD`(보드칼라×사이즈)는 [동형결합 260702]으로 구
  per-color/thickness 구성요소(`COMP_POSTER_FOAMBOARD_WHITE`·`_BLACK`·둘 다 use_yn=N 은퇴)를 `mat_cd`
  축으로 통합한다(comp note). 포맥스보드130은 별개 구성요소(`COMP_POSTER_FOMEXBOARD_BOARD`·"폼보드 BOARD
  동형"이나 별 comp) — 폼보드/포맥스보드 구성요소 미통합.
- ★**격자 엇갈림(끊긴 경로 정직 선언):** 격자는 (A3siz×A3mat)·(A2siz×A2mat) **대각선 4셀만** 단가행
  존재(전사표). 상품제공 자재4×사이즈2 = naive 8조합 중 4조합(대각선-밖)은 단가행 부재. 옵션 보드칼라가
  **A3 자재(398/399)만 참조**하므로 사이즈=A2 선택 시 (A2siz, A3mat) 미가격 조합 → **견적 0 위험** →
  [[gap-129-matsize-mismatch]](CN-2 엇갈림·§31 판례 P-1). 값(unit_price)은 기록하지 않는다(연결·격자
  coverage·차원까지·값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹 2:** 보드칼라(`OPT-000045`·SEL_TYPE.01·min1/max1·mand_yn=Y — 화이트보드/블랙보드) + 코팅
  (`OPT-000044`·SEL_TYPE.01·min0/max1·mand_yn=N — 무광/유광). 보드칼라 item은 자재(OPT_REF_DIM.03)+실사가공
  공정(OPT_REF_DIM.04)을, 코팅 item은 공정(OPT_REF_DIM.04)을 가리켜 선택이 uses_material·has_process
  차원으로 환원된다(R11 option_refs·L-18 부모정합). ★보드칼라는 **A3 자재만 배선**(A2 미배선)·유광코팅
  item은 참조 공정 미배선(전사표) → 상세·GAP=[[product-129-foam-board-nodes]].
- **제약규칙:** `t_prd_product_constraints` = 129에 **0행**(live-snapshot 20260702_1119 실측). 129는 118과
  달리 자유치수가 없어(nonspec_yn=N) 치수범위 제약이 불필요하다(pack §1.1 constraints 발현 7상품 목록에
  129 부재·정합). ★단 자재↔사이즈 엇갈림(대각선-밖 4조합)을 막는 CN-2 제약은 **아직 미등록**(스냅샷 시점)
  — §31 constraint-rules 하네스가 판례 P-1로 다루는 대상([[gap-129-matsize-mismatch]]). evaluate_price는
  제약 미참조이므로 엇갈림 차단은 위젯/주문 validate 소관(constraint-builder 계약).
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 129 행 **없음**. 폼보드는 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·고정가형 분기는 pack §3.1·§3.10 + mapping.md §5(고정가형·BLOCKED-OUT-OF-SCOPE)의 승계·재검증.
  "29 전부 면적매트릭스" 일괄 금지(round-2 오모델·T-5) — 폼보드는 고정가형(수량×규격 계열)이 확정 아키타입.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)는 라이브 COMMIT으로 이미 해소
  — 129는 정상 카테고리 연결. round-13/위키를 그대로 옮기면 오염이라 live-snapshot 20260702_1119 실측으로
  재판정(현재값=정답).
- ★자재유형 crosscut(T-2): 폼보드 자재는 `MAT_TYPE.16 실사부자재`이며 레더 .05/.08 crosscut과 무관
  (양면 불요·false-defect 방지). 좌표 회귀·round-2 sparse(T-4·T-5)는 면적매트릭스 함정이라 고정가형 폼보드에
  애초 무관.
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견. 롤/보드 소재 완제품 셀단가 산정 로직은 엑셀 미기재 암묵지 GAP([[gap-129-board-price-logic]]).
