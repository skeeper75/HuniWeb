#!/usr/bin/env python3
"""t60 검산 — 본문(cto-todo.md)이 주장하는 수·경로를 원본에서 다시 재서 대조한다.
읽기전용. 실패하면 본문을 고치지 결과를 고치지 않는다."""
import csv, os, re, json, subprocess, collections

BASE = os.path.dirname(os.path.abspath(__file__))
SS = os.path.join(BASE, '..')
ROOT = '/Users/innojini/Dev/HuniWeb'
MALL = '/Users/innojini/Dev/huni-skin-shopby'
MESR = '/Users/innojini/Dev/TS.BackOffice.Huni'
WA = os.path.join(ROOT, 'raw', 'webadmin')

fails = []


def gate(ok, label, got=''):
    print(('PASS ' if ok else 'FAIL ') + label + (f' — {got}' if got != '' else ''))
    if not ok:
        fails.append(label)


def rd(p):
    return list(csv.DictReader(open(p, encoding='utf-8')))


def grepc(pattern, path, flags='-rnE', include=None):
    cmd = ['grep'] + flags.split() + ([f'--include={include}'] if include else []) + [pattern, path]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return 0 if r.returncode != 0 else len([l for l in r.stdout.splitlines() if l.strip()])


# --- 입력 ---
plan = rd(os.path.join(SS, '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'))
rej = rd(os.path.join(SS, 't56', 'rejudge.csv'))
ax = rd(os.path.join(BASE, 'axis-rows.csv'))
gate(len(plan) == 735, 'G1 입력 plan-rows 735행', len(plan))
gate(len(rej) == 735, 'G2 입력 t56 rejudge 735행', len(rej))

tok = lambda s: [t.strip() for t in re.split(r'[+·]', s or '')]
shh = [r for r in rej if '서희항' in tok(r['owner_proposed'])]
rem = [r for r in shh if r['remaining'] == 'Y']
gate((len(shh), len(rem)) == (246, 186), 'G3 서희항 몫 246 · 남은 일 186', (len(shh), len(rem)))

# --- 축 배분 ---
gate(len(ax) == 186, 'G4 axis-rows 186행', len(ax))
gate(all(r['axis'] in '123456' for r in ax), 'G5 미배치 0건',
     collections.Counter(r['axis'] for r in ax).get('0', 0))
c = collections.Counter(r['axis'] for r in ax)
want = {'1': 39, '2': 30, '3': 18, '4': 50, '5': 19, '6': 30}
gate(dict(c) == want, 'G6 축별 행수 39/30/18/50/19/30', dict(sorted(c.items())))
gate(len({r['row_id'] for r in ax}) == 186, 'G7 row_id 중복 0', len({r['row_id'] for r in ax}))
ids = {r['row_id'] for r in rej}
gate({r['row_id'] for r in ax} <= ids, 'G8 축 행 전건 t56 원장 실재')

# --- 근거강도 ---
jb = collections.Counter(r['judged_by'] for r in ax)
weak = jb['rule-step'] + jb['rule-track']
gate((jb['merged-owner_side'], jb['evidence-path'], jb['manual-read'], jb['rule-step'],
      jb['rule-track']) == (66, 59, 7, 42, 12), 'G9 judged_by 66/59/7/42/12', dict(jb))
gate(weak == 54 and round(weak / 186 * 100) == 29, 'G10 약한 근거 54행 = 29%', (weak, round(weak/186*100)))

# --- 선행 구조 ---
axis = {r['row_id']: r['axis'] for r in ax}
planm = {r['row_id']: r for r in plan}
none_c, ext_c = collections.Counter(), collections.Counter()
extt = collections.defaultdict(collections.Counter)
for r in ax:
    ts = [t.strip() for t in (r['prereq'] or '').split(';') if t.strip() and t.strip() != '—']
    if not ts:
        none_c[r['axis']] += 1
    for t in ts:
        if t not in axis and t not in planm:
            ext_c[r['axis']] += 1
            extt[r['axis']][t] += 1
gate(dict(none_c) == {'1': 34, '2': 12, '3': 8, '4': 3, '5': 1, '6': 18},
     'G11 축별 선행없음 34/12/8/3/1/18', dict(sorted(none_c.items())))
gate(dict(ext_c) == {'1': 3, '2': 11, '3': 12, '4': 55, '5': 9, '6': 6},
     'G12 축별 외부 선행 3/11/12/55/9/6', dict(sorted(ext_c.items())))
gate(sum(v for k, v in ext_c.items() if k != '4') == 41, 'G13 ④ 외의 다섯 축 외부 선행 합 41',
     sum(v for k, v in ext_c.items() if k != '4'))
e4 = extt['4']
gate((e4['EXT-PITSTOP'], e4['EXT-MES'], e4['EXT-NHN']) == (24, 20, 9),
     'G14 ④ EXT-PITSTOP 24 · EXT-MES 20 · EXT-NHN 9', dict(e4.most_common(4)))
gate(sum(v for k, v in none_c.items() if k != '4') == 73, 'G15 ④ 외 다섯 축 선행없음 합 73',
     sum(v for k, v in none_c.items() if k != '4'))

# --- provided 8행 ---
prov = [r for r in ax if r['verdict'] == 'provided']
gate(len(prov) == 8 and all(r['axis'] == '4' for r in prov), 'G16 provided 8행 전건 ④', len(prov))
art = [r for r in rem if r['row_id'].startswith('STD-ART-')]
gate(len(art) == 27 and len([r for r in art if r['verdict'] == 'provided']) == 7,
     'G17 STD-ART 남은 27 · provided 7 → 20 (리드 표기와 일치)',
     (len(art), len([r for r in art if r['verdict'] == 'provided'])))
mfg = [r for r in rem if r['row_id'].startswith('STD-MFG-')]
gate(len(mfg) == 63 and len([r for r in mfg if r['verdict'] == 'provided']) == 1,
     'G18 STD-MFG 남은 63 · provided 1 → 62 (리드 표기와 일치)',
     (len(mfg), len([r for r in mfg if r['verdict'] == 'provided'])))

# --- ③ 계약: 제공자 실재 · 호출자 0건 ---
urls = open(os.path.join(WA, 'webadmin', 'config', 'urls.py'), encoding='utf-8').read().splitlines()
def has_route(p):
    return any(f'"{p}"' in l for l in urls)
gate(all(has_route(p) for p in ['api/w/v1/handoff', 'api/w/v1/handoff/verify',
                                'api/w/v1/handoff/requote', 'api/w/v1/order/register',
                                'api/w/v1/catalog']), 'G19 제공자 라우트 5종 실재(urls.py)')
gate(len([l for l in urls if 'api/w/v1' in l]) == 22, 'G20 api/w/v1 라우트 22개',
     len([l for l in urls if 'api/w/v1' in l]))
src = os.path.join(MALL, 'src')
gate(grepc('order/register', src) == 0, 'G21 huni-mall order/register 호출 0건', grepc('order/register', src))
gate(grepc('X-Huni-Server-Key', src) == 0, 'G22 huni-mall 서버키 헤더 0건', grepc('X-Huni-Server-Key', src))
hv = subprocess.run(['grep', '-rn', 'handoff/verify', src], capture_output=True, text=True).stdout
gate(all('huni-widget.tsx' in l for l in hv.splitlines() if l.strip()) and len(hv.splitlines()) == 2,
     'G23 huni-mall handoff/verify = 주석 2줄뿐(실호출 0)', len(hv.splitlines()))
imp = subprocess.run(['grep', '-rln', '@/lib/api/requote', src], capture_output=True, text=True).stdout
gate([os.path.basename(p) for p in imp.split()] == ['cart-page.tsx'],
     'G24 requote 헬퍼 호출처 = cart-page.tsx 뿐', imp.split())

# --- ④ 세 저장소 코드 0 ---
gate(grepc('pitstop', os.path.join(WA, 'webadmin'), '-rniE', '*.py') == 0,
     'G25 webadmin PitStop 0건')
gate(grepc('MES_SENT|mes_send|api_mes|send_to_mes', os.path.join(WA, 'webadmin'), '-rnE', '*.py') == 0,
     'G26 webadmin MES 전송 코드 0건')
# mes_item_cd 는 앱 디렉터리에 8곳 — 전부 필드 정의·입력 안내·중복 검증(그릇). 전송 코드는 G26 이 0건으로 잡는다.
gate(grepc('mes_item_cd', os.path.join(WA, 'webadmin'), '-rn', '*.py') == 8,
     'G27 webadmin(앱) mes_item_cd 8곳 — 전부 그릇(필드·안내·중복검증)',
     grepc('mes_item_cd', os.path.join(WA, 'webadmin'), '-rn', '*.py'))
gate(grepc('pitstop', MESR, '-rniE', '*.cs') == 0, 'G28 MES 저장소 PitStop 0건')
gate(grepc('shopby', MESR, '-rniE', '*.cs') == 0, 'G29 MES 저장소 shopby 0건')
gate(grepc('pitstop|mes_item', src, '-rniE') == 0, 'G30 huni-mall PitStop/MES 0건')

# --- ② Edicus 구멍 21건 ---
cov = json.load(open(os.path.join(WA, 'tools', 'edicus_coverage_baseline.json'), encoding='utf-8'))
miss = {}
blocked = []
def walk(o, k=''):
    if isinstance(o, dict):
        if isinstance(o.get('miss'), int) and o['miss']:
            miss[k] = o['miss']
        if o.get('blocked'):
            blocked.append(k)
        for kk, v in o.items():
            walk(v, k + '/' + str(kk))
    elif isinstance(o, list):
        for i, v in enumerate(o):
            walk(v, k + f'[{i}]')
walk(cov)
gate(sum(miss.values()) == 21 and len(blocked) == 1,
     'G31 Edicus miss 합계 21 · blocked 1상품', (sum(miss.values()), blocked))

# --- ① 허용사이트 등록 수단 부재 ---
gate(grepc('TWgtSites', os.path.join(WA, 'webadmin', 'catalog', 'admin.py'), '-n') == 0,
     'G32 TWgtSites Django admin 미등록(0건)')
# allow_domains 를 쓰는(UPDATE 하는) 코드는 테스트 픽스처에만 있다 — 운영 도구·화면에는 없다.
ad = subprocess.run(['grep', '-rn', '--include=*.py', 'allow_domains', WA],
                    capture_output=True, text=True).stdout.splitlines()
writers = [l for l in ad if '.update(allow_domains' in l.replace(' ', '')]
nontest = [l for l in writers if '/tests/' not in l and '/tools/' not in l]
gate(len(writers) == 2 and not nontest,
     'G33 allow_domains 쓰기 = 테스트 픽스처 2곳뿐 · 운영 도구·화면 0곳',
     [l.split(':')[0].replace(WA + '/', '') for l in writers])
gate(len(ad) == 21, 'G33b allow_domains 등장 21곳(저장소 전체)', len(ad))
gate('미설정=통과' in open(os.path.join(WA, 'webadmin', 'catalog', 'widget_api.py'),
                          encoding='utf-8').read().splitlines()[709],
     'G34 widget_api.py:710 「미설정=통과」 원문 실재')

# --- 인용 경로 실재 ---
CITED = [
    (WA, 'webadmin/config/urls.py'), (WA, 'webadmin/catalog/widget_api.py'),
    (WA, 'webadmin/catalog/artwork_promote.py'), (WA, 'webadmin/catalog/pricing.py'),
    (WA, 'webadmin/catalog/admin.py'), (WA, 'webadmin/catalog/price_views.py'),
    (WA, 'tools/issue_site_key.py'), (WA, 'tools/edicus_coverage_baseline.json'),
    (WA, 'docs/artwork-scan-integration.md'), (WA, 'docs/widget-builder-design.html'),
    (MALL, 'src/lib/printly/huni.ts'), (MALL, 'src/app/api/printly/requote/route.ts'),
    (MALL, 'src/lib/api/requote.ts'), (MALL, 'src/components/cart/cart-page.tsx'),
    (MALL, 'src/lib/api/server/catalog.ts'),
    (ROOT, '_workspace/huni-launch-runway/07_rebaseline/S/S4-infra/migration-plan.md'),
    (ROOT, '_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md'),
    (SS, 't50/pitstop-decisions.md'), (SS, 't57/connect-design.md'),
    (SS, 't58/verdict.md'), (SS, 't59/csj-todo.md'), (SS, 't56/rejudge.csv'),
]
missing = [os.path.join(a, b) for a, b in CITED if not os.path.exists(os.path.join(a, b))]
gate(not missing, f'G35 인용 경로 {len(CITED)}개 전건 실재', missing or '없음 0')

# --- 사실 정정 근거 ---
cd = open(os.path.join(SS, 't57', 'connect-design.md'), encoding='utf-8').read()
gate('「핫폴더 vs CLI」가 아니다' in cd, 'G36 t57 「핫폴더 vs CLI 가 아니다」 원문 실재')
gate('핫폴더 vs CLI' in open(os.path.join(SS, 't56', 'rejudge.csv'), encoding='utf-8').read(),
     'G37 t56 원장 STD-ART-034 제목에 「핫폴더 vs CLI」 실재(정정 대상)')
cs = open(os.path.join(ROOT, '_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md'),
          encoding='utf-8').read()
gate('오픈 테스트는 Lightsail 위에서' in cs, 'G38 CARDS-S §0-A 「오픈 테스트는 Lightsail 위에서」 실재')
mp = open(os.path.join(ROOT, '_workspace/huni-launch-runway/07_rebaseline/S/S4-infra/migration-plan.md'),
          encoding='utf-8').read()
gate('되돌릴 수 없는 단계 — 오픈 테스트 통과 후에만' in mp,
     'G39 런북 F3-11 「되돌릴 수 없는 단계 — 오픈 테스트 통과 후에만」 실재')

# --- 신규 제안이 원장과 충돌하지 않는가 ---
NEW = ['NEW-S1', 'NEW-S2', 'NEW-S3', 'NEW-S4']
gate(not (set(NEW) & ids), f'G40 신규 제안 {len(NEW)}건 row_id 원장 충돌 0', sorted(set(NEW) & ids) or '충돌 0')

# --- 보강(⑤ 통합 대상 4개 · 나가는 간선 · 오픈 테스트 선행) ---
INF_PREFIX = ('F1-', 'F2-', 'F3-')
INF_ROWS = {'T1-1', 'T1-2', 'T1-3'}
out_edges = []
for r in plan:
    ts = [t.strip() for t in (r['prereq'] or '').split(';') if t.strip() and t.strip() != '—']
    if any(t in INF_ROWS or t.startswith(INF_PREFIX) for t in ts):
        out_edges.append(r)
gate(len(out_edges) == 17, 'G41 ⑤ 인프라 행을 prereq 로 단 행 17', len(out_edges))
to_kdh = [r for r in out_edges if r['owner_name'] == '김동학']
gate([r['row_id'] for r in to_kdh] == ['F4-4'],
     'G42 ⑤ → 김동학 나가는 원장 간선은 F4-4 하나뿐', [r['row_id'] for r in to_kdh])
gate('F2-1' in (planm['F4-4']['prereq'] or ''), 'G43 F4-4.prereq 에 F2-1 실재', planm['F4-4']['prereq'])
gate(not any(t.startswith('F1-') for t in (planm['F4-2']['prereq'] or '').split(';')),
     'G44 F4-2.prereq 에 F1 계열 없음(간선 제안이 맞다)', planm['F4-2']['prereq'])

opentest = [r for r in plan if '오픈 테스트' in (r['prereq'] or '')]
gate([r['row_id'] for r in opentest] == ['F4-8'],
     'G45 prereq 에 「오픈 테스트」가 적힌 행은 F4-8 하나뿐', [r['row_id'] for r in opentest])
gate('오픈 테스트' not in (planm['F3-11']['prereq'] or '')
     and '오픈 테스트 통과 전 금지' in planm['T1-3']['title'],
     'G46 F3-11 은 prereq 에 오픈테스트 없음 · 같은 조건이 T1-3 제목에만 있다',
     planm['F3-11']['prereq'])

pcrx = re.compile(r'(페이지빌더|pagebuilder|Pie ?Canvas).*(이전|이관|마이그|Lightsail|컨테이너|배포)'
                  r'|(이전|이관|Lightsail).*(페이지빌더|pagebuilder|Pie ?Canvas)', re.I)
pcmig = [r for r in plan if pcrx.search(' '.join([r['title'], r.get('note') or '', r.get('evidence') or '']))]
gate(len(pcmig) == 0, 'G47 페이지빌더 Lightsail 이전 행 0 (찾지 못했다)', len(pcmig))
gate(sum(1 for r in plan if 'EXT-PIECANVAS' in (r['prereq'] or '')) == 0,
     'G48 EXT-PIECANVAS 를 prereq 로 단 행 0 — 정정이 원장 선후를 바꾸지 않는다')
pcall = [r for r in plan if re.search(r'페이지빌더|pagebuilder|Pie ?Canvas', ' '.join(
    [r['title'], r.get('note') or '', r.get('evidence') or '']), re.I)]
gate(len(pcall) == 2 and {r['owner_name'] for r in pcall} == {'김동학'},
     'G49 페이지빌더 언급 행 2 · 전건 김동학(정정과 이미 일치)',
     [(r['row_id'], r['owner_name']) for r in pcall])
PCDOC = '/Users/innojini/Dev/HuniWeb/_workspace/huni-page-compose/01_recon/pie-canvas-model.md'
gate(os.path.exists(PCDOC) and '벤더' in open(PCDOC, encoding='utf-8').read(),
     'G50 pie-canvas-model.md 가 「벤더」로 적고 있다(정정 대상 표기 실재)')


print(f"\n실패 {len(fails)}" + (': ' + '; '.join(fails) if fails else ''))
