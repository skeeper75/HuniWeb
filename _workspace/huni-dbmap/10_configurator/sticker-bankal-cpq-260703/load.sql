-- ============================================================================
-- round6-sticker-bankal-cpq-260703 / load.sql
-- L2 CPQ 옵션 레이어 신설: 반칼 스티커 4상품 (052 반칼 자유형 스티커 동형)
--   PRD_000059 반칼정사각 · PRD_000060 반칼직사각 · PRD_000061 반칼띠지 · PRD_000062 반칼팬시
-- 참조 차원행은 전부 라이브 실재-활성(del_yn='N'). 신규 자재/공정 mint 0.
-- 멱등: ON CONFLICT DO NOTHING. 최종 COMMIT = 인간 승인 + webadmin 실화면 확인 후.
-- opt_grp_cd/opt_cd(OPT_/OPV_ 연번)는 라이브 max(OPT_000159/OPV_000638) 다음값.
--   [CONFIRM] 실제 COMMIT 직전 max 재확인 후 필요 시 재채번(멱등키=PK).
-- ============================================================================
BEGIN;

-- ---------------------------------------------------------------------------
-- [커팅 공정 교정·사용자 확정] 059/060/061 = 반칼(뒷지 안 자름)이 맞음.
--   현재 잘못 등록된 스티커완칼(PROC_000055) 은퇴 → 반칼커팅(PROC_000122) 등록.
--   (052 반칼자유형·062 반칼팬시 정답 대조군과 동일 공정). 트리거 선행: 커팅 option_item이 PROC_000122 참조하려면 상품에 실재해야 함.
-- ---------------------------------------------------------------------------
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
SELECT v.prd_cd,'PROC_000122','N',1,now(),'N'
  FROM (VALUES ('PRD_000059'),('PRD_000060'),('PRD_000061')) v(prd_cd)
 WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes p WHERE p.prd_cd=v.prd_cd AND p.proc_cd='PROC_000122');
UPDATE t_prd_product_processes SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd IN ('PRD_000059','PRD_000060','PRD_000061') AND proc_cd='PROC_000055' AND del_yn='N';

-- ---------------------------------------------------------------------------
-- [CONFIRM-062] 062 기존 broken partial 은퇴 (논리삭제)
--   기존: OPT-000040 인쇄(sel_typ NULL, mand N) · OPT-000041 용지(sel_typ NULL, option 5건이나 option_item 0건=미해결)
--   → sel_typ/mand 부재 + 자재 옵션이 차원행 미연결(손님 선택 불가) + 커팅 그룹 없음.
--   아래 신규 052-동형 세트로 대체. undo.sql 로 복원 가능.
-- ---------------------------------------------------------------------------
UPDATE t_prd_product_option_items SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000062'
   AND opt_cd IN ('OPV-000082','OPV-000083','OPV-000084','OPV-000085','OPV-000086','OPV-000087')
   AND del_yn='N';
UPDATE t_prd_product_options SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000062'
   AND opt_cd IN ('OPV-000082','OPV-000083','OPV-000084','OPV-000085','OPV-000086','OPV-000087')
   AND del_yn='N';
UPDATE t_prd_product_option_groups SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000062'
   AND opt_grp_cd IN ('OPT-000040','OPT-000041')
   AND del_yn='N';

-- ---------------------------------------------------------------------------
-- 1) option_groups  (각 상품 3그룹: 종이=자재 / 인쇄=도수 / 커팅=공정, 전부 SEL_TYPE.01 택1·필수)
-- ---------------------------------------------------------------------------
INSERT INTO t_prd_product_option_groups
 (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, note, reg_dt) VALUES
 ('PRD_000059','OPT_000160','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPT_000161','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPT_000162','커팅','SEL_TYPE.01',1,1,'Y',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPT_000163','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPT_000164','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPT_000165','커팅','SEL_TYPE.01',1,1,'Y',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPT_000166','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPT_000167','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPT_000168','커팅','SEL_TYPE.01',1,1,'Y',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPT_000169','종이','SEL_TYPE.01',1,1,'Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPT_000170','인쇄','SEL_TYPE.01',1,1,'Y',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPT_000171','커팅','SEL_TYPE.01',1,1,'Y',3,'Y','N','round6-sticker-bankal-cpq-260703',now())
ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 2) options  (종이=자재 5·인쇄=단면 1·커팅 1, 각 그룹 첫 옵션 dflt_yn='Y')
-- ---------------------------------------------------------------------------
INSERT INTO t_prd_product_options
 (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, note, reg_dt) VALUES
 -- 059 종이
 ('PRD_000059','OPV_000639','OPT_000160','유포스티커','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPV_000640','OPT_000160','비코팅스티커','N',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPV_000641','OPT_000160','미색스티커','N',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPV_000642','OPT_000160','무광코팅스티커','N',4,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPV_000643','OPT_000160','유광코팅스티커','N',5,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPV_000644','OPT_000161','단면','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000059','OPV_000645','OPT_000162','반칼','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 -- 060 종이
 ('PRD_000060','OPV_000646','OPT_000163','유포스티커','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPV_000647','OPT_000163','비코팅스티커','N',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPV_000648','OPT_000163','미색스티커','N',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPV_000649','OPT_000163','무광코팅스티커','N',4,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPV_000650','OPT_000163','유광코팅스티커','N',5,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPV_000651','OPT_000164','단면','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000060','OPV_000652','OPT_000165','반칼','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 -- 061 종이
 ('PRD_000061','OPV_000653','OPT_000166','유포스티커','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPV_000654','OPT_000166','비코팅스티커','N',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPV_000655','OPT_000166','미색스티커','N',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPV_000656','OPT_000166','무광코팅스티커','N',4,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPV_000657','OPT_000166','유광코팅스티커','N',5,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPV_000658','OPT_000167','단면','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000061','OPV_000659','OPT_000168','반칼','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 -- 062 종이 (052-family 자재: 유포584/아트611/미색609/무광585/유광586)
 ('PRD_000062','OPV_000660','OPT_000169','유포스티커','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPV_000661','OPT_000169','아트스티커','N',2,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPV_000662','OPT_000169','미색스티커','N',3,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPV_000663','OPT_000169','무광코팅스티커','N',4,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPV_000664','OPT_000169','유광코팅스티커','N',5,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPV_000665','OPT_000170','단면','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now()),
 ('PRD_000062','OPV_000666','OPT_000171','반칼','Y',1,'Y','N','round6-sticker-bankal-cpq-260703',now())
ON CONFLICT (prd_cd, opt_cd) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 3) option_items  (polymorphic ref_dim_cd → 라이브 활성 차원행. fn_chk_opt_item_ref 정합)
--    종이=OPT_REF_DIM.03 자재(ref_key1=mat_cd, ref_key2=USAGE.07)
--    인쇄=OPT_REF_DIM.06 도수(ref_key1=opt_id='1')
--    커팅=OPT_REF_DIM.04 공정(ref_key1=proc_cd)
-- ---------------------------------------------------------------------------
INSERT INTO t_prd_product_option_items
 (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, reg_dt) VALUES
 -- 059
 ('PRD_000059','OPV_000639',1,'OPT_REF_DIM.03','MAT_000153','USAGE.07',1,'Y','N',now()),
 ('PRD_000059','OPV_000640',1,'OPT_REF_DIM.03','MAT_000084','USAGE.07',1,'Y','N',now()),
 ('PRD_000059','OPV_000641',1,'OPT_REF_DIM.03','MAT_000242','USAGE.07',1,'Y','N',now()),
 ('PRD_000059','OPV_000642',1,'OPT_REF_DIM.03','MAT_000155','USAGE.07',1,'Y','N',now()),
 ('PRD_000059','OPV_000643',1,'OPT_REF_DIM.03','MAT_000156','USAGE.07',1,'Y','N',now()),
 ('PRD_000059','OPV_000644',1,'OPT_REF_DIM.06','1',NULL,1,'Y','N',now()),
 ('PRD_000059','OPV_000645',1,'OPT_REF_DIM.04','PROC_000122',NULL,1,'Y','N',now()),
 -- 060
 ('PRD_000060','OPV_000646',1,'OPT_REF_DIM.03','MAT_000153','USAGE.07',1,'Y','N',now()),
 ('PRD_000060','OPV_000647',1,'OPT_REF_DIM.03','MAT_000084','USAGE.07',1,'Y','N',now()),
 ('PRD_000060','OPV_000648',1,'OPT_REF_DIM.03','MAT_000242','USAGE.07',1,'Y','N',now()),
 ('PRD_000060','OPV_000649',1,'OPT_REF_DIM.03','MAT_000155','USAGE.07',1,'Y','N',now()),
 ('PRD_000060','OPV_000650',1,'OPT_REF_DIM.03','MAT_000156','USAGE.07',1,'Y','N',now()),
 ('PRD_000060','OPV_000651',1,'OPT_REF_DIM.06','1',NULL,1,'Y','N',now()),
 ('PRD_000060','OPV_000652',1,'OPT_REF_DIM.04','PROC_000122',NULL,1,'Y','N',now()),
 -- 061
 ('PRD_000061','OPV_000653',1,'OPT_REF_DIM.03','MAT_000153','USAGE.07',1,'Y','N',now()),
 ('PRD_000061','OPV_000654',1,'OPT_REF_DIM.03','MAT_000084','USAGE.07',1,'Y','N',now()),
 ('PRD_000061','OPV_000655',1,'OPT_REF_DIM.03','MAT_000242','USAGE.07',1,'Y','N',now()),
 ('PRD_000061','OPV_000656',1,'OPT_REF_DIM.03','MAT_000155','USAGE.07',1,'Y','N',now()),
 ('PRD_000061','OPV_000657',1,'OPT_REF_DIM.03','MAT_000156','USAGE.07',1,'Y','N',now()),
 ('PRD_000061','OPV_000658',1,'OPT_REF_DIM.06','1',NULL,1,'Y','N',now()),
 ('PRD_000061','OPV_000659',1,'OPT_REF_DIM.04','PROC_000122',NULL,1,'Y','N',now()),
 -- 062
 ('PRD_000062','OPV_000660',1,'OPT_REF_DIM.03','MAT_000584','USAGE.07',1,'Y','N',now()),
 ('PRD_000062','OPV_000661',1,'OPT_REF_DIM.03','MAT_000611','USAGE.07',1,'Y','N',now()),
 ('PRD_000062','OPV_000662',1,'OPT_REF_DIM.03','MAT_000609','USAGE.07',1,'Y','N',now()),
 ('PRD_000062','OPV_000663',1,'OPT_REF_DIM.03','MAT_000585','USAGE.07',1,'Y','N',now()),
 ('PRD_000062','OPV_000664',1,'OPT_REF_DIM.03','MAT_000586','USAGE.07',1,'Y','N',now()),
 ('PRD_000062','OPV_000665',1,'OPT_REF_DIM.06','1',NULL,1,'Y','N',now()),
 ('PRD_000062','OPV_000666',1,'OPT_REF_DIM.04','PROC_000122',NULL,1,'Y','N',now())
ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;

COMMIT;
