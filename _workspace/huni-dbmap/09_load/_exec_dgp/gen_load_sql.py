#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — 디지털인쇄 가격엔진 GO 적재본 → 멱등 적재 SQL 생성기
#   round-5 적재 실행본 (dbm-load-builder). 손편집 금지 — 이 스크립트가 권위.
#
#   입력 (검증 GO 적재본, LOADABLE 147행):
#     02_mapping/digital-print-engine/
#       t_prc_price_formulas_DGP.csv             (6)
#       t_prc_price_components_PAPER.csv         (1, COMP_PAPER)
#       t_prc_formula_components_DGP.csv         (72)
#       t_prc_component_prices_PAPER.csv         (49, 용지비)
#       t_prd_product_price_formulas_DGP.csv     (19)
#   BLOCKED 파일(_BLOCKED_siz / _BLOCKED_foil)은 적재 대상 아님 — 입력 제외.
#
#   출력 (FK 위상정렬 번호):
#     00_resync_sequence.sql   (comp_price_id IDENTITY 시퀀스 재동기화 — 모든 INSERT 전)
#     01_t_prc_price_formulas.sql
#     02_t_prc_price_components.sql
#     03_t_prc_formula_components.sql
#     04_t_prc_component_prices.sql
#     05_t_prd_product_price_formulas.sql
#     migrate.provenance.csv   (per-row 출처)
#
#   [수정 2026-06-07 — 라이브 DRY-RUN 적발 결함] comp_price_id 시퀀스 stale.
#     라이브 확증: t_prc_component_prices.comp_price_id = IDENTITY(BY DEFAULT),
#     시퀀스 public.t_prc_component_prices_comp_price_id_seq 가 last_value=2(stale)인데
#     MAX(comp_price_id)=4805·count=3292 (2026-06-06 적재가 명시 ID 로 넣고 시퀀스 미전진).
#     → 04 가 comp_price_id 생략(auto-IDENTITY)이라 올바르나, 시퀀스가 1,2,…를 발급해
#       기존 행과 PK 충돌. 따라서 step 00 setval 로 시퀀스를 MAX 로 재동기화한 뒤 INSERT.
#     setval 후 04 의 49행은 4806~ 발급 → 충돌 0. setval 은 idempotent(재실행 harmless).
#
#   멱등 전략 (라이브 read-only 제약 확인 기반):
#     - 01/02/03/05: PK = 자연키 → ON CONFLICT (PK) DO NOTHING.
#       (라이브 확인: pk_t_prc_price_formulas=frm_cd · pk_t_prc_price_components=comp_cd
#        · t_prc_formula_components_pkey=(frm_cd,comp_cd) · t_prd_product_price_formulas_pkey=(prd_cd,frm_cd))
#     - 04 용지비: 자연키 UNIQUE ux_t_prc_comp_prices_nat_key(8) 가 NULLS DISTINCT
#       (indnullsnotdistinct=f, 라이브 확인). 용지비는 clr_cd/coat_side_cnt/bdl_qty/min_qty=NULL
#       → ON CONFLICT 가 NULL 포함 행에 안 걸려 재실행 시 중복 INSERT 위험.
#       따라서 ON CONFLICT 대신 INSERT … SELECT … WHERE NOT EXISTS(자연키 IS NOT DISTINCT FROM 매칭)
#       멱등 가드 사용. (sql-idempotent-patterns 변형 C, 라이브 제약 근거)
#     - reg_dt/upd_dt: 라이브 reg_dt NOT NULL DEFAULT now() · upd_dt NULL.
#       INSERT 컬럼 목록에서 omit → reg_dt DEFAULT now() 발화 (round-5 함정 회피:
#       명시 NULL 은 DEFAULT 미발화이므로 컬럼 자체를 안 쓴다).
#
#   비밀값 미접근 (CSV→SQL 변환만, DB 연결 없음).
# =====================================================================
import csv
import os
import sys

SRC = "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/02_mapping/digital-print-engine"
OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/09_load/_exec_dgp"

PROV_ROWS = []  # (sql_file, sql_block_no, source_csv, source_row_no, natural_key)


def q(val):
    """SQL 문자열 리터럴 — None/'' → NULL, 그 외 작은따옴표 이스케이프."""
    if val is None:
        return "NULL"
    s = str(val).strip()
    if s == "":
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


def qnum(val):
    """numeric/integer 리터럴 — 빈값 → NULL, 그 외 raw (따옴표 없음)."""
    if val is None:
        return "NULL"
    s = str(val).strip()
    if s == "":
        return "NULL"
    return s


def read_csv(name):
    path = os.path.join(SRC, name)
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


# ---------------------------------------------------------------------
# 00 comp_price_id IDENTITY 시퀀스 재동기화 (모든 INSERT 전)
#   라이브 DRY-RUN 적발: 시퀀스 stale(last_value=2) vs MAX(comp_price_id)=4805.
#   auto-IDENTITY INSERT 가 1,2,…를 발급해 충돌 → setval 로 시퀀스를 MAX 로 전진.
#   is_called=true → 다음 nextval = MAX+1 = 4806부터. 빈 테이블(MAX=NULL) 대비 COALESCE.
#   setval 은 idempotent — 재실행해도 시퀀스를 동일 MAX 로 재설정(harmless).
# ---------------------------------------------------------------------
def gen_resync_sequence():
    lines = [
        "-- 00_resync_sequence.sql  — comp_price_id IDENTITY 시퀀스 재동기화 (모든 INSERT 전)",
        "-- 라이브 DRY-RUN 적발 결함: 시퀀스 stale(last_value=2) vs MAX(comp_price_id)=4805.",
        "--   2026-06-06 적재가 명시 ID 로 넣고 시퀀스를 전진시키지 않아 auto-IDENTITY 가 1,2,…발급→충돌.",
        "-- setval 로 시퀀스를 현재 MAX 로 동기화 → 04 의 auto-IDENTITY 49행은 4806~ 발급(충돌 0).",
        "-- COALESCE(MAX,0): 빈 테이블 대비. true: is_called=true → 다음 nextval=MAX+1.",
        "-- idempotent: 재실행해도 동일 MAX 로 재설정(harmless). DDL 아님(시퀀스 값 조정).",
        "SELECT setval('public.t_prc_component_prices_comp_price_id_seq',",
        "              (SELECT COALESCE(MAX(comp_price_id), 0) FROM t_prc_component_prices), true);",
        "",
    ]
    write("00_resync_sequence.sql", lines)
    # provenance: 시퀀스 재동기화는 CSV 출처 없음 — 라이브 진단 근거
    PROV_ROWS.append(("00_resync_sequence.sql", 1,
                      "(live diagnosis: comp_price_id seq stale)", 0,
                      "setval t_prc_component_prices_comp_price_id_seq"))


# ---------------------------------------------------------------------
# 01 t_prc_price_formulas  (6행, PK frm_cd → ON CONFLICT (frm_cd) DO NOTHING)
# ---------------------------------------------------------------------
def gen_formulas():
    rows = read_csv("t_prc_price_formulas_DGP.csv")
    assert len(rows) == 6, f"price_formulas expected 6, got {len(rows)}"
    lines = [
        "-- 01_t_prc_price_formulas.sql  — DGP 공식 헤더 6행 (신규 mint frm_cd)",
        "-- 멱등: PK frm_cd → ON CONFLICT (frm_cd) DO NOTHING",
        "-- reg_dt/upd_dt omit → reg_dt DEFAULT now() 발화. 트랜잭션은 apply.sql 이 감쌈.",
        "",
    ]
    for i, r in enumerate(rows, 1):
        vals = ", ".join([
            q(r["frm_cd"]), q(r["frm_nm"]), q(r["frm_typ_cd"]),
            q(r["note"]), q(r["use_yn"]),
        ])
        lines.append(f"-- src: t_prc_price_formulas_DGP.csv:{i+1}  key={r['frm_cd']}")
        lines.append(
            "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)\n"
            f"VALUES ({vals})\n"
            "ON CONFLICT (frm_cd) DO NOTHING;"
        )
        lines.append("")
        PROV_ROWS.append(("01_t_prc_price_formulas.sql", i,
                          "t_prc_price_formulas_DGP.csv", i + 1, r["frm_cd"]))
    write("01_t_prc_price_formulas.sql", lines)
    return len(rows)


# ---------------------------------------------------------------------
# 02 t_prc_price_components  (1행 COMP_PAPER, PK comp_cd → ON CONFLICT (comp_cd))
# ---------------------------------------------------------------------
def gen_components():
    rows = read_csv("t_prc_price_components_PAPER.csv")
    assert len(rows) == 1, f"price_components expected 1, got {len(rows)}"
    lines = [
        "-- 02_t_prc_price_components.sql  — 신규 component COMP_PAPER (용지비) 1행",
        "-- 멱등: PK comp_cd → ON CONFLICT (comp_cd) DO NOTHING",
        "-- comp_typ_cd=PRC_COMPONENT_TYPE.03 (용지비). reg_dt/upd_dt omit.",
        "",
    ]
    for i, r in enumerate(rows, 1):
        vals = ", ".join([
            q(r["comp_cd"]), q(r["comp_nm"]), q(r["comp_typ_cd"]),
            q(r["note"]), q(r["use_yn"]),
        ])
        lines.append(f"-- src: t_prc_price_components_PAPER.csv:{i+1}  key={r['comp_cd']}")
        lines.append(
            "INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)\n"
            f"VALUES ({vals})\n"
            "ON CONFLICT (comp_cd) DO NOTHING;"
        )
        lines.append("")
        PROV_ROWS.append(("02_t_prc_price_components.sql", i,
                          "t_prc_price_components_PAPER.csv", i + 1, r["comp_cd"]))
    write("02_t_prc_price_components.sql", lines)
    return len(rows)


# ---------------------------------------------------------------------
# 03 t_prc_formula_components  (72행, PK (frm_cd,comp_cd) → ON CONFLICT)
# ---------------------------------------------------------------------
def gen_formula_components():
    rows = read_csv("t_prc_formula_components_DGP.csv")
    assert len(rows) == 72, f"formula_components expected 72, got {len(rows)}"
    lines = [
        "-- 03_t_prc_formula_components.sql  — 공식↔구성요소 배선 72행",
        "-- 멱등: PK (frm_cd, comp_cd) → ON CONFLICT (frm_cd, comp_cd) DO NOTHING",
        "-- FK: frm_cd→01(PRF_DGP_*), comp_cd→재사용 35 + COMP_PAPER(02). reg_dt omit.",
        "",
    ]
    for i, r in enumerate(rows, 1):
        vals = ", ".join([
            q(r["frm_cd"]), q(r["comp_cd"]),
            qnum(r["disp_seq"]), q(r["addtn_yn"]),
        ])
        key = f"{r['frm_cd']}|{r['comp_cd']}"
        lines.append(
            "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)\n"
            f"VALUES ({vals})\n"
            "ON CONFLICT (frm_cd, comp_cd) DO NOTHING;"
        )
        PROV_ROWS.append(("03_t_prc_formula_components.sql", i,
                          "t_prc_formula_components_DGP.csv", i + 1, key))
    write("03_t_prc_formula_components.sql", lines)
    return len(rows)


# ---------------------------------------------------------------------
# 04 t_prc_component_prices  (49행 용지비)
#   자연키 UNIQUE 8 = NULLS DISTINCT (라이브 확인) + 용지비는 4개 차원 NULL
#   → ON CONFLICT 무력 → INSERT … SELECT … WHERE NOT EXISTS(IS NOT DISTINCT FROM) 가드
# ---------------------------------------------------------------------
NATKEY_COLS = ["comp_cd", "apply_ymd", "siz_cd", "clr_cd", "mat_cd",
               "coat_side_cnt", "bdl_qty", "min_qty"]


def gen_component_prices():
    rows = read_csv("t_prc_component_prices_PAPER.csv")
    assert len(rows) == 49, f"component_prices expected 49, got {len(rows)}"
    lines = [
        "-- 04_t_prc_component_prices.sql  — 용지비 49행 (COMP_PAPER × 국4절 SIZ_000499 × 49 종이 mat_cd)",
        "-- !! 멱등 가드 = INSERT … SELECT … WHERE NOT EXISTS (자연키 IS NOT DISTINCT FROM 매칭) !!",
        "--   사유: 자연키 UNIQUE ux_t_prc_comp_prices_nat_key(8) 가 NULLS DISTINCT",
        "--   (indnullsnotdistinct=f, 라이브 read-only 확인). 용지비는 clr_cd/coat_side_cnt/",
        "--   bdl_qty/min_qty = NULL → ON CONFLICT 가 NULL 포함 행에 안 걸려 재실행 시 중복 INSERT.",
        "--   IS NOT DISTINCT FROM 은 NULL=NULL 을 TRUE 로 매칭 → 재실행 0행 (R1 멱등 보장).",
        "-- comp_price_id = surrogate PK(생략, 자동). reg_dt omit(DEFAULT now()). siz_cd=SIZ_000499 고정.",
        "",
    ]
    for i, r in enumerate(rows, 1):
        comp_cd = q(r["comp_cd"])
        apply_ymd = q(r["apply_ymd"])
        siz_cd = q(r["siz_cd"])
        clr_cd = q(r["clr_cd"])           # 빈 → NULL
        mat_cd = q(r["mat_cd"])
        coat = qnum(r["coat_side_cnt"])    # 빈 → NULL
        bdl = qnum(r["bdl_qty"])           # 빈 → NULL
        minq = qnum(r["min_qty"])          # 빈 → NULL
        price = qnum(r["unit_price"])
        note = q(r["note"])

        # WHERE NOT EXISTS 의 자연키 매칭 — IS NOT DISTINCT FROM (NULL-safe equality)
        where_match = (
            f"comp_cd IS NOT DISTINCT FROM {comp_cd}"
            f" AND apply_ymd IS NOT DISTINCT FROM {apply_ymd}"
            f" AND siz_cd IS NOT DISTINCT FROM {siz_cd}"
            f" AND clr_cd IS NOT DISTINCT FROM {clr_cd}"
            f" AND mat_cd IS NOT DISTINCT FROM {mat_cd}"
            f" AND coat_side_cnt IS NOT DISTINCT FROM {coat}"
            f" AND bdl_qty IS NOT DISTINCT FROM {bdl}"
            f" AND min_qty IS NOT DISTINCT FROM {minq}"
        )
        sel_vals = (
            f"{comp_cd}, {apply_ymd}, {siz_cd}, {clr_cd}, {mat_cd}, "
            f"{coat}, {bdl}, {minq}, {price}, {note}"
        )
        lines.append(f"-- src: t_prc_component_prices_PAPER.csv:{i+1}  mat_cd={r['mat_cd']}")
        lines.append(
            "INSERT INTO t_prc_component_prices\n"
            "  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)\n"
            f"SELECT {sel_vals}\n"
            "WHERE NOT EXISTS (\n"
            "  SELECT 1 FROM t_prc_component_prices\n"
            f"  WHERE {where_match}\n"
            ");"
        )
        lines.append("")
        key = f"COMP_PAPER|2026-06-01|SIZ_000499|{r['mat_cd']}"
        PROV_ROWS.append(("04_t_prc_component_prices.sql", i,
                          "t_prc_component_prices_PAPER.csv", i + 1, key))
    write("04_t_prc_component_prices.sql", lines)
    return len(rows)


# ---------------------------------------------------------------------
# 05 t_prd_product_price_formulas  (19행, PK (prd_cd,frm_cd) → ON CONFLICT)
# ---------------------------------------------------------------------
def gen_product_price_formulas():
    rows = read_csv("t_prd_product_price_formulas_DGP.csv")
    assert len(rows) == 19, f"product_price_formulas expected 19, got {len(rows)}"
    lines = [
        "-- 05_t_prd_product_price_formulas.sql  — 상품↔공식 바인딩 19행 (049 제외 = D-5 BLOCKED)",
        "-- 멱등: PK (prd_cd, frm_cd) → ON CONFLICT (prd_cd, frm_cd) DO NOTHING",
        "-- FK: prd_cd→t_prd_products(19 선존재), frm_cd→01(PRF_DGP_*). apply_bgn_ymd 메모. reg_dt omit.",
        "",
    ]
    for i, r in enumerate(rows, 1):
        vals = ", ".join([
            q(r["prd_cd"]), q(r["frm_cd"]),
            q(r["apply_bgn_ymd"]), q(r["note"]),
        ])
        key = f"{r['prd_cd']}|{r['frm_cd']}"
        lines.append(f"-- src: t_prd_product_price_formulas_DGP.csv:{i+1}  key={key}")
        lines.append(
            "INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)\n"
            f"VALUES ({vals})\n"
            "ON CONFLICT (prd_cd, frm_cd) DO NOTHING;"
        )
        lines.append("")
        PROV_ROWS.append(("05_t_prd_product_price_formulas.sql", i,
                          "t_prd_product_price_formulas_DGP.csv", i + 1, key))
    write("05_t_prd_product_price_formulas.sql", lines)
    return len(rows)


def write(fname, lines):
    path = os.path.join(OUT, fname)
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines).rstrip() + "\n")


def write_provenance():
    path = os.path.join(OUT, "migrate.provenance.csv")
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["sql_file", "sql_block_no", "source_csv", "source_row_no", "natural_key"])
        w.writerows(PROV_ROWS)


def main():
    gen_resync_sequence()        # 00: comp_price_id 시퀀스 재동기화 (INSERT 전)
    n1 = gen_formulas()
    n2 = gen_components()
    n3 = gen_formula_components()
    n4 = gen_component_prices()
    n5 = gen_product_price_formulas()
    write_provenance()
    total = n1 + n2 + n3 + n4 + n5
    print("[gen] 00 resync_sequence        = setval (comp_price_id seq → MAX)")
    print(f"[gen] 01 price_formulas        = {n1}")
    print(f"[gen] 02 price_components       = {n2}")
    print(f"[gen] 03 formula_components     = {n3}")
    print(f"[gen] 04 component_prices(용지비)= {n4}")
    print(f"[gen] 05 product_price_formulas = {n5}")
    print(f"[gen] total LOADABLE rows       = {total}  (expect 147)")
    print(f"[gen] provenance rows           = {len(PROV_ROWS)}")
    assert total == 147, f"total expected 147, got {total}"
    print("[gen] OK — 멱등 SQL 5종 + migrate.provenance.csv 생성 완료")


if __name__ == "__main__":
    main()
