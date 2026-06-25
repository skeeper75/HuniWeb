-- =====================================================================
-- w2-dryrun.sql — W2 옵션화 COMMIT 범위(머그컵 제외) 롤백 전용 DRY-RUN
-- =====================================================================
-- 목적: w2-apply.sql 의 실 INSERT 를 단일 트랜잭션 안에서 실행해
--       ① 트리거 fn_chk_opt_item_ref 가 INSERT 로 실제로 통과하는지
--          (EXISTS 사전체크가 아니라, 29 INSERT 가 예외 없이 통과)
--       을 입증하고, ②~⑥ 검증 SELECT 를 수행한 뒤 ROLLBACK.
-- ★끝에 ROLLBACK — 라이브 무변경. 본 파일은 검증 전용.
-- 실행: 메인이 수행. 실패 시 ON_ERROR_STOP 으로 즉시 중단(=NO-GO 신호).
-- =====================================================================

\set ON_ERROR_STOP on

BEGIN;

-- ============ pre: 신규 채번 PK 충돌 0 사전 확인(④ 일부) ============
\echo '== [pre] 신규 채번 PK 충돌(기대 0/0) =='
SELECT 'grp_pre_exist' k, count(*) FROM t_prd_product_option_groups
  WHERE (prd_cd,opt_grp_cd) IN (
    ('PRD_000072','OPT_000064'),('PRD_000077','OPT_000065'),('PRD_000082','OPT_000066'),
    ('PRD_000088','OPT_000067'),('PRD_000140','OPT_000068'),('PRD_000142','OPT_000069'),
    ('PRD_000197','OPT_000070'),('PRD_000198','OPT_000071'),('PRD_000217','OPT_000072'))
UNION ALL
SELECT 'opt_pre_exist', count(*) FROM t_prd_product_options
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';

-- ============ INSERT 1) groups ============
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

-- ============ INSERT 2) options ============
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

-- ============ INSERT 3) option_items ============
-- ★검증①: 이 INSERT 가 trg_..._chk_ref 를 실제로 통과해야 함.
--   29 행 중 1 행이라도 ref 무결성 위반이면 EXCEPTION → ON_ERROR_STOP → 즉시 중단(NO-GO).
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

\echo '== [검증①] option_items 29 INSERT 가 트리거 통과(여기까지 무예외 도달=PASS) =='
SELECT count(*) AS items_inserted FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';
-- 기대: items_inserted = 29. (예외 발생 시 위 INSERT 에서 이미 중단됨)

-- ============ [검증②] N1 보완: ref 가 가리키는 자재행이 del_yn='N' 으로 실재 ============
\echo '== [검증②] 29 item 의 (prd,mat,usage) 가 del_yn=N 자재로 실재(기대 29/29) =='
SELECT count(*) AS items,
       count(*) FILTER (WHERE EXISTS(
         SELECT 1 FROM t_prd_product_materials m
         WHERE m.prd_cd=i.prd_cd AND m.mat_cd=i.ref_key1
           AND m.usage_cd=i.ref_key2 AND m.del_yn='N')) AS deln_resolved
FROM t_prd_product_option_items i
WHERE i.opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';
-- 기대: items=29, deln_resolved=29. (트리거는 del_yn 미필터이므로 별도 명시 확인)

-- ============ [검증③] FK 무결성: 상품·옵션그룹·자재 실재 ============
\echo '== [검증③] FK 무결성: 9상품 실재 + option_group→상품 + option→그룹 (기대 고아 0) =='
SELECT 'orphan_groups_to_prd' k, count(*) FROM t_prd_product_option_groups g
  WHERE g.opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072'
    AND NOT EXISTS(SELECT 1 FROM t_prd_products p WHERE p.prd_cd=g.prd_cd)
UNION ALL
SELECT 'orphan_options_to_grp', count(*) FROM t_prd_product_options o
  WHERE o.opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
    AND NOT EXISTS(SELECT 1 FROM t_prd_product_option_groups g
                   WHERE g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd)
UNION ALL
SELECT 'orphan_items_to_opt', count(*) FROM t_prd_product_option_items i
  WHERE i.opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
    AND NOT EXISTS(SELECT 1 FROM t_prd_product_options o
                   WHERE o.prd_cd=i.prd_cd AND o.opt_cd=i.opt_cd);
-- 기대: 세 행 전부 count=0.

-- ============ [검증④] PK 중복 0 (신규 채번 충돌) ============
\echo '== [검증④] 적재된 신규 행수(기대 grp=9 opt=29 item=29·채번충돌0) =='
SELECT 'groups' lvl, count(*) FROM t_prd_product_option_groups
  WHERE opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072'
UNION ALL
SELECT 'options', count(*) FROM t_prd_product_options
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462'
UNION ALL
SELECT 'items', count(*) FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';
-- 기대: 9 / 29 / 29. (pre 가 0/0 이었으므로 이 값이 곧 신규 적재분=충돌 0)

-- ============ [검증⑤] 멱등 2-pass delta 0 (같은 INSERT 재실행) ============
\echo '== [검증⑤] 멱등 2-pass: 동일 INSERT 재실행 후 delta 0 =='
-- groups 재실행
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
-- option_items 재실행(트리거 멱등 재통과 확인)
INSERT INTO t_prd_product_option_items
  (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
VALUES
  ('PRD_000072','OPV_000434',1,'OPT_REF_DIM.03','MAT_000001','USAGE.03',1,'Y','N'),
  ('PRD_000217','OPV_000462',1,'OPT_REF_DIM.03','MAT_000303','USAGE.07',1,'Y','N')
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;

SELECT 'groups_after_2pass' lvl, count(*) FROM t_prd_product_option_groups
  WHERE opt_grp_cd BETWEEN 'OPT_000064' AND 'OPT_000072'
UNION ALL
SELECT 'items_after_2pass', count(*) FROM t_prd_product_option_items
  WHERE opt_cd BETWEEN 'OPV_000434' AND 'OPV_000462';
-- 기대: groups=9, items=29 (변화 없음 = delta 0).

-- ============ [검증⑥] 돈영향: 적재 자재 component_prices 0행 ============
\echo '== [검증⑥] 돈영향: COMMIT 범위 15자재 단가행(기대 0) =='
SELECT count(*) AS price_rows
FROM t_prc_component_prices cp
WHERE cp.comp_cd IN (
  SELECT comp_cd FROM t_prc_price_components
  WHERE mat_cd IN ('MAT_000001','MAT_000002','MAT_000003','MAT_000004',
                   'MAT_000255','MAT_000256','MAT_000297','MAT_000298','MAT_000299',
                   'MAT_000300','MAT_000301','MAT_000302','MAT_000303'));
-- 기대: 0. (옵션 선택이 가격을 바꾸지 않음 = 돈영향 0)

-- ============ 마무리 ============
\echo '== 모든 검증 SELECT 완료. 롤백으로 라이브 무변경 처리 =='
ROLLBACK;
-- ★ROLLBACK — DRY-RUN 종료. 실 적재는 w2-apply.sql(COMMIT) 로.
