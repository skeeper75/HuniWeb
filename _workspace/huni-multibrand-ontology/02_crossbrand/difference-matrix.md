# 3축 차이 매트릭스 — 후니 vs 와우 상품군별 대조 (§35 Phase 2)

> 작성: 2026-07-04 · mbo-crossbrand-mapper. 방법론 = `mbo-crossbrand-mapping` 스킬.
> **정렬 원천** = `family-alignment.md`(A-1~A-16 성립 쌍). 각 쌍에 3축 대조:
> **① 구성요소**(자재·공정·옵션) **② 가격공식**(계산 아키타입) **③ 가격구성요소**(무엇에 값을 매기나).
> **[HARD] 양쪽 앵커 병기**·앵커 없는 차이 주장 금지. 값 대조는 경계 밖(§33 D-18) — **가격 값 계산 안 함**.
> 값 권위 = 후니 `evaluate_price`/`evaluate_set_price`(Railway 서버) · 와우 `POST /std/prod/jobcost`→`ordcost_bill`.
> **brand 열 = huni / wowpress / [red 미포함]**(레드 추가 시 열 증설).
>
> **읽는 법:** "같은 상품군인데 어떻게 다른가"를 세 관점으로 본다. ①은 무엇으로 만드나, ②는 값을 어떻게 계산하나,
> ③은 무엇에 돈을 매기나. 셋 다 "구조·모델의 차이"까지만 — 실제 금액 대조는 하지 않는다(엔진/API 권위).

---

## 0. 전 상품군 공통 델타 (모든 A-* 쌍에 상속) — 먼저 읽을 것

세 축에서 상품군과 무관하게 반복되는 브랜드 구조 차이. 개별 쌍 표는 이 공통 델타 위에 상품군 특수 차이만 얹는다.

### ★핵심 델타 D0-A — PrintMethodIntent(인쇄방식) 지위 (standards-mapping D-U4·U-4)

| 축 | 후니(huni) 앵커 | 와우(wowpress) 앵커 | 차이 요지 |
|---|---|---|---|
| 인쇄방식 지위 | print_option에 접힘·"비절대축"·`axis/print-options.md`(도수=POPT_*·인쇄방식은 공식선택으로 암묵) | **1급 가격결정 축** `prsjobinfo[].jobno`(그룹 jobpresetno)·`catalog:products/*.json#raw.prod_info.prsjobinfo` | 후니는 인쇄방식을 **공식 바인딩**(PRF_DGP=디지털·PRF_GANGPAN=합판도무송·PRF_POSTER=실사)으로 상품마다 고정. 와우는 손님이 **prsjob 16종 중 선택**(합판디지털106·합판옵셋47·합판UV17·INDIGO8·옵셋5·윤전R2R3…·`_cache/wow_domain_prsjob.csv`) |
| 합판/독판 | `plate_size`+`fn_calc_pansu`(판걸이수·판형 자동선택·`axis/plate-sizes.md`)로 **암묵 흡수**(종이류만) | `pjoin` 명시 축(합판9=137상품·독판0=174·별도1=12·`#raw.prod_info.pjoin`) + prsjob 접두 "합판/독판" | 후니 = 합판을 판형·판걸이수 **계산**으로 처리(고객 미선택). 와우 = 합판/독판을 **상품구분·인쇄방식 선택값**으로 노출 |

→ **이 델타가 최대 구조적 차이.** 후니 온톨로지엔 대등한 인쇄방식 노드가 없어 U-4 `PrintMethodIntent` 신설로 양 브랜드 대등 표현 필요(후니는 print_option 접힘분 + plate/pansu 계산을 U-4로 투영). 전 A-* 쌍의 axis②·③에 상속. 교차엣지 = `price_model_differs`(인쇄방식 처리 위치 상이).

### D0-B — 가격공식 아키타입 다형성 (axis ② 공통·U-16 PriceModel)

| brand | 가격 계산 구조 | 앵커 | 요지 |
|---|---|---|---|
| huni | **다형 내장 아키타입 6종**: 원자합산형(PRF_DGP_*)·고정가(PRF_NAMECARD_*/STN_*)·완제품가룩업(PRF_STK_FIXED)·면적매트릭스(PRF_CLR_ACRYL/POSTER)·면적+부속(PRF_ACRYL_MAGNET)·셋트조합(evaluate_set_price) | `03_kb/formula/*.md`·`t_prc_price_formulas` | 상품군마다 다른 계산 아키타입을 **DB 공식으로 내장**. 값=evaluate_price 서버 |
| wowpress | **단일 메커니즘**: 전 326상품 축조합 입력 → `POST /std/prod/jobcost` → `ordcost_bill`. catalog에 정적 가격표 **0**(전량 `pricing.status=requires-configuration`·`price-mechanism §1`) | `wowpress-api:6.4`·`catalog:products/*.json#pricing.status` | 아키타입 구분 없이 **API 조회 하나**. "templated 6"=payload 템플릿(정적표 아님·전량 책자·error 상태) |

→ 교차엣지 `price_model_differs`(전 쌍): 후니 = **상품군별 내장 아키타입**, 와우 = **단일 조회 API**. 값 권위는 둘 다 서버(경계 동형·D-18). U-18 `QuoteFunction`(표준 공백)으로 상위 통일.

### D0-C — 가격구성요소 가시성 (axis ③ 공통·U-17 PriceComponent)

| brand | 구성요소 표현 | 앵커 | 요지 |
|---|---|---|---|
| huni | `t_prc_formula_components`(COMP_* + `use_dims` 차원 + `addtn`/`disp_seq` 배선 한정자) **투명** | `formula/*.md` has_component 배선 | 무엇에 값을 매기는지 구성요소 노드로 열림(인쇄비·용지비·공정비·판걸이수) |
| wowpress | `ordcost_base`(map) **은닉·미공개** | `wowpress-api:6.4#ordcost_base`·GAP-PRICE-3 | 구성 내역 map 스키마 비공개 → KB 재현 안 함(§33 D-18 경계). 값=ordcost_bill만 |

→ 후니는 가격구성요소를 축 단위로 대조 가능, 와우는 **은닉**이라 대조가 "입력 축→ordcost_bill" 수준까지만. component_differs는 후니 구성요소 ↔ 와우 **입력 축**(prsjob/paper/color/awkjob) 대응으로 표현(내역 map 아님).

### D0-D — 교차축 제약 세분성 (구성요소 부속·U-15 CrossAxisConstraint)

- 후니: `t_prd_product_constraints`(JSONLogic·CN-1~6·상품/그룹 단위·`price-impact-constraint`) — 위젯/주문이 validate(evaluate_price는 제약 미참조).
- 와우: 인라인 `req_*`/`rst_*`(option-item 세분·186 도수·151 재질·109 규격 상품·`structure §5`) + jobcost status(402~411)가 **런타임 강제**(price-mechanism §4). 가격조회 = 유효성 검증자.
- → 세분성 차이: 후니 = 상품/그룹 규칙, 와우 = option-item 인라인 + API status. 전 쌍 상속(standards D-U15+).

---

## 1. 상품군별 3축 대조 매트릭스

각 쌍 = 3행(구성요소·가격공식·가격구성요소). 공통 델타(§0)는 "→D0-*"로 참조하고 **상품군 특수 차이만** 기술.

### A-1 명함 (huni 031~040 ↔ wow 명함 43·특수지명함40070)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | material(특수지/펄/투명)·process(박PROC/귀돌이/형압)·print_option 도수 · `product-037-original-foil-namecard` | paperinfo 15~17재질·awkjobinfo 6~7후가공(박앞/뒷·타공)·colorinfo 2도 · `catalog:products/40070.json#raw.prod_info` | 자재폭 유사. 후니=박을 공정+동판셋업 구성요소(COMP_NAMECARD_FOIL_SETUP)로 분해, 와우=박을 awkjob(박앞면/박뒷면 그룹)으로 |
| 가격공식 | **고정가(용지포함)** PRF_NAMECARD_FIXED/COAT/SHAPE/FOIL/CLEAR([siz_cd,qty] 룩업+박 동판셋업) → D0-B huni | jobcost 조회(→D0-B wow) | price_model_differs: 후니 고정가 룩업 vs 와우 API. 후니 박=본체단가+셋업비 2구성요소, 와우 박=awkjob 가산 |
| 가격구성요소 | 완제품가(용지포함 통가)·박 setup 분리·면 동일가 · COMP_NAMECARD_FOIL_S1/SETUP | prsjob(합판옵셋/디지털)·paperno·colorno·awkjob(박) → ordcost_base 은닉(D0-C) | 후니=명함 인쇄방식을 공식에 고정, 와우=prsjob 선택(합판디지털 vs 옵셋)이 가격 가름 → **D0-A** |

### A-2 스티커 (huni 051~067 ↔ wow 스티커 45·가성비도무송40008)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | material(반칼/완칼 소재)·process(도무송 커팅 COMP_STK_PRINT)·규격/자유형 · `product-052-sticker-halfcut-freeform` | paperinfo 3재질·규격 45(비규격 non_standard)·awkjob(칼선/재단) · `catalog:products/40008.json#raw.prod_info.sizeinfo` | 둘 다 도무송/규격 구분. 후니=완제품가에 커팅 포함(룩업), 와우=칼선 awkjob 세분 |
| 가격공식 | **완제품가 룩업형** PRF_STK_FIXED(siz×mat×qty 격자)·PRF_GANGPAN_FIXED(합판도무송)·PRF_STK_PACK(합가 54장4000) — 원자합산 아님 | jobcost 조회 | price_model_differs: 후니 격자 룩업(단일 COMP), 와우 API. 후니 합판도무송=별 공식(합판 프로레이팅), 와우=pjoin+prsjob |
| 가격구성요소 | 완제품 통가(출력+가공)·소재 연당가 미포함·[siz,mat,qty] · COMP_STK_PRINT/GANGPAN_PRINT | sizeno(45)·paperno·awkjob(칼선)·ordqty(구간) → 은닉 | 후니=격자 셀 통가, 와우=축조합+수량 비선형(price-mechanism §4). 규격폭 와우 45 vs 후니 등록규격 |

### A-3 엽서·카드 (huni 016~030 ↔ wow 프리미엄엽서40346·행택/청첩장)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | material(고평량지·투명PET)·process(코팅/오시/미싱/귀돌이/가변텍스트)·도수+별색화이트(COMP_PRINT_SPOT_WHITE) · `formula-PRF_DGP_A` | paperinfo 10재질·awkjobinfo 6후가공·colorinfo 2도·prodadd 1(엽서봉투) · `catalog:products/40346.json#raw.prod_info` | 유사. 후니=별색화이트를 별 구성요소(spot=공정)로, 와우=colornoadd(추가도수)로 |
| 가격공식 | **원자합산형** PRF_DGP_A(인쇄비+별색+용지비+공정비 별도합산·9~11 구성요소) | jobcost 조회 | price_model_differs: 후니 원자합산(구성요소 가산), 와우 API. 후니 구조 투명(D0-C) |
| 가격구성요소 | 인쇄비(판걸이수 기반)·용지비·공정별(코팅/오시/미싱/모서리/가변) 각 별도 · COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_PP_* | prsjob·paperno·colorno(+add)·awkjob(6)·prodadd → 은닉 | 후니 판걸이수(fn_calc_pansu·U-7) 명시 vs 와우 pjoin/prsjob(D0-A). 봉투: 후니 has_addon 템플릿 vs 와우 prodadd |

### A-4 사인·실사 (huni 118~145 ↔ wow 사인제품 51·현수막40437)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | material이 상품 가름(방수PET/아트/캔버스/폼보드)·비종이류(판형없음)·거치대 가산(mat_cd) · `product-120-waterproof-poster`·`product-136-pet-banner` | paperinfo 1(현수막)·규격6·awkjob 2·prodadd 2(거치대) · `catalog:products/40437.json#raw.prod_info` | 유사(소재가 상품 가름). 후니 거치대=mat_cd 가산, 와우 거치대=prodadd 부자재 |
| 가격공식 | **2모델**: 면적매트릭스형([가로×세로] 셀·off-grid ceiling·PRF_POSTER_WATERPROOF) / 고정가형(등록규격 룩업·폼보드130·PET배너136) | jobcost 조회 | price_model_differs: 후니 면적매트릭스(가로×세로 2축) vs 와우 API(sizeno 규격 선택+비규격 w/h). **면적 개념 후니 명시·와우 non_standard w/h로** |
| 가격구성요소 | 완제품 통가(소재+출력+가공)·**수량축 없음**(면적셀=통가)·[siz_width×siz_height] · COMP_POSTER_ARTPRINT_PHOTO | sizeno/비규격 width·height·paperno·awkjob·prodadd·ordqty → 은닉 | 후니 면적형=수량축 제거(팩§3.4), 와우=ordqty 유지(구간). off-grid: 후니 ceiling, 와우 req_width/height(411 에러) |

### A-5 책자 (huni 068~107 ↔ wow 책자 6·무선책자40196)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | 셋트 = 표지member+내지member+면지member+제본부모공식(COVERBIND/제본비)·페이지축 · `formula-PRF_BIND_MUSEON`·has_member | paperinfo **152**·colorinfo 30(표지/내지 페이지별)·awkjob 9·`coverinfo.pagelist`+pagecnt·prsjob 15 · `catalog:products/40196.json#raw.prod_info` | 후니=셋트(부품조립·has_member R13), 와우=단일 상품에 표지/내지 옵션 내장(coverinfo). **구조 근본 상이** |
| 가격공식 | **셋트조합** evaluate_set_price=구성원 evaluate_price 합산+부모공식+할인(2아키타입: 원자합산 COVERBIND / 부모 all-in 고정가 PRF_PCB_FIXED) | jobcost 조회(+ 6상품만 payload 템플릿·전량 error 상태·price-mechanism §2) | price_model_differs 강함: 후니 **2단 계산**(멤버+부모), 와우 단일 jobcost. 와우 책자만 templated 시도(성공샘플0·GAP-PRICE-2) |
| 가격구성요소 | 제본비(중철/무선/PUR/트윈링)·표지(인쇄+코팅+용지 3비목)·내지(페이지 파생 PRF_DGP_INNER)·면지(기여0) | prsjob·paperno(152)·colorno(30)·awkjob(제본 그룹)·pagecnt(페이지) → 은닉 | 후니=제본을 부모공식+구성원 분해, 와우=제본을 awkjob(제본 그룹)+coverinfo. 페이지: 후니 page_rule 파생 vs 와우 pagecnt |

### A-6 리플렛·접지 (huni 048~050 ↔ wow 리플렛40037)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | FoldScheme 접지패턴(반/3단/4단아코디언/게이트·COMP_FOLD_LEAF_*)·오시+접지 · `formula-PRF_DGP_E` | paperinfo 74·awkjob 10(오시/접지)·colorinfo 14·pjoin1 · `catalog:products/40037.json#raw.prod_info` | 유사(접지 후가공). 후니=접지패턴을 4개 구성요소로 열거, 와우=접지 awkjob 그룹 |
| 가격공식 | **원자합산형** PRF_DGP_E(인쇄+코팅+용지+접지 folds 별도합산) | jobcost 조회 | price_model_differs: 후니 원자합산 vs 와우 API |
| 가격구성요소 | 인쇄비·용지비·접지비(패턴별)·코팅 · COMP_FOLD_LEAF_* | prsjob·paperno(74)·colorno·awkjob(접지)·ordqty → 은닉 | FoldScheme(U-10): 후니 패턴별 구성요소 vs 와우 awkjob(접지 작업). D0-A 상속 |

### A-8 캘린더 (huni 108~112 ↔ wow 캘린더 7·벽걸이40619)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | material·process(캘린더제본/트윈링 COMP_BIND_CAL_WALL)·장수(낱장) · `formula-PRF_DGP_CAL_WIDE` | paperinfo 2·colorinfo 4·규격9·pjoin9(합판)·기성/맞춤 · `catalog:products/40619.json` | 후니=단품 공식(셋트아님)·업로드형. 와우=기성 벽걸이(2026 기성품)+맞춤 혼재. 제본 유사(트윈링) |
| 가격공식 | **원자합산형** PRF_DGP_CAL_DESK/WIDE(인쇄+용지+캘린더제본) | jobcost 조회 | price_model_differs: 후니 원자합산 vs 와우 API. 후니 장수→인쇄비 반영(page_rule gap) |
| 가격구성요소 | 인쇄비·용지비·제본비(캘린더가공+제본+삼각대)·장수 | prsjob·paperno·colorno·규격·ordqty → 은닉 | 후니 장수 축 명시 vs 와우 규격/수량. 기성품: 와우 pricing=조회, 후니는 업로드 공식 |

### A-14 굿즈·판촉(떡메모지) (huni 097·098·183~225 ↔ wow 떡메모지40189/40083·판촉물)

| 축 | 후니(앵커) | 와우(앵커) | 차이 요지 |
|---|---|---|---|
| 구성요소 | 떡메모지=셋트(내지 member)·굿즈=material 다양(우드/린넨/규조토/텀블러) · `formula-PRF_TTEOKME_FIXED`·`product-190~199` | 떡메모지=규격11·paper1·color1·awkjob1·add1·`catalog:products/40189.json` | 후니 떡메모지=셋트(권당장수 bdl_qty), 와우=단일 상품. 굿즈 자재폭 후니 넓음(HO-5) |
| 가격공식 | 떡메모지=셋트 부모 all-in 고정가(PRF_TTEOKME_FIXED·bdl_qty 50/100)·굿즈=고정가/면적 다양 | jobcost 조회 | price_model_differs: 후니 셋트/고정가 다형 vs 와우 단일 API. 권당장수 축 후니 명시 |
| 가격구성요소 | 완제품가(사이즈·권당장수·수량)·구성원 내지 · COMP_TTEOKME | 규격·paper·color·awkjob·prodadd·ordqty → 은닉 | 후니 bdl_qty(권당장수) 축 vs 와우 ordqty. component_differs 강함(구조 상이) |

> A-7·A-9~A-13·A-15·A-16 = 공통 델타(§0) 상속 + partial 정렬(family-alignment G-ALIGN-3). 상품군 특수 차이는 후속 델타(개별 상품 매핑 시)로 확장. 핵심 3축 패턴은 위 대표 쌍과 동형(구성요소=자재/공정 대응·가격공식=아키타입 vs jobcost·가격구성요소=투명 vs 은닉+D0-A).

---

## 2. 후니-only / 와우-only 상품군의 3축 (대조 상대 없음·단면 기록)

| 상품군 | 존재 brand | 3축 특성(단면) | 대조 불가 사유 |
|---|---|---|---|
| 아크릴 굿즈(HO-1) | huni만 | 구성요소=아크릴3T+부속(자석/집게/헤어끈)·공식=면적매트릭스(PRF_CLR_ACRYL 277셀)+면적+부속선택·구성요소=면적셀+부속별도합산 | 와우 아크릴보드=사인 보드류(굿즈 아님)·same_family 미성립 |
| 봉제 파우치·에코백(HO-2) | huni만 | 구성요소=봉제원단(레더/캔버스/타이벡/메쉬)·공식=고정가 by siz·구성요소=완제품가 | 와우 어패럴=티셔츠(봉제 파우치 부재) |
| 문구 다이어리 셋트(HO-3) | huni만 | 구성요소=표지member(면지/내지 없거나 소수)·공식=셋트 부모 all-in 고정가(PRF_STN_*·sparse grid)·구성요소=완제품가 by [siz,qty] | 와우 서식류=영수증/NCR(다이어리 부재) |
| 카페용품(WO-1) | wow만 | 구성요소=스트로우/컵(비종이·paper0)·공식=jobcost·pjoin9·구성요소=축조합 | 후니 KB 미대응 |
| 서식류·NCR(WO-2) | wow만 | 구성요소=NCR지(도수18)·공식=jobcost·구성요소=색분해 다도수 | 후니 KB 미대응 |
| 와우기획상품(WO-3) | wow만 | 전 축 0(샘플팩·번들·G-MAP-3) | 표준 6축 미적용·후니 미대응 |

---

## 3. 매트릭스 요약 (architect 입력)

- **최대 델타 = D0-A PrintMethodIntent**(전 쌍 상속): 후니 print_option 접힘 + plate/pansu 계산 ↔ 와우 prsjob 1급 축(16종). U-4 신설 필요. `price_model_differs` 주근거.
- **가격공식 델타 = D0-B**: 후니 **아키타입 6종 내장**(원자합산/고정가/완제품가룩업/면적매트릭스/면적+부속/셋트조합) ↔ 와우 **단일 jobcost API**. 값 권위 둘 다 서버(경계 동형·D-18).
- **가격구성요소 델타 = D0-C**: 후니 `formula_components` **투명**(COMP_*·use_dims) ↔ 와우 `ordcost_base` **은닉**. component_differs는 후니 구성요소 ↔ 와우 **입력 축**(paper/color/prsjob/awkjob) 대응까지만.
- **구조 근본 차이(A-5 책자)**: 후니 **셋트=has_member 부품조립**(2단 계산) ↔ 와우 **단일 상품+coverinfo 옵션**. 셋트 아키타입은 후니 특유.
- **판걸이수(U-7 ImpositionStrategy)**: 후니 fn_calc_pansu 명시 ↔ 와우 pjoin(합판9/독판0) 이진. 전 종이류 쌍 상속.

## GAP (정직 기록)

- **G-DIFF-1**: 와우 `ordcost_base`(가격 내역 map) 미공개(GAP-PRICE-3) → 후니 formula_components ↔ 와우 내역 **직접 대조 불가**. axis③ 대조는 "후니 구성요소 ↔ 와우 입력 축"까지(내역 아님). 값 권위 경계상 의도적.
- **G-DIFF-2**: 와우 jobcost payload 전개 JSON 미확보(GAP-PRICE-1) → prsjob 맵 내부 필드 정확 배치(sizeno/paperno 위치) 미확정. 인쇄방식↔구성 결합 세부는 라이브 호출/PDF 필요.
- **G-DIFF-3**: A-7·A-9~A-16 상품군 특수 3축은 공통 델타 상속만 기록(개별 상품 대조는 후속). partial 정렬군은 component_differs가 강해 후속 델타에서 상품 단위 재대조 필요(G-ALIGN-3).
- **G-DIFF-4**: 후니 값(evaluate_price)·와우 값(jobcost) 둘 다 이 문서에서 계산 안 함(D-18). "값이 얼마 다른가"는 경계 밖 — 추천 근거는 축·모델 차이까지.
- **G-DIFF-5**: 레드 미포함. 레드 열 추가 시 각 axis 행에 red 앵커 append(brand 축 확장 안전).

## Sources
- 후니: §33 `03_kb/formula/{digital,sticker,set,acrylic,stationery}-formulas.md`·`axis/{print-options,plate-sizes,categories}.md`·`02_ontology/ontology-schema.md`(R1~R19)
- 와우: §35 `01_analysis/wowpress-{structure,price-mechanism,catalog-map}.md`·`_cache/wow_domain_prsjob.csv`(인쇄방식 16)·`wow_products.csv`(pjoin)
- 상위 축: `00_research/upper-ontology-vocabulary.md`(U-4·U-7·U-15·U-16·U-17·U-18)·`standards-mapping-delta.md`(D-U4 최대 델타)
