---
id: product-145-mini-banner
type: product
anchor: t_prd_products/PRD_000145
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000145(prd_nm=미니배너·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 고정가형 15상품 중 미니배너145·§3.1(정체)·§3.4(고정가형=수량축 보유)·§3.8(비종이류 판형없음)(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_MINI_BANNER use_dims=[siz_cd,min_qty](고정가 규격×수량구간 룩업·면적매트릭스 아님)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000097, note: "POP(cat_lvl=2·부모 CAT_000005 사인·main_cat_yn(링크)=N·144 미니보드스탠딩과 공유 leaf·145가 companion mint)"}
  - {rel: has_size, target: size-SIZ_000028, note: "150x300mm 이산 규격(dflt_yn=Y·del_yn=N·impos_yn=N·145 전용 mint·마스터 note는 카드 잔재로 배너 무관)"}
  - {rel: has_size, target: size-SIZ_000328, note: "180x420mm 이산 규격(dflt_yn=Y·del_yn=N·impos_yn=N·145 전용 mint)"}
  - {rel: uses_material, target: material-MAT_000178, note: "PET(USAGE.07·dflt_yn=Y·★MAT_TYPE.08 실사소재 현재값·axis/materials.md canonical 재사용·039/120/135/136 횡단)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(부모 PROC_000013·mand_proc_yn=N·코팅 옵션 유광이 참조·axis/processes 재사용)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(부모 PROC_000013·mand_proc_yn=N·코팅 옵션 무광 dflt이 참조·axis/processes 재사용)"}
  - {rel: has_qty_rule, target: qty-145, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)·bundle_qtys 0행"}
  - {rel: has_option_group, target: optgroup-145-coating, note: "코팅(무광 dflt/유광·택1·mand N)→process-PROC_000015/014·통가격 포함(별도 가산 없음)"}
  - {rel: priced_by, target: formula-PRF_POSTER_MINI_BANNER, note: "완제품가 고정가 룩업형(규격×수량구간 셀단가·다-tier 수량할인·면적매트릭스 아님)"}
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
  archetype: "고정가 룩업형(fixed·use_dims=[siz_cd,min_qty]·규격2×수량구간5 셀단가·다-tier 수량할인·면적매트릭스 아님)"
standards: {schema_org: Product, xjdf: "Product(배너/Banner·LayoutIntent FinishedDimensions·라미네이팅 후가공)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(미니배너 가격 경로)", "조건 탐색(배너 소재·규격·코팅)"]
tags: ["#실사", "#배너", "#미니배너", "#고정가룩업", "#비종이류", "#POP"]
updated: 2026-07-03
---

# product-145 미니배너 (PRD_000145)

미니배너는 **실사(대형 실사 출력물·사인 POP류)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(150×300 또는 180×420mm)** 을 고르고 **코팅(무광/유광)** 과 **수량**을 정하면,
`(사이즈 siz_cd × 수량구간 min_qty)` **고정가 룩업**에서 **완제품 통가격**(출력+코팅+**거치대** 포함가)을
조회한다. 파일 업로드 방식(`file_upload_yn=Y`·에디터 미사용·`nonspec_yn=N`이라 비규격 자유치수 없음).
**PET 소재** 대형 롤 출력이라 비종이류(판형 없음). 수치는 [[product-145-mini-banner-nodes]] 전사표가
권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 미니배너는 `t_prd_product_sets` 부모 등록이
  없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안). ★거치대(스탠드)가 통가격에 baked돼 있어(가격 note
  '[출력+코팅+거치대 포함가]') 137 메쉬배너의 배너거치대 addon/standoff와 달리 **부속 미연결이 결함이
  아니다**(addon/set 0행 정합·아래 자재/가격).
- 상품군 = **실사**(카테고리 005 사인 하위 097 POP). 사인 POP 배너류 완제품 — 굿즈/포장재 아님.
- 카테고리: POP `CAT_000097`(leaf·lvl2·부모 CAT_000005 사인·main_cat_yn(링크)=N). 145는 junction 1행
  (CAT_000097)만 연결·부모 CAT_000005는 카테고리 계층(upr_cat_cd)이지 상품 junction 링크 아님.
  ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** — `CAT_000298`은
  `del_yn=Y` 논리삭제(06-18)됐고 145는 CAT_000097(POP·사인 하위)로 정상 재연결됨(pack §1.1·§4 T-1).
  현재 상태=정상연결(defect 아님·양면 불요). CAT_000097은 144 미니보드스탠딩과 공유하는 leaf인데 def
  block이 KB에 미존재라 **145가 companion mint(canonical·needed_shared)** — 144의 in_category 참조도
  이 정의로 해소.

## 차원
- **사이즈:** 이산 **2 규격**(150×300 `SIZ_000028`·180×420 `SIZ_000328`·둘 다 dflt_yn=Y·impos_yn=N·
  del_yn=N). `nonspec_yn=N`이라 **비규격 연속범위가 없다**(118/126의 사용자입력 치수 UX와 차이·pack
  §3.2 부수). ★SIZ_000028 마스터 note("판걸이=3.0 / 전지=316x467 / 적용=3단접지카드")는 공유 마스터
  사이즈의 **카드 잔재** — 비종이류 배너(145)엔 무관(판형 del·판걸이 로직 미적용·T-7). 두 사이즈 노드는
  KB 미존재라 **145 전용 mint**(아래 nodes).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 145 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min1/max10000/incr1·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  145 행 **없음**(제품 레벨 규칙만). ★137과 달리 145는 구성요소 use_dims 수량구간(min_qty)이 **다-tier**
  (4/19/49/99/10000)라 실제 **수량할인 격자**가 있다(단가 6500→2800 감소). 다만 격자 최저 tier=min_qty 4로
  **상품 min_qty=1과 불일치** — 수량 1~3의 가격 tier가 없어 [[product-145-mini-banner-nodes#gap-145-qtytier-floor]]로
  정직 선언(수량 UI 권위=상품 수량규칙·가격구간과 역할 분리·pack §3.4·
  [[rule/decisions#DEC_qty_audit_260702]]).

## 자재·공정
- **자재:** **PET 단일 소재**(낱장 완제품·내지/표지 없음·pack §3.5) — `MAT_000178`(PET·upr_mat_cd
  공백·USAGE.07·dflt_yn=Y). ★자재유형이 현재 **`MAT_TYPE.08 실사소재`**(pack §3.5 PET=실사소재·현재값).
  material-MAT_000178 노드는 **axis/materials.md가 canonical 정의**(039 투명명함/120 방수포스터/135
  족자포스터/136 PET배너 횡단 공유 축)이므로 145는 **재사용만**(재정의 안 함·L-3). PET는 pack §3.5
  실사소재 목록에 있고 §1.1 자재유형 교정 리스트(레더 .08→.05 등)에 개별 지목이 없어, .08은 "현재값이자
  실사소재 정합"으로 두고 양면(defect) 선언하지 않는다(false-defect 방지·형제 122 투명PVC .08 판단 동형).
  ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** **유광라미네이팅 `PROC_000014`·무광라미네이팅 `PROC_000015`**(부모 `PROC_000013`
  라미네이팅)·둘 다 `mand_proc_yn=N`. 코팅 CPQ 옵션(OPT_000024)이 이 두 공정을 택1 참조
  (option_refs·OPT_REF_DIM.04). process-PROC_000014/015는 **axis/processes.md canonical 재사용**
  (재정의 안 함). 코팅은 **생산 마감 선택**이지 별도 가격 component 배선이 없다 — 통가격
  ('[출력+코팅+거치대 포함가]')에 포함(공식 단일 구성요소).
- **판형(plate_size):** ★**없음(비종이류)**. 라이브 plate 2행(SIZ_000028·SIZ_000328) 전부 `del_yn=Y`
  (06-30 정리)·`output_paper_typ` 공백(파일사양 placeholder). 실사=대형 롤 출력이라 절수 기반 전지·
  판걸이수가 무의미(`has_plate_size` 엣지 0=정상·pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]).

## 가격 경로 (연결·차원까지·값=엔진)
- **priced_by → `PRF_POSTER_MINI_BANNER`**(고정가 룩업형·use_yn=Y) **→ has_component →
  `COMP_POSTER_MINI_BANNER`**(단일 구성요소·use_dims=`[siz_cd, min_qty]`). 상품→공식→구성요소 사슬
  **연결됨**(O5/O6 충족·견적 0 위험 없음·격자완전 10/10). 상세=[[product-145-mini-banner-nodes]] formula/
  component 블록.
- **가격모델 = 고정가 룩업형**(pack §3.10 고정가 15상품). 라이브 격자 = **규격 2 × 수량구간 5 = 10셀
  전부 실재**(격자완전). ★118~128 **면적매트릭스형**([가로×세로] `[siz_width, siz_height]`)과 **다른
  아키타입** — 145는 등록 규격 `siz_cd` 키 + 수량구간 `min_qty` 룩업(면적 좌표 아님). "실사=전부
  면적매트릭스" 일괄 금지(round-2 오모델 재발·pack T-5·§3.10).
- **★가격 값 경계(D-18):** 온톨로지는 use_dims 차원 선언·배선까지만. 개별 셀단가·계산은 `evaluate_price`
  단일 권위(값 노드 미기록·[[rule/rules#RULE_price_value_boundary]]). 단가는 인쇄상품 가격표 260527
  verbatim(comp note). 통가격 산정 규칙(롤 소재)은 문서 부재=[[product-145-mini-banner-nodes#gap-145-fixedprice-basis]].

## 옵션·제약
- **CPQ 옵션 1그룹:** 코팅(OPT_000024·택1·mand N·min0/max1) — 무광코팅(OPV_000046·dflt)→PROC_000015·
  유광코팅(OPV_000047)→PROC_000014. option_refs 타깃(공정 2)이 145 has_process에 실재(L-18 부모정합
  통과). 상세=[[product-145-mini-banner-nodes#optgroup-145-coating]].
- **제약규칙:** `t_prd_product_constraints` = 145 행 **0**. pack §1.1 constraints 신규발현 7상품
  (118/120/121/122/124/125/139)에 **145 미포함**이라 0행이 정합(nonspec_yn=N이라 치수범위 제약 불필요·
  false-defect 아님).
- **추가상품/셋트:** addon/set 0행. ★거치대가 통가격 baked라 별도 부속 불요(137 standoff BLOCKED과
  대비) — 145는 부속 미연결이 결함이 아니다(pack §3.12 부속붙는 8상품에 145 미포함).

## 결함 재조준 (위키 round-13 → 현재값·pack §4)
- **SL-DEF-001 카테고리 고아 → 해소.** CAT_000298 `del_yn=Y`(06-18)·145는 CAT_000097 정상 junction(T-1).
- **SL-DEF-005 부속 addon/set 0행 → 145는 N/A.** 145는 부속붙는 8상품이 아니고 거치대 통가격 baked라
  0행이 정합(잔존 결함 아님).
- **SL-CPQ-003 constraints → 145는 N/A.** 신규발현 7상품에 145 미포함(0행 정합).
- **★양면(defect) 0:** 실사 시트 260702 무영향(pack §5.5)이라 소재 코드값 불변(false-defect 방지). PET
  .08은 실사소재 현재값 정합·카테고리/부속/제약 전부 현재값=정답. 유일한 미해결은 GAP 2(수량 tier floor·
  롤 소재 산정 근거)로 정직 선언.

> 상세 하위 노드(카테고리·사이즈 2·수량규칙·코팅 옵션그룹·가격공식·구성요소·GAP 2)와 전 축 스크립트
> 전사표는 [[product-145-mini-banner-nodes]]. 공유 축(material-MAT_000178·process-PROC_000014/015)은
> 재사용만(재정의 안 함·needed_shared).
