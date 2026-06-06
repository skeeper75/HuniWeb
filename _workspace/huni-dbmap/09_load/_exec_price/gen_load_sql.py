#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_load_sql.py — 가격(t_prc_*) 적재 실행본 생성기 (round-5, dbm-load-builder)

round-4 GO 적재본(09_load/_assembled_price/load/*.csv)을 멱등 INSERT … ON CONFLICT
실행 SQL + 트랜잭션 래퍼 + provenance 로 변환한다. 재현성(G8): 같은 입력 → 같은 출력.
손편집 금지 — 모든 SQL은 본 스크립트로 생성된다.

권위: docs/goal-2026-06-06-02.md §8 · sql-idempotent-patterns.md · 라이브 제약 조회 결과
(constraints-live.md). 식별자/컬럼/SQL 영어, 주석 한국어.

실행: python3 gen_load_sql.py   (출력은 본 디렉터리)
"""
import csv
import os
from decimal import Decimal, InvalidOperation

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "_assembled_price", "load")
OUT = HERE


def sql_str(v):
    """문자열 리터럴: 작은따옴표 이스케이프. None/공란 → NULL."""
    if v is None:
        return "NULL"
    s = str(v)
    if s.strip() == "":
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


def sql_int(v):
    """정수 리터럴. 공란 → NULL. 비정수 → 예외(침묵 강제변환 금지)."""
    if v is None or str(v).strip() == "":
        return "NULL"
    return str(int(str(v).strip()))


def sql_num(v):
    """numeric 리터럴. 공란 → NULL. 비수치 → 예외."""
    if v is None or str(v).strip() == "":
        return "NULL"
    try:
        Decimal(str(v).strip())
    except InvalidOperation:
        raise ValueError(f"비수치 numeric 값: {v!r}")
    return str(v).strip()


def sql_char1(v):
    """char(1): Y/N 등. 공란 → NULL."""
    if v is None or str(v).strip() == "":
        return "NULL"
    s = str(v).strip()
    if len(s) != 1:
        raise ValueError(f"char(1) 위반: {v!r}")
    return "'" + s.replace("'", "''") + "'"


def read_csv(name):
    with open(os.path.join(SRC, name), newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_step(filename, header_note, db_cols, conflict_sql, rows_sql, prov_rows):
    """테이블별 .sql + .provenance.csv 산출."""
    path = os.path.join(OUT, filename)
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"-- {filename}\n")
        f.write(f"-- {header_note}\n")
        f.write("-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.\n")
        f.write("-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.\n\n")
        for line, prov in rows_sql:
            f.write(f"-- src: {prov}\n")
            f.write(line + "\n")
    # provenance
    ppath = os.path.join(OUT, filename.replace(".sql", ".provenance.csv"))
    with open(ppath, "w", newline="", encoding="utf-8") as pf:
        w = csv.writer(pf)
        w.writerow(["sql_stmt_seq", "target_table", "conflict_key", "source_csv_row"])
        for i, pr in enumerate(prov_rows, 1):
            w.writerow([i, pr[0], conflict_sql, pr[1]])
    return len(rows_sql)


def gen_00_component_type():
    """단계 00: t_cod_base_codes 코드행 선적재 (PRC_COMPONENT_TYPE.06)."""
    rows = read_csv("00_prc_component_type.csv")
    cols = ["cod_cd", "cod_nm", "upr_cod_cd", "disp_seq", "use_yn", "note"]
    out = []
    prov = []
    for i, r in enumerate(rows, 2):
        vals = [
            sql_str(r["cod_cd"]), sql_str(r["cod_nm"]), sql_str(r["upr_cod_cd"]),
            sql_int(r["disp_seq"]), sql_char1(r["use_yn"]), sql_str(r.get("note", "")),
        ]
        stmt = (f"INSERT INTO t_cod_base_codes ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (cod_cd) DO NOTHING;")
        out.append((stmt, f"00_prc_component_type.csv:row{i} cod_cd={r['cod_cd']}"))
        prov.append(("t_cod_base_codes", f"00_prc_component_type.csv:row{i}"))
    return write_step(
        "00_prc_component_type.sql",
        "단계00 코드행 선적재 — PK pk_t_cod_base_codes(cod_cd). 후니 등록 대기 코드값 1행.",
        cols, "(cod_cd)", out, prov)


def gen_01_formulas():
    rows = read_csv("01_prc_price_formulas.csv")
    cols = ["frm_cd", "frm_nm", "frm_typ_cd", "note", "use_yn"]
    out, prov = [], []
    for i, r in enumerate(rows, 2):
        vals = [sql_str(r["frm_cd"]), sql_str(r["frm_nm"]), sql_str(r["frm_typ_cd"]),
                sql_str(r["note"]), sql_char1(r["use_yn"])]
        stmt = (f"INSERT INTO t_prc_price_formulas ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (frm_cd) DO NOTHING;")
        out.append((stmt, f"01_prc_price_formulas.csv:row{i} frm_cd={r['frm_cd']}"))
        prov.append(("t_prc_price_formulas", f"01_prc_price_formulas.csv:row{i}"))
    return write_step(
        "01_prc_price_formulas.sql",
        "단계01 공식 헤더 — PK pk_t_prc_price_formulas(frm_cd).",
        cols, "(frm_cd)", out, prov)


def gen_02_components():
    rows = read_csv("02_prc_price_components.csv")
    cols = ["comp_cd", "comp_nm", "comp_typ_cd", "note", "use_yn"]
    out, prov = [], []
    for i, r in enumerate(rows, 2):
        # comp_cd varchar(50) 길이 점검 (침묵 truncate 금지)
        if len(r["comp_cd"]) > 50:
            raise ValueError(f"comp_cd > 50자: {r['comp_cd']!r} (행 {i}) — truncate 금지, builder로 라우팅")
        vals = [sql_str(r["comp_cd"]), sql_str(r["comp_nm"]), sql_str(r["comp_typ_cd"]),
                sql_str(r["note"]), sql_char1(r["use_yn"])]
        stmt = (f"INSERT INTO t_prc_price_components ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (comp_cd) DO NOTHING;")
        out.append((stmt, f"02_prc_price_components.csv:row{i} comp_cd={r['comp_cd']}"))
        prov.append(("t_prc_price_components", f"02_prc_price_components.csv:row{i}"))
    return write_step(
        "02_prc_price_components.sql",
        "단계02 구성요소 카탈로그 — PK pk_t_prc_price_components(comp_cd). comp_cd<=50자 점검.",
        cols, "(comp_cd)", out, prov)


def gen_03_formula_components():
    rows = read_csv("03_prc_formula_components.csv")
    cols = ["frm_cd", "comp_cd", "disp_seq", "addtn_yn"]
    out, prov = [], []
    for i, r in enumerate(rows, 2):
        vals = [sql_str(r["frm_cd"]), sql_str(r["comp_cd"]),
                sql_int(r["disp_seq"]), sql_char1(r["addtn_yn"])]
        stmt = (f"INSERT INTO t_prc_formula_components ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (frm_cd, comp_cd) DO NOTHING;")
        out.append((stmt, f"03_prc_formula_components.csv:row{i} {r['frm_cd']}/{r['comp_cd']}"))
        prov.append(("t_prc_formula_components", f"03_prc_formula_components.csv:row{i}"))
    return write_step(
        "03_prc_formula_components.sql",
        "단계03 공식-구성요소 배선 — PK t_prc_formula_components_pkey(frm_cd, comp_cd).",
        cols, "(frm_cd, comp_cd)", out, prov)


def gen_04_component_prices():
    """단계04 단가 2,108행.
    충돌키 = PK comp_price_id (CSV가 결정적 명시값 제공). 자연키 unique index
    ux_t_prc_comp_prices_nat_key 는 NULLS DISTINCT(라이브 확증)라 NULL 포함 행에서
    멱등 미보장 → PK 충돌키 채택(재실행 안전). 자연키 unique 는 의미중복 2차 방어로 존속.
    """
    rows = read_csv("04_prc_component_prices.csv")
    cols = ["comp_price_id", "comp_cd", "apply_ymd", "siz_cd", "clr_cd", "mat_cd",
            "coat_side_cnt", "bdl_qty", "min_qty", "unit_price", "note"]
    out, prov = [], []
    for i, r in enumerate(rows, 2):
        if len(r["comp_cd"]) > 50:
            raise ValueError(f"comp_cd > 50자: {r['comp_cd']!r} (행 {i})")
        vals = [
            sql_int(r["comp_price_id"]), sql_str(r["comp_cd"]), sql_str(r["apply_ymd"]),
            sql_str(r["siz_cd"]), sql_str(r["clr_cd"]), sql_str(r["mat_cd"]),
            sql_int(r["coat_side_cnt"]), sql_int(r["bdl_qty"]), sql_int(r["min_qty"]),
            sql_num(r["unit_price"]), sql_str(r["note"]),
        ]
        stmt = (f"INSERT INTO t_prc_component_prices ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (comp_price_id) DO NOTHING;")
        out.append((stmt, f"04_prc_component_prices.csv:row{i} comp_price_id={r['comp_price_id']}"))
        prov.append(("t_prc_component_prices", f"04_prc_component_prices.csv:row{i}"))
    return write_step(
        "04_prc_component_prices.sql",
        "단계04 단가 — 충돌키=PK comp_price_id(CSV 명시값). 자연키 idx NULLS DISTINCT 라 PK 채택.",
        cols, "(comp_price_id)", out, prov)


def gen_05_product_price_formulas():
    rows = read_csv("05_prd_product_price_formulas.csv")
    cols = ["prd_cd", "frm_cd", "apply_bgn_ymd", "note"]
    out, prov = [], []
    for i, r in enumerate(rows, 2):
        vals = [sql_str(r["prd_cd"]), sql_str(r["frm_cd"]),
                sql_str(r["apply_bgn_ymd"]), sql_str(r["note"])]
        stmt = (f"INSERT INTO t_prd_product_price_formulas ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (prd_cd, frm_cd) DO NOTHING;")
        out.append((stmt, f"05_prd_product_price_formulas.csv:row{i} {r['prd_cd']}/{r['frm_cd']}"))
        prov.append(("t_prd_product_price_formulas", f"05_prd_product_price_formulas.csv:row{i}"))
    return write_step(
        "05_prd_product_price_formulas.sql",
        "단계05 상품-공식 바인딩 — PK t_prd_product_price_formulas_pkey(prd_cd, frm_cd).",
        cols, "(prd_cd, frm_cd)", out, prov)


def gen_apply_sql(counts):
    """apply.sql — 단일 트랜잭션 래퍼. BEGIN 만 포함, COMMIT/ROLLBACK 은 로더가 주입."""
    path = os.path.join(OUT, "apply.sql")
    with open(path, "w", encoding="utf-8") as f:
        f.write("-- apply.sql — 가격(t_prc_*) 적재 단일 트랜잭션 래퍼 (round-5)\n")
        f.write("-- BEGIN 으로 열고, COMMIT/ROLLBACK 은 apply.sh(로더)가 주입.\n")
        f.write("-- 기본 = DRY-RUN(ROLLBACK). 실제 COMMIT 은 --commit(인간 승인)만.\n")
        f.write("-- FK 위상정렬: 00 코드행 → 01 공식 → 02 구성요소 → 03 배선 → 04 단가 → 05 바인딩.\n\n")
        f.write("\\set ON_ERROR_STOP on\n")
        f.write("BEGIN;\n\n")
        for fn in ["00_prc_component_type.sql", "01_prc_price_formulas.sql",
                   "02_prc_price_components.sql", "03_prc_formula_components.sql",
                   "04_prc_component_prices.sql", "05_prd_product_price_formulas.sql"]:
            f.write(f"\\echo '>> {fn} ({counts.get(fn,0)} stmts)'\n")
            f.write(f"\\i {fn}\n\n")
        f.write("-- COMMIT/ROLLBACK 은 여기 미포함 — apply.sh 가 모드에 따라 주입.\n")


def main():
    counts = {}
    counts["00_prc_component_type.sql"] = gen_00_component_type()
    counts["01_prc_price_formulas.sql"] = gen_01_formulas()
    counts["02_prc_price_components.sql"] = gen_02_components()
    counts["03_prc_formula_components.sql"] = gen_03_formula_components()
    counts["04_prc_component_prices.sql"] = gen_04_component_prices()
    counts["05_prd_product_price_formulas.sql"] = gen_05_product_price_formulas()
    gen_apply_sql(counts)
    total = sum(counts.values())
    print("가격 적재 SQL 생성 완료:")
    for k in sorted(counts):
        print(f"  {k}: {counts[k]} stmts")
    print(f"  총 INSERT 문: {total} (기대 2,320)")
    assert total == 2320, f"행수 불일치: {total} != 2320"
    print("  행수 검증 OK")


if __name__ == "__main__":
    main()
