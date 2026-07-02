#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-027 2단접지카드 전용.

기존 transcribe_snapshot.py(파일럿 공통 축)는 수정하지 않는다. 이 스크립트는
PRD_000027(2단접지카드) 노드가 필요로 하는 상품 전용 수치/배선을 라이브 스냅샷에서
결정론적으로 전사한다:
  ① 상품 정체·수량 스칼라(prd_typ_cd·min/max/incr·qty_unit)
  ② 상품 전용 사이즈 6행 치수(공유 sizes.md에 없는 것)
  ③ 상품 전용 자재 8행 사양(공유 materials.md에 없는 것)
  ④ 박 분기 공식 PRF_DGP_E_FOIL 배선(14 구성요소)
  ⑤ 박/형압 구성요소 3종(COMP_FOIL_*) 속성
  ⑥ CPQ 옵션그룹 5종 → 참조 차원(option_refs) 요약

노드 파일의 치수·자재 사양·배선표는 이 스크립트가 전사한 것을 그대로 옮긴 것이며
(transcribed-by 마커), 사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_027.py          # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000027"

# 공유 축 노드에 이미 있는 것(재사용) — 전사에서 제외
SHARED_SIZES = {"SIZ_000001", "SIZ_000002", "SIZ_000003", "SIZ_000004",
                "SIZ_000005", "SIZ_000006", "SIZ_000007", "SIZ_000499"}
SHARED_MATS = {"MAT_000074", "MAT_000081", "MAT_000082",
               "MAT_000091", "MAT_000092", "MAT_000101"}
FOIL_COMPS = ["COMP_FOIL_SETUP_LARGE", "COMP_FOIL_PROC_LARGE_STD",
              "COMP_FOIL_PROC_LARGE_SPECIAL"]
FOIL_FRM = "PRF_DGP_E_FOIL"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def prd_rows(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD and r.get("del_yn", "N") == "N"]


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def marker(tbl):
    return (f"<!-- transcribed-by: _meta/scripts/transcribe_product_027.py "
            f"from {SNAP_ID} {tbl} prd_cd={PRD} @ {STAMP} -->")


def identity():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}[PRD]
    out = [marker("t_prd_products"),
           "| 필드 | 값 |", "|---|---|"]
    for k in ["prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
              "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]:
        out.append(f"| {k} | {p.get(k)} |")
    return "\n".join(out)


def sizes():
    szmaster = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = [r for r in prd_rows("t_prd_product_sizes.csv")]
    rows.sort(key=lambda r: int(r.get("disp_seq") or 999))
    out = [marker("t_prd_product_sizes+t_siz_sizes"),
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp_seq |",
           "|---|---|---|---|---|---|"]
    for r in rows:
        s = szmaster.get(r["siz_cd"], {})
        work = f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}'
        cut = f'{_mm(s.get("cut_width"))}x{_mm(s.get("cut_height"))}'
        new = "" if r["siz_cd"] in SHARED_SIZES else " (신규)"
        out.append(f'| {r["siz_cd"]}{new} | {s.get("siz_nm")} | {work} | {cut} | {r["dflt_yn"]} | {r["disp_seq"]} |')
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = [r for r in prd_rows("t_prd_product_materials.csv")
            if r["mat_cd"] not in SHARED_MATS]
    rows.sort(key=lambda r: int(r.get("disp_seq") or 999))
    out = [marker("t_prd_product_materials+t_mat_materials (공유 6종 제외)"),
           "| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage |",
           "|---|---|---|---|---|---|"]
    for r in rows:
        m = mm.get(r["mat_cd"], {})
        spec = f'{_mm(m.get("width"))}x{_mm(m.get("height"))}'
        out.append(f'| {r["mat_cd"]} | {m.get("mat_nm")} | {m.get("mat_typ_cd")} | {spec} | {_mm(m.get("weight"))} | {r["usage_cd"]} |')
    return "\n".join(out)


def foil_wiring():
    pc = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FOIL_FRM]
    rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""),
                             float(x.get("disp_seq") or 1e9), x["comp_cd"]))
    out = [marker(f"t_prc_formula_components+t_prc_price_components frm_cd={FOIL_FRM}"),
           "| disp_seq | comp_cd | addtn | prc_typ | comp_nm |",
           "|---|---|---|---|---|"]
    for r in rows:
        c = pc.get(r["comp_cd"], {})
        out.append(f'| {r.get("disp_seq") or ""} | {r["comp_cd"]} | {r.get("addtn_yn") or ""} | {c.get("prc_typ_cd")} | {c.get("comp_nm")} |')
    return "\n".join(out)


def foil_components():
    pc = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    out = [marker("t_prc_price_components (박/형압 구성요소)"),
           "| comp_cd | comp_nm | prc_typ | use_dims |", "|---|---|---|---|"]
    for c in FOIL_COMPS:
        r = pc.get(c, {})
        out.append(f'| {c} | {r.get("comp_nm")} | {r.get("prc_typ_cd")} | {r.get("use_dims")} |')
    return "\n".join(out)


def optgroups():
    grp = prd_rows("t_prd_product_option_groups.csv")
    opts = prd_rows("t_prd_product_options.csv")
    items = {r["opt_cd"]: r for r in prd_rows("t_prd_product_option_items.csv")}
    by_grp = {}
    for o in opts:
        by_grp.setdefault(o["opt_grp_cd"], []).append(o)
    out = [marker("t_prd_product_option_groups/options/option_items"),
           "| opt_grp_cd | 그룹명 | sel_typ | mand | 옵션값(참조 차원) |",
           "|---|---|---|---|---|"]
    grp.sort(key=lambda r: int(r.get("disp_seq") or 999))
    for g in grp:
        refs = []
        for o in by_grp.get(g["opt_grp_cd"], []):
            it = items.get(o["opt_cd"])
            if it:
                refs.append(f'{o["opt_nm"]}→{it["ref_dim_cd"]}:{it["ref_key1"]}')
            else:
                refs.append(f'{o["opt_nm"]}(참조없음)')
        out.append(f'| {g["opt_grp_cd"]} | {g["opt_grp_nm"]} | {g["sel_typ_cd"]} | {g["mand_yn"]} | {"; ".join(refs)} |')
    return "\n".join(out)


if __name__ == "__main__":
    print("### 정체·수량 (전사)\n");   print(identity())
    print("\n### 상품 전용 사이즈 (전사)\n"); print(sizes())
    print("\n### 상품 전용 자재 (전사)\n"); print(materials())
    print(f"\n### {FOIL_FRM} 배선 (전사)\n"); print(foil_wiring())
    print("\n### 박/형압 구성요소 (전사)\n"); print(foil_components())
    print("\n### CPQ 옵션그룹→참조차원 (전사)\n"); print(optgroups())
