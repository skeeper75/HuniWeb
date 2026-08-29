#!/usr/bin/env python3
"""게시 위젯 0원·음수 2차 스캔 — 실재 단가행 기반 (M4-26b).

1차(zero_price_scan.py)는 대표 조합(첫 사이즈·첫 자재)만 줘서 ERR 30건이 났다.
그 대부분은 결함이 아니라 **내가 안 준 축**(bdl_qty·print_opt_cd·proc_cd·opt_cd) 탓이었다.

2차는 반대로 간다: 각 상품 본품 구성요소의 **실재하는 단가행 한 줄을 골라
그 행의 축 값을 그대로** selections 에 싣는다. 그 조합은 정의상 단가가 존재하므로
**가격이 나오지 않거나 0원이면 그것은 도구 탓이 아니라 결함**이다.

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
# 단가행 컬럼 -> selections 키 (그대로 실어야 매칭된다)
AXES = ['siz_cd', 'mat_cd', 'bdl_qty', 'print_opt_cd', 'proc_cd', 'opt_cd',
        'clr_cd', 'plt_siz_cd', 'coat_side_cnt', 'spot_side_cnt']


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


def price(site_key, wgt, sel, qty=1, depth=0):
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
            return None, f'http{ex.code}', qty
    except Exception as ex:
        return None, type(ex).__name__, qty
    if not d.get('ok'):
        err = d.get('error') or '; '.join(d.get('errors') or []) or d.get('code', 'not-ok')
        m = re.search(r'최소 주문수량은\s*(\d+)', err) or re.search(r'수량은 최소\s*(\d+)', err)
        if m and depth == 0:
            return price(site_key, wgt, sel, qty=int(m.group(1)), depth=1)
        return None, err[:100], qty
    return d.get('total'), '', qty


def main():
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]
    only = set(sys.argv[1:]) or None

    widgets = psql(e, """
      SELECT w.wgt_cd, w.prd_cd, p.prd_nm FROM t_wgt_widgets w
      JOIN t_prd_products p ON p.prd_cd=w.prd_cd
      WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND w.use_yn='Y' AND COALESCE(w.del_yn,'N')<>'Y'
        AND p.use_yn='Y' AND COALESCE(p.del_yn,'N')<>'Y'
      ORDER BY w.prd_cd;""")

    cols = ', '.join(f"COALESCE(cp.{c}::text,'') AS {c}" for c in AXES)
    # 상품별 본품(최소 disp_seq) 구성요소의 단가행 한 줄. 그 행의 축을 그대로 쓴다.
    rows_sql = psql(e, f"""
      WITH base AS (
        SELECT ppf.prd_cd, fc.comp_cd,
               ROW_NUMBER() OVER (PARTITION BY ppf.prd_cd
                                  ORDER BY COALESCE(fc.disp_seq,999), fc.comp_cd) rn
        FROM t_prd_product_price_formulas ppf
        JOIN t_prc_formula_components fc ON fc.frm_cd=ppf.frm_cd
        JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
        WHERE COALESCE(pc.use_yn,'Y')='Y'
      ), pick AS (
        SELECT b.prd_cd, b.comp_cd,
               COALESCE(cp.min_qty::text,'') AS mq, {cols},
               ROW_NUMBER() OVER (PARTITION BY b.prd_cd ORDER BY cp.comp_price_id) rn2
        FROM base b JOIN t_prc_component_prices cp ON cp.comp_cd=b.comp_cd
        WHERE b.rn=1
      )
      SELECT prd_cd, comp_cd, mq, {', '.join(AXES)} FROM pick WHERE rn2=1;""")
    axis = {r[0]: (r[1], r[2], r[3:]) for r in rows_sql}

    out = []
    for wgt, prd, pnm in widgets:
        if only and prd not in only:
            continue
        info = axis.get(prd)
        if not info:
            out.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt, comp_cd='', sel='',
                            qty='', total='', verdict='NO-PRICEROW',
                            err='본품 구성요소의 단가행을 찾지 못함'))
            continue
        comp, minq, vals = info
        sel = {}
        for k, v in zip(AXES, vals):
            if v:
                sel[k] = int(v) if k in ('bdl_qty', 'coat_side_cnt', 'spot_side_cnt') \
                    and v.isdigit() else v
        q = int(minq) if minq and minq.isdigit() and int(minq) > 0 else 1
        total, err, q2 = price(site_key, wgt, sel, qty=q)
        if total is None:
            v = 'ERR'
        elif total < 0:
            v = 'NEGATIVE'
        elif total == 0:
            v = 'ZERO'
        else:
            v = 'OK'
        out.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt, comp_cd=comp,
                        sel=json.dumps(sel, ensure_ascii=False), qty=q2,
                        total=total if total is not None else '', verdict=v, err=err))

    p = f'{HERE}/zero-price-probe2-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    from collections import Counter
    print(f'대상 위젯 {len(out)}')
    print('판정:', dict(Counter(r['verdict'] for r in out)))
    for tag, title in (('NEGATIVE', '음수'), ('ZERO', '0원'),
                       ('ERR', '가격 미산출'), ('NO-PRICEROW', '단가행 없음')):
        sel2 = [r for r in out if r['verdict'] == tag]
        if not sel2:
            continue
        print(f'\n--- {title} {len(sel2)}건 ---')
        for r in sel2:
            print(f'  {r["prd_cd"]} {r["prd_nm"][:18]:<20} {r["comp_cd"][:30]:<32}'
                  f'qty={str(r["qty"]):<6}{r["err"][:66]}')
    print('\n산출:', p)


if __name__ == '__main__':
    sys.exit(main())
