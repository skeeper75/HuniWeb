"""표지 사이즈별 판형 자동선택·금액 실측(읽기·계산 전용·DB write 0).

각 셋트 부모에 대해 표지 구성원의 사이즈를 하나씩 바꿔가며 simulate-set 을 호출하고,
선택된 판형·상태·표지 금액을 원장화한다. 내지는 기본선택 고정.
"""
import json
import os
import sys

D = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, D)
from simset import META_JS, SIM_JS, call, pick  # noqa: E402

COPIES, PAGES = 100, 24
PARENTS = ['PRD_000068', 'PRD_000069', 'PRD_000070', 'PRD_000072', 'PRD_000077']
rows = []

for prd in PARENTS:
    code, body = call(META_JS % prd)
    meta = json.loads(body)
    cover = next((m for m in meta['set_members']
                  if m.get('role') == 'SEMI_ROLE.02'), None)
    if not cover:
        continue
    for opt in cover.get('sizes') or []:
        members = []
        for m in meta['set_members']:
            inner = bool(m.get('is_inner'))
            siz = (opt['v'] if m['sub_prd_cd'] == cover['sub_prd_cd']
                   else pick(m.get('sizes')))
            mb = {'sub_prd_cd': m['sub_prd_cd'], 'role': m.get('role'),
                  'label': m.get('role_nm'), 'siz_cd': siz,
                  'mat_cd': pick(m.get('materials')),
                  'print_opt_cd': pick(m.get('print_opts')),
                  'qty_mode': 'derived' if inner else 'manual'}
            if inner:
                mb['pages'] = PAGES
            members.append(mb)
        payload = {'copies': COPIES, 'mode': 'lenient', 'members': members,
                   'set_selections': {}, 'set_procs': []}
        code, body = call(SIM_JS % (prd, json.dumps(payload)))
        try:
            j = json.loads(body)
        except ValueError:
            rows.append({'prd': prd, 'cover_siz': opt['v'], 'raw': body[:200]})
            continue
        cm = next((m for m in j.get('members') or []
                   if m.get('sub_prd_cd') == cover['sub_prd_cd']), {})
        qb = cm.get('qty_breakdown') or {}
        base = ((cm.get('eval') or {}).get('base') or {})
        comps = base.get('components') or []
        rows.append({
            'prd': prd, 'prd_nm': meta['prd_nm'], 'cover': cover['sub_prd_cd'],
            'cover_siz': opt['v'], 'cover_siz_nm': opt['t'],
            'plate': qb.get('plate'), 'plate_status': qb.get('plate_status'),
            'cover_amount': base.get('amount'),
            'cover_final': (cm.get('eval') or {}).get('final_price'),
            'set_final': j.get('final_price'),
            'comp_included': [c['comp_cd'] for c in comps if c.get('included')],
            'comp_excluded': [c['comp_cd'] for c in comps if not c.get('included')],
            'warnings': j.get('warnings'),
        })

json.dump(rows, open(os.path.join(D, 'coverprobe_raw.json'), 'w'),
          ensure_ascii=False, indent=1)
for r in rows:
    print('=' * 78)
    print(f"{r['prd']} {r.get('prd_nm')} | 표지 {r.get('cover')} "
          f"siz={r['cover_siz']} {r.get('cover_siz_nm')}")
    print(f"  plate={r.get('plate')} ({r.get('plate_status')}) "
          f"표지금액={r.get('cover_amount')} 표지최종={r.get('cover_final')} "
          f"셋트최종={r.get('set_final')}")
    print(f"  included={r.get('comp_included')}")
    print(f"  excluded={r.get('comp_excluded')}")
