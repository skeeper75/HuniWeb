#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""t63 산출물 빌더 — process-tree.csv · processes/*.md · gaps.csv · index.html.

입력
  scope.csv             담당 201행(원장에서 잘라낸 것)
  processes_def.py      사람이 쓴 프로세스 정의(L3·그림·경계)
  ev-{cat,opt,ord,pay}.csv  코드 증거 수집본(레인 조사 결과)
  evidence-index.json   선행 카드 증거 중 실재 확인된 조각(폴백)

출력은 전부 이 폴더 아래. 숫자는 전부 입력에서 세며 손으로 적지 않는다.
"""
import csv, html, json, os, re
from collections import Counter, OrderedDict

import processes_def as D
import evidence_norm as EN

HERE = os.path.dirname(os.path.abspath(__file__))
OUT_MD = os.path.join(HERE, 'processes')

# 「결정·확인·협의」 성격 — 코드가 없는 것이 결함이 아닌 행
DECISION_PAT = re.compile(
    r'(결정|확정|협의|산정|상정|확인|검토|심사|서류|절차 정리|가능 여부|조건|수수료|기준 정리|정책)')
UNSETTLED = {'부분', '구현-미검증', '미실측', '미착수'}


def load_csv(name):
    p = os.path.join(HERE, name)
    if not os.path.isfile(p):
        return {}
    return {r['row_id']: r for r in csv.DictReader(open(p))}


def main():
    scope = OrderedDict((r['row_id'], r) for r in csv.DictReader(
        open(os.path.join(HERE, 'scope.csv'))))

    ev_rows = {}
    for n in ['ev-cat.csv', 'ev-opt.csv', 'ev-ord.csv', 'ev-pay.csv']:
        ev_rows.update(load_csv(n))

    fallback = {}
    fp = os.path.join(HERE, 'evidence-index.json')
    if os.path.isfile(fp):
        for rid, frags in json.load(open(fp)).items():
            good = [f"{f['path']}:{f['line']}" if f['line'] else f['path']
                    for f in frags if f['ok']]
            if good:
                fallback[rid] = ' · '.join(OrderedDict.fromkeys(good))

    # ── 행별 확정: 시스템 · 근거 · 갭 종류 ────────────────────────────────
    info, dropped_frag = {}, {}
    for rid, s in scope.items():
        e = ev_rows.get(rid, {})
        found = (e.get('found') or '').strip().upper() == 'Y'
        evid = (e.get('evidence') or '').strip()
        system = (e.get('system') or '').strip()
        note = (e.get('note') or '').strip()
        norm, nkeep, ndrop = EN.normalize(evid) if found else ('', 0, 0)
        if found and nkeep:
            basis, has_code = norm, True
            if ndrop:
                dropped_frag[rid] = ndrop
        elif rid in fallback:
            basis, has_code = fallback[rid] + ' (선행 카드 증거 · 실재 확인)', True
        else:
            basis, has_code = '「미확인」' + (f' — {evid}' if evid else ''), False

        decision = bool(DECISION_PAT.search(s['title'])) or '미정' in s['owner']
        if decision and not has_code:
            gap = '라 결정 미정'
        elif not has_code:
            gap = '나 행은 있는데 코드 0'
        elif s['status'] in UNSETTLED:
            gap = '다 코드는 있는데 연결 안 됨'
        else:
            gap = ''
        info[rid] = {'system': system or '미확인', 'basis': basis,
                     'gap': gap, 'note': note, 'has_code': has_code}

    # ── process-tree.csv ────────────────────────────────────────────────
    tree_path = os.path.join(HERE, 'process-tree.csv')
    cross_of = {}
    with open(tree_path, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['L0', 'L1_대분류', 'L2_중분류', 'L3_프로세스', 'L3_프로세스명',
                    'L4_순번', 'row_id', '기능', '시스템', '담당자', '상태',
                    '근거', 'cross'])
        for p in D.PROCESSES:
            xc = ' / '.join(c for c in p['cross'] if c.startswith('t'))
            cross_of[p['id']] = xc
            n = 0
            for rid in p['rows']:
                s, i = scope[rid], info[rid]
                n += 1
                w.writerow([D.L0['card'], p['daebun'], p['jungbun'], p['id'],
                            p['name'], n, rid, s['title'], i['system'],
                            s['owner'], s['status'], i['basis'], xc])
            for (title, sysname, owner, _why) in p['extra']:
                n += 1
                w.writerow([D.L0['card'], p['daebun'], p['jungbun'], p['id'],
                            p['name'], n, '', title, sysname, owner,
                            '원장 행 없음', '「미확인」', xc])

    # ── gaps.csv ────────────────────────────────────────────────────────
    gaps = []
    for p in D.PROCESSES:
        for (title, sysname, owner, why) in p['extra']:
            gaps.append([p['id'], p['name'], '가 원장에 행 없음', '', title,
                         why, owner, '원장 735행에 행을 새로 섞지 않는다 — 이 제안으로만 남긴다'])
        for rid in p['rows']:
            g = info[rid]['gap']
            if not g:
                continue
            s = scope[rid]
            pre = {'나 행은 있는데 코드 0': '코드·명세를 뒤졌으나 구현을 찾지 못했다',
                   '다 코드는 있는데 연결 안 됨': f"코드는 있는데 원장 상태가 「{s['status']}」다",
                   '라 결정 미정': '사람이 정해야 끝나는 안건 — 코드가 없는 것이 결함이 아니다'}[g]
            gaps.append([p['id'], p['name'], g, rid, s['title'],
                         (info[rid]['note'] or pre), s['owner'], pre])
    with open(os.path.join(HERE, 'gaps.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['프로세스', '프로세스명', '종류', 'row_id', '내용', '진단',
                    '제안 담당', '선행'])
        w.writerows(gaps)

    # ── processes/*.md ──────────────────────────────────────────────────
    os.makedirs(OUT_MD, exist_ok=True)
    gap_by_p = Counter(g[0] for g in gaps)
    for p in D.PROCESSES:
        md = render_md(p, scope, info, gaps)
        fn = f"{p['id']}-{p['name'].replace(' ', '-').replace('·', '-')}.md"
        open(os.path.join(OUT_MD, fn), 'w').write(md)

    # ── index.html ──────────────────────────────────────────────────────
    open(os.path.join(HERE, 'index.html'), 'w').write(
        render_html(scope, info, gaps, gap_by_p))

    # ── 요약 ────────────────────────────────────────────────────────────
    gk = Counter(g[2] for g in gaps)
    print(f'프로세스 {len(D.PROCESSES)} · 담당 행 {len(scope)} · '
          f'미귀속 {len(scope) - sum(len(p["rows"]) for p in D.PROCESSES)}')
    print('갭', dict(gk), '합', len(gaps))
    print('근거 확보', sum(1 for i in info.values() if i['has_code']),
          '/ 미확인', sum(1 for i in info.values() if not i['has_code']))
    if dropped_frag:
        print(f'해소 실패로 버린 근거 조각 {sum(dropped_frag.values())}개 '
              f'({len(dropped_frag)}행) — 실재 확인된 것만 싣는다')


def render_md(p, scope, info, gaps):
    L = []
    A = L.append
    A(f"# {p['id']} · {p['name']}\n")
    A(f"> {D.L0['card']} · L1 **{p['daebun']}** · L2 {p['jungbun']}\n")

    A('## 1. 한줄정의 · 시작/끝 · 등장인물\n')
    A(f"**한줄정의** — {p['oneline']}\n")
    A(f"- **시작**: {p['start']}")
    A(f"- **끝**: {p['end']}\n")
    A('| 등장인물 | 무엇인가 |')
    A('|---|---|')
    for a in p['actors']:
        A(f"| {a} | {D.ACTORS.get(a, '')} |")
    A('')
    if p['cross']:
        A('**가로지르는 곳**')
        for c in p['cross']:
            A(f"- {c}")
        A('')

    A('## 2. 흐름 (sequence)\n')
    A('```mermaid'); A(p['seq']); A('```\n')

    A('## 3. 갈림길 (flowchart · 실패·비회원·취소 분기)\n')
    A('```mermaid'); A(p['flow']); A('```\n')

    A('## 4. 단계표\n')
    A('| # | 단계 | 시스템 | 담당자 | 원장 row_id | 상태 | 근거 |')
    A('|---|---|---|---|---|---|---|')
    n = 0
    for rid in p['rows']:
        s, i = scope[rid], info[rid]
        n += 1
        A(f"| {n} | {s['title']} | {i['system']} | {s['owner']} | `{rid}` | "
          f"{s['status']} | {i['basis']} |")
    for (title, sysname, owner, _why) in p['extra']:
        n += 1
        A(f"| {n} | {title} | {sysname} | {owner} | — | **원장 행 없음** | 「미확인」 |")
    A('')

    A('## 5. 빠진 곳\n')
    mine = [g for g in gaps if g[0] == p['id']]
    if not mine:
        A('이 프로세스에서 네 종류 어디에도 걸린 단계가 없다.\n')
    else:
        for kind in ['가 원장에 행 없음', '나 행은 있는데 코드 0',
                     '다 코드는 있는데 연결 안 됨', '라 결정 미정']:
            sel = [g for g in mine if g[2] == kind]
            if not sel:
                continue
            A(f"**{kind}** — {len(sel)}건\n")
            A('| row_id | 내용 | 진단 |')
            A('|---|---|---|')
            for g in sel:
                A(f"| {('`' + g[3] + '`') if g[3] else '—'} | {g[4]} | {g[5]} |")
            A('')

    A('## 6. 채우는 방법\n')
    if not mine:
        A('추가로 채울 것이 없다.\n')
    else:
        A('| 누가 | 무엇을 | 선행 |')
        A('|---|---|---|')
        for g in mine:
            A(f"| {g[6]} | {g[4]} | {g[7]} |")
        A('')

    A('## 7. 확인 못 한 것\n')
    A(p['unknown'] + '\n')
    A('---')
    A('> 이 문서의 상태·근거는 원장 `08_system-screen/t56/rejudge.csv` 와 '
      '이 카드의 증거 수집본에서 기계로 채웠다. '
      '「미확인」은 코드·원장·명세를 뒤졌으나 **찾지 못했다**는 뜻이지, 없다는 뜻이 아니다.')
    return '\n'.join(L) + '\n'


def render_html(scope, info, gaps, gap_by_p):
    esc = html.escape
    gk = Counter(g[2] for g in gaps)
    by_dae = OrderedDict()
    for p in D.PROCESSES:
        by_dae.setdefault(p['daebun'], []).append(p)

    nav, panes = [], []
    for dae, ps in by_dae.items():
        nav.append(f'<div class="grp"><h3>{esc(dae)}</h3><ul>')
        for p in ps:
            nav.append(
                f'<li><button data-t="{p["id"]}">'
                f'<span class="pid">{p["id"]}</span>{esc(p["name"])}'
                f'<span class="badge" title="빠진 곳">{gap_by_p.get(p["id"], 0)}</span>'
                f'</button></li>')
        nav.append('</ul></div>')

    for p in D.PROCESSES:
        rows = []
        n = 0
        for rid in p['rows']:
            s, i = scope[rid], info[rid]
            n += 1
            cls = 'ok' if i['has_code'] else 'no'
            rows.append(
                f'<tr><td>{n}</td><td>{esc(s["title"])}</td>'
                f'<td>{esc(i["system"])}</td><td>{esc(s["owner"])}</td>'
                f'<td><code>{rid}</code></td><td>{esc(s["status"])}</td>'
                f'<td class="{cls}">{esc(i["basis"])}</td></tr>')
        for (title, sysname, owner, _w) in p['extra']:
            n += 1
            rows.append(
                f'<tr><td>{n}</td><td>{esc(title)}</td><td>{esc(sysname)}</td>'
                f'<td>{esc(owner)}</td><td>—</td><td><b>원장 행 없음</b></td>'
                f'<td class="no">「미확인」</td></tr>')
        mine = [g for g in gaps if g[0] == p['id']]
        grows = ''.join(
            f'<tr><td>{esc(g[2])}</td><td>{("<code>" + g[3] + "</code>") if g[3] else "—"}</td>'
            f'<td>{esc(g[4])}</td><td>{esc(g[5])}</td><td>{esc(g[6])}</td></tr>'
            for g in mine)
        panes.append(f"""<section class="pane" id="{p['id']}">
<h2><span class="pid">{p['id']}</span> {esc(p['name'])}</h2>
<p class="one">{esc(p['oneline'])}</p>
<p class="se"><b>시작</b> {esc(p['start'])} &nbsp;→&nbsp; <b>끝</b> {esc(p['end'])}</p>
<h4>흐름</h4><pre class="mermaid">{esc(p['seq'])}</pre>
<h4>갈림길</h4><pre class="mermaid">{esc(p['flow'])}</pre>
<h4>단계표 <span class="cnt">{n}단계</span></h4>
<table><thead><tr><th>#</th><th>단계</th><th>시스템</th><th>담당자</th>
<th>원장 row_id</th><th>상태</th><th>근거</th></tr></thead>
<tbody>{''.join(rows)}</tbody></table>
<h4>빠진 곳 <span class="cnt">{len(mine)}건</span></h4>
<table><thead><tr><th>종류</th><th>row_id</th><th>내용</th><th>진단</th>
<th>제안 담당</th></tr></thead><tbody>{grows or
    '<tr><td colspan="5">없다</td></tr>'}</tbody></table>
<h4>확인 못 한 것</h4><p class="unk">{esc(p['unknown'])}</p>
</section>""")

    kpi = ''.join(f'<div class="k"><b>{v}</b><span>{esc(k)}</span></div>'
                  for k, v in [('프로세스', len(D.PROCESSES)),
                               ('담당 기능 행', len(scope)),
                               ('근거 확보', sum(1 for i in info.values() if i['has_code'])),
                               ('미확인', sum(1 for i in info.values() if not i['has_code'])),
                               ('빠진 곳', len(gaps))]) + \
          ''.join(f'<div class="k s"><b>{v}</b><span>{esc(k)}</span></div>'
                  for k, v in sorted(gk.items()))

    return f"""<!DOCTYPE html>
<html lang="ko"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>탐색~결제 프로세스 지도</title>
<style>
:root {{ --bg:#fbfaf8; --fg:#1c1a17; --mut:#6b6559; --line:#e3ded4;
  --card:#fff; --acc:#8a5a2b; --ok:#2f6b46; --no:#9a3412; }}
:root:not([data-theme="light"]) {{ }}
@media (prefers-color-scheme: dark) {{ :root:not([data-theme="light"]) {{
  --bg:#171614; --fg:#eceae6; --mut:#9b948a; --line:#332f2a; --card:#201e1b;
  --acc:#d3a06a; --ok:#7fc39a; --no:#f0a27a; }} }}
:root[data-theme="dark"] {{ --bg:#171614; --fg:#eceae6; --mut:#9b948a;
  --line:#332f2a; --card:#201e1b; --acc:#d3a06a; --ok:#7fc39a; --no:#f0a27a; }}
* {{ box-sizing:border-box; }}
body {{ margin:0; background:var(--bg); color:var(--fg);
  font:15px/1.65 -apple-system,"Apple SD Gothic Neo","Noto Sans KR",sans-serif; }}
header {{ padding:28px 16px 12px; border-bottom:1px solid var(--line); }}
h1 {{ margin:0 0 4px; font-size:22px; letter-spacing:-.02em; }}
header p {{ margin:0; color:var(--mut); font-size:13px; }}
.kpi {{ display:flex; flex-wrap:wrap; gap:8px; padding:14px 16px; }}
.k {{ background:var(--card); border:1px solid var(--line); border-radius:10px;
  padding:8px 12px; min-width:104px; }}
.k b {{ display:block; font-size:19px; }}
.k span {{ font-size:11px; color:var(--mut); }}
.k.s b {{ color:var(--acc); }}
.wrap {{ display:flex; gap:20px; padding:0 16px 48px; align-items:flex-start; }}
nav {{ flex:0 0 268px; position:sticky; top:12px; max-height:88vh; overflow:auto; }}
.grp h3 {{ font-size:12px; color:var(--mut); margin:16px 0 6px;
  text-transform:none; letter-spacing:.04em; }}
nav ul {{ list-style:none; margin:0; padding:0; }}
nav button {{ width:100%; text-align:left; background:none; border:0;
  color:var(--fg); padding:6px 8px; border-radius:8px; cursor:pointer;
  font:inherit; font-size:13.5px; display:flex; align-items:center; gap:7px; }}
nav button:hover {{ background:var(--card); }}
nav button[aria-current="true"] {{ background:var(--card);
  box-shadow:inset 2px 0 0 var(--acc); }}
.pid {{ font-size:11px; color:var(--acc); font-weight:700; }}
.badge {{ margin-left:auto; font-size:11px; color:var(--mut);
  border:1px solid var(--line); border-radius:999px; padding:0 6px; }}
main {{ flex:1; min-width:0; }}
.pane {{ display:none; background:var(--card); border:1px solid var(--line);
  border-radius:14px; padding:20px; }}
.pane.on {{ display:block; }}
.pane h2 {{ margin:0 0 6px; font-size:19px; }}
.one {{ margin:0 0 6px; }}
.se {{ margin:0 0 14px; color:var(--mut); font-size:13px; }}
h4 {{ margin:22px 0 8px; font-size:13px; color:var(--mut); }}
.cnt {{ color:var(--acc); }}
table {{ width:100%; border-collapse:collapse; font-size:12.5px; }}
th,td {{ border-bottom:1px solid var(--line); padding:6px 8px;
  text-align:left; vertical-align:top; }}
th {{ color:var(--mut); font-weight:600; font-size:11.5px; }}
td.ok {{ color:var(--ok); }} td.no {{ color:var(--no); }}
code {{ font-size:11.5px; }}
.unk {{ color:var(--mut); font-size:13px; }}
.mermaid {{ background:transparent; overflow:auto; }}
@media (max-width:820px) {{ .wrap {{ display:block; }}
  nav {{ position:static; max-height:none; margin-bottom:16px; }} }}
</style></head><body>
<header><h1>탐색~결제 프로세스 지도</h1>
<p>{esc(D.L0['card'])} · L0 {esc(D.L0['name'])}</p></header>
<div class="kpi">{kpi}</div>
<div class="wrap"><nav>{''.join(nav)}</nav><main>{''.join(panes)}</main></div>
<script type="module">
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
const dark = matchMedia('(prefers-color-scheme: dark)').matches;
mermaid.initialize({{ startOnLoad:false, theme: dark ? 'dark' : 'neutral',
  securityLevel:'strict' }});
const btns = [...document.querySelectorAll('nav button')];
const show = id => {{
  document.querySelectorAll('.pane').forEach(p => p.classList.toggle('on', p.id===id));
  btns.forEach(b => b.setAttribute('aria-current', String(b.dataset.t===id)));
  mermaid.run({{ nodes: document.querySelectorAll('#'+id+' .mermaid') }});
}};
btns.forEach(b => b.onclick = () => show(b.dataset.t));
show(btns[0].dataset.t);
</script></body></html>"""


main()
