#!/usr/bin/env python3
"""위젯 노출 축 ↔ 가격구성요소 요구 축 간극 전수 스캔 (M4-27).

발단: 프리미엄엽서 105장이 위젯 축만으로는 424원(용지비만), `proc_cd` 를 실으면
9,424원(디지털인쇄비 9,000 + 용지비 424)이 된다. 위젯은 `proc_cd` 를 노출하지 않으므로
**고객은 인쇄비를 내지 않는다.** 과소청구다.

구조: 구성요소는 `use_dims` 로 축을 요구하고, 그 축이 selections 에 없으면
단가행이 매칭되지 않아 **그 구성요소가 통째로 빠진 채 합계가 난다**(에러가 아니다).

그래서 (위젯이 주는 축) 과 (구성요소가 요구하는 축)의 차집합을 전 게시 위젯에서 잰다.

[엔진이 유도하는 축] 실증으로 확인된 것만 제외한다:
  min_qty     — qty 에서 유도 (수량구간)
  plt_siz_cd  — 상품 기본 판형에서 유도 (용지비가 붙는 것으로 확인)
  bdl_qty     — 묶음수. 유도 여부 미확인이라 간극으로 계상하되 표시한다
`proc_cd` 는 유도되지 않음이 실증됐다(위 9,000원 차이).

라이브 읽기 전용 (가격조회·설정조회). 쓰기 0.
"""
import csv
import json
import os
import subprocess
import sys
import urllib.error
import urllib.request

HERE = '_workspace/postersign-audit'
WAPI = 'https://huni-admin.printly.co.kr/api/w/v1/widgets'
UA = ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/131.0 Safari/537.36')
# 엔진이 스스로 채우는 축 — 위젯이 안 줘도 된다
DERIVED = {'min_qty', 'plt_siz_cd'}


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


def widget_axes(site_key, wgt):
    req = urllib.request.Request(f'{WAPI}/{wgt}?site_key={site_key}',
                                 headers={'User-Agent': UA, 'Origin': 'http://localhost'})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            d = json.load(r)
    except Exception as ex:
        return None, type(ex).__name__
    if not d.get('ok'):
        return None, d.get('code', 'not-ok')
    return {i['ref_key'] for i in d['widget']['cfg']['items']
            if i.get('ref_key') and i.get('visible_yn') == 'Y'}, ''


def main():
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]

    widgets = psql(e, """
      SELECT w.wgt_cd, w.prd_cd, p.prd_nm FROM t_wgt_widgets w
      JOIN t_prd_products p ON p.prd_cd=w.prd_cd
      WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND w.use_yn='Y' AND COALESCE(w.del_yn,'N')<>'Y'
        AND p.use_yn='Y' AND COALESCE(p.del_yn,'N')<>'Y'
      ORDER BY w.prd_cd;""")

    # 상품 -> [(공식, 구성요소, 구성요소명, use_dims)]
    comp = {}
    for prd, frm, cc, cn, dims in psql(e, """
      SELECT ppf.prd_cd, ppf.frm_cd, pc.comp_cd, pc.comp_nm, COALESCE(pc.use_dims::text,'[]')
      FROM t_prd_product_price_formulas ppf
      JOIN t_prc_formula_components fc ON fc.frm_cd=ppf.frm_cd
      JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
      WHERE COALESCE(pc.use_yn,'Y')='Y'
      ORDER BY ppf.prd_cd, COALESCE(fc.disp_seq,999);"""):
        try:
            axes = {a for a in json.loads(dims) if not a.startswith(('proc_grp:', 'opt_grp:'))}
        except Exception:
            axes = set()
        comp.setdefault(prd, []).append((frm, cc, cn, axes))

    rows, prod = [], []
    for wgt, prd, pnm in widgets:
        wax, err = widget_axes(site_key, wgt)
        if wax is None:
            prod.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt, 위젯축='',
                             간극구성요소=0, 총구성요소=len(comp.get(prd, [])),
                             간극축='', verdict='WGT-ERR', note=err))
            continue
        gapc = []
        for frm, cc, cn, axes in comp.get(prd, []):
            miss = axes - wax - DERIVED
            if miss:
                gapc.append((frm, cc, cn, miss))
                rows.append(dict(prd_cd=prd, prd_nm=pnm, frm_cd=frm, comp_cd=cc,
                                 comp_nm=cn, 요구축=','.join(sorted(axes)),
                                 위젯축=','.join(sorted(wax)),
                                 미충족축=','.join(sorted(miss))))
        prod.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt,
                         위젯축=','.join(sorted(wax)),
                         간극구성요소=len(gapc), 총구성요소=len(comp.get(prd, [])),
                         간극축=','.join(sorted({m for _, _, _, ms in gapc for m in ms})),
                         verdict='GAP' if gapc else 'OK', note=''))

    with open(f'{HERE}/axis-gap-comp-260829.csv', 'w', newline='', encoding='utf-8') as f:
        if rows:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    with open(f'{HERE}/axis-gap-prod-260829.csv', 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(prod[0].keys()))
        w.writeheader()
        w.writerows(prod)

    from collections import Counter
    print(f'게시 위젯 {len(prod)} · 간극 구성요소 행 {len(rows)}')
    print('상품 판정:', dict(Counter(r['verdict'] for r in prod)))
    print('\n미충족 축 분포(구성요소 기준):',
          dict(Counter(a for r in rows for a in r['미충족축'].split(','))))
    print('\n--- 공식별 파급 (간극 있는 상품 수) ---')
    byfrm = Counter(r['frm_cd'] for r in rows)
    seen = {}
    for r in rows:
        seen.setdefault(r['frm_cd'], set()).add(r['prd_cd'])
    for frm, _ in byfrm.most_common(15):
        print(f'  {frm:<28} 간극 구성요소 {byfrm[frm]:>3} · 영향 게시상품 {len(seen[frm]):>3}')
    print('\n--- 간극 상품 상위 20 ---')
    for r in sorted(prod, key=lambda x: -x['간극구성요소'])[:20]:
        if r['간극구성요소']:
            print(f'  {r["prd_cd"]} {r["prd_nm"][:16]:<18}'
                  f'{r["간극구성요소"]}/{r["총구성요소"]} 구성요소 · 미충족 [{r["간극축"]}]')
    print('\n산출:', f'{HERE}/axis-gap-prod-260829.csv', '·', f'{HERE}/axis-gap-comp-260829.csv')


if __name__ == '__main__':
    sys.exit(main())
