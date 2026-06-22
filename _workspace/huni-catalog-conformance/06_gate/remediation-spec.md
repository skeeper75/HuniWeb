# remediation-spec.md — 확정 결함 교정 명세 (인간 승인 큐 · dbmap 라우팅)

> **Phase 6 — hcc-conformance-gate** · 2026-06-22 · `huni-catalog-conformance/06_gate`
> 게이트가 라이브 재실측으로 **확정**한 결함만 교정 명세화. 항목 = {결함·권위 정답·교정 방법·대상 t_*·FK 위상·돈영향·dbmap 트랙·인간 승인}.
> **[HARD] 직접 COMMIT 금지·search-before-mint 준수.** 실 적재는 인간 승인 후 dbmap 트랙 위임(게이트는 명세까지).
> CONFIRM(권위 모호·needed 충돌)은 결함 아님 → §C 별도. 추정 0·단가값 verbatim·신규 mint 최소.
>
> **★[HARD] 교정 범위 제약(사용자 directive 2026-06-22):** 기초코드/공유 마스터는 **수정 금지**, 상품별 구성요소만 접근.
> 본 명세는 §S에서 R1~R9를 **클래스 A(상품별 t_prd_product_* 만으로 닫힘)** vs **클래스 B(공유 마스터 수정 필요·보류)**로
> 재분류한다. §1~§C 원본은 결함 사실·돈영향 기록으로 유지하되, **실제 교정 가능 범위의 권위는 §S**다.

---

## §S — 교정 범위 재분류 (클래스 A 가능 / 클래스 B 보류) ★권위

> **허용(클래스 A 후보)** = `t_prd_product_*` : product_sizes·materials·print_options·processes·plate_sizes·bundle_qtys·
> page_rules·addons·option_groups·options·option_items·constraints·templates·**price_formulas 바인딩**(t_prd_product_price_formulas).
> **금지(클래스 B)** = 기초코드/공유 : t_mat_materials·t_siz_sizes·**t_prc_price_components**(공유 comp·use_dims)·
> **t_prc_price_formulas**(공식 정의 본체)·**t_prc_component_prices**(공유 단가행)·코드값 그룹·t_prc_formula_components(공식 배선=본체 종속).
> 라이브 재실측으로 각 항목이 어느 테이블에서 닫히는지 확인(아래 근거).

### 클래스 A — 상품별 교정 가능 (t_prd_product_* 만으로 닫힘)

| ID | 결함 | 대상 t_prd_product_* | FK 위상(선존재=마스터, 미수정) | 돈영향 | dbmap 트랙 | 인간승인 |
|----|------|---------------------|--------------------------------|--------|------------|:--:|
| **A2-bind** | 미바인딩 中 **019·049** 공식 바인딩(기존 PRF 재사용) | `t_prd_product_price_formulas`(prd_cd,frm_cd) | 기존 PRF_DGP_A/E(본체 미수정) ← 바인딩 | 019 차단해소(단가행 SIZ_000499/077 실재) | dbm-load-execution(바인딩만) | 필요 |
| **A3-proc** | 별색/접지/커팅 **product_processes 링크** 추가 | `t_prd_product_processes`(prd_cd,proc_cd,mand_proc_yn,disp_seq) | PROC_000007~012 마스터 실재(미수정) ← 링크 | 별색 선택 가능화(가산은 B 동반) | dbm-correctness-audit | 필요 |
| **A3-popt** | 도수/인쇄면 **print_options 링크** 보정 | `t_prd_product_print_options`(front/back_colrcnt_cd) | CLR 마스터 실재(미수정) | 견적옵션 정합 | dbm-correctness-audit | 필요 |
| **A5-plate** | 판형 혼입/오매칭 **product 판형 정리** | `t_prd_product_plate_sizes`(siz_cd,output_paper_typ_cd,del_yn) | SIZ 마스터 실재(미수정) ← 행 교정/논리삭제 | 019 완성품치수 혼입 제거·030/049 권위판형 매핑 | dbm-correctness-audit | 필요 |
| **A6-opt** | **옵션그룹/옵션/옵션항목** 적재(21상품·046 완성) | `t_prd_product_option_groups`·`options`·`option_items`(ref_dim_cd 타입+ref_key1 코드) | 차원 마스터 실재(미수정) ← 포인터 | 견적 차원환원 가능화 | dbm-option-mapper | 필요 |
| **A7-addon** | **추가상품/템플릿** 연결(9상품) | `t_prd_product_addons`(prd_cd,tmpl_cd)·`t_prd_templates`(base_prd_cd)·`t_prd_template_selections` | base 상품 실재(미수정) | 추가상품 견적 복구 | dbm-option-mapper | 필요 |
| **A8-mat** | 형압명함 **자재 슬롯** 적재(038) | `t_prd_product_materials`(mat_cd,usage_cd) | mat 마스터 실재(미수정) ← 링크 | 용지비 산출 가능화 | dbm-axis-staged-load | 필요(별도설정 의미 컨펌) |
| **A9-bundle** | 명함 **묶음수** 적재(031~040)·024 EXTRA 논리삭제 | `t_prd_product_bundle_qtys`(bdl_qty,bdl_unit_typ_cd,del_yn) | QTY_UNIT 코드 실재(미수정) | LOW(옵션표시) | dbm-load-builder | 선택 |
| **A-constr** | 제약규칙 적재(needed 확정 후·§C-X3) | `t_prd_product_constraints`(rule_cd,logic,err_msg) | — (상품별 규칙) | UI 제약 가드 | dbm-cpq-option-mapping | 보류→needed 확정 후 |

**클래스 A 항목 수 = 9** (A2-bind·A3-proc·A3-popt·A5-plate·A6-opt·A7-addon·A8-mat·A9-bundle·A-constr).
**클래스 A 중 돈크리티컬 = 있음** → **A2-bind(019 차단해소·바인딩만으로 0원→견적복구)** 1건. 나머지 A는 과소/옵션/환원(중·저).

### 클래스 B — 보류 (기초코드/공유 마스터 수정 필요)

| ID | 결함 | 공유 마스터(수정 금지) | 돈영향 | 상품별 우회 가능성 | dbmap 트랙 |
|----|------|----------------------|--------|---------------------|------------|
| **B1-namecard** | 명함 D-A(variant 공식 신설)+D-B(STD use_dims에 print_opt_cd 등재) | `t_prc_price_formulas`(PRF_NAMECARD_* 신설)·`t_prc_formula_components`(배선)·`t_prc_price_components`(STD use_dims UPDATE)·`t_prc_component_prices`(print_opt 충전) | **과대 +280K / 0원 −550K** (최고 돈크리티컬) | **불가.** PRF_NAMECARD_FIXED만 존재·STD comp 공유. variant 공식·use_dims·단가행 전부 공유 영역. 상품별 t_prd_product_*로는 잘못 배선된 공유 공식을 못 고침(바인딩 대상 자체가 결함) | dbm-price-arbiter→dbm-load-execution |
| **B2-formula-new** | 미바인딩 명함 **034~040**(variant 공식 부재) | `t_prc_price_formulas`(신설)·`t_prc_formula_components` | **차단 0원** | **불가.** PRF_NAMECARD_FIXED 1종뿐·바인딩하면 D-A/D-B 결함 상속. variant 공식 신설=공유 본체 | dbm-price-arbiter→dbm-load-execution |
| **B3-print-rows** | 미바인딩 **030·049** 판형 공유 단가행 0 | `t_prc_component_prices`(COMP_PRINT plt_siz=SIZ_000142/143/186/188/190 충전) | **차단 0원** | **부분.** R5-plate(클래스 A)로 030/049 판형을 단가행이 있는 판형(SIZ_000499/077 등)으로 정정하면 우회 가능 — 단 권위판형(330x660=SIZ_000475)도 공유 단가행 0행 → 정답 판형 확정(§C Q-DGP-PLATE)이 선행. 권위판형 고수 시 공유 단가행 충전=B | dbm-correctness-audit(A) + dbm-load-execution(B) |
| **B4-coat-glossy** | COMP_COAT_GLOSSY 공유 단가행 0 | `t_prc_component_prices`(유광 단가 INSERT) | 과소(유광 미부과) | **불가.** 공유 comp 단가행. 전 PRF_DGP_A/D/E 상품 공통. 상품별 우회 없음 | dbm-load-execution |
| **B5-spot-price** | 별색 선택의 **가격 가산**(comp 배선·단가) | `t_prc_formula_components`(별색 comp 배선)·`t_prc_component_prices`(별색 단가) | 과소(별색 가산비 누락) | **부분.** A3-proc로 선택은 가능화하나 **가격 가산은 공유 공식 배선·단가행 필요**. 선택만 되고 돈 안 붙으면 과소 잔존 | dbm-price-arbiter→dbm-load-execution |

**클래스 B(보류) 항목 수 = 5** (B1·B2·B3·B4·B5). **B1·B2가 최고 돈크리티컬이나 전부 공유 영역 → 보류.**

### §S 종합 — 범위 제약의 효과

- **돈크리티컬 결함의 핵심(B1 명함 D-A/D-B·B2 명함 미바인딩)은 전부 클래스 B(공유 공식·comp)** → 이 directive 하에서는 **교정 불가·보류.** 상품별 t_prd_product_* 접근만으론 잘못 배선된 공유 공식을 고칠 수 없다(바인딩 대상 자체가 결함).
- **클래스 A로 닫히는 돈크리티컬 = A2-bind 019 1건**(기존 정상 공식 PRF_DGP_A에 바인딩만 → 0원 차단 해소).
- **A3/A5/B5 연동 주의:** 별색은 A3-proc(선택 가능화·클래스 A)와 B5-spot-price(가격 가산·클래스 B)가 분리된다. 클래스 A만 하면 "선택은 되나 가격은 0" → **과소 잔존**. 완전 교정은 B 동반 필요(보류).
- **030/049(B3):** R5-plate(클래스 A 판형 정정)로 단가행 있는 판형에 매핑하면 공유 단가행 충전 없이 우회 가능성 — 단 정답 판형(§C Q-DGP-PLATE) 확정 선행. 권위 330x660 고수 시 B.
- **결론:** 범위 제약 하 즉시 진행 가능 = 클래스 A 9항목(돈크리티컬 1=019 바인딩). 최대 돈영향 명함 결함은 공유 영역으로 **보류**(인간이 공유 마스터 수정 승인해야 해소).

### §S-보류 — K6·CONFIRM 미해결 (교정 보류)

| 항목 | 보류 사유 | 클래스 |
|------|-----------|--------|
| **K6 gstack 3원 대조** | HUNI_ADMIN_PW 인증 실패(추측 금지) → 화면 결함 미확인 → 화면 기반 교정 불가 | 보류(자격증명) |
| **DEF-PE-05**(단가형 ×qty 의미) | 권위 엑셀 모호(장당가 vs 묶음가)·B1 정확도 선행조건 | 보류(CONFIRM·공유) |
| **R-X1 needed(037/050/051)** | 판형 needed=Y/N 인간 확정 필요(plate typ NULL) | 보류(needed 재판정) |
| **R-X3 constraints needed 상품수** | "34 전건 needed=Y" 미입증·상품별 별표/블리드 재추출 필요 | 보류→확정 후 A-constr |
| **R-X4 페이지룰** | domain-lens 판수=앱런타임 충돌·CONFIRM 강등 | 보류(잡음 가능) |
| **Q-DGP-PLATE/SPOT·Q-COAT-TIER·Q-ROUND** | 권위 모호(B3·B5·B4 정답 결정 선행) | 보류(CONFIRM) |
| **C-016-BUNDLE** | 권위 1봉투 vs 라이브 5봉투 재정의 필요 | 보류(권위 확정) |

> 보류 항목은 인간 확인/공유 마스터 수정 승인 전까지 교정 진행 금지. 클래스 A 진행은 보류 항목과 독립.

---

## 0. 인간 승인 큐 — 우선순위 (돈크리티컬 Top)

| # | 결함 | 돈영향 | 대상 상품 | 승인 |
|--:|------|--------|----------|:--:|
| **R1** | 명함 D-A/D-B (COAT 미배선 + STD 이중합산) | **과대 +280K/100매 또는 0원·과소** | 031·032(전 명함류 동형) | **필요(돈크리티컬·최우선)** |
| **R2** | 미바인딩 10상품(공식 0) | **차단 0원·주문불가** | 019·030·034~040·049 | **필요(차단·최우선)** |
| **R3** | 별색인쇄 미적재(process·option_group) | **과소·견적가산 누락** | 019~025·035·036·039·040·043~046·048 (17) | 필요 |
| **R4** | COMP_COAT_GLOSSY 단가행 0 | 과소(유광 미부과) | PRF_DGP_A/D/E 사용 상품 | 필요 |
| **R5** | 판형 오매칭/혼입 | 단가행 오매칭 위험 | 030·049(MISMATCH)·019(EXTRA) | 필요 |
| **R6** | 옵션그룹 미적재(견적 선택 불가) | 견적 차원환원 불가 | 옵션그룹 0행 21상품 | 필요 |
| **R7** | 추가상품/템플릿 미적재 | 추가상품 견적 누락 | 017~022·043~045 (9) | 필요 |
| **R8** | 자재 미적재(형압명함) | 용지비 산출 불가 | 038 | 필요 |
| **R9** | 묶음수 미적재(명함 박스단위) | 옵션표시(LOW) | 031~040 (10) | 선택 |

---

## R1 — 명함 D-A/D-B (돈크리티컬·최우선)

- **결함(라이브 재현):** PRF_NAMECARD_FIXED에 COMP_NAMECARD_STD_S1/S2 **만** 배선. (a) COAT/PREMIUM/PEARL/SHAPE/FOIL/WHITE variant comp는 orphan(미배선) → 코팅명함이 STD로 매겨지거나(MAT_000082) 0원(MAT_000081). (b) STD use_dims=[mat_cd,min_qty]에 **print_opt_cd 부재** + 단가행 print_opt_cd 전부 NULL → 단면 선택해도 S1·S2 둘 다 매칭 → silent 이중합산.
- **권위 정답:** 명함은 자재/후가공 variant별 단가(COAT 5,500~·PREMIUM 4,500~)·인쇄면(단면 S1·양면 S2 택1). 단가값 라이브 verbatim 실재(orphan comp).
- **교정 방법 (두 갈래·둘 다 필요):**
  1. **D-A 해소(variant 배선):** 명함 variant별 전용 공식 신설(PRF_NAMECARD_COAT·_PREMIUM·_PEARL·_SHAPE·_FOIL·_WHITE) + 해당 상품 바인딩. comp 신규 mint **불요**(전부 실재) → formula_components 배선 + product_price_formulas 바인딩만. (engine-design-digitalprint.md §3.1·§4 명세 재사용·search-before-mint)
  2. **D-B 해소(인쇄면 판별):** COMP_NAMECARD_STD_S1 단가행에 print_opt_cd=POPT_000001(단면)·S2에 POPT_000002(양면) 충전 **+ comp use_dims에 print_opt_cd 등재(둘 다 선행 필수)**. 단가값 불변(verbatim). ※게이트 정정: 보드는 단가행 충전만 언급했으나 **use_dims 미등재 시 매칭 차원에 안 들어가 무효** → use_dims UPDATE 선행.
- **대상 t_*:** `t_prc_price_formulas`(신설)·`t_prc_formula_components`(배선)·`t_prd_product_price_formulas`(바인딩)·`t_prc_price_components`(use_dims UPDATE)·`t_prc_component_prices`(print_opt_cd 충전 UPDATE).
- **FK 위상:** comp(실재) → price_formulas(신설) → formula_components → product_price_formulas. component_prices print_opt_cd는 POPT 마스터 선존재 확인(POPT_000001/2 실재).
- **돈영향:** 시나리오 MAT_000082 단면 860,000(현) → 580,000(정답)=−280,000 과대 교정. MAT_000081 0원(현) → 550,000 견적복구.
- **dbmap 트랙:** `dbm-price-arbiter`(variant 공식 신설·prc_typ 의미 심의=DEF-PE-05 합산) → `dbm-load-execution`(배선·use_dims·print_opt UPDATE).
- **인간 승인:** **필요(돈크리티컬).** ★DEF-PE-05(단가형 ×qty: STD 3,500이 장당가인지 100매 묶음가인지) 권위 확정이 R1 정확도의 선행조건 → §C-DEF-PE-05 먼저 컨펌.

## R2 — 미바인딩 10상품 (차단·최우선)

- **결함:** 019·030·034·035·036·037·038·039·040·049 — t_prd_product_price_formulas 행 부재 → final 0원/None.
- **권위 정답:** 상품마스터 가격공식 칸 의도 존재 + engine-design §4 바인딩 명세(전 상품 needed=Y).
- **교정 방법:** 9상품은 comp orphan 실재 → **공식 신설+바인딩**(신규 mint 불요). 형압명함(038)만 comp 미실재 → 단가 권위 확정 후 comp 신설(G-4 심의).
- **대상 t_*:** `t_prd_product_price_formulas`(바인딩)·필요 시 `t_prc_price_formulas`/`formula_components`. 038은 추가로 `t_prc_price_components`+`component_prices`.
- **FK 위상:** comp → formula → product 바인딩.
- **돈영향:** 견적 0원 → 정상 견적 복구(차단 해소).
- **dbmap 트랙:** engine-design 명세 → `dbm-load-execution`. 038 comp 부재 → `dbm-price-arbiter`(G-4).
- **인간 승인:** 필요.

## R3 — 별색인쇄 미적재 (과소·견적가산 누락)

- **결함:** PROC_000007~012(별색/화이트/클리어/핑크/금/은) 마스터 실재·**디지털 product_processes 링크 0**. 17상품 별색/접지/커팅 옵션 미연결(인쇄옵션 MISSING/MISMATCH).
- **권위 정답:** 상품마스터 `별색인쇄(옵션)_*`·`접지(옵션)`·`커팅(옵션)`. 별색=공정(clr_cd=NULL·PROC_000007 family).
- **교정 방법:** product_processes 링크 적재 + 가격 가산 위해 해당 comp(별색/접지/커팅 process comp)·formula 배선. 별색을 도수로 넣지 말 것(domain-lens §2/§3). ※K7 X2 정정: 024/025 화이트인쇄는 **MISSING(MISMATCH 아님)** — 옵션 미적재.
- **대상 t_*:** `t_prd_product_processes`·(가격) `t_prc_formula_components`·`component_prices`. (옵션) `t_prd_product_option_groups/options/option_items`(R6 동반).
- **FK 위상:** proc 마스터(실재) → product_processes → option_items(ref_key1=proc) → 가격 comp 배선.
- **돈영향:** 별색/커팅 가산비 미부과 과소.
- **dbmap 트랙:** `dbm-correctness-audit`(상품별 추출규칙) + `dbm-axis-staged-load`(공정 축) + `dbm-option-mapper`.
- **인간 승인:** 필요.

## R4 — COMP_COAT_GLOSSY 단가행 0 (과소)

- **결함:** 유광코팅 comp가 PRF_DGP_A/D/E에 배선됐으나 단가행 0(MATTE 92행과 대조) → 유광 선택분 0원 침묵.
- **권위 정답:** 인쇄상품 가격표 `코팅` 시트 유광 단/양면 단가.
- **교정 방법:** 가격표 유광 단가행 INSERT(plt_siz_cd·coat_side_cnt·min_qty 차원·verbatim). 신규 comp 불요(COMP_COAT_GLOSSY 실재).
- **대상 t_*:** `t_prc_component_prices`(INSERT).
- **FK 위상:** comp(실재) → component_prices. plt_siz 마스터 선존재 확인.
- **돈영향:** 유광코팅비 과소 교정.
- **dbmap 트랙:** [[dbmap-price-import-round16]] → `dbm-load-execution`.
- **인간 승인:** 필요. ※Q-COAT-TIER(구간 경계 이상/이하) 미명시 → 적재 전 §C 컨펌.

## R5 — 판형 오매칭/혼입 (단가행 오매칭 위험)

- **결함:** 030 라이브 work 604x154·154x604(권위 330x660 MISMATCH) / 049 635x303·644x303·646x303(권위 330x660 MISMATCH) / 019 완성품치수(102x152·137x137·150x212·typ=NULL) plate_sizes 혼입(EXTRA) + SIZ_000522(315x467) 정상판형 공존.
- **권위 정답:** 상품마스터 `파일사양_출력용지규격`. component_prices.plt_siz_cd=출력판형(완성품 아님).
- **교정 방법:** 030/049 권위 출력판형으로 plate 교정(330x660 search-before-mint·기존 plate 매핑). 019는 완성품치수 plate 행 논리삭제(del_yn=Y) — 완성품 사이즈는 t_prd_product_sizes로, plate는 SIZ_000522만 유지.
- **대상 t_*:** `t_prd_product_plate_sizes`(교정/논리삭제)·연동 `t_prc_component_prices` 단가행 plt_siz 재매핑.
- **FK 위상:** plate siz 마스터 선존재 → plate_sizes → component_prices.
- **돈영향:** 단가행 plt_siz_cd 오매칭 시 잘못된 인쇄/용지비. (Q-DGP-PLATE 3절/국4절 분기 심의 동반.)
- **dbmap 트랙:** `dbm-correctness-audit`.
- **인간 승인:** 필요. ※030/049는 §C Q-DGP-PLATE 연관.

## R6 — 옵션그룹 미적재 (견적 차원환원 불가)

- **결함:** 21상품 t_prd_product_option_groups 0행 → 고객 옵션 선택 불가. (046은 grp 1·item 0 미완성 MISMATCH.)
- **권위 정답:** 상품마스터 옵션성 컬럼(주문방법·종이·인쇄·후가공·별색·접지·커팅·박). 디지털 전 상품 최소 주문방법 needed=Y.
- **교정 방법:** option_groups→options→option_items 설계·적재. option_item은 **이미 적재된 차원행 포인터**(L2≠L1·차원 재적재 금지·ref_dim_cd 타입판별+ref_key1 실코드). 046은 커팅 공정 차원 참조 채우고 권위 커팅값(사각) 정합.
- **대상 t_*:** `t_prd_product_option_groups`·`options`·`option_items`.
- **FK 위상:** 차원 마스터(siz/mat/proc·선존재) → option_groups → options → option_items(ref_key1=차원코드). fn_chk_opt_item_ref 트리거 정합.
- **돈영향:** 직접 0원 아니나 견적 환원 불가(R3 별색 옵션 동반 시 가산비 차단=N2 cross-board).
- **dbmap 트랙:** `dbm-option-mapper`(option_groups 설계) + `dbm-cpq-option-mapping`.
- **인간 승인:** 필요.

## R7 — 추가상품/템플릿 미적재

- **결함:** 017~022(엽서6)·043~045(배경지3) addon 0행·연결 템플릿 0(needed=Y). 016만 5/5 정상(MISMATCH=권위 1봉투 vs 라이브 5봉투는 §C-016).
- **권위 정답:** 상품마스터 `추가상품(옵션)`(엽서봉투 100x150 등).
- **교정 방법:** addons + templates(base_prd_cd+size freeze) 적재. ref_dim_cd 아님(템플릿 경유).
- **대상 t_*:** `t_prd_product_addons`·`t_prd_templates`·`t_prd_template_selections`.
- **FK 위상:** templates(base_prd_cd 선존재) → product_addons(tmpl_cd) → template_selections.
- **돈영향:** 추가상품 견적 누락(별 SKU 미판매).
- **dbmap 트랙:** `dbm-option-mapper`.
- **인간 승인:** 필요.

## R8 — 자재 미적재 (형압명함 038)

- **결함:** 038 t_prd_product_materials 0행 → 용지비 COMP_PAPER 산출 불가.
- **권위 정답:** 상품마스터 `종이(필수)`=*별도설정.
- **교정 방법:** 종이 슬롯(mat_cd·usage_cd) 적재. 별도설정 의미 권위 확정 후.
- **대상 t_*:** `t_prd_product_materials`.
- **dbmap 트랙:** `dbm-axis-staged-load`(자재 축).
- **인간 승인:** 필요(별도설정 의미 컨펌 동반).

## R9 — 묶음수 미적재 (LOW·옵션표시)

- **결함:** 031~040 명함 건수(박스단위) bundle_qtys 0행. (024 EXTRA=needed=N인데 적재.)
- **권위 정답:** 상품마스터 `제작수량_건수(옵션)`. 단 건수 표기 실재 여부 상품별 재확인(X-bundle).
- **교정 방법:** bundle_qtys 적재(bdl_qty·QTY_UNIT.03). 024는 needed=N이면 논리삭제.
- **대상 t_*:** `t_prd_product_bundle_qtys`.
- **dbmap 트랙:** `dbm-load-builder` / 024 EXTRA는 `dbm-correctness-audit`.
- **인간 승인:** 선택(LOW).

---

## §C — CONFIRM 큐 (결함 아님·인간 확인 후 R항목 정확도 결정)

> 권위 엑셀끼리 모호·needed 충돌. 게이트가 임의 확정 금지. R 적재 전 선행 컨펌.

| ID | 내용 | 게이트 라이브 단서 | 연관 |
|----|------|--------------------|------|
| **DEF-PE-05** | 명함 단가(STD 3,500 등)가 장당가인가 100매 묶음가인가 | 전 명함 comp prc_typ=PRICE_TYPE.01(단가형)·min_qty=100 보유 → 단가형이면 ×qty(×100 위험)·묶음가면 합가형(÷min_qty) 교정 | **R1 선행 필수** |
| **R-X1 needed(037/050/051)** | 037 박명함·050 봉투·051 썬캡 판형 needed=Y/N | plate output_paper_typ_cd 전부 NULL → 050/051 EXTRA(비판형 needed=N 채택)·037 CONFIRM(미명시) | needed 재판정 |
| **R-X3 constraints needed 상품수** | constraints 0(미적재 확정)·단 "34 전건 needed=Y" 미입증 | 상품별 별표/블리드/박크기/가변 권위 재추출 필요 | needed 확정 |
| **R-X4 페이지룰** | 016~019·027 page_rule needed | page_rules 0행·domain-lens [HARD] 판수=앱런타임 DB미저장 충돌 → CONFIRM 강등 | 낱장 엽서=잡음·027만 검토 |
| **Q-DGP-PLATE** | 3절 vs 국4절 출력판형 분기(판걸이수 시트 결정) | 030/049 plate 교정의 정답 판형 결정 | **R5 동반** |
| **Q-DGP-SPOT** | 별색엽서 인쇄비 공식 변형(일반엽서 상이) | 별색 가격 comp 설계 | R3 동반 |
| **Q-COAT-TIER / Q-ROUND** | 코팅 수량행 구간 경계·반올림 규칙 미명시 | 가격표 미명시 | R4 동반 |
| **C-016-BUNDLE** | 016 추가상품 권위 1봉투 vs 라이브 5봉투 | 5 addon→5 template 정상 해소(무결성 OK)·권위 묶음 재정의 | R7 |

---

## dbmap 라우팅 요약

| 트랙 | R 항목 |
|------|--------|
| `dbm-price-arbiter`(심의) | R1(variant 공식·DEF-PE-05)·R2(038 comp G-4) |
| `dbm-load-execution`(적재) | R1·R2·R4(인간 승인 후) |
| `dbm-correctness-audit` | R3·R5·R9(024 EXTRA) |
| `dbm-axis-staged-load` | R3(공정)·R8(자재) |
| `dbm-option-mapper`/`dbm-cpq-option-mapping` | R6·R7 |
| `dbm-load-builder` | R9 |

**[HARD] 게이트는 명세까지.** 실 INSERT/UPDATE/DDL은 전부 인간 승인 후 위 트랙. search-before-mint(orphan comp·plate 마스터 재사용·신규 mint 최소).

---

# 배치1 — 포토북·캘린더 13상품 교정 명세 (게이트 확정 결함)

> Phase 6 배치1 · hcc-conformance-gate · 2026-06-22 · 라이브 직접 재실측 확정분만. **실 COMMIT/DDL은 인간 승인.**
> 클래스 A=상품별 구성요소(t_prd_product_*) 교정 가능 · 클래스 B=기초코드 공유마스터 충돌=보류(memory `catalog-conformance-remediation-scope`).
> ★기초코드(t_mat/t_siz/t_prc 공유) 직접수정 금지 · webadmin 코드 직접수정 금지 · search-before-mint.

## B1. 확정 결함 요약
- 확정 결함: **클래스 A 14건 + 클래스 B 0건**(+ 횡단 정정 1·CONFIRM 6).
- 돈크리티컬: **6건**(공식 미바인딩=견적 0원 차단 — 가장 비싼 등급). 자재오염 4·page_rule 7·판형 1·역할축 비대칭은 견적옵션/생산정보 결함(저~중).
- **모두 상품별 구성요소(t_prd_product_*) 또는 신규 공식그래프(t_prc_* 신설)** → 클래스 A. 기존 공유마스터 값 변경 0 → 클래스 B(보류) 없음. 단 공식 신설은 가격 돈크리티컬이라 dbm-price-arbiter 심의+인간 승인 필수.

## B2. 교정 명세 (결함·정답·방법·대상·돈영향·트랙·승인)

| ID | 결함 | 권위 정답 | 교정 방법 | 대상 t_* | 돈영향 | dbmap 트랙 | 클래스 | 승인 |
|----|------|-----------|-----------|----------|--------|-----------|:--:|:--:|
| **R-B1-PRICE** | 6 prd 공식 미바인딩(100·108~112)·PRF_PHOTOBOOK*/PRF_CAL* 0행 | 설계 engine-design-photobook §2~5·calendar §2~6: 공식 신설+comp(일부)신설+단가행+바인딩 | full WIRE: t_prc_price_formulas 신설→formula_components 배선→component_prices 충전(재사용 comp는 충전됨)→t_prd_product_price_formulas 바인딩 | t_prc_price_formulas·_formula_components·_component_prices·t_prd_product_price_formulas | **차단(0원)** | dbm-price-arbiter(심의)→dbm-load-execution | A | ✔필수 |
| **R-B1-OPT** | CPQ 옵션 레이어 전무(13 prd grp/opt/item 0) | domain-lens: 포토북=주문방법+표지타입택일·캘린더=주문방법+캘린더가공택일 | option_groups→options→option_items 설계·적재(표지타입→mat_cd·사이즈→proc_cd 판별차원 주입) | t_prd_product_option_groups/_options/_option_items | 차단가중(차원 미주입) | dbm-option-mapper→dbm-load-execution | A | ✔필수 |
| **R-B1-CONSTR** | 제약 0행(6 prd needed=Y) | 권위 블리드·책등10/12/14/16·캘린더 제약주석 | JSONLogic constraints 설계·적재 | t_prd_product_constraints(.logic) | UI가드 부재 | dbm-cpq-option-mapping→dbm-load-execution | A | ✔필수 |
| **R-B1-MAT-CONTAM** | 캘린더 자재오염 4(108/109/111/112 삼각대·링 USAGE.07) | materials=종이만·삼각대/링=공정축(캘린더가공/링칼라) | 삼각대(252/254)·링(253) 자재행 논리삭제(del_yn=Y) + 공정 재귀속(한 트랜잭션) | t_prd_product_materials(del)·t_prd_product_processes(insert) | 생산정보 오염 | dbm-axis-staged-load | A | ✔필수 |
| **R-B1-PROC-CRAFT** | 108/109 링/삼각대 공정 미등록(자재 EXTRA의 짝) | 108=삼각대(그레이)+링블랙·109=삼각대(블랙)+링블랙 | 공정 INSERT(R-B1-MAT-CONTAM과 동일 트랜잭션·축이동) | t_prd_product_processes | 생산정보 누락 | dbm-axis-staged-load | A | ✔필수 |
| **R-B1-PLATE-112** | 112 판형 304x629(SIZ_000292 작업판) | 출력용지규격 330x660=SIZ_000475(실재) | plate siz_cd 정정 SIZ_000292→SIZ_000475(search-before-mint·신규 mint 불요) | t_prd_product_plate_sizes | 단가차원(가격엔진 교차) | dbm-load-builder(가격 단가행 영향=dbm-price-arbiter 교차) | A | ✔필수 |
| **R-B1-PAGE-CAL** | 캘린더 page_rule 0행(108~112) | 108=30P·109=26P·110=12P·111=13P·112=13P | page_rule 코드행 적재(고정 min=max vs 가변=Q-CAL-PAGE-SHAPE CONFIRM 선결) | t_prd_product_page_rules | 견적옵션(편집매수) | dbm-load-builder | A | ✔(CONFIRM 후) |
| **R-B1-SEMI-ROLE** | 101~107 역할축(도수/판형/공정) 0행 — 본체 superset | 내지=양면·작업203·표지=단면·무광·면지=PUR | **교정 아님·구조 의도 확정 선행**: 본체집약 정상이면 N/A 재판정·멤버환원이 정합이면 역할축 환원 | t_prd_product_*(조건부) | (구조의존) | dbm-correctness-audit(의도 확정→환원/N/A 분기) | A | ✔(의도 확정 후) |
| **R-GATE1** | checklist target_table `t_prd_products.constraint_json` 컬럼 부재(49행·디지털36+배치13) | 제약=t_prd_product_constraints.logic | checklist target_table 49행 정정(스키마 오류·데이터 결함 아님) | (산출물 checklist) | 없음(메타) | dbm-correctness-audit(횡단·checklist 권위 산출물=인간 확인) | A(메타) | ✔ |

## B3. CONFIRM 큐 (결함 아님·인간 확정 — 임의 처리 금지)
| ID | 모호 | 영향 |
|----|------|------|
| Q-PB-SUPERSET | 101~107 본체집약 superset 정상 vs 멤버환원 정합 | R-B1-SEMI-ROLE 12셀 verdict 분기(B-N1 합류) |
| Q-CAL-PAGE-SHAPE | 캘린더 page_rule 고정(min=max) vs 편집기 가변 | R-B1-PAGE-CAL 적재값 |
| Q-CAL-PLATE-112 | 304x629→330x660 정정 정합(가격 단가차원) | R-B1-PLATE-112 |
| Q-CAL-PROC-EXTRA-110 | 110 타공이 권위누락인지 정당공정인지(111 동일) | 110/111 공정 EXTRA 판정 |
| Q-PB-SETPRICE/PAGEBASE/MAT | 포토북 base24 묶음·base_min 시작점·표지타입↔mat_cd | R-B1-PRICE 단가행 정확성(돈크리티컬·잘못 확정 시 과대/과소) |
| B-N4 반제품 고객노출 | 101~107 product-viewer 노출=dead-catalog vs 숨김 N/A | K6 BLOCKED 해소 후 |

## B4. 인간 승인 큐 (우선순위)
1. **[돈크리티컬·top] R-B1-PRICE** — 6 prd 공식 full WIRE. Q-PB-PAGEBASE/MAT/SETPRICE 컨펌 동반(잘못 적재 시 과대/과소). dbm-price-arbiter 심의 선행.
2. **R-B1-PLATE-112** — 판형 정정(가격 단가차원·디지털 019 동형 선례). Q-CAL-PLATE-112 컨펌.
3. **R-B1-MAT-CONTAM + R-B1-PROC-CRAFT** — 자재→공정 축이동 한 트랜잭션(생산정보).
4. **R-GATE1** — checklist 49행 횡단 정정(메타·저위험·디지털 배치 공통).
5. **R-B1-SEMI-ROLE / Q-PB-SUPERSET** — 구조 의도 확정 선행(교정 아님).
6. R-B1-OPT/CONSTR/PAGE-CAL — 옵션·제약·페이지 적재(CONFIRM 후).

> 라이브 COMMIT 0(이 게이트는 명세까지). 기초코드 공유마스터 직접수정 금지. 실 적재는 인간 승인 후 dbmap 트랙 위임.

---

# 배치2 — 책자10·문구9·악세15 (34상품) 교정 명세 (게이트 확정 결함)

> Phase 6 배치2 · hcc-conformance-gate · 2026-06-23 · 라이브+코드 직접 재실측 확정분만. **실 COMMIT/DDL 인간 승인.**
> ★기초코드(공유 마스터 t_mat/t_siz/t_prc 공통) 직접수정 금지·webadmin 코드(pricing.py) 직접수정 금지.
> 클래스 A=상품별 구성요소(t_prd_product_*) 교정 / 클래스 B=공유 마스터·공식·코드 충돌(보류/별도 트랙).

## B2.교정 명세 표

| ID | 결함 | 권위 정답 | 교정 방법 | 대상 t_* | FK 위상 | 돈영향 | dbm 트랙 | 클래스 | 승인 |
|----|------|-----------|-----------|----------|---------|--------|----------|--------|:--:|
| **R-B2-094** | 094 silent 이중합산(단/양면 wildcard) | 단면=S1만·양면=S2만 (print_opt_cd 판별차원) | COMP_PCB_S1_20P 단가행 print_opt_cd=단면·S2_20P=양면 충전 + comp use_dims에 print_opt_cd 등재(둘 다 필수). 단가값 verbatim 불변. 30p variant(S1/S2_30P) 배선+페이지축 설계 | t_prc_component_prices(UPDATE)·t_prc_price_components.use_dims(UPDATE) | comp 차원 정의(공유) | **과대 +11.5K/장(단·+11K 양)** | dbm-price-arbiter→dbm-load-execution | **B**(공유 comp 차원·돈크리·최우선) | ✔ |
| **R-B2-BIND** | 068~071 PRF_BIND_SUM=JUNGCHEOL(del=Y)만 misfire | 무선=MUSEON·PUR=PUR·트윈링=TWINRING(활성·proc_cd 통합 32행)·표지/내지 comp 합산 | PRF_BIND_SUM 재배선(상품별 제본 comp)+중철 오염 교정+표지/내지 신설. ★pricing.py del_yn 필터는 webadmin 코드(직접수정 금지·구조위험만 기록) | t_prc_formula_components(재배선)·신규 표지/내지 comp | 공식 그래프 변경(공유) | 과소/미완성가 | dbm-price-arbiter→dbm-load-execution | **B**(공유 공식·webadmin 코드 위험) | ✔ |
| **R-B2-DL5** | 책자 사이즈 옵션→삭제 siz 5 dead link | A5(170)·A5세로(253)·A4가로(255) 활성 siz로 재포인트 또는 옵션 제거 | option_item.ref_key1을 활성 siz_cd로 교정(또는 해당 항목 del). SIZ_000172(활성)은 정상 | t_prd_product_option_items(068/069/071) | option_item→siz 참조 | 차단(견적불가) | dbm-option-mapper | **A**(상품별 option_item) | ✔ |
| **R-B2-070MAT** | 070 PUR책자 자재 MISSING(용지비 누락) | 내지/표지종이=*별도설정(종이 옵션 다수) | t_prd_product_materials INSERT(형제 068/069/071 동형 종이 세트) | t_prd_product_materials(070) | mat_cd→t_mat 참조 | 차단(용지비 0) | dbm-axis-staged-load | **A**(상품별 materials) | ✔ |
| **R-B2-MISS28** | MISSING 28(미바인딩/미가격 견적0원) | 책자=PRF_<제본>_SUM·문구=AC열 고정가 product_prices·악세=AC-1/AC-2 가격사슬·떡메모=PRF_TTEOKME_FIXED 바인딩 | engine-design-booklet/stationery/accessory 명세대로 공식 신설·바인딩·product_prices INSERT | t_prd_product_price_formulas·t_prd_product_prices·t_prc_*(신규) | 공식→comp→단가→바인딩 | 차단(견적0원) | dbm-load-execution(+price-arbiter 심의) | A(상품별 바인딩/가격)+B(신규 공유 comp) | ✔ |
| **R-B2-ADDON** | 악세 001/002 addon 연결 OK이나 양 경로 가격 전무 | 자체 완제품가(product_prices)+addon 단가(template_prices) 양쪽 적재 | product_prices INSERT + template_prices INSERT(TMPL-000005/006) | t_prd_product_prices·t_prd_template_prices | template_prices→tmpl 참조 | 차단(양 경로 0원) | dbm-load-execution | A | ✔ |

## B2.클래스 분리 (★기초코드 미수정 directive)

- **클래스 A(상품별 구성요소 교정·즉시 가능)**: R-B2-DL5(option_item)·R-B2-070MAT(materials)·R-B2-MISS28 일부(상품별 바인딩·product_prices)·R-B2-ADDON. → 상품별 t_prd_product_* 한정. 기초코드 무관.
- **클래스 B(공유 마스터·공식·코드 충돌·보류/별도 트랙)**:
  - **R-B2-094**(돈크리 최우선이나 use_dims=comp 마스터 차원 정의=공유). 단가값 불변·차원 충전만이라 영향 좁으나 COMP_PCB_*를 쓰는 모든 공식에 print_opt_cd 차원이 추가됨 → 공유영향 검토 필수.
  - **R-B2-BIND**(PRF_BIND_SUM=공유 공식·표지/내지 comp 신규=공유). pricing.py del_yn 필터 부재는 **webadmin 코드**(직접수정 금지·구조개선 별도 트랙·코드 PR은 인간).
  - R-B2-MISS28 신규 공유 comp 부분.

## B2.인간 승인 큐 (우선순위)

1. **R-B2-094** — 돈크리티컬 silent 과대청구(양방향·경고없이 틀린값 성립=가장 위험). use_dims 변경 공유영향 검토 후 승인.
2. **R-B2-BIND** — 068~071 misfire(과소/미완성가)·표지내지 누락. del_yn 코드위험 별도.
3. **R-B2-DL5 / R-B2-070MAT** — 차단 결함(견적불가)·클래스 A 즉시 가능.
4. **R-B2-MISS28 / R-B2-ADDON** — 견적0원 28+양경로. 명세는 engine-design-* 존재.

## B2.codex 라우팅 처리 (reconcile 수렴)
- **신규B 채택**: R-B2-094 교정범위에 **양방향 명시**(단면+양면 둘 다 print_opt_cd 충전 = S1·S2 각각 단/양면 판별차원). 단면만 고치면 양면 +11,000 잔존.
- **신규A 라우팅(범위축소)**: del_yn 필터 부재=구조위험 사실이나 라이브 스캔 결과 formula_components 배선된 del_yn=Y comp는 **전 카탈로그 단 1건**(COMP_BIND_JUNGCHEOL→PRF_BIND_SUM)=배치2가 유일 노출 케이스 커버. 광범위 공통피해는 라이브 미입증 → 코드 구조개선은 webadmin 트랙(직접수정 금지).

> 라이브 COMMIT 0(이 게이트는 명세까지). 기초코드 공유마스터·webadmin 코드 직접수정 금지. 실 적재는 인간 승인 후 dbmap 트랙 위임.
