"""공식 하나의 교체 계획을 JSON 한 줄로 낸다."""
import json
import sys
BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'
for p in json.load(open(f'{BASE}/m4/swap-plan-1to1.json')):
    if p['frm'] == sys.argv[1]:
        print(json.dumps(p['swaps'], ensure_ascii=False))
        break
