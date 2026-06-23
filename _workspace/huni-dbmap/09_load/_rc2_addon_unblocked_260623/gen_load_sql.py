#!/usr/bin/env python3
"""gen_load_sql.py — RC-2 추가물형(비BLOCKED) 적재 SQL 생성기 (reproducible).

mapping.csv(진실 소스)를 읽어 멱등 SQL 4단을 생성한다. 손편집 금지 — 이 스크립트가 권위.
대상: 메쉬현수막(139)·캔버스행잉(133)·린넨우드봉(134). PET(136)=HOLD-1 BLOCKED 제외(mapping.csv에 미포함).

FK 위상순서:
  01 옵션 INSERT (t_prd_product_options)   ─ 부모: (prd_cd,opt_grp_cd) 그룹 실재
  02 comp use_dims UPDATE (price_components) ─ always-add 가드: opt_cd 포함
  03 단가행 충전 UPDATE (component_prices)   ─ opt_cd + RC-4 siz_cd 재배선·단가 verbatim
  04 공식 바인딩 INSERT (formula_components) ─ addtn_yn=Y·disp_seq=2

멱등성: INSERT=NOT EXISTS 가드 / UPDATE=IS DISTINCT FROM 가드 + unit_price verbatim WHERE 검증.
"""
import csv
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
MAPPING = os.path.join(HERE, "mapping.csv")


def read_rows():
    rows = []
    with open(MAPPING, newline="", encoding="utf-8") as f:
        for raw in f:
            if raw.lstrip().startswith("#"):
                continue
            rows.append(raw)
    # 헤더 포함 재파싱 (주석 제거 후)
    reader = csv.DictReader(rows)
    return [r for r in reader if r.get("kind")]


def sql_str(v):
    return "'" + v.replace("'", "''") + "'"


def gen_options(rows):
    out = ["-- 01_options.sql — RC-2 추가물형 신규 CPQ 옵션 INSERT (멱등 NOT EXISTS 가드)",
           "-- PK=(prd_cd,opt_cd). reg_dt DEFAULT now()·use_yn DEFAULT Y·del_yn DEFAULT N (명시 생략 가능하나 명시).",
           ""]
    for r in rows:
        if r["kind"] != "option":
            continue
        if not (r["disp_seq"] or "").strip().isdigit():
            raise SystemExit(f"FATAL option disp_seq not integer: {r['disp_seq']!r} for {r['opt_cd']}")
        out.append(f"-- src: {r['src']}")
        out.append(
            "INSERT INTO t_prd_product_options "
            "(prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, reg_dt)"
        )
        out.append(
            f"SELECT {sql_str(r['prd_cd'])}, {sql_str(r['opt_cd'])}, {sql_str(r['opt_grp_cd'])}, "
            f"{sql_str(r['opt_nm'])}, {sql_str(r['dflt_yn'])}, {r['disp_seq']}, 'Y', 'N', now()"
        )
        out.append(
            "WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options "
            f"WHERE prd_cd={sql_str(r['prd_cd'])} AND opt_cd={sql_str(r['opt_cd'])});"
        )
        out.append("")
    return "\n".join(out) + "\n"


def gen_use_dims(rows):
    out = ["-- 02_use_dims.sql — comp 판별차원 충전 (멱등 IS DISTINCT FROM 가드)",
           "-- always-add 가드: use_dims에 opt_cd 포함 → 미선택(opt_cd≠신규) 시 단가행 매칭 None → 가산 0.",
           ""]
    for r in rows:
        if r["kind"] != "use_dims":
            continue
        ud = r["use_dims"]
        out.append(f"-- src: {r['src']} ({r['opt_cd']})")
        out.append("UPDATE t_prc_price_components")
        out.append(f"   SET use_dims = {sql_str(ud)}::jsonb, upd_dt = now()")
        out.append(f" WHERE comp_cd = {sql_str(r['comp_cd'])}")
        out.append(f"   AND use_dims IS DISTINCT FROM {sql_str(ud)}::jsonb;")
        out.append("")
    return "\n".join(out) + "\n"


def gen_price(rows):
    out = ["-- 03_price_fill.sql — 단가행 opt_cd 충전 + RC-4 siz_cd 재배선 (멱등·단가 verbatim 불변)",
           "-- comp_price_id=라이브 PK. unit_price는 WHERE 검증값으로만 가드(미변경).",
           "-- 순서: ⓐ opt_cd 충전(전 단가행) → ⓑ RC-4 siz_cd 재배선(캔버스 우드행거 3행).",
           ""]
    out.append("-- ⓐ opt_cd 판별값 충전 (single-statement: opt_cd NULL=와일드카드 always-add 해소)")
    for r in rows:
        if r["kind"] != "price_opt":
            continue
        cpid = r["comp_price_id"]
        up = r["unit_price"]
        out.append(f"-- src: {r['src']}")
        out.append("UPDATE t_prc_component_prices")
        out.append(f"   SET opt_cd = {sql_str(r['opt_cd'])}, upd_dt = now()")
        out.append(f" WHERE comp_price_id = {cpid}")
        out.append(f"   AND comp_cd = {sql_str(r['comp_cd'])}")
        out.append(f"   AND unit_price = {up}            -- verbatim 단가 검증(불일치=0행 가드)")
        out.append(f"   AND opt_cd IS DISTINCT FROM {sql_str(r['opt_cd'])};")
        out.append("")
    out.append("-- ⓑ RC-4 캔버스 우드행거 siz_cd 재배선 (133 미등록 258/315/317 → 등록 172/174/197 동일치수)")
    for r in rows:
        if r["kind"] != "siz_rewire":
            continue
        cpid = r["comp_price_id"]
        up = r["unit_price"]
        out.append(f"-- src: {r['src']} ({r['cur_siz_cd']}->{r['new_siz_cd']})")
        out.append("UPDATE t_prc_component_prices")
        out.append(f"   SET siz_cd = {sql_str(r['new_siz_cd'])}, upd_dt = now()")
        out.append(f" WHERE comp_price_id = {cpid}")
        out.append(f"   AND comp_cd = {sql_str(r['comp_cd'])}")
        out.append(f"   AND unit_price = {up}            -- verbatim 단가 검증(불일치=0행 가드)")
        out.append(f"   AND siz_cd IS DISTINCT FROM {sql_str(r['new_siz_cd'])}")
        # 멱등: 현재 siz_cd가 cur 또는 이미 new 일 때만 (오행 보호)
        out.append(f"   AND siz_cd IN ({sql_str(r['cur_siz_cd'])}, {sql_str(r['new_siz_cd'])});")
        out.append("")
    return "\n".join(out) + "\n"


def gen_bind(rows):
    out = ["-- 04_formula_components.sql — 공식 바인딩 (멱등 UPSERT·PK=(frm_cd,comp_cd))",
           "-- addtn_yn=Y 가산·disp_seq=2부터. ON CONFLICT DO UPDATE 가드.",
           ""]
    for r in rows:
        if r["kind"] != "bind":
            continue
        ds = (r["bind_disp_seq"] or "").strip()
        if not ds.isdigit():
            raise SystemExit(
                f"FATAL bind row disp_seq not integer: {ds!r} for {r['comp_cd']} "
                "(mapping.csv 컬럼 정렬 오류 의심)"
            )
        out.append(f"-- src: {r['src']}")
        out.append("INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)")
        out.append(f"VALUES ({sql_str(r['frm_cd'])}, {sql_str(r['comp_cd'])}, {ds}, 'Y', now())")
        out.append("ON CONFLICT (frm_cd, comp_cd) DO UPDATE")
        out.append("   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()")
        out.append(" WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn")
        out.append("    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;")
        out.append("")
    return "\n".join(out) + "\n"


def main():
    rows = read_rows()
    files = {
        "01_options.sql": gen_options(rows),
        "02_use_dims.sql": gen_use_dims(rows),
        "03_price_fill.sql": gen_price(rows),
        "04_formula_components.sql": gen_bind(rows),
    }
    for name, content in files.items():
        with open(os.path.join(HERE, name), "w", encoding="utf-8") as f:
            f.write(content)
        sys.stderr.write(f"wrote {name} ({content.count(chr(10))} lines)\n")


if __name__ == "__main__":
    main()
