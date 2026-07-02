-- =====================================================================
-- Huni-Constraint-Rules · wave-3 · PRD_000047 소량전단지
-- CN-3 코팅×종이두께 — "코팅은 180g 이상 종이에서만" (RULE_TYPE.02 금지·안전형)
-- 유도 시점: 2026-07-02 17:04:07 · 원천: 라이브 t_prd_product_options/option_items(읽기전용)
-- 생성: gen_sql.py (derived-rules.json verbatim) · 임계 180g · 차단 종이 15종
-- search-before-mint: 047 기존 제약 0건(논리삭제 대상 없음) · 순수 신규 mint 1건
-- =====================================================================
-- UNDO: 신규 규칙 논리삭제(대칭 복원). 047 은 이전 제약 없었음.

BEGIN;

UPDATE t_prd_product_constraints
   SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000047' AND rule_cd='R_EXCL_COATING_THIN_PAPER';

COMMIT;
