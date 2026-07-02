---
id: product-031-premium-namecard
type: product
anchor: t_prd_products/PRD_000031
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000031", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 명함 정체·§3.3 도수=printopt·§3.6 박=공정·§3.11 명함 배선교정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N)"}
  # 차원 — 사이즈 (R2 has_size — 008/133=공유 축 재사용·009=companion 신설)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm(dflt)"}
  - {rel: has_size, target: size-SIZ_000009, note: "90x55mm(companion 신설)"}
  - {rel: has_size, target: size-SIZ_000133, note: "86x52mm"}
  # 자재 (R3 uses_material — 14종·USAGE.07 단일 슬롯. 프리미엄 지질=weight-특정 child 코드)
  - {rel: uses_material, target: material-MAT_000101, note: "랑데뷰 WH 240g(dflt)"}
  - {rel: uses_material, target: material-MAT_000102, note: "랑데뷰 WH 310g"}
  - {rel: uses_material, target: material-MAT_000108, note: "몽블랑 210g"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g"}
  - {rel: uses_material, target: material-MAT_000123, note: "띤또레또 200g"}
  - {rel: uses_material, target: material-MAT_000124, note: "띤또레또 250g"}
  - {rel: uses_material, target: material-MAT_000347, note: "아코팩 웜화이트 250g(upr MAT_000113)"}
  - {rel: uses_material, target: material-MAT_000348, note: "리사이클러스 240g(upr MAT_000114)"}
  - {rel: uses_material, target: material-MAT_000349, note: "매쉬멜로우 233g(upr MAT_000115)"}
  - {rel: uses_material, target: material-MAT_000350, note: "린넨커버 216g(upr MAT_000116)"}
  - {rel: uses_material, target: material-MAT_000351, note: "스타화이트 238g(upr MAT_000117)"}
  - {rel: uses_material, target: material-MAT_000353, note: "클래식 크래스트 270g(upr MAT_000118)"}
  - {rel: uses_material, target: material-MAT_000356, note: "한지 170g(upr MAT_000125)"}
  - {rel: uses_material, target: material-MAT_000357, note: "스코트랜드 220g(upr MAT_000126)"}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005 4도)"}
  # 공정 (R5 has_process — 전부 mand_proc_yn=N·모서리/가변/박색 자식공정·공유 축+027 companion 재사용)
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각(모서리)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근(모서리)"}
  - {rel: has_process, target: process-PROC_000031, qualifier: {mand: N}, note: "가변텍스트"}
  - {rel: has_process, target: process-PROC_000032, qualifier: {mand: N}, note: "가변이미지"}
  - {rel: has_process, target: process-PROC_000037, qualifier: {mand: N}, note: "홀로그램(특수박)"}
  - {rel: has_process, target: process-PROC_000038, qualifier: {mand: N}, note: "금유광(일반박)"}
  - {rel: has_process, target: process-PROC_000039, qualifier: {mand: N}, note: "은유광(일반박)"}
  - {rel: has_process, target: process-PROC_000040, qualifier: {mand: N}, note: "먹유광(일반박)"}
  - {rel: has_process, target: process-PROC_000041, qualifier: {mand: N}, note: "동박(일반박)"}
  - {rel: has_process, target: process-PROC_000042, qualifier: {mand: N}, note: "적박(일반박)"}
  - {rel: has_process, target: process-PROC_000043, qualifier: {mand: N}, note: "청박(일반박)"}
  - {rel: has_process, target: process-PROC_000044, qualifier: {mand: N}, note: "트윙클(특수박)"}
  # 판형 (R6 has_plate_size — 종이류만·공유 축 국전·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "SIZ_000499 출력용지·OUTPUT_PAPER_TYPE.01"}
  # 가격 (R8 priced_by — 두 공식·companion 신설: 등급가 기본 + 박 분기)
  - {rel: priced_by, target: formula-PRF_NAMECARD_PREMIUM, note: "박 미선택 등급가"}
  - {rel: priced_by, target: formula-PRF_NAMECARD_PREMIUM_FOIL, note: "박 선택 재바인딩"}
  # CPQ 옵션 그룹 (R10 has_option_group — 하위 노드 5)
  - {rel: has_option_group, target: optgroup-031-print}
  - {rel: has_option_group, target: optgroup-031-paper}
  - {rel: has_option_group, target: optgroup-031-corner}
  - {rel: has_option_group, target: optgroup-031-postpress}
  - {rel: has_option_group, target: optgroup-031-foil}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모 미등록)
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  archetype_price: "고정가(등급가·용지포함)+박 분기"
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). t_prd_product_bundle_qtys 행 0"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3]
tags: [디지털인쇄, 명함, 고정가, 박]
updated: 2026-07-03
---

# 상품: 프리미엄명함 (PRD_000031)

프리미엄명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·SOT: 완제품=셋트 아닌 단일
제조상품·`t_prd_product_sets` 부모 미등록). 명함 카테고리에서 스탠다드(033)·코팅(032) 위의 **고급
지질·박 가공** 라인이다. 사이즈 3종(90×50 dflt·90×55·86×52)·칼라 단/양면·프리미엄 지질 14종·
후가공은 모서리(직각/둥근)·가변데이터(텍스트/이미지)·**박(박칼라 8종)**을 손님이 고른다. 파일
업로드형(editor_yn=N). 최소 100매·100매 증분·최대 10,000매(QTY_UNIT.02 "매").

**가격 아키타입 = 고정가(등급가·용지포함) + 박 분기** — 명함 형제(032/033)처럼 원자합산형(엽서
PRF_DGP_A)이 아니라 **완제품가(용지·인쇄 포함) 단가표**로 계산한다. 그래서 별도 base 인쇄공정
(PROC_000004)을 `has_process`에 두지 않는다(인쇄비가 등급가 component에 포함·032/033 동형·결함 아님).
가격 값 차원(use_dims)은 `[mat_cd, print_opt_cd, min_qty]` — 지질 등급·단/양면·수량으로 갈린다.
박(박칼라) 선택 시 공식이 `PRF_NAMECARD_PREMIUM`→`PRF_NAMECARD_PREMIUM_FOIL`로 재바인딩되어 소형
동판셋업+일반박/특수박 가공비가 더해진다([[product-031-premium-namecard-nodes#formula-PRF_NAMECARD_PREMIUM_FOIL]]).
가격 값 계산은 `evaluate_price` 단일 권위([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 배선까지(D-18).

**가격 경로(priced_by→공식→has_component→차원):** product-031 --priced_by--> `PRF_NAMECARD_PREMIUM`
(+박 분기 `_FOIL`) --has_component--> 등급가 4구성요소(S1/S2×MGA/MGB·use_dims mat_cd/print_opt_cd/min_qty)
[+박 3구성요소]. 두 공식 모두 `has_component ≥1`(고아 공식 0). 골든 스냅샷=live 20260702_1119 기준(값 미기록).

**배선교정 이력:** 프리미엄 등급가 단가행이 적재됐으나 공식 미배선(고아)이어서 견적 0이었고,
2026-06-30 `PRF_NAMECARD_PREMIUM` 배선 + 2026-07-01 박 분기 `PRF_NAMECARD_PREMIUM_FOIL` +
가변/귀돌이 구성요소 추가 COMMIT으로 해소([[#DEC_namecard031_wiring_260630]]·[[rule/rules#RULE_dataline_neq_wiring]]).

## 명함 사이즈·자재·공정 (전사·재사용)

사이즈 3종 중 SIZ_000008(90×50)·SIZ_000133(86×52)은 공유 `axis/sizes.md`, SIZ_000009(90×55)는
companion([[product-031-premium-namecard-nodes#size-SIZ_000009]]). 자재 14종·박색 자식공정
(PROC_000037~044)·모서리/가변 공정은 공유 축(axis) 또는 형제 companion(product-027-nodes)에서 재사용하며,
공유에 없던 프리미엄 지질 5종(102/124/351/353/357)·공식 2종·구성요소 7종만 companion에 신설했다
(중복 정의 금지·L-3). 치수·자재사양·공식배선 전사표는 companion·transcribe_product_031.py 산출에 유지.

<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000031 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | qty_unit_typ_cd |
|---|---|---|---|
| 100 | 10000 | 100 | QTY_UNIT.02 |

> 수량규칙은 **상품 레벨 스칼라**(min/max/incr·단위 QTY_UNIT.02 "매")로 실린다. 031은
> `t_prd_product_bundle_qtys` 행이 0개 → 별도 bundle_qty 노드 미생성·has_qty_rule 엣지 없음(정상·팩 §3.4).

---

<!-- 이하: PRD_000031 전용 하위 노드(공유 축·companion에 없는 것 = 옵션그룹·GAP·결정). -->
<!-- 공유 축(사이즈·자재·공정·도수·판형·카테고리)+companion 공식/구성요소는 위 relations로 재사용. -->

## CPQ 옵션 그룹 (손님 선택 축 5)

> option_refs 다형참조는 option_item 단위(ref_key 한정자·R11). 앵커는 t_prd_product_option_groups의
> 키 컬럼(col0=prd_cd)이라 PRD_000031로 앵커하고 opt_grp_cd는 props에 기록(L-17 닫힌세계 정합·복합키
> 확증은 source_locator). ★[HARD] option_refs 타깃은 같은 부모 product 차원에 실재(L-18·fn_chk_opt_item_ref).

### [optgroup-031-print] 인쇄(도수) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000031
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000031,OPT_000039)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}, note: "단면=opt_id 1"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "2"}, note: "양면=opt_id 2"}
- props: {opt_grp_cd: "OPT_000039", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 1, max_sel_cnt: 1, mand_yn: "Y", note: "도수 단/양면 택1 필수. ref OPT_REF_DIM.06 opt_id(NOT clr_cd·[[rule/rules#RULE_dosu_is_printopt]])"}

### [optgroup-031-paper] 종이(자재) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000031
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000031,OPT_000040)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000149~163 ref_dim_cd:OPT_REF_DIM.03(14 활성·148/159 del_yn=Y 제외)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
# 직접참조 6종(옵션 ref_key1 = 상품 재고 자재 동일)
- rel: {rel: option_refs, target: material-MAT_000101, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000101", ref_key2: "USAGE.07"}, note: "랑데뷰240·OPV_000149"}
- rel: {rel: option_refs, target: material-MAT_000102, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000102", ref_key2: "USAGE.07"}, note: "랑데뷰310·OPV_000150"}
- rel: {rel: option_refs, target: material-MAT_000108, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000108", ref_key2: "USAGE.07"}, note: "몽블랑210·OPV_000151"}
- rel: {rel: option_refs, target: material-MAT_000109, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000109", ref_key2: "USAGE.07"}, note: "몽블랑240·OPV_000152"}
- rel: {rel: option_refs, target: material-MAT_000123, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000123", ref_key2: "USAGE.07"}, note: "띤또레또200·OPV_000160"}
- rel: {rel: option_refs, target: material-MAT_000124, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000124", ref_key2: "USAGE.07"}, note: "띤또레또250·OPV_000161"}
# 부모참조 8종(옵션 ref_key1 = 부모 family 코드·상품 재고 = weight-특정 child) → 타깃=child(L-18 정합)·ref_key1=live 부모·[[#GAP_031_paper_parent_child]]
- rel: {rel: option_refs, target: material-MAT_000347, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000113", ref_key2: "USAGE.07"}, note: "아코팩250·OPV_000153·live ref=부모MAT_000113→재고 child MAT_000347"}
- rel: {rel: option_refs, target: material-MAT_000348, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000114", ref_key2: "USAGE.07"}, note: "리사이클러스240·OPV_000154·부모MAT_000114→child MAT_000348"}
- rel: {rel: option_refs, target: material-MAT_000349, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000115", ref_key2: "USAGE.07"}, note: "매쉬멜로우233·OPV_000155·부모MAT_000115→child MAT_000349"}
- rel: {rel: option_refs, target: material-MAT_000350, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000116", ref_key2: "USAGE.07"}, note: "린넨커버216·OPV_000156·부모MAT_000116→child MAT_000350"}
- rel: {rel: option_refs, target: material-MAT_000351, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000117", ref_key2: "USAGE.07"}, note: "스타화이트238·OPV_000157·부모MAT_000117→child MAT_000351"}
- rel: {rel: option_refs, target: material-MAT_000353, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000118", ref_key2: "USAGE.07"}, note: "클래식크래스트270·OPV_000158·부모MAT_000118→child MAT_000353"}
- rel: {rel: option_refs, target: material-MAT_000356, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000125", ref_key2: "USAGE.07"}, note: "한지170·OPV_000162·부모MAT_000125→child MAT_000356"}
- rel: {rel: option_refs, target: material-MAT_000357, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000126", ref_key2: "USAGE.07"}, note: "스코트랜드220·OPV_000163·부모MAT_000126→child MAT_000357"}
- props: {opt_grp_cd: "OPT_000040", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 1, max_sel_cnt: 1, mand_yn: "Y", note: "지질 14종 택1 필수·USAGE.07. 6종 직접참조 + 8종 부모→child(가격 등급 A/B는 mat_cd 단가표가 판정). 앙상블210(OPV_000148)·리브스디자인250(OPV_000159)=del_yn=Y(비활성 제외)"}

### [optgroup-031-corner] 모서리 택1 선택 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000031
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000031,OPT_000041)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000027, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000027"}, note: "직각(dflt)"}
- rel: {rel: option_refs, target: process-PROC_000028, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000028"}, note: "둥근"}
- props: {opt_grp_cd: "OPT_000041", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 0, max_sel_cnt: 1, mand_yn: "N", note: "직각/둥근 택1 선택(비필수)·ref 공정 .04"}

### [optgroup-031-postpress] 후가공(가변데이터) 택N 다중 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000031
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000031,OPT_000042)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000031, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000031"}, note: "가변텍스트"}
- rel: {rel: option_refs, target: process-PROC_000032, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000032"}, note: "가변이미지"}
- props: {opt_grp_cd: "OPT_000042", opt_grp_nm: "후가공", sel_typ_cd: "SEL_TYPE.02", min_sel_cnt: 0, max_sel_cnt: 2, mand_yn: "N", note: "가변텍스트/가변이미지 택N(최대2)·줄수/개수 파라미터 미보존([[#gap-031-vardata-param]])"}

### [optgroup-031-foil] 박칼라 택1 선택 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000031
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000031,OPT_000043)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000169~176 ref_dim_cd:OPT_REF_DIM.04(박없음 OPV_000168=참조없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000037, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000037"}, note: "홀로그램(특수박)·OPV_000169"}
- rel: {rel: option_refs, target: process-PROC_000038, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000038"}, note: "금유광(일반박)·OPV_000170"}
- rel: {rel: option_refs, target: process-PROC_000039, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000039"}, note: "은유광(일반박)·OPV_000171"}
- rel: {rel: option_refs, target: process-PROC_000040, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000040"}, note: "먹유광(일반박)·OPV_000172"}
- rel: {rel: option_refs, target: process-PROC_000041, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000041"}, note: "동박(일반박)·OPV_000173"}
- rel: {rel: option_refs, target: process-PROC_000042, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000042"}, note: "적박(일반박)·OPV_000174"}
- rel: {rel: option_refs, target: process-PROC_000043, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000043"}, note: "청박(일반박)·OPV_000175"}
- rel: {rel: option_refs, target: process-PROC_000044, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000044"}, note: "트윙클(특수박)·OPV_000176"}
- props: {opt_grp_cd: "OPT_000043", opt_grp_nm: "박칼라", sel_typ_cd: "SEL_TYPE.01", min_sel_cnt: 0, max_sel_cnt: 1, mand_yn: "N", note: "박없음(OPV_000168·dflt·참조 차원 없음)+박색 8종→각 개별 공정(PROC_000037~044). 박 선택 시 공식=PRF_NAMECARD_PREMIUM_FOIL 재바인딩. [[rule/gaps#GAP_foil_parent_children]] 구체 실현형(옵션풀+개별공정)"}

## 결정·공백 (교정 이력·미확정 — 정직 선언)

### [DEC_namecard031_wiring_260630] 프리미엄명함 고아 공식→배선 COMMIT(등급가+박 분기) {verified}
- type: decision
- anchor: none  # 사유: KB 전용 결정(근거=라이브 바인딩 note + 배선 원장)
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000031,PRF_NAMECARD_PREMIUM) note:'§29 배선교정 260630 — 프리미엄 등급가(견적0 해소)'·(PRD_000031,PRF_NAMECARD_PREMIUM_FOIL) note:'§29 배선교정 260630 — 프리미엄 박분기'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/wiring/HANDOFF.md", source_locator: "명함 고아 component 배선(round22)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-wiring}
- rel: {rel: decided_because, target: component-COMP_NAMECARD_PREMIUM_S1_MGA, note: "등급 A 단면 배선"}
- rel: {rel: decided_because, target: component-COMP_FOIL_SETUP_SMALL, note: "박 분기 소형 동판셋업 배선(07-01)"}
- props: {일자: "2026-06-30~07-01", 내용: "프리미엄 등급가 단가행이 적재됐으나 공식 미배선(고아)→견적0. PRF_NAMECARD_PREMIUM 등급가 4구성요소 배선(06-30) + PRF_NAMECARD_PREMIUM_FOIL 박 3구성요소 + 가변2/귀돌이(07-01) COMMIT으로 해소(단가행 존재≠배선완료 교훈)"}

### [GAP_031_paper_parent_child] 종이옵션 부모참조 ↔ 상품재고 child-자재 불일치 {unknown}
- type: gap
- anchor: none  # 사유: 8 프리미엄 지질에서 옵션 ref_key1=부모 family 코드 vs 상품 재고=weight-특정 child 코드
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000153~158/162/163 ref_key1:MAT_000113~118/125/126(부모)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "PRD_000031 mat_cd:MAT_000347~357(child·upr=113~126)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "종이 옵션 8종(아코팩/리사이클러스/매쉬멜로우/린넨커버/스타화이트/클래식크래스트/한지/스코트랜드)의 option_item ref_key1이 부모 family 코드(MAT_000113~118/125/126)를 가리키는데, 상품이 실제 재고하는 자재(t_prd_product_materials)와 등급가 단가표(use_dims mat_cd)는 weight-특정 child 코드(MAT_000347~357). 부모참조가 child 단가행으로 환원되는지(fn_chk_opt_item_ref·evaluate_price mat_cd 매칭) 미확인 — 미환원 시 8지질 견적 미스 가능. ★형제 027은 종이 옵션이 child 코드를 직접 참조(정합)이나 031은 부모 참조(더 오래된 옵션 배선)"
- gap_fill_from: "실무진/§17 표시중복 정리 + §21 옵션→차원 정합 검증(부모→child 환원 규칙 확정 또는 option_item ref_key1을 child로 재적재). 라이브 시뮬레이터 8지질 견적 실측이 판정 게이트"
- gap_owner: staff
- rel: {rel: references, target: optgroup-031-paper, note: "이 옵션 그룹 8지질의 부모/child 참조 불일치"}

### [gap-031-vardata-param] 가변데이터 줄수·개수 파라미터 미보존 {unknown}
- type: gap
- anchor: none  # 사유: 후가공 가변텍스트/이미지 줄수·개수 파라미터가 옵션 정형 shape에 보존되지 않음
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000031,OPT_000042) 후가공 그룹", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "가변텍스트/가변이미지 후가공의 줄수·개수(수량) 파라미터 — 옵션 정형 shape에 보존 불가(가격 영향 가능축·COMP_PP_VARTEXT/VARIMG use_dims min_qty). 033·041 동형 GAP"
- gap_fill_from: "위젯/폼빌더 파라미터 입력 스펙(§6/§31) 또는 실무진 확인"
- gap_owner: staff
- rel: {rel: derived_from, target: process-PROC_000031}

## 끊긴 경로·미해결 (정직 선언)

- **종이 부모/child 참조 불일치**: 위 [[#GAP_031_paper_parent_child]] — 8 프리미엄 지질에서 옵션이
  부모 family 코드를 참조하나 상품 재고·단가표는 child 코드. 가격 환원 여부 미확인(⚪·§17/§21 판정).
- **가변데이터 파라미터 GAP**: [[#gap-031-vardata-param]] — 줄수/개수 미보존(033/041 동형).
- **박 부모/자식 옵션풀 통일 미결**: [[rule/gaps#GAP_foil_parent_children]] — 031은 옵션풀+개별공정으로
  실현(027 동형)이나 전 상품 통일 여부는 미결(GAP 참조만·여기 재정의 금지·L-3).
- **수량규칙 노드 부재**: `t_prd_product_bundle_qtys` 행 0 → bundle_qty 노드(E8) 미생성. 상품 스칼라로만 표현(정상).
- **제약규칙 없음**: `t_prd_product_constraints` PRD_000031 행 0. 박×지질(특수박 발색)·박×사이즈 물리제약이
  도메인상 있을 수 있으나 현재 등록 정형 제약 없음(결함 아님·§31 CN-1~CN-6 소관·여기서 제약 노드 미생성).
- **추가상품 없음**: `t_prd_product_addons` 행 0 → `has_addon` 없음.

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): `t_prd_products`(PRD_000031 정체·수량)·`t_prd_product_sizes`(SIZ_000008/009/133)·`t_prd_product_materials`(14종 USAGE.07)·`t_prd_product_print_options`(POPT_000001/002)·`t_prd_product_processes`(12종 037~044/027/028/031/032 mand=N)·`t_prd_product_plate_sizes`(SIZ_000499)·`t_prd_product_price_formulas`(PRF_NAMECARD_PREMIUM·_FOIL 2바인딩)·`t_prd_product_option_groups/options/option_items`(OPT_000039~043 5그룹·활성 option_items)·`t_prd_product_categories`(CAT_000003/313)·`t_prd_product_bundle_qtys`/`addons`/`constraints`(0행) — 전사=`_meta/scripts/transcribe_product_031.py`(cache/transcribed-031-260703.json).
- `01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd)·§3.5(자재 USAGE.07·IMPORT 삭제금지)·§3.6(박=공정)·§3.11(명함 배선교정).
- 공유 축·companion 노드: `axis/sizes.md`(008/133)·`axis/materials.md`(101/109)·`axis/processes.md`(027/028/031/032)·`axis/print-options.md`·`axis/plate-sizes.md`·`axis/categories.md`·`product-027-nodes.md`(108/347/348/349/350/123/356·PROC_000037~044)·`formula/digital-components.md`(COMP_PP_VARTEXT/VARIMG/CORNER_RIGHT)·[[product-031-premium-namecard-nodes]](신설 사이즈1·자재5·공식2·구성요소7).
