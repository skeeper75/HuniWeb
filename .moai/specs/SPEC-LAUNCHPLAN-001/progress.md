# SPEC-LAUNCHPLAN-001 — 진행 기록

## §E.1 Plan-phase Audit-Ready Signal

```yaml
spec_id: SPEC-LAUNCHPLAN-001
version: "0.4.0"
plan_status: audit-ready
plan_complete_at: 2026-09-17
author: manager-spec
tier: M
req_count: 18
ac_count: 16
budget_exception: "REQ 한 축 +2 (AC 축은 예산 준수) — 리드 판정 ③ 승인, 기록 plan.md §A-3"
```

- 산출 5종: `spec.md`(GEARS 18항) · `plan.md`(마일스톤 5 · M0 3분할) ·
  `acceptance.md`(16 — §A D3 판정 001~014 · §B run 판정 015 · §C 사람 판정 016 ·
  추적 매트릭스 고아 0) · `research.md`(입력 5/5 · 원본 9종 · 미해결 입력 통합표 35건) ·
  `progress.md`(본 파일).
- SPEC ID 사전 검사: `[[ "SPEC-LAUNCHPLAN-001" =~ ^SPEC(-[A-Z][A-Z0-9]*)+-[0-9]{3}$ ]]` → `PASS`
  (Bash 실행 · 출력 인용).
- 미해소 `[NEEDS CLARIFICATION]` 마커: **0건**.
- 입력 **5/5 완결** — S5(`S/S5-live/`, 2026-09-17 01:30~01:33 KST · p2/p1 · 쓰기 0) 반영 완료.

### 계획감사 이력 (3/3 소진)

| 회차 | 점수 | 판정 | 처리 |
|---|---|---|---|
| review-1 | 64/100 | FAIL | 치명 4(C-1~C-4) · 주요 16 · 경미 7 → 26/29 해소 · 회귀 0 |
| review-2 | 79/100 | FAIL(1점 미달) | 차단 N-1(갭 상수) + N-2·N-3·N-4 + AC 병합 3건 + §6-1 + S5 반영 + 이월 3건 선반영 |
| review-3 | **88/100** | **PASS-WITH-NOTES** | R-1(AC-007(d) 범위) + R-4·R-5·R-6 텍스트 정정 |

추이 64 → 79 → 88 · 회귀 0건 · 신규 치명 0건.

### 잔존 기술부채 (드러내 놓고 이월 — 재감사 회차 소진)

| # | 내용 | 왜 지금 안 고치는가 | 닫는 지점 |
|---|---|---|---|
| R-2 | 선언 갭 수 == 실제 갭 표기 수 대조가 AC-LP-014 에 없음(현재는 「수 + 기준 + 원천 선언」만 검사) | AC 계약 변경이고 재감사 회차가 없음 | **run 단계** — D3 구현 중 자연히 손대는 자리. **sync-auditor 확인 대상** |
| R-3 | §6 앵커 순서 — 도식(`diag-option-price`)이 37행 메뉴 표보다 **뒤**에 옴. 「그림 한 장」이 목적인데 표가 먼저 보임 | 동일(AC 계약 변경) | **run 단계** — D1 조립 시 순서 조정 + D3 앵커 순서 검사 추가. **sync-auditor 확인 대상** |
| m-8 | `REQ-LP-016` 이 Go/No-Go·컷오버·하이퍼케어·RACI 4섹션을 한 조항에 과묶음 | **보류가 옳다고 감사 판정** — 분해 3안이 전부 REQ 예외를 +2 → +5 로 키우거나 문제를 절반만 품. `AC-LP-013` 이 소조건 (a)(b)(c)(d) 로 네 섹션을 각각 검사하므로 **진단 해상도는 이미 보존** | 이 SPEC 이 아님 — **다음 유사 SPEC 을 처음부터 4 REQ 로 쪼개서** 해소 |

### 미검증 사항 (run 단계 첫 확인 대상)

3회차 내내 닫지 못한 것들이다. 전부 **설계 검토이지 실행 관측이 아니다.**

1. **D1·D2·D3 미생성** — 모든 게이트 판정이 설계 검토다. 특히 `AC-LP-014(c)`(선언 문장 파싱) ·
   `AC-LP-005(a)`(요약 700자·6요소 라벨 추출) · `AC-LP-006(d)`(체크 방법 형태소 검사)는
   **jsdom 구현 난이도가 있고, 구현 불가로 판명되면 그 검사는 대리 지표로 퇴화**한다.
   → run M4 에서 구현 가능성을 먼저 확인하고, 불가하면 대리 지표로 낮추지 말고 **리드에
   보고**한다.
2. `R/R5/build_xlsx_v4.py` **미열람** — `AC-LP-015(c)`(654행 시트 보존) 실현 가능성 미확인.
   → run M3 착수 전 열람.
3. **`huni-product-lifecycle.md` · `huni-pricing-engine-map.md` 내용 미검토** —
   `AC-LP-014(d)` 의 「5단계」와 「`use_dims` 12축」이 두 정본의 실제 서술과 일치하는지
   **미검증**. → **run M0 에서 대조할 것.** 불일치 시 §6 도식 계약이 흔들린다.
4. `option-price-trace.md` 의 mermaid **렌더 가능성** 미확인(파싱 존재만 확인) ·
   §A-2 LOC 추정 미검증 · **교차모델 2차 의견 미호출**(Claude 단독 앵커).

### 다음 단계

Implementation Kickoff Approval(plan→run 인간 게이트) 대기. 승인 후 run 레인은
**M0(28구간 통합 상태판 · 3분할)** 부터 착수하며, 위 미검증 3번을 M0 안에서 먼저 닫는다.

## §E.2 Run-phase Evidence

_<pending run-phase>_

## §E.3 Run-phase Audit-Ready Signal

_<pending run-phase>_

## §E.4 Sync-phase Audit-Ready Signal

_<pending sync-phase>_
