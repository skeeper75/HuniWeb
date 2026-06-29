#!/usr/bin/env python3
"""
build_load — 결함보드 → 권위 verbatim 교정 적재본 SQL + dryrun(BEGIN…ROLLBACK).

[HARD]
 - 단가 verbatim: 권위 단가 그대로 UPSERT/UPDATE. 계산/배수/blind swap 금지.
 - 자동 생성 SQL 은 생성측 산출물일 뿐 — 게이트 골든 시뮬 + codex 교차 + 인간 승인 후에만 COMMIT.
 - dryrun 은 BEGIN…ROLLBACK 로만(실 COMMIT 없음).

결함유형별 SQL 전략:
 - mismatch     → UPDATE unit_price = 권위값 WHERE comp_price_id=<repro id>. (verbatim)
 - missing_cell → INSERT 단일 셀(도수축이 살아있는 경우만·sparse fill).
 - transpose    → BLOCKED(verbatim 재적재 설계 필요·blind swap 금지) → 주석 escalation.
 - prc_typ_typo → UPDATE prc_typ_cd. (값 불변)
 - dim_missing  → BLOCKED(차원 축 신설/공식 재설계 = search-before-mint·인간 결정) → escalation 주석.
                  자동 INSERT 금지(엔진이 도수 구분 못하면 셀만 넣어도 collision/오청구).
"""
import csv
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
from matrix_parse import parse_l1  # noqa: E402

HEADER = """-- ============================================================
-- 가격테이블 무결성 교정 적재본 (생성측 산출물 · 결정론 배치)
-- [HARD] 인간 승인 전 COMMIT 금지. 게이트(골든 시뮬)+codex 스냅샷 교차 후 dbmap COMMIT.
-- 권위=인쇄상품 가격표 260527(절대). 단가 verbatim. 라이브 읽기전용·스냅샷 기준.
-- 생성: build_load.py (결정론·재실행 가능)
-- ============================================================
"""


def build(defects_csv, l1_csv, out_sql, out_dryrun):
    with open(defects_csv, encoding="utf-8-sig") as f:
        defects = list(csv.DictReader(f))
    auth = parse_l1(l1_csv, "digital-print")
    auth_by_key = {(c["plt_grade"], c["clr"], c["side"], c["min_qty"]): c for c in auth}

    apply_stmts = []   # 실 적용(UPDATE/INSERT) — verbatim
    blocked = []       # 설계 결정 필요(escalation)

    for d in defects:
        dt = d["defect"]
        if dt == "mismatch":
            # repro: "comp_price_id=NNN unit_price A→B"
            import re
            m = re.search(r"comp_price_id=(\d+)", d["repro"])
            key = tuple(_parse_key(d["key"]))
            c = auth_by_key.get(key)
            if m and c:
                apply_stmts.append(
                    f"UPDATE t_prc_component_prices SET unit_price = {c['unit_price']}"
                    f"  -- 권위 verbatim ({'/'.join(map(str,key))})\n"
                    f"  WHERE comp_price_id = {m.group(1)};")
        elif dt == "prc_typ_typo":
            import re
            m = re.search(r"comp_price_id=(\d+)", d["repro"])
            if m:
                apply_stmts.append(
                    f"UPDATE t_prc_component_prices SET prc_typ_cd = 'PRICE_TYPE.02'"
                    f"  -- {d['key']} 밴드/세트 합가형\n"
                    f"  WHERE comp_price_id = {m.group(1)};")
        elif dt == "missing_axis_cells":
            # comp 존재·단가행 0 = verbatim sparse fill 가능. 시트별 전용 빌더 위임.
            # (코팅 유광은 build_coating_glossy_load 가 INSERT 생성)
            apply_stmts.append(
                f"-- missing_axis_cells {d['key']}: {d['auth_value']} verbatim sparse fill\n"
                f"--   → 시트 전용 빌더(build_coating_glossy_load 등)가 INSERT 생성. "
                f"comp 존재(단가행 0)이므로 차원 설계 불요.")
        elif dt == "missing_cell":
            apply_stmts.append(
                f"-- missing_cell {d['key']}: 권위 단가 {d['auth_value']} "
                f"(sparse fill 단일 셀 INSERT — 대상 comp_cd/차원코드 확정 후 적재)")
        elif dt in ("dim_missing", "transpose"):
            blocked.append(
                f"-- [BLOCKED · 설계 결정 필요] {dt} {d['key']}\n"
                f"--   권위: {d['auth_value']} | 라이브: {d['live_value']}\n"
                f"--   돈영향: {d['money_impact']}\n"
                f"--   사유: 차원 축 신설/공식 재설계는 search-before-mint·인간 결정 "
                f"(blind insert/swap 금지). dbmap/§18 라우팅.")

    # apply SQL
    with open(out_sql, "w", encoding="utf-8") as f:
        f.write(HEADER)
        if apply_stmts:
            f.write("\n-- 실 적용(verbatim UPSERT/UPDATE) — 인간 승인 후 COMMIT\n")
            f.write("BEGIN;\n")
            f.write("\n".join(apply_stmts))
            f.write("\nCOMMIT;  -- [HARD] 게이트+codex+인간 승인 전 실행 금지\n")
        else:
            f.write("\n-- verbatim 적용 대상 0건(값 불일치/오타이핑 없음).\n")
        if blocked:
            f.write("\n-- ── 설계 결정 필요(BLOCKED·자동 적재 금지) ──\n")
            f.write("\n".join(blocked) + "\n")

    # dryrun SQL (BEGIN…ROLLBACK)
    with open(out_dryrun, "w", encoding="utf-8") as f:
        f.write(HEADER)
        f.write("\n-- DRY-RUN: BEGIN…ROLLBACK (실 변경 없음·적재 가능성 실증용)\n")
        f.write("BEGIN;\n")
        if apply_stmts:
            f.write("\n".join(apply_stmts) + "\n")
        else:
            f.write("-- 적용 대상 0건\n")
        f.write("ROLLBACK;  -- 항상 롤백\n")
        if blocked:
            f.write("\n-- BLOCKED(설계 결정 필요):\n" + "\n".join(blocked) + "\n")

    return {"apply_count": len(apply_stmts), "blocked_count": len(blocked)}


def _parse_key(key):
    parts = key.split("/")
    parts[-1] = int(parts[-1])
    return parts


# ─────────────────────────────────────────────────────────────────────
# 코팅 유광(COMP_COAT_GLOSSY) verbatim sparse-fill INSERT 생성.
# 권위 격자 유광 셀(국4절/3절 × 단면/양면 × 수량) → 무광 인코딩과 동형 INSERT.
#   plt_siz_cd: 국4절=SIZ_000499 / 3절=SIZ_000077
#   coat_side_cnt: 단면=1 / 양면=2
#   proc_cd/proc_grp 는 무광 활성 행과 동일 값 사용(스냅샷에서 확정).
# [HARD] 단가 verbatim. 인간 승인 전 COMMIT 금지.
# ─────────────────────────────────────────────────────────────────────
COAT_PLT = {"국4절": "SIZ_000499", "3절": "SIZ_000077"}
COAT_SIDE = {"단면": "1", "양면": "2"}


def build_coating_glossy_load(l1_csv, snap_dir, out_sql, out_dry):
    auth = parse_l1(l1_csv, "coating")
    glossy = [c for c in auth if c["clr"] == "유광"]
    # 무광 활성 행에서 proc_cd/proc_grp/apply_ymd 모범값 추출(동형 인코딩)
    import csv as _csv
    with open(os.path.join(snap_dir, "t_prc_component_prices.csv"), encoding="utf-8-sig") as f:
        cp = list(_csv.DictReader(f))
    matte = [r for r in cp if r["comp_cd"] == "COMP_COAT_MATTE"]
    apply_ymd = matte[0]["apply_ymd"] if matte else "2026-06-01"
    # [HARD] 유광은 자기 도수코드를 써야 함(무광 proc_cd 복사 금지).
    #   PROC_000014=유광 · PROC_000015=무광 (t_proc_processes). 결정론 lookup.
    with open(os.path.join(snap_dir, "t_proc_processes.csv"), encoding="utf-8-sig") as f:
        procs = list(_csv.DictReader(f))
    proc_cd = next((p["proc_cd"] for p in procs
                    if p.get("proc_nm") == "유광" and p.get("del_yn") == "N"), "")
    assert proc_cd, "유광 proc_cd 미발견 — 매핑미상(사람 확인)"

    inserts = []
    for c in glossy:
        plt = COAT_PLT.get(c["plt_grade"], "")
        side = COAT_SIDE.get(c["side"], "")
        note = f"코팅({c['plt_grade']})/유광코팅/{c['side']} 출력매수 {c['min_qty']}장 이상"
        inserts.append(
            "INSERT INTO t_prc_component_prices "
            "(comp_cd, apply_ymd, min_qty, unit_price, note, proc_cd, coat_side_cnt, plt_siz_cd, reg_dt) "
            f"VALUES ('COMP_COAT_GLOSSY', '{apply_ymd}', {c['min_qty']}, {c['unit_price']}, "
            f"'{note}', '{proc_cd}', {side}, '{plt}', now())\n"
            "  ON CONFLICT DO NOTHING;  -- 멱등")
    head = HEADER + ("\n-- 코팅 유광(COMP_COAT_GLOSSY) verbatim sparse fill "
                     f"({len(inserts)}행) — comp 존재·단가행 0\n")
    with open(out_sql, "w", encoding="utf-8") as f:
        f.write(head + "BEGIN;\n" + "\n".join(inserts) +
                "\nCOMMIT;  -- [HARD] 게이트+codex+인간 승인 전 실행 금지\n")
    with open(out_dry, "w", encoding="utf-8") as f:
        f.write(head + "-- DRY-RUN: BEGIN…ROLLBACK\nBEGIN;\n" + "\n".join(inserts) +
                "\nROLLBACK;  -- 항상 롤백\n")
    return {"insert_count": len(inserts)}


if __name__ == "__main__":
    base = os.path.abspath(os.path.join(HERE, ".."))
    defects = sys.argv[1] if len(sys.argv) > 1 else os.path.join(base, "digital-print-defects.csv")
    l1 = os.path.abspath(os.path.join(HERE, "..", "..", "..", "huni-dbmap",
                                      "06_extract", "price-digital-print-price-l1.csv"))
    out_sql = os.path.join(base, "digital-print-load.sql")
    out_dry = os.path.join(base, "digital-print-load-dryrun.sql")
    r = build(defects, l1, out_sql, out_dry)
    print(json.dumps(r, ensure_ascii=False))
    print(f"적재본 → {out_sql}\ndryrun → {out_dry}")
