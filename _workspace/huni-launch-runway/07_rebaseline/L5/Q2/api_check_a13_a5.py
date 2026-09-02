#!/usr/bin/env python3
"""Q2 — A-13(비회원 구매 가능 설정값 전수) · A-5(viewShopSpecification) 읽기 확인.

읽기 전용 GET 만. 자격증명은 환경변수에서만 읽고 어떤 산출 파일에도 값을 쓰지 않는다.
재실행: set -a && . ./.env.local && set +a && python3 api_check_a13_a5.py
"""
import csv, json, os, pathlib, sys, time, urllib.error, urllib.parse, urllib.request
from collections import Counter

SERVER = os.environ["SHOPBY_SERVER_API_URL"].rstrip("/")
SHOP = os.environ["SHOPBY_SHOP_API_URL"].rstrip("/")
SERVER_HDR = {
    "systemKey": os.environ["SHOPBY_SYSTEM_KEY"],
    "Authorization": "Bearer " + os.environ["SHOPBY_SERVER_ACCESS_TOKEN"],
    "version": os.environ.get("SHOPBY_VERSION", "1.0"),
    "Accept": "application/json",
}
SHOP_HDR = {
    "clientId": os.environ["SHOPBY_CLIENT_ID"],
    "platform": os.environ.get("SHOPBY_PLATFORM", "PC"),
    "version": os.environ.get("SHOPBY_VERSION", "1.0"),
    "Accept": "application/json",
}
LOG = []  # (method, base, path, status) — 값은 절대 기록하지 않는다


def get(base, hdr, path, params=None):
    url = base + path + ("?" + urllib.parse.urlencode(params) if params else "")
    req = urllib.request.Request(url, headers=hdr, method="GET")  # GET 고정
    tag = "server" if base == SERVER else "shop"
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            LOG.append(("GET", tag, path, r.status))
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        LOG.append(("GET", tag, path, e.code))
        return None


# ---------- A-5 : 몰 주문설정 viewShopSpecification ----------
cfg = get(SHOP, SHOP_HDR, "/order-configs") or {}
a5 = {k: cfg.get(k) for k in (
    "viewShopSpecification", "shopSpecificationFields", "specificationAdditionalInfo",
    "visibleReceiptBtn", "useSimpleReceipt", "usePaymentReceipt",
    "cashReceipt", "cashReceiptRequired", "pgType", "escrow",
)}
pathlib.Path("a5-order-configs.json").write_text(
    json.dumps(a5, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# ---------- A-13 : 상품 전수 비회원 구매 설정값 ----------
prods, page, total = [], 1, None
while True:
    d = get(SERVER, SERVER_HDR, "/products/search", {"page": page, "size": 50})
    if not d or not d.get("elements"):
        break
    prods += d["elements"]
    total = d.get("totalCount")
    if page >= d.get("totalPage", 1):
        break
    page += 1
print(f"상품 목록: {len(prods)}건 (totalCount={total})", file=sys.stderr)

rows = []
for i, p in enumerate(prods, 1):
    no = p["mallProductNo"]
    d = get(SERVER, SERVER_HDR, f"/products/{no}")
    mp = (d or {}).get("mallProduct") or {}
    err = "" if d else "GET 실패"
    rows.append({
        "mallProductNo": no,
        "productName": p.get("productName", ""),
        "productManagementCd": p.get("productManagementCd", ""),
        "saleStatusType": p.get("saleStatusType", ""),
        "nonmemberPurchaseYn": mp.get("nonmemberPurchaseYn", ""),
        "minorPurchaseYn": mp.get("minorPurchaseYn", ""),
        "memberGradeDisplayInfo": "있음" if mp.get("memberGradeDisplayInfo") else "없음",
        "memberGroupDisplayInfo": "있음" if mp.get("memberGroupDisplayInfo") else "없음",
        "판정": ("비회원 구매 가능" if mp.get("nonmemberPurchaseYn") == "Y"
                else "비회원 구매 불가" if mp.get("nonmemberPurchaseYn") == "N"
                else "미확인"),
        "조회오류": err,
    })
    if i % 50 == 0:
        print(f"  {i}/{len(prods)} …", file=sys.stderr)
    time.sleep(0.05)

with open("a13-nonmember-purchase.csv", "w", encoding="utf-8", newline="") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

with open("_get-log.txt", "w", encoding="utf-8") as f:
    f.write("# Q2 요청 로그 — 전건 GET · 쓰기 0 · 자격증명 값 미기록\n")
    f.write(f"# 총 {len(LOG)}건\n")
    for m, t, p, s in LOG:
        f.write(f"{m} [{t}] {p} -> {s}\n")

print("\n=== A-5 viewShopSpecification ===", a5["viewShopSpecification"])
print("=== A-13 판정 분포 ===", dict(Counter(r["판정"] for r in rows)))
print("=== 판매중만 ===", dict(Counter(
    r["판정"] for r in rows if r["saleStatusType"] == "ONSALE")))
print("=== saleStatusType ===", dict(Counter(r["saleStatusType"] for r in rows)))
print("=== minorPurchaseYn ===", dict(Counter(r["minorPurchaseYn"] for r in rows)))
print("=== 요청 메서드 ===", set(m for m, _, _, _ in LOG))
print("=== 비200 응답 ===", sum(1 for _, _, _, s in LOG if s != 200))
print("=== 총 행수 ===", len(rows), "| 판정 빈칸:", sum(1 for r in rows if not r["판정"]))
