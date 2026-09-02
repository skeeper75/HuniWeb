"""라이브 DB 읽기전용 헬퍼. SELECT 만 허용한다 (SPEC-PRICECOMP-001 제약 1)."""
import subprocess

_ENVPATH = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/.env.local'

def _url():
    vals = {}
    for line in open(_ENVPATH):
        line = line.strip()
        if line.startswith('RAILWAY_DB_'):
            k, _, v = line.partition('=')
            vals[k] = v
    return (f"postgresql://{vals['RAILWAY_DB_USER']}:{vals['RAILWAY_DB_PASSWORD']}"
            f"@{vals['RAILWAY_DB_HOST']}:{vals['RAILWAY_DB_PORT']}/{vals['RAILWAY_DB_NAME']}")

URL = _url()

_FORBIDDEN = ('insert', 'update', 'delete', 'drop', 'alter', 'create', 'truncate', 'grant')

def _guard(sql):
    low = sql.lower()
    for w in _FORBIDDEN:
        if f' {w} ' in f' {low} ' or low.lstrip().startswith(w):
            raise SystemExit(f'쓰기 명령 차단: {w}')

def q(sql, tuples=False):
    """SELECT 를 실행해 stdout 문자열을 돌려준다."""
    _guard(sql)
    args = ['psql', URL, '-v', 'ON_ERROR_STOP=1']
    if tuples:
        args += ['-A', '-F', '\t', '-t']
    args += ['-c', sql]
    r = subprocess.run(args, capture_output=True, text=True)
    if r.returncode != 0:
        raise SystemExit(f'psql 실패:\n{r.stderr}')
    return r.stdout

def to_csv(sql, path):
    """SELECT 결과를 CSV 파일로 내린다. 돌려주는 값은 데이터 행 수."""
    _guard(sql)
    copy = f"\\copy ({sql}) TO '{path}' WITH CSV HEADER"
    r = subprocess.run(['psql', URL, '-v', 'ON_ERROR_STOP=1', '-c', copy],
                       capture_output=True, text=True)
    if r.returncode != 0:
        raise SystemExit(f'psql \\copy 실패:\n{r.stderr}')
    with open(path) as f:
        return sum(1 for _ in f) - 1
