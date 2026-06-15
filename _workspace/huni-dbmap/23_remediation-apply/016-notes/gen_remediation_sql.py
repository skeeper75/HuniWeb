#!/usr/bin/env python3
r"""
gen_remediation_sql.py — 016 프리미엄엽서(PRD_000016) PRF_DGP_A 가격사슬 note 교정 번들 생성기.

산출(재현성·provenance 추적):
  - note-map.csv          : 행별 {table·pk·comp_cd·current_note(라이브 실측 인용)·corrected_note}
  - 01_update_notes.sql   : 멱등 UPDATE (note 컬럼만, IS DISTINCT FROM 가드, upd_dt=now())
  - apply.sql             : 단일 트랜잭션 래퍼 (ON_ERROR_STOP, BEGIN; \i 01_...; — COMMIT/ROLLBACK은 로더 주입)

[HARD] note 컬럼만 변경. unit_price·prc_typ_cd·가격/단가행 절대 불변.
[HARD] 멱등 — 재실행 delta 0 (IS DISTINCT FROM + regexp가 마커없는 텍스트엔 no-op).

라이브는 읽기전용 SELECT로만 접속(현재 note 실측). 비밀번호 stdout 출력 금지.
규칙 권위: 17_correctness/postcard-016-price/note-remediation.md + 토대 §9-1.
"""
import os
import sys
import csv
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=HERE).decode().strip()

# ---- 정의행(29) comp_cd → 쉬운 한국어 라벨 (note-remediation.md 권위 + comp_nm 보강) ----
DEF_LABELS = {
    "COMP_PRINT_DIGITAL_S1": "디지털 인쇄비(단면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.",
    "COMP_PRINT_DIGITAL_S2": "디지털 인쇄비(양면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.",
    "COMP_PRINT_SPOT_WHITE_S1": "별색(화이트) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_WHITE_S2": "별색(화이트) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_CLEAR_S1": "별색(클리어) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_CLEAR_S2": "별색(클리어) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_PINK_S1": "별색(핑크) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_PINK_S2": "별색(핑크) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_GOLD_S1": "별색(금색) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_GOLD_S2": "별색(금색) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_SILVER_S1": "별색(은색) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.",
    "COMP_PRINT_SPOT_SILVER_S2": "별색(은색) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.",
    "COMP_COAT_GLOSSY": "유광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 장당 단가표.",
    "COMP_COAT_MATTE": "무광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 장당 단가표.",
    "COMP_PAPER": "용지비. 선택한 종이·출력규격(국4절/3절)별 절가. 실제 청구는 출력매수만큼 시스템이 자동 계산.",
    "COMP_PP_CREASE_1L": "오시(접는 줄) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_CREASE_2L": "오시(접는 줄) 2줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_CREASE_3L": "오시(접는 줄) 3줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_PERF_1L": "미싱(점선 절취) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_PERF_2L": "미싱(점선 절취) 2줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_PERF_3L": "미싱(점선 절취) 3줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_VARTEXT_1EA": "가변 텍스트 1개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_VARTEXT_2EA": "가변 텍스트 2개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_VARTEXT_3EA": "가변 텍스트 3개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_VARIMG_1EA": "가변 이미지 1개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_VARIMG_2EA": "가변 이미지 2개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_VARIMG_3EA": "가변 이미지 3개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_CORNER_RIGHT": "모서리 직각 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "COMP_PP_CORNER_ROUND": "모서리 둥근 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
}

PAPER_SUFFIX = " — 실제 청구는 출력매수만큼 자동 계산"

import re
# 단가행 변환 단계 (파이썬에서 미리 계산 → note-map.csv 검증용. 실제 라이브 UPDATE는 동일 규칙의 regexp_replace를 SQL이 수행)
RE_SIZ = re.compile(r"^\[siz-corrected:[^\]]*\]\s*")
RE_SPOT = re.compile(r"\s*\(별색=공정,clr=NULL\)\s*$")
RE_HAPGA = re.compile(r"\s*\(합가,\s*comp_typ=\.04\s*후가공비,\s*옵션=comp흡수\)\s*$")
RE_OUT = re.compile(r"출력매수≥([0-9]+)")
RE_ORD = re.compile(r"제작수량≥([0-9]+)")


def transform_price_note(comp_cd, note):
    """단가행 note → 쉬운 한국어 (라이브 SQL의 regexp_replace 체인과 동치)."""
    if comp_cd == "COMP_PAPER":
        if PAPER_SUFFIX.strip() in note:
            return note  # 멱등: 이미 붙어 있으면 그대로
        return note + PAPER_SUFFIX
    s = note
    s = RE_SIZ.sub("", s)
    s = RE_SPOT.sub("", s)
    s = RE_HAPGA.sub(" / 작업 1건 고정 금액", s)
    s = RE_OUT.sub(lambda m: f"출력매수 {m.group(1)}장 이상", s)
    s = RE_ORD.sub(lambda m: f"주문수량 {m.group(1)}건 이상", s)
    return s.strip()


def psql_query(sql):
    """라이브 읽기전용 SELECT. .env.local에서 자격증명 로드, 비밀번호 미출력."""
    env = dict(os.environ)
    # .env.local 파싱 (export 형식)
    with open(os.path.join(REPO, ".env.local")) as f:
        for line in f:
            line = line.strip()
            if line.startswith("RAILWAY_DB_") and "=" in line:
                k, v = line.split("=", 1)
                env[k.strip()] = v.strip().strip('"').strip("'")
    env["PGPASSWORD"] = env["RAILWAY_DB_PASSWORD"]
    cmd = [
        "psql", "-h", env["RAILWAY_DB_HOST"], "-p", env["RAILWAY_DB_PORT"],
        "-U", env["RAILWAY_DB_USER"], "-d", env["RAILWAY_DB_NAME"],
        "-v", "ON_ERROR_STOP=1", "-P", "pager=off", "-tA", "-F", "\t", "-c", sql,
    ]
    out = subprocess.check_output(cmd, env=env).decode()
    return [ln.split("\t") for ln in out.splitlines() if ln]


def sql_lit(s):
    return "'" + s.replace("'", "''") + "'"


def main():
    # 1) 라이브에서 정의행 + 단가행 현재 note 실측
    def_rows = psql_query(
        "SELECT pc.comp_cd, coalesce(pc.note,'') FROM t_prc_price_components pc "
        "WHERE pc.comp_cd IN (SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_A') "
        "ORDER BY pc.comp_cd;"
    )
    price_rows = psql_query(
        "SELECT cp.comp_price_id::text, cp.comp_cd, cp.note FROM t_prc_component_prices cp "
        "WHERE cp.comp_cd IN (SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_A') "
        "AND cp.note IS NOT NULL ORDER BY cp.comp_cd, cp.comp_price_id;"
    )

    # 2) note-map.csv
    mapping = []
    for comp_cd, cur in def_rows:
        new = DEF_LABELS[comp_cd]
        mapping.append(("t_prc_price_components", comp_cd, comp_cd, cur, new))
    for cpid, comp_cd, cur in price_rows:
        new = transform_price_note(comp_cd, cur)
        mapping.append(("t_prc_component_prices", cpid, comp_cd, cur, new))

    with open(os.path.join(HERE, "note-map.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["table", "pk", "comp_cd", "current_note", "corrected_note"])
        for r in mapping:
            w.writerow(r)

    # 3) 01_update_notes.sql — 정의행은 CASE(comp_cd), 단가행은 결정적 regexp 치환(SQL 동치)
    lines = []
    lines.append("-- 01_update_notes.sql — 016 프리미엄엽서 PRF_DGP_A 가격사슬 note 교정 (note 컬럼만)")
    lines.append("-- 생성기: gen_remediation_sql.py (손편집 금지·재현성). 멱등=IS DISTINCT FROM + no-op regexp.")
    lines.append("-- [HARD] unit_price·prc_typ_cd·기타 컬럼 절대 미변경. SET 절은 note·upd_dt 둘뿐.")
    lines.append("")

    # 3a) 정의행 — 행별 UPDATE (comp_cd PK)
    lines.append("-- A) 구성요소 정의행 t_prc_price_components.note (29행, comp_cd PK)")
    for comp_cd in sorted(DEF_LABELS):
        new = DEF_LABELS[comp_cd]
        lines.append(
            f"UPDATE t_prc_price_components SET note={sql_lit(new)}, upd_dt=now() "
            f"WHERE comp_cd={sql_lit(comp_cd)} AND note IS DISTINCT FROM {sql_lit(new)};"
        )
    lines.append("")

    # 3b) 단가행 — 결정적 regexp 치환 (비-용지비). PK=comp_price_id로 스코프(comp_cd 화이트리스트).
    chain = (
        "SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_A'"
    )
    xf = (
        "btrim("
        "regexp_replace("
        "regexp_replace("
        "regexp_replace("
        "regexp_replace("
        "regexp_replace(note, '^\\[siz-corrected:[^\\]]*\\]\\s*', ''), "
        "'\\s*\\(별색=공정,clr=NULL\\)\\s*$', ''), "
        "'\\s*\\(합가,\\s*comp_typ=\\.04\\s*후가공비,\\s*옵션=comp흡수\\)\\s*$', ' / 작업 1건 고정 금액'), "
        "'출력매수≥([0-9]+)', '출력매수 \\1장 이상'), "
        "'제작수량≥([0-9]+)', '주문수량 \\1건 이상'))"
    )
    lines.append("-- B) 단가행 t_prc_component_prices.note (비-용지비) — 결정적 regexp 치환")
    lines.append("--    siz-corrected 마커·(별색=공정,clr=NULL)·(합가,comp_typ=.04...) 제거 + 축 한국어화")
    lines.append("--    note 컬럼만 읽어 note 컬럼만 씀. 가격행(unit_price 등) 불변. WHERE로 실변경분만 → 멱등.")
    lines.append(
        f"UPDATE t_prc_component_prices cp SET note = {xf}, upd_dt=now()\n"
        f"WHERE cp.comp_cd IN ({chain})\n"
        f"  AND cp.comp_cd <> 'COMP_PAPER'\n"
        f"  AND cp.note IS NOT NULL\n"
        f"  AND cp.note IS DISTINCT FROM ({xf});"
    )
    lines.append("")
    # 3c) 단가행 용지비 — suffix 추가(이미 있으면 no-op)
    paper_new = "note || " + sql_lit(PAPER_SUFFIX)
    lines.append("-- C) 단가행 용지비(COMP_PAPER) — 친화 설명 suffix 추가(이미 있으면 건너뜀=멱등)")
    lines.append(
        f"UPDATE t_prc_component_prices cp SET note = {paper_new}, upd_dt=now()\n"
        f"WHERE cp.comp_cd = 'COMP_PAPER'\n"
        f"  AND cp.note IS NOT NULL\n"
        f"  AND cp.note NOT LIKE '%실제 청구는 출력매수만큼 자동 계산%';"
    )
    lines.append("")

    with open(os.path.join(HERE, "01_update_notes.sql"), "w") as f:
        f.write("\n".join(lines) + "\n")

    # 4) apply.sql — 단일 트랜잭션 래퍼 (COMMIT/ROLLBACK은 로더 주입)
    apply = [
        "-- apply.sql — 016 note 교정 단일 트랜잭션 래퍼",
        "-- 기본 = DRY-RUN: 로더(apply_loader.sh)가 끝에 ROLLBACK 주입. --commit 시에만 COMMIT.",
        "-- [HARD] note 컬럼만 변경. 중간 COMMIT 없음(원자성).",
        "\\set ON_ERROR_STOP on",
        "BEGIN;",
        "  \\i 01_update_notes.sql",
        "-- COMMIT/ROLLBACK 미포함 — 로더가 주입(기본 ROLLBACK).",
    ]
    with open(os.path.join(HERE, "apply.sql"), "w") as f:
        f.write("\n".join(apply) + "\n")

    print(f"note-map.csv rows={len(mapping)} (def={len(def_rows)}, price={len(price_rows)})")
    print("generated: note-map.csv, 01_update_notes.sql, apply.sql")


if __name__ == "__main__":
    main()
