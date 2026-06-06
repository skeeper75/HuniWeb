import csv

base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'

def dump(fn, block, rowmin=None, rowmax=None):
    with open(base + '/06_extract/' + fn, newline='') as f:
        l1 = list(csv.DictReader(f))
    print('=== {} / block={} ==='.format(fn, block))
    for r in l1:
        if block and r['block_title'] != block:
            continue
        cr = r['cell_ref']
        # extract row number
        num = ''.join(ch for ch in cr if ch.isdigit())
        if rowmin and num and int(num) < rowmin: continue
        if rowmax and num and int(num) > rowmax: continue
        if r['value'].strip() == '': continue
        print('   {} row_key={!r} band={!r} value={!r}'.format(cr, r['row_key'], r['band_header_path'], r['value']))

dump('price-cutting-l1.csv', '타공 (단가)', 44, 53)
print()
dump('price-namecard-photocard-l1.csv', '투명포토카드(20장1세트)', None, None)
print()
# STK 기본가 block
dump('price-sticker-price-l1.csv', '기본가', None, None)
