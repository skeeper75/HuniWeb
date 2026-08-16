# R1 — 뉴로-심볼릭 AI(Neuro-Symbolic AI) 아키텍처 이론

> 작성: 2026-08-15 · 트랙: huni-worldmodel / 01_research
> 규율: 1차 출처(논문 원문·공식 페이지) 확인분만 인용. 추측은 [추정] 배지. 라이브 DB·raw/webadmin 무수정(본 문서는 읽기 전용 조사).

---

## 요약

- Henry Kautz는 2020 AAAI Engelmore 기념강연(AI Magazine 2022 게재)에서 뉴로-심볼릭 하이브리드 아키텍처를 **6가지 결합 방식**으로 분류했고, 자신이 가장 유망하다고 본 것은 신경망 안에 기호추론기를 **서브루틴으로 내장**하는 `Neuro[Symbolic]`이다(Kahneman의 System 1/System 2 대응).
- 실무에서 뉴로/심볼릭 책임 분리의 축은 하나로 수렴한다: **뉴로는 "무엇을 말하려는지"(모호·개방·유사성)를, 심볼릭은 "무엇이 참인지·얼마인지"(제약·산술·조합탐색)를 맡는다.** Program-of-Thought·Logic-LM·LLM-Modulo·ConstraintLLM이 모두 이 분업을 서로 다른 결합도로 구현한다.
- 결합 지점의 실패는 대부분 **계산 실패가 아니라 형식화(autoformalization) 실패**다. LLM이 만든 제약모델은 "구문 오류·논리 불일치·핵심 제약 누락"을 포함할 수 있고([ConstraintLLM 한계](https://arxiv.org/html/2510.05774)), LLM의 자기검증은 신뢰 근거가 되지 못한다([LLM-Modulo](https://proceedings.mlr.press/v235/kambhampati24a.html)).
- 후니프린팅 문제(조합폭발·암묵지·의도→주문)에 대입하면, **가격·판걸이수·제약은 100% 심볼릭(기존 `evaluate_price`·`fn_calc_pansu`·제약규칙)에 남기고**, LLM은 ① 고객 의도 → 옵션 벡터 번역, ② 암묵지 후보 제안, ③ 결함 원인 설명 3역할로 한정하는 `Neuro | Symbolic` + `Symbolic[Neuro]` 혼합이 우리 등급에 맞는다.
- 우리 파이프라인의 종료선("전 상품 × 전 옵션조합 → 권위 엑셀과 100% 일치, 안 맞는 상품 0")은 이미 **심볼릭 검증기(verifier) 규격**이다(`_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:113,117`). 뉴로 계층은 이 검증기를 우회할 수 없고, 우회 시도가 곧 알려진 실패 모드다.

---

## 본문

### 1. Kautz의 NSAI 6분류 — 1차 출처 정리

출처: Kautz, H. "The third AI summer: AAAI Robert S. Engelmore Memorial Lecture," *AI Magazine* 43(1), 2022, pp. 105–125, DOI `10.1002/aaai.12036`. 아래 6개 유형은 원문 pp. 118–121(PART III: FUTURE OF AI)에서 저자가 직접 이름 붙인 것이다. 원문 각주 7은 "이것은 가능한 하나의 분류일 뿐이며 다른 분류로는 Garcez & Lamb(2020)을 보라"고 명시한다 — **즉 규범(normative)이 아니라 설계 공간 지도**다.

| # | 유형 | 결합 방식(원문 요지) | 대표 사례(원문) |
|---|---|---|---|
| 1 | `Symbolic Neuro symbolic` | 기호 입력을 벡터로 변환 → 신경망 → softmax로 다시 기호 출력. **결합 아님, 현재 딥러닝 NLP의 표준 절차(SOP)** | word2vec/GloVe + NN, 일반 LLM |
| 2 | `Symbolic[Neuro]` | **기호적 문제해결기 안에 신경망을 서브루틴으로** 호출(패턴인식 담당) | AlphaGo(MCTS + 신경망 평가함수), 대부분의 로봇·자율주행 |
| 3 | `Neuro \| Symbolic` | 신경망이 비기호 입력(픽셀 등)을 **기호 자료구조로 변환** → 기호추론기가 처리. 기호측이 학습 피드백 신호를 되돌려줌. 원문: 90° 회전하면 2번과 유사하되 **neuro가 서브루틴이 아니라 코루틴** | Neuro-Symbolic Concept Learner (Mao et al. 2019) |
| 4 | `Neuro: Symbolic → Neuro` | 아키텍처는 1번(SOP)이되, **기호 규칙으로 생성한 학습 데이터로 훈련**(지식을 훈련셋에 컴파일) | Lample & Charton(2020) 기호수학 Transformer — 유도과정 없이 정답을 "추측" |
| 5 | `Neuro_{Symbolic}` | **기호 규칙을 신경망 내부 구조의 템플릿으로 변환**(임베딩에 규칙을 각인) | Tensor Product Representations, Logic Tensor Networks. 원문: **선언적(disjunctive) 규칙을 통한 사례별 조합추론에는 아직 미탐색** |
| 6 | `Neuro[Symbolic]` | **신경 엔진 안에 기호추론 엔진을 내장**. System 1(신경)이 언제 System 2(기호)를 호출할지 결정하고, Attention Schema에 문제의 기호 표현을 채워 넘김. 결과는 "머릿속 작은 목소리"처럼 되먹임 | Kautz가 가장 유망하다고 본 유형 (원문 Figure 15: 미로-치즈 예제, 최단경로 알고리즘 호출) |

원문에서 놓치면 안 되는 3가지 부가 주장:

- **결합 방향이 곧 신뢰성 등급이다.** 2번(Symbolic[Neuro])은 기호측이 최종 통제권을 쥐므로 검증 가능성이 높고, 1번·4번은 신경망이 최종 답을 내므로 검증 불가에 가깝다.
- **미분 불가 문제는 우회 가능하다.** 원문은 `Neuro[Symbolic]`의 정당한 반론으로 "기호 솔버는 미분 불가라 경사하강 학습을 못 받는다"를 들고, 해법으로 **솔버의 입출력쌍으로 System 1을 훈련**(=4번 방식)하면 시간이 갈수록 System 2 호출 빈도가 줄어든다고 답한다. → **4번은 6번의 학습 하위루틴으로 재사용된다.**
- **기호 서브시스템은 인간 System 2보다 강할 수 있다.** 원문은 DPLL SAT 솔버가 200TB 증명이 필요한 피타고라스 삼조 문제를 푼 사례를 든다(인간은 불가). 즉 "심볼릭 = 느리고 약함"이 아니라 **"심볼릭 = 인간이 못 하는 정확도·규모의 조합탐색"** 이다.

보완 분류로 Garcez & Lamb, *Neurosymbolic AI: The 3rd Wave*(arXiv:2012.05876, 2020)는 심볼릭이 기여하는 것을 **compositionality(합성성)·extrapolation(분포 밖 외삽)·검증가능성**으로, 신경이 기여하는 것을 **학습·강건한 지각**으로 정리하고, 3대 과제로 (1) 1차논리/고차 지식 추출, (2) 목표지향 상식추론과 효율적 조합탐색, (3) 인간-네트워크 소통을 든다.

### 2. 뉴로 계층과 심볼릭 계층의 책임 분리 원칙

여러 1차 출처를 교차하면 분리선은 5개 축으로 정리된다.

| 축 | 뉴로가 맡아야 하는 쪽 | 심볼릭이 맡아야 하는 쪽 | 근거 |
|---|---|---|---|
| 입력 형태 | 비정형·모호·자연어·이미지 | 정형·타입 있는 구조 | Kautz 유형 3 (픽셀 → 기호 자료구조) |
| 정답 정의 | 정답 집합이 열려 있음(유사성 판단) | 정답이 규칙으로 판정 가능 | Kautz System 1(similarity) vs System 2(rules) |
| 계산 성격 | 근사·연상·후보 생성 | 산술·제약충족·조합탐색 | PoT: "CoT는 추론과 계산을 동시에 시킨다"는 문제 제기 |
| 오류 비용 | 틀려도 재시도 가능(제안) | 틀리면 안 됨(돈·계약·안전) | LLM-Modulo: LLM은 "근사 지식원", 검증은 외부 모델기반 검증기 |
| 검증 주체 | 자기 자신을 검증하지 못함 | 결정론적으로 판정 | LLM-Modulo: 자기검증도 추론의 일종이므로 LLM 단독 불가 |

여기서 도출되는 **설계 원칙 4개**:

1. **정답 판정권은 심볼릭에 고정한다.** 뉴로가 최종 값을 내는 순간 그 값은 검증 불가가 된다(Kautz 유형 1·4의 성질).
2. **뉴로 → 심볼릭 인터페이스는 "기호 자료구조"여야 한다.** 자연어 요약을 넘기면 결합이 아니라 잡음 전달이다. Kautz의 Attention Schema, Logic-LM의 symbolic formulation, ConstraintLLM의 constraint profile이 모두 이 인터페이스 객체다.
3. **오류 피드백 루프를 반드시 닫는다.** Logic-LM은 솔버의 에러 메시지로 형식화를 자기수정(self-refinement)한다. ConstraintLLM은 생성 → 솔버 검증 → 자기수정 반복 루프를 쓴다. **루프가 없는 단방향 파이프라인은 형식화 오류를 그대로 최종값으로 배출한다.**
4. **결합도(coupling)는 필요 최소로.** 결합이 느슨할수록(2·3번) 검증·감사·롤백이 쉽고, 조밀할수록(5·6번) 성능은 오르되 오류 귀속이 어려워진다.

### 3. LLM + 기호추론기 결합 실무 패턴

#### (a) Tool calling — 가장 느슨한 결합 (Kautz 유형 2에 가까움)
Toolformer(Schick et al., arXiv:2302.04761)는 계산기·QA·검색·번역·달력 API를 **언제·어떤 인자로 호출하고 결과를 어떻게 이어 붙일지** 자기지도(self-supervised)로 학습시켰다. 핵심은 "LLM이 산술·사실조회를 스스로 하지 않고 위임한다"는 것. 실무 함의: 도구의 **시그니처와 사전조건이 곧 계약**이며, LLM이 인자를 잘못 채우는 것이 주 실패 지점이다.

#### (b) Program-of-Thought — 추론과 계산의 분리
Chen et al., *Program of Thoughts Prompting*(arXiv:2211.12588, TMLR 2023). CoT가 추론과 계산을 한 통에서 처리하는 것을 문제로 보고, **추론 과정을 프로그램으로 표현하고 계산은 외부 인터프리터가 실행**한다. 8개 데이터셋(GSM·AQuA·SVAMP·TabMWP·MultiArith·FinQA·ConvFinQA·TATQA)에서 CoT 대비 평균 약 12% 향상. 실무 함의: **금액 계산을 LLM 토큰으로 시키지 말고 코드/SQL/함수 호출로 내보내라.**

#### (c) 형식화 + 솔버 — Logic-LM / ConstraintLLM
- **Logic-LM**(Pan et al., EMNLP Findings 2023, arXiv:2305.12295): 자연어 → 기호 형식화 → 결정론적 솔버 추론 → **솔버 에러 기반 self-refinement**. 5개 논리추론 데이터셋에서 표준 프롬프팅 대비 +39.2%, CoT 대비 +18.4%.
- **ConstraintLLM**(arXiv:2510.05774): 산업급 제약프로그래밍(CP) 전용. LLM은 PyCSP3 코드를 생성하고 Choco 솔버가 검증·피드백. 제약유형 온톨로지(AllDifferent, Cumulative 등)로 문제를 프로파일링해 **어휘 유사도가 아니라 제약구조 유사도(Jaccard)로 예제를 검색**하는 CARM 모듈이 특징. 산업 벤치마크 IndusCP(140문제, 평균 240제약)에서 51.3%.
- **핵심 교훈**: 검색(RAG)의 단위를 문서가 아니라 **제약 구조**로 바꾼 것이 성능을 만들었다. 즉 심볼릭 스키마가 뉴로측 검색까지 규율한다.

#### (d) Neuro-guided search — 신경이 탐색을 안내
- **AlphaGeometry**(Trinh, Wu, Le, He, Luong, *Nature* 625:476–482, 2024): 기호 연역엔진을 먼저 돌려 소진시키고, **막히면 언어모델이 보조점(auxiliary point) 하나를 제안**해 증명 상태를 키운 뒤 다시 기호엔진을 돌린다. IMO 기하 30문제 중 25문제 해결(직전 최고 기호전용 시스템 10문제). **신경도 기호도 단독으로는 이 성능에 못 간다.**
- **FunSearch**(Nature 2023, PMC10794145): "해답이 무엇인가"가 아니라 **"해답을 만드는 프로그램"** 을 LLM + 진화탐색으로 찾는다. cap set 문제·온라인 빈패킹에 적용. 실무 함의: 규칙 자체를 후보로 생성하고 **평가는 결정론적 실행기**가 한다.

#### (e) LLM + 지식그래프
Pan et al., *Unifying LLMs and Knowledge Graphs: A Roadmap*(IEEE TKDE 2024, arXiv:2306.08302)는 세 갈래로 정리한다: **KG-Enhanced LLM**(KG로 LLM 보강), **LLM-Augmented KG**(LLM으로 KG 구축·완성·질의), **Synergized**(양방향). 우리 맥락에서 중요한 것은 두 번째 — **LLM은 온톨로지를 "채우는" 도구로 쓰고, 질의·추론은 그래프가 한다.**

#### (f) 검증기 중심 — LLM-Modulo
Kambhampati et al., *Position: LLMs Can't Plan, But Can Help Planning in LLM-Modulo Frameworks*(ICML 2024, PMLR 235:22895–22907). 주장: 자기회귀 LLM은 **스스로는 계획도 자기검증도 못 한다**. 그러나 "만능 근사 지식원"으로서 후보 생성·모델 획득에는 유용하다. 해법은 외부 모델기반 검증기와의 **양방향 상호작용(bi-directional)** — 앞단 번역기/뒷단 번역기로 격하하는 단순 파이프라인보다 조밀한 결합.

### 4. 무엇을 심볼릭에 남기고 무엇을 뉴로에 보낼 것인가 — 판단 기준

아래 7개 질문에 하나라도 "예"면 **심볼릭에 남긴다**.

1. **틀린 값이 곧 손해인가?** (금액·계약·수량·안전) → 심볼릭. 근거: LLM-Modulo의 외부 검증기 필수 주장.
2. **정답이 규칙으로 판정 가능한가?** 판정 함수가 존재하면 생성도 그 함수 편에 두는 것이 싸다.
3. **조합탐색·제약충족·산술이 본질인가?** → 심볼릭. PoT·Logic-LM의 성능 격차가 이 지점에서 발생.
4. **분포 밖 외삽이 필요한가?** (새 사이즈, 새 조합, 처음 보는 수량) → 심볼릭. Garcez & Lamb의 extrapolation 논거.
5. **감사·재현·롤백이 요구되는가?** 기호 규칙은 diff·버전관리·설명이 되고, 가중치는 안 된다.
6. **규칙이 이미 문서/코드로 존재하는가?** 존재하는 규칙을 학습으로 재발견시키는 것은 순손실.
7. **동일 입력에 동일 출력이 필요한가?** (결정론) → 심볼릭.

반대로 아래에 해당하면 **뉴로로 보낸다**.

1. **입력이 자연어·이미지 등 비정형**이고 정형화 자체가 과제일 때 → Kautz 유형 3의 변환기 역할.
2. **정답이 열려 있고 유사성 판단이 본질**일 때(비슷한 상품 추천, 문구 생성).
3. **규칙이 명시되지 않은 암묵지**이고, 그 암묵지를 **후보로 제안**만 시키고 채택은 사람/규칙이 할 때.
4. **탐색공간이 너무 커서 안내가 필요**할 때 → AlphaGeometry식 neuro-guided search(단, 최종 판정은 기호엔진).
5. **오류가 저비용이고 즉시 회수 가능**할 때.

**경계선 원칙 한 줄**: *생성은 뉴로에 열어주되, 판정·산출·기록은 심볼릭이 독점한다.*

### 5. 알려진 실패 모드

| # | 실패 모드 | 내용 | 1차 근거 |
|---|---|---|---|
| F1 | **형식화 오류(autoformalization failure)** | LLM이 만든 제약/논리 모델이 "구문 오류·논리 불일치·핵심 제약 미포착"을 포함. 솔버는 잘못된 모델을 정확히 풀어 **자신 있게 틀린 답**을 낸다 | ConstraintLLM 한계 절 |
| F2 | **자기검증 환상** | LLM에게 자기 출력을 검증시키면 신뢰가 오르지만 정확도는 안 오른다. 자기검증도 추론이므로 동일한 한계 | LLM-Modulo(ICML 2024) |
| F3 | **불충실한 사고연쇄(unfaithful CoT)** | CoT 설명이 실제 예측 이유를 체계적으로 오도. 선택지 순서 편향만 넣어도 13개 BIG-Bench Hard 과제에서 최대 36% 정확도 하락, 모델은 편향의 영향을 언급하지 않음 | Turpin et al., NeurIPS 2023, arXiv:2305.04388 |
| F4 | **계산/추론 혼용** | 추론과 산술을 한 토큰 스트림에서 처리하면 산술이 추론을 오염시킨다 | PoT(arXiv:2211.12588) |
| F5 | **미분 불가로 인한 학습 단절** | 기호 솔버는 미분 불가 → 신경측 경사학습 신호가 끊긴다. 완화책은 솔버 입출력쌍 증류(유형 4) | Kautz 원문, `Neuro[Symbolic]` 반론 절 |
| F6 | **조합추론 표현의 미탐색 영역** | 규칙을 임베딩에 각인하는 유형 5는 **선언적(OR) 규칙을 통한 사례별 조합추론**에 대해 아직 검증되지 않았다고 원문이 명시 | Kautz 원문 |
| F7 | **설명가능성·메타인지 결핍** | 2020–2024 논문 158편 분석에서 explainability/trustworthiness 28%, meta-cognition 5%에 불과. 4개 핵심 영역을 모두 교차한 논문은 AlphaGeometry 1편뿐 | Neuro-Symbolic AI in 2024: A Systematic Review (arXiv:2501.05435) |
| F8 | **검색/예제 부적합** | 어휘 유사도 기반 RAG는 구조가 다른 예제를 끌어와 형식화를 망친다. 구조 프로파일 기반 검색 필요 | ConstraintLLM CARM |
| F9 | **결합도 과잉** | 조밀 결합일수록 오류 귀속·감사·롤백이 어려워진다(설계 트레이드오프). *[추정]* — Kautz가 결합도 스펙트럼을 제시했으나 "감사 난이도"라는 표현으로 명시하지는 않았다 |
| F10 | **규칙 재발견 낭비** | 이미 코드/문서로 존재하는 결정론 규칙을 학습으로 대체하려 시도. *[추정]* — 실무 관찰이며 위 출처들이 직접 명명한 실패 모드는 아니다 |

---

## 우리 문제에의 적용 — 후니프린팅

### 6.1 우리 문제의 3중 구조

| 문제 | 현재 상태(1차 근거) |
|---|---|
| **조합폭발** | 완성 기준이 "손님이 **어떤 옵션 조합을 골라도** 정확한 가격"이고, 종료 척도가 "전 상품 × 전 옵션조합 시뮬레이터 결과가 권위 엑셀과 100% 일치, 안 맞는 상품 0"이다 (`_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:113`, `:117`) |
| **암묵지** | 판걸이수는 순수 기하계산이 실무 값과 다르며 **"실무진 판걸이수가 권위"**, 재질 종속(투명엽서 6 vs 일반 8)까지 존재 (`HARNESS-DOMAIN-RULES-260701.md:23`). 계산식이 시장가 2배를 넘으면 공식 대신 **가격테이블 lookup**으로 전환하라는 규칙도 암묵지의 코드화다 (`:39`) |
| **의도 → 주문** | 고객은 판형(`plt_siz_cd`)을 고르지 않는다. 완제품 사이즈만 고르면 `fn_best_plate`가 자동 도출한다 (`HARNESS-DOMAIN-RULES-260701.md:12`). 즉 **고객 의도(완제품)와 생산 실체(판형·판수) 사이에 이미 결정론 번역층이 있다** |

### 6.2 우리 시스템은 이미 Kautz 유형 2 (`Symbolic[Neuro]`)의 뼈대다

우리 4단 사슬 — **상품 → 가격공식 → 가격구성요소 → 가격표(단가)** (`가격파이프라인-쉬운설명-260629.md:33`) — 은 완전한 심볼릭 시스템이다. `evaluate_price`, `fn_best_plate`, `fn_calc_pansu`, `t_prd_product_constraints`(JSONLogic)는 Kautz가 말한 System 2 기호 서브시스템 그 자체다. 따라서 우리가 선택할 것은 "뉴로-심볼릭을 도입할까"가 아니라 **"이미 있는 심볼릭 엔진 어디에 신경 서브루틴 구멍을 뚫을까"** 다.

권장 등급: **`Symbolic[Neuro]`(유형 2) + `Neuro | Symbolic`(유형 3) 혼합.** 유형 1·4(LLM이 최종 금액을 산출)는 §5 F1·F3 때문에 **금지 등급**이다.

### 6.3 계층별 배치 — 무엇을 어디에 두는가

**심볼릭에 반드시 남긴다 (뉴로 접근 금지):**

| 대상 | 이유(§4 기준 번호) |
|---|---|
| 최종 금액 산출(`evaluate_price` 4단 사슬) | 기준1(틀리면 손해)·기준7(결정론). 우리 규율은 이미 "LLM 숫자전사 금지·결정론 파서" |
| 판걸이수 `fn_calc_pansu` / 판형 선택 `fn_best_plate` | 기준2(판정함수 존재)·기준3(기하·조합) |
| 제약규칙(JSONLogic, `t_prd_product_constraints`) | 기준2·기준5(감사·폼빌더 역파싱 필요) |
| 권위 엑셀 ↔ DB 셀 대조(배치 diff 스크립트) | 기준6(규칙이 이미 코드로 존재)·기준7 |
| 옵션 캐스케이드·유효 조합 열거 | 기준3(제약충족)·기준4(새 조합 외삽) |

**뉴로에 보낸다 (판정권 없음, 제안만):**

| 대상 | 결합 유형 | 심볼릭 검증기 |
|---|---|---|
| **의도 → 옵션 벡터 번역** ("A4 명함 500장 양면 코팅") → `{prd_cd, siz_cd, qty, 도수, 후가공}` 구조체 | 유형 3 (`Neuro \| Symbolic`) | 옵션 그룹·제약규칙이 즉시 판정. 불가 조합이면 LLM이 아니라 **제약 위반 메시지**가 반환 |
| **암묵지 후보 제안** (판걸이수 lookup 누락분, 시장가 2배 이상 상품의 테이블형 전환 후보) | 유형 3 | 시뮬레이터 재계산 + 경쟁사 벤치마크 오라클. 채택은 인간 승인 |
| **결함 원인 설명·라우팅** (견적 0, 저청구 발생 시 4단 사슬 중 어디가 끊겼는지 서술) | 유형 2 (기호 진단 결과의 자연어화) | 진단 자체는 스크립트가 한 것만 서술. 새 사실 생성 금지 |
| **가격표 시트 → 차원축 후보 추출** (복합셀 분해 시 차원 후보 제안) | 유형 3 | 권위 엑셀 verbatim 대조. 값 전사는 LLM 금지 |

### 6.4 조합폭발에 대한 처방 — 열거하지 말고 제약으로 접는다

우리 종료선은 "전 상품 × 전 옵션조합 100% 일치"인데, 이를 **전수 열거로 검증하려 하면 그 자체가 조합폭발**이다. NSAI 문헌의 답은 명확하다:

- **열거 대상을 제약 만족 공간으로 축소한다.** ConstraintLLM/FdConfig 계열의 제품 컨피규레이터가 쓰는 방식 — 제약충족 엔진이 유효 조합만 유지하므로 조합폭발이 완화된다. 우리에겐 이미 `t_prd_product_constraints`가 있으므로, **검증 대상은 "모든 조합"이 아니라 "제약을 통과하는 조합 + 각 차원축의 경계값"** 이다.
- **차원축 누락은 조합 개수로 안 보인다.** 우리 실사례 — 디지털인쇄비 212줄이 있어도 전부 칼라뿐이라 흑백 가격을 넣을 칸 자체가 없었다(`가격파이프라인-쉬운설명-260629.md:50` 인접 서술). 이는 **행 수(뉴로적 "많아 보임")가 아니라 스키마 차원축(심볼릭)으로만 검출**되는 결함이다. → 커버리지 판정은 100% 심볼릭.
- **탐색 안내에만 뉴로를 쓴다.** AlphaGeometry 패턴 대입: 배치 diff 스크립트가 결함 목록을 소진시킨 뒤 **막히는 지점**(예: 복합셀이 어느 차원으로 갈라지는지 애매한 시트)에서만 LLM이 "보조점"에 해당하는 **차원축 가설 1개**를 제안하고, 다시 결정론 스크립트가 검증한다.

### 6.5 암묵지에 대한 처방 — LLM은 발굴기, 권위는 사람·엑셀

암묵지(실무진 판걸이수, 면지는 제본비 포함 무가격, 실사 가격은 포스터/사인 매트릭스로 환원 등)는 **Garcez & Lamb의 "지식 추출(Challenge 1)"** 문제다. 안전한 운용 규약:

1. LLM은 **가설 + 출처 + 컨펌 질문** 형태로만 출력한다(우리 기존 하네스 규약 "추정 0"과 동일).
2. 채택된 암묵지는 **자연어 메모가 아니라 기호 자산**으로 착지시킨다 — `t_siz_pansu` 행, JSONLogic 규칙, 또는 도메인 규칙 문서의 번호 매긴 항목. (LLM-Augmented KG 패턴: LLM은 채우고, 질의·추론은 그래프/DB가 한다.)
3. **역방향 금지**: 라이브 DB나 경쟁사 값이 권위 엑셀을 덮어쓰지 못한다. NSAI 용어로는 "약한 신호원이 검증기를 재정의하는 것"이며 F2(자기검증 환상)의 조직판이다.

### 6.6 의도 → 주문에 대한 처방 — 번역층을 기호 객체로 못 박는다

Kautz 유형 3의 핵심은 **신경망이 내놓는 것이 답이 아니라 "기호 자료구조"** 라는 점이고, Kautz는 이를 Attention Schema라 불렀다. 우리 대응물은 **정규화된 주문 의도 객체**여야 한다.

```
[고객 자연어/이미지]
      │  (뉴로: 유형 3 변환기 — LLM)
      ▼
[주문 의도 객체]  ← 여기까지가 뉴로의 최대 권한
  { prd_cd, siz_cd, qty, 도수, 자재, 후가공[], 납기 }
      │  (심볼릭: 제약규칙 판정 → 불가 조합 차단·대안 제시)
      ▼
[유효 옵션 벡터]
      │  (심볼릭: fn_best_plate → plt_siz_cd, fn_calc_pansu → 판걸이수)
      ▼
[생산 정보]
      │  (심볼릭: evaluate_price 4단 사슬)
      ▼
[최종 금액]  ← 뉴로가 절대 손대지 않음
```

이 그림에서 중요한 것은 **화살표가 한 방향이 아니라는 점**이다. Logic-LM의 self-refinement, LLM-Modulo의 양방향 상호작용에 대응해, 제약 위반이나 견적 0이 나오면 **위반 사유(기호 메시지)를 뉴로 계층으로 되돌려** 재번역시킨다. 되돌리는 것은 **에러 코드/위반 규칙 ID**이지 "다시 잘 해봐"가 아니다.

### 6.7 우리 등급에서의 실패 모드 매핑

| NSAI 실패 모드 | 후니 맥락에서의 구체적 발현 | 방어선 |
|---|---|---|
| F1 형식화 오류 | LLM이 가격표 복합셀을 잘못된 차원으로 갈라 놓으면, 엔진은 그 잘못된 구조를 정확히 계산해 **틀린 가격을 자신 있게** 낸다 | 권위 엑셀 verbatim 대조 + 시뮬레이터 골든 재현(허용오차 0) |
| F2 자기검증 환상 | 에이전트가 "검증 완료"라고 보고했으나 명령을 실제로 돌리지 않은 경우 | 생성≠검증 분리(우리 게이트 규율) + 실행 로그 파일경로 인용 |
| F3 불충실한 설명 | 결함 원인 설명이 그럴듯하나 실제 원인(차원축 부재)과 무관 | 설명은 **스크립트 산출 결함 ID를 참조**해야만 유효 |
| F4 계산/추론 혼용 | LLM이 금액을 직접 계산·전사 | "LLM 숫자전사 금지" 규율(기존) — PoT 원칙과 동일 |
| F8 검색 부적합 | 유사 상품명으로 예제를 끌어와 다른 가격모델을 적용(공식형 vs 테이블형 혼동) | ConstraintLLM CARM 교훈 — **상품명이 아니라 가격모델 유형·차원축 프로파일로 검색** |
| F10 규칙 재발견 | 이미 `pricing.py`·도메인 규칙 12항에 있는 규칙을 LLM에게 다시 추론시킴 | 원본(엑셀 셀 + 실무진 코멘트 + `pricing.py`) 먼저 읽는 기존 규율 |

### 6.8 우리에게 권장되는 최소 구현 순서

1. **주문 의도 객체 스키마를 먼저 고정한다**(기호 인터페이스). 이것 없이 LLM을 붙이면 §5 F1이 확정적으로 발생한다.
2. **제약규칙(JSONLogic)을 의도 검증기로 승격**한다 — 이미 폼빌더 역파싱 가능한 정형 shape 규율이 있으므로 감사 가능성이 확보된다.
3. **PoT 규율 적용**: 금액이 관여하는 모든 경로를 함수 호출/SQL로만 흐르게 하고 LLM 토큰 산술을 금지한다.
4. **AlphaGeometry식 안내 루프**를 결함 잔여분에만 적용: 결정론 스크립트 소진 → 막힌 지점에서만 LLM 가설 1개 → 스크립트 재검증.
5. **F7 대비**: 설명가능성·메타인지가 NSAI 전반의 최약 고리(28%/5%)이므로, 우리 쪽에서는 **결함 ID ↔ 근거 파일:라인 추적성**을 대체 수단으로 쓴다.

---

## 미해결·한계

- **Kautz 원문 전체를 페이지 단위로 검증하지는 못했다.** 확보·추출한 것은 `cs.virginia.edu` 호스팅 PDF(DOI 10.1002/aaai.12036 메타데이터 포함)의 본문 텍스트이며, Wiley 원본 페이지는 HTTP 402(유료)로 접근 불가, `ojs.aaai.org` 항목 페이지는 서버 오류였다. 6분류 본문(pp. 118–121)은 verbatim 확인했다.
- **Garcez & Lamb(arXiv:2012.05876) 본문은 초록·목차·키워드 수준까지만 확인**했고, 3대 과제 문구는 PDF 텍스트 추출 grep 결과(챌린지 1~3 항목)에 근거한다. 각 챌린지의 상세 논증은 미독.
- **F9(결합도 과잉으로 인한 감사 난이도)·F10(규칙 재발견 낭비)은 [추정]** — 위 1차 출처들이 그 이름으로 명명한 실패 모드가 아니다. 설계 트레이드오프에서 유도한 것이다.
- **"의도 → 주문" 번역 품질에 대한 정량 근거 없음.** 인쇄 도메인 자연어 → 옵션 벡터 변환의 정확도를 다룬 1차 문헌을 이번 조사에서 찾지 못했다. ConstraintLLM/NL4OPT는 최적화 문제 형식화이지 상품 컨피규레이션 의도 파싱이 아니다. 후속 리서치 필요.
- **우리 라이브 수치는 재실측하지 않았다.** 252/134/118 상품 분포는 `가격파이프라인-쉬운설명-260629.md`(2026-06-29 시점) 기록이며 현재 라이브와 다를 수 있다. 본 문서는 아키텍처 이론 조사이므로 라이브 psql 실측을 수행하지 않았다.
- **`Neuro[Symbolic]`(유형 6)의 실무 적용 사례가 희박하다.** Kautz 본인이 가장 유망하다고 본 유형이지만, 2024 체계적 리뷰에서 4개 핵심 영역을 모두 교차한 사례가 AlphaGeometry 1편뿐이라는 점은 이 유형이 아직 연구 단계임을 시사한다. 우리 등급에는 부적합.

---

## Sources:

WebFetch로 실재를 확인한 URL만 나열한다.

1. [Kautz, H. (2022). The third AI summer: AAAI Robert S. Engelmore Memorial Lecture. *AI Magazine* 43(1), 105–125. DOI 10.1002/aaai.12036 (호스팅 PDF)](https://www.cs.virginia.edu/~rmw7my/papers/AI%20Magazine%20-%202022%20-%20Kautz%20-%20The%20third%20AI%20summer%20%20AAAI%20Robert%20S%20%20Engelmore%20Memorial%20Lecture.pdf) — 6분류 원문(pp. 118–121) verbatim 추출
2. [Garcez, A. d'A., & Lamb, L. C. (2020). Neurosymbolic AI: The 3rd Wave. arXiv:2012.05876](https://arxiv.org/abs/2012.05876)
3. [Chen, W., Ma, X., Wang, X., & Cohen, W. W. (2022). Program of Thoughts Prompting. arXiv:2211.12588 (TMLR 2023)](https://arxiv.org/abs/2211.12588)
4. [Pan, L., Albalak, A., Wang, X., & Wang, W. Y. (2023). Logic-LM. arXiv:2305.12295 (Findings of EMNLP 2023)](https://arxiv.org/abs/2305.12295)
5. [Kambhampati, S., et al. (2024). Position: LLMs Can't Plan, But Can Help Planning in LLM-Modulo Frameworks. PMLR 235:22895–22907](https://proceedings.mlr.press/v235/kambhampati24a.html)
6. [Kambhampati, S., et al. (2024). arXiv:2402.01817 (동일 논문 프리프린트)](https://arxiv.org/abs/2402.01817)
7. [Turpin, M., Michael, J., Perez, E., & Bowman, S. R. (2023). Language Models Don't Always Say What They Think. arXiv:2305.04388 (NeurIPS 2023)](https://arxiv.org/abs/2305.04388)
8. [Trinh, T., Wu, Y., Le, Q., He, H., & Luong, T. (2024). Solving olympiad geometry without human demonstrations. *Nature* 625, 476–482 (Google Research 공식 게재 페이지)](https://research.google/pubs/solving-olympiad-geometry-without-human-demonstrations/)
9. [ConstraintLLM: A Neuro-Symbolic Framework for Industrial-Level Constraint Programming. arXiv:2510.05774 (HTML 전문)](https://arxiv.org/html/2510.05774)
10. [Pan, S., Luo, L., Wang, Y., Chen, C., Wang, J., & Wu, X. (2024). Unifying Large Language Models and Knowledge Graphs: A Roadmap. IEEE TKDE. arXiv:2306.08302](https://arxiv.org/abs/2306.08302)
11. [Schick, T., et al. (2023). Toolformer: Language Models Can Teach Themselves to Use Tools. arXiv:2302.04761](https://arxiv.org/abs/2302.04761)
12. [Neuro-Symbolic AI in 2024: A Systematic Review. arXiv:2501.05435 (HTML 전문)](https://arxiv.org/html/2501.05435v1)
13. [Mathematical discoveries from program search with large language models (FunSearch). *Nature* 2023, PMC10794145](https://pmc.ncbi.nlm.nih.gov/articles/PMC10794145/)

### 프로젝트 내부 1차 근거(파일:라인)

- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md:12` — 판형은 고객이 선택하지 않고 `fn_best_plate`가 자동 도출
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md:23` — 판걸이수 3요소·실무진 값이 권위
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md:39` — 계산식 2배/시장가 초과 시 가격테이블 lookup으로 전환
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md:59` — 상품별 출력용지규격 상이
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:33` — 4단 사슬 중 하나라도 빠지면 가격이 틀린다
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:47` — 상품 252개 / 가격 산출 134 / 미산출 약 118
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:50` — 가격표는 수기 입력, 행 수만으로 완비 착각
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:113` — 완성 정의 4항(어떤 옵션 조합에도 정확한 가격)
- `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/가격파이프라인-쉬운설명-260629.md:117` — 종료 척도: 안 맞는 상품 0
