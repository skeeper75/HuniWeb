#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
부속 산출물 조립: (A) update-set 통합, (B) step00 코드선적재 CSV(레이저커팅 proc + 066 원형 siz_cd).
조립만 — 값 재도출 0. 라이브 사실(template/proc/siz 실재)은 외부 read-only SELECT 확정분 박제.
"""
import csv, os
ROOT = os.path.dirname(os.path.abspath(__file__))
LOAD = os.path.dirname(ROOT)
OUT_UPD = os.path.join(ROOT, "update-set")
OUT_LOAD = os.path.join(ROOT, "load")

def read_csv(p):
    with open(p, encoding="utf-8") as f:
        return list(csv.DictReader(f))

# ── (A) UPDATE-set 통합 ────────────────────────────────────────────────────
# 각 *_update.csv는 컬럼 갱신(INSERT 아님). 시트 태그 붙여 그대로 결합.
UPDATE_INPUTS = {
    "t_prd_products_qtyunit": [
        "digital-print/load/t_prd_products_qtyunit_update.csv",
        "booklet/t_prd_products_qtyunit_update.csv",
        "stationery/load/t_prd_products_qtyunit_update.csv",
        "sticker/load/t_prd_products_qtyunit_update.csv",
        "calendar/load/t_prd_products_qtyunit_update.csv",
        "acrylic/load/t_prd_products_qtyunit_update.csv",
        "silsa/load/t_prd_products_qtyunit_update.csv",
        "photobook/load/t_prd_products_qtyunit_update.csv",
        "product-accessory/load/t_prd_products_qtyunit_update.csv",
        "goods-pouch/load/t_prd_products_qtyunit_update.csv",
    ],
    "t_prd_products_nonspec": [
        "acrylic/load/t_prd_products_nonspec_update.csv",
        "silsa/load/t_prd_products_nonspec_update.csv",
    ],
    "t_prd_product_materials_thickness": [
        "acrylic/load/t_prd_product_materials_thickness_update.csv",
    ],
    "t_prd_product_print_options_uv": [
        "acrylic/load/t_prd_product_print_options_uv_update.csv",
    ],
    "t_prd_product_processes_excl_link": [
        "calendar/load/t_prd_product_processes_excl_link_update.csv",
    ],
    "t_prd_product_process_excl_groups_note": [
        "calendar/load/t_prd_product_process_excl_groups_note_update.csv",
    ],
}

upd_tally = {}
for name, files in UPDATE_INPUTS.items():
    merged, cols = [], None
    for rel in files:
        p = os.path.join(LOAD, rel)
        if not os.path.exists(p):
            continue
        sheet = rel.split("/")[0]
        rows = read_csv(p)
        if rows and cols is None:
            cols = list(rows[0].keys())
        for r in rows:
            r["_sheet"] = sheet
            merged.append(r)
    if not merged:
        continue
    if "_sheet" not in cols:
        cols = cols + ["_sheet"]
    out = os.path.join(OUT_UPD, f"{name}_update.csv")
    with open(out, "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f); w.writerow(cols)
        for r in merged:
            w.writerow([r.get(c, "") for c in cols])
    upd_tally[name] = len(merged)
    print(f"UPDATE {name}_update.csv = {len(merged)}행")

print(f"\nUPDATE-set 합계 = {sum(upd_tally.values())}행  내역={upd_tally}")

# ── (B) step00 코드선적재 ──────────────────────────────────────────────────
# (B1) 레이저커팅 proc_cd 신설 제안.  t_proc_processes 컬럼:
#   proc_cd,proc_nm,upr_proc_cd,prcs_dtl_opt,disp_seq,use_yn,note,reg_dt,upd_dt,del_yn,del_dt
# 라이브 컷계열 형제: 053 완칼(disp 12)·054 반칼(13)·055 스티커완칼(14). max=PROC_000083.
proc_cols = ["proc_cd","proc_nm","upr_proc_cd","prcs_dtl_opt","disp_seq","use_yn","note","_provenance"]
proc_rows = [{
    "proc_cd":"PROC_000084","proc_nm":"레이저커팅","upr_proc_cd":"","prcs_dtl_opt":"",
    "disp_seq":"15","use_yn":"Y",
    "note":"아크릴 모양컷 도메인공정(레이저커팅). 053 완칼=종이/스티커 전용이라 의미 부정확 → 신설(K-2).",
    "_provenance":"K-2 결정(_confirmation-recommendations.md §10·HANDOFF §3). 라이브 컷계열 형제=053 완칼/054 반칼/055 스티커완칼(전부 종이·스티커). max proc_cd=PROC_000083 → 차순번 PROC_000084. disp_seq=15(055 다음). 아크릴 14상품 완칼행이 이 코드에 의존(blocked-and-gaps.md)."
}]
with open(os.path.join(OUT_LOAD,"00_proc_laser.csv"),"w",encoding="utf-8",newline="") as f:
    w = csv.writer(f); w.writerow(proc_cols)
    for r in proc_rows:
        w.writerow([r.get(c,"") for c in proc_cols])
print(f"\nCODE-PRELOAD 00_proc_laser.csv = {len(proc_rows)}행 (레이저커팅 proc_cd 제안)")

# (B2) sticker 066 원형 siz_cd 제안 (K-4).  t_siz_sizes 컬럼:
#   siz_cd,siz_nm,work_*,cut_*,margin_*,impos_yn,use_yn,note,reg_dt,upd_dt,del_yn,del_dt
# [보정 MAJOR — search-before-mint 강화] siz_nm **전수 매칭**(범위추정 금지).
#   라이브 t_siz_sizes 전수 SELECT 결과: 원형35x35 = SIZ_000422 **이미 실재** → 신설 철회·재사용.
#   나머지 10종(10/15/20/25/30/40/45/50/55/60mm)은 라이브 siz_nm 무매치 → 신설 정당.
# 라이브 실재 siz_nm → siz_cd (read-only SELECT 박제). 발명 0.
LIVE_CIRCLE = {"원형35x35": "SIZ_000422"}   # 라이브 실재(재사용). 그 외 무매치 → mint.
src = read_csv(os.path.join(LOAD,"sticker","_blocked","t_prd_product_sizes_066_circle.BLOCKED.csv"))
siz_cols = ["siz_cd","siz_nm","cut_width","cut_height","impos_yn","use_yn","note","_src_shape","_ea","_mint","_provenance"]
siz_rows = []
n = 500  # 라이브 max siz_cd=SIZ_000500
for i, r in enumerate(src, start=1):
    w = r["_cut_width_mm"]; h = r["_cut_height_mm"]
    wi = str(int(float(w))); hi = str(int(float(h)))
    nm = f"원형{wi}x{hi}"                 # 라이브 형제 명명규칙(원형13x13) 추종
    if nm in LIVE_CIRCLE:
        existing = LIVE_CIRCLE[nm]
        siz_rows.append({
            "siz_cd": existing, "siz_nm": nm,
            "cut_width": f"{float(w):.2f}", "cut_height": f"{float(h):.2f}",
            "impos_yn": "N", "use_yn": "Y",
            "note": f"합판도무송 원형 옵션({r['_l1_shape_name']}). 판당 {r['_ea']}EA는 bundle_qty 차원.",
            "_src_shape": r["_l1_shape_name"], "_ea": r["_ea"], "_mint": "REUSE(라이브 실재)",
            "_provenance": f"[보정 MAJOR] K-4. {r['_l1_shape_name']}={nm} = 라이브 {existing} **이미 실재**(siz_nm 전수 매칭) → 신설 철회·재사용. 066 size link는 {existing} 사용. EA={r['_ea']}=bundle_qty(siz_cd 미인코딩이라 재사용 무영향)."
        })
    else:
        n += 1
        siz_rows.append({
            "siz_cd": f"SIZ_{n:06d}", "siz_nm": nm,
            "cut_width": f"{float(w):.2f}", "cut_height": f"{float(h):.2f}",
            "impos_yn": "N", "use_yn": "Y",
            "note": f"합판도무송 원형 옵션({r['_l1_shape_name']}). 판당 {r['_ea']}EA는 bundle_qty 차원(size 아님).",
            "_src_shape": r["_l1_shape_name"], "_ea": r["_ea"], "_mint": "NEW(라이브 무매치)",
            "_provenance": f"K-4. sticker 066 row{i} {r['_l1_shape_name']}(cut {w}x{h}). 라이브 siz_nm 전수 매칭 무매치 → 신설. 형제 SIZ_000419~422(원형WxH·impos_yn=N). max siz_cd=SIZ_000500 → 차순 SIZ_{n:06d}. EA=판당조각수=bundle_qty(K-4 치수=size축·모양=공정 유지)."
        })
mint_n = sum(1 for r in siz_rows if r["_mint"].startswith("NEW"))
with open(os.path.join(OUT_LOAD,"00_siz_sticker_circle.csv"),"w",encoding="utf-8",newline="") as f:
    w = csv.writer(f); w.writerow(siz_cols)
    for r in siz_rows:   # 전 11종 기록(신설 10 + 재사용 1) — 투명성. 코드선적재 대상=NEW 10종.
        w.writerow([r.get(c,"") for c in siz_cols])
print(f"CODE-PRELOAD 00_siz_sticker_circle.csv = {len(siz_rows)}행 (신설 {mint_n} + 재사용 {len(siz_rows)-mint_n})")
