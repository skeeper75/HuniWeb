# 교차관계 폐쇄목록 — 상위 온톨로지 교차 엣지 확정 (§35 Phase 3)

> 작성: 2026-07-04 · mbo-ontology-architect · 방법론 = `mbo-ontology-design` 스킬.
> 입력: `02_crossbrand/crossbrand-edges.md`(SFA/PMD/CMD/instance_of/mapped_to 후보)·`family-alignment.md`(A-1~16)·`difference-matrix.md`(D0-A~D).
> **[HARD] 이 문서가 교차관계를 폐쇄목록으로 확정한다**(후보 → 등재). 개방 관계명 금지(§33 D-7 승계). 앵커 없는 엣지 금지(L-X-1).
> **[HARD] 가격 값 대조 안 함**(D-18). 교차관계는 **모델·구조 차이**까지(값 권위=엔진/API).
>
> **읽는 법:** 후니 노드와 와우 노드를 잇는 "다리(엣지)" 5종을 확정한다. 같은 상품군=`same_family_as`, 가격모델 상이=`price_model_differs`, 구성 상이=`component_differs`, 상위 표준개념에 걸기=`instance_of`, 상위 경유 교차=`mapped_to`.

---

## 0. 교차관계 5종 확정 (폐쇄목록 등재)

| 엣지 | ID | 방향 | 카디널리티 | 유래 | §33 폐쇄목록 |
|---|---|---|---|---|---|
| `instance_of` | X-1 | 브랜드노드 → upper_concept | N:1 | §35 신규(2층 핵심) | **신규 등재**(23종째) |
| `mapped_to` | X-2 | 브랜드노드 ↔ 브랜드노드 | N:M(대칭) | §33 §9 동사 | **승계**(재등재 불필요) |
| `same_family_as` | X-3 | product↔product / family↔family | N:M(대칭) | §35 신규 | **신규 등재** |
| `price_model_differs` | X-4 | price_formula↔price_formula | N:M(대칭) | §35 신규 | **신규 등재** |
| `component_differs` | X-5 | price_component↔(component\|축) | N:M(대칭) | §35 신규 | **신규 등재** |

- **신규 4종**(X-1·X-3·X-4·X-5) → §33 19종 + 4 = **폐쇄목록 23종**. X-2는 §33 §9에 이미 있어 승계.
- **대칭 엣지 표기 규약**: X-3/4/5는 무방향(대칭). 저장 시 정본 방향 = `huni_node → wow_node`(레드 추가 시 알파벳순 huni<red<wowpress). 질의는 양방향 순회.
- **엣지 한정자(qualifier) 공통**: `diff_type`(차이 요지)·`both_authority`(값 권위 위치·X-4)·`inherits`(D0-* 상속)·`confidence`(strong/partial)·`sources`(양쪽 앵커 병기 필수).

---

## 1. `same_family_as`(X-3) — 확정 폐쇄목록 (16쌍)

방향 = 무방향(대칭). family 단위. 확신도 `strong`=verified·`partial`=candidate. **양쪽 앵커 병기**(L-X-1).

| edge# | 후니 노드(앵커) | 와우 노드(앵커) | 확신도(badge) | 근거 |
|---|---|---|---|---|
| **SFA-1** | `family-명함`(t_cat_categories/CAT_000313) | `wow-family-명함`(catalog:categories 명함 43상품) | strong(✅) | A-1 |
| **SFA-2** | `family-스티커`(CAT_000002) | `wow-family-스티커`(catalog 45) | strong(✅) | A-2 |
| **SFA-3** | `family-엽서카드`(CAT_000001) | `wow-family-행택쿠폰안내장`+프리미엄엽서(catalog:products/40346) | strong(✅) | A-3 |
| **SFA-4** | `family-사인실사`(product 118~145) | `wow-family-사인제품`(catalog 51·40437) | strong(✅) | A-4 |
| **SFA-5** | `family-책자`(product 068~107) | `wow-cat-책자`(catalog:products/40196) | strong(✅) | A-5 |
| **SFA-6** | `family-리플렛`(product 048~050) | `wow-cat-홍보물리플렛`(catalog:products/40037) | strong(✅) | A-6 |
| **SFA-7** | `family-전단`(product 047) | `wow-family-전단`(catalog:products/40054) | partial(🟡) | A-7 |
| **SFA-8** | `family-캘린더`(product 108~112) | `wow-cat-캘린더`(catalog:products/40619) | strong(✅) | A-8 |
| **SFA-9** | `family-봉투부자재`(product 001·002·005·050) | `wow-cat-봉투부자재`(catalog:products/40035·40339) | partial(🟡) | A-9 |
| **SFA-10** | `family-홀더`(product 215·216·218) | `wow-cat-홀더`(catalog:products/40041) | partial(🟡) | A-10 |
| **SFA-11** | `family-폰케이스`(product 219·220) | `wow-cat-폰액세서리`(catalog:products/40463) | partial(🟡) | A-11 |
| **SFA-12** | `family-자석`(product 011·147) | `wow-cat-자석제품`(catalog:products/40093) | partial(🟡) | A-12 |
| **SFA-13** | `family-쿠폰상품권`(product 041·042) | `wow-family-행택쿠폰`(catalog:products/40109) | partial(🟡) | A-13 |
| **SFA-14** | `family-굿즈떡메모지`(product 097·098) | `wow-cat-굿즈판촉`(catalog:products/40189·40083) | partial(🟡) | A-14 |
| **SFA-15** | `family-버튼`(product 200·227) | `wow-cat-버튼선거`(catalog:products/40136·40451) | partial(🟡) | A-15 |
| **SFA-16** | `family-어패럴`(product 205·206·209) | `wow-cat-어패럴`(catalog:products/40468) | partial(🟡) | A-16 |

**정렬 불가(same_family_as 미배선·단면 GAP 노드 보존·삭제 금지)**: 후니-only HO-1~5(아크릴굿즈·봉제파우치·문구다이어리·투명계열·데코소품) · 와우-only WO-1~6(카페용품·서식NCR·기획상품·액자·선거·팬시). → 각각 `gap` 성격 단면 노드(brand 속성 + family 노드·상대 없음 명시). family-alignment §2·§3 승계.

---

## 2. `instance_of`(X-1) — 확정 (2층 연결·11 상위개념 우선)

브랜드 실물 → upper_concept. **신설 상위개념 우선**(표준 근거·upper-vocab §1). 전량 = upper-ontology-schema §4 매핑표.

| upper_concept | 후니 --instance_of--> | 와우 --instance_of--> | 우선 |
|---|---|---|---|
| `UPPER_PrintMethodIntent`(U-4) | `printmethod-huni-*`(투영·none) | `wow-prsjob-*`(16종) | **★신설 필수**(D0-A 최대 델타) |
| `UPPER_QuoteFunction`(U-18) | `quotefn-huni-evaluate-price` | `quotefn-wow-jobcost`(wowpress-api:6.4) | ★신설(값 경계) |
| `UPPER_ProductFamily`(U-20) | `family-*` | `wow-family-*` | ★신설(SFA 기준선) |
| `UPPER_BrandNode`(U-22) | `brand-huni` | `brand-wowpress` | ★신설(출처축) |
| `UPPER_ImpositionStrategy`(U-7) | `plate-*`+fn_calc_pansu | wow-product.pjoin(속성) | 접기(개체X) |
| `UPPER_MediaClass`(U-6) | `material-MAT_*` | `wow-paper-*` | 승계 |
| `UPPER_DimensionSpec`(U-3) | `size-*` | `wow-size-*` | 승계 |
| `UPPER_ColorSpec`(U-5) | `printopt-*` | `wow-color-*` | 승계 |
| `UPPER_FinishingOp`(U-8) | `process-PROC_*` | `wow-awkjob-*`(2단) | 승계 |
| `UPPER_PriceModel`(U-16) | `formula-PRF_*`(6아키타입) | `wow-jobcost-formula` | 승계 |
| `UPPER_CrossAxisConstraint`(U-15) | `constraint-*`(CN-1~6) | wow req_/rst_(option-item) | 승계 |

- **레드 확장 안전**: `red-*` 노드에 instance_of만 붙이면 mapped_to 자동 유도(upper-vocab §2).

---

## 3. `price_model_differs`(X-4) — 확정 폐쇄목록 (8쌍)

formula↔formula. 값 권위 둘 다 서버(`both_authority: server`·D-18 경계 동형). 차이 = 모델 위치·형태. 전 쌍 D0-A(PrintMethodIntent)+D0-B(아키타입 다형 vs 단일 API) 상속.

| edge# | 후니 formula(아키타입·앵커) | 와우 formula(앵커) | diff_type | 근거 |
|---|---|---|---|---|
| **PMD-1** | `formula-PRF_NAMECARD_FIXED/FOIL`(고정가·용지포함) | `wow-jobcost-formula-40070`(prsjob+paper+awkjob) | 내장 고정가룩업+박 셋업비분리 vs 조회API·박=awkjob | A-1 |
| **PMD-2** | `formula-PRF_STK_FIXED/GANGPAN_FIXED`(완제품가 격자룩업) | `wow-jobcost-formula-스티커` | 격자룩업 vs API·합판=별공식 vs pjoin | A-2 |
| **PMD-3** | `formula-PRF_DGP_A`(원자합산형·투명) | `wow-jobcost-formula-40346` | 원자합산(구성요소 가산·투명) vs 조회(은닉) | A-3 |
| **PMD-4** | `formula-PRF_CLR_ACRYL/POSTER_WATERPROOF`(면적매트릭스·수량축 없음) | `wow-jobcost-formula-40437` | 면적셀 통가 vs 축조합+수량 | A-4 |
| **PMD-5** | `formula-PRF_BIND_MUSEON`+evaluate_set_price(셋트조합 2단) | `wow-jobcost-formula-40196`(단일+coverinfo) | 셋트 부품조립(멤버합산+부모) vs 단일 조회 | A-5 |
| **PMD-6** | `formula-PRF_DGP_E`(원자합산·접지) | `wow-jobcost-formula-40037` | 원자합산 vs API | A-6 |
| **PMD-7** | `formula-PRF_DGP_CAL_WIDE`(원자합산·장수축) | `wow-jobcost-formula-40619`(기성/맞춤) | 업로드 원자합산 vs 조회(기성 포함) | A-8 |
| **PMD-8** | `formula-PRF_TTEOKME_FIXED`(셋트 부모 all-in·권당장수) | `wow-jobcost-formula-40189` | 셋트 고정가+bdl_qty vs 단일 조회 | A-14 |

> **공통 축 상속**: 전 PMD = D0-A(후니 인쇄방식 공식바인딩 ↔ 와우 prsjob 16종 선택) + D0-B(후니 6아키타입 ↔ 와우 단일 jobcost). 최대 델타.

---

## 4. `component_differs`(X-5) — 확정 폐쇄목록 (9쌍)

component↔축. 와우 `ordcost_base` 은닉(GAP-PRICE-3)이라 후니 component ↔ 와우 **입력 축**(prsjob/paper/color/awkjob) 대응까지(내역 map 아님·D0-C 경계).

| edge# | 후니 component(앵커) | 와우 축(앵커) | diff_type | 근거 |
|---|---|---|---|---|
| **CMD-1** | `component-COMP_PRINT_DIGITAL_S1`(인쇄비·판걸이수) | `wow-axis:prsjob`(16)+pjoin(합판/독판) | **인쇄방식 지위**(후니 접힘+판걸이수 계산 vs 와우 1급 축) — 핵심 | D0-A |
| **CMD-2** | `component-COMP_PAPER`(용지비·연당) | `wow-axis:paperno`(papergroup·pgram) | 연당가 구성요소 vs 지질 선택값 | D0-C |
| **CMD-3** | `component-COMP_NAMECARD_FOIL_SETUP`(박 동판셋업 분리) | `wow-axis:awkjob`(박앞/뒷 그룹) | 셋업비 별구성요소 vs 후가공 가산 | A-1 |
| **CMD-4** | `component-COMP_PRINT_SPOT_WHITE_S1`(별색화이트=공정) | `wow-axis:colornoadd`(추가도수) | 별색=공정 vs 추가도수 | A-3 |
| **CMD-5** | `component-COMP_FOLD_LEAF_*`(접지패턴 4구성요소) | `wow-axis:awkjob`(접지 그룹) | 패턴별 구성요소 열거 vs 접지 작업 | A-6 |
| **CMD-6** | `component-COMP_BIND_MUSEON/JUNGCHEOL/PUR`(제본비 부모공식) | `wow-axis:awkjob`(제본 그룹) | 제본=부모공식+구성원분해 vs 후가공 | A-5 |
| **CMD-7** | `component-COMP_POSTER_ARTPRINT_PHOTO`(면적 통가) | `wow-axis:sizeno`+비규격 w/h | [가로×세로]셀 통가 vs 규격선택+non_standard | A-4 |
| **CMD-8** | (후니 has_addon 템플릿·엽서봉투/거치대) | `wow-axis:prodaddinfo/optioninfo`(2채널) | addon 단일채널(R14) vs 2채널 경계(D-U14+) | A-3·A-4 |
| **CMD-9** | `component-COMP_TTEOKME`(권당장수 bdl_qty) | `wow-axis:ordqty`(수량) | 권당장수 축 vs 수량 구간 | A-14 |

---

## 5. `mapped_to`(X-2) — 승계 (상위개념 경유 수평 교차)

instance_of 배선 후 **유도**(upper-vocab §2). 명시 배선은 대표 재질/공정/도수만.

| edge# | 후니 노드 | 와우 노드 | 경유 상위 | 비고 |
|---|---|---|---|---|
| MT-1 | `material-MAT_*`(스노우지) | `wow-paper-*`(스노우지·papergroup) | `UPPER_MediaClass`(U-6) | 재질 교차 |
| MT-2 | `process-PROC_*`(코팅/타공/박) | `wow-awkjob-*`(코팅/타공/박) | `UPPER_FinishingOp`(U-8) | 후가공 교차 |
| MT-3 | `printopt-*`(단/양면 도수) | `wow-color-*`(단면칼라/양면칼라) | `UPPER_ColorSpec`(U-5) | 도수 교차 |

---

## 6. 폐쇄목록 준수 요약

- **신규 관계 = X-1·X-3·X-4·X-5 4종만**(X-2 승계). 개방 관계명 금지(§33 D-7·lint L-14).
- **엣지 총계**: same_family_as 16(strong 8·partial 8) · instance_of 11 상위개념(전 브랜드 노드) · price_model_differs 8 · component_differs 9 · mapped_to 대표 3(+instance_of 유도분).
- **양쪽 앵커 병기 필수**(L-X-1) — 편측 앵커 엣지 = FAIL. 앵커 없는 차이 주장 금지.
- **정본 방향** = huni→wow(레드 추가 시 알파벳순). 대칭 순회.

## GAP (정직 기록)

- **G-REL-1**: same_family_as는 **family 단위**만(SFA-1~16). 상품 단위(예 후니 특수지명함 ↔ 와우 40070)는 후속 델타(개별 상품 매핑·G-EDGE-2 승계).
- **G-REL-2**: component_differs는 와우 ordcost_base 은닉으로 **입력 축 대응까지**(GAP-PRICE-3). 후니 구성요소 ↔ 와우 가격내역 직접 엣지 배선 불가(값 경계·의도적).
- **G-REL-3**: partial 정렬군(SFA-7·9~16)은 component_differs 강함 → 상품 단위 재대조 후속(G-ALIGN-3).
- **G-REL-4**: `instance_of` 신규 등재(폐쇄목록 23종째)의 §33 반영 = 아키텍처 게이트(MB7)+인간 승인 후 확정(§33 확장이면 §33 관계목록 머지·독립이면 §35 시드).
- **G-REL-5**: 레드 미포함 → 전 엣지 후니+와우 2브랜드. 레드 추가 시 3자 엣지 append(instance_of 구조·확장 안전).

## Sources
- §35 `02_crossbrand/crossbrand-edges.md`(SFA/PMD/CMD/instance_of/mapped_to 후보·폐쇄목록 준수)·`family-alignment.md`(A-1~16·HO-*·WO-*)·`difference-matrix.md`(D0-A~D·A-* 3축)
- §35 `00_research/upper-ontology-vocabulary.md`(X-1~X-5·§2 설계근거)·`standards-mapping-delta.md`(신규 관계 4)
- §33 `02_ontology/ontology-schema.md`(R1~R19·§9 mapped_to 승계·D-7 개방 관계명 금지)
