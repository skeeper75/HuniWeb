#!/usr/bin/env python3
"""Q0 — 샵바이 상품 텍스트 옵션 라벨 전수 조회 (읽기 전용 GET 만).
자격증명은 환경변수에서만 읽고, 어떤 산출 파일에도 값을 쓰지 않는다.
재실행: set -a && . ./.env.local && set +a && python3 fetch_labels.py
"""
import json, os, sys, time, urllib.request, urllib.parse, urllib.error, csv, pathlib

BASE = os.environ["SHOPBY_SERVER_API_URL"].rstrip("/")
HDR = {
    "systemKey": os.environ["SHOPBY_SYSTEM_KEY"],
    "Authorization": "Bearer " + os.environ["SHOPBY_SERVER_ACCESS_TOKEN"],
    "version": os.environ.get("SHOPBY_VERSION", "1.0"),
    "Accept": "application/json",
}
LOG = []  # (method, path, status) — 값은 절대 기록하지 않는다

def get(path, params=None):
    url = BASE + path + ("?" + urllib.parse.urlencode(params) if params else "")
    req = urllib.request.Request(url, headers=HDR, method="GET")   # GET 고정
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            LOG.append(("GET", path, r.status))
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        LOG.append(("GET", path, e.code))
        return None

# 1) 상품 전수 목록
prods, page = [], 1
while True:
    d = get("/products/search", {"page": page, "size": 50})
    if not d or not d.get("elements"):
        break
    prods += d["elements"]
    if page >= d.get("totalPage", 1):
        break
    page += 1
print(f"상품 목록: {len(prods)}건 (totalCount={d.get('totalCount') if d else '?'})", file=sys.stderr)

# 2) 상품별 옵션 조회 → 텍스트 옵션(inputs) 라벨
rows = []
for i, p in enumerate(prods, 1):
    no = p["mallProductNo"]
    o = get(f"/products/{no}/options")
    if o is None:
        labels, opt_type, err = [], "", "GET 실패"
    else:
        labels = [x.get("inputLabel", "") for x in (o.get("inputs") or [])]
        opt_type, err = o.get("type", ""), ""
    has_tok = "huni_token" in labels
    has_item = "huni_item" in labels
    has_ord = "huni_order" in labels
    rows.append({
        "mallProductNo": no,
        "productName": p.get("productName", ""),
        "productManagementCd": p.get("productManagementCd", ""),
        "classType": p.get("classType", ""),
        "saleStatusType": p.get("saleStatusType", ""),
        "optionType": opt_type,
        "textOptionLabels": "|".join(labels),
        "textOptionCount": len(labels),
        "huni_token": "Y" if has_tok else "N",
        "huni_item": "Y" if has_item else "N",
        "huni_order": "Y" if has_ord else "N",
        "분류": ("huni_token 있음" if has_tok
                else "huni_item 있음" if has_item
                else "둘 다 없음"),
        "조회오류": err,
    })
    if i % 50 == 0:
        print(f"  {i}/{len(prods)} …", file=sys.stderr)
    time.sleep(0.05)

out = pathlib.Path("label-check.csv")
with out.open("w", encoding="utf-8", newline="") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

# 3) 요청 로그 — 메서드/경로/상태만 (값 없음)
with open("_get-log.txt", "w", encoding="utf-8") as f:
    f.write(f"# Q0 요청 로그 — 전건 GET · 쓰기 0 · 자격증명 값 미기록\n")
    f.write(f"# 총 {len(LOG)}건\n")
    for m, p, s in LOG:
        f.write(f"{m} {p} -> {s}\n")

from collections import Counter
print("\n=== 3분류 ===")
for k, v in Counter(r["분류"] for r in rows).items():
    print(f"  {k}: {v}")
print("\n=== 라벨 조합 ===")
for k, v in Counter(r["textOptionLabels"] for r in rows).most_common():
    print(f"  [{k or '(없음)'}]: {v}")
print("\n=== classType ===", dict(Counter(r["classType"] for r in rows)))
print("=== 판매상태 ===", dict(Counter(r["saleStatusType"] for r in rows)))
print("=== 요청 메서드 전건 GET ===", set(m for m, _, _ in LOG))
print("=== 비200 응답 ===", sum(1 for _, _, s in LOG if s != 200))
print("=== 총 행수 ===", len(rows), "| 분류 빈칸:", sum(1 for r in rows if not r["분류"]))
