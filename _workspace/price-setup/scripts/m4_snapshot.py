"""M4 재배선 직전 스냅샷 — 되돌릴 때 보고 화면에서 원래대로 돌리기 위한 자료.

화면 갈무리는 복구 입력이 못 된다. 되돌리려면 「어느 공식이 어느 그릇을 어느 순서로
보고 있었는가」와 「할인이 어느 그릇을 지목하고 있었는가」가 표로 있어야 한다.
전부 조회다 — 쓰기 없음.
"""
import csv
import datetime
import sys

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
sys.path.insert(0, f'{BASE}/scripts')
import db                                                        # noqa: E402

OUT = f'{BASE}/rollback'
tag = sys.argv[1] if len(sys.argv) > 1 else 'm4'

mapping = list(csv.DictReader(open(f'{BASE}/m1/mapping-43-trackA.csv')))
old_comps = sorted({c for m in mapping for c in m['live_comp'].split(' + ') if c.strip()})
new_comps = sorted({m['new_code'] for m in mapping})
frms = sorted({f for m in mapping for f in m['formulas'].split() if f})


def q_in(v):
    return ', '.join("'" + x.replace("'", "''") + "'" for x in v) or "''"


JOBS = {
    # 배선 되돌리기 자료 — 공식이 어느 그릇을 어느 순서로 보고 있었는가
    'wiring-before': f"""
        SELECT fc.frm_cd, f.frm_nm, fc.comp_cd, c.comp_nm, fc.disp_seq,
               coalesce(fc.addtn_yn,'') AS addtn_yn
        FROM t_prc_formula_components fc
        JOIN t_prc_price_formulas f ON f.frm_cd = fc.frm_cd
        JOIN t_prc_price_components c ON c.comp_cd = fc.comp_cd
        WHERE fc.frm_cd IN ({q_in(frms)}) ORDER BY fc.frm_cd, fc.disp_seq, fc.comp_cd
    """,
    # 할인 적용 범위 — 구성요소를 지목한 행이 핵심이다(그릇을 내리면 조용히 끊긴다)
    'discount-binding-before': """
        SELECT d.prd_cd, p.prd_nm, d.dsc_tbl_cd, coalesce(d.comp_cd,'') AS comp_cd,
               d.apply_bgn_ymd
        FROM t_prd_product_discount_tables d
        JOIN t_prd_products p ON p.prd_cd = d.prd_cd
        ORDER BY (d.comp_cd IS NULL), d.prd_cd
    """,
    # 옛 그릇의 사용 여부 — M6 에서 내리기 전 상태
    'old-vessels-before': f"""
        SELECT comp_cd, comp_nm, use_yn, coalesce(del_yn,'') AS del_yn, prc_typ_cd,
               replace(coalesce(use_dims::text,''), ',', ' ') AS use_dims
        FROM t_prc_price_components WHERE comp_cd IN ({q_in(old_comps)}) ORDER BY comp_cd
    """,
    # 새 그릇의 현재 상태 — 재배선이 이 그릇들을 가리키게 된다
    'new-vessels-before': f"""
        SELECT c.comp_cd, c.comp_nm, c.use_yn, c.prc_typ_cd,
               replace(coalesce(c.use_dims::text,''), ',', ' ') AS use_dims,
               count(p.comp_price_id) AS price_rows
        FROM t_prc_price_components c
        LEFT JOIN t_prc_component_prices p ON p.comp_cd = c.comp_cd
        WHERE c.comp_cd IN ({q_in(new_comps)}) GROUP BY 1,2,3,4,5 ORDER BY 1
    """,
    # 상품↔공식 묶임 — 어느 상품이 어느 공식을 쓰는가
    'product-formula-before': f"""
        SELECT pf.prd_cd, p.prd_nm, pf.frm_cd, p.use_yn
        FROM t_prd_product_price_formulas pf
        JOIN t_prd_products p ON p.prd_cd = pf.prd_cd
        WHERE pf.frm_cd IN ({q_in(frms)}) ORDER BY pf.frm_cd, pf.prd_cd
    """,
}


def main():
    stamp = datetime.datetime.now(datetime.timezone.utc).isoformat(timespec='seconds')
    lines = []
    for name, sql in JOBS.items():
        path = f'{OUT}/{name}-{tag}.csv'
        n = db.to_csv(' '.join(sql.split()), path)
        lines.append((name, n, f'{name}-{tag}.csv'))
        print(f'{name:26s} {n:>6}행 -> {path}')
    with open(f'{OUT}/manifest-{tag}.csv', 'w') as f:
        f.write('artifact,row_count,file,captured_at_utc\n')
        for name, n, fn in lines:
            f.write(f'{name},{n},{fn},{stamp}\n')
    print(f'\n매니페스트 {OUT}/manifest-{tag}.csv')
    print('※ 범위한정 지문은 scripts/fingerprint_scoped.py 로 따로 뜬다')


if __name__ == '__main__':
    main()
