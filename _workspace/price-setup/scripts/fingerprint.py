"""M1① 라이브 세 층 지문 — 작업 전 기준선. 조회만 한다.

네 개의 표를 결정론 순서로 CSV 에 내리고, 각 표의 행 수 · 가장 최근 수정시각 ·
전체 정렬 체크섬을 요약 파일에 남긴다. AC-007 이 볼 '손대지 않기로 한 범위'
체크섬은 이 원본에서 나중에(M1③ 이 대상 목록을 고정한 뒤) 계산한다.
"""
import hashlib
import sys
import datetime
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db

OUT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/baseline'
TAG = 'before'

LAYERS = {
    'components': """
        SELECT comp_cd, comp_nm, comp_typ_cd, prc_typ_cd,
               coalesce(use_dims::text,'') AS use_dims,
               use_yn, coalesce(del_yn,'') AS del_yn
        FROM t_prc_price_components ORDER BY comp_cd
    """,
    'formulas': """
        SELECT frm_cd, frm_nm, use_yn
        FROM t_prc_price_formulas ORDER BY frm_cd
    """,
    'formula_components': """
        SELECT frm_cd, comp_cd, disp_seq, coalesce(addtn_yn,'') AS addtn_yn
        FROM t_prc_formula_components ORDER BY frm_cd, comp_cd, disp_seq
    """,
    'component_prices': """
        SELECT comp_price_id, comp_cd, coalesce(apply_ymd,'') AS apply_ymd,
               coalesce(siz_cd,'') AS siz_cd, coalesce(clr_cd,'') AS clr_cd,
               coalesce(mat_cd,'') AS mat_cd, coalesce(proc_cd,'') AS proc_cd,
               coalesce(opt_cd,'') AS opt_cd, coalesce(print_opt_cd,'') AS print_opt_cd,
               coalesce(plt_siz_cd,'') AS plt_siz_cd,
               coalesce(coat_side_cnt,-1) AS coat_side_cnt,
               coalesce(spot_side_cnt,-1) AS spot_side_cnt,
               coalesce(page_cnt,-1) AS page_cnt,
               coalesce(bdl_qty,-1) AS bdl_qty, coalesce(min_qty,-1) AS min_qty,
               coalesce(siz_width,-1) AS siz_width, coalesce(siz_height,-1) AS siz_height,
               unit_price
        FROM t_prc_component_prices ORDER BY comp_price_id
    """,
}

UPD = {
    'components': 't_prc_price_components',
    'formulas': 't_prc_price_formulas',
    'formula_components': 't_prc_formula_components',
    'component_prices': 't_prc_component_prices',
}


def checksum(path):
    """헤더를 뺀 본문 전체의 md5. 행 순서가 SQL 로 고정되어 있어 결정론이다."""
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
        path = f'{OUT}/{name}-{TAG}.csv'
        n = db.to_csv(' '.join(sql.split()), path)
        upd = db.q(f"SELECT coalesce(max(upd_dt)::text, coalesce(max(reg_dt)::text,'')) "
                   f"FROM {UPD[name]}", tuples=True).strip()
        rows.append((name, n, upd, checksum(path), f'{name}-{TAG}.csv'))
        print(f'{name:20s} {n:>7,}행  최근수정 {upd}  md5 {rows[-1][3]}')

    summary = f'{OUT}/live-fingerprint-{TAG}.csv'
    with open(summary, 'w') as f:
        f.write('layer,row_count,max_upd_dt,md5_full,source_csv,captured_at_utc\n')
        for name, n, upd, md5, src in rows:
            f.write(f'{name},{n},{upd},{md5},{src},{stamp}\n')
    print(f'\n요약: {summary}')


if __name__ == '__main__':
    main()
