<!-- namespace file: sticker-spec-square (반칼정사각스티커 PRD_000059) — 스티커 파일럿 첫 상품. -->
<!-- ★블록-노드 파일(frontmatter 아님) — L-1 파일명↔id 검사 예외(is_file_node=False). 축/formula 파일과 동형. -->
<!-- ★공유 파일(index/axis/*/formula/*/rule/*) 미수정 — 스티커 전용 신규 축 원자는 sticker-spec-square-nodes.md에 -->
<!--   임시 거처(축 승격 대기·needed_shared_nodes 반환). 수치는 전사표(transcribe_sticker_059.py)에만. -->

# 스티커 파일럿 — 반칼정사각스티커 (PRD_000059)

반칼정사각스티커는 **스티커 상품군의 첫 온톨로지 상품**(상품마스터 260702 스티커 시트·
라이브 `PRD_000059`). 규격(정사각) 점착지에 CMYK 4도 단면 인쇄 후 **반칼(Kiss Cut) 계열
커팅**으로 시트 위에 낱장을 따는 규격스티커다. 상세 축 원자·가격공식·GAP은
[[sticker-spec-square-nodes]]가 담는다(스티커 전용 신규 축 = 공유축 승격 대기).

★스티커 파일럿 3대 특성(디지털인쇄 상품군과 다른 점·팩 §0):
1. **가격 = 완제품가(시트가격) 고정가 룩업** — 원자합산형(인쇄비+용지비+공정비)이 **아니다**.
   `PRF_STK_FIXED`가 `COMP_STK_PRINT`(소재·규격·수량별 완제품가) 하나만 배선한다.
2. **소재 연당가(원자재 원가)는 이 상품 가격사슬에 노드로 없다** — 완제품가로 통째 저장(팩 §4).
   059의 5개 소재는 260702 연당가 재적재 대상(투명/홀로/크라프트)에 **해당 없음**(아래 연당가 절).
3. **코팅이 자재로 적재된 CONFLICT가 살아있다**(무광/유광코팅스티커=자재 vs Q9 코팅=공정·[[gap-059-coating-conflict]]).

## product 노드 (정체·유형 SOT)

### [product-059-sticker-spec-square] 반칼정사각스티커 (PRD_000059) {verified}
- type: product
- anchor: t_prd_products/PRD_000059
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000059", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§3.1 정체·§3.2 형상=size·§1.1 prd_typ 재분류", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stk}
- src: {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "문서:§1 16상품 정체확정표(규격스티커 059)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
- rel: {rel: in_category, target: category-CAT_000002, note: "스티커(root·main_cat_yn=Y·disp_seq 9)"}
- rel: {rel: in_category, target: category-CAT_000037, note: "규격스티커(2단·main_cat_yn=N·부카테고리)"}
- rel: {rel: has_size, target: size-SIZ_000520, note: "A4(210x297) 반칼 전용가·활성. SIZ_000170(A5)은 master del_yn=Y 06-17(폐지)→prose"}
- rel: {rel: uses_material, target: material-MAT_000153, note: "유포스티커·MAT_TYPE.11·dflt"}
- rel: {rel: uses_material, target: material-MAT_000084, note: "비코팅스티커·라이브 MAT_TYPE.13(note는 .11 주장·불일치→prose)"}
- rel: {rel: uses_material, target: material-MAT_000242, note: "미색스티커·MAT_TYPE.11"}
- rel: {rel: uses_material, target: material-MAT_000155, note: "무광코팅스티커·MAT_TYPE.11(코팅=자재 CONFLICT·gap)"}
- rel: {rel: uses_material, target: material-MAT_000156, note: "유광코팅스티커·MAT_TYPE.11(코팅=자재 CONFLICT·gap)"}
- rel: {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001)·공유축 기존 노드"}
- rel: {rel: has_process, target: process-PROC_000055, note: "스티커완칼(Die Cut+조각수)·mand_proc_yn=N. 상품명 '반칼'과 명칭 불일치→gap"}
- rel: {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_02, note: "46계열 전지(SIZ_000521 330x470)·점착지=종이류라 판형 유효(RULE_plate_paper_only)·활성. 국전 SIZ_000007/A4 SIZ_000050은 06-30 del_yn=Y"}
- rel: {rel: priced_by, target: formula-PRF_STK_FIXED, note: "스티커 규격/소재/수량별 단가(완제품가 고정가 룩업)"}
- rel: {rel: has_qty_rule, target: qty-059, note: "상품레벨 min 4·max 10000·incr 4·QTY_UNIT.02(bundle_qtys 0행)·형제 15상품 동형"}
- props: {prd_typ_cd: "PRD_TYPE.01", semi_role_cd: "null", file_upload_yn: "Y", editor_yn: "Y", min_qty: 4, max_qty: 10000, qty_incr: 4, qty_unit_typ_cd: "QTY_UNIT.02", use_yn: "Y", del_yn: "N", qty_src: "전사표(transcribe_sticker_059.py)·raw 손전사 아님"}
- standards: {schema_org: "Product", xjdf: "Product(스티커/라벨)", config_ont: "component type"}
- answers_cq: ["구체 상품 질의(반칼스티커 구성·가격 경로)", "조건 탐색(정사각 규격스티커)"]
- 본문: 반칼정사각스티커는 스티커 **완제품 단일**(prd_typ_cd=PRD_TYPE.01·SOT 정합). t_prd_product_sets 부모/구성원 등록이 없어 셋트 아님(일반 단일 완제품·[[rule/rules#RULE_scope_boundary]] 범위 안). 규격스티커 family(058~062) 소속·정체 오분류 0(팩 §3.1). round-13 "전량 prd_typ.04 디자인상품"은 STALE — 라이브 재분류로 .01 완제품이 현재값(팩 §1.1·T-1). file_upload·editor 양쪽 Y. 수량 min 4/max 10000/incr 4(QTY_UNIT.02·[[sticker-spec-square-nodes]] 전사표). 카테고리=스티커(CAT_000002)>규격스티커(CAT_000037).

## 차원 (사이즈·형상·도수·수량)

- **사이즈:** 활성 1행 = SIZ_000520 `A4(210x297mm) 반칼`(반칼 전용가·B02 낱장 SIZ_172와 분리).
  master는 work/cut mm 미기재(note에 판걸이=2.0)·[[sticker-spec-square-nodes]] 전사표. product_sizes
  junction은 SIZ_000170(A5)도 링크하나 **master del_yn=Y(06-17 폐지)** → 유효 사이즈 아님(고아 링크·[[rule/rules#RULE_dataline_neq_wiring]] 유형). 활성 has_size는 SIZ_000520만.
- **형상(칼틀):** 상품명은 "정사각"이나 **정사각 형상이 size에도 옵션에도 별도 저장되지 않는다**
  (규격형 058~062 형상 저장처 미결·[[gap-059-spec-shape-cut]]·팩 GAP-ST-3·Q-ST-C). 066 합판도무송처럼
  형상=siz_nm으로 흡수되지 않음(family 모델 불일치). 형상을 자재/옵션으로 오판 금지(팩 §0).
- **도수:** 단면 CMYK 4도(printopt-POPT_000001·front CLR_000005/back CLR_000001). 도수=인쇄옵션 코드값이지
  색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]). 화이트 underbase(PROC_000008)는 059 무관(불투명 규격·팩 §3.3).
- **수량규칙:** 제품 레벨 min 4/max 10000/incr 4. `t_prd_product_bundle_qtys`에 059 행 **0개**
  (조각수·묶음수 규칙 라이브 미적재 — 팩 §3.4에서 066만 5행). 수량 UI 권위=제품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정

- **자재:** 5소재 = 유포(MAT_000153)·비코팅(MAT_000084)·미색(MAT_000242)·무광코팅(MAT_000155)·
  유광코팅(MAT_000156). 전부 usage_cd=USAGE.07(공통) 단일 슬롯. 정답 자재유형=MAT_TYPE.11(스티커용지)·
  6-14 재분류 note 실재(종이.01→스티커.11·팩 §3.5). ★**비코팅 MAT_000084는 라이브 값 MAT_TYPE.13(합판스티커용지)**
  인데 note는 ".11로 정정"이라 주장 → **note↔값 불일치**(candidate 관찰·[[sticker-spec-square-nodes]]). ★IMPORT 등록 자재
  삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = **PROC_000055(스티커완칼·Die Cut+조각수) 1행·mand_proc_yn=N**뿐.
  상품명은 "반칼"(Kiss Cut=PROC_000054)인데 실제 바인딩은 PROC_000055 → **명칭↔공정 불일치**([[gap-059-spec-shape-cut]]).
  단 규격 family 058~062 전부 PROC_000055라 family 관례일 수 있음(단정 금지·Q-ST-C). ★**base 인쇄공정
  PROC_000004 미바인딩은 결함 아님** — 스티커는 완제품가 룩업이라 인쇄비 원자component가 없다(디지털
  원자합산형의 인쇄비0 결함과 다름·false-defect 회피·[[rule/rules#RULE_dataline_neq_wiring]] 반대사례).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)

- `product-059 --priced_by--> formula-PRF_STK_FIXED --has_component--> component-COMP_STK_PRINT`.
  COMP_STK_PRINT use_dims=`[siz_cd, mat_cd, min_qty]`(PRICE_TYPE.01·완제품가). 즉 가격은
  **소재×규격×수량 격자의 시트가격 고정가**(형상×치수×코팅 격자·팩 §3.10). 면적매트릭스 아님·구간할인(t_dsc_*) 비대상.
- 단가행(COMP_STK_PRINT 6498행 중 059 SIZ_000520 참조 540행·소재별 각 36행)은 노드로 펼치지 않고
  구성요소 속성으로 접는다(D-22). 연결 증거·행수 = [[sticker-spec-square-nodes]] 전사표(★단가 **값**은 미전사).
- **코팅=가격축:** 가격표는 비코팅/무광/유광 3컬럼(코팅이 가격을 가른다) → 코팅을 자재(MAT_000155/156)로도
  적재. 이 CONFLICT(자재 vs 공정 vs 가격축)는 [[gap-059-coating-conflict]]로 양면 표기(단정 금지·팩 §3.9 BATCH-3).

## ★연당가 (돈-크리티컬) — 059는 재적재 워크리스트 대상 아님

- 팩 §4 연당가 양면(defect) 재적재 워크리스트 = **투명스티커(백색후지 MAT_000162)·홀로그램(163)·크라프트(164)·
  투명후지(372)** 4소재. **059의 5소재(153/084/242/155/156)는 이 목록에 없다** → 059에는 연당가 양면 노드가 없다(정직).
- 근거: ① COMP_PAPER(용지비 절가)에 059 소재 mat_cd **0행**(실측·전사표) — 스티커는 원가를 절가로 펼치지
  않고 완제품가로 저장. ② 스티커 완제품 가격표(COMP_STK_PRINT)는 260702에서 **무변경**(팩 §4-B) → retail=권위 일치
  → **retail 노드 dual 금지**(false-defect 회피). 따라서 059의 dual_nodes=∅. 원가 급락의 완제품가 전파 여부는
  타 소재(투명/홀로/크라프트) 상품 소관의 열린 질문(059 무관).

## 옵션·제약·추가상품

- **옵션그룹:** 라이브 `t_prd_product_option_groups`에 059 행 **없음**(CPQ 옵션 레이어 미적재·팩 §3.9 BATCH-6 범위).
- **제약규칙:** `t_prd_product_constraints`에 059 행 **없음**. 코팅=자재 CONFLICT는 제약이 아니라 모델링 갭([[gap-059-coating-conflict]]).
- **추가상품:** `t_prd_product_addons`에 059 행 **없음**(단품 인쇄물·addon 얕음·팩 §3.12).
- **셋트:** `t_prd_product_sets` 부모/구성원 아님(스티커팩 065만 세트·059 무관).

## 승계·freshness 메모

- 정체·형상=size·인쇄방식 의미 = 팩 §3.1/§3.2·17_correctness/sticker FRESH 승계. prd_typ은 PRD_TYPE.01로 갱신(§1.1·T-1).
- 결함표(위키 recipes/sticker §7 STK-ST-*)는 시점 낡음(T-6) → §4/§3 각 축 REVERIFY + live-snapshot으로 재조준(직접 이관 안 함).
- STALE 회피: price-engine-ddl 8차원(T-2)·constraint_json(T-3)·판수=앱계산(T-7)·구 연당가 무대조(T-8) 미인용.
