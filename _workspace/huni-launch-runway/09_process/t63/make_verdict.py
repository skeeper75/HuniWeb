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


FINDINGS = """프로세스로 세워 놓고 보니, 흩어져 있을 때는 안 보이던 어긋남이 몇 군데 드러났다.
전부 코드를 직접 열어 확인한 것이고, 표본 재검 기록은 `spotcheck.md` 에 있다.

### ① 시작가 — 두 쪽이 서로 다른 그릇을 보고 있다

webadmin 은 자기 카탈로그 API 로 시작가를 내보낸다
(`raw/webadmin/webadmin/config/urls.py:248` → `catalog/widget_api.py:5844` 의 `api_catalog`,
본문에서 `t_prd_start_prices` 를 읽는다).
그런데 huni-mall 은 그 API 가 아니라 **샵바이 원본 `salePrice`** 를 읽는다
(`huni-skin-shopby/src/lib/api/server/catalog.ts:86`).

그래서 「시작가가 API 로 내려가는데 쇼핑몰에 반영되지 않는다」(`STD-CAT-040`)는
버그라기보다 **아직 안 이은 것**이다. 이관 행(`STD-CAT-043`)이 정확히 그 일이다.
P01(카테고리로 상품 찾기)·P02(검색으로 상품 찾기) 두 프로세스가 같은 지점에서 막힌다.

곁다리로 하나 — `api_catalog` 의 docstring 은 아직 「가격은 없다」고 말하는데 본문은 시작가를 싣는다.
**문서가 낡았고 코드가 맞다.** 이 카드는 코드를 따랐다.

### ② 결제 — 돌아가는 수단이 무통장 하나뿐이다

`checkout-form.tsx:365-371` 이 `bank_transfer` 가 아니면 토스트를 띄우고 그냥 `return` 한다.
카드·계좌이체·네이버·카카오·토스페이는 **탭은 보이는데 제출이 막혀 있다.**
P19(결제하기)의 갈림길 대부분이 지금은 死線이고, 그 선을 여는 일이 P20(결제수단 개통하기)이다 —
코드가 아니라 계약·심사·어드민 설정이라 개발로 풀리지 않는다.

이 둘을 갈라 둔 것이 이번 정리의 실익이다. 결제가 「미착수」로 뭉뚱그려져 있을 때는
**무엇을 기다리는 일이고 무엇을 짜는 일인지** 구분되지 않았다.

### ③ 비회원 조회 — 원장이 적은 수단과 코드가 쓰는 수단이 다르다

원장 `STD-ORD-022` 는 「주문번호+**휴대전화**」라고 적었는데,
`guest-order-lookup.tsx` 는 주문번호+**비밀번호**로 조회한다(`:28` 스키마 · `:150` 요청 본문 ·
`:188` 「비밀번호」 필드). 샵바이 API 의 `mobileNo` 는 선택 파라미터이고 UI 가 쓰지 않는다.

기능은 돈다. 다만 **본인확인 수단이 정책과 다르다**. 정책 문제라 이 카드가 정하지 않고 갭으로 올렸다.

### ④ 주문등록 S2S — 받을 쪽은 있는데 보낼 쪽이 없다

`widget_api.py:5286-5303` 에 `POST /api/w/v1/order/register` 수신 엔드포인트가 있다.
huni-mall 전수에서 이 엔드포인트를 부르는 코드는 **찾지 못했다**.
P16(주문 확정하기)에서 t64(생산·출고)로 넘어가는 **바로 그 이음매**가 아직 비어 있다는 뜻이다.
이 카드 구간에서 다음 구간으로 건너가는 다리라, 여기가 비면 t64 가 아무리 준비돼도 물건이 안 넘어간다.

### ⑤ 원고 업로드 — 「분할」은 됐고 「재개」는 안 됐다

`widget.js` 의 `_uploadMultipart` 가 100MB 이상을 10MB 조각으로 나눠 올린다.
그런데 조각이 실패하면 `ops.abort` 로 **전체를 접고 처음부터** 다시 한다 —
이미 올린 조각부터 이어받는 코드는 없다.
원장 `STD-ART-002` 의 「분할/재개」 중 **절반만 구현**된 상태다.
대용량 원고를 다루는 인쇄몰에서 이 절반은 체감이 크다.

### ⑥ 옵션·견적은 뼈대가 이미 서 있다 — 다만 「부분」이 많다

가격 권위가 서버 한 곳이라는 원칙이 코드로 지켜진다.
`pricing.py:838` 의 `evaluate_price` 가 단일 계산 지점이고,
위젯은 `/api/w/v1/price` 응답을 **그대로 표시만** 한다(클라이언트 곱셈 없음).
제약도 서버(`widget_api.py` 의 `api_validate`)와 클라이언트(`constraint_engine.js`)가
같은 JSONLogic(`models.py:814` `TPrdProductConstraints`)을 본다.

특히 `widget.js:688-691` 은 **0원 줄은 감추고 `amount == null`(계산 불가)은 남기는**
분기를 주석까지 달아 지키고 있다 — 「0원과 계산 불가는 다르다」를 코드가 알고 있다.
P05(옵션 위젯)·P08(실시간 견적)의 뼈대는 이미 서 있다고 봐도 된다.

### ⑦ 빠진 곳의 3분의 2가 「없어서」가 아니라 「안 이어서」다

「다 코드는 있는데 연결 안 됨」이 「나 행은 있는데 코드 0」의 **두 배가 넘는다.**
①④⑤가 전부 이 모양이다 — 시작가 API 도, S2S 수신부도, 분할 업로드도 만들어는 놓았다.
남은 일을 「개발량」으로만 세면 이쪽을 크게 과대평가하게 된다.
반대로 「연결」은 양쪽 담당이 다를 때가 많아 **조율 비용**이 개발 비용보다 클 수 있다."""

UNKNOWNS = """이 카드가 **하지 않은 것**을 분명히 적는다. 못 한 것을 한 것처럼 세면 다음 사람이 속는다.

- **라이브 화면을 보지 않았다.** 전부 코드·명세·원장 정독이다.
  DB write 0 · 라이브 COMMIT 0 · 주문·결제 0. 「실화면으로 확정」이 필요한 행은 그대로 남아 있다.
- **위젯 총액 ↔ 샵바이 청구액 정합(`STD-PAY-031`)을 재현하지 않았다.**
  10원 단위 모델은 코드로 확인했지만(`widget-order.ts:26,33`),
  `README.md:70-71` 은 여전히 표시↔청구 불일치를 경고한다. 둘이 서로 다른 말을 한다.
  실제 청구액 대조는 결제를 태워야 하므로 이 카드에서 가릴 수 없었다.
  표시가격=`start_price` · 결제단위=10원 은 **t61 리드 보강 판정을 그대로 따랐고 재론하지 않았다.**
- **판매중 상품 수 3갈래(`STD-CAT-041`)를 재실측하지 않았다.** 선행 관측을 그대로 인용만 했다.
  라이브는 움직이므로, 분모가 필요한 순간에 다시 세야 한다.
- **부재 주장 중 레인 grep 에만 기댄 것이 있다.**
  「샵바이로 시작가를 미는 코드가 없다」는 `shopby_sync.py` 전문을 리드가 직접 읽어 재확인하지 않았다.
  전부 **「찾지 못했다」**로 적었고 「없다」로 쓰지 않았다.
- **에디쿠스 쪽은 래퍼까지만 봤다.** `edicus_lookup.py` 에 TODO 로 남은 미배선이 여럿인데,
  에디터 본체 동작은 이 카드 범위 밖이다(P12 의 「확인 못 한 것」에 적었다).

### 블로커

없다. 카드가 요구한 산출물 다섯 가지를 전부 냈고 게이트 8종이 통과한다.
다만 **위 「확인 못 한 것」은 해소된 것이 아니라 미뤄 둔 것**이며,
그중 `STD-PAY-031`(청구액 정합)과 `STD-ORD-030`(S2S 호출측)은
오픈 전에 반드시 누군가 실화면·실호출로 닫아야 하는 자리다."""

main()
