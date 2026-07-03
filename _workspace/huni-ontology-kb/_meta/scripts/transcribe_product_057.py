#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 대형 자유형 스티커 PRD_000057 전용.

transcribe_product_051.py(썬캡) 패턴을 계승하되, 스티커 파일럿 특성에 맞춘다:
  - 가격 모델 = 완제품가(고정가 by siz×mat×qty) 룩업 = PRF_STK_FIXED → COMP_STK_PRINT
    (원자합산형 아님·pack §3.10). use_dims=[siz_cd, mat_cd, min_qty].
  - ★완제품가 격자 샘플 = 057 등록 사이즈(SIZ_000199 400x600) × 유포(MAT_000153) 수량구간 단가행.
    이 표는 KB "값 노드"가 아니라 use_dims 실증(값 계산=evaluate_price 권위·D-18). retail 무변경(260702) → 양면 아님.
  - CPQ 옵션그룹/옵션/아이템 = 0행 → 관련 섹션 생략.
  - bundle_qtys/addons/constraints/sets = 0행 → 미보유 축 섹션에서 정직 표기.
  - 카테고리 2행(CAT_000002 스티커=주 main_cat_yn=Y·CAT_000309 자유형스티커=부) → main 표기.
  - 사이즈 = t_prd_product_sizes SIZ_000199(400x600) 1행(= 판형 siz_cd와 동일·free-form 최대 바운딩).
  - 판형(plate) = SIZ_000199·output_paper_typ_cd=OUTPUT_PAPER_TYPE.03(기타)·note "파일사양"(free-form 업로드 규격).
  - 자재 = MAT_000153(유포스티커·MAT_TYPE.11 스티커 정답유형·USAGE.07 단일 슬롯·비코팅).
  - 인쇄옵션 = POPT_000001(단면·front CLR_000005 CMYK4·back CLR_000001 인쇄안함) 단일.
  - 공정 = PROC_000053(완칼 die-cut·모양 input·mand_proc_yn=N — 완제품가에 출력+가공 포함이라 base print 공정 미필요).
  - ★use_yn=Y·file_upload_yn=Y·editor_yn=N (자유형=고객 업로드 칼선).
  - ★연당가 대조: MAT_000153 유포는 260702 연당가 diff에 미포함(변경 4소재=투명162/홀로163/크라프164/투명후지372).
    live 평량/규격 = authority(import row76 평량80·330x470) 일치 → 057 소재는 양면 defect 대상 아님(§4-D false-defect 회피).

사용:  python3 transcribe_product_057.py            # stdout에 markdown 블록
       python3 transcribe_product_057.py --json     # cache/transcribed-057-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000057"
SELF = "transcribe_product_057.py"


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
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
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
    # 셋트 부모/구성원(t_prd_product_sets)
    setrows = rd("t_prd_product_sets.csv")
    sets_parent = active([r for r in setrows if r["prd_cd"] == PRD])
    sets_member = active([r for r in setrows if r.get("sub_prd_cd") == PRD])

    linked_siz = sorted({r["siz_cd"] for r in psizes} | {r["siz_cd"] for r in plates})
    size_dims = {s: {"siz_nm": sizes[s]["siz_nm"],
                     "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                     "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                     "impos_yn": sizes[s].get("impos_yn") or "",
                     "tags": sizes[s].get("tags") or "",
                     "note": sizes[s].get("note") or ""}
                 for s in linked_siz if s in sizes}

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    frm_master = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "comp_typ_cd": pcomp.get(r["comp_cd"], {}).get("comp_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 완제품가 격자 샘플 = COMP_STK_PRINT × 057 등록 사이즈(SIZ_000199) × 유포(MAT_000153)
    reg_siz = [r["siz_cd"] for r in psizes]  # 057 등록 사이즈
    reg_mat = [r["mat_cd"] for r in mats]    # 057 등록 자재
    cp = rd("t_prc_component_prices.csv")
    grid = []
    for r in cp:
        if r["comp_cd"] != "COMP_STK_PRINT":
            continue
        if r["siz_cd"] in reg_siz and r["mat_cd"] in reg_mat:
            grid.append({"siz_cd": r["siz_cd"], "mat_cd": r["mat_cd"],
                         "min_qty": r["min_qty"], "unit_price": r["unit_price"],
                         "note": r.get("note") or ""})
    grid.sort(key=lambda x: (x["siz_cd"], x["mat_cd"], int(x["min_qty"] or 0)))
    # 같은 등록사이즈 격자에 존재하는 (057 미등록) 코팅/변형 mat_cd — 정직 표기용
    grid_variants = {}
    for r in cp:
        if r["comp_cd"] == "COMP_STK_PRINT" and r["siz_cd"] in reg_siz:
            grid_variants.setdefault(r["mat_cd"], 0)
            grid_variants[r["mat_cd"]] += 1

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd"),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes_linked": [r["siz_cd"] for r in psizes],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "width": mat.get(r["mat_cd"], {}).get("width"),
                       "height": mat.get(r["mat_cd"], {}).get("height"),
                       "weight": mat.get(r["mat_cd"], {}).get("weight"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "opt_id": r["opt_id"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")} for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
                       "prcs_dtl_opt": proc.get(r["proc_cd"], {}).get("prcs_dtl_opt") or "",
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "output_file_typ": r.get("output_file_typ"),
                    "dflt_plt_yn": r["dflt_plt_yn"], "note": r.get("note") or ""} for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons, "option_groups": grps,
        "sets_parent": sets_parent, "sets_member": sets_member,
        "formulas": fbind, "frm_master": {f: frm_master.get(f, {}) for f in fbind},
        "wiring": wiring, "grid": grid, "grid_variants": grid_variants,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000057"))
    p = d["product"]
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 상위 | main_cat_yn |")
    o.append("|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"] or "-"} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 치수 (전사)\n")
    o.append(_tb("t_siz_sizes (linked+plate)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | impos_yn | tags | note |")
    o.append("|---|---|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["impos_yn"]} | {v["tags"]} | {v["note"]} |')

    o.append("\n### 자재 (전사)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 규격(w×h mm) | 평량(g) | usage_cd | dflt |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {_mm(r["width"])}x{_mm(r["height"])} | {_mm(r["weight"])} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 인쇄옵션 (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | mand | prcs_dtl_opt(inputs) |")
    o.append("|---|---|---|---|")
    for r in d["processes"]:
        dtl = (r["prcs_dtl_opt"] or "").replace("\n", " ")
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} | `{dtl}` |')

    o.append("\n### 판형 (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | note |")
    o.append("|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt_plt_yn"]} | {r["note"]} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/constraints/option_groups/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")
    o.append(f"| sets(셋트 구성원) | {len(d['sets_member'])} |")

    o.append("\n### 가격 배선 PRF_STK_FIXED (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 완제품가 격자 샘플 — 등록 사이즈×유포×수량구간 (전사)\n")
    o.append(_tb("t_prc_component_prices COMP_STK_PRINT (siz_cd∈057등록 · mat_cd∈057등록)"))
    o.append("| siz_cd | mat_cd | min_qty | unit_price | note |")
    o.append("|---|---|---|---|---|")
    for r in d["grid"]:
        o.append(f'| {r["siz_cd"]} | {r["mat_cd"]} | {r["min_qty"]} | {r["unit_price"]} | {r["note"]} |')

    o.append("\n### 완제품가 격자의 소재 변형 (057 등록 사이즈 격자에 존재·057 미등록 포함) (전사)\n")
    o.append(_tb("t_prc_component_prices COMP_STK_PRINT (siz_cd∈057등록) mat_cd별 행수"))
    o.append("| mat_cd | 격자행수 | 057 등록? |")
    o.append("|---|---|---|")
    reg_mat = {r["mat_cd"] for r in d["materials"]}
    for m, c in sorted(d["grid_variants"].items()):
        o.append(f'| {m} | {c} | {"Y" if m in reg_mat else "N"} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-057-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
