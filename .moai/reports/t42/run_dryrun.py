"""remediation.sql 을 롤백 전용으로 돌려 결과를 dryrun.log 로 남긴다."""
import sys

sys.path.insert(0, '.moai/reports/t42')
from dbq import run_file  # noqa: E402

rc, out = run_file('.moai/reports/t42/remediation.sql')
with open('.moai/reports/t42/dryrun.log', 'w') as f:
    f.write(f'# exit={rc}\n\n{out}')
print(f'exit={rc} -> .moai/reports/t42/dryrun.log')
print(out)
