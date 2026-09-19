#!/usr/bin/env python3
# t57 후속 — L1 이음매 10개의 담당을 t56 rejudge.csv 에서 읽는다(읽기전용).
# 이음매마다 원장 evidence 가 가리키는 plan_row_id 집합을 넣고, t56 판정을 모은다.
import csv, collections, json, os, sys

T56 = ("/Users/innojini/Dev/HuniWeb/.claude/worktrees/t56/_workspace/"
       "huni-launch-runway/08_system-screen/t56/rejudge.csv")
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MERGED = os.path.join(BASE, "t51", "merged.csv")

rej = {r["row_id"]: r for r in csv.DictReader(open(T56, encoding="utf-8"))}
rows = list(csv.DictReader(open(MERGED, encoding="utf-8")))

# 이음매 ↔ 원장 행 선택자 (system, counterpart) 무순 쌍 또는 screen_id 접두
SEAMS = {
    "① 위젯→쇼핑몰(handoff)":      {"pairs": [("widget", "huni-mall"), ("huni-mall", "widget")]},
    "② 쇼핑몰→샵바이":              {"pairs": [("huni-mall", "shopby")]},
    "③ 샵바이→webadmin 주문등록":   {"pairs": [("shopby", "webadmin")]},
    "④ 샵바이 웹훅→webadmin":       {"screen": ["SB-WEBHOOK"]},
    "⑤ 원고 승격(S3)":              {"pairs": [("s3", "webadmin")]},
    "⑥ 원고→PitStop":               {"pairs": [("pitstop", "pitstop")]},
    "⑦ 샵바이→MES":                 {"pairs": [("mes", "shopby")]},
    "⑧ PitStop→MES":                {"pairs": [("mes", "pitstop")]},
    "⑨ Edicus 렌더→MES":            {"pairs": [("edicus", "mes")]},
    "⑩ MES→샵바이 상태·송장":       {"plans": ["STD-MFG-027", "STD-MFG-029", "STD-MFG-114",
                                              "STD-MFG-123", "STD-SHP-012", "STD-SHP-013"]},
}

WEAK = {"rule-step", "rule-track"}   # 리드 지적 ①: 약한 근거


def pick(spec):
    out = []
    for x in rows:
        if x["work_type"] != "integrate" and "screen" not in spec:
            continue
        if "pairs" in spec:
            k = {x["system"], x["counterpart"]}
            if any(k == set(p) for p in spec["pairs"]):
                out.append(x)
        if "screen" in spec and x["screen_id"] in spec["screen"]:
            out.append(x)
        if "plans" in spec and x["plan_row_id"] in spec["plans"]:
            out.append(x)
    return out


report = {}
for name, spec in SEAMS.items():
    sel = pick(spec)
    plans = [x["plan_row_id"] for x in sel if x["plan_row_id"] not in ("", "NEW")]
    owners, weak, unknown = collections.Counter(), collections.Counter(), 0
    for p in plans:
        r = rej.get(p)
        if not r:
            unknown += 1
            continue
        o = (r.get("owner_proposed") or r.get("owner_now") or "").strip() or "(공란)"
        owners[o] += 1
        if (r.get("judged_by") or "").strip() in WEAK:
            weak[o] += 1
    report[name] = {
        "원장행": len(sel), "plan_row_id 있는 행": len(plans),
        "t56 미수록": unknown,
        "담당 분포": dict(owners.most_common()),
        "약한 근거(rule-step/track)": dict(weak.most_common()),
    }
    top = owners.most_common(1)
    head = f"{top[0][0]} {top[0][1]}/{len(plans)}" if top else "판정 근거 없음"
    w = sum(weak.values())
    print(f"{name:28s} 행{len(sel):4d} · 담당 {head}"
          + (f" · 약한근거 {w}" if w else "")
          + (f" · t56미수록 {unknown}" if unknown else ""))
    if len(owners) > 1:
        print(f"{'':28s}   분포 {dict(owners.most_common())}")

json.dump(report, open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "owners.json"),
                       "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(f"\nt56 원장 {len(rej)}행 · 판정 분포 "
      f"{dict(collections.Counter(r['verdict'] for r in rej.values()).most_common())}")
