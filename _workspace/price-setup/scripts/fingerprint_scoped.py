"""AC-007 지문 — '손대지 않기로 한 범위'만 남긴 체크섬 (리드 결정 260902 반영).

층 전체에 체크섬을 걸면 43개 그릇과 수천 단가행이 정상적으로 들어오는 순간 반드시
깨진다. 그래서 세 갈래를 뺀다.
 (a) 이번에 손댈 것 — 신설 43코드 · 갈음될 옛 그릇 33개의 사용여부 · 옮겨 걸 공식 44개
 (b) 범위 밖 다른 트랙 — 오늘 같은 라이브를 만지고 있는 추가상품·봉투·굿즈 계열
 (c) 위 그릇들에 딸린 단가행
"""
import csv
import hashlib
import datetime
import sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'
OUT = f'{BASE}/baseline'
TAG = sys.argv[1] if len(sys.argv) > 1 else 'before'

# (b) 범위 밖 트랙 — 리드 승인 제외 목록
OUT_OF_SCOPE = ('ACC_', 'GOODS_', 'FORM_', 'PRF_ACC_', 'COMP_ACC_')

mapping = list(csv.DictReader(open(f'{BASE}/m1/mapping-43-trackA.csv')))
new_codes = sorted({m['new_code'] for m in mapping})
old_comps = sorted({c for m in mapping for c in m['live_comp'].split(' + ') if c})
frms = sorted({f for m in mapping for f in m['formulas'].split() if f})


def q_in(vals):
    return ', '.join("'" + v.replace("'", "''") + "'" for v in vals) or "''"


def not_oos(col):
    return ' AND '.join(f"{col} NOT LIKE '{p}%'" for p in OUT_OF_SCOPE)


LAYERS = {
    'components': f"""
        SELECT comp_cd, comp_nm, comp_typ_cd, prc_typ_cd,
               coalesce(use_dims::text,'') AS use_dims, use_yn,
               coalesce(del_yn,'') AS del_yn
        FROM t_prc_price_components
        WHERE comp_cd NOT IN ({q_in(new_codes)})
          AND comp_cd NOT IN ({q_in(old_comps)})
          AND {not_oos('comp_cd')}
        ORDER BY comp_cd
    """,
    'formulas': f"""
        SELECT frm_cd, frm_nm, use_yn FROM t_prc_price_formulas
        WHERE frm_cd NOT IN ({q_in(frms)}) AND {not_oos('frm_cd')}
        ORDER BY frm_cd
    """,
    'formula_components': f"""
        SELECT frm_cd, comp_cd, disp_seq, coalesce(addtn_yn,'') AS addtn_yn
        FROM t_prc_formula_components
        WHERE frm_cd NOT IN ({q_in(frms)}) AND {not_oos('frm_cd')}
          AND comp_cd NOT IN ({q_in(new_codes)}) AND {not_oos('comp_cd')}
        ORDER BY frm_cd, comp_cd, disp_seq
    """,
    'component_prices': f"""
        SELECT comp_price_id, comp_cd, coalesce(apply_ymd,'') AS apply_ymd,
               coalesce(siz_cd,'') AS siz_cd, coalesce(clr_cd,'') AS clr_cd,
               coalesce(mat_cd,'') AS mat_cd, coalesce(proc_cd,'') AS proc_cd,
               coalesce(opt_cd,'') AS opt_cd, coalesce(print_opt_cd,'') AS print_opt_cd,
               coalesce(plt_siz_cd,'') AS plt_siz_cd,
               coalesce(coat_side_cnt,-1) AS coat_side_cnt,
               coalesce(spot_side_cnt,-1) AS spot_side_cnt,
               coalesce(page_cnt,-1) AS page_cnt, coalesce(bdl_qty,-1) AS bdl_qty,
               coalesce(min_qty,-1) AS min_qty,
               coalesce(siz_width,-1) AS siz_width, coalesce(siz_height,-1) AS siz_height,
               unit_price
        FROM t_prc_component_prices
        WHERE comp_cd NOT IN ({q_in(new_codes)}) AND {not_oos('comp_cd')}
        ORDER BY comp_price_id
    """,
}


def checksum(path):
    h = hashlib.md5()
    with open(path, 'rb') as f:
        next(f, None)
        for line in f:
            h.update(line)
    return h.hexdigest()


def main():
    stamp = datetime.datetime.now(datetime.timezone.utc).isoformat(timespec='seconds')
    rows = []
    for name, sql in LAYERS.items():
        path = f'{OUT}/scoped-{name}-{TAG}.csv'
        n = db.to_csv(' '.join(sql.split()), path)
        rows.append((name, n, checksum(path), f'scoped-{name}-{TAG}.csv'))
        print(f'{name:20s} {n:>7,}행  md5 {rows[-1][2]}')

    path = f'{OUT}/scoped-fingerprint-{TAG}.csv'
    with open(path, 'w') as f:
        f.write('layer,row_count,md5_scoped,source_csv,captured_at_utc\n')
        for name, n, md5, src in rows:
            f.write(f'{name},{n},{md5},{src},{stamp}\n')

    # 무엇을 뺐는지 함께 남긴다 — 제외 목록이 없으면 체크섬을 재현할 수 없다.
    ex = f'{OUT}/scoped-exclusions-{TAG}.csv'
    with open(ex, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['kind', 'value'])
        for c in new_codes:
            w.writerow(['신설 예정 코드', c])
        for c in old_comps:
            w.writerow(['갈음될 옛 그릇', c])
        for c in frms:
            w.writerow(['옮겨 걸 공식', c])
        for p in OUT_OF_SCOPE:
            w.writerow(['범위 밖 트랙 접두', p + '*'])
    print(f'\n지문 {path}\n제외목록 {ex} '
          f'(신설 {len(new_codes)} · 옛그릇 {len(old_comps)} · 공식 {len(frms)} · 접두 {len(OUT_OF_SCOPE)})')


if __name__ == '__main__':
    main()
