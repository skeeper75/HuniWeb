-- 제약조건데모 등록 (2026-07-02, 사용자 지시)
-- 목적: 자재↔사이즈 엇갈림 조합(단가행 없음=0원)을 제약으로 차단하는 데모.
--   PRD_000130 포맥스보드: 자재명에 사이즈 내장(3mm/5mm × A3/A2) — 자재별 필수동반 사이즈.
--   PRD_000129 폼보드:     자재명에 사이즈 내장(화이트/블랙 × A3/A2) — 자재별 필수동반 사이즈.
-- 규칙유형 RULE_TYPE.03(필수동반) 의미 구조: AND[ or(자재≠X, 사이즈=Y) × 4 ]
-- var 계약: mat_cd__usage_cd(결합키) · siz_cd  (views.py VAR_KEY_MAP · 검증 미리보기와 정합)
-- 멱등: ON CONFLICT (prd_cd, rule_cd) DO UPDATE. undo = constraint-demo-260702-undo.sql

BEGIN;

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn, reg_dt)
VALUES
('PRD_000130', 'R_DEMO_MATSIZ', '제약조건데모', 'RULE_TYPE.03',
 '{"and":[
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000022__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000174"]}]},
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000023__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000174"]}]},
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000554__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000197"]}]},
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000555__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000197"]}]}
 ]}'::jsonb,
 '자재와 사이즈가 맞지 않습니다. A3 자재는 A3 사이즈, A2 자재는 A2 사이즈를 선택하세요.',
 1, 'Y', 'N', now()),
('PRD_000129', 'R_DEMO_MATSIZ', '제약조건데모', 'RULE_TYPE.03',
 '{"and":[
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000398__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000315"]}]},
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000399__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000315"]}]},
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000612__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000198"]}]},
   {"or":[{"!==":[{"var":"mat_cd__usage_cd"},"MAT_000613__USAGE.07"]},{"===":[{"var":"siz_cd"},"SIZ_000198"]}]}
 ]}'::jsonb,
 '자재와 사이즈가 맞지 않습니다. A3 자재는 A3 사이즈, A2 자재는 A2 사이즈를 선택하세요.',
 1, 'Y', 'N', now())
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm,
  rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic,
  err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq,
  use_yn = 'Y', del_yn = 'N', del_dt = NULL,
  upd_dt = now();

-- 사후 확인
SELECT prd_cd, rule_cd, rule_nm, rule_typ_cd, use_yn, del_yn
FROM t_prd_product_constraints
WHERE prd_cd IN ('PRD_000129','PRD_000130') AND rule_cd='R_DEMO_MATSIZ';

COMMIT;
