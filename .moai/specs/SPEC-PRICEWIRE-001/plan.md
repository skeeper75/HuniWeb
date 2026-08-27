---
id: SPEC-PRICEWIRE-001
doc: plan
version: "0.1.1"
updated: 2026-08-27
status: draft
tier: L
---

# 구현 계획 — SPEC-PRICEWIRE-001

> 순서 원칙: **번복 가능성이 큰 결정을 먼저** 놓는다(§A 티어·§B 결정 기록 → §C 접근 → §D 마일스톤 → §E 리스크 → §F 흡수표). 기계적 절차는 뒤로 뺐다.

---

## §A 티어 판정 — **Tier L** (근거)

| 판정축 | 실측 | 판단 |
|---|---|---|
| 영향 단위 | 게시 위젯 194 / 상품 193, BROKEN 게시 71건 | 15 파일-등가 초과 → L |
| 결함 배치 | 6개(M0 재고정 + 4개 교정 배치 + 검증 스윕) | 다마일스톤 |
| 제약 밀도 | 계승 HARD 18항 + 오탐 방지 16항 + 모순 12건 | 헌법급(constitutional) |
| 아티팩트 | `research.md` 506줄 **이미 존재** | Tier L 아티팩트 셋과 정합 |
| 성격 | 코드 중심 아님 — **운영(화면 조작) 중심** | LOC 축은 비적용, 대신 대상 건수·제약 밀도로 판정 |

→ **Tier L**: `spec.md` + `plan.md` + `acceptance.md` + `design.md` + `research.md`. REQ ≤25 / AC ≤25 예산 준수(현재 REQ 22 / AC 25).

**Tier M 이 아닌 이유**: 화면 절차 자체가 설계 산출물이어야 한다(`price_grid_save` full-sync 방어·인라인 폼셋 경로·blast_radius 게이트). 이를 `plan.md` 에 욱여넣으면 절차가 검토 불가능해진다 → `design.md` 분리가 필요하므로 L.

---

## §B 결정 기록 (해소 완료 — 미해소 마커 0건)

plan-audit iteration-1 의 해소 게이트 5건은 아래와 같이 종결됐다. 1건은 **범위 결정**, 나머지 4건은 **착수 전 기계 확인 절차**로 전환해 해당 마일스톤의 선행 단계에 편입했다(마커 삭제).

### B-1. G1 stale 기본값 34건 — **범위 밖(SCOPE OUT)** [결정]

이 SPEC 의 수정 수단은 사용자가 지정한 3개 가격 화면(가격공식·가격구성요소·가격뷰어)뿐인데, G1 교정은 **위젯 편집 + 재게시**(`widget_views.py:467-513` `publish_widget` — 새 스냅샷 생성)를 요구하므로 수단 밖이다. 위젯 API 는 활성 스냅샷을 서빙한다(`widget_api.py:214`).

- 조치: 34건(`out/defects/g1-defects.jsonl` 실측)은 **수정 대상·종료조건 분자에서 제외**하고, **발견 원장(ledger) 산출물로만 기록**해 후속 위젯 정비 트랙으로 이월한다.
- `AC-PW-017` 의 (A) 분자 정의에서 G1 제외를 명시(`acceptance.md §C`).
- 재게시 관련 기존 문구는 "**이 SPEC 은 재게시를 수행하지 않는다**" 로 강화됐다(`spec.md §2.2` · `§5.2` · `REQ-PW-016`). 기존의 "재게시 별도 게이트" 층 구분은 "수행 안 함" 으로 승격.

### B-2. E5 실존 여부 — **M0 선행 판정 절차로 전환**

감사는 판형미환산 20상품(고신뢰, `AUDIT-BUCKETS-260822.md:213`), 렌즈 B 실호출은 **E5 0건**(`progress.md:176-188`)이라 어느 쪽이 아티팩트인지 미확정이었다(research.md C10). → **M0-5 단계**로 편입: 판형 경로를 포함한 렌즈 B 재스윕으로 E5 발화 여부를 기계 판정한다. **판정 전에는 E5 관련 계상을 보류**한다(`spec.md §5.1-7` 의 "E5→E4 흡수 금지" [HARD] 는 그대로 유지).

### B-3. admin 인라인 폼셋 필드 prefix — **M3 착수 조건으로 전환**

`t_prc_formula_components` 인라인의 폼셋 prefix(`…-TOTAL_FORMS` 등)가 미확인이다(research.md §16). → **M3 착수 조건**: `gstack` 실화면 정찰 1건으로 폼셋 필드(prefix · `management_form`)를 확인한 뒤 착수한다. 확인 전 M3 저장 조작 금지.

### B-4. 매뉴얼 HTML 최신성 — **M0 확인 절차로 전환**

`docs/admin-manual.html` 이 현행 원고(`tools/manual_content.py`)와 동기화된 빌드인지 미확인이다(research.md C12). → **M0-6 단계**: `gen_admin_manual.py` / `gen_widget_manual.py` 재생성 diff 로 `docs/*.html` 동기화를 확인한다. diff 가 비면 화면 매뉴얼 = 원고로 확정, 비지 않으면 **원고(`manual_content.py`)를 1차 참조**로 삼는다(`spec.md §5.1-11`).

### B-5. 감사 도구 원본 미확보 — **M5 대체 규칙으로 확정**

종료 판정 1차 근거가 감사 HTML 계열인데(REQ-PW-022) 감사 도구 원본 확보가 선행 미해결 5건 중 ⑤ 로 남아 있다. → **M5 규정**: 원본 미확보 시 **1차 근거를 `lens_b_runner` 실호출로 대체**한다. 이 대체 규칙은 `research.md §15` 의 "감사 HTML 을 1차 근거로" 권고를 갱신하는 것으로, REQ-PW-022 본문에도 반영됐다.

---

## §C 기술 접근

### C.1 작업 단위 = 결함유형 배치 (상품군 아님)

같은 화면·같은 폼계약·같은 안전절차를 공유하는 건을 한 배치로 묶는다. 상품군 단위로 쪼개면 동일 화면 절차를 N회 재학습하고, 공유 구성요소(최대 31상품 파급)의 중복 수정 위험이 커진다.

### C.2 재사용 자산 (신규 제작 0)

| 목적 | 자산 | 비고 |
|---|---|---|
| 권위 재추출 | `_scripts/run_extract_master_260703.py` · `run_extract_price_260705.py` · `06_extract/scripts/extract_price_sheets.py:36,43` | 경로 상수만 교체 |
| 권위↔라이브 격자 diff | `huni-price-table-integrity/_batch/scripts/{matrix_parse,grid_diff,run_all,build_load}.py` | `run_all.py` 의 `EXTRACT` 상수 260822 로 교체 |
| 배선 결함 전수 | `_workspace/_foundation/batch/wiring_scan.py` | ORPHAN/DEAD_WIRE/DELETED_WIRE/NO_FORMULA, 토큰 0 측도 |
| 게시 실호출 스윕 | `huni-widget-wiring/bin/lens_b_runner.py` | 판정 mint 금지 계약 승계 |
| 0원 전수 적발 | `raw/webadmin/tools/verify_zero_quote.py` | 종료조건과 1:1 |
| 게시 194 전수 점검 | `raw/webadmin/tools/audit_published_prices.py` | `--products/--limit/--workers` |

`build_load.py` 산출 SQL 은 **실행하지 않는다** — 화면 입력 값 명세로만 사용(spec.md §2.2).

### C.3 배치 공통 절차 (모든 M1~M4 에 적용)

1. **대상 목록 확정** — 출처 파일·필터 조건 명시(추정 금지).
2. **blast_radius 산출** — 수정 대상 구성요소를 공유하는 상품 수 표기.
3. **드라이런/미리보기** — 저장 전 변경 예정 값 제시.
4. **인간 승인** — 승인 없이 저장 금지.
5. **저장 후 즉시 단건 재계산** — 시뮬레이터로 해당 상품 최종가 확인.
6. **원장 기입** — 대상·전후·근거·승인자.

---

## §D 마일스톤

### M0 — 기준 재고정 [선행·차단, 우선순위 High]

C1·C9 해소. 이 마일스톤 완료 전 `needs_authority` 694건 착수 금지(REQ-PW-005 [HARD]).

- **M0-1 권위 재추출**: 기존 결정론 스크립트의 경로 상수를 260822_1 로 교체(4파일, research.md §10 재추출 경로) → 재실행. 원본 xlsx 2종 sha256 을 캐시 매니페스트에 기준점으로 기록.
- **M0-2 결함 건수 실측 재집계**: `widget-defects.jsonl` 파일 실측(389) vs 문서 승계(404) 15건 차이 규명. TRUNCATED 11건 분리분 + α 를 확정.
- **M0-3 worklist 재산출**: 재추출 캐시 기준으로 `worklist.csv` 재생성. `needs_authority` 재분류 결과 확정.
- **M0-4 `run_all.py` EXTRACT 상수 교체** 후 19시트 배치 diff 1회 실행, `SHEET_REGISTRY` 각 시트 status 실측.
- **M0-5 E5 발화 여부 판정** (§B-2): 판형 경로를 포함한 렌즈 B 재스윕을 1회 실행해 E5 발화 여부를 기계 판정한다. 판정 전 E5 관련 계상 보류.
- **M0-6 매뉴얼 HTML 동기화 확인** (§B-4): `gen_admin_manual.py` / `gen_widget_manual.py` 재생성 diff 로 `docs/admin-manual.html` · `docs/widget-manual.html` 의 원고 동기화를 확인한다.

### M1 — E1 가격소스 배선 [우선순위 High]

- 대상: 렌즈 B `E1 NO_SOURCE` 75건 ∩ 게시 분모 / `wiring-health-index` 치명 E1 15상품 / 백로그 **t6**(게시중 무가격 15상품: 완제품 2 + 기성 13) / **t7**(`PRD_000010` 행택끈 · `PRD_000218` 타이벡북커버) / 고아 공식 10건 바인딩 / PRD_TYPE.01 가격소스 전무 2건(`PRD_000038` 형압명함 · `PRD_000220` 폰스트랩).
- 화면: 가격 뷰어 → `price_source_save`(`kind:"formula"` 우선, 직접단가 상품은 `kind:"price"`).
- **선행 확인 [HARD]**: 각 건마다 직접단가 보유 여부를 먼저 확인한 뒤에만 E1 로 올린다(REQ-PW-007).
- blast_radius: 상품 단위 바인딩이므로 원칙적으로 1. 공식 공유 시 해당 공식의 바인딩 상품 수 표기.
- 별항: `PRD_000218` 은 권위 엑셀 굿즈파우치 row88 가격 셀 **공란** → `needs_authority`, 실무진 문항으로 분리.
- **층별 중복 관계 [HARD · C6]**: 위 대상 목록의 앞 3개 항목은 **같은 "가격 소스 없음" 을 서로 다른 분모·판정층에서 본 관측치**이며 서로 중복된다 — 렌즈 B `E1 NO_SOURCE` 75건(게시 194 / 실호출) ⊇ `wiring-health-index` 치명 E1 15상품(게시 / 오프라인 집계) ⊇ t6 게시중 무가격 15상품(같은 15상품의 카드 표현). PRD_TYPE.01 2건은 `PRICE-DB-STATE` `d_none` 50건(분모 266)의 부분집합이다. **대상 목록은 4개 층의 합집합으로 구성하되, 종료 시 E1 잔량 계상은 렌즈 B 층 단일 기준으로만 센다**(`spec.md §1.2.1`). 건수를 합산하지 않는다.

### M2 — E4 재키 드리프트 교정 [우선순위 High]

- 대상: P1 아크릴 재키 14상품 / 백로그 **t2**(트윈링책자 `PRD_000071` 연결공정 `PROC_000021` ↔ `COMP_BIND_TWINRING` 단가행 32건 전부 `PROC_000019`) / `use_dims` vs 등록차원 미충전 건.
- 화면: 가격구성요소(MD) → 단가표 편집 → `price_grid_save`.
- **원칙 [HARD]**: 값 무변경·코드 이관만. 삭제 금지.
- **안전 [HARD]**: 전체 그리드 로드 상태에서 행 추가만(REQ-PW-014). 부분 페이로드 저장 금지.
- blast_radius: 단가표 1개 수정의 파급 상품 수 필수 표기(최대 31).

### M3 — E2 공식↔구성요소 배선 [우선순위 Medium]

- 대상: 전역(상품 비귀속) E2 8건(빈배선 6 + 고아구성요소 2) / 백로그 **t4③**(책자 공식에 인쇄비·용지비 구성요소 부재) / 고아 구성요소 79/202 중 가격 영향 확인분.
- 화면: `/admin/catalog/tprcpriceformulas/<frm_cd>/change/?_popup=1` 인라인 폼셋 POST(CSRF + management_form). **전용 JSON 엔드포인트 없음**(research.md §5.1).
- 권위: 상품마스터 「계산공식집초안」 전개식(예: 트윈링책자 판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 제본비 + 용지비 + 후가공비).
- **착수 조건 [HARD · §B-3]**: `gstack` 실화면 정찰 1건으로 인라인 폼셋 필드(prefix · `management_form`)를 확인한 뒤 착수한다. 확인 전 저장 조작 금지.

### M4 — S1 셋트/책자 [우선순위 Medium]

- 대상: S1 셋트 계산 실패 11상품 / `SET_MEMBER_NO_SOURCE` 26건 / 백로그 **t3**(책자 5상품 `mand_proc_yn` 전건 NULL → 공정축 미스윕, ZERO_FINAL 90건 미판정).
- 화면: 셋트상품 관리 + 구성원별 M1/M2 경로.
- t3 잔여: 위젯 공정 필수선택 여부 + 필수공정 등록 판단(상품 뷰어).
- **판정 기준 [HARD]**: 셋트 구성원의 공식 부재가 정상인지 결함인지는 라이브가 아니라 「계산공식집초안」 공식 유형으로 가른다.

### M5 — 검증 스윕 [우선순위 High · 종료 판정]

- 도구: `verify_zero_quote.py` + `lens_b_runner.py` + `audit_published_prices.py`. 백로그 **t8**(WB-DIAG 근거 게시본 194 전수 진단) 흡수.
- 분류: (A) 진짜 결함 / (B) 정상 미매칭「가족 분담 면제」 / (C) 미선택 차원.
- 오탐 방지 16항(research.md §14)을 negative guard 로 적용 — 해당 케이스를 결함으로 재적발하면 FAIL.
- `PRD_000165` 별항 결론 기재.
- **1차 근거 대체 규칙 [§B-5]**: 감사 도구 원본이 미확보이면 1차 근거를 `lens_b_runner` 실호출로 대체한다(REQ-PW-022). `research.md §15` 의 감사-1차-근거 권고를 이 규칙으로 갱신한다.
- **G1 34건**: 범위 밖(§B-1) — 수정하지 않고 **발견 원장으로만** 기재, 후속 위젯 정비 트랙 이월.
- 종료: (A) = 0건(G1 34건 제외, E1 잔량은 `spec.md §1.2.1` 렌즈 B 층 기준).

---

## §E 리스크

| 리스크 | 영향 | 완화 |
|---|---|---|
| `price_grid_save` full-sync 로 기존 행 소실 | 치명(2026-07 사고 재현) | REQ-PW-014 전체그리드 로드 절차 + 저장 전 행수 대조 |
| 오프라인 진단의 과소 집계(only_audit 23건) | 종료 오판 | REQ-PW-022 — 실호출 결과를 1차 근거로 |
| 권위 stale(캐시 ~50일) | 694건 판정 불가 | M0 차단 게이트 |
| 공유 구성요소 수정의 광역 파급(최대 31상품) | 회귀 | blast_radius 표기 + 인간 승인 |
| 화면 조작 자동화 난도(M3 인라인 폼셋) | 일정 | §B-3 착수 조건(gstack 실화면 정찰 1건)으로 절차 확정 후 전개 |
| 재게시 필요 시 시작가 재계산 | 미승인 변경 | **재게시 미수행**(§B-1) — 재게시를 요구하는 교정(G1 34건 등)은 범위 밖 이월 |

---

## §F 백로그 t2~t8 흡수 매핑

| 카드 | 요지 | 흡수 마일스톤 | 비고 |
|---|---|---|---|
| **t2** | 트윈링책자 공정축 재키 드리프트(단가행 32건) | **M2** | 값 무변경·코드 이관 |
| **t3** | 책자 5상품 `mand_proc_yn` NULL → 공정축 미스윕 | **M4**(+ M5 커버리지) | 잔여 = 필수공정 등록 판단 |
| **t4** | ① TRUNCATED 전수화 ② AC5 증거 수정 ③ 책자 공식 구성요소 부재 | ①② = **완료 확인 후 흡수**(M0-2 회귀 확인) · ③ = **M3** | C5 |
| **t5** | 아티팩트 표시결함 | **완료 확인 후 흡수** — 회귀 항목으로만 | C5 · spec.md §2.2 |
| **t6** | 게시중 무가격 15상품 | **M1** | 수단이 이미 SPEC 규정과 일치 |
| **t7** | `PRD_000010` · `PRD_000218` (감사 분모 밖) | **M1 별항** | `PRD_000218` 은 needs_authority |
| **t8** | WB-DIAG 근거 게시 194 전수 진단 + 제외 3분류 | **M5** | 본 SPEC 의 직계 모체 |

**출처 각주 [C4]**: `t6`~`t8` 의 출처는 `.moai/state/kanban/backlog.json` 의 `items[]` 이며, `HANDOFF.md:52-55`(t2~t5 만 정의)와 동기화돼 있지 않다(research.md C4, `research.md:439-444`). **카드 본문 수치는 backlog 를 정본으로 삼는다.**
