# 렌즈 4 — LLM 자기회귀 개선 루프 (스스로 좋아지는 지식베이스 운영 방법)

> 작성: 2026-07-03 · 작성자: okb-methodology-researcher (렌즈 4 배정분만)
> 질문: "에이전트(AI)가 지식베이스(위키)를 스스로 점검하고 — 빠진 것을 찾고(누락 감지), 채우고(보강), 다시 확인하는(재검증) — 운영 루프를 어떻게 설계해야 하는가? 지식이 낡는 것(staleness, 스테일니스 = 원천이 바뀌었는데 문서는 옛 내용인 상태)은 어떻게 관리하는가?"
> 전제: 이 레포의 기존 실증이 1차 증거. 외부 방법론은 그 위에 얹는다.

---

## ① 핵심 발견 (실존 출처 포함)

### 발견 1 — "AI 혼자 자기 답을 고치는 것"은 학계에서 이미 한계가 실증됨 → 외부 근거 기반 교정만 유효

- **Self-Refine** (Madaan et al. 2023): 같은 LLM이 "생성 → 자기 피드백 → 수정"을 반복하면 1회 생성보다 평균 약 20% 좋아진다는 원조 논문. 훈련 없이 프롬프트만으로 루프를 돈다.
  - 출처: https://arxiv.org/abs/2303.17651
- **그러나 결정적 반박** — "LLMs Cannot Self-Correct Reasoning Yet" (Huang et al., ICLR 2024): **외부 피드백 없이** 모델이 스스로 답을 재검토하게 하면 추론 문제에서는 오히려 **성능이 나빠지는 경우가 많다**는 실증. "자기 확신을 자기 검증으로 쓸 수 없다"는 결론.
  - 출처: https://arxiv.org/abs/2310.01798
- **CRITIC** (Gou et al., ICLR 2024): 자기 교정이 작동하려면 **도구(검색·코드 실행·계산기 등 외부 수단)로 검증한 결과**를 피드백으로 넣어야 한다는 프레임워크. "① 도구로 검증 → ② 그 비평을 근거로 수정"의 2단계.
  - 출처: https://arxiv.org/abs/2305.11738

**이 레포 실증과의 정합:** 이 결론은 레포의 [HARD] 규칙 **"생성≠검증"**(만든 에이전트가 자기 산출을 승인 못 함·codex 독립 2차 교차), **결정론 diff가 측도**(`wiring_scan.py` 배선 결함 수, §26 grid-diff 셀 대조 — 토큰 0의 외부 근거)와 정확히 같은 방향이다. 즉 학계 최신 결론과 레포 26라운드 실전이 **"자기 느낌으로 고치지 말고, 스크립트/실측이라는 외부 자로 재고 고쳐라"**로 수렴한다.
  - 레포 출처: `_workspace/excel-to-db/_meta/best-practices-playbook.md` 횡단 원칙 3·5, `_workspace/_foundation/batch/wiring_scan.py`(§27 배선 서브트랙 — "결함 0"이라는 숫자 종료척도로 7세션 수렴 완주), CLAUDE.md §27 변경이력.

### 발견 2 — "에이전트가 위키를 유지보수하는 패턴"의 원형 = Karpathy LLM 위키 (이 레포 §9가 이미 채택·운영 실증)

- **Karpathy LLM Wiki** (gist, 2026-04): 3계층(원천 raw는 불변 / 위키는 LLM 전담 / 스키마는 규약) + 3워크플로(**Ingest** 원천 추가 시 관련 페이지 연쇄 갱신 / **Query** 질의 응답 후 좋은 답을 페이지로 환원(file-back) / **Lint** 주기 점검: 모순·낡은 주장·고아 페이지·누락 교차참조 탐지).
  - 출처: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- **이 레포 실증(§9 print-kb 위키)이 여기에 이미 보강해 둔 것들** — 외부에는 없는 실전 확장:
  - **badge 4종**(✅결정/🟡권장/🔴미결정/⚪명세) — "사실의 확정 정도"를 블록마다 표기. 🟡을 사실로 쓰지 말라는 취급 규칙까지 명문.
  - **base 출처 신뢰도 3종**([검증]/[단일출처]/[추정]) — 보편 지식도 교차검증 등급을 단다.
  - **원자 블록 + 안정 @id + 관계 동사 6종**(uses/requires/excludes/priced-by/loaded-via/mapped-to) + 역링크 슬롯 — 갱신이 한 곳만 고치면 되는 구조(단일 사실 원칙·복붙 금지 HARD).
  - 레포 출처: `_workspace/print-kb/wiki/README.md` §1·§3·§4.
- **Generative Agents** (Park et al. 2023): 에이전트 기억 설계의 고전 — 낱개 기억(memory stream)에서 주기적으로 **상위 통찰을 합성(reflection)**해 다시 기억에 넣는 구조. "축 페이지/요약 페이지 = 낱개 사실들의 상위 합성"이라는 위키 운영과 동형.
  - 출처: https://arxiv.org/abs/2304.03442
- **Reflexion** (Shinn et al., NeurIPS 2023): 실패 경험을 말로 요약해 다음 시도의 컨텍스트로 넣는 "언어적 강화학습". 이 레포의 HANDOFF.md·auto-memory(MEMORY.md)·"교훈" 메모 파일들이 이미 이 패턴의 실전형이다.
  - 출처: https://arxiv.org/abs/2303.11366
- **A-MEM** (Xu et al. 2025): 새 기억이 들어올 때 에이전트가 기존 기억들과의 링크를 **자동 생성·재조직**(Zettelkasten식)하는 메모리 시스템. 링크 자동화의 최신형이지만, 재조직이 자동으로 일어나면 기존 참조가 흔들릴 수 있다.
  - 출처: https://arxiv.org/abs/2502.12110

### 발견 3 — 지식 노후화(staleness) 관리: "활동 기반"이 아니라 "원천 변경 이벤트 기반 + 선언된 만료 규칙"이 정석

- **FreshLLMs** (Vu et al. 2023): LLM의 지식은 훈련 시점에 고정되어 낡는다는 것을 대규모 벤치마크(FreshQA)로 실증 — 낡은 지식 질문에서 오답·환각 급증. 결론은 "모델 내부 지식을 믿지 말고 **외부의 최신 원천을 조회**하라". KB 맥락으로 옮기면: **답의 권위는 항상 문서/DB 원천에 있고, 원천의 신선도를 관리해야 한다**.
  - 출처: https://arxiv.org/abs/2310.03214
- **dbt source freshness** (데이터 업계 표준 도구): 원천 데이터마다 **"경고 기준/오류 기준"을 선언**(예: 12시간 지나면 warn, 24시간이면 error)하고 파이프라인이 자동 판정. "신선도는 느낌이 아니라 원천별로 선언된 숫자 규칙"이라는 산업 관행.
  - 출처: https://docs.getdbt.com/docs/deploy/source-freshness
- **Kubernetes lifecycle stale bot**: 이슈가 90일 활동 없으면 stale → 30일 더 지나면 rotten → 닫힘, `/remove-lifecycle stale`로 갱신. **활동(activity) 기반** 노후 판정의 대표 사례 — 단, 커뮤니티에서 "유효한데 조용한 이슈를 죽인다"는 불만이 반복 제기됨(지식 블록에 그대로 쓰면 위험하다는 반증).
  - 출처: https://kubernetes.io/docs/contribute/review/for-approvers/ · https://github.com/kubernetes/community/issues/6418
- **Google 문서화 관행**: 문서는 **코드 변경과 같은 변경단위(CL)에서 함께 갱신**하는 것이 원칙 — "죽은 문서는 잘못 안내하고 개발을 늦춘다". 즉 노후화 방지의 최선은 사후 탐지가 아니라 **변경 시점 동시 갱신**.
  - 출처: https://google.github.io/styleguide/docguide/best_practices.html
- **이 레포 실증 — 이미 이 정석을 자체 발명해 운영 중:**
  - **freshness 레지스트리**: `_workspace/print-kb/wiki/_curation/source-registry.md` — 원천마다 **FRESH / PARTIAL-STALE(어느 축이 낡았는지 축 단위 명시) / STALE(인용 금지 + 대체 소스 지목)** 3등급. 판정 권위는 별도 진단 산출물(round-14 `impact-diagnosis.md` I-1~I-11)로 고정. **"STALE/v03 인용 금지"는 §9 하네스 HARD 규칙.**
  - **권위 엑셀 버전 델타**: 신 버전 엑셀(260527→260610→260702)이 오면 전면 재분석이 아니라 **키 기반 셀 diff로 변경분만** 반영(260702 채택 = 33+32셀 diff로 완료). 출처: `_workspace/excel-to-db/_meta/best-practices-playbook.md` 6단계·CLAUDE.md §23 변경이력.
  - **round 재검증**: 라이브 DB가 계속 바뀌므로, 이전 라운드 산출을 다음 라운드가 재실측으로 재검증(예: §22 역공학 4월→6월 드리프트 적발 후 재역공학, §16 R7 freshness 게이트 신설 — 라이브 드리프트를 게이트가 적발).
  - **양면 표기**: 라이브가 오적재로 확정된 영역은 "라이브 현재값 ↔ 정답"을 나란히 표기(§9 레시피 7절 필수 슬롯) — 낡은/틀린 값을 지우지 않고 상태를 드러내는 방식.

### 발견 4 — 그래프 파생물의 갱신: 대규모에서는 증분(델타) 인덱싱, 소규모에서는 전면 재빌드가 더 단순·안전

- **Microsoft GraphRAG 1.0**: 기존 인덱스와 새 콘텐츠의 **차이(델타)를 계산해 병합**하는 update/append 명령 제공 — 대규모 코퍼스에서 재인덱싱 비용 때문에 필요해진 기능. 임계치를 넘으면 결국 전면 재계산으로 퇴화.
  - 출처: https://microsoft.github.io/graphrag/ · https://www.microsoft.com/en-us/research/blog/moving-to-graphrag-1-0-streamlining-ergonomics-for-developers-and-users/
- 후니 규모(상품 283개·t_* 34테이블·위키 수백 페이지)에서는 파생 그래프를 **결정론 스크립트로 매번 전부 다시 빌드**해도 초 단위다. 증분 병합 로직 자체가 새 결함원이 된다(레포 교훈: "일괄 merge 함정" — §17 CHANGELOG).

---

## ② 후니 적용 권고 (채택 / 기각 / 보류 + 이유)

후니 조건: 상품 283개, t_* 34테이블, **단일 운영자**, git 레포(파일 = 정본), 이미 §9 위키·freshness 레지스트리·결정론 diff 스크립트군 보유.

| # | 항목 | 판정 | 이유 |
|---|------|------|------|
| R4-1 | **외부 근거 기반 교정 루프** — 보강(수정)은 반드시 "결정론 측도(스크립트 diff·DB 실측·골든 재계산)가 낸 결함 목록"을 입력으로만 수행. AI의 "다시 읽어보니 이상함" 같은 자기 느낌 단독 수정 금지 | **채택 [HARD 승격 권고]** | Huang 2024(자기교정 역효과)+CRITIC(도구 검증 필수)+레포 생성≠검증 실증이 3중 수렴. 이미 사실상 운영 중 — 명문화만 하면 됨 |
| R4-2 | **루프 골격 = 감지→보강→재검증→기록 4박자, 트리거 5종으로 유형화** — ①권위 엑셀 신버전(셀 diff) ②라이브 DB 드리프트(스냅샷 diff) ③새 하네스 산출물 도착(Ingest) ④질의 실패/공백(Query gap) ⑤주기 Lint | **채택** | Karpathy 3워크플로(Ingest/Query/Lint)에 이 레포 고유 트리거 2종(권위 버전 델타·라이브 드리프트)을 더한 것. 전부 레포에서 개별 실증됨 — 묶어서 하나의 운영 루프로 선언하는 게 신규분 |
| R4-3 | **트리거마다 숫자 종료척도 선언** — 예: 엑셀 델타 반영 = "변경 셀 반영 누락 0", Lint = "STALE 인용 0·고아 페이지 0·모순 블록 0", 질의 공백 = "미답 CQ 큐 소진" | **채택 [HARD 승격 권고]** | 레포 최대 시행착오가 "종료척도 부재로 분석 무한 반복"(scoring-framework 메모·x2d 횡단 원칙 5). §27 배선 루프가 "결함 0"으로 실제 수렴 완주한 것이 실증 |
| R4-4 | **freshness 레지스트리 승계·확장** — §9 `source-registry.md`의 FRESH/PARTIAL-STALE(축)/STALE 3등급 + 판정 권위 문서 분리를 온톨로지 KB의 1급 산출물로 승계. STALE 인용 금지 HARD 유지 | **채택** | 이미 운영 실증된 자체 자산. 외부(dbt)도 같은 원리("원천별 선언 규칙"). 새로 발명할 것 없음 |
| R4-5 | **원천별 만료 규칙(freshness SLA)을 선언형으로 추가** — 원천 유형별로 "무엇이 오면 낡은 것으로 보나"를 표로 선언: 권위 엑셀=신 버전 파일 도착 이벤트, 라이브 DB 스냅샷=재실측 날짜 기준(예: 최종 스냅샷 N일 경과 시 PARTIAL-STALE 후보), 하네스 산출물=해당 하네스 CHANGELOG 갱신 이벤트 | **채택(경량으로)** | dbt source freshness의 원리를 문서 KB에 이식. 현행 레지스트리는 "진단이 있어야 등급이 바뀌는" 수동형 — 만료 규칙을 선언해 두면 감지가 기계적이 됨. 단일 운영자라 복잡한 자동화 불요, 표 1장+체크 스크립트면 충분 |
| R4-6 | **활동 기반 자동 노후 판정(Kubernetes stale bot식 "오래 안 건드리면 stale")** | **기각** | 지식 블록은 활동이 없어도 유효(판형 규칙은 1년 안 고쳐도 참). Kubernetes 커뮤니티 자체에서도 유효 항목 오폐기 불만이 실증됨. 노후 판정은 "시간 경과"가 아니라 "**원천 변경 이벤트**"로만(R4-5) |
| R4-7 | **staleness 전파(원천이 낡으면 파생 블록에 자동 표기)** — 블록마다 이미 출처 필드가 있으므로, "원천 X가 STALE로 바뀌면 X를 인용한 블록 목록을 뽑아 재검토 큐에 넣는" 결정론 스크립트 | **채택** | §9 원자 블록 규약(출처 필수)이 이미 의존 정보를 갖고 있음 — grep 수준으로 구현 가능. round-14 impact-diagnosis가 수동으로 한 일(원천 변경→문서별 stale 축 표기)의 스크립트화 |
| R4-8 | **Query→file-back(질의에 답한 뒤 좋은 답을 페이지로 환원)과 미답 질문 큐** — 답 못 한 자연어 질의 = 누락 감지 신호로 등록(CQ 레지스트리에 적립)하고 다음 보강 라운드의 입력으로 | **채택** | Karpathy Query 워크플로 원형 + §9 CQ 레지스트리(answers_cq 양방향)가 이미 그릇을 갖춤. 온톨로지 KB의 목적(자연어 질의→추천→가격)상 "질의 실패"가 가장 값진 누락 신호 |
| R4-9 | **Reflexion식 교훈 적립(실패 요약을 다음 시도의 컨텍스트로)** | **채택(현행 유지)** | HANDOFF.md·auto-memory·"교훈" 메모가 이미 이 패턴. 신규 설계 불요 — KB 하네스의 `_meta/`에 같은 규약 적용만 |
| R4-10 | **상위 통찰 합성(reflection) 페이지** — 낱개 블록들을 주기적으로 축/요약 페이지로 합성하되, 합성물에도 출처·badge 필수 | **채택(조건부)** | Generative Agents의 reflection과 §9 축 페이지가 동형. 단, 합성은 생성 행위이므로 재검증 레인(렌즈 5)을 반드시 통과 — 합성 단계가 환각 유입구라는 것이 자기교정 한계 연구의 경고 |
| R4-11 | **A-MEM식 링크 자동 재조직**(새 지식이 오면 AI가 기존 블록 링크를 자동으로 다시 짬) | **보류** | 후니는 안정 @id 불변 + 관계 동사 6종 명시 링크(§9 R-7·관계 그래프 원칙)가 이미 규약 — 자동 재조직은 이 불변성을 흔들 위험. 페이지 수천 장 규모가 되어 수동 링크가 병목이 될 때 재검토 |
| R4-12 | **GraphRAG식 증분(델타) 그래프 인덱싱** | **기각(현 규모)** | 파생 그래프는 결정론 스크립트 전면 재빌드가 더 단순·안전(초 단위 규모). 증분 병합 로직 자체가 결함원(§17 "일괄 merge 함정" 실증). 하네스 결정 "파일=정본·그래프=파생 빌드"와도 정합 — 파생물은 언제든 버리고 다시 만들 수 있어야 함 |
| R4-13 | **Self-Refine식 무제한 반복** | **변형 채택** | 반복 자체는 유효(§27 배선 루프 7세션 수렴이 실증)하나, ①피드백은 외부 측도만(R4-1) ②반복 상한+종료척도(R4-3) ③매 회전마다 검증자 분리 — 3조건을 달아야 함. 조건 없는 Self-Refine 원형은 Huang 2024가 반박 |

### 권고 종합 — 후니 운영 루프 한 장 그림 (설계자 입력용)

```
[트리거 5종]                          [감지 = 결정론 우선]
① 권위 엑셀 신버전     ──→ 셀 diff 스크립트(변경 셀 목록)
② 라이브 DB 드리프트   ──→ 스냅샷 diff(wiring_scan류·grid-diff류)
③ 새 하네스 산출물     ──→ Ingest(원천 등록+freshness 등급)
④ 질의 실패/공백       ──→ 미답 CQ 큐 적립
⑤ 주기 Lint           ──→ STALE 인용·고아·모순·역링크 누락 스캔
        │
        ▼
[보강 = 생성 레인]  결함 목록만 입력으로 블록 추가/수정 (출처+badge 필수·숫자 전사 금지)
        │
        ▼
[재검증 = 별도 레인]  생성≠검증 — okb-adversarial-verifier(렌즈 5 담당)·종료척도 미달 시 루프
        │
        ▼
[기록]  log.md append + freshness 레지스트리 갱신 + CQ 레지스트리 갱신
```

---

## ③ 설계자(okb-ontology-architect)에게 넘길 결정 항목

1. **freshness 레지스트리의 위치·소유** — §9 `source-registry.md`를 온톨로지 KB가 승계(복사)할지, 참조(단일본 공유)할지. 권고: 단일본 공유 + 온톨로지 KB 전용 원천만 추가(복사 = 이중 관리 = 그 자체가 staleness 원인).
2. **원천 유형별 만료 규칙 표(R4-5)의 초기값** — 권위 엑셀/라이브 스냅샷/하네스 산출물/외부 리서치 4유형에 대해 "무슨 이벤트가 오면 어느 등급으로 떨어지는가"를 설계서에 표로 확정.
3. **staleness 전파 스크립트(R4-7)의 계약** — 블록 출처 필드의 표기 형식을 기계 파싱 가능하게 고정해야 전파가 grep으로 됨(현행 §9 컨벤션 `출처: <file:§>` 유지 여부 + 원천 ID(src_id) 병기 여부 결정).
4. **트리거별 종료척도(R4-3)의 수치 확정** — 특히 Lint의 "모순 블록 0"을 무엇으로 셀지(같은 @id 이중 등재? 같은 사실 상충 값? 정의 필요).
5. **루프 실행 방식** — 단일 운영자 전제에서 주기 Lint를 ⓐ사람이 세션 시작 시 수동 트리거 ⓑ하네스 재실행 시 Phase 0으로 내장 ⓒ스케줄 자동화 중 무엇으로 할지. 권고: ⓑ(하네스 실행 = Lint 선행) — 자동화(ⓒ)는 승인 게이트(실 COMMIT 인간 승인 원칙)와 충돌 여지.
6. **보강 반복 상한** — §25가 "최대 3회 루프"를 실증했음. 온톨로지 KB 루프의 회전 상한과 상한 도달 시 처리(BLOCKED 큐로 격리·인간 에스컬레이션)를 설계서에 명시.
7. **합성(reflection) 페이지의 재검증 강도(R4-10)** — 낱개 블록과 같은 게이트를 통과시킬지, 합성물 전용 게이트(원천 블록과의 정합 재대조)를 둘지 — 렌즈 5(적대적 검증) 설계와 접합 필요.

---

## ④ 미확인 / 추가 조사 필요

- **"LLM 에이전트가 장기간(수개월) 위키를 유지보수했을 때의 품질 추이"에 대한 학술 실증은 찾지 못함** — Karpathy 위키는 패턴 제안(2026-04)이고 파생 글들은 튜토리얼 수준. 장기 운영 데이터는 사실상 이 레포의 §9 운영 이력(2026-06-05~)이 가장 실증에 가까움. 외부 벤치마크 부재를 전제로 설계할 것.
- **A-MEM의 실제 안정성**(자동 링크 재조직이 기존 참조를 얼마나 깨뜨리는지) — 논문·리포는 성능 위주, 참조 안정성 데이터 미확인. R4-11 보류 판정의 근거이기도 함.
- **미답 CQ 큐의 우선순위 산정 방법**(어느 공백부터 보강할지) — 질의 빈도 기반 랭킹이 정석일 것이나 단일 운영자 환경의 질의량으로 유의미한지 미확인. 초기에는 수동 우선순위로 시작 권고.
- **Kubernetes bot 방식의 변형 가능성** — "활동 기반"은 기각했으나, "원천 이벤트 후 N일 내 재검토 미완이면 경고 승격" 같은 하이브리드는 검토 여지. 운영 몇 라운드 후 재평가.

## Sources (외부)

- Self-Refine: https://arxiv.org/abs/2303.17651
- LLMs Cannot Self-Correct Reasoning Yet (ICLR 2024): https://arxiv.org/abs/2310.01798
- CRITIC (ICLR 2024): https://arxiv.org/abs/2305.11738
- Reflexion (NeurIPS 2023): https://arxiv.org/abs/2303.11366
- Generative Agents: https://arxiv.org/abs/2304.03442
- A-MEM: https://arxiv.org/abs/2502.12110
- FreshLLMs: https://arxiv.org/abs/2310.03214
- Karpathy LLM Wiki gist: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Microsoft GraphRAG(증분 인덱싱): https://microsoft.github.io/graphrag/ · https://www.microsoft.com/en-us/research/blog/moving-to-graphrag-1-0-streamlining-ergonomics-for-developers-and-users/
- dbt source freshness: https://docs.getdbt.com/docs/deploy/source-freshness
- Kubernetes lifecycle(stale bot): https://kubernetes.io/docs/contribute/review/for-approvers/ · https://github.com/kubernetes/community/issues/6418
- Google 문서화 관행: https://google.github.io/styleguide/docguide/best_practices.html

## Sources (레포 내부 — 1차 증거)

- `_workspace/print-kb/wiki/README.md` (badge·원자 블록·안정 @id·관계 동사·Ingest/Query/Lint·양면 표기)
- `_workspace/print-kb/wiki/_curation/source-registry.md` (FRESH/PARTIAL-STALE/STALE 레지스트리·round-14 진단 권위)
- `_workspace/excel-to-db/_meta/best-practices-playbook.md` (버전 델타·종료척도·생성≠검증·결정론 우선)
- CLAUDE.md §9(위키)·§16(R7 freshness 게이트)·§22(재역공학 드리프트)·§23(권위 260702 델타 채택)·§26·§27(wiring_scan 수렴 루프)
