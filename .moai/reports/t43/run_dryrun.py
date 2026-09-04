"""dryrun.sql 을 롤백 전용으로 돌려 dryrun.log 로 남긴다."""
import sys

sys.path.insert(0, '.moai/reports/t43')
from dbq import run_file  # noqa: E402

rc, out = run_file('.moai/reports/t43/dryrun.sql')
with open('.moai/reports/t43/dryrun.log', 'w') as f:
    f.write(f'# exit={rc}\n\n{out}')
print(f'exit={rc} -> .moai/reports/t43/dryrun.log')
print(out)
