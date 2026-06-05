# round-3 L2 정합 재검증 v2 — 종합 대시보드 (9속성 전수)

작성 2026-06-05 · **기준 = DB 정규화 규칙(B 28규칙)이 산출한 expected rows**(엑셀 단순집합대조 폐기).
expected는 `04_audit/v2/scripts/audit_v2.py`로 재현 산출(날조·dead link 없음). DB read-only(추출본 2026-06-04 + BLOCK-2 라이브 1회).
1차(`04_audit/*-parity.md`)는 보존, 본 v2는 독립 재산출. 분모 = 공통 245상품(`00_master-parity.md`).

---

## §1 9속성 정합 대시보드 (v2)

| # | 속성 | DB행 | MATCH | MISSING | EXTRA | MISMATCH | 판정 | 1차 대비 변동 |
|---|------|:----:|:-----:|:-------:|:-----:|:--------:|------|-------------|
| 1 | 사이즈 size | 444 | 415 | 31(진짜3) | 21 | 0 | **GO**(조건부) | 치수브리지로 false 83 제거. 진짜=A1 3건(1차 동일) |
| 2 | 자재 material | 406 | 209 | 40 | 266 | 0 | **MAJOR** | 표기차정규화로 MATCH 121→209. 명칭약어·IMPORT 잔여 |
| 3 | 인쇄옵션 print_option | 172 | 109 | 3 | 63 | 0 | **GO** | 별색 공정분기 유지. MISSING 1→3(캘린더 양면) |
| 4 | 공정 process | 196 | 156 | 48 | 40 | 0 | **MAJOR** | 박/형압 부모 false 제거·코팅 false EXTRA 제거·형압자식 6 신규 |
| 5 | 공정택일그룹 process_select_group | 13 | N/A | N/A | N/A | N/A | **N/A 보류** | 엑셀 원천 부재(BLOCK-3). 추론대조 금지 |
| 6 | 판형사이즈 plate_size | 509 | 보류 | 보류 | 보류 | 보류 | **CONDITIONAL** | 의미축 상이(전지↔작업사이즈). set 자동대조 보류 |
| 7 | 묶음수 bundle_qty | 4 | 0 | 다수 | 1 | 0 | **MAJOR** | DB 2상품뿐. 엑셀 의미 미확정 |
| 8 | 페이지룰 page_rule | 11 | 11 | 0 | 0 | 0 | **GO** | 11/11 완전정합 |
| 9 | 추가상품 addl_product | 34 | 19 | 11 | 0 | 0 | **MAJOR** | 실addon 7 미적재·brittle 매칭 |

> MATCH/MISSING/EXTRA는 행 단위. 상품(prd_nm) 단위는 각 `*-parity-v2.md` 참조.
> 자동 expected 산출 4속성(size·material·process·print_option)만 v2 코드 재산출. 나머지 5속성은 1차 판정 재확인(자동산출 불가/보류).

---

## §2 회귀 게이트 — **PASS** (상세 `regression-gate.md`)

| 지표 | 결과 |
|------|------|
| **R-PROC-2 줄수/개수 MISSING** | **32건 ≥ 6 → PASS** |
| 프리미엄엽서 4공정(29/30/31/32) | 검출 (1차 결함 재현·해소) |
| 프리미엄명함 2공정(31/32) | 검출 |
| digital-print 한정 적용 | 확인(sticker 빈컬럼 거짓신호 0) |
| 별색 교차(공정↔인쇄옵션 동일근원) | PROC_000008/009 확인 |

**1차 핵심 결함(상쇄형 누락 은폐)이 v2 규칙 코드화로 구조적 재발 불가**임을 expected 재현으로 기계 보증.

---

## §3 1차 판정 정정 사항 (거짓 정합·거짓 MISSING 적발)

| # | 1차 | v2 정정 | 근거 |
|---|-----|---------|------|
| 1 | size MISSING 3(A1만) | **진짜는 동일 3건**이나 siz_cd 직접대조 시 false 83건 발생 확인 | 동일 cut치수 복수 siz_cd 30그룹 → 치수브리지 필수 |
| 2 | process 박/형압 MISSING(부모 매칭) | **false MISSING 12건 철회** | 부모 미적재 규칙(자식 leaf만 적재) |
| 3 | process 코팅 | **false EXTRA 43건 철회** | `무광코팅(단면)`→PROC_000015 표기 정규화 |
| 4 | process 형압 | **형압자식 051/052 6건 신규 진짜 MISSING** | 부모규칙 보정으로 자식 결손 노출 |
| 5 | 별색공정 MISSING 9 | **2건으로 축소(CONFIRM 7)** | 시트·컨텍스트 게이트(과대검출 정정) |
| 6 | material EXTRA 60 | **표기차 정규화로 MATCH 다수 전환**(스타드림 등) | mat_nm 공백·`g` 정규화 |

> 거짓 정합(마스터 깨진 채 연결만 맞음) 위험 없음 — 마스터 계층 건전 재확인(1차 동일).

---

## §4 숨김/미출시 비활성 분류 (MISSING 아님)

| 신호 | 건수 | 처리 |
|------|:---:|------|
| 그레이밴딩(품절/준비중) 셀 | **3193셀**(전량 goods-pouch 시트) | **비활성(미출시)** 분류 — MISSING 집계 제외 |
| unresolved 상품(ref 미등록) | **7상품** | 모집단 외 — 정합 위반 아님 |

- 비활성 셀 3193 전부 굿즈파우치 시트 집중 = 굿즈파우치 다수 옵션 품절/준비중. L1 메타 `fill_meaning='품절/준비중'` 보존.
- unresolved 7: `링바인더(보류중)`·`버즈케이스★`·`에어팟케이스★`·`투명포스터★`·`블랙젤리`·`슬림하드 폰케이스`·`임팩트 젤하드`. ★보류/신규 → DB 미등록은 정합 위반 아님(별도 모집단).

---

## §5 N/A 보류 · CONFIRM 잔여

| 항목 | 상태 | 사유 |
|------|------|------|
| 공정택일그룹(BLOCK-3) | **N/A 보류** | 엑셀 원천 부재. 추론 자동대조 금지. DB 13행 내부정합만 |
| 판형사이즈 | **CONDITIONAL** | 의미축 상이(전지↔작업사이즈 매핑표 확정 전 자동대조 보류) |
| 별색공정 7건 | **CONFIRM** | 시트·컨텍스트 적격성 재확인 후 MISSING 단정 |
| material 명칭약어 | **CONFIRM** | `백모조`=`백색모조지` 약어 표준화 필요(과적합 방지 미자동화) |
| process EXTRA 40 다축혼재 | **CONFIRM** | 실사 봉제/족자·아크릴 부자재·캘린더 거치대 — 공정 vs 자재 vs 추가축 확정 |
| 형압명함 IMPORT 차용(BLOCK-1) | **CONFIRM** | 프리미엄명함 종이세트 차용 여부 |
| PUR책자 종이세트(BLOCK-1) | **CONFIRM** | 무선/중철 차용 여부 |

---

## §6 v2 종합 판정

**마스터 건전 · 상품별 연결 적재결손(MAJOR 3) — 1차 골격 유지하되 false 다수 정정.**

- **자동산출 4속성**: GO 2(size 조건부·print_option) / MAJOR 2(material·process).
- **잔여 5속성**: GO 1(page_rule) / MAJOR 2(bundle_qty·addl_product) / CONDITIONAL 1(plate_size) / N/A 1(process_select_group).
- **회귀게이트 PASS**: 1차 결함(프리미엄엽서 4공정 누락) 재발 0. R-PROC-2 32건 기계 검출.
- **v2 핵심 기여**: ① 치수브리지로 size false 83 제거 ② 부모규칙으로 process false MISSING 12 제거 ③ 코팅 표기로 false EXTRA 43 제거 ④ 형압자식 6 신규 진짜 MISSING ⑤ material 표기차 정규화로 MATCH +88.
- **결론**: DB↔엑셀 매핑은 **구조적으로 건전**, 상품별 옵션 적재 미완(MAJOR). **정정·적재는 별도 단계 — 본 하네스 DB 미적재 유지.**

**산출 색인**: `regression-gate.md` · `{size,process,material,print_option}-parity-v2.md` · `small-attrs-parity-v2.md` · 각 `*-mismatches-v2.csv` · `expected/*.csv` · `scripts/{common.py,audit_v2.py}`.
