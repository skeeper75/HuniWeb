# 교차엣지 후보 목록 — 상위 온톨로지 교차관계 폐쇄목록 후보 (§35 Phase 2)

> 작성: 2026-07-04 · mbo-crossbrand-mapper. 방법론 = `mbo-crossbrand-mapping` 스킬.
> **입력 원천** = `family-alignment.md`(A-1~A-16 정렬)·`difference-matrix.md`(D0-*·A-* 3축 차이).
> **목적** = architect(mbo-ontology-design)가 상위 온톨로지에 넣을 **교차관계 엣지 후보**를 폐쇄목록으로 제시.
> **[HARD] 경계:** 후보까지. 스키마 확정·개체 승격·닫힌세계 규약은 architect 몫. 앵커 없는 엣지 금지.
> **관계 어휘(승계)** = `upper-ontology-vocabulary.md` §2: X-1 `instance_of`·X-2 `mapped_to`(§33 승계)·X-3 `same_family_as`·X-4 `price_model_differs`·X-5 `component_differs`.
>
> **읽는 법:** 이 목록은 후니·와우 두 브랜드 노드를 잇는 "다리(엣지)" 후보다. 같은 상품군이면 `same_family_as`,
> 가격모델이 다르면 `price_model_differs`, 구성이 다르면 `component_differs`, 상위 표준개념에 걸면 `instance_of`.

---

## 0. 엣지 유형 5종 요약

| 엣지 | 방향 | 의미 | 유래 | 근거 문서 |
|---|---|---|---|---|
| `same_family_as`(X-3) | product↔product / family↔family | 같은 상품군 교차 대응 | §35 신규 | family-alignment A-* |
| `price_model_differs`(X-4) | formula↔formula | 같은 상품군인데 가격 아키타입 상이 | §35 신규 | difference-matrix D0-A/B·axis② |
| `component_differs`(X-5) | component↔component | 같은 개념인데 구성요소 표현 상이 | §35 신규 | difference-matrix axis①/③ |
| `instance_of`(X-1) | 브랜드노드→상위개념 | 브랜드 실물이 상위 표준개념의 사례 | §35 신규(2층 핵심) | upper-vocab U-* |
| `mapped_to`(X-2) | 브랜드노드↔브랜드노드 | 같은 상위개념 경유 교차 대응 | §33 §9 동사 승계 | standards-mapping-delta |

---

## 1. `same_family_as`(X-3) 후보 — family 단위 (16 성립 쌍)

방향 = 무방향(대칭). id 접두 후니 = `product-*`/family 라벨·와우 = `wow-cat-<id>`/`wow-prod-<id>`(접두 규약 architect 확정 대기·upper-vocab §4 항목5).

| edge# | 후니 노드 | 와우 노드 | 확신도 | 근거(family-alignment) |
|---|---|---|---|---|
| SFA-1 | family:명함(product-031~040) | wow-family:명함(catalog:categories 명함 43) | strong | A-1 |
| SFA-2 | family:스티커(product-051~067) | wow-family:스티커(catalog 45) | strong | A-2 |
| SFA-3 | family:엽서카드(product-016~030) | wow-family:행택/쿠폰/안내장+프리미엄엽서(catalog 22) | strong | A-3 |
| SFA-4 | family:사인실사(product-118~145) | wow-family:사인제품(catalog 51) | strong | A-4 |
| SFA-5 | family:책자(product-068~107) | wow-cat:책자(catalog 6) | strong | A-5 |
| SFA-6 | family:리플렛(product-048~050) | wow-cat:홍보물/리플렛(catalog:products/40037) | strong | A-6 |
| SFA-7 | family:전단(product-047) | wow-family:전단(catalog 5) | partial | A-7 |
| SFA-8 | family:캘린더(product-108~112) | wow-cat:캘린더(catalog 7) | strong | A-8 |
| SFA-9 | family:봉투부자재(product-001·002·005·050) | wow-cat:봉투+부자재(catalog:products/40035·40339) | partial | A-9 |
| SFA-10 | family:홀더(product-215·216·218) | wow-cat:홀더(catalog 5) | partial | A-10 |
| SFA-11 | family:폰케이스(product-219·220) | wow-cat:폰액세서리(catalog:products/40463) | partial | A-11 |
| SFA-12 | family:자석(product-011·147) | wow-cat:자석제품(catalog:products/40093) | partial | A-12 |
| SFA-13 | family:쿠폰상품권(product-041·042) | wow-family:행택/쿠폰(catalog:products/40109) | partial | A-13 |
| SFA-14 | family:굿즈떡메모지(product-097·098) | wow-cat:굿즈/판촉(catalog:products/40189·40083) | partial | A-14 |
| SFA-15 | family:버튼(product-200·227) | wow-cat:버튼/선거홍보물(catalog:products/40136·40451) | partial | A-15 |
| SFA-16 | family:어패럴(product-205·206·209) | wow-cat:어패럴(catalog:products/40468) | partial | A-16 |

> **정렬 불가(same_family_as 미배선·양면 GAP 노드)**: 후니-only HO-1~5(아크릴굿즈·봉제파우치·문구다이어리·투명계열·데코소품)·와우-only WO-1~6(카페용품·서식NCR·기획상품·액자·선거·팬시). architect가 GAP/단면 노드로 보존(삭제 금지·family-alignment §2·§3).

---

## 2. `price_model_differs`(X-4) 후보 — formula↔formula

방향 = 무방향. 근거 = 후니 아키타입(내장 다형) vs 와우 jobcost(단일 API). 값 권위 둘 다 서버(D-18·경계 동형·차이는 **모델 위치·형태**).

| edge# | 후니 formula(아키타입) | 와우 formula | 차이 유형 | 근거 |
|---|---|---|---|---|
| PMD-1 | formula-PRF_NAMECARD_FIXED/FOIL(고정가·용지포함) | wow-jobcost:명함(prsjob+paper+awkjob 조회) | 내장 고정가룩업 vs 조회API·박=셋업비분리 vs awkjob | A-1 |
| PMD-2 | formula-PRF_STK_FIXED/GANGPAN_FIXED(완제품가 격자룩업) | wow-jobcost:스티커 | 격자룩업 vs API·합판=별공식 vs pjoin | A-2 |
| PMD-3 | formula-PRF_DGP_A(원자합산형) | wow-jobcost:엽서 | 원자합산(구성요소가산·투명) vs 조회(은닉) | A-3 |
| PMD-4 | formula-PRF_CLR_ACRYL/PRF_POSTER_WATERPROOF(면적매트릭스·수량축없음) | wow-jobcost:사인제품(sizeno/비규격 w/h+ordqty) | 면적셀 통가 vs 축조합+수량 | A-4 |
| PMD-5 | formula-PRF_BIND_MUSEON+evaluate_set_price(셋트조합 2단) | wow-jobcost:책자(단일+coverinfo) | 셋트 부품조립(멤버합산+부모) vs 단일 조회 | A-5 |
| PMD-6 | formula-PRF_DGP_E(원자합산·접지) | wow-jobcost:리플렛 | 원자합산 vs API | A-6 |
| PMD-7 | formula-PRF_DGP_CAL_WIDE(원자합산·장수축) | wow-jobcost:캘린더(기성/맞춤) | 업로드 원자합산 vs 조회(기성품 포함) | A-8 |
| PMD-8 | formula-PRF_TTEOKME_FIXED(셋트 부모 all-in·권당장수) | wow-jobcost:떡메모지 | 셋트 고정가+bdl_qty vs 단일 조회 | A-14 |

> **공통 축(전 PMD 상속)** = **D0-A PrintMethodIntent**: 후니 인쇄방식 공식바인딩 ↔ 와우 prsjob 선택(16종). 최대 델타. + **D0-B**: 후니 6아키타입 ↔ 와우 단일 jobcost.

---

## 3. `component_differs`(X-5) 후보 — component↔축

방향 = 무방향. 근거 = 후니 구성요소(COMP_*·투명) ↔ 와우 입력 축(paper/color/prsjob/awkjob·내역 map 은닉이라 **입력 축 대응까지**·D0-C).

| edge# | 후니 component | 와우 축 | 차이 유형 | 근거 |
|---|---|---|---|---|
| CMD-1 | component-COMP_PRINT_DIGITAL_S1(인쇄비·판걸이수) | wow-axis:prsjob(인쇄방식16)+pjoin(합판/독판) | **인쇄방식 지위**(후니 접힘+판걸이수 계산 vs 와우 1급 축) — 최대 델타 | D0-A |
| CMD-2 | component-COMP_PAPER(용지비·연당) | wow-axis:paperno(papergroup·pgram) | 후니 연당가 구성요소 vs 와우 지질 선택값 | D0-C |
| CMD-3 | component-COMP_NAMECARD_FOIL_SETUP(박 동판셋업 분리) | wow-axis:awkjob(박앞면/박뒷면 그룹) | 후니 셋업비 별구성요소 vs 와우 후가공 가산 | A-1 |
| CMD-4 | component-COMP_PRINT_SPOT_WHITE_S1(별색화이트=공정) | wow-axis:colornoadd(추가도수) | 후니 별색=공정 vs 와우 추가도수 | A-3 |
| CMD-5 | component-COMP_FOLD_LEAF_*(접지패턴 4구성요소) | wow-axis:awkjob(접지 그룹) | 후니 패턴별 구성요소 열거 vs 와우 접지 작업 | A-6 |
| CMD-6 | component-COMP_BIND_MUSEON/JUNGCHEOL/PUR(제본비 부모공식) | wow-axis:awkjob(제본 그룹) | 후니 제본=부모공식+구성원분해 vs 와우 제본=후가공 | A-5 |
| CMD-7 | component-COMP_POSTER_ARTPRINT_PHOTO(면적 통가) | wow-axis:sizeno+비규격 width/height | 후니 [가로×세로]셀 통가 vs 와우 규격선택+non_standard | A-4 |
| CMD-8 | (후니 has_addon 템플릿·엽서봉투/거치대) | wow-axis:prodaddinfo/optioninfo(2채널) | 후니 addon 단일채널(R14) vs 와우 2채널 경계(D-U14+) | A-3·A-4 |
| CMD-9 | component-COMP_TTEOKME(권당장수 bdl_qty) | wow-axis:ordqty(수량) | 후니 권당장수 축 vs 와우 수량 구간 | A-14 |

---

## 4. `instance_of`(X-1) 후보 — 브랜드노드→상위개념 (2층 연결)

architect가 상위 개념(U-*)을 개체로 승격하면 아래 엣지로 브랜드 노드를 건다(upper-vocab §1). **핵심 신설 상위개념 우선**.

| 상위개념(U-) | 후니 노드 --instance_of--> | 와우 노드 --instance_of--> | 비고 |
|---|---|---|---|
| U-4 PrintMethodIntent | (print_option 접힘분 + plate/pansu 투영) | wow-prsjob-*(16종)·pjoin | **신설 필수**(최대 델타·양 브랜드 대등 표현) |
| U-6 MediaClass | material-MAT_*(E4) | wow-paper-*(paperinfo) | 승계(XJDF MediaIntent) |
| U-3 DimensionSpec | size-*(E3) | wow-size-*(sizeinfo·비규격 w/h) | 승계 |
| U-5 ColorSpec | printopt-POPT_*(도수) | wow-color-*(colorno+add) | 승계 |
| U-8 FinishingOp | process-PROC_*(E6) | wow-awkjob-*(2단 jobgroup) | 승계 |
| U-7 ImpositionStrategy | plate_size+fn_calc_pansu(E7) | wow-pjoin(합판9/독판0) | 신설(판걸이 명시) |
| U-16 PriceModel | formula-PRF_*(6아키타입) | wow-jobcost(단일) | 승계 |
| U-18 QuoteFunction | evaluate_price() | POST /std/prod/jobcost | 신설(표준 공백·값 권위 경계) |
| U-15 CrossAxisConstraint | constraint-*(CN-1~6) | wow-req_/rst_*(option-item) | 승계(세분성 주석) |
| U-20 ProductFamily | family:명함/스티커/... | wow-family:명함/스티커/... | 신설(same_family_as 기준선) |
| U-22 BrandNode | brand:huni(전 노드) | brand:wowpress(전 노드) | 신설(3브랜드 출처축) |

---

## 5. `mapped_to`(X-2) 후보 — 승계(§33 §9 동사)

상위개념 경유 수평 교차. **instance_of가 상위에 걸리면 mapped_to는 유도**(upper-vocab §2 설계근거). 명시 후보 예:

| edge# | 후니 노드 | 와우 노드 | 경유 상위 | 비고 |
|---|---|---|---|---|
| MT-1 | material-MAT_*(스노우지 등) | wow-paper-*(스노우지·papergroup 160) | U-6 MediaClass | 재질 교차 |
| MT-2 | process-PROC_*(코팅/타공/박) | wow-awkjob-*(코팅/타공/박 그룹) | U-8 FinishingOp | 후가공 교차 |
| MT-3 | printopt-POPT_(단/양면 도수) | wow-color-*(단면칼라/양면칼라8도) | U-5 ColorSpec | 도수 교차 |

> mapped_to는 **인스턴스 단위 교차**(architect가 instance_of 배선 후 유도·명시 배선은 대표만). 자동 확장(레드 추가) = instance_of만 붙이면 성립(upper-vocab §2).

---

## 6. 엣지 후보 요약 (architect 입력)

- **same_family_as 16**(SFA-1~16: strong 8·partial 8) + 정렬불가 11군(양면/단면 GAP 보존).
- **price_model_differs 8**(PMD-1~8): 전부 D0-A(PrintMethodIntent 최대 델타)+D0-B(아키타입 다형 vs 단일 API) 상속.
- **component_differs 9**(CMD-1~9): CMD-1(인쇄방식 지위)이 핵심. 와우 내역 은닉이라 후니 component ↔ 와우 **입력 축** 대응까지(D0-C 경계).
- **instance_of 11 상위개념**: 신설 우선 = U-4 PrintMethodIntent·U-7 ImpositionStrategy·U-18 QuoteFunction·U-20 ProductFamily·U-22 BrandNode(전부 표준 근거·upper-vocab §1).
- **mapped_to = instance_of 유도**(레드 확장 안전). 명시 배선은 대표 재질/공정/도수만.
- **폐쇄목록 준수**: 신규 관계 = X-1·X-3·X-4·X-5 4종만(X-2는 §33 승계). 개방 관계명 금지(§33 스키마 D-원칙 승계).

## GAP (정직 기록)

- **G-EDGE-1**: 와우 노드 id 접두 규약 미확정(`wow-paper-*`·`wow-family-*` 등) → architect가 §33 접두와 충돌 없게 확정(upper-vocab §4 항목5·brand축 U-22 병기).
- **G-EDGE-2**: same_family_as는 **family 단위**만 배선(SFA-1~16). 상품 단위 same_family_as(예 후니 특수지명함 ↔ 와우 40070)는 후속 델타(개별 상품 매핑·G-ALIGN-2).
- **G-EDGE-3**: component_differs(CMD-*)는 와우 ordcost_base 은닉(GAP-PRICE-3)으로 **입력 축 대응까지**. 후니 구성요소 ↔ 와우 가격내역 직접 대조 엣지는 배선 불가(값 권위 경계·의도적).
- **G-EDGE-4**: instance_of 신설(X-1)을 §33 관계 폐쇄목록(19종)에 추가할지 = architect 결정(upper-vocab §4 항목3·권고 추가). 이 목록은 후보 제시까지.
- **G-EDGE-5**: 레드 미포함 → PMD/CMD/SFA 전부 후니+와우 2브랜드. 레드 추가 시 3자 엣지 append(instance_of 구조라 확장 안전·GAP-DELTA-2).

## Sources
- `family-alignment.md`(A-1~A-16·HO-*·WO-*) · `difference-matrix.md`(D0-A~D·A-* 3축·CMD 근거)
- `00_research/upper-ontology-vocabulary.md`(U-1~U-22·X-1~X-5 관계 어휘) · `standards-mapping-delta.md`(신규 8개·X-1/3/4/5)
- §33 `02_ontology/ontology-schema.md`(R1~R19·§9 동사 6종 mapped_to 승계·개방 관계명 금지)
