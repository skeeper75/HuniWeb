"""M1③ 축 결정표 — 축마다 근거를 그 상품의 상품 화면 요소로 댄다 (AC-008).

권위 격자의 축 머리와 라이브 그릇의 use_dims 만으로는 AC-008 을 만족하지 못한다.
「그 상품 화면에 실제로 등록되어 있는가」를 상품 등록 표(t_prd_product_*)에서
직접 세어 붙인다. 화면에 없는 축을 켜면 위젯이 값을 보내지 않아 0원이 된다(§D 규칙 1).
"""
import csv
import sys

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
sys.path.insert(0, f'{WT}/_workspace/price-setup/scripts')
import db                                                        # noqa: E402

BASE = f'{WT}/_workspace/price-setup'

# 축 이름 ↔ 그 축이 등록되는 상품 화면 표
AXIS_TABLE = {
    'siz_cd':       ('t_prd_product_sizes',         '사이즈'),
    'mat_cd':       ('t_prd_product_materials',     '자재'),
    'print_opt_cd': ('t_prd_product_print_options', '인쇄옵션'),
    'proc_cd':      ('t_prd_product_processes',     '공정'),
    'plt_siz_cd':   ('t_prd_product_plate_sizes',   '판형사이즈'),
    'bdl_qty':      ('t_prd_product_bundle_qtys',   '묶음수'),
    'opt_cd':       ('t_prd_product_option_groups', '옵션그룹'),
}


def counts_by_product(table):
    out = {}
    for line in db.q(f"SELECT prd_cd, count(*) FROM {table} GROUP BY 1", tuples=True).splitlines():
        if line.strip():
            cd, n = line.split('\t')
            out[cd] = int(n)
    return out


def live_dims_all():
    """모든 그릇의 use_dims 를 직접 읽는다. 매핑표의 한 칸에 기대면
    합쳐 적힌 그릇(`A + B`)에서 값이 비어 축 근거가 통째로 빠진다."""
    out = {}
    for line in db.q("SELECT comp_cd, replace(coalesce(use_dims::text,''), ',', ' ') "
                     "FROM t_prc_price_components", tuples=True).splitlines():
        if line.strip():
            cd, dims = line.split('\t')
            out[cd] = dims
    return out


def main():
    reg = {axis: counts_by_product(t) for axis, (t, _) in AXIS_TABLE.items()}
    all_dims = live_dims_all()
    mapping = list(csv.DictReader(open(f'{BASE}/m1/mapping-43-trackA.csv')))

    rows = []
    for m in mapping:
        prods = [p.split(':', 1) for p in m['products'].split(' | ') if p]
        # 라이브 use_dims 를 축 후보로 삼는다. 표기는 ["a", "b"] 꼴이다.
        raw = m['live_use_dims'] or ''
        if not raw:
            # 합쳐 적힌 그릇은 각 그릇의 use_dims 를 합집합으로 모은다.
            merged = []
            for c in m['live_comp'].split(' + '):
                for d in (all_dims.get(c.strip(), '') or '').split():
                    if d not in merged:
                        merged.append(d)
            raw = ' '.join(merged)
        dims = [d.strip(' []"\'') for d in raw.split()]
        dims = [d for d in dims if d and not d.startswith('opt_grp')]
        ev = []
        for d in dims:
            if d in ('min_qty',):
                ev.append('수량=주문수량(화면 요소 아님)')
                continue
            if d in ('siz_width', 'siz_height'):
                ev.append(f'{d}=직접입력(가로·세로 실측)')
                continue
            tbl = AXIS_TABLE.get(d)
            if not tbl:
                ev.append(f'{d}=대응 화면 표 없음 ★확인필요')
                continue
            label = tbl[1]
            if not prods:
                ev.append(f'{label}: 걸린 상품 없음(그릇만 생성)')
                continue
            have = [c for c, _ in prods if reg[d].get(c)]
            miss = [c for c, _ in prods if not reg[d].get(c)]
            note = f'{label}: 등록 {len(have)}/{len(prods)}상품'
            if miss:
                note += f' ★미등록 {",".join(miss[:4])}'
            ev.append(note)
        rows.append(dict(
            no=m['no'], new_code=m['new_code'], new_name=m['new_name'],
            authority_axis_header=m['authority_axis'],
            live_use_dims=raw,
            product_cnt=m['products_in_scope'],
            screen_evidence=' | '.join(ev),
            verdict=('확인필요' if any('★' in e for e in ev) else '축=화면 등록과 일치')))

    path = f'{BASE}/m1/axis-decision-trackA.csv'
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    need = [r for r in rows if r['verdict'] != '축=화면 등록과 일치']
    print(f'축 결정표 {len(rows)}행 -> {path}')
    print(f'확인 필요 {len(need)}건')
    for r in need:
        print(f"  #{r['no']} {r['new_code']}: {r['screen_evidence']}"[:200])


if __name__ == '__main__':
    main()
