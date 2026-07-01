# widget-db-entities.md — 위젯에 필요한 DB 엔티티·속성 전수

> 파이프라인 ③' 컨버전 선행. **권위 스키마 = `docs/huni/table-spec_260619.html`**(36테이블/374컬럼·2026-06-17).
> 실측 교차 = `_workspace/_foundation/live-snapshot/latest/`(2026-07-01). 가격 권위 = `pricing.py:evaluate_price`(:394).
> 분류 기준 = "고객이 상품 선택 → 옵션 확인 → 주문 조건 충족"에 위젯이 실제 소비/운반하는 엔티티·속성인가.
> 위젯은 정규화 계약(`04_build/src/contract/*`)에만 의존 — 아래 매핑은 **어댑터(createHuniAdapter)가 흡수**할 규칙이다.

## 0. 36테이블 분류 요약

| 분류 | 테이블 수 | 테이블 |
|------|-----------|--------|
| **위젯 직접 필요** (옵션 차원·캐스케이드·가격경로 직접 소비) | 17 | t_prd_products · t_prd_product_sizes · t_prd_product_materials · t_prd_product_print_options · t_prd_product_processes · t_prd_product_plate_sizes · t_prd_product_bundle_qtys · t_prd_product_page_rules · t_prd_product_option_groups · t_prd_product_options · t_prd_product_option_items · t_prd_product_constraints · t_prd_product_addons · t_siz_sizes · t_clr_color_counts · t_proc_processes · t_mat_materials |
| **부분 필요** (어댑터가 라벨/차원 환원·가격경로 간접 참조) | 8 | t_prt_print_options · t_cod_base_codes · t_prd_product_categories · t_prd_product_sets · t_prd_templates · t_prd_template_selections · t_cat_categories · t_prd_product_price_formulas |
| **위젯 미사용** (서버 가격엔진 내부·회계·MES — evaluate_price 불투명 결과만 받음) | 11 | t_prc_price_formulas · t_prc_price_components · t_prc_formula_components · t_prc_component_prices · t_prd_product_prices · t_prd_template_prices · t_dsc_discount_tables · t_dsc_discount_details · t_dsc_grade_discount_rates · t_prd_product_discount_tables · t_cus_customers |

요약: **직접 17 / 부분 8 / 미사용 11.** 가격 7종 + 할인 4종 = 11테이블은 전부 서버 권위(위젯은 `final_price`/breakdown 불투명 결과만). t_prd_products.MES_ITEM_CD는 컬럼 단위로 미사용.

---

## 1. 위젯 직접 필요 (17) — 컬럼별 계약 사상

### t_prd_products (상품정보) — `NormalizedProduct` 루트
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `prd_cd` | `NormalizedProduct.code` / `NormalizedPriceRequest.productCode` | 불투명 echo |
| `prd_nm` | `.name` | 직접 |
| `prd_typ_cd` (PRD_TYPE 완/반/기성/디자인/추가) | (어댑터 분기 권위) `itemGroup` 휴리스틱 | 완제품=단일 / 셋트는 `t_prd_product_sets` 부모 등록 여부로 판정 |
| `semi_role_cd` (내지/표지/면지/간지/투명커버) | `sides[]` (셋트 구성원 역할) | 책자/셋트=`[default,inner]` 도출 근거 |
| `nonspec_yn` + `nonspec_{width,height}_{min,max,incr}` | `OptionGroup(componentType=area-input \| dimension-matrix-input)` + `BaseRule.{minCutW,minCutH,maxCutW,maxCutH,nonStandardAllowed}` | 비규격=어댑터가 area 그룹 생성 |
| `file_upload_yn` | `cta.pdfUpload` · `editors.pdf` · `ProductSide.uploadType='pdf'` | `='Y'` |
| `editor_yn` | `cta.designEditor` · `editors.koi`(Edicus) · `ProductSide.uploadType='editor'` | `='Y'` (※partner 코드 없음 → 갭) |
| `min_qty`/`max_qty`/`qty_incr`/`dflt_qty` | `QuantityRule.{min,increment(=first),step,default}` · `InputSpec`(counter-input) | 직접 |
| `qty_unit_typ_cd` (EA/매/권/세트/팩/장) | `NormalizedProduct.unit` | t_cod_base_codes에서 cod_nm 환원 |
| `use_yn`/`del_yn` | (필터) | `use_yn='Y' AND del_yn!='Y'` 만 노출 |

### t_prd_product_sizes ⋈ t_siz_sizes (상품별사이즈 + 사이즈정보) — 규격 OptionGroup + SizeRule
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `t_prd_product_sizes.siz_cd` | `OptionValue.id` (규격 그룹) · `SizeRule.valueId` | 불투명 |
| `dflt_yn` | 기본 선택값 | `='Y'` |
| `disp_seq` | 렌더 순서 | 직접 |
| `t_siz_sizes.siz_nm` | `OptionValue.label` | 직접 |
| `t_siz_sizes.{cut_width,cut_height,work_width,work_height}` | `SizeRule.{cutW,cutH,workW,workH}` · `PriceDimension` | 직접 1:1 (캐스케이드 ④) |
| `t_siz_sizes.{margin_top,margin_bot,margin_lft,margin_rgt}` | `BaseRule.cutMargin` | 어댑터 도출 (캐스케이드 ⑥) |
| `t_siz_sizes.tags` (jsonb) | (선택) 규격 그룹핑/배지 후보 | 어댑터 해석 |
| componentType 판정 | `option-button`(값 ≤ N) / `select-box`(값 多) | 값 개수 |

### t_prd_product_materials ⋈ t_mat_materials (상품별자재 + 자재정보) — 용지 OptionGroup
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `t_prd_product_materials.mat_cd` | `OptionValue.id` · `NormalizedPriceRequest.materials[side]` | 불투명 |
| `usage_cd` (내지/표지/면지/간지/투명커버/표지타입/공통) | `OptionGroup.side` 분기 (USAGE.07=공통→default) | side 매핑 |
| `dflt_yn`/`disp_seq` | 기본값·순서 | 직접 |
| `t_mat_materials.mat_nm` | `OptionValue.label` | 직접 |
| `mat_typ_cd` (MAT_TYPE 디지털인쇄용지/아크릴/…) | (어댑터 componentType 판정 보조) | 종이류/이미지칩 분기 |
| `sel_typ_cd` (단일/다중) · `max_sel_cnt` | `OptionGroup.multiple` · acc-panel max | 다중=multiple |
| componentType 판정 | 값多=`select-box`, 이미지有=`image-chip` | (※imageUrl 컬럼 없음 → 갭) |
| ❌ **colorHex / imageUrl / badge / add_color_yn** | `OptionValue.{colorHex,imageUrl,badge,addColorCapable}` | **컬럼 부재 = 추가 스키마 (added-schema)** |

### t_prd_product_print_options ⋈ t_prt_print_options ⋈ t_clr_color_counts (도수 OptionGroup)
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `t_prd_product_print_options.print_opt_cd` | `OptionValue.id` · `NormalizedPriceRequest.print_opt_cd` echo | 불투명 |
| `print_side` (단면/양면) | `OptionValue.label` 보조 | 직접 |
| `front_colrcnt_cd`/`back_colrcnt_cd` → `t_clr_color_counts.chnl_cnt` | `OptionValue.priceColorCount` · `colorCounts[side]` | chnl_cnt 평면화 (캐스케이드 ③) |
| `dflt_yn`/`disp_seq` | 기본·순서 | 직접 |
| componentType | `option-button` | 고정 |

### t_prd_product_processes ⋈ t_proc_processes (후가공 OptionGroup)
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `proc_cd` | `OptionValue.id` · `selectedFinishes[].valueId` · 가격요청 `proc_cd`/procs[] | 불투명 |
| `mand_proc_yn` | `OptionGroup.required`(필수공정 자동선택) | `='Y'` |
| `disp_seq` (음수=숨김 후보, 예 PROC_000004 disp_seq=-1) | `OptionGroup.visible` 후보 | **visible 전용컬럼 부재 → 갭/관례** |
| `t_proc_processes.proc_nm` | `OptionValue.label` | 직접 |
| `t_proc_processes.prcs_dtl_opt` (jsonb `{inputs:[{key,type,min,max,unit,price_dim}]}`) | `InputSpec`(finish 내부 입력) · `SelectedFinish.attb` | 어댑터 파싱 (오시 줄수·코팅 앞뒤·박 크기 등) |
| `upr_proc_cd` | 공정 그룹(택일) | excl 그룹 도출 보조 |
| componentType | `finish-button` (색상有→`color-chip`) | prcs_dtl_opt color有 시 |

### t_prd_product_plate_sizes ⋈ t_siz_sizes (판형사이즈)
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `siz_cd` | 가격요청 `plt_siz_cd` (어댑터 자동, 위젯 비노출) | 불투명. **종이류만 유효**(§29 [HARD]) |
| `dflt_plt_yn` | 기본 판형 | `='Y'` |
| `output_paper_typ_cd` (국전/46/기타) | (가격엔진 내부) | 위젯 미노출 |
| componentType | 대개 **고객 비선택**(판형은 evaluate_price 내부 자동매칭) | 파일럿 실측: prod_dims에 plate 미노출 |

### t_prd_product_bundle_qtys (묶음수) · t_prd_product_page_rules (페이지룰)
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `bundle_qtys.bdl_qty` + `bdl_unit_typ_cd` | `NormalizedProduct.unit` 보조 · 수량 스텝 | 묶음 단위 도출 |
| `page_rules.{page_min,page_max,page_incr}` | `QuantityRule.{pageMin,pageMax,pageStep}` · `InputSpec`(page-counter-input) | 책자 내지 (캐스케이드 ②) |

### t_prd_product_option_groups / options / option_items (CPQ 컨피규레이터) — 핵심
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `option_groups.opt_grp_cd` | `OptionGroup.id` | 불투명 |
| `opt_grp_nm` / `usr_def_nm` | `OptionGroup.label` (usr_def 우선) | 직접 |
| `sel_typ_cd` (단일/다중) | `OptionGroup.multiple` (다중=true) | SEL_TYPE.02=다중 |
| `mand_yn` | `OptionGroup.required` | `='Y'` |
| `min_sel_cnt`/`max_sel_cnt` | acc-panel/멀티 선택 한도 | 직접 |
| `disp_seq` | 렌더 순서 | 직접 |
| `options.opt_cd` | `OptionValue.id` | 불투명 |
| `opt_nm`/`usr_def_nm` | `OptionValue.label` | 직접 |
| `dflt_yn` | 기본 선택 | `='Y'` |
| `options.tags` (jsonb) | `OptionValue.badge` 후보 | **badge 표준값 부재 → 갭** |
| `option_items.ref_dim_cd` (OPT_REF_DIM 사이즈/판형/자재/공정/묶음수/도수/셋트) | **차원 환원 권위**(polymorphic) | 어댑터가 선택→가격요청 차원키 환원 |
| `option_items.ref_key1`/`ref_key2`/`qty` | 환원 대상 코드(예 mat_cd, usage_cd) | round-trip echo |
| componentType | `sel_typ`+값 특성 (단일=option-button/select-box, 다중=acc-panel/finish) | §3.2 |

### t_prd_product_constraints (제약규칙)
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `rule_cd`/`rule_nm` | `DisableRule`/`VisibilityRule` 식별 | 불투명 |
| `rule_typ_cd` (금지/필수동반) | 금지→`disableRules`, 필수동반→required 게이트 | RULE_TYPE 분기 |
| `logic` (JSONLogic) | `disableRules[]`/`visibilityRules[]` 도출 | 어댑터가 룰 파싱 (캐스케이드 ①) |
| `err_msg` | (선택) 사용자 메시지 | 직접 |
| `disp_seq`/`use_yn` | 순서·활성 | 직접 |

### t_prd_product_addons (추가상품 연결)
| 컬럼 | 계약 필드 | 변환 |
|------|-----------|------|
| `tmpl_cd` → t_prd_templates | addon 그룹(W-ADDON 클래스) | 템플릿 경로 |
| `disp_seq` | 순서 | 직접 |

---

## 2. 부분 필요 (8)

| 테이블 | 위젯 사용 정도 | 어디에 |
|--------|----------------|--------|
| t_prt_print_options | 도수 라벨/색수 환원 보조(t_prd_product_print_options가 직접 참조) | `OptionValue.priceColorCount` |
| t_cod_base_codes | 코드값 라벨 환원(prd_typ/usage/qty_unit/sel_typ/ref_dim 등) | `unit`·side·라벨. 위젯엔 환원 결과만 |
| t_prd_product_categories ⋈ t_cat_categories | 상품 분류(위젯 진입·동형 클래스 보조). 위젯 렌더엔 직접 불요 | 어댑터 분류·isomorphism |
| t_prd_product_sets | 셋트 sides 도출(표지/내지 구성원) | `sides[]` · evaluate_set_price 입력 |
| t_prd_templates / t_prd_template_selections | addon 템플릿 옵션값·차원(ref_dim_cd) | W-ADDON 그룹 |
| t_prd_product_price_formulas | `priceSchemeKey` echo (frm_cd) | `NormalizedProduct.priceSchemeKey` (불투명, 위젯은 echo만) |

---

## 3. 위젯 미사용 (11) — 서버 가격 권위 [HARD]

가격 7종(`t_prc_price_formulas`·`t_prc_price_components`·`t_prc_formula_components`·`t_prc_component_prices`·`t_prd_product_prices`·`t_prd_template_prices`) + 할인 4종(`t_dsc_*` 3 + `t_prd_product_discount_tables`) + `t_cus_customers`는 **전부 evaluate_price 내부**. 위젯은 단가/공식/할인율을 모른다 — `NormalizedPriceBreakdown.{finalPrice,vat,shipping,lines}` 불투명 결과만 받는다. **이 11테이블의 어떤 컬럼도 위젯/계약에 포팅 금지**(t_prc_* 위젯 포팅 = HARD 위반). `t_prd_products.MES_ITEM_CD`도 컬럼 단위로 위젯 미사용(MES 생산용).

---

## 4. 위젯이 필요로 하나 DB에 없는 속성 (→ added-schema-260701)

search-before-mint 통과한 진짜 갭(상세 사유=`added-schema-260701.md`):
1. **자재/옵션 표시 색상칩** `colorHex` — `OptionValue.colorHex`. t_mat_materials·t_prd_product_options·t_prc_* 어디에도 hex 없음.
2. **자재/옵션 미리보기 이미지** `imageUrl` — `OptionValue.imageUrl`(image-chip). 어떤 테이블에도 이미지 URL 컬럼 없음.
3. **옵션 배지** `badge`(recommend/best/new/up) — `OptionValue.badge`. options.tags(jsonb) 존재하나 표준 배지 enum 부재.
4. **에디터 파트너 분기** `editor_partner_cd` — Edicus psCode/templateUrl/resourceId 발급 라우팅. t_prd_products에 editor_yn(boolean)만 있고 partner/psCode 없음.
5. **공정 표시여부(VIEW_YN)** — hidden-essential 공정(자동적용·비표시) 분류. mand_proc_yn(required)만 있고 visible 컬럼 없음(현재 disp_seq 음수 관례로 우회).

> 4·5는 어댑터/관례로 부분 흡수 가능 — (A)/(B) 분류는 `gaps-and-recommendations.md` 참조.
