"""게시 위젯 전수 × 전 차원 정합 스캔 (읽기전용).

기준점 = **실무진이 상품뷰어에 등록한 차원**(지니 지시 2026-08-27).
상품뷰어 12섹션(사이즈·도수/인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰·
옵션그룹·제약규칙·추가상품템플릿·옵션조합자재연결) 중 **가격 차원**에 해당하는 축을
대상으로, 각 게시 상품의 현행 공식 구성요소가 요구하는 use_dims 차원값이 그 상품이
실제 등록한 값으로 도달 가능한지 전수 대조한다.

기존 M1-1C 스캔은 opt_cd 한 축만 봤다. 이 스캔은 전 축으로 확장한 것이다.

판정: 단가행이 그 차원에 값을 지정했는데(distinct 값 ≥1), 상품 등록값과 교집합이
0이면 해당 구성요소는 그 차원에서 영구 no-match → 금액 미도달.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/scan_dim_conformance.py
"""
import json
import os
import sys
from collections import defaultdict

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


# ── 상품이 등록한 차원값 (상품뷰어 섹션 ↔ 가격차원 대응) ────────────────────
# 가격차원 : (상품측 테이블, 컬럼, 상품뷰어 섹션명)
PROVIDER = {
    "siz_cd":       ("t_prd_product_sizes",        "siz_cd",       "사이즈"),
    # 판형 테이블의 판형코드 컬럼명은 siz_cd 다(item_siz_cd 는 완제품사이즈)
    "plt_siz_cd":   ("t_prd_product_plate_sizes",  "siz_cd",       "판형"),
    "mat_cd":       ("t_prd_product_materials",    "mat_cd",       "자재"),
    "print_opt_cd": ("t_prd_product_print_options", "print_opt_cd", "도수/인쇄옵션"),
    "proc_cd":      ("t_prd_product_processes",    "proc_cd",      "공정"),
    "bdl_qty":      ("t_prd_product_bundle_qtys",  "bdl_qty",      "묶음수"),
    "opt_cd":       ("t_prd_product_options",      "opt_cd",       "옵션그룹"),
}
# 상품 차원이 아닌 축(수량·파생값) — 정합 대조 대상 아님
NON_PRODUCT_DIMS = {"min_qty", "siz_width", "siz_height",
                    "coat_side_cnt", "spot_side_cnt", "clr_cd", "opt_grp"}


def has_col(table, col):
    return bool(q("""SELECT 1 FROM information_schema.columns
                     WHERE table_name=%s AND column_name=%s""", [table, col]))


def provided(prd_cd, dim):
    """상품이 등록한 그 차원의 값 집합 (미삭제)."""
    tbl, col, _sec = PROVIDER[dim]
    where = "prd_cd=%s"
    if has_col(tbl, "del_yn"):
        where += " AND COALESCE(del_yn,'N')<>'Y'"
    rows = q(f"SELECT DISTINCT {col} FROM {tbl} WHERE {where}", [prd_cd])
    return {r[0] for r in rows if r[0] is not None}


PUB = [r[0] for r in q("""
    SELECT DISTINCT prd_cd FROM t_wgt_widgets
    WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N' ORDER BY 1""")]

BIND = dict(q("""
    SELECT DISTINCT ON (pf.prd_cd) pf.prd_cd, pf.frm_cd
    FROM t_prd_product_price_formulas pf
    WHERE pf.prd_cd = ANY(%s) ORDER BY pf.prd_cd, pf.apply_bgn_ymd DESC""", [PUB]))

NAMES = dict(q("SELECT prd_cd, prd_nm FROM t_prd_products WHERE prd_cd = ANY(%s)", [PUB]))

print("=" * 84)
print("게시 위젯 전수 × 전 차원 정합 스캔 — 기준점: 실무진 등록 차원(상품뷰어)")
print("=" * 84)
print(f"게시 상품 {len(PUB)} · 공식 바인딩 보유 {len(BIND)} · "
      f"고정가(바인딩 없음) {len(PUB)-len(BIND)}")

defects = []          # (prd, comp, dim, n_price_vals, n_prod_vals, n_hit)
dim_stat = defaultdict(lambda: [0, 0])   # dim -> [검사쌍, 결함쌍]

for prd in PUB:
    frm = BIND.get(prd)
    if not frm:
        continue
    comps = q("""SELECT fc.comp_cd, pc.use_dims
                 FROM t_prc_formula_components fc
                 JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                 WHERE fc.frm_cd=%s ORDER BY fc.disp_seq""", [frm])
    for comp_cd, use_dims in comps:
        # raw cursor 는 JSONField 를 str 로 돌려준다 — 문자 단위 순회 방지
        if isinstance(use_dims, str):
            try:
                use_dims = json.loads(use_dims)
            except (ValueError, TypeError):
                use_dims = []
        if not isinstance(use_dims, list):
            use_dims = []
        for d in use_dims:
            dim = str(d).split(":")[0]
            if dim in NON_PRODUCT_DIMS or dim not in PROVIDER:
                continue
            _tbl, col, _sec = PROVIDER[dim]
            pvals = {r[0] for r in q(
                f"SELECT DISTINCT {col} FROM t_prc_component_prices WHERE comp_cd=%s",
                [comp_cd]) if r[0] is not None}
            if not pvals:
                continue                      # 단가행이 그 차원을 안 씀 → 대조 불필요
            prod = provided(prd, dim)
            hit = pvals & prod
            dim_stat[dim][0] += 1
            if not hit:
                dim_stat[dim][1] += 1
                defects.append((prd, comp_cd, dim, len(pvals), len(prod), 0))

print("\n" + "-" * 84)
print("차원별 집계 (검사쌍 = 상품×구성요소×차원)")
print(f"{'가격차원':<14}{'상품뷰어 섹션':<16}{'검사쌍':>8}{'결함쌍':>8}")
for dim in PROVIDER:
    tot, bad = dim_stat[dim]
    if tot:
        print(f"{dim:<14}{PROVIDER[dim][2]:<16}{tot:>8}{bad:>8}")

print("\n" + "-" * 84)
print(f"차원 불일치 (도달 불가) — {len(defects)}건")
print(f"{'상품':<14}{'상품명':<18}{'구성요소':<44}{'차원':<14}{'단가값':>6}{'상품값':>6}")
for prd, comp, dim, npv, npr, _h in sorted(defects, key=lambda x: (x[2], x[0])):
    print(f"{prd:<14}{(NAMES.get(prd) or '')[:16]:<18}{comp[:42]:<44}{dim:<14}{npv:>6}{npr:>6}")

print("\n" + "=" * 84)
bad_prd = sorted({d[0] for d in defects})
print(f"영향 상품 {len(bad_prd)}건: {', '.join(bad_prd)}")
