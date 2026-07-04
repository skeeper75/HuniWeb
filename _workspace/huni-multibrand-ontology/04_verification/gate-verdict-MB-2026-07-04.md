# MB1~MB7 독립 검증 게이트 판정 — §35 다중브랜드 온톨로지 (Phase 4)

> 판정일: 2026-07-04 · mbo-verify-gate(독립 검증) · 방법론 = `mbo-verify-gate-validation` 스킬.
> **[HARD] 생성≠검증**: 생성자(standards-researcher·catalog-analyst·crossbrand-mapper·ontology-architect) 주장을
> 신뢰하지 않고 catalog JSON 재파싱·`_cache` CSV byte-diff 재현·§33 정본 grep·표준 URL 재조회·codex 교차로 독립 재실측.
> **종합: GO (7/7 게이트 통과).** 결함 = Medium 1 + Low 3(전부 공시·게이트됨·앵커 무결·지어내기 0). 단일 FAIL 없음.
> codex(gpt-5.5, codex-cli 0.142.3) 고위험 3문항 독립 교차 수행 — 주장 2건은 소스 대조로 판정(1 기각·1 Medium 승격).

---

## 0. 판정 요약표

| 게이트 | 판정 | 핵심 재실측 증거 |
|--------|------|------------------|
| **MB1 와우 추출 충실성** | **GO** | `_cache` CSV 4종 재현 = 커밋본과 **byte 단위 IDENTICAL**. 분포 전량 독립 재파싱 일치(selType M311/S12/None3·pjoin 0=174/9=137/1=12·전량 requires-configuration). 40196 책자 papers=152/colors=30/prsjob=15 raw 직접 카운트 일치. 손전사 오염 0 |
| **MB2 표준 인용 실재성** | **GO** | schema.org `isAccessoryOrSparePartFor` 실재(domain Product·주장 일치)·CIP4/XJDF 실 표준단체 확인. candidate(🟡) 항목은 GAP-STD-1/2로 정직 배지. 어휘만 차용(RDF/OWL 기술스택 기각 승계) |
| **MB3 차이 지도 정확** | **GO** | 인용 후니 공식·구성요소 20종 전량 §33 03_kb 실재(지어낸 차이 0). 상품 번호대 7종 실 파일 정합. §33 골든 git-clean(무손상). 차이 행마다 양쪽 앵커 실재 |
| **MB4 상위 온톨로지 건전성** | **GO** | §33 개체17·관계19 실재 확인 → delta 17+5=22·19+4=23 정확. instance_of·교차 3관계 §33에 0회=진짜 신규. mapped_to §9 승계 실재. 접기 2종(U-2·U-7)=search-before-mint 준수. NL 질의 10+ 경로 실 엣지로 성립 |
| **MB5 와우 앵커 닫힌세계** | **GO** | lint L-AN-1 기계검증 실동작(예시 앵커 3종 실 파일·jsonpath resolve). API/PDF 원천 실재·jobcost 엔드포인트 API 문서 실재. 앵커 없는 노드 = upper_concept(+표준근거)·brand·gap만. L-BR/L-AN/L-X/L-UP 기계 검증 가능 |
| **MB6 교차관계 정합** | **GO** | SFA 폐쇄목록(23종) 등재 후 사용. 와우 앵커 17 상품 ID 전량 실재(이름 정합). 비대칭 정직성 실측 검증(와우 카페용품 10 존재=WO-1·아크릴굿즈 0=HO-1). ★Low: 요약 집계 불일치 |
| **MB7 생성검증 독립성 + 권고** | **GO** | 재실측=결정론 재현(복사 아님). 아키텍처 브리프 A/B 균형(codex도 AGREE). 권고 근거 有(H-1 드리프트·§33 안정성·와우 노후). codex 교차 완료 |

**종합 판정: GO** — 단일 FAIL 없음. 아키텍처 결정(§33 확장 vs 독립)은 이 판정을 입력으로 **인간 승인 대기**(`architecture-recommendation.md`).

---

## 1. 게이트별 재실측 상세

### MB1 와우 추출 충실성 — GO
- **재현성 실증(결정론)**: `_cache/_profile_wow.py`·`_categories_reps.py`를 scratchpad 출력으로 재실행 → `wow_products.csv`·`wow_categories.csv`·`wow_representatives.csv`·`wow_size_options.csv` 4종 모두 커밋본과 **byte 단위 IDENTICAL**. 값=스크립트 전사 확증(LLM 손전사 흔적 0).
- **분포 독립 재파싱**: 326상품 전수 재파싱 — selType {M:311,S:12,None:3}·pjoin {0:174,9:137,1:12,None:3}·pricing.status {requires-configuration:326}·pricing.source {/std/prod/jobcost:326}·has_template 6·quotes 0. 전량 structure.md §3·price-mechanism §1 주장과 **정확 일치**.
- **축 커버리지**: sizeinfo 307·paperinfo 276·colorinfo 277·prsjobinfo 319·awkjobinfo 145·prodaddinfo 87·optioninfo 34 = structure §4 일치. 교차제약 color 186·paper 151·size 109 = §5 일치.
- **원자값 직접 검증(스크립트 독립)**: 40196 책자 raw.prod_info 직접 카운트 papers=152·colors=30·prsjob=15 = catalog-map §2 일치. normalized options keys=[orderQuantities,coverTypes,additionalOptions] = "sparse" 주장 정확.
- **가격유형 판정**: templated 6 = 전량 책자(40196/40198/40200/40201/40433/40525)·전량 statusCode 1048 target_bound null 에러. 40200 step "PJOIN 1 SET JOBNO"는 `diagnostics.response.step`에 실재(인용 정확). templated≠정적가격표 판정 타당.
- **멤버십**: 326상품=326멤버십·다중소속 0(1상품 1카테고리) 재검증.

### MB2 표준 인용 실재성 — GO
- schema.org `isAccessoryOrSparePartFor` 1차 조회 = 실재 속성(domain Product·expected Product) = standards-playbook §1.2 주장 일치. 환각 아님.
- CIP4 1차 조회 = 실 표준단체(26개국·XJDF "Exchange Job Definition Format" 발행) 확인.
- **candidate 정직성**: BindingType 열거값·FoldCatalog 명명·PrintMethod XJDF 자원위치는 🟡 candidate로 배지·GAP-STD-1/2로 정직 기록(스펙 PDF 직독 실패 명시). 지어내기 아닌 정직한 GAP.
- 어휘만 차용 준수: JDF/XJDF XML 실구현·RDF/OWL·IOF/BFO는 §33 D-2 승계로 기각(기술스택 미도입).

### MB3 차이 지도 정확 — GO
- **§33 무손상**: `git status _workspace/huni-ontology-kb/` = 클린(변경 0). §33 골든(스키마 v1.0.2·03_kb·build_graph.py) 수정 0.
- **후니 값 정본 일치**: 인용 20종(PRF_NAMECARD_FIXED/FOIL·PRF_STK_FIXED/GANGPAN_FIXED/PACK·PRF_DGP_A/E/CAL_WIDE·PRF_BIND_MUSEON·evaluate_set_price·PRF_CLR_ACRYL·PRF_POSTER_WATERPROOF·PRF_TTEOKME_FIXED·COMP_PRINT_DIGITAL_S1·COMP_NAMECARD_FOIL_SETUP·COMP_PRINT_SPOT_WHITE_S1·COMP_FOLD_LEAF·COMP_POSTER_ARTPRINT_PHOTO·COMP_TTEOKME·COMP_STK_PRINT) 전량 §33 03_kb 실재. **지어낸 차이 0.**
- 상품 번호대 실 파일 정합: 037 오리지널박명함·052 반칼자유형·070 PUR책자·097 떡메모지·120 방수포스터·136 PET배너·147 아크릴마그넷.
- **가격 경계(D-18)**: difference-matrix는 "값 계산 안 함" 명시·후니 evaluate_price/와우 jobcost 권위 병기. axis③ 대조는 "후니 구성요소 ↔ 와우 입력 축"까지(내역 map 아님).

### MB4 상위 온톨로지 건전성 — GO
- **§33 승계 실재**: §33 스키마 v1.0.2·개체17(R1~R19 관계19) 실 확인. delta = 17+신규5(E-U/E18/E19/E20/E21)=22·19+신규4(X-1/X-3/X-4/X-5)=23. **정확.**
- **search-before-mint 준수**: instance_of·same_family_as·price_model_differs·component_differs = §33에 **0회**(진짜 신규). mapped_to = §33 §9 동사 승계(재발명 아님). U-2 ConfigurabilityClass·U-7 ImpositionStrategy는 **접기**(기존 E7/속성 재사용) — 개체화 과잉 회피. 신규 5개체 각각 표준+와우 증거 근거 명시.
- **2층 연결 완결성**: §4 매핑표 22 upper_concept 전부 후니·와우 instance_of 열 채워짐.
- **NL 질의 경로**: Q1~Q10 전부 실 엣지(SFA/PMD/CMD/instance_of)·실 공식으로 경로 성립. Q4(인쇄방식)·Q8(가시성)은 상위층 존재 이유 실증. N1~N6 거절은 의도적 경계(값권위·은닉·미적재·런타임) — 스키마 결함 아님.

### MB5 와우 앵커 닫힌세계 — GO
- **lint 기계검증 실동작**: L-AN-1 시연 — catalog:products/40070.json#raw.prod_info.prsjobinfo(→list)·#meta(→dict)·index.json#productCount(→int) 전부 실 파일·jsonpath resolve. 환각 앵커 차단 규칙 실제 작동.
- 앵커 네임스페이스 3유형(catalog:/wowpress-api:/wowpress-pdf:) 원천 파일 전량 실재. jobcost 엔드포인트(cjson_jobcost) API 문서 실재.
- 닫힌세계 유지: 앵커 none 허용 = upper_concept(+표준근거·L-UP-1)·brand·term·rule·decision·gap·intent만. 와우 실물 노드는 catalog/api/pdf or GAP.
- L-BR-1/2·L-AN-1/2/3·L-X-1/2·L-UP-1 = 전부 기계 검증 가능한 술어(brand 속성·앵커 화이트리스트·파일 존재·_cache 전사·양측 앵커·타입·standard_url).

### MB6 교차관계 정합 — GO
- **폐쇄목록 등재 후 사용**: X-3 same_family_as = crossbrand-relations §0에서 23종째 등재 후 §1에서 16쌍 사용. 개방 관계명 0.
- **앵커 실재**: SFA 16쌍 와우 앵커 17 상품 ID 전량 실재(40070 특수지명함·40437 미니현수막·40196 무선책자·40189 떡메모지 등 이름 정합). 양쪽 앵커 병기(L-X-1).
- **비대칭 정직성 실측**: 와우 catalog 재파싱 — 카페용품 10상품 실존(WO-1=와우강점 정직)·아크릴굿즈(키링/스탠드/코롯토) 0상품(HO-1=후니강점 정직). 1:1 불성립이 사실과 부합·삭제 없이 단면 GAP 보존.
- 정렬 근거 = 3유형(용어/용도/구성) + 확신도 등급(strong/partial). 행별 배정 정확·앵커됨.

### MB7 생성검증 독립성 + 아키텍처 권고 — GO
- **독립성**: 재실측이 생성자 산출 복사 아님 — catalog 독립 재파싱·CSV byte-diff 재현·§33 grep·표준 URL 재조회·codex 교차. 결정론 재현(byte-identical)은 LLM 의견보다 강한 증거.
- **아키텍처 브리프 공정성**: A(§33 확장)·B(독립+연합) 장단점 대칭 제시 + 하이브리드 C + 비교표 9기준. "결정 안 함·인간 승인" 명시. 초기 B/최종 A 권고는 숨은 편향 아닌 명시 분리. **codex도 point 3 AGREE.**
- **codex 교차 결과**(codex-cli 0.142.3·read-only): 3 고위험 문항. point 2(D-18 위반 주장)=소스 대조로 **기각**(하단 §3). point 1(E18/E20 mint)=**Medium 승격**(하단 §2 DEFECT-M1). point 3(브리프 공정)=AGREE.

---

## 2. 결함 보드

| ID | 심각도 | 게이트 | 결함 | 귀속 에이전트 | 교정 방향 |
|----|--------|--------|------|---------------|-----------|
| **DEFECT-M1** | **Medium** | MB4/MB7 | E18 print_method·E20 product_family mint의 fold-vs-mint 경계가 미세 표준 구분(§33 process=Finishing Intent≠Process View 전체·category=브랜드내부 vs family=교차축)에 의존. E18 표준앵커는 candidate(GAP-STD-2). codex가 "process/category 재사용 가능" 문제제기 | ontology-architect | mint 방어 가능(process는 후가공전용·prsjob 담을 §33 노드 부재 실측 확인)이나 **아키텍처 게이트에서 인간이 E18/E20 승격 최종 검증**. 이미 G-SCHEMA-5로 gate+승인 지연 명시 — 결함이라기보다 **인간 검증 항목**. NO-GO 아님 |
| **DEFECT-L1** | Low | MB6 | SFA strong/partial **요약 집계 불일치**: 실제 7 strong/9 partial인데 문서 요약이 "strong 8·partial 8"(2곳)·"strong 6"·"8개 strong"으로 제각각 | crossbrand-mapper | 행별 배정은 정확·앵커 무결. 요약 tally만 7/9로 정정(재게이트 불요·문서 위생) |
| **DEFECT-L2** | Low | MB4 | nl-query Q1이 product-037을 "원터치박명함"으로 라벨(실제 §33=오리지널박명함). 공식 참조(PRF_NAMECARD_FOIL)는 정확 | ontology-architect | 예시 라벨 오기 1건. "오리지널박명함"으로 정정(앵커 무결·경로 유효) |
| **DEFECT-L3** | Low | MB3 | difference-matrix A-2 "PRF_STK_PACK(합가 54장4000)" 서술이 가격값처럼 읽힘 | crossbrand-mapper | **위반 아님**: "54장4000"은 §33/라이브 DB 공식명(frm_nm 스티커팩 합가형(54장1세트 4000)) verbatim 인용. §33 자신도 D-18 명시. 상위 온톨로지 노드는 실 가격값 저장 0(grep 확인). 필요 시 서술에 "(공식명)" 주석 |

**High 결함: 없음. NO-GO 게이트: 없음.**

---

## 3. codex 교차 판정 (주장=가설·소스 대조 후 채택/기각)

| codex 주장 | codex 판정 | 게이트 판정(소스 대조) |
|-----------|-----------|----------------------|
| ① print_method/product_family는 §33 process/category 재사용 가능(needless mint) | DISAGREE | **부분 수용→DEFECT-M1**. §33 process=후가공(Finishing Intent)이라 인쇄방식(prsjob) 담을 노드 부재 실측 확인 → mint 방어 가능. 단 미세 구분·candidate 앵커라 인간 검증 항목으로 승격 |
| ② difference-matrix "54장4000"이 실 가격값 저장=D-18 위반 | DISAGREE | **기각**. §33 03_kb `formula-PRF_STK_PACK` frm_nm="스티커팩 합가형(54장1세트 4000)" verbatim 인용(라이브 t_prc_price_formulas 공식명). §33 자신이 "값 계산=evaluate_price 권위(D-18)" 명시. 상위 온톨로지 노드 실 가격값 grep=0. 위반 아님 |
| ③ 아키텍처 브리프 A/B 편향 | AGREE-GO | 일치. 균형 제시·명시 권고 분리 |

**codex 순효과**: 지어내기·앵커 없는 주장 미발견(재확인). D-18 노드 경계 재확증. E18/E20 mint를 인간 검증 항목으로 부각(가치 有). codex 주장 2건 중 1 기각·1 Medium — 검증 전 채택 금지 원칙 준수.

---

## 4. 재게이트 지침

- **NO-GO 없음** → 교정 루프 불요. DEFECT-L1/L2/L3는 문서 위생(재게이트 불요·다음 편집 시 정정).
- **DEFECT-M1**은 결함이 아니라 **아키텍처 게이트(MB7)+인간 승인의 정식 검증 항목**(E18/E20 mint 승격 확정) — `architecture-recommendation.md` 체크리스트에 반영.
- 재게이트 시 이 파일 **append**(덮어쓰기 금지).

## Sources (재실측 증거)
- catalog 재파싱: `docs/wowpress/catalog/`(index.json·products/326·categories/47) 직접 로드
- CSV 재현: `_cache/_profile_wow.py`·`_categories_reps.py` scratchpad 재실행 → byte-diff IDENTICAL
- §33 정본: `_workspace/huni-ontology-kb/03_kb/`(formula·product)·`02_ontology/ontology-schema.md` grep·git status
- 표준: schema.org/isAccessoryOrSparePartFor·cip4.org 1차 조회
- codex: codex-cli 0.142.3 exec read-only 3문항 교차
