---
id: product-045-header-tag
type: product
anchor: t_prd_products/PRD_000045
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000045", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 배경지 정체·§3.10 PRF_DGP_C·§3.6 공정·§4 교정이력", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "§1 배경지 PRD_000045 착수명단·§2 포장세트 경계", captured_at: "2026-07-03", badge: verified, src_id: SR-worklist-dp}
relations:
  - {rel: in_category, target: category-CAT_000327, note: "인쇄포장재(main_cat_yn=N·부카테고리)·팩 §3.1 포장 계열"}
  - {rel: has_size, target: size-SIZ_000043, note: "80x80 (기본·dflt_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000044, note: "110x80"}
  - {rel: has_size, target: size-SIZ_000045, note: "140x80"}
  - {rel: has_size, target: size-SIZ_000046, note: "160x80"}
  - {rel: uses_material, target: material-MAT_000091, note: "스노우지 250g·USAGE.07 공통 슬롯(단일 본문 자재)·043과 동일"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면만(front CLR_000005 칼라·back CLR_000001)·★043과 달리 양면 미등록"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base·2026-06-30 결합(DEC_baseproc_260701 18건 중 1건)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전계열(316x467)@SIZ_000499·종이류·fn_best_plate 자동선택"}
  - {rel: priced_by, target: formula-PRF_DGP_C, note: "원자합산형C(인쇄비+용지비+접지비+타공비)·043 배경지와 공유 공식"}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 20
  max_qty: 1000
  qty_incr: 20
  qty_unit_typ_cd: QTY_UNIT.02
  file_upload_yn: Y
  editor_yn: N
  use_yn: Y
  del_yn: N
  archetype_note: "완제품 단일(t_prd_product_sets 부모 등록 0행 — SOT상 셋트 아님)"
  qty_src: "전사표(transcribe_045.py) — raw 수치 손전사 아님"
standards: {schema_org: Product, xjdf: "Product(헤더택·포장)", config_ont: "component type"}
answers_cq: [S1, S3]
tags: [디지털인쇄, 포장, 배경지, 헤더택]
updated: 2026-07-03
---

# 인쇄헤더택 — PRD_000045

## 정체 (identity)

디지털인쇄 **완제품 단일**(prd_typ_cd=PRD_TYPE.01). 헤더택(header tag)은 포장(봉투·스낵백 등)의
상단에 접어 다는 헤더 형태 태그로, 팩 §3.1의 배경지 계열(043~045)과 같은 **인쇄포장재**
(CAT_000327·상위 CAT_000012) 카테고리에 속한다. 라이브에서 `t_prd_product_sets` 부모 등록이
**0행**이므로 SOT 기준 **셋트 완제품이 아니다**(일반 단일 완제품·[[rule/rules#RULE_scope_boundary]] 범위 안).
worklist §2가 "배경지 044/045는 포장 세트(봉투/케이스 동봉)"로 묶은 것은 카테고리·용도 계열의
느슨한 표현이며, 부품조립형 셋트(`has_member`)와 구분한다 — 045 라이브는 sets·addons 모두 0행이라
포장 동봉의 세트/애드온 적재 모델은 미결로 남는다([[GAP_envelope_set_model]]·팩 §3.9 Q-ID-A).
파일 업로드형(file_upload_yn=Y·editor_yn=N). 가격 값 단정은 하지 않는다([[RULE_price_value_boundary]]·D-18).

**043 배경지와의 관계:** 공식(PRF_DGP_C)·자재(스노우지 250g)·판형(국전)·카테고리(인쇄포장재)를
공유하는 형제 상품이나, ① 사이즈가 다르고(045=4행 SIZ_000043~046 / 043=6행 SIZ_000033~038)
② **도수가 단면만**(045는 POPT_000002 양면 미등록·043은 단/양면 둘 다)이라는 점에서 갈린다.

## 라이브 축 멤버십 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_045.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* (PRD_000045) @ 2026-07-03 -->
| 축 | 라이브 멤버십 |
|---|---|
| 정체 | 인쇄헤더택 · prd_typ_cd=PRD_TYPE.01 · use_yn=Y/del_yn=N · file_upload=Y/editor=N |
| 수량 | min=20 · max=1000 · incr=20 · 단위=QTY_UNIT.02 |
| 사이즈 | SIZ_000043, SIZ_000044, SIZ_000045, SIZ_000046 (4행) |
| 자재 | MAT_000091(USAGE.07) |
| 도수(인쇄옵션) | POPT_000001(단면) |
| 공정 | PROC_000004(mand) |
| 판형 | OUTPUT_PAPER_TYPE.01@SIZ_000499 |
| 공식 | PRF_DGP_C |
| 카테고리 | CAT_000327 |
| CPQ/추가/셋트 | option_groups=0 · constraints=0 · addons=0 · sets=0 · bundle_qtys=0 |

## 차원 (dimensions)

- **사이즈** 4행(80x80·110x80·140x80·160x80) — 폭 80mm 고정·길이 가변의 가로 헤더 형태. 치수 전사표는
  [[product/product-045-header-tag-sizes.md]](상품 전용 하위 노드). 면적매트릭스 아닌 이산 사이즈 행(팩 §3.2).
- **도수(인쇄옵션)** = **단면만**(POPT_000001·front_colrcnt_cd=CLR_000005 칼라·back=CLR_000001).
  도수는 인쇄옵션 코드이지 색상코드가 아니다([[RULE_dosu_is_printopt]]). 양면(POPT_000002)은 라이브 미등록 —
  헤더택은 앞면만 인쇄하는 태그라 단면 단일이 도메인상 정합(지어내지 않고 라이브 그대로).
- **수량규칙** = 상품 레벨 스칼라(min 20·max 1000·incr 20·단위 QTY_UNIT.02 "매"). `t_prd_product_bundle_qtys`
  0행이라 별도 `bundle_qty` 노드/`has_qty_rule` 엣지 없이 상품 props로 접는다(수량 UI 권위=상품/사이즈
  수량규칙·가격구간과 역할 분리·팩 §3.4).
- **판걸이수(UP수)** = 사이즈의 파생값(엔진 `fn_calc_pansu` 계산·[[RULE_pansu_db_function]]) — 온톨로지 밖.

## 자재·공정 (BOM)

- **자재** = 스노우지 250g(MAT_000091) 단일 본문 슬롯(USAGE.07 default·팩 §3.5·043과 동일 자재). 종이류이므로 판형 유효.
- **공정** = 디지털인쇄 base(PROC_000004·mand)뿐. 이 base 공정은 2026-06-30에 결합됐다 —
  미바인딩이면 인쇄비 영구 0이 되는 7월 대발견 18건 교정에 045가 포함됐다([[DEC_baseproc_260701]]·[[RULE_dataline_neq_wiring]]).
- **판형** = 국전계열(OUTPUT_PAPER_TYPE.01·316x467)@SIZ_000499. 고객 미선택·fn_best_plate 자동선택([[RULE_plate_paper_only]]).

## 가격 경로 (price path)

`priced_by` → **PRF_DGP_C**(원자합산형C·[[formula-PRF_DGP_C]]·043 배경지와 공유). PRF_DGP_C가 `has_component`로
배선하는 4 구성요소(공식 노드에 전사): 디지털인쇄비(COMP_PRINT_DIGITAL_S1)·용지비(COMP_PAPER)·접지비 카드 2단
(COMP_FOLD_CARD_2H·use_dims=[min_qty])·타공비 6mm(COMP_CUT_PERF_1H6·use_dims proc_grp:PROC_000079). 각 구성요소의
use_dims 차원 선언은 [[formula/digital-components]]에, 값 계산은 evaluate_price 권위([[RULE_price_value_boundary]]).
골든 스냅샷 기준일 = live 20260702_1119(값은 기록하지 않음·연결만).

**끊긴 경로(정직 선언):** 공식은 타공비(COMP_CUT_PERF_1H6·발현 조건 proc_grp:PROC_000079)를 배선하나,
이 상품의 `t_prd_product_processes`에는 **타공(PROC_000079 계열) 공정이 미등록**(PROC_000004만 존재).
헤더택은 걸이용 상단 구멍(타공)이 도메인상 그럴듯한데도 타공 공정이 없어 타공비가 조용히 0이 될 수 있다
→ 아래 [[GAP_045_perf_process]]로 등재. (접지비 COMP_FOLD_CARD_2H는 use_dims=[min_qty]로 공정 의존이
없어 별도 공정 등록 없이 발현 — 끊김 아님. 단 헤더택에 접지가 실제로 쓰이는지는 공식 레벨 관심사.)

## CPQ·추가상품 (options / addons)

라이브에서 옵션그룹·제약·추가상품·셋트 **전부 0행**. 포장 헤더택의 봉투/케이스 동봉을 sets·addons·CPQ
옵션 중 무엇으로 표현할지는 미결([[GAP_envelope_set_model]]·팩 §3.9/§3.12 Q-ID-A). 현재는 연결할 CPQ
노드가 없어 `has_option_group`/`has_addon` 엣지를 만들지 않는다(지어내지 않음).

## 승계·freshness 메모

- 정체·사이즈 4행 = 팩 §3.1/§3.2 FRESH 승계(live-snapshot 20260702_1119 실측). "엽서 13종"류 STALE(T-2)는 045 무관.
- base 공정 결합·판걸이수 DB함수는 위키에 없던 7월 신사실 — §4-A/§4-C 원장으로 재조준(T-6 오염 회피).
  위키 🔴 결함표(C-01~18)를 "현재 결함"으로 인용하지 않았다.

## 이력 (history)

- 2026-07-03 초기 집필(디지털인쇄 배경지 계열 확장·043의 형제). 공유 축·공식·구성요소는 재사용(중복 mint 0).
  전용 신규 = 사이즈 4행(하위 노드·이관 후보)·GAP_045_perf_process. 수치 전량 `transcribe_045.py` 전사.

---

## 상품 전용 GAP

### [GAP_045_perf_process] 헤더택 타공비 배선 vs 타공 공정 미등록 {unknown}
- type: gap
- anchor: none  # 사유: 공식은 타공비를 배선하나 product_processes에 타공 공정 미등록 — 의도 여부 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:PRD_000045 (PROC_000004만)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.6 [DGP-BM-003] 배경지/라벨택 전용 커팅·타공 MISSING 재측정", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "PRF_DGP_C는 타공비(COMP_CUT_PERF_1H6·proc_grp:PROC_000079)를 배선하지만 045의 t_prd_product_processes에 타공(PROC_000079 계열) 공정이 없음 — 타공비 발현 조건 부재(저청구/0). 헤더택은 걸이 구멍(타공)이 도메인상 필요할 법한데 공정 미등록이 누락인지 의도인지 원천 부재. 043 배경지와 동형 결함(GAP_043_perf_process)"
- gap_fill_from: "실무진 확인(헤더택 타공 필요 여부) + 필요 시 §26/§27 배선·공정 등록 트랙(재측정 wiring_scan.py·contribution_sim_scan.py). 값 판정은 evaluate_price(D-18)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_CUT_PERF_1H6, note: "배선된 타공비 구성요소"}
- rel: {rel: references, target: process-PROC_000079, note: "발현 조건 공정(미등록)"}
- 본문: 접지비(COMP_FOLD_CARD_2H)는 use_dims=[min_qty]만 보므로 발현되나, 타공비는 proc_grp:PROC_000079 매칭이 필요하다. 이 상품 공정 목록에 타공이 없어 타공비가 조용히 0이 될 수 있다 — 지어내지 않고 GAP으로 노출. [[product-045-header-tag]]의 가격 경로 참조. 043 배경지와 같은 공식(PRF_DGP_C)을 공유해 동형 GAP이다.
