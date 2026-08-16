# R7 — 의도(자연어) → 주문(확정 견적) 자동화: 선행 사례와 아키텍처

## 요약

- 실제로 돌아간 사례들은 예외 없이 **"LLM은 의도를 해석하고, 가격·구성 확정은 결정론 엔진이 한다"** 는 분업을 택했다. Salesforce CPQ 실전 후기는 이를 *"중요하거나 민감한 비즈니스 규칙은 지시문(instructions)이 아니라 액션(actions)의 기능으로 구현하라 — 지시문은 비결정론적이다"* 로 정식화했다.
- OpenAI/Stripe의 Agentic Commerce Protocol(ACP)은 이 분업을 **프로토콜 수준에서 강제**한다. 라인아이템 단가·세금·배송비·합계는 전부 **머천트가 계산해 응답**하고, 에이전트(ChatGPT)는 그것을 **표시·수집만** 한다.
- 실패는 "가격이 조금 틀린다"가 아니라 **책임 문제**로 끝난다. Moffatt v. Air Canada(2024 BCCRT 149)는 챗봇 발화에 대해 회사가 과실 부실표시 책임을 진다고 판시했고, Chevrolet of Watsonville 사건(AIID #622)은 프롬프트 조작만으로 $1 계약 발언이 나올 수 있음을 보였다.
- 신뢰성의 병목은 평균 성공률이 아니라 **재현성**이다. τ-bench는 pass^1이 50% 미만인 에이전트의 pass^8이 retail에서 25% 미만으로 붕괴함을 보였다 — 같은 의도를 8번 말하면 같은 견적이 8번 나와야 하는 우리 문제와 정확히 같은 축이다.
- "모른다고 말하게 하는" 장치는 프롬프트가 아니라 **구조**다: 스키마에서 구속력 있는 필드를 제거하고(decision-negative), 비판 에이전트를 붙이고(환각 11.3%→3.8%), 불확실 케이스를 즉시 사람에게 라우팅한다.

---

## 본문

### 1. 왜 "복잡한 맞춤형 제품"이 별종인가

일반 이커머스(SKU 고정)에서 에이전트의 일은 검색·비교·결제 대행이다. 반면 인쇄·제조·보험·재보험처럼 **구성(configuration)이 가격을 만드는** 상품에서는 에이전트가 "무엇을 살지"를 확정하는 순간 **가격이 파생**된다. 즉 의도 해석 오류 = 금액 오류다. 조사한 사례는 모두 이 지점에서 아키텍처가 갈렸다.

### 2. (a) 실제로 주문/견적을 완성시킨 사례

#### 2-1. Salesforce CPQ 대화형 견적 에이전트 (실전 필드 리포트)

4개월간 Agentforce + Salesforce CPQ로 대화형 견적 에이전트를 운영한 후기. 월 140건 이상의 견적을 자동 생성했고, 건당 30분 걸리던 수작업 초안 작성을 대체했다.

기술적으로 두 번 방향을 틀었다.
- **상품 매칭**: RAG(실시간 DB 질의) → **In-Context Learning**(상품 데이터를 프롬프트에 직접 삽입). 데이터셋이 안정적이면 후자가 우월했다.
- **견적 생성**: Flow → 커스텀 Apex. Flow 방식은 "Unable to lock rows" 오류가 **50%를 초과**해 폐기했다.

핵심 교훈은 분업선이다: 상품 적격성 필터, 가격 검증 규칙, 자동 생성 추적 필드("Created by Automation")를 **전부 코드로 내렸다**. 근거는 *"actions는 독립적으로 테스트할 수 있지만 instructions는 신뢰성 있게 테스트할 수 없다"* 는 것. 동명이물 상품이 다수 존재하는 문제는 DB를 몇 달간 청소하는 대신 **의미검색 + 사용빈도 랭킹**으로 우회하고, 애매하면 되묻게 했다("Essential Training Package와 Essential License Bundle 중 어느 쪽입니까?").

#### 2-2. 상업보험 인수심사 에이전트 (Claude Sonnet 4.5, 500건 전문가 검증)

5계층 human-in-the-loop 구조: 입력층 → 에이전트 추론층 → **적대적 비판층** → 결정 인터페이스 → 시스템-오브-레코드(사람 승인 후에만 기록). 시스템은 명시적으로 **"decision-negative"** — 구속력 있는 행위 전에 반드시 인간 승인을 요구한다.

측정 결과(500 케이스):

| 지표 | 에이전트 단독 | 에이전트+비판자 |
|---|---|---|
| 판단 정확도 | 92% | 96% |
| 환각률 | 11.3% | 3.8% |
| 오탐(false positive) | 3.6% | 1% |
| 출처 추적성 | 81% | 96% |
| 처리시간 | (수작업 120분) | 20분 |

실패 모드 분류도 공개했다: 엣지케이스 누락 ~2%, 과보수적 판정 ~3%, 경미한 환각 ~3%, 비판자 오경보 ~5%, 시스템 통합 <1%. 비판 에이전트 자체는 진짜 문제 87% 포착 / 오탐 12% / 수정 성공 91%. 추가 연산비용은 건당 $0.26, 절감 인건비는 $60–75.

#### 2-3. 재보험 제출자료 처리 멀티에이전트 (Temporal)

지저분한 엑셀 제출팩 → 구조화된 재해 손실 레코드. 단일 거대 에이전트 대신 4개 순차 서브에이전트로 쪼갰다. 이유: *"에이전트에게 선택지가 많을수록 다음에 어떤 도구를 실행할지 헷갈릴 가능성이 커진다."*

안전장치가 이 사례의 본체다. **각 도구 실행과 각 에이전트 완료마다 사람이 확인/취소**하며, 시그널이 올 때까지 실행이 차단된다. Temporal Workflow의 지속 실행으로 LLM 호출/도구 실패 시 자동 재시도하고, 실패나 모호한 결과가 나오면 크래시 대신 **사용자에게 물어보게** 만들었다. 모든 에이전트 행동·시그널·업데이트가 Workflow 히스토리에 남아 감사 추적이 된다.

#### 2-4. ACP / ChatGPT Instant Checkout — 프로토콜이 강제하는 분업

ACP는 OpenAI·Stripe 공동 관리 개방 표준으로, 두 개의 API 표면(Agentic Checkout API, Delegate Payment API)을 정의한다. 설계 철학이 명확하다: 에이전트는 **merchant of record가 되지 않는다.**

체크아웃 스펙상 **머천트가 라인아이템 base_amount·할인·소계·세금·합계, 배송 옵션과 요금을 전부 계산해 반환**하고, 세션이 갱신될 때마다 머천트가 **재계산**해서 새 비용·새 옵션·새 오류를 돌려준다. ChatGPT는 표시·수집 계층일 뿐이며 가격을 만들지 않는다.

다만 상업적 결과는 냉정하다. 2025-09-29 Etsy로 시작한 in-chat 체크아웃은 2026-03경 **discovery-and-redirect 모델로 축소**됐다(참여 머천트 수가 극소수, 매출 미미). [추정] 프로토콜의 기술적 분업선은 살아남았지만, "대화 안에서 끝까지 사는" 경험 자체는 아직 검증되지 않았다는 신호다.

#### 2-5. Klarna — 과잉 자동화의 반례

2024-02 도입 후 30일 만에 230만 건 대화 처리(상담원 700명분), 대화의 67% 자동화. 그러나 2025-05 방향을 되돌려 사람을 다시 채용했다. CEO 발언: 비용이 지배 변수가 되면 *"결국 남는 건 낮은 품질"*. 현재는 AI가 정형 문의(여전히 약 2/3)를 처리하고 분쟁·사기·곤란 사례는 사람이 맡는 하이브리드다.

### 3. (b) 실패 지점과 대응 장치

| 실패 지점 | 실제 사례 | 대응 장치 |
|---|---|---|
| **가격/규칙 환각** | 인수심사 에이전트 단독 환각률 11.3% | 적대적 비판 에이전트 1회 사이클 → 3.8%. 모든 사실을 입력 데이터에 대조 |
| **비결정론적 규칙 준수** | Salesforce CPQ: 지시문으로 넣은 적격성 필터가 흔들림 | 규칙을 Apex/Flow 액션으로 하강. 액션은 단위 테스트 가능 |
| **재현성 붕괴** | τ-bench: pass^1 <50%인 에이전트의 retail pass^8 <25% | 상태 기반 채점(대화 종료 시 DB 상태를 목표 상태와 비교), pass^k를 릴리즈 게이트로 |
| **프롬프트 조작으로 인한 허위 확약** | Chevrolet of Watsonville 챗봇 "$1, 법적 구속력 있는 제안" (2023-12-18, AIID #622) | 출력 스키마에서 구속력 필드 제거, 가격은 서버가 서명, 대화 발화는 계약이 아님을 구조로 보장 |
| **되돌리기 불가 / 책임 소재** | Moffatt v. Air Canada — 회사가 챗봇 발화에 책임. "챗봇은 별개 법인" 주장 기각, 차액 배상 | 발화 전 사실 검증 의무, 정적 페이지와 에이전트 답변의 **단일 진실원** 통일 |
| **도구 실패 시 크래시/유령 상태** | 재보험 파이프라인 | Durable execution(자동 재시도) + 실패 시 사용자에게 질문 + Workflow 히스토리 감사 |
| **자신감 과잉** | RLHF/DPO가 verbalized confidence를 구조적으로 부풀림. 대형 모델도 최적 프롬프트에서 실측 정확도와 약 7% 괴리, production ECE 0.05–0.20 | temperature scaling / Platt·isotonic 보정 / 다중 프롬프트 집계(불일치를 저신뢰 신호로) |

### 4. (c) 사람은 어디에 들어가는가

조사한 사례들의 HITL 위치는 놀랄 만큼 일관된다.

1. **의도가 모호할 때 (전단부)** — Salesforce 에이전트의 되묻기. 사람은 "고객"으로서 개입한다.
2. **구속력 있는 행위 직전 (후단부)** — 인수심사의 decision-negative 구조. 시스템-오브-레코드는 **사람 승인 후에만** 기록된다. Palantir의 표현: *"AI는 인수 판단에 법적·윤리적으로 책임질 수 없다, 오직 사람만 가능하다."*
3. **도구 호출 단위 (중간, 강한 버전)** — 재보험 사례는 **각 도구 실행마다** 확인/취소를 요구한다. 이건 "블랙박스 자율 실행"을 "감독받는 조수"로 바꾸는 대가로 처리량을 포기한 선택이다.
4. **불확실성 임계 초과 시 즉시 에스컬레이션** — 고불확실 케이스는 곧바로 사람에게.
5. **감정·분쟁·예외** — Klarna가 되돌린 지점.

핵심 비대칭: **읽기는 자율, 쓰기는 승인.** 인수심사 시스템은 도구를 **read-only API로만 제한**했다.

### 5. (d) "모르는 것을 모른다"고 말하게 만드는 설계

프롬프트로 겸손을 요청하는 것은 가장 약한 장치다. 실제로 작동한 것들:

- **출력 스키마에서 능력을 제거한다.** 구속력 있는 결정 필드를 스키마에서 빼면 모델은 "확정"을 발화할 수 없다. 상태 기계가 순차 전이를 가드 조건으로 강제한다.
- **적대적 비판자를 붙인다.** 초안 + 추론 사슬을 받아 오류·근거 없는 가정·가이드라인 위반을 찾는 회의적 내부 검토자. 반사실 시나리오를 주입해 견고성을 시험한다. 1회 비판-수정 사이클 후 사람에게 넘긴다.
- **출처 추적성을 지표로 잡는다.** traceability 81%→96%. 근거를 못 대면 그 자체가 "모른다"의 신호다.
- **불일치를 신호로 쓴다.** 의미적으로 변형된 여러 프롬프트로 질의해 답이 갈리면, 개별 confidence가 높아도 저신뢰로 취급한다.
- **confidence gating.** 불확실도가 임계 τ를 넘으면 응답을 보류·플래그. [추정] coverage를 의도적으로 깎아 정밀도를 사는 거래이며, 견적처럼 오답 비용이 큰 도메인에서 유리하다.
- **되묻기를 실패가 아니라 성공 경로로 정의한다.** Salesforce 사례의 명시적 disambiguation 질문.

### 6. (e) 돈이 걸릴 때의 검증 아키텍처

수렴하는 형태는 3층이다.

```
[1] 의도 해석층 (LLM)        자연어 → 구조화된 구성 후보 + 신뢰도 + 미확정 슬롯
        ↓ (구조화 payload만 통과, 숫자는 통과 금지)
[2] 결정론 확정층 (엔진)      규칙 검증 → 가격 계산 → 정본 견적 생성
        ↓ (엔진 산출 숫자만)
[3] 대조·표시층              재계산 대조 / 감사로그 / 사람 승인 게이트
```

- **가격은 엔진만 만든다.** ACP가 프로토콜로 못박은 지점. 에이전트는 계산하지 않고 **머천트가 계산한 값을 표시**한다.
- **재계산 대조.** 세션이 바뀔 때마다 머천트가 전부 재계산해 반환한다. 즉 "직전 값 재사용" 자체를 금지하는 설계.
- **결정론적 재현 가능성 확보.** temperature 0 기본, 모델 버전 핀 고정, 프롬프트 버전·입력 데이터·입력 파라미터·판단 논리를 실행마다 기록(semantic record-keeping). 단, temperature 0에서도 상용 모델은 비결정론적으로 응답할 수 있으므로 **결정론은 모델이 아니라 엔진 쪽에서 확보해야 한다.**
- **상태 기반 채점.** τ-bench는 대화가 아니라 **최종 DB 상태**를 목표 상태와 비교한다. 견적 검증에도 그대로 이식 가능하다.
- **워크플로 우선.** Anthropic의 권고: *"단순 프롬프트에서 시작하고, 평가로 최적화하고, 단순한 해법이 부족할 때만 다단계 에이전트를 추가하라."* 에이전트는 비용과 **오류 누적**을 감수하는 선택이다.

---

## 우리 문제에의 적용 (후니프린팅)

### A. 3층 아키텍처를 우리 자산에 매핑하면

우리에겐 이미 [2] 결정론 확정층이 있다. 없는 건 [1]과 [3]이다.

| 층 | 후니 구현체 | 상태 |
|---|---|---|
| [1] 의도 해석 | (없음) 자연어 → 옵션 조합 | **신규** |
| [2] 결정론 확정 | `evaluate_price` / `t_prc_*` 4단(공식→formula_components→price_components→component_prices), `t_prd_product_constraints`(JSONLogic), CPQ `option_groups/options/option_items`, 셋트 `evaluate_set_price` | 존재, 정합 진행 중 |
| [3] 대조·표시 | 위젯, webadmin 실화면 | 부분 존재 |

**[HARD] 확정 규칙: LLM은 후니 견적에서 단 하나의 숫자도 만들지 않는다.** 이는 신규 규칙이 아니라 이미 우리 메모리에 있는 "LLM 숫자전사 금지(결정론 파서)" 원칙(`~/.claude/projects/-Users-innojini-Dev-HuniWeb/memory/MEMORY.md:13`)의 런타임 확장이다. ACP가 프로토콜로 못박은 것과 정확히 같은 선이다.

### B. 조합폭발 문제 — LLM이 풀 문제가 아니다

우리 조합폭발은 사이즈 × 자재 × 도수 × 인쇄옵션 × 공정 × 판형/판걸이수 × 수량구간 × 셋트 구성원의 곱이다. Salesforce 사례의 교훈을 그대로 적용하면:

- **적격 조합의 열거·차단은 LLM이 아니라 `t_prd_product_constraints`가 한다.** "제약규칙은 UI 폼빌더에서 역파싱 가능한 정형 shape로만" 이라는 기존 하네스 규율(§huni-constraint-rules)은 곧 **"규칙을 지시문이 아니라 액션으로 내려라"** 의 후니 버전이다. 이미 옳은 방향으로 가 있다.
- **LLM의 역할은 후보 축소(narrowing)와 슬롯 채우기뿐이다.** "명함 500장 고급스럽게" → `{상품군: 명함, 수량: 500, 자재: 미확정(고급 계열 후보 N개), 도수: 미확정, 후가공: 미확정}`. 조합 자체는 CPQ 레이어가 캐스케이드로 좁힌다.
- **동명이물 문제는 우리에게도 있다.** JOIN KEY가 `prd_nm`이라는 현실(`MEMORY.md:14`)은 Salesforce 사례의 "동일 이름 상품 다수" 상황과 동형이다. 그들의 처방(DB 청소를 몇 달 하는 대신 **의미검색 + 사용빈도 랭킹 + 되묻기**)은 우리 기초코드 정리(§huni-basecode)가 끝나기 전에도 [1]층을 띄울 수 있다는 뜻이다. [추정] 단, 되묻기 없이 자동 선택하면 조용한 오견적이 된다.

### C. 암묵지 문제 — 실무진 머릿속을 어디에 넣을 것인가

판걸이수(`fn_calc_pansu`), 판형=종이류 한정, 실사=포스터사인, 비규격 처리, 완제품 as-plate=결함 같은 규칙(`MEMORY.md:10-11`)은 전형적인 암묵지다. 조사 결과가 주는 지침은 명확하다.

- **암묵지를 프롬프트에 적으면 비결정론이 된다.** 지시문은 테스트할 수 없다. 암묵지는 **제약규칙 / 차원 테이블 / 함수**로 내려야 테스트 가능해진다.
- **아직 못 내린 암묵지는 "모른다"로 처리한다.** 인수심사 사례의 decision-negative 구조를 빌려, [1]층 출력 스키마에서 **가격·확정 필드를 아예 제거**한다. LLM 산출물은 `구성 후보 + 미확정 슬롯 목록 + 근거`뿐이며, 미확정 슬롯이 하나라도 있으면 견적은 "확정"이 아니라 "미확정"이다.
- **비판 에이전트를 우리 게이트로 재사용한다.** 우리는 이미 "생성≠검증" 게이트 문화를 갖고 있다(hcc/hpe/hbg의 GO/NO-GO 게이트). 런타임에도 같은 패턴을 넣을 수 있다: 해석기가 만든 구성안을 **권위 엑셀(상품마스터 260703 / 가격표 260705)과 라이브 t_* 실측**에 대조하는 비판 패스. 인수심사 사례에서 이 패스 하나가 환각을 11.3%→3.8%로 낮췄다.

### D. 의도 → 주문: 후니 HITL 배치안

```
고객 자연어
  ↓ [1] 해석기(LLM)  — 숫자 금지, 미확정 슬롯 명시
  ↓ ★게이트1: 미확정 슬롯 있으면 고객에게 되묻기 (실패 아님, 정상 경로)
  ↓ [2] CPQ 캐스케이드 + JSONLogic 제약 → 유효 조합만 통과
  ↓ [2] evaluate_price / evaluate_set_price  ← 유일한 가격 원천
  ↓ ★게이트2: 재계산 대조 (동일 입력 재호출 결과 일치 확인)
  ↓ [3] 고객 확인 화면(위젯) — 표시만
  ↓ ★게이트3: 비규격·신규 조합·제약 미커버 케이스 → 실무진 승인 큐
  주문 확정
```

- **게이트3의 판정 기준**: 해당 조합이 권위 가격표 격자 안의 실적재 셀인가. 우리 §26(가격테이블 무결성) 산출물의 "미적재 셀 / 이 빠진 적재" 보드가 그대로 **런타임 라우팅 테이블**이 된다. 미적재 셀이면 자동 확정 금지 → 사람.
- **읽기 자율, 쓰기 승인**: 인수심사 사례가 도구를 read-only API로 제한한 것은 우리의 "Railway DB=읽기전용 SELECT", "COMMIT=인간승인"(`MEMORY.md:13-14`)과 동일 원리다. 견적 조회는 자율, 주문 생성·가격 예외 승인은 사람.
- **Klarna 교훈의 후니 버전**: 정형(표준 규격 명함·전단 등)은 자율, 비정형(비규격 사이즈, 특수 후가공, 대량 협의가)은 사람. 처음부터 100% 자동화를 목표로 두지 않는다.

### E. 릴리즈 게이트를 pass^k로

τ-bench의 교훈이 우리에게 가장 직접적이다. **"같은 의도를 8번 말하면 같은 견적이 8번 나오는가"** 를 게이트로 삼는다.

- 골든 케이스(상품군별 대표 의도 문장) × k회 재실행 → **최종 상태(선택된 옵션 집합 + 최종가) 완전일치율**을 측정. 대화 텍스트가 아니라 **상태**를 채점한다는 점이 핵심.
- 우리는 이미 골든 케이스·허용오차 0 재현 검증(hpe E1~E7, hrev-golden-capture)을 갖고 있다. [1]층이 붙는 순간 그 골든 세트의 **입력을 자연어로 바꾸면** 그대로 pass^k 게이트가 된다.
- [추정] 초기 pass^8은 낮게 나올 것이다. 낮은 pass^k를 프롬프트로 올리려 하지 말고, **불일치한 슬롯을 제약규칙/옵션그룹으로 하강**시키는 신호로 읽는 편이 사례들과 일치한다.

### F. 책임 설계 — 발화는 계약이 아니다

Moffatt 판결과 Chevrolet 사건을 우리 조건으로 옮기면:

- 견적 화면에 표시되는 금액과 대화창에서 LLM이 말한 금액이 **다를 수 있는 구조 자체가 리스크**다. Air Canada가 진 이유가 정확히 "정적 페이지와 챗봇 답변의 불일치"였다.
- 따라서 **대화 응답의 금액은 반드시 `evaluate_price` 반환값을 그대로 렌더한 토큰이어야 하며, LLM이 문장 안에서 숫자를 재작성하지 못하게** 한다. [추정] 실무적으로는 금액을 플레이스홀더로만 생성시키고 서버에서 치환하는 방식이 가장 안전하다.
- 프롬프트 조작으로 "이 가격에 계약합니다" 류 발화가 나오지 못하도록, **확약 어휘를 출력 스키마에서 배제**하고 주문 확정은 별도 서명된 서버 액션으로만 발생시킨다.

---

## 미해결·한계

- **인쇄 도메인 특화 1차 사례를 찾지 못했다.** 조사된 실증 사례는 CPQ(소프트웨어 라이선스), 보험/재보험, 리테일 체크아웃이다. 인쇄 MIS 영역의 RFQ 자동화 글들은 벤더 마케팅이 대부분이고 실패 후기·수치가 없어 근거로 채택하지 않았다.
- **ACP의 사업적 실패 원인이 불명확하다.** in-chat 체크아웃이 축소된 것이 UX 문제인지, 머천트 통합 비용 문제인지, 수요 부재인지 1차 자료로 확인하지 못했다. 우리 위젯 UX 결정에 직접 인용하기엔 근거가 얇다.
- **pass^k를 우리 견적 도메인에서 실측한 적이 없다.** 위 E절의 게이트 제안은 τ-bench 방법론의 이식이며, 후니 데이터로 검증된 바 없다. [추정]
- **비판 에이전트의 비용/지연 트레이드오프 미검증.** 인용한 수치(건당 $0.26, 환각 11.3%→3.8%)는 보험 인수심사 조건이다. 견적처럼 응답 지연이 이탈로 직결되는 실시간 경로에 같은 구조를 넣을 수 있는지는 별도 검증이 필요하다.
- **abstention 문헌 1건(opendatascience)은 403으로 원문 검증에 실패해 인용에서 제외**했다. (d)절의 confidence gating 서술은 calibration 문헌 쪽 근거만으로 구성했다.
- **"미확정 슬롯"의 판정 기준을 아직 정의하지 못했다.** 무엇을 물어보고 무엇을 기본값으로 둘 것인가는 실무진 암묵지 인터뷰가 선행되어야 한다 — 이는 R7 범위 밖이다.

---

## Sources:

- [Real-world agents: a production-grade Salesforce agent for CPQ quoting — AI Builders](https://www.aibuilders.blog/p/a-production-grade-salesforce-agent)
- [Agentic AI for Commercial Insurance Underwriting with Adversarial Self-Critique — arXiv 2602.13213](https://arxiv.org/html/2602.13213)
- [Trusting AI agents: A reinsurance case study — Temporal](https://temporal.io/blog/trusting-ai-agents-a-reinsurance-case-study)
- [Agentic Commerce Protocol (ACP) — GitHub, maintained by OpenAI and Stripe](https://github.com/agentic-commerce-protocol/agentic-commerce-protocol)
- [Agentic Checkout Spec — OpenAI Developers](https://developers.openai.com/commerce/specs/checkout/)
- [τ-bench: A Benchmark for Tool-Agent-User Interaction in Real-World Domains — arXiv 2406.12045](https://arxiv.org/abs/2406.12045)
- [Moffatt v. Air Canada: A Misrepresentation by an AI Chatbot — McCarthy Tétrault](https://www.mccarthy.ca/en/insights/blogs/techlex/moffatt-v-air-canada-misrepresentation-ai-chatbot)
- [Incident 622: Chevrolet Dealer Chatbot Agrees to Sell Tahoe for $1 — AI Incident Database](https://incidentdatabase.ai/cite/622/)
- [Requirements for AI in Production in Insurance Underwriting — Palantir Blog](https://blog.palantir.com/requirements-for-ai-in-production-in-insurance-underwriting-04f7c1eed13d)
- [Building Effective Agents — Anthropic Engineering](https://www.anthropic.com/engineering/building-effective-agents)
- [Your Model Is Most Wrong When It Sounds Most Sure: LLM Calibration in Production — TianPan.co](https://tianpan.co/blog/2026-04-20-llm-calibration-production-overconfidence)
- [Klarna changes its AI tune and again recruits humans for customer service — CX Dive](https://www.customerexperiencedive.com/news/klarna-reinvests-human-talent-customer-service-AI-chatbot/747586/)

내부 근거:
- `/Users/innojini/.claude/projects/-Users-innojini-Dev-HuniWeb/memory/MEMORY.md:8-16` — 권위 엑셀 최신본, 도메인 규칙 12항, 판형사이즈 권위, LLM 숫자전사 금지·COMMIT 인간승인, Railway 읽기전용·JOIN KEY=prd_nm
