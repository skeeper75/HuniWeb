---
id: SPEC-PRICEWIRE-001
title: "게시 위젯상품 전량 가격 배선 교정 (0원·-원 제거)"
version: "0.1.1"
status: draft
created: 2026-08-27
updated: 2026-08-27
author: 지니
priority: P1
phase: "런칭 런웨이 — 가격 배선 1차"
module: "_workspace/huni-widget-wiring"
lifecycle: spec-anchored
tags: "price, wiring, widget, published, zero-price, webadmin, remediation, umbrella"
tier: L
depends_on: [SPEC-WIDGET-WIRING-001]
---

# SPEC-PRICEWIRE-001 — 게시 위젯상품 전량 가격 배선 교정

> **입력 산출물(정본)**: `.moai/specs/SPEC-PRICEWIRE-001/research.md` (4렌즈 통합 리서치, 506줄).
> 본 SPEC 의 모든 건수·화면매핑·제약·오탐목록·모순(C1~C12)은 research.md 를 근거로 하며 재도출하지 않는다.
> **선행 SPEC**: `SPEC-WIDGET-WIRING-001` (진단, 3-phase closed). 본 SPEC 은 그 산출물을 소비하는 **교정(remediation) 우산 SPEC** 이다.
>
> [HARD] `raw/webadmin/**` 소스코드와 라이브 DB 는 **읽기 전용**. 교정 수단은 webadmin **실화면 조작**이며 이는 별도 층이다(§5.2).
> [HARD] 모든 사실 주장에 `파일경로:라인`. 추정은 `[추정]` 배지. LLM 셀 단위 분석 0.

## 0. 판본 이력 (HISTORY)

| 판본 | 일자 | 변경 |
|---|---|---|
| v0.1.0 | 2026-08-27 | 초판 — 우산 SPEC 신설. 백로그 t2~t8 흡수. M0 기준 재고정 + 결함유형별 6배치 + 검증 스윕 구조 확정 |
| v0.1.1 | 2026-08-27 | plan-audit iteration-1 반영 — REQ-PW-022 GEARS 정형화(D1) · E1 종료 분모 층 확정(D6) · G1 34건 범위 밖 결정 + 재게시 미수행 명시 · REQ-PW-007 `Where`→`While`(D11) · blast_radius 전사 교정(D9) · 의존 필드를 정본 `depends_on` 으로 변경(D12) |

---

## 1. 배경과 분모

### 1.1 목표는 두 층이다

종료 조건 "게시 위젯 전량에서 가격이 0원/-원 없이 나온다" 는 독립된 두 층으로 갈린다(research.md §1).

- **1차 = 배선**: 가격 소스 부재(E1)·공식→구성요소 미배선(E2)·단가행 미도달(E4) → `final=0`.
- **2차 = 정확도**: 판수 환산(E5)·수량 경계(Q1)·셋트 합산(S1) → 0원이 아니라 **저청구**. 돈영향 실측 `undercharge 841 · overcharge 0 · unknown 578 · none 12`(`_workspace/huni-widget-wiring/out/wiring-health-index.json`).

본 SPEC 의 **우선순위 1 = 배선**(값이 나오는 것), **우선순위 2 = 정확도**. 정확도 층은 **검증·원장화 범위로만 포함**하며 그 교정은 후속 SPEC 으로 이월할 수 있다(§2.2). 다만 E5 를 E4 에 흡수하는 것은 금지된다(선행 `SPEC-WIDGET-WIRING-001/spec.md:233-234` [HARD]).

### 1.2 분모 확정 — 1줄 [HARD · C3 해소]

> **본 SPEC 의 분모 = 게시 위젯 194 개 / 그에 대응하는 상품 A∩B 193 개.**
> `PRD_000165`(아크릴포카코롯토, 게시됐으나 `use_yn=N` = B−A 1건)는 **분모에 포함하지 않고 별도 치명 항목**으로 원장에 단독 계상한다.

근거: `out/REPORT-260822.md` AC9 · `lens-b-defects.jsonl`(194) · `progress.md:141-143`(A∩B=193, B−A=1). `wiring-health-index.json.published_widgets: 193` 은 v0.1.0 시점 수치로 채택하지 않는다(research.md C3).

### 1.2.1 E1 종료 기준 분모 확정 — 1줄 [HARD · C6 해소]

> **본 SPEC 의 E1 종료 기준 분모 = 렌즈 B(게시 194 실호출)의 `E1 NO_SOURCE`.**
> 아래 나머지 3개 층은 **동일 대상의 다른 층 관측치**이며 합산하지 않는다.

| 층 | 건수 | 분모 | 판정층 | 본 SPEC 취급 |
|---|---|---|---|---|
| **렌즈 B `E1 NO_SOURCE`** | **75** | **게시 194** | **실호출** | **종료 기준 분모(정본)** |
| `wiring-health-index` 치명 E1 | 15 (상품) | 게시 | 오프라인 집계 | 동일 대상의 다른 층 관측치 — M1 대상 목록 공급용 |
| `PRICE-DB-STATE` `d_none` | 50 | 266(전체 등록) | 정적 DB 상태 | 동일 대상의 다른 층 관측치 — 분모가 다름, 합산 금지 |
| 렌즈 A `E1 NO_FORMULA` | 2 | PRD_TYPE.01 | 정적 어댑터 | 동일 대상의 다른 층 관측치 — 오탐 57 제거 후 잔량 |

근거: research.md C6(`research.md:453-461`). 이 4개 층은 같은 "가격 소스 없음" 을 서로 다른 분모·판정층에서 본 값이므로 한 숫자로 합칠 수 없다. M1 의 대상 목록은 4개 층의 **합집합**으로 구성하되, 종료 시 E1 잔량 계상은 렌즈 B 층 단일 기준으로만 센다(`plan.md §D M1` 층별 중복 관계 부기 참조).

### 1.3 현 상태 실측 (승계)

- v0.2.0 verdict: `BROKEN 78 · WARN 92 · NOT_EVALUATED 38 · OK 58`. **BROKEN 중 게시 71 / 미게시 7**, NOT_EVALUATED 38 은 전부 미게시 → 1차 배선 목표의 분모 밖(research.md §2).
- 렌즈 B(게시 194 실호출) 상품 verdict: `BROKEN 66 · OK 119 · WARN 2 · NOT_EVALUATED 6 · INFRA_FAIL 1`.
- 교정 라우팅: `needs_authority 694 · review 616 · needs_design 121 · auto_data 0`(`worklist.csv` 1,431행).

---

## 2. 범위

### 2.1 범위 안

1. **기준 재고정**: 권위 엑셀 260822_1 재추출 + 결함 건수 재집계 + worklist 재산출 (M0).
2. **결함유형별 일괄 교정**(작업 단위 = 결함유형 배치, 상품군 단위 아님): E1 / E4 재키드리프트 / E2 / S1 (M1~M4).
3. **검증 스윕**: 게시 분모 전량 재판정 + 제외 3분류 원장화 (M5).
4. 백로그 카드 t2~t8 의 흡수(§3.3).
5. 정확도 층(E5·Q1·S1 저청구)의 **검증·원장화**.

### 2.2 범위 밖 (exclusions)

아래 항목은 본 SPEC 의 out of scope 이며, 재적발 시 결함이 아니라 라우팅 대상이다.

### Out of Scope — 라이브 DB 직접 변경
- 라이브 DB 에 대한 직접 SQL / DDL / COMMIT 실행. `build_load.py` 가 산출하는 UPSERT SQL 은 **화면 입력 값 명세로만** 사용하고 실행하지 않는다(research.md §11).
- `raw/webadmin/**` 소스코드 수정. 호출·이식만 허용.

### Out of Scope — 정확도 층 교정
- E5(판수 환산)·Q1(수량 경계)의 **실교정**. 본 SPEC 은 이를 원장화·재현조건 확정까지만 수행하고, 교정은 후속 SPEC 으로 이월할 수 있다.
- 가격 레이어 승계 553건(`out/defects/price-defects.jsonl`) — hdx §26 트랙 소관으로 이미 분리됨(`HANDOFF.md:81`).

### Out of Scope — G1 stale 기본값 34건 교정
- G1 stale 기본값 **34건**(`out/defects/g1-defects.jsonl` 실측)의 **실교정**. 이 SPEC 의 수정 수단은 사용자가 지정한 3개 가격 화면(가격공식·가격구성요소·가격뷰어)뿐인데, G1 교정은 **위젯 편집 + 재게시**(`widget_views.py:467-513` `publish_widget` — 새 스냅샷 생성)를 요구하므로 수단 밖이다. 위젯 API 는 활성 스냅샷을 서빙하므로(`widget_api.py:214`) 재게시 없이는 교정이 반영되지 않는다.
- 조치: 34건은 **수정 대상·종료조건 분자에서 제외**하고, **발견 원장(ledger) 산출물로만 기록**해 후속 위젯 정비 트랙으로 이월한다. `AC-PW-017` 의 (A) 분자 정의에서 G1 은 제외된다.

### Out of Scope — 위젯 재게시
- **이 SPEC 은 위젯 재게시를 수행하지 않는다.** 화면 조작으로 값을 저장하는 데까지가 범위이며, 재게시(`publish_widget`)가 필요한 교정은 전부 후속 트랙 이월 대상이다(게시 시 시작가 자동 재계산, `widget_manual_content.py:254-256`).

### Out of Scope — 미게시 상품
- NOT_EVALUATED 38건(전부 미게시)과 `A−B`(등록됐으나 미게시) 상품군. 런칭 대기 상태이며 결함이 아니다.

### Out of Scope — 판정 알고리즘 신설
- 신규 판정 알고리즘·심각도 등급 mint. 판정은 기존 5센서 + `widget_api._prep_*` + `pricing.evaluate_price` 호출·조립만으로 수행한다(선행 SPEC R3/R8, AC12).

### Out of Scope — 진단 아티팩트 품질 개선
- 백로그 t5(아티팩트 표시결함)의 신규 개선. 이미 완료 기록(`progress.md §M2'`)이므로 회귀 항목으로만 승계한다.

---

## 3. 결함유형 → 배치 → 화면 매핑

### 3.1 배치 정의 (작업 단위 = 결함유형)

| 배치 | 결함유형 | 고치는 화면 | 저장 엔드포인트 |
|---|---|---|---|
| **M1** | E1 가격소스 없음 | 가격 뷰어 `/admin/price-viewer/?prd=` | `POST /admin/price-viewer/<prd_cd>/source/` = `price_source_save` |
| **M2** | E4 코드 재키 드리프트(사이즈축·공정축) | 가격구성요소(MD) → 단가표 편집 | `POST .../comp/<comp_cd>/save/` = `price_grid_save` |
| **M3** | E2 공식↔구성요소 미배선 | 가격공식(MD) admin changeform 인라인 | **전용 JSON 엔드포인트 없음** — 인라인 폼셋 POST |
| **M4** | S1 셋트/책자 | 셋트상품 관리 `/admin/set-products/` + 구성원별 M1/M2 경로 | 구성원 경로 승계 |
| **M5** | 전량 검증 스윕 | 가격 시뮬레이터 `/admin/price-simulator/`(읽기·검증) | 없음(읽기 전용) |

근거: research.md §4(권위 `out/PRICE-ADMIN-MAP-260822.md §F`), §4.1, §4.2, §5.1.

주의 2건(research.md §4):
- **상품 뷰어 `/admin/product-viewer/` 는 가격 등록 화면이 아니다**(`build_product_tree(with_price_badge=False)`, `PRICE-ADMIN-MAP-260822.md:119`).
- **엔진 소스 우선순위: 직접단가 > 공식.** 직접단가가 있으면 공식은 조회조차 되지 않는다(`raw/webadmin/webadmin/catalog/pricing.py:568-592`). 오탐 57건의 뿌리다.

### 3.2 매뉴얼이 규정한 올바른 등록 절차 (준수 대상)

`raw/webadmin/tools/manual_content.py:820-830` verbatim: ① 기준정보 → ② 상품 → ③ **가격구성요소·단가표 생성 → 가격공식으로 묶고 → 가격 뷰어에서 상품에 연결** → ④ 시뮬레이터 검증. 본 SPEC 의 배치 순서(M1→M2→M3)는 이 절차의 역순 진입(이미 존재하는 것부터 연결)임을 명시한다.

### 3.3 백로그 t2~t8 흡수

흡수 매핑표는 `plan.md §F` 에 둔다(research.md §12 승계). t4①②·t5 는 "완료 확인 후 흡수"로 다룬다(C5).

---

## 4. 요구사항 (GEARS)

### 4.1 기준 재고정

- **REQ-PW-001** — Ubiquitous. 본 SPEC 의 가격 판정 기준은 권위 엑셀 260822_1 2종(가격표 sha256 `f4a3e4ca…c5a9` · 상품마스터 sha256 `46225a1a…a946`)에서 재추출한 캐시여야 한다.
- **REQ-PW-002** — **When** 기존 결정론 추출 스크립트를 260822_1 로 재실행할 때, 재추출기는 경로 상수만 교체하고 추출 로직은 변경하지 않아야 한다(`_scripts/run_extract_master_260703.py` · `run_extract_price_260705.py` · `06_extract/scripts/extract_price_sheets.py:36,43`).
- **REQ-PW-003** — **When** 재추출이 완료되면, 재추출기는 원본 xlsx 2종의 sha256 을 캐시 매니페스트에 기준점으로 기록해야 한다(현행 매니페스트에는 해시 필드가 없다, research.md §10).
- **REQ-PW-004** — **When** 결함 건수를 인용할 때, 집계기는 파일 실측 재집계 결과만 인용해야 하며 문서 승계 수치(404 / 925)를 그대로 쓰지 않아야 한다(C1·C2 해소).
- **REQ-PW-005** — **While** M0 이 완료되지 않은 동안, 작업자는 `needs_authority` 로 분류된 694건에 착수하지 않아야 한다. [HARD]

### 4.2 배선 교정 (1차 목표)

- **REQ-PW-006** — **When** 상품에 가격 소스가 전무한 것으로 확인되면, 작업자는 가격 뷰어 `price_source_save` 로 `kind:"formula"`(상품↔공식 바인딩) 또는 `kind:"price"`(직접단가)를 등록해야 한다.
- **REQ-PW-007** — **While** 상품이 직접단가(`t_prd_product_prices`)를 보유하는 동안, 판정기는 공식 바인딩 부재를 결함으로 올리지 않아야 한다. (`shall not` — 오탐 57건 재발 금지)
- **REQ-PW-008** — **When** 고아 공식(어느 상품에도 미바인딩) 10건을 교정할 때, 작업자는 상품↔공식 바인딩만으로 배선이 살아나는지 먼저 확인해야 한다(최고 ROI 지점, `PRICE-DB-STATE-260822.md:116,136-145`).
- **REQ-PW-009** — **When** 코드 재키 드리프트를 교정할 때, 작업자는 **값을 변경하지 않고 코드만 상품 연결 코드로 이관**해야 한다(사이즈축 선례 `PRD_000155`, 공정축 t2 `PRD_000071`).
- **REQ-PW-010** — **When** 차원 축을 가격에 반영할 때, 작업자는 `use_dims` 체크박스가 아니라 **단가행의 해당 컬럼 값**을 채워야 한다. 행 값 NULL 은 와일드카드이며(`pricing.py:136-148`), 미충전 시 그 구성요소가 합산에서 조용히 빠져 저청구가 된다.
- **REQ-PW-011** — **When** 공식↔구성요소 배선(E2, 전역 8건: 빈배선 6 + 고아구성요소 2)을 교정할 때, 작업자는 admin changeform 인라인 폼셋 경로를 사용해야 한다. 전용 JSON 저장 엔드포인트는 존재하지 않는다(`price_views.py` 쓰기 surface 3개 전수 확인, research.md §16).
- **REQ-PW-012** — **When** 셋트 상품의 계산 실패를 교정할 때, 작업자는 각 구성원을 M1/M2 경로로 개별 교정한 뒤 셋트 합산을 재검증해야 한다.
- **REQ-PW-013** — **Where** 상품군이 「계산공식집초안」의 `[고정가형]` 으로 분류되는 경우, 판정기는 공식/구성요소 부재를 결함으로 올리지 않아야 한다. (`shall not`)

### 4.3 안전 절차

- **REQ-PW-014** — **When** 단가표를 `price_grid_save` 로 저장할 때, 작업자는 **전체 그리드를 로드한 상태에서 행 추가만** 수행해야 하며, 부분 페이로드로 저장하지 않아야 한다. `price_grid_save` 는 full-sync 이며 그리드에 없는 키를 삭제한다(`price_views.py:1313-1327`). [HARD · C8 방어]
- **REQ-PW-015** — **When** 단가표·구성요소를 수정할 때, 작업자는 해당 구성요소의 **파급 상품 수(blast_radius)** 를 표기한 뒤 인간 판단을 받아야 한다(최대 31상품: `COMP_PRINT_DIGITAL_S1` 31 · `COMP_PAPER` 31 · `COMP_GOODS_FIXED_SIZ` 30).
- **REQ-PW-016** — **When** 화면 조작으로 값을 저장할 때, 저장(COMMIT)은 드라이런/미리보기 → 인간 승인 → 저장 순서를 거쳐야 한다. **작업자는 위젯 재게시(`publish_widget`)를 수행하지 않아야 한다** — 이 SPEC 은 재게시를 범위 밖으로 두며(§2.2), 재게시가 필요한 교정은 후속 트랙으로 이월한다. [HARD · C7 해소]
- **REQ-PW-017** — Ubiquitous. 작업자는 등록된 값을 삭제하지 않아야 하며, 산출물에 "과등록 조사"·"삭제" 를 시사하는 문구를 남기지 않아야 한다(2026-07 0원 견적 사고 재현 경로, `verify_zero_quote.py:5-9`). (`shall not`) [HARD]

### 4.4 검증·종료

- **REQ-PW-018** — **When** 전량 검증 스윕을 수행할 때, 검증기는 기존 도구만 재사용해야 한다: `verify_zero_quote.py` · `lens_b_runner.py` · `audit_published_prices.py`. 신규 판정 알고리즘 mint 금지.
- **REQ-PW-019** — **When** 스윕 결과를 분류할 때, 검증기는 각 미매칭 건을 (A)진짜 결함 / (B)정상 미매칭(「가족 분담 면제」) / (C)미선택 차원 3분류로 사유와 함께 원장화해야 한다(t8 골격 승계).
- **REQ-PW-020** — **When** 가격 권위를 판정할 때, 검증기는 `result_sum.PRICE` 를 단일 출처로 삼아야 하며 per-line `result[].PRICE=0` 을 결함으로 세지 않아야 한다.
- **REQ-PW-021** — **While** 조합 절단(TRUNCATED)이 존재하는 상품에 대해, 검증기는 그 상품을 `OK` 로 판정하지 않아야 한다. TRUNCATED 는 결함이 아니라 커버리지 고지다. (`shall not`)
- **REQ-PW-022** — Ubiquitous. 검증기는 종료 판정의 1차 근거로 감사 HTML(`docs/huni/widget-price-audit-260822.html`) 계열의 실호출 결과를 사용해야 하며, 오프라인 defects/health 는 보조 근거로만 인용해야 한다(오프라인은 실제 막힘을 과소 집계, `AUDIT-BUCKETS-260822.md:166-174`). 감사 도구 원본이 미확보인 경우 1차 근거는 `lens_b_runner` 실호출로 대체해야 한다(`plan.md §D M5`).

---

## 5. 제약 [HARD]

### 5.1 계승 18항 (research.md §13 요약 — 근거는 원문 유지)

1. `raw/webadmin/**` · 라이브 DB **읽기 전용**(선행 `spec.md:24-26`).
2. DB write·DDL·COMMIT·위젯 재게시 = **인간 승인 게이트**(선행 OUT-2).
3. **값 삭제 금지**(R12, 선행 `spec.md:310-315`) — `ANCHOR_*` 를 `auto_data` 로 분류 금지.
4. **알고리즘 mint 금지 / search-before-mint**(선행 §1.1·§1.6, R8, AC12).
5. 원본 센서에 없는 **심각도 신설 금지**(R3).
6. **미평가를 통과로 표기 금지**(선행 §3.3, AC11).
7. **E5 를 E4 에 흡수 금지**(선행 `spec.md:233-234`, AC10).
8. 모든 사실 주장에 `파일경로:라인`, 추정은 `[추정]`, **LLM 셀 단위 분석 0**(OUT-5).
9. **원본 먼저 읽기**(memory `read-source-not-ask-260706.md`) — 최신본만.
10. 권위 정본 = 상품마스터 **「계산공식집초안」**(memory `master-formula-draft-sheet-sot.md`).
11. webadmin 화면 의미는 **앱 내장 매뉴얼이 1차**(`tools/manual_content.py` · `widget_manual_content.py`). `_workspace/huni-admin-manual/manual/*.md` 는 가격 영역에 쓰지 말 것.
12. **`use_dims` ≠ 매칭 축**, NULL = 와일드카드. `use_dims`(12종, `admin.py:156`) ≠ `OPT_REF_DIM`(7종).
13. **사이즈 매칭 기준 = 상품에 연결된 사이즈코드.** 교정은 "연결된 코드로 이관(값 무변경)".
14. 가격축은 위젯 **「차원」 컴포넌트(`WGT_SRC_TYPE.01`)** 로 배치. `.02` 옵션그룹은 가격에 안 걸린다.
15. **PRICE=0 을 정상 빈 상태로 취급 금지.** 권위는 `result_sum.PRICE`.
16. **blast_radius 필수 표기**(선행 `spec.md:119-121`).
17. **게시 상태 코드값 하드코딩 금지**(선행 `plan.md:53-54`). 실측: `WGT_STS_TYPE.02`=게시됨 · 01=작성중 · 03=게시중단.
18. **[본 SPEC 고유] `price_grid_save` full-sync 안전 절차** — REQ-PW-014.

### 5.2 화면 조작 층 분리 [HARD · C7 명시 해제]

선행 SPEC OUT-2 의 "DB write 금지" 는 **코드/직접 SQL 층**에 대한 제약이다. 본 SPEC 의 작업 수단인 **webadmin 실화면 조작(gstack browser)** 은 별도 층이며, 화면을 통한 각 저장은 인간 승인 게이트를 거친다(REQ-PW-016). 라이브 DB 직접 SQL/DDL 은 여전히 금지된다. **위젯 재게시는 이 SPEC 에서 수행하지 않는다** — 화면 조작 층보다 상위의 별도 층이며(게시 시 시작가 자동 재계산, `widget_manual_content.py:254-256`), 재게시를 요구하는 교정(대표적으로 G1 stale 기본값 34건)은 §2.2 범위 밖으로 이월한다. 하위 층 승인이 상위 층을 대체하지 않는다.

---

## 6. 종료 조건

M5 스윕에서 **게시 분모(위젯 194 / 상품 193) 전량**에 대해:

- **(A) 진짜 결함으로 분류되는 `ZERO_FINAL` / `-원` 표시 = 0건** — (A) 분자에서 **G1 stale 기본값 34건은 제외**한다(§2.2 범위 밖, 발견 원장으로만 기록). E1 잔량 계상 분모는 §1.2.1 의 렌즈 B 층 단일 기준이다.
- **(B) 정상 미매칭**·**(C) 미선택 차원**은 사유와 함께 원장화(건수 무관)
- `PRD_000165` 별항은 별도 결론(교정 또는 게시중단 권고)으로 종결

기계 검증 명령·판정 기준은 `acceptance.md` 를 정본으로 한다.
