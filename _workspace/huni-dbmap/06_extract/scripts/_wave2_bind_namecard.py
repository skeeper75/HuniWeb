import csv
from collections import Counter, defaultdict
base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'

with open(base + '/02_mapping/load_price/t_prc_component_prices.csv', newline='') as f:
    load = list(csv.DictReader(f))

# 1) PHOTOCARD_BULK 50행 vs L1 대량제작 50구간 값 대조
bulk = [r for r in load if r['comp_cd'] == 'COMP_PHOTOCARD_BULK']
bulk_map = {r['min_qty']: r['unit_price'] for r in bulk}
with open(base + '/06_extract/price-namecard-photocard-l1.csv', newline='') as f:
    l1 = list(csv.DictReader(f))
l1_bulk = {}
for r in l1:
    if r['block_title'] == '포토카드(대랑제작)' and r['row_key'].isdigit() and r['value'].replace(',','').isdigit() and r['value'] != r['row_key']:
        l1_bulk[r['row_key']] = r['value'].replace(',','')
print('=== PHOTOCARD_BULK: load {} rows vs L1 {} qty-rows ==='.format(len(bulk), len(l1_bulk)))
mism = 0
for q, v in l1_bulk.items():
    lv = bulk_map.get(q)
    if lv != v:
        mism += 1
        if mism <= 8:
            print('   MISMATCH qty={} L1={} load={}'.format(q, v, lv))
miss_load = [q for q in bulk_map if q not in l1_bulk]
print('   value mismatches={}  load-qty-not-in-L1={}'.format(mism, miss_load[:10]))

# 2) BIND load 74 vs L1 73 — what is the extra?
binds = [r for r in load if r['comp_cd'].startswith('COMP_BIND')]
print()
print('=== BIND load comp distribution (74 rows) ===')
print(' ', Counter(r['comp_cd'] for r in binds))

# 3) NAMECARD multi-block: distinct comp per block & STD block reverse
print()
print('=== NAMECARD load comp_cd count ===')
nc = [r for r in load if r['comp_cd'].startswith('COMP_NAMECARD')]
print('   total NAMECARD load rows:', len(nc))
print(' ', dict(Counter(r['comp_cd'] for r in nc)))

# 4) FOLD/BIND/CUT formula binding presence in formula_components
with open(base + '/02_mapping/load_price/t_prc_formula_components.csv', newline='') as f:
    fc = list(csv.DictReader(f))
bound_comps = set(r['comp_cd'] for r in fc)
all_new = set(r['comp_cd'] for r in load if any(r['comp_cd'].startswith(p) for p in ('COMP_FOLD','COMP_BIND','COMP_CUT','COMP_STK','COMP_GANGPAN','COMP_NAMECARD','COMP_PHOTOCARD','COMP_PCB')))
unbound = sorted(all_new - bound_comps)
print()
print('=== 신규 comp 중 formula_components 바인딩 없는 것 ({}) ==='.format(len(unbound)))
for c in unbound:
    print('   ', c)
