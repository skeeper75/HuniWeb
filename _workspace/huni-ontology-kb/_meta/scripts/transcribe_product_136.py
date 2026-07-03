#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000136 PET배너 (실사·★고정가형[siz_cd 룩업]+거치대 가산·D-9·§4·[HARD] LLM 손전사 금지).

PET배너(136)의 규격 사이즈(600x1800 단일)·본체 자재(PET)·거치대 자재(실내/실외)·
코팅/실사가공 공정(07-01 재키잉)·수량규칙·고정가 SHAPE(값 아님·차원·행수·siz_cd 셀만)·
거치대 가산 SHAPE(mat_cd 키·행수)·옵션그룹 3(코팅/가공/거치대)·orphan 거치대 구성요소를 결정론 전사한다.
★131 프레임리스우드액자(단순 고정가)와 달리 136은 **고정가 본체 + 거치대 가산(mat_cd)** 2 구성요소 공식이다.
★07-01 재키잉: 라미(014/015)→코팅(115/116)·타공(079)→실사가공(135)·PET 부모(178)→자식(601)·우드거치대(223 del)→실내/실외(409/410).
★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
  고정가/가산은 SHAPE(셀 수·수량축 충전·격자완전·orphan 존재)만 확인한다.
★실사=비종이류(대형 롤) → 판형(plate_size)은 파일사양 placeholder일 뿐 종이류 판형 아님(전사 제외·T-7).

사용:  python3 transcribe_product_136.py            # stdout markdown 블록
       python3 transcribe_product_136.py --json     # cache/transcribed-136-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000136"
SIZES_ACTIVE = ["SIZ_000321"]                              # 600x1800mm (product_sizes del_yn=N·단일)
PLATE_PLACEHOLDER = ["SIZ_000321"]                         # 파일사양 placeholder(JPG·비종이류·판형 아님)
MATS_ACTIVE = ["MAT_000601", "MAT_000409", "MAT_000410"]   # PET(body dflt)·실내용거치대·실외용거치대
MATS_SUPERSEDED = ["MAT_000178", "MAT_000223"]             # 구 PET 부모(junc del)·우드거치대(master+junc del)
PROCS_ACTIVE = ["PROC_000115", "PROC_000116", "PROC_000135"]  # 유광/무광코팅·실사가공(junc del_yn=N)
PROCS_SUPERSEDED = ["PROC_000014", "PROC_000015", "PROC_000079"]  # 구 유광/무광라미·타공(junc del_yn=Y)
FRM = "PRF_POSTER_PET_BANNER"
COMP_BODY = "COMP_POSTER_PET_BANNER"                       # 고정가 완제품가 구성요소(siz_cd 룩업)
COMP_STAND = "COMP_POSTEROPT_PET_BANNER_STAND_SEL"        # 거치대 가산 구성요소(mat_cd 룩업)
COMP_ORPHAN = ["COMP_POSTEROPT_PET_BANNER_STAND_IN",
               "COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1",
               "COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2"]   # orphan(공식 미배선·STAND_SEL로 대체)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _num(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    pcat = [r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD]
    psz = {r["siz_cd"]: r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD}
    pproc = {r["proc_cd"]: r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD}
    pmat = {r["mat_cd"]: r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD}
    pfrm = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fcomp = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FRM]
    pc = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    og = [r for r in rd("t_prd_product_option_groups.csv") if r["prd_cd"] == PRD]
    opt = [r for r in rd("t_prd_product_options.csv") if r["prd_cd"] == PRD]
    oitem = [r for r in rd("t_prd_product_option_items.csv") if r["prd_cd"] == PRD]
    addon = [r for r in rd("t_prd_product_addons.csv") if r["prd_cd"] == PRD]
    sets = [r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD]
    cprices = rd("t_prc_component_prices.csv")

    def cp_rows(comp):
        return [r for r in cprices if r["comp_cd"] == comp]

    body = cp_rows(COMP_BODY)
    stand = cp_rows(COMP_STAND)
    body_siz = sorted({r["siz_cd"] for r in body if r.get("siz_cd")})
    body_qty = sorted({r["min_qty"] for r in body if r.get("min_qty")})
    stand_mats = sorted({r["mat_cd"] for r in stand if r.get("mat_cd")})

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_136.py"},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "upr": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", ""),
                        "main": r.get("main_cat_yn", "")}
                       for r in pcat],
        "sizes_active": {s: {"siz_nm": siz[s]["siz_nm"],
                             "work": f'{_num(siz[s]["work_width"])}x{_num(siz[s]["work_height"])}',
                             "master_del_yn": siz[s].get("del_yn", ""),
                             "junc_del_yn": psz.get(s, {}).get("del_yn", "")}
                         for s in SIZES_ACTIVE if s in siz},
        "materials_active": {m: {"mat_nm": mat[m]["mat_nm"], "mat_typ_cd": mat[m]["mat_typ_cd"],
                                 "upr": mat[m].get("upr_mat_cd", ""),
                                 "dflt": pmat.get(m, {}).get("dflt_yn", ""),
                                 "junc_del_yn": pmat.get(m, {}).get("del_yn", "")}
                             for m in MATS_ACTIVE if m in mat},
        "materials_superseded": {m: {"mat_nm": mat.get(m, {}).get("mat_nm", "?"),
                                     "master_del_yn": mat.get(m, {}).get("del_yn", ""),
                                     "junc_del_yn": pmat.get(m, {}).get("del_yn", "")}
                                 for m in MATS_SUPERSEDED},
        "processes_active": {p: {"proc_nm": proc[p]["proc_nm"], "upr_proc_cd": proc[p]["upr_proc_cd"],
                                 "mand": pproc.get(p, {}).get("mand_proc_yn", ""),
                                 "junc_del_yn": pproc.get(p, {}).get("del_yn", "")}
                             for p in PROCS_ACTIVE if p in proc},
        "processes_superseded": {p: {"proc_nm": proc.get(p, {}).get("proc_nm", "?"),
                                     "junc_del_yn": pproc.get(p, {}).get("del_yn", "")}
                                 for p in PROCS_SUPERSEDED},
        "plate_placeholder": {s: {"siz_nm": siz.get(s, {}).get("siz_nm", "?")}
                              for s in PLATE_PLACEHOLDER},
        "qty": {"nonspec_yn": prod[PRD]["nonspec_yn"],
                "min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "editor_yn": prod[PRD]["editor_yn"], "file_upload_yn": prod[PRD]["file_upload_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "prd_nm": prod[PRD]["prd_nm"]}
        if PRD in prod else {},
        "formula": {"frm_cd": FRM, "bound": bool(pfrm),
                    "comp_wired": [{"comp_cd": r["comp_cd"], "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]}
                                   for r in sorted(fcomp, key=lambda x: x["disp_seq"])]},
        "components": {c: {"prc_typ_cd": pc.get(c, {}).get("prc_typ_cd", ""),
                           "comp_typ_cd": pc.get(c, {}).get("comp_typ_cd", ""),
                           "use_dims": pc.get(c, {}).get("use_dims", "")}
                       for c in [COMP_BODY, COMP_STAND]},
        "body_shape": {"comp_cd": COMP_BODY, "row_count": len(body),
                       "use_dims": ["siz_cd", "min_qty"],
                       "distinct_siz": len(body_siz), "siz_cells": body_siz,
                       "qty_bands": body_qty,
                       "grid_full": len(body) == len(body_siz) * max(1, len(body_qty)),
                       "qty_populated": len(body_qty) > 1,
                       "size_price_match": sorted(SIZES_ACTIVE) == body_siz},
        "stand_shape": {"comp_cd": COMP_STAND, "row_count": len(stand),
                        "use_dims": ["mat_cd"], "distinct_mat": len(stand_mats),
                        "mat_cells": stand_mats,
                        "covers_option_mats": sorted(["MAT_000409", "MAT_000410"]) == stand_mats},
        "orphan_components": {c: {"in_formula": any(w["comp_cd"] == c for w in fcomp),
                                  "price_rows": len(cp_rows(c)),
                                  "use_dims": pc.get(c, {}).get("use_dims", "")}
                              for c in COMP_ORPHAN},
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "nm": r["opt_grp_nm"],
                           "sel_typ": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                           "max_sel": r["max_sel_cnt"], "mand": r["mand_yn"],
                           "use_yn": r["use_yn"], "del_yn": r["del_yn"], "note": r["note"]}
                          for r in sorted(og, key=lambda x: x["disp_seq"] or "9")],
        "options": [{"opt_cd": r["opt_cd"], "grp": r["opt_grp_cd"], "nm": r["opt_nm"],
                     "dflt": r["dflt_yn"], "del_yn": r["del_yn"]}
                    for r in opt],
        "option_items": [{"opt_cd": r["opt_cd"], "seq": r["item_seq"], "ref_dim": r["ref_dim_cd"],
                          "ref_key1": r["ref_key1"], "ref_key2": r["ref_key2"], "del_yn": r["del_yn"]}
                         for r in oitem],
        "addon_rows": len(addon),
        "set_parent_rows": len(sets),
    }


def md(d):
    o = []
    def hdr(tbl):
        o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_136.py from {SNAP_ID} {tbl} PRD_000136 @ {STAMP} -->")

    hdr("t_prd_product_categories+t_cat_categories")
    o.append("| cat_cd | 분류명 | 상위 | lvl | main |")
    o.append("|---|---|---|---|---|")
    for c in d["categories"]:
        o.append(f'| {c["cat_cd"]} | {c["cat_nm"]} | {c["upr"] or "-"} | {c["lvl"]} | {c["main"]} |')
    o.append("")
    hdr("t_prd_product_sizes+t_siz_sizes")
    o.append("| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |")
    o.append("|---|---|---|---|---|")
    for s, v in d["sizes_active"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["master_del_yn"] or "N"} | {v["junc_del_yn"] or "N"} |')
    o.append("")
    hdr("t_mat_materials+t_prd_product_materials (활성)")
    o.append("| mat_cd | 자재명 | mat_typ | 상위자재 | dflt | junction_del_yn |")
    o.append("|---|---|---|---|---|---|")
    for m, v in d["materials_active"].items():
        o.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr"] or "-"} | {v["dflt"] or "N"} | {v["junc_del_yn"] or "N"} |')
    o.append("")
    o.append("자재 승계삭제(참고·노드 미생성): " + ", ".join(
        f'{m}({v["mat_nm"]}·master_del={v["master_del_yn"] or "N"}·junc_del={v["junc_del_yn"] or "N"})'
        for m, v in d["materials_superseded"].items()))
    o.append("")
    hdr("t_proc_processes+t_prd_product_processes (활성)")
    o.append("| proc_cd | 공정명 | 상위공정 | mand | junction_del_yn |")
    o.append("|---|---|---|---|---|")
    for p, v in d["processes_active"].items():
        o.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"] or "-"} | {v["mand"] or "N"} | {v["junc_del_yn"] or "N"} |')
    o.append("")
    o.append("공정 승계삭제(참고·노드 미생성·07-01 재키잉): " + ", ".join(
        f'{p}({v["proc_nm"]}·junc_del={v["junc_del_yn"] or "N"})'
        for p, v in d["processes_superseded"].items()))
    o.append("")
    hdr("t_prd_product_plate_sizes (★output_paper_typ 공란=파일사양 placeholder·비종이류 판형 무의미·pack §3.8·T-7)")
    o.append("| siz_cd | 라벨 | 용도 |")
    o.append("|---|---|---|")
    for s, v in d["plate_placeholder"].items():
        o.append(f'| {s} | {v["siz_nm"]} | JPG 파일사양(판형 아님) |')
    o.append("")
    hdr("t_prd_products")
    o.append("| 항목 | 값 |")
    o.append("|---|---|")
    q = d["qty"]
    for k, lab in [("prd_nm", "prd_nm"), ("prd_typ_cd", "prd_typ_cd"), ("nonspec_yn", "nonspec_yn(★N=사용자입력 없음)"),
                   ("min_qty", "min_qty"), ("max_qty", "max_qty"), ("qty_incr", "qty_incr"),
                   ("unit", "qty_unit"), ("use_yn", "use_yn"), ("del_yn", "del_yn"),
                   ("file_upload_yn", "file_upload"), ("editor_yn", "editor")]:
        o.append(f'| {lab} | {q.get(k)} |')
    o.append("")
    hdr("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components")
    o.append("| frm_cd | 상품 바인딩 | comp_cd(배선·disp_seq) | prc_typ_cd | comp_typ_cd | use_dims |")
    o.append("|---|---|---|---|---|---|")
    f = d["formula"]
    for w in f["comp_wired"]:
        cc = d["components"].get(w["comp_cd"], {})
        o.append(f'| {f["frm_cd"]} | {f["bound"]} | {w["comp_cd"]}(seq {w["disp_seq"]}·addtn {w["addtn"]}) '
                 f'| {cc.get("prc_typ_cd","")} | {cc.get("comp_typ_cd","")} | {cc.get("use_dims","")} |')
    o.append("")
    hdr("t_prc_component_prices (★본체 고정가 SHAPE·값 미전사)")
    o.append("| comp_cd | 차원 | 규격셀수 | siz 셀 | 수량밴드수 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    b = d["body_shape"]
    o.append(f'| {b["comp_cd"]} | {"×".join(b["use_dims"])} | {b["distinct_siz"]} | {",".join(b["siz_cells"])} '
             f'| {len(b["qty_bands"])} | {b["row_count"]} | {b["grid_full"]} | {b["qty_populated"]} | {b["size_price_match"]} |')
    o.append("")
    hdr("t_prc_component_prices (★거치대 가산 SHAPE·값 미전사)")
    o.append("| comp_cd | 차원 | 자재셀수 | mat 셀 | 단가행수 | 거치대옵션자재 커버 |")
    o.append("|---|---|---|---|---|---|")
    st = d["stand_shape"]
    o.append(f'| {st["comp_cd"]} | {"×".join(st["use_dims"])} | {st["distinct_mat"]} | {",".join(st["mat_cells"])} '
             f'| {st["row_count"]} | {st["covers_option_mats"]} |')
    o.append("")
    hdr("t_prc_price_components+t_prc_formula_components (★orphan 거치대 구성요소·공식 미배선)")
    o.append("| comp_cd | 공식배선됨 | 단가행수 | use_dims |")
    o.append("|---|---|---|---|")
    for c, v in d["orphan_components"].items():
        o.append(f'| {c} | {v["in_formula"]} | {v["price_rows"]} | {v["use_dims"] or "[]"} |')
    o.append("")
    hdr("t_prd_product_option_groups")
    o.append("| opt_grp_cd | 그룹명 | sel_typ | min/max | mand | use_yn | del_yn | note |")
    o.append("|---|---|---|---|---|---|---|---|")
    for g in d["option_groups"]:
        o.append(f'| {g["opt_grp_cd"]} | {g["nm"]} | {g["sel_typ"]} | {g["min_sel"] or "-"}/{g["max_sel"] or "-"} '
                 f'| {g["mand"]} | {g["use_yn"]} | {g["del_yn"]} | {g["note"]} |')
    o.append("")
    hdr("t_prd_product_options+t_prd_product_option_items (옵션값→차원 참조)")
    o.append("| opt_cd | 그룹 | 옵션명 | dflt | ref_dim | ref_key1 | item_del_yn |")
    o.append("|---|---|---|---|---|---|---|")
    # 활성 item(del_yn=N)이 승계삭제 item을 이기도록 — del=Y 먼저 넣고 del=N이 덮어쓰게 정렬(재키잉 후 활성 ref 표시)
    itm = {(i["opt_cd"]): i for i in sorted(d["option_items"], key=lambda x: x["del_yn"], reverse=True)}
    for op in d["options"]:
        it = itm.get(op["opt_cd"], {})
        o.append(f'| {op["opt_cd"]} | {op["grp"]} | {op["nm"]} | {op["dflt"]} '
                 f'| {it.get("ref_dim","-")} | {it.get("ref_key1","-")} | {it.get("del_yn","-")} |')
    o.append("")
    o.append(f'추가상품(t_prd_product_addons) 행수 = {d["addon_rows"]} · '
             f'셋트부모(t_prd_product_sets) 행수 = {d["set_parent_rows"]} '
             f'(★거치대는 CPQ 옵션 OPT-000009+STAND_SEL 가산으로 표현·addon 아님·pack §3.12 우드거치대012 addon 기대와 델타)')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-136-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
