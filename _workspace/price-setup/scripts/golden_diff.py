"""골든 두 판을 조합 단위로 대조한다. 금액이 달라진 줄만 뽑는다."""
import csv, sys
BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'
a, b = sys.argv[1], sys.argv[2]

def load(tag):
    d = {}
    for r in csv.DictReader(open(f'{BASE}/golden/golden-{tag}.csv')):
        d[(r['prd_cd'], r['combo'])] = r
    return d

A, B = load(a), load(b)
only_a = sorted(set(A) - set(B)); only_b = sorted(set(B) - set(A))
same = sorted(set(A) & set(B))

def money(r):
    v = r['final_price']
    return float(v) if v not in ('', None) else 0.0

moved = [(k, money(A[k]), money(B[k])) for k in same if money(A[k]) != money(B[k])]
print(f'{a} {len(A)}줄 ↔ {b} {len(B)}줄 · 공통 {len(same)} · {a}만 {len(only_a)} · {b}만 {len(only_b)}')
print(f'금액 달라진 조합 {len(moved)}건\n')
for (prd, combo), x, y in moved:
    nm = B[(prd, combo)]['prd_cd']
    print(f'  {prd} {combo:22s} {x:>12,.0f} → {y:>12,.0f}  ({y-x:+,.0f})')
for k in only_a[:10]: print('  A만:', k)
for k in only_b[:10]: print('  B만:', k)
