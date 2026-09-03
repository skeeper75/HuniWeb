"""트랙 B P6 골든 — 교정 대상 3그릇(귀돌이·오시·미싱)을 무는 상품의 실제 계산 금액.

golden.py 의 엔진 호출을 그대로 재사용한다(읽기 전용 · save/create/update 없음).
차이점 둘:
  ① 상품뷰어 meta 가 **실제로 내주는** 공정 목록에서 대상 공정을 고른다.
     상품은 부모 공정(오시 PROC_000029·미싱 PROC_000030)을 등록하고 그릇은
     자식(PROC_000090·PROC_000086)으로 매칭하므로, 등록 코드로 상품을 찾으면
     미싱이 통째로 빠진다(첫 판에서 실제로 0줄이 나왔다).
  ② 교정 경계 수량을 훑는다.
사용: golden_b.py <tag>   예) golden_b.py p6-before
"""
import csv, sys

MYTAG = sys.argv[1] if len(sys.argv) > 1 else 'p6-before'
sys.argv = [sys.argv[0]]                      # golden.py 의 TAG 파싱을 무해하게 통과
import golden as G                            # django.setup() 포함

TARGET = {                       # 자식 공정 → (그릇, 상세파라미터)
    'PROC_000028': ('COMP_PP_CORNER_RIGHT', {}),          # 둥근모서리(4방4R)
    'PROC_000090': ('COMP_PP_CREASE_1L', {'줄수': 1}),     # 오시 1줄
    'PROC_000086': ('COMP_PP_PERF_1L', {'줄수': 1}),       # 미싱 1줄
}
QTYS = [100, 101, 300, 301, 500, 1000, 5000, 6000, 10000]   # 교정 경계 + 대조군
PER_COMP = 3                                                # 그릇마다 대표 상품 수


def proc_options(meta):
    for d in meta.get('prod_dims') or []:
        if d.get('kind') == 'proc':
            return [o.get('v') for o in (d.get('options') or [])]
    return []


def main():
    import db as DBH
    # 3그릇을 무는 공식에 걸린 상품 전체가 후보다.
    prds = [l.strip() for l in DBH.q(
        """SELECT DISTINCT pf.prd_cd FROM t_prd_product_price_formulas pf
           WHERE pf.frm_cd IN (SELECT DISTINCT frm_cd FROM t_prc_formula_components
             WHERE comp_cd IN ('COMP_PP_CORNER_RIGHT','COMP_PP_CREASE_1L','COMP_PP_PERF_1L'))
           ORDER BY 1""", tuples=True).splitlines() if l.strip()]
    print(f'후보 상품 {len(prds)}')
    rows, failed, taken = [], [], {c: 0 for c, _ in TARGET.values()}
    for prd in prds:
        try:
            meta = G.PV._build_sim_meta(prd)
        except Exception as e:                            # noqa: BLE001
            failed.append((prd, f'meta 실패: {e}')); continue
        avail = set(proc_options(meta))
        sel, base_procs = G.base_selection(meta)
        for proc, (comp, detail) in TARGET.items():
            if proc not in avail or taken[comp] >= PER_COMP:
                continue
            procs = [p for p in base_procs if p.get('proc_cd') != proc]
            procs.append({'proc_cd': proc, 'detail': dict(detail)})
            for q in QTYS:
                try:
                    r = G.run(prd, f'{comp}·{proc}·수량{q}', sel, q, procs)
                    r['target_comp'], r['target_proc'] = comp, proc
                    rows.append(r)
                except Exception as e:                    # noqa: BLE001
                    failed.append((prd, f'{comp} 수량{q}: {e}'))
            taken[comp] += 1
            print(f'  {comp} {prd} · {len(QTYS)}수량', flush=True)
    path = f'{G.BASE}/golden/golden-{MYTAG}.csv'
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader(); w.writerows(rows)
    print(f'골든 {len(rows)}줄 · 상품 {len({r["prd_cd"] for r in rows})} · 그릇별 {taken} -> {path}')
    zero = [r for r in rows if not r['final_price']]
    print(f'계산 실패 {len(failed)}건 · 0원/계산불가 {len(zero)}줄')
    for p, m in failed[:8]:
        print('  실패:', p, str(m)[:130])
    for r in zero[:8]:
        print(f'  0원: {r["prd_cd"]} {r["combo"]} — {(r["errors"] or r["warnings"])[:120]}')


if __name__ == '__main__':
    main()
