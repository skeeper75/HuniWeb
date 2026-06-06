#!/usr/bin/env python3
# 796 L1셀 vs 785 적재 — 11셀 차이 정밀 분석 + AREA 헤더 echo 식별 + baseline 0원
import csv, re, collections

L1 = "06_extract/price-poster-sign-l1.csv"
LOAD = "02_mapping/load_price/t_prc_component_prices.csv"

l1 = list(csv.DictReader(open(L1, encoding="utf-8-sig")))

def is_number(s):
    s=s.strip()
    if s=="":return False
    try: float(s);return True
    except: return False

# AREA형 블록: row_seq 2 = 가로헤더(value=600/800/1000/1200 mm 라벨). 가격 아님.
# 매트릭스 본문: B~E열, value=가격. 헤더행(row 2)의 B~E도 숫자(600/800등 mm)지만 band가 'NNmm > ...'.
# 식별: band_header_path가 'NNNmm >' 로 시작하고 row_key도 동일 'NNNmm' 이면서 value가 헤더 mm값이면 헤더 echo.
# 더 정확: row 2(헤더행)의 셀은 row_key=='가로 / 세로'.

cells=[]   # 모든 A열 제외 숫자셀
header_echo=[]
zero_cells=[]
for r in l1:
    val=r["value"].strip()
    if not is_number(val): continue
    if r["col"].strip()=="A": continue
    num=int(float(val))
    rk=r["row_key"].strip()
    band=r["band_header_path"].strip()
    bid=r["block_id"]
    # 헤더 echo: row_key가 '가로 / 세로' (AREA 헤더행 row2)
    if rk in ("가로 / 세로","사이즈 / 수량"):
        header_echo.append((bid,r["cell_ref"],num,rk,r["col"]))
        continue
    if num==0:
        zero_cells.append((bid,r["cell_ref"],num,rk,r["col"],band))
        continue
    cells.append((bid,r["cell_ref"],num,rk,band,r["col"]))

print(f"A열제외 숫자셀 총 = {len(cells)+len(header_echo)+len(zero_cells)}")
print(f"  헤더 echo(가로/세로·사이즈/수량 헤더행) = {len(header_echo)}")
print(f"  0원 baseline 셀 = {len(zero_cells)}")
for z in zero_cells:
    print(f"    0원: {z[0]} {z[1]} row_key={z[3]} col={z[4]}")
print(f"  실가격 셀(>0, 헤더아님) = {len(cells)}")

# 적재
load=[r for r in csv.DictReader(open(LOAD,encoding="utf-8")) if r["comp_cd"].startswith("COMP_POSTER")]
print(f"\n적재 POSTER 행 = {len(load)}")

# 실가격셀 - 적재 = 차이
l1c = collections.Counter(c[2] for c in cells)
ldc = collections.Counter(int(float(r['unit_price'])) for r in load)
print(f"\n실가격셀 multiset 합계 = {sum(l1c.values())}, 적재 multiset 합계 = {sum(ldc.values())}")

# L1에만 있고 적재 부족한 값
short=[]
for v,c in l1c.items():
    if ldc[v] < c:
        short.append((v, c, ldc[v]))
print(f"\n[과소적재 후보] L1 가격값 출현수 > 적재 출현수:")
for v,lc,dc in sorted(short):
    print(f"  값={v}: L1 {lc}회 vs 적재 {dc}회 (부족 {lc-dc})")
tot_short=sum(lc-dc for v,lc,dc in short)
print(f"  총 부족 출현수 = {tot_short}")

# 적재에만 과다
over=[]
for v,c in ldc.items():
    if l1c[v] < c:
        over.append((v,c,l1c[v]))
print(f"\n[과다적재/발명 후보] 적재 > L1:")
for v,dc,lc in sorted(over):
    print(f"  값={v}: 적재 {dc}회 vs L1 {lc}회 (초과 {dc-lc})")
tot_over=sum(dc-lc for v,dc,lc in over)
print(f"  총 초과 출현수 = {tot_over}")
