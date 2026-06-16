# 발굴 축 (discovered-axes) — 7버킷 외 관리 메타모델

> rpm-metamodel-architect. 사용자 directive(HARD): **알려진 7버킷(자재/공정/옵션/템플릿/제약/기초코드/카테고리) 외에 더 많은 관리 축이 있는지 심도 발굴.**
> 입력 = BN(현수막류) 6상품 역공학(`01_reverse/`) + 인쇄 도메인 KB(`07_domain/`).
> 판정 기준(SKILL §3 distinctness test): **고유 속성/lifecycle/관계가 있어 기존 축이 왜곡 없이 못 담으면 distinct, 아니면 facet.**
> ⚠️ BN 단일 카테고리 추출 — 오버피팅 경계(SKILL §5): "한 상품만 필요한 축" 거부. distinct 판정은 *횡단 패턴 + 후니 도메인 동형*으로만.

---

## 발굴 결과 한눈에

7버킷은 "정적 객체 버킷"(무엇을 등록하나)에 치우쳐 있다. RedPrinting 역공학이 드러낸 추가 관리 축은 대부분 **관계·동역학 축**(객체들이 *어떻게 결합·게이팅·매개변수화되나*)이다.

| ID | 발굴 축 | distinct/facet | 한 줄 정체 | 7버킷 중 가장 가까운 것 | 왜 그것으로 안 되나 |
|---|---|:---:|---|---|---|
| **D-1** | 부속물(Addon) | **distinct** | 본체와 분리된 완제 부속 부품(거치대) | 템플릿/SKU·옵션 | 템플릿=묶음단위, 옵션=본체속성. 부속물은 독립 SKU·재고·본체 비귀속 |
| **D-2** | 자재 합성 & usage & 공정결합 | **distinct(메타규칙)** | MTRL_CD 다축 합성 + usage 슬롯 + 공정의 자재소비 | 자재 | 단순 자재 enum이 아니라 *합성 규칙*과 *공정↔자재 FK*가 본질 |
| **D-3** | 제약 논리유형(Constraint Logic) | **distinct** | disable/force/require/match/exclude/essential의 *유형화된 어휘* | 제약 | 7버킷 "제약"은 객체일 뿐, *논리 유형 거버넌스*가 누락 |
| **D-4** | 공정 파라미터(Process Parameter) | **distinct** | 공정 멤버에 종속된 매개변수 슬롯(줄수·mm·색·수량) | 옵션·공정 | 옵션=독립선택, 공정=멤버. 파라미터=부모공정 종속 자식 |
| **D-5** | 수량 모델(Quantity Model) | **distinct** | 건수×수량 다중 수량 슬롯 + 공정종속 수량 | 옵션(수량) | 단일 qty 스칼라로 평면화 시 가격 의미 소실 |
| **D-6** | 가격기여 역할(Pricing Role) | **distinct(횡단 메타)** | 각 선택이 가격에 *어떻게* 기여하는가(면적/곱수/고정/단가) | (7버킷 없음) | 7버킷 어디에도 "가격기여 방식" 축 부재 — RP는 price_flag로 전 축에 부착 |
| **D-7** | 인쇄방식/생산 레시피 | **distinct(조건부)** | 인쇄방식이 가능 공정·파일·팀을 게이팅 | 공정·기초코드 | RP는 자재 facet으로, 후니는 1급 레시피 축으로 — 게이팅 lifecycle 보유 |
| **D-8** | UI 런타임/표현 바인딩 | **facet(거부)** | Vue vs jQuery 두 런타임 | (없음) | 동일 base-data 모델 공유 → 관리 축 아님(표현 계층) |
| **D-9** | 생산형태(Production Type) | **distinct (GS v2.0)** | 완제품/반제품/통합/기성/디자인이 본체 모델링을 governing | 카테고리·템플릿 | 카테고리=기능 트리(직교), 템플릿=번들. 생산형태는 그 둘을 *governing*(본체=SKU vs 자재행 결정) |
| **D-10** | 본체 형태가공(Body Form-Assembly) | **distinct (GS v2.0)** | 평면→입체 본체를 *생성*하는 조립/봉제/지퍼 | 공정 | 일반 후가공=본체에 작업, 형태가공=본체 *생성*(없으면 본체 부재). lifecycle 구별 |

**발굴 distinct 축 = 9개**(D-1~D-7 BN + D-9·D-10 GS), facet 강등 = D-8 + GS facet 4종(G-1/G-2/G-4/G-3 아래). 7버킷 + 발굴 = **총 16 관리 축**(단 D-2는 자재 버킷 심화, D-6/D-7은 횡단). 메타모델 사전(`metamodel-dictionary.md`)은 **7 정적 축 + 4 관계/동역학 축 + 2 횡단 축 + GS 신축 2(#14·#15) = 15 dictionaried 축**으로 정리(D-8 제외).

> **v2.0 (GS 통합) 핵심 판정:** GS 역공학이 발굴한 새 패턴 6종 중 **distinct 승격은 2종(D-9 생산형태·D-10 형태가공)**뿐. 나머지 4종(완제 본체 SKU·본체소재 pdtCode 분리·variant 3채널·기종 enum)은 **기존 축 facet/확장으로 흡수**(과잉 일반화 거부, SKILL §5). 판정 근거 = "BN(평면)·GS(완제/입체) 두 군을 견디며 고유 lifecycle/governing을 가지는가". 양면 트레이드오프 펼침 = G-1/G-2(아래).

---

## D-1. 부속물 축 (Addon) — distinct ✅

**정체:** 인쇄 본체와 *분리된 완제 부속 부품*. 거치대(X배너 8종·롤업 3종), 후니 도메인의 우드봉·볼체인·이젤.

**증거(BN):**
- BNSTDFT CDL_DFT = [PTIDF 뉴포인트, PT005 L거치대, PT004 W거치대, … 8종], BNRLSLV = [RLU01/02/03 롤업거치대].
- PCS_COD(후가공) 그룹으로 묶이지만 **본체에 가하는 작업이 아니다** — 독립 완제품.

**distinctness:**
- vs **템플릿/SKU:** 템플릿 = "본체+부속의 묶음 주문 단위(번들 SKU)". 부속물 = "묶음에 들어가는 부속 부품". 거치대는 부품(D-1), "현수막+거치대 1세트" = 템플릿. 둘 다 필요(서로 못 담음).
- vs **옵션:** 옵션 = 본체 속성 선택. 부속물 = 본체 외부 객체(자체 코드·재고·가격).
- vs **공정:** 공정 = 본체 변형. 부속물 = 비변형 첨부.
- **후니 동형(권위):** entity-semantic-model 9속성 #9 `addl_product`(`t_prd_product_addons`) "완제 부속: 거치대·우드봉·볼체인 — 부착공정과 축 분리". → RP CDL_DFT = 후니 addons의 RP 표현. distinct 확정.

**오버피팅 검토:** BN에서만 거치대가 보였으나, 후니 도메인 KB가 거치대·우드봉·볼체인·이젤을 횡단 부속물로 확증 → 단일상품 아님, distinct 정당.

**관계:** 부속물 → 본체 상품(belongs-to, 번들), 부속물 ↔ 사이즈(match 제약, D-3). 부속물 자체가 size variant 보유(롤업거치대 600/850/1000).

---

## D-2. 자재 합성 & usage & 공정결합 축 (Material Composition) — distinct(메타규칙) ✅

**정체:** "자재"는 단순 enum이 아니라 **(a) 다축 합성코드 + (b) usage 슬롯 + (c) 공정의 자재소비 FK**라는 세 규칙을 가진 메타 구조.

**증거(BN):**
- (a) **합성:** MTRL_CD = MTRL_TYPE(P) + PTT_CD(BFC현수막/MAS매쉬/TFC텐트천) + CLR_CD(X기본) + WGT_CD(XXX) + 인쇄방식(수성C/라텍스L). 하나의 코드가 4~5축 인코딩(BNBNFBL note, A-4).
- (b) **usage:** BN은 substrate 단일 usage이나, 후니 entity-semantic-model #2 usage_cd(.01내지/.02표지/.03면지/.07공통) = 자재가 *어느 슬롯에 쓰이나*.
- (c) **공정결합:** SUB_MTRL_YN=Y(아일렛=금속링, 각목, 로프, 큐방) = 공정이 부자재를 소비(A-6). "순수공정(재단)" vs "자재소비공정(아일렛)"을 플래그로 분리.

**distinctness:**
- 단순 "자재 버킷"(자재 행 등록)은 (a)(b)(c) 규칙을 못 담음. 합성코드를 평면 문자열로 두면 본체색(CLR)·소재(PTT)·인쇄방식 분리 불가 → 위젯 옵션 캐스케이드·가격 분기 붕괴.
- **후니 권위 정합(HARD):** entity-semantic-model §1-1 "자재축에 공정 섞임"(아트250+무광코팅) = 결함. 메모리 `dbmap-material-option-normalization`: 후니 자재 오염(색/형상/구수가 자재행에) — RP 합성코드 분해가 *정답 모델*. 별색=공정·본체색=자재 CLR축(도메인 사실 준수).
- **공정↔자재 FK는 자재 버킷 단독으로 표현 불가** — 공정 엔티티가 `consumes_material`/`material_ref`를 가져야 함. 자재와 공정 양쪽에 걸친 메타규칙 → distinct.

**관계:** 자재(합성) → 본체, 자재 CLR → 본체색(variant), 공정(SUB_MTRL_Y) → 자재(consumes FK), 자재 → 공정(force, PET→코팅필수 D-3).

**경계 준수(도메인 HARD):** 별색≠자재(별색=공정 PROC_000007), 본체색=자재 CLR 분해축, 두께=자재 식별자. RP MTRL_CD의 CLR/WGT는 자재축, 인쇄방식은 자재 facet 또는 D-7로.

---

## D-3. 제약 논리유형 축 (Constraint Logic Typing) — distinct ✅

**정체:** 7버킷 "제약"은 *제약 객체*만 가리킨다. 발굴 핵심 = 제약이 **유형화된 논리 어휘**를 가진다는 것 — disable / force(=require) / match / exclude / essential / min-max.

**증거(BN) — 6 논리유형 실관측:**
| 논리유형 | BN 증거 | 방향 | 후니 동형 |
|---|---|---|---|
| **disable** | `pdt_disable_pcs_info`(자재→공정 비활성, BN 0건·책자 24건) | 자재→공정 (−) | round-6 material→pcs disable |
| **force/require** | PET→코팅 ESN_Y 필수, 텐트천→PKG_RUP 포장 필수(A-5) | 자재→공정 (+) | ESN_YN=Y, force 규칙 |
| **essential(필수)** | CUT_ZUN 재단 ESN_YN=Y(택1 필수), COT_DFT 코팅 ESN_Y | 그룹 내 필수 | excl_group 필수 |
| **match(캐스케이드)** | 롤업 size 600 ↔ 거치대 RLU01 1:1(A-1) | 사이즈↔부속물 | 부속물 size 종속 |
| **exclude(택1)** | 재단 그룹 [정사이즈/방풍/모양] 택1, SEL_TYPE.01 | 그룹 내 배타 | process_excl_group SEL_TYPE.01 |
| **min-max(범위)** | nonspec size MIN/MAX_CUT_WDT/HGH(0~5000) | 값 범위 | nonspec_*_min/max |

**distinctness:**
- 제약을 단일 객체 버킷으로 두면 "어떤 논리인가"를 못 표현 → 위젯 런타임이 캐스케이드를 못 구동. 6유형은 *거버넌스된 어휘*(JSONLogic op 집합)여야 함.
- **후니 권위:** entity-semantic-model #5 process_excl_group(택일), 메모리 `dbmap-cpq-option-mapping` "RedPrinting 캐스케이드 6종 → JSONLogic constraints", `dbmap-live-admin-product-viewer` constraints.logic NOT NULL. → 제약 논리유형이 후니 CPQ의 1급 구조. distinct 확정.
- **force = disable의 역방향**(사용자 directive 명시 후보): RP가 disable(−)과 force(+)를 *대칭 쌍*으로 운영 → 제약 축이 방향성을 가진 그래프임을 입증.

**관계:** 제약은 모든 축을 잇는 *간선(edge)* — 자재→공정(disable/force), 사이즈↔부속물(match), 공정 그룹 내(exclude/essential), 값 범위(min-max). 제약 축 = 메타모델의 관계 엔진.

---

## D-4. 공정 파라미터 축 (Process Parameter) — distinct ✅

**정체:** 공정 *멤버*가 선택됐을 때만 활성되는, 그 공정에 종속된 매개변수 슬롯.

**증거(BN):**
- BNTNHVY number_sel_ROP_DFT: 로프 공정에 종속된 수량 select(USER/1~10) (A-7).
- SUB_MTR QTY_INPUT_YN=Y: 추가부자재 수량 입력.
- (후니 횡단) UV 변형 5종(풀빼다/배면양면 = PROC_000002 param), 오시 줄수 0~3, 접지 16종, 책등 mm, 링컬러/D링 mm, 조각수.

**distinctness:**
- vs **옵션:** 옵션은 독립 선택축. 파라미터는 *부모 공정 종속*(공정 미선택 시 비존재).
- vs **수량:** 수량 슬롯 중 일부(로프 수량)는 파라미터지만, 파라미터는 수량 외 도메인(줄수/mm/색/조각수)도 가짐 → 수량의 상위가 아니라 별개.
- **후니 권위:** entity-semantic-model #4 "prcs_dtl_opt param — 줄수/개수/조각수=공정 신호(옵션값 아님)", process-recipe-tree §2-3 "param이 캐스케이드 입력값", 메모리 `dbmap-cpq-option-mapping` ref_param_json. → distinct 확정.
- **lifecycle:** 조건부 활성(부모 공정 선택 시), 자체 값 도메인, 가격에 공정과 함께 기여. 기존 옵션/공정 어느 쪽도 단독으로 못 담음.

**관계:** 파라미터 → 공정 멤버(belongs-to), 파라미터 → 가격(공정과 결합 기여, D-6), 파라미터 ↔ 캐스케이드(오시 줄수 → 접지 단수, D-3 match).

**도메인 경계 준수:** 판걸이수(impos)는 *앱 계산*(DB 미저장) — 파라미터 축에 넣지 말 것(entity-semantic #6 plate_size note, 메모리 `dbmap-compute-in-app-db-stores-lookup`). 파라미터 = *입력* 매개변수만.

---

## D-5. 수량 모델 축 (Quantity Model) — distinct ✅

**정체:** 단일 qty 스칼라가 아니라 **다중 의미적 수량 슬롯**(주문 건수 × 인쇄 수량 + 공정종속 수량).

**증거(BN):**
- 전 BN: ORD_CNT="디자인 수(건수)" + PRN_CNT="수량" 이중축(quantityGroup, A-2). SSR number1_sel(1~10) + number4_sel("N배").
- 공정종속: ROP_DFT 수량, SUB_MTR 수량(D-4와 교차).

**distinctness:**
- "옵션(수량)"으로 평면화하면 건수(세팅비 곱수)와 수량(선형)의 가격기여 차이 소실 → 가격 모델 붕괴(D-6과 연결).
- vs **bundle_qty(후니):** entity-semantic-model #7 bundle_qty = 묶음수(권/세트), page_rule ≠ bundle. RP ORD_CNT(디자인 건수)는 후니 bundle과 또 다른 의미 → 수량 축은 *복수의 이질적 슬롯*을 갖는 축임이 확증.
- lifecycle: 상품마다 노출 슬롯 다름(건수만/수량만/둘다/공정수량). distinct.

**관계:** 수량 슬롯 → 가격기여 역할(D-6: 건수=곱수, 수량=선형), 공정종속 수량 → 공정 파라미터(D-4 교차).

**오버피팅 검토:** 이중 수량은 BN 전 6상품 + Vue/jQuery 양 런타임 일관 관측 → 단일상품 아님, distinct.

---

## D-6. 가격기여 역할 축 (Pricing Role) — distinct(횡단 메타) ✅

**정체:** 7버킷 어디에도 없는 횡단 축 — **각 선택축이 가격에 *어떻게* 기여하는가**의 역할 태그.

**증거(BN):**
- 전 축에 `price_flag`/`price_gbn=real_price`가 부착: MTRL_CD→면적단가 분기키, CUT_WDT/HGH→SizeMatrix2D 면적, DOSU_COD→도수가, PCS_INFO[]→후가공가, ORD_CNT→세팅곱수.
- item_gbn=real_item·price_gbn=real_price = "대형 실사/배너 = 면적 기반 SizeMatrix2D 가격모델"(BN 공통 계약).

**distinctness:**
- 7버킷은 "무엇을 등록하나"(객체)만 다룬다. "그 선택이 가격에 면적단가인지/곱수인지/고정인지/단가매트릭스인지"는 별도 메타정보 → RP가 모든 축에 price_flag로 부착한 것이 증거.
- **후니 권위 정합:** 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형), `dbmap-price-class-benchmark`(가격공식 15클래스), round-2 t_prc_* 4단(price_components.prc_typ_cd 단가/합가). → 후니도 가격기여 *유형*을 1급 데이터로 운영(prc_typ_cd, frm_typ). distinct 확정.
- 횡단성: 자재·사이즈·도수·공정·수량 *모든 축*이 가격기여 역할을 가짐 → 단일 버킷 귀속 불가, 횡단 메타.

**관계:** 가격기여 역할은 각 축 엔티티에 *부착되는 태그*(자재.price_flag, size→면적, qty→곱수/선형) + 면적기반 상품은 SizeMatrix2D 가격모델 바인딩.

**경계:** 본 하네스 산출(메타모델)에서는 *역할 분류*까지만 — 실제 가격 *값/공식*은 dbmap 가격 트랙·갭분석가 영역. PRICE=0 캡처(비로그인)는 가격 *구조* 추출에 무관(BN note).

---

## D-7. 인쇄방식 / 생산 레시피 축 (Print-Method / Production Recipe) — distinct(조건부) ✅

**정체:** 인쇄방식(디지털/실사/UV/옵셋/실크)이 **가능 공정 부분집합·파일포맷·생산팀·기초데이터를 게이팅**하는 최상위 레시피 축.

**증거:**
- (BN/RP) 인쇄방식이 MTRL_CD 끝자리로 인코딩(수성C/라텍스L, A-4) — RP는 *자재 facet*으로 표현.
- (후니 권위) process-recipe-tree §1: 인쇄방식 5종 = 최상위 축, "1상품=1인쇄방식이 가능 공정 부분집합 결정"(레시피 게이팅). §2 PDF 17 Case = 방식별 공정 시퀀스.

**distinctness 판정(조건부):**
- **RP 표현에서는 facet**(자재코드 분기) — BN 단독으로 보면 자재 합성의 일부(A-4 1차 판정).
- **후니/도메인 표현에서는 distinct 1급 축** — 인쇄방식이 공정·파일·팀·기초데이터를 게이팅하는 *lifecycle*을 가짐. 단순 자재 분기가 담을 수 없는 게이팅 관계.
- **메모리 `dbmap-print-method-not-absolute-axis`:** 인쇄방식 절대축 아님(강제 분리 금지) — 그래서 *조건부* distinct: 메타모델은 인쇄방식을 (a) 자재 facet으로 인코딩하거나 (b) 1급 레시피 축으로 게이팅하는 *양면 표현*을 인정해야 함.
- **결론:** distinct 등재하되 "RP=자재 facet / 후니=1급 게이팅 축" 갭을 명기. 메타모델 사전에서는 게이팅 관계를 1급으로 그림(갭분석가가 후니 흡수 위치 결정).

**관계:** 인쇄방식 → 가능 공정 집합(gates), → 파일포맷, → 생산팀, → 기초데이터 요구. 자재와 부분 중첩(RP 인코딩).

---

## D-8. UI 런타임/표현 바인딩 — facet, **축 아님(거부)** ❌

**정체 후보:** Vue3 위젯 vs 레거시 jQuery 두 런타임(BN §0).

**거부 근거:**
- BN §0 핵심 발견: "UI 런타임이 둘이어도 **base-data 스키마는 하나**"(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_pcs_info` 공유).
- 후니가 흡수할 대상은 UI가 아니라 공통 관리 축 — 런타임은 *표현 계층*이지 관리 축이 아님.
- distinctness test 실패: 고유 관리 *데이터*가 없음(같은 base-data를 다르게 렌더할 뿐). → facet of presentation, 메타모델 사전에서 제외.

**메타모델 시사:** 메타모델은 런타임 중립이어야 함 — 같은 base-data가 어떤 위젯으로도 렌더되도록(후니 위젯 컨버전 전략 정합, 메모리 `huni-widget-conversion-strategy`).

---

## ═══ GS 통합 발굴 (v2.0) ═══

## D-9. 생산형태 축 (Production Type) — distinct ✅ (GS 신축)

**정체:** 상품의 생산 구조 분류(완제품 C / 반제품·셋트 B / 통합 A / 기성 / 디자인)가 **본체 모델링·자재 usage·형태가공을 governing**하는 상위 직교 축.

**증거(GS + 도메인 권위):**
- GS: 텀블러/코스터/효자손/장패드 = **C 완제품**(본체=DIR_MTR 완제 SKU 항목, 내지/표지 개념 없음), 스프링노트/스케치북 = **A 통합 또는 B 셋트**(표지+내지 usage 다중슬롯). 같은 "노트" 기능군에 통합책자·하드커버 공존.
- 도메인 권위(entity-semantic §4 "C-9 해결"): 생산방식 3구조 **A 통합 / B 셋트·반제품 / C 완제품·단일** 확정·11군 매핑. "B 셋트라도 자재 권위=parent+usage_cd, sub_prd 0행=정상".

**distinctness:**
- vs **카테고리:** 카테고리=기능 트리(코스터·노트). 생산형태는 *직교* — 같은 카테고리에 A·B·C 공존(노트=통합책자[A]+하드커버[B]). 카테고리가 생산형태를 못 담음(다대다 직교).
- vs **템플릿/SKU:** 템플릿=번들 주문 단위. 생산형태는 *본체가 자재행인가 완제 SKU 항목인가*를 결정하는 분류 — 템플릿의 상위.
- **lifecycle/governing:** 생산형태가 #1(본체 모델링)·#14(형태가공 활성)·#1 usage(셋트=다중)를 게이팅. 1상품 1생산형태. 기존 어느 축도 이 governing을 단독으로 못 함 → distinct.
- **오버피팅 검토:** BN(전부 C형 단일)에선 단일값이라 미발굴이었으나, **도메인 권위가 11군 매핑으로 1급 확정** + GS가 A/C 다수 노출 → 단일상품 아님(횡단). distinct 정당.

**관계:** 생산형태 → 상품(classifies 1:1), → 본체 모델링(governs #1/#4), → 형태가공(#14 C 입체 활성), → 자재 usage(#1 B 다중슬롯), ⊥ 카테고리(직교).

**★후니 갭(갭분석가 주목):** 메모리 `dbmap-grid-binding-round15` "라이브 prd_typ_cd ≠ 생산형태(굿즈/문구=.03기성·디지털/실사/아크릴=.04디자인 오귀속)" — 후니 라이브가 이 축을 *오모델링* 중. RP/GS가 정합 참조 제공.

---

## D-10. 본체 형태가공 축 (Body Form-Assembly) — distinct ✅ (GS 신축)

**정체:** 평면 인쇄물을 *입체 완제 굿즈로 조립/봉제/지퍼/형성*하는 공정. 본체 *형태 자체를 생성*(일반 후가공=기존 본체에 작업).

**증거(GS):**
- GSPUFBC: `PDT_WRK`(노트북-태블릿 파우치가공) + `FLX_ZIP`(지퍼가공 세로형). GSTGMIC: `PDT_WRK`(마이크텍 조립). 평면 패브릭/인쇄물 → 입체 파우치/마이크텍.
- BN(평면 배너)엔 *전무* — 굿즈 특유 축.

**distinctness:**
- vs **공정(#2):** 일반 후가공(코팅·재단·아일렛)=기존 본체에 작업 가함. 형태가공=본체 *생성*(파우치는 PDT_WRK 없으면 평면지로 본체 미완성). lifecycle 구별.
- vs **자재소비공정(D-2):** 지퍼(FLX_ZIP)는 부자재 소비 동반(아일렛 패턴)이나, PDT_WRK(봉제/조립)는 순수 형성 — 형태가공은 자재소비공정의 부분집합 아닌 별 카테고리.
- **lifecycle:** 본체 정체와 결합된 필수 공정 + 방향 variant(세로/가로). 생산형태(D-9 C 입체)에서만 활성.
- **오버피팅 검토:** GSPUFBC·GSTGMIC 2상품 + 효자손/폰케이스 추정 → 단일상품 아님. 후니 굿즈 BOM "평면→입체 조립 단계"(메모리 round-22 본체 자재 BOM) 동형. distinct 정당.

**관계:** 형태가공 → 상품(belongs, 본체 형성), → 자재(consumes 지퍼, #1), → 생산형태(D-9 governs), → 공정 seq(인쇄→재단→형태가공).

---

## ═══ GS facet/확장 판정 (distinct 거부 — 양면 트레이드오프) ═══

## G-1. 완제 본체 SKU (DIR_MTR/WRK_MTR) — **자재축 facet (distinct 거부)** ★핵심 의사결정

**정체 후보:** 굿즈 본체(텀블러/실리콘끈/장패드/스펀지)가 `DIR_MTR`(부자재직접인쇄)/`WRK_MTR`(부자재작업) PCS 항목으로 등장하고 result PRICE 주체.

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) 별도 distinct "완제 본체 SKU" 축으로 신설:**
  - 찬성: BN 본체=`ORD_INFO.MTRL_CD`(자재행)와 GS 본체=`DIR_MTR`(PCS 항목)는 *DB 위치가 다름*(ORD vs PCS). PRICE 주체·완제 SKU 라벨이라는 별 성격.
  - 반대: 위치가 달라도 *둘 다 "본체 소재를 가리키는 참조"*라는 같은 의미축. 신축으로 두면 자재축이 BN/GS로 쪼개져 메타모델 일관성 붕괴(같은 개념 2축). PRICE 주체는 가격기여 역할(#11)이 담음·완제 SKU성은 템플릿(#4)·생산형태(#15)가 담음.
- **(나) 자재축(#1)의 두 표현 facet + 템플릿(#4)·생산형태(#15) 결합 [채택]:**
  - 본체 = 자재참조(#1)이며, 생산형태(#15)가 *표현을 governing*: C 완제품→DIR_MTR PCS 항목(완제 SKU 라벨), A/B→ORD_INFO 자재행. 가격 주체성=#11, SKU성=#4.
  - 이점: 자재축 단일 유지·기존 발굴 축(#11/#4/#15)이 나머지 성격 흡수·BN/GS 통일.

**판정: facet (distinct 거부).** 완제 본체는 *기존 축들의 결합*으로 왜곡 없이 표현됨(자재#1 + 가격기여#11 + 템플릿#4 + 생산형태#15). 신축은 자재축 중복. **단 [HARD] 분해 요구:** PCS_DTL_NME 라벨 융합("미르 와이드마우스 보틀 화이트 20oz")을 `{body_material, body_color, capacity, thickness, brand}`로 분해해야(평면 라벨=의미축 drop). 이것이 후니 "굿즈 본체소재 부재" 결함의 RP판 정답.

---

## G-2. 본체 소재 = pdtCode 분리 (코스터 6소재) — **자재+카테고리 복합 facet (distinct 거부)** ★핵심 의사결정

**정체 후보:** 같은 기능(코스터)이 본체 소재(규조토/펠트/코르크/종이/아크릴/레더)별로 6개 별도 pdtCode.

**★양면 트레이드오프(침묵 선택 금지):**
- **(가) RedPrinting 방식 답습 — 소재=상품 분리(pdtCode 6개 유지):**
  - 찬성: RP 검증 모델·소재가 본체정체(다른 소재=다른 생산라인/단가)·아크릴 코스터만 형상 추가처럼 소재가 후속 옵션 캐스케이드.
  - 반대: 카탈로그 6→1 기회 상실·소재 추가 시 신상품 생성 운영부담·후니 "굿즈 본체소재 컬럼 부재"라 현재 상품명에만 → 6 pdtCode 답습 시 결함 고착.
- **(나) 소재=옵션화 — 한 "코스터" 상품 + 소재 차원(자재 variant):**
  - 찬성: 카탈로그 축소·소재=자재축 variant(entity-semantic §2 "색상 variant→material" 동형으로 소재 variant→material)·관리용이.
  - 반대: 소재별 후속 옵션 분기(아크릴=형상, 규조토=흡수 무인쇄?)를 옵션 캐스케이드로 풀어야 — variant×후속옵션 복잡도. 소재별 단가가 매트릭스로.

**판정: facet — 자재축(#1 소재 variant) + 카테고리(#7 코스터=공통 기능 노드) 복합 (distinct 거부).** "본체 소재"는 자재축이 담고(소재=mat_cd 분기), "코스터 공통 기능"은 카테고리가 담음 → 신축 불요. **분리 vs 옵션화는 메타모델 판정이 아닌 후니 카탈로그 *정책 결정*(갭분석가/실무)** — 메타모델은 둘 다 표현 가능(소재=pdtCode면 카테고리 다대일, 소재=옵션이면 자재 variant). RP는 (가) 채택, 후니 관리용이성은 (나) 우세하나 아크릴 코스터 형상 캐스케이드가 (나)의 난점. **권고: 정형 소재(종이/펠트/코르크/규조토/레더)=옵션화, 형상 동반 소재(아크릴)=별 pdtCode** 하이브리드.

---

## G-3. 폰케이스 기종(device) enum — **사이즈 프리셋 facet (distinct 거부)**

**정체 후보:** 폰케이스 기종(갤럭시/아이폰 수십종)별 칼틀·사이즈 분기(GSCAPHN, 옵션 상세 unobserved).

**판정: facet — 사이즈 축(#13) 대규모 프리셋 인스턴스 (distinct 거부).** 기종 = 사이즈/칼틀 프리셋의 *대규모 enum*일 뿐 고유 lifecycle 없음(소재처럼 본체정체를 바꾸지 않음·기능 동일). 기종↔칼틀 캐스케이드 = 제약축(#5 match). "일반/터프"(케이스 구조)는 자재축 본체타입 variant(#1)와 직교. **단 enum 규모(수십~수백)가 질적으로 커 위젯 UX는 검색형 select 필요**(메타모델 데이터 구조는 사이즈 프리셋 동일·표현만 다름). unobserved라 규모/캐스케이드 방향 확정 불가(`unobserved`).

---

## G-4. variant 3채널(DTL/ATTB/CUT) — **기존 축 분배 facet (distinct 거부)**

**정체 후보:** 같은 variant 개념이 DTL코드·ATTB·CUT_WDT/HGH 3채널로 분산.

**판정: facet — 3채널을 기존 축으로 분배 (별 "variant 축" distinct 거부).** ① DTL코드→옵션축(#3) polymorphic option_item(다차원 합일 시 다중 ref_dim_cd), ② ATTB→공정 파라미터(#9, 링색·반경), ③ CUT→사이즈축(#13 프리셋). entity-semantic §2 "variant 분해 원칙(색상→material·사이즈→size·두께→material)"이 이미 채널 분배를 규정 → 신축 불요. **★난점 명기:** GSTGMIC TG001/3처럼 *한 DTL코드가 자재+사이즈+칼틀+가격 동시 결정*(강결합) — 후니 CPQ polymorphic ref가 한 option_item에서 복수 차원을 게이팅하도록 표현(메모리 `dbmap-cpq-option-layer-mapping`). 정규화 난점이지 신축 사유 아님.

---

## G-5/G-6/G-7/G-8 — 기존 축 확장 (요약 판정)

| frag | 정체 | 판정 | 귀속 축 |
|---|---|---|---|
| **G-5** | INN_DFT/RIN_DFT/RIN_COL/STA_DFT (내지 usage + 제본방식) | **facet/확장** | 내지=자재 usage 다중슬롯(#1 GS 확인 ✅), 제본=공정(#2) + 자재(링/코일) bundle + 택1 그룹. 제본방식이 PCS_COD 레벨 분리(그룹 메타 없음) → 후니 옵션그룹(택1)으로 묶을 메타 추가 필요 |
| **G-6** | PDT_WRK/FLX_ZIP (형태 조립) | **distinct → D-10** | 본체 형태가공 신축(위 D-10). FLX_ZIP은 자재소비(지퍼) bundle |
| **G-7** | tmpl/vTmpl/tiered_price (가격모델 3종) | **확장** | 가격기여 역할(#11) — pricing_model enum 4종 확장(면적/tmpl/vTmpl/tiered). 옵션↔가격모델 라우팅 |
| **G-8** | PAK_ETC/PAK_POL (포장 다중 + 유료/무료) | **facet** | 공정(#2 포장) — 방식별 PCS_COD + 가격기여(#11 유료/무료 분기). BN PKG_GB(강제 제약 A-5)와 달리 GS=선택+개당과금 |

---

## 종합 — 7버킷 재평가

| 7버킷 | 발굴로 인한 재평가 |
|---|---|
| 자재 | **심화** — 단순 enum이 아닌 합성+usage+공정결합 메타규칙(D-2) |
| 공정 | **확장** — 자재소비 플래그(D-2) + 파라미터 종속(D-4) |
| 옵션 | **분화** — 수량은 별도 다중슬롯 모델(D-5), 파라미터는 공정종속(D-4)로 분리 |
| 템플릿/SKU | **인접 축 분리** — 부속물(D-1)은 별개(템플릿=번들단위, 부속물=부품) |
| 제약 | **유형화** — 객체가 아닌 6 논리유형 거버넌스(D-3) |
| 기초코드 | (유지) — enum 도메인 거버넌스, 사이즈 프리셋·도수 enum. GS: 도수 enum에 SID_X(무인쇄·텀블러) 확인 |
| 카테고리 | **GS 보강** — 공통 기능 그룹화(코스터 6 pdtCode=1 노드) 확인. 생산형태는 직교 distinct로 분리(D-9) |
| 신축(GS) | **생산형태(D-9)·본체 형태가공(D-10)** — 완제/입체 굿즈가 드러낸 distinct 2축 |

**GS로 해소된 BN 갭:** ① **자재 usage 다중슬롯** — GS 스프링노트(표지+내지+링) 실관측으로 BN substrate 단일 한계 해소(#1 GS 확인 ✅). ② **생산형태** — GS C 완제품 다수 노출로 distinct 확정(D-9·도메인 권위 C-9 정합). ③ **완제 SKU 본체 모델링** — GS DIR_MTR로 패턴 확정(G-1 facet 판정).

**여전히 미발굴(2 상품군 한계):** ① **카테고리 트리 깊이/다중분류** — GS도 옵션 트리 라이브 추출 불가(신규 Vue client-render)로 다중분류(한 상품 여러 트리) 직접 미관측. ② **템플릿 template_selections 구조** — 완제 SKU 번들 구성 선택 묶음 상세(봉투결합 엽서·OTC) 미관측. ③ **코드 채번 거버넌스** — pdtCode/PCS_COD/DTL 채번 규칙. → 책자(booklet, A통합+B셋트 명시)·문구(stationery) 샘플로 확대 권고.

## 갭 — 추가 샘플 필요(과잉 일반화 방지)

1. **카테고리 트리/다중분류:** BN·GS 둘 다 옵션 트리 라이브 추출 불가(신규 Vue) → 한 상품 여러 트리 소속·트리 깊이 미관측. **책자(booklet)·문구(stationery) reuse 캡처 권고.**
2. **템플릿(완제 SKU) 계층:** GS DIR_MTR로 완제 본체는 확인했으나 *번들 구성(template_selections)*은 미관측(봉투결합 엽서·OTC). 완제 SKU + 부속물 묶음 샘플 필요.
3. **vTmpl vs tmpl 가격모델 분기 조건:** GSPDLNG만 vTmpl 단일 샘플 → variant 유무가 가격모델을 어떻게 가르는지 확정 불가. variant 상품 추가 캡처 권고.
4. **생산형태 enum 완전성:** 기성·디자인 형태(D-9)는 도메인 권위로만 확정, RP 직접 관측은 완제품(C)·통합(A)·셋트(B) 위주. 디자인/기성 굿즈 캡처로 보강.
