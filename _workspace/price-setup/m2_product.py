"""M2 — 상품에서 출발한다: 게시 상품 → 필요한 단가행 → 실무진이 붙여넣을 표.

`SPEC-PRICEGRID-001` §1 이 규정한 이 SPEC 의 일:

    「실무진이 상품뷰어를 세팅하고 위젯을 게시했다」고 하면,
     그 상품이 가격을 내기 위해 **필요한 단가행의 표**를 만들어 주는 것.

따라서 **진입점은 권위 엑셀이 아니라 상품이다.** 상품뷰어에 세팅된 것과 위젯에 게시된 것을
먼저 읽고, 거기서 필요한 좌표를 뽑는다. 권위 엑셀은 그 좌표의 **값을 채울 때** 쓴다(§5.1 ②).

    ① 상품뷰어 세팅 + 위젯 게시   ← 이 모듈의 입력
    ② 그 상품에 물린 공식 → 구성요소
    ③ 구성요소마다 필요한 단가행 좌표(= M1 분모)
    ④ 라이브 대조 → **없는 것만** 실무진에게 준다
    ⑤ 붙여넣기 표는 `/grid/` 응답 `dims` 계약대로(REQ-PG-001)

[HARD] 헤더는 `use_dims` 가 아니라 `dims` 로 만든다.
       `proc_grp` 가 있으면 서버가 `proc_cd` **바로 뒤에** 파라미터 컬럼을 끼워 넣는다.
       실측 `COMP_COAT_GLOSSY`: `use_dims` 4개인데 `dims` 는 6개(앞면코팅·뒷면코팅 삽입).
       `use_dims` 로 헤더를 만들면 **컬럼이 2칸 밀려 단가가 엉뚱한 칸에 들어간다**(R-8).

[HARD] 라이브 쓰기 0건. 이 모듈은 읽고 표를 쓸 뿐 저장하지 않는다(REQ-PG-008).
[HARD] 값이 권위에 없으면 **칸을 비운다**. 0 으로 채우지 않는다(REQ-PG-006 · 무료 ≠ 0원).

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m2_product.py PRD_000146
  raw/webadmin/.venv/bin/python _workspace/price-setup/m2_product.py PRD_000146 --tsv out/
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


def _q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return c.fetchall()


# ── ① 상품뷰어 세팅 ──────────────────────────────────────────────────────
# 상품뷰어 각 섹션의 원천 테이블. build_grid.py 의 AXIS_SOURCE 와 같은 경계다.
VIEWER_AXES = [
    ("사이즈",   "t_prd_product_sizes",         "siz_cd",       "t_siz_sizes",        "siz_nm"),
    ("자재",     "t_prd_product_materials",     "mat_cd",       "t_mat_materials",    "mat_nm"),
    ("공정",     "t_prd_product_processes",     "proc_cd",      "t_proc_processes",   "proc_nm"),
    ("인쇄옵션", "t_prd_product_print_options", "print_opt_cd", "t_prt_print_options", "print_opt_nm"),
    ("판형",     "t_prd_product_plate_sizes",   "siz_cd",       "t_siz_sizes",        "siz_nm"),
    ("옵션",     "t_prd_product_options",       "opt_cd",       None,                 None),
]


def product_viewer(prd_cd):
    """상품뷰어에 세팅된 축을 섹션별로 읽는다. 이것이 이 SPEC 의 출발점이다."""
    out = {}
    for label, tbl, col, jt, jn in VIEWER_AXES:
        has_del = bool(_q("""SELECT 1 FROM information_schema.columns
                             WHERE table_name=%s AND column_name='del_yn'""", [tbl]))
        del_clause = " AND COALESCE(a.del_yn,'N') <> 'Y'" if has_del else ""
        if jt:
            sql = (f"SELECT a.{col}, m.{jn} FROM {tbl} a "
                   f"LEFT JOIN {jt} m ON m.{col} = a.{col} "
                   f"WHERE a.prd_cd = %s{del_clause} ORDER BY a.{col}")
        else:
            sql = (f"SELECT a.{col}, a.opt_nm FROM {tbl} a "
                   f"WHERE a.prd_cd = %s{del_clause} ORDER BY a.{col}")
        out[label] = _q(sql, [prd_cd])
    return out


def widget_state(prd_cd):
    """위젯 게시 상태 — 게시되지 않았으면 이 SPEC 의 선행 조건이 안 선 것이다(§1)."""
    rows = _q("""SELECT wgt_cd, wgt_nm, COALESCE(sts_typ_cd,''), COALESCE(use_yn,''),
                        COALESCE(del_yn,'')
                 FROM t_wgt_widgets WHERE prd_cd=%s ORDER BY wgt_cd""", [prd_cd])
    return rows


# ── ② 상품 → 공식 → 구성요소 ────────────────────────────────────────────
def product_components(prd_cd):
    return _q("""SELECT DISTINCT fc.comp_cd, c.comp_nm, c.use_dims::text,
                        c.prc_typ_cd, ppf.frm_cd, f.frm_nm
                   FROM t_prd_product_price_formulas ppf
                   JOIN t_prc_formula_components fc ON fc.frm_cd = ppf.frm_cd
                   JOIN t_prc_price_components c ON c.comp_cd = fc.comp_cd
                   LEFT JOIN t_prc_price_formulas f ON f.frm_cd = ppf.frm_cd
                  WHERE ppf.prd_cd = %s
                  ORDER BY fc.comp_cd""", [prd_cd])


# ── ⑤ 붙여넣기 헤더 — /grid/ dims 계약 ──────────────────────────────────
def grid_contract(comp_cd):
    """`price_views.price_grid` 가 만드는 `dims` 를 같은 코드로 재현한다.

    [HARD] 하드코딩하지 않고, `use_dims` 로부터 재구성하지도 않는다(REQ-PG-001 · AC-PG-004).
    """
    from catalog import price_views as pv
    from catalog import models as M
    comp = M.TPrcPriceComponents.objects.filter(comp_cd=comp_cd).first()
    if not comp:
        return None
    dims = pv._comp_dims(comp)
    _, scopes = pv.split_scopes(comp.use_dims)
    proc_grp = scopes.get("proc_grp")
    param_cols = pv.proc_param_cols(proc_grp) if proc_grp else []
    cols = []
    for d in dims:
        if d == "proc_cd" and proc_grp:
            cols.append({"name": d, "label": pv.DIM_META[d][0], "kind": "fk"})
            cols.extend(param_cols)          # ★ proc_cd 바로 뒤 — 이 위치가 계약이다
            continue
        label, kind, _fm, _fn = pv.DIM_META[d]
        if d == "opt_cd":
            kind = "fk"
        cols.append({"name": d, "label": label, "kind": kind})
    prc_typ = pv.PRC_TYPE_LABEL.get(comp.prc_typ_cd_id, "단가형")
    price_header = {"단가형": "단가", "합가형": "합가", "고정금액": "고정"}.get(prc_typ, "단가")
    header = ["적용일"] + [c["label"] for c in cols] + [price_header, "비고"]
    return {"comp_cd": comp_cd, "comp_nm": comp.comp_nm, "prc_typ": prc_typ,
            "dims": dims, "cols": cols, "header": header, "scopes": scopes,
            "param_keys": [c["name"] for c in param_cols]}


# ── ③④ 격자 + 라이브 대조 ───────────────────────────────────────────────
def component_rows(comp_cd, dims):
    cols = ", ".join(dims)
    return _q(f"""SELECT {cols}, unit_price, apply_ymd FROM t_prc_component_prices
                  WHERE comp_cd=%s ORDER BY apply_ymd, {cols}""", [comp_cd])


def published_products():
    """게시 상품 — 위젯이 게시(WGT_STS_TYPE.02) 상태인 것. 이 SPEC 의 대상 모집단(§1)."""
    return _q("""SELECT DISTINCT p.prd_cd, p.prd_nm
                   FROM t_prd_products p
                   JOIN t_wgt_widgets w ON w.prd_cd = p.prd_cd
                  WHERE COALESCE(p.use_yn,'') = 'Y' AND COALESCE(p.del_yn,'N') <> 'Y'
                    AND w.sts_typ_cd = 'WGT_STS_TYPE.02'
                    AND COALESCE(w.del_yn,'N') <> 'Y'
                  ORDER BY p.prd_cd""")


def sweep(tsv_dir=None):
    """게시 상품 전건 — 어느 상품이 아직 가격을 못 내는지, 무슨 표가 필요한지."""
    prods = published_products()
    print("게시 상품 %d종 — 가격 등록 상태" % len(prods))
    print("=" * 100)
    print(f"  {'상품':30s}{'구성요소':>6s}{'단가행':>7s}{'빈구성요소':>10s}  판정")
    need, ready, blocked = [], [], []
    for prd_cd, prd_nm in prods:
        comps = product_components(prd_cd)
        if not comps:
            blocked.append((prd_cd, prd_nm, "공식 미바인딩 — REQ-PG-009"))
            print(f"  {prd_cd} {str(prd_nm)[:18]:20s}{0:6d}{0:7d}{0:10d}  ★ 공식 미바인딩")
            continue
        tot, empty = 0, []
        for cc, cn, ud, pt, frm, fn in comps:
            n = _q("SELECT count(*) FROM t_prc_component_prices WHERE comp_cd=%s", [cc])[0][0]
            tot += n
            if n == 0:
                empty.append((cc, cn))
        verdict = "가격 등록됨" if not empty else "★ 단가행 0인 구성요소 %d개" % len(empty)
        (ready if not empty else need).append((prd_cd, prd_nm, comps, empty))
        print(f"  {prd_cd} {str(prd_nm)[:18]:20s}{len(comps):6d}{tot:7d}{len(empty):10d}  {verdict}")
    print("=" * 100)
    print(f"  가격 등록됨 {len(ready)}종 · 표가 필요한 상품 {len(need)}종 · 공식 미바인딩 {len(blocked)}종")
    if need:
        print("\n[표가 필요한 상품 — 단가행이 0인 구성요소]")
        for prd_cd, prd_nm, comps, empty in need:
            for cc, cn in empty:
                g = grid_contract(cc)
                print(f"  {prd_cd} {str(prd_nm)[:16]:18s} {cc:28s} {str(cn)[:16]:18s}"
                      f" 헤더 {len(g['header'])}컬럼")
                print(f"      {' | '.join(g['header'])}")
                if tsv_dir:
                    os.makedirs(tsv_dir, exist_ok=True)
                    path = os.path.join(tsv_dir, f"{prd_cd}-{cc}.tsv")
                    with open(path, "w", encoding="utf-8-sig", newline="") as fh:
                        csv.writer(fh, delimiter="\t").writerow(g["header"])
    if blocked:
        print("\n[블로커 — 공식 미바인딩 (격자를 만들지 않는다 · REQ-PG-009)]")
        for prd_cd, prd_nm, why in blocked:
            print(f"  {prd_cd} {str(prd_nm)[:24]:26s} {why}")


def main():
    ap = argparse.ArgumentParser(description="M2 — 상품에서 출발해 필요한 단가행을 낸다")
    ap.add_argument("prd_cd", nargs="?", help="생략하면 게시 상품 전건 스윕")
    ap.add_argument("--tsv", help="붙여넣기 TSV 를 이 디렉터리에 쓴다")
    a = ap.parse_args()

    if not a.prd_cd:
        sweep(a.tsv)
        return

    prd = _q("""SELECT prd_nm, COALESCE(use_yn,''), COALESCE(del_yn,''), prd_typ_cd
                FROM t_prd_products WHERE prd_cd=%s""", [a.prd_cd])
    if not prd:
        print("상품 없음: %s" % a.prd_cd)
        return
    nm, use_yn, del_yn, typ = prd[0]
    print("=" * 92)
    print(f"{a.prd_cd}  {nm}   use_yn={use_yn} del_yn={del_yn} 유형={typ}")
    print("=" * 92)

    # ① 위젯 게시 — 선행 조건
    w = widget_state(a.prd_cd)
    print("\n[①-a 위젯 게시 상태]  — 이 SPEC 의 선행 조건(§1)")
    if not w:
        print("   위젯 없음 — 게시되지 않았다. 이 SPEC 의 전제가 서지 않는다.")
    for r in w:
        print(f"   {r[0]}  {str(r[1])[:26]:28s} 상태={r[2]:12s} use={r[3]} del={r[4]}")

    # ① 상품뷰어 세팅
    print("\n[①-b 상품뷰어 세팅]  — 실무진이 세팅한 것")
    pv_axes = product_viewer(a.prd_cd)
    for label, rows in pv_axes.items():
        if not rows:
            print(f"   {label:8s} —")
            continue
        show = ", ".join(f"{c}({str(n)[:12]})" if n else str(c) for c, n in rows[:6])
        more = f" 외 {len(rows)-6}종" if len(rows) > 6 else ""
        print(f"   {label:8s} {len(rows):2d}종  {show}{more}")

    # ② 상품 → 공식 → 구성요소
    comps = product_components(a.prd_cd)
    print(f"\n[② 물린 공식·구성요소]  {len(comps)}개")
    if not comps:
        print("   공식 미바인딩 — 격자를 만들지 않고 블로커로 보고한다(REQ-PG-009 · AC-PG-009)")
        return
    for cc, cn, ud, pt, frm, fn in comps:
        print(f"   {cc:28s} {str(cn)[:20]:22s} 공식={frm} {str(fn)[:18]}")

    # ③④⑤ 구성요소마다
    for cc, cn, ud, pt, frm, fn in comps:
        g = grid_contract(cc)
        rows = component_rows(cc, g["dims"])
        print("\n" + "-" * 92)
        print(f"[③ {cc}]  {cn}   ({g['prc_typ']})")
        print(f"   use_dims = {ud}")
        print(f"   dims     = {g['dims']}" +
              (f"   + 파라미터 {g['param_keys']}" if g["param_keys"] else ""))
        print(f"   붙여넣기 헤더 ({len(g['header'])}컬럼):")
        print(f"      {' | '.join(g['header'])}")
        if g["param_keys"]:
            print(f"   ★ 파라미터 컬럼이 `proc_cd` 바로 뒤에 있다 — use_dims 로 만들면"
                  f" {len(g['header'])-len(g['param_keys'])}컬럼이 되어 {len(g['param_keys'])}칸 밀린다")
        print(f"   [④ 라이브] 현재 단가행 {len(rows)}행")

        if a.tsv:
            os.makedirs(a.tsv, exist_ok=True)
            path = os.path.join(a.tsv, f"{a.prd_cd}-{cc}.tsv")
            with open(path, "w", encoding="utf-8-sig", newline="") as fh:
                w2 = csv.writer(fh, delimiter="\t")
                w2.writerow(g["header"])
                for r in rows:
                    w2.writerow([r[-1]] + list(r[:len(g["dims"])]) + [r[-2], ""])
            print(f"   → {path}")


if __name__ == "__main__":
    main()
