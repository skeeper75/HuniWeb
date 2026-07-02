#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-049 와이드 접지리플렛 전용.

기존 파일럿 공통/형제 스크립트(transcribe_product_027.py·029.py 등)는 수정하지 않는다.
이 스크립트는 PRD_000049(와이드 접지리플렛·인쇄홍보물) 노드가 필요로 하는 상품 전용
수치/배선을 라이브 스냅샷에서 결정론적으로 전사한다:
  ① 상품 정체·수량 스칼라(prd_typ_cd·min/max/incr·qty_unit)
  ② 상품 사이즈 1행 치수(★신규 mint SIZ_000055 640x297 와이드)
  ③ 상품 자재 5행 사양(★신규 mint MAT_000083/093/110/111/112 "3절" 계열)
  ④ 상품 공정 7행(★신규 mint=PROC_000060 3단접지·PROC_000071 병풍접지, 나머지 재사용)
  ⑤ 판형(★신규 mint plate OUTPUT_PAPER_TYPE.03 기타 — 국전 초과 와이드)
  ⑥ 가격공식 바인딩(PRF_DGP_E 재사용·frm_nm에 "접지리플렛" 명시)
  ⑦ 인쇄옵션·옵션그룹·추가상품·제약·수량규칙 카운트(옵션그룹 0 = CPQ 미등록)

노드 파일의 치수·자재·공정·판형·배선표는 이 스크립트가 전사한 것을 그대로 옮긴 것이며
(transcribed-by 마커), 사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_049.py          # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000049"

# 기존 노드 정의처(재사용 — 이 스크립트/노드에서 재-mint 금지·L-3)
PROC_SRC = {
    "PROC_000004": "axis/processes", "PROC_000014": "axis/processes",
    "PROC_000015": "axis/processes", "PROC_000031": "axis/processes",
    "PROC_000032": "axis/processes",
    # PROC_000060(3단접지)·PROC_000071(병풍접지) = 신규(이 상품 전용 마스터)
}
NEW_PROCS = ["PROC_000060", "PROC_000071"]
# 자재: MAT_000110은 형제 030(지그재그엽서)이 이미 정의 → 재사용(L-3). 나머지 4종 신규.
MAT_SRC = {
    "MAT_000110": "product-030-nodes",
}
# 판형 .03(기타)도 형제 030이 이미 정의 → 재사용(L-3). 카테고리 CAT_000058·사이즈 SIZ_000055·자재 4종은 신규.
PLATE_SRC = {
    "OUTPUT_PAPER_TYPE.03": "product-030-nodes",
}


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
    return (f"<!-- transcribed-by: _meta/scripts/transcribe_product_049.py "
            f"from {SNAP_ID} {tbl} prd_cd={PRD} @ {STAMP} -->")


def identity():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}[PRD]
    out = [marker("t_prd_products"), "| 필드 | 값 |", "|---|---|"]
    for k in ["prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
              "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]:
        out.append(f"| {k} | {p.get(k)} |")
    return "\n".join(out)


def categories():
    cm = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    rows = prd_rows("t_prd_product_categories.csv")
    out = [marker("t_prd_product_categories+t_cat_categories"),
           "| cat_cd | 분류명 | lvl | 상위 | 노드 정의처 |", "|---|---|---|---|---|"]
    for r in rows:
        c = cm.get(r["cat_cd"], {})
        src = "axis/categories" if r["cat_cd"] == "CAT_000003" else "product-049-nodes (신규)"
        out.append(f'| {r["cat_cd"]} | {c.get("cat_nm")} | {c.get("cat_lvl")} | {c.get("upr_cat_cd") or "-"} | {src} |')
    return "\n".join(out)


def sizes():
    szmaster = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = prd_rows("t_prd_product_sizes.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["siz_cd"]))
    out = [marker("t_prd_product_sizes+t_siz_sizes"),
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | 노드 정의처 |",
           "|---|---|---|---|---|---|"]
    for r in rows:
        s = szmaster.get(r["siz_cd"], {})
        work = f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}'
        cut = f'{_mm(s.get("cut_width"))}x{_mm(s.get("cut_height"))}'
        out.append(f'| {r["siz_cd"]} | {s.get("siz_nm")} | {work} | {cut} | {r["dflt_yn"]} | product-049-nodes (신규) |')
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = prd_rows("t_prd_product_materials.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials"),
           "| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | 노드 정의처 |",
           "|---|---|---|---|---|---|---|"]
    for r in rows:
        m = mm.get(r["mat_cd"], {})
        spec = f'{_mm(m.get("width"))}x{_mm(m.get("height"))}'
        src = MAT_SRC.get(r["mat_cd"], "product-049-nodes (신규)")
        out.append(f'| {r["mat_cd"]} | {m.get("mat_nm")} | {m.get("mat_typ_cd")} | {spec} | {_mm(m.get("weight"))} | {r["usage_cd"]} | {src} |')
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
        src = PROC_SRC.get(r["proc_cd"], "product-049-nodes (신규)")
        out.append(f'| {r["proc_cd"]} | {m.get("proc_nm")} | {r.get("mand_proc_yn")} | {r.get("disp_seq")} | {src} |')
    return "\n".join(out)


def plate():
    szmaster = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = prd_rows("t_prd_product_plate_sizes.csv")
    out = [marker("t_prd_product_plate_sizes(+t_siz_sizes 출력용지규격)"),
           "| 출력용지유형 | 출력용지 siz_cd | 출력용지 규격 | dflt | 노드 정의처 |", "|---|---|---|---|---|"]
    for r in rows:
        s = szmaster.get(r.get("siz_cd"), {})
        spec = f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}'
        src = PLATE_SRC.get(r.get("output_paper_typ_cd"), "product-049-nodes (신규)")
        out.append(f'| {r.get("output_paper_typ_cd")} | {r.get("siz_cd")} | {spec} | {r.get("dflt_plt_yn")} | {src} |')
    return "\n".join(out)


def formula_binding():
    pf = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    fc = {}
    for r in rd("t_prc_formula_components.csv"):
        fc.setdefault(r["frm_cd"], 0)
        fc[r["frm_cd"]] += 1
    rows = prd_rows("t_prd_product_price_formulas.csv")
    rows.sort(key=lambda r: r.get("frm_cd"))
    out = [marker("t_prd_product_price_formulas(+t_prc_price_formulas·formula_components)"),
           "| frm_cd | frm_nm | apply_bgn_ymd | formula_components(배선수) | 노드 정의처 |",
           "|---|---|---|---|---|"]
    for r in rows:
        f = pf.get(r["frm_cd"], {})
        out.append(f'| {r["frm_cd"]} | {f.get("frm_nm")} | {r.get("apply_bgn_ymd")} | {fc.get(r["frm_cd"], 0)} | formula/digital-formulas (재사용) |')
    return "\n".join(out)


def counts():
    po = prd_rows("t_prd_product_print_options.csv")
    og = prd_rows("t_prd_product_option_groups.csv")
    ad = prd_rows("t_prd_product_addons.csv")
    ct = prd_rows("t_prd_product_constraints.csv")
    bq = prd_rows("t_prd_product_bundle_qtys.csv")
    out = [marker("t_prd_product_print_options / option_groups / addons / constraints / bundle_qtys")]
    out.append(f"- 인쇄옵션 행: {len(po)}" + (f" (opt_id={po[0].get('opt_id')} print_side={po[0].get('print_side')} front={po[0].get('front_colrcnt_cd')} back={po[0].get('back_colrcnt_cd')})" if po else ""))
    out.append(f"- CPQ 옵션그룹 행: {len(og)}  (0=옵션그룹 미등록=CPQ 손님선택축 없음)")
    out.append(f"- 추가상품(addon) 행: {len(ad)}")
    out.append(f"- 활성 제약(constraints del_yn=N): {len(ct)}")
    out.append(f"- bundle_qtys 행: {len(bq)}  (0=상품 스칼라 수량규칙만)")
    return "\n".join(out)


if __name__ == "__main__":
    print("### 정체·수량 (전사)\n");                  print(identity())
    print("\n### 카테고리 (전사)\n");                   print(categories())
    print("\n### 사이즈 1행 (전사·신규 mint)\n");        print(sizes())
    print("\n### 자재 5행 (전사·신규 mint)\n");          print(materials())
    print("\n### 공정 7행 (전사·신규=060/071)\n");       print(processes())
    print("\n### 판형 (전사·신규 mint .03 기타)\n");     print(plate())
    print("\n### 가격공식 바인딩 (전사·재사용)\n");       print(formula_binding())
    print("\n### 인쇄옵션·옵션그룹·추가상품·제약·수량 (전사)\n"); print(counts())
