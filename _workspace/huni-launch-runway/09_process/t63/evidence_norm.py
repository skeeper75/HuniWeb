# -*- coding: utf-8 -*-
"""근거 문자열 정규화 — 실재하는 path:line 만 남긴다.

레인 조사본은 `catalog.ts:337-344` 처럼 디렉터리를 뗀 약칭을 섞어 쓴다.
그대로 실으면 「근거가 있는 것처럼 보이는데 열리지 않는」 행이 생긴다.
여기서 (1) 저장소 루트 기준으로 해소하고 (2) 해소 안 되는 조각은 버리고
(3) 하나도 안 남으면 「미확인」으로 되돌린다.
"""
import os, re
from collections import OrderedDict

BASE = '/Users/innojini/Dev/HuniWeb'
WT = os.path.join(BASE, '.claude/worktrees/t63')
ROOTS = [WT, BASE, '/Users/innojini/Dev',
         os.path.join(WT, '_workspace/huni-launch-runway'),
         os.path.join(WT, '_workspace')]
# 약칭을 붙여 볼 디렉터리 — 흔한 자리부터
HINT_DIRS = [
    '/Users/innojini/Dev/huni-skin-shopby/src/lib/api/server',
    '/Users/innojini/Dev/huni-skin-shopby/src/lib/api',
    '/Users/innojini/Dev/huni-skin-shopby/src/lib/hooks',
    '/Users/innojini/Dev/huni-skin-shopby/src/lib',
    '/Users/innojini/Dev/huni-skin-shopby/src/components/shop',
    '/Users/innojini/Dev/huni-skin-shopby/src/components/product',
    '/Users/innojini/Dev/huni-skin-shopby/src/components/cart',
    '/Users/innojini/Dev/huni-skin-shopby/src/components/layout',
    '/Users/innojini/Dev/huni-skin-shopby/src/components',
]
PAT = re.compile(
    r'([A-Za-z0-9_()./~-]+\.(?:tsx|ts|jsx|js|py|html|yml|yaml|md|json|sql|csv|txt))'
    r'(?::(\d+)(?:-(\d+))?)?')

_cache = {}


def _nlines(f):
    if f not in _cache:
        with open(f, 'rb') as fh:
            _cache[f] = sum(1 for _ in fh)
    return _cache[f]


def _find(p):
    """경로 조각을 실제 파일로 해소한다. 실패하면 None."""
    if p.startswith('/'):
        return p if os.path.isfile(p) else None
    for r in ROOTS:
        c = os.path.normpath(os.path.join(r, p))
        if os.path.isfile(c):
            return c
    if '/' not in p:  # 디렉터리를 뗀 약칭 — 흔한 자리에 붙여 본다
        for d in HINT_DIRS:
            c = os.path.join(d, p)
            if os.path.isfile(c):
                return os.path.relpath(c, '/Users/innojini/Dev')
    return None


def normalize(raw):
    """(정규화된 근거 문자열, 살아남은 조각 수, 버린 조각 수) 를 돌려준다."""
    kept, dropped = OrderedDict(), 0
    for m in PAT.finditer(raw or ''):
        p, ln = m.group(1), m.group(2)
        real = _find(p)
        if not real:
            dropped += 1
            continue
        full = real if real.startswith('/') else real
        disk = full if full.startswith('/') else os.path.join('/Users/innojini/Dev', full)
        if ln and int(ln) > _nlines(disk if os.path.isfile(disk) else full):
            dropped += 1
            continue
        shown = full
        if shown.startswith(WT + '/'):
            shown = shown[len(WT) + 1:]
        elif shown.startswith(BASE + '/'):
            shown = shown[len(BASE) + 1:]
        elif shown.startswith('/Users/innojini/Dev/'):
            shown = shown[len('/Users/innojini/Dev/'):]
        kept[shown + (f':{m.group(2)}' + (f'-{m.group(3)}' if m.group(3) else '')
                      if ln else '')] = 1
    return ' · '.join(kept), len(kept), dropped
