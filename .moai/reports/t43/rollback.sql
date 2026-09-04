-- t43 rollback — apply.sql 을 그대로 되돌린다
-- ============================================================================
-- [HARD] apply.sql 을 COMMIT 한 뒤에만 의미가 있다. 그 전에는 UPDATE 0 이 정상이다.
-- apply.sql 이 siz_cd 한 칼럼만 옮겼으므로(행 삭제·삽입 없음) 되돌림은 완전 대칭이다.
-- disp_seq·dflt_yn·reg_dt·del_yn 은 apply 가 건드리지 않았으니 복원 대상이 아니다.
-- ============================================================================

BEGIN;

UPDATE t_prd_product_sizes
   SET siz_cd = 'SIZ_000172',
       upd_dt = now()
 WHERE prd_cd = 'PRD_000286'
   AND siz_cd = 'SIZ_000252'
   AND del_yn = 'N';
-- 기대: UPDATE 1

COMMIT;

-- 되돌린 뒤 확인:
--   SELECT ps.siz_cd, s.work_width, s.work_height,
--          fn_calc_pansu('SIZ_000499', ps.siz_cd) AS pansu
--     FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON s.siz_cd = ps.siz_cd
--    WHERE ps.prd_cd = 'PRD_000286' AND ps.del_yn = 'N' ORDER BY ps.disp_seq;
--   → A4 가 SIZ_000172(290x377) · pansu 1 로 돌아와 있어야 한다.
