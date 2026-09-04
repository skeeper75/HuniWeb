"""t41 apply.sql 을 라이브에 1회 COMMIT 한다(지니 승인 260904).

apply.sql 이 BEGIN…COMMIT 을 스스로 들고 있으므로 그대로 -f 로 넘긴다.
멱등 가드(WHERE 조건)가 걸려 있어 재실행해도 0행이 되지만, 이 스크립트는 1회만 돌린다.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbq

HERE = os.path.dirname(os.path.abspath(__file__))
rc, out = dbq.run_file(f'{HERE}/apply.sql')
with open(f'{HERE}/commit.log', 'w') as f:
    f.write('$ psql <URL> -v ON_ERROR_STOP=1 -f apply.sql\n'
            '# t41 라이브 COMMIT · 지니 승인 260904 (AskUserQuestion 직접 확인)\n'
            f'[exit={rc}]\n\n{out}')
print(f'[exit={rc}] -> commit.log')
print(out)
sys.exit(rc)
