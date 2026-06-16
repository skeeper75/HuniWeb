# 후니 기초데이터 관리 갭 매트릭스 (gap-matrix)

> rpm-gap-analyst. RedPrinting 옵션 관리 메타모델을 후니 base-data 관리 현황과 **축 단위**로 대조.
> 후니 권위 = **라이브 `information_schema`/실측(2026-06-17 read-only 접속 성공)** + `_workspace/huni-dbmap/00_schema/`(스냅샷) + dbmap 누적 round 진단.
> 판정: **PASS**(동등 표현력 보유·t_* 인용) · **WEAK**(그릇 있으나 미정규화/축혼동/오염) · **GAP**(관리 그릇 부재).
> [HARD] **vessel-gap**(스키마가 축을 표현 못함, 본 하네스 산출) vs **data-gap**(테이블 있고 비어있음, `_data-gaps-noted.md`로 분리·dbmap 라우팅) 구분. dbmap 기존 진단과 **중복 재발견 금지** — 알려진 결함에 매핑.
>
> **── 버전 ──**
> - **v1.0 (BN, 13축):** 현수막류 메타모델(13축) 대조. PASS 5·WEAK 6·GAP 2. (§I~III·종합 = BN, **보존**.)
> - **v2.0 (GS 통합):** 메타모델 15축(v2.0)으로 확장 + GS 신축 2(#14 본체형태가공·#15 생산형태) + GS facet 라이브 정밀 실측. BN 13축 판정은 **보존**(GS 실측이 일부 BN 판정 정정 = §VI에 명기). GS 추가 = **§IV(굿즈 본체자재 상세)·§V(GS 신축 #14·#15)·§VI(BN 판정 GS 정정)**.
> - **v3.0 (TP 통합·현재):** 메타모델 16축(v3.0)으로 확장 + TP 신축 1(#16 디자인 입력 채널) + TP facet 5종(T-A~T-E). BN·GS 판정 **보존**. TP 추가 = **§VIII(#16 디자인 입력 채널 — vessel-gap 1순위)·§IX(TP facet 판정)·§X(TP 종합 카운트)**. 라이브 information_schema 정밀 실측(2026-06-17·read-only)으로 #16 그릇 부재 확정.
>
> **GS 라이브 실측 핵심(2026-06-17 read-only):** 굿즈 본체자재는 **vessel-gap(분해축 컬럼 부재) + 부분 data-fix 혼재** — 자세히 §IV. 형태가공(#14)=GAP(봉제만). 생산형태(#15)=WEAK(prd_typ_cd≠생산형태). usage 다중슬롯=PASS(USAGE.01~07 적재). 가격모델 4종=vessel 대부분 존재(template_prices unit_price)·data-gap.

---

## 0. 라이브 접속 결과 (2026-06-17, read-only) — 스냅샷과 큰 드리프트

스냅샷(`00_schema/`, 2026-06-06)은 round-22 이전이라 **stale**. 라이브 실측이 다수를 정정:

| 항목 | 스냅샷(2026-06-06) | **라이브(2026-06-17)** | 영향 |
|---|---:|---:|---|
| `t_prd_product_option_groups` | 13 | **134** | CPQ 옵션 레이어 **대거 적재됨**(round-6/Tier-A 이후) |
| `t_prd_product_options` | 0 | **494** | 〃 |
| `t_prd_product_option_items` | 0 | **469** | round-7 "option_items 전역 0행" 진단 **해소**(data-gap 닫힘) |
| `t_prd_product_constraints` | 0 | **10** | 제약 일부 적재 |
| `t_prd_template_selections` | 0 | **14** | 템플릿 구성 일부 적재 |
| `t_prc_price_formulas` | 0 | **17** | 가격 공식 적재 |
| `t_prc_component_prices` | 0 | **3,416** | 단가행 대거 적재 |
| `t_cat_categories` 고아노드 | 14노드/113상품 | **0** | round-22 ⑥카테고리 교정(DELETE 111) **반영됨** |
| `t_mat_materials` MAT_TYPE.08/.09/.10 | ~129 | **17/69/43=129** | 자재 오염 **여전히 존재**(B-3 미적용) |

→ 결론: **data-gap(빈 테이블)은 대부분 닫혔다.** 남은 것은 주로 **vessel-gap**(스키마가 축을 표현 못함)과 **WEAK**(오염/축혼동). 이게 본 하네스의 산출 대상.

---

## I. 정적 축 (7버킷)

### 1. 자재 축 (Material) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | `Material`(합성 PK) + `MaterialAxis`(TYPE/PTT/CLR/WGT/방식 분해축). mtrl_cd가 *분해 가능*. usage_cd 슬롯·sub_mtrl_yn·price_flag. (dictionary §1) |
| **후니 현황** | `t_mat_materials`(340행, `mat_typ_cd`→MAT_TYPE 14종) + `t_prd_product_materials`(402행, `usage_cd` 슬롯 보유 — round-7/cpq 트리거 `OPT_REF_DIM.03`이 mat_cd+usage_cd 2키로 참조). **그릇은 있다.** |
| **판정** | **WEAK** — 합성 분해축(CLR/PTT/WGT 분리 컬럼) 부재 + **오염**. 라이브 실측: `MAT_TYPE.09`(파우치)가 색(검정/노랑/빨강/초록), 형상(사각/원형/하트/마카롱), 인쇄면(단면/양면/배면만 인쇄), 구수(1구/2구/3구), 사이즈(100mm/11인치)를 **자재 행으로** 보유. `MAT_TYPE.08/.10`도 동형. 합성 자재가 평면 `mat_nm` 문자열 — RP의 CLR/PTT/WGT/방식 분해축 표현 불가. |
| **dbmap 교차참조** | round-22 ④자재 🔴 최대결함(`dbmap-axis-staged-load-round22`)·`dbmap-material-option-normalization`(MAT_TYPE.08~10 오염·본체색=재질행 합성·형상/사이즈/구수 오적재). B-3 비소재 CPQ 축이동 **설계 GO·라이브 적용 0**(경로Y+round-6 CPQ 대기). **재발견 아님 — 알려진 결함에 매핑.** |

### 2. 공정 축 (Process) — **PASS** ✅ (별색 분리는 정상)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `ProcessGroup`+`ProcessMember`(pcs_cod/pcs_dtl_cod·esn_yn·sub_mtrl_yn·qty_input_yn·seq). 별색=공정·UV=공정. (dictionary §2) |
| **후니 현황** | `t_proc_processes`(96행) + `t_prd_product_processes`(196행) + `t_prd_product_process_excl_groups`→option_groups 흡수. 라이브 실측: 별색=공정으로 **정상 분리**(`PROC_000007 별색인쇄`·`PROC_000008 화이트`·`009 클리어`·`011 금색`·`012 은색`), UV=`PROC_000002`, 박=`PROC_000033~049`. |
| **판정** | **PASS** — 별색/UV/박 모두 공정 행으로 보유. 도메인 경계(별색≠자재) 라이브 준수. ※ `sub_mtrl_yn`(자재소비 플래그) 1급 컬럼은 미확인 — 책자/아일렛 확대 시 재점검(아래 D-2 참조). |
| **dbmap 교차참조** | round-22 ③도수 🟢정상·⑤공정 부분 교정(에폭시 PRD_000169 라이브 COMMIT). 별색 분리는 round-13에서 "정답"으로 확정(`dbmap-correctness-audit-round13`). |

### 3. 옵션 축 (Option) — **PASS** ✅

| 면 | 증거 |
|---|---|
| **RP 표현력** | `OptionGroup`(택1/택N)→`Option`→`OptionItem`(polymorphic ref). disp_seq=컬럼순서. (dictionary §3) |
| **후니 현황** | `t_prd_product_option_groups`(134·`sel_typ_cd`→SEL_TYPE 단일123/다중11)→`t_prd_product_options`(494)→`t_prd_product_option_items`(469·`ref_dim_cd`→OPT_REF_DIM 7종·ref_key1/2). 검증 트리거 `fn_chk_opt_item_ref`. disp_seq 보유. |
| **판정** | **PASS** — RP의 3계층 polymorphic 옵션 구조를 **동등 이상** 표현(트리거 강제 무결성까지). 라이브 option_items 469행으로 적재됨(과거 0행 data-gap 닫힘). |
| **dbmap 교차참조** | `dbmap-cpq-option-mapping`·`dbmap-tierA-cpq-option-load`(option_groups=L1 컬럼순서·polymorphic 7종). round-7 "option_items 전역 0행" 진단은 **stale**(라이브 469행). |

### 4. 템플릿/SKU 축 (Template/Bundle) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | `Template`(SKU)→`TemplateSelection`. prd_typ(완제품/반제품/디자인/기성). (dictionary §4) |
| **후니 현황** | `t_prd_templates`(12·`base_prd_cd`→products·dflt_qty)→`t_prd_template_selections`(14·polymorphic+opt_cd+sel_val). `t_prd_product_addons`(5·addon→`tmpl_cd` FK). prd_typ는 `t_prd_products.prd_typ_cd`(PRD_TYPE.01~04). |
| **판정** | **WEAK** — 그릇 구조는 정합하나 **`t_prd_templates.price`(추가가격) 미구현**(cpq-schema §4 🟡9). 완제 SKU의 번들 추가가격 보관처 부재 → 템플릿이 가격 표현력 부족. ※ 구조 자체는 PASS 수준이나 가격 facet 결손으로 WEAK. |
| **dbmap 교차참조** | `cpq-schema.md §4`(templates.price 미구현)·`dbmap-acrylic-price-chain-link`(완제SKU=addons/templates/template_prices·add_price 컬럼 부재→가격은 항상 사슬). prd_typ_cd≠생산형태 오모델 주의(`dbmap-grid-binding-round15`). |

### 5. 제약 축 (Constraint) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | `Constraint`(logic-typed)·6 논리유형(disable/force/require/essential/match/exclude/min-max). JSONLogic. force=disable 역방향. (dictionary §5, D-3) |
| **후니 현황** | `t_prd_product_constraints`(10행·`rule_typ_cd`→RULE_TYPE 3종[호환/금지/필수동반]·`logic` jsonb NN). `t_prd_products.constraint_json`(compile 캐시). 라이브: RULE_TYPE.01=7·.02=2·.03=1. |
| **판정** | **WEAK** — JSONLogic 그릇·rule_typ_cd 보유는 PASS급이나 **RULE_TYPE이 3종(호환/금지/필수동반)뿐** — RP 6 논리유형 중 **match(캐스케이드·사이즈↔부속물)·min-max(nonspec 범위)·essential(그룹내 필수)** 를 별도 유형으로 거버넌스 못함(호환/금지로 환원하면 의미축 drop). disable/force는 호환/금지로 표현 가능하나 match/minmax/essential은 표현력 미달. |
| **dbmap 교차참조** | `dbmap-cpq-option-mapping`(캐스케이드 6종→JSONLogic)·`dbmap-live-admin-product-viewer`(constraints.logic NOT NULL). essential은 option_groups의 `mand_yn`+min/max_sel_cnt로 일부 흡수 가능(아래 search-before-mint 대상). |

### 6. 기초코드 축 (Base-Code/Enum) — **PASS** ✅

| 면 | 증거 |
|---|---|
| **RP 표현력** | `EnumGroup`→`EnumValue`(group_cd/code/label/seq). 사이즈 프리셋·도수·usage/qty_unit/mat_type. (dictionary §6) |
| **후니 현황** | `t_cod_base_codes`(라이브 84행·**16 부모 그룹** + 자식). OPT_REF_DIM/SEL_TYPE/RULE_TYPE/MAT_TYPE/QTY_UNIT 등 enum 그룹 거버넌스. 채번=surrogate PK+이름기반 멱등. |
| **판정** | **PASS** — RP의 EnumGroup/EnumValue 2계층을 동등 표현. 새 enum 축은 코드행 추가로 닫힘(코드행<컬럼 사다리 최저단). |
| **dbmap 교차참조** | `dbmap-code-identifier-strategy`(채번 MAX+1·`_` separator)·`code-values.md`·`ref-base-codes.csv`. |

### 7. 카테고리 축 (Category) — **PASS** ✅ (round-22 교정 후)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `Category`(트리 parent FK·main_yn 잎노드·생산형태 직교). 상품 다중 소속. 고아 금지. (dictionary §7) |
| **후니 현황** | `t_cat_categories`(자기참조 트리 `upr_cat_cd`·lvl1~3) + `t_prd_product_categories`(M:N·`main_cat_yn`·disp_seq). 라이브 실측: **고아 노드 0**(round-22 DELETE 111 반영). |
| **판정** | **PASS** — 트리+다중분류 그릇 보유, 고아 0으로 무결성 회복. ※ 생산형태(완제품/반제품/디자인/기성)는 `prd_typ_cd`에 있으나 **카테고리와 직교 의미 오모델**(prd_typ_cd≠생산형태) 위험은 데이터 정합 이슈(vessel 아님). |
| **dbmap 교차참조** | round-22 ⑥카테고리(고아 페어 삭제·`dbmap-axis-staged-load-round22`)·`dbmap-grid-binding-round15`(prd_typ_cd 생산형태 오귀속). |

---

## II. 관계/동역학 축 (발굴 D-1/D-4/D-5)

### 8. 부속물 축 (Addon) — **PASS** ✅

| 면 | 증거 |
|---|---|
| **RP 표현력** | `Addon`(독립 SKU)·자체 size_variant·본체와 별 lifecycle·size↔부속물 match. (dictionary §8) |
| **후니 현황** | `t_prd_product_addons`(5행·prd_cd→`tmpl_cd` FK→templates). 부속물=template(SKU)로 모델 — RP의 "본체와 분리된 완제 부속"을 템플릿 경유로 표현. |
| **판정** | **PASS** — 부속물을 독립 template SKU로 분리 보유(addon→tmpl_cd). size↔부속물 match는 제약 축(D-3 match 부재)에 의존 → match 결손은 #5 WEAK로 귀속(중복 계상 안 함). |
| **dbmap 교차참조** | `cpq-schema.md`(addon addon_prd_cd→tmpl_cd 변경)·`ref-product-addons.csv`. |

### 9. 공정 파라미터 축 (Process Parameter) — **GAP** ❌ (vessel-gap)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `ProcessParameter`(owner_process·param_type[줄수/mm/색/수량/조각수]·value_domain). 공정 종속 조건부 슬롯. 캐스케이드(오시줄수→접지단수). (dictionary §9, D-4) |
| **후니 현황** | 설계 `ref_param_json`(공정 파라미터 보존) — **라이브 미구현**(cpq-schema §4 🔴8·option_items엔 `qty`만). 타공 4/6/8(구수)·봉제 유형·오시 줄수·책등 mm를 담을 1급 슬롯 부재. |
| **판정** | **GAP** — RP의 "공정에 종속된 매개변수(줄수·mm·색·조각수)" 를 후니 스키마가 표현 못함. 현재는 공정 행 분리 또는 qty 단일값으로 우회(의미축 drop·캐스케이드 불가). **vessel-gap**(스키마가 축을 표현 못함, 빈 테이블 아님). |
| **dbmap 교차참조** | `cpq-schema.md §4 🔴8`(ref_param_json 미구현·banner 7회/postcard 2회 인용)·`dbmap-cpq-option-mapping`(ref_param_json GAP)·`dbmap-process-select-group-domain`. **알려진 GAP에 매핑.** |

### 10. 수량 모델 축 (Quantity Model) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | `QuantitySlot`(slot_type: ORD_CNT 건수/PRN_CNT 수량/bundle_qty/공정종속·price_role 곱수/선형). 다중 의미 슬롯. (dictionary §10, D-5) |
| **후니 현황** | `t_prd_product_bundle_qtys`(28행·묶음수) + `t_prd_product_page_rules`(11·내지) + 가격 수량구간은 `t_dsc_*`/component_prices 차원. **묶음수 슬롯은 있으나** ORD_CNT(디자인 건수)와 PRN_CNT(인쇄 수량)를 *구별된 슬롯*으로 보유하는 그릇 미확인(수량은 주로 가격 차원·옵션으로 평면화). |
| **판정** | **WEAK** — bundle_qty 슬롯은 있으나 RP의 "건수×수량 이중축(가격기여 메커니즘 다름)" 을 1급 슬롯으로 분리 표현 못함. 평면 qty로 두면 세팅곱수 vs 선형 의미 소실. (vessel-gap 후보 — designer가 컬럼 vs 코드로 판정) |
| **dbmap 교차참조** | `dbmap-compute-in-app-db-stores-lookup`(bundle_qty≠page_rule≠인쇄수량·판걸이수=앱계산 DB미저장). RP ORD_CNT는 후니 미관측 — discovered-axes 갭(BN 한계, 추가 샘플 필요). |

---

## III. 횡단 축 (발굴 D-6/D-7)

### 11. 가격기여 역할 축 (Pricing Role) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | 각 선택축에 부착되는 price_role 태그(면적/곱수/고정/단가) + PricingModel(SizeMatrix2D 등). price_flag 전 축 부착. (dictionary §11, D-6) |
| **후니 현황** | `t_prc_*` 4단(price_formulas 17·formula_components·price_components `prc_typ_cd` 단가/합가·component_prices 3,416). 가격기여 *유형*을 prc_typ_cd로 운영. **그릇 있고 적재됨.** |
| **판정** | **WEAK** — prc_typ_cd(단가/합가)는 PASS급이나 (a) 각 *선택축 엔티티*에 붙는 price_role 태그가 아니라 가격 사슬 측에만 존재(자재/사이즈/공정 행에 price_flag 부착 컬럼 부재) (b) **가격사슬 단절**(round-16/21 단가행≠배선)·**frm_typ_cd 라이브 부재**(round-17)로 PricingModel 유형 축 미완. 역할 분류 표현력 부분 결손. |
| **dbmap 교차참조** | `dbmap-price-formula-types-authority`(면적매트릭스형/고정가형)·`dbmap-price-class-benchmark`(15클래스)·`dbmap-price-formula-audit-round17`(frm_typ_cd 라이브 부재)·`dbmap-price-chain-dwire-per-product-formula`(가격사슬 단절). ※ 실제 값/공식은 dbmap 가격 트랙 범위 — 본 매트릭스는 *역할 표현력*까지만. |

### 12. 인쇄방식/생산 레시피 축 (Print-Method Recipe) — **GAP** ❌ (vessel-gap, 조건부)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `PrintMethod`(레시피)·allowed_processes(가능 공정 부분집합)·file_formats·team. 인쇄방식이 공정/파일/팀 게이팅. RP=자재 facet 인코딩, 후니=1급 게이팅 축. (dictionary §12, D-7) |
| **후니 현황** | 인쇄방식은 `t_proc_processes`(PROC_000002~6 = UV/디지털 등)에 *공정 행*으로 존재하나, **"인쇄방식→가능 공정 부분집합 게이팅"을 표현하는 그릇 부재**. allowed_processes·file_formats·team 메타·게이팅 관계를 담을 1급 PrintMethod 엔티티 없음. |
| **판정** | **GAP(조건부)** — 인쇄방식을 공정 행으로 *존재*시킬 수는 있으나, RP/도메인이 요구하는 **게이팅 lifecycle**(방식 선택→가능 공정 집합 결정→파일포맷/팀 결정)을 표현 못함. 1상품=1방식 게이팅은 현재 앱/암묵 규칙. **vessel-gap.** ※ 조건부 — 강제 1급화 금지(메모리 `dbmap-print-method-not-absolute-axis`), match/제약 축으로 게이팅 흡수 가능성은 designer가 판정. |
| **dbmap 교차참조** | `dbmap-print-method-not-absolute-axis`(인쇄방식 절대축 아님·강제 분리 금지)·`process-recipe-tree`(§1 인쇄방식 5종 최상위 게이팅). |

### 13. 사이즈 축 (Size) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | `SizePreset`(프리셋 enum·cut_wdt/hgh·work=재단+4mm) + `NonspecRange`(min/max 0~5000). size=재단치수≠plate. 형상 흡수. (dictionary §13) |
| **후니 현황** | `t_siz_sizes`(497행 마스터) + `t_prd_product_sizes`(444) + `t_prd_product_plate_sizes`(509·output_paper_typ_cd로 판형 분류). size↔plate가 **한 마스터에 공존**(impos_yn/note로 구분). |
| **판정** | **WEAK** — 프리셋 enum은 PASS급이나 (a) **nonspec 자유입력 범위(min/max)** 를 size 행에 담는 1급 컬럼 미확인(현수막류 0~5000 범위제약) (b) size와 plate(출력판형/전지)가 같은 마스터 혼재 → 이중등록·SIZ_PENDING 진단(round-2/plate 트랙). 재단치수 vs 출력판형 축 혼동 WEAK. |
| **dbmap 교차참조** | `dbmap-platesize-is-output-paper`(plate=출력용지규격·권위=상품마스터 출력용지규격 컬럼)·`dbmap-output-plate-mapping`(SIZ_PENDING 출력판형)·`schema-relationship-analysis.md`(판형↔siz↔가격). nonspec 범위는 BN 현수막 RP 관측, 후니 미확인(추가 샘플). |

---

## 종합 카운트 (v1.0 BN 13축 — 보존)

| 판정 | 개수 | 축 |
|---|---:|---|
| **PASS** | 5 | ②공정 · ③옵션 · ⑥기초코드 · ⑦카테고리 · ⑧부속물 |
| **WEAK** | 6 | ①자재 · ④템플릿 · ⑤제약 · ⑩수량모델 · ⑪가격기여역할 · ⑬사이즈 |
| **GAP** | 2 | ⑨공정파라미터 · ⑫인쇄방식레시피 |

- **vessel-gap (본 하네스 산출 대상)**: ⑨공정파라미터(GAP)·⑫인쇄방식레시피(GAP) + WEAK 6의 vessel 결손분(자재 합성분해·제약 논리유형 확장·수량 이중슬롯·가격 role 태그·사이즈 nonspec).
- **data-gap (범위 외, dbmap 라우팅)**: `_data-gaps-noted.md` 참조 — 대부분 라이브 적재로 **이미 닫힘**(option_items 469·constraints 10·prc 3,416). 잔존 부분 적재만 노트.
- **WEAK의 데이터 오염분(자재 MAT_TYPE.08~10 등)**: 그릇은 있으나 잘못 채움 = dbmap 교정 트랙(round-22 B-3) — vessel 신설 아님(축혼동은 vessel이지만 행 오염은 data). 자재 ①은 **양면**(분해축 컬럼 부재=vessel + 오염=data) → vessel-needs에 분해축만 산출.

> 모든 PASS/WEAK/GAP는 양쪽 증거(메타모델 항목 + 후니 t_* 실측) 보유. 라이브 read-only 접속 성공(2026-06-17) — `provisional(snapshot)` 표기 불필요.

---

## IV. ★굿즈 본체자재 결함 — vessel-gap vs data-gap 판별 (GS 최우선·v2.0)

> 사용자 directive 최우선 항목. 메모리 round-22: "굿즈 103상품 본체 소재 확인 0개·상품마스터에 소재 컬럼 부재·소재는 상품명에만·진짜 소재행 .05/.06 고아". RP는 완제 본체에서도 소재/색/용량/두께를 라벨 융합(`PCS_DTL_NME`="미르 와이드마우스 보틀 화이트 20oz") → 메타모델 정답=`{body_material, body_color, capacity, thickness, brand}` 분해축 필수(dictionary §1 G-1, 명제 #11).
> **2026-06-17 라이브 정밀 실측으로 판별** — 이게 본 갭분석의 핵심 산출.

### IV-0. 라이브 실측 결과 (read-only psql 2026-06-17)

| 측정 | 결과 | 함의 |
|---|---|---|
| `t_mat_materials` 컬럼 | `mat_cd·mat_nm·mat_typ_cd·upr_mat_cd·sel_typ_cd·max_sel_cnt·**width·height·depth·weight·bdl_qty**·use_yn·note` | **분해축 컬럼 부재 확정**: `width/height/depth/weight`는 *물리치수*이지 RP의 `body_color(CLR)·capacity·thickness(WGT)·body_material(PTT)` 분해축이 아님. 본체색/용량은 담을 컬럼이 **없음**. |
| MAT_TYPE 코드값 | .03 아크릴·.05 특수소재·.06 가죽 = **정상 본체소재 버킷** / **.09 "파우치"·.10 "악세사리" = 상품군명 버킷** | ★구조적 진원: 후니가 자재유형을 *상품군 이름*(파우치/악세사리)으로 만들어 형상/사이즈/색/구수를 "자재"로 적재 → vessel-level 오라벨. |
| 굿즈 본체소재 링크 실측 | 레더코스터→`MAT_000008 레더`(MAT_TYPE.06)·린넨패브릭코스터→`MAT_000184 린넨`(.05)·아크릴코스터→`MAT_000043 아크릴 투명 3mm`(.03) = **본체소재 행 존재** / 코르크·우드·규조토 코스터 = **본체소재 행 0**(형상행 `원형 90mm`[MAT_TYPE.09]만 링크) | ★**혼재**: round-22 "명확분 41상품 COMMIT"(레더23·캔버스9·린넨5·메쉬4)으로 일부 본체소재 적재됨 = **data 진척**. 미적재 소재(우드/코르크/규조토)는 **data-gap**(소재 행 미생성). |
| `t_prd_products` 컬럼 | `prd_cd·MES_ITEM_CD·prd_nm·prd_typ_cd·semi_role_cd·nonspec_*·file_upload_yn·editor_yn·min/max/dflt_qty·qty_unit_typ_cd` | 상품 본체에 **소재/색/용량/두께 컬럼 없음** — 본체소재는 `t_prd_product_materials`(usage_cd 슬롯) 경유가 정답 경로(상품 컬럼 신설 아님). |

### IV-1. 판정 — **본체자재는 vessel-gap + data-gap 양면 (핵심 답)**

| 측면 | 판정 | 근거(양쪽) |
|---|---|---|
| **본체소재 *링크* 그릇** | **PASS (vessel 존재)** | `t_prd_product_materials.usage_cd`(USAGE.07 등 7슬롯·639+행)로 상품↔자재 본체소재 연결 가능. 레더/린넨/아크릴 코스터 실제 링크됨. RP의 "본체=자재참조"(G-1 (b))를 표현 가능. |
| **본체소재 *분해축*(색/용량/두께)** | **GAP (vessel-gap)** ❌ | RP `{body_color, capacity, thickness, brand}` 분해를 담을 컬럼이 `t_mat_materials`에 부재(`width/height/depth/weight`는 물리치수). RP `PCS_DTL_NME` 융합("화이트 20oz")을 분해 적재할 그릇 없음 → **후니도 라벨 융합/상품명 의존 고착**. dictionary G-1 [HARD] "분해 요구"의 그릇 결손. = `vessel-needs.md` V-3 굿즈 확장. |
| **미적재 소재 행**(우드/코르크/규조토) | **data-gap** | 그릇(MAT_TYPE.05 특수소재 등)은 있고 행만 미생성 → `_data-gaps-noted.md`·round-22 GPM-4 (`dbmap-axis-staged-load-round22` BLOCKED=신규mint 우드/규조토/코르크 ddl-proposer). vessel 신설 아님. |
| **MAT_TYPE.09/.10 오염**(형상/사이즈/색/구수가 자재행) | **data 오염** | 행이 잘못된 축에 들어감 = 축이동 교정(B-3). 단 *목적지 그릇*(본체색=CPQ option·형상=siz·구수=bundle)은 일부만 존재 → 색→CPQ는 vessel 있음(option_items), 형상→siz 있음. **오염 교정=data(B-3), 분해축 컬럼=vessel(V-3).** |

> **★결론(사용자 질의 직답):** 굿즈 본체자재는 **vessel-gap이 우세하되 양면**이다. ① 본체소재를 *상품에 연결*하는 그릇(product_materials+usage)은 **있다(PASS)** — round-22가 41상품 본체소재를 실제 적재(data 진척). ② 그러나 본체소재의 *분해축(색/용량/두께/브랜드)*을 담을 컬럼은 **없다(vessel-gap)** — RP `PCS_DTL_NME` 융합을 분해 못해 후니도 상품명 의존 고착. ③ 미적재 소재 행·MAT_TYPE.09/.10 오염은 **data-gap/오염**(dbmap B-3·GPM-4). → 본 하네스 산출 = **②의 분해축 그릇(V-3 굿즈 확장)만**. ①의 적재 진척과 ③의 교정은 dbmap.

---

## V. GS 신축 — 메타모델 #14·#15 (v2.0)

### 14. 본체 형태가공 축 (Body Form-Assembly, #14) — **GAP** ❌ (vessel-gap)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `FormAssembly`(assembly_cd·assembly_type[봉제/조립/지퍼/접합]·consumes_material[지퍼=부자재]·direction_variant). 평면→입체 본체를 *생성*. RP=`PDT_WRK`(파우치가공·마이크텍조립)·`FLX_ZIP`(지퍼). (dictionary §14, D-10) |
| **후니 현황** | 라이브 `t_proc_processes` 실측: 조립/봉제/지퍼/가공 검색 → **`PROC_000080 봉제`·`PROC_000088 봉제` 2행만**. 조립(PDT_WRK)·지퍼(FLX_ZIP)·파우치가공에 해당하는 공정 행 **부재**. |
| **판정** | **GAP** — 봉제는 공정 행으로 일부 존재하나, RP의 "본체 *생성* 형태가공"(파우치가공·지퍼·조립) lifecycle을 표현하는 그릇 부재. 일반 후가공(#2)에 봉제만 섞여 있고, 형태가공의 *본체 생성성*(없으면 본체 미완)·방향 variant(세로/가로)·지퍼=부자재 consumes를 1급으로 구별 못함. **vessel-gap.** ※ 봉제 행 존재로 "완전 0"은 아니나 축으로서 미구별 → GAP. |
| **dbmap 교차참조** | round-22 굿즈/파우치 본체 자재 BOM(`dbmap-axis-staged-load-round22`: "평면→입체 조립 단계" BOM 동형). 파우치 103상품(레더/캔버스/타이벡/메쉬/린넨 플랫·슬림·삼각·볼륨·스트링)이 형태가공 보유 추정 → load-bearing. **신 진단(중복 아님): 라이브 공정 행에 형태가공 축 미구별 확정.** |

### 15. 생산형태 축 (Production Type, #15·카테고리와 직교) — **WEAK** 🟡

| 면 | 증거 |
|---|---|
| **RP 표현력** | `ProductionType`(prd_typ[A통합/B셋트·반제품/C완제품/기성/디자인]·body_model[A·B=자재행 / C=완제 SKU 항목]·set_structure). 카테고리와 **직교**·본체 모델링을 governing. (dictionary §15, D-9) |
| **후니 현황** | 라이브 `t_cod_base_codes` PRD_TYPE: **.01 완제품·.02 반제품·.03 기성상품·.04 디자인상품·.05 추가상품** (5종 enum 존재). `t_prd_products.prd_typ_cd` 분포: .01=8·.02=28·.03=124·.04=115. 굿즈 실측: 코스터·파우치·노트·텀블러 **전부 `PRD_TYPE.03`(기성상품)**. |
| **판정** | **WEAK** — enum 그릇(PRD_TYPE 5종)·상품당 1값은 PASS급이나 **(a) prd_typ_cd가 RP `body_model`/`set_structure` governing을 안 함**(단순 분류 라벨일 뿐, 본체=자재행 vs 완제SKU 분기를 안 가름) **(b) 값 오모델**: 메모리 round-15 "prd_typ_cd≠생산형태(굿즈/문구=.03기성 오귀속)" — 굿즈가 전부 .03인데 RP 모델로는 텀블러/코스터=C 완제품·노트=A통합/B셋트로 갈려야 함. 카테고리⊥생산형태 직교성도 데이터로 미표현. **그릇 enum은 있으나 governing 의미·직교 분기 표현 부족 = WEAK.** |
| **dbmap 교차참조** | `dbmap-grid-binding-round15`(라이브 prd_typ_cd≠생산형태·굿즈/문구=.03기성·디지털/실사/아크릴=.04디자인 오귀속). **재발견 아님 — 라이브 PRD_TYPE 5종·굿즈 전부 .03 실측으로 확정.** ※ 오모델 교정(.03→올바른 형태)=data(dbmap), governing 표현(body_model 분기 그릇)=vessel 후보(designer 판정). |

---

## VI. BN 13축 판정의 GS 라이브 정정 (보존 + 델타)

> BN 판정(§I~III)은 **보존**. GS 실측(2026-06-17)이 *정정/확증*한 항목만 델타로 기록(원 판정 위에 갱신, 덮어쓰지 않음).

| BN 축 | BN 판정 | GS 실측 델타 | 갱신 판정 |
|---|---|---|---|
| ①자재 | WEAK | **확증·심화**: MAT_TYPE.09/.10이 *상품군명 버킷*(파우치/악세사리)으로 vessel-level 오라벨 확정. 분해축 컬럼 부재 = `width/height/depth/weight`가 물리치수임을 컬럼 실측으로 입증. usage 다중슬롯(USAGE.01~07)은 **PASS**(BN "단일 substrate" 한계가 GS에서 해소 — 본체+내지+링 동시). | **WEAK 유지**(분해축 vessel-gap) — 단 usage 측면은 PASS로 분리 명기 |
| ④템플릿 | WEAK(templates.price 미구현) | **정정 단서**: `t_prd_templates`에 price 컬럼 없음 **확증**하나, 별 테이블 **`t_prd_template_prices`(tmpl_cd·apply_ymd·unit_price)** 존재 발견 → 완제 SKU 개당가(tmpl/vTmpl) 보관 그릇은 **있음**(0행=data-gap). 가격 facet 결손이 vessel-gap이 아니라 **data-gap**으로 재분류 가능. | **WEAK→PASS 근접**(가격 그릇 발견·적재만 부재) |
| ⑬사이즈 | WEAK(nonspec min/max 미확인) | **정정**: `t_prd_products`에 **`nonspec_yn·nonspec_width_min/max·nonspec_height_min/max`** 컬럼 실측 확인 → nonspec 자유입력 범위 그릇 **존재**(BN "미확인"을 PASS로 정정). size/plate 혼재는 별개 data 정합. | **WEAK→부분 PASS**(nonspec 범위 vessel 존재 확정·혼재만 잔존) |
| ⑩수량모델 | WEAK | GS 굿즈도 ORD_CNT(주문건수)×PRN_CNT(인쇄수량) 이중 패턴(텀블러·장패드 PRICE_LOG) — 후니 1급 슬롯 분리는 여전히 미확인(BN과 동일 한계). | **WEAK 유지** |

> **★GS 정정 요지:** GS 라이브 실측이 BN의 보수적 "미확인" 2건을 **vessel 존재로 정정**(④template_prices·⑬nonspec 범위) — 즉 BN보다 후니 표현력이 **더 좋다**(vessel-gap 2건 → data-gap/PASS로 하향). 반대로 ①자재 분해축·#14 형태가공·#15 생산형태 governing은 **vessel-gap 확증**. 순 vessel-gap 변동: ④/⑬ 완화, #14 신규 GAP, #15 신규 WEAK.

---

## VII. v2.0 종합 카운트 (BN 13 + GS 신축 2 = 15축)

| 판정 | 개수 | 축 |
|---|---:|---|
| **PASS** | 5 | ②공정 · ③옵션 · ⑥기초코드 · ⑦카테고리 · ⑧부속물 (+ ①usage 다중슬롯·④template_prices·⑬nonspec = BN WEAK의 PASS 측면) |
| **WEAK** | 7 | ①자재(분해축) · ④템플릿(가격 data-gap화) · ⑤제약 · ⑩수량모델 · ⑪가격기여역할 · ⑬사이즈(혼재) · **#15 생산형태(신규)** |
| **GAP** | 3 | ⑨공정파라미터 · ⑫인쇄방식레시피 · **#14 본체형태가공(신규)** |

- **GS 신축 판정:** #14 형태가공=**GAP**(봉제만·형태가공 미구별), #15 생산형태=**WEAK**(PRD_TYPE enum 있으나 governing 미표현·값 오모델).
- **굿즈 본체자재(핵심):** **vessel-gap(분해축 컬럼)+data-gap(미적재 소재)+data 오염(MAT_TYPE.09/.10) 양면** — vessel 산출=분해축만(V-3 굿즈 확장).
- **GS가 BN 정정:** ④template_prices·⑬nonspec 범위 vessel 발견 → 2건 완화(vessel-gap→data-gap/PASS).

> 모든 판정 양쪽 증거 보유. 라이브 read-only 접속 성공(2026-06-17·psql 직접 SELECT) — `provisional(snapshot)` 불필요. dbmap round-22(B-3·GPM-4·⑥카테고리)와 정합(재발견 아님·라이브 실측으로 확증).

---

## VIII. ★TP 신축 — 메타모델 #16 디자인 입력 채널 (vessel-gap 1순위·directive 핵심·v3.0)

> 사용자 directive 최우선 항목 = "디자인 입력 채널 축(#16/D-11)을 후니가 담을 그릇이 있는가". 라이브 information_schema 정밀 실측(2026-06-17·read-only)으로 판별 — 본 TP 갭분석의 핵심 산출.

### VIII-0. 라이브 실측 결과 (information_schema 직접 SELECT 2026-06-17)

| 측정 | 라이브 결과 | 함의 |
|---|---|---|
| `t_prd_products` 전 컬럼(23) | `prd_cd·MES_ITEM_CD·prd_nm·prd_typ_cd·semi_role_cd·nonspec_*·**file_upload_yn·editor_yn**·min/max/incr/dflt_qty·use_yn·reg/upd_dt·qty_unit_typ_cd·del_yn/dt` | 디자인 입력 신호 = **`editor_yn`·`file_upload_yn` 불리언 2개뿐.** `item_gbn`(채널 타입)·에디터 종류(KOI/Edicus/RP) 구분·`koi_template_resource_id`(템플릿 리소스 포인터)·VDP/가변데이터 컬럼 **전무.** |
| editor/koi/edicus/vdp/item_gbn/channel/resource/asset/template/variable 컬럼 전역 검색 | `t_prd_products.editor_yn`·`file_upload_yn` + `tmpl_cd`(templates 계열)만 매치. **에디터 채널·리소스·VDP 컬럼 0건.** | RP `item_gbn`(vDigital/edicus/offset2023)·`useKoiEditor`/`useRPEditor`·`koiOption[]`·`setVariableData` 대응 그릇 **부재 확정.** |
| 에디터/디자인/리소스/asset/vdp **테이블** 전역 검색 | `t_prd_templates`·`t_prd_template_selections`·`t_prd_template_prices`만. **에디터 채널/디자인 자산 전용 standalone 테이블 0건.** | TemplateAsset(에디터 디자인 시안 카탈로그) 그릇 부재 — `t_prd_templates`는 완제SKU(아래 IX T-A 이중의미). |
| base_codes 그룹 16종 | MAT_TYPE·PRD_TYPE·OPT_REF_DIM·SEL_TYPE·RULE_TYPE·USAGE·QTY_UNIT·SEMI_ROLE·OUTPUT_PAPER_TYPE·PRC_*·DSC_TYPE·CUS_GRADE·TEST* | **에디터 채널/item_gbn enum 그룹 부재** — 채널 *타입*(KOI vs Edicus vs PDF)을 분류할 코드 도메인조차 없음. RP `item_gbn` 3값 대응 enum 미존재. |
| `editor_yn`/`file_upload_yn` 분포(use_yn=Y) | Y/Y=104·Y/N=3·N/Y=91·N/N=49 | editor_yn=Y **107상품** — 에디터 *사용 여부*는 불리언으로 잡으나, *어느 에디터*·*어느 템플릿 리소스*·*VDP 가능*은 표현 불가(평면 불리언). HLCLSTD형(N/Y=PDF전용) 91건은 입력채널 값 보유. |

### VIII-1. 판정 — #16 디자인 입력 채널 = **GAP** ❌ (vessel-gap, 1순위)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `DesignInputChannel`(channel=item_gbn[vDigital_item/edicus_item/offset2023_item]·use_koi_editor·use_rp_editor·use_template_download·use_pdf·ord_cnt_source·vdp_capable) + 종속 `TemplateAsset`(template_resource_id·asset_options·price=0). 입력채널이 디자인수 산정·템플릿 자산 노출·VDP를 *게이팅*. (dictionary §16, D-11) |
| **후니 현황** | 라이브 `t_prd_products`에 **`editor_yn`·`file_upload_yn` 불리언 2개**만. 채널 타입 컬럼·에디터 종류 enum·템플릿 리소스 ID·VDP 변수 스키마 그릇 **전무**(전역 컬럼/테이블/base_code 검색 0건). |
| **판정** | **GAP** — RP의 "디자인을 *어떻게 입력받나*"(KOI/Edicus/PDF 채널 + 템플릿 리소스 바인딩 + VDP 가변데이터 + 디자인수 산정 출처)를 후니 스키마가 표현 못함. 현재는 `editor_yn`(Y/N) 단일 불리언으로 *에디터 사용 여부*만 — RP `item_gbn` 3분기·에디터 종류·리소스 포인터·VDP를 **전혀 담지 못함**(의미축 대거 drop). **vessel-gap**(빈 테이블 아님·스키마가 축을 표현 못함). ★후니=Edicus를 huni-widget RedEditorSDK *코드 계약*으로만 보유, **DB 그릇 미정 가설(T-1) 라이브로 확정**. |
| **dbmap 교차참조** | dbmap에 디자인 입력 채널 진단 **없음**(dbmap은 자재/가격/CPQ/카테고리 축 중심·에디터 채널 미터치). **재발견 아님·dbmap 갭과 비충돌 = 신규 vessel-gap.** huni-widget `seed-redprinting-sdk-analysis.md`(RedEditorSDK 45메서드·`sdkOpenEditor`/`fnKoiEditor`/`fnRpEditor`)·`editor-bridge-protocol.md`(cmd create-design-project·editor_type/run_mode 파라미터)가 *코드 계약*만 — DB 그릇 설계가 vessel 과제. = `vessel-needs.md` **V-10**(P1 최우선). |

> **★결론(사용자 핵심 질의 직답):** **#16 디자인 입력 채널 = GAP(vessel-gap·후니 그릇 부재).** ① 라이브 `t_prd_products`에 `editor_yn`·`file_upload_yn` 불리언 2개만 존재 — *에디터 사용 여부*만 표현. ② RP `item_gbn`(채널 3분기)·에디터 종류(KOI/Edicus/RP)·`koi_template_resource_id`(템플릿 리소스)·VDP 변수 스키마·디자인수 산정 출처에 대응할 **컬럼·테이블·enum 그룹 전무**(전역 검색 0건·base_code 16그룹에 에디터 채널 enum 없음). ③ 후니는 Edicus를 huni-widget RedEditorSDK *코드 계약*으로만 보유하고 **DB 그릇 미정(T-1 가설)을 라이브로 확정** → 입력채널 메타를 담을 그릇 설계가 vessel 1순위. **dbmap이 한 번도 안 건드린 신규 vessel-gap(중복/충돌 없음).**

---

## IX. TP facet 판정 (distinct 거부 — 기존 축 흡수 + 이중의미)

> discovered-axes T-A~T-E(facet 강등)를 후니 그릇 대조. distinct 신축 아니므로 기존 축 판정에 흡수되나, **T-A 템플릿 이중의미 오염 위험**은 별도 명시(directive 요구).

### IX-A. ★템플릿 자산(에디터 디자인 시안) — **WEAK** 🟡 (T-A 이중의미 오염 위험)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `TemplateAsset`(에디터가 로드하는 디자인 시안 카탈로그·가격0·D-11#16 종속). RP=`useTemplateDownload=Y`·`koi_template_resource_id`·SDK getTemplateList. **#4 완제SKU 템플릿과 *같은 단어 다른 의미*.** (dictionary §4 TP 분리·T-A) |
| **후니 현황** | 라이브 `t_prd_templates`(12행) 실측 = **완제SKU/OTC 번들**: `봉투(700x200)`·`카드봉투(블랙) 165x115 50장`·`OPP접착봉투`·`트레싱지봉투` — 전부 봉투류 완제 주문단위(`base_prd_cd`→products·`dflt_qty`·`tmpl_nm`=수량 포함 SKU명). 디자인 시안 리소스 그릇 **아님.** TemplateAsset(에디터 디자인 시안) 그릇 **부재.** |
| **판정** | **WEAK** — TemplateAsset *전용* 그릇은 **부재(GAP성)**이나, **★핵심 위험 = `t_prd_templates`에 TP 디자인 시안을 매핑하면 의미 오염.** 라이브 `t_prd_templates`는 완제SKU(봉투 50장 단위)인데, TP "템플릿"(`koi_template_resource_id` = 가격0 디자인 리소스·런타임 SDK 로드)을 여기 적재하면 *가격0 디자인 리소스를 주문단위로 오모델* → **이중의미 충돌**(dictionary #4 [HARD] "디자인 시안을 완제SKU에 적재 금지"). 그릇 부재 + 오염 위험 양면 = **WEAK + 분리 권고**(별 엔티티 `TemplateAsset`은 #16 입력채널 그릇과 함께 설계 — V-10 종속). |
| **dbmap 교차참조** | dbmap `cpq-schema.md §5`(template_selections=완제SKU 구성·OTC 봉투 선례)·`dbmap-schema-design-intent-first`(카드봉투 색=siz 오매핑 교훈 = 같은 값 잘못된 t_* 위험). **★TP 디자인 시안↔완제SKU 분리 = 본 하네스 신규 명시**(dbmap은 templates를 완제SKU로만 다룸·디자인 시안 미터치). |

### IX-B~E. VDP·페이지계층·형태variant·특수인쇄 — 기존 축 흡수 (요약)

| TP facet | 귀속 축 | 후니 그릇 판정 | 근거(라이브) |
|---|---|---|---|
| **T-B VDP(가변데이터)** | #16 입력채널 데이터바인딩 facet × 수량#10 | **GAP**(vessel-gap, #16 종속) | VDP 변수 스키마(`setVariableData`/`data_feed`) 담을 그릇 부재 — #16 입력채널 그릇과 함께 설계(V-10 일부). 명함(TPBCDFT)·상장(TPPOAWD) VDP 후보. 라이브 가변데이터 컬럼 0건. |
| **T-C 페이지계층(INN_PAGE)** | 수량모델#10 + 제약#5 | **PASS(부분)** ✅ | `t_prd_product_page_rules`(11행) = 내지 페이지룰 그릇 존재(§10 수량모델 WEAK에 흡수·캘린더 월수/북 대수 표현 가능). min/max/step 범위는 제약#5 WEAK. 신규 vessel 불요. |
| **T-D 형태variant(M/I/보딩·탁상/벽걸이)** | 사이즈#13 + 칼틀공정#2 | **WEAK** 🟡 | 사이즈 프리셋(§13 WEAK·`t_siz_sizes`)+칼틀=공정(§2 PASS)으로 흡수. GS THO_CUT 형상 동형(§13 GS 확장). 신규 vessel 불요·기존 사이즈 WEAK에 귀속. |
| **T-E 특수인쇄(PRT_WHT/PRT_MAG·박·미싱)** | 공정#2 (+넘버링=VDP) | **PASS** ✅ | 화이트=`PROC_000008`·클리어 009·박 033~049·별색 007 라이브 보유(§2 PASS). 별색=공정 경계 준수. 미싱(절취선)=공정·넘버링(순차)=VDP면 T-B(#16) 귀속·라이브 미관측→data/검증. 신규 vessel 불요. |

> **TP facet 요지:** T-A 템플릿 자산만 **WEAK(이중의미 오염 위험·V-10 종속 설계)**, T-B VDP는 **#16 GAP에 흡수**, T-C/T-D/T-E는 **기존 축(page_rules·사이즈·공정)으로 흡수**(신규 vessel 불요). 즉 TP가 추가하는 *순 신규 vessel-gap = #16 디자인 입력 채널 1건*(+T-A/T-B는 그 종속·T-A 오염 경고).

---

## X. v3.0 종합 카운트 (BN 13 + GS 신축 2 + TP 신축 1 = 16축)

| 판정 | 개수 | 축 |
|---|---:|---|
| **PASS** | 5 | ②공정 · ③옵션 · ⑥기초코드 · ⑦카테고리 · ⑧부속물 (+ ①usage·④template_prices·⑬nonspec·T-C page_rules·T-E 특수인쇄 = PASS 측면) |
| **WEAK** | 8 | ①자재(분해축) · ④템플릿(가격 data-gap화) · ⑤제약 · ⑩수량모델 · ⑪가격기여역할 · ⑬사이즈(혼재·T-D 형태variant) · #15 생산형태 · **T-A 템플릿 자산(신규·이중의미 오염)** |
| **GAP** | 4 | ⑨공정파라미터 · ⑫인쇄방식레시피 · #14 본체형태가공 · **#16 디자인 입력 채널(신규·★1순위·T-B VDP 종속)** |

- **TP 신축 판정:** **#16 디자인 입력 채널 = GAP**(★vessel-gap 1순위·후니 그릇 부재·라이브 확정). T-A 템플릿 자산=**WEAK**(이중의미 오염 위험). T-B VDP=#16 GAP 흡수. T-C/T-D/T-E=기존 축 흡수.
- **디자인 입력 채널(directive 핵심):** **vessel-gap**(데이터 미적재 아님) — `editor_yn` 불리언만·item_gbn/에디터종류/리소스ID/VDP 그릇 전무·base_code enum 부재. dbmap 미터치 신규 갭(중복/충돌 없음). 후니 Edicus=코드 계약만·DB 그릇 미정 확정.
- **TP가 BN/GS 정정 안 함:** TP는 본체와 직교한 *신축*이라 기존 BN/GS 판정 불변(보존). T-C 페이지계층은 기존 page_rules로 PASS·신규 갭 아님.

> 모든 판정 양쪽 증거 보유(메타모델 항목 + 후니 t_* 라이브 실측). 라이브 information_schema 직접 SELECT(2026-06-17·read-only) — `provisional(snapshot)` 불필요. **TP 신규 vessel-gap = #16 1건(+T-A/T-B 종속)·dbmap 갭과 비충돌.**
