# 후니 기초데이터 관리 갭 매트릭스 (gap-matrix)

> rpm-gap-analyst. RedPrinting 옵션 관리 메타모델을 후니 base-data 관리 현황과 **축 단위**로 대조.
> 후니 권위 = **라이브 `information_schema`/실측(2026-06-17 read-only 접속 성공)** + `_workspace/huni-dbmap/00_schema/`(스냅샷) + dbmap 누적 round 진단.
> 판정: **PASS**(동등 표현력 보유·t_* 인용) · **WEAK**(그릇 있으나 미정규화/축혼동/오염) · **GAP**(관리 그릇 부재).
> [HARD] **vessel-gap**(스키마가 축을 표현 못함, 본 하네스 산출) vs **data-gap**(테이블 있고 비어있음, `_data-gaps-noted.md`로 분리·dbmap 라우팅) 구분. dbmap 기존 진단과 **중복 재발견 금지** — 알려진 결함에 매핑.
>
> **── 버전 ──**
> - **v1.0 (BN, 13축):** 현수막류 메타모델(13축) 대조. PASS 5·WEAK 6·GAP 2. (§I~III·종합 = BN, **보존**.)
> - **v2.0 (GS 통합):** 메타모델 15축(v2.0)으로 확장 + GS 신축 2(#14 본체형태가공·#15 생산형태) + GS facet 라이브 정밀 실측. BN 13축 판정은 **보존**(GS 실측이 일부 BN 판정 정정 = §VI에 명기). GS 추가 = **§IV(굿즈 본체자재 상세)·§V(GS 신축 #14·#15)·§VI(BN 판정 GS 정정)**.
> - **v3.0 (TP 통합):** 메타모델 16축(v3.0)으로 확장 + TP 신축 1(#16 디자인 입력 채널) + TP facet 5종(T-A~T-E). BN·GS 판정 **보존**. TP 추가 = **§VIII(#16 디자인 입력 채널 — vessel-gap 1순위)·§IX(TP facet 판정)·§X(TP 종합 카운트)**. 라이브 information_schema 정밀 실측(2026-06-17·read-only)으로 #16 그릇 부재 확정.
> - **v4.0 (PR 통합):** PR(인쇄물·책자·리플렛·포스터)이 발굴한 **distinct 신축 0건 + facet 강화 9건(P-1~P-9)**. 따라서 PR 갭의 핵심 = "새 축 그릇 부재"가 아니라 **PR이 강화한 기존 축의 facet들을 후니가 같은 표현력으로 담는가**. **신규 축 카운트 변동 0** — 16축 유지. PR 추가 = **§XI(PR facet 6항 PASS/WEAK/GAP·라이브 2026-06-17 실측)**. BN·GS·TP 판정 **보존**. **★실측 핵심: PR facet 6건 중 PASS 4 (cover/inner usage·접지/제본 공정·page_rules 엔티티·면지 bundle)·WEAK 1 (digital_price 라우팅)·GAP 1 (인쇄방식 자재풀 게이팅) — distinct 신축이 없으니 신규 vessel-gap도 0(전부 기존 §I~III 축 판정에 흡수·인쇄방식 게이팅은 기존 #12 GAP과 동일).**
> - **v5.0 (ST 통합) ★16축 포화 붕괴:** ST(스티커)가 **distinct 신축 1건(#17 형상) + facet 강화 9건(S-2~S-10)**을 도입. PR이 입증한 16축 포화를 ST가 정직하게 깸 — **17축**. ST 추가 = **§XIII(형상축 #17 ★vessel-gap 별도 강조 + ST facet 5항 PASS/WEAK/GAP·라이브 2026-06-17 실측)·§XIV(ST 종합 카운트)**. BN·GS·TP·PR 판정 **보존**. **★실측 핵심(라이브 information_schema 직접 SELECT): ① 형상축 #17 = GAP(vessel-gap·신규) — t_* 전 테이블에 `shape`/`shape_cd`/`outline`/`die`/`form_typ` 컬럼 0건·형상 전용 테이블 0건·base_code 16그룹에 SHAPE/형상 enum 부재 → KB G-SK-2 "형상이 어느 축에도 없음"을 라이브가 확증. ② facet 5항 분포 = PASS 1(재단입자 S-3·PROC_053/054/055 라이브 실재)·WEAK 2(점착소재 S-4=기존 #1 자재 분해축·disable 룰엔진 S-8=기존 #5 제약)·GAP 1(인쇄방식 S-5=기존 #12)·기존축흡수 1(칼선 S-2=공정#2 family·단 자유칼선 도무송 별 process row 부재). 형상 #17만 신규 vessel-gap·나머지 전부 기존 축 판정에 흡수.**
> - **v6.0 (CL 통합·현재) ★17축 재포화(PR 패턴 반복):** CL(의류·티셔츠·앞치마·가방류)이 **distinct 신축 0건(★의류 variant #18 부결) + facet 강화 5항(C-2~C-9 클러스터)**. CL reverse가 "의류 variant=distinct #18"를 강하게 제기(전용 clothes2025 모델·전용 apparel_info 6키·size×color 2D 매트릭스·Pantone 1124)했으나 메타모델 단계가 전건 facet 강등 → 갭의 핵심 = **CL이 강화한 facet들(size×color 2D matrix·인쇄위치 멀티슬롯·인쇄방식·Pantone 별색·item_gbn discriminator)을 후니가 같은 표현력으로 담는가**. **신규 축 카운트 변동 0 — 17축 유지.** CL 추가 = **§XV(CL facet 5항 PASS/WEAK/GAP·라이브 2026-06-17 실측)·§XVI(CL 종합 카운트)**. BN·GS·TP·PR·ST 판정 **보존**. **★실측 핵심(라이브 information_schema 직접 SELECT 2026-06-17): CL facet 5건 중 신규 vessel-gap 0 — ① size×color 2D matrix(C-2/C-3) = WEAK(기존 #1 자재 분해축 + #5 제약에 흡수·단 ★`option_items.ref_key1/ref_key2` 2D 페어링이 라이브 활성[255/469 ref_key2 사용]=2D 셀 표현 그릇은 보유·자재 CLR 분해축만 부재) ② 인쇄위치 멀티슬롯(C-4) = WEAK(★`t_prd_product_processes` PK=(prd_cd,proc_cd)·위치 컬럼 0건=공정행으론 위치반복 불가·단 option_groups[SEL_TYPE.02 다중]→option_items[ref_dim_cd=공정.04] 경유로 다중위치 표현 가능=그릇 보유·기존 #2/#9에 흡수) ③ 인쇄방식 실크/전사/DTF(C-6) = GAP(기존 #12) ④ Pantone 별색(C-7) = PASS(★`PROC_000007 별색인쇄`+화이트008/클리어009/금색011/은색012 라이브 실재·별색=공정 경계) ⑤ item_gbn=clothes2025 discriminator(C-5) = WEAK(기존 #15 생산형태). 신규 vessel-gap 0·전부 기존 §I~§XIV 판정에 흡수(PR 패턴 반복).**
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
| **후니 현황** | `t_proc_processes`(**97행**·라이브 2026-06-17) + `t_prd_product_processes`(**270행**·라이브 2026-06-17) + `t_prd_product_process_excl_groups`→option_groups 흡수. 라이브 실측: 별색=공정으로 **정상 분리**(`PROC_000007 별색인쇄`·`PROC_000008 화이트`·`009 클리어`·`011 금색`·`012 은색`), UV=`PROC_000002`, 박=`PROC_000033~049`. ※ 카운트 97/270은 v6.0(2026-06-17·CL 검증) 라이브 직접 SELECT 실측 — 이전 스냅샷 96/196은 stale(D-CL-3 정정). |
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

---

## XI. ★PR facet 갭 판정 — distinct 0·facet 강화 6항 (라이브 2026-06-17 실측·v4.0)

> PR이 발굴한 P-1~P-9는 **전부 facet(distinct 신축 0)** → 갭의 핵심 = "PR이 강화한 기존 축 facet들을 후니가 같은 표현력으로 담는가". 입력 directive 6항을 라이브 information_schema 직접 SELECT(read-only)로 판별. **신규 축 없음 = 신규 vessel-gap 없음**(전부 기존 §I~III 축 판정에 매핑·중복 계상 안 함).

### XI-0. 라이브 실측 결과 (psql read-only 2026-06-17 — PR facet 6항 직접 조회)

| 측정 | 라이브 결과 | facet |
|---|---|---|
| **USAGE base_codes** | `.01 내지·.02 표지·.03 면지·.04 간지·.05 투명커버·.06 표지타입·.07 공통` (7종) | P-2 표지/내지 |
| **product_materials usage_cd 분포** | `.01 내지=49·.02 표지=67·.03 면지=15·.05 투명커버=2·.07 공통=639` | P-2·P-5 — **표지/내지/면지 슬롯 실적재** |
| **접지/제본 공정 행** | 접지 19행(`PROC_000056 접지`·057~074 가로/세로/2~8단/병풍/롤/오시접지/미싱접지) + 오시(`PROC_000029`·`PROC_000090`) + 제본 9행(`PROC_000017~025` 중철/무선/PUR/트윈링/떡/하드커버무선·트윈링/레이플랫) | P-1 접지·P-4 제본 |
| **page_rules 엔티티** | 컬럼 = `prd_cd·page_min·page_max·page_incr·note·reg_dt·upd_dt` (11행 적재) | P-3 페이지수 |
| **price_components 제본비** | `COMP_BIND_MUSEON/JUNGCHEOL/PUR/TWINRING/SSABARI/HC_MUSEON/HC_TWINRING/CAL_*`(11행·`PRICE_TYPE.01` 단가) | P-4·P-5 가격 |
| **면지 자재 행** | USAGE.03 → `MAT_000001 화이트면지·002 블랙면지·003 그레이면지·004 인쇄면지`(PRD_000072/077/082 등 링크) | P-5 면지 bundle |
| **print-method/pricing_model 게이팅 컬럼** | `print_method`/`prn_mtd`/`allowed`/`pool`/`price_gbn`/`item_gbn`/`pricing_model` 전역 검색 **0건** | P-6·P-7 |
| **price_formulas frm_typ 컬럼** | `frm_cd·frm_nm·note·use_yn` — **frm_typ/model 컬럼 부재**(round-17 확증) | P-6 digital_price 라우팅 |
| **자재 평량 컬럼** | `t_mat_materials.weight`(numeric) **실재** — 단 자재 *단일 평량값*이지 RP `COV_MIN_WGT`(표지 최소)/`INN_MAX_WGT`(내지 최대) **제약쌍(min/max) 부재** | P-2 평량제약 |

### XI-1. PR facet 6항 판정 (입력 directive 1~6)

| # | PR facet (입력 directive) | 귀속 축(메타모델) | 판정 | 후니 t_* 실측 근거 | dbmap 교차 |
|---|---|---|:---:|---|---|
| **1** | **표지/내지 역할 슬롯 (usage_cd 자재 슬롯) + cover/inner 단가축 분리** | 자재#1 usage_cd (§I-1) | **PASS** ✅ | `USAGE.01 내지/.02 표지/.03 면지` enum 실재 + `t_prd_product_materials.usage_cd`로 표지(67)·내지(49) **실적재**. cover/inner 단가는 `t_prc_price_components`가 `comp_cd` 단위로 분리(제본비 11행=방식별 별 comp_cd가 그 증거 — 표지인쇄비/내지인쇄비도 동일 패턴으로 별 comp_cd) + `use_dims` jsonb. RP `inner_pdt_*` 평행 스키마 = usage 슬롯의 후니판 구현. | `entity-semantic-model:23` USAGE 7종·`:118` parent+usage_cd 권위 |
| **2** | **접지 공정 family + 접지↔오시 cascade + 면 분할 파생** | 공정#2 (§I-2) | **PASS** ✅ | 접지 19행(2~8단·병풍·롤·오시접지·미싱접지)·오시 2행 **공정 행 실재**. 면수(2단=4면)는 접지방식 파생값(DB 미저장·판걸이수 동형 정상). 접지↔오시 cascade는 제약#5(WEAK)로 표현. | round-22 ⑤공정·`dbmap-compute-in-app-db-stores-lookup`(파생값 앱계산) |
| **3** | **page_rule 엔티티 (INN_PAGE min/max/incr)** | 수량#10 + 제약#5 (§IX-B T-C) | **PASS** ✅ | `t_prd_product_page_rules` 컬럼 = `page_min·page_max·page_incr` — **메타모델 정밀 매핑 주장 라이브 확증**(INN_PAGE→page_rule 1:1). 11행 적재(TP 캘린더+PR 책자 공유 슬롯). breadth는 data-gap. | `entity-semantic-model:29` page_rule 엔티티·TP T-C 합류 |
| **4** | **인쇄방식 자재풀 게이팅 (윤전→YWM pool 등)** | 인쇄방식#12 → 자재#1 게이팅 (§III-12) | **GAP** ❌ | 인쇄방식이 **공정/자재/컬럼 어디에도 1급 그릇 없음** — `print_method`/`prn_mtd`/`allowed`/`pool` 컬럼 전역 0건. 윤전→YWM 자재풀 부분집합 게이팅(가능 자재 제약)을 표현할 PrintMethod 엔티티·allowed_material 관계 부재. **기존 #12 GAP과 동일**(신규 아님·P-7이 자재풀 게이팅 면을 *강화*했을 뿐). | §III-12·`dbmap-print-method-not-absolute-axis` |
| **5** | **digital_price 라우팅 (규격물 vs 면적물 가격엔진 분기)** | 가격#11 pricing_model 라우팅 (§III-11) | **WEAK** 🟡 | 가격 사슬(`price_formulas` 17·`component_prices` 3,416)은 PASS급이나 **pricing_model/frm_typ 라우팅 컬럼 부재**(`price_formulas`에 frm_typ/model 컬럼 없음·`price_gbn`/`item_gbn` 전역 0건). digital_price(규격/자유) vs 면적매트릭스 분기를 1급 라우팅키로 못 가짐 → 상품군별 암묵/앱 분기. **기존 #11 WEAK(frm_typ_cd 라이브 부재·round-17)과 동일.** | §III-11·`dbmap-price-formula-audit-round17`(frm_typ_cd 부재) |
| **6** | **제본 가공 BUNDLE (면지=자재+공정)** | 자재#1(usage.03)+공정#2 (§I-1·§I-2) | **PASS** ✅ | 면지 = `USAGE.03` 자재 행(MAT_000001~004 화이트/블랙/그레이/인쇄면지·실링크) + 제본/삽입 = 공정#2(`PROC_000017~025`) + 가격 = `COMP_BIND_*` 제본비 component. GS 제본 bundle(링=자재+꿰기=공정)·아일렛 동형 — **자재+공정 BUNDLE 패턴 무손실 표현**. | `entity-semantic-model:23` USAGE.03 면지·`dbmap-option-material-process-bundle` |

> **★결론(입력 6항 직답):** PR facet 6건 = **PASS 4 (#1·#2·#3·#6) · WEAK 1 (#5) · GAP 1 (#4)**. ① **표지/내지 역할 슬롯**(P-2)·**접지/제본 공정**(P-1·P-4)·**page_rule 엔티티**(P-3)·**면지 bundle**(P-5) = 후니가 **이미 같은 표현력 보유**(USAGE enum·접지 19행·page_min/max/incr·면지 자재행 전부 라이브 실재·일부 실적재). ② **digital_price 라우팅**(P-6) = `pricing_model`/`frm_typ` 라우팅키 부재 = **기존 #11 WEAK과 동일**(신규 아님). ③ **인쇄방식 자재풀 게이팅**(P-7) = PrintMethod 1급 그릇 부재 = **기존 #12 GAP과 동일**(신규 아님). **★핵심: PR이 distinct 신축 0이므로 신규 vessel-gap도 0 — WEAK/GAP 2건은 전부 기존 BN 판정(#11·#12)에 이미 잡힌 것을 PR facet이 재확인. PR이 더한 것은 새 그릇 수요가 아니라 *기존 그릇이 PR facet을 견딘다는 검증 신호*(PASS 4건이 16축 포화 입증).**

### XI-2. cover/inner 단가 분리 — 미묘점 (PASS 단서 + data-gap)

표지/내지 인쇄비 *분리*(RP F_CVR vs K_INN)는 후니 `price_components.comp_cd` 단위 분리로 표현 가능(제본비가 방식별 11 comp_cd로 분리된 것이 동형 증거). **단 라이브에 표지인쇄비/내지인쇄비 명명 component 행은 아직 없음**(book2025 책자 가격이 미적재·`COMP_BIND_*` 제본비만 적재) → **vessel은 PASS(comp_cd 무한 분리 가능·use_dims jsonb), 책자 cover/inner 인쇄비 행은 data-gap**(dbmap 가격 트랙·`_data-gaps-noted.md` §2 가격 사슬). vessel 신설 불요.

### XI-3. 평량 제약 (COV_MIN_WGT/INN_MAX_WGT) — 미묘점 (제약#5 WEAK 흡수)

RP의 "표지 최소평량 150·내지 최대평량 130" platform-weight 제약은 후니 `t_mat_materials.weight`(단일 평량값) 컬럼은 **실재**하나 **표지 최소/내지 최대를 한 상품에 거는 제약쌍(min/max)을 담을 그릇은 부재** → 현재 앱/암묵 또는 제약 룰로 표현해야. **별 vessel 아님 — 제약 축#5 WEAK(match/min-max 유형 미거버넌스)에 흡수**(V-4 RULE_TYPE 확장 시 같이 해소·코드행 경량). 단일 vessel 신설 불요.

---

## XII. v4.0 종합 카운트 (PR 통합 — 신규 축 0·카운트 불변)

| 판정 | 개수 | 축 | PR 영향 |
|---|---:|---|---|
| **PASS** | 5 | ②공정 · ③옵션 · ⑥기초코드 · ⑦카테고리 · ⑧부속물 (+ ①usage·④template_prices·⑬nonspec·T-C page_rules·T-E 특수인쇄 = PASS 측면) | **PR facet 4건이 PASS 측면 강화**(usage 표지/내지·접지/제본 공정·page_rules·면지 bundle) — 16축 포화 입증 |
| **WEAK** | 8 | ①자재(분해축) · ④템플릿 · ⑤제약 · ⑩수량모델 · ⑪가격기여역할 · ⑬사이즈 · #15 생산형태 · T-A 템플릿 자산 | **PR P-6(digital_price)이 ⑪에 재확인**·평량제약이 ⑤에 흡수 — 신규 WEAK 0 |
| **GAP** | 4 | ⑨공정파라미터 · ⑫인쇄방식레시피 · #14 본체형태가공 · #16 디자인 입력 채널 | **PR P-7(자재풀 게이팅)이 ⑫에 재확인**(인쇄방식 게이팅이 자재풀까지 확장) — 신규 GAP 0 |

- **PR 판정 요지:** distinct 신축 0 → **신규 PASS/WEAK/GAP 축 0**. PR facet 6항 = PASS 4·WEAK 1(기존 ⑪)·GAP 1(기존 ⑫). PR이 한 일 = ① PASS 4건으로 기존 그릇의 PR facet 견딤 **검증**(16축 포화) ② WEAK/GAP 2건이 기존 #11·#12에 이미 잡혔음 **재확인**(중복 계상 안 함).
- **PR이 추가하는 vessel-needs = 0건** — 전부 기존 V-항목(자재 §1·제약 V-4·가격 V-7·인쇄방식 V-2)에 흡수. PR 통합으로 vessel-needs 신규 항목 없음(BN/GS/TP V-1~V-11 불변).

> 모든 판정 양쪽 증거 보유(메타모델 P-항목 + 후니 t_* 라이브 실측·2026-06-17 read-only psql 직접 SELECT). **PR distinct 신축 0 = 신규 vessel-gap 0·dbmap 갭과 비충돌·기존 판정 전부 보존.**

---

## XIII. ★ST 신축 — 메타모델 #17 형상 축 (★16축 포화 붕괴·vessel-gap 신규) + ST facet 5항 (라이브 2026-06-17 실측·v5.0)

> directive 핵심 = **① 형상축 #17의 후니 그릇 부재(vessel-gap 1순위) 확정 + ② facet 5항 갭**. ST가 distinct 신축 1건(형상)으로 PR 16축 포화를 깸 → 17축. 형상 #17만 신규 vessel-gap, 나머지 9 fragment(S-2~S-10)는 기존 축 흡수. 라이브 information_schema 직접 SELECT(read-only)로 전건 판별.

### XIII-0. 라이브 실측 결과 (psql read-only 2026-06-17 — ST 6항 직접 조회)

| 측정 | 라이브 결과 | 함의 |
|---|---|---|
| **형상 컬럼**(`shape`/`shape_cd`/`shape_info`/`outline`/`cut_typ`/`die`/`form_typ`) 전 t_* 검색 | **0건**(매치 = `transforms.transform_type`·`t_prc_*formula*` 전부 false positive — 형상 무관) | ★**형상 전용 컬럼 부재 확정.** RP `option_info.shape_info`(SQ/CL/EL/RC/FR) 대응 슬롯 없음. |
| **형상 테이블**(`shape`/`form`/`outline`) 전역 | **0건**(매치 = price_formula 테이블·`transforms` — 형상 무관) | 형상 전용 standalone 엔티티 부재. |
| **base_code 16 부모 그룹** | `MAT_TYPE·USAGE·SEL_TYPE·RULE_TYPE·OPT_REF_DIM·OUTPUT_PAPER_TYPE·PRC_*·QTY_UNIT·PRD_TYPE·SEMI_ROLE·CUS_GRADE·DSC_TYPE·TEST*` | ★**SHAPE/형상 enum 그룹 부재** — 형상 코드값(SQ/CL/EL/RC/FR)을 분류할 코드 도메인조차 없음. KB G-SK-2 "어느 축에도 없음"을 base_code 레벨로 확증. |
| **칼선/재단 공정**(완칼/반칼/스티커완칼/도무송) | `PROC_000053 완칼`(Die Cut 종이+후지)·`PROC_000054 반칼`(Kiss Cut 종이만 스티커)·`PROC_000055 스티커완칼`(Die Cut+조각수)·`087 반칼`·`091 완칼`·`094 스티커완칼` **실재** / **도무송·자유모양커팅 별 row 0건** | ★재단입자(반칼/완칼)=**공정 멤버 라이브 실재**(S-3 PASS). 단 **자유칼선(THO_GRA 도무송) 전용 process row 부재** — 자유칼선은 완칼+모양 파라미터로 환원되나 그 모양 파라미터 슬롯이 #9 공정파라미터 GAP. |
| **자재 점착/내후 컬럼**(`adhesion`/`weather`/`grade`) 전 t_* | `t_mat_materials`=`mat_cd·mat_nm·mat_typ_cd·upr_mat_cd·sel_typ_cd·max_sel_cnt·width·height·depth·weight·bdl_qty·...` (점착/내후 컬럼 **0건**·grade 매치=고객/할인 등급 false positive) | ★점착강도/내후등급 분해 컬럼 부재 = 기존 #1 자재 분해축 vessel-gap과 **동일**(S-4가 새 면 아님). |
| **MAT_TYPE 14종 + 분포** | `.11 스티커용지`(16행)=**ST 전용 클린 버킷 존재** / `.08 실사소재`17·`.09 파우치`69·`.10 악세사리`43=**상품군명 버킷 오염 여전**(round-22 B-3 미적용) | ★ST 자재는 `.11 스티커용지`로 깨끗이 분리됨(파우치 .09 오염과 대조) — ST 점착 spectrum은 .11 안의 mat_nm 평면 문자열로 융합(분해축 부재). |
| **제약 vessel + RULE_TYPE** | `t_prd_product_constraints`=`logic` jsonb(JSONLogic)·`disp_seq`·`err_msg` 보유·**10행**(RULE_TYPE.01 호환=7·.02 금지=2·.03 필수동반=1) / RULE_TYPE **3종만** | ★disable 전용 논리유형 부재 = 기존 #5 제약 WEAK과 **동일**. S-8 227건 룰엔진은 logic jsonb로 *담길 수 있으나*(스케일 OK) 라이브 10행만 적재(data-gap)·disable 유형 미거버넌스. |

### XIII-1. ★판정 — #17 형상 축 = GAP ❌ (vessel-gap·신규·1순위)

| 면 | 증거 |
|---|---|
| **RP 표현력** | `Shape`(shape_info enum SQ/CL/EL/RC/FR·전용 슬롯) — 형상이 ① 칼틀 enum 부분집합 게이팅(CL→CL001~100) ② 자유형(FR)→자유칼선 강제 ③ 사이즈 입력모드 게이팅·형상↔사이즈 1:多·5형상 superset(STDCFBR). (dictionary §17·D-12) |
| **후니 현황** | 라이브 information_schema 실측: 형상 전용 **컬럼 0건·테이블 0건·base_code SHAPE enum 0건**(전 검색 false positive만). `t_siz_sizes`(497행)는 "재단치수"(width×height)이지 형상(원/사각) 분류 슬롯 아님. KB G-SK-2 "도형/치수 enum(원형 25~90mm)이 어느 축에도 없음" = **라이브 3-레벨(컬럼/테이블/enum) 모두 확증.** |
| **판정** | **GAP** — RP의 "형상을 사이즈와 분리된 전용 enum 슬롯으로 관리·칼틀/사이즈 게이팅"을 후니 스키마가 **표현 못함.** 형상은 현재 ① 상품명/note에만 (원형 스티커·사각라운드) ② 칼틀/사이즈 행에 *암묵 흡수*(1:多인데 1:1 흡수 강제 시 "원형이라는 사실"을 매 칼틀 프리셋에 중복 인코딩=정규화 붕괴). 형상 enum·형상→칼틀 게이팅·자유형→자유칼선 강제를 담을 그릇 **전무**. **vessel-gap(신규)**·빈 테이블 아님. **★단 [HARD] 1:1 흡수 카테고리(BN 어깨띠·GS 하트·TP 티켓·PR 카드형)는 사이즈 프리셋 유지** — 형상축은 ST처럼 1:多 분리가 명시 슬롯으로 드러난 곳에만 별 슬롯(형상축 전면 강제 = 오모델 회피). |
| **dbmap 교차참조** | **dbmap이 형상을 *결함으로 명시*했으나 그릇은 미신설**: `07_domain/entity-semantic-model.md:39` G-SK-2 "size축에 형상 enum drop·어느 축에도 없음" + round-3 "도무송 형상=siz_cd 신설 컨펌"(`dbmap-round3-mapping-audit`). dbmap은 형상을 *siz_cd 신설*(사이즈 흡수)로 닫으려 했으나 — **ST 1:多 증거는 siz 흡수가 정규화 붕괴임을 보임** → 형상 *전용* 그릇이 정답(dbmap siz 흡수 권고를 ST가 정정). **재발견 아님·dbmap 진단(G-SK-2) 위에 정밀화 = 신규 vessel-gap.** = `vessel-needs.md` **V-12**(P1·V-10/V-3과 나란한 최우선). |

> **★결론(directive ① 직답 — 형상축 #17 후니 그릇 부재 확정):** **#17 형상 축 = GAP(vessel-gap·신규).** 라이브 information_schema 3-레벨 실측이 KB G-SK-2를 전건 확증 — ① 형상 전용 **컬럼 0건**(t_* 전 테이블·shape/outline/die/form_typ 매치 전부 false positive) ② 형상 전용 **테이블 0건** ③ base_code 16그룹에 **SHAPE/형상 enum 부재**(코드값 도메인조차 없음). 후니는 형상을 상품명/note 또는 칼틀·사이즈 행에 암묵 흡수만 — RP `shape_info`(전용 슬롯·1:多 칼틀 게이팅·5형상 superset)를 **전혀 담지 못함.** dbmap이 G-SK-2로 결함은 명시했으나 그릇은 미신설(round-3는 siz_cd 흡수 권고 — ST 1:多 증거가 그 흡수를 정정·전용 그릇 필요). → **형상 그릇 설계가 vessel 신규 최우선 V-12**(단 1:1 흡수 카테고리는 size 유지·전면 강제 금지).

### XIII-2. ST facet 5항 판정 (directive ② — facet 강화분 갭)

| # | ST facet (directive) | 귀속 축(메타모델) | 판정 | 후니 t_* 실측 근거 | dbmap 교차 |
|---|---|---|:---:|---|---|
| **2** | **칼선 2메커니즘**(THO_GRA 자유/THO_DFT 프리셋칼틀) | 공정#2 family + 사이즈#13 (§I-2) | **PASS(부분)** ✅ / 자유칼선만 미세 | 프리셋칼틀=완칼/반칼 공정 **라이브 실재**(PROC_000053/054/055). 프리셋칼틀이 사이즈 겸함=공정#2+#13 cascade. **단 자유칼선(THO_GRA 도무송) 전용 process row 부재** — 자유칼선은 PROC_000053(완칼)+모양 파라미터로 환원(모양 파라미터 슬롯=#9 공정파라미터 GAP에 의존). 형상=FR→자유칼선 강제는 #17 형상↔칼선 게이팅(V-12)이 담당. | round-3 "도무송 형상=siz_cd"·`pdf-domain-knowledge.md:113-115`(완칼/반칼/스티커완칼 공정) |
| **3** | **재단입자**(반칼 PROC_000054/완칼 053/스티커완칼 055) | 공정#2 멤버 (§I-2) | **PASS** ✅ | **라이브 직접 확인: PROC_000053 완칼**(Die Cut 종이+후지)·**PROC_000054 반칼**(Kiss Cut 종이만 스티커)·**PROC_000055 스티커완칼**(Die Cut+조각수) — 메타모델 주장 **전건 실재**(+087/091/094 중복행). 묶음재단(반칼시트)/개별재단(완칼낱장)=공정 멤버+배치 facet. 후니가 이미 1급 공정 멤버화 = **무손실 표현.** | `pdf-domain-knowledge.md:71`(Case2 스티커=반칼/완칼 분기)·`:113-114`(PROC_054/053) |
| **4** | **점착/내후 소재 차원**(adhesion_grade/weather_grade) | 자재#1 합성 분해축 (§I-1) | **WEAK** 🟡 (기존 #1과 동일) | `t_mat_materials`에 **점착강도/내후등급 분해 컬럼 부재**(`width/height/depth/weight/bdl_qty`만·adhesion/weather 0건). 강접/리무버블/옥외/저온/자석/메탈/한지가 `.11 스티커용지`(16행) 안의 `mat_nm` 평면 문자열로 융합 → 색상/두께 동형 분해축 갭. **기존 §I-1 자재 분해축 WEAK과 동일 면**(S-4가 새 vessel 아님·#1에 점착/내후 차원 추가로 흡수). ※ ST 자재는 `.11` 클린 버킷이라 파우치 .09 오염과 달리 *오라벨 아님* — 순수 분해축 부재만. | `dbmap-material-option-normalization`(합성 분해축)·round-22 ④자재 |
| **5** | **인쇄방식 분기**(일반/UV/DTF/후지) | 인쇄방식레시피#12 (§III-12) | **GAP** ❌ (기존 #12와 동일) | 인쇄방식이 **공정/자재/컬럼 1급 그릇 없음**(`print_method`/`prn_mtd`/`pool` 전역 0건·§XI-1 재확인). UV=`PROC_000002` 변형으로 공정 행 존재하나 DTF/후지는 미상·"인쇄방식→자재(DTF필름)/도수숨김/화이트강제/가격엔진 게이팅" lifecycle 그릇 부재. **PR P-4/P-7과 동일 #12 GAP**(ST가 UV/DTF/후지로 *횡단 합류*했을 뿐·신규 아님). | §III-12·§XI-1(P-7)·`dbmap-print-method-not-absolute-axis` |
| **6** | **disable 227건 룰엔진** | 제약#5 disable (§I-5) | **WEAK** 🟡 (기존 #5와 동일) | `t_prd_product_constraints.logic` jsonb(JSONLogic) = **227건 스케일 담을 수 있음**(그릇 PASS급). 단 ① RULE_TYPE **3종만**(호환/금지/필수동반)·**disable 전용 유형 부재**(자재→공정 비활성을 금지로 환원 시 의미축 일부 보존되나 disable 의미 명시 못함) ② 라이브 **10행만** 적재(data-gap). **기존 §I-5 제약 WEAK과 동일**(S-8은 BN 강제·PR 24건의 *정점 케이스*로 룰엔진 스케일을 검증 — 그릇은 견딤·유형 거버넌스만 미달). | `dbmap-cpq-option-mapping`(캐스케이드→JSONLogic)·`dbmap-live-admin-product-viewer`(logic NOT NULL) |

> **★결론(directive ② 직답 — facet 5항 PASS/WEAK/GAP 분포):** **PASS 1(재단입자 S-3) · WEAK 2(점착소재 S-4·disable 룰엔진 S-8) · GAP 1(인쇄방식 S-5) · 부분PASS 1(칼선 S-2).** ① **재단입자**(S-3)=PROC_053/054/055 라이브 실재로 **무손실 PASS**(메타모델 주장 전건 확인). ② **칼선 2메커니즘**(S-2)=프리셋칼틀(완칼/반칼)은 공정#2 PASS·자유칼선(도무송)만 전용 row 부재(완칼+모양 파라미터 #9 GAP 의존·형상→칼선 게이팅 V-12). ③ **점착/내후**(S-4)=기존 #1 자재 분해축 **WEAK**과 동일(신규 vessel 아님·ST 자재는 .11 클린 버킷). ④ **disable 룰엔진**(S-8)=기존 #5 제약 **WEAK**과 동일(logic jsonb 스케일 OK·RULE_TYPE disable 유형 미달·10행 data-gap). ⑤ **인쇄방식**(S-5)=기존 #12 **GAP**과 동일(PR P-4/P-7 횡단 합류·신규 아님). **★핵심: facet 5항 중 신규 vessel-gap 0 — 전부 기존 §I~III 축 판정(#1·#2·#5·#12)에 흡수. ST가 더한 신규 vessel-gap은 형상축 #17 단 1건.**

### XIII-3. 형상↔칼선 게이팅 — 미묘점 (V-12 설계 포인트)

ST의 형상은 칼선 메커니즘을 *게이팅*(FR→자유칼선·SQ/CL/RC→프리셋칼틀)한다. 라이브 칼선 공정은 완칼(053)/반칼(054)/스티커완칼(055)만 존재하고 **자유칼선(도무송) 전용 row가 없다** → 자유형(FR) 형상은 "완칼 + 자유 모양 파라미터"로 환원되어야 하나 *그 모양 파라미터 슬롯*(완칼 PROC_053의 `모양` 인자)이 **공정파라미터 #9 GAP**에 걸린다. 즉 형상축(V-12)은 단독 enum이 아니라 **형상→칼틀 게이팅(칼틀 프리셋 부분집합 결정) + 형상=FR→완칼 모양 파라미터 활성**의 관계 그릇이어야 함 — designer가 V-12 설계 시 #9(공정파라미터 ref_param_json)·#13(사이즈 칼틀 프리셋)과의 게이팅 간선을 함께 고려(형상은 #13·#2·#9를 잇는 분류자). **단 1:1 흡수 카테고리는 형상→사이즈 프리셋 1:1로 충분**(형상 enum 슬롯 없이 칼틀=사이즈 행이 형상 암묵 보유).

---

## XIV. v5.0 종합 카운트 (BN 13 + GS 신축 2 + TP 신축 1 + ST 신축 1 = 17축)

| 판정 | 개수 | 축 | ST 영향 |
|---|---:|---|---|
| **PASS** | 5 | ②공정 · ③옵션 · ⑥기초코드 · ⑦카테고리 · ⑧부속물 (+ ①usage·④template_prices·⑬nonspec·T-C page_rules·T-E 특수인쇄·**S-3 재단입자 PROC_053/054/055** = PASS 측면) | **ST facet 재단입자(S-3)가 ②공정 PASS 측면 강화**(완칼/반칼/스티커완칼 라이브 실재) |
| **WEAK** | 8 | ①자재(분해축·**S-4 점착/내후**) · ④템플릿 · ⑤제약(**S-8 disable 227 정점**) · ⑩수량모델 · ⑪가격기여역할(**S-6 가격엔진**) · ⑬사이즈(**S-2 프리셋칼틀**) · #15 생산형태 · T-A 템플릿 자산 | **S-4가 ①에·S-8이 ⑤에·S-6이 ⑪에 재확인** — 신규 WEAK 0 |
| **GAP** | 5 | ⑨공정파라미터 · ⑫인쇄방식레시피(**S-5 UV/DTF/후지 합류**) · #14 본체형태가공 · #16 디자인 입력 채널 · **#17 형상(신규·★vessel-gap 1순위)** | **S-5가 ⑫에 재확인 + ★#17 형상 신규 GAP 1건** |

- **ST 신축 판정:** **#17 형상 = GAP**(★vessel-gap 신규·1순위·라이브 3-레벨 확정). ST facet 5항 = PASS 1(S-3 재단입자)·WEAK 2(S-4 점착=기존#1·S-8 disable=기존#5)·GAP 1(S-5 인쇄방식=기존#12)·부분PASS 1(S-2 칼선=공정#2·자유칼선만 #9 의존).
- **형상축(directive 핵심):** **vessel-gap**(데이터 미적재 아님) — 형상 컬럼/테이블/base_code enum 3-레벨 전무·dbmap G-SK-2 명시 위 정밀화(round-3 siz 흡수 권고를 1:多 증거로 정정). = `vessel-needs.md` V-12(P1·신규).
- **ST가 BN/GS/TP/PR 정정 안 함:** ST는 형상을 1:多로 분리한 *신축*이라 기존 1:1 흡수 카테고리 판정 불변(보존). S-3 재단입자는 기존 공정#2 PASS 측면 강화·신규 갭 아님.
- **포화 붕괴 정직성:** PR(distinct 0·16축 포화 입증)을 ST가 정직하게 깸 — 단 형상축은 1:多 분리가 명시 슬롯으로 드러난 ST에서만 distinct, 1:1 흡수 카테고리(BN/GS/TP/PR)는 사이즈 프리셋 유지. 모델은 증거에 정직(포화도 진화도 증거가 결정).

> 모든 판정 양쪽 증거 보유(메타모델 S-항목 + 후니 t_* 라이브 실측·2026-06-17 read-only psql 직접 SELECT — 형상 3-레벨·칼선 PROC·자재 컬럼·제약 RULE_TYPE·MAT_TYPE 분포 전건 실측). **ST distinct 신축 1(형상 #17)=신규 vessel-gap 1·facet 5항 신규 vessel-gap 0(기존 #1/#2/#5/#12 흡수)·dbmap G-SK-2 위 정밀화(중복 아님).**

---

## XV. ★CL facet 갭 판정 — distinct 0(의류 variant #18 부결)·facet 강화 5항 (라이브 2026-06-17 실측·v6.0)

> CL이 발굴한 C-1~C-9는 **전부 facet(distinct 신축 0·★의류 variant #18 부결)** → 갭의 핵심 = "CL이 강화한 facet들을 후니가 같은 표현력으로 담는가"(PR 패턴 반복). 입력 directive 5항을 라이브 information_schema 직접 SELECT(read-only)로 판별. **신규 축 없음 = 신규 vessel-gap 없음**(전부 기존 §I~§XIV 축 판정에 매핑·중복 계상 안 함).

### XV-0. 라이브 실측 결과 (psql read-only 2026-06-17 — CL facet 5항 직접 조회)

| 측정 | 라이브 결과 | facet |
|---|---|---|
| **OPT_REF_DIM 도메인** | `.01 사이즈·.02 판형·.03 자재·.04 공정·.05 묶음수·.06 도수·.07 셋트` (7종) — **색상(color) 전용 ref 타입 부재** | C-2/C-3 색상→자재 라우팅 |
| **option_items 2D 페어링** | `t_prd_product_option_items` = `prd_cd·opt_cd·item_seq·ref_dim_cd·**ref_key1·ref_key2**·qty·use_yn` / **ref_key2 사용 255/469행**(라이브 활성) | C-2/C-3 size×color 2D 셀 — **2D 페어링 그릇 보유·활성** |
| **option_items ref_dim_cd 분포** | `.03 자재=255·.04 공정=156·.06 도수=45·.01 사이즈=11·.07 셋트=2` — 자재(.03)가 ref_key2와 함께 dominant | C-2/C-3 자재 SKU + 2D |
| **t_prd_product_processes 컬럼·PK** | 컬럼=`prd_cd·proc_cd·mand_proc_yn·disp_seq` / **PK=(prd_cd,proc_cd)·위치(position/slot) 컬럼 0건** | C-4 인쇄위치 멀티슬롯 — **공정행으론 위치반복 불가** |
| **SEL_TYPE** | `.01 단일·.02 다중` — 다중선택 그릇 존재 | C-4 인쇄위치 다중선택 |
| **별색 공정 family** | `PROC_000007 별색인쇄·008 화이트·009 클리어·010 핑크·011 금색·012 은색` 라이브 실재 | C-7 Pantone 별색 |
| **색상/Pantone enum** | 색/color/pantone 코드값 도메인 **0건**(독립 색상 enum 부재) | C-2/C-3/C-7 색상 거버넌스 |
| **MAT_TYPE 14종** | `.01 디지털인쇄용지·…·.06 가죽·.08 실사소재·.09 파우치·.10 악세사리·.11 스티커용지·.12 사입자재·.13 합판스티커·.14 합판봉투` — **의류/티셔츠/원단(apparel fabric) 전용 버킷 부재** | C-2/C-3 의류 본체 원단 |
| **PRD_TYPE** | `.01 완제품·.02 반제품·.03 기성·.04 디자인·.05 추가` (5종·§V-15 동일) | C-5 item_gbn=생산형태 |

### XV-1. CL facet 5항 판정 (입력 directive 1~5)

| # | CL facet (입력 directive) | 귀속 축(메타모델) | 판정 | 후니 t_* 실측 근거 | dbmap 교차 |
|---|---|---|:---:|---|---|
| **1** | **size×color 2D 매트릭스 (자재#1 SKU matrix + 제약#5 셀가용성)** | 자재#1 + 사이즈#13 + 색상[자재CLR] + 제약#5 (§I-1·§I-5·§I-13) | **WEAK** 🟡 (기존 #1·#5와 동일·★2D 페어링 그릇은 보유) | ★**2D 셀 표현 그릇 보유**: `option_items.ref_key1`(사이즈)+`ref_key2`(자재/색) 2D 페어링이 라이브 **활성**(255/469행 ref_key2 사용)·셀가용성=`use_yn`. GS variant SKU(G-1)·ST disable 227(제약#5 정점·S-8)과 동형으로 후니가 **2D 매트릭스를 표현 가능**(item_seq×use_yn=셀단위). 단 ① **색상 전용 ref 타입 부재**(OPT_REF_DIM 7종에 color 없음)→색상은 자재 CLR로 라우팅하는데 **자재 분해축(CLR) 컬럼 부재**(§I-1 WEAK·V-3) ② **의류 원단 MAT_TYPE 버킷 부재**(14종에 apparel fabric 없음)→자체 SXSRT/브랜드 SXZSB 본체 SKU가 깨끗한 자재유형 버킷 없음. **★종합 판정 = WEAK**(두 면 분리: ⓐ 2D *구조*[cardinality·셀가용성 정점]는 그릇이 견딤 = 결손 아님 ⓑ 자재 CLR *분해축*은 부재 = 기존 #1 WEAK·V-3. WEAK 사유는 ⓑ뿐·ⓐ는 견딤). | §I-1·§IV(굿즈 본체자재)·`dbmap-material-option-normalization`(색상 variant→material)·round-22 ④자재 |
| **2** | **인쇄위치 멀티슬롯 (공정#2 + #11 + #16)** | 공정#2 멀티슬롯 + 가격#11 + 입력채널#16 (§I-2·§III-11·§VIII) | **WEAK** 🟡 (기존 #2/#9에 흡수·★공정행 멀티슬롯은 부재·옵션 경유는 보유) | ★**공정 행으론 멀티슬롯 불가**: `t_prd_product_processes` PK=(prd_cd,proc_cd)·위치 컬럼 0건 → 한 상품이 같은 인쇄 공정을 6위치(앞/뒤/소매…)로 *반복* 보유 못함. **단 그릇은 우회로 보유**: option_groups(`SEL_TYPE.02 다중`)→option_items(`ref_dim_cd=공정.04`·`ref_key2`로 위치 페어링·156행 .04 라이브)로 다중위치 선택 표현 가능. 위치별 가격 가산(PDT_WRK PRICE)은 component_prices 차원(가격 사슬). KOI_NME 에디터 매핑(#16)=디자인입력 채널 GAP에 종속(§VIII V-10). 위치별 공정 파라미터(앞면 size·소매 위치)는 **#9 공정파라미터 GAP**(ref_param_json 부재)에 의존. **공정#2 본체 그릇은 옵션 경유 표현 가능(WEAK)·위치 파라미터=기존 #9 GAP·에디터 매핑=#16 GAP.** | §I-2·§II-9·§VIII·round-22 ⑤공정 |
| **3** | **인쇄방식 (실크/전사/DTF) (#12)** | 인쇄방식레시피#12 (§III-12) | **GAP** ❌ (기존 #12와 동일·PR/ST 합류) | 인쇄방식이 **공정/자재/컬럼 1급 그릇 없음**(`print_method`/`prn_mtd`/`pool`/`item_gbn` 전역 0건·§XI-1/§XIII-2 재확인). PTP_DTF(DTF 열전사)·PTP_DIR(직접인쇄)·PTP_SLK(실크/날염)이 *상품내 옵션*(ORD_INFO.PRINT_TYPE)으로 인코딩되나 — 후니에 "인쇄방식→가능 자재(DTF필름)/도수노출/화이트강제/Pantone활성/가격엔진 게이팅" lifecycle 그릇 부재. **PR P-4/P-7·ST S-5와 동일 #12 GAP**(CL이 의류 인쇄방식[실크/전사/DTF]으로 *횡단 합류*했을 뿐·신규 아님). ★CL이 더한 면: 인쇄방식의 *삼면 표현*(BN=자재facet·ST/PR=상품분기·CL=상품내 옵션) — #12 lifecycle 동일. | §III-12·§XI-1(P-7)·§XIII-2(S-5)·`dbmap-print-method-not-absolute-axis` |
| **4** | **Pantone 별색 (공정#2 별색)** | 공정#2 별색 family (§I-2) | **PASS** ✅ | ★**별색=공정 family 라이브 실재**: `PROC_000007 별색인쇄`·`PROC_000008 화이트`·`009 클리어`·`011 금색`·`012 은색`. Pantone 지정(실크인쇄 PTP_SLK spot color)을 **별색 공정으로 표현 가능**(ST/PR 별색·후니 PROC_000007 동일 그릇·별색=공정 round-22 경계 준수). **단 1124 PANTONE C 규모의 *색값 도메인*(어느 Pantone인지)을 담을 색상 enum은 부재**(색/pantone 코드값 0건) → 별색 *공정*은 PASS·별색 *지정값*(어떤 팬톤색)은 기초코드#6 별색 도메인 enum 거버넌스 미비(V-13 후보·경량). **축=공정#2 PASS·1124 규모는 #6 enum 도메인.** | §I-2·§I-6·round-22 별색=공정·`dbmap-axis-staged-load-round22` |
| **5** | **item_gbn=clothes2025 discriminator** | 생산형태#15 + 구현 discriminator (§V-15) | **WEAK** 🟡 (기존 #15와 동일) | item_gbn(clothes2025 vs tmpl)이 *본체 정체→가격/옵션 패러다임 결정* = 생산형태#15 governing(C 완제품 의류 SKU vs 굿즈형). 라이브 `PRD_TYPE` enum 5종 존재하나 **§V-15와 동일 WEAK**: prd_typ_cd가 body_model governing(자재행 vs 완제SKU 분기)을 안 함·item_gbn 같은 *구현 discriminator*(어느 가격 SP/옵션 skin 분기 키) 컬럼 부재. 의류는 PRD_TYPE.03(기성) 또는 신규 분류 필요 — RP item_gbn 3분기(clothes2025/tmpl/vTmpl)를 담을 discriminator 그릇 부족. **기존 #15 생산형태 WEAK과 동일**(CL이 "동일 카테고리 내 생산형태 분기"로 재확인·신규 아님·구현 discriminator라 vessel-gap 아님). | §V-15·`dbmap-grid-binding-round15`(prd_typ_cd≠생산형태) |

> **★결론(입력 5항 직답):** CL facet 5건 = **PASS 1 (#4 Pantone 별색) · WEAK 3 (#1 size×color 2D·#2 인쇄위치 멀티슬롯·#5 item_gbn) · GAP 1 (#3 인쇄방식)**. ① **Pantone 별색**(C-7)=`PROC_000007` 별색 공정 family **라이브 실재**로 후니가 **같은 표현력 보유**(별색=공정 경계 준수·1124 색값 도메인만 #6 enum 미비). ② **size×color 2D matrix**(C-2/C-3)=★`option_items.ref_key1/ref_key2` 2D 페어링이 라이브 **활성**(255/469)으로 **2D 셀·셀가용성 표현 그릇 보유**(GS SKU·ST disable 정점 동형)·자재 CLR 분해축만 기존 #1 WEAK(V-3). ③ **인쇄위치 멀티슬롯**(C-4)=공정 행으론 위치반복 불가(PK 제약)·단 option(다중)→option_items(공정.04) 경유로 표현 가능=기존 #2/#9 흡수. ④ **item_gbn**(C-5)=기존 #15 생산형태 WEAK과 동일. ⑤ **인쇄방식 실크/전사/DTF**(C-6)=PrintMethod 1급 그릇 부재 = **기존 #12 GAP과 동일**(PR/ST 횡단 합류). **★핵심: CL이 distinct 신축 0(의류 variant #18 부결)이므로 신규 vessel-gap도 0 — WEAK 3·GAP 1은 전부 기존 판정(#1·#2·#9·#12·#15)에 이미 잡힌 것을 CL facet이 재확인. CL이 더한 것은 새 그릇 수요가 아니라 *기존 그릇이 CL facet을 견딘다는 검증 신호*(PASS 1·옵션 2D 페어링 활성=17축 포화 재입증·PR 패턴 반복).**

### XV-2. size×color 2D 셀가용성 — 미묘점 (★종합 판정 WEAK·두 면 분리)

> [라벨 명확화·D-CL-2] 본 facet의 **종합 판정 = WEAK**. "그릇 견딤"은 *2D 구조*에 한정된 면이지 facet 전체 판정이 아님 — PASS가 아니다. 아래 두 면을 명시 분리:
> - **면 ⓐ — 2D *구조*(cardinality·셀가용성): 그릇 견딤(결손 아님)**. PASS *측면*이라 부르되 facet 판정은 아님.
> - **면 ⓑ — 자재 CLR *분해축*/원단 버킷: 부재(결손) → 이 결손 때문에 종합 = WEAK.**

CL size×color 매트릭스(자체 227셀·단체 54셀)는 후니 `option_items`의 **2D 페어링으로 무손실 표현 가능**: `ref_key1`=사이즈(SIZ)·`ref_key2`=자재/색(MAT)·`item_seq`=셀·`use_yn`=셀가용성(HIDE_YN 대응). 라이브 ref_key2 **255/469 활성**이 이 패턴이 *이미 작동 중*임을 입증(자재 .03 옵션이 dominant=2D) = **면 ⓐ 그릇 견딤**. **그러나 두 결손(면 ⓑ)이 종합 WEAK 사유**: ① 색상이 OPT_REF_DIM 7종에 **별 ref 타입 없음**→색상을 자재(.03 CLR)로 라우팅해야 하나 자재 분해축(CLR 컬럼)이 §I-1 WEAK(V-3) ② 의류 원단이 MAT_TYPE 14종에 **전용 버킷 없음**(.09 파우치/.10 악세사리는 상품군명 오라벨) → 자체 SXSRT/브랜드 SXZSB 본체 SKU가 깨끗한 자재유형 버킷 부재(V-3 굿즈 분해축과 동근). **★종합 = WEAK**(면 ⓑ 분해축/버킷 결손 = 기존 #1 WEAK·V-3에 흡수·신규 vessel 불요)·면 ⓐ는 결손 아님(그릇 보유).

### XV-3. 인쇄위치 멀티슬롯 — 미묘점 (공정행 PK 한계 + 옵션 경유 표현)

CL 인쇄위치 6슬롯(앞/뒤/소매…·각 PDT_WRK 가산)은 `t_prd_product_processes`(PK=(prd_cd,proc_cd))로는 **같은 인쇄 공정을 위치별로 반복 보유 못함**(위치 컬럼 0건). 그러나 후니는 이를 **option 레이어로 우회 표현**: option_groups(`SEL_TYPE.02 다중`)→option_items(`ref_dim_cd=공정.04`·라이브 156행·`ref_key2`로 위치 페어링)로 "여러 위치 다중선택"을 담을 수 있음. 위치별 인쇄비 가산은 component_prices(가격 사슬). **단 위치별 공정 파라미터**(앞면 인쇄영역 size·소매 위치 좌표·KOI_NME 에디터 매핑)는 #9 공정파라미터 GAP(ref_param_json 부재)·#16 디자인입력 채널 GAP에 의존. **본체 멀티슬롯 선택=그릇 보유(옵션 경유 WEAK)·위치 파라미터=기존 #9 GAP·에디터 매핑=#16 GAP — 전부 기존 판정 흡수·신규 vessel 불요.**

---

## XVI. v6.0 종합 카운트 (CL 통합 — 신규 축 0·카운트 불변·17축 재포화)

| 판정 | 개수 | 축 | CL 영향 |
|---|---:|---|---|
| **PASS** | 5 | ②공정 · ③옵션 · ⑥기초코드 · ⑦카테고리 · ⑧부속물 (+ ①usage·④template_prices·⑬nonspec·T-C page_rules·T-E 특수인쇄·S-3 재단입자·**C-7 Pantone 별색 PROC_000007 family** = PASS 측면) | **CL facet Pantone 별색(C-4/C-7)이 ②공정 PASS 측면 강화**(별색=공정 라이브 실재)·★option_items 2D 페어링(ref_key2 255/469) 활성이 ③옵션 PASS 측면 강화 — 17축 포화 재입증 |
| **WEAK** | 8 | ①자재(분해축·**C-2/C-3 size×color 2D·자재CLR**) · ④템플릿 · ⑤제약(**C-2/C-3 2D 셀가용성**) · ⑩수량모델(**C-6 이중수량**) · ⑪가격기여역할 · ⑬사이즈 · #15 생산형태(**C-5 item_gbn**) · T-A 템플릿 자산 | **C-1/C-3이 ①에·2D 셀가용성이 ⑤에·item_gbn이 #15에 재확인** — 신규 WEAK 0(인쇄위치 멀티슬롯 C-4=②/#9 흡수) |
| **GAP** | 5 | ⑨공정파라미터(**C-4 위치 파라미터**) · ⑫인쇄방식레시피(**C-6 실크/전사/DTF 합류**) · #14 본체형태가공 · #16 디자인 입력 채널(**C-4 KOI_NME 에디터 매핑**) · #17 형상 | **C-6이 ⑫에·C-4 위치 파라미터가 ⑨에·KOI_NME가 #16에 재확인** — 신규 GAP 0 |

- **CL 판정 요지:** distinct 신축 0(의류 variant #18 부결) → **신규 PASS/WEAK/GAP 축 0**. CL facet 5항 = PASS 1(#4 Pantone)·WEAK 3(#1 size×color=기존 #1/#5·#2 인쇄위치=기존 #2/#9·#5 item_gbn=기존 #15)·GAP 1(#3 인쇄방식=기존 #12). CL이 한 일 = ① PASS 1·option_items 2D 페어링 활성(255/469)으로 기존 그릇의 CL facet 견딤 **검증**(17축 포화 재입증·PR 패턴 반복) ② WEAK/GAP 4건이 기존 #1·#2·#9·#12·#15에 이미 잡혔음 **재확인**(중복 계상 안 함).
- **CL이 추가하는 vessel-needs = 0건** — 전부 기존 V-항목(자재 V-3·공정파라미터 V-1·인쇄방식 V-2·생산형태 V-9·디자인입력 V-10)에 흡수. CL 통합으로 vessel-needs 신규 항목 없음(BN/GS/TP/PR/ST V-1~V-12 불변).
- **CL이 BN/GS/TP/PR/ST 정정 안 함:** CL은 의류 variant를 GS variant(G-4)의 2D 일반화 facet으로 흡수한 *재포화*라 기존 판정 불변(보존). C-4 Pantone 별색은 기존 공정#2 PASS 측면 강화·신규 갭 아님.
- **재포화 정직성:** ST(distinct 1·17축)에 이어 CL이 **6번째 카테고리 distinct 0**(PR 4번째 distinct 0 패턴 반복) — 모델 안정성 재확인. 의류 variant가 가장 distinct로 *보이는* 이유(전용 clothes2025·apparel_info·size×color 2D·Pantone 1124)가 전부 *구현 표현*(discriminator/컨테이너/Cartesian+셀가용성/별색 공정)이지 *관리 축*이 아님이 라이브로 확증.

> 모든 판정 양쪽 증거 보유(메타모델 C-항목 + 후니 t_* 라이브 실측·2026-06-17 read-only psql 직접 SELECT — OPT_REF_DIM 7종·option_items ref_key1/2 2D 페어링 255/469·product_processes PK(prd_cd,proc_cd)·별색 PROC_000007 family·색상 enum 0건·MAT_TYPE 14종 apparel 버킷 부재·SEL_TYPE 다중 전건 실측). **CL distinct 신축 0(의류 variant #18 부결)=신규 vessel-gap 0·facet 5항 신규 vessel-gap 0(기존 #1/#2/#5/#9/#12/#15 흡수)·dbmap 기존 갭과 비충돌·기존 판정 전부 보존(17축 재포화).**
