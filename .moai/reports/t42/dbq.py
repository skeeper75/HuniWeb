"""t36 읽기전용 질의 도구. 자격증명은 주 체크아웃 .env.local 에서만 읽는다."""
import subprocess
import sys

ENV = '/Users/innojini/Dev/HuniWeb/.env.local'
v = {}
for line in open(ENV):
    line = line.strip()
    if line.startswith('RAILWAY_DB_'):
        k, _, val = line.partition('=')
        v[k] = val
URL = (f"postgresql://{v['RAILWAY_DB_USER']}:{v['RAILWAY_DB_PASSWORD']}"
       f"@{v['RAILWAY_DB_HOST']}:{v['RAILWAY_DB_PORT']}/{v['RAILWAY_DB_NAME']}")


def q(sql, tuples=False):
    args = ['psql', URL, '-v', 'ON_ERROR_STOP=1']
    if tuples:
        args += ['-t', '-A', '-F', '\t']
    args += ['-c', sql]
    r = subprocess.run(args, capture_output=True, text=True)
    if r.returncode:
        raise RuntimeError(r.stderr.strip()[:500])
    return r.stdout


def run_file(path):
    """트랜잭션 SQL 파일 실행 — 파일이 스스로 BEGIN/ROLLBACK 을 들고 있어야 한다."""
    r = subprocess.run(['psql', URL, '-v', 'ON_ERROR_STOP=1', '-f', path],
                       capture_output=True, text=True)
    return r.returncode, r.stdout + (('\n[STDERR]\n' + r.stderr) if r.stderr else '')


if __name__ == '__main__':
    sql = sys.argv[1]
    out = q(sql)
    if len(sys.argv) > 2:
        with open(sys.argv[2], 'w') as f:
            f.write(f'$ psql <URL> -c "{sql}"\n\n' + out)
        print(f'-> {sys.argv[2]}')
    print(out)
