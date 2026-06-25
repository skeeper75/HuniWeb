-- =====================================================================
-- w2-apply.sql — W2 CPQ 옵션화 COMMIT 범위(머그컵 제외) 실 적재
-- =====================================================================
-- 범위: 9상품 / 9 option_group / 29 option / 29 option_item
--       T1 면지(PRD_072·077·082·088) + T3 즉시(PRD_140·142·197·198·217).
--       ★머그컵(PRD_193) 제외 — codex 의미축 분류 불일치(HOLD).
-- 채번: 라이브 MAX(OPT_000063 / OPV_000433) +1 연속, 머그컵 제거분 재정렬 반영.
--       opt_grp_cd OPT_000064~OPT_000072 (9) · opt_cd OPV_000434~OPV_000462 (29).
-- 멱등: 전 INSERT에 ON CONFLICT (PK) DO NOTHING. 재실행 시 delta 0.
-- FK 위상: groups → options → option_items (option_items INSERT 시 트리거 발화).
-- 트랜잭션: 단일 BEGIN…COMMIT. ★실제 COMMIT은 메인이 수행. 본 파일은 빌드 산출물.
--   - DRY-RUN 검증은 w2-dryrun.sql(BEGIN…ROLLBACK)에서.
--   - 신규 mint = option layer만(자재/상품/차원 신규 0).
-- 돈영향: 적재 자재 component_prices = 0행(실측). 옵션 선택이 가격 불변.
-- =====================================================================

\set ON_ERROR_STOP on

BEGIN;

-- ---------------------------------------------------------------
-- 1) t_prd_product_option_groups (9행)
-- ---------------------------------------------------------------
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000072','OPT_000064','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000077','OPT_000065','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000082','OPT_000066','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000088','OPT_000067','면지색','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000140','OPT_000068','색상','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000142','OPT_000069','색상','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000197','OPT_000070','색상','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000198','OPT_000071','색상','SEL_TYPE.01',1,1,'Y',1,'Y','N'),
  ('PRD_000217','OPT_000072','잉크색','SEL_TYPE.01',1,1,'Y',1,'Y','N')
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- 2) t_prd_product_options (29행)
-- ---------------------------------------------------------------
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000072','OPV_000434','OPT_000064','화이트','Y',1,'Y','N'),
  ('PRD_000072','OPV_000435','OPT_000064','블랙','N',2,'Y','N'),
  ('PRD_000072','OPV_000436','OPT_000064','그레이','N',3,'Y','N'),
  ('PRD_000077','OPV_000437','OPT_000065','화이트','Y',1,'Y','N'),
  ('PRD_000077','OPV_000438','OPT_000065','블랙','N',2,'Y','N'),
  ('PRD_000077','OPV_000439','OPT_000065','그레이','N',3,'Y','N'),
  ('PRD_000082','OPV_000440','OPT_000066','화이트','Y',1,'Y','N'),
  ('PRD_000082','OPV_000441','OPT_000066','블랙','N',2,'Y','N'),
  ('PRD_000082','OPV_000442','OPT_000066','그레이','N',3,'Y','N'),
  ('PRD_000082','OPV_000443','OPT_000066','인쇄','N',4,'Y','N'),
  ('PRD_000088','OPV_000444','OPT_000067','화이트','Y',1,'Y','N'),
  ('PRD_000088','OPV_000445','OPT_000067','블랙','N',2,'Y','N'),
  ('PRD_000088','OPV_000446','OPT_000067','그레이','N',3,'Y','N'),
  ('PRD_000088','OPV_000447','OPT_000067','인쇄','N',4,'Y','N'),
  ('PRD_000140','OPV_000448','OPT_000068','화이트','Y',1,'Y','N'),
  ('PRD_000140','OPV_000449','OPT_000068','블랙','N',2,'Y','N'),
  ('PRD_000142','OPV_000450','OPT_000069','화이트','Y',1,'Y','N'),
  ('PRD_000142','OPV_000451','OPT_000069','블랙','N',2,'Y','N'),
  ('PRD_000197','OPV_000452','OPT_000070','화이트','Y',1,'Y','N'),
  ('PRD_000197','OPV_000453','OPT_000070','블랙','N',2,'Y','N'),
  ('PRD_000198','OPV_000454','OPT_000071','화이트','Y',1,'Y','N'),
  ('PRD_000198','OPV_000455','OPT_000071','블랙','N',2,'Y','N'),
  ('PRD_000217','OPV_000456','OPT_000072','청보라','Y',1,'Y','N'),
  ('PRD_000217','OPV_000457','OPT_000072','빨강','N',2,'Y','N'),
  ('PRD_000217','OPV_000458','OPT_000072','검정','N',3,'Y','N'),
  ('PRD_000217','OPV_000459','OPT_000072','파랑','N',4,'Y','N'),
  ('PRD_000217','OPV_000460','OPT_000072','초록','N',5,'Y','N'),
  ('PRD_000217','OPV_000461','OPT_000072','핑크','N',6,'Y','N'),
  ('PRD_000217','OPV_000462','OPT_000072','노랑','N',7,'Y','N')
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- 3) t_prd_product_option_items (29행) — INSERT 시 trg_..._chk_ref 발화
--    (OPT_REF_DIM.03 → t_prd_product_materials(prd_cd,mat_cd,usage_cd) EXISTS)
-- ---------------------------------------------------------------
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
VALUES
  ('PRD_000072','OPV_000434',1,'OPT_REF_DIM.03','MAT_000001','USAGE.03',1,'Y','N'),
  ('PRD_000072','OPV_000435',1,'OPT_REF_DIM.03','MAT_000002','USAGE.03',1,'Y','N'),
  ('PRD_000072','OPV_000436',1,'OPT_REF_DIM.03','MAT_000003','USAGE.03',1,'Y','N'),
  ('PRD_000077','OPV_000437',1,'OPT_REF_DIM.03','MAT_000001','USAGE.03',1,'Y','N'),
  ('PRD_000077','OPV_000438',1,'OPT_REF_DIM.03','MAT_000002','USAGE.03',1,'Y','N'),
  ('PRD_000077','OPV_000439',1,'OPT_REF_DIM.03','MAT_000003','USAGE.03',1,'Y','N'),
  ('PRD_000082','OPV_000440',1,'OPT_REF_DIM.03','MAT_000001','USAGE.03',1,'Y','N'),
  ('PRD_000082','OPV_000441',1,'OPT_REF_DIM.03','MAT_000002','USAGE.03',1,'Y','N'),
  ('PRD_000082','OPV_000442',1,'OPT_REF_DIM.03','MAT_000003','USAGE.03',1,'Y','N'),
  ('PRD_000082','OPV_000443',1,'OPT_REF_DIM.03','MAT_000004','USAGE.03',1,'Y','N'),
  ('PRD_000088','OPV_000444',1,'OPT_REF_DIM.03','MAT_000001','USAGE.03',1,'Y','N'),
  ('PRD_000088','OPV_000445',1,'OPT_REF_DIM.03','MAT_000002','USAGE.03',1,'Y','N'),
  ('PRD_000088','OPV_000446',1,'OPT_REF_DIM.03','MAT_000003','USAGE.03',1,'Y','N'),
  ('PRD_000088','OPV_000447',1,'OPT_REF_DIM.03','MAT_000004','USAGE.03',1,'Y','N'),
  ('PRD_000140','OPV_000448',1,'OPT_REF_DIM.03','MAT_000255','USAGE.07',1,'Y','N'),
  ('PRD_000140','OPV_000449',1,'OPT_REF_DIM.03','MAT_000256','USAGE.07',1,'Y','N'),
  ('PRD_000142','OPV_000450',1,'OPT_REF_DIM.03','MAT_000255','USAGE.07',1,'Y','N'),
  ('PRD_000142','OPV_000451',1,'OPT_REF_DIM.03','MAT_000256','USAGE.07',1,'Y','N'),
  ('PRD_000197','OPV_000452',1,'OPT_REF_DIM.03','MAT_000255','USAGE.07',1,'Y','N'),
  ('PRD_000197','OPV_000453',1,'OPT_REF_DIM.03','MAT_000256','USAGE.07',1,'Y','N'),
  ('PRD_000198','OPV_000454',1,'OPT_REF_DIM.03','MAT_000255','USAGE.07',1,'Y','N'),
  ('PRD_000198','OPV_000455',1,'OPT_REF_DIM.03','MAT_000256','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000456',1,'OPT_REF_DIM.03','MAT_000297','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000457',1,'OPT_REF_DIM.03','MAT_000298','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000458',1,'OPT_REF_DIM.03','MAT_000299','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000459',1,'OPT_REF_DIM.03','MAT_000300','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000460',1,'OPT_REF_DIM.03','MAT_000301','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000461',1,'OPT_REF_DIM.03','MAT_000302','USAGE.07',1,'Y','N'),
  ('PRD_000217','OPV_000462',1,'OPT_REF_DIM.03','MAT_000303','USAGE.07',1,'Y','N')
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;

-- ---------------------------------------------------------------
-- 적재 후 행수 보고(기대: groups 9 / options 29 / items 29 신규)
-- ---------------------------------------------------------------
\echo '== 적재 후 9상품 행수(기대 grp=9 opt=29 item=29) =='
SELECT 'groups' lvl, count(*) FROM t_prd_product_option_groups
  WHERE opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072'
UNION ALL
SELECT 'options', count(*) FROM t_prd_product_options
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
UNION ALL
SELECT 'items', count(*) FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';

COMMIT;
-- ★실 적재 시에만 COMMIT 유효. 검증은 w2-dryrun.sql 사용.
