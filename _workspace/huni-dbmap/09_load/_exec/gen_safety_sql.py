#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_safety_sql.py — 상품마스터(t_prd_*/t_proc_/t_siz_) COMMIT-안전 인프라 생성기
(round-5 보강, dbm-load-builder)

목적: 인간이 실제 COMMIT 을 승인하기 전/후에 적재를 **무손실 되돌릴(REVERSIBLE)** 수 있도록
백업 스냅샷 SQL + 언두 SQL 을 재현적으로 생성한다. 본 스크립트는 적재 SQL(00~90)을 일절
변경하지 않는다 — 멱등성 보존. 입력 = 같은 디렉터리의 적재 SQL(권위), 출력 = 안전 SQL 일체.

전략(정확히 어떻게 되돌리는가):
  (A) INSERT 단계(00 proc·siz / 05 materials / 06 processes / 09·09b bundle) —
      apply.sh 가 commit 트랜잭션 안에서 "이 트랜잭션이 실제로 새로 INSERT 한 행"만
      xmin = pg_current_xact_id()::xid 로 식별해 inserted_keys_<runts>.csv 로 캡처한다.
      (ON CONFLICT DO NOTHING 으로 선존 행은 xmin 이 이전 트랜잭션 → 제외 = 정확.)
      언두 = 그 로그된 PK 키만 DELETE. 선존 행은 절대 건드리지 않음.
  (B) UPDATE-set 단계(90 qtyunit·nonspec·thickness) — 적재 전 현재값(before-image)을
      backup-before-load.sh 가 timestamped CSV 로 스냅샷한다. 언두 = before-image 로 UPDATE 복원.

권위: constraints-live.md(PK/컬럼), 90_update_set.sql(영향 키·SET 컬럼), 라이브 read-only
컬럼조회(2026-06-06, PG 18.4). 식별자/SQL 영어, 주석 한국어. 손편집 금지.

실행: python3 gen_safety_sql.py   (출력은 본 디렉터리)
"""
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
UPDATE_SET_SQL = os.path.join(HERE, "90_update_set.sql")

# ── INSERT 단계: 테이블 → PK 컬럼(언두 DELETE 키). constraints-live.md §1 권위. ──
# 적재 순서(FK 위상정렬)의 역순으로 DELETE(자식 먼저) — 단 본 적재본은 코드행(proc/siz)이
# 부모, 상품-자재/공정/묶음이 자식이므로 자식 먼저 삭제 후 코드행 삭제.
INSERT_STEPS = [
    # (sql_file, target_table, pk_cols)  — DELETE 순서(자식→부모)
    ("09b_correction_bundle_qtys.sql", "t_prd_product_bundle_qtys", ["prd_cd", "bdl_qty"]),
    ("09_t_prd_product_bundle_qtys.sql", "t_prd_product_bundle_qtys", ["prd_cd", "bdl_qty"]),
    ("06_t_prd_product_processes.sql", "t_prd_product_processes", ["prd_cd", "proc_cd"]),
    ("05_t_prd_product_materials.sql", "t_prd_product_materials", ["prd_cd", "mat_cd", "usage_cd"]),
    ("00_siz_sizes.sql", "t_siz_sizes", ["siz_cd"]),
    ("00_proc_processes.sql", "t_proc_processes", ["proc_cd"]),
]

# ── UPDATE-set 단계: before-image 스냅샷/복원 명세 ──
# t_prd_products: qtyunit + nonspec 가 같은 테이블의 다른 컬럼을 건드림 → 한 행으로 통합 스냅샷.
PRODUCTS_BACKUP_COLS = [
    "prd_cd", "qty_unit_typ_cd", "nonspec_yn",
    "nonspec_width_min", "nonspec_width_max",
    "nonspec_height_min", "nonspec_height_max",
]
# thickness: t_prd_product_materials 의 PK(mat_cd) 자체를 바꾸므로 PK 식별행 전체를 스냅샷.
MATERIALS_BACKUP_COLS = [
    "prd_cd", "mat_cd", "usage_cd", "dep_proc_cd", "dflt_yn", "disp_seq",
]


def parse_affected_prd_for_products():
    """90_update_set.sql 에서 t_prd_products 를 건드리는(qtyunit/nonspec) prd_cd 합집합 추출."""
    txt = open(UPDATE_SET_SQL, encoding="utf-8").read()
    prds = set()
    # qty_unit_typ_cd UPDATE: "WHERE prd_cd = 'X' AND qty_unit_typ_cd IS DISTINCT ..."
    for m in re.finditer(r"SET qty_unit_typ_cd =.*?\n\s*WHERE prd_cd = '([^']+)'", txt, re.S):
        prds.add(m.group(1))
    for m in re.finditer(r"SET nonspec_yn =.*?\n\s*WHERE prd_cd = '([^']+)'", txt, re.S):
        prds.add(m.group(1))
    return sorted(prds)


def parse_affected_materials_for_thickness():
    """thickness UPDATE 의 (prd_cd, 현재 mat_cd=PK 식별, usage_cd) 키 추출. before-image 대상."""
    txt = open(UPDATE_SET_SQL, encoding="utf-8").read()
    keys = []
    for m in re.finditer(
        r"SET mat_cd =.*?\n\s*WHERE prd_cd = '([^']+)' AND mat_cd = '([^']+)' AND usage_cd = '([^']+)'",
        txt, re.S,
    ):
        keys.append((m.group(1), m.group(2), m.group(3)))  # (prd, old_mat, usage)
    return keys


def in_list(vals):
    return ", ".join("'" + v.replace("'", "''") + "'" for v in vals)


# ───────────────────────── 1) backup-before-load.sql ─────────────────────────
def gen_backup_sql():
    """before-image 스냅샷 쿼리 3종(서버측 COPY ... TO STDOUT). 셸이 각각 파일로 리다이렉트.

    psql v18 의 \\copy/\\o 는 :'var' 경로 보간을 지원하지 않으므로(검증), COPY ... TO STDOUT +
    셸 stdout 리다이렉트(파일당 psql 1회)를 쓴다. 전부 read-only — DB 변경 0.
    출력: backup_q_products.sql / backup_q_materials.sql / backup_q_coderows.sql.
    """
    prds = parse_affected_prd_for_products()
    mat_keys = parse_affected_materials_for_thickness()

    # (B-1) t_prd_products before-image (qtyunit + nonspec union)
    q_products = (
        "COPY (SELECT " + ", ".join(PRODUCTS_BACKUP_COLS) +
        " FROM t_prd_products WHERE prd_cd IN (" + in_list(prds) + ")"
        " ORDER BY prd_cd) TO STDOUT WITH (FORMAT csv, HEADER true);"
    )
    _write_query_file(
        "backup_q_products.sql",
        f"상품마스터 before-image — t_prd_products (qtyunit+nonspec 영향 {len(prds)}상품). read-only.",
        q_products)

    # (B-2) t_prd_product_materials before-image (thickness PK rows)
    mat_or = " OR ".join(
        f"(prd_cd = '{p}' AND mat_cd = '{m}' AND usage_cd = '{u}')" for (p, m, u) in mat_keys
    )
    q_materials = (
        "COPY (SELECT " + ", ".join(MATERIALS_BACKUP_COLS) +
        " FROM t_prd_product_materials WHERE " + mat_or +
        " ORDER BY prd_cd, mat_cd, usage_cd) TO STDOUT WITH (FORMAT csv, HEADER true);"
    )
    _write_query_file(
        "backup_q_materials.sql",
        f"상품마스터 before-image — t_prd_product_materials thickness PK행 {len(mat_keys)}건(mat_cd 변경=PK변경). read-only.",
        q_materials)

    # (B-3) INSERT 코드행 타깃의 선존 여부(00 proc/siz) — 진단(적재 전 부재여야 정상).
    q_coderows = (
        "COPY (SELECT 't_proc_processes' AS tbl, proc_cd AS k FROM t_proc_processes "
        "WHERE proc_cd = 'PROC_000084' "
        "UNION ALL SELECT 't_siz_sizes', siz_cd FROM t_siz_sizes "
        "WHERE siz_cd IN ('SIZ_000501','SIZ_000502','SIZ_000503','SIZ_000504','SIZ_000505',"
        "'SIZ_000506','SIZ_000507','SIZ_000508','SIZ_000509','SIZ_000510') "
        "ORDER BY tbl, k) TO STDOUT WITH (FORMAT csv, HEADER true);"
    )
    _write_query_file(
        "backup_q_coderows.sql",
        "코드행 타깃 선존 진단 — proc/siz 신설 대상이 적재 전 부재여야 정상. read-only.",
        q_coderows)
    return len(prds), len(mat_keys)


def _write_query_file(filename, note, query_sql):
    """단일 COPY ... TO STDOUT 쿼리 파일(셸이 stdout 리다이렉트). 메타명령 없음."""
    path = os.path.join(HERE, filename)
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"-- {filename} — {note}\n")
        f.write("-- 생성: gen_safety_sql.py (손편집 금지). COPY ... TO STDOUT — 셸이 파일로 리다이렉트.\n")
        f.write(query_sql + "\n")


# ───────────────────────── 2) capture-inserted-keys.sql ─────────────────────────
def gen_capture_sql():
    """commit 트랜잭션 안에서 '이 트랜잭션이 새로 INSERT 한 행'만 PK 로 캡처해 CSV 로 \\copy.

    xmin = pg_current_xact_id()::xid 로 현재 트랜잭션 신규행을 정확히 식별(ON CONFLICT 로
    스킵된 선존행은 이전 xmin → 제외). 언두가 '신규행만 DELETE' 하도록 보장하는 핵심.
    apply.sh commit 모드가 \\i 적재 직후·COMMIT 직전에 이 파일을 같은 세션에서 실행.
    """
    path = os.path.join(HERE, "capture-inserted-keys.sql")
    lines = []
    lines.append("-- capture-inserted-keys.sql — 현재 commit 트랜잭션이 새로 INSERT 한 PK 키 캡처")
    lines.append("-- 생성: gen_safety_sql.py (손편집 금지). 적재 SQL 미변경(멱등성 보존).")
    lines.append("-- apply.sh commit 모드가 \\i 적재 직후·COMMIT 직전에 같은 트랜잭션에서 실행.")
    lines.append("-- apply.sh 가 이 COPY 앞뒤로 \\o <keys.csv> / \\o 를 주입 → 데이터만 파일로 라우팅.")
    lines.append("-- 식별: xmin = pg_current_xact_id()::xid → ON CONFLICT 로 스킵된 선존행 제외(정확).")
    lines.append("--")
    lines.append("-- [핵심 보정] thickness UPDATE-set(90)은 mat_cd(=PK)를 바꾼다 → 갱신된 행의 xmin 이")
    lines.append("-- 현재 트랜잭션이 되어 'INSERT 신규행'처럼 보인다. 이를 INSERT-언두 DELETE 대상에서")
    lines.append("-- 제외해야 한다(이 행은 UPDATE 이므로 before-image UPDATE-복원이 담당). 아래 t_prd_")
    lines.append("-- product_materials 캡처는 thickness NEW-타깃 (prd,NEW_mat,usage)을 NOT IN 으로 배제.")
    # thickness UPDATE 의 NEW-타깃 키(이 캡처에서 배제할 키). 적재 SQL 권위에서 파싱.
    thk_pairs = _parse_thickness_pairs()  # (prd, old_mat, usage, new_mat)
    thk_new_keys = sorted({(p, nm, u) for (p, _om, u, nm) in thk_pairs})
    # 단일 CSV 에 (tbl, pk_cols, pk_vals) 형태로 통합 — 언두가 테이블별로 파싱.
    # 같은 테이블 중복 step(09/09b)은 한 번만 캡처.
    seen = set()
    uniq = []
    for _fn, tbl, pk in INSERT_STEPS:
        if tbl in seen:
            continue
        seen.add(tbl)
        key_concat = " || '|' || ".join(f"{c}::text" for c in pk)
        where = "xmin = pg_current_xact_id()::xid"
        if tbl == "t_prd_product_materials":
            # thickness NEW-타깃 배제(이 행은 INSERT 가 아니라 PK 변경 UPDATE).
            excl = ", ".join(
                f"('{p}','{nm}','{u}')" for (p, nm, u) in thk_new_keys
            )
            where += (
                f" AND (prd_cd, mat_cd, usage_cd) NOT IN ({excl})"
            )
        uniq.append(
            f"SELECT '{tbl}' AS tbl, '{','.join(pk)}' AS pk_cols, {key_concat} AS pk_vals "
            f"FROM {tbl} WHERE {where}"
        )
    capture_query = " UNION ALL ".join(uniq) + " ORDER BY tbl, pk_vals"
    lines.append(f"COPY ({capture_query}) TO STDOUT WITH (FORMAT csv, HEADER true);")
    lines.append("")
    open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    return [t for _f, t, _p in INSERT_STEPS]


# ───────────────────────── 3) undo-after-load.sql ─────────────────────────
def gen_undo_sql():
    """언두: (A) 로그된 신규 PK 키만 DELETE + (B) before-image 로 UPDATE-set 복원.

    \\set 변수로 백업 디렉터리 경로 주입(undo.sh). 단일 트랜잭션(BEGIN…), COMMIT/ROLLBACK
    은 undo.sh 가 모드에 따라 주입(기본 DRY-RUN=ROLLBACK).
    """
    path = os.path.join(HERE, "undo-after-load.sql")
    lines = []
    lines.append("-- undo-after-load.sql — 상품마스터 적재를 무손실 되돌리는 언두 데이터 연산 (round-5)")
    lines.append("-- 생성: gen_safety_sql.py (손편집 금지).")
    lines.append("--")
    lines.append("-- 본 파일은 BEGIN/CREATE TEMP/\\copy FROM 을 포함하지 않는다 — undo.sh 가 리터럴 경로로")
    lines.append("-- 임시테이블(_undo_keys/_bi_products/_bi_materials)을 선적재한 뒤 이 파일을 \\i 한다.")
    lines.append("-- (psql v18 의 \\copy 는 :'var' 경로 보간 미지원 → 셸이 리터럴 경로 주입.)")
    lines.append("-- COMMIT/ROLLBACK 도 undo.sh 가 주입. 기본 = DRY-RUN(ROLLBACK).")
    lines.append("--")
    lines.append("-- (A) INSERT 언두 = 로그된 신규 PK 만 DELETE(선존행 불가침).")
    lines.append("-- (B) UPDATE-set 언두 = before-image 로 복원.")
    lines.append("")
    lines.append("-- ── (A) INSERT 언두 — 로그된 신규 PK 키만 DELETE (_undo_keys 선적재 전제) ──")
    # 테이블별 DELETE (자식→부모 순서; INSERT_STEPS 가 이미 그 순서)
    seen = set()
    for _fn, tbl, pk in INSERT_STEPS:
        if tbl in seen:
            continue
        seen.add(tbl)
        # pk_vals 는 'v1|v2|v3' 형태 → split_part 로 분해 매칭.
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
    lines.append("-- ── (B) UPDATE-set 언두 — before-image 로 복원 (_bi_* 선적재 전제) ──")
    lines.append("-- (B-1) t_prd_products: qty_unit_typ_cd + nonspec 5컬럼을 백업값으로 되돌림.")
    lines.append("\\echo '>> undo RESTORE t_prd_products (before-image)'")
    lines.append("UPDATE t_prd_products p SET")
    lines.append("  qty_unit_typ_cd  = b.qty_unit_typ_cd,")
    lines.append("  nonspec_yn       = b.nonspec_yn,")
    lines.append("  nonspec_width_min  = b.nonspec_width_min,")
    lines.append("  nonspec_width_max  = b.nonspec_width_max,")
    lines.append("  nonspec_height_min = b.nonspec_height_min,")
    lines.append("  nonspec_height_max = b.nonspec_height_max,")
    lines.append("  upd_dt = now()")
    lines.append("FROM _bi_products b")
    lines.append("WHERE p.prd_cd = b.prd_cd")
    lines.append("  AND (p.qty_unit_typ_cd IS DISTINCT FROM b.qty_unit_typ_cd")
    lines.append("    OR p.nonspec_yn IS DISTINCT FROM b.nonspec_yn")
    lines.append("    OR p.nonspec_width_min IS DISTINCT FROM b.nonspec_width_min")
    lines.append("    OR p.nonspec_width_max IS DISTINCT FROM b.nonspec_width_max")
    lines.append("    OR p.nonspec_height_min IS DISTINCT FROM b.nonspec_height_min")
    lines.append("    OR p.nonspec_height_max IS DISTINCT FROM b.nonspec_height_max);")
    lines.append("")
    lines.append("-- (B-2) t_prd_product_materials thickness: mat_cd(=PK) 변경을 되돌림.")
    lines.append("-- 적재가 (prd,OLD_mat,usage) → mat_cd=NEW 로 바꿨으므로, 언두는 백업의")
    lines.append("-- (prd, OLD_mat, usage) 가 사라지고 (prd, NEW_mat, usage) 가 생겼다.")
    lines.append("-- before-image(_bi_materials, undo.sh 선적재)에는 OLD 행 전체가 있다. 복원 = 현재")
    lines.append("-- NEW PK 행을 OLD 로 되돌리되, 적재 매핑(OLD→NEW)을 thickness_update 에서 읽어 짝지운다.")
    lines.append("-- OLD→NEW 매핑(적재 SQL 권위에서 그대로 추출, 손편집 0).")
    lines.append("CREATE TEMP TABLE _thk_map (prd_cd text, old_mat text, usage_cd text, new_mat text) ON COMMIT DROP;")
    # OLD→NEW 매핑을 적재 SQL 에서 파싱해 INSERT 로 주입(재현성·리터럴, 경로변수 무관).
    thk_pairs = _parse_thickness_pairs()
    for (prd, old_mat, usage, new_mat) in thk_pairs:
        lines.append(
            f"INSERT INTO _thk_map VALUES ('{prd}', '{old_mat}', '{usage}', '{new_mat}');"
        )
    lines.append("\\echo '>> undo RESTORE t_prd_product_materials thickness (mat_cd PK revert)'")
    lines.append("UPDATE t_prd_product_materials m SET mat_cd = t.old_mat, upd_dt = now()")
    lines.append("FROM _thk_map t")
    lines.append("WHERE m.prd_cd = t.prd_cd AND m.usage_cd = t.usage_cd AND m.mat_cd = t.new_mat")
    lines.append("  -- 안전: before-image 에 OLD 행이 실제 존재했던 경우만 복원(임의 행 생성 방지).")
    lines.append("  AND EXISTS (SELECT 1 FROM _bi_materials bi")
    lines.append("             WHERE bi.prd_cd = t.prd_cd AND bi.usage_cd = t.usage_cd AND bi.mat_cd = t.old_mat);")
    lines.append("")
    lines.append("DROP TABLE IF EXISTS _thk_map;")
    lines.append("-- (BEGIN/COMMIT/ROLLBACK·_undo_keys/_bi_* 선적재는 undo.sh 가 리터럴 경로로 래핑.)")
    open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    return thk_pairs


def _parse_thickness_pairs():
    """thickness UPDATE 의 (prd, OLD_mat, usage, NEW_mat) 짝을 적재 SQL 에서 추출."""
    txt = open(UPDATE_SET_SQL, encoding="utf-8").read()
    pairs = []
    for m in re.finditer(
        r"SET mat_cd = '([^']+)'.*?\n\s*WHERE prd_cd = '([^']+)' AND mat_cd = '([^']+)' AND usage_cd = '([^']+)'",
        txt, re.S,
    ):
        new_mat, prd, old_mat, usage = m.group(1), m.group(2), m.group(3), m.group(4)
        pairs.append((prd, old_mat, usage, new_mat))
    return pairs


def main():
    n_prd, n_mat = gen_backup_sql()
    tables = gen_capture_sql()
    thk = gen_undo_sql()
    print("상품마스터 COMMIT-안전 SQL 생성 완료:")
    print(f"  backup-before-load.sql  : t_prd_products {n_prd}상품 + materials {n_mat}건 + 코드행 진단")
    print(f"  capture-inserted-keys.sql: {len(set(tables))} 고유 테이블 신규행 PK 캡처(xmin)")
    print(f"  undo-after-load.sql      : INSERT 언두(로그키 DELETE) + UPDATE 언두(before-image), thickness {len(thk)}짝")


if __name__ == "__main__":
    main()
