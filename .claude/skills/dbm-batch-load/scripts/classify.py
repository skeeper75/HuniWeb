#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
classify.py — 270 상품을 상태축 × 동형축으로 분류 (dbm-batch-load S1).
  라이브 read-only + 엑셀 명시값(권위). 추측 0. 출력 classification.csv/md.

분류 두 축:
  상태축  : ready(정확등록가능=컬럼완정·기초정합) / pending(신규예정=완정성 미확인)
            / unlisted(미출시=use_yn N·정체 미확정)
  동형축  : (옵션구성 시그니처, 가격계산방식=PRF_* 클래스) → 같으면 한 동형 클래스
배치 대상 = 상태 ready AND 동형 클래스 멤버 ≥ 2 (단건은 dbm-load-execution).

라이브 시그니처 소스(예시 — 적용 시 조정):
  - 가격클래스 : t_prd_product_price_formulas.frm_cd (PRF_*)
  - 옵션구성   : t_prd_product_option_groups/options 패턴 해시
  - 상태       : t_prd_products.use_yn + 기초 차원 적재 여부(siz/mat/proc)
사용: python classify.py  (.env.local RAILWAY_DB_* 읽기전용)
"""
import csv, os, subprocess, hashlib

OUT_DIR = os.environ.get('BATCH_OUT', '.')


def q(sql: str) -> list[tuple[str, ...]]:
    """읽기전용 psql 조회 → 행 리스트. 비밀값은 환경에서만."""
    env = dict(os.environ)
    root = subprocess.check_output(['git', 'rev-parse', '--show-toplevel'], text=True).strip()
    for line in open(os.path.join(root, '.env.local'), encoding='utf-8'):
        if line.startswith('RAILWAY_DB_') and '=' in line:
            k, v = line.strip().split('=', 1)
            env[k] = v.strip().strip('"')
    env['PGPASSWORD'] = env.get('RAILWAY_DB_PASSWORD', '')
    cmd = ['psql', '-h', env['RAILWAY_DB_HOST'], '-p', env['RAILWAY_DB_PORT'],
           '-U', env['RAILWAY_DB_USER'], '-d', env['RAILWAY_DB_NAME'],
           '-tAF', '\t', '-c', sql]
    out = subprocess.check_output(cmd, env=env, text=True)
    return [tuple(r.split('\t')) for r in out.splitlines() if r]


def opt_signature(prd_cd: str) -> str:
    """옵션구성 시그니처 — option_groups/options 패턴 해시(동형 판정용)."""
    rows = q(f"""SELECT og.opt_grp_typ_cd, count(o.opt_cd)
                 FROM t_prd_product_option_groups og
                 LEFT JOIN t_prd_product_options o USING (prd_cd, opt_grp_cd)
                 WHERE og.prd_cd='{prd_cd}' GROUP BY 1 ORDER BY 1""")
    sig = '|'.join(f"{r[0]}:{r[1]}" for r in rows)
    return hashlib.md5(sig.encode()).hexdigest()[:8] if sig else 'NONE'


def main() -> None:
    # 상품 × 가격클래스 × use_yn (예시 쿼리 — 적용 시 컬럼 조정)
    prods = q("""SELECT p.prd_cd, p.prd_nm, p.use_yn,
                        coalesce(f.frm_cd,'NONE') AS price_class
                 FROM t_prd_products p
                 LEFT JOIN t_prd_product_price_formulas f USING (prd_cd)
                 ORDER BY price_class, p.prd_cd""")
    rows = []
    for prd_cd, prd_nm, use_yn, price_class in prods:
        sig = opt_signature(prd_cd)
        state = 'unlisted' if use_yn != 'Y' else ('ready' if price_class != 'NONE' else 'pending')
        # 동형 클래스 = (가격계산방식, 옵션구성 시그니처)
        homclass = f"{price_class}__{sig}"
        rows.append((prd_cd, prd_nm, state, price_class, sig, homclass))
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, 'classification.csv')
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f)
        w.writerow(['prd_cd', 'prd_nm', 'state', 'price_class', 'opt_sig', 'homclass'])
        w.writerows(rows)
    # 동형 클래스별 배치 가능(ready ≥ 2) 집계
    from collections import Counter
    ready = Counter(r[5] for r in rows if r[2] == 'ready')
    batchable = {c: n for c, n in ready.items() if n >= 2}
    print(f"[classify] 상품 {len(rows)} → 동형클래스 {len(set(r[5] for r in rows))}개")
    print(f"[classify] 배치 가능(ready≥2) 클래스 {len(batchable)}개: "
          f"{sum(batchable.values())}상품")
    print(f"[classify] → {path}")


if __name__ == '__main__':
    main()
