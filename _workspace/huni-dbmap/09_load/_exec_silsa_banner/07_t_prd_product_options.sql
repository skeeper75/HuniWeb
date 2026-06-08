-- =====================================================================
-- step 07 — t_prd_product_options
-- 가공6+추가5 = 11 options(헤더, 트리거 없음). PK=(prd_cd,opt_cd) → ON CONFLICT DO NOTHING
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-YEOLJAEDAN', 'OG-GAGONG', '열재단', 'Y', 1, 'Y', 'process-only (천 자체 열절단·추가자재 없음). item=신규 PROC_000084 — 공정 신설 인간승인 대기 BLOCKED (M-1 ① 확정·완칼 차용 폐기)', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-TAGONG4', 'OG-GAGONG', '타공(4개)', 'N', 2, 'Y', 'PROCESS-ONLY [사용자 확정 bare-hole]: 구멍만·아일렛 안 끼움 → 공정 타공 PROC_000079 {구수:4}만(.04 seq1). 아일렛 자재 seq/mint 철회', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-TAGONG6', 'OG-GAGONG', '타공(6개)', 'N', 3, 'Y', 'PROCESS-ONLY [bare-hole]: 공정 타공 PROC_000079 {구수:6}만', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-TAGONG8', 'OG-GAGONG', '타공(8개)', 'N', 4, 'Y', 'PROCESS-ONLY [bare-hole]: 공정 타공 PROC_000079 {구수:8}만', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-YANGMYEONTAPE', 'OG-GAGONG', '양면테입', 'N', 5, 'Y', 'BUNDLE: 자재 양면테입 MAT_000069(라이브 EXISTS) + 공정 부착 PROC_000081 {대상:테입}. 양면테입=자재이자 공정 (사용자 모델 직접 사례)', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-GAGONG-BONGMISING', 'OG-GAGONG', '봉미싱', 'N', 6, 'Y', 'BUNDLE [사용자 확정 실=자재]: 자재 봉제사/실 [CONFIRM-MAT mint MAT_TYPE.07] + 공정 봉제 PROC_000080 {유형:봉미싱}. 소모성→자재 미등록 후보 철회', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-NONE', 'OG-CHUGA', '추가없음', 'Y', 1, 'Y', '선택안함 센티넬 (option_item 0행)', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-QBANG4', 'OG-CHUGA', '큐방(4개)추가', 'N', 2, 'Y', 'BUNDLE: 자재 큐방 [CONFIRM-MAT 미존재 mint] + 공정 부착 PROC_000081 {대상:큐방 [CONFIRM enum]}', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-STRING4', 'OG-CHUGA', '끈(4개)추가', 'N', 3, 'Y', 'BUNDLE: 자재 끈 MAT_000070(라이브 EXISTS) + 공정 부착 PROC_000081 {대상:끈}', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-LE900', 'OG-CHUGA', '각목(900이하)+끈(4개) 추가', 'N', 4, 'Y', 'MULTI-BUNDLE: 자재 각목 [CONFIRM-MAT mint] + 자재 끈 MAT_000070 + 공정 부착 PROC_000081(끈). 각목=목재 자재(set 아님 정정)', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)
VALUES ('PRD_000138', 'OP-CHUGA-GAKMOK-GT900', 'OG-CHUGA', '각목(900초과)+끈(4개) 추가', 'N', 5, 'Y', 'MULTI-BUNDLE: 자재 각목 [CONFIRM-MAT mint] + 자재 끈 MAT_000070 + 공정 부착 PROC_000081(끈)', now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;
