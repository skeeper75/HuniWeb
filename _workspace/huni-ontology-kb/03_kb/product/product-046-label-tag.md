---
id: product-046-label-tag
type: product
anchor: t_prd_products/PRD_000046
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000046", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md", source_locator: "문서:C-12 라벨택 046=사이즈 3행 CORRECT", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000327, note: "인쇄포장재 — main_cat_yn=N(부카테고리)"}
  - {rel: has_size, target: size-SIZ_000047, note: "40x80 (완칼 재단)"}
  - {rel: has_size, target: size-SIZ_000011, note: "50x50"}
  - {rel: has_size, target: size-SIZ_000048, note: "25x110"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g·USAGE.07 단일 슬롯"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(칼라)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(칼라)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base·mand_proc_yn=Y(07-01 18건 COMMIT분)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지 SIZ_000499·종이류라 판형 유효·fn_best_plate 자동선택"}
  - {rel: priced_by, target: formula-PRF_DGP_B, note: "원자합산형B(인쇄+용지+완칼)"}
  - {rel: has_option_group, target: optgroup-046-cutting-shape, note: "커팅모양 3택(나뭇잎/별타공/리니니)"}
props:
  prd_typ_cd: PRD_TYPE.01
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 20
  max_qty: 1000
  qty_incr: 20
  qty_unit_typ_cd: QTY_UNIT.02
  del_yn: N
  qty_src: "전사표(transcribe_046.py) — raw 수치 손전사 아님"
standards: {schema_org: Product, xjdf: "Product(라벨/택)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(라벨택 가격 경로)", "조건 탐색(완칼 모양 라벨)"]
tags: ["#디지털인쇄", "#라벨택", "#완칼", "#포장"]
updated: 2026-07-03
---

# product-046 라벨/택 (PRD_000046)

라벨/택은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`)이다. 몽블랑 240g 낱장 용지에
칼라 단/양면 인쇄 후 **완칼(die-cut)** 로 모양대로 잘라내는 상품군(카테고리 = 인쇄포장재
`CAT_000327`). 파일 업로드 방식(`file_upload_yn=Y`, 에디터 미사용). 최소 20매·최대 1,000매·
20매 증분(단위 QTY_UNIT.02 "매"). 수량 raw 값은 [[product-046-label-tag-nodes]] 전사표가
권위(스크립트 전사·손전사 금지).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 라벨/택은 `t_prd_product_sets` 부모
  등록이 없어 셋트 완제품이 아니라 일반 단일 완제품(SOT 정합·[[rule/rules#RULE_scope_boundary]] 범위 안).
- 구분 그룹 = "라벨택"(디지털인쇄 7구분 중 하나·팩 §3.1). 배경지(043~045)와 함께 카테고리
  012 포장 계열이나, 라벨택은 **포장 단품**(세트 아님).

## 차원
- **사이즈:** 3행(40x80·50x50·25x110) — 이산 사이즈 행(면적매트릭스 아님·팩 §3.2 C-12).
  치수·판걸이수 전사표 = [[product-046-label-tag-nodes]]. 사이즈별 판걸이수(24/35/24)는
  **사이즈의 파생값**(`fn_calc_pansu` t_siz_pansu lookup·[[rule/rules#RULE_pansu_db_function]]).
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001 / 양면 POPT_000002). 도수는 색상코드가
  아니다([[rule/rules#RULE_dosu_is_printopt]]). 라이브 front/back 색상수 코드 = CLR_000005(4도)
  기반(단면 back=CLR_000001).
- **수량규칙:** 제품 레벨 min 20 / max 1,000 / incr 20(QTY_UNIT.02). `t_prd_product_bundle_qtys`
  에는 046 행이 **없음**(제품 레벨 규칙만·per-size 수량규칙 미설정). 수량 UI 권위 = 제품/사이즈
  수량규칙(가격구간과 역할 분리·팩 §3.4).

## 자재·공정
- **자재:** 몽블랑 240g(`MAT_000109`, 상위 MAT_000103, MAT_TYPE.01, 316x467) 단일 본문 —
  parent + usage_cd 단일 슬롯(USAGE.07 default·정당·팩 §3.5). 상세 = [[product-046-label-tag-nodes]].
- **공정:** 라이브 `t_prd_product_processes` = **PROC_000004(디지털인쇄 base) mand 1행**뿐
  (07-01 base 공정 18건 COMMIT분에 046 포함·[[rule/decisions#DEC_baseproc_260701]]). base 공정
  미바인딩이면 인쇄비 영구 0이 되는 결함을 교정한 이력([[rule/rules#RULE_dataline_neq_wiring]]).
  **완칼 커팅은 공정행이 아니라 가격공식 구성요소**(COMP_CUT_FULL_DIECUT)로 표현된다(모델링 주의).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-046 --priced_by--> formula-PRF_DGP_B --has_component--> {COMP_PRINT_DIGITAL_S1(인쇄),
  COMP_PAPER(용지), COMP_CUT_FULL_DIECUT(완칼)}`. 배선 사슬은 공유 공식 노드
  [[formula/digital-formulas]] · 구성요소 [[formula/digital-components]]에 이미 등재(재사용).
- 원자합산형B = [디지털출력] + [용지비] + [완칼 커팅비]. **판걸이수는 DB 함수 계산**(앱 아님).
- 완칼 단가는 단가형×판수 이중적용 과대청구를 `.01→.03` 고정으로 교정한 이력
  ([[rule/decisions#DEC_diecut_260701]]·046 1,350,000→50,000). 단, **절대값 골든은 pcode 미상으로
  미검증** — [[gap-046-diecut-golden]]로 정직 선언(지어내지 않음).

## 옵션·제약
- **옵션그룹:** 커팅모양(`OPT-000010`, SEL_TYPE.01·mand_yn=N) — 나뭇잎/별타공/리니니 3택.
  상세 = [[product-046-label-tag-nodes]]. 이 옵션 item에는 `ref_dim_cd` 다형참조가 없어
  (option_items 0행) 실물 차원(자재/사이즈)을 가리키지 않는다 → **가격 비영향**(생산·시각 선택).
- **제약규칙:** 라이브 `t_prd_product_constraints` = 046 행 **없음**(제약 미등록). 완칼 모양×사이즈
  물리제약 필요 여부는 미확정(§31 제약 하네스 소관·현재 GAP 아님·데모 미착수).
- **추가상품:** `t_prd_product_addons` = 046 행 **없음**(봉투 등 addon 미연결).

## 승계·freshness 메모
- 정체·사이즈 3행 = 팩 §3.1/§3.2(C-12) FRESH 승계. "엽서 13종"류 STALE(T-2)는 046 무관.
- base 공정·완칼 교정은 위키에 없던 7월 신사실 — §4-A/§4-B 원장으로 재조준(T-6 오염 회피).
