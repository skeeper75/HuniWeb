#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""t63 게이트 검산 — 산출물이 카드 요건을 지켰는지 기계로 확인한다.

게이트
  G1 미귀속 0        담당 201행이 전부 1개 이상 프로세스에 귀속
  G2 나무 정합       process-tree.csv 행수 = 원장 단계 + 원장 없는 단계
  G3 문서 7절        프로세스마다 md 가 있고 고정 7절을 다 갖춤
  G4 그림 2종        md 마다 mermaid sequenceDiagram 1 + flowchart 1
  G5 갭 4종          gaps.csv 종류가 가·나·다·라 넷뿐
  G6 근거 실재       단계표에 적힌 path:line 이 실제 파일·줄로 해소됨
  G7 경계 분리       t64 경계 행이 담당 범위와 겹치지 않음
  G8 화면            index.html 에 프로세스 pane 이 전부 있음
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import processes_def as D

BASE = '/Users/innojini/Dev/HuniWeb'
WT = os.path.join(BASE, '.claude/worktrees/t63')
ROOTS = [WT, BASE, '/Users/innojini/Dev',
         os.path.join(WT, '_workspace/huni-launch-runway'),
         os.path.join(WT, '_workspace')]
PATH_PAT = re.compile(
    r'([A-Za-z0-9_./~-]+\.(?:tsx|ts|jsx|js|py|html|yml|yaml|md|json|sql|csv|txt))'
    r'(?::(\d+))?')
SECTIONS = ['## 1. 한줄정의', '## 2. 흐름', '## 3. 갈림길', '## 4. 단계표',
            '## 5. 빠진 곳', '## 6. 채우는 방법', '## 7. 확인 못 한 것']

fails = []


def gate(name, ok, detail):
    print(f"{'PASS' if ok else 'FAIL'}  {name}  {detail}")
    if not ok:
        fails.append(name)


def resolve(p):
    if p.startswith('/'):
        return p if os.path.isfile(p) else None
    for r in ROOTS:
        c = os.path.normpath(os.path.join(r, p))
        if os.path.isfile(c):
            return c
    return None


def nlines(f):
    with open(f, 'rb') as fh:
        return sum(1 for _ in fh)


def main():
    scope = [r['row_id'] for r in csv.DictReader(open(os.path.join(HERE, 'scope.csv')))]
    tree = list(csv.DictReader(open(os.path.join(HERE, 'process-tree.csv'))))
    gaps = list(csv.DictReader(open(os.path.join(HERE, 'gaps.csv'))))

    # G1
    assigned = {r['row_id'] for r in tree if r['row_id']}
    miss = [s for s in scope if s not in assigned]
    gate('G1 미귀속 0', not miss,
         f'담당 {len(scope)}행 · 귀속 {len(assigned)} · 미귀속 {len(miss)}'
         + (f' {miss[:5]}' if miss else ''))

    # G2
    want = sum(len(p['rows']) + len(p['extra']) for p in D.PROCESSES)
    gate('G2 나무 정합', len(tree) == want,
         f'process-tree.csv {len(tree)}행 · 정의상 {want}행')

    # G3 · G4
    bad3, bad4 = [], []
    for p in D.PROCESSES:
        fn = f"{p['id']}-{p['name'].replace(' ', '-').replace('·', '-')}.md"
        fp = os.path.join(HERE, 'processes', fn)
        if not os.path.isfile(fp):
            bad3.append(p['id'] + '(파일없음)')
            continue
        t = open(fp).read()
        if any(s not in t for s in SECTIONS):
            bad3.append(p['id'])
        if t.count('```mermaid') != 2 or 'sequenceDiagram' not in t \
                or 'flowchart' not in t:
            bad4.append(p['id'])
    gate('G3 문서 7절', not bad3, f'{len(D.PROCESSES)}개 문서 · 결함 {bad3 or "없음"}')
    gate('G4 그림 2종', not bad4, f'결함 {bad4 or "없음"}')

    # G5
    kinds = sorted({g['종류'] for g in gaps})
    want_k = ['가 원장에 행 없음', '나 행은 있는데 코드 0',
              '다 코드는 있는데 연결 안 됨', '라 결정 미정']
    gate('G5 갭 4종', set(kinds) <= set(want_k),
         f'{len(gaps)}건 · 종류 {kinds}')

    # G6 — 단계표 근거의 path:line 전수 해소
    tot = ok = 0
    bad = []
    for r in tree:
        b = r['근거']
        if '미확인' in b:
            continue
        for m in PATH_PAT.finditer(b):
            tot += 1
            f = resolve(m.group(1))
            good = bool(f) and (not m.group(2) or int(m.group(2)) <= nlines(f))
            if good:
                ok += 1
            else:
                bad.append(f"{r['row_id']}:{m.group(0)}")
    gate('G6 근거 실재', tot == ok,
         f'path:line {tot}조각 중 실재 {ok} · 미해소 {len(bad)}'
         + (f' 표본 {bad[:5]}' if bad else ''))

    # G7
    bnd = [r['row_id'] for r in csv.DictReader(
        open(os.path.join(HERE, 'boundary-t64.csv')))]
    overlap = set(bnd) & set(scope)
    gate('G7 경계 분리', not overlap,
         f't64 경계 {len(bnd)}행 · 담당과 겹침 {len(overlap)}')

    # G8
    h = open(os.path.join(HERE, 'index.html')).read()
    missing = [p['id'] for p in D.PROCESSES if f'id="{p["id"]}"' not in h]
    gate('G8 화면', not missing,
         f'pane {len(D.PROCESSES) - len(missing)}/{len(D.PROCESSES)}')

    print()
    print('판정:', 'PASS — 게이트 전부 통과' if not fails else f'FAIL — {fails}')
    return 1 if fails else 0


sys.exit(main())
