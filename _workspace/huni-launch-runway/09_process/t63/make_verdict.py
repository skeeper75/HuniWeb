#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verdict.md 생성 — 숫자는 전부 산출물에서 센다(손으로 적지 않는다)."""
import csv, os, subprocess, sys
from collections import Counter, OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import processes_def as D


def rd(n):
    return list(csv.DictReader(open(os.path.join(HERE, n))))


def main():
    scope = rd('scope.csv')
    tree = rd('process-tree.csv')
    gaps = rd('gaps.csv')
    bnd = rd('boundary-t64.csv')

    ev = {}
    lanes = OrderedDict()
    for n in ['ev-cat.csv', 'ev-opt.csv', 'ev-ord.csv', 'ev-pay.csv']:
        p = os.path.join(HERE, n)
        if not os.path.isfile(p):
            lanes[n] = None
            continue
        rows = rd(n)
        lanes[n] = Counter(r['found'].strip().upper() for r in rows)
        for r in rows:
            ev[r['row_id']] = r

    unconf = [r for r in tree if r['row_id'] and '미확인' in r['근거']]
    conf = [r for r in tree if r['row_id'] and '미확인' not in r['근거']]
    gk = Counter(g['종류'] for g in gaps)
    by_dae = Counter(r['L1_대분류'] for r in tree if r['row_id'])
    sysc = Counter(r['시스템'] for r in tree if r['row_id'])
    owner = Counter(r['담당자'] for r in tree if r['row_id'])

    vout = subprocess.run([sys.executable, os.path.join(HERE, 'verify.py')],
                          capture_output=True, text=True, cwd=HERE)
    verify_txt = (vout.stdout or '') + (vout.stderr or '')

    L = []
    A = L.append
    A('# t63 verdict — 탐색~결제 프로세스 정리 B\n')
    A('> 카드 t63 · 브랜치 `WT-process-order` · Class C(plan 생략 · 레인 단독 완주) · 탑다운 L0→L4\n')

    A('## 1. 한 일\n')
    A('쇼핑몰 기능목록에서 **손님이 상품을 찾아 결제하기까지의 프로세스를 전부 뽑아**, '
      '프로세스마다 흐름·갈림길·단계·빠진 곳을 원장 행과 코드 근거에 붙였다.\n')
    A(f'- L0 = {D.L0["name"]}')
    A(f'- 이 카드가 맡은 구간 = 탐색~결제. 앞뒤는 t62·t64·t65 가 맡는다.')
    A(f'- L1 대분류 {len(by_dae)} → L3 프로세스 **{len(D.PROCESSES)}** → L4 단계 **{len(tree)}**\n')

    A('## 2. 숫자\n')
    A('| 항목 | 값 |')
    A('|---|---|')
    A(f'| 담당 기능 행(원장 735행에서 잘라낸 분모) | **{len(scope)}** |')
    A(f'| 프로세스(L3) | **{len(D.PROCESSES)}** |')
    A(f'| 단계(L4 · 원장 행 + 원장에 없는 흐름 단계) | **{len(tree)}** |')
    A(f'| **미귀속 행** | **{len(scope) - len({r["row_id"] for r in tree if r["row_id"]})}** |')
    A(f'| 코드·명세 근거를 붙인 행 | {len(conf)} |')
    A(f'| 「미확인」으로 남긴 행 | {len(unconf)} |')
    A(f'| 빠진 곳(gaps.csv) | {len(gaps)} |')
    A(f'| t64 경계 행(담당 밖으로 뺀 것) | {len(bnd)} |')
    A('')
    A('**대분류별 행수**  ' + ' · '.join(f'{k} {v}' for k, v in by_dae.most_common()) + '\n')
    A('**빠진 곳 4종**  ' + ' · '.join(f'{k} {v}' for k, v in sorted(gk.items())) + '\n')
    A('**시스템별**  ' + ' · '.join(f'{k} {v}' for k, v in sysc.most_common()) + '\n')
    A('**담당자별(원장 owner_proposed 그대로)**  '
      + ' · '.join(f'{k} {v}' for k, v in owner.most_common(10)) + '\n')

    A('## 3. 산출물\n')
    A('| 파일 | 무엇 |')
    A('|---|---|')
    A('| `process-tree.csv` | L0→L4 나무. 담당 행이 전부 프로세스에 귀속됐는지 이 파일로 센다 |')
    A('| `processes/P01~P24-*.md` | 프로세스마다 고정 7절(정의·sequence·flowchart·단계표·빠진 곳·채우는 법·확인 못 한 것) |')
    A('| `index.html` | L0→L3 나무 + 프로세스별 그림을 한 화면에서 보는 단일 파일(mermaid) |')
    A('| `gaps.csv` | 빠진 곳 4종 원장 |')
    A('| `scope.csv` · `boundary-t64.csv` | 담당 분모와 t64 경계 |')
    A('| `verify.py` | 게이트 8종 검산 |')
    A('| `spotcheck.md` | 조사 레인 주장을 리드가 직접 열어 확인한 표본 재검 |')
    A('| `build.py` · `processes_def.py` · `build_scope.py` · `collect_evidence.py` · `evidence_norm.py` | 재생성 도구 |')
    A('')

    A('## 4. STD-ART 경계 행 — t64(lane-4)로 넘기는 목록\n')
    A('카드 지시대로 t64 와 겹치지 않게 **행 단위로** 갈랐다. '
      '이 카드는 원고의 **고객 쪽**(업로드·미리보기·에디터·보관)만 맡고, '
      '**검판(C4)·생산연계(C5)·PitStop** 은 t64 가 맡는다.\n')
    A(f'### t64 로 넘긴 {len(bnd)}행\n')
    A('| row_id | 중분류 | 기능 | 담당자 | 상태 |')
    A('|---|---|---|---|---|')
    for r in bnd:
        A(f"| `{r['row_id']}` | {r['jungbun'] or '(원장에만 있는 행)'} | {r['title']} "
          f"| {r['owner']} | {r['status']} |")
    A('')
    mine_art = [r for r in scope if r['row_id'].startswith('STD-ART')]
    A(f'### 이 카드가 갖는 STD-ART {len(mine_art)}행\n')
    A('| row_id | 기능 | 프로세스 |')
    A('|---|---|---|')
    pof = {r['row_id']: f"{r['L3_프로세스']} {r['L3_프로세스명']}" for r in tree if r['row_id']}
    for r in mine_art:
        A(f"| `{r['row_id']}` | {r['title']} | {pof.get(r['row_id'], '')} |")
    A('')
    A('**경계에서 손이 스치는 두 곳** — 행은 갈랐지만 흐름은 이어지므로 양쪽이 알고 있어야 한다.\n')
    A('- `STD-ART-015`(검판 결과 리포트 **고객 노출**)·`STD-ART-018`(재업로드 요청 발송)은 '
      '화면이 고객 쪽이지만 값을 만드는 곳이 검판이다 → **t64 가 갖는다**. '
      '이 카드의 P11(올린 원고 확인하기)에서 t64 로 넘어가는 지점으로만 표시했다.')
    A('- `STD-SHP-012`·`STD-SHP-013`(송장 등록·일괄 상태변경)은 배송(이 카드) 분모에 있으나 '
      '운영자 출고 동선이라 t64 의 「출고·추적」과 만난다 → **이 카드가 행을 갖고**, '
      'P23 의 cross 에 t64 를 적었다. t64 는 같은 행을 다시 만들지 말고 이 카드를 가리키면 된다.\n')

    A('## 5. 검산\n')
    A('```')
    A('$ python3 verify.py')
    A(verify_txt.rstrip())
    A('```\n')
    A('게이트 뜻: G1 미귀속 0 · G2 나무 행수 정합 · G3 문서 7절 · G4 그림 2종 · '
      'G5 갭 4종 · **G6 단계표에 적힌 `path:line` 을 전수 열어 실재 확인** · '
      'G7 t64 경계 분리 · G8 화면 pane.\n')
    A('레인 조사본 집계')
    A('')
    A('| 파일 | found=Y | found=N |')
    A('|---|---|---|')
    for n, c in lanes.items():
        A(f"| `{n}` | {c['Y'] if c else '—'} | {c['N'] if c else '—'} |")
    A('')

    A('## 6. 이번에 알게 된 것\n')
    A(FINDINGS + '\n')

    A('## 7. 확인 못 한 것 · 블로커\n')
    A(UNKNOWNS + '\n')

    A('## 8. 지킨 경계\n')
    A('- 원장 735행에 **새 행을 섞지 않았다**. 흐름상 필요한데 행이 없는 7건은 '
      '`gaps.csv` 의 「가 원장에 행 없음」 제안으로만 남겼다.')
    A('- DB write 0 · 라이브 COMMIT 0 · 푸시 0. 읽기와 이 폴더 쓰기만 했다.')
    A('- 「없다」는 쓰지 않았다. 다 뒤지고도 못 찾은 것은 **「찾지 못했다」/「미확인」**이다.')
    A('- huni-mall 은 독립몰(headless)로만 불렀다 — 「스킨」을 쓰지 않았다.')
    A('- 담당자는 t56 `rejudge.csv`(a83dc44b)의 `owner_proposed` 를 그대로 옮겼고, '
      '이 카드에서 배정을 바꾸지 않았다.')
    A('- 생성≠검증: 코드 증거는 조사 레인이 모으고, 판정에 무게가 실리는 것은 '
      '리드가 직접 열어 재검했다(`spotcheck.md`).')
    open(os.path.join(HERE, 'verdict.md'), 'w').write('\n'.join(L) + '\n')
    open(os.path.join(HERE, 'verify-result.txt'), 'w').write(verify_txt)
    print(f'verdict.md · verify-result.txt 작성 · 프로세스 {len(D.PROCESSES)} · '
          f'단계 {len(tree)} · 갭 {len(gaps)}')


FINDINGS = """(빌드 후 채움)"""
UNKNOWNS = """(빌드 후 채움)"""

main()
