<!-- companion nodes for product-125 캔버스패브릭포스터 — 공유 축(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(052 방식). -->
<!-- ★실사 첫 상품이라 실사 공유 축(카테고리 CAT_000004/072·면적공식 PRF_POSTER_CANVAS·구성요소 COMP_POSTER_CANVAS_FABRIC·봉제 PROC_000080·캔버스 MAT_000185·A계열 사이즈)은 여기 mint→needed_shared_nodes로 반환(향후 실사 13 면적상품 승격 후보). -->
<!-- ★수치(치수·nonspec 범위·면적 셀 행수·배선)는 전사 스크립트 transcribe_product_125.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-125 전용 노드 (캔버스패브릭포스터 — 실사 area-matrix 전용 마스터 축)

[[product-125-canvas-fabric-poster]]가 연결하는 축은 전부 실사 첫 상품이라 디지털/스티커 공유 축
(axis/*·formula/*)에 없다. 아래 신설(공유 승격 후보=needed_shared_nodes). 판형(plate_size)은 실사
비종이류라 노드 없음(전 행 논리삭제·pack §3.8·T-7). 인쇄옵션(도수)도 없음(실사 대형잉크젯 풀컬러·po=0).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_125.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_125.py` 재실행 시 동일 출력(멱등). JSON 캐시=`cache/transcribed-125-260703.json`.

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000125 @ 2026-07-03 -->
| cat_cd | 분류명 | 상위 | lvl | main | disp |
|---|---|---|---|---|---|
| CAT_000004 | 포스터 |  | 1 | N |  |
| CAT_000072 | 패브릭포스터 | CAT_000004 | 2 | Y | 2 |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (junction del_yn=N·★master_del_yn 별도 검출) PRD_000125 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |
|---|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | Y | 1 | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | Y | 1 | N |
| SIZ_000293 | A1(594x841mm) | 594x841 | 594x841 | Y | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (del_yn=N·MAT_TYPE.05=특수소재 교정됨) PRD_000125 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | dflt | disp | usage |
|---|---|---|---|---|---|---|
| MAT_000185 | 캔버스(옥스포드) | MAT_TYPE.05 |  | Y | 1 | USAGE.07 |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes (del_yn=N·봉제=가공 CPQ) PRD_000125 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000080 | 봉제 |  | N | 1 |

인쇄옵션(print_option) 활성 행수 = 0 (실사=대형 잉크젯 풀컬러·도수 축 없음·정당)

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (★전 행 del_yn=Y 논리삭제=비종이류 판형 무의미·pack §3.8·T-7) PRD_000125 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | output_file_typ | del_yn | note |
|---|---|---|---|---|
| SIZ_000052 | (빈값) | JPG | Y | 파일사양 |
| SIZ_000198 | (빈값) | JPG | Y | 파일사양 |
| SIZ_000294 | (빈값) | JPG | Y | 파일사양 |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000125 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_POSTER_CANVAS | COMP_POSTER_CANVAS_FABRIC | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components (use_dims·prc_typ·[동형결합] 4소재 통합) PRD_000125 @ 2026-07-03 -->
| comp_cd | 이름 | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|
| COMP_POSTER_CANVAS_FABRIC | 실사 완제품가 (캔버스패브릭포스터·레더아트프린트·메쉬프린트·타이벡프린트) | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | `["siz_width", "siz_height", "min_qty"]` |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_CANVAS_FABRIC 면적 셀 행수요약 (값 나열 아님·D-22 접기·[siz_width×siz_height]) PRD_000125 @ 2026-07-03 -->
| 지표 | 값 |
|---|---|
| 총 단가행(셀) | 52 |
| 고유 (가로,세로) 순서쌍 | 52 |
| 고유 가로값 수 | 4 (범위 600.00~1200.00mm) |
| 고유 세로값 수 | 13 (범위 600.00~3000.00mm) |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items (가공=봉제 CPQ) PRD_000125 @ 2026-07-03 -->
**OPT_000010 가공** (sel=SEL_TYPE.01·min/max=0/1·mand=N·disp=1)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPV_000028 | 오버로크 | Y | OPT_REF_DIM.04 | PROC_000080 |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints (nonspec 치수범위·JSONLogic·폼빌더 shape) PRD_000125 @ 2026-07-03 -->
| rule_cd | 규칙명 | rule_typ_cd | use_yn | err_msg |
|---|---|---|---|---|
| RULE_001 | 사용자입력 치수 범위 | RULE_TYPE.01 | Y | 가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요 |

- RULE_001 logic: `{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}`

<!-- transcribed-by: _meta/scripts/transcribe_product_125.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (정체·nonspec·수량·상태) PRD_000125 @ 2026-07-03 -->
| 항목 | 값 |
|---|---|
| prd_nm | 캔버스패브릭포스터 |
| prd_typ_cd | PRD_TYPE.01 |
| nonspec_yn | Y |
| nonspec 가로범위(mm) | 200~1200 (incr 200) |
| nonspec 세로범위(mm) | 200~3000 (incr 200) |
| min/max/incr 수량 | 1/10000/1 (QTY_UNIT.01) |
| use_yn / del_yn | Y / N |
| file_upload / editor | Y / N |

---

## 카테고리 (category) — 125 main=CAT_000072 신설·root CAT_000004 재사용

★**동시 빌드 정합(consolidation):** 실사 root `category-CAT_000004`(포스터)는 병렬 실사 형제
(119 아트페이퍼포스터 등)가 이미 소유(파싱 순서상 owner)·125는 **재사용 참조**(중복 mint 금지·L-3
회피). in_category 엣지는 프론트매터가 유지(target 실재). leaf `category-CAT_000072`(패브릭포스터·
125 main)만 여기 신설(다른 형제 미소유·unique). 실사 카테고리는 공유 categories.md에 아직 없어
**needed_shared_nodes**로 반환(실사 카테고리 승격 시 consolidate 대상).

### [category-CAT_000072] 패브릭포스터 (실사 leaf·cat_lvl 2·125 main) {verified}
- type: category
- anchor: t_cat_categories/CAT_000072
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000072 cat_nm=패브릭포스터·cat_lvl=2·upr_cat_cd=CAT_000004·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "테이블:t_prd_product_categories 키:(PRD_000125,CAT_000072) main_cat_yn=Y·disp 2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_lvl: 2, upr_cat_cd: "CAT_000004", main_cat_yn_for_125: "Y"}
- 본문: 125의 main 분류(패브릭포스터·포스터 하위 leaf). 소재(캔버스)가 상품 정체를 가르는 실사 특성(pack §0 특성1)이 카테고리에 반영.

---

## 사이즈 (size) — 전부 재사용 참조 (공유 axis/형제 owner·중복 mint 금지)

★**동시 빌드 정합(consolidation):** 125 이산 사이즈 A3/A2/A1은 전부 다른 파일이 이미 소유하므로
125는 **재사용 참조만**(L-3 중복 mint 금지)·has_size 프론트매터 엣지는 유지(target 실재):
- `size-SIZ_000197`(A2 420x594) = **공유 [axis/sizes.md](../axis/sizes.md) owner**(재사용).
- `size-SIZ_000174`(A3 297x420) = product-047(소량전단지) owner(재사용·A계열 공용).
- `size-SIZ_000293`(A1 594x841) = 병렬 실사 형제 119(아트페이퍼포스터) owner. ★119가 이 노드를
  **양면 defect**(junction 활성 vs master `t_siz_sizes.SIZ_000293` del_yn=Y·활성 A1=SIZ_000294)로
  이미 표기함 — 125도 같은 불일치를 공유(A1 참조=매달린 master). 정리 워크리스트는 형제/consolidation
  소관(단정 금지·라이브 인간 승인).

실사 사이즈 = 이산 규격 SIZ(A3/A2/A1) + nonspec 연속범위(입력 UX·가격격자 아님·pack §3.2). 판걸이수
(UP수)는 종이류 파생값이라 실사 무의미(판형 절). 면적 셀단가 격자는 (가로×세로) siz_width/siz_height
키로 별도 저장(SIZ 코드 아님·가격구성요소 절).

---

## 자재 (material) — 실사 캔버스 1종 (MAT_TYPE.05 특수소재·교정됨)

실사 자재 = 소재별 본체 자재 단일(낱장 완제품·parent+usage_cd·pack §3.5). 캔버스는 06-14 `.08 실사소재`
→`.05`로 교정됨(live note). round-13 목표 라벨 "원단"(구 .05 지칭)은 MAT_TYPE 코드 개편으로 STALE(현재 .05=특수소재).

### [material-MAT_000185] 캔버스(옥스포드) (MAT_TYPE.05 특수소재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000185
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000185 mat_nm=캔버스(옥스포드)·mat_typ_cd=MAT_TYPE.05·note '정정 2026-06-14: 실사소재(.08)→원단(.05)'·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 자재유형 교정(캔버스185=.05 교정됨)·T-2(목표 라벨 '원단'(구 .05) STALE·현재 .05=특수소재)·§1.1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_typ_cd: "MAT_TYPE.05", usage_cd: "USAGE.07", upr_mat_cd: null, 교정: ".08→.05(06-14)"}
- 본문: 캔버스 원단(옥스포드). MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재·.08=실사소재)으로 round-13 "원단/가죽"(구 .05/.06 지칭) 목표 라벨은 STALE(T-2). 현재값 .05 특수소재가 교정 완료 상태라 자재유형 양면 아님. ★IMPORT 시트 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 공정 (process) — 실사 봉제 1종 (패브릭 완성형태·가공 CPQ 참조)

패브릭은 소재가 완성형태라 봉제가 후가공(pack §3.6). 봉제(PROC_000080)는 opt이며 가공 CPQ 옵션그룹이
이 공정을 참조(옵션=공정 BUNDLE). 인쇄방식 공정(PROC_000006)은 실사 라이브 부재(po=0·정당).

### [process-PROC_000080] 봉제 (opt·유형/폭 param·패브릭 후가공) {verified}
- type: process
- anchor: t_proc_processes/PROC_000080
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000080 proc_nm=봉제·upr 없음·prcs_dtl_opt(유형 enum[오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱(7cm)]·폭 number mm)·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:(PRD_000125,PROC_000080) mand_proc_yn=N(opt)·disp 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.6 패브릭=봉제 PROC_000080(param 오버로크/말아박기/봉미싱·폭)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mand_for_125: "N(opt)", param_ref: "전사표(유형 enum·폭 mm)", 계열: "패브릭 완성형태 후가공"}
- 본문: 봉제 후가공. 유형(오버로크/말아박기/봉미싱)·폭 param은 prcs_dtl_opt에 정의(전사표). ★봉제 variant 적재 위치(CPQ option_items vs prcs_dtl_opt param)는 실사 GAP-SL-2(현재 125는 CPQ 가공 옵션으로 오버로크 1값만 노출). 값 계산=엔진.

---

## 가격공식·구성요소 (실사 첫 상품 — 상품-local mint·needed_shared_node)

실사 = 면적매트릭스형 완제품가(포스터사인 [가로×세로] 셀단가·pack §3.10). 디지털 원자합산(PRF_DGP_*)·
스티커 고정룩업(PRF_STK_FIXED)과 다르므로 실사 전용 공식/구성요소를 여기 신설(면적매트릭스를 공유하는
실사 13상품 향후 승격 후보).

### [formula-PRF_POSTER_CANVAS] 캔버스패브릭포스터 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_CANVAS
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_CANVAS frm_nm='캔버스패브릭포스터 완제품가(면적/규격 단가)'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_CANVAS,COMP_POSTER_CANVAS_FABRIC) disp_seq 1·addtn_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·off-grid ceiling)", use_yn: Y}
- rel: {rel: has_component, target: component-COMP_POSTER_CANVAS_FABRIC, qualifier: {disp_seq: 1, addtn: Y}, note: "면적매트릭스 완제품가(단일 구성요소·통가격)"}
- standards: {schema_org: "(Offer 계산 — schema.org 표현 불가)", note: "값 계산=evaluate_price 권위(D-18)·off-grid ceiling=앱"}
- 본문: 면적매트릭스형 = [가로×세로] 면적 셀단가 룩업(출력+소재+가공 포함 통가격). 고아 공식 아님(has_component 1개). off-grid(격자 밖 크기)=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행). 온톨로지는 배선까지, 값은 엔진.

### [component-COMP_POSTER_CANVAS_FABRIC] 실사 완제품가 (캔버스/레더/메쉬/타이벡 동형결합·면적 셀) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_CANVAS_FABRIC
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_CANVAS_FABRIC prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품비)·use_dims=[siz_width,siz_height,min_qty]·note '[동형결합] 가격표 동일 4소재 통합'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_CANVAS_FABRIC 52셀(siz_width×siz_height·값=전사표 행수요약·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B08 캔버스125↔comp_cd·면적 셀 (승계·재검증 2026-07-03 — live=동형결합 4소재 통합으로 갱신·round-2 D-WIRE 오모델 T-5 아님)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "전사표 [siz_width,siz_height,min_qty]", 셀행수_ref: "전사표(52셀)", 결합소재: "캔버스125·레더126·메쉬128·타이벡127(가격표 동일)"}
- 본문: 실사 완제품가(출력+소재+가공 포함 통가격)를 (가로×세로) 면적 셀로 저장. ★이름과 달리 가격표 동일 4소재(캔버스/레더/메쉬/타이벡)를 통합한 [동형결합]이라 125·126·127·128이 같은 comp 공유. 각 상품은 자기 공식으로 이 comp를 배선(125=PRF_POSTER_CANVAS·126=PRF_POSTER_LEATHER_AP·127=PRF_POSTER_TYVEK·128=PRF_POSTER_MESH·live formula_components 실측). ★**동시 빌드 owner=125(캔버스=namesake)** — 파싱 순서상 125가 이 노드를 소유하고 형제(126 레더 등)는 재사용 참조해야 함(126이 중복 mint 시 L-3=126측 결함·consolidation 소관). round-2 "28상품 단일 comp·2~6%만 적재" D-WIRE 오모델(T-5)과 다른 의도된 결합(52셀 전건 적재). 단가행 실값 나열 아님(D-22 접기)·값 계산=evaluate_price 권위.

---

## 옵션그룹 (CPQ) — 가공(봉제) 1그룹 택1 선택

옵션 = 공정 BUNDLE(pack §3.9). 옵션참조(ref_dim_cd=OPT_REF_DIM.04 공정)는 같은 부모 prd_cd 차원에
실재 필수(`fn_chk_opt_item_ref`·L-18). 가공 옵션이 부모 has_process(PROC_000080)를 가리킴=정합.

### [optgroup-125-gagong] 가공(봉제) 택1 선택 (min0/max1·mand=N) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000125
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000125,OPT_000010) opt_grp_nm=가공·usr_def_nm='오버로크 봉제 가공'·sel_typ=SEL_TYPE.01·min/max=0/1·mand_yn=N·use_yn=Y·disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000125,OPV_000028) ref_dim_cd=OPT_REF_DIM.04(공정)·ref_key1=PROC_000080·qty 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "N", items: "오버로크(OPV_000028·dflt)→PROC_000080"}
- rel: {rel: option_refs, target: process-PROC_000080, ref_key1: PROC_000080, note: "오버로크(OPV_000028·OPT_REF_DIM.04 공정·ref_key1=PROC_000080)"}
- 본문: 가공 옵션값 오버로크가 부모 has_process(봉제 PROC_000080)를 가리킨다(L-18 정합). 옵션=공정 BUNDLE(pack §3.9). ★봉제 5 variant(오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱)는 PROC_000080.prcs_dtl_opt param에 있으나 CPQ 옵션값은 현재 오버로크 1개만 노출 → variant 적재 위치는 실사 GAP-SL-2([[gap-125-seam-variant-location]]).

---

## 제약 (constraint) — nonspec 치수범위 1행

### [constraint-125-nonspec-range] 사용자입력 치수 범위 (RULE_001·nonspec 검증) {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000125
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints 키:(PRD_000125,RULE_001) rule_nm='사용자입력 치수 범위'·rule_typ_cd=RULE_TYPE.01·use_yn=Y·err_msg '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1·§3.9 실사 constraints 신규 발현 7상품(118/120/121/122/124/125/139 각 1행)·T-3(위키 0행 STALE)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {rule_typ_cd: "RULE_TYPE.01", logic_ref: "전사표(JSONLogic or/and·size_mode=nonspec 시 width/height 범위)", CN유형: "범위/입력검증(nonspec)"}
- rel: {rel: constrains, target: product-125-canvas-fabric-poster, note: "nonspec 입력 시 가로/세로 범위 검증(폼빌더 shape)"}
- 본문: nonspec(사용자입력) 치수 상품의 입력 범위 검증(가로/세로 범위는 전사표). ★pack §1.1 실사 constraints 신규 발현 7상품 중 125 1행(위키 "constraints 0행"은 STALE·T-3). logic은 폼빌더 정형 shape(raw JSONLogic escape hatch 아님·전사표). evaluate_price는 제약 미참조(위젯/주문이 validate 호출해야 강제·§31).

---

## 정직 GAP (원천 부재·범위 밖·미해소)

### [gap-125-roll-price-logic] 롤 소재 off-grid 가격 계산 로직 (엑셀 미기재 암묵지) {unknown}
- type: gap
- anchor: none  # 사유: 실사 대형 롤 임의 크기(격자 밖)의 가격 계산 로직(off-grid ceiling·롤 소재 원가)이 엑셀에 미기재된 암묵지 — KB use_dims 선언 밖(엔진/실무진)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 GAP(롤 소재 가격 계산 로직·엑셀 미기재 암묵지·실사 전체 영향)·source-registry §9 GAP-2", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_CANVAS_FABRIC 52셀(격자)·격자 밖 크기는 DB 룩업행 부재(앱 ceiling)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "캔버스패브릭포스터는 면적 셀 격자(52셀·특정 가로×세로)로 완제품가를 저장하나, nonspec 자유입력 치수(가로 200~1200·세로 200~3000 연속)는 격자에 없는 조합이 대부분이다. off-grid 시 '한 단계 큰 규격 ceiling'으로 룩업한다지만 그 구체 계산(어느 셀로 올림·롤 낭비폭 반영 여부)은 엑셀에 미기재된 암묵지"
- gap_fill_from: "실무진(롤 소재 가격 산정 규칙) + evaluate_price off-grid ceiling 구현 확인(값 계산은 KB 밖·D-18). source-registry §9 GAP-2(실사 전체 영향)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_CANVAS_FABRIC, note: "면적 격자 52셀(off-grid는 앱 ceiling)"}
- rel: {rel: references, target: product-125-canvas-fabric-poster, note: "nonspec 자유입력 상품(격자 밖 조합 대부분)"}
- 본문: 가격 경로 자체는 연결됨(priced_by→formula→component). 이 GAP은 '격자 밖 크기의 값 계산 로직'이 KB(use_dims 선언) 밖·엔진/암묵지임을 정직 선언(값 날조 금지·D-18 경계).

### [gap-125-seam-variant-location] 봉제 variant 적재 위치 (CPQ vs prcs_dtl_opt·GAP-SL-2) {unknown}
- type: gap
- anchor: none  # 사유: 봉제 5 variant가 PROC_000080.prcs_dtl_opt param과 CPQ option_items 두 곳 중 어디에 적재돼야 정답인지 미결(pack GAP-SL-2)
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000080 prcs_dtl_opt 유형 enum 5값(오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 125 가공 옵션값=오버로크 1개만(나머지 4 variant 미노출)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.6·§5 [GAP-SL-2] 봉제/족자 variant 적재 위치(Q-SL-2·CPQ option_items vs prcs_dtl_opt param)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "봉제 5 variant(오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱)가 PROC_000080.prcs_dtl_opt param에는 5값 다 있으나, 125 CPQ 가공 옵션(OPT_000010)에는 오버로크 1값만 노출됨. variant를 CPQ option_items로 펼칠지 prcs_dtl_opt param 인스턴스로 둘지 미결(적재 위치 불일치)"
- gap_fill_from: "실무진 Q-SL-2 + §31 제약/§7 dbmap 결정(변형 적재 위치)·라이브 교정 인간 승인 후"
- gap_owner: staff
- rel: {rel: references, target: optgroup-125-gagong, note: "가공 옵션(오버로크 1값만 노출)"}
- rel: {rel: references, target: process-PROC_000080, note: "봉제 param 5 variant 원천"}
- 본문: 옵션참조는 청정(오버로크→PROC_000080·L-18 정합)이나 나머지 4 variant의 적재 위치가 미결. 정직 GAP으로 선언(단정 금지·라이브 소관).
