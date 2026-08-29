#!/usr/bin/env python3
"""필수 공정 미반영 과소청구 실측 (M4-27).

물음: 위젯이 `proc_cd` 를 노출하지 않아, **필수 공정의 비용이 가격에서 빠지는가.**
빠진다면 고객은 그만큼 덜 낸다 — 과소청구다.

방법(반박하기 어려운 형태): 상품마다 두 번 부른다.
  base  = 위젯이 노출하는 축만 (고객이 실제로 만들 수 있는 조합)
  with  = base + 그 상품의 **필수 공정**(`mand_proc_yn='Y'`) proc_cd
  차액   = with − base  ... 0보다 크면 그 금액이 고객 청구에서 빠지고 있다.

차액이 0이면 결함이 아니다 — 엔진이 필수 공정을 스스로 반영했거나 그 공정이 무료다.

[한계] API 는 `proc_cd` 를 하나만 받는다. 필수 공정이 여럿이면 각각 따로 재고
       합산은 추정으로만 적는다(동시 적용은 미검증).

라이브 읽기 전용 (가격조회·설정조회). 쓰기 0.
"""
import csv
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request

HERE = '_workspace/postersign-audit'
API = 'https://huni-admin.printly.co.kr/api/w/v1/price'
WAPI = 'https://huni-admin.printly.co.kr/api/w/v1/widgets'
UA = ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/131.0 Safari/537.36')


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
         '-A', '-F', '\t', '-t', '-c', sql],
        env=e, capture_output=True, text=True, check=True).stdout
    return [ln.split('\t') for ln in out.splitlines() if ln.strip()]


def call(site_key, wgt, sel, qty, depth=0):
    body = json.dumps({'site_key': site_key, 'wgt_cd': wgt,
                       'qty': qty, 'selections': sel}).encode()
    req = urllib.request.Request(API, data=body, method='POST', headers={
        'Content-Type': 'application/json', 'Origin': 'http://localhost',
        'User-Agent': UA})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            d = json.load(r)
    except urllib.error.HTTPError as ex:
        try:
            d = json.load(ex)
        except Exception:
            return None, f'http{ex.code}', qty, []
    except Exception as ex:
        return None, type(ex).__name__, qty, []
    if not d.get('ok'):
        err = d.get('error') or '; '.join(d.get('errors') or []) or d.get('code', '')
        if depth < 2:
            # 수량 규칙은 상품 규칙이지 가격 결함이 아니다. 문구 3종을 모두 잡는다.
            m = (re.search(r'최소 주문수량은\s*(\d+)', err)
                 or re.search(r'수량은 최소\s*(\d+)', err)
                 or re.search(r'수량은\s*(\d+)\s*단위', err))
            if m:
                n = int(m.group(1))
                return call(site_key, wgt, sel, max(n, (qty // n + 1) * n), depth + 1)
        return None, err[:80], qty, []
    return d.get('total'), '', qty, d.get('components', [])


def widget_axes(site_key, wgt):
    req = urllib.request.Request(f'{WAPI}/{wgt}?site_key={site_key}',
                                 headers={'User-Agent': UA, 'Origin': 'http://localhost'})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            d = json.load(r)
        return {i['ref_key'] for i in d['widget']['cfg']['items']
                if i.get('ref_key') and i.get('visible_yn') == 'Y'}
    except Exception:
        return set()


def main():
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]

    # 필수 공정을 가진 게시 상품
    tgt = psql(e, """
      SELECT DISTINCT w.wgt_cd, p.prd_cd, p.prd_nm
      FROM t_prd_product_processes pp
      JOIN t_prd_products p ON p.prd_cd=pp.prd_cd
      JOIN t_wgt_widgets w ON w.prd_cd=p.prd_cd AND w.sts_typ_cd='WGT_STS_TYPE.02'
                          AND w.use_yn='Y' AND COALESCE(w.del_yn,'N')<>'Y'
      WHERE pp.mand_proc_yn='Y' AND COALESCE(pp.del_yn,'N')<>'Y'
        AND p.use_yn='Y' AND COALESCE(p.del_yn,'N')<>'Y'
      ORDER BY p.prd_cd;""")

    mand = {}
    for prd, pc, pn in psql(e, """
      SELECT pp.prd_cd, pp.proc_cd, COALESCE(pr.proc_nm,'?')
      FROM t_prd_product_processes pp LEFT JOIN t_proc_processes pr ON pr.proc_cd=pp.proc_cd
      WHERE pp.mand_proc_yn='Y' AND COALESCE(pp.del_yn,'N')<>'Y' ORDER BY pp.prd_cd, pp.disp_seq;"""):
        mand.setdefault(prd, []).append((pc, pn))

    pick = {}
    for prd, k, v in psql(e, """
      SELECT prd_cd, 'siz_cd', siz_cd FROM (
        SELECT ps.prd_cd, ps.siz_cd, ROW_NUMBER() OVER (PARTITION BY ps.prd_cd ORDER BY ps.disp_seq) rn
        FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
        WHERE COALESCE(ps.del_yn,'N')<>'Y' AND COALESCE(s.use_yn,'Y')='Y' AND COALESCE(s.del_yn,'N')<>'Y') t
      WHERE rn=1
      UNION ALL
      SELECT prd_cd, 'mat_cd', mat_cd FROM (
        SELECT pm.prd_cd, pm.mat_cd, ROW_NUMBER() OVER (PARTITION BY pm.prd_cd ORDER BY pm.disp_seq) rn
        FROM t_prd_product_materials pm
        WHERE pm.cust_sel_yn='Y' AND COALESCE(pm.del_yn,'N')<>'Y') t2 WHERE rn=1
      UNION ALL
      SELECT prd_cd, 'print_opt_cd', print_opt_cd FROM (
        SELECT po.prd_cd, po.print_opt_cd, ROW_NUMBER() OVER (PARTITION BY po.prd_cd ORDER BY po.print_opt_cd) rn
        FROM t_prd_product_print_options po) t3 WHERE rn=1;"""):
        pick.setdefault(prd, {})[k] = v

    out = []
    for wgt, prd, pnm in tgt:
        wax = widget_axes(site_key, wgt)
        sel = {k: v for k, v in pick.get(prd, {}).items() if k in wax}
        base, err, q, comps = call(site_key, wgt, sel, 1)
        if base is None:
            out.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt, proc_cd='', proc_nm='',
                            qty='', base='', withproc='', gap='', verdict='BASE-FAIL',
                            note=err, base_comps=''))
            continue
        bn = ','.join(c['name'] for c in comps)
        for pc, pn in mand.get(prd, []):
            wp, err2, q2, comps2 = call(site_key, wgt, dict(sel, proc_cd=pc), q)
            if wp is None:
                v, gap = 'WITH-FAIL', ''
            else:
                gap = wp - base
                v = 'UNDERCHARGE' if gap > 0 else ('OK' if gap == 0 else 'NEGATIVE-GAP')
            out.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt, proc_cd=pc, proc_nm=pn,
                            qty=q, base=base, withproc=wp if wp is not None else '',
                            gap=gap, verdict=v, note=err2 if wp is None else '',
                            base_comps=bn))

    p = f'{HERE}/mandatory-proc-gap-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    from collections import Counter
    print(f'대상(필수공정 보유 게시상품) {len({r["prd_cd"] for r in out})} · 검사 {len(out)}쌍')
    print('판정:', dict(Counter(r['verdict'] for r in out)))
    uc = [r for r in out if r['verdict'] == 'UNDERCHARGE']
    if uc:
        uc.sort(key=lambda r: -r['gap'])
        print(f'\n--- 과소청구 {len(uc)}건 · 영향 상품 {len({r["prd_cd"] for r in uc})} ---')
        print(f'{"prd_cd":<12}{"상품":<18}{"필수공정":<18}{"qty":>6}{"현재":>10}{"정상":>10}{"누락":>10}')
        for r in uc:
            print(f'{r["prd_cd"]:<12}{r["prd_nm"][:16]:<18}{r["proc_nm"][:16]:<18}'
                  f'{r["qty"]:>6}{r["base"]:>10,}{r["withproc"]:>10,}{r["gap"]:>10,}')
    print('\n산출:', p)


if __name__ == '__main__':
    sys.exit(main())
