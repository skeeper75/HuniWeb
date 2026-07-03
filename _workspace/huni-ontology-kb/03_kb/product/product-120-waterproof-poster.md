---
id: product-120-waterproof-poster
type: product
anchor: t_prd_products/PRD_000120
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000120 (방수포스터·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·nonspec_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§0 특성1~4·§3.1 정체·§3.10 면적매트릭스 13(B03 방수120)·§3.11 comp·§5 인계", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000120,PRF_POSTER_WATERPROOF) note:방수포스터 완제품가(면적/규격 단가)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "문서:실사=포스터/사인 면적매트릭스 [가로×세로]·off-grid=한 단계 큰 크기·비종이류→판형 없음", captured_at: "2026-07-03", badge: verified, src_id: SR-domain-rules}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(main_cat_yn=Y·leaf 정밀도 확인 대상·needed_shared)"}
  - {rel: in_category, target: category-CAT_000314, note: "부카테고리(main_cat_yn=N·06-19 신규노드·needed_shared)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3 297x420 프리셋(master 활성·needed_shared)"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2 420x594 프리셋(공유 axis/sizes 실재 — 재사용·055 최초 소비)"}
  - {rel: has_size, target: size-SIZ_000293, note: "★A1 594x841 — junction 활성이나 master del_yn=Y(06-17)=양면 defect(형제 121 minted defect 노드 재사용·needed_shared)"}
  - {rel: uses_material, target: material-MAT_000178, note: "PET(MAT_TYPE.08 실사소재)·USAGE.07·dflt — 공유 axis/materials 실재(039 투명명함 최초 소비)·재사용"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(opt·mand=N·상위 PROC_000013)·공유 축 재사용·코팅 옵션값"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(opt·mand=N·상위 PROC_000013)·공유 축 재사용·코팅 default"}
  - {rel: priced_by, target: formula-PRF_POSTER_WATERPROOF, note: "완제품가 면적매트릭스형(실사 첫 아키타입·needed_shared)"}
  - {rel: has_option_group, target: optgroup-120-coating, note: "코팅 택1(무광 default/유광)·가격 미기여(통가격 포함)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  nonspec_yn: Y
  use_yn: Y
  del_yn: N
  nonspec_src: "전사표(transcribe_product_120.py) 가로 200~1200(incr200)·세로 200~3000(incr200) — raw 손전사 아님"
  archetype: "면적매트릭스형([가로×세로] 셀단가·off-grid ceiling)"
standards: {schema_org: Product, xjdf: "Product(실사 포스터/Poster)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(방수포스터 가격 경로)", "조건 탐색(실사 면적 가격이 어떤 축으로 달라지나)"]
tags: ["#실사", "#포스터사인", "#방수포스터", "#면적매트릭스", "#비종이류"]
updated: 2026-07-03
---

# product-120 방수포스터 (PRD_000120)

방수포스터는 **실사(포스터/사인)** 상품군의 첫 온톨로지 노드이자, 그 대표 아키타입인
**면적매트릭스형** 가격의 표준 사례다. 손님이 **가로·세로 치수**(사용자입력·200~3000mm 범위)를
정하면, 포스터사인 **[가로×세로] 셀단가표**에서 **완제품가(소재+출력+가공 포함 통가격)** 를 조회한다.
파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용). 수량 1~1000(1 증분·단위 QTY_UNIT.01). 치수·
셀·자재·배선 raw 값은 [[product-120-waterproof-poster-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 방수포스터는 `t_prd_product_sets` 부모
  등록이 없어(라이브 실측 — sets 미등재) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합).
- 상품군 = **실사**(카테고리 004 포스터·005 사인 계열의 대형 실사 출력물·굿즈/포장재 아님·팩 §3.1).
- **★실사 4대 특성(팩 §0):** ① 소재가 상품을 가른다(방수=PET 방수 소재) ② 가격=면적매트릭스형(13상품
  중 하나·B03) ③ **비종이류라 판형 없음** ④ 방수포스터는 "부속붙는 8상품"이 아닌 **단품**(addon/set 무).
- 카테고리: 주 = 포스터 `CAT_000004`(main_cat_yn=Y) + 부 = `CAT_000314`(06-19 신규노드·main_cat_yn=N).
  ★round-13 "실사 전부 CAT_000298 고아"는 **STALE**(CAT_000298 del_yn=Y 논리삭제·28상품 정상 재연결·
  팩 §1.1 T-1). 이 노드는 현재 정상연결을 기록(leaf 귀속 정밀도만 확인 대상).

## 차원
- **사이즈(★실사 특유):** 이산 규격 프리셋 3행(A3 `SIZ_000174` / A2 `SIZ_000197` / A1 `SIZ_000293`)
  + **비규격 연속범위**(사용자입력 가로 200~1200·세로 200~3000·200 증분). ★**비규격 범위는 입력 UX
  한계일 뿐 가격격자가 아니다** — 유효 가격 권위 = 포스터사인 면적매트릭스 셀([가로×세로]). off-grid
  (격자 밖 치수) = 가로·세로 각 **한 단계 큰 규격으로 ceiling**(앱 계산·DB는 룩업행·팩 §3.2·도메인규칙).
  A1(SIZ_000293)은 junction 활성이나 master 삭제(06-17) → **양면 defect**(현재값=junction 활성 vs 정답=
  master 삭제·형제 121이 minted한 size-SIZ_000293 defect 노드 공유·[[product-121-adhesive-waterproof-poster-nodes]]).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 120 행 **없음**(po=0). 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(도수=print_opt_cd
  프레임·[[rule/rules#RULE_dosu_is_printopt]]·팩 §3.3·§3.7).
- **수량규칙:** 제품 레벨 min 1 / max 1000 / incr 1(QTY_UNIT.01·전사표). `t_prd_product_bundle_qtys` = 120 행
  **없음**. ★**면적매트릭스형은 수량축이 없다**(매트릭스 셀=완제품 통가격·팩 §3.4) — component use_dims의
  `min_qty`는 셀에서 전부 빈값(수량밴드 없음·전사표 SHAPE 확인). 수량 UI 권위=상품 규칙([[rule/decisions#DEC_qty_audit_260702]]).
  별도 bundle_qty 노드는 만들지 않는다(면적 실사 형제 공통·orphan 회피·props+전사표로 충분).

## 자재·공정
- **자재:** **PET `MAT_000178`**(MAT_TYPE.08 실사소재·USAGE.07·dflt) 단일 슬롯. 실사 자재 = 소재별 본체
  자재 단일(낱장 완제품·내지/표지 없음·팩 §3.5). ★공유 [[axis/materials#material-MAT_000178]] 실재
  (039 투명명함 최초 소비·bare PET)라 **재사용**(중복 mint 금지). ★IMPORT 등록 자재 삭제 금지
  ([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = 유광라미 `PROC_000014` + 무광라미 `PROC_000015`(둘 다
  opt·mand=N·상위 PROC_000013 라미코팅). 둘 다 공유 [[axis/processes#process-PROC_000014]] 재사용.
  ★**인쇄방식 공정(실사출력 `PROC_000006`)은 120에 미바인딩** — 실사 인쇄방식은 `PROC_000006` 단일이나
  라이브엔 전 실사 인쇄방식 공정 행이 부재(po=0·팩 §3.7)이고, 방수포스터는 **완제품가 매트릭스형**이라
  출력·가공이 완제품가 구성요소에 포함된다(통가격). 봉투제작(050)의 "PROC_000004 base 미바인딩=인쇄비 0
  결함"과 **다르다**(설계상 해당 없음이지 결함 아님·모델링 주의·[[rule/decisions#DEC_baseproc_260701]] 비대상).

## 판형 (종이류 규칙 — ★해당 없음·비종이류)
- 라이브 `t_prd_product_plate_sizes` = 120에 3행 있으나 `output_paper_typ_cd`가 **전부 공란**이고 용도가
  "파일사양"(output_file_typ=JPG)이며 **전부 del_yn=Y**(06-30 논리삭제). 방수포스터는 **대형 롤 출력**이라
  절수 기반 전지(원지) 규격이 무의미하다 — 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`)는 **종이류 전용
  로직**이므로 실사에 적용 금지([[rule/rules#RULE_plate_paper_only]]·팩 §3.8·T-7). 그래서 `has_plate_size`
  관계를 **걸지 않는다**(정직 표기·환각 방지). 스티커/디지털 팩의 판형 SOT를 실사에 이식하면 오모델.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-120 --priced_by--> formula-PRF_POSTER_WATERPROOF --has_component--> component-COMP_POSTER_ARTPRINT_PHOTO`.
  **가격 경로 연결됨(고아 공식 아님)** — 공식이 완제품가 구성요소 1건을 배선한다(전사표 배선행 확인).
- **면적매트릭스형** = 원자합산형(디지털 PRF_DGP_*)·고정가 룩업형(스티커 PRF_STK_FIXED)과 다른 **세 번째
  아키타입**. 단일 구성요소를 use_dims 2축(**가로 siz_width × 세로 siz_height**)으로 조회한다. **매트릭스
  비대칭**(가로×세로 순서가 뒤바뀌면 다른 셀)이라 각 (가로,세로) 순서쌍이 고유 셀. 아크릴 면적매트릭스와 동형(팩 §3.11).
- **★동형결합 구성요소(REVERIFY):** 방수포스터의 완제품가는 전용 `COMP_POSTER_WATERPROOF_PET`가 아니라
  **`COMP_POSTER_ARTPRINT_PHOTO`(4소재 통합)** 에 있다 — "가격표 동일 4소재(아트프린트/접착방수/아트패브릭/
  방수포스터) 동형결합"(comp note 실측). 전용 comp `COMP_POSTER_WATERPROOF_PET`는 use_yn=N 은퇴(06-17).
  → 팩 §3.11 round-2 **D-WIRE GAP**(28상품 단일 comp·매트릭스 2~6%만 적재) 우려는 **해소**(현재 동형결합
  52셀·grid_full=True·전사표 SHAPE). round-2 sparse 인용은 STALE(T-5).
- **격자완전:** 셀 52개 = 가로 4구간(600/800/1000/1200) × 세로 13구간(600~3000 step 200)이 이 빠짐 없이
  채워짐(grid_full=True·전사표). 격자 안 (가로,세로) 조합은 단가 조회 가능·격자 밖은 ceiling. ★단, 격자
  최소치수(가로 600·세로 600)가 상품 nonspec 최소(가로 200·세로 200)보다 커서 200~600 구간은 전부
  600으로 ceiling된다(off-grid 정상 경로·값 판정=엔진). 가격 값은 기록하지 않는다(연결·격자완전성까지·
  값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]). ★실사 시트 inline price(R/S/V)는 가격 권위
  아님 — 권위는 인쇄상품 가격표 "포스터사인" 시트(팩 §3.10 [HARD]·T-4 좌표회귀 DROP).

## 옵션·제약·추가상품
- **옵션그룹:** 코팅(`OPT_000006`·SEL_TYPE.01·min/max=0/1·mand=N) — 무광코팅(default)/유광코팅 택1.
  2 옵션값이 각각 라미 공정(무광 PROC_000015·유광 PROC_000014·`OPT_REF_DIM.04`)을 가리켜(R11 option_refs)
  부모 has_process에 실재(L-18 정합). ★**코팅 선택은 가격 미기여**(공식이 완제품가 comp 1건만 배선·별도
  코팅 comp 배선 없음→가격 delta 없음·팩 §3.10 "코팅포함 통가격" 정합) — 마감 스펙 선택일 뿐. 상세=[[product-120-waterproof-poster-nodes]].
  - 팩 §3.10은 면적매트릭스를 "코팅 무관·코팅포함 통가격"으로 서술 — 라이브는 코팅을 **스펙 옵션**으로 노출
    하되 가격은 통가격(정합). 비종이류라 has_plate_size·has_print_option은 없음.
- **제약규칙:** 라이브 `t_prd_product_constraints` = **RULE_001 1행**(사용자입력 치수 범위·RULE_TYPE.01·
  가로 200~1200·세로 200~3000). CN-5(범위증분) 유형·폼빌더 정형 shape(JSONLogic or/and·[[constraint-120-dimrange]]).
  ★위키 "실사 constraints 전부 0행"은 **STALE**(7상품 1행씩 신규 발현·120 포함·팩 §1.1 T-3). 상세=[[product-120-waterproof-poster-nodes]].
- **추가상품:** `t_prd_product_addons` = 120 행 **없음**(addon 미연결). 방수포스터는 부속 없는 단품
  (부속붙는 8상품=133~137·131/132·138/139는 별건·팩 §3.12). GAP 아님(설계상 부속 없음).

## 승계·freshness 메모
- 정체·소재 13군·면적/고정 분기 의미는 팩 §3.1/§3.10(FRESH·INHERIT) 승계. 방수포스터=면적매트릭스 B03 확증.
- ★결함 상태값은 팩 §1.1·§4로 재조준(위키 🔴 그대로 옮기면 T-6 오염): 카테고리 고아(해소·CAT_000298 삭제)·
  레더 .08(120 무관·120 자재=PET)·constraints 0행(→ 120은 1행 발현)·판형(비종이류 없음)을 전부 라이브 실측.
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(팩 §4·§5-5)이라 권위 충돌
  미발견(현재값=정답 판정). 단 A1 사이즈 master 삭제만 양면 표기(junction 활성 vs master del).
- **범위 밖 거절:** 주문·배송·회원·쿠폰 질의는 KB 범위 밖([[rule/rules#RULE_scope_boundary]]·팩 §5-7).
