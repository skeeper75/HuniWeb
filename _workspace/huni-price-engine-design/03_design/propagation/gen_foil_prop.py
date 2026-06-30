#!/usr/bin/env python3
# gen_foil_prop.py — 박류 동형 전파 적재본 결정론 생성기 (6상품·대형 comp + 펄명함 소형 재사용)
#
# 무엇을 하나 (engine-design-foil.md REV4 + golden-cases-foil.md 권위·파일럿 PRD_000031 패턴 답습):
#   ① 대형 박 comp 3종 신설(동판비 LARGE·박가공비 LARGE 일반/특수) — search-before-mint(라이브 0건 확인).
#   ② 대형 면적격자(B02/B04: 가로×세로→등급 A~E) × 대형 등급단가표(B03 일반/B05 특수: 등급×수량→단가)를
#      적재 전 결정론 join → 박가공비를 (proc_cd × siz_width × siz_height × min_qty) → 단가의 1단 flatten
#      면적매트릭스 단가행으로 펼친다(grade=note 추적용·매칭 비사용). 동판비 LARGE = B01 8x8 면적매트릭스
#      (가로×세로·min_qty NULL·박색상 proc_cd 게이트).
#   ③ 6상품 분기 공식(base→base_FOIL 클론 + 박 comp 추가) + 그 상품만 재바인딩(형제 공유공식 미터치).
#      펄명함034=소형(기존 라이브 COMP_FOIL_*SMALL* 재사용)·나머지 5상품=대형.
#
# 단가 verbatim: 전부 price-foil-large-l1.csv(권위)에서 직접 복사 — 날조 0.
# 색상 충전: 6상품 전부 라이브 t_prd_product_processes 등록 = PROC_000037~044 (8종·2026-06-30 SELECT).
#   대형 일반(STD) 등록 4색: 금유광038·은유광039·동박041·청박043 (금무광048·은무광049 미등록).
#   대형 특수(SPECIAL) 등록 4색: 홀로37·먹유광040·적박042·트윙클044 (백박046·녹박047 미등록).
#   소형(펄명함034) STD 6색=038,039,040,043,042,041 / SPECIAL 2색=037,044 (파일럿 PRD_000031 동형).
#
# 멱등: SQL 측 NOT EXISTS NULL-safe 가드(nat-key UNIQUE가 NULLS DISTINCT라 ON CONFLICT 불가). 이 스크립트는 행 데이터만.
#
# 실행: python3 gen_foil_prop.py            # 행수·골든 자가검증 요약을 stderr로
#       python3 gen_foil_prop.py --body     # 전체 INSERT 본문(트랜잭션 미포함)
#       python3 gen_foil_prop.py --undo / --provenance
import sys

APPLY_YMD = "2026-06-01"        # 표준 적용일(단가행 적용일 분기 금지·이중계상 방지)
NEW_BIND_YMD = "2026-07-01"     # 분기 공식 적용 시작(기존 바인딩보다 후·엔진 최신 선택)·파일럿 동일

# ── 라이브 등록 박색상 (6상품 전수 t_prd_product_processes·2026-06-30 SELECT = 037~044 8종) ──
REGISTERED = {"PROC_000037","PROC_000038","PROC_000039","PROC_000040",
              "PROC_000041","PROC_000042","PROC_000043","PROC_000044"}

# 대형 일반박 색상 (B03 제목 verbatim): 금유광038·금무광048·은유광039·은무광049·동박041·청박043
LARGE_STD_ALL     = ["PROC_000038","PROC_000048","PROC_000039","PROC_000049","PROC_000041","PROC_000043"]
# 대형 특수박 색상 (B05 제목 verbatim): 먹유광040·백박046·홀로37·트윙클044·적박042·녹박047
LARGE_SPECIAL_ALL = ["PROC_000040","PROC_000046","PROC_000037","PROC_000044","PROC_000042","PROC_000047"]

# 등록된 색상만 충전 (사용 불가 색상 과금 방지·task RULE)
LARGE_STD     = [c for c in LARGE_STD_ALL     if c in REGISTERED]   # → 038,039,041,043 (4)
LARGE_SPECIAL = [c for c in LARGE_SPECIAL_ALL if c in REGISTERED]   # → 040,037,044,042 (4)

# 소형 (펄명함034 = 파일럿 PRD_000031 동형·기존 라이브 COMP_FOIL_*SMALL* 재사용)
SMALL_STD_ALL     = ["PROC_000038","PROC_000039","PROC_000040","PROC_000043","PROC_000042","PROC_000041","PROC_000045"]
SMALL_SPECIAL_ALL = ["PROC_000046","PROC_000037","PROC_000044"]
SMALL_STD     = [c for c in SMALL_STD_ALL     if c in REGISTERED]   # → 038,039,040,043,042,041 (6)
SMALL_SPECIAL = [c for c in SMALL_SPECIAL_ALL if c in REGISTERED]   # → 037,044 (2)

# ── 대형 동판비 B01 8x8 (large-l1.csv 행3~10·B~I열 value verbatim) : (가로,세로)→단가 ──
#   행=가로(30..170), 열=세로(30..170).
W_TIERS_L = [30, 50, 70, 90, 110, 130, 150, 170]
H_TIERS_L = [30, 50, 70, 90, 110, 130, 150, 170]
SETUP_LARGE = {
    30:  {30:11000, 50:11000, 70:11000, 90:11000, 110:11000, 130:11000, 150:11000, 170:12000},
    50:  {30:11000, 50:11000, 70:11000, 90:11000, 110:12000, 130:15000, 150:17000, 170:19000},
    70:  {30:11000, 50:11000, 70:11000, 90:14000, 110:17000, 130:20000, 150:23000, 170:27000},
    90:  {30:11000, 50:11000, 70:14000, 90:18000, 110:22000, 130:26000, 150:30000, 170:34000},
    110: {30:11000, 50:12000, 70:17000, 90:22000, 110:27000, 130:32000, 150:37000, 170:42000},
    130: {30:11000, 50:15000, 70:20000, 90:26000, 110:32000, 130:38000, 150:43000, 170:49000},
    150: {30:11000, 50:17000, 70:23000, 90:30000, 110:37000, 130:43000, 150:50000, 170:56000},
    170: {30:12000, 50:19000, 70:27000, 90:34000, 110:42000, 130:49000, 150:56000, 170:64000},
}

# ── 대형 면적→등급 격자 B02/B04 8x8 (일반/특수 동일·large-l1.csv 행16~23 / 36~43 verbatim) ──
#   행=가로, 열=세로. (engine-design-foil §3-2 표와 1:1 일치.)
AREA_GRID_LARGE = {
    30:  {30:"A", 50:"A", 70:"A", 90:"A", 110:"A", 130:"A", 150:"A", 170:"B"},
    50:  {30:"A", 50:"A", 70:"A", 90:"A", 110:"B", 130:"B", 150:"B", 170:"B"},
    70:  {30:"A", 50:"A", 70:"B", 90:"B", 110:"B", 130:"B", 150:"B", 170:"D"},
    90:  {30:"A", 50:"A", 70:"B", 90:"C", 110:"C", 130:"D", 150:"D", 170:"D"},
    110: {30:"A", 50:"B", 70:"B", 90:"C", 110:"D", 130:"D", 150:"D", 170:"D"},
    130: {30:"A", 50:"B", 70:"B", 90:"D", 110:"D", 130:"D", 150:"D", 170:"E"},
    150: {30:"A", 50:"B", 70:"B", 90:"D", 110:"D", 130:"D", 150:"E", 170:"E"},
    170: {30:"B", 50:"B", 70:"D", 90:"D", 110:"D", 130:"E", 150:"E", 170:"E"},
}

# ── 대형 일반박 등급단가표 B03 (large-l1.csv 행16~28 L~P열) : [수량밴드][등급]→단가 verbatim ──
#   13 수량밴드: 10,200,500,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000.
LARGE_STD_PRICE = {
    10:    {"A":55000,  "B":65000,  "C":65000,  "D":80000,   "E":120000},
    200:   {"A":65000,  "B":80000,  "C":90000,  "D":120000,  "E":160000},
    500:   {"A":70000,  "B":85000,  "C":100000, "D":140000,  "E":180000},
    1000:  {"A":75000,  "B":95000,  "C":120000, "D":160000,  "E":200000},
    2000:  {"A":150000, "B":190000, "C":240000, "D":320000,  "E":400000},
    3000:  {"A":225000, "B":285000, "C":360000, "D":480000,  "E":600000},
    4000:  {"A":300000, "B":380000, "C":480000, "D":640000,  "E":800000},
    5000:  {"A":375000, "B":475000, "C":600000, "D":800000,  "E":1000000},
    6000:  {"A":450000, "B":570000, "C":720000, "D":960000,  "E":1200000},
    7000:  {"A":525000, "B":665000, "C":840000, "D":1120000, "E":1400000},
    8000:  {"A":600000, "B":760000, "C":960000, "D":1280000, "E":1600000},
    9000:  {"A":675000, "B":855000, "C":1080000,"D":1440000, "E":1800000},
    10000: {"A":750000, "B":950000, "C":1200000,"D":1600000, "E":2000000},
}

# ── 대형 특수박 등급단가표 B05 (large-l1.csv 행36~48 L~P열) : [수량밴드][등급]→단가 verbatim ──
LARGE_SPECIAL_PRICE = {
    10:    {"A":65000,  "B":80000,   "C":80000,   "D":100000,  "E":150000},
    200:   {"A":80000,  "B":103000,  "C":113000,  "D":150000,  "E":200000},
    500:   {"A":88000,  "B":110000,  "C":125000,  "D":175000,  "E":225000},
    1000:  {"A":95000,  "B":125000,  "C":150000,  "D":200000,  "E":250000},
    2000:  {"A":190000, "B":250000,  "C":300000,  "D":400000,  "E":500000},
    3000:  {"A":285000, "B":375000,  "C":450000,  "D":600000,  "E":750000},
    4000:  {"A":380000, "B":500000,  "C":600000,  "D":800000,  "E":1000000},
    5000:  {"A":475000, "B":625000,  "C":750000,  "D":1000000, "E":1250000},
    6000:  {"A":570000, "B":750000,  "C":900000,  "D":1200000, "E":1500000},
    7000:  {"A":665000, "B":875000,  "C":1050000, "D":1400000, "E":1750000},
    8000:  {"A":760000, "B":1000000, "C":1200000, "D":1600000, "E":2000000},
    9000:  {"A":855000, "B":1125000, "C":1350000, "D":1800000, "E":2250000},
    10000: {"A":950000, "B":1250000, "C":1500000, "D":2000000, "E":2500000},
}


# ════════════════════════ 단가행 flatten ════════════════════════

def flatten_proc_large(comp_cd, colors, price_table):
    """대형 박가공비 flatten: (proc_cd × 면적셀8x8 × 13수량밴드) → 단가. grade=note."""
    rows = []
    for proc in colors:
        for w in W_TIERS_L:
            for h in H_TIERS_L:
                grade = AREA_GRID_LARGE[w][h]
                for minq in sorted(price_table.keys()):
                    up = price_table[minq][grade]
                    rows.append(dict(
                        comp_cd=comp_cd, apply_ymd=APPLY_YMD, proc_cd=proc,
                        siz_width=w, siz_height=h, min_qty=minq, unit_price=up,
                        note=f"대형 박가공비 등급{grade}·가로{w}이하×세로{h}이하·수량{minq}이상 (flatten·grade=추적)"))
    return rows


def setup_rows_large(comp_cd, colors):
    """대형 동판비: (proc_cd × 면적셀8x8) → B01 단가. min_qty NULL(수량무관·1회성). proc_cd 게이트."""
    rows = []
    for proc in colors:
        for w in W_TIERS_L:
            for h in H_TIERS_L:
                up = SETUP_LARGE[w][h]
                rows.append(dict(
                    comp_cd=comp_cd, apply_ymd=APPLY_YMD, proc_cd=proc,
                    siz_width=w, siz_height=h, min_qty=None, unit_price=up,
                    note=f"대형 박·형압 동판셋업비·가로{w}이하×세로{h}이하 (수량무관·1회·proc_cd 박선택 게이트)"))
    return rows


def build_prices():
    rows = []
    rows += setup_rows_large("COMP_FOIL_SETUP_LARGE",        LARGE_STD + LARGE_SPECIAL)
    rows += flatten_proc_large("COMP_FOIL_PROC_LARGE_STD",     LARGE_STD,     LARGE_STD_PRICE)
    rows += flatten_proc_large("COMP_FOIL_PROC_LARGE_SPECIAL", LARGE_SPECIAL, LARGE_SPECIAL_PRICE)
    return rows


def sql_val(v):
    if v is None:
        return "NULL"
    if isinstance(v, str):
        return "'" + v.replace("'", "''") + "'"
    return str(v)


def emit_prices(rows):
    out = []
    for r in rows:
        w  = sql_val(r["siz_width"]); h = sql_val(r["siz_height"]); mq = sql_val(r["min_qty"])
        vals = (f"{sql_val(r['comp_cd'])}, {sql_val(r['apply_ymd'])}, {sql_val(r['proc_cd'])}, "
                f"{w}, {h}, {mq}, {sql_val(r['unit_price'])}, {sql_val(r['note'])}")
        guard = (
            "INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, proc_cd, siz_width, siz_height, min_qty, unit_price, note)\n"
            f"SELECT {vals}\n"
            "WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices p\n"
            f"  WHERE p.comp_cd={sql_val(r['comp_cd'])} AND p.apply_ymd={sql_val(r['apply_ymd'])}\n"
            f"    AND p.proc_cd IS NOT DISTINCT FROM {sql_val(r['proc_cd'])}\n"
            f"    AND p.siz_width IS NOT DISTINCT FROM {w} AND p.siz_height IS NOT DISTINCT FROM {h}\n"
            f"    AND p.min_qty IS NOT DISTINCT FROM {mq}\n"
            "    AND p.siz_cd IS NULL AND p.mat_cd IS NULL AND p.opt_cd IS NULL AND p.clr_cd IS NULL);"
        )
        out.append(guard)
    return "\n".join(out)


# ════════════════════════ Step 1: 대형 comp 3종 (search-before-mint·라이브 0건 확인) ════════════════════════
COMP_DEFS = [
    ("COMP_FOIL_SETUP_LARGE", "박·형압 동판셋업비(대형)", "PRC_COMPONENT_TYPE.05",
     'PRICE_TYPE.03', '["proc_cd", "siz_width", "siz_height"]',
     "대형 동판비 B01 8x8 면적매트릭스·proc_cd 박선택 게이트(미선택 0)·.03 FLAT ×qty0·1회성"),
    ("COMP_FOIL_PROC_LARGE_STD", "박 가공비(대형·일반박)", "PRC_COMPONENT_TYPE.01",
     'PRICE_TYPE.03', '["proc_cd", "siz_width", "siz_height", "min_qty"]',
     "대형 일반박 가공비·flatten 면적매트릭스(grade→단가 펼침·note 추적)·.03 FLAT band lookup ×qty0"),
    ("COMP_FOIL_PROC_LARGE_SPECIAL", "박 가공비(대형·특수박)", "PRC_COMPONENT_TYPE.01",
     'PRICE_TYPE.03', '["proc_cd", "siz_width", "siz_height", "min_qty"]',
     "대형 특수박 가공비(먹유광/백박/홀로/트윙클/적박/녹박)·flatten 면적매트릭스·.03 FLAT ×qty0"),
]


def emit_comp_defs():
    out = []
    for cd, nm, ctyp, ptyp, dims, note in COMP_DEFS:
        out.append(
            "INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, note)\n"
            f"SELECT {sql_val(cd)}, {sql_val(nm)}, {sql_val(ctyp)}, {sql_val(ptyp)}, {sql_val(dims)}::jsonb, 'Y', 'N', {sql_val(note)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd={sql_val(cd)});"
        )
    return "\n".join(out)


# ════════════════════════ Step 3/4/5: 분기 공식 + 구성요소 + 재바인딩 (상품별) ════════════════════════
# base 공식의 라이브 formula_components를 충실 클론(라이브 SELECT 2026-06-30) + 박 comp 추가.
# addtn_yn / disp_seq 는 라이브값 그대로(None=NULL). 박 comp는 base 최대 disp_seq 뒤에 append.
#
# 박 comp 세트:
#   소형(펄명함034) = SETUP_SMALL + PROC_SMALL_STD + PROC_SMALL_SPECIAL (기존 라이브 comp 재사용)
#   대형(나머지5)   = SETUP_LARGE + PROC_LARGE_STD + PROC_LARGE_SPECIAL (Step1 신설 comp)
FOIL_SMALL = [("COMP_FOIL_SETUP_SMALL","Y"), ("COMP_FOIL_PROC_SMALL_STD","Y"), ("COMP_FOIL_PROC_SMALL_SPECIAL","Y")]
FOIL_LARGE = [("COMP_FOIL_SETUP_LARGE","Y"), ("COMP_FOIL_PROC_LARGE_STD","Y"), ("COMP_FOIL_PROC_LARGE_SPECIAL","Y")]

# base_components: (comp_cd, disp_seq, addtn_yn)  — 라이브 SELECT verbatim (None=NULL)
BASE_COMPONENTS = {
    "PRF_NAMECARD_PEARL": [
        ("COMP_NAMECARD_PEARL_S1", 1, "Y"),
        ("COMP_NAMECARD_PEARL_S2", 2, "Y"),
    ],
    "PRF_DGP_E": [
        ("COMP_PRINT_DIGITAL_S1", 0, "Y"),
        ("COMP_COAT_GLOSSY", 1, "Y"),
        ("COMP_COAT_MATTE", 2, "Y"),
        ("COMP_PAPER", 3, "Y"),
        ("COMP_FOLD_LEAF_HALF", 4, "Y"),
        ("COMP_FOLD_LEAF_3FOLD", 5, "Y"),
        ("COMP_FOLD_LEAF_4ACC", 6, "Y"),
        ("COMP_FOLD_LEAF_4GATE", 7, "Y"),
        ("COMP_CUT_PERF_1H6", 8, "Y"),
    ],
    "PRF_DGP_A": [
        ("COMP_PRINT_DIGITAL_S1", 0, "Y"),
        ("COMP_PRINT_SPOT_WHITE_S1", 1, "Y"),
        ("COMP_PAPER", 2, "Y"),
        ("COMP_PP_CORNER_RIGHT", 3, None),
        ("COMP_PP_CREASE_1L", 4, "Y"),
        ("COMP_PP_PERF_1L", 5, "Y"),
        ("COMP_PP_VARTEXT_1EA", 6, "Y"),
        ("COMP_PP_VARIMG_1EA", 7, "Y"),
        ("COMP_COAT_GLOSSY", None, None),
        ("COMP_COAT_MATTE", None, None),
    ],
    "PRF_BIND_MUSEON": [
        ("COMP_BIND_MUSEON", 1, "Y"),
    ],
    "PRF_BIND_PUR": [
        ("COMP_BIND_PUR", 1, "Y"),
    ],
}

# 6상품 정의: (prd_cd, base_frm, new_frm, new_frm_nm, sheet, foil_comps, base 박영역 상한 CONFIRM?)
PRODUCTS = [
    ("PRD_000034", "PRF_NAMECARD_PEARL", "PRF_NAMECARD_PEARL_FOIL",
     "펄명함 면/소재/수량별 단가(용지포함)+박", "small", FOIL_SMALL, False),
    ("PRD_000029", "PRF_DGP_E", "PRF_DGP_E_FOIL",
     "접지카드(디지털인쇄·접지·타공)+박", "large", FOIL_LARGE, False),
    ("PRD_000027", "PRF_DGP_E", "PRF_DGP_E_FOIL",
     "접지카드(디지털인쇄·접지·타공)+박", "large", FOIL_LARGE, True),   # 027 박영역 상한 CONFIRM
    ("PRD_000042", "PRF_DGP_A", "PRF_DGP_A_FOIL",
     "프리미엄쿠폰/상품권(디지털인쇄)+박", "large", FOIL_LARGE, False),
    ("PRD_000069", "PRF_BIND_MUSEON", "PRF_BIND_MUSEON_FOIL",
     "무선책자(제본)+박(표지)", "large", FOIL_LARGE, True),            # 069 박영역 상한 CONFIRM
    ("PRD_000070", "PRF_BIND_PUR", "PRF_BIND_PUR_FOIL",
     "PUR책자(제본)+박(표지)", "large", FOIL_LARGE, True),            # 070 박영역 상한 CONFIRM
]

# 027·029는 같은 base(PRF_DGP_E)→같은 new_frm(PRF_DGP_E_FOIL). 공식/구성요소는 1회만 생성, 바인딩은 둘 다.
def unique_formulas():
    seen = {}
    for prd, base, newf, newnm, sheet, foil, confirm in PRODUCTS:
        if newf not in seen:
            seen[newf] = (base, newnm, sheet, foil)
    return seen  # {new_frm: (base, nm, sheet, foil_comps)}


def emit_formulas():
    out = []
    for newf, (base, nm, sheet, foil) in unique_formulas().items():
        note = f"{base} 클론+박{len(foil)}comp 분기 공식(해당 상품 전용·공유공식 형제 미영향·search-before-mint)"
        out.append(
            "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, note)\n"
            f"SELECT {sql_val(newf)}, {sql_val(nm)}, 'Y', {sql_val(note)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd={sql_val(newf)});"
        )
    return "\n".join(out)


def emit_formula_components():
    out = []
    for newf, (base, nm, sheet, foil) in unique_formulas().items():
        # base comp 충실 클론
        base_rows = BASE_COMPONENTS[base]
        max_seq = max([s for (_, s, _) in base_rows if s is not None], default=0)
        for comp, seq, addtn in base_rows:
            seqv = sql_val(seq); addtnv = sql_val(addtn)
            out.append(
                "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)\n"
                f"SELECT {sql_val(newf)}, {sql_val(comp)}, {seqv}, {addtnv}\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd={sql_val(newf)} AND comp_cd={sql_val(comp)});"
            )
        # 박 comp append (base 최대 seq 뒤)
        for i, (comp, addtn) in enumerate(foil, start=1):
            seqv = max_seq + i
            out.append(
                "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)\n"
                f"SELECT {sql_val(newf)}, {sql_val(comp)}, {seqv}, {sql_val(addtn)}\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd={sql_val(newf)} AND comp_cd={sql_val(comp)});"
            )
    return "\n".join(out)


def emit_bindings():
    out = []
    for prd, base, newf, newnm, sheet, foil, confirm in PRODUCTS:
        out.append(
            "INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)\n"
            f"SELECT {sql_val(prd)}, {sql_val(newf)}, {sql_val(NEW_BIND_YMD)}, '박 분기 공식으로 재바인딩(동형전파·인간승인 후 COMMIT)'\n"
            "WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas\n"
            f"  WHERE prd_cd={sql_val(prd)} AND apply_bgn_ymd={sql_val(NEW_BIND_YMD)});"
        )
    return "\n".join(out)


# ════════════════════════ 자가검증 ════════════════════════
def selfcheck(rows):
    from collections import Counter
    c = Counter(r["comp_cd"] for r in rows)
    sys.stderr.write("=== 대형 flatten 자가검증 ===\n")
    for k in ("COMP_FOIL_SETUP_LARGE","COMP_FOIL_PROC_LARGE_STD","COMP_FOIL_PROC_LARGE_SPECIAL"):
        sys.stderr.write(f"  {k}: {c[k]} 행\n")
    sys.stderr.write(f"  대형 STD 등록색상={LARGE_STD}\n  대형 SPECIAL 등록색상={LARGE_SPECIAL}\n")
    sys.stderr.write(f"  총 component_prices 행수(대형): {len(rows)}\n")
    sys.stderr.write(f"  기대: SETUP_LARGE={8*8}*{len(LARGE_STD+LARGE_SPECIAL)}={64*len(LARGE_STD+LARGE_SPECIAL)}"
                     f" · PROC_STD={64*13}*{len(LARGE_STD)}={64*13*len(LARGE_STD)}"
                     f" · PROC_SPECIAL={64*13}*{len(LARGE_SPECIAL)}={64*13*len(LARGE_SPECIAL)}\n")

    def setup(w, h): return SETUP_LARGE[w][h]
    def proc(table, w, h, minq):
        g = AREA_GRID_LARGE[w][h]; return table[minq][g], g
    sys.stderr.write("=== 골든 셀 자가대조 (동판비 + 박가공비) ===\n")
    g1, g1g = proc(LARGE_STD_PRICE, 90, 90, 1000)      # G-F1: 18000 + C 120000 = 138000
    sys.stderr.write(f"  G-F1 대형 STD 금유광 90x90 q1000 → 동판{setup(90,90)} + 등급{g1g} {g1} = {setup(90,90)+g1} (기대 138000)\n")
    g2, g2g = proc(LARGE_SPECIAL_PRICE, 90, 90, 1000)  # G-F2: 18000 + C 150000 = 168000
    sys.stderr.write(f"  G-F2 대형 SPECIAL 홀로 90x90 q1000 → 동판{setup(90,90)} + 등급{g2g} {g2} = {setup(90,90)+g2} (기대 168000)\n")
    g3, g3g = proc(LARGE_STD_PRICE, 30, 30, 10)        # G-F3: 11000 + A 55000 = 66000
    sys.stderr.write(f"  G-F3 대형 STD 은유광 30x30 q10 → 동판{setup(30,30)} + 등급{g3g} {g3} = {setup(30,30)+g3} (기대 66000)\n")
    g7, g7g = proc(LARGE_SPECIAL_PRICE, 170, 170, 1000) # G-F7: 64000 + E 250000 = 314000
    sys.stderr.write(f"  G-F7 대형 SPECIAL 백박 170x170 q1000 → 동판{setup(170,170)} + 등급{g7g} {g7} = {setup(170,170)+g7} (기대 314000)\n")
    # G-F6 off-grid 75x85 → ceiling 90x90 (엔진 처리·여기선 ceiling 결과셀 확인)
    g6, g6g = proc(LARGE_STD_PRICE, 90, 90, 1000)
    sys.stderr.write(f"  G-F6 off-grid 75x85→ceiling 90x90 STD q1000 → {setup(90,90)+g6} (기대 138000)\n")
    # G-F10 off-band q1500 → band 1000 (flat)
    g10, g10g = proc(LARGE_STD_PRICE, 90, 90, 1000)
    sys.stderr.write(f"  G-F10 off-band 90x90 q1500(band1000) STD → {setup(90,90)+g10} (.03 flat·기대 138000)\n")
    # 백박046 미등록 검증
    sys.stderr.write(f"  GATE: 백박046 in LARGE_SPECIAL? {'PROC_000046' in LARGE_SPECIAL} (기대 False·미등록)\n")


# ════════════════════════ 본문/파일 ════════════════════════
def build_body_sql():
    rows = build_prices()
    return "\n".join([
        "-- foil-prop-load body — 6상품 박 동형전파 순수 INSERT 본문(트랜잭션 래핑 없음·load/dryrun 이 감쌈)",
        "-- 자동생성: gen_foil_prop.py --body. 직접 실행 금지(BEGIN/ROLLBACK 없음).",
        "-- ===== STEP 1: 대형 박 comp 3종 (search-before-mint) =====", emit_comp_defs(),
        f"-- ===== STEP 2: 대형 단가행 flatten 면적매트릭스 ({len(rows)}행) =====", emit_prices(rows),
        "-- ===== STEP 3: 분기 공식 (base 클론·상품별 1회) =====", emit_formulas(),
        "-- ===== STEP 4: 공식 구성요소 (base 충실 클론 + 박 comp append) =====", emit_formula_components(),
        "-- ===== STEP 5: 6상품 재바인딩 (apply_bgn_ymd=2026-07-01·형제 미터치) =====", emit_bindings(),
    ])


def build_undo_sql():
    new_frms = sorted(unique_formulas().keys())
    prds = [p[0] for p in PRODUCTS]
    frm_list = ", ".join(f"'{f}'" for f in new_frms)
    prd_pairs = "\n".join(
        f" OR (prd_cd='{prd}' AND apply_bgn_ymd='{NEW_BIND_YMD}' AND frm_cd='{newf}')"
        for prd, base, newf, *_ in PRODUCTS
    )
    return f"""-- foil-prop-undo.sql — 박 동형전파 적재 되돌리기 (COMMIT 후 회수용)
-- FK 역순: ⑤ 바인딩 → ④ formula_components → ③ formula → ② component_prices → ① components.
-- 다른 데이터 미영향: 신규 comp/공식/바인딩만 삭제. 기존 base 바인딩(2026-06-01/06-27)·형제 상품·명함박·파일럿(031 소형) 미터치.
-- [HARD] 인간 승인 후에만 COMMIT. 기본 ROLLBACK.
\\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

-- ⑤ 재바인딩 행 제거 (6상품의 2026-07-01 행만)
DELETE FROM t_prd_product_price_formulas
 WHERE FALSE{prd_pairs};

-- ④ 분기 공식 구성요소
DELETE FROM t_prc_formula_components WHERE frm_cd IN ({frm_list});

-- ③ 분기 공식
DELETE FROM t_prc_price_formulas WHERE frm_cd IN ({frm_list});

-- ② 대형 박 단가행 (소형 comp는 파일럿 소유라 미터치)
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_FOIL_SETUP_LARGE','COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL');

-- ① 대형 박 comp 3종
DELETE FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_FOIL_SETUP_LARGE','COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL');

-- COMMIT;   -- ← 인간 승인 후 주석 해제
ROLLBACK;
"""


def build_provenance_csv():
    rows = build_prices()
    out = ["comp_cd,proc_cd,siz_width,siz_height,min_qty,unit_price,grade,authority_source"]
    for r in rows:
        cc = r["comp_cd"]
        def c(v): return "" if v is None else v
        if cc == "COMP_FOIL_SETUP_LARGE":
            src = f"price-foil-large-l1.csv B01 동판비[가로{r['siz_width']}][세로{r['siz_height']}] verbatim"; grade = ""
        else:
            grade = AREA_GRID_LARGE[r["siz_width"]][r["siz_height"]]
            blk = "B03 일반박" if cc.endswith("STD") else "B05 특수박"
            src = f"price-foil-large-l1.csv {blk}[등급{grade}][수량{r['min_qty']}] + B02/B04 면적격자[{r['siz_width']}][{r['siz_height']}]→{grade}"
        out.append(f"{cc},{r['proc_cd']},{c(r['siz_width'])},{c(r['siz_height'])},{c(r['min_qty'])},{r['unit_price']},{grade},\"{src}\"")
    return "\n".join(out)


if __name__ == "__main__":
    rows = build_prices()
    selfcheck(rows)
    if "--body" in sys.argv:
        sys.stdout.write(build_body_sql())
    elif "--undo" in sys.argv:
        sys.stdout.write(build_undo_sql())
    elif "--provenance" in sys.argv:
        sys.stdout.write(build_provenance_csv())
