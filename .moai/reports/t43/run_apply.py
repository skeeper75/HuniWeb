"""apply.sql 을 라이브에 1회 실행하고 commit.log 로 남긴다.

[HARD] 지니 승인(260904 · SIZ_000252 안 채택 · 리드 lead-peta 경유 전달) 후에만 실행.
apply.sql 은 스스로 BEGIN…COMMIT 을 들고 있다. 되돌림은 rollback.sql(보존·실행 금지).
"""
import sys
from datetime import datetime, timezone

sys.path.insert(0, '.moai/reports/t43')
from dbq import run_file  # noqa: E402

started = datetime.now(timezone.utc).isoformat()
rc, out = run_file('.moai/reports/t43/apply.sql')
ended = datetime.now(timezone.utc).isoformat()

log = (
    '# t43 라이브 COMMIT 로그\n'
    f'# 승인: 지니 260904 (SIZ_000252 안 채택) — 리드 lead-peta [8748b7] 경유 전달\n'
    f'# 파일: .moai/reports/t43/apply.sql\n'
    f'# 시작: {started}\n'
    f'# 종료: {ended}\n'
    f'# exit: {rc}\n\n'
    f'{out}'
)
with open('.moai/reports/t43/commit.log', 'w') as f:
    f.write(log)
print(log)
