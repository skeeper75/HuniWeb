"""sim-meta 읽기(계산·조회 전용·쓰기 0). 페이지 컨텍스트에서 동기 XHR."""
import json, os, subprocess, sys
BROWSE = os.path.expanduser('~/.claude/skills/gstack/browse/dist/browse')
JS = """(function(){var x=new XMLHttpRequest();
x.open('GET','/admin/price-viewer/%s/sim-meta/',false);x.send();
return x.status+' '+x.responseText;})()"""
prd = sys.argv[1]
r = subprocess.run([BROWSE, 'js', JS % prd], capture_output=True, text=True)
out = r.stdout.strip()
code, _, body = out.partition(' ')
print('HTTP', code, 'len', len(body))
try:
    j = json.loads(body)
except ValueError:
    print(body[:600]); sys.exit(1)
open(f'.moai/reports/t9/meta_{prd}.json','w').write(json.dumps(j, ensure_ascii=False, indent=1))
print('top keys:', sorted(j.keys()))
