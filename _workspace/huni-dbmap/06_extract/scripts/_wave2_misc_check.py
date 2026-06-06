import csv
from collections import Counter

base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
with open(base + '/02_mapping/load_price/t_prc_component_prices.csv', newline='') as f:
    load = list(csv.DictReader(f))

def sheet_of(c):
    if c.startswith('COMP_CUT'): return 'CUT'
    if c.startswith('COMP_STK'): return 'STK'
    if c.startswith('COMP_NAMECARD') or c.startswith('COMP_PHOTOCARD'): return 'NAMECARD'
    return None

for sname, fn in [('CUT','price-cutting-l1.csv'),('STK','price-sticker-price-l1.csv'),('NAMECARD','price-namecard-photocard-l1.csv')]:
    pool = Counter(r['unit_price'].replace(',','') for r in load if sheet_of(r['comp_cd'])==sname)
    with open(base + '/06_extract/' + fn, newline='') as f:
        l1 = list(csv.DictReader(f))
    ni = [r for r in l1 if r['value'].replace(',','').isdigit()
          and r['value'].replace(',','') not in pool
          and r['value'].replace(',','') != r['row_key'].strip()]
    print('=== {} not-in-load {} cells ==='.format(sname, len(ni)))
    for r in ni:
        print('   {}/{} row_key={!r} band={!r} value={!r}'.format(r['block_title'], r['cell_ref'], r['row_key'], r['band_header_path'], r['value']))
