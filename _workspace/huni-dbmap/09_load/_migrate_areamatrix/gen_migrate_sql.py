#!/usr/bin/env python3
# =====================================================================
# gen_migrate_sql.py — 면적매트릭스 좌표 siz 등록 + 면적 component_prices 마이그레이션 생성기
#
#   입력(권위, verbatim — 손편집 금지):
#     - 02_mapping/load_price_correction/areamatrix-siz-registration.csv  (308 distinct 좌표)
#     - 02_mapping/load_price/t_prc_component_prices.csv                  (면적 source rows)
#   산출:
#     - 01_siz_register.sql      211 NEW 좌표 siz INSERT (ON CONFLICT (siz_cd) DO NOTHING)
#     - 02_component_prices.sql  면적 component_prices INSERT (ON CONFLICT 자연키8 DO NOTHING)
#     - migrate.sql              BEGIN → 01 → 02 (로더가 ROLLBACK/COMMIT 주입)
#     - undo.sql                 등록 211 siz + 추가 면적 prices 제거
#     - backup.sql               (읽기전용) 영향 comp_cd 스냅샷 + 신규 siz_cd 목록
#     - migrate.provenance.csv   생성행 → source CSV 출처 추적
#
#   원칙(round-5):
#     - 멱등성(R1): 모든 INSERT는 ON CONFLICT 가드.
#     - 원자성(R2): 단일 트랜잭션(migrate.sql). 중간 COMMIT 없음.
#     - 재현성(R3): CSV 위 스크립트 생성. 같은 입력 → 같은 출력.
#     - search-before-mint: 211 NEW만 신규 siz_cd 발급(라이브 max 이후, 충돌 0 확인됨).
#                           97 reuse(EXACT/REVERSED)는 areamatrix CSV의 existing_siz_cd 재사용.
#     - 발명 0: siz_nm/치수는 WxH 데이터만(width_mm/height_mm). 발명 금지.
#   읽기전용. DB 쓰기·DDL·COMMIT 0. 비밀번호 미출력.
# =====================================================================
import csv
import os

# ---- 경로 (절대) -----------------------------------------------------
ROOT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap"
AREAMATRIX = os.path.join(ROOT, "02_mapping/load_price_correction/areamatrix-siz-registration.csv")
COMPONENT_PRICES = os.path.join(ROOT, "02_mapping/load_price/t_prc_component_prices.csv")
OUTDIR = os.path.join(ROOT, "09_load/_migrate_areamatrix")

# ---- 라이브 검증 상수 (read-only SELECT 결과, 본 세션) ----------------
#   live max siz_cd = SIZ_000500 (count 500). 신규 블록 SIZ_000511..SIZ_000721 = 211, 점유 0 확인.
#   교차등록 조율(번호 충돌 회피): round-5 sticker 원형이 SIZ_000501~510(10종)을 선점 예약 →
#   면적 신규는 그 다음 SIZ_000511부터 시작한다. (501~510 라이브 부재 + sticker 예약 = 면적 미사용.)
SIZ_NEW_START = 511  # 라이브 max(500)+1=501은 sticker 원형 예약(501~510) → 면적은 511부터. 충돌 0 검증 완료.
APPLY_YMD = "2026-06-01"  # source CSV apply_ymd (면적 row 전건 동일)

# 좌표 siz_cd 발급 결정성: NONE 행을 (group, width_mm asc, height_mm asc) 정렬해 연번 배정.
SORT_GROUPS = ["POSTER", "ACRYL"]  # POSTER 먼저, 그다음 ACRYL (안정적 연번)


def load_areamatrix():
    """areamatrix CSV → 좌표 매핑. NONE에 신규 siz_cd 배정, reuse는 existing_siz_cd."""
    rows = []
    with open(AREAMATRIX, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows.append(r)

    # NONE(신규) 행만 결정적 정렬 → 연번 배정
    none_rows = [r for r in rows if r["match_status"] == "NONE"]
    none_rows.sort(key=lambda r: (SORT_GROUPS.index(r["group"]), int(r["width_mm"]), int(r["height_mm"])))

    new_assignment = {}  # (group, wxh) -> new siz_cd
    seq = SIZ_NEW_START
    for r in none_rows:
        siz_cd = f"SIZ_{seq:06d}"
        new_assignment[(r["group"], r["wxh"])] = siz_cd
        seq += 1
    new_count = seq - SIZ_NEW_START

    # 전체 매핑: pending token -> resolved siz_cd, + siz 등록 레코드
    token_to_siz = {}   # 'POSTER'/'ACRYL' + wxh -> resolved siz_cd
    register = []       # 신규 등록 211: dict(siz_cd, siz_nm, w, h, group, wxh)
    reuse = []          # 재사용 97: dict(group, wxh, siz_cd, match_status)
    for r in rows:
        group, wxh = r["group"], r["wxh"]
        w, h = int(r["width_mm"]), int(r["height_mm"])
        if r["match_status"] == "NONE":
            siz_cd = new_assignment[(group, wxh)]
            register.append({"siz_cd": siz_cd, "siz_nm": wxh, "w": w, "h": h,
                             "group": group, "wxh": wxh})
        else:  # EXACT / REVERSED
            siz_cd = r["existing_siz_cd"]
            reuse.append({"group": group, "wxh": wxh, "siz_cd": siz_cd,
                          "match_status": r["match_status"]})
        token_to_siz[(group, wxh)] = siz_cd

    # 신규 siz 등록은 발급 연번순으로
    register.sort(key=lambda x: x["siz_cd"])
    assert new_count == len(register), f"신규 배정 불일치 {new_count} != {len(register)}"
    return token_to_siz, register, reuse


def load_area_component_prices(token_to_siz):
    """component_prices source → 면적 rows(670 POSTER + 237 ACRYL), siz_cd 치환.
       10 고정가 placeholder(A1/5x5/5x7/8x8/8x10)는 areamatrix에 부재 → 제외(별도 _migrate_fixedprice 처리)."""
    out = []          # dict(comp_cd, apply_ymd, siz_cd, ...) 적재행
    excluded = []     # 제외된 10 고정가 placeholder
    with open(COMPONENT_PRICES, encoding="utf-8-sig") as f:
        for lineno, r in enumerate(csv.DictReader(f), start=2):  # 헤더=1
            siz = r["siz_cd"]
            if siz.startswith("SIZ_PENDING_POSTER_"):
                group, wxh = "POSTER", siz[len("SIZ_PENDING_POSTER_"):]
            elif siz.startswith("SIZ_PENDING_ACRYL_"):
                group, wxh = "ACRYL", siz[len("SIZ_PENDING_ACRYL_"):]
            else:
                continue  # 면적 행 아님 (다른 PENDING/실제 siz)
            resolved = token_to_siz.get((group, wxh))
            if resolved is None:
                excluded.append((lineno, siz))  # areamatrix 부재 = 고정가 placeholder
                continue
            out.append({
                "src_line": lineno,
                "comp_price_id": r["comp_price_id"],  # surrogate PK = 충돌키(committed _exec_price 패턴 일치)
                "comp_cd": r["comp_cd"],
                "apply_ymd": r["apply_ymd"],
                "siz_cd": resolved,
                "clr_cd": r["clr_cd"],
                "mat_cd": r["mat_cd"],
                "coat_side_cnt": r["coat_side_cnt"],
                "bdl_qty": r["bdl_qty"],
                "min_qty": r["min_qty"],
                "unit_price": r["unit_price"],
                "note": r["note"],
            })
    return out, excluded


# ---- SQL 직렬화 헬퍼 --------------------------------------------------
def sql_str(v):
    if v is None or v == "":
        return "NULL"
    return "'" + str(v).replace("'", "''") + "'"


def sql_num(v):
    if v is None or v == "":
        return "NULL"
    return str(v)


def gen_siz_register_sql(register):
    """01_siz_register.sql — 211 NEW 좌표 siz INSERT."""
    L = []
    L.append("-- =====================================================================")
    L.append("-- STEP 1: 면적매트릭스 좌표 siz 등록 (t_siz_sizes) — 211 NEW, 멱등")
    L.append("--   siz_nm = 'WxH' (라이브 컨벤션 일관). cut/work = (width, height).")
    L.append("--   search-before-mint: 라이브 max=SIZ_000500, 신규 블록 SIZ_000511.. 충돌 0 검증.")
    L.append("--   501~510은 round-5 sticker 원형 예약 → 면적은 511부터(교차등록 조율).")
    L.append("--   97 reuse(EXACT/REVERSED)는 재등록하지 않음(기존 재사용).")
    L.append(f"--   **후니 master-data 등록 결정 대상: 아래 {len(register)} 신규 siz** (인간 승인).")
    L.append("-- =====================================================================")
    for x in register:
        # cut = 절단(완성)치수 = WxH 그대로. work = 작업치수 = WxH 그대로(면적 직접입력형, margin 0).
        cols = "(siz_cd, siz_nm, work_width, work_height, cut_width, cut_height, " \
               "margin_top, margin_bot, margin_lft, margin_rgt, impos_yn, use_yn, note, reg_dt, del_yn)"
        note = f"면적매트릭스 좌표 ({x['group']}) 가로{x['w']}mm×세로{x['h']}mm. round-2 면적-좌표 정정 등록"
        vals = (f"({sql_str(x['siz_cd'])}, {sql_str(x['siz_nm'])}, "
                f"{x['w']}.00, {x['h']}.00, {x['w']}.00, {x['h']}.00, "
                f"0.00, 0.00, 0.00, 0.00, 'N', 'Y', {sql_str(note)}, now(), 'N')")
        L.append(f"INSERT INTO t_siz_sizes {cols} VALUES {vals} ON CONFLICT (siz_cd) DO NOTHING;")
    L.append("")
    return "\n".join(L)


def gen_component_prices_sql(rows):
    """02_component_prices.sql — 면적 component_prices INSERT (자연키8 ON CONFLICT)."""
    L = []
    L.append("-- =====================================================================")
    L.append("-- STEP 2: 면적 component_prices 적재 (t_prc_component_prices)")
    L.append(f"--   {len(rows)} 면적 행 (POSTER 670 + ACRYL 237). siz_cd = 등록/재사용 좌표로 치환.")
    L.append("--   comp_price_id = source CSV 의 surrogate PK 값 명시(committed _exec_price 04 패턴 일치).")
    L.append("--   라이브 검증: 907 comp_price_id 전건 라이브 부재(충돌 0). IDENTITY GENERATED BY DEFAULT 라 명시 삽입 가능.")
    L.append("--   ON CONFLICT (comp_price_id) DO NOTHING — 충돌키 = 라이브 PK(surrogate). 재실행 시 no-op(R1).")
    L.append("--   ACRYL = 인쇄가공비 매트릭스(수량할인/후가공은 별도 적용단). off-grid ceiling = 런타임(미저장).")
    L.append("--   참고: 21건은 REVERSED siz 재사용으로 (comp_cd,siz_cd)가 동일해지나 comp_price_id는 distinct →")
    L.append("--         전 907행 적재. 동일 좌표 = 동일 unit_price(SAME-PRICE 검증) → 룩업 모순 0.")
    L.append("-- =====================================================================")
    cols = "(comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)"
    for r in rows:
        note = r["note"]
        vals = (f"({sql_num(r['comp_price_id'])}, {sql_str(r['comp_cd'])}, {sql_str(r['apply_ymd'])}, {sql_str(r['siz_cd'])}, "
                f"{sql_str(r['clr_cd'])}, {sql_str(r['mat_cd'])}, {sql_num(r['coat_side_cnt'])}, "
                f"{sql_num(r['bdl_qty'])}, {sql_num(r['min_qty'])}, {sql_num(r['unit_price'])}, "
                f"{sql_str(note)}, now())")
        L.append(f"-- src: load_price/t_prc_component_prices.csv:{r['src_line']} comp_price_id={r['comp_price_id']}")
        L.append(f"INSERT INTO t_prc_component_prices {cols} VALUES {vals} "
                 f"ON CONFLICT (comp_price_id) DO NOTHING;")
    L.append("")
    return "\n".join(L)


def gen_migrate_sql(register, price_rows):
    L = []
    L.append("-- =====================================================================")
    L.append("-- 면적매트릭스 좌표 siz 등록 + 면적 component_prices 마이그레이션 (migrate.sql)")
    L.append("-- 생성: gen_migrate_sql.py (입력 CSV verbatim, 손편집 금지)")
    L.append("-- 단일 트랜잭션. 로더(apply.sh)가 ROLLBACK 주입(기본 DRY-RUN), --commit=인간 승인.")
    L.append("-- 면적 13(실사11+현수막2) + 아크릴은 이미 PRF_POSTER_FIXED 바인딩 — 재바인딩 없음(가드로 확인).")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("\\timing on")
    L.append("BEGIN;")
    L.append("")
    L.append("-- 가드 0: 면적 13(실사11+현수막2) + 아크릴 3소재가 PRF_POSTER_FIXED에 바인딩되어 있는지 확인.")
    L.append("--          (재바인딩하지 않음 — 이미 GO 커밋. 좌표 siz + 면적 단가만 추가.)")
    L.append("DO $$")
    L.append("DECLARE n int;")
    L.append("BEGIN")
    L.append("  SELECT count(*) INTO n FROM t_prd_product_price_formulas")
    L.append("   WHERE prd_cd IN ('PRD_000118','PRD_000119','PRD_000120','PRD_000121','PRD_000122','PRD_000123',")
    L.append("                    'PRD_000124','PRD_000125','PRD_000126','PRD_000127','PRD_000128','PRD_000138','PRD_000139')")
    L.append("     AND frm_cd='PRF_POSTER_FIXED';")
    L.append("  IF n < 13 THEN")
    L.append("    RAISE WARNING '면적 13 PRF_POSTER_FIXED 바인딩이 13 미만 (실제 %). 재바인딩은 하지 않음 — 확인만.', n;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("\\i 01_siz_register.sql")
    L.append("\\i 02_component_prices.sql")
    L.append("")
    L.append("-- 적재 후 어서션 (롤백 전 검증용 — DRY-RUN/검증에서 사용)")
    L.append("-- 1) FK 고아: 본 마이그레이션 907 면적행(comp_price_id IN ...)의 siz_cd 가 전건 t_siz_sizes에 존재 (0행=PASS).")
    L.append("--    주의: 라이브 기존 COMP_POSTEROPT_BANNER_* 17행은 siz_cd=NULL 선존재 고아(별도 add-on, 본 범위 외) → 제외.")
    pid_in = ", ".join(str(r["comp_price_id"]) for r in price_rows)
    L.append("DO $$")
    L.append("DECLARE orphan int;")
    L.append("BEGIN")
    L.append("  SELECT count(*) INTO orphan FROM t_prc_component_prices cp")
    L.append("   LEFT JOIN t_siz_sizes s ON s.siz_cd = cp.siz_cd")
    L.append(f"   WHERE cp.comp_price_id IN ({pid_in}) AND s.siz_cd IS NULL;")
    L.append("  RAISE NOTICE '[assert] 본 적재 907행 FK 고아(siz 미해소, 0이어야 PASS): %', orphan;")
    L.append("  IF orphan <> 0 THEN")
    L.append("    RAISE EXCEPTION '적재행 FK 고아 % 건 — siz 미등록. 중단.', orphan;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("COMMIT;")
    L.append("")
    return "\n".join(L)


def gen_undo_sql(register, price_rows):
    new_siz = [x["siz_cd"] for x in register]
    price_ids = [r["comp_price_id"] for r in price_rows]
    L = []
    L.append("-- =====================================================================")
    L.append("-- 면적매트릭스 마이그레이션 역실행 (undo.sql)")
    L.append("--   등록한 211 좌표 siz + 추가한 907 면적 component_prices 를 제거한다. 단일 트랜잭션.")
    L.append("--   기본 ROLLBACK(undo.sh DRY-RUN). --commit=인간 승인.")
    L.append("--   t_siz_sizes는 INSERT-only였으므로 backup = 신규 siz_cd 목록(아래 IN절이 권위).")
    L.append("--   component_prices는 comp_price_id(surrogate PK)로 정밀 제거 → 본 마이그레이션 적재분만, 무차별 0.")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("BEGIN;")
    L.append("")
    L.append("-- 1) 면적 component_prices 907행 제거 — comp_price_id(PK) IN 으로 정밀(본 적재분만).")
    pid_in = ", ".join(str(p) for p in price_ids)
    L.append(f"DELETE FROM t_prc_component_prices WHERE comp_price_id IN ({pid_in});")
    L.append("")
    L.append("-- 2) 등록한 211 좌표 siz 제거 (참조 면적행 제거 후라 FK 안전)")
    siz_in = ", ".join(f"'{s}'" for s in new_siz)
    L.append(f"DELETE FROM t_siz_sizes WHERE siz_cd IN ({siz_in});")
    L.append("")
    L.append("COMMIT;")
    L.append("")
    return "\n".join(L)


def gen_backup_sql(register, price_rows):
    new_siz = [x["siz_cd"] for x in register]
    comp_cds = sorted(set(r["comp_cd"] for r in price_rows))
    L = []
    L.append("-- =====================================================================")
    L.append("-- backup.sql — 읽기전용 백업 스냅샷 (undo 권위본)")
    L.append("--   t_siz_sizes는 INSERT-only → backup = 신규 발급할 siz_cd 목록(파일로 박제).")
    L.append("--   영향 comp_cd 의 기존 면적행(있다면) 스냅샷 → 적재 전/후 대조.")
    L.append("--   DB 쓰기 없음(\\copy out 만).")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("-- 1) 신규 발급 예정 siz_cd 목록 (undo 권위) — 본 파일이 박제, 추가로 라이브 부재 확증")
    siz_in = ", ".join(f"'{s}'" for s in new_siz)
    L.append(f"\\copy (SELECT '{new_siz[0]}' AS first_new, '{new_siz[-1]}' AS last_new, "
             f"{len(new_siz)} AS new_count) TO 'backup_new_siz_range.csv' CSV HEADER")
    L.append(f"\\copy (SELECT siz_cd FROM t_siz_sizes WHERE siz_cd IN ({siz_in}) ORDER BY siz_cd) "
             f"TO 'backup_existing_collisions.csv' CSV HEADER  -- 0행이어야 정상(충돌 없음)")
    L.append("")
    L.append("-- 2) 영향 comp_cd 의 기존 component_prices 스냅샷 (적재 전 상태)")
    comp_in = ", ".join(f"'{c}'" for c in comp_cds)
    L.append(f"\\copy (SELECT comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price "
             f"FROM t_prc_component_prices WHERE comp_cd IN ({comp_in}) ORDER BY comp_cd, siz_cd) "
             f"TO 'backup_area_component_prices_before.csv' CSV HEADER")
    L.append("")
    return "\n".join(L)


def gen_provenance(register, price_rows):
    L = ["artifact,output_kind,output_key,source_csv,source_detail"]
    for x in register:
        L.append(f"01_siz_register.sql,siz_insert,{x['siz_cd']},"
                 f"areamatrix-siz-registration.csv,{x['group']}/{x['wxh']} (NONE→new)")
    for r in price_rows:
        L.append(f"02_component_prices.sql,price_insert,comp_price_id={r['comp_price_id']},"
                 f"t_prc_component_prices.csv,line:{r['src_line']}|siz:{r['siz_cd']}|comp:{r['comp_cd']}")
    return "\n".join(L)


def main():
    token_to_siz, register, reuse = load_areamatrix()
    price_rows, excluded = load_area_component_prices(token_to_siz)

    # 출력
    def w(name, content):
        with open(os.path.join(OUTDIR, name), "w", encoding="utf-8") as f:
            f.write(content)

    w("01_siz_register.sql", gen_siz_register_sql(register))
    w("02_component_prices.sql", gen_component_prices_sql(price_rows))
    w("migrate.sql", gen_migrate_sql(register, price_rows))
    w("undo.sql", gen_undo_sql(register, price_rows))
    w("backup.sql", gen_backup_sql(register, price_rows))
    w("migrate.provenance.csv", gen_provenance(register, price_rows))

    # 요약 (stdout — 비밀값 없음)
    poster_prices = sum(1 for r in price_rows if r["comp_cd"].startswith("COMP_POSTER_"))
    acryl_prices = sum(1 for r in price_rows if r["comp_cd"].startswith("COMP_ACRYL_"))
    print(f"[gen] 신규 등록 siz : {len(register)}  (SIZ_{SIZ_NEW_START:06d}..{register[-1]['siz_cd']})")
    print(f"[gen] 재사용 siz    : {len(reuse)}  (EXACT/REVERSED, 재등록 안 함)")
    print(f"[gen] 면적 prices   : {len(price_rows)}  (POSTER {poster_prices} + ACRYL {acryl_prices})")
    print(f"[gen] 제외(고정가 placeholder) : {len(excluded)} 행 → {sorted(set(t for _,t in excluded))}")
    # 내부 중복 검사 (자연키8) — REVERSED siz 재사용으로 발생 가능.
    #   ACRYL 직접입력형은 면적만으로 가격 결정 → 역방향(WxH↔HxW)이 같은 siz_cd로 수렴.
    #   SAME-PRICE 중복 = 무손실 dedup(ON CONFLICT DO NOTHING 안전). DIFF-PRICE 중복 = 손실위험 → HARD FAIL.
    from collections import defaultdict
    byk = defaultdict(list)
    for r in price_rows:
        k = (r["comp_cd"], r["apply_ymd"], r["siz_cd"], r["clr_cd"], r["mat_cd"],
             r["coat_side_cnt"], r["bdl_qty"], r["min_qty"])
        byk[k].append(r)
    same_price_dup = 0
    diff_price_dup = []
    for k, v in byk.items():
        if len(v) > 1:
            prices = set(x["unit_price"] for x in v)
            if len(prices) == 1:
                same_price_dup += len(v) - 1
            else:
                diff_price_dup.append((k, sorted(prices)))
    distinct_keys = len(byk)
    # comp_price_id(PK) 충돌키 사용 → 907 전건 적재(중복 no-op 아님). 아래는 정보용 정합 점검.
    pid = [r["comp_price_id"] for r in price_rows]
    print(f"[gen] comp_price_id distinct : {len(set(pid))}/{len(pid)}  (PK 중복 0 필수)")
    print(f"[gen] (참고) (comp_cd,siz_cd) 동일행 {same_price_dup}건 = REVERSED siz 수렴, 전건 SAME-PRICE(룩업 모순 0)")
    if diff_price_dup:
        print(f"[gen] !!! DIFF-PRICE (동일 좌표·상이 단가) : {len(diff_price_dup)} → 적재 거부, 라우팅 필요 !!!")
        for k, ps in diff_price_dup:
            print(f"       {k} prices={ps}")
        raise SystemExit("DIFF-PRICE 동일좌표 충돌 — 침묵 금지. designer 라우팅.")


if __name__ == "__main__":
    main()
