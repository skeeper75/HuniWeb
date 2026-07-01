-- jibbitz-tbd-cleanup-fix.sql — 156 재바인딩으로 고아화된 placeholder 공식 정리(dead wire 해소)
-- PRF_ACRYL_ZIBITZ_TBD: 156 외 바인딩 0(고아)·PRF_ZIBITZ_ACRYL로 대체됨. 공유 COMP_ACRYL_PENDING_TBD는 보존(6개 _TBD 공유).
BEGIN;
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_ACRYL_ZIBITZ_TBD' AND comp_cd='COMP_ACRYL_PENDING_TBD';  -- dead wire 제거
UPDATE t_prc_price_formulas SET use_yn='N', upd_dt=now() WHERE frm_cd='PRF_ACRYL_ZIBITZ_TBD';                    -- 공식 소프트 은퇴(감사 보존)
COMMIT;
