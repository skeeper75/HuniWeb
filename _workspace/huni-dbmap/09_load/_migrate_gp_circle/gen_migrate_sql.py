#!/usr/bin/env python3
# =====================================================================
# gen_migrate_sql.py — GP 합판도무송 원형 직경 siz 등록 + GP 가격 + 066 size link 마이그레이션 생성기
#
#   대상(자율 quick win — round-5 적재 실행본 / 가격·상품마스터 교차):
#     COMP_GANGPAN_PRINT(GP·합판도무송 인쇄가공비) 원형 직경 100 차단행을 실 적재가능하게 만든다.
#     35mm(10행)는 이미 SIZ_000422로 committed _exec_price GO 번들에 적재됨 → 본 트랙 제외.
#     비-35mm 10 직경(10/15/20/25/30/40/45/50/55/60mm) = 100행(10직경×2mat×5수량밴드).
#
#   입력(권위, verbatim — 손편집 금지):
#     - 09_load/sticker/_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv  (직경 치수 L1 추출·발명0)
#     - 02_mapping/load_price/t_prc_component_prices.csv                     (GP 가격 source rows)
#     - 09_load/_assembled/code-row-preload.md §2                            (siz_cd 배정 권위표)
#   산출:
#     - 01_siz_register.sql      10 NEW 원형 siz INSERT  (ON CONFLICT (siz_cd) DO NOTHING)
#     - 02_component_prices.sql  100 GP 가격 INSERT        (auto-IDENTITY + 자연키 NOT EXISTS 가드)
#     - 03_product_sizes.sql     11 PRD_000066 원형 size link (ON CONFLICT (prd_cd, siz_cd) DO NOTHING)
#     - migrate.sql              BEGIN → step00 setval → 가드0 → 01 → 02 → 03 → assert → COMMIT
#     - undo.sql                 등록 10 siz + 100 GP prices + 11 size link 제거 (가격=자연키 DELETE)
#     - backup.sql               (읽기전용) 신규 siz_cd 부재 확증 + 영향 GP comp 스냅샷
#     - migrate.provenance.csv   생성행 → source CSV 출처 추적
#
#   [수정 2026-06-07 — 라이브 DRY-RUN 적발 결함]
#     기존 02 는 명시 comp_price_id(2956~3065) + ON CONFLICT (comp_price_id) DO NOTHING 이었다.
#     라이브 확증: comp_price_id 는 IDENTITY(BY DEFAULT)·시퀀스 stale(last_value=2 vs MAX=4805).
#       (1) 명시 ID 는 시퀀스를 무시 → 이후 auto-IDENTITY INSERT 가 그 ID 를 재발급해 충돌·비멱등.
#       (2) ON CONFLICT(comp_price_id) 는 명시 ID 가 우연히 라이브에 있으면 자연키 무관하게
#           가격행을 silently skip → under-load (디지털인쇄 04 와 동일 부류 결함).
#     수정: 02 를 comp_price_id 생략(auto-IDENTITY) + 자연키(8) NOT EXISTS 멱등 가드로 전환.
#           migrate.sql step 00 에 setval 추가(시퀀스→MAX) → 100행 4806~ 발급(충돌 0).
#           undo 도 자연키(comp_cd + siz 501~510) DELETE 로 전환(id 미상이므로 PK IN 불가).
#
#   원칙(round-5):
#     - 멱등성(R1): siz/link = ON CONFLICT(PK) 가드. 가격 = 자연키 NOT EXISTS(IS NOT DISTINCT FROM)
#                   — GP 가격은 clr/coat/bdl 차원 NULL 이고 자연키 UNIQUE 가 NULLS DISTINCT 라
#                   ON CONFLICT 무력 → NOT EXISTS 로 NULL-safe 매칭(디지털인쇄 04 와 동일 패턴).
#     - 원자성(R2): 단일 트랜잭션(migrate.sql). 중간 COMMIT 없음.
#     - 재현성(R3): CSV/권위표 위 스크립트 생성. 같은 입력 → 같은 출력.
#     - FK 위상순(R): siz → component_prices, siz → product_sizes. 부모(siz) 먼저.
#     - search-before-mint: 10 비-35mm 직경만 신규(라이브 max=SIZ_000500, 501~510 sticker 예약 점유).
#                           35mm = 기존 SIZ_000422 재사용(committed). 발명 0.
#     - reg_dt NOT NULL DEFAULT 교훈(round-5): component_prices는 reg_dt 컬럼 미포함(DEFAULT now() 발화).
#                           product_sizes는 source reg_dt 실값('2026-06-05')을 명시(공란 아님 → NULL 위험 없음).
#   읽기전용. DB 쓰기·DDL·COMMIT 0. 비밀번호 미출력.
# =====================================================================
import csv
import os

# ---- 경로 (절대) -----------------------------------------------------
ROOT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap"
SIZE_BLOCKED = os.path.join(ROOT, "09_load/sticker/_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv")
COMPONENT_PRICES = os.path.join(ROOT, "02_mapping/load_price/t_prc_component_prices.csv")
OUTDIR = os.path.join(ROOT, "09_load/_migrate_gp_circle")

# ---- siz_cd 배정 권위표 (09_load/_assembled/code-row-preload.md §2, verbatim) -------
#   라이브 max(SIZ_000500)+1 = 501부터. 35mm는 422 재사용(번호 미소비, 점프).
#   직경(mm) → (siz_cd, siz_nm). 발명 아님 — code-row-preload.md §2 표 그대로.
DIAM_TO_SIZ = {
    10: ("SIZ_000501", "원형10x10"),
    15: ("SIZ_000502", "원형15x15"),
    20: ("SIZ_000503", "원형20x20"),
    25: ("SIZ_000504", "원형25x25"),
    30: ("SIZ_000505", "원형30x30"),
    # 35mm = SIZ_000422 (committed 재사용, 신규 등록 안 함)
    40: ("SIZ_000506", "원형40x40"),
    45: ("SIZ_000507", "원형45x45"),
    50: ("SIZ_000508", "원형50x50"),
    55: ("SIZ_000509", "원형55x55"),
    60: ("SIZ_000510", "원형60x60"),
}
SIZ_35MM_REUSE = "SIZ_000422"   # 원형35x35 — committed 재사용(신규 아님)
NEW_SIZ_CDS = [DIAM_TO_SIZ[d][0] for d in sorted(DIAM_TO_SIZ)]   # 10종 신규 siz_cd
PLACEHOLDER_PREFIX = "SIZ_PENDING_GP_원형"   # 02_mapping CSV placeholder 접두


def diam_from_placeholder(siz):
    """'SIZ_PENDING_GP_원형40mm' → 40 (int). GP 원형 placeholder 아니면 None."""
    if not siz.startswith(PLACEHOLDER_PREFIX):
        return None
    tail = siz[len(PLACEHOLDER_PREFIX):]   # '40mm'
    if not tail.endswith("mm"):
        return None
    try:
        return int(tail[:-2])
    except ValueError:
        return None


def load_size_dimensions():
    """BLOCKED size CSV → 직경(mm) → (cut_width, cut_height, dflt_yn, disp_seq, reg_dt, ea).
       cut_width=cut_height=직경(원형). _l1_shape_name/_ea/_block_reason 는 메타(DB 컬럼 아님)."""
    by_diam = {}
    with open(SIZE_BLOCKED, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            cw = r["_cut_width_mm"].strip()
            ch = r["_cut_height_mm"].strip()
            diam = int(float(cw))
            assert int(float(ch)) == diam, f"원형 비정방 {cw}x{ch} — 발명 금지, 중단"
            by_diam[diam] = {
                "cut_width": cw,        # '10.00' 등 verbatim
                "cut_height": ch,
                "dflt_yn": r["dflt_yn"].strip(),       # 'N'
                "disp_seq": r["disp_seq"].strip(),     # '27'..'37'
                "reg_dt": r["reg_dt"].strip(),         # '2026-06-05 00:00:00' (실값, 공란 아님)
                "ea": r["_ea"].strip(),                # 판당 EA(=bundle 차원, size 아님 — note 보존용)
                "shape": r["_l1_shape_name"].strip(),  # '원형 10mm (8EA)'
            }
    return by_diam


def load_gp_component_prices():
    """component_prices source → GP 원형 비-35mm 100행. placeholder→실 siz_cd 치환.
       comp_price_id verbatim(committed _exec_price 04 패턴). note 에 [siz-corrected:…] 접두."""
    out = []
    excluded_35 = 0
    with open(COMPONENT_PRICES, encoding="utf-8-sig") as f:
        for lineno, r in enumerate(csv.DictReader(f), start=2):  # 헤더=1
            siz = r["siz_cd"]
            diam = diam_from_placeholder(siz)
            if diam is None:
                continue                       # GP 원형 placeholder 아님
            if diam == 35:
                excluded_35 += 1               # 35mm = committed 적재분, 본 트랙 제외
                continue
            if diam not in DIAM_TO_SIZ:
                raise SystemExit(f"미배정 직경 {diam}mm (CSV line {lineno}) — 권위표 부재, 중단")
            real_siz = DIAM_TO_SIZ[diam][0]
            note_prefix = f"[siz-corrected: {siz}→{real_siz}] "
            out.append({
                "src_line": lineno,
                "comp_price_id": r["comp_price_id"],      # surrogate PK = 충돌키
                "comp_cd": r["comp_cd"],                  # COMP_GANGPAN_PRINT
                "apply_ymd": r["apply_ymd"],              # '2026-06-01'
                "placeholder": siz,
                "siz_cd": real_siz,
                "clr_cd": r["clr_cd"],
                "mat_cd": r["mat_cd"],                    # MAT_000084 / MAT_000153
                "coat_side_cnt": r["coat_side_cnt"],
                "bdl_qty": r["bdl_qty"],
                "min_qty": r["min_qty"],                  # 1000..5000
                "unit_price": r["unit_price"],
                "note": note_prefix + r["note"],
            })
    return out, excluded_35


def build_size_links(dims):
    """PRD_000066 원형 size link 11행: 신규 10(501~510) + 재사용 35mm(SIZ_000422).
       (MINT_NEEDED) → 실 siz_cd 치환. dflt_yn/disp_seq/reg_dt verbatim."""
    links = []
    for diam in sorted(dims):
        d = dims[diam]
        if diam == 35:
            siz_cd = SIZ_35MM_REUSE                       # 재사용(committed 라이브 실재)
            note = "원형35mm size link — SIZ_000422 재사용(committed)"
        else:
            siz_cd = DIAM_TO_SIZ[diam][0]                 # 신규 501~510
            note = f"원형{diam}mm size link — 신규 {siz_cd}"
        links.append({
            "prd_cd": "PRD_000066",
            "siz_cd": siz_cd,
            "dflt_yn": d["dflt_yn"],
            "disp_seq": d["disp_seq"],
            "reg_dt": d["reg_dt"],          # '2026-06-05 00:00:00' 실값(NOT NULL DEFAULT — 공란 아님이라 안전)
            "diam": diam,
            "note": note,
        })
    return links


# ---- SQL 직렬화 헬퍼 --------------------------------------------------
def sql_str(v):
    if v is None or v == "":
        return "NULL"
    return "'" + str(v).replace("'", "''") + "'"


def sql_num(v):
    if v is None or v == "":
        return "NULL"
    return str(v)


def sql_ts(v):
    """timestamp 컬럼: 실값 있으면 리터럴, 공란이면 DEFAULT(키워드) — round-5 reg_dt 교훈.
       NOT NULL DEFAULT now() 컬럼에 명시 NULL 금지(공란→DEFAULT)."""
    if v is None or v == "":
        return "DEFAULT"
    return "'" + str(v).replace("'", "''") + "'"


# ---- STEP 1: siz 등록 -------------------------------------------------
def gen_siz_register_sql(dims):
    L = []
    L.append("-- =====================================================================")
    L.append("-- STEP 1: GP/sticker 원형 직경 siz 등록 (t_siz_sizes) — 10 NEW, 멱등")
    L.append("--   siz_nm = '원형{w}x{h}' (라이브 형제 SIZ_000419~422 컨벤션 추종, code-row-preload.md §2).")
    L.append("--   cut_width=cut_height=직경(원형), work=cut 동일, margin=0, impos_yn='N', use_yn='Y', del_yn='N'.")
    L.append("--   search-before-mint: 라이브 max=SIZ_000500. 신규 SIZ_000501~510. 35mm=SIZ_000422 재사용(미포함).")
    L.append("--   교차등록 조율: 501~510 = sticker 원형/GP 가격 공유(register ONCE). 면적매트릭스(511~721)와 불교차.")
    L.append(f"--   **후니 master-data 등록 결정 대상: 아래 {len(NEW_SIZ_CDS)} 신규 siz** (인간 승인).")
    L.append("--   치수 출처: sticker/_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv (L1, 발명 0).")
    L.append("-- =====================================================================")
    cols = ("(siz_cd, siz_nm, work_width, work_height, cut_width, cut_height, "
            "margin_top, margin_bot, margin_lft, margin_rgt, impos_yn, use_yn, note, reg_dt, del_yn)")
    for diam in sorted(dims):
        if diam == 35:
            continue   # 재사용 — 신규 등록 안 함
        siz_cd, siz_nm = DIAM_TO_SIZ[diam]
        d = dims[diam]
        cw, ch = d["cut_width"], d["cut_height"]   # '10.00' verbatim
        note = (f"합판도무송/스티커 원형 직경 {diam}mm (판당 {d['ea']}EA — bundle 차원, size 미인코딩). "
                f"sticker 066 원형 size + GP 가격 공유 siz. round-5 자율 quick win 등록")
        vals = (f"({sql_str(siz_cd)}, {sql_str(siz_nm)}, "
                f"{cw}, {ch}, {cw}, {ch}, "
                f"0.00, 0.00, 0.00, 0.00, 'N', 'Y', {sql_str(note)}, now(), 'N')")
        L.append(f"INSERT INTO t_siz_sizes {cols} VALUES {vals} ON CONFLICT (siz_cd) DO NOTHING;")
    L.append("")
    return "\n".join(L)


# ---- STEP 2: GP component_prices -------------------------------------
def gen_component_prices_sql(rows):
    L = []
    L.append("-- =====================================================================")
    L.append("-- STEP 2: GP(합판도무송) 원형 가격 적재 (t_prc_component_prices)")
    L.append(f"--   {len(rows)} GP 원형 행 (10직경×2mat[MAT_000084/153]×5수량밴드[1000..5000]). 35mm 제외(committed).")
    L.append("--   placeholder SIZ_PENDING_GP_원형NNmm → 실 siz_cd(501~510) 치환. note 에 [siz-corrected:…] 접두.")
    L.append("--")
    L.append("--   [수정 2026-06-07 — 라이브 DRY-RUN 적발 결함]")
    L.append("--   기존: comp_price_id 명시(2956~3065) + ON CONFLICT (comp_price_id) DO NOTHING.")
    L.append("--   결함: comp_price_id 는 IDENTITY(BY DEFAULT)·시퀀스 stale(last_value=2 vs MAX=4805).")
    L.append("--         명시 ID 는 시퀀스를 무시 → 향후 auto-IDENTITY INSERT 와 충돌·재실행 비멱등.")
    L.append("--         또한 ON CONFLICT(comp_price_id) 가 명시 ID 가 우연히 라이브에 있으면 가격행을")
    L.append("--         자연키 무관하게 silently skip → under-load.")
    L.append("--   수정: comp_price_id 생략(auto-IDENTITY) + 자연키 NOT EXISTS 멱등 가드.")
    L.append("--         migrate.sql step 00 setval 로 시퀀스를 MAX 로 재동기화 → 100행 4806~ 발급.")
    L.append("--   자연키(8): (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty).")
    L.append("--     GP 용 NULL 차원(clr/coat/bdl) 존재 → ux_t_prc_comp_prices_nat_key 가 NULLS DISTINCT")
    L.append("--     (라이브 indnullsnotdistinct=f)라 ON CONFLICT 무력 → IS NOT DISTINCT FROM 매칭 가드 사용.")
    L.append("--   reg_dt 미포함 — NOT NULL DEFAULT now() 발화(round-5 reg_dt 교훈 준수).")
    L.append("--   comp_cd=COMP_GANGPAN_PRINT 는 라이브 실재(35mm 행이 이미 참조). FK fk_prc_comp_prices_comp_cd PASS.")
    L.append("-- =====================================================================")
    cols = ("(comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, "
            "coat_side_cnt, bdl_qty, min_qty, unit_price, note)")
    for r in rows:
        comp_cd = sql_str(r['comp_cd'])
        apply_ymd = sql_str(r['apply_ymd'])
        siz_cd = sql_str(r['siz_cd'])
        clr_cd = sql_str(r['clr_cd'])           # 빈 → NULL
        mat_cd = sql_str(r['mat_cd'])
        coat = sql_num(r['coat_side_cnt'])       # 빈 → NULL
        bdl = sql_num(r['bdl_qty'])              # 빈 → NULL
        minq = sql_num(r['min_qty'])
        price = sql_num(r['unit_price'])
        note = sql_str(r['note'])
        # WHERE NOT EXISTS 자연키 매칭 — IS NOT DISTINCT FROM (NULL-safe equality)
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
        sel_vals = (f"{comp_cd}, {apply_ymd}, {siz_cd}, {clr_cd}, {mat_cd}, "
                    f"{coat}, {bdl}, {minq}, {price}, {note}")
        L.append(f"-- src: load_price/t_prc_component_prices.csv:{r['src_line']} (was comp_price_id={r['comp_price_id']}) "
                 f"siz:{r['placeholder']}->{r['siz_cd']}")
        L.append(f"INSERT INTO t_prc_component_prices {cols}")
        L.append(f"SELECT {sel_vals}")
        L.append("WHERE NOT EXISTS (")
        L.append("  SELECT 1 FROM t_prc_component_prices")
        L.append(f"  WHERE {where_match}")
        L.append(");")
    L.append("")
    return "\n".join(L)


# ---- STEP 3: product_sizes link --------------------------------------
def gen_product_sizes_sql(links):
    L = []
    L.append("-- =====================================================================")
    L.append("-- STEP 3: PRD_000066(합판도무송스티커) 원형 size link (t_prd_product_sizes)")
    L.append(f"--   {len(links)} 행 = 신규 10(SIZ_000501~510) + 재사용 1(SIZ_000422, 원형35mm).")
    L.append("--   충돌키 = 라이브 PK (prd_cd, siz_cd) [t_prd_product_sizes_pkey, 03_pks.tsv 63-64 확인].")
    L.append("--   (MINT_NEEDED) → 실 siz_cd 치환. dflt_yn/disp_seq/reg_dt = BLOCKED CSV verbatim.")
    L.append("--   reg_dt = '2026-06-05 00:00:00'(실값) 명시 — 공란 아님이라 NOT NULL DEFAULT 위험 없음(round-5 교훈).")
    L.append("--   FK: prd_cd→t_prd_products(PRD_000066 실재), siz_cd→t_siz_sizes(STEP1 등록 + 422 재사용).")
    L.append("--   upd_dt/del_dt 미포함(NULL 허용), del_yn 미포함→DEFAULT 'N' 발화.")
    L.append("-- =====================================================================")
    cols = "(prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt)"
    for x in links:
        vals = (f"({sql_str(x['prd_cd'])}, {sql_str(x['siz_cd'])}, {sql_str(x['dflt_yn'])}, "
                f"{sql_num(x['disp_seq'])}, {sql_ts(x['reg_dt'])})")
        L.append(f"-- {x['note']} (직경 {x['diam']}mm)")
        L.append(f"INSERT INTO t_prd_product_sizes {cols} VALUES {vals} "
                 f"ON CONFLICT (prd_cd, siz_cd) DO NOTHING;")
    L.append("")
    return "\n".join(L)


# ---- migrate.sql wrapper ---------------------------------------------
def gen_migrate_sql(price_rows, links):
    L = []
    L.append("-- =====================================================================")
    L.append("-- GP 합판도무송 원형 직경 마이그레이션 (migrate.sql)")
    L.append("-- 생성: gen_migrate_sql.py (입력 CSV verbatim, 손편집 금지)")
    L.append("-- 단일 트랜잭션. 로더(apply.sh)가 ROLLBACK 주입(기본 DRY-RUN), --commit=인간 승인.")
    L.append("-- 4단계: 00 시퀀스 재동기화 → 01 siz 등록(10) → 02 GP 가격(100) → 03 066 size link(11).")
    L.append("--        FK 위상순(siz 먼저). 35mm(SIZ_000422)는 committed _exec_price GO 번들 적재 — 무간섭.")
    L.append("--")
    L.append("-- [수정 2026-06-07 — 라이브 DRY-RUN 적발] step 00 setval 추가: comp_price_id 시퀀스")
    L.append("--   stale(last_value=2 vs MAX=4805). 02 가 auto-IDENTITY 로 전환됐으므로, 시퀀스를 MAX 로")
    L.append("--   재동기화해야 100행이 4806~ 발급(충돌 0). setval idempotent·롤백 시 영구 미반영(DRY-RUN 안전).")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("\\timing on")
    L.append("BEGIN;")
    L.append("")
    L.append("-- 단계 0: comp_price_id IDENTITY 시퀀스 재동기화 (02 auto-IDENTITY INSERT 전).")
    L.append("--   라이브 DRY-RUN 적발: 시퀀스 last_value=2 vs MAX(comp_price_id)=4805. setval 로 동기화.")
    L.append("SELECT setval('public.t_prc_component_prices_comp_price_id_seq',")
    L.append("              (SELECT COALESCE(MAX(comp_price_id), 0) FROM t_prc_component_prices), true);")
    L.append("")
    L.append("-- 가드 0: search-before-mint 불변식 — 신규 SIZ_000501~510 적재 전 라이브 부재(0)여야 정상.")
    L.append("--         >0 이면 이미 존재 → ON CONFLICT DO NOTHING 이 멱등 처리(중단 아님, NOTICE 만).")
    L.append("DO $$")
    L.append("DECLARE pre int;")
    L.append("BEGIN")
    siz_in = ", ".join(f"'{s}'" for s in NEW_SIZ_CDS)
    L.append(f"  SELECT count(*) INTO pre FROM t_siz_sizes WHERE siz_cd IN ({siz_in});")
    L.append("  IF pre = 0 THEN")
    L.append("    RAISE NOTICE '[guard0] 신규 원형 siz(501~510) 라이브 부재(0) — search-before-mint 정상.';")
    L.append("  ELSE")
    L.append("    RAISE NOTICE '[guard0] 신규 원형 siz 중 % 종이 이미 존재 — ON CONFLICT DO NOTHING 멱등 처리.', pre;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("\\i 01_siz_register.sql")
    L.append("\\i 02_component_prices.sql")
    L.append("\\i 03_product_sizes.sql")
    L.append("")
    L.append("-- 적재 후 어서션 (롤백 전 검증용 — DRY-RUN/검증에서 사용)")
    L.append("-- 1) FK 고아(siz): 본 적재 GP 가격행의 siz_cd 전건 t_siz_sizes 존재 (0=PASS).")
    L.append("--    [수정] comp_price_id 명시 폐지 → 자연키(comp_cd=COMP_GANGPAN_PRINT + siz 501~510)로 식별.")
    L.append("DO $$")
    L.append("DECLARE orphan int;")
    L.append("BEGIN")
    gp_siz_in = ", ".join(f"'{s}'" for s in NEW_SIZ_CDS)
    L.append("  SELECT count(*) INTO orphan FROM t_prc_component_prices cp")
    L.append("   LEFT JOIN t_siz_sizes s ON s.siz_cd = cp.siz_cd")
    L.append(f"   WHERE cp.comp_cd = 'COMP_GANGPAN_PRINT' AND cp.siz_cd IN ({gp_siz_in})")
    L.append("     AND s.siz_cd IS NULL;")
    L.append("  RAISE NOTICE '[assert] GP 원형 가격행 FK 고아(siz 미해소, 0=PASS): %', orphan;")
    L.append("  IF orphan <> 0 THEN")
    L.append("    RAISE EXCEPTION 'GP 가격행 FK 고아 % 건 — siz 미등록. 중단.', orphan;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("-- 1b) 적재 행수 검증: 본 트랜잭션에서 GP 원형(siz 501~510) 가격행이 정확히 100건이어야 (under-load 0).")
    L.append("DO $$")
    L.append("DECLARE gp_cnt int;")
    L.append("BEGIN")
    L.append("  SELECT count(*) INTO gp_cnt FROM t_prc_component_prices")
    L.append(f"   WHERE comp_cd = 'COMP_GANGPAN_PRINT' AND siz_cd IN ({gp_siz_in});")
    L.append("  RAISE NOTICE '[assert] GP 원형(501~510) 가격행 수(100=PASS, 1회차): %', gp_cnt;")
    L.append("  IF gp_cnt <> 100 THEN")
    L.append("    RAISE EXCEPTION 'GP 원형 가격행 % 건 (기대 100) — under/over-load. 중단.', gp_cnt;")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("-- 2) FK(comp_cd): COMP_GANGPAN_PRINT 가 t_prc_price_components 에 존재해야 (35mm 행이 이미 참조).")
    L.append("DO $$")
    L.append("DECLARE n int;")
    L.append("BEGIN")
    L.append("  SELECT count(*) INTO n FROM t_prc_price_components WHERE comp_cd = 'COMP_GANGPAN_PRINT';")
    L.append("  RAISE NOTICE '[assert] comp_cd COMP_GANGPAN_PRINT 라이브 존재(1=PASS): %', n;")
    L.append("  IF n = 0 THEN")
    L.append("    RAISE EXCEPTION 'comp_cd COMP_GANGPAN_PRINT 부재 — FK fk_prc_comp_prices_comp_cd 위반. 중단.';")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("-- 3) FK(product_sizes): 066 size link 11행 siz_cd 전건 t_siz_sizes 존재 + PRD_000066 실재.")
    L.append("DO $$")
    L.append("DECLARE link_orphan int; prd_n int;")
    L.append("BEGIN")
    link_siz = ", ".join(f"'{x['siz_cd']}'" for x in links)
    L.append("  SELECT count(*) INTO link_orphan FROM (")
    L.append(f"    SELECT unnest(ARRAY[{link_siz}]) AS siz_cd) v")
    L.append("   LEFT JOIN t_siz_sizes s ON s.siz_cd = v.siz_cd WHERE s.siz_cd IS NULL;")
    L.append("  SELECT count(*) INTO prd_n FROM t_prd_products WHERE prd_cd = 'PRD_000066';")
    L.append("  RAISE NOTICE '[assert] 066 size link siz FK 고아(0=PASS): % / PRD_000066 존재(1=PASS): %', link_orphan, prd_n;")
    L.append("  IF link_orphan <> 0 THEN")
    L.append("    RAISE EXCEPTION '066 size link FK 고아 % 건. 중단.', link_orphan;")
    L.append("  END IF;")
    L.append("  IF prd_n = 0 THEN")
    L.append("    RAISE EXCEPTION 'PRD_000066 부재 — FK fk_prd_product_sizes_prd_cd 위반. 중단.';")
    L.append("  END IF;")
    L.append("END $$;")
    L.append("")
    L.append("COMMIT;")
    L.append("")
    return "\n".join(L)


def gen_undo_sql(price_rows, links):
    L = []
    L.append("-- =====================================================================")
    L.append("-- GP 원형 마이그레이션 역실행 (undo.sql)")
    L.append("--   추가한 100 GP 가격 + 11 066 size link + 등록 10 siz 를 제거한다. 단일 트랜잭션.")
    L.append("--   기본 ROLLBACK(undo.sh DRY-RUN). --commit=인간 승인.")
    L.append("--   제거순 = 적재 역순(자식 먼저): prices → size link → siz. FK 안전.")
    L.append("--   35mm(SIZ_000422)는 committed 분이라 절대 건드리지 않음(siz 501~510 한정).")
    L.append("--")
    L.append("--   [수정 2026-06-07] comp_price_id 명시 폐지(auto-IDENTITY 전환)에 따라 가격 DELETE 를")
    L.append("--   자연키(comp_cd=COMP_GANGPAN_PRINT + siz 501~510)로 전환. id 를 모르므로 PK IN 불가.")
    L.append("--   35mm(SIZ_000422)는 siz IN 절에서 제외되므로 committed 분 보존 — 안전.")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("BEGIN;")
    L.append("")
    L.append("-- 1) GP 원형 가격 100행 제거 — 자연키(comp_cd + 신규 siz 501~510)로 정밀.")
    L.append("--    35mm(SIZ_000422)는 IN 절에서 빠지므로 committed 분 무간섭.")
    new_siz_in = ", ".join(f"'{s}'" for s in NEW_SIZ_CDS)
    L.append("DELETE FROM t_prc_component_prices")
    L.append(f" WHERE comp_cd = 'COMP_GANGPAN_PRINT' AND siz_cd IN ({new_siz_in});")
    L.append("")
    L.append("-- 2) 066 size link 중 신규 siz(501~510)분만 제거 — 35mm(SIZ_000422) link 는 보존(재사용 권위).")
    new_link_siz = ", ".join(f"'{s}'" for s in NEW_SIZ_CDS)
    L.append(f"DELETE FROM t_prd_product_sizes WHERE prd_cd = 'PRD_000066' AND siz_cd IN ({new_link_siz});")
    L.append("")
    L.append("-- 3) 등록한 10 원형 siz 제거 (참조 prices/link 제거 후라 FK 안전).")
    siz_in = ", ".join(f"'{s}'" for s in NEW_SIZ_CDS)
    L.append(f"DELETE FROM t_siz_sizes WHERE siz_cd IN ({siz_in});")
    L.append("")
    L.append("COMMIT;")
    L.append("")
    return "\n".join(L)


def gen_backup_sql(price_rows):
    comp_cds = sorted(set(r["comp_cd"] for r in price_rows))
    L = []
    L.append("-- =====================================================================")
    L.append("-- backup.sql — 읽기전용 백업 스냅샷 (undo 권위본)")
    L.append("--   t_siz_sizes는 INSERT-only → backup = 신규 발급 siz_cd(501~510) 부재 확증.")
    L.append("--   영향 comp_cd(COMP_GANGPAN_PRINT) 기존 GP 행(35mm 등 committed) 스냅샷 → 적재 전/후 대조.")
    L.append("--   DB 쓰기 없음(\\copy out 만).")
    L.append("-- =====================================================================")
    L.append("\\set ON_ERROR_STOP on")
    L.append("-- 1) 신규 발급 예정 siz_cd 범위 (undo 권위) — 본 파일이 박제 + 라이브 부재 확증.")
    siz_in = ", ".join(f"'{s}'" for s in NEW_SIZ_CDS)
    L.append(f"\\copy (SELECT '{NEW_SIZ_CDS[0]}' AS first_new, '{NEW_SIZ_CDS[-1]}' AS last_new, "
             f"{len(NEW_SIZ_CDS)} AS new_count) TO 'backup_new_siz_range.csv' CSV HEADER")
    L.append(f"\\copy (SELECT siz_cd FROM t_siz_sizes WHERE siz_cd IN ({siz_in}) ORDER BY siz_cd) "
             f"TO 'backup_existing_collisions.csv' CSV HEADER  -- 0행이어야 정상(충돌 없음)")
    L.append("")
    L.append("-- 2) 영향 comp_cd 기존 component_prices 스냅샷 (적재 전 상태 — committed 35mm 포함).")
    comp_in = ", ".join(f"'{c}'" for c in comp_cds)
    L.append(f"\\copy (SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price "
             f"FROM t_prc_component_prices WHERE comp_cd IN ({comp_in}) ORDER BY comp_price_id) "
             f"TO 'backup_gp_component_prices_before.csv' CSV HEADER")
    L.append("")
    L.append("-- 3) PRD_000066 기존 size link 스냅샷 (적재 전 — 원형 외 기존 규격 보존 확인).")
    L.append("\\copy (SELECT prd_cd, siz_cd, dflt_yn, disp_seq FROM t_prd_product_sizes "
             "WHERE prd_cd = 'PRD_000066' ORDER BY disp_seq) "
             "TO 'backup_066_product_sizes_before.csv' CSV HEADER")
    L.append("")
    return "\n".join(L)


def gen_provenance(dims, price_rows, links):
    L = ["artifact,output_kind,output_key,source,source_detail"]
    for diam in sorted(dims):
        if diam == 35:
            continue
        siz_cd, siz_nm = DIAM_TO_SIZ[diam]
        d = dims[diam]
        L.append(f"01_siz_register.sql,siz_insert,{siz_cd},"
                 f"t_prd_product_sizes_066_circle.BLOCKED.csv+code-row-preload.md§2,"
                 f"{siz_nm}|cut {d['cut_width']}x{d['cut_height']}|diam {diam}mm|{d['ea']}EA")
    for r in price_rows:
        L.append(f"02_component_prices.sql,price_insert,comp_price_id={r['comp_price_id']},"
                 f"t_prc_component_prices.csv,"
                 f"line:{r['src_line']}|{r['placeholder']}->{r['siz_cd']}|mat:{r['mat_cd']}|min_qty:{r['min_qty']}")
    for x in links:
        L.append(f"03_product_sizes.sql,size_link,PRD_000066+{x['siz_cd']},"
                 f"t_prd_product_sizes_066_circle.BLOCKED.csv,"
                 f"diam {x['diam']}mm|disp_seq {x['disp_seq']}|{x['note']}")
    return "\n".join(L)


def main():
    dims = load_size_dimensions()
    price_rows, excluded_35 = load_gp_component_prices()
    links = build_size_links(dims)

    # --- 정합 가드 (발명 0·누락 0 검증) -------------------------------
    assert len(NEW_SIZ_CDS) == 10, f"신규 siz 수 {len(NEW_SIZ_CDS)} != 10"
    assert len(price_rows) == 100, f"GP 가격행 수 {len(price_rows)} != 100 (실제 {len(price_rows)})"
    assert excluded_35 == 10, f"35mm 제외 수 {excluded_35} != 10"
    assert len(links) == 11, f"size link 수 {len(links)} != 11"
    # [수정] comp_price_id 명시 폐지(auto-IDENTITY) → 자연키(8) distinct 검증으로 전환.
    #   GP 가격 자연키: (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty).
    natkeys = [(r["comp_cd"], r["apply_ymd"], r["siz_cd"], r["clr_cd"], r["mat_cd"],
               r["coat_side_cnt"], r["bdl_qty"], r["min_qty"]) for r in price_rows]
    assert len(set(natkeys)) == 100, f"GP 가격 자연키 중복 — distinct {len(set(natkeys))} != 100"
    # 가격행 siz_cd 가 전부 등록 siz(501~510)로 해소되는지(고아 0)
    unresolved = [r for r in price_rows if r["siz_cd"] not in NEW_SIZ_CDS]
    assert not unresolved, f"미해소 siz 가격행 {len(unresolved)} — 권위표 누락"

    def w(name, content):
        with open(os.path.join(OUTDIR, name), "w", encoding="utf-8") as f:
            f.write(content)

    w("01_siz_register.sql", gen_siz_register_sql(dims))
    w("02_component_prices.sql", gen_component_prices_sql(price_rows))
    w("03_product_sizes.sql", gen_product_sizes_sql(links))
    w("migrate.sql", gen_migrate_sql(price_rows, links))
    w("undo.sql", gen_undo_sql(price_rows, links))
    w("backup.sql", gen_backup_sql(price_rows))
    w("migrate.provenance.csv", gen_provenance(dims, price_rows, links))

    # 요약 (stdout — 비밀값 없음)
    n84 = sum(1 for r in price_rows if r["mat_cd"] == "MAT_000084")
    n153 = sum(1 for r in price_rows if r["mat_cd"] == "MAT_000153")
    bands = sorted(set(int(r["min_qty"]) for r in price_rows))
    print(f"[gen] 신규 등록 siz : {len(NEW_SIZ_CDS)}  ({NEW_SIZ_CDS[0]}..{NEW_SIZ_CDS[-1]})")
    print(f"[gen] GP 가격행     : {len(price_rows)}  (MAT_000084 {n84} + MAT_000153 {n153}, 밴드 {bands})")
    print(f"[gen] 35mm 제외     : {excluded_35}  (committed _exec_price SIZ_000422, 본 트랙 무간섭)")
    print(f"[gen] 066 size link : {len(links)}  (신규 10 + 재사용 1[SIZ_000422])")
    print(f"[gen] GP 가격 자연키 distinct : {len(set(natkeys))}/{len(natkeys)}  (중복 0 필수, auto-IDENTITY)")
    print("[gen] 02 = auto-IDENTITY + 자연키 NOT EXISTS 가드 / migrate step00 setval (시퀀스 재동기화)")


if __name__ == "__main__":
    main()
