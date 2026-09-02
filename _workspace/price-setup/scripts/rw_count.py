"""그 공식의 구성요소 수를 센다."""
import sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db
print(db.q(f"SELECT count(*) FROM t_prc_formula_components WHERE frm_cd='{sys.argv[1]}'",
           tuples=True).strip())
