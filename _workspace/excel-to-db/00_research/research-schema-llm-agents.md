# 리서치: 스키마 설계 방법론 + LLM 에이전트 기반 데이터 엔지니어링

> 목적: 업무용 엑셀(상품마스터·다차원 가격표)을 **DB 스키마 + 적재 코드**로 바꾸는 LLM 에이전트 하네스의
> 설계 규칙을 근거로 뒷받침한다. 두 영역(스키마 설계 / LLM 데이터 엔지니어링)을 각각 조사해
> "이 하네스에서는 무엇을 하라"는 규칙으로 번역했다.
> 작성일: 2026-07-02 · 출처는 모두 실재 URL(확인 못 한 것은 `미확인` 표시)

---

## 핵심 요약 (5줄)

1. 스키마는 **개념→논리→물리** 3단계로 내려가되, 참조·가격 데이터는 트랜잭션용 3정규화(3NF)와 조회용 차원모델(스타 스키마)을 **한 DB 안에서 섞어** 쓴다(내부는 정규화, 가격 조회는 룩업 격자).
2. 다차원 가격표는 **EAV(엔티티-속성-값) 금지** — 대신 차원을 명시 컬럼으로 둔 룩업 테이블 + "구간(band) 시작·끝·단가" 3컬럼 패턴으로 모델링한다(수량구간=tiered/volume/stairstep 구분이 핵심).
3. CPQ(옵션 구성 상품)는 상용 표준(Salesforce CPQ)이 **번들-옵션-피처(min/max)-제약(constraint)-가격규칙** 5요소로 이미 검증한 모델이 있으니 그대로 흡수한다.
4. LLM은 **숫자에서 반드시 틀린다**(자릿수·연쇄계산 붕괴). 그래서 에이전트가 셀을 직접 읽어 계산하면 안 되고, **결정론적 스크립트(pandas/SQL)를 생성·실행**하게 해서 숫자는 코드가 다루고 LLM은 로직만 맡긴다(토큰도 98% 절감).
5. **생성자≠검증자 분리 + 교차검증**이 데이터 정확성의 핵심 — 같은 모델의 자기검토는 실패하고, 다른 모델/독립 실측이 20%가량 더 잡아낸다.

---

## AREA 1 발견 — DB 스키마 설계 방법론

### A1-1. 개념→논리→물리 3단계 설계 워크플로

- **기법:** 데이터 모델링은 추상도가 다른 3단계다. **개념모델**=업무 관점 엔티티·관계(무슨 데이터가 필요한가, 저장방법 무관)→**논리모델**=속성·타입·구조 추가(컬럼 명시)→**물리모델**=특정 DBMS에 타입·길이·nullable·인덱스로 구현. 각 단계는 청중이 다르다(업무담당→아키텍트→DBA/개발자).
- **출처:** [1keydata — Data Modeling Levels](https://www.1keydata.com/datawarehousing/data-modeling-levels.html) · [Couchbase — Conceptual/Logical/Physical](https://www.couchbase.com/blog/conceptual-physical-logical-data-models/)
- **이 하네스 규칙으로 번역:** 엑셀→DB 변환을 **3패스**로 강제한다. ① 개념 패스=엑셀 시트가 무슨 상품/무슨 가격축을 뜻하는지 사람이 읽는 표(엔티티·차원 식별). ② 논리 패스=컬럼↔차원↔단위 매핑(타입·코드값 확정). ③ 물리 패스=실제 `t_*` DDL/INSERT. 중간 산출물을 남겨 검증 지점을 만든다. **적용도: High** (이 하네스가 이미 "엑셀 분석→매핑 설계→적재본"으로 이 구조를 쓰고 있음 — 명시적 3단계 게이트로 격상 권고).

### A1-2. 3NF(정규화) vs 스타 스키마(차원모델) — 언제 무엇을

- **기법:** 3NF는 OLTP(주문·수정 1건이 1테이블만 건드림)에 강하지만 분석 쿼리는 15+ 조인으로 느려진다. 스타 스키마(팩트=측정값+FK / 디멘전=속성)는 조회가 단순·빠르다. **현실 정답=둘 다** — 애플리케이션/적재 계층은 3NF로 정합성 유지, 조회/가격 계층은 차원(룩업) 구조로 단순화. 컬럼형 창고는 넓은 테이블 스캔에 최적.
- **출처:** [CloudQuery — 3NF vs Star Schema](https://www.cloudquery.io/blog/explainer-3nf_vs_star-schema) · [Matillion — 3NF vs Dimensional Modeling](https://www.matillion.com/blog/3nf-vs-dimensional-modeling) · [datadef — Dimensional Modeling Guide](https://datadef.io/guides/en/dimensional-modeling)
- **이 하네스 규칙으로 번역:** 기초코드·상품·옵션 같은 **참조 데이터는 정규화**(자재/사이즈/공정 코드 테이블 분리, 중복 금지)하되, **가격 조회는 차원 룩업 격자**로 둔다(가격을 계산식 하드코딩이 아니라 `(사이즈, 자재, 수량구간)→단가` 조회로). 가격은 "차원+셀"이 곧 팩트, 나머지는 디멘전이라는 렌즈로 본다. **적용도: High**.

### A1-3. 다차원 가격표 모델링 — 룩업 vs 공식, 수량구간(tier/volume) 패턴

- **기법(수량구간):** 수량 기반 가격은 **3종**으로 갈린다 — **tiered/graduated**(각 구간의 단위가 그 구간 요율로 누적 계산), **volume**(총량이 임계 넘으면 전 단위가 새 요율로 하락), **stairstep**(구간에 걸리면 정확한 수량과 무관하게 고정가). 셋을 혼동하면 가격이 통째로 틀린다. 스키마는 상품ID + "하한·상한·단가"를 가진 가격행 집합으로 표현.
- **출처:** [Recurly — Tiered/Volume/Stairstep Pricing](https://docs.recurly.com/recurly-subscriptions/docs/-tiered-stairstep-and-volume-pricing) · [ProAbono — Tiered vs Volume](https://docs.proabono.com/documentation/whats-the-difference-between-tiered-pricing-and-volume-pricing/)
- **기법(EAV 안티패턴):** 가격/속성을 "엔티티·속성·값" 3컬럼 한 테이블(long-skinny)에 몰아넣는 EAV는 **제약(CHECK/FK)을 걸 수 없고, 타입 안전이 사라지고, 오타가 새 속성이 되고, 조회마다 조인 폭발**한다. RDB 엔진이 이 모델용이 아니라서 모든 지식이 애플리케이션으로 새어나간다. 의료 기록처럼 속성이 수천 개로 희소할 때만 예외.
- **출처:** [Cybertec — EAV in PostgreSQL, don't do it](https://www.cybertec-postgresql.com/en/entity-attribute-value-eav-design-in-postgresql-dont-do-it/) · [Wikipedia — EAV model](https://en.wikipedia.org/wiki/Entity%E2%80%93attribute%E2%80%93value_model)
- **이 하네스 규칙으로 번역:** ① 가격표를 **wide(피벗된 격자)로 읽되 long(unpivot)로 적재** — 엑셀의 "가로=사이즈 / 세로=수량" 매트릭스를 `(prd, siz, qty_band)→price` 행으로 펼친다(이 하네스가 이미 하는 "매트릭스→long CSV"). ② **차원은 EAV로 뭉치지 말고 명시 컬럼**으로 — 사이즈·자재·수량구간을 값-보따리(JSON/EAV)가 아니라 각각 코드 컬럼으로 둬야 제약·조회가 산다. ③ 각 가격축이 tiered인지 volume인지 stairstep인지 **명시 태깅**(오분류=대량 과/저청구). ④ "공식으로 표현 가능 vs 룩업 필요"를 판정 — 공식 결과가 시장가의 2배거나 계산 안 되면 룩업 격자로. **적용도: High** (다차원 가격표가 이 하네스의 본질).

### A1-4. CPQ(옵션 구성 상품) 데이터 모델 패턴

- **기법:** Salesforce CPQ는 **ProductModel = 옵션(option) + 피처(feature) + 구성속성 + 제약(constraint)**으로 상품을 모델링한다. **번들 부모** 밑에 **옵션(자식, 번들가에 기여)**, 옵션 묶음인 **피처는 Min/Max Options**로 "1개 택 / 5중 3택" 같은 선택 규칙. **옵션 제약(Option Constraint)**은 옵션 A 선택 시 옵션 B를 켜거나 끈다. **제품규칙(Product Rule)**=검증/선택/알림, **가격규칙(Price Rule)**=수량·조건별 가격 동적 변경, **Block Price**=수량 하한·상한·가격 구간행.
- **출처:** [Salesforce Help — Product Bundles in CPQ](https://help.salesforce.com/s/articleView?id=sales.cpq_bundle_products.htm&language=en_US&type=5) · [Salesforce Developers — CPQ Rules Management data model](https://developer.salesforce.com/docs/platform/data-models/guide/cpq-rules-management.html) · [Salesforce CPQ Data Model Map (PDF)](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/final_cpq_map.pdf)
- **이 하네스 규칙으로 번역:** 옵션/제약을 새로 발명하지 말고 **이 5요소로 매핑** — 후니의 `option_groups`(=피처, min/max)·`options/option_items`(=옵션)·`product_constraints`(=옵션 제약, JSONLogic)·`product_sets`(=번들 부모↔구성원)·가격구간(=Block Price)이 정확히 대응한다. **핵심 교훈: min/max·제약을 "옵션그룹으로 대충 대행"하지 말고 명시 제약으로 분리**(상용 표준이 둘을 나눈 이유=관리성). "5중 3택"류 선택수 제약은 summary variable(개수 세기)로 표현. **적용도: High**.

### A1-5. 참조·코드 테이블 설계 컨벤션 (대리키·소프트삭제·감사컬럼)

- **기법:** **대리키(surrogate key)**=업무 의미 없는 시스템 생성 정수 PK로 원천 변경으로부터 창고를 격리(자연키는 크고 변한다). **소프트삭제**=행을 지우지 않고 삭제 플래그/유효기간으로 표시. **감사컬럼**=`created_at/by`, `modified_at/by`로 누가 언제 바꿨는지·ETL 중단 진단. 이력 추적이 필요하면 SCD Type 2(같은 자연키에 여러 버전+start/end/active_flag).
- **출처:** [Microsoft Fabric — Dimension Tables (surrogate keys)](https://learn.microsoft.com/en-us/fabric/data-warehouse/dimensional-modeling-dimension-tables) · [Wikipedia — Slowly Changing Dimension](https://en.wikipedia.org/wiki/Slowly_changing_dimension)
- **이 하네스 규칙으로 번역:** 코드 테이블은 **이름기반 멱등 + MAX+1 채번**(이 하네스의 기존 컨벤션과 정합), **물리 삭제 금지·논리삭제(`del_yn`/`use_yn`)만**, 통합은 "신규+이름갱신+옛것 use_yn=N". 적재 코드는 **UPSERT(ON CONFLICT) + 감사컬럼 채움 + 트랜잭션 래핑**을 기본형으로. **적용도: High** (기존 [HARD] 규칙 "기초코드 삭제금지"와 일치 — 근거 보강).

---

## AREA 2 발견 — LLM 에이전트 기반 데이터 엔지니어링 (2023–2025)

### A2-1. LLM 에이전트의 스프레드시트·표 이해 (도구·벤치·한계)

- **기법:** **SheetCopilot**(NeurIPS 2023)=자연어 작업을 받아 스프레드시트 조작 계획을 생성·실행, 221개 과제/28워크북 벤치, "제안→검증→수정" 반영 루프. **Data Interpreter**=계층 그래프 동적 계획+도구통합+논리 불일치 탐지. **Table-GPT / SpreadsheetLLM / TableBench** 등 표 처리 계열. 종합 서베이가 "표 인코딩·직렬화가 성패를 가른다"고 정리.
- **출처:** [SheetCopilot (demo/paper)](https://sheetcopilot-demo.github.io/) · [arXiv 2402.05121 — LLM for Table Processing: A Survey](https://arxiv.org/html/2402.05121v1) · [arXiv 2410.07331 — DA-Code](https://arxiv.org/html/2410.07331v2) · [arXiv 2502.13897 — DataSciBench](https://arxiv.org/html/2502.13897v1)
- **무엇이 되고 무엇이 실패하나:** 되는 것=자연어→**연산 스크립트/계획 생성**, 표 구조 파악, 반영 루프로 자기수정. 실패=**셀 값 직접 계산/대량 셀 나열**(뒤 A2-3), 큰 표를 프롬프트에 통째로 넣기(토큰·정확도 붕괴).
- **이 하네스 규칙으로 번역:** 엑셀 이해를 **"에이전트가 시트를 눈으로 읽어 값을 옮긴다"가 아니라 "에이전트가 파서/디프 스크립트를 짠다"로** 설계. 표 인코딩은 CSV 캐시(1회 추출) 우선. **적용도: High**.

### A2-2. 큰 표는 셀을 읽지 말고 결정론 스크립트를 생성·실행하라 (토큰 효율)

- **기법:** 1만 행을 LLM에 넣지 말고 **로컬에서 pandas/SQL로 필터·집계**한 결과만 문맥에 넣으면 토큰 거의 0. Anthropic 엔지니어링: 도구를 코드 API로 노출해 에이전트가 코드를 쓰게 하면 **중간 결과가 실행환경에 머물고** 모델은 로그·반환한 것만 본다 → **150K→2K 토큰(98.7% 절감)**. 데이터 직렬화가 나쁘면 토큰 40~70% 낭비, 표는 CSV가 JSON보다 40~50% 효율. 코드 생성 데이터 랭글링은 F1 최대 +37.2점을 훨씬 낮은 비용으로.
- **출처:** [Anthropic — Code execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp) · [The New Stack — Token-Efficient Data Prep](https://thenewstack.io/a-guide-to-token-efficient-data-prep-for-llm-workloads/) · [ACM DEEM 2024 — Efficient Data Wrangling with LLMs using Code Generation](https://dl.acm.org/doi/10.1145/3650203.3663334)
- **이 하네스 규칙으로 번역:** **[HARD] 데이터 이동/비교/집계는 반드시 결정론 스크립트(pandas/psql)로, 에이전트는 스크립트를 짜고 검수만.** 엑셀↔DB 대조는 "권위 CSV ↔ 스냅샷 CSV를 diff 스크립트로"(이 하네스의 grid-diff/batch-builder가 이미 이 패턴 — 근거 보강). 에이전트가 "셀 값을 직접 판단"하는 자연어 대조는 토큰 폭발+환각이라 예외 처리에만. **적용도: High** (하네스의 토큰0 배치 방침을 직접 뒷받침).

### A2-3. 함정 — LLM이 숫자에서 실패하는 패턴 (환각)

- **기법(실패 유형):** **수치 환각**=오카운트, 숫자 잘못 복제, 부적절 치환, 값 날조. LLM은 피연산자 자릿수 늘면(특히 곱셈·중간자리) 산술이 무너지고, **표 추론에서 산술 오류가 연쇄로 전파되어 최종 판정을 뒤집는다.** 부동소수점을 직접 넣으면 산술 환각 유발(텍스트 모달리티가 고정밀 계산에 부적합). 벤치: 단순 조회 95.6% → 다변수 계산 near-0%로 붕괴. 자릿수 편향(Benford's Curse).
- **출처:** [arXiv 2506.01734 — Benford's Curse: Numerical Hallucination](https://arxiv.org/pdf/2506.01734) · [arXiv 2502.11075 — Exposing Numeracy Gaps](https://arxiv.org/pdf/2502.11075) · [arXiv 2603.07316 — FinSheet-Bench (95.6%→~0%)](https://arxiv.org/pdf/2603.07316) `미확인: 미래 날짜 arXiv ID, 초록만 검색결과로 확인`
- **이 하네스 규칙으로 번역:** ① **가격 숫자는 절대 LLM이 계산·전사하지 않는다** — verbatim 복사는 스크립트로, 계산은 실제 가격엔진(`evaluate_price`) 실호출로만(이 하네스의 "골든값 verbatim·날조 0·허용오차 0"과 일치). ② 다차원 곱셈(면적×단가×수량)은 특히 위험 — 반드시 코드/DB가 수행. ③ 에이전트 산출에 숫자가 등장하면 "출처 셀/쿼리"를 강제. **적용도: High** (가장 중요한 안전장치).

### A2-4. 생성자–검증자 분리 + 자기일관성/교차검증

- **기법:** LLM은 **생성보다 검토를 잘하고**, 생성·검토 프롬프트를 분리하면 self-refine 대비 ~20% 향상. 단, **자기검증은 자기일관 오류(같은 모델이 반복해서 같이 틀림)를 못 잡는다** — 오류는 모델별로 달라 겹치지 않으므로 **다른 계열의 외부 검증자**가 낫다. 강한 생성자일수록 오류가 교묘해져 검증 난도↑(그래서 독립 실측이 필요).
- **출처:** [arXiv 2505.17656 — Too Consistent to Detect (self-consistent errors)](https://arxiv.org/pdf/2505.17656) · [arXiv 2408.15240 — Generative Verifiers](https://arxiv.org/html/2408.15240) · [Medium — LLM Verification Loops](https://timjwilliams.medium.com/llm-verification-loops-best-practices-and-patterns-07541c854fd8)
- **이 하네스 규칙으로 번역:** ① **[HARD] 생성≠검증**(같은 컨텍스트 자기승인 금지) — 스키마/적재본을 만든 에이전트와 게이트 검증 에이전트를 분리(이 하네스 전반의 원칙). ② **다른 모델(codex)로 2차 교차검증**하되 codex 주장=가설(라이브/권위로 확증 전 채택 금지) — 자기일관 오류를 다른 계열이 잡는다는 근거와 정합. ③ 검증은 "말"이 아니라 **독립 실측(스크립트 재실행·DB 재조회)**으로. **적용도: High**.

### A2-5. Text-to-Schema / Text-to-SQL 자동화의 현주소

- **기법:** LLM 기반 Text-to-SQL이 주류가 되며 **스키마 링킹**(질문↔관련 테이블/컬럼 연결)이 성능 핵심. 스키마 구조·주석·**샘플 데이터·관계 매핑**을 문맥에 주면 성능↑. 환각 완화는 "생성 전 정렬(alignment)". 컬럼 설명 자동생성(TACO), 지식베이스 증강 등.
- **출처:** [arXiv 2406.08426 — Next-Gen Database Interfaces: LLM Text-to-SQL Survey](https://arxiv.org/pdf/2406.08426) · [arXiv 2411.00073 — RSL-SQL: Robust Schema Linking](https://arxiv.org/html/2411.00073v1)
- **이 하네스 규칙으로 번역:** 스키마 생성/매핑 시 **라이브 DDL·컬럼 주석·코드값·샘플행을 반드시 문맥에 제공**(정보 없이 추론 금지 → 환각 원천). "search-before-mint"(신규 만들기 전 기존 검색)는 스키마 링킹의 하네스판. **적용도: Medium** (이 하네스는 순수 NL→SQL이 아니라 엑셀→스키마라 부분 적용).

---

## 함정 / 안티패턴 모음 (특히 LLM×숫자)

| # | 안티패턴 | 왜 위험 | 하네스 방어 |
|---|---|---|---|
| F1 | LLM이 가격 셀을 눈으로 읽어 전사/계산 | 자릿수·연쇄계산 환각(95.6%→0%) | 숫자는 스크립트/엔진만, verbatim 복사도 코드로 |
| F2 | 다차원 가격을 EAV(값-보따리)로 적재 | 제약 불가·조회 폭발·오타=새속성 | 차원=명시 코드 컬럼, wide 읽고 long 적재 |
| F3 | 수량구간 종류(tiered/volume/stairstep) 혼동 | 전 구간 대량 과/저청구 | 가격축마다 종류 명시 태깅 |
| F4 | 큰 표를 프롬프트에 통째로 투입 | 토큰 폭발+정확도 붕괴 | 1회 CSV 추출→diff 스크립트(토큰0) |
| F5 | 같은 에이전트가 만들고 자기승인 | 자기일관 오류를 못 잡음 | 생성≠검증 + 다른 계열 교차검증 |
| F6 | 옵션 min/max·제약을 옵션그룹으로 대행 | 관리 붕괴(상용 표준이 분리한 이유) | 명시 constraint로 분리(CPQ 5요소) |
| F7 | 스키마를 DDL/샘플 없이 추론 | 컬럼·코드값 환각 | 라이브 DDL·주석·샘플행을 문맥 강제 |
| F8 | 부동소수점을 LLM에 직접 넣어 비교 | 산술 환각 | DECIMAL·정수 취급, 비교는 코드 |

---

## 하네스 설계 권고 Top 5

1. **숫자·데이터는 코드, LLM은 로직만 (골든 룰).** 엑셀↔DB의 모든 이동/대조/집계/verbatim 복사는 결정론 스크립트(pandas/psql)로 하고, 에이전트는 스크립트를 생성·검수만 한다. 가격 계산은 실제 엔진 실호출로만. → 토큰 98% 절감 + 수치 환각 원천 차단. (A2-2, A2-3)

2. **가격표는 "wide로 읽고 long으로 적재", 차원은 명시 컬럼(EAV 금지).** 가로세로 매트릭스를 `(상품, 사이즈, 자재, 수량구간)→단가` 행으로 unpivot하고, 각 가격축의 수량구간 종류(tiered/volume/stairstep)를 태깅한다. (A1-3)

3. **CPQ 5요소 표준을 그대로 흡수한다.** 옵션 구성은 번들-옵션-피처(min/max)-제약-가격구간으로 매핑하고, min/max·제약을 옵션그룹으로 대행하지 말고 명시 제약(JSONLogic 등)으로 분리한다. (A1-4)

4. **개념→논리→물리 3패스를 게이트로 만든다.** ① 엔티티·차원 식별 ② 컬럼↔차원↔단위·코드값 확정 ③ DDL/UPSERT 적재본. 각 패스에 중간 산출물(사람이 읽는 표/CSV)을 남겨 검증·롤백 지점을 확보. 참조데이터는 정규화, 가격은 룩업 격자. (A1-1, A1-2)

5. **생성≠검증 + 독립 교차검증을 [HARD]로.** 만든 에이전트가 자기승인 금지, 다른 계열 모델(codex)로 2차 의견을 받되 라이브/권위로 확증 전엔 가설로만 취급. 검증은 말이 아니라 스크립트 재실행·DB 재조회·엔진 재계산의 실측으로. 적재 코드는 UPSERT+감사컬럼+트랜잭션+DRY-RUN, 삭제는 논리삭제만. (A1-5, A2-4)

---

## 출처 목록 (실재 URL, 15+)

**AREA 1**
1. https://www.1keydata.com/datawarehousing/data-modeling-levels.html — 개념/논리/물리 3단계
2. https://www.couchbase.com/blog/conceptual-physical-logical-data-models/ — CLP 모델·청중
3. https://www.cloudquery.io/blog/explainer-3nf_vs_star-schema — 3NF vs 스타 스키마
4. https://www.matillion.com/blog/3nf-vs-dimensional-modeling — 3NF vs 차원모델
5. https://datadef.io/guides/en/dimensional-modeling — Kimball 차원모델 가이드
6. https://docs.recurly.com/recurly-subscriptions/docs/-tiered-stairstep-and-volume-pricing — 수량구간 3종
7. https://docs.proabono.com/documentation/whats-the-difference-between-tiered-pricing-and-volume-pricing/ — tiered vs volume
8. https://www.cybertec-postgresql.com/en/entity-attribute-value-eav-design-in-postgresql-dont-do-it/ — EAV 안티패턴
9. https://en.wikipedia.org/wiki/Entity%E2%80%93attribute%E2%80%93value_model — EAV 정의·예외
10. https://help.salesforce.com/s/articleView?id=sales.cpq_bundle_products.htm&language=en_US&type=5 — CPQ 번들/피처 min-max
11. https://developer.salesforce.com/docs/platform/data-models/guide/cpq-rules-management.html — CPQ 규칙 데이터모델
12. https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/final_cpq_map.pdf — CPQ 데이터모델 맵(PDF)
13. https://learn.microsoft.com/en-us/fabric/data-warehouse/dimensional-modeling-dimension-tables — 대리키·디멘전
14. https://en.wikipedia.org/wiki/Slowly_changing_dimension — SCD·소프트삭제·감사컬럼

**AREA 2**
15. https://sheetcopilot-demo.github.io/ — SheetCopilot(NeurIPS 2023)
16. https://arxiv.org/html/2402.05121v1 — LLM for Table Processing: A Survey
17. https://arxiv.org/html/2410.07331v2 — DA-Code(에이전트 데이터과학 코드생성 벤치)
18. https://arxiv.org/html/2502.13897v1 — DataSciBench
19. https://dl.acm.org/doi/10.1145/3650203.3663334 — Efficient Data Wrangling with LLMs using Code Generation (DEEM 2024)
20. https://www.anthropic.com/engineering/code-execution-with-mcp — 코드실행 MCP(150K→2K 토큰)
21. https://thenewstack.io/a-guide-to-token-efficient-data-prep-for-llm-workloads/ — 토큰효율 데이터 준비(CSV>JSON)
22. https://arxiv.org/pdf/2506.01734 — Benford's Curse: 수치 환각
23. https://arxiv.org/pdf/2502.11075 — Exposing Numeracy Gaps(수 능력 벤치)
24. https://arxiv.org/pdf/2505.17656 — Too Consistent to Detect(자기일관 오류)
25. https://arxiv.org/html/2408.15240 — Generative Verifiers
26. https://timjwilliams.medium.com/llm-verification-loops-best-practices-and-patterns-07541c854fd8 — 검증 루프 패턴(생성≠검토 ~20%)
27. https://arxiv.org/pdf/2406.08426 — LLM Text-to-SQL 서베이(스키마 링킹)
28. https://arxiv.org/html/2411.00073v1 — RSL-SQL 스키마 링킹
29. https://arxiv.org/pdf/2603.07316 — FinSheet-Bench (`미확인`: 미래 날짜 arXiv ID·검색결과 초록만 확인)
