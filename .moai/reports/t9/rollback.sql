-- t9 R2 되돌리기 — apply.sql 을 정확히 역으로 되돌린다.
--
-- 되돌린 뒤 상태 = pre_live.txt 와 동일해야 한다:
--   SIZ_000251 dflt_yn='Y' · disp_seq=1 · del_yn='N'
--   SIZ_000181 dflt_yn='N' · disp_seq=2 · del_yn='N'
--   SIZ_000631 del_yn='Y' (물리삭제 아님 — 기초마스터 코드 삭제금지)
--
-- 실행: psql <URL> -f rollback.sql

\set ON_ERROR_STOP 1

BEGIN;

-- ① 레거시 되살리기
UPDATE t_prd_product_sizes
   SET del_yn = 'N', del_dt = NULL, dflt_yn = 'Y', disp_seq = 1, upd_dt = now()
 WHERE prd_cd = 'PRD_000288' AND siz_cd = 'SIZ_000251';

-- ② 신규 연결 논리삭제(행 자체는 남긴다)
UPDATE t_prd_product_sizes
   SET del_yn = 'Y', del_dt = now(), dflt_yn = 'N', upd_dt = now()
 WHERE prd_cd = 'PRD_000288' AND siz_cd = 'SIZ_000631';

\echo '=== 되돌린 뒤 — pre_live.txt 와 대조 ==='
SELECT s.siz_cd, z.siz_nm, s.dflt_yn, s.disp_seq, s.del_yn,
       fn_calc_pansu('SIZ_000499', s.siz_cd) AS pansu
FROM t_prd_product_sizes s JOIN t_siz_sizes z ON z.siz_cd = s.siz_cd
WHERE s.prd_cd = 'PRD_000288' AND s.del_yn = 'N'
ORDER BY s.disp_seq;

COMMIT;
