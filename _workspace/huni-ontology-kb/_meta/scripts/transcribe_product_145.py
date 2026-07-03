#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 미니배너 PRD_000145 전용.

transcribe_product_137.py(메쉬배너·고정가 (siz_cd×min_qty) 룩업)를 계승하되 145 실측 델타에 맞춘다:

  - ★가격모델=고정가 룩업(fixed): COMP_POSTER_MINI_BANNER·use_dims=[siz_cd, min_qty]·규격×수량구간
    블록(pack §3.10 고정가형 15상품 미니배너). ★137과 달리 145는 **수량구간이 다tier**(min_qty 4/19/49/
    99/10000 5구간)이라 실제 수량할인 격자가 있다. 격자 = 2 규격 × 5 수량구간 = 10셀(전부 실재·격자완전).
    ★값(unit_price)은 노드에 기록 안 함(D-18·값=evaluate_price) — 전사 evidence 표에는 range(shape)만.
  - ★자재=PET MAT_000178(MAT_TYPE.08 실사소재·upr 공백·USAGE.07) = **axis/materials.md가 canonical
    정의**한 공유 축 노드(material-MAT_000178·039 투명명함/120 방수/135 족자/136 PET배너 횡단)를 재사용
    (여기서 재정의 안 함·L-3). MAT_TYPE.08은 현재값(pack §3.5 PET 실사소재)·정정 목표 미명시.
  - ★공정=유광라미네이팅 PROC_000014·무광라미네이팅 PROC_000015(부모 PROC_000013 라미네이팅) = axis/
    processes.md canonical 재사용. 둘 다 mand_proc_yn=N(코팅 옵션이 택1로 선택).
  - ★비종이류(배너·대형 롤): 판형(plate_size) 무의미 — 라이브 plate 2행(SIZ_000028/SIZ_000328) 전부
    del_yn=Y(2026-06-30 정리)·output_paper_typ 공백(파일사양 placeholder). fn_best_plate/fn_calc_pansu 적용 금지.
  - CPQ 옵션 레이어 1그룹(137과 차이·코팅 옵션):
      OPT_000024 코팅(mand N·택1·min0/max1)→OPV_000046 무광코팅(dflt Y)→option_item ref PROC_000015
        (OPT_REF_DIM.04 공정 무광라미) / OPV_000047 유광코팅→option_item ref PROC_000014(유광라미).
        ★코팅 옵션은 공정 선택(생산 마감)이지 별도 가격 component 배선 없음 — 통가격(출력+코팅+거치대)에 포함.
  - ★거치대: 가격 note '[출력+코팅+거치대 포함가]'라 배너거치대(stand)가 통가격 baked → 137처럼 별도
    부속 옵션/addon 불요(137 standoff BLOCKED과 대비). addons/sets 0행이 정합(부속 미연결 결함 아님).
  - print_options/bundle_qtys/addons/constraints/sets = 0행(실측). option_groups=1행(코팅).
  - 카테고리 = CAT_000097(POP·lvl2·부모 CAT_000005 사인)만 junction 연결(1행). 145/144 미니류 공유 leaf.
  - 사이즈 = SIZ_000028(150x300·note에 3단접지카드 판걸이 잔재=공유 마스터·비종이류라 무관)·
    SIZ_000328(180x420)·둘 다 이산 규격·nonspec_yn=N·둘 다 dflt_yn=Y(데이터 특이·전사 그대로).

사용:  python3 transcribe_product_145.py            # stdout markdown
       python3 transcribe_product_145.py --json     # cache/transcribed-145-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000145"
SELF = "transcribe_product_145.py"
FIXED_COMP = "COMP_POSTER_MINI_BANNER"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd_all(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat_nm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc_nm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd_all("t_prd_product_categories.csv"))
    psizes = by_prd_all("t_prd_product_sizes.csv")           # del 표기 위해 전 행
    mats = active(by_prd_all("t_prd_product_materials.csv"))
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs = active(by_prd_all("t_prd_product_processes.csv"))
    plates = by_prd_all("t_prd_product_plate_sizes.csv")     # del 표기 위해 전 행
    bqty = active(by_prd_all("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd_all("t_prd_product_addons.csv"))
    cons = active(by_prd_all("t_prd_product_constraints.csv"))
    grps = active(by_prd_all("t_prd_product_option_groups.csv"))
    opts = active(by_prd_all("t_prd_product_options.csv"))
    oitems = active(by_prd_all("t_prd_product_option_items.csv"))
    sets_parent = active([r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD])

    def size_row(r):
        s = sizes.get(r["siz_cd"], {})
        return {"siz_cd": r["siz_cd"], "siz_nm": s.get("siz_nm", "?"),
                "work": f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}',
                "impos_yn": s.get("impos_yn", "?"), "nonspec": prod.get("nonspec_yn"),
                "link_del": r.get("del_yn", "N"), "master_del": s.get("del_yn", "?"),
                "dflt": r.get("dflt_yn", ""),
                "master_note": (s.get("note") or "").replace("\n", " ")}

    def plate_row(r):
        return {"siz_cd": r["siz_cd"],
                "output_paper_typ_cd": r.get("output_paper_typ_cd") or "",
                "output_file_typ": r.get("output_file_typ") or "",
                "dflt": r.get("dflt_plt_yn", ""), "del": r.get("del_yn", "N"),
                "note": r.get("note") or ""}

    def proc_row(r):
        m = proc_nm.get(r["proc_cd"], {})
        return {"proc_cd": r["proc_cd"], "proc_nm": m.get("proc_nm", "?"),
                "upr": m.get("upr_proc_cd") or "", "mand": r.get("mand_proc_yn", ""),
                "dtl_opt": (m.get("prcs_dtl_opt") or "").replace("\n", " "),
                "link_del": r.get("del_yn", "N")}

    def grp_row(r):
        gopts = [o for o in opts if o["opt_grp_cd"] == r["opt_grp_cd"]]
        return {"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                "max_sel": r["max_sel_cnt"], "mand_yn": r["mand_yn"],
                "note": r.get("note") or "",
                "options": [{"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"], "dflt": o["dflt_yn"]}
                            for o in gopts]}

    def item_row(r):
        return {"opt_cd": r["opt_cd"], "item_seq": r["item_seq"],
                "ref_dim_cd": r.get("ref_dim_cd") or "", "ref_key1": r.get("ref_key1") or "",
                "ref_key2": r.get("ref_key2") or "", "qty": r.get("qty") or ""}

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fmeta = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 고정가 룩업 셀 요약 (D-22 접기 — 전개 금지·집계만·값은 range shape 증거만)
    # use_dims=[siz_cd, min_qty] → 격자축 = (siz_cd × min_qty)
    cp = active([r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIXED_COMP])

    def fixed_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        sset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        qset = sorted({r.get("min_qty") for r in g if r.get("min_qty")},
                      key=lambda x: (x in (None, ""), float(x) if x else 0))
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        cells = sorted({(r.get("siz_cd"), r.get("min_qty")) for r in g})
        return {"rows": len(g), "sizes": sset, "qtys": qset,
                "cells_present": len(cells),
                "combos_potential": len(sset) * len(qset),
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "use_yn": pcomp.get(comp, {}).get("use_yn"),
                "use_dims": pcomp.get(comp, {}).get("use_dims"),
                "comp_nm": pcomp.get(comp, {}).get("comp_nm")}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "nonspec_yn",
                     "min_qty", "max_qty", "qty_incr", "qty_unit_typ_cd",
                     "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd"),
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl"),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes": [size_row(r) for r in psizes],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "upr_mat_cd": mat_nm.get(r["mat_cd"], {}).get("upr_mat_cd") or "",
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [proc_row(r) for r in procs],
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": [grp_row(r) for r in grps],
        "option_items": [item_row(r) for r in oitems],
        "sets_parent": sets_parent,
        "formulas": fbind, "formula_meta": {f: fmeta.get(f, {}) for f in fbind},
        "wiring": wiring,
        "grid": {FIXED_COMP: fixed_summary(FIXED_COMP)},
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000145"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("\n> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 2종 150x300·180x420만). 수량 min1/max10000/incr1(제품 레벨).")
    o.append("> ★상품 min_qty=1인데 가격격자 최저 수량구간=min_qty 4(아래 격자표) — 수량 1~3 가격 tier 부재는 GAP(gap-145-qtytier-floor).")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn(링크) |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')
    o.append("\n> ★junction 1행(CAT_000097 POP·lvl2)만. 부모 CAT_000005(사인·root)는 카테고리 계층(upr_cat_cd)이지 junction 링크 아님. CAT_000097은 미니류(144 미니보드스탠딩 형제) 공유 leaf — 144가 in_category로 참조만 하고 def block 미생성이라 145가 companion mint(canonical·needed_shared).")

    o.append("\n### 사이즈 (전사·전 행·del 표기·nonspec_yn=N 이산 2규격)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | impos_yn | nonspec | dflt | 링크 del | 마스터 del | 마스터 note |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    for r in d["sizes"]:
        mnote = r.get("master_note") or "-"
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["impos_yn"]} | {r["nonspec"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} | {mnote} |')
    o.append("\n> ★SIZ_000028(150x300)·SIZ_000328(180x420) 둘 다 dflt_yn=Y(데이터 특이·전사 그대로). SIZ_000028 마스터 note '판걸이=3.0 / 전지=316x467 / 적용=3단접지카드'는 공유 마스터 사이즈의 카드 잔재 — 비종이류 배너(145)엔 무관(판형 del·판걸이 로직 미적용·T-7). 145 전용 mint(KB 미존재).")

    o.append("\n### 자재 (전사·★PET MAT_TYPE.08 실사소재·axis/materials canonical 재사용)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt |")
    o.append("|---|---|---|---|---|---|")
    for r in d["materials"]:
        upr = r["upr_mat_cd"] if r["upr_mat_cd"] else "(공백·부모)"
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {upr} | {r["usage_cd"]} | {r["dflt_yn"]} |')
    o.append("\n> ★PET MAT_000178 = MAT_TYPE.08 실사소재(현재값·pack §3.5 PET 실사소재). material-MAT_000178은 axis/materials.md가 canonical 정의(039 투명명함/120 방수/135 족자/136 PET배너 횡단·공유 축)이라 145는 재사용만(재정의 안 함·L-3). ★IMPORT 등록 자재 삭제 금지(RULE_import_material_no_delete).")

    o.append("\n### 공정 (전사·유광/무광 라미네이팅·mand N·코팅 옵션이 선택)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand | prcs_dtl_opt(param) | 링크 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["processes"]:
        upr = r["upr"] if r["upr"] else "(없음)"
        dtl = r["dtl_opt"] if r["dtl_opt"] else "(없음)"
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {upr} | {r["mand"]} | `{dtl}` | {r["link_del"]} |')
    o.append("\n> ★PROC_000014 유광라미네이팅·PROC_000015 무광라미네이팅(부모 PROC_000013 라미네이팅)·둘 다 mand N. 코팅 CPQ 옵션(OPT_000024)이 이 두 공정을 택1 참조(option_refs·OPT_REF_DIM.04). process-PROC_000014/015는 axis/processes.md canonical 재사용(재정의 안 함).")

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·del_yn=Y)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')
    o.append("\n> ★plate 2행 전부 del_yn=Y(06-30 정리)·output_paper_typ 공백. 비종이류(대형 롤 배너)라 판형·판걸이수 무의미(has_plate_size 엣지 0=정상·pack §3.8·T-7·RULE_plate_paper_only).")

    o.append("\n### CPQ 옵션 레이어 (전사·★137과 차이·1그룹 코팅)\n")
    o.append(_tb("t_prd_product_option_groups+t_prd_product_options"))
    o.append("| opt_grp_cd | 그룹명 | sel_typ | min/max_sel | mand | 옵션값(opt_cd·dflt) | 그룹 note |")
    o.append("|---|---|---|---|---|---|---|")
    for g in d["option_groups"]:
        ov = " / ".join(f'{o["opt_nm"]}({o["opt_cd"]}·dflt={o["dflt"]})' for o in g["options"])
        o.append(f'| {g["opt_grp_cd"]} | {g["opt_grp_nm"]} | {g["sel_typ_cd"]} | {g["min_sel"]}/{g["max_sel"]} | {g["mand_yn"]} | {ov} | {g["note"]} |')

    o.append("\n### CPQ 옵션 아이템 (전사·다형참조 ref_dim_cd)\n")
    o.append(_tb("t_prd_product_option_items"))
    o.append("| opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | qty |")
    o.append("|---|---|---|---|---|---|")
    if d["option_items"]:
        for r in d["option_items"]:
            o.append(f'| {r["opt_cd"]} | {r["item_seq"]} | {r["ref_dim_cd"]} | {r["ref_key1"]} | {r["ref_key2"] or "-"} | {r["qty"]} |')
    else:
        o.append("| (없음) | - | - | - | - | - |")
    o.append("\n> ★OPV_000046 무광코팅(dflt) → OPT_REF_DIM.04(공정)·ref_key1=PROC_000015(무광라미)·qty 1. OPV_000047 유광코팅 → ref_key1=PROC_000014(유광라미). 두 옵션 다 145 has_process에 실재(L-18 부모정합 통과). ★코팅은 공정 선택(마감)이지 별도 가격 component 배선 없음 — 통가격에 포함.")

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("print_options/bundle_qtys/addons/constraints/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")
    o.append("\n> ★addons/sets 0행 = 정합(거치대가 통가격 baked·'[출력+코팅+거치대 포함가]'라 별도 부속 불요·137 standoff BLOCKED과 대비). constraints 0행 = 정합(145는 신규발현 7상품 118/120/121/122/124/125/139에 미포함·nonspec_yn=N이라 치수범위 제약 불필요).")

    o.append("\n### 가격 배선 (전사·priced_by→공식→구성요소)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for frm in d["formulas"]:
        fm = d["formula_meta"].get(frm, {})
        o.append(f'\n공식 **{frm}** — {fm.get("frm_nm","")} (use_yn={fm.get("use_yn","")})\n')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|")
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)\n")
    o.append(_tb("t_prc_component_prices (COMP_POSTER_MINI_BANNER 집계)"))
    o.append("| comp_cd | use_yn | 행수 | 사이즈축 | 수량구간축(min_qty) | 셀존재/잠재 | 단가범위(shape) | use_dims |")
    o.append("|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIXED_COMP]
    sizes_lbl = "/".join(g["sizes"]) if g["sizes"] else "-"
    qtys_lbl = "/".join(g["qtys"]) if g["qtys"] else "-"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    o.append(f'| {FIXED_COMP} | {g["use_yn"]} | {g["rows"]} | {sizes_lbl} | {qtys_lbl} | {g["cells_present"]}/{g["combos_potential"]} | {pr} | `{g["use_dims"]}` |')
    o.append("\n> ★셀존재/잠재 = 사이즈 2(SIZ_000028·SIZ_000328) × 수량구간 5(min_qty 4/19/49/99/10000) = 10셀 전부 실재")
    o.append("> (격자완전 True·137과 달리 다-tier 수량할인 실재). use_dims=[siz_cd, min_qty]=규격×수량구간 블록")
    o.append("> (면적매트릭스 아님·siz_width/siz_height 미사용). 통가격=출력+코팅+거치대 포함(가격 note).")
    o.append("> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).")
    o.append("> ★수량구간 최저 tier=min_qty 4(상품 min_qty 1과 불일치) — 수량 1~3 tier 부재=GAP(gap-145-qtytier-floor).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-145-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
