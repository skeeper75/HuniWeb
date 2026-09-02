# -*- coding: utf-8 -*-
"""완료조건 ⑤ — 무작위 15건 재대조(근거 파일 실재 + 인용 토큰 실재)"""
import csv,json,os,random,re
HERE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(HERE,'..','..','..'))          # 07_rebaseline
REPO=os.path.abspath(os.path.join(ROOT,'..','..','..'))          # HuniWeb
V2=list(csv.DictReader(open(os.path.join(HERE,'..','standard-feature-canon-v2.csv'),encoding='utf-8')))
NEW=set(json.load(open(os.path.join(HERE,'decisions.json')))['new'])
random.seed(20260902)
pool=[r for r in V2 if r['std_id'] in NEW or r['std_id'].startswith('STD-MFG')]
sample=pool
ALIAS={
 'order-to-mes-process.md':'raw/webadmin/docs/order-to-mes-process.md',
 'artwork-scan-integration.md':'raw/webadmin/docs/artwork-scan-integration.md',
 'aws-architecture-huni.pdf':'docs/huni/aws-architecture-huni.pdf',
 'artwork_promote.py':'raw/webadmin/webadmin/catalog/artwork_promote.py',
 'manual_content.py':'raw/webadmin/webadmin/catalog/manual_content.py',
 'widget_api.py':'raw/webadmin/webadmin/catalog/widget_api.py',
 '후니프린팅_주문프로세스_20251001.pdf':'docs/huni/후니프린팅_주문프로세스_20251001.pdf',
 '후니프린팅_공정관리_시행초안_20260210.pdf':'docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf',
 '후니프린팅_통합IA_일정_역할분담_260616.xlsx':'docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx',
}
import unicodedata
def _ex(p):
    if os.path.exists(p): return True
    d,b=os.path.split(p)
    if not os.path.isdir(d): return False
    n=lambda x: unicodedata.normalize('NFC',x)
    return n(b) in {n(x) for x in os.listdir(d)}
def resolve(tok):
    tok=tok.split('#')[0].split(':')[0].strip()
    tok=ALIAS.get(tok,tok)
    if not tok: return None
    for base in (REPO, ROOT, os.path.join(REPO,'_workspace')):
        if _ex(os.path.join(base,tok)): return os.path.join(base,tok)
    return None
bad=[]
for r in sample:
    toks=re.findall(r'[^\s·\[\]]+\.(?:md|pdf|py|json|xlsx|csv|ts|tsx)', r['근거출처'])
    res=[(t, resolve(t) is not None) for t in toks]
    hit=sum(1 for _,b in res if b)
    status='OK' if hit>0 else ('NO-PATH' if not toks else 'MISS')
    if status!='OK': bad.append((r['std_id'],r['근거출처'][:90],res))
    #print(f"{status:8} {r['std_id']:14} {r['기능'][:40]:42} 근거토큰 {len(toks)} 실재 {hit}")
print(f"전수 {len(sample)}행 · 근거 미실재 {len(bad)}")
for b in bad: print("  ",b)
