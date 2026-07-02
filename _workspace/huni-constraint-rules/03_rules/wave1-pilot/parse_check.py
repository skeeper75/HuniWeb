#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""폼빌더 역파싱 자가검사.

raw/webadmin/webadmin/catalog/views.py 의 _parse_logic_to_conditions 를 verbatim 복사해,
설계한 규칙(derived-rules.json)과 기존 규칙(016/058/구 R_DEMO_MATSIZ)이 폼빌더로 다시 열리는지
프로그램으로 대조한다. PARSEABLE=빌더가 역파싱 성공 / RAW-ONLY=고급 JSON 창으로만 열림(규약 위반).
"""
import json
import os

# ── views.py verbatim (52-73, 197, 200-315) ────────────────────────────
VAR_KEY_MAP = {
    "OPT_REF_DIM.01": ("siz_cd", False),
    "OPT_REF_DIM.02": ("plt_siz_cd", False),
    "OPT_REF_DIM.03": ("mat_cd__usage_cd", False),
    "OPT_REF_DIM.04": ("proc_cd", False),
    "OPT_REF_DIM.05": ("bdl_qty", True),
    "OPT_REF_DIM.06": ("opt_id", True),
    "OPT_REF_DIM.07": ("sub_prd_cd", False),
}
OPT_DIM_VAR = {"OPT_GRP": "sel_opt_grps", "OPT": "sel_opts"}
_OPT_VAR_REVERSE = {v: k for k, v in OPT_DIM_VAR.items()}
_REVERSE_VAR_KEY = {v[0]: k for k, v in VAR_KEY_MAP.items()}


def _parse_logic_to_conditions(logic: dict, rule_typ_cd: str):
    try:
        result_dim, result_val = "", ""
        if rule_typ_cd == "RULE_TYPE.02":
            inner = logic.get("!")
            if inner is None:
                return None
            combined = inner
        elif rule_typ_cd in ("RULE_TYPE.01", "RULE_TYPE.03"):
            or_args = logic.get("or")
            if not or_args or len(or_args) != 2:
                return None
            neg_part, res_part = or_args
            combined = neg_part.get("!") if isinstance(neg_part, dict) else None
            if combined is None:
                return None
            eq = res_part.get("===") if isinstance(res_part, dict) else None
            if eq and len(eq) == 2 and isinstance(eq[0], dict) and "var" in eq[0]:
                rk = eq[0]["var"]
                result_dim = _REVERSE_VAR_KEY.get(rk, "")
                result_val = eq[1]
            else:
                inn = res_part.get("in") if isinstance(res_part, dict) else None
                if inn and len(inn) == 2 and isinstance(inn[1], dict) and "var" in inn[1]:
                    result_dim = _OPT_VAR_REVERSE.get(inn[1]["var"], "")
                    result_val = inn[0]
        else:
            return None

        def _is_leaf(node):
            return isinstance(node, dict) and ("===" in node or "in" in node)

        def _clause_to_row(clause):
            eq = clause.get("===")
            if eq and len(eq) == 2 and isinstance(eq[0], dict):
                var_key = eq[0].get("var", "")
                dim_cd = _REVERSE_VAR_KEY.get(var_key, "")
                return {"dim": dim_cd, "val": eq[1]} if dim_cd else None
            inn = clause.get("in")
            if inn and len(inn) == 2 and isinstance(inn[1], dict) and "var" in inn[1]:
                dim_cd = _OPT_VAR_REVERSE.get(inn[1]["var"], "")
                return {"dim": dim_cd, "val": inn[0]} if dim_cd else None
            return None

        def _detect_group_op(node):
            for op in ("and", "or"):
                if op in node:
                    return op
            return "and"

        groups, group_ops = [], []
        if _is_leaf(combined):
            row = _clause_to_row(combined)
            if row:
                groups.append({"op": "and", "rows": [row]})
        elif "and" in combined or "or" in combined:
            top_op = _detect_group_op(combined)
            items = combined[top_op]
            for i, item in enumerate(items):
                if _is_leaf(item):
                    row = _clause_to_row(item)
                    if row:
                        groups.append({"op": "and", "rows": [row]})
                        if i > 0:
                            group_ops.append(top_op)
                elif "and" in item or "or" in item:
                    sub_op = _detect_group_op(item)
                    rows = [_clause_to_row(c) for c in item[sub_op] if _is_leaf(c)]
                    rows = [r for r in rows if r]
                    if rows:
                        groups.append({"op": sub_op, "rows": rows})
                        if i > 0:
                            group_ops.append(top_op)
        if not groups:
            return None
        return {"groups": groups, "groupOps": group_ops,
                "result": {"dim": result_dim,
                           "val": str(result_val) if result_val != "" else ""}}
    except Exception:
        return None


# ── panzi-json-logic 소형 평가기 (===, !==, !, and, or, in) ─────────────
def jl(rule, data):
    if not isinstance(rule, dict):
        return rule
    op, args = next(iter(rule.items()))
    if op == "var":
        key = args if isinstance(args, str) else args[0]
        return data.get(key)
    if op == "and":
        return all(jl(a, data) for a in args)
    if op == "or":
        for a in args:
            if jl(a, data):
                return True
        return False
    if op == "!":
        return not jl(args if not isinstance(args, list) else args[0], data)
    if op == "===":
        return jl(args[0], data) == jl(args[1], data)
    if op == "!==":
        return jl(args[0], data) != jl(args[1], data)
    if op == "in":
        needle = jl(args[0], data)
        hay = jl(args[1], data)
        return needle in hay if hay else False
    raise ValueError(f"unsupported op {op}")


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    derived = json.load(open(os.path.join(here, "derived-rules.json")))

    # 기존 라이브 규칙(실측) — 대조군
    live = [
        ("PRD_000016", "R_DEMO_VIS", "RULE_TYPE.01",
         {"or": [{"!": {"in": ["OPV_000018", {"var": "sel_opts"}]}},
                 {"in": ["OPT-000007", {"var": "sel_opt_grps"}]}]}),
        ("PRD_000016", "R_DEMO_EXC", "RULE_TYPE.02",
         {"!": {"and": [{"in": ["OPT-000005", {"var": "sel_opt_grps"}]},
                        {"in": ["OPT-000006", {"var": "sel_opt_grps"}]}]}}),
        ("PRD_000058", "RULE_001", "RULE_TYPE.03",
         {"!": {"and": [{"===": [{"var": "siz_cd"}, "SIZ_000426"]}]
                       + [{"in": [f"OPV-0000{n}", {"var": "sel_opts"}]} for n in range(66, 74)]}}),
        ("PRD_000129", "R_DEMO_MATSIZ(구·AND-of-OR)", "RULE_TYPE.03",
         {"and": [{"or": [{"!==": [{"var": "mat_cd__usage_cd"}, "MAT_000398__USAGE.07"]},
                          {"===": [{"var": "siz_cd"}, "SIZ_000315"]}]}]}),
    ]

    print("=== 설계 규칙 (wave-1) — 역파싱 + 유도조합 재현 ===")
    ok = 0
    for r in derived["rules"]:
        parsed = _parse_logic_to_conditions(r["logic"], r["rule_typ_cd"])
        p = "PARSEABLE" if parsed else "RAW-ONLY"
        pass_ok = jl(r["logic"], r["pass_case"]) is True
        block_ok = jl(r["logic"], r["block_case"]) is False
        verdict = "OK" if (parsed and pass_ok and block_ok) else "FAIL"
        if verdict == "OK":
            ok += 1
        print(f"  [{verdict}] {r['prd_cd']} {r['rule_cd']}: {p} | 통과재현={pass_ok} 막힘재현={block_ok}")
    print(f"  => {ok}/{len(derived['rules'])} 정상\n")

    print("=== 기존 규칙 점검 (대조) ===")
    for prd, rc, typ, logic in live:
        parsed = _parse_logic_to_conditions(logic, typ)
        print(f"  {prd} {rc} ({typ}): {'PARSEABLE' if parsed else 'RAW-ONLY / 역파싱실패'}")


if __name__ == "__main__":
    main()
