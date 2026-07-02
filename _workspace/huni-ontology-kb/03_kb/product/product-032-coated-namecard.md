---
id: product-032-coated-namecard
type: product
anchor: t_prd_products/PRD_000032
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000032", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(명함=인쇄홍보물)·§3.11 명함 배선교정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(2차·main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000008, note: "90x50(공유 명함 사이즈·033 정의 재사용)"}
  - {rel: has_size, target: size-SIZ_000133, note: "86x52(공유 명함 사이즈·033 정의 재사용)"}
  - {rel: uses_material, target: material-MAT_000081, note: "아트지 250g(USAGE.07·dflt)"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g(USAGE.07)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(칼라)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(칼라)"}
  - {rel: has_process, target: process-PROC_000014, qualifier: {mand: N}, note: "유광라미네이팅(코팅 옵션)"}
  - {rel: has_process, target: process-PROC_000015, qualifier: {mand: N}, note: "무광라미네이팅(코팅 옵션)"}
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각(모서리 옵션)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근(모서리 옵션)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "종이류(아트지)→판형 국전 SIZ_000499·fn_best_plate 자동선택"}
  - {rel: priced_by, target: formula-PRF_NAMECARD_COAT}
  - {rel: has_option_group, target: optgroup-032-print}
  - {rel: has_option_group, target: optgroup-032-paper}
  - {rel: has_option_group, target: optgroup-032-coating}
  - {rel: has_option_group, target: optgroup-032-corner}
props:
  prd_typ_cd: PRD_TYPE.01
  min_qty: 100
  file_upload_yn: Y
  editor_yn: N
  qty_unit_typ_cd: QTY_UNIT.02
  archetype_price: "고정가(용지포함)"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
updated: 2026-07-03
---

# 코팅명함 (PRD_000032) — 디지털인쇄 완제품 (명함)

코팅명함은 디지털인쇄 **완제품 단일**(prd_typ_cd=PRD_TYPE.01·SOT: 완제품=셋트 아닌 단일
제조상품). 파일 업로드형(file_upload_yn=Y·editor_yn=N). 명함 사이즈 2종(90×50·86×52)·
칼라 단/양면·아트지 250/300g·유광/무광 코팅·직각/둥근 모서리를 손님이 고른다.

**가격 아키타입 = 고정가(용지포함)** — 원자합산형(엽서 PRF_DGP_A)이 아니라 명함 전용 고정가
공식 [[formula/digital-formulas#formula-PRF_NAMECARD_COAT]]로 계산한다. 값 차원(use_dims)은
`[mat_cd, min_qty, print_opt_cd]` — 즉 **자재·수량·단/양면**으로만 가격이 갈리며, 코팅(유광/무광)·
모서리(직각/둥근)는 CPQ 옵션이지만 이 고정가 표의 가격 차원이 아니다(고정가에 포함·아래 §옵션 참고).
가격 값 계산은 evaluate_price 단일 권위([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는
연결까지만(D-18). 골든 스냅샷 = live 20260702_1119 기준(값 미기록).

**배선교정 이력:** 명함 완제품가 단가행(용지포함)이 적재됐으나 공식에 미배선(고아)이어서
저청구였고, 2026-06-30 PRF_NAMECARD_COAT 배선 COMMIT으로 해소([[#DEC_namecard032_wiring_260630]]·
[[rule/rules#RULE_dataline_neq_wiring]]).

## 사이즈 전사 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_namecard032.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 |
| SIZ_000133 | 86x52mm | 88x54 | 86x52 |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |

## 수량규칙 스칼라 전사

<!-- transcribed-by: _meta/scripts/transcribe_namecard032.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000032 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | qty_unit_typ_cd |
|---|---|---|---|
| 100 | 10000 | 100 | QTY_UNIT.02 |

> 수량규칙은 **상품 레벨 스칼라**(min/max/incr·단위 QTY_UNIT.02 "매")로 실린다. 032는
> `t_prd_product_bundle_qtys` 행이 0개 → 별도 bundle_qty 노드 미생성(팩 §3.4: bundle_qtys 0행이
> 곧 미적재를 뜻하지 않음·수량 UI 권위=상품/사이즈 수량규칙). has_qty_rule 엣지 없음(정상).

## 사이즈 노드 (공유 참조 — 중복 정의 금지)

> 명함 사이즈 2종(SIZ_000008 90x50·SIZ_000133 86x52)은 공유 axis/sizes.md(016 엽서 7행+국전)엔
> 미등재이나, 형제 상품 노드 product-033-standard-namecard.md가 축 규약 id(size-SIZ_000008/133)로
> 이미 정의했다. 중복 노드 생성 금지 원칙([HARD])에 따라 032는 **정의하지 않고 재사용(참조)**한다
> (has_size 엣지가 그 노드로 resolve). ★근본 해법 = 이 2종을 공유 axis/sizes.md로 승격(index_entries
> 반환) — 축 규약 id는 승격 후에도 안정 유지(reference 그대로 resolve).

## 공정 노드 (소유 모델 — 032=코팅 소유·명함일반=033 참조)

> 032가 쓰는 후가공 공정 4종은 전부 다상품 공유 축 항목이나 공유 axis/processes.md엔 라미네이팅
> 코팅 부모(PROC_000013)·귀돌이(PROC_000026)만 있어 명함 실사용 자식 코드가 비어 있다(근본 공백).
> 중복 노드 생성 금지 원칙([HARD])하에 단일 소유자를 정한다:
> - **유광/무광 라미네이팅(PROC_000014/015)** = 코팅명함(032)이 자연 소유자(코팅=상품 정체) → 032 정의.
> - **직각/둥근 모서리(PROC_000027/028)** = 명함 일반 공정 → product-033-standard-namecard가 정의 → 032는 참조.
>
> ★2026-07-03 축 승격 완료 = 라미네이팅(PROC_000014/015)·모서리(PROC_000027/028) 4종 전부 공유
> `axis/processes.md`로 이관됨. 032는 이제 위 relations(has_process·optgroup-032-corner의 option_refs)로
> 축 노드를 참조만 한다(중복 정의 제거·L-3 해소). 전부 mand_proc_yn=N(선택 후가공). [[_glossary#TERM_corner_round]].

## CPQ 옵션 그룹 (손님 선택 축)

> 4그룹 전부 택1(SEL_TYPE.01). 인쇄·종이=필수(mand_yn=Y)·코팅·모서리=선택(min_sel=0·센티넬).
> option_refs 다형참조는 option_item 단위(ref_key 한정자). 앵커는 t_prd_product_option_groups의
> 키 컬럼(col0=prd_cd)이라 PRD_000032로 앵커하고 opt_grp_cd는 props에 기록(L-17 닫힌세계 정합).

### [optgroup-032-print] 인쇄 (도수 택1 필수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000032
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000032,OPT_000044)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: 1}, note: "단면=opt_id 1"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: 2}, note: "양면=opt_id 2"}
- props: {opt_grp_cd: OPT_000044, sel_typ_cd: "SEL_TYPE.01", mand_yn: Y, note: "도수 택1 필수. ref OPT_REF_DIM.06 opt_id(NOT clr_cd·[[rule/rules#RULE_dosu_is_printopt]])"}

### [optgroup-032-paper] 종이 (자재 택1 필수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000032
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000032,OPT_000045)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000081, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000081", ref_key2: "USAGE.07"}, note: "아트지 250g"}
- rel: {rel: option_refs, target: material-MAT_000082, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000082", ref_key2: "USAGE.07"}, note: "아트지 300g"}
- props: {opt_grp_cd: OPT_000045, sel_typ_cd: "SEL_TYPE.01", mand_yn: Y, note: "종이 택1 필수. ref OPT_REF_DIM.03 mat_cd+usage_cd. 자재=가격 차원(use_dims mat_cd)"}

### [optgroup-032-coating] 코팅 (택1 선택) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000032
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000032,OPT_000046)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000014, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000014"}, note: "유광"}
- rel: {rel: option_refs, target: process-PROC_000015, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000015"}, note: "무광"}
- props: {opt_grp_cd: OPT_000046, sel_typ_cd: "SEL_TYPE.01", mand_yn: N, min_sel_cnt: 0, note: "코팅 택1 선택(코팅없음 센티넬 OPV_000181=option_item 0행). ref OPT_REF_DIM.04 공정. ★단/양면 면구분 파라미터 부재=[[#GAP_032_coat_side]]"}

### [optgroup-032-corner] 모서리 (택1 선택) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000032
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000032,OPT_000047)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000027, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000027"}, note: "직각"}
- rel: {rel: option_refs, target: process-PROC_000028, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000028"}, note: "둥근"}
- props: {opt_grp_cd: OPT_000047, sel_typ_cd: "SEL_TYPE.01", mand_yn: N, min_sel_cnt: 0, note: "모서리 택1 선택(직각 dflt). ref OPT_REF_DIM.04 공정 027/028"}

## 결정·공백 (교정 이력·미확정)

### [DEC_namecard032_wiring_260630] 명함 고아 component→PRF_NAMECARD_COAT 배선 COMMIT {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거=라이브 바인딩 note + 배선 원장)
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000032,PRF_NAMECARD_COAT) note:'§29 배선교정 260630 — 스탠다드 저청구 해소'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "명함 고아 component 배선(032 코팅 저청구·031 견적0)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- rel: {rel: decided_because, target: component-COMP_NAMECARD_COAT_S1, note: "단면 완제품가(용지포함) 배선"}
- rel: {rel: decided_because, target: component-COMP_NAMECARD_COAT_S2, note: "양면 완제품가(용지포함) 배선"}
- props: {일자: "2026-06-30", 내용: "명함 완제품가 단가행(용지포함)이 적재됐으나 공식 미배선(고아)→저청구. PRF_NAMECARD_COAT 배선 COMMIT으로 해소(단가행 존재≠배선완료 교훈)", 인접: "031 견적0 동시 교정"}

### [GAP_032_coat_side] 코팅 단면/양면 면 구분 파라미터 부재 {unknown}
- type: gap
- anchor: none  # 사유: 옵션 모델에 coat_side_cnt 파라미터 없음(라이브 opt_grp note 실측 플래그)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000032,OPT_000046) note:'단/양면 면구분=GAP-PARAM'", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "코팅(유광/무광)을 어느 면에 적용하는지(단면/양면 coat_side_cnt) 파라미터가 032 옵션 모델에 없음. 코팅명함 고정가(use_dims mat_cd/min_qty/print_opt_cd)엔 코팅 면수 차원 없어 가격 무영향이나, 옵션 표현으로는 공백"
- gap_fill_from: "실무진 확인 + 폼빌더 파라미터(§31 제약규칙 하네스)로 면수 파라미터 정형화 여부 결정"
- gap_owner: staff
- rel: {rel: references, target: optgroup-032-coating, note: "이 옵션 그룹의 면수 파라미터 공백"}

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): t_prd_products(PRD_000032)·t_prd_product_sizes(2행)·t_prd_product_materials(2행 USAGE.07)·t_prd_product_print_options(2행 POPT_000001/002)·t_prd_product_processes(4행 014/015/027/028 mand=N)·t_prd_product_plate_sizes(1행 SIZ_000499 OUTPUT_PAPER_TYPE.01)·t_prd_product_option_groups(4행)·t_prd_product_option_items(8행)·t_prd_product_options(9행)·t_prd_product_price_formulas(PRF_NAMECARD_COAT)·t_prd_product_bundle_qtys(0행)·t_prd_product_addons(0행)·t_prd_product_constraints(0행).
- `_workspace/huni-ontology-kb/01_curation/pack-digital-print.md` (§3.1 정체·§3.3 도수=printopt·§3.11 명함 배선교정·§3.4 수량규칙).
- 수치 전사: `_meta/scripts/transcribe_namecard032.py`(사이즈·수량 스칼라).
