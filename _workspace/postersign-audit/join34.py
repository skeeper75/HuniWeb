"""상품별 정합 4축 개별 판정표 — AC-PC-009 / AC-PC-010 / AC-PC-012.

무엇을 하나
    한 상품의 판정을 네 축(① 구성요소 존재 ② 가격 배선 ③ 값 정합 ④ 위젯 표시)으로
    **각각** 적는다. 총계는 상품별 구멍을 가린다 — 실제로 축③ 총계는 「일치 756 · VALUE 0」
    이었지만 상품별로 쪼개니 5개 상품은 대조 자체가 안 된 상태였다.

규약
    · 분모는 **라이브(상품뷰어)** 다 — 권위 엑셀을 분모로 삼지 않는다(AC-PC-002).
    · 빈칸을 남기지 않는다. 판정하지 못했으면 PASS 가 아니라 `UNVERIFIED` 라고 적는다.
      실패 신호가 없다는 것은 통과의 증거가 아니다.
    · 축①·②는 라이브 SELECT 로 이 자리에서 잰다. 축③은 `diff.py --emit` 산출,
      축④는 `axis4.py` 산출을 그대로 읽는다 — LLM 이 값을 전사하지 않는다(AC-PC-011).
    · 축④ 비교 필드는 `supply` 다. `total` 을 권위와 비교하지 않는다(AC-PC-012).
    · 라이브는 SELECT 만. 쓰기 질의 없음(AC-PC-014).

use_dims 함정 [HARD]
    이 SPEC 에서 컬럼 부재를 결함으로 오판한 사고가 세 번 났다(min_qty 축 오인 ·
    siz_cd 고아 88건 · 기본값 27건). 원인은 하나다 — `use_dims` 를 보지 않고
    「그 컬럼이 없다」를 결함으로 센 것. 고아 판정은 반드시 use_dims 게이팅을 먼저 건다.

사용
    python3 join34.py                       # 최신 산출물로 결합
    python3 join34.py --lo PRD_000052 --hi PRD_000067   # 다른 마일스톤
"""
import argparse
import collections
import csv
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))

# ── 축①·② 라이브 질의 (SELECT 전용) ──────────────────────────────────────────
# 공식 바인딩 → 구성요소 → 단가행 인벤토리. LEFT JOIN 이라 배선이 끊긴 곳도 행으로 남는다.
SQL_WIRING = """
SELECT ppf.prd_cd, p.prd_nm, ppf.frm_cd,
       COALESCE(fc.comp_cd,''), COALESCE(fc.disp_seq::text,''), COALESCE(fc.addtn_yn,''),
       COALESCE(pc.comp_cd,''), COALESCE(pc.comp_nm,''),
       COALESCE(pc.use_dims::text,''),
       COALESCE((SELECT COUNT(*) FROM t_prc_component_prices cp
                 WHERE cp.comp_cd = pc.comp_cd)::text,'0')
FROM t_prd_product_price_formulas ppf
JOIN t_prd_products p            ON p.prd_cd = ppf.prd_cd
LEFT JOIN t_prc_formula_components fc ON fc.frm_cd = ppf.frm_cd
LEFT JOIN t_prc_price_components pc   ON pc.comp_cd = fc.comp_cd
                                     AND COALESCE(pc.del_yn,'N') <> 'Y'
WHERE ppf.prd_cd BETWEEN :LO AND :HI
ORDER BY 1, 3, 5
"""

# 고아 사이즈 — 두 겹의 한정이 **둘 다** 필요하다. 하나만 걸면 오판이 남는다.
#   (1) use_dims 가 siz_cd 를 가격축으로 선언한 구성요소로 한정 — 빼면 88건(M4-6 오판)
#   (2) 삭제·미사용 사이즈 제외(AC-PC-003) — 빼면 18건이 나오는데 전부 도달 불가였다.
#       위젯 catalog 실측 결과 그 18종은 고객 선택지에 아예 없다(M4-14).
SQL_ORPHAN = """
SELECT ppf.prd_cd, pc.comp_cd, pps.siz_cd, s.siz_nm
FROM t_prd_product_price_formulas ppf
JOIN t_prc_formula_components fc ON fc.frm_cd = ppf.frm_cd
JOIN t_prc_price_components pc   ON pc.comp_cd = fc.comp_cd
                                AND COALESCE(pc.del_yn,'N') <> 'Y'
                                AND pc.use_dims::text LIKE '%siz_cd%'
JOIN t_prd_product_sizes pps     ON pps.prd_cd = ppf.prd_cd
                                AND COALESCE(pps.del_yn,'N') <> 'Y'
JOIN t_siz_sizes s               ON s.siz_cd = pps.siz_cd
                                AND COALESCE(s.use_yn,'Y') = 'Y'
                                AND COALESCE(s.del_yn,'N') <> 'Y'
WHERE ppf.prd_cd BETWEEN :LO AND :HI
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices cp
                  WHERE cp.comp_cd = pc.comp_cd AND cp.siz_cd = pps.siz_cd)
ORDER BY 1, 2, 3
"""


def env():
    e = dict(os.environ)
    with open(os.path.join(ROOT, '.env.local'), encoding='utf-8') as f:
        for line in f:
            if '=' in line and not line.lstrip().startswith('#'):
                k, _, v = line.partition('=')
                e.setdefault(k.strip(), v.strip().strip('"').strip("'"))
    e['PGPASSWORD'] = e['RAILWAY_DB_PASSWORD']
    return e


def sql(query, lo, hi):
    e = env()
    out = subprocess.run(
        ['psql', '-h', e['RAILWAY_DB_HOST'], '-p', e['RAILWAY_DB_PORT'],
         '-U', e['RAILWAY_DB_USER'], '-d', e['RAILWAY_DB_NAME'],
         '-A', '-F', '|', '-t', '-c', query.replace(':LO', f"'{lo}'").replace(':HI', f"'{hi}'")],
        env=e, capture_output=True, text=True, check=True).stdout
    return [line.split('|') for line in out.splitlines() if line.strip()]


def latest(pattern):
    """파일명 정렬이 아니라 mtime 으로 고른다 — '-'(0x2D) < '.'(0x2E) 라 구판이 뒤로 간다."""
    import glob
    files = glob.glob(os.path.join(HERE, pattern))
    return max(files, key=os.path.getmtime) if files else None


# ── 축①·② 판정 ──────────────────────────────────────────────────────────────
def axis12(lo, hi):
    wiring = sql(SQL_WIRING, lo, hi)
    orphan = sql(SQL_ORPHAN, lo, hi)

    # 고아는 단위가 둘이고 값이 다르다 — 하나만 적으면 다음 사람이 같은 자리에서 헷갈린다.
    #   배선단위 (comp × siz) : 채워야 할 단가행 수. 한 상품에 siz_cd 축 구성요소가
    #                           둘이면(완제품가 + 옵션 추가가격) 같은 사이즈가 두 번 센다.
    #   고객단위 (prd × siz)  : 고객이 겪는 증상 수. M4-6 의 18건이 이 단위이고,
    #                           축④ 교차도 (prd_cd, siz_nm) 로 했으므로 이쪽과 맞물린다.
    orphans = collections.defaultdict(list)          # 배선단위
    orphan_sizes = collections.defaultdict(set)      # 고객단위
    for prd, comp, siz, siz_nm in orphan:
        orphans[prd].append(f'{siz}({siz_nm})')
        orphan_sizes[prd].add(siz)

    by_prd = collections.defaultdict(list)
    names = {}
    for r in wiring:
        by_prd[r[0]].append(r)
        names[r[0]] = r[1]

    out = {}
    for prd, rows in by_prd.items():
        comps = [r for r in rows if r[3]]                       # fc.comp_cd 가 있는 행
        dangling = [r for r in comps if not r[6]]               # fc 는 있는데 pc 가 없다
        priced = [r for r in comps if r[6] and int(r[9]) > 0]

        # 축① 구성요소 존재 — 공식이 있고, 구성요소가 실재하고, 단가행이 붙어 있는가
        if not comps:
            a1, a1b = 'FAIL', '공식에 구성요소 0건'
        elif dangling:
            a1, a1b = 'FAIL', f'구성요소 참조 끊김 {len(dangling)}건'
        elif not priced:
            a1, a1b = 'FAIL', f'단가행 붙은 구성요소 0건(구성요소 {len(comps)})'
        else:
            a1, a1b = 'PASS', f'구성요소 {len(comps)} · 단가행 보유 {len(priced)}'

        # 축② 가격 배선 — AC-PC-010 이 요구하는 네 항목을 각각 판정한다
        s_main = 'PASS' if comps else 'FAIL'

        seen = collections.Counter((r[2], r[3]) for r in comps)  # (frm_cd, comp_cd)
        dup = [k for k, n in seen.items() if n > 1]
        s_dup = 'PASS' if not dup else 'FAIL'

        noseq = [r for r in comps if r[4] == '']
        seqdup = [k for k, n in collections.Counter(
            (r[2], r[4]) for r in comps if r[4]).items() if n > 1]
        s_seq = 'PASS' if comps and not noseq and not seqdup else ('FAIL' if comps else 'FAIL')

        s_orphan = 'PASS' if not orphans[prd] else 'FAIL'

        subs = [s_main, s_dup, s_seq, s_orphan]
        a2 = 'PASS' if all(s == 'PASS' for s in subs) else 'FAIL'
        a2b = ' · '.join([
            f'본품 {s_main}',
            f'중복구성요소 {s_dup}' + (f'({len(dup)})' if dup else ''),
            f'disp_seq {s_seq}' + (f'(미설정 {len(noseq)}/중복 {len(seqdup)})'
                                   if (noseq or seqdup) else ''),
            f'고아 {s_orphan}' + (f'(배선 {len(orphans[prd])} / 고객 {len(orphan_sizes[prd])}건: '
                                  + ", ".join(sorted(orphan_sizes[prd])[:3])
                                  + (' …' if len(orphan_sizes[prd]) > 3 else '') + ')'
                                  if orphans[prd] else ''),
        ])
        out[prd] = dict(prd_nm=names[prd], a1=a1, a1b=a1b, a2=a2, a2b=a2b,
                        s_main=s_main, s_dup=s_dup, s_seq=s_seq, s_orphan=s_orphan,
                        n_orphan_wiring=len(orphans[prd]),
                        n_orphan_size=len(orphan_sizes[prd]))
    return out


# ── 축④ 판정 ────────────────────────────────────────────────────────────────
def axis4(path):
    """axis4 산출을 상품별로 접는다. 비교 필드는 supply 다(AC-PC-012)."""
    out = {}
    if not path:
        return out
    rows = collections.defaultdict(list)
    with open(path, encoding='utf-8') as f:
        for r in csv.DictReader(f):
            rows[r['prd_cd']].append(r)
    for prd, rs in rows.items():
        ok = [r for r in rs if not r['err'] and r['supply']]
        bad = [r for r in rs if r['err']]
        kinds = collections.Counter(r['err'].split()[0] if r['err'] else '' for r in bad)
        if not rs:
            v, b = 'UNVERIFIED', '축④ 미실행'
        elif bad:
            v = 'FAIL'
            b = (f'{len(rs)}조합 중 실패 {len(bad)} — '
                 + ' · '.join(f'{k}:{n}' for k, n in kinds.most_common()))
        else:
            v, b = 'PASS', f'{len(ok)}조합 전건 supply 산출'
        out[prd] = dict(a4=v, a4b=b, n_try=len(rs), n_ok=len(ok), n_fail=len(bad))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--lo', default='PRD_000118')
    ap.add_argument('--hi', default='PRD_000145')
    ap.add_argument('--a3', default=None, help='diff.py --emit 산출 CSV')
    ap.add_argument('--a4', default=None, help='axis4.py 산출 CSV')
    ap.add_argument('--out', default=None, help='결합 판정표 출력 경로')
    args = ap.parse_args()

    a3_path = args.a3 or os.path.join(HERE, 'axis3-per-product.csv')
    a4_path = args.a4 or latest('axis4-*.csv')
    out_path = args.out or os.path.join(HERE, 'axis-verdict-28.csv')

    if not os.path.exists(a3_path):
        sys.exit(f'축③ 산출이 없습니다: {a3_path}\n  먼저: python3 diff.py --emit {a3_path}')

    a3 = {r['prd_cd']: r for r in csv.DictReader(open(a3_path, encoding='utf-8'))}
    a4 = axis4(a4_path)
    a12 = axis12(args.lo, args.hi)

    # 분모는 라이브다 — 공식이 바인딩된 상품 전체(AC-PC-002).
    prds = sorted(set(a12) | set(a3))

    hdr = ['prd_cd', 'prd_nm',
           'axis1_구성요소존재', 'axis1_근거',
           'axis2_가격배선', 'axis2_본품', 'axis2_중복구성요소', 'axis2_disp_seq',
           'axis2_고아', 'axis2_고아_배선단위', 'axis2_고아_고객단위', 'axis2_근거',
           'axis3_값정합', 'axis3_근거',
           'axis4_위젯가격산출', 'axis4_근거',
           '종단판정', '종단_성격', '잔여']
    table = []
    for p in prds:
        w = a12.get(p, {})
        t3 = a3.get(p, {})
        t4 = a4.get(p, {})
        v1 = w.get('a1', 'UNVERIFIED')
        v2 = w.get('a2', 'UNVERIFIED')
        v3 = t3.get('a3_verdict', 'UNVERIFIED')
        v4 = t4.get('a4', 'UNVERIFIED')
        vs = [v1, v2, v3, v4]
        if 'FAIL' in vs:
            end = 'FAIL'
        elif 'UNVERIFIED' in vs:
            end = 'UNVERIFIED'
        else:
            end = 'PASS'
        rest = ' · '.join(
            f'축{i}' for i, v in zip('①②③④', vs) if v == 'UNVERIFIED') or ''
        table.append([
            p, w.get('prd_nm') or t3.get('prd_nm', ''),
            v1, w.get('a1b', '축①·② 미실측'),
            v2, w.get('s_main', ''), w.get('s_dup', ''), w.get('s_seq', ''),
            w.get('s_orphan', ''), w.get('n_orphan_wiring', ''), w.get('n_orphan_size', ''),
            w.get('a2b', '축② 미실측'),
            v3, t3.get('a3_basis', '축③ 산출에 이 상품 없음'),
            v4, t4.get('a4b', '축④ 미실행'),
            end,
            # 위젯 supply 를 권위에 **직접** 댄 것이 아니다. 축③(라이브 단가↔권위)과
            # 축④(위젯↔가격 산출)를 이어 붙인 결합 추론이다. AC-PC-013 이 요구하는
            # 「응답 supply 와 권위값이 한 기록 안에 함께 있고 일치」는 아직 3건뿐이다.
            '결합추론(축③ DB↔권위 ∧ 축④ 위젯↔산출)' if end == 'PASS' else '',
            rest,
        ])

    with open(out_path, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(hdr)
        w.writerows(table)

    # ── 보고 ─────────────────────────────────────────────────────────────────
    print(f'분모(라이브 공식 바인딩 상품) {len(prds)}건')
    print(f'축③ 입력: {os.path.basename(a3_path)}')
    print(f'축④ 입력: {os.path.basename(a4_path) if a4_path else "(없음)"}')
    ix = {h: i for i, h in enumerate(hdr)}
    axis_cols = ['axis1_구성요소존재', 'axis2_가격배선', 'axis3_값정합', 'axis4_위젯가격산출']

    print(f'\n{"축":<22}{"PASS":>6}{"FAIL":>6}{"UNVERIFIED":>12}')
    print('-' * 46)
    for col, name in zip(axis_cols + ['종단판정'],
                         ('① 구성요소 존재', '② 가격 배선', '③ 값 정합',
                          '④ 위젯 가격산출', '종단')):
        c = collections.Counter(r[ix[col]] for r in table)
        print(f'{name:<20}{c["PASS"]:>6}{c["FAIL"]:>6}{c["UNVERIFIED"]:>12}')

    blank = sum(1 for r in table for col in axis_cols if not r[ix[col]])
    print(f'\n축 미기재(빈칸) {blank}건 — AC-PC-009 는 0건을 요구한다')

    ow = sum(r[ix['axis2_고아_배선단위']] or 0 for r in table)
    os_ = sum(r[ix['axis2_고아_고객단위']] or 0 for r in table)
    print(f'축② 고아 — 배선단위(comp × siz) {ow}건 · 고객단위(prd × siz) {os_}건')
    print('  삭제·미사용 사이즈 제외 후의 수다(AC-PC-003). 필터를 빼면 18건이 나오지만,')
    print('  그 18종은 위젯 선택지에 없어 고객이 도달할 수 없다 — 결함이 아니다(M4-14).')

    bad = [r for r in table if r[ix['종단판정']] != 'PASS']
    print(f'\n■ 종단 미통과 {len(bad)}건')
    for r in bad:
        axes = ' '.join(f'{n}{r[ix[c]][0]}' for n, c in zip('①②③④', axis_cols))
        print(f'  {r[0]} {r[1]:<18} [{axes}]  {r[ix["잔여"]] or r[ix["종단판정"]]}')

    print(f'\n판정표 {len(table)}행 → {out_path}')
    print('※ 축④ 비교 필드는 supply 다(AC-PC-012). total 을 권위와 비교한 건 0건.')
    print('※ 종단 PASS 는 축③(DB 단가↔권위) ∧ 축④(위젯↔가격 산출)의 **결합 추론**이다.')
    print('   AC-PC-013 이 요구하는 「응답 supply 와 권위값이 한 기록에 함께 있고 일치」를')
    print('   직접 만족한 건은 M4-9 의 수기 3건뿐이다 — axis4 산출에 권위값·조회일시 열이 없다.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
