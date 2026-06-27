-- ============================================================================
-- goods-size-label-pilot-dryrun.sql — 굿즈 사이즈 라벨 옵션 시범(230 레더 플랫) DRY-RUN
--   방식 B: 기존 옵션 장치(그룹→옵션→아이템)로 손님용 라벨(M/L) 부여.
--   새 코드/새 속성 0 — 기존 엔티티만 사용. 라벨(opt_nm) → 크기코드(siz_cd) → (가격공식 siz_cd 매칭).
--   t_prd_product_sizes(생산 치수)는 시범1에서 이미 연결됨(230→SIZ_433/434). 여기선 라벨 옵션만 추가.
-- 채번: opt_grp OPT_000073 · option OPV_000463/464 (현재 MAX+1). 라이브 미변경(ROLLBACK).
-- ============================================================================
\echo '===== BEFORE: 230 옵션그룹/옵션(없어야) ====='
SELECT count(*) opt_grps FROM t_prd_product_option_groups WHERE prd_cd='PRD_000230';

BEGIN;
-- 1) 사이즈 옵션그룹(택1·필수)
INSERT INTO t_prd_product_option_groups
 (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn)
VALUES ('PRD_000230','OPT_000073','사이즈','SEL_TYPE.01',1,1,'Y',1,'Y');

-- 2) 옵션(라벨) — M(기본)·L
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)
VALUES ('PRD_000230','OPV_000463','OPT_000073','M','Y',1,'Y'),
       ('PRD_000230','OPV_000464','OPT_000073','L','N',2,'Y');

-- 3) 옵션아이템 — 라벨 → 크기코드(가격 연결축 OPT_REF_DIM.01 사이즈)
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, qty, use_yn)
VALUES ('PRD_000230','OPV_000463',1,'OPT_REF_DIM.01','SIZ_000433',1,'Y'),
       ('PRD_000230','OPV_000464',1,'OPT_REF_DIM.01','SIZ_000434',1,'Y');

\echo '===== AFTER: 230 손님 사이즈 선택(라벨 → 치수 → 가격연결축) ====='
SELECT o.opt_nm AS "손님라벨", s.siz_nm AS "크기코드(치수)", s.work_width||'x'||s.work_height AS "생산작업치수",
       oi.ref_dim_cd AS "가격연결축", o.dflt_yn AS "기본"
FROM t_prd_product_options o
JOIN t_prd_product_option_items oi ON oi.opt_cd=o.opt_cd AND oi.prd_cd=o.prd_cd
JOIN t_siz_sizes s ON s.siz_cd=oi.ref_key1
WHERE o.prd_cd='PRD_000230' ORDER BY o.disp_seq;

DO $$
DECLARE v_opt int; v_item int; v_lbl text;
BEGIN
  SELECT count(*) INTO v_opt FROM t_prd_product_options WHERE prd_cd='PRD_000230' AND opt_grp_cd='OPT_000073';
  IF v_opt<>2 THEN RAISE EXCEPTION '검증 실패: 옵션 %개(기대 2)',v_opt; END IF;
  SELECT count(*) INTO v_item FROM t_prd_product_option_items oi
   WHERE oi.prd_cd='PRD_000230' AND oi.ref_dim_cd='OPT_REF_DIM.01'
     AND oi.ref_key1 IN (SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='PRD_000230');
  IF v_item<>2 THEN RAISE EXCEPTION '검증 실패: 라벨→크기코드 연결 %건(기대 2·사이즈와 정합)',v_item; END IF;
  SELECT opt_nm INTO v_lbl FROM t_prd_product_options WHERE prd_cd='PRD_000230' AND dflt_yn='Y';
  RAISE NOTICE 'DRY-RUN OK: 손님라벨 M/L → SIZ_433/434(생산치수) → 가격축 OPT_REF_DIM.01 연결·기본=%·새속성 0', v_lbl;
END $$;

ROLLBACK;
\echo '===== ROLLBACK 완료 — 라이브 미변경 ====='
