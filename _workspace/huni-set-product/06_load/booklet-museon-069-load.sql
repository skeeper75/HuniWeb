-- ================================================================
-- 무선 소프트커버책자(PRD_000069) 셋트 ★완전 동작화 적재본 (표지+내지 member·068 동형 전파)
-- 생성: hsp-set-designer 2026-07-01 · 라이브 읽기전용 SELECT 실측 · DB 미적재(게이트 DRY-RUN+인간 승인 후 COMMIT)
-- 권위[HARD]: booklet-cover-branch-design.md(069=PRF_BIND_MUSEON·page 24/300/2·분해형 펼침 cover_mult=1)
--             · 068 full-load(동형 템플릿·방금 COMMIT·표지 88,688 패턴) · 단가 verbatim(날조 0)
-- 목적: 068 중철 완전동작화 패턴을 069 무선에 전파 — 표지 member(290)+내지 member(289)+셋트행 2.
-- ================================================================
-- 068 대비 069 차이(실측 2026-07-01):
--   · 제본 부모공식 = PRF_BIND_MUSEON(이미 라이브·NO-OP 재확인) — 068=PRF_BIND_SUM(중철)과 다름.
--   · page_rule = 24/300/2 (068=4/28/4와 다름·069 권위 verbatim).
--   · cover_mult=1 (무선=PROC_000019 책등 있음·펼침 ×1) — 071/082 ×2 BLOCKED 무관.
--   · 표지공식 PRF_BOOK_COVER 재사용(068에서 COMMIT·라이브 실재 확인·신규 공식 0).
--   · 내지공식 PRF_DGP_INNER 재사용(라이브 실재·신규 0).
-- ================================================================
-- 라이브 실측(2026-07-01·읽기전용·search-before-mint):
--   MAX prd_cd=PRD_000288(068 표지) → 069 내지 mint=PRD_000289 · 069 표지 mint=PRD_000290 (둘 다 미존재 확인).
--   PRF_BOOK_COVER 실재(068 COMMIT·use_yn=Y·비목 S1+COAT_MATTE+PAPER 3개 verbatim) → 재사용.
--   PRF_DGP_INNER 실재 → 재사용 · PRF_BIND_MUSEON 실재(069 바인딩 보유·NO-OP).
--   fn_calc_pansu(SIZ_000499, SIZ_000174)=1 실측 → 표지 1매=1판(저청구 가드).
--   골든 단가 verbatim(SIZ_000499·plt_siz_cd):
--     · 표지인쇄 S1 POPT_000001(칼라단면) PROC_000004 min100=350 / min1=4000 / min1000=165
--     · 표지코팅 MATTE coat_side=1 PROC_000015 min100=500 / min1=2000 / min1000=130
--     · 표지용지 COMP_PAPER 백모120(MAT_000073) SIZ_000499=36.88
--     · 내지용지 COMP_PAPER MAT_000074(069 USAGE.02 dflt) SIZ_000499=70.64
--     · 제본 MUSEON COMP_BIND_MUSEON PROC_000019 min100=500 / min1=3000 / min1000=500
-- 골든 G-CB-069A (무선·표지 칼라단면 백모120 무광 100부·cover_mult=1):
--   표지 = 인쇄 350×100=35,000 + 코팅 500×100=50,000 + 용지 36.88×100=3,688 = ★표지 88,688
--   제본 = MUSEON 500×100 = 50,000
--   부모(제본) 50,000 + 표지 member 88,688 = ★138,688 + 내지289 (page파생·허용오차0)
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor 단일 트랜잭션 래핑·DRY-RUN=ROLLBACK). DB 미적재.
-- ================================================================
-- 이중합산 0 (비목 단일 귀속):
--   표지인쇄/코팅/용지 = 표지 member(PRF_BOOK_COVER)만 · 내지인쇄/용지 = 내지 member(PRF_DGP_INNER)만
--   제본 = 부모공식(PRF_BIND_MUSEON→COMP_BIND_MUSEON)만. 각 1회.
--   COMP_PAPER는 표지(290·MAT_000073·USAGE.01)/내지(289·MAT_000074·USAGE.02) 다른 frm_cd·다른 mat_cd
--   ·다른 출력매수라 충돌 없음.
-- ★proc_cd 주입 가드: S1(proc_grp PROC_000001)·COAT_MATTE(proc_grp PROC_000013) use_dims에 proc_cd
--   → 표지 member 평가 시 인쇄=PROC_000004·코팅=PROC_000015 고정(silent 다중매칭 가드).
-- ★cover_mult ×2 무관: 069 무선=PROC_000019(책등 있음)=펼침 cover_mult=1 → 표지 ×1(copies). 071/082(×2) BLOCKED 무관.
-- ★DBLPANSU(내지 이중÷pansu·price_views.py:1707) = C트랙(개발팀 1회 교정·전 책자 공통·표지/제본 무영향) — 본 SQL 우회.
-- ================================================================

-- ================================================================
-- [PART A] 표지/내지 공식 NO-OP 재확인 (신규 공식 0·전부 재사용)
-- ================================================================
-- A1) PRF_BOOK_COVER NO-OP 멱등 재확인 (068 COMMIT·라이브 실재·use_yn=Y·비목 3개) — 069 재사용
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt) VALUES
    ('PRF_BOOK_COVER', '책자 표지 분해형(인쇄+코팅+용지)',
     '068~071 분해형 책자 표지 전용. 표지인쇄(S1)+표지코팅(MATTE)+표지용지(PAPER) 3비목 합산. 굿즈/명함 후가공 comp 무혼입(S8 옵션오염 가드). 출력매수=copies×cover_mult(068~070=×1 펼침).', 'Y', now())
ON CONFLICT (frm_cd) DO UPDATE SET use_yn='Y', upd_dt=now()
WHERE t_prc_price_formulas.use_yn IS DISTINCT FROM 'Y';

-- A2) PRF_BOOK_COVER 비목 3개 NO-OP 재확인 (068 COMMIT·재사용 comp·신규 comp 0)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
    ('PRF_BOOK_COVER', 'COMP_PRINT_DIGITAL_S1', 1, 'Y', now()),
    ('PRF_BOOK_COVER', 'COMP_COAT_MATTE',       2, 'Y', now()),
    ('PRF_BOOK_COVER', 'COMP_PAPER',            3, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ================================================================
-- [PART B] 내지 member 289
-- ================================================================

-- [위상 1] 내지 반제품 mint (search-before-mint: MAX=288 → 289)
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000289', '무선책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- [위상 2a] 내지289 사이즈 (069 완제품 동형: A5 dflt / A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000289', 'SIZ_000170', 'Y', 1, now(), 'N'),
    ('PRD_000289', 'SIZ_000172', 'N', 2, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 2b] 내지289 인쇄옵션 (칼라단/양면001/002 + 흑백단/양면008/009·dflt=흑백양면·068 동형)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000289', 1, '단면', 'CLR_000005', 'CLR_000001', 'N', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000289', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N'),
    ('PRD_000289', 3, '단면', 'CLR_000001', 'CLR_000001', 'N', 3, 'POPT_000008', now(), 'N'),
    ('PRD_000289', 4, '양면', 'CLR_000001', 'CLR_000001', 'Y', 4, 'POPT_000009', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- [위상 2c] 내지289 내지종이 자재 (USAGE.07 내지용도·069 완제품 USAGE.02 내지 6종 verbatim·MAT_000074 dflt)
--   ★068 내지287은 USAGE.07로 충전 → 069 동형 USAGE.07. 자재 코드는 069 완제품 USAGE.02(내지) 권위.
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000289', 'MAT_000074', 'USAGE.07', 'Y', 1, now(), 'N'),
    ('PRD_000289', 'MAT_000081', 'USAGE.07', 'N', 2, now(), 'N'),
    ('PRD_000289', 'MAT_000082', 'USAGE.07', 'N', 3, now(), 'N'),
    ('PRD_000289', 'MAT_000091', 'USAGE.07', 'N', 4, now(), 'N'),
    ('PRD_000289', 'MAT_000092', 'USAGE.07', 'N', 5, now(), 'N'),
    ('PRD_000289', 'MAT_000109', 'USAGE.07', 'N', 6, now(), 'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- [위상 2d] 내지289 판형 (SIZ_000499·인쇄/용지 환원 키·068 동형)
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000289', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 3] 내지289 가격공식 (PRF_DGP_INNER 재사용·신설 0)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000289', 'PRF_DGP_INNER', '2026-06-06', '무선책자 내지 구성원(디지털 합가형·068 내지287 동형·페이지24~300/+2)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ================================================================
-- [PART C] 표지 member 290
-- ================================================================

-- [위상 4] 표지 반제품 mint (search-before-mint: 289=내지 → 290=표지·미존재 확인·068 표지288 동형)
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000290', '무선책자-표지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- [위상 5a] 표지290 사이즈 (★A3 펼침 SIZ_000174 단독·dflt — fn_calc_pansu(499,174)=1 보증·068 동형)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000290', 'SIZ_000174', 'Y', 1, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 5b] 표지290 인쇄옵션 (칼라단면001 dflt + 칼라양면002·068 동형·골든=칼라단면)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000290', 1, '단면', 'CLR_000005', 'CLR_000001', 'Y', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000290', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- [위상 5c] 표지290 자재(표지용지·USAGE.01·069 완제품 USAGE.01 표지 7종 verbatim·백모120 MAT_000073 dflt)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000290', 'MAT_000073', 'USAGE.01', 'Y', 1, now(), 'N'),  -- 백색모조120(골든 표지용지)
    ('PRD_000290', 'MAT_000077', 'USAGE.01', 'N', 2, now(), 'N'),
    ('PRD_000290', 'MAT_000087', 'USAGE.01', 'N', 3, now(), 'N'),
    ('PRD_000290', 'MAT_000095', 'USAGE.01', 'N', 4, now(), 'N'),
    ('PRD_000290', 'MAT_000096', 'USAGE.01', 'N', 5, now(), 'N'),
    ('PRD_000290', 'MAT_000104', 'USAGE.01', 'N', 6, now(), 'N'),
    ('PRD_000290', 'MAT_000105', 'USAGE.01', 'N', 7, now(), 'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- [위상 5d] 표지290 판형 (★SIZ_000499 국4절 — fn_calc_pansu(499,174)=1 보증·068 동형)
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000290', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 5e] 표지290 코팅 공정 (PROC_000015 무광·proc_cd 주입 가드·068 동형)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000290', 'PROC_000015', 'N', 1, now(), 'N')
ON CONFLICT (prd_cd, proc_cd) DO UPDATE SET
    mand_proc_yn=EXCLUDED.mand_proc_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_processes.mand_proc_yn IS DISTINCT FROM EXCLUDED.mand_proc_yn
   OR t_prd_product_processes.del_yn IS DISTINCT FROM 'N';

-- [위상 6] 표지290 가격공식 바인딩 (PRF_BOOK_COVER 재사용·표지 88,688 평가)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000290', 'PRF_BOOK_COVER', '2026-06-06', '무선책자 표지 구성원(분해형 인쇄+코팅+용지·펼침 cover_mult=1·SIZ_000499 판형·A3펼침 pansu=1·068 동형)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ================================================================
-- [PART D] 069 제본 부모공식 NO-OP 재확인 + 셋트행
-- ================================================================

-- [위상 7] 069 부모공식 PRF_BIND_MUSEON NO-OP 멱등 재확인 (이미 라이브·제본 MUSEON·재바인딩 불요)
--   ★박 _FOIL 변종(PRF_BIND_MUSEON_FOIL)은 후가공 옵션이므로 본체 동작화엔 불요(박 미선택 기본가) — 건드리지 않음.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000069', 'PRF_BIND_MUSEON', '2026-06-01', '무선책자→제본 구성요소(세트 부모·제본비 MUSEON). 표지=290 member(PRF_BOOK_COVER 3비목). 내지=289 member(PRF_DGP_INNER).', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd = 'PRF_BIND_MUSEON'
  AND t_prd_product_price_formulas.note IS DISTINCT FROM EXCLUDED.note;

-- [위상 8] 069 셋트행 — 표지290 + 내지289 (2구성원·소프트커버 면지 없음·복합PK 멱등·068 동형)
-- 8a) 표지290 — seq1 (min1/max1·1권당 표지 1펼침·cover_mult=1)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000069', 'PRD_000290', 1, 1, 1, NULL, 1, '표지=무선 펼침(인쇄+코팅+용지 3비목·PRF_BOOK_COVER)·1권고정·cover_mult=1(펼침 ×1)·호출자 qty=copies', now(), 'N')
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

-- 8b) 내지289 — seq2 (페이지 24~300/+2 = 069 page_rule verbatim)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000069', 'PRD_000289', 1, 24, 300, 2, 2, '내지=무선내지종이·페이지24~300/+2(069 page_rule verbatim)·PRF_DGP_INNER', now(), 'N')
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
--   069 셋트 2행(표지290 seq1·min1/max1 + 내지289 seq2·page24~300/+2·면지없음)·복합PK
--   표지290: 사이즈1(A3펼침174)·인쇄옵션2(칼라단/양면)·자재7(USAGE.01)·판형1(499)·코팅proc1(015)·공식 PRF_BOOK_COVER(재사용)
--   내지289: 사이즈2·인쇄옵션4·자재6(USAGE.07)·판형1(499)·공식 PRF_DGP_INNER(재사용)
--   069 부모공식 PRF_BIND_MUSEON(제본·NO-OP)·신규 공식 0·신규 comp 0
--   ★골든 138,688: evaluate_set_price(069·100부) =
--     부모(MUSEON 500×100=50,000) + 표지290(인쇄350×100+코팅500×100+용지36.88×100=88,688) + 내지289(page파생)
-- ================================================================
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq FROM t_prd_product_sets WHERE prd_cd='PRD_000069' AND del_yn='N' ORDER BY disp_seq;
-- SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000069','PRD_000289','PRD_000290') ORDER BY prd_cd, frm_cd;
-- SELECT fn_calc_pansu('SIZ_000499','SIZ_000174');  -- 기대 1
-- SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000290' AND del_yn='N';  -- 7
-- SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000289' AND del_yn='N';  -- 6

-- ================================================================
-- BLOCKED (본 SQL 미포함·인간 승인 후 별도 트랙):
--   C-TRACK-ENGINE-DBLPANSU : 내지289 이중÷pansu(price_views.py:1707·전 책자 공통)·개발팀 1회 교정. 본 SQL 우회.
--   NA-FOIL-VARIANT : PRF_BIND_MUSEON_FOIL(박 후가공)은 본체 동작화 불요(박 미선택 기본가)·건드리지 않음.
--   NA-COVERMULT-X2 : 069 무선=cover_mult=1(책등 있음·펼침)이라 ×배수 자체 없음·071/082(×2) BLOCKED 무관.
-- ================================================================
