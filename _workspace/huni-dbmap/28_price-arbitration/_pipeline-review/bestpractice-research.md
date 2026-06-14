# 가격계산 검증 하네스 — 베스트프랙티스 리서치

> 목적: "라이브에 적재된 가격·상품구성요소 데이터가 권위 원본(엑셀)대로 맞는지 검증하고, 틀리면
> 개선/수정/보완할 때 요건이 충분히 반영됐는지 보장"하는 산업 표준·방법론을 확인해, 우리 파이프라인
> 설계 권고로 정리한다.
>
> 작성: 2026-06-14 · 읽기전용 WebSearch/WebFetch · 모든 인용 URL은 WebFetch 검증
> 적용 맥락: 라이브 DB 적재 가격(t_prc_*) · 엑셀 권위(상품마스터·가격표) · 경쟁사 합리성 오라클 · 돈-크리티컬

---

## 0. 한눈에 (핵심 베스트프랙티스 3~5)

| # | 베스트프랙티스 | 한 줄 원리 | 우리 적용 |
|---|---------------|-----------|----------|
| **BP-1** | **Value-level source-to-target reconciliation** (행수만 보지 말고 셀 단위 대조) | 행수·합계는 개별 셀 오류를 가린다 → field-by-field + FK 무결성 + 6품질차원 분류 | 엑셀 권위 ↔ 라이브 t_prc_* 셀단위 diff (단가행·차원키·할인구간) |
| **BP-2** | **검증 게이트 순서: 데이터 정합 → 구성(config) → 가격계산** | garbage-in 방지. 입력 마스터데이터가 통과해야 파생 계산을 검증 | 가격사슬 구성요소(자재·공정·사이즈·도수·단가행) 정합 게이트를 가격계산 검증의 선행 관문으로 |
| **BP-3** | **Metamorphic / reasonableness oracle** (정답 대신 "성립해야 할 관계"로 검증) | 정확한 정답을 몰라도 단조성·배수·외부벤치마크 관계 위반은 결함 확증 | 수량↑→단가↓ 단조성, 면적 2배→가격 ~2배 등 + 경쟁사 가격을 합리성 오라클(정답 아님)로 |
| **BP-4** | **Tolerance/materiality 기반 분류** (모든 차이를 동급 취급 금지) | 돈 데이터는 금액·% 혼합 임계로 즉시교정 vs 추적관찰 분리 | 가격 diff를 금액+% blended 임계로 PASS/WARN/FAIL, FAIL만 차단 |
| **BP-5** | **Closed-loop remediation + 양방향 추적성(RTM)** | 발견→교정→재검증 폐루프 + 요건↔검증 양방향 매핑으로 커버리지·재발 보장 | 결함보드→교정 매니페스트→재검증 게이트, 요건(상품×가격요소)↔게이트 traceability |

---

## 1. 질문별 베스트프랙티스 요약

### Q1. 데이터 정합/검증 — 적재본이 원본(source of truth)대로인가

**핵심 발견**
- **행수 대조는 함정이다.** Datafold는 "단순 record count가 흔히 첫 지표로 쓰이지만 매우 오해를 부를 수 있다 — 합계는 맞아도 개별 행이 틀릴 수 있다"고 명시. 대신 **field-by-field 비교 + checksum + 관계무결성(FK) + value-level 정밀 대조**로 "정확히 어디가 안 맞는지" 찾으라고 권고. ([Datafold](https://www.datafold.com/blog/data-reconciliation-best-practices/))
- **ETL 검증 5단계 표준**: ① source 검증 ② transformation rule 검증 ③ completeness ④ integrity ⑤ business validation. 합·집계 같은 복잡 로직이 끼면 source/target 양쪽에서 business validation이 필요. ([Integrate.io](https://www.integrate.io/blog/data-validation-etl/), [Talend](https://www.talend.com/resources/etl-testing/))
- **6개 품질 차원으로 결함 분류**: completeness / accuracy / consistency / timeliness / conformity / uniqueness. 막연한 "에러" 대신 차원별 분류 + 심각도 등급으로. ([Datafold](https://www.datafold.com/blog/data-reconciliation-best-practices/))
- **데이터 계약(data contract) & 선언적 테스트**: dbt contract는 컬럼명·타입·NOT NULL을 DDL로 강제하고 모델 빌드 전에 검사. dbt-expectations / Great Expectations는 `expect_column_pair_values_a_to_be_greater_than_b`, `expect_column_values_to_match_regex` 같은 **관계·범위 단언**을 선언적으로 제공. ([Datadog dbt-expectations](https://www.datadoghq.com/blog/dbt-data-quality-testing/), [DataCamp data contracts](https://www.datacamp.com/blog/data-contracts))
- **거버넌스**: 검증·승인·예외관리 역할을 명확히 배정하고(ownership), 마이그레이션 사후가 아니라 **데이터 이동 때마다 상시 reconciliation**으로 조기 적발. ([Quinnox](https://www.quinnox.com/blogs/data-reconciliation/), [Datagaps](https://www.datagaps.com/blog/data-reconciliation-best-practices/))

> **함의(우리 맥락)**: "라이브 행이 존재함 = 적재됨"으로 보는 LOADED 판정(이미 round-7에서 D-1 결함으로 식별)은
> 정확히 이 함정이다. 권위=엑셀, 대상=라이브로 두고 **셀 단위 value-level diff**(단가행 금액, 차원키
> 매칭, 할인구간 경계)를 1차 검증으로 삼아야 한다.

---

### Q2. 게이트형 검증 순서 — 입력 정합을 파생 계산의 선행 게이트로

**핵심 발견**
- **CPQ 테스트의 명시적 순서 = 데이터 정합 → 구성(config) 로직 → 가격(pricing) 실행.** Everstage:
  "configuration logic은 pricing logic보다 **먼저** 검증되어야 한다 ... 이 순서가 corrupted input이
  가격계산으로 cascade되는 것을 막는다." 권고 구조: **data integrity → configuration logic → pricing execution.**
  ([Everstage CPQ Testing](https://www.everstage.com/cpq/cpq-testing))
- **통합 지점에서 입력 게이트**: "integration point마다 validation rule을 세워 bad data가 조용히
  전파되는 것을 막아라. 부정확한 SKU·원가·수량단위 등 master data는 product record에서 먼저
  맞아야 한다." 가격 계산 전에 누락/이상 필드를 flag. ([Everstage](https://www.everstage.com/cpq/cpq-testing), [Infor CPQ](https://www.infor.com/solutions/service-sales/configure-price-quote/what-is-cpq))
- **Pricing Waterfall**: 가격은 List Price에서 시작해 System/Partner/Volume Discount를 순차
  cascade하여 Net Price로. 즉 가격계산 자체가 **단계적 파이프라인**이며, 각 단계의 입력(단가·할인율)이
  선행 검증되어야 한다. ([Salesforce CPQ pricing engine](https://medium.com/@shirley_peng/the-math-whiz-demystifying-the-cpq-pricing-engine-7936316b4750))
- 데이터 엔지니어링 일반 원칙도 동일: "data quality testing을 **가장 먼저** — 전체 reconciliation의
  토대이며, 에러가 파이프라인으로 전파되기 전에 차단." ([Datafold](https://www.datafold.com/blog/data-reconciliation-best-practices/))

> **함의(우리 맥락)**: 가격계산(재계산/엔진) 검증은 **구성요소 정합 게이트가 GO일 때만** 의미가 있다.
> 단가행·차원·할인구간·바인딩이 엑셀과 어긋난 채로 계산을 검증하면 "맞는 공식이 틀린 입력으로 틀린 값"을
> 내고 검증이 그것을 통과시킬 수 있다(false confidence).

---

### Q3. 경쟁사/외부 기준 합리성 검증 — 이상치(터무니없는 차이) 적발

**핵심 발견**
- **Test Oracle Problem**: 정확한 정답을 모르거나(또는 구하기가 너무 비싸) 단건 출력의 옳고 그름을
  직접 판정할 수 없는 상황. 가격처럼 "이 옵션 조합의 정답가"를 외부에서 독립 산출하기 어려운 경우가 해당.
  ([Wikipedia: Metamorphic testing](https://en.wikipedia.org/wiki/Metamorphic_testing))
- **Metamorphic Testing**: 단건 정답 대신 **여러 실행 사이에 반드시 성립해야 할 관계(metamorphic
  relation)** 를 검사. 관계가 깨지면 정답을 몰라도 결함이 **확증**된다. 예: `sin(π−x)=sin(x)`,
  검색 결과를 가격대로 필터하면 부분집합이어야 함. → "절대 정확성"이 아니라 "다중 시나리오에 걸친
  논리적 일관성"을 검사. ([Wikipedia](https://en.wikipedia.org/wiki/Metamorphic_testing), [Chen et al. IEEE](https://ieeexplore.ieee.org/document/7166267/))
- 가격 도메인에 자연스러운 관계(reasonableness oracle): **수량↑ → 단가↓(수량할인 단조성)**,
  **면적/사이즈 2배 → 면적형 가격 ≈ 2배**, **옵션 추가 → 총가 비감소(monotone)**, **고정가형은
  수량과 무관한 단가**. 이런 관계 위반은 정답가를 몰라도 결함 신호.
- **외부 벤치마크 = 합리성 오라클(정답 아님)**: 경쟁사 가격은 전략 차이로 다를 수 있으므로 정답이
  아니다. 그러나 **터무니없는 차이(예: 10배·1/10)** 는 우리 계산/매핑/적재 결함의 강한 신호 —
  reconciliation의 anomaly detection과 동형.

> **함의(우리 맥락)**: 우리에겐 이미 `dbm-competitor-benchmark`(와우프레스·레드프린팅)와
> `dbm-price-engine-verifier`(재계산)가 있다. 이를 **두 종의 오라클**로 정식화하면 된다 —
> ① 내부 정답 오라클(엑셀 known값 = exact), ② 합리성 오라클(metamorphic 관계 + 경쟁사 plausibility).
> 경쟁사는 "차이의 합리성"만 판정(정답 단정 금지)하고, 터무니없으면 정답 오라클·사슬 실측으로 회부.

---

### Q4. 개선 폐루프 — 결함 발견→교정→재검증 + 요건 커버리지 보장

**핵심 발견**
- **상시·폐루프 reconciliation**: 사후 일괄이 아니라 데이터 이동 때마다 자동 재검증으로 조기 적발하고
  대규모 실패를 예방. 불일치는 **flag → 심각도 분류 → 교정조치 검토 → 검증 리포트로 동기화 확인**의
  순환. ([Quinnox](https://www.quinnox.com/blogs/data-reconciliation/), [Integrate.io](https://www.integrate.io/blog/data-validation-etl/))
- **양방향 추적성(RTM)**: forward + backward를 결합한 bidirectional traceability가 "초기 비즈니스
  요건 → 구현 → 다시 요건"의 완전한 책임 순환을 만든다. RTM은 **커버리지 갭·누락 요건을 조기에 드러내고**
  audit readiness를 제공. **단, 갱신이 늦으면 같은 산출물이 거짓 확신을 만든다**(stale 경고).
  ([Jama](https://www.jamasoftware.com/requirements-management-guide/requirements-traceability/traceability-matrix-101/), [Testomat RTM](https://testomat.io/blog/the-ultimate-guide-to-rtm-requirements-traceability-matrix/), [Atlassian](https://community.atlassian.com/forums/App-Central-articles/The-Benefits-of-a-Traceability-Matrix-in-Quality-Assurance/ba-p/2898288))
- **Tolerance/Materiality 임계(돈 데이터 특화)**: 재무 reconciliation은 모든 차이를 동급으로 보지
  않는다. **금액(절대) + % (상대)** 를 혼합한 materiality 임계로, 임계 초과만 즉시 교정 대상, 미만은
  추적관찰(pattern analysis). 계정/항목별로 임계를 차등. ([Numeric materiality](https://www.numeric.io/blog/materiality-threshold), [Hyperbots reconciliation threshold](https://www.hyperbots.com/glossary/reconciliation-threshold), [Cornell internal controls](https://finance.cornell.edu/controller/internalcontrols/materiality))

> **함의(우리 맥락)**: 우리 결함보드(round-7/13)→교정 매니페스트(round-13/23_remediation-apply)
> →재검증 게이트가 이미 폐루프의 형태. 여기에 ① **요건↔게이트 양방향 추적표**(상품×가격요소 요건이
> 어느 검증으로 커버되는지, 미커버=갭)와 ② **금액+% materiality 임계**로 차이를 PASS/WARN/FAIL
> 분류하는 규칙을 추가하면 "요건이 충분히 반영됐는지 보장"이 구조적으로 충족된다.

---

## 2. 우리 파이프라인 적용 권고

> 새 도구 도입 권고는 하지 않는다. 아래는 **원리·패턴을 기존 하네스(생성≠검증·게이트·산출물 추적)에
> 흡수**하는 형태다. 모든 권고는 라이브 읽기전용·DB 미적재·실 교정 인간승인 원칙을 그대로 따른다.

### 2.1 게이트 순서 (BP-2) — 3단 선행 게이트

검증 하네스를 **반드시 이 순서**로 구성한다. 앞 게이트 NO-GO면 뒤 게이트는 실행하지 않는다(또는
결과를 신뢰하지 않는다).

```
G-DATA  구성요소 정합(엑셀↔라이브 셀단위)   ──PASS──▶  G-CHAIN  가격사슬 배선 완전성     ──PASS──▶  G-CALC  가격계산 재계산·합리성
(단가행·차원키·할인구간·코드값)                        (공식→formula_components→         (재계산 vs 엑셀 known +
                                                     price_components→component_prices    metamorphic 관계 + 경쟁사 plausibility)
                                                     ·t_dsc 할인 연결·바인딩 존재)
```

- **G-DATA**(BP-1): 엑셀 권위 ↔ 라이브 t_prc_* / 구성요소 t_mat_*·t_proc_* 등을 **value-level diff**.
  행수 대조 금지 — 단가 금액·차원키·할인구간 경계·코드값을 셀 단위로. 6품질차원으로 분류.
- **G-CHAIN**: 가격사슬 단절(round-16/17에서 식별)을 선행 차단. 상품→공식→구성요소→단가행이 실제로
  배선됐는지(고아·미바인딩=FAIL). 이게 깨지면 G-CALC는 "엔진 없음/입력 없음"으로 무의미.
- **G-CALC**(BP-3): G-DATA·G-CHAIN PASS인 케이스만 재계산. 라이브 엔진 미구현 상태에선 Phase11
  명세대로 검증용 계산기 재구현(이미 `dbm-price-engine-verifier`가 수행).

### 2.2 실 적재 검증 (BP-1) — "행 존재"가 아니라 "값 일치"

- 권위 = 엑셀(상품마스터·가격표 known값). 대상 = 라이브.
- 1차: **completeness**(필요 단가행/차원/할인구간이 라이브에 다 있는가) + **accuracy**(있는 값이
  엑셀과 같은가) + **consistency**(FK·polymorphic ref·할인테이블 연결 무결성).
- round-7의 **D-1 결함(LOADED=행존재만, 변형 커버리지 미검증)** 을 이 게이트가 정식으로 닫는다 —
  각 상품의 **선택 변형(사이즈/도수/수량 조합)별로 대응 단가행이 존재+일치**하는지까지.
- 산출: 차원별/상품별 셀 diff 보드(MATCH/MISMATCH/MISSING) + 6품질차원 라벨.

### 2.3 합리성 오라클 (BP-3) — 두 종 오라클 정식화

- **정답 오라클(exact)**: 가격표 엑셀의 known 셀값. 재계산 결과와 정확히 일치해야 함(반올림 규칙 명시).
- **합리성 오라클(plausibility, 정답 아님)**:
  - *Metamorphic 관계* — 수량↑→단가 비증가, 면적 k배→면적형가 ≈k배, 옵션 추가→총가 비감소,
    고정가형은 수량 무관. 위반 시 정답을 몰라도 **결함 확증**.
  - *경쟁사 벤치마크* — 같은 옵션 동형 매핑으로 와우프레스/레드프린팅과 대조. **터무니없는 차이만**
    이상치로 본다(전략 차이는 정상). 이상치는 정답 오라클·사슬 실측으로 회부(`dbm-price-arbiter`).
- [HARD 유지] 경쟁사 가격으로 우리 가격을 재단하지 않는다 — 합리성 신호로만.

### 2.4 Materiality 임계 (BP-4) — 차이 분류 규칙

모든 차이를 동급 차단하지 말 것. **금액(절대) + %(상대) blended** 임계로:

| 판정 | 규칙(예시 — 실제 임계는 인간 확정) | 처리 |
|------|----------------------------------|------|
| **PASS** | 반올림 오차 이내(정답 오라클은 0원이 원칙) | 통과 |
| **WARN** | 작은 절대차 또는 작은 % — 패턴 관찰 | 추적관찰(즉시 차단 안 함) |
| **FAIL** | 금액·% 임계 동시 초과 또는 metamorphic 위반·MISSING | 차단 → 폐루프 회부 |

- 정답 오라클(엑셀 known)은 원칙상 **정확 일치**(돈 데이터). 임계는 주로 합리성 오라클·경쟁사 비교의
  노이즈 억제와 우선순위화에 쓴다.

### 2.5 폐루프 + 추적성 (BP-5) — 발견→교정→재검증 + 커버리지 보장

- **폐루프**: 결함보드(FAIL) → 교정 매니페스트(원인유형·근본원인·교정 t_*·트랙 라우팅, 이미
  round-13/23 형태) → 적용(인간승인) → **동일 게이트 재검증(2-pass)** 으로 닫힘 확인. 재검증 GO
  전에는 "교정됨" 단정 금지(round-13 stale 게이트 교훈과 동형).
- **요건↔게이트 양방향 추적표(RTM)**: 행=요건(상품군 × 가격요소: 사이즈·도수·수량할인·옵션가·공식),
  열=게이트(G-DATA/G-CHAIN/G-CALC + 오라클). 셀=커버 상태. **빈 셀=커버리지 갭**(검증 안 된 요건).
  이로써 "요건이 충분히 반영됐는지"가 한 판에서 입증된다(round-7 커버리지 매트릭스의 검증 버전).
- [HARD] RTM·결함보드는 **stale 시 거짓 확신**을 준다 → 재검증마다 라이브 실측으로 갱신, 산출물에
  측정 시각·권위 출처 기록(우리 기존 산출물 추적 규약 그대로).

### 2.6 생성≠검증 (기존 규약 강화)

- 재계산기 구현(`dbm-price-engine-verifier`)과 게이트 판정(`dbm-validator` PE1~PE6)을 분리 유지.
  metamorphic/합리성 오라클도 **검증 측**이 독립 설계(생성자가 자기 출력을 정당화하지 않도록).

---

## 3. 우리 자산 ↔ 베스트프랙티스 매핑 (이미 보유분 활용)

| 베스트프랙티스 | 우리 기존 자산 | 보강 포인트 |
|---------------|---------------|------------|
| BP-1 value-level reconciliation | round-7 커버리지 매트릭스·round-13 교정 감사 | "행존재→값일치"로 격상(D-1 결함 정식 차단) |
| BP-2 게이트 순서 | round-17 사슬 진단·`dbm-price-engine-verify` PE게이트 | G-DATA→G-CHAIN→G-CALC 선후 강제 명문화 |
| BP-3 오라클 | `dbm-price-engine-verifier`(재계산)·`dbm-competitor-benchmark`(경쟁사) | 정답/합리성 2종 오라클 + metamorphic 관계 추가 |
| BP-4 materiality | (신규) | 금액+% blended 임계로 PASS/WARN/FAIL 분류 규칙 |
| BP-5 폐루프+RTM | round-13/23 교정 매니페스트·round-7 매트릭스 | 요건↔게이트 양방향 추적표 + 2-pass 재검증 |

---

## Sources

모든 URL은 WebFetch로 직접 검증함(접근 가능·내용 인용 일치).

- Datafold — Data reconciliation: technical best practices: https://www.datafold.com/blog/data-reconciliation-best-practices/ (WebFetch 검증)
- Everstage — CPQ Testing: How to Protect Revenue and Quote Accuracy: https://www.everstage.com/cpq/cpq-testing (WebFetch 검증)
- Wikipedia — Metamorphic testing: https://en.wikipedia.org/wiki/Metamorphic_testing (WebFetch 검증)
- Integrate.io — Data Validation in ETL (2026 Guide): https://www.integrate.io/blog/data-validation-etl/
- Talend — ETL Testing: What, Why, and How: https://www.talend.com/resources/etl-testing/
- Quinnox — Data Reconciliation: Best Practices, Challenges & Use Cases: https://www.quinnox.com/blogs/data-reconciliation/
- Datagaps — Data Reconciliation Best Practices (ETL Validator): https://www.datagaps.com/blog/data-reconciliation-best-practices/
- Datadog — Implement dbt data quality checks with dbt-expectations: https://www.datadoghq.com/blog/dbt-data-quality-testing/
- DataCamp — What Are Data Contracts? A Beginner Guide: https://www.datacamp.com/blog/data-contracts
- Infor — What is CPQ (Configure, Price, Quote)?: https://www.infor.com/solutions/service-sales/configure-price-quote/what-is-cpq
- Shirley Peng (Medium) — Demystifying the CPQ Pricing Engine (Pricing Waterfall): https://medium.com/@shirley_peng/the-math-whiz-demystifying-the-cpq-pricing-engine-7936316b4750
- Chen et al. (IEEE) — Metamorphic Testing: A Simple Method for Alleviating the Test Oracle Problem: https://ieeexplore.ieee.org/document/7166267/
- Jama Software — Requirements Traceability Matrix 101: https://www.jamasoftware.com/requirements-management-guide/requirements-traceability/traceability-matrix-101/
- Testomat — RTM Requirements Traceability Matrix Guide: https://testomat.io/blog/the-ultimate-guide-to-rtm-requirements-traceability-matrix/
- Atlassian Community — Benefits of a Traceability Matrix in QA: https://community.atlassian.com/forums/App-Central-articles/The-Benefits-of-a-Traceability-Matrix-in-Quality-Assurance/ba-p/2898288
- Numeric — How to Calculate Materiality Thresholds: https://www.numeric.io/blog/materiality-threshold
- Hyperbots — What is Reconciliation Threshold?: https://www.hyperbots.com/glossary/reconciliation-threshold
- Cornell University — Materiality and Risk Assessment (Internal Controls): https://finance.cornell.edu/controller/internalcontrols/materiality
