-- 088 레더 링바인더 재설계 — UNDO (현 임시 COVERBIND 모델로 대칭 복원)
-- 생성 2026-07-02 · hsp-set-design · apply.sql 적용분을 되돌려 재설계 前 상태(1부34,100/100부796,900)로 환원.
-- ★ 멱등. BEGIN/COMMIT 미내장 — load-executor가 트랜잭션 래핑. 실 COMMIT 인간 승인 후.
-- 순서: 부모공식 원복(6/7 역) → 089 바인딩 제거(5 역) → mint 배선/공식/단가/component 제거(4/3/2/1 역) → 088 proc 제거(8 역)

-- (7 역) 부모공식 싸바리 배선 제거
DELETE FROM t_prc_formula_components
WHERE frm_cd = 'PRF_LEATHER_RINGBINDER_SET' AND comp_cd = 'COMP_BIND_SSABARI';

-- (6 역) 부모공식 COVERBIND 배선 복원 (재설계 前 = 유일 배선)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_LEATHER_RINGBINDER_SET', 'COMP_HC_MUSEON_COVERBIND', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq = 1, addtn_yn = 'Y', upd_dt = now();

-- (5 역) member 089 표지 공식 바인딩 제거 (재설계 前 = 089 공식 0건)
DELETE FROM t_prd_product_price_formulas
WHERE prd_cd = 'PRD_000089' AND apply_bgn_ymd = '2026-01-01' AND frm_cd = 'PRF_LEATHER_RINGBINDER_COVER';

-- (4 역) 표지 공식 배선 제거
DELETE FROM t_prc_formula_components
WHERE frm_cd = 'PRF_LEATHER_RINGBINDER_COVER' AND comp_cd = 'COMP_LEATHER_RINGBINDER_COVER';

-- (3 역) 표지 공식 제거
DELETE FROM t_prc_price_formulas WHERE frm_cd = 'PRF_LEATHER_RINGBINDER_COVER';

-- (2 역) 표지 단가행 제거
DELETE FROM t_prc_component_prices
WHERE comp_cd = 'COMP_LEATHER_RINGBINDER_COVER' AND apply_ymd = '2026-06-01' AND min_qty = 1;

-- (1 역) 표지 component 제거 (mint 되돌림)
DELETE FROM t_prc_price_components WHERE comp_cd = 'COMP_LEATHER_RINGBINDER_COVER';

-- (8 역) 088 proc PROC_000098 제거 (재설계 前 = 088 proc 0건)
DELETE FROM t_prd_product_processes WHERE prd_cd = 'PRD_000088' AND proc_cd = 'PROC_000098';

-- 참고: COMP_HC_MUSEON_COVERBIND / COMP_BIND_SSABARI component 자체는 apply.sql이 삭제하지 않았으므로 UNDO 대상 아님(존치).
