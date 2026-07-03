#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 반칼팬시투명스티커 PRD_000063 전용.

transcribe_sticker_halfcut_clear.py(053) 패턴을 계승하되 063 특성에 맞춘다:
  - 063 = 규격(팬시) 투명 스티커·use_yn=N(미출시)·CPQ 옵션 레이어 0행(BATCH-6 GAP-ST-6).
  - 자재 = 구코드 MAT_000162(투명스티커·un-split parent) 단일 링크(053은 371/372로 마이그레이션·063은 미마이그레이션).
  - 커팅 공정 = PROC_000055(스티커완칼·Die Cut)·상품명 '반칼'과 명칭 관찰 불일치(gap-063-halfcut-process).
  - 화이트 = PROC_000008 실재(2026-06-13 추가) → pack §3.3 GAP-ST(화이트) "MISSING"은 REVERIFY로 해소.
  - 가격 = PRF_STK_FIXED → COMP_STK_PRINT 단일(완제품가 고정가 룩업·use_dims 차원 선언만).
  - ★연당가 = 투명스(백색후지) 260702 권위 diff 전사. dual 노드는 material-MAT_000162(056 companion) 재사용.

사용:  python3 transcribe_sticker_063.py         # stdout markdown
       python3 transcribe_sticker_063.py --json  # cache/transcribed-sticker063-260703.json
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
PRD = "PRD_000063"
SELF = "transcribe_sticker_063.py"
MAT_063 = "MAT_000162"          # 063 유일 링크 자재(un-split parent)
ACTIVE_SIZ = ("SIZ_000059", "SIZ_000060")  # 상품행 del_yn=N 활성 사이즈


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

    grps = by_prd("t_prd_product_option_groups.csv")

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

    # COMP_STK_PRINT 행수 + 063 소재(162) 커버 (사이즈별)
    stk_rows = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == "COMP_STK_PRINT"]
    stk_total = len(stk_rows)
    cover = {m: sum(1 for r in stk_rows if r["mat_cd"] == m) for m in (MAT_063,)}
    cover_siz = {}
    for s in ("SIZ_000058",) + ACTIVE_SIZ:
        cover_siz[s] = sum(1 for r in stk_rows if r["mat_cd"] == MAT_063 and r["siz_cd"] == s)
    coat_axis = sorted({(r["coat_side_cnt"] or "(공백)") for r in stk_rows if r["mat_cd"] == MAT_063})
    paper_rows = [r for r in rd("t_prc_component_prices.csv")
                  if r["comp_cd"] == "COMP_PAPER" and r["mat_cd"] == MAT_063]

    # 260702 권위 연당가 diff 전사 (투명스=백색후지·063이 쓰는 소재만)
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
        "processes": procs, "plates": plates, "option_group_rows": len(grps),
        "formulas": fbind, "wiring": wiring,
        "stk_total": stk_total, "cover": cover, "cover_siz": cover_siz,
        "coat_axis": coat_axis, "paper_rows": len(paper_rows),
        "bundle_qtys": len(by_prd("t_prd_product_bundle_qtys.csv")),
        "addons": len(by_prd("t_prd_product_addons.csv")),
        "constraints": len(by_prd("t_prd_product_constraints.csv")),
        "sets": len(by_prd("t_prd_product_sets.csv")),
        "options": len(by_prd("t_prd_product_options.csv")),
        "option_items": len(by_prd("t_prd_product_option_items.csv")),
        "authority": {"투명스": authority.get("투명스", [])},
    }


def _tb(what, src="live"):
    origin = SNAP_ID if src == "live" else "huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {origin} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000063"))
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['del_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | main_cat_yn |")
    o.append("|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes PRD_000063"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 상품행 del | 마스터 del | note |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt_yn"]} | {r["del_yn"]} | {r["mst_del"]} | {r["note"]} |')

    o.append("\n### 자재 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials PRD_000063"))
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
    o.append(_tb("t_prd_product_processes+t_proc_processes PRD_000063"))
    o.append("| proc_cd | 공정명 | 상위 | mand | del |")
    o.append("|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr"] or ""} | {r["mand"]} | {r["del_yn"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_plate_sizes PRD_000063"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["opt"] if r["opt"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del_yn"]} | {r["note"]} |')

    o.append("\n### CPQ 옵션 레이어 + 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_option_groups/options/option_items/bundle_qtys/addons/constraints/sets PRD_000063"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| option_groups(CPQ 옵션그룹) | {d['option_group_rows']} |")
    o.append(f"| options(옵션값) | {d['options']} |")
    o.append(f"| option_items(옵션아이템 ref_dim) | {d['option_items']} |")
    o.append(f"| bundle_qtys(묶음수) | {d['bundle_qtys']} |")
    o.append(f"| addons(추가상품) | {d['addons']} |")
    o.append(f"| constraints(제약규칙) | {d['constraints']} |")
    o.append(f"| sets(셋트 구성원) | {d['sets']} |")

    o.append("\n### 가격 배선 PRF_STK_FIXED (전사·완제품가 격자)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    cs = d["cover_siz"]
    o.append(f"\n> COMP_STK_PRINT 단가행(완제품가) 총 {d['stk_total']}행 · 063 소재 MAT_000162 커버={d['cover'][MAT_063]}행 · "
             f"활성 사이즈 SIZ_000059={cs['SIZ_000059']}행·SIZ_000060={cs['SIZ_000060']}행(각 격자 충전=silent-0 아님)·"
             f"삭제 SIZ_000058={cs['SIZ_000058']}행(상품행 del_yn=Y 정합) · coat_side_cnt={d['coat_axis']}(코팅축 없음=투명 무코팅) · "
             f"COMP_PAPER(연당가/절가)에 MAT_000162={d['paper_rows']}행(=원가 미저장).")

    o.append("\n### ★260702 권위 연당가 diff (전사·재사용 dual material-MAT_000162 authority_value 근거)\n")
    o.append(_tb("출력소재(IMPORT) 투명스(백색후지) — 063이 쓰는 소재만", src="pdiff"))
    o.append("| 소재키 | 컬럼 | 260527(before) | 260702(after) |")
    o.append("|---|---|---|---|")

    def _san(v):
        return (v or "(신규)").replace("|", " ⁄ ")
    for r in d["authority"]["투명스"]:
        o.append(f'| 투명스 | {r["column"]} | {_san(r["before"])} | {_san(r["after"])} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(HERE, "cache"), exist_ok=True)
        pth = os.path.join(HERE, "cache", "transcribed-sticker063-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
