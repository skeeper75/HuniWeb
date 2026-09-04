"""dryrun.sql 을 실행하고 출력을 dryrun.log 로 남긴다. 마지막이 ROLLBACK 이라 라이브 무변경."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbq

HERE = os.path.dirname(os.path.abspath(__file__))
rc, out = dbq.run_file(f'{HERE}/dryrun.sql')
with open(f'{HERE}/dryrun.log', 'w') as f:
    f.write(f'$ psql <URL> -v ON_ERROR_STOP=1 -f dryrun.sql\n[exit={rc}]\n\n{out}')
print(f'[exit={rc}] -> dryrun.log')
print(out)
