---
id: product-029-trifold-card
type: product
anchor: t_prd_products/PRD_000029
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000029", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3 접지카드 축별 큐레이션·§0 36 distinct/7구분", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§1 접지카드 정체(round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000021}
  - {rel: has_size, target: size-SIZ_000523}
  - {rel: has_size, target: size-SIZ_000124}
  - {rel: has_size, target: size-SIZ_000004}
  - {rel: uses_material, target: material-MAT_000074}
  - {rel: uses_material, target: material-MAT_000081}
  - {rel: uses_material, target: material-MAT_000082}
  - {rel: uses_material, target: material-MAT_000091}
  - {rel: uses_material, target: material-MAT_000092}
  - {rel: uses_material, target: material-MAT_000101}
  - {rel: uses_material, target: material-MAT_000108}
  - {rel: uses_material, target: material-MAT_000109}
  - {rel: uses_material, target: material-MAT_000113}
  - {rel: uses_material, target: material-MAT_000114}
  - {rel: uses_material, target: material-MAT_000115}
  - {rel: uses_material, target: material-MAT_000116}
  - {rel: uses_material, target: material-MAT_000123}
  - {rel: uses_material, target: material-MAT_000125}
  - {rel: has_print_option, target: printopt-POPT_000002}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: Y, note: "디지털인쇄 base(mand_proc_yn=Y·disp_seq -1)"}}
  - {rel: has_process, target: process-PROC_000067, qualifier: {mand: N, note: "3단 가로접지 옵션"}}
  - {rel: has_process, target: process-PROC_000068, qualifier: {mand: N, note: "3단 세로접지 옵션"}}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: N, note: "가변텍스트 옵션"}}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: N, note: "가변이미지 옵션"}}
  - {rel: has_process, target: process-PROC_000037, qualifier: {mand: N, note: "박칼라 옵션(홀로그램)"}}
  - {rel: has_process, target: process-PROC_000038, qualifier: {mand: N, note: "박칼라 옵션(금유광)"}}
  - {rel: has_process, target: process-PROC_000039, qualifier: {mand: N, note: "박칼라 옵션(은유광)"}}
  - {rel: has_process, target: process-PROC_000040, qualifier: {mand: N, note: "박칼라 옵션(먹유광)"}}
  - {rel: has_process, target: process-PROC_000041, qualifier: {mand: N, note: "박칼라 옵션(동박)"}}
  - {rel: has_process, target: process-PROC_000042, qualifier: {mand: N, note: "박칼라 옵션(적박)"}}
  - {rel: has_process, target: process-PROC_000043, qualifier: {mand: N, note: "박칼라 옵션(청박)"}}
  - {rel: has_process, target: process-PROC_000044, qualifier: {mand: N, note: "박칼라 옵션(트윙클)"}}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01}
  - {rel: priced_by, target: formula-PRF_DGP_E}
  - {rel: priced_by, target: formula-PRF_DGP_E_FOIL, note: "박 선택 시 재바인딩(라이브 apply_bgn_ymd 2026-07-01)"}
  - {rel: has_option_group, target: optgroup-OPT_000034}
  - {rel: has_option_group, target: optgroup-OPT_000035}
  - {rel: has_option_group, target: optgroup-OPT_000036}
  - {rel: has_option_group, target: optgroup-OPT_000037}
  - {rel: has_option_group, target: optgroup-OPT_000038}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 8
  max_qty: 10000
  qty_incr: 8
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
standards: {schema_org: Product, xjdf: "Product(접지카드)·FoldingIntent(3-panel)", config_ont: "component type"}
updated: 2026-07-03
---

# product-029 · 3단접지카드 (PRD_000029)

디지털인쇄 **완제품 단일**(`PRD_TYPE.01`·[[product-type-classification-sot]] 정합·셋트 아님·
`t_prd_product_sets` 부모/구성원 미등록·라이브 실측 0행). 접지카드 구분 그룹(팩 §0 7구분 중 하나).
파일 업로드로 주문(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`). 형제 [[product-027-bifold-card]]
(2단접지카드)와 **동형**이며 접기 단수만 3단(3-panel)으로 다르다. 청첩·안내카드 용도가 많아
[[INTENT_wedding]]와 연관(약참조).

## 정체·수량

<!-- transcribed-by: _meta/scripts/transcribe_product_029.py from live-snapshot/latest (snap_20260702_1119) t_prd_products prd_cd=PRD_000029 @ 2026-07-03 -->
| 필드 | 값 |
|---|---|
| prd_nm | 3단접지카드 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 8 |
| max_qty | 10000 |
| qty_incr | 8 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | Y |
| del_yn | N |

- **수량 규칙:** 최소 8 · 최대 10000 · 증분 8 (단위 QTY_UNIT.02 "매"). 이 상품은
  `t_prd_product_bundle_qtys`·사이즈 수량규칙 행이 **라이브 0행**이라 수량 규칙 = **상품 스칼라**
  (min/max/incr)로만 표현된다(별도 `bundle_qty` 노드·`has_qty_rule` 엣지 없음 — 결함 아님·팩 §3.4
  "수량 UI 권위=상품/사이즈 규칙"의 상품레벨 케이스·형제 027과 동일).

## 차원 — 사이즈·도수

- **사이즈 3행**(전부 기존 노드 재사용·[[product-029-trifold-card-nodes]] 사이즈 절): SIZ_000523
  (100×150)·SIZ_000124(150×100)는 [[product-027-nodes]] 정의를 재사용, SIZ_000004(135×135)는
  공유 축 [[axis/sizes]] 정의를 재사용. **신규 사이즈 노드 없음**(중복 mint 금지·L-3).
  ★디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 접지 전개(펼침) 치수의 3단 기하는
  master(t_siz_sizes) 재단값이 권위이며 이 노드는 전사값만 기록한다(3단 폴딩 산식 날조 금지).
- **도수 = 인쇄옵션**([[rule/rules#RULE_dosu_is_printopt]]): [[printopt-POPT_000002]] 양면 전용
  (front/back CLR_000005·라이브 인쇄옵션 1행 opt_id=1). 색상코드가 아니다(T-4 함정 회피).

## 자재/공정 BOM

- **자재 14종**(전부 USAGE.07·낱장 단일 슬롯·전부 기존 노드 재사용): 공유 6종([[axis/materials]]
  MAT_000074/081/082/091/092/101) + 몽블랑/띤또레또 3종([[product-027-nodes]] MAT_000108/109/123)
  + 친환경·특수지 5종([[product-023-shaped-postcard-nodes]] MAT_000113 아코팩/114 리사이클러스/
  115 매쉬멜로우/116 린넨커버/125 한지). ★027의 자재가 "?"규격 미기재였던 데 비해 029는 동일
  계열을 **규격 316×467 기재된 정식 mat_cd(113~116/125)** 로 참조한다(전사표 근거). 기본 =
  백색모조지 220g([[material-MAT_000074]]). **신규 자재 노드 없음**(전부 재사용·L-3).
- **공정 13행**: base [[process-PROC_000004]](디지털인쇄·mand_proc_yn=Y·disp_seq -1) + **3단접지
  2종([[product-029-trifold-card-nodes]] PROC_000067 가로/PROC_000068 세로 — ★이 상품에서 신규 mint)**
  + 가변 2종([[axis/processes]] PROC_000031/032) + 박 8종([[product-027-nodes]] PROC_000037~044).
  ★별색·박·코팅은 도수 아닌 공정(팩 §3.3). ★박 8종은 [[rule/gaps#GAP_foil_parent_children]]의
  구체 실현형(박 부모 PROC_000033 대신 옵션그룹 값이 개별 공정을 가리킴).
- **판형**: [[plate-OUTPUT_PAPER_TYPE_01]] 국전계열(종이류만·`fn_best_plate` 자동선택·고객 미선택).
  판걸이수는 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

## 가격 경로 (priced_by → 공식 → has_component)

두 공식에 라이브 바인딩(박 선택 분기·전사표 "가격공식 바인딩"):
1. [[formula/digital-formulas#formula-PRF_DGP_E]] — 접지+타공(박 미선택 기본·apply_bgn 2026-06-01).
   원자합산형.
2. [[product-027-nodes]] `formula-PRF_DGP_E_FOIL` — 접지+타공+박(박 선택 시 재바인딩·apply_bgn
   2026-07-01·14 구성요소). 형제 027이 정의한 공식 노드를 **재사용**(동형 전파·재-mint 아님).

가격 값 계산은 **evaluate_price 단일 권위**([[rule/rules#RULE_price_value_boundary]]·D-18) —
KB는 "어떤 구성요소가 어떤 차원(use_dims)으로 붙나"까지만. 골든 스냅샷은 날짜 라벨로만 참조하며
이 노드에 수치 값을 기록하지 않는다(단가행은 D-22로 접음). 두 공식 모두 `has_component` 배선을
보유(고아 공식 아님·O5/O6 충족) — 배선은 각 공식 노드(digital-formulas·027-nodes) 소관.

## CPQ 옵션 (has_option_group) — [[product-029-trifold-card-cpq]]

인쇄(양면 고정)·종이(14)·후가공(가변·다중)·접지(3단 가로/세로·필수)·박칼라(8+없음) 5축. 각 옵션값은
`ref_dim_cd`+`ref_key1`로 실물 차원(자재/공정/인쇄옵션)을 가리킨다(R11 다형참조). 제약(constraint)은
라이브 실측 0건(§31 소관).

## 추가상품 (has_addon) — 봉투 3템플릿 → GAP

카드봉투 화이트/블랙(TMPL-000038/039→PRD_000004)·트레싱지봉투(TMPL-000009→PRD_000283)를 addon으로
딸 수 있으나, 대상 봉투 상품이 아직 KB 노드가 아니라 has_addon 엣지는 유보한다 →
[[gap-029-addon-envelope]](정직 GAP 선언·[[product-029-trifold-card-cpq]]).

## 승계·출처

정체·구분은 `_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md`(round-13 결함진단
문서·승계·재검증 2026-07-03·prd_cd 라이브 실재 확인). 축·배선 수치는 전부 `transcribe_product_029.py`
스크립트 전사(손전사 금지). 라이브 현재값(snap_20260702_1119)과 권위 엑셀 260702 충돌 없음
(양면 표기 불요·형제 027과 동형 구조·pack §3 접지카드 축 정합).
