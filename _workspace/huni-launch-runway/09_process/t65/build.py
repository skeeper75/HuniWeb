# -*- coding: utf-8 -*-
"""t65 산출물 빌더 — spec_a/b/c 의 프로세스 정의와 원장을 합쳐 산출물을 다시 만든다.

원장(rejudge.csv)의 evidence·owner_proposed·status·verdict 는 **그대로** 옮긴다(전사 금지).
프로세스 정의(순서·그림·빠진 곳)만 이 저장소의 저작물이다.
"""
import csv
import html
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
RUNWAY = os.path.abspath(os.path.join(HERE, '..', '..'))
CANON = os.path.join(RUNWAY, '07_rebaseline/L1/standard-feature-canon.csv')
LEDGER = os.path.join(RUNWAY, '08_system-screen/t56/rejudge.csv')

L0 = '후니프린팅 몰 전체(huni-mall 독립몰 + 샵바이 + webadmin/위젯 + MES/PitStop)'

L1_OF = {
    'STD-CLM': '클레임·CS',
    'STD-ADP': '운영자·상품가격',
    'STD-FIN': '정산·통계',
    'STD-INF': '정보·콘텐츠',
    'STD-SYS': '시스템·플랫폼',
}

KIND_LABEL = {
    '가': '가 — 원장에 행 없음',
    '나': '나 — 행은 있는데 코드 0',
    '다': '다 — 코드는 있는데 연결 안 됨',
    '라': '라 — 결정 미정',
}


def prefix_of(i):
    return i.rsplit('-', 1)[0] if re.match(r'^[A-Z0-9]+-.+-\d+$', i) else None


def slug(name):
    s = re.sub(r'[\s/·,()\[\]:]+', '-', name.strip())
    s = re.sub(r'-+', '-', s).strip('-')
    return s


def load_processes():
    import spec_a
    import spec_b
    import spec_c
    ps = spec_a.PROCESSES + spec_b.PROCESSES + spec_c.PROCESSES
    seen = set()
    for p in ps:
        if p['pid'] in seen:
            raise SystemExit('중복 process_id: %s' % p['pid'])
        seen.add(p['pid'])
    return ps


def main():
    canon = {r['std_id']: r for r in csv.DictReader(open(CANON, encoding='utf-8'))}
    ledger = {r['row_id']: r for r in csv.DictReader(open(LEDGER, encoding='utf-8'))}
    procs = load_processes()

    # ── process-tree.csv ──────────────────────────────────────────────
    tree_path = os.path.join(HERE, 'process-tree.csv')
    cols = ['L0', 'L1', 'L2', 'process_id', 'process_name', 'step_no', 'step', 'row_id',
            '기능', '시스템', '담당자', '상태', '원장판정', '근거', 'cross', '원장전용']
    rows = []
    for p in procs:
        for n, st in enumerate(p['steps'], 1):
            label, rid, system = st
            led = ledger.get(rid)
            if led is None:
                raise SystemExit('%s: 원장에 없는 row_id %s' % (p['pid'], rid))
            rows.append({
                'L0': L0,
                'L1': L1_OF[prefix_of(rid)],
                'L2': canon.get(rid, {}).get('중분류') or '%s(원장전용)' % p['l2'],
                'process_id': p['pid'],
                'process_name': p['name'],
                'step_no': n,
                'step': label,
                'row_id': rid,
                '기능': led['title'],
                '시스템': system,
                '담당자': led['owner_proposed'],
                '상태': led['status'],
                '원장판정': led['verdict'],
                '근거': led['evidence'],
                'cross': p.get('cross', ''),
                '원장전용': 'N' if rid in canon else 'Y',
            })
    with open(tree_path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)

    # ── gaps.csv ──────────────────────────────────────────────────────
    gcols = ['gap_id', 'process_id', 'process_name', '대분류', '종류', '종류설명',
             '내용', '제안담당', '선행']
    gaps = []
    n = 0
    for p in procs:
        for kind, text, owner, pre in p['gaps']:
            n += 1
            gaps.append({
                'gap_id': 'G-t65-%03d' % n,
                'process_id': p['pid'],
                'process_name': p['name'],
                '대분류': p['l1'],
                '종류': kind,
                '종류설명': KIND_LABEL[kind],
                '내용': text,
                '제안담당': owner,
                '선행': pre,
            })
    with open(os.path.join(HERE, 'gaps.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=gcols)
        w.writeheader()
        w.writerows(gaps)

    # ── processes/<Pnn>-<이름>.md ─────────────────────────────────────
    pdir = os.path.join(HERE, 'processes')
    os.makedirs(pdir, exist_ok=True)
    for old in os.listdir(pdir):
        if old.endswith('.md'):
            os.remove(os.path.join(pdir, old))
    for p in procs:
        mine = [r for r in rows if r['process_id'] == p['pid']]
        mygaps = [g for g in gaps if g['process_id'] == p['pid']]
        out = []
        out.append('# %s %s' % (p['pid'], p['name']))
        out.append('')
        out.append('> 카드 `t65` · 대분류 **%s** · 중분류 %s · 단계 %d · 빠진 곳 %d'
                   % (p['l1'], p['l2'], len(mine), len(mygaps)))
        out.append('')
        out.append('## 1. 한줄정의')
        out.append('')
        out.append(p['def'])
        out.append('')
        out.append('| | |')
        out.append('|---|---|')
        out.append('| **시작** | %s |' % p['start'])
        out.append('| **끝** | %s |' % p['end'])
        out.append('| **등장인물** | %s |' % ' · '.join(p['actors']))
        if p.get('cross'):
            out.append('| **가로지르는 카드** | %s |' % p['cross'])
        out.append('')
        out.append('## 2. 흐름 — sequenceDiagram')
        out.append('')
        out.append('```mermaid')
        out.append(p['seq'].strip())
        out.append('```')
        out.append('')
        out.append('## 3. 분기 — flowchart')
        out.append('')
        out.append('```mermaid')
        out.append(p['flow'].strip())
        out.append('```')
        out.append('')
        out.append('## 4. 단계표')
        out.append('')
        out.append('| # | 단계 | 시스템 | 담당자 | 원장 row_id | 상태 | 근거 |')
        out.append('|---:|---|---|---|---|---|---|')
        for r in mine:
            out.append('| %s | %s | %s | %s | `%s` | %s | %s |' % (
                r['step_no'], r['step'], r['시스템'], r['담당자'], r['row_id'],
                r['상태'], md_cell(r['근거'])))
        out.append('')
        out.append('## 5. 빠진 곳')
        out.append('')
        if mygaps:
            out.append('| id | 종류 | 내용 | 제안 담당 |')
            out.append('|---|---|---|---|')
            for g in mygaps:
                out.append('| `%s` | %s | %s | %s |' % (
                    g['gap_id'], g['종류설명'], md_cell(g['내용']), g['제안담당']))
        else:
            out.append('없음.')
        out.append('')
        out.append('## 6. 채우는 방법')
        out.append('')
        out.append(p['fill'].strip())
        out.append('')
        out.append('## 7. 확인 못 한 것')
        out.append('')
        out.append(p['unknown'].strip())
        out.append('')
        fn = '%s-%s.md' % (p['pid'], slug(p['name']))
        open(os.path.join(pdir, fn), 'w', encoding='utf-8').write('\n'.join(out))

    # ── index.html ────────────────────────────────────────────────────
    write_index(procs, rows, gaps)

    print('프로세스 %d · 단계 %d · 빠진 곳 %d' % (len(procs), len(rows), len(gaps)))
    by_l1 = {}
    for r in rows:
        by_l1[r['L1']] = by_l1.get(r['L1'], 0) + 1
    for k in sorted(by_l1):
        print('  %-12s %d' % (k, by_l1[k]))


def md_cell(s):
    return s.replace('|', '\\|').replace('\n', ' ')


def write_index(procs, rows, gaps):
    steps_of = {}
    for r in rows:
        steps_of.setdefault(r['process_id'], []).append(r)
    gaps_of = {}
    for g in gaps:
        gaps_of.setdefault(g['process_id'], []).append(g)

    l1order = ['클레임·CS', '정보·콘텐츠', '운영자·상품가격', '정산·통계', '시스템·플랫폼']
    tree = {}
    for p in procs:
        tree.setdefault(p['l1'], []).append(p)

    e = html.escape
    B = []
    B.append('<!doctype html><html lang="ko"><head><meta charset="utf-8">')
    B.append('<meta name="viewport" content="width=device-width,initial-scale=1">')
    B.append('<title>t65 프로세스 지도 — 클레임·운영·정산</title>')
    B.append('<script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.1/dist/mermaid.min.js"></script>')
    B.append('''<style>
:root{--bg:#fff;--fg:#1a1a1a;--mut:#6b6b6b;--line:#e3e3e3;--card:#fafafa;
--a:#2f6fdb;--g1:#c62828;--g2:#e07b00;--g3:#2f6fdb;--g4:#7b3fb8;}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#14161a;--fg:#e8e8e8;
--mut:#9aa0a6;--line:#2c3038;--card:#1b1e24;--a:#78a9ff;}}
:root[data-theme="dark"]{--bg:#14161a;--fg:#e8e8e8;--mut:#9aa0a6;--line:#2c3038;--card:#1b1e24;--a:#78a9ff;}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--fg);
font:15px/1.65 -apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Noto Sans KR",sans-serif}
.wrap{max-width:1180px;margin:0 auto;padding:32px 16px 96px}
h1{font-size:26px;margin:0 0 6px}h2{font-size:20px;margin:40px 0 10px;padding-bottom:6px;
border-bottom:2px solid var(--line)}h3{font-size:16px;margin:0}
.sub{color:var(--mut);margin:0 0 24px}
.kpi{display:flex;flex-wrap:wrap;gap:10px;margin:18px 0 6px}
.kpi div{background:var(--card);border:1px solid var(--line);border-radius:10px;
padding:10px 14px;min-width:104px}
.kpi b{display:block;font-size:22px}.kpi span{color:var(--mut);font-size:12px}
.tree{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:14px 18px;margin:10px 0 0}
.tree ul{margin:4px 0 4px 18px;padding:0}.tree li{list-style:none;margin:3px 0}
.tree a{color:var(--a);text-decoration:none}.tree a:hover{text-decoration:underline}
.proc{background:var(--card);border:1px solid var(--line);border-radius:12px;
padding:16px 18px;margin:14px 0}
.phead{display:flex;flex-wrap:wrap;gap:8px;align-items:baseline;justify-content:space-between}
.badges{display:flex;gap:6px;flex-wrap:wrap}
.b{font-size:11px;border-radius:999px;padding:2px 9px;color:#fff;white-space:nowrap}
.b.k가{background:var(--g1)}.b.k나{background:var(--g2)}.b.k다{background:var(--g3)}
.b.k라{background:var(--g4)}.b.steps{background:var(--mut)}
.def{color:var(--mut);margin:8px 0 0;font-size:14px}
details{margin-top:10px}summary{cursor:pointer;color:var(--a);font-size:14px}
table{border-collapse:collapse;width:100%;font-size:13px;margin-top:8px;display:block;overflow-x:auto}
th,td{border:1px solid var(--line);padding:5px 8px;text-align:left;vertical-align:top}
th{background:var(--bg)}
.ev{color:var(--mut);font-size:11px;word-break:break-all}
.mer{margin-top:10px;overflow-x:auto}
.legend{color:var(--mut);font-size:12px;margin-top:8px}
</style></head><body><div class="wrap">''')
    B.append('<h1>t65 프로세스 지도 — 클레임·운영·정산</h1>')
    B.append('<p class="sub">기능목록을 <b>고객·운영자가 겪는 한 흐름</b>으로 다시 묶었다. '
             'L0 몰 전체 → L1 대분류 → L2 중분류 → L3 프로세스 → L4 단계(기능 행).</p>')
    kinds = {k: 0 for k in KIND_LABEL}
    for g in gaps:
        kinds[g['종류']] += 1
    B.append('<div class="kpi">')
    B.append('<div><b>%d</b><span>프로세스</span></div>' % len(procs))
    B.append('<div><b>%d</b><span>기능 행(단계)</span></div>' % len(rows))
    B.append('<div><b>%d</b><span>빠진 곳</span></div>' % len(gaps))
    for k in ['가', '나', '다', '라']:
        B.append('<div><b>%d</b><span>%s</span></div>' % (kinds[k], e(KIND_LABEL[k])))
    B.append('</div>')

    B.append('<h2>L0 → L3 나무</h2>')
    B.append('<div class="tree"><b>%s</b><ul>' % e(L0))
    for l1 in l1order:
        ps = tree.get(l1, [])
        n = sum(len(steps_of.get(p['pid'], [])) for p in ps)
        B.append('<li>▸ <b>%s</b> <span class="ev">프로세스 %d · 단계 %d</span><ul>'
                 % (e(l1), len(ps), n))
        for p in ps:
            B.append('<li>· <a href="#%s">%s %s</a> <span class="ev">(%d단계 · 빠진 곳 %d)</span></li>'
                     % (p['pid'], p['pid'], e(p['name']),
                        len(steps_of.get(p['pid'], [])), len(gaps_of.get(p['pid'], []))))
        B.append('</ul></li>')
    B.append('</ul></div>')

    for l1 in l1order:
        B.append('<h2>%s</h2>' % e(l1))
        for p in tree.get(l1, []):
            st = steps_of.get(p['pid'], [])
            gs = gaps_of.get(p['pid'], [])
            kc = {}
            for g in gs:
                kc[g['종류']] = kc.get(g['종류'], 0) + 1
            B.append('<div class="proc" id="%s">' % p['pid'])
            B.append('<div class="phead"><h3>%s %s</h3><div class="badges">' % (p['pid'], e(p['name'])))
            B.append('<span class="b steps">%d단계</span>' % len(st))
            for k in ['가', '나', '다', '라']:
                if kc.get(k):
                    B.append('<span class="b k%s">%s %d</span>' % (k, k, kc[k]))
            B.append('</div></div>')
            B.append('<p class="def">%s</p>' % e(p['def']))
            B.append('<div class="mer"><pre class="mermaid">%s</pre></div>' % e(p['seq'].strip()))
            B.append('<div class="mer"><pre class="mermaid">%s</pre></div>' % e(p['flow'].strip()))
            B.append('<details><summary>단계표 %d행</summary><table>' % len(st))
            B.append('<tr><th>#</th><th>단계</th><th>시스템</th><th>담당자</th>'
                     '<th>row_id</th><th>상태</th><th>근거</th></tr>')
            for r in st:
                B.append('<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td><code>%s</code></td>'
                         '<td>%s</td><td class="ev">%s</td></tr>' % (
                             r['step_no'], e(r['step']), e(r['시스템']), e(r['담당자']),
                             e(r['row_id']), e(r['상태']), e(r['근거'])))
            B.append('</table></details>')
            if gs:
                B.append('<details><summary>빠진 곳 %d건</summary><table>' % len(gs))
                B.append('<tr><th>id</th><th>종류</th><th>내용</th><th>제안 담당</th><th>선행</th></tr>')
                for g in gs:
                    B.append('<tr><td><code>%s</code></td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>'
                             % (e(g['gap_id']), e(g['종류설명']), e(g['내용']),
                                e(g['제안담당']), e(g['선행'])))
                B.append('</table></details>')
            B.append('</div>')

    B.append('<p class="legend">근거는 원장 <code>08_system-screen/t56/rejudge.csv</code> 의 '
             'evidence 를 그대로 옮긴 것이다. 「미확인」은 확인하지 못했다는 뜻이지 없다는 뜻이 아니다.</p>')
    B.append('''</div><script>
mermaid.initialize({startOnLoad:true,securityLevel:"loose",
theme: matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "default"});
</script></body></html>''')
    open(os.path.join(HERE, 'index.html'), 'w', encoding='utf-8').write('\n'.join(B))


if __name__ == '__main__':
    main()
