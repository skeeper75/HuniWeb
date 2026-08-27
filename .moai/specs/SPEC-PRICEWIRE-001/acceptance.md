---
id: SPEC-PRICEWIRE-001
doc: acceptance
version: "0.1.3"
updated: 2026-08-27
status: draft
tier: L
---

# 인수 기준 — SPEC-PRICEWIRE-001

> 형식: `AC-PW-NNN` — Given / When / Then. 모든 항목은 **이진 판정 가능**해야 한다.
> 판정 도구는 기존 자산만 사용한다(신규 판정 알고리즘 mint 금지, REQ-PW-018).
> 각 AC 말미의 `(REQ-PW-NNN)` 는 대응 요구사항이다. 전체 매핑은 §G 를 정본으로 한다.

---

## §A M0 — 기준 재고정

**AC-PW-001** — Given 권위 엑셀 260822_1 2종이 `docs/huni/` 에 존재하고, When 재추출 스크립트를 경로 상수 교체 후 실행하면, Then 260822 기준 추출 캐시 디렉터리가 생성되고 그 매니페스트에 원본 xlsx 2종의 sha256(`f4a3e4ca…c5a9` / `46225a1a…a946`)이 기록되어 있다. (REQ-PW-001, REQ-PW-003)

**AC-PW-002** — Given 재추출 캐시가 생성된 상태에서, When `_workspace` 전수에서 260822 기준 캐시를 조회하면, Then 조회 결과가 1건 이상이며 각 매니페스트의 `source_file` 이 260822_1 파일명을 가리킨다. (REQ-PW-001)

**AC-PW-003** — Given 결함 파일 실측이 필요한 상태에서, When `widget-defects.jsonl` 행수와 승계 문서 수치(404)를 대조하면, Then 15건 차이의 구성(TRUNCATED 분리분 + α)이 항목별로 규명되어 원장에 기재되어 있다(미규명 잔량 0건). (REQ-PW-004)

**AC-PW-004** — Given M0-3 이 완료된 상태에서, When 재산출된 `worklist.csv` 의 라우팅 클래스를 집계하면, Then `auto_data` 가 0건이며 `needs_authority` 건수가 재추출 캐시 기준으로 재계산되어 있다. (REQ-PW-004)

**AC-PW-005** — Given M0 이 미완료인 상태에서, When 작업 로그를 조회하면, Then `needs_authority` 로 분류된 건에 대한 저장(COMMIT) 기록이 0건이다. [HARD 차단 게이트] (REQ-PW-005)

## §B M1~M4 — 배치 교정

**AC-PW-006** — Given M1 대상 목록이 확정된 상태에서, When 각 대상의 교정 기록을 조회하면, Then 모든 건에 (대상 목록 출처 · 화면/엔드포인트 · 절차 · blast_radius)가 표기되어 있다(미표기 0건). **추가로, 할인 바인딩 건은 저장한 「적용 대상」 값(구성요소 코드 또는 `전체 금액`)과 그 값이 도출된 권위 행(「계산공식집초안」 row 번호 또는 권위 `구간할인적용테이블` 셀 값)이 함께 기재되어 있다** — 두 필드 중 하나라도 빠진 할인 바인딩 건이 0건이다. (REQ-PW-015, REQ-PW-023)

**AC-PW-007** — Given 직접단가를 보유한 상품이 있을 때, When 그 상품의 공식 바인딩 부재를 판정하면, Then 결함으로 계상되지 않는다(오탐 57건 재발 0). (REQ-PW-007)

**AC-PW-008** — Given 고아 공식 10건이 있을 때, When 상품↔공식 바인딩을 등록하고 시뮬레이터로 재계산하면, Then 각 건의 `result_sum.PRICE` 가 0 이 아니거나, 0인 경우 그 사유가 (B)/(C) 분류로 기재되어 있다. (REQ-PW-006, REQ-PW-008)

**AC-PW-009** — Given M2 재키 드리프트 교정 대상이 있을 때, When 교정 전후 단가행을 대조하면, Then **단가 값이 변경된 행이 0건**이며 변경분은 코드 컬럼 이관에 한정된다. (REQ-PW-009)

**AC-PW-010** — Given 단가표를 `price_grid_save` 로 저장했을 때, When 저장 전후 해당 구성요소의 `component_prices` 행수를 대조하면, Then **저장 후 행수 ≥ 저장 전 행수**이며 삭제된 자연키가 0건이다. [C8 방어] (REQ-PW-014)

**AC-PW-011** — Given 차원 축 교정이 필요한 건에서, When 교정 결과를 확인하면, Then `use_dims` 체크박스만 변경하고 단가행 컬럼 값을 채우지 않은 건이 0건이다. (REQ-PW-010)

**AC-PW-012** — Given M3 대상(E2 전역 8건 + t4③)이 있을 때, When `wiring_scan.py` 를 실행하면, Then 대상 범위의 `DEAD_WIRE` / `ORPHAN` / `NO_FORMULA` 결함이 0건이거나, 잔존분이 사유와 함께 원장화되어 있다. (REQ-PW-011)

**AC-PW-013** — Given M4 셋트 대상이 있을 때, When 셋트 최종가를 `simulate_set_core` 경로로 재계산하면, Then `result_sum.PRICE` 가 0 이 아니거나 사유가 (B)/(C) 로 분류되어 있다. (REQ-PW-012)

**AC-PW-014** — Given 공유 구성요소(파급 ≥2상품)를 수정했을 때, When 승인 기록을 조회하면, Then 각 저장 건에 blast_radius 표기와 인간 승인 기록이 1:1로 존재한다. (REQ-PW-015, REQ-PW-016)

**AC-PW-015** — Given 교정 산출물 전체에 대해, When "과등록 조사" · "삭제" 시사 문구를 검색하면, Then 일치 0건이다. [HARD] (REQ-PW-017)

## §C M5 — 종료 판정

**AC-PW-016** — Given 게시 분모(위젯 194 / 상품 193)가 확정된 상태에서, When `audit_published_prices.py` 로 전수 점검을 실행하면, Then 점검 대상 수가 194 이며 미점검 0건이다. (REQ-PW-018)

**AC-PW-017** — Given 전량 스윕이 완료된 상태에서, When `verify_zero_quote.py` 결과를 (A)/(B)/(C) 3분류로 집계하면, Then **(A) 진짜 결함 = 0건**이며, (A) 집계의 근거 필드가 전건 `result_sum.PRICE` 이고 per-line `result[].PRICE=0` 을 근거로 계상된 건이 0건이다. **(A) 분자에서 G1 stale 기본값 34건은 제외**하며(`spec.md §2.2` 범위 밖), E1 잔량은 `spec.md §1.2.1` 의 렌즈 B 층 분모로만 센다.
> **(A) 분자에 포함되는 항목 [명시]** — (i) **할인 적용 범위 위반**(REQ-PW-023: 인쇄가공비 외 구성요소를 보유한 공식인데 할인이 총액 스코프로 바인딩된 건) · (ii) **추가상품 템플릿 단가 부재**(REQ-PW-024: `t_prd_template_prices` 행이 없어 `_addons_strict` 가 422 로 막는 템플릿). 종료 시 **(i) = 0건 AND (ii) = 0건** 이어야 한다. (ii) 중 권위 단가 출처가 미확보인 건(트레싱지봉투 4종 · 천정고리)은 `needs_authority` 로 원장화하고 그 사유가 기재된 경우에 한해 잔량으로 계상하되, 사유 없는 잔량은 0건이어야 한다. [종료 조건] (REQ-PW-020, REQ-PW-023, REQ-PW-024)

**AC-PW-018** — Given (B) 정상 미매칭 · (C) 미선택 차원 건이 존재할 때, When 원장을 조회하면, Then 각 건에 분류 사유가 개별 기재되어 있다(사유 없는 건 0). (REQ-PW-019)

**AC-PW-019** — Given TRUNCATED 가 존재하는 상품이 있을 때, When 그 상품의 verdict 를 확인하면, Then `OK` 로 판정된 건이 0건이다. (REQ-PW-021)

**AC-PW-020** — Given `PRD_000165`(게시·`use_yn=N`)에 대해, When 원장을 조회하면, Then 분모와 분리된 별항으로 계상되고 결론(교정 또는 게시중단 권고)이 기재되어 있다. (REQ-PW-019)

**AC-PW-021** — Given 종료 판정을 내릴 때, When 근거 출처를 확인하면, Then 1차 근거가 실호출 결과(`lens_b_runner` / `audit_published_prices` 계열)이고 오프라인 defects/health 는 보조 근거로만 인용된다. (REQ-PW-022)

## §C' 미커버 REQ 보강 (D4)

**AC-PW-022** — Given 재추출 대상 스크립트 4파일(`_scripts/run_extract_master_260703.py` · `run_extract_price_260705.py` · `06_extract/scripts/extract_price_sheets.py` · `run_all.py`)에 대해, When 260822 실행본과 기존본을 `git diff` 로 대조하면, Then 변경 라인이 **경로/EXTRACT 상수 정의부에 한정**되고 추출 로직 함수 본문의 변경이 **0라인**이다. **260822 실행본의 러너는 `_workspace/huni-dbmap/_scripts/run_extract_master_260822.py` · `run_extract_price_260822.py` 2종이며, 상수 정의부 외의 변경은 선언된 비의미 예외 2건(① docstring 갱신 ② ruff `E401` 품질 게이트가 강제한 `import` 한 줄 분리)에 한정된다** — 그 외 변경이 0건이고, 공용 추출기(`06_extract/scripts/*`)의 함수 본문 변경이 0라인이다. (REQ-PW-002)

**AC-PW-023** — Given 「계산공식집초안」에서 `[고정가형]` 으로 분류된 상품군에 대해, When M5 결함 원장을 조회하면, Then 해당 상품군의 공식/구성요소 부재를 결함으로 계상한 건이 **0건**이다. (REQ-PW-013)

**AC-PW-024** — Given 본 SPEC 의 전체 작업 로그에 대해, When 위젯 재게시(`publish_widget`) 실행 기록을 조회하면, Then **일치 0건**이며, 재게시를 요구하는 교정(G1 34건 포함)은 전부 후속 트랙 이월로 원장에 기재되어 있다. (REQ-PW-016)

**AC-PW-025** — Given 종료 판정에 사용된 도구 목록에 대해, When 실행 로그를 조회하면, Then 실행 도구가 `verify_zero_quote.py` · `lens_b_runner.py` · `audit_published_prices.py` **3종 + 라이브 읽기전용 SELECT** 로 한정되고(SELECT 는 REQ-PW-023 저청구 계열의 계측 수단이며 신규 스크립트가 아니다 — REQ-PW-018 참조), 신규 판정 스크립트·심각도 등급 신설이 **0건**이며, SELECT 외 라이브 쓰기(INSERT/UPDATE/DELETE)가 **0건**이다. **또한 권위 부재(`needs_authority`)를 판정한 전건에 대해 REQ-PW-025 의 판독 규약이 적용되어 있다** — 권위 엑셀 2종 **전부**와 「계산공식집초안」 시트를 연 근거가 기재되지 않은 채 내려진 「권위 없음」 판정이 **0건**이며, 1건이라도 존재하면 이 AC 는 FAIL 이다. (REQ-PW-018, REQ-PW-025)

---

## §D Negative Guard — 오탐 방지 16항 [FAIL 조건]

아래 케이스를 **결함으로 재적발하면 `바인딩 AC` 열의 해당 AC 가 FAIL** 이다(research.md §14 승계).

**판정 주체·방법 [D5 해소]** — 판정 주체는 **M5 검증기**(`lens_b_runner` + `verify_zero_quote` + `audit_published_prices` 실호출 결과를 읽는 작업자)다. 방법은: 각 바인딩 AC 를 판정할 때 해당 행의 케이스가 그 AC 의 결함 분자에 계상됐는지 원장에서 조회하고, **1건이라도 계상됐으면 그 AC 를 FAIL** 로 확정한다. 판정 근거(조회 명령·출력)는 원장에 verbatim 기록한다(§E 재현성).

| # | 정상이므로 고치면 안 되는 케이스 | 바인딩 AC |
|---|---|---|
| 1 | 무지 내지의 사이즈 0건 · 판형 0건(`PRD_000302/304/306/308`) — 단 "가격이 없어도 된다"는 뜻은 아님 | AC-PW-017 |
| 2 | `t_siz_sizes.margin_*` NULL(블리드 0) — 단 작업≠재단인데 NULL 인 행은 모순 | AC-PW-017 |
| 3 | 직접단가 보유 상품의 공식 바인딩 없음 | AC-PW-007 |
| 4 | 「계산공식집초안」 `[고정가형]` 상품군의 공식/구성요소 부재 | AC-PW-023 |
| 5 | 셋트 구성원의 공식 부재(정상/결함은 공식 유형이 가름) | AC-PW-013 |
| 6 | (B) 「가족 분담 면제」 — 형제 구성요소가 명시행으로 커버 | AC-PW-018 |
| 7 | (C) 미선택 차원 — 손님이 아직 안 고른 축 | AC-PW-018 |
| 8 | INFO-1 기본값 미지정(`dflt_val` 없음) — 고지만 | AC-PW-017 |
| 9 | `A−B`(등록됐으나 미게시) — 런칭 대기 | AC-PW-016 |
| 10 | 분모 차이(266 vs 194) — 정보 | AC-PW-016 |
| 11 | TRUNCATED(조합 절단) — 커버리지 고지 | AC-PW-019 |
| 12 | `PARENT_DEAD` 대량 — 원본 정책 승계로 WARN, 분모 제외 금지 | AC-PW-016 |
| 13 | 다중 항목 동시 변경 조합 미검사 — 설계상 한계 | AC-PW-021 |
| 14 | E5 0건(판형 자동 도출, 서버 경로 정상) | AC-PW-017 (M0-5 판정 전 계상 보류) |
| 15 | `PRD_000108` 탁상형캘린더 · `PRD_000042` — 렌즈 B 전 조합 정상가 | AC-PW-017 |
| 16 | per-line `result[].PRICE = 0` — 권위는 `result_sum.PRICE` | AC-PW-017 (REQ-PW-020 절) |

---

## §E 품질 게이트

| 게이트 | 기준 |
|---|---|
| 근거성 | 모든 사실 주장에 `파일경로:라인`, 추정은 `[추정]` |
| 판정 무결성 | 신규 판정 알고리즘·심각도 mint 0건 |
| 안전 | 값 삭제 0건 · 라이브 직접 SQL/DDL 실행 0건 |
| 승인 | 저장(COMMIT) 건마다 인간 승인 기록 1:1 |
| 재현성 | 종료 판정에 사용한 명령·인자·출력이 원장에 verbatim 기록 |

## §F Definition of Done

- [ ] M0~M5 전 마일스톤 완료, 각 배치 원장 기재
- [ ] AC-PW-001~025 전건 PASS
- [ ] Negative Guard 16항 재적발 0건(바인딩 AC 기준)
- [ ] 해소 게이트 5건 종결 상태 유지 — 미해소 마커 잔량 0건(`plan.md §B` 결정 기록)
- [ ] G1 34건 = 발견 원장 기재 완료 + 후속 트랙 이월 명시(교정 0건)
- [ ] 할인 적용 범위 위반 3건(`PRD_000147`·`PRD_000149`·`PRD_000154`) 교정 완료 — 「적용 대상」 = `COMP_ACRYL_CLEAR3T`
- [ ] 추가상품 템플릿 단가 부재 6종 처리 완료 — 등록 또는 `needs_authority` 사유 기재
- [ ] 할인표 밴드 값 변경 0건(범위 밖, `spec.md §2.2`)
- [ ] 종료 조건(§C AC-PW-017 (A)=0건) 충족

---

## §G AC ↔ REQ 매핑표 (정본, D3 해소)

| REQ | 커버하는 AC |
|---|---|
| REQ-PW-001 | AC-PW-001 · AC-PW-002 |
| REQ-PW-002 | AC-PW-022 |
| REQ-PW-003 | AC-PW-001 |
| REQ-PW-004 | AC-PW-003 · AC-PW-004 |
| REQ-PW-005 | AC-PW-005 |
| REQ-PW-006 | AC-PW-008 |
| REQ-PW-007 | AC-PW-007 |
| REQ-PW-008 | AC-PW-008 |
| REQ-PW-009 | AC-PW-009 |
| REQ-PW-010 | AC-PW-011 |
| REQ-PW-011 | AC-PW-012 |
| REQ-PW-012 | AC-PW-013 |
| REQ-PW-013 | AC-PW-023 |
| REQ-PW-014 | AC-PW-010 |
| REQ-PW-015 | AC-PW-006 · AC-PW-014 |
| REQ-PW-016 | AC-PW-014 · AC-PW-024 |
| REQ-PW-017 | AC-PW-015 |
| REQ-PW-018 | AC-PW-016 · AC-PW-025 |
| REQ-PW-019 | AC-PW-018 · AC-PW-020 |
| REQ-PW-020 | AC-PW-017 |
| REQ-PW-021 | AC-PW-019 |
| REQ-PW-022 | AC-PW-021 |
| REQ-PW-023 | AC-PW-006 · AC-PW-017 |
| REQ-PW-024 | AC-PW-017 |
| REQ-PW-025 | AC-PW-025 |

**커버리지**: REQ **25건** 전건이 1개 이상의 번호 AC 로 커버된다(미커버 0건). AC **25건** 전건이 1개 이상의 REQ 를 참조한다. **Tier L 예산 준수 — REQ 25 ≤ 상한 25 · AC 25 ≤ 상한 25**(두 상한은 독립 적용). v0.1.2 흡수분(REQ-PW-023/024/025)은 신규 AC 없이 **기존 AC 본문 확장**으로 커버했다 — AC 총량 불변.
