#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — 일반현수막(PRD_000138) CPQ 옵션레이어 + 마스터 mint
#   재현 가능한 멱등 적재 SQL 생성기 (손편집 금지 · CSV/설계 권위 위에서 생성).
#   권위: 10_configurator/silsa-option-layer-v2.md (옵션 STRUCTURE)
#         00_schema/code-identifier-strategy.md (코드 규약 — `_` 순차 surrogate·이름기반 멱등·신규 DDL 0)
#   [HARD] 멱등 = 이름기반 NOT EXISTS 가드. surrogate 코드는 라이브 MAX+1 리터럴로 부여하되
#          존재검사는 코드가 아닌 *이름*으로 → 재실행 시 코드 재발급 없이 delta 0.
#   [HARD] NEVER COMMIT (로더 기본 ROLLBACK). DDL(CREATE/ALTER) 없음 — mint=master-data INSERT.
#   reg_dt 명시 생략(컬럼 DEFAULT now() 발화) — round-5 교훈(명시 NULL은 DEFAULT 미발화).
# =====================================================================
import os, csv

OUT = os.path.dirname(os.path.abspath(__file__))
PRD = "PRD_000138"

# ---------------------------------------------------------------------
# 라이브 실측 MAX(suffix)+1 (2026-06-09 read-only 확인):
#   mat=MAT_000336 → 337+ · proc=PROC_000083 → 084 · opt_grp=OPT-000002 → OPT_000003+ · opt=OPV-000005 → OPV_000006+
# 코드는 *리터럴* 로 부여(생성 트리거 부재·D4 적재 먼저). 멱등은 이름키가 담당.
# ---------------------------------------------------------------------
def sql_str(s):
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"

prov = []  # (sql_file, step, target_row_key, source)

# =====================================================================
# step 01 — t_mat_materials (mint 4: 큐방·각목900이하·각목900초과·봉제사)
#   guard = mat_nm (이름기반). MAT_TYPE.07=부속. use_yn='Y'. sel_typ_cd NULL(부속 자재, 옵션이 택1 담당).
# =====================================================================
MATERIALS_MINT = [
    # mat_cd,      mat_nm,         note
    ("MAT_000337", "큐방",          "silsa 큐방(4개)추가 옵션 자재. 금속 부속. search-before-mint 부재 재확인(2026-06-09 live 0행). MAT_TYPE.07 부속."),
    ("MAT_000338", "각목(900이하)", "silsa 각목(900이하)+끈 옵션 자재. 사각단면 목재(우드봉 차용 배제·D③). 900이하 규격. 2규격 별 mat_cd 모델(D-2 적용결정)."),
    ("MAT_000339", "각목(900초과)", "silsa 각목(900초과)+끈 옵션 자재. 사각단면 목재. 900초과 규격. 2규격 별 mat_cd 모델(D-2 적용결정)."),
    ("MAT_000340", "봉제사",        "silsa 봉미싱 옵션 자재. 봉제용 실(D② 실=자재 확정·소모성 미등록 후보 철회). search-before-mint 부재 재확인(2026-06-09 live 0행). MAT_TYPE.07 부속."),
]

def gen_01():
    lines = [
        "-- =====================================================================",
        "-- step 01 — t_mat_materials (마스터 mint 4: 큐방·각목900이하·각목900초과·봉제사)",
        "-- 멱등 가드 = mat_nm (이름기반 NOT EXISTS). 코드=라이브 MAX(MAT_000336)+1 리터럴 부여.",
        "--   재실행: 이름 일치 행 존재 → INSERT 0행(코드 재발급 없음). PK=mat_cd.",
        "-- MAT_TYPE.07=부속. use_yn='Y'. reg_dt 생략→DEFAULT now(). DDL 아님(master-data INSERT).",
        "-- search-before-mint: 2026-06-09 live 0행 재확인(큐방/각목/봉제사 부재). 손편집 금지.",
        "-- =====================================================================",
    ]
    for mat_cd, mat_nm, note in MATERIALS_MINT:
        lines.append(
            f"INSERT INTO t_mat_materials (mat_cd, mat_nm, mat_typ_cd, use_yn, note)\n"
            f"SELECT {sql_str(mat_cd)}, {sql_str(mat_nm)}, 'MAT_TYPE.07', 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_mat_materials WHERE mat_nm = {sql_str(mat_nm)} AND mat_typ_cd = 'MAT_TYPE.07' AND del_yn = 'N');"
        )
        prov.append(("01_t_mat_materials.sql", "01", f"mat_nm={mat_nm} → {mat_cd}", "silsa-option-layer-v2.md §1.1 + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 02 — t_proc_processes (mint 1: 열재단 PROC_000084)
#   guard = proc_nm. flat(prcs_dtl_opt NULL — param 없음). 완칼 차용 폐기(M-1 ①).
# =====================================================================
def gen_02():
    note = "silsa 열재단 옵션 공정. 천 자체 열절단(추가 자재 없는 순수 process). M-1 ① 확정·완칼 PROC_053 차용 폐기. flat(param 없음)."
    lines = [
        "-- =====================================================================",
        "-- step 02 — t_proc_processes (마스터 mint 1: 열재단 PROC_000084)",
        "-- 멱등 가드 = proc_nm. 코드=라이브 MAX(PROC_000083)+1 리터럴. prcs_dtl_opt NULL(flat).",
        "-- reg_dt 생략→DEFAULT now(). DDL 아님. 손편집 금지.",
        "-- =====================================================================",
        f"INSERT INTO t_proc_processes (proc_cd, proc_nm, use_yn, note)\n"
        f"SELECT 'PROC_000084', '열재단', 'Y', {sql_str(note)}\n"
        f"WHERE NOT EXISTS (SELECT 1 FROM t_proc_processes WHERE proc_nm = '열재단' AND del_yn = 'N');",
    ]
    prov.append(("02_t_proc_processes.sql", "02", "proc_nm=열재단 → PROC_000084", "silsa-option-layer-v2.md §1.2 M-1 ① + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 03 — t_prd_product_materials (PRD_000138 자재 링크)
#   기존 실재 자재(끈 MAT_000070·양면테입 MAT_000069) LINK + mint 자재 4종 LINK.
#   trigger fn_chk_opt_item_ref(.03)는 (prd_cd, mat_cd, usage_cd) 존재를 요구 → 옵션아이템(07) 선행조건.
#   mint 자재 mat_cd 는 step01과 동일 이름으로 *조회* 해 resolve(재실행 안전). usage_cd=USAGE.07(공통).
#   PK=(prd_cd, mat_cd, usage_cd) → guard = 그 3키 NOT EXISTS.
# =====================================================================
# (mat_resolver, usage_cd, dflt_yn, disp_seq, prov_note)
#   mat_resolver: ('lit', mat_cd)=실재 코드 직접 / ('name', mat_nm)=mint 자재 이름조회
MATERIAL_LINKS = [
    (("lit",  "MAT_000069"), "USAGE.07", "N", 1, "양면테입(실재 EXISTS) 링크 — 양면테입 옵션 자재 seq"),
    (("lit",  "MAT_000070"), "USAGE.07", "N", 2, "끈(실재 EXISTS) 링크 — 끈/각목복합 옵션 자재 seq"),
    (("name", "큐방"),         "USAGE.07", "N", 3, "큐방(mint MAT_000337) 링크 — 큐방 옵션 자재 seq"),
    (("name", "각목(900이하)"), "USAGE.07", "N", 4, "각목900이하(mint MAT_000338) 링크 — 각목LE 옵션 자재 seq"),
    (("name", "각목(900초과)"), "USAGE.07", "N", 5, "각목900초과(mint MAT_000339) 링크 — 각목GT 옵션 자재 seq"),
    (("name", "봉제사"),       "USAGE.07", "N", 6, "봉제사(mint MAT_000340) 링크 — 봉미싱 옵션 자재 seq"),
]

def mat_expr(resolver):
    kind, val = resolver
    if kind == "lit":
        return f"{sql_str(val)}"
    # name → resolve mint code by mat_nm (재실행 안전: 이름→코드)
    return f"(SELECT mat_cd FROM t_mat_materials WHERE mat_nm = {sql_str(val)} AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1)"

def gen_03():
    lines = [
        "-- =====================================================================",
        "-- step 03 — t_prd_product_materials (PRD_000138 자재 링크 6행)",
        "-- 트리거 fn_chk_opt_item_ref(.03) 선행조건: 옵션아이템(07) 자재 seq가 (prd_cd,mat_cd,usage_cd) 존재 요구.",
        "-- 멱등 가드 = (prd_cd, mat_cd, usage_cd) NOT EXISTS. mint 자재는 이름→코드 조회(재실행 안전).",
        "-- usage_cd=USAGE.07(공통). dflt_yn='N'. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for resolver, usage, dflt, seq, note in MATERIAL_LINKS:
        me = mat_expr(resolver)
        lines.append(
            f"INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)\n"
            f"SELECT {sql_str(PRD)}, {me}, {sql_str(usage)}, {sql_str(dflt)}, {seq}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_materials\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND mat_cd = {me} AND usage_cd = {sql_str(usage)});"
        )
        prov.append(("03_t_prd_product_materials.sql", "03", f"link {resolver[1]}/{usage}", "silsa-option-layer-v2.md §7 자재링크 선적재 + " + note))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 04 — t_prd_product_processes (PRD_000138 열재단 링크)
#   079/080/081 은 라이브 이미 링크 → mint 한 열재단(PROC_000084)만 신규 링크.
#   PK=(prd_cd, proc_cd) → guard = 2키 NOT EXISTS. mand_proc_yn NOT NULL → 'N'(옵션 공정).
# =====================================================================
def gen_04():
    proc_expr = "(SELECT proc_cd FROM t_proc_processes WHERE proc_nm='열재단' AND del_yn='N' ORDER BY proc_cd LIMIT 1)"
    lines = [
        "-- =====================================================================",
        "-- step 04 — t_prd_product_processes (PRD_000138 열재단 링크 1행)",
        "-- 079 타공·080 봉제·081 부착 = 라이브 이미 링크(재적재 안 함). 열재단(PROC_000084·mint)만 신규 링크.",
        "-- 멱등 가드 = (prd_cd, proc_cd) NOT EXISTS. 열재단은 이름→코드 조회. mand_proc_yn='N'(옵션 공정).",
        "-- 트리거 fn_chk_opt_item_ref(.04) 선행조건: 열재단 옵션아이템(07)이 (prd_cd,proc_cd) 존재 요구.",
        "-- reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
        f"INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)\n"
        f"SELECT {sql_str(PRD)}, {proc_expr}, 'N', 10\n"
        f"WHERE NOT EXISTS (\n"
        f"  SELECT 1 FROM t_prd_product_processes\n"
        f"  WHERE prd_cd = {sql_str(PRD)} AND proc_cd = {proc_expr});",
    ]
    prov.append(("04_t_prd_product_processes.sql", "04", "link 열재단(PROC_000084)", "silsa-option-layer-v2.md §1.2/§7 열재단 신설+링크"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 05 — t_prd_product_option_groups (OPT_000003 가공 · OPT_000004 추가)
#   멱등 가드 = (prd_cd, opt_grp_nm). 코드=라이브 MAX(OPT-000002)+1 → OPT_000003+ (`_` 통일·D3).
#   기존 OPT-000002 각목추가=del_yn='Y' 소프트삭제 → 이름 '가공'/'추가' 와 무관(충돌 0).
# =====================================================================
OPT_GROUPS = [
    # opt_grp_cd, opt_grp_nm, sel_typ, min, max, mand, disp, note
    ("OPT_000003", "가공", "SEL_TYPE.01", 1, 1, "Y", 1,
     "가공 택1 필수 (열재단 기본). sel_typ=SEL_TYPE.01 단일 (가격표 B26 J/K 단일컬럼 캐스케이드). v2 BUNDLE."),
    ("OPT_000004", "추가", "SEL_TYPE.01", 0, 1, "N", 2,
     "추가 택1 선택 (추가없음 센티넬 기본 min0). sel_typ=SEL_TYPE.01 (가격표 B26 M/N 단일컬럼). v2 BUNDLE."),
]

def gen_05():
    lines = [
        "-- =====================================================================",
        "-- step 05 — t_prd_product_option_groups (OPT_000003 가공 · OPT_000004 추가)",
        "-- 멱등 가드 = (prd_cd, opt_grp_nm) NOT EXISTS. 코드=라이브 MAX(OPT-000002)+1 → OPT_000003+(`_` 통일·D3).",
        "--   기존 OPT-000002 각목추가=del_yn='Y' 소프트삭제 → 이름 가공/추가와 무관(충돌 0).",
        "-- 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for cd, nm, sel, mn, mx, mand, seq, note in OPT_GROUPS:
        lines.append(
            f"INSERT INTO t_prd_product_option_groups\n"
            f"  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)\n"
            f"SELECT {sql_str(PRD)}, {sql_str(cd)}, {sql_str(nm)}, {sql_str(sel)}, {mn}, {mx}, {sql_str(mand)}, {seq}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_option_groups\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND opt_grp_nm = {sql_str(nm)} AND del_yn = 'N');"
        )
        prov.append(("05_t_prd_product_option_groups.sql", "05", f"opt_grp_nm={nm} → {cd}", "load_silsa_v2/t_prd_product_option_groups.csv + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 06 — t_prd_product_options (11 options · OPV_000006~000016)
#   멱등 가드 = (prd_cd, opt_grp_cd, opt_nm). opt_grp_cd 는 그룹 이름으로 resolve(재실행 안전).
#   코드=라이브 MAX(OPV-000005)+1 → OPV_000006+(`_` 통일·D3).
# =====================================================================
# (opt_cd, grp_nm, opt_nm, dflt, disp, note)
OPTIONS = [
    ("OPV_000006", "가공", "열재단",            "Y", 1, "process-only (천 자체 열절단·추가자재 없음). item=mint PROC_000084 (.04 seq1). 본 적재에서 열재단 링크 선적재→INSERTABLE."),
    ("OPV_000007", "가공", "타공(4개)",          "N", 2, "PROCESS-ONLY [bare-hole·D①]: 구멍만·아일렛 안 끼움. 공정 타공 PROC_000079 {구수:4}(.04 seq1)."),
    ("OPV_000008", "가공", "타공(6개)",          "N", 3, "PROCESS-ONLY [bare-hole]: 공정 타공 PROC_000079 {구수:6}(.04 seq1)."),
    ("OPV_000009", "가공", "타공(8개)",          "N", 4, "PROCESS-ONLY [bare-hole]: 공정 타공 PROC_000079 {구수:8}(.04 seq1)."),
    ("OPV_000010", "가공", "양면테입",            "N", 5, "BUNDLE: 자재 양면테입 MAT_000069(seq1 .03) + 공정 부착 PROC_000081 {대상:테입}(seq2 .04)."),
    ("OPV_000011", "가공", "봉미싱",              "N", 6, "BUNDLE [D② 실=자재]: 자재 봉제사(mint MAT_000340 seq1 .03) + 공정 봉제 PROC_000080 {유형:봉미싱}(seq2 .04)."),
    ("OPV_000012", "추가", "추가없음",            "Y", 1, "선택안함 센티넬 (option_item 0행)."),
    ("OPV_000013", "추가", "큐방(4개)추가",       "N", 2, "BUNDLE: 자재 큐방(mint MAT_000337 seq1 .03) + 공정 부착 PROC_000081(seq2 .04). 부착 enum 큐방 부재 [CONFIRM 잔존]."),
    ("OPV_000014", "추가", "끈(4개)추가",         "N", 3, "BUNDLE: 자재 끈 MAT_000070(seq1 .03) + 공정 부착 PROC_000081 {대상:끈}(seq2 .04)."),
    ("OPV_000015", "추가", "각목(900이하)+끈(4개) 추가", "N", 4, "MULTI-BUNDLE: 자재 각목900이하(mint MAT_000338 seq1) + 끈 MAT_000070(seq2) + 공정 부착 PROC_000081(seq3)."),
    ("OPV_000016", "추가", "각목(900초과)+끈(4개) 추가", "N", 5, "MULTI-BUNDLE: 자재 각목900초과(mint MAT_000339 seq1) + 끈 MAT_000070(seq2) + 공정 부착 PROC_000081(seq3)."),
]

def grp_expr(grp_nm):
    return f"(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd={sql_str(PRD)} AND opt_grp_nm={sql_str(grp_nm)} AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1)"

def gen_06():
    lines = [
        "-- =====================================================================",
        "-- step 06 — t_prd_product_options (11 options · OPV_000006~000016)",
        "-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS. opt_grp_cd = 그룹 이름으로 resolve(재실행 안전).",
        "-- 코드=라이브 MAX(OPV-000005)+1 → OPV_000006+(`_` 통일·D3). 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for cd, grp_nm, opt_nm, dflt, disp, note in OPTIONS:
        ge = grp_expr(grp_nm)
        lines.append(
            f"INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)\n"
            f"SELECT {sql_str(PRD)}, {sql_str(cd)}, {ge}, {sql_str(opt_nm)}, {sql_str(dflt)}, {disp}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_options\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND opt_grp_cd = {ge} AND opt_nm = {sql_str(opt_nm)} AND del_yn = 'N');"
        )
        prov.append(("06_t_prd_product_options.sql", "06", f"opt_nm={opt_nm} → {cd}", "load_silsa_v2/t_prd_product_options.csv + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 07 — t_prd_product_option_items (BUNDLE: 자재 .03 + 공정 .04)
#   본 적재가 자재 mint+링크(01/03)와 열재단 mint+링크(02/04)를 *선행* 하므로,
#   prior 패키지에서 BLOCKED 였던 자재 seq(.03) + 열재단(.04) 가 본 트랜잭션에서 INSERTABLE 로 승격.
#   parent opt_cd = (prd_cd, opt_nm) 로 resolve. ref_dim_cd .03=자재(ref_key1=mat_cd,ref_key2=usage_cd) / .04=공정(ref_key1=proc_cd).
#   item_seq 규약: seq1~=자재(.03), 마지막=공정(.04). 트리거 fn_chk_opt_item_ref 가 행단위 차원행 EXISTS 검사.
#   PK=(prd_cd, opt_cd, item_seq) → guard = 그 자연키 NOT EXISTS.
# =====================================================================
# 각 항목: (opt_nm, item_seq, ref_dim, ref_key1_resolver, ref_key2, qty)
#   ref_key1_resolver: ('lit',code) | ('matname',mat_nm)[자재] | ('procname',proc_nm)[공정]
OPTION_ITEMS = [
    # --- 가공 그룹 ---
    ("열재단",     1, ".04", ("procname", "열재단"), None,       1),
    ("타공(4개)",  1, ".04", ("lit", "PROC_000079"), None,       1),
    ("타공(6개)",  1, ".04", ("lit", "PROC_000079"), None,       1),
    ("타공(8개)",  1, ".04", ("lit", "PROC_000079"), None,       1),
    ("양면테입",   1, ".03", ("lit", "MAT_000069"), "USAGE.07",  1),
    ("양면테입",   2, ".04", ("lit", "PROC_000081"), None,       1),
    ("봉미싱",     1, ".03", ("matname", "봉제사"),  "USAGE.07", 1),
    ("봉미싱",     2, ".04", ("lit", "PROC_000080"), None,       1),
    # --- 추가 그룹 (추가없음=센티넬, item 0행) ---
    ("큐방(4개)추가", 1, ".03", ("matname", "큐방"),  "USAGE.07", 4),
    ("큐방(4개)추가", 2, ".04", ("lit", "PROC_000081"), None,     4),
    ("끈(4개)추가",   1, ".03", ("lit", "MAT_000070"), "USAGE.07", 4),
    ("끈(4개)추가",   2, ".04", ("lit", "PROC_000081"), None,     4),
    ("각목(900이하)+끈(4개) 추가", 1, ".03", ("matname", "각목(900이하)"), "USAGE.07", 1),
    ("각목(900이하)+끈(4개) 추가", 2, ".03", ("lit", "MAT_000070"),        "USAGE.07", 4),
    ("각목(900이하)+끈(4개) 추가", 3, ".04", ("lit", "PROC_000081"),       None,       4),
    ("각목(900초과)+끈(4개) 추가", 1, ".03", ("matname", "각목(900초과)"), "USAGE.07", 1),
    ("각목(900초과)+끈(4개) 추가", 2, ".03", ("lit", "MAT_000070"),        "USAGE.07", 4),
    ("각목(900초과)+끈(4개) 추가", 3, ".04", ("lit", "PROC_000081"),       None,       4),
]

def opt_expr(opt_nm):
    return f"(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd={sql_str(PRD)} AND opt_nm={sql_str(opt_nm)} AND del_yn='N' ORDER BY opt_cd LIMIT 1)"

def refkey1_expr(resolver):
    kind, val = resolver
    if kind == "lit":
        return f"{sql_str(val)}"
    if kind == "matname":
        return f"(SELECT mat_cd FROM t_mat_materials WHERE mat_nm={sql_str(val)} AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1)"
    if kind == "procname":
        return f"(SELECT proc_cd FROM t_proc_processes WHERE proc_nm={sql_str(val)} AND del_yn='N' ORDER BY proc_cd LIMIT 1)"
    raise ValueError(resolver)

def gen_07():
    lines = [
        "-- =====================================================================",
        "-- step 07 — t_prd_product_option_items (BUNDLE 자재.03 + 공정.04 · 18행)",
        "-- [중요] 본 패키지가 자재 mint+링크(01/03)·열재단 mint+링크(02/04)를 선행하므로,",
        "--   prior _exec_silsa_banner 에서 BLOCKED 였던 자재 seq(.03 8행)+열재단(.04 1행)이 본 트랜잭션에서 INSERTABLE 승격.",
        "--   18행 = 공정 seq(.04) 9 [열재단·타공3·부착4·봉제1] + 자재 seq(.03) 9 [양면069·봉제사·큐방·끈070×3·각목338·각목339].",
        "-- 트리거 fn_chk_opt_item_ref 가 행단위 차원행 EXISTS 검사 → 03/04 선적재가 선행조건(같은 트랜잭션 내 순서로 충족).",
        "-- 멱등 가드 = (prd_cd, opt_cd, item_seq) NOT EXISTS. opt_cd=opt_nm resolve·mat_cd/proc_cd=이름 resolve(재실행 안전).",
        "-- ref_key1 NOT NULL(트리거 소스 확인). reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for opt_nm, seq, dim, r1, r2, qty in OPTION_ITEMS:
        oe = opt_expr(opt_nm)
        r1e = refkey1_expr(r1)
        r2e = sql_str(r2)
        lines.append(
            f"INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)\n"
            f"SELECT {sql_str(PRD)}, {oe}, {seq}, {sql_str('OPT_REF_DIM'+dim)}, {r1e}, {r2e}, {qty}, 'Y'\n"
            f"WHERE NOT EXISTS (\n"
            f"  SELECT 1 FROM t_prd_product_option_items\n"
            f"  WHERE prd_cd = {sql_str(PRD)} AND opt_cd = {oe} AND item_seq = {seq});"
        )
        prov.append(("07_t_prd_product_option_items.sql", "07", f"{opt_nm}#seq{seq} {dim} {r1[1]}", "load_silsa_v2 items+BLOCKED CSV(승격) + trigger fn_chk_opt_item_ref"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 08 — t_prd_product_constraints (R-GAKMOK · RULE_001)
#   각목↔세로변 호환. var=mat_cd(각목 material 재귀속·D-2 별 mat_cd 2개 모델).
#   rule_cd=RULE_001(상품별 카운터·D5). logic jsonb NOT NULL. siz_cd 멤버십 집합은 가격트랙 siz 등록 의존.
#   [차단 잔존] siz 76규격 미등록(가격트랙) → logic 의 세로 siz_cd 집합이 미완 → 본 적재에서는 BLOCKED 로 분리.
# =====================================================================
def gen_08():
    lines = [
        "-- =====================================================================",
        "-- step 08 — t_prd_product_constraints (R-GAKMOK · RULE_001) — BLOCKED(siz 의존)",
        "-- R-GAKMOK: 각목(900이하)↔세로변 900이하, 각목(900초과)↔세로변 900초과 호환.",
        "--   var=mat_cd(각목=material 재귀속·D-2 별 mat_cd 2개: MAT_000338/MAT_000339).",
        "--   rule_cd=RULE_001(상품별 카운터·D5). rule_typ_cd=RULE_TYPE.01(호환). logic jsonb NOT NULL.",
        "-- [BLOCKED] logic 의 siz_cd 멤버십 집합이 siz 76규격 미등록(가격트랙)으로 미완 → 본 트랜잭션 미적재.",
        "--   각목 mat_cd(338/339)는 본 패키지 mint 로 충족되나, siz 차원 집합 부재로 constraint 는 DEFER.",
        "--   siz 등록(가격트랙·인간승인) + 폼빌더 배열-멤버십 입력방식(F-1) 후 별도 적재 → _blocked/.",
        "-- =====================================================================",
        "SELECT '08: constraints — 0 rows now (R-GAKMOK GAP-DEFER: siz 76규격 미등록·F-1 폼빌더 미검증). _blocked/08_*.sql 참조' AS step_08;",
    ]
    prov.append(("08_t_prd_product_constraints.sql", "08", "R-GAKMOK RULE_001 (DEFER)", "load_silsa_v2/t_prd_product_constraints_GAP.csv (siz 의존 BLOCKED)"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 00 — markers (no INSERT) — applied decisions
# =====================================================================
def gen_00():
    return """-- =====================================================================
-- step 00 — pre-load markers (NO INSERT) — 적용된 설계 결정 명시
-- 일반현수막(PRD_000138) CPQ 옵션레이어 v2 + 마스터 mint · `_exec_silsa_cpq`
-- 권위: silsa-option-layer-v2.md (옵션 STRUCTURE) · code-identifier-strategy.md (코드 규약)
-- =====================================================================
-- [적용 결정]
--  D1 전략: 순차 surrogate PK 유지. 멱등=이름기반 NOT EXISTS(신규 DDL 0). 코드 재발급 없음.
--  D2 멱등키: option_groups=(prd_cd,opt_grp_nm) · options=(prd_cd,opt_grp_cd,opt_nm)
--             · materials=(mat_nm,mat_typ_cd) · processes=(proc_nm)
--             · materials_link/processes_link/option_items=자연키.
--  D3 separator: 신규 CPQ 코드 `_` 통일 (OPT_/OPV_). 기존 OPT-/OPV- 하이픈(삭제분)은 본 적재 미관여.
--  D4 채번: 라이브 MAX(suffix)+1 리터럴 부여 (생성 트리거 부재). 멱등은 이름키.
--           mat MAT_000337~340 · proc PROC_000084 · opt_grp OPT_000003~000004 · opt OPV_000006~000016.
--  D5 rule_cd: 상품별 카운터 RULE_001.
--  D-2 (적용): 각목 2규격 = 별 mat_cd 2개 (각목900이하=MAT_000338 · 각목900초과=MAT_000339).
--              사유: ref_param_json 부재(GAP-PARAM·D4 no-DDL) → 단일 mat_cd+param 불가 → 2 mat_cd 모델.
--  D① (반영): 타공=bare-hole(구멍만·아일렛 안 끼움)=process-only.
--  D② (반영): 봉미싱 실=자재 등록(MAT_000340 봉제사 mint).
--  D③ (반영): 각목=신규 mint(우드봉 차용 배제).
-- [search-before-mint 재확인 2026-06-09 live]: 큐방·각목·봉제사 t_mat_materials 0행(부재 재증명) → mint 정당.
--   끈 MAT_000070·양면테입 MAT_000069 = 실재(EXISTS) → LINK only(mint 안 함).
--   열재단 t_proc_processes 0행 → mint. 079/080/081 = 실재+PRD_000138 링크 실재.
-- [BLOCKED 잔존] R-GAKMOK constraint(siz 76규격 미등록 의존) → _blocked/08. 부착 enum 큐방 [CONFIRM].
-- [HARD] NEVER COMMIT — 로더 기본 ROLLBACK. mint=master-data INSERT(DDL 아님·CREATE/ALTER 없음).
SELECT '00: markers — applied decisions D1~D5/D-2/D①②③, search-before-mint reconfirmed' AS step_00;
"""

# ---------------------------------------------------------------------
def write(fn, content):
    with open(os.path.join(OUT, fn), "w") as f:
        f.write(content)

def main():
    write("00_preload_markers.sql", gen_00())
    write("01_t_mat_materials.sql", gen_01())
    write("02_t_proc_processes.sql", gen_02())
    write("03_t_prd_product_materials.sql", gen_03())
    write("04_t_prd_product_processes.sql", gen_04())
    write("05_t_prd_product_option_groups.sql", gen_05())
    write("06_t_prd_product_options.sql", gen_06())
    write("07_t_prd_product_option_items.sql", gen_07())
    write("08_t_prd_product_constraints.sql", gen_08())

    # provenance
    with open(os.path.join(OUT, "load.provenance.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sql_file", "step", "target_row_key", "source_authority"])
        for row in prov:
            w.writerow(row)

    print("generated:", len(prov), "provenance rows")

if __name__ == "__main__":
    main()
