#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_safety_sql.py — 가격(t_prc_*) COMMIT-안전 인프라 생성기 (round-5 보강, dbm-load-builder)

목적: 인간이 실제 COMMIT 을 승인하기 전/후에 가격 적재를 무손실 되돌릴 수 있도록 백업 스냅샷 +
언두를 재현적으로 생성한다. 적재 SQL(00~05)을 일절 변경하지 않는다 — 멱등성 보존.

가격 트랙의 특수성:
  · t_prc_* 5 테이블(formulas/components/formula_components/component_prices/product_price_formulas)
    은 라이브에서 전부 EMPTY(count=0, 2026-06-06 read-only 확증). → 언두 = 적재한 행 전부 DELETE.
    (선존행이 없으므로 '신규행' = 적재행 전부. xmin 캡처도 함께 떠 안전 2중화.)
  · t_cod_base_codes 코드행(PRC_COMPONENT_TYPE.06)은 공유 테이블 → EMPTY 아님. 이 한 행만은
    "이번 트랜잭션이 새로 INSERT 했을 때만" DELETE(xmin 식별). 선존 코드값 절대 불가침.

전략:
  (A) backup-before-load.sql — 적재 전 5 t_prc_* 테이블 행수 + 코드행 선존여부 스냅샷(read-only).
      EMPTY 확증을 timestamped CSV 로 기록(되돌림 안전 근거).
  (B) capture-inserted-keys.sql — commit 트랜잭션 안에서 신규행 PK 캡처(xmin). 5 t_prc_* 전체 +
      코드행. inserted_keys_<runts>.csv.
  (C) undo-after-load.sql — 로그된 신규 PK 만 DELETE(코드행 포함). 코드행이 선존이었으면 로그에
      없으므로 자연히 보존.

UPDATE-set 없음(가격 트랙은 전부 INSERT). 따라서 before-image UPDATE 복원 불필요.

권위: constraints-live.md(PK), 라이브 read-only(EMPTY 확증·컬럼). 손편집 금지.
실행: python3 gen_safety_sql.py
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))

# 적재 테이블 → PK 컬럼. constraints-live.md §1 권위. DELETE 순서 = FK 자식→부모.
# 코드행(t_cod_base_codes)이 최상위 부모 → 맨 마지막 DELETE.
INSERT_STEPS = [
    ("05_prd_product_price_formulas.sql", "t_prd_product_price_formulas", ["prd_cd", "frm_cd"]),
    ("04_prc_component_prices.sql", "t_prc_component_prices", ["comp_price_id"]),
    ("03_prc_formula_components.sql", "t_prc_formula_components", ["frm_cd", "comp_cd"]),
    ("02_prc_price_components.sql", "t_prc_price_components", ["comp_cd"]),
    ("01_prc_price_formulas.sql", "t_prc_price_formulas", ["frm_cd"]),
    ("00_prc_component_type.sql", "t_cod_base_codes", ["cod_cd"]),
]

# 가격 적재가 t_cod_base_codes 에 INSERT 하는 코드행(진단 스냅샷 대상).
CODE_ROW = "PRC_COMPONENT_TYPE.06"


def gen_backup_sql():
    """적재 전 스냅샷 쿼리(서버측 COPY ... TO STDOUT). 셸이 stdout 을 파일로 리다이렉트.

    psql v18 의 \\copy 는 :'var' 보간을 지원하지 않으므로(검증), 경로 변수 대신
    COPY ... TO STDOUT + 셸 리다이렉트를 쓴다(read-only, DB 변경 0).
    """
    path = os.path.join(HERE, "backup-before-load.sql")
    lines = []
    lines.append("-- backup-before-load.sql — 가격(t_prc_*) 적재 전 스냅샷 쿼리 (read-only)")
    lines.append("-- 생성: gen_safety_sql.py (손편집 금지). COPY ... TO STDOUT 만 — DB 변경 0.")
    lines.append("-- 셸(backup-before-load.sh)이 stdout 을 backup_<runts>/before_prc_counts.csv 로 리다이렉트.")
    lines.append("-- 가격 5 테이블은 라이브 EMPTY → 적재 전 행수=0 을 기록(되돌림 안전 근거).")
    lines.append("-- 코드행(PRC_COMPONENT_TYPE.06) 선존여부도 떠둔다(선존이면 언두가 보존해야 함).")
    lines.append("")
    backup_query = (
        "SELECT 't_prc_price_formulas' AS tbl, count(*) AS cnt FROM t_prc_price_formulas"
        " UNION ALL SELECT 't_prc_price_components', count(*) FROM t_prc_price_components"
        " UNION ALL SELECT 't_prc_formula_components', count(*) FROM t_prc_formula_components"
        " UNION ALL SELECT 't_prc_component_prices', count(*) FROM t_prc_component_prices"
        " UNION ALL SELECT 't_prd_product_price_formulas', count(*) FROM t_prd_product_price_formulas"
        f" UNION ALL SELECT 't_cod_base_codes:{CODE_ROW}', count(*) FROM t_cod_base_codes"
        f" WHERE cod_cd = '{CODE_ROW}'"
        " ORDER BY tbl"
    )
    lines.append(f"COPY ({backup_query}) TO STDOUT WITH (FORMAT csv, HEADER true);")
    lines.append("")
    open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")


def gen_capture_sql():
    """commit 트랜잭션 안에서 신규행 PK 캡처(xmin). 5 t_prc_* + 코드행."""
    path = os.path.join(HERE, "capture-inserted-keys.sql")
    lines = []
    lines.append("-- capture-inserted-keys.sql — 현재 commit 트랜잭션이 새로 INSERT 한 PK 키 캡처(가격)")
    lines.append("-- 생성: gen_safety_sql.py (손편집 금지). 적재 SQL 미변경(멱등성 보존).")
    lines.append("-- apply.sh commit 모드가 \\i 적재 직후·COMMIT 직전에 같은 트랜잭션에서 실행.")
    lines.append("-- apply.sh 가 이 COPY 앞뒤로 \\o <keys.csv> / \\o 를 주입 → 데이터만 파일로 라우팅.")
    lines.append("-- 식별: xmin = pg_current_xact_id()::xid → 선존 코드행(ON CONFLICT 스킵) 제외.")
    uniq = []
    seen = set()
    for _fn, tbl, pk in INSERT_STEPS:
        if tbl in seen:
            continue
        seen.add(tbl)
        key_concat = " || '|' || ".join(f"{c}::text" for c in pk)
        cond = "xmin = pg_current_xact_id()::xid"
        # t_cod_base_codes 는 공유 테이블 → 이번 적재가 건드린 코드행으로 한정(안전·정확).
        if tbl == "t_cod_base_codes":
            cond += f" AND cod_cd = '{CODE_ROW}'"
        uniq.append(
            f"SELECT '{tbl}' AS tbl, '{','.join(pk)}' AS pk_cols, {key_concat} AS pk_vals "
            f"FROM {tbl} WHERE {cond}"
        )
    capture_query = " UNION ALL ".join(uniq) + " ORDER BY tbl, pk_vals"
    lines.append(f"COPY ({capture_query}) TO STDOUT WITH (FORMAT csv, HEADER true);")
    lines.append("")
    open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")


def gen_undo_sql():
    """언두: 로그된 신규 PK 키만 DELETE(코드행 포함). 가격 5 테이블 EMPTY → 적재행=신규행 전부."""
    path = os.path.join(HERE, "undo-after-load.sql")
    lines = []
    lines.append("-- undo-after-load.sql — 가격(t_prc_*) 적재를 무손실 되돌리는 언두 데이터 연산 (round-5)")
    lines.append("-- 생성: gen_safety_sql.py (손편집 금지).")
    lines.append("--")
    lines.append("-- 본 파일은 BEGIN/CREATE TEMP/\\copy FROM 을 포함하지 않는다 — undo.sh 가 리터럴 경로로")
    lines.append("-- _undo_keys 를 선적재한 뒤 이 파일을 \\i 한다. (psql v18 \\copy 는 :'var' 경로 보간 미지원.)")
    lines.append("-- COMMIT/ROLLBACK 도 undo.sh 가 주입. 기본 = DRY-RUN(ROLLBACK).")
    lines.append("--")
    lines.append("-- 5 t_prc_* 테이블은 라이브 EMPTY 였으므로 적재행 = 신규행 전부 → DELETE-all 등가.")
    lines.append("-- 다만 inserted_keys_<runts>.csv 로그키만 DELETE 하여, 만에 하나 선존행이 있어도 불가침.")
    lines.append("-- 코드행(t_cod_base_codes)은 로그에 있을 때만(=이번에 신설했을 때만) DELETE.")
    lines.append("")
    seen = set()
    for _fn, tbl, pk in INSERT_STEPS:
        if tbl in seen:
            continue
        seen.add(tbl)
        conds = []
        for idx, c in enumerate(pk, 1):
            conds.append(f"{tbl}.{c}::text = split_part(_undo_keys.pk_vals, '|', {idx})")
        lines.append(f"\\echo '>> undo DELETE {tbl} (logged new keys only)'")
        lines.append(
            f"DELETE FROM {tbl} USING _undo_keys\n"
            f" WHERE _undo_keys.tbl = '{tbl}'\n"
            f"   AND " + "\n   AND ".join(conds) + ";"
        )
        lines.append("")
    lines.append("-- (BEGIN/COMMIT/ROLLBACK·_undo_keys 선적재는 undo.sh 가 리터럴 경로로 래핑.)")
    open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")


def main():
    gen_backup_sql()
    gen_capture_sql()
    gen_undo_sql()
    tables = sorted({t for _f, t, _p in INSERT_STEPS})
    print("가격 COMMIT-안전 SQL 생성 완료:")
    print("  backup-before-load.sql   : 5 t_prc_* 행수(EMPTY 확증) + 코드행 선존여부")
    print(f"  capture-inserted-keys.sql: {len(tables)} 테이블 신규행 PK 캡처(xmin), 코드행 한정")
    print("  undo-after-load.sql      : 로그키 DELETE(EMPTY 테이블 = DELETE-all 등가, 코드행은 신설 시만)")
    print("  UPDATE-set 없음 → before-image 복원 불요(가격 트랙 전부 INSERT).")


if __name__ == "__main__":
    main()
