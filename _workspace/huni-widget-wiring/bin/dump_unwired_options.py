"""미배선 옵션값 전체 덤프 — 잘림 없이 (읽기전용).

지니 지시(2026-08-27): 「인쇄상품가격표를 확인해서 가격 미정인 부분들을 확정해줘」

`scan_option_price_wiring.py` 는 상품당 8건에서 잘라 보여준다. 권위 대조를 하려면
전량이 필요하므로 이 스크립트는 잘림 없이 TSV 로 덤프한다.

출력 컬럼: 옵션그룹 / 상품코드 / 상품명 / 옵션코드 / 옵션명 / 해소차원

실행: raw/webadmin/.venv/bin/python .../dump_unwired_options.py
"""
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
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def main():
    # 게시 상품의 살아있는 옵션값 + 그 상품 공식이 값을 매길 수 있는 키를 한 번에.
    rows = q("""
        WITH pub AS (
          SELECT DISTINCT w.prd_cd FROM t_wgt_widgets w
           WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(w.del_yn,'N')='N'
        ), keys AS (
          SELECT pf.prd_cd, cp.mat_cd, cp.proc_cd, cp.opt_cd
            FROM t_prd_product_price_formulas pf
            JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
            JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                                          AND COALESCE(pc.del_yn,'N')='N'
            JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
           WHERE pf.prd_cd IN (SELECT prd_cd FROM pub)
        ), opt AS (
          SELECT o.prd_cd, o.opt_cd, o.opt_nm, g.opt_grp_nm,
                 ARRAY_REMOVE(ARRAY_AGG(i.ref_key1), NULL) AS refs
            FROM t_prd_product_options o
            JOIN t_prd_product_option_groups g
                 ON g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd
                AND COALESCE(g.del_yn,'N')='N'
            LEFT JOIN t_prd_product_option_items i
                 ON i.prd_cd=o.prd_cd AND i.opt_cd=o.opt_cd
                AND COALESCE(i.del_yn,'N')='N'
           WHERE o.prd_cd IN (SELECT prd_cd FROM pub) AND COALESCE(o.del_yn,'N')='N'
           GROUP BY o.prd_cd, o.opt_cd, o.opt_nm, g.opt_grp_nm, g.disp_seq, o.disp_seq
        )
        SELECT opt.opt_grp_nm, opt.prd_cd, p.prd_nm, opt.opt_cd, opt.opt_nm, opt.refs
          FROM opt
          LEFT JOIN t_prd_products p ON p.prd_cd=opt.prd_cd
         WHERE NOT EXISTS (
                 SELECT 1 FROM keys k
                  WHERE k.prd_cd=opt.prd_cd
                    AND (k.opt_cd = opt.opt_cd
                         OR k.mat_cd = ANY(opt.refs)
                         OR k.proc_cd = ANY(opt.refs))
               )
         ORDER BY opt.opt_grp_nm, opt.prd_cd, opt.opt_cd
    """)
    print("옵션그룹\t상품코드\t상품명\t옵션코드\t옵션명\t해소차원")
    for r in rows:
        refs = ",".join(r["refs"]) if r["refs"] else "-"
        print(f"{r['opt_grp_nm']}\t{r['prd_cd']}\t{r['prd_nm']}\t{r['opt_cd']}\t"
              f"{r['opt_nm']}\t{refs}")
    print(f"# 합계 {len(rows)}")


if __name__ == "__main__":
    main()
