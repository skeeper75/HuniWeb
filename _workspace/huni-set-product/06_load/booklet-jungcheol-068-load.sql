-- ================================================================
-- 중철 소프트커버책자(PRD_000068) 셋트 동작화 적재본 (멱등·FK 위상순·DRY-RUN)
-- 생성: hsp-set-designer 2026-07-01
-- 권위: booklet-068-071-design.md rev.2 · booklet-cover-branch-design.md(데이터 GO/cover_mult×2 BLOCKED)
--       상품마스터 booklet-l1 · 계산공식집 중철책자 · 077/082 동형(동작 기준·방금 COMMIT)
-- 목적: 068 저청구(부모공식=제본 JUNGCHEOL 1개만·표지/내지/용지 누락) → 내지+제본 PRICE≠0
--       (077=레더표지 BLOCKED·전용지 골든부터 / 082=표지/면지×2 BLOCKED·제본+내지부터 와 동형)
-- 라이브 실측(2026-07-01·읽기전용):
--   PRD_000068=완제품(PRD_TYPE.01)·셋트 0행·page_rule 4/28/4
--   부모공식 PRF_BIND_SUM → COMP_BIND_JUNGCHEOL 1개만(068 전용·공유 0)=제본비만 저청구
--   ★068=분해형(077/082=통합형 COVERBIND와 근본 다름) — 표지 인쇄+코팅+용지 3비목
--   ★068 완제품 판형=SIZ_000250/251/252/181(150x214 등) / 표지·내지 단가행 plt_siz_cd=SIZ_000499(316x467)뿐
--      → 표지/내지를 부모공식 직배선하면 068판형으로 plt_siz 환원→단가행 NO_MATCH→비용0(저청구).
--      ∴ 077/082처럼 내지를 별 member 반제품으로 분리(SIZ_000499 판형 부여)해야 환원·매칭됨.
--   MAX prd_cd=PRD_000286(082 내지 점유) → 068 내지 mint=PRD_000287
--   공유 단가행(DIGITAL_S1 SIZ_000499 proc_grp:PROC_000001·COMP_PAPER SIZ_000499)=상품 비종속(내지 단가행 신규 0)
--   골든 verbatim(SIZ_000499·proc_cd=PROC_000004): S1 POPT_000001 100매=350·POPT_000002=700·POPT_000008=200·POPT_000009=400
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor가 단일 트랜잭션 래핑·DRY-RUN=ROLLBACK).
-- DB 미적재: 실 COMMIT은 게이트 DRY-RUN + 인간 승인 후.
-- ================================================================

-- ================================================================
-- [스코프 = PRICE≠0 동작화] : 본 SQL은 068을 "내지+제본 골든 경로"로 동작시킨다.
--   ★표지인쇄·표지코팅·표지용지(분해형 3비목) 정확값은 본 SQL 밖(BLOCKED-COVER-FORMULA).
--    이유(라이브 실측·search-before-mint):
--     ① 표지 3비목(인쇄 S1·코팅 MATTE/GLOSSY·용지 PAPER)만 가진 "깔끔한 표지 분해형 공식"이
--        라이브에 부재. 코팅 포함 공식(PRF_DGP_A/D/E)은 전부 굿즈/명함/리플렛 후가공 comp
--        (코너라운딩·미싱·접지·가변텍스트 등 8~17개)가 섞여 있음 → 068 표지에 빌리면 §3 옵션 오염
--        (S8 위반·무관 옵션 노출). 가격은 NO_MATCH로 0 기여라 silent overcharge는 없으나, 정책상 금지.
--     ② 표지 member 공식은 인쇄+코팅+용지 3비목 전용 신규 공식(PRF_BIND_SUM_COVER 등)을
--        §18에서 신설해야 깔끔(068~071 분해형 공통·dbmap mint+인간 승인).
--    → BLOCKED-COVER-FORMULA로 분리. 본 SQL은 내지+제본 골든(PRICE≠0)을 먼저 달성.
--    저청구 잔존하나 0원 아님(내지 인쇄+용지 + 제본 70,000 ≈ 비0 즉시).
--   ★cover_mult ×2 이슈 없음: 068 중철=PROC_000018(책등 접지)=펼침 cover_mult=1
--    → 표지 출력 ×1(copies). 071/082 트윈링/링(×2) BLOCKED와 무관(068은 ×배수 자체 없음).
-- ================================================================

-- ---------------------------------------------------------------
-- [위상 1] 내지 반제품 신설 (search-before-mint: MAX=PRD_000286 → 287·라이브 미존재 확인)
--    prd_typ=PRD_TYPE.02(반제품) · 284/285/286(하드커버/레더/링 내지) 동형 · 068 전용 중철 내지
-- ---------------------------------------------------------------
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000287', '중철책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- [위상 2] 내지287 차원 충전 (284/285/286 동형 · 가격계산 환원 차원)
--    사이즈 3 (A5 dflt / B5 / A4) · 인쇄옵션 4 (068 완제품 칼라단/양면 + 흑백단/양면 — 중철내지 흔히 흑백)
--    자재(내지종이) 9 (백모조100 dflt)
--    ★페이지룰은 셋트행 min/max(4~28/+4 = 068 page_rule)로 제어
-- ---------------------------------------------------------------

-- 2a) 사이즈 (284~286 동형: SIZ_000170 A5 dflt · SIZ_000380 B5 · SIZ_000172 A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000287', 'SIZ_000170', 'Y', 1, now(), 'N'),
    ('PRD_000287', 'SIZ_000380', 'N', 2, now(), 'N'),
    ('PRD_000287', 'SIZ_000172', 'N', 3, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- 2b) 인쇄옵션 (★068 중철내지=칼라/흑백 둘 다 — POPT 칼라단001/양면002 + 흑백단008/양면009)
--     도수 라벨[HARD·booklet-cover-branch §4.3]: POPT_000001=칼라(CMYK)단면·002=칼라양면·
--       008=흑백1도 단면·009=흑백1도 양면. 칼라350/700·흑백200/400(저청구·과청구 가드).
--     dflt=양면(POPT_000009 흑백양면 — 중철내지 일반 흑백 / 칼라양면도 운영자 택1 가능)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000287', 1, '단면', 'CLR_000005', 'CLR_000001', 'N', 1, 'POPT_000001', now(), 'N'),  -- 칼라단면
    ('PRD_000287', 2, '양면', 'CLR_000005', 'CLR_000005', 'N', 2, 'POPT_000002', now(), 'N'),  -- 칼라양면
    ('PRD_000287', 3, '단면', 'CLR_000001', 'CLR_000001', 'N', 3, 'POPT_000008', now(), 'N'),  -- 흑백단면
    ('PRD_000287', 4, '양면', 'CLR_000001', 'CLR_000001', 'Y', 4, 'POPT_000009', now(), 'N')   -- 흑백양면 dflt
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- 2c) 내지종이 자재 (284~286 동형 9종: 백모조100 dflt — COMP_PAPER SIZ_000499 단가행 충전됨)
--     usage_cd='USAGE.07'(내지종이 용도·284~286 동형·NOT NULL) · PK=(prd_cd,mat_cd,usage_cd)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000287', 'MAT_000072', 'USAGE.07', 'Y', 1, now(), 'N'),  -- 백색모조지 100g
    ('PRD_000287', 'MAT_000073', 'USAGE.07', 'N', 2, now(), 'N'),  -- 백색모조지 120g
    ('PRD_000287', 'MAT_000086', 'USAGE.07', 'N', 3, now(), 'N'),  -- 스노우지 100g
    ('PRD_000287', 'MAT_000087', 'USAGE.07', 'N', 4, now(), 'N'),  -- 스노우지 120g
    ('PRD_000287', 'MAT_000076', 'USAGE.07', 'N', 5, now(), 'N'),  -- 아트지 100g
    ('PRD_000287', 'MAT_000077', 'USAGE.07', 'N', 6, now(), 'N'),  -- 아트지 120g
    ('PRD_000287', 'MAT_000104', 'USAGE.07', 'N', 7, now(), 'N'),  -- 몽블랑 100g
    ('PRD_000287', 'MAT_000105', 'USAGE.07', 'N', 8, now(), 'N'),  -- 몽블랑 130g
    ('PRD_000287', 'MAT_000095', 'USAGE.07', 'N', 9, now(), 'N')   -- 앙상블 100g
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- 2d) 판형 (284~286 동형 SIZ_000499=316x467·PDF) — ★내지 단가행(DIGITAL_S1·PAPER) plt_siz_cd 환원 키
--     이게 없으면 내지인쇄비/용지비가 판형 미환원(068 완제품판형 SIZ_000250은 단가행 없음)
--     → 내지가 0 = 저청구. PRICE≠0 보증 필수. fn_calc_pansu(SIZ_000499, A5)=4판.
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000287', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------
-- [위상 3] 내지287 가격공식 바인딩 (PRF_DGP_INNER 재사용 · 신설 0 · 077/082 동형)
--    PRF_DGP_INNER = COMP_PRINT_DIGITAL_S1(인쇄비) + COMP_PAPER(용지비) · 공유 단가행
--    ★깔끔한 2비목(굿즈 후가공 오염 없음 — 077/082 검증 동형) → 옵션 오염 없음.
-- ---------------------------------------------------------------
-- PK=(prd_cd, apply_bgn_ymd) — 상품×적용일 1공식. frm_cd는 충돌 시 EXCLUDED로 갱신.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000287', 'PRF_DGP_INNER', '2026-06-06', '중철책자 내지 구성원(디지털 합가형·284~286 동형·페이지4~28)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 4] 068 부모공식 = 기존 PRF_BIND_SUM 유지 (재바인딩 불요·이미 실재·068 전용)
--    PRF_BIND_SUM → COMP_BIND_JUNGCHEOL(제본비) 1비목. 068×2026-06-01 이미 바인딩됨.
--    ★표지 3비목(인쇄/코팅/용지)은 PRF_BIND_SUM에 추가배선하지 않음(BLOCKED-COVER-FORMULA):
--      - 표지 comp는 plt_siz_cd 차원 → 068 완제품판형(SIZ_000250)으로 환원→단가행(SIZ_000499) NO_MATCH→비용0.
--      - 깔끔한 표지 분해형 공식 부재(코팅 공식 전부 굿즈/명함 오염) → 표지 member 분리+신규공식=§18 BLOCKED.
--    따라서 본 위상은 NO-OP(기존 PRF_BIND_SUM 멱등 재확인만). 077/082는 부모공식 0행이라 신규 바인딩이
--    필요했으나, 068은 이미 PRF_BIND_SUM 바인딩 보유(제본 정답값) → 동작화는 내지 member 추가가 전부.
-- ---------------------------------------------------------------
-- (멱등 재확인 — 변경 없으면 무동작)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000068', 'PRF_BIND_SUM', '2026-06-01', '중철책자→제본 구성요소(세트 부모·제본비 JUNGCHEOL). 표지 3비목=BLOCKED-COVER-FORMULA(§18 신규공식). 내지=287 구성원 별도.', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 5] 068 셋트행 구성 (복합PK 멱등 · 077/082 동형 · ★068=면지 없음)
--    내지287(seq1·신규·page4~28/+4 = 068 page_rule)
--    + 표지(BLOCKED — 표지 반제품도 라이브 부재·표지공식도 부재 → 표지 member 추가는 별도 트랙)
--    ★068=중철 소프트커버 → 면지 없음(072/077/082 하드커버와 달리 면지 구성원 0·booklet-cover-branch §0.1)
--    ★표지 member 미추가 사유: 표지 반제품(중철책자-표지) 라이브 부재 + 표지공식 부재(BLOCKED).
--      077/082는 표지 반제품(078/083)이 이미 있었으나, 068은 표지 반제품 자체가 없음(추가 복잡분).
-- ---------------------------------------------------------------

-- 5a) 내지287 — 신규 member (페이지 4~28/+4 = derive_inner_sheets 입력 차원·068 page_rule verbatim)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000068', 'PRD_000287', 1, 4, 28, 4, 1, '내지=중철내지종이·페이지4~28/+4(068 page_rule verbatim·★072/077 24~300·082 8~100과 다름)', now(), 'N')
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

-- ---------------------------------------------------------------
-- 사후 검증(읽기) — load-executor 트랜잭션 내 확인용
--   기대: 068 셋트 1행(내지287·면지없음·표지 BLOCKED)·disp_seq 1·내지 min4/max28/incr4
--   068 부모공식 1행(PRF_BIND_SUM·기존)·내지287 공식 1행(PRF_DGP_INNER)
--   내지287 사이즈3·인쇄옵션4(칼라단/양면+흑백단/양면)·자재9·판형1(SIZ_000499)
--   ★PRICE≠0 경로: evaluate_set_price(068, members=[내지287], set_selections=제본, copies)
--     = 내지(S1 인쇄 + PAPER 용지) + 부모공식(JUNGCHEOL 제본 × copies) > 0
-- ---------------------------------------------------------------
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note
-- FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND del_yn='N' ORDER BY disp_seq;
-- SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000068','PRD_000287');
-- SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000287';
-- SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000287' AND del_yn='N';      -- 3
-- SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000287' AND del_yn='N'; -- 4
-- SELECT count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000287' AND del_yn='N';   -- 9

-- ================================================================
-- BLOCKED (본 SQL 미포함 · 인간 승인 후 별도 트랙):
--   BLOCKED-COVER-FORMULA : 068 표지인쇄·표지코팅·표지용지(분해형 3비목·전부 cover_mult=1·×1).
--     ① 깔끔한 표지 분해형 공식 부재(코팅 공식 PRF_DGP_A/D/E는 전부 굿즈/명함/리플렛 후가공 comp 오염).
--        → 인쇄+코팅+용지 3비목 전용 신규 공식(예 PRF_BIND_SUM_COVER / PRF_COVER_DGP) §18 신설.
--     ② 표지 반제품(중철책자-표지) 라이브 부재 → mint 필요(dbmap·PRD_000288 채번·SIZ_000499 판형).
--     ③ 표지 member.qty = copies × cover_mult(=1·펼침) — 068은 ×1이라 cover_mult ×2 BLOCKED 무관
--        (071/082만 ×2 BLOCKED). 068 표지는 호출자 qty=copies 주입으로 즉시 정확(엔진 코드 0).
--     해법: §18 표지공식 신설 + 표지 반제품 mint(dbmap) + 셋트행 표지 member 추가 + 인간 승인.
--     골든(데이터 트랙 GO·booklet-cover-branch §4.3): G-CB-068A 표지칼라단면 백모120 무광 100부
--       = 인쇄 350×100=35,000 + 코팅 500×100=50,000 + 용지 36.88×100=3,688 = 표지소계 88,688
--       (제본 70,000 + 표지 88,688 = 부모 158,688 검증값). 단가 verbatim 실측 일치(SIZ_000499).
--   BLOCKED-MAT-REWIRE : 068 완제품 자재 USAGE.01/02(표지·내지용도) link 점검 — 표지 3비목 신설 시
--     표지용지 자재 매핑(현 068 완제품에 MAT_000073 등 USAGE.01/02 다수). 견적 미관여(정합)·인간 승인.
--   C-TRACK-ENGINE : DBLPANSU 내지 이중÷pansu(price_views.py:1707·전 책자 공통·072/077/082 동형 코드결함).
--     068 내지도 동일 — 골든 페이지 환산 시 입력값 우회 명시. 개발팀(webadmin·1회 교정이 전 책자 해소).
-- ================================================================
