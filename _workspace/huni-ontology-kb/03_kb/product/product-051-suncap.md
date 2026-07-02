---
id: product-051-suncap
type: product
anchor: t_prd_products/PRD_000051
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000051", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§1(정답소스)·§3.6 공정(PROC_000004 base)·§3.8 판형(fn_best_plate)·§3.11 완칼 .03 교정·§4-B — 디지털 시트2 인쇄홍보물", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  - {rel: in_category, target: category-CAT_000181, note: "여행/아웃도어(main_cat_yn=Y 주 카테고리·라이브 실측)"}
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(main_cat_yn=N 부 카테고리)"}
  - {rel: has_size, target: size-SIZ_000195, note: "313x400 썬캡 작업사이즈(t_prd_product_sizes 단일 행)"}
  - {rel: has_plate_size, target: plate-051-SIZ_000535, note: "3절 전지 판형(330x540)·output_paper_typ_cd 공백(타 디지털=OUTPUT_PAPER_TYPE.01과 상이)·fn_best_plate 자동선택·판수1(t_siz_pansu lookup·DEC_pansu_260701)"}
  - {rel: uses_material, target: material-MAT_000149, note: "아이보리(MAT_TYPE.01)·USAGE.07 단일 슬롯·dflt Y"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(앞 CMYK4도·뒤 인쇄안함)·양면 미보유"}
  - {rel: has_process, target: process-PROC_000004, qualifier: {mand: "Y"}, note: "디지털인쇄 base 공정(2026-07-01 이관 COMMIT으로 인쇄비 0 해소·DEC_baseproc_260701·pack §4-A)"}
  - {rel: has_qty_rule, target: qty-051, note: "상품레벨 min 10·max 1000·incr 10·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_DGP_F, note: "원자합산형F 썬캡(디지털인쇄비+용지비+완칼 커팅비)·미출시 구조 참조용"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측)
  archetype: "원자합산형(PRF_DGP_F·인쇄비+용지비+완칼커팅비 합산)"
  min_qty: 10               # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "N"       # ★파일 업로드·에디터 둘 다 미지원(미출시 상태와 정합)
  editor_yn: "N"
  use_yn: "N"               # ★미출시 — 라이브 현재값(공식명 자체가 "썬캡(미출시)")·honest status
standards: {schema_org: Product, xjdf: "Product(썬캡 인쇄홍보물)", config_ont: "component type"}
tags: [디지털인쇄, 인쇄홍보물, 썬캡, 원자합산형, 미출시]
updated: 2026-07-03
---

# product-051-suncap — 썬캡 (PRD_000051)

디지털인쇄 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원 등록
없음 — [[product-type-classification-sot]] 준수). 아이보리 종이를 썬캡(햇빛가리개 모자챙)
모양으로 완칼(die-cut) 재단하는 인쇄홍보물. 주 카테고리는 **여행/아웃도어**(CAT_000181·
main_cat_yn=Y), 부 카테고리가 **인쇄홍보물**(CAT_000003). 가격은 원자합산형 공식 `PRF_DGP_F`가
**디지털인쇄비 + 용지비(COMP_PAPER) + 완칼 커팅비(COMP_CUT_FULL_DIECUT)** 를 더해 계산한다
(값 계산=`evaluate_price` 권위·[[rule/rules#RULE_price_value_boundary]]).

- **★미출시(use_yn=N):** 라이브 현재값이 `use_yn=N`이고 공식 마스터명도 "디지털인쇄 원자합산형F
  썬캡(미출시)"다. 가격 사슬은 2026-07-01 §26 작업(3절 판형 SIZ_000535 등록·PROC_000004 필수공정·
  단가행 복사)으로 **구조적으로 연결**됐으나, 상품 자체는 출시 상태가 아니다 — 지어내지 않고
  현재값을 그대로 기록한다(pack §5·[[rule/decisions#DEC_pansu_260701]]).
- 파일 업로드·에디터 둘 다 미지원(`file_upload_yn=N`·`editor_yn=N`) — 완칼 모양 고정 상품(자유 편집 없음).
- **판형(has_plate_size):** 종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택
  (`fn_best_plate` 자동선택·[[harness-domain-rules-12-260701]]). 단 썬캡은 국전([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])이
  **아니라** 전용 **3절 판형 SIZ_000535(330×540)** 를 쓰며, `output_paper_typ_cd`가 **공백**이다
  (타 디지털 상품은 OUTPUT_PAPER_TYPE.01). 판걸이수(UP)는 사이즈 컬럼이 아니라 `fn_calc_pansu`/
  `t_siz_pansu` DB함수 파생([[rule/rules#RULE_pansu_db_function]]·권위 판걸이수시트 330×540 판수=1).
- 도수는 인쇄옵션(POPT_000001 단면)이지 색상코드가 아님([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]). 썬캡은 단면만.
- **디지털 base 공정 PROC_000004**(mand=Y)는 §26 이관 COMMIT으로 인쇄비 0 해소된 18건 계보와
  동형([[rule/decisions#DEC_baseproc_260701]]·pack §4-A).
- **완칼 커팅(COMP_CUT_FULL_DIECUT)** 은 썬캡 모양 die-cut. 단가형 `.03` 고정 교정(단가형×판수
  이중적용 과대청구 해소·[[rule/decisions#DEC_diecut_260701]]·pack §4-B) 계보에 속한다.
- CPQ 옵션그룹·추가상품·제약규칙·묶음수(bundle_qtys)는 라이브 0행(전사 실측) — 없는 것을 지어내지 않는다.
- 끊긴 경로: 완칼 커팅 절대값 골든 미검증 + 미출시라 예전사이트 대조 골든 부재 → [[gap-051-golden]]로 정직 선언.

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_051.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-051-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000051 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 10 | 1000 | 10 | QTY_UNIT.02 | N | N | N |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | main_cat_yn |
|---|---|---|
| CAT_000003 | 인쇄홍보물 | N |
| CAT_000181 | 여행/아웃도어 | Y |

> 주 카테고리(main_cat_yn=Y)=여행/아웃도어(CAT_000181)·부=인쇄홍보물(CAT_000003). CAT_000181은
> 공유 축(axis/categories.md) 미등재라 이 파일이 임시 선언(승격 대기 → needed_shared).

### 사이즈 치수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | tags | note |
|---|---|---|---|---|---|
| SIZ_000195 | 313x400 | 313x400 | ?x? |  |  |
| SIZ_000535 | 330x540 | 330x540 | 320x530 | ["3절", "판형"] | 3절 전지 - 썬캡 판형(권위 판걸이수시트 330x540 판수1) 260701 |

> SIZ_000195(313×400)=썬캡 작업사이즈(`t_prd_product_sizes` 단일·재단 컬럼 공백). SIZ_000535
> (330×540)=3절 전지 출력용지(판형·tags=["3절","판형"]). 판걸이수(판수1)는 파생·`fn_calc_pansu`.

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000149 | 아이보리 | MAT_TYPE.01 | USAGE.07 | Y |

> 낱장 단일 본문 자재 = parent + usage_cd 단일 슬롯(USAGE.07 공통·pack §3.5). MAT_000149는 공유 축
> (axis/materials.md) 미등재라 이 파일이 임시 선언(단일 소비자·승격 대기).

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

> 도수는 인쇄옵션(print_opt_cd) — 앞/뒤 색상수(clr)는 인쇄옵션의 속성이지 별도 도수축이 아니다(pack §3.3·T-4 함정). 썬캡=단면만.

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand |
|---|---|---|
| PROC_000004 | 디지털인쇄 | Y |

> PROC_000004(디지털인쇄 base)=필수 공정(인쇄비 원천). 코팅·후가공 없음(썬캡=완칼 모양 재단만·완칼은 커팅 구성요소로 가격 반영).

### 판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | note |
|---|---|---|---|---|
| SIZ_000535 | (공백) | PDF | Y | 3절 330x540 연결 260701 |

> ★타 디지털 상품의 판형은 `output_paper_typ_cd=OUTPUT_PAPER_TYPE.01`(국전)인데, 썬캡은 전용 3절
> 판형(SIZ_000535)이고 `output_paper_typ_cd`가 **공백**이다. 그래도 `dflt_plt_yn=Y`라 fn_best_plate가
> 자동선택하고 판수1(t_siz_pansu lookup)로 가격 사슬은 성립한다(§26 견적 성립 확인). 국전 판형
> [[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]]과 상이 — 이 파일이 전용 plate 노드로 선언.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints/option_groups @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |

> 수량은 상품레벨 규칙(min 10·incr 10·QTY_UNIT.02)만 — 별도 묶음수 행 없음. CPQ 옵션그룹·추가상품·
> 제약규칙 미등록(정직 표기). 썬캡은 손님 선택 축이 없는 단순 완제품(단면·아이보리 고정).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-051-suncap` --priced_by--> [[formula/digital-formulas#formula-PRF_DGP_F]]
--has_component--> `COMP_PRINT_DIGITAL_S1`·`COMP_PAPER`·`COMP_CUT_FULL_DIECUT`([[formula/digital-components]]).
PRF_DGP_F(원자합산형F)는 라이브에 이미 배선된 공유 공식이라 구성요소 노드는 기존 축을 재사용한다
(중복 mint 없음). 각 구성요소의 `use_dims`가 이 상품 가격이 어떤 축으로 달라지는지 선언한다(값 계산은 엔진).

### 가격 배선 PRF_DGP_F (전사·골든 스냅샷 20260702_1119)

<!-- transcribed-by: _meta/scripts/transcribe_product_051.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 0 | COMP_PRINT_DIGITAL_S1 | Y | PRICE_TYPE.01 | 디지털인쇄비 | `["proc_cd", "plt_siz_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000001"]` |
| 1 | COMP_PAPER | Y | PRICE_TYPE.01 | 용지비(종이별 절가) | `["plt_siz_cd", "mat_cd"]` |
| 2 | COMP_CUT_FULL_DIECUT | Y | PRICE_TYPE.03 | 커팅 완제품가 완칼(모양엽서·라벨택) | `["plt_siz_cd", "min_qty"]` |

> 골든 라벨: 위 배선은 live-snapshot 20260702_1119 기준. 썬캡이 실 사용하는 항목은 디지털인쇄비
> (PROC_000004 매칭)·용지비(SIZ_000535 판형×MAT_000149 아이보리)·완칼 커팅비(썬캡 모양 die-cut·.03 고정)이다.
> COMP_CUT_FULL_DIECUT는 라벨택(046)·모양엽서(023)와 공유하는 완칼 구성요소(pack §4-B·[[rule/decisions#DEC_diecut_260701]]).
> 값 절대치는 KB 밖(evaluate_price)·D-18 경계. §26이 견적 0→성립 확인했으나 절대값 골든은 미검증([[gap-051-golden]]).

---

## 이 상품 전용 하위 노드

> SIZ_000195(313×400)·MAT_000149(아이보리)·plate SIZ_000535(3절 판형)·CAT_000181(여행/아웃도어)는
> 현재 썬캡이 유일 소비자라 이 파일이 선언한다(공유 axis 파일 미수정 원칙·026 종이슬로건 선례).
> 공정(PROC_000004)·인쇄옵션(POPT_000001)·공식(PRF_DGP_F)·구성요소는 공유 축([[axis/processes]]·
> [[axis/print-options]]·[[formula/digital-formulas]]·[[formula/digital-components]])의 기존 노드로 해소된다(중복 노드 생성 금지).
> ★CAT_000181은 카테고리 축이라 다상품 성격 — 통합 단계 axis/categories.md 승격 후보(needed_shared).

### [category-CAT_000181] 여행/아웃도어 (승격 대기) {verified}
- type: category
- anchor: t_cat_categories/CAT_000181
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000181", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "여행/아웃도어", note: "썬캡 주 카테고리(main_cat_yn=Y). 공유 axis/categories.md 미등재 — 단일 소비자라 임시 거처. 2번째 소비 상품 집필 시 이 축으로 승격(canonical id 그대로). owner=architect(needed_shared)"}

### [size-SIZ_000195] 313x400 (썬캡 작업사이즈) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000195
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000195", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000195", note: "썬캡 작업사이즈 313x400(재단 컬럼 공백)·t_prd_product_sizes 단일 행. 단일 소비자·승격 대기"}

### [plate-051-SIZ_000535] 3절 전지 판형 330x540 (썬캡 전용) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000051
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000051,SIZ_000535) output_paper_typ_cd=공백·dflt_plt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000535(330x540·tags 3절/판형)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.8 판형·§4-C fn_calc_pansu·t_siz_pansu(판수1)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
- props: {siz_cd: "SIZ_000535", output_paper_typ_cd: "(공백)", note: "★타 디지털 판형=OUTPUT_PAPER_TYPE.01(국전)과 달리 전용 3절 판형·output_paper_typ_cd 공백. fn_best_plate 자동선택(dflt Y)·판수1(t_siz_pansu lookup·DEC_pansu_260701). 종이류라 판형 유효(RULE_plate_paper_only). §26 3절 이관 COMMIT(견적0→성립·260701)"}

### [material-MAT_000149] 아이보리 (썬캡 본문 자재) {verified}
- type: material
- anchor: t_mat_materials/MAT_000149
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000149", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000051,MAT_000149) usage_cd=USAGE.07 dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", usage_cd: "USAGE.07", note: "썬캡 본문 자재 아이보리·parent+usage_cd 단일 슬롯(pack §3.5). 단일 소비자·승격 대기(axis/materials.md)"}

### [qty-051] 썬캡 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000051
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000051(min_qty/max_qty/qty_incr/qty_unit_typ_cd)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min 10·max 1000·incr 10)", bdl_unit_typ_cd: "QTY_UNIT.02", note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙(pack §3.4·DEC_qty_audit_260702)"}

### [gap-051-golden] 썬캡 완칼 골든 미검증 + 미출시 대조 부재 {unknown}
- type: gap
- anchor: none  # 사유: 미출시(use_yn=N)라 예전사이트 견적 골든이 존재하지 않음 — 대조할 정답 원천 자체가 없음
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "frm_cd:PRF_DGP_F(frm_nm 썬캡 미출시)·live use_yn(PRD_000051)=N", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "썬캡 최종 견적 절대값(골든): §26이 3절 판형·PROC_000004·완칼 .03로 견적 0→성립을 확인했으나, ① COMP_CUT_FULL_DIECUT 완칼 절대값이 라벨택(046)·모양엽서(023)와 함께 pcode 미상으로 미검증([[gap-046-diecut-golden]] 동형) ② 미출시(use_yn=N)라 예전사이트 대조 골든이 없음"
- gap_fill_from: "① 완칼 pcode 매핑 후 예전사이트 대조(§4-B·개발팀) ② 썬캡 출시 결정 시 예전사이트/실무진 골든 확보(staff). 그 전까지 절대값 단정 금지"
- gap_owner: dev
- rel: {rel: derived_from, target: size-SIZ_000195, note: "완칼 커팅·판걸이수는 사이즈/판형의 파생"}
