# R5 — 지식그래프·온톨로지 + GraphRAG의 산업 적용 (월드모델 관점 보강 리서치)

> 작성: huni-worldmodel §01_research · 2026-08-15
> 선행 산출물: `_workspace/huni-ontology-kb/`(§33 · 275상품 KB) · `_workspace/huni-multibrand-ontology/`(§35 · 상위 온톨로지)
> 이 문서의 자리: **§33/§35가 이미 내린 결론을 재탕하지 않는다.** 두 HANDOFF가 "기각 유지"로 못 박은 항목(임베딩·트리플스토어·OWL 추론기·Leiden 커뮤니티 자동탐지·개방추출)은 **되묻지 않고**, 그 기각이 외부 정량 근거로도 지지되는지 검증하고, 아직 **비어 있는 층**(암묵지·의도·행위-효과)을 어떻게 채울지에 초점을 둔다.

---

## 요약

1. GraphRAG는 **모든 질의에서 이기지 않는다.** 단일 사실 조회(fact retrieval)에서는 vanilla RAG와 동률이거나 오히려 지고(60.92% vs 36.92~60.14%), 다중 홉 추론(+10.45pp)·맥락 종합(+13.1pp)에서만 확실히 이긴다. 토큰 비용은 최대 30~330배 부풀 수 있다.
2. 후니 KB가 택한 **"스키마-우선 닫힌세계 + 앵커 강제"**는 학계에서 GraphRAG의 서브셋이 아니라 **다른 계열**(constraint-governed generation)이며, 환각 억제 강도는 이쪽이 더 세다 — SHACL 게이트로 오답률 0.0·기권 정밀도 1.0을 보고한 사례가 있다(다만 사실 정확도는 89.1%로 "모르면 침묵"의 대가를 치른다).
3. 제조·제품구성 도메인은 **온톨로지의 가장 오래된 성공 영역**(Soininen 구성 온톨로지·XCON $40M/년)이면서 동시에 **가장 유명한 실패 영역**(XCON 규칙 1만개 유지보수 붕괴)이다. 성패를 가른 축은 "도메인 지식과 문제해결 지식의 분리"였고, 이는 후니의 D-18 가격경계(KB는 잇기만·계산은 evaluate_price)와 정확히 같은 축이다.
4. 실측 결과 후니 KB는 **구조 층은 두껍고(엣지 4,568) 의미 층은 거의 비어 있다** — intent 3개·rule 7개·constraint 10개 대 gap 229개. 조합폭발은 이미 표현되지만 **암묵지와 의도는 아직 표현되지 않았다.**
5. 정적 개념지도 → 월드모델로 가려면 필요한 것은 추론기나 임베딩이 아니라 **행위(action)·전제(precondition)·효과(effect)·상태(state) 4개 개체의 신설**이다. 현재 17개체 스키마에는 이 4개가 하나도 없다.

---

## 본문

### 1. GraphRAG가 이기는 질의 / 지는 질의 (정량)

#### 1.1 태스크 유형별 승패 (GraphRAG-Bench, ICLR'26)

GraphRAG-Bench 논문(“When to use Graphs in RAG”)은 9종 GraphRAG를 vanilla RAG와 4개 태스크 유형에서 대조했다. Novel 데이터셋·GPT-4o-mini 기준 수치:

| 태스크 유형 | vanilla RAG | GraphRAG | 판정 |
|---|---|---|---|
| 단순 사실 조회(fact retrieval) | **60.92%** | 36.92 ~ 60.14% | **RAG 승** (그래프 이득 없음) |
| 복합 추론(complex reasoning) | 42.93% | **53.38%** (HippoRAG2) | 그래프 승 **+10.45pp** |
| 맥락 종합(contextual summarization) | 51.30% | **64.40%** (GraphRAG local) | 그래프 승 **+13.1pp** |
| 창의 생성(creative generation) | 38.26% | 23.80 ~ 48.28% | **혼재** (대부분 RAG 이하) |

논문의 출발 문제의식 자체가 "GraphRAG가 실제 과제에서 vanilla RAG에 자주 진다는 보고"였다는 점이 중요하다. 즉 **GraphRAG는 기본값이 아니라 조건부 도구다.**

#### 1.2 다중 홉·시간 질의에서의 승리 폭 (RAG vs GraphRAG 체계 평가)

별도 체계 평가(arXiv:2502.11371)에서:

- **GraphRAG 승**: HotpotQA F1 63.01(HippoRAG2) / 61.66(Community-GraphRAG Local) vs RAG 60.04. MultiHop-RAG **Temporal 질의 50.60% vs RAG 30.70%** (거의 2배 — 시간·비교 질의는 그래프의 명백한 우위 구간).
- **RAG 승**: Natural Questions F1 64.78 vs RaptorRAG 60.04. NovelQA **detail 서브셋 55.28% vs 46.88%** — 세부 사실 질의에서 그래프는 오히려 손해.

#### 1.3 비용 — 이기는 구간에서도 공짜가 아니다

- **구축 시간**(MultiHop-RAG): RAG 135초 vs Community-GraphRAG 5,560초(**41배**) vs KG-GraphRAG 7,702초(**57배**).
- **검색 지연**: KG-GraphRAG 14,434초 vs RAG 1,724초(**8.4배**). 단 Community-GraphRAG는 오히려 25% 빠름 — 그래프 계열 내부 편차가 크다.
- **토큰**: Global-GraphRAG 프롬프트 최대 4×10⁴ 토큰, LightRAG ≈10⁴, HippoRAG2 ≈10³. vanilla RAG(≈879 토큰) 대비 **30~330배 팽창**.

#### 1.4 여기서 끌어낼 규칙

> 그래프는 **"연결을 따라가야만 답이 나오는 질의"**에서만 값을 한다. "이 상품 최소수량 얼마?"류 단일 사실 조회에 그래프 순회를 붙이면 정확도는 안 오르고 비용만 오른다.

이 규칙은 §33이 이미 채택한 **D-11 하이브리드 2단 라우팅**(1단 노드 확정 → 2단 경로 탐색)과 정합한다(`_workspace/huni-ontology-kb/02_ontology/nl-query-paths.md:11-13`). 즉 후니는 **"항상 그래프"가 아니라 "노드 확정 후 필요할 때만 순회"**를 이미 하고 있으며, 위 수치는 그 설계를 사후 지지한다.

---

### 2. 제조·제품구성(BOM·컨피규레이션) 도메인의 온톨로지 실사례

#### 2.1 구성 온톨로지(configuration ontology) — 이 분야의 원조

지식기반 컨피규레이션에서 표준 표현 개념은 **component / port / resource / function**이며, Soininen 등(1998)의 "일반 구성 온톨로지"가 이론적 토대를 제공했다. 이 기술은 자동차·통신·컴퓨터 제조·전력변압기 등에 실제 배포된 "가장 성공적으로 적용된 AI 기술 중 하나"로 서술된다.

핵심 전환점은 **규칙기반 → 모델기반**이었다. 모델기반(제약충족문제·CSP)은 **도메인 지식과 문제해결 지식을 엄격히 분리**하고, 규칙 발화 순서에 의존하지 않는 **다방향성(multidirectionality)**을 제공해 유지보수성을 크게 개선했다.

ASP(Answer Set Programming) 기반 최신 흐름(arXiv:2109.08304)도 같은 골격이다 — 구성 개념 식별 → 제품 지식의 사실(fact) 포맷 → 도메인 독립 인코딩. **"온톨로지는 어휘를, 제약 솔버는 계산을"** 분업 구조가 반복 등장한다.

#### 2.2 Bosch — 제조 데이터의 가상 지식그래프(VKG)

Bosch SMT(표면실장) 라인 사례(ISWC 2020)는 이 도메인의 대표 산업 배포다. SMT 제조 데이터용 온톨로지 + 공장 데이터 소스 매핑을 만들고, **제품 품질 분석 과제 카탈로그를 SPARQL 질의로 인코딩**해 표현력·성능을 평가했다. 다만 논문은 클래스 수·테이블 수·질의 실행시간 같은 **정량 지표를 제시하지 않고 정성적으로("promising") 보고**한다 — 산업 사례 인용 시 자주 과장되는 지점이므로 주의.

산업 KG 절차모델 논문(arXiv:2409.13425)은 2차 인용으로 **"Bosch 전자제품 품질관리 KG가 데이터 분석 효율을 70% 개선"**을 전한다. 다만 이는 해당 논문의 재인용이며 원 출처 측정 방법은 확인하지 못했다 — [추정] 수준으로 취급할 것.

같은 절차모델 논문은 7단계(Business Understanding → Data Understanding → Data Preparation → Modeling → Graph Setup → Evaluation → Deployment)를 제시하는데, **1단계가 competency question(CQ) 정의**이고 **6단계 평가가 "SPARQL 질의로 CQ에 답하는가"**다. 이는 §33이 `nl-query-paths.md`로 "경로가 안 그려지면 스키마 결함"을 판정한 방식과 동일한 방법론이다.

#### 2.3 BOM·변형구성(variant configuration)에서 그래프가 하는 일

Configurable BOM 패턴은 "구성요소 상위집합에서 제약·점수·의존성을 지키며 최적 구성을 선언적으로 해결"하는 문제로 정의된다. 즉 **BOM 그래프는 조합을 나열하려는 게 아니라 잘라내려고(prune) 존재한다.** (해당 벤더 문서는 403으로 직접 검증 실패 — Sources 미등재, 본문에서도 근거로 쓰지 않는다.)

---

### 3. 온톨로지가 LLM 환각을 줄이는 구체 기전

환각 감소는 "그래프를 붙였다"로 일어나지 않는다. 실제 작동하는 기전은 4가지로 분리된다.

#### 기전 ① 어휘 폐쇄(closed vocabulary) — 존재하지 않는 개체를 말할 수 없게 함

스키마가 개체 유형·관계 유형을 **닫힌 목록**으로 고정하면 모델은 목록 밖 술어를 만들 수 없다. 후니 KB는 개체 17종·관계 19종을 닫고 "개방 관계명 금지"를 명시했다(`02_ontology/ontology-schema.md:12`).

#### 기전 ② 앵커 강제(existence anchoring) — 실재 증거 없는 노드 금지

후니 KB는 모든 노드에 앵커 3유형(`t_<table>/<CODE>` 라이브 코드 / `xlsx:파일#시트!셀` / `none`+사유)만 허용하고, **앵커 실재를 결정론 스크립트가 lint로 검사**한다. 앵커 없는 개념은 GAP 노드로만 존재 가능 — 문서 표현대로 "**환각 개체 완전 차단**"(`02_ontology/ontology-schema.md:29-33`).

이것이 GraphRAG(문서에서 엔티티를 개방 추출)와 후니 방식의 결정적 분기다. 개방 추출은 **추출 단계에서 환각을 만들어 그래프에 굳혀버린다.** 후니 방식은 그래프에 들어오는 입구에서 막는다.

#### 기전 ③ 검증 게이트(constraint-governed generation) — 생성 후 형식 검증

최근 계열은 SHACL 같은 형상 제약 언어로 **생성 직전 검증 관문**을 두어, KG 제약을 만족하지 않는 주장은 출력 자체를 막고 **결정론적 기권(abstention)**을 시킨다. 보고된 수치는 **기권 정밀도 1.0 · 오답률 0.0 · 사실 정확도 89.1%**(arXiv:2511.06073). 해석이 중요하다 — **오답 0의 대가는 "10%는 답을 못 함"**이다. 이 트레이드오프를 받아들일 수 있는 도메인(견적·가격)에서만 쓸 수 있는 카드다.

#### 기전 ④ 범위 경계 규칙(scope boundary) — 아는 축과 모르는 축의 명시

후니 KB는 `RULE_scope_boundary` 노드로 in_scope(상품·구성요소·옵션·가격 차원·제약) / out_of_scope(주문·배송·회원·쿠폰·경쟁사 가격비교·재고)를 선언하고, 범위 밖은 **상품 노드로 라우팅조차 하지 않는다**(`06_query_gate/scenarios-rejection-260703.md:15-16`). 게이트 실측에서 거절형 15건 PASS·환각 추천 0건, 아크릴 라운드에서도 거절 5/5 PASS(`06_query_gate/gate-verdict-acryl-260704.md:87-90`).

> **정리**: KG가 환각을 줄이는 건 "정보를 더 줘서"가 아니라 **"말할 수 있는 것의 집합을 줄여서"**다. ①②는 입구 통제, ③④는 출구 통제. 후니는 ①②④를 이미 갖췄고 **③(형식 검증 게이트)만 비어 있다.**

---

### 4. 구축·유지의 실무 비용과 실패 사례 (낙관 금지 절)

#### 4.1 고전적 실패 — XCON/R1

DEC의 XCON은 **연 $40M 순이익**을 낸 성공 사례로 인용되지만, 동시에 이 분야 최대의 경고다. 규칙 수가 수천~1만을 넘자 시스템은 느려졌고 유지보수·기능 추가가 매우 어려워졌다. 근본 원인은 **도메인 지식과 문제해결 지식의 상호의존** — 도메인 지식을 고치면 문제해결 지식이 깨지고 그 역도 성립했다. 개발자들이 규칙 발화 순서를 강제하려고 "obscure tricks"를 쓴 것이 붕괴의 징후였다.

> **후니 대입**: 우리 KB가 "가격 값은 evaluate_price 권위·KB는 계산 안 함"(D-18, `02_ontology/ontology-schema.md:19`)을 지키는 한 이 실패 모드는 재현되지 않는다. **D-18을 깨고 KB가 가격을 계산하기 시작하는 순간이 XCON 재현 시점이다.**

#### 4.2 비용 추정 — 숫자가 있지만 정밀하지 않다

온톨로지 개발 비용 추정 모델 ONTOCOM 계열은 인월(PM)을 응답변수, 크기를 설명변수로 두고 다수의 서열 변수를 쓴다. 후속 F-ONTOCOM은 **148개 온톨로지 프로젝트 데이터셋**으로 검증됐다(퍼지 확장이 ONTOCOM보다 정확하다고 주장). 즉 **이 분야에는 "COCOMO급 정밀도"가 없다** — 추정 자체가 연구 주제로 남아 있다는 사실이 곧 비용 불확실성의 증거다.

산업 KG 절차모델 논문은 실무 감각을 준다: KG 구축은 "도메인 전문가와 기술 전문가의 공동 투입이 필요한 큰 투자"이며, 특히 **데이터 이해 단계가 문서화 부실 때문에 예상보다 더 든다**. 배포 이후 **유지·갱신·확장이 상시 의무**로 남는다.

#### 4.3 진짜 실패 모드는 표현이 아니라 운영

업계 관찰(2차 문헌 — Sources 미등재, [추정]으로 취급)이 반복 지적하는 실패 패턴은 셋이다:
1. **과설계** — 전사를 하나의 온톨로지로 모델링하려다 정의 논쟁에 빠져 아무것도 못 냄.
2. **유지보수 부재** — 온톨로지는 출시일에 가장 정확하고 이후 매일 낡는다. 관리자가 없으면 "존재하지 않는 도시의 지도"가 된다.
3. **오염의 비가시성** — 유지 안 한 비용은 파국 전까지 보이지 않는다.

#### 4.4 컨피규레이션 특유의 부채 — 제약 이상(anomaly)

구성 지식베이스는 규모가 커지면 **불일치(inconsistency)·중복(redundancy)** 같은 이상이 축적되며, 이를 자동 탐지·제거하는 기법(CoreDiag 등)이 별도 연구 분야로 존재할 만큼 흔한 문제다. 즉 **제약을 많이 쓰면 제약 자체가 유지보수 대상이 된다.**

> **후니 실측 경고**: 현재 constraint 노드는 **274상품에 대해 단 10개**(아래 §측정). 지금은 이상 축적 문제가 없지만, §34 제약규칙 하네스가 전 상품 제약을 등록하면 **CoreDiag류 중복·모순 점검을 처음부터 파이프라인에 넣어야 한다.** 나중에 붙이면 늦다.

---

### 5. 온톨로지가 "월드모델"이 되려면 — 정적 개념지도 → 동적 행위-효과 모델

#### 5.1 무엇이 빠졌는가

현재 온톨로지가 표현하는 것은 **"무엇이 무엇과 어떻게 연결되는가"**(구조·is-a·part-of·priced_by)다. 월드모델이 추가로 요구하는 것은 **"어떤 행위를 하면 상태가 어떻게 변하는가"**다. 형식적으로는 4개 원소가 더 필요하다:

| 필요 원소 | 의미 | 후니 스키마 현황 |
|---|---|---|
| **state** | 시점 t의 세계 상태(부분 구성·재고·설비 점유) | **없음** |
| **action** | 상태를 바꾸는 조작(옵션 선택·자재 변경·공정 추가·수량 변경) | **없음** |
| **precondition** | 행위 적용 가능 조건 | constraint 10개로 부분 표현(정적 금지만) |
| **effect** | 행위 후 상태 변화(가격·납기·가능옵션 집합의 변화) | **없음** |

PDDL이 정확히 이 4원소의 표준 형식이고, LLM으로 이 형식을 자동 생성하려는 시도가 Text2World 벤치마크다. 결과는 냉정하다 — 대규모 RL로 학습한 추론 모델이 가장 낫지만 **최고 성능 모델조차 세계 모델링 능력이 제한적**이라는 것이 논문의 결론이다. 실패 유형에는 **술어 환각(원문에 없는 관계를 발명)**이 포함된다.

precondition/effect 지식을 LLM에 주입하려는 연구(arXiv:2409.12278)는 전제 예측용·효과 예측용 **모델 2개를 따로 파인튜닝**하고 합성 데이터로 학습시키며, 행위 사슬(action chain) 생성 가능성까지 평가한다. 즉 **"LLM은 본래 세계 동역학을 모델링하도록 설계되지 않았다"**는 전제 위에서, 동역학은 외부에 명시적으로 두는 방향이 주류다.

#### 5.2 우리에게 주는 설계 함의

> 월드모델화의 정답은 **"LLM에게 세계를 상상시키기"가 아니라 "행위-효과를 온톨로지에 명시하고 LLM은 그 위를 걷게 하기"**다.

이는 §2.1의 "도메인 지식 / 문제해결 지식 분리"와 정확히 같은 원칙의 시간축 확장이다. 후니 스키마 용어로 옮기면:

- `action` 노드 = 견적 화면에서 손님이 할 수 있는 조작 1개 (= `option_group`의 **선택 행위**)
- `precondition` = 기존 `constraint`(JSONLogic)의 재해석 — "금지 목록"에서 "행위 적용 조건"으로
- `effect` = **가장 큰 공백.** "코팅을 추가하면 가격구성요소 COMP_COATING이 붙고 납기가 +1일 되며 자재 선택지가 축소된다" 같은 사실이 지금 어디에도 없다.
- `state` = 부분 구성(partial configuration) — CPQ에서 손님이 절반만 고른 상태

---

## 우리 문제에의 적용 (후니프린팅)

### A. 실측 현황 — 우리 KB의 층별 두께

`04_graph/nodes.jsonl`·`edges.jsonl` 직접 집계(2026-08-15 실행):

```
노드 1,485 = product 274 · size 174 · material 162 · option_group 146 · price_component 134
            · price_formula 97 · process 71 · category 68 · bundle_qty 64 · plate_size 23
            · constraint 10 · print_option 4        ← 구조 층 (두꺼움)
            · gap 229                                ← 공백 층 (두 번째로 큼!)
            · decision 12 · rule 7 · term 7 · intent 3   ← 의미·암묵지 층 (거의 비어 있음)
엣지 4,568 = references 1,859 · uses_material 451 · in_category 392 · has_size 363
            · has_process 302 · option_refs 298 · has_component 218 · has_option_group 146
            · priced_by 143 · has_print_option 112 · has_plate_size 74 · has_qty_rule 64
            · derived_from 54 · has_member 43 · decided_because 19 · alias_of 19 · constrains 11
```

**이 표가 R5의 핵심 진단이다.** 조합폭발(구조)은 이미 잘 표현돼 있다. 그러나 **암묵지(rule 7) · 의도(intent 3) · 제약(constraint 10)은 사실상 미착수**이고, **gap 229**는 "정직하게 비어 있음을 표시한 것"이라 건강한 신호지만 동시에 **KB의 1/6이 아직 공백**이라는 뜻이다.

### B. 문제 1 — 조합폭발

**현재 상태**: 274상품 × (사이즈 174 · 자재 162 · 옵션그룹 146 · 공정 71) 축이 곱해지는 구조. 실 조합 수는 계산하지 않았으나 축 카디널리티만으로도 열거 불가 규모다.

**적용 규칙 (§1.4 · §2.3에서 도출)**:
1. **조합을 나열하지 말고 잘라라.** BOM 그래프의 산업적 역할은 enumerate가 아니라 prune이다. 우리 그래프도 "가능한 견적 목록"을 만들지 말고 **불가능한 조합을 제거하는 제약 그래프**로 써야 한다 → constraint 10개는 압도적으로 부족.
2. **단순 사실 질의에는 그래프를 쓰지 마라.** "명함 최소 몇 장?"은 `has_qty_rule` 1홉이면 끝난다(`nl-query-paths.md` S3). GraphRAG-Bench 수치대로 여기에 커뮤니티 요약·다중 홉 순회를 붙이면 **정확도 이득 0, 토큰 30~330배**다. 라우터가 "1홉 조회 / 다홉 순회"를 먼저 판정해야 한다.
3. **그래프가 값을 하는 후니 질의 유형은 명확히 3종**: ① 상품 간 비교(S2 "코팅명함 vs 스탠다드명함" = 다중 홉 diff) ② 용도 추천(intent → 상품군 = 관계 사슬) ③ 가격 사슬 설명(product → formula → component → 차원). 이 3종은 GraphRAG-Bench의 complex reasoning / contextual summarization 구간과 정확히 겹친다.

### C. 문제 2 — 암묵지

**현재 상태**: rule 노드 7개는 전부 **KB 운영 메타규칙**(scope_boundary · plate_paper_only · pansu_db_function · price_value_boundary · dosu_is_printopt · import_material_no_delete · dataline_neq_wiring)이다. `03_kb/rule/rules.md:8-46` 확인. **고객 응대·실무 판단의 암묵지는 단 1건도 등재돼 있지 않다.**

즉 "청첩장은 보통 몇 g 이상 쓴다", "이 자재에 이 가공 넣으면 실무진이 말린다", "이 사이즈는 판걸이수가 나빠서 단가가 튄다" 같은 **지금 사람 머릿속에만 있는 지식**이 그래프에 없다.

**적용 방안**:
1. **암묵지는 `rule` 노드가 아니라 `constraint`+`effect`로 나눠 담아야 한다.** "말린다"는 두 종류다 — (a) 물리적으로 불가 → `constraint`(precondition) (b) 가능하지만 결과가 나쁨 → `effect`(가격↑·납기↑·품질↓). 현재 스키마는 (b)를 담을 그릇이 없다.
2. **채우는 방법은 LLM 추출이 아니라 앵커 강제다.** Text2World가 보인 **술어 환각**(원문에 없는 관계 발명)이 정확히 암묵지 추출에서 터질 실패 모드다. 암묵지 노드도 앵커 3유형 규율을 그대로 적용 — 통화록·실무진 코멘트·과거 주문 이력 좌표가 없으면 `gap`으로 남긴다.
3. **비용 각오**: §4.2대로 이 단계가 "예상보다 더 드는" 구간(데이터 이해)이다. 전 상품 일괄이 아니라 **한 상품군 파일럿 → 동형 전파**(§33이 이미 검증한 루프)로 간다.

### D. 문제 3 — 의도 → 주문

**현재 상태**: intent 노드 **3개**(cafe_opening · wedding · premium), 전부 `{candidate}` 배지(`03_kb/intent/intents.md:10-26`). §35 HANDOFF도 "intent 원자 분해 미완 = 키스톤"으로 못 박았다. 반면 거절 경로는 이미 견고 — 범위 밖 질의는 상품 노드로 라우팅조차 하지 않고 정직 거절(15/15 PASS).

**적용 방안**:
1. **의도→주문은 "탐색"이 아니라 "행위 사슬"이다.** 손님의 여정은 `INTENT_wedding` → 상품 후보 → 옵션 선택(행위) → 제약 통과 → 가격 확정 → 주문이다. 지금 그래프는 **첫 두 단계만** 표현한다. 3단계 이후가 §5의 action/precondition/effect/state 공백과 정확히 일치한다.
2. **가격 경계(D-18)는 유지하되, "효과"는 KB에 넣어라.** KB가 가격 *값*을 계산하면 XCON 실패 재현(§4.1). 그러나 **"이 옵션을 켜면 어떤 구성요소가 추가되는가"**는 값이 아니라 구조이므로 KB 소관이다. 지금은 `has_component`(공식→구성요소)만 있고 **`option → component` 링크가 없다** — 이게 "선택의 효과"를 못 말하는 직접 원인이다.
3. **환각 통제는 기전 ③를 추가로 붙여라.** 견적 도메인은 "틀린 답보다 침묵이 낫다"가 성립하는 전형적 도메인이다. SHACL형 게이트의 **오답률 0.0 / 기권 정밀도 1.0 / 사실 정확도 89.1%** 트레이드오프는 우리에게 유리한 거래다. 구현은 OWL/SHACL 스택 도입이 아니라(§35 기각 유지) **기존 결정론 lint를 응답 직전 게이트로 재사용**하면 된다 — 답변에 등장한 모든 코드가 앵커 실재 검사를 통과해야만 출력.
4. **주문 라우팅(§35 E22~E25)은 능력 포섭(capability ⊇ spec) 문제**이므로, 위 action/effect 층이 생기면 같은 형식으로 재사용된다 — 공급자 능력이 곧 precondition, 주문 전달이 곧 action.

### E. 실행 순서 (우선순위)

1. **스키마에 `effect` 표현을 추가** — 신규 개체 남발 대신 `has_option_group` / `option_refs` 엣지에 **효과 한정자**(어떤 component가 붙는가·어떤 축이 잠기는가)를 다는 방식부터 검토(search-before-mint 원칙 준수).
2. **응답 게이트(기전 ③) 구현** — 기존 lint 재사용. 비용 최소·환각 억제 효과 최대.
3. **constraint 확충 + 중복/모순 점검을 동시 설계**(§4.4) — §34 하네스와 연동.
4. **intent 원자 분해 파일럿** — 한 상품군, 앵커 강제, gap 정직.
5. **암묵지 수집** — 통화록·실무진 코멘트 앵커 확보가 선행. 앵커 없으면 착수하지 않는다.

---

## 미해결·한계

- **본 문서의 수치는 대부분 영어권 일반 도메인 벤치마크**(HotpotQA·NovelQA·MultiHop-RAG 등)에서 왔다. 한국어·인쇄 도메인·274상품 규모에서 동일 비율이 재현된다는 보장은 없다. [추정] 방향성(다중 홉·비교·종합에서 그래프 우위)은 도메인 무관하게 성립할 가능성이 높지만, 절대 수치는 이식 금지.
- **Bosch 70% 효율 개선**은 2차 인용이며 원 측정 방법 미확인. 원논문(ISWC 2020)은 정량 지표를 제시하지 않는다.
- **Neo4j Configurable BOM 문서 · VentureBeat GraphRAG 기사 · Springer ONTOCOM 원문 · Semantic Scholar Soininen 페이지**는 403/리다이렉트로 직접 검증 실패 → Sources 미등재이며 본문 근거로 사용하지 않았다(§2.3은 근거 아닌 서술로 표시).
- **온톨로지 실패 패턴(§4.3)**은 업계 블로그 계열 2차 문헌 기반이라 검증 URL을 싣지 않았다. [추정] 취급.
- **SHACL 게이트 89.1% 수치**는 단일 논문·특정 벤치마크 결과다. 우리 도메인에서 기권률이 얼마가 될지는 파일럿 전까지 알 수 없다.
- **행위-효과 층의 비용을 추정하지 못했다.** ONTOCOM 계열조차 정밀도가 낮은 영역이라, 파일럿 실측 없이 인월 추정을 하지 않는다.
- **우리 그래프 집계 수치는 2026-08-15 시점 `04_graph/*.jsonl` 스냅샷**이다. §33 HANDOFF의 H-1 드리프트 교훈대로, 재사용 시 재집계할 것.

---

## Sources:

- [RAG vs. GraphRAG: A Systematic Evaluation and Key Insights (arXiv:2502.11371v3)](https://arxiv.org/html/2502.11371v3)
- [When to use Graphs in RAG — GraphRAG-Bench, 본문 HTML (arXiv:2506.05690v1)](https://arxiv.org/html/2506.05690v1)
- [When to use Graphs in RAG (arXiv:2506.05690 초록)](https://arxiv.org/abs/2506.05690)
- [GraphRAG-Bench: Challenging Domain-Specific Reasoning for Evaluating GraphRAG (arXiv:2506.02404)](https://arxiv.org/abs/2506.02404)
- [Text2World: Benchmarking LLMs for Symbolic World Model Generation (arXiv:2502.13092)](https://arxiv.org/abs/2502.13092)
- [Making Large Language Models into World Models with Precondition and Effect Knowledge (arXiv:2409.12278)](https://arxiv.org/abs/2409.12278)
- [Can Knowledge Graphs Reduce Hallucinations in LLMs? A Survey (arXiv:2311.07914)](https://arxiv.org/abs/2311.07914)
- [Stemming Hallucination in Language Models Using a Licensing Oracle (arXiv:2511.06073)](https://arxiv.org/abs/2511.06073)
- [Semantic Integration of Bosch Manufacturing Data Using Virtual Knowledge Graphs (ISWC 2020)](https://www.inf.unibz.it/~calvanese/papers-html/ISWC-2020-bosch.html)
- [Procedure Model for Building Knowledge Graphs for Industry Applications (arXiv:2409.13425v1)](https://arxiv.org/html/2409.13425v1)
- [Product Configuration in Answer Set Programming (arXiv:2109.08304)](https://arxiv.org/abs/2109.08304)
- [Knowledge-based configuration (Wikipedia)](https://en.wikipedia.org/wiki/Knowledge-based_configuration)
- [A Short History of Configuration Technologies — Knowledge-based Configuration (2014)](https://apprize.best/usability/knowledge-based/3.html)
- [F-ONTOCOM: A Fuzzified Cost Estimation Approach for Ontology Engineering (JWE)](https://journals.riverpublishers.com/index.php/JWE/article/view/6263)
- [CoreDiag: Eliminating Redundancy in Constraint Sets (arXiv:2102.12151)](https://arxiv.org/pdf/2102.12151)

### 내부 근거 (파일:라인)

- `_workspace/huni-ontology-kb/02_ontology/ontology-schema.md:12`(개체17·관계19 폐쇄), `:19`(D-18 가격경계), `:29-33`(앵커 3유형·lint·환각 개체 차단)
- `_workspace/huni-ontology-kb/02_ontology/nl-query-paths.md:11-13`(D-11 하이브리드 2단 라우팅)
- `_workspace/huni-ontology-kb/03_kb/rule/rules.md:8-46`(rule 7종 — 전부 KB 운영 메타규칙)
- `_workspace/huni-ontology-kb/03_kb/intent/intents.md:10-26`(intent 3종·전부 candidate)
- `_workspace/huni-ontology-kb/06_query_gate/scenarios-rejection-260703.md:15-16`(RULE_scope_boundary in/out_of_scope), `:5-7`(거절형 15 PASS·환각 0)
- `_workspace/huni-ontology-kb/06_query_gate/gate-verdict-acryl-260704.md:87-90`(거절 5/5·환각 견적 0)
- `_workspace/huni-ontology-kb/04_graph/nodes.jsonl`·`edges.jsonl`(2026-08-15 집계 — 노드 1,485·엣지 4,568)
- `_workspace/huni-ontology-kb/HANDOFF.md:25`(H-1 드리프트·재-SELECT 필수), `_workspace/huni-multibrand-ontology/HANDOFF.md:28-29`(스키마-우선 닫힌세계 우위·임베딩/트리플스토어/OWL/Leiden 기각 유지)
