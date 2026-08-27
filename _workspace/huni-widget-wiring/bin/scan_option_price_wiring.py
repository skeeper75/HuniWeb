"""옵션 → 단가행 배선 커버리지 전수 스캔 (읽기전용).

지니 질문(2026-08-27): 「가격배선이 안된 부분이 없는 건지??」

M1-1N 의 「가격없음」 배지는 **상품 레벨** 가격소스(직접단가/공식) 유무만 본다.
이 스캔은 한 층 아래 — **옵션 레벨**을 본다: 고객이 고를 수 있는 옵션값이 있는데,
그 선택을 값으로 바꿔줄 단가행이 그 상품의 공식 어디에도 없는 경우를 찾는다.

[HARD] 3(§G''.5): 돈 손실 축은 「상품 → 단가행」이다. 「단가행 → 상품」은 돈 손실을
말하지 못한다(공유 공식의 미해당 구성요소를 엔진이 「제외」 처리하므로).

★ 판정 주의 — 「단가 없음」은 결함이 아니다
  완제품가 포함형(권위가 「출력+코팅+가공 포함가」라 적은 경우)이면 옵션 추가비 0 이
  정답이다. 셋트 구성원이면 부모가 청구한다. 그래서 이 스캔의 출력은 **후보**이지
  결함이 아니다. 결함 판정은 권위 대조가 따로 필요하다(M1-1O §I 교훈).

축 대조 (M1-1O §I 교훈 — 단가행의 차원 축은 상품마다 다르다)
  옵션값 → t_prd_product_option_items(ref_dim_cd, ref_key1) 로 차원 해소
    OPT_REF_DIM.03 → 자재(mat_cd)      OPT_REF_DIM.04 → 공정(proc_cd)
  단가행 → t_prc_component_prices 의 mat_cd / proc_cd / opt_cd 중 **어느 축이든** 매칭
  ⇒ 한 축만 보면 거짓 「미배선」이 나온다. 세 축을 모두 본다.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/scan_option_price_wiring.py
"""
import os
import sys
from datetime import datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import connection  # noqa: E402

FOCUS = ["PRD_000136", "PRD_000137"]  # 배너 2종 — 상세 출력


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def one(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    return c.fetchone()


def price_keys(prd_cd):
    """그 상품의 공식이 실제로 값을 매길 수 있는 키 집합 — 세 축 모두."""
    rows = q("""SELECT cp.mat_cd, cp.proc_cd, cp.opt_cd
                  FROM t_prd_product_price_formulas pf
                  JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
                  JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
                                                AND COALESCE(pc.del_yn,'N')='N'
                  JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
                 WHERE pf.prd_cd=%s""", [prd_cd])
    keys = set()
    for r in rows:
        for v in (r["mat_cd"], r["proc_cd"], r["opt_cd"]):
            if v:
                keys.add(v)
    return keys


def live_options(prd_cd):
    """살아있는 옵션그룹의 살아있는 옵션값 + 그 옵션이 해소하는 차원 키."""
    opts = q("""SELECT o.opt_cd, o.opt_nm, g.opt_grp_cd, g.opt_grp_nm
                  FROM t_prd_product_options o
                  JOIN t_prd_product_option_groups g
                       ON g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd
                      AND COALESCE(g.del_yn,'N')='N'
                 WHERE o.prd_cd=%s AND COALESCE(o.del_yn,'N')='N'
                 ORDER BY g.disp_seq, o.disp_seq""", [prd_cd])
    for o in opts:
        o["refs"] = [r["ref_key1"] for r in q(
            """SELECT ref_key1 FROM t_prd_product_option_items
                WHERE prd_cd=%s AND opt_cd=%s AND COALESCE(del_yn,'N')='N'
                  AND ref_key1 IS NOT NULL""", [prd_cd, o["opt_cd"]])]
    return opts


def unwired(prd_cd):
    """값으로 바뀌지 못하는 옵션값 목록 — 후보이지 결함이 아니다."""
    keys = price_keys(prd_cd)
    out = []
    for o in live_options(prd_cd):
        # opt_cd 자체가 단가행 축이거나, 해소된 차원 키가 단가행 축이면 배선됨
        if o["opt_cd"] in keys or any(r in keys for r in o["refs"]):
            continue
        out.append(o)
    return out


def main():
    stamp = one("SELECT to_char(now() AT TIME ZONE 'Asia/Seoul','YYYY-MM-DD HH24:MI:SS')")[0]
    wgt, prd = one("""SELECT COUNT(*), COUNT(DISTINCT prd_cd) FROM t_wgt_widgets
                      WHERE sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(del_yn,'N')='N'""")
    print("=" * 78)
    print(f"[0] 게시 분모 재실측  verbatim: {stamp}|{wgt}|{prd}")

    # ── 1. 배너 2종 상세 ──────────────────────────────────────────────────
    print("=" * 78)
    print("[1] 배너 2종 — 전 축 상세")
    for cd in FOCUS:
        nm = one("SELECT prd_nm FROM t_prd_products WHERE prd_cd=%s", [cd])[0]
        print(f"\n  ▸ {cd} {nm}")
        for label, sql in (
            ("사이즈", "SELECT COUNT(*) FROM t_prd_product_sizes WHERE prd_cd=%s AND COALESCE(del_yn,'N')='N'"),
            ("판형", "SELECT COUNT(*) FROM t_prd_product_plate_sizes WHERE prd_cd=%s AND COALESCE(del_yn,'N')='N'"),
            ("도수", "SELECT COUNT(*) FROM t_prd_product_print_options WHERE prd_cd=%s AND COALESCE(del_yn,'N')='N'"),
            ("공정", "SELECT COUNT(*) FROM t_prd_product_processes WHERE prd_cd=%s AND COALESCE(del_yn,'N')='N'"),
            ("자재", "SELECT COUNT(*) FROM t_prd_product_materials WHERE prd_cd=%s AND COALESCE(del_yn,'N')='N'"),
            ("묶음수", "SELECT COUNT(*) FROM t_prd_product_bundle_qtys WHERE prd_cd=%s"),
            ("페이지룰", "SELECT COUNT(*) FROM t_prd_product_page_rules WHERE prd_cd=%s"),
            ("추가상품", "SELECT COUNT(*) FROM t_prd_product_addons WHERE prd_cd=%s"),
            ("제약규칙", "SELECT COUNT(*) FROM t_prd_product_constraints WHERE prd_cd=%s"),
            ("할인테이블", "SELECT COUNT(*) FROM t_prd_product_discount_tables WHERE prd_cd=%s"),
            ("직접단가", "SELECT COUNT(*) FROM t_prd_product_prices WHERE prd_cd=%s"),
        ):
            print(f"      {label:8} {one(sql, [cd])[0]}")
        print(f"      단가 축 키 {sorted(price_keys(cd)) or '없음'}")
        for o in live_options(cd):
            u = "" if (o["opt_cd"] in price_keys(cd)
                       or any(r in price_keys(cd) for r in o["refs"])) else "  ⚠️ 미배선"
            print(f"      옵션 [{o['opt_grp_nm']}] {o['opt_cd']} {o['opt_nm']} "
                  f"→ {o['refs'] or '차원없음'}{u}")

    # ── 2. 게시 전수 ──────────────────────────────────────────────────────
    print("=" * 78)
    print("[2] 게시 상품 전수 — 값으로 바뀌지 못하는 옵션값")
    pubs = q("""SELECT DISTINCT w.prd_cd, p.prd_nm
                  FROM t_wgt_widgets w LEFT JOIN t_prd_products p ON p.prd_cd=w.prd_cd
                 WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(w.del_yn,'N')='N'
                 ORDER BY w.prd_cd""")
    hits, tot_opt = [], 0
    for p in pubs:
        opts = live_options(p["prd_cd"])
        tot_opt += len(opts)
        u = unwired(p["prd_cd"])
        if u:
            hits.append((p, opts, u))
    print(f"    게시 상품 {len(pubs)} · 살아있는 옵션값 총 {tot_opt}")
    print(f"    미배선 옵션값을 가진 상품 {len(hits)} · 미배선 옵션값 "
          f"{sum(len(u) for _, _, u in hits)}")
    for p, opts, u in hits:
        print(f"\n    ▸ {p['prd_cd']} {p['prd_nm']} — 옵션 {len(opts)} 중 미배선 {len(u)}")
        for o in u[:8]:
            print(f"        [{o['opt_grp_nm']}] {o['opt_cd']} {o['opt_nm']} "
                  f"→ {o['refs'] or '차원없음'}")
        if len(u) > 8:
            print(f"        … 외 {len(u) - 8}건")

    print("\n" + "=" * 78)
    print("  ★ 위 목록은 **후보**다. 완제품가 포함형·셋트 구성원은 0원이 정답이므로,")
    print("    결함 판정에는 권위(가격표·상품마스터) 대조가 따로 필요하다.")
    print(f"완료 {datetime.now():%Y-%m-%d %H:%M:%S}")


if __name__ == "__main__":
    main()
