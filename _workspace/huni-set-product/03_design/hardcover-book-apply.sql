-- ================================================================
-- 하드커버책자(PRD_000072) 셋트 종단 설계 적재본 (멱등·DRY-RUN)
-- 생성: hsp-set-designer 2026-06-29 · 권위=상품마스터 booklet row38
-- 스코프: 셋트 행 보정 + 내지 반제품(PRD_000284) 신설
-- 분리(dbmap 위임·인간 승인): 자재 재배선·셋트공식 신설(PRF_BIND_HC_MUSEON)·
--   구성원 PRF_DGP_A 바인딩+차원 충전·면지 통합 → 본 SQL 미포함(BLOCKED 보드).
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor가 래핑·DRY-RUN=ROLLBACK).
-- ================================================================

-- ---------------------------------------------------------------
-- 1) 내지 반제품 신설 (search-before-mint: MAX=PRD_000283 → 284·미존재 확인)
--    prd_typ=PRD_TYPE.02(반제품) · 디지털인쇄 동형
-- ---------------------------------------------------------------
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000284', '하드커버책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- 2) 셋트 구성원 보정 + 내지 member 신설 (복합PK 멱등)
--    표지(073): min1/max1 충전 · disp_seq 1 유지
--    내지(284): 신규 INSERT · 페이지 24~300/+2 (member-qty 가변)
--    면지(074/075/076): disp_seq 2/3/4 → 3/4/5 재배치(내지 삽입)
-- ---------------------------------------------------------------

-- 2a) 표지 — 개수규칙 충전
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000072', 'PRD_000073', 1, 1, 1, NULL, 1, '표지=전용지·1권고정', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    min_cnt   = EXCLUDED.min_cnt,
    max_cnt   = EXCLUDED.max_cnt,
    cnt_incr  = EXCLUDED.cnt_incr,
    disp_seq  = EXCLUDED.disp_seq,
    note      = EXCLUDED.note,
    upd_dt    = now()
WHERE  t_prd_product_sets.min_cnt  IS DISTINCT FROM EXCLUDED.min_cnt
   OR  t_prd_product_sets.max_cnt  IS DISTINCT FROM EXCLUDED.max_cnt
   OR  t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR  t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note;

-- 2b) 내지 — 신규 member (페이지 24~300/+2 = derive_inner_sheets 입력 차원)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000072', 'PRD_000284', 1, 24, 300, 2, 2, '내지=별도설정종이·페이지24~300/+2', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    sub_prd_qty = EXCLUDED.sub_prd_qty,
    min_cnt     = EXCLUDED.min_cnt,
    max_cnt     = EXCLUDED.max_cnt,
    cnt_incr    = EXCLUDED.cnt_incr,
    disp_seq    = EXCLUDED.disp_seq,
    note        = EXCLUDED.note,
    del_yn      = 'N',
    upd_dt      = now()
WHERE  t_prd_product_sets.sub_prd_qty IS DISTINCT FROM EXCLUDED.sub_prd_qty
   OR  t_prd_product_sets.min_cnt     IS DISTINCT FROM EXCLUDED.min_cnt
   OR  t_prd_product_sets.max_cnt     IS DISTINCT FROM EXCLUDED.max_cnt
   OR  t_prd_product_sets.cnt_incr    IS DISTINCT FROM EXCLUDED.cnt_incr
   OR  t_prd_product_sets.disp_seq    IS DISTINCT FROM EXCLUDED.disp_seq
   OR  t_prd_product_sets.note        IS DISTINCT FROM EXCLUDED.note
   OR  t_prd_product_sets.del_yn      IS DISTINCT FROM 'N';

-- 2c) 면지 화이트 — disp_seq 2→3
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000072', 'PRD_000074', 1, NULL, NULL, NULL, 3, '면지=화이트면지·택1그룹', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq = EXCLUDED.disp_seq,
    note     = EXCLUDED.note,
    upd_dt   = now()
WHERE  t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR  t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note;

-- 2d) 면지 블랙 — disp_seq 3→4
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000072', 'PRD_000075', 1, NULL, NULL, NULL, 4, '면지=블랙면지·택1그룹', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq = EXCLUDED.disp_seq,
    note     = EXCLUDED.note,
    upd_dt   = now()
WHERE  t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR  t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note;

-- 2e) 면지 그레이 — disp_seq 4→5
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000072', 'PRD_000076', 1, NULL, NULL, NULL, 5, '면지=그레이면지·택1그룹', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq = EXCLUDED.disp_seq,
    note     = EXCLUDED.note,
    upd_dt   = now()
WHERE  t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR  t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- 사후 검증(읽기) — load-executor 트랜잭션 내 확인용
--   기대: 5행(표지1+내지1+면지3)·disp_seq 1~5 단조·내지 min24/max300/incr2
-- ---------------------------------------------------------------
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note
-- FROM   t_prd_product_sets WHERE prd_cd='PRD_000072' ORDER BY disp_seq;
-- SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000284';

-- ================================================================
-- BLOCKED (본 SQL 미포함 · dbmap/§18 위임 · 인간 승인 후):
--   BLOCKED-FORMULA   : PRF_BIND_HC_MUSEON 셋트공식 신설(COMP_BIND_HC_MUSEON 단가행 6개 실재)
--   BLOCKED-INNER-DIM : PRD_000284 내지 PRF_DGP_A 바인딩 + 사이즈/공정/판형 차원 충전
--   BLOCKED-COVER-DIM : PRD_000073 표지 PRF_DGP_A 바인딩 + 차원 충전
--   BLOCKED-MAT-REWIRE: 부모 좀비 자재(MAT_000002 아크릴·003 우드거치대) link 제거
--                       + 구성원 정자재(전용지/면지/내지종이) 배선(마스터 삭제금지·link만)
--   CONFIRM-PAPER     : 내지 종이=별도설정(권위 공란) → 실무진 목록 확정
--   CONFIRM-FACE      : 면지 3행→1반제품+색상옵션 통합 여부(인간 정책)
-- ================================================================
