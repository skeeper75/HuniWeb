-- ================================================================
-- 중철 소프트커버책자(PRD_000068) 셋트 ★완전 동작화 적재본 (표지 member 포함·골든 158,688)
-- 생성: hsp-set-designer 2026-07-01 · 라이브 읽기전용 SELECT 실측
-- 권위[HARD]: booklet-cover-branch-design.md rev.2(068A 골든 158,688=제본70,000+표지88,688)
--             · booklet-068-071-design.md rev.2 · 077/082 member 패턴(동작 기준·방금 COMMIT)
-- 목적: 부분 적재본(booklet-jungcheol-068-load.sql=내지287+제본)을 ★표지 member까지 확장.
--       사용자 directive "표지까지 완전 동작화" → 표지 88,688 산정 경로 완성.
-- ================================================================
-- ★ 부분 적재본 대비 추가분 = [위상 6~9] 표지 member(288)+표지공식(PRF_BOOK_COVER)+셋트행 표지.
--    위상 1~5(내지287+제본 부모공식)는 부분 적재본 verbatim 동일(멱등 재확인).
-- ================================================================
-- 라이브 실측(2026-07-01·읽기전용·search-before-mint):
--   MAX prd_cd=PRD_000286 → 내지 mint=PRD_000287 · 표지 mint=PRD_000288 (라이브 둘 다 미존재 확인).
--   ★068=분해형 표지(077/082=통합형 COVERBIND와 근본 다름) — 표지인쇄+코팅+용지 3비목 별 평가.
--   ★표지 깔끔 3비목 공식 부재(라이브 전수): COAT 포함 공식=PRF_DGP_A/D/E/_FOIL뿐(전부 굿즈/명함/
--     리플렛 후가공 comp 10~14개 혼입=§3 옵션오염·S8 위반) → ★표지 전용 신규공식 PRF_BOOK_COVER 신설
--     (인쇄 S1 + 코팅 MATTE + 용지 PAPER 3비목만·깔끔·068~071 분해형 공통).
--   ★표지 펼침 판형 매칭 해소: 표지 member 완제품 사이즈=SIZ_000174(A3 297x420 펼침)·판형=SIZ_000499
--     → fn_calc_pansu(SIZ_000499, SIZ_000174)=1(실측) → plate_qty(100부)=100판 → 표지 1매=1판 정확.
--     (A4 SIZ_000172는 pansu=2라 ÷2 저청구 / SIZ_000499 자기자신은 0 → 둘 다 부결. A3 펼침이 정답.)
--   골든 단가 verbatim(2026-07-01 실측·SIZ_000499):
--     · 표지인쇄 S1 POPT_000001(칼라단면) PROC_000004 min100=350 / min1=4000 / min1000=165
--     · 표지코팅 MATTE coat_side=1 PROC_000015 min100=500 / min1=2000 / min1000=130
--     · 표지용지 COMP_PAPER 백모120(MAT_000073) SIZ_000499=36.88
--     · 제본 JUNGCHEOL PROC_000018 min100=700 / min1=3000 / min1000=500
-- 골든 G-CB-068A (표지 칼라단면 백모120 무광 100부·내지 28p·펼침 cover_mult=1):
--   표지 = 인쇄 350×100=35,000 + 코팅 500×100=50,000 + 용지 36.88×100=3,688 = ★표지 88,688
--   제본 = JUNGCHEOL 700×100 = 70,000
--   부모(제본) 70,000 + 표지 member 88,688 + 내지287 = ★158,688 + 내지(허용오차0)
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor 단일 트랜잭션 래핑·DRY-RUN=ROLLBACK).
-- DB 미적재: 실 COMMIT은 게이트 DRY-RUN + 인간 승인 후.
-- ================================================================
-- 이중합산 0 (비목 단일 귀속):
--   표지인쇄/코팅/용지 = 표지 member(PRF_BOOK_COVER)만 · 내지인쇄/용지 = 내지 member(PRF_DGP_INNER)만
--   제본 = 부모공식(PRF_BIND_SUM→JUNGCHEOL)만. 각 1회. COMP_PAPER는 표지(member288·표지mat)/내지
--   (member287·내지mat) 다른 frm_cd·다른 mat_cd·다른 출력매수라 충돌 없음.
-- ★표지/내지 proc_cd 주입 가드: S1(proc_grp:PROC_000001)·COAT(proc_grp:PROC_000013) use_dims에 proc_cd
--   → 표지 member.selections에 proc_cd 주입(인쇄=PROC_000004·코팅=PROC_000015) 필수(silent 다중매칭 가드).
-- ★cover_mult ×2 무관: 068 중철=PROC_000018(접지·책등 있음)=펼침 cover_mult=1 → 표지 출력 ×1(copies).
--   호출자 member.qty = copies × 1 = copies. 071/082 트윈링/링(×2) BLOCKED와 무관(068은 ×배수 없음).
-- ================================================================

-- ================================================================
-- [PART A] 내지287 (부분 적재본 booklet-jungcheol-068-load.sql verbatim — 멱등 재확인)
-- ================================================================

-- [위상 1] 내지 반제품 mint (search-before-mint: MAX=286 → 287)
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000287', '중철책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- [위상 2a] 내지287 사이즈 (284~286 동형: A5 dflt / B5 / A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000287', 'SIZ_000170', 'Y', 1, now(), 'N'),
    ('PRD_000287', 'SIZ_000380', 'N', 2, now(), 'N'),
    ('PRD_000287', 'SIZ_000172', 'N', 3, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 2b] 내지287 인쇄옵션 (칼라단/양면001/002 + 흑백단/양면008/009·dflt=흑백양면)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000287', 1, '단면', 'CLR_000005', 'CLR_000001', 'N', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000287', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N'),
    ('PRD_000287', 3, '단면', 'CLR_000001', 'CLR_000001', 'N', 3, 'POPT_000008', now(), 'N'),
    ('PRD_000287', 4, '양면', 'CLR_000001', 'CLR_000001', 'Y', 4, 'POPT_000009', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- [위상 2c] 내지287 내지종이 자재 9종 (USAGE.07·백모조100 dflt)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000287', 'MAT_000072', 'USAGE.07', 'Y', 1, now(), 'N'),
    ('PRD_000287', 'MAT_000073', 'USAGE.07', 'N', 2, now(), 'N'),
    ('PRD_000287', 'MAT_000086', 'USAGE.07', 'N', 3, now(), 'N'),
    ('PRD_000287', 'MAT_000087', 'USAGE.07', 'N', 4, now(), 'N'),
    ('PRD_000287', 'MAT_000076', 'USAGE.07', 'N', 5, now(), 'N'),
    ('PRD_000287', 'MAT_000077', 'USAGE.07', 'N', 6, now(), 'N'),
    ('PRD_000287', 'MAT_000104', 'USAGE.07', 'N', 7, now(), 'N'),
    ('PRD_000287', 'MAT_000105', 'USAGE.07', 'N', 8, now(), 'N'),
    ('PRD_000287', 'MAT_000095', 'USAGE.07', 'N', 9, now(), 'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- [위상 2d] 내지287 판형 (SIZ_000499·인쇄/용지 환원 키)
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000287', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- [위상 3] 내지287 가격공식 (PRF_DGP_INNER 재사용·신설 0·깔끔 2비목 S1+PAPER)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000287', 'PRF_DGP_INNER', '2026-06-06', '중철책자 내지 구성원(디지털 합가형·284~286 동형·페이지4~28)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- [위상 4] 068 부모공식 PRF_BIND_SUM 유지 (제본 JUNGCHEOL·이미 정답값 70,000·NO-OP 멱등 재확인)
--   ★표지 3비목은 부모공식에 추가배선 안 함 → 표지 member(288)로 분리(분해형·plt_siz 환원·옵션오염 가드).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000068', 'PRF_BIND_SUM', '2026-06-01', '중철책자→제본 구성요소(세트 부모·제본비 JUNGCHEOL). 표지=288 member(PRF_BOOK_COVER 3비목). 내지=287 member.', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ================================================================
-- [PART B] ★표지 member 확장 (완전 동작화 추가분 — 표지 88,688 산정)
-- ================================================================

-- ---------------------------------------------------------------
-- [위상 5] ★표지 전용 신규공식 PRF_BOOK_COVER (인쇄 S1 + 코팅 MATTE + 용지 PAPER 3비목 — 깔끔)
--    search-before-mint: 라이브 코팅포함 공식 전수=PRF_DGP_A/D/E/_FOIL(굿즈/명함/리플렛 후가공
--    10~14개 혼입=옵션오염) → 빌리기 부결(S8). 068~071 분해형 표지 공통 신규공식.
--    ★set-designer는 공식 자체를 신설하지 않는 원칙이나, 사용자 "표지 완전 동작화" directive +
--      booklet-cover-branch 해법(a)(표지 member 분리)에 따라 ★게이트/인간 승인 대상으로 정의를 포함.
--      게이트가 evaluate 재계산으로 검증·인간 승인 후 dbmap COMMIT.
-- ---------------------------------------------------------------
-- 5a) 공식 행 (합산형·use_yn=Y)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt) VALUES
    ('PRF_BOOK_COVER', '책자 표지 분해형(인쇄+코팅+용지)',
     '068~071 분해형 책자 표지 전용. 표지인쇄(S1)+표지코팅(MATTE)+표지용지(PAPER) 3비목 합산. 굿즈/명함 후가공 comp 무혼입(S8 옵션오염 가드). 출력매수=copies×cover_mult(068=×1 펼침).', 'Y', now())
ON CONFLICT (frm_cd) DO UPDATE SET
    frm_nm=EXCLUDED.frm_nm, note=EXCLUDED.note, use_yn='Y', upd_dt=now()
WHERE t_prc_price_formulas.frm_nm IS DISTINCT FROM EXCLUDED.frm_nm
   OR t_prc_price_formulas.note   IS DISTINCT FROM EXCLUDED.note
   OR t_prc_price_formulas.use_yn IS DISTINCT FROM 'Y';

-- 5b) 공식 비목 3개 (전부 기존 comp 재사용·신규 comp 0)
--     COMP_PRINT_DIGITAL_S1(인쇄)·COMP_COAT_MATTE(코팅)·COMP_PAPER(용지) — addtn_yn='Y'(합산)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES
    ('PRF_BOOK_COVER', 'COMP_PRINT_DIGITAL_S1', 1, 'Y', now()),
    ('PRF_BOOK_COVER', 'COMP_COAT_MATTE',       2, 'Y', now()),
    ('PRF_BOOK_COVER', 'COMP_PAPER',            3, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now()
WHERE t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn;

-- ---------------------------------------------------------------
-- [위상 6] 표지 반제품 mint (search-before-mint: MAX=286·287=내지 → 표지=288·라이브 미존재 확인)
--    prd_typ=PRD_TYPE.02(반제품) · 077 표지078 / 082 표지083 동형 · 068 전용 중철 표지(펼침)
-- ---------------------------------------------------------------
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000288', '중철책자-표지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- [위상 7] 표지288 차원 충전 (골든 88,688 평가 환원 차원)
--    ★사이즈=SIZ_000174(A3 297x420 펼침) — fn_calc_pansu(SIZ_000499,SIZ_000174)=1 (표지 1매=1판)
--      판형=SIZ_000499 → plate_qty(copies)=copies → 표지인쇄/코팅/용지 ×copies (×cover_mult=1·×1)
--    인쇄옵션=칼라단/양면(POPT_000001/002·dflt 칼라단면) — 표지는 칼라가 일반
--    자재(표지용지)=USAGE.01(표지용도)·백모120(MAT_000073) dflt — 068 완제품 USAGE.01 동형
--    코팅 proc=PROC_000015(무광) 충전 — coat_side_cnt 차원은 호출자 selection
-- ---------------------------------------------------------------

-- 7a) 표지 사이즈 (★A3 펼침 SIZ_000174 단독·dflt — pansu=1 보증 / A4=pansu2 부결)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000288', 'SIZ_000174', 'Y', 1, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- 7b) 표지 인쇄옵션 (칼라단면001 dflt + 칼라양면002 — 표지는 칼라 일반·골든=칼라단면)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000288', 1, '단면', 'CLR_000005', 'CLR_000001', 'Y', 1, 'POPT_000001', now(), 'N'),  -- 칼라단면 dflt
    ('PRD_000288', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N')   -- 칼라양면
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- 7c) 표지용지 자재 (USAGE.01 표지용도·백모120 MAT_000073 dflt — 068 완제품 USAGE.01 동형 13종)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000288', 'MAT_000073', 'USAGE.01', 'Y', 1, now(), 'N'),  -- 백색모조120(골든 표지용지)
    ('PRD_000288', 'MAT_000077', 'USAGE.01', 'N', 2, now(), 'N'),
    ('PRD_000288', 'MAT_000078', 'USAGE.01', 'N', 3, now(), 'N'),
    ('PRD_000288', 'MAT_000079', 'USAGE.01', 'N', 4, now(), 'N'),
    ('PRD_000288', 'MAT_000080', 'USAGE.01', 'N', 5, now(), 'N'),
    ('PRD_000288', 'MAT_000087', 'USAGE.01', 'N', 6, now(), 'N'),
    ('PRD_000288', 'MAT_000104', 'USAGE.01', 'N', 7, now(), 'N'),
    ('PRD_000288', 'MAT_000105', 'USAGE.01', 'N', 8, now(), 'N')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- 7d) 표지 판형 (★SIZ_000499=316x467 국4절 — fn_calc_pansu(499,A3펼침174)=1 보증)
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000288', 'SIZ_000499', 'Y', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- 7e) 표지 코팅 공정 (PROC_000015 무광코팅 — mand_proc_yn='Y'·coat_side_cnt는 호출자 selection)
--     ★proc_cd 주입 가드: COAT_MATTE use_dims에 proc_cd → 표지 평가 시 PROC_000015 고정 주입(silent 다중매칭 가드)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000288', 'PROC_000015', 'N', 1, now(), 'N')  -- 무광코팅(택1·운영자 노출용·평가는 selection proc)
ON CONFLICT (prd_cd, proc_cd) DO UPDATE SET
    mand_proc_yn=EXCLUDED.mand_proc_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_processes.mand_proc_yn IS DISTINCT FROM EXCLUDED.mand_proc_yn
   OR t_prd_product_processes.del_yn IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------
-- [위상 8] 표지288 가격공식 바인딩 (PRF_BOOK_COVER — 신규공식 3비목·표지 88,688 평가)
-- ---------------------------------------------------------------
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000288', 'PRF_BOOK_COVER', '2026-06-06', '중철책자 표지 구성원(분해형 인쇄+코팅+용지·펼침 cover_mult=1·SIZ_000499 판형·A3펼침 pansu=1)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 9] 068 셋트행 — 표지288 + 내지287 (2구성원·소프트커버 면지 없음·복합PK 멱등)
--    ★068=중철 소프트커버 → 면지 없음(072/077/082 하드커버 면지 구성원과 다름).
--    표지288: qty1·min1/max1(권당 표지 1펼침·호출자 member.qty=copies×cover_mult=copies×1)
--    내지287: page 4~28/+4 (068 page_rule verbatim)
-- ---------------------------------------------------------------

-- 9a) 표지288 — seq1 (min1/max1·1권당 표지 1펼침)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000068', 'PRD_000288', 1, 1, 1, NULL, 1, '표지=중철 펼침(인쇄+코팅+용지 3비목·PRF_BOOK_COVER)·1권고정·cover_mult=1(펼침 ×1)·호출자 qty=copies', now(), 'N')
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

-- 9b) 내지287 — seq2 (페이지 4~28/+4 = 068 page_rule verbatim)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000068', 'PRD_000287', 1, 4, 28, 4, 2, '내지=중철내지종이·페이지4~28/+4(068 page_rule verbatim)·PRF_DGP_INNER', now(), 'N')
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
--   068 셋트 2행(표지288 seq1 + 내지287 seq2·면지없음)·복합PK
--   표지288: 사이즈1(A3펼침174)·인쇄옵션2(칼라단/양면)·자재8(USAGE.01)·판형1(499)·코팅proc1(015)·공식 PRF_BOOK_COVER
--   내지287: 사이즈3·인쇄옵션4·자재9(USAGE.07)·판형1(499)·공식 PRF_DGP_INNER
--   068 부모공식 PRF_BIND_SUM(제본)·PRF_BOOK_COVER 신규(3비목 S1+COAT+PAPER)
--   ★골든 158,688: evaluate_set_price(068·100부) =
--     부모(JUNGCHEOL 700×100=70,000) + 표지288(qty=100·인쇄350×100+코팅500×100+용지36.88×100=88,688) + 내지287
-- ================================================================
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND del_yn='N' ORDER BY disp_seq;
-- SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000068','PRD_000287','PRD_000288');
-- SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd='PRF_BOOK_COVER' ORDER BY disp_seq;
-- SELECT fn_calc_pansu('SIZ_000499','SIZ_000174');  -- 기대 1
-- SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000288' AND del_yn='N';  -- 8
-- SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000288' AND del_yn='N';      -- 1

-- ================================================================
-- BLOCKED (본 SQL 미포함·인간 승인 후 별도 트랙):
--   BLOCKED-COVER-FORMULA-MINT : PRF_BOOK_COVER 신규공식 + formula_components 3행은 ★set-designer가
--     아니라 §18(가격공식 설계)·dbmap 소관(t_prc_* COMMIT). 본 SQL은 게이트/인간 승인용 정의를 포함하나,
--     실 COMMIT은 §18 검증 GO + 인간 승인 후. (set-designer는 t_prd_product_sets 행이 본분.)
--   C-TRACK-ENGINE-DBLPANSU : 내지287 이중÷pansu(price_views.py:1707·전 책자 공통)·내지비 과소 가능성.
--     골든 페이지 환산 시 입력값 우회 명시. 개발팀(1회 교정이 전 책자 해소).
--   NOTE-COVERMULT : 068은 cover_mult=1(중철 펼침)이라 표지 부모공식 직배선도 정확했을 수 있으나,
--     ★판형 차이(완제품 SIZ_000250 vs 단가행 SIZ_000499)로 member 분리는 필연(077/082 동형).
--     071/082 cover_mult ×2 BLOCKED와는 무관(068 ×1).
-- ================================================================
