#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — PRD_000044 인쇄배경지(투명케이스타입).

기존 transcribe_snapshot.py는 파일럿 공통 사이즈(016 7행+국전)만 다룬다. 배경지(043)의
전용 사이즈(SIZ_000033~038)·자재/도수/공정/판형/공식 멤버십은 그 스크립트 범위 밖이라
이 보강 스크립트를 새로 추가한다(기존 스크립트 무수정). 노드 파일의 사이즈 치수·수량 스칼라·
축 멤버십은 이 스크립트가 라이브 스냅샷에서 결정론적으로 뽑은 것을 그대로 옮긴 것이며,
사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_044.py           # stdout에 markdown 블록(사이즈 전사표 + 멤버십 요약)
       python3 transcribe_044.py --json    # cache/transcribed-044-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000044"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def sub(rows):
    return [r for r in rows if r.get("prd_cd") == PRD and r.get("del_yn", "N") != "Y"]


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    prd_sizes = sub(rd("t_prd_product_sizes.csv"))
    siz_codes = [r["siz_cd"] for r in prd_sizes]
    siz_master = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in siz_codes}
    mats = sub(rd("t_prd_product_materials.csv"))
    popts = sub(rd("t_prd_product_print_options.csv"))
    procs = sub(rd("t_prd_product_processes.csv"))
    plates = sub(rd("t_prd_product_plate_sizes.csv"))
    forms = sub(rd("t_prd_product_price_formulas.csv"))
    cats = sub(rd("t_prd_product_categories.csv"))
    ogroups = sub(rd("t_prd_product_option_groups.csv"))
    consts = sub(rd("t_prd_product_constraints.csv"))
    addons = sub(rd("t_prd_product_addons.csv"))
    sets_ = sub(rd("t_prd_product_sets.csv"))
    bqty = sub(rd("t_prd_product_bundle_qtys.csv"))

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_044.py"},
        "product": {"prd_nm": prod.get("prd_nm"), "prd_typ_cd": prod.get("prd_typ_cd"),
                    "min_qty": prod.get("min_qty"), "max_qty": prod.get("max_qty"),
                    "qty_incr": prod.get("qty_incr"), "qty_unit_typ_cd": prod.get("qty_unit_typ_cd"),
                    "file_upload_yn": prod.get("file_upload_yn"), "editor_yn": prod.get("editor_yn"),
                    "use_yn": prod.get("use_yn"), "del_yn": prod.get("del_yn")},
        "sizes": [{"siz_cd": s, "siz_nm": siz_master.get(s, {}).get("siz_nm"),
                   "work": f'{_mm(siz_master.get(s,{}).get("work_width"))}x{_mm(siz_master.get(s,{}).get("work_height"))}',
                   "cut": f'{_mm(siz_master.get(s,{}).get("cut_width"))}x{_mm(siz_master.get(s,{}).get("cut_height"))}'}
                  for s in siz_codes],
        "materials": [{"mat_cd": r["mat_cd"], "usage_cd": r.get("usage_cd"), "dflt": r.get("dflt_yn")} for r in mats],
        "print_options": [{"opt_id": r["opt_id"], "print_side": r["print_side"],
                           "print_opt_cd": r["print_opt_cd"], "front": r["front_colrcnt_cd"],
                           "back": r["back_colrcnt_cd"]} for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "mand": r.get("mand_proc_yn")} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r.get("output_paper_typ_cd"),
                    "dflt_plt": r.get("dflt_plt_yn")} for r in plates],
        "formulas": [{"frm_cd": r["frm_cd"], "note": r.get("note")} for r in forms],
        "categories": [{"cat_cd": r["cat_cd"], "main_cat_yn": r.get("main_cat_yn")} for r in cats],
        "counts": {"option_groups": len(ogroups), "constraints": len(consts),
                   "addons": len(addons), "sets": len(sets_), "bundle_qtys": len(bqty)},
    }


def md_sizes(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_044.py from {SNAP_ID} t_siz_sizes (PRD_000044 sizes) @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s in d["sizes"]:
        out.append(f'| {s["siz_cd"]} | {s["siz_nm"]} | {s["work"]} | {s["cut"]} |')
    return "\n".join(out)


def md_membership(d):
    p = d["product"]
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_044.py from {SNAP_ID} t_prd_product_* (PRD_000044) @ {STAMP} -->",
           "| 축 | 라이브 멤버십 |", "|---|---|",
           f'| 정체 | {p["prd_nm"]} · prd_typ_cd={p["prd_typ_cd"]} · use_yn={p["use_yn"]}/del_yn={p["del_yn"]} · file_upload={p["file_upload_yn"]}/editor={p["editor_yn"]} |',
           f'| 수량 | min={p["min_qty"]} · max={p["max_qty"]} · incr={p["qty_incr"]} · 단위={p["qty_unit_typ_cd"]} |',
           f'| 사이즈 | {", ".join(s["siz_cd"] for s in d["sizes"])} ({len(d["sizes"])}행) |',
           f'| 자재 | {", ".join(m["mat_cd"]+"("+m["usage_cd"]+")" for m in d["materials"])} |',
           f'| 도수(인쇄옵션) | {", ".join(o["print_opt_cd"]+"("+o["print_side"]+")" for o in d["print_options"])} |',
           f'| 공정 | {", ".join(pr["proc_cd"]+("(mand)" if pr["mand"]=="Y" else "") for pr in d["processes"])} |',
           f'| 판형 | {", ".join(pl["output_paper_typ_cd"]+"@"+pl["siz_cd"] for pl in d["plates"])} |',
           f'| 공식 | {", ".join(f["frm_cd"] for f in d["formulas"])} |',
           f'| 카테고리 | {", ".join(c["cat_cd"]+("(main)" if c["main_cat_yn"]=="Y" else "") for c in d["categories"])} |',
           f'| CPQ/추가/셋트 | option_groups={d["counts"]["option_groups"]} · constraints={d["counts"]["constraints"]} · addons={d["counts"]["addons"]} · sets={d["counts"]["sets"]} · bundle_qtys={d["counts"]["bundle_qtys"]} |']
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-044-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 사이즈 전사표 (044 전용)\n")
        print(md_sizes(d))
        print("\n### 라이브 축 멤버십 (044)\n")
        print(md_membership(d))
