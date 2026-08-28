"""권위 격자(엑셀) ↔ 라이브 단가행 셀 단위 대조 — 결정론."""
import csv, collections

AUTH = '_workspace/postersign-audit/authority.csv'
LIVE = '_workspace/postersign-audit/live-snapshot-260828.csv'

MAP = {
 '아트프린트포스터 (인화지)':['PRD_000118'], '아트페이퍼포스터 (매트지)':['PRD_000119'],
 '방수포스터 (PET)':['PRD_000120'], '접착방수포스터 (PVC)':['PRD_000121'],
 '접착투명포스터 (투명PVC)':['PRD_000122'], '아트패브릭포스터 (그래픽천)':['PRD_000123'],
 '린넨패브릭포스터':['PRD_000124'], '캔버스패브릭포스터':['PRD_000125'],
 '레더아트프린트':['PRD_000126'], '타이벡프린트 (하드 / 소프트)':['PRD_000127'],
 '메쉬프린트':['PRD_000128'], '폼보드':['PRD_000129'], '포맥스보드':['PRD_000130'],
 '프레임리스우드액자':['PRD_000131'], '레더아트액자':['PRD_000132'],
 '캔버스행잉포스터':['PRD_000133'], '린넨우드봉족자':['PRD_000134'], '족자포스터':['PRD_000135'],
 'PET배너':['PRD_000136'], '메쉬배너':['PRD_000137'],
 '일반현수막':['PRD_000138'], '메쉬현수막':['PRD_000139'],
 '시트커팅 (무광 / 홀로그램)':['PRD_000140','PRD_000141'],
 '아크릴스티커 (유광 / 미러)':['PRD_000142','PRD_000143'],
 '미니스탠딩보드':['PRD_000144'], '미니배너':['PRD_000145'],
}

auth = list(csv.DictReader(open(AUTH, encoding='utf-8')))
live = list(csv.DictReader(open(LIVE, encoding='utf-8')))

a_main = collections.defaultdict(list)
for r in auth:
    if r['kind'] == 'main':
        a_main[r['block']].append(int(r['price']))

l_by_prd = collections.defaultdict(list)
comps_by_prd = collections.defaultdict(set)
for r in live:
    l_by_prd[r['prd_cd']].append(r)
    comps_by_prd[r['prd_cd']].add((r['comp_cd'], r['comp_nm']))

print(f"{'엑셀 블록':<26} {'상품':<26} {'엑셀셀':>5} {'라이브행':>7} {'구성요소':>5}  판정")
print('-'*95)
tot_ok = tot_bad = 0
for block, prds in MAP.items():
    acells = len(a_main.get(block, []))
    lrows = sum(len([r for r in l_by_prd[p] if r['unit_price']]) for p in prds)
    ncomp = sum(len(comps_by_prd[p]) for p in prds)
    names = ' + '.join(sorted({r['prd_nm'] for p in prds for r in l_by_prd[p]}) or ['(없음)'])
    if acells == lrows:
        verdict = 'OK'; tot_ok += 1
    else:
        verdict = f'MISMATCH  Δ{lrows-acells:+d}'; tot_bad += 1
    print(f'{block:<26} {names:<26} {acells:>5} {lrows:>7} {ncomp:>5}  {verdict}')
print('-'*95)
print(f'일치 {tot_ok} · 불일치 {tot_bad}')
