import csv
base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
with open(base + '/06_extract/price-namecard-photocard-l1.csv', newline='') as f:
    l1 = list(csv.DictReader(f))
# all blocks
from collections import Counter
print('=== namecard-photocard 블록 목록 ===')
for b, c in Counter(r['block_title'] for r in l1).most_common():
    print('   {!r}: {}'.format(b, c))
print()
print('=== 포토카드 관련 블록 셀 ===')
for r in l1:
    if '포토카드' in r['block_title'] or '포토' in (r['value'] or ''):
        if r['value'].strip():
            print('   {}/{} row_key={!r} value={!r}'.format(r['block_title'], r['cell_ref'], r['row_key'], r['value']))
