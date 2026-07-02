-- =====================================================================
-- Huni-Constraint-Rules · wave-1 파일럿 · 129 폼보드 / 130 포맥스보드
-- CN-2 자재↔사이즈 엇갈림 제약 (RULE_TYPE.03 필수동반)
-- 유도 시점: 2026-07-02 13:59:30 · 원천: 라이브 t_prc_component_prices(읽기전용)
-- 생성: gen_sql.py (derived-rules.json verbatim) · 멱등 UPSERT
-- =====================================================================

BEGIN;

-- 기존 데모 규칙 논리삭제(search-before-mint): 구 R_DEMO_MATSIZ 는 1규칙 AND-of-OR 구조로
-- 폼빌더 역파싱 불가 → 자재별 8규칙으로 분할 대체. 물리삭제 아님(del_yn='Y').
UPDATE t_prd_product_constraints
   SET use_yn = 'N', del_yn = 'Y', upd_dt = now()
 WHERE prd_cd IN ('PRD_000129','PRD_000130') AND rule_cd = 'R_DEMO_MATSIZ';

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000129', 'R_MATSIZ_FB_A3_WHITE_5MM', '[제약조건데모] A3 폼보드(화이트) 5mm 는 A3 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000398__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000315"]}]}'::jsonb,
   '이 자재(A3 폼보드(화이트) 5mm)는 A3 크기 전용입니다. 크기를 A3로 선택해 주세요.', 1, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000129', 'R_MATSIZ_FB_A3_BLACK_5MM', '[제약조건데모] A3 폼보드(블랙) 5mm 는 A3 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000399__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000315"]}]}'::jsonb,
   '이 자재(A3 폼보드(블랙) 5mm)는 A3 크기 전용입니다. 크기를 A3로 선택해 주세요.', 2, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000129', 'R_MATSIZ_FB_A2_WHITE_5MM', '[제약조건데모] A2 폼보드(화이트) 5mm 는 A2 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000612__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000198"]}]}'::jsonb,
   '이 자재(A2 폼보드(화이트) 5mm)는 A2 크기 전용입니다. 크기를 A2로 선택해 주세요.', 3, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000129', 'R_MATSIZ_FB_A2_BLACK_5MM', '[제약조건데모] A2 폼보드(블랙) 5mm 는 A2 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000613__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000198"]}]}'::jsonb,
   '이 자재(A2 폼보드(블랙) 5mm)는 A2 크기 전용입니다. 크기를 A2로 선택해 주세요.', 4, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000130', 'R_MATSIZ_FX_A3_WHITE_3MM', '[제약조건데모] 포맥스(화이트) 3mm A3 는 A3 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000022__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000174"]}]}'::jsonb,
   '이 자재(포맥스(화이트) 3mm A3)는 A3 크기 전용입니다. 크기를 A3로 선택해 주세요.', 1, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000130', 'R_MATSIZ_FX_A2_WHITE_3MM', '[제약조건데모] 포맥스(화이트) 3mm A2 는 A2 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000554__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000197"]}]}'::jsonb,
   '이 자재(포맥스(화이트) 3mm A2)는 A2 크기 전용입니다. 크기를 A2로 선택해 주세요.', 2, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000130', 'R_MATSIZ_FX_A3_WHITE_5MM', '[제약조건데모] 포맥스(화이트) 5mm A3 는 A3 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000023__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000174"]}]}'::jsonb,
   '이 자재(포맥스(화이트) 5mm A3)는 A3 크기 전용입니다. 크기를 A3로 선택해 주세요.', 3, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000130', 'R_MATSIZ_FX_A2_WHITE_5MM', '[제약조건데모] 포맥스(화이트) 5mm A2 는 A2 크기 전용', 'RULE_TYPE.03',
   '{"or": [{"!": {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000555__USAGE.07"]}}, {"===": [{"var": "siz_cd"}, "SIZ_000197"]}]}'::jsonb,
   '이 자재(포맥스(화이트) 5mm A2)는 A2 크기 전용입니다. 크기를 A2로 선택해 주세요.', 4, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

-- 검증: 활성 제약 8건(129·130 각 4) + 구 데모 비활성 확인
SELECT prd_cd, rule_cd, rule_typ_cd, use_yn, del_yn, disp_seq
  FROM t_prd_product_constraints WHERE prd_cd IN ('PRD_000129','PRD_000130')
  ORDER BY prd_cd, del_yn, disp_seq;

ROLLBACK;  -- DRY-RUN: 실제 반영 안 함
