#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 반칼원형스티커 PRD_000058 전용.

transcribe_product_051.py 패턴을 계승하되, 스티커(058) 특성에 맞춘다:
  - ★active(del_yn=N)만 전사 + 삭제행(del_yn=Y) 요약 카운트(재키잉 이력 정직 표기).
  - CPQ 옵션그룹/옵션값/옵션아이템 = 실재(07-01 재키잉) → 전 구조 전사.
  - constraints = RULE_001(A5 커팅·RULE_TYPE.03) 1행 → 전사(참조 siz_cd 포함).
  - bundle_qtys/addons/sets/직접단가 = 0행 → 미보유 축 정직 표기.
  - 카테고리 2행(CAT_000002 스티커=main·CAT_000037 규격스티커=부).
  - 사이즈 = t_prd_product_sizes active(SIZ_000520 A4반칼·SIZ_000170 A5) + 판형 SIZ_000521.
  - 자재 = active 5종(유포/미색/아트/무광코팅/유광코팅 — 전부 MAT_TYPE.11 스티커·07-01 variant 재키잉).
  - 공정 = active PROC_000122 반칼커팅(상위 PROC_000121 커팅) — base 인쇄공정 없음(완제품가 모델).
  - 인쇄옵션 = POPT_000001 단면.
  - 공식 = PRF_STK_FIXED(스티커 고정가·완제품가 룩업) → COMP_STK_PRINT(use_dims=[siz_cd,mat_cd,min_qty]).
  - 연당가 대조 = 26_change-tracking price-diff 스티커 소재행(058 소재 해당분만) 카운트.

사용:  python3 transcribe_sticker_058.py            # stdout에 markdown 블록
       python3 transcribe_sticker_058.py --json     # cache/transcribed-058-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
       26_change-tracking-260702/price-diff-260527-260702.csv (연당가 diff)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
DIFF = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000058"
SELF = "transcribe_sticker_058.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def deleted(rows):
    return [r for r in rows if r.get("del_yn", "N") == "Y"]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "" if v in (None, "") else str(v)


def dim(sizes, s):
    r = sizes.get(s)
    if not r:
        return {"siz_nm": "(미상)", "work": "", "cut": ""}
    return {"siz_nm": r.get("siz_nm") or "",
            "work": f'{_mm(r.get("work_width"))}x{_mm(r.get("work_height"))}',
            "cut": f'{_mm(r.get("cut_width"))}x{_mm(r.get("cut_height"))}'}


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    pfrm = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}

    psizes = by_prd("t_prd_product_sizes.csv")
    plates = by_prd("t_prd_product_plate_sizes.csv")
    mats = by_prd("t_prd_product_materials.csv")
    popts = by_prd("t_prd_product_print_options.csv")
    procs = by_prd("t_prd_product_processes.csv")
    grps = by_prd("t_prd_product_option_groups.csv")
    opts = by_prd("t_prd_product_options.csv")
    items = by_prd("t_prd_product_option_items.csv")
    cons = by_prd("t_prd_product_constraints.csv")
    cats = by_prd("t_prd_product_categories.csv")

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 가격격자 충전 실측: COMP_STK_PRINT 행수(058 active 소재별)
    active_mats = [r["mat_cd"] for r in active(mats)]
    grid = {"COMP_STK_PRINT_total": 0, "by_mat": {}}
    for r in rd("t_prc_component_prices.csv"):
        if r.get("comp_cd") == "COMP_STK_PRINT":
            grid["COMP_STK_PRINT_total"] += 1
            m = r.get("mat_cd")
            if m in active_mats:
                grid["by_mat"].setdefault(m, {"rows": 0, "sample": None})
                grid["by_mat"][m]["rows"] += 1
                if grid["by_mat"][m]["sample"] is None and r.get("min_qty"):
                    grid["by_mat"][m]["sample"] = {"siz_cd": r.get("siz_cd"),
                        "min_qty": r.get("min_qty"), "unit_price": r.get("unit_price"),
                        "note": (r.get("note") or "")[:40]}

    # 연당가 diff: 스티커 소재행 (058 소재 해당분 판정)
    diffrows = []
    try:
        with open(DIFF, encoding="utf-8") as f:
            for r in csv.DictReader(f):
                if "출력소재" in (r.get("sheet") or "") and \
                   (r.get("column") in ("연당가", "가격 (국4절)", "평량", "종이명") or "ADDED" in (r.get("column") or "")):
                    diffrows.append(r)
    except FileNotFoundError:
        diffrows = [{"sheet": "(파일 없음)", "key": "", "column": "", "before": "", "after": ""}]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF,
                 "diff_src": os.path.relpath(DIFF, os.path.join(os.path.dirname(__file__), "../../.."))},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "semi_role_cd", "min_qty", "max_qty",
                     "qty_incr", "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "main_cat_yn": r["main_cat_yn"], "disp": r.get("disp_seq")} for r in cats],
        "sizes_active": [{"siz_cd": r["siz_cd"], "dflt": r["dflt_yn"], **dim(sizes, r["siz_cd"])}
                         for r in active(psizes)],
        "sizes_deleted": [r["siz_cd"] for r in deleted(psizes)],
        "plates_active": [{"siz_cd": r["siz_cd"], "otyp": r["output_paper_typ_cd"],
                           "dflt": r["dflt_plt_yn"], **dim(sizes, r["siz_cd"])} for r in active(plates)],
        "plates_deleted": [r["siz_cd"] for r in deleted(plates)],
        "materials_active": [{"mat_cd": r["mat_cd"], "usage": r["usage_cd"], "dflt": r["dflt_yn"],
                              "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
                              "mat_typ": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
                              "upr": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                              "note": mat.get(r["mat_cd"], {}).get("note", "")} for r in active(mats)],
        "materials_deleted": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm")}
                              for r in deleted(mats)],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")}
                          for r in active(popts)],
        "processes_active": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
                              "upr": proc.get(r["proc_cd"], {}).get("upr_proc_cd", ""),
                              "mand": r["mand_proc_yn"]} for r in active(procs)],
        "processes_deleted": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm")}
                             for r in deleted(procs)],
        "opt_groups": [{"grp": r["opt_grp_cd"], "nm": r["opt_grp_nm"], "sel": r.get("sel_typ_cd"),
                        "mand": r.get("mand_yn"), "disp": r.get("disp_seq"), "del": r.get("del_yn")}
                       for r in grps],
        "opt_values": [{"opt": r["opt_cd"], "grp": r["opt_grp_cd"], "nm": r["opt_nm"],
                        "disp": r.get("disp_seq"), "del": r.get("del_yn")}
                       for r in opts if r.get("del_yn") != "Y"],
        "opt_items": [{"opt": r["opt_cd"], "ref_dim": r["ref_dim_cd"], "ref_key1": r["ref_key1"],
                       "ref_key2": r.get("ref_key2", ""), "del": r.get("del_yn")}
                      for r in items if r.get("del_yn") != "Y"],
        "constraints": [{"rule": r["constraint_cd"] if "constraint_cd" in r else r.get("rule_cd", list(r.values())[1]),
                         "nm": list(r.values())[2], "typ": list(r.values())[3],
                         "logic": list(r.values())[4][:400]} for r in cons],
        "formulas": [{"frm": f, "frm_nm": pfrm.get(f, {}).get("frm_nm"),
                      "note": pfrm.get(f, {}).get("note"), "use_yn": pfrm.get(f, {}).get("use_yn")}
                     for f in fbind],
        "wiring": wiring,
        "grid": grid,
        "empty_axes": {"bundle_qtys": len(by_prd("t_prd_product_bundle_qtys.csv")),
                       "addons": len(by_prd("t_prd_product_addons.csv")),
                       "sets": len(by_prd("t_prd_product_sets.csv")),
                       "direct_prices": len(by_prd("t_prd_product_prices.csv"))},
        "diff": [{"sheet": r.get("sheet"), "key": r.get("key"), "column": r.get("column"),
                  "before": r.get("before"), "after": r.get("after")} for r in diffrows],
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000058"))
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['del_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 상위 | main_cat_yn | disp |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr"]} | {r["main_cat_yn"]} | {r["disp"]} |')

    o.append("\n### 사이즈 치수 active (전사)\n")
    o.append(_tb("t_prd_product_sizes(del_yn=N)+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["sizes_active"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["cut"]} | {r["dflt"]} |')
    o.append(f'\n> 삭제행(del_yn=Y·07-01 재키잉): {", ".join(d["sizes_deleted"]) or "없음"}')

    o.append("\n### 판형 active (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes(del_yn=N)"))
    o.append("| siz_cd | 라벨 | 작업(mm) | output_paper_typ | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["plates_active"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["otyp"]} | {r["dflt"]} |')
    o.append(f'\n> 삭제 판형행: {", ".join(d["plates_deleted"]) or "없음"}')

    o.append("\n### 자재 active (전사)\n")
    o.append(_tb("t_prd_product_materials(del_yn=N)+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위 | usage | dflt | 마스터 note |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["materials_active"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ"]} | {r["upr"]} | {r["usage"]} | {r["dflt"]} | {r["note"]} |')
    o.append(f'\n> 삭제행(변경전 parent·07-01 재키잉): ' +
             (", ".join(f'{x["mat_cd"]}({x["mat_nm"]})' for x in d["materials_deleted"]) or "없음"))

    o.append("\n### 인쇄옵션 active (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 active (전사)\n")
    o.append(_tb("t_prd_product_processes(del_yn=N)+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위 | mand |")
    o.append("|---|---|---|---|")
    for r in d["processes_active"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr"]} | {r["mand"]} |')
    o.append(f'\n> 삭제 공정행: ' +
             (", ".join(f'{x["proc_cd"]}({x["proc_nm"]})' for x in d["processes_deleted"]) or "없음"))

    o.append("\n### CPQ 옵션그룹 (전사)\n")
    o.append(_tb("t_prd_product_option_groups"))
    o.append("| opt_grp_cd | 이름 | sel_typ | mand | disp | del_yn |")
    o.append("|---|---|---|---|---|---|")
    for r in d["opt_groups"]:
        o.append(f'| {r["grp"]} | {r["nm"]} | {r["sel"]} | {r["mand"]} | {r["disp"]} | {r["del"]} |')

    o.append("\n### CPQ 옵션값 active (전사)\n")
    o.append(_tb("t_prd_product_options(del_yn!=Y)"))
    o.append("| opt_cd | 그룹 | 이름 | disp |")
    o.append("|---|---|---|---|")
    for r in sorted(d["opt_values"], key=lambda x: (x["grp"], x["disp"] or "")):
        o.append(f'| {r["opt"]} | {r["grp"]} | {r["nm"]} | {r["disp"]} |')

    o.append("\n### CPQ 옵션아이템 참조 active (전사)\n")
    o.append(_tb("t_prd_product_option_items(del_yn!=Y)"))
    o.append("| opt_cd | ref_dim_cd | ref_key1 | ref_key2 |")
    o.append("|---|---|---|---|")
    for r in d["opt_items"]:
        o.append(f'| {r["opt"]} | {r["ref_dim"]} | {r["ref_key1"]} | {r["ref_key2"]} |')

    o.append("\n### 제약규칙 (전사)\n")
    o.append(_tb("t_prd_product_constraints"))
    o.append("| rule | 이름 | 유형 | logic(앞400자) |")
    o.append("|---|---|---|---|")
    for r in d["constraints"]:
        lg = r["logic"].replace("|", "\\|").replace("\n", " ")
        o.append(f'| {r["rule"]} | {r["nm"]} | {r["typ"]} | `{lg}` |')

    o.append("\n### 가격 배선 + 격자 충전 (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for f in d["formulas"]:
        o.append(f'\n**{f["frm"]}** — {f["frm_nm"]} (use_yn={f["use_yn"]}·note: {f["note"]})\n')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|")
        for r in d["wiring"][f["frm"]]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    g = d["grid"]
    o.append(f'\n> COMP_STK_PRINT 전체 단가행 = {g["COMP_STK_PRINT_total"]}행. 058 active 소재별 격자 충전(실측):')
    o.append("\n| mat_cd | 격자 행수 | 샘플(siz_cd·min_qty·단가·note) |")
    o.append("|---|---|---|")
    for m, v in sorted(g["by_mat"].items()):
        s = v["sample"] or {}
        smp = f'{s.get("siz_cd","")}·{s.get("min_qty","")}·{s.get("unit_price","")}·{s.get("note","")}' if s else "-"
        o.append(f'| {m} | {v["rows"]} | {smp} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/sets/prices"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    for k, v in d["empty_axes"].items():
        o.append(f"| {k} | {v} |")

    o.append("\n### 260702 연당가/국4절 diff — 스티커 소재행 (전사·058 소재 대조용)\n")
    o.append(f"<!-- transcribed-by: _meta/scripts/{SELF} from {d['meta']['diff_src']} @ {STAMP} -->")
    o.append("| sheet | key | column | before | after |")
    o.append("|---|---|---|---|---|")
    for r in d["diff"]:
        af = (r["after"] or "").replace("|", "\\|")[:60]
        o.append(f'| {r["sheet"]} | {r["key"]} | {r["column"]} | {r["before"]} | {af} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-058-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
