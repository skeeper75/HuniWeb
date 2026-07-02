#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fill-plan CSV -> 멱등 UPDATE SQL (dryrun/apply/undo). 실행 금지 — 파일만 생성."""
import csv, os
BASE = os.path.dirname(os.path.abspath(__file__))


def rows(name):
    with open(os.path.join(BASE, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


sizes = rows("fill-plan-sizes.csv")
prods = rows("fill-plan-products.csv")

fill = [r for r in sizes if r["verdict"] == "FILL"]
mismatch = [r for r in sizes if r["verdict"] == "MISMATCH"]
band = [r for r in prods if r["verdict"] == "BAND_CONFLICT"]

HDR = """-- ============================================================
-- 제작수량(필수) 규칙 채움 — 사이즈 레벨 빈곳 UPDATE
-- 대상: t_prd_product_sizes (min_qty/max_qty/qty_incr)
-- 권위: 상품마스터 260702(제작수량 컬럼 260610과 동일) + 가격표 최소구간 가드
-- 멱등: 현재 3값 모두 NULL인 사이즈행만 채움(재실행 안전·기존값 미변경)
-- 라이브 쓰기는 인간 승인 후. dflt_qty는 mint 금지(비움).
-- ============================================================
"""


def upd(r):
    return (f"UPDATE t_prd_product_sizes SET min_qty={r['prop_min']}, "
            f"max_qty={r['prop_max']}, qty_incr={r['prop_incr']} "
            f"WHERE prd_cd='{r['prd_cd']}' AND siz_cd='{r['siz_cd']}' AND del_yn='N' "
            f"AND min_qty IS NULL AND max_qty IS NULL AND qty_incr IS NULL;"
            f"  -- {r['prd_nm']} [{r['siz_label']}]")


# ---- dryrun ----
with open(os.path.join(BASE, "qtyrules-fill-dryrun.sql"), "w", encoding="utf-8") as f:
    f.write(HDR)
    f.write("-- 롤백 전용 DRY-RUN: 적용→검증→ROLLBACK (실 반영 없음)\nBEGIN;\n\n")
    f.write("-- [1] 사이즈 빈곳 채움 (FILL " + str(len(fill)) + "건)\n")
    for r in fill:
        f.write(upd(r) + "\n")
    f.write("\n-- [검증] 방금 채운 행 확인\n")
    cds = sorted({r["prd_cd"] for r in fill})
    inlist = ",".join(f"'{c}'" for c in cds)
    f.write(f"SELECT prd_cd, siz_cd, min_qty, max_qty, qty_incr FROM t_prd_product_sizes\n"
            f"  WHERE prd_cd IN ({inlist}) AND del_yn='N' ORDER BY prd_cd, disp_seq;\n\n")
    f.write("ROLLBACK;\n")

# ---- apply ----
with open(os.path.join(BASE, "qtyrules-fill-apply.sql"), "w", encoding="utf-8") as f:
    f.write(HDR)
    f.write("-- ★ 실 COMMIT — 인간 승인 후에만 실행. webadmin 가격시뮬레이터 실화면 확인 후.\nBEGIN;\n\n")
    f.write("-- 사이즈 빈곳 채움 (FILL " + str(len(fill)) + "건)\n")
    for r in fill:
        f.write(upd(r) + "\n")
    f.write("\nCOMMIT;\n")

# ---- undo ----
with open(os.path.join(BASE, "qtyrules-fill-undo.sql"), "w", encoding="utf-8") as f:
    f.write("-- UNDO: apply로 채운 사이즈행을 NULL로 되돌림 (인간 승인 후)\nBEGIN;\n\n")
    for r in fill:
        f.write(f"UPDATE t_prd_product_sizes SET min_qty=NULL, max_qty=NULL, qty_incr=NULL "
                f"WHERE prd_cd='{r['prd_cd']}' AND siz_cd='{r['siz_cd']}' AND del_yn='N' "
                f"AND min_qty={r['prop_min']} AND max_qty={r['prop_max']} AND qty_incr={r['prop_incr']};"
                f"  -- {r['prd_nm']} [{r['siz_label']}]\n")
    f.write("\nCOMMIT;\n")

# ---- 검토 필요분(자동적용 금지): MISMATCH 사이즈 + BAND_CONFLICT 상품 ----
with open(os.path.join(BASE, "qtyrules-review-needed.sql"), "w", encoding="utf-8") as f:
    f.write("-- ============================================================\n")
    f.write("-- 검토 필요(자동 적용 금지) — 인간 판단 후 개별 결정\n")
    f.write("-- ============================================================\n\n")
    f.write("-- [A] 사이즈 MISMATCH: 기존 non-null 값이 권위와 다름 (덮어쓰기 여부 결정)\n")
    for r in mismatch:
        f.write(f"-- {r['prd_nm']} {r['siz_cd']}[{r['siz_label']}] "
                f"현재({r['cur_min']},{r['cur_max']},{r['cur_incr']}) -> 권위({r['prop_min']},{r['prop_max']},{r['prop_incr']})\n")
        f.write(f"-- UPDATE t_prd_product_sizes SET min_qty={r['prop_min']}, max_qty={r['prop_max']}, qty_incr={r['prop_incr']} "
                f"WHERE prd_cd='{r['prd_cd']}' AND siz_cd='{r['siz_cd']}' AND del_yn='N';\n\n")
    f.write("-- [B] 상품 BAND_CONFLICT: 상품마스터 최소 < 가격표 최소구간 → 인상 제안\n")
    f.write("--     ※ 대부분 박(FOIL) 등 옵션 조건부 최소구간 — 인상 시 무옵션/기본 주문 하한도 함께 막힘. 신중.\n")
    for r in band:
        f.write(f"-- {r['prd_nm']}({r['prd_cd']}) 현재min={r['cur_min']} 권위min={r['auth_min']} 가격표min={r['band_min']} -> 제안min={r['prop_min']} | {r['note']}\n")
        f.write(f"-- UPDATE t_prd_products SET min_qty={r['prop_min']} WHERE prd_cd='{r['prd_cd']}';\n\n")

print(f"FILL sizes: {len(fill)} | MISMATCH sizes: {len(mismatch)} | BAND_CONFLICT products: {len(band)}")
print("SQL 생성 완료: dryrun/apply/undo/review-needed")
