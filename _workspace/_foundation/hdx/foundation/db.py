"""라이브 DB 읽기전용 조회 — lib_huni.db verbatim 승계.

[HARD] SELECT 전용. 이 모듈은 어떤 쓰기(INSERT/UPDATE/DELETE/COMMIT)도 하지 않는다.
실 교정 적재는 인간 승인 후 별도 채널(진단 배치 범위 밖).
"""
import os
import subprocess


def db(sql, rows=True):
    """라이브 DB SELECT. rows=True 면 [[col,...],...] 리스트(탭 구분), False 면 raw 텍스트.

    자격증명은 os.environ 의 RAILWAY_DB_* 를 psql 환경변수로 전달(값 출력 없음).
    """
    env = dict(os.environ)
    env["PGPASSWORD"] = os.environ["RAILWAY_DB_PASSWORD"]
    env["PGHOST"] = os.environ["RAILWAY_DB_HOST"]
    env["PGPORT"] = os.environ["RAILWAY_DB_PORT"]
    env["PGUSER"] = os.environ["RAILWAY_DB_USER"]
    env["PGDATABASE"] = os.environ["RAILWAY_DB_NAME"]
    args = ["psql", "-At", "-F", "\t", "-c", sql]
    out = subprocess.run(args, env=env, capture_output=True, text=True, timeout=120)
    if out.returncode != 0:
        raise RuntimeError(f"psql 실패: {out.stderr.strip()}")
    if not rows:
        return out.stdout
    return [ln.split("\t") for ln in out.stdout.splitlines() if ln != ""]
