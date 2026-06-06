-- backup_q_coderows.sql — 코드행 타깃 선존 진단 — proc/siz 신설 대상이 적재 전 부재여야 정상. read-only.
-- 생성: gen_safety_sql.py (손편집 금지). COPY ... TO STDOUT — 셸이 파일로 리다이렉트.
COPY (SELECT 't_proc_processes' AS tbl, proc_cd AS k FROM t_proc_processes WHERE proc_cd = 'PROC_000084' UNION ALL SELECT 't_siz_sizes', siz_cd FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000501','SIZ_000502','SIZ_000503','SIZ_000504','SIZ_000505','SIZ_000506','SIZ_000507','SIZ_000508','SIZ_000509','SIZ_000510') ORDER BY tbl, k) TO STDOUT WITH (FORMAT csv, HEADER true);
