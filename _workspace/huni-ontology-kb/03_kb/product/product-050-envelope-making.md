---
id: product-050-envelope-making
type: product
anchor: t_prd_products/PRD_000050
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000050", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "문서:§1 인쇄홍보물 PRD_000050 봉투제작 = PRF_ENV_MAKING(봉투제작형)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(main_cat_yn=Y·공유 축 실재)"}
  - {rel: in_category, target: category-CAT_000065, note: "봉투/홀더 외(부카테고리·main_cat_yn=N·companion)"}
  - {rel: has_size, target: size-SIZ_000191, note: "티켓봉투 225x193"}
  - {rel: has_size, target: size-SIZ_000192, note: "소봉투 238x262"}
  - {rel: has_size, target: size-SIZ_000193, note: "자켓봉투 262x238"}
  - {rel: has_size, target: size-SIZ_000194, note: "대봉투 510x387"}
  - {rel: uses_material, target: material-MAT_000159, note: "모조 120g·USAGE.07·dflt_yn=Y"}
  - {rel: uses_material, target: material-MAT_000168, note: "레자크체크백색 110g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000169, note: "레자크줄무늬백색 110g·USAGE.07(단가=레자크체크 동일)"}
  - {rel: priced_by, target: formula-PRF_ENV_MAKING, note: "완제품가 매트릭스형(봉투종류×소재×수량)"}
  - {rel: has_option_group, target: optgroup-050-envelope-type, note: "봉투옵션 4택(OPT-000014)→사이즈 환원"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 1000
  max_qty: 5000
  qty_incr: 1000
  qty_unit_typ_cd: QTY_UNIT.02
  use_yn: Y
  del_yn: N
  qty_src: "전사표(transcribe_product_050.py) — raw 수치 손전사 아님"
standards: {schema_org: Product, xjdf: "Product(봉투/Envelope)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(봉투제작 가격 경로)", "조건 탐색(봉투 종류·소재별 제작)"]
tags: ["#디지털인쇄", "#봉투제작", "#인쇄홍보물", "#완제품가매트릭스"]
updated: 2026-07-03
---

# product-050 봉투제작 (PRD_000050)

봉투제작은 인쇄홍보물 구분의 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`) 상품이다. 손님이 봉투
**종류**(티켓/자켓/소/대봉투)와 **소재**(모조 120g·레자크체크·레자크줄무늬)를 고르면, (봉투종류×
소재×주문수량) 표에서 **완제품가(용지 포함)** 를 조회한다. 파일 업로드 방식(`file_upload_yn=Y`,
에디터 미사용). 최소 1,000매·최대 5,000매·1,000매 증분(단위 QTY_UNIT.02). 수량·치수·자재 raw 값은
[[product-050-envelope-making-nodes]] 전사표가 권위(스크립트 전사·손전사 금지).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 봉투제작은 `t_prd_product_sets` 부모
  등록이 없어(라이브 실측 — sets 미등재) 셋트 완제품이 아니라 **일반 단일 완제품**(SOT 정합·
  [[rule/rules#RULE_scope_boundary]] 범위 안).
- 구분 그룹 = "인쇄홍보물"(디지털인쇄 7구분 중 하나·워크리스트 §1·5상품 047~051 중 050).
- 카테고리: 주 = 인쇄홍보물 `CAT_000003`(main_cat_yn=Y·[[axis/categories#category-CAT_000003]]) +
  부 = 봉투/홀더 외 `CAT_000065`([[product-050-envelope-making-nodes]] companion·승격 대기).

## 차원
- **사이즈:** 4행 = 봉투 **종류**가 곧 사이즈(티켓 225x193 / 소 238x262 / 자켓 262x238 /
  대 510x387). 이산 사이즈 행(면적매트릭스 아님). **조판(impos_yn)=N** — 낱장 조판 인쇄가 아니라
  봉투 완제품 제작이라 작업치수만 있고 재단·판걸이수 개념이 없다(전사표 = [[product-050-envelope-making-nodes]]).
- **도수(인쇄옵션):** 라이브 `t_prd_product_print_options` = 050 행 **없음**(도수 선택 없음).
  봉투제작은 완제품가에 인쇄가 포함된 제작 상품이라 손님이 도수를 별도 고르지 않는다 —
  결함이 아니라 **설계상 해당 없음**(도수=print_opt_cd 프레임·[[rule/rules#RULE_dosu_is_printopt]]).
- **수량규칙:** 제품 레벨 min 1,000 / max 5,000 / incr 1,000(QTY_UNIT.02). `t_prd_product_bundle_qtys`
  에 050 행 **없음**(제품 레벨 규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·
  팩 §3.4). ★가격 매트릭스의 수량구간(1000/2000/3000/4000/5000)은 이와 별개의 **가격 차원**이다.

## 자재·공정
- **자재:** 3종 병렬(모조 120g `MAT_000159` / 레자크체크백색 `MAT_000168` / 레자크줄무늬백색
  `MAT_000169`) — 전부 USAGE.07 단일 슬롯(팩 §3.5). 레자크체크·줄무늬는 단가 동일(라이브 note
  "레자크체크=줄무늬 동일단가"). 상세 = [[product-050-envelope-making-nodes]].
  ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = 050 행 **없음**. 다른 디지털 상품의 "PROC_000004
  base 미바인딩=인쇄비 0" 결함([[rule/decisions#DEC_baseproc_260701]])과 **다르다** — 봉투제작은
  원자합산형이 아니라 **완제품가 매트릭스형**이라 인쇄·제작이 완제품가 구성요소(COMP_ENV_MAKING)에
  포함된다. 공정 미바인딩이 정상(설계상 해당 없음)이며 인쇄비 0 결함이 아니다(모델링 주의).

## 판형 (종이류 규칙 — 해당 없음)
- 라이브 `t_prd_product_plate_sizes` = 050에 4행 있으나 `output_paper_typ_cd`가 **전부 공란**이고
  용도가 "파일사양"(output_file_typ=AI)이다 — 판걸이수 산정용 출력용지 판형이 아니라 **파일 규격
  플레이스홀더**다. 봉투제작은 낱장 조판 인쇄가 아닌 완제품 제작이라 판형(plate_size)·판걸이수가
  **해당 없음**([[rule/rules#RULE_plate_paper_only]] 종이류만 판형). 그래서 `has_plate_size` 관계를
  걸지 않는다(정직 표기·환각 방지).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-050 --priced_by--> formula-PRF_ENV_MAKING --has_component--> component-COMP_ENV_MAKING`.
  **가격 경로 연결됨(고아 공식 아님)** — 공식이 완제품가 구성요소 1건을 배선한다.
- **완제품가 매트릭스형** = 원자합산형(인쇄+용지+공정 합산)과 다른 아키타입. 단일 구성요소
  `COMP_ENV_MAKING`(용지 포함 완제품가)를 use_dims 3축(**봉투종류 siz_cd × 소재 mat_cd ×
  주문수량 min_qty**)으로 조회한다. 공식·구성요소 노드 = [[product-050-envelope-making-nodes]]
  (formula/component 축 승격 대기).
- **격자완전:** 단가행 60개 = 4 사이즈 × 3 자재 × 5 수량구간이 이 빠짐 없이 채워짐(grid_full=True·
  매트릭스 전사표). 어떤 (종류·소재·수량) 조합도 단가 조회 가능 → **견적 0/미적재 셀 위험 없음**.
  가격 값은 기록하지 않는다(연결·격자완전성까지·값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹:** 봉투옵션(`OPT-000014`, SEL_TYPE.01·mand_yn=N) — 티켓/자켓/소/대봉투 4택. 4 item이
  각각 사이즈를 가리켜(R11 option_refs·OPT_REF_DIM.01) 선택이 **가격 매트릭스의 siz_cd 축으로 환원**
  된다(가격 사슬 참여). 상세 = [[product-050-envelope-making-nodes]].
  - ★라이브에 빈 옵션그룹 4개(OPT-000013/15/16/17·봉투제작/소/자켓/대봉투 이름)가 있으나 연결 옵션
    0건인 스캐폴딩이라 노드로 등재하지 않음(companion 하단 정직 기록·정리는 §12 소관).
- **제약규칙:** 라이브 `t_prd_product_constraints` = 050 행 **없음**(제약 미등록). 봉투종류×소재 조합이
  전부 단가행에 실재(격자완전)라 물리불가 제약 필요성 낮음 — 현재 GAP 아님(§31 제약 하네스 소관).
- **추가상품:** `t_prd_product_addons` = 050 행 **없음**(addon 미연결).

## 승계·freshness 메모
- 정체·구분·prd_cd·개수는 워크리스트 §1(FRESH·INHERIT) 승계. 봉투제작=PRF_ENV_MAKING 힌트 확증.
- 공정·판형 "해당 없음"은 위키 원자합산 서술(디지털 공통)을 그대로 옮기면 오적용 — 봉투제작은
  완제품가 매트릭스형이라 §4 base-proc/판걸이수 교정 대상이 아님을 라이브 실측으로 확인(T-6 오염 회피).
- 라이브 현재값 = live-snapshot 20260702_1119. 권위(260702 엑셀) diff에 봉투제작 셀 변경 있으면
  양면 표기 필요 — 이 노드는 라이브 실측 기준이며 별도 권위 충돌 미발견(현재값=정답 판정).
