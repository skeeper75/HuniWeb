---
id: product-024-photocard
type: product
anchor: t_prd_products/PRD_000024
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000024", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체 — 포토카드=7 구분 그룹 중 하나(디지털 시트2)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000310, note: "포토카드(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드(상위 계열)"}
  - {rel: has_size, target: size-SIZ_000012, note: "55x86 단일 재단사이즈(포토카드 전용)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "종이류(아트지)라 판형 유효·국전 SIZ_000499·fn_best_plate 자동선택"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g·USAGE.07 단일 슬롯"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(칼라)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(칼라)"}
  - {rel: has_process, target: process-PROC_000014, qualifier: {mand: "N"}, note: "유광라미네이팅(코팅옵션)"}
  - {rel: has_process, target: process-PROC_000015, qualifier: {mand: "N"}, note: "무광라미네이팅(코팅옵션)"}
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: "N"}, note: "직각 모서리(모서리옵션)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: "N"}, note: "둥근 모서리(모서리옵션)"}
  - {rel: has_qty_rule, target: qty-024, note: "min 20·incr 20·묶음 20 QTY_UNIT.06"}
  - {rel: priced_by, target: formula-PRF_PHOTOCARD_NORMAL, note: "고정가·세트 vs 대량 분기(opt_grp:OPT_000084)"}
  - {rel: has_option_group, target: optgroup-OPT_000017, note: "인쇄(도수)"}
  - {rel: has_option_group, target: optgroup-OPT_000018, note: "종이"}
  - {rel: has_option_group, target: optgroup-OPT_000019, note: "코팅"}
  - {rel: has_option_group, target: optgroup-OPT_000020, note: "모서리"}
  - {rel: has_option_group, target: optgroup-OPT_000084, note: "제작방식(세트/대량)=가격 분기축"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(셋트 부모/구성원 아님 — t_prd_product_sets 0/0 실측)
  archetype: "고정가(세트/대량 2행)"
  min_qty: 20               # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(포토카드)", config_ont: "component type"}
tags: [디지털인쇄, 포토카드, 고정가]
updated: 2026-07-03
---

# product-024-photocard — 포토카드 (PRD_000024)

디지털인쇄 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원
등록 없음 — [[product-type-classification-sot]] 준수). 아트지 300g 낱장에 단면/양면 칼라 인쇄,
코팅(유광/무광)·모서리(직각/둥근) 선택 후가공. 가격은 고정가 공식 `PRF_PHOTOCARD_NORMAL`이
**제작방식(세트/대량제작)** 옵션에 따라 세트가(`COMP_PHOTOCARD_SET`) 또는 대량가
(`COMP_PHOTOCARD_BULK`)로 분기한다(값 계산=`evaluate_price` 권위·D-18 경계).

- 파일 업로드·에디터 둘 다 지원(`file_upload_yn=Y`·`editor_yn=Y`).
- 판형: 종이류라 판형 유효 — 국전계열 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])·`fn_best_plate` 자동선택([[harness-domain-rules-12-260701]]).
- 도수는 인쇄옵션(POPT)이지 색상코드가 아님([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]).
- 추가상품(OPP비접착봉투)은 대상 product 노드 미구축 → GAP으로 정직 선언(아래 [[gap-024-addon-envelope]]).

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_024.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-024-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000024 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 20 | 10000 | 20 | QTY_UNIT.02 | Y | Y |

### 사이즈 치수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000012 | 55x86 | 57x88 | 55x86 |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |

> SIZ_000012(55x86)=포토카드 재단사이즈(신용카드 유사)·SIZ_000499=국전 출력용지(판형).

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand |
|---|---|---|
| PROC_000015 | 무광라미네이팅 | N |
| PROC_000027 | 직각 | N |
| PROC_000014 | 유광라미네이팅 | N |
| PROC_000028 | 둥근 | N |

> 4공정 전부 선택(mand=N). 코팅(유광/무광)·모서리(직각/둥근)는 CPQ 옵션그룹으로도 노출된다(아래).

### CPQ 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max | mand |
|---|---|---|---|---|
| OPT_000017 | 인쇄 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000018 | 종이 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000019 | 코팅 | SEL_TYPE.01 | 0/1 | N |
| OPT_000084 | 제작방식 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000020 | 모서리 | SEL_TYPE.01 | 0/1 | N |

### CPQ 옵션 아이템 → 차원 참조 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPT_000017 | OPV_000070 | 단면 | OPT_REF_DIM.06 | 1 |  |
| OPT_000017 | OPV_000071 | 양면 | OPT_REF_DIM.06 | 2 |  |
| OPT_000018 | OPV_000072 | 아트지 300g | OPT_REF_DIM.03 | MAT_000082 | USAGE.07 |
| OPT_000020 | OPV_000076 | 직각 | OPT_REF_DIM.04 | PROC_000027 |  |
| OPT_000020 | OPV_000077 | 둥근 | OPT_REF_DIM.04 | PROC_000028 |  |
| OPT_000019 | OPV_000074 | 유광 | OPT_REF_DIM.04 | PROC_000014 |  |
| OPT_000019 | OPV_000075 | 무광 | OPT_REF_DIM.04 | PROC_000015 |  |

> `ref_dim_cd`가 옵션값이 가리키는 실물 차원을 정한다: `.06`=인쇄옵션(ref_key1=opt_id·1단면/2양면),
> `.03`=자재(ref_key1=mat_cd·ref_key2=usage_cd), `.04`=공정(ref_key1=proc_cd). 제작방식(OPT_000084·세트/대량)은
> 실물 차원 참조가 없고 가격 차원(opt_grp:OPT_000084)만 구동한다. 모든 참조 타깃이 이 상품(PRD_000024)에
> 실재 → `fn_chk_opt_item_ref` 정합(pack §3.9).

### 추가상품 템플릿 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates @ 2026-07-03 -->
| tmpl_cd | 템플릿명 | base_prd_cd | base 상품명 | base 유형 |
|---|---|---|---|---|
| TMPL-000012 | OPP비접착봉투 60x90 mm 20장 | PRD_000002 | OPP비접착봉투 | PRD_TYPE.03 |
| TMPL-000030 | OPP비접착봉투 60x90 mm 50장 | PRD_000002 | OPP비접착봉투 | PRD_TYPE.03 |

> `has_addon`의 실 배선=product→template(tmpl_cd)→`t_prd_templates.base_prd_cd`(R14·F-7). 대상
> product(PRD_000002 OPP비접착봉투·기성상품 .03) 노드가 아직 KB에 없어 `has_addon` 엣지를
> 걸면 끊긴 링크가 된다 → 아래 GAP으로 정직 선언(지어내지 않음).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-024-photocard` --priced_by--> [[formula/digital-formulas#formula-PRF_PHOTOCARD_NORMAL]]
--has_component--> `COMP_PHOTOCARD_SET`·`COMP_PHOTOCARD_BULK`([[formula/digital-components]]). 두 구성요소의
`use_dims`가 이 상품의 가격이 어떤 축으로 달라지는지 선언한다(값 계산은 엔진).

### 가격 배선 PRF_PHOTOCARD_NORMAL (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_024.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_PHOTOCARD_SET | Y | PRICE_TYPE.02 | 포토카드 완제품가 일반세트 | `["siz_cd", "bdl_qty", "min_qty", "opt_cd", "opt_grp:OPT_000084"]` |
| 2 | COMP_PHOTOCARD_BULK | Y | PRICE_TYPE.02 | 포토카드 완제품가 대량 | `["min_qty", "opt_cd", "opt_grp:OPT_000084"]` |

> 골든 스냅샷 라벨: 위 배선은 live-snapshot 20260702_1119 기준. 세트가=siz_cd·bdl_qty·제작방식(opt) 차원,
> 대량가=min_qty·제작방식 차원. 제작방식 옵션(OPT_000084 세트/대량제작·[[optgroup-OPT_000084]])이 두 구성요소
> 중 어느 것을 적용할지 가르는 분기축이다.

---

## 이 상품 전용 하위 노드

> 아래 SIZ_000012(55x86)는 포토카드 전용 사이즈라 이 파일이 유일 선언한다(공유 파일 미수정 원칙).
> **라미네이팅·모서리 공정(PROC_000014/015/027/028)은 명함·포토카드가 공유하는 축**이라 여기서
> 재선언하지 않는다(중복 노드 생성 금지). 현재 다른 상품 파일(product-032/033)이 ad-hoc 선언 중이며,
> `has_process`·`option_refs` 관계는 그 기존 노드로 해소된다 → **axis/processes.md로 승격 필요**
> (open_questions·index_entries 참조 — 소유 모호·L-3 충돌 위험).

### [size-SIZ_000012] 55x86 (포토카드 전용) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000012
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000012", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000012", note: "포토카드 단일 재단사이즈 55x86(작업 57x88)·신용카드 유사"}

### [qty-024] 포토카드 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_product_bundle_qtys/PRD_000024
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "테이블:t_prd_product_bundle_qtys 키:PRD_000024", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {bdl_unit_typ_cd: "QTY_UNIT.06", min_max_incr_ref: "본문 전사표(min 20·max 10000·incr 20)", note: "묶음수 bdl_qty=20·상품 qty_unit_typ_cd=QTY_UNIT.02와 bundle 단위 QTY_UNIT.06 상이(전사값 그대로 기록)"}

### [optgroup-OPT_000017] 인쇄 (도수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000024
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000024 opt_grp_cd:OPT_000017", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000017", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택"}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}, note: "단면(ref_key1=opt_id 1)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "2"}, note: "양면(ref_key1=opt_id 2)"}

### [optgroup-OPT_000018] 종이 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000024
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000024 opt_grp_cd:OPT_000018", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000018", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택·현재 아트지 300g 단일"}
- rel: {rel: option_refs, target: material-MAT_000082, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000082", ref_key2: "USAGE.07"}, note: "아트지 300g"}

### [optgroup-OPT_000019] 코팅 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000024
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000024 opt_grp_cd:OPT_000019", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000019", opt_grp_nm: "코팅", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "min/max 0/1 선택·코팅없음(OPV_000073)은 del_yn=Y"}
- rel: {rel: option_refs, target: process-PROC_000014, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000014"}, note: "유광→유광라미네이팅"}
- rel: {rel: option_refs, target: process-PROC_000015, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000015"}, note: "무광→무광라미네이팅"}

### [optgroup-OPT_000020] 모서리 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000024
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000024 opt_grp_cd:OPT_000020", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000020", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "min/max 0/1 선택·직각 기본"}
- rel: {rel: option_refs, target: process-PROC_000027, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000027"}, note: "직각"}
- rel: {rel: option_refs, target: process-PROC_000028, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000028"}, note: "둥근"}

### [optgroup-OPT_000084] 제작방식 (세트/대량) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000024
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000024 opt_grp_cd:OPT_000084", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000084", opt_grp_nm: "제작방식", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", options: "세트(OPV_000495 기본)·대량제작(OPV_000496)", note: "실물 차원 참조 없음 — 가격 분기축(opt_grp:OPT_000084)만 구동. COMP_PHOTOCARD_SET vs COMP_PHOTOCARD_BULK 선택([[formula/digital-components#component-COMP_PHOTOCARD_SET]])"}

### [gap-024-addon-envelope] 포토카드 추가상품(봉투) 대상 product 노드 미구축 {unknown}
- type: gap
- anchor: none  # 사유: has_addon 대상 product(PRD_000002)가 아직 KB에 없음 — 끊긴 링크 방지
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons 키:PRD_000024(TMPL-000012·TMPL-000030→base PRD_000002)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "포토카드 추가상품 OPP비접착봉투(TMPL-000012 20장·TMPL-000030 50장→base_prd_cd=PRD_000002·기성상품 .03)의 대상 product 노드가 KB에 없어 has_addon 엣지를 아직 못 건다"
- gap_fill_from: "기성상품(.03) 노드 집필 시 product-002 신설 후 product-024→product-002 has_addon 배선(대표 8상품 로드맵 밖·프로모션 대기)"
- gap_owner: 설계
