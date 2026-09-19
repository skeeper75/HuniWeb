#!/usr/bin/env python3
"""t56 — rejudge.csv → 담당자별 Todo 목록(todo-by-owner.md) + 재배정 제안표(reassign-proposal.md).

숫자는 전부 rejudge.csv 에서 센다(손으로 적지 않는다). 날짜·작업량 추정 0.
"""
import csv, os, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROWS = list(csv.DictReader(open(os.path.join(HERE, 'rejudge.csv'), encoding='utf-8')))

TRACK_NAME = {
    'T1': '인프라 이전(Lightsail)', 'T2': '상품·가격·위젯 준비',
    'T3': '쇼핑몰 주문·결제·회원', 'T4': '주문 수신·원고·생산 연동',
    'T5': '운영 설정·알림·CS·증빙', 'T6': '프린팅머니', 'T7': '테스트·리허설·컷오버',
}
INHOUSE = ['서희항', '김동학', '최숙진', '신우진']
VORDER = ['담당맞음', '재배정', '분할', 'provided', '불필요', '미정']


def c(rows, key):
    return collections.Counter(r[key] for r in rows)


def owner_block(owner, out):
    mine = [r for r in ROWS if r['owner_now'] == owner]
    rem = [r for r in mine if r['remaining'] == 'Y']
    keep = [r for r in rem if r['verdict'] == '담당맞음']
    move = [r for r in rem if r['verdict'] == '재배정']
    split = [r for r in rem if r['verdict'] == '분할']
    prov = [r for r in mine if r['verdict'] in ('provided', '불필요')]
    undef = [r for r in rem if r['verdict'] == '미정']
    incoming = [r for r in ROWS if r['owner_now'] != owner and owner in r['owner_proposed']
                and r['remaining'] == 'Y' and r['verdict'] in ('재배정', '분할')]

    out.append(f'\n## {owner}\n')
    out.append('### 한 장 요약\n')
    out.append('| 항목 | 행수 |')
    out.append('|---|---|')
    out.append(f'| 현재 걸린 행(원장 전체) | {len(mine)} |')
    out.append(f'| 그중 남은 일(status≠작동) | {len(rem)} |')
    out.append(f'| ① 담당 맞음 — 그대로 한다 | {len(keep)} |')
    out.append(f'| ② 다른 담당으로 넘길 제안 | {len(move)} |')
    out.append(f'| ③ 행을 나눠야 함(경계 걸침) | {len(split)} |')
    out.append(f'| ④ 샵바이·MES 제공이라 개발 일 아님 / 불필요 | {len(prov)} |')
    out.append(f'| ⑤ 미정(실측·결정 전이라 배정 불가) | {len(undef)} |')
    out.append(f'| **다른 사람에게서 넘어올 제안** | **{len(incoming)}** |')
    out.append('')
    out.append(f'재판정 뒤 이 사람이 실제로 질 남은 일(제안 기준) = '
               f'{len(keep)} + 넘어옴 {len(incoming)} = **{len(keep) + len(incoming)}행** '
               f'(+ 나눠야 하는 {len(split)}행의 자기 몫)\n')

    out.append('### 트랙별\n')
    out.append('| 트랙 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 |')
    out.append('|---|---|---|---|---|---|---|')
    for t in sorted({r['track'] for r in rem}):
        tr = [r for r in rem if r['track'] == t]
        cc = c(tr, 'verdict')
        out.append(f"| {t} {TRACK_NAME.get(t, '')} | {len(tr)} | {cc['담당맞음']} | "
                   f"{cc['재배정']} | {cc['분할']} | {cc['provided'] + cc['불필요']} | {cc['미정']} |")
    out.append('')

    for title, sel, extra in (
        ('① 담당 맞음 — 그대로 한다', keep, False),
        ('② 다른 담당으로(제안)', move, True),
        ('③ 행을 나눠야 함', split, True),
        ('④ 제공/불필요 — 개발 일 아님(확인만)', prov, True),
        ('⑤ 미정', undef, True),
    ):
        if not sel:
            continue
        out.append(f'### {title} — {len(sel)}행\n')
        out.append('| row_id | 트랙.단계 | status | 일 | ' + ('제안 담당 | 근거등급 | 근거 |' if extra else '근거등급 |'))
        out.append('|---|---|---|---|---|---|---|' if extra else '|---|---|---|---|---|')
        for r in sorted(sel, key=lambda x: (x['track'], x['step'], x['row_id'])):
            ttl = r['title'].replace('|', '·')[:70]
            if extra:
                nb = (r['note'] or r['basis']).replace('|', '·')[:90]
                out.append(f"| {r['row_id']} | {r['track']}.{r['step']} | {r['status']} | {ttl} | "
                           f"{r['owner_proposed']} | {r['judged_by']} | {nb} |")
            else:
                out.append(f"| {r['row_id']} | {r['track']}.{r['step']} | {r['status']} | {ttl} | {r['judged_by']} |")
        out.append('')

    if incoming:
        out.append(f'### 넘어올 제안 — {len(incoming)}행\n')
        out.append('| row_id | 트랙.단계 | status | 일 | 현재 담당 | 판정 | 근거등급 |')
        out.append('|---|---|---|---|---|---|---|')
        for r in sorted(incoming, key=lambda x: (x['track'], x['step'], x['row_id'])):
            out.append(f"| {r['row_id']} | {r['track']}.{r['step']} | {r['status']} | "
                       f"{r['title'].replace('|', '·')[:60]} | {r['owner_now']} | {r['verdict']} | {r['judged_by']} |")
        out.append('')


def todo_md():
    out = ['# t56 — 담당자별 Todo(재판정 후) · 오픈일정 S7-A',
           '',
           '입력 = `07_rebaseline/S/S5-plan/plan-rows.csv` 735행 · `08_system-screen/t51/merged.csv` 747행.',
           '판정 = 5분류(담당맞음 / 재배정 / 분할 / provided·불필요 / 미정). **재배정은 제안까지 — 결정은 지니.**',
           '작업량·날짜 추정 0. 모든 행의 근거는 `rejudge.csv` 의 `basis`·`evidence` 열.',
           '',
           '## 0. 전체',
           '']
    rem = [r for r in ROWS if r['remaining'] == 'Y']
    out.append(f'- 원장 735행 중 남은 일(status≠작동) = **{len(rem)}행**')
    cc = c(ROWS, 'verdict')
    out.append('- 판정 분포(735행 전체): ' + ' · '.join(f'{k} {cc[k]}' for k in VORDER if cc[k]))
    jb = c(ROWS, 'judged_by')
    out.append('- 근거 등급: ' + ' · '.join(f'{k} {v}' for k, v in sorted(jb.items(), key=lambda x: -x[1])))
    out.append('')
    out.append('| 근거등급 | 뜻 |')
    out.append('|---|---|')
    out.append('| manual-read | 그 evidence 파일을 열어 확인함(파일·줄 명시) |')
    out.append('| merged-owner_side | t51 merged.csv 가 그 기능이 사는 코드 쪽을 이미 적어 둔 행 |')
    out.append('| evidence-path | plan-rows evidence 가 저장소·호스트를 직접 가리킴 |')
    out.append('| rule-step | 위가 전부 없어 CARDS-S §1 단계 기본 담당으로만 판정 — **약한 근거** |')
    out.append('| rule-track | 위가 전부 없고 트랙/수기 판단 — **약한 근거** |')
    out.append('')
    out.append('## 담당자 한 장 요약(전원)\n')
    out.append('| 담당 | 현재 행 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 | 넘어올 제안 |')
    out.append('|---|---|---|---|---|---|---|---|---|')
    for o in INHOUSE:
        mine = [r for r in ROWS if r['owner_now'] == o]
        rr = [r for r in mine if r['remaining'] == 'Y']
        cv = c(rr, 'verdict')
        prov = len([r for r in mine if r['verdict'] in ('provided', '불필요')])
        inc = len([r for r in ROWS if r['owner_now'] != o and o in r['owner_proposed']
                   and r['remaining'] == 'Y' and r['verdict'] in ('재배정', '분할')])
        out.append(f"| {o} | {len(mine)} | {len(rr)} | {cv['담당맞음']} | {cv['재배정']} | "
                   f"{cv['분할']} | {prov} | {cv['미정']} | {inc} |")
    out.append('')
    for o in INHOUSE:
        owner_block(o, out)

    other = [r for r in ROWS if r['owner_now'] not in INHOUSE]
    out.append(f'\n## 그 밖(외부·대표·지니·미정) — {len(other)}행\n')
    out.append('사내 4담당 경계 밖이라 이번 재판정 대상이 아니다(판정=미정 유지).')
    out.append('')
    out.append('| 담당 | 행수 |')
    out.append('|---|---|')
    for k, v in sorted(c(other, 'owner_now').items(), key=lambda x: -x[1]):
        out.append(f'| {k} | {v} |')
    return '\n'.join(out) + '\n'


def reassign_md():
    move = [r for r in ROWS if r['verdict'] in ('재배정', '분할', 'provided', '불필요')
            and r['owner_now'] in INHOUSE]
    out = ['# t56 — 재배정 제안표 (제안까지 · 결정은 지니)',
           '',
           f'대상 = 사내 4담당이 든 행 중 판정이 담당맞음이 아닌 **{len(move)}행**.',
           '작업량 숫자·날짜 추정 없음. 근거 등급이 `rule-step`·`rule-track` 인 행은 **약한 근거**로, 실측 후 확정해야 한다.',
           '']
    flow = collections.Counter((r['owner_now'], r['owner_proposed']) for r in move
                               if r['verdict'] in ('재배정',))
    out.append('## 이동 흐름(재배정만)\n')
    out.append('| 현재 → 제안 | 행수 |')
    out.append('|---|---|')
    for k, v in sorted(flow.items(), key=lambda x: -x[1]):
        out.append(f'| {k[0]} → {k[1]} | {v} |')
    out.append('')
    for v in ('재배정', '분할', 'provided', '불필요'):
        sel = [r for r in move if r['verdict'] == v]
        if not sel:
            continue
        out.append(f'## {v} — {len(sel)}행\n')
        out.append('| row_id | 트랙.단계 | status | 일 | 현재 | 제안 | 근거등급 | 근거 |')
        out.append('|---|---|---|---|---|---|---|---|')
        for r in sorted(sel, key=lambda x: (x['owner_now'], x['track'], x['step'])):
            out.append(f"| {r['row_id']} | {r['track']}.{r['step']} | {r['status']} | "
                       f"{r['title'].replace('|', '·')[:60]} | {r['owner_now']} | {r['owner_proposed']} | "
                       f"{r['judged_by']} | {(r['note'] or r['basis']).replace('|', '·')[:110]} |")
        out.append('')
    return '\n'.join(out) + '\n'


if __name__ == '__main__':
    open(os.path.join(HERE, 'todo-by-owner.md'), 'w', encoding='utf-8').write(todo_md())
    open(os.path.join(HERE, 'reassign-proposal.md'), 'w', encoding='utf-8').write(reassign_md())
    print('todo-by-owner.md · reassign-proposal.md 생성')
