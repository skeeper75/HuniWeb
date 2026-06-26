-- UNDO: 명함 자재 단가행 전개 복원 (260626) — 교정 10행 삭제 후 원본 4행 복원
BEGIN;
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
   AND min_qty=100 AND print_opt_cd IN ('POPT_000001','POPT_000002')
   AND mat_cd IN ('MAT_000074','MAT_000081','MAT_000082','MAT_000091','MAT_000092');
INSERT INTO t_prc_component_prices (comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price,note) VALUES
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000074','POPT_000001',100,3500.00,'원복'),
('COMP_NAMECARD_STD_S1','2026-06-01','MAT_000082','POPT_000001',100,3800.00,'원복'),
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000074','POPT_000002',100,4500.00,'원복'),
('COMP_NAMECARD_STD_S2','2026-06-01','MAT_000082','POPT_000002',100,4800.00,'원복');
-- 검증 후 COMMIT;
