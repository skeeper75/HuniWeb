---
id: product-025-transparent-photocard
type: product
anchor: t_prd_products/PRD_000025
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000025", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체 — 포토카드=7 구분 그룹 중 하나(디지털 시트2)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000310, note: "포토카드(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드(상위 계열)"}
  - {rel: has_size, target: size-SIZ_000012, note: "55x86 단일 재단사이즈(포토카드 공용·024와 공유 노드)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "출력용지 국전계열 SIZ_000522(315x467)·fn_best_plate 자동선택. ★PET는 종이 아님이나 라이브가 국전 출력판형 등록(현재값 그대로 기록)"}
  - {rel: uses_material, target: material-MAT_000144, note: "투명 PET 260g·USAGE.07 dflt(활성 BOM·07-01 교정분)"}
  - {rel: uses_material, target: material-MAT_000147, note: "반투명 PET 260g·USAGE.07(활성 BOM·07-01 교정분)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(칼라)만 — 양면 미제공(투명 낱장)"}
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: "N"}, note: "직각 모서리(모서리옵션)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: "N"}, note: "둥근 모서리(모서리옵션)"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: "N"}, note: "화이트인쇄(투명 소재 백색 별색)·가격 미배선(아래 gap-025-white-spot)"}
  - {rel: has_qty_rule, target: qty-025, note: "min 20·incr 20·묶음 20 QTY_UNIT.06"}
  - {rel: priced_by, target: formula-PRF_PHOTOCARD_CLEAR, note: "투명세트 고정가·V3 공식분리(silent 합산 교정·260623)"}
  - {rel: has_option_group, target: optgroup-OPT_000022, note: "인쇄(도수·단면만)"}
  - {rel: has_option_group, target: optgroup-OPT_000023, note: "종이(PET)"}
  - {rel: has_option_group, target: optgroup-OPT_000024, note: "모서리(직각/둥근)"}
  - {rel: has_option_group, target: optgroup-OPT_000025, note: "화이트별색(BLOCKED·차원행 부재)"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(셋트 부모/구성원 아님 — t_prd_product_sets 0/0 실측)
  archetype: "고정가(투명세트 1행)"
  min_qty: 20               # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(투명포토카드)", config_ont: "component type"}
tags: [디지털인쇄, 포토카드, 투명, 고정가]
updated: 2026-07-03
---

# product-025-transparent-photocard — 투명포토카드 (PRD_000025)

디지털인쇄 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원
등록 없음 — [[product-type-classification-sot]] 준수). 포토카드(PRD_000024)의 자매 상품으로,
불투명 아트지 대신 **투명/반투명 PET 260g** 낱장에 **단면 칼라**로 인쇄하고, 투명 소재 특유의
**화이트인쇄(백색 별색)** 공정과 모서리(직각/둥근) 후가공을 갖는다. 가격은 고정가 공식
`PRF_PHOTOCARD_CLEAR`(투명세트 전용·값 계산=`evaluate_price` 권위·D-18 경계)로 결정된다.

- 파일 업로드·에디터 둘 다 지원(`file_upload_yn=Y`·`editor_yn=Y`).
- 도수는 인쇄옵션(POPT)이지 색상코드가 아님([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]).
  투명포토카드는 **단면(POPT_000001)만** 제공(024 포토카드의 양면은 없음).
- 판형: 라이브가 국전계열 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]]·SIZ_000522)를
  등록·`fn_best_plate` 자동선택([[harness-domain-rules-12-260701]]). ★PET는 종이류가 아니라
  [[rule/rules#RULE_plate_paper_only]]와 긴장 관계 — 여기서는 relitigate 없이 **라이브 현재값만** 기록.
- **투명 특성 3요소**(024 대비 차이): ① 자재=투명/반투명 PET(아트지 아님) ② 화이트인쇄 공정
  PROC_000008 ③ 화이트별색 옵션그룹 OPT_000025. 이 중 ②③의 **가격 배선이 끊겨** 있어
  아래 GAP으로 정직 선언한다(지어내지 않음).
- 추가상품(OPP비접착봉투)은 대상 product 노드 미구축 → GAP으로 정직 선언(아래 [[gap-025-addon-envelope]]).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_025.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-025-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000025 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 20 | 10000 | 20 | QTY_UNIT.02 | Y | Y |

### 사이즈 치수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000012 | 55x86 | 57x88 | 55x86 |
| SIZ_000522 | 315x467 | 315x467 | 305x457 |

> SIZ_000012(55x86)=포토카드 재단사이즈(024와 공유 노드)·SIZ_000522(315x467)=국전계열 출력용지(판형).

### 자재 BOM (전사·활성 del_yn=N만)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (active) @ 2026-07-03 -->
| mat_cd | 자재명 | usage_cd | dflt |
|---|---|---|---|
| MAT_000144 | 투명 PET 260g | USAGE.07 | Y |
| MAT_000147 | 반투명 PET 260g | USAGE.07 | N |

> ★자재 교정 이력(07-01): 종전 추상 자재 MAT_000178(PET·mat_typ .08)이 소프트삭제(`t_prd_product_materials`
> del_yn=Y)되고 구체 자재 MAT_000144(투명 PET 260g)·MAT_000147(반투명 PET 260g)로 교체됐다.
> 단, CPQ 종이 옵션(OPV_000080)은 여전히 삭제된 MAT_000178을 참조 → 불일치(아래 [[gap-025-option-material-stale]]).

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand |
|---|---|---|
| PROC_000027 | 직각 | N |
| PROC_000028 | 둥근 | N |
| PROC_000008 | 화이트인쇄 | N |

> 모서리(직각/둥근)는 CPQ 옵션그룹으로도 노출(아래). **화이트인쇄(PROC_000008)** 는 상품에 결합돼
> 있으나 CPQ 화이트별색 옵션(OPV_000083)·별색 가격구성요소와 미링크 → [[gap-025-white-spot]].

### CPQ 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max | mand |
|---|---|---|---|---|
| OPT_000022 | 인쇄 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000023 | 종이 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000024 | 모서리 | SEL_TYPE.01 | 0/1 | N |
| OPT_000025 | 화이트별색 | SEL_TYPE.01 | 0/1 | N |

### CPQ 옵션 아이템 → 차원 참조 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPT_000022 | OPV_000079 | 단면 | OPT_REF_DIM.06 | 1 |  |
| OPT_000023 | OPV_000080 | PET | OPT_REF_DIM.03 | MAT_000178 | USAGE.07 |
| OPT_000024 | OPV_000081 | 직각 | OPT_REF_DIM.04 | PROC_000027 |  |
| OPT_000024 | OPV_000082 | 둥근 | OPT_REF_DIM.04 | PROC_000028 |  |

> `ref_dim_cd`가 옵션값이 가리키는 실물 차원을 정한다: `.06`=인쇄옵션(ref_key1=opt_id·1단면),
> `.03`=자재(ref_key1=mat_cd·ref_key2=usage_cd), `.04`=공정(ref_key1=proc_cd). ★종이 옵션(OPV_000080)의
> ref_key1=**MAT_000178**은 소프트삭제된 자재라 활성 BOM(144/147)과 불일치([[gap-025-option-material-stale]]).
> 화이트별색 그룹(OPT_000025)의 옵션 OPV_000083은 **option_items 차원행이 없음**(라이브 note "BLOCKED,
> 차원행 부재") → option_refs 엣지 미배선([[gap-025-white-spot]]).

### 추가상품 템플릿 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates @ 2026-07-03 -->
| tmpl_cd | 템플릿명 | base_prd_cd | base 상품명 | base 유형 |
|---|---|---|---|---|
| TMPL-000012 | OPP비접착봉투 60x90 mm 20장 | PRD_000002 | OPP비접착봉투 | PRD_TYPE.03 |
| TMPL-000030 | OPP비접착봉투 60x90 mm 50장 | PRD_000002 | OPP비접착봉투 | PRD_TYPE.03 |

> `has_addon`의 실 배선=product→template(tmpl_cd)→`t_prd_templates.base_prd_cd`(R14·F-7). 대상
> product(PRD_000002 OPP비접착봉투·기성상품 .03) 노드가 아직 KB에 없어 `has_addon` 엣지를
> 걸면 끊긴 링크가 된다 → 아래 GAP으로 정직 선언(지어내지 않음).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-025-transparent-photocard` --priced_by--> [[formula/digital-formulas#formula-PRF_PHOTOCARD_CLEAR]]
--has_component--> `COMP_PHOTOCARD_CLEAR_SET`([[formula/digital-components]]). 단일 구성요소의
`use_dims`가 이 상품 가격이 어떤 축으로 달라지는지 선언한다(값 계산은 엔진). ★공식·구성요소 노드는
공유 축(formula/)에 아직 없어 **needed_shared_nodes로 반환**(통합 단계 mint) — priced_by 엣지는 그
mint 후 완결된다.

### 가격 배선 PRF_PHOTOCARD_CLEAR (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_PHOTOCARD_CLEAR_SET | Y | PRICE_TYPE.02 | 포토카드 완제품가 투명세트 | `["siz_cd", "bdl_qty", "min_qty"]` |

> 골든 스냅샷 라벨: 위 배선은 live-snapshot 20260702_1119 기준. 투명세트가=siz_cd·bdl_qty·min_qty 차원의
> 고정가 단가표. ★모서리(모서리옵션)·화이트별색은 use_dims에 없어 **가격 차원이 아님**(현재 무가치 반영/
> 화이트별색은 미배선). 024 포토카드의 제작방식(세트/대량) 분기축도 여기엔 없다(투명은 세트 단일).

---

## 이 상품 전용 하위 노드

> SIZ_000012(55x86)·모서리 공정(PROC_000027/028)은 공유 축이라 여기서 재선언하지 않는다(중복 노드
> 생성 금지·L-3). 아래는 투명포토카드 전용 CPQ 옵션그룹·수량규칙·GAP이다.

### [qty-025] 투명포토카드 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_product_bundle_qtys/PRD_000025
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "테이블:t_prd_product_bundle_qtys 키:PRD_000025", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {bdl_unit_typ_cd: "QTY_UNIT.06", min_max_incr_ref: "본문 전사표(min 20·max 10000·incr 20)", note: "묶음수 bdl_qty=20·상품 qty_unit_typ_cd=QTY_UNIT.02와 bundle 단위 QTY_UNIT.06 상이(전사값 그대로 기록)"}

### [optgroup-OPT_000022] 인쇄 (도수·단면만) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000025
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000025,OPT_000022)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000022", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택·단면(OPV_000079)만·양면 없음"}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}, note: "단면(ref_key1=opt_id 1)"}

### [optgroup-OPT_000023] 종이 (PET) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000025
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000025,OPT_000023)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000023", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", opt_item_ref: "OPV_000080 ref_key1=MAT_000178(소프트삭제)", note: "min/max 1/1 필수 단일선택. ★option item OPV_000080이 삭제 자재 MAT_000178 참조 → 활성 BOM(144/147)과 불일치라 option_refs 엣지 미배선(L-18 오염 방지)·gap-025-option-material-stale"}

### [optgroup-OPT_000024] 모서리 (직각/둥근) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000025
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000025,OPT_000024)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000024", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "min/max 0/1 선택·직각 기본. 모서리는 가격 use_dims에 없음(무가치·투명세트 고정가에 포함)"}
- rel: {rel: option_refs, target: process-PROC_000027, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000027"}, note: "직각"}
- rel: {rel: option_refs, target: process-PROC_000028, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000028"}, note: "둥근"}

### [optgroup-OPT_000025] 화이트별색 (BLOCKED) {defect}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000025
- badge: defect
- current_value: "화이트별색 옵션 OPV_000083 존재하나 t_prd_product_option_items 차원행 없음·화이트인쇄 공정(PROC_000008)·별색component(COMP_PRINT_SPOT_WHITE_S1) 미링크 (live-snapshot 20260702_1119)"
- authority_value: "투명 소재 백색 별색은 별색공정(PROC_000007 계열)+통합별색 구성요소 COMP_PRINT_SPOT_WHITE_S1로 배선돼야 가격 발현(pack §3.3·메모리 whiteprint-material-4color-unified-spot-component-260630)"
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options 키:(PRD_000025,OPV_000083,OPT_000025) note='화이트별색 공정 — BLOCKED(차원행 부재, 화이트 별색공정 미링크)'", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000025", opt_grp_nm: "화이트별색", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "옵션은 있으나 차원·가격 미배선 → option_refs 엣지 미생성. 상세 GAP=gap-025-white-spot"}

### [gap-025-white-spot] 화이트별색 옵션 차원·가격 미배선 (BLOCKED) {unknown}
- type: gap
- anchor: none  # 사유: 화이트별색 옵션(OPV_000083)에 option_items 차원행·별색 가격배선이 없음(원천 부재)
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000025,OPV_000083) note='BLOCKED(차원행 부재, 화이트 별색공정 미링크)'", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "투명포토카드 화이트별색(백색 별색)이 CPQ 옵션(OPV_000083)·화이트인쇄 공정(PROC_000008)까지는 등록됐으나, ①option_items 차원행 부재로 손님 선택→차원 환원이 끊기고 ②가격공식 PRF_PHOTOCARD_CLEAR에 별색 구성요소(COMP_PRINT_SPOT_WHITE_S1) 미배선이라 화이트인쇄가 가격에 발현되지 않는다"
- gap_fill_from: "별색 배선 트랙(§27 배선·COMP_PRINT_SPOT_WHITE_S1 통합별색 component 재사용) + 화이트별색 option_item 차원행 등록 — 실무진/dbmap 인간 승인. 참조=메모리 transparent-postcard-price-fix-260629·whiteprint-material-4color-unified-spot-component-260630"
- gap_owner: 실무진
- rel: {rel: references, target: RULE_dataline_neq_wiring, note: "단가행/공정 존재≠배선 완료"}

### [gap-025-option-material-stale] 종이 옵션이 소프트삭제 자재(MAT_000178) 참조 {unknown}
- type: gap
- anchor: none  # 사유: option_item 참조와 활성 BOM 불일치의 정답(재포인팅 여부)이 원천에 확정 안 됨
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "키:(PRD_000025,OPV_000080) ref_key1=MAT_000178", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000025,MAT_000178) del_yn=Y·(PRD_000025,MAT_000144/147) del_yn=N", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "종이 옵션 OPV_000080의 자재 참조 ref_key1=MAT_000178은 07-01 교정으로 소프트삭제됐고 활성 BOM은 MAT_000144(투명)/MAT_000147(반투명)이다. 옵션 참조가 활성 자재로 재포인팅돼야 하는지(fn_chk_opt_item_ref 정합)의 정답이 확정 안 됨"
- gap_fill_from: "dbmap 교정 트랙(option_items.ref_key1 재포인팅 vs MAT_000178 재활성) — 인간 승인. ★[HARD] IMPORT 등록 자재 임의 삭제 금지([[rule/rules#RULE_import_material_no_delete]])"
- gap_owner: dbmap
- rel: {rel: references, target: RULE_import_material_no_delete, note: "IMPORT 자재 삭제 금지 규칙 연동"}

### [gap-025-addon-envelope] 투명포토카드 추가상품(봉투) 대상 product 노드 미구축 {unknown}
- type: gap
- anchor: none  # 사유: has_addon 대상 product(PRD_000002)가 아직 KB에 없음 — 끊긴 링크 방지
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons 키:PRD_000025(TMPL-000012·TMPL-000030→base PRD_000002)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "투명포토카드 추가상품 OPP비접착봉투(TMPL-000012 20장·TMPL-000030 50장→base_prd_cd=PRD_000002·기성상품 .03)의 대상 product 노드가 KB에 없어 has_addon 엣지를 아직 못 건다"
- gap_fill_from: "기성상품(.03) 노드 집필 시 product-002 신설 후 product-025→product-002 has_addon 배선(대표 8상품 로드맵 밖·프로모션 대기)"
- gap_owner: 설계
