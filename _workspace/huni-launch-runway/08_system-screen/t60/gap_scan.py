#!/usr/bin/env python3
# t60 ㉯ — 「원장에 없는 일」 후보를 plan-rows 735행 전수 검색으로 확인한다.
# 「없다」가 아니라 「이 패턴으로 찾지 못했다」를 남기는 것이 목적이다. 읽기전용.
import csv, os, re

BASE = os.path.dirname(os.path.abspath(__file__))
plan = list(csv.DictReader(open(os.path.join(
    BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'), encoding='utf-8')))

# (후보 이름, 정규식) — title + std_ids + note 를 합쳐서 검색한다.
PROBES = [
    ('NEW-S1 허용사이트·도메인 등록 수단', r'허용\s*(사이트|도메인)|allow_domains|site[_ ]?key|사이트\s*키'),
    ('NEW-S2 handoff/verify 서버 재검증 계약', r'handoff|재검증|verify'),
    ('NEW-S3 우리가 제공할 API 정의서', r'API\s*4종|정의서|인터페이스\s*규격|API\s*계약'),
    ('NEW-S4 Edicus 파일 검수 스킵 결정', r'검수\s*스킵|편집기.*검수|Edicus.*검수|에디쿠스.*검수'),
    ('NEW-S5 구 사이트 DB 접근 확보', r'구\s*DB|구\s*사이트.*(DB|데이터|추출)|Classic\s*ASP|원천\s*데이터\s*추출'),
    ('NEW-S6 서버키 운영값 확정·배포', r'서버키|SERVER_KEY|X-Huni-Server-Key'),
    ('NEW-S7 위젯 SDK 버전·배포 규약', r'위젯.*(배포|버전|릴리스)|widget\.js|SDK\s*배포'),
    ('NEW-S8 PitStop 설치 서버(EC2 윈도우) 확보', r'EC2|윈도우\s*서버|PitStop.*서버'),
]

for name, pat in PROBES:
    rx = re.compile(pat, re.I)
    hits = [r for r in plan
            if rx.search(' '.join([r['title'], r.get('std_ids', ''), r.get('note', '') or '']))]
    print(f"\n### {name}\n  패턴: {pat}\n  적중 {len(hits)}행")
    for h in hits[:8]:
        print(f"    {h['row_id']:14} {h['owner_name']:10} {h['status']:8} {h['title'][:62]}")
    if len(hits) > 8:
        print(f"    … 외 {len(hits)-8}행")
