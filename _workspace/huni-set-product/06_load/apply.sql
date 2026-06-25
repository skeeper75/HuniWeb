-- ============================================================================
-- apply.sql (래핑본) — 엽서북(PRD_000094) 셋트 보정 라이브 COMMIT
-- 생성: hsp-load-executor · 게이트 GO(CONDITIONAL) + codex reconcile(R-1~R-4 CLOSED) + 인간 승인
-- 단일 트랜잭션 BEGIN ... COMMIT · 3 DML 한정 · 신규 mint 0 · 백업=_setbuild_20260624_0600
-- 03_design/apply.sql 본체를 BEGIN/COMMIT으로 래핑(데이터 변경 없음)
-- BLOCKED 제외: RM-1 30P 오청구 · RM-2 면지 자재 · RM-3 6셋트 유형정책
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- DML#1: 셋트 부모 유형 04(디자인) -> 01(완제품) · IS DISTINCT FROM 멱등 가드
UPDATE t_prd_products
   SET prd_typ_cd = 'PRD_TYPE.01',
       upd_dt     = now()
 WHERE prd_cd     = 'PRD_000094'
   AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01';

-- DML#2: 내지(95) UPSERT — min/max/incr=20/30/10 · disp_seq=1
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

-- DML#3: 표지(96) UPSERT — 가변 NULL 유지 · disp_seq 1->2 보정
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

COMMIT;
