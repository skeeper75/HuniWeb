-- backup.sql (_exec) — 물리 백업 테이블 2종 (COMMIT 직전 실행)
-- 부1: 부활 10행(t_mat_materials)  /  부2: 굿즈 PET 대상 행(t_prd_product_materials)
-- 백업 = 교정 전 상태 스냅샷. 복원은 undo.sql. 멱등(DROP IF EXISTS 후 재생성).
-- 라이브 변경 없음(CREATE TABLE AS SELECT). 자격증명은 .env.local에서만.

-- ── 부1 백업: 부활 대상 자재 10행 ──
DROP TABLE IF EXISTS bak_t_mat_materials_w1_20260624_1137;
CREATE TABLE bak_t_mat_materials_w1_20260624_1137 AS
SELECT mat_cd, mat_nm, mat_typ_cd, upr_mat_cd, sel_typ_cd,
       use_yn, del_yn, del_dt, upd_dt, now() AS backup_dt
  FROM t_mat_materials
 WHERE mat_cd IN (
        'MAT_000246',  -- P2-A 전용지
        'MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100',
        'MAT_000103','MAT_000122','MAT_000143','MAT_000146'  -- P3-A 종이 root 9
       );

-- ── 부2 백업: 굿즈 PET(143/146) 대상 배선 행 (CONFIRM 분리분 — 변경하지 않으나 증거 보존) ──
DROP TABLE IF EXISTS bak_t_prd_product_materials_w1goods_20260624_1137;
CREATE TABLE bak_t_prd_product_materials_w1goods_20260624_1137 AS
SELECT prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq,
       reg_dt, upd_dt, del_yn, del_dt, now() AS backup_dt
  FROM t_prd_product_materials
 WHERE mat_cd IN ('MAT_000143','MAT_000146');

-- 백업 행수 확인:
SELECT 'bak_mat(부1)' AS tbl, count(*) AS rows FROM bak_t_mat_materials_w1_20260624_1137
UNION ALL
SELECT 'bak_goods(부2)', count(*) FROM bak_t_prd_product_materials_w1goods_20260624_1137;
-- 기대: 부1=10행(전부 del_yn='Y'), 부2=3행(전부 wire del_yn='N').
