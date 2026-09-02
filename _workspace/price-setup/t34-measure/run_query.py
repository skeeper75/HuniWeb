import subprocess
import sys

vals = {}
for line in open('/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/.env.local'):
    line = line.strip()
    if line.startswith('RAILWAY_DB_'):
        k, _, v = line.partition('=')
        vals[k] = v
URL = f"postgresql://{vals['RAILWAY_DB_USER']}:{vals['RAILWAY_DB_PASSWORD']}@{vals['RAILWAY_DB_HOST']}:{vals['RAILWAY_DB_PORT']}/{vals['RAILWAY_DB_NAME']}"

def run(sql, outfile):
    args = ['psql', URL, '-v', 'ON_ERROR_STOP=1', '-c', sql]
    r = subprocess.run(args, capture_output=True, text=True)
    out = r.stdout + ("\n[STDERR]\n" + r.stderr if r.stderr else "")
    with open(outfile, 'w') as f:
        f.write(f"$ psql <DATABASE_URL> -c \"{sql}\"\n\n")
        f.write(out)
    return r.returncode, out

if __name__ == '__main__':
    sql = sys.argv[1]
    outfile = sys.argv[2]
    rc, out = run(sql, outfile)
    print(f"[rc={rc}] -> {outfile}")
    print(out[:4000])
