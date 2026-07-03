<!-- product-local sub-nodes: E2 category·E3 size·E4 material·E9 price_formula·E10 component·E11 option_group·gap for PRD_000136 PET배너. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - process-PROC_000115(유광코팅)·PROC_000116(무광코팅) = product-118-artprint-poster-nodes가 canonical 정의 → 여기서 재정의 안 함. 136 main이 has_process로 참조만. -->
<!--   - process-PROC_000135(실사가공) = product-129-foam-board-nodes가 canonical 정의 → 재사용(참조만). -->
<!--   - material-MAT_000178(PET 부모) = 공유 axis/materials.md 정의(039 투명명함 bare PET). MAT_000601의 upr로만 참조(관계 아님·props). -->
<!-- ★여기 정의(136 고유·타 빌더 미정의): category-CAT_000315(companion mint)·size(SIZ_000321)·material(PET 자식 601·거치대 409/410)·qty·formula(PRF_POSTER_PET_BANNER)·component 2(본체+거치대 가산)·optgroup 3(코팅/가공/거치대)·gap 5. -->
<!--   category-CAT_000315(배너/현수막)는 전 실사 배너 공유 축이나 현재 미정의 → 136이 companion mint(needed_shared 반환·consolidation이 canonical 이관). -->
<!-- ★수치(규격·고정가/가산 SHAPE·옵션 참조)는 아래 전사표(transcribed-by·transcribe_product_136.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-136 하위 노드 (PET배너 전용 축 원자 + 공식/구성요소/옵션/GAP)

PET배너(PRD_000136)가 쓰는 배너/현수막 분류·600×1800 규격·PET 본체 자재·거치대 부자재 2종·수량규칙·
고정가 본체 공식 + 거치대 가산 구성요소·CPQ 옵션그룹 3(코팅/가공/거치대)·GAP 5. 상품→축 연결
(in_category·has_size·uses_material·has_process·priced_by·has_qty_rule·has_option_group)은
[[product-136-pet-banner]]가 건다. 공식→구성요소 배선(has_component)은 아래 formula 블록. 코팅/실사가공
공정 노드는 118-nodes·129-nodes 정의를 재사용(참조만·재정의 금지·L-3).

## 카테고리·규격·자재·공정·수량·고정가/가산 SHAPE·옵션 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000136 @ 2026-07-03 -->
| cat_cd | 분류명 | 상위 | lvl | main |
|---|---|---|---|---|
| CAT_000315 | 배너/현수막 | CAT_000005 | 2 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000136 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |
|---|---|---|---|---|
| SIZ_000321 | 600x1800mm | 600x1800 | N | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials+t_prd_product_materials (활성) PRD_000136 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위자재 | dflt | junction_del_yn |
|---|---|---|---|---|---|
| MAT_000601 | PET | MAT_TYPE.08 | MAT_000178 | Y | N |
| MAT_000409 | 실내용거치대 | MAT_TYPE.16 | MAT_000227 | N | N |
| MAT_000410 | 실외용거치대 | MAT_TYPE.16 | MAT_000227 | N | N |

> 자재 승계삭제(참고·노드 미생성): MAT_000178(PET·master_del=N·junc_del=Y·07-01 자식 601로 대체) · MAT_000223(우드거치대·master_del=Y·junc_del=Y·실내/실외 거치대로 대체).

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes+t_prd_product_processes (활성) PRD_000136 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | junction_del_yn |
|---|---|---|---|---|
| PROC_000115 | 유광코팅 | PROC_000114 | N | N |
| PROC_000116 | 무광코팅 | PROC_000114 | N | N |
| PROC_000135 | 실사가공 | PROC_000083 | N | N |

> 공정 승계삭제(참고·노드 미생성·07-01 재키잉): PROC_000014(유광라미네이팅·junc_del=Y) · PROC_000015(무광라미네이팅·junc_del=Y) · PROC_000079(타공·구수 param 보유·junc_del=Y→실사가공 135로 대체·param 손실 GAP).

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (★output_paper_typ 공란=파일사양 placeholder·비종이류 판형 무의미·pack §3.8·T-7) PRD_000136 @ 2026-07-03 -->
| siz_cd | 라벨 | 용도 |
|---|---|---|
| SIZ_000321 | 600x1800mm | JPG 파일사양(판형 아님) |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000136 @ 2026-07-03 -->
| 항목 | 값 |
|---|---|
| prd_nm | PET배너 |
| prd_typ_cd | PRD_TYPE.01 |
| nonspec_yn(★N=사용자입력 없음) | N |
| min_qty | 1 |
| max_qty | 10000 |
| qty_incr | 1 |
| qty_unit | QTY_UNIT.01 |
| use_yn | Y |
| del_yn | N |
| file_upload | Y |
| editor | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000136 @ 2026-07-03 -->
| frm_cd | 상품 바인딩 | comp_cd(배선·disp_seq) | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|---|
| PRF_POSTER_PET_BANNER | True | COMP_POSTER_PET_BANNER(seq 1·addtn Y) | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | ["siz_cd", "min_qty"] |
| PRF_POSTER_PET_BANNER | True | COMP_POSTEROPT_PET_BANNER_STAND_SEL(seq 2·addtn Y) | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.01 | ["mat_cd"] |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (★본체 고정가 SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원 | 규격셀수 | siz 셀 | 수량밴드수 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_PET_BANNER | siz_cd×min_qty | 1 | SIZ_000321 | 1 | 1 | True | False | True |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (★거치대 가산 SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원 | 자재셀수 | mat 셀 | 단가행수 | 거치대옵션자재 커버 |
|---|---|---|---|---|---|
| COMP_POSTEROPT_PET_BANNER_STAND_SEL | mat_cd | 2 | MAT_000409,MAT_000410 | 2 | True |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components+t_prc_formula_components (★orphan 거치대 구성요소·공식 미배선) @ 2026-07-03 -->
| comp_cd | 공식배선됨 | 단가행수 | use_dims |
|---|---|---|---|
| COMP_POSTEROPT_PET_BANNER_STAND_IN | False | 1 | [] |
| COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1 | False | 1 | [] |
| COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2 | False | 1 | [] |

> **격자완전(grid_full)=True** = 본체 규격 1셀 × 수량 1밴드 = 1행이 채워짐. **수량축충전=False**: 셀단가=배너 통가격
> (수량무관). 거치대 가산 2셀(실내409·실외410)이 옵션 자재를 정확히 커버(covers=True). ★orphan 3건은 공식 미배선
> (STAND_SEL로 대체)·[[gap-136-stand-orphan-components]] 참조. 값=evaluate_price(D-18·미전사).

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000136 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max | mand | use_yn | del_yn | note |
|---|---|---|---|---|---|---|---|
| OPT_000017 | 코팅 | SEL_TYPE.01 | 0/1 | N | Y | N | 코팅 택1 선택 |
| OPT_000018 | 가공 | SEL_TYPE.01 | 1/1 | Y | Y | N | 4구타공 필수 (구수 param=GAP) |
| OPT_000019 | 추가 | SEL_TYPE.01 | 0/1 | N | Y | Y | 배너거치대 추가 (template·BLOCKED) |
| OPT-000009 | 거치대 | SEL_TYPE.01 | -/- | Y | Y | N |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options+t_prd_product_option_items (옵션값→차원 참조) PRD_000136 @ 2026-07-03 -->
| opt_cd | 그룹 | 옵션명 | dflt | ref_dim | ref_key1 | item_del_yn |
|---|---|---|---|---|---|---|
| OPV-000094 | OPT-000009 | 거치대없음 | Y | - | - | - |
| OPV_000036 | OPT_000017 | 무광코팅 | Y | OPT_REF_DIM.04 | PROC_000015 | N |
| OPV_000037 | OPT_000017 | 유광코팅 | N | OPT_REF_DIM.04 | PROC_000014 | N |
| OPV_000039 | OPT_000019 | 거치대없음 | Y | - | - | - |
| OPV_000038 | OPT_000018 | 4구타공 | Y | OPT_REF_DIM.04 | PROC_000135 | N |
| OPV-000019 | OPT-000009 | 실내용거치대 | N | OPT_REF_DIM.03 | MAT_000409 | N |
| OPV-000020 | OPT-000009 | 실외용거치대 | N | OPT_REF_DIM.03 | MAT_000410 | N |

> 추가상품(addons)=0 · 셋트부모(sets)=0. ★거치대는 CPQ 옵션 OPT-000009+STAND_SEL 가산으로 표현(addon 아님·pack §3.12
> 우드거치대012 addon 기대와 델타·[[gap-136-stand-attribution]]). ★코팅 옵션(OPV_000036/037) ref가 삭제된 라미(PROC_000015/014)를
> 가리킴(활성 코팅 115/116 미참조)=재키잉 불일치([[gap-136-coating-optref-stale]]).

## 카테고리 노드 (product-local companion mint — 실사 배너 공유 축 승격 대기)

### [category-CAT_000315] 배너/현수막 {verified}
- type: category
- anchor: t_cat_categories/CAT_000315
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000315(cat_nm=배너/현수막·upr_cat_cd=CAT_000005 사인·cat_lvl=2·06-19 신규노드·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000136,CAT_000315) main_cat_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "배너/현수막", cat_lvl: 2, upr_cat_cd: "CAT_000005", main_cat_yn: "N", note: "실사 005 사인 하위 배너/현수막 leaf(06-19 신규노드). CAT_000298 고아 해소 후 재연결(pack §1.1·T-1). 상위 카테고리 관계는 스키마 19종에 없어 upr_cat_cd props로만 기록"}
- 본문: PET배너가 걸리는 라이브 분류(배너/현수막·사인 하위 leaf). [[product-136-pet-banner]] in_category 대상. 형제 실사 배너(137 메쉬배너 등)와 공유하는 축이나 현재 미정의라 136이 companion mint(needed_shared 반환·consolidation이 canonical 이관).

## 사이즈 노드 (product-local — 600x1800 단일 규격)

### [size-SIZ_000321] 배너 규격 (600x1800) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000321
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000321(siz_nm=600x1800mm·work 600x1800·impos_yn=N·tags=[배너]·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000136,SIZ_000321) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000321(작업 600x1800·impos_yn=N)", note: "PET배너 단일 등록 규격. nonspec_yn=N이라 사용자입력 치수 없음. 고정가 본체 단가표 1셀(600x1800)과 정확 일치(전사표 규격=가격셀 정합 True)"}
- 본문: PET배너 규격(600×1800mm 단일). [[product-136-pet-banner]] has_size 대상. 고정가형이라 이 규격이 본체 구성요소 siz_cd 룩업 키(수량 무관 통가격).

## 자재 노드 (product-local — PET 본체 + 거치대 부자재·축 승격 대기)

<!-- ★136 본체=PET(MAT_TYPE.08 실사소재·정당). 거치대 부자재=MAT_TYPE.16 실사부자재(부모 MAT_000227 배너거치대). -->
<!-- MAT_000178(PET 부모)·MAT_000223(우드거치대)는 07-01 재키잉 승계삭제 → 노드 미생성(환각 차단). -->

### [material-MAT_000601] PET (본체·07-01 재키잉 신설) {verified}
- type: material
- anchor: t_mat_materials/MAT_000601
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000601(mat_nm=PET·mat_typ_cd=MAT_TYPE.08·upr_mat_cd=MAT_000178·06-30 신설·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000136,MAT_000601) USAGE.07·dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", upr_mat_cd: "MAT_000178", 사용: "136 본체 자재(USAGE.07·dflt_yn=Y)", note: "PET 배너 본체(실사소재). 구 부모 MAT_000178(공유 axis/materials.md 정의·investment junction del_yn=Y)의 자식으로 06-30 신설·07-01 재키잉으로 본체 활성 코드가 됨"}
- 본문: PET배너 본체 자재(PET·낱장 완제품 단일 슬롯·USAGE.07·내지/표지 없음). [[product-136-pet-banner]] uses_material 대상(dflt). 부모 MAT_000178은 공유 axis에 정의됨(여기 재정의 안 함·upr props로만 참조).

### [material-MAT_000409] 실내용거치대 (거치대 옵션 자재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000409
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000409(mat_nm=실내용거치대·mat_typ_cd=MAT_TYPE.16 실사부자재·upr_mat_cd=MAT_000227 배너거치대·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000136,MAT_000409) USAGE.07·dflt_yn=N·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", upr_mat_cd: "MAT_000227", 사용: "136 거치대 옵션값(OPT-000009 실내용거치대) 참조대상·거치대 가산 구성요소(STAND_SEL) mat_cd 키", note: "실사부자재(배너거치대 계열). 구 우드거치대 MAT_000223(승계삭제) 대체. 거치대 선택 시 mat_cd로 가산가 조회"}
- 본문: 거치대 옵션값(실내용)이 가리키는 자재. [[product-136-pet-banner]] uses_material 대상. optgroup-136-stand의 option_refs 타깃(OPT_REF_DIM.03·자재)이자 [[component-COMP_POSTEROPT_PET_BANNER_STAND_SEL]] mat_cd 단가행 키(L-18 부모정합 통과·uses_material 실재).

### [material-MAT_000410] 실외용거치대 (거치대 옵션 자재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000410
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000410(mat_nm=실외용거치대·mat_typ_cd=MAT_TYPE.16 실사부자재·upr_mat_cd=MAT_000227 배너거치대·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000136,MAT_000410) USAGE.07·dflt_yn=N·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.16", upr_mat_cd: "MAT_000227", 사용: "136 거치대 옵션값(OPT-000009 실외용거치대) 참조대상·거치대 가산 구성요소(STAND_SEL) mat_cd 키", note: "실사부자재(배너거치대 계열). ★실외 단면/양면 구분(orphan STAND_OUT_S1 단면·S2 양면)이 mat_cd 단일 키로는 붕괴됨([[gap-136-stand-orphan-components]])"}
- 본문: 거치대 옵션값(실외용)이 가리키는 자재. [[product-136-pet-banner]] uses_material 대상. optgroup-136-stand의 option_refs 타깃(OPT_REF_DIM.03)이자 STAND_SEL mat_cd 단가행 키(L-18 통과).

## 수량규칙 노드 (product-local)

### [qty-136] PET배너 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000136
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000136 min_qty/max_qty/qty_incr(1/10000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가형이라 본체 단가표 수량축 1밴드(min_qty=1)만 충전(전사표 수량축충전=False). 셀단가=배너 통가격·총액=셀×수량(+거치대 가산). max_qty=10000(형제 실사 1000과 다름·배너 대량 허용)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 수량 무관 통가격.

## 가격공식 노드 (product-local — silsa 고정가+가산 formula 축 승격 대기)

<!-- ★고정가형(본체 siz_cd 룩업) + 거치대 가산(mat_cd) 2 구성요소 공식. 131(단순 고정가 1구성요소)보다 복잡. -->
<!-- has_component 타깃: 본체 COMP_POSTER_PET_BANNER + 거치대 COMP_POSTEROPT_PET_BANNER_STAND_SEL(아래 정의). -->

### [formula-PRF_POSTER_PET_BANNER] PET배너 완제품가 (고정가 본체 + 거치대 가산) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_PET_BANNER
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_PET_BANNER(frm_nm=PET배너 완제품가(면적/규격 단가)·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_PET_BANNER(COMP_POSTER_PET_BANNER disp1·COMP_POSTEROPT_PET_BANNER_STAND_SEL disp2·둘 다 addtn_yn Y·2행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000136,PRF_POSTER_PET_BANNER) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_PET_BANNER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_PET_BANNER_STAND_SEL, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가형(fixed-price·본체 통가격) + 거치대 가산(mat_cd)", use_yn: Y, note: "136 바인딩 전용 공식. 본체(siz_cd×min_qty)+거치대 가산(mat_cd) 2 구성요소 합산(addtn_yn=Y)·값=evaluate_price"}
- 본문: PET배너 가격공식. 구성요소 2건 배선 — 본체 완제품 통가격([[component-COMP_POSTER_PET_BANNER]]·siz_cd 룩업)에 거치대 선택 가산([[component-COMP_POSTEROPT_PET_BANNER_STAND_SEL]]·mat_cd)을 더한다. 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

## 가격구성요소 노드 (product-local — 본체 고정가 + 거치대 가산)

<!-- ★단가행(본체 1셀·거치대 2셀)은 노드로 펼치지 않고 use_dims 차원+SHAPE로 접음(D-22). 값(unit_price) 미전사(evaluate_price 권위). -->

### [component-COMP_POSTER_PET_BANNER] PET배너 본체 완제품가 (고정가·siz_cd) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_PET_BANNER
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_PET_BANNER(comp_typ=PRC_COMPONENT_TYPE.06 완제품비·prc_typ_cd=PRICE_TYPE.01 단가형·use_dims=[siz_cd,min_qty])", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_PET_BANNER 단가행 1(SIZ_000321×min1·값 미전사)·note '출력+코팅+가공(4구아일렛) 포함가'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "PET배너 본체 완제품 통가격(출력+코팅+4구타공 포함)", 단가행_ref: "전사표 고정가 SHAPE(1셀=규격1×수량1·격자완전 True·수량축 미충전)", archetype: "고정가형(fixed-price·siz_cd 룩업·off-grid ceiling 없음)"}
- 본문: PET배너 본체 완제품가 구성요소. use_dims 2축(규격 siz_cd × 수량 min_qty)으로 셀단가 조회(차원 선언까지·D-22 단가행 접기). 규격 1셀 완전격자(전사표 SHAPE). 코팅·4구타공은 이 통가격에 baked(별도 원자합산 아님). 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]).

### [component-COMP_POSTEROPT_PET_BANNER_STAND_SEL] 거치대(실내/실외) 선택 가산가격 (mat_cd) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_PET_BANNER_STAND_SEL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_PET_BANNER_STAND_SEL(comp_typ=PRC_COMPONENT_TYPE.01·prc_typ_cd=PRICE_TYPE.01·use_dims=[mat_cd]·07-01 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTEROPT_PET_BANNER_STAND_SEL 단가행 2(MAT_000409 실내·MAT_000410 실외·값 미전사)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.01", use_dims: '["mat_cd"]', role: "거치대 선택 가산(실내용409·실외용410)", 단가행_ref: "전사표 가산 SHAPE(2셀=자재2·옵션자재 커버 True)", note: "거치대 옵션(OPT-000009) 선택→자재 mat_cd로 가산가 조회. orphan STAND_IN/OUT_S1/OUT_S2를 대체([[gap-136-stand-orphan-components]])"}
- 본문: 거치대 선택 시 자재별 가산가격 구성요소. use_dims 1축(자재 mat_cd)으로 실내용(409)/실외용(410) 가산가 조회. [[optgroup-136-stand]] 옵션 선택이 uses_material 차원으로 환원되어 이 구성요소를 구동. 값=evaluate_price(미전사·D-18).

## 옵션그룹 노드 (CPQ)

### [optgroup-136-coating] 코팅 (없음/무광/유광) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000136
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000136 opt_grp_cd:OPT_000017(코팅·SEL_TYPE.01·min0/max1·mand_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000136 OPT_000017 (OPV_000036 무광코팅 dflt·OPV_000037 유광코팅)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000136 (OPV_000036→PROC_000015·OPV_000037→PROC_000014·OPT_REF_DIM.04=공정·★삭제된 라미 참조)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000017", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "코팅없음/무광코팅/유광코팅(택0~1)", ref_dim: "OPT_REF_DIM.04=공정(코팅=본체 통가격 포함·가산 아님)", 결함: "★option_items ref가 삭제된 라미(PROC_000015/014)를 가리킴·활성 코팅 115/116 미참조=재키잉 불일치(option_refs 관계 미부착·gap-136-coating-optref-stale)"}
- 본문: 손님이 코팅을 고르는 CPQ 옵션(택0~1). 코팅 선택은 본체 통가격에 포함이라 별도 가산 아님(pack §3.10). ★현재 option_items가 07-01 승계삭제된 라미네이팅 공정(PROC_000015 무광·PROC_000014 유광)을 참조하고, 상품 활성 코팅 공정(PROC_000115/116)은 미참조다 — 재키잉 미완 불일치라 **option_refs 관계를 부착하지 않고**(삭제 공정에 링크 금지·L-18 오염 회피) [[gap-136-coating-optref-stale]]로 정직 선언한다. evaluate_price는 제약/옵션 ref를 가격에 직접 반영하지 않으므로(통가격 baked) 견적 영향은 없으나 옵션 UI→공정 배선은 끊긴 상태.

### [optgroup-136-gagong] 가공 (4구타공 필수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000136
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000136 opt_grp_cd:OPT_000018(가공·SEL_TYPE.01·min1/max1·mand_yn=Y·use_yn=Y·del_yn=N·note '4구타공 필수 (구수 param=GAP)')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000136 OPT_000018 (OPV_000038 4구타공 dflt)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000136 (OPV_000038→PROC_000135·OPT_REF_DIM.04=공정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000135, ref_key1: PROC_000135, note: "4구타공(OPV_000038)→실사가공 공정"}
- props: {opt_grp_cd: "OPT_000018", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "4구타공(택1 필수·현재 단일)", ref_dim: "OPT_REF_DIM.04=공정(4구타공→실사가공 PROC_000135)", note: "★옵션명 '4구타공'이나 ref는 generic 실사가공(PROC_000135)·구 타공 PROC_000079의 구수 param 손실([[gap-136-punch-param]])"}
- 본문: 손님이 가공을 고르는 필수 CPQ 옵션(택1·현재 4구타공 단일). option_item이 실사가공 공정 PROC_000135를 가리켜(R11 option_refs·OPT_REF_DIM.04) has_process 차원으로 환원(L-18 통과·부모 136 has_process 실재). 가공비는 본체 통가격에 포함(4구아일렛). ★구 타공 공정(PROC_000079)의 구수(hole count) param(min1/max8)이 재키잉으로 소실됨([[gap-136-punch-param]]).

### [optgroup-136-stand] 거치대 (없음/실내용/실외용) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000136
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000136 opt_grp_cd:OPT-000009(거치대·SEL_TYPE.01·mand_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000136 OPT-000009 (OPV-000094 거치대없음 dflt·OPV-000019 실내용거치대·OPV-000020 실외용거치대)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000136 (OPV-000019→MAT_000409·OPV-000020→MAT_000410·OPT_REF_DIM.03=자재·ref_key2=USAGE.07)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: material-MAT_000409, ref_key1: MAT_000409, note: "실내용거치대(OPV-000019)→자재→가산가격"}
- rel: {rel: option_refs, target: material-MAT_000410, ref_key1: MAT_000410, note: "실외용거치대(OPV-000020)→자재→가산가격"}
- props: {opt_grp_cd: "OPT-000009", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", 옵션값: "거치대없음(dflt)/실내용/실외용(택1 필수)", ref_dim: "OPT_REF_DIM.03=자재(거치대→STAND_SEL mat_cd 가산)", note: "거치대없음(OPV-000094)은 참조 없음. 실내/실외 item이 자재(409/410)를 가리켜 거치대 가산 구성요소를 구동"}
- 본문: 손님이 거치대를 고르는 필수 CPQ 옵션(택1·기본 없음). 실내용/실외용 item이 자재 MAT_000409/410을 가리켜(R11 option_refs·OPT_REF_DIM.03) uses_material 차원으로 환원(L-18 통과·부모 136 uses_material 실재). 이 선택이 [[component-COMP_POSTEROPT_PET_BANNER_STAND_SEL]](mat_cd 키) 가산가격을 구동하는 깨끗한 CPQ→가격 배선. ★구 template 방식(OPT_000019 추가·del_yn=Y)을 대체.

## GAP 노드 (원천 부재·불일치·정직 선언)

### [gap-136-coating-optref-stale] 코팅 옵션 참조 재키잉 불일치 {defect}
- type: gap
- anchor: none  # 사유: 코팅 옵션 item이 삭제된 라미(014/015)를 가리켜 활성 코팅(115/116)과 불일치 — 라이브 데이터 상태이나 정답 배선은 어느 문서도 명시 없음
- badge: defect
- current_value: "코팅 옵션 OPV_000036/037의 option_items ref_key1 = PROC_000015(무광라미)·PROC_000014(유광라미) — 상품 junction del_yn=Y(승계삭제)"
- authority_value: "정답 배선 = 활성 코팅 공정 PROC_000115(유광)·PROC_000116(무광) 참조(118 재키잉 후 상태와 동형)"
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:PRD_000136 OPV_000036→PROC_000015·OPV_000037→PROC_000014(삭제 라미)·활성 코팅 115/116 미참조", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/03_kb/product/product-118-artprint-poster-nodes.md", source_locator: "블록:optgroup-118-coating(118은 재키잉 후 코팅 옵션이 PROC_000115/116 참조·136 정답 동형)", captured_at: "2026-07-03", badge: verified, src_id: SR-5-livesnap}
- gap_what: "코팅 옵션그룹(OPT_000017)의 option_items가 07-01 승계삭제된 라미네이팅 공정(014/015)을 가리키고 활성 코팅 공정(115/116)을 미참조 — 옵션 UI→공정 배선 단절(재키잉 미완). 118은 이미 115/116으로 재배선됨"
- gap_fill_from: "실무진 재배선(option_items ref_key1을 PROC_000115/116으로 교정·118 동형)·§31/dbmap 트랙. evaluate_price는 통가격 baked라 견적 영향 없으나 옵션 표시/제약 정합에 필요"
- gap_owner: staff
- 본문: 07-01 재키잉이 상품 공정(115/116 활성·014/015 삭제)까지는 진행됐으나 코팅 옵션 item의 참조를 갱신하지 않아 삭제 공정을 가리키는 불일치가 남았다. 양면 표기(현재값=삭제 라미 참조 / 정답=활성 코팅 참조). optgroup-136-coating은 이 불일치 때문에 option_refs 관계를 부착하지 않는다(삭제 공정 링크 금지). 실 교정은 인간 승인 후 트랙(생성≠검증·DB 미적재).

### [gap-136-punch-param] 4구타공 구수(hole count) param 손실 {unknown}
- type: gap
- anchor: none  # 사유: 구 타공 공정 PROC_000079의 구수 param(min1/max8)이 재키잉으로 실사가공 135(param 없음)로 대체되며 소실 — 구수 옵션 표현처가 어느 문서에도 없음
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000079(타공·prcs_dtl_opt inputs 구수 min1 max8)·상품 junction del_yn=Y→PROC_000135(실사가공·prcs_dtl_opt 없음)로 대체", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.6·GAP-SL-2 봉제/족자/타공 variant param 적재 위치 미결(CPQ option_items vs prcs_dtl_opt)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "가공 옵션(OPT_000018) note가 '4구타공 필수 (구수 param=GAP)'로 명시 — 구 타공 공정 PROC_000079의 구수(4/6/8구) param이 실사가공 PROC_000135로 재키잉되며 소실. 손님이 구수를 고를 축(또는 고정 4구)이 데이터로 표현 안 됨"
- gap_fill_from: "실무진 — 구수 고정(4구)인지 선택(4/6/8구)인지 확정 후 param 적재 위치 결정(pack §3.6 GAP-SL-2·Q-SL-2). 메쉬현수막139의 타공 param 처리와 정합 필요"
- gap_owner: staff
- 본문: 4구타공은 현재 본체 통가격에 4구 고정으로 baked된 것으로 보이나(component note '4구아일렛'), 구수 선택 축이 데이터에 없다. 가격 사슬은 끊기지 않음(통가격 조회 가능)이나 옵션 표현/생산 지시의 param이 GAP. pack §3.6 봉제/족자/타공 variant 적재 위치 미결(GAP-SL-2)과 같은 축.

### [gap-136-stand-attribution] 거치대 귀속 — CPQ 옵션 vs addon {candidate}
- type: gap
- anchor: none  # 사유: pack §3.12는 거치대를 addon(우드거치대012 재연결)으로 기대하나 라이브는 CPQ 옵션+가산으로 표현 — 정답 귀속 모델이 확정 안 됨
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.12·GAP-SL-4 부속붙는 8상품(PET배너136→우드거치대012 addon 재연결 대기)·addon=0/set=0 잔존", captured_at: "2026-07-03", badge: candidate, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000136 OPT-000009 거치대(CPQ 옵션·활성)+COMP_POSTEROPT_PET_BANNER_STAND_SEL 가산·addon/set 0행·우드거치대 MAT_000223 승계삭제", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- gap_what: "pack §3.12는 PET배너 거치대를 addon(우드거치대012)으로 재연결 대기라 하나, 라이브는 거치대를 CPQ 옵션그룹(OPT-000009)+거치대 가산 구성요소(STAND_SEL·mat_cd)로 이미 표현하고 우드거치대 자재는 승계삭제 — addon 0행이 결함이 아니라 다른 메커니즘 해소다. 두 모델(addon vs CPQ 옵션) 중 무엇을 정답 귀속으로 확정할지 미결"
- gap_fill_from: "실무진 — 거치대를 상품 옵션(현 라이브)으로 둘지 별매 addon(pack 기대)으로 둘지 확정(pack §3.12 GAP-SL-4·Q-SL-4). 형제 메쉬배너137도 동일 판정 대상"
- gap_owner: staff
- 본문: 라이브는 거치대를 상품 내 CPQ 옵션+가산가격으로 표현(작동함·PRICE≠0)하는데, pack §3.12는 별매 addon(우드거치대012) 재연결을 기대한다. 어느 쪽이 정답 귀속인지 미확정이라 candidate로 정직 선언(단정 금지). 현재 라이브 메커니즘은 끊긴 사슬이 아니다(옵션→자재→STAND_SEL 가산 연결됨).

### [gap-136-stand-orphan-components] 거치대 orphan 구성요소 3건 + 실내값 CONFIRM {defect}
- type: gap
- anchor: none  # 사유: 공식 미배선 orphan 3건(STAND_IN/OUT_S1/OUT_S2)·실내 orphan값이 배선된 STAND_SEL 실내값과 불일치 CONFIRM — 정답값은 상품마스터260610 근거이나 orphan 은퇴 판정 미완
- badge: defect
- current_value: "배선 = COMP_POSTEROPT_PET_BANNER_STAND_SEL(mat_cd·실내409/실외410 2셀·공식 seq2). orphan(공식 미배선) = STAND_IN(실내)·STAND_OUT_S1(실외 단면)·STAND_OUT_S2(실외 양면) 각 1행. STAND_SEL 실내 comp note '★live orphan STAND_IN 불일치 CONFIRM'"
- authority_value: "상품마스터260610 = 실내 10000·실외 23000(STAND_SEL 실외=live STAND_OUT_S1 일치·확정). orphan STAND_IN·양면 STAND_OUT_S2는 배선 대상 아님(은퇴 후보)"
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTEROPT_PET_BANNER_STAND_SEL note '실내 [260610=10000·★live orphan STAND_IN 불일치 CONFIRM]'·실외 note '[260610=23000=live STAND_OUT_S1 일치·확정]'·orphan STAND_IN/OUT_S1/OUT_S2 각 1행 공식 미배선", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- gap_what: "거치대 가산이 mat_cd 키 STAND_SEL로 재정합됐으나 구 per-variant orphan 구성요소 3건(STAND_IN·STAND_OUT_S1·STAND_OUT_S2)이 공식 미배선으로 잔존. ① 실내 orphan값이 배선된 STAND_SEL 실내값과 불일치(CONFIRM 필요) ② 실외 양면용(STAND_OUT_S2) variant가 mat_cd 단일 키(실외 1값)로 붕괴돼 미포착 — 단면/양면 실외 거치대 구분이 소실"
- gap_fill_from: "실무진 — 실내 값 확정(STAND_SEL vs orphan) 후 orphan 3건 은퇴(use_yn=N)·실외 단면/양면 구분이 필요하면 mat_cd 키 확장 또는 별 옵션값 신설(§27 배선 서브트랙·dbmap 위임). 값 정합은 예전사이트 골든 대조"
- gap_owner: staff
- 본문: 배선된 STAND_SEL(실내409·실외410 2셀)은 상품마스터260610 정합(실외 확정)이나, 실내값이 orphan STAND_IN과 불일치해 CONFIRM 대기(양면 표기). 또 실외 단면/양면(orphan OUT_S1/OUT_S2 2값)이 mat_cd 단일 키로 붕괴돼 양면 거치대가 미포착이다. orphan 3건은 공식 미배선(가격 미영향)이나 데이터 청소·값 확정 대상. §27 배선 서브트랙 계열 결함.

### [gap-136-roll-price-logic] 롤 소재 완제품 통가격 산정 로직 {unknown}
- type: gap
- anchor: none  # 사유: 롤(대형롤) 소재 완제품 통가격 도출 규칙이 어느 엑셀/문서에도 명시 없음(암묵지)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "본체 고정가 통가격(600×1800 배너)이 롤 원가/폭/마진 어떤 규칙으로 도출됐는지 — 값은 라이브에 적재됐으나 산정 근거 문서 부재(실사 전체 공통)"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_PET_BANNER]]→본체+거치대 구성요소·격자완전)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
