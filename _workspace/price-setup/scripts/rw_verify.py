"""저장 뒤 그 공식이 기대한 모양인지 확인한다.

「옛 그릇 잔존」은 **그 공식에서 교체하기로 계획한 코드**만 센다. 범위 밖 구성요소는
COMP_ 로 시작해도 그대로 남는 것이 정상이다(예: 아크릴명찰 골드실버 본체,
메쉬현수막 부자재).
"""
import json
import sys
BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'
sys.path.insert(0, f'{BASE}/scripts')
import db

frm, before = sys.argv[1], int(sys.argv[2])
planned = {o for p in json.load(open(f'{BASE}/m4/swap-plan-1to1.json'))
           if p['frm'] == frm for o, _ in p['swaps']}
rows = db.q(f"SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='{frm}' ORDER BY 1",
            tuples=True).split()
left = [c for c in rows if c in planned]
ok = len(rows) == before and not left
extra = [c for c in rows if c.startswith(('COMP_', 'CLR_')) and c not in planned]
note = f" · 범위 밖 {len(extra)}" if extra else ""
print(f"[{frm}] 저장 후 {len(rows)}개 (기대 {before}) · 교체대상 잔존 {len(left)}{note} → "
      f"{'OK ✓' if ok else '★확인필요'}")
if not ok:
    print('   ', ' '.join(rows))
sys.exit(0 if ok else 1)
