# GPM-1/2 본체 자재 link 적재본 — 롤백전용 DRY-RUN 로그

> **실행** 2026-06-16 · `dbm-correctness-auditor` · 라이브 읽기전용+BEGIN…ROLLBACK(비파괴, COMMIT 0).
> **대상:** `apply.sql` → `t_prd_product_materials` 명확분 41 본체 소재 link.

---

## 1. 적재 전 베이스라인 (라이브 실측)

```sql
SELECT count(*) FROM t_prd_product_materials pm
JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
WHERE m.mat_typ_cd IN ('MAT_TYPE.05','MAT_TYPE.06')
  AND pm.prd_cd IN (<41 prd_cd>);
-- 결과: 0
```

→ 41상품 전부 본체 소재(.05/.06) link **0건**. 본 적재는 전량 신규(멱등 skip 대상 0).

## 2. DRY-RUN 결과 (apply.sql · BEGIN…ROLLBACK)

```
BEGIN
DO                       -- 가드0 통과: 재사용 자재행 4종(MAT_000008/183/184/185) use_yn='Y' 실재
INSERT 0 41              -- 41행 전부 신규 삽입 (ON CONFLICT skip 0)
 chk                   | n
 본체소재link(.05/.06) | 41   -- 적재 후 본체소재 link = 41 (기대 41 일치)
 chk    | n
 FK고아 | 0                -- mat_cd/usage_cd/prd_cd FK 전부 정합, 고아 0
ROLLBACK                 -- 비파괴, 라이브 무변경
```

## 3. 롤백 확인 (라이브 무변경)

```sql
SELECT count(*) FROM t_prd_product_materials
 WHERE usage_cd='USAGE.07' AND mat_cd IN ('MAT_000008','MAT_000183','MAT_000184','MAT_000185')
   AND prd_cd LIKE 'PRD_0002%';
-- 결과: 0  (DRY-RUN 후에도 라이브 본체소재 link 0 — COMMIT 안 됨 확인)
```

## 4. 멱등성 2-pass 검증 (동일 TX 2회 INSERT)

```
BEGIN
INSERT 0 2     -- 1회차: 신규 2
INSERT 0 0     -- 2회차: 동일 INSERT → ON CONFLICT DO NOTHING skip 2
ROLLBACK
```

→ PK=(prd_cd,mat_cd,usage_cd) ON CONFLICT 멱등. 재실행 시 중복 0행.

## 5. 게이트 판정

| 항목 | 결과 |
|------|:--:|
| 제약 위반 | 0 |
| FK 고아 | 0 (mat/usage/prd 전부 참조 정합) |
| NOT NULL 위반 | 0 (reg_dt/del_yn DEFAULT 발화, dflt_yn='Y' 명시) |
| 멱등성(재실행 중복) | 0 |
| 신규 mint | 0 (기존 .05/.06 자재행 재사용) |
| 라이브 실 변경(COMMIT) | 0 (ROLLBACK) |
| INSERT 행수 | **41** (명확분 전수) |

**판정: DRY-RUN GO — 제약위반 0·FK고아 0·멱등 입증.** 실 COMMIT(ROLLBACK→COMMIT 교체)은 인간 승인.

## 6. 후속 순서 [HARD]

GPM-1/2(본체 소재 link 선적재·본 단계) → **그 다음** GPM-4(비소재 .09/.08 link 제거·dflt_yn 정리). 역순이면 본체 BOM 영구 공백(진단 §4 순서 제약). BLOCKED 14(타이벡 11·모호 3)는 컨펌 후 별도 적재본.
