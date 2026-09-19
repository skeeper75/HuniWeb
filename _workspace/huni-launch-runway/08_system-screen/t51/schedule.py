#!/usr/bin/env python3
"""t51 일정·의존 추출기 — 9/17 원장(plan-rows.csv 735행)에서만 읽는다.

날짜를 추정하지 않는다. 원장에 적힌 것만 옮긴다:
  - 원장 하한 = data_role=top 행의 effort_lb_days (28행에만 있다)
  - 선행 = prereq 열 ('—' 는 선행 없음)
  - 순서 = track(T1~T7) · step
통합 원장(merged.csv)의 plan_row_id 를 원장 행에 이어 붙여 step 별 화면·기능 행수를 센다.

실행: python3 schedule.py  (assemble.py 를 먼저 실행해 merged.csv 가 있어야 한다)
"""
import csv
import json
import re
import collections
from pathlib import Path

HERE = Path(__file__).resolve().parent
RUNWAY = HERE.parent.parent
PLAN = RUNWAY / "07_rebaseline" / "S" / "S5-plan" / "plan-rows.csv"


def main():
    plan = list(csv.DictReader(PLAN.open(encoding="utf-8")))
    by_id = {r["row_id"]: r for r in plan}

    merged = list(csv.DictReader((HERE / "merged.csv").open(encoding="utf-8")))

    # 통합 원장 행 → 원장 행(track/step) 연결
    step_rows = collections.defaultdict(lambda: {"total": 0, "remaining": 0})
    linked, unlinked_new, unlinked_missing = 0, 0, []
    for r in merged:
        if r["scope"] != "in":
            continue
        pid = r["plan_row_id"].strip()
        if pid == "NEW" or not pid:
            unlinked_new += 1
            continue
        p = by_id.get(pid)
        if not p:
            unlinked_missing.append(pid)
            continue
        linked += 1
        key = (p["track"], p["step"])
        step_rows[key]["total"] += 1
        if r["status"] != "완료":
            step_rows[key]["remaining"] += 1

    # 일정 척추 = data_role=top 행 (원장 하한을 가진 유일한 행들)
    spine = []
    for r in plan:
        if r.get("data_role") != "top":
            continue
        key = (r["track"], r["step"])
        lb = r["effort_lb_days"].strip()
        spine.append({
            "row_id": r["row_id"],
            "track": r["track"],
            "step": r["step"],
            "title": r["title"].strip(),
            "owner": r["owner_name"].strip(),
            "effort_lb_days": lb if lb else None,
            "effort_lb_is_numeric": bool(re.fullmatch(r"\d+(\.\d+)?", lb)),
            "prereq": "" if r["prereq"].strip() in ("—", "none", "") else r["prereq"].strip(),
            "target_date": r["target_date"].strip(),
            "status": r["status"].strip(),
            "screen_rows": step_rows.get(key, {}).get("total", 0),
            "screen_rows_remaining": step_rows.get(key, {}).get("remaining", 0),
            "evidence": r["evidence"].strip(),
        })
    spine.sort(key=lambda s: (s["track"], s["row_id"]))

    # 외부 의존 = prereq 의 EXT-* 토큰 (원장 전체에서)
    ext = collections.Counter()
    ext_rows = collections.defaultdict(list)
    for r in plan:
        for tok in re.split(r"[;,\s]+", r["prereq"].strip()):
            if tok.startswith("EXT-"):
                ext[tok] += 1
                ext_rows[tok].append(r["row_id"])
    # 원장 내부 선행 — 여러 행이 기다리는 선행 상위
    internal = collections.Counter()
    for r in plan:
        for tok in re.split(r"[;,\s]+", r["prereq"].strip()):
            if tok and not tok.startswith("EXT-") and tok != "—":
                internal[tok] += 1

    out = {
        "plan_rows": len(plan),
        "spine": spine,
        "spine_effort_lb_sum": round(sum(
            float(s["effort_lb_days"]) for s in spine if s["effort_lb_is_numeric"]), 1),
        "spine_effort_lb_rows": sum(1 for s in spine if s["effort_lb_is_numeric"]),
        "plan_rows_with_effort_lb": sum(1 for r in plan if r["effort_lb_days"].strip()),
        "linked_screen_rows": linked,
        "unlinked_new": unlinked_new,
        "unlinked_missing_ids": sorted(set(unlinked_missing)),
        "unlinked_missing_count": len(unlinked_missing),
        "ext_dependencies": {k: {"waiting_rows": v, "sample": ext_rows[k][:6]}
                             for k, v in ext.most_common()},
        "top_internal_prereqs": dict(internal.most_common(15)),
        "plan_status_counts": dict(collections.Counter(r["status"] for r in plan).most_common()),
        "plan_owner_counts": dict(collections.Counter(r["owner_name"] for r in plan).most_common()),
    }
    (HERE / "schedule.json").write_text(
        json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"원장 {out['plan_rows']}행 · 척추 {len(spine)}행 "
          f"· 하한 보유 {out['spine_effort_lb_rows']}행(합 {out['spine_effort_lb_sum']}일)")
    print(f"통합원장 in 행 중 원장 연결 {linked} · NEW {unlinked_new} "
          f"· 원장에 없는 id {out['unlinked_missing_count']}종")
    print("외부 의존:", json.dumps({k: v["waiting_rows"] for k, v in out["ext_dependencies"].items()},
                                ensure_ascii=False))


if __name__ == "__main__":
    main()
