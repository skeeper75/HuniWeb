#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
고정가형 15상품 정정 마이그레이션 SQL 생성기 (round-2 면적-좌표 오모델 정정).

입력 (커밋 5e57464, verbatim):
  - 02_mapping/load_price_correction/fixedprice-component-prices.csv  (73행)
  - 02_mapping/load_price_correction/fixedprice-formulas.csv          (공식+구성+바인딩)

산출 → 09_load/_migrate_fixedprice/:
  - migrate.sql        : 단일 트랜잭션 정정 마이그레이션
  - undo.sql           : 역마이그레이션 (백업 복원)
  - *.provenance.csv   : 각 출력행 → 입력 출처 추적

설계 결정 (라이브 검증 기반):
  1. 공식/구성/와이어링: 모두 신규(15개 PRF_*_FIXED는 라이브 부재) → INSERT … ON CONFLICT DO NOTHING (멱등).
  2. component_prices: 선행 broken-partial 적재(55행, reg_dt 2026-06-06 11:30)가 이미 커밋됨.
     그 55행 중 14행은 min_qty=NULL(ACRYLSTK/SHEETCUT)로 CSV(min_qty=1)와 자연키 불일치 →
     단순 ON CONFLICT append 시 중복행 발생. 정정 마이그레이션이므로
     17개 comp_cd의 기존 행 전부 DELETE 후 권위 CSV 73행 INSERT(comp_price_id=MAX+증분).
     → 라이브 = 정확히 CSV 73행, 중복/stale NULL-qty 제거.
  3. 상품 바인딩(정정 핵심): 15상품의 PRF_POSTER_FIXED 바인딩 DELETE 후 고정가형 바인딩 INSERT.
     (면적형 13상품은 PRF_POSTER_FIXED 유지 — 본 마이그레이션은 건드리지 않음.)
"""
import csv
import os

ROOT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap"
SRC_CP = f"{ROOT}/02_mapping/load_price_correction/fixedprice-component-prices.csv"
SRC_FRM = f"{ROOT}/02_mapping/load_price_correction/fixedprice-formulas.csv"
OUT = f"{ROOT}/09_load/_migrate_fixedprice"

# 정정 대상 15상품 (면적형 13상품은 제외)
FIXED_PRD = [
    "PRD_000129", "PRD_000130", "PRD_000131", "PRD_000132", "PRD_000133",
    "PRD_000134", "PRD_000135", "PRD_000136", "PRD_000137", "PRD_000140",
    "PRD_000141", "PRD_000142", "PRD_000143", "PRD_000144", "PRD_000145",
]

APPLY_YMD = "2026-06-01"      # 라이브 기존 포스터 단가 apply_ymd와 동일
COMP_TYP = "PRC_COMPONENT_TYPE.06"   # 완제품비 (라이브 FK target 검증됨)
COMP_NM_TPL = "포스터 완제품가(포함항목 통가격) [{}]"  # 라이브 기존 component 명명 규칙

# 라이브 부재인 신규 component 4종 (FOAM/FOMEX 색상 variant) — 나머지 13종은 이미 라이브 존재.
# (멱등 ON CONFLICT DO NOTHING이므로 17종 전부 INSERT문 emit, 기존 13종은 skip됨)


def sqlstr(v):
    """문자열 리터럴 (None/빈문자 → NULL)."""
    if v is None or v == "":
        return "NULL"
    return "'" + v.replace("'", "''") + "'"


def sqlnum(v):
    if v is None or v == "":
        return "NULL"
    return str(v)


def sqlint(v):
    """정수 컬럼용 — NULL도 ::int 캐스트해 VALUES 타입추론 오류 방지."""
    if v is None or v == "":
        return "NULL::int"
    return f"{int(v)}::int"


def sqlnumeric(v):
    """numeric 컬럼용 — NULL도 ::numeric 캐스트."""
    if v is None or v == "":
        return "NULL::numeric"
    return f"{v}::numeric"


def sqltext(v):
    """text/varchar 컬럼용 — NULL도 ::text 캐스트(VALUES 타입추론 안정화)."""
    if v is None or v == "":
        return "NULL::text"
    return "'" + v.replace("'", "''") + "'"


def read_cp_rows():
    rows = []
    with open(SRC_CP, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows.append(r)
    return rows


def read_frm_csv():
    formulas, formula_comps, bindings = [], [], []
    with open(SRC_FRM, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            t = r["target_table"]
            if t == "t_prc_price_formulas":
                formulas.append(r)
            elif t == "t_prc_formula_components":
                formula_comps.append(r)
            elif t == "t_prd_product_price_formulas":
                bindings.append(r)
    return formulas, formula_comps, bindings


def derive_components(cp_rows):
    """component_prices에 나타나는 distinct comp_cd → t_prc_price_components 신규행."""
    seen = {}
    for r in cp_rows:
        c = r["comp_cd"]
        if c not in seen:
            seen[c] = COMP_NM_TPL.format(c)
    # disp 순서 안정화
    return [(c, seen[c]) for c in dict.fromkeys(r["comp_cd"] for r in cp_rows)]


def main():
    cp_rows = read_cp_rows()
    assert len(cp_rows) == 73, f"component_prices CSV는 73행이어야 함, 실제 {len(cp_rows)}"
    formulas, formula_comps, bindings = read_frm_csv()
    components = derive_components(cp_rows)

    # comp_cd IN (...) 목록 (DELETE 대상)
    comp_list = sorted({r["comp_cd"] for r in cp_rows})
    comp_in = ", ".join(f"'{c}'" for c in comp_list)

    new_frm = [f["frm_cd"] for f in formulas]
    frm_in = ", ".join(f"'{c}'" for c in new_frm)
    prd_in = ", ".join(f"'{p}'" for p in FIXED_PRD)

    prov = []  # (output_table, key, source)

    L = []
    A = L.append
    A("-- =====================================================================")
    A("-- 고정가형 15상품 정정 마이그레이션 (migrate.sql)")
    A("-- round-2 면적-좌표 오모델 정정. GO 커밋 후 COMMITTED 데이터 마이그레이션.")
    A("-- 생성: gen_migrate_sql.py (입력 CSV verbatim, 손으로 수정 금지)")
    A("-- 단일 트랜잭션. 로더(apply.sh)가 기본 ROLLBACK 주입(DRY-RUN), --commit=인간 승인.")
    A("-- =====================================================================")
    A("\\set ON_ERROR_STOP on")
    A("\\timing on")
    A("BEGIN;")
    A("")
    A("-- 마이그레이션 전 가드: 15상품이 PRF_POSTER_FIXED에 바인딩되어 있는지 확인")
    A("DO $$")
    A("DECLARE n int;")
    A("BEGIN")
    A(f"  SELECT count(*) INTO n FROM t_prd_product_price_formulas")
    A(f"   WHERE prd_cd IN ({prd_in}) AND frm_cd='PRF_POSTER_FIXED';")
    A("  IF n <> 15 THEN")
    A("    RAISE EXCEPTION '가드 실패: PRF_POSTER_FIXED 바인딩이 15가 아님 (실제 %). 마이그레이션 중단.', n;")
    A("  END IF;")
    A("END $$;")
    A("")

    # ---------- STEP 1: price_formulas (신규 15) ----------
    A("-- ---------------------------------------------------------------------")
    A("-- STEP 1: 고정가형 공식 추가 (t_prc_price_formulas) — 신규, 멱등")
    A("-- ---------------------------------------------------------------------")
    for f in formulas:
        A(
            "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt) VALUES ("
            f"{sqlstr(f['frm_cd'])}, {sqlstr(f['frm_nm'])}, {sqlstr(f['frm_typ_cd'])}, "
            f"{sqlstr(f['note'])}, {sqlstr(f['use_yn'] or 'Y')}, now())"
            " ON CONFLICT (frm_cd) DO NOTHING;"
        )
        prov.append(("t_prc_price_formulas", f["frm_cd"], "fixedprice-formulas.csv:t_prc_price_formulas"))
    A("")

    # ---------- STEP 2a: price_components (신규 comp_cd) ----------
    A("-- ---------------------------------------------------------------------")
    A("-- STEP 2a: 가격구성요소 추가 (t_prc_price_components) — 색상 variant 포함, 멱등")
    A("--   17 comp_cd 전부 emit (라이브 13종 기존존재→skip, FOAM/FOMEX 4종 신규)")
    A("-- ---------------------------------------------------------------------")
    for comp_cd, comp_nm in components:
        A(
            "INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, use_yn, reg_dt) VALUES ("
            f"{sqlstr(comp_cd)}, {sqlstr(comp_nm)}, {sqlstr(COMP_TYP)}, 'Y', now())"
            " ON CONFLICT (comp_cd) DO NOTHING;"
        )
        prov.append(("t_prc_price_components", comp_cd, "fixedprice-component-prices.csv:comp_cd"))
    A("")

    # ---------- STEP 2b: formula_components wiring (신규) ----------
    A("-- ---------------------------------------------------------------------")
    A("-- STEP 2b: 공식↔구성 와이어링 (t_prc_formula_components) — 신규, 멱등")
    A("-- ---------------------------------------------------------------------")
    for fc in formula_comps:
        A(
            "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt) VALUES ("
            f"{sqlstr(fc['frm_cd'])}, {sqlstr(fc['comp_cd'])}, {sqlnum(fc['disp_seq'])}, "
            f"{sqlstr(fc['addtn_yn'] or 'N')}, now())"
            " ON CONFLICT (frm_cd, comp_cd) DO NOTHING;"
        )
        prov.append(("t_prc_formula_components", f"{fc['frm_cd']}|{fc['comp_cd']}",
                     "fixedprice-formulas.csv:t_prc_formula_components"))
    A("")

    # ---------- STEP 3: component_prices — DELETE 선행파셜 THEN INSERT 73 ----------
    A("-- ---------------------------------------------------------------------")
    A("-- STEP 3: 단가 정정 (t_prc_component_prices)")
    A("--   선행 broken-partial 적재(55행, min_qty NULL/1 불일치 포함)를 DELETE 후")
    A("--   권위 CSV 73행을 INSERT. → 라이브 = 정확히 73행 (중복/stale NULL-qty 제거)")
    A("--   comp_price_id = MAX(현재)+행번호 (시퀀스 없음, 명시 채번)")
    A("-- ---------------------------------------------------------------------")
    A(f"DELETE FROM t_prc_component_prices WHERE comp_cd IN ({comp_in});")
    A("")
    A("-- 채번 기준 캡처 (DELETE 후 MAX, 충돌 회피)")
    A("DO $$")
    A("DECLARE base bigint;")
    A("BEGIN")
    A("  SELECT coalesce(max(comp_price_id),0) INTO base FROM t_prc_component_prices;")
    A("  CREATE TEMP TABLE _mig_base (b bigint) ON COMMIT DROP;")
    A("  INSERT INTO _mig_base VALUES (base);")
    A("END $$;")
    A("")
    A("INSERT INTO t_prc_component_prices")
    A("  (comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)")
    A("SELECT (SELECT b FROM _mig_base) + v.rn,")
    A("       v.comp_cd, v.apply_ymd, v.siz_cd, v.clr_cd, v.mat_cd, v.coat_side_cnt, v.bdl_qty, v.min_qty, v.unit_price, v.note, now()")
    A("FROM (VALUES")
    vals = []
    for i, r in enumerate(cp_rows, start=1):
        vals.append(
            f"  ({i}::int, {sqltext(r['comp_cd'])}, '{APPLY_YMD}'::varchar, {sqltext(r['siz_cd'])}, "
            f"{sqltext(r['clr_cd'])}, {sqltext(r['mat_cd'])}, {sqlint(r['coat_side_cnt'])}, "
            f"{sqlint(r['bdl_qty'])}, {sqlint(r['min_qty'])}, {sqlnumeric(r['unit_price'])}, {sqltext(r['note'])})"
        )
        prov.append(("t_prc_component_prices",
                     f"{r['comp_cd']}|{r['siz_cd']}|{r['min_qty'] or '1'}",
                     "fixedprice-component-prices.csv row {}".format(i + 1)))
    A(",\n".join(vals))
    A(") AS v(rn, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)")
    A("ON CONFLICT (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty) DO NOTHING;")
    A("")

    # ---------- STEP 4: REBIND 15상품 (정정 핵심) ----------
    A("-- ---------------------------------------------------------------------")
    A("-- STEP 4 (정정 핵심): 15상품 재바인딩")
    A("--   PRF_POSTER_FIXED(오바인딩) DELETE → 상품별 고정가형 바인딩 INSERT.")
    A("--   면적형 13상품은 PRF_POSTER_FIXED 유지 — 본 마이그레이션 미포함.")
    A("-- ---------------------------------------------------------------------")
    A(f"DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ({prd_in}) AND frm_cd='PRF_POSTER_FIXED';")
    A("")
    for b in bindings:
        note = b["note"] or ""
        A(
            "INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt) VALUES ("
            f"{sqlstr(b['prd_cd'])}, {sqlstr(b['frm_cd'])}, '{APPLY_YMD}', {sqlstr(note)}, now())"
            " ON CONFLICT (prd_cd, frm_cd) DO NOTHING;"
        )
        prov.append(("t_prd_product_price_formulas", f"{b['prd_cd']}|{b['frm_cd']}",
                     "fixedprice-formulas.csv:t_prd_product_price_formulas (rebind)"))
    A("")
    A("-- 사후 가드: 15상품이 각각 정확히 1개의 고정가형 바인딩을 갖는지 확인")
    A("DO $$")
    A("DECLARE n int;")
    A("BEGIN")
    A(f"  SELECT count(*) INTO n FROM t_prd_product_price_formulas")
    A(f"   WHERE prd_cd IN ({prd_in}) AND frm_cd IN ({frm_in});")
    A("  IF n <> 15 THEN")
    A("    RAISE EXCEPTION '사후 가드 실패: 고정가형 바인딩이 15가 아님 (실제 %).', n;")
    A("  END IF;")
    A(f"  SELECT count(*) INTO n FROM t_prd_product_price_formulas")
    A(f"   WHERE prd_cd IN ({prd_in}) AND frm_cd='PRF_POSTER_FIXED';")
    A("  IF n <> 0 THEN")
    A("    RAISE EXCEPTION '사후 가드 실패: PRF_POSTER_FIXED 잔존 바인딩 % 건.', n;")
    A("  END IF;")
    A("END $$;")
    A("")
    A("-- 영향 카운트 리포트")
    A("SELECT '고정가형 바인딩' AS metric, count(*) AS cnt FROM t_prd_product_price_formulas WHERE frm_cd IN (" + frm_in + ")")
    A("UNION ALL SELECT 'component_prices(17 comp)', count(*) FROM t_prc_component_prices WHERE comp_cd IN (" + comp_in + ")")
    A("UNION ALL SELECT 'price_formulas(신규15)', count(*) FROM t_prc_price_formulas WHERE frm_cd IN (" + frm_in + ");")
    A("")
    A("COMMIT;")

    with open(f"{OUT}/migrate.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(L) + "\n")

    # provenance
    with open(f"{OUT}/migrate.provenance.csv", "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["output_table", "key", "source"])
        w.writerows(prov)

    # ---------- undo.sql ----------
    U = []
    B = U.append
    B("-- =====================================================================")
    B("-- 고정가형 정정 마이그레이션 역실행 (undo.sql)")
    B("-- backup.sql이 생성한 backup_prf_poster_bindings.csv 의 PRF_POSTER_FIXED 바인딩을 복원하고")
    B("-- 본 마이그레이션이 추가한 고정가형 엔티티를 제거한다. 단일 트랜잭션.")
    B("-- 기본 ROLLBACK(undo.sh DRY-RUN). --commit=인간 승인.")
    B("-- 주의: STEP 3 DELETE는 선행 broken-partial 행도 함께 지웠으므로 undo는 73행을 제거하되")
    B("--       broken-partial 55행은 복원하지 않는다(그것이 정정의 목적). 필요 시 backup CSV 참조.")
    B("-- =====================================================================")
    B("\\set ON_ERROR_STOP on")
    B("BEGIN;")
    B("")
    B("-- 1) 추가한 고정가형 바인딩 제거")
    B(f"DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ({prd_in}) AND frm_cd IN ({frm_in});")
    B("")
    B("-- 2) 백업된 PRF_POSTER_FIXED 바인딩 재삽입 (15행)")
    B("--    \\copy 로 backup CSV 로드하거나, 아래 명시 INSERT 사용(백업 시점 값).")
    B("\\set bkp `cat " + OUT + "/backup_prf_poster_bindings.csv 2>/dev/null | tail -n +2`")
    B("-- 명시 복원 (apply_bgn_ymd/note는 백업본 CSV가 권위; 아래는 기본 재바인딩)")
    for p in FIXED_PRD:
        B(
            f"INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, reg_dt) VALUES ('{p}', 'PRF_POSTER_FIXED', now())"
            " ON CONFLICT (prd_cd, frm_cd) DO NOTHING;"
        )
    B("")
    B("-- 3) component_prices: 마이그레이션이 INSERT한 73행 제거")
    B(f"DELETE FROM t_prc_component_prices WHERE comp_cd IN ({comp_in}) AND apply_ymd='{APPLY_YMD}';")
    B("")
    B("-- 4) formula_components 와이어링 제거")
    B(f"DELETE FROM t_prc_formula_components WHERE frm_cd IN ({frm_in});")
    B("")
    B("-- 5) 신규 component (4종 FOAM/FOMEX) 제거 — 라이브 기존 13종은 보존")
    B("DELETE FROM t_prc_price_components WHERE comp_cd IN "
      "('COMP_FOAMBOARD_WHITE','COMP_FOAMBOARD_BLACK','COMP_FOMEXBOARD_WHITE','COMP_FOMEXBOARD_BLACK');")
    B("")
    B("-- 6) 신규 고정가형 공식 제거")
    B(f"DELETE FROM t_prc_price_formulas WHERE frm_cd IN ({frm_in});")
    B("")
    B("-- 복원 가드: 15상품이 PRF_POSTER_FIXED로 돌아왔는지 확인")
    B("DO $$")
    B("DECLARE n int;")
    B("BEGIN")
    B(f"  SELECT count(*) INTO n FROM t_prd_product_price_formulas WHERE prd_cd IN ({prd_in}) AND frm_cd='PRF_POSTER_FIXED';")
    B("  IF n <> 15 THEN RAISE EXCEPTION 'undo 가드 실패: PRF_POSTER_FIXED 복원 % (기대 15).', n; END IF;")
    B("END $$;")
    B("")
    B("COMMIT;")
    with open(f"{OUT}/undo.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(U) + "\n")

    print(f"migrate.sql       : {len(L)} lines")
    print(f"  formulas        : {len(formulas)}")
    print(f"  components       : {len(components)}")
    print(f"  formula_components: {len(formula_comps)}")
    print(f"  component_prices : {len(cp_rows)} (DELETE-then-INSERT)")
    print(f"  bindings(rebind) : {len(bindings)}")
    print(f"undo.sql          : {len(U)} lines")
    print(f"provenance rows   : {len(prov)}")


if __name__ == "__main__":
    main()
