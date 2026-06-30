#!/usr/bin/env python3
# 비종이류 판형 오적재 교정본 — 4중 확증(자재 비종이 + spine 비종이 + output_paper_typ 빈값) 판형 행 논리삭제.
import csv, os, json
HERE=os.path.dirname(os.path.abspath(__file__))
SNAP=os.path.abspath(os.path.join(HERE,"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
spine={r.get('prd_cd',''):r.get('종이류여부','') for r in csv.DictReader(open(os.path.join(HERE,'..','..','huni-product-readiness','00_spine','product-spine.csv'), encoding='utf-8-sig'))}
prds={p['prd_cd']:p for p in load('t_prd_products')}
sizes={s['siz_cd']:s for s in load('t_siz_sizes')}
# 자재 기반 비종이류(C 135) — spine도 비종이인 것만(false-positive 6 제외)
C=json.load(open(f"{HERE}/nonpaper-plate-defects.json"))
nonpaper_prds={d['prd_cd'] for d in C if not spine.get(d['prd_cd'],'').strip().upper().startswith('Y')}
# 대상 판형 행: 비종이류 상품 + output_paper_typ 빈값 + 활성
targets=[]
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')!='N': continue
    if r['prd_cd'] in nonpaper_prds and not (r.get('output_paper_typ_cd') or '').strip():
        targets.append(r)
prds_in=sorted({t['prd_cd'] for t in targets})
print(f"교정 대상: {len(prds_in)}상품 · {len(targets)}판형행 (비종이+spine비종이+출력유형빔)")

def emit(commit):
    L=["\\set ON_ERROR_STOP on","SET client_min_messages=warning;","BEGIN;"]
    for t in targets:
        nm=prds.get(t['prd_cd'],{}).get('prd_nm','')
        sn=sizes.get(t['siz_cd'],{}).get('siz_nm','')
        L.append(f"-- {t['prd_cd']} {nm}: 판형 {t['siz_cd']}({sn}) 논리삭제(완제품 오적재)")
        L.append(f"UPDATE t_prd_product_plate_sizes SET del_yn='Y', del_dt=now() WHERE prd_cd='{t['prd_cd']}' AND siz_cd='{t['siz_cd']}' AND del_yn='N';")
    pin="','".join(prds_in)
    L.append(f"SELECT '잔여 활성판형' AS chk, count(*) FROM t_prd_product_plate_sizes WHERE prd_cd IN ('{pin}') AND del_yn='N';")
    L.append("COMMIT;" if commit else "ROLLBACK;")
    return "\n".join(L)+"\n"
open(f"{HERE}/nonpaper-fix-dryrun.sql","w").write(emit(False))
open(f"{HERE}/nonpaper-fix-COMMIT.sql","w").write(emit(True))
# undo
U=["\\set ON_ERROR_STOP on","BEGIN;"]
for t in targets:
    U.append(f"UPDATE t_prd_product_plate_sizes SET del_yn='N', del_dt=NULL WHERE prd_cd='{t['prd_cd']}' AND siz_cd='{t['siz_cd']}';")
U.append("-- COMMIT;\nROLLBACK;")
open(f"{HERE}/nonpaper-fix-undo.sql","w").write("\n".join(U)+"\n")
print("생성: nonpaper-fix-dryrun.sql · nonpaper-fix-COMMIT.sql · nonpaper-fix-undo.sql")
