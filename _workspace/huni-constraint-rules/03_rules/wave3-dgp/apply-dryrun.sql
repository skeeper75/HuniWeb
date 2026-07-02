-- =====================================================================
-- Huni-Constraint-Rules · wave-3 · PRD_000047 소량전단지
-- CN-3 코팅×종이두께 — "코팅은 180g 이상 종이에서만" (RULE_TYPE.02 금지·안전형)
-- 유도 시점: 2026-07-02 17:04:07 · 원천: 라이브 t_prd_product_options/option_items(읽기전용)
-- 생성: gen_sql.py (derived-rules.json verbatim) · 임계 180g · 차단 종이 15종
-- search-before-mint: 047 기존 제약 0건(논리삭제 대상 없음) · 순수 신규 mint 1건
-- =====================================================================

BEGIN;

INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000047', 'R_EXCL_COATING_THIN_PAPER', '[제약조건] 코팅은 두꺼운 종이(180g 이상)에서만 가능', 'RULE_TYPE.02',
   '{"!": {"and": [{"or": [{"in": ["OPV_000280", {"var": "sel_opts"}]}, {"in": ["OPV_000281", {"var": "sel_opts"}]}]}, {"or": [{"===": [{"var": "mat_cd__usage_cd"}, "MAT_000072__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000073__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000076__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000077__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000078__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000086__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000087__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000088__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000095__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000096__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000097__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000104__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000105__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000106__USAGE.07"]}, {"===": [{"var": "mat_cd__usage_cd"}, "MAT_000125__USAGE.07"]}]}]}}'::jsonb,
   '코팅은 두꺼운 종이(180g 이상)에서만 가능합니다. 종이를 180g 이상으로 바꾸거나 코팅을 빼 주세요.', 1, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();

-- 검증: 047 활성 제약(신규 1건) 확인
SELECT prd_cd, rule_cd, rule_typ_cd, use_yn, del_yn, disp_seq,
       jsonb_typeof(logic) AS logic_type
  FROM t_prd_product_constraints
 WHERE prd_cd = 'PRD_000047'
 ORDER BY del_yn, disp_seq;

ROLLBACK;  -- DRY-RUN: 실제 반영 안 함
