#!/usr/bin/env python3
"""차원 정합 적대적 진단 (3자 조인) — §26 huni-price-table-integrity.

가격구성요소(component)에서 "돈이 새는 차원 누락"을 전 상품·전 component 전수로
결정론 적발한다(토큰0). 3개 면(face)을 한 격자(상품×component×차원)에서 조인:

  Face A  use_dims    — component가 선언한 차원(t_prc_price_components.use_dims)
  Face B  충전        — component_prices에 실제 채워진 차원 컬럼(DISTINCT 값집합)
  Face C  선택수단    — 상품이 손님에게 그 차원을 고르게 하는 수단
                        (product_sizes/plate_sizes/materials/processes/print_options/
                         bundle_qtys + option_items의 polymorphic ref_dim 환원)

판정(verdict):
  MISSING     Face C에 있는데 Face B에 없음 = 손님 선택가능한데 단가행 0 → 견적누락/돈샘 🔴
  UNDECLARED  Face B에 opt_cd 등 채워졌는데 Face A(use_dims) 미선언 = silent 가산/무시 위험 🔴
  (SURPLUS는 죽은단가로 돈샘 아님 — 본 진단은 언더차지=돈샘에 집중)

라이브 읽기전용 SELECT만. DB 미적재(교정은 인간 승인 후 dbmap 위임).
사용: RAILWAY_DB_* 환경변수 로드 후 `python3 dim_conformance.py [prd_cd]`
      인자로 prd_cd 주면 그 상품만, 없으면 전수.
"""
import os, json, subprocess, sys
from collections import defaultdict

H, P, U, D, PW = (os.environ[k] for k in
                  ('RAILWAY_DB_HOST', 'RAILWAY_DB_PORT', 'RAILWAY_DB_USER',
                   'RAILWAY_DB_NAME', 'RAILWAY_DB_PASSWORD'))


def q(sql):
    env = dict(os.environ, PGPASSWORD=PW)
    r = subprocess.run(['psql', '-h', H, '-p', P, '-U', U, '-d', D, '-tAF\t', '-c', sql],
                       capture_output=True, text=True, env=env)
    if r.returncode:
        sys.exit('SQL err: ' + r.stderr)
    return [ln.split('\t') for ln in r.stdout.strip().split('\n') if ln]


# polymorphic 옵션참조차원 → component_prices 차원 컬럼
# ★.06(도수)은 print_opt_cd가 아니라 clr_cd축(SKIP) — 과대환원 FP 진원이라 제외.
REFDIM = {'OPT_REF_DIM.01': 'siz_cd', 'OPT_REF_DIM.02': 'plt_siz_cd',
          'OPT_REF_DIM.03': 'mat_cd', 'OPT_REF_DIM.04': 'proc_cd',
          'OPT_REF_DIM.05': 'bdl_qty'}
# 검사 대상 차원(단가행 컬럼). min_qty=수량구간(항상충족)·siz_width/height=비규격·
# coat_side_cnt=코팅면수·clr_cd/dim_vals=별도경로 → 1차 제외(false-positive 가드)
CHECK_DIMS = ['siz_cd', 'plt_siz_cd', 'mat_cd', 'proc_cd', 'print_opt_cd', 'bdl_qty', 'opt_cd']
SKIP_DIMS = {'min_qty', 'siz_width', 'siz_height', 'coat_side_cnt', 'clr_cd'}

only = sys.argv[1] if len(sys.argv) > 1 else None

# 1. 상품→공식
prod_frm = q("SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas"
             + (f" WHERE prd_cd='{only}'" if only else ""))
# 2. 공식→component
frm_comp = defaultdict(list)
for f, c in q("SELECT frm_cd, comp_cd FROM t_prc_formula_components"):
    frm_comp[f].append(c)
# mat_cd → mat_typ_cd (원판 MAT_TYPE.03 vs 부속 .07 분리용 — 같은 mat_typ만 비교)
mat_typ = {}
for m, t in q("SELECT mat_cd, COALESCE(mat_typ_cd,'') FROM t_mat_materials"):
    mat_typ[m] = t

# 3. component use_dims (proc_grp:* 같은 게이트 토큰은 차원 아님 → 제외)
comp_dims = {}
for row in q("SELECT comp_cd, COALESCE(use_dims::text,'[]') FROM t_prc_price_components "
             "WHERE COALESCE(use_yn,'Y')='Y'"):
    c, ud = row[0], row[1]
    try:
        comp_dims[c] = [d for d in json.loads(ud) if isinstance(d, str) and ':' not in d]
    except Exception:
        comp_dims[c] = []
# 4. Face B — component_prices 충전 차원집합
filled = defaultdict(lambda: defaultdict(set))
for dim in CHECK_DIMS:
    for c, v in q(f"SELECT comp_cd, {dim}::text FROM t_prc_component_prices "
                  f"WHERE {dim} IS NOT NULL"):
        if v and v.strip():
            filled[c][dim].add(v)
# 5. Face C — 상품 선택수단
avail = defaultdict(lambda: defaultdict(set))
SRC = [('siz_cd', 't_prd_product_sizes', 'siz_cd'),
       ('plt_siz_cd', 't_prd_product_plate_sizes', 'siz_cd'),  # 판형을 siz_cd 컬럼에 저장 → plt_siz_cd 차원
       ('mat_cd', 't_prd_product_materials', 'mat_cd'),
       ('proc_cd', 't_prd_product_processes', 'proc_cd'),
       ('print_opt_cd', 't_prd_product_print_options', 'print_opt_cd'),
       ('bdl_qty', 't_prd_product_bundle_qtys', 'bdl_qty::text')]
for dim, tbl, col in SRC:
    for p, v in q(f"SELECT prd_cd, {col} FROM {tbl} WHERE COALESCE(del_yn,'N')<>'Y'"
                  + (f" AND prd_cd='{only}'" if only else "")):
        if v:
            avail[p][dim].add(v)
# 옵션 환원(polymorphic) + opt_cd 자체
for p, rd, rk, oc in q("SELECT prd_cd, ref_dim_cd, COALESCE(ref_key1,''), opt_cd "
                       "FROM t_prd_product_option_items WHERE COALESCE(del_yn,'N')<>'Y'"
                       + (f" AND prd_cd='{only}'" if only else "")):
    dim = REFDIM.get(rd)
    if dim and rk:
        avail[p][dim].add(rk)
    avail[p]['opt_cd'].add(oc)

# 신뢰도: 자재·사이즈·판형·묶음수는 보통 1 component가 전담 → 누락=진짜(HIGH).
# 공정·옵션·인쇄옵션은 한 상품의 여러 component가 분담(별색 comp는 별색 proc만,
# 박 comp는 박 proc만) → 상품 전체와 비교 시 false-positive 다수 → REVIEW.
HIGH_DIMS = {'mat_cd', 'siz_cd', 'plt_siz_cd', 'bdl_qty'}

# 6. 3자 조인 verdict
# 핵심: 한 상품-공식에서 같은 차원 D를 use_dims에 쓰는 모든 component의 filled를 UNION한 뒤
#   avail과 비교한다. 등급 분할(MGA/MGB)·역할 분담(별색 comp는 별색 proc, 박 comp는 박 proc)을
#   union이 흡수하므로 "어느 component에도 단가행이 없는" 진짜 돈샘만 남는다.
rows = []
for p, f in prod_frm:
    comps = frm_comp.get(f, [])
    # (a) 차원별 filled UNION + 그 차원 담당 component 목록
    dim_union = defaultdict(set)
    dim_comps = defaultdict(list)
    for c in comps:
        for d in comp_dims.get(c, []):
            if d in CHECK_DIMS and d not in SKIP_DIMS:
                dim_union[d] |= filled[c].get(d, set())
                dim_comps[d].append(c)
    # (b) MISSING: avail - union (전 component 합쳐도 단가행 없는 차원값 = 진짜 돈샘)
    for d, un in dim_union.items():
        av = avail[p].get(d, set())
        if not av:
            continue
        # ★mat_typ 분리: component가 쓰는 자재유형(원판/부속/색지…)으로 avail 제한.
        #   component_prices가 원판(MAT_TYPE.03)만 쓰면 상품의 후가공 부속(.07)은 비교 제외
        #   (부속은 별도 가산 component가 담당 → 같은 mat_cd 축으로 보면 false-positive).
        if d == 'mat_cd' and un:
            comp_typs = {mat_typ.get(m) for m in un if mat_typ.get(m)}
            if comp_typs:
                av = {m for m in av if mat_typ.get(m) in comp_typs}
        miss = av - un
        if miss:
            conf = 'HIGH' if d in HIGH_DIMS else 'REVIEW'
            cs = ','.join(sorted(set(dim_comps[d])))[:60]
            rows.append([p, f, cs, d, 'MISSING', conf, len(miss),
                         ';'.join(sorted(miss))[:160]])
    # (c) UNDECLARED: 어떤 component가 차원 D로 단가행을 구분하는데(filled 있음) 그 component의
    #   use_dims엔 D 미선언 + 상품이 D 선택수단 보유 → 엔진이 차원 못 봐 silent 가산/무시. 고신뢰.
    for c in comps:
        uds = comp_dims.get(c, [])
        for d in filled[c]:
            if d in SKIP_DIMS or d in uds or d not in CHECK_DIMS:
                continue
            if filled[c][d] and avail[p].get(d):
                rows.append([p, f, c, d, 'UNDECLARED', 'HIGH', len(filled[c][d]),
                             'use_dims미선언(silent가산/무시 위험)'])

# verdict, confidence 순 정렬: HIGH MISSING 먼저
rows.sort(key=lambda r: (r[5] != 'HIGH', r[4] != 'MISSING', r[0], r[2]))
print(f"=== 차원정합 진단{' ['+only+']' if only else ' [전수]'}: {len(rows)}건 ===")
print("prd_cd\tfrm\tcomp\tdim\tverdict\tconf\tcnt\tdetail")
for r in rows:
    print('\t'.join(str(x) for x in r))
miss_hi = sum(1 for r in rows if r[4] == 'MISSING' and r[5] == 'HIGH')
miss_rv = sum(1 for r in rows if r[4] == 'MISSING' and r[5] == 'REVIEW')
und_n = sum(1 for r in rows if r[4] == 'UNDECLARED')
hp = len({r[0] for r in rows if r[5] == 'HIGH'})
print(f"\n--- 요약: MISSING-HIGH(돈샘 고신뢰) {miss_hi}건 · MISSING-REVIEW(검토) {miss_rv}건 "
      f"· UNDECLARED(silent) {und_n}건 · 고신뢰 영향 상품 {hp}개 ---")
