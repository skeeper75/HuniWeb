import csv
from collections import Counter, defaultdict

base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
with open(base + '/06_extract/price-postcard-book-l1.csv', newline='') as f:
    l1 = list(csv.DictReader(f))
with open(base + '/02_mapping/load_price/t_prc_component_prices.csv', newline='') as f:
    load = [r for r in csv.DictReader(f) if r['comp_cd'].startswith('COMP_PCB')]
load_prices = Counter(r['unit_price'].replace(',', '') for r in load)

print('=== 떡메모지 블록 전체 ===')
for r in l1:
    if r['block_title'] == '떡메모지':
        print('   {} row_key={!r} band={!r} value={!r}'.format(r['cell_ref'], r['row_key'], r['band_header_path'], r['value']))

ni = [r for r in l1 if r['value'].replace(',', '').isdigit()
      and r['value'].replace(',', '') not in load_prices
      and r['value'].replace(',', '') != r['row_key'].strip()]
print()
print('=== not-in-load 98건 블록 분포 ===')
print(' ', Counter(r['block_title'] for r in ni))
print('=== 장수/수량 블록 전체 (앞 20) ===')
n=0
for r in l1:
    if r['block_title'] == '장수 / 수량':
        print('   {} row_key={!r} band={!r} value={!r}'.format(r['cell_ref'], r['row_key'], r['band_header_path'], r['value']))
        n+=1
        if n>=20: break
print('=== not-in-load 샘플 (블록=엽서북) 14 ===')
for r in [x for x in ni if x['block_title'] == '엽서북'][:14]:
    print('   {} row_key={!r} band={!r} value={!r}'.format(r['cell_ref'], r['row_key'], r['band_header_path'], r['value']))
