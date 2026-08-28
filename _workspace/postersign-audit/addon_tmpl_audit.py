#!/usr/bin/env python3
"""추가상품 템플릿 단가 전수 대조 (M4-23).

권위 두 곳 (하나가 아니다)
  ① 상품마스터 260822_1 「상품악세사리(가격포함)」 — 상품명(C)+사양(E)+가격(I). C는 병합셀.
  ② 가격표 260822_1 「포스터사인」 우측 c10/c11 — 배너 추가옵션(거치대), 우드봉+면끈,
     일반현수막 가공/추가옵션. A열 블록만 훑으면 통째로 놓친다.
  [HARD] 상품마스터 「실사」 c25/c26 은 STALE — 쓰지 않는다 (§ load_authority 주석).
라이브 = t_prd_templates x t_prd_template_prices.

대조 축
  P1 단가 부재    — 살아있는 템플릿에 t_prd_template_prices 행이 없다
  P2 단가 불일치  — 권위와 값이 다르다
  P3 권위 미대응  — 권위에서 짝을 못 찾았다 (대조 불가. 결함 아님, 미판정)
  P4 base 죽음    — base_prd_cd 가 삭제/미사용
  P5 고아 템플릿  — 어느 상품에도 addon 으로 안 붙었다 (도달 불가)

라이브 읽기 전용. 쓰기 0.
"""
import csv
import os
import re
import subprocess
import sys

import openpyxl

HERE = '_workspace/postersign-audit'
XLSX = 'docs/huni/후니프린팅_상품마스터_260822_1.xlsx'
SHEET = '상품악세사리(가격포함)'
PRICE_XLSX = 'docs/huni/후니프린팅_인쇄상품_가격표_260822_1.xlsx'


def env():
    e = dict(os.environ)
    for line in open('.env.local', encoding='utf-8'):
        if '=' in line and not line.lstrip().startswith('#'):
            k, _, v = line.partition('=')
            e.setdefault(k.strip(), v.strip().strip('"').strip("'"))
    e['PGPASSWORD'] = e['RAILWAY_DB_PASSWORD']
    return e


def psql(e, sql):
    out = subprocess.run(
        ['psql', '-h', e['RAILWAY_DB_HOST'], '-p', e['RAILWAY_DB_PORT'],
         '-U', e['RAILWAY_DB_USER'], '-d', e['RAILWAY_DB_NAME'],
         '-A', '-F', '|', '-t', '-c', sql],
        env=e, capture_output=True, text=True, check=True).stdout
    return [ln.split('|') for ln in out.splitlines() if ln.strip()]


def norm(s):
    """대조 키. 공백/괄호/구분자를 죽이고 소문자화한다."""
    return re.sub(r'[\s()\[\]/,.+·\-_]', '', (s or '')).lower()


def nums(s):
    """숫자 시퀀스. 사양은 대부분 치수·수량으로 식별된다 (270mm, 165x115, 50장)."""
    return tuple(int(x) for x in re.findall(r'\d+', s or ''))


def hangul(s):
    return set(re.findall(r'[가-힣]', s or ''))


def fuzzy(live_nm, auth):
    """이름 표기가 어긋난 짝을 찾는다.

    라이브와 권위는 같은 물건을 다르게 적는다 — 「트레싱지봉투」/「트래싱지 카드봉투」,
    「칼라볼체인」/「볼체인」, 「투명PP케이스」/「투명케이스 PP투명케이스 …」.
    그래서 표기가 아니라 (숫자 시퀀스 + 한글 글자 겹침)으로 짝을 찾는다.
    숫자가 다르면 다른 사양이므로 후보에서 뺀다 — 값이 다른 짝을 잘못 붙이면
    「단가 불일치」라는 없는 결함을 만든다.
    """
    ln, lh = nums(live_nm), hangul(live_nm)
    best, best_score = None, 0.0
    for a in auth:
        text = a['name'] + ' ' + a['spec']
        if nums(text) != ln:
            continue                       # 숫자 불일치 = 다른 사양
        ah = hangul(text)
        if not (lh | ah):
            continue
        score = len(lh & ah) / max(len(lh | ah), 1)
        if score > best_score:
            best, best_score = a, score
    # 한글이 절반 이상 겹쳐야 같은 물건으로 본다 (오타/접두어 차이는 통과)
    return best if best_score >= 0.5 else None


def load_authority():
    wb = openpyxl.load_workbook(XLSX, data_only=True, read_only=True)
    ws = wb[SHEET]
    rows, cur = [], ''
    for r, row in enumerate(ws.iter_rows(values_only=True), 1):
        if r <= 2:
            continue
        nm = (str(row[3]).strip() if len(row) > 3 and row[3] is not None else '')
        spec = (str(row[4]).strip() if len(row) > 4 and row[4] is not None else '')
        price = row[8] if len(row) > 8 else None
        if nm:
            cur = nm                      # 병합셀 forward-fill
        if not cur or not spec or price in (None, ''):
            continue
        try:
            p = float(str(price).replace(',', ''))
        except ValueError:
            continue
        rows.append(dict(row=r, name=cur, spec=spec, price=p))

    # 권위는 한 시트가 아니다. 추가옵션·가공옵션 단가는 가격표 「포스터사인」 시트의
    # 우측 열(c10 옵션명 / c11 가격)에 별도 블록으로 있다 — 배너 추가옵션(거치대),
    # 우드봉+면끈, 일반현수막 가공/추가옵션 등.
    #
    # [HARD] 상품마스터 「실사」 시트 c25/c26 에도 같은 항목이 있으나 STALE 하다.
    # 실측: 실내용배너거치대가 실사 c26 은 10,000, 가격표는 7,000, 라이브는 7,000.
    # 실사 시트를 권위로 삼으면 「3,000원 과소청구」라는 없는 결함이 만들어진다.
    # 가격 사안의 권위는 가격표다. 실사 시트는 읽지 않는다.
    wb2 = openpyxl.load_workbook(PRICE_XLSX, data_only=True, read_only=True)
    ws2 = wb2['포스터사인']
    for r, row in enumerate(ws2.iter_rows(values_only=True), 1):
        nm2 = (str(row[9]).strip() if len(row) > 9 and row[9] is not None else '')
        val = row[10] if len(row) > 10 else None
        if not nm2 or val in (None, ''):
            continue
        try:
            p = float(str(val).replace(',', ''))
        except ValueError:
            continue                       # 헤더행(「추가옵션명」 등)은 여기서 걸러진다
        if p == 0:
            continue                       # 「거치대없음 0」은 옵션 부재이지 단가가 아니다
        rows.append(dict(row=f'가격표!포스터사인!{r}', name=nm2, spec=nm2, price=p))

    # ③ 굿즈류(워터북보틀·규조토코스터 등)의 권위는 상품마스터 「굿즈파우치(가격포함)」.
    #    c4 상품명(병합) / c5 사양 / c18 가격.
    ws3 = wb['굿즈파우치(가격포함)']
    cur3 = ''
    for r, row in enumerate(ws3.iter_rows(values_only=True), 1):
        nm3 = (str(row[3]).strip() if len(row) > 3 and row[3] is not None else '')
        spec3 = (str(row[4]).strip() if len(row) > 4 and row[4] is not None else '')
        val = row[17] if len(row) > 17 else None
        if nm3:
            cur3 = nm3                     # 병합셀 forward-fill
        if not cur3 or not spec3 or val in (None, ''):
            continue
        try:
            p = float(str(val).replace(',', ''))
        except ValueError:
            continue
        rows.append(dict(row=f'굿즈파우치!{r}', name=cur3, spec=spec3, price=p))
    return rows


def main():
    e = env()
    auth = load_authority()

    # 권위 인덱스 — 이름+사양 결합키와 사양 단독키 둘 다 만든다
    by_pair, by_spec = {}, {}
    for a in auth:
        by_pair.setdefault(norm(a['name'] + a['spec']), []).append(a)
        by_spec.setdefault((norm(a['name']), norm(a['spec'])), []).append(a)

    live = psql(e, """
      SELECT t.tmpl_cd, t.tmpl_nm, t.base_prd_cd,
             COALESCE(b.prd_nm,''),
             CASE WHEN b.prd_cd IS NULL THEN 'MISSING'
                  WHEN b.use_yn<>'Y' OR COALESCE(b.del_yn,'N')='Y' THEN 'DEAD'
                  ELSE 'LIVE' END,
             COALESCE((SELECT MAX(p.unit_price)::text FROM t_prd_template_prices p
                       WHERE p.tmpl_cd=t.tmpl_cd),''),
             COALESCE((SELECT COUNT(*)::text FROM t_prd_template_prices p
                       WHERE p.tmpl_cd=t.tmpl_cd),'0'),
             COALESCE((SELECT COUNT(*)::text FROM t_prd_product_addons a
                       WHERE a.tmpl_cd=t.tmpl_cd),'0'),
             COALESCE(t.combo_yn,'N'),
             CASE WHEN EXISTS (SELECT 1 FROM t_prd_product_price_formulas f
                               WHERE f.prd_cd=t.base_prd_cd) THEN 'Y' ELSE 'N' END
      FROM t_prd_templates t
      LEFT JOIN t_prd_products b ON b.prd_cd=t.base_prd_cd
      WHERE t.use_yn='Y' AND COALESCE(t.del_yn,'N')<>'Y'
      ORDER BY t.tmpl_cd;""")

    # 선행 1회: 근사매칭이 권위 어느 행에 몇 건을 붙이는지 센다 (모호 판정용)
    fuzzy_hits = {}
    for row in live:
        nm = row[1]
        if norm(nm) in by_pair:
            continue
        f = fuzzy(nm, auth)
        if f:
            fuzzy_hits[f['row']] = fuzzy_hits.get(f['row'], 0) + 1

    out = []
    for tmpl, nm, base, bnm, bstate, price, prows, links, combo, bfrm in live:
        prows, links = int(prows), int(links)
        lp = float(price) if price else None
        key = norm(nm)
        cand = by_pair.get(key)
        if not cand:
            # 템플릿명이 "이름(사양)" 형태면 쪼개서 다시 시도
            m = re.match(r'^(.*?)\s*[（(](.*)[）)]\s*$', nm)
            if m:
                cand = by_spec.get((norm(m.group(1)), norm(m.group(2))))
        how = 'exact' if cand else ''
        if not cand:
            f = fuzzy(nm, auth)
            if f:
                cand, how = [f], 'fuzzy'
        ap = cand[0]['price'] if cand else None
        arow = cand[0]['row'] if cand else ''

        flags = []
        # 단가 부재는 그 자체로 결함이 아니다. 조합형(combo_yn='Y')이면서 base 에
        # 가격공식이 있으면 계산을 base 에 위임하는 정상 형태다. 가격이 나올 길이
        # 아예 없는 경우(비조합 + base 공식 없음)만 결함으로 센다.
        if prows == 0:
            if combo == 'Y' and bfrm == 'Y':
                flags.append('N1 단가없음(base계산 위임)')
            else:
                flags.append('P1 가격경로없음')
        if ap is not None and lp is not None and abs(ap - lp) > 0.001:
            # 근사매칭이 권위 한 행에 라이브 여러 건을 붙였다면 그 불일치는
            # 매칭이 만든 가짜일 수 있다 (권위 「실외용배너거치대」 1행에 라이브
            # 단면·양면 2건). 값 차이를 결함으로 굳히지 않고 모호로 보류한다.
            if how == 'fuzzy' and fuzzy_hits.get(arow, 0) > 1:
                flags.append(f'A1 모호매칭(권위 1행에 {fuzzy_hits[arow]}건 — 판정보류)')
            else:
                flags.append(f'P2 불일치(권위 {ap:,.0f} vs 라이브 {lp:,.0f})')
        if ap is None and prows > 0:
            flags.append('P3 권위미대응')
        # base 가 죽어도 템플릿에 단가가 있으면 가격은 정상으로 나온다 — 실증했다
        # (TMPL-000096 천정고리: base use_yn='N' 인데 addon amount 6,500 정상 반환).
        # 그러므로 base 죽음은 단가가 없을 때만 가격 결함이 된다.
        if bstate != 'LIVE':
            flags.append(f'{"P4" if prows == 0 else "N2"} base{bstate}'
                         + ('' if prows == 0 else '(단가보유·가격정상)'))
        if links == 0:
            flags.append('P5 고아')

        codes = {f[:2] for f in flags}
        if not flags:
            v = 'OK'
        elif codes & {'P1', 'P2', 'P4'}:
            v = 'DEFECT'
        elif codes & {'A1'} or 'P3' in codes:
            v = 'UNVERIFIED'
        else:
            v = 'OK-주의'          # N1(정상 위임) 또는 P5(고아)만 붙은 경우

        out.append(dict(tmpl_cd=tmpl, tmpl_nm=nm, base_prd_cd=base, base_nm=bnm,
                        base_state=bstate, combo_yn=combo, base_formula=bfrm,
                        live_price=lp if lp is not None else '',
                        price_rows=prows, addon_links=links,
                        auth_price=ap if ap is not None else '', auth_row=arow,
                        match=how, verdict=v, flags='; '.join(flags)))

    p = f'{HERE}/addon-tmpl-audit-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    from collections import Counter
    print(f'권위 행 {len(auth)} · 살아있는 템플릿 {len(out)}')
    print('판정:', dict(Counter(r['verdict'] for r in out)))
    print()
    print('매칭:', dict(Counter(r['match'] or '(없음)' for r in out)))
    print()
    for tag, title in (('DEFECT', '결함'), ('UNVERIFIED', '미판정(권위 미대응)'), ('OK-주의', '주의(정상 위임/고아)')):
        sel = [r for r in out if r['verdict'] == tag]
        if not sel:
            continue
        print(f'--- {title} {len(sel)}건 ---')
        for r in sel[:40]:
            print(f'  {r["tmpl_cd"]:<14}{r["tmpl_nm"][:26]:<28}'
                  f'라이브 {str(r["live_price"]):>10}  권위 {str(r["auth_price"]):>10}  {r["flags"]}')
        if len(sel) > 40:
            print(f'  … 외 {len(sel)-40}건 (CSV 참조)')
        print()
    print('산출:', p)


if __name__ == '__main__':
    sys.exit(main())
