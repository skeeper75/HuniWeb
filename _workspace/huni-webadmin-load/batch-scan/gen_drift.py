import json, sys
d=json.load(open('_workspace/huni-webadmin-load/batch-scan/products.json'))
# 슬라이스 [start:end] 또는 prd_cd 목록(콤마)
if sys.argv[1].startswith('PRD_'):
    want=set(sys.argv[1].split(','))
    sl=[r for r in d if r['prd_cd'] in want]
else:
    start=int(sys.argv[1]); end=int(sys.argv[2]); sl=d[start:end]
body=open('_workspace/huni-webadmin-load/batch-scan/drift_scan.js').read()
js=f"const PRDS={json.dumps(sl,ensure_ascii=False)};\n"+body
open('/tmp/drift_run.js','w').write(js)
print(f"드리프트 슬라이스 = {len(sl)}개")
