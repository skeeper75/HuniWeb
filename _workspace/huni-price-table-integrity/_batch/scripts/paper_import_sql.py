#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
paper_import_match.py 의 매칭 결과 → COMP_PAPER 절가 적재본 SQL 생성.

산출:
  paper-import-load.sql         — ① (이번엔 mint 0) ② COMP_PAPER 절가행 멱등 INSERT (BEGIN…COMMIT 자리)
  paper-import-load-dryrun.sql  — 동일 + 마지막 ROLLBACK (적재 가능성 실증·DB 미반영)

[HARD]
  - 권위 절가 verbatim (반올림·계산 금지). 권위 가격(국4절/3절) 값 그대로 INSERT.
  - 멱등 = NULL-safe NOT EXISTS 가드 (ON CONFLICT NULLS DISTINCT 함정 회피).
    기적재 60행과 충돌하는 (comp_cd,apply_ymd,mat_cd,plt_siz_cd)는 INSERT 안 됨.
  - 기초마스터 코드 삭제·이름변경 금지(이번 실행 mint 0이므로 mat INSERT 없음).
  - 인간 승인 전 COMMIT 금지.
"""
import paper_import_match as M

OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-price-table-integrity/_batch"
APPLY_YMD = "2026-06-01"
COMP = "COMP_PAPER"
PLT_G4 = "SIZ_000499"  # 국4절 (316x467)
PLT_G3 = "SIZ_000077"  # 3절   (300x625)

NOTE_T = ("용지비 {name} {label}({sizetxt}) 절가 — 실제 청구는 출력매수만큼 자동 계산")
SIZETXT = {PLT_G4: "316x467", PLT_G3: "300x625"}
LABEL = {PLT_G4: "국4절", PLT_G3: "3절"}


def sql_str(s):
    return "'" + str(s).replace("'", "''") + "'"


def insert_stmt(mat_cd, plt, price, name):
    """라이브 60행 컬럼 패턴 미러 + NULL-safe NOT EXISTS 멱등 가드."""
    note = NOTE_T.format(name=name, label=LABEL[plt], sizetxt=SIZETXT[plt])
    return (
        "INSERT INTO t_prc_component_prices "
        "(comp_cd, apply_ymd, mat_cd, min_qty, unit_price, note, plt_siz_cd, reg_dt)\n"
        f"SELECT {sql_str(COMP)}, {sql_str(APPLY_YMD)}, {sql_str(mat_cd)}, 1, {price}, "
        f"{sql_str(note)}, {sql_str(plt)}, now()\n"
        "WHERE NOT EXISTS (\n"
        "  SELECT 1 FROM t_prc_component_prices\n"
        f"  WHERE comp_cd = {sql_str(COMP)} AND apply_ymd = {sql_str(APPLY_YMD)}\n"
        f"    AND mat_cd = {sql_str(mat_cd)} AND plt_siz_cd = {sql_str(plt)}\n"
        ");"
    )


HEADER = """-- ============================================================
-- 출력소재(IMPORT) 용지 절가 → COMP_PAPER 단가행 적재본 (생성측 산출물)
-- [HARD] 인간 승인 전 COMMIT 금지. 게이트 + 검토 후 dbmap COMMIT.
-- 권위 = 인쇄상품 가격표 출력소재(IMPORT) 시트 (절대). 가격(국4절/3절) 절가 verbatim.
-- 멱등 = NULL-safe NOT EXISTS 가드 (기적재 60행 미터치).
-- search-before-mint = 전 용지 기존 mat_cd 매칭(mint 0). 라이브 읽기전용 스냅샷 기준.
-- 생성: paper_import_match.py + paper_import_sql.py (결정론·재실행 가능)
-- 컬럼 = 라이브 COMP_PAPER 60행 패턴 미러 (comp_cd,apply_ymd,mat_cd,min_qty,unit_price,note,plt_siz_cd,reg_dt)
-- ============================================================
"""


def build(res):
    lines = [HEADER, "BEGIN;", ""]
    n_g4 = n_g3 = 0

    lines.append("-- ① 신규 mat_cd: 없음 (search-before-mint 전건 기존 자재 매칭)\n")

    lines.append("-- ② COMP_PAPER 국4절(SIZ_000499) 절가 verbatim INSERT")
    for r in res["cp_g4"]:
        lines.append(insert_stmt(r["mat_cd"], PLT_G4, r["price"], r["name"]))
        lines.append("")
        n_g4 += 1

    lines.append("-- ③ COMP_PAPER 3절(SIZ_000077) 절가 verbatim INSERT")
    lines.append("--    ★confirm-3절: 라이브 3절 단가행 선례 0 — 전용 '(3절)' 자재 + plt_siz_cd=SIZ_000077(300x625) 추론.")
    lines.append("--    사람이 plt_siz_cd / 자재 선택 확인 후 COMMIT.")
    for r in res["cp_g3"]:
        lines.append(insert_stmt(r["mat_cd"], PLT_G3, r["price"], r["name"]))
        lines.append("")
        n_g3 += 1

    lines.append(f"-- 적재 대상: 국4절 {n_g4}행 + 3절 {n_g3}행 = {n_g4 + n_g3}행 (verbatim·멱등)")
    body = "\n".join(lines)

    with open(f"{OUT}/paper-import-load.sql", "w", encoding="utf-8") as f:
        f.write(body + "\n\nCOMMIT;  -- ★인간 승인 후에만. dbmap COMMIT 트랙.\n")
    with open(f"{OUT}/paper-import-load-dryrun.sql", "w", encoding="utf-8") as f:
        f.write(body + "\n\nROLLBACK;  -- DRY-RUN: 적재 가능성·멱등 실증, DB 미반영.\n")

    print(f"SQL 생성 완료: 국4절 {n_g4} + 3절 {n_g3} = {n_g4 + n_g3} INSERT")
    return n_g4, n_g3


if __name__ == "__main__":
    res = M.main()
    build(res)
