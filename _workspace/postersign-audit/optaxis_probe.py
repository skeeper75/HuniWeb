#!/usr/bin/env python3
"""옵션 가격축 조합 실호출 검증 (M4-25).

M4-24 는 옵션 단가가 권위와 같다는 것까지 확인했다(27/27). 남은 물음은
「조합에서 그 단가가 실제로 붙는가」이며, 그것은 값 대조가 아니라 실호출로만 답한다.

방법: (사이즈 × 옵션) 전수로 가격을 부르고, 같은 사이즈의 옵션-없음 기준가와의
      증분이 라이브 단가와 일치하는지 본다.

      증분 == 단가        -> OK      (그 단가가 실제로 붙었다)
      증분 == 0           -> NOEFFECT(단가는 있는데 가격에 안 붙는다 = 결함 후보)
      증분 != 단가        -> MISMATCH(다른 값이 붙는다 = 결함 후보)

[한계] API 는 opt_cd 를 하나만 받는다. 그룹코드 키 / opt_cds 배열 / addon_opt_cd /
       최상위 options 를 모두 시도했으나 두 그룹 동시 반영은 되지 않았다.
       따라서 이 검증은 「옵션 1개씩」이며, 2그룹 동시 조합은 미검증으로 남는다.

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
TARGETS = ['PRD_000124', 'PRD_000133', 'PRD_000134', 'PRD_000138', 'PRD_000139']


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


def price(site_key, wgt, sel, qty=1):
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
            return None, f'http{ex.code}'
    except Exception as ex:
        return None, type(ex).__name__
    if not d.get('ok'):
        err = '; '.join(d.get('errors') or []) or d.get('code', 'not-ok')
        # 최소 주문수량은 상품 규칙이지 가격 결함이 아니다 — 알려준 수량으로 되쏜다
        m = re.search(r'최소 주문수량은\s*(\d+)', err)
        if m and qty == 1:
            return price(site_key, wgt, sel, qty=int(m.group(1)))
        return None, err[:90]
    return d.get('total'), ''


def main():
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]
    inlist = "','".join(TARGETS)

    wgt = {p: w for w, p in psql(e, f"""
      SELECT wgt_cd, prd_cd FROM t_wgt_widgets
      WHERE prd_cd IN ('{inlist}') AND sts_typ_cd='WGT_STS_TYPE.02'
        AND use_yn='Y' AND COALESCE(del_yn,'N')<>'Y';""")}

    sizes = {}
    for prd, siz, nm in psql(e, f"""
      SELECT ps.prd_cd, ps.siz_cd, COALESCE(s.siz_nm,'')
      FROM t_prd_product_sizes ps LEFT JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
      WHERE ps.prd_cd IN ('{inlist}') AND COALESCE(ps.del_yn,'N')<>'Y'
        AND COALESCE(s.use_yn,'Y')='Y' AND COALESCE(s.del_yn,'N')<>'Y'
      ORDER BY ps.prd_cd, ps.disp_seq;"""):
        sizes.setdefault(prd, []).append((siz, nm))

    # 옵션과 그 라이브 단가. 단가가 사이즈별로 갈리는 구성요소가 있어 siz_cd 도 받는다.
    opts = {}
    for prd, grp, gnm, mand, opt, onm, siz, up in psql(e, f"""
      SELECT o.prd_cd, o.opt_grp_cd, g.opt_grp_nm, g.mand_yn, o.opt_cd, o.opt_nm,
             COALESCE(cp.siz_cd,''), COALESCE(cp.unit_price::text,'')
      FROM t_prd_product_options o
      JOIN t_prd_product_option_groups g
        ON g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd
       AND g.use_yn='Y' AND COALESCE(g.del_yn,'N')<>'Y'
      LEFT JOIN t_prc_component_prices cp ON cp.opt_cd=o.opt_cd
      WHERE o.prd_cd IN ('{inlist}') AND o.use_yn='Y' AND COALESCE(o.del_yn,'N')<>'Y'
      ORDER BY o.prd_cd, g.disp_seq, o.disp_seq;"""):
        opts.setdefault(prd, {}).setdefault((grp, gnm, mand, opt, onm), {})[siz] = (
            float(up) if up else None)

    rows = []
    for prd in TARGETS:
        w = wgt.get(prd)
        if not w:
            continue
        for siz, snm in sizes.get(prd, []):
            base, err = price(site_key, w, {'siz_cd': siz})
            if base is None:
                rows.append(dict(prd_cd=prd, siz_nm=snm, opt_grp='', opt_nm='(기준가)',
                                 unit_price='', base='', got='', delta='',
                                 verdict='BASE-FAIL', note=err))
                continue
            for (grp, gnm, mand, opt, onm), pricemap in opts.get(prd, {}).items():
                # 이 사이즈에 걸린 단가 우선, 없으면 사이즈 무관 단가
                up = pricemap.get(siz, pricemap.get('', None))
                if up is None:
                    up = next((v for v in pricemap.values() if v is not None), None)
                got, err2 = price(site_key, w, {'siz_cd': siz, 'opt_cd': opt})
                if got is None:
                    v, delta = 'CALL-FAIL', ''
                else:
                    delta = got - base
                    if up is None:
                        v = 'NO-UNITPRICE'
                    elif abs(delta - up) < 0.001:
                        v = 'OK'
                    elif delta == 0:
                        v = 'NOEFFECT'
                    else:
                        v = 'MISMATCH'
                rows.append(dict(prd_cd=prd, siz_nm=snm, opt_grp=f'{gnm}({mand})',
                                 opt_nm=onm, unit_price=up if up is not None else '',
                                 base=base, got=got if got is not None else '',
                                 delta=delta, verdict=v, note=err2 if got is None else ''))

    p = f'{HERE}/optaxis-probe-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w2 = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w2.writeheader()
        w2.writerows(rows)

    from collections import Counter
    print(f'{"prd_cd":<12}{"사이즈":<16}{"옵션":<22}{"단가":>8}{"기준":>9}{"결과":>9}{"증분":>8}  판정')
    for r in rows:
        print(f'{r["prd_cd"]:<12}{r["siz_nm"][:14]:<16}{r["opt_nm"][:20]:<22}'
              f'{str(r["unit_price"]):>8}{str(r["base"]):>9}{str(r["got"]):>9}'
              f'{str(r["delta"]):>8}  {r["verdict"]}'
              + (f'  {r["note"]}' if r['note'] else ''))
    print()
    print('판정:', dict(Counter(r['verdict'] for r in rows)))
    print('호출 수:', len(rows) + len({(r['prd_cd'], r['siz_nm']) for r in rows}))
    print('산출:', p)


if __name__ == '__main__':
    sys.exit(main())
