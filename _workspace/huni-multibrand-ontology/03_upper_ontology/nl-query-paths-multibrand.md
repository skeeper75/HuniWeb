# NL 질의 경로 — 브랜드-무관 추천→가격→주문 (§35 Phase 3)

> 작성: 2026-07-04 · mbo-ontology-architect · 방법론 = `mbo-ontology-design` 스킬.
> 승계: §33 `nl-query-paths.md`(질의 경로 증명 패턴)·`ontology-schema.md`(R1~R19). 확장 = **브랜드축 + 교차관계**(same_family_as·price_model_differs·instance_of).
> **[HARD] 요구사항**: 브랜드-무관 대표 질의 ≥8을 상위 온톨로지 위 탐색 경로로 증명. **경로 안 그려지면 스키마 결함**(§4로 환류).
> **[HARD] 가격 경계(D-18)**: 경로는 quote_function(evaluate_price/jobcost) **호출 지점까지**. 값 계산·비교 수치는 서버 권위(온톨로지는 "어디서·무슨 축으로 계산되나"까지).
>
> **읽는 법:** 손님이 자연어로 물으면(예 "카페 오픈 500장 어디가 유리?"), 그래프를 어떤 점·선을 따라 순회해 답을 만드는지 보인다. 브랜드-무관 = 후니·와우를 한 그래프에서 나란히 놓고 비교·추천·견적. 화살표는 그래프 관계(엣지), `[E-U]`=상위 개념 경유.

---

## 0. 질의 유형 3분류 (§33 승계 + 브랜드축 확장)

| 유형 | §33 | §35 확장 |
|---|---|---|
| **T1 사양 기반 추천** | 상품 속성→상품 | + `same_family_as`로 **브랜드 무관** 후보 |
| **T2 용도/의도 추천** | intent→상품군(references) | + 브랜드 교차 후보 |
| **T3 가격 비교/견적** | product→formula→component(evaluate_price 경계) | + **quote_function 브랜드별 분기**(evaluate_price vs jobcost) |
| **T4 교차 비교(신설)** | — | **price_model_differs·component_differs로 "왜 다른가" 설명** |

---

## 1. 브랜드-무관 대표 질의 8+ (경로 증명)

### Q1 (T3·T4) "고급 명함 추천하고, 후니와 와우 가격을 비교해줘"
```
"명함" → [term alias_of] → UPPER_ProductFamily:명함
       → [instance_of⁻¹] → family-명함(huni) · wow-family-명함(wowpress)
family-명함 --same_family_as(SFA-1)-- wow-family-명함        # 교차 후보 확보
"고급" → [material 특수지/펄 + process 박] filter
  huni: product-037(원터치박명함) --priced_by--> formula-PRF_NAMECARD_FOIL --references--> quotefn-huni-evaluate-price
  wow : wow-product-40070(특수지명함) --priced_by--> wow-jobcost-formula --references--> quotefn-wow-jobcost
가격 차이 설명: PRF_NAMECARD_FOIL --price_model_differs(PMD-1)-- wow-jobcost-formula
                (diff: 후니 고정가룩업+박 셋업비 분리 vs 와우 조회 API+박 awkjob 가산)
```
답: 양 브랜드 고급명함 후보 + **각 브랜드 엔진 호출 지점**(값=서버). "왜 가격 구조가 다른가"=PMD-1. **값 비교 수치는 각 엔진 호출 결과**(D-18 경계·온톨로지는 호출까지).

### Q2 (T2·T3) "카페 오픈 기념으로 500장, 어디가 유리해?"
```
"카페 오픈" → INTENT_cafe_opening --references(R19)--> [명함·스티커·쿠폰·전단 상품군]
"500장" → [bundle_qty/ordqty min/max/incr] filter (huni qty-* · wow ordqty)
각 상품군 → same_family_as로 huni·wow 병렬 후보
견적 경로: 각 후보 --priced_by--> formula --references--> quote_function(브랜드별)
```
답: 용도→상품군 매핑 후 브랜드 무관 후보 나열 + 500장 수량규칙 충족분 필터 + 엔진 호출. "유리"의 값 판정=엔진 결과(경계).

### Q3 (T1·T4) "스티커를 도무송(자유형)으로 뽑고 싶은데 두 브랜드 방식이 어떻게 달라?"
```
"스티커" → UPPER_ProductFamily:스티커 → family-스티커 · wow-family-스티커 (SFA-2)
"도무송/자유형" → UPPER_FinishingOp:칼선 → huni process(반칼/완칼) · wow-awkjob(칼선)  [instance_of 경유]
차이 설명:
  가격모델: PRF_STK_FIXED --price_model_differs(PMD-2)-- wow-jobcost   (격자룩업 vs API·합판=별공식 vs pjoin)
  구성:     COMP_STK_PRINT --component_differs(CMD-*)-- wow-axis:awkjob(칼선)
```
답: 같은 상품군(SFA-2)·같은 후가공 개념(FinishingOp)이나 후니=완제품가 격자룩업, 와우=칼선 awkjob 세분 + pjoin 합판. 구조 차이까지.

### Q4 (T4) "왜 후니 명함엔 '인쇄방식' 선택이 없고 와우엔 16가지나 있어?"
```
UPPER_PrintMethodIntent(U-4·D0-A 최대 델타)
  ← instance_of ← printmethod-huni-*(투영·print_option 접힘 + plate/pansu 계산)
  ← instance_of ← wow-prsjob-*(16종: 합판디지털106·합판옵셋47·합판UV17·INDIGO8·옵셋5·윤전…)
설명: 후니는 인쇄방식을 공식 바인딩(PRF_DGP=디지털·PRF_GANGPAN=합판)으로 상품마다 고정·판걸이수 계산으로 흡수.
      와우는 손님이 prsjob 16종 중 선택(1급 가격결정 축).
```
답: 상위 개념(PrintMethodIntent)은 같으나 **브랜드가 그 개념을 다루는 위치**가 다름(후니=암묵 계산·와우=명시 선택). 이 질의는 상위층 없이는 답 불가 → 상위 온톨로지의 존재 이유.

### Q5 (T1·T3) "A4 무선제본 책자 100페이지, 두 브랜드 견적"
```
"책자/무선/A4/100p" → UPPER_ProductFamily:책자 (SFA-5)
  huni: family-책자 → product(무선책자·셋트) --has_member--> 표지/내지/면지 member
        --priced_by--> evaluate_set_price (2단: 멤버 evaluate_price 합산 + 부모 제본공식)
  wow : wow-product-40196(무선책자·단일) --priced_by--> wow-jobcost (coverinfo.pagecnt=100)
구조 차이: PRF_BIND_MUSEON+evaluate_set_price --price_model_differs(PMD-5)-- wow-jobcost
           (후니 셋트 부품조립 2단 vs 와우 단일 상품+coverinfo 옵션)
```
답: 후니=셋트 2단 계산·와우=단일 조회. 페이지축=후니 page_rule 파생 vs 와우 pagecnt. 각 엔진 호출.

### Q6 (T1) "방수 현수막 3x1m, 거치대 포함으로"
```
"현수막/방수/사인" → UPPER_ProductFamily:사인실사 (SFA-4)
  huni: product-136(PET배너) uses_material 방수PET · 거치대=mat_cd 가산 · PRF_POSTER(면적/고정가)
  wow : wow-product-40437(현수막) paperinfo 현수막 · 거치대=prodadd 부자재 · jobcost
"3x1m 비규격" → huni 면적매트릭스 off-grid ceiling / wow non_standard req_width/height (411 에러 가드)
거치대: COMP(후니 mat_cd) --component_differs(CMD-8)-- wow-prodadd(2채널)
```
답: 브랜드 무관 현수막 후보 + 비규격 처리 방식 차이(ceiling vs req_w/h) + 거치대 딸림 방식 차이.

### Q7 (T2) "청첩장/초대장 안내용 카드, 봉투까지"
```
"청첩장·초대장" → INTENT_invitation --references--> UPPER_ProductFamily:엽서카드 (SFA-3)
  huni: product-016(프리미엄엽서) --has_addon--> product-envelope(봉투 템플릿·R14)
  wow : wow-product-40108(청첩장/초대장) + prodadd(엽서봉투)
봉투: 후니 has_addon 단일채널 --component_differs(CMD-8)-- wow prodadd/optioninfo 2채널
```
답: 용도(초대)→엽서카드 상품군·양 브랜드 후보·봉투 딸림. 봉투 모델 차이 설명.

### Q8 (T3·T4) "리플렛 3단접지, 후니는 구성요소가 다 보이는데 와우는 왜 안 보여?"
```
"리플렛/3단접지" → UPPER_ProductFamily:리플렛 (SFA-6) · UPPER_FoldScheme(F6-*)
  huni: PRF_DGP_E --has_component--> [인쇄비·용지비·접지비(패턴별)·코팅]  (투명·D0-C)
  wow : wow-jobcost --ordcost_base(은닉·GAP-PRICE-3)  → 값=ordcost_bill만
가시성 차이: COMP_FOLD_LEAF_* --component_differs(CMD-5)-- wow-axis:awkjob(접지)
```
답: 후니는 formula_components 투명(무엇에 값 매기나 열림), 와우는 ordcost_base 은닉이라 **입력 축까지만** 대조. 값 경계(D-18) 정직 설명.

### Q9 (T1·T4·확장) "캘린더 기성품 vs 맞춤제작, 두 브랜드 뭐가 달라?"
```
UPPER_ProductFamily:캘린더 (SFA-8)
  huni: product-108~112 업로드형(맞춤)·PRF_DGP_CAL_WIDE 원자합산·장수축
  wow : wow-product-40619 기성벽걸이2026(기성) + 맞춤 혼재 · jobcost
차이: PMD-7(후니 업로드 원자합산 vs 와우 조회·기성 포함) · 장수: 후니 축 명시 vs 와우 규격/수량
```
답: 후니=업로드 맞춤 위주·와우=기성+맞춤 혼재. 장수 처리 차이.

### Q10 (T2·교차·후니 강점) "아크릴 키링 굿즈 만들고 싶은데 어디서?"
```
"아크릴 굿즈" → UPPER_ProductFamily:아크릴굿즈
  huni: family-아크릴굿즈(HO-1·product 146~170) --priced_by--> PRF_CLR_ACRYL(면적매트릭스+부속)
  wow : same_family_as 없음 → GAP 단면 노드("와우 카탈로그 부재·아크릴보드는 사인 보드류")
```
답: **후니만 대응**(HO-1 단면 GAP). 정직하게 "와우엔 아크릴 굿즈 상품군 없음". 편향 없이 브랜드 강점 노출.

---

## 2. 답 못하는 시나리오 (경계·정직 거절)

| # | 질의 | 못 답하는 이유 | 정직 응답 |
|---|------|---------------|-----------|
| N1 | "후니 명함이 와우보다 정확히 얼마 싸?" | 값 계산=서버 권위(D-18). 온톨로지는 호출 지점까지·수치 비교 안 함 | "각 브랜드 엔진(evaluate_price/jobcost) 호출 결과로만 확정 — 구조 차이는 PMD-1로 설명 가능" |
| N2 | "와우 리플렛 접지비가 인쇄비의 몇 %?" | 와우 ordcost_base 은닉(GAP-PRICE-3)·내역 map 비공개 | "와우 가격 내역 미공개 — 입력 축(paper/awkjob)까지만·값=ordcost_bill 총액" |
| N3 | "레드프린팅은 이 명함 얼마?" | 레드 미포함(GAP-DELTA-2) | "레드 브랜드 미적재 — instance_of 구조라 red-* 추가 시 확장 가능" |
| N4 | "카페용품 스트로우, 후니엔 어떤 게 있어?" | 후니 KB 미대응(WO-1 단면) | "후니 카탈로그엔 카페용품 없음 — 와우 강점군(WO-1)" |
| N5 | "와우 40297 상품 사양 알려줘" | selType=None·`_TEST` 상품(G-STRUCT-3) | "테스트 상품(_TEST)·유형 미정 GAP" |
| N6 | "이 조합(재질A+후가공B) 주문 가능?" | 와우 req_/rst_ 런타임 강제·jobcost status(402~411)가 판정 | "제약 그래프(constraint/req_·rst_)로 후보 판정·최종 유효성=API status(런타임)" |

---

## 3. 경로 증명 요약 (스키마 결함 없음)

- **T1~T4 전 유형 답됨** — 상위 온톨로지(instance_of)로 브랜드 무관 후보 확보 → same_family_as 교차 → quote_function 브랜드별 분기 → price_model_differs/component_differs로 "왜 다른가" 설명.
- **Q4(인쇄방식)·Q8(가시성)은 상위층 없이 답 불가** → 상위 온톨로지 존재 이유 실증(D0-A·D0-C).
- **Q10·N4는 단면 GAP 정직 노출**(브랜드 강점·편향 없음).
- **가격 경계 준수**: 전 경로 quote_function 호출까지·N1~N2 값 거절(D-18).
- **결함 없음**: 8+ 대표 질의 전부 경로 성립. 못 답하는 6종은 전부 **의도적 경계**(값 권위·은닉·미적재·런타임)이지 스키마 결함 아님.

## GAP
- **G-NLQ-1**: 상품 단위 same_family_as 미배선(family 단위만) → Q1류 "특정 상품 대 상품" 정밀 매칭은 후속 델타(G-EDGE-2).
- **G-NLQ-2**: INTENT_* 코퍼스는 §33 후니 기준 → 와우 용도 코퍼스 미보강. T2 교차는 상품군 경유(intent→family→same_family_as).
- **G-NLQ-3**: 실 질의 응답 품질은 그래프 빌드·질의 엔진 구현 후 실측(이 문서는 경로 설계 증명까지·DB 미적재).

## Sources
- §33 `02_ontology/nl-query-paths.md`(질의 유형·경로 패턴)·`ontology-schema.md`(R1~R19·references R19·intent)
- §35 `crossbrand-relations.md`(SFA/PMD/CMD/instance_of 확정)·`upper-ontology-schema.md`(§4 2층 매핑·E18/E19/E20)·`difference-matrix.md`(D0-A~D)·`family-alignment.md`(HO-*/WO-* 단면)
