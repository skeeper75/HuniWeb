"""webadmin 읽기 탐색 헬퍼 — 자격증명은 주 체크아웃 .env.local 에서만 읽고 절대 출력하지 않는다.

사용: python3 .moai/reports/t43/wa.py <browse 하위명령> [인자...]
      python3 .moai/reports/t43/wa.py --login
      python3 .moai/reports/t43/wa.py --url <경로>      # HUNI_ADMIN_URL 뒤에 붙여 goto
[HARD] 저장·삭제·주문·결제 금지. 읽기 탐색만.
"""
import os
import subprocess
import sys

ENV = '/Users/innojini/Dev/HuniWeb/.env.local'
BROWSE = os.path.expanduser('~/.claude/skills/gstack/browse/dist/browse')

v = {}
for line in open(ENV):
    line = line.strip()
    if line.startswith('HUNI_ADMIN_'):
        k, _, val = line.partition('=')
        v[k] = val.strip().strip('"').strip("'")

# HUNI_ADMIN_URL 은 경로까지 들어 있어(.../admin/product-viewer) 오리진만 뽑아 쓴다
from urllib.parse import urlsplit  # noqa: E402

_u = urlsplit(v['HUNI_ADMIN_URL'])
BASE = f'{_u.scheme}://{_u.netloc}'


def b(*args):
    r = subprocess.run([BROWSE, *args], capture_output=True, text=True)
    return r.stdout + (('\n[STDERR] ' + r.stderr) if r.stderr.strip() else '')


if sys.argv[1] == '--login':
    print(b('goto', f'{BASE}/admin/login/?next=/admin/'))
    print(b('fill', '#id_username', v['HUNI_ADMIN_ID']).replace(v['HUNI_ADMIN_ID'], '<ID>'))
    print(b('fill', '#id_password', v['HUNI_ADMIN_PW']).replace(v['HUNI_ADMIN_PW'], '<PW>'))
    print(b('press', 'Enter'))
    print(b('url'))
elif sys.argv[1] == '--runjs':
    # 페이지로 이동한 뒤 JS 파일을 브라우저에서 돌린다(읽기 계산 전용).
    print(b('goto', BASE + sys.argv[2]))
    print(b('eval', sys.argv[3]))
elif sys.argv[1] == '--url':
    print(b('goto', BASE + sys.argv[2]))
    print(b('url'))
else:
    out = b(*sys.argv[1:])
    for secret in (v.get('HUNI_ADMIN_ID'), v.get('HUNI_ADMIN_PW')):
        if secret:
            out = out.replace(secret, '<redacted>')
    print(out)
