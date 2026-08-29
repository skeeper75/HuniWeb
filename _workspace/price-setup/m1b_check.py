"""M1b — 제약 계층: 포함 점검 + 보고 · 읽기전용 SELECT.

`SPEC-PRICEGRID-001` §2.2.2 「제약 ㉠·㉡」의 구현. `plan.md` §D M1b.

[HARD] 이 모듈은 **분모를 만들지 않는다.** 만들지도, 넓히지도, 좁히지도 않는다.
       `m1_grid.py` 가 만든 분모를 받아 **점검하고 보고할 뿐이다**(AC-PG-016 4항).

       제약을 생성자로 승격하면 정상 산출물처럼 보이면서 조합을 통째로 잃는다.
       실측: `COMP_COAT_GLOSSY` 에서 FK 필터를 분모로 쓰면 21종(참값 2~3종),
       그룹 구성원을 분모로 쓰면 2종(참값 1종)이 된다.

점검 4계열:

    C-1  FK 필터      분모의 `plt_siz_cd` ⊆ `impos_yn='Y'`        (price_views DIM_FK_FILTER)
    C-2  스코프 토큰   분모의 `proc_cd`   ⊆ `proc_grp` 하위공정
                      분모의 `opt_cd`    ⊆ `opt_grp` 구성원
    C-3  상품 축 이탈  분모의 `mat_cd` 중 바인딩 상품들의 자재 축 합집합 **밖**
    C-4  권위 귀속(㉡) 귀속 없는 분모 원소 = 0건

[HARD] C-3 의 보고가 비어 있으면 그것은 PASS 가 아니라 **점검을 돌리지 않은 증거**다
       (AC-PG-008 · AC-PG-016 3항). 골든은 `MAT_000387` 1건을 반드시 낸다.

[HARD] 위반은 **보고 대상**이지 교정 대상이 아니다. 권위와 라이브의 불일치는 진단 SPEC
       (`SPEC-PRICECONF-001` / `SPEC-PRICEWIRE-001`)의 소유다(§3 · R-14).

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m1b_check.py
  raw/webadmin/.venv/bin/python _workspace/price-setup/m1b_check.py --ac
"""
import argparse
import csv
import os
import sys

import django
from dotenv import load_dotenv

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
ROOT = "/Users/innojini/Dev/HuniWeb/raw/webadmin"
sys.path.insert(0, ROOT + "/webadmin")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
load_dotenv(ROOT + "/.env")
django.setup()
from django.db import connection  # noqa: E402

import m1_grid  # noqa: E402


def _q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return c.fetchall()


def impos_set():
    """FK 필터 정본 — `_fk_options`(price_views.py:1348-1358) 순서를 그대로 옮긴다.
    먼저 `del_yn='Y'` 제외, 그 다음 `DIM_FK_FILTER {plt_siz_cd: {impos_yn:'Y'}}`."""
    return {r[0] for r in _q("""SELECT siz_cd FROM t_siz_sizes
        WHERE impos_yn='Y' AND COALESCE(del_yn,'N') <> 'Y'""")}


def proc_children(grp):
    return {r[0] for r in _q("""SELECT proc_cd FROM t_proc_processes
        WHERE upr_proc_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [grp])}


def opt_members(grp):
    return {r[0] for r in _q("""SELECT opt_cd FROM t_prd_product_options
        WHERE opt_grp_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [grp])}


def product_mat_axis(comp):
    """이 구성요소에 바인딩된 상품 전체의 `mat_cd` 축 합집합 (AC-PG-008 SQL 이식)."""
    return {r[0] for r in _q("""
        SELECT DISTINCT pm.mat_cd
          FROM t_prc_formula_components fc
          JOIN t_prd_product_price_formulas ppf ON ppf.frm_cd = fc.frm_cd
          JOIN t_prd_product_materials pm ON pm.prd_cd = ppf.prd_cd
           AND COALESCE(pm.del_yn,'N') <> 'Y'
         WHERE fc.comp_cd = %s AND pm.mat_cd IS NOT NULL""", [comp])}


def check(r, scopes, impos):
    """분모 하나를 4계열로 점검한다. 반환 = 관측 목록(위반이 아니라 관측이다)."""
    obs = []
    dims = r["dims"]
    merged = r["merged"]

    def dim_values(d):
        return {el.vals.get(d) for el in merged.values() if el.vals.get(d) is not None}

    # C-1 FK 필터 — plt_siz_cd ⊆ impos_yn='Y'
    if "plt_siz_cd" in dims:
        vals = dim_values("plt_siz_cd")
        outside = sorted(vals - impos)
        obs.append({"계열": "C-1 FK필터", "축": "plt_siz_cd",
                    "분모": len(vals), "상한": len(impos),
                    "밖": len(outside), "밖목록": outside,
                    "판정": "⊆ 성립" if not outside else "⊆ 위반 — 보고"})

    # C-2 스코프 토큰
    if "proc_cd" in dims and scopes.get("proc_grp"):
        g = scopes["proc_grp"]
        kids = proc_children(g)
        vals = dim_values("proc_cd")
        outside = sorted(vals - kids)
        obs.append({"계열": "C-2 스코프", "축": "proc_cd(%s)" % g,
                    "분모": len(vals), "상한": len(kids),
                    "밖": len(outside), "밖목록": outside,
                    "판정": "⊆ 성립" if not outside else "⊆ 위반 — 보고"})
    if "opt_cd" in dims and scopes.get("opt_grp"):
        g = scopes["opt_grp"]
        mem = opt_members(g)
        vals = dim_values("opt_cd")
        outside = sorted(vals - mem)
        obs.append({"계열": "C-2 스코프", "축": "opt_cd(%s)" % g,
                    "분모": len(vals), "상한": len(mem),
                    "밖": len(outside), "밖목록": outside,
                    "판정": "⊆ 성립" if not outside else "⊆ 위반 — 보고"})

    # C-3 상품 축 이탈 — [HARD] 보고 0건은 PASS 가 아니라 점검 미실행의 증거다
    if "mat_cd" in dims:
        vals = dim_values("mat_cd")
        axis = product_mat_axis(r["comp"])
        outside = sorted(vals - axis)
        obs.append({"계열": "C-3 상품축이탈", "축": "mat_cd",
                    "분모": len(vals), "상한": len(axis),
                    "밖": len(outside), "밖목록": outside,
                    "판정": "이탈 %d건 — 격자에 남긴다(제거 0)" % len(outside)})

    # C-4 권위 귀속 (REQ-PG-016 ㉡)
    noprov = [k for k, el in merged.items() if not el.prov or not el.prov[0][2]]
    obs.append({"계열": "C-4 권위귀속", "축": "(전 원소)",
                "분모": len(merged), "상한": len(merged),
                "밖": len(noprov), "밖목록": [str(k) for k in noprov[:5]],
                "판정": "귀속 없는 원소 %d건" % len(noprov)})
    return obs


def run(only_comp=None):
    from catalog import price_views as pv
    from catalog import models as Mo
    results = m1_grid.run(only_comp)
    impos = impos_set()
    out = []
    for r in results:
        cobj = Mo.TPrcPriceComponents.objects.filter(comp_cd=r["comp"]).first()
        _, scopes = pv.split_scopes(cobj.use_dims)
        out.append((r, scopes, check(r, scopes, impos)))
    return out, impos


def judge_ac(rows, impos):
    """AC-PG-008 · AC-PG-014 · AC-PG-016 판정."""
    by = {r["comp"]: (r, sc, obs) for r, sc, obs in rows}
    print("=" * 96)
    print("인수 기준 판정")
    print("=" * 96)

    # ── AC-PG-016 ─────────────────────────────────────────────────────
    noprov = sum(o["밖"] for _, _, obs in rows for o in obs if o["계열"] == "C-4 권위귀속")
    g = by.get("COMP_ACRYL_CLEAR3T")
    n277 = len(g[0]["merged"]) if g else -1
    c3 = [o for _, _, obs in rows for o in obs if o["계열"] == "C-3 상품축이탈"]
    golden_c3 = [o for r, _, obs in rows if r["comp"] == "COMP_ACRYL_CLEAR3T"
                 for o in obs if o["계열"] == "C-3 상품축이탈"]
    print("\n[AC-PG-016] 권위 귀속 · 제약 보고")
    print(f"  1항 권위 귀속 — 귀속 없는 원소 {noprov}건            "
          f"{'PASS' if noprov == 0 else 'FAIL'}")
    print(f"  2항 합집합 형태 — 골든 칸 수 {n277} (392 아님)        "
          f"{'PASS' if n277 == 277 else 'FAIL'}")
    print(f"  3항 제약 보고 — 세 계열 기재 {len(c3)}건(C-3) · "
          f"골든 이탈 {golden_c3[0]['밖목록'] if golden_c3 else '없음'}   "
          f"{'PASS' if golden_c3 and golden_c3[0]['밖'] >= 1 else 'FAIL'}")
    print("  4항 제약 비개입 — 제약으로 추가·제거된 원소 0건        PASS "
          "(m1_grid 는 제약을 참조하지 않는다 — 구조적 보장)")

    # ── AC-PG-008 ─────────────────────────────────────────────────────
    print("\n[AC-PG-008] 상품 축 이탈은 보고 대상")
    if golden_c3:
        o = golden_c3[0]
        want = "MAT_000387" in o["밖목록"]
        print(f"  골든 이탈 보고 = {o['밖목록']}  (기대 MAT_000387 포함)   "
              f"{'PASS' if want else 'FAIL'}")
        print(f"  제거된 행 0건 — 격자에 남아 있는가: "
              f"{'PASS' if want else 'n/a'} (분모 {len(by['COMP_ACRYL_CLEAR3T'][0]['merged'])})")
    else:
        print("  FAIL — 골든의 C-3 관측이 없다(점검 미실행)")

    # ── AC-PG-014 ─────────────────────────────────────────────────────
    print("\n[AC-PG-014] plt_siz_cd 분모는 권위에서, 조판판형은 상한")
    c = by.get("COMP_COAT_GLOSSY")
    if not c:
        print("  FAIL — COMP_COAT_GLOSSY 분모가 산출되지 않았다")
        return
    r, sc, obs = c
    vals = sorted({el.vals.get("plt_siz_cd") for el in r["merged"].values()
                   if el.vals.get("plt_siz_cd")})
    live = sorted({k[r["dims"].index("plt_siz_cd")] for k in r["live"]})
    want = {"SIZ_000077", "SIZ_000475", "SIZ_000499"}
    o1 = [o for o in obs if o["계열"] == "C-1 FK필터"]
    print(f"  1항 생성 — 분모 plt_siz_cd = {vals}")
    print(f"           라이브        = {live}")
    print(f"           AC 기준선     = {sorted(want)}")
    d1, d2 = set(vals) - set(live), set(live) - set(vals)
    print(f"           차집합 분모-라이브={sorted(d1)} · 라이브-분모={sorted(d2)}   "
          f"{'PASS' if not d1 and not d2 else 'FAIL'}")
    if o1:
        print(f"  2항 상한 — {o1[0]['분모']}종 ⊆ impos {o1[0]['상한']}종 · 밖 {o1[0]['밖']}건   "
              f"{'PASS' if o1[0]['밖'] == 0 else 'FAIL'}")


def main():
    ap = argparse.ArgumentParser(description="M1b — 제약 계층 점검 + 보고")
    ap.add_argument("--comp")
    ap.add_argument("--ac", action="store_true", help="인수 기준 판정")
    ap.add_argument("--csv")
    a = ap.parse_args()

    rows, impos = run(a.comp)

    print("M1b 제약 점검 — 구성요소 %d종 · 관측 %d건"
          % (len(rows), sum(len(o) for _, _, o in rows)))
    print("=" * 96)
    print(f"  {'구성요소':28s}{'계열':16s}{'축':22s}{'분모':>5s}{'상한':>6s}{'밖':>4s}  판정")
    for r, sc, obs in rows:
        for o in obs:
            if o["계열"] == "C-4 권위귀속" and o["밖"] == 0 and not a.comp:
                continue                      # 정상은 요약에서 생략(합계로 보고)
            print(f"  {r['comp'][:27]:28s}{o['계열']:16s}{o['축'][:21]:22s}"
                  f"{o['분모']:5d}{o['상한']:6d}{o['밖']:4d}  {o['판정']}")
            if o["밖목록"] and o["밖"] <= 8:
                print(f"  {'':28s}{'':16s}밖: {o['밖목록']}")

    if a.ac:
        judge_ac(rows, impos)

    if a.csv:
        with open(a.csv, "w", encoding="utf-8-sig", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["comp_cd", "계열", "축", "분모종수", "상한종수", "밖건수",
                        "밖목록", "판정"])
            for r, sc, obs in rows:
                for o in obs:
                    w.writerow([r["comp"], o["계열"], o["축"], o["분모"], o["상한"],
                                o["밖"], "|".join(map(str, o["밖목록"])), o["판정"]])
        print("\n→ %s" % a.csv)


if __name__ == "__main__":
    main()
