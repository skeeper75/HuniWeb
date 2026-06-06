#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_correction_bundle_sql.py — 정정(보완) 묶음수 적재 SQL 생성기

Jun-4 SIZE_NAME_NOISE 정정에서 GO 판정됐으나 round-5 _exec 에 통합되지 않은
고아 적재본(02_mapping/correction/load/t_prd_product_bundle_qtys.csv, 18행 9상품)을
멱등 INSERT … ON CONFLICT DO NOTHING SQL(09b 단계)로 변환한다.

round-5 09_t_prd_product_bundle_qtys.sql 과 동일 패턴:
 - 충돌키 = PK (prd_cd, bdl_qty) — constraints-live.md 권위.
 - reg_dt = NOT NULL DEFAULT now() → 공란이면 SQL 키워드 DEFAULT(now() 발화), 명시 NULL 금지(F-1).
 - dflt_yn = char(1) NOT NULL, disp_seq 공란 → NULL.

FK 라이브 read-only 검증 완료(2026-06-06, db=railway):
 - prd_cd→t_prd_products: 9/9 실존.
 - bdl_unit_typ_cd→QTY_UNIT .01/.02/.04: 전부 실존.
 - PK 충돌: PRD_000001/50, PRD_000002/50 라이브 선존 → ON CONFLICT DO NOTHING 으로 no-op(멱등).

재현성(G8): 같은 CSV → 같은 SQL. 손편집 금지. COMMIT/DDL 미포함.
실행: python3 gen_correction_bundle_sql.py
"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..", "..")  # huni-dbmap
SRC = os.path.join(ROOT, "02_mapping", "correction", "load", "t_prd_product_bundle_qtys.csv")
OUT_SQL = os.path.join(HERE, "09b_correction_bundle_qtys.sql")
OUT_PROV = os.path.join(HERE, "09b_correction_bundle_qtys.provenance.csv")


def sql_str(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    return "'" + str(v).strip().replace("'", "''") + "'"


def sql_int(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    return str(int(str(v).strip()))


def sql_char1(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    s = str(v).strip()
    if len(s) != 1:
        raise ValueError(f"char(1) 위반: {v!r}")
    return "'" + s.replace("'", "''") + "'"


def main():
    with open(SRC, newline="", encoding="utf-8-sig") as f:
        rows = [r for r in csv.DictReader(f) if r.get("prd_cd")]
    assert len(rows) == 18, f"정정 묶음수 CSV 행수 {len(rows)} != 18"

    cols = ["prd_cd", "bdl_qty", "bdl_unit_typ_cd", "dflt_yn", "disp_seq", "reg_dt", "upd_dt"]
    stmts = []
    for i, r in enumerate(rows, 2):  # CSV row2 부터(헤더=row1)
        # reg_dt/upd_dt 는 CSV 에 컬럼 없음 → reg_dt 공란→DEFAULT(now()), upd_dt→NULL.
        vals = [
            sql_str(r["prd_cd"]),
            sql_int(r["bdl_qty"]),
            sql_str(r["bdl_unit_typ_cd"]),
            sql_char1(r["dflt_yn"]),
            sql_int(r.get("disp_seq", "")),
            "DEFAULT",   # reg_dt = NOT NULL DEFAULT now() — 공란 → DEFAULT
            "NULL",      # upd_dt nullable
        ]
        stmt = (f"INSERT INTO t_prd_product_bundle_qtys ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;")
        prov = (f"correction/load/t_prd_product_bundle_qtys.csv:row{i} "
                f"{r['prd_cd']}/bdl{r['bdl_qty']}")
        stmts.append((stmt, prov))

    with open(OUT_SQL, "w", encoding="utf-8") as f:
        f.write("-- 09b_correction_bundle_qtys.sql\n")
        f.write("-- 단계09b 정정(보완) 묶음수 — Jun-4 SIZE_NAME_NOISE 정정 GO 적재본 18행 9상품.\n")
        f.write("-- round-5 _exec 미통합 고아 적재본을 멱등 통합. PK t_prd_product_bundle_qtys_pkey(prd_cd, bdl_qty).\n")
        f.write("-- 출처: 02_mapping/correction/load/t_prd_product_bundle_qtys.csv (검증 GO — correction-validation-report.md §3).\n")
        f.write("-- FK 검증 완료(read-only): prd_cd 9/9·QTY_UNIT .01/.02/.04 실존. PRD_000001/50·PRD_000002/50 선존→DO NOTHING no-op.\n")
        f.write("-- 생성: gen_correction_bundle_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.\n\n")
        for stmt, prov in stmts:
            f.write(f"-- src: {prov}\n{stmt}\n")

    with open(OUT_PROV, "w", newline="", encoding="utf-8") as pf:
        w = csv.writer(pf)
        w.writerow(["sql_stmt_seq", "conflict_or_where_key", "source_csv_row"])
        for i, (_, prov) in enumerate(stmts, 1):
            w.writerow([i, "(prd_cd, bdl_qty)", prov])

    print(f"09b_correction_bundle_qtys.sql 생성: {len(stmts)} stmts (18 INSERT, ON CONFLICT DO NOTHING)")
    # 검증: 9 distinct prd_cd, dflt_yn 전건 N
    prds = sorted(set(r["prd_cd"] for r in rows))
    assert len(prds) == 9, f"distinct prd_cd {len(prds)} != 9"
    assert all(r["dflt_yn"].strip() == "N" for r in rows), "dflt_yn 비-N 존재"
    print(f"  distinct prd_cd: {len(prds)} {prds}")


if __name__ == "__main__":
    main()
