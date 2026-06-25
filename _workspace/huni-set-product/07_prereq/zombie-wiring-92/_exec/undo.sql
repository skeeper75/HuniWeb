-- undo.sql (zombie-wiring-92 _exec) — 확정 4건 교정 되돌리기 (백업 복원·권장)
-- 백업 테이블 선행 필요(backup.sql):
--   bak_t_mat_materials_zombiewire_20260625_053924 (자재 4행)
--   bak_t_prd_product_materials_zombiewire_20260625_053924 (배선 35행)
-- 단일 트랜잭션 래핑. 멱등(IS DISTINCT FROM 가드).
-- ★복원 순서: 배선 복원이 핵심(REWIRE로 mat_cd가 정본으로 바뀐 행을 좀비 mat_cd로 되돌림).
--   PK가 mat_cd 포함이므로 REWIRE된 행은 새 PK로 존재 -> 백업과 PK가 다름.
--   따라서 복원 = (정본으로 바뀐 신규 행 삭제) + (백업의 원래 좀비 행 재삽입). 아래 안전 절차.

BEGIN;

-- ── 부1: 자재 복원 (008/261 del_yn N->Y 원상, 260/270 원상) ──
UPDATE t_mat_materials m
   SET del_yn = b.del_yn, del_dt = b.del_dt
  FROM bak_t_mat_materials_zombiewire_20260625_053924 b
 WHERE m.mat_cd = b.mat_cd
   AND (m.del_yn IS DISTINCT FROM b.del_yn OR m.del_dt IS DISTINCT FROM b.del_dt);

-- ── 부2: 배선 복원 ──
-- (1) REWIRE로 정본(250/343)에 새로 생긴 행 중, 백업에 좀비(260/270)로 있던 (prd_cd,usage_cd) 조합 삭제
DELETE FROM t_prd_product_materials cur
 USING bak_t_prd_product_materials_zombiewire_20260625_053924 b
 WHERE b.mat_cd IN ('MAT_000260','MAT_000270')
   AND cur.prd_cd = b.prd_cd AND cur.usage_cd = b.usage_cd
   AND cur.mat_cd = CASE b.mat_cd WHEN 'MAT_000260' THEN 'MAT_000250' WHEN 'MAT_000270' THEN 'MAT_000343' END;

-- (2) 백업의 원래 좀비 배선 행 전부 재삽입(없는 것만) — 260/270 좀비 + 충돌 softdel 원상 포함
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, upd_dt, del_yn, del_dt)
SELECT b.prd_cd, b.mat_cd, b.usage_cd, b.dflt_yn, b.disp_seq, b.reg_dt, b.upd_dt, b.del_yn, b.del_dt
  FROM bak_t_prd_product_materials_zombiewire_20260625_053924 b
 WHERE b.mat_cd IN ('MAT_000260','MAT_000270')
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_materials cur
                   WHERE cur.prd_cd=b.prd_cd AND cur.mat_cd=b.mat_cd AND cur.usage_cd=b.usage_cd);

-- (008/261 배선은 mat_cd 불변·자재 del_yn만 원복했으므로 배선 행 자체 변경 없음 — 추가 작업 불요)

COMMIT;

-- 검증: 4건 원상 복귀 확인
SELECT 'mat_4' AS chk, mat_cd, mat_nm, del_yn FROM t_mat_materials WHERE mat_cd IN ('MAT_000008','MAT_000261','MAT_000260','MAT_000270') ORDER BY mat_cd;
SELECT 'wire_260' AS chk, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000260' AND del_yn='N';  -- 기대 7
SELECT 'wire_270' AS chk, count(*) AS v FROM t_prd_product_materials WHERE mat_cd='MAT_000270' AND del_yn='N';  -- 기대 1
