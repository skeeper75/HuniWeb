#!/usr/bin/env python3
"""위젯 meta 기반 가격 재검증 (M4-28) — M4-27 오판 정정.

M4-27 은 `cfg.items[].ref_key` 를 「위젯이 주는 축」으로 보고 `proc_cd` 가 없다고 판단해
「필수공정 미반영 과소청구 20상품」이라는 결론을 냈다. **틀렸다.**

  cfg.items       = 위젯 레이아웃(블록 배치)
  meta.prod_dims  = 위젯 데이터(차원과 선택지) ← 여기에 proc_cd 가 있다
  meta 는 응답의 `widget` 안이 아니라 **최상위**에 있다(widget_api.py api_widget).

그리고 필수공정은 `{"v":"PROC_000004","t":"디지털인쇄","mand":true}` 로 표시되며,
`models.py:701` 계약대로 **위젯이 항상 켠 채 보낸다** — 고객이 고르지 않아도 적용된다.

그래서 이 스크립트는 **위젯이 실제로 보내는 조합**을 재현한다:
  각 prod_dims 차원에서 기본값(dflt) 또는 첫 옵션을 고르고,
  **mand:true 인 옵션은 반드시 포함**한다. 수량은 meta.qty_rule 을 따른다.

이 조합에서 가격이 안 나오거나 0원이면 **그것이 진짜 결함**이다.

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


def get_json(url):
    req = urllib.request.Request(url, headers={'User-Agent': UA, 'Origin': 'http://localhost'})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            return json.load(r), ''
    except Exception as ex:
        return None, type(ex).__name__


def post_price(site_key, wgt, sel, qty):
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
            return None, f'http{ex.code}', []
    except Exception as ex:
        return None, type(ex).__name__, []
    if not d.get('ok'):
        return None, (d.get('error') or '; '.join(d.get('errors') or []) or d.get('code', ''))[:90], []
    return d.get('total'), '', d.get('components', [])


def build_selections(meta):
    """위젯 런타임이 보낼 조합을 재현한다.

    - 단일값 차원(siz_cd/mat_cd/print_opt_cd 등): 기본값(dflt) 우선, 없으면 첫 옵션
    - proc_cd: **mand 인 옵션을 모두** 포함. 없으면 넣지 않는다(선택 공정은 고객 몫)
      API 가 proc_cd 를 하나만 받으므로 mand 가 여럿이면 첫 번째만 싣고 그 사실을 남긴다.
    """
    sel, notes = {}, []
    for pd in meta.get('prod_dims') or []:
        name, opts = pd.get('name'), pd.get('options') or []
        if not name or not opts:
            continue
        if name == 'proc_cd':
            mands = [o for o in opts if o.get('mand')]
            if not mands:
                continue
            sel[name] = mands[0]['v']
            if len(mands) > 1:
                notes.append(f'필수공정 {len(mands)}종 중 1종만 적용')
        else:
            dflt = next((o for o in opts if o.get('dflt')), None)
            sel[name] = (dflt or opts[0])['v']
    return sel, '; '.join(notes)


def main():
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]
    widgets = psql(e, """
      SELECT w.wgt_cd, w.prd_cd, p.prd_nm FROM t_wgt_widgets w
      JOIN t_prd_products p ON p.prd_cd=w.prd_cd
      WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND w.use_yn='Y' AND COALESCE(w.del_yn,'N')<>'Y'
        AND p.use_yn='Y' AND COALESCE(p.del_yn,'N')<>'Y'
      ORDER BY w.prd_cd;""")

    out = []
    for wgt, prd, pnm in widgets:
        d, err = get_json(f'{WAPI}/{wgt}?site_key={site_key}')
        if d is None or not d.get('ok'):
            out.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt, sel='', qty='',
                            total='', comps='', verdict='META-FAIL', note=err))
            continue
        meta = d.get('meta') or {}
        sel, note = build_selections(meta)
        qr = meta.get('qty_rule') or {}
        # 사이즈별 수량 규칙이 있으면 그 사이즈 것을 쓴다(size_qty_rules)
        sqr = (meta.get('size_qty_rules') or {}).get(sel.get('siz_cd'), {})
        qty = sqr.get('dflt') or sqr.get('min') or qr.get('dflt') or qr.get('min') or 1
        total, perr, comps = post_price(site_key, wgt, sel, int(qty))
        if total is None:
            v = 'ERR'
        elif total < 0:
            v = 'NEGATIVE'
        elif total == 0:
            v = 'ZERO'
        else:
            v = 'OK'
        out.append(dict(prd_cd=prd, prd_nm=pnm, wgt_cd=wgt,
                        sel=json.dumps(sel, ensure_ascii=False), qty=qty,
                        total=total if total is not None else '',
                        comps=' + '.join(f"{c['name']}={c['amount']}" for c in comps),
                        verdict=v, note=(note + ' ' + perr).strip()))

    p = f'{HERE}/widget-meta-probe-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    from collections import Counter
    print(f'게시 위젯 {len(out)} (meta.prod_dims 기반 조합 · 필수공정 mand 포함)')
    print('판정:', dict(Counter(r['verdict'] for r in out)))
    for tag, title in (('NEGATIVE', '음수'), ('ZERO', '0원'), ('ERR', '가격 미산출'),
                       ('META-FAIL', 'meta 조회 실패')):
        sel2 = [r for r in out if r['verdict'] == tag]
        if not sel2:
            continue
        print(f'\n--- {title} {len(sel2)}건 ---')
        for r in sel2[:30]:
            print(f'  {r["prd_cd"]} {r["prd_nm"][:18]:<20} qty={str(r["qty"]):<7}{r["note"][:70]}')
        if len(sel2) > 30:
            print(f'  … 외 {len(sel2)-30}건')
    ok = [r for r in out if r['verdict'] == 'OK']
    if ok:
        print('\n--- 정상 산출 예시 (인쇄물 계열) ---')
        for r in ok:
            if any(k in r['prd_nm'] for k in ('엽서', '접지', '리플렛', '전단', '명함', '쿠폰')):
                print(f'  {r["prd_cd"]} {r["prd_nm"][:16]:<18} qty={r["qty"]:<6} total={r["total"]:<10} {r["comps"][:70]}')
    print('\n산출:', p)


if __name__ == '__main__':
    sys.exit(main())
