#!/usr/bin/env python3
"""t51 검증기 — 산출물이 원천과 계약을 지켰는지 독립적으로 재계산한다.

조립기(assemble.py)의 결과를 믿지 않는다. 세 레인 screens.csv 와 9/17 원장을
다시 읽어 스스로 세고, 산출물(merged.csv · stats.json · schedule.json · HTML · xlsx)과 대조한다.

게이트 V1~V9. 하나라도 FAIL 이면 종료코드 1.
실행: python3 verify.py
"""
import csv
import json
import re
import sys
import collections
from pathlib import Path

HERE = Path(__file__).resolve().parent
BASE = HERE.parent
RUNWAY = BASE.parent
PLAN = RUNWAY / "07_rebaseline" / "S" / "S5-plan" / "plan-rows.csv"
OUT_PREFIX = "[오픈분모밖] "
CARDS = ("t48", "t49", "t50")

SYSTEMS = {"shopby", "edicus", "mes", "huni-mall", "webadmin", "widget", "pagebuilder", "pitstop"}
WORK_TYPES = {"build", "integrate", "config", "provided", "manual"}
STATUSES = {"완료", "진행", "미착수", "미확인"}
ROLES = {"고객", "운영자(CS·상품)", "생산(MES)", "관리자", "시스템(무인)"}

results = []


def gate(gid, name, ok, detail):
    results.append((gid, name, "PASS" if ok else "FAIL", detail))
    print(f"[{'PASS' if ok else 'FAIL'}] {gid} {name} — {detail}")
    return ok


def main():
    # ── 원천을 다시 읽는다 ────────────────────────────────────────────────
    src = []
    for card in CARDS:
        with (BASE / card / "screens.csv").open(encoding="utf-8") as f:
            for i, r in enumerate(csv.DictReader(f), start=2):
                r["_uid"] = f"{card}:{i}"
                r["_card"] = card
                src.append(r)
    merged = list(csv.DictReader((HERE / "merged.csv").open(encoding="utf-8")))
    stats = json.loads((HERE / "stats.json").read_text(encoding="utf-8"))
    sch = json.loads((HERE / "schedule.json").read_text(encoding="utf-8"))

    # V1 — 행 보존: 합친 행은 사라지지 않고 merged_from 으로 남아 있어야 한다
    folded = sum(len([x for x in r["merged_from"].split(";") if x]) for r in merged)
    v1 = (len(merged) + folded == len(src)) and len(src) == stats["raw_total"]
    gate("V1", "행 보존", v1,
         f"원천 {len(src)} = 통합 {len(merged)} + 병합흡수 {folded} "
         f"(stats.raw_total={stats['raw_total']})")

    # V2 — 허용값
    bad = collections.Counter()
    for r in merged:
        if r["system"] not in SYSTEMS:
            bad["system"] += 1
        if r["work_type"] not in WORK_TYPES:
            bad["work_type"] += 1
        if r["status"] not in STATUSES:
            bad["status"] += 1
        if r["role"] not in ROLES:
            bad["role"] += 1
        if not r["evidence"].strip():
            bad["evidence_empty"] += 1
    gate("V2", "허용값·근거 필수", not bad,
         "위반 0" if not bad else f"위반 {dict(bad)}")

    # V3 — scope 파생을 스스로 다시 계산
    my_out = sum(1 for r in src if (r.get("evidence") or "").startswith(OUT_PREFIX))
    their_out = stats["by_scope"].get("out", 0)
    mism = sum(1 for r in merged
               if (r["scope"] == "out") != r["evidence"].startswith(OUT_PREFIX))
    gate("V3", "scope 파생", mism == 0 and my_out >= their_out,
         f"접두 보유 원천 {my_out}행 · 통합 out {their_out}행 · 파생 불일치 {mism}")

    # V4 — integrate 필수열 (owner_side 미정은 결함이 아니라 미결로 따로 센다)
    miss_cp = [r["row_uid"] for r in merged
               if r["work_type"] == "integrate" and not r["counterpart"].strip()]
    miss_dir = [r["row_uid"] for r in merged
                if r["work_type"] == "integrate" and not r["direction"].strip()]
    undec = sum(1 for r in merged if r["scope"] == "in" and r["work_type"] == "integrate"
                and r["owner_side"] in ("", "미정"))
    gate("V4", "integrate 필수열", not miss_cp and not miss_dir,
         f"counterpart 누락 {len(miss_cp)} · direction 누락 {len(miss_dir)} "
         f"· owner_side 미정 {undec}건(결함 아님 · 미결로 보고)")
    if undec != stats["integrate_owner_side_undecided"]:
        gate("V4b", "owner_side 미정 집계 일치", False,
             f"검증기 {undec} ≠ stats {stats['integrate_owner_side_undecided']}")
    else:
        gate("V4b", "owner_side 미정 집계 일치", True, f"양쪽 {undec}건")

    # V5 — 병합 무손실: merged_from 이 가리키는 uid 가 원천에 실재하고, 상대 시스템이 보존됐나
    uids = {r["_uid"] for r in src}
    by_uid = {r["_uid"]: r for r in src}
    lost, sysdrop = [], []
    for r in merged:
        for u in [x for x in r["merged_from"].split(";") if x]:
            if u not in uids:
                lost.append(u)
                continue
            o = by_uid[u]
            # 흡수된 행의 system 이 남은 행의 system 또는 counterpart 로 살아 있어야 한다
            if o["system"] not in (r["system"], r["counterpart"]):
                sysdrop.append((u, o["system"], r["system"], r["counterpart"]))
    gate("V5", "병합 무손실(양쪽 드릴다운 보존)", not lost and not sysdrop,
         f"유령 uid {len(lost)} · 상대 시스템 소실 {len(sysdrop)}")

    # V6 — 일정: 원장에 없는 값이 섞이지 않았나 (날짜 추정 0)
    plan = {r["row_id"]: r for r in csv.DictReader(PLAN.open(encoding="utf-8"))}
    drift = []
    for s in sch["spine"]:
        p = plan.get(s["row_id"])
        if not p:
            drift.append((s["row_id"], "원장에 없음"))
            continue
        if (s["effort_lb_days"] or "") != p["effort_lb_days"].strip():
            drift.append((s["row_id"], "하한 불일치"))
        if s["target_date"] != p["target_date"].strip():
            drift.append((s["row_id"], "날짜 불일치"))
        if s["title"] != p["title"].strip():
            drift.append((s["row_id"], "제목 불일치"))
    gate("V6", "일정 = 원장 복사(추정 0)", not drift,
         f"척추 {len(sch['spine'])}행 · 원장과 어긋난 값 {len(drift)}" +
         (f" {drift[:5]}" if drift else ""))

    # V7 — 미수록을 스스로 다시 판정
    ids = collections.defaultdict(set)
    for r in src:
        for pid in re.split(r"[;,\s]+", r.get("plan_row_id") or ""):
            if pid and pid != "NEW":
                ids[pid].add(r["_card"])
    my_miss = []
    with (BASE / "t48" / "out-of-scope.csv").open(encoding="utf-8") as f:
        oos = list(csv.DictReader(f))
        for r in oos:
            if not (ids.get(r["plan_row_id"].strip(), set()) - {"t48"}):
                my_miss.append(r["plan_row_id"].strip())
    their = stats["out_of_scope_crosscheck"]
    v7 = (len(my_miss) == their["miss_count"] and len(oos) == their["total"]
          and sorted(my_miss) == sorted(m["plan_row_id"] for m in their["miss"]))
    gate("V7", "미수록 독립 재판정", v7,
         f"라우팅 {len(oos)} · 검증기 미수록 {len(my_miss)} · 보고 {their['miss_count']}")

    # V8 — 산출물 실재 + 핵심 수치가 문서에 그대로 실렸나
    html_p = HERE / "reports" / "launch-schedule-20260919.html"
    md_p = HERE / "reports" / "launch-schedule-20260919.md"
    xlsx_p = HERE / "reports" / "launch-screens-20260919.xlsx"
    exist = [p.name for p in (html_p, md_p, xlsx_p) if not p.exists()]
    htxt = html_p.read_text(encoding="utf-8") if html_p.exists() else ""
    must = [str(stats["merged_total"]), str(stats["by_scope"]["in"]),
            str(stats["by_scope"]["out"]), str(stats["in_remaining"]),
            str(stats["decisions_total"]), str(their["miss_count"]),
            str(sch["spine_effort_lb_sum"])]
    absent = [m for m in must if m not in htxt]
    gate("V8", "산출물·핵심 수치 실재", not exist and not absent,
         f"누락 파일 {exist or '없음'} · 문서에 없는 수치 {absent or '없음'} "
         f"· HTML {len(htxt.encode()):,}B")

    # V9 — 승계 의무 주석이 문서에 실렸나 (리드 인계 §3)
    duties = {
        "완료의 뜻": "코드(또는 매뉴얼 원고)에서 그 기능이 실제로 있는 것을 확인했다",
        "라이브 확인 0": "라이브 화면에서 실제로 눌러",
        "MES 메뉴 한계": "MenuInfo",
        "분모밖 레인 제안": "레인이 낸 제안",
        "unmeasured 후보": "STD-MFG-060",
        "CRT 타 고객": "열림PnP",
    }
    absent_d = [k for k, v in duties.items() if v not in htxt]
    gate("V9", "승계 의무 주석", not absent_d,
         f"실린 주석 {len(duties)-len(absent_d)}/{len(duties)}" +
         (f" · 빠짐 {absent_d}" if absent_d else ""))

    # V10 — verdict.md 의 손으로 쓴 표가 계산값과 같은가 (사람 전사 오류 차단)
    vp = HERE / "verdict.md"
    vtxt = vp.read_text(encoding="utf-8") if vp.exists() else ""
    wrong = []
    for w in ["build", "integrate", "config", "provided", "manual"]:
        want = f"| {w} | {stats['in_by_work_type'][w]} | {stats['in_remaining_by_work_type'][w]} |"
        if want not in vtxt:
            wrong.append(want)
    for s in sorted(SYSTEMS):
        rin = [r for r in merged if r["system"] == s and r["scope"] == "in"]
        want = (f"| {s} | {len(rin)} | {sum(1 for r in rin if r['status']=='완료')} | "
                f"{sum(1 for r in rin if r['status']!='완료')} | "
                f"{sum(1 for r in rin if r['status']=='미확인')} | "
                f"{sum(1 for r in merged if r['system']==s and r['scope']=='out')} |")
        if want not in vtxt:
            wrong.append(want)
    gate("V10", "verdict 표 = 계산값", vp.exists() and not wrong,
         "일치" if vp.exists() and not wrong
         else ("verdict.md 없음" if not vp.exists() else f"어긋난 행 {len(wrong)}: {wrong[:3]}"))

    fails = [r for r in results if r[2] == "FAIL"]
    print()
    print(f"게이트 {len(results)}종 · PASS {len(results)-len(fails)} · FAIL {len(fails)}")
    (HERE / "verify-result.json").write_text(json.dumps(
        [{"gate": g, "name": nm, "verdict": v, "detail": d} for g, nm, v, d in results],
        ensure_ascii=False, indent=2), encoding="utf-8")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
