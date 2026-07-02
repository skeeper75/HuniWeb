#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-048 접지리플렛 전용.

기존 파일럿 공통/형제 전사 스크립트는 수정하지 않는다(기존 수정 금지).
이 스크립트는 PRD_000048(접지리플렛·인쇄홍보물) 노드가 필요로 하는 상품 전용 수치/배선을
라이브 스냅샷에서 결정론적으로 전사한다:
  ① 상품 정체·수량 스칼라(prd_typ_cd·min/max/incr·qty_unit·upload/editor)
  ② 상품 사이즈 행(★라이브 0행 — 사이즈 미등록 사실을 그대로 전사)
  ③ 상품 자재 46행 사양(노드 정의처=기존 재사용 vs 미민팅 표기·★비종이 2건 오염의심 태깅)
  ④ 상품 공정 4행(전부 기존 노드 재사용 — base 인쇄공정 PROC_000004 부재도 그대로 전사)
  ⑤ 인쇄옵션·판형 1행씩
  ⑥ 가격공식 바인딩(★PRF_FOLD_SUM 단일 — 접지비 sub-formula)
  ⑦ PRF_FOLD_SUM 공식→구성요소 배선(★COMP_FOLD_CARD_2H 1건 — 인쇄비/용지비 미배선)
  ⑧ 옵션그룹·추가상품·제약·수량규칙 카운트(전부 0)

노드 파일의 치수·자재·공정·배선표는 이 스크립트가 전사한 것을 그대로 옮긴 것이며
(transcribed-by 마커), 사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_048.py          # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000048"

# 기존 노드 정의처(재사용 — 이 스크립트/노드에서 재-mint 금지·L-3).
# 목록에 없는 mat_cd = 아직 공유 axis 미민팅(needed_shared_nodes로 통합 단계 보고).
MAT_SRC = {
    "MAT_000074": "axis/materials", "MAT_000081": "axis/materials",
    "MAT_000082": "axis/materials", "MAT_000091": "axis/materials",
    "MAT_000092": "axis/materials", "MAT_000101": "axis/materials",
    "MAT_000109": "axis/materials",
    "MAT_000108": "product-027-nodes", "MAT_000123": "product-027-nodes",
    "MAT_000113": "product-023-nodes", "MAT_000114": "product-023-nodes",
    "MAT_000115": "product-023-nodes", "MAT_000116": "product-023-nodes",
    "MAT_000125": "product-023-nodes",
}
# 비종이 자재(오염 의심 — MAT_TYPE.01 아님). 낱장 리플렛에 부적합 = candidate 태깅.
NONPAPER_SUSPECT = {"MAT_000128", "MAT_000130"}

# 공정 전부 기존 노드 재사용(신규 mint 없음).
PROC_SRC = {
    "PROC_000014": "axis/processes", "PROC_000015": "axis/processes",
    "PROC_000031": "axis/processes", "PROC_000032": "axis/processes",
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
    return (f"<!-- transcribed-by: _meta/scripts/transcribe_product_048.py "
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
           "| cat_cd | 분류명 | cat_lvl | upr_cat_cd | 노드 정의처 |", "|---|---|---|---|---|"]
    src = {"CAT_000003": "axis/categories", "CAT_000058": "미민팅(needed_shared_nodes)"}
    for r in rows:
        c = cm.get(r["cat_cd"], {})
        out.append(f'| {r["cat_cd"]} | {c.get("cat_nm")} | {c.get("cat_lvl")} | {c.get("upr_cat_cd")} | {src.get(r["cat_cd"], "미민팅")} |')
    return "\n".join(out)


def sizes():
    rows = prd_rows("t_prd_product_sizes.csv")
    out = [marker("t_prd_product_sizes"),
           f"- 활성 사이즈 행(del_yn=N): **{len(rows)}행**  "
           + ("(★손님 재단사이즈 선택 축 라이브 미등록 — gap-048-no-size)" if not rows
              else "")]
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = prd_rows("t_prd_product_materials.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials"),
           f"- 활성 자재 행(del_yn=N): **{len(rows)}행**",
           "",
           "| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage | 노드 정의처 |",
           "|---|---|---|---|---|---|---|"]
    minted = existing = suspect = 0
    for r in rows:
        m = mm.get(r["mat_cd"], {})
        spec = f'{_mm(m.get("width"))}x{_mm(m.get("height"))}'
        defsrc = MAT_SRC.get(r["mat_cd"])
        if r["mat_cd"] in NONPAPER_SUSPECT:
            defsrc = "★오염의심(candidate·비종이)"; suspect += 1
        elif defsrc:
            existing += 1
        else:
            defsrc = "미민팅(needed_shared)"; minted += 1
        out.append(f'| {r["mat_cd"]} | {m.get("mat_nm")} | {m.get("mat_typ_cd")} | {spec} | {_mm(m.get("weight"))} | {r.get("usage_cd")} | {defsrc} |')
    out.append("")
    out.append(f"- 요약: 기존 노드 재사용 **{existing}** · 미민팅(공유 axis 대기) **{minted}** · 오염의심(비종이) **{suspect}**")
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = prd_rows("t_prd_product_processes.csv")
    rows.sort(key=lambda r: (int(r.get("disp_seq") or 999), r["proc_cd"]))
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | mand | disp_seq | 노드 정의처 |", "|---|---|---|---|---|"]
    for r in rows:
        m = pm.get(r["proc_cd"], {})
        out.append(f'| {r["proc_cd"]} | {m.get("proc_nm")} | {r.get("mand_proc_yn")} | {r.get("disp_seq")} | {PROC_SRC.get(r["proc_cd"], "?")} |')
    # base 인쇄공정 부재 실증
    has_base = any(r["proc_cd"] == "PROC_000004" for r in rows)
    out.append("")
    out.append(f"- base 인쇄공정 PROC_000004 바인딩: **{'있음' if has_base else '없음(★인쇄비 0 신호·§4-A 18건 COMMIT 목록에 048 미포함)'}**")
    return "\n".join(out)


def print_opts_plate():
    po = prd_rows("t_prd_product_print_options.csv")
    pl = prd_rows("t_prd_product_plate_sizes.csv")
    out = [marker("t_prd_product_print_options / t_prd_product_plate_sizes")]
    out.append("| opt_id | print_side | front | back | print_opt_cd |")
    out.append("|---|---|---|---|---|")
    for r in po:
        out.append(f'| {r.get("opt_id")} | {r.get("print_side")} | {r.get("front_colrcnt_cd")} | {r.get("back_colrcnt_cd")} | {r.get("print_opt_cd")} |')
    out.append("")
    out.append("| siz_cd | dflt | output_paper_typ_cd |")
    out.append("|---|---|---|")
    for r in pl:
        out.append(f'| {r.get("siz_cd")} | {r.get("dflt_plt_yn")} | {r.get("output_paper_typ_cd")} |')
    return "\n".join(out)


def formula_binding():
    rows = prd_rows("t_prd_product_price_formulas.csv")
    rows.sort(key=lambda r: r.get("frm_cd"))
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | apply_bgn_ymd | note |", "|---|---|---|"]
    for r in rows:
        out.append(f'| {r["frm_cd"]} | {r.get("apply_bgn_ymd")} | {r.get("note")} |')
    return "\n".join(out)


def formula_components():
    fh = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    compm = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    bound = [r["frm_cd"] for r in prd_rows("t_prd_product_price_formulas.csv")]
    out = [marker("t_prc_formula_components+t_prc_price_components (PRD_000048 바인딩 공식)")]
    for frm in bound:
        h = fh.get(frm, {})
        out.append(f"- **{frm}** ({h.get('frm_nm')}) — {h.get('note')}")
        out.append("")
        out.append("| disp | comp_cd | addtn | 구성요소명 | prc_typ | use_dims | 노드 정의처 |")
        out.append("|---|---|---|---|---|---|---|")
        fc = [r for r in rd("t_prc_formula_components.csv") if r.get("frm_cd") == frm]
        fc.sort(key=lambda r: int(r.get("disp_seq") or 999))
        # 구성요소 노드 존재 여부(digital-components.md 정의분)
        exist = {"COMP_FOLD_CARD_2H", "COMP_PAPER", "COMP_PRINT_DIGITAL_S1",
                 "COMP_COAT_GLOSSY", "COMP_COAT_MATTE", "COMP_CUT_PERF_1H6",
                 "COMP_FOLD_LEAF_HALF", "COMP_FOLD_LEAF_3FOLD", "COMP_FOLD_LEAF_4ACC",
                 "COMP_FOLD_LEAF_4GATE", "COMP_PP_VARTEXT_1EA", "COMP_PP_VARIMG_1EA",
                 "COMP_CUT_FULL_DIECUT", "COMP_PP_CORNER_RIGHT", "COMP_PP_CREASE_1L",
                 "COMP_PP_PERF_1L", "COMP_PRINT_SPOT_WHITE_S1"}
        for r in fc:
            c = compm.get(r["comp_cd"], {})
            d = "formula/digital-components" if r["comp_cd"] in exist else "미민팅"
            out.append(f'| {r.get("disp_seq")} | {r["comp_cd"]} | {r.get("addtn_yn")} | {c.get("comp_nm")} | {c.get("prc_typ_cd")} | {c.get("use_dims")} | {d} |')
        out.append("")
        out.append(f"  - 배선 구성요소 수: **{len(fc)}** "
                   + ("(★인쇄비 COMP_PRINT_DIGITAL_S1·용지비 COMP_PAPER 미배선 = 견적 접지비만)"
                      if not any(x["comp_cd"] in ("COMP_PRINT_DIGITAL_S1", "COMP_PAPER") for x in fc)
                      else ""))
    return "\n".join(out)


def counts():
    og = prd_rows("t_prd_product_option_groups.csv")
    ad = prd_rows("t_prd_product_addons.csv")
    ct = prd_rows("t_prd_product_constraints.csv")
    bq = prd_rows("t_prd_product_bundle_qtys.csv")
    out = [marker("옵션그룹 / 추가상품 / 제약 / 수량규칙 카운트"),
           f"- 옵션그룹(option_groups del_yn=N): {len(og)}",
           f"- 추가상품(addons): {len(ad)}",
           f"- 활성 제약(constraints del_yn=N): {len(ct)}",
           f"- bundle_qtys 행: {len(bq)}  (0=상품 스칼라 수량규칙만)"]
    return "\n".join(out)


if __name__ == "__main__":
    print("### 정체·수량 (전사)\n");                 print(identity())
    print("\n### 카테고리 (전사)\n");                 print(categories())
    print("\n### 사이즈 (전사·★0행)\n");              print(sizes())
    print("\n### 자재 46행 (전사)\n");                print(materials())
    print("\n### 공정 4행 (전사·전부 재사용)\n");      print(processes())
    print("\n### 인쇄옵션·판형 (전사)\n");            print(print_opts_plate())
    print("\n### 가격공식 바인딩 (전사)\n");           print(formula_binding())
    print("\n### 공식→구성요소 배선 (전사·★접지비만)\n"); print(formula_components())
    print("\n### 옵션그룹·추가상품·제약·수량 (전사·전부 0)\n"); print(counts())
