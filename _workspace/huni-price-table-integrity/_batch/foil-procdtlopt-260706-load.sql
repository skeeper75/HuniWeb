-- 박(foil) prcs_dtl_opt 가로×세로 price_dim 정식화 + use_dims proc_grp 일관화 (결함4·박 0원 저청구 해소)
-- 설계: dim-editor-audit/FOIL-PROCDTLOPT-DESIGN-260706.md §4
-- 기전: pricing.py _derive_price_dims는 price_dim 선언만이 박 가로/세로를 selections.siz_width/height로 주입.
--   현 단일 "크기"(price_dim 없음)=주입 0 → 박 flatten 단가행 미매칭 → 박 가공비 0원(체계적 저청구).
-- 실측 확증(027·proc PROC_000038): 면적 미주입 박=0 / 30×30 주입 박=76,000 / 100×100 주입 박=147,000.
-- ★단가행·가격값 절대 무변경(t_proc_processes.prcs_dtl_opt 2행 + t_prc_price_components.use_dims 5행 메타만).
--   proc_grp는 엔진 무참조(NON_QTY/TIER_DIMS 미포함·L685 ":" 제외)=돈영향 0·편집 그룹핑만.
-- [HARD] COMMIT은 인간 승인 + 사후 webadmin 시뮬레이터(박 견적 정상화) 확인 후. 위젯 계약(박영역 가로/세로 전송)=후속 게이트.

BEGIN;

-- 4-1. prcs_dtl_opt 정식화 (박 PROC_000033 · 형압 PROC_000050 동형·형압 comp 0=forward 그릇)
UPDATE t_proc_processes
SET prcs_dtl_opt = '{"inputs":[{"key":"가로","type":"number","unit":"mm","price_dim":"siz_width"},{"key":"세로","type":"number","unit":"mm","price_dim":"siz_height"}]}'::jsonb
WHERE proc_cd = 'PROC_000033'
  AND prcs_dtl_opt = '{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}'::jsonb;   -- 멱등 가드

UPDATE t_proc_processes
SET prcs_dtl_opt = '{"inputs":[{"key":"가로","type":"number","unit":"mm","price_dim":"siz_width"},{"key":"세로","type":"number","unit":"mm","price_dim":"siz_height"}]}'::jsonb
WHERE proc_cd = 'PROC_000050'
  AND prcs_dtl_opt = '{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}'::jsonb;

-- 4-2. use_dims proc_grp 일관화 (5행·SMALL_STD는 이미 보유→멱등 가드로 0행)
UPDATE t_prc_price_components
SET use_dims = use_dims || '["proc_grp:PROC_000033"]'::jsonb
WHERE comp_cd IN ('COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL',
                  'COMP_FOIL_PROC_SMALL_SPECIAL','COMP_FOIL_SETUP_LARGE','COMP_FOIL_SETUP_SMALL')
  AND NOT (use_dims @> '["proc_grp:PROC_000033"]'::jsonb);

-- 사후 검증(트랜잭션 내)
SELECT proc_cd, prcs_dtl_opt::text FROM t_proc_processes WHERE proc_cd IN ('PROC_000033','PROC_000050') ORDER BY proc_cd;
SELECT comp_cd, use_dims::text FROM t_prc_price_components
WHERE comp_cd LIKE 'COMP_FOIL_%' ORDER BY comp_cd;

COMMIT;
