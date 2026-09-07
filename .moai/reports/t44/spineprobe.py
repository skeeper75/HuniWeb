"""Max Page 책등·표지 펼침 실측(읽기·계산 전용·DB write 0).

엔진에게 직접 묻는다 — 손으로 모델링하지 않는다.
각 셋트에 대해 ① 내지 최대두께 자재 ② page_max ③ 제본공정 을 실어 넣고
sim-meta 의 spine 설정 + simulate-set 응답에서 책등·펼침을 읽는다.
"""
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


# 부모 → (제본 proc_cd, 제본방향)
CASES = {
    'PRD_000069': ('PROC_000019', '세로형좌철'),   # 무선제본
    'PRD_000070': ('PROC_000020', '세로형좌철'),   # PUR제본
    'PRD_000072': ('PROC_000023', '세로형좌철'),   # 하드커버무선제본
    'PRD_000077': ('PROC_000023', '세로형좌철'),   # 하드커버무선제본
}

rows = []
for prd, (proc_cd, bind_dir) in CASES.items():
    code, body = call(META_JS % prd)
    meta = json.loads(body)
    spine_cfg = (meta.get('spine') or {}).get(proc_cd)
    inner = next((m for m in meta['set_members'] if m.get('is_inner')), None)
    cover = next((m for m in meta['set_members']
                  if m.get('role') == 'SEMI_ROLE.02'), None)
    # 내지 페이지 상한 — 구성원 page_rules 에서 양면 규칙의 page_max
    prules = inner.get('page_rules') or ([inner['page_rule']] if inner.get('page_rule') else [])
    # 내지 최대두께 자재는 DB 실측값을 인자로 받는다(meta 에는 depth 가 없을 수 있다)
    rows.append({'prd': prd, 'prd_nm': meta.get('prd_nm'), 'proc_cd': proc_cd,
                 'spine_cfg': spine_cfg, 'page_rules': prules,
                 'inner': inner['sub_prd_cd'],
                 'inner_sizes': [(o['v'], o['t']) for o in inner.get('sizes') or []],
                 'inner_mats': [(o['v'], o['t']) for o in inner.get('materials') or []],
                 'cover': cover['sub_prd_cd'] if cover else None,
                 'cover_sizes': [(o['v'], o['t']) for o in (cover or {}).get('sizes') or []],
                 'meta_keys': sorted(meta.keys())})

json.dump(rows, open(os.path.join(D, 'spine_meta.json'), 'w'),
          ensure_ascii=False, indent=1)
for r in rows:
    print('=' * 74)
    print(r['prd'], r['prd_nm'], '| 제본', r['proc_cd'])
    print('  spine cfg :', json.dumps(r['spine_cfg'], ensure_ascii=False)[:300])
    print('  page_rules:', json.dumps(r['page_rules'], ensure_ascii=False)[:200])
    print('  내지', r['inner'], r['inner_sizes'])
    print('  표지', r['cover'], r['cover_sizes'])
