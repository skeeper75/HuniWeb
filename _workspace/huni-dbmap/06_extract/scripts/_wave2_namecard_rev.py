import csv
from collections import defaultdict
base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
with open(base + '/02_mapping/load_price/t_prc_component_prices.csv', newline='') as f:
    load = list(csv.DictReader(f))
with open(base + '/06_extract/price-namecard-photocard-l1.csv', newline='') as f:
    l1 = list(csv.DictReader(f))

# STD 명함 블록 L1 값
print('=== 스탠다드명함 블록 L1 가격 셀 ===')
for r in l1:
    if r['block_title'] == '스탠다드명함' and r['value'].replace(',','').isdigit() and r['value'] != r['row_key']:
        print('   {} row_key={!r} band={!r} value={!r}'.format(r['cell_ref'], r['row_key'], r['band_header_path'], r['value']))
print('=== load STD_S1/S2 ===')
for r in load:
    if r['comp_cd'] in ('COMP_NAMECARD_STD_S1', 'COMP_NAMECARD_STD_S2'):
        print('   {} mat={} min_qty={} price={} note={!r}'.format(r['comp_cd'], r['mat_cd'], r['min_qty'], r['unit_price'], r['note'][:60]))

# 세트/포함/2개 날조 검증: load note 키워드 -> L1에 실재 텍스트 있는지
print()
print('=== "세트/포함/2개1세트" 표기 L1 출처 확인 ===')
l1_alltext = ' '.join(r['value'] for r in l1) + ' ' + ' '.join(r['row_key'] for r in l1) + ' ' + ' '.join(r['block_title'] for r in l1)
# pcb sheet too
with open(base + '/06_extract/price-postcard-book-l1.csv', newline='') as f:
    pcb = list(csv.DictReader(f))
pcb_text = ' '.join(r['value'] for r in pcb) + ' ' + ' '.join(r['block_title'] for r in pcb)
with open(base + '/06_extract/price-sticker-price-l1.csv', newline='') as f:
    stk = list(csv.DictReader(f))
stk_text = ' '.join(r['value'] for r in stk) + ' ' + ' '.join(r['block_title'] for r in stk)
alltext = l1_alltext + ' ' + pcb_text + ' ' + stk_text
for kw in ['1세트', '20장1세트', '54장1세트', '삼각대', '포함', '2개']:
    print('   {!r} in L1 source: {}'.format(kw, kw in alltext))
