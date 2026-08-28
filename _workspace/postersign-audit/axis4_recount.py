#!/usr/bin/env python3
"""축④ 조합 분모 전수 재산정 (M4-22).

axis4.py 가 API 를 113번 쏘아 만든 조합 분모가 옳은지를, API 를 다시 쏘지 않고
결정론적으로 재계산해 대조한다. 세 소스를 삼원 대조한다.

  ① 위젯 API      — 위젯이 실제 노출하는 축(ref_key). 고객 도달의 최종 판정자
  ② 라이브 DB     — 각 축의 도달 가능한 선택지 수 (del_yn/use_yn/cust_sel_yn 필터)
  ③ axis4 산출 CSV — 지난 세션이 실제로 쏜 조합

결함 형태는 두 방향이다.
  과다(inflated) — DB·CSV 가 곱한 축을 위젯이 안 내놓는다 → 도달 불가 조합을 셌다
  과소(missed)   — 위젯이 내놓는 축을 CSV 가 안 곱했다   → 팔리는 조합을 안 쟀다

라이브 읽기 전용. 쓰기 0.
"""
import csv
import json
import os
import subprocess
import sys
import urllib.error
import urllib.request

HERE = '_workspace/postersign-audit'
WGT_API = 'https://huni-admin.printly.co.kr/api/w/v1/widgets'
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


def widget_axes(site_key, wgt_cd):
    """위젯이 노출하는 축 집합. cfg 는 축만 선언하고 선택지 값은 담지 않는다."""
    url = f'{WGT_API}/{wgt_cd}?site_key={site_key}'
    req = urllib.request.Request(url, headers={
        # [도구 함정] UA 없으면 CDN 이 error code: 1010 으로 403 을 낸다.
        'User-Agent': UA, 'Origin': 'http://localhost'})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            d = json.load(r)
    except urllib.error.HTTPError as ex:
        return None, f'http{ex.code}'
    except Exception as ex:
        return None, type(ex).__name__
    if not d.get('ok'):
        return None, d.get('code', 'not-ok')
    items = d['widget']['cfg']['items']
    return {i['ref_key'] for i in items
            if i.get('ref_key') and i.get('visible_yn') == 'Y'}, None


def main():
    lo, hi = 'PRD_000118', 'PRD_000145'
    e = env()
    site_key = psql(e, "SELECT site_key FROM t_wgt_sites WHERE site_cd='SITE_OWN';")[0][0]

    # 분모 = 게시 위젯 (문서 숫자 인용 금지 — AC-PC-025. 매번 다시 잰다)
    widgets = psql(e, f"""
      SELECT w.wgt_cd, w.prd_cd, p.prd_nm FROM t_wgt_widgets w
      JOIN t_prd_products p ON p.prd_cd=w.prd_cd
      WHERE w.sts_typ_cd='WGT_STS_TYPE.02' AND COALESCE(w.del_yn,'N')<>'Y' AND w.use_yn='Y'
        AND COALESCE(p.del_yn,'N')<>'Y' AND p.use_yn='Y'
        AND w.prd_cd BETWEEN '{lo}' AND '{hi}' ORDER BY w.prd_cd;""")

    # axis4.py 와 동일한 필터 규칙 (동형 재현이어야 대조가 성립한다)
    sizes = {}
    for prd, siz, nm in psql(e, f"""
      SELECT ps.prd_cd, ps.siz_cd, COALESCE(s.siz_nm,'') FROM t_prd_product_sizes ps
      LEFT JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
      WHERE ps.prd_cd BETWEEN '{lo}' AND '{hi}'
        AND COALESCE(ps.del_yn,'N') <> 'Y'
        AND COALESCE(s.use_yn,'Y') = 'Y' AND COALESCE(s.del_yn,'N') <> 'Y'
      ORDER BY ps.prd_cd, s.siz_nm;"""):
        sizes.setdefault(prd, []).append(nm)
    mats = {}
    for prd, mat, nm in psql(e, f"""
      SELECT pm.prd_cd, pm.mat_cd, COALESCE(m.mat_nm,'') FROM t_prd_product_materials pm
      LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
      WHERE pm.prd_cd BETWEEN '{lo}' AND '{hi}'
        AND pm.cust_sel_yn='Y' AND COALESCE(pm.del_yn,'N')<>'Y'
      ORDER BY pm.prd_cd, pm.disp_seq;"""):
        mats.setdefault(prd, []).append(nm)

    # 필터를 걸지 않았을 때의 수 — 과거 결함 형태가 남아 있는지 보는 대조군
    raw_sizes, raw_mats = {}, {}
    for prd, n in psql(e, f"""
      SELECT prd_cd, COUNT(*) FROM t_prd_product_sizes
      WHERE prd_cd BETWEEN '{lo}' AND '{hi}' GROUP BY prd_cd;"""):
        raw_sizes[prd] = int(n)
    for prd, n in psql(e, f"""
      SELECT prd_cd, COUNT(*) FROM t_prd_product_materials
      WHERE prd_cd BETWEEN '{lo}' AND '{hi}' GROUP BY prd_cd;"""):
        raw_mats[prd] = int(n)

    # ③ 지난 세션 산출
    csv_cnt = {}
    for r in csv.DictReader(open(f'{HERE}/axis4-118-145.csv', encoding='utf-8')):
        csv_cnt[r['prd_cd']] = csv_cnt.get(r['prd_cd'], 0) + 1

    out, verdicts = [], []
    for wgt, prd, pnm in widgets:
        axes, err = widget_axes(site_key, wgt)
        ns, nm_ = len(sizes.get(prd, [])), len(mats.get(prd, []))
        db_combo = max(ns, 1) * max(nm_, 1)
        got = csv_cnt.get(prd, 0)

        # 위젯 축 ↔ DB 곱한 축 대조
        notes = []
        if axes is None:
            notes.append(f'위젯API실패({err})')
        else:
            if 'siz_cd' in axes and ns == 0:
                notes.append('위젯은 사이즈를 내는데 DB 선택지 0')
            if 'siz_cd' not in axes and ns > 1:
                notes.append(f'위젯이 사이즈 미노출인데 DB {ns}종을 곱함')
            if 'mat_cd' in axes and nm_ == 0:
                notes.append('위젯은 자재를 내는데 DB 선택지 0')
            if 'mat_cd' not in axes and nm_ > 1:
                notes.append(f'위젯이 자재 미노출인데 DB {nm_}종을 곱함')

        if got == 0:
            v = 'CSV-없음'
        elif got == db_combo and not notes:
            v = 'OK'
        elif got != db_combo:
            v = '분모불일치'
        else:
            v = '축불일치'
        verdicts.append(v)
        out.append(dict(
            prd_cd=prd, prd_nm=pnm, wgt_cd=wgt,
            widget_axes=','.join(sorted(axes)) if axes else '',
            db_siz=ns, db_mat=nm_, raw_siz=raw_sizes.get(prd, 0), raw_mat=raw_mats.get(prd, 0),
            db_combo=db_combo, csv_combo=got, delta=got - db_combo,
            verdict=v, note='; '.join(notes)))

    p = f'{HERE}/axis4-recount-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    print(f'게시 위젯 분모(재실측) = {len(widgets)}')
    print(f'{"prd_cd":<12}{"상품":<18}{"위젯축":<22}{"DB":>4}{"CSV":>5}{"Δ":>4}  판정')
    for r in out:
        print(f'{r["prd_cd"]:<12}{r["prd_nm"][:16]:<18}{r["widget_axes"]:<22}'
              f'{r["db_combo"]:>4}{r["csv_combo"]:>5}{r["delta"]:>+4}  {r["verdict"]}'
              + (f'  ← {r["note"]}' if r['note'] else ''))
    from collections import Counter
    print('\n판정 집계:', dict(Counter(verdicts)))
    print('DB 합계', sum(r['db_combo'] for r in out),
          '· CSV 합계', sum(r['csv_combo'] for r in out))
    print('산출:', p)


if __name__ == '__main__':
    sys.exit(main())
