import csv,re,os,random
BASE={'huni-skin-shopby':'/Users/innojini/Dev/huni-skin-shopby','raw/webadmin':'/Users/innojini/Dev/HuniWeb/raw/webadmin'}
rows=list(csv.DictReader(open('L4/b/mapping.csv')))
random.seed(20260902)
sample=random.sample(rows,15)
pat=re.compile(r'((?:huni-skin-shopby|raw/webadmin)[\w/\.\-\[\]\(\)]+?\.(?:ts|tsx|py|prisma)):(\d+)')
ok=bad=skip=0
for r in sample:
    hits=pat.findall(r['근거'])
    if not hits:
        print(f"[SKIP] {r['std_id']} {r['상태']} — 파일근거 없음(정상: todo/new)"); skip+=1; continue
    for p,ln in hits:
        root='huni-skin-shopby' if p.startswith('huni-skin-shopby') else 'raw/webadmin'
        full=os.path.join(BASE[root], p[len(root)+1:]) if root=='huni-skin-shopby' else os.path.join('/Users/innojini/Dev/HuniWeb',p)
        if not os.path.exists(full): print(f"[FAIL] {r['std_id']} 파일 없음 {full}"); bad+=1; continue
        n=sum(1 for _ in open(full,errors='ignore'))
        if int(ln)<=n: print(f"[OK  ] {r['std_id']} {p}:{ln} (파일 {n}줄)"); ok+=1
        else: print(f"[FAIL] {r['std_id']} 라인초과 {p}:{ln} > {n}"); bad+=1
print(f"\n표본15 → 근거검증 OK {ok} · FAIL {bad} · 파일근거없음 {skip}")
