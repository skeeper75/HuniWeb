#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""derived-rules.json → apply-dryrun.sql / apply-fix.sql / undo.sql 생성.

logic JSON 을 verbatim 으로 실어 전사 오류를 없앤다. 멱등 UPSERT.
apply-fix.sql 은 COMMIT 종결자(검증 실행 금지) · apply-dryrun.sql 은 BEGIN...ROLLBACK.
"""
import json
import os

here = os.path.dirname(os.path.abspath(__file__))
data = json.load(open(os.path.join(here, "derived-rules.json")))
rules = data["rules"]
ts = data["derived_at"]
PRDS = "('PRD_000129','PRD_000130')"


def sqlstr(s):
    return "'" + s.replace("'", "''") + "'"


def insert_block():
    lines = []
    for r in rules:
        logic = json.dumps(r["logic"], ensure_ascii=False)
        lines.append(
            "INSERT INTO t_prd_product_constraints\n"
            "  (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn)\n"
            "VALUES\n"
            f"  ({sqlstr(r['prd_cd'])}, {sqlstr(r['rule_cd'])}, {sqlstr(r['rule_nm'])}, "
            f"{sqlstr(r['rule_typ_cd'])},\n"
            f"   {sqlstr(logic)}::jsonb,\n"
            f"   {sqlstr(r['err_msg'])}, {r['disp_seq']}, 'Y', 'N')\n"
            "ON CONFLICT (prd_cd, rule_cd) DO UPDATE SET\n"
            "  rule_nm = EXCLUDED.rule_nm, rule_typ_cd = EXCLUDED.rule_typ_cd,\n"
            "  logic = EXCLUDED.logic, err_msg = EXCLUDED.err_msg,\n"
            "  disp_seq = EXCLUDED.disp_seq, use_yn = 'Y', del_yn = 'N', upd_dt = now();"
        )
    return "\n\n".join(lines)


RETIRE_OLD = (
    "-- 기존 데모 규칙 논리삭제(search-before-mint): 구 R_DEMO_MATSIZ 는 1규칙 AND-of-OR 구조로\n"
    "-- 폼빌더 역파싱 불가 → 자재별 8규칙으로 분할 대체. 물리삭제 아님(del_yn='Y').\n"
    "UPDATE t_prd_product_constraints\n"
    "   SET use_yn = 'N', del_yn = 'Y', upd_dt = now()\n"
    f" WHERE prd_cd IN {PRDS} AND rule_cd = 'R_DEMO_MATSIZ';"
)

HEADER = (
    "-- =====================================================================\n"
    "-- Huni-Constraint-Rules · wave-1 파일럿 · 129 폼보드 / 130 포맥스보드\n"
    "-- CN-2 자재↔사이즈 엇갈림 제약 (RULE_TYPE.03 필수동반)\n"
    f"-- 유도 시점: {ts} · 원천: 라이브 t_prc_component_prices(읽기전용)\n"
    "-- 생성: gen_sql.py (derived-rules.json verbatim) · 멱등 UPSERT\n"
    "-- =====================================================================\n"
)

# apply-dryrun.sql — BEGIN...ROLLBACK (검증 전용)
dryrun = [HEADER, "BEGIN;", "", RETIRE_OLD, "", insert_block(), "",
          "-- 검증: 활성 제약 8건(129·130 각 4) + 구 데모 비활성 확인",
          "SELECT prd_cd, rule_cd, rule_typ_cd, use_yn, del_yn, disp_seq",
          f"  FROM t_prd_product_constraints WHERE prd_cd IN {PRDS}",
          "  ORDER BY prd_cd, del_yn, disp_seq;", "",
          "ROLLBACK;  -- DRY-RUN: 실제 반영 안 함", ""]

# apply-fix.sql — COMMIT 종결자 (registrar 만 인간 승인 후 실행 · 여기서 실행 금지)
fix = [HEADER, "-- ★ 이 파일은 COMMIT 종결자입니다. 검증 실행 금지 — 승인 후 registrar 만 실행.",
       "BEGIN;", "", RETIRE_OLD, "", insert_block(), "", "COMMIT;", ""]

# undo.sql — 대칭 복원 (8규칙 논리삭제 + 구 데모 복원)
undo = [HEADER, "-- 대칭 복원: 신규 8규칙 논리삭제 + 구 R_DEMO_MATSIZ 재활성",
        "BEGIN;", ""]
for r in rules:
    undo.append(
        "UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()\n"
        f" WHERE prd_cd={sqlstr(r['prd_cd'])} AND rule_cd={sqlstr(r['rule_cd'])};"
    )
undo += ["",
         "UPDATE t_prd_product_constraints SET use_yn='Y', del_yn='N', upd_dt=now()\n"
         f" WHERE prd_cd IN {PRDS} AND rule_cd='R_DEMO_MATSIZ';",
         "", "COMMIT;", ""]

for name, body in [("apply-dryrun.sql", dryrun), ("apply-fix.sql", fix), ("undo.sql", undo)]:
    with open(os.path.join(here, name), "w") as f:
        f.write("\n".join(body))
    print(f"wrote {name}")
