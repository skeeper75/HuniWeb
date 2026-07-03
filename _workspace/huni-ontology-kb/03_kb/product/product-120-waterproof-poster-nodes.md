<!-- companion nodes for product-120 방수포스터 — 공유 축(axis/*·formula/*)에 없는 상품 전용·미승격 원자 노드. -->
<!-- ★공유 파일 수정 금지 규칙(HARD): axis/*·formula/*·rule/*는 수정하지 않는다. -->
<!-- ★실사 면적매트릭스 형제(118/119/121/122/123/125/126)가 이미 category-CAT_000004/314·size-SIZ_000293(A1 defect)· -->
<!--    component-COMP_POSTER_ARTPRINT_PHOTO(동형결합)를 product-local로 mint함(consolidation 승격 대기·L-3 debt). -->
<!--    120은 그 노드를 재사용(중복 mint 없음)하고, 유일하게 없는 formula-PRF_POSTER_WATERPROOF(120 전용 공식)만 여기 mint. -->
<!-- ★수치(치수·nonspec·셀·배선·shape)는 전사 스크립트 transcribe_product_120.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자 shape까지만(D-18·값=evaluate_price). -->

# product-120 전용 노드 (방수포스터 — 면적매트릭스 공식 + CPQ + GAP)

[[product-120-waterproof-poster]]가 연결하는 축 중, 공유 축·형제 실사 상품에 **이미 있는 것**은
**재사용**하고 여기 중복 신설하지 않는다(L-3 debt 증가 방지):
- 공유 axis: material-MAT_000178(PET·039 최초)·size-SIZ_000197(A2)·process-PROC_000013/014/015(라미)·
  rule/decisions(DEC_qty_audit_260702)·rule/rules(RULE_plate_paper_only·RULE_dosu_is_printopt·
  RULE_price_value_boundary·RULE_import_material_no_delete·RULE_scope_boundary).
- 형제 실사 product-local(consolidation 승격 대기): category-CAT_000004(포스터)·category-CAT_000314(부)·
  size-SIZ_000174(A3·047 최초)·size-SIZ_000293(A1 양면 defect·121 minted)·component-COMP_POSTER_ARTPRINT_PHOTO
  (동형결합 4소재·118/121/123 minted).

여기 신설하는 것 = **120 전용**: 면적매트릭스 공식(PRF_POSTER_WATERPROOF)·코팅 옵션그룹·치수범위 제약·
120 관련 정직 GAP 2건. (수량은 면적매트릭스라 수량축 없음 → bundle_qty 노드 미생성·형제 공통·orphan 회피.)

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_120.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_120.py` 재실행 시 동일 출력(멱등·md5 고정). ★가격 값(unit_price) 미전사.

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000120 @ 2026-07-03 -->
| prd_nm | prd_typ | use_yn | del_yn | file_upload | editor | min | max | incr | 단위 | nonspec | 가로(mm) | 세로(mm) | 가로incr | 세로incr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 방수포스터 | PRD_TYPE.01 | Y | N | Y | N | 1 | 1000 | 1 | QTY_UNIT.01 | Y | 200~1200 | 200~3000 | 200 | 200 |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000120 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | junction_del | master_del |
|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | N | N |
| SIZ_000293 | A1(594x841mm) | 594x841 | N | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000120 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | usage | dflt |
|---|---|---|---|---|
| MAT_000178 | PET | MAT_TYPE.08 | USAGE.07 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000120 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 | mand |
|---|---|---|---|
| PROC_000014 | 유광라미네이팅 | PROC_000013 | N |
| PROC_000015 | 무광라미네이팅 | PROC_000013 | N |

인쇄옵션(도수) 행수 = 0 (실사=풀컬러 잉크젯·도수 컬럼 없음·정당)

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000120 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | output_file_typ | note | del_yn |
|---|---|---|---|---|
| SIZ_000052 | (공란) | JPG | 파일사양 | Y |
| SIZ_000198 | (공란) | JPG | 파일사양 | Y |
| SIZ_000294 | (공란) | JPG | 파일사양 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000120 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_POSTER_WATERPROOF | COMP_POSTER_ARTPRINT_PHOTO | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components(use_dims·note) COMP_POSTER_ARTPRINT_PHOTO @ 2026-07-03 -->
| comp_cd | 이름 | prc_typ | comp_typ | use_dims | use_yn |
|---|---|---|---|---|---|
| COMP_POSTER_ARTPRINT_PHOTO | 실사 완제품가 (아트프린트포스터·접착방수포스터·아트패브릭포스터·방수포스터) | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | `["siz_width", "siz_height", "min_qty"]` | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_ARTPRINT_PHOTO(SHAPE·값 미전사·D-22 접기) @ 2026-07-03 -->
| comp_cd | 가로 구간(mm) | 세로 구간(mm) | 셀수 | 격자완전 | 수량밴드 |
|---|---|---|---|---|---|
| COMP_POSTER_ARTPRINT_PHOTO | 600/800/1000/1200 | 600/800/1000/1200/1400/1600/1800/2000/2200/2400/2600/2800/3000 | 52 | True | (EMPTY·수량축 없음) |

> **grid_full=True** = 가로 4구간 × 세로 13구간 = 52셀이 이 빠짐 없이 채워짐(미적재 셀 0). (가로,세로)
> 순서쌍이 고유 셀(**비대칭**·팩 §3.11). 격자 최소(가로 600·세로 600) < 상품 nonspec 최소(200)라
> 200~600 입력은 600으로 ceiling(off-grid 앱 런타임·DB는 룩업행). 가격 값은 이 표에 없다(값=evaluate_price·D-18).

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items OPT_000006 PRD_000120 @ 2026-07-03 -->
**OPT_000006 코팅** (sel=SEL_TYPE.01·min/max=0/1·mand=N·note:코팅 택1 선택)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 |
|---|---|---|---|---|
| OPV_000020 | 무광코팅 | Y | OPT_REF_DIM.04 | PROC_000015 |
| OPV_000021 | 유광코팅 | N | OPT_REF_DIM.04 | PROC_000014 |

<!-- transcribed-by: _meta/scripts/transcribe_product_120.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000120 @ 2026-07-03 -->
| rule_cd | rule_nm | rule_typ | use_yn | logic 길이(shape·raw 미전재) | err_msg |
|---|---|---|---|---|---|
| RULE_001 | 사용자입력 치수 범위 | RULE_TYPE.01 | Y | 198자 | 가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요 |

---

## 가격공식 노드 (product-local — formula/silsa-* 승격 대기·120 전용)

<!-- ★방수포스터 = 면적매트릭스형(원자합산형·고정가 룩업과 다른 세 번째 아키타입). 단일 완제품가 구성요소 -->
<!--   (동형결합 4소재·코팅/출력/소재 포함 통가격)를 (가로×세로) 셀에서 조회. round-2 D-WIRE(공유공식+sparse)→해소. -->

### [formula-PRF_POSTER_WATERPROOF] 방수포스터 완제품가 (면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_WATERPROOF
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_WATERPROOF(frm_nm=방수포스터 완제품가(면적/규격 단가)·use_yn=Y·note=포스터사인 방수포스터 소재/사이즈/수량별 완제품 통가격·upd 2026-06-18)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_WATERPROOF(comp COMP_POSTER_ARTPRINT_PHOTO·disp_seq 1·addtn Y·1행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 면적매트릭스 13(B03 방수120)·§3.11 동형결합 comp (승계·재검증 2026-07-03·라이브 PRF_POSTER_WATERPROOF+COMP_POSTER_ARTPRINT_PHOTO 확증)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: has_component, target: component-COMP_POSTER_ARTPRINT_PHOTO, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "면적매트릭스(area-matrix·[가로×세로] 셀 룩업·완제품가)", use_yn: Y, note: "120 방수포스터 전용 바인딩(t_prd_product_price_formulas). 배선된 구성요소는 동형결합 COMP_POSTER_ARTPRINT_PHOTO(형제 118/121/123과 공유·형제 노드 재사용). 전용 레거시 comp COMP_POSTER_WATERPROOF_PET는 use_yn=N 은퇴(06-17·미배선·노드 미생성=고아 방지). round-2 D-WIRE(단일 comp+sparse) 해소 확증. 값=evaluate_price"}
- 본문: 방수포스터 공식. 단일 완제품가 구성요소 1건 배선 — 인쇄·용지·공정을 원자 합산하지 않고 (가로×세로) 면적매트릭스에서 완제품가(코팅포함 통가격)를 조회한다. has_component→[[product-121-adhesive-waterproof-poster-nodes]]의 component-COMP_POSTER_ARTPRINT_PHOTO(동형결합 4소재·52셀 grid_full). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]). ★팩 §3.11 round-2 D-WIRE GAP(28상품 단일 comp·매트릭스 2~6%만 적재)은 이 상품에서 해소(현재값 확증·동형결합 52셀·round-2 sparse 인용은 STALE·T-5).

---

## 옵션그룹 노드 (CPQ — 코팅 택1·선택)

옵션 = 자재/공정 BUNDLE(팩 §3.9). 옵션참조(ref_dim_cd)는 같은 부모 prd_cd 차원에 실재 필수
(`fn_chk_opt_item_ref` 트리거·L-18). 코팅 그룹은 부모 has_process(014/015)를 가리켜 정합.

### [optgroup-120-coating] 코팅 (유광/무광 택1·선택) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000120
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000120,OPT_000006) opt_grp_nm=코팅·sel_typ=SEL_TYPE.01·min/max=0/1·mand=N·use_yn=Y·note:코팅 택1 선택", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000120,OPT_000006) OPV_000020 무광코팅(dflt_yn=Y) / OPV_000021 유광코팅", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000120,OPV_000020→PROC_000015 무광 / OPV_000021→PROC_000014 유광·전부 OPT_REF_DIM.04=공정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: option_refs, target: process-PROC_000015, ref_key1: PROC_000015, note: "무광코팅(OPV_000020·dflt)→무광라미네이팅 공정"}
- rel: {rel: option_refs, target: process-PROC_000014, ref_key1: PROC_000014, note: "유광코팅(OPV_000021)→유광라미네이팅 공정"}
- props: {opt_grp_cd: "OPT_000006", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "무광코팅(dflt)/유광코팅(2택)", ref_dim: "OPT_REF_DIM.04=공정(라미네이팅)", 가격영향: "없음(코팅포함 통가격·마감 선택·[[gap-120-coating-price-verify]])"}
- 본문: 손님이 코팅 마감을 고르는 CPQ 옵션(무광 dflt/유광). 2 option_item이 각각 공정(무광 PROC_000015·유광 PROC_000014)을 가리켜(R11 option_refs·OPT_REF_DIM.04), 부모(PRD_000120) has_process에 실재(L-18 통과·fn_chk_opt_item_ref 정합). ★가격은 면적매트릭스 완제품가에 코팅이 포함(통가격·별도 코팅 comp 미배선)이라 코팅 선택이 단가를 바꾸지 않음(팩 §3.10 정합·delta 실호출 확인은 [[gap-120-coating-price-verify]]).

---

## 제약규칙 노드 (§31 — 비규격 치수 범위·CN-5)

### [constraint-120-dimrange] 사용자입력 치수 범위 검증 {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000120
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints 키:(PRD_000120,RULE_001) rule_nm=사용자입력 치수 범위·rule_typ_cd=RULE_TYPE.01·use_yn=Y·del_yn=N·logic=JSONLogic(size_mode≠nonspec OR (width 200~1200 AND height 200~3000)·198자)·err_msg=가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§1.1/§3.9 constraints 7상품 신규 발현(120 포함) (승계·재검증 2026-07-03·라이브 1행 확증)·§31 CN-1~CN-6 폼빌더 정형 shape", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- rel: {rel: constrains, target: product-120-waterproof-poster, note: "비규격(사용자입력) 시 가로 200~1200·세로 200~3000 범위 검증"}
- props: {rule_typ_cd: "RULE_TYPE.01", cn_type: "CN-5(범위·비규격 치수)", logic_ref: "전사표(size_mode=nonspec이면 200≤width≤1200 AND 200≤height≤3000·raw 미전재·nonspec 컬럼과 정합)", ui_form: "폼빌더 정형 shape(raw JSONLogic escape hatch 아님·CLAUDE.md §31)", note: "위키 round-13 'constraints 0행'은 낡음(팩 T-3)·120 1행 신규 발현(REVERIFY→현재값)"}
- 본문: 방수포스터 비규격 치수 입력 검증 제약. size_mode=nonspec(사용자입력)일 때 가로 200~1200mm·세로 200~3000mm 범위를 벗어나면 막는다(CN-5 범위형). ★제약 shape는 폼빌더에서 읽고 조정 가능한 정형이어야 함(raw JSONLogic escape hatch 금지·CLAUDE.md §31)·shape 상세는 §31 하네스 소관. evaluate_price는 제약 미참조(위젯/주문이 validate 호출해야 강제·[[rule/rules#RULE_price_value_boundary]] 계열). ★위키 "실사 constraints 전부 0행"은 STALE(120 RULE_001 1행 실재·팩 T-3).

---

## 정직 GAP (원천 부재·범위 밖·검증 대기)

### [gap-120-coating-price-verify] 코팅 유광/무광 가격 delta=0 실호출 확인 (검증 대기) {unknown}
- type: gap
- anchor: none  # 사유: 코팅 옵션값이 라미 공정을 가리키나 별도 코팅 가격구성요소가 공식 미배선 — delta=0 추정은 배선+팩 근거이나 evaluate_price 실호출 확증은 KB 밖(값=엔진)
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components frm_cd=PRF_POSTER_WATERPROOF 배선 comp 1개(COMP_POSTER_ARTPRINT_PHOTO)·코팅 comp 없음", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 면적매트릭스=코팅 무관·코팅포함 통가격(면적 13상품 clr/mat/coat/bdl/min=NULL)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "코팅 옵션그룹(OPT_000006·유광/무광)이 라미 공정(014/015)을 가리키나 공식이 완제품가 comp 1건만 배선. 코팅 전용 가격구성요소가 없어 유광↔무광 선택 가격 delta=0으로 보이나(팩 §3.10 '코팅포함 통가격' 지지), evaluate_price 실호출 delta는 이 노드에서 확증 불가(값=엔진 소관)"
- gap_fill_from: "evaluate_price 실호출로 코팅 유광/무광 delta=0 확인(§13/§15 검증 트랙). 팩 §3.10 '코팅포함 통가격'이 라이브 옵션 노출과 정합인지 확정"
- gap_owner: staff
- rel: {rel: references, target: optgroup-120-coating, note: "가격 미기여 추정 옵션그룹"}
- rel: {rel: references, target: formula-PRF_POSTER_WATERPROOF, note: "코팅 comp 미배선 공식"}
- 본문: 온톨로지는 배선(코팅 comp 미배선)까지만 기록하고, 실제 가격 delta는 evaluate_price 권위라 단정하지 않는다([[rule/rules#RULE_price_value_boundary]]). 배선+팩 근거는 delta=0을 강하게 시사하나 실호출 확인은 검증 트랙 대기.

### [gap-120-nonspec-range-authority] 비규격 치수 범위 강제처 (GAP-SL-7) {unknown}
- type: gap
- anchor: none  # 사유: 사용자입력 치수 범위가 products nonspec 컬럼·constraint RULE_001·앱 런타임 3곳에 중복 표현 — 어느 것이 강제 권위인지 팩 미해소(GAP-SL-7)
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000120 nonspec_width/height_min/max(200~1200·200~3000)+incr 200", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.9 GAP-SL-7 비치수 수치 범위 검증처(R-SIZE-NONSPEC — products 범위 컬럼+앱 vs 비표준 var vs 앱 런타임·Q-SL-7)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "방수포스터 비규격 치수 유효범위(가로 200~1200·세로 200~3000·200 증분)가 ① 상품 nonspec 컬럼 ② 제약 constraint-120-dimrange(RULE_001) ③ 앱 런타임(위젯/견적) 3곳에 표현된다. 어느 것이 실제 입력 강제 권위이고 나머지는 파생인지, 증분(200) 강제 위치가 어디인지 미해소(팩 GAP-SL-7)"
- gap_fill_from: "실무진 Q-SL-7 — R-SIZE-NONSPEC 검증처 확정(products 범위 컬럼+앱 vs 제약 vs 앱 런타임). §31 제약/§6 위젯 validate 라우팅"
- gap_owner: staff
- rel: {rel: references, target: constraint-120-dimrange, note: "범위 표현 3곳 중 제약측"}
- rel: {rel: references, target: product-120-waterproof-poster, note: "nonspec 컬럼 보유 상품"}
- 본문: 같은 범위(200~1200 × 200~3000·200 증분)가 상품 컬럼·제약·앱 3곳에 중복 표현. evaluate_price는 제약 미참조라 강제는 위젯/주문 validate 소관인데, nonspec 컬럼과 제약 중 무엇이 SOT인지 미확정(팩 GAP-SL-7·단정 회피).

### [gap-120-roll-material-pricing-logic] 롤 소재 가격 계산 로직 (source-registry GAP-2) {unknown}
- type: gap
- anchor: none  # 사유: 실사 롤 소재 완제품가 산정 암묵지가 엑셀 미기재 — 실사 전체 영향(120 포함)·원천 부재
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "문서:§3.10 GAP·§5 인계·롤 소재 가격 계산 로직(엑셀 미기재 암묵지·source-registry §9 GAP-2·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "raw/webadmin/webadmin/catalog/pricing.py", source_locator: "함수:evaluate_price(면적매트릭스 룩업 실행·단가 산정 근거 로직은 코드/엑셀 밖 암묵지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pricing-py}
- gap_what: "방수포스터 완제품가(면적매트릭스 52셀)의 셀단가 자체가 어떤 롤 소재 원가·출력·가공 원리로 산정됐는지 계산 로직이 권위 엑셀·코드에 미기재(암묵지). KB는 룩업 셀(연결·격자완전)까지 기록하나, 셀값의 유도 근거는 원천 부재(실사 전체 영향·source-registry GAP-2)"
- gap_fill_from: "실무진 확인(롤 소재 단가 산정 암묵지) 또는 §18 설계 트랙 문서화. KB 경계상 값 유도는 온톨로지 밖(D-18)이나 셀단가 근거 부재는 정직 기록"
- gap_owner: staff
- rel: {rel: references, target: formula-PRF_POSTER_WATERPROOF, note: "면적매트릭스 셀단가 유도 근거 부재 공식"}
- 본문: 면적매트릭스 셀단가(값)는 evaluate_price가 룩업할 뿐, 그 셀값을 만든 롤 소재 가격 계산 원리는 엑셀·코드 미기재 암묵지(실사 공통 GAP-2). 온톨로지는 연결·격자완전까지 기록하고 값 유도는 경계 밖이나, 근거 부재 자체를 GAP으로 정직 선언(지어내지 않음).

---

## 재사용·미민팅(needed_shared_nodes) 요약

- **공유 축 재사용(이미 실재·중복 mint 없음):** `axis/materials.md`(material-MAT_000178 PET)·
  `axis/sizes.md`(size-SIZ_000197 A2)·`axis/processes.md`(process-PROC_000013 라미 parent·PROC_000014 유광·
  PROC_000015 무광)·`rule/rules.md`(RULE_plate_paper_only·RULE_dosu_is_printopt·RULE_price_value_boundary·
  RULE_import_material_no_delete·RULE_scope_boundary)·`rule/decisions.md`(DEC_qty_audit_260702).
- **형제 실사 product-local 재사용(consolidation 승격 대기·120 중복 mint 안 함):** category-CAT_000004(포스터)·
  category-CAT_000314(부)·size-SIZ_000174(A3·047 최초)·size-SIZ_000293(A1 양면 defect·121)·
  component-COMP_POSTER_ARTPRINT_PHOTO(동형결합 4소재·118/121/123).
- **미민팅(needed_shared_nodes·공유 파일 미수정·향후 formula/silsa-* 승격 후보):**
  formula-PRF_POSTER_WATERPROOF(여기 120 전용 mint — 형제 미보유 유일 노드)·component-COMP_POSTER_ARTPRINT_PHOTO
  (형제 재사용·동형결합 승격)·process-PROC_000006(실사출력·마스터 실재·전 실사 미바인딩·완제품가 통가격 포함·형제 미생성).
- **index 등재(O4·소프트) 대기:** product-120-waterproof-poster + companion 6노드 = consolidation/architect의 index.md 갱신 몫(공유 파일이라 본 빌드 미수정·index_entries로 반환).
