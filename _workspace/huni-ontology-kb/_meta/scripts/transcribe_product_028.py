#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-028 미니접지카드 전용.

기존 파일럿 공통 축 스크립트(transcribe_snapshot.py)나 형제 상품 스크립트
(transcribe_product_027.py 등)는 수정하지 않는다. 이 스크립트는 PRD_000028(미니접지카드)
노드가 필요로 하는 상품 전용 수치/배선을 라이브 스냅샷에서 결정론적으로 전사한다:
  ① 상품 정체·수량 스칼라(prd_typ_cd·min/max/incr·qty_unit·use_yn 미출시)
  ② 상품 사이즈 4행 치수(공유/형제 노드 재사용분은 표에 표기·신규분만 mint)
  ③ 상품 자재 14행 사양(공유/형제 재사용 제외·신규 5종만 mint 대상)
  ④ 상품 공정 목록(박 8종 포함 — 옵션그룹 부재 검증용)
  ⑤ 가격공식 바인딩 행(PRF_DGP_E 단일 — 박 분기 FOIL 미바인딩 검증)
  ⑥ CPQ 옵션그룹/옵션/제약/추가상품 건수(전부 0 검증)

노드 파일의 치수·자재 사양·배선표·건수는 이 스크립트가 전사한 것을 그대로 옮긴 것이며
(transcribed-by 마커), 사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_028.py          # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000028"

# 이미 노드가 있는 것(공유 축 axis/* 또는 형제 상품 nodes.md) — mint 대상에서 제외 표기
# 사이즈: 008/133/499 = axis/sizes.md 재사용. 132/135 = 신규 mint.
EXISTING_SIZE_NODES = {"SIZ_000008", "SIZ_000133", "SIZ_000499",
                       "SIZ_000001", "SIZ_000002", "SIZ_000003",
                       "SIZ_000004", "SIZ_000005", "SIZ_000006", "SIZ_000007"}
# 자재: 074/081/082/091/092/101/109 = axis/materials.md · 108/123 = 027-nodes · 113 = 023-nodes.
# 114/115/116/125 = 신규 mint.
EXISTING_MAT_NODES = {"MAT_000074", "MAT_000081", "MAT_000082", "MAT_000091",
                      "MAT_000092", "MAT_000101", "MAT_000108", "MAT_000109",
                      "MAT_000113", "MAT_000123"}


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
    return (f"<!-- transcribed-by: _meta/scripts/transcribe_product_028.py "
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
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | seq | 노드 |",
           "|---|---|---|---|---|---|---|"]
    for r in rows:
        s = szmaster.get(r["siz_cd"], {})
        work = f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}'
        cut = f'{_mm(s.get("cut_width"))}x{_mm(s.get("cut_height"))}'
        origin = "재사용" if r["siz_cd"] in EXISTING_SIZE_NODES else "신규mint"
        out.append(f'| {r["siz_cd"]} | {s.get("siz_nm")} | {work} | {cut} | {r["dflt_yn"]} | {r["disp_seq"]} | {origin} |')
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = prd_rows("t_prd_product_materials.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials"),
           "| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | seq | 노드 |",
           "|---|---|---|---|---|---|---|---|"]
    for r in rows:
        m = mm.get(r["mat_cd"], {})
        spec = f'{_mm(m.get("width"))}x{_mm(m.get("height"))}'
        origin = "재사용" if r["mat_cd"] in EXISTING_MAT_NODES else "신규mint"
        out.append(f'| {r["mat_cd"]} | {m.get("mat_nm")} | {m.get("mat_typ_cd")} | {spec} | {_mm(m.get("weight"))} | {r["usage_cd"]} | {r["disp_seq"]} | {origin} |')
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = prd_rows("t_prd_product_processes.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["proc_cd"]))
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | mand | seq |", "|---|---|---|---|"]
    for r in rows:
        p = pm.get(r["proc_cd"], {})
        out.append(f'| {r["proc_cd"]} | {p.get("proc_nm")} | {r.get("mand_proc_yn")} | {r.get("disp_seq")} |')
    return "\n".join(out)


def formula_binding():
    rows = [r for r in rd("t_prd_product_price_formulas.csv") if r.get("prd_cd") == PRD]
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | note |", "|---|---|"]
    for r in rows:
        out.append(f'| {r.get("frm_cd")} | {r.get("note")} |')
    return "\n".join(out)


def cpq_counts():
    g = len(prd_rows("t_prd_product_option_groups.csv"))
    o = len(prd_rows("t_prd_product_options.csv"))
    i = len(prd_rows("t_prd_product_option_items.csv"))
    c = len(prd_rows("t_prd_product_constraints.csv"))
    a = len(prd_rows("t_prd_product_addons.csv"))
    b = len(prd_rows("t_prd_product_bundle_qtys.csv"))
    cat = [r.get("cat_cd") for r in prd_rows("t_prd_product_categories.csv")]
    plate = [(r.get("siz_cd"), r.get("output_paper_typ_cd")) for r in prd_rows("t_prd_product_plate_sizes.csv")]
    po = [(r.get("print_opt_cd"), r.get("print_side")) for r in prd_rows("t_prd_product_print_options.csv")]
    out = [marker("CPQ/부수 테이블 건수"),
           "| 테이블 | 건수/값 |", "|---|---|",
           f"| t_prd_product_option_groups | {g} |",
           f"| t_prd_product_options | {o} |",
           f"| t_prd_product_option_items | {i} |",
           f"| t_prd_product_constraints | {c} |",
           f"| t_prd_product_addons | {a} |",
           f"| t_prd_product_bundle_qtys | {b} |",
           f"| t_prd_product_categories | {cat} |",
           f"| t_prd_product_plate_sizes | {plate} |",
           f"| t_prd_product_print_options | {po} |"]
    return "\n".join(out)


if __name__ == "__main__":
    print("### 정체·수량 (전사)\n"); print(identity())
    print("\n### 사이즈 4행 (전사)\n"); print(sizes())
    print("\n### 자재 14행 (전사)\n"); print(materials())
    print("\n### 공정 목록 (전사)\n"); print(processes())
    print("\n### 가격공식 바인딩 (전사)\n"); print(formula_binding())
    print("\n### CPQ/부수 건수 (전사)\n"); print(cpq_counts())
