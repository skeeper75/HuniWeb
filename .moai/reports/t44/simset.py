"""셋트 가격 시뮬(읽기·계산 전용·DB write 0). 각 부모의 기본선택으로 simulate-set 호출."""
import json
import os
import subprocess
import sys

BROWSE = os.path.expanduser('~/.claude/skills/gstack/browse/dist/browse')
D = os.path.dirname(os.path.abspath(__file__))

META_JS = """(function(){var x=new XMLHttpRequest();
x.open('GET','/admin/price-viewer/%s/sim-meta/',false);x.send();
return x.status+' '+x.responseText;})()"""
SIM_JS = """(function(){var t=(document.cookie.match(/csrftoken=([^;]+)/)||[])[1]||'';
var x=new XMLHttpRequest();x.open('POST','/admin/price-viewer/%s/simulate-set/',false);
x.setRequestHeader('Content-Type','application/json');x.setRequestHeader('X-CSRFToken',t);
x.send(JSON.stringify(%s));return x.status+' '+x.responseText;})()"""


def call(js):
    r = subprocess.run([BROWSE, 'js', js], capture_output=True, text=True)
    out = r.stdout.strip()
    code, _, body = out.partition(' ')
    return code, body


def pick(opts):
    """기본값(dflt=True) 우선, 없으면 첫 옵션 — 위젯 첫 화면과 같은 규칙."""
    if not opts:
        return None
    for o in opts:
        if o.get('dflt'):
            return o['v']
    return opts[0]['v']


def build(meta, pages):
    members = []
    for m in meta.get('set_members') or []:
        inner = bool(m.get('is_inner'))
        mb = {'sub_prd_cd': m['sub_prd_cd'], 'role': m.get('role'),
              'label': m.get('role_nm') or m.get('prd_nm'),
              'siz_cd': pick(m.get('sizes')), 'mat_cd': pick(m.get('materials')),
              'print_opt_cd': pick(m.get('print_opts')),
              'qty_mode': 'derived' if inner else 'manual'}
        if inner:
            mb['pages'] = pages
        members.append(mb)
    return members


COPIES, PAGES = 100, 24
rows = []
for prd in sys.argv[1:]:
    code, body = call(META_JS % prd)
    if code != '200':
        rows.append({'prd': prd, 'error': f'meta HTTP {code}: {body[:200]}'})
        continue
    meta = json.loads(body)
    members = build(meta, PAGES)
    payload = {'copies': COPIES, 'mode': 'lenient', 'members': members,
               'set_selections': {}, 'set_procs': []}
    code, body = call(SIM_JS % (prd, json.dumps(payload)))
    rec = {'prd': prd, 'prd_nm': meta.get('prd_nm'), 'http': code,
           'sent_members': members}
    try:
        j = json.loads(body)
    except ValueError:
        rec['raw'] = body[:400]
        rows.append(rec)
        continue
    rec['ok'] = j.get('ok')
    rec['errors'] = j.get('errors')
    rec['final'] = j.get('final_price') or j.get('total') or j.get('sum_price')
    rec['members_out'] = []
    for m in j.get('members') or []:
        qb = m.get('qty_breakdown') or {}
        ev = (m.get('eval') or {}).get('base') or {}
        rec['members_out'].append({
            'sub': m.get('sub_prd_cd'), 'role': m.get('role_nm') or m.get('role'),
            'plate': qb.get('plate'), 'plate_status': qb.get('plate_status'),
            'plate_diag': qb.get('plate_diag'), 'pansu': qb.get('pansu'),
            'qty': m.get('qty'), 'mode': qb.get('mode'),
            'price': ev.get('final_price') or ev.get('price') or m.get('price'),
            'n_comp': len(ev.get('components') or []),
            'excluded': sum(1 for c in (ev.get('components') or []) if c.get('excluded')),
        })
    rec['keys'] = sorted(j.keys())
    rows.append(rec)

json.dump(rows, open(os.path.join(D, 'simset_raw.json'), 'w'),
          ensure_ascii=False, indent=1)
for r in rows:
    print('=' * 72)
    print(r['prd'], r.get('prd_nm'), 'HTTP', r.get('http'), 'ok=', r.get('ok'),
          'final=', r.get('final'))
    if r.get('error'):
        print('  ERR', r['error'])
    if r.get('raw'):
        print('  RAW', r['raw'])
    if r.get('errors'):
        print('  errors:', r['errors'])
    for m in r.get('members_out') or []:
        print(f"  - {m['role']} {m['sub']} plate={m['plate']} ({m['plate_status']}) "
              f"pansu={m['pansu']} qty={m['qty']} price={m['price']} "
              f"comp={m['n_comp']} excl={m['excluded']}")
        if m['plate_status'] == 'no_plates':
            print('       diag:', m['plate_diag'])
