#!/usr/bin/env python3
# 판형 권위 교정본 생성 — authority-defects.json → 여분삭제(논리)+전지추가(INSERT). 분류·결정론.
import csv, os, json
HERE=os.path.dirname(os.path.abspath(__file__))
SNAP=os.path.abspath(os.path.join(HERE,"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
sizes={s['siz_cd']:s for s in load('t_siz_sizes')}
pps={}  # 라이브 행 상세(dflt·output_paper_typ)
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')=='N': pps[(r['prd_cd'],r['siz_cd'])]=r
defects=json.load(open(f"{HERE}/authority-defects.json"))

def dim(sc):
    s=sizes.get(sc,{}); 
    import re
    m=re.search(r'(\d+)\D+(\d+)', s.get('siz_nm','') or '')
    return (int(m.group(1)),int(m.group(2))) if m else None

groups={'DELETE_EXTRA':[],'REPLACE':[],'ADD_ONLY':[],'AMBIGUOUS':[]}
for d in defects:
    miss=d['missing_in_live']; extra=d['extra_in_live']
    # 애매: miss·extra 둘 다 1개이고 크기 거의 동일(±2mm) = 전지 미세차
    if len(miss)==1 and len(extra)==1:
        dm,de=dim(miss[0]),dim(extra[0])
        if dm and de and abs(dm[0]-de[0])<=2 and abs(dm[1]-de[1])<=2:
            groups['AMBIGUOUS'].append(d); continue
    if not miss and extra: groups['DELETE_EXTRA'].append(d)
    elif miss and extra: groups['REPLACE'].append(d)
    else: groups['ADD_ONLY'].append(d)

def emit(ds, rollback):
    L=["\\set ON_ERROR_STOP on","BEGIN;"]
    for d in ds:
        prd=d['prd_cd']
        L.append(f"-- {prd} {d['prd_nm']}: 라이브{d['live_plates']}→권위{d['authority_plates']}")
        for sc in d['extra_in_live']:
            L.append(f"UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='{prd}' AND siz_cd='{sc}' AND del_yn='N';")
        for sc in d['missing_in_live']:
            ex=next((pps[(prd,e)] for e in d['extra_in_live'] if (prd,e) in pps), None)
            opt=ex.get('output_paper_typ_cd') if ex else None
            optv=f"'{opt}'" if opt else "NULL"
            L.append(f"INSERT INTO t_prd_product_plate_sizes(prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,reg_dt,del_yn) "
                     f"VALUES('{prd}','{sc}','Y',{optv},now(),'N') ON CONFLICT DO NOTHING;")
    prds="','".join(d['prd_cd'] for d in ds)
    L.append(f"SELECT prd_cd, siz_cd, dflt_plt_yn, del_yn FROM t_prd_product_plate_sizes WHERE prd_cd IN ('{prds}') ORDER BY prd_cd, del_yn, siz_cd;")
    L.append("ROLLBACK;" if rollback else "-- COMMIT;  -- 인간 승인 후\nROLLBACK;")
    return "\n".join(L)+"\n"

for g,ds in groups.items():
    print(f"{g}: {len(ds)}상품 — {[d['prd_cd'] for d in ds]}")
# 가장 안전한 DELETE_EXTRA + REPLACE 교정본(dryrun)
safe=groups['DELETE_EXTRA']+groups['REPLACE']
open(f"{HERE}/authority-fix-dryrun.sql","w").write(emit(safe, True))
open(f"{HERE}/authority-fix.sql","w").write(emit(safe, False))
print(f"\n교정본 생성: authority-fix.sql ({len(safe)}상품·DELETE_EXTRA+REPLACE)")
print(f"보류: AMBIGUOUS {len(groups['AMBIGUOUS'])} (사람 확인)")
