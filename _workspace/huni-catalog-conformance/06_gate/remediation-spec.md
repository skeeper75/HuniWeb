# remediation-spec.md — 확정 결함 교정 명세 (인간 승인 큐 · dbmap 라우팅)

> **Phase 6 — hcc-conformance-gate** · 2026-06-22 · `huni-catalog-conformance/06_gate`
> 게이트가 라이브 재실측으로 **확정**한 결함만 교정 명세화. 항목 = {결함·권위 정답·교정 방법·대상 t_*·FK 위상·돈영향·dbmap 트랙·인간 승인}.
> **[HARD] 직접 COMMIT 금지·search-before-mint 준수.** 실 적재는 인간 승인 후 dbmap 트랙 위임(게이트는 명세까지).
> CONFIRM(권위 모호·needed 충돌)은 결함 아님 → §C 별도. 추정 0·단가값 verbatim·신규 mint 최소.

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
