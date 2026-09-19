#!/usr/bin/env python3
# t56 — plan-rows 735행 evidence 시그널 집계(읽기전용 탐색 보조)
import csv, collections, re, sys, os

BASE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PLAN = os.path.join(BASE, '07_rebaseline/S/S5-plan/plan-rows.csv')

PATS = {
    'skin': r'huni-skin-shopby|huni-skin-next|스킨',
    'webadmin': r'raw/webadmin|webadmin',
    'selleradmin': r'service\.shopby\.co\.kr|셀러어드민',
    'livemall': r'shopby\.huniprinting\.co\.kr',
    'widget': r'위젯|widget',
    'mes': r'TS\.BackOffice|MES',
    'edicus': r'[Ee]dicus|편집기',
    'pitstop': r'[Pp]it[Ss]top|PITSTOP',
    'doconly': r'\.md|\.csv|\.xlsx|\.html|\.pdf|\.json',
}


def sigs(text):
    return tuple(sorted(k for k, p in PATS.items() if re.search(p, text)))


def load():
    with open(PLAN, encoding='utf-8') as f:
        return list(csv.DictReader(f))


if __name__ == '__main__':
    rows = load()
    c = collections.Counter()
    for r in rows:
        c[(r['owner_name'], sigs(r['evidence'] + ' ' + r['title']))] += 1
    for k, v in sorted(c.items(), key=lambda x: -x[1])[:70]:
        print(v, k)
