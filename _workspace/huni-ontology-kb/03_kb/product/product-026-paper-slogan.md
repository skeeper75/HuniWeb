---
id: product-026-paper-slogan
type: product
anchor: t_prd_products/PRD_000026
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000026", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체·§3.10 가격공식(PRF_DGP_A 원자합산형) — 디지털 시트2 포토카드 구분 그룹", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드(main_cat_yn=Y·라이브 단일 카테고리)"}
  - {rel: has_size, target: size-SIZ_000015, note: "300x100 종이슬로건 전용 재단사이즈"}
  - {rel: has_size, target: size-SIZ_000016, note: "400x145 종이슬로건 전용 재단사이즈"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "종이류(아트지)라 판형 유효·국전 SIZ_000499·fn_best_plate 자동선택"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g·USAGE.07 단일 슬롯"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(앞 CMYK4도·뒤 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(앞뒤 CMYK4도)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: "Y"}, note: "디지털인쇄 base 공정(2026-06-30 mand 추가·인쇄비 0 해소·DEC_baseproc_260701)"}
  - {rel: has_process, target: process-PROC_000014, qualifier: {mand: "N"}, note: "유광라미네이팅(코팅옵션)"}
  - {rel: has_process, target: process-PROC_000015, qualifier: {mand: "N"}, note: "무광라미네이팅(코팅옵션)"}
  - {rel: has_qty_rule, target: qty-026, note: "상품레벨 min 4·incr 4·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_DGP_A, note: "원자합산형A(엽서·상품권·슬로건 공유·라이브 note 명시)"}
  - {rel: has_option_group, target: optgroup-OPT_000026, note: "인쇄(도수) 필수 1/1"}
  - {rel: has_option_group, target: optgroup-OPT_000027, note: "종이(자재) 필수 1/1"}
  - {rel: has_option_group, target: optgroup-OPT_000028, note: "코팅 선택 0/1"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측)
  archetype: "원자합산형(PRF_DGP_A·인쇄비+용지비+후가공비 합산)"
  min_qty: 4                # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"
  editor_yn: "N"            # ★포토카드(024)와 달리 에디터 미지원·파일 업로드만
standards: {schema_org: Product, xjdf: "Product(종이슬로건)", config_ont: "component type"}
tags: [디지털인쇄, 종이슬로건, 원자합산형]
updated: 2026-07-03
---

# product-026-paper-slogan — 종이슬로건 (PRD_000026)

디지털인쇄 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원
등록 없음 — [[product-type-classification-sot]] 준수). 아트지 300g 낱장에 단면/양면 칼라 인쇄,
코팅(유광/무광) 선택 후가공. 가로로 긴 슬로건 판형(300×100·400×145)이 특징이다. 가격은
원자합산형 공식 `PRF_DGP_A`(엽서·상품권·종이슬로건 공유)가 **인쇄비 + 용지비(COMP_PAPER) +
후가공비**를 더해 계산한다(값 계산=`evaluate_price` 권위·D-18 경계).

- 파일 업로드만 지원(`file_upload_yn=Y`·`editor_yn=N`) — 포토카드([[product-024-photocard]])와 달리 에디터 없음.
- 판형: 종이류라 판형 유효 — 국전계열 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])·`fn_best_plate` 자동선택([[harness-domain-rules-12-260701]]). 판걸이수(UP)는 `fn_calc_pansu`/`t_siz_pansu` DB함수 파생(전사 note의 판걸이 4.0/2.0은 사이즈 속성).
- 도수는 인쇄옵션(POPT)이지 색상코드가 아님([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]). 앞/뒤 도수(CMYK4도·인쇄안함)는 인쇄옵션의 속성.
- **디지털 base 공정 PROC_000004**(mand=Y)는 2026-06-30 인쇄비 0 해소 COMMIT으로 추가됨([[rule/decisions#DEC_baseproc_260701]]·pack §4-A). 종이슬로건도 그 18건 대상.
- 추가상품·제약규칙·묶음수(bundle_qtys)는 라이브 0행(전사 실측) — 없는 것을 지어내지 않는다.
- 끊긴 경로: 코팅 면수(coat_side_cnt) 옵션 파라미터 미보존 → 아래 [[gap-026-coat-side]]로 정직 선언.

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_026.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-026-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000026 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 4 | 10000 | 4 | QTY_UNIT.02 | Y | N |

### 사이즈 치수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | note |
|---|---|---|---|---|
| SIZ_000015 | 300x100 | 302x102 | 300x100 | 판걸이=4.0 / 전지=316x467 / 적용=종이슬로건 |
| SIZ_000016 | 400x145 | 402x147 | 400x145 | 판걸이=2.0 / 전지=316x467 / 적용=종이슬로건 |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |  |

> SIZ_000015/016 = 종이슬로건 전용 재단사이즈(가로로 긴 배너형)·SIZ_000499 = 국전 출력용지(판형).

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |
| POPT_000002 | 양면 | CMYK 4도 | CMYK 4도 |

> 도수는 인쇄옵션(print_opt_cd) — 앞/뒤 색상수(clr)는 인쇄옵션의 속성이지 별도 도수축이 아니다(pack §3.3·T-4 함정).

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand |
|---|---|---|
| PROC_000015 | 무광라미네이팅 | N |
| PROC_000014 | 유광라미네이팅 | N |
| PROC_000004 | 디지털인쇄 | Y |

> PROC_000004(디지털인쇄 base)=필수 공정(인쇄비 원천). 코팅(유광/무광)은 선택(mand=N)·CPQ 코팅 옵션그룹으로도 노출.

### 판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | dflt |
|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 | Y |

### CPQ 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min/max | mand |
|---|---|---|---|---|
| OPT_000026 | 인쇄 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000027 | 종이 | SEL_TYPE.01 | 1/1 | Y |
| OPT_000028 | 코팅 | SEL_TYPE.01 | 0/1 | N |

### CPQ 옵션 아이템 → 차원 참조 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items @ 2026-07-03 -->
| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPT_000026 | OPV_000084 | 단면 | OPT_REF_DIM.06 | 1 |  |
| OPT_000026 | OPV_000085 | 양면 | OPT_REF_DIM.06 | 2 |  |
| OPT_000027 | OPV_000086 | 아트지 300g | OPT_REF_DIM.03 | MAT_000082 | USAGE.07 |
| OPT_000028 | OPV_000088 | 유광 | OPT_REF_DIM.04 | PROC_000014 |  |
| OPT_000028 | OPV_000089 | 무광 | OPT_REF_DIM.04 | PROC_000015 |  |

> `ref_dim_cd`: `.06`=인쇄옵션(ref_key1=opt_id·1단면/2양면), `.03`=자재(ref_key1=mat_cd·ref_key2=usage_cd),
> `.04`=공정(ref_key1=proc_cd). 코팅없음(OPV_000087)은 del_yn=Y 센티넬(min_sel_cnt=0으로 대체)이라 옵션참조 없음.
> 모든 참조 타깃이 이 상품(PRD_000026)에 실재 → `fn_chk_opt_item_ref` 정합(pack §3.9·L-18).

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |

> 수량은 상품레벨 규칙(min 4·incr 4·QTY_UNIT.02)만 — 별도 묶음수 행 없음. 추가상품·제약규칙 미등록(정직 표기).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-026-paper-slogan` --priced_by--> [[formula/digital-formulas#formula-PRF_DGP_A]]
--has_component--> `COMP_PRINT_DIGITAL_S1`·`COMP_PAPER`·후가공 구성요소([[formula/digital-components]]).
PRF_DGP_A는 엽서(016)·상품권(041)과 공유하는 원자합산형 공식이라 구성요소 노드는 기존 축을
재사용한다(중복 mint 없음). 각 구성요소의 `use_dims`가 이 상품 가격이 어떤 축으로 달라지는지
선언한다(값 계산은 엔진).

### 가격 배선 PRF_DGP_A (전사·골든 스냅샷 20260702_1119)

<!-- transcribed-by: _meta/scripts/transcribe_product_026.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 0 | COMP_PRINT_DIGITAL_S1 | Y | PRICE_TYPE.01 | 디지털인쇄비 | `["proc_cd", "plt_siz_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000001"]` |
| 1 | COMP_PRINT_SPOT_WHITE_S1 | Y | PRICE_TYPE.01 | 별색인쇄비 | `["plt_siz_cd", "proc_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000007"]` |
| 2 | COMP_PAPER | Y | PRICE_TYPE.01 | 용지비(종이별 절가) | `["plt_siz_cd", "mat_cd"]` |
| 3 | COMP_PP_CORNER_RIGHT |  | PRICE_TYPE.03 | 귀돌이비 | `["proc_cd", "min_qty", "proc_grp:PROC_000026"]` |
| 4 | COMP_PP_CREASE_1L | Y | PRICE_TYPE.01 | 오시비 | `["proc_cd", "min_qty", "proc_grp:PROC_000029"]` |
| 5 | COMP_PP_PERF_1L | Y | PRICE_TYPE.01 | 미싱비 | `["proc_cd", "min_qty", "proc_grp:PROC_000030"]` |
| 6 | COMP_PP_VARTEXT_1EA | Y | PRICE_TYPE.03 | 가변텍스트 | `["proc_cd", "min_qty", "proc_grp:PROC_000085"]` |
| 7 | COMP_PP_VARIMG_1EA | Y | PRICE_TYPE.03 | 가변이미지 | `["proc_cd", "min_qty", "proc_grp:PROC_000085"]` |
|  | COMP_COAT_GLOSSY |  | PRICE_TYPE.01 | 유광코팅비 | `["proc_cd", "plt_siz_cd", "coat_side_cnt", "min_qty", "proc_grp:PROC_000013"]` |
|  | COMP_COAT_MATTE |  | PRICE_TYPE.01 | 무광코팅비 | `["proc_cd", "plt_siz_cd", "coat_side_cnt", "min_qty", "proc_grp:PROC_000013"]` |

> 골든 라벨: 위 배선은 live-snapshot 20260702_1119 기준. 종이슬로건이 실 사용하는 항목은
> 디지털인쇄비·용지비(COMP_PAPER)·코팅비(선택 시). 별색/귀돌이/오시/미싱/가변은 PRF_DGP_A 공유
> 슬롯이며 이 상품 공정(PROC_000004/014/015)에 없으면 해당 항목은 0(차원 미매칭·엔진 판정).
> 값 절대치는 KB 밖(evaluate_price)·D-18 경계.

---

## 이 상품 전용 하위 노드

> SIZ_000015(300x100)·SIZ_000016(400x145)는 종이슬로건 전용 사이즈(t_siz_sizes tags=["종이슬로건"])라
> 이 파일이 유일 선언한다(공유 axis 파일 미수정 원칙·포토카드 SIZ_000012 선례). 자재·공정·인쇄옵션·판형·
> 공식은 공유 축([[axis/materials]]·[[axis/processes]]·[[axis/print-options]]·[[axis/plate-sizes]]·
> [[formula/digital-formulas]])의 기존 노드로 해소된다(중복 노드 생성 금지).

### [size-SIZ_000015] 300x100 (종이슬로건 전용) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000015
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000015", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000015", note: "종이슬로건 재단 300x100(작업 302x102)·판걸이 4.0(전사 note)·가로 배너형"}

### [size-SIZ_000016] 400x145 (종이슬로건 전용) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000016
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000016", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000016", note: "종이슬로건 재단 400x145(작업 402x147)·판걸이 2.0(전사 note)·가로 배너형"}

### [qty-026] 종이슬로건 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000026
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000026(min_qty/qty_incr/qty_unit_typ_cd)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min 4·max 10000·incr 4)", bdl_unit_typ_cd: "QTY_UNIT.02", note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙(pack §3.4)"}

### [optgroup-OPT_000026] 인쇄 (도수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000026
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000026 opt_grp_cd:OPT_000026", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000026", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택·단면/양면"}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}, note: "단면(ref_key1=opt_id 1)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "2"}, note: "양면(ref_key1=opt_id 2)"}

### [optgroup-OPT_000027] 종이 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000026
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000026 opt_grp_cd:OPT_000027", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000027", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "min/max 1/1 필수 단일선택·현재 아트지 300g 단일"}
- rel: {rel: option_refs, target: material-MAT_000082, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000082", ref_key2: "USAGE.07"}, note: "아트지 300g"}

### [optgroup-OPT_000028] 코팅 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000026
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000026 opt_grp_cd:OPT_000028", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000028", opt_grp_nm: "코팅", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "min/max 0/1 선택·코팅없음(OPV_000087)은 del_yn=Y 센티넬"}
- rel: {rel: option_refs, target: process-PROC_000014, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000014"}, note: "유광→유광라미네이팅"}
- rel: {rel: option_refs, target: process-PROC_000015, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000015"}, note: "무광→무광라미네이팅"}

### [gap-026-coat-side] 코팅 면수(coat_side_cnt) 옵션 파라미터 미보존 {unknown}
- type: gap
- anchor: none  # 사유: 코팅 면수 축이 t_prd_product_option_* 어디에도 없음 — 라이브에 부재하는 것을 앵커 못 함
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000026 opt_grp_cd:OPT_000028(note: '단/양면 면구분=GAP-PARAM')", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "코팅 구성요소 COMP_COAT_GLOSSY/MATTE의 use_dims에 `coat_side_cnt`(코팅 면수)가 있으나, 코팅 옵션그룹(OPT_000028)은 유광/무광만 고르고 면수(단면/양면 코팅)를 옵션 파라미터로 잡지 않는다 → 견적 시 coat_side_cnt 차원 환원에 별도 detail 필요(옵션만으로 자동 결정 불가)"
- gap_fill_from: "코팅명함 032 코팅면수 GAP(GAP_032_coat_side)와 동형 — §31 제약/옵션 파라미터 거버넌스로 면수 옵션 신설 또는 위젯 detail 전달 규약 확정(실무진/개발팀). live `t_prd_product_options` 면수 파라미터 등록 여부 재측정"
- gap_owner: 설계
