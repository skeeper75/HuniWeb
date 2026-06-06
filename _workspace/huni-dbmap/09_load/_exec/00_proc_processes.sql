-- 00_proc_processes.sql
-- 단계00a 코드행 선적재 — 레이저커팅 PROC_000084. PK pk_t_proc_processes(proc_cd).
-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: 00_proc_laser.csv:row2 proc_cd=PROC_000084
INSERT INTO t_proc_processes (proc_cd, proc_nm, upr_proc_cd, prcs_dtl_opt, disp_seq, use_yn, note)
VALUES ('PROC_000084', '레이저커팅', NULL, NULL, 15, 'Y', '아크릴 모양컷 도메인공정(레이저커팅). 053 완칼=종이/스티커 전용이라 의미 부정확 → 신설(K-2).')
ON CONFLICT (proc_cd) DO NOTHING;
