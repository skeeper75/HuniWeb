#!/usr/bin/env python3
# 반칼팬시스티커(PRD_000062) 수치 전사 스크립트 (D-9·L-16 — LLM 손전사 금지).
# 라이브 스냅샷(snap_20260702_1119) CSV에서 사이즈·자재·수량·가격격자 충전 실측치를 뽑아
# sticker-spec-fancy-nodes.md 전사표에 삽입할 markdown을 출력한다. 값 계산=evaluate_price 권위(KB 밖).
import csv, os

SNAP = "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest"
PRD = "PRD_000062"
FANCY_SIZES = ["SIZ_000058", "SIZ_000059", "SIZ_000060"]
PLATE_SIZE = "SIZ_000521"
ACTIVE_MATS = ["MAT_000584", "MAT_000609", "MAT_000611", "MAT_000585", "MAT_000586"]


def rows(fn):
    with open(os.path.join(SNAP, fn), newline="") as f:
        return list(csv.DictReader(f))


def main():
    siz = {r["siz_cd"]: r for r in rows("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rows("t_mat_materials.csv")}
    cp = rows("t_prc_component_prices.csv")
    prd = {r["prd_cd"]: r for r in rows("t_prd_products.csv")}

    print("<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from "
          "live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->")
    print("| siz_cd | siz_nm | 작업(mm) | 재단(mm) | 판걸이(note) | del_yn |")
    print("|---|---|---|---|---|---|")
    for s in FANCY_SIZES + [PLATE_SIZE]:
        r = siz[s]
        pangeori = r["note"].split("/")[0].strip() if r.get("note") else "-"
        print(f"| {s} | {r['siz_nm']} | {r['work_width']}x{r['work_height']} | "
              f"{r['cut_width']}x{r['cut_height']} | {pangeori} | {r['del_yn']} |")
    print()

    print("<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from "
          "live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->")
    print("| mat_cd | 자재명 | mat_typ | upr_mat_cd | 평량(g) |")
    print("|---|---|---|---|---|")
    for m in ACTIVE_MATS:
        r = mat[m]
        print(f"| {m} | {r['mat_nm']} | {r['mat_typ_cd']} | {r['upr_mat_cd'] or '-'} | {r['weight'] or '-'} |")
    print()

    p = prd[PRD]
    print("<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from "
          "live-snapshot/latest (snap_20260702_1119) t_prd_products @ 2026-07-03 -->")
    print("| min_qty | max_qty | qty_incr | 단위 | file_upload | editor |")
    print("|---|---|---|---|---|---|")
    print(f"| {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | "
          f"{p['file_upload_yn']} | {p['editor_yn']} |")
    print()

    # 가격격자 충전 실측 (행수만·값 미전사 — D-22 접기·D-18 경계)
    print("<!-- transcribed-by: _meta/scripts/transcribe_sticker_fancy_062.py from "
          "live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT @ 2026-07-03 -->")
    print("| siz_cd | siz_nm | COMP_STK_PRINT 행수(active 5소재) | 상태 |")
    print("|---|---|---|---|")
    for s in FANCY_SIZES:
        per_mat = {}
        total = 0
        for r in cp:
            if r["comp_cd"] == "COMP_STK_PRINT" and r["siz_cd"] == s and r["mat_cd"] in ACTIVE_MATS:
                per_mat[r["mat_cd"]] = per_mat.get(r["mat_cd"], 0) + 1
                total += 1
        status = "격자 충전(silent-0 아님)" if total > 0 else "★격자 0행(silent-0·미충전)"
        detail = ",".join(f"{k.split('_')[-1]}:{v}" for k, v in sorted(per_mat.items())) or "-"
        print(f"| {s} | {siz[s]['siz_nm']} | {total} ({detail}) | {status} |")
    print()
    print("행수 = 연결 증거(단가 값은 미전사·evaluate_price 권위·D-18). 격자 키 = (siz_cd, mat_cd, min_qty).")


if __name__ == "__main__":
    main()
