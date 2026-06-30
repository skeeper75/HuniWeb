#!/usr/bin/env python3
# gen_foil_pilot.py — 프리미엄명함 PRD_000031 (소형) 박류 파일럿 적재본 결정론 생성기
#
# 무엇을 하나 (engine-design-foil.md REV4 + golden-cases-foil.md 권위):
#   소형 면적격자(B02: 가로×세로→등급 A~E) × 등급단가표(B03 일반/B05 특수: 등급×수량→단가)를
#   적재 전 결정론 join → 박가공비를 (proc_cd × siz_width × siz_height × min_qty) → 단가 의
#   1단 flatten 면적매트릭스 단가행으로 펼친다(grade는 note 추적용·매칭 비사용).
#   동판비(소형)는 고정 5,000 × 박색상 proc_cd.
#
# 단가 verbatim: 전부 price-foil-small-l1.csv(권위)에서 직접 복사 — 날조 0.
# 적재 대상: PILOT = 소형 comp 3종 + PRD_000031 등록 박색상만(037~044) → STD 6색·SPECIAL 2색.
#   (045 펄박·046 백박은 PRD_000031 미등록 → 미생성 = 사용 불가 색상에 과금 안 함.)
#
# 산출: foil-pilot-namecard031-load.sql 의 INSERT 본문(component_prices 행)을 표준출력으로.
# 멱등: SQL 측에서 NOT EXISTS NULL-safe 가드로 처리(이 스크립트는 행 데이터만 결정론 생성).
#
# 실행: python3 gen_foil_pilot.py            # 행수·골든 자가검증 요약을 stderr로
#       python3 gen_foil_pilot.py --rows     # component_prices VALUES 행만 stdout
import sys

APPLY_YMD = "2026-06-01"   # 표준 적용일(아크릴·기존 단가행과 동일·단가행 적용일 분기 금지)

# ── PRD_000031 등록 박색상 (라이브 t_prd_product_processes·2026-06-30 SELECT) ──
#   037~044 (8종). 소형 일반/특수 그룹 매핑은 engine-design-foil §2-3 권위.
REGISTERED = {"PROC_000037","PROC_000038","PROC_000039","PROC_000040",
              "PROC_000041","PROC_000042","PROC_000043","PROC_000044"}

# 소형 일반박 색상(B02/B03 제목 verbatim): 금유광038·은유광039·먹유광040·청박043·적박042·동박041·펄박045
SMALL_STD_ALL = ["PROC_000038","PROC_000039","PROC_000040","PROC_000043",
                 "PROC_000042","PROC_000041","PROC_000045"]
# 소형 특수박 색상(B04/B05 제목 verbatim): 백박046·홀로그램037·트윙클044
SMALL_SPECIAL_ALL = ["PROC_000046","PROC_000037","PROC_000044"]

# PRD_000031 이 실제 제공하는 색상만 (사용 불가 색상에 과금 방지·task RULE)
STD_COLORS     = [c for c in SMALL_STD_ALL     if c in REGISTERED]   # → 038,039,040,043,042,041 (6)
SPECIAL_COLORS = [c for c in SMALL_SPECIAL_ALL if c in REGISTERED]   # → 037,044 (2)

# ── 소형 면적격자 B02 (small-l1.csv 행10~12) : (가로,세로)→등급 ──
#   행 = 가로(10,20,40), 열 = 세로(10,20,40,60,80). verbatim.
#   small-l1.csv: 10행=A A A B C / 20행=A A B C D / 40행=A B D E E
AREA_GRID_SMALL = {
    10: {10:"A", 20:"A", 40:"A", 60:"B", 80:"C"},
    20: {10:"A", 20:"A", 40:"B", 60:"C", 80:"D"},
    40: {10:"A", 20:"B", 40:"D", 60:"E", 80:"E"},
}
W_TIERS = [10, 20, 40]            # 가로 티어 상한값('이하')
H_TIERS = [10, 20, 40, 60, 80]    # 세로 티어 상한값('이하')

# ── 소형 일반박 등급단가표 B03 (small-l1.csv 행10~27) : [수량밴드][등급]→단가 verbatim ──
SMALL_STD_PRICE = {
    200:   {"A":12200, "B":15000, "C":16400, "D":17800, "E":19200},
    300:   {"A":14300, "B":18500, "C":20600, "D":22700, "E":24800},
    400:   {"A":16400, "B":22000, "C":24800, "D":27600, "E":30400},
    500:   {"A":18500, "B":25500, "C":29000, "D":32500, "E":36000},
    600:   {"A":20600, "B":29000, "C":33200, "D":37400, "E":41600},
    700:   {"A":22700, "B":32500, "C":37400, "D":42300, "E":47200},
    800:   {"A":24800, "B":36000, "C":41600, "D":47200, "E":52800},
    900:   {"A":26900, "B":39500, "C":45800, "D":52100, "E":58400},
    1000:  {"A":29000, "B":43000, "C":50000, "D":57000, "E":64000},
    2000:  {"A":50000, "B":78000, "C":92000, "D":106000,"E":120000},
    3000:  {"A":71000, "B":113000,"C":134000,"D":155000,"E":176000},
    4000:  {"A":92000, "B":148000,"C":176000,"D":204000,"E":232000},
    5000:  {"A":113000,"B":183000,"C":218000,"D":253000,"E":288000},
    6000:  {"A":134000,"B":218000,"C":260000,"D":302000,"E":344000},
    7000:  {"A":155000,"B":253000,"C":302000,"D":351000,"E":400000},
    8000:  {"A":176000,"B":288000,"C":344000,"D":400000,"E":456000},
    9000:  {"A":197000,"B":323000,"C":386000,"D":449000,"E":512000},
    10000: {"A":218000,"B":358000,"C":428000,"D":498000,"E":568000},
}

# ── 소형 특수박 등급단가표 B05 (small-l1.csv 행33~50) : [수량밴드][등급]→단가 verbatim ──
SMALL_SPECIAL_PRICE = {
    200:   {"A":14300, "B":18500, "C":20600, "D":22700, "E":24800},
    300:   {"A":17500, "B":23800, "C":26900, "D":30100, "E":33200},
    400:   {"A":20700, "B":29100, "C":33200, "D":37500, "E":41600},
    500:   {"A":23900, "B":34400, "C":39500, "D":44900, "E":50000},
    600:   {"A":27100, "B":39700, "C":45800, "D":52300, "E":58400},
    700:   {"A":30300, "B":45000, "C":52100, "D":59700, "E":66800},
    800:   {"A":33500, "B":50300, "C":58400, "D":67100, "E":75200},
    900:   {"A":36700, "B":55600, "C":64700, "D":74500, "E":83600},
    1000:  {"A":39900, "B":60900, "C":71000, "D":81900, "E":92000},
    2000:  {"A":71900, "B":113900,"C":134000,"D":155900,"E":176000},
    3000:  {"A":103900,"B":166900,"C":197000,"D":229900,"E":260000},
    4000:  {"A":135900,"B":219900,"C":260000,"D":303900,"E":344000},
    5000:  {"A":167900,"B":272900,"C":323000,"D":377900,"E":428000},
    6000:  {"A":199900,"B":325900,"C":386000,"D":451900,"E":512000},
    7000:  {"A":231900,"B":378900,"C":449000,"D":525900,"E":596000},
    8000:  {"A":263900,"B":431900,"C":512000,"D":599900,"E":680000},
    9000:  {"A":295900,"B":484900,"C":575000,"D":673900,"E":764000},
    10000: {"A":327900,"B":537900,"C":638000,"D":747900,"E":848000},
}

SETUP_SMALL = 5000   # small-l1.csv B01 B3 verbatim (80x40mm 고정)


def flatten_proc(comp_cd, colors, price_table):
    """박가공비 flatten 행 생성: (proc_cd × 면적셀 × 수량밴드) → 단가. grade=note."""
    rows = []
    for proc in colors:
        for w in W_TIERS:
            for h in H_TIERS:
                grade = AREA_GRID_SMALL[w][h]
                for minq in sorted(price_table.keys()):
                    up = price_table[minq][grade]
                    rows.append(dict(
                        comp_cd=comp_cd, apply_ymd=APPLY_YMD, proc_cd=proc,
                        siz_width=w, siz_height=h, min_qty=minq, unit_price=up,
                        note=f"소형 박가공비 등급{grade}·가로{w}이하×세로{h}이하·수량{minq}이상 (flatten·grade=추적)"))
    return rows


def setup_rows(comp_cd, colors):
    """소형 동판비: 박색상별 5,000 고정 1행(siz/min_qty NULL=수량·면적 무관·proc_cd 게이트)."""
    return [dict(comp_cd=comp_cd, apply_ymd=APPLY_YMD, proc_cd=proc,
                 siz_width=None, siz_height=None, min_qty=None, unit_price=SETUP_SMALL,
                 note="소형 박·형압 동판셋업비 5,000 고정 (수량·면적 무관·proc_cd 박선택 게이트)")
            for proc in colors]


def build_all():
    rows = []
    # 동판비는 박 선택 게이트만 — STD+SPECIAL 모든 등록색상에 동일 5,000
    rows += setup_rows("COMP_FOIL_SETUP_SMALL", STD_COLORS + SPECIAL_COLORS)
    rows += flatten_proc("COMP_FOIL_PROC_SMALL_STD",     STD_COLORS,     SMALL_STD_PRICE)
    rows += flatten_proc("COMP_FOIL_PROC_SMALL_SPECIAL", SPECIAL_COLORS, SMALL_SPECIAL_PRICE)
    return rows


def sql_val(v):
    if v is None:
        return "NULL"
    if isinstance(v, str):
        return "'" + v.replace("'", "''") + "'"
    return str(v)


def emit_rows(rows):
    """component_prices INSERT 한 행씩 — NOT EXISTS NULL-safe 가드 포함(멱등)."""
    out = []
    cols = "comp_cd, apply_ymd, proc_cd, siz_width, siz_height, min_qty, unit_price, note"
    for r in rows:
        w  = sql_val(r["siz_width"]);  h = sql_val(r["siz_height"]); mq = sql_val(r["min_qty"])
        vals = (f"{sql_val(r['comp_cd'])}, {sql_val(r['apply_ymd'])}, {sql_val(r['proc_cd'])}, "
                f"{w}, {h}, {mq}, {sql_val(r['unit_price'])}, {sql_val(r['note'])}")
        # NULL-safe 멱등: 자연키(NULL 포함) IS NOT DISTINCT FROM 로 비교 → 재실행 0행
        guard = (
            f"INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, siz_width, siz_height, min_qty, unit_price, note)\n"
            f"SELECT {vals}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p\n"
            f"  WHERE p.comp_cd={sql_val(r['comp_cd'])} AND p.apply_ymd={sql_val(r['apply_ymd'])}\n"
            f"    AND p.proc_cd IS NOT DISTINCT FROM {sql_val(r['proc_cd'])}\n"
            f"    AND p.siz_width IS NOT DISTINCT FROM {w} AND p.siz_height IS NOT DISTINCT FROM {h}\n"
            f"    AND p.min_qty IS NOT DISTINCT FROM {mq}\n"
            f"    AND p.siz_cd IS NULL AND p.mat_cd IS NULL AND p.opt_cd IS NULL AND p.clr_cd IS NULL);"
        )
        out.append(guard)
    return "\n".join(out)


def selfcheck(rows):
    from collections import Counter
    c = Counter(r["comp_cd"] for r in rows)
    sys.stderr.write("=== flatten 자가검증 (소형 PILOT) ===\n")
    for k in ("COMP_FOIL_SETUP_SMALL","COMP_FOIL_PROC_SMALL_STD","COMP_FOIL_PROC_SMALL_SPECIAL"):
        sys.stderr.write(f"  {k}: {c[k]} 행\n")
    sys.stderr.write(f"  STD 색상={STD_COLORS}\n  SPECIAL 색상={SPECIAL_COLORS}\n")
    sys.stderr.write(f"  총 component_prices 행수: {len(rows)}\n")
    # 골든 셀 대조 (소형)
    def lk(table, w, h, minq):
        g = AREA_GRID_SMALL[w][h]; return table[minq][g], g
    g4, g4g = lk(SMALL_STD_PRICE, 40, 80, 1000)      # G-F4: E·64000
    g5, g5g = lk(SMALL_SPECIAL_PRICE, 10, 10, 200)   # G-F5: A·14300
    g8, g8g = lk(SMALL_STD_PRICE, 40, 40, 500)       # G-F8: D·32500
    g9, g9g = lk(SMALL_STD_PRICE, 40, 80, 800)       # G-F9 off-band(850→800): E·52800
    sys.stderr.write("=== 골든 셀 자가대조 (동판비 5,000 별도 합산) ===\n")
    sys.stderr.write(f"  G-F4 소형 STD 40x80 q1000 → 등급{g4g} 가공비{g4} +5000 = {g4+5000} (기대 69000)\n")
    sys.stderr.write(f"  G-F5 소형 SPECIAL 10x10 q200 → 등급{g5g} 가공비{g5} +5000 = {g5+5000} (기대 19300)\n")
    sys.stderr.write(f"  G-F8 소형 STD 40x40 q500 → 등급{g8g} 가공비{g8} +5000 = {g8+5000} (기대 37500)\n")
    sys.stderr.write(f"  G-F9 소형 STD 40x80 q850(band800) → 등급{g9g} 가공비{g9} +5000 = {g9+5000} (기대 57800·.03 flat)\n")


# ── Step 1: 3 신규 comp (search-before-mint·NULL-safe 멱등) ──
COMP_DEFS = [
    ("COMP_FOIL_SETUP_SMALL", "박·형압 동판셋업비(소형)", "PRC_COMPONENT_TYPE.05",
     'PRICE_TYPE.03', '["proc_cd"]',
     "소형 동판비 5000 고정·proc_cd 박선택 게이트(미선택 0)·.03 FLAT ×qty0"),
    ("COMP_FOIL_PROC_SMALL_STD", "박 가공비(소형·일반박)", "PRC_COMPONENT_TYPE.01",
     'PRICE_TYPE.03', '["proc_cd", "siz_width", "siz_height", "min_qty"]',
     "소형 일반박 가공비·flatten 면적매트릭스(grade→단가 펼침·note 추적)·.03 FLAT band lookup ×qty0"),
    ("COMP_FOIL_PROC_SMALL_SPECIAL", "박 가공비(소형·특수박)", "PRC_COMPONENT_TYPE.01",
     'PRICE_TYPE.03', '["proc_cd", "siz_width", "siz_height", "min_qty"]',
     "소형 특수박 가공비(백/홀로/트윙클)·flatten 면적매트릭스·.03 FLAT ×qty0"),
]

# ── Step 3/4: 분기 공식 + 구성요소(공유 PRF_NAMECARD_FIXED 미터치·032/033 보호) ──
NEW_FRM = "PRF_NAMECARD_FIXED_FOIL"
NEW_FRM_NM = "프리미엄명함 면/소재/수량별 단가(용지포함)+박"
# 본체 2 STD comp 복제 + 박 3 comp (disp_seq 순)
FRM_COMPS = [
    (1, "COMP_NAMECARD_STD_S1", "Y"),   # 본체 단면(PRF_NAMECARD_FIXED에서 복제)
    (2, "COMP_NAMECARD_STD_S2", "Y"),   # 본체 양면
    (3, "COMP_FOIL_SETUP_SMALL", "Y"),  # 소형 동판비
    (4, "COMP_FOIL_PROC_SMALL_STD", "Y"),
    (5, "COMP_FOIL_PROC_SMALL_SPECIAL", "Y"),
]
NEW_BIND_YMD = "2026-07-01"   # 분기 공식 적용 시작(기존 2026-06-01 바인딩보다 후·엔진 최신 선택)


def emit_comp_defs():
    out = []
    for cd, nm, ctyp, ptyp, dims, note in COMP_DEFS:
        out.append(
            "INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, note)\n"
            f"SELECT {sql_val(cd)}, {sql_val(nm)}, {sql_val(ctyp)}, {sql_val(ptyp)}, {sql_val(dims)}::jsonb, 'Y', {sql_val(note)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd={sql_val(cd)});"
        )
    return "\n".join(out)


def emit_formula():
    return (
        "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, note)\n"
        f"SELECT {sql_val(NEW_FRM)}, {sql_val(NEW_FRM_NM)}, 'Y', '프리미엄명함 박 분기 공식(PRF_NAMECARD_FIXED 클론+박3comp·031 전용·032/033 미영향)'\n"
        f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd={sql_val(NEW_FRM)});"
    )


def emit_formula_components():
    out = []
    for seq, comp, addtn in FRM_COMPS:
        out.append(
            "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)\n"
            f"SELECT {sql_val(NEW_FRM)}, {sql_val(comp)}, {seq}, {sql_val(addtn)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd={sql_val(NEW_FRM)} AND comp_cd={sql_val(comp)});"
        )
    return "\n".join(out)


def emit_binding():
    # PK=(prd_cd, apply_bgn_ymd). 새 적용일 행 추가(시계열·엔진 최신 선택). 기존 2026-06-01 행 미터치(롤백 안전).
    return (
        "INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)\n"
        f"SELECT 'PRD_000031', {sql_val(NEW_FRM)}, {sql_val(NEW_BIND_YMD)}, '박 분기 공식으로 재바인딩(파일럿·인간승인 후 COMMIT)'\n"
        "WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas\n"
        f"  WHERE prd_cd='PRD_000031' AND apply_bgn_ymd={sql_val(NEW_BIND_YMD)});"
    )


HEADER = """-- foil-pilot-namecard031-load.sql — 프리미엄명함 PRD_000031 (소형) 박류 파일럿 적재본
-- 생성: gen_foil_pilot.py (결정론·재현가능·단가 verbatim from price-foil-small-l1.csv·날조 0)
-- 권위: engine-design-foil.md REV4 + golden-cases-foil.md + webadmin-dim-editor-foil-fit.md
-- 범위: 소형 comp 3종 + PRD_000031 박색상(037~044) 단가행 + 분기 공식 바인딩만.
--       대형 comp·다른 6상품·명함박(PRD_000037/PRF_NAMECARD_FOIL)은 미터치.
-- FK 위상순서: ① price_components → ② component_prices(comp_cd·proc_cd 부모 실재)
--              → ③ price_formulas → ④ formula_components → ⑤ product_price_formulas(rebind)
-- 멱등: 전부 NOT EXISTS NULL-safe 가드(nat_key UNIQUE가 NULLS DISTINCT라 ON CONFLICT 불가→NOT EXISTS).
--       재실행 시 0행 영향(NO-OP). comp_price_id=IDENTITY BY DEFAULT(미지정·자동채번).
-- 코드 선적재: PRICE_TYPE.03·PRC_COMPONENT_TYPE.05/.01 전부 라이브 실재 → 코드행 선적재 불요.
-- 분기 공식: PRF_NAMECARD_FIXED(031·032·033 공유)에 박 직접합산하면 032/033에 박 노출 →
--            클론 PRF_NAMECARD_FIXED_FOIL 만들어 PRD_000031만 재바인딩(형제 미영향·Q-FOIL-FRM1).
--            proc_cd 게이트로 박 미선택 주문은 박 comp no_match→0(silent 합산 0).
-- [HARD] 인간 승인 전 COMMIT 금지. 이 파일은 COMMIT 을 주석처리해 둠 — dryrun 은 별 파일(ROLLBACK).
SET client_min_messages = warning;
BEGIN;
"""

FOOTER = """
-- 사후검증(승인 실행 시):
--   SELECT comp_cd, count(*) FROM t_prc_component_prices
--    WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%' GROUP BY comp_cd ORDER BY comp_cd;
--   -- 기대: SETUP_SMALL 8 · PROC_SMALL_STD 1620 · PROC_SMALL_SPECIAL 540
--   SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas
--    WHERE prd_cd='PRD_000031' ORDER BY apply_bgn_ymd;  -- 2026-07-01 행 = PRF_NAMECARD_FIXED_FOIL

-- COMMIT;   -- ← [HARD] 인간 승인 후에만 주석 해제. 그 전엔 아래 ROLLBACK 으로 종료.
ROLLBACK;
"""


def build_body_sql():
    """BEGIN/ROLLBACK 없는 순수 INSERT 본문 (FK 위상순서) — dryrun 이 2회 \\i 용."""
    rows = build_all()
    return "\n".join([
        "-- foil-pilot-namecard031-body.sql — 순수 INSERT 본문(트랜잭션 래핑 없음·load/dryrun 이 감쌈)",
        "-- 자동생성: gen_foil_pilot.py --body. 직접 실행 금지(BEGIN/ROLLBACK 없음).",
        "-- ===== STEP 1: 신규 가격구성요소 3종 =====", emit_comp_defs(),
        "-- ===== STEP 2: 단가행 flatten 면적매트릭스 (2168행) =====", emit_rows(rows),
        "-- ===== STEP 3: 분기 공식 =====", emit_formula(),
        "-- ===== STEP 4: 공식 구성요소(본체 2 + 박 3) =====", emit_formula_components(),
        "-- ===== STEP 5: PRD_000031 재바인딩 =====", emit_binding(),
    ])


def build_full_sql():
    parts = [HEADER,
             "\n\\i foil-pilot-namecard031-body.sql",
             FOOTER]
    return "\n".join(parts)


def build_undo_sql():
    """UNDO — 파일럿 적재분만 정확히 제거(FK 역순). 다른 데이터 미영향."""
    return f"""-- foil-pilot-namecard031-undo.sql — 파일럿 적재 되돌리기 (COMMIT 후 회수용)
-- FK 역순 삭제: ⑤ 바인딩 → ④ formula_components → ③ formula → ② component_prices → ① components.
-- 다른 데이터 미영향: 신규 코드/행만 삭제. 기존 2026-06-01 PRD_000031 바인딩·형제 032/033·명함박 미터치.
-- [HARD] 인간 승인 후에만 COMMIT. 기본 ROLLBACK.
\\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

-- ⑤ 재바인딩 행 제거(기존 2026-06-01 행 보존 → 엔진 자동 복귀)
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000031' AND apply_bgn_ymd='{NEW_BIND_YMD}' AND frm_cd='{NEW_FRM}';

-- ④ 분기 공식 구성요소
DELETE FROM t_prc_formula_components WHERE frm_cd='{NEW_FRM}';

-- ③ 분기 공식
DELETE FROM t_prc_price_formulas WHERE frm_cd='{NEW_FRM}';

-- ② 박 단가행 (소형 3 comp)
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_FOIL_SETUP_SMALL','COMP_FOIL_PROC_SMALL_STD','COMP_FOIL_PROC_SMALL_SPECIAL');

-- ① 박 comp 3종 (component_prices CASCADE 되나 위에서 명시 삭제)
DELETE FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_FOIL_SETUP_SMALL','COMP_FOIL_PROC_SMALL_STD','COMP_FOIL_PROC_SMALL_SPECIAL');

-- COMMIT;   -- ← 인간 승인 후 주석 해제
ROLLBACK;
"""


def build_provenance_csv():
    """각 단가행의 권위 출처(셀) 추적 — 검증가가 row→authority 역추적."""
    rows = build_all()
    out = ["comp_cd,proc_cd,siz_width,siz_height,min_qty,unit_price,grade,authority_source"]
    for r in rows:
        cc = r["comp_cd"]
        if cc == "COMP_FOIL_SETUP_SMALL":
            src = "price-foil-small-l1.csv B01 B3 (80x40mm=5000 verbatim)"; grade = ""
        else:
            grade = r["note"].split("등급")[1][0] if "등급" in r["note"] else ""
            blk = "B03 일반박" if cc.endswith("STD") else "B05 특수박"
            src = f"price-foil-small-l1.csv {blk} [등급{grade}][수량{r['min_qty']}] + B02 면적격자[{r['siz_width']}][{r['siz_height']}]→{grade}"
        def c(v): return "" if v is None else v
        out.append(f"{cc},{r['proc_cd']},{c(r['siz_width'])},{c(r['siz_height'])},{c(r['min_qty'])},{r['unit_price']},{grade},\"{src}\"")
    return "\n".join(out)


if __name__ == "__main__":
    rows = build_all()
    selfcheck(rows)
    if "--rows" in sys.argv:
        print(emit_rows(rows))
    elif "--sql" in sys.argv:
        sys.stdout.write(build_full_sql())
    elif "--body" in sys.argv:
        sys.stdout.write(build_body_sql())
    elif "--undo" in sys.argv:
        sys.stdout.write(build_undo_sql())
    elif "--provenance" in sys.argv:
        sys.stdout.write(build_provenance_csv())
