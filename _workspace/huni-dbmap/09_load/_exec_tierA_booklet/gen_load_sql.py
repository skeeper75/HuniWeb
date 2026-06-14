#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — 책자 Tier A 4상품 CPQ 옵션레이어 멱등 적재 SQL 생성기
#   대상: PRD_000068 중철 · PRD_000069 무선 · PRD_000071 트윈링 · PRD_000094 엽서북
#   silsa(_exec_silsa_cpq) 패턴 모방: INSERT…SELECT…WHERE NOT EXISTS(자연키),
#   surrogate 코드=라이브 MAX+1 리터럴(`_` separator), 옵션아이템=이름 resolve(재실행 안전).
#   차원행은 모두 라이브 실재(BLOCKED 0) — 차원 mint 단계 없음.
#
#   산출: 05_*.sql(groups) 06_*.sql(options) 07_*.sql(option_items) 08_*.sql(constraints=0)
#   NEVER COMMIT — apply.sh가 ROLLBACK 주입(기본 DRY-RUN).
# =====================================================================
import os

HERE = os.path.dirname(os.path.abspath(__file__))

# 라이브 채번 시작 (MAX+1, `_` separator). groups MAX=5→6, options MAX=16→17.
GRP_START = 6
OPT_START = 17

# ---------------------------------------------------------------------
# 상품별 옵션 레이어 정의 (라이브 실측 차원행 기준).
#   group: (disp_seq, opt_grp_nm, sel_typ, min_sel, max_sel, mand_yn, note)
#   options 표현 2가지:
#     - 'enum': 명시 옵션 리스트 [(opt_nm, dflt_yn, [items...])]
#     - 'mat_usage': 라이브 자재행 전개(usage_cd) — 1자재=1옵션, item=.03 mat_cd+usage
#   item dict: {dim, key1, key1_resolve, key2, qty}
#     key1_resolve: 'literal'|'proc_nm'(공정이름→proc_cd)|'mat_nm'(자재이름→mat_cd)
# ---------------------------------------------------------------------

PRODUCTS = {
    "PRD_000068": {  # 중철책자
        "groups": [
            {"seq":1,"nm":"사이즈","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum",
             "note":"사이즈 택1 필수. L1 disp 1.",
             "options":[("A5(148x210mm)","Y",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000170","res":"literal"}]),
                        ("A4(210x297mm)","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000172","res":"literal"}])]},
            {"seq":2,"nm":"내지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage",
             "usage":"USAGE.01","note":"내지종이 택1 필수 (자재 usage 내지). L1 disp 2."},
            {"seq":3,"nm":"내지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum",
             "note":"내지인쇄 택1 필수 (도수). L1 disp 3.",
             "options":[("양면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("단면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":4,"nm":"표지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage",
             "usage":"USAGE.02","note":"표지종이 택1 필수 (자재 usage 표지). L1 disp 4."},
            {"seq":5,"nm":"표지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum",
             "note":"표지인쇄 택1 필수. 도수 차원 내지와 공유(GAP-DOSU-USAGE). L1 disp 5.",
             "options":[("양면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("단면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":6,"nm":"표지코팅","sel":"01","min":0,"max":1,"mand":"N","mode":"enum",
             "note":"표지코팅 택1 선택 (코팅없음 센티넬 min0). L1 disp 6.",
             "options":[("유광","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000014","res":"literal"}]),
                        ("무광","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000015","res":"literal"}])]},
            {"seq":9,"nm":"제본","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum",
             "note":"제본 택1 필수 (택일그룹·excl 흡수). L1 disp 9 필수.",
             "options":[("중철제본","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000018","res":"literal"}])]},
        ],
        "sets": None,
    },
    "PRD_000069": {  # 무선책자
        "groups": [
            {"seq":1,"nm":"사이즈","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum",
             "note":"사이즈 택1 필수.",
             "options":[("A5(148x210mm)","Y",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000170","res":"literal"}]),
                        ("A4(210x297mm)","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000172","res":"literal"}])]},
            {"seq":2,"nm":"내지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage","usage":"USAGE.01","note":"내지종이 택1 필수."},
            {"seq":3,"nm":"내지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"내지인쇄 택1 필수.",
             "options":[("양면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("단면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":4,"nm":"표지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage","usage":"USAGE.02","note":"표지종이 택1 필수."},
            {"seq":5,"nm":"표지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"표지인쇄 택1 필수. 도수 공유(GAP-DOSU-USAGE).",
             "options":[("양면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("단면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":6,"nm":"표지코팅","sel":"01","min":0,"max":1,"mand":"N","mode":"enum","note":"표지코팅 택1 선택 (코팅없음 min0).",
             "options":[("유광","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000014","res":"literal"}]),
                        ("무광","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000015","res":"literal"}])]},
            {"seq":8,"nm":"박/형압","sel":"02","min":0,"max":10,"mand":"N","mode":"enum",
             "note":"박/형압 다중 선택 (SEL_TYPE.02 max10). 크기 param=GAP-PARAM(미반영). L1 disp 8.",
             "options":[("홀로그램","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000037","res":"literal"}]),
                        ("금유광","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000038","res":"literal"}]),
                        ("은유광","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000039","res":"literal"}]),
                        ("먹유광","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000040","res":"literal"}]),
                        ("동박","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000041","res":"literal"}]),
                        ("적박","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000042","res":"literal"}]),
                        ("청박","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000043","res":"literal"}]),
                        ("트윙클","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000044","res":"literal"}]),
                        ("형압(양각)","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000051","res":"literal"}]),
                        ("형압(음각)","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000052","res":"literal"}])]},
            {"seq":9,"nm":"제본","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"제본 택1 필수 (택일그룹).",
             "options":[("무선제본","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000019","res":"literal"}])]},
        ],
        "sets": None,
    },
    "PRD_000071": {  # 트윈링책자
        "groups": [
            {"seq":1,"nm":"사이즈","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"사이즈 택1 필수 (4종).",
             "options":[("A5(148x210mm)","Y",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000170","res":"literal"}]),
                        ("A4(210x297mm)","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000172","res":"literal"}]),
                        ("A5(210x148mm)","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000253","res":"literal"}]),
                        ("A4(297x210mm)","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000255","res":"literal"}])]},
            {"seq":2,"nm":"내지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage","usage":"USAGE.01","note":"내지종이 택1 필수."},
            {"seq":3,"nm":"내지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"내지인쇄 택1 필수.",
             "options":[("단면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("양면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":4,"nm":"표지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage","usage":"USAGE.02","note":"표지종이 택1 필수."},
            {"seq":5,"nm":"표지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"표지인쇄 택1 필수. 도수 공유(GAP-DOSU-USAGE).",
             "options":[("단면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("양면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":6,"nm":"표지코팅","sel":"01","min":0,"max":1,"mand":"N","mode":"enum","note":"표지코팅 택1 선택 (min0).",
             "options":[("유광","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000014","res":"literal"}]),
                        ("무광","N",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000015","res":"literal"}])]},
            {"seq":7,"nm":"투명커버","sel":"01","min":0,"max":1,"mand":"N","mode":"enum",
             "note":"투명커버 택1 선택 (투명커버없음 min0). 자재 USAGE.05(필름). L1 disp 7.",
             "options":[("유광투명커버","Y",[{"dim":"OPT_REF_DIM.03","key1":"MAT_000244","key2":"USAGE.05","res":"literal"}]),
                        ("무광투명커버","N",[{"dim":"OPT_REF_DIM.03","key1":"MAT_000245","key2":"USAGE.05","res":"literal"}])]},
            {"seq":9,"nm":"제본","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"제본 택1 필수 (택일그룹).",
             "options":[("트윈링제본","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000021","res":"literal"}])]},
            {"seq":10,"nm":"링컬러","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum",
             "note":"링컬러 택1 필수. 자재 USAGE.07(금속). L1 disp 10. color-chip 후보(hex 부재).",
             "options":[("화이트링","Y",[{"dim":"OPT_REF_DIM.03","key1":"MAT_000013","key2":"USAGE.07","res":"literal"}]),
                        ("블랙링","N",[{"dim":"OPT_REF_DIM.03","key1":"MAT_000014","key2":"USAGE.07","res":"literal"}]),
                        ("메탈링","N",[{"dim":"OPT_REF_DIM.03","key1":"MAT_000015","key2":"USAGE.07","res":"literal"}])]},
        ],
        "sets": None,
    },
    "PRD_000094": {  # 엽서북
        "groups": [
            {"seq":1,"nm":"사이즈","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"사이즈 택1 필수 (3종).",
             "options":[("100x150","Y",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000003","res":"literal"}]),
                        ("135x135","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000004","res":"literal"}]),
                        ("150x100","N",[{"dim":"OPT_REF_DIM.01","key1":"SIZ_000124","res":"literal"}])]},
            {"seq":2,"nm":"내지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage","usage":"USAGE.01","note":"내지종이 택1 필수 (몽블랑240 1종)."},
            {"seq":3,"nm":"내지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"내지인쇄 택1 필수.",
             "options":[("단면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("양면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":4,"nm":"표지종이","sel":"01","min":1,"max":1,"mand":"Y","mode":"mat_usage","usage":"USAGE.02","note":"표지종이 택1 필수 (스노우300 1종)."},
            {"seq":5,"nm":"표지인쇄","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"표지인쇄 택1 필수. 도수 공유(GAP-DOSU-USAGE).",
             "options":[("단면","Y",[{"dim":"OPT_REF_DIM.06","key1":"1","res":"literal"}]),
                        ("양면","N",[{"dim":"OPT_REF_DIM.06","key1":"2","res":"literal"}])]},
            {"seq":6,"nm":"표지코팅","sel":"01","min":0,"max":1,"mand":"N","mode":"enum","note":"표지코팅 택1 선택 (무광 1종, min0).",
             "options":[("무광","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000015","res":"literal"}])]},
            {"seq":9,"nm":"제본","sel":"01","min":1,"max":1,"mand":"Y","mode":"enum","note":"제본 택1 필수 (떡제본 택일그룹).",
             "options":[("떡제본","Y",[{"dim":"OPT_REF_DIM.04","key1":"PROC_000022","res":"literal"}])]},
        ],
        # set = BOM 구성 (CONFIRM §5.4) — 셋트 option_group 1개 + .07 2 item, mand_yn=N
        "sets": {"seq":11,"nm":"셋트구성","sel":"01","min":0,"max":1,"mand":"N","mode":"enum",
                 "note":"엽서북 BOM 구성 (내지+표지 sub_prd). CONFIRM §5.4: BOM vs 사용자옵션·미노출 hidden 후보(GAP-HIDDEN).",
                 "options":[("엽서북-내지","Y",[{"dim":"OPT_REF_DIM.07","key1":"PRD_000095","res":"literal"}]),
                            ("엽서북-표지","N",[{"dim":"OPT_REF_DIM.07","key1":"PRD_000096","res":"literal"}])]},
    },
}

HDR = "-- =====================================================================\n"

def esc(s):
    return s.replace("'", "''")

# ---------------------------------------------------------------------
# 05 — option_groups : (prd_cd, opt_grp_nm) NOT EXISTS 가드, 리터럴 코드 MAX+1
# ---------------------------------------------------------------------
def gen_groups():
    lines = [HDR,
        "-- step 05 — t_prd_product_option_groups (책자 4상품)\n",
        "-- 멱등 가드 = (prd_cd, opt_grp_nm, del_yn='N') NOT EXISTS. 코드=라이브 MAX(5)+1, `_` separator.\n",
        "-- 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.\n", HDR]
    g = GRP_START
    grpcode = {}  # (prd, nm) -> opt_grp_cd
    for prd, spec in PRODUCTS.items():
        groups = list(spec["groups"])
        if spec["sets"]:
            groups = groups + [spec["sets"]]
        for grp in groups:
            code = f"OPT_{g:06d}"
            grpcode[(prd, grp["nm"])] = code
            note = esc(grp["note"])
            lines.append(
                "INSERT INTO t_prd_product_option_groups\n"
                "  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)\n"
                f"SELECT '{prd}', '{code}', '{esc(grp['nm'])}', 'SEL_TYPE.{grp['sel']}', {grp['min']}, {grp['max']}, '{grp['mand']}', {grp['seq']}, 'Y', '{note}'\n"
                "WHERE NOT EXISTS (\n"
                "  SELECT 1 FROM t_prd_product_option_groups\n"
                f"  WHERE prd_cd = '{prd}' AND opt_grp_nm = '{esc(grp['nm'])}' AND del_yn = 'N');\n")
            g += 1
    return "".join(lines), grpcode

# ---------------------------------------------------------------------
# 06 — options : 전 옵션 opt_cd 동적 채번(MAX+1 at insert time, 리터럴 0)으로
#   enum/mat_usage 간 코드 충돌 방지 + 멱등(이름 가드). enum도 DO 블록(VALUES 배열 순회).
#   opt_grp_cd는 이름 resolve(05 선행). [HARD] 리터럴 opt_cd 미사용(충돌·재발급 0).
# ---------------------------------------------------------------------
def gen_options():
    lines = [HDR,
        "-- step 06 — t_prd_product_options (책자 4상품)\n",
        "-- [HARD] opt_cd = 동적 채번(삽입 시점 MAX(OPV_*)+1, 리터럴 0) → enum/mat_usage 충돌 0·재발급 0.\n",
        "-- 멱등 가드 = (prd_cd, opt_nm, opt_grp resolve) NOT EXISTS. opt_grp_cd=이름 resolve(05 선행).\n",
        "-- enum=고정 옵션 배열 순회 DO 블록, mat_usage=라이브 자재행 순회 DO 블록.\n", HDR]
    for prd, spec in PRODUCTS.items():
        groups = list(spec["groups"])
        if spec["sets"]:
            groups = groups + [spec["sets"]]
        for grp in groups:
            if grp["mode"] == "enum":
                # ARRAY[(opt_nm, dflt_yn)...] 순회. opt_cd=MAX+1 매 행.
                pairs = ",".join([f"('{esc(nm)}','{dflt}')" for (nm,dflt,_items) in grp["options"]])
                lines.append(
                    f"-- {prd} {grp['nm']} (enum {len(grp['options'])} 옵션, opt_cd 동적)\n"
                    "DO $$\n"
                    "DECLARE r RECORD; v_grp varchar; v_max int;\n"
                    "BEGIN\n"
                    f"  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='{prd}' AND opt_grp_nm='{esc(grp['nm'])}' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;\n"
                    f"  FOR r IN SELECT * FROM (VALUES {pairs}) AS t(opt_nm, dflt_yn) LOOP\n"
                    f"    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='{prd}' AND opt_nm=r.opt_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN\n"
                    "      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;\n"
                    "      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)\n"
                    f"      VALUES ('{prd}', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.opt_nm, r.dflt_yn, {grp['seq']}, 'Y', '{esc(grp['nm'])}');\n"
                    "    END IF;\n"
                    "  END LOOP;\n"
                    "END $$;\n")
            else:  # mat_usage — 라이브 자재행 전개, opt_cd 동적.
                usage = grp["usage"]
                lines.append(
                    f"-- {prd} {grp['nm']} (mat_usage {usage}, 라이브 자재행 전개, opt_cd 동적)\n"
                    "DO $$\n"
                    "DECLARE r RECORD; v_grp varchar; v_max int; v_i int := 0;\n"
                    "BEGIN\n"
                    f"  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='{prd}' AND opt_grp_nm='{esc(grp['nm'])}' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;\n"
                    f"  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd\n"
                    f"           WHERE pm.prd_cd='{prd}' AND pm.usage_cd='{usage}' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP\n"
                    f"    IF NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='{prd}' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N') THEN\n"
                    "      v_i := v_i + 1;\n"
                    "      SELECT COALESCE(MAX(regexp_replace(opt_cd,'[^0-9]','','g')::int),0)+1 INTO v_max FROM t_prd_product_options;\n"
                    "      INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)\n"
                    f"      VALUES ('{prd}', 'OPV_'||lpad(v_max::text,6,'0'), v_grp, r.mat_nm, CASE WHEN v_i=1 THEN 'Y' ELSE 'N' END, {grp['seq']}, 'Y', '{esc(grp['nm'])} (자재 {usage})');\n"
                    "    END IF;\n"
                    "  END LOOP;\n"
                    "END $$;\n")
    return "".join(lines)

# ---------------------------------------------------------------------
# 07 — option_items : 1 option = 1 item (포인터). 트리거 fn_chk_opt_item_ref.
#   enum: 명시 items. mat_usage: 자재 option별 .03 mat_cd+usage item(DO 블록).
#   opt_cd=opt_nm resolve. ref_key1 NOT NULL.
# ---------------------------------------------------------------------
def gen_items():
    lines = [HDR,
        "-- step 07 — t_prd_product_option_items (책자 4상품, 포인터)\n",
        "-- 멱등 가드 = (prd_cd, opt_cd resolve, item_seq) NOT EXISTS. opt_cd=opt_nm resolve(재실행 안전).\n",
        "-- 트리거 fn_chk_opt_item_ref: .01 siz_cd · .03 mat_cd+usage_cd · .04 proc_cd · .06 opt_id::int · .07 sub_prd_cd.\n",
        "-- ref_key1 NOT NULL. reg_dt 생략→DEFAULT now(). 손편집 금지.\n", HDR]
    for prd, spec in PRODUCTS.items():
        groups = list(spec["groups"])
        if spec["sets"]:
            groups = groups + [spec["sets"]]
        for grp in groups:
            if grp["mode"] == "enum":
                for (opt_nm, dflt, items) in grp["options"]:
                    opt_resolve = (
                        f"(SELECT opt_cd FROM t_prd_product_options WHERE prd_cd='{prd}' "
                        f"AND opt_nm='{esc(opt_nm)}' "
                        f"AND opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups WHERE prd_cd='{prd}' AND opt_grp_nm='{esc(grp['nm'])}' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1) "
                        f"AND del_yn='N' ORDER BY opt_cd LIMIT 1)")
                    for i, it in enumerate(items, start=1):
                        k2 = f"'{it['key2']}'" if it.get("key2") else "NULL"
                        qty = it.get("qty", 1)
                        lines.append(
                            "INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)\n"
                            f"SELECT '{prd}', {opt_resolve}, {i}, '{it['dim']}', '{it['key1']}', {k2}, {qty}, 'Y'\n"
                            "WHERE NOT EXISTS (\n"
                            "  SELECT 1 FROM t_prd_product_option_items\n"
                            f"  WHERE prd_cd='{prd}' AND opt_cd={opt_resolve} AND item_seq={i});\n")
            else:  # mat_usage — 자재 option별 .03 item(DO 블록, opt_nm=자재명 resolve)
                usage = grp["usage"]
                lines.append(
                    f"-- {prd} {grp['nm']} items (mat_usage {usage}): 자재 option별 .03 mat_cd+usage item\n"
                    "DO $$\n"
                    "DECLARE r RECORD; v_grp varchar; v_opt varchar;\n"
                    "BEGIN\n"
                    f"  SELECT opt_grp_cd INTO v_grp FROM t_prd_product_option_groups WHERE prd_cd='{prd}' AND opt_grp_nm='{esc(grp['nm'])}' AND del_yn='N' ORDER BY opt_grp_cd LIMIT 1;\n"
                    f"  FOR r IN SELECT pm.mat_cd, m.mat_nm FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd\n"
                    f"           WHERE pm.prd_cd='{prd}' AND pm.usage_cd='{usage}' AND pm.del_yn='N' ORDER BY pm.mat_cd LOOP\n"
                    f"    SELECT opt_cd INTO v_opt FROM t_prd_product_options WHERE prd_cd='{prd}' AND opt_nm=r.mat_nm AND opt_grp_cd=v_grp AND del_yn='N' ORDER BY opt_cd LIMIT 1;\n"
                    "    IF v_opt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='" + prd + "' AND opt_cd=v_opt AND item_seq=1) THEN\n"
                    "      INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)\n"
                    f"      VALUES ('{prd}', v_opt, 1, 'OPT_REF_DIM.03', r.mat_cd, '{usage}', 1, 'Y');\n"
                    "    END IF;\n"
                    "  END LOOP;\n"
                    "END $$;\n")
    return "".join(lines)

def gen_constraints():
    return (HDR +
        "-- step 08 — t_prd_product_constraints (책자 4상품 — 0행)\n"
        "-- page_rule(내지페이지)=비옵션 범위(이미 라이브 적재, 손대지 않음). 도수↔제본 유의미 제약 없음(4상품 제본 단일).\n"
        "-- 최종 가격유효성=가격엔진. enumerate 제약 안 함. → 0행 (DEFER, silsa 동형).\n" + HDR +
        "-- (no INSERT)\n")

def main():
    groups_sql, grpcode = gen_groups()
    with open(os.path.join(HERE,"05_t_prd_product_option_groups.sql"),"w") as f: f.write(groups_sql)
    with open(os.path.join(HERE,"06_t_prd_product_options.sql"),"w") as f: f.write(gen_options())
    with open(os.path.join(HERE,"07_t_prd_product_option_items.sql"),"w") as f: f.write(gen_items())
    with open(os.path.join(HERE,"08_t_prd_product_constraints.sql"),"w") as f: f.write(gen_constraints())
    print("generated 05/06/07/08 sql. groups:", len(grpcode))

if __name__ == "__main__":
    main()
