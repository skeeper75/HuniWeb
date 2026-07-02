---
id: product-033-standard-namecard
type: product
anchor: t_prd_products/PRD_000033
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000033", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.7 인쇄옵션·§3.1 명함 정체", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y)"}
  # 차원 — 사이즈 (R2 has_size — 명함 전용 사이즈, 하위 노드)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm 기본"}
  - {rel: has_size, target: size-SIZ_000133, note: "86x52mm"}
  # 자재 (R3 uses_material — 공유 축 5종·USAGE.07 default 단일 슬롯)
  - {rel: uses_material, target: material-MAT_000074}
  - {rel: uses_material, target: material-MAT_000081}
  - {rel: uses_material, target: material-MAT_000082}
  - {rel: uses_material, target: material-MAT_000091}
  - {rel: uses_material, target: material-MAT_000092}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005 4도)"}
  # 공정 (R5 has_process — 모두 mand_proc_yn=N·명함 전용 자식 공정, 하위 노드)
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각 모서리(default 재단)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근 모서리(귀돌이 R)"}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: N}, note: "가변텍스트"}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: N}, note: "가변이미지"}
  # 판형 (R6 has_plate_size — 종이류만·공유 축 국전계열·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "SIZ_000499 출력용지·OUTPUT_PAPER_TYPE.01"}
  # 가격 (R8 priced_by — 공유 공식·고정가 용지포함)
  - {rel: priced_by, target: formula-PRF_NAMECARD_FIXED}
  # CPQ 옵션 그룹 (R10 has_option_group — 하위 노드)
  - {rel: has_option_group, target: optgroup-033-print}
  - {rel: has_option_group, target: optgroup-033-paper}
  - {rel: has_option_group, target: optgroup-033-corner}
  - {rel: has_option_group, target: optgroup-033-postpress}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모 미등록)
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). 별도 t_prd_product_bundle_qtys 행 없음·사이즈 수량규칙(min/max/incr) 공란"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3]
tags: [디지털인쇄, 명함, 고정가]
updated: 2026-07-03
---

# 상품: 스탠다드명함 (PRD_000033)

스탠다드명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`). 명함 카테고리의 고정가
baseline 상품이다. 사이즈 2종(90×50·86×52)·칼라 단/양면·용지 5종(USAGE.07 공통 슬롯)·후가공은
모서리(직각/둥근) 택1 + 가변데이터(텍스트/이미지) 택N. 파일 업로드형(에디터 미사용). 가격은
고정가 공식 [[formula-PRF_NAMECARD_FIXED]](용지포함 완제품가 단/양면)로 결정되며, 값 계산은
`evaluate_price` 권위(온톨로지는 배선까지·D-18). 최소 100매·100매 증분·최대 10,000매.

**코팅명함(PRD_000032)과의 관계:** 스탠다드명함은 코팅 없는 baseline, 코팅명함은 코팅 포함
변형(별도 공식 `PRF_NAMECARD_COAT`). nl S2/S3 질의(최소수량·명함 종류 비교)의 기준 상품.

## 명함 전용 사이즈 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_033.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 |
| SIZ_000133 | 86x52mm | 88x54 | 86x52 |

> 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생값(`fn_calc_pansu`·엔진)이다(F-9·T-7). SIZ_000008
> note에 "판걸이=24.0" 기재가 있으나 이는 참고 메모이며 권위 판걸이수는 엔진 계산.

## 명함 후가공 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_033.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정(upr) |
|---|---|---|
| PROC_000027 | 직각 | PROC_000026 |
| PROC_000028 | 둥근 | PROC_000026 |
| PROC_000031 | 가변텍스트 | PROC_000085 |
| PROC_000032 | 가변이미지 | PROC_000085 |

> 명함 후가공은 엽서(016) 축의 부모 공정(귀돌이 PROC_000026·가변데이타 PROC_000085)의 **자식
> 공정 코드**를 쓴다(직각/둥근·텍스트/이미지). **2026-07-03 축 승격**: 명함 사이즈(SIZ_000008/133)와
> 후가공 자식 공정(PROC_000027/028/031/032)은 032·024 등과 공유라 공유 `axis/sizes.md`·`axis/processes.md`로
> 이관했다(위 relations의 has_size/has_process 타깃이 축 노드로 resolve·L-3 중복 해소). 치수/상위공정 전사표는
> 위 §명함 전용 사이즈·§명함 후가공 공정(transcribe_product_033.py 산출)에 유지.

---

<!-- 이하: PRD_000033 전용 하위 노드(공유 축에 없는 것만 = 옵션그룹). 공유 축(사이즈·공정·자재·도수·판형·카테고리·공식)은 위 relations로 재사용. -->

### [optgroup-033-print] 인쇄(도수) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000033
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000033 opt_grp_cd:OPT_000048", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "2"}}
- props: {opt_grp_cd: "OPT_000048", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 1, max_sel_cnt: 1, mand_yn: "Y", note: "도수 단/양면 택1 필수. ref=opt_id(NOT clr_cd·도수=print_opt_cd)"}

### [optgroup-033-paper] 종이(자재) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000033
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000033 opt_grp_cd:OPT_000049", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000074, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000074", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000081, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000081", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000082, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000082", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000091, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000091", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000092, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000092", ref_key2: "USAGE.07"}}
- props: {opt_grp_cd: "OPT_000049", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 1, max_sel_cnt: 1, mand_yn: "Y", note: "용지 5종 택1 필수·USAGE.07 공통 슬롯. option_refs 타깃은 같은 부모 실재(fn_chk_opt_item_ref)"}

### [optgroup-033-corner] 모서리 택1 선택 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000033
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000033 opt_grp_cd:OPT_000050", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000027, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000027"}}
- rel: {rel: option_refs, target: process-PROC_000028, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000028"}}
- props: {opt_grp_cd: "OPT_000050", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 0, max_sel_cnt: 1, mand_yn: "N", note: "직각/둥근 택1 선택(비필수)·ref 공정 .04"}

### [optgroup-033-postpress] 후가공 택N 다중 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000033
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000033 opt_grp_cd:OPT_000051", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000031, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000031"}}
- rel: {rel: option_refs, target: process-PROC_000032, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000032"}}
- props: {opt_grp_cd: "OPT_000051", opt_grp_nm: "후가공", sel_typ_cd: "SEL_TYPE.02", min_sel_cnt: 0, max_sel_cnt: 2, mand_yn: "N", note: "가변텍스트/가변이미지 택N(2종 동시선택 실증)·줄수/개수 파라미터 미보존([[gap-033-vardata-param]])"}

### [gap-033-vardata-param] 가변데이터 줄수·개수 파라미터 미보존 {unknown}
- type: gap
- anchor: none  # 사유: 후가공 가변텍스트/가변이미지의 줄수·개수 파라미터가 옵션 정형 shape에 보존되지 않음(OPT_000051 note "GAP-PARAM 보존불가")
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000033 opt_grp_cd:OPT_000051 note", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "가변텍스트/가변이미지 후가공의 줄수·개수(수량) 파라미터 — 옵션 정형 shape에 보존 불가(가격 영향 가능축)"
- gap_fill_from: "위젯/폼빌더 파라미터 입력 스펙(§6/§31) 또는 실무진 확인"
- gap_owner: staff
- rel: {rel: derived_from, target: process-PROC_000031}

## 끊긴 경로·미해결 (정직 선언)

- **가변데이터 파라미터 GAP**: 위 [[gap-033-vardata-param]] — 줄수/개수가 옵션 shape에 없어
  가격/제작 파라미터가 보존 안 됨. 가격 영향 가능성 있으나 원천 부재(⚪).
- **수량규칙 노드 부재**: `t_prd_product_bundle_qtys`에 PRD_000033 행 없음 → 별도 `bundle_qty`
  노드(E8) 미생성. 수량은 상품 스칼라(min100/max10000/incr100)로만 표현(정상·GAP 아님).
- **제약규칙(constraint) 없음**: `t_prd_product_constraints`에 PRD_000033 행 0. 옵션 택일 카디널리티
  (sel_typ·min/max_sel)로 선택 규칙이 표현되어 별도 교차제약 불요(정상).
- **추가상품 없음**: `t_prd_product_addons` 행 0 → `has_addon` 없음(명함은 addon 미보유).

## Sources
- live-snapshot 20260702_1119: `t_prd_products`(PRD_000033 정체·수량)·`t_prd_product_sizes`(SIZ_000008/133)·`t_prd_product_materials`(5종 USAGE.07)·`t_prd_product_print_options`(POPT_000001/002)·`t_prd_product_processes`(PROC_000027/028/031/032)·`t_prd_product_plate_sizes`(SIZ_000499)·`t_prd_product_price_formulas`(PRF_NAMECARD_FIXED)·`t_prd_product_option_groups/options/option_items`(OPT_000048~051)·`t_prd_product_categories`(CAT_000313/003) — 전사=`_meta/scripts/transcribe_product_033.py`(cache/transcribed-033-260703.json).
- `01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd)·§3.5(자재 USAGE.07)·§3.7(인쇄옵션).
- 공유 축·공식 노드: `axis/materials.md`·`axis/print-options.md`·`axis/plate-sizes.md`·`axis/categories.md`·`formula/digital-formulas.md`(PRF_NAMECARD_FIXED)·`formula/digital-components.md`(COMP_NAMECARD_STD_S1/S2).
