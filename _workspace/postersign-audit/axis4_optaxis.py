#!/usr/bin/env python3
"""축④ 옵션 가격축 미측정 규모 산출 (M4-22).

axis4.py 는 siz_cd x mat_cd 만 곱는다. 그런데 일부 상품은 옵션그룹이 use_dims 에
들어 있어 가격을 바꾼다 (옵션마다 단가행이 다르다). 그 축을 곱지 않았으므로
해당 옵션들의 단가가 옳게 붙는지 한 번도 재본 적이 없다.

전 28상품에서 그 규모를 결정론적으로 산출한다. 라이브 읽기 전용.

곱 규칙
  필수 그룹 (mand_yn='Y') — 반드시 하나 고른다        -> x N
  선택 그룹 (mand_yn='N') — 미선택도 성립한다         -> x (N+1)
필수만 반영한 수(하한)와 선택까지 반영한 수(상한)를 함께 낸다.
"""
import csv
import os
import re
import subprocess
import sys

HERE = '_workspace/postersign-audit'
LO, HI = 'PRD_000118', 'PRD_000145'


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


def main():
    e = env()

    # 상품별 use_dims 전문 (공식 -> 구성요소)
    dims = {}
    for prd, txt in psql(e, f"""
      SELECT ppf.prd_cd, string_agg(DISTINCT COALESCE(pc.use_dims::text,''), ' ')
      FROM t_prd_product_price_formulas ppf
      JOIN t_prc_formula_components fc ON fc.frm_cd=ppf.frm_cd
      JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
      WHERE ppf.prd_cd BETWEEN '{LO}' AND '{HI}' GROUP BY ppf.prd_cd;"""):
        dims[prd] = txt

    # 살아있는 옵션그룹 + 선택지 수
    groups = {}
    for prd, grp, gnm, mand, n in psql(e, f"""
      SELECT g.prd_cd, g.opt_grp_cd, g.opt_grp_nm, g.mand_yn, COUNT(o.opt_cd)
      FROM t_prd_product_option_groups g
      LEFT JOIN t_prd_product_options o
             ON o.prd_cd=g.prd_cd AND o.opt_grp_cd=g.opt_grp_cd
            AND o.use_yn='Y' AND COALESCE(o.del_yn,'N')<>'Y'
      WHERE g.prd_cd BETWEEN '{LO}' AND '{HI}'
        AND g.use_yn='Y' AND COALESCE(g.del_yn,'N')<>'Y'
      GROUP BY g.prd_cd, g.opt_grp_cd, g.opt_grp_nm, g.mand_yn, g.disp_seq
      ORDER BY g.prd_cd, g.disp_seq;"""):
        groups.setdefault(prd, []).append((grp, gnm, mand, int(n)))

    # 옵션별 단가행이 실재하는가 — 가격을 실제로 바꾸는지의 증거
    priced = set()
    for prd, grp in psql(e, f"""
      SELECT DISTINCT o.prd_cd, o.opt_grp_cd
      FROM t_prd_product_options o
      JOIN t_prc_component_prices cp ON cp.opt_cd = o.opt_cd
      WHERE o.prd_cd BETWEEN '{LO}' AND '{HI}';"""):
        priced.add((prd, grp))

    csv_cnt = {}
    for r in csv.DictReader(open(f'{HERE}/axis4-118-145.csv', encoding='utf-8')):
        csv_cnt[r['prd_cd']] = csv_cnt.get(r['prd_cd'], 0) + 1
    names = {r['prd_cd']: r['prd_nm'] for r in
             csv.DictReader(open(f'{HERE}/axis4-118-145.csv', encoding='utf-8'))}

    out = []
    for prd in sorted(csv_cnt):
        d = dims.get(prd, '')
        # use_dims 가 옵션을 가격축으로 쓰는가
        uses_opt = ('opt_cd' in d) or ('opt_grp' in d)
        named = set(re.findall(r'opt_grp:(OPT_\d+)', d))
        base = csv_cnt[prd]
        lo_mult = hi_mult = 1
        detail = []
        for grp, gnm, mand, n in groups.get(prd, []):
            if n == 0:
                continue
            # 가격축 판정: use_dims 가 그룹을 이름으로 지목했거나,
            # opt_cd 를 쓰면서 그 그룹의 옵션에 단가행이 실재하는 경우
            is_price_axis = (grp in named) or (
                'opt_cd' in d and (prd, grp) in priced)
            if not is_price_axis:
                detail.append(f'{gnm}({grp}) x{n} 가격무관')
                continue
            if mand == 'Y':
                lo_mult *= n
                hi_mult *= n
                detail.append(f'{gnm}({grp}) 필수 x{n}')
            else:
                hi_mult *= (n + 1)
                detail.append(f'{gnm}({grp}) 선택 x{n}+미선택')
        out.append(dict(
            prd_cd=prd, prd_nm=names[prd],
            use_dims=d.strip(), uses_opt_axis='Y' if uses_opt else 'N',
            csv_combo=base, need_min=base * lo_mult, need_max=base * hi_mult,
            missed_min=base * lo_mult - base, missed_max=base * hi_mult - base,
            note='; '.join(detail)))

    p = f'{HERE}/axis4-optaxis-260829.csv'
    with open(p, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)

    print(f'{"prd_cd":<12}{"상품":<18}{"CSV":>4}{"필수반영":>7}{"선택까지":>7}  비고')
    for r in out:
        if r['missed_max'] == 0:
            continue
        print(f'{r["prd_cd"]:<12}{r["prd_nm"][:16]:<18}{r["csv_combo"]:>4}'
              f'{r["need_min"]:>7}{r["need_max"]:>7}  {r["note"]}')
    print()
    print('측정된 조합      ', sum(r['csv_combo'] for r in out))
    print('필수 축까지 필요 ', sum(r['need_min'] for r in out),
          f'(미측정 {sum(r["missed_min"] for r in out)})')
    print('선택 축까지 필요 ', sum(r['need_max'] for r in out),
          f'(미측정 {sum(r["missed_max"] for r in out)})')
    print('영향 상품        ', sum(1 for r in out if r['missed_max']), '/', len(out))
    print('산출:', p)


if __name__ == '__main__':
    sys.exit(main())
