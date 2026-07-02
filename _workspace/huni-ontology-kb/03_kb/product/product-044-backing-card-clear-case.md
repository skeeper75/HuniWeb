---
id: product-044-backing-card-clear-case
type: product
anchor: t_prd_products/PRD_000044
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000044", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 배경지 정체·§3.10 PRF_DGP_C·§3.6 접지/타공", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "docs/huni/후니프린팅_상품마스터_260702.xlsx", source_locator: "시트:디지털인쇄!인쇄배경지행 (via _workspace/huni-dbmap/06_extract/digital-print-l1.csv)", captured_at: "2026-07-03", badge: verified, src_id: SR-2.2-diff}
relations:
  - {rel: in_category, target: category-CAT_000327, note: "인쇄포장재(main_cat_yn=N)·팩 §3.1 포장 계열"}
  - {rel: has_size, target: size-SIZ_000039}
  - {rel: has_size, target: size-SIZ_000041}
  - {rel: uses_material, target: material-MAT_000091, note: "스노우지 250g·USAGE.07 공통 슬롯(단일 본문 자재)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base·DEC_baseproc_260701 18건 중 1건"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전계열(316x467)@SIZ_000499·종이류·fn_best_plate 자동선택"}
  - {rel: priced_by, target: formula-PRF_DGP_C, note: "원자합산형C(인쇄비+용지비+접지비+타공비)·043과 공유"}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 20
  max_qty: 1000
  qty_incr: 20
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
  archetype_note: "완제품 단일(t_prd_product_sets 부모 등록 0행 — SOT상 셋트 아님)"
standards: {schema_org: Product, xjdf: "Product(배경지·포장)", config_ont: "component type"}
answers_cq: [S1, S3]
tags: [디지털인쇄, 포장, 배경지]
updated: 2026-07-03
---

# 인쇄배경지(투명케이스타입) — PRD_000044

## 정체 (identity)

디지털인쇄 **완제품 단일**(prd_typ_cd=PRD_TYPE.01). 이름의 "투명케이스타입"은 투명 케이스(포토카드
케이스 등)에 넣는 포장 용도의 배경지라는 뜻이고, 라이브에서 `t_prd_product_sets` 부모 등록이
**0행**이므로 SOT 기준 **셋트 완제품이 아니다**(일반 단일 완제품). 팩 §3.1의 "배경지=포장 세트"는
카테고리(포장 계열)를 가리키는 느슨한 표현으로, 부품조립형 셋트(`has_member`)와 구분한다.
043(OPP봉투타입)의 형제 상품이며 축 구성(자재·도수·공정·판형·공식·카테고리)이 동일하고 **사이즈만
다르다**(043=6행 / 044=2행). 카테고리는 **인쇄포장재**(CAT_000327·상위 CAT_000012)로 연결됐다 —
팩 §3.1이 남긴 `[DGP-ST-001]` 카테고리 고아(044→구 CAT_000296) 의심은 라이브 재측정 결과 **재연결로
해소**(main_cat_yn=N). 파일 업로드형(file_upload_yn=Y·editor_yn=N). 가격 값 단정은 하지 않는다
([[RULE_price_value_boundary]]·D-18).

## 라이브 축 멤버십 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_044.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* (PRD_000044) @ 2026-07-03 -->
| 축 | 라이브 멤버십 |
|---|---|
| 정체 | 인쇄배경지(투명케이스타입) · prd_typ_cd=PRD_TYPE.01 · use_yn=Y/del_yn=N · file_upload=Y/editor=N |
| 수량 | min=20 · max=1000 · incr=20 · 단위=QTY_UNIT.02 |
| 사이즈 | SIZ_000039, SIZ_000041 (2행) |
| 자재 | MAT_000091(USAGE.07) |
| 도수(인쇄옵션) | POPT_000001(단면), POPT_000002(양면) |
| 공정 | PROC_000004(mand) |
| 판형 | OUTPUT_PAPER_TYPE.01@SIZ_000499 |
| 공식 | PRF_DGP_C |
| 카테고리 | CAT_000327 |
| CPQ/추가/셋트 | option_groups=0 · constraints=0 · addons=0 · sets=0 · bundle_qtys=0 |

## 차원 (dimensions)

- **사이즈** 2행(74x74·74x109) — 치수 전사표는 [[product/product-044-backing-card-clear-case-sizes.md]].
  전부 dflt_yn=Y·사이즈별 수량규칙 없음(t_prd_product_sizes의 min/max/incr 공란).
  2 사이즈 노드는 [[product/product-044-backing-card-clear-case-sizes.md]](상품 전용 하위 노드).
- **도수(인쇄옵션)** = 단면(POPT_000001)·양면(POPT_000002). 도수는 인쇄옵션 코드이지 색상코드가
  아니다([[RULE_dosu_is_printopt]]). front_colrcnt_cd=CLR_000005(칼라).
- **수량규칙** = 상품 레벨 스칼라(min 20·max 1000·incr 20·단위 QTY_UNIT.02 "매"). `t_prd_product_bundle_qtys`
  0행이라 별도 `bundle_qty` 노드/`has_qty_rule` 엣지 없이 상품 props로 접는다.
- **판걸이수(UP수)** = 사이즈의 파생값(엔진 `fn_calc_pansu` 계산·[[RULE_pansu_db_function]]) — 온톨로지 밖.

## 자재·공정 (BOM)

- **자재** = 스노우지 250g(MAT_000091) 단일 본문 슬롯(USAGE.07 default·팩 §3.5). 종이류이므로 판형 유효.
- **공정** = 디지털인쇄 base(PROC_000004·mand). 이 base 공정 미바인딩이면 인쇄비 영구 0이 되는 7월
  대발견 18건 교정의 일부([[DEC_baseproc_260701]]·[[RULE_dataline_neq_wiring]]).
- **판형** = 국전계열(OUTPUT_PAPER_TYPE.01·316x467)@SIZ_000499. 고객 미선택·fn_best_plate 자동선택([[RULE_plate_paper_only]]).

## 가격 경로 (price path)

`priced_by` → **PRF_DGP_C**(원자합산형C·[[formula-PRF_DGP_C]]·043과 공유). PRF_DGP_C가 `has_component`로
배선하는 4 구성요소(공식 노드에 전사): 디지털인쇄비(COMP_PRINT_DIGITAL_S1)·용지비(COMP_PAPER)·
접지비 카드 2단(COMP_FOLD_CARD_2H)·타공비 6mm(COMP_CUT_PERF_1H6). 각 구성요소의 use_dims 차원
선언은 [[formula/digital-components]]에, 값 계산은 evaluate_price 권위([[RULE_price_value_boundary]]).
골든 스냅샷 기준일 = live 20260702_1119(값은 기록하지 않음·연결만).

**끊긴 경로(정직 선언):** 공식은 타공비(COMP_CUT_PERF_1H6·발현 조건 proc_grp:PROC_000079)를 배선하나,
이 상품의 `t_prd_product_processes`에는 **타공(PROC_000079 계열) 공정이 미등록**(PROC_000004만 존재).
→ 아래 [[GAP_044_perf_process]]로 등재. (접지비 COMP_FOLD_CARD_2H는 use_dims=[min_qty]로 공정 의존이
없어 별도 공정 등록 없이 발현 — 끊김 아님. 043과 동일 구조.)

## CPQ·추가상품 (options / addons)

라이브에서 옵션그룹·제약·추가상품·셋트 **전부 0행**. 투명케이스 포장 구성을 sets·addons·CPQ 옵션 중
무엇으로 표현할지는 미결([[GAP_envelope_set_model]]·팩 §3.9/§3.12 Q-ID-A). 현재는 연결할 CPQ 노드가
없어 `has_option_group`/`has_addon` 엣지를 만들지 않는다(지어내지 않음).

## 이력 (history)

- 2026-07-03 초기 집필(Phase 4 이후 배경지 계열 확장 — 043 형제 상품). 공유 축·공식·구성요소는 재사용
  (중복 mint 0). 전용 신규 = 사이즈 2행(하위 노드·이관 후보 SIZ_000039/041)·GAP_044_perf_process.
  수치 전량 `transcribe_044.py`(043 스크립트 복제·PRD만 교체·기존 무수정) 전사.

---

## 상품 전용 GAP

### [GAP_044_perf_process] 투명케이스 배경지 타공비 배선 vs 타공 공정 미등록 {unknown}
- type: gap
- anchor: none  # 사유: 공식은 타공비를 배선하나 product_processes에 타공 공정 미등록 — 의도 여부 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:PRD_000044 (PROC_000004만)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.6 [DGP-BM-003] 배경지/라벨택 전용 커팅·접지 MISSING 재측정", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "PRF_DGP_C는 타공비(COMP_CUT_PERF_1H6·proc_grp:PROC_000079)를 배선하지만 044의 t_prd_product_processes에 타공(PROC_000079 계열) 공정이 없음 — 타공비 발현 조건 부재 가능성(저청구/0). 투명케이스 배경지에 타공이 실제 필요한지·필요하면 공정 등록이 누락인지 원천 부재. 043(형제)과 동일 패턴"
- gap_fill_from: "실무진 확인(투명케이스 배경지 타공 필요 여부) + 필요 시 §26/§27 배선·공정 등록 트랙(재측정 wiring_scan.py·contribution_sim_scan.py). 값 판정은 evaluate_price(D-18)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_CUT_PERF_1H6, note: "배선된 타공비 구성요소"}
- rel: {rel: references, target: process-PROC_000079, note: "발현 조건 공정(미등록)"}
- 본문: 접지비는 min_qty만 보므로 발현되나, 타공비는 proc_grp:PROC_000079 매칭이 필요하다. 이 상품 공정 목록에 타공이 없어 타공비가 조용히 0이 될 수 있다 — 지어내지 않고 GAP으로 노출. [[product-044-backing-card-clear-case]]의 가격 경로 참조. 043의 [[GAP_043_perf_process]]와 동일 구조(공유 공식 PRF_DGP_C 파생).
</content>
