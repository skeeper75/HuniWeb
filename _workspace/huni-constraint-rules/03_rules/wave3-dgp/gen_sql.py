#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""wave-3 적재본 SQL 생성 (derived-rules.json verbatim → dryrun/fix/undo).

멱등 UPSERT (ON CONFLICT (prd_cd, rule_cd)). 047 은 기존 제약 0건(search-before-mint 확인)이라
논리삭제 대상 없음 — 순수 신규 mint 1건. undo 는 신규 규칙 논리삭제(대칭 복원).
"""
import json
import os

here = os.path.dirname(os.path.abspath(__file__))
d = json.load(open(os.path.join(here, "derived-rules.json")))
ts = d["derived_at"]
r = d["rules"][0]
logic_str = json.dumps(r["logic"], ensure_ascii=False)

HEADER = f"""-- =====================================================================
-- Huni-Constraint-Rules · wave-3 · PRD_000047 소량전단지
-- CN-3 코팅×종이두께 — "코팅은 180g 이상 종이에서만" (RULE_TYPE.02 금지·안전형)
-- 유도 시점: {ts} · 원천: 라이브 t_prd_product_options/option_items(읽기전용)
-- 생성: gen_sql.py (derived-rules.json verbatim) · 임계 {d['threshold_g']}g · 차단 종이 {len(r['thin_matkeys'])}종
-- search-before-mint: 047 기존 제약 0건(논리삭제 대상 없음) · 순수 신규 mint 1건
-- =====================================================================
"""

INSERT = f"""INSERT INTO t_prd_product_constraints
  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)
VALUES
  ('{r['prd_cd']}', '{r['rule_cd']}', '{r['rule_nm']}', '{r['rule_typ_cd']}',
   '{logic_str}'::jsonb,
   '{r['err_msg']}', {r['disp_seq']}, 'Y', 'N')
ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET
  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,
  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,
  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();
"""

VERIFY = f"""-- 검증: 047 활성 제약(신규 1건) 확인
SELECT prd_cd, rule_cd, rule_typ_cd, use_yn, del_yn, disp_seq,
       jsonb_typeof(logic) AS logic_type
  FROM t_prd_product_constraints
 WHERE prd_cd = '{r['prd_cd']}'
 ORDER BY del_yn, disp_seq;
"""

# apply-dryrun.sql — BEGIN…ROLLBACK (검증 전용)
with open(os.path.join(here, "apply-dryrun.sql"), "w") as f:
    f.write(HEADER + "\nBEGIN;\n\n" + INSERT + "\n" + VERIFY + "\nROLLBACK;  -- DRY-RUN: 실제 반영 안 함\n")

# apply-fix.sql — COMMIT 종결자 (인간 승인 후 registrar 만 실행)
with open(os.path.join(here, "apply-fix.sql"), "w") as f:
    f.write(HEADER + "-- ★ COMMIT 종결자. 인간 승인 후 registrar 만 실행. 여기서 검증 실행 금지.\n"
            + "\nBEGIN;\n\n" + INSERT + "\nCOMMIT;\n")

# undo.sql — 대칭 복원(신규 규칙 논리삭제)
with open(os.path.join(here, "undo.sql"), "w") as f:
    f.write(HEADER + "-- UNDO: 신규 규칙 논리삭제(대칭 복원). 047 은 이전 제약 없었음.\n"
            + "\nBEGIN;\n\n"
            + f"UPDATE t_prd_product_constraints\n"
              f"   SET use_yn='N', del_yn='Y', upd_dt=now()\n"
              f" WHERE prd_cd='{r['prd_cd']}' AND rule_cd='{r['rule_cd']}';\n"
            + "\nCOMMIT;\n")

print("SQL 생성 완료: apply-dryrun.sql · apply-fix.sql · undo.sql")
print(f"  규칙: {r['prd_cd']} {r['rule_cd']} ({r['rule_typ_cd']})  차단종이 {len(r['thin_matkeys'])}종")
