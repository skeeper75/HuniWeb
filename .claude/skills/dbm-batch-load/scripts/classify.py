#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
classify.py — 270 상품을 상태축 × 동형축으로 분류 (dbm-batch-load S1).
  라이브 read-only + 한 SQL 집계(상품마다 호출 X). 출력 classification.csv + 집계.

분류 두 축:
  상태축  : ready(use_yn=Y & 가격공식 바인딩 있음) / pending(use_yn=Y & 공식 NONE)
            / unlisted(use_yn=N)
  동형축  : (옵션구성 시그니처, 가격계산방식=frm_cd 집합) → 같으면 한 동형 클래스
가격 동형 = 공식(frm_cd) 기준. formula_components가 frm_cd 단위(prd_cd 없음) →
  같은 공식=같은 comp(comp 차이는 런타임 option). 한 시트 여러 공식은 frm_cd로 자동분리.
옵션 시그니처 = option_groups 의 (sel_typ_cd:옵션수) 패턴 해시(택1/택N 구조).
배치 대상 = state ready AND 동형 클래스 멤버 ≥ 2 (단건은 dbm-load-execution).

사용: BATCH_OUT=_workspace/huni-dbmap/30_batch python3 classify.py  (.env.local RAILWAY_DB_*)
"""
import csv, os, subprocess
from collections import Counter

OUT_DIR = os.environ.get('BATCH_OUT', '.')

SQL = r"""
WITH og AS (
  SELECT g.prd_cd, g.opt_grp_cd, g.sel_typ_cd, count(o.opt_cd) AS n_opt
  FROM t_prd_product_option_groups g
  LEFT JOIN t_prd_product_options o
    ON o.prd_cd=g.prd_cd AND o.opt_grp_cd=g.opt_grp_cd AND o.use_yn='Y'
  WHERE g.use_yn='Y'
  GROUP BY g.prd_cd, g.opt_grp_cd, g.sel_typ_cd
),
opt_sig AS (
  SELECT prd_cd,
         md5(string_agg(sel_typ_cd||':'||n_opt, '|' ORDER BY sel_typ_cd, n_opt)) AS osig,
         count(*) AS n_groups
  FROM og GROUP BY prd_cd
),
pf AS (
  SELECT p.prd_cd, p.prd_nm, p.use_yn,
         COALESCE(string_agg(DISTINCT f.frm_cd, '+' ORDER BY f.frm_cd), 'NONE') AS price_class
  FROM t_prd_products p
  LEFT JOIN t_prd_product_price_formulas f USING (prd_cd)
  GROUP BY p.prd_cd, p.prd_nm, p.use_yn
)
SELECT pf.prd_cd, replace(pf.prd_nm, E'\t', ' '),
  CASE WHEN pf.use_yn<>'Y' THEN 'unlisted'
       WHEN pf.price_class='NONE' THEN 'pending'
       ELSE 'ready' END AS state,
  pf.price_class,
  COALESCE(os.n_groups, 0) AS n_groups,
  COALESCE(left(os.osig, 8), 'NOOPT') AS opt_sig
FROM pf LEFT JOIN opt_sig os USING (prd_cd)
ORDER BY pf.price_class, pf.prd_cd;
"""
# 동형 두 축은 분리 [HARD]: 가격 동형 = price_class(frm_cd 집합·레시피) — 가격 적재 배치 단위.
#   옵션 동형 = opt_sig — 옵션 적재 배치 단위. 같은 가격공식이어도 옵션 다르면 옵션 배치는 분리되나
#   가격 배치는 한 묶음(맛간장 = 공유 공식·comp). formula_components 가 frm_cd 단위라 가격은 frm_cd로 동형.


def q(sql: str) -> list[list[str]]:
    root = subprocess.check_output(['git', 'rev-parse', '--show-toplevel'], text=True).strip()
    env = dict(os.environ)
    for line in open(os.path.join(root, '.env.local'), encoding='utf-8'):
        if line.startswith('RAILWAY_DB_') and '=' in line:
            k, v = line.strip().split('=', 1)
            env[k] = v.strip().strip('"')
    env['PGPASSWORD'] = env.get('RAILWAY_DB_PASSWORD', '')
    cmd = ['psql', '-h', env['RAILWAY_DB_HOST'], '-p', env['RAILWAY_DB_PORT'],
           '-U', env['RAILWAY_DB_USER'], '-d', env['RAILWAY_DB_NAME'],
           '-tAF', '\t', '-v', 'ON_ERROR_STOP=1', '--no-psqlrc', '-c', sql]
    out = subprocess.check_output(cmd, env=env, text=True)
    return [r.split('\t') for r in out.splitlines() if r]


def main() -> None:
    rows = q(SQL)  # [prd_cd, prd_nm, state, price_class, n_groups, opt_sig]
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, 'classification.csv')
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f)
        w.writerow(['prd_cd', 'prd_nm', 'state', 'price_class', 'n_groups', 'opt_sig'])
        w.writerows(rows)

    states = Counter(r[2] for r in rows)
    # 가격 동형(frm_cd·레시피) = 가격 적재 배치 단위
    price_hom = Counter(r[3] for r in rows if r[2] == 'ready')
    price_batch = {c: n for c, n in price_hom.items() if n >= 2}
    # 옵션 동형(price+opt) = 옵션 적재 배치 단위(별 축)
    opt_hom = Counter((r[3], r[5]) for r in rows if r[2] == 'ready')
    opt_batch = {k: n for k, n in opt_hom.items() if n >= 2}

    print(f"[classify] 상품 {len(rows)} → {path}")
    print(f"[상태] " + ' · '.join(f"{s}:{n}" for s, n in sorted(states.items())))
    print(f"\n[가격 동형 = frm_cd(레시피)] ready {sum(price_hom.values())}상품 → "
          f"{len(price_hom)}클래스, 배치가능(멤버≥2) {len(price_batch)}클래스 "
          f"{sum(price_batch.values())}상품")
    for cls, n in price_hom.most_common():
        tag = '  ← 배치' if n >= 2 else '  (단건=load-execution)'
        print(f"  {cls:<28} {n}{tag}")
    print(f"\n[옵션 동형 = 가격공식×옵션시그(별 축)] 배치가능 {len(opt_batch)}클래스 "
          f"{sum(opt_batch.values())}상품 — 옵션 적재 배치 단위")
    for (cls, osig), n in sorted(opt_batch.items(), key=lambda x: -x[1])[:10]:
        print(f"  {cls}__{osig:<10} {n}")


if __name__ == '__main__':
    main()
