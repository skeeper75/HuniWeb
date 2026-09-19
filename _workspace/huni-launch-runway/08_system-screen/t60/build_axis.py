#!/usr/bin/env python3
"""t60 ㉮ — 서희항 몫 「남은 일」을 6축에 결정론으로 배분해 axis-rows.csv 를 만든다.

배분 규칙(이 파일이 규칙의 정본이다):
  1) EXPLICIT 에 row_id 가 있으면 그 축. (리드 초안 prefix 규칙이 실측과 어긋나 손으로 고친 자리)
  2) 없으면 PREFIX 규칙.
  3) 둘 다 없으면 축 '0'(미배치) — verify.py 가 0건을 강제한다.

축:
  1 위젯·가격 · 2 에디터·원고 · 3 API/SDK(huni-mall 이음매) · 4 생산연동(PitStop·MES)
  5 인프라 이전(Lightsail) · 6 webadmin 운영화면·회원/정산 이관  ← 리드 초안 5축에 없던 축(신설 제안)

읽기전용: t56/rejudge.csv · plan-rows.csv 를 열기만 한다. 원장은 수정하지 않는다.
"""
import csv, os, re, collections

BASE = os.path.dirname(os.path.abspath(__file__))
PLAN = os.path.join(BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv')
REJ = os.path.join(BASE, '..', 't56', 'rejudge.csv')
OUT = os.path.join(BASE, 'axis-rows.csv')

AXIS_NAME = {
    '1': '위젯·가격',
    '2': '에디터·원고',
    '3': 'API/SDK(huni-mall 이음매)',
    '4': '생산연동(PitStop·MES)',
    '5': '인프라 이전(Lightsail)',
    '6': 'webadmin 운영화면·회원/정산 이관',
}

# prefix 기본 배분 — 실측으로 확인된 다수 성격을 따른다.
PREFIX = {
    'STD-OPT': '1', 'STD-ADP': '1',
    'STD-ART': '2',
    'STD-SYS': '3', 'BLK-S1': '3', 'BLK-S2': '3',
    'STD-MFG': '4', 'STD-ADO': '4',
    'F1': '5', 'F2': '5', 'F3': '5', 'T1': '5',
}

# row_id 단위 예외 — 근거는 axis-notes 열에 적는다.
EXPLICIT = {
    # ① 위젯·가격
    'T2-2': '1', 'T2-3': '1',
    'STD-CAT-039': '1', 'STD-CAT-040': '1', 'STD-CAT-043': '1',
    # ② 에디터·원고 — 디자인상품(Edicus 템플릿)·편집상품 미리보기·보관함
    'STD-CAT-033': '2', 'STD-CAT-035': '2', 'STD-CAT-036': '2',
    'STD-MYP-003': '2', 'STD-MYP-030': '2', 'T2-4': '2',
    'STD-MFG-004': '2', 'STD-MFG-005': '2', 'STD-MFG-006': '2',
    'STD-MFG-008': '2', 'STD-MFG-009': '2', 'STD-MFG-064': '2',
    # ③ API/SDK — 주문 수신 계약·상태머신·웹훅·가격 브리지
    'STD-MFG-001': '3', 'STD-MFG-002': '3', 'STD-MFG-003': '3',
    'STD-MFG-022': '3', 'STD-MFG-023': '3', 'STD-MFG-024': '3',
    'STD-MFG-030': '3', 'STD-MFG-136': '3',
    'STD-PAY-013': '3', 'STD-PAY-031': '3', 'T4-2': '3',
    # ④ 생산연동
    'T4-3': '4', 'STD-ART-016': '4',
    'STD-ART-008': '4', 'STD-ART-009': '4', 'STD-ART-010': '4', 'STD-ART-011': '4',
    'STD-ART-012': '4', 'STD-ART-013': '4', 'STD-ART-014': '4', 'STD-ART-015': '4',
    # ⑤ 인프라
    'STD-SYS-017': '5',
    # ⑥ webadmin 운영화면·회원/정산 이관 — 리드 초안 5축이 덮지 않는다
    'STD-ORD-027': '6', 'STD-B2B-001': '6', 'STD-MEM-018': '6', 'STD-MEM-020': '6',
    'STD-MYP-009': '6', 'STD-ADC-004': '6', 'STD-ADC-014': '6',
    'STD-SHP-012': '6', 'STD-SHP-013': '6', 'STD-SYS-025': '6', 'STD-SYS-026': '6',
    'STD-ADO-002': '6', 'STD-ADO-003': '6', 'STD-ADO-005': '6', 'STD-ADO-008': '6',
    'STD-ADO-009': '6',
    'STD-MFG-114': '6', 'STD-MFG-123': '6', 'STD-MFG-124': '6',
    'STD-MFG-125': '6', 'STD-MFG-126': '6', 'STD-MFG-127': '6',
    'STD-MFG-128': '6', 'STD-MFG-129': '6', 'STD-MFG-007': '6', 'STD-MFG-012': '6',
    'STD-CAT-011': '6', 'STD-ADP-034': '6', 'STD-ADP-037': '6', 'STD-CAT-034': '6',
}

NOTE = {
    'STD-ADP': '리드 초안은 STD-ADP 11행을 ⑤ 인프라에 넣었으나 실측 결과 webadmin 기준정보·가격 관리화면이다(urls.py:356-360 옵션그룹·:371 제약·:144-148 단가그리드) → ①',
    'STD-CAT-033': '디자인상품 화면 구조 = Edicus 템플릿 노출 경로 → ②',
    'STD-CAT-035': 'PS코드·템플릿 경로 식별 규약 = Edicus 연결 키 → ②',
    'STD-CAT-036': '디자인 목록 API = webadmin 등록분을 독립몰이 읽는 연동이나 대상이 Edicus 템플릿 → ②',
    'STD-CAT-039': '목록 시작가 자동 계산 = 위젯 기본값 산출 → ①',
    'STD-CAT-040': '시작가가 샵바이에 반영 안 되는 원인 규명 → ①',
    'STD-CAT-043': '시작가를 GET /api/w/v1/catalog 로 이관 = huni-mall 이 부르는 계약 → ③',
    'STD-MFG-001': 'POST /api/w/v1/order/register 수신 = ③ 이음매 계약(urls.py:268)',
    'STD-MFG-136': '샵바이 웹훅 소비 = t57 이음매 ④',
    'STD-PAY-013': '서버 재계산 대조 = 가격 브리지 계약 → ③',
    'STD-PAY-031': '「10원×수량」 표시↔청구 정합 = 가격 브리지 계약 → ③',
    'T4-2': '웹훅 해석 소비자 구현(입금→PAID) → ③',
    'STD-ART-008': 'provided 판정 8행 중 하나 — PitStop 제품 제공 기능. 우리 일은 연동·확인 → ④',
    'STD-SYS-017': 'DB 백업·복구 리허설 = F2 반입과 같은 손 → ⑤',
    'STD-CAT-034': '3-way 분할(김동학 표시·최숙진 콘텐츠·서희항 자동등록 도구) 중 서희항 몫은 webadmin 등록 도구 → ⑥',
    '6': '리드 초안 5축 어디에도 들어가지 않는다 — webadmin 운영화면(주문·회원·거래처·알림)과 구 사이트 이관. 신설 제안 축.',
}


def tok(op):
    return [t.strip() for t in re.split(r'[+·]', op or '')]


def prefix(rid):
    m = re.match(r'^([A-Z]+-[A-Z0-9]+)-\d+$', rid)
    if m:
        return m.group(1)
    m = re.match(r'^([A-Z]+\d*)-', rid)
    return m.group(1) if m else rid


def axis_of(rid):
    if rid in EXPLICIT:
        return EXPLICIT[rid], NOTE.get(rid, NOTE.get(EXPLICIT[rid], ''))
    p = prefix(rid)
    return PREFIX.get(p, '0'), NOTE.get(p, '')


def main():
    plan = {r['row_id']: r for r in csv.DictReader(open(PLAN, encoding='utf-8'))}
    rej = list(csv.DictReader(open(REJ, encoding='utf-8')))
    shh = [r for r in rej if '서희항' in tok(r['owner_proposed'])]
    rem = [r for r in shh if r['remaining'] == 'Y']

    out = []
    for r in rem:
        rid = r['row_id']
        ax, note = axis_of(rid)
        pr = (plan.get(rid, {}).get('prereq') or '').strip()
        out.append({
            'axis': ax,
            'axis_name': AXIS_NAME.get(ax, '미배치'),
            'row_id': rid,
            'track': r['track'],
            'step': r['step'],
            'title': r['title'],
            'status': r['status'],
            'verdict': r['verdict'],
            'owner_proposed': r['owner_proposed'],
            'judged_by': r['judged_by'],
            'prereq': pr,
            'evidence': r['evidence'],
            'axis_note': note,
        })
    out.sort(key=lambda x: (x['axis'], x['row_id']))
    with open(OUT, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    print(f"서희항 몫 {len(shh)}행 · 남은 일 {len(rem)}행 → axis-rows.csv {len(out)}행")
    c = collections.Counter(x['axis'] for x in out)
    for a in sorted(AXIS_NAME) + (['0'] if c.get('0') else []):
        print(f"  {a} {AXIS_NAME.get(a,'미배치'):34} {c.get(a,0):3}")
    weak = collections.Counter(x['judged_by'] for x in out)
    print('근거강도(judged_by):', dict(weak))


if __name__ == '__main__':
    main()
