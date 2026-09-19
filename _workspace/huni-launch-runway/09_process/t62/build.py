# -*- coding: utf-8 -*-
"""t62 산출물 빌더 — process-tree.csv · processes/*.md · gaps.csv · index.html.

입력: 기능목록 정본(standard-feature-canon.csv) + 원장(t56/rejudge.csv) + spec_a/b/c.py
출력: 이 디렉터리.
"""
import csv
import html
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RUNWAY = os.path.abspath(os.path.join(HERE, '..', '..'))
CANON = os.path.join(RUNWAY, '07_rebaseline/L1/standard-feature-canon.csv')
LEDGER = os.path.join(RUNWAY, '08_system-screen/t56/rejudge.csv')

sys.path.insert(0, HERE)
import spec_a
import spec_b
import spec_c

SPEC = {}
SPEC.update(spec_a.SPEC)
SPEC.update(spec_b.SPEC)
SPEC.update(spec_c.SPEC)

PREFIXES = ['STD-MEM', 'STD-MYP', 'STD-PRM', 'STD-B2B', 'STD-ADC']
L1_OF_PREFIX = {
    'STD-MEM': '회원·인증',
    'STD-MYP': '마이페이지',
    'STD-PRM': '프로모션',
    'STD-B2B': 'B2B',
    'STD-ADC': '운영자·회원CS',
}
CARD = 't62'
L0 = '후니프린팅 몰 전체(huni-mall 독립몰 + 샵바이 + webadmin/위젯 + MES/PitStop)'


def prefix_of(row_id):
    return row_id.rsplit('-', 1)[0] if re.match(r'^STD-.+-\d+$', row_id) else None


def load():
    canon = {r['std_id']: r for r in csv.DictReader(open(CANON, encoding='utf-8'))}
    ledger = {r['row_id']: r for r in csv.DictReader(open(LEDGER, encoding='utf-8'))}
    scope = {k: v for k, v in ledger.items() if prefix_of(k) in PREFIXES}
    return canon, ledger, scope


def feature_name(row_id, canon, ledger):
    c = canon.get(row_id)
    if c:
        return c['기능']
    return ledger[row_id]['title']


def l2_of(row_id, canon, proc):
    c = canon.get(row_id)
    if c:
        return c['중분류']
    return proc['l2'] + '(원장전용)'


def build_tree(canon, ledger, scope):
    rows = []
    seen = {}
    for pid in sorted(SPEC):
        p = SPEC[pid]
        for i, (label, row_id, system) in enumerate(p['steps'], 1):
            if row_id not in scope:
                raise SystemExit('범위 밖 row_id: %s (%s)' % (row_id, pid))
            led = ledger[row_id]
            seen.setdefault(row_id, []).append(pid)
            rows.append({
                'L0': L0,
                'L1': p['l1'],
                'L2': l2_of(row_id, canon, p),
                'process_id': pid,
                'process_name': p['name'],
                'step_no': i,
                'step': label,
                'row_id': row_id,
                '기능': feature_name(row_id, canon, ledger),
                '시스템': system,
                '담당자': led['owner_proposed'],
                '상태': led['status'],
                '원장판정': led['verdict'],
                '근거': led['evidence'],
                'cross': p.get('cross', {}).get(row_id, ''),
                '원장전용': 'N' if row_id in canon else 'Y',
            })
    return rows, seen


def write_tree(rows):
    path = os.path.join(HERE, 'process-tree.csv')
    cols = ['L0', 'L1', 'L2', 'process_id', 'process_name', 'step_no', 'step',
            'row_id', '기능', '시스템', '담당자', '상태', '원장판정', '근거', 'cross', '원장전용']
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)
    return path


GAP_KIND = {
    '가': '가 — 원장에 행 없음',
    '나': '나 — 행은 있는데 코드 0',
    '다': '다 — 코드는 있는데 연결 안 됨',
    '라': '라 — 결정 미정',
}


def write_gaps():
    path = os.path.join(HERE, 'gaps.csv')
    cols = ['gap_id', 'process_id', 'process_name', '대분류', '종류', '종류설명', '내용', '제안담당', '선행']
    out = []
    n = 0
    for pid in sorted(SPEC):
        p = SPEC[pid]
        for kind, text, owner, pre in p['gaps']:
            n += 1
            out.append({
                'gap_id': 'G-%s-%03d' % (CARD, n),
                'process_id': pid,
                'process_name': p['name'],
                '대분류': p['l1'],
                '종류': kind,
                '종류설명': GAP_KIND[kind],
                '내용': text,
                '제안담당': owner,
                '선행': pre,
            })
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(out)
    return path, out


def md_escape(s):
    return s.replace('|', '\\|')


def write_processes(canon, ledger, scope, seen):
    d = os.path.join(HERE, 'processes')
    os.makedirs(d, exist_ok=True)
    written = []
    for pid in sorted(SPEC):
        p = SPEC[pid]
        safe = re.sub(r'[\s/()·]+', '-', p['name']).strip('-')
        fn = '%s-%s.md' % (pid, safe)
        L = []
        L.append('# %s %s' % (pid, p['name']))
        L.append('')
        L.append('> 카드 `%s` · L1 **%s** · L2 **%s** · 기능 행 %d개' % (CARD, p['l1'], p['l2'], len(p['steps'])))
        L.append('')
        # 1
        L.append('## 1. 한줄정의 · 시작/끝 · 등장인물')
        L.append('')
        L.append('**한줄정의** — %s' % p['oneline'])
        L.append('')
        L.append('- **시작**: %s' % p['start'])
        L.append('- **끝**: %s' % p['end'])
        L.append('')
        L.append('**등장인물**')
        L.append('')
        for a in p['actors']:
            L.append('- %s' % a)
        L.append('')
        # 2
        L.append('## 2. 흐름(sequence)')
        L.append('')
        L.append('```mermaid')
        L.append(p['seq'])
        L.append('```')
        L.append('')
        # 3
        L.append('## 3. 분기(flowchart) — 실패·비회원·취소 포함')
        L.append('')
        L.append('```mermaid')
        L.append(p['flow'])
        L.append('```')
        L.append('')
        # 4
        L.append('## 4. 단계표')
        L.append('')
        L.append('| 단계 | 시스템 | 담당자 | 원장 row_id | 상태 | 근거 |')
        L.append('|---|---|---|---|---|---|')
        for label, row_id, system in p['steps']:
            led = ledger[row_id]
            ev = led['evidence'].strip() or '「미확인」'
            other = [x for x in seen[row_id] if x != pid]
            rid = '`%s`' % row_id
            if other:
                rid += ' (또한 %s)' % ', '.join(other)
            cross = p.get('cross', {}).get(row_id, '')
            if cross:
                rid += ' ↔ %s' % cross
            L.append('| %s | %s | %s | %s | %s | %s |' % (
                md_escape(label), md_escape(system), md_escape(led['owner_proposed']),
                md_escape(rid), md_escape(led['status']), md_escape(ev)))
        L.append('')
        # 5
        L.append('## 5. 빠진 곳')
        L.append('')
        L.append('| 종류 | 내용 | 제안 담당 | 선행 |')
        L.append('|---|---|---|---|')
        for kind, text, owner, pre in p['gaps']:
            L.append('| **%s** | %s | %s | %s |' % (
                md_escape(GAP_KIND[kind]), md_escape(text), md_escape(owner), md_escape(pre or '없음')))
        L.append('')
        # 6
        L.append('## 6. 채우는 방법')
        L.append('')
        for x in p['fill']:
            L.append('- %s' % x)
        L.append('')
        # 7
        L.append('## 7. 확인 못 한 것')
        L.append('')
        if p['unknown']:
            for x in p['unknown']:
                L.append('- %s' % x)
        else:
            L.append('- 없음.')
        L.append('')
        open(os.path.join(d, fn), 'w', encoding='utf-8').write('\n'.join(L))
        written.append(fn)
    return written


def write_index(rows, gaps, canon, ledger, seen):
    by_l1 = {}
    for pid in sorted(SPEC):
        p = SPEC[pid]
        by_l1.setdefault(p['l1'], []).append(pid)
    gap_by_p = {}
    for g in gaps:
        gap_by_p.setdefault(g['process_id'], []).append(g)

    data = {'l0': L0, 'card': CARD, 'l1': [], 'gapKinds': GAP_KIND}
    for l1 in ['회원·인증', '마이페이지', '프로모션', 'B2B', '운영자·회원CS']:
        procs = []
        for pid in by_l1.get(l1, []):
            p = SPEC[pid]
            steps = []
            for i, (label, row_id, system) in enumerate(p['steps'], 1):
                led = ledger[row_id]
                steps.append({
                    'no': i, 'label': label, 'row_id': row_id, 'system': system,
                    'owner': led['owner_proposed'], 'status': led['status'],
                    'evidence': led['evidence'],
                    'l2': l2_of(row_id, canon, p),
                    'also': [x for x in seen[row_id] if x != pid],
                    'cross': p.get('cross', {}).get(row_id, ''),
                })
            procs.append({
                'id': pid, 'name': p['name'], 'l2': p['l2'], 'oneline': p['oneline'],
                'start': p['start'], 'end': p['end'], 'actors': p['actors'],
                'seq': p['seq'], 'flow': p['flow'], 'steps': steps,
                'gaps': [{'kind': g['종류'], 'text': g['내용'], 'owner': g['제안담당'], 'pre': g['선행']}
                         for g in gap_by_p.get(pid, [])],
                'fill': p['fill'], 'unknown': p['unknown'],
            })
        data['l1'].append({'name': l1, 'procs': procs})

    total_rows = len(rows)
    payload = json.dumps(data, ensure_ascii=False)
    tpl = HTML_TPL.replace('__DATA__', payload)
    tpl = tpl.replace('__TOTAL__', str(total_rows))
    tpl = tpl.replace('__NPROC__', str(len(SPEC)))
    tpl = tpl.replace('__NGAP__', str(len(gaps)))
    path = os.path.join(HERE, 'index.html')
    open(path, 'w', encoding='utf-8').write(tpl)
    return path


HTML_TPL = r'''<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>t62 프로세스 나무 — 회원·혜택</title>
<style>
:root{--bg:#fbfbfd;--fg:#1d1d1f;--mut:#6e6e73;--line:#e3e3e8;--card:#fff;
--ga:#b45309;--na:#b91c1c;--da:#7c3aed;--ra:#0369a1;--acc:#4f46e5}
*{box-sizing:border-box}
body{margin:0;font:15px/1.65 -apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Noto Sans KR",sans-serif;background:var(--bg);color:var(--fg)}
header{padding:28px 20px 18px;border-bottom:1px solid var(--line);background:var(--card);position:sticky;top:0;z-index:20}
h1{margin:0 0 6px;font-size:20px;letter-spacing:-.3px}
.sub{color:var(--mut);font-size:13px}
.kpi{display:flex;gap:16px;margin-top:12px;flex-wrap:wrap}
.kpi div{background:var(--bg);border:1px solid var(--line);border-radius:10px;padding:8px 14px;font-size:13px}
.kpi b{font-size:17px;margin-right:6px}
main{max-width:1180px;margin:0 auto;padding:22px 16px 80px}
.l1{margin:26px 0 8px;font-size:16px;font-weight:700;border-left:4px solid var(--acc);padding-left:10px}
details.proc{background:var(--card);border:1px solid var(--line);border-radius:12px;margin:10px 0;overflow:hidden}
details.proc>summary{cursor:pointer;padding:14px 16px;list-style:none;display:flex;align-items:center;gap:10px;flex-wrap:wrap}
details.proc>summary::-webkit-details-marker{display:none}
.pid{font:600 12px/1 ui-monospace,SFMono-Regular,Menlo,monospace;background:#eef2ff;color:#3730a3;padding:5px 7px;border-radius:6px}
.pname{font-weight:600}
.badge{margin-left:auto;display:flex;gap:6px}
.b{font-size:11px;padding:3px 7px;border-radius:999px;border:1px solid var(--line);color:var(--mut)}
.b.rows{background:#f1f5f9}
.b.g{background:#fff7ed;color:var(--ga);border-color:#fed7aa}
.b.n{background:#fef2f2;color:var(--na);border-color:#fecaca}
.b.d{background:#f5f3ff;color:var(--da);border-color:#ddd6fe}
.b.r{background:#f0f9ff;color:var(--ra);border-color:#bae6fd}
.body{padding:0 16px 18px;border-top:1px solid var(--line)}
h3{font-size:13px;margin:18px 0 8px;color:var(--mut);text-transform:none;letter-spacing:0}
.one{margin:14px 0 4px;font-size:14px}
.se{color:var(--mut);font-size:13px}
ul{margin:6px 0;padding-left:20px}
table{border-collapse:collapse;width:100%;font-size:12.5px;margin:6px 0}
th,td{border:1px solid var(--line);padding:6px 8px;text-align:left;vertical-align:top}
th{background:#f7f7fa;font-weight:600;white-space:nowrap}
td.ev{color:var(--mut);font-size:11.5px;word-break:break-all}
code{font:12px ui-monospace,SFMono-Regular,Menlo,monospace;background:#f1f1f5;padding:1px 4px;border-radius:4px}
.kind{font-weight:700;white-space:nowrap}
.kind.가{color:var(--ga)}.kind.나{color:var(--na)}.kind.다{color:var(--da)}.kind.라{color:var(--ra)}
.mer{background:#fff;border:1px solid var(--line);border-radius:10px;padding:10px;overflow:auto}
.tree{font:12.5px/1.8 ui-monospace,SFMono-Regular,Menlo,monospace;background:var(--card);border:1px solid var(--line);border-radius:12px;padding:14px 16px;white-space:pre-wrap}
.note{background:#fffbeb;border:1px solid #fde68a;border-radius:10px;padding:10px 14px;font-size:13px;margin:14px 0}
@media (prefers-color-scheme:dark){
:root{--bg:#0f1115;--fg:#e8e8ed;--mut:#9a9aa3;--line:#2a2d35;--card:#171a21}
.pid{background:#1e1b4b;color:#c7d2fe}
th{background:#1c1f27}
code{background:#22252e}
.mer{background:#f7f7fa}
.note{background:#2a2410;border-color:#5a4a12}
.b.rows{background:#1c1f27}
}
</style>
</head>
<body>
<header>
  <h1>t62 프로세스 나무 — 회원·혜택</h1>
  <div class="sub">L0 몰 전체 → L1 대분류 → L2 중분류 → L3 프로세스 → L4 단계(기능 행). 프로세스를 펼치면 흐름·분기 그림과 단계표·빠진 곳이 나온다.</div>
  <div class="kpi">
    <div><b>__NPROC__</b>프로세스</div>
    <div><b>__TOTAL__</b>단계(기능 행 귀속)</div>
    <div><b>__NGAP__</b>빠진 곳</div>
    <div>미귀속 <b>0</b></div>
  </div>
</header>
<main>
  <div class="note">그림은 펼칠 때 그려진다. 단계표의 <b>근거</b>는 원장(t56 <code>rejudge.csv</code>)의 evidence 를 그대로 옮긴 값이다. 「없다」가 아니라 「찾지 못했다」로 적힌 항목은 코드·원장·명세를 모두 보고도 지점을 찾지 못했다는 뜻이다.</div>
  <h2 class="l1" style="border-color:#94a3b8">L0 — 몰 전체</h2>
  <div class="tree" id="tree"></div>
  <div id="root"></div>
</main>
<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
<script>
const DATA = __DATA__;
const KINDCLS = {'가':'g','나':'n','다':'d','라':'r'};
let mermaidReady = false;
try{ mermaid.initialize({startOnLoad:false, securityLevel:'loose', theme:'neutral'}); mermaidReady = true; }catch(e){}

function esc(s){return String(s==null?'':s).replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}

// L0 -> L3 나무
(function(){
  const out=[DATA.l0];
  DATA.l1.forEach(g=>{
    out.push('├─ '+g.name+'  ('+g.procs.length+' 프로세스)');
    const l2s={};
    g.procs.forEach(p=>{ (l2s[p.l2]=l2s[p.l2]||[]).push(p); });
    Object.keys(l2s).forEach(l2=>{
      out.push('│   ├─ '+l2);
      l2s[l2].forEach(p=>{
        out.push('│   │   └─ '+p.id+' '+p.name+'  · 단계 '+p.steps.length+' · 빠진 곳 '+p.gaps.length);
      });
    });
  });
  document.getElementById('tree').textContent = out.join('\n');
})();

function countKind(gaps,k){return gaps.filter(g=>g.kind===k).length;}

function procHTML(p){
  const steps = p.steps.map(s=>{
    let rid='<code>'+esc(s.row_id)+'</code>';
    if(s.also.length) rid+='<br><span class="se">또한 '+esc(s.also.join(', '))+'</span>';
    if(s.cross) rid+='<br><span class="se">↔ '+esc(s.cross)+'</span>';
    return '<tr><td>'+esc(s.label)+'</td><td>'+esc(s.system)+'</td><td>'+esc(s.owner)+'</td><td>'+rid+'</td><td>'+esc(s.status)+'</td><td class="ev">'+esc(s.evidence||'「미확인」')+'</td></tr>';
  }).join('');
  const gaps = p.gaps.length ? p.gaps.map(g=>
    '<tr><td class="kind '+esc(g.kind)+'">'+esc(g.kind)+'</td><td>'+esc(g.text)+'</td><td>'+esc(g.owner)+'</td><td>'+esc(g.pre||'없음')+'</td></tr>').join('')
    : '<tr><td colspan="4">없음</td></tr>';
  return ''+
  '<div class="body">'+
    '<div class="one"><b>한줄정의</b> — '+esc(p.oneline)+'</div>'+
    '<div class="se">시작: '+esc(p.start)+' &nbsp;·&nbsp; 끝: '+esc(p.end)+'</div>'+
    '<h3>등장인물</h3><ul>'+p.actors.map(a=>'<li>'+esc(a)+'</li>').join('')+'</ul>'+
    '<h3>2. 흐름(sequence)</h3><div class="mer" data-mer="'+esc(p.seq)+'"></div>'+
    '<h3>3. 분기(flowchart)</h3><div class="mer" data-mer="'+esc(p.flow)+'"></div>'+
    '<h3>4. 단계표</h3><table><thead><tr><th>단계</th><th>시스템</th><th>담당자</th><th>원장 row_id</th><th>상태</th><th>근거</th></tr></thead><tbody>'+steps+'</tbody></table>'+
    '<h3>5. 빠진 곳 — 가 원장에 행 없음 / 나 행은 있는데 코드 0 / 다 코드는 있는데 연결 안 됨 / 라 결정 미정</h3>'+
    '<table><thead><tr><th>종류</th><th>내용</th><th>제안 담당</th><th>선행</th></tr></thead><tbody>'+gaps+'</tbody></table>'+
    '<h3>6. 채우는 방법</h3><ul>'+p.fill.map(x=>'<li>'+esc(x)+'</li>').join('')+'</ul>'+
    '<h3>7. 확인 못 한 것</h3><ul>'+(p.unknown.length?p.unknown.map(x=>'<li>'+esc(x)+'</li>').join(''):'<li>없음.</li>')+'</ul>'+
  '</div>';
}

const root=document.getElementById('root');
DATA.l1.forEach(g=>{
  const h=document.createElement('h2'); h.className='l1';
  h.textContent='L1 — '+g.name+' ('+g.procs.length+' 프로세스)';
  root.appendChild(h);
  g.procs.forEach(p=>{
    const d=document.createElement('details'); d.className='proc';
    const badges=['<span class="b rows">단계 '+p.steps.length+'</span>'];
    ['가','나','다','라'].forEach(k=>{const n=countKind(p.gaps,k); if(n) badges.push('<span class="b '+KINDCLS[k]+'">'+k+' '+n+'</span>');});
    d.innerHTML='<summary><span class="pid">'+p.id+'</span><span class="pname">'+esc(p.name)+'</span>'+
      '<span class="se">· '+esc(p.l2)+'</span><span class="badge">'+badges.join('')+'</span></summary>'+procHTML(p);
    d.addEventListener('toggle',()=>{ if(d.open) render(d); });
    root.appendChild(d);
  });
});

let seq=0;
function render(scope){
  if(!mermaidReady) return;
  scope.querySelectorAll('.mer[data-mer]').forEach(el=>{
    const src=el.getAttribute('data-mer');
    el.removeAttribute('data-mer');
    const id='m'+(++seq);
    mermaid.render(id, src).then(r=>{el.innerHTML=r.svg;})
      .catch(e=>{el.innerHTML='<pre style="color:#b91c1c;white-space:pre-wrap">그림을 그리지 못했다 — '+esc(String(e))+'\n\n'+esc(src)+'</pre>';});
  });
}
</script>
</body>
</html>
'''


def main():
    canon, ledger, scope = load()
    rows, seen = build_tree(canon, ledger, scope)
    tree_path = write_tree(rows)
    gaps_path, gaps = write_gaps()
    files = write_processes(canon, ledger, scope, seen)
    idx = write_index(rows, gaps, canon, ledger, seen)

    covered = set(seen)
    missing = sorted(set(scope) - covered)
    print('범위 행(원장 STD-MEM/MYP/PRM/B2B/ADC) =', len(scope))
    print('프로세스 =', len(SPEC), '· 단계(귀속) =', len(rows))
    print('미귀속 =', len(missing), missing)
    print('빠진 곳 =', len(gaps))
    print('산출:', os.path.basename(tree_path), os.path.basename(gaps_path),
          os.path.basename(idx), 'processes/*.md x%d' % len(files))


if __name__ == '__main__':
    main()
