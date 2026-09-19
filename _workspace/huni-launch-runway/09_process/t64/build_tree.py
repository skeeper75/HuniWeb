#!/usr/bin/env python3
"""t64 — process-tree.csv 생성.

입력: t56/rejudge.csv(원장 735행) + 07_rebaseline/L1/standard-feature-canon.csv + assign.py
출력: process-tree.csv (L0→L1→L2→L3→L4)
게이트: 담당 범위 행 중 미귀속 0.
"""
import csv, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
RUNWAY = os.path.abspath(os.path.join(HERE, "..", ".."))
LEDGER = os.path.join(RUNWAY, "08_system-screen", "t56", "rejudge.csv")
CANON = os.path.join(RUNWAY, "07_rebaseline", "L1", "standard-feature-canon.csv")

sys.path.insert(0, HERE)
from assign import PROCESSES, ASSIGN, CROSS_STEPS  # noqa: E402

L0 = "후니 몰 전체(huni-mall 독립몰 + 샵바이 + webadmin/위젯 + MES + Edicus + PitStop)"


def in_scope(r):
    """t64 담당 범위 판정 — 이 함수가 분모의 단일 정의."""
    rid = r["row_id"]
    if rid.startswith("STD-MFG-"):
        return True
    if rid.startswith("STD-ADO-"):
        return True
    if rid.startswith("STD-ART-") and r["step"] in ("C4", "C5"):
        return True
    if rid in ("T4-2", "T4-3", "T4-4", "T4-5", "BLK-S2-2", "BLK-S2-3", "BLK-S2-4"):
        return True
    return False


def main():
    ledger = list(csv.DictReader(open(LEDGER, encoding="utf-8")))
    by_id = {r["row_id"]: r for r in ledger}
    canon = {r["std_id"]: r for r in csv.DictReader(open(CANON, encoding="utf-8"))}
    pmeta = {p[0]: p for p in PROCESSES}

    scope = [r for r in ledger if in_scope(r)]
    scope_ids = {r["row_id"] for r in scope}

    out = []
    for rid in sorted(scope_ids):
        r = by_id[rid]
        procs = ASSIGN.get(rid, [])
        c = canon.get(rid)
        for pid in procs:
            _, pname, l1, l2, _, pcross = pmeta[pid]
            out.append({
                "L0": L0,
                "L1_대분류": c["대분류"] if c else l1,
                "L2_중분류": c["중분류"] if c else l2,
                "L3_프로세스": f"{pid}-{pname}",
                "L4_단계_row_id": rid,
                "기능": r["title"],
                "status": r["status"],
                "owner_proposed": r["owner_proposed"] or r["owner_now"],
                "step": r["step"],
                "track": r["track"],
                "원장출처": "canon+ledger" if c else "ledger전용",
                "cross": pcross,
                "귀속": "담당",
            })

    # cross 단계(담당 범위 밖 · 분모 아님)
    for rid, (pid, card) in sorted(CROSS_STEPS.items()):
        r = by_id.get(rid)
        c = canon.get(rid)
        _, pname, l1, l2, _, _ = pmeta[pid]
        out.append({
            "L0": L0,
            "L1_대분류": (c or {}).get("대분류") or (r or {}).get("track") or l1,
            "L2_중분류": (c or {}).get("중분류") or l2,
            "L3_프로세스": f"{pid}-{pname}",
            "L4_단계_row_id": rid,
            "기능": (r or {}).get("title", "(원장 밖 · 상대 카드 행)"),
            "status": (r or {}).get("status", ""),
            "owner_proposed": (r or {}).get("owner_proposed") or (r or {}).get("owner_now", ""),
            "step": (r or {}).get("step", ""),
            "track": (r or {}).get("track", ""),
            "원장출처": "canon+ledger" if c else ("ledger전용" if r else "원장밖"),
            "cross": card,
            "귀속": "cross",
        })

    cols = ["L0", "L1_대분류", "L2_중분류", "L3_프로세스", "L4_단계_row_id", "기능",
            "status", "owner_proposed", "step", "track", "원장출처", "cross", "귀속"]
    with open(os.path.join(HERE, "process-tree.csv"), "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=cols, lineterminator="\n")
        w.writeheader()
        w.writerows(out)

    unassigned = sorted(scope_ids - set(ASSIGN))
    print(f"담당 범위 행 = {len(scope_ids)}")
    print(f"process-tree.csv 행 = {len(out)} (담당 {sum(1 for o in out if o['귀속']=='담당')} · cross {sum(1 for o in out if o['귀속']=='cross')})")
    print(f"프로세스 = {len(PROCESSES)}")
    print(f"미귀속 = {len(unassigned)}  {unassigned}")
    stale = sorted(set(ASSIGN) - scope_ids)
    if stale:
        print(f"⚠ 범위 밖인데 ASSIGN 에 있는 행 = {stale}")
    return 0 if not unassigned and not stale else 1


if __name__ == "__main__":
    sys.exit(main())
