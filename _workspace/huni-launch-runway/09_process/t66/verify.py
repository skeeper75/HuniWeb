#!/usr/bin/env python3
"""t66 검증기 — 게이트 V1~V12.

생성측(`build.py`·`merge_lib.py`)을 **import 하지 않는다.** 분모·건수를 여기서 다시 센다.
같은 코드를 공유하면 같이 틀리기 때문이다(t64 가 쓴 방식을 이어받았다).
"""
import csv
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PROC = os.path.dirname(HERE)
RUNWAY = os.path.dirname(PROC)
REPO = os.path.abspath(os.path.join(RUNWAY, '..', '..'))
LEDGER = os.path.join(RUNWAY, '08_system-screen', 't56', 'rejudge.csv')

# t64 는 260919 에 두 번 고쳤다 — 집계 정정(65→169 · 9c7476bb) 뒤 담당 채움(b50011a6).
CARD_COMMIT = {'t62': 'd50770c9', 't63': '307e6a56', 't64': 'b50011a6', 't65': '21f181ec'}
EXPECT_OWNED = {'t62': 131, 't63': 201, 't64': 178, 't65': 151}
EXPECT_GAPS = {'t62': 71, 't63': 168, 't64': 169, 't65': 117}
EXPECT_TOTAL_GAPS = 525
EXPECT_DECISIONS = 148
EXPECT_PROC = {'t62': 29, 't63': 24, 't64': 17, 't65': 38}
JOURNEYS = ['J1-비회원-주문-종단.md', 'J2-회원-가입-첫주문-적립.md',
            'J3-주문-생산-출고-배송.md', 'J4-취소-환불.md', 'J5-재제작.md']

results = []


def gate(name, ok, detail=''):
    results.append((name, bool(ok), detail))


def rows(path):
    with open(path, encoding='utf-8') as f:
        return list(csv.DictReader(f))


tree = rows(os.path.join(HERE, 'all-process-tree.csv'))
gaps = rows(os.path.join(HERE, 'all-gaps.csv'))
roots = rows(os.path.join(HERE, 'root-causes.csv'))
ledger = rows(LEDGER)
ledger_ids = {r['row_id'].strip() for r in ledger}

# V1 — 원장
gate('V1 원장 735행', len(ledger) == 735 and len(ledger_ids) == 735,
     f'실측 {len(ledger)}행 · 고유 {len(ledger_ids)}')

# V2 — 735 전수 설명(누락 0)
owned = {r['row_id'] for r in tree if r['귀속'] == '담당' and r['row_id']}
premise = {r['row_id'] for r in tree if r['귀속'] == '전제' and r['row_id']}
missing = sorted(ledger_ids - owned - premise)
outside = sorted((owned | premise) - ledger_ids)
gate('V2 원장 전수 설명', len(owned) == 661 and len(premise) == 74 and not missing and not outside,
     f'담당 {len(owned)} + 전제 {len(premise)} = {len(owned) + len(premise)} · '
     f'누락 {missing or "[]"} · 원장 밖 {outside or "[]"}')

# V3 — 담당·전제가 겹치지 않는다
gate('V3 담당·전제 배타', not (owned & premise), f'겹침 {sorted(owned & premise) or "[]"}')

# V4 — 카드별 담당 행수
bad = {}
for c, n in EXPECT_OWNED.items():
    got = len({r['row_id'] for r in tree if r['card'] == c and r['귀속'] == '담당' and r['row_id']})
    if got != n:
        bad[c] = f'{got}≠{n}'
gate('V4 카드별 담당 131·201·178·151', not bad, str(bad or '일치'))

# V5 — 카드 사이 담당 행 중복 0
seen, dup = {}, []
for r in tree:
    if r['귀속'] != '담당' or not r['row_id']:
        continue
    prev = seen.get(r['row_id'])
    if prev and prev != r['card']:
        dup.append(f"{r['row_id']}({prev}·{r['card']})")
    seen[r['row_id']] = r['card']
gate('V5 카드 간 담당 행 중복 0', not dup, str(sorted(set(dup))[:10] or '[]'))

# V6 — 프로세스 108
nproc = len({r['process_uid'] for r in tree if r['card'] != '전제'})
percard = {c: len({r['process_uid'] for r in tree if r['card'] == c}) for c in EXPECT_PROC}
gate('V6 프로세스 108', nproc == 108 and percard == EXPECT_PROC, f'{nproc} · {percard}')

# V7 — 빠진 곳 525 + 카드별 분해
gcard = {c: sum(1 for g in gaps if g['card'] == c) for c in EXPECT_GAPS}
kinds = {k: sum(1 for g in gaps if g['종류'] == k) for k in '가나다라'}
gate(f'V7 빠진 곳 {EXPECT_TOTAL_GAPS}',
     len(gaps) == EXPECT_TOTAL_GAPS and gcard == EXPECT_GAPS and sum(kinds.values()) == EXPECT_TOTAL_GAPS,
     f'{len(gaps)} · 카드 {gcard} · 종류 {kinds}')

# V8 — 뿌리표가 525 를 남김없이 덮는다
rsum = sum(int(r['건수']) for r in roots)
no_rc = [g['gap_uid'] for g in gaps if not g['root_cause_id']]
rc_ids = {r['root_cause_id'] for r in roots}
orphan = {g['root_cause_id'] for g in gaps} - rc_ids
gate(f'V8 뿌리 합계 = {EXPECT_TOTAL_GAPS}',
     rsum == EXPECT_TOTAL_GAPS and not no_rc and not orphan,
     f'합 {rsum} · 뿌리 {len(roots)}종 · 빈 root_cause {no_rc or "[]"} · 표 밖 {sorted(orphan) or "[]"}')

# V9 — decisions.md 148건 = 종류 「라」
dec = open(os.path.join(HERE, 'decisions.md'), encoding='utf-8').read()
m = re.search(r'\|\s*\*\*합계\*\*\s*\|\s*\*\*(\d+)\*\*\s*\|', dec)
dec_n = int(m.group(1)) if m else -1
gate(f'V9 결정 {EXPECT_DECISIONS}건',
     dec_n == EXPECT_DECISIONS and kinds['라'] == EXPECT_DECISIONS,
     f'decisions.md {dec_n} · 라 {kinds["라"]}')

# V9c — 문서 제목·본문에 적힌 건수가 실측과 같은가
#       (260919: t64 가 65→169 로 바뀌자 상수로 박아 둔 「105건」·「421건」이 낡아 남았다.
#        이제 build.py 가 계산값으로 쓰고, 여기서 낡은 수가 남아 있지 않은지 다시 본다.)
stale = []
dec_txt = open(os.path.join(HERE, 'decisions.md'), encoding='utf-8').read()
qw_txt = open(os.path.join(HERE, 'quick-wins.md'), encoding='utf-8').read()
m = re.search(r'^# t66 — 지니가 정해야 하는 것 (\d+)건', dec_txt, re.M)
if not m or int(m.group(1)) != kinds['라']:
    stale.append(f'decisions.md 제목 {m.group(1) if m else "없음"} ≠ 라 {kinds["라"]}')
for label, txt, pat in [('decisions.md', dec_txt, r'`기다리는것` = (\d+)건 중'),
                        ('quick-wins.md', qw_txt, r'네 카드의 빠진 곳 (\d+)건 중')]:
    m2 = re.search(pat, txt)
    if not m2 or int(m2.group(1)) != len(gaps):
        stale.append(f'{label} 분모 {m2.group(1) if m2 else "없음"} ≠ {len(gaps)}')
m3 = re.search(r'^\*\*(\d+)건\*\* — 담당자별로', qw_txt, re.M)
qw_n = int(m3.group(1)) if m3 else -1
m4 = re.search(r'\|\s*\*\*합계\*\*\s*\|\s*\*\*(\d+)\*\*\s*\|', qw_txt)
if not m4 or int(m4.group(1)) != qw_n:
    stale.append(f'quick-wins.md 머리 {qw_n} ≠ 합계 {m4.group(1) if m4 else "없음"}')
gate('V9c 문서 본문 건수 = 실측', not stale, str(stale or '일치'))

# V9d — 제안담당 공란 0 · `담당_근거` 는 t64 만 채워져 있다(다른 세 카드는 만들어 넣지 않았다)
blank_owner = [g['gap_uid'] for g in gaps if not g['제안담당'].strip()]
t64_no_basis = [g['gap_uid'] for g in gaps if g['card'] == 't64' and not g['담당_근거'].strip()]
other_basis = [g['gap_uid'] for g in gaps if g['card'] != 't64' and g['담당_근거'].strip()]
gate('V9d 제안담당 공란 0 · 담당_근거는 t64 만',
     not blank_owner and not t64_no_basis and not other_basis,
     f'공란 {blank_owner[:5] or "[]"} · t64 근거없음 {t64_no_basis[:5] or "[]"} · '
     f't64 밖 근거 {other_basis[:5] or "[]"}')

# V9b — gap_uid 는 카드별로 매긴다(통번호 금지 — 한 카드가 바뀌면 인용이 통째로 밀린다)
badid = [g['gap_uid'] for g in gaps if not re.fullmatch(r'GX-t6[2-5]-\d{3}', g['gap_uid'])]
gate('V9b gap_uid 카드별 고정', not badid and len({g['gap_uid'] for g in gaps}) == len(gaps),
     f'형식 위반 {badid[:5] or "[]"} · 고유 {len({g["gap_uid"] for g in gaps})}')

# V10 — 여정 5편 · mermaid · 경계 표 · 인용한 gap_uid 실재
uids = {g['gap_uid'] for g in gaps}
jbad = []
for j in JOURNEYS:
    p = os.path.join(HERE, 'journeys', j)
    if not os.path.exists(p):
        jbad.append(f'{j}: 없음')
        continue
    t = open(p, encoding='utf-8').read()
    if '```mermaid' not in t:
        jbad.append(f'{j}: mermaid 없음')
    if '묶음 경계에서 끊기는 지점' not in t:
        jbad.append(f'{j}: 경계 표 없음')
    ghost = sorted(set(re.findall(r'GX-[A-Za-z0-9]+-\d{3}', t)) - uids)
    if ghost:
        jbad.append(f'{j}: 없는 gap {ghost}')
gate('V10 여정 5편 · mermaid · 경계표 · 인용 실재', not jbad, str(jbad or '정상'))

# V11 — gaps 가 가리키는 원장 row_id 가 실재한다
ghost_rows = set()
for g in gaps:
    for rid in re.findall(r'STD-[A-Z0-9]{2,4}-\d{3}|BLK-S\d+-\d+|T\d-\d+', g['관련_row_id']):
        if rid not in ledger_ids:
            ghost_rows.add(f"{g['gap_uid']}:{rid}")
gate('V11 gaps 참조 row_id 실재', not ghost_rows, str(sorted(ghost_rows)[:10] or '[]'))

# V12 — 네 카드 산출물 미변경(합치기만 했다) · index.html 링크 대상 실재
diffs = []
for c, sha in CARD_COMMIT.items():
    rel = os.path.relpath(os.path.join(PROC, c), REPO)
    try:
        out = subprocess.run(['git', '-C', REPO, 'diff', '--name-only', sha, '--', rel],
                             capture_output=True, text=True, timeout=60)
        if out.stdout.strip():
            diffs.append(f'{c}: ' + out.stdout.strip().replace('\n', ' '))
    except Exception as e:                                    # noqa: BLE001
        diffs.append(f'{c}: 확인 실패 {e}')
links = ['all-process-tree.csv', 'all-gaps.csv', 'root-causes.csv',
         'decisions.md', 'quick-wins.md', 'verdict.md'] + ['journeys/' + j for j in JOURNEYS]
nolink = [l for l in links if not os.path.exists(os.path.join(HERE, l))]
gate('V12 네 카드 미변경 · 링크 대상 실재', not diffs and not nolink,
     f'{diffs or "변경 0"} · 없는 링크 {nolink or "[]"}')

npass = sum(1 for _, ok, _ in results if ok)
for name, ok, detail in results:
    print(f'{"PASS" if ok else "FAIL"} {name} — {detail}')
print(f'\n{npass}통과 / {len(results) - npass}실패')
sys.exit(0 if npass == len(results) else 1)
