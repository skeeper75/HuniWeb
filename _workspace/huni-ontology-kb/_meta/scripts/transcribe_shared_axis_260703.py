#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""transcribe_shared_axis_260703.py — 공유축 통합 mint용 수치 전사(D-9·LLM 손전사 금지).

브로큰링크 해소 대상 공유노드(4 material·5 formula·12 component)의 raw 수치(자재 규격/평량)를
live-snapshot t_mat_materials.csv에서 결정론 전사한다. 공식/구성요소는 use_dims·배선만(가격값 없음).
출력=materials.md 전사표 행 + formula_components 배선(disp_seq/addtn) 검증 덤프.
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../_foundation/live-snapshot/latest"))

MATS = ["MAT_000137", "MAT_000144", "MAT_000147", "MAT_000178"]


def load(table):
    with open(os.path.join(SNAP, table + ".csv"), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def main():
    mat = {r["mat_cd"]: r for r in load("t_mat_materials")}
    print("## 자재 전사표 행 (materials.md 삽입용)")
    print("| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 상위자재 |")
    print("|---|---|---|---|---|---|")
    for m in MATS:
        r = mat[m]
        w, h, wt = r["width"], r["height"], r["weight"]
        spec = f"{w.rstrip('0').rstrip('.')}x{h.rstrip('0').rstrip('.')}" if w and h else "미기재"
        wtv = wt.rstrip("0").rstrip(".") if wt else "미기재"
        upr = r["upr_mat_cd"] or "-"
        print(f"| {m} | {r['mat_nm']} | {r['mat_typ_cd']} | {spec} | {wtv} | {upr} |")

    fc = load("t_prc_formula_components")
    print("\n## formula_components 배선 검증 (has_component qualifier)")
    for f in ["PRF_PHOTOCARD_CLEAR", "PRF_NAMECARD_SHAPE", "PRF_NAMECARD_MINISHAPE",
              "PRF_NAMECARD_FOIL", "PRF_NAMECARD_CLEAR"]:
        rows = sorted([r for r in fc if r["frm_cd"] == f], key=lambda x: int(x["disp_seq"]))
        for r in rows:
            print(f"{f} -> {r['comp_cd']} disp_seq={r['disp_seq']} addtn={r['addtn_yn']}")


if __name__ == "__main__":
    main()
