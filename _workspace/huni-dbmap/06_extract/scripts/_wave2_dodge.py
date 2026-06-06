import csv, re
from collections import Counter, defaultdict
base = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
with open(base + '/02_mapping/load_price/t_prc_component_prices.csv', newline='') as f:
    rows = list(csv.DictReader(f))

live = {}
with open(base + '/06_extract/scripts/_live_siz.tsv') as f:
    for line in f:
        p = line.rstrip('\n').split('\t')
        if len(p) >= 2:
            live[p[0]] = p[1]

def norm(s):
    s = re.sub(r'\([^)]*\)', '', s)
    s = re.sub(r'\s+', '', s)
    return s.lower().replace('mm', '')
live_norm = defaultdict(list)
for cd, nm in live.items():
    live_norm[norm(nm)].append(cd)

ph = [r for r in rows if r['siz_cd'].startswith('SIZ_PENDING')]
def grp(c):
    if c.startswith('COMP_GANGPAN'): return 'GANGPAN'
    if c.startswith('COMP_STK'): return 'STK'
    if c.startswith('COMP_CUT'): return 'CUT'
    if c.startswith('COMP_ACRYL'): return 'ACRYL'
    if c.startswith('COMP_PRINT') or c.startswith('COMP_COAT'): return 'DIGITAL/COAT'
    if c.startswith('COMP_ENV'): return 'ENV'
    return c
print('=== placeholder siz_cd rows (적재 차단, FK 부재) ===')
print('   TOTAL placeholder rows:', len(ph))
print('   by group:', dict(Counter(grp(r['comp_cd']) for r in ph)))

# GANGPAN: how many placeholder siz_cd map to a live size (dodge-fixable)
gp = [r for r in ph if r['comp_cd'].startswith('COMP_GANGPAN')]
fixable = nonfix = 0
fix_rows = nonfix_rows = 0
seen = {}
for r in gp:
    label = r['siz_cd'].replace('SIZ_PENDING_GP_', '')
    key = norm(label)
    if live_norm.get(key):
        fix_rows += 1
        seen.setdefault('FIX', set()).add(label)
    else:
        nonfix_rows += 1
        seen.setdefault('NONFIX', set()).add(label)
print()
print('=== GANGPAN dodge 판정 ===')
print('   행: 라이브매칭(dodge-fixable)={}  미매칭(정당 미등록)={}'.format(fix_rows, nonfix_rows))
print('   distinct siz: fixable={} nonfix={}'.format(len(seen.get('FIX', set())), len(seen.get('NONFIX', set()))))
print('   nonfix labels (원형류):', sorted(seen.get('NONFIX', set())))

# STK placeholder: how many fixable
stk = [r for r in ph if r['comp_cd'].startswith('COMP_STK')]
sf = snf = 0
stk_fix_labels = set(); stk_nonfix_labels = set()
for r in stk:
    label = r['siz_cd'].replace('SIZ_PENDING_STK_', '')
    key = norm(label.replace('_', ''))
    if live_norm.get(key):
        sf += 1; stk_fix_labels.add(label)
    else:
        snf += 1; stk_nonfix_labels.add(label)
print()
print('=== STK dodge 판정 ===')
print('   행: fixable={} nonfix={}'.format(sf, snf))
print('   fixable labels:', sorted(stk_fix_labels))
print('   nonfix labels:', sorted(stk_nonfix_labels))

# CUT placeholder
cut = [r for r in ph if r['comp_cd'].startswith('COMP_CUT')]
print()
print('=== CUT placeholder ===')
print('   rows:', len(cut), 'distinct siz:', set(r['siz_cd'] for r in cut))
for sc in set(r['siz_cd'] for r in cut):
    label = sc.replace('SIZ_PENDING_', '')
    print('   {} -> live match: {}'.format(sc, live_norm.get(norm(label))))
