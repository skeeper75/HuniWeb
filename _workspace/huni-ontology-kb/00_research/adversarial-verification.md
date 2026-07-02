# 렌즈 5 — 적대적 검증·오염 필터링 방법론 리서치

> 작성: 2026-07-03 · 작성자: okb-methodology-researcher (렌즈 5 배정분)
> 목적: 온톨로지 지식베이스(KB)의 산출물이 "그럴듯한 거짓"으로 오염되는 것을 막는 검증 방법을,
> 외부 학술·산업 방법론 + **이 레포에서 이미 실증된 검증 사례**(1차 증거)로 종합하고,
> O1~O7 게이트(`okb-adversarial-gate` 스킬)를 구체화할 권고를 낸다.
> 규모 전제: 상품 283개 · t_* 34테이블 · 운영자 1명 · git 파일 레포(트리플스토어 아님).

---

## 0. 이 렌즈의 한 문장 결론

**후니는 일반적인 "사실 검증(fact verification)" 문제보다 훨씬 유리한 조건에 있다 — 정답 기계(oracle, 오라클: 정답을 돌려주는 기준 장치)가 이미 둘이나 있기 때문이다(권위 엑셀 260702 + 라이브 가격엔진 evaluate_price).** 따라서 외부 방법론 중 "검색해서 맞는지 확인" 계열은 오라클이 없는 서술(도메인 원리 설명 등)에만 쓰고, 수치·연결·구조는 전부 **결정론 대조(deterministic diff: 같은 입력이면 항상 같은 결과가 나오는 스크립트 비교)**로 검증하는 것이 정답이다. 이는 이 레포의 실전(wiring_scan·grid_diff·골든 오차 0)이 이미 증명했다.

---

## ① 핵심 발견 (외부 방법론 + 레포 내부 실증)

### 1-A. 원자 단위 분해 → 개별 검증 (atomic claim verification)

- **FActScore** (Min et al., EMNLP 2023): 긴 LLM 산출문을 "원자 사실(atomic fact: 더 쪼갤 수 없는 짧은 주장 한 개)"로 분해한 뒤, 각각을 신뢰 가능한 지식원과 대조해 "지지되는 비율"을 점수화. 문서 전체를 한 덩어리로 채점하면 오류가 숨는다는 것이 출발점.
  출처: https://arxiv.org/abs/2305.14251 · 구현: https://github.com/shmsw25/FActScore
- **SAFE** (Wei et al., Google DeepMind 2024, "Long-form factuality in large language models"): LLM이 응답을 사실 단위로 분해하고, 각 사실을 검색으로 확인하는 자동 평가기. 사람 평가자보다 정확하고 저렴함을 실증.
  출처: https://arxiv.org/abs/2403.18802 (제목·SAFE 내용 직접 확인함)
- **주의 — 검증기 자체의 함정**: "Verifying the Verifiers"는 사실 검증기(verifier)들이 갖는 편향과 실패 유형을 정리 — 검증기도 틀린다.
  출처: https://arxiv.org/pdf/2506.13342

**레포 내부 실증(1차 증거)**: §9 위키·okb 집필 컨벤션의 "모든 블록 출처+badge 필수"가 이미 원자 단위 검증 구조다. 문서 전체가 아니라 블록(노드) 단위로 출처를 달았기 때문에 dbmap round-13에서 **F-PB-1 "oracle 날조"** — 생성 에이전트가 포토북 소프트 page "4~14"를 엑셀 권위값이라고 단언했으나 검증자가 실측하니 해당 셀이 공란이었던 사건 — 을 블록 단위로 적발·교정할 수 있었다(출처: `_workspace/huni-dbmap/17_correctness/_gate/photobook-gate.md` §2.2, `huni-dbmap/HANDOFF.md:182`). 같은 유형으로 huni-widget에서도 **G-1 ATTB 권위 날조**(존재하지 않는 소스 라인 인용) 적발 사례가 있다(출처: `_workspace/huni-widget/CHANGELOG.md` 2026-06-04 행).

### 1-B. 자기검증 계열 — 자기 초안에 스스로 검증 질문을 던지기

- **Chain-of-Verification(CoVe)** (Meta AI, ACL Findings 2024): ① 초안 작성 → ② 초안을 검증할 질문 목록 생성 → ③ 그 질문에 **초안을 보지 않고** 독립적으로 답 → ④ 불일치를 반영해 최종본. 목록형 답·긴 산출문에서 환각(hallucination: 그럴듯한 거짓 생성)이 감소함을 실증.
  출처: https://arxiv.org/abs/2309.11495 · https://aclanthology.org/2024.findings-acl.212/
- **SelfCheckGPT** (EMNLP 2023): 같은 질문에 여러 번 답하게 해서 답이 서로 갈리면 환각으로 판정(외부 지식원 없이도 동작).
  출처: https://arxiv.org/abs/2303.08896
- **한계(레포 실증이 이김)**: excel-to-db 플레이북 횡단원칙 3 — "자기일관 오류는 자기검증 불가 → 교차검증 필요"(출처: `_workspace/excel-to-db/_meta/best-practices-playbook.md`). 즉 자기검증은 보조 수단이고, 최종 판정은 **다른 행위자**가 해야 한다.

### 1-C. 반증 패널 — 여러 행위자가 서로 공격하게 하기 (refutation / debate)

- **다중 에이전트 토론** (Du et al. 2023): 여러 LLM 인스턴스가 각자 답을 내고 여러 라운드 서로 반박하게 하면 사실성·추론이 개선됨을 실증.
  출처: https://arxiv.org/abs/2305.14325 (제목·내용 직접 확인함)
- **MAD-Fact** (2025): 긴 산출문 사실성 평가에 토론 프레임워크를 적용. 출처: https://arxiv.org/pdf/2510.22967
- **Elenchus** (2026): "주장자(prover) vs 회의자(skeptic)" 대화로 지식베이스를 생성 — KB 구축 자체에 반증 구도를 넣은 최신 사례. 출처: https://arxiv.org/pdf/2603.06974

**레포 내부 실증**: 이 레포의 "생성≠검증 + codex 독립 2차 교차(다른 모델 계열) + codex 주장=가설"이 정확히 이 계열의 실전형이다. §23 088 재설계에서 codex 13/13 합의, §27 배선에서 codex high 7/8 AGREE 후 불일치 1건만 사람이 reconcile — 토론을 "무제한 라운드"가 아니라 **합의/불일치 분류 후 불일치만 조사**로 좁힌 형태가 이미 작동 중(출처: CLAUDE.md §23·§27 변경이력, `.claude/skills/hqv-codex-cross-verify`).

### 1-D. 골든 대조·결정론 diff (golden master)

- **특성화 테스트/골든 마스터(characterization test)**: 현재 동작의 스냅숏을 "골든(정답본)"으로 저장하고, 변경 후 결과를 결정론적으로 diff해 의도치 않은 변화를 잡는 고전 기법. 전제 조건은 "비교 대상을 결정론적으로 만들 것".
  출처: https://en.wikipedia.org/wiki/Characterization_test · https://understandlegacycode.com/blog/characterization-tests-or-approval-tests/
- **레포 내부 실증(외부보다 강함)**: `wiring_scan.py`(배선 결함 4종 토큰 0 검출), `grid_diff.py`(권위 CSV↔라이브 스냅샷 셀 단위 diff), `contribution_sim_scan.py`(뷰어 재현 시뮬레이트만이 진짜 F층 — 정적 스캔은 과적발), 골든 재현 오차 0(088: 39,000/290,000/1,800,000), **PRICE=0=결함신호[HARD]**. 특히 "정적 스캔 과적발 → 시뮬레이트 재현이 유일 신뢰" 교훈은 골든 대조의 **관측 지점을 실제 실행 경로에 놓아야 한다**는 외부 원칙의 실전 확인이다(출처: MEMORY `silent-zero-final-simscan-260701` · `formula-components-wiring-subtrack-260701`).

### 1-E. 출처 강제 (provenance: 이 지식이 어디서 왔는지의 기록)

- **W3C PROV-O**: "누가·언제·무엇으로부터 이 데이터가 생겼나"를 표현하는 웹 표준 온톨로지. 출처: https://www.w3.org/TR/prov-o/
- **나노퍼블리케이션(nanopublication)**: 지식 한 조각을 ① 주장(assertion) ② 출처(provenance) ③ 발행정보(publication info) 3부분으로 **분리 저장**하는 구조 — 주장과 그 근거를 절대 한 덩어리로 뭉치지 않는다. 출처: https://nanopub.net/guidelines/working_draft/
- **레포 내부 실증**: §9 위키의 "모든 블록 출처+badge", dbmap의 "양면 표기(라이브 현재값 vs 권위 정답)"가 경량 나노펍 구조에 해당. F-PB-1 적발이 가능했던 것도 출처 필드가 강제였기 때문(출처 없는 주장이었다면 대조 자체가 불가).

### 1-F. 오염 데이터 격리 (contamination quarantine)

- **PoisonedRAG** (USENIX Security 2025): 검색증강생성(RAG: 문서를 검색해 답에 근거로 쓰는 방식)의 지식저장소에 악성 문서 몇 개만 섞여도 답변을 90% 조작 가능함을 실증 — "저장소에 무엇이 들어가는가"가 곧 답변 품질.
  출처: https://arxiv.org/abs/2402.07867 · https://github.com/sleeepeer/PoisonedRAG
- 방어책으로 검색 폭 확대(knowledge expansion)·다수결 응답(RobustRAG) 등이 제안되나 불충분하다는 후속 연구: https://arxiv.org/pdf/2508.02835
- **레포 내부 실증(후니의 오염원은 공격자가 아니라 "낡음과 환각")**: ① STALE/v03 인용 금지[HARD](§9 — round-14 freshness 권위) ② 구권위(260610/260527) 잔재 — 260702 채택으로 diff 셀 33+32개가 낡은 값이 됨 ③ 라이브 오적재를 정답처럼 베끼는 오염(round-13: 라이브=교정 대상, 권위 역전 금지) ④ LLM 환각 개체(원천 어디에도 없는 그럴듯한 중간 개념). 후니의 격리 대상은 이 4종이지 외부 공격자가 아니다.

### 1-G. 그래프 구조 검증 (스키마 제약 lint)

- **SHACL**(Shapes Constraint Language): RDF 그래프가 정해진 모양(타입·필수 속성·개수 제약)을 지키는지 검사하는 W3C 표준. 출처: https://www.w3.org/TR/shacl/ · 데이터 품질 평가 적합성 논의: https://arxiv.org/abs/2507.22305
- **GraphEval**: 지식그래프 구조를 이용해 LLM 환각을 평가하는 프레임워크. 출처: https://arxiv.org/pdf/2407.10793
- **레포 내부 실증**: dbmap의 FK 고아 검출·`fn_chk_opt_item_ref` 트리거(옵션 참조는 같은 부모에 실재해야)·round-13 "카테고리 고아 오연결" 적발 — 구조 제약 검사가 실결함을 잡아온 이력.

---

## ② 후니 적용 권고 (채택 / 기각 / 보류)

| # | 방법론 | 판정 | 이유 (후니 규모·기존 실증 기준) |
|---|--------|------|------|
| R1 | **노드 단위 출처 강제(경량 나노펍 3분리)** — 모든 KB 노드에 `주장 본문 / 출처(파일경로+시트·셀 또는 테이블·행 좌표+수집일) / 상태 badge`를 구조화 필드로 분리 | **채택** | F-PB-1·G-1 날조 적발이 전부 "출처 필드가 있어서" 가능했다. RDF/PROV-O 문법은 불필요 — markdown frontmatter + 정형 필드면 충분(운영자 1명·git 레포). 출처 없는 주장 = lint 결함으로 기계 적발 |
| R2 | **수치는 산문 금지·구조화 필드로만** — 가격·치수·수량 등 숫자는 본문 문장에 녹이지 말고 스크립트가 diff할 수 있는 표/필드에만 기록 | **채택** | LLM 숫자 전사 금지[HARD](excel-to-db 플레이북 원칙 2)의 KB판. 산문 속 숫자는 결정론 대조가 불가능해 O2 게이트의 사각지대가 된다 |
| R3 | **골든 대조 결정론 diff를 O2의 유일 판정기로** — 노드 수치 ↔ 권위 260702 CSV 캐시를 스크립트 전수 diff(오차 0), LLM 자연어 대조는 판정에 불사용 | **채택** | grid_diff·wiring_scan 실증: 자연어 대조보다 정확하고 토큰 0. 외부 golden master 원칙("결정론으로 만들라")과 일치 |
| R4 | **오염 4종 명시 블록리스트** — ① STALE/v03 문서 목록 ② 구권위 260610/260527의 260702-diff 셀 목록 ③ 라이브 오적재 목록(양면 표기 강제) ④ 환각 개체(아래 R5) 를 `05_verification/`에 기계가 읽는 목록 파일로 유지, 인용 시 lint FAIL | **채택** | PoisonedRAG의 교훈("저장소 입구를 지켜라")을 후니 오염원 4종에 맞게 번안. 목록 파일이 있어야 검증이 사람 기억이 아닌 스크립트가 된다 |
| R5 | **환각 개체 차단 = 닫힌 세계 앵커링** — 개체(상품·자재·공정·옵션·사이즈) 노드는 반드시 실존 앵커(t_* 코드 또는 권위 엑셀 셀 좌표)를 가져야 하며, 앵커 없는 개체는 GAP 노드로만 존재 가능 | **채택** | LLM KG 구축의 최대 결함=환각 개체(§1-G GraphEval·KG construction 연구 공통 경고). 후니는 개체 전수가 유한(283상품·34테이블)하므로 "코드 실재 확인"이라는 결정론 검사로 완전 차단 가능 — 외부 연구가 못 누리는 이점 |
| R6 | **반증 패널 = codex 교차(불일치만 조사) + 3렌즈 반증** | **채택(현행 유지)** | 다중 에이전트 토론(Du et al.)의 실전 경량형이 이미 작동 중(codex 합의/불일치 분류). 무제한 토론 라운드는 운영자 1명 규모에 과함. 스킬의 3렌즈(도메인 원리/데이터/이력)로 충분 |
| R7 | **CoVe식 검증 질문을 O6 시나리오 생성에 차용** — 질의 게이트 시나리오(≥12·5유형)를 만들 때 "이 KB가 틀렸다면 어디서 틀렸을까"를 묻는 검증 질문 목록을 먼저 뽑고, 그 질문이 최소 1개씩 시나리오에 반영되게 | **채택** | CoVe의 핵심(초안과 독립된 검증 질문)이 블라인드 질의 프로토콜과 정확히 맞물린다. 비용 추가 거의 0 |
| R8 | **SHACL 도구 도입** | **기각** | RDF 스택·트리플스토어 전제 — 파일=정본·그래프=파생 빌드인 후니 구조에 안 맞고 운영자 1명에 과함. 대신 **"SHACL-lite"**: build_graph.py에 타입·필수엣지·개수 제약 lint를 내장(같은 효과·도구 0개 추가) — 이건 채택 |
| R9 | **SelfCheckGPT(다중 샘플 자기일관 검사)** | **기각** | 자기일관 오류는 자기검증 불가(레포 실증이 이김). 후니는 더 강한 오라클(결정론 diff·evaluate_price 실측)이 있어 확률적 자기검사가 하위호환. 오라클이 전혀 없는 서술 노드에 한해 보류 가능하나 codex 교차가 이미 그 역할 |
| R10 | **검색 기반 사실 검증(SAFE/FActScore 원형 그대로)** | **기각(구조만 차용)** | Google 검색 대조는 후니 내부 지식(자사 가격·공정)에 무의미 — 권위는 웹이 아니라 엑셀과 라이브 DB. 단 "원자 분해 후 개별 검증" 구조는 R1로 이미 흡수 |
| R11 | **RAG 포이즈닝 방어(RobustRAG·knowledge expansion)** | **기각** | 외부 공격자 모델 전제. 후니 KB는 git으로 입고가 통제되는 닫힌 저장소 — 위협은 공격이 아니라 낡음·환각이며 R4·R5가 그 방어 |
| R12 | **검증기 편향 감사("Verifying the Verifiers")** — 검증자(verifier·query-gate)가 낸 FAIL/PASS 표본을 주기적으로 사람이 재감사 | **보류** | 원칙은 옳으나(검증기도 틀린다 — 실제로 §26에서 "가변 component 오진단"을 후속 세션이 정정한 이력 있음) 상시 프로세스로 만들기엔 운영자 1명 부담. 파일럿 1회 완주 후 오판율을 보고 결정 |

---

## ③ 설계자(okb-ontology-architect)에게 넘길 결정 항목

O1~O7 게이트가 위 권고대로 작동하려면 **스키마 설계 단계에서** 다음이 확정돼야 한다(검증 단계에서 소급 불가):

1. **노드 provenance 필드의 정형 shape** (R1) — `source_file / source_locator(시트·셀 | 테이블·키 | 문서·행) / captured_at / badge` 4필드를 frontmatter 표준으로. 출처 lint 스크립트가 파싱할 수 있는 형식이어야 O1이 기계 검사가 된다.
2. **수치의 저장 위치 규약** (R2) — 가격·치수·수량은 어느 필드/표에만 두는지, 산문 속 숫자를 lint가 어떻게 적발하는지(예: 본문 정규식 스캔 + 허용 예외 태그).
3. **개체 노드의 앵커 필수 규칙** (R5) — 앵커 유형 열거(t_* 코드 / 엑셀 셀 / GAP 선언)와, 앵커 실재 확인 스크립트가 조회할 기준 스냅샷(`_foundation/live-snapshot/` 재사용 여부).
4. **오염 목록 파일의 위치·형식** (R4) — STALE 목록·구권위 diff 셀 목록·라이브 오적재(양면) 목록을 어디에 어떤 스키마로 두고, 빌드가 이를 어떻게 참조하는지.
5. **양면 표기의 구조화** — "라이브 현재값 vs 권위 정답"을 산문이 아닌 두 필드로 분리해야 O3(양면 위반)이 기계 검사 가능.
6. **SHACL-lite lint 규칙 목록** (R8) — 노드 타입별 필수 엣지·개수 제약(예: 상품 노드는 가격공식 엣지 1개 이상 또는 GAP 선언)을 스키마 문서에 같이 정의.
7. **범위 선언(scope) 노드** — O6 거절형 질의("범위 밖이면 정직하게 거절")가 성립하려면 "이 KB가 다루는 범위"가 노드로 존재해야 함. 어디까지를 범위로 선언할지.
8. **검증 스크립트 계약** — `05_verification/scripts/`에 두는 스크립트들의 입출력 계약(재실행 가능·멱등)과, O4의 "build 2회 실행 멱등" 판정 방식.

---

## ④ 미확인 / 추가 조사 필요

- **Elenchus(prover-skeptic KB 생성, arXiv 2603.06974)** — 검색 결과로 실재 확인했으나 본문 정독은 안 함. KB "생성 단계"에 반증을 내장하는 구체 프로토콜이 후니 builder↔verifier 분업에 추가로 줄 것이 있는지는 미확인 (우선순위 낮음 — 현행 생성≠검증이 이미 동등 구조).
- **MAD-Fact(2510.22967)·Traceback of Poisoning(2504.21668)** — 제목·초록 수준만 확인. 오염 발생 후 "어느 입고분이 오염원인지 역추적" 기법은 후니 git 이력(blame)으로 대체 가능해 보이나 대조는 안 해봄.
- **R12(검증기 재감사)의 실측 근거** — 이 레포에서 검증자 오판이 몇 건이었는지 전수 집계는 없음(확인된 사례: §26 가변 component 오진단 정정, 썬캡 "기하0" 오판 정정). 파일럿 후 집계 권장.
- **국내 커머스 KB의 오염 관리 사례** — 한국어 자료 조사는 하지 않음. 필요성 낮다고 판단(후니 오염원 4종이 이미 레포 이력에서 확정적).

## 출처 목록 (요약)

외부: [FActScore](https://arxiv.org/abs/2305.14251) · [SAFE](https://arxiv.org/abs/2403.18802) · [Verifying the Verifiers](https://arxiv.org/pdf/2506.13342) · [CoVe](https://arxiv.org/abs/2309.11495) · [SelfCheckGPT](https://arxiv.org/abs/2303.08896) · [Multiagent Debate](https://arxiv.org/abs/2305.14325) · [MAD-Fact](https://arxiv.org/pdf/2510.22967) · [Elenchus](https://arxiv.org/pdf/2603.06974) · [PoisonedRAG](https://arxiv.org/abs/2402.07867) · [RAG 방어 한계](https://arxiv.org/pdf/2508.02835) · [PROV-O](https://www.w3.org/TR/prov-o/) · [Nanopublication](https://nanopub.net/guidelines/working_draft/) · [SHACL](https://www.w3.org/TR/shacl/) · [SHACL 품질평가 적합성](https://arxiv.org/abs/2507.22305) · [GraphEval](https://arxiv.org/pdf/2407.10793) · [Characterization test](https://en.wikipedia.org/wiki/Characterization_test) · [Approval tests 해설](https://understandlegacycode.com/blog/characterization-tests-or-approval-tests/)

내부(1차 증거): `_workspace/excel-to-db/_meta/best-practices-playbook.md` · `_workspace/huni-dbmap/17_correctness/_gate/photobook-gate.md`(F-PB-1) · `_workspace/huni-dbmap/HANDOFF.md:182` · `_workspace/huni-widget/CHANGELOG.md`(G-1 날조) · `.claude/skills/okb-adversarial-gate/SKILL.md` · MEMORY [[silent-zero-final-simscan-260701]] · [[formula-components-wiring-subtrack-260701]] · `docs/kb/03_레드프린팅_경쟁분석_온톨로지전략.md`
