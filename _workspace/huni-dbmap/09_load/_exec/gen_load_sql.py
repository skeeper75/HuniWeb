#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_load_sql.py — 상품마스터(t_prd_*/t_proc_/t_siz_) 적재 실행본 생성기 (round-5)

round-4 GO 적재본(09_load/_assembled/load/*.csv + update-set/*.csv)을 멱등 INSERT … ON
CONFLICT / 멱등 UPDATE 실행 SQL + 트랜잭션 래퍼 + provenance 로 변환한다. 재현성(G8): 같은
입력 → 같은 출력. 손편집 금지.

권위: docs/goal-2026-06-06-02.md §8 · sql-idempotent-patterns.md · 라이브 제약 조회(constraints-live.md).

라이브 스키마 정합 처리(조립 중 적발, 침묵 강제변환 금지):
 - t_prd_product_processes 에 excl_grp_cd 컬럼 부재(라이브) → 06 INSERT 에서 해당 컬럼 제외.
   적재 CSV 62행 전건 excl_grp_cd 공란이라 행 손실 0(검증). excl_grp 연결은 update-set(차단)으로 분리.
 - 00_siz_sticker_circle.csv 11행 중 SIZ_000422(_mint=REUSE, 라이브 실재)는 신설 SQL 에서 제외 →
   신설 10행만(search-before-mint). ON CONFLICT DO NOTHING 이라 포함해도 안전하나 의미상 미포함.
 - update-set 6종 중 실행가능 3종(qtyunit/nonspec/thickness)만 SQL 화. 나머지 3종(uv/excl_link/
   excl_groups_note)은 라이브 컬럼·테이블 부재 또는 미확정 placeholder 라 비실행 → blocked-and-gaps.

실행: python3 gen_load_sql.py
"""
import csv
import os
from decimal import Decimal, InvalidOperation

HERE = os.path.dirname(os.path.abspath(__file__))
LOAD = os.path.join(HERE, "..", "_assembled", "load")
UPD = os.path.join(HERE, "..", "_assembled", "update-set")
OUT = HERE


def sql_str(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    return "'" + str(v).replace("'", "''") + "'"


def sql_int(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    return str(int(str(v).strip()))


def sql_num(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    try:
        Decimal(str(v).strip())
    except InvalidOperation:
        raise ValueError(f"비수치 numeric: {v!r}")
    return str(v).strip()


def sql_char1(v):
    if v is None or str(v).strip() == "":
        return "NULL"
    s = str(v).strip()
    if len(s) != 1:
        raise ValueError(f"char(1) 위반: {v!r}")
    return "'" + s.replace("'", "''") + "'"


def sql_ts(v):
    """nullable timestamp 리터럴(upd_dt/del_dt 용). 공란 → NULL.

    주의: 이 함수는 nullable 컬럼 전용이다. NOT NULL DEFAULT 컬럼(reg_dt)에는
    sql_ts_default() 를 써야 한다 — 명시 NULL 은 컬럼 DEFAULT 를 발화시키지 않으며
    (PostgreSQL 의미), NOT NULL 위반으로 적재가 abort 된다(F-1).
    """
    if v is None or str(v).strip() == "":
        return "NULL"
    return "'" + str(v).strip().replace("'", "''") + "'"


def sql_ts_default(v):
    """NOT NULL DEFAULT 컬럼(reg_dt) 전용 timestamp 직렬화.

    공란 → SQL 키워드 DEFAULT(컬럼 DEFAULT now() 발화). 실값 → 리터럴 보존
    (now() 로 붕괴 금지 — 적재본의 '2026-06-05 00:00:00' 를 그대로 유지).
    명시 NULL 은 절대 emit 하지 않는다(NOT NULL 위반 회피). 한 multi-row INSERT
    안에서 DEFAULT 와 리터럴 혼합은 유효한 PostgreSQL 이다.
    """
    if v is None or str(v).strip() == "":
        return "DEFAULT"
    return "'" + str(v).strip().replace("'", "''") + "'"


def read_csv(path):
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_sql(filename, header_note, stmts_with_prov, conflict_or_key):
    path = os.path.join(OUT, filename)
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"-- {filename}\n-- {header_note}\n")
        f.write("-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.\n\n")
        for stmt, prov in stmts_with_prov:
            f.write(f"-- src: {prov}\n{stmt}\n")
    ppath = os.path.join(OUT, filename.replace(".sql", ".provenance.csv"))
    with open(ppath, "w", newline="", encoding="utf-8") as pf:
        w = csv.writer(pf)
        w.writerow(["sql_stmt_seq", "conflict_or_where_key", "source_csv_row"])
        for i, (_, prov) in enumerate(stmts_with_prov, 1):
            w.writerow([i, conflict_or_key, prov])
    return len(stmts_with_prov)


# ---- 단계 00a: t_proc_processes 코드행 선적재 (레이저커팅) ----
def gen_00_proc():
    rows = read_csv(os.path.join(LOAD, "00_proc_laser.csv"))
    cols = ["proc_cd", "proc_nm", "upr_proc_cd", "prcs_dtl_opt", "disp_seq", "use_yn", "note"]
    out = []
    for i, r in enumerate(rows, 2):
        # prcs_dtl_opt 는 jsonb — CSV 공란이면 NULL.
        jsonb = r.get("prcs_dtl_opt", "")
        jsonb_sql = "NULL" if jsonb.strip() == "" else sql_str(jsonb) + "::jsonb"
        vals = [sql_str(r["proc_cd"]), sql_str(r["proc_nm"]), sql_str(r["upr_proc_cd"]),
                jsonb_sql, sql_int(r["disp_seq"]), sql_char1(r["use_yn"]), sql_str(r["note"])]
        stmt = (f"INSERT INTO t_proc_processes ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (proc_cd) DO NOTHING;")
        out.append((stmt, f"00_proc_laser.csv:row{i} proc_cd={r['proc_cd']}"))
    return write_sql("00_proc_processes.sql",
                     "단계00a 코드행 선적재 — 레이저커팅 PROC_000084. PK pk_t_proc_processes(proc_cd).",
                     out, "(proc_cd)")


# ---- 단계 00b: t_siz_sizes 코드행 선적재 (sticker 원형 신설 10) ----
def gen_00_siz():
    rows = read_csv(os.path.join(LOAD, "00_siz_sticker_circle.csv"))
    cols = ["siz_cd", "siz_nm", "cut_width", "cut_height", "impos_yn", "use_yn", "note"]
    out = []
    skipped = []
    for i, r in enumerate(rows, 2):
        mint = r.get("_mint", "")
        if mint.startswith("REUSE"):
            # 라이브 실재(SIZ_000422) — 신설 아님. search-before-mint: 신설 SQL 미포함.
            skipped.append(r["siz_cd"])
            continue
        vals = [sql_str(r["siz_cd"]), sql_str(r["siz_nm"]), sql_num(r["cut_width"]),
                sql_num(r["cut_height"]), sql_char1(r["impos_yn"]), sql_char1(r["use_yn"]),
                sql_str(r["note"])]
        stmt = (f"INSERT INTO t_siz_sizes ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (siz_cd) DO NOTHING;")
        out.append((stmt, f"00_siz_sticker_circle.csv:row{i} siz_cd={r['siz_cd']}"))
    n = write_sql("00_siz_sizes.sql",
                  f"단계00b 코드행 선적재 — sticker 원형 신설 10(SIZ_000501~510). "
                  f"REUSE 제외: {','.join(skipped)} (라이브 실재). PK pk_t_siz_sizes(siz_cd).",
                  out, "(siz_cd)")
    return n


# ---- 단계 05: t_prd_product_materials ----
def gen_05_materials():
    rows = read_csv(os.path.join(LOAD, "05_t_prd_product_materials.csv"))
    cols = ["prd_cd", "mat_cd", "usage_cd", "dep_proc_cd", "dflt_yn", "disp_seq", "reg_dt", "upd_dt"]
    out = []
    for i, r in enumerate(rows, 2):
        vals = [sql_str(r["prd_cd"]), sql_str(r["mat_cd"]), sql_str(r["usage_cd"]),
                sql_str(r["dep_proc_cd"]), sql_char1(r["dflt_yn"]), sql_int(r["disp_seq"]),
                sql_ts_default(r["reg_dt"]), sql_ts(r["upd_dt"])]  # reg_dt = NOT NULL DEFAULT now()
        stmt = (f"INSERT INTO t_prd_product_materials ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;")
        out.append((stmt, f"05_t_prd_product_materials.csv:row{i} {r['prd_cd']}/{r['mat_cd']}/{r['usage_cd']}"))
    return write_sql("05_t_prd_product_materials.sql",
                     "단계05 상품-자재 — PK t_prd_product_materials_pkey(prd_cd, mat_cd, usage_cd).",
                     out, "(prd_cd, mat_cd, usage_cd)")


# ---- 단계 06: t_prd_product_processes (excl_grp_cd 컬럼 제외 — 라이브 부재) ----
def gen_06_processes():
    rows = read_csv(os.path.join(LOAD, "06_t_prd_product_processes.csv"))
    # 라이브 컬럼: prd_cd, proc_cd, mand_proc_yn, disp_seq, reg_dt, upd_dt (excl_grp_cd 부재)
    cols = ["prd_cd", "proc_cd", "mand_proc_yn", "disp_seq", "reg_dt", "upd_dt"]
    out = []
    for i, r in enumerate(rows, 2):
        # 가드: excl_grp_cd 가 비공란이면 데이터 손실이므로 중단(현 적재본 전건 공란 확증).
        if r.get("excl_grp_cd", "").strip() != "":
            raise ValueError(
                f"06 행{i} excl_grp_cd 비공란({r['excl_grp_cd']!r}) — 라이브 컬럼 부재로 적재 불가. "
                f"truncate/drop 금지, ddl-proposer 로 라우팅")
        vals = [sql_str(r["prd_cd"]), sql_str(r["proc_cd"]), sql_char1(r["mand_proc_yn"]),
                sql_int(r["disp_seq"]), sql_ts_default(r["reg_dt"]), sql_ts(r["upd_dt"])]  # reg_dt = NOT NULL DEFAULT now()
        stmt = (f"INSERT INTO t_prd_product_processes ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (prd_cd, proc_cd) DO NOTHING;")
        out.append((stmt, f"06_t_prd_product_processes.csv:row{i} {r['prd_cd']}/{r['proc_cd']}"))
    return write_sql("06_t_prd_product_processes.sql",
                     "단계06 상품-공정 — PK t_prd_product_processes_pkey(prd_cd, proc_cd). "
                     "라이브 excl_grp_cd 컬럼 부재 → INSERT 에서 제외(적재본 전건 공란, 손실 0).",
                     out, "(prd_cd, proc_cd)")


# ---- 단계 09: t_prd_product_bundle_qtys ----
def gen_09_bundle():
    rows = read_csv(os.path.join(LOAD, "09_t_prd_product_bundle_qtys.csv"))
    cols = ["prd_cd", "bdl_qty", "bdl_unit_typ_cd", "dflt_yn", "disp_seq", "reg_dt", "upd_dt"]
    out = []
    for i, r in enumerate(rows, 2):
        vals = [sql_str(r["prd_cd"]), sql_int(r["bdl_qty"]), sql_str(r["bdl_unit_typ_cd"]),
                sql_char1(r["dflt_yn"]), sql_int(r["disp_seq"]), sql_ts_default(r["reg_dt"]), sql_ts(r["upd_dt"])]  # reg_dt = NOT NULL DEFAULT now()
        stmt = (f"INSERT INTO t_prd_product_bundle_qtys ({', '.join(cols)})\n"
                f"VALUES ({', '.join(vals)})\n"
                f"ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;")
        out.append((stmt, f"09_t_prd_product_bundle_qtys.csv:row{i} {r['prd_cd']}/bdl{r['bdl_qty']}"))
    return write_sql("09_t_prd_product_bundle_qtys.sql",
                     "단계09 상품-묶음수 — PK t_prd_product_bundle_qtys_pkey(prd_cd, bdl_qty).",
                     out, "(prd_cd, bdl_qty)")


# ---- 단계 90: update-set (실행가능 3종, 멱등 UPDATE) ----
def gen_90_update_set():
    """기존 라이브 행 컬럼 갱신. 멱등: WHERE … IS DISTINCT FROM target → 2회차 0행.
    실행가능 3종만(qtyunit/nonspec/thickness). uv/excl_link/excl_groups_note 는 비실행(blocked).
    """
    out = []
    # qtyunit (244): t_prd_products.qty_unit_typ_cd
    for i, r in enumerate(read_csv(os.path.join(UPD, "t_prd_products_qtyunit_update.csv")), 2):
        tgt = r["target_qty_unit_typ_cd"]
        stmt = (f"UPDATE t_prd_products SET qty_unit_typ_cd = {sql_str(tgt)}, upd_dt = now()\n"
                f"WHERE prd_cd = {sql_str(r['prd_cd'])} "
                f"AND qty_unit_typ_cd IS DISTINCT FROM {sql_str(tgt)};")
        out.append((stmt, f"qtyunit_update.csv:row{i} {r['prd_cd']}→{tgt}"))
    # nonspec (25): t_prd_products.nonspec_yn + 범위
    for i, r in enumerate(read_csv(os.path.join(UPD, "t_prd_products_nonspec_update.csv")), 2):
        tgt = r["target_nonspec_yn"]
        stmt = (f"UPDATE t_prd_products SET nonspec_yn = {sql_char1(tgt)}, "
                f"nonspec_width_min = {sql_num(r['nonspec_width_min'])}, "
                f"nonspec_width_max = {sql_num(r['nonspec_width_max'])}, "
                f"nonspec_height_min = {sql_num(r['nonspec_height_min'])}, "
                f"nonspec_height_max = {sql_num(r['nonspec_height_max'])}, upd_dt = now()\n"
                f"WHERE prd_cd = {sql_str(r['prd_cd'])} AND ("
                f"nonspec_yn IS DISTINCT FROM {sql_char1(tgt)} "
                f"OR nonspec_width_min IS DISTINCT FROM {sql_num(r['nonspec_width_min'])} "
                f"OR nonspec_width_max IS DISTINCT FROM {sql_num(r['nonspec_width_max'])} "
                f"OR nonspec_height_min IS DISTINCT FROM {sql_num(r['nonspec_height_min'])} "
                f"OR nonspec_height_max IS DISTINCT FROM {sql_num(r['nonspec_height_max'])});")
        out.append((stmt, f"nonspec_update.csv:row{i} {r['prd_cd']}→{tgt}"))
    # thickness (20): t_prd_product_materials.mat_cd 정정 (current→target). PK 컬럼 변경.
    for i, r in enumerate(read_csv(os.path.join(UPD, "t_prd_product_materials_thickness_update.csv")), 2):
        cur, tgt = r["current_mat_cd"], r["target_mat_cd"]
        # 멱등: current(192) 가 이미 target 으로 바뀐 2회차엔 WHERE 무매치 → 0행.
        stmt = (f"UPDATE t_prd_product_materials SET mat_cd = {sql_str(tgt)}, upd_dt = now()\n"
                f"WHERE prd_cd = {sql_str(r['prd_cd'])} "
                f"AND mat_cd = {sql_str(cur)} AND usage_cd = {sql_str(r['usage_cd'])};")
        out.append((stmt, f"thickness_update.csv:row{i} {r['prd_cd']} {cur}→{tgt}"))
    return write_sql("90_update_set.sql",
                     "단계90 update-set(실행가능 3종) — qtyunit 244·nonspec 25·thickness 20. "
                     "멱등 UPDATE(IS DISTINCT FROM/PK 키변경 무매치). INSERT 단계 이후 적용.",
                     out, "UPDATE WHERE prd_cd[+key]")


def gen_apply_sql(counts):
    path = os.path.join(OUT, "apply.sql")
    order = ["00_proc_processes.sql", "00_siz_sizes.sql",
             "05_t_prd_product_materials.sql", "06_t_prd_product_processes.sql",
             "09_t_prd_product_bundle_qtys.sql", "90_update_set.sql"]
    with open(path, "w", encoding="utf-8") as f:
        f.write("-- apply.sql — 상품마스터 적재 단일 트랜잭션 래퍼 (round-5)\n")
        f.write("-- BEGIN 으로 열고 COMMIT/ROLLBACK 은 apply.sh 가 주입. 기본 = DRY-RUN(ROLLBACK).\n")
        f.write("-- FK 위상정렬: 00a proc → 00b siz(코드행) → 05 materials → 06 processes → 09 bundle → 90 update-set.\n")
        f.write("-- 차단/GAP(레이저커팅 의존 14·addon 4·디자인캘린더 18·goods-pouch GAP·uv/excl update-set)는 미포함.\n\n")
        f.write("\\set ON_ERROR_STOP on\nBEGIN;\n\n")
        for fn in order:
            f.write(f"\\echo '>> {fn} ({counts.get(fn,0)} stmts)'\n\\i {fn}\n\n")
        f.write("-- COMMIT/ROLLBACK 미포함 — apply.sh 가 모드에 따라 주입.\n")


def main():
    counts = {}
    counts["00_proc_processes.sql"] = gen_00_proc()
    counts["00_siz_sizes.sql"] = gen_00_siz()
    counts["05_t_prd_product_materials.sql"] = gen_05_materials()
    counts["06_t_prd_product_processes.sql"] = gen_06_processes()
    counts["09_t_prd_product_bundle_qtys.sql"] = gen_09_bundle()
    counts["90_update_set.sql"] = gen_90_update_set()
    gen_apply_sql(counts)
    inserts = (counts["00_proc_processes.sql"] + counts["00_siz_sizes.sql"]
               + counts["05_t_prd_product_materials.sql"] + counts["06_t_prd_product_processes.sql"]
               + counts["09_t_prd_product_bundle_qtys.sql"])
    print("상품마스터 적재 SQL 생성 완료:")
    for k in ["00_proc_processes.sql", "00_siz_sizes.sql", "05_t_prd_product_materials.sql",
              "06_t_prd_product_processes.sql", "09_t_prd_product_bundle_qtys.sql", "90_update_set.sql"]:
        print(f"  {k}: {counts[k]} stmts")
    print(f"  INSERT 합계(코드행 11 + 적재 384): {inserts}")
    print(f"  UPDATE-set(실행가능): {counts['90_update_set.sql']} (기대 289 = qtyunit 244+nonspec 25+thickness 20)")
    # 즉시 적재 384 = materials 316 + processes 62 + bundle 6
    load_384 = (counts["05_t_prd_product_materials.sql"] + counts["06_t_prd_product_processes.sql"]
                + counts["09_t_prd_product_bundle_qtys.sql"])
    assert load_384 == 384, f"즉시적재 행수 불일치: {load_384} != 384"
    assert counts["00_proc_processes.sql"] == 1, "proc 코드행 != 1"
    assert counts["00_siz_sizes.sql"] == 10, "siz 신설 != 10 (REUSE 제외 후)"
    assert counts["90_update_set.sql"] == 289, f"update-set != 289: {counts['90_update_set.sql']}"
    print("  행수 검증 OK (코드행 1+10, 적재 384, update-set 289)")


if __name__ == "__main__":
    main()
