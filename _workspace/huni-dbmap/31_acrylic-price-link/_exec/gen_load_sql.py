#!/usr/bin/env python3
"""아크릴 가격사슬 연결 — 멱등 적재 SQL 생성기 (round-5 load-execution).

CSV 명세(data_*.csv) → 멱등 INSER … ON CONFLICT SQL + provenance.
재현성(R3·G8): 같은 CSV → byte-identical 출력. 손편집 금지 — 이 스크립트 경유.
NEVER COMMIT: apply.sql은 BEGIN으로 열고 COMMIT/ROLLBACK은 로더가 주입(기본 ROLLBACK).

충돌키(라이브 PK 실측):
  t_prc_price_formulas        PK frm_cd
  t_prc_price_components       PK comp_cd
  t_prc_formula_components     PK (frm_cd, comp_cd)
  t_prd_product_price_formulas PK (prd_cd, apply_bgn_ymd)   ← frm_cd는 PK 밖
reg_dt: NOT NULL DEFAULT now() → 명시 NULL 금지·컬럼 omit(DEFAULT 발화).
"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))


def q(s):
    """SQL 문자열 리터럴 — 작은따옴표 이스케이프."""
    return "'" + s.replace("'", "''") + "'"


def read_csv(name):
    with open(os.path.join(HERE, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write(fname, header_comment, lines, prov_rows):
    with open(os.path.join(HERE, fname), "w", encoding="utf-8") as f:
        f.write(f"-- {header_comment}\n")
        f.write("-- 생성: gen_load_sql.py (손편집 금지·재현성 R3). NEVER COMMIT.\n\n")
        f.write("\n".join(lines) + "\n")
    if prov_rows:
        pname = fname.replace(".sql", ".provenance.csv")
        with open(os.path.join(HERE, pname), "w", encoding="utf-8", newline="") as f:
            w = csv.writer(f)
            w.writerow(["target_table", "natural_key", "source"])
            w.writerows(prov_rows)


def gen_formulas():
    """01 — 신규 공식 INSERT … ON CONFLICT(frm_cd) DO NOTHING.
    PRF_CLR_ACRYL은 라이브 실재 → ON CONFLICT가 자동 스킵(별도 NOT EXISTS 불요·동일효과)."""
    rows = read_csv("data_formulas.csv")
    lines, prov = [], []
    for r in rows:
        live = " (라이브 실재 — ON CONFLICT 스킵)" if r["live_exists"] == "Y" else ""
        lines.append(f"-- src: data_formulas.csv frm_cd={r['frm_cd']}{live}")
        lines.append(
            "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES ("
            f"{q(r['frm_cd'])}, {q(r['frm_nm'])}, {q(r['note'])}, {q(r['use_yn'])})"
        )
        lines.append("ON CONFLICT (frm_cd) DO NOTHING;\n")
        prov.append(["t_prc_price_formulas", r["frm_cd"], r["provenance"]])
    write("01_prc_price_formulas.sql",
          "신규 가격공식 (PRF_MIRROR/COROTTO/CARABINER·PRF_CLR 재현)", lines, prov)


def gen_components():
    """02 — 신규 comp INSERT … ON CONFLICT(comp_cd) DO NOTHING.
    기존 CLEAR3T·MIRROR3T는 재적재 0(재사용·아래 SQL에 미포함)."""
    rows = read_csv("data_components.csv")
    lines, prov = [], []
    for r in rows:
        lines.append(f"-- src: data_components.csv comp_cd={r['comp_cd']}")
        lines.append(
            "INSERT INTO t_prc_price_components "
            "(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn) VALUES ("
            f"{q(r['comp_cd'])}, {q(r['comp_nm'])}, {q(r['comp_typ_cd'])}, "
            f"{q(r['prc_typ_cd'])}, {q(r['use_dims'])}::jsonb, 'Y')"
        )
        lines.append("ON CONFLICT (comp_cd) DO NOTHING;\n")
        prov.append(["t_prc_price_components", r["comp_cd"], r["provenance"]])
    write("02_prc_price_components.sql",
          "신규 구성요소 (COROTTO .01/.01 · CARABINER .06/.01)", lines, prov)


def gen_wiring():
    """03 — 배선. 신규 3건 = INSERT … ON CONFLICT(frm_cd,comp_cd) DO NOTHING.
    PRF_CLR_ACRYL 메타 보정(seq/addtn NULL→1/N) = DO UPDATE (변형 B·실제 변경분만).
    단 메타 보정은 Q-ACR-7(prc_typ .02 엔진계약) 미해소 — BLOCKED 분리.
    여기서는 신규 3건만. CLR 메타 보정은 별 파일(주석 처리·BLOCKED)."""
    rows = read_csv("data_wiring.csv")
    lines, prov = [], []
    for r in rows:
        if r["mode"] == "upsert_meta":
            # PRF_CLR_ACRYL 메타 보정 — Q-ACR-7 미해소로 BLOCKED. 주석으로만 남김(미발화).
            lines.append(
                f"-- [BLOCKED Q-ACR-7] src: data_wiring.csv {r['frm_cd']}→{r['comp_cd']} "
                "메타 보정(disp_seq=1·addtn_yn=N) — 엔진 prc_typ .02 계약 미확정으로 보류."
            )
            lines.append(
                "-- INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES ("
                f"{q(r['frm_cd'])}, {q(r['comp_cd'])}, {r['disp_seq']}, {q(r['addtn_yn'])})"
            )
            lines.append(
                "-- ON CONFLICT (frm_cd, comp_cd) DO UPDATE SET disp_seq=EXCLUDED.disp_seq, "
                "addtn_yn=EXCLUDED.addtn_yn, upd_dt=now()"
            )
            lines.append(
                "--   WHERE t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq "
                "OR t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn;\n"
            )
            continue
        lines.append(f"-- src: data_wiring.csv {r['frm_cd']}→{r['comp_cd']}")
        lines.append(
            "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES ("
            f"{q(r['frm_cd'])}, {q(r['comp_cd'])}, {r['disp_seq']}, {q(r['addtn_yn'])})"
        )
        lines.append("ON CONFLICT (frm_cd, comp_cd) DO NOTHING;\n")
        prov.append(["t_prc_formula_components", f"{r['frm_cd']}|{r['comp_cd']}", r["provenance"]])
    write("03_prc_formula_components.sql",
          "공식↔구성요소 배선 (신규 3 INSERT · CLR 메타보정 BLOCKED 주석)", lines, prov)


def gen_bindings():
    """04 — 상품↔공식 바인딩. ON CONFLICT(prd_cd, apply_bgn_ymd) DO NOTHING.
    PK가 (prd_cd, apply_bgn_ymd) — frm_cd PK 밖. 같은 상품·같은 적용일에 한 공식만.
    멱등: 재실행 시 동일 (prd_cd, apply_bgn_ymd) 충돌 → DO NOTHING."""
    rows = read_csv("data_bindings.csv")
    lines, prov = [], []
    for r in rows:
        live = " (라이브 실재)" if r["live_exists"] == "Y" else ""
        lines.append(f"-- src: data_bindings.csv {r['prd_cd']}({r['prd_nm']})→{r['frm_cd']}{live}")
        lines.append(
            "INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd) VALUES ("
            f"{q(r['prd_cd'])}, {q(r['frm_cd'])}, {q(r['apply_bgn_ymd'])})"
        )
        lines.append("ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;\n")
        prov.append(["t_prd_product_price_formulas",
                     f"{r['prd_cd']}|{r['apply_bgn_ymd']}→{r['frm_cd']}", r["provenance"]])
    write("04_prd_product_price_formulas.sql",
          "상품↔공식 바인딩 (투명14 + 코롯토3 + 카라비너1 · 미러 BLOCKED)", lines, prov)


def main():
    gen_formulas()
    gen_components()
    gen_wiring()
    gen_bindings()
    print("generated: 01_prc_price_formulas.sql 02_prc_price_components.sql "
          "03_prc_formula_components.sql 04_prd_product_price_formulas.sql (+provenance)")


if __name__ == "__main__":
    main()
