# db-contract-mapping.md — 현재 라이브 DB → 정규화 위젯 계약 매핑 매트릭스

> 파이프라인 ③' 컨버전 선행. **권위 = `docs/huni/table-spec_260619.html`(36테이블/374컬럼)** + 라이브 스냅샷(2026-07-01).
> 이 문서는 `03_spec/huni-db-mapping.md`(2026-06-02, "가격/제약 미작성" 전제)를 **SUPERSEDE**한다.
> 목적: 어댑터(`createHuniAdapter`)가 흡수할 매핑 규칙. **위젯 계약(`04_build/src/contract/*`)은 불변**.
> 가격은 서버 권위(`pricing.py:evaluate_price` 불투명 결과). componentType=테이블 종류+값 특성 판정(이름 아님).

## 0. 계약 타입 → 라이브 출처 한눈에

| 계약 타입 | 주 출처 테이블 | 보조 |
|-----------|----------------|------|
| `NormalizedProduct` | t_prd_products | t_prd_product_sets · t_prd_product_categories |
| `ProductSide[]` | t_prd_products.semi_role_cd + t_prd_product_sets | usage_cd |
| `OptionGroup[]` | option_groups / sizes / materials / print_options / processes / plate_sizes / page_rules / addons | option_items(ref_dim) |
| `OptionValue[]` | options / 각 차원 테이블 ⋈ 마스터(siz/mat/clr/proc) | t_cod_base_codes(라벨) |
| `NormalizedConstraints` | t_prd_product_constraints + materials.usage + sizes + page_rules | excl(upr_proc_cd) |
| `NormalizedPriceRequest` | (위젯 선택 상태 조립) | option_items.ref_dim 환원 |
| `NormalizedPriceBreakdown` | **evaluate_price 결과** (불투명) | t_prc_*(서버 내부, 포팅 금지) |
| editor/upload/cart | t_prd_products.{editor_yn,file_upload_yn} | (Edicus psCode=DB 부재→갭) |

---

## 1. NormalizedProduct

| 계약 필드 | 라이브 컬럼 | 변환 규칙 | 갭 |
|-----------|------------|-----------|-----|
| `code` | t_prd_products.prd_cd | 불투명 echo | — |
| `name` | prd_nm | 직접 | — |
| `unit` | qty_unit_typ_cd → t_cod_base_codes.cod_nm (QTY_UNIT.02='매' 등) | 코드 라벨 환원. 없으면 bdl_unit_typ_cd 파생 | — |
| `priceSchemeKey` | t_prd_product_price_formulas.frm_cd (최신 apply_bgn_ymd) | 불투명 echo (이제 적재됨·76→138행) | — |
| `itemGroup` | prd_typ_cd(+셋트 여부) | 완제품/반제품/셋트 분류. fixture 미전달 시 isBook 휴리스틱 | — |
| `sides` | semi_role_cd + t_prd_product_sets 구성원 | 단일=`[default]` / 책자·셋트=`[default(표지),inner(내지)]` | — |
| `optionGroups` | §2 | §2 | — |
| `constraints` | §3 | §3 | — |
| `editors` | `{koi:editor_yn==='Y', rp:false, pdf:file_upload_yn==='Y'}` | rp(RedEditor)는 후니 미사용 | partner코드 없음 (B) |
| `cta` | `{pdfUpload:file_upload_yn==='Y', designEditor:editor_yn==='Y', cart:true, estimate:true}` | 직접 | — |

---

## 2. OptionGroup → componentType 판정 (14종)

판정 알고리즘 (DESIGN.md componentType, data-contract §0.1 — **데이터셋 이름 아님**):

| 정규화 그룹 | 라이브 출처 | componentType | 판정 근거 |
|-------------|------------|---------------|-----------|
| 규격(size) | product_sizes ⋈ siz_sizes | `option-button`(값≤6) / `select-box`(값多) | 값 개수 |
| 비규격 치수 | products.nonspec_*  | `area-input`(2축) / `dimension-matrix-input`(프리셋칩+자유입력) | nonspec_yn='Y' |
| 판형(plate) | product_plate_sizes ⋈ siz_sizes | (대개 비노출 — evaluate_price 자동매칭) | 종이류만·고객 선택 대개 없음 |
| 용지(material) | product_materials ⋈ mat_materials | 값多=`select-box` / 이미지有=`image-chip` / 색지=`color-chip` | mat_typ_cd + (imageUrl/colorHex 보유 시) |
| 도수(print) | product_print_options ⋈ clr_color_counts | `option-button` | 고정 |
| 후가공(process) | product_processes ⋈ proc_processes | `finish-button` / 색상有=`color-chip` / 입력有=`finish-select-box` | prcs_dtl_opt inputs/color |
| CPQ 옵션 단일 | option_groups(SEL_TYPE.01) | `option-button` / `select-box` | 값 개수 |
| CPQ 옵션 다중 | option_groups(SEL_TYPE.02) | `acc-panel`(다단) / `finish-button`(평면) | min/max_sel_cnt·종속 |
| 수량(quantity) | products.{min,max,qty_incr,dflt}_qty + bundle_qtys | `counter-input` (InputSpec) | 항상 |
| 내지페이지 | page_rules | `page-counter-input` (InputSpec) | 책자 |
| addon | product_addons ⋈ templates | addon 그룹(W-ADDON) | tmpl 연결 |
| 요약 | (없음) | `summary` | 어댑터 생성 |
| 업로드 | products.{file_upload_yn,editor_yn} | `upload-cta` | 어댑터 생성 |

**CPQ polymorphic ref_dim 환원** (option_items.ref_dim_cd → 가격요청 차원키), [[dbmap-cpq-option-layer-mapping]] L1≠L2:

| ref_dim_cd | 의미 | ref_key1 / ref_key2 | 환원 → 가격요청 키 |
|------------|------|---------------------|--------------------|
| OPT_REF_DIM.01 | 사이즈 | siz_cd | `siz_cd` |
| OPT_REF_DIM.02 | 판형 | plt_siz_cd | `plt_siz_cd` |
| OPT_REF_DIM.03 | 자재 | mat_cd / usage_cd | `mat_cd` |
| OPT_REF_DIM.04 | 공정 | proc_cd | `proc_cd`/procs[] |
| OPT_REF_DIM.05 | 묶음수 | bdl_qty | bundle |
| OPT_REF_DIM.06 | 도수 | print_opt_cd | `print_opt_cd` |
| OPT_REF_DIM.07 | 셋트 | sub_prd_cd | set member |

> 파일럿 PRD_000041 실측: 인쇄그룹(OPT_000052)→ref_dim.06(도수), 종이(OPT_000053)→ref_dim.03(자재+usage), 후가공(OPT_000054)→ref_dim.04(공정). 어댑터는 옵션 선택값(opt_cd)을 option_items로 조인해 가격요청 차원키로 환원하고, 응답 시 opt_cd round-trip echo.

### OptionValue 필드 매핑
| 계약 필드 | 라이브 출처 | 갭 |
|-----------|------------|-----|
| `id` | 차원 코드(siz_cd/mat_cd/print_opt_cd/proc_cd/opt_cd) | 불투명 echo |
| `label` | 마스터 *_nm (usr_def_nm 우선) | — |
| `disabled` | (런타임 캐스케이드 계산, 어댑터 초기 false) | — |
| `priceColorCount` | print_options.front/back_colrcnt → clr_color_counts.chnl_cnt | — |
| `colorHex` | ❌ **없음** | (C) added-schema |
| `imageUrl` | ❌ **없음** | (C) added-schema |
| `badge` | options.tags(jsonb·표준 enum 부재) | (C) added-schema |
| `addColorCapable` | ❌ **없음**(별색/형광 가용) | (C) added-schema |
| `colorSide` | print_options.print_side 파생 | — |
| `attb` | proc_processes.prcs_dtl_opt inputs 산출 | — |

---

## 3. NormalizedConstraints (캐스케이드 6종) — 이제 라이브 제약 적재

| 제약 | 라이브 출처 | 매핑 | 비고 |
|------|------------|------|------|
| ① material→process disable | t_prd_product_constraints(logic JSONLogic·rule_typ=금지) + upr_proc_cd(택일) | `disableRules[]` | 라이브 12행(파일럿 PRD_000041=0행) |
| ①-b visibility add/remove | constraints(rule_typ) | `visibilityRules[]` | 부재 시 빈 배열 |
| ② quantity | products.{min,max,qty_incr,dflt}_qty + page_rules.{page_*} | `quantity[side]` QuantityRule | 직접 |
| ③ dosu↔color | clr_color_counts.chnl_cnt | `OptionValue.priceColorCount` 평면화 | 별도 배열 없음 |
| ④ size | siz_sizes.{cut,work}_{width,height} | `sizeRules[]` SizeRule | 직접 1:1 |
| ⑤ essential/hidden→required/visible | processes.mand_proc_yn(required) / disp_seq 음수(hidden 관례) | `OptionGroup.{required,visible}` 평면화 | **visible 전용컬럼 부재**(D) |
| ⑥ base | siz_sizes margin + products.nonspec_* | `BaseRule` | 직접 |

> rule_typ_cd: 금지(RULE_TYPE.01)→disableRules / 필수동반(RULE_TYPE.02)→required 게이트. logic은 JSONLogic이므로 어댑터가 `{var}`/`{and}` 파싱해 trigger/disables 추출.

---

## 4. NormalizedPriceRequest / Breakdown — 서버 권위 경계

상세는 `evaluate-price-contract.md`. 요약:
- 위젯 선택 8축(dimensions/colorCounts/materials/quantity/pageCount/selectedFinishes/addColor/printCount) → 어댑터가 **option_items.ref_dim 환원** + `priceSchemeKey` echo → `evaluate_price(target, selections, qty, grade_cd)` 입력 `{siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, ...}`.
- 셋트는 `evaluate_set_price(set_prd_cd, members, set_selections, copies)`.
- 응답 `final_price`/`base.components[]` → `NormalizedPriceBreakdown.{finalPrice, lines[]}`. **PRICE=0=결함 신호**.
- t_prc_* (공식/구성요소/단가행/할인) **위젯 포팅 금지** — evaluate_price 내부.

---

## 5. editor / upload / cart

| 계약 | 라이브 출처 | 갭 |
|------|------------|-----|
| `NormalizedEditorConfig.{psCode,templateUrl,resourceId,token}` | t_prd_products.editor_yn(boolean) — **psCode/templateUrl/resourceId/partner 코드 부재** | (C) added-schema editor_partner_cd / Edicus 발급 메타는 BFF 책임 |
| `NormalizedPresigned` | (커머스/스토리지 BFF) | 위젯 스코프 밖(UNDECIDED) |
| `NormalizedCartHandoff` | 위젯 조립(selectedOptions=opt_cd round-trip) | 커머스 바인딩 UNDECIDED → (C) |
| `NormalizedOrderReadiness` | (서버) | 서버 doc 검수 — DB 테이블 부재 (C) |

---

## 6. supersede 표기

`03_spec/huni-db-mapping.md` 헤더에 STALE/SUPERSEDED 마커 존재 확인(2026-07-01). 본 문서가 권위.
