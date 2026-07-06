#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
수량할인 차원 전 사슬 정합 센서스 — 형제 상품 간 할인 배선 불일치 적발.

전 사슬 원칙(상품→공식→구성요소→차원→기준정보 마스터↔시트차원)을 "수량할인 차원"에 적용:
같은 가격공식(frm_cd)을 쓰는 형제 상품 중 일부만 t_prd_product_discount_tables 에 배선되고
나머지가 미배선이면 → 그 미배선 상품은 시트 구간할인(굿즈파우치구간할인 등)이 적용 안 됨 =
대량주문 과청구(돈 크리티컬). grid_diff(면적 L6)는 이 차원을 못 본다.

라이브 읽기전용 SELECT 전용. 결정론(토큰0).
"""
import sys, os
from collections import defaultdict
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_foundation", "batch"))
import lib_huni as L
L.load_env()
def db(s): return L.db(s)

rows = db("""
SELECT pf.frm_cd, p.prd_cd, p.prd_nm,
  (SELECT string_agg(d.dsc_tbl_cd,',' ORDER BY d.dsc_tbl_cd)
     FROM t_prd_product_discount_tables d WHERE d.prd_cd=p.prd_cd) AS dsc
FROM t_prd_products p
JOIN t_prd_product_price_formulas pf ON pf.prd_cd=p.prd_cd
WHERE p.del_yn='N'
ORDER BY pf.frm_cd, dsc NULLS LAST, p.prd_nm
""")
grp = defaultdict(list)
for frm, pcd, pnm, dsc in rows:
    grp[frm].append((pcd, pnm, dsc))

print("=" * 70)
print("수량할인 차원 형제 불일치 센서스 (같은 공식·배선/미배선 혼재)")
print("=" * 70)
flagged = 0
for frm, items in sorted(grp.items()):
    wired = [i for i in items if i[2]]
    unwired = [i for i in items if not i[2]]
    if wired and unwired:
        flagged += 1
        dsc_set = sorted(set(i[2] for i in wired))
        print(f"\n[{frm}]  배선 {len(wired)} / 미배선 {len(unwired)}  할인={dsc_set}")
        for pcd, pnm, dsc in unwired:
            print(f"   미배선: {pcd:13} {(pnm or '')[:28]}")
print(f"\n===> 형제 불일치 공식 {flagged}개")
