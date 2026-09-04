"""t43 가격 시뮬레이션 v2 — 페이지 안에서 동기 XHR 로 simulate 만 호출(계산 전용·쓰기 0).

브라우저 페이지 컨텍스트에서 돌리므로 세션 쿠키·CSRF·Origin 이 자동으로 붙는다.
"""
import json
import os
import subprocess

BROWSE = os.path.expanduser('~/.claude/skills/gstack/browse/dist/browse')

CASES = [
    ('A4 100부 — 현재 SIZ_000172 (work 290x377)', 'SIZ_000172'),
    ('A4 100부 — 권장 SIZ_000252 (work 213x303 · 형제 5상품 공통)', 'SIZ_000252'),
    ('A4 100부 — t42안 SIZ_000258 (work 210x297)', 'SIZ_000258'),
    ('A5 100부 — 현재 SIZ_000007 (work 150x212)', 'SIZ_000007'),
    ('B5 100부 — 현재 SIZ_000380 (work 182x257)', 'SIZ_000380'),
]

JS = """(function(){
  var t=(document.cookie.match(/csrftoken=([^;]+)/)||[])[1]||'';
  var x=new XMLHttpRequest();
  x.open('POST','/admin/price-viewer/PRD_000286/simulate/',false);
  x.setRequestHeader('Content-Type','application/json');
  x.setRequestHeader('X-CSRFToken',t);
  x.send(JSON.stringify(%s));
  return x.status+' '+x.responseText;
})()"""

results = []
for label, siz in CASES:
    payload = {
        'selections': {'siz_cd': siz, 'mat_cd': 'MAT_000072',
                       'print_opt_cd': 'POPT_000002'},
        'qty': 100,
        'procs': [{'proc_cd': 'PROC_000004', 'detail': {}}],
        'mode': 'lenient',
    }
    expr = JS % json.dumps(payload)
    r = subprocess.run([BROWSE, 'js', expr], capture_output=True, text=True)
    results.append({'case': label, 'siz_cd': siz,
                    'out': r.stdout.strip(), 'err': r.stderr.strip()[:200]})

with open('.moai/reports/t43/sim_raw.json', 'w') as f:
    json.dump(results, f, ensure_ascii=False, indent=1)

for r in results:
    print('=' * 70)
    print(r['case'])
    out = r['out']
    body = out.split(' ', 1)
    if len(body) == 2 and body[0].isdigit():
        print(f'  HTTP {body[0]}')
        try:
            j = json.loads(body[1])
        except ValueError:
            print('  ' + body[1][:400])
            continue
        print(f"  keys = {sorted(j.keys())}")
        for k in ('ok', 'final_price', 'total', 'sum_price', 'errors',
                  'plt_siz_cd', 'pansu', 'plate_qty', 'eff_qty'):
            if k in j:
                print(f'  {k} = {j[k]}')
        if isinstance(j.get('selections'), dict):
            print(f"  selections = {j['selections']}")
        for ln in (j.get('lines') or j.get('details') or j.get('items') or []):
            print(f'  line: {json.dumps(ln, ensure_ascii=False)[:300]}')
    else:
        print('  RAW: ' + out[:400])
        if r['err']:
            print('  ERR: ' + r['err'])
