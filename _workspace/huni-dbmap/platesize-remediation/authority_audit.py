#!/usr/bin/env python3
# 판형 권위 대조 — 상품마스터 '파일사양_출력용지규격' ↔ 라이브 plate_size. 결정론.
# 출력규격 텍스트(WxH)→siz_cd 매핑 후 라이브와 대조. 불일치=오적재(권위값으로 교정).
import csv, os, re, json
from collections import defaultdict
HERE=os.path.dirname(os.path.abspath(__file__))
EXTRACT=os.path.abspath(os.path.join(HERE,"..","24_master-extract-260610"))
SNAP=os.path.abspath(os.path.join(HERE,"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
sizes=load('t_siz_sizes'); prds=load('t_prd_products')

def dims(txt):
    m=re.search(r'(\d+)\s*[xX×]\s*(\d+)', txt or '')
    return (int(m.group(1)), int(m.group(2))) if m else None
# (w,h)→siz_cd : siz_nm 우선, cut 보조 (활성만)
wh2siz={}
for s in sizes:
    if s.get('del_yn')!='N': continue
    d=dims(s.get('siz_nm',''))
    if d: wh2siz.setdefault(d, s['siz_cd'])
    if s.get('cut_width') and s.get('cut_height'):
        try: wh2siz.setdefault((round(float(s['cut_width'])),round(float(s['cut_height']))), s['siz_cd'])
        except: pass
nm2prd={p['prd_nm']:p['prd_cd'] for p in prds if p.get('del_yn')=='N'}
# 라이브 plate_size
live=defaultdict(set)
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')=='N': live[r['prd_cd']].add(r['siz_cd'])

SHEETS=['digital-print','sticker','acrylic','calendar','design-calendar','goods-pouch','silsa','booklet']
auth=defaultdict(set); unmapped_txt=set()
for sh in SHEETS:
    fp=f"{EXTRACT}/{sh}-l1.csv"
    if not os.path.exists(fp): continue
    rows=list(csv.reader(open(fp, encoding='utf-8-sig')))
    hdr=rows[0]
    oc=next((i for i,h in enumerate(hdr) if '출력용지규격' in h), None)
    pc=next((i for i,h in enumerate(hdr) if h=='prd_nm'), 2)
    if oc is None: continue
    for r in rows[1:]:
        if len(r)<=max(oc,pc): continue
        nm=r[pc].strip(); txt=r[oc].strip()
        if not nm or not txt: continue
        prd=nm2prd.get(nm)
        if not prd: continue
        d=dims(txt)
        sc=wh2siz.get(d) if d else None
        if sc: auth[prd].add(sc)
        elif d: unmapped_txt.add((txt,d))

# 대조: 권위 siz_cd set vs 라이브
defects=[]
for prd in sorted(auth):
    a=auth[prd]; l=live.get(prd,set())
    if a and a!=l:
        nm=next((p['prd_nm'] for p in prds if p['prd_cd']==prd),'')
        defects.append({'prd_cd':prd,'prd_nm':nm,
          'live_plates':sorted(l),'authority_plates':sorted(a),
          'missing_in_live':sorted(a-l),'extra_in_live':sorted(l-a)})
print(f"권위 출력규격 보유 상품: {len(auth)} | 라이브와 불일치: {len(defects)}")
print(f"매핑 못한 출력규격 텍스트: {len(unmapped_txt)} {list(unmapped_txt)[:8]}\n")
for d in defects:
    print(f"  {d['prd_cd']} {d['prd_nm']}")
    print(f"     라이브={d['live_plates']} vs 권위={d['authority_plates']}  (라이브에없음={d['missing_in_live']} 라이브여분={d['extra_in_live']})")
json.dump(defects, open(f"{HERE}/authority-defects.json","w"), ensure_ascii=False, indent=1)
print(f"\n→ authority-defects.json ({len(defects)}건)")
