#!/usr/bin/env python3
# gen_load_sql.py — RC-2 일반현수막 가공/추가 옵션 바인딩 멱등 적재 SQL 생성기
# 입력: mapping.csv (이 디렉토리). 출력: 01~03_*.sql + apply.sql (재현성·손편집 금지).
# 권위: rc2-silsa-addon-binding-design.md + 라이브 실측(2026-06-23). 단가 verbatim·DB 미적재.
# 멱등성: use_dims/opt_cd UPDATE는 IS DISTINCT FROM 가드(2회차 0행). formula_components는 PK UPSERT.
import csv, os

HERE = os.path.dirname(os.path.abspath(__file__))
FRM = "PRF_POSTER_BANNER_N"

# ── 1. use_dims 충전 (price_components UPDATE·멱등) ────────────────────────────
USE_DIMS = [
    # (comp_cd, new_use_dims_json)
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE",  '["opt_cd", "opt_grp:OPT_000003"]'),
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE",    '["opt_cd", "opt_grp:OPT_000003"]'),
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW",  '["opt_cd", "opt_grp:OPT_000003"]'),
    ("COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4",   '["opt_cd", "opt_grp:OPT_000004"]'),
    ("COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4",  '["opt_cd", "opt_grp:OPT_000004"]'),
]

# ── 2. 단가행 판별값(opt_cd) 충전 (component_prices UPDATE·단가 불변·멱등) ────────
#    comp_price_id = 라이브 실측 surrogate PK. 단가는 WHERE에 검증값으로만 사용(미변경).
OPT_FILL = [
    # (comp_price_id, comp_cd, opt_cd, verbatim_unit_price)
    (4692, "COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE",  "OPV_000006", "3000.00"),
    (4699, "COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE",    "OPV_000010", "3000.00"),
    (4701, "COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW",  "OPV_000011", "4000.00"),
    (4694, "COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4",   "OPV_000013", "3000.00"),
    (4696, "COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4",  "OPV_000014", "4000.00"),
]

# ── 3. 공식 바인딩 (formula_components UPSERT·PK=(frm_cd,comp_cd)) ────────────────
BIND = [
    # (comp_cd, addtn_yn, disp_seq) — PUNCH_4는 기존행 addtn_yn/disp_seq 충전, 나머지 신규
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4",  "Y", 2),
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE",  "Y", 3),
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE",    "Y", 4),
    ("COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW",  "Y", 5),
    ("COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4",   "Y", 6),
    ("COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4",  "Y", 7),
]


def w(path, lines):
    with open(os.path.join(HERE, path), "w") as f:
        f.write("\n".join(lines) + "\n")


def gen_use_dims():
    L = ["-- 01_use_dims.sql — RC-2 일반현수막 옵션 comp use_dims 판별차원 충전 (멱등 UPDATE)",
         "-- 빈 [] / 오설정 opt_grp → opt_cd+opt_grp 판별차원. IS DISTINCT FROM 가드(2회차 0행).", ""]
    for comp, dims in USE_DIMS:
        L += [f"-- src: mapping.csv use_dims · {comp}",
              f"UPDATE t_prc_price_components",
              f"   SET use_dims = '{dims}'::jsonb, upd_dt = now()",
              f" WHERE comp_cd = '{comp}'",
              f"   AND use_dims IS DISTINCT FROM '{dims}'::jsonb;", ""]
    w("01_use_dims.sql", L)


def gen_opt_fill():
    L = ["-- 02_opt_fill.sql — RC-2 단가행 opt_cd 판별값 충전 (멱등 UPDATE·단가 verbatim 불변)",
         "-- comp_price_id=라이브 PK. unit_price는 WHERE 검증값으로만(미변경). opt_cd만 채움.", ""]
    for cpid, comp, opt, price in OPT_FILL:
        L += [f"-- src: mapping.csv opt_fill · {comp} (price {price} 불변)",
              f"UPDATE t_prc_component_prices",
              f"   SET opt_cd = '{opt}', upd_dt = now()",
              f" WHERE comp_price_id = {cpid}",
              f"   AND comp_cd = '{comp}'",
              f"   AND unit_price = {price}            -- verbatim 단가 검증(불일치 시 0행=가드)",
              f"   AND opt_cd IS DISTINCT FROM '{opt}';", ""]
    w("02_opt_fill.sql", L)


def gen_bind():
    L = ["-- 03_formula_components.sql — RC-2 공식 바인딩 (멱등 UPSERT·PK=(frm_cd,comp_cd))",
         f"-- 대상공식 {FRM}. addtn_yn=Y 가산. 기존 PUNCH_4행은 addtn_yn/disp_seq 충전.", ""]
    for comp, addtn, seq in BIND:
        L += [f"-- src: mapping.csv bind · {comp}",
              f"INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)",
              f"VALUES ('{FRM}', '{comp}', {seq}, '{addtn}', now())",
              f"ON CONFLICT (frm_cd, comp_cd) DO UPDATE",
              f"   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()",
              f" WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn",
              f"    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;", ""]
    w("03_formula_components.sql", L)


def gen_apply():
    L = ["-- apply.sql — RC-2 일반현수막 옵션 바인딩 트랜잭션 래퍼 (FK 위상순서)",
         "-- 기본 DRY-RUN: 로더(apply.sh)가 끝에 ROLLBACK 주입. COMMIT은 --commit 인간 승인만.",
         "-- 순서: price_components(use_dims) → component_prices(opt_cd) → formula_components(바인딩)",
         "\\set ON_ERROR_STOP on", "BEGIN;",
         "  \\i 01_use_dims.sql",
         "  \\i 02_opt_fill.sql",
         "  \\i 03_formula_components.sql",
         "-- 기본 ROLLBACK(apply.sh 주입). 실제 적재는 --commit 으로만 COMMIT.", ""]
    w("apply.sql", L)


def gen_provenance():
    rows = [("file", "line_kind", "comp_cd", "key", "value", "source")]
    for comp, dims in USE_DIMS:
        rows.append(("01_use_dims.sql", "use_dims", comp, "use_dims", dims, "rc2-design §2 + live"))
    for cpid, comp, opt, price in OPT_FILL:
        rows.append(("02_opt_fill.sql", "opt_fill", comp, f"opt_cd(id={cpid})", f"{opt}·price={price}", "live comp_price_id"))
    for comp, addtn, seq in BIND:
        rows.append(("03_formula_components.sql", "bind", comp, "addtn_yn/disp_seq", f"{addtn}/{seq}", f"{FRM}"))
    with open(os.path.join(HERE, "load.provenance.csv"), "w", newline="") as f:
        csv.writer(f).writerows(rows)


if __name__ == "__main__":
    gen_use_dims()
    gen_opt_fill()
    gen_bind()
    gen_apply()
    gen_provenance()
    print("generated: 01_use_dims.sql 02_opt_fill.sql 03_formula_components.sql apply.sql load.provenance.csv")
