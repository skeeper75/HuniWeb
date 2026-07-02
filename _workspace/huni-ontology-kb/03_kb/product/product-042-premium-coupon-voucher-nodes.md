<!-- product-scoped supplement: PRD_000042(프리미엄 쿠폰/상품권)이 도입하는 신규 축 항목 + CPQ 옵션그룹 + GAP. -->
<!-- ★공유 axis/*·formula/*·index.md 수정 금지 제약 하에, 042가 새로 쓰는 축 멤버(청정 자재 118/121·오염 자재 128/129/240/241)를 -->
<!--    이 상품 전용 하위 노드로 선언한다. 이미 mint된 노드(사이즈 013/014=041·박색 037~044=027-nodes·자재 107=023·125=028·공유 축)는 재사용(중복 생성 금지·L-3). -->
<!-- ★박 분기 공식 formula-PRF_DGP_A_FOIL은 공유 formula/ 소속이라 여기 mint하지 않고 needed_shared_nodes로 반환(통합 단계 mint). -->
<!-- ★수치·연결은 _meta/scripts/transcribe_product_042.py 전사(transcribed-by 마커)에서 옮긴 것·LLM 손전사 금지(D-9). -->

# product-042-premium-coupon-voucher 축 보강 (PRD_000042 전용 신규 축 멤버 · CPQ · GAP)

042가 도입하는, 공유 축 노드(axis/)에 아직 없는 항목만 여기 선언한다. 이미 있는 축(사이즈
SIZ_000013/014=041 mint·박색 037~044=027-nodes mint·자재 MAT_000107=023·MAT_000125=028·오시
029·미싱 030·가변 031/032·단면/양면 POPT·국전 판형·카테고리 CAT_000062·공식 PRF_DGP_A)은 재사용
(중복 생성 금지)하고, 상품 노드가 그리로 연결한다.

## 통합 전사표 (권위 = 라이브 스냅샷)

<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt |
|---|---|---|---|---|
| SIZ_000013 | 148x68 | 152x72 | 148x68 | Y |
| SIZ_000014 | 148x75 | 158x77 | 148x75 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials+t_prd_product_options @ 2026-07-03 -->
| mat_cd | 마스터명(현재값) | mat_typ | 042 옵션의도 | 정답 mat_cd | usage | dflt |
|---|---|---|---|---|---|---|
| MAT_000107 | 몽블랑 190g | MAT_TYPE.01 | - | - | USAGE.07 | Y |
| MAT_000118 | 클래식 크래스트 | MAT_TYPE.01 | - | - | USAGE.07 | Y |
| MAT_000121 | 켄도 | MAT_TYPE.01 | - | - | USAGE.07 | Y |
| MAT_000125 | 한지 | MAT_TYPE.01 | - | - | USAGE.07 | Y |
| MAT_000128 🔴 | 면끈 | MAT_TYPE.17 | 스타드림(실버) 240g | MAT_000358 | USAGE.07 | Y |
| MAT_000129 🔴 | 아크릴키링고리 | MAT_TYPE.03 | 스타드림(골드) 240g | MAT_000359 | USAGE.07 | Y |
| MAT_000240 🔴 | 보드스탠딩 | MAT_TYPE.16 | 스타드림(다이아) 240g | MAT_000352 | USAGE.07 | Y |
| MAT_000241 🔴 | 핀버튼 | MAT_TYPE.12 | 스타드림(로츠쿼츠) 240g | MAT_000360 | USAGE.07 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand | disp_seq | 부모공정 |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | -1 | PROC_000001 |
| PROC_000029 | 오시 | N | 10 | - |
| PROC_000030 | 미싱 | N | 11 | - |
| PROC_000031 | 가변텍스트 | N | 12 | PROC_000085 |
| PROC_000032 | 가변이미지 | N | 13 | PROC_000085 |
| PROC_000037 | 홀로그램 | N | 1 | PROC_000033 |
| PROC_000038 | 금유광 | N | 1 | PROC_000033 |
| PROC_000039 | 은유광 | N | 1 | PROC_000033 |
| PROC_000040 | 먹유광 | N | 1 | PROC_000033 |
| PROC_000041 | 동박 | N | 1 | PROC_000033 |
| PROC_000042 | 적박 | N | 1 | PROC_000033 |
| PROC_000043 | 청박 | N | 1 | PROC_000033 |
| PROC_000044 | 트윙클 | N | 1 | PROC_000033 |

<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min | max | mand | disp |
|---|---|---|---|---|---|---|
| OPT_000055 | 인쇄 | SEL_TYPE.01 | 1 | 1 | Y | 1 |
| OPT_000056 | 종이 | SEL_TYPE.01 | 1 | 1 | Y | 2 |
| OPT_000057 | 후가공 | SEL_TYPE.02 | 0 | 4 | N | 3 |
| OPT_000058 | 박칼라 | SEL_TYPE.01 | 0 | 1 | N | 4 |

<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items+options @ 2026-07-03 -->
| opt_cd | 라벨 | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|
| OPV_000207 | 단면 | OPT_REF_DIM.06 | 1 | - |
| OPV_000208 | 양면 | OPT_REF_DIM.06 | 2 | - |
| OPV_000209 | 몽블랑 190g | OPT_REF_DIM.03 | MAT_000107 | USAGE.07 |
| OPV_000210 | 클래식 크래스트 스티플 270g | OPT_REF_DIM.03 | MAT_000118 | USAGE.07 |
| OPV_000211 | 켄도 250g | OPT_REF_DIM.03 | MAT_000121 | USAGE.07 |
| OPV_000212 | 한지 170g | OPT_REF_DIM.03 | MAT_000125 | USAGE.07 |
| OPV_000213 | 스타드림(실버) 240g | OPT_REF_DIM.03 | MAT_000128 | USAGE.07 |
| OPV_000214 | 스타드림(골드) 240g | OPT_REF_DIM.03 | MAT_000129 | USAGE.07 |
| OPV_000215 | 스타드림(다이아) 240g | OPT_REF_DIM.03 | MAT_000240 | USAGE.07 |
| OPV_000216 | 스타드림(로츠쿼츠) 240g | OPT_REF_DIM.03 | MAT_000241 | USAGE.07 |
| OPV_000217 | 오시 | OPT_REF_DIM.04 | PROC_000029 | - |
| OPV_000218 | 미싱 | OPT_REF_DIM.04 | PROC_000030 | - |
| OPV_000219 | 가변텍스트 | OPT_REF_DIM.04 | PROC_000031 | - |
| OPV_000220 | 가변이미지 | OPT_REF_DIM.04 | PROC_000032 | - |
| OPV_000222 | 홀로그램 | OPT_REF_DIM.04 | PROC_000037 | - |
| OPV_000223 | 금유광 | OPT_REF_DIM.04 | PROC_000038 | - |
| OPV_000224 | 은유광 | OPT_REF_DIM.04 | PROC_000039 | - |
| OPV_000225 | 먹유광 | OPT_REF_DIM.04 | PROC_000040 | - |
| OPV_000226 | 동박 | OPT_REF_DIM.04 | PROC_000041 | - |
| OPV_000227 | 적박 | OPT_REF_DIM.04 | PROC_000042 | - |
| OPV_000228 | 청박 | OPT_REF_DIM.04 | PROC_000043 | - |
| OPV_000229 | 트윙클 | OPT_REF_DIM.04 | PROC_000044 | - |

> ★박없음(OPV_000221)은 `t_prd_product_options`에만 있고 `t_prd_product_option_items` 참조행이 없다(박칼라 min0 센티넬 "선택안함") — option_refs 없음(정상·차원 참조 아님).

---

## 신규 자재 — 청정 종이 2종 (E4 material · MAT_TYPE.01)

> MAT_000107(몽블랑 190g)=[[product-023-shaped-postcard-nodes#material-MAT_000107]] 재사용, MAT_000125(한지 170g)=[[product-028-mini-folded-card-nodes#material-MAT_000125]] 재사용 (중복 mint 금지·L-3). 아래 2종만 042가 신규 선언.

### [material-MAT_000118] 클래식 크래스트 스티플 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000118
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000118", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 마스터명: "클래식 크래스트", 옵션라벨: "클래식 크래스트 스티플 270g", 사용: "042 종이 옵션(USAGE.07)·공유 축 승격 후보"}

### [material-MAT_000121] 켄도 250g {verified}
- type: material
- anchor: t_mat_materials/MAT_000121
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000121", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 마스터명: "켄도", 옵션라벨: "켄도 250g", 사용: "042 종이 옵션(USAGE.07)·공유 축 승격 후보"}

## 신규 자재 — 🔴오염 잔존 4종 (E4 material · 표시↔실제 불일치·양면 defect)

> ★이 4종은 042 종이 옵션이 "스타드림 240g 종이"로 표시하나, 라이브 자재 마스터가 **굿즈 부자재**(면끈/키링고리/보드/핀버튼)를 가리키는 **오적재 잔존**이다. 034 펄명함은 2026-06-30 동일 오염을 정리(del_yn=Y·정답 스타드림 MAT_000352/358/359/360 채택 — [[product-034-pearl-namecard#DEC_pearl034_material_260630]])했으나 **042는 미정리**. 자재 삭제가 아니라 올바른 mat_cd로 재배선 필요(§17 basedata-dedup·실무진·[[rule/rules#RULE_import_material_no_delete]]와 별개=명백한 굿즈 오적재).

### [material-MAT_000128] 면끈(현재값) ↔ 스타드림(실버) 240g(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000128
- badge: defect
- current_value: "MAT_000128 마스터명=면끈·mat_typ_cd=MAT_TYPE.17(굿즈 부자재) (live-snapshot 20260702_1119)"
- authority_value: "042 종이 옵션 OPV_000213 라벨=스타드림(실버) 240g(종이 MAT_TYPE.01) — 정답 mat_cd=MAT_000358(034가 2026-06-30 채택)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000128 + t_prd_product_options 키:(PRD_000042,OPV_000213) note:굿즈 오적재 잔존", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.17", 참조상품: "042 uses_material(오염) + 종이 옵션 OPV_000213"}
- rel: {rel: references, target: GAP_paper_material_042, note: "이 오염의 교정 owner"}

### [material-MAT_000129] 아크릴키링고리(현재값) ↔ 스타드림(골드) 240g(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000129
- badge: defect
- current_value: "MAT_000129 마스터명=아크릴키링고리·mat_typ_cd=MAT_TYPE.03(굿즈 부자재) (live-snapshot 20260702_1119)"
- authority_value: "042 종이 옵션 OPV_000214 라벨=스타드림(골드) 240g(종이 MAT_TYPE.01) — 정답 mat_cd=MAT_000359(034 채택)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000129 + t_prd_product_options 키:(PRD_000042,OPV_000214) note:굿즈 오적재 잔존", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.03", 참조상품: "042 uses_material(오염) + 종이 옵션 OPV_000214"}
- rel: {rel: references, target: GAP_paper_material_042, note: "이 오염의 교정 owner"}

### [material-MAT_000240] 보드스탠딩(현재값) ↔ 스타드림(다이아) 240g(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000240
- badge: defect
- current_value: "MAT_000240 마스터명=보드스탠딩·mat_typ_cd=MAT_TYPE.16(굿즈 부자재) (live-snapshot 20260702_1119)"
- authority_value: "042 종이 옵션 OPV_000215 라벨=스타드림(다이아) 240g(종이 MAT_TYPE.01) — 정답 mat_cd=MAT_000352(034 채택·마스터명 '스타드림(다이아몬드) 240g')"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000240 + t_prd_product_options 키:(PRD_000042,OPV_000215) note:굿즈 오적재 잔존", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", 참조상품: "042 uses_material(오염) + 종이 옵션 OPV_000215"}
- rel: {rel: references, target: GAP_paper_material_042, note: "이 오염의 교정 owner"}

### [material-MAT_000241] 핀버튼(현재값) ↔ 스타드림(로츠쿼츠) 240g(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000241
- badge: defect
- current_value: "MAT_000241 마스터명=핀버튼·mat_typ_cd=MAT_TYPE.12(굿즈 부자재) (live-snapshot 20260702_1119)"
- authority_value: "042 종이 옵션 OPV_000216 라벨=스타드림(로츠쿼츠) 240g(종이 MAT_TYPE.01) — 정답 mat_cd=MAT_000360(034 채택·마스터명 '스타드림(로즈쿼츠) 240g'·라벨 로츠/로즈 표기차)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000241 + t_prd_product_options 키:(PRD_000042,OPV_000216) note:굿즈 오적재 잔존", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.12", 참조상품: "042 uses_material(오염) + 종이 옵션 OPV_000216"}
- rel: {rel: references, target: GAP_paper_material_042, note: "이 오염의 교정 owner"}

## CPQ 옵션그룹 (E11 option_group)

> 앵커 규약(junction-키·016/041 방식): `t_prd_product_option_groups`는 junction(col0=prd_cd)이라 빌더 L-17 닫힌세계 검사는 **부모 prd_cd**(PRD_000042) 실재까지 검증한다. 복합키 `opt_grp_cd`(OPT_000055 등)는 L-17 범위 밖이므로 **sources 전사로 확증**(각 옵션그룹 src의 `키:(PRD_000042,OPT_00005x)`). option_refs 타깃은 전부 부모 042 차원(uses_material/has_process/has_print_option)에 실재(L-18·fn_chk_opt_item_ref 정합).

### [optgroup-042-print] 인쇄(도수) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000042
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000042,OPT_000055)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "opt_id=1"}, note: "단면(OPV_000207)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "opt_id=2"}, note: "양면(OPV_000208)"}
- props: {opt_grp_cd: "OPT_000055", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01(택1)", min_sel: 1, max_sel: 1, mand_yn: Y, disp_seq: 1, ref_dim: "OPT_REF_DIM.06=opt_id(★NOT clr_cd)"}
- 본문: 인쇄(도수) 택1 필수. ref_dim .06 opt_id → 상품 print_options 행(단면 POPT_000001·양면 POPT_000002). 도수=print_opt_cd([[rule/rules#RULE_dosu_is_printopt]]).

### [optgroup-042-paper] 종이(자재) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000042
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000042,OPT_000056)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000107, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000107", ref_key2: "USAGE.07"}, note: "몽블랑190g·OPV_000209(청정)"}
- rel: {rel: option_refs, target: material-MAT_000118, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000118", ref_key2: "USAGE.07"}, note: "클래식크래스트270g·OPV_000210(청정)"}
- rel: {rel: option_refs, target: material-MAT_000121, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000121", ref_key2: "USAGE.07"}, note: "켄도250g·OPV_000211(청정)"}
- rel: {rel: option_refs, target: material-MAT_000125, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000125", ref_key2: "USAGE.07"}, note: "한지170g·OPV_000212(청정)"}
- rel: {rel: option_refs, target: material-MAT_000128, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000128", ref_key2: "USAGE.07"}, note: "🔴OPV_000213 라벨=스타드림(실버)240g·타깃=면끈(오염)"}
- rel: {rel: option_refs, target: material-MAT_000129, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000129", ref_key2: "USAGE.07"}, note: "🔴OPV_000214 라벨=스타드림(골드)240g·타깃=아크릴키링고리(오염)"}
- rel: {rel: option_refs, target: material-MAT_000240, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000240", ref_key2: "USAGE.07"}, note: "🔴OPV_000215 라벨=스타드림(다이아)240g·타깃=보드스탠딩(오염)"}
- rel: {rel: option_refs, target: material-MAT_000241, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000241", ref_key2: "USAGE.07"}, note: "🔴OPV_000216 라벨=스타드림(로츠쿼츠)240g·타깃=핀버튼(오염)"}
- props: {opt_grp_cd: "OPT_000056", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01(택1)", min_sel: 1, max_sel: 1, mand_yn: Y, disp_seq: 2, ref_dim: "OPT_REF_DIM.03=mat_cd+usage_cd", contamination: "OPV_000213/214/215/216 4종=굿즈 오적재 잔존(→GAP_paper_material_042)"}
- 본문: 종이(자재) 택1 필수. 8종 자재 옵션참조(전부 USAGE.07). 청정 4종(107/118/121/125)+오염 4종(128/129/240/241). 오염 4종은 라벨=스타드림 240g이나 타깃 자재가 굿즈(면끈/키링고리/보드/핀버튼)를 가리킴([[GAP_paper_material_042]]). option_refs 타깃 8종 전부 042 uses_material에 실재(L-18 통과).

### [optgroup-042-finish] 후가공 택N(0~4) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000042
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000042,OPT_000057)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000029, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000029"}, note: "오시(OPV_000217)"}
- rel: {rel: option_refs, target: process-PROC_000030, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000030"}, note: "미싱(OPV_000218)"}
- rel: {rel: option_refs, target: process-PROC_000031, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000031"}, note: "가변텍스트(OPV_000219)"}
- rel: {rel: option_refs, target: process-PROC_000032, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000032"}, note: "가변이미지(OPV_000220)"}
- props: {opt_grp_cd: "OPT_000057", opt_grp_nm: "후가공", sel_typ_cd: "SEL_TYPE.02(택N)", min_sel: 0, max_sel: 4, mand_yn: N, disp_seq: 3, ref_dim: "OPT_REF_DIM.04=proc_cd", live_items: "오시029·미싱030·가변텍스트031·가변이미지032(전사표)", param_gap: "줄수/개수 미보존→GAP_finish_param_042"}
- 본문: 후가공 택N(0~4 동시). 라이브 opt_item 4종=오시·미싱·가변텍스트·가변이미지(041 형제 동일). option_refs는 opt_item 실코드 그대로 029/030/031/032에 배선. ★줄수(오시/미싱)·개수(가변) 세부 파라미터는 옵션에 보존 안 됨([[GAP_finish_param_042]]).

### [optgroup-042-foil] 박칼라 택1 선택(0~1·박없음 센티넬) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000042
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000042,OPT_000058)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000037, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000037"}, note: "홀로그램(OPV_000222)"}
- rel: {rel: option_refs, target: process-PROC_000038, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000038"}, note: "금유광(OPV_000223)"}
- rel: {rel: option_refs, target: process-PROC_000039, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000039"}, note: "은유광(OPV_000224)"}
- rel: {rel: option_refs, target: process-PROC_000040, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000040"}, note: "먹유광(OPV_000225)"}
- rel: {rel: option_refs, target: process-PROC_000041, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000041"}, note: "동박(OPV_000226)"}
- rel: {rel: option_refs, target: process-PROC_000042, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000042"}, note: "적박(OPV_000227)"}
- rel: {rel: option_refs, target: process-PROC_000043, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000043"}, note: "청박(OPV_000228)"}
- rel: {rel: option_refs, target: process-PROC_000044, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000044"}, note: "트윙클(OPV_000229)"}
- props: {opt_grp_cd: "OPT_000058", opt_grp_nm: "박칼라", sel_typ_cd: "SEL_TYPE.01(택1)", min_sel: 0, max_sel: 1, mand_yn: N, disp_seq: 4, ref_dim: "OPT_REF_DIM.04=proc_cd", sentinel: "박없음 OPV_000221=선택안함(min0·option_item 참조행 없음)", param_gap: "박크기 미보존→GAP_foil_param_042", price_branch: "박 선택→PRF_DGP_A_FOIL(needed_shared)"}
- 본문: 박칼라 택1 선택(0~1). 박없음(min0 센티넬) 또는 박색 8종(홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클) 중 1택. option_refs=박색 8공정(037~044·027-nodes mint 재사용). 박 선택 시 가격은 박 분기 공식 `PRF_DGP_A_FOIL`(needed_shared·미mint)로 갈림([[product-042-premium-coupon-voucher]] 가격 경로 절). ★박크기 세부 파라미터는 옵션에 보존 안 됨([[GAP_foil_param_042]]·공유 [[rule/gaps#GAP_foil_parent_children]] 동일 축).

## GAP (원천 부재·미확정)

### [GAP_paper_material_042] 042 종이 옵션 4종 굿즈 자재 오적재 잔존 {unknown}
- type: gap
- anchor: none  # 사유: 라이브 오적재 잔존 상태 — 정답(스타드림 재배선)은 실무진/§17 승인 대기(온톨로지가 지어낼 수 없음)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:PRD_000042(MAT_000128/129/240/241 del_yn=N 잔존) + t_prd_product_options opt_nm=스타드림240g", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "042 종이 옵션 4종(스타드림 실버/골드/다이아/로츠쿼츠 240g)이 굿즈 mat_cd(MAT_000128 면끈·129 아크릴키링고리·240 보드스탠딩·241 핀버튼)를 가리킴 — 034 펄명함이 2026-06-30 정리(정답 MAT_000358/359/352/360)했으나 042는 미정리 잔존"
- gap_fill_from: "§17 huni-basedata-dedup 재배선(MAT_000128→358·129→359·240→352·241→360) + 실무진 확인 — 034 DEC_pearl034_material_260630 동형 교정(굿즈 논리삭제+스타드림 채택). 인간 승인 후 dbmap COMMIT"
- gap_owner: 실무진/§17
- rel: {rel: references, target: material-MAT_000128, note: "오염 자재 슬롯"}
- rel: {rel: references, target: material-MAT_000129, note: "오염 자재 슬롯"}
- rel: {rel: references, target: material-MAT_000240, note: "오염 자재 슬롯"}
- rel: {rel: references, target: material-MAT_000241, note: "오염 자재 슬롯"}

### [GAP_finish_param_042] 042 후가공 줄수/개수 파라미터 보존불가 {unknown}
- type: gap
- anchor: none  # 사유: CPQ 옵션이 공정 택N만 표현·줄수/개수 수치 차원 미보존(GAP-PARAM)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000042,OPT_000057) note:줄수/개수=GAP-PARAM 보존불가", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "042 후가공(오시/미싱 줄수·가변텍스트/이미지 개수) 세부 파라미터 — 옵션그룹이 공정 택N만 담고 줄수/개수 수치 차원을 보존하지 못함(041 GAP_finish_param_041 동일 축)"
- gap_fill_from: "옵션 파라미터 모델 설계(줄수/개수 차원 추가)·실무진 확인 — 여러 디지털 상품 공통(041/042 등)이라 일반화 검토(open_question)"
- gap_owner: 설계
- rel: {rel: references, target: optgroup-042-finish, note: "이 옵션그룹의 파라미터 보존 공백"}

### [GAP_foil_param_042] 042 박칼라 박크기 파라미터 보존불가 {unknown}
- type: gap
- anchor: none  # 사유: 박칼라 옵션이 박색 택1만 표현·박크기(면적) 수치 차원 미보존(GAP-PARAM)
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options 키:(PRD_000042,OPT_000058) note:박크기=GAP-PARAM 보존불가", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "042 박칼라(홀로그램/금은먹유광/동적청박/트윙클) 박크기(면적) 세부 파라미터 — 박색 택1만 담고 박 면적 수치 차원을 보존하지 못함. 박 가격은 박 분기 공식 PRF_DGP_A_FOIL이 결정(needed_shared)"
- gap_fill_from: "옵션 파라미터 모델(박크기 차원) + 공유 [[rule/gaps#GAP_foil_parent_children]](박 부모 vs 박색 8자식 옵션풀 C-06 미결)와 동일 축 — 실무진/§31 제약규칙·폼빌더 파라미터"
- gap_owner: 설계/실무진
- rel: {rel: references, target: optgroup-042-foil, note: "이 옵션그룹의 박크기 파라미터 보존 공백"}
- rel: {rel: references, target: GAP_foil_parent_children, note: "공유 박 옵션풀 GAP과 동일 축"}
