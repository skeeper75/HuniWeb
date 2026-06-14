#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — Tier A 면적형 포스터·배너 13상품 CPQ 옵션레이어 멱등 적재 생성기
#   권위: 10_configurator/tierA/areaform-option-layer.md (옵션 STRUCTURE)
#         09_load/_exec_silsa_cpq/ (138 적재 패턴) · 00_schema/cpq-schema.md (트리거)
#   [HARD] 멱등 = 이름기반 NOT EXISTS 가드. surrogate 코드는 라이브 MAX+1 리터럴 부여.
#          존재검사는 코드가 아닌 *이름*으로 → 재실행 시 코드 재발급 없이 delta 0.
#   [HARD] NEVER COMMIT (로더 기본 ROLLBACK). DDL(CREATE/ALTER) 없음.
#   [HARD] BLOCKED(거치대 template·+끈/우드행거/천정고리 미링크 자재) = 본 적재 미관여 → _blocked/.
#   reg_dt 명시 생략(DEFAULT now()) — round-5 교훈.
#   라이브 실측 2026-06-14: opt_grp MAX=OPT_000004 → OPT_000005+ · opt MAX=OPV_000016 → OPV_000017+
# =====================================================================
import os, csv

OUT = os.path.dirname(os.path.abspath(__file__))

def sql_str(s):
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"

prov = []  # (sql_file, step, target_row_key, source)

# ---------------------------------------------------------------------
# surrogate 채번 카운터 (라이브 MAX+1 리터럴). 멱등은 이름키가 담당.
# ---------------------------------------------------------------------
_grp_n = 5   # OPT_000005~
_opt_n = 17  # OPV_000017~
def next_grp():
    global _grp_n
    cd = f"OPT_{_grp_n:06d}"; _grp_n += 1; return cd
def next_opt():
    global _opt_n
    cd = f"OPV_{_opt_n:06d}"; _opt_n += 1; return cd

# ---------------------------------------------------------------------
# 13상품 옵션 레이어 정의 (areaform-option-layer.md §2 권위).
#   groups: [(grp_key, grp_nm, sel_typ, min, max, mand, note)]
#   options: {grp_key: [(opt_nm, dflt, [items]), ...]}
#     item = (ref_dim, ref_key1_resolver, ref_key2, qty)
#       ref_key1_resolver: ('lit', code) — 라이브 실코드 직접
#       (센티넬/BLOCKED 옵션은 items=[])
#   nonspec: (W_min, W_max, H_min, H_max) or None
#   BLOCKED 옵션은 별도 표기(items_blocked) — 본 적재 제외, _blocked 기록.
# ---------------------------------------------------------------------
P = {}  # prd_cd -> spec

def coating_grp(has_none, dflt_none):
    opts = []
    if has_none:
        opts.append(("코팅없음", "Y" if dflt_none else "N", []))
        opts.append(("무광코팅", "N", [(".04", ("lit","PROC_000015"), None, 1)]))
        opts.append(("유광코팅", "N", [(".04", ("lit","PROC_000014"), None, 1)]))
    else:
        opts.append(("무광코팅", "Y", [(".04", ("lit","PROC_000015"), None, 1)]))
        opts.append(("유광코팅", "N", [(".04", ("lit","PROC_000014"), None, 1)]))
    return ("OG-COATING", "코팅", "SEL_TYPE.01", 0, 1, "N", "코팅 택1 선택", opts)

# --- 2-A 순수 코팅형 ---
P["PRD_000118"] = {"groups": [coating_grp(True, True)],  "nonspec": (200,1200,200,3000)}
P["PRD_000120"] = {"groups": [coating_grp(False,False)], "nonspec": (200,1200,200,3000)}
P["PRD_000121"] = {"groups": [coating_grp(False,False)], "nonspec": (200,1200,200,3000)}
P["PRD_000145"] = {"groups": [coating_grp(False,False)], "nonspec": None}

# --- 2-B 별색형 (122) ---
P["PRD_000122"] = {"groups": [
    ("OG-BYEOLSAEK", "화이트별색", "SEL_TYPE.01", 0, 1, "N", "화이트 underbase 별색 선택", [
        ("단면", "N", [(".04", ("lit","PROC_000008"), None, 1)]),
    ])], "nonspec": (200,1200,200,3000)}

# --- 2-C 패브릭 가공형 (124/125) ---
P["PRD_000125"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 0, 1, "N", "오버로크 봉제 가공", [
        ("오버로크", "Y", [(".04", ("lit","PROC_000080"), None, 1)]),
    ])], "nonspec": (200,1200,200,3000)}
P["PRD_000124"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 0, 1, "N", "봉제 가공 (유형 param=GAP-PARAM)", [
        ("오버로크", "Y", [(".04", ("lit","PROC_000080"), None, 1)]),
        ("말아박기", "N", [(".04", ("lit","PROC_000080"), None, 1)]),
        ("봉미싱(7cm)", "N", [(".04", ("lit","PROC_000080"), None, 1)]),
        # BLOCKED: 오버로크+리본끈 / 말아박기+면끈 (끈 자재 미링크) → items_blocked
    ], [  # blocked options
        ("오버로크+리본끈", "리본끈 자재 라이브 0행(GAP-RIBBON)·미링크"),
        ("말아박기+면끈", "면끈 자재 124 product_material 미링크(GAP-BUNDLE-LINK)"),
    ])], "nonspec": (200,1200,200,3000)}

# --- 2-D 족자/행잉형 (133/134/135) ---
P["PRD_000135"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 1, 1, "Y", "족자제작 필수 (모양 param=GAP)", [
        ("사각족자", "Y", [(".04", ("lit","PROC_000082"), None, 1)]),
        ("원형족자", "N", [(".04", ("lit","PROC_000082"), None, 1)]),
    ]),
    ("OG-CHUGA", "추가", "SEL_TYPE.01", 0, 1, "N", "천정형고리 추가 선택", [
        ("추가없음", "Y", []),  # 센티넬
    ], [
        ("천정형고리 포함", "천정고리 자재(MAT_000215) vs 셋트(PRD_000008) [CONFIRM]·135 미링크"),
    ])], "nonspec": None}
P["PRD_000133"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 1, 1, "Y", "오버로크 봉제 필수", [
        ("오버로크", "Y", [(".04", ("lit","PROC_000080"), None, 1)]),
    ]),
    ("OG-CHUGA", "추가", "SEL_TYPE.01", 0, 1, "N", "우드행거 추가 선택", [
        ("출력만", "Y", []),  # 센티넬
    ], [
        ("우드행거+면끈 포함", "우드행거 MAT_000229+면끈 자재 133 미링크(GAP-BUNDLE-LINK)"),
    ])], "nonspec": None}
P["PRD_000134"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 1, 1, "Y", "오버로크+봉미싱 봉제 필수 (복합유형=2 item)", [
        ("오버로크+봉미싱(4cm)", "Y", [(".04", ("lit","PROC_000080"), None, 1)]),
    ]),
    ("OG-CHUGA", "추가", "SEL_TYPE.01", 0, 1, "N", "우드봉 추가 선택", [
        ("출력만", "Y", []),  # 센티넬
    ], [
        ("우드봉+면끈 포함", "우드봉 MAT_000225+면끈 자재 134 미링크(GAP-BUNDLE-LINK)"),
    ])], "nonspec": None}

# --- 2-E 배너 거치대형 (136/137) ---
P["PRD_000136"] = {"groups": [
    ("OG-COATING", "코팅", "SEL_TYPE.01", 0, 1, "N", "코팅 택1 선택", [
        ("무광코팅", "Y", [(".04", ("lit","PROC_000015"), None, 1)]),
        ("유광코팅", "N", [(".04", ("lit","PROC_000014"), None, 1)]),
    ]),
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 1, 1, "Y", "4구타공 필수 (구수 param=GAP)", [
        ("4구타공", "Y", [(".04", ("lit","PROC_000079"), None, 1)]),
    ]),
    ("OG-CHUGA", "추가", "SEL_TYPE.01", 0, 1, "N", "배너거치대 추가 (template·BLOCKED)", [
        ("거치대없음", "Y", []),  # 센티넬
    ], [
        ("실내용배너거치대", "거치대 상품 라이브 미발견 → template base [CONFIRM]·GAP-ADDON-STAND"),
        ("실외용배너거치대", "거치대 상품 라이브 미발견 → template base [CONFIRM]·GAP-ADDON-STAND"),
    ])], "nonspec": None}
P["PRD_000137"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 1, 1, "Y", "4구타공 필수 (구수 param=GAP)", [
        ("4구타공", "Y", [(".04", ("lit","PROC_000079"), None, 1)]),
    ]),
    ("OG-CHUGA", "추가", "SEL_TYPE.01", 0, 1, "N", "배너거치대 추가 (template·BLOCKED)", [
        ("거치대없음", "Y", []),  # 센티넬
    ], [
        ("실내용배너거치대", "거치대 상품 라이브 미발견 → template base [CONFIRM]"),
        ("실외용배너거치대", "거치대 상품 라이브 미발견 → template base [CONFIRM]"),
    ])], "nonspec": None}

# --- 2-F 메쉬현수막 (139) — 138 형제 ---
#   [FINDING-1 보정] 재단만(PROC_000084)·끈추가(MAT_000070+PROC_000081)는 139에 product-link 미적재 =
#     L1 차원행 생성 필요 → 124/133/134/135 복합끈과 동일하게 BLOCKED 격리(L1 LINK 선적재=인간 승인 후 적재 대기).
#     타공(4/6/8)=PROC_000079 라이브 기존 링크 → INSERTABLE. 추가없음=센티넬 → INSERTABLE.
P["PRD_000139"] = {"groups": [
    ("OG-GAGONG", "가공", "SEL_TYPE.01", 1, 1, "Y", "타공 필수 (구수 param=GAP). 재단만=L1 LINK 의존 BLOCKED", [
        ("타공(4개)", "Y", [(".04", ("lit","PROC_000079"), None, 1)]),  # PROC_000079 기존 링크 → INSERTABLE. dflt 승격(재단만 BLOCKED)
        ("타공(6개)", "N", [(".04", ("lit","PROC_000079"), None, 1)]),
        ("타공(8개)", "N", [(".04", ("lit","PROC_000079"), None, 1)]),
    ], [  # blocked options (L1 LINK 의존)
        ("재단만", "열재단 PROC_000084 139 product-process 미링크(L1 LINK 선적재 의존·GAP-BUNDLE-LINK)"),
    ]),
    ("OG-CHUGA", "추가", "SEL_TYPE.01", 0, 1, "N", "끈추가=L1 LINK 의존 BLOCKED. 추가없음만 INSERTABLE", [
        ("추가없음", "Y", []),  # 센티넬 → INSERTABLE
    ], [  # blocked options (L1 LINK 의존)
        ("끈추가", "끈 MAT_000070+부착 PROC_000081 139 미링크(L1 LINK 선적재 의존·GAP-BUNDLE-LINK)"),
    ])], "nonspec": (500,900,500,3000)}

# ---------------------------------------------------------------------
# [FINDING-1 보정] L1 차원 LINK 선적재 — L2 옵션 트랜잭션에서 분리.
#   별도 _l1_link_preload.sql 패키지로 격리. "L1 차원 선적재·인간 승인 필요" — L2 적재의 선행 의존.
#   마스터 코드(PROC_000084/PROC_000081/MAT_000070)는 라이브 실재(발명 아님)이나, product-link INSERT는
#   L1 차원행 생성 → L2 옵션레이어 경계 밖. 이 LINK 적재(인간 승인) 후 139 재단만/끈추가가 INSERTABLE 승격.
#   PROD_LINK = [(prd_cd, kind, code, usage_cd, note)]  kind: 'mat'|'proc'
# ---------------------------------------------------------------------
L1_LINK_PRELOAD = [
    ("PRD_000139", "proc", "PROC_000084", None,      "열재단 공정 LINK (재단만 옵션 .04 선행조건·라이브 차원 실재·139 미링크)"),
    ("PRD_000139", "mat",  "MAT_000070", "USAGE.07", "끈 자재 LINK (끈추가 BUNDLE seq1 .03 선행조건·라이브 차원 실재·139 미링크)"),
    ("PRD_000139", "proc", "PROC_000081", None,      "부착 공정 LINK (끈추가 BUNDLE seq2 .04 선행조건·라이브 차원 실재·139 미링크)"),
]

PRD_ORDER = ["PRD_000118","PRD_000120","PRD_000121","PRD_000122","PRD_000124",
             "PRD_000125","PRD_000133","PRD_000134","PRD_000135","PRD_000136",
             "PRD_000137","PRD_000139","PRD_000145"]

# =====================================================================
# step 00 — markers
# =====================================================================
def gen_00():
    return """-- =====================================================================
-- step 00 — pre-load markers (NO INSERT) — Tier A 면적형 13상품 CPQ 옵션레이어
-- 권위: tierA/areaform-option-layer.md · _exec_silsa_cpq (138 패턴) · cpq-schema.md (트리거)
-- =====================================================================
-- [적용 결정]
--  D1 멱등=이름기반 NOT EXISTS(신규 DDL 0·코드 재발급 없음). D3 separator `_`(OPT_/OPV_).
--  D4 채번 라이브 MAX+1: opt_grp OPT_000005~ · opt OPV_000017~ (138 점유 OPT_000004/OPV_000016 다음).
--  prn=0 13상품 전부 → 도수 OG 0개. 소재 1행 → 소재 OG 0개. 비규격=products 범위+constraint(option_item 아님).
--  가공 param(타공 구수·봉제 유형·족자 모양)=GAP-PARAM(ref_param_json 미구현) → option_item은 공정행만 가리킴.
-- [BLOCKED 격리] 본 L2 적재 미관여 (차원행/LINK 재적재 안 함):
--  · 거치대 template (136/137 실내/실외) — 거치대 상품 라이브 미발견(GAP-ADDON-STAND)
--  · +끈/+면끈/+우드행거/+우드봉/+천정고리 BUNDLE 자재 미링크 (124/133/134/135 — GAP-BUNDLE-LINK)
--  · 리본끈 자재 라이브 0행 (124 — GAP-RIBBON)
--  · 139 재단만(PROC_000084)·끈추가(MAT_000070+PROC_000081) — L1 LINK 의존 BLOCKED [FINDING-1 보정·일관성]
-- [FINDING-1 보정] L1 차원 LINK 선적재(product-materials/processes INSERT)는 L2 옵션 트랜잭션에서 분리.
--  · _l1_link_preload.sql (별도 패키지·인간 승인 필요) — L2 적재의 선행 의존. apply.sql(L2 순수)에 비포함.
--  · 마스터 코드는 라이브 실재(발명 아님)이나 product-link INSERT=L1 차원행 생성=L2 경계 밖.
-- [HARD] NEVER COMMIT — 로더 기본 ROLLBACK. apply.sql=DDL/L1 LINK 없는 순수 L2 옵션레이어 INSERT.
SELECT '00: markers — Tier A 13 products, OG from OPT_000005/OPV_000017, L1 LINK separated, BLOCKED isolated' AS step_00;
"""

# =====================================================================
# _l1_link_preload.sql — L1 차원 LINK 선적재 (L2 옵션 트랜잭션에서 분리·인간 승인 필요)
#   [FINDING-1 보정] product-materials/processes INSERT = L1 차원행 생성 → apply.sql(L2 순수) 비포함.
#   이 패키지를 인간 승인 적재한 후에만 139 재단만/끈추가 option_items 가 INSERTABLE 승격.
# =====================================================================
def gen_l1_link():
    lines = [
        "-- =====================================================================",
        "-- _l1_link_preload.sql — L1 차원 LINK 선적재 (apply.sql L2 트랜잭션 비포함·별도 인간 승인)",
        "-- [FINDING-1 보정] product-materials/processes INSERT = L1 차원행 생성 → L2 옵션레이어 경계 밖.",
        "--   124/133/134/135 복합끈 BLOCKED 와 동일 처리(차원 LINK 선적재=인간 승인). 139만 LINK 묶던 불일치 해소.",
        "-- 끈 MAT_000070·열재단 PROC_000084·부착 PROC_000081 = 라이브 차원 실재(mint 불요·LINK only)·139 미링크.",
        "-- 이 패키지 적재(인간 승인) 후 139 재단만/끈추가 option_items 가 트리거 통과(INSERTABLE 승격).",
        "-- 멱등 가드 = 자연키 NOT EXISTS. reg_dt 생략→DEFAULT now(). 손편집 금지. NEVER COMMIT by default.",
        "-- =====================================================================",
    ]
    for prd, kind, code, usage, note in L1_LINK_PRELOAD:
        if kind == "mat":
            lines.append(
                f"INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)\n"
                f"SELECT {sql_str(prd)}, {sql_str(code)}, {sql_str(usage)}, 'N', 10\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials\n"
                f"  WHERE prd_cd={sql_str(prd)} AND mat_cd={sql_str(code)} AND usage_cd={sql_str(usage)});"
            )
        else:
            lines.append(
                f"INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)\n"
                f"SELECT {sql_str(prd)}, {sql_str(code)}, 'N', 10\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes\n"
                f"  WHERE prd_cd={sql_str(prd)} AND proc_cd={sql_str(code)});"
            )
        prov.append(("_l1_link_preload.sql", "L1-LINK", f"{prd} LINK {kind} {code}", "FINDING-1 보정 L1 분리 + " + note))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 02 — t_prd_product_option_groups
# =====================================================================
def gen_02():
    lines = [
        "-- =====================================================================",
        "-- step 02 — t_prd_product_option_groups (OPT_000005~)",
        "-- 멱등 가드 = (prd_cd, opt_grp_nm) NOT EXISTS. 코드=라이브 MAX+1 리터럴(OPT_000005~).",
        "-- 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for prd in PRD_ORDER:
        spec = P[prd]
        for i, g in enumerate(spec["groups"], start=1):
            grp_key, grp_nm, sel, mn, mx, mand, note = g[0], g[1], g[2], g[3], g[4], g[5], g[6]
            cd = g[-1] if isinstance(g[-1], str) and g[-1].startswith("OPT_") else None
            cd = next_grp()
            g_local = list(g); g_local.append(cd)
            P[prd].setdefault("_grp_codes", {})[grp_key] = cd
            lines.append(
                f"INSERT INTO t_prd_product_option_groups\n"
                f"  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)\n"
                f"SELECT {sql_str(prd)}, {sql_str(cd)}, {sql_str(grp_nm)}, {sql_str(sel)}, {mn}, {mx}, {sql_str(mand)}, {i}, 'Y', {sql_str(note)}\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups\n"
                f"  WHERE prd_cd={sql_str(prd)} AND opt_grp_nm={sql_str(grp_nm)} AND del_yn='N');"
            )
            prov.append(("02_t_prd_product_option_groups.sql", "02", f"{prd}/{grp_nm} → {cd}", "areaform-option-layer.md §2 + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 03 — t_prd_product_options
# =====================================================================
def grp_expr(prd, grp_nm):
    return (f"(SELECT opt_grp_cd FROM t_prd_product_option_groups "
            f"WHERE prd_cd={sql_str(prd)} AND opt_grp_nm={sql_str(grp_nm)} AND del_yn='N' "
            f"ORDER BY opt_grp_cd LIMIT 1)")

def gen_03():
    lines = [
        "-- =====================================================================",
        "-- step 03 — t_prd_product_options (OPV_000017~)",
        "-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS. opt_grp_cd = 그룹 이름 resolve(재실행 안전).",
        "-- 코드=라이브 MAX+1 리터럴(OPV_000017~). BLOCKED 옵션은 미적재(_blocked 기록). reg_dt 생략. 손편집 금지.",
        "-- =====================================================================",
    ]
    for prd in PRD_ORDER:
        spec = P[prd]
        for g in spec["groups"]:
            grp_nm = g[1]; opts = g[7]
            ge = grp_expr(prd, grp_nm)
            for di, o in enumerate(opts, start=1):
                opt_nm, dflt, items = o[0], o[1], o[2]
                cd = next_opt()
                P[prd].setdefault("_opt_codes", {})[(grp_nm, opt_nm)] = (cd, items)
                lines.append(
                    f"INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn)\n"
                    f"SELECT {sql_str(prd)}, {sql_str(cd)}, {ge}, {sql_str(opt_nm)}, {sql_str(dflt)}, {di}, 'Y'\n"
                    f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options\n"
                    f"  WHERE prd_cd={sql_str(prd)} AND opt_grp_cd={ge} AND opt_nm={sql_str(opt_nm)} AND del_yn='N');"
                )
                prov.append(("03_t_prd_product_options.sql", "03", f"{prd}/{grp_nm}/{opt_nm} → {cd}", "areaform-option-layer.md §2 + live MAX+1"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 04 — t_prd_product_option_items (.03 자재 + .04 공정)
# =====================================================================
def opt_expr(prd, opt_nm):
    return (f"(SELECT opt_cd FROM t_prd_product_options "
            f"WHERE prd_cd={sql_str(prd)} AND opt_nm={sql_str(opt_nm)} AND del_yn='N' "
            f"ORDER BY opt_cd LIMIT 1)")

def gen_04():
    lines = [
        "-- =====================================================================",
        "-- step 04 — t_prd_product_option_items (.03 자재 / .04 공정 — polymorphic)",
        "-- 트리거 fn_chk_opt_item_ref 행단위 차원행 EXISTS 검사 → step 01 LINK 선행이 139 끈추가 충족.",
        "-- 멱등 가드 = (prd_cd, opt_cd, item_seq) NOT EXISTS. opt_cd=opt_nm resolve(재실행 안전).",
        "-- ref_key1 NOT NULL. 센티넬(코팅없음/추가없음/출력만)=item 0행. BLOCKED 옵션=미적재. reg_dt 생략. 손편집 금지.",
        "-- =====================================================================",
    ]
    for prd in PRD_ORDER:
        spec = P[prd]
        for g in spec["groups"]:
            grp_nm = g[1]; opts = g[7]
            for o in opts:
                opt_nm, items = o[0], o[2]
                oe = opt_expr(prd, opt_nm)
                for seq, (dim, r1res, r2, qty) in enumerate(items, start=1):
                    kind, code = r1res  # ('lit', code)
                    r1 = sql_str(code)
                    r2e = sql_str(r2)
                    lines.append(
                        f"INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)\n"
                        f"SELECT {sql_str(prd)}, {oe}, {seq}, {sql_str('OPT_REF_DIM'+dim)}, {r1}, {r2e}, {qty}, 'Y'\n"
                        f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items\n"
                        f"  WHERE prd_cd={sql_str(prd)} AND opt_cd={oe} AND item_seq={seq});"
                    )
                    prov.append(("04_t_prd_product_option_items.sql", "04", f"{prd}/{opt_nm}#seq{seq} {dim} {code}", "areaform-option-layer.md §2 + trigger fn_chk_opt_item_ref"))
    return "\n".join(lines) + "\n"

# =====================================================================
# step 05 — t_prd_product_constraints (R-SIZE-NONSPEC × 7)
# =====================================================================
import json
def nonspec_logic(w0,w1,h0,h1):
    return {"or": [
        {"!=": [{"var":"size_mode"}, "nonspec"]},
        {"and": [
            {">=": [{"var":"width"}, w0]}, {"<=": [{"var":"width"}, w1]},
            {">=": [{"var":"height"}, h0]}, {"<=": [{"var":"height"}, h1]},
        ]},
    ]}

def gen_05():
    lines = [
        "-- =====================================================================",
        "-- step 05 — t_prd_product_constraints (R-SIZE-NONSPEC · RULE_001 — 7상품)",
        "-- 비규격 입력 7상품(118/120/121/122/124/125/139). 규격이면 통과·사용자입력이면 4변 범위.",
        "-- rule_cd=RULE_001(상품별 카운터·D5). rule_typ_cd=RULE_TYPE.01(compatible). logic jsonb NOT NULL.",
        "-- 멱등 가드 = (prd_cd, rule_cd) NOT EXISTS. reg_dt 생략→DEFAULT now(). 손편집 금지.",
        "-- =====================================================================",
    ]
    for prd in PRD_ORDER:
        ns = P[prd].get("nonspec")
        if not ns:
            continue
        logic = json.dumps(nonspec_logic(*ns), ensure_ascii=False)
        err = f"가로 {ns[0]}~{ns[1]}mm, 세로 {ns[2]}~{ns[3]}mm 범위로 입력하세요"
        lines.append(
            f"INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)\n"
            f"SELECT {sql_str(prd)}, 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', {sql_str(logic)}::jsonb, {sql_str(err)}, 'Y', 1\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints\n"
            f"  WHERE prd_cd={sql_str(prd)} AND rule_cd='RULE_001');"
        )
        prov.append(("05_t_prd_product_constraints.sql", "05", f"{prd} R-SIZE-NONSPEC RULE_001", "areaform-option-layer.md §3 + products.nonspec_*"))
    lines.append("-- NOTE: constraint_json compile 캐시(t_prd_products.constraint_json) 갱신은 인간 승인 COMMIT 후 별도 (활성 rule AND).")
    return "\n".join(lines) + "\n"

# ---------------------------------------------------------------------
def write(fn, content):
    with open(os.path.join(OUT, fn), "w") as f:
        f.write(content)

def main():
    write("00_preload_markers.sql", gen_00())
    # [FINDING-1] L1 차원 LINK = 별도 패키지(apply.sql L2 트랜잭션 비포함·인간 승인 선행)
    write("_l1_link_preload.sql", gen_l1_link())
    # L2 순수 옵션레이어 (LINK 비포함)
    write("02_t_prd_product_option_groups.sql", gen_02())
    write("03_t_prd_product_options.sql", gen_03())
    write("04_t_prd_product_option_items.sql", gen_04())
    write("05_t_prd_product_constraints.sql", gen_05())

    with open(os.path.join(OUT, "load.provenance.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sql_file", "step", "target_row_key", "source_authority"])
        for row in prov:
            w.writerow(row)

    print("generated:", len(prov), "provenance rows")
    # counts (L2 순수·INSERTABLE)
    n_grp = sum(len(P[p]["groups"]) for p in PRD_ORDER)
    n_opt = sum(len(g[7]) for p in PRD_ORDER for g in P[p]["groups"])
    n_item = sum(len(o[2]) for p in PRD_ORDER for g in P[p]["groups"] for o in g[7])
    n_block = sum(len(g[8]) for p in PRD_ORDER for g in P[p]["groups"] if len(g) > 8)
    n_cons = sum(1 for p in PRD_ORDER if P[p].get("nonspec"))
    n_l1link = len(L1_LINK_PRELOAD)
    print(f"[L2 pure] groups={n_grp} options={n_opt} items(INSERTABLE)={n_item} blocked_options={n_block} constraints={n_cons}")
    print(f"[L1 separated] link_preload={n_l1link} (apply.sql 비포함·인간 승인 선행)")

if __name__ == "__main__":
    main()
