#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 반칼 자유형 홀로그램스티커 PRD_000054 전용.

transcribe_product_051.py(썬캡·완칼/원자합산형) 패턴을 계승하되, 스티커 특성에 맞춘다:
  - 가격 = 완제품가 고정가 룩업(원자합산형 아님). PRF_STK_FIXED → COMP_STK_PRINT 단일 구성요소.
  - 완제품가 격자 = COMP_STK_PRINT(t_prc_component_prices) use_dims=[siz_cd, mat_cd, min_qty].
    → MAT_000163(홀로그램) 몫 행수·siz_cd 목록·coat_side_cnt를 스크립트로 집계(값 자체는 KB 밖·D-18).
  - 자재 = MAT_000163(홀로그램스티커·MAT_TYPE.11)+child MAT_000590. 연당가는 라이브 미저장(§4-B).
  - ★연당가 양면(defect) 전사: 260702 price-diff(홀로스 연당가/국4절) vs 라이브 t_mat_materials(가격컬럼 없음).
  - 공정 = PROC_000054(반칼 Kiss Cut·mand=N)+PROC_000008(화이트인쇄 underbase·mand=N).
  - 인쇄옵션 = POPT_000001(단면·앞 CMYK4도/뒤 인쇄안함).
  - 판형 = SIZ_000521(46계열 OUTPUT_PAPER_TYPE.02·330x470). 종이류라 판형 유효.
  - CPQ 옵션그룹/제약/추가상품/묶음수 = 0행(정직 표기).

사용:  python3 transcribe_product_054.py            # stdout에 markdown 블록
       python3 transcribe_product_054.py --json     # cache/transcribed-054-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
       _workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv (연당가 diff)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
DIFF = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000054"
MAT = "MAT_000163"
SELF = "transcribe_product_054.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd(name):
    return active([r for r in rd(name) if r["prd_cd"] == PRD])


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "?"


def price_grid_summary():
    """COMP_STK_PRINT × MAT_000163 완제품가 격자 요약(행수·siz_cd·coat). 값 자체는 전사 안 함(D-18)."""
    per_siz = {}
    total = 0
    coats = set()
    with open(os.path.join(SNAP, "t_prc_component_prices.csv"), encoding="utf-8") as f:
        for r in csv.DictReader(f):
            if r["comp_cd"] == "COMP_STK_PRINT" and r["mat_cd"] == MAT:
                per_siz[r["siz_cd"]] = per_siz.get(r["siz_cd"], 0) + 1
                coats.add(r.get("coat_side_cnt") or "(공백)")
                total += 1
    return {"total_rows": total, "per_siz": dict(sorted(per_siz.items())),
            "coat_side_cnt_values": sorted(coats)}


def yeondangga_diff():
    """260702 price-diff에서 홀로스(홀로그램) 연당가/국4절/구매정보 변경 행 전사."""
    rows = []
    with open(DIFF, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            if r["sheet"].startswith("출력소재") and r["key"] == "홀로스":
                rows.append({"column": r["column"], "cell": r["cell_ref"],
                             "before": r["before"], "after": r["after"]})
    return rows


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc_nm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = by_prd("t_prd_product_categories.csv")
    psizes = by_prd("t_prd_product_sizes.csv")
    mats = by_prd("t_prd_product_materials.csv")
    popts = by_prd("t_prd_product_print_options.csv")
    procs = by_prd("t_prd_product_processes.csv")
    plates = by_prd("t_prd_product_plate_sizes.csv")
    bqty = by_prd("t_prd_product_bundle_qtys.csv")
    addons = by_prd("t_prd_product_addons.csv")
    cons = by_prd("t_prd_product_constraints.csv")
    grps = by_prd("t_prd_product_option_groups.csv")

    linked_siz = sorted({r["siz_cd"] for r in psizes} | {r["siz_cd"] for r in plates})
    size_dims = {s: {"siz_nm": sizes[s]["siz_nm"],
                     "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                     "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                     "master_del_yn": sizes[s].get("del_yn") or "N",
                     "tags": sizes[s].get("tags") or "",
                     "note": sizes[s].get("note") or ""}
                 for s in linked_siz if s in sizes}

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    wiring = {}
    frm_master = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 자재 마스터 + 자식(부모=MAT_000163)
    mat_children = [r for r in active(list(mat.values())) if r.get("upr_mat_cd") == MAT]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF,
                 "diff_source": "huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv"},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd") or "(root)",
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "weight": mat.get(r["mat_cd"], {}).get("weight"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "material_children": [{"mat_cd": r["mat_cd"], "mat_nm": r["mat_nm"],
                               "weight": r.get("weight"), "reg_dt": r.get("reg_dt")}
                              for r in mat_children],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")} for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc_nm.get(r["proc_cd"], {}).get("proc_nm"),
                       "upr_proc_cd": proc_nm.get(r["proc_cd"], {}).get("upr_proc_cd") or "",
                       "note": proc_nm.get(r["proc_cd"], {}).get("note") or "",
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "output_file_typ": r.get("output_file_typ"),
                    "dflt_plt_yn": r["dflt_plt_yn"], "note": r.get("note") or ""} for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons, "option_groups": grps,
        "formulas": [{"frm_cd": f, "frm_nm": frm_master.get(f, {}).get("frm_nm"),
                      "use_yn": frm_master.get(f, {}).get("use_yn"),
                      "note": frm_master.get(f, {}).get("note")} for f in fbind],
        "wiring": wiring,
        "price_grid": price_grid_summary(),
        "yeondangga_diff": yeondangga_diff(),
    }


def _tb(what, src="snap"):
    if src == "diff":
        return (f"<!-- transcribed-by: _meta/scripts/{SELF} from "
                f"huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv {what} @ {STAMP} -->")
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000054"))
    p = d["product"]
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | main_cat_yn |")
    o.append("|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 치수 (전사·주문 링크된 사이즈 + 판형)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes (linked+plate)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 마스터 del_yn | tags | note |")
    o.append("|---|---|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["master_del_yn"]} | {v["tags"]} | {v["note"]} |')

    o.append("\n### 자재 (전사)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 평량(weight) | usage_cd | dflt |")
    o.append("|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["weight"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')
    if d["material_children"]:
        o.append("\n자식(부모=MAT_000163):")
        o.append("| mat_cd | 이름 | 평량 | 등록일 |")
        o.append("|---|---|---|---|")
        for r in d["material_children"]:
            o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["weight"]} | {r["reg_dt"]} |')

    o.append("\n### ★연당가 양면(defect) — 260702 권위 vs 라이브 현재값 (전사)\n")
    o.append(_tb("홀로스(홀로그램) 연당가/국4절/구매정보", src="diff"))
    o.append("| 항목(column) | 셀 | 260527(before) | 260702(after·권위) |")
    o.append("|---|---|---|---|")
    for r in d["yeondangga_diff"]:
        o.append(f'| {r["column"]} | {r["cell"]} | {r["before"]} | {r["after"]} |')
    o.append("\n> ★라이브 현재값: `t_mat_materials`에 가격(연당가/국4절) 컬럼 없음 + `COMP_PAPER`에 MAT_000163 **0행** "
             "→ 연당가는 라이브 스티커 가격사슬에 **저장 안 됨**(원가 미반영). 평량·명은 일치(50·홀로그램스티커). "
             "이 표 = 연당가 재적재 워크리스트(§4-D·[[matcost-054-hologram]]).")

    o.append("\n### 인쇄옵션 (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 부모공정 | mand | note |")
    o.append("|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr_proc_cd"]} | {r["mand_proc_yn"]} | {r["note"]} |')

    o.append("\n### 판형 (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | note |")
    o.append("|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt_plt_yn"]} | {r["note"]} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/constraints/option_groups"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")

    o.append("\n### 가격 배선 PRF_STK_FIXED (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| frm_cd | frm_nm | use_yn |")
    o.append("|---|---|---|")
    for f in d["formulas"]:
        o.append(f'| {f["frm_cd"]} | {f["frm_nm"]} | {f["use_yn"]} |')
    o.append("\n| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for f in d["formulas"]:
        for r in d["wiring"][f["frm_cd"]]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 완제품가 격자 요약 COMP_STK_PRINT × MAT_000163 (전사·행수만·값은 KB 밖 D-18)\n")
    o.append(_tb("t_prc_component_prices COMP_STK_PRINT mat_cd=MAT_000163"))
    g = d["price_grid"]
    o.append(f"- 총 행수: **{g['total_rows']}** · coat_side_cnt 값: {g['coat_side_cnt_values']} (홀로그램=코팅축 없음)")
    o.append("| siz_cd | 수량구간(min_qty) 행수 |")
    o.append("|---|---|")
    for s, n in g["per_siz"].items():
        o.append(f"| {s} | {n} |")
    o.append("\n> 격자 키=(siz_cd, mat_cd, min_qty)·값=완제품 시트가격(출력+가공 포함). 값 절대치는 `evaluate_price` 권위(D-18). "
             "주문 링크 사이즈(SIZ_000170·SIZ_000520)는 격자에 실재 → 가격 경로 성립. 나머지 siz_cd는 타 스티커 상품 공유 격자.")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-054-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
