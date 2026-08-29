#!/usr/bin/env python3
"""게시 위젯 0원·음수 가격 전수 스캔 (M4-26).

물음은 「게시된 위젯에서 0원이나 음수 가격이 나오는 것이 있는가」다.
DB 층(단가행)은 별도로 확인했고, 여기서는 **실제 가격 API 응답**을 본다.

각 게시 위젯을 대표 조합(첫 사이즈 · 첫 자재)으로 호출해 total 을 본다.

  ZERO      total == 0        <- 돈을 못 받는다. 결함 후보
  NEGATIVE  total < 0         <- 돈을 돌려준다. 결함 후보
  OK        total > 0
  ERR       가격이 안 나온다   <- 0원과 다른 문제. 별도 집계

[한계] 상품당 대표 조합 1건이다. 모든 조합을 도는 것이 아니므로
       「어떤 조합에서도 0원이 안 난다」를 증명하지는 않는다.

라이브 읽기 전용 (가격 조회만). 쓰기 0.
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
         '-A', '-F', '|', '-t', '-c', sql],
        env=e, capture_output=True, text=True, check=True).stdout
    return [ln.split('|') for ln in out.splitlines() if ln.strip()]


def price(site_key, wgt, sel, qty=1, depth=0):
    body = json.dumps({'site_key': site_key, 'wgt_cd': wgt,
                       'qty': qty, 'selections': sel}).encode()
    req = urllib.request.Request(API, data=body, method='POST', headers={
        'Content-Type': 'application/json', 'Origin': 'http://localhost',
        'User-Agent': UA})                 # UA 없으면 CDN 이 1010 으로 403
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            d = json.load(r)
    except urllib.error.HTTPError as ex:
        try:
            d = json.load(ex)
        except Exception:
            return None, f'http{ex.code}', qty
    except Exception as ex:
        return None, type(ex).__name__, qty
    if not d.get('ok'):
        err = d.get('error') or '; '.join(d.get('errors') or []) or d.get('code', 'not-ok')
        # 최소 주문수량은 상품 규칙이지 가격 결함이 아니다. 문구가 두 가지라 둘 다 잡는다
        # (「최소 주문수량은 N」 / 「수량은 최소 N 이상이어야 합니다」).
        m = re.search(r'최소 주문수량은\s*(\d+)', err) or re.search(r'수량은 최소\s*(\d+)', err)
        if m and depth == 0:
            return price(site_key, wgt, sel, qty=int(m.group(1)), depth=1)
        return None, err[:90], qty
    return d.get('total'), '', qty


def main():
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]

    # 분모는 매번 다시 잰다 — 문서 숫자를 인용하지 않는다 (AC-PC-025)
    widgets = psql(e, """
      SELECT w.wgt_cd, w.prd_cd, p.prd_nm FROM t_wgt_widgets w
      JOIN t_prd_products p ON p.prd_cd=w.prd_cd
      WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND w.use_yn='Y' AND COALESCE(w.del_yn,'N')<>'Y'
        AND p.use_yn='Y' AND COALESCE(p.del_yn,'N')<>'Y'
      ORDER BY w.prd_cd;""")

    sizes, mats = {}, {}
    for prd, siz in psql(e, """
      SELECT ps.prd_cd, ps.siz_cd FROM t_prd_product_sizes ps
      JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
      WHERE COALESCE(ps.del_yn,'N')<>'Y'
        AND COALESCE(s.use_yn,'Y')='Y' AND COALESCE(s.del_yn,'N')<>'Y'
      ORDER BY ps.prd_cd, ps.disp_seq;"""):
        sizes.setdefault(prd, []).append(siz)
    for prd, mat in psql(e, """
      SELECT pm.prd_cd, pm.mat_cd FROM t_prd_product_materials pm
      WHERE pm.cust_sel_yn='Y' AND COALESCE(pm.del_yn,'N')<>'Y'
      ORDER BY pm.prd_cd, pm.disp_seq;"""):
        mats.setdefault(prd, []).append(mat)

    rows = []
    for wgt, prd, pnm in widgets:
        sel = {}
        if sizes.get(prd):
            sel['siz_cd'] = sizes[prd][0]
        if mats.get(prd):
            sel['mat_cd'] = mats[prd][0]
        total, err, q = price(site_key, wgt, sel)
        if total is None:
            v = 'ERR'
        elif total < 0:
            v = 'NEGATIVE'
        elif total == 0:
            v = 'ZERO'
        else:
            v = 'OK'
        rows.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt,
                         siz_cd=sel.get('siz_cd', ''), mat_cd=sel.get('mat_cd', ''),
                         qty=q, total=total if total is not None else '',
                         verdict=v, err=err))

    p = f'{HERE}/zero-price-scan-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)

    from collections import Counter
    print(f'게시 위젯 분모(재실측) = {len(widgets)}')
    print('판정:', dict(Counter(r['verdict'] for r in rows)))
    for tag, title in (('NEGATIVE', '음수 가격'), ('ZERO', '0원 가격'), ('ERR', '가격 미산출')):
        sel2 = [r for r in rows if r['verdict'] == tag]
        if not sel2:
            continue
        print(f'\n--- {title} {len(sel2)}건 ---')
        for r in sel2:
            print(f'  {r["prd_cd"]} {r["prd_nm"][:20]:<22} qty={r["qty"]:<6}'
                  f'total={str(r["total"]):<10} {r["err"][:70]}')
    print('\n산출:', p)


if __name__ == '__main__':
    sys.exit(main())
