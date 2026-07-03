#!/usr/bin/env python3
# 셋트 계열 Stage C1 축 노드 민팅용 결정론 전사 (okb-knowledge-builder).
# t_mat_materials·t_siz_sizes에서 자재 사양·사이즈 치수를 전사(LLM 손전사 금지·D-9·§4).
# 사용: python3 transcribe_set_axis_c1_260703.py [materials|sizes]  → stdout 전사표 행.
import csv
import sys

SNAP = "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest"

# Stage C1 신규 mint 자재(search-before-mint로 기존 072/078/105/107/186 제외).
MINT_MATERIALS = [
    "MAT_000246", "MAT_000379", "MAT_000073", "MAT_000076", "MAT_000077",
    "MAT_000086", "MAT_000087", "MAT_000095", "MAT_000104", "MAT_000013",
    "MAT_000014", "MAT_000015", "MAT_000079", "MAT_000080", "MAT_000090",
    "MAT_000096", "MAT_000106", "MAT_000005", "MAT_000250", "MAT_000251",
    "MAT_000006", "MAT_000007", "MAT_000127", "MAT_000098",
]

# Stage C1 신규 mint 사이즈(기존 172/174/124/119/380 제외).
MINT_SIZES = [
    "SIZ_000266", "SIZ_000269", "SIZ_000274", "SIZ_000069", "SIZ_000070",
    "SIZ_000018", "SIZ_000071", "SIZ_000072", "SIZ_000073", "SIZ_000074",
    "SIZ_000050", "SIZ_000075", "SIZ_000076", "SIZ_000077",
]


def _num(v):
    v = (v or "").strip()
    if not v:
        return ""
    if "." in v:
        v = v.rstrip("0").rstrip(".")
    return v


def load(table, key):
    rows = {}
    with open(f"{SNAP}/{table}.csv", newline="", encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows[r[key]] = r
    return rows


def materials():
    rows = load("t_mat_materials", "mat_cd")
    print("| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 상위 | 마스터del |")
    print("|---|---|---|---|---|---|---|")
    for mc in MINT_MATERIALS:
        r = rows.get(mc)
        if not r:
            print(f"<!-- MISSING {mc} -->", file=sys.stderr)
            continue
        w, h = _num(r["width"]), _num(r["height"])
        spec = f"{w}x{h}" if (w or h) else "미기재"
        wt = _num(r["weight"]) or "미기재"
        upr = r["upr_mat_cd"] or "-"
        print(f"| {mc} | {r['mat_nm']} | {r['mat_typ_cd']} | {spec} | {wt} | {upr} | {r['del_yn']} |")


def sizes():
    rows = load("t_siz_sizes", "siz_cd")
    print("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 마스터del |")
    print("|---|---|---|---|---|")
    for sc in MINT_SIZES:
        r = rows.get(sc)
        if not r:
            print(f"<!-- MISSING {sc} -->", file=sys.stderr)
            continue
        ww, wh = _num(r["work_width"]), _num(r["work_height"])
        cw, ch = _num(r["cut_width"]), _num(r["cut_height"])
        work = f"{ww}x{wh}" if (ww or wh) else "미기재"
        cut = f"{cw}x{ch}" if (cw or ch) else "미기재"
        print(f"| {sc} | {r['siz_nm']} | {work} | {cut} | {r['del_yn']} |")


if __name__ == "__main__":
    what = sys.argv[1] if len(sys.argv) > 1 else "materials"
    (materials if what == "materials" else sizes)()
