"""Max Page 책등·표지 펼침 산출 — 운영 코드(catalog/spine_calc.py)를 그대로 import 한다.

손으로 산식을 다시 쓰지 않는다. 입력(자재 두께·페이지 상한·spine cfg·완제품 사이즈)은
전부 라이브 DB 실측값이고, 계산은 운영 엔진이 한다.
LLM 숫자 전사 금지 원칙 — 이 스크립트가 결정론 산출기다.
"""
import json
import os
import sys

sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin')
from catalog import spine_calc as SC  # noqa: E402

D = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, D)
import dbq  # noqa: E402


def rows(sql):
    out = dbq.q(sql, tuples=True)
    return [ln.split('\t') for ln in out.strip().splitlines() if ln.strip()]


# ── 라이브 입력 ────────────────────────────────────────────────────────────
CASES = [
    # (부모, 부모명, 제본 proc_cd, 내지 prd, 표지 prd)
    ('PRD_000069', '무선책자', 'PROC_000019', 'PRD_000289', 'PRD_000290'),
    ('PRD_000070', 'PUR책자', 'PROC_000020', 'PRD_000291', 'PRD_000292'),
    ('PRD_000072', '하드커버책자', 'PROC_000023', 'PRD_000291', 'PRD_000073'),
    ('PRD_000077', '레더하드커버책자', 'PROC_000023', 'PRD_000291', 'PRD_000078'),
]

# 완제품(내지) 재단 사이즈 — 표지 펼침의 밑변. 코드 설계의도(spine_widget.py:223~234
# 역방향 폴백 주석): 「무선책자류는 표지가 완성 사이즈를 그대로 따른다」
FINISHED = {}
for r in rows("""SELECT siz_cd, siz_nm, cut_width, cut_height
                 FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000250','SIZ_000252')"""):
    FINISHED[r[0]] = {'nm': r[1], 'w': float(r[2]), 'h': float(r[3])}

cfgs = {}
for r in rows("""SELECT proc_cd, spine_mgn_mm, rnd_typ_cd, cover_incl_yn
                 FROM t_proc_spine_calcs WHERE del_yn='N' AND use_yn='Y'"""):
    cfgs[r[0]] = {'spine_mgn_mm': float(r[1]), 'rnd_typ_cd': r[2],
                  'cover_incl_yn': r[3]}

results = []
for parent, pnm, proc_cd, inner_cd, cover_cd in CASES:
    cfg = cfgs[proc_cd]
    # 내지 최대두께 자재(MAT_TYPE.01 디지털인쇄용지만 — 낱장두께×장수 규칙 대상)
    mrow = rows(f"""SELECT m.mat_cd, m.mat_nm, m.depth
                    FROM t_prd_product_materials pm
                    JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
                    WHERE pm.del_yn='N' AND pm.prd_cd='{inner_cd}'
                      AND m.mat_typ_cd='MAT_TYPE.01' AND m.depth IS NOT NULL
                    ORDER BY m.depth DESC LIMIT 1""")[0]
    mat_cd, mat_nm, depth = mrow[0], mrow[1], float(mrow[2])
    # 페이지 상한 — 양면(POPT_000002) 규칙
    prow = rows(f"""SELECT page_max, print_opt_cd FROM t_prd_product_page_rules
                    WHERE prd_cd='{inner_cd}' AND print_opt_cd='POPT_000002'""")[0]
    page_max = int(prow[0])

    for fin_cd, fin in FINISHED.items():
        members = [{
            'sub_prd_cd': inner_cd, 'semi_role_cd': SC.ROLE_INNER,
            'depth': depth, 'mat_typ_cd': 'MAT_TYPE.01',
            'pages': page_max, 'sides': 2, 'cnt': 1,
        }]
        # 표지는 cover_incl_yn='N' 이라 두께 기여 0 — 그래도 계약대로 넣어 준다
        members.append({
            'sub_prd_cd': cover_cd, 'semi_role_cd': SC.ROLE_COVER,
            'depth': None, 'mat_typ_cd': 'MAT_TYPE.01',
            'pages': None, 'sides': 1, 'cnt': 1,
        })
        size = {'w': fin['w'], 'h': fin['h']}
        res = SC.calc_spine(cfg, members, specs=[], color_nm=None,
                            bind_dir='세로형좌철', size=size, cover_size=size)
        results.append({
            'parent': parent, 'parent_nm': pnm, 'proc_cd': proc_cd,
            'rnd': cfg['rnd_typ_cd'], 'mgn': cfg['spine_mgn_mm'],
            'inner': inner_cd, 'mat': f'{mat_nm}({mat_cd})', 'depth': depth,
            'page_max': page_max, 'sheets': -(-page_max // 2),
            'finished': f"{fin['nm']}({fin_cd})",
            'fin_w': fin['w'], 'fin_h': fin['h'],
            'block_mm': res['block_mm'], 'raw_mm': res['raw_mm'],
            'spine_mm': res['spine_mm'], 'ok': res['ok'],
            'spread': res['spread'], 'fail': res['fail_reason'],
        })

json.dump(results, open(os.path.join(D, 'maxpage_spread.json'), 'w'),
          ensure_ascii=False, indent=1, default=str)

print(f"{'부모':<18}{'완제품':<22}{'최대두께자재':<22}{'장수':>5}"
      f"{'블록mm':>9}{'raw':>8}{'책등':>7}  펼침(WxH)")
print('-' * 108)
for r in results:
    sp = r['spread']
    spread = f"{sp['w']} x {sp['h']}" if sp else '(없음)'
    print(f"{r['parent_nm']:<18}{r['finished']:<22}{r['mat']:<22}"
          f"{r['sheets']:>5}{r['block_mm']:>9}{r['raw_mm']:>8}"
          f"{r['spine_mm']:>7}  {spread}")
