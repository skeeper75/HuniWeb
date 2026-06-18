# undo-green.md — ✅GREEN 36 카테고리 적재 롤백 절차 (round-24 2단계)

대상: 라이브 `t_prd_product_categories` · 백업 테이블 **`bak_pc_green_20260618_1322`** (39행, 적재 전 상태 전수 스냅샷)
적재 COMMIT 일시: 2026-06-18 · 변경 = DELETE 26 · UPDATE 4 · UPSERT 36 (신규 27 + UPDATE 9)

## 원리
백업 테이블은 영향 36 prd_cd의 **적재 전 junction 전 행(39)** 을 그대로 보존한다. 따라서
"36 prd_cd의 현재 junction 행을 전부 삭제 → 백업 39행을 다시 삽입"하면 적재 전 상태로 정확히 복원된다.
(DELETE 26 대상이던 del='Y' 노드 행도 백업에 포함되어 복원됨.)

## 롤백 SQL (단일 트랜잭션)

```sql
BEGIN;

-- [1] 적재로 변경된 36 prd_cd의 현재 junction 행 전부 제거
DELETE FROM t_prd_product_categories
WHERE prd_cd IN (
  'PRD_000016','PRD_000017','PRD_000018','PRD_000024','PRD_000025','PRD_000026','PRD_000027','PRD_000029',
  'PRD_000031','PRD_000032','PRD_000033','PRD_000041','PRD_000042','PRD_000047','PRD_000052','PRD_000053',
  'PRD_000055','PRD_000066','PRD_000068','PRD_000069','PRD_000071','PRD_000094','PRD_000118','PRD_000120',
  'PRD_000121','PRD_000122','PRD_000124','PRD_000125','PRD_000133','PRD_000134','PRD_000135','PRD_000136',
  'PRD_000137','PRD_000138','PRD_000139','PRD_000145'
);

-- [2] 백업 스냅샷(39행)을 원래대로 복원
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt)
SELECT prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt
FROM bak_pc_green_20260618_1322;

-- [검증] 복원 행수 = 39 인지 확인
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM t_prd_product_categories
  WHERE prd_cd IN (SELECT DISTINCT prd_cd FROM bak_pc_green_20260618_1322);
  IF n <> 39 THEN
    RAISE EXCEPTION '[UNDO] 복원 행수 %, 기대 39 — ROLLBACK', n;
  END IF;
END $$;

COMMIT;
```

## 검증(롤백 후)
```sql
-- 36 prd junction 총 39행으로 복귀했는지
SELECT count(*) FROM t_prd_product_categories
WHERE prd_cd IN (SELECT DISTINCT prd_cd FROM bak_pc_green_20260618_1322);  -- 기대 39
```

## DRY-RUN 권장
실 롤백 전 위 블록의 `COMMIT;` 을 `ROLLBACK;` 으로 바꿔 1회 실행해 DELETE/INSERT 건수·검증 통과를 먼저 확인할 것.

## 정리(롤백 불필요 확정 시)
적재가 안정적으로 확정되면 백업 테이블은 인간 승인 후 `DROP TABLE bak_pc_green_20260618_1322;` 로 정리 가능(권장: 일정 기간 보존).
