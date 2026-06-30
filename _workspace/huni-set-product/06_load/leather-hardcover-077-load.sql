-- ================================================================
-- 레더 하드커버책자(PRD_000077) 셋트 동작화 적재본 (멱등·FK 위상순·DRY-RUN)
-- 생성: hsp-set-designer 2026-06-30
-- 권위: 03_design/leather-hardcover-077-authority.md (권위 대조 결판)
--       상품마스터 booklet-l1 row36~38 · 계산공식집 하드커버무선 · 072 동형(동작 기준)
-- 목적: 077 견적 0원(부모공식 0행) 해소 → PRICE≠0 (전용지 골든 46,900 경로)
-- 라이브 실측(2026-06-30·읽기전용): 부모 PRD_000077=완제품·공식 0행·셋트 4행(내지 부재)
--   PRF_HC_MUSEON_SET 실재(072 바인딩)·PRF_DGP_INNER 실재·COMP_HC_MUSEON_COVERBIND 6밴드 verbatim
--   공유 단가행(COMP_PRINT_DIGITAL_S1 424행·COMP_PAPER 81행)=상품 비종속(내지 단가행 신규 0)
--   MAX prd_cd=PRD_000284 → 내지 mint=PRD_000285
-- 트랜잭션: BEGIN/COMMIT 미내장 (load-executor가 단일 트랜잭션 래핑·DRY-RUN=ROLLBACK).
-- DB 미적재: 실 COMMIT은 게이트 DRY-RUN + 인간 승인 후.
-- ================================================================

-- ================================================================
-- [스코프 = PRICE≠0 동작화] : 본 SQL은 077을 "전용지 골든 경로"(46,900)로 동작시킨다.
--   ★레더 표지 +3,900(골든 50,800) 정확값은 본 SQL 밖(BLOCKED-COVERBIND-LEATHER).
--    이유(라이브 실측): COMP_HC_MUSEON_COVERBIND.use_dims = ["min_qty"] 만 — mat_cd 분기축 없음.
--    레더 단가행을 mat_cd=MAT_000186 으로 추가하면 엔진(_match_entry)이 그 행을 키로 인식 못해
--    silent 무시 또는 동시매칭(AMBIGUOUS)으로 합산 제외될 위험 → use_dims 스키마 변경 또는
--    별도 component 신설이 선행돼야 함(§18 가격설계 + 엔진 거동 검증 + 인간 승인). 본 SQL 미포함.
-- ================================================================

-- ---------------------------------------------------------------
-- [위상 1] 내지 반제품 신설 (search-before-mint: MAX=PRD_000284 → 285·라이브 미존재 확인)
--    prd_typ=PRD_TYPE.02(반제품) · 284(하드커버책자-내지) 동형 · 077 전용 레더 내지
-- ---------------------------------------------------------------
INSERT INTO t_prd_products
    (prd_cd, prd_nm, prd_typ_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, reg_dt, del_yn)
VALUES
    ('PRD_000285', '레더 하드커버책자-내지', 'PRD_TYPE.02', 'N', 'Y', 'N', 'Y', now(), 'N')
ON CONFLICT (prd_cd) DO NOTHING;

-- ---------------------------------------------------------------
-- [위상 2] 내지285 차원 충전 (284 동형 · 가격계산 환원 차원)
--    사이즈 3 (A5 dflt / B5 / A4) · 인쇄옵션 2 (단면 / 양면 dflt) · 자재(내지종이) 9 (백모조100 dflt)
--    page_rules 미충전(284 동형) — 페이지는 셋트행 min/max(24~300/+2)로 제어
-- ---------------------------------------------------------------

-- 2a) 사이즈 (284 동형: SIZ_000170 A5 dflt · SIZ_000380 B5 · SIZ_000172 A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000285', 'SIZ_000170', 'Y', 1, now(), 'N'),
    ('PRD_000285', 'SIZ_000380', 'N', 2, now(), 'N'),
    ('PRD_000285', 'SIZ_000172', 'N', 3, now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_sizes.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_sizes.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sizes.del_yn IS DISTINCT FROM 'N';

-- 2b) 인쇄옵션 (284 동형: 단면 POPT_000001 · 양면 POPT_000002 dflt)
INSERT INTO t_prd_product_print_options
    (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn) VALUES
    ('PRD_000285', 1, '단면', 'CLR_000005', 'CLR_000001', 'N', 1, 'POPT_000001', now(), 'N'),
    ('PRD_000285', 2, '양면', 'CLR_000005', 'CLR_000005', 'Y', 1, 'POPT_000002', now(), 'N')
ON CONFLICT (prd_cd, opt_id) DO UPDATE SET
    print_side=EXCLUDED.print_side, front_colrcnt_cd=EXCLUDED.front_colrcnt_cd,
    back_colrcnt_cd=EXCLUDED.back_colrcnt_cd, dflt_yn=EXCLUDED.dflt_yn,
    print_opt_cd=EXCLUDED.print_opt_cd, del_yn='N', upd_dt=now()
WHERE t_prd_product_print_options.print_opt_cd IS DISTINCT FROM EXCLUDED.print_opt_cd
   OR t_prd_product_print_options.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_print_options.del_yn IS DISTINCT FROM 'N';

-- 2c) 내지종이 자재 (284 동형 9종: 백모조100 dflt + 8종 — COMP_PAPER 단가행 mat_cd 충전돼 있음)
--     usage_cd='USAGE.07'(내지종이 용도·284 동형·NOT NULL) · PK=(prd_cd,mat_cd,usage_cd)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn) VALUES
    ('PRD_000285', 'MAT_000072', 'USAGE.07', 'Y', 1, now(), 'N'),  -- 백색모조지 100g
    ('PRD_000285', 'MAT_000073', 'USAGE.07', 'N', 2, now(), 'N'),  -- 백색모조지 120g
    ('PRD_000285', 'MAT_000086', 'USAGE.07', 'N', 3, now(), 'N'),  -- 스노우지 100g
    ('PRD_000285', 'MAT_000087', 'USAGE.07', 'N', 4, now(), 'N'),  -- 스노우지 120g
    ('PRD_000285', 'MAT_000076', 'USAGE.07', 'N', 5, now(), 'N'),  -- 아트지 100g
    ('PRD_000285', 'MAT_000077', 'USAGE.07', 'N', 6, now(), 'N'),  -- 아트지 120g
    ('PRD_000285', 'MAT_000104', 'USAGE.07', 'N', 7, now(), 'N'),  -- 몽블랑 100g
    ('PRD_000285', 'MAT_000105', 'USAGE.07', 'N', 8, now(), 'N'),  -- 몽블랑 130g
    ('PRD_000285', 'MAT_000095', 'USAGE.07', 'N', 9, now(), 'N')   -- 앙상블 100g
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO UPDATE SET
    dflt_yn=EXCLUDED.dflt_yn, disp_seq=EXCLUDED.disp_seq, del_yn='N', upd_dt=now()
WHERE t_prd_product_materials.dflt_yn IS DISTINCT FROM EXCLUDED.dflt_yn
   OR t_prd_product_materials.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_materials.del_yn IS DISTINCT FROM 'N';

-- 2d) 판형 (284 동형 SIZ_000499=316x467·PDF) — ★내지 단가행(DIGITAL_S1·PAPER) plt_siz_cd 환원 키
--     이게 없으면 내지인쇄비/용지비가 판형 미환원 → 내지가 0 = 저청구. PRICE≠0 보증 필수.
INSERT INTO t_prd_product_plate_sizes
    (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn) VALUES
    ('PRD_000285', 'SIZ_000499', 'N', 'OUTPUT_PAPER_TYPE.01', 'PDF', now(), 'N')
ON CONFLICT (prd_cd, siz_cd) DO UPDATE SET
    dflt_plt_yn=EXCLUDED.dflt_plt_yn, output_paper_typ_cd=EXCLUDED.output_paper_typ_cd,
    output_file_typ=EXCLUDED.output_file_typ, del_yn='N', upd_dt=now()
WHERE t_prd_product_plate_sizes.output_paper_typ_cd IS DISTINCT FROM EXCLUDED.output_paper_typ_cd
   OR t_prd_product_plate_sizes.del_yn IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------
-- [위상 3] 내지285 가격공식 바인딩 (PRF_DGP_INNER 재사용 · 신설 0)
--    PRF_DGP_INNER = COMP_PRINT_DIGITAL_S1(인쇄비) + COMP_PAPER(용지비) · 공유 단가행
-- ---------------------------------------------------------------
-- PK=(prd_cd, apply_bgn_ymd) — 상품×적용일 1공식. frm_cd는 충돌 시 EXCLUDED로 갱신.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000285', 'PRF_DGP_INNER', '2026-06-06', '레더 하드커버책자 내지 구성원(디지털 합가형·284 동형)', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 4] 077 부모공식 바인딩 (PRF_HC_MUSEON_SET 재사용 · 072 동형 · 신설 0)
--    표지+제본 권당 합산(COMP_HC_MUSEON_COVERBIND 6밴드) — 077 견적 0원의 직접 해소
-- ---------------------------------------------------------------
-- PK=(prd_cd, apply_bgn_ymd) — 077×2026-06-06 1공식. frm_cd는 충돌 시 EXCLUDED로 갱신.
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES
    ('PRD_000077', 'PRF_HC_MUSEON_SET', '2026-06-06', '레더 하드커버책자 표지+제본 합산(세트 부모·072 동형 재사용). 내지=285 구성원 별도.', now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO UPDATE SET
    frm_cd=EXCLUDED.frm_cd, note=EXCLUDED.note, upd_dt=now()
WHERE t_prd_product_price_formulas.frm_cd IS DISTINCT FROM EXCLUDED.frm_cd
   OR t_prd_product_price_formulas.note   IS DISTINCT FROM EXCLUDED.note;

-- ---------------------------------------------------------------
-- [위상 5] 077 셋트행 5행 보정 (복합PK 멱등 · 072 동형 구조)
--    표지078(seq1·min1/max1) + 내지285(seq2·신규·page24~300/+2) + 면지079/080/081(seq3/4/5·무료 택1)
-- ---------------------------------------------------------------

-- 5a) 표지078 — 개수규칙 충전(min1/max1)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000077', 'PRD_000078', 1, 1, 1, NULL, 1, '표지=레더(화이트)·1권고정', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt, cnt_incr=EXCLUDED.cnt_incr,
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.min_cnt   IS DISTINCT FROM EXCLUDED.min_cnt
   OR t_prd_product_sets.max_cnt   IS DISTINCT FROM EXCLUDED.max_cnt
   OR t_prd_product_sets.disp_seq  IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note      IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn    IS DISTINCT FROM 'N';

-- 5b) 내지285 — 신규 member (페이지 24~300/+2 = derive_inner_sheets 입력 차원)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000077', 'PRD_000285', 1, 24, 300, 2, 2, '내지=별도설정종이·페이지24~300/+2(284 동형)', now(), 'N')
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

-- 5c) 면지 화이트079 — disp_seq 2→3 (가격0 무료 택1 유지)
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000077', 'PRD_000079', 1, NULL, NULL, NULL, 3, '면지=화이트면지·택1그룹(무료)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- 5d) 면지 블랙080 — disp_seq 3→4
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000077', 'PRD_000080', 1, NULL, NULL, NULL, 4, '면지=블랙면지·택1그룹(무료)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- 5e) 면지 그레이081 — disp_seq 4→5
INSERT INTO t_prd_product_sets
    (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, reg_dt, del_yn)
VALUES
    ('PRD_000077', 'PRD_000081', 1, NULL, NULL, NULL, 5, '면지=그레이면지·택1그룹(무료)', now(), 'N')
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
    disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now()
WHERE t_prd_product_sets.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq
   OR t_prd_product_sets.note     IS DISTINCT FROM EXCLUDED.note
   OR t_prd_product_sets.del_yn   IS DISTINCT FROM 'N';

-- ---------------------------------------------------------------
-- 사후 검증(읽기) — load-executor 트랜잭션 내 확인용
--   기대: 077 셋트 5행(표지1+내지1+면지3)·disp_seq 1~5 단조·내지 min24/max300/incr2
--   077 부모공식 1행(PRF_HC_MUSEON_SET)·내지285 공식 1행(PRF_DGP_INNER)
--   내지285 사이즈3·인쇄옵션2·자재9
-- ---------------------------------------------------------------
-- SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note
-- FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N' ORDER BY disp_seq;
-- SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000077','PRD_000285');
-- SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000285';

-- ================================================================
-- BLOCKED (본 SQL 미포함 · 인간 승인 후 별도 트랙):
--   BLOCKED-COVERBIND-LEATHER : 레더 표지 +3,900(골든 50,800) 정확값.
--     COMP_HC_MUSEON_COVERBIND.use_dims=["min_qty"]만 → mat_cd 분기 단가행 silent 무시 위험.
--     해법: (A) use_dims에 mat_cd 추가 + 레더(MAT_000186) 단가행 6밴드(전용지+3,900) 추가
--           (B) COMP_HC_LEATHER_COVERBIND 별도 신설 + PRF 분기 배선
--     → §18 가격설계 + 엔진 거동 검증 + 라이브 격자 probe + 인간 승인. 본 SQL 동작은 전용지 골든(46,900) 경로.
--   BLOCKED-MAT-REWIRE : 077 부모 좀비 MAT_000002(아크릴 활성·del_yn=N) link 제거(003은 이미 del_yn=Y).
--     표지078 자재=레더(MAT_000186/379) link 추가(현 몽블랑130 ×2는 이미 del_yn=Y로 비어있음).
--     → dbmap/basecode·link만(마스터 삭제 금지)·견적 미관여(정합)·인간 승인.
--   CONFIRM-LEATHER-PRINT : 표지 특수인쇄(A5)/실사출력(A4) 단가가 레자인쇄=+3,900에 포함되는지 → 실무진.
--   C-TRACK-ENGINE : COVERBIND ×qty(권당)·책등 by 페이지·DBLPANSU 내지 이중÷pansu — 072 동형 코드결함(개발팀).
-- ================================================================
