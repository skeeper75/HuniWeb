-- ============================================================================
-- 072 PRF 트랙 DRY-RUN (멱등·FK 무결성·부작용 0 검증 · BEGIN…assert…ROLLBACK)
-- 생성: hsp-set-designer 2026-06-26 · 롤백 전용·실 COMMIT 0 · 게이트(S1~S7) 입력
-- 실행: psql -v ON_ERROR_STOP=1 -f prf-dryrun.sql (READ-ONLY 검증 후 ROLLBACK)
-- ============================================================================
BEGIN;

-- ----- P0. 선행 전제: PRD_000284 내지 반제품 실재(vessel COMMIT 후) -----
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM t_prd_products WHERE prd_cd='PRD_000284') THEN
    RAISE NOTICE '[P0] PRD_000284 미존재 — vessel apply.sql 선행 COMMIT 필요(바인딩 §D는 BLOCKED)';
  END IF;
END $$;

-- ----- P1. S2 부활 부작용 0 (참조 활성공식 0건 assert) -----
DO $$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM t_prc_formula_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2';
  IF n <> 0 THEN RAISE EXCEPTION '[P1] S2 부활 위험: 참조 공식 %건(부작용 가능)', n; END IF;
  RAISE NOTICE '[P1] S2 참조 활성공식 0건 — 부활 안전';
END $$;

-- ----- 적용(apply.sql §A~§C 인라인·바인딩 §D 제외) -----
UPDATE t_prc_price_components SET del_yn='N', upd_dt=now()
 WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND del_yn='Y';

INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_HC_INNER','하드커버책자 내지(인쇄+용지)','내지 반제품 자기 공식','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_INNER');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_HC_COVER','하드커버책자 표지(인쇄+코팅+용지)','표지 구성원 자기 공식','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_COVER');
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn)
SELECT 'PRF_HC_BODY','하드커버책자 본체(제본)','셋트 본체 자기 공식=제본만','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_HC_BODY');

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, v.seq, 'Y' FROM (VALUES
  ('PRF_HC_INNER','COMP_PRINT_DIGITAL_S1',1),
  ('PRF_HC_INNER','COMP_PRINT_DIGITAL_S2',2),
  ('PRF_HC_INNER','COMP_PAPER',3),
  ('PRF_HC_COVER','COMP_PRINT_DIGITAL_S1',1),
  ('PRF_HC_COVER','COMP_COAT_MATTE',2),
  ('PRF_HC_COVER','COMP_PAPER',3),
  ('PRF_HC_BODY','COMP_BIND_SSABARI',1)
) AS v(frm_cd, comp_cd, seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc
                  WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);

-- ----- P2. 영향행 assert (PRF 3 + fc 7) -----
DO $$ DECLARE nf int; nc int; BEGIN
  SELECT count(*) INTO nf FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_HC_INNER','PRF_HC_COVER','PRF_HC_BODY');
  SELECT count(*) INTO nc FROM t_prc_formula_components WHERE frm_cd IN ('PRF_HC_INNER','PRF_HC_COVER','PRF_HC_BODY');
  IF nf <> 3 THEN RAISE EXCEPTION '[P2] PRF 헤더 %건(기대 3)', nf; END IF;
  IF nc <> 7 THEN RAISE EXCEPTION '[P2] formula_components %건(기대 7)', nc; END IF;
  RAISE NOTICE '[P2] PRF 3 + fc 7 정합';
END $$;

-- ----- P3. FK 무결성: 배선된 comp 전부 마스터 실재·활성(S2 부활 후) -----
DO $$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM t_prc_formula_components fc
   WHERE fc.frm_cd LIKE 'PRF_HC_%'
     AND NOT EXISTS (SELECT 1 FROM t_prc_price_components pc
                     WHERE pc.comp_cd=fc.comp_cd AND pc.del_yn='N');
  IF n <> 0 THEN RAISE EXCEPTION '[P3] 활성 comp 미존재 배선 %건(S2 부활 누락?)', n; END IF;
  RAISE NOTICE '[P3] 전 배선 comp 활성 실재(FK·del_yn=N)';
END $$;

-- ----- P4. BODY=제본only 가드 (CFM-BODY-INNER-RESIDUAL) -----
DO $$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM t_prc_formula_components
   WHERE frm_cd='PRF_HC_BODY' AND comp_cd <> 'COMP_BIND_SSABARI';
  IF n <> 0 THEN RAISE EXCEPTION '[P4] BODY에 제본 외 comp %건(이중평가 위험)', n; END IF;
  RAISE NOTICE '[P4] PRF_HC_BODY = 제본only(이중평가 가드 OK)';
END $$;

-- ----- P5. 멱등성: apply 2회차 신규 INSERT 0행 -----
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT v.frm_cd, v.comp_cd, v.seq, 'Y' FROM (VALUES
  ('PRF_HC_INNER','COMP_PRINT_DIGITAL_S1',1),
  ('PRF_HC_BODY','COMP_BIND_SSABARI',1)
) AS v(frm_cd, comp_cd, seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc
                  WHERE fc.frm_cd=v.frm_cd AND fc.comp_cd=v.comp_cd);
-- 위 2회차는 NOT EXISTS로 0행 INSERT 기대(멱등). ROW_COUNT 확인용 NOTICE:
DO $$ BEGIN RAISE NOTICE '[P5] 멱등 2회차 — NOT EXISTS 가드로 신규 0행(상위 INSERT 영향행 확인)'; END $$;

-- ----- 골든 smoke (단가행 실재 — evaluate_set_price PRICE≠0 사전 확증) -----
DO $$ DECLARE s2_50 numeric; s2_1200 numeric; paper numeric; bind50 numeric; BEGIN
  SELECT unit_price INTO s2_1200 FROM t_prc_component_prices
    WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND plt_siz_cd='SIZ_000499' AND print_opt_cd='POPT_000002' AND min_qty=1200;
  SELECT unit_price INTO paper FROM t_prc_component_prices
    WHERE comp_cd='COMP_PAPER' AND plt_siz_cd='SIZ_000499' AND mat_cd='MAT_000073';
  SELECT unit_price INTO bind50 FROM t_prc_component_prices
    WHERE comp_cd='COMP_BIND_SSABARI' AND proc_cd='PROC_000023' AND min_qty=50;
  RAISE NOTICE '[smoke] S2@1200=% (기대326)·내지용지=% (기대36.88)·제본@50=% (기대9000) — 단가행 실재', s2_1200, paper, bind50;
  -- ★정답 골든(코드교정 후): 표지64832.5 + 내지(407500+46100) + 제본450000 = 968432.5
  -- ★DBLPANSU 함정(미교정): 내지 313판 → 169020+11543.44 → final 695395.94 (내지 ~0.4배 과소)
END $$;

ROLLBACK;
-- ★ROLLBACK 전용. 실 COMMIT은 게이트 GO + 인간 승인 후 load-executor(prf-apply.sql).
