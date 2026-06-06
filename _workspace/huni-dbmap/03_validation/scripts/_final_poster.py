#!/usr/bin/env python3
# 포스터사인 면적분 적대검증: L1 가격셀 ↔ 적재 785행 완전성 + 값 multiset 대조
import csv, json, re, collections

L1 = "06_extract/price-poster-sign-l1.csv"
LOAD = "02_mapping/load_price/t_prc_component_prices.csv"

# --- 1. 적재 CSV에서 POSTER 행 추출 ---
load_rows = []
with open(LOAD, encoding="utf-8") as f:
    rd = csv.DictReader(f)
    for r in rd:
        if r["comp_cd"].startswith("COMP_POSTER"):
            load_rows.append(r)
print(f"[LOAD] COMP_POSTER* 행수 = {len(load_rows)}")

# 메인 vs 추가옵션 분리
main_rows = [r for r in load_rows if not r["comp_cd"].startswith("COMP_POSTEROPT")]
opt_rows  = [r for r in load_rows if r["comp_cd"].startswith("COMP_POSTEROPT")]
print(f"  메인(COMP_POSTER_*) = {len(main_rows)}, 추가옵션(COMP_POSTEROPT_*) = {len(opt_rows)}")

# 적재 unit_price multiset
load_prices = collections.Counter()
for r in load_rows:
    load_prices[int(float(r["unit_price"]))] += 1

# --- 2. L1에서 가격셀 추출 ---
# 가격셀 = value가 순수 숫자(정수/float)인 셀. 헤더/라벨/수량 echo 제외.
# AREA형: 매트릭스 내부 숫자값. SIZEQTY: 가격행 숫자. B26: B~F열 가격 + K/N열 옵션가.
# 수량 라벨(행키=수량)·치수 라벨(가로/세로 mm)·헤더는 제외.
l1_price_cells = []   # (block, cell_ref, value, row_key, band, col)
l1_all = []
with open(L1, encoding="utf-8-sig") as f:
    rd = csv.DictReader(f)
    for r in rd:
        l1_all.append(r)

def is_number(s):
    s = s.strip()
    if s == "": return False
    try:
        float(s); return True
    except: return False

# 치수/수량 라벨 패턴 (가격 아님)
dim_label = re.compile(r'^\d+\s*mm$|^[ABab]\d$|^\d{2,4}[xX×]\d{2,4}$|^\d+$')

for r in l1_all:
    val = r["value"].strip()
    if not is_number(val):
        continue
    num = float(val)
    rk = r["row_key"].strip()
    col = r["col"].strip()
    band = r["band_header_path"].strip()
    bid = r["block_id"]
    # row_key가 가로/세로/사이즈/옵션 라벨이면 헤더행 — A열 자기참조는 제외
    if col == "A":
        # A열은 보통 행 라벨(치수/수량). 가격 아님.
        continue
    # row_key 자체가 숫자이고 value==row_key면 수량 echo 가능성 — 하지만 가격일수도. 보존.
    l1_price_cells.append((bid, r["cell_ref"], int(num), rk, band, col, val))

print(f"\n[L1] 숫자 가격셀 후보(A열 제외) = {len(l1_price_cells)}")

# row_key가 수량라벨(순수 정수 1~9999)인 행에서 value==int(row_key) 인 셀 = 수량 echo 후보
echo_suspects = [c for c in l1_price_cells if c[3].isdigit() and str(c[2])==c[3]]
print(f"  └ value==row_key(수량 echo 의심) = {len(echo_suspects)}")

# band_header_path가 '가로/세로' 매트릭스 헤더 echo (B2 row 헤더) — band에 '>' 다중 포함이지만 value는 헤더라벨 숫자(600 등)
# AREA 헤더행(row_seq 2): value가 '600' 등 mm 라벨이나 band에 mm 포함. 이건 col!=A라도 헤더.
header_echo = [c for c in l1_price_cells if re.match(r'^\d+mm', c[4]) and c[2] in (600,800,1000,1200,1400,1500,1750,2000,900) and c[5]=='B' ]
# 너무 거칠다 — 별도 정밀 집계 아래서

# --- 3. 블록별 L1 가격셀 분포 ---
by_block = collections.Counter()
for c in l1_price_cells:
    by_block[c[0]] += 1
print("\n[L1 블록별 숫자셀 분포]")
for bid in sorted(by_block):
    print(f"  {bid}: {by_block[bid]}")

# --- 4. 값 multiset 대조: 적재 가격이 L1에 존재하는가 (역방향) ---
l1_vals = collections.Counter(c[2] for c in l1_price_cells)
miss_in_l1 = []
for price, cnt in load_prices.items():
    if l1_vals[price] == 0:
        miss_in_l1.append((price, cnt))
print(f"\n[역대조] 적재 가격 중 L1에 값 자체가 부재 = {len(miss_in_l1)} 종")
for price, cnt in sorted(miss_in_l1)[:30]:
    print(f"  unit_price={price} (적재 {cnt}행) — L1 부재")

# --- 5. 31블록 전수 적재 점검: 각 L1 블록의 대표가격이 적재에 존재? ---
print("\n[31블록 전수 적재 점검]")
block_titles = {}
for r in l1_all:
    if r["block_id"] not in block_titles and r["block_title"].strip():
        block_titles[r["block_id"]] = r["block_title"].strip()
covered = []
uncovered = []
for bid in sorted(by_block):
    # 이 블록의 숫자가격값 집합
    bvals = set(c[2] for c in l1_price_cells if c[0]==bid and c[2] > 100)  # 100 초과만 (수량라벨 배제)
    if not bvals:
        continue
    hit = sum(1 for v in bvals if load_prices[v] > 0)
    ratio = hit/len(bvals) if bvals else 0
    status = "OK" if ratio >= 0.5 else "**LOW**"
    if ratio < 0.5:
        uncovered.append((bid, block_titles.get(bid,""), hit, len(bvals)))
    else:
        covered.append(bid)
    print(f"  {bid} {block_titles.get(bid,'')[:20]:20s}: {hit}/{len(bvals)} 가격값 적재됨 {status}")

print(f"\n커버 블록 {len(covered)} / 저커버 블록 {len(uncovered)}")
for bid,t,h,n in uncovered:
    print(f"  ** 저커버: {bid} {t} ({h}/{n})")
