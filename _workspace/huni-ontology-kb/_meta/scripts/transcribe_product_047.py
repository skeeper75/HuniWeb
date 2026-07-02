#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 소량전단지 PRD_000047 전용.

transcribe_product_026.py(종이슬로건) 패턴을 계승하되, 소량전단지가 필요로 하는
자재 46종 전수 표(USAGE.07 단일 슬롯)·4 옵션그룹(인쇄/종이/코팅/후가공=SEL_TYPE.02 다중)·
제약규칙 현재 스냅샷 실측(0행)을 라이브 스냅샷에서 결정론적으로 뽑아, 노드 본문에 붙일
markdown 표(transcribed-by 마커)와 JSON 캐시로 출력한다. 사람이 눈으로 읽어 손으로 옮기지 않는다.

종이슬로건(026)과 다른 점: 사이즈 4종(A5/A4/A3/A3+)·자재 46종·공정 5(base+코팅2+가변2)·
후가공 다중선택 옵션그룹(OPT_000062 SEL_TYPE.02 max2)·공식=PRF_DGP_D(원자합산형 전단지형).
option_items의 종이(.03) 46행은 자재 전사표와 1:1이라 md에서 요약(비-자재 참조만 전개).

사용:  python3 transcribe_product_047.py            # stdout에 markdown 블록
       python3 transcribe_product_047.py --json     # cache/transcribed-047-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000047"
SELF = "transcribe_product_047.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc_nm = {r["proc_cd"]: r.get("proc_nm") for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    mat_nm = {r["mat_cd"]: r.get("mat_nm") for r in rd("t_mat_materials.csv")}
    mat_typ = {r["mat_cd"]: r.get("mat_typ_cd") for r in rd("t_mat_materials.csv")}
    cat_nm = {r["cat_cd"]: r.get("cat_nm") for r in rd("t_cat_categories.csv")}

    cats = active(by_prd("t_prd_product_categories.csv"))
    psizes = active(by_prd("t_prd_product_sizes.csv"))
    mats = active(by_prd("t_prd_product_materials.csv"))
    popts = active(by_prd("t_prd_product_print_options.csv"))
    procs = active(by_prd("t_prd_product_processes.csv"))
    plates = active(by_prd("t_prd_product_plate_sizes.csv"))
    bqty = active(by_prd("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd("t_prd_product_addons.csv"))
    cons = active(by_prd("t_prd_product_constraints.csv"))

    grps = active(by_prd("t_prd_product_option_groups.csv"))
    opts = active(by_prd("t_prd_product_options.csv"))
    items = active(by_prd("t_prd_product_option_items.csv"))
    opt_by_cd = {o["opt_cd"]: o for o in opts}

    # L-18 정합 결정론 실측: 활성 옵션아이템(.03 자재참조)이 이 상품 활성 materials에 실재하는가.
    active_mat = {r["mat_cd"] for r in mats}
    broken = []
    for i in items:
        if i["ref_dim_cd"] == "OPT_REF_DIM.03" and i["ref_key1"] not in active_mat:
            m = next((r for r in rd("t_mat_materials.csv") if r["mat_cd"] == i["ref_key1"]), {})
            po = opt_by_cd.get(i["opt_cd"], {})
            broken.append({"opt_cd": i["opt_cd"], "opt_nm": po.get("opt_nm"),
                           "ref_key1": i["ref_key1"], "master_nm": m.get("mat_nm"),
                           "master_typ": m.get("mat_typ_cd")})

    linked_siz = sorted({r["siz_cd"] for r in psizes} | {r["siz_cd"] for r in plates})
    size_dims = {s: {"siz_nm": sizes[s]["siz_nm"],
                     "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                     "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                     "note": sizes[s].get("note") or ""}
                 for s in linked_siz if s in sizes}

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat_nm.get(r["cat_cd"]),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes_linked": [r["siz_cd"] for r in psizes],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"]),
                       "mat_typ_cd": mat_typ.get(r["mat_cd"]),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"],
                       "disp_seq": r["disp_seq"]} for r in mats],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "opt_id": r["opt_id"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")} for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc_nm.get(r["proc_cd"]),
                       "mand_proc_yn": r["mand_proc_yn"], "disp_seq": r["disp_seq"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "dflt_plt_yn": r["dflt_plt_yn"]} for r in plates],
        "bundle_qty": [{"bdl_qty": r["bdl_qty"], "bdl_unit_typ_cd": r["bdl_unit_typ_cd"]} for r in bqty],
        "addons": [dict(r) for r in addons],
        "constraints": [dict(r) for r in cons],
        "option_groups": [{"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                           "sel_typ_cd": g["sel_typ_cd"], "min_sel_cnt": g["min_sel_cnt"],
                           "max_sel_cnt": g["max_sel_cnt"], "mand_yn": g["mand_yn"]} for g in grps],
        "option_items": [{"opt_grp_cd": opt_by_cd.get(i["opt_cd"], {}).get("opt_grp_cd"),
                          "opt_cd": i["opt_cd"], "opt_nm": opt_by_cd.get(i["opt_cd"], {}).get("opt_nm"),
                          "ref_dim_cd": i["ref_dim_cd"], "ref_key1": i["ref_key1"],
                          "ref_key2": i["ref_key2"]} for i in items],
        "formulas": fbind,
        "wiring": wiring,
        "optref_broken": broken,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000047"))
    p = d["product"]
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | main_cat_yn |")
    o.append("|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 치수 (전사)\n")
    o.append(_tb("t_siz_sizes (linked+plate)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | note |")
    o.append("|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["note"]} |')

    o.append("\n### 자재 (전사·46종 USAGE.07 단일 슬롯)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| disp_seq | mat_cd | 자재명 | mat_typ | usage | dflt |")
    o.append("|---|---|---|---|---|---|")
    for r in sorted(d["materials"], key=lambda x: int(x["disp_seq"] or 0)):
        o.append(f'| {r["disp_seq"]} | {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 인쇄옵션 (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| disp_seq | proc_cd | 공정명 | mand |")
    o.append("|---|---|---|---|")
    for r in sorted(d["processes"], key=lambda x: int(x["disp_seq"] or 0)):
        o.append(f'| {r["disp_seq"]} | {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} |')

    o.append("\n### 판형 (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | dflt |")
    o.append("|---|---|---|")
    for r in d["plates"]:
        o.append(f'| {r["siz_cd"]} | {r["output_paper_typ_cd"]} | {r["dflt_plt_yn"]} |')

    o.append("\n### CPQ 옵션그룹 (전사)\n")
    o.append(_tb("t_prd_product_option_groups"))
    o.append("| opt_grp_cd | 그룹명 | sel_typ | min/max | mand |")
    o.append("|---|---|---|---|---|")
    for g in d["option_groups"]:
        o.append(f'| {g["opt_grp_cd"]} | {g["opt_grp_nm"]} | {g["sel_typ_cd"]} | {g["min_sel_cnt"]}/{g["max_sel_cnt"]} | {g["mand_yn"]} |')

    # option_items: 종이(.03) 46행은 자재 전사표와 1:1 → 비-자재 참조만 전개 + 자재행 요약
    o.append("\n### CPQ 옵션 아이템 → 차원 참조 (전사·비-자재 참조 전개)\n")
    o.append(_tb("t_prd_product_option_items"))
    o.append("| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 |")
    o.append("|---|---|---|---|---|---|")
    mat_items = 0
    for i in d["option_items"]:
        if i["ref_dim_cd"] == "OPT_REF_DIM.03":
            mat_items += 1
            continue
        o.append(f'| {i["opt_grp_cd"]} | {i["opt_cd"]} | {i["opt_nm"]} | {i["ref_dim_cd"]} | {i["ref_key1"]} | {i["ref_key2"] or ""} |')
    o.append(f'| OPT_000060 | (자재참조) | 종이 옵션 | OPT_REF_DIM.03 | mat_cd | USAGE.07 |')
    nbroken = len(d["optref_broken"])
    active_mat_n = len(d["materials"])
    o.append(f"\n> 종이(OPT_000060) 옵션아이템 = **{mat_items}행**(OPT_REF_DIM.03·ref_key1=mat_cd·ref_key2=USAGE.07) vs "
             f"활성 materials **{active_mat_n}행** → 위 자재 전사표와 대응. "
             f"★L-18 결정론 실측: 활성 옵션아이템 중 상품 활성 materials에 없는 참조 = **{nbroken}건**.")
    if nbroken:
        o.append("\n| 매달린 옵션아이템(broken ref) | 옵션 라벨 | ref mat_cd | 자재마스터 이름 | mat_typ |")
        o.append("|---|---|---|---|---|")
        for b in d["optref_broken"]:
            o.append(f'| {b["opt_cd"]} | {b["opt_nm"]} | {b["ref_key1"]} | {b["master_nm"]} | {b["master_typ"]} |')
        o.append("\n> ★위 broken ref = `fn_chk_opt_item_ref` 정합 위반 후보(L-18). "
                 "활성 옵션아이템이 **상품 활성 materials에 없는** mat_cd를 가리킴 → [[gap-047-optref-mat129]]로 정직 선언.")

    o.append("\n### 미보유·현재값 축 (전사·실측 행수)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/constraints"))
    o.append("| 축 | 행수(스냅샷 20260702_1119) |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append("\n> ★제약규칙 0행 = **스냅샷 11:19 시점의 현재값**. §31 wave-3(코팅×종이두께 "
             "`R_EXCL_COATING_THIN_PAPER`)는 같은 날 **17:21 COMMIT**(스냅샷 이후)이라 이 스냅샷에 없음 "
             "→ 아래 [[gap-047-coating-constraint]]로 정직 선언(재촬영 필요).")

    o.append("\n### 가격 배선 PRF_DGP_D (전사·골든 스냅샷 20260702_1119)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-047-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
