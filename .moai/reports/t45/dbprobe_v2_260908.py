#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dbprobe_v2_260908.py — SPEC-STAFFBRIEF-001 (card t45) v2 보강 재실측 스크립트
- v1 dbprobe_260908.py 패턴 승계 (이중 읽기전용: 비-SELECT 거부 + 서버 세션 read-only)
- v2 추가: 옵션 3층 실데이터 예시 · 위젯 항목 컴포넌트 분포
- 자격증명: 메인 체크아웃 /Users/innojini/Dev/HuniWeb/.env.local RAILWAY_DB_* (값 미기록)
- PII 정책: 카운트·코드·상품명만 SELECT
- 사용: python3 dbprobe_v2_260908.py metrics --out <로그> --qfile <쿼리파일>
"""
import sys
import re
import datetime
import pathlib

ENV_PATH = "/Users/innojini/Dev/HuniWeb/.env.local"


def load_creds():
    creds = {}
    for line in pathlib.Path(ENV_PATH).read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        m = re.match(r"^(RAILWAY_DB_[A-Z_]+)=(.*)$", line)
        if m:
            creds[m.group(1)] = m.group(2)
    required = ["RAILWAY_DB_HOST", "RAILWAY_DB_PORT", "RAILWAY_DB_NAME",
                "RAILWAY_DB_USER", "RAILWAY_DB_PASSWORD"]
    missing = [k for k in required if not creds.get(k)]
    if missing:
        raise SystemExit(f"FATAL: missing keys in {ENV_PATH}: {missing}")
    return creds


def connect(creds):
    import psycopg2
    return psycopg2.connect(
        host=creds["RAILWAY_DB_HOST"],
        port=creds["RAILWAY_DB_PORT"],
        dbname=creds["RAILWAY_DB_NAME"],
        user=creds["RAILWAY_DB_USER"],
        password=creds["RAILWAY_DB_PASSWORD"],
        sslmode="require",
        options="-c default_transaction_read_only=on",
    )


READONLY_RE = re.compile(r"^\s*(SELECT|WITH)\b", re.IGNORECASE)


def run_queries(conn, queries, log):
    cur = conn.cursor()
    for q in queries:
        q = q.strip()
        if not q or q.startswith("--"):
            continue
        if not READONLY_RE.match(q):
            log(f"REJECTED (non-SELECT, not executed): {q[:120]}")
            continue
        ts = datetime.datetime.now().astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")
        log(f"\n=== [{ts}] QUERY ===")
        log(q)
        cur.execute(q)
        cols = [d[0] for d in cur.description] if cur.description else []
        rows = cur.fetchall()
        log("--- RESULT (%d row%s) ---" % (len(rows), "" if len(rows) == 1 else "s"))
        log(" | ".join(cols))
        for r in rows:
            log(" | ".join("NULL" if v is None else str(v) for v in r))
    cur.close()


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(2)
    mode = sys.argv[1]
    out_path = None
    qfile = None
    args = sys.argv[2:]
    for i in range(0, len(args), 2):
        if args[i] == "--out":
            out_path = args[i + 1]
        elif args[i] == "--qfile":
            qfile = args[i + 1]

    lines = []

    def log(s):
        print(s)
        lines.append(s)

    ts0 = datetime.datetime.now().astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")
    log(f"# dbprobe_v2_260908.py — mode={mode} (v2 보강 재실측)")
    log(f"# run started: {ts0}")
    log("# connection: host=<redacted> sslmode=require options=-c default_transaction_read_only=on")
    log(f"# credential source: {ENV_PATH} (RAILWAY_DB_* — values never logged)")

    creds = load_creds()
    conn = connect(creds)
    try:
        if mode == "metrics":
            if not qfile:
                raise SystemExit("metrics mode requires --qfile")
            qs = pathlib.Path(qfile).read_text(encoding="utf-8").splitlines()
            run_queries(conn, qs, log)
        else:
            raise SystemExit(f"unknown mode: {mode}")
    finally:
        conn.close()

    ts1 = datetime.datetime.now().astimezone().strftime("%Y-%m-%d %H:%M:%S %Z")
    log(f"\n# run finished: {ts1}")
    if out_path:
        pathlib.Path(out_path).write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"\n[saved] {out_path}")


if __name__ == "__main__":
    main()
