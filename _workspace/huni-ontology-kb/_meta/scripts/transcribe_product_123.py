#!/usr/bin/env python3
# 전사 스크립트 — product-123 아트패브릭포스터(PRD_000123·실사 area-matrix).
# 권위 = live-snapshot(snap_20260702_1119) t_* CSV. LLM 손전사 금지(§32 [HARD]).
# 실행: python3 transcribe_product_123.py  → stdout의 transcribed-by 마커 표를 노드에 붙임.
# 결정론: 입력 CSV 불변이면 출력 동일(멱등).
import csv, os, sys

PRD = "PRD_000123"
COMP = "COMP_POSTER_ARTPRINT_PHOTO"        # 라이브 동형결합 comp(형식상 4소재 통합·upd 06-18)
FRM = "PRF_POSTER_ARTFABRIC"
HERE = os.path.dirname(os.path.abspath(__file__))
# _meta/scripts → 레포 루트 상대로 live-snapshot 탐색
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
SNAP = os.path.join(ROOT, "_workspace", "_foundation", "live-snapshot", "snap_20260702_1119")
STAMP = "snap_20260702_1119 @ 2026-07-03"

def rows(name):
    with open(os.path.join(SNAP, name + ".csv"), newline="") as f:
        yield from csv.DictReader(f)

def marker(tbl, note=""):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_123.py from live-snapshot/latest ({STAMP}) {tbl} {PRD}{(' '+note) if note else ''} -->"

def emit(title, header, data, tbl, note=""):
    print(f"\n### {title}")
    print(marker(tbl, note))
    print("| " + " | ".join(header) + " |")
    print("|" + "|".join(["---"] * len(header)) + "|")
    for d in data:
        print("| " + " | ".join(str(x) for x in d) + " |")

# 1. 상품 마스터 (차원 범위·수량·상태)
p = next(r for r in rows("t_prd_products") if r["prd_cd"] == PRD)
emit("상품 마스터 (비규격 범위·수량·상태)",
     ["prd_typ", "nonspec", "가로(min~max·incr)", "세로(min~max·incr)", "min_qty", "max_qty", "qty_incr", "file_upload", "editor", "use_yn", "del_yn"],
     [[p["prd_typ_cd"], p["nonspec_yn"],
       f'{p["nonspec_width_min"]}~{p["nonspec_width_max"]}·{p["nonspec_width_incr"]}',
       f'{p["nonspec_height_min"]}~{p["nonspec_height_max"]}·{p["nonspec_height_incr"]}',
       p["min_qty"], p["max_qty"], p["qty_incr"], p["file_upload_yn"], p["editor_yn"], p["use_yn"], p["del_yn"]]],
     "t_prd_products")

# 2. 카테고리
cats = {c["cat_cd"]: c for c in rows("t_cat_categories")}
pc = [r for r in rows("t_prd_product_categories") if r["prd_cd"] == PRD]
emit("카테고리",
     ["cat_cd", "cat_nm", "상위", "lvl", "main_cat", "disp"],
     [[r["cat_cd"], cats.get(r["cat_cd"], {}).get("cat_nm", "?"), cats.get(r["cat_cd"], {}).get("upr_cat_cd", "") or "root",
       cats.get(r["cat_cd"], {}).get("cat_lvl", "?"), r["main_cat_yn"], r["disp_seq"] or ""]
      for r in pc],
     "t_prd_product_categories + t_cat_categories")

# 3. 사이즈 (이산 규격 SIZ)
siz = {s["siz_cd"]: s for s in rows("t_siz_sizes")}
ps = [r for r in rows("t_prd_product_sizes") if r["prd_cd"] == PRD]
emit("사이즈 (이산 규격 · 면적매트릭스 아님)",
     ["siz_cd", "라벨", "작업(mm)", "재단(mm)", "dflt", "링크 del_yn", "마스터 del_yn"],
     [[r["siz_cd"], siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
       f'{siz.get(r["siz_cd"],{}).get("work_width","?")}x{siz.get(r["siz_cd"],{}).get("work_height","?")}',
       f'{siz.get(r["siz_cd"],{}).get("cut_width","?")}x{siz.get(r["siz_cd"],{}).get("cut_height","?")}',
       r["dflt_yn"], r["del_yn"], siz.get(r["siz_cd"], {}).get("del_yn", "?")]
      for r in ps],
     "t_prd_product_sizes + t_siz_sizes")

# 4. 자재 (본체 단일·mat_typ 현재값)
mat = {m["mat_cd"]: m for m in rows("t_mat_materials")}
pm = [r for r in rows("t_prd_product_materials") if r["prd_cd"] == PRD]
emit("자재 (소재별 본체 단일 · mat_typ 현재값)",
     ["mat_cd", "자재명", "mat_typ(현재)", "usage", "dflt", "링크 del_yn"],
     [[r["mat_cd"], mat.get(r["mat_cd"], {}).get("mat_nm", "?"), mat.get(r["mat_cd"], {}).get("mat_typ_cd", "?"),
       r["usage_cd"], r["dflt_yn"], r["del_yn"]]
      for r in pm],
     "t_prd_product_materials + t_mat_materials")

# 5. 판형 (실사=비종이류 → 전부 del_yn=Y·output_paper_typ 공란·판형 없음 증거)
pp = [r for r in rows("t_prd_product_plate_sizes") if r["prd_cd"] == PRD]
emit("판형 (★비종이류 실사 → 전부 논리삭제·output_paper_typ 공란)",
     ["siz_cd", "output_paper_typ", "output_file_typ", "note", "del_yn"],
     [[r["siz_cd"], r["output_paper_typ_cd"] or "(공란)", r["output_file_typ"], r["note"], r["del_yn"]] for r in pp],
     "t_prd_product_plate_sizes")

# 6. 가격공식 바인딩 + 공식→구성요소 배선
pf = [r for r in rows("t_prd_product_price_formulas") if r["prd_cd"] == PRD]
frm = {f["frm_cd"]: f for f in rows("t_prc_price_formulas")}
fc = [r for r in rows("t_prc_formula_components") if r["frm_cd"] == FRM]
emit("가격공식 바인딩 (product→formula) + 배선 (formula→component)",
     ["frm_cd", "frm_nm", "use_yn", "→ comp_cd", "disp", "addtn"],
     [[FRM, frm.get(FRM, {}).get("frm_nm", "?"), frm.get(FRM, {}).get("use_yn", "?"),
       c["comp_cd"], c["disp_seq"], c["addtn_yn"]] for c in fc]
     or [[FRM, frm.get(FRM, {}).get("frm_nm", "?"), frm.get(FRM, {}).get("use_yn", "?"), "(배선 없음)", "", ""]],
     "t_prd_product_price_formulas + t_prc_formula_components")

# 7. 가격구성요소 요약 (D-22 단가행 접기 — 셀 값은 전사 안 함·행수/차원/골든만)
comps = {c["comp_cd"]: c for c in rows("t_prc_price_components")}
n_cells = sum(1 for r in rows("t_prc_component_prices") if r["comp_cd"] == COMP)
c = comps.get(COMP, {})
emit("가격구성요소 요약 (단가행 접기 D-22 · 셀 값 미전사·행수/차원만)",
     ["comp_cd", "comp_nm", "prc_typ", "use_dims", "use_yn", "단가행 수", "골든(note)"],
     [[COMP, c.get("comp_nm", "?"), c.get("prc_typ_cd", "?"), c.get("use_dims", "?"),
       c.get("use_yn", "?"), n_cells, "600×1800=21,600원 (comp note·값=evaluate_price 권위)"]],
     "t_prc_price_components + t_prc_component_prices")

# 8. 미배선/미등록 축 (0행 정직 기록)
def cnt(name):
    return sum(1 for r in rows(name) if r.get("prd_cd") == PRD)
print("\n### 미등록·미배선 축 (0행 정직 기록)")
print(marker("t_prd_product_processes/print_options/bundle_qtys/option_groups/constraints/addons/sets"))
print("| 축 | 라이브 행수 | 해석 |")
print("|---|---|---|")
print(f"| 공정 t_prd_product_processes | {cnt('t_prd_product_processes')} | 면적매트릭스=코팅포함 통가격·공정행 없음(정당) |")
print(f"| 인쇄옵션 t_prd_product_print_options | {cnt('t_prd_product_print_options')} | 실사=도수 컬럼 없음(대형 잉크젯 풀컬러·정당·pack §3.3) |")
print(f"| 수량규칙 t_prd_product_bundle_qtys | {cnt('t_prd_product_bundle_qtys')} | 면적매트릭스=수량축 없음(상품레벨 min/max만·pack §3.4) |")
print(f"| 옵션그룹 t_prd_product_option_groups | {cnt('t_prd_product_option_groups')} | CPQ 옵션 미등록(27 실사 잔존·BATCH-6·pack §3.9) |")
print(f"| 제약 t_prd_product_constraints | {cnt('t_prd_product_constraints')} | 123은 제약 0행(constraints 7상품=118/120/121/122/124/125/139에 123 미포함·pack §1.1) |")
print(f"| 추가상품 t_prd_product_addons | {cnt('t_prd_product_addons')} | 부속 없음(부속붙는 8상품에 123 미포함) |")
print(f"| 셋트 t_prd_product_sets | {cnt('t_prd_product_sets')} | 완제품 단일(셋트 아님·SOT 정합) |")
