# E. 엑셀 무손실 추출 베스트프랙티스 — 이질적 다시트 비정규화 Excel을 누락 0으로 추출하는 방법론

> **이 문서가 답하는 실제 사건**: 후니프린팅 상품마스터 엑셀(13시트, 시트마다 컬럼 구조 상이)을 1차 추출할 때 **속성별 단일 컬럼만 평면화**(사이즈 속성=E컬럼 '사이즈명'만 파이프 join)하여 같은 행의 I열(작업사이즈)·J열(재단사이즈)를 버렸다. 그 결과 **행 내 관계(row-level context)** 가 소실되어 "사이즈명 A1은 있는데 작업사이즈는 공백"이라는 정보가 사라졌고, 다운스트림 매핑이 작업사이즈 없는 표시용 사이즈를 실사이즈로 오인 → **false MISSING** 오판이 발생했다.
>
> 본 문서는 "시트마다 다른 컬럼을 동일 기준으로 가져오면 또 누락된다"는 우려에 대한 업계 베스트프랙티스를 조사해, 후니 13시트 추출의 실행 권고로 정리한다.

---

## ① 요약 — 후니 적용 핵심 권고

이번 사건의 근본 원인은 **"추출 단계에서 해석을 먼저 해버린 것"**이다. "사이즈 속성은 사이즈명만 중요하다"는 해석을 추출 시점에 적용해, 그 해석에 안 맞는 컬럼(작업사이즈/재단사이즈)을 조용히 버렸다. 베스트프랙티스의 핵심 처방은 다음과 같다.

1. **추출(extract)과 해석(interpret)을 물리적으로 분리하라.** 1단계는 "어떤 셀도 조용히 버리지 않는" 무손실 충실 추출(전 컬럼 보존), 2단계가 매핑/정규화. 이번 사건은 두 단계가 뒤섞여 발생했다.
2. **고정 스키마(fixed schema)를 13시트 전체에 적용하지 마라.** 시트마다 컬럼이 다르므로 "사이즈명만 뽑는" 류의 단일 가정은 시트 특이 컬럼을 반드시 놓친다. **schema-on-read + 시트별 컬럼 맵 명시**가 정답.
3. **빈 셀도 의미를 보존하라(공백 ≠ 없음).** "작업사이즈가 공백"이라는 사실 자체가 다운스트림에 필요한 정보였다. 빈 셀을 drop하지 말고 명시적 빈값(empty string sentinel)으로 보존.
4. **추출 완전성을 사람 눈이 아니라 기계로 증명하라.** 셀 카운트 대조, non-empty 보존율, 컬럼 커버리지, round-trip diff로 "누락 0"을 자동 보증.
5. **머지셀·2행헤더·세로리스트(ragged)는 추출 단계에서 명시 규칙으로 펼쳐라(forward-fill).** 시각적 구조를 분석 가능한 행 구조로 무손실 변환하되, 펼침이 일어났다는 사실을 기록.

> **F(구조파악)·G(기준서)에게**: F는 13시트 각각의 **시트별 컬럼 맵**(시트→컬럼명→의미축)을 만들어야 하고, G는 그 맵을 근거로 "전 컬럼 무손실 덤프 + 행 단위 보존 + 완전성 검증 게이트"를 기준서로 명문화해야 한다. 단일 평면화 규칙은 금지한다.

---

## ② 고정 스키마(fixed schema)의 위험 vs 시트별 적응 추출(schema-on-read)

### 고정 스키마 추출의 위험

전통적 ETL 도구(예: SAP Data Services 멀티시트 추출)는 **"모든 워크시트가 동일 스키마를 가져야 한다"**는 제약을 전제로 한다. 후니처럼 시트마다 컬럼이 제각각인 데이터에 이 전제를 적용하면, "공통 컬럼"만 추출 대상이 되고 시트 특이 컬럼은 정의상 누락된다. 이번 사건이 정확히 이 패턴이다 — "사이즈명"이라는 공통 가정을 13시트에 강제하니, 그 가정에 없던 작업사이즈/재단사이즈가 탈락했다.

고정 스키마는 **데이터가 입력 시점에 미리 정의된 타입으로 들어오는 정형 데이터**에 적합하다(cost-based 최적화 가능). 그러나 **이질적/비정규화 다시트 Excel은 정형 데이터가 아니다** — 시트별로 "관찰 단위"와 "변수 집합"이 다르다.

### 시트별 적응 추출 (권고)

업계 권고는 **schema-on-read**: 구조를 추출 시점에 강제하지 않고, 읽을 때(또는 해석 단계에서) 구조를 부여한다. 유연성을 속도와 맞바꾸지만, **이질적·비정규화 소스에 적합**하다.

학술 영역에서도 **schema-driven information extraction from heterogeneous tables**(ACL Findings 2024)는 "사람이 작성한 스키마를 따라 다양한 형식·도메인의 표 데이터를 구조화 레코드로 변환"하는 접근을 제시한다. 핵심은 **스키마를 추출 로직에 하드코딩하지 않고 외부에 명시적으로 선언**한다는 점이다.

후니에 적용하면 두 가지 실행 선택지가 있고, **둘을 결합**하는 것이 최선이다.

- **(A) 시트별 컬럼 맵 명시**: 13시트 각각에 대해 "이 시트의 컬럼 X = 의미축 Y" 매핑을 명시 선언(코드 밖 데이터로). 사이즈 시트면 `{E: 사이즈명, I: 작업사이즈, J: 재단사이즈, ...}` 전부 열거.
- **(B) 전 컬럼 무손실 덤프 후 해석(2단 분리)**: 1단계는 시트의 **모든** 컬럼을 그대로 떠서 보존(아무 해석 없음), 2단계에서 (A)의 맵으로 의미 부여. ← **권장 베이스라인.** 컬럼 맵에 실수로 누락이 있어도 원본 덤프에 데이터가 살아있어 복구 가능.

**금지 안티패턴**: 추출 함수 안에 "사이즈는 E컬럼만" 같은 의미 가정을 박아넣기. 이것이 이번 false MISSING의 직접 원인이다.

---

## ③ 무손실 추출 원칙(lossless / faithful extraction)

대원칙: **"어떤 셀도 조용히 버리지 않는다(no cell is silently dropped)."** 추출 산출물은 원본의 모든 행·모든 컬럼·모든 비어있지 않은 값을 보존해야 하며, 버릴 거면 명시적으로 기록해야 한다.

### 3-1. 행 구조 보존 (row-level context)

값을 컬럼별로 분리·평면화하면 **같은 행에 속한다는 관계**가 깨진다. 이번 사건의 핵심 손실이 바로 이것. 추출은 **행 단위(record)** 로 보존해야 한다 — "사이즈명 A1 / 작업사이즈 (공백) / 재단사이즈 (공백)"이 한 레코드로 함께 살아있어야, 다운스트림이 "이 사이즈는 작업치수가 없다"를 판단할 수 있다.

- **권고 산출 형태**: 시트당 1개의 행 보존 테이블(CSV/JSON-lines). 1행 = 원본 1행, 모든 컬럼 = 별도 필드. 속성별로 파이프 join하지 말 것.

### 3-2. 빈 셀 의미 보존 (공백 ≠ 없음)

빈 셀은 "값이 없다"가 아니라 **"이 행에서 이 변수는 비어있다"**는 정보다. drop하면 행 길이가 줄고 컬럼 정렬이 어긋난다. 빈 셀은 **명시적 빈값(empty string `""` 또는 명시적 null sentinel)** 으로 보존하라. 후니 사건에서 "작업사이즈=공백" 자체가 다운스트림 판단의 근거였으므로, 이는 필수 규칙이다.

### 3-3. 머지셀(merged cells) 처리

엑셀의 머지셀은 **좌상단 셀에만 값이 있고 나머지는 비어있다.** 단순 추출하면 머지 범위의 두 번째 셀부터 전부 공백이 되어 데이터가 "사라진 것처럼" 보인다.

- **개념 패턴**: 추출 단계에서 머지 범위를 감지(openpyxl `worksheet.merged_cells.ranges`)하여, 머지 범위 전체에 좌상단 값을 **채워 펼친다(unmerge-and-fill)**. pandas만으로 부족할 때 openpyxl로 머지 좌표를 직접 읽어 DataFrame 좌표로 변환 후 값 전파.
- **권고**: 머지 펼침이 적용된 셀은 "원본은 머지였다"는 사실을 메타로 남기면 round-trip 검증이 정확해진다(선택).

### 3-4. 2행 헤더 / 그룹 헤더(multi-row / grouped header)

상위 헤더(그룹명) + 하위 헤더(세부 컬럼)의 2단 구조는, 단순히 "1행을 헤더로" 읽으면 하위 컬럼 의미가 소실되거나 컬럼명이 중복(`Unnamed`)된다.

- **개념 패턴**: 헤더 행 범위를 명시 지정(pandas `header=[0,1]` 멀티인덱스) 후, **상위 헤더를 하위로 forward-fill**하여 `상위_하위` 형태의 평탄한 단일 컬럼명으로 합성. 머지된 상위 헤더는 3-3과 동일하게 펼친다.
- **후니 적용**: F가 시트별로 "헤더가 몇 행인지"를 먼저 판정해야 한다. 시트마다 헤더 행 수가 다를 수 있다(고정 가정 금지).

### 3-5. 세로 리스트 / ragged column (forward-fill)

한 상품 블록의 첫 행에만 상품명·카테고리가 있고 이어지는 옵션 행들은 공백인 "비주얼 그룹핑" 구조. 추출 시 채우지 않으면 옵션 행이 어느 상품 소속인지 잃는다.

- **개념 패턴**: 그룹 키 컬럼(상품명/카테고리 등)에 한해 **명시적 forward-fill(`ffill`)** 로 하위 행에 전파. 단, **ffill 대상 컬럼을 명시 화이트리스트로 한정**하라 — 전 컬럼 무차별 ffill은 진짜 빈값까지 덮어써 거짓 데이터를 만든다(3-2 위반).
- **주의**: ffill은 추출(충실)이 아니라 이미 가벼운 해석이다. 따라서 **2단 분리상 "해석 직전"** 위치에 두고, 어느 컬럼을 왜 ffill했는지 기록한다.

---

## ④ 완전성 검증 기법 — "누락 0"을 기계로 보증

사람이 13시트를 일일이 눈으로 대조하는 것은 불가능하고 신뢰할 수 없다. 추출이 원본과 일치함을 **기계적으로** 증명해야 한다. ETL 데이터 reconciliation의 표준 기법을 추출 검증에 그대로 적용한다.

### 4-1. 셀/행/컬럼 카운트 대조 (count reconciliation)
- **행 카운트**: 원본 시트 행 수 == 추출 레코드 수 (머지 펼침·ffill로 행이 늘거나 줄지 않았는지). 손실·중복을 1차로 잡는다.
- **컬럼 커버리지**: 원본 시트 컬럼 수 == 추출 필드 수. "사이즈명만 뽑고 9개 버림" 같은 사건은 이 체크 하나로 즉시 적발된다. ← **이번 사건의 직접 방어선.**
- **비어있지 않은 셀(non-empty) 카운트**: 원본 시트의 non-empty 셀 총수 == 추출본 non-empty 값 총수(머지 펼침분은 보정). **non-empty 보존율 100%** 가 무손실의 핵심 지표.

> 주의: 카운트 일치만으로는 부족하다(개별 레코드 오류를 놓침). 카운트는 **빠른 1차 게이트**로 쓰고, 아래 4-2/4-3과 병행한다.

### 4-2. 값/체크섬 대조 (value & checksum)
- **체크섬/해시**: 원본 셀 값 집합과 추출 값 집합 각각에 해시(MD5/SHA-256)를 생성해 비교. 내용이 의도치 않게 변경(타입 강제변환, 공백 trim, 숫자 반올림)됐는지 탐지.
- **필드 단위 값 대조(field-by-field)**: 핵심 시트는 셀 값을 1:1 대조. 전수가 부담되면 **랜덤 샘플링(~1%)** 으로 차이의 크기를 추정.

### 4-3. Round-trip(추출→재구성→원본 diff)
추출본으로 원본 시트를 재구성(reconstruct)해 원본과 diff. diff가 0이면 **완전 무손실이 형식적으로 증명**된다. 머지/ffill은 메타로 기록해두면 정확한 재구성이 가능하다. 가장 강한 보증이며, 핵심 시트(사이즈·자재 등 false MISSING 위험 큰 축)에 우선 적용 권장.

### 4-4. 스키마/제약 체크
- non-empty 기대 컬럼이 전부 채워졌는지(completeness), 데이터 타입·포맷이 기대대로인지, 중복 키가 없는지(uniqueness). 추출 스테이지에 "선언적 검증 규칙"(Great Expectations / dbt test 류의 사고방식)을 둔다.

### 4-5. 권고 — 후니 추출 완전성 게이트 (자동)
시트별로 다음을 자동 산출해 PASS/FAIL을 판정:
- `row_count_match`, `column_count_match`, `nonempty_cell_preservation == 100%`
- `value_checksum_match`(또는 1% 샘플 diff = 0)
- `roundtrip_diff == 0`(핵심 시트)
하나라도 FAIL이면 추출 산출을 **다운스트림 매핑에 넘기지 않는다.**

---

## ⑤ extract ↔ interpret 2단 분리 원칙

이번 사건의 본질은 **추출(extract)과 해석(interpret)의 경계 붕괴**다. 두 단계는 책임·실패모드·검증기준이 다르므로 물리적으로 분리해야 한다.

| 구분 | extract (1단계) | interpret / normalize (2단계) |
|------|----------------|------------------------------|
| 목적 | 원본을 **충실히, 무해석**으로 보존 | 매핑·정규화·의미 부여 |
| 산출 | 시트별 행 보존 raw 테이블(전 컬럼) | 9속성 매핑 / DB 정합 입력 |
| 성공 기준 | **누락 0**(완전성 검증 통과) | 의미 정확성(매핑 정합) |
| 허용 연산 | 머지 펼침·헤더 합성·키 ffill(기록 동반) | 컬럼 선택, unpivot, tidy 변환, 코드값 매핑 |
| 금지 | 컬럼 drop, 의미 가정 박기, 빈값 삭제 | 원본 raw 변경 |

**경계를 어디에 긋나**: "이 정보가 다운스트림에 필요한가?"라는 **판단이 들어가는 순간이 interpret**다. 추출은 그 판단을 하지 않는다 — 전부 가져온다. "사이즈 속성은 사이즈명만 필요하다"는 판단은 명백히 interpret이며, 추출 단계에 있어선 안 됐다.

**tidy data / unpivot의 위치**: tidy 변환(각 변수=컬럼, 각 관찰=행, 각 값=셀)과 `pivot_longer`/unpivot는 **interpret(2단계)에 속한다.** Wickham이 지적하듯 "longer가 tidy냐 wider가 tidy냐"는 분석 목적에 따라 달라지는 실용적 판단이므로, 충실 추출의 일이 아니다. 단, raw 보존 테이블은 행 구조를 깨지 않은 상태로 unpivot의 **입력**이 되어야 한다(③-1).

**2단 분리의 안전망**: interpret에서 컬럼 맵 실수로 누락이 생겨도, raw 보존본에 데이터가 살아있으므로 매핑만 고쳐 재실행하면 복구된다. 이번 사건처럼 추출 시점에 버렸다면 원본을 다시 파싱해야 한다.

---

## ⑥ 후니 13시트 적용 권고 (F 구조파악 · G 기준서 참고 지침)

### F(구조파악)가 시트별로 산출할 것 — "시트별 컬럼 맵"
각 시트를 단일 가정으로 보지 말고, 시트마다 다음을 명시 판정:
1. **헤더 행 범위** (1행? 2행 그룹헤더? 시트마다 다를 수 있음 — ③-4)
2. **머지셀 존재 여부 및 위치** (③-3)
3. **세로 리스트/그룹 키 컬럼** (ffill 대상 화이트리스트 — ③-5)
4. **전 컬럼 목록 + 각 컬럼의 의미축** (예: 사이즈 시트 = `사이즈명 / 작업사이즈 / 재단사이즈 / ...` 전부 열거 — ②A). 절대 "대표 컬럼 1개"로 축약하지 말 것.
5. **행의 관찰 단위**(무엇이 1 레코드인가 — 상품? 옵션? 사이즈 항목?)

### G(기준서)가 명문화할 추출 기준 — HARD 규칙
1. **[HARD] 전 컬럼 무손실 덤프 우선** — 시트별 컬럼 맵에 정의된 **모든** 컬럼을 행 단위로 보존. 속성별 단일 컬럼 평면화·파이프 join **금지**(이번 false MISSING의 원인).
2. **[HARD] 행 구조 보존** — 1행 = 1 레코드. 같은 행의 컬럼들은 한 레코드에 함께 유지(작업사이즈/재단사이즈를 사이즈명과 분리하지 말 것).
3. **[HARD] 빈 셀 보존** — 공백 ≠ 없음. drop 금지, 명시적 빈값으로 보존. "작업사이즈=공백"은 유효한 다운스트림 신호.
4. **[HARD] 머지/2행헤더/세로리스트는 명시 규칙으로 펼치되 기록** — 머지 펼침, 헤더 합성, 키 ffill을 적용하고 적용 사실을 메타로 남김. 화이트리스트 외 무차별 ffill 금지.
5. **[HARD] 추출↔해석 2단 분리** — 추출 함수에 "어느 컬럼이 중요한가"류 의미 판단 금지. 의미 부여는 매핑(interpret) 단계로.
6. **[HARD] 완전성 검증 게이트 통과 후에만 다운스트림 전달** — 시트별 `row_count_match` / `column_count_match` / `nonempty_preservation==100%` / (핵심 시트)`roundtrip_diff==0`. 하나라도 FAIL이면 매핑 진입 차단.
7. **[HARD] schema-on-read** — 13시트에 단일 고정 스키마 강제 금지. 시트별 컬럼 맵으로 적응 추출.

### 도구 관점(개념 수준, 실행코드 아님)
- **머지셀**: openpyxl `ws.merged_cells.ranges`로 범위 감지 → 좌상단 값을 범위 전체에 전파(unmerge-and-fill). pandas 단독으로 부족할 때 openpyxl로 좌표 직접 처리(pandas의 엔진이 openpyxl이라 자연스러운 보완).
- **2행 헤더**: pandas `read_excel(header=[0,1])` 멀티인덱스 → 상위 헤더 forward-fill → `상위_하위` 단일 컬럼명 합성.
- **세로 리스트**: 그룹 키 컬럼에 한해 `df[keys].ffill()` (화이트리스트 한정).
- **빈 셀**: `read_excel(..., keep_default_na=...)` / dtype 관리로 빈 셀을 `""`로 명시 보존, NaN 자동 drop 회피.
- **완전성 검증**: 선언적 데이터 검증(Great Expectations / dbt test 사고방식)으로 카운트·non-null·체크섬 규칙을 시트별로 코드화.

---

## ⑦ 출처(Sources)

- [Schema-Driven Information Extraction from Heterogeneous Tables (ACL Findings 2024)](https://aclanthology.org/2024.findings-emnlp.600.pdf)
- [Schema-Driven Information Extraction from Heterogeneous Tables (arXiv preprint PDF)](https://arxiv.org/pdf/2305.14336)
- [Structured vs Unstructured Data — schema-on-read vs fixed schema (Exasol)](https://www.exasol.com/hub/data-warehouse/structured-vs-unstructured-data/)
- [Excel Multi Sheet Extraction — same-schema constraint (SAP Community)](https://community.sap.com/t5/technology-blog-posts-by-members/excel-multi-sheet-extraction/ba-p/13240415)
- [Data Reconciliation: Technical Best Practices (Datafold)](https://www.datafold.com/blog/data-reconciliation-best-practices/)
- [How do you verify the integrity of data after ETL completion? (Milvus)](https://milvus.io/ai-quick-reference/how-do-you-verify-the-integrity-of-data-after-etl-completion)
- [5 Data tidying — R for Data Science (2e), Hadley Wickham](https://r4ds.hadley.nz/data-tidy.html)
- [Tidy Data (Hadley Wickham, original paper PDF)](https://vita.had.co.nz/papers/tidy-data.pdf)
- [Pandas: How to Read Excel File with Merged Cells (Statology)](https://www.statology.org/pandas-read-excel-merged-cells/)
- [openpyxl: dealing with merged cells (GitHub gist)](https://gist.github.com/tchen/01d1d61a985190ff6b71fc14c45f95c9)
- [How to Read Excel File with Merged Cells in Pandas (codepointtech)](https://codepointtech.com/how-to-read-excel-file-with-merged-cells-in-pandas/)
