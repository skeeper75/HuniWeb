"""t36 ② 기준선 — use_dims 변경 전 실제 계산 금액을 대표 5케이스로 떠 둔다.

라이브 evaluate_price DB 함수는 없다. 실제 엔진은 webadmin 의 catalog/pricing.py 이므로
django.setup() 으로 그 엔진을 읽기전용 호출한다(t34 트랙 B golden.py 선례).
★ 쓰기 경로 없음 — save/create/update/delete 호출이 하나도 없다.
"""
import csv
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbq as DBH                                                # noqa: E402

os.environ['DATABASE_URL'] = DBH.URL
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin')
import django                                                    # noqa: E402
django.setup()
from catalog import price_views as PV, pricing as P              # noqa: E402

OUT = os.path.dirname(os.path.abspath(__file__))

# 카드 지정 대표 5케이스 — (라벨, 사이즈코드, 수량)
CASES = [
    ('A6 1000장',      'SIZ_000057', 1000),
    ('A5 500장',       'SIZ_000426', 500),
    ('A4 100장',       'SIZ_000258', 100),
    ('90x190 300장',   'SIZ_000060', 300),
    ('124x186 200장',  'SIZ_000059', 200),
]
# 대상 구성요소를 무는 상품 중 반칼 대표(판형 행 살아 있음) + 낱장/대형 대표(판형 없음)
PRDS = ['PRD_000052', 'PRD_000064', 'PRD_000055', 'PRD_000057']


def pick(options, want=None):
    if not options:
        return None
    if want:
        for o in options:
            if o.get('v') == want:
                return want
    ordered = sorted(options, key=lambda o: (not o.get('dflt'),))
    return ordered[0].get('v')


def selection(meta, siz_cd):
    sel, procs = {}, []
    for d in meta.get('prod_dims') or []:
        name, opts = d['name'], d.get('options') or []
        if d.get('kind') == 'proc':
            chosen = [o['v'] for o in opts if o.get('mand')]
            procs = [{'proc_cd': v, 'detail': {}} for v in chosen]
            continue
        v = pick(opts, siz_cd if name == 'siz_cd' else None)
        if v is not None:
            sel[name] = v
    return sel, procs


def main():
    rows = []
    for prd in PRDS:
        try:
            meta = PV._build_sim_meta(prd)
        except Exception as e:                                   # noqa: BLE001
            rows.append(dict(prd_cd=prd, case='meta 실패', siz_cd='', qty='',
                             matched_siz='', ok='', final_price='', components='',
                             warnings=str(e)[:200], errors=''))
            continue
        nm = (meta.get('prd_nm') or '')
        for label, siz, qty in CASES:
            sel, procs = selection(meta, siz)
            if sel.get('siz_cd') != siz:
                rows.append(dict(prd_cd=prd, prd_nm=nm, case=label, siz_cd=siz, qty=qty,
                                 matched_siz=sel.get('siz_cd', ''), ok='SKIP',
                                 final_price='', components='',
                                 warnings='이 상품에 등록되지 않은 사이즈 — 건너뜀',
                                 errors=''))
                continue
            r = P.evaluate_price({'prd_cd': prd}, sel, qty, mode='lenient',
                                 proc_sels=procs or None)
            comps = ((r.get('base') or {}).get('components')) or []
            rows.append(dict(
                prd_cd=prd, prd_nm=nm, case=label, siz_cd=siz, qty=qty,
                matched_siz=sel.get('siz_cd', ''), ok=r.get('ok'),
                final_price=r.get('final_price'),
                components='; '.join(f"{c.get('comp_cd')}={c.get('amount')}" for c in comps),
                warnings=' | '.join(r.get('warnings') or [])[:300],
                errors=' | '.join(r.get('errors') or [])[:300]))
            print(f"  {prd} {label} -> {r.get('final_price')}", flush=True)
    path = f'{OUT}/baseline.csv'
    keys = ['prd_cd', 'prd_nm', 'case', 'siz_cd', 'qty', 'matched_siz', 'ok',
            'final_price', 'components', 'warnings', 'errors']
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=keys)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, '') for k in keys})
    print(f'기준선 {len(rows)}줄 -> {path}')


if __name__ == '__main__':
    main()
