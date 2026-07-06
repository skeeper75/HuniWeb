#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전 사슬 형제 불일치 센서스 (다차원 배치화) — 전 사슬 원칙을 상품 단위 배선 전 차원에 적용.

같은 가격공식(frm_cd)을 쓰는 형제 상품 중 일부만 어떤 상품단위 배선(할인·공정·판형·인쇄옵션·묶음수)에
연결되고 나머지가 미배선이면, 그 미배선이 결함일 가능성이 높다(수량할인 아크릴 7상품이 이 패턴).
비율(배선/전체)로 신뢰도 랭크: 다수 배선·소수 미배선 = 강한 신호.

라이브 읽기전용. 결정론(토큰0). grid_diff(면적 L6)가 못 보는 사슬 차원을 전부 스캔.
"""
import sys, os
from collections import defaultdict
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_foundation", "batch"))
import lib_huni as L
L.load_env()
def db(s): return L.db(s)

# 차원명 → 상품단위 배선 테이블 (돈/기능 영향 큰 것 전 차원 — 계층4 완주)
DIMS = [
    ("수량할인", "t_prd_product_discount_tables"),
    ("공정",   "t_prd_product_processes"),
    ("판형",   "t_prd_product_plate_sizes"),
    ("인쇄옵션", "t_prd_product_print_options"),
    ("묶음수",  "t_prd_product_bundle_qtys"),
    ("자재",   "t_prd_product_materials"),
    ("CPQ옵션그룹", "t_prd_product_option_groups"),
    ("사이즈",  "t_prd_product_sizes"),
    ("애드온",  "t_prd_product_addons"),
]

# 활성상품 → 공식
prod_frm = {}
for frm, pcd in db("""SELECT pf.frm_cd, p.prd_cd FROM t_prd_products p
      JOIN t_prd_product_price_formulas pf ON pf.prd_cd=p.prd_cd WHERE p.del_yn='N'"""):
    prod_frm[pcd] = frm
pname = dict(db("SELECT prd_cd, prd_nm FROM t_prd_products WHERE del_yn='N'"))

frm_prods = defaultdict(set)
for pcd, frm in prod_frm.items():
    frm_prods[frm].add(pcd)

print("=" * 74)
print("전 사슬 형제 불일치 센서스 — 공식그룹 내 상품단위 배선 불일치 (전 차원)")
print("=" * 74)
findings = []
for dimnm, tbl in DIMS:
    wired = set(r[0] for r in db(f"SELECT DISTINCT prd_cd FROM {tbl} WHERE prd_cd IS NOT NULL"))
    for frm, prods in frm_prods.items():
        if len(prods) < 2:
            continue
        w = prods & wired
        u = prods - wired
        if w and u:  # 형제 불일치
            ratio = len(w) / len(prods)
            findings.append((ratio, dimnm, frm, sorted(w), sorted(u)))

# 신뢰도(배선비율 높은 순=미배선이 소수 이상치) 랭크
findings.sort(key=lambda x: -x[0])
for ratio, dimnm, frm, w, u in findings:
    conf = "★강" if ratio >= 0.6 else ("중" if ratio >= 0.34 else "약")
    print(f"\n[{dimnm}] {frm}  배선 {len(w)}/미배선 {len(u)}  (배선율 {ratio:.0%}·{conf})")
    for pcd in u:
        print(f"     미배선: {pcd:13} {(pname.get(pcd) or '')[:26]}")
print(f"\n===> 형제 불일치 (차원×공식) {len(findings)}건")
