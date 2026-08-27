"""게시 위젯 전수 — **상품이 등록한 차원값에 단가가 없는** 구멍 스캔 (읽기전용).

방향이 핵심이다.
  · 단가행 → 상품 (scan_dim_conformance.py): 단가행이 가리키는 값이 상품에 없다.
    공유 공식에 붙은 미해당 구성요소일 수 있어 **결함이 아닐 수 있다**(엔진 '제외' 처리).
  · 상품 → 단가행 (이 스캔): **실무진이 등록한 차원값**인데 대응 단가가 없다.
    고객이 그 값을 고르면 그 항목이 0원으로 청구된다 = **돈 손실**.

기준점 = 실무진이 상품뷰어에 등록한 차원(지니 지시 2026-08-27).

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/scan_dim_gap_reverse.py
"""
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import connection  # noqa: E402


def q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return c.fetchall()


PUB = [r[0] for r in q("""
    SELECT DISTINCT prd_cd FROM t_wgt_widgets
    WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N' ORDER BY 1""")]
BIND = dict(q("""
    SELECT DISTINCT ON (pf.prd_cd) pf.prd_cd, pf.frm_cd
    FROM t_prd_product_price_formulas pf WHERE pf.prd_cd = ANY(%s)
    ORDER BY pf.prd_cd, pf.apply_bgn_ymd DESC""", [PUB]))
NAMES = dict(q("SELECT prd_cd, prd_nm FROM t_prd_products WHERE prd_cd = ANY(%s)", [PUB]))


def use_dims_of(comp_cd):
    r = q("SELECT use_dims FROM t_prc_price_components WHERE comp_cd=%s", [comp_cd])
    v = r[0][0] if r else None
    if isinstance(v, str):
        try:
            v = json.loads(v)
        except (ValueError, TypeError):
            v = []
    return v if isinstance(v, list) else []


print("=" * 92)
print("게시 위젯 전수 — 실무진 등록 옵션에 단가가 없는 구멍 (상품 → 단가행 방향)")
print("=" * 92)

rows_out = []
for prd in PUB:
    frm = BIND.get(prd)
    if not frm:
        continue
    # 상품이 등록한 옵션(필수 그룹 우선) — 옵션그룹은 고객이 반드시 고르는 축
    opts = q("""
        SELECT o.opt_grp_cd, COALESCE(g.opt_grp_nm,'-'), COALESCE(g.mand_yn,'-'),
               o.opt_cd, COALESCE(o.opt_nm,'-')
        FROM t_prd_product_options o
        JOIN t_prd_product_option_groups g
          ON g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd
        WHERE o.prd_cd=%s AND COALESCE(o.del_yn,'N')<>'Y' AND COALESCE(g.del_yn,'N')<>'Y'
        ORDER BY g.disp_seq, o.disp_seq""", [prd])
    if not opts:
        continue
    # 현행 공식에서 opt_cd 축을 쓰는 구성요소
    comps = [c for (c,) in q("""
        SELECT fc.comp_cd FROM t_prc_formula_components fc WHERE fc.frm_cd=%s
        ORDER BY fc.disp_seq""", [frm])]
    opt_comps = [c for c in comps if any(str(d).split(":")[0] == "opt_cd"
                                         for d in use_dims_of(c))]
    if not opt_comps:
        continue
    priced = set()
    for c in opt_comps:
        priced |= {r[0] for r in q(
            "SELECT DISTINCT opt_cd FROM t_prc_component_prices WHERE comp_cd=%s", [c])
            if r[0] is not None}
    for grp, grp_nm, mand, ocd, onm in opts:
        if ocd not in priced:
            rows_out.append((prd, NAMES.get(prd, ""), grp, grp_nm, mand, ocd, onm,
                             ",".join(opt_comps)[:46]))

print(f"{'상품':<13}{'상품명':<16}{'옵션그룹':<13}{'그룹명':<10}{'필수':<5}"
      f"{'옵션코드':<14}{'옵션명':<20}{'단가 보유 구성요소'}")
for r in rows_out:
    print(f"{r[0]:<13}{(r[1] or '')[:14]:<16}{r[2]:<13}{r[3][:8]:<10}{r[4]:<5}"
          f"{r[5]:<14}{r[6][:18]:<20}{r[7]}")

print("\n" + "=" * 92)
prds = sorted({r[0] for r in rows_out})
mand = [r for r in rows_out if r[4] == "Y"]
print(f"단가 없는 등록 옵션 {len(rows_out)}건 · 영향 상품 {len(prds)}건 "
      f"· 그중 **필수 그룹** {len(mand)}건")
print("영향 상품:", ", ".join(prds))
