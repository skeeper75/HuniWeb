# 수량규칙 ↔ 가격테이블 수량구간 정합 전수 점검 (읽기전용)
# 목적: 엽서북형 함정(상품 min_qty < 가격표 최소구간 → 화면 0원/구성요소 제외) 전 상품 적발
# 판정:
#   TRAP_MIN   — 상품 최소수량(미등록=1)으로 주문 가능한데 어떤 필수 구간 comp의 최소구간보다 작음
#   NO_RULES   — 상품 수량규칙 미등록 + 구간 존재 (UI 기본 min=1)
#   INFO_MAX   — 상품 max_qty가 최대구간 시작의 10배 초과 (초대량 저청구 검토)
#   OK         — 정합
import os, subprocess, csv, json, sys

ENV = os.environ
def q(sql):
    r = subprocess.run(['psql','-h',ENV['RAILWAY_DB_HOST'],'-p',ENV['RAILWAY_DB_PORT'],
                        '-U',ENV['RAILWAY_DB_USER'],'-d',ENV['RAILWAY_DB_NAME'],'-Atc',sql],
                       env={**ENV,'PGPASSWORD':ENV['RAILWAY_DB_PASSWORD']},capture_output=True,text=True)
    if r.returncode!=0: sys.exit(r.stderr)
    return [l.split('|') for l in r.stdout.strip().split('\n') if l]

# 상품 × 공식 × comp별 수량구간 요약 (min_qty NULL만 있는 comp = 구간 없음 = 제약 없음)
rows = q("""
WITH comp_bands AS (
  SELECT fc.frm_cd, cp.comp_cd,
         min(cp.min_qty) FILTER (WHERE cp.min_qty IS NOT NULL) AS band_min,
         max(cp.min_qty) AS band_max,
         count(*) FILTER (WHERE cp.min_qty IS NOT NULL) AS qty_rows,
         count(*) AS all_rows
  FROM t_prc_formula_components fc
  JOIN t_prc_price_components c ON c.comp_cd=fc.comp_cd AND COALESCE(c.use_yn,'Y')='Y'
  JOIN t_prc_component_prices cp ON cp.comp_cd=fc.comp_cd
  GROUP BY fc.frm_cd, cp.comp_cd
)
SELECT p.prd_cd, p.prd_nm, p.prd_typ_cd,
       COALESCE(p.min_qty::text,''), COALESCE(p.max_qty::text,''), COALESCE(p.qty_incr::text,''),
       b.frm_cd, cb.comp_cd,
       COALESCE(cb.band_min::text,''), COALESCE(cb.band_max::text,''), cb.qty_rows, cb.all_rows
FROM t_prd_products p
JOIN t_prd_product_price_formulas b ON b.prd_cd=p.prd_cd
JOIN comp_bands cb ON cb.frm_cd=b.frm_cd
WHERE COALESCE(p.del_yn,'N')='N' AND COALESCE(p.use_yn,'Y')='Y'
ORDER BY p.prd_cd, cb.comp_cd
""")

# 상품 단위로 집계
prod = {}
for r in rows:
    prd, nm, typ, mn, mx, inc, frm, comp, bmin, bmax, qrows, arows = r
    p = prod.setdefault(prd, {'nm':nm,'typ':typ,'min':mn,'max':mx,'incr':inc,'frm':frm,'comps':[]})
    if bmin != '':  # 구간 있는 comp만 제약
        p['comps'].append({'comp':comp,'band_min':int(bmin),'band_max':int(bmax) if bmax else None})

report = []
for prd, p in sorted(prod.items()):
    if not p['comps']:
        continue  # 수량구간 comp 없음(면적형/장당형) — 함정 불가
    eff_min = int(p['min']) if p['min'] else 1          # 미등록이면 UI 기본 1
    strictest = max(c['band_min'] for c in p['comps'])   # 가장 늦게 시작하는 comp
    loosest   = min(c['band_min'] for c in p['comps'])
    max_band  = max(c['band_max'] for c in p['comps'] if c['band_max'] is not None)
    trap_comps = [c['comp'] for c in p['comps'] if c['band_min'] > eff_min]
    if p['min'] == '' and trap_comps:
        verdict = 'NO_RULES'
    elif trap_comps:
        verdict = 'TRAP_MIN'
    elif p['max'] and max_band and int(p['max']) > max_band*10:
        verdict = 'INFO_MAX'
    else:
        verdict = 'OK'
    report.append({'prd_cd':prd,'prd_nm':p['nm'],'prd_typ':p['typ'],'verdict':verdict,
                   'prd_min':p['min'] or '(미등록=1)','prd_max':p['max'],'prd_incr':p['incr'],
                   'strictest_band_min':strictest,'loosest_band_min':loosest,'max_band_start':max_band,
                   'frm_cd':p['frm'],'trap_comps':';'.join(trap_comps)})

out = os.path.dirname(os.path.abspath(__file__)) + '/qty-rule-audit-260702.csv'
with open(out,'w',newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(report[0].keys()))
    w.writeheader(); w.writerows(report)

# 사이즈별 수량규칙 충전 현황
sz = q("""SELECT count(*) FILTER (WHERE min_qty IS NOT NULL OR max_qty IS NOT NULL OR qty_incr IS NOT NULL), count(*)
FROM t_prd_product_sizes WHERE COALESCE(del_yn,'N')='N'""")[0]

summary = {}
for r in report: summary[r['verdict']] = summary.get(r['verdict'],0)+1
print(json.dumps({'집계':summary,'점검상품':len(report),'사이즈수량규칙':f"{sz[0]}/{sz[1]}",'csv':out}, ensure_ascii=False))
print('\n--- TRAP_MIN / NO_RULES 상세 ---')
for r in report:
    if r['verdict'] in ('TRAP_MIN','NO_RULES'):
        print(f"{r['verdict']}\t{r['prd_cd']}\t{r['prd_nm']}\tmin={r['prd_min']}\t최소구간={r['strictest_band_min']}(느슨={r['loosest_band_min']})\t{r['trap_comps'][:80]}")
print('\n--- INFO_MAX 상세 ---')
for r in report:
    if r['verdict'] == 'INFO_MAX':
        print(f"INFO_MAX\t{r['prd_cd']}\t{r['prd_nm']}\tmax={r['prd_max']}\t최대구간시작={r['max_band_start']}")
