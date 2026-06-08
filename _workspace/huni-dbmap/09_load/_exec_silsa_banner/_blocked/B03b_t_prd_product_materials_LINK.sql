-- =====================================================================
-- step B-03b — t_prd_product_materials (BLOCKED-LINK — 자재 링크 선적재)
-- [v2] PRD_000138 자재 링크. 끈 MAT_000070·양면테입 MAT_000069=실코드 즉시. mint분(큐방·각목·봉제사)=채번 후
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
-- [HARD] 트리거 .03 = (mat_cd, usage_cd) BOTH in t_prd_product_materials(prd_cd) 강제.
--   자재 seq option_items(B04)의 선행. PK=(prd_cd,mat_cd,usage_cd). dflt_yn NOT NULL(옵션 부속이라 'N').
-- [멱등] ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING.
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)
VALUES ('PRD_000138', 'MAT_000069', 'USAGE.07', 'N', 1, now())
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- [mint 후 활성화] [CONFIRM-MAT 봉제사] (큐방/각목/봉제사 mint 후 채번된 mat_cd 로 치환):
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)
-- VALUES ('PRD_000138', '[CONFIRM-CHANNEL mat_cd]', 'USAGE.07', 'N', 1, now())
-- ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- [mint 후 활성화] [CONFIRM-MAT 큐방] (큐방/각목/봉제사 mint 후 채번된 mat_cd 로 치환):
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)
-- VALUES ('PRD_000138', '[CONFIRM-CHANNEL mat_cd]', 'USAGE.07', 'N', 1, now())
-- ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)
VALUES ('PRD_000138', 'MAT_000070', 'USAGE.07', 'N', 1, now())
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- [mint 후 활성화] [CONFIRM-MAT 각목900이하] (큐방/각목/봉제사 mint 후 채번된 mat_cd 로 치환):
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)
-- VALUES ('PRD_000138', '[CONFIRM-CHANNEL mat_cd]', 'USAGE.07', 'N', 1, now())
-- ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- [mint 후 활성화] [CONFIRM-MAT 각목900초과] (큐방/각목/봉제사 mint 후 채번된 mat_cd 로 치환):
-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)
-- VALUES ('PRD_000138', '[CONFIRM-CHANNEL mat_cd]', 'USAGE.07', 'N', 1, now())
-- ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
