#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
순환고리 전수 센서스 — 상품→공식→구성요소→차원→기준정보 마스터 전 상품 관통.
가격테이블 차원이 이 고리에 제대로 매핑됐는지 blind spot 을 결정론으로 적발.
라이브 읽기전용 SELECT 전용(쓰기 없음).
"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_foundation", "batch"))
import lib_huni as L
L.load_env()

def one(sql): return int(L.db(sql)[0][0])
def rows(sql): return L.db(sql)

print("="*70)
print("A. 순환고리 엣지 고아(blind spot: 끊긴 연결)")
print("="*70)
# 공식 with no product (죽은 공식)
dead_frm = rows("""SELECT f.frm_cd,f.frm_nm FROM t_prc_price_formulas f
  WHERE NOT EXISTS(SELECT 1 FROM t_prd_product_price_formulas p WHERE p.frm_cd=f.frm_cd)
  ORDER BY f.frm_cd""")
print(f"\n[A1] 상품 미연결 공식(죽은 공식): {len(dead_frm)}")
for r in dead_frm: print(f"     {r[0]:26} {(r[1] or '')[:34]}")
# 상품 with no formula (가격 못내는 상품) — del_yn=N 만
noformula = one("""SELECT count(*) FROM t_prd_products p WHERE p.del_yn='N'
  AND NOT EXISTS(SELECT 1 FROM t_prd_product_price_formulas x WHERE x.prd_cd=p.prd_cd)""")
print(f"\n[A2] 공식 미연결 상품(del_yn=N): {noformula}")
# 구성요소 with no formula (죽은 구성요소 = MIRROR3T류)
dead_comp = rows("""SELECT c.comp_cd,c.comp_nm FROM t_prc_price_components c
  WHERE c.del_yn='N' AND NOT EXISTS(SELECT 1 FROM t_prc_formula_components fc WHERE fc.comp_cd=c.comp_cd)
  ORDER BY c.comp_cd""")
print(f"\n[A3] 공식 미배선 구성요소(죽은 구성요소): {len(dead_comp)}")
for r in dead_comp: print(f"     {r[0]:34} {(r[1] or '')[:30]}")
# 공식 with no component
frm_nocomp = rows("""SELECT f.frm_cd,f.frm_nm FROM t_prc_price_formulas f
  WHERE NOT EXISTS(SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd=f.frm_cd) ORDER BY f.frm_cd""")
print(f"\n[A4] 구성요소 미배선 공식: {len(frm_nocomp)}")
for r in frm_nocomp: print(f"     {r[0]:26} {(r[1] or '')[:34]}")
# 구성요소 with 0 price rows
comp_norows = rows("""SELECT c.comp_cd,c.comp_nm FROM t_prc_price_components c
  WHERE c.del_yn='N' AND NOT EXISTS(SELECT 1 FROM t_prc_component_prices p WHERE p.comp_cd=c.comp_cd)
  ORDER BY c.comp_cd""")
print(f"\n[A5] 단가행 0 구성요소: {len(comp_norows)}")
for r in comp_norows: print(f"     {r[0]:34} {(r[1] or '')[:30]}")

print()
print("="*70)
print("B. 차원 코드 → 기준정보 마스터 미해결(blind spot: 마스터에 없는 값)")
print("="*70)
# (dim컬럼, 마스터테이블, 마스터PK)
DIMS = [("mat_cd","t_mat_materials","mat_cd"),
        ("proc_cd","t_proc_processes","proc_cd"),
        ("siz_cd","t_siz_sizes","siz_cd"),
        ("plt_siz_cd","t_siz_sizes","siz_cd"),
        ("clr_cd","t_clr_color_counts","clr_cd"),
        ("print_opt_cd","t_prt_print_options","print_opt_cd")]
for col,tbl,pk in DIMS:
    used = one(f"SELECT count(DISTINCT {col}) FROM t_prc_component_prices WHERE {col} IS NOT NULL")
    orphan = rows(f"""SELECT DISTINCT cp.{col} FROM t_prc_component_prices cp
      WHERE cp.{col} IS NOT NULL AND NOT EXISTS(SELECT 1 FROM {tbl} m WHERE m.{pk}=cp.{col}) LIMIT 20""")
    print(f"\n  {col:14} 사용값 {used}종 · 마스터({tbl}) 미해결 {len(orphan)}종"
          + (f" → {[x[0] for x in orphan]}" if orphan else ""))

print()
print("="*70)
print("C. Face A(use_dims 선언) vs Face B(단가행 실충전) 불일치")
print("="*70)
import json
COLMAP={"mat_cd":"mat_cd","proc_cd":"proc_cd","siz_cd":"siz_cd","opt_cd":"opt_cd",
        "print_opt_cd":"print_opt_cd","plt_siz_cd":"plt_siz_cd","coat_side_cnt":"coat_side_cnt",
        "bdl_qty":"bdl_qty","siz_width":"siz_width","siz_height":"siz_height","min_qty":"min_qty"}
comps = rows("""SELECT comp_cd, comp_nm, use_dims::text FROM t_prc_price_components WHERE del_yn='N' ORDER BY comp_cd""")
# 실충전 프로파일: 컬럼당 GROUP BY 1회씩(총 11회) — comp_cd별 distinct 값수 수집
fill = {}  # comp_cd -> set(dim)
for dim,col in COLMAP.items():
    for cc, n in rows(f"""SELECT comp_cd, count(DISTINCT {col}) FROM t_prc_component_prices
                          WHERE {col} IS NOT NULL GROUP BY comp_cd"""):
        if int(n) >= 2:
            fill.setdefault(cc, set()).add(dim)
undeclared=[]; empty_decl=[]
for cc,cn,ud in comps:
    dims = json.loads(ud) if ud else []
    declared = set(d for d in dims if isinstance(d,str) and d in COLMAP)
    filled = fill.get(cc, set())
    # UNDECLARED: 단가행이 차원 구분하는데 use_dims 미선언 = silent
    und = filled - declared
    # EMPTY_DECL: use_dims 선언했는데 단가행 미구분
    emp = declared - filled - {"min_qty"}  # min_qty 는 흔히 단일
    if und: undeclared.append((cc,cn,sorted(und)))
    if emp: empty_decl.append((cc,cn,sorted(emp)))
print(f"\n[C1] UNDECLARED(단가행은 차원 구분·use_dims 미선언=silent): {len(undeclared)}")
for cc,cn,d in undeclared: print(f"     {cc:34} {cn[:22]:24} {d}")
print(f"\n[C2] EMPTY_DECL(use_dims 선언·단가행 미구분): {len(empty_decl)}")
for cc,cn,d in empty_decl[:40]: print(f"     {cc:34} {cn[:22]:24} {d}")
