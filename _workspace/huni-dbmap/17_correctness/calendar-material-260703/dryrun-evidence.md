# DRY-RUN 증거 — 캘린더 종이 드롭다운 부속 논리삭제 (round-13 · GAP-CAL-2)

> **작성** 2026-07-03. 라이브 롤백전용 DRY-RUN(전 트랜잭션 `ROLLBACK` — COMMIT 0). 비밀값 비노출.
> **목적:** load.sql(부속 논리삭제)이 정확히 6행만 대상·멱등·undo 가역임을 실증.

## D1 — 대상 정밀성 (6행, 전부 비종이)

```
 prd_cd     | mat_cd     | mat_nm         | mat_typ_cd  | master_del
 PRD_000108 | MAT_000252 | 삼각대(싸바리) | MAT_TYPE.15 | N
 PRD_000108 | MAT_000253 | 링 블랙        | MAT_TYPE.07 | Y(은퇴)
 PRD_000109 | MAT_000253 | 링 블랙        | MAT_TYPE.07 | Y(은퇴)
 PRD_000109 | MAT_000254 | 삼각대(종이)   | MAT_TYPE.07 | N
 PRD_000111 | MAT_000253 | 링 블랙        | MAT_TYPE.07 | Y(은퇴)
 PRD_000112 | MAT_000253 | 링 블랙        | MAT_TYPE.07 | Y(은퇴)
```
→ 6행 전부 `mat_typ_cd<>MAT_TYPE.01`. 종이(.01) 50행은 대상 아님. **110은 대상 0**(이미 종이만).

## D2 — 멱등성

```
UPDATE 6   -- 1차 실행
UPDATE 0   -- 2차 실행(같은 트랜잭션 재실행) → del_yn='N' 가드로 0행
```
재실행 안전(중복 적용 무해).

## D3 — 사후 상태 (부속 0·종이 무손상)

load 적용 후:
```
 prd_cd     | papers | nonpaper
 PRD_000108 |      8 |        0
 PRD_000109 |      7 |        0
 PRD_000110 |     10 |        0
 PRD_000111 |     22 |        0
 PRD_000112 |      3 |        0
```
→ 전 상품 nonpaper=0(부속 제거 완료). 종이 수(8/7/10/22/3) 변화 없음(용지 무손실).

## D4 — load → undo 가역성 (단일 트랜잭션 실증)

```
STEP1 load  : UPDATE 6           (부속 논리삭제)
STEP2 verify: nonpaper=0 전 상품 (제거 확인)
STEP3 undo  : UPDATE 6           (복원)
STEP4 verify: nonpaper 복원 108=2·109=2·111=1·112=1 (원상)
ROLLBACK    : 커밋 0
```
→ load.sql·undo.sql 한 쌍이 정확히 상호 역연산. 원상 복구 보장.

## D5 — 재현 커맨드 (읽기전용/롤백전용)
```
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -f load.sql   # 내부 BEGIN…ROLLBACK
```

## 판정
- 대상 정밀(6행·비종이만)·멱등(6→0)·사후 부속0/종이무손실·가역(load↔undo) 전부 PASS.
- **미커밋**(ROLLBACK) — 실 COMMIT은 인간 승인 + webadmin 실화면 확인 후.
- escalate 항목(C-9 종이 다종 트리밍·Q-CAL-MAT-1)은 본 DRY-RUN 범위 밖(제거 안 함).
