"""t43 사후 시뮬 — COMMIT 후 라이브 값으로 재계산(계산 전용·쓰기 0).

sim-meta 로 화면 사이즈 목록도 같이 확인한다(SIZ_000172 가 사라지고 SIZ_000252 가 떠야 한다).
"""
import json
import os
import subprocess

BROWSE = os.path.expanduser('~/.claude/skills/gstack/browse/dist/browse')

CASES = [
    ('A4 100매 — 교정 후 SIZ_000252 (work 213x303)', 'SIZ_000252'),
    ('A5 100매 — SIZ_000007 (무변경)', 'SIZ_000007'),
    ('B5 100매 — SIZ_000380 (무변경)', 'SIZ_000380'),
]

POST = """(function(){
  var t=(document.cookie.match(/csrftoken=([^;]+)/)||[])[1]||'';
  var x=new XMLHttpRequest();
  x.open('POST','/admin/price-viewer/PRD_000286/simulate/',false);
  x.setRequestHeader('Content-Type','application/json');
  x.setRequestHeader('X-CSRFToken',t);
  x.send(JSON.stringify(%s));
  return x.status+' '+x.responseText;
})()"""

GET_META = """(function(){
  var x=new XMLHttpRequest();
  x.open('GET','/admin/price-viewer/PRD_000286/sim-meta/',false);
  x.send();
  var j=JSON.parse(x.responseText);
  var d=(j.prod_dims||[]).filter(function(p){return p.name==='siz_cd';})[0]||{};
  return JSON.stringify(d.options||[]);
})()"""


def run_js(expr):
    return subprocess.run([BROWSE, 'js', expr],
                          capture_output=True, text=True).stdout.strip()


subprocess.run([BROWSE, 'goto',
                'https://huni-admin.printly.co.kr/admin/price-viewer/?prd=PRD_000286'],
               capture_output=True, text=True)

meta_raw = run_js(GET_META)
try:
    screen_sizes = json.loads(meta_raw)
except ValueError:
    screen_sizes = {'parse_error': meta_raw[:300]}

results = []
for label, siz in CASES:
    payload = {
        'selections': {'siz_cd': siz, 'mat_cd': 'MAT_000072',
                       'print_opt_cd': 'POPT_000002'},
        'qty': 100,
        'procs': [{'proc_cd': 'PROC_000004', 'detail': {}}],
        'mode': 'lenient',
    }
    out = run_js(POST % json.dumps(payload))
    head, _, body = out.partition(' ')
    try:
        j = json.loads(body)
    except ValueError:
        results.append({'case': label, 'siz_cd': siz, 'http': head,
                        'raw': body[:300]})
        continue
    comps = j.get('base', {}).get('components', [])
    results.append({
        'case': label, 'siz_cd': siz, 'http': head,
        'ok': j.get('ok'), 'errors': j.get('errors'),
        'final_price': j.get('final_price'), 'supply': j.get('supply'),
        'plt_siz_nm': (comps[0].get('matched_names') or {}).get('plt_siz_cd')
        if comps else None,
        'pansu': comps[0].get('pansu') if comps else None,
        'excluded': [c['comp_cd'] for c in comps if not c.get('included')],
        'lines': [{'comp': c['comp_cd'], 'unit': c.get('per_item'),
                   'qty': c.get('comp_qty'), 'subtotal': c.get('subtotal')}
                  for c in comps],
    })

payload_out = {'screen_size_options': screen_sizes, 'cases': results}
with open('.moai/reports/t43/sim-live-after-commit.json', 'w') as f:
    json.dump(payload_out, f, ensure_ascii=False, indent=1)

print('=== 화면(sim-meta) 사이즈 옵션 ===')
for o in screen_sizes if isinstance(screen_sizes, list) else []:
    print(f"  {o.get('v')}  {o.get('t')}  dflt={o.get('dflt')} "
          f"work={o.get('work_w')}x{o.get('work_h')}")
print()
for r in results:
    print(f"{r['case']}")
    print(f"  HTTP {r.get('http')} ok={r.get('ok')} errors={r.get('errors')} "
          f"제외={r.get('excluded')}")
    print(f"  판형={r.get('plt_siz_nm')} 판수={r.get('pansu')} "
          f"최종가={r.get('final_price')}")
    for ln in r.get('lines', []):
        print(f"    {ln}")
    print()
