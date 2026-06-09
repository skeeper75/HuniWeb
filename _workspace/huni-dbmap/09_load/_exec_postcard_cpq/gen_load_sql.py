#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — 프리미엄엽서(PRD_000016) CPQ 옵션레이어 (groups/options/items)
#                   + 봉투 templates/template_selections/addons + constraints + constraint_json
#   재현 가능한 멱등 적재 SQL 생성기 (손편집 금지 · CSV/설계 STRUCTURE 권위 위에서 생성).
#
#   권위(STRUCTURE):  10_configurator/postcard-option-layer.md + load/*.csv (옵션 STRUCTURE만 권위)
#   권위(코드 규약):  00_schema/code-identifier-strategy.md (2026-06-09 사용자 비준 D1~D5)
#
#   [HARD] 설계의 시맨틱 코드(OG-DOSU·OP-DOSU-SINGLE·TMPL-ENV-*·R-HUGA-*)는 DEPRECATED →
#          전부 `_` 순차 surrogate 로 RE-CODE. 라이브 MAX(suffix)+1 리터럴 부여.
#   [HARD] 멱등 = 이름/자연키 기반 NOT EXISTS 가드 (surrogate 코드는 매 생성마다 달라 충돌키 불가).
#          존재검사는 코드가 아닌 *이름/자연키* → 재실행 시 코드 재발급 없이 delta 0.
#   [HARD] NEVER COMMIT (로더 기본 ROLLBACK). DDL(CREATE/ALTER) 없음.
#   reg_dt 명시 생략(컬럼 DEFAULT now() 발화) — round-5 교훈(명시 NULL은 DEFAULT 미발화).
#
#   라이브 실측 MAX+1 (2026-06-09 read-only 확인):
#     opt_grp MAX=OPT_000004 → OPT_000005+ · opt MAX=OPV_000016 → OPV_000017+ · tmpl MAX=TMPL-000009 → TMPL_000010(`_`)
#
#   [중요·STRUCTURE 정정 — search-before-mint] 설계의 봉투 3 신규 템플릿(TMPL-ENV-*) 중
#     2종은 라이브에 *이미 존재*(del_yn=N): TMPL-000005(OPP접착, base PRD_000001)·TMPL-000006(OPP비접착, base PRD_000002).
#     각각 template_selections(SIZ_000085 qty50)도 실재 → 재생성 금지(중복 mint 방지). 본 적재는 *링크(addon)만* 보장.
#     카드봉투(화이트)는 활성 템플릿 부재(TMPL-000007 del_yn=Y·base PRD_000281) → TMPL_000010 신규 mint(base PRD_000004, SIZ_000104).
#     PRD_000016 addon 은 라이브 1행(→TMPL-000005, disp_seq1) 기실재 → 멱등 가드가 흡수, 나머지 2 addon 만 신규.
# =====================================================================
import os, csv

OUT = os.path.dirname(os.path.abspath(__file__))
PRD = "PRD_000016"

prov = []  # (sql_file, step, target_row_key, source)

def sql_str(s):
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"

# =====================================================================
# 코드 부여표 (라이브 MAX+1 · `_` 통일) — 설계 시맨틱 코드 → surrogate 매핑
# =====================================================================
# option_groups: OPT_000005~OPT_000009 (설계 OG-* 순서 = disp_seq 순)
GRP_CODE = {
    "인쇄(도수)":    "OPT_000005",
    "종이":          "OPT_000006",
    "모서리":        "OPT_000007",
    "후가공":        "OPT_000008",
    "추가상품(봉투)": "OPT_000009",
}
# options: OPV_000017~OPV_000029 (설계 OP-* 순서)
OPT_CODE = {
    ("인쇄(도수)", "단면"):       "OPV_000017",
    ("인쇄(도수)", "양면"):       "OPV_000018",
    ("종이", "별도설정"):         "OPV_000019",   # BLOCKED item 의 부모(헤더는 적재 가능)
    ("모서리", "직각"):           "OPV_000020",
    ("모서리", "둥근"):           "OPV_000021",
    ("후가공", "오시"):           "OPV_000022",   # BLOCKED item 의 부모
    ("후가공", "미싱"):           "OPV_000023",
    ("후가공", "가변텍스트"):     "OPV_000024",
    ("후가공", "가변이미지"):     "OPV_000025",
    ("추가상품(봉투)", "봉투없음"):                       "OPV_000026",
    ("추가상품(봉투)", "OPP접착봉투 110x160 50장"):        "OPV_000027",
    ("추가상품(봉투)", "OPP비접착봉투 110x160 50장"):      "OPV_000028",
    ("추가상품(봉투)", "카드봉투(화이트) 165x115 50장"):   "OPV_000029",
}

# =====================================================================
# step 01 — t_prd_product_option_groups (5행 · OPT_000005~OPT_000009)
#   멱등 가드 = (prd_cd, opt_grp_nm, del_yn='N'). 코드=리터럴(라이브 MAX+1). 트리거 없음.
# =====================================================================
# (opt_grp_nm, sel_typ, min, max, mand, disp, note)
OPT_GROUPS = [
    ("인쇄(도수)",    "SEL_TYPE.01", 1, 1, "Y", 1, "단/양면 택1 필수 (print_option opt_id 1/2). 설계 OG-DOSU 재코드→OPT_000005."),
    ("종이",          "SEL_TYPE.01", 1, 1, "Y", 2, "종이=*별도설정 material 0행 → 하위 item BLOCKED(GAP-DEFER). 헤더는 적재 가능. 설계 OG-JONGI→OPT_000006."),
    ("모서리",        "SEL_TYPE.01", 0, 1, "N", 3, "직각/둥근 택1 (PROC_000027/028). 설계 OG-MOSEORI→OPT_000007."),
    ("후가공",        "SEL_TYPE.02", 0, 4, "N", 4, "오시/미싱/가변텍스트/가변이미지 다중(max4) — L1 row2~4 4종 동시. 029~032 process 0행 → 하위 item BLOCKED. 설계 OG-HUGAGONG→OPT_000008."),
    ("추가상품(봉투)", "SEL_TYPE.01", 0, 1, "N", 5, "봉투 add-on은 template 경유(ref_dim 아님·option_item 0행). 설계 OG-CHUGA→OPT_000009."),
]

def gen_05():
    lines = [
        "-- =====================================================================",
        "-- step 05 — t_prd_product_option_groups (5행 · OPT_000005~OPT_000009)",
        "-- 멱등 가드 = (prd_cd, opt_grp_nm, del_yn='N') NOT EXISTS. 코드=라이브 MAX(OPT_000004)+1 리터럴(`_` 통일·D3).",
        "-- 설계 시맨틱 코드(OG-*) DEPRECATED → surrogate 재코드. 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for nm, sel, mn, mx, mand, seq, note in OPT_GROUPS:
        cd = GRP_CODE[nm]
        lines.append(
            f"INSERT INTO t_prd_product_option_groups\n"
            f"  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)\n"
            f"SELECT {sql_str(PRD)}, {sql_str(cd)}, {sql_str(nm)}, {sql_str(sel)}, {mn}, {mx}, {sql_str(mand)}, {seq}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_option_groups\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND opt_grp_nm = {sql_str(nm)} AND del_yn = 'N');"
        )
        prov.append(("05_t_prd_product_option_groups.sql", "05", f"opt_grp_nm={nm} -> {cd}", "postcard-option-layer.md §2 + live MAX+1(re-code OG-*)"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 06 — t_prd_product_options (13행 · OPV_000017~OPV_000029)
#   멱등 가드 = (prd_cd, opt_grp_cd, opt_nm, del_yn='N'). opt_grp_cd = 그룹 이름으로 resolve(재실행 안전).
#   트리거 없음 → BLOCKED 는 item 레벨, 옵션 헤더 13행 전부 적재 가능.
# =====================================================================
# (grp_nm, opt_nm, dflt, disp, note)
OPTIONS = [
    ("인쇄(도수)", "단면", "Y", 1, "print_option opt_id 1. 설계 OP-DOSU-SINGLE."),
    ("인쇄(도수)", "양면", "N", 2, "print_option opt_id 2. 설계 OP-DOSU-DOUBLE."),
    ("종이", "별도설정", "Y", 1, "종이 차원 0행 — 하위 item BLOCKED(GAP-DEFER). 헤더만 적재. 설계 OP-JONGI-DEFAULT."),
    ("모서리", "직각", "Y", 1, "PROC_000027 (default 재단). 설계 OP-MOSEORI-JIKGAK."),
    ("모서리", "둥근", "N", 2, "PROC_000028 (R 라운딩). 설계 OP-MOSEORI-DUNGEUN."),
    ("후가공", "오시", "N", 1, "PROC_000029 — 차원 0행 → 하위 item BLOCKED(GAP-DEFER). 설계 OP-HUGA-OSI."),
    ("후가공", "미싱", "N", 2, "PROC_000030 — 차원 0행 BLOCKED. 설계 OP-HUGA-MISING."),
    ("후가공", "가변텍스트", "N", 3, "PROC_000031 — 차원 0행 BLOCKED. 설계 OP-HUGA-VARTEXT."),
    ("후가공", "가변이미지", "N", 4, "PROC_000032 — 차원 0행 BLOCKED. 설계 OP-HUGA-VARIMG."),
    ("추가상품(봉투)", "봉투없음", "Y", 1, "선택안함 센티넬 (option_item 0행). 설계 OP-CHUGA-NONE."),
    ("추가상품(봉투)", "OPP접착봉투 110x160 50장", "N", 2, "addon → TMPL-000005(라이브 실재). 설계 OP-CHUGA-OPP-JEOPCHAK."),
    ("추가상품(봉투)", "OPP비접착봉투 110x160 50장", "N", 3, "addon → TMPL-000006(라이브 실재). 설계 OP-CHUGA-OPP-BIJEOPCHAK."),
    ("추가상품(봉투)", "카드봉투(화이트) 165x115 50장", "N", 4, "addon → TMPL_000010(본 적재 mint). 설계 OP-CHUGA-CARD-WHITE."),
]

def grp_expr(grp_nm):
    return f"(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd={sql_str(PRD)} AND opt_grp_nm={sql_str(grp_nm)} AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1)"

def gen_06():
    lines = [
        "-- =====================================================================",
        "-- step 06 — t_prd_product_options (13행 · OPV_000017~OPV_000029)",
        "-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm, del_yn='N') NOT EXISTS. opt_grp_cd = 그룹 이름으로 resolve(재실행 안전).",
        "-- 코드=라이브 MAX(OPV_000016)+1 리터럴(`_` 통일·D3·re-code OP-*). 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for grp_nm, opt_nm, dflt, disp, note in OPTIONS:
        cd = OPT_CODE[(grp_nm, opt_nm)]
        ge = grp_expr(grp_nm)
        lines.append(
            f"INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)\n"
            f"SELECT {sql_str(PRD)}, {sql_str(cd)}, {ge}, {sql_str(opt_nm)}, {sql_str(dflt)}, {disp}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_options\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND opt_grp_cd = {ge} AND opt_nm = {sql_str(opt_nm)} AND del_yn = 'N');"
        )
        prov.append(("06_t_prd_product_options.sql", "06", f"opt_nm={opt_nm} -> {cd}", "postcard-option-layer.md §3 + live MAX+1(re-code OP-*)"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 07 — t_prd_product_option_items (INSERTABLE 4행: 도수2 + 모서리2)
#   트리거 fn_chk_opt_item_ref 행단위 차원행 EXISTS 검사:
#     .06 도수 → t_prd_product_print_options(opt_id) · .04 공정 → t_prd_product_processes(proc_cd)
#   라이브 실재 차원(2026-06-09): print_option opt_id 1/2 ✅ · PROC_000027/028 ✅ (PRD_000016 링크).
#   BLOCKED(후가공 029~032·종이 material 0행)은 _blocked/ 로 격리(차원행 부재→트리거 REJECT).
#   멱등 가드 = (prd_cd, opt_cd, item_seq) 자연키. opt_cd = opt_nm resolve(재실행 안전). ref_key1 NOT NULL.
# =====================================================================
# (opt_nm, item_seq, ref_dim, ref_key1, ref_key2, qty)
OPTION_ITEMS = [
    ("단면", 1, ".06", "1",           None, 1),
    ("양면", 1, ".06", "2",           None, 1),
    ("직각", 1, ".04", "PROC_000027", None, 1),
    ("둥근", 1, ".04", "PROC_000028", None, 1),
]

def opt_expr(opt_nm):
    # opt_nm 은 본 상품 옵션 전역에서 유일(도수 단면/양면, 모서리 직각/둥근) → prd_cd 범위 resolve.
    return f"(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd={sql_str(PRD)} AND opt_nm={sql_str(opt_nm)} AND del_yn='N' ORDER BY opt_cd LIMIT 1)"

def gen_07():
    lines = [
        "-- =====================================================================",
        "-- step 07 — t_prd_product_option_items (INSERTABLE 4행: 도수2 .06 + 모서리2 .04)",
        "-- 트리거 fn_chk_opt_item_ref 행단위: .06→print_options(opt_id 1/2 실재) · .04→processes(PROC_000027/028 실재).",
        "-- BLOCKED(후가공 PROC_000029~032·종이 material 0행) = 차원행 부재→트리거 REJECT → _blocked/(적재 대상 아님).",
        "-- 멱등 가드 = (prd_cd, opt_cd, item_seq) 자연키. opt_cd=opt_nm resolve(재실행 안전). ref_key1 NOT NULL.",
        "-- ref_key2(도수/공정) 미사용=NULL. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for opt_nm, seq, dim, r1, r2, qty in OPTION_ITEMS:
        oe = opt_expr(opt_nm)
        lines.append(
            f"INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)\n"
            f"SELECT {sql_str(PRD)}, {oe}, {seq}, {sql_str('OPT_REF_DIM'+dim)}, {sql_str(r1)}, {sql_str(r2)}, {qty}, 'Y'\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_option_items\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND opt_cd = {oe} AND item_seq = {seq});"
        )
        prov.append(("07_t_prd_product_option_items.sql", "07", f"{opt_nm}#seq{seq} {dim} {r1}", "postcard-option-layer.md §4 INSERTABLE + trigger fn_chk_opt_item_ref"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 08 — t_prd_templates (봉투 SKU)
#   [search-before-mint] OPP접착=TMPL-000005·OPP비접착=TMPL-000006 라이브 실재(del_yn=N) → mint 안 함.
#   카드봉투(화이트)=활성 템플릿 부재(TMPL-000007 del_yn=Y·base PRD_000281) → TMPL_000010 신규 mint(base PRD_000004, `_`).
#   멱등 가드 = (base_prd_cd, tmpl_nm, del_yn='N'). 코드=리터럴(라이브 MAX(TMPL-000009)+1 → TMPL_000010, `_` 통일).
#   라이브 컬럼: tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, note (price 없음·R4).
# =====================================================================
TEMPLATES_MINT = [
    # tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, note
    ("TMPL_000010", "PRD_000004", "카드봉투(화이트) 165x115 mm 50장", 50,
     "엽서 봉투 add-on SKU. 카드봉투(화이트) base PRD_000004. 활성 템플릿 부재(TMPL-000007=del_yn=Y·base PRD_000281)라 신규 mint. price 컬럼 라이브 부재(R4·가격엔진 t_prc_* 연계). 설계 TMPL-ENV-CARD-WHITE 재코드."),
]

def gen_08():
    lines = [
        "-- =====================================================================",
        "-- step 08 — t_prd_templates (카드봉투화이트 TMPL_000010 신규 mint 1행)",
        "-- [search-before-mint] OPP접착 TMPL-000005·OPP비접착 TMPL-000006 = 라이브 실재(del_yn=N) → mint 안 함(중복 방지).",
        "--   각각 template_selections(SIZ_000085 qty50)도 실재 → 본 적재 미관여(09 step 미적재).",
        "-- 카드봉투(화이트)만 활성 템플릿 부재(TMPL-000007=del_yn=Y) → TMPL_000010 신규 mint(base PRD_000004, `_` 통일·D3).",
        "-- 멱등 가드 = (base_prd_cd, tmpl_nm, del_yn='N') NOT EXISTS. price 없음(R4). reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for cd, base, nm, dq, note in TEMPLATES_MINT:
        lines.append(
            f"INSERT INTO t_prd_templates (tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, note)\n"
            f"SELECT {sql_str(cd)}, {sql_str(base)}, {sql_str(nm)}, {dq}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_templates\n"
            f"  WHERE base_prd_cd = {sql_str(base)} AND tmpl_nm = {sql_str(nm)} AND del_yn = 'N');"
        )
        prov.append(("08_t_prd_templates.sql", "08", f"tmpl_nm={nm} -> {cd}", "postcard-option-layer.md §6 + search-before-mint(TMPL-000005/006 reuse) + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 09 — t_prd_template_selections (카드봉투화이트 freeze siz)
#   TMPL-000005/006 의 selection 은 라이브 실재 → 본 적재 미관여.
#   TMPL_000010(신규)만 freeze: SIZ_000104(base PRD_000004 보유 실재) qty50.
#   tmpl_cd 는 base+이름으로 resolve(재실행 시 mint 코드 재해결). 멱등 가드=(tmpl_cd, sel_seq) 자연키.
# =====================================================================
def tmpl_expr(base, nm):
    return f"(SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd={sql_str(base)} AND tmpl_nm={sql_str(nm)} AND del_yn='N' ORDER BY tmpl_cd LIMIT 1)"

# (base, tmpl_nm, sel_seq, ref_dim, ref_key1, sel_val, qty)
TEMPLATE_SELECTIONS = [
    ("PRD_000004", "카드봉투(화이트) 165x115 mm 50장", 1, "OPT_REF_DIM.01", "SIZ_000104", "화이트165x115mm", 50),
]

def gen_09():
    te = tmpl_expr("PRD_000004", "카드봉투(화이트) 165x115 mm 50장")
    lines = [
        "-- =====================================================================",
        "-- step 09 — t_prd_template_selections (카드봉투화이트 freeze 1행)",
        "-- TMPL-000005/006 selection = 라이브 실재(SIZ_000085 qty50) → 본 적재 미관여.",
        "-- TMPL_000010(신규)만 freeze: SIZ_000104(base PRD_000004 보유 실재·트리거 없음) qty50.",
        "-- tmpl_cd = base+이름 resolve(재실행 시 mint 코드 재해결). 멱등 가드 = (tmpl_cd, sel_seq) 자연키.",
        "-- ref_dim_cd=.01 사이즈. opt_cd NULL(자기 차원 freeze). reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for base, nm, seq, dim, r1, selval, qty in TEMPLATE_SELECTIONS:
        lines.append(
            f"INSERT INTO t_prd_template_selections (tmpl_cd, sel_seq, ref_dim_cd, ref_key1, sel_val, qty, use_yn)\n"
            f"SELECT {te}, {seq}, {sql_str(dim)}, {sql_str(r1)}, {sql_str(selval)}, {qty}, 'Y'\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_template_selections\n"
            f"  WHERE tmpl_cd = {te} AND sel_seq = {seq});"
        )
        prov.append(("09_t_prd_template_selections.sql", "09", f"{nm}#sel{seq} {r1}", "postcard-option-layer.md §6 + ref-product-sizes(SIZ_000104 base 실재)"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 10 — t_prd_product_addons (PRD_000016 → 봉투 3 템플릿 링크)
#   PK=(prd_cd, tmpl_cd). 라이브 실재: PRD_000016 → TMPL-000005 (disp_seq1) 1행 → 멱등 가드 흡수.
#   본 적재: TMPL-000005(seq1·기실재)·TMPL-000006(seq2·신규)·TMPL_000010(seq3·신규).
#   tmpl_cd resolve: 접착/비접착=라이브 실재 코드 base+이름 조회 / 카드=신규 mint base+이름 조회.
# =====================================================================
# (base, tmpl_nm, disp_seq, note)
ADDONS = [
    ("PRD_000001", "OPP접착봉투 110x160 mm 50장",      1, "OPP접착봉투 50장 (TMPL-000005 라이브 실재·AS-IS addon_prd_cd=PRD_000001 마이그). 설계 TMPL-ENV-OPP-JEOPCHAK."),
    ("PRD_000002", "OPP비접착봉투 110x160 mm 50장",    2, "OPP비접착봉투 50장 (TMPL-000006 라이브 실재·AS-IS addon_prd_cd=PRD_000002 마이그). 설계 TMPL-ENV-OPP-BIJEOPCHAK."),
    ("PRD_000004", "카드봉투(화이트) 165x115 mm 50장", 3, "카드봉투화이트 50장 (TMPL_000010 본 적재 mint·AS-IS addon_prd_cd=PRD_000004 마이그). 설계 TMPL-ENV-CARD-WHITE."),
]

def gen_10():
    lines = [
        "-- =====================================================================",
        "-- step 10 — t_prd_product_addons (PRD_000016 → 봉투 3 템플릿 링크)",
        "-- PK=(prd_cd, tmpl_cd). 라이브 실재: PRD_000016 → TMPL-000005(disp_seq1) → 멱등 가드 흡수(재적재 안 함).",
        "-- 본 적재 신규 = TMPL-000006(seq2)·TMPL_000010(seq3). tmpl_cd = base+이름 resolve(재실행 안전).",
        "-- 멱등 가드 = (prd_cd, tmpl_cd) 자연키. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for base, nm, seq, note in ADDONS:
        te = tmpl_expr(base, nm)
        lines.append(
            f"INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, note)\n"
            f"SELECT {sql_str(PRD)}, {te}, {seq}, {sql_str(note)}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_addons\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND tmpl_cd = {te});"
        )
        prov.append(("10_t_prd_product_addons.sql", "10", f"addon {base}/{nm} seq{seq}", "postcard-option-layer.md §6 AS-IS addon 마이그 + live addon 실재(TMPL-000005)"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 11 — t_prd_product_constraints (3행 · RULE_001~RULE_003)
#   설계 R-HUGA-MAXN/R-HUGA-PARAM/R-QTY-PANSU → 상품별 카운터 RULE_001~003 재코드(D5).
#   라이브 컬럼: prd_cd, rule_cd, rule_nm, rule_typ_cd, logic(jsonb NN), err_msg, disp_seq, use_yn.
#   logic = postcard-option-layer.md §5 JSONLogic(python json-logic 검증 PASS·well-formed). 멱등=(prd_cd,rule_nm).
# =====================================================================
LOGIC_MAXN = (
    '{ "<=": [ { "reduce": [ { "var": "hugagong" }, '
    '{ "+": [ { "var": "accumulator" }, 1 ] }, 0 ] }, 4 ] }'
)
LOGIC_PARAM = (
    '{ "and": [ { ">=": [ { "var": "osi_julsu" }, 0 ] }, { "<=": [ { "var": "osi_julsu" }, 3 ] }, '
    '{ ">=": [ { "var": "mising_julsu" }, 0 ] }, { "<=": [ { "var": "mising_julsu" }, 3 ] }, '
    '{ ">=": [ { "var": "vartext_cnt" }, 0 ] }, { "<=": [ { "var": "vartext_cnt" }, 3 ] }, '
    '{ ">=": [ { "var": "varimg_cnt" }, 0 ] }, { "<=": [ { "var": "varimg_cnt" }, 3 ] } ] }'
)
# 7사이즈 판수 배수: SIZ_000001~007 = 15/12/8/6/6/4/4
_PANSU = [("SIZ_000001",15),("SIZ_000002",12),("SIZ_000003",8),("SIZ_000004",6),("SIZ_000005",6),("SIZ_000006",4),("SIZ_000007",4)]
def _qty_clause(siz, mod):
    return ('{ "and": [ { "==": [ { "var": "siz_cd" }, "%s" ] }, '
            '{ "==": [ { "%%": [ { "var": "qty" }, %d ] }, 0 ] } ] }' % (siz, mod))
LOGIC_PANSU = '{ "or": [ ' + ', '.join(_qty_clause(s, m) for s, m in _PANSU) + ' ] }'

# (rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp)
CONSTRAINTS = [
    ("RULE_001", "후가공 최대 4종", "RULE_TYPE.01", LOGIC_MAXN,
     "후가공은 최대 4종까지 선택 가능합니다", 1),
    ("RULE_002", "후가공 파라미터 범위", "RULE_TYPE.01", LOGIC_PARAM,
     "오시/미싱 줄수·가변 개수는 0~3 범위입니다", 2),
    ("RULE_003", "수량 판수 배수", "RULE_TYPE.03", LOGIC_PANSU,
     "제작수량은 선택 사이즈의 판수 배수여야 합니다", 3),
]

def gen_11():
    lines = [
        "-- =====================================================================",
        "-- step 11 — t_prd_product_constraints (3행 · RULE_001~RULE_003)",
        "-- 설계 R-HUGA-MAXN/R-HUGA-PARAM/R-QTY-PANSU → 상품별 카운터 RULE_001~003 재코드(D5·복합 PK 충돌 없음).",
        "-- rule_typ_cd 코드 FK(.01 호환/.03 필수동반·R5). logic jsonb NOT NULL(JSONLogic·python 검증 PASS).",
        "-- 멱등 가드 = (prd_cd, rule_nm, del_yn='N'). reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for cd, nm, typ, logic, err, disp in CONSTRAINTS:
        lines.append(
            f"INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn)\n"
            f"SELECT {sql_str(PRD)}, {sql_str(cd)}, {sql_str(nm)}, {sql_str(typ)}, {sql_str(logic)}::jsonb, {sql_str(err)}, {disp}, 'Y'\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_constraints\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND rule_nm = {sql_str(nm)} AND del_yn = 'N');"
        )
        prov.append(("11_t_prd_product_constraints.sql", "11", f"rule_nm={nm} -> {cd}", "postcard-option-layer.md §5 JSONLogic(python PASS) + re-code R-*"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 12 — UPDATE t_prd_products.constraint_json (compile 캐시 = 활성 3 rule AND)
#   멱등: 현재 값과 *다를 때만* UPDATE (IS DISTINCT FROM). 동일하면 0행.
#   compile = §5 의 AND 결합 JSONLogic. POD json-logic-js·백엔드 json-logic-py 동일 평가.
# =====================================================================
COMPILE = (
    '{ "and": [ ' + LOGIC_MAXN + ', ' + LOGIC_PARAM + ', ' + LOGIC_PANSU + ' ] }'
)

def gen_12():
    lines = [
        "-- =====================================================================",
        "-- step 12 — UPDATE t_prd_products.constraint_json (compile 캐시: 활성 3 rule AND)",
        "-- 멱등: constraint_json IS DISTINCT FROM 새 값일 때만 UPDATE (동일하면 0행·재실행 delta 0).",
        "-- compile = §5 AND(R-MAXN, R-PARAM, R-QTY-PANSU). jsonb. POD json-logic-js · 백엔드 json-logic-py 동일 평가.",
        "-- =====================================================================",
        f"UPDATE t_prd_products\n"
        f"SET constraint_json = {sql_str(COMPILE)}::jsonb\n"
        f"WHERE prd_cd = {sql_str(PRD)}\n"
        f"  AND constraint_json IS DISTINCT FROM {sql_str(COMPILE)}::jsonb;",
    ]
    prov.append(("12_t_prd_products_constraint_json.sql", "12", f"{PRD}.constraint_json compile", "postcard-option-layer.md §5 compile(AND of 3 rules)"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 00 — markers (no INSERT)
# =====================================================================
def gen_00():
    return """-- =====================================================================
-- step 00 — pre-load markers (NO INSERT) — 적용된 설계 결정 명시
-- 프리미엄엽서(PRD_000016) CPQ 옵션레이어 · `_exec_postcard_cpq` (round-6 CPQ → load-execution)
-- 권위: postcard-option-layer.md (옵션 STRUCTURE만) · code-identifier-strategy.md (코드 규약 D1~D5)
-- =====================================================================
-- [적용 결정 — 코드 규약 D1~D5]
--  D1 전략: 순차 surrogate PK. 멱등 = 이름/자연키 기반 NOT EXISTS (신규 DDL 0). 코드 재발급 없음.
--  D2 멱등키: option_groups=(prd_cd,opt_grp_nm) · options=(prd_cd,opt_grp_cd,opt_nm)
--             · option_items=(prd_cd,opt_cd,item_seq) · templates=(base_prd_cd,tmpl_nm)
--             · template_selections=(tmpl_cd,sel_seq) · addons=(prd_cd,tmpl_cd) · constraints=(prd_cd,rule_nm).
--  D3 separator: 신규 CPQ 코드 `_` 통일 (OPT_/OPV_/TMPL_).
--  D4 채번: 라이브 MAX(suffix)+1 리터럴 (생성 트리거 부재). 멱등은 이름/자연키.
--           opt_grp OPT_000005~000009 · opt OPV_000017~000029 · tmpl TMPL_000010 · rule RULE_001~003.
--  D5 rule_cd: 상품별 카운터 RULE_001~003 (복합 PK 충돌 없음).
-- [설계 시맨틱 코드 RE-CODE] OG-DOSU/OP-DOSU-SINGLE/TMPL-ENV-*/R-HUGA-* (DEPRECATED) → 전부 `_` surrogate.
-- [search-before-mint — 봉투 템플릿] (2026-06-09 live 재확인)
--   OPP접착 = TMPL-000005 (base PRD_000001, del_yn=N) 실재 → mint 안 함. selection(SIZ_000085 qty50) 실재 → 미관여.
--   OPP비접착 = TMPL-000006 (base PRD_000002, del_yn=N) 실재 → mint 안 함. selection 실재 → 미관여.
--   카드봉투(화이트) = 활성 템플릿 부재 (TMPL-000007 del_yn=Y·base PRD_000281) → TMPL_000010 신규 mint (base PRD_000004).
--   PRD_000016 addon = 라이브 1행 (→TMPL-000005, disp_seq1) 실재 → 멱등 가드 흡수, addon 2행 신규(TMPL-000006/TMPL_000010).
-- [차원행 전제 — INSERTABLE option_items]
--   도수 .06 → print_options opt_id 1/2 (PRD_000016 실재) ✅ · 모서리 .04 → PROC_000027/028 (PRD_000016 링크 실재) ✅.
-- [BLOCKED] 종이=*별도설정 material 0행 · 후가공 PROC_000029~032 0행 → option_item 차원행 부재(트리거 REJECT) → _blocked/.
--   별색 그룹 = 본 상품 미보유(L1 별색 전 7행 공백) → 미인스턴스화(발명 금지).
-- [HARD] NEVER COMMIT — 로더 기본 ROLLBACK. DDL(CREATE/ALTER) 없음. mint=master-data INSERT.
SELECT '00: markers — D1~D5/re-code/search-before-mint(TMPL-000005/006 reuse, TMPL_000010 mint)' AS step_00;
"""

# ---------------------------------------------------------------------
def write(fn, content):
    with open(os.path.join(OUT, fn), "w") as f:
        f.write(content)

def main():
    write("00_preload_markers.sql", gen_00())
    write("05_t_prd_product_option_groups.sql", gen_05())
    write("06_t_prd_product_options.sql", gen_06())
    write("07_t_prd_product_option_items.sql", gen_07())
    write("08_t_prd_templates.sql", gen_08())
    write("09_t_prd_template_selections.sql", gen_09())
    write("10_t_prd_product_addons.sql", gen_10())
    write("11_t_prd_product_constraints.sql", gen_11())
    write("12_t_prd_products_constraint_json.sql", gen_12())

    with open(os.path.join(OUT, "load.provenance.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sql_file", "step", "target_row_key", "source_authority"])
        for row in prov:
            w.writerow(row)

    print("generated:", len(prov), "provenance rows")

if __name__ == "__main__":
    main()
