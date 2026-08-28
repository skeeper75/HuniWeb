"""축④ — 위젯 실가격(`supply`) 종단 스윕. 읽기 전용.

이것은 2026-08-22 전수 감사의 재실행이 아니다(REQ-PC-019).
그 감사는 게시 위젯 전량을 「0원 또는 산출 실패」 렌즈로 훑었고, 이 스크립트는
**한 마일스톤의 상품에 한정해** 상품뷰어가 파는 조합마다 `supply` 를 받아
권위값과 대조할 재료를 만든다(AC-PC-012·013). 렌즈도 분모도 다르다.

`supply` 만 본다 — `total` 은 `supply × 1.1` 이라 권위와 비교하면 오판이다(§2.3).

사용
    python3 axis4.py                      # 기본 범위(M4)
    python3 axis4.py --lo PRD_000200 --hi PRD_000230
"""
import argparse
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
    return [line.split('|') for line in out.splitlines() if line.strip()]


def price(site_key, wgt_cd, sel, qty=1):
    """api_price 호출. qty 는 selections 안이 아니라 **최상위**다(안에 넣으면 bad_qty)."""
    body = json.dumps({'site_key': site_key, 'wgt_cd': wgt_cd,
                       'qty': qty, 'selections': sel}).encode()
    req = urllib.request.Request(API, data=body, method='POST', headers={
        'Content-Type': 'application/json',
        'Origin': 'http://localhost',   # t_wgt_sites.allow_domains 에 등재된 호스트
        # [도구 함정] User-Agent 를 안 주면 CDN 이 `error code: 1010`(브라우저 서명 차단)
        # 으로 403 을 낸다. 우리 앱의 site_key/Origin 게이트가 아니라 **앞단 CDN** 이며,
        # 응답이 JSON 이 아니라 HTML 이라 코드만 보면 origin_not_allowed 로 오독하기 쉽다.
        # curl 은 자기 UA 를 붙이므로 통과했고, urllib 기본값(Python-urllib/3.x)은 막혔다.
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
                      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36',
    })
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
    if d.get('ok'):
        return d.get('supply'), ''
    return None, d.get('code') or (d.get('user_errors') or [''])[0][:24]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--lo', default='PRD_000118')
    ap.add_argument('--hi', default='PRD_000145')
    a = ap.parse_args()
    e = env()

    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]

    # 게시 위젯 ↔ 상품 (분모 = 상품뷰어)
    widgets = psql(e, f"""
      SELECT w.wgt_cd, w.prd_cd, p.prd_nm FROM t_wgt_widgets w
      JOIN t_prd_products p ON p.prd_cd=w.prd_cd
      WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(w.del_yn,'N')<>'Y' AND w.use_yn='Y'
        AND w.prd_cd BETWEEN '{a.lo}' AND '{a.hi}' ORDER BY w.prd_cd;""")

    # 상품뷰어가 파는 사이즈 / 고객이 고를 수 있는 자재
    sizes, mats = {}, {}
    for prd, siz, nm in psql(e, f"""
      SELECT ps.prd_cd, ps.siz_cd, COALESCE(s.siz_nm,'') FROM t_prd_product_sizes ps
      LEFT JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
      WHERE ps.prd_cd BETWEEN '{a.lo}' AND '{a.hi}'
        -- [HARD] 삭제·미사용 행을 빼지 않으면 팔지 않는 사이즈를 API 에 넣게 되고,
        -- 그 price_gap 을 결함으로 오독한다(AC-PC-003). 실제로 그렇게 「고아 18종」이
        -- 나왔고 위젯은 그 사이즈를 선택지로 내놓지도 않았다 — 도달 불가였다.
        -- 바로 아래 자재 질의는 이 필터를 걸고 있었다. 사이즈만 빠져 있었다.
        AND COALESCE(ps.del_yn,'N') <> 'Y'
        AND COALESCE(s.use_yn,'Y') = 'Y' AND COALESCE(s.del_yn,'N') <> 'Y'
      ORDER BY ps.prd_cd, s.siz_nm;"""):
        sizes.setdefault(prd, []).append((siz, nm))
    for prd, mat, nm in psql(e, f"""
      SELECT pm.prd_cd, pm.mat_cd, COALESCE(m.mat_nm,'') FROM t_prd_product_materials pm
      LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
      WHERE pm.prd_cd BETWEEN '{a.lo}' AND '{a.hi}'
        AND pm.cust_sel_yn='Y' AND COALESCE(pm.del_yn,'N')<>'Y'
      ORDER BY pm.prd_cd, pm.disp_seq;"""):
        mats.setdefault(prd, []).append((mat, nm))

    rows, summary = [], []
    for wgt, prd, pnm in widgets:
        combos = []
        for siz, snm in sizes.get(prd, [(None, '')]) or [(None, '')]:
            for mat, mnm in (mats.get(prd) or [(None, '')]):
                sel = {}
                if siz:
                    sel['siz_cd'] = siz
                if mat:
                    sel['mat_cd'] = mat
                combos.append((sel, snm, mnm))
        ok = bad = 0
        for sel, snm, mnm in combos:
            sup, err = price(site_key, wgt, sel)
            # 최소 주문수량 미달은 상품 규칙이지 가격 결함이 아니다. 엔진이 알려 준
            # 수량으로 한 번 되쏜다 — 이 재시도가 없으면 정상 상품이 실패로 집계된다.
            m = re.search(r'최소 주문수량은\s*(\d+)', err or '')
            if sup is None and m:
                sup, err = price(site_key, wgt, sel, qty=int(m.group(1)))
            if sup is not None:
                ok += 1
            else:
                bad += 1
            rows.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt,
                             siz_nm=snm, mat_nm=mnm, supply=sup or '', err=err))
        summary.append((prd, pnm, ok, bad, len(combos)))
        print(f'{prd} {pnm:<18} 조합 {len(combos):>3}  가격나옴 {ok:>3}  실패 {bad:>3}'
              + ('   ← 전조합 실패' if ok == 0 else ''))

    out = f'{HERE}/axis4-{a.lo[-3:]}-{a.hi[-3:]}.csv'
    with open(out, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=['prd_cd', 'prd_nm', 'wgt_cd', 'siz_nm', 'mat_nm', 'supply', 'err'])
        w.writeheader()
        w.writerows(rows)

    tot_ok = sum(s[2] for s in summary)
    tot = sum(s[4] for s in summary)
    dead = [s for s in summary if s[2] == 0]
    print(f'\n상품 {len(summary)} · 조합 {tot} · 가격나옴 {tot_ok} · 실패 {tot - tot_ok}')
    print(f'전조합 실패 상품: {len(dead)}건' + (' — ' + ' · '.join(s[1] for s in dead) if dead else ''))
    print(f'→ {out}')
    print('\n※ 이 스윕은 「가격이 나오는가」만 본다. 나온 값이 권위와 같은지는 축③ 대조의 몫이다.')


if __name__ == '__main__':
    sys.exit(main())
