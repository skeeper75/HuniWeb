"""M1④ 골든 금액표 — 화면을 만지기 전 실제 계산 금액을 떠 둔다.

라이브에 evaluate_price DB 함수는 없다. 실제 엔진은 webadmin 의
catalog/pricing.py 이므로, raw/webadmin/tools 의 선례대로 django.setup() 으로
그 엔진을 그대로 읽기전용 호출한다(리드 승인 260902).

★ 쓰기 경로 없음 — 이 파일에는 save/create/update/delete 호출이 하나도 없다.
   DB 접속은 ORM 의 SELECT 뿐이다.

상품마다 조합을 최소 둘 잡는다.
  기본  — 축마다 기본값(dflt, 없으면 첫 옵션) · 수량은 상품 기본수량
  변형  — 한 축을 두 번째 옵션으로 바꾼 것 (바꿀 축이 없으면 수량을 바꾼다)
  할인  — 아크릴 상품은 수량구간 할인(300~499)에 드는 300 을 하나 더 잡는다.
          할인이 걸린 채로 계산된 금액이 표에 없으면 M4 에서 할인이 끊긴 것을
          골든 대조가 잡아내지 못한다.
"""
import csv
import os
import re
import sys
import datetime

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
sys.path.insert(0, f'{WT}/_workspace/price-setup/scripts')
import db as DBH                                                 # noqa: E402

os.environ['DATABASE_URL'] = DBH.URL
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin')
import django                                                    # noqa: E402
django.setup()
from catalog import price_views as PV, pricing as P              # noqa: E402

BASE = f'{WT}/_workspace/price-setup'
DISCOUNT_QTY = 300
TAG = sys.argv[1] if len(sys.argv) > 1 else 'before'


def pick(options, idx=0):
    if not options:
        return None
    ordered = sorted(options, key=lambda o: (not o.get('dflt'),))
    return ordered[min(idx, len(ordered) - 1)].get('v')


def base_selection(meta, idx_by_dim=None):
    idx_by_dim = idx_by_dim or {}
    sel, procs = {}, []
    for d in meta.get('prod_dims') or []:
        name, opts = d['name'], d.get('options') or []
        if d.get('kind') == 'proc':
            # 엔진이 받는 모양은 [{"proc_cd": 코드, "detail": {...}}, …] 이다
            # (pricing.py:922). 코드 문자열만 넘기면 ps.get 에서 통째로 터진다.
            chosen = [o['v'] for o in opts if o.get('mand')] or (
                [opts[0]['v']] if opts else [])
            procs = [{'proc_cd': v, 'detail': {}} for v in chosen]
            continue
        v = pick(opts, idx_by_dim.get(name, 0))
        if v is not None:
            sel[name] = v
    ns = meta.get('nonspec') or {}
    if (ns.get('yn') or 'N') == 'Y':
        # 직접입력 상품 — 사이즈코드가 아니라 가로·세로 실측값으로 축을 잡는다.
        for axis, lo, hi in (('siz_width', ns.get('w_min'), ns.get('w_max')),
                             ('siz_height', ns.get('h_min'), ns.get('h_max'))):
            if lo is not None:
                sel[axis] = float(lo)
            elif hi is not None:
                sel[axis] = float(hi)
    return sel, procs


def variant_dim(meta):
    for d in meta.get('prod_dims') or []:
        if d.get('kind') != 'proc' and len(d.get('options') or []) > 1:
            return d['name']
    return None


def is_acrylic(meta):
    return '아크릴' in (meta.get('prd_nm') or '')


MIN_QTY_RE = re.compile(r'최소 주문수량\s*(\d+)')


def run(prd_cd, label, sel, qty, procs):
    r = P.evaluate_price({'prd_cd': prd_cd}, sel, qty,
                         mode='lenient', proc_sels=procs or None)
    if not r.get('final_price'):
        # 그릇이 요구하는 최소 수량보다 적게 잡아 0원이 난 경우만 그 수량으로 다시 잰다.
        hits = [int(m.group(1)) for w in (r.get('warnings') or [])
                for m in [MIN_QTY_RE.search(w)] if m]
        if hits and max(hits) > qty:
            qty = max(hits)
            label = f'{label}·최소수량{qty}'
            r = P.evaluate_price({'prd_cd': prd_cd}, sel, qty,
                                 mode='lenient', proc_sels=procs or None)
    comps = ((r.get('base') or {}).get('components')) or []
    return dict(
        prd_cd=prd_cd, combo=label, qty=qty,
        selections='; '.join(f'{k}={v}' for k, v in sorted(sel.items())),
        procs=' '.join(p.get('proc_cd', '') for p in (procs or [])),
        ok=r.get('ok'),
        base_amount=(r.get('base') or {}).get('amount'),
        final_price=r.get('final_price'),
        component_cnt=len(comps),
        components='; '.join(f"{c.get('comp_cd')}={c.get('amount')}" for c in comps),
        discounts='; '.join(
            f"{d.get('step')}[{d.get('label')}] {d.get('typ')}={d.get('value')} "
            f"{d.get('before')}→{d.get('after')} 할인={d.get('discount')}"
            for d in (r.get('discounts') or [])),
        discount_cnt=len(r.get('discounts') or []),
        warnings=' | '.join(r.get('warnings') or [])[:400],
        errors=' | '.join(r.get('errors') or [])[:400])


def main():
    targets = list(csv.DictReader(open(f'{BASE}/m1/target-products-trackA.csv')))
    rows, failed = [], []
    for i, t in enumerate(targets, 1):
        prd = t['prd_cd']
        print(f'[{i}/{len(targets)}] {prd} {t["prd_nm"]}', flush=True)
        try:
            meta = PV._build_sim_meta(prd)
        except Exception as e:                                   # noqa: BLE001
            failed.append((prd, f'meta 실패: {e}'))
            continue
        qd = (meta.get('qty_rule') or {}).get('dflt') or 1
        sel, procs = base_selection(meta)
        combos = [('기본', sel, qd)]
        vd = variant_dim(meta)
        if vd:
            sel2, _ = base_selection(meta, {vd: 1})
            combos.append((f'변형({vd})', sel2, qd))
        else:
            combos.append(('변형(수량)', dict(sel), max(qd + 1, 2)))
        if is_acrylic(meta):
            combos.append(('할인구간(300)', dict(sel), DISCOUNT_QTY))
        for label, s, q in combos:
            try:
                rows.append(run(prd, label, s, q, procs))
            except Exception as e:                               # noqa: BLE001
                failed.append((prd, f'{label} 계산 실패: {e}'))

    stamp = datetime.datetime.now(datetime.timezone.utc).isoformat(timespec='seconds')
    path = f'{BASE}/golden/golden-{TAG}.csv'
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()) + ['captured_at_utc'])
        w.writeheader()
        for r in rows:
            r['captured_at_utc'] = stamp
            w.writerow(r)

    zero = [r for r in rows if not r['final_price']]
    print(f'골든 {len(rows)}줄 · 상품 {len({r["prd_cd"] for r in rows})} -> {path}')
    print(f'0원/계산불가 {len(zero)}줄 · meta·계산 예외 {len(failed)}건')
    for p, m in failed[:15]:
        print('  실패:', p, str(m)[:150])
    for r in zero[:20]:
        print(f'  0원: {r["prd_cd"]} {r["combo"]} — {(r["errors"] or r["warnings"])[:140]}')


if __name__ == '__main__':
    main()
