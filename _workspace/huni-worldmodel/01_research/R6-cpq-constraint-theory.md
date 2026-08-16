# R6 — 제품 컨피규레이터 / CPQ 제약이론 정통 조사

> 조사일: 2026-08-15 · 대상: (a) CSP 모델링 표준 (b) 조합폭발 대응 검증된 기법 (c) 상용 CPQ의 규칙 데이터모델 (d) 가격-구성 결합 방식 (e) 탐색→대화 전환 시도
> 평가 기준: **후니프린팅 실측 조합 규모(10¹⁵ 자릿수)에서 실제로 작동하는 기법만 채택**

---

## 요약

1. 제품 구성은 40년 된 AI 문제이며 표준 모델은 **CSP → Conditional/Dynamic CSP(Mittal & Falkenhainer 1990)** 다. 변수 집합 자체가 선택에 따라 생겼다 사라지는 것이 구성 문제의 본질이고, 인쇄 옵션(후가공 켜면 하위 축이 생김)은 정확히 이 형태다.
2. **10¹⁵ 라는 숫자는 난이도 지표가 아니다.** 컴파일 표현(BDD/MDD/d-DNNF)의 크기는 해(解)의 개수가 아니라 제약의 **구조**로 정해진다. 후니 실측 산식이 보여주는 "거의 독립인 축들의 곱" 구조는 컴파일 관점에서 **최선의 경우**에 가깝다(곱이 아니라 합으로 표현됨).
3. 상용 CPQ는 두 계열로 갈린다 — **제약 기반 solver 계열**(Tacton·Configit·SAP constraint)과 **규칙 행(row) 기반 절차 계열**(Salesforce CPQ). 후자는 규칙 수가 조합에 비례해 폭발하고 평가 순서에 종속된다. 현재 후니의 `t_prd_product_constraints`(JSONLogic)는 **후자 형태**다.
4. 가격은 "제약으로 푸는 방식"과 "사후 계산" 둘 다 정통 근거가 있다. 가산(additive) 비용은 MDD 위에서 실용적이지만 **다중 비용은 NP-hard**(Andersen·Hadzic·Pisinger, JAIR 37, 2010). 인쇄 가격은 판걸이·구간할인 때문에 비가산이므로 **사후 계산 단일권위 + 컴파일 레이어의 단조 하한 비용** 이중 구조가 현실적이다.
5. "탐색이 아니라 대화"는 이미 이론·상용 양쪽에 존재한다. 최적 대화 전략 자체는 **NP-hard / PSPACE**(Di Noia 외, 2021)이지만, **컴파일 표현 위에서는 model counting이 다항시간**이라 "다음 질문 = 정보이득 최대 축"을 실제로 계산할 수 있다. 이것이 후니가 취할 경로다.

---

## 본문

### 0. 먼저 — 우리 쪽 숫자부터 바로잡는다 [검증]

의뢰문의 `4,314,196,940,625,000` 은 **이미 폐기된 값**이다. 프로젝트 자체 게이트에서 성원애드피아 코팅 축을 3→2로 교정하면서 값이 바뀌었다.

| 항목 | 값 | 근거 |
|---|---:|---|
| 의뢰문 인용값 (구) | 4,314,196,940,625,000 | — |
| **현행 확정값 (성원 일반지명함)** | **2,876,131,293,750,000** (≈2.88×10¹⁵) | `_workspace/print-story/02_capture/complexity-metrics.md:105` · 교정 이력 `_workspace/print-story/06_artifact/build-notes.md:150` |
| 와우프레스 | 890,503,269,495,840 (≈8.91×10¹⁴) | `complexity-metrics.md:80` |
| 레드프린팅 | 1,432,200 | `complexity-metrics.md:26` |

또한 **"하한(lower bound)"이라는 프레이밍도 같은 게이트에서 폐기**됐다. 원문 규정은 이렇다 — 자유 입력(mm·수량) 제외는 값을 낮추는 방향, 종속 축 미보정은 높이는 방향이므로 **"하한값도 상한값도 아니고 자릿수를 보는 값"**(`complexity-metrics.md:38`). 이 문서는 그 규정을 따른다. 아래 평가는 전부 **"10¹⁵ 자릿수"** 기준이며, 정확한 유효 구성 수는 미측정이다(→ 미해결 §1).

---

### (a) 제품 구성을 CSP로 모델링하는 표준 방식

#### a-1. 구성 과제의 원 정의

Mittal & Frayman(IJCAI-89)은 구성 과제를 "고정된 사전정의 컴포넌트 집합 + 속성·포트·연결제약·구조제약이 주어졌을 때, 요구를 만족하는 구성을 만들거나 **요구 사이의 비일관성을 검출**하는 것"으로 정의했다. 원 탐색공간이 `√((pN)!)` 규모이며 **포트별 지역 제약의 조기 적용**만이 공간을 다룰 크기로 줄인다고 명시한다. 논문이 든 구성 도메인 예시에 **printing presses**가 이미 들어 있다 (`_workspace/print-story/04_thesis/thesis-arc.md:119`, `:259`).

여기서 이미 결론 하나가 나온다: **"만들기"와 "비일관성 검출"이 같은 문제의 두 출력**이다. 즉 "이 주문은 접수하면 안 됩니다 + 왜"는 부가기능이 아니라 구성 엔진의 1급 출력이다.

#### a-2. 표준 형식화 3단계

| 단계 | 형식 | 표현하는 것 | 인쇄 도메인 대응 |
|---|---|---|---|
| **① 고전 CSP** `⟨X,D,C⟩` | 변수·유한도메인·제약 | 모든 변수가 항상 값을 가짐 | 용지·평량·규격·수량처럼 항상 정해야 하는 축 |
| **② Conditional / Dynamic CSP** | + **activity constraint** (변수의 활성/비활성) | 선택에 따라 변수가 생기고 사라짐 | 박 = OFF면 `박종류/박면/박내용` 변수 자체가 없음 |
| **③ Generative / component-port CSP** | + 컴포넌트 개수 자체가 변수 | 구성요소 수가 미정 | 셋트상품(부품조립형), 페이지 수 가변 책자 |

②가 이 도메인의 최소 요건이다. Mittal & Falkenhainer(AAAI-90, "Dynamic Constraint Satisfaction Problems", pp.25–32)의 핵심 관찰이 정확히 우리 상황이다 — 구성·모델합성 같은 합성(synthesis) 과제에서는 **해에 관여하는 변수 집합이 문제 풀이 도중의 결정에 반응해 동적으로 바뀐다**. 이후 Sabin & Freuder 계열의 Conditional CSP(CCSP), Gelle & Faltings의 Mixed/Conditional CSP가 이를 정련했고, "존재할 수도 안 할 수도 있는 잠재변수(potential variable)" 개념으로 정착했다(예: 선루프가 있어야 선루프 종류가 의미를 가짐).

> **[중요] 후니의 옵션 트리는 지금 ②를 ①로 눌러 담고 있다.** 성원 산식(`complexity-metrics.md:86–105`)이 `박(1+3면×14종×2내용=85)`처럼 **"OFF" 를 도메인 값 1개로 인코딩**한 것이 그 증거다. 이건 유효한 CCSP→CSP 인코딩(널 값 추가)이지만, 제약을 쓸 때 "박이 꺼졌으면 박종류 제약은 평가하지 않는다"를 매번 손으로 써야 하는 비용을 낳는다.

#### a-3. 대표 해결기

| 계열 | 대표 | 구성 문제에 쓰이는 이유 | 한계 |
|---|---|---|---|
| CP solver (전파+백트래킹) | Choco, Gecode, OR-Tools CP-SAT | 확장 제약(table constraint)·GAC 전파가 강력, 모델링 자유 | 매 상호작용마다 재탐색 → **완전한 유효도메인 보장은 비쌈** |
| SAT / SMT | MiniSat, Z3 | 부울 옵션·기능모델(feature model)에 자연스러움 | 카운팅·유효도메인은 별도 #SAT 필요 |
| ASP (Answer Set Programming) | clingo | activity constraint·기본부정(default negation)이 언어에 내장 → **DCSP 직역** | 대규모 인터랙션 응답성은 별도 설계 |
| **컴파일 계열** | BDD / MDD / d-DNNF / SDD | **오프라인 1회 컴파일 → 온라인 다항시간 질의** | 컴파일 크기가 폭발할 수 있음(구조 의존) |
| 상용 constraint engine | Tacton, Configit VT, SAP constraint | 위를 제품화 | 블랙박스 |

Junker의 *Configuration* 장(Rossi·van Beek·Walsh 편, *Handbook of Constraint Programming*, Elsevier, 2006)이 이 계보의 표준 서베이다. [추정] 본 조사에서 해당 챕터 원문 URL은 검증하지 못했으므로 서지 사실로만 인용한다.

---

### (b) 조합 폭발을 다루는 검증된 기법 — 무엇이 10¹⁵에서 살아남는가

#### b-1. 먼저 오해를 제거한다: 해의 개수 ≠ 표현의 크기

**BDD는 2ⁿ개의 모델을 O(n) 노드로 표현할 수 있다.** n개의 독립 부울 변수에 제약이 없으면 BDD는 사실상 선형이다. 반대로 해가 몇 개 없어도 제약 구조가 나쁘면 BDD는 지수 폭발한다.

따라서 **"2.88×10¹⁵ 이라서 컴파일이 불가능하다"는 명제는 거짓**이다. 결정하는 것은 축 간 **결합도(coupling)** 다.

후니 실측 산식을 이 렌즈로 다시 읽으면:

```
성원 = 3,420(필수 5축) × 15 × 15 × 85 × 5 × 5 × 41 × 25 × 33 × 4 × 13
       └─────────────┘   └──────────── 후가공 10축, 서로 곱셈 = 상호 제약 없음 ────────────┘
```
(`_workspace/print-story/02_capture/complexity-metrics.md:86–105`)

곱셈으로 계산됐다는 것은 **UI 상에서 이 10개 축이 서로 독립으로 제시된다**는 뜻이다. 독립 축의 곱은 MDD/BDD에서 **직렬 연결(합)** 로 표현된다 — 크기가 `15+15+85+5+5+41+25+33+4+13 ≈ 241` 수준의 노드 뭉치로 붙는다는 의미다. 자릿수가 15개여도 **표현은 수백~수천 노드**다.

> [추정] 실제 노드 수는 변수순서·교차제약 도입 후에야 확정된다. 다만 "곱 구조 = 독립 = 컴파일 친화"라는 방향은 BDD 이론의 정론이다.

**진짜 난이도는 반대편에 있다** — 지금 UI가 곱으로 제시하고 있지만 실제로는 불가능한 조합(코팅×평량, 오시간격×규격, 박×도무송 간섭)이 존재한다. 그 교차 제약을 **명시하는 순간** 결합도가 생기고 컴파일 크기가 결정된다. 즉 **우리가 지불할 비용은 "10¹⁵을 다루는 비용"이 아니라 "암묵지를 명시 제약으로 옮기는 비용"이다.**

#### b-2. 제약 전파 (constraint propagation)

- **하는 일**: 도메인 축소. GAC(generalized arc consistency)를 유지하면 "지금 이 시점에 고를 수 있는 값"만 남는다.
- **10¹⁵에서**: 전파 자체는 조합 수와 무관하게 제약·도메인 크기에 다항. **작동한다.**
- **한계**: 전파만으로는 **backtrack-free를 보장하지 못한다**. 즉 "화면에 남아 있는 값을 골랐는데 나중에 막히는" 현상이 생긴다. 이걸 없애려면 유효도메인(valid domain)의 **정확한** 계산이 필요하고, 그건 일반 CSP에서 NP-hard다.
- **평가**: **필수 기반 기술이나 단독으로는 불충분.** 우리 위젯의 즉시 반응(옵션 회색처리)에는 충분하지만, "고른 대로 반드시 주문된다"는 보장에는 부족하다.

#### b-3. 지식 컴파일 (knowledge compilation) — 이 도메인의 정답 계열

Darwiche & Marquis, *A Knowledge Compilation Map*, JAIR 17:229–264 (2002)이 표준 프레임이다. 두 축으로 언어를 평가한다 — **간결성(succinctness)** 과 **다항시간에 지원하는 질의/변환**. NNF를 뿌리로 DNNF, d-DNNF, FBDD, OBDD 등 중첩(DAG) 계열을 포함하며, DNNF는 "보편적이고, 풍부한 다항시간 연산을 지원하며, OBDD보다 공간 효율적"으로 특징지어진다. 리터럴 조건화(conditioning)와 원자 사영(projection)이 선형시간이라는 점이 인터랙티브 구성에 결정적이다.

컴파일이 사주는 것(구성 문제에 직접 대응):

| 질의 | 기호 | 구성에서의 의미 |
|---|---|---|
| Consistency | CO | "지금 선택으로 주문 가능한가" |
| Conditioning | — | "이 옵션을 고르면" 을 선형시간에 반영 |
| Projection / 유효도메인 | — | "다음 축에서 아직 고를 수 있는 값 목록" |
| **Model counting** | CT | **"남은 조합이 몇 개인가" → 정보이득 계산의 재료** (d-DNNF는 다항, OBDD도 가능) |
| Enumeration | ME | 후보 명세 나열 |

**model counting이 다항시간이라는 것**이 (e) 대화 설계의 열쇠다. 이걸 못 하면 "다음에 뭘 물어야 가장 많이 좁혀지는가"를 계산할 수 없다.

#### b-4. BDD 기반 인터랙티브 구성 — 산업 실증

- Hadzic·Subbarayan·Jensen·Andersen·Hulgaard·Møller 계열의 **compile-once / online-query 2단 구조**: 오프라인에서 유효 구성 집합을 압축 기호표현으로 컴파일하고, 온라인에서는 그 위를 순회해 **backtrack-free** 상호작용을 제공한다. "Calculating Valid Domains for BDD-Based Interactive Configuration"(arXiv:0704.1394)이 유효도메인 계산의 핵심 알고리즘을 다룬다.
- 이 연구 라인에서 **Configit Software A/S**가 스핀오프했고, **Virtual Tables(현 Virtual Tabulation®)** 라는 기호표현을 특허화했다. Configit 자사 설명에도 VT™가 "가장 복잡한 제품을 다루는 다중특허 구성 AI 기술"로, 그리고 `Solution Space - VT™ in Action` 데모가 "회사 안에 존재하는 제품 변형이 몇 가지인지의 전체 뷰"를 준다고 명시된다 — **즉 상용 제품이 대놓고 "전체 해 공간을 세어 보여준다"** (= model counting을 판다).
- 컴파일이 감당 안 될 때의 정석 대비책: **BDD + 백트래킹 탐색 하이브리드**(Subbarayan 계열)로 "부분 컴파일 + 나머지는 탐색".

#### b-5. 산업 규모 반례 확인 — 자동차

Renault는 차량 다양성 모델링을 **사내에서 knowledge compilation 방식으로** 구축해 운영한다. 후속 최적화 연구(대칭성 활용)에서 Renault 실 데이터셋 기준 **공간 표현 52.13% 감소, 처리시간 49.81% 감소**를 보고한다. 자동차 제품군은 인쇄 명함보다 **훨씬 강하게 결합된** 제약 구조(안전·법규·물리 간섭)를 갖는데도 컴파일 계열이 프로덕션에서 돈다.

> [추정] Renault 공간 규모의 정확한 자릿수는 본 조사에서 1차 출처로 확인하지 못했다(HAL/ACM 접근 차단). "10²⁰" 같은 수치는 인용하지 않는다.

#### b-6. 컴파일된 오토마톤 + 설명 + 일관성 복원

Amilhastre·Fargier·Marquis, "Consistency restoration and explanations in dynamic CSPs — Application to configuration", *Artificial Intelligence* 135(1-2):199–234 (2002). CSP 프레임을 확장해 **① 전역 일관성 유지 ② 사용자 선택에 대한 설명 제공 ③ 일관성 복원(무엇을 풀면 다시 가능해지는가)** 세 기능을 제공한다.

**③이 인쇄 도메인에서 결정적이다.** "이 조합은 불가능합니다"로 끝나면 고객은 이탈한다. "박과 에폭시를 같은 면에 동시 적용할 수 없습니다 — **에폭시를 뒷면으로 옮기면** 가능합니다"가 되어야 한다. 이건 UX 카피가 아니라 **알고리즘 출력**이다.

#### b-7. 10¹⁵ 규모 적합성 종합 판정

| 기법 | 우리 규모에서 | 판정 |
|---|---|---|
| 제약 전파 (GAC) | 조합 수 무관, 다항 | ✅ 채택 (기반) |
| 백트래킹 탐색 단독 | 매 클릭마다 재탐색, backtrack-free 미보장 | ⚠️ 보조 |
| **BDD/MDD 컴파일** | 독립축 구조 → 표현 작음, 온라인 다항 | ✅ **핵심 채택** |
| **d-DNNF 컴파일** | model counting 다항 → 대화 설계 필수 | ✅ **핵심 채택** |
| 전수 열거 / 캐시 테이블 | 10¹⁵ 행 = 불가능 | ❌ 배제 |
| LLM에게 유효성 판정 위임 | 확률적, 검증 불가 | ❌ 배제 (`thesis-arc.md:151` 동일 결론) |
| 트리 분해 / 클러스터 분리 | 독립 후가공 축 → 자연 분해 | ✅ 채택 (전처리) |

---

### (c) 상용 CPQ는 "규칙"을 어떻게 저장·검증·유지하는가 — 데이터 모델 관점

#### c-1. 두 계열의 대립

Tacton은 이 대립을 자사 문서에서 직접 명명한다 — **constraint-based vs rules-based**.

- 규칙 기반: if-then 문이 경로를 지정 → 사용자가 정해진 순서를 따라야 함.
- 제약 기반: **"구성이 성립하려면 무엇이 참이어야 하는가"** 를 정의 → **"사용자는 어떤 입력(재질·크기·환경)으로든 시작할 수 있고, 시스템이 나머지를 실시간으로 걸러 조정"**.
- **데이터/로직 분리**: 모든 허용 조합을 열거하는 대신 속성 기반 제약을 쓰므로, 신규 부품·모듈을 **로직 변경 없이** 추가 가능.
- 정량 근거(Tacton 제시): Siemens Energy가 **수천 개 비즈니스 룰 → 수백 개 제약**으로 대체.
- 모델링 표면: **TCstudio** 라는 전용 모델링 언어로 제약과 부품 구조 간 관계를 기술. 엔진은 constraint solver(변수 선택 → 값 시도 → 실패 시 백트래킹).

> **핵심 데이터모델 교훈**: 제약 기반은 규칙을 **"제품 데이터(부품 테이블)"와 "로직(제약식)"으로 분리 저장**한다. 규칙 수가 SKU 수에 비례하지 않고 **속성 축 수에 비례**한다. 이게 조합 폭발을 규칙 테이블에서 막는 유일한 구조적 수단이다.

#### c-2. Configit — 공유 제품모델 + 컴파일 표현

Configit은 **Configuration Lifecycle Management(CLM)** 을 내세워, 구성 지식을 영업·엔지니어링·제조가 공유하는 단일 모델로 관리한다는 포지션을 취한다. 엔진은 b-4의 **Virtual Tabulation®**(다중특허, 컴파일된 기호표현)이다. 즉 **저장 형식 = 소스 제품모델, 실행 형식 = 컴파일 산출물**의 2표현 구조다.

#### c-3. SAP LO-VC — 의존성(dependency) 타입 체계

SAP Variant Configuration의 데이터 모델은 **특성(characteristic) / 클래스 / 구성가능자재(configurable material) / 슈퍼 BOM** 위에 **오브젝트 의존성(object dependency)** 을 얹는 구조다.

| 의존성 타입 | 하는 일 | CSP 대응 |
|---|---|---|
| Precondition | 조건 충족 전까지 특성·값을 **숨김** | 도메인 필터 / activity constraint |
| Selection condition | 조건이 **명확히 참일 때만** BOM 항목·공정 선택 | activity constraint (컴포넌트 생성) |
| Procedure | 다른 특성 값을 **계산·유도** | 함수 종속 / 파생변수 |
| Action | (레거시) 값 설정 | 위와 동일 |
| Constraint | 논리 **일관성 유지·검사** | 진짜 제약 |

특징 두 가지가 데이터모델 관점에서 중요하다:

1. **Global vs Local 저장.** 의존성을 중앙(global)에 만들어 여러 오브젝트가 재사용하는 것이 권장 방식이고, 특정 오브젝트에 직접 붙이는 local은 최소화하라고 안내된다 → **로직 중복 제거를 저장 계층에서 강제**.
2. **미할당 값의 3치 논리.** Precondition은 조건이 참이거나 **아직 평가되지 않았으면** 표시하고, Selection condition은 **명확히 참일 때만** 선택한다(값이 없으면 거짓). 즉 **"모름(unknown)"을 두 방향으로 다르게 취급**한다 — 인터랙티브 구성에서 반드시 필요한 설계다.

> [추정·미검증] SAP 공식 help 페이지는 JS 렌더링으로 본문 fetch에 실패했다. 위 서술은 검색 스니펫 + 2차 자료(cleverence 해설, 4개 의존성 카테고리·특성/클래스/구성가능자재 구조 확인) 기반이며, 1차 출처 원문 대조는 하지 못했다.

#### c-4. Salesforce CPQ — 규칙 행(row) 모델의 전형

Trailhead 문서로 확인된 레코드 구조:

```
Product Rule ──< Error Condition   (언제 발동하는가)
             ──< Product Action    (무엇을 add/remove/hide 하는가)
             ──< Lookup Query      (외부 커스텀 오브젝트 데이터 참조)
Configuration Rule                 (어느 번들에 붙는가)
Configuration Attribute / Summary Variable  (입력·집계)
```
규칙 타입 4종: **Alert**(경고·무시가능) / **Validation**(저장 차단) / **Selection**(자동 추가·제거·숨김) / **Filter**(동적 선택 목록 필터).

가격 쪽은 **Price Rule + Price Condition + Price Action + Lookup** 의 동형 구조다.

**데이터모델 관점 평가**:
- 장점: 규칙이 **행(row)** 이라 비개발자가 UI로 편집 가능, 감사 가능, Lookup Query로 "데이터는 테이블에, 규칙은 행에" 라는 약한 형태의 데이터/로직 분리 달성.
- 치명적 약점 3가지:
  1. **절차적·순서 종속.** Lookup Query에 Action이 걸리면 Action이 먼저 실행되는 등 평가 순서 규칙이 존재한다 → 규칙 간 상호작용이 비가환.
  2. **양방향 추론 불가.** "A를 고르면 B 제거"는 되지만 "B가 필수인 상황에서 A를 미리 회색처리"는 규칙을 따로 또 써야 한다 → **규칙 수가 방향 수만큼 배증**.
  3. **전역 일관성·설명·유효도메인 없음.** 지금 상태에서 도달 가능한 완성 구성이 존재하는지 보장하지 않는다.

> 이것이 Tacton이 말한 "수천 개 룰"의 정체다. **후니의 `t_prd_product_constraints`(JSONLogic 행 + `rule_cd` + `err_msg`)는 구조적으로 Salesforce 계열이다.**

#### c-5. 규칙의 "검증·유지" — KB 자체의 품질 문제

상용/학계 공통으로 인정되는 구성 지식베이스의 고질 결함 4종:

| 결함 | 정의 | 컴파일 표현에서의 검출 |
|---|---|---|
| **Dead option** | 어떤 유효 구성에도 등장할 수 없는 옵션 | 유효도메인이 공집합 → 선형시간 |
| **False optional** | 선택 옵션인데 사실상 항상 강제됨 | 모든 모델에 등장 → CT 비교 |
| **Redundant constraint** | 제거해도 해 집합 불변 | 모델 수 동일 → CT 비교 |
| **Void / inconsistent model** | 유효 구성이 0개 | CO 질의 → 선형시간 |

Felfernig 계열(Graz TU)이 이를 **지식 엔지니어링 병목**으로 지목하고, 오류 KB의 진단·수리(model-based diagnosis) 및 KB 개발 자체를 추천시스템으로 돕는 접근을 제시해 왔다(*Knowledge-Based Configuration: From Research to Business Cases*, Felfernig·Hotz·Bagley·Tiihonen, Morgan Kaufmann/Elsevier, 2014).

> **[중요] 이 4종은 현재 후니 하네스가 이미 다른 이름으로 잡고 있는 결함과 동일하다** — `hcc-cpq-link-conformance`의 dead link / 고아 참조 / 오배선, `hbg-basecode-diagnosis`의 고아·오매칭. 즉 우리는 이미 문제를 알고 있고, **컴파일 표현을 갖는 순간 이 감사가 SQL 전수 대조에서 선형시간 질의로 바뀐다.**

---

### (d) 가격을 구성과 함께 푸는가, 나중에 계산하는가

#### d-1. 두 입장

| | **Price as constraint** (구성과 동시) | **Price as post-computation** (사후 계산) |
|---|---|---|
| 모델 | COP / Valued CSP / cost-augmented MDD | `price = f(완성된 구성)` |
| 대표 근거 | Andersen·Hadzic·Pisinger, *Interactive Cost Configuration over Decision Diagrams*, JAIR 37:99–139 (2010) | 대부분의 상용 CPQ 실무, SAP variant conditions |
| 가능해지는 것 | "예산 30만원 이하에서 가능한 것만 보여줘", 비용 하한/상한 실시간 표시, 최적 구성 탐색 | 임의 복잡 공식, 단일 권위, 변경 용이 |
| 대가 | 비용을 모델 안에 넣어야 함 → 가격 개정 시 재컴파일 | **가격이 선택의 함수인데 사용자에게 그 함수가 안 보임** |

#### d-2. JAIR 2010의 정밀한 경계선 [검증]

이 논문이 이 절의 결정적 근거다. 확인된 내용:

- 비용 함수가 **가산(additive)** 이면 **MDD로 효율적·견고·구현 쉬운 확장이 가능**하다.
- 비가산(non-additive) 케이스도 다루지만 난이도가 오른다.
- **다중 비용 함수(multi-cost) 구성은 NP-hard**임을 증명. 대신 2-비용 문제에 **의사다항(pseudo-polynomial) 스킴과 FPTAS**를 제시.
- 실 데이터셋 실험에서 대형 인스턴스도 **1초 미만 응답**.

앞선 AAAI-06 논문(*A BDD-Based Polytime Algorithm for Cost-Bounded Interactive Configuration*)이 그 전신으로, **비용 상한이 걸린 상태의 유효도메인을 다항시간에** 계산한다.

#### d-3. 인쇄 가격은 어느 쪽인가 — 판정

인쇄 가격은 **가산이 아니다.** 근거:

1. **판걸이/면부치기.** 수량과 규격이 판 수를 결정하고, 판 수가 계단함수로 가격을 만든다. 후니 자체 자료에도 판당 고정비(Rip 10분+전송 5분+커팅세팅 3분 = 18분)와 "3판→1판이면 36분 절감"이 명시돼 있다(`_workspace/print-story/04_thesis/thesis-arc.md:64`). 이건 옵션별 단가의 합이 아니다.
2. **수량 구간 할인.** 구간 경계에서 단가가 점프.
3. **면적형 공식.** 규격 × 수량의 비선형 조합.
4. **실측 배수.** 후가공 4종 클릭에 4,620원 → 43,670원 = **9.45배**(`thesis-arc.md:97`). 그리고 결정적 문장: *"가격은 조합의 함수인데, 사용자에게 그 함수가 보이지 않는다"*(같은 파일 :99).

⇒ JAIR 분류상 **비가산 + 사실상 다중 비용(자재비·공정비·판비)** = **NP-hard 영역**. **가격을 통째로 제약 모델에 넣는 것은 우리 규모에서 권장되지 않는다.**

#### d-4. 그러나 순수 사후 계산도 답이 아니다

사후 계산만 하면 위의 "함수가 안 보인다" 문제가 그대로 남고, 대화형 견적에서 **예산 기반 질문**("30만원 안에서 최대한 고급스럽게")을 원리적으로 답할 수 없다.

#### d-5. 권장 — 2계층 가격 (정합 판정 포함)

```
[권위 계층]  evaluate_price  ← 최종 금액의 단일 권위. 변경 없음.
[탐색 계층]  단조 하한 비용 c_lb(부분 구성)  ← 컴파일 레이어에 병설
             · 각 옵션에 "최소 증분 비용" 태그 (가산 근사)
             · 부분 구성의 하한 = 확정 축 증분의 합
             · 하한 > 예산 ⇒ 그 가지는 확실히 배제 가능 (안전한 가지치기)
             · 하한 ≤ 예산 ⇒ 후보 유지 → 완성 시 evaluate_price 로 확정
```
이 구조는 **틀린 가격을 절대 보여주지 않으면서**(하한은 "최소 이 정도"로만 표시) 예산 대화를 가능하게 한다. 그리고 기존 설계결정 **D-18(KB는 가격을 계산하지 않는다, 가격 엔진이 단일 권위 — `thesis-arc.md:200` 부근)** 을 위반하지 않는다. 하한은 **가격이 아니라 가지치기 지표**다.

#### d-6. SAP의 절충 [추정·미검증]

SAP은 특성 값에 **variant key**를 붙이고 조건유형 **VA00** 으로 할증/할인 레코드를 만든 뒤 SD 조건기법으로 합산하는 방식을 쓴다. 구조상 **"특성값 → 가격 증분"의 가산 모델 + 의존성으로 계수 조정(pricing factor)** 이다. 즉 상용 ERP도 "구성 solver 안에서 가격을 풀지" 않고 **가격은 조건기법(사후·가산)** 으로 뺀다. 위 d-5 권장과 같은 방향이다. (SAP help 원문 fetch 실패 — 검색 스니펫 기반.)

---

### (e) 옵션 고르기를 "탐색"이 아니라 "대화"로 바꾼 시도

#### e-1. 있다. 세 계보다.

**① 지식기반 추천 / 크리티킹 (1990s~)**
Burke의 knowledge-based recommender, FindMe 계열의 **critiquing**("이것보다 더 싼 것", "더 두꺼운 것")이 시초. Felfernig 계열이 이를 **constraint-based recommender**로 정식화했다(*Developing Constraint-based Recommenders*, in *Recommender Systems Handbook*, Springer). 핵심은 추천이 유사도가 아니라 **제약 만족 + 설명**으로 이루어진다는 점 — 구성 문제와 같은 엔진을 쓴다. 최근에는 음성 상호작용 크리티킹(ReComment)까지 나왔다.

**② 대화형 추천의 이론적 복잡도 (2021)** [검증]
Di Noia·Donini·Jannach·Narducci·Pomo, *Conversational Recommendation: Theoretical Model and Complexity Analysis*(arXiv:2111.05578). 도메인 독립 형식 모델로 "원하는/원치 않는 특성 또는 아이템을 점진적으로 물어 선호를 획득"하는 과정을 정의하고 다음을 증명:
- 효율적 대화 전략을 찾는 것은 **일반적으로 NP-hard, PSPACE 내**.
- **특정 카탈로그 형태에서는 POLYLOGSPACE 로 떨어진다.**
- 결론: **"카탈로그 특성이 개별 대화 전략의 효율에 강하게 영향을 주므로 전략 설계 시 고려해야 한다."**

> **이 결과가 우리에게 좋은 소식인 이유**: 후니 카탈로그는 §b-1에서 본 대로 **거의 직교하는 축의 곱**이다. 이것이 바로 "특정 카탈로그 형태"의 유리한 쪽이다. 직교 축에서는 각 질문이 독립적으로 공간을 나누므로 전략 계산이 쉬워진다.

**③ LLM + solver 하이브리드 (2024~2026)**
- *Configuration with Generative AI*(Springer, 2025 챕터): LLM을 **모델링 단계**(자연어→제약 형식화)와 **구성 단계**(자연어 입력→solver→자연어 설명) 양쪽에 배치. **유효성 판정은 solver가** 한다.
- *Large Language Model Meets Constraint Propagation*(IJCAI 2025, proceedings/2025/1115.pdf — URL 실재 확인, 본문 파싱 실패).
- ACMG 프레임워크(*Applied Sciences* 15(12):6518, 2025): 파인튜닝 LLM으로 자연어 → CSP 모델 자동 생성, MiniZinc로 반복 검증. [추정: MDPI 본문 403, 검색 스니펫 기반]
- **solver 없이 하는 방식도 실재한다** [검증]: Hinterdorfer, *Natural-Language Multi-Tenant Product Configurator Using LLM Tool-Calling Against a Curated Relational Database, Without a Constraint Solver*(Technical Disclosure Commons, 2026-05-07). 핵심 설계는 **LLM의 행동 공간 제한** — *"LLM은 큐레이션된 관계형 DB에 대해 작동하는 작고 고정된 도구 집합만 호출할 수 있고, DB가 이전에 반환한 옵션 식별자만 전달할 수 있다"*. 따라서 **환각/무효 식별자는 DB 계층에서 실패하므로 구조적으로 불가능**하다고 주장한다.

#### e-2. 우리가 취할 조합 — "정보이득 대화"

컴파일(b-3)이 model counting을 다항시간에 주므로, 다음이 **계산 가능해진다**:

```
다음 질문 축 q* = argmax_q  H(현재 해 집합) − Σ_v P(v)·H(해 집합 | q=v)
                  (H = log2(모델 수), 모델 수는 d-DNNF/OBDD 에서 다항시간)
```
- log₂(2.88×10¹⁵) ≈ **51 비트**. 이론적 하한은 균등 분포 가정 시 51번의 이진 질문이다.
- 그러나 실제 분포는 극도로 편향돼 있다(대부분 조합은 아무도 주문하지 않음). **주문 이력으로 사전분포를 넣으면** 기대 질문 수는 훨씬 줄어든다. 이것이 §e-1-②가 말한 "카탈로그 특성"의 실전 버전이다.
- LLM은 **입구**(자연어 → 진입 노드/사전분포 편향)와 **출구**(결과·거절사유·대안 설명)만 맡는다. 이 역할 분담은 이미 프로젝트 내부에서 동일하게 결론 났다(`_workspace/print-story/04_thesis/thesis-arc.md:151` — *"중간의 유효성 판정을 LLM에 맡기면 틀린다"*).

---

## 우리 문제에의 적용 — 후니프린팅

### 1. 규모 프레이밍을 바꾼다 (가장 중요)

**지금까지의 서사**: "2,876조 가지 = 인간이 감당 불가 = 그래서 AI가 필요".
**정정된 서사**: "2,876조는 **표현의 난이도가 아니라 UI가 사용자에게 떠넘긴 분류 노동의 크기**다. 컴파일 관점에서 이 구조는 오히려 유리하다."

근거는 우리 자신의 산식이다. `complexity-metrics.md:86–105`가 성원 후가공 10축을 **곱셈으로** 계산했다는 사실 자체가 "이 축들 사이에 UI 상 제약이 없다 = 직교"라는 증거다. 직교 축은 BDD/MDD에서 **직렬 연결**이므로 노드 수가 축 크기의 **합** 수준이다(≈수백). 10¹⁵이라는 자릿수는 표현 크기에 나타나지 않는다.

⇒ **발표·설계 양쪽에서 "10¹⁵이라 못 푼다"는 주장을 쓰면 안 된다.** 정확한 명제는:
> "10¹⁵은 컴파일하면 작다. **진짜 비용은 그 곱셈이 거짓말이라는 사실 — 즉 축 사이 실제 제약이 어디에도 기록돼 있지 않다는 것 — 을 메우는 비용이다.**"

### 2. 암묵지 → 1급 제약: 첫 번째 착수 지점이 이미 특정돼 있다

`thesis-arc.md:126`이 정확한 증거를 잡아 뒀다. 성원의 옵션 이름 `오시2줄(양끝 10mm미만)` / `오시2줄(오시간격 30mm미만)`은 **선택지가 아니라 생산 제약 조건문**이 옵션 라벨 문자열 안에 숨은 것이다. 사용자에게 "당신이 어느 케이스인지 스스로 분류하시오"를 시키고 있다.

이것이 Tacton이 말하는 **data/logic 미분리**의 극단적 형태다. 해야 할 일:

```
[현재]  option_item.name = "오시2줄(양끝 10mm미만)"        ← 제약이 문자열
[목표]  option_item      = 오시 2줄
        constraint       : 오시2줄 → (규격.가로 − 오시위치합) ≥ 10mm
                           오시2줄 → 오시간격 < 30mm
```
착수 순서 제안 (규모 순이 아니라 **결합도 순**):
1. **자재 ↔ 평량 ↔ 코팅** (종속축, 이미 `complexity-metrics.md:37`에서 "종속 축 미보정"으로 지목됨)
2. **평량 ↔ 접지/오시** (180g 초과 시 오시 강제 — `thesis-arc.md` §3-② 예시)
3. **후가공 간 간섭** (박 ↔ 에폭시 ↔ 도무송 동일면 충돌)
4. **규격(자유입력) ↔ 판걸이수** (가격축과의 접점)

### 3. 현재 DB 구조에 대한 구체 진단·권고

| 현행 | 이론상 정체 | 문제 | 권고 |
|---|---|---|---|
| `t_prd_product_constraints` (JSONLogic 행 + `rule_cd` + `err_msg`) | **Salesforce CPQ형 규칙 행 모델** (c-4) | 순서 종속·단방향·전역 일관성 없음 | **유지하되 역할 축소** — UI 즉시 피드백 게이트 전용 |
| `option_groups / options / option_items` + polymorphic `ref_dim_cd` | 변수·도메인 정의 (CSP의 `⟨X,D⟩`) | 양호 | 그대로 CSP 변수·도메인으로 승격 |
| (없음) | **허용 튜플 테이블 (extensional / table constraint)** | — | **신설 권고**: 축 쌍/삼중의 허용 조합을 행으로 저장 → CP solver의 table constraint 및 BDD 컴파일 입력으로 **양쪽 다** 소비 가능 |
| (없음) | 컴파일 산출물 | — | 빌드 파이프라인 산출물로 취급 (DB 아님, 배포 아티팩트) |

**핵심 권고 = 이중 표현.**
- **저장(source of truth)**: 관계형 — 옵션 정의 + 허용 튜플 테이블 + 파생 규칙. 실무진이 webadmin에서 편집 가능해야 하므로 **행 기반 유지**는 타협 불가 제약이다(기존 `hcr-rule-authoring`의 "폼빌더 역파싱 가능한 정형 shape만" 규약과 정합).
- **실행(runtime)**: 위를 **빌드 시 컴파일**해 BDD/MDD/d-DNNF 산출. Configit의 "소스 제품모델 + VT 컴파일 산출물" 2표현 구조(c-2)와 동일.
- 이 분리가 있으면 실무진 편집 → 빌드 → **컴파일 실패 = 지식베이스 결함 검출**이라는 CI 게이트가 공짜로 생긴다.

### 4. KB 자체 감사가 선형시간이 된다

c-5의 4종 결함(dead option / false optional / redundant constraint / void model)은 현재 후니 하네스가 **SQL 전수 대조**로 잡고 있는 것과 같은 대상이다 — `hcc-cpq-link-conformance`의 dead link·고아 참조, `hbg-basecode-diagnosis`의 고아·오매칭, `hcc-basedata-conformance`의 등록 누락.

컴파일 표현을 갖는 순간:
- "이 옵션 아이템은 어떤 유효 주문에도 나타날 수 없다" → 유효도메인 공집합 질의 (선형)
- "이 상품은 유효 구성이 0개다" → CO 질의 (선형)
- "이 제약은 있으나 마나다" → 모델 수 불변 (CT 2회)

⇒ **하네스의 감사 대상이 줄어드는 게 아니라, 감사 방법이 바뀐다.** 이건 지금 진행 중인 정합 하네스들과 경쟁이 아니라 그것들의 **다음 단계**다.

### 5. 가격 — D-18을 지키면서 예산 대화를 여는 법

§d-3 판정: 인쇄 가격은 비가산·다중비용 ⇒ **제약 모델에 통째로 넣지 않는다.** 기존 결정(D-18: KB는 가격을 계산하지 않고 `evaluate_price`가 단일 권위)은 **이론적으로도 옳다.**

추가할 것은 하나뿐이다 — **단조 하한 비용 태그**:
- 각 option_item에 "이걸 켜면 최소 얼마 늘어나는가"의 **하한**을 태그.
- 부분 구성의 하한 = 확정된 증분들의 합 (가산 근사, 항상 실제보다 작거나 같음).
- 용도는 **가지치기와 예산 대화 뿐**. 화면에 "약 X원부터"로만 노출하고, **확정 금액은 완성 후 `evaluate_price`** 가 낸다.
- 판걸이·구간할인 같은 계단함수는 하한에서 **가장 유리한 구간을 가정**하면 단조성이 유지된다.

이렇게 하면 `"30만원 안에서 카페 오픈용 명함"` 같은 발화를 **틀린 가격을 말하지 않고** 처리할 수 있다.

### 6. 의도 → 주문: 실제 대화 루프 설계

`thesis-arc.md:145–151`이 이미 정의한 문제 형태 — *"자유 발화를 창의적으로 해석하는 것이 아니라, 닫힌 세계의 유효한 구성 하나로 접는 것"* — 에 §e-2의 계산 가능한 절차를 붙인다.

```
발화: "카페 오픈 기념으로 나눠줄 명함, 두툼하고 고급스럽게, 500장"
  │
  ├─[LLM]  진입 노드 확정 + 사전분포 편향
  │        용도=판촉 · 두툼=평량↑ · 고급=후가공 켬 · 수량=500
  │        → 하드 제약이 아니라 "선호 가중치"로만 주입   ← [중요] LLM 출력은 제약이 아니다
  │
  ├─[컴파일 표현]  조건화(conditioning) → 남은 유효 공간 + 모델 수
  │
  ├─[정보이득]  다음 질문 축 선택
  │        "종이 질감을 고르실까요? (스노우 / 아트 / 고급 질감지)"
  │        ← 이 축이 남은 공간을 가장 크게 나누기 때문에 물어봄. 순서가 계산 결과다.
  │
  ├─(반복 — 기대 질문 수는 사전분포로 51비트보다 훨씬 짧아짐)
  │
  ├─[불가 조합 발생 시]  일관성 복원 (b-6)
  │        "박과 에폭시를 같은 면에 동시 적용 불가 — 에폭시를 뒷면으로 옮기면 가능합니다"
  │
  └─[완성]  evaluate_price → 확정 견적
```

역할 분담은 `thesis-arc.md`의 표와 동일하며, 본 조사가 그 표에 **"② 경로 탐색"과 "③ 유효성 판정" 사이에 컴파일 레이어를 명시적으로 넣는다**는 점만 더한다. GraphRAG는 ②(진입 노드→관계 경로)를 돕고, **컴파일 표현이 ③(유효성 판정)과 "다음 질문 선택"을 담당**한다.

### 7. 세 사이트 비교에 대한 재해석

`complexity-metrics.md` §3의 발견 — *"복잡도는 사라지지 않고 이동한다"* — 은 이론적으로 정확하다. 레드프린팅의 상품 분할(143만/페이지)은 CSP 관점에서 **문제를 수동으로 분해(decomposition)한 것**이고, 성원의 옵션 집약(2,876조/페이지)은 **분해하지 않은 것**이다.

**둘 다 같은 실패를 한다** — 분해의 정당성(어느 경계로 쪼갤 것인가)을 **사용자에게 묻지 않고 사용자에게 떠넘긴다**. 자동 분해(트리 분해, 클러스터 검출)는 컴파일 계열에서 기계가 하는 일이다. 즉 **레드프린팅 전략은 사람이 손으로 한 트리 분해**이고, 우리가 할 일은 그것을 **제약 구조에서 자동으로 유도**하는 것이다.

### 8. 착수 순서 제안 (시간 추정 없이, 의존 순서로)

1. **허용 튜플 테이블 스키마 신설** — 축 쌍/삼중 단위. 기존 `option_groups/items` 를 변수·도메인으로 확정.
2. **대표 1상품(일반 명함) 전 제약 명시화** — §2의 4개 결합 지점부터. 문자열에 숨은 제약을 전부 승격.
3. **컴파일 파일럿** — 그 1상품을 BDD/MDD로 컴파일. **실측할 것: 노드 수, 컴파일 시간, 유효 구성 수(model count), 온라인 질의 지연.** (§b-1의 "표현은 작다" 주장을 여기서 **검증하거나 반증**한다.)
4. **KB 결함 4종 자동 감사** — 컴파일 결과로 dead option / void / redundant 검출. 기존 하네스 결함 보드와 대조.
5. **정보이득 기반 질문 선택 프로토타입** — 모델 카운팅 위에서. 주문 이력으로 사전분포.
6. **단조 하한 비용 태그** — 예산 대화 개통. `evaluate_price` 권위 불변.
7. **동형 전파** — 상품군 단위. (기존 하네스의 "대표 파일럿 → 동형 전파" 패턴 그대로)

---

## 미해결·한계

1. **유효 구성의 실제 개수를 모른다.** 2.88×10¹⁵은 "UI가 제시하는 선택 공간의 규모 지표"이지 유효 구성 수가 아니다(`complexity-metrics.md:38`). 그런데 유효 구성 수를 세려면 제약이 명시돼 있어야 하고, 제약 명시가 바로 하려는 일이다 — **닭·달걀**. 파일럿 1상품에서 먼저 깨야 한다.
2. **자유 입력 축(가로/세로 mm, 수량 직접입력)은 유한 도메인이 아니다.** 순수 BDD/MDD로 표현 불가. 구간 이산화 + 구간 전파(interval propagation) 하이브리드가 필요하며, 본 조사에서 인쇄 도메인 사례를 찾지 못했다.
3. **컴파일 크기를 측정하지 않았다.** §b-1의 "독립축이므로 표현이 작다"는 **BDD 이론에서 도출한 [추정]** 이며 후니 데이터로 실측되지 않았다. 교차 제약을 넣는 순간 결과가 달라질 수 있다.
4. **가격 비가산성을 정량 확인하지 않았다.** 판걸이·구간할인이 비가산이라는 것은 도메인 지식과 자체 자료(`thesis-arc.md:64`)에 근거하지만, "얼마나 비가산인가"(하한 근사의 오차율)를 측정하지 않았다. d-5 권고의 실효성은 이 오차율에 달려 있다.
5. **SAP LO-VC 1차 출처 미검증.** help.sap.com 페이지가 JS 렌더링이라 본문 fetch에 실패했다. c-3과 d-6은 검색 스니펫 + 2차 자료 기반이며 [추정] 표시했다.
6. **Renault 규모 수치 미확보.** HAL·ACM·Semantic Scholar 모두 접근 차단(403). "10²⁰ 변형" 류의 흔한 인용은 1차 확인 실패로 본문에서 제외했다. 확인된 것은 "knowledge compilation을 사내 기술로 사용" 및 최적화 연구의 52.13%/49.81% 개선 수치뿐이다.
7. **회사별 작업가이드(진짜 해자) 원천이 아직 문서화되지 않았다.** `thesis-arc.md` §3의 계층 ③(규칙 계층 = 회사별 인쇄 작업가이드)이 최종 결정권을 갖는데, 그 원천 문서가 이 조사 범위에 없었다. 컴파일 대상 제약의 **권위 출처**가 확정되지 않으면 위 전체가 공중에 뜬다.
8. **IJCAI 2025 논문 본문 미독해.** URL 실재는 확인(339KB PDF 수신)했으나 바이너리 파싱 실패로 내용 인용은 하지 않았다.
9. **Junker의 Handbook *Configuration* 장 원문 미확인.** 서지 사실로만 인용.
10. **대화 전략의 기대 질문 수를 계산하지 않았다.** log₂(2.88×10¹⁵)≈51비트는 균등분포 상한이며, 실제 주문 이력 분포가 없어 기대값을 내지 못했다.

---

## Sources:

WebFetch로 실재·내용을 확인한 URL만 나열한다.

- [A Knowledge Compilation Map — Darwiche & Marquis, JAIR 17:229–264 (2002)](https://arxiv.org/abs/1106.1819)
- [Calculating Valid Domains for BDD-Based Interactive Configuration (arXiv:0704.1394)](https://arxiv.org/pdf/0704.1394)
- [Interactive Cost Configuration Over Decision Diagrams — Andersen, Hadzic, Pisinger, JAIR 37:99–139 (2010)](https://www.jair.org/index.php/jair/article/view/10639)
- [A BDD-Based Polytime Algorithm for Cost-Bounded Interactive Configuration (AAAI-06) — PDF 실재 확인, 본문 파싱 실패](https://cdn.aaai.org/AAAI/2006/AAAI06-010.pdf)
- [Consistency restoration and explanations in dynamic CSPs — Amilhastre, Fargier, Marquis, *Artificial Intelligence* 135(1-2):199–234 (2002), DOI 10.1016/S0004-3702(01)00162-X — dblp 서지 확인](https://dblp.org/rec/journals/ai/AmilhastreFM02.html)
- [Conversational Recommendation: Theoretical Model and Complexity Analysis — Di Noia 외 (arXiv:2111.05578)](https://arxiv.org/abs/2111.05578)
- [Constraint-Based vs. Rules-Based Configuration — Tacton](https://www.tacton.com/cpq-blog/constraint-based-vs-rules-based-configuration-the-advantage-for-complex-manufacturing/)
- [Configuration Lifecycle Management / Virtual Tabulation® — Configit](https://www.configit.com/configuration-lifecycle-management/)
- [Get Started with Product Rules — Salesforce Trailhead (Product Rules in Salesforce CPQ)](https://trailhead.salesforce.com/content/learn/modules/product-rules-in-salesforce-cpq/get-started-with-product-rules)
- [Natural-Language Multi-Tenant Product Configurator Using LLM Tool-Calling Against a Curated Relational Database, Without a Constraint Solver — Hinterdorfer, Technical Disclosure Commons (2026)](https://www.tdcommons.org/dpubs_series/10033/)
- [Comprehensive Guide to SAP LO-VC (2차 자료 — 특성·클래스·구성가능자재 및 4개 의존성 카테고리 확인)](https://www.cleverence.com/articles/sap-documentation/variant-configuration-lo-vc-5823/)
- [Large Language Model Meets Constraint Propagation (IJCAI 2025) — PDF 실재 확인, 본문 파싱 실패](https://www.ijcai.org/proceedings/2025/1115.pdf)

### 미검증 참조 (URL 실재하나 본문 fetch 실패 — 본문에서 [추정] 처리)

- help.sap.com — Preconditions / Pricing Factors (JS 렌더링)
- hal.science/hal-03618184, dl.acm.org, semanticscholar.org, mdpi.com, link.springer.com — 403 / 접근 차단

### 로컬 1차 근거 (프로젝트 내부)

- `_workspace/print-story/02_capture/complexity-metrics.md:25–26, 37–38, 80, 86–105, 154` — 3사 조합 수 실측·산식·계수 규칙
- `_workspace/print-story/04_thesis/thesis-arc.md:64, 93–99, 119, 126, 145–151, 259` — 판 고정비, 실측 지표, Mittal & Frayman 정의, 문자열에 숨은 제약, 의도→주문 문제 형태, 역할 분담
- `_workspace/print-story/06_artifact/build-notes.md:150, 121–122` — 조합 수 교정 이력(4,314…→2,876…), 검증 로그
