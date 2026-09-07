#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dbprobe_260908.py — SPEC-STAFFBRIEF-001 (card t45) M1.1 재실측 스크립트
- 읽기전용 보장 2중: (1) 클라이언트 검사 — SELECT/WITH 로 시작하지 않는 쿼리 거부
                     (2) 서버 세션 — default_transaction_read_only=on (쓰기 시도 시 DB가 거부)
- 자격증명: 메인 체크아웃 /Users/innojini/Dev/HuniWeb/.env.local 의 RAILWAY_DB_* 키 (값은 출력·로그에 절대 기록 안 함)
- PII 정책: 카운트·코드값만 SELECT (상품명·주문 개인정보 없음)
- 사용: python3 dbprobe_260908.py discovery --out <로그경로>
       python3 dbprobe_260908.py metrics   --out <로그경로> --qfile <쿼리파일(1행 1쿼리, '--'행은 무시)>
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


DISCOVERY_QUERIES = [
    "-- (D0) 접속 증명: DB 서버 시각",
    "SELECT now() AS db_now, current_database() AS db_name, current_user AS db_user;",

    "-- (D1) 재실측 대상 테이블 존재 확인",
    "SELECT table_name FROM information_schema.tables "
    "WHERE table_schema='public' AND (table_name IN ('t_prd_products','t_wgt_widgets') "
    "OR table_name LIKE 't\\_prd\\_product%' OR table_name LIKE 't\\_wgt%' "
    "OR table_name LIKE 't\\_prc%' OR table_name LIKE '%ord%' OR table_name LIKE '%cart%') "
    "ORDER BY table_name;",

    "-- (D2) t_prd_products 컬럼(상태 컬럼 확인용)",
    "SELECT column_name, data_type FROM information_schema.columns "
    "WHERE table_schema='public' AND table_name='t_prd_products' ORDER BY ordinal_position;",

    "-- (D3) t_wgt_widgets 컬럼(상태 컬럼 확인용)",
    "SELECT column_name, data_type FROM information_schema.columns "
    "WHERE table_schema='public' AND table_name='t_wgt_widgets' ORDER BY ordinal_position;",

    "-- (D4) t_prc_* 컬럼 중 prd_cd 를 가진 테이블(바인딩 후보)",
    "SELECT c.table_name, c.column_name FROM information_schema.columns c "
    "JOIN information_schema.tables t ON t.table_schema=c.table_schema AND t.table_name=c.table_name "
    "WHERE c.table_schema='public' AND c.table_name LIKE 't\\_prc%' "
    "AND (c.column_name IN ('prd_cd','prd_id') OR c.column_name LIKE '%bind%') "
    "ORDER BY c.table_name, c.ordinal_position;",

    "-- (D5) 위젯 상태 기초코드(WGT_STS_TYPE) 값 확인",
    "SELECT grp_cd, bas_cd, bas_nm, use_yn FROM t_bas_base_codes "
    "WHERE grp_cd LIKE '%WGT%' ORDER BY grp_cd, bas_cd LIMIT 30;",
]


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
    log(f"# dbprobe_260908.py — mode={mode}")
    log(f"# run started: {ts0}")
    log("# connection: host=<redacted> sslmode=require options=-c default_transaction_read_only=on")
    log(f"# credential source: {ENV_PATH} (RAILWAY_DB_* — values never logged)")

    creds = load_creds()
    conn = connect(creds)
    try:
        if mode == "discovery":
            run_queries(conn, DISCOVERY_QUERIES, log)
        elif mode == "metrics":
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
