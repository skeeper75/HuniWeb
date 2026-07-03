---
id: product-118-artprint-poster
type: product
anchor: t_prd_products/PRD_000118
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000118(prd_nm=아트프린트포스터·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B01 아트프린트118↔COMP_POSTER_ARTPRINT_PHOTO(면적매트릭스 13상품 중 1)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.1·§3.10·§3.11 실사 정체·면적매트릭스형(승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(cat_lvl=1 root·main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000314, note: "아트포스터(cat_lvl=2·upr=CAT_000004·06-19 신규노드)"}
  - {rel: has_size, target: size-SIZ_000315, note: "A3 규격(del_yn=N·07-01 재키잉)"}
  - {rel: has_size, target: size-SIZ_000198, note: "A2 규격(del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000294, note: "A1 규격(del_yn=N)"}
  - {rel: uses_material, target: material-MAT_000176, note: "인화지(부모·USAGE.07·dflt_yn=Y)"}
  - {rel: uses_material, target: material-MAT_000599, note: "인화지(자식·USAGE.07·06-30 신설·소재옵션 참조대상)"}
  - {rel: has_process, target: process-PROC_000115, note: "유광코팅(선택·코팅옵션 참조대상)"}
  - {rel: has_process, target: process-PROC_000116, note: "무광코팅(선택·코팅옵션 참조대상)"}
  - {rel: has_qty_rule, target: qty-118, note: "제품레벨 min1/max1000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ARTPRINT, note: "완제품가 면적매트릭스형(포스터사인 가로×세로 셀단가)"}
  - {rel: has_option_group, target: optgroup-118-coating, note: "코팅 택1(없음/무광/유광)"}
  - {rel: has_option_group, target: optgroup-118-material, note: "소재 택1(인화지)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  nonspec_yn: Y
  nonspec_range_ref: "전사표(transcribe_product_118.py) — 가로/세로 raw 수치 손전사 아님"
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1
  max_qty: 1000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "면적매트릭스형(area-matrix·use_dims=[siz_width,siz_height,min_qty])"
standards: {schema_org: Product, xjdf: "Product(포스터/Poster·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아트프린트포스터 가격 경로)", "조건 탐색(포스터 소재·규격·코팅)"]
tags: ["#실사", "#포스터", "#아트프린트포스터", "#면적매트릭스", "#비종이류"]
updated: 2026-07-03
---

# product-118 아트프린트포스터 (PRD_000118)

아트프린트포스터는 **실사(대형 실사 출력물)** 카테고리의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)
상품이다. 손님이 **규격(A3/A2/A1) 또는 사용자입력 치수**와 **소재(인화지)·코팅**을 고르면,
포스터사인 **[가로×세로] 면적매트릭스**에서 **완제품 통가격(코팅 포함가)** 을 조회한다. 파일 업로드
방식(`file_upload_yn=Y`, 에디터 미사용). 수치(치수·매트릭스 SHAPE)는
[[product-118-artprint-poster-nodes]] 전사표가 권위(스크립트 전사·손전사 금지·D-9).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 아트프린트포스터는 `t_prd_product_sets`
  부모 등록이 없어(라이브 실측 — sets 0행) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 상품군 = **실사**(카테고리 004 포스터). 굿즈/포장재 아님(정체 오분류 위험 없음).
- 카테고리: 포스터 `CAT_000004`(root·[[product-118-artprint-poster-nodes]]) + 아트포스터
  `CAT_000314`(leaf). ★[REVERIFY→해소] round-13 "실사 28상품 전부 CAT_000298 고아"는 **STALE** —
  `CAT_000298`은 `del_yn=Y` 논리삭제(06-18)됐고 118은 정상 카테고리 노드로 재연결됨(pack §1.1·§4
  T-1). 현재 상태=정상연결(defect 아님·양면 불요).

## 차원
- **사이즈:** 규격 3행(A3 `SIZ_000315` / A2 `SIZ_000198` / A1 `SIZ_000294`·전부 del_yn=N) **+
  비규격 연속범위**(nonspec_yn=Y·가로 200~1200mm·세로 200~3000mm·전사표). ★**비규격 범위는 입력
  UX 한계일 뿐 가격격자가 아니다**(pack §3.2) — 유효 가격 권위 = 면적매트릭스 셀(§가격 경로).
  07-01에 A3/A2/A1가 재키잉되어 구 코드(SIZ_000174/197/293)는 상품에서 논리삭제됨(전사표).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 118 행 **없음**. 실사는 **대형 잉크젯
  풀컬러**라 도수(칼라/흑백) 컬럼 자체가 없다 — 결함이 아니라 **설계상 해당 없음**(pack §3.3·
  [[rule/rules#RULE_dosu_is_printopt]] 프레임 밖).
- **수량규칙:** 제품 레벨 수량규칙(전사표 min/max/incr·QTY_UNIT.01). `t_prd_product_bundle_qtys`에
  118 행 **없음**(제품 레벨 규칙만). ★면적매트릭스형이라 **수량축이 가격 차원이 아니다** — 매트릭스
  52셀 전부 min_qty NULL(수량무관 통가격·전사표 수량축충전=False). 셀 단가는 포스터 1장가이며
  총액=셀단가×수량(수량구간 할인 없음). 수량 UI 권위=제품 수량규칙(가격구간과 역할 분리·pack §3.4).

## 자재·공정
- **자재:** **인화지 단일 소재계열**(낱장 완제품·내지/표지 없음·pack §3.5). 부모 `MAT_000176` +
  자식 `MAT_000599`(06-30 신설·소재옵션 참조), 둘 다 `MAT_TYPE.08 실사소재`·USAGE.07 단일 슬롯.
  ★118 자재는 **인화지(.08 정당)** 이며, 실사 팩이 경고한 **레더 `MAT_000186` .08→.05 교정 crosscut과
  무관**(pack §1.1·§3.5·T-2 — 레더는 100/126/296/298 횡단이고 118은 아님). 인화지 .08 = 현재값이자
  정답(양면 불요). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 코팅 2종(유광 `PROC_000115` / 무광 `PROC_000116`·둘 다 상위 PROC_000114·del_yn=N).
  ★07-01 **재키잉**: 구 라미네이팅 공정(유광 PROC_000014·무광 PROC_000015·상위 PROC_000013)이
  상품에서 `del_yn=Y` 논리삭제되고 코팅 공정으로 교체됨(전사표). 코팅은 **면적매트릭스 통가격에 포함**
  (COMP는 "코팅포함가"·pack §3.10)이라 별도 코팅비 원자합산이 아니라 소재/사이즈별 셀단가에 녹아 있다.
  실사 대형 잉크젯 인쇄방식 공정(PROC_000006)은 라이브에 118 행이 없다(실사 공통·po=0·설계상 정당·pack §3.7).

## 판형 (★비종이류 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 118에 3행(SIZ_000052/198/294) 있으나 `output_paper_typ_cd`가
  **전부 공란**이고 용도가 "파일사양"(output_file_typ=JPG)이다 — 판걸이수 산정용 출력용지 판형이 아니라
  **파일 규격 플레이스홀더**다. ★실사는 **대형 롤 출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션
  없음) → 판형(`fn_best_plate`)·판걸이수(`fn_calc_pansu`·t_siz_pansu)는 **종이류 전용 로직이므로 실사에
  적용 금지**(pack §3.8·T-7·[[rule/rules#RULE_plate_paper_only]]·[[harness-domain-rules-12-260701]]).
  그래서 `has_plate_size` 관계를 걸지 않는다(정직 표기·환각 방지·050 봉투제작 선례 동형).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-118 --priced_by--> formula-PRF_POSTER_ARTPRINT --has_component--> component-COMP_POSTER_ARTPRINT_PHOTO`.
  **가격 경로 연결됨(고아 공식·미배선 아님)** — 공식이 완제품가 구성요소 1건을 배선한다.
- **면적매트릭스형** = 원자합산형(디지털 인쇄+용지+공정 합산)·고정룩업형(스티커 siz_cd 룩업)과 **다른
  아키타입**. 단일 구성요소 `COMP_POSTER_ARTPRINT_PHOTO`를 use_dims 3축(**가로 siz_width × 세로
  siz_height × 수량 min_qty**)으로 조회한다. 매트릭스=**가로 4구간 × 세로 13구간 = 52셀 완전격자**
  (grid_full=True·전사표). off-grid=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행·pack §3.10).
- ★**동형결합 구성요소:** `COMP_POSTER_ARTPRINT_PHOTO`는 [동형결합]으로 **가격표 동일 4소재**
  (아트프린트118·방수120·접착방수121·아트패브릭123)를 통합한다(comp note·mapping.md §1.2). 즉 이
  구성요소는 118 전용이 아니라 실사 4포스터 공유 축(→ needed_shared_nodes·향후 silsa formula/component
  파일 승격 후보). 공식 `PRF_POSTER_ARTPRINT`는 118 바인딩 전용.
- 값(unit_price)은 기록하지 않는다(연결·격자완전성·차원까지·값=evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹 2:** 코팅(`OPT_000005`·SEL_TYPE.01·min0/max1·mand_yn=Y — 코팅없음/무광→PROC_000116/
  유광→PROC_000115) + 소재(`OPT-000043`·SEL_TYPE.01·min1/max1·mand_yn=Y — 인화지→MAT_000599).
  코팅옵션 item은 공정(OPT_REF_DIM.04)을, 소재옵션 item은 자재(OPT_REF_DIM.03)를 가리켜 선택이
  각각 has_process·uses_material 차원으로 환원된다(R11 option_refs·L-18 부모정합 통과). 상세 =
  [[product-118-artprint-poster-nodes]].
- **제약규칙:** `t_prd_product_constraints` = 118에 **1행**(RULE_001 사용자입력 치수 범위·RULE_TYPE.01).
  비규격 입력 시 가로/세로가 제품 nonspec 범위(전사표) 안인지 검증(CN-5 범위형·§31). ★[REVERIFY]
  위키 "실사 constraints 전부 0행"은 **STALE**(118 포함 7상품 1행씩 신규 발현·pack §1.1·T-3). 현재값
  =정답(정당한 범위 제약·defect 아님·양면 불요). 상세=[[product-118-artprint-poster-nodes]].
- **추가상품:** `t_prd_product_addons`·`t_prd_product_sets` = 118 행 **없음**. 118은 부속붙는 상품이
  아니다(부속 8상품=133~137·131/132·138/139·pack §3.12). addon 미연결이 결함 아님(설계상 해당 없음).

## 승계·freshness 메모
- 정체·소재계열·면적매트릭스 분기는 pack §3.1·§3.10·§3.11(FRESH·INHERIT) + mapping.md §1.2 승계·재검증.
- ★위키 🔴 결함 재조준(pack §4·T-6 오염 회피): 카테고리 고아(SL-DEF-001)·constraints 0행(SL-CPQ-003)은
  **라이브 COMMIT으로 이미 해소** — 118은 정상 카테고리 연결 + 제약 1행. round-13/위키를 그대로 옮기면
  오염이라 live-snapshot 20260702_1119 실측으로 재판정(현재값=정답).
- 좌표 회귀·round-2 sparse 대표셀(T-4·T-5) 인용 안 함 — 명시 매트릭스 52셀 완전격자만 승계(mapping.md §2).
- 라이브 현재값 = live-snapshot 20260702_1119. 실사 시트는 260702 diff 무영향(pack §5.5)이라 권위 충돌
  미발견(현재값=정답 판정). 롤 소재 가격 계산 로직은 엑셀 미기재 암묵지 GAP([[product-118-artprint-poster-nodes]]).
