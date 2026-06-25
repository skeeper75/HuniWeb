-- ============================================================================
-- apply.sql — 엽서북(PRD_000094) 셋트 구성 보정 적재본 (멱등)
-- 생성: hsp-set-designer · 파일럿 종단 · DB 미적재(load-executor가 BEGIN/COMMIT 래핑)
-- 권위=상품마스터(260610) · 라이브 실측 기준 · 신규 mint 0(전부 보정/UPDATE)
-- 라이브 스키마 실측: t_prd_product_sets PK=(prd_cd,sub_prd_cd) · semi_role_cd 컬럼 없음
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [1] 셋트 부모 유형 교정 (directive 1) — t_prd_products
--     PRD_TYPE.04(디자인) -> PRD_TYPE.01(완제품). 멱등: 이미 01이면 0행.
-- ----------------------------------------------------------------------------
UPDATE t_prd_products
   SET prd_typ_cd = 'PRD_TYPE.01',
       upd_dt     = now()
 WHERE prd_cd     = 'PRD_000094'
   AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01';

-- ----------------------------------------------------------------------------
-- [2] 셋트 구성원 보정 (directive 2) — t_prd_product_sets
--     기존 2행 존재(94->95 내지, 94->96 표지). INSERT ... ON CONFLICT DO UPDATE
--     로 멱등 보정: 내지 가변범위(20/30/10) 충전 + disp_seq 보정(내지1/표지2).
--     (행이 없을 경우에도 안전하게 생성되도록 INSERT 형태로 작성)
-- ----------------------------------------------------------------------------

-- 내지 (PRD_000095): min/max/incr = 20/30/10, disp_seq=1
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt)
VALUES
    ('PRD_000094', 'PRD_000095', 1, 20, 30, 10, 1, '내지=몽블랑240·페이지20~30/+10', 'N', now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    sub_prd_qty = EXCLUDED.sub_prd_qty,
    min_cnt     = EXCLUDED.min_cnt,
    max_cnt     = EXCLUDED.max_cnt,
    cnt_incr    = EXCLUDED.cnt_incr,
    disp_seq    = EXCLUDED.disp_seq,
    note        = EXCLUDED.note,
    del_yn      = 'N',
    upd_dt      = now();

-- 표지 (PRD_000096): 가변범위 NULL 유지(표지=셋트수량 1:1), disp_seq=2
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt)
VALUES
    ('PRD_000094', 'PRD_000096', 1, NULL, NULL, NULL, 2, '표지=스노우300·1권고정', 'N', now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    sub_prd_qty = EXCLUDED.sub_prd_qty,
    min_cnt     = EXCLUDED.min_cnt,
    max_cnt     = EXCLUDED.max_cnt,
    cnt_incr    = EXCLUDED.cnt_incr,
    disp_seq    = EXCLUDED.disp_seq,
    note        = EXCLUDED.note,
    del_yn      = 'N',
    upd_dt      = now();

-- ----------------------------------------------------------------------------
-- BLOCKED (적재본 제외 · blocked-board.csv 참조):
--   - 30P 단가행/comp 부재 → §18/dbmap (가격공식 신설·인간승인)
--   - 면지 자재 4종 재배선 → dbmap/basecode (t_mat 공유마스터 수술·인간승인) · 엽서북 N/A
--   - 6셋트 유형교정 → 인간 정책확인 후 확장
-- ----------------------------------------------------------------------------
