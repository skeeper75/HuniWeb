#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
굿즈 권위 시트 결정론 파서 — 상품마스터 260703 굿즈파우치/상품악세사리(가격포함).
LLM 숫자전사 금지: openpyxl 로 값 직접 추출. 라이브 DB prd_cd 매칭까지.
산출: goods-authority-extract-260706.csv (적재본 준비 입력)
"""
import openpyxl, csv, sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_foundation", "batch"))
import lib_huni as L
L.load_env()

F = "/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_상품마스터_260703.xlsx"
OUT = os.path.join(os.path.dirname(__file__), "goods-authority-extract-260706.csv")

def num(v):
    return v if isinstance(v, (int, float)) else None

records = []
wb = openpyxl.load_workbook(F, read_only=False, data_only=True)

# ── 굿즈파우치(가격포함): col0 구분·3 상품명·4 상품(옵션)·7 재단사이즈·16 가격·
#    19/20/21 수량 min/max/incr·24 구간할인테이블·14/15 선택옵션·17/18 가공·22/23 추가상품
ws = wb["굿즈파우치(가격포함)"]
gubun = None; prd = None
for r in ws.iter_rows(min_row=3, values_only=True):
    def g(i): return r[i] if len(r) > i else None
    if g(0): gubun = str(g(0)).strip()
    if g(3): prd = str(g(3)).strip()
    opt = g(4); price = num(g(16))
    if opt is None and price is None:  # 빈/구분 행
        continue
    records.append({
        "sheet": "굿즈파우치", "구분": gubun, "ID": g(1), "MES": g(2), "상품명": prd,
        "사이즈옵션": (str(opt).strip() if opt is not None else ""),
        "재단사이즈": (str(g(7)).strip() if g(7) is not None else ""),
        "가격": price,
        "수량min": num(g(19)), "수량max": num(g(20)), "수량incr": num(g(21)),
        "구간할인테이블": (str(g(24)).strip() if g(24) is not None else ""),
        "선택옵션": (str(g(14)).strip() if g(14) is not None else ""), "선택가격": num(g(15)),
        "가공": (str(g(17)).strip() if g(17) is not None else ""), "가공가격": num(g(18)),
        "추가상품": (str(g(22)).strip() if g(22) is not None else ""), "추가가격": num(g(23)),
    })

# ── 상품악세사리(가격포함): col0 구분·3 상품명·4 사이즈·5/6/7 수량 min/max/incr·8 가격
ws = wb["상품악세사리(가격포함)"]
gubun = None; prd = None
for r in ws.iter_rows(min_row=3, values_only=True):
    def g(i): return r[i] if len(r) > i else None
    if g(0): gubun = str(g(0)).strip()
    if g(3): prd = str(g(3)).strip()
    opt = g(4); price = num(g(8))
    if opt is None and price is None:
        continue
    records.append({
        "sheet": "상품악세사리", "구분": gubun, "ID": g(1), "MES": g(2), "상품명": prd,
        "사이즈옵션": (str(opt).strip() if opt is not None else ""), "재단사이즈": "",
        "가격": price, "수량min": num(g(5)), "수량max": num(g(6)), "수량incr": num(g(7)),
        "구간할인테이블": "", "선택옵션": "", "선택가격": None, "가공": "", "가공가격": None,
        "추가상품": "", "추가가격": None,
    })
wb.close()

# ── 라이브 DB 상품명→prd_cd 매칭(활성 완제품)
dbmap = {}
for pc, pn in L.db("""SELECT prd_cd, prd_nm FROM t_prd_products WHERE del_yn='N'"""):
    dbmap[pn.strip().replace(" ", "")] = pc
def matchdb(nm):
    return dbmap.get((nm or "").strip().replace(" ", ""), "")

for rec in records:
    rec["prd_cd"] = matchdb(rec["상품명"])

# ── 출력
cols = ["sheet","구분","상품명","prd_cd","사이즈옵션","재단사이즈","가격","수량min","수량max",
        "수량incr","구간할인테이블","선택옵션","선택가격","가공","가공가격","추가상품","추가가격","ID","MES"]
with open(OUT, "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
    for rec in records: w.writerow({k: rec.get(k, "") for k in cols})

# ── 요약
prods = {}
for rec in records:
    prods.setdefault(rec["상품명"], {"rows":0,"priced":0,"matched":bool(rec["prd_cd"]),"bands":set()})
    d = prods[rec["상품명"]]; d["rows"]+=1
    if rec["가격"]: d["priced"]+=1
    if rec["구간할인테이블"]: d["bands"].add(rec["구간할인테이블"])
matched = sum(1 for p,d in prods.items() if d["matched"])
print(f"레코드(사이즈변형행) 총 {len(records)} · 상품 {len(prods)}종 · DB매칭 {matched}종")
print(f"CSV: {OUT}")
print("\n구간할인테이블 종류:", sorted({b for d in prods.values() for b in d["bands"]}))
# 57 미적재 커버리지 초점
base = """p.del_yn='N' AND p.use_yn='Y' AND p.prd_typ_cd='PRD_TYPE.01' AND NOT EXISTS(SELECT 1 FROM t_prd_product_price_formulas x WHERE x.prd_cd=p.prd_cd)"""
unpriced = {pn.strip(): pc for pc, pn in L.db(f"SELECT prd_cd,prd_nm FROM t_prd_products p WHERE {base}")}
authnames = {p.replace(" ", ""): d for p, d in prods.items()}
cov = 0; nocov = []
for nm in unpriced:
    d = authnames.get(nm.replace(" ", ""))
    if d and d["priced"] > 0: cov += 1
    else: nocov.append(nm)
print(f"\n=== 미적재 57 커버리지(파서 기준) ===")
print(f"권위 가격행 확보: {len(unpriced)-len(nocov)} / {len(unpriced)}")
print(f"미확보: {nocov}")
print("\n=== 구간할인테이블 정상값(적재 매핑 대상) ===")
clean = [b for d in prods.values() for b in d["bands"]]
from collections import Counter
for b, n in Counter(clean).most_common():
    print(f"  {b}: {n}상품")
