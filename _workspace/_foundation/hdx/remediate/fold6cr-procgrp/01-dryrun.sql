-- COMP_FOLD_CARD_6CR use_dims proc_grp 보강 — DRY-RUN (ROLLBACK)
-- ============================================================================
-- 목적 : contribution scan 6단접지 잔존오탐 제거
--        (지그재그엽서 PRD_000030 6단오시접지 PROC_000073 / 6단미싱접지 PROC_000074
--         UNCOVERED_PROCESS HIGH 2건 = 오탐).
-- 근거 : 오시/미싱 COMP(COMP_PP_CREASE_1L)와 동일 배선 패턴. 카드접지 COMP 만 proc_grp
--        선언이 누락된 데이터 불일치. COMP_FOLD_CARD_6CR 은 공식 PRF_DGP_C_6CR 에 이미
--        배선·과금 완비([묶음 동일단가: 6단오시접지 / 6단미싱접지] · min_qty 구간별).
-- 가격중립 : ① 엔진(engine.py=pricing.py verbatim)은 proc_grp 를 사용하지 않음
--            ② 단가행은 min_qty 만으로 매칭(오시/미싱접지 동일단가) → 단가 매칭 불변.
-- 확증 : overlay 재스캔(스냅샷 사본에 본 교정 적용) = 지그재그 6단접지 오탐 2건 소멸,
--        전체 UNCOVERED HIGH 7→5(남은 5=전부 진짜 저청구: 타공2·UV평판·도장인쇄·전사인쇄).
-- ============================================================================
BEGIN;

DROP TABLE IF EXISTS z_bak_fold6cr_usedims;
CREATE TABLE z_bak_fold6cr_usedims AS
  SELECT comp_cd, use_dims
    FROM t_prc_price_components
   WHERE comp_cd = 'COMP_FOLD_CARD_6CR';

UPDATE t_prc_price_components
   SET use_dims = '["min_qty", "proc_grp:PROC_000073", "proc_grp:PROC_000074"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'COMP_FOLD_CARD_6CR';

-- 게이트: 정확히 1행이 두 proc_grp 를 담아야 한다.
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n
    FROM t_prc_price_components
   WHERE comp_cd = 'COMP_FOLD_CARD_6CR'
     AND use_dims @> '["proc_grp:PROC_000073", "proc_grp:PROC_000074"]'::jsonb
     AND use_dims @> '["min_qty"]'::jsonb;
  IF n <> 1 THEN
    RAISE EXCEPTION 'gate fail: expected 1 row with proc_grp+min_qty, got %', n;
  END IF;
END $$;

SELECT comp_cd, use_dims FROM t_prc_price_components WHERE comp_cd = 'COMP_FOLD_CARD_6CR';

ROLLBACK;  -- DRY-RUN. 인간 승인 + webadmin 실화면(지그재그엽서 견적 불변) 확인 후 02-fix.sql 실행.
