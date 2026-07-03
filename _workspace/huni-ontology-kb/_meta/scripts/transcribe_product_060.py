#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 반칼직사각스티커 PRD_000060 전용.

transcribe_product_051.py(썬캡) 패턴을 계승하되, 스티커 파일럿 특성에 맞춘다:
  - 가격 모델 = 완제품가 고정가 룩업(PRF_STK_FIXED → COMP_STK_PRINT·use_dims=[siz_cd,mat_cd,min_qty]).
    원자합산형 아님(pack §3.10). 단가행(component_prices)은 값 전사 대신 (siz,mat) 조합별 행수만
    집계(단가행 접기·D-22·값 절대치는 evaluate_price 권위).
  - 자재 5종(유포 153·비코팅 084·미색 242 + 코팅 무광 155·유광 156). ★코팅 자재 155/156 = BATCH-3
    CONFLICT(코팅=자재 vs Q9 코팅=공정) 대상. mat note·del_yn 포함해 6-14 정정 note 실증.
  - 공정 = PROC_000055 스티커완칼(mand=N) 1행. ★상품명 "반칼"인데 등록 공정=완칼(PROC_000055)
    → 관찰(GAP). PROC_000004 base 인쇄 미보유(고정가 룩업이라 base 인쇄 구성요소 불요).
  - 사이즈 = SIZ_000520 A4 반칼 / SIZ_000170 A5. ★SIZ_000170은 t_siz_sizes 마스터 del_yn=Y이나
    상품-사이즈 링크는 del_yn=N(불일치 관찰). 사이즈 마스터 del_yn 전사.
  - 판형 = 활성 SIZ_000521(46전지·OUTPUT_PAPER_TYPE.02) 1행 + 삭제 2행(SIZ_000007/050·6-30 del).
  - 연당가 diff = 060 자재는 price-diff에서 N2 라벨 변경만(가격 무영향) → 연당가 양면노드 해당 없음.
  - CPQ 옵션그룹/추가상품/제약/셋트/묶음수 = 0행.

사용:  python3 transcribe_product_060.py            # stdout에 markdown 블록
       python3 transcribe_product_060.py --json     # cache/transcribed-060-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys
from collections import Counter

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000060"
SELF = "transcribe_product_060.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd_all(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def by_prd(name):
    return active(by_prd_all(name))


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc_all = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    mat_all = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat_nm = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = by_prd("t_prd_product_categories.csv")
    psizes = by_prd("t_prd_product_sizes.csv")
    mats = by_prd("t_prd_product_materials.csv")
    popts = by_prd("t_prd_product_print_options.csv")
    procs = by_prd("t_prd_product_processes.csv")
    plates_all = by_prd_all("t_prd_product_plate_sizes.csv")   # 삭제행도 관찰용
    bqty = by_prd("t_prd_product_bundle_qtys.csv")
    addons = by_prd("t_prd_product_addons.csv")
    cons = by_prd("t_prd_product_constraints.csv")
    grps = by_prd("t_prd_product_option_groups.csv")
    sets_parent = [r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD]

    linked_siz = sorted({r["siz_cd"] for r in psizes} |
                        {r["siz_cd"] for r in plates_all})
    size_dims = {s: {"siz_nm": sizes[s]["siz_nm"],
                     "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                     "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                     "del_yn": sizes[s].get("del_yn") or "N",
                     "tags": sizes[s].get("tags") or "",
                     "note": sizes[s].get("note") or ""}
                 for s in linked_siz if s in sizes}

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv")
             if r["prd_cd"] == PRD]
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""),
                                 x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")}
                       for r in rows]

    # 단가행 격자 커버리지(값 전사 아님·행수 집계만·D-22 접기)
    my_siz = {r["siz_cd"] for r in psizes}
    my_mat = {r["mat_cd"] for r in mats}
    grid = Counter()
    for r in rd("t_prc_component_prices.csv"):
        if r.get("comp_cd") == "COMP_STK_PRINT" and \
           r.get("siz_cd") in my_siz and r.get("mat_cd") in my_mat:
            grid[(r["siz_cd"], r["mat_cd"])] += 1

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"],
                        "cat_nm": cat_nm.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr": cat_nm.get(r["cat_cd"], {}).get("upr_cat_cd") or "",
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes_linked": [r["siz_cd"] for r in psizes],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"],
                       "mat_nm": mat_all.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_all.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"],
                       "mat_note": (mat_all.get(r["mat_cd"], {}).get("note") or "").strip()}
                      for r in mats],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "opt_id": r["opt_id"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")}
                          for r in popts],
        "processes": [{"proc_cd": r["proc_cd"],
                       "proc_nm": proc_all.get(r["proc_cd"], {}).get("proc_nm"),
                       "proc_note": (proc_all.get(r["proc_cd"], {}).get("note") or "").strip(),
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "output_file_typ": r.get("output_file_typ") or "",
                    "dflt_plt_yn": r["dflt_plt_yn"], "del_yn": r.get("del_yn") or "N",
                    "note": r.get("note") or ""} for r in plates_all],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": grps, "sets_parent": sets_parent,
        "formulas": fbind, "wiring": wiring,
        "price_grid": {f"{s}|{m}": n for (s, m), n in sorted(grid.items())},
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000060"))
    p = d["product"]
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['del_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 상위 | main_cat_yn |")
    o.append("|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 치수 (전사·형상=size) \n")
    o.append(_tb("t_siz_sizes (linked+plate)·del_yn 포함"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | del_yn | tags | note |")
    o.append("|---|---|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["del_yn"]} | {v["tags"]} | {v["note"]} |')

    o.append("\n### 자재 (전사·코팅 155/156=BATCH-3 CONFLICT) \n")
    o.append(_tb("t_prd_product_materials+t_mat_materials·note 포함"))
    o.append("| mat_cd | 이름 | mat_typ | usage_cd | dflt | mat note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} | {r["mat_note"]} |')

    o.append("\n### 인쇄옵션 (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes·note 포함"))
    o.append("| proc_cd | 공정명 | mand | proc note |")
    o.append("|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} | {r["proc_note"]} |')

    o.append("\n### 판형 (전사·활성+삭제) \n")
    o.append(_tb("t_prd_product_plate_sizes·del_yn 포함"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del_yn | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt_plt_yn"]} | {r["del_yn"]} | {r["note"]} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/constraints/option_groups/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")

    o.append("\n### 가격 배선 PRF_STK_FIXED (전사·완제품가 룩업) \n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 단가행 격자 커버리지 (전사·행수 집계·값 아님·D-22 접기) \n")
    o.append(_tb("t_prc_component_prices COMP_STK_PRINT (siz,mat) 조합별 행수"))
    o.append("| siz_cd | mat_cd | 단가행 수 |")
    o.append("|---|---|---|")
    for k, n in d["price_grid"].items():
        s, m = k.split("|")
        o.append(f"| {s} | {m} | {n} |")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-060-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
