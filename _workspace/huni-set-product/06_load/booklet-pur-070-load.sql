-- ================================================================
-- PUR 소프트커버책자(PRD_000070) 셋트 ★완전 동작화 적재본 (표지+내지 member·068/069 동형 전파)
-- 생성: hsp-set-designer 2026-07-01 · 라이브 읽기전용 SELECT 실측 · DB 미적재(게이트 DRY-RUN+인간 승인 후 COMMIT)
-- 권위[HARD]: booklet-cover-branch-design.md(070=PRF_BIND_PUR·page 24/300/2·분해형 펼침 cover_mult=1)
--             · 068 full-load + 069 load(동형 템플릿) · 단가 verbatim(날조 0)
-- 목적: 068/069 완전동작화 패턴을 070 PUR에 전파 — 표지 member(292)+내지 member(291)+셋트행 2.
-- ================================================================
-- 069 대비 070 차이(실측 2026-07-01):
--   · 제본 부모공식 = PRF_BIND_PUR(이미 라이브·NO-OP) — 069=MUSEON과 제본방식만 다름.
--   · page_rule = 24/300/2 (069와 동일·070 권위 verbatim).
--   · cover_mult=1 (PUR=PROC_000020 책등 있음·펼침 ×1) — 071/082 ×2 BLOCKED 무관.
--   · 표지/내지 공식 PRF_BOOK_COVER·PRF_DGP_INNER 재사용(신규 공식 0).
--   · ★070 완제품 자재 0행(라이브 실측·del 무관) — 070 표지/내지 자재 소스는 069 권위(USAGE.01 표지 7종·
--     USAGE.02 내지 6종) 재사용. member에 직접 충전(068 내지287/표지288도 완제품이 아닌 member 충전).
--     완제품 자재 link 부재는 견적 미관여(BLOCKED-MAT070-LINK·선택 정합·dbmap).
-- ================================================================
-- 라이브 실측(2026-07-01·읽기전용·search-before-mint):
--   MAX prd_cd=PRD_000288(068) → 069 mint=289/290 → 070 내지 mint=PRD_000291 · 070 표지 mint=PRD_000292
--   (069 적재본과 단일 트랜잭션이면 290 후행·둘 다 미존재 확인).
--   PRF_BOOK_COVER·PRF_DGP_INNER 실재 → 재사용 · PRF_BIND_PUR 실재(070 바인딩 보유·NO-OP).
--   fn_calc_pansu(SIZ_000499, SIZ_000174)=1 실측 → 표지 1매=1판.
--   골든 단가 verbatim(SIZ_000499·plt_siz_cd):
--     · 표지인쇄 S1 POPT_000001(칼라단면) PROC_000004 min100=350 / min1=4000
--     · 표지코팅 MATTE coat_side=1 PROC_000015 min100=500 / min1=2000
--     · 표지용지 COMP_PAPER 백모120(MAT_000073) SIZ_000499=36.88 · 내지용지 MAT_000074=70.64
--     · 제본 PUR COMP_BIND_PUR PROC_000020 min100=2000 / min1=5000 / min1000=1500
-- 골든 G-CB-070A (PUR·표지 칼라단면 백모120 무광 100부·cover_mult=1):
--   표지 = 인쇄 350×100=35,000 + 코팅 500×100=50,000 + 용지 36.88×100=3,688 = ★표지 88,688
--   제본 = PUR 2000×100 = 200,000
--   부모(제본) 200,000 + 표지 member 88,688 = ★288,688 + 내지291 (page파생·허용오차0)
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor 단일 트랜잭션 래핑·DRY-RUN=ROLLBACK). DB 미적재.
-- ================================================================
-- 이중합산 0 (비목 단일 귀속): 표지(292·PRF_BOOK_COVER)·내지(291·PRF_DGP_INNER)·제본(부모 PRF_BIND_PUR→COMP_BIND_PUR) 각 1회.
--   COMP_PAPER는 표지(292·MAT_000073·USAGE.01)/내지(291·MAT_000074·USAGE.07) 다른 frm_cd·다른 mat_cd라 충돌 없음.
-- ★proc_cd 주입 가드: 표지 인쇄=PROC_000004·코팅=PROC_000015 고정. 제본 PUR=PROC_000020 단일 comp(다중매칭 위험 낮음).
-- ★cover_mult=1(PUR 책등 있음·펼침) → 표지 ×1(copies). 071/082(×2) BLOCKED 무관.
-- ★DBLPANSU(내지) = C트랙(개발팀)·표지/제본 무영향·본 SQL 우회.
-- ================================================================

-- ================================================================
-- [PART A] 표지/내지 공식 NO-OP 재확인 (신규 공식 0·전부 재사용)
-- ================================================================
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt) VALUES
    ('PRF_BOOK_COVER', '책자 표지 분해형(인쇄+코팅+용지)',
     '068~071 분해형 책자 표지 전용. 표지인쇄(S1)+표지코팅(MATTE)+표지용지(PAPER) 3비목 합산. 굿즈/명함 후가공 comp 무혼입(S8 옵션오염 가드). 출력매수=copies×cover_mult(068~070=×1 펼침).', 'Y', now())
ON CONFLICT (frm_cd) DO UPDATE SET use_yn='Y', upd_dt=now()
WHERE t_prc_price_formulas.use_yn IS DISTINCT FROM 'Y';

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
    ('PRF_BOOK_COVER', 'COMP_PRINT_DIGITAL_S1', 1, 'Y', now()),
    ('PRF_BOOK_COVER', 'COMP_COAT_MATTE',       2, 'Y', now()),
    ('PRF_BOOK_COVER', 'COMP_PAPER',            3, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ================================================================
-- [PART B] 내지 member 291
-- ================================================================

-- [위상 1] 내지 반제품 mint (search-before-mint: 069 290 후행 → 291)
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000291', 'PUR책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- [위상 2a] 내지291 사이즈 (070 완제품 동형: A5 dflt / A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000291', 'SIZ_000170', 'Y', 1, now(), 'N'),
    ('PRD_000291', 'SIZ_000172', 'N', 2, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 2b] 내지291 인쇄옵션 (칼라단/양면001/002 + 흑백단/양면008/009·dflt=흑백양면·068/069 동형)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000291', 1, '단면', 'CLR_000005', 'CLR_000001', 'N', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000291', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N'),
    ('PRD_000291', 3, '단면', 'CLR_000001', 'CLR_000001', 'N', 3, 'POPT_000008', now(), 'N'),
    ('PRD_000291', 4, '양면', 'CLR_000001', 'CLR_000001', 'Y', 4, 'POPT_000009', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- [위상 2c] 내지291 내지종이 자재 (USAGE.07·069 USAGE.02 내지 6종 verbatim·070 완제품 자재 0행→069 권위 재사용·MAT_000074 dflt)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000291', 'MAT_000074', 'USAGE.07', 'Y', 1, now(), 'N'),
    ('PRD_000291', 'MAT_000081', 'USAGE.07', 'N', 2, now(), 'N'),
    ('PRD_000291', 'MAT_000082', 'USAGE.07', 'N', 3, now(), 'N'),
    ('PRD_000291', 'MAT_000091', 'USAGE.07', 'N', 4, now(), 'N'),
    ('PRD_000291', 'MAT_000092', 'USAGE.07', 'N', 5, now(), 'N'),
    ('PRD_000291', 'MAT_000109', 'USAGE.07', 'N', 6, now(), 'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- [위상 2d] 내지291 판형 (SIZ_000499·068/069 동형)
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000291', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 3] 내지291 가격공식 (PRF_DGP_INNER 재사용·신설 0)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000291', 'PRF_DGP_INNER', '2026-06-06', 'PUR책자 내지 구성원(디지털 합가형·068/069 동형·페이지24~300/+2)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ================================================================
-- [PART C] 표지 member 292
-- ================================================================

-- [위상 4] 표지 반제품 mint (search-before-mint: 291=내지 → 292=표지·미존재 확인·068/069 동형)
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000292', 'PUR책자-표지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- [위상 5a] 표지292 사이즈 (★A3 펼침 SIZ_000174·fn_calc_pansu(499,174)=1 보증)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000292', 'SIZ_000174', 'Y', 1, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 5b] 표지292 인쇄옵션 (칼라단면001 dflt + 칼라양면002·068/069 동형)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000292', 1, '단면', 'CLR_000005', 'CLR_000001', 'Y', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000292', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- [위상 5c] 표지292 자재(표지용지·USAGE.01·069 USAGE.01 표지 7종 verbatim·백모120 dflt·070 완제품 자재 0행→069 권위 재사용)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000292', 'MAT_000073', 'USAGE.01', 'Y', 1, now(), 'N'),  -- 백색모조120(골든 표지용지)
    ('PRD_000292', 'MAT_000077', 'USAGE.01', 'N', 2, now(), 'N'),
    ('PRD_000292', 'MAT_000087', 'USAGE.01', 'N', 3, now(), 'N'),
    ('PRD_000292', 'MAT_000095', 'USAGE.01', 'N', 4, now(), 'N'),
    ('PRD_000292', 'MAT_000096', 'USAGE.01', 'N', 5, now(), 'N'),
    ('PRD_000292', 'MAT_000104', 'USAGE.01', 'N', 6, now(), 'N'),
    ('PRD_000292', 'MAT_000105', 'USAGE.01', 'N', 7, now(), 'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- [위상 5d] 표지292 판형 (★SIZ_000499 국4절·fn_calc_pansu(499,174)=1)
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000292', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 5e] 표지292 코팅 공정 (PROC_000015 무광·proc_cd 주입 가드)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000292', 'PROC_000015', 'N', 1, now(), 'N')
ON CONFLICT (prd_cd, proc_cd) DO UPDATE SET
    mand_proc_yn=EXCLUDED.mand_proc_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_processes.mand_proc_yn IS DISTINCT FROM EXCLUDED.mand_proc_yn
   OR t_prd_product_processes.del_yn IS DISTINCT FROM 'N';

-- [위상 6] 표지292 가격공식 바인딩 (PRF_BOOK_COVER 재사용·표지 88,688 평가)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000292', 'PRF_BOOK_COVER', '2026-06-06', 'PUR책자 표지 구성원(분해형 인쇄+코팅+용지·펼침 cover_mult=1·SIZ_000499 판형·A3펼침 pansu=1·068/069 동형)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ================================================================
-- [PART D] 070 제본 부모공식 NO-OP 재확인 + 셋트행
-- ================================================================

-- [위상 7] 070 부모공식 PRF_BIND_PUR NO-OP 멱등 재확인 (이미 라이브·제본 PUR·재바인딩 불요)
--   ★박 _FOIL 변종(PRF_BIND_PUR_FOIL)은 후가공 옵션이므로 본체 동작화엔 불요(박 미선택 기본가) — 건드리지 않음.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000070', 'PRF_BIND_PUR', '2026-06-01', 'PUR책자→제본 구성요소(세트 부모·제본비 PUR). 표지=292 member(PRF_BOOK_COVER 3비목). 내지=291 member(PRF_DGP_INNER).', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd = 'PRF_BIND_PUR'
  AND t_prd_product_price_formulas.note IS DISTINCT FROM EXCLUDED.note;

-- [위상 8] 070 셋트행 — 표지292 + 내지291 (2구성원·소프트커버 면지 없음·복합PK 멱등·068/069 동형)
-- 8a) 표지292 — seq1 (min1/max1·cover_mult=1)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000070', 'PRD_000292', 1, 1, 1, NULL, 1, '표지=PUR 펼침(인쇄+코팅+용지 3비목·PRF_BOOK_COVER)·1권고정·cover_mult=1(펼침 ×1)·호출자 qty=copies', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
    cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.sub_prd_qty IS DISTINCT FROM EXCLUDED.sub_prd_qty
   OR t_prd_product_sets.min_cnt     IS DISTINCT FROM EXCLUDED.min_cnt
   OR t_prd_product_sets.max_cnt     IS DISTINCT FROM EXCLUDED.max_cnt
   OR t_prd_product_sets.cnt_incr    IS DISTINCT FROM EXCLUDED.cnt_incr
   OR t_prd_product_sets.disp_seq    IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note        IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn      IS DISTINCT FROM 'N';

-- 8b) 내지291 — seq2 (페이지 24~300/+2 = 070 page_rule verbatim)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000070', 'PRD_000291', 1, 24, 300, 2, 2, '내지=PUR내지종이·페이지24~300/+2(070 page_rule verbatim)·PRF_DGP_INNER', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
    cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.sub_prd_qty IS DISTINCT FROM EXCLUDED.sub_prd_qty
   OR t_prd_product_sets.min_cnt     IS DISTINCT FROM EXCLUDED.min_cnt
   OR t_prd_product_sets.max_cnt     IS DISTINCT FROM EXCLUDED.max_cnt
   OR t_prd_product_sets.cnt_incr    IS DISTINCT FROM EXCLUDED.cnt_incr
   OR t_prd_product_sets.disp_seq    IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note        IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn      IS DISTINCT FROM 'N';

-- ================================================================
-- 사후 검증(읽기·load-executor 트랜잭션 내)
--   070 셋트 2행(표지292 seq1·min1/max1 + 내지291 seq2·page24~300/+2·면지없음)·복합PK
--   표지292: 사이즈1(174)·인쇄옵션2·자재7(USAGE.01)·판형1(499)·코팅proc1(015)·공식 PRF_BOOK_COVER(재사용)
--   내지291: 사이즈2·인쇄옵션4·자재6(USAGE.07)·판형1(499)·공식 PRF_DGP_INNER(재사용)
--   070 부모공식 PRF_BIND_PUR(제본·NO-OP)·신규 공식 0·신규 comp 0
--   ★골든 288,688: evaluate_set_price(070·100부) =
--     부모(PUR 2000×100=200,000) + 표지292(인쇄350×100+코팅500×100+용지36.88×100=88,688) + 내지291(page파생)
-- ================================================================
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq FROM t_prd_product_sets WHERE prd_cd='PRD_000070' AND del_yn='N' ORDER BY disp_seq;
-- SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000070','PRD_000291','PRD_000292') ORDER BY prd_cd, frm_cd;
-- SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000292' AND del_yn='N';  -- 7
-- SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000291' AND del_yn='N';  -- 6

-- ================================================================
-- BLOCKED (본 SQL 미포함·인간 승인 후 별도 트랙):
--   C-TRACK-ENGINE-DBLPANSU : 내지291 이중÷pansu(price_views.py:1707·전 책자 공통)·개발팀 1회 교정. 본 SQL 우회.
--   BLOCKED-MAT070-LINK : 070 완제품(PRD_000070) 자재 link 0행(라이브 실측)·069는 USAGE.01/02 보유. 표지/내지
--     자재는 member(291/292)에 069 권위 verbatim 충전(견적 정확)·완제품 자재 link 보강은 견적 미관여 선택 정합(dbmap).
--   NA-FOIL-VARIANT : PRF_BIND_PUR_FOIL(박 후가공)은 본체 동작화 불요·건드리지 않음.
--   NA-COVERMULT-X2 : 070 PUR=cover_mult=1(책등 있음·펼침)·071/082(×2) BLOCKED 무관.
-- ================================================================
