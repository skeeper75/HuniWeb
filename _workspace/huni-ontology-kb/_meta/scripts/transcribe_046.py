#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000046 라벨/택 (D-9·§4·[HARD] LLM 손전사 금지).

기존 transcribe_snapshot.py는 016 엽서 7행 사이즈(SIZ_000001~007+499)만 전사한다.
라벨/택(046)의 사이즈(SIZ_000047/011/048)·전용 자재(MAT_000109)는 그 스크립트 범위 밖이라
이 보강 스크립트로 결정론 전사한다(기존 스크립트 수정 금지·새 파일 원칙).

사용:  python3 transcribe_046.py            # stdout markdown 블록(사이즈·자재·수량)
       python3 transcribe_046.py --json     # cache/transcribed-046-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000046"
SIZES = ["SIZ_000047", "SIZ_000011", "SIZ_000048"]   # 라벨/택 재단 사이즈 3행
MAT = "MAT_000109"                                    # 몽블랑 240g (라벨/택 본문 자재)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in SIZES}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv") if r["mat_cd"] == MAT}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": "transcribe_046.py"},
        "sizes": {s: {"siz_nm": siz[s]["siz_nm"],
                      "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}',
                      "cut": f'{_mm(siz[s]["cut_width"])}x{_mm(siz[s]["cut_height"])}',
                      "note": siz[s].get("note", "")}
                  for s in SIZES if s in siz},
        "material": {MAT: {"mat_nm": mat[MAT]["mat_nm"], "mat_typ_cd": mat[MAT]["mat_typ_cd"],
                           "upr_mat_cd": mat[MAT]["upr_mat_cd"],
                           "spec": f'{_mm(mat[MAT]["width"])}x{_mm(mat[MAT]["height"])}',
                           "weight": _mm(mat[MAT]["weight"])}} if MAT in mat else {},
        "qty": {"min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"]} if PRD in prod else {},
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_046.py from {SNAP_ID} t_siz_sizes PRD_000046 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 비고(라이브 note) |")
    out.append("|---|---|---|---|---|")
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["note"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_046.py from {SNAP_ID} t_mat_materials MAT_000109 @ {STAMP} -->")
    out.append("| mat_cd | 자재명 | mat_typ | 상위자재 | 규격(mm) | 평량(g) |")
    out.append("|---|---|---|---|---|---|")
    for m, v in d["material"].items():
        out.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["spec"]} | {v["weight"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_046.py from {SNAP_ID} t_prd_products PRD_000046 @ {STAMP} -->")
    out.append("| min_qty | max_qty | qty_incr | 단위 |")
    out.append("|---|---|---|---|")
    q = d["qty"]
    out.append(f'| {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-046-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
