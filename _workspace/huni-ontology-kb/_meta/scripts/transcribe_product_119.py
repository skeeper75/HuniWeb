#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 아트페이퍼포스터 PRD_000119 전용.

★실사(silsa) 첫 상품군 파일럿 — 면적매트릭스형(area-matrix). transcribe_product_051.py
패턴을 계승하되 실사 특성에 맞춘다(pack-silsa.md):
  - ★가격 = 면적매트릭스형(포스터사인 [가로×세로] 셀단가). use_dims=[siz_width, siz_height].
    off-grid=한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행). 단가행 39셀 = D-22 접기(행수만·값 나열 아님).
  - 인쇄옵션 0행·공정 0행 = 실사 정당(도수 컬럼 없음·인쇄방식 대형 잉크젯 단일·po=0·pack §3.3/§3.7).
  - 판형(plate) = 파일사양(output_file_typ=JPG·output_paper_typ_cd 공백) — ★종이류 절수 판형 아님
    (실사=비종이류 대형 롤·T-7). fn_best_plate/fn_calc_pansu 판걸이수 로직 적용 금지.
  - nonspec_yn=Y — 비규격 연속범위(가로 200~900·세로 200~3000·incr 200) 입력 UX. ★가격격자 아님
    (pack §3.2·유효 가격 권위=면적매트릭스 셀).
  - 사이즈 = 이산 규격 SIZ 3행(A3/A2/A1). ★SIZ_000293(A1) 마스터 del_yn 실측(양면 신호).
  - 자재 = MAT_000177 매트지(MAT_TYPE.08 실사소재·아트페이퍼=매트지 소재·USAGE.07 단일).
  - 카테고리 = CAT_000004 포스터(main Y) + CAT_000314 아트포스터(leaf·신규 노드).
  - constraints/option_groups/addons/bundle_qtys = 0행(119는 constraints 7상품 목록에 없음·pack §1.1).

사용:  python3 transcribe_product_119.py            # stdout에 markdown 블록
       python3 transcribe_product_119.py --json     # cache/transcribed-119-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000119"
SELF = "transcribe_product_119.py"


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


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc_nm = {r["proc_cd"]: r.get("proc_nm") for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    mat_nm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat_nm = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    frm_nm = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}

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

    # 사이즈: 상품 사이즈(재단 규격 SIZ) — 마스터 del_yn 함께 전사(양면 신호)
    prod_sizes = []
    for r in psizes:
        s = sizes.get(r["siz_cd"], {})
        prod_sizes.append({"siz_cd": r["siz_cd"], "siz_nm": s.get("siz_nm"),
                           "work": f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}',
                           "cut": f'{_mm(s.get("cut_width"))}x{_mm(s.get("cut_height"))}',
                           "dflt_yn": r.get("dflt_yn"), "disp_seq": r.get("disp_seq"),
                           "master_del_yn": s.get("del_yn", "?"),
                           "tags": s.get("tags") or ""})

    # 카테고리(부모 체인 라벨)
    cat_rows = []
    for r in cats:
        c = cat_nm.get(r["cat_cd"], {})
        upr = c.get("upr_cat_cd") or ""
        cat_rows.append({"cat_cd": r["cat_cd"], "cat_nm": c.get("cat_nm"),
                         "cat_lvl": c.get("cat_lvl"), "upr": upr,
                         "main_cat_yn": r.get("main_cat_yn")})

    # 가격 배선: PRF_POSTER_ARTPAPER → COMP_POSTER_ARTPAPER_MATTE (면적매트릭스)
    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    wiring = {}
    comp_rows_count = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "comp_typ_cd": pcomp.get(r["comp_cd"], {}).get("comp_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 단가행 접기(D-22): comp별 셀 행수 + 면적매트릭스 (가로,세로) 순서쌍 개수 요약 (값 나열 아님)
    cp = rd("t_prc_component_prices.csv")
    for frm in fbind:
        for w in wiring[frm]:
            cc = w["comp_cd"]
            cells = [r for r in cp if r["comp_cd"] == cc]
            wh = sorted({(r.get("siz_width") or "", r.get("siz_height") or "") for r in cells})
            ws = [float(p[0]) for p in wh if p[0]]
            hs = [float(p[1]) for p in wh if p[1]]
            comp_rows_count[cc] = {"total_rows": len(cells),
                                   "distinct_wh_pairs": len(wh),
                                   "w_min": min(ws) if ws else "",
                                   "w_max": max(ws) if ws else "",
                                   "h_min": min(hs) if hs else "",
                                   "h_max": max(hs) if hs else ""}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn",
                     "nonspec_yn", "nonspec_width_min", "nonspec_width_max", "nonspec_width_incr",
                     "nonspec_height_min", "nonspec_height_max", "nonspec_height_incr"]},
        "categories": cat_rows,
        "prod_sizes": prod_sizes,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"]}
                          for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc_nm.get(r["proc_cd"]),
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "output_file_typ": r.get("output_file_typ"),
                    "dflt_plt_yn": r["dflt_plt_yn"], "note": r.get("note") or ""} for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons, "option_groups": grps,
        "formulas": fbind,
        "formula_meta": {f: {"frm_nm": frm_nm.get(f, {}).get("frm_nm"),
                             "use_yn": frm_nm.get(f, {}).get("use_yn"),
                             "note": frm_nm.get(f, {}).get("note")} for f in fbind},
        "wiring": wiring, "comp_rows": comp_rows_count,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량·비규격범위 (전사)\n")
    o.append(_tb("t_prd_products PRD_000119"))
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | nonspec_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['nonspec_yn']} |")
    o.append("\n> 비규격(nonspec) 연속범위 — ★입력 UX 한계일 뿐 가격격자 아님(pack §3.2·가격 권위=면적매트릭스 셀):\n")
    o.append("| 축 | min(mm) | max(mm) | incr(mm) |")
    o.append("|---|---|---|---|")
    o.append(f"| 가로(width) | {_mm(p['nonspec_width_min'])} | {_mm(p['nonspec_width_max'])} | {_mm(p['nonspec_width_incr'])} |")
    o.append(f"| 세로(height) | {_mm(p['nonspec_height_min'])} | {_mm(p['nonspec_height_max'])} | {_mm(p['nonspec_height_incr'])} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | lvl | 상위 | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["cat_lvl"]} | {r["upr"] or "(root)"} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 — 이산 규격(재단) (전사)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes PRD_000119"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["prod_sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["cut"]} | {r["dflt_yn"]} | {r["disp_seq"]} | {r["master_del_yn"]} |')

    o.append("\n### 자재 (전사)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | usage_cd | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 판형(파일사양) (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes PRD_000119"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | note |")
    o.append("|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt_plt_yn"]} | {r["note"]} |')

    o.append("\n### 얕은/미보유 축 (전사·행수 실측)\n")
    o.append(_tb("t_prd_product_print_options/processes/bundle_qtys/addons/constraints/option_groups"))
    o.append("| 축 | 행수 | 실사 정당성 |")
    o.append("|---|---|---|")
    o.append(f"| print_options(도수/인쇄방식) | {len(d['print_options'])} | 실사=도수 컬럼 없음·대형 잉크젯 풀컬러 단일(pack §3.3/§3.7) |")
    o.append(f"| processes(공정) | {len(d['processes'])} | 아트페이퍼=순수 출력물(봉제/타공/족자 후가공 없음) |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} | 면적매트릭스는 수량축 없음(셀=완제품 통가격·pack §3.4) |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} | 부속붙는 8상품 아님(단품) |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} | 119는 constraints 7상품 목록 밖(118/120/121/122/124/125/139만·pack §1.1) |")
    o.append(f"| option_groups(CPQ) | {len(d['option_groups'])} | 손님 구성축 없음(소재/규격 고정·일반현수막138만 옵션 레이어) |")

    o.append("\n### 가격 배선 — 면적매트릭스 (전사·골든 스냅샷 20260702_1119)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| frm_cd | disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {frm} | {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 단가행 접기 — 면적매트릭스 셀 요약 (D-22·값 나열 아님) (전사)\n")
    o.append(_tb("t_prc_component_prices (comp_cd별 셀 행수+가로세로 순서쌍 범위·값 미나열)"))
    o.append("| comp_cd | 단가행수 | (가로,세로) 순서쌍 수 | 가로 범위(mm) | 세로 범위(mm) |")
    o.append("|---|---|---|---|---|")
    for cc, m in d["comp_rows"].items():
        o.append(f'| {cc} | {m["total_rows"]} | {m["distinct_wh_pairs"]} | {_mm(m["w_min"])}~{_mm(m["w_max"])} | {_mm(m["h_min"])}~{_mm(m["h_max"])} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-119-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
