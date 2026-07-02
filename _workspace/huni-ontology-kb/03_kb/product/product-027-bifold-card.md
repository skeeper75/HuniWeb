---
id: product-027-bifold-card
type: product
anchor: t_prd_products/PRD_000027
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000027", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3 접지카드 축별 큐레이션·§0 36 distinct/7구분", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§1 접지카드 정체(round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000021}
  - {rel: has_size, target: size-SIZ_000523}
  - {rel: has_size, target: size-SIZ_000124}
  - {rel: has_size, target: size-SIZ_000524}
  - {rel: has_size, target: size-SIZ_000525}
  - {rel: has_size, target: size-SIZ_000526}
  - {rel: has_size, target: size-SIZ_000129}
  - {rel: uses_material, target: material-MAT_000074}
  - {rel: uses_material, target: material-MAT_000081}
  - {rel: uses_material, target: material-MAT_000082}
  - {rel: uses_material, target: material-MAT_000091}
  - {rel: uses_material, target: material-MAT_000092}
  - {rel: uses_material, target: material-MAT_000101}
  - {rel: uses_material, target: material-MAT_000108}
  - {rel: uses_material, target: material-MAT_000109}
  - {rel: uses_material, target: material-MAT_000123}
  - {rel: uses_material, target: material-MAT_000347}
  - {rel: uses_material, target: material-MAT_000348}
  - {rel: uses_material, target: material-MAT_000349}
  - {rel: uses_material, target: material-MAT_000350}
  - {rel: uses_material, target: material-MAT_000356}
  - {rel: has_print_option, target: printopt-POPT_000002}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: Y, note: "디지털인쇄 base·미바인딩=인쇄비0"}}
  - {rel: has_process, target: process-PROC_000065, qualifier: {mand: N, note: "접지 옵션"}}
  - {rel: has_process, target: process-PROC_000066, qualifier: {mand: N, note: "접지 옵션"}}
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
  - {rel: priced_by, target: formula-PRF_DGP_E_FOIL, note: "박 선택 시 재바인딩"}
  - {rel: has_option_group, target: optgroup-OPT_000029}
  - {rel: has_option_group, target: optgroup-OPT_000030}
  - {rel: has_option_group, target: optgroup-OPT_000031}
  - {rel: has_option_group, target: optgroup-OPT_000032}
  - {rel: has_option_group, target: optgroup-OPT_000033}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 8
  max_qty: 10000
  qty_incr: 8
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
standards: {schema_org: Product, xjdf: "Product(접지카드)·FoldingIntent", config_ont: "component type"}
updated: 2026-07-03
---

# product-027 · 2단접지카드 (PRD_000027)

디지털인쇄 **완제품 단일**(`PRD_TYPE.01`·[[product-type-classification-sot]] 정합·셋트 아님·
`t_prd_product_sets` 부모 미등록). 접지카드 구분 그룹(팩 §0 7구분 중 하나). 파일 업로드로 주문
(`file_upload_yn=Y`·에디터 미사용 `editor_yn=N`). 청첩·안내카드 용도가 많아 [[INTENT_wedding]]와
연관(약참조).

## 정체·수량

<!-- transcribed-by: _meta/scripts/transcribe_product_027.py from live-snapshot/latest (snap_20260702_1119) t_prd_products prd_cd=PRD_000027 @ 2026-07-03 -->
| 필드 | 값 |
|---|---|
| prd_nm | 2단접지카드 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 8 |
| max_qty | 10000 |
| qty_incr | 8 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | Y |
| del_yn | N |

- **수량 규칙:** 최소 8 · 최대 10000 · 증분 8 (단위 QTY_UNIT.02 "매"). ★2단접지=한 판에 2컷
  → 8의 배수(2-up folding 특성). 이 상품은 `t_prd_product_bundle_qtys`·사이즈 수량규칙 행이 없어
  **수량 규칙 = 상품 스칼라(min/max/incr)** 로만 표현된다(별도 `bundle_qty` 노드·`has_qty_rule`
  엣지 없음 — 결함 아님·팩 §3.4 "수량 UI 권위=상품/사이즈 규칙"의 상품레벨 케이스).

## 차원 — 사이즈·도수

- **사이즈 6행**(접지카드 전용·[[product-027-nodes]] 사이즈 절): SIZ_000523/124/524/525/526/129.
  작업사이즈가 재단의 약 2배인 행은 펼침(접기 전) 전개 치수. SIZ_000524(가로접지)·SIZ_000525
  (세로접지)는 접힌 치수 135×135로 동일·펼침 방향만 다름.
- **도수 = 인쇄옵션**([[rule/rules#RULE_dosu_is_printopt]]): [[printopt-POPT_000002]] 양면 전용
  (front/back CLR_000005). 색상코드가 아니다(T-4 함정 회피).

## 자재/공정 BOM

- **자재 14종**(전부 USAGE.07·낱장 단일 슬롯): 공유 6종(백색모조지220 등·[[axis/materials]]) +
  접지카드 전용 8종([[product-027-nodes]] 자재 절 — 몽블랑/특수지·일부는 마스터 규격 미기재).
  기본 = 백색모조지 220g([[material-MAT_000074]]).
- **공정**: base [[process-PROC_000004]](디지털인쇄·mand) + 접지(PROC_000065/066) + 가변
  (PROC_000031/032) + 박 8종(PROC_000037~044). ★별색·박·코팅은 도수 아닌 공정(팩 §3.3).
  ★박 8종은 [[rule/gaps#GAP_foil_parent_children]]의 구체 실현형(박 부모 PROC_000033 대신
  옵션그룹 값이 개별 공정을 가리키는 형태).
- **판형**: [[plate-OUTPUT_PAPER_TYPE_01]] 국전계열(종이류만·`fn_best_plate` 자동선택·고객 미선택).
  판걸이수는 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

## 가격 경로 (priced_by → 공식 → has_component)

두 공식에 바인딩(박 선택 분기):
1. [[formula/digital-formulas#formula-PRF_DGP_E]] — 접지+타공(박 미선택 기본). 원자합산형.
2. [[product-027-nodes]] `formula-PRF_DGP_E_FOIL` — 접지+타공+박(박 선택 시 재바인딩·14구성요소).

가격 값 계산은 **evaluate_price 단일 권위**([[rule/rules#RULE_price_value_boundary]]·D-18) —
KB는 "어떤 구성요소가 어떤 차원(use_dims)으로 붙나"까지만. 골든 스냅샷은 날짜 라벨로만 참조하며
이 노드에 수치 값을 기록하지 않는다(단가행은 D-22로 접음).

## CPQ 옵션 (has_option_group) — [[product-027-cpq]]

인쇄(양면 고정)·종이(14)·후가공(가변·다중)·접지(가로/세로·필수)·박칼라(8+없음). 각 옵션값은
`ref_dim_cd`+`ref_key1`로 실물 차원(자재/공정/인쇄옵션)을 가리킨다(R11 다형참조). 제약(constraint)은
현재 0건(§31 소관).

## 추가상품 (has_addon) — 봉투 3템플릿

카드봉투 화이트/블랙·트레싱지봉투를 addon으로 딸 수 있으나, 대상 봉투 상품이 아직 KB 노드가
아니라 has_addon 엣지는 유보한다 → [[gap-027-addon-envelope]](정직 GAP 선언).

## 승계·출처

정체·구분은 `_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md`(round-13 결함진단
문서·승계·재검증 2026-07-03·prd_cd 라이브 실재 확인). 축·배선 수치는 전부 `transcribe_product_027.py` 스크립트 전사(손전사
금지). 라이브 현재값(snap_20260702_1119)과 권위 엑셀 260702 충돌 없음(양면 표기 불요).
