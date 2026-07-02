<!-- product-scoped supplement: PRD_000041(스탠다드 쿠폰/상품권)이 도입하는 신규 축 항목 + CPQ 옵션그룹 + GAP. -->
<!-- ★공유 axis/*·index.md 수정 금지 제약 하에, 041이 새로 쓰는 축 멤버(사이즈 013/014·자재 072/078/088/105·공정 031/032)를 -->
<!--    이 상품 전용 하위 노드로 선언한다(중복 아님 — 공유 axis에 미등재). 향후 공유 axis 흡수 제안은 index_entries/open_questions로 반환. -->
<!-- ★수치·연결은 _meta/scripts/transcribe_product_041.py 전사(transcribed-by 마커)에서 옮긴 것·LLM 손전사 금지(D-9). -->

# product-041-coupon 축 보강 (PRD_000041 전용 신규 축 멤버 · CPQ)

041이 도입하는, 공유 축 노드(axis/)에 아직 없는 항목만 여기 선언한다. 이미 있는 축(오시
PROC_000029·미싱 PROC_000030·단면/양면 POPT·국전 판형·카테고리 CAT_000062·공식 PRF_DGP_A)은
재사용(중복 생성 금지)하고, 상품 노드가 그리로 연결한다.

## 통합 전사표 (권위 = 라이브 스냅샷)

<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt |
|---|---|---|---|---|
| SIZ_000013 | 148x68 | 152x72 | 148x68 | Y |
| SIZ_000014 | 148x75 | 158x77 | 148x75 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | usage_cd | dflt |
|---|---|---|---|
| MAT_000072 | 백색모조지 100g | USAGE.07 | Y |
| MAT_000078 | 아트지 150g | USAGE.07 | Y |
| MAT_000088 | 스노우지 150g | USAGE.07 | Y |
| MAT_000105 | 몽블랑 130g | USAGE.07 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand | disp_seq | 부모공정 |
|---|---|---|---|---|
| PROC_000029 | 오시 | N | 10 | - |
| PROC_000030 | 미싱 | N | 11 | - |
| PROC_000031 | 가변텍스트 | N | 12 | PROC_000085 |
| PROC_000032 | 가변이미지 | N | 13 | PROC_000085 |
| PROC_000004 | 디지털인쇄 | Y | -1 | PROC_000001 |

<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min | max | mand | disp |
|---|---|---|---|---|---|---|
| OPT_000052 | 인쇄 | SEL_TYPE.01 | 1 | 1 | Y | 1 |
| OPT_000053 | 종이 | SEL_TYPE.01 | 1 | 1 | Y | 2 |
| OPT_000054 | 후가공 | SEL_TYPE.02 | 0 | 4 | N | 3 |

<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_cd | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|
| OPV_000197 | OPT_REF_DIM.06 | 1 | - |
| OPV_000198 | OPT_REF_DIM.06 | 2 | - |
| OPV_000199 | OPT_REF_DIM.03 | MAT_000072 | USAGE.07 |
| OPV_000200 | OPT_REF_DIM.03 | MAT_000078 | USAGE.07 |
| OPV_000201 | OPT_REF_DIM.03 | MAT_000088 | USAGE.07 |
| OPV_000202 | OPT_REF_DIM.03 | MAT_000105 | USAGE.07 |
| OPV_000203 | OPT_REF_DIM.04 | PROC_000029 | - |
| OPV_000204 | OPT_REF_DIM.04 | PROC_000030 | - |
| OPV_000205 | OPT_REF_DIM.04 | PROC_000031 | - |
| OPV_000206 | OPT_REF_DIM.04 | PROC_000032 | - |

---

## 신규 사이즈 (E3 size)

### [size-SIZ_000013] 148x68 (상품권) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000013
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000013", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000013", note: "041 쿠폰/상품권 사이즈. 공유 axis/sizes.md 미등재 → 흡수 제안(index_entries)"}

### [size-SIZ_000014] 148x75 (상품권) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000014
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000014", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000014", note: "041 쿠폰/상품권 사이즈. 라이브에서 013·014 둘 다 dflt_yn=Y(기본 중복) — open_question"}

## 신규 자재 (E4 material) — 전부 USAGE.07 공통 슬롯

### [material-MAT_000072] 백색모조지 100g {verified}
- type: material
- anchor: t_mat_materials/MAT_000072
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000072", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000072", 사용: "041 종이 옵션(USAGE.07)"}

### [material-MAT_000078] 아트지 150g {verified}
- type: material
- anchor: t_mat_materials/MAT_000078
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000078", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000078", 사용: "041 종이 옵션(USAGE.07)"}

### [material-MAT_000088] 스노우지 150g {verified}
- type: material
- anchor: t_mat_materials/MAT_000088
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000088", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000088", 사용: "041 종이 옵션(USAGE.07)"}

### [material-MAT_000105] 몽블랑 130g {verified}
- type: material
- anchor: t_mat_materials/MAT_000105
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000105", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000105", 사용: "041 종이 옵션(USAGE.07)·MAT_000101 랑데뷰와 별개"}

## 공정 (E6 process) — 가변텍스트/가변이미지 = 공유 축 등재 완료 (R2 해소)

> ★041 후가공은 라이브에서 가변텍스트(PROC_000031)·가변이미지(PROC_000032) 두 공정을 참조한다(위 전사표).
> 이 둘은 **가변데이타(PROC_000085·[[axis/processes#process-PROC_000085]])의 자식**이며, 병렬 빌더 L-3 중복 실측 때문에
> R1 시점엔 공유 `axis/processes.md` 미등재라 041이 부모 085로 접었었다. **260703 공유 축 승격으로 031/032가 verified
> 노드로 등재**되어, R2에서 041 has_process·optgroup-041-finish option_refs를 **라이브 실코드(031/032) 그대로 직접
> 배선**했다(형제 033/027 동일 패턴). ★부모 085 접기 폐기 이유: `PROC_000085`는 라이브 `t_prd_product_processes`에
> 상품 바인딩 0건 — has_process로 쓰면 라이브 부재값을 배선(환각)하고 fn_chk_opt_item_ref 부모정합도 깨진다.
> 가격측 `proc_grp:PROC_000085`(단가행 차원)는 별개로 공식/구성요소 노드가 유지한다.

## CPQ 옵션그룹 (E11 option_group)

> 앵커 규약(junction-키·016 방식으로 통일·V1-03 교정): `t_prd_product_option_groups`는 junction(col0=prd_cd)이라
> 빌더 L-17 닫힌세계 검사는 **부모 prd_cd**(PRD_000041) 실재까지 검증한다. 복합키 `opt_grp_cd`(OPT_000052 등)는
> L-17 범위 밖이므로 **sources 전사로 확증**(각 옵션그룹 src의 `키:(PRD_000041,OPT_00005x)`).
> 앵커 = `t_prd_product_option_groups/PRD_000041`(부모측 실재) + 복합키 sources 확증 = 016 옵션그룹과 동일 규약
> (ontology-schema §1.0 junction 앵커 규약 명문화).

### [optgroup-041-print] 인쇄(도수) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000041
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000041,OPT_000052)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "opt_id=1"}, note: "단면(OPV_000197)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "opt_id=2"}, note: "양면(OPV_000198)"}
- props: {opt_grp_cd: "OPT_000052", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01(택1)", min_sel: 1, max_sel: 1, mand_yn: Y, disp_seq: 1, ref_dim: "OPT_REF_DIM.06=opt_id(★NOT clr_cd)"}
- 본문: 인쇄(도수) 택1 필수. ref_dim .06 opt_id → 상품 print_options 행(단면 POPT_000001·양면 POPT_000002). 도수=print_opt_cd([[rule/rules#RULE_dosu_is_printopt]]).

### [optgroup-041-paper] 종이(자재) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000041
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000041,OPT_000053)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000072, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000072", ref_key2: "USAGE.07"}, note: "OPV_000199"}
- rel: {rel: option_refs, target: material-MAT_000078, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000078", ref_key2: "USAGE.07"}, note: "OPV_000200"}
- rel: {rel: option_refs, target: material-MAT_000088, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000088", ref_key2: "USAGE.07"}, note: "OPV_000201"}
- rel: {rel: option_refs, target: material-MAT_000105, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000105", ref_key2: "USAGE.07"}, note: "OPV_000202"}
- props: {opt_grp_cd: "OPT_000053", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01(택1)", min_sel: 1, max_sel: 1, mand_yn: Y, disp_seq: 2, ref_dim: "OPT_REF_DIM.03=mat_cd+usage_cd"}
- 본문: 종이(자재) 택1 필수. 4종 자재 옵션참조(전부 USAGE.07). 옵션참조 자재는 상품에 실재(uses_material 정합·fn_chk_opt_item_ref).

### [optgroup-041-finish] 후가공 택N(0~4) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000041
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000041,OPT_000054)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000029, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000029"}, note: "오시(OPV_000203)"}
- rel: {rel: option_refs, target: process-PROC_000030, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000030"}, note: "미싱(OPV_000204)"}
- rel: {rel: option_refs, target: process-PROC_000031, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000031"}, note: "가변텍스트(OPV_000205·R2 라이브 부합 배선)"}
- rel: {rel: option_refs, target: process-PROC_000032, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000032"}, note: "가변이미지(OPV_000206·R2 라이브 부합 배선)"}
- props: {opt_grp_cd: "OPT_000054", opt_grp_nm: "후가공", sel_typ_cd: "SEL_TYPE.02(택N)", min_sel: 0, max_sel: 4, mand_yn: N, disp_seq: 3, ref_dim: "OPT_REF_DIM.04=proc_cd", live_items: "오시029·미싱030·가변텍스트031·가변이미지032(전사표)", model_note: "031/032 공유축 승격(260703)으로 opt_item(OPV_000205/206) 실코드 그대로 직접 배선·부모접기 폐기", param_gap: "줄수/개수 미보존→GAP_finish_param_041"}
- 본문: 후가공 택N(0~4 동시). 라이브 opt_item 4종=오시·미싱·가변텍스트·가변이미지(전사표가 진실). 그래프 option_refs는 opt_item 실코드 그대로 029/030/031/032에 배선(R2 교정·부모 PROC_000085 접기 폐기 — 085는 라이브 상품 바인딩 0건이라 fn_chk_opt_item_ref/부모 has_process 정합 불가). 031/032는 260703 공유 [[axis/processes]] 축 승격 노드. ★줄수(오시/미싱)·개수(가변) 세부 파라미터는 옵션에 보존 안 됨([[GAP_finish_param_041]]).

## GAP (원천 부재·미확정)

### [GAP_finish_param_041] 041 후가공 줄수/개수 파라미터 보존불가 {unknown}
- type: gap
- anchor: none  # 사유: CPQ 옵션이 공정 택N만 표현·줄수/개수 수치 차원 미보존(GAP-PARAM)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000041,OPT_000054) note:줄수/개수=GAP-PARAM 보존불가", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "041 후가공(오시/미싱 줄수·가변텍스트/이미지 개수) 세부 파라미터 — 옵션그룹이 공정 택N만 담고 줄수/개수 수치 차원을 보존하지 못함"
- gap_fill_from: "옵션 파라미터 모델 설계(줄수/개수 차원 추가)·실무진 확인 — 여러 디지털 상품 공통일 수 있어 일반화 검토(open_question)"
- gap_owner: 설계
- rel: {rel: references, target: optgroup-041-finish, note: "이 옵션그룹의 파라미터 보존 공백"}
