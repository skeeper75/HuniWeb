"""단일 부모의 simulate-set 원문 전체를 저장(읽기·계산 전용)."""
import json
import os
import subprocess
import sys

BROWSE = os.path.expanduser('~/.claude/skills/gstack/browse/dist/browse')
D = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, D)
from simset import META_JS, SIM_JS, call, build  # noqa: E402

prd = sys.argv[1]
pages = int(sys.argv[2]) if len(sys.argv) > 2 else 24
copies = int(sys.argv[3]) if len(sys.argv) > 3 else 100
code, body = call(META_JS % prd)
meta = json.loads(body)
members = build(meta, pages)
payload = {'copies': copies, 'mode': 'lenient', 'members': members,
           'set_selections': {}, 'set_procs': []}
code, body = call(SIM_JS % (prd, json.dumps(payload)))
j = json.loads(body)
out = os.path.join(D, f'sim_{prd}.json')
json.dump({'payload': payload, 'response': j}, open(out, 'w'),
          ensure_ascii=False, indent=1)
print('->', out, 'HTTP', code)
print('top keys:', sorted(j.keys()))
for k in ('ok', 'final_price', 'total', 'errors', 'warnings'):
    if k in j:
        print(f'  {k} =', json.dumps(j[k], ensure_ascii=False)[:300])
for m in j.get('members') or []:
    print('---', m.get('sub_prd_cd'), m.get('role'), 'member keys:', sorted(m.keys()))
    print('   qty_breakdown:', json.dumps(m.get('qty_breakdown'), ensure_ascii=False)[:400])
    ev = m.get('eval') or {}
    print('   eval keys:', sorted(ev.keys()))
    base = ev.get('base') or {}
    print('   base keys:', sorted(base.keys()))
    for k in ('final_price', 'price', 'sum', 'total'):
        if k in base:
            print(f'   base.{k} =', base[k])
    for c in (base.get('components') or []):
        print('     comp:', json.dumps(c, ensure_ascii=False)[:260])
