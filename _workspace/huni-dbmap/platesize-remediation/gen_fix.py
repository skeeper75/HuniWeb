#!/usr/bin/env python3
# 판형 오매핑 교정 SQL 생성 — defects-all.json → UPDATE(+dryrun+undo). 결정론.
# 올바른 판형 = 그 상품 판형축 comp들이 공통 단가를 가진 판형(교집합). 단일이면 확정 교정.
import json, os
from collections import defaultdict
HERE=os.path.dirname(os.path.abspath(__file__))
defects=json.load(open(f"{HERE}/platesize-defects-all.json"))
byprd=defaultdict(list)
for d in defects: byprd[d['prd_cd']].append(d)

fixes=[]; ambiguous=[]
for prd, ds in sorted(byprd.items()):
    cur=set(ds[0]['cur_plates'])
    inter=None
    for d in ds:
        s=set(d['comp_priced_plates'])
        inter = s if inter is None else (inter & s)
    if len(cur)==1 and inter and len(inter)==1:
        fixes.append({'prd_cd':prd,'nm':ds[0]['prd_nm'],'old':next(iter(cur)),'new':next(iter(inter)),
                      'comps':[d['comp_cd'] for d in ds]})
    else:
        ambiguous.append({'prd_cd':prd,'nm':ds[0]['prd_nm'],'cur':sorted(cur),'inter':sorted(inter or [])})

def sqls(rollback):
    L=["-- 판형 오매핑 교정 (결정론 생성·gen_fix.py)",
       "-- [HARD] 인간 승인 전 COMMIT 금지. 단가 무관·plate_size siz_cd만 교정.",
       "\\set ON_ERROR_STOP on","BEGIN;"]
    for f in fixes:
        L.append(f"-- {f['prd_cd']} {f['nm']}: 판형 {f['old']} → {f['new']} (미스매치 comp: {','.join(f['comps'])})")
        L.append(f"UPDATE t_prd_product_plate_sizes SET siz_cd='{f['new']}', upd_dt=now() "
                 f"WHERE prd_cd='{f['prd_cd']}' AND siz_cd='{f['old']}' AND del_yn='N';")
    L.append("-- 사후검증:")
    prds="','".join(f['prd_cd'] for f in fixes)
    L.append(f"SELECT prd_cd, siz_cd, dflt_plt_yn FROM t_prd_product_plate_sizes WHERE prd_cd IN ('{prds}') AND del_yn='N' ORDER BY prd_cd;")
    L.append("ROLLBACK;" if rollback else "-- COMMIT;   -- ← 인간 승인 후 주석 해제")
    L.append("ROLLBACK;" if not rollback else "")
    return "\n".join(x for x in L if x!="")

open(f"{HERE}/platesize-fix-dryrun.sql","w").write(sqls(rollback=True)+"\n")
# 실행본: COMMIT 주석 + 끝 ROLLBACK(승인 시 COMMIT 주석해제·ROLLBACK 삭제)
open(f"{HERE}/platesize-fix.sql","w").write(sqls(rollback=False)+"\n")
# undo
U=["-- 판형 교정 undo","\\set ON_ERROR_STOP on","BEGIN;"]
for f in fixes:
    U.append(f"UPDATE t_prd_product_plate_sizes SET siz_cd='{f['old']}', upd_dt=now() WHERE prd_cd='{f['prd_cd']}' AND siz_cd='{f['new']}' AND del_yn='N';")
U.append("-- COMMIT;")
U.append("ROLLBACK;")
open(f"{HERE}/platesize-fix-undo.sql","w").write("\n".join(U)+"\n")

print(f"확정 교정: {len(fixes)}건")
for f in fixes: print(f"  {f['prd_cd']} {f['nm']}: {f['old']} → {f['new']}")
print(f"모호(사람 확인): {len(ambiguous)}건")
for a in ambiguous: print(f"  {a['prd_cd']} {a['nm']}: cur={a['cur']} inter={a['inter']}")
print("\n생성: platesize-fix.sql · platesize-fix-dryrun.sql · platesize-fix-undo.sql")
