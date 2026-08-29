"""M1 — 권위 하위표 합집합으로 격자 분모를 생성 · 읽기전용 SELECT.

`SPEC-PRICEGRID-001` §2.2.2 의 4단계 중 3·4단계다(1·2단계는 M3 = `m3_map` · `m3_axis`).

    1. 구성요소 → 권위 하위표 매핑 (1:N)      → m3_map
    2. 축 라벨 → 차원 코드 번역   (1:N)      → m3_axis
    3. **하위표별 교차곱**                    → 이 모듈
    4. **하위표 합집합**                      → 이 모듈

[HARD] 4단계를 「구성요소 전체 차원값 집합의 교차곱」으로 축약하지 않는다.
       하위표마다 축의 범위가 다르다. 골든 케이스 실측:

           B01 투명아크릴3T   14(가로) × 14(세로) = 196
           B02 투명아크릴1.5T  9(가로) ×  9(세로) =  81
           합집합                                 = 277  ← 라이브 277 과 일치
           전체 교차곱  2(자재) × 14 × 14         = 392  ← 틀린 값

[HARD] 분모의 원소마다 **권위 귀속**을 함께 싣는다 — 어느 하위표의 어느 축 라벨에서
       왔는지. AC-PG-016 1항의 판정 대상이고, REQ-PG-016 ㉡ 폴백이 그것 없이는
       성립하지 않는다. 「채웠으나 틀린」 분모는 빈 분모(㉠)로는 잡히지 않는다 —
       상품 축·FK 필터·그룹 구성원은 언제나 무언가를 돌려주기 때문이다.

[HARD] 분모는 권위가 만든다. 라이브는 **대조 대상**이지 생성자가 아니다.
       라이브에만 있는 행(잉여)은 보고하고 **삭제를 제안하지 않는다**(P-2).
       분모에만 있는 행(누락)은 단가 칸을 비워 둔다(REQ-PG-006 · 무료 ≠ 0원).

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m1_grid.py --comp COMP_ACRYL_CLEAR3T
  raw/webadmin/.venv/bin/python _workspace/price-setup/m1_grid.py --csv m1-grid-260829.csv
"""
import argparse
import csv
import itertools
import json
import os
import sys
from collections import defaultdict

import django
from dotenv import load_dotenv

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
ROOT = "/Users/innojini/Dev/HuniWeb/raw/webadmin"
sys.path.insert(0, ROOT + "/webadmin")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
load_dotenv(ROOT + "/.env")
django.setup()
from django.db import connection  # noqa: E402

import m3_axis  # noqa: E402
import m3_l1  # noqa: E402
import m3_map  # noqa: E402

# 골든 회귀 기준선 — M4 게이트가 이 셋으로 판정한다(plan.md §D M3 · M4).
GOLDEN = {"COMP_ACRYL_CLEAR3T": 277, "COMP_ACRYL_MIRROR3T": 81, "COMP_ACRYL_COROTTO": 36}


def _q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return c.fetchall()


def _norm_val(v):
    """차원값을 대조용으로 정규화. 수치는 Decimal 표기 차이를 흡수한다."""
    if v is None:
        return None
    if isinstance(v, (int, float)):
        return str(int(v)) if float(v) == int(float(v)) else str(v)
    s = str(v).strip()
    try:
        f = float(s)
        return str(int(f)) if f == int(f) else str(f)
    except ValueError:
        return s


class Element:
    """분모의 원소 하나 — 차원값 조합 + 권위 귀속 + 권위 값(§5.1 ② 값 충전)."""

    __slots__ = ("key", "dims", "vals", "prov", "auth_value", "auth_ref")

    def __init__(self, dims, vals, prov, auth_value=None, auth_ref=None):
        self.dims = dims
        self.vals = vals                       # {dim: 값}
        self.prov = prov                       # [(sheet, block_id, {dim: 축라벨})]
        self.auth_value = auth_value           # 권위 셀 값 — 없으면 None(칸을 비운다)
        self.auth_ref = auth_ref               # 그 값의 셀 좌표
        self.key = tuple(_norm_val(vals.get(d)) for d in dims)


def build_block_grid(b, dims, tr):
    """3단계 — 하위표 하나의 교차곱. 번역 미성립 차원이 있으면 (None, 사유)."""
    axis_vals, axis_lab = {}, {}
    for d in dims:
        r = tr.get(d, {})
        st = r.get("status")
        if st == "null-dim":
            axis_vals[d] = [None]
            axis_lab[d] = {None: "(미사용)"}
            continue
        mp = r.get("map") or {}
        if not mp:
            return None, "차원 %s 번역 미성립(%s) — REQ-PG-016 ㉠ 블로커" % (d, r.get("why", st))
        vals, lab = [], {}
        for label, codes in mp.items():
            for c in codes:
                if c not in vals:
                    vals.append(c)
                    lab[c] = label            # 권위 귀속 — 어느 축 라벨에서 왔나
        axis_vals[d] = vals
        axis_lab[d] = lab

    # §5.1 ② 값 충전 — 권위 셀에서 값을 가져온다. 없으면 None(칸을 비운다 · REQ-PG-006).
    #   블록 행렬은 (행 라벨, 열 라벨 튜플, 값, 셀좌표) 이므로, 어느 차원이 행 축이고
    #   어느 차원이 밴드 축인지를 알아야 셀을 찾을 수 있다. tr 의 axis 가 그 대응이다.
    row_dim = next((d for d in dims if (tr.get(d) or {}).get("axis") == "row"), None)
    band_dims = [d for d in dims
                 if str((tr.get(d) or {}).get("axis") or "").startswith("band")]
    band_dims.sort(key=lambda d: str(tr[d]["axis"]))
    cell = {}
    for rl, cl, v, ref in b.matrix:
        cell[(rl, cl)] = (v, ref)

    order = list(dims)
    out = []
    for combo in itertools.product(*[axis_vals[d] for d in order]):
        vals = dict(zip(order, combo))
        labels = {d: axis_lab[d].get(vals[d]) for d in order}
        av = aref = None
        if row_dim and band_dims:
            rl = labels.get(row_dim)
            cl = tuple(labels[d] for d in band_dims if labels.get(d) is not None)
            hit = cell.get((rl, cl))
            if hit:
                av, aref = hit
        out.append(Element(order, vals, [(b.sheet, b.block_id, labels)], av, aref))
    return out, None


def _as_dict(dv):
    """`dim_vals`(jsonb) 를 dict 로. 원시 커서는 문자열로 돌려주기도 한다."""
    if isinstance(dv, dict):
        return dv
    if isinstance(dv, str) and dv.strip():
        try:
            v = json.loads(dv)
        except ValueError:
            return {}
        return v if isinstance(v, dict) else {}
    return {}


def comp_params(cobj):
    """이 구성요소의 공정 상세 파라미터 축. 반환 (키 목록, {키: 컬럼스펙}).

    [HARD] 화면이 정본이다(`huni-webadmin-manual-first.md` · STATUS §4.5). `use_dims` 12종만
           보면 이 축을 통째로 놓친다 — 오시비·박에서 같은 형태로 두 번 틀렸다.
           단가편집 화면은 `proc_grp` 의 상세입력을 `proc_cd` 바로 뒤 **컬럼**으로 세우고
           (`price_views.proc_param_cols`), 값은 `dim_vals`(jsonb)에 담긴다.
    """
    from catalog import price_views as pv
    _, scopes = pv.split_scopes(cobj.use_dims)
    pg = scopes.get("proc_grp")
    cols = pv.proc_param_cols(pg) if pg else []
    return [c["name"] for c in cols], {c["name"]: c for c in cols}


def live_param_vals(comp, params):
    """라이브가 각 파라미터 축에 실제로 쓰는 값 집합.

    비어 있으면 `translate_block` 이 그 축을 `null-dim` 으로 빼낸다 — 화면에 컬럼은
    있으나 라이브가 그 칸을 전건 비워 둔 구성요소(별색·코팅·제본 계열)가 그 형태다.
    """
    out = {p: set() for p in params}
    if not params:
        return out
    for (dv,) in _q("SELECT dim_vals FROM t_prc_component_prices "
                    "WHERE comp_cd=%s AND dim_vals IS NOT NULL", [comp]):
        d = _as_dict(dv)
        for p in params:
            v = d.get(p)
            if v is not None and str(v).strip() != "":
                out[p].add(_norm_val(v))
    return out


def live_rows(comp, dims, params=()):
    """라이브 단가행을 같은 키 모양으로. 대조 대상이지 생성자가 아니다.

    [HARD] `dim_vals` 의 파라미터를 키에 **펼쳐 넣는다** — `/grid/` 응답과 같은 모양이다
           (`price_views.price_grid`: `for k in param_keys: r[k] = dv.get(k)`).
           빠뜨리면 오시비 30행이 10행으로 접히고, 없는 조합이 누락으로 만들어진다.
    """
    cols = ", ".join(dims)
    rows = _q(f"SELECT {cols}, dim_vals, unit_price, apply_ymd "
              f"FROM t_prc_component_prices WHERE comp_cd=%s", [comp])
    out = {}
    for r in rows:
        dv = _as_dict(r[len(dims)])
        key = (tuple(_norm_val(x) for x in r[:len(dims)])
               + tuple(_norm_val(dv.get(p)) for p in params))
        out.setdefault(key, []).append({"unit_price": r[-2], "apply_ymd": r[-1]})
    return out


def build(comp, slots, dims, scopes, M, live_vals, all_blocks, params=None):
    """3·4단계 — 하위표별 교차곱을 만들고 합집합한다."""
    merged, blockers, per_block = {}, [], []
    for key, v in slots.items():
        b = v["block"]
        tr = m3_axis.translate_block(comp, b, dims, scopes, M, live_vals,
                                     m3_axis.foreign_labels(all_blocks, b),
                                     params=params)
        grid, why = build_block_grid(b, dims, tr)
        if grid is None:
            blockers.append((b, why))
            continue
        per_block.append((b, len(grid)))
        for el in grid:
            if el.key in merged:
                merged[el.key].prov.extend(el.prov)     # 4단계 — 합집합
            else:
                merged[el.key] = el
    return merged, blockers, per_block


def run(only_comp=None, only_sheet=None):
    per_col, unmapped, names, nrows, meta = m3_map.pair_blocks(only_sheet)
    comp2blocks = m3_map.invert(per_col)
    M = m3_axis.Masters()
    all_blocks = m3_l1.load_blocks(only_sheet)

    from catalog import price_views as pv
    from catalog import models as Mo

    results = []
    for comp, slots in sorted(comp2blocks.items()):
        if only_comp and comp != only_comp:
            continue
        cobj = Mo.TPrcPriceComponents.objects.filter(comp_cd=comp).first()
        if not cobj:
            continue
        dims = pv._comp_dims(cobj)
        _, scopes = pv.split_scopes(cobj.use_dims)
        param_keys, param_meta = comp_params(cobj)
        # 격자 축 = 12종 차원 + 공정 상세 파라미터. 화면 컬럼과 같은 모양이다.
        grid_dims = list(dims) + param_keys
        live_vals = {d: {r[0] for r in _q(
            f"SELECT DISTINCT {d} FROM t_prc_component_prices "
            f"WHERE comp_cd=%s AND {d} IS NOT NULL", [comp])} for d in dims}
        live_vals.update(live_param_vals(comp, param_keys))

        merged, blockers, per_block = build(comp, slots, grid_dims, scopes, M,
                                            live_vals, all_blocks, param_meta)
        live = live_rows(comp, dims, param_keys)
        present = [k for k in merged if k in live]      # 실재
        missing = [k for k in merged if k not in live]  # 누락 — 단가 칸을 비운다
        extra = [k for k in live if k not in merged]    # 잉여 — 보고만(P-2)
        results.append({
            "comp": comp, "comp_nm": names.get(comp, ""), "dims": grid_dims,
            "base_dims": dims, "param_keys": param_keys,
            "merged": merged, "live": live, "per_block": per_block,
            "blockers": blockers, "present": present, "missing": missing,
            "extra": extra, "prc_typ": meta.get(comp, ("", ""))[1],
        })
    return results


def main():
    ap = argparse.ArgumentParser(description="M1 — 권위 하위표 합집합으로 분모 생성")
    ap.add_argument("--comp")
    ap.add_argument("--sheet")
    ap.add_argument("--csv")
    ap.add_argument("--golden", action="store_true", help="M4 골든 게이트만 판정")
    a = ap.parse_args()

    results = run(a.comp, a.sheet)

    if a.golden:
        print("M4 골든 게이트 — 누락 0 · 잉여 0")
        print("=" * 78)
        ok = True
        for r in results:
            if r["comp"] not in GOLDEN:
                continue
            want = GOLDEN[r["comp"]]
            got, nl = len(r["merged"]), len(r["live"])
            miss, ext = len(r["missing"]), len(r["extra"])
            good = (got == want and miss == 0 and ext == 0)
            ok = ok and good
            print(f"  [{'PASS' if good else 'FAIL'}] {r['comp']:22s} "
                  f"분모 {got:4d} (기준 {want}) · 라이브 {nl:4d} · 누락 {miss} · 잉여 {ext}")
            for b, n in r["per_block"]:
                print(f"          {b.sheet} {b.block_id} {b.title[:34]:36s} {n:4d}칸")
        print("=" * 78)
        print("  게이트: %s" % ("PASS — 확대 가능" if ok else "FAIL — 확대 금지(plan.md §D M4)"))
        return

    print("M1 분모 생성 — 구성요소 %d종" % len(results))
    print("=" * 96)
    print(f"  {'구성요소':30s}{'분모':>6s}{'라이브':>7s}{'실재':>6s}{'누락':>6s}{'잉여':>6s}"
          f"{'하위표':>7s}{'블로커':>7s}")
    tot = defaultdict(int)
    for r in sorted(results, key=lambda x: -len(x["merged"])):
        mark = " ★" if r["comp"] in GOLDEN else ""
        print(f"  {r['comp'][:29]:30s}{len(r['merged']):6d}{len(r['live']):7d}"
              f"{len(r['present']):6d}{len(r['missing']):6d}{len(r['extra']):6d}"
              f"{len(r['per_block']):7d}{len(r['blockers']):7d}{mark}")
        tot["분모"] += len(r["merged"])
        tot["라이브"] += len(r["live"])
        tot["실재"] += len(r["present"])
        tot["누락"] += len(r["missing"])
        tot["잉여"] += len(r["extra"])
        tot["블로커"] += len(r["blockers"])
    print("-" * 96)
    print(f"  {'합계':30s}{tot['분모']:6d}{tot['라이브']:7d}{tot['실재']:6d}"
          f"{tot['누락']:6d}{tot['잉여']:6d}{'':>7s}{tot['블로커']:7d}")

    if a.comp:
        r = results[0]
        print("\n" + "=" * 96)
        print(f"{r['comp']}  {r['comp_nm']}  ({r['prc_typ']})")
        print(f"  dims = {r['dims']}")
        for b, n in r["per_block"]:
            print(f"  하위표 {b.sheet} {b.block_id} {b.title[:44]:46s} {n:5d}칸  ({b.geometry})")
        print(f"  → 합집합 분모 {len(r['merged'])} · 라이브 {len(r['live'])}"
              f" · 실재 {len(r['present'])} · 누락 {len(r['missing'])} · 잉여 {len(r['extra'])}")
        for b, why in r["blockers"]:
            print(f"  [블로커] {b.sheet} {b.block_id}: {why}")
        print("\n  분모 원소 표본 (권위 귀속 포함):")
        for k in list(r["merged"])[:6]:
            el = r["merged"][k]
            sheet, bid, labels = el.prov[0]
            vals = " · ".join(f"{d}={el.vals.get(d)}" for d in r["dims"])
            labs = " · ".join(f"{d}←{labels.get(d)}" for d in r["dims"])
            print(f"    {vals}")
            print(f"        귀속: {sheet} {bid} | {labs}")

    if a.csv:
        with open(a.csv, "w", encoding="utf-8-sig", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["comp_cd", "comp_nm", "판정"] + [f"dim:{d}" for d in
                        ["siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd",
                         "opt_cd", "coat_side_cnt", "spot_side_cnt", "bdl_qty",
                         "siz_width", "siz_height", "min_qty"]] +
                       ["권위_시트", "권위_하위표", "권위_축라벨", "라이브_단가"])
            ALL = ["siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                   "coat_side_cnt", "spot_side_cnt", "bdl_qty", "siz_width",
                   "siz_height", "min_qty"]
            for r in results:
                for k, el in r["merged"].items():
                    verdict = "실재" if k in r["live"] else "누락"
                    sheet, bid, labels = el.prov[0]
                    price = ""
                    if k in r["live"]:
                        price = r["live"][k][0]["unit_price"]
                    w.writerow([r["comp"], r["comp_nm"], verdict] +
                               [el.vals.get(d, "") for d in ALL] +
                               [sheet, bid,
                                " · ".join(f"{d}←{labels[d]}" for d in r["dims"]
                                           if labels.get(d)),
                                price])
                for k in r["extra"]:
                    w.writerow([r["comp"], r["comp_nm"], "잉여"] +
                               ["" for _ in ALL] + ["", "", "(권위에 없음 — 보고만, P-2)",
                                                    r["live"][k][0]["unit_price"]])
        print("\n→ %s" % a.csv)


if __name__ == "__main__":
    main()
