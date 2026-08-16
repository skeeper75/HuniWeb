# R3 sync-log — SPEC-WORLDMODEL-001 재검증 R3 마감 (sync 칼럼)

- 일시: 2026-08-17 (칸반 sync 세션)
- 수임: lead-tjtkse 지시 (① 숫자 불일치 정리 → ② 명시 경로 커밋 → ③ 본 로그)

---

## ① 숫자 불일치 정리 — 실측 근거와 결정

### 지시 내용

`spec.md` §8 FU-8 은 LINE_DRIFT 를 **157건**, `R3-mechanical-scan.md` §① 요약표는 리드 전언 기준 **"스캔 200건(+수동 재판정 편입 6건)"** — 같은 측정치의 두 값이 병존한다고 판단되어 정리 지시받음.

### 실측 (근거)

| 근거 | 실측값 | 비고 |
|---|---|---|
| `_scripts/out/a_summary.json` `class_counts.LINE_DRIFT` | **200** | 스캔 원값 (결정론 스크립트 산출물) |
| `R3-mechanical-scan.md` §① A-LINE_DRIFT 행 | "스캔 200건 중 py 대상 48행 전수 대조 → 오탐 46행 제외 → **154건 + 재분류 3건 = 157건**" | 원측정 보고서의 도출 서술 |
| `R3-mechanical-scan.md` §② 집계표 | 스캔 200 / 재판정 보정 −46+3 | "스캔 원값 → 수동 재판정 보정" 표 |
| `R3-remediation-log.md`:110 | "LINE_DRIFT **157건**(design-FINAL 대상 84건)" | 반영 원장도 최종값 157 사용 |

### 판정

- 두 값의 출처가 **전부 특정됨**: 200 = 스캔 원값(기계 분류), 157 = 수동 재판정 보정 후 확정값(200 − py오탐 46 + 재분류 3). **같은 측정의 원값과 확정값**이며, 원측정 보고서 §① 이 둘을 한 셀에 도출 서술로 담고 있다.
- 리드 전언의 "스캔 200건(+수동 재판정 편입 6건)"은 §① 실제 문면과 일치하지 않음(실제: "오탐 46행 제외 → 154건 + 재분류 3건 = 157건". "+6"에 해당하는 숫자는 문서에 없음). 임의 판단이 아니라 실측으로 해소 가능한 케이스라 블로커 미반환.
- FU-8 의 157 자체는 정본 최종값과 일치(틀린 숫자 아님). 결함은 **단일 값으로만 적어 원값 200 과의 병존처럼 보이는 것**이므로, 정본의 도출 과정을 병기하는 방향으로 교정.

### 교정 내용 (`spec.md` FU-8, 유일 수정처)

```
(전) 전수 추출해 `LINE_DRIFT` **157건**을 집계했고
(후) 전수 추출해 `LINE_DRIFT` **스캔 원값 200건 → 수동 재판정 보정(py 오탐 46건 제외·재분류 3건 편입) 확정 157건**을 집계했고
```

- R3 보고서 2종(`R3-mechanical-scan.md`·`R3-adversarial-review.md`·`R3-remediation-log.md`)은 미수정 — 판정·측정 기록.
- 판정 기록(`05_gate/*`, `04_design/evaluation-rubric.md`) 한 글자도 미수정. 미교정 좌표 74건 그대로 둠.

---

## ② 커밋

| 항목 | 값 |
|---|---|
| 커밋 SHA | **`daa736fa`** (main, 부모 a509e52a) |
| 제목 | `docs(SPEC-WORLDMODEL-001): R3 재검증 + 권고 10건 반영` |
| 담긴 파일 수 | **75개** (+65,200줄, 전부 신규) |
| 스테이징 방식 | `git add .moai/specs/SPEC-WORLDMODEL-001/ _workspace/huni-worldmodel/ ':(exclude,glob)**/.moai/state/**' ':(exclude,glob)**/.ruff_cache/**'` — `add -A`/`add .`/`commit -a` 미사용 |
| push | **하지 않음** (별도 판단 — 리드 지시) |

### 담긴 구성 (75)

- `.moai/specs/SPEC-WORLDMODEL-001/` — spec·plan·acceptance (3)
- `_workspace/huni-worldmodel/` — 01_research (8) · 02_diagnosis (10) · 03_problem (1) · 04_design (8, 한글 파일명 score-L1~L3 포함) · 05_gate (36, codex 판정 기록 _codex/_codex2·verdict 최대 2.8MB 텍스트 포함) · 06_artifact (1) · 07_reverify (7) · CHANGELOG·HANDOFF (2)

### 담지 않은 것과 사유

| 제외 | 건수 | 사유 |
|---|---|---|
| `**/.moai/state/` (config-cache·context-usage.json) | 16 | 세션 런타임 상태 캐시 — 문서 커밋에 무의미·렌더마다 변동 |
| `**/.ruff_cache/` | 4 | 파이썬 린터 캐시 — 도구 캐시, 커밋 대상 아님 |
| 카드 무관 변경분 (`.claude/` 대량 삭제분·`_workspace/huni-shopby/`·`tmp/` 등) | 400+ 행(status) | 다른 카드 소관 — pathspec 미포함으로 원천 미스테이징 |

### 특이사항

- **`git fetch origin main` → `0 34`**: 로컬가 34커밋 선행, origin 선행 없음 — 정상 진행.
- **`.git/index.lock` 유령 잠금 제거**: 7월 21일산 0바이트 잠금이 존재해 최초 `git add` 실패. `lsof`·프로세스 점검으로 소유자 없음 확인 후 제거하고 재스테이징(관찰-후-재시도). 27일 된 크래시 잔재.
- 민감정보(`.env*`)·덤프·바이너리: 스테이징 목록 전수 점검 결과 **0건**.

---

## Gaps

1. 리드 전언의 "±6건" 표현은 어느 문서에서도 출처를 특정하지 못함(§① 실제 문면과 불일치). 본 로그의 실측 표가 원문 면으로 대체함.
2. `07_reverify/_scripts/out/` 산출물 중 `b_traceability.json`·`a_citations.tsv`·`a_summary.json` 은 커밋에 포함되었으나, 스캔 재실행 시 산출물-보고서 간 재대조는 하지 않음(원측정 산출물 신뢰 전제).
3. 커밋 후 워킹트리에 카드 무관 변경분 400+건이 그대로 남아 있음 — 다른 카드/세션 소관이라 손대지 않음.
4. 본 로그 자체는 SHA 기입 시점 사정으로 별도 커밋(SHA는 리드에게 보고 완료)으로 반영.

---

로그 작성: sync 세션 (2026-08-17). 본체 커밋: `daa736fa`.
