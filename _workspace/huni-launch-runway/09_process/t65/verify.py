# -*- coding: utf-8 -*-
"""t65 검증 — 산출물을 원천에서 독립적으로 다시 읽어 게이트를 판정한다.

build.py 의 메모리 구조도 spec_*.py 도 쓰지 않는다. 디스크에 쓰인 산출물과
원천(canon·원장)만 읽는다. 생성≠검증.
"""
import csv
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RUNWAY = os.path.abspath(os.path.join(HERE, '..', '..'))
CANON = os.path.join(RUNWAY, '07_rebaseline/L1/standard-feature-canon.csv')
LEDGER = os.path.join(RUNWAY, '08_system-screen/t56/rejudge.csv')

PREFIXES = {'STD-CLM', 'STD-ADP', 'STD-FIN', 'STD-INF', 'STD-SYS'}
L1S = {'클레임·CS', '정보·콘텐츠', '운영자·상품가격', '정산·통계', '시스템·플랫폼'}
KINDS = {'가', '나', '다', '라'}
SECTIONS = ['## 1. 한줄정의', '## 2. 흐름', '## 3. 분기', '## 4. 단계표',
            '## 5. 빠진 곳', '## 6. 채우는 방법', '## 7. 확인 못 한 것']
SCOPE_N = 151

results = []


def gate(gid, title, ok, detail):
    results.append((gid, title, 'PASS' if ok else 'FAIL', detail))
    return ok


def prefix_of(i):
    return i.rsplit('-', 1)[0] if re.match(r'^[A-Z0-9]+-.+-\d+$', i) else None


def main():
    canon = {r['std_id']: r for r in csv.DictReader(open(CANON, encoding='utf-8'))}
    ledger = {r['row_id']: r for r in csv.DictReader(open(LEDGER, encoding='utf-8'))}
    scope = {k for k in ledger if prefix_of(k) in PREFIXES}
    canon_scope = {k for k in canon if prefix_of(k) in PREFIXES}

    tree = list(csv.DictReader(open(os.path.join(HERE, 'process-tree.csv'), encoding='utf-8')))
    gaps = list(csv.DictReader(open(os.path.join(HERE, 'gaps.csv'), encoding='utf-8')))
    pdir = os.path.join(HERE, 'processes')
    mds = sorted(f for f in os.listdir(pdir) if f.endswith('.md'))
    idx = open(os.path.join(HERE, 'index.html'), encoding='utf-8').read()

    # V1 — 분모: 기능목록 정본(대분류 범위)이 원장 범위에 전부 들어 있다
    missing_canon = sorted(canon_scope - scope)
    gate('V1', '분모 확정 — canon %d행이 원장 %d행에 모두 포함' % (len(canon_scope), len(scope)),
         not missing_canon and len(scope) == SCOPE_N,
         '원장 범위 %d · canon 범위 %d · canon-only %d %s' % (
             len(scope), len(canon_scope), len(missing_canon), missing_canon))

    # V2 — 미귀속 0 (카드가 지정한 게이트)
    covered = {r['row_id'] for r in tree}
    unassigned = sorted(scope - covered)
    gate('V2', '미귀속 0 — 담당 범위의 모든 기능 행이 1개 이상 프로세스에 귀속',
         not unassigned, '귀속 %d/%d · 미귀속 %d %s' % (len(covered), len(scope), len(unassigned), unassigned))

    # V3 — 범위 밖 행이 섞이지 않았다 + 원장에 없는 행을 새로 만들지 않았다
    #      (T·F 일정/인프라 행은 전제로만 쓰고 단계로 넣지 않는다)
    outside = sorted(covered - scope)
    nonstd = sorted(r['row_id'] for r in tree if prefix_of(r['row_id']) not in PREFIXES)
    gate('V3', '범위 밖·신설 행 0 — 735행 원장에 새 행을 섞지 않았다 · T/F 행 단계 편입 0',
         not outside and not nonstd,
         '범위 밖 %d %s · 비STD 접두 %d %s' % (len(outside), outside[:5], len(nonstd), nonstd[:5]))

    # V4 — 프로세스 md 7절 전수
    bad = []
    for f in mds:
        t = open(os.path.join(pdir, f), encoding='utf-8').read()
        miss = [s for s in SECTIONS if s not in t]
        if miss:
            bad.append((f, miss))
    gate('V4', '프로세스 문서 고정 7절 전수(%d개 파일)' % len(mds), not bad, '결손 %d %s' % (len(bad), bad[:3]))

    # V5 — 파일마다 mermaid 2개(sequence + flowchart)
    bad = []
    for f in mds:
        t = open(os.path.join(pdir, f), encoding='utf-8').read()
        n = t.count('```mermaid')
        if n != 2 or 'sequenceDiagram' not in t or 'flowchart' not in t:
            bad.append((f, n, 'sequenceDiagram' in t, 'flowchart' in t))
    gate('V5', 'mermaid sequence + flowchart 각 1개', not bad, '결손 %d %s' % (len(bad), bad[:3]))

    # V6 — 단계표의 근거가 전수 채워져 있다(빈칸 금지 · 「미확인」 허용)
    empty = [r['row_id'] for r in tree if not r['근거'].strip()]
    gate('V6', '단계표 근거 전수 — 빈칸 0(「미확인」은 허용)', not empty, '빈칸 %d %s' % (len(empty), empty[:5]))

    # V7 — 근거가 원장 evidence 와 한 글자도 다르지 않다(전사 오류 방지)
    drift = [r['row_id'] for r in tree if r['근거'] != ledger[r['row_id']]['evidence']]
    gate('V7', '근거 원문 일치 — 원장 evidence 를 그대로 옮겼다', not drift, '불일치 %d %s' % (len(drift), drift[:5]))

    # V8 — 담당자가 원장 owner_proposed 와 일치(임의 재배정 금지)
    odrift = [r['row_id'] for r in tree if r['담당자'] != ledger[r['row_id']]['owner_proposed']]
    gate('V8', '담당자 = 원장 owner_proposed (임의 재배정 0)', not odrift, '불일치 %d %s' % (len(odrift), odrift[:5]))

    # V9 — L1 대분류가 5종 안에만 있다
    l1s = {r['L1'] for r in tree}
    gate('V9', 'L1 대분류 5종 고정', l1s <= L1S and l1s == L1S, '관측 %s' % sorted(l1s))

    # V10 — gaps.csv 종류가 4종 안 · 프로세스가 실재
    pids = {r['process_id'] for r in tree}
    bad_kind = sorted({g['종류'] for g in gaps} - KINDS)
    bad_pid = sorted({g['process_id'] for g in gaps} - pids)
    gate('V10', 'gaps 4종 분류 · 프로세스 실재', not bad_kind and not bad_pid,
         '종류 위반 %d · 미지 프로세스 %d · 총 %d건' % (len(bad_kind), len(bad_pid), len(gaps)))

    # V11 — index.html 에 모든 프로세스가 실려 있다
    miss = sorted(p for p in pids if 'id="%s"' % p not in idx)
    gate('V11', 'index.html 프로세스 전수 수록(%d)' % len(pids), not miss, '누락 %s' % miss)

    # V12 — 프로세스마다 단계 1개 이상 · 빠진 곳 1개 이상
    cnt, gcnt = {}, {}
    for r in tree:
        cnt[r['process_id']] = cnt.get(r['process_id'], 0) + 1
    for g in gaps:
        gcnt[g['process_id']] = gcnt.get(g['process_id'], 0) + 1
    thin = sorted(p for p in pids if cnt.get(p, 0) < 1)
    nogap = sorted(p for p in pids if gcnt.get(p, 0) < 1)
    gate('V12', '프로세스별 단계 ≥1 · 빠진 곳 ≥1', not thin and not nogap,
         '단계 0 %s · 빠진 곳 0 %s' % (thin, nogap))

    # V13 — 「없다」 단정 금지 + 7절이 실제로 확인 범위를 밝힌다
    bad = []
    for f in mds:
        t = open(os.path.join(pdir, f), encoding='utf-8').read()
        for m in re.finditer(r'(코드가 없다|API 가 없다|어디에도 없다(?! —))', t):
            bad.append((f, m.group(0)))
        tail = t.split('## 7. 확인 못 한 것', 1)[-1]
        if not re.search(r'(확인하지 못했|찾지 못했|보지 못했|세지 못했|대조하지 못했|'
                         r'열어보지 않았|따라가지 않았|않았다|못했다)', tail):
            bad.append((f, '7절이 확인 범위를 밝히지 않음'))
    gate('V13', '「없다」 단정 금지 · 7절 확인 범위 명시', not bad, '적발 %d %s' % (len(bad), bad[:3]))

    print('== t65 verify ==')
    fails = 0
    for gid, title, verdict, detail in results:
        if verdict == 'FAIL':
            fails += 1
        print('%-4s %-6s %s' % (gid, verdict, title))
        print('        %s' % detail)
    print('---')
    print('PASS %d / FAIL %d' % (len(results) - fails, fails))
    json.dump([{'gate': g, 'title': t, 'verdict': v, 'detail': d} for g, t, v, d in results],
              open(os.path.join(HERE, 'verify-result.json'), 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)
    return 1 if fails else 0


if __name__ == '__main__':
    sys.exit(main())
