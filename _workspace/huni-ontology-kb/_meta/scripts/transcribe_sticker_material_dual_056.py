#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
연당가 양면(현재값 vs 정답) 전사 — 낱장 자유형 투명스티커(PRD_000056) 소재축.
[HARD] LLM 손전사 금지(§32·SKILL §2). 이 스크립트가 두 원천에서 결정론 전사한다:
  ① 라이브 현재값 = live-snapshot/latest t_mat_materials (투명스티커 계열 MAT_000162/371/372)
  ② 권위 정답 260702 = 26_change-tracking-260702/price-diff-260527-260702.csv (출력소재 IMPORT 델타)

pack-sticker.md §4-A/§4-D 정합. 완제품 retail 격자(COMP_STK_PRINT)는 260702 무변경이라 dual 아님 —
이 스크립트는 소재 원가(연당가/국4절/평량/명) 축만 다룬다.

사용:  python3 transcribe_sticker_material_dual_056.py          # stdout markdown
       python3 transcribe_sticker_material_dual_056.py --json   # cache/transcribed-sticker-mat-dual-056-260703.json
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
DIFF = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
DIFF_ID = "26_change-tracking-260702/price-diff-260527-260702.csv"
STAMP = "2026-07-03"

# 투명스티커 계열(056이 실제 링크=parent MAT_000162, 권위 260702 split=백색후지/투명후지)
FAMILY = ["MAT_000162", "MAT_000371", "MAT_000372"]


def rd(path):
    with open(path, encoding="utf-8") as f:
        return list(csv.DictReader(f))


def build():
    mats = {r["mat_cd"]: r for r in rd(os.path.join(SNAP, "t_mat_materials.csv"))}
    live = []
    for mc in FAMILY:
        r = mats.get(mc, {})
        live.append({
            "mat_cd": mc,
            "mat_nm": r.get("mat_nm", "(부재)"),
            "mat_typ_cd": r.get("mat_typ_cd", ""),
            "upr_mat_cd": r.get("upr_mat_cd", ""),
            "weight": r.get("weight", ""),
            "reg_dt": (r.get("reg_dt", "") or "")[:10],
            "yeondang_stored": "미저장(t_mat_materials 가격컬럼 없음)",
        })

    # 260702 권위 델타: 출력소재(IMPORT) 시트, key 투명스/투명투(신규행)
    diff = rd(DIFF)
    auth = {"백색후지": {}, "투명후지": {}}
    for row in diff:
        if row["sheet"] != "출력소재(IMPORT)":
            continue
        k, col, after = row["key"], row["column"], row["after"]
        if k == "투명스":  # = 투명스티커(백색후지) MAT_000162/MAT_000371
            if col == "종이명":
                auth["백색후지"]["mat_nm"] = after
            elif col == "평량":
                auth["백색후지"]["weight"] = after
            elif col == "연당가":
                auth["백색후지"]["yeondang"] = after
            elif col == "가격 (국4절)":
                auth["백색후지"]["gukjeol"] = after
        elif k == "투명투":  # ADDED row 86 = 투명스티커(투명후지) MAT_000372
            # after 형식: "C=투명스티커(투명후지) | D=50 | ... | H=222000 | I=740 | K=330x480"
            parts = [p.strip() for p in after.split("|")]
            for p in parts:
                if p.startswith("C="):
                    auth["투명후지"]["mat_nm"] = p[2:].strip()
                elif p.startswith("D="):
                    auth["투명후지"]["weight"] = p[2:].strip()
                elif p.startswith("H="):
                    auth["투명후지"]["yeondang"] = p[2:].strip()
                elif p.startswith("I="):
                    auth["투명후지"]["gukjeol"] = p[2:].strip()

    return {"meta": {"live": SNAP_ID, "authority": DIFF_ID, "captured_at": STAMP,
                     "generated_by": "transcribe_sticker_material_dual_056.py"},
            "live": live, "authority": auth}


def md(d):
    o = []
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_sticker_material_dual_056.py "
             f"live={SNAP_ID} authority={DIFF_ID} @ {STAMP} -->")
    o += ["| mat_cd | 라이브 현재 명 | 라이브 평량(g) | 라이브 reg | 연당가(라이브) |",
          "|---|---|---|---|---|"]
    for v in d["live"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["weight"]} | {v["reg_dt"]} | {v["yeondang_stored"]} |')
    o.append("")
    o += ["| 권위 소재(260702) | 명 | 평량(g) | 연당가 | 국4절가 |",
          "|---|---|---|---|---|"]
    a = d["authority"]
    o.append(f'| 백색후지(MAT_000162/371) | {a["백색후지"].get("mat_nm","?")} | '
             f'{a["백색후지"].get("weight","?")} | {a["백색후지"].get("yeondang","?")} | '
             f'{a["백색후지"].get("gukjeol","?")} |')
    o.append(f'| 투명후지(MAT_000372·신규행) | {a["투명후지"].get("mat_nm","?")} | '
             f'{a["투명후지"].get("weight","?")} | {a["투명후지"].get("yeondang","?")} | '
             f'{a["투명후지"].get("gukjeol","?")} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache",
                         "transcribed-sticker-mat-dual-056-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
