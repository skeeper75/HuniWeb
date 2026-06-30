-- ================================================================
-- 하드커버 링책자(PRD_000082) 셋트 동작화 적재본 (멱등·FK 위상순·DRY-RUN)
-- 생성: hsp-set-designer 2026-07-01
-- 권위: 03_design/hardcover-ring-082-authority.md (권위 대조 결판)
--       상품마스터 booklet-l1 row37~41 · 계산공식집 하드커버링책자(L81~89) · 072/077 동형(동작 기준)
-- 목적: 082 견적 0원(부모공식 0행) 해소 → PRICE≠0 (제본 30,000 + 내지 ≈9,100 경로)
-- 라이브 실측(2026-07-01·읽기전용): 부모 PRD_000082=완제품·공식 0행·셋트 5행(내지 부재·표지083+면지084~087)
--   ★핵심 차이(077 대비): 077=무선 부모 PRF_HC_MUSEON_SET 재사용(bundle COVERBIND·표지+제본 1밴드).
--     082=링 → 무선 부모 재사용 = S8 옵션 오염(링 상품에 무선 제본단가). 따라서:
--     - PRF_HC_TWINRING_SET = ★신규 mint (링 전용 부모공식)
--     - COMP_BIND_HC_TWINRING = ★실재 6밴드(30000/20000/15000/10000/8000/7000·PROC_000024·미바인딩) 재사용
--   PRF_DGP_INNER 실재(072/077 내지 바인딩)·공유 단가행(DIGITAL_S1·PAPER)=상품 비종속(내지 단가행 신규 0)
--   MAX prd_cd=PRD_000285(077 내지 점유) → 082 내지 mint=PRD_000286
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor가 단일 트랜잭션 래핑·DRY-RUN=ROLLBACK).
-- DB 미적재: 실 COMMIT은 게이트 DRY-RUN + 인간 승인 후.
-- ================================================================

-- ================================================================
-- [스코프 = PRICE≠0 동작화] : 본 SQL은 082를 "제본+내지 골든 경로"로 동작시킨다.
--   ★표지인쇄·표지코팅·면지인쇄·면지코팅(전부 ×2·앞뒤 물리 2장) 정확값은 본 SQL 밖(BLOCKED).
--    이유: ① 링 표지/면지 component 단가행이 라이브에 부재(072/077 무선엔 표지=COVERBIND bundle에 흡수,
--           면지=무료라 별도 단가행 없음. 082 링 분해형 비목은 단가행 미적재).
--          ② cover_mult ×2 곱셈은 현 엔진 미지원(plate_qty÷pansu만·×2 경로 0 — [[booklet-cover-branch-design-260630]]).
--    → BLOCKED-COVER-MYUNJI-PRINT(표지/면지 인쇄·코팅 단가)·BLOCKED-COVERMULT-X2(×2 곱셈)로 분리.
--    077이 레더 +3,900을 BLOCKED 별도 트랙으로 두고 전용지 골든으로 PRICE≠0 먼저 달성한 패턴과 동형.
--    저청구 잔존하나 0원 아님(제본 30,000 + 내지 9,100 ≈ 39,100+ 비0 즉시).
-- ================================================================

-- ---------------------------------------------------------------
-- [위상 0] 링 전용 부모공식 PRF_HC_TWINRING_SET 신설 (search-before-mint: 라이브 부재 확인)
--    ★무선 PRF_HC_MUSEON_SET 재사용 금지(링에 무선 제본단가=S8 오염).
--    분해형(권위 7비목 정합·071 트윈링 설계 원리): 제본비 = COMP_BIND_HC_TWINRING(실재·미바인딩).
--    표지인쇄/표지코팅/면지 ×2 비목은 단가행 부재로 미배선(BLOCKED) — 제본으로 PRICE≠0 먼저.
-- ---------------------------------------------------------------
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
VALUES (
    'PRF_HC_TWINRING_SET',
    '하드커버트윈링 제본 합산가(세트 부모)',
    '082 하드커버 링책자 세트 부모공식(링 전용·신설). 제본비=COMP_BIND_HC_TWINRING(PROC_000024·6밴드). 무선 PRF_HC_MUSEON_SET 재사용 금지(S8 오염). 표지/면지 인쇄·코팅 ×2 비목은 단가행 부재로 BLOCKED(별도 트랙). 내지=PRD_000286 구성원 별도.',
    'Y', now()
)
ON CONFLICT (frm_cd) DO UPDATE SET
    frm_nm=EXCLUDED.frm_nm, note=EXCLUDED.note, use_yn='Y', upd_dt=now()
WHERE t_prc_price_formulas.frm_nm IS DISTINCT FROM EXCLUDED.frm_nm
   OR t_prc_price_formulas.note   IS DISTINCT FROM EXCLUDED.note
   OR t_prc_price_formulas.use_yn IS DISTINCT FROM 'Y';

-- ---------------------------------------------------------------
-- [위상 0b] 부모공식 비목 배선 (formula_components)
--    제본비 component COMP_BIND_HC_TWINRING (실재·미바인딩) → addtn_yn='Y'(가산)
--    ★S8 가드: 무선 COMP_HC_MUSEON_COVERBIND·일반 COMP_BIND_TWINRING(071용) 배선 금지(오염).
--    COMP_BIND_HC_TWINRING.use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"] → proc_cd=PROC_000024 단가행 매칭.
-- ---------------------------------------------------------------
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_HC_TWINRING_SET', 'COMP_BIND_HC_TWINRING', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, addtn_yn=EXCLUDED.addtn_yn, upd_dt=now()
WHERE t_prc_formula_components.disp_seq  IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn;

-- ---------------------------------------------------------------
-- [위상 1] 내지 반제품 신설 (search-before-mint: MAX=PRD_000285 → 286·라이브 미존재 확인)
--    prd_typ=PRD_TYPE.02(반제품) · 284(하드커버책자-내지)/285(레더 내지) 동형 · 082 전용 링 내지
-- ---------------------------------------------------------------
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000286', '하드커버 링책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- [위상 2] 내지286 차원 충전 (285 동형 · 가격계산 환원 차원)
--    사이즈 3 (A5 dflt / B5 / A4) · 인쇄옵션 2 (단면 / 양면 dflt) · 자재(내지종이) 9 (백모조100 dflt)
--    ★페이지룰은 셋트행 min/max(8~100/+2)로 제어 — 082 권위는 8/100/+2(★072/077 24/300과 다름)
-- ---------------------------------------------------------------

-- 2a) 사이즈 (285 동형: SIZ_000170 A5 dflt · SIZ_000380 B5 · SIZ_000172 A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000286', 'SIZ_000170', 'Y', 1, now(), 'N'),
    ('PRD_000286', 'SIZ_000380', 'N', 2, now(), 'N'),
    ('PRD_000286', 'SIZ_000172', 'N', 3, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- 2b) 인쇄옵션 (285 동형: 단면 POPT_000001 · 양면 POPT_000002 dflt)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000286', 1, '단면', 'CLR_000005', 'CLR_000001', 'N', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000286', 2, '양면', 'CLR_000005', 'CLR_000005', 'Y', 1, 'POPT_000002', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- 2c) 내지종이 자재 (285 동형 9종: 백모조100 dflt + 8종 — COMP_PAPER 단가행 mat_cd 충전돼 있음)
--     usage_cd='USAGE.07'(내지종이 용도·284/285 동형·NOT NULL) · PK=(prd_cd,mat_cd,usage_cd)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000286', 'MAT_000072', 'USAGE.07', 'Y', 1, now(), 'N'),  -- 백색모조지 100g
    ('PRD_000286', 'MAT_000073', 'USAGE.07', 'N', 2, now(), 'N'),  -- 백색모조지 120g
    ('PRD_000286', 'MAT_000086', 'USAGE.07', 'N', 3, now(), 'N'),  -- 스노우지 100g
    ('PRD_000286', 'MAT_000087', 'USAGE.07', 'N', 4, now(), 'N'),  -- 스노우지 120g
    ('PRD_000286', 'MAT_000076', 'USAGE.07', 'N', 5, now(), 'N'),  -- 아트지 100g
    ('PRD_000286', 'MAT_000077', 'USAGE.07', 'N', 6, now(), 'N'),  -- 아트지 120g
    ('PRD_000286', 'MAT_000104', 'USAGE.07', 'N', 7, now(), 'N'),  -- 몽블랑 100g
    ('PRD_000286', 'MAT_000105', 'USAGE.07', 'N', 8, now(), 'N'),  -- 몽블랑 130g
    ('PRD_000286', 'MAT_000095', 'USAGE.07', 'N', 9, now(), 'N')   -- 앙상블 100g
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- 2d) 판형 (285 동형 SIZ_000499=316x467·PDF) — ★내지 단가행(DIGITAL_S1·PAPER) plt_siz_cd 환원 키
--     이게 없으면 내지인쇄비/용지비가 판형 미환원 → 내지가 0 = 저청구. PRICE≠0 보증 필수.
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000286', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------
-- [위상 3] 내지286 가격공식 바인딩 (PRF_DGP_INNER 재사용 · 신설 0)
--    PRF_DGP_INNER = COMP_PRINT_DIGITAL_S1(인쇄비) + COMP_PAPER(용지비) · 공유 단가행
-- ---------------------------------------------------------------
-- PK=(prd_cd, apply_bgn_ymd) — 상품×적용일 1공식. frm_cd는 충돌 시 EXCLUDED로 갱신.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000286', 'PRF_DGP_INNER', '2026-06-06', '하드커버 링책자 내지 구성원(디지털 합가형·284/285 동형·페이지8~100)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 4] 082 부모공식 바인딩 (PRF_HC_TWINRING_SET 신설분 바인딩 · 082 견적 0원 직접 해소)
--    제본비 합산(COMP_BIND_HC_TWINRING 6밴드·링) — ★무선 PRF_HC_MUSEON_SET 재사용 금지
-- ---------------------------------------------------------------
-- PK=(prd_cd, apply_bgn_ymd) — 082×2026-06-06 1공식. frm_cd는 충돌 시 EXCLUDED로 갱신.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000082', 'PRF_HC_TWINRING_SET', '2026-06-06', '하드커버 링책자 세트 부모(링 전용 제본 합산·신설). 내지=286 구성원 별도. 표지/면지 ×2 비목 BLOCKED.', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 5] 082 셋트행 6행 보정 (복합PK 멱등 · 072 동형 + 면지4종)
--    표지083(seq1·min1/max1) + 내지286(seq2·신규·page8~100/+2)
--    + 면지084/085/086/087(seq3~6·택1·유료비목은 BLOCKED·현 무료 보존)
-- ---------------------------------------------------------------

-- 5a) 표지083 — 개수규칙 충전(min1/max1)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000082', 'PRD_000083', 1, 1, 1, NULL, 1, '표지=전용지·1권고정(인쇄/코팅 ×2비목 BLOCKED)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt, cnt_incr=EXCLUDED.cnt_incr,
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.min_cnt   IS DISTINCT FROM EXCLUDED.min_cnt
   OR t_prd_product_sets.max_cnt   IS DISTINCT FROM EXCLUDED.max_cnt
   OR t_prd_product_sets.disp_seq  IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note      IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn    IS DISTINCT FROM 'N';

-- 5b) 내지286 — 신규 member (페이지 8~100/+2 = derive_inner_sheets 입력 차원·★082 권위)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000082', 'PRD_000286', 1, 8, 100, 2, 2, '내지=별도설정종이·페이지8~100/+2(★072/077 24~300과 다름)', now(), 'N')
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

-- 5c) 면지 화이트084 — disp_seq 2→3 (택1그룹·유료비목 BLOCKED·현 무료 보존)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000082', 'PRD_000084', 1, NULL, NULL, NULL, 3, '면지=화이트면지·택1그룹(인쇄/코팅 ×2 유료비목 BLOCKED-CONFIRM)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- 5d) 면지 블랙085 — disp_seq 3→4
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000082', 'PRD_000085', 1, NULL, NULL, NULL, 4, '면지=블랙면지·택1그룹(유료비목 BLOCKED-CONFIRM)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- 5e) 면지 그레이086 — disp_seq 4→5
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000082', 'PRD_000086', 1, NULL, NULL, NULL, 5, '면지=그레이면지·택1그룹(유료비목 BLOCKED-CONFIRM)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- 5f) 면지 인쇄087 — disp_seq 5→6 (★082 4번째 면지·인쇄면지·인쇄有 추가단가 가능성=CONFIRM)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000082', 'PRD_000087', 1, NULL, NULL, NULL, 6, '면지=인쇄면지·택1그룹(★082/088 전용 4번째·인쇄추가단가 BLOCKED-CONFIRM)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------
-- 사후 검증(읽기) — load-executor 트랜잭션 내 확인용
--   기대: 082 셋트 6행(표지1+내지1+면지4)·disp_seq 1~6 단조·내지 min8/max100/incr2
--   082 부모공식 1행(PRF_HC_TWINRING_SET·신설)·내지286 공식 1행(PRF_DGP_INNER)
--   PRF_HC_TWINRING_SET formula_components 1행(COMP_BIND_HC_TWINRING·addtn_yn=Y)
--   내지286 사이즈3·인쇄옵션2·자재9·판형1
-- ---------------------------------------------------------------
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note
-- FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND del_yn='N' ORDER BY disp_seq;
-- SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000082','PRD_000286');
-- SELECT frm_cd, comp_cd, addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_HC_TWINRING_SET';
-- SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000286';

-- ================================================================
-- BLOCKED (본 SQL 미포함 · 인간 승인 후 별도 트랙):
--   BLOCKED-COVER-MYUNJI-PRINT : 표지인쇄비·표지코팅비·면지인쇄비·면지코팅비(권위 비목·전부 ×2).
--     라이브에 링 표지/면지 인쇄·코팅 component 단가행 부재(072 표지=COVERBIND bundle 흡수·면지=무료라
--     별도 단가행 없음). 082 분해형 비목 단가행을 §18 설계+라이브 격자 probe로 신설해야 함.
--     해법: COMP_PRINT_COVER_*·COMP_COAT_COVER_*·COMP_PRINT_MYUNJI_* 단가행 신설 + PRF_HC_TWINRING_SET 비목 배선.
--     → §18 가격설계 + 082 라이브 ASP 골든 역산 + 인간 승인. 본 SQL 동작은 제본+내지 골든 경로.
--   BLOCKED-COVERMULT-X2 : 표지/면지 ×2(앞뒤 물리 2장·링=책등無). 권위 (3)~(6) 명시.
--     권고=단가행 2매분 내재(데이터 흡수·엔진 ×2 곱셈 불요). 엔진 ×2 곱셈 경로는 C트랙(미지원).
--     → §18 설계(단가행 ×2 내재) 또는 개발팀(엔진). 동작화 막지 않음(077 +3,900 동형).
--   CONFIRM-MYUNJI-PAID : 082 면지=유료 비목(권위 면지인쇄·코팅 ×2 명시) vs 072 면지=무료(라이브 동형).
--     면지 가격 기여·종류별 단가·인쇄면지(087) 추가단가 → domain-researcher/실무진·082 라이브 ASP 역산.
--   BLOCKED-MAT-REWIRE : 082 부모 좀비 자재 link 점검(MAT_000246/001/013/002/014/015/004 활성·MAT_000003만 del_yn=Y).
--     072/077 동형 오염 가능성. 표지083 자재=전용지 배선(현 0행)·면지 정자재.
--     → dbmap/basecode·link만(마스터 삭제 금지)·견적 미관여(정합)·인간 승인.
--   C-TRACK-ENGINE : COMP_BIND_HC_TWINRING ×copies(권당)·책등 by 페이지·DBLPANSU 내지 이중÷pansu(전 책자 공통).
--     cover_mult ×2 곱셈 미지원 — 입력값 우회 명시(골든 페이지 환산 시 고려). 개발팀(webadmin·072 동형).
-- ================================================================
