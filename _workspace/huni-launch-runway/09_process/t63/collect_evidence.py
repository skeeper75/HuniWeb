#!/usr/bin/env python3
"""선행 카드(t59/t60/t61) axis-rows.csv 의 evidence 를 row_id 별로 모으고,
path:line 이 실재하는지 파일시스템에서 직접 확인한다.
(인용하는 쪽이 직접 path:line 을 확인한다 — CONTRACT 보충 4)"""
import csv, json, os, re

BASE = '/Users/innojini/Dev/HuniWeb'
WT = os.path.join(BASE, '.claude/worktrees/t63')
SRC = os.path.join(WT, '_workspace/huni-launch-runway/08_system-screen')

PAT = re.compile(
    r'([A-Za-z0-9_./~-]+\.(?:tsx|ts|jsx|js|py|html|yml|yaml|md|json|sql|csv|txt))'
    r'(?::(\d+)(?:-(\d+))?)?')

ROOTS = [WT, BASE, '/Users/innojini/Dev',
         os.path.join(WT, '_workspace/huni-launch-runway'),
         os.path.join(WT, '_workspace')]


def resolve(p):
    """evidence 에 적힌 경로를 실제 파일로 해소한다. 실패하면 None."""
    if p.startswith('/'):
        if os.path.isfile(p):
            return p
        # 다른 워크트리를 가리키는 경로는 t63 워크트리로 되돌려 확인한다
        m = re.search(r'/\.claude/worktrees/[^/]+/(.*)$', p)
        if m:
            c = os.path.join(WT, m.group(1))
            return c if os.path.isfile(c) else None
        return None
    for r in ROOTS:
        c = os.path.normpath(os.path.join(r, p))
        if os.path.isfile(c):
            return c
    return None


def nlines(f):
    try:
        with open(f, 'rb') as fh:
            return sum(1 for _ in fh)
    except Exception:
        return 0


def main():
    ev = {}
    for f in ['t59/axis-rows.csv', 't60/axis-rows.csv', 't61/axis-rows.csv']:
        card = f.split('/')[0]
        for r in csv.DictReader(open(os.path.join(SRC, f))):
            rid = r['row_id'].strip()
            raw = (r.get('evidence') or '').strip()
            if not raw:
                continue
            for m in PAT.finditer(raw):
                p, ln = m.group(1), m.group(2)
                real = resolve(p)
                ok = bool(real)
                if ok and ln:
                    ok = int(ln) <= nlines(real)
                ev.setdefault(rid, []).append({
                    'card': card, 'path': p, 'line': ln,
                    'resolved': real, 'ok': ok})
    json.dump(ev, open(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                    'evidence-index.json'), 'w'),
              ensure_ascii=False, indent=1)
    tot = sum(len(v) for v in ev.values())
    good = sum(1 for v in ev.values() for e in v if e['ok'])
    print(f'row_id {len(ev)} · evidence 조각 {tot} · 실재확인 {good} · 미해소 {tot - good}')
    bad = sorted({e['path'] for v in ev.values() for e in v if not e['ok']})
    print(f'미해소 고유 path {len(bad)} · 표본:', bad[:12])


main()
