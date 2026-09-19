#!/usr/bin/env python3
# t66 — 네 카드 병합 산출물 생성기.
#   ① all-process-tree.csv  ② all-gaps.csv + root-causes.csv
#   ④ decisions.md  ⑤ quick-wins.md  ⑥ index.html
# journeys/*.md 는 사람이 쓴 글이라 여기서 만들지 않는다(verify.py 가 존재·형식만 본다).
import csv
import html
import json
import os
import re
import sys
import collections

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import merge_lib as M

OUT = os.path.dirname(os.path.abspath(__file__))

TRACK_NAME = {
    'T1': '인프라 이전·배포(Lightsail·DB 반입·도메인)',
    'T2': '상품·가격·위젯 데이터 충전',
    'T3': '몰 결함 수정·회원 이관',
    'T4': '주문 등록 다리·운영 변수',
    'T5': '셀러어드민 설정·알림·법정표기·증빙',
    'T6': '프린팅머니 이관·외부 계약 회신',
    'T7': '오픈 테스트·Go/No-Go',
}

TREE_COLS = ['card', 'L1_대분류', 'L2_중분류', 'process_uid', 'process_id', 'process_name',
             'step_no', 'row_id', '기능', '시스템', '담당자', '상태', '근거', 'cross', '귀속']


def build_tree():
    tree = M.merged_tree()
    rows = []
    for r in tree:
        rows.append({
            'card': r['card'], 'L1_대분류': r['L1'], 'L2_중분류': r['L2'],
            'process_uid': f"{r['card']}-{r['process_id']}",
            'process_id': r['process_id'], 'process_name': r['process_name'],
            'step_no': r['step_no'], 'row_id': r['row_id'], '기능': r['기능'],
            '시스템': r['시스템'], '담당자': r['담당자'], '상태': r['상태'],
            '근거': r['근거'], 'cross': r['cross'], '귀속': r['귀속'],
        })
    for p in sorted(M.premise_rows(tree), key=lambda x: (x['track'], x['step'], x['row_id'])):
        t = p['track']
        rows.append({
            'card': '전제', 'L1_대분류': '전제 — 일정·인프라(어느 카드에도 담당으로 안 들어간 74행)',
            'L2_중분류': f'{t} {TRACK_NAME.get(t, "")}',
            'process_uid': f'전제-{t}', 'process_id': t, 'process_name': TRACK_NAME.get(t, ''),
            'step_no': p['step'], 'row_id': p['row_id'], '기능': p['title'],
            '시스템': '', '담당자': p['owner_proposed'], '상태': p['status'],
            '근거': p['evidence'], 'cross': '', '귀속': '전제',
        })
    with open(os.path.join(OUT, 'all-process-tree.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=TREE_COLS, lineterminator='\n')
        w.writeheader()
        w.writerows(rows)
    return rows


GAP_COLS = ['gap_uid', 'card', 'process_ref', 'process_name', 'L1_대분류', '종류', '종류설명',
            '내용', '제안담당', '선행', '관련_row_id', 'root_cause_id', 'root_cause', '걸린낱말']


def build_gaps(tree_rows):
    l1_of = {}
    for r in tree_rows:
        l1_of.setdefault((r['card'], r['process_id']), r['L1_대분류'])
    gaps = M.merged_gaps()
    for g in gaps:
        rid, label, kw = M.root_cause(g)
        g['root_cause_id'] = rid
        g['root_cause'] = label
        g['걸린낱말'] = kw
        g['L1_대분류'] = l1_of.get((g['card'], g['process_ref']), '')
    with open(os.path.join(OUT, 'all-gaps.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=GAP_COLS, lineterminator='\n')
        w.writeheader()
        w.writerows(gaps)

    cnt = collections.Counter(g['root_cause_id'] for g in gaps)
    ranked = []
    for i, (rid, n) in enumerate(sorted(cnt.items(), key=lambda kv: (-kv[1], kv[0])), 1):
        sub = [g for g in gaps if g['root_cause_id'] == rid]
        ranked.append({
            '순위': i, 'root_cause_id': rid, 'root_cause': M.ROOT_LABEL[rid], '건수': n,
            '가': sum(1 for g in sub if g['종류'] == '가'), '나': sum(1 for g in sub if g['종류'] == '나'),
            '다': sum(1 for g in sub if g['종류'] == '다'), '라': sum(1 for g in sub if g['종류'] == '라'),
            '걸린_카드': '·'.join(sorted({g['card'] for g in sub})),
        })
    with open(os.path.join(OUT, 'root-causes.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['순위', 'root_cause_id', 'root_cause', '건수', '가', '나', '다', '라', '걸린_카드'],
                           lineterminator='\n')
        w.writeheader()
        w.writerows(ranked)
    return gaps, ranked


# --------------------------------------------------------------- 기존 결정 안건
DEC_DOCS = [
    ('t48/huni-mall-decisions.md', 't48 huni-mall'),
    ('t48/shopby-decisions.md', 't48 shopby'),
    ('t49/pagebuilder-decisions.md', 't49 페이지빌더'),
    ('t50/edicus-decisions.md', 't50 Edicus'),
    ('t50/pitstop-decisions.md', 't50 PitStop'),
    ('t58/widget-decisions.md', 't58 위젯'),
    ('t61/huni-mall-decisions.md', 't61 huni-mall'),
]
ROWID_RE = re.compile(r'(?:STD-[A-Z0-9]{2,4}-\d{3}|BLK-S\d+-\d+|T\d-\d+|F\d-\d+|NEW-[A-Z]\d+)')


def existing_decisions():
    """기존 결정 안건 7문서에서 plan_row_id 를 뽑아 둔다 — 같은 것은 합치기 위해서다."""
    base = os.path.join(M.RUNWAY, '08_system-screen')
    idx = collections.defaultdict(set)
    for rel, label in DEC_DOCS:
        p = os.path.join(base, rel)
        if not os.path.exists(p):
            continue
        for line in open(p, encoding='utf-8'):
            if not line.strip().startswith('|'):
                continue
            first = line.strip().strip('|').split('|')[0]
            for m in ROWID_RE.findall(first):
                idx[m].add(label)
    return idx


OWNER_FIX = [
    (r'지니', '지니'), (r'신우진', '신우진(PM)'), (r'최숙진', '최숙진'), (r'채훈희', '채훈희'),
    (r'김동학', '김동학'), (r'서희항', '서희항'), (r'외부', '외부 회신'), (r'대표', '대표'),
    (r'PM', '신우진(PM)'),
]


def owner_bucket(s):
    s = (s or '').strip()
    if not s:
        return '미정'
    out = []
    for pat, name in OWNER_FIX:
        if re.search(pat, s) and name not in out:
            out.append(name)
    return '+'.join(out) if out else s


def build_decisions(gaps, tree_rows, ranked):
    ex = existing_decisions()
    root_n = {r['root_cause_id']: r['건수'] for r in ranked}
    proc_n = collections.Counter((r['card'], r['process_id']) for r in tree_rows if r['귀속'] == '담당')

    # 「무엇이 이 결정을 기다리는가」 — 카드가 스스로 쓴 `선행` 문장에서만 센다(관측된 간선).
    prereq_ids = []
    for g in gaps:
        prereq_ids.append((g['card'], set(ROWID_RE.findall(g['선행'])),
                           set(re.findall(r'\bP\d{2}\b', g['선행']))))

    items = []
    for g in gaps:
        if g['종류'] != '라':
            continue
        ids = set(ROWID_RE.findall(g['관련_row_id'] + ' ' + g['내용'] + ' ' + g['선행']))
        hit = sorted({lab for i in ids for lab in ex.get(i, ())})
        waiting = 0
        for card2, rids2, procs2 in prereq_ids:
            if (ids & rids2) or (card2 == g['card'] and g['process_ref'] in procs2):
                waiting += 1
        items.append(dict(
            gap_uid=g['gap_uid'], card=g['card'], proc=g['process_ref'], pname=g['process_name'],
            주체=owner_bucket(g['제안담당']), 원문담당=g['제안담당'], 내용=g['내용'], 선행=g['선행'],
            rc=g['root_cause'], rc_id=g['root_cause_id'],
            기다리는것=waiting,
            같은뿌리=root_n.get(g['root_cause_id'], 0),
            프로세스담당행=proc_n.get((g['card'], g['process_ref']), 0),
            기존안건='·'.join(hit), 연결row='·'.join(sorted(ids)),
        ))

    by_owner = collections.defaultdict(list)
    for it in items:
        by_owner[it['주체']].append(it)
    for v in by_owner.values():
        v.sort(key=lambda x: (-x['기다리는것'], -x['프로세스담당행'], -x['같은뿌리'], x['gap_uid']))
    owners = sorted(by_owner, key=lambda k: (-len(by_owner[k]), k))

    L = []
    L.append('# t66 — 지니가 정해야 하는 것 105건 (「라 결정 미정」 전수)\n')
    L.append('네 카드(t62·t63·t64·t65)의 `gaps.csv` 에서 종류 **「라 — 결정 미정」** 만 뽑아 '
             '**결정 주체별**로 모으고, 그 안에서 **걸린 것이 많은 순**으로 세웠다. '
             '문장은 네 카드가 쓴 그대로이고, 이 문서가 새로 판정한 것은 없다.\n')
    L.append('**줄 세우는 기준.** ① `기다리는것` = 421건 중 **자기 `선행` 칸에 이 결정의 row_id 나 '
             '프로세스 번호를 적어 둔 줄의 수** — 네 카드가 스스로 쓴 문장에서만 셌다(관측된 간선). '
             '② `프로세스행` = 그 결정이 걸린 프로세스의 담당 기능 행 수. '
             '③ `같은뿌리` = 같은 뿌리로 묶인 빠진 곳 건수(`root-causes.csv`). '
             '①이 0이라고 아무도 안 기다린다는 뜻은 아니다 — **선행 칸에 안 적혔다는 뜻일 뿐이다.**\n')
    L.append('`기존안건` 열이 채워진 줄은 **이미 세워져 있던 결정 안건과 같은 것**이다 — '
             '새 안건이 아니라 같은 안건의 재등장이므로 그 문서에서 이어서 처리하면 된다.\n')
    L.append(f'| 결정 주체 | 건수 |\n|---|---:|')
    for o in owners:
        L.append(f'| {o} | {len(by_owner[o])} |')
    L.append(f'| **합계** | **{len(items)}** |\n')
    dup = sum(1 for it in items if it['기존안건'])
    L.append(f'기존 결정 안건 7문서(t48·t49·t50·t58·t61)와 대조한 결과 **{dup}건이 같은 안건의 재등장**이고, '
             f'**{len(items) - dup}건은 이 네 카드가 처음 세운 것**이다.\n')
    L.append('---\n')

    for o in owners:
        L.append(f'## {o} — {len(by_owner[o])}건\n')
        L.append('| # | 카드·프로세스 | 정해야 하는 것 | 뿌리 | 기다리는것 | 프로세스행 | 같은뿌리 | 선행 | 기존안건 |')
        L.append('|---:|---|---|---|---:|---:|---:|---|---|')
        for i, it in enumerate(by_owner[o], 1):
            L.append('| {} | `{}` {} {} | {} | {} | {} | {} | {} | {} | {} |'.format(
                i, it['card'], it['proc'], it['pname'],
                md_cell(it['내용']), md_cell(it['rc']),
                it['기다리는것'], it['프로세스담당행'], it['같은뿌리'],
                md_cell(it['선행']) or '—', it['기존안건'] or '—'))
        L.append('')
    with open(os.path.join(OUT, 'decisions.md'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(L))
    return items


def md_cell(s):
    return (s or '').replace('|', '\\|').replace('\n', ' ').strip()


NO_PREREQ = re.compile(r'^\s*(없음|-|—|해당\s*없음|없다)|없음\s*[—·-]|바로 착수|선행 없음')


def build_quickwins(gaps, tree_rows):
    proc_name = {}
    for r in tree_rows:
        proc_name.setdefault((r['card'], r['process_id']), r['process_name'])
    picks = []
    for g in gaps:
        if g['종류'] == '라':
            continue                      # 결정 자체는 quick-win 이 아니다
        s = g['선행'].strip()
        if s and not NO_PREREQ.search(s):
            continue
        if re.search(r'외부|회신|계약|구매|심사|스펙|승인|결정', s):
            continue
        picks.append(g)

    by_owner = collections.defaultdict(list)
    for g in picks:
        by_owner[owner_bucket(g['제안담당'])].append(g)
    owners = sorted(by_owner, key=lambda k: (-len(by_owner[k]), k))

    L = ['# t66 — 지금 바로 할 수 있는 일 (결정·외부회신 없이)\n']
    L.append('네 카드의 빠진 곳 421건 중 **선행이 비었거나 「없음 — 바로 착수 가능」이라고 적힌 것**만 골랐다. '
             '종류 「라(결정 미정)」는 성격상 제외했고, 선행 문장에 외부·회신·계약·구매·심사·스펙·승인·결정이 '
             '들어간 줄도 뺐다. **고른 규칙은 `build.py:build_quickwins` 한 곳에 있다.**\n')
    L.append(f'**{len(picks)}건** — 담당자별로 아래와 같다. 각 줄의 문장은 네 카드가 쓴 그대로다.\n')
    L.append('| 담당 | 건수 |\n|---|---:|')
    for o in owners:
        L.append(f'| {o} | {len(by_owner[o])} |')
    L.append(f'| **합계** | **{len(picks)}** |\n')
    L.append('> 주의 — 「선행이 없다」는 **그 카드가 선행 칸을 비웠다**는 뜻이다. '
             '일의 크기를 뜻하지 않고, 일정·작업량 추정은 하지 않는다.\n')
    L.append('---\n')
    for o in owners:
        L.append(f'## {o} — {len(by_owner[o])}건\n')
        L.append('| # | 카드·프로세스 | 종류 | 할 일 | 관련 row_id |')
        L.append('|---:|---|---|---|---|')
        for i, g in enumerate(by_owner[o], 1):
            pn = g['process_name'] or proc_name.get((g['card'], g['process_ref']), '')
            L.append('| {} | `{}` {} {} | {} | {} | {} |'.format(
                i, g['card'], g['process_ref'], pn, g['종류'],
                md_cell(g['내용']), md_cell(g['관련_row_id']) or '—'))
        L.append('')
    with open(os.path.join(OUT, 'quick-wins.md'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(L))
    return picks


# ----------------------------------------------------------------------- 한 화면
JOURNEYS = [
    ('J1', '비회원이 주문을 끝까지 마치는 길', 'journeys/J1-비회원-주문-종단.md'),
    ('J2', '회원 가입 → 첫 주문 → 적립·리뷰', 'journeys/J2-회원-가입-첫주문-적립.md'),
    ('J3', '주문 → 검수 → 생산 → 출고 → 배송', 'journeys/J3-주문-생산-출고-배송.md'),
    ('J4', '취소·환불', 'journeys/J4-취소-환불.md'),
    ('J5', '재제작(인쇄 불량)', 'journeys/J5-재제작.md'),
]


def build_index(tree_rows, gaps, ranked, decisions, quickwins):
    procs = collections.OrderedDict()
    for r in tree_rows:
        k = r['process_uid']
        if k not in procs:
            procs[k] = dict(card=r['card'], L1=r['L1_대분류'], L2=r['L2_중분류'],
                            pid=r['process_id'], pname=r['process_name'], n=0, cross=0)
        if r['귀속'] == '담당':
            procs[k]['n'] += 1
        elif r['귀속'] == 'cross':
            procs[k]['cross'] += 1
        elif r['귀속'] == '전제':
            procs[k]['n'] += 1
    gap_by_proc = collections.Counter(f"{g['card']}-{g['process_ref']}" for g in gaps)

    groups = collections.OrderedDict()
    for k, p in procs.items():
        groups.setdefault((p['card'], p['L1']), []).append((k, p))

    data = {
        'procs': [dict(uid=k, **v, gaps=gap_by_proc.get(k, 0)) for k, v in procs.items()],
        'roots': ranked,
        'kinds': dict(collections.Counter(g['종류'] for g in gaps)),
        'cards': dict(collections.Counter(g['card'] for g in gaps)),
    }

    rows_html = []
    for (card, l1), items in groups.items():
        tot = sum(p['n'] for _, p in items)
        unit = '행' if card == '전제' else '단계'
        rows_html.append(f'<section class="grp" data-card="{html.escape(card)}">'
                         f'<h3><span class="card c-{html.escape(card)}">{html.escape(card)}</span> '
                         f'{html.escape(l1)} <em>{len(items)} 프로세스 · {tot} {unit}</em></h3><div class="pg">')
        for k, p in items:
            g = gap_by_proc.get(k, 0)
            rows_html.append(
                f'<div class="p"><b>{html.escape(p["pid"])}</b> {html.escape(p["pname"] or p["L2"])}'
                f'<span class="m">{html.escape(p["L2"])}</span>'
                f'<span class="n">{p["n"]}{unit}</span>'
                + (f'<span class="x">cross {p["cross"]}</span>' if p['cross'] else '')
                + (f'<span class="g">빠진 곳 {g}</span>' if g else '')
                + '</div>')
        rows_html.append('</div></section>')

    root_html = ['<table class="t"><thead><tr><th>순위</th><th>뿌리</th><th>건수</th>'
                 '<th>가</th><th>나</th><th>다</th><th>라</th><th>카드</th></tr></thead><tbody>']
    for r in ranked:
        root_html.append('<tr><td>{}</td><td>{}</td><td class="b">{}</td><td>{}</td><td>{}</td>'
                         '<td>{}</td><td>{}</td><td>{}</td></tr>'.format(
                             r['순위'], html.escape(r['root_cause']), r['건수'],
                             r['가'], r['나'], r['다'], r['라'], html.escape(r['걸린_카드'])))
    root_html.append('</tbody></table>')

    dec_owner = collections.Counter(d['주체'] for d in decisions)
    dec_html = ['<table class="t"><thead><tr><th>결정 주체</th><th>건수</th></tr></thead><tbody>']
    for o, n in dec_owner.most_common():
        dec_html.append(f'<tr><td>{html.escape(o)}</td><td class="b">{n}</td></tr>')
    dec_html.append(f'<tr><td><b>합계</b></td><td class="b">{len(decisions)}</td></tr></tbody></table>')

    jour_html = []
    for jid, title, path in JOURNEYS:
        jour_html.append(f'<li><a href="{html.escape(path)}"><b>{jid}</b> {html.escape(title)}</a></li>')

    # 원장 행 기준(고유 row_id)으로 센다 — t64 는 같은 행이 두 프로세스의 단계로 두 번 등장하는 것이 있어
    # 단계 행 수(673)와 원장 행 수(661)가 다르다.
    owned = len({r['row_id'] for r in tree_rows if r['귀속'] == '담당' and r['row_id']})
    premise = len({r['row_id'] for r in tree_rows if r['귀속'] == '전제' and r['row_id']})
    steps = sum(1 for r in tree_rows if r['귀속'] == '담당')
    doc = TEMPLATE.format(
        owned=owned, premise=premise, total=owned + premise, steps=steps,
        nproc=len([p for p in procs.values() if p['card'] != '전제']),
        ngaps=len(gaps), nroots=len(ranked), ndec=len(decisions), nqw=len(quickwins),
        tree=''.join(rows_html), roots=''.join(root_html), dec=''.join(dec_html),
        jour=''.join(jour_html), data=json.dumps(data, ensure_ascii=False))
    with open(os.path.join(OUT, 'index.html'), 'w', encoding='utf-8') as f:
        f.write(doc)


TEMPLATE = '''<!doctype html>
<html lang="ko"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>t66 — 프로세스 정리 통합</title>
<style>
:root{{--bg:#fbfbfa;--fg:#1f1d1a;--mut:#6b6660;--line:#e3e0da;--card:#fff;--ac:#1a5f9e;
--t62:#7a4bb8;--t63:#1a7f5a;--t64:#b8683a;--t65:#2a6fb8;--pre:#8a8580;}}
@media (prefers-color-scheme:dark){{:root:not([data-theme=light]){{--bg:#16150f;--fg:#ece8e0;
--mut:#9a948c;--line:#33302a;--card:#1f1d18;}}}}
*{{box-sizing:border-box}}
body{{margin:0;background:var(--bg);color:var(--fg);
font:15px/1.65 -apple-system,BlinkMacSystemFont,"Pretendard","Apple SD Gothic Neo",sans-serif;}}
.wrap{{max-width:1180px;margin:0 auto;padding:32px 16px 80px}}
h1{{font-size:26px;margin:0 0 6px;letter-spacing:-.02em}}
h2{{font-size:19px;margin:44px 0 12px;padding-bottom:7px;border-bottom:2px solid var(--line)}}
h3{{font-size:15px;margin:22px 0 8px;font-weight:600}}
h3 em{{font-style:normal;color:var(--mut);font-weight:400;font-size:13px;margin-left:6px}}
.sub{{color:var(--mut);font-size:13.5px;margin:0 0 22px}}
.kpi{{display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:10px;margin:22px 0}}
.kpi div{{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:13px 14px}}
.kpi b{{display:block;font-size:24px;letter-spacing:-.02em}}
.kpi span{{color:var(--mut);font-size:12.5px}}
.card{{display:inline-block;padding:1px 7px;border-radius:5px;color:#fff;font-size:11.5px;
font-weight:700;margin-right:6px;vertical-align:1px}}
.c-t62{{background:var(--t62)}}.c-t63{{background:var(--t63)}}.c-t64{{background:var(--t64)}}
.c-t65{{background:var(--t65)}}.c-전제{{background:var(--pre)}}
.pg{{display:grid;grid-template-columns:repeat(auto-fill,minmax(270px,1fr));gap:8px}}
.p{{background:var(--card);border:1px solid var(--line);border-radius:9px;padding:9px 11px;font-size:13.5px}}
.p .m{{display:block;color:var(--mut);font-size:11.5px;margin-top:2px}}
.p span.n,.p span.x,.p span.g{{display:inline-block;font-size:11px;padding:1px 6px;border-radius:4px;
margin:5px 4px 0 0;border:1px solid var(--line);color:var(--mut)}}
.p span.g{{color:#b0421f;border-color:#e8c4b6}}
table.t{{width:100%;border-collapse:collapse;font-size:13.5px;background:var(--card);
border:1px solid var(--line);border-radius:9px;overflow:hidden}}
.t th,.t td{{padding:7px 10px;border-bottom:1px solid var(--line);text-align:left}}
.t th{{background:rgba(127,127,127,.07);font-size:12.5px;font-weight:600;white-space:nowrap}}
.t td.b{{font-weight:700}}
.t tr:last-child td{{border-bottom:0}}
.scroll{{overflow-x:auto}}
ul.j{{list-style:none;padding:0;margin:0;display:grid;
grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:8px}}
ul.j a{{display:block;background:var(--card);border:1px solid var(--line);border-radius:9px;
padding:11px 13px;color:var(--fg);text-decoration:none;font-size:13.5px}}
ul.j a:hover{{border-color:var(--ac);color:var(--ac)}}
.links a{{color:var(--ac);margin-right:14px;font-size:13.5px}}
.note{{background:var(--card);border:1px solid var(--line);border-left:3px solid var(--ac);
border-radius:0 9px 9px 0;padding:11px 14px;font-size:13.5px;color:var(--mut);margin:14px 0}}
.filter{{margin:14px 0;display:flex;gap:6px;flex-wrap:wrap}}
.filter button{{font:inherit;font-size:12.5px;padding:4px 11px;border-radius:14px;cursor:pointer;
border:1px solid var(--line);background:var(--card);color:var(--fg)}}
.filter button[aria-pressed=true]{{background:var(--fg);color:var(--bg);border-color:var(--fg)}}
</style></head><body><div class="wrap">

<h1>t66 — 프로세스 정리 통합</h1>
<p class="sub">t62 · t63 · t64 · t65 네 묶음을 하나로 합친 것. 네 카드의 내용은 고치지 않았다 — 합치기만 했다.</p>

<div class="kpi">
  <div><b>{total}</b><span>원장 735행 전수 설명</span></div>
  <div><b>{owned}</b><span>담당 기능 행(네 카드)</span></div>
  <div><b>{premise}</b><span>전제 행(어느 카드에도 없던 것)</span></div>
  <div><b>{nproc}</b><span>프로세스</span></div>
  <div><b>{steps}</b><span>단계(같은 행 재등장 포함)</span></div>
  <div><b>{ngaps}</b><span>빠진 곳</span></div>
  <div><b>{nroots}</b><span>뿌리</span></div>
  <div><b>{ndec}</b><span>정해야 할 것</span></div>
  <div><b>{nqw}</b><span>바로 할 수 있는 일</span></div>
</div>

<p class="links">각 카드로: <a href="../t62/index.html">t62</a><a href="../t63/index.html">t63</a>
<a href="../t64/index.html">t64</a><a href="../t65/index.html">t65</a>
· 표: <a href="all-process-tree.csv">all-process-tree.csv</a>
<a href="all-gaps.csv">all-gaps.csv</a><a href="root-causes.csv">root-causes.csv</a>
· 문서: <a href="decisions.md">decisions.md</a><a href="quick-wins.md">quick-wins.md</a>
<a href="verdict.md">verdict.md</a></p>

<h2>여러 묶음을 가로지르는 길</h2>
<p class="sub">한 카드 안에서는 끊기지 않는데, 카드 경계를 넘을 때 끊기는 자리가 어디인지 이어 붙인 것.</p>
<ul class="j">{jour}</ul>

<h2>전체 나무</h2>
<div class="filter" id="f">
  <button data-c="" aria-pressed="true">전부</button>
  <button data-c="t62">t62</button><button data-c="t63">t63</button>
  <button data-c="t64">t64</button><button data-c="t65">t65</button>
  <button data-c="전제">전제</button>
</div>
{tree}

<h2>빠진 곳의 뿌리 — 건수 순</h2>
<p class="sub">같은 뿌리에서 나온 것끼리 묶었다. 뿌리를 고르는 규칙표는 <code>merge_lib.py:ROOT_RULES</code>
한 곳에 있고, 걸린 낱말은 <code>all-gaps.csv</code> 의 <code>걸린낱말</code> 열에 남아 있다.</p>
<div class="scroll">{roots}</div>
<div class="note">「공통 뿌리 없음」은 규칙표에 걸리지 않았다는 뜻이지 뿌리가 없다는 뜻이 아니다 —
사람이 읽어야 하는 줄이다. 억지로 묶지 않았다.</div>

<h2>정해야 할 것 — 결정 주체별</h2>
<div class="scroll">{dec}</div>
<p class="sub">전문은 <a href="decisions.md">decisions.md</a>. 이미 세워져 있던 결정 안건(t48·t49·t50·t58·t61)과
같은 것은 그 문서를 가리키게 표시했다.</p>

<script>
const DATA = {data};
document.getElementById('f').addEventListener('click', e => {{
  const b = e.target.closest('button'); if (!b) return;
  document.querySelectorAll('#f button').forEach(x => x.setAttribute('aria-pressed', x === b));
  const c = b.dataset.c;
  document.querySelectorAll('.grp').forEach(s => {{
    s.style.display = (!c || s.dataset.card === c) ? '' : 'none';
  }});
}});
</script>
</div></body></html>
'''


def main():
    tree_rows = build_tree()
    gaps, ranked = build_gaps(tree_rows)
    decisions = build_decisions(gaps, tree_rows, ranked)
    quickwins = build_quickwins(gaps, tree_rows)
    build_index(tree_rows, gaps, ranked, decisions, quickwins)
    print('tree rows      :', len(tree_rows))
    print('  담당         :', sum(1 for r in tree_rows if r['귀속'] == '담당'))
    print('  cross        :', sum(1 for r in tree_rows if r['귀속'] == 'cross'))
    print('  단계(행없음) :', sum(1 for r in tree_rows if r['귀속'] == '단계'))
    print('  전제         :', sum(1 for r in tree_rows if r['귀속'] == '전제'))
    print('gaps           :', len(gaps), '· roots', len(ranked))
    print('decisions      :', len(decisions))
    print('quick-wins     :', len(quickwins))


if __name__ == '__main__':
    main()
