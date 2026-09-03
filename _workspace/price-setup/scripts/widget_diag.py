"""M5 위젯 가격진단 — 게시 위젯 54상품. 조회·계산만(쓰기 0).

각 상품을 두 조합으로 잰다: 기본 선택 · 옵션 1회 변경.
그리고 센서 둘을 함께 돌린다.
  센서① 구성요소 누락 — 공식에 붙은 구성요소가 계산에 실제로 반영됐는가.
        (금액이 0 이 아니어도 한 구성요소가 통째로 빠질 수 있다 — D-17 이 그랬다)
  센서② 격자 커버리지 — 고른 사이즈의 재단치수가 그 구성요소 격자 안에 들어오는가.
"""
import csv, os, sys, datetime

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
sys.path.insert(0, f'{BASE}/scripts')
import db as DBH                                                 # noqa: E402
os.environ['DATABASE_URL'] = DBH.URL
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin')
import django                                                    # noqa: E402
django.setup()
from catalog import price_views as PV, pricing as P              # noqa: E402

TAG = sys.argv[1] if len(sys.argv) > 1 else 'm5'
HOLD = {'PRD_000052', 'PRD_000053', 'PRD_000054', 'PRD_000062', 'PRD_000063'}


def formula_comps(frm_cd):
    """엔진이 실제로 고른 공식에 붙은 구성요소 코드.

    상품에 걸린 공식을 전부 합치면 안 된다 — 엔진은 공식 하나만 골라 쓴다.
    합치면 안 쓰인 옛 공식의 구성요소가 「누락」으로 잘못 잡힌다(스티커 7상품 오탐).
    """
    rows = DBH.q(f"""SELECT comp_cd FROM t_prc_formula_components
        WHERE frm_cd = '{frm_cd}'""", tuples=True).split()
    return sorted(set(rows))


_GRID = {}


def grid(comp_cd):
    if comp_cd not in _GRID:
        g = []
        for line in DBH.q(f"""SELECT siz_width, siz_height FROM t_prc_component_prices
            WHERE comp_cd = '{comp_cd}' AND siz_width IS NOT NULL
              AND siz_height IS NOT NULL""", tuples=True).splitlines():
            if line.strip():
                w, h = line.split('\t')
                g.append((float(w), float(h)))
        _GRID[comp_cd] = g
    return _GRID[comp_cd]


_CUT = {}


def cut(siz_cd):
    if siz_cd not in _CUT:
        line = DBH.q(f"""SELECT cut_width, cut_height FROM t_siz_sizes
            WHERE siz_cd = '{siz_cd}'""", tuples=True).strip()
        try:
            w, h = line.split('\t')
            _CUT[siz_cd] = (float(w), float(h))
        except ValueError:
            _CUT[siz_cd] = None
    return _CUT[siz_cd]


def pick(options, idx=0):
    if not options:
        return None
    ordered = sorted(options, key=lambda o: (not o.get('dflt'),))
    return ordered[min(idx, len(ordered) - 1)].get('v')


def selection(meta, bump=None):
    """축마다 기본값. bump 가 준 축만 두 번째 선택지로 바꾼다."""
    sel, procs = {}, []
    for d in meta.get('prod_dims') or []:
        opts = d.get('options') or []
        if d.get('kind') == 'proc':
            chosen = [o['v'] for o in opts if o.get('mand')] or ([opts[0]['v']] if opts else [])
            procs = [{'proc_cd': v, 'detail': {}} for v in chosen]
            continue
        v = pick(opts, 1 if d['name'] == bump else 0)
        if v is not None:
            sel[d['name']] = v
    ns = meta.get('nonspec') or {}
    if (ns.get('yn') or 'N') == 'Y':
        for axis, lo in (('siz_width', ns.get('w_min')), ('siz_height', ns.get('h_min'))):
            if lo is not None:
                sel[axis] = float(lo)
    return sel, procs


def opt_axis(meta):
    """옵션 축이 있으면 그것, 없으면 선택지가 둘 이상인 첫 축."""
    dims = [d for d in (meta.get('prod_dims') or []) if d.get('kind') != 'proc']
    for d in dims:
        if d['name'] == 'opt_cd' and len(d.get('options') or []) > 1:
            return d['name']
    for d in dims:
        if len(d.get('options') or []) > 1:
            return d['name']
    return None


def diagnose(prd_cd, prd_nm):
    out = []
    meta = PV._build_sim_meta(prd_cd)
    qd = (meta.get('qty_rule') or {}).get('dflt') or 1
    bump = opt_axis(meta)
    combos = [('기본', None)] + ([(f'옵션변경({bump})', bump)] if bump else [])
    for label, b in combos:
        sel, procs = selection(meta, b)
        r = P.evaluate_price({'prd_cd': prd_cd}, sel, qd, mode='lenient',
                             proc_sels=procs or None)
        base = r.get('base') or {}
        used_frm = ((base.get('formula') or {}).get('frm_cd')) or ''
        want = formula_comps(used_frm) if used_frm else []
        comps = base.get('components') or []
        got = {c.get('comp_cd') for c in comps}
        missing = [c for c in want if c not in got]

        # 센서② — 고른 사이즈가 각 구성요소 격자 안에 들어오는가
        uncovered = []
        siz = sel.get('siz_cd')
        dims = cut(siz) if siz else (
            (sel.get('siz_width'), sel.get('siz_height'))
            if sel.get('siz_width') and sel.get('siz_height') else None)
        if dims and dims[0] and dims[1]:
            cw, ch = dims
            for c in want:
                g = grid(c)
                if g and not any(cw <= w and ch <= h for w, h in g):
                    uncovered.append(c)

        out.append(dict(
            prd_cd=prd_cd, prd_nm=prd_nm, combo=label, qty=qd,
            hold='Y' if prd_cd in HOLD else '',
            used_frm=used_frm,
            selections='; '.join(f'{k}={v}' for k, v in sorted(sel.items())),
            final_price=r.get('final_price'),
            price_nonzero='Y' if r.get('final_price') else 'N',
            formula_comp_cnt=len(want), applied_comp_cnt=len(got),
            sensor1_missing_comps='; '.join(missing),
            sensor1_pass='Y' if not missing else 'N',
            sensor2_uncovered='; '.join(uncovered),
            sensor2_pass='Y' if not uncovered else 'N',
            warnings=' | '.join(r.get('warnings') or [])[:300],
            errors=' | '.join(r.get('errors') or [])[:300]))
    return out


def main():
    targets = [t for t in csv.DictReader(open(f'{BASE}/m1/target-products-trackA.csv'))
               if t['in_scope'] == 'Y']
    stamp = datetime.datetime.now().astimezone().isoformat(timespec='seconds')
    rows, failed = [], []
    print(f'분모 판정: target-products-trackA.csv in_scope=Y → {len(targets)}상품 · 판정시각 {stamp}')
    for i, t in enumerate(targets, 1):
        try:
            rows += diagnose(t['prd_cd'], t['prd_nm'])
        except Exception as e:                                   # noqa: BLE001
            failed.append((t['prd_cd'], str(e)[:160]))
            print(f'  [{i}] {t["prd_cd"]} 실패: {str(e)[:100]}', flush=True)

    path = f'{BASE}/golden/widget-diag-{TAG}.csv'
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()) + ['judged_at'])
        w.writeheader()
        for r in rows:
            r['judged_at'] = stamp
            w.writerow(r)

    zero = [r for r in rows if r['price_nonzero'] == 'N']
    s1 = [r for r in rows if r['sensor1_pass'] == 'N']
    s2 = [r for r in rows if r['sensor2_pass'] == 'N']
    err = [r for r in rows if r['errors']]
    print(f'\n진단 {len(rows)}줄 · 상품 {len({r["prd_cd"] for r in rows})} -> {path}')
    print(f'PRICE=0 {len(zero)} · 센서① 구성요소누락 {len(s1)} · 센서② 격자밖 {len(s2)} '
          f'· errors {len(err)} · meta실패 {len(failed)}')
    for r in (zero + s1 + s2)[:25]:
        print(f'  ★ {r["prd_cd"]} {r["prd_nm"][:14]:14s} {r["combo"]:14s} '
              f'가격={r["final_price"]} 누락=[{r["sensor1_missing_comps"]}] '
              f'격자밖=[{r["sensor2_uncovered"]}]')
    for p, m in failed:
        print('  실패:', p, m)


main()
