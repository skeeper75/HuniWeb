<!-- product-local sub-nodes: E2 category·E7 bundle_qty·E9 price_formula·E10 price_component·gap for PRD_000131 프레임리스우드액자. -->
<!-- ★공유 노드 재사용(중복 mint 방지·L-3): -->
<!--   - size-SIZ_000174(A3) = product-047-small-flyer.md owner → 재사용 참조만(재정의 안 함). -->
<!--   - size-SIZ_000197(A2) = 공유 axis/sizes.md owner → 재사용 참조만. -->
<!--   - process-PROC_000014/015(유광/무광 라미네이팅) = 공유 axis/processes.md owner(260703 승격) → 재사용 참조만. -->
<!--   - category-CAT_000080(보드액자) = 병렬 형제 129/130/132/133/134 동시 귀속 공유 leaf → 여기 정의(node 실재 보증)+needed_shared 반환(consolidation dedupe). -->
<!-- ★여기 신설(131 고유·타 빌더 미정의): category-CAT_000080(공유 보증)·qty-131·formula-PRF_POSTER_FRAMELESS -->
<!--   ·component-COMP_POSTER_FRAMELESS_WOOD(★실사 고정가형 첫 공식/구성요소)·gap 4. 실사 고정가 공유 축 승격 후보=needed_shared. -->
<!-- ★수치(규격·고정가 SHAPE)는 아래 전사표(transcribed-by·transcribe_product_131.py)에만. props raw 미기입(D-9·L-12). -->
<!-- ★가격 값(unit_price)은 전사하지 않음 — 연결·차원·격자완전성까지만(D-18·값=evaluate_price). -->

# product-131 하위 노드 (프레임리스우드액자 — 실사 고정가형 전용 마스터 + GAP)

프레임리스우드액자(PRD_000131)가 여기 신설하는 것 = 보드액자 카테고리(★병렬 형제 공유·node 실재 보증)·
수량규칙·가격공식·가격구성요소(★실사 고정가형 첫 노드)·GAP 4. 규격 사이즈(A3/A2)·라미 공정은 공유 축
(product-047·axis/sizes·axis/processes)이 이미 소유해 재사용 참조만 한다(중복 mint 금지·L-3). 상품→축 연결(has_size·has_process·priced_by·has_qty_rule)은
[[product-131-frameless-wood-frame]]가 건다. 판형(plate_size)은 실사 비종이류라 노드 없음(파일사양
placeholder·pack §3.8·T-7). 인쇄옵션(도수)도 없음(실사 대형잉크젯 풀컬러·po=0). CPQ 옵션그룹·제약규칙 0행
(nonspec_yn=N·설계상 해당 없음).

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_131.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_131.py` 재실행 시 동일 출력(멱등). JSON 캐시=`cache/transcribed-131-260703.json`.

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000131 @ 2026-07-03 -->
| cat_cd | 분류명 | 상위 | lvl | main |
|---|---|---|---|---|
| CAT_000080 | 보드액자 | CAT_000004 | 2 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000131 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |
|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | N | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | N | N |

자재(t_prd_product_materials) 활성 행수 = 0 (★우드 프레임 소재 미등록·완제품 통가격 baked·pack §3.5 보드/우드 5상품 L1 빈값 AMBIGUOUS·GAP)

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_proc_processes+t_prd_product_processes PRD_000131 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | junction_del_yn |
|---|---|---|---|---|
| PROC_000014 | 유광라미네이팅 | PROC_000013 | N | N |
| PROC_000015 | 무광라미네이팅 | PROC_000013 | N | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (★전 행 output_paper_typ 공란=파일사양 placeholder·비종이류 판형 무의미·pack §3.8·T-7) PRD_000131 @ 2026-07-03 -->
| siz_cd | 라벨 | 용도 |
|---|---|---|
| SIZ_000175 | 303x426 | JPG 파일사양(판형 아님) |
| SIZ_000303 | 426x600 | JPG 파일사양(판형 아님) |

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000131 @ 2026-07-03 -->
| 항목 | 값 |
|---|---|
| prd_nm | 프레임리스우드액자 |
| prd_typ_cd | PRD_TYPE.01 |
| nonspec_yn(★N=사용자입력 없음) | N |
| min_qty | 1 |
| max_qty | 1000 |
| qty_incr | 1 |
| qty_unit | QTY_UNIT.01 |
| use_yn | Y |
| del_yn | N |
| file_upload | Y |
| editor | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000131 @ 2026-07-03 -->
| frm_cd | 상품 바인딩 | comp_cd(배선) | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|---|
| PRF_POSTER_FRAMELESS | True | COMP_POSTER_FRAMELESS_WOOD | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | ["siz_cd", "min_qty"] |

<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_POSTER_FRAMELESS_WOOD (★고정가 SHAPE·값 미전사) @ 2026-07-03 -->
| comp_cd | 차원(use_dims) | 규격셀수 | siz 셀 | 수량밴드수 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_FRAMELESS_WOOD | siz_cd×min_qty | 2 | SIZ_000174,SIZ_000197 | 1 | 2 | True | False | True |

> **격자완전(grid_full)=True** = 규격 2셀(A3·A2) × 수량 1밴드 = 2행이 이 빠짐 없이 채워짐(미적재 셀 0).
> **규격=가격셀 정합=True**: 상품 등록 규격 2행(SIZ_000174/197)이 고정가 단가표 2셀과 정확히 일치(A1 없음).
> ★**수량축충전=False**: 2셀 모두 min_qty=1 단일 밴드 → 규격당 통가격(수량구간 할인 없음). 값=evaluate_price(D-18).
> ★**면적매트릭스와 다름**: siz_width×siz_height 순서쌍이 아니라 등록 규격(siz_cd) 키 룩업 → off-grid ceiling·비대칭 개념 없음(nonspec_yn=N).

## 사이즈·공정 (재사용 참조 — 공유 축 owner·중복 mint 금지)

★**consolidation 정합:** 131 규격/라미 공정은 전부 다른 파일이 이미 소유하므로 131은 **재사용 참조만**
(L-3 중복 mint 금지)·has_size/has_process 프론트매터 엣지는 유지(target 실재):
- `size-SIZ_000174`(A3 297x420) = **product-047(소량전단지) owner**(재사용·A계열 공용).
- `size-SIZ_000197`(A2 420x594) = **공유 [axis/sizes.md](../axis/sizes.md) owner**(재사용).
- `process-PROC_000014`(유광라미)·`process-PROC_000015`(무광라미) = **공유 [axis/processes.md](../axis/processes.md)
  owner**(260703 승격). ★118은 이 라미를 07-01 재키잉으로 코팅(115/116)으로 교체했으나 131은 라미를
  그대로 보유(마스터 활성·junction del_yn=N). 131은 이 공정을 CPQ 옵션 없이 붙여둠(통가격 baked 추정·
  [[#gap-131-lamination-no-option]]).

실사 사이즈 = 이산 등록 규격 SIZ(A3/A2)만(nonspec_yn=N·연속범위 없음·pack §3.2). 판걸이수(UP수)는 종이류
파생값이라 실사 무의미(판형 절). 고정가 단가는 규격(siz_cd) 키로 저장(면적 siz_width/siz_height 아님·가격
구성요소 절).

---

## 카테고리 (category) — 보드액자 (실사 leaf·★병렬 다중귀속·needed_shared)

★**consolidation 정합:** `category-CAT_000080`(보드액자·cat_lvl 2·상위 CAT_000004 포스터)는 131의 유일 등록
분류이자, **병렬 보드/액자 빌더 129 폼보드·130 포맥스보드·132 레더아트액자·133/134 등이 동시에 귀속**하는
공유 leaf다(전부 CAT_000080). 실사 보드액자 카테고리는 공유 categories.md에 아직 없어 여기 정의하고
**needed_shared_nodes**로 반환(consolidation이 단일 소유권으로 이관·향후 승격 대상). ★동시 빌드 중 여러
형제가 이 노드를 mint하면 L-3 중복이 뜰 수 있으나(consolidation이 dedupe), 아무도 정의 안 하면 I-2 끊긴
링크(더 나쁨)라 131이 실재 노드를 보증한다. 상위 포스터(CAT_000004)는 면적매트릭스 실사 형제(119 등)
소유 — 131은 등록 junction이 있는 leaf CAT_000080만 in_category(직접 CAT_000004 junction 없음).

### [category-CAT_000080] 보드액자 (실사 leaf·cat_lvl 2·129~134 공유·131 등록 분류) {verified}
- type: category
- anchor: t_cat_categories/CAT_000080
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000080 cat_nm=보드액자·cat_lvl=2·upr_cat_cd=CAT_000004·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "테이블:t_prd_product_categories 키:(PRD_000131,CAT_000080) main_cat_yn=N·131 유일 등록 분류(129/130/132 형제도 동일 leaf 귀속)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_lvl: 2, upr_cat_cd: "CAT_000004", main_cat_yn_for_131: "N", 공유귀속: "129 폼보드·130 포맥스보드·131 프레임리스우드액자·132 레더아트액자 등(consolidation dedupe 대상)"}
- 본문: 보드/액자 계열 실사 leaf(포스터 CAT_000004 하위). 소재·완성형태(보드/우드 프레임)가 상품 정체를 가르는 실사 특성(pack §0 특성1)이 카테고리에 반영. ★병렬 형제 다중귀속 공유 노드(needed_shared·단일 소유권은 consolidation 소관·[[axis/categories]] 승격 대기).

---

## 수량규칙 노드 (product-local)

### [qty-131] 프레임리스우드액자 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000131
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000131 min_qty/max_qty/qty_incr(1/1000/1)·qty_unit_typ_cd=QTY_UNIT.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/1000/1)", bdl_unit_typ_cd: "QTY_UNIT.01", bundle_qtys_rows: 0, note: "★고정가형이라 수량축이 가격 차원이 아님(단가표 2셀 min_qty=1 단일 밴드). 규격당 통가격·총액=통가격×수량(수량구간 할인 없음)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 1000·incr 1). t_prd_product_bundle_qtys 0행 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 가격은 규격별 통가격(수량 무관).

---

## 가격공식·구성요소 (★실사 고정가형 첫 상품 — 상품-local mint·needed_shared_node)

실사 = 2 가격모델 공존(pack §3.10). 118·125 등은 **면적매트릭스형**(포스터사인 [가로×세로] 셀단가)이고,
131은 **고정가형**(등록 규격 siz_cd 키 룩업·수량축 단일밴드). 디지털 원자합산(PRF_DGP_*)·면적매트릭스
(PRF_POSTER_CANVAS 등)·스티커 고정룩업(PRF_STK_FIXED)과 구별되는 **실사 고정가 아키타입 첫 노드**를 여기
신설(실사 고정가 15상품 향후 승격 후보).

### [formula-PRF_POSTER_FRAMELESS] 프레임리스우드액자 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_FRAMELESS
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_FRAMELESS frm_nm='프레임리스우드액자 완제품가(면적/규격 단가)'·note '포스터사인 프레임리스우드액자 소재/사이즈/수량별 완제품 통가격'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_FRAMELESS,COMP_POSTER_FRAMELESS_WOOD) disp_seq 1·addtn_yn=Y·1행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000131,PRF_POSTER_FRAMELESS) 바인딩", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_POSTER_FRAMELESS_WOOD, qualifier: {disp_seq: 1, addtn: Y}, note: "고정가 완제품가(단일 구성요소·통가격)"}
- props: {archetype: "고정가형(fixed-price·siz_cd 룩업·use_dims=[siz_cd,min_qty])", use_yn: Y, note: "131 바인딩 전용 공식. 단일 구성요소(완제품 통가격)를 규격 siz_cd 셀에서 조회(evaluate_price). 면적매트릭스 아님(가로×세로 순서쌍 없음)"}
- 본문: 프레임리스우드액자 가격공식. 단일 구성요소(완제품 통가격) 1건 배선 — 인쇄·용지·코팅·가공을 원자 합산하지 않고 등록 규격(siz_cd)별 완제품 통가격을 조회한다. 고아 공식 아님(has_component 1개). 배선 타깃 [[component-COMP_POSTER_FRAMELESS_WOOD]]. ★118(면적매트릭스)와 달리 use_dims=[siz_cd,min_qty]라 off-grid ceiling·비대칭이 없다(등록 규격 키 룩업). 값 계산=evaluate_price 권위(D-18·[[rule/rules#RULE_price_value_boundary]]).

### [component-COMP_POSTER_FRAMELESS_WOOD] 프레임리스우드액자 완제품가 (고정가 siz_cd 셀) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_FRAMELESS_WOOD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_FRAMELESS_WOOD comp_nm='프레임리스우드액자 완제품가'·comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품비)·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd,min_qty]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_FRAMELESS_WOOD 2셀(siz_cd별·값=전사표 SHAPE·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.1 고정가형 15상품 프레임리스우드액자131([수량×규격] 블록·B14 포스터사인·승계·재검증 2026-07-03 — 면적매트릭스 13상품 아님)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "실사 액자 완제품 통가격(소재+출력+가공 포함)·고정가 규격 룩업", 단가행_ref: "전사표 고정가 SHAPE(2셀=규격2×수량1·격자완전 True·수량축 미충전·규격=가격셀 정합 True)", archetype: "고정가형(fixed-price·siz_cd 룩업·off-grid 개념 없음)"}
- 본문: 실사 액자 완제품가 구성요소. use_dims 2축(규격 siz_cd × 수량 min_qty)으로 셀단가가 달라진다(차원 선언까지·D-22 단가행 접기). 규격 2셀(A3·A2) × 수량 1밴드 = 2셀 완전격자(전사표 SHAPE). ★118의 [동형결합]과 달리 131 전용 단일 공식이 이 comp를 배선(formula_components 실측 1:1). ★소재+출력+가공이 통가격에 baked라 자재 미등록([[#gap-131-material-absent]])·라미 공정 미노출([[#gap-131-lamination-no-option]])과 정합. 값=evaluate_price(값·골든 미전사·D-18·[[rule/rules#RULE_price_value_boundary]]).

---

## 정직 GAP (원천 부재·미결·AMBIGUOUS)

### [gap-131-material-absent] 우드 프레임 본체 소재 미등록 (통가격 baked·pack §3.5) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_materials 131 행 0개 — 우드 프레임을 자재로 등록할지 통가격 baked로 둘지 미결(원본 미명시·AMBIGUOUS)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials PRD_000131 활성 행수 0(전사표)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 보드/우드 5상품 소재 L1 빈값(원본 미명시 정당·AMBIGUOUS)·C-04 자재유형", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "프레임리스우드액자 본체(우드 프레임+출력물)의 자재가 t_prd_product_materials에 0행이다. 완제품가 note가 '소재+출력+가공 포함 통가격'이라 소재비가 통가격에 baked된 것으로 보이나, 우드 프레임을 별도 자재(parent+usage_cd)로 등록해야 하는지 통가격 baked로 두는 게 정답인지 원본(L1)에 미명시"
- gap_fill_from: "실무진(보드/우드 5상품 소재 정책·pack §3.5) + L1 원본 자재 셀 확인. 통가격 baked면 자재 미등록이 정당, 별도 등록이 필요하면 dbmap 트랙(인간 승인)"
- gap_owner: staff
- rel: {rel: references, target: product-131-frameless-wood-frame, note: "자재 0행 상품(통가격 baked 추정)"}
- rel: {rel: references, target: component-COMP_POSTER_FRAMELESS_WOOD, note: "소재+출력+가공 포함 통가격(자재비 baked)"}
- 본문: 가격 경로는 연결됨(priced_by→formula→component·2셀 완전격자)이라 견적 0 위험 없음. 이 GAP은 '우드 프레임을 자재로 명시할지'가 원본 미명시라 정직 선언(자재 날조 금지·IMPORT 자재 삭제 금지 원칙과 별개·[[rule/rules#RULE_import_material_no_delete]]).

### [gap-131-lamination-no-option] 라미네이팅 공정 CPQ 미노출 (붙었으나 옵션·가격 미표현) {unknown}
- type: gap
- anchor: none  # 사유: 라미 공정 2종(PROC_000014/015)이 상품에 붙었으나 CPQ 옵션그룹 0행·통가격 baked인지 휴면 결함인지 미결
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:(PRD_000131,PROC_000014)·(PRD_000131,PROC_000015) mand_proc_yn=N·junction del_yn=N(전사표)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups PRD_000131 행 0개(코팅 옵션 없음·118은 optgroup-118-coating 보유)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "유광/무광 라미네이팅(PROC_000014/015)이 131 has_process로 붙어 있으나, 이를 참조하는 CPQ 옵션그룹이 0행이라 손님이 코팅을 고르는 축이 없다. 통가격 note가 '가공 포함'이라 baked된 것으로 보이나, 118처럼 코팅 옵션으로 노출해야 하는지(손님 선택) 통가격 baked로 두는 게 정답인지 미결"
- gap_fill_from: "실무진(액자 코팅이 손님 선택인지 고정 가공인지) + 예전사이트 실화면(코팅 선택 UI 유무). baked면 옵션 미노출 정당, 선택이면 CPQ 옵션 적재(BATCH-6·§7 dbmap 인간 승인)"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000014, note: "유광라미(붙었으나 옵션 미노출)"}
- rel: {rel: references, target: process-PROC_000015, note: "무광라미(붙었으나 옵션 미노출)"}
- 본문: has_process는 실재하나 CPQ 옵션·가격 표현이 없다. 통가격 baked 추정이나 확증 원천 부재라 정직 선언(단정 금지). 가격 경로 자체는 통가격으로 연결됨(견적 0 아님).

### [gap-131-frame-attribution] 액자 귀속 — 공정(액자가공) vs 부속(프레임 별매) (GAP-SL-4·C-14) {unknown}
- type: gap
- anchor: none  # 사유: 액자 131/132의 완성이 공정(액자가공)인지 부속(프레임 별매 addon)인지 미결(pack §3.12 AMBIGUOUS)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.12 C-14 액자 귀속 AMBIGUOUS(131/132 공정 vs 부속)·[GAP-SL-4]·Q-SL-4", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons PRD_000131 행 0개(sets도 0행·부속 미연결)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "프레임리스우드액자의 '액자 프레임'이 상품 자체의 완성 공정(액자가공·통가격 baked)인지, 프레임을 별매 부속(addon/set)으로 딸리는 것인지 미결. addon=0·set=0이라 현재는 통가격 단일 상품이나, pack §3.12는 액자 131/132 귀속을 AMBIGUOUS로 남김(C-14)"
- gap_fill_from: "실무진 Q-SL-4(액자=공정 vs 부속). 부속이면 프레임 PRD/자재 재연결(search-before-mint·라이브 addon/set 인간 승인), 공정이면 통가격 baked 정당"
- gap_owner: staff
- rel: {rel: references, target: product-131-frameless-wood-frame, note: "액자 귀속 미결 상품(addon/set 0행)"}
- 본문: addon/set 0행이 결함인지 정당인지는 액자 귀속 판정에 달렸다. 통가격 단일 상품으로 보면 정당, 프레임 별매 모델이면 부속 미연결이 잔존 결함. pack §3.12가 미결로 남긴 AMBIGUOUS를 그대로 정직 선언(단정 금지·GAP-SL-4).

### [gap-131-price-basis] 고정가 완제품가 산정 근거 문서 부재 (엑셀 미기재 암묵지) {unknown}
- type: gap
- anchor: none  # 사유: 규격별 우드액자 통가격이 어떤 원가/마진 규칙으로 도출됐는지 어느 엑셀/문서에도 명시 없음(암묵지)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/source-registry.md", source_locator: "문서:§9 GAP-2 롤/소재 가격 계산 로직(엑셀 미기재 암묵지·실사 전체 영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices COMP_POSTER_FRAMELESS_WOOD 2셀(규격별 통가격·값 적재됨·산정근거 문서 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "규격별(A3·A2) 우드액자 완제품 통가격이 우드 원가/프레임 규격/출력·가공비 어떤 규칙으로 도출됐는지 — 값은 라이브에 적재됐으나(2셀) 산정 근거 문서 부재"
- gap_fill_from: "실무진 확인(source-registry §9 GAP-2·실사 전체 영향). 예전사이트 골든 대조로 값 정합 검증 가능하나 산정식 자체는 암묵지"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_FRAMELESS_WOOD, note: "고정가 2셀(산정 근거 문서 부재)"}
- 본문: 가격 경로는 연결됨([[formula-PRF_POSTER_FRAMELESS]]→[[component-COMP_POSTER_FRAMELESS_WOOD]]·2셀 완전격자)이라 견적 0 위험 없음. 다만 통가격이 **어떻게** 산정됐는지는 엑셀 미기재 암묵지(실사 전체 공통 GAP). 온톨로지는 연결·차원까지, 값 계산은 evaluate_price 권위이므로 이 GAP은 값 정합이 아니라 "산정 근거 문서 부재"의 정직 선언.
