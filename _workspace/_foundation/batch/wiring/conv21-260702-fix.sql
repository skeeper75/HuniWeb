-- ============================================================================
-- §27 전수 수렴 round21 교정 DRYRUN (BEGIN…ROLLBACK) — 2026-07-02
-- 대상 5건: ①삭제오염 복원 ②110 base proc ③020 인쇄옵션 ④고아 use_yn=N 정리
--          ⑤포맥스 5mm BOARD 동형 확장(폼보드 패턴)
-- 근거: wiring_scan round21(결함10) + contribution_sim_scan(HIGH 13→진짜 2상품)
--       + design-foldcard-260701.md + design-foamboard-260701.md(라이브 재실측 갱신)
-- ============================================================================
BEGIN;

-- ── ① 삭제오염 복원: 082 셋트 공식이 참조하는 제본비 comp(6/17 논리삭제분) ──
UPDATE t_prc_price_components
SET del_yn='N', del_dt=NULL, upd_dt=now()
WHERE comp_cd='COMP_BIND_HC_TWINRING' AND del_yn='Y';

-- ── ② 110 엽서캘린더: 디지털인쇄 base 공정 미등록 → 인쇄비 영구0 (108/109 동형 누락분) ──
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000110','PROC_000004','Y',-1, now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
                  WHERE prd_cd='PRD_000110' AND proc_cd='PROC_000004' AND del_yn='N');

-- ── ③ 020 화이트인쇄엽서: 인쇄옵션 0건 → 별색인쇄비(SPOT) 영구0. 021/022 동형 등록 ──
--    (dflt: 단면 Y·양면 N — R3 단일기본 준수. SPOT 단가행 proc008×POPT1/2 각 53행 실재)
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, reg_dt, del_yn, print_opt_cd)
SELECT 'PRD_000020',1,'단면','CLR_000005','CLR_000001','Y',1,now(),'N','POPT_000001'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
                  WHERE prd_cd='PRD_000020' AND print_opt_cd='POPT_000001' AND del_yn='N');
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, reg_dt, del_yn, print_opt_cd)
SELECT 'PRD_000020',2,'양면','CLR_000005','CLR_000005','N',2,now(),'N','POPT_000002'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options
                  WHERE prd_cd='PRD_000020' AND print_opt_cd='POPT_000002' AND del_yn='N');

-- ── ④ 고아 정리(use_yn=N·삭제 금지) ──
-- 접지카드 3단: 리플렛 3FOLD 단가 verbatim 동일 → FOLD_LEAF 재사용 확정(design-foldcard §4a). 중복 comp 은퇴.
UPDATE t_prc_price_components
SET use_yn='N', upd_dt=now(),
    note = coalesce(note,'') || ' [use_yn=N 260702: 리플렛 COMP_FOLD_LEAF_3FOLD(단가 verbatim 동일)로 대체 운영·중복 은퇴]'
WHERE comp_cd='COMP_FOLD_CARD_3H' AND use_yn='Y';
-- 폼보드 블랙/화이트: BOARD(mat×siz) comp로 대체(260701 복구 커밋). 구 siz단독 comp 은퇴 + 화이트 stale 배선 제거.
UPDATE t_prc_price_components
SET use_yn='N', upd_dt=now(),
    note = coalesce(note,'') || ' [use_yn=N 260702: COMP_POSTER_FOAMBOARD_BOARD(mat×siz)로 대체·은퇴]'
WHERE comp_cd IN ('COMP_POSTER_FOAMBOARD_BLACK','COMP_POSTER_FOAMBOARD_WHITE') AND use_yn='Y';
DELETE FROM t_prc_formula_components
WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_WHITE';

-- ── ⑤ 포맥스보드(130) 두께축 BOARD 동형 확장 — 실무진 등록 자재 4종 재사용(mint 0) ──
-- 5a. 상품자재 등록 (폼보드 동형: USAGE.07·dflt N)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT v.prd, v.mat, 'USAGE.07', 'N', v.seq, now(), 'N'
FROM (VALUES ('PRD_000130','MAT_000022',1),   -- 포맥스(화이트) 3mm A3
             ('PRD_000130','MAT_000554',2),   -- 포맥스(화이트) 3mm A2
             ('PRD_000130','MAT_000023',3),   -- 포맥스(화이트) 5mm A3
             ('PRD_000130','MAT_000555',4))   -- 포맥스(화이트) 5mm A2
     AS v(prd, mat, seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials
                  WHERE prd_cd=v.prd AND mat_cd=v.mat AND del_yn='N');

-- 5b. BOARD comp 신설 (폼보드 COMP_POSTER_FOAMBOARD_BOARD 동형)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, prc_typ_cd, use_dims, del_yn)
SELECT 'COMP_POSTER_FOMEXBOARD_BOARD','포맥스보드(두께×사이즈) 완제품가','PRC_COMPONENT_TYPE.06',
       '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 두께=자재축(3mm/5mm)×사이즈. 폼보드 BOARD 동형 260702. 단가=가격표260527 verbatim.',
       'Y', now(), 'PRICE_TYPE.01', '["mat_cd", "siz_cd"]'::jsonb, 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOMEXBOARD_BOARD');

-- 5c. 단가행 4행 verbatim (IDENTITY setval 선행 — 시퀀스 드리프트 가드)
SELECT setval(pg_get_serial_sequence('t_prc_component_prices','comp_price_id'),
              (SELECT max(comp_price_id) FROM t_prc_component_prices));
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, unit_price, note, reg_dt)
SELECT v.comp, DATE '2026-06-01', v.siz, v.mat, v.p, v.note, now()
FROM (VALUES
  ('COMP_POSTER_FOMEXBOARD_BOARD','SIZ_000174','MAT_000022', 8500.00,'포맥스보드/화이트3mm/A3 완제품가 260527 verbatim (BOARD 동형 260702)'),
  ('COMP_POSTER_FOMEXBOARD_BOARD','SIZ_000197','MAT_000554',13000.00,'포맥스보드/화이트3mm/A2 완제품가 260527 verbatim (BOARD 동형 260702)'),
  ('COMP_POSTER_FOMEXBOARD_BOARD','SIZ_000174','MAT_000023',10000.00,'포맥스보드/화이트5mm/A3 완제품가 260527 verbatim (BOARD 동형 260702)'),
  ('COMP_POSTER_FOMEXBOARD_BOARD','SIZ_000197','MAT_000555',16000.00,'포맥스보드/화이트5mm/A2 완제품가 260527 verbatim (BOARD 동형 260702)'))
 AS v(comp, siz, mat, p, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices
                  WHERE comp_cd=v.comp AND siz_cd=v.siz AND mat_cd=v.mat);

-- 5d. 배선 교체: BOARD 배선 + 구 WHITE3MM 배선 제거(이중합산 차단) + 구 comp 은퇴
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_POSTER_FOMEXBOARD','COMP_POSTER_FOMEXBOARD_BOARD',1,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components
                  WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_BOARD');
DELETE FROM t_prc_formula_components
WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE3MM';
UPDATE t_prc_price_components
SET use_yn='N', upd_dt=now(),
    note = coalesce(note,'') || ' [use_yn=N 260702: COMP_POSTER_FOMEXBOARD_BOARD(mat×siz)로 대체·은퇴]'
WHERE comp_cd IN ('COMP_POSTER_FOMEXBOARD_WHITE3MM','COMP_POSTER_FOMEXBOARD_WHITE5MM') AND use_yn='Y';

-- ============================== 검증 어서션 ==============================
-- V1 삭제오염 해소
SELECT 'V1', count(*) AS expect_1 FROM t_prc_price_components
WHERE comp_cd='COMP_BIND_HC_TWINRING' AND del_yn='N';
-- V2 110 base proc
SELECT 'V2', count(*) AS expect_1 FROM t_prd_product_processes
WHERE prd_cd='PRD_000110' AND proc_cd='PROC_000004' AND del_yn='N' AND mand_proc_yn='Y';
-- V3 020 인쇄옵션 2행
SELECT 'V3', count(*) AS expect_2 FROM t_prd_product_print_options
WHERE prd_cd='PRD_000020' AND del_yn='N';
-- V4 고아 comp 은퇴 5건
SELECT 'V4', count(*) AS expect_5 FROM t_prc_price_components
WHERE comp_cd IN ('COMP_FOLD_CARD_3H','COMP_POSTER_FOAMBOARD_BLACK','COMP_POSTER_FOAMBOARD_WHITE',
                  'COMP_POSTER_FOMEXBOARD_WHITE3MM','COMP_POSTER_FOMEXBOARD_WHITE5MM')
  AND use_yn='N';
-- V5 포맥스 BOARD: comp 1·단가 4·배선 1·구배선 0
SELECT 'V5a', count(*) AS expect_1 FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOMEXBOARD_BOARD' AND use_yn='Y';
SELECT 'V5b', count(*) AS expect_4 FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_FOMEXBOARD_BOARD';
SELECT 'V5c', count(*) AS expect_1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_BOARD';
SELECT 'V5d', count(*) AS expect_0 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE3MM';
-- V6 포맥스 disjoint: (siz,mat) 조합별 활성 배선 comp 매칭 정확히 1 (구 WHITE 계열 잔존 매칭 0)
SELECT 'V6', v.siz, v.mat, count(*) AS expect_1
FROM (VALUES ('SIZ_000174','MAT_000022'),('SIZ_000197','MAT_000554'),
             ('SIZ_000174','MAT_000023'),('SIZ_000197','MAT_000555')) AS v(siz,mat)
JOIN t_prc_formula_components fc ON fc.frm_cd='PRF_POSTER_FOMEXBOARD'
JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
 AND (cp.siz_cd IS NULL OR cp.siz_cd=v.siz) AND (cp.mat_cd IS NULL OR cp.mat_cd=v.mat)
GROUP BY v.siz, v.mat;
-- V7 130 상품자재 4행
SELECT 'V7', count(*) AS expect_4 FROM t_prd_product_materials WHERE prd_cd='PRD_000130' AND del_yn='N';

COMMIT;
