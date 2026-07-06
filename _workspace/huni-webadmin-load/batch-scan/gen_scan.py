import json, sys
d=json.load(open('_workspace/huni-webadmin-load/batch-scan/products.json'))
start=int(sys.argv[1]); end=int(sys.argv[2])
sl=d[start:end]
body=open('_workspace/huni-webadmin-load/batch-scan/scan_body.js').read()
js=f"const PRDS={json.dumps(sl,ensure_ascii=False)};\n"+body
open('/tmp/scan_run.js','w').write(js)
print(f"슬라이스 [{start}:{end}] = {len(sl)}개")
