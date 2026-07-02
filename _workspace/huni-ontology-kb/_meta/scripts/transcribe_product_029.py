#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-029 3단접지카드 전용.

기존 transcribe_product_027.py(형제 2단접지카드)와 파일럿 공통 스크립트는 수정하지 않는다.
이 스크립트는 PRD_000029(3단접지카드) 노드가 필요로 하는 상품 전용 수치/배선을
라이브 스냅샷에서 결정론적으로 전사한다:
  ① 상품 정체·수량 스칼라(prd_typ_cd·min/max/incr·qty_unit)
  ② 상품 사이즈 3행 치수(전부 기존 노드 재사용 — 재사용 출처 표기)
  ③ 상품 자재 14행 사양(전부 기존 노드 재사용 — 재사용 출처 표기)
  ④ 상품 공정 13행(★신규=PROC_000067/068 3단접지, 나머지 재사용)
  ⑤ 가격공식 바인딩(PRF_DGP_E 기본 + PRF_DGP_E_FOIL 박 분기·둘 다 라이브 바인딩)
  ⑥ CPQ 옵션그룹 5종 → 참조 차원(option_refs) 요약
  ⑦ 추가상품(addon) 템플릿 3종·인쇄옵션·제약 카운트

노드 파일의 치수·자재·공정·배선표는 이 스크립트가 전사한 것을 그대로 옮긴 것이며
(transcribed-by 마커), 사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_029.py          # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000029"

# 기존 노드 정의처(재사용 — 이 스크립트/노드에서 재-mint 금지·L-3)
SIZE_SRC = {
    "SIZ_000523": "product-027-nodes", "SIZ_000124": "product-027-nodes",
    "SIZ_000004": "axis/sizes",
}
MAT_SRC = {
    "MAT_000074": "axis/materials", "MAT_000081": "axis/materials",
    "MAT_000082": "axis/materials", "MAT_000091": "axis/materials",
    "MAT_000092": "axis/materials", "MAT_000101": "axis/materials",
    "MAT_000108": "product-027-nodes", "MAT_000109": "product-027-nodes",
    "MAT_000123": "product-027-nodes",
    "MAT_000113": "product-023-nodes", "MAT_000114": "product-023-nodes",
    "MAT_000115": "product-023-nodes", "MAT_000116": "product-023-nodes",
    "MAT_000125": "product-023-nodes",
}
PROC_SRC = {
    "PROC_000004": "axis/processes", "PROC_000031": "axis/processes",
    "PROC_000032": "axis/processes",
    "PROC_000037": "product-027-nodes", "PROC_000038": "product-027-nodes",
    "PROC_000039": "product-027-nodes", "PROC_000040": "product-027-nodes",
    "PROC_000041": "product-027-nodes", "PROC_000042": "product-027-nodes",
    "PROC_000043": "product-027-nodes", "PROC_000044": "product-027-nodes",
    # PROC_000067/068 = 신규(이 상품 전용 마스터 — product-029-nodes에서 mint)
}
NEW_PROCS = ["PROC_000067", "PROC_000068"]


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
    return (f"<!-- transcribed-by: _meta/scripts/transcribe_product_029.py "
            f"from {SNAP_ID} {tbl} prd_cd={PRD} @ {STAMP} -->")


def identity():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}[PRD]
    out = [marker("t_prd_products"), "| 필드 | 값 |", "|---|---|"]
    for k in ["prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
              "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]:
        out.append(f"| {k} | {p.get(k)} |")
    return "\n".join(out)


def sizes():
    szmaster = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = prd_rows("t_prd_product_sizes.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["siz_cd"]))
    out = [marker("t_prd_product_sizes+t_siz_sizes"),
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | 노드 정의처(재사용) |",
           "|---|---|---|---|---|---|"]
    for r in rows:
        s = szmaster.get(r["siz_cd"], {})
        work = f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}'
        cut = f'{_mm(s.get("cut_width"))}x{_mm(s.get("cut_height"))}'
        out.append(f'| {r["siz_cd"]} | {s.get("siz_nm")} | {work} | {cut} | {r["dflt_yn"]} | {SIZE_SRC.get(r["siz_cd"], "?")} |')
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = prd_rows("t_prd_product_materials.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials"),
           "| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | 노드 정의처(재사용) |",
           "|---|---|---|---|---|---|---|"]
    for r in rows:
        m = mm.get(r["mat_cd"], {})
        spec = f'{_mm(m.get("width"))}x{_mm(m.get("height"))}'
        out.append(f'| {r["mat_cd"]} | {m.get("mat_nm")} | {m.get("mat_typ_cd")} | {spec} | {_mm(m.get("weight"))} | {r["usage_cd"]} | {MAT_SRC.get(r["mat_cd"], "?")} |')
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = prd_rows("t_prd_product_processes.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["proc_cd"]))
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | mand | disp_seq | 노드 정의처 |",
           "|---|---|---|---|---|"]
    for r in rows:
        m = pm.get(r["proc_cd"], {})
        src = PROC_SRC.get(r["proc_cd"], "product-029-nodes (신규)")
        out.append(f'| {r["proc_cd"]} | {m.get("proc_nm")} | {r.get("mand_proc_yn")} | {r.get("disp_seq")} | {src} |')
    return "\n".join(out)


def formula_binding():
    rows = prd_rows("t_prd_product_price_formulas.csv")
    rows.sort(key=lambda r: r.get("frm_cd"))
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | apply_bgn_ymd | note |", "|---|---|---|"]
    for r in rows:
        out.append(f'| {r["frm_cd"]} | {r.get("apply_bgn_ymd")} | {r.get("note")} |')
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
            if it and it.get("ref_dim_cd"):
                refs.append(f'{o["opt_nm"]}→{it["ref_dim_cd"]}:{it["ref_key1"]}')
            else:
                refs.append(f'{o["opt_nm"]}(참조없음)')
        out.append(f'| {g["opt_grp_cd"]} | {g["opt_grp_nm"]} | {g["sel_typ_cd"]} | {g["mand_yn"]} | {"; ".join(refs)} |')
    return "\n".join(out)


def addons_and_counts():
    tm = {r["tmpl_cd"]: r for r in rd("t_prd_templates.csv")}
    ad = prd_rows("t_prd_product_addons.csv")
    ad.sort(key=lambda r: int(r.get("disp_seq") or 999))
    out = [marker("t_prd_product_addons+t_prd_templates / print_options / constraints"),
           "| disp_seq | tmpl_cd | 템플릿명 | base_prd |", "|---|---|---|---|"]
    for r in ad:
        t = tm.get(r["tmpl_cd"], {})
        out.append(f'| {r.get("disp_seq")} | {r["tmpl_cd"]} | {t.get("tmpl_nm")} | {t.get("base_prd_cd")} |')
    po = prd_rows("t_prd_product_print_options.csv")
    ct = prd_rows("t_prd_product_constraints.csv")
    bq = prd_rows("t_prd_product_bundle_qtys.csv")
    out.append("")
    out.append(f"- 인쇄옵션 행: {len(po)}" + (f" (opt_id={po[0].get('opt_id')} print_side={po[0].get('print_side')} front={po[0].get('front_colrcnt_cd')} back={po[0].get('back_colrcnt_cd')})" if po else ""))
    out.append(f"- 활성 제약(constraints del_yn=N): {len(ct)}")
    out.append(f"- bundle_qtys 행: {len(bq)}  (0=상품 스칼라 수량규칙만)")
    return "\n".join(out)


if __name__ == "__main__":
    print("### 정체·수량 (전사)\n");                 print(identity())
    print("\n### 사이즈 3행 (전사·전부 재사용)\n");     print(sizes())
    print("\n### 자재 14행 (전사·전부 재사용)\n");      print(materials())
    print("\n### 공정 13행 (전사·신규=067/068)\n");     print(processes())
    print("\n### 가격공식 바인딩 (전사)\n");            print(formula_binding())
    print("\n### CPQ 옵션그룹→참조차원 (전사)\n");       print(optgroups())
    print("\n### 추가상품·인쇄옵션·제약 (전사)\n");      print(addons_and_counts())
