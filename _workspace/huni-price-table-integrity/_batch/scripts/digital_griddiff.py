#!/usr/bin/env python3
"""
digital_griddiff — 「디지털인쇄비」 시트 권위 격자 ↔ 라이브 스냅샷 **셀 단위** grid-diff.

§26 무결성: §29 준비도(차원 매칭 present/missing 스크리닝)를 넘어, 어느 1도/4도/별색
셀이 빠졌는지/값이 틀렸는지를 셀 좌표 단위로 확정한다. 결정론(같은 입력 → 같은 결과).

권위 가격축(차원): 판형(국4절/3절) × 도수(흑백1도/칼라CMYK/별색5색) × 면(단면/양면) × 수량구간.
라이브 구성요소:
  COMP_PRINT_DIGITAL_S1 (활성) — 흑백/칼라, 면+도수가 print_opt_cd 로 인코딩
     POPT_000001 칼라단면 · POPT_000002 칼라양면 · POPT_000008 흑백단면(단면1도) · POPT_000009 흑백양면(양면1도)
     → 면은 note(단면/양면) 가 1차 권위(코드맵만으론 흑백 누락=가짜신호).
  COMP_PRINT_SPOT_WHITE_S1 (활성) — 별색 5색 통합 comp, 색상=proc_cd
     PROC_000008 화이트 · 009 클리어 · 010 핑크 · 011 금색 · 012 은색
  ※ del_yn=Y comp(DIGITAL_S2·SPOT_*_S2·기타 색상 S1) = 신규 통합 comp 로 대체된 폐기분.
    어떤 상품 공식도 바인딩 안 함(FC=DIGITAL_S1·SPOT_WHITE_S1 만) → 비활성 제외가 맞음.

검출: missing_cell(권위에 있고 라이브에 없음)·mismatch(값 다름)·extra(라이브에만)·
      dim_missing(도수축 통째 부재). 정상빈칸(권위에도 없는 셀)은 격자 생성 단계에서 배제.
"""
import csv
import os
import sys
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from matrix_parse import parse_l1, read_csv  # noqa: E402

GRADE = {"SIZ_000499": "국4절", "SIZ_000077": "3절"}
SPOT = {
    "PROC_000008": "별색-화이트", "PROC_000009": "별색-클리어",
    "PROC_000010": "별색-핑크", "PROC_000011": "별색-금색",
    "PROC_000012": "별색-은색",
}


def _clr_from_note(n):
    if "흑백" in n:
        return "흑백"
    if "칼라" in n:
        return "칼라"
    return None


def _side_from_note(n):
    if "양면" in n:
        return "양면"
    if "단면" in n:
        return "단면"
    return None


def build_live(snap_dir):
    """라이브 스냅샷 → 정규 셀 dict {(grade,clr,side,qty): {price,comp,id,popt,proc}}.

    활성(del_yn=N) COMP_PRINT comp 만. 도수=note(흑백/칼라) 또는 proc_cd(별색),
    면=note 1차. 같은 키 중복 시 comp_price_id 작은 것 유지(결정론).
    """
    cp = read_csv(os.path.join(snap_dir, "t_prc_component_prices.csv"))
    comps = read_csv(os.path.join(snap_dir, "t_prc_price_components.csv"))
    active = {c["comp_cd"] for c in comps
              if c["comp_cd"].startswith("COMP_PRINT") and c["del_yn"] == "N"}
    live = {}
    for r in cp:
        comp = r["comp_cd"]
        if not comp.startswith("COMP_PRINT") or comp not in active:
            continue
        grade = GRADE.get(r["plt_siz_cd"])
        side = _side_from_note(r["note"])
        if comp.startswith("COMP_PRINT_SPOT"):
            clr = SPOT.get(r["proc_cd"])
        else:
            clr = _clr_from_note(r["note"])
        if not (grade and side and clr):
            continue
        try:
            qty = int(r["min_qty"])
            price = int(float(r["unit_price"]))
        except (ValueError, TypeError):
            continue
        key = (grade, clr, side, qty)
        if key not in live or int(r["comp_price_id"]) < int(live[key]["id"]):
            live[key] = {"price": price, "comp": comp, "id": r["comp_price_id"],
                         "popt": r["print_opt_cd"], "proc": r["proc_cd"]}
    return live


def run(l1_csv, snap_dir, out_cells, out_defects):
    auth = parse_l1(l1_csv, "digital-print")
    authkeys = {(c["plt_grade"], c["clr"], c["side"], c["min_qty"]): c for c in auth}
    live = build_live(snap_dir)

    # 도수 그룹핑 라벨(1도/4도/별색) — 사용자 관심축
    def deunggeup(clr):
        if clr == "흑백":
            return "흑백(1도)"
        if clr == "칼라":
            return "칼라(4도)"
        return "별색"

    rows = []           # 전 셀 verdict(투명성)
    defects = []        # 결함 셀만
    all_keys = sorted(set(authkeys) | set(live))
    for k in all_keys:
        grade, clr, side, qty = k
        a = authkeys.get(k)
        lv = live.get(k)
        av = a["unit_price"] if a else ""
        lp = lv["price"] if lv else ""
        comp = lv["comp"] if lv else ""
        if a and lv:
            verdict = "match" if av == lp else "mismatch"
        elif a and not lv:
            verdict = "missing_cell"
        else:
            verdict = "extra_live"
        row = {"verdict": verdict, "deunggeup": deunggeup(clr), "clr": clr,
               "plt_grade": grade, "side": side, "min_qty": qty,
               "auth_value": av, "live_value": lp, "comp_cd": comp,
               "src_ref": a["src_ref"] if a else "", "comp_price_id": lv["id"] if lv else ""}
        rows.append(row)
        if verdict != "match":
            defects.append(row)

    fields = ["verdict", "deunggeup", "clr", "plt_grade", "side", "min_qty",
              "auth_value", "live_value", "comp_cd", "src_ref", "comp_price_id"]
    with open(out_cells, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)
    with open(out_defects, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(defects)

    # 집계
    stats = {
        "auth_cells": len(authkeys),
        "live_cells": len(live),
        "defect_cells": len(defects),
        "by_verdict": dict(Counter(r["verdict"] for r in rows)),
        "by_deunggeup_total": dict(Counter(deunggeup(k[1]) for k in authkeys)),
        "by_deunggeup_defect": dict(Counter(r["deunggeup"] for r in defects)),
        "live_clrs": sorted({k[1] for k in live}),
        "live_grades": sorted({k[0] for k in live}),
    }
    # 도수×판형×면 커버리지(present/total)
    cov = defaultdict(lambda: [0, 0])  # (deunggeup,grade,side) -> [present, total]
    for k in authkeys:
        kk = (deunggeup(k[1]), k[0], k[2])
        cov[kk][1] += 1
        if k in live:
            cov[kk][0] += 1
    stats["coverage"] = {f"{a}/{b}/{c}": v for (a, b, c), v in sorted(cov.items())}
    return stats


if __name__ == "__main__":
    l1 = os.path.abspath(os.path.join(
        HERE, "..", "..", "..", "huni-dbmap", "06_extract",
        "price-digital-print-price-l1.csv"))
    snap = os.path.abspath(os.path.join(
        HERE, "..", "..", "..", "_foundation", "live-snapshot", "latest"))
    out_cells = os.path.join(HERE, "..", "digital-print-griddiff.csv")
    out_def = os.path.join(HERE, "..", "digital-print-griddiff-defects.csv")
    st = run(l1, snap, out_cells, out_def)
    import json
    print(json.dumps(st, ensure_ascii=False, indent=2))
