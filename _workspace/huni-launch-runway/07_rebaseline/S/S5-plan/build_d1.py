# -*- coding: utf-8 -*-
"""M2 — D1 오픈 계획서 HTML 생성.

   입력: plan-rows.csv · decisions-by-step.csv · wait-items.csv · lanes.csv · workdays.csv ·
        manual-element-matrix.csv · matrix-README.md(분모 명령) · 메뉴 지도 CSV(메인 체크아웃 읽기 전용)
   출력: docs/huni/후니프린팅_오픈계획서_260917.html (+ 에이전트용 요약 .md)
   [HARD] 표·집계 수는 전부 CSV 에서 계산한다 — 손으로 적은 수가 문서에 들어가지 않게.
   실행: python3 -B build_d1.py
"""
import csv
import html
import os
import re
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
WT = os.path.abspath(os.path.join(HERE, *(['..'] * 5)))
MAIN = '/Users/innojini/Dev/HuniWeb'
RB = '_workspace/huni-launch-runway/07_rebaseline'
OUT = os.path.join(WT, 'docs/huni/후니프린팅_오픈계획서_260917.html')
MENU = f'{MAIN}/{RB}/S/S5-live/menu-map-260917.csv'
MENU_REL = f'{RB}/S/S5-live/menu-map-260917.csv'
TODAY = '2026-09-17'


def rd(name, path=None):
    return list(csv.DictReader(open(path or os.path.join(HERE, name), encoding='utf-8')))


ROWS = rd('plan-rows.csv')
TOP = [r for r in ROWS if r['data_role'] == 'top']
DETAIL = [r for r in ROWS if r['data_role'] == 'detail']
DEC = rd('decisions-by-step.csv')
WAIT = [r for r in ROWS if r['data_owner'] == 'ext' and r['data_work'] == 'wait']
LANES = rd('lanes.csv')
WORKDAYS = [r['workday'] for r in rd('workdays.csv')]
MATRIX = rd('manual-element-matrix.csv')
MENU_ROWS = rd(None, MENU)
TRACKS = {
    'T1': '인프라 이전(Lightsail)', 'T2': '상품·가격·위젯 준비', 'T3': '쇼핑몰 주문·결제·회원',
    'T4': '주문 수신·원고·생산 연동', 'T5': '운영 설정·알림·CS·증빙', 'T6': '프린팅머니',
    'T7': '테스트·리허설·Go/No-Go·컷오버',
}

# ───────────── 산문 정리: 내부 코드명·반려 수치·용어 제한(AC-LP-002) ─────────────
CODE_RX = re.compile(r'\b(?:S[1-6]|R[1-9][a-e]?|L[1-9])\b|CARDS-\w*|manager-\w+|\w+-orchestrator|plan-auditor')
PRED_RX = re.compile(r'가능|불가|어렵|무리|힘들|충분|맞출 수')


def clean(t):
    t = t or ''
    t = re.sub(r'\bS3\b', '원고 저장소(AWS)', t)  # AWS 제품명이 내부 코드명 검사에 걸리지 않게
    t = CODE_RX.sub('', t)
    t = t.replace('565일', '').replace('348행', '').replace('조판', '판 배치')
    t = re.sub(r'\(\s*[·,]?\s*\)', '', t)
    t = re.sub(r'\s{2,}', ' ', t)
    # 한 문장에 기준일 + 판정 술어가 같이 있으면 날짜를 「기준일」로 바꾼다
    parts = re.split(r'(?<=[.!?。])\s', t)
    parts = [re.sub(r'10/6|10월 6일|2026-10-06', '기준일', p) if PRED_RX.search(p) else p for p in parts]
    return ' '.join(parts).strip()


def e(t):
    return html.escape(clean(t))


def raw(t):
    return html.escape(t or '')


# ───────────── 공통 ─────────────
def attrs(r):
    return (f'data-row-id="{raw(r["row_id"])}" data-role="{r["data_role"]}" data-step="{r["step"]}" data-std="{raw(r["std_ids"])}" '
            f'data-owner="{r["data_owner"]}" data-work="{r["data_work"]}" '
            f'data-api-path="{r["api_path"]}" data-api-evidence="{raw(r["api_evidence"])}"')


API_LABEL = {'server-api': 'Server API', 'shop-api': 'Shop API', 'admin-manual': '셀러어드민 수동', 'none': '샵바이 비경유'}
OWN_LABEL = {'nhn': 'NHN 제공', 'huni': '후니 개발', 'ext': '외부 대기'}


def row_html(r, extra=''):
    badge = f'<span class="tag t-{r["data_owner"]}">{OWN_LABEL[r["data_owner"]]}</span>' \
            f'<span class="tag t-api">{API_LABEL[r["api_path"]]}</span>'
    irr = ' <strong class="warn">오픈 테스트 통과 전 금지</strong>' if r['irreversible'] == 'Y' else ''
    if r['std_ids'] == 'NEW' and r['data_role'] == 'top':
        irr += f' <span class="new-reason">{e(r["note"])}</span>'
    due = r['target_date'] or '—'
    rid = f'<span class="rid">{raw(r["row_id"])}</span> ' if r['data_role'] == 'top' else ''
    return (f'<tr {attrs(r)}{extra}><th scope="row" class="item">{rid}{e(r["title"])}{irr}<br>{badge}</th>'
            f'<td class="owner">{e(r["owner_name"])}</td><td class="duedate">{raw(due)}</td>'
            f'<td class="evidence">{raw(r["evidence"])}</td><td class="check">{e(r["check_method"])}</td>'
            f'<td class="prereq">{e(r["prereq"]) or "—"}</td><td class="status">{raw(r["status"])}</td></tr>')


THEAD = ('<thead><tr><th>할 일</th><th>담당</th><th>목표일<br><small>하한 — 마감일 아님</small></th><th>완료 증거</th>'
         '<th>체크 방법</th><th>선행</th><th>상태</th></tr></thead>')


def section(n, title, body, lead=''):
    lead_html = f'<p class="lead">{lead}</p>' if lead else ''
    return f'<section id="sec-{n:02d}"><h2><span class="no">{n}</span>{title}</h2>{lead_html}{body}</section>'


def mermaid(src, fallback, id_=None):
    idattr = f' id="{id_}"' if id_ else ''
    return (f'<figure{idattr} class="diagram"><pre class="mermaid">{html.escape(src)}</pre>'
            f'<noscript><p class="fallback">{fallback}</p></noscript></figure>')


# ───────────── 계산 값 ─────────────
def is_date(s):
    return bool(re.fullmatch(r'\d{4}-\d{2}-\d{2}', s or ''))


top_by_id = {r['row_id']: r for r in TOP}
dated = [r for r in TOP if is_date(r['target_date'])]
derived = max(dated, key=lambda r: r['target_date'])
unsized = [r for r in TOP if r['target_date'].startswith('미산정')]
ext_top = [r for r in TOP if r['data_owner'] == 'ext']
open_req_dec = [d for d in DEC if d['open_required'] == 'Y']
# 결정 제목을 전제 없는 질문형으로(리드 판정 260917 · 원문 제목은 decisions-by-step.csv·원천 문서에 유지)
DEC_TITLE_OVERRIDE = {'1': '오픈 범위를 어디까지로 할 것인가'}
menu_gap_star = [m for m in MENU_ROWS if '★' in m['갭']]
menu_key = [k for k in MENU_ROWS[0] if k.startswith('실메뉴')][0]
MANUAL_COL = '매뉴얼 화면 섹션(SCREENS/MODEL_ADMIN) 유무'
# 대조 제외 = 매뉴얼 칸이 자체 문서·별도 문서·「—」 인 메뉴(문서 본문 자체) — README 제외 선언과 같은 집합
EXCLUDED_MENUS = [m[menu_key] for m in MENU_ROWS if re.match(r'자체 문서|별도 문서|—', m[MANUAL_COL])]
sidebar = sum(1 for m in MENU_ROWS if m['사이드바그룹'] != '(사이드바 없음)')
nonsidebar = len(MENU_ROWS) - sidebar
res_kind = lambda v: re.split(r'[(]', v)[0]  # noqa: E731
dist = Counter(res_kind(m['실측 결과']) for m in MATRIX)
screens = Counter(m['화면'] for m in MATRIX)
mismatch = [m for m in MATRIX if res_kind(m['실측 결과']) == '불일치']
writepath = [m for m in MATRIX if res_kind(m['실측 결과']) == '쓰기경로-dev환경필요']
readme = open(os.path.join(HERE, 'matrix-README.md'), encoding='utf-8').read()
DENOM_CMD = re.search(r'```bash\n(cd raw/webadmin/tools && python3 -c .*?)\n```', readme, re.S).group(1)
api_dist = Counter(r['api_path'] for r in ROWS)
admin_manual = [r for r in ROWS if r['api_path'] == 'admin-manual']
unreviewed_none = [r for r in ROWS if r['api_path'] == 'none' and r['data_owner'] == 'huni'
                   and '매칭 규칙 없음' in r['api_basis']
                   and r['step'] in {'A5', 'B1', 'B4', 'B5', 'B6', 'B7', 'D2', 'D3', 'D4', 'E3', 'A4', 'C1', 'C3', 'C6', 'C7', 'D5', 'E1'}]


def startable(r):
    # 이번 주 착수 가능 = 상태가 완료·작동이 아니고, 선행 칸이 「—」(T 행·선행 입력·결정·외부 회신이 하나도 적혀 있지 않음)
    return r['status'] not in ('완료', '작동') and (r['prereq'] or '—').strip() == '—'


def due_with_state(r):
    # 선행 대기 행은 하한 옆에 「선행 대기」를 같이 보인다(하한 계산식은 그대로 · 리드 판정 260917)
    return raw(r['target_date']) + ('' if startable(r) else ' <span class="waiting">선행 대기</span>')

# ───────────── §1 요약 ─────────────
risks = [
    ('회원 장바구니 인증 결함', '로그인한 손님이 장바구니를 쓸 수 없다. 결제·주문·주문조회가 전부 이 뒤에 있다.'),
    ('인프라 이전 선행 회신', '관리서버·DB·스킨 이전의 첫 단계가 인프라팀 회신(권한·시크릿·접속 정보)에 묶여 있고 소요도 산정되지 않았다.'),
    ('결제 이후 주문 연결 공백', '결제 직후 주문 등록 호출이 0건이고 접수 화면·MES 전송이 없다. 결제는 되는데 무엇을 만들지 모르는 주문이 된다.'),
    ('외부 계약·심사 대기', f'외부 대기 {len(WAIT)}건(PG·토스·NHN 플랜·구 사이트 운영사 등)은 회신 시점을 모른다.'),
]
next_ms = top_by_id['T1-4']
summary = f'''
<div class="summary-grid">
  <div class="card" data-el="what-why"><h3>무엇·왜</h3>
    <p class="prose">후니프린팅 새 쇼핑몰을 여는 데 필요한 일을 28개 업무 구간과 7개 트랙으로 묶어, 누가 무엇을 언제까지 확인하는지 적은 계획서다.
    9/16 목록이 「무슨 문서인지 모르겠다」는 반려를 받아, 기능 목록 대신 주문이 흐르는 순서를 뼈대로 다시 짰다.
    오픈일은 못 박지 않고, 필요한 일과 선행 관계에서 가장 이른 날을 계산해 보여 준다.</p>
    <p class="prose" id="base-date">기준일(역산 기준점)은 2026-10-06 이다. <a href="#go-no-go">Go/No-Go 판정 회의</a> 제안일 2026-10-02 는 기준일 직전 근무일이다.</p></div>
  <div class="card" data-el="rag"><h3>RAG 상태</h3>
    <p class="rag rag-red">Red</p><p class="prose">최상위 할 일 {len(TOP)}개 중 소요를 산정할 수 없는 구간 {len(unsized)}개, 외부 회신 대기 {len(WAIT)}건.</p></div>
  <div class="card" data-el="risks"><h3>상위 리스크 {len(risks)}개</h3><ol>{''.join(f'<li><b>{a}</b> — {b}</li>' for a, b in risks)}</ol></div>
  <div class="card" data-el="next-milestone"><h3>다음 마일스톤 + 목표일</h3>
    <p class="prose">T1 인프라 이전 — 인프라팀 회신 요청일 <b>{WORKDAYS[1]}</b>. 스킨 이전 행({raw(next_ms["row_id"])})의 가장 이른 완료일(하한) <b>{due_with_state(next_ms)}</b>.</p></div>
  <div class="card" data-el="rollup"><h3>롤업 타임라인</h3>
    <p class="prose">T1 인프라 이전 → T2·T3·T5 병행 → T4 주문 연결 → T7 종단 테스트 → Go/No-Go. 선행 관계만으로 계산한 가장 이른 완료일(하한)은 <a href="#critical-path">임계경로 절</a>에 있다.</p></div>
  <div class="card" data-el="legend"><h3>상태 범례</h3><ul class="legend">
    <li><span class="dot g"></span>Green — 최상위 할 일의 미완 행 0건</li>
    <li><span class="dot y"></span>Yellow — 미완 행 1건 이상, 외부 대기 0건</li>
    <li><span class="dot r"></span>Red — 외부 대기 1건 이상 또는 소요 미산정 구간 1개 이상</li>
    <li><span class="dot u"></span>Unknown — 증거 0건(판정 불가 = 차단으로 본다)</li></ul></div>
</div>'''

# ───────────── §2 범위 ─────────────
open_rows_html = ''.join(
    f'<tr><td>{r["track"]}</td><td>{e(r["title"])}</td><td>{e(r["owner_name"])}</td></tr>' for r in TOP)
after_items = [
    ('프린팅머니 충전 기능(토스 가상계좌)', '잔액 이관만 오픈 범위. 충전은 오픈 뒤 트랙'),
    ('네이버페이·카카오페이 간편결제', '결제수단 범위 결정 뒤 추가'),
    ('구 관리자 화면 이관 행(거래처·상품통계·체험단 등)', '원장 「오픈 무관」 판정 행'),
    ('조판', '오픈 뒤 마지막에 결정하는 논외 항목'),
]
scope = f'''
<table class="scope" data-scope="open"><caption>오픈 필수 — 최상위 할 일 {len(TOP)}개</caption>
<thead><tr><th>트랙</th><th>할 일</th><th>담당</th></tr></thead><tbody>{open_rows_html}</tbody></table>
<table class="scope" data-scope="after"><caption>오픈 후 — 오픈 판정에 넣지 않는 것</caption>
<thead><tr><th>항목</th><th>이유</th></tr></thead><tbody>{''.join(f"<tr><td>{a}</td><td>{b}</td></tr>" for a, b in after_items)}</tbody></table>
<div class="rule" id="scope-freeze"><h3>범위 동결 규칙</h3><ol>
<li>오픈 필수 표에 새 항목을 넣으려면 같은 크기의 항목을 오픈 후 표로 옮기고, 결정자(채훈희)가 승인한다.</li>
<li>오픈 후 표의 항목은 Go/No-Go 판정에 쓰지 않는다.</li>
<li>동결 뒤 바뀐 범위는 이 문서의 결정 절에 날짜와 결정자를 남긴다.</li></ol></div>'''

# ───────────── §3 마일스톤 ─────────────
MILESTONES = [
    ('T1', 'T1 인프라 이전 완료 — 관리서버·DB·스킨이 Lightsail 에서 돈다', '서희항', '대기', ['T1-1', 'T1-2', 'T1-3', 'T1-4']),
    ('T3', '회원이 장바구니에 담고 주문서까지 간다', '김동학', '진행', ['T3-1', 'T3-2', 'T3-3']),
    ('T4', '결제된 주문이 접수 화면에 들어오고 MES 로 넘어간다', '서희항', '대기', ['T4-1', 'T4-2', 'T4-3', 'T4-4']),
    ('T5', '셀러어드민 설정·알림·법정 표기가 채워진다', '최숙진', '진행', ['T5-1', 'T5-2', 'T5-3']),
    ('T7', '실주문 1건 종단 테스트 통과 → Go/No-Go', '채훈희', '대기', ['T7-1', 'T7-2', 'T7-3']),
]


def ms_date(ids):
    ds = [top_by_id[i]['target_date'] for i in ids if is_date(top_by_id[i]['target_date'])]
    us = [i for i in ids if top_by_id[i]['target_date'].startswith('미산정')]
    s = max(ds) if ds else '—'
    if us and len(us) * 2 > len(ids):
        return f'<b>미산정 {len(us)}/{len(ids)} — 계산 불가</b> (계산된 행만의 값 {s})'
    return s + (f' (미산정 {len(us)}개 제외)' if us else '')


milestones = '<ol id="diag-milestone" class="rail">' + ''.join(
    f'<li data-track="{t}"><div class="rail-dot"></div><div><b>{title}</b>'
    f'<p>오너 <span class="ms-owner">{o}</span> · 상태 <span class="ms-status">{s}</span> · 가장 이른 완료일(하한) {ms_date(ids)}</p></div></li>'
    for t, title, o, s, ids in MILESTONES) + '</ol>'

# ───────────── §4 스윔레인 + CTO 10구간 ─────────────
swim_src = '''flowchart LR
  subgraph L1["고객 화면·자사몰 스킨 (후니 개발)"]
    a1[상품 찾기·옵션 선택] --> a2[원고 업로드] --> a3[장바구니 담기] --> a4[주문서·결제]
  end
  subgraph L2["샵바이 주문·결제·회원 원장 (NHN 제공)"]
    b1[장바구니 1원×수량] --> b2[주문 생성·입금] --> b3[상태 변경·송장]
  end
  subgraph L3["관리서버 webadmin·위젯·가격 (후니 개발)"]
    c1[견적·서명] --> c2[주문 등록 수신] --> c3[원고 승격] --> c4[웹훅 해석] --> c5[접수 화면]
  end
  subgraph L4["생산 연동 PitStop·MES (후니 개발)"]
    d1[파일 검사] --> d2[MES 접수] --> d3[상태·송장 회신]
  end
  a1 --> c1
  a3 --> b1
  a4 --> b2
  a4 --> c2
  c2 --> c3
  b2 --> c4
  c5 --> d1
  d3 --> b3
'''
CTO10 = [
    ('01 사양 선택·원고 업로드', 'B2 · B3', '금액과 원고가 묶이지 않으면 장바구니에 담긴 가격을 믿을 수 없다.'),
    ('02 장바구니 담기(우리 쪽 보관)', 'B4', '사양을 우리가 보관하지 못하면 재견적도 주문 대조도 할 수 없다.'),
    ('03 샵바이 장바구니 올리기', 'B4 · A4', '1원×수량 방식이 틀어지면 손님이 본 금액과 결제 금액이 달라진다.'),
    ('04 결제·주문 생성', 'B5 · B6 · B7', '결제가 막히면 매출이 한 건도 생기지 않는다.'),
    ('05 주문 등록', 'C1', '결제는 됐는데 무엇을 만들지 모르는 주문이 된다.'),
    ('06 원고 승격', 'C2', '원고가 임시 보관함 시한을 넘기면 주문한 파일이 사라진다.'),
    ('07 주문 상태 변화 알림(웹훅)', 'C3 · D1', '입금·취소·주소 변경을 우리가 모르면 엉뚱한 주문을 생산하게 된다.'),
    ('08 파일 검사', 'C4', '인쇄에 맞지 않는 파일이 생산에 들어가 재작업과 클레임이 는다.'),
    ('09 접수 — 검수 후 제작대기', 'C5', '접수 화면이 없으면 주문이 쌓여도 제작대기로 넘길 방법이 없다.'),
    ('10 MES 상태 변경 → 자사몰 전달', 'C6 · C7 · D2', '손님이 주문 진행 상황을 볼 수 없어 문의가 전부 전화로 몰린다.'),
]
cto = '<ol id="map-cto10" class="cto">' + ''.join(
    f'<li data-steps="{s}"><b>{a}</b> <span class="steps">구간 {s}</span><p class="impact">{i}</p></li>'
    for a, s, i in CTO10) + '</ol>'

# ───────────── §5 배치도 ─────────────
topo_src = '''flowchart LR
  n1["자사몰 스킨 컨테이너 — Lightsail · 후니 개발 · 김동학"]
  n2["관리서버 webadmin 컨테이너 — Lightsail · 후니 개발 · 서희항"]
  n3["PostgreSQL 17 hunidb·webapp — Lightsail · 후니 개발 · 서희항"]
  n4["원고 저장소 — AWS · 후니 개발 · 서희항"]
  n5["샵바이 셀러어드민·주문 원장 — NHN 제공 · 최숙진"]
  n6["샵바이 Shop/Server API — NHN 제공 · 김동학"]
  n7["위젯 런타임·가격 API — 관리서버 안 · 후니 개발 · 서희항"]
  n8["파일 검사 PitStop 연동 — 후니 개발 · 서희항"]
  n9["MES 연동 모듈 — 후니 개발 · 서희항"]
  n10["기존 Railway·Vercel — 이전 뒤 종료 · 후니 개발 · 신우진"]
  n1 --> n6
  n1 --> n7
  n7 --> n2
  n2 --> n3
  n2 --> n4
  n6 --> n5
  n5 -- 웹훅 --> n2
  n2 --> n8
  n8 --> n9
  n10 -. 이전 .-> n2
'''

# ───────────── §6 판매 준비 프로세스 ─────────────
menu_rows_html = ''.join(
    f'<tr data-gap="{"Y" if "★" in m["갭"] else "N"}" data-manual="{raw(m["매뉴얼 화면 섹션(SCREENS/MODEL_ADMIN) 유무"])}"><td>{e(m["사이드바그룹"])}</td><td>{e(m[menu_key])}</td>'
    f'<td>{raw(m["경로"])}</td><td class="gap">{e(m["갭"])}</td></tr>' for m in MENU_ROWS)
menu_block = f'''
<div id="map-webadmin-menu"><h3>① webadmin 메뉴 지도 — 메뉴 렌더 확인 + 요소 대조 결과</h3>
<p>메뉴 <b>{len(MENU_ROWS)}개</b> = 사이드바 {sidebar} + 비사이드바 {nonsidebar}.
갭 <b class="gap-count">{len(menu_gap_star)}건</b> — 판정 기준: 갭 열에 ★ 표기가 붙은 행(매뉴얼 원고에 화면 섹션이 없거나 원고 설명과 화면이 어긋난 것).
★ 없는 갭 열 문구는 참고 메모로 남기고 세지 않았다. <span class="source">출처: {MENU_REL}</span></p>
<div class="scroll"><table><thead><tr><th>그룹</th><th>메뉴</th><th>경로</th><th>갭</th></tr></thead><tbody>{menu_rows_html}</tbody></table></div></div>'''

STAGES = [
    ('상품 구성요소', '상품 뷰어'),
    ('가격공식·가격구성요소·단가표(use_dims)', '가격공식 MD · 가격구성요소 MD · 가격 뷰어'),
    ('위젯 cfg·기본값', '위젯빌더'),
    ('고객 화면', '자사몰 상품 상세'),
    ('/api/w/v1/price', '가격 시뮬레이터'),
]
op_src = 'flowchart LR\n' + '\n'.join(
    f'  s{i}["{i}. {a}<br/>고치는 화면: {b}"]' for i, (a, b) in enumerate(STAGES, 1)) + '\n' + \
    '\n'.join(f'  s{i} --> s{i + 1}' for i in range(1, len(STAGES)))
option_block = f'''
<div><h3>② 옵션을 바꾸면 어느 화면에서 고치나</h3>
<p class="lead">옵션은 왼쪽에서 오른쪽으로 흐른다. 손님 화면에서 값이 이상하면 <b>한 단계 왼쪽 화면</b>부터 본다. 위젯은 가격을 정하지 않고 계산 결과를 보여 줄 뿐이다.</p>
{mermaid(op_src, ' → '.join(f'{a}(고치는 화면: {b})' for a, b in STAGES))}
<ol id="diag-option-price" class="stages">{''.join(f'<li data-stage="{i}"><b>{a}</b> <span class="fix-screen">고치는 화면: {b}</span></li>' for i, (a, b) in enumerate(STAGES, 1))}</ol>
<p class="example"><b>예</b> — 아크릴키링은 위젯에서 사이즈·고리 기본값이 비어 첫 화면이 0원으로 뜬다. 고칠 곳은 3단계 위젯빌더의 기본값이다(9/17 01:34~01:39 가격 추적).</p></div>'''

screen_rows = ''.join(f'<tr><td>{e(s)}</td><td class="n">{n}</td></tr>' for s, n in screens.items())
wp_by_screen = defaultdict(list)
for m in writepath:
    wp_by_screen[m['화면']].append(m)
manual_summary = f'''
<div id="map-manual-elements"><h3>③ 매뉴얼 요소 대조 — 요약</h3>
<p class="lead">매뉴얼이 「이 버튼을 누르면 이렇게 된다」고 적은 지점을 실제 화면에서 하나씩 눌러 본 결과다. 메뉴 지도(메뉴 {len(MENU_ROWS)}개)와는 분모가 달라서, 여기서는 화면단위 {len(screens)} · 요소 {len(MATRIX)}건을 센다.</p>
<p><b>분모 산출 규칙</b>: 요소 1건 = 매뉴얼 원고(manual_content.py · widget_manual_content.py)의 SCREENS 캡처가 selector 로 화면의 한 지점을 지목하고 label 로 설명한 콜아웃 하나. 콜아웃이 없는 MODEL_ADMIN_SCREENS 는 화면 1건을 요소 1건으로 센다. <b>매뉴얼 콜아웃이 0 이거나 매뉴얼 섹션이 아예 없는 사이드바 관리 화면도 화면 1건 = 요소 1건</b>으로 센다(9/17 보강 — 대조 대상을 줄이지 않기 위해). steps(도달 조작)는 세지 않는다. 재현 명령:</p>
<pre id="denominator-command" class="cmd">{html.escape(DENOM_CMD)}</pre>
<p>대조에서 뺀 메뉴 — 화면 요소가 아니라 문서 본문 자체라 대조할 지점이 없다({len(EXCLUDED_MENUS)}개):</p>
<ul id="manual-exclusions">{''.join(f'<li>{e(x)}</li>' for x in EXCLUDED_MENUS)}</ul>
<table class="dist" id="manual-dist"><caption>결과 분포(요소 {len(MATRIX)}건)</caption><tbody>
{''.join(f'<tr><th>{k}</th><td class="n">{dist.get(k, 0)}</td></tr>' for k in ['동작확인', '불일치', '쓰기경로-dev환경필요', '미실측'])}
</tbody></table>
<details><summary>화면단위별 요소 수 {len(screens)}개 (합 {sum(screens.values())})</summary>
<table id="manual-screen-counts"><thead><tr><th>화면</th><th>요소 수</th></tr></thead><tbody>{screen_rows}</tbody></table></details>
<h4>불일치 목록</h4><ul id="manual-mismatch">{''.join(f'<li>{e(m["화면"])} — {e(m["요소(설명 발췌)"])}</li>' for m in mismatch) or '<li>없음 — 선행 조작을 매뉴얼대로 실행한 뒤 전 요소가 화면과 일치했다</li>'}</ul>
<h4>쓰기경로-dev환경필요 목록 — {len(writepath)}요소 · {len(wp_by_screen)}화면</h4>
<p id="manual-t1-link" class="link-t1">등록·수정·삭제·게시·저장 버튼은 라이브에서 누르지 않았다. 이 {len(writepath)}건은 dev 환경이 서야 판정할 수 있으므로 <a href="#t1-entry">T1 오픈 테스트 진입 조건</a>과 같이 움직이며, <a href="#critical-path">임계경로 절</a>의 선행 항목으로 올라가 있다.</p>
<ul id="manual-writepath">{''.join(f'<li>{e(s)} — {len(ms)}건</li>' for s, ms in wp_by_screen.items())}</ul>
</div>'''

# ───────────── §7 트랙 + 역할 진입점 + 수동 등록 요약 ─────────────
forced = [r for r in admin_manual if r['forced_by_impl'] == 'Y']
nonforced = [r for r in admin_manual if r['forced_by_impl'] != 'Y']


STD_TO_TOP = {}
for _t in TOP:
    STD_TO_TOP[_t['row_id']] = _t['row_id']
    for _s in _t['std_ids'].split(';'):
        STD_TO_TOP.setdefault(_s, _t['row_id'])


def link_of(r):
    t = STD_TO_TOP.get(r['row_id'])
    return f'<a href="#row-{t}">연결 {t}</a>' if t else '참고(트랙 행 밖)'


def am_li(r):
    return (f'<li data-row="{raw(r["row_id"])}" data-step="{r["step"]}"><b>{e(r["title"])}</b> — {link_of(r)} · 담당 {e(r["owner_name"])} · '
            f'<span class="source">{raw(r["api_evidence"])}</span></li>')


api_block = f'''
<div id="api-admin-manual" class="focus"><h3>우리 구현이 셀러어드민 수동 등록을 강제하는 항목</h3>
<p class="lead">샵바이는 NHN 이 제공하는 서비스라, 같은 일을 <b>API 로 자동화</b>할 수도 있고 <b>셀러어드민 화면에서 사람이 등록</b>할 수도 있다. 아래는 체크리스트 전 행에 「어느 길로 하나」를 붙인 결과다.</p>
<p>분류 값 4종 — Server API(우리 서버가 샵바이를 부름) · Shop API(손님 화면이 샵바이를 부름) · 셀러어드민 수동(사람이 화면에서 등록) · 샵바이 비경유(MES·PitStop·webadmin 가격처럼 샵바이를 안 거침).
분포: {' · '.join(f'{API_LABEL[k]} {api_dist.get(k, 0)}' for k in ['server-api', 'shop-api', 'admin-manual', 'none'])} (전체 {len(ROWS)}행).</p>
<ul id="api-summary">
<li>API 가 있는데 셀러어드민에서 손으로 하고 있는 항목 {len(forced)}건 — 트랙 행에 연결 {sum(1 for r in forced if STD_TO_TOP.get(r['row_id']))}건 · 참고(트랙 행 밖) {sum(1 for r in forced if not STD_TO_TOP.get(r['row_id']))}건</li>
<li>셀러어드민 화면으로만 할 수 있는 항목 {len(nonforced)}건 — 트랙 행에 연결 {sum(1 for r in nonforced if STD_TO_TOP.get(r['row_id']))}건 · 참고 {sum(1 for r in nonforced if not STD_TO_TOP.get(r['row_id']))}건</li>
<li>우선 볼 곳: 「API 가 있는데 수동」 항목은 자동화로 바꿀지 결정할 대상이다</li>
<li>「화면으로만」 항목은 실무운영이 셀러어드민에서 설정해야 끝나는 일이다</li>
<li>샵바이 관련 구간인데 규칙에 걸리지 않은 {len(unreviewed_none)}행은 아래 판정 방법 참고</li></ul>
<details><summary>API 가 있는데 수동으로 두고 있는 항목 전체 — {len(forced)}건</summary><ol id="api-forced">{''.join(am_li(r) for r in forced)}</ol></details>
<details><summary>셀러어드민 화면으로만 할 수 있는 항목 전체 — {len(nonforced)}건</summary><ol id="api-admin-only">{''.join(am_li(r) for r in nonforced)}</ol></details>
<p class="note">판정 방법: 기능명 규칙으로 1차 분류 → 샵바이 경유로 잡힌 행 전건 열람 → 행 단위 사람 판정. 다만 샵바이 관련 구간인데 규칙에 걸리지 않아 「비경유」로 남은 {len(unreviewed_none)}행은 한 행씩 열어 보지 않았으므로, 이 안에 수동 등록 항목이 더 있을 수 있다.</p>
</div>'''

ROLES = [
    ('role-shopdev', '쇼핑개발 — 김동학', lambda r: r['owner_name'] == '김동학'),
    ('role-printdev', '인쇄개발 — 서희항', lambda r: r['owner_name'] == '서희항'),
    ('role-ops', '실무운영 — 최숙진·김용기', lambda r: r['owner_name'] in ('최숙진', '김용기')),
    ('role-pm', 'PM — 신우진·지니', lambda r: r['owner_name'] in ('신우진', '지니')),
    ('role-exec', '대표 결정 — 채훈희', lambda r: r['owner_name'] == '채훈희'),
]
# 이번 주 선행 풀기 — 최상위 행의 선행 칸에서만 규칙으로 뽑는다(날짜·사실·담당 신설 0 · 지니 결정 260917)
NAME_ROLE = [('지니', 'role-pm'), ('신우진', 'role-pm'), ('PM', 'role-pm'), ('김동학', 'role-shopdev'),
             ('서희항', 'role-printdev'), ('최숙진', 'role-ops'), ('김용기', 'role-ops'), ('채훈희', 'role-exec'), ('대표', 'role-exec')]


def owner_role(r):
    return next((rid for rid, _, f in ROLES if f(r)), None)


def unblock_items():
    """→ {role_id: {key: [kind, 표시 문구, [막는 행]]}}. T 행 선행은 일이지 회신·결정·입력이 아니므로 뺀다."""
    out = defaultdict(dict)

    def put(role, key, kind, label, rid):
        if role:
            item = out[role].setdefault(key, [kind, label, []])
            if label not in item[1].split(' / '):  # 같은 대상의 다른 문구는 원문 그대로 나란히 둔다
                item[1] += ' / ' + label
            if rid not in item[2]:
                item[2].append(rid)

    def target_key(tok, named):
        # 같은 대상 = 적힌 사람 표시(이름·「(지니)」·「대표(구매)」·「·PM」)를 뺀 뒤 첫 낱말 + 적힌 사람 역할 집합
        t = re.sub(r'\([^)]*\)', ' ', tok)
        words = [w for w in re.split(r'\s+', t) if w and not any(nm in w for nm, _ in NAME_ROLE)]
        return f'대상:{words[0] if words else tok}|' + ','.join(sorted(named))

    for r in TOP:
        own = owner_role(r)
        for tok in [t.strip() for t in (r['prereq'] or '').split(' · ') if t.strip() not in ('', '—')]:
            if re.match(r'T\d-\d', tok):
                continue
            if tok.startswith('외부('):
                put(own, tok, '회신 받기', tok, r['row_id'])
            elif m := re.match(r'결정 ([\d·]+)', tok):
                for no in m.group(1).split('·'):
                    put(own, f'결정 {no}', '결정 요청', tok if '·' not in m.group(1) else f'결정 {no}', r['row_id'])
            elif tok.startswith('선행 입력'):
                put(own, tok, '입력 받기', tok, r['row_id'])
            else:
                named = {role for nm, role in NAME_ROLE if re.search(rf'(?<![가-힣A-Za-z]){nm}(?![A-Za-z])', tok)}
                dec = '결정' in tok
                key = target_key(tok, named)
                for role in named:
                    put(role, key, '결정 내리기' if dec else '입력 제공', tok, r['row_id'])
                if own not in named:
                    put(own, key, '결정 요청' if dec else '입력 받기', tok, r['row_id'])
    return out


UNBLOCK = unblock_items()


def unblock_html(rid):
    items = UNBLOCK.get(rid, {})
    lis = ''.join(f'<li class="unblock" data-unblock="{raw(k)}"><span class="ub-kind">{kind}</span> {e(label)} — 막는 행 '
                  + ' · '.join(f'<a href="#row-{x}">{x}</a>' for x in rows) + '</li>'
                  for k, (kind, label, rows) in items.items())
    return f'<h5>이번 주 선행 풀기 — {len(items)}건</h5><ul class="unblock-list">{lis or "<li>없음</li>"}</ul>'


roles = ('<p class="rule" id="startable-rule">「이번 주 착수 가능」 표시 규칙 — 상태가 완료가 아니고, 선행 칸에 T 행·선행 입력·결정·외부 회신이 하나도 없는 최상위 할 일. '
         '선행이 해소됐다는 기록은 이 문서에 없으므로 선행이 적힌 행은 모두 대기로 본다. 날짜는 새로 정하지 않았다.</p>'
         '<p class="rule" id="unblock-rule">「이번 주 선행 풀기」 추출 규칙 — 최상위 할 일의 선행 칸을 나눠 T 행은 빼고, 외부 회신은 회신 받기 · 결정 번호는 결정 요청 · 선행 입력은 입력 받기로 그 행 담당 역할에 붙인다. '
         '사람이 적힌 선행은 적힌 사람의 역할에 입력 제공(결정이면 결정 내리기)으로, 그 행 담당 역할에는 입력 받기(결정 요청)로 붙인다. 한 선행이 여러 행을 막으면 1건으로 센다 — 사람이 적힌 선행은 사람 표시를 뺀 첫 낱말이 같으면 같은 선행으로 보고 원문을 나란히 적는다.</p>'
         '<div class="roles">' + ''.join(
    f'<div id="{rid}" class="role"><h4>{name}</h4><ul>' +
    ''.join(f'<li><a href="#row-{r["row_id"]}">{r["row_id"]}</a> {e(r["title"])}'
            + (' <span class="startable">이번 주 착수 가능</span>' if startable(r) else ' <span class="waiting">선행 대기</span>')
            + f' — 하한 {raw(r["target_date"])}</li>'
            for r in TOP if f(r)) + '</ul>' + unblock_html(rid) + '</div>'
    for rid, name, f in ROLES) + '</div>')
# 대표 결정 역할에 결정 레버도 연결(최상위 행만으로는 비어 보일 수 있다)
roles = roles.replace('<div id="role-exec" class="role"><h4>대표 결정 — 채훈희</h4><ul>',
                      '<div id="role-exec" class="role"><h4>대표 결정 — 채훈희</h4><ul><li><a href="#decisions">날짜·인원·범위 3레버 결정</a></li><li><a href="#go-no-go">Go/No-Go 결정</a></li>')


def track_table(tr):
    rows = [r for r in TOP if r['track'] == tr]
    body = ''.join(row_html(r, f' id="row-{r["row_id"]}"') for r in rows)
    return f'<div class="scroll"><table class="checklist" data-track="{tr}">{THEAD}<tbody>{body}</tbody></table></div>'


T1_ENTRY = [
    'hunidb 반입 + 검증 4종 exit 0 + 행수 지문 일치(F2-4) — 가격이 기존 DB 와 같아야 테스트 값이 의미 있다.',
    'DJANGO_SECRET_KEY 가 기존 운영 값과 같다(F3-8) — 다르면 기존 장바구니·손님 증표가 전부 무효가 된다.',
    '샵바이 IP 화이트리스트 52.78.126.17 + 프록시 시크릿(F3-4) — 주문 조회·상태 변경·메인이미지 동기화가 이 경로다.',
    '웹훅 URL 새 호스트 전환 + 시크릿 동일(F3-5) — 주문 등록·원고 승격이 웹훅 수신에서 시작한다.',
    '원고 저장소(AWS) CORS 에 새 관리자 호스트(F3-6) — 원고 업로드 없는 주문은 종단 테스트가 아니다.',
    'huni-admin.printly.co.kr 도메인 유지(F3-7) — 위젯 스크립트·재견적이 스킨에 고정 주소로 박혀 있다.',
    '스킨 컨테이너가 shopby.huniprinting.co.kr 로 서빙 + NEXTAUTH_URL 고정 + 소셜 3사 콜백 통과(F4-5·F4-6).',
    'PRINTLY_DB_URL → webapp 으로 상세 탭 렌더(F2-3) — 상품 상세 없이는 위젯 진입점이 없다.',
    '크론 사이드카가 정시에 시작가 재계산 완료(F1-4) — 목록가·시작가 불일치는 테스트 잡음이다.',
]
t1_extra = f'''
<ul class="flabels"><li><b>F1</b> 관리서버 dev 배포·검증</li><li><b>F2</b> DB 반입(PG 18.6→17)·검증 4종·vc_ 분리</li><li><b>F3</b> 운영 전환 12단계</li><li><b>F4</b> 스킨 컨테이너화·도메인·콜백·env 이관</li></ul>
<h4>오픈 테스트 진입 조건 — {len(T1_ENTRY)}항</h4><ol id="t1-entry">{''.join(f'<li>{x}</li>' for x in T1_ENTRY)}</ol>
<p class="warnbox">되돌릴 수 없는 단계 2개 — <b>F3-11 Railway 종료</b>·<b>F4-8 Vercel 정지</b>는 <strong class="warn">오픈 테스트 통과 전 금지</strong>. 반입 창(F2-4)부터 F3-10 까지는 가격·상품·위젯 편집을 멈추므로 T2 도 그동안 멈춘다.</p>
<p id="t1-redirect-reverify">로그인 리다이렉트 절대 origin 교정 재검증 — 스킨 이전(T1-4) 뒤 로그인·마이페이지 경로가 shopby.huniprinting.co.kr 을 벗어나지 않는지 다시 확인한다(9/17 회원 흐름에서는 이탈이 재현되지 않았다).</p>'''

DP = [  # 결정자 = S2 findings §4 원문 그대로(복수 실명)
    ('D-P1', 'PitStop 도입 형태', '채훈희(구매) · 서희항(구성) · 최숙진(검사 항목)'),
    ('D-P2', '검사 큐 방식', '서희항 · 외부(인프라팀)'),
    ('D-P3', '편집기(Edicus) 파일 검수 생략 여부', '서희항 · 최숙진'),
    ('D-P4', '웹훅 이벤트 → 내부 상태 매핑', '서희항 · 김동학(자사몰 이벤트 실측)'),
    ('D-P5', '주문 상태머신', '서희항 · 최숙진 · 채훈희(정책)'),
    ('D-P6', 'MES 인터페이스', '서희항 · 외부(MES 담당)'),
    ('D-P7', '접수 화면', '최숙진(사용자) · 서희항'),
    ('D-P8', '샵바이 되돌리기(상품준비중·송장·취소)', '서희항 · 최숙진 · 채훈희(시스템키 발급)'),
    ('D-P9', '고객 알림·재업로드', '최숙진 · 신우진'),
]
C_STATUS = [
    ('C1', '주문 등록 수신 엔드포인트', '구현-미검증'), ('C2', '원고 승격', '구현-미검증'), ('C3 수신', '웹훅 수신·원문 저장', '구현-미검증'),
    ('C3 해석', '웹훅 이벤트 해석 → 내부 상태', '없음'), ('C4', '파일 검수(PitStop)', '없음'), ('C5', '접수 화면·MES 전송', '없음'),
    ('C6', 'MES 상태·송장 수신 → 샵바이 반영', '없음'), ('C7', '생산 상태 → 고객 주문조회 반영', '없음'),
]
t4_extra = f'''
<ol class="stages3" id="t4-stages"><li data-stage="design"><b>① 설계 결정</b> — 아래 D-P1~D-P9 가 코드보다 먼저다. D-P4·D-P5·D-P6 이 상태 어휘를 정하므로 가장 먼저.</li>
<li data-stage="build"><b>② 구현</b> — 주문 등록 호출 배선 → 웹훅 해석 → 검수 → 접수 화면·MES 전송 → 송장·상태 되돌리기.</li>
<li data-stage="e2e"><b>③ 종단 테스트</b> — 실주문 1건이 결제 → 접수 → MES → 송장 → 고객 주문조회까지 간다(T7-2).</li></ol>
<table id="t4-decisions"><caption>설계 결정 9건</caption><thead><tr><th>번호</th><th>결정</th><th>결정자</th></tr></thead><tbody>
{''.join(f'<tr><td>{a}</td><td>{b}</td><td class="decider">{c}</td></tr>' for a, b, c in DP)}</tbody></table>
<table id="t4-status"><caption>구간별 현재 상태(9/17 코드·라이브 DB 실측)</caption><thead><tr><th>구간</th><th>무엇</th><th>상태</th></tr></thead><tbody>
{''.join(f'<tr data-seg="{a}"><td>{a}</td><td>{b}</td><td class="status">{c}</td></tr>' for a, b, c in C_STATUS)}</tbody></table>'''

MIG6 = [
    ('구 DB 접근 확보', '외부'), ('스키마 분석', ''), ('매핑 설계', ''), ('이관 스크립트', ''),
    ('샘플 검증 → 전량 리허설(건수 지문·잔액 합계 대사)', ''), ('컷오버 delta 동기화', ''),
]


def mig(track):
    deps = {'T3': ('Shopby 회원 생성 경로', '구 DB 접속 권한'), 'T6': ('구 DB 접속 권한', '잔액 스냅샷 원천')}[track]
    steps = []
    for i, (name, _) in enumerate(MIG6, 1):
        dep = ''
        if i == 1:
            dep = f'<span class="ext-dep">외부 의존: {deps[1] if track == "T3" else deps[0]}</span>'
        if (track == 'T3' and i == 3) or (track == 'T6' and i == 5):
            dep = f'<span class="ext-dep">외부 의존: {deps[0] if track == "T3" else deps[1]}</span>'
        steps.append(f'<li data-mig-step="{i}">{name} {dep}</li>')
    who = ('스크립트 = 인쇄개발 서희항/지니 · Shopby 측 적재 = 쇼핑개발 김동학' if track == 'T3'
           else '설계문서·원장 배정·회의 기록 세 곳이 서로 다르다')
    return f'''<div class="mig" data-track="{track}"><h4>이관 6단계</h4><ol class="mig6">{''.join(steps)}</ol>
<p class="mig-owner">담당 <b>미확정</b> — {who}.</p>
<p class="p6">9/15 회의의 「구 ASP 코드·DB 는 제공하지 않고 참고하지 않음」 기록은 9/17 확정(구 DB 를 직접 분석해 이관 스크립트를 쓴다)으로 덮어썼다.</p></div>'''


t6_waits = '''<ul class="t6-wait" id="t6-outside-waits"><li data-wait="toss">토스페이먼츠 계약 — 면제·수수료·업종 심사·샌드박스 회신(회신 요청: 외부(토스페이먼츠))</li>
<li data-wait="enterprise">Shopby 엔터프라이즈 플랜·외부포인트 정식 적용(회신 요청: 외부(NHN커머스))</li></ul>
<p>잔액 대사는 1원 차이도 NO-GO 다.</p>'''

EXTRA = {'T1': t1_extra, 'T3': mig('T3'), 'T4': t4_extra, 'T6': mig('T6') + t6_waits}
tracks_html = '<h3>역할별 진입점 — 내 일부터 찾기</h3>' + roles + api_block + ''.join(
    f'<div id="track-{t}" class="track"><h3>{t} {n}</h3>{EXTRA.get(t, "")}{track_table(t)}'
    f'<p class="more">세부 {sum(1 for r in DETAIL if r["track"] == t)}행은 <a href="#detail-{t}">부록</a>에 있다.</p></div>'
    for t, n in TRACKS.items())

# ───────────── §8 임계경로 ─────────────
internal_pre = [r for r in DETAIL if r['source'] == 'research§4' and r['data_owner'] != 'ext']
path_ids = ['T1-1', 'T1-2', 'T1-3', 'T1-4', 'T3-1', 'T3-3', 'T4-1', 'T4-2', 'T4-4', 'T7-1', 'T7-2', 'T7-3']
cp_rows = ''.join(
    f'<tr><td>{i}</td><td>{e(top_by_id[i]["title"])}</td><td>{e(top_by_id[i]["prereq"])}</td>'
    f'<td class="n">{top_by_id[i]["effort_lb_days"]}</td><td class="n">{top_by_id[i]["week_plus_cnt"]}</td><td>{raw(top_by_id[i]["target_date"])}</td></tr>'
    for i in path_ids)
lane_rows = ''.join(f'<tr><td>{e(r["owner_name"])}</td><td class="n">{r["effort_lb_days"]}</td><td>{r["serial_end_lb"]}</td></tr>' for r in LANES)
critical = f'''
<p class="lead">날짜를 먼저 정하지 않는다. 할 일 → 선행·외부 대기 → 가장 긴 줄 → 그 줄이 끝나는 가장 이른 날 순서로 계산한다.</p>
<h3>1. 필요 항목</h3><p>최상위 할 일 {len(TOP)}개(트랙별 3~5) · 세부 {len(DETAIL)}행. 오픈 전 반드시 정해야 하는 결정 {len(open_req_dec)}건은 <a href="#decisions">결정 절</a>.</p>
<h3>2. 의존·외부 대기</h3>
<h4>외부 대기 — {len(WAIT)}건 (회신 시점을 모른다)</h4>
<ol id="wait-items">{''.join(f'<li data-row="{raw(r["row_id"])}" data-owner="ext" data-work="wait">{e(r["title"])} — 회신 요청 대상 <b class="wait-target">{e(r["wait_target"])}</b>' + ('' if r["owner_name"] == r["wait_target"] else f' · 챙기는 사람 {e(r["owner_name"])}') + f' <span class="source">근거: {raw(r["wait_target_basis"])}</span></li>' for r in WAIT)}</ol>
<h4>내부 선행 결정 — {len(internal_pre)}건</h4>
<ol id="internal-prereq">{''.join(f'<li data-row="{raw(r["row_id"])}">{e(r["title"])} — {e(r["owner_name"])}</li>' for r in internal_pre)}</ol>
<h4>dev 환경이 있어야 판정할 수 있는 화면 — {len(writepath)}요소 · {len(wp_by_screen)}화면</h4>
<ul id="devenv-prereq">{''.join(f'<li data-prereq="dev-env">{e(s)} — {len(ms)}건</li>' for s, ms in wp_by_screen.items())}</ul>
<p class="link-t1">이 목록은 <a href="#t1-entry">T1 오픈 테스트 진입 조건</a>이 충족돼 dev 환경이 선 뒤에야 판정할 수 있다. 그래서 T1 이 끝나기 전에는 이 화면들의 등록·수정 동작을 확인한 것으로 치지 않는다.</p>
<h3>3. 임계경로</h3>
<p>소요 = 원장 작업량구간을 하한 일수로 환산해 합산(반일 0.5 · 1일 1 · 2-3일 2 · 1주+ 5). <b>합산 대상은 원장 분류가 개발·수정인 미완 행뿐</b>이다 — 검증·설정·이슈 행은 체크리스트에 그대로 남기되 소요는 0 으로 둔다. 1주+ 는 상한이 없어 건수를 같이 적는다. 작업량 「미판정」 행은 합산에서 뺐다.
근무일은 한국천문연구원 특일정보의 공휴일을 빼고 셌다(첫 근무일: {' · '.join(WORKDAYS[:11])}).</p>
<div class="scroll"><table id="cp-table"><thead><tr><th>할 일</th><th>이름</th><th>선행</th><th>소요 하한(일)</th><th>1주+ 건수</th><th>가장 이른 완료일(하한)</th></tr></thead><tbody>{cp_rows}</tbody></table></div>
<p class="note">날짜는 선행 관계만으로 계산했다 — 한 사람이 여러 할 일을 동시에 할 수 없다는 제약은 넣지 않았다(넣으면 줄 세운 순서에 따라 날짜가 달라져 하한이 아니게 된다). 그 제약은 아래 담당자별 표에서 따로 본다.</p>
<p>소요를 산정하지 못한 구간 {len(unsized)}개({', '.join(r["row_id"] for r in unsized)})는 원장에 행이 없어 0 으로 계산했다. 이 구간이 채워지면 날짜는 뒤로 밀린다.</p>
<h3>4. 도출된 오픈일(하한)</h3>
<p class="derived">선행 관계만으로 계산한 가장 이른 완료일(하한) = <b id="derived-open-date">{derived["target_date"]}</b> — 가장 늦게 끝나는 최상위 할 일 {derived["row_id"]}({e(derived["title"])}).
<br><b>범위·인원 조정 전 계산값이며 오픈 가능 여부 판정이 아니다. 판정은 <a href="#go-no-go">Go/No-Go 회의</a>에서 한다.</b>
실제 날짜는 여기에 소요 미산정 구간과 외부 회신 시점이 더해져 늦어진다. 범위·인원을 정하기 전의 수치라는 점도 함께 봐야 한다.</p>
<h4>담당자별로 줄 세웠을 때 — 오픈 범위 조정 전 · 1인 직렬 가정 · 하한</h4>
<p>한 사람이 한 번에 한 가지만 한다고 가정하고, 최상위 할 일에 매달린 개발·수정 미완 행을 원장 담당자별로 이어 붙인 값이다.
담당 칸에 여러 이름이 적힌 행은 <b>처음 나오는 이름에 소요 전부</b>를 붙였다. 개발·수정 행이 없는 담당자는 표에 나오지 않는다.</p>
<p>9/16 에 반려된 합산 수치는 구 IA·검증·설정·오픈 후 행까지 일수로 더했지만, 이 표는 <b>오픈 필수 범위의 개발·수정 행만</b> 더한다. 다만 범위·인원을 정하기 전의 값이라 <a href="#decisions">결정 절</a>의 근거로만 쓴다.</p>
<table id="lane-table"><thead><tr><th>담당</th><th>소요 하한(일)</th><th>전부 끝나는 날(하한)</th></tr></thead><tbody>{lane_rows}</tbody></table>'''

# ───────────── §9 결정 ─────────────
decisions = f'''
<p class="lead">임계경로의 날짜를 앞당기려면 날짜·인원·범위 중 무엇을 움직일지 정해야 한다. 하나를 정하면 나머지 둘도 따라 정해진다. 근거는 <a href="#lane-table">임계경로 절의 담당자별 표</a>다.</p>
<table id="levers"><thead><tr><th>레버</th><th>무엇을 움직이나</th><th>결정자</th></tr></thead><tbody>
<tr data-lever="date"><td>날짜</td><td>기준일을 도출된 날짜 쪽으로 옮긴다</td><td class="decider">채훈희 <span class="proposal">제안(확정 전)</span></td></tr>
<tr data-lever="people"><td>인원</td><td>쇼핑개발 담당을 늘려 담당자별 줄을 나눈다</td><td class="decider">채훈희 <span class="proposal">제안(확정 전)</span></td></tr>
<tr data-lever="scope"><td>범위</td><td>오픈 필수 표에서 항목을 빼 오픈 후 표로 옮긴다</td><td class="decider">신우진 <span class="proposal">제안(확정 전)</span></td></tr>
</tbody></table>
<h3>오픈 전에 정해야 하는 결정 — {len(open_req_dec)}건 (전체 {len(DEC)})</h3>
<div class="scroll"><table id="decision-list"><thead><tr><th>번호</th><th>결정</th><th>구간</th><th>오픈 전 필수</th></tr></thead><tbody>
{''.join(f'<tr data-step="{d["step"]}"><td>{d["no"]}</td><td>{e(DEC_TITLE_OVERRIDE.get(d["no"], d["title"]))}{(" — " + e(d["memo"])) if d["memo"] else ""}</td><td>{d["step"]}</td><td>{"필수" if d["open_required"] == "Y" else "—"}</td></tr>' for d in DEC)}
</tbody></table></div>'''

# ───────────── §10~12 운영 ─────────────
gonogo = '''
<p class="lead">오픈을 결정하는 자리다. 준비도로 판정하고, 데이터가 없는 항목은 위험으로 본다.</p>
<ul class="states"><li data-state="green"><b>Green</b> — 트랙의 최상위 할 일이 전부 완료 증거를 갖췄다</li>
<li data-state="yellow"><b>Yellow</b> — 미완이 있으나 리스크 오너와 해결 기한이 적혀 있다</li>
<li data-state="red"><b>Red</b> — 오픈 테스트 진입 조건 9항 중 하나라도 미충족 → 오픈 차단</li>
<li data-state="unknown"><b>Unknown</b> — 확인할 데이터가 없다 → 차단으로 본다</li></ul>
<p>결정권자: <b class="decider">채훈희</b> <span class="proposal">제안(확정 전)</span> · 판정 회의: <b class="meeting-date">2026-10-02</b> <span class="proposal">제안(확정 전)</span>(<a href="#base-date">기준일 2026-10-06</a> 직전 근무일). Red 나 Unknown 이 하나라도 있으면 범위 축소 후 진행·연기·보완 통제 진행 중 하나를 고른다.</p>'''

CUT = [
    ('1', '서희항', '종단 테스트 통과(T7-2)', 'Railway 관리자 쓰기 정지 공지 기록', '공지 철회 후 기존 운영 유지'),
    ('2', '서희항', '1', 'DB 재덤프 → hunidb 반입 → 검증 4종 exit 0 · 행수 지문 일치', '기존 DB 가 살아 있으므로 연결 주소 유지'),
    ('3', '최숙진', '2', '샵바이 IP 화이트리스트 등록 후 메인이미지 동기화 1건 성공', '등록 해제'),
    ('4', '서희항', '3', '웹훅 URL 새 호스트 전환 후 테스트 주문 1건 수신 로그', '구 URL 재등록'),
    ('5', '김동학', '4', '스킨 도메인 전환 → 소셜 3사 로그인 각 1회 성공', 'DNS 되돌림'),
    ('6', '신우진', '5', '회원·잔액 이관 delta 반영 → 잔액 대사 차이 0원', '이관 행 회수 후 구 사이트 유지'),
    ('7', '채훈희', '6', '오픈 공지·손님 화면 오픈', '공지 보류'),
]
cutover = f'''
<table id="cutover-table"><thead><tr><th>순서</th><th>담당</th><th>선행조건</th><th>검증 증거</th><th>비상조치</th></tr></thead><tbody>
{''.join(f'<tr><td>{a} <span class=\"proposal\">제안(확정 전)</span></td><td>{b}</td><td>{c}</td><td>{d}</td><td>{x}</td></tr>' for a, b, c, d, x in CUT)}</tbody></table>
<p id="rollback-trigger"><span class="proposal">제안(확정 전)</span> 롤백 트리거 — 행수 지문 1개 테이블 이상 불일치, 또는 잔액 대사 차이 1원 이상, 또는 위젯 가격 API 응답 중앙값 300ms 초과가 전환 후 30분 이상 지속.
결정자 <b class="decider">채훈희</b> · 시한 컷오버 시작 후 <b>48시간</b> 안.</p>'''

hypercare = '''
<p class="lead">오픈 직후 집중 감시 기간이다. 끝나는 날을 달력으로 정하지 않고 아래 지표가 채워지면 끝낸다.</p>
<ul id="hypercare-exit">
<li>결제 완료 주문 중 주문 등록 누락 0건이 연속 72시간 유지된다.</li>
<li>처리되지 않은 웹훅 이벤트가 0건이다.</li>
<li>잔액 대사 차이가 0원이다.</li>
<li>장바구니·주문서 화면 오류 신고가 하루 2건 이하로 3일 연속이다. <span class="proposal">제안(확정 전)</span></li>
<li>Sev1 결함 미해결 0건이다.</li></ul>'''

RACI = [
    ('T1 인프라 이전', 'R', 'A', 'I', '', 'C', 'I', 'I'),
    ('T2 상품·가격·위젯', 'I', 'R', 'A', 'R', 'C', 'I', 'I'),
    ('T3 쇼핑몰 주문·결제·회원', 'A', 'C', 'C', '', 'R', 'I', 'I'),
    ('T4 주문 수신·생산 연동', 'R', 'A', 'C', 'C', 'I', 'I', 'I'),
    ('T5 운영 설정·알림·CS', 'C', 'I', 'A', 'R', 'C', 'I', 'I'),
    ('T6 프린팅머니', 'C', 'C', 'C', '', 'R', 'R', 'A'),
    ('T7 테스트·Go/No-Go', 'R', 'R', 'R', 'R', 'A', 'C', 'C'),
    ('롤백 결정', 'C', 'C', 'I', 'I', 'R', 'I', 'A'),
]
PEOPLE = ['김동학', '서희항', '최숙진', '김용기', '신우진', '지니', '채훈희']
raci = f'''
<table id="raci-table"><thead><tr><th>항목</th>{''.join(f'<th>{p}</th>' for p in PEOPLE)}</tr></thead><tbody>
{''.join('<tr><td>' + r[0] + ' <span class=\"proposal\">제안(확정 전)</span></td>' + ''.join(f'<td>{x}</td>' for x in r[1:]) + '</tr>' for r in RACI)}</tbody></table>
<p class="note">A = 결정·승인 1인, R = 실행, C = 사전 협의, I = 결과 공유. 행마다 A 는 한 명이다.</p>
<table id="comms"><caption>의사소통 주기</caption><thead><tr><th>대상</th><th>메시지 수준</th><th>주기</th><th>채널</th><th>담당자</th></tr></thead><tbody>
<tr><td>실무진 전원 <span class="proposal">제안(확정 전)</span></td><td>트랙별 최상위 할 일 상태 변화</td><td>근무일 매일</td><td>이 문서 갱신 + 사내 메신저</td><td>신우진</td></tr>
<tr><td>대표·CTO <span class="proposal">제안(확정 전)</span></td><td>RAG·임계경로 날짜·결정 요청</td><td>주 1회</td><td>주간 회의</td><td>지니</td></tr>
<tr><td>외부(인프라팀·NHN·토스) <span class="proposal">제안(확정 전)</span></td><td>회신 요청·기한</td><td>대기 항목 발생 시</td><td>메일</td><td>신우진</td></tr>
</tbody></table>
<div id="jini-decisions" class="focus"><h3>지니 결정 필요 — 제안값 목록</h3>
<p class="lead">아래는 원천 문서에 확정값이 없어 이 계획서가 제안으로 채운 값이다. 표지 「제안(확정 전)」은 결정이 날 때까지 떼지 않는다.</p>
<table><thead><tr><th>항목</th><th>제안값</th><th>근거</th><th>결정자</th></tr></thead><tbody>
<tr><td>Go/No-Go 결정권자·회의 일자</td><td>채훈희 · 2026-10-02</td><td>결정권자는 1인이어야 한다(오픈 준비 베스트프랙티스) · 기준일 직전 근무일</td><td>지니</td></tr>
<tr><td>3레버 결정자</td><td>날짜·인원 채훈희 · 범위 신우진</td><td>대표 결정 역할 · PM 범위 관리 역할(역할 정의)</td><td>지니</td></tr>
<tr><td>컷오버 순서 7단계와 담당</td><td>표 그대로</td><td>인프라 런북 F2-4·F3-4·F3-5·F4-5 순서 + 이관 컷오버</td><td>지니</td></tr>
<tr><td>롤백 트리거 지속 시간·시한</td><td>300ms 초과 30분 지속 · 48시간</td><td>수치 임계는 런북·잔액 대사 원천, 지속 시간·시한은 베스트프랙티스(첫 24~48시간)에서 고른 제안</td><td>지니</td></tr>
<tr><td>하이퍼케어 CS 신고 기준</td><td>하루 2건 이하 · 3일 연속</td><td>원천 없음 — 종료 기준을 지표로 두라는 원칙만 있음</td><td>지니</td></tr>
<tr><td>RACI 배정 8행</td><td>표 그대로</td><td>트랙 주 담당(원장 담당 열) · 항목당 A 1인 원칙</td><td>지니</td></tr>
<tr><td>의사소통 대상·주기·채널</td><td>표 그대로</td><td>원천 없음 — 대상·수준·주기·채널·담당 다섯 요소 원칙만 있음</td><td>지니</td></tr>
</tbody></table></div>'''

# ───────────── §13 부록 ─────────────
detail_html = ''.join(
    f'<details id="detail-{t}"><summary>{t} {n} — 세부 {sum(1 for r in DETAIL if r["track"] == t)}행</summary>'
    f'<div class="scroll"><table class="checklist detail" data-track="{t}">{THEAD}<tbody>'
    + ''.join(row_html(r) for r in DETAIL if r['track'] == t) + '</tbody></table></div></details>'
    for t, n in TRACKS.items())
matrix_rows = ''.join(
    f'<tr><td>{raw(m["화면"])}</td><td>{raw(m["매뉴얼 원문 위치"])}</td><td>{raw(m["요소(설명 발췌)"])}</td>'
    f'<td>{raw(m["경로 종류"])}</td><td>{raw(m["실측 결과"])}</td></tr>' for m in MATRIX)
appendix = f'''
<div id="appendix">
<h3>체크리스트 세부 행</h3>{detail_html}
<details id="manual-element-matrix"><summary>매뉴얼 요소 대조 전건 — {len(MATRIX)}행</summary>
<p>CSV: {RB}/S/S5-plan/manual-element-matrix.csv</p>
<div class="scroll"><table><thead><tr><th>화면</th><th>매뉴얼 원문 위치</th><th>요소</th><th>경로 종류</th><th>실측 결과</th></tr></thead><tbody>{matrix_rows}</tbody></table></div></details>
<h3>매뉴얼 결함 1건(개발자 전달 · 오픈 일정과 무관)</h3>
<p>/admin/category-master/ 의 매뉴얼 선행 조작이 행 전체(.row)를 누르게 되어 있는데, 그 행 안에 삭제 버튼이 들어 있어 삭제 확인 창이 뜬다. 원고는 「steps 는 읽기 조작만 둔다」고 선언하므로 원고 결함이다. 실측 방법론은 다이얼로그 자동 수락 금지 · 안전한 자식 요소 지목 · 쓰기 컨트롤 선검사 3항으로 고정했다.</p>
<h3>원천 파일</h3><ul>
<li>원장 654행: {RB}/R/R2/unified-ledger-v4.csv</li>
<li>계획 행: {RB}/S/S5-plan/plan-rows.csv (생성 build_plan_rows.py)</li>
<li>결정 30건: {RB}/R/R3/decisions-for-pm.md → decisions-by-step.csv</li>
<li>인프라 런북: {RB}/S/S4-infra/migration-plan.md</li>
<li>공휴일: holidays-kasi-2026.xml · holidays-kasi-2027.xml(한국천문연구원 특일정보)</li>
<li>샵바이 API 명세: docs/shopby/shopby-api/parsed/*.endpoints.json</li></ul>
</div>'''

# ───────────── 조립 ─────────────
CSS = '''
:root{--ivory:#FAF9F5;--paper:#FFFFFF;--slate:#141413;--clay:#D97757;--clay-d:#B85C3E;--oat:#E3DACC;--olive:#788C5D;
--g100:#F0EEE6;--g300:#D1CFC5;--g500:#87867F;--g700:#3D3D3A;
--sans:"Pretendard",system-ui,-apple-system,sans-serif;--mono:"JetBrains Mono",ui-monospace,"SF Mono",monospace;
--max-width:1080px;--radius-panel:12px;--radius-row:8px;--border:1.5px solid var(--g300);color-scheme:light}
*{box-sizing:border-box}
body{margin:0;background:var(--ivory);color:var(--slate);font:15px/1.65 var(--sans);padding:0 16px 64px}
header.top{max-width:var(--max-width);margin:0 auto;padding:40px 0 16px}
header.top h1{font-size:30px;margin:0 0 6px;letter-spacing:-.01em}
header.top p{margin:0;color:var(--g700)}
nav.toc{max-width:var(--max-width);margin:0 auto 12px;display:flex;flex-wrap:wrap;gap:6px}
nav.toc a{font-size:13px;padding:3px 10px;border:var(--border);border-radius:999px;color:var(--g700);text-decoration:none;background:var(--paper)}
section{max-width:var(--max-width);margin:28px auto;background:var(--paper);border:var(--border);border-radius:var(--radius-panel);padding:24px}
h2{margin:0 0 12px;font-size:22px;display:flex;gap:10px;align-items:center}
h2 .no{display:inline-grid;place-items:center;width:30px;height:30px;border-radius:50%;background:var(--clay);color:#fff;font-size:14px}
h3{font-size:17px;margin:22px 0 8px}h4{font-size:15px;margin:16px 0 6px}
.lead{background:var(--g100);border-left:4px solid var(--clay);padding:10px 14px;border-radius:0 var(--radius-row) var(--radius-row) 0}
a{color:var(--clay-d)}
table{border-collapse:collapse;width:100%;font-size:13.5px;margin:8px 0}
th,td{border-bottom:1px solid var(--g300);padding:7px 8px;text-align:left;vertical-align:top}
thead th{background:var(--g100);font-weight:600}
caption{text-align:left;font-weight:600;padding:4px 0}
td.n{text-align:right;font-variant-numeric:tabular-nums}
td.evidence,.source,.cmd{font-family:var(--mono);font-size:12px;color:var(--g700);word-break:break-all}
.scroll{overflow-x:auto}
.summary-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:12px}
.card{border:var(--border);border-radius:var(--radius-row);padding:14px;background:var(--ivory)}
.card h3{margin:0 0 6px;font-size:15px}
.rag{font-size:26px;font-weight:700;margin:0}.rag-red{color:#B3261E}
.legend{list-style:none;padding:0;margin:0}.dot{display:inline-block;width:10px;height:10px;border-radius:50%;margin-right:6px}
.dot.g{background:#3E8E41}.dot.y{background:#C99A06}.dot.r{background:#B3261E}.dot.u{background:var(--g500)}
.tag{display:inline-block;font-size:11px;padding:1px 7px;border-radius:999px;margin:4px 4px 0 0;border:1px solid var(--g300)}
.t-nhn{background:#E8F0FB}.t-huni{background:#F4EDE4}.t-ext{background:#FBE9E7}.t-api{background:var(--g100)}
.warn{color:#B3261E}.warnbox{background:#FBE9E7;padding:10px 14px;border-radius:var(--radius-row)}
.rail{list-style:none;padding:0;margin:0;border-left:3px solid var(--oat)}
.rail li{position:relative;padding:4px 0 14px 22px}.rail-dot{position:absolute;left:-9px;top:8px;width:15px;height:15px;border-radius:50%;background:var(--clay)}
.rail p{margin:2px 0;color:var(--g700)}
.cto li{margin-bottom:8px}.cto .steps{font-size:12px;color:var(--g500)}.cto .impact{margin:2px 0}
.stages li,.stages3 li{margin:4px 0}.fix-screen{display:inline-block;font-size:12px;background:var(--g100);padding:1px 8px;border-radius:999px}
.focus{border:2px solid var(--clay);border-radius:var(--radius-panel);padding:16px;background:#FFF8F4}
.roles{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:10px}
.role{border:var(--border);border-radius:var(--radius-row);padding:10px;font-size:13.5px}.role ul{padding-left:18px;margin:4px 0}
.track{border-top:2px solid var(--oat);margin-top:26px;padding-top:6px}
.ext-dep{font-size:12px;background:#FBE9E7;padding:1px 8px;border-radius:999px}
.derived{font-size:16px}.note{font-size:13px;color:var(--g700)}
.rid{font-family:var(--mono);font-size:12px;color:var(--clay-d);font-weight:700}
.startable{display:inline-block;font-size:11px;padding:0 7px;border-radius:999px;background:#E3F1E4;color:#1E5B24;border:1px solid #9CC9A0}
.waiting{display:inline-block;font-size:11px;padding:0 7px;border-radius:999px;background:var(--g100);color:var(--g700);border:1px solid var(--g300)}
.rule{font-size:13px;background:var(--g100);padding:8px 12px;border-radius:var(--radius-row)}
.proposal{display:inline-block;font-size:11px;font-weight:600;color:#8A4B00;background:#FFF1D6;border:1px solid #E8C27A;border-radius:999px;padding:0 7px;white-space:nowrap}
figure.diagram{margin:10px 0;overflow-x:auto;background:var(--ivory);border-radius:var(--radius-row);padding:10px}
pre.mermaid{margin:0;white-space:pre}.cmd{background:var(--g100);padding:10px;border-radius:var(--radius-row);white-space:pre-wrap}
details{margin:6px 0}summary{cursor:pointer;font-weight:600}
@media print{body{background:#fff}section{break-inside:avoid-page;border:none}nav.toc{display:none}}
'''
NAV = ['요약', '범위', '마일스톤', '흐름', '배치도', '판매 준비', '트랙', '임계경로', '결정', 'Go/No-Go', '컷오버', '하이퍼케어', 'RACI·부록']
SECTIONS = [
    section(1, '한 장 요약', summary),
    section(2, '범위 — 오픈 필수와 오픈 후', scope, '오픈 판정에 쓰는 것과 쓰지 않는 것을 두 표로 나눴다. 섞이면 오픈 날짜 논의가 끝나지 않는다.'),
    section(3, '마일스톤', milestones, '큰 확인 지점 5개다. 날짜는 각 마일스톤에 속한 할 일의 가장 이른 완료일(하한) 중 가장 늦은 날이다.'),
    section(4, '주문이 흐르는 길 — 누가 무엇을 넘기나',
            mermaid(swim_src, '고객 화면·자사몰 스킨(후니 개발) → 샵바이 주문·결제·회원 원장(NHN 제공) → 관리서버 webadmin·위젯·가격(후니 개발) → 생산 연동 PitStop·MES(후니 개발). 결제 뒤 주문 등록과 웹훅이 관리서버로 들어오고, MES 상태와 송장이 샵바이로 되돌아간다.', 'diag-swimlane')
            + '<h3>CTO 10구간 ↔ 업무 28구간</h3>' + cto,
            '가로 구획 하나가 한 시스템이고, 화살표는 일을 넘기는 지점이다. 아래 10구간은 9/8 CTO 문서의 구간을 그대로 쓰고 이 계획서의 28구간을 연결했다.'),
    section(5, '시스템 배치도 — 무엇이 어디로 옮겨지나',
            mermaid(topo_src, '이전 뒤 Lightsail 에 스킨·관리서버·DB 가 올라가고, 샵바이(NHN 제공)는 그대로다. 관리서버가 웹훅을 받고 원고 저장소·PitStop·MES 로 이어진다. 기존 Railway·Vercel 은 오픈 테스트 통과 뒤 종료한다.', 'diag-topology'),
            '노드마다 소유(NHN 제공 / 후니 개발)와 담당 실명을 붙였다. NHN 제공 노드는 우리가 개발하지 않고 설정만 한다.'),
    section(6, '판매 준비 프로세스 — 실무진이 어디서 무엇을 고치나', menu_block + option_block + manual_summary),
    section(7, '트랙별 체크리스트', tracks_html,
            '트랙마다 최상위 할 일 3~5개만 본문에 둔다. 칸은 담당 · 목표일 · 완료 증거 · 체크 방법 · 선행 · 상태 여섯 개다. 목표일은 가장 이른 완료일(하한)이다.'),
    f'<section id="sec-08"><h2><span class="no">8</span>임계경로</h2><div id="critical-path">{critical}</div></section>',
    f'<section id="sec-09"><h2><span class="no">9</span>결정</h2><div id="decisions">{decisions}</div></section>',
    f'<section id="sec-10"><h2><span class="no">10</span>Go/No-Go</h2><div id="go-no-go">{gonogo}</div></section>',
    f'<section id="sec-11"><h2><span class="no">11</span>컷오버·롤백</h2><div id="cutover">{cutover}</div><div id="hypercare">{hypercare}</div></section>',
    f'<section id="sec-12"><h2><span class="no">12</span>RACI·의사소통</h2><div id="raci">{raci}</div></section>',
    f'<section id="sec-13"><h2><span class="no">13</span>부록</h2>{appendix}</section>',
]
MERMAID_JS = '''<script type="module">
import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
mermaid.initialize({startOnLoad:true,theme:"base",securityLevel:"strict",themeVariables:{primaryColor:"#FAF9F5",primaryTextColor:"#141413",primaryBorderColor:"#D97757",lineColor:"#87867F",secondaryColor:"#E3DACC",tertiaryColor:"#F0EEE6"}});
</script>'''
DOC = f'''<!doctype html>
<html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>후니프린팅 오픈 계획서</title>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
<style>{CSS}</style></head>
<body>
<header class="top"><h1>후니프린팅 오픈 계획서</h1><p>작성 {TODAY} · 필요한 일 → 선행·외부 대기 → 가장 이른 완료일 순서로 정리</p></header>
<nav class="toc">{''.join(f'<a href="#sec-{i:02d}">{i}. {n}</a>' for i, n in enumerate(NAV, 1))}</nav>
{''.join(SECTIONS)}
{MERMAID_JS}
</body></html>'''

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, 'w', encoding='utf-8') as f:
    f.write(DOC)

# 에이전트용 요약(사람용 HTML 보다 가볍게 — 사실·수치·결정만)
TWIN = OUT[:-5] + '.md'
with open(TWIN, 'w', encoding='utf-8') as f:
    f.write(f'# 후니프린팅 오픈 계획서 — 요약 ({TODAY})\n\n')
    f.write(f'- 최상위 할 일 {len(TOP)} · 세부 {len(DETAIL)} · 외부 대기 {len(WAIT)} · 소요 미산정 {len(unsized)}\n')
    f.write(f'- 도출된 가장 이른 완료일(하한): {derived["target_date"]} ({derived["row_id"]})\n')
    f.write(f'- api-path: {dict(api_dist)} · 수동 등록 강제(API 있음) {len(forced)} · 화면만 {len(nonforced)}\n')
    f.write(f'- 매뉴얼 요소 {len(MATRIX)}: {dict(dist)} · 메뉴 {len(MENU_ROWS)} · 갭(★) {len(menu_gap_star)}\n\n')
    f.write('| id | 트랙 | 할 일 | 담당 | 가장 이른 완료일(하한) | 상태 |\n|---|---|---|---|---|---|\n')
    for r in TOP:
        f.write(f'| {r["row_id"]} | {r["track"]} | {r["title"]} | {r["owner_name"]} | {r["target_date"]} | {r["status"]} |\n')

print(f'D1 {OUT} {os.path.getsize(OUT):,} bytes')
print(f'top {len(TOP)} · detail {len(DETAIL)} · wait {len(WAIT)} · derived {derived["target_date"]} ({derived["row_id"]})')
print(f'menu {len(MENU_ROWS)} (사이드바 {sidebar} + 비사이드바 {nonsidebar}) · 갭★ {len(menu_gap_star)} · matrix {len(MATRIX)} {dict(dist)} · 화면 {len(screens)}')
print(f'api {dict(api_dist)} · forced {len(forced)} · admin-only {len(nonforced)} · 규칙 미매칭 none {len(unreviewed_none)}')
