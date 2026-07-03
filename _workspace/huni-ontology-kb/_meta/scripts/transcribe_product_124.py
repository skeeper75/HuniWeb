#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 린넨패브릭포스터 PRD_000124 전용 (실사·area-matrix).

transcribe_product_051.py(썬캡) 패턴을 계승하되, 실사 파일럿 특성에 맞춘다:
  - ★가격모델=면적매트릭스: COMP_POSTER_LINEN_FABRIC use_dims=[siz_width,siz_height]·52셀(D-22 접기=행수만).
    + CPQ 마감(봉제) 옵션 단가 COMP_POSTEROPT_LINEN_FINISH use_dims=[opt_cd,min_qty]·5행.
  - ★비종이류 판형 없음: t_prd_product_plate_sizes 전 행 del_yn=Y(대형 롤·output_paper_typ=.기타/공백) → 판형 0(정직 표기).
  - ★인쇄옵션(도수) 0행 = 실사는 도수축 없음(대형 잉크젯 풀컬러·pack §3.3/§3.7).
  - 사이즈 = 이산 규격 프리셋 SIZ_000542~547(A3/A2/A1 세로·가로·work 치수 공백=라벨 프리셋)
    + nonspec 연속범위(가로 200~1200·세로 200~3000·incr 200·입력 UX). 구 SIZ_000295~301은 del_yn=Y.
  - 자재 = MAT_000607 린넨(내추럴)·MAT_TYPE.05(활성). 부모 MAT_000184 린넨은 del_yn=Y(07-01 교체).
  - 공정 = PROC_000130 봉제가공(활성 mand=N). 구 PROC_000080 봉제(del_yn=Y·07-01 교체)는 param 보유+마감 옵션이 여전히 참조 → 별도 전사(mismatch 신호).
  - 제약 = RULE_001 사용자입력 치수 범위(nonspec width/height 범위·RULE_TYPE.01) 1행.
  - 옵션그룹 = OPT_000009 마감(봉제 param via OPT_REF_DIM.04→PROC_000080).

사용:  python3 transcribe_product_124.py            # stdout에 markdown 블록
       python3 transcribe_product_124.py --json     # cache/transcribed-124-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000124"
SELF = "transcribe_product_124.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd_all(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "" if v in (None, "") else "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd_all("t_prd_product_categories.csv"))
    psizes = active(by_prd_all("t_prd_product_sizes.csv"))
    mats = active(by_prd_all("t_prd_product_materials.csv"))
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs_all = by_prd_all("t_prd_product_processes.csv")   # 활성+삭제 둘 다(교체 신호)
    plates_all = by_prd_all("t_prd_product_plate_sizes.csv")
    bqty = active(by_prd_all("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd_all("t_prd_product_addons.csv"))
    cons = active(by_prd_all("t_prd_product_constraints.csv"))
    grps = active(by_prd_all("t_prd_product_option_groups.csv"))
    items = active(by_prd_all("t_prd_product_option_items.csv"))

    def sd(s):
        r = sizes.get(s, {})
        ww, wh = _mm(r.get("work_width")), _mm(r.get("work_height"))
        work = f"{ww}x{wh}" if (ww or wh) else "(공백·라벨전용)"
        return {"siz_nm": r.get("siz_nm", "?"), "work": work, "tags": r.get("tags") or ""}
    size_dims = {r["siz_cd"]: sd(r["siz_cd"]) for r in psizes}

    # 가격 배선
    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    # component_prices 행수(D-22 접기 — 셀 열거 금지, 카운트만)
    cprows = {}
    for r in rd("t_prc_component_prices.csv"):
        cprows[r["comp_cd"]] = cprows.get(r["comp_cd"], 0) + 1
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm"),
                        "n_rows": cprows.get(r["comp_cd"], 0)} for r in rows]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn",
                     "nonspec_yn", "nonspec_width_min", "nonspec_width_max", "nonspec_width_incr",
                     "nonspec_height_min", "nonspec_height_max", "nonspec_height_incr"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd") or "",
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd") or "",
                       "mand_proc_yn": r["mand_proc_yn"], "del_yn": r.get("del_yn", "N"),
                       "has_param": "Y" if (proc.get(r["proc_cd"], {}).get("prcs_dtl_opt") or "") else "N"}
                      for r in procs_all],
        "plates_active": active(plates_all), "plates_total": len(plates_all),
        "bundle_qty": bqty, "addons": addons,
        "constraints": [{"rule_cd": r["rule_cd"], "rule_nm": r["rule_nm"],
                         "rule_typ_cd": r["rule_typ_cd"], "use_yn": r["use_yn"]} for r in cons],
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                           "max_sel": r["max_sel_cnt"], "mand_yn": r["mand_yn"],
                           "note": r.get("note") or ""} for r in grps],
        "option_items": [{"opt_cd": r["opt_cd"], "item_seq": r["item_seq"],
                          "ref_dim_cd": r["ref_dim_cd"], "ref_key1": r["ref_key1"],
                          "dtl_opt": r.get("dtl_opt") or ""} for r in items],
        "formulas": fbind, "wiring": wiring,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량·비규격범위 (전사)\n")
    o.append(_tb("t_prd_products PRD_000124"))
    o.append("| prd_typ | min | max | incr | unit | file_up | editor | use_yn | nonspec |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | "
             f"{p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['nonspec_yn']} |")
    o.append("\n" + _tb("t_prd_products PRD_000124 nonspec 범위"))
    o.append("| 축 | min(mm) | max(mm) | incr(mm) |")
    o.append("|---|---|---|---|")
    o.append(f"| 가로(width) | {_mm(p['nonspec_width_min'])} | {_mm(p['nonspec_width_max'])} | {_mm(p['nonspec_width_incr'])} |")
    o.append(f"| 세로(height) | {_mm(p['nonspec_height_min'])} | {_mm(p['nonspec_height_max'])} | {_mm(p['nonspec_height_incr'])} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | main_cat_yn |")
    o.append("|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 프리셋 (전사·이산 규격·work 치수 공백=라벨 프리셋)\n")
    o.append(_tb("t_prd_product_sizes(활성)+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | tags |")
    o.append("|---|---|---|---|")
    for s, v in sorted(d["size_dims"].items()):
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["tags"]} |')

    o.append("\n### 자재 (전사)\n")
    o.append(_tb("t_prd_product_materials(활성)+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | upr_mat | usage_cd | dflt |")
    o.append("|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["upr_mat_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 공정 (전사·활성+삭제 — 07-01 교체 신호)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | upr_proc | mand | del_yn | param보유 |")
    o.append("|---|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr_proc_cd"]} | {r["mand_proc_yn"]} | {r["del_yn"]} | {r["has_param"]} |')

    o.append("\n### 판형·인쇄옵션 (전사·★실사 비종이류=판형 0·도수축 0)\n")
    o.append(_tb("t_prd_product_plate_sizes+t_prd_product_print_options"))
    o.append("| 축 | 활성행수 | 비고 |")
    o.append("|---|---|---|")
    o.append(f'| plate_sizes(판형) | {len(d["plates_active"])} | 전 {d["plates_total"]}행 del_yn=Y(대형 롤·비종이류·pack §3.8·T-7) |')
    o.append(f'| print_options(도수/인쇄방식) | {len(d["print_options"])} | 실사=대형 잉크젯 풀컬러·도수 컬럼 없음(pack §3.3/§3.7) |')

    o.append("\n### 제약·옵션그룹·미보유 축 (전사)\n")
    o.append(_tb("t_prd_product_constraints/option_groups/option_items/bundle_qtys/addons"))
    o.append("| 축 | 행수 | 비고 |")
    o.append("|---|---|---|")
    for r in d["constraints"]:
        o.append(f'| constraints | 1 | {r["rule_cd"]} {r["rule_nm"]}({r["rule_typ_cd"]}·use_yn={r["use_yn"]}) |')
    if not d["constraints"]:
        o.append("| constraints | 0 | — |")
    for r in d["option_groups"]:
        o.append(f'| option_group | 1 | {r["opt_grp_cd"]} {r["opt_grp_nm"]}({r["sel_typ_cd"]}·min{r["min_sel"]}/max{r["max_sel"]}·mand={r["mand_yn"]}) |')
    o.append(f'| option_items(마감) | {len(d["option_items"])} | 봉제 param via OPT_REF_DIM.04→PROC_000080 |')
    o.append(f'| bundle_qtys | {len(d["bundle_qty"])} | 상품레벨 수량규칙만 |')
    o.append(f'| addons | {len(d["addons"])} | 부속 미적재(정직) |')

    o.append("\n### 마감 옵션 아이템 (전사·finishing)\n")
    o.append(_tb("t_prd_product_option_items(활성)"))
    o.append("| opt_cd | item_seq | ref_dim_cd | ref_key1 | dtl_opt(유형) |")
    o.append("|---|---|---|---|---|")
    for r in sorted(d["option_items"], key=lambda x: (x["opt_cd"], x["item_seq"])):
        dt = r["dtl_opt"].replace("|", "/") if r["dtl_opt"] else ""
        o.append(f'| {r["opt_cd"]} | {r["item_seq"]} | {r["ref_dim_cd"]} | {r["ref_key1"]} | {dt} |')

    o.append("\n### 가격 배선 PRF_POSTER_LINEN (전사·★면적매트릭스+마감옵션·D-22 접기=행수)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components(행수)"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims | 단가행수 |")
    o.append("|---|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | '
                     f'{r["comp_nm"]} | `{r["use_dims"]}` | {r["n_rows"]} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-124-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
