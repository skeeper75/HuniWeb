"""t41 — 카드 지정 5케이스를 실제 엔진으로 계산한다(읽기 전용).

사용:
  sim_t41.py before          현재 라이브 상태로 계산 → sim-before.csv
  sim_t41.py after           BEGIN → apply.sql → 계산 → ROLLBACK → sim-after.csv

'after' 는 커밋하지 않는다. 같은 트랜잭션 안에서 계산하려면 엔진이 그 트랜잭션을 봐야 하므로,
Django 커넥션에서 직접 apply.sql 을 실행하고 계산한 뒤 ROLLBACK 한다.
"""
import csv
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import dbq as DBH                                                # noqa: E402

MODE = sys.argv[1] if len(sys.argv) > 1 else 'before'
os.environ['DATABASE_URL'] = DBH.URL
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin')
import django                                                    # noqa: E402
django.setup()
from django.db import connection, transaction                    # noqa: E402
from catalog import price_views as PV, pricing as P              # noqa: E402

# 카드 지정 5케이스 — (라벨, 상품, 사이즈, 자재, 수량, 예측)
CASES = [
    ('A6 유포 1,000장', 'PRD_000052', 'SIZ_000057', 'MAT_000584', 1000, 712500),
    ('A6 유포 8장',     'PRD_000052', 'SIZ_000057', 'MAT_000584', 8,    6700),
    ('A6 미색 100장',   'PRD_000052', 'SIZ_000057', 'MAT_000609', 100,  None),   # ≠0 이면 통과
    ('A5 유포 500장',   'PRD_000052', 'SIZ_000426', 'MAT_000584', 500,  None),
    ('A4 유포 100장',   'PRD_000052', 'SIZ_000258', 'MAT_000584', 100,  None),
]


def selection(meta, siz, mat):
    sel, procs = {}, []
    for d in meta.get('prod_dims') or []:
        name, opts = d['name'], d.get('options') or []
        if d.get('kind') == 'proc':
            procs = [{'proc_cd': o['v'], 'detail': {}} for o in opts if o.get('mand')]
            continue
        want = {'siz_cd': siz, 'mat_cd': mat}.get(name)
        vals = [o.get('v') for o in opts]
        if want and want in vals:
            sel[name] = want
        elif opts:
            sel[name] = sorted(opts, key=lambda o: (not o.get('dflt'),))[0].get('v')
    return sel, procs


def run_cases():
    rows = []
    for label, prd, siz, mat, qty, predict in CASES:
        meta = PV._build_sim_meta(prd)
        sel, procs = selection(meta, siz, mat)
        # 실제 화면 경로(price_views.price_simulate:3795~3800)와 같게 판형을 자동 주입한다.
        # 판형은 내부(생산) 개념이라 사용자 선택값에 없고, 엔진을 직접 부르면 이 단계가 빠져
        # 「판수 환산 불가(판형=미선택)」로 0원이 난다.
        if sel.get('siz_cd') and not sel.get('plt_siz_cd'):
            best, _st, _dg = PV._select_default_plate(prd, sel['siz_cd'])
            if best:
                sel['plt_siz_cd'] = best
        r = P.evaluate_price({'prd_cd': prd}, sel, qty, mode='lenient',
                             proc_sels=procs or None)
        comps = ((r.get('base') or {}).get('components')) or []
        rows.append(dict(
            case=label, prd_cd=prd, siz_cd=sel.get('siz_cd'), mat_cd=sel.get('mat_cd'),
            plt_siz_cd=sel.get('plt_siz_cd', ''),
            qty=qty, predict=('' if predict is None else predict),
            ok=r.get('ok'), final_price=r.get('final_price'),
            components='; '.join(f"{c.get('comp_cd')}={c.get('amount')}" for c in comps),
            warnings=' | '.join(r.get('warnings') or [])[:250],
            errors=' | '.join(r.get('errors') or [])[:250]))
        print(f'  {label} -> {r.get("final_price")}', flush=True)
    return rows


def main():
    if MODE == 'after':
        sql = open(f'{HERE}/apply.sql').read()
        sql = sql.split('\nBEGIN;\n', 1)[1].rsplit('COMMIT;', 1)[0]
        with transaction.atomic():
            with connection.cursor() as cur:
                cur.execute(sql)
            rows = run_cases()
            transaction.set_rollback(True)      # 반드시 되돌린다
    else:
        rows = run_cases()
    path = f'{HERE}/sim-{MODE}.csv'
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    print(f'{MODE} {len(rows)}줄 -> {path}')


if __name__ == '__main__':
    main()
