# -*- coding: utf-8 -*-
"""t59 검산 — 주장한 수치를 원본에서 다시 재고, 인용 경로의 실재를 확인한다."""
import csv, os, re, sys

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t59/_workspace/huni-launch-runway/'
MAIN = '/Users/innojini/Dev/HuniWeb/'
SKIN = '/Users/innojini/Dev/huni-skin-shopby/'
PLAN = BASE + '07_rebaseline/S/S5-plan/plan-rows.csv'
REJ = BASE + '08_system-screen/t56/rejudge.csv'
AX = BASE + '08_system-screen/t59/axis-rows.csv'
GUIDE = SKIN + 'src/lib/guide-data.ts'

fails = []


def gate(name, ok, got):
    print(('PASS ' if ok else 'FAIL ') + name + ' — ' + str(got))
    if not ok:
        fails.append(name)


def load(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f))


plan = load(PLAN)
rej = load(REJ)
ax = load(AX)
own = {r['row_id']: r['owner_name'] for r in plan}

gate('G1 입력 plan-rows 735행', len(plan) == 735, len(plan))
gate('G2 입력 t56 rejudge 735행', len(rej) == 735, len(rej))

# G3 신규 제안 행은 원장 row_id 와 겹치지 않는다
new = [r for r in ax if r['kind'] == '신규']
dup = [r['row_id'] for r in new if r['row_id'] in own]
gate('G3 신규 제안 row_id 가 원장과 충돌 0', not dup, '신규 %d건 · 충돌 %s' % (len(new), dup or 0))

# G4 재연결·경계 행은 전부 원장에 실재
miss = [r['row_id'] for r in ax if r['kind'] != '신규' and r['row_id'] not in own]
gate('G4 재연결·경계 행 전건 원장 실재', not miss, '%d건 · 누락 %s' % (len(ax) - len(new), miss or 0))

# G5 prereq 간선 — 최숙진 선행 → 서희항 후행
idpat = re.compile(r'(STD-[A-Z0-9]+-\d+|T\d-\d+|F\d-\d+|BLK-[A-Z0-9-]+)')
edges = 0
csj_src = 0
csj_to_shk = 0
for r in plan:
    for i in set(idpat.findall(r['prereq'] or '')):
        if i not in own:
            continue
        edges += 1
        if own[i] == '최숙진':
            csj_src += 1
            if own[r['row_id']] == '서희항':
                csj_to_shk += 1
gate('G5 원장 prereq 간선 182 · 최숙진 선행 25 · 그중 서희항 후행 1',
     (edges, csj_src, csj_to_shk) == (182, 25, 1), (edges, csj_src, csj_to_shk))

# G6 정의하는 행 10개의 후행 0건
DEFN = ['STD-ADO-008', 'STD-ADO-010', 'STD-ADO-017', 'STD-MFG-058', 'STD-MFG-062',
        'STD-MFG-092', 'STD-MFG-100', 'STD-ADO-018', 'STD-CAT-019', 'STD-INF-007']
succ = {d: 0 for d in DEFN}
for r in plan:
    for i in set(idpat.findall(r['prereq'] or '')):
        if i in succ:
            succ[i] += 1
gate('G6 정의 행 10개 후행 0건', all(v == 0 for v in succ.values()),
     {k: v for k, v in succ.items() if v})

# G7 최숙진 행 수 · prereq 공란 수
csj = [r for r in plan if r['owner_name'] == '최숙진']
blank = [r for r in csj if (r['prereq'] or '').strip() in ('', '—')]
gate('G7 최숙진 행 153 · prereq 공란 126', (len(csj), len(blank)) == (153, 126), (len(csj), len(blank)))

# G8 상세탭 도구 행 5개 전부 최숙진 아님
TAB = ['STD-CAT-007', 'STD-CAT-034', 'STD-ADP-015', 'STD-SYS-021', 'STD-SYS-049']
gate('G8 상세탭 원장 행 5개 중 최숙진 0', all(own.get(t) != '최숙진' for t in TAB),
     {t: own.get(t) for t in TAB})

# G9 guide-data.ts — 글 72편 중 자리표시자 71편
src = open(GUIDE, encoding='utf-8').read()
stub_calls = len(re.findall(r'(?<!function )\bstub\(', src)) - src.count('stub(\n      `${prefix}')
file_articles = 12
tabs_stub = len(re.findall(r'stubList\(', src)) - 1        # 정의 1회 제외
total = file_articles + tabs_stub * 12
placeholder = (file_articles - 1) + tabs_stub * 12
gate('G9 가이드북 글 72편 · 자리표시자 71편', (total, placeholder) == (72, 71), (total, placeholder))

# G10 자동 생성 제목 — 탭당 제목 4개만 주어진다
per_tab_titles = re.findall(r'stubList\("(\w+)", "[^"]+", 12, \[(.*?)\]\)', src, re.S)
auto = sum(12 - len(re.findall(r'"[^"]+"', t[1])) for t in per_tab_titles) if per_tab_titles else -1
gate('G10 자동 생성 제목 40건(5탭 × 8편)', auto == 40, auto)

# G11 인용 경로 실재
PATHS = [
    GUIDE,
    SKIN + 'src/lib/printly/detail-tabs.ts',
    SKIN + 'src/components/product/product-sections.tsx',
    SKIN + 'src/app/(main)/product/[slug]/page.tsx',
    MAIN + 'raw/webadmin/webadmin/config/urls.py',
    MAIN + 'raw/webadmin/webadmin/catalog/s3_guide.py',
    MAIN + 'docs/huni/후니프린팅_운영정책_260918.xlsx',
    MAIN + 'docs/huni/후니프린팅_리뉴얼_정책체크리스트.xlsx',
    MAIN + 'docs/huni/후니프린팅_운영정책_검토요청_260918.md',
    MAIN + 'docs/huni/후니-주문흐름-장바구니에서-MES까지_서희항_260908.html',
    MAIN + '_workspace/huni-launch-runway/07_rebaseline/S/S4-infra/migration-plan.md',
    MAIN + '_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md',
    MAIN + '_workspace/_foundation/live-snapshot/snap_20260827_1422/t_prd_guide_files.csv',
]
bad = [p for p in PATHS if not os.path.exists(p)]
gate('G11 인용 경로 전건 실재', not bad, '%d개 확인 · 없음 %s' % (len(PATHS), bad or 0))

# G12 가이드 파일 스냅샷 — 504행 · 88상품 · guide_nm 전건 공란
gf = load(MAIN + '_workspace/_foundation/live-snapshot/snap_20260827_1422/t_prd_guide_files.csv')
blank_nm = sum(1 for r in gf if not (r['guide_nm'] or '').strip())
gate('G12 가이드파일 504행 · 상품 88 · 표시명 공란 504',
     (len(gf), len({r['prd_cd'] for r in gf}), blank_nm) == (504, 88, 504),
     (len(gf), len({r['prd_cd'] for r in gf}), blank_nm))

# G13 축 분포
import collections
c = collections.Counter(r['axis'] for r in ax)
k = collections.Counter(r['kind'] for r in ax)
gate('G13 axis-rows 42행 · 5축 · 신규 21', len(ax) == 42 and len(c) == 5 and k['신규'] == 21,
     (len(ax), dict(c), dict(k)))

print('실패 %d' % len(fails))
sys.exit(1 if fails else 0)
