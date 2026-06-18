#!/usr/bin/env python3
# round-24 release-status v2 재분류 — 원천 권위(price-quotability) 기준
# 입력: release-status.csv(v1·244행) + _reclassify/price-quotability.csv(233행)
# 규칙: QUOTABLE→✅정상등록가능, NOT-QUOTABLE→🟡옵션부족(현재 0),
#       NEEDS-DOMAIN→🟦보류, ❌미출시 유지, ◆/➖ 유지.
import csv, os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
V1 = os.path.join(BASE, "release-status.csv")
PQ = os.path.join(BASE, "_reclassify", "price-quotability.csv")
OUT_V2 = os.path.join(BASE, "release-status.csv")          # v2로 덮어씀(백업은 별도)
OUT_V1BAK = os.path.join(BASE, "release-status-v1.csv")
OUT_UP = os.path.join(BASE, "_reclassify", "upgraded-green.csv")

# price-quotability를 prd_cd로 인덱싱
pq = {}
with open(PQ, encoding="utf-8-sig") as f:
    for r in csv.DictReader(f):
        pq[r["prd_cd"]] = r

# v1 백업(원본 그대로 복사)
with open(V1, encoding="utf-8") as f:
    v1_lines = f.read()
with open(OUT_V1BAK, "w", encoding="utf-8") as f:
    f.write(v1_lines)

ST_GREEN = "✅정상등록가능"
ST_YELLOW = "🟡옵션부족"
ST_HOLD = "🟦보류"
ST_NONE = "❌미출시"

rows_out = []
upgraded = []
counts = {}  # category -> {total, green, yellow, hold, none, xref}

with open(V1, encoding="utf-8-sig") as f:
    rdr = csv.DictReader(f)
    fields = rdr.fieldnames[:]  # category,cell,raw,norm,status,reason,sheet_match,live_prd_cd,live_opt_n,live_priced,routing
    for r in rdr:
        cat = r["category"]
        prd = r.get("live_prd_cd", "").strip()
        v1_status = r["status"]
        c = counts.setdefault(cat, {"total":0,"green":0,"yellow":0,"hold":0,"none":0})
        c["total"] += 1

        # ❌미출시 유지 (price-quotability 대상 아님: 상품 부재)
        if v1_status.startswith("❌"):
            new_status = ST_NONE
            verdict = "n/a(부재)"
            evid = r["reason"]
            change = "유지"
            c["none"] += 1
        elif prd and prd in pq:
            v = pq[prd]["verdict"]
            method = pq[prd]["method"]
            evid = pq[prd]["evidence"]
            if v == "QUOTABLE":
                new_status = ST_GREEN
                verdict = "QUOTABLE"
            elif v == "NOT-QUOTABLE":
                new_status = ST_YELLOW
                verdict = "NOT-QUOTABLE"
            elif v == "NEEDS-DOMAIN":
                new_status = ST_HOLD
                verdict = "NEEDS-DOMAIN"
            else:
                new_status = v1_status; verdict = v
            # 변동 산정
            if v1_status == new_status:
                change = "유지"
            elif v1_status.startswith("🟡") and new_status == ST_GREEN:
                change = "격상"
            elif v1_status.startswith("🟡") and new_status == ST_HOLD:
                change = "재라벨(보류)"
            elif v1_status == ST_GREEN and new_status != ST_GREEN:
                change = "강등"
            else:
                change = "변경"
            # 집계
            if new_status == ST_GREEN: c["green"] += 1
            elif new_status == ST_YELLOW: c["yellow"] += 1
            elif new_status == ST_HOLD: c["hold"] += 1
            # 격상분 수집
            if change == "격상":
                upgraded.append([prd, r["raw"], cat, r.get("sheet_match",""),
                                 f"{verdict}/{method}"])
        else:
            # price-quotability에 없으나 부재도 아닌 행(있으면) — 보수적으로 v1 유지
            new_status = v1_status
            verdict = "PQ미수록"
            evid = r["reason"]
            change = "유지(PQ미수록)"
            if new_status.startswith("🟡"): c["yellow"] += 1
            elif new_status == ST_GREEN: c["green"] += 1

        r["status"] = new_status
        r["reason"] = f"[v2·{verdict}·{change}] {evid}"
        rows_out.append(r)

# v2 쓰기
with open(OUT_V2, "w", encoding="utf-8", newline="") as f:
    w = csv.DictWriter(f, fieldnames=fields)
    w.writeheader()
    for r in rows_out:
        w.writerow(r)

# 격상분 쓰기
with open(OUT_UP, "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f)
    w.writerow(["prd_cd","상품명","카테고리(MAP)","상품군(sheet)","근거(verdict/method)"])
    for u in upgraded:
        w.writerow(u)

# 집계 출력
print(f"총 행: {len(rows_out)}  격상: {len(upgraded)}")
def catnum(k):
    try: return int(k.split()[0])
    except: return 99
print(f"{'카테고리':<10}{'전체':>4}{'✅':>5}{'🟡':>4}{'🟦':>4}{'❌':>4}")
tot={"total":0,"green":0,"yellow":0,"hold":0,"none":0}
for cat in sorted(counts, key=catnum):
    c=counts[cat]
    for k in tot: tot[k]+=c[k]
    print(f"{cat:<10}{c['total']:>4}{c['green']:>5}{c['yellow']:>4}{c['hold']:>4}{c['none']:>4}")
print(f"{'합계':<10}{tot['total']:>4}{tot['green']:>5}{tot['yellow']:>4}{tot['hold']:>4}{tot['none']:>4}")

# 격상 카테고리별 분포
print("\n격상 카테고리별:")
up_cat={}
for u in upgraded: up_cat[u[2]]=up_cat.get(u[2],0)+1
for cat in sorted(up_cat, key=catnum):
    print(f"  {cat}: {up_cat[cat]}")

# 보류 목록
print("\n🟦보류:")
for r in rows_out:
    if r["status"]==ST_HOLD:
        print(f"  {r['live_prd_cd']} {r['raw']} ({r['category']})")
