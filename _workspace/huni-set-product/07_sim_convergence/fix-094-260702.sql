-- ============================================================================
-- fix-094-260702.sql — 엽서북 셋트(PRD_000094) DATA 트랙 교정 (R1-D1 + R1-D2)
-- 실행: psql --single-transaction -v ON_ERROR_STOP=1 -f fix-094-260702.sql
-- 멱등: 전 문장 ON CONFLICT DO NOTHING (복합 PK/자연키 기준)
-- 스코프: PRD_000094/095/096 만. 부모 행 삭제/이동 없음(복사 추가만). 물리 DELETE 없음.
-- 권위: 상품마스터 260610 엽서북 = 부모 PRD_000094 라이브 등록분(3사이즈/2자재/2인쇄옵션) 미러.
--       판형 SIZ_000499(국4절 316x467)=구성원 095 라이브 기등록 미러(fn_calc_pansu 9/6/9>0).
-- ============================================================================

-- [R1-D1-①] 구성원 사이즈 — 부모 094의 3사이즈를 095/096에 복사(dflt=SIZ_000003)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, del_yn)
VALUES
  ('PRD_000095','SIZ_000003','Y',1,'N'),
  ('PRD_000095','SIZ_000004','N',2,'N'),
  ('PRD_000095','SIZ_000124','N',3,'N'),
  ('PRD_000096','SIZ_000003','Y',1,'N'),
  ('PRD_000096','SIZ_000004','N',2,'N'),
  ('PRD_000096','SIZ_000124','N',3,'N')
ON CONFLICT (prd_cd, siz_cd) DO NOTHING;

-- [R1-D1-②] 구성원 자재 — 내지=몽블랑240(USAGE.01)/표지=스노우300(USAGE.02)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, del_yn)
VALUES
  ('PRD_000095','MAT_000109','USAGE.01','Y',1,'N'),
  ('PRD_000096','MAT_000092','USAGE.02','Y',1,'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;

-- [R1-D1-③] 구성원 인쇄옵션 — 부모 행 미러(단면 CLR_000005/CLR_000001 dflt Y·양면 5/5),
--            opt_id = 해당 상품 내 MAX+1 채번(PK=(prd_cd,opt_id)·자연키 유니크로 멱등)
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, del_yn, print_opt_cd)
SELECT 'PRD_000095', COALESCE((SELECT MAX(opt_id) FROM t_prd_product_print_options WHERE prd_cd='PRD_000095'),0)+1,
       '단면','CLR_000005','CLR_000001','Y',1,'N','POPT_000001'
ON CONFLICT (prd_cd, print_side, front_colrcnt_cd, back_colrcnt_cd) DO NOTHING;

INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, del_yn, print_opt_cd)
SELECT 'PRD_000095', COALESCE((SELECT MAX(opt_id) FROM t_prd_product_print_options WHERE prd_cd='PRD_000095'),0)+1,
       '양면','CLR_000005','CLR_000005','N',2,'N','POPT_000002'
ON CONFLICT (prd_cd, print_side, front_colrcnt_cd, back_colrcnt_cd) DO NOTHING;

INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, del_yn, print_opt_cd)
SELECT 'PRD_000096', COALESCE((SELECT MAX(opt_id) FROM t_prd_product_print_options WHERE prd_cd='PRD_000096'),0)+1,
       '단면','CLR_000005','CLR_000001','Y',1,'N','POPT_000001'
ON CONFLICT (prd_cd, print_side, front_colrcnt_cd, back_colrcnt_cd) DO NOTHING;

INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, del_yn, print_opt_cd)
SELECT 'PRD_000096', COALESCE((SELECT MAX(opt_id) FROM t_prd_product_print_options WHERE prd_cd='PRD_000096'),0)+1,
       '양면','CLR_000005','CLR_000005','N',2,'N','POPT_000002'
ON CONFLICT (prd_cd, print_side, front_colrcnt_cd, back_colrcnt_cd) DO NOTHING;

-- [R1-D2] 부모 094 라이브 판형 등록 — 구성원 095 기등록 SIZ_000499(국4절) 미러.
--         기존 del_yn=Y 6행(완제품사이즈 오적재분)은 복원하지 않음(스코프 외·금지).
INSERT INTO t_prd_product_plate_sizes
  (prd_cd, siz_cd, dflt_plt_yn, output_file_typ, note, item_siz_cd, del_yn)
VALUES
  ('PRD_000094','SIZ_000499','Y','PDF','엽서북 셋트 판형 국4절 등록(260702 R1-D2 교정·구성원 095 미러)','','N')
ON CONFLICT (prd_cd, siz_cd, item_siz_cd) DO NOTHING;
