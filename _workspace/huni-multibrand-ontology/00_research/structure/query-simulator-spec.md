# 질의 결합 시뮬레이터 명세 (Query→Semantic Combination Simulator)

> 작성: 2026-07-04 · §35 구조 리서치 후속. **설계 명세**(코딩 전 청사진·DB 미적재·생성≠검증).
> 결정 근거: 온톨로지 스튜디오(질의→순회→답+하이라이트) *행위* 채택, 무거운 기질(Neo4j·OCR·임베딩) 기각 → **우리 경량 그래프 + nl-query-paths 위에** 얹음. OntoAir는 시각화 아이디어만(코드 재사용 불가·연구용 비오픈).
> [HARD] 가격/배정 값 = 엔진 권위(D-18/D-ROUTE·시뮬은 호출 지점까지). 라이브 읽기전용. GAP 정직(경로 안 그려지면 스키마 결함 신호).

---

## 1. 목적 (북극성)

고객 자연어 질의 → 상품을 이루는 **원자 의미 단위**들이 그래프에서 **그때 연결(결합)** → 상품 추천 + 가격(엔진 호출) → (추후) 인쇄소 라우팅. 시뮬레이터 = 이 결합을 **실행하고 눈에 보이게** 하는 도구. "온톨로지 스튜디오가 하는 일을 후니 인쇄 도메인에서."

**시뮬레이터 vs 뷰어 구분**: 뷰어(OntoAir)=완성 그래프 구경. **시뮬레이터=질의가 순회를 일으켜 답을 합성**(핵심 차이).

## 2. 채택 모델 (결정)

| 층 | 채택원 | 내용 |
|---|---|---|
| **행위(질의→결합→답)** | 온톨로지 스튜디오 | 질의 입력 → 그래프 순회 → 답 + 순회 경로 하이라이트 |
| **기질(그래프 저장·엔진)** | **후니 경량**(스튜디오 기각) | SQLite 3층·파일=정본/그래프=파생·결정론 트리. Neo4j/임베딩/OWL 미채택(과공학·§33 D-2 승계·Onto-OSINT 외부검증) |
| **순회 로직** | **후니 기존 자산** | nl-query-paths(§33)·nl-query-paths-multibrand Q1~Q10(§35)·nl-query-paths-routing RQ1~RQ6 |
| **시각화 렌더** | 우리 자산 + OntoAir 아이디어 | product_viewer 대시보드·Cytoscape(§29 hpr-dashboard 재사용) + OntoAir 아이디어(개체/클래스 구분·소스↔그래프 양방향 하이라이트) |

## 3. 아키텍처 (5 단계 파이프라인)

```
[질의] → ①용어 해석 → ②경로 순회 → ③경계 호출 → ④답 합성 → ⑤시각화
```

### ① 용어 해석 (Term Resolution)
- 자연어 단어 → 그래프 노드 매핑. 결정론 alias 1차(term alias_of → 노드), 미해결 표현만 임베딩 fallback 보류(구조 리서치 D3·초기 미채택).
- 예: "고급 명함" → {ProductFamily:명함} + {material:특수지/펄, process:박} 필터. "카페 오픈" → INTENT_cafe_opening.
- **원자 의미 결합의 시작점**: 질의를 원자 노드 집합으로 분해(키스톤=intent 원자 분해가 여기서 정밀도 결정).

### ② 경로 순회 (Path Traversal) — 시뮬레이터의 심장
- nl-query-paths에 정의된 관계 경로를 **실행**. 질의 유형(T1 사양·T2 용도·T3 가격·T4 교차)별 순회 규칙.
- 관계 따라감: `instance_of`(상위개념 경유 브랜드무관)·`same_family_as`(교차 후보)·`references`(용도→상품군)·`priced_by`→`has_component`·`capability_covers`(라우팅 포섭).
- 브랜드-무관: 후니·와우를 한 그래프에서 나란히 순회(§35 상위 온톨로지 존재 이유). 레드는 append 시 자동 확장(전이 추론·tykimos 차용).
- **결합 = 이 순회 자체.** 흩어진 원자(용지·박·명함·용도)가 질의 순간 경로로 이어짐.

### ③ 경계 호출 (Engine Boundary) [HARD]
- 순회가 `quote_function`(가격)·`routing_function`(배정) 노드에 닿으면 **거기까지가 온톨로지**. 값은 엔진(후니 evaluate_price·와우 jobcost API·라우팅 스코어링)이 권위.
- 시뮬은 "어디서·무슨 축으로 계산되나"를 보여주고 **호출 지점 표시**. 값 비교 수치는 엔진 결과로만(D-18/D-ROUTE 경계). 못 하는 질의(N1~N6·N-R1~6)는 정직 거절 표시.

### ④ 답 합성 (Answer Synthesis)
- 순회 결과 + 엔진 호출(있으면)을 자연어 답으로. 근거 노드 id·앵커 병기(온톨로지 스튜디오처럼 "[노드: 제27조, entity id …]" → 후니는 "[상품 product-037·공식 PRF_NAMECARD_FOIL]").
- 브랜드 교차 답(PMD/CMD로 "왜 다른가")·단면 GAP 정직 노출(Q10·N4 = 브랜드 강점·편향 없음).
- 파생/추론 엣지엔 confidence + reasoning-log(tykimos 차용).

### ⑤ 시각화 (Visualization)
- **순회한 부분그래프**를 하이라이트(질의 안 닿은 노드는 흐리게 — 온톨로지 스튜디오 2번째 이미지처럼). Cytoscape/force-directed.
- 노드 클릭 → 앵커·출처·속성·연결 툴팁. 소스↔그래프 양방향 하이라이트(OntoAir 아이디어).
- 상위개념(E-U)·브랜드(huni/wow/red)·경계 노드(quote/routing_function) 시각 구분.

## 4. 재사용 자산 (search-before-mint — 새로 만들 것 최소)

| 필요 | 이미 있는 것 | 신규 |
|---|---|---|
| 순회 경로 정의 | nl-query-paths ×3(§33·§35·라우팅) | 실행 엔진(경로→쿼리) |
| 그래프 데이터 | §33 03_kb(275상품)·§35 상위 온톨로지·라우팅 층(형만) | — (읽기 재사용) |
| 그래프 시각화 | product_viewer 대시보드·Cytoscape(§29) | 순회 하이라이트 로직 |
| 가격 값 | evaluate_price·jobcost API | 호출 어댑터(경계) |
| 용어 해석 | term alias(§33)·intent | 원자 분해 정밀화(키스톤) |

**핵심**: 시뮬레이터는 대부분 **기존 자산의 조립**. 새로 만드는 건 ①경로 실행 엔진 ②순회 하이라이트 ③엔진 호출 어댑터 정도.

## 5. 범위·경계

- **시뮬레이터 = 경로 실행 + 시각화 + 엔진 호출 지점까지.** 값 계산 안 함(엔진 권위). 실 주문·결제·적재 안 함(읽기전용·시뮬레이션).
- architecture-neutral: §33 통합/독립 §35 어느 쪽 그래프든 동일 시뮬레이터(경로 정의만 참조).
- 라우팅(③)은 형만 있고 데이터 GAP(공급자 레지스트리 부재) → 라우팅 질의는 "경로는 성립·인스턴스는 candidate/GAP" 정직 표시.
- 생성≠검증: 시뮬 답의 정확성은 nl-query-paths 통과판정·엔진 결과로 검증(자기 승인 금지).

## 6. 단계적 구현 제안 (파일럿 우선)

1. **P1 파일럿** — 한 질의 유형(T3 가격 비교·Q1 "고급 명함 후니vs와우")을 종단 실행(용어→순회→evaluate_price 호출→답+하이라이트). 최소 1브랜드.
2. **P2 확장** — Q1~Q10 브랜드-무관 질의 + 시각화 다듬기(OntoAir 아이디어).
3. **P3 라우팅** — RQ1~RQ6(형만·GAP 정직). 공급자 데이터 확보 후 실동.
4. **P4 자기개선** — 자동 재수집·전이 추론(tykimos 확장-T1/T2).

## 7. GAP / 리스크

- **G-SIM-1**: 순회 엔진은 nl-query-paths를 **실행 가능 쿼리로 형식화**해야(개선-2 CQ 테이블화와 결합). 현재 경로는 산문/의사코드 → 형식 쿼리(재귀 CTE·그래프 순회) 변환 필요.
- **G-SIM-2**: 용어 해석 정밀도 = intent 원자 분해(키스톤)에 의존 → 파일럿과 동시 진행 권장.
- **G-SIM-3**: 시각화 자산(product_viewer·Cytoscape) 실제 재사용성은 코드 확인 필요.
- **G-SIM-4**: 실 질의 품질·결합 정확성은 P1 구현 후 실측(이 문서는 명세까지·DB 미적재).
- OntoAir 코드 재사용 불가(연구용 비오픈)·macOS/RDF 전용 → 아이디어만.

## Sources
- 참조 시스템: [uEngine Ontology Studio](https://github.com/uengine-oss/ontology-studio)(질의→그래프 순회→답+경로 하이라이트·Golden Question) · [tykimos/ontoair](https://github.com/tykimos/ontoair)(시각화 아이디어) · [tykimos/onto-osint](https://github.com/tykimos/onto-osint)(경량 검증·전이추론·자동 루프)
- 후니 자산: §33 `nl-query-paths.md` · §35 `nl-query-paths-multibrand.md`·`nl-query-paths-routing.md`·`upper-ontology-schema.md`·`routing-layer-schema.md` · 구조 리서치 `structure-recommendations.md`·`tykimos-onto-projects-extraction.md` · §29 product_viewer/Cytoscape 대시보드
