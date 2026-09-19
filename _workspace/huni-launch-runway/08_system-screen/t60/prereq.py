#!/usr/bin/env python3
# t60 ㉰ — 원장 prereq 간선이 서희항 몫을 어떻게 묶고 있는지 실측. 읽기전용.
import csv, os, re, collections

BASE = os.path.dirname(os.path.abspath(__file__))
PLAN = os.path.join(BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv')
REJ = os.path.join(BASE, '..', 't56', 'rejudge.csv')

plan = {r['row_id']: r for r in csv.DictReader(open(PLAN, encoding='utf-8'))}
rej = {r['row_id']: r for r in csv.DictReader(open(REJ, encoding='utf-8'))}


def owners(rid):
    r = rej.get(rid)
    return [t.strip() for t in re.split(r'[+·]', r['owner_proposed'])] if r else []


SHH = {rid for rid in rej if '서희항' in owners(rid)}

# prereq 파싱: ';' 구분 · 원장에 실재하는 id 만 간선으로 센다
edges = []          # (선행, 후행)
ext = collections.Counter()
for rid, r in plan.items():
    for p in (r.get('prereq') or '').split(';'):
        p = p.strip()
        if not p:
            continue
        if p in plan:
            edges.append((p, rid))
        else:
            ext[p] += 1

print(f"plan-rows {len(plan)}행 · t56 rejudge {len(rej)}행 · 서희항 몫 {len(SHH)}")
print(f"해석 가능한 prereq 간선 {len(edges)} · 원장 밖 선행 토큰 {sum(ext.values())}종별 {len(ext)}")
print('원장 밖 선행 상위:', ext.most_common(8))

in_shh = [e for e in edges if e[1] in SHH]
out_shh = [e for e in edges if e[0] in SHH]
print(f"\n서희항 행이 후행인 간선 {len(in_shh)} · 선행인 간선 {len(out_shh)}")
print('  선행이 서희항 아닌 사람인 것:',
      collections.Counter(tuple(sorted(set(owners(a)) - {'서희항'})) or ('서희항',)
                          for a, b in in_shh).most_common(8))

def is_blank(rid):
    # 원장은 「선행 없음」을 공란이 아니라 '—' 로 적는다(735행 중 486행).
    v = (plan.get(rid, {}).get('prereq') or '').strip()
    return v in ('', '—')


blank = [rid for rid in SHH if is_blank(rid)]
print(f"\n서희항 몫 중 prereq 공란 {len(blank)} / {len(SHH)}")
rem = [rid for rid in SHH if rej[rid]['remaining'] == 'Y']
blank_rem = [rid for rid in rem if is_blank(rid)]
print(f"  남은 일 {len(rem)} 중 prereq 공란 {len(blank_rem)}")

# 서희항 행을 선행으로 둔 후행의 담당
succ = collections.Counter()
for a, b in out_shh:
    for o in owners(b):
        succ[o] += 1
print('\n서희항이 선행인 간선의 후행 담당 분포:', succ.most_common())
