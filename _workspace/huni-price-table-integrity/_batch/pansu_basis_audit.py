#!/usr/bin/env python3
"""
판걸이수 basis 전수 감사 — 재단 vs 라이브 work vs 권위 시트 작업사이즈 일관성 + 엔진 대조.

[HARD] 사용자 지침: 판수는 작업사이즈 기준. 적재 전 사이즈별로
  (시트 작업사이즈 == 라이브 work 치수) 인지 확인해야 사과-오렌지 비교를 피한다.
  basis 일관 GO 행만 t_siz_pansu 적재 후보.

라이브 읽기전용. 출력=audit CSV + 콘솔 요약. COMMIT 없음.
"""
import csv, os, sys, re
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_foundation", "batch"))
import lib_huni as H
H.load_env()

PANGEORI = os.path.join(os.path.dirname(__file__), "..", "..", "huni-dbmap", "06_extract", "pangeori-l1.csv")
OUT = os.path.join(os.path.dirname(__file__), "pansu-basis-audit-260701.csv")

def dims(s):
    """'102x152' or '145 x 145' -> (102.0,152.0) ; '' -> None"""
    if not s: return None
    m = re.findall(r"(\d+(?:\.\d+)?)", s)
    if len(m) >= 2: return (float(m[0]), float(m[1]))
    return None

# 1) 라이브 사이즈 인덱스: work 치수 -> [siz_cd,...], cut 치수 -> [siz_cd,...]
rows = H.db("""SELECT siz_cd, siz_nm, cut_width, cut_height, work_width, work_height
  FROM t_siz_sizes WHERE del_yn='N'""")
by_work = {}; by_cut = {}; siz_info = {}
for sc, nm, cw, ch, ww, wh in rows:
    siz_info[sc] = (nm, cw, ch, ww, wh)
    def f(x):
        try: return float(x)
        except: return None
    if f(ww) and f(wh): by_work.setdefault((f(ww), f(wh)), []).append(sc)
    if f(cw) and f(ch): by_cut.setdefault((f(cw), f(ch)), []).append(sc)

# 2) 판형 dims -> siz_cd
PLATE = {(316.0,467.0): "SIZ_000499", (330.0,660.0): "SIZ_000475", (330.0,470.0): "SIZ_000521"}
def plate_siz(pd):
    return PLATE.get(pd)

# 3) 판걸이수 시트 전수 감사
audit = []
with open(PANGEORI, encoding="utf-8-sig") as f:
    r = csv.reader(f)
    hdr = next(r)
    for row in r:
        if not row or row[0] != "판걸이수": continue
        opt_nm = row[4]; cut_s = row[5]; bleed = row[6]; work_s = row[7]
        prod = row[8]; pansu_a = row[9]; guk4 = row[10]; sam3 = row[11]
        cut_d = dims(cut_s); work_d = dims(work_s)
        pansu_auth = None
        try: pansu_auth = int(pansu_a)
        except: pass
        plate_d = dims(guk4) or dims(sam3)
        plate_cd = plate_siz(plate_d) if plate_d else None
        # 라이브 매칭: 우선 cut 로, 없으면 work 로
        live = by_cut.get(cut_d, []) if cut_d else []
        match_by = "cut"
        if not live and work_d:
            live = by_work.get(work_d, []); match_by = "work"
        # basis 일관성: 각 매칭 siz 의 live work == 시트 작업사이즈 ?
        recs = []
        for sc in live:
            nm, cw, ch, ww, wh = siz_info[sc]
            try: lw, lh = float(ww), float(wh)
            except: lw = lh = None
            basis_ok = (work_d is not None and lw is not None and (lw, lh) == work_d)
            eng = None
            if plate_cd and sc:
                v = H.db(f"SELECT fn_calc_pansu('{plate_cd}','{sc}')")
                try: eng = int(v[0][0]) if v and v[0] and v[0][0] not in (None,"") else None
                except: eng = None
            recs.append((sc, nm, ww, wh, basis_ok, eng))
        audit.append({
            "opt_nm": opt_nm, "prod": prod, "cut": cut_s, "bleed": bleed,
            "work_sheet": work_s, "pansu_auth": pansu_auth,
            "plate": (guk4 or sam3), "plate_cd": plate_cd, "match_by": match_by,
            "recs": recs,
        })

# 4) 리포트
print(f"{'옵션명':22s} {'상품':12s} {'재단':10s} {'시트작업':10s} {'판형cd':12s} {'siz_cd':13s} {'live_work':10s} basis 권위 엔진 결정")
n_load = n_hold_basis = n_hold_nomatch = n_conflict = n_nochange = 0
csv_rows = []
for a in audit:
    if not a["recs"]:
        n_hold_nomatch += 1
        print(f"{a['opt_nm'][:22]:22s} {a['prod'][:12]:12s} {a['cut']:10s} {a['work_sheet']:10s} {str(a['plate_cd']):12s} {'—':13s} {'—':10s}  NOLIVE  auth={a['pansu_auth']} HOLD(무매칭)")
        csv_rows.append([a['opt_nm'],a['prod'],a['cut'],a['work_sheet'],a['plate_cd'],'','','NO_LIVE',a['pansu_auth'],'','HOLD_NOMATCH'])
        continue
    for sc, nm, ww, wh, basis_ok, eng in a["recs"]:
        lw = f"{ww}x{wh}"
        auth = a["pansu_auth"]
        if not basis_ok:
            decision = "HOLD_BASIS"; n_hold_basis += 1
        elif auth is None:
            decision = "HOLD_NOAUTH"
        elif eng is None:
            decision = "LOAD_ENG0"  # 엔진 0/NULL (썬캡류) — 권위로 override 필요
            n_load += 1
        elif eng == auth:
            decision = "NOCHANGE"; n_nochange += 1
        else:
            decision = f"LOAD({eng}->{auth})"; n_load += 1
        flag = "OK " if basis_ok else "MIS"
        print(f"{a['opt_nm'][:22]:22s} {a['prod'][:12]:12s} {a['cut']:10s} {a['work_sheet']:10s} {str(a['plate_cd']):12s} {sc:13s} {lw:10s}  {flag} {str(auth):>4s} {str(eng):>4s} {decision}")
        csv_rows.append([a['opt_nm'],a['prod'],a['cut'],a['work_sheet'],a['plate_cd'],sc,lw,'OK' if basis_ok else 'MISMATCH',auth,eng,decision])

print(f"\n요약: LOAD후보={n_load}  NOCHANGE(시트=엔진)={n_nochange}  HOLD_BASIS(basis불일치)={n_hold_basis}  HOLD_NOMATCH(무매칭)={n_hold_nomatch}")
with open(OUT, "w", encoding="utf-8-sig", newline="") as f:
    w = csv.writer(f)
    w.writerow(["opt_nm","prod","cut","work_sheet","plate_cd","siz_cd","live_work","basis","pansu_auth","engine_pansu","decision"])
    w.writerows(csv_rows)
print(f"→ {OUT}")
