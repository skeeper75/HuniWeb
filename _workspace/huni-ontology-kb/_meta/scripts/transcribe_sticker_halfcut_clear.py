#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 반칼 자유형 투명스티커 PRD_000053 전용.

transcribe_product_051.py(썬캡) 패턴을 계승하되 스티커 특성에 맞춘다:
  - 사이즈/자재/공정/판형은 **전 행(del 표기 포함)** 을 전사한다(6월말~7월초 재키잉/코드
    재발급 이력을 그래프가 침묵으로 버리지 않게). del_yn=Y도 표에 남기되 del 열로 구분.
  - CPQ = 옵션그룹 4·옵션 6·옵션아이템 5(ref_dim) 전량 전사(스티커 옵션 레이어 실재).
  - 가격 = PRF_STK_FIXED → COMP_STK_PRINT 단일(완제품가 고정가 룩업·use_dims 차원 선언만).
  - ★연당가 양면(defect) 근거 = 260702 권위 diff(price-diff-260527-260702.csv) 전사로
    authority_value 를 뽑는다(투명스티커 백색후지/투명후지 2소재만 053 사용).

사용:  python3 transcribe_sticker_halfcut_clear.py         # stdout markdown
       python3 transcribe_sticker_halfcut_clear.py --json  # cache/transcribed-sticker053-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
       _workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv (260702 권위)
"""
import csv, json, os, sys

HERE = os.path.dirname(__file__)
SNAP = os.path.abspath(os.path.join(HERE, "../../../_foundation/live-snapshot/latest"))
PDIFF = os.path.abspath(os.path.join(
    HERE, "../../../huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000053"
SELF = "transcribe_sticker_halfcut_clear.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return ""


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
             "main_cat_yn": r["main_cat_yn"]} for r in by_prd("t_prd_product_categories.csv")]

    psizes = [{"siz_cd": r["siz_cd"], "dflt_yn": r["dflt_yn"], "del_yn": r["del_yn"],
               "siz_nm": sizes.get(r["siz_cd"], {}).get("siz_nm"),
               "work": f'{_mm(sizes.get(r["siz_cd"],{}).get("work_width"))}x{_mm(sizes.get(r["siz_cd"],{}).get("work_height"))}',
               "mst_del": sizes.get(r["siz_cd"], {}).get("del_yn"),
               "note": (sizes.get(r["siz_cd"], {}).get("note") or "")}
              for r in by_prd("t_prd_product_sizes.csv")]

    mats = [{"mat_cd": r["mat_cd"], "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"],
             "del_yn": r["del_yn"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
             "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
             "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd"),
             "weight": mat.get(r["mat_cd"], {}).get("weight")}
            for r in by_prd("t_prd_product_materials.csv")]

    popts = [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"], "opt_id": r["opt_id"],
              "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
              "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")}
             for r in by_prd("t_prd_product_print_options.csv")]

    procs = [{"proc_cd": r["proc_cd"], "mand": r["mand_proc_yn"], "del_yn": r["del_yn"],
              "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
              "upr": proc.get(r["proc_cd"], {}).get("upr_proc_cd")}
             for r in by_prd("t_prd_product_processes.csv")]

    plates = [{"siz_cd": r["siz_cd"], "opt": r["output_paper_typ_cd"], "del_yn": r["del_yn"],
               "output_file_typ": r.get("output_file_typ"), "dflt": r["dflt_plt_yn"],
               "note": (r.get("note") or "")} for r in by_prd("t_prd_product_plate_sizes.csv")]

    grps = [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
             "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"], "max_sel": r["max_sel_cnt"],
             "mand_yn": r["mand_yn"], "use_yn": r["use_yn"], "del_yn": r["del_yn"],
             "note": (r.get("note") or "")}
            for r in by_prd("t_prd_product_option_groups.csv")]
    opts = [{"opt_cd": r["opt_cd"], "opt_grp_cd": r["opt_grp_cd"], "opt_nm": r["opt_nm"],
             "dflt_yn": r["dflt_yn"], "del_yn": r["del_yn"]}
            for r in by_prd("t_prd_product_options.csv")]
    items = [{"opt_cd": r["opt_cd"], "item_seq": r["item_seq"], "ref_dim_cd": r["ref_dim_cd"],
              "ref_key1": r["ref_key1"], "ref_key2": r.get("ref_key2"), "del_yn": r["del_yn"]}
             for r in by_prd("t_prd_product_option_items.csv")]

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

    # COMP_STK_PRINT 행수 + 053 소재(371/372) 커버 여부
    stk_rows = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == "COMP_STK_PRINT"]
    stk_total = len(stk_rows)
    cover = {m: sum(1 for r in stk_rows if r["mat_cd"] == m) for m in ("MAT_000371", "MAT_000372")}
    paper_rows = [r for r in rd("t_prc_component_prices.csv")
                  if r["comp_cd"] == "COMP_PAPER" and r["mat_cd"] in ("MAT_000162", "MAT_000371", "MAT_000372")]

    # 260702 권위 연당가 diff 전사 (투명스=백색후지, 투명투=투명후지 신규행)
    authority = {}
    with open(PDIFF, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            if r["sheet"] != "출력소재(IMPORT)":
                continue
            authority.setdefault(r["key"], []).append(
                {"column": r["column"], "before": r["before"], "after": r["after"]})

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF,
                 "pdiff": "huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": cats, "sizes": psizes, "materials": mats, "print_options": popts,
        "processes": procs, "plates": plates, "option_groups": grps, "options": opts,
        "option_items": items, "formulas": fbind, "wiring": wiring,
        "stk_total": stk_total, "cover": cover, "paper_rows": len(paper_rows),
        "authority": {"투명스": authority.get("투명스", []), "투명투": authority.get("투명투", [])},
    }


def _tb(what, src="live"):
    origin = SNAP_ID if src == "live" else "huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {origin} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000053"))
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | main_cat_yn |")
    o.append("|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes PRD_000053"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 상품행 del | 마스터 del | note |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt_yn"]} | {r["del_yn"]} | {r["mst_del"]} | {r["note"]} |')

    o.append("\n### 자재 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials PRD_000053"))
    o.append("| mat_cd | 자재명 | mat_typ | 부모 | 평량(g) | usage | dflt | del |")
    o.append("|---|---|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["upr_mat_cd"] or ""} | {_mm(r["weight"])} | {r["usage_cd"]} | {r["dflt_yn"]} | {r["del_yn"]} |')

    o.append("\n### 인쇄옵션 (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | opt_id | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["opt_id"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes PRD_000053"))
    o.append("| proc_cd | 공정명 | 상위 | mand | del |")
    o.append("|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr"] or ""} | {r["mand"]} | {r["del_yn"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_plate_sizes PRD_000053"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["opt"] if r["opt"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del_yn"]} | {r["note"]} |')

    o.append("\n### 옵션그룹 (전사)\n")
    o.append(_tb("t_prd_product_option_groups PRD_000053"))
    o.append("| opt_grp_cd | 그룹명 | sel_typ | min~max | mand | use | note |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["option_groups"]:
        o.append(f'| {r["opt_grp_cd"]} | {r["opt_grp_nm"]} | {r["sel_typ_cd"]} | {r["min_sel"]}~{r["max_sel"]} | {r["mand_yn"]} | {r["use_yn"]} | {r["note"]} |')

    o.append("\n### 옵션값·옵션아이템(ref_dim) (전사)\n")
    o.append(_tb("t_prd_product_options+t_prd_product_option_items PRD_000053"))
    o.append("| opt_grp | opt_cd | 옵션명 | dflt | item_seq | ref_dim_cd | ref_key1 | ref_key2 |")
    o.append("|---|---|---|---|---|---|---|---|")
    items_by = {}
    for it in d["option_items"]:
        items_by.setdefault(it["opt_cd"], []).append(it)
    for r in d["options"]:
        its = items_by.get(r["opt_cd"], [])
        if not its:
            o.append(f'| {r["opt_grp_cd"]} | {r["opt_cd"]} | {r["opt_nm"]} | {r["dflt_yn"]} | (없음) | | | |')
        for it in its:
            o.append(f'| {r["opt_grp_cd"]} | {r["opt_cd"]} | {r["opt_nm"]} | {r["dflt_yn"]} | {it["item_seq"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["ref_key2"] or ""} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/constraints/sets PRD_000053"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(by_prd('t_prd_product_bundle_qtys.csv'))} |")
    o.append(f"| addons(추가상품) | {len(by_prd('t_prd_product_addons.csv'))} |")
    o.append(f"| constraints(제약규칙) | {len(by_prd('t_prd_product_constraints.csv'))} |")
    o.append(f"| sets(셋트 구성원) | {len(by_prd('t_prd_product_sets.csv'))} |")

    o.append("\n### 가격 배선 PRF_STK_FIXED (전사·완제품가 격자)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    o.append(f"\n> COMP_STK_PRINT 단가행(완제품가) 총 {d['stk_total']}행 · 053 소재 커버: "
             f"MAT_000371(백색후지)={d['cover']['MAT_000371']}행·MAT_000372(투명후지)={d['cover']['MAT_000372']}행 · "
             f"COMP_PAPER(연당가/절가)에 162/371/372 = {d['paper_rows']}행(=원가 미저장).")

    o.append("\n### ★260702 권위 연당가 diff (전사·양면 authority_value 근거)\n")
    o.append(_tb("출력소재(IMPORT) 투명스(백색후지)·투명투(투명후지 신규행)", src="pdiff"))
    o.append("| 소재키 | 컬럼 | 260527(before) | 260702(after) |")
    o.append("|---|---|---|---|")
    def _san(v):
        return (v or "(신규)").replace("|", " ⁄ ")
    for key in ("투명스", "투명투"):
        for r in d["authority"][key]:
            o.append(f'| {key} | {r["column"]} | {_san(r["before"])} | {_san(r["after"])} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(HERE, "cache"), exist_ok=True)
        pth = os.path.join(HERE, "cache", "transcribed-sticker053-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
