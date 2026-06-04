# A. ETL 베스트프랙티스 — 비정규화 Excel → 정규화 RDB 매핑 정합검증 적용 리서치

> huni-dbmap round-3 매핑 정합 검증 방법론 재설계 산출물 A (리서치).
> 외부 데이터 엔지니어링·ETL·data quality 모범사례를 조사하여 **후니 9속성 정합검증에 이렇게 적용하라**는 실행 권고로 변환한 문서.
> 후속 산출물 B(규칙사전)·C(전수 검증 설계)가 직접 참조하도록 작성.

---

## ① 요약 — 후니 적용 핵심 권고

1. **검증 기준은 "DB 정규화 규칙"이지 "엑셀 원본 셀 집합"이 아니다.** 1차 검증이 엑셀 셀값을 그대로 기대집합으로 삼아 "과적재 오판"을 낸 것은 source-to-target 검증의 정석을 어긴 것이다. 올바른 흐름은 **엑셀 원천 → (변환규칙 적용) → 기대행(expected rows) 산출 → DB 적재행과 집합대조**다. 엑셀 값 그 자체가 아니라 *변환규칙이 산출하는 기대값*이 비교 기준이 된다.
2. **엑셀 한 셀의 다중값·머지·취합(ragged) 구조는 반드시 unpivot/melt + lookup 정규화로 행 단위로 펼쳐야 비교가 성립한다.** 비교 전 "엑셀 → 정규화된 기대행" 변환 단계를 검증 파이프라인 안에 명시적으로 넣어라. 이 변환 자체가 검증 로직의 권위 소스다.
3. **엑셀 값으로 DB를 덮어쓰면 안 된다(no reverse load).** 정규화 결과를 비정규화 원천으로 되돌리면 surrogate key·코드 디멘션·차원 분리·제약이 손실/오염된다. 정합검증은 read-only 대조이며, 불일치 발견 시 처방은 "재변환·재적재 설계"이지 "엑셀 값 직접 주입"이 아니다.
4. **불일치는 4분류로 코드화한다: MATCH / MISSING(엑셀에 있고 DB에 없음) / EXTRA(DB에 있고 엑셀에 없음=잉여·중복 의심) / MISMATCH(둘 다 있으나 값 불일치).** 이것이 reconciliation의 표준 결과 스키마이며 9속성 전부 동일 스키마로 산출하라.
5. **count(건수) 대조 → set(집합) 대조 → value(필드값) 대조의 3계층으로 깊어진다.** count만 맞아도 안 되고(중복+누락이 상쇄될 수 있음), 자연키 기반 집합대조와 필드값 대조까지 내려가야 1차 결함(상쇄형 누락)을 잡는다.
6. **표본에서 도출한 변환규칙은 마스터 디멘션 테이블 전체에 적용해 일반화를 검증한다(overfitting 방지).** 소수 상품으로 만든 규칙을 t_prd_*·t_siz_*·t_mat_* 등 디멘션 전수에 돌려 MISSING/EXTRA가 폭증하지 않는지 확인해야 규칙이 진짜 일반 규칙임이 입증된다.
7. **dbt/Great Expectations식 제약·집합 검증 4종(not_null / unique / accepted_values / relationships)을 정합검증의 무결성 게이트로 선행 실행하라.** FK·UNIQUE·코드값 도메인 위반은 값 대조 이전에 걸러야 한다.

---

## ② ragged Excel → 정규화 ETL 표준 패턴

후니 엑셀은 ragged/취합 구조(한 셀 다중값, 머지셀, 옵션 캐스케이드, 가변 길이 행)다. 이를 정규화 RDB로 옮길 때의 표준 변환 패턴은 다음과 같다.

### 2.1 Unpivot / Melt (wide → long)
- 한 행에 여러 옵션·값이 가로로 늘어선 wide 구조를, 행 단위 long 구조로 펼친다. SQL `UNPIVOT` 또는 pandas `melt`가 표준 도구.
- **후니 적용:** "한 셀에 콤마/줄바꿈으로 묶인 옵션값들"(예: 사이즈 목록, 자재 목록)은 그대로 1셀=1값으로 오판하면 안 되고, 분해(split)하여 N행으로 펼친 뒤 각 행이 DB의 1행(t_siz_sizes, t_mat_materials 등)에 대응되어야 한다. 이 split 규칙이 곧 B 규칙사전의 핵심 항목.

### 2.2 Lookup 정규화 + 코드 디멘션 분리
- 반복되는 텍스트 값은 별도 디멘션 테이블로 분리하고 코드값(MTRL_CD, PROC_CD, SIZ_CD …)으로 참조. 텍스트가 아닌 코드가 관계의 축이 된다.
- **후니 적용:** 엑셀의 자유 텍스트 옵션명을 DB 코드값으로 매핑하는 lookup 테이블이 변환의 권위. 정합검증은 "엑셀 텍스트 → 코드값" 매핑이 1:1로 성립하는지, 코드 미존재(MISSING) 또는 고아 코드(EXTRA)가 없는지를 본다.

### 2.3 Surrogate Key
- 자연키(prd_nm 등)가 불안정하면 정수 surrogate key를 부여. 단 후니는 **MES_ITEM_CD가 전부 NULL → JOIN KEY = prd_nm(상품명) only**(메모리 `railway-db-access` 확정). 따라서 정합대조의 자연키는 prd_nm이며, 동명이품·공백·표기 흔들림이 MISSING/EXTRA 오탐의 1차 원인이 되므로 **정규화(trim·전각/반각·공백)된 prd_nm 키**로 대조해야 한다.

### 2.4 이행종속·부분종속 잔존 점검
- 정규화 변환이 불완전하면 부분종속(복합키 일부에만 종속)·이행종속이 남아 디멘션에 비정규 잔재가 생긴다.
- **후니 적용:** 9속성 각각이 올바른 테이블(t_prd_product_*, t_siz_*, t_mat_*, t_proc_*)에 "그 속성의 결정자 단위"로 적재됐는지 본다. 예: 공정 별색이 clr가 아니라 PROC(공정)로 분리됐는지(메모리 `dbmap-round3-mapping-audit`의 "별색=공정분기" 교훈), 판형이 의미축(전지 vs 작업사이즈)으로 올바로 분리됐는지.

### 2.5 변환 단계 자체를 검증 산출물로
- ETL 모범사례는 "변환 전 정규화 → 변환 → 검증"을 권한다. 후니 정합검증은 **엑셀을 기대행으로 변환하는 코드/규칙**을 명시 산출물로 남겨야 한다(B 규칙사전 = 이 변환규칙의 사전). 검증 결과의 신뢰성은 이 변환규칙의 정직성에 달려 있다.

---

## ③ DB 오염 방지 체크리스트

정규화 적재 시 흔한 오류 + 후니 점검 항목. 정합검증의 무결성 게이트(값 대조 이전 선행)로 사용.

- [ ] **NOT NULL 위반 / 침묵 빈값:** 필수 컬럼에 빈값·공백이 침묵 적재되지 않았는가. (위젯 하네스 메모리의 "빈값 침묵 PRICE=0" 교훈 — 빈값은 결함 신호로 취급)
- [ ] **FK / Relationships 무결성:** 자식 행(t_prd_product_*)의 모든 코드값이 부모 디멘션(t_*_codes)에 존재하는가. 고아 FK = EXTRA 의심.
- [ ] **UNIQUE / 중복:** 자연키 UNIQUE 제약 또는 (prd_nm + 속성) 조합 중복이 없는가. dedup 누락은 count는 부풀리고 set대조에서 EXTRA로 드러난다.
- [ ] **CHECK / 도메인(accepted_values):** 코드값이 허용 코드 도메인(t_cod_base_codes) 안에 드는가. 오타·이형 코드는 MISMATCH의 숨은 원인.
- [ ] **정규화 깨짐(부분/이행종속):** §2.4 점검. 디멘션에 비정규 잔재가 없는가.
- [ ] **코드값 불일치:** 엑셀 텍스트→코드 lookup이 양방향 1:1인가(미매핑·다대일 붕괴 없는가).
- [ ] **타입·자릿수 변환 손실:** numeric 정밀도(할인율 numeric(5,2) 등)·날짜 포맷(apply_ymd `yyyy-MM-dd`)·문자 인코딩 truncation 없는가.
- [ ] **[HARD] 역적재 금지(no reverse load):** 정규화 결과를 엑셀 비정규 원천으로 되돌리거나, 엑셀 셀값으로 DB를 덮어쓰지 말 것. 손실/오염을 부른다. 불일치 처방은 재변환 설계.

---

## ④ Reconciliation / 정합검증 패턴 (기대행 생성 + 집합대조 중심)

핵심 원리: **단순 값 비교가 아니라, 비즈니스 변환규칙으로 엑셀에서 "기대행(expected rows)"을 산출한 뒤 DB 적재행(actual rows)과 집합대조한다.** source-to-target 매핑 검증의 정석.

### 4.1 기대행(expected rows) 생성
1. 엑셀 원천을 §2 패턴(unpivot/split/lookup)으로 정규화하여 **DB와 동일한 그레인(grain)·동일한 코드값 공간**의 행 집합으로 변환.
2. 이 변환은 B 규칙사전의 변환규칙으로 코드화 — "엑셀 셀 X → 기대행 (prd_nm, 코드값, 속성값)".
3. 결과 = `expected_<속성>` 행 집합. (DB를 건드리지 않고 CSV로 산출)

### 4.2 3계층 대조 (얕은→깊은)
- **L1 Count 대조:** expected 건수 vs actual(DB) 건수. 빠른 1차 스크리닝이지만 **중복+누락이 상쇄되면 통과하므로 단독 신뢰 금지**.
- **L2 Set 대조(자연키):** prd_nm(정규화) ⊕ 속성 자연키로 집합 차집합 계산.
  - `expected − actual` = **MISSING** (엑셀엔 있는데 DB에 안 들어감 — 1차에서 놓친 누락 유형)
  - `actual − expected` = **EXTRA** (DB에만 있음 — 잉여·중복·과적재·고아)
- **L3 Value 대조(필드):** 교집합 키에 대해 비교 대상 필드를 field-for-field 대조 → 일치=**MATCH**, 불일치=**MISMATCH**.
- (보조) **집계 대조:** sum/min/max/mean/distinct_count match — 대량 속성에서 빠른 무결성 확인(DQOps 표준 5+1 메트릭).

### 4.3 4분류 결과 스키마 (9속성 공통)
| 분류 | 의미 | 우선 처방 |
|------|------|-----------|
| MATCH | 기대행=적재행 | 없음 |
| MISSING | expected에 있고 actual에 없음 | 변환규칙 누락 or 적재 결손 — 재적재 설계 |
| EXTRA | actual에 있고 expected에 없음 | 과적재·중복·고아 — 원인(dedup/FK) 추적 |
| MISMATCH | 키는 매칭, 필드값 불일치 | 변환·타입·코드매핑 오류 |

- **[원칙] EXTRA를 "엑셀에 없으니 잉여"로 단정 금지.** 1차 결함의 본질은 "엑셀 셀을 기대집합으로 오판" → 정규화/캐스케이드로 생성되는 정당한 파생행을 EXTRA로 오탐한 것. EXTRA가 나오면 **변환규칙이 그 행을 산출했어야 하는지 먼저 재검토**(규칙 누락 가능성)한 뒤 잉여로 분류.

### 4.4 자연키·정규화 주의
- prd_nm only JOIN이므로 키 정규화(trim, 공백, 전각/반각, 괄호표기) 필수. 키 노이즈가 MISSING/EXTRA를 동시 양산(상쇄 위험).
- **추출본 stale 주의(권위반전):** 등록/NULL/존재 판정은 라이브 DB가 권위(메모리 `dbmap-no-db-load-file-first`). 단 본 round-3 정책상 라이브 반복조회는 최소화하고 추출 스냅샷으로 작업하되, 결정적 존재판정은 스냅샷 신선도를 기록할 것.

---

## ⑤ 표본 → 규칙 → 전수 + 오버피팅 방지

### 5.1 3단계 전략
1. **표본(sample):** 대표 상품 소수로 "엑셀 셀 → 기대행" 변환규칙을 도출. 표본은 *대표성*(다양한 옵션 캐스케이드·공정분기·ragged 패턴 포함)이 핵심이며 편향 없는 선정 필요.
2. **규칙코드화(rule):** 도출 규칙을 B 규칙사전에 명시 코드화. "이 패턴의 셀은 이렇게 N행으로 펼친다" 식의 결정적 규칙.
3. **전수적용(full population):** 규칙을 마스터 디멘션 테이블 전체(전 상품·전 코드)에 돌려 expected를 생성하고 4.3 대조를 전수 실행.

### 5.2 오버피팅 방지 (핵심)
- **독립·전수 검증:** ML 검증의 holdout 원리와 동형 — 규칙을 도출한 표본이 아닌 **나머지 전체 모집단**에서 규칙이 작동하는지 본다. 표본에만 맞고 전수에서 MISSING/EXTRA가 폭증하면 그 규칙은 표본에 과적합된 것.
- **표본 재사용 경계:** 같은 표본으로 규칙을 반복 튜닝하면 표본에 과적합(holdout reuse 함정). 규칙 수정 후에는 **표본 밖 디멘션**에서 재검증.
- **대표성·완전성 점검:** 표본이 모집단의 패턴 다양성을 포괄하는지(특수 공정·예외 옵션·ragged 극단 케이스 포함). 미포함 패턴은 전수에서 새 MISSING/EXTRA 군집으로 드러나며, 이때 규칙을 일반화 보강(특수처리 추가가 아니라 규칙 일반성 확장).
- **규칙 일반성 기준:** "이 규칙이 왜 전 상품에 성립하는가"를 디멘션 구조(결정자)로 설명할 수 있어야 한다. 설명 못 하면 표본 특수 케이스를 일반규칙으로 착각한 것.

---

## ⑥ 후니 9속성 정합검증 적용 권고 (B·C 참조용)

대상 9속성: 사이즈·자재·인쇄옵션·공정·공정택일그룹·판형사이즈·묶음수·페이지룰·추가상품 → t_prd_* / t_siz_* / t_mat_* / t_proc_* 등.

### 6.1 공통 파이프라인 (속성별 동일 적용)
```
엑셀 원천 시트
  → [§2 변환] unpivot/split + lookup(텍스트→코드) + 키 정규화(prd_nm)
  → expected_<속성> 행집합 (CSV, DB 무변경)
  → [§3 무결성 게이트] not_null/unique/accepted_values/relationships 선행
  → [§4.2 3계층 대조] count → set(MISSING/EXTRA) → value(MISMATCH)
  → 4분류 결과 CSV + 대시보드
```

### 6.2 속성별 변환규칙 주의 (B 규칙사전이 코드화할 지점)
- **사이즈(t_siz_sizes):** 한 셀 다중 사이즈 split. 치수는 라이브가 이미 77/77 NOT NULL(메모리 — ref CSV stale)이므로 치수 대조는 라이브 권위, split 누락만 본다.
- **자재(t_mat_*):** 엑셀 "별도설정 = 출력소재 IMPORT가 실자재"라는 간접참조(메모리 `dbmap-round3` 교훈) → 표면 텍스트가 아닌 IMPORT 해소 후의 실자재를 기대행으로 산출.
- **인쇄옵션 / 공정(t_proc_*):** **별색은 clr가 아니라 PROC(공정) 축**(확정 규칙). 1건의 엑셀 항목이 2속성(자재+공정) 동시 산출 가능 → 변환규칙이 분기 산출하도록 코드화.
- **공정택일그룹:** 엑셀에 원천 명시가 부재(메모리 교훈) → 기대행을 무엇으로 산출할지 B에서 권위 소스 먼저 확정(추측 금지). 권위 부재 시 검증 보류·플래그.
- **판형사이즈:** 의미축 분리(전지 vs 작업사이즈) — split이 아니라 축 해석. MISMATCH 잦을 지점.
- **묶음수(bdl_qty):** DB 4행 vs 정정 18행 → **MISSING 확증 예상**(메모리 신호). 장수→bdl_qty 차원분리 규칙 적용.
- **페이지룰 / 추가상품:** ragged 가변 구조 — unpivot 후 상품 연결(t_prd_*).

### 6.3 실행 순서 (C 전수설계 권고)
1. **기초데이터순(디멘션 먼저):** 사이즈·자재·공정 등 마스터 디멘션의 코드값 무결성을 먼저 전수 검증(FK 기준 확립) → 그 다음 상품-연결(t_prd_product_*) 정합.
2. **속성별 incremental:** 한 속성씩 expected 생성→대조→4분류, 속성 간 독립 산출(파일 충돌 방지).
3. **종합 대시보드:** 9속성 × 4분류 매트릭스 + MISSING/EXTRA/MISMATCH 핫스팟. 1차 대비 "상쇄형 누락이 잡히는가"를 회귀 기준으로.
4. **[HARD] read-only · DB 무변경.** 산출은 expected/대조결과 CSV + md만. 라이브 반복조회 최소화.

---

## ⑦ 출처 (Sources)

- [Transforming Denormalized Data with SQL Unpivot — CertLibrary](https://www.certlibrary.com/blog/transforming-denormalized-data-with-sql-unpivot/)
- [What role does normalization/denormalization play in ETL transformations — Milvus](https://milvus.io/ai-quick-reference/what-role-does-normalization-or-denormalization-play-in-etl-transformations)
- [Data Normalization for Data Quality & ETL Optimization — Integrate.io](https://www.integrate.io/blog/data-normalization/)
- [How to Reconcile Data with Table Comparison Checks — DQOps](https://dqops.com/docs/categories-of-data-quality-checks/how-to-reconcile-data-and-detect-differences/)
- [Data Reconciliation Best Practices with DataOps Suite ETL Validator — Datagaps](https://www.datagaps.com/blog/data-reconciliation-best-practices/)
- [What is ETL Testing: Concepts, Types, Examples & Scenarios — iceDQ](https://icedq.com/etl-testing)
- [Data Validation in ETL — 2026 Guide — Integrate.io](https://www.integrate.io/blog/data-validation-etl/)
- [dbt Tests and Data Quality Checks — Conduktor](https://www.conduktor.io/glossary/dbt-tests-and-data-quality-checks)
- [Validate data integrity with GX — Great Expectations](https://docs.greatexpectations.io/docs/reference/learn/data_quality_use_cases/integrity/)
- [5 essential data quality checks for analytics — dbt Labs](https://www.getdbt.com/blog/data-quality-checks)
- [The importance of choosing a proper validation strategy (avoiding overfitting) — ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0003267025012322)
- [Generalization in Adaptive Data Analysis and Holdout Reuse — arXiv](https://arxiv.org/pdf/1506.02629)
