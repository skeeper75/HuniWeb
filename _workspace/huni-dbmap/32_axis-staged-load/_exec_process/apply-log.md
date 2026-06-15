# ⑤ 공정 에폭시 연결 — 실 라이브 COMMIT 로그 (round-22 v2 경로 X)

> **실행** 2026-06-16 · 경로 X(라이브 직접). 검증 GO(X1~X6·size-process-gate)·사용자 "계속 진행". undo 단순(1행 DELETE).

## 적용 내용

| 단계 | 내용 | 결과 |
|------|------|------|
| 정체 확인 | PRD_000169=아크릴입체블럭(use_yn=Y)·PROC_000083=에폭시·169 BOM=투명아크릴(MAT_TYPE.03) | 정합 |
| 백업 | 169 현재 공정 연결 export | COPY 0(연결 없었음) |
| DRY-RUN | BEGIN…ROLLBACK | INSERT 0 1·proc_cd cp 0·ROLLBACK |
| **COMMIT** | `INSERT … ('PRD_000169','PROC_000083','Y',10) ON CONFLICT DO NOTHING` | **INSERT 0 1 · COMMIT** |
| 검증 | 169 에폭시 Y disp 10 적재 | ✅ |
| 멱등 2회차 | 재실행 | INSERT 0 0(ON CONFLICT·완전 멱등) ✅ |

## 적용 대상 = 169만 (168 BLOCKED)

- **PRD_000169 아크릴입체블럭** — BOM 투명아크릴 확정·에폭시(아크릴 입체 충전) 공정 정합 → 적용.
- **PRD_000168 아크릴입체코롯토** — 자재 BOM 0행·정체 추정 → **B-10(입체코롯토 정체 미확정·적재 보류)** BLOCKED. 에폭시 연결 보류(추측 회피).

## 되돌리기 (undo)

```sql
DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000169' AND proc_cd='PROC_000083';
```
(백업 0행 = 원래 연결 없었으므로 삭제로 완전 원복)

## ★회귀 위험 (경로 Y 백로그)

경로 X는 개발자 v03 `15_상품별공정` 재적재 시 소멸. 근본=경로 Y(v03 15시트에 169 에폭시 행 append). `_backlog/developer-code-changes.md` A-4 참조.

## ② 사이즈 = 라이브 적용 0건

②사이즈축은 가역 안전분 0(전부 가격모델 종속·경로 Y/BLOCKED). 라이브 직접 교정 없음. 상세=`_corrected_xlsx/size-correction-spec.md`.
