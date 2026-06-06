import csv
from collections import Counter
base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
with open(base + '/02_mapping/load_price/t_prc_component_prices.csv', newline='') as f:
    rows = list(csv.DictReader(f))

print('TOTAL rows:', len(rows))

# C-2 natural key uniqueness (comp,apply,siz,clr,mat,coat,bdl,min)
nk = Counter((r['comp_cd'], r['apply_ymd'], r['siz_cd'], r['clr_cd'], r['mat_cd'], r['coat_side_cnt'], r['bdl_qty'], r['min_qty']) for r in rows)
dups = {k: c for k, c in nk.items() if c > 1}
print('C-2 natural-key duplicates:', len(dups))
for k, c in list(dups.items())[:5]:
    print('   DUP x{}: {}'.format(c, k))

# apply_ymd uniformity
ay = Counter(r['apply_ymd'] for r in rows)
print('apply_ymd values:', dict(ay))

# unit_price all numeric & non-negative & not empty
bad_price = [r for r in rows if not r['unit_price'].replace(',', '').replace('.', '').isdigit()]
print('non-numeric unit_price rows:', len(bad_price))
for r in bad_price[:5]:
    print('   ', r['comp_price_id'], r['comp_cd'], repr(r['unit_price']))

# min_qty NOT NULL?
empty_minqty = [r for r in rows if r['min_qty'].strip() == '']
print('empty min_qty rows:', len(empty_minqty))
print('   sample comp of empty min_qty:', Counter(r['comp_cd'] for r in empty_minqty).most_common(6))

# comp_price_id uniqueness
ids = Counter(r['comp_price_id'] for r in rows)
print('duplicate comp_price_id:', len([1 for i, c in ids.items() if c > 1]))

# siz_cd real codes used (non-placeholder, non-null) - collect for FK check
real_siz = sorted(set(r['siz_cd'].strip() for r in rows if r['siz_cd'].strip() and not r['siz_cd'].startswith('SIZ_PENDING') and r['siz_cd'].strip().upper() != 'NULL'))
print('distinct real siz_cd used:', len(real_siz))
# write to a file for FK check
with open(base + '/06_extract/scripts/_wave2_real_siz.txt', 'w') as f:
    f.write('\n'.join(real_siz))

# mat_cd used
real_mat = sorted(set(r['mat_cd'].strip() for r in rows if r['mat_cd'].strip() and r['mat_cd'].strip().upper() != 'NULL'))
print('distinct mat_cd used:', len(real_mat), real_mat[:10])
with open(base + '/06_extract/scripts/_wave2_real_mat.txt', 'w') as f:
    f.write('\n'.join(real_mat))

# clr_cd used
real_clr = sorted(set(r['clr_cd'].strip() for r in rows if r['clr_cd'].strip() and r['clr_cd'].strip().upper() != 'NULL'))
print('distinct clr_cd used:', real_clr)
