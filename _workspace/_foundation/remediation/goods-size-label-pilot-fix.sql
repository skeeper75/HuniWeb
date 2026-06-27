-- goods-size-label-pilot-fix.sql — 230 레더 플랫 사이즈 라벨 옵션 실제 저장(COMMIT)
-- 방식 B: 기존 옵션장치(그룹→옵션→아이템)로 라벨(M/L)→크기코드→가격축 연결. 새 속성/코드 0.
BEGIN;
INSERT INTO t_prd_product_option_groups
 (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn)
VALUES ('PRD_000230','OPT_000073','사이즈','SEL_TYPE.01',1,1,'Y',1,'Y');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
VALUES ('PRD_000230','OPV_000463','OPT_000073','M','Y',1,'Y'),
       ('PRD_000230','OPV_000464','OPT_000073','L','N',2,'Y');
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn)
VALUES ('PRD_000230','OPV_000463',1,'OPT_REF_DIM.01','SIZ_000433',1,'Y'),
       ('PRD_000230','OPV_000464',1,'OPT_REF_DIM.01','SIZ_000434',1,'Y');
DO $$
DECLARE v int;
BEGIN
  SELECT count(*) INTO v FROM t_prd_product_option_items oi
   WHERE oi.prd_cd='PRD_000230' AND oi.ref_dim_cd='OPT_REF_DIM.01'
     AND oi.ref_key1 IN (SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='PRD_000230' AND COALESCE(del_yn,'N')<>'Y');
  IF v<>2 THEN RAISE EXCEPTION '검증 실패: 라벨→크기 연결 %건(기대 2)',v; END IF;
  RAISE NOTICE '저장 OK: 230 손님라벨 M/L→크기코드→가격축 연결';
END $$;
COMMIT;
