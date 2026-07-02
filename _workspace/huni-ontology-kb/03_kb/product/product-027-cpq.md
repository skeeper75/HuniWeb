<!-- companion CPQ nodes for product-027 2단접지카드 — 옵션그룹(E11)·제약(E12)·추가상품 GAP. -->
<!-- ★option_refs(R11) 타깃은 같은 부모 product-027에 실재해야 함(L-18·fn_chk_opt_item_ref 정합). -->
<!-- ★option_group anchor = t_prd_product_option_groups/PRD_000027 (col0=prd_cd·복합키의 정밀 좌표는 source_locator). -->

# product-027 CPQ 레이어 (2단접지카드 — 옵션그룹·제약·추가상품)

손님이 고르는 선택 축(옵션그룹) 5종 + 각 옵션값이 가리키는 실물 차원(option_refs). 접지카드는
인쇄(양면)·종이(14)·후가공(가변)·접지(가로/세로)·박칼라(8+없음) 5축으로 구성된다. ★옵션→차원
연결은 다형참조 `ref_dim_cd`(OPT_REF_DIM.03=자재·.04=공정·.06=인쇄옵션) + `ref_key1`으로
option_item 단위에 귀속된다(스키마 R11·한정자로 접음).

<!-- transcribed-by: _meta/scripts/transcribe_product_027.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups/options/option_items prd_cd=PRD_000027 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | mand | 옵션값(참조 차원) |
|---|---|---|---|---|
| OPT_000029 | 인쇄 | SEL_TYPE.01 | Y | 양면→OPT_REF_DIM.06:1 |
| OPT_000030 | 종이 | SEL_TYPE.01 | Y | 14종→OPT_REF_DIM.03:MAT_*(USAGE.07) |
| OPT_000031 | 후가공 | SEL_TYPE.02 | N | 가변텍스트→PROC_000031; 가변이미지→PROC_000032 |
| OPT_000032 | 접지 | SEL_TYPE.01 | Y | 2단가로접지→PROC_000065; 2단세로접지→PROC_000066 |
| OPT_000033 | 박칼라 | SEL_TYPE.01 | N | 박없음(참조없음); 홀로그램→PROC_000037 … 트윙클→PROC_000044 (8종) |

> sel_typ: SEL_TYPE.01=단일선택 · SEL_TYPE.02=다중선택. mand=필수 여부.
> OPT_000029 인쇄는 옵션값이 "양면" 1개(양면 전용 상품·POPT_000002)라 사실상 고정.
> OPT_000033 박칼라의 "박없음"(OPV_000109)은 참조 차원이 없다(공정 미부가=기본값).

---

### [optgroup-OPT_000029] 인쇄 (양면 고정) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000027
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000027+OPT_000029", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000029", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "옵션값 '양면' 1개(OPV_000090)→OPT_REF_DIM.06 ref_key1=1(인쇄옵션 opt_id)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}}

### [optgroup-OPT_000030] 종이 (14종) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000027
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000027+OPT_000030", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000091~104 ref_dim_cd:OPT_REF_DIM.03", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000030", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "종이 14종 단일선택·각 값→OPT_REF_DIM.03(자재)+USAGE.07. 백색모조지220(OPV_000091)=dflt"}
- rel: {rel: option_refs, target: material-MAT_000074, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000074", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000081, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000081", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000082, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000082", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000091, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000091", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000092, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000092", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000101, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000101", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000108, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000108", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000109, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000109", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000123, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000123", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000347, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000347", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000348, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000348", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000349, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000349", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000350, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000350", ref_key2: "USAGE.07"}}
- rel: {rel: option_refs, target: material-MAT_000356, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000356", ref_key2: "USAGE.07"}}

### [optgroup-OPT_000031] 후가공 (가변데이타·다중) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000027
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000027+OPT_000031", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000031", sel_typ_cd: "SEL_TYPE.02", mand_yn: "N", note: "다중선택·가변텍스트/가변이미지→OPT_REF_DIM.04(공정)"}
- rel: {rel: option_refs, target: process-PROC_000031, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000031"}}
- rel: {rel: option_refs, target: process-PROC_000032, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000032"}}

### [optgroup-OPT_000032] 접지 (가로/세로) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000027
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000027+OPT_000032", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000032", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "단일선택 필수·2단가로접지(dflt)/2단세로접지→OPT_REF_DIM.04(공정)"}
- rel: {rel: option_refs, target: process-PROC_000065, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000065"}}
- rel: {rel: option_refs, target: process-PROC_000066, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000066"}}

### [optgroup-OPT_000033] 박칼라 (8종+박없음) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000027
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000027+OPT_000033", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000110~117 ref_dim_cd:OPT_REF_DIM.04", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000033", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "박없음(OPV_000109·dflt·참조 차원 없음)+박색 8종→각 개별 공정(PROC_000037~044). [[rule/gaps#GAP_foil_parent_children]] 구체 실현형(옵션풀+개별공정)"}
- rel: {rel: option_refs, target: process-PROC_000037, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000037"}}
- rel: {rel: option_refs, target: process-PROC_000038, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000038"}}
- rel: {rel: option_refs, target: process-PROC_000039, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000039"}}
- rel: {rel: option_refs, target: process-PROC_000040, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000040"}}
- rel: {rel: option_refs, target: process-PROC_000041, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000041"}}
- rel: {rel: option_refs, target: process-PROC_000042, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000042"}}
- rel: {rel: option_refs, target: process-PROC_000043, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000043"}}
- rel: {rel: option_refs, target: process-PROC_000044, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000044"}}

---

## 제약 (constraint) — 현재 0건

live-snapshot 20260702_1119 실측: `t_prd_product_constraints`에서 PRD_000027 **활성(del_yn=N)
제약 0건**. 박칼라×종이(특수박이 특정 지질에서 발색 불가 등)나 접지×사이즈 물리제약이 도메인상
있을 수 있으나 현재 등록된 정형 제약규칙은 없다(§31 제약규칙 거버넌스 소관). 이는 결함이 아니라
"현재값"이며, 필요 제약 도출은 §31 트랙(CN-1~CN-6)이 판정한다. 여기서는 제약 노드를 만들지 않는다
(원천 부재 아님·"제약 없음"이 라이브 사실).

---

## 추가상품 (addon) — 봉투 3템플릿 (대상 상품 미노드 → GAP)

### [gap-027-addon-envelope] 봉투 addon 대상 상품 미노드 {unknown}
- type: gap
- anchor: none  # 사유: has_addon(R14)은 product→product인데 대상 봉투 상품이 아직 KB 노드 아님
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "prd_cd:PRD_000027 tmpl_cd:TMPL-000038/039/032", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_templates.csv", source_locator: "TMPL-000038 base_prd:PRD_000004·TMPL-000039 base_prd:PRD_000004·TMPL-000032 base_prd:PRD_000283", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "2단접지카드 addon = 카드봉투 화이트/블랙(TMPL-000038/039→PRD_000004)·트레싱지봉투(TMPL-000032→PRD_000283). has_addon 엣지는 대상 상품(PRD_000004/283)이 KB 노드가 돼야 배선 가능(F-7 template 접기)"
- gap_fill_from: "봉투 상품(PRD_000004 카드봉투·PRD_000283 트레싱지봉투) 노드 집필 후 product-027에 has_addon 배선. 봉투/케이스 세트 적재모델은 [[rule/gaps#GAP_envelope_set_model]]와 함께 결정"
- gap_owner: 설계
