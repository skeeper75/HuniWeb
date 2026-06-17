-- L3 마감가공 단가행 5 (component_prices·opt_cd별·단가 verbatim)
-- ============================================================================
-- COMP_POSTEROPT_LINEN_FINISH 에 opt_cd별 단가 5행. 단가 verbatim(사용자 명시):
--   오버로크 OPV_000025          = 0
--   오버로크+리본끈 OPV-000024   = 800
--   말아박기 OPV_000026          = 1000
--   말아박기+면끈 OPV_000424     = 2000
--   봉미싱(7cm) OPV_000027       = 2000
-- proc_cd=PROC_000080(봉제)·apply_ymd='2026-06-01'(sibling POSTEROPT 단가행 관행).
-- comp_price_id = 시퀀스 자동(surrogate PK·omit). 0원(오버로크)=명시 0행(견적 "무료" 표시·미적재 아님).
-- 멱등: (comp_cd,opt_cd,apply_ymd) 논리키 NOT EXISTS 가드(자연키 unique 제약 부재→PK 시퀀스라 NOT EXISTS 필수).
-- ============================================================================
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, opt_cd, proc_cd, unit_price, note, reg_dt)
SELECT v.comp_cd, v.apply_ymd, v.opt_cd, 'PROC_000080', v.unit_price, v.note, now()
FROM (VALUES
  ('COMP_POSTEROPT_LINEN_FINISH','2026-06-01','OPV_000025',   0::numeric, '오버로크(무료 기본)'),
  ('COMP_POSTEROPT_LINEN_FINISH','2026-06-01','OPV-000024', 800::numeric, '오버로크+리본끈'),
  ('COMP_POSTEROPT_LINEN_FINISH','2026-06-01','OPV_000026',1000::numeric, '말아박기'),
  ('COMP_POSTEROPT_LINEN_FINISH','2026-06-01','OPV_000424',2000::numeric, '말아박기+면끈'),
  ('COMP_POSTEROPT_LINEN_FINISH','2026-06-01','OPV_000027',2000::numeric, '봉미싱(7cm)')
) AS v(comp_cd, apply_ymd, opt_cd, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd = v.comp_cd AND cp.apply_ymd = v.apply_ymd AND cp.opt_cd = v.opt_cd
);
