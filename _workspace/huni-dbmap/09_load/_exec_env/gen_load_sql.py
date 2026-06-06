#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — 봉투제작(ENV) component_prices 적재 실행본 생성기
#
#   대상(round-5 적재 실행본 / 가격 트랙 — 봉투제작 ENV):
#     봉투제작(PRD_000050) 4 봉투종류 × 2 소재 × 5 수량밴드 = 40 component_prices 가격행을
#     실 적재 가능한 멱등 SQL로 만든다. **가격행 ONLY** — siz 등록·바인딩·코드행 전부 불요(전부 라이브 선존재).
#
#   입력(권위, verbatim — 손편집 금지):
#     - 02_mapping/load_price/t_prc_component_prices_ENV.csv  (40행, GO 검증된 적재 CSV)
#   산출:
#     - 01_component_prices.sql   40 ENV 가격 INSERT (ON CONFLICT (comp_price_id) DO NOTHING)
#     - migrate.sql               BEGIN → guard0(siz EXACT 재사용) → 01 → assert(FK orphan ×3 + 멱등카운트) → COMMIT
#     - undo.sql                  comp_price_id IN(1713..1752) DELETE
#     - backup.sql                (읽기전용) COMP_ENV_MAKING component_prices 라이브=0 확증 (undo 권위)
#     - migrate.provenance.csv    생성행 → source CSV 출처 추적 (placeholder→siz 계보 포함)
#
#   원칙(round-5):
#     - 멱등성(R1): 모든 INSERT는 ON CONFLICT (comp_price_id) DO NOTHING 가드. 충돌키=라이브 PK(단일컬럼).
#     - 원자성(R2): 단일 트랜잭션(migrate.sql). 중간 COMMIT 없음. 로더가 ROLLBACK/COMMIT 주입.
#     - 재현성(R3): CSV 위 스크립트 생성. 같은 입력 → byte-identical 출력. 손편집 금지.
#     - FK 위상순: siz(SIZ_000191~194)·comp(COMP_ENV_MAKING)·mat(MAT_000159/168) 전부 라이브 선존재
#                 → 부모 등록 단계 없음. component_prices 단일 단계만(ENV = 가장 단순 GO 트랙).
#     - search-before-mint: siz 신규 발급 0 (게이트가 SIZ_000191~194 EXACT 재사용 확증, hidden mint 0).
#     - reg_dt NOT NULL DEFAULT 교훈(round-5): component_prices는 reg_dt 컬럼 미포함(DEFAULT now() 발화,
#                 committed _exec_price/04 패턴 일치). source CSV에 reg_dt 컬럼 자체가 없음.
#   읽기전용. DB 쓰기·DDL·COMMIT 0. 비밀번호 미출력.
# =====================================================================
import csv
import os
from collections import Counter

# ---- 경로 (__file__ 기준 — 포터블) -----------------------------------
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", ".."))          # _workspace/huni-dbmap
SRC_CSV = os.path.join(ROOT, "02_mapping/load_price/t_prc_component_prices_ENV.csv")
OUTDIR = HERE

# ---- placeholder → 실 siz_cd 권위표 (게이트 TARGET 2 EXACT 재사용표, verbatim) ----
#   봉투종류(작업사이즈) → 라이브 siz_cd. 전부 EXACT work 치수 매칭, mint 0.
#   ENV_TICKET 225×193 / ENV_SMALL 238×262 / ENV_JACKET 262×238 / ENV_LARGE 510×387.
PLACEHOLDER_TO_SIZ = {
    "SIZ_PENDING_ENV_TICKET": "SIZ_000191",  # 티켓봉투
    "SIZ_PENDING_ENV_SMALL":  "SIZ_000192",  # 소봉투
    "SIZ_PENDING_ENV_JACKET": "SIZ_000193",  # 자켓봉투
    "SIZ_PENDING_ENV_LARGE":  "SIZ_000194",  # 대봉투
}
SIZ_TO_PLACEHOLDER = {v: k for k, v in PLACEHOLDER_TO_SIZ.items()}
ENV_SIZ_CDS = ["SIZ_000191", "SIZ_000192", "SIZ_000193", "SIZ_000194"]  # 라이브 선존재 재사용
ENV_MAT_CDS = ["MAT_000159", "MAT_000168"]  # 모조120g / 레자크체크백색110g(레자크 대표)
ENV_COMP_CD = "COMP_ENV_MAKING"

# component_prices 컬럼 순서 (source CSV 헤더와 동일). reg_dt 는 컬럼 자체가 없음 → DEFAULT 발화.
COLS = ["comp_price_id", "comp_cd", "apply_ymd", "siz_cd", "clr_cd", "mat_cd",
        "coat_side_cnt", "bdl_qty", "min_qty", "unit_price", "note"]
NUMCOLS = {"comp_price_id", "coat_side_cnt", "bdl_qty", "min_qty", "unit_price"}


def load_env_prices():
    """ENV component_prices CSV → 40행 verbatim. siz_cd 는 source 가 이미 실값(SIZ_000191~194).
       placeholder 계보는 SIZ_TO_PLACEHOLDER 로 역추적(provenance 용). 발명 0."""
    out = []
    with open(SRC_CSV, encoding="utf-8-sig", newline="") as f:
        for lineno, r in enumerate(csv.DictReader(f), start=2):  # 헤더=1
            siz_cd = (r["siz_cd"] or "").strip()
            if siz_cd not in SIZ_TO_PLACEHOLDER:
                raise SystemExit(
                    f"미배정 siz_cd {siz_cd!r} (CSV line {lineno}) — ENV 권위표 부재, 중단(no invention)")
            rec = {c: (r.get(c) or "").strip() for c in COLS}
            rec["src_line"] = lineno
            rec["placeholder"] = SIZ_TO_PLACEHOLDER[siz_cd]
            out.append(rec)
    return out


# ---- SQL 직렬화 헬퍼 --------------------------------------------------
def sql_val(col, v):
    if v is None or v == "":
        return "NULL"
    if col in NUMCOLS:
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"


# ---- STEP 1: ENV component_prices ------------------------------------
def gen_component_prices_sql(rows):
    L = []
    L.append("-- =====================================================================")
    L.append("-- STEP 1: 봉투제작(ENV) 가격 적재 (t_prc_component_prices)")
    L.append(f"--   {len(rows)} ENV 행 (4봉투종류×2mat[MAT_000159/168]×5수량밴드[1000..5000]).")
    L.append("--   placeholder SIZ_PENDING_ENV_종류 → 실 siz_cd(SIZ_000191~194) 치환:")
    L.append("--     TICKET→SIZ_000191 · SMALL→SIZ_000192 · JACKET→SIZ_000193 · LARGE→SIZ_000194 (EXACT 재사용, mint 0).")
    L.append("--   comp_price_id = source CSV surrogate PK 명시(1713..1752, 라이브 미사용 확증). note 에 [siz: …] 접두 보존.")
    L.append("--   reg_dt 미포함 — NOT NULL DEFAULT now() 발화(committed _exec_price/04 패턴, round-5 reg_dt 교훈 준수).")
    L.append("--   ON CONFLICT (comp_price_id) DO NOTHING — 충돌키=라이브 PK(단일컬럼). 재실행 시 no-op(R1).")
    L.append("--   FK 부모 전건 라이브 선존재: comp_cd COMP_ENV_MAKING · siz SIZ_000191~194 · mat MAT_000159/168.")
    L.append("--   바인딩(PRD_000050→PRF_ENV_MAKING)·코드행(.06·FRM_TYPE.02) 라이브 선존재 → 본 트랙 INSERT 0(가격행 ONLY).")
    L.append("-- =====================================================================")
    colsql = "(" + ", ".join(COLS) + ")"
    for r in rows:
        vals = ", ".join(sql_val(c, r[c]) for c in COLS)
        L.append(f"-- src: load_price/t_prc_component_prices_ENV.csv:{r['src_line']} "
                 f"comp_price_id={r['comp_price_id']} siz:{r['placeholder']}->{r['siz_cd']} "
                 f"mat:{r['mat_cd']} min_qty:{r['min_qty']}")
        L.append(f"INSERT INTO t_prc_component_prices {colsql} VALUES ({vals}) "
                 f"ON CONFLICT (comp_price_id) DO NOTHING;")
    L.append("")
    return "\n".join(L)


# ---- migrate.sql wrapper ---------------------------------------------
def gen_migrate_sql(rows):
    pid_in = ", ".join(str(r["comp_price_id"]) for r in rows)
    siz_in = ", ".join(f"'{s}'" for s in ENV_SIZ_CDS)
    L = []
    L.append("-- =====================================================================")
    L.append("-- 봉투제작(ENV) component_prices 적재 (migrate.sql)")
    L.append("-- 생성: gen_load_sql.py (입력 CSV verbatim, 손편집 금지)")
    L.append("-- 단일 트랜잭션. 로더(apply.sh)가 ROLLBACK 주입(기본 DRY-RUN), --commit=인간 승인.")
    L.append("-- 1단계: 01 ENV 가격(40행). FK 부모(siz/comp/mat) 전건 라이브 선존재 → 등록 단계 없음(가격행 ONLY).")
    L.append("-- ENV = round-5 가장 단순 GO 트랙: siz 등록 0 · 바인딩 INSERT 0 · 코드행 0.")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("\\timing on")
    L.append("BEGIN;")
    L.append("")
    L.append("-- 가드 0: siz EXACT 재사용 불변식 — SIZ_000191~194 적재 전 라이브 존재(4)여야 정상(mint 아님).")
    L.append("--         <4 이면 작업사이즈 siz 부재 → STOP(발명 금지). 게이트 EXACT 매칭과 모순이므로 예외.")
    L.append("DO $$")
    L.append("DECLARE pre int;")
    L.append("BEGIN")
    L.append(f"  SELECT count(*) INTO pre FROM t_siz_sizes WHERE siz_cd IN ({siz_in}) AND del_yn = 'N';")
    L.append("  RAISE NOTICE '[guard0] ENV 작업사이즈 siz(191~194) 라이브 존재(4=PASS, EXACT 재사용·mint 0): %', pre;")
    L.append("  IF pre <> 4 THEN")
    L.append("    RAISE EXCEPTION 'ENV siz SIZ_000191~194 중 % 종만 라이브 존재 — EXACT 재사용 전제 위반. 중단(no invention).', pre;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("\\i 01_component_prices.sql")
    L.append("")
    L.append("-- 적재 후 어서션 (롤백 전 검증용 — DRY-RUN/검증에서 사용)")
    L.append("-- 1) FK 고아(siz): 본 적재 40 ENV 가격행의 siz_cd 전건 t_siz_sizes 존재 (0=PASS).")
    L.append("DO $$")
    L.append("DECLARE orphan int;")
    L.append("BEGIN")
    L.append("  SELECT count(*) INTO orphan FROM t_prc_component_prices cp")
    L.append("   LEFT JOIN t_siz_sizes s ON s.siz_cd = cp.siz_cd")
    L.append(f"   WHERE cp.comp_price_id IN ({pid_in}) AND s.siz_cd IS NULL;")
    L.append("  RAISE NOTICE '[assert] ENV 가격 40행 FK 고아(siz 미해소, 0=PASS): %', orphan;")
    L.append("  IF orphan <> 0 THEN")
    L.append("    RAISE EXCEPTION 'ENV 가격행 FK 고아(siz) % 건. 중단.', orphan;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("-- 2) FK(comp_cd): COMP_ENV_MAKING 가 t_prc_price_components 에 존재해야 (라이브 선존재).")
    L.append("DO $$")
    L.append("DECLARE n int;")
    L.append("BEGIN")
    L.append(f"  SELECT count(*) INTO n FROM t_prc_price_components WHERE comp_cd = '{ENV_COMP_CD}';")
    L.append("  RAISE NOTICE '[assert] comp_cd COMP_ENV_MAKING 라이브 존재(1=PASS): %', n;")
    L.append("  IF n = 0 THEN")
    L.append("    RAISE EXCEPTION 'comp_cd COMP_ENV_MAKING 부재 — FK fk_prc_comp_prices_comp_cd 위반. 중단.';")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("-- 3) FK(mat_cd): MAT_000159/168 이 t_mat_materials 에 존재해야 (라이브 선존재).")
    L.append("DO $$")
    L.append("DECLARE mat_orphan int;")
    L.append("BEGIN")
    L.append("  SELECT count(*) INTO mat_orphan FROM t_prc_component_prices cp")
    L.append("   LEFT JOIN t_mat_materials m ON m.mat_cd = cp.mat_cd")
    L.append(f"   WHERE cp.comp_price_id IN ({pid_in}) AND cp.mat_cd IS NOT NULL AND m.mat_cd IS NULL;")
    L.append("  RAISE NOTICE '[assert] ENV 가격 40행 FK 고아(mat 미해소, 0=PASS): %', mat_orphan;")
    L.append("  IF mat_orphan <> 0 THEN")
    L.append("    RAISE EXCEPTION 'ENV 가격행 FK 고아(mat) % 건 — MAT_000159/168 미존재. 중단.', mat_orphan;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("-- 4) 멱등성 카운트(검증 참고): 본 적재 comp_price_id 중 이미 라이브 존재분(DO NOTHING 대상).")
    L.append("DO $$")
    L.append("DECLARE existing int;")
    L.append("BEGIN")
    L.append(f"  SELECT count(*) INTO existing FROM t_prc_component_prices WHERE comp_price_id IN ({pid_in});")
    L.append("  RAISE NOTICE '[assert] 본 적재 comp_price_id 라이브 선존재 수(1회차=0 기대, 2회차=40 기대): %', existing;")
    L.append("END $$;")
    L.append("")
    L.append("COMMIT;")
    L.append("")
    return "\n".join(L)


def gen_undo_sql(rows):
    pid_in = ", ".join(str(r["comp_price_id"]) for r in rows)
    L = []
    L.append("-- =====================================================================")
    L.append("-- 봉투제작(ENV) 적재 역실행 (undo.sql)")
    L.append("--   추가한 40 ENV 가격행을 제거한다. 단일 트랜잭션.")
    L.append("--   기본 ROLLBACK(undo.sh DRY-RUN). --commit=인간 승인.")
    L.append("--   comp_price_id(PK) IN 으로 정밀 제거(본 적재분 1713..1752만). siz/comp/mat 마스터는 손대지 않음(재사용분).")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("BEGIN;")
    L.append("")
    L.append("-- ENV 가격 40행 제거 — comp_price_id(PK) IN 으로 정밀(본 적재분만).")
    L.append(f"DELETE FROM t_prc_component_prices WHERE comp_price_id IN ({pid_in});")
    L.append("")
    L.append("COMMIT;")
    L.append("")
    return "\n".join(L)


def gen_backup_sql(rows):
    pid_in = ", ".join(str(r["comp_price_id"]) for r in rows)
    siz_in = ", ".join(f"'{s}'" for s in ENV_SIZ_CDS)
    L = []
    L.append("-- =====================================================================")
    L.append("-- backup.sql — 읽기전용 백업 스냅샷 (undo 권위본)")
    L.append("--   ENV = INSERT-only 가격 적재 → backup = COMP_ENV_MAKING component_prices 라이브=0 확증")
    L.append("--   (빈 슬롯 입증) + 본 적재 comp_price_id(1713..1752) 부재 확증. DB 쓰기 없음(\\copy out 만).")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("-- 1) COMP_ENV_MAKING 기존 component_prices 스냅샷 (적재 전 = 0행 기대, 빈 슬롯 입증).")
    L.append(f"\\copy (SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price "
             f"FROM t_prc_component_prices WHERE comp_cd = '{ENV_COMP_CD}' ORDER BY comp_price_id) "
             f"TO 'backup_env_component_prices_before.csv' CSV HEADER")
    L.append("")
    L.append("-- 2) 본 적재 comp_price_id 충돌 확증 (0행이어야 정상 — 1713..1752 라이브 부재).")
    L.append(f"\\copy (SELECT comp_price_id FROM t_prc_component_prices WHERE comp_price_id IN ({pid_in}) "
             f"ORDER BY comp_price_id) TO 'backup_env_id_collisions.csv' CSV HEADER  -- 0행=정상(충돌 없음)")
    L.append("")
    L.append("-- 3) 재사용 마스터 선존재 확증 (siz 191~194 — undo 시 절대 제거 안 함).")
    L.append(f"\\copy (SELECT siz_cd, siz_nm, work_width, work_height FROM t_siz_sizes "
             f"WHERE siz_cd IN ({siz_in}) ORDER BY siz_cd) "
             f"TO 'backup_env_reuse_siz.csv' CSV HEADER")
    L.append("")
    return "\n".join(L)


def gen_provenance(rows):
    L = ["artifact,output_kind,output_key,source,source_detail"]
    for r in rows:
        L.append(f"01_component_prices.sql,price_insert,comp_price_id={r['comp_price_id']},"
                 f"t_prc_component_prices_ENV.csv,"
                 f"line:{r['src_line']}|{r['placeholder']}->{r['siz_cd']}|mat:{r['mat_cd']}|"
                 f"min_qty:{r['min_qty']}|unit_price:{r['unit_price']}")
    return "\n".join(L)


def main():
    rows = load_env_prices()

    # --- 정합 가드 (발명 0·누락 0 검증) -------------------------------
    assert len(rows) == 40, f"ENV 가격행 수 {len(rows)} != 40"
    pid = [r["comp_price_id"] for r in rows]
    assert len(set(pid)) == 40, f"comp_price_id PK 중복 — distinct {len(set(pid))} != 40"
    pid_int = sorted(int(p) for p in pid)
    assert pid_int == list(range(1713, 1753)), f"comp_price_id 1713..1752 연속 아님: {pid_int[0]}..{pid_int[-1]}"
    assert all(r["comp_cd"] == ENV_COMP_CD for r in rows), "comp_cd 전건 COMP_ENV_MAKING 아님"
    unresolved = [r for r in rows if r["siz_cd"] not in ENV_SIZ_CDS]
    assert not unresolved, f"미해소 siz 가격행 {len(unresolved)} — 권위표 누락"
    assert all(r["mat_cd"] in ENV_MAT_CDS for r in rows), "mat_cd 전건 MAT_000159/168 아님"
    siz_cnt = Counter(r["siz_cd"] for r in rows)
    mat_cnt = Counter(r["mat_cd"] for r in rows)
    qty_cnt = Counter(r["min_qty"] for r in rows)
    assert all(c == 10 for c in siz_cnt.values()) and len(siz_cnt) == 4, f"siz별 10 아님: {dict(siz_cnt)}"
    assert all(c == 20 for c in mat_cnt.values()) and len(mat_cnt) == 2, f"mat별 20 아님: {dict(mat_cnt)}"
    assert all(c == 8 for c in qty_cnt.values()) and len(qty_cnt) == 5, f"수량밴드별 8 아님: {dict(qty_cnt)}"
    assert all(not r["clr_cd"] and not r["coat_side_cnt"] and not r["bdl_qty"] for r in rows), \
        "clr/coat/bdl 전건 공란(NULL) 아님 — source 와 불일치"

    def w(name, content):
        with open(os.path.join(OUTDIR, name), "w", encoding="utf-8") as f:
            f.write(content)

    w("01_component_prices.sql", gen_component_prices_sql(rows))
    w("migrate.sql", gen_migrate_sql(rows))
    w("undo.sql", gen_undo_sql(rows))
    w("backup.sql", gen_backup_sql(rows))
    w("migrate.provenance.csv", gen_provenance(rows))

    # 요약 (stdout — 비밀값 없음)
    print(f"[gen] ENV 가격행      : {len(rows)}  (comp_price_id {pid_int[0]}..{pid_int[-1]})")
    print(f"[gen] siz 재사용      : {sorted(siz_cnt)} (각 {dict(siz_cnt)} — mint 0, EXACT 재사용)")
    print(f"[gen] mat            : {dict(mat_cnt)} (MAT_000159 모조120g / MAT_000168 레자크 대표)")
    print(f"[gen] 수량밴드        : {sorted(int(q) for q in qty_cnt)} (각 {dict(qty_cnt)})")
    print(f"[gen] comp_price_id distinct : {len(set(pid))}/{len(pid)}  (PK 중복 0 필수)")
    print(f"[gen] siz 등록 0 · 바인딩 0 · 코드행 0 — 가격행 ONLY (가장 단순 GO 트랙)")


if __name__ == "__main__":
    main()
