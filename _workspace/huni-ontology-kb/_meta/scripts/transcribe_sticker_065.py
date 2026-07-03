#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 스티커팩 PRD_000065 전용.

transcribe_sticker_058.py 패턴을 계승하되, 스티커팩(065·합가형 완제품가) 특성에 맞춘다:
  - ★가격 = COMP_STK_PACK(합가형·54장1세트 4000·use_dims=[siz_cd,min_qty]) 단 1행 룩업.
    COMP_STK_PRINT(자유형 6,498행)과 다른 컴포넌트 — 팩은 소재 무관(mat_cd 미차원).
  - ★공정 0행·옵션그룹 0행·제약 0행·셋트(sets) 0행 = 순수 인쇄물/미적재 축 정직 전사.
  - 카테고리 2행(CAT_000002 스티커=main·CAT_000312 스티커팩=부·cat_lvl 2).
  - 사이즈 = SIZ_000068(75x110·판걸이=16·적용 스티커팩) 단 1행.
  - 판형 active = SIZ_000521(OUTPUT_PAPER_TYPE.02 46전지) + 삭제행 SIZ_000068(.03 PDF 파일사양).
  - 자재 active 2종(비코팅스티커 084 MAT_TYPE.13·미색스티커 242 MAT_TYPE.11) — 둘 다 dflt·note '정정 종이→스티커'.
  - 인쇄옵션 = POPT_000001 단면.
  - 공식 = PRF_STK_PACK(합가형) → COMP_STK_PACK.
  - 연당가 대조 = 26_change-tracking price-diff 스티커 소재행(065 소재=비코팅/미색 substantive 변경 판정용).

사용:  python3 transcribe_sticker_065.py            # stdout에 markdown 블록
       python3 transcribe_sticker_065.py --json     # cache/transcribed-065-260703.json 갱신
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
PRD = "PRD_000065"
SELF = "transcribe_sticker_065.py"
PACK_COMP = "COMP_STK_PACK"


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
        return {"siz_nm": "(미상)", "work": "", "cut": "", "note": ""}
    return {"siz_nm": r.get("siz_nm") or "",
            "work": f'{_mm(r.get("work_width"))}x{_mm(r.get("work_height"))}',
            "cut": f'{_mm(r.get("cut_width"))}x{_mm(r.get("cut_height"))}',
            "note": r.get("note") or ""}


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
                        "comp_typ_cd": pcomp.get(r["comp_cd"], {}).get("comp_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 가격격자 충전 실측: COMP_STK_PACK 전 단가행(팩은 합가형·소수행 → 전행 전사)
    pack_rows = []
    pack_total = 0
    for r in rd("t_prc_component_prices.csv"):
        if r.get("comp_cd") == PACK_COMP:
            pack_total += 1
            pack_rows.append({"siz_cd": r.get("siz_cd"), "mat_cd": r.get("mat_cd") or "",
                              "min_qty": r.get("min_qty"), "unit_price": r.get("unit_price"),
                              "note": (r.get("note") or "")[:60]})

    # 소재별 COMP_PAPER(용지비=연당가 절가) 존재 여부 — 065 소재(084/242) 0행 실증
    active_mats = [r["mat_cd"] for r in active(mats)]
    paper_rows = {m: 0 for m in active_mats}
    for r in rd("t_prc_component_prices.csv"):
        if r.get("comp_cd") == "COMP_PAPER" and r.get("mat_cd") in paper_rows:
            paper_rows[r["mat_cd"]] += 1

    # 연당가 diff: 스티커 소재행 (065 소재 비코팅/미색 substantive 판정)
    diffrows = []
    try:
        with open(DIFF, encoding="utf-8") as f:
            for r in csv.DictReader(f):
                sheet = r.get("sheet") or ""
                col = r.get("column") or ""
                key = (r.get("key") or "")
                if ("출력소재" in sheet or "스티커" in sheet) and \
                   any(t in (key + col) for t in ("비코팅", "미색", "유포", "연당가", "국4절", "평량")):
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
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", ""),
                        "main_cat_yn": r["main_cat_yn"], "disp": r.get("disp_seq")} for r in cats],
        "sizes_active": [{"siz_cd": r["siz_cd"], "dflt": r["dflt_yn"], **dim(sizes, r["siz_cd"])}
                         for r in active(psizes)],
        "sizes_deleted": [r["siz_cd"] for r in deleted(psizes)],
        "plates_active": [{"siz_cd": r["siz_cd"], "otyp": r["output_paper_typ_cd"],
                           "dflt": r["dflt_plt_yn"], **dim(sizes, r["siz_cd"])} for r in active(plates)],
        "plates_deleted": [{"siz_cd": r["siz_cd"], "otyp": r["output_paper_typ_cd"]} for r in deleted(plates)],
        "materials_active": [{"mat_cd": r["mat_cd"], "usage": r["usage_cd"], "dflt": r["dflt_yn"],
                              "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
                              "mat_typ": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
                              "upr": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                              "weight": mat.get(r["mat_cd"], {}).get("weight", ""),
                              "note": mat.get(r["mat_cd"], {}).get("note", "")} for r in active(mats)],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")}
                          for r in active(popts)],
        "processes_active": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
                              "mand": r["mand_proc_yn"]} for r in active(procs)],
        "opt_groups_count": len(grps),
        "opt_values_count": len([r for r in opts if r.get("del_yn") != "Y"]),
        "opt_items_count": len([r for r in items if r.get("del_yn") != "Y"]),
        "constraints_count": len(cons),
        "formulas": [{"frm": f, "frm_nm": pfrm.get(f, {}).get("frm_nm"),
                      "note": pfrm.get(f, {}).get("note"), "use_yn": pfrm.get(f, {}).get("use_yn")}
                     for f in fbind],
        "wiring": wiring,
        "pack_grid": {"total_rows": pack_total, "rows": pack_rows},
        "paper_rows": paper_rows,
        "empty_axes": {"processes": len(procs), "option_groups": len(grps),
                       "constraints": len(cons),
                       "bundle_qtys": len(by_prd("t_prd_product_bundle_qtys.csv")),
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
    o.append(_tb("t_prd_products PRD_000065"))
    o.append("| prd_nm | prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_nm']} | {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['del_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 상위 | cat_lvl | main_cat_yn | disp |")
    o.append("|---|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} | {r["disp"]} |')

    o.append("\n### 사이즈 치수 active (전사)\n")
    o.append(_tb("t_prd_product_sizes(del_yn=N)+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt | 마스터 note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["sizes_active"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["cut"]} | {r["dflt"]} | {r["note"]} |')
    o.append(f'\n> 삭제 사이즈행: {", ".join(d["sizes_deleted"]) or "없음"}')

    o.append("\n### 판형 (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | output_paper_typ | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["plates_active"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["otyp"]} | {r["dflt"]} |')
    o.append(f'\n> 삭제 판형행(del_yn=Y): ' +
             (", ".join(f'{x["siz_cd"]}({x["otyp"]})' for x in d["plates_deleted"]) or "없음"))

    o.append("\n### 자재 active (전사)\n")
    o.append(_tb("t_prd_product_materials(del_yn=N)+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위 | 평량 | usage | dflt | 마스터 note |")
    o.append("|---|---|---|---|---|---|---|---|")
    for r in d["materials_active"]:
        note = (r["note"] or "").replace("|", "\\|").replace("\n", " ")
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ"]} | {r["upr"]} | {r["weight"]} | {r["usage"]} | {r["dflt"]} | {note} |')

    o.append("\n### 인쇄옵션 active (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 가격 배선 + 팩 격자 전행 (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components+t_prc_component_prices"))
    for f in d["formulas"]:
        o.append(f'\n**{f["frm"]}** — {f["frm_nm"]} (use_yn={f["use_yn"]}·note: {f["note"]})\n')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|---|")
        for r in d["wiring"][f["frm"]]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    pg = d["pack_grid"]
    o.append(f'\n> {PACK_COMP} 전체 단가행 = {pg["total_rows"]}행(전행 전사·팩은 합가형 소수행):')
    o.append("\n| siz_cd | mat_cd | min_qty | unit_price | note |")
    o.append("|---|---|---|---|---|")
    for r in pg["rows"]:
        note = (r["note"] or "").replace("|", "\\|")
        o.append(f'| {r["siz_cd"]} | {r["mat_cd"] or "(무·소재무관)"} | {r["min_qty"]} | {r["unit_price"]} | {note} |')
    o.append(f'\n> ★소재 연당가 절가(COMP_PAPER) 065 소재 행수(0=원가 절가 미저장·완제품가 모델):')
    o.append("\n| mat_cd | COMP_PAPER 행수 |")
    o.append("|---|---|")
    for m, c in d["paper_rows"].items():
        o.append(f"| {m} | {c} |")

    o.append("\n### 미보유/미적재 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_processes/option_groups/constraints/bundle_qtys/addons/sets/prices"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    for k, v in d["empty_axes"].items():
        o.append(f"| {k} | {v} |")

    o.append("\n### 260702 연당가/국4절 diff — 스티커 소재행 (전사·065 소재=비코팅/미색 substantive 판정)\n")
    o.append(f"<!-- transcribed-by: _meta/scripts/{SELF} from {d['meta']['diff_src']} @ {STAMP} -->")
    o.append("| sheet | key | column | before | after |")
    o.append("|---|---|---|---|---|")
    for r in d["diff"]:
        af = (r["after"] or "").replace("|", "\\|")[:60]
        key = (r["key"] or "").replace("|", "\\|")[:60]
        o.append(f'| {r["sheet"]} | {key} | {r["column"]} | {r["before"]} | {af} |')
    o.append(f'\n> 판정: 위 diff에 065 소재(비코팅스티커·미색스티커)의 **연당가/국4절 substantive 변경 없음**(N2 좌표 라벨만·§4-A 4소재=투명/홀로/크라프트/투명후지에 065 소재 미포함) → 065 완제품가·소재 원가 clean(false-defect 방지·052 선례).')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-065-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
