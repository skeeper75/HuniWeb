# 가격검증 파이프라인 전수 확장 — 외부 베스트프랙티스 리서치

**목적:** 한 클래스(엽서류)에서 완주한 게이트형 검증(데이터정합→사슬→재계산→경쟁사벤치마크→정립→재검증)을 15 가격공식 클래스 + 184 미구성 상품 전체로 **중단없이 전수 확장**하는 체계를, 외부 베스트프랙티스로 검증·보강한다.

**범위 한정:** 일반 방법론 권고 + 후니 맥락(가격공식 클래스·webadmin Phase11 엔진 미구현·DB 미적재 원칙·경량 우선) 적용 권고. 후니 특정 데이터는 추측하지 않음.

---

## Q1. 대량 회귀/골든 케이스 검증

### 베스트프랙티스
- **Characterization = Golden Master = Approval = (Snapshot) 은 같은 기법의 다른 이름.** "내가 원하는 동작"이 아니라 "시스템의 실제 동작"을 기록해 의도치 않은 회귀로부터 보호하는 것이 목적(Michael Feathers, understandlegacycode). 후니처럼 **권위 known값(가격표 엑셀)** 이 이미 존재하는 경우는 순수 characterization(관찰값 고정)보다 **권위값 대조형 approval test**가 맞다 — 즉 "엔진이 뱉은 값을 그대로 굳히는" 것이 아니라 "엔진 산출 vs 권위 엑셀값"을 비교.
- **"Approval" 명명이 권장되는 이유:** 캡처된 값이 사람이 검토·승인한 것이며, 의도적으로 진화시킬 수 있음을 명시하기 때문. **"Golden Master"는 불변(immutable) 뉘앙스라 진화하는 데이터에는 부적절.** 후니 가격표는 버전이 바뀌므로(260527→260610) golden을 불변으로 다루면 안 되고 "버전 태깅된 승인값"으로 관리해야 한다.
- **Printer(직렬화 포맷) 설계가 핵심:** 출력을 사람이 읽기 쉬운 형태(영수증 레이아웃)로 포맷하고, flaky 데이터(timestamp 등)는 제거. snapshot test의 흔한 실패 모드 = 사람이 diff를 안 보고 무지성 승인(blind approve) → Printer를 의미있게 만들어 변경이 눈에 띄게.
- **Table-driven cases:** 입력/기대출력을 테이블·DB에서 조회. 단점은 "가진 예시로만 입력이 제한됨" — 그래서 보완으로 **property-based testing(불변식)** 을 병행. IEEE Software 연구: 예시기반+속성기반 병행 팀이 엣지/경계 결함 탐지율 35~50% 높음.
- **Property-based = 부분 오라클(partial oracle):** 구체적 기대값 대신 "항상 성립해야 하는 관계/불변식"을 검증. 금융 도메인 불변식 예: 가격 비음수, OHLC 내부 정합, 타임스탬프 단조성, 보정가 연속성. **가격은 known값이 없는 조합이 압도적이므로(수량×옵션 조합 폭발), known값 골든으로는 전수 불가 → 불변식으로 빈 공간을 메운다.**

### 후니 적용 권고
1. **2층 골든 자산.** (a) **앵커 골든(approval)** = 가격표 엑셀에서 직접 나오는 known 셀값(예: 특정 사이즈×수량의 정가). 클래스별 대표 조합 소수를 권위값과 1:1 고정. (b) **불변식(property)** = known값 없는 조합을 덮는 안전망. 후니 도메인 불변식 후보(추측 아님, 일반 가격엔진 성질): 가격>0(0은 항상 우리측 결함 신호 — 메모리 `huni-widget-red-price-never-zero` 정합), 수량↑일 때 단가 비증가(구간할인 단조), 동일옵션 더 큰 사이즈 가격≥작은 사이즈, 옵션 추가 시 가격 비감소, off-grid는 한 단계 큰 격자값과 동일(메모리 `dbmap-price-formula-types-authority`의 ceiling 규칙).
2. **버전 태깅.** 골든값에 가격표 버전(260610 등)을 메타로 붙여 "불변 golden" 함정 회피. 버전 변경 시 골든 재승인이 추적 가능한 변경분이 되도록(round-10 변경추적 트랙과 결합).
3. **Printer = 가격사슬 영수증.** 재계산 결과를 "공식→구성요소→단가행→할인→최종가" 단계별 한국어 영수증으로 직렬화(실무진 가독). 메모리 `dbmap-digitalprint`의 "가격검증=공식사슬 전체" 교훈과 일치. 무지성 승인 방지 = 단계별 수치가 보이게.
4. **[HARD 경계 — 보정 하드코딩 금지 재확인]** 골든은 **권위 엑셀값**이어야지, verifier가 파이썬에서 만든 "corrected" 값을 골든으로 굳히면 안 된다. CLAUDE.md §7 round-18+에서 적발된 "recompute.py가 옵션→구성요소 매핑을 하드코딩해 라이브에 없는 매핑을 계산기가 메워 거짓 GO" 가 정확히 이 안티패턴(snapshot blind-approve). 골든의 출처는 항상 권위 엑셀, corrected는 진단용.

---

## Q2. 배치 검증 파이프라인 + 게이트(부분통과·격리)

### 베스트프랙티스
- **두 가지 데이터품질 패턴 — Fail-Fast vs Quarantine (Spark 엔지니어링 정설).**
  - *Fail-Fast*: 기대치가 잘 정의되고 리스크 허용도 낮은 성숙 파이프라인·규제 영역에 적합. 하나라도 틀리면 전체 정지.
  - *Quarantine*: 다양·불완전 소스를 다룰 때, "부분 데이터가 무데이터보다 낫다"일 때 적합. 통과/실패 두 스트림으로 분리하고, 실패 레코드는 **격리존(quarantine table)** 으로 — 어느 체크가, 언제, 왜 실패했는지 **구조화된 에러 설명·심각도·타임스탬프** 메타와 함께 보관. 운영 중단 없이 검토·정제·추세 추적.
- **하이브리드 임계 모델(권장):** 평소엔 격리하며 진행하되, **전체 통과율이 임계(예: 80%) 아래로 떨어지면 Fail-Fast로 정지.** "일상 유연성 + 대량 불량 데이터의 침묵 적재 방지"라는 양쪽 장점. (Towards Data Engineering)
- **품질 게이트는 처리 단계 사이에서 작동:** 스키마 검증 → 비즈니스 규칙 → 유일성 검사 순서로, 실패 레코드는 격리 테이블에 로그. **회복력 있는 구조 = 획득/버퍼/적재 분리** → 안전 재시도, 독립 확장, 전체 정지 없는 실패 격리. (Airbyte, Unstructured)
- **CPQ 도메인 표준 게이트 순서 = 구성(configuration) 무결성 → 가격(pricing) 정확성.** CPQ 테스트는 "가격규칙·제품구성·승인워크플로가 실거래 시나리오에서 올바로 동작하는가"의 구조화 검증이며, **통합 지점마다 검증 규칙을 두어 나쁜 데이터의 침묵 전파(silent propagation)를 막는다 — 누락 필드·잘못된 가격·비호환 조합을 다운스트림 오염 전에 플래그.** 실데모 아닌 실데이터로 테스트. (Everstage, BrowserStack)

### 후니 적용 권고
1. **게이트 순서의 외부 근거 확보.** 후니가 이미 채택한 `G-DATA(데이터정합) → G-CHAIN(사슬) → G-CALC(계산) → 벤치마크`는 CPQ 표준(구성무결성 먼저, 가격 나중)과 정확히 일치. 특히 "통합 지점마다 검증으로 침묵 전파 차단" = 후니가 막으려던 D-2(라이브에 매핑 없는데 계산기가 메워 거짓 GO). **G-DATA를 하드게이트로 두는 것이 외부 정설로 정당화됨.**
2. **클래스를 레코드처럼 흘려라 — Quarantine 패턴 채택.** 15 클래스 × 상품을 동일 게이트 시퀀스에 통과시키되, NO-GO 클래스/상품은 **격리 보드(quarantine table)** 로 빼고 나머지는 계속 진행. 격리 항목마다: 어느 게이트(G-DATA/G-CHAIN/G-CALC/B)에서, 무엇이(결함 유형), 왜, 권위 출처는 무엇인지 + 라우팅(round-5/13/ddl-proposer/인간승인) 메타 기록. → 후니의 기존 "갭 보드" 관행과 동형.
3. **하이브리드 임계로 "거짓 GO" 방지.** 클래스 단위 통과율이 임계 아래면 그 클래스는 Fail-Fast(전수 정지 후 정립). 단, **전체 파이프라인은 멈추지 않음** — 한 클래스가 막혀도 다른 클래스는 흐른다.
4. **184 미구성 상품 = 정상적 격리 대상.** "가격 미구성"은 검증 실패가 아니라 **입력 부재**다. 이들은 G-DATA 진입 전 단계에서 "BLOCKED: 가격 미구성(입력 부재)"로 격리 — NO-GO와 구분(메모리 `dbmap-price-import` 의 "BLOCKED=NULL 강제 금지" 교훈과 정합). 격리 사유 유형을 분리해야 진척률이 왜곡되지 않음.
5. **과설계 경계.** Spark/Airbyte 같은 무거운 파이프라인 엔진 도입 불필요. 격리 보드 = 마크다운/CSV 테이블 1개, 게이트 = 스크립트 + 판정표면 충분. 후니 DB 미적재 원칙상 "스트림 분리"는 물리 적재가 아니라 산출물(통과 매니페스트 vs 격리 보드)의 논리 분리로 구현.

---

## Q3. 결함 카탈로그/체크리스트 재사용 (known-defect 스캐닝)

### 베스트프랙티스
- **격리 레코드의 메타는 추세 추적용:** 어느 체크가 왜 실패했는지 구조화 보관 → "반복되는 이슈를 발견하고 추세 추적." 즉 한 대상의 실패가 다음 대상의 체크 항목이 된다(Towards Data Engineering / dlthub). 이것이 결함 카탈로그의 핵심 메커니즘.
- **CPQ: 통합 지점 검증 규칙을 명시적으로 둔다** — "누락 필드·잘못된 가격·비호환 조합"은 도메인에서 반복되는 결함 클래스이므로 규칙으로 고정(Everstage).
- **Approval test = 결함을 재현 가능한 케이스로 박제:** 한 번 발견한 회귀를 승인 케이스로 추가하면 이후 영구 가드.

### 후니 적용 권고
1. **결함 패턴 카탈로그를 1급 산출물로.** 엽서 클래스 완주에서 나온 결함을 **재사용 가능한 스캐너 체크리스트**로 정규화. 후니에서 이미 관찰된 known-defect 후보(메모리 근거):
   - **옵션→구성요소 멤버십 부재**(D-2: 라이브에 매핑 없는데 계산기가 메움) — `dbmap-price-chain-dwire-per-product-formula`
   - **prc_typ 메타데이터 오적재**(단가형/합가형 혼동) — `dbmap-price-import-round16`
   - **가격사슬 단절**(단가행 존재 ≠ 공식에 배선됨) — round-16/17 "broken" 진단
   - **판형 미해석/과대합산**(출력판형≠재단≠작업, 면적-좌표 오모델) — `dbmap-output-plate-mapping`, `dbmap-silsa-price-via-poster-sign`
   - **단위변환 부재**(면적 ceiling/off-grid 미적용)
   - **가격 미구성인데 0/거짓값 반환**(0은 항상 우리측 결함)
2. **체크리스트 = 클래스 진입 시 자동 1차 스캔.** 새 클래스를 G-DATA에 넣기 전, 위 카탈로그를 일괄 스캔해 "이미 아는 결함 유형"을 먼저 솎아낸다. 신규 클래스에서 새 결함 발견 → 카탈로그에 append(누적 진화). 격리 메타의 "결함 유형" 필드가 카탈로그 ID를 가리키게.
3. **각 카탈로그 항목 스키마:** `{결함ID · 증상 · 탐지 쿼리/스크립트 · 권위 대조 기준 · 근본원인 · 라우팅 · 최초발견 클래스}`. round-13/16/17 산출이 이미 이 형태의 진단을 가지고 있으므로 신규 유도 없이 추출·통합(중복 0).
4. **과설계 경계:** 별도 결함 추적 도구 불필요. 카탈로그 1개 마크다운 + 각 항목당 grep/SQL 스니펫이면 충분.

---

## Q4. 사람 승인 게이트 분리 (human-in-the-loop)

### 베스트프랙티스
- **표준 패턴 = 상태관리형 중단(state-managed interruption):** 에이전트를 멈추고 전체 상태를 내구 저장소에 직렬화 → 호출자에 제어 반환 → 승인 신호 도착 시 정확한 체크포인트에서 재개. **"실행이 메모리 콜트리가 아니라 DB의 한 행(row)이 된다."** (Just Understanding Data)
- **결정과 전달 분리(decouple decision from delivery):** "사람을 부를지"와 "어떻게 전달할지(Slack/이메일/대시보드)"를 분리.
- **비동기 — 막지 않는다(parking):** 에이전트는 블록하지 않고 액션을 주차(park)한 뒤 다른 작업을 계속 → 승인이 병목이 안 됨.
- **티어 에스컬레이션:** 신뢰도 임계 보정해 정말 불확실한 것만 리뷰로. tier-1(중간 리스크)은 빠른 SLA, tier-3(고위험)는 전문가.
- **propose-then-commit + 멱등성:** 승인 기록 전까지 실 액션 차단. 멱등키 없으면 한 번 승인된 액션이 두 번 실행될 수 있음.

### 후니 적용 권고
1. **검증 흐름과 승인 큐의 물리적 분리.** 후니의 "실 COMMIT·DDL·의미결정은 인간 승인" 원칙이 정확히 이 패턴. **승인 대기 항목을 검증 파이프라인에서 빼서 별도 "인간 승인 큐"(파킹)** 로 보내라 — 검증은 다음 클래스로 계속 진행. 한 항목의 승인 대기가 전체를 멈추면 안 됨(질문 핵심).
2. **승인 항목 = 구조화된 행(row).** 각 승인 대기를 `{대상 클래스/상품 · 제안 내용(어느 t_*에 무엇을) · 트레이드오프 · 근거 출처 · 라우팅 · 멱등키}`로. 후니는 DB 미적재라 "내구 저장소" = 승인 큐 산출물(보드/매니페스트). 이게 곧 dbm-price-arbiter의 "정립 방안" 출력과 동형.
3. **propose-then-commit + 멱등.** 후니가 이미 멱등 UPSERT·롤백전용 DRY-RUN으로 실증해 온 패턴. 승인 큐 항목에 멱등키(이름기반 — 메모리 `dbmap-code-identifier-strategy`)를 붙여 "재-DRY-RUN delta 0"으로 이중적용 방지.
4. **티어 분리.** 자동 통과(검증 GO·기계적) / tier-1(라우팅 명확한 적재 제안) / tier-3(의미 결정 — 예: D-2 매핑 권위가 CPQ냐 차원컬럼이냐, C-2 컨펌). tier-3만 사람 깊은 개입.
5. **결정과 전달 분리:** 승인 요청 전달 채널(AskUserQuestion)과 승인 큐(산출물)를 분리 — 큐는 쌓이고, 사람은 배치로 처리. 검증은 그 사이 멈추지 않음.

---

## Q5. 커버리지 추적 (RTM / traceability)

### 베스트프랙티스
- **RTM = 각 요건을 검증 케이스·설계요소·검증단계에 매핑하는 구조화 문서.** 전수 진척과 공백을 가시화. (testomat, TestRail, Jama)
- **양방향 추적:**
  - *Forward(전방)*: 연결된 테스트가 없는 요건을 잡아냄 = **미검증 공백**.
  - *Backward(후방)*: 어떤 요건에도 안 닿는 테스트/설계요소를 잡아냄 = **스코프 크립**.
- **프로젝트 시작 시 만들고 주기적으로 리뷰** — 데드라인 전에 공백을 잡기 위해. 역할 명확화(테스터/개발/분석가 참여).

### 후니 적용 권고
1. **RTM = 요건 × 게이트 × 클래스 매트릭스.** 행=검증 요건(데이터정합·사슬완전·재계산정확·벤치마크 합리성·정립), 열=15 클래스(+184 미구성). 셀=상태(GO/NO-GO/격리/미검증/N-A). **빈칸 = 미검증 = 전방 공백** — 후니 CLAUDE.md §7의 "재검증 폐루프+RTM(빈칸=미검증)" 이 정확히 forward traceability.
2. **후방 추적도 둬라.** 어떤 검증 케이스/골든값이 어느 요건·권위 엑셀 셀에도 안 닿으면 = corrected 하드코딩 같은 스코프 크립 신호. (Q1 [HARD] 경계와 연결 — backward trace가 "골든 출처가 권위 엑셀인가"를 자동 점검.)
3. **격리 보드 ↔ RTM 동기화.** 격리된 항목은 RTM에서 NO-GO/격리 셀로 표시되고, 라우팅·승인큐 항목과 ID로 연결. 한 판에서 "전수 중 어디까지·무엇이 막혔나·누가 처리하나"가 보임.
4. **과설계 경계:** RTM은 마크다운 매트릭스 1장 + 셀 상태 범례. 전용 RTM 도구(Jama 등) 불필요. 클래스 추가 시 열 1개 추가로 확장.

---

## 종합 — 후니 게이트형 파이프라인 보강 요약

| 질문 | 핵심 권고 | 외부 정설 근거 | 후니 기존 정합 |
|------|----------|---------------|----------------|
| Q1 골든 | 앵커 골든(권위 엑셀값·approval) + 불변식(property) 2층. 버전 태깅. 사슬 영수증 Printer. **corrected는 골든 금지** | approval test, property-based partial oracle, golden=불변 함정 | round-18+ [HARD] 보정 하드코딩 금지 |
| Q2 파이프라인 | Quarantine 격리 + 하이브리드 임계 Fail-Fast. CPQ 표준 게이트(구성무결성→가격) | fail-fast vs quarantine, CPQ 침묵전파 차단 | G-DATA→G-CHAIN→G-CALC, 갭보드 |
| Q3 결함카탈로그 | 결함 패턴을 재사용 스캐너로 박제·누적. 클래스 진입 시 1차 자동 스캔 | 격리 메타 추세추적, approval 회귀 박제 | round-13/16/17 진단 통합 |
| Q4 승인분리 | 승인 큐 파킹(검증은 계속). propose-then-commit + 멱등키. 티어 분리 | state-managed interruption, decouple decision/delivery | 멱등 UPSERT·DRY-RUN·인간승인 |
| Q5 RTM | 요건×게이트×클래스 매트릭스. 양방향 추적(빈칸=미검증, 고아=스코프크립) | forward/backward traceability | round-18+ RTM 폐루프 |

**한 줄 결론:** 후니의 현 게이트 순서·갭보드·인간승인·멱등·RTM 관행은 외부 베스트프랙티스(CPQ 테스트 표준 + 데이터품질 quarantine 패턴 + approval/property 테스트 + HITL state-interruption)와 이미 강하게 정합한다. 전수 확장에 필요한 **신규 도구는 없고**, 4개 경량 산출물 — ① 2층 골든 자산(앵커값+불변식) ② 격리 보드(quarantine, 하이브리드 임계) ③ 결함 패턴 카탈로그(재사용 스캐너) ④ 요건×클래스 RTM — 을 추가하면 "중단없는 전수 검증" 체계가 완성된다. 특히 [HARD] 경계: 골든·통과 판정의 출처는 항상 권위 엑셀이어야 하며, verifier의 corrected 값을 골든/GO 근거로 삼는 것은 외부 정설(snapshot blind-approve 안티패턴)로도 금지된다.

---

## Sources

- [Characterization test — Wikipedia](https://en.wikipedia.org/wiki/Characterization_test)
- [Regression vs Characterization vs Approval Tests — Understand Legacy Code](https://understandlegacycode.com/blog/characterization-tests-or-approval-tests/)
- [Golden Master Testing: Refactor Complicated Views — SitePoint](https://www.sitepoint.com/golden-master-testing-refactor-complicated-views/)
- [Property-Based Testing and Test Oracles — SWEN90006 (Univ. of Melbourne)](https://swen90006.github.io/Property-based-testing.html)
- [Property-Based Testing Meets Financial Data — susanpotter.net](https://www.susanpotter.net/quant/property-based-testing-statistical-validation/)
- [Fail Fast or Quarantine? Two Data Quality Patterns — Towards Data Engineering (Medium)](https://medium.com/towards-data-engineering/fail-fast-or-quarantine-two-data-quality-patterns-every-spark-engineer-should-know-111598f31ada)
- [Data Pipeline Dependencies & Retries — Airbyte](https://airbyte.com/data-engineering-resources/how-to-manage-dependencies-and-retries-in-data-pipelines)
- [CPQ Testing: How to Protect Revenue and Quote Accuracy — Everstage](https://www.everstage.com/cpq/cpq-testing)
- [Salesforce CPQ Testing: Approaches, Types, Challenges — BrowserStack](https://www.browserstack.com/guide/salesforce-cpq-testing)
- [Human-in-the-Loop Patterns: Approval, Input, Escalation — Just Understanding Data](https://understandingdata.com/posts/human-in-the-loop-patterns/)
- [Human-in-the-Loop Approval Gates for AI Agents — StackAI](https://www.stackai.com/insights/human-in-the-loop-ai-agents-how-to-design-approval-workflows-for-safe-and-scalable-automation)
- [The Ultimate Guide to RTM (Requirements Traceability Matrix) — testomat.io](https://testomat.io/blog/the-ultimate-guide-to-rtm-requirements-traceability-matrix/)
- [Requirements Traceability Matrix: A How-To Guide — TestRail](https://www.testrail.com/blog/requirements-traceability-matrix/)
- [Traceability Matrix Guide — Jama Software](https://www.jamasoftware.com/requirements-management-guide/requirements-traceability/traceability-matrix/)
