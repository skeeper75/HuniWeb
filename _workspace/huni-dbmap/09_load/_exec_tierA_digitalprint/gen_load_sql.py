#!/usr/bin/env python3
# =====================================================================
# gen_load_sql.py — 디지털인쇄 Tier A 14상품 CPQ 옵션레이어 멱등 적재 생성기
#   재현 가능한 멱등 적재 SQL 생성기 (손편집 금지 · 라이브 실측/L1 권위 위에서 생성).
#   권위: 10_configurator/tierA/digitalprint-option-layer.md (옵션 STRUCTURE)
#         00_schema/cpq-schema.md §2 (트리거 fn_chk_opt_item_ref) · attribute-entity-map.md (verdict)
#         09_load/_exec_silsa_cpq (멱등 SQL 패턴 권위)
#         00_schema/code-identifier-strategy.md (`_` 순차 surrogate·이름기반 멱등·신규 DDL 0)
#   [HARD] 멱등 = 이름기반 NOT EXISTS 가드. surrogate 코드(OPT_/OPV_)는 라이브 MAX+1 리터럴로 부여하되
#          존재검사는 코드가 아닌 *이름*(prd_cd+opt_grp_nm / prd_cd+opt_grp_cd+opt_nm) → 재실행 delta 0.
#   [HARD] option_item = 이미 적재된 차원행 포인터. ref_dim_cd별 차원행 EXISTS 를 트리거가 강제.
#          차원행 0행 참조 option_item = BLOCKED (적재 대상 아님 · _blocked/ 격리).
#   [HARD] NEVER COMMIT (로더 기본 ROLLBACK). DDL(CREATE/ALTER) 없음 — CPQ 행 INSERT 만.
#          mint(자재/공정) 없음 — 14상품 전부 차원행 라이브 적재 실측 완료(2026-06-14).
#   reg_dt 명시 생략(컬럼 DEFAULT now() 발화) — round-5 교훈(명시 NULL은 DEFAULT 미발화).
#
#   [라이브 실측 2026-06-14 read-only]:
#     채번 MAX: opt_grp = OPT_000004/OPT-000005 (suffix MAX=5) → 신규 OPT_000005+
#               opt     = OPV_000016/OPV-000010 (suffix MAX=16) → 신규 OPV_000017+
#     차원행: 14상품 sizes/materials(USAGE.07)/print_options(opt_id 1/2)/processes 전부 적재.
#       후가공 PROC_000029(오시)/030(미싱)/031(가변텍스트)/032(가변이미지) = 라이브 적재됨
#         → postcard 파일럿 BLOCKED 5행은 STALE. 본 적재에서 INSERTABLE 로 승격.
#       모서리 PROC_000027(직각)/028(둥근) · 코팅 PROC_000014(유광)/015(무광) 적재됨.
#       박칼라 공정 PROC_000037(홀로그램)/038(금유광)/039(은유광)/040(먹유광)/041(동박)/
#         042(적박)/043(청박)/044(트윙클) 적재됨(027/029/031/042 링크).
#     BLOCKED(차원행 부재): 접지 공정(065~068 미링크) · 화이트별색(024/025 미링크).
#     016 더미(OPT-000005 후가공/OPV-000007~010) · 025 더미(RULE_001) = _cleanup_dummy.sql 인간승인.
#     016 봉투 add-on(TMPL-000005/006/009/010/011) = 라이브 기존 → 본 적재 미관여(옵션 중복생성 안 함).
# =====================================================================
import os, csv

OUT = os.path.dirname(os.path.abspath(__file__))

# 라이브 MAX+1 시작 채번(suffix 리터럴). 생성 트리거 부재 → 리터럴 부여, 멱등은 이름키.
OPT_GRP_START = 5    # OPT_000005+
OPT_START = 17       # OPV_000017+

# ---------------------------------------------------------------------
# 공정/도수 차원 코드(라이브 실측). 후가공·모서리·코팅·박칼라 = INSERTABLE.
DOSU_SINGLE = 1   # opt_id 1 = 단면
DOSU_DOUBLE = 2   # opt_id 2 = 양면

PROC_MOSEORI_JIKGAK = "PROC_000027"  # 직각
PROC_MOSEORI_DUNGEUN = "PROC_000028" # 둥근
PROC_OSI = "PROC_000029"
PROC_MISING = "PROC_000030"
PROC_VARTEXT = "PROC_000031"
PROC_VARIMG = "PROC_000032"
PROC_YUGWANG = "PROC_000014"  # 유광(코팅)
PROC_MUGWANG = "PROC_000015"  # 무광(코팅)
# 박칼라 공정(8종, 라이브 박칼라 그룹)
BAK_PROCS = [  # (proc_cd, 라벨)
    ("PROC_000037", "홀로그램"),
    ("PROC_000038", "금유광"),
    ("PROC_000039", "은유광"),
    ("PROC_000040", "먹유광"),
    ("PROC_000041", "동박"),
    ("PROC_000042", "적박"),
    ("PROC_000043", "청박"),
    ("PROC_000044", "트윙클"),
]
# 접지 공정(BLOCKED — 라이브 process 미링크) — 참조용 매핑(적재 안 함)
PROC_2DAN_GARO = "PROC_000065"; PROC_2DAN_SERO = "PROC_000066"
PROC_3DAN_GARO = "PROC_000067"; PROC_3DAN_SERO = "PROC_000068"

USAGE = "USAGE.07"

# ---------------------------------------------------------------------
# 상품별 차원행 실측(라이브 2026-06-14). 종이=자재 mat_cd list(dflt 첫 항목).
#   PAPERS[prd] = [(mat_cd, dflt_yn, 라벨)…]  · 도수 opt_id list · 코팅 공정 list 등
# (간결성 위해 종이는 라이브 materials 그대로 — option_item 이 mat_cd+usage_cd 참조)
PRODUCTS = {}

def P(prd, prd_nm, papers, dosu, *, coating=None, moseori=False, hugagong=None,
      jeopji=None, bak=False, whiteprint=False, envelope=False):
    """상품 옵션 스펙 등록.
    papers: [(mat_cd, dflt_yn)…] 라이브 자재행. dosu: [(opt_id, 라벨)…] 라이브 print_options 실측.
    coating: ['유광','무광'] | None. moseori: 직각/둥근 택1. hugagong: 다중 후가공 list(공정코드).
    jeopji: [(라벨, proc_cd)…] (BLOCKED). bak: 박칼라 8종. whiteprint: 화이트별색(BLOCKED). envelope: 봉투(기존addon).
    """
    PRODUCTS[prd] = dict(prd_nm=prd_nm, papers=papers, dosu=dosu, coating=coating,
                         moseori=moseori, hugagong=hugagong or [], jeopji=jeopji or [],
                         bak=bak, whiteprint=whiteprint, envelope=envelope)

# 종이 자재행(라이브 실측 — (mat_cd, dflt_yn) 순서=disp_seq)
PAPER_016 = [("MAT_000074","Y"),("MAT_000082","Y"),("MAT_000092","N"),("MAT_000101","N"),("MAT_000109","N"),
             ("MAT_000113","N"),("MAT_000114","N"),("MAT_000115","N"),("MAT_000116","N"),("MAT_000117","N"),
             ("MAT_000118","N"),("MAT_000120","N"),("MAT_000121","N"),("MAT_000123","N"),("MAT_000124","N"),
             ("MAT_000125","N"),("MAT_000126","N"),("MAT_000127","N"),("MAT_000128","N"),("MAT_000129","N"),("MAT_000130","N")]
PAPER_017 = [("MAT_000081","Y"),("MAT_000082","Y")]
PAPER_018 = [("MAT_000074","Y"),("MAT_000080","N"),("MAT_000081","N"),("MAT_000082","N"),("MAT_000090","N"),("MAT_000091","N"),("MAT_000092","N")]
PAPER_024 = [("MAT_000082","Y")]
PAPER_025 = [("MAT_000178","Y")]
PAPER_026 = [("MAT_000082","Y")]
PAPER_027 = [("MAT_000074","Y"),("MAT_000081","N"),("MAT_000082","N"),("MAT_000091","N"),("MAT_000092","N"),
             ("MAT_000101","N"),("MAT_000108","N"),("MAT_000109","N"),("MAT_000113","N"),("MAT_000114","N"),
             ("MAT_000115","N"),("MAT_000116","N"),("MAT_000123","N"),("MAT_000125","N")]
PAPER_029 = [("MAT_000074","Y"),("MAT_000081","N"),("MAT_000082","N"),("MAT_000091","N"),("MAT_000092","N"),
             ("MAT_000101","N"),("MAT_000108","N"),("MAT_000109","N"),("MAT_000113","N"),("MAT_000114","N"),
             ("MAT_000115","N"),("MAT_000116","N"),("MAT_000123","N"),("MAT_000125","N")]  # G1-1 보정: MAT_000125(한지170g·라이브 disp_seq14) 추가. 라이브 029 materials=14종(027과 동일)
PAPER_031 = [("MAT_000099","Y"),("MAT_000101","N"),("MAT_000102","N"),("MAT_000108","N"),("MAT_000109","N"),
             ("MAT_000113","N"),("MAT_000114","N"),("MAT_000115","N"),("MAT_000116","N"),("MAT_000117","N"),
             ("MAT_000118","N"),("MAT_000119","N"),("MAT_000123","N"),("MAT_000124","N"),("MAT_000125","N"),("MAT_000126","N")]
PAPER_032 = [("MAT_000081","Y"),("MAT_000082","Y")]
PAPER_033 = [("MAT_000074","Y"),("MAT_000081","Y"),("MAT_000082","Y"),("MAT_000091","Y"),("MAT_000092","Y")]
PAPER_041 = [("MAT_000072","Y"),("MAT_000078","Y"),("MAT_000088","Y"),("MAT_000105","Y")]
PAPER_042 = [("MAT_000107","Y"),("MAT_000118","Y"),("MAT_000121","Y"),("MAT_000125","Y"),("MAT_000128","Y"),("MAT_000129","Y"),("MAT_000240","Y"),("MAT_000241","Y")]
PAPER_047 = [("MAT_000072","Y"),("MAT_000073","N"),("MAT_000074","N"),("MAT_000076","N"),("MAT_000077","N"),
             ("MAT_000078","N"),("MAT_000079","N"),("MAT_000080","N"),("MAT_000081","N"),("MAT_000082","N"),
             ("MAT_000086","N"),("MAT_000087","N"),("MAT_000088","N"),("MAT_000089","N"),("MAT_000090","N"),
             ("MAT_000091","N"),("MAT_000092","N"),("MAT_000095","N"),("MAT_000096","N"),("MAT_000097","N"),
             ("MAT_000098","N"),("MAT_000099","N"),("MAT_000101","N"),("MAT_000102","N"),("MAT_000104","N"),
             ("MAT_000105","N"),("MAT_000106","N"),("MAT_000107","N"),("MAT_000108","N"),("MAT_000109","N"),
             ("MAT_000113","N"),("MAT_000114","N"),("MAT_000115","N"),("MAT_000116","N"),("MAT_000117","N"),
             ("MAT_000118","N"),("MAT_000119","N"),("MAT_000120","N"),("MAT_000121","N"),("MAT_000123","N"),
             ("MAT_000124","N"),("MAT_000125","N"),("MAT_000126","N"),("MAT_000127","N"),("MAT_000128","N"),
             ("MAT_000129","N"),("MAT_000130","N")]

P("PRD_000016","프리미엄엽서", PAPER_016, [(1,"단면"),(2,"양면")], moseori=True,
  hugagong=[(PROC_OSI,"오시"),(PROC_MISING,"미싱"),(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")], envelope=True)
P("PRD_000017","코팅엽서", PAPER_017, [(1,"단면"),(2,"양면")], coating=["유광","무광"], moseori=True, envelope=True)
P("PRD_000018","스탠다드엽서", PAPER_018, [(1,"단면"),(2,"양면")], moseori=True,
  hugagong=[(PROC_OSI,"오시"),(PROC_MISING,"미싱"),(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")], envelope=True)
P("PRD_000024","포토카드", PAPER_024, [(1,"단면"),(2,"양면")], coating=["유광","무광"], moseori=True, whiteprint=True)
P("PRD_000025","투명포토카드", PAPER_025, [(1,"단면")], moseori=True, whiteprint=True)
P("PRD_000026","종이슬로건", PAPER_026, [(1,"단면"),(2,"양면")], coating=["유광","무광"])
P("PRD_000027","2단접지카드", PAPER_027, [(1,"양면")],
  hugagong=[(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")],
  jeopji=[("2단 가로접지",PROC_2DAN_GARO),("2단 세로접지",PROC_2DAN_SERO)], bak=True)
P("PRD_000029","3단접지카드", PAPER_029, [(1,"양면")],
  hugagong=[(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")],
  jeopji=[("3단 가로접지",PROC_3DAN_GARO),("3단 세로접지",PROC_3DAN_SERO)], bak=True)
P("PRD_000031","프리미엄명함", PAPER_031, [(1,"단면"),(2,"양면")], moseori=True,
  hugagong=[(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")], bak=True)
P("PRD_000032","코팅명함", PAPER_032, [(1,"단면"),(2,"양면")], coating=["유광","무광"], moseori=True)
P("PRD_000033","스탠다드명함", PAPER_033, [(1,"단면"),(2,"양면")], moseori=True,
  hugagong=[(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")])
P("PRD_000041","스탠다드 쿠폰/상품권", PAPER_041, [(1,"단면"),(2,"양면")],
  hugagong=[(PROC_OSI,"오시"),(PROC_MISING,"미싱"),(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")])
P("PRD_000042","프리미엄 쿠폰/상품권", PAPER_042, [(1,"단면"),(2,"양면")],
  hugagong=[(PROC_OSI,"오시"),(PROC_MISING,"미싱"),(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")], bak=True)
P("PRD_000047","소량전단지", PAPER_047, [(1,"단면"),(2,"양면")], coating=["유광","무광"],
  hugagong=[(PROC_VARTEXT,"가변텍스트"),(PROC_VARIMG,"가변이미지")])

PROD_ORDER = ["PRD_000016","PRD_000017","PRD_000018","PRD_000024","PRD_000025","PRD_000026",
              "PRD_000027","PRD_000029","PRD_000031","PRD_000032","PRD_000033","PRD_000041",
              "PRD_000042","PRD_000047"]

# ---------------------------------------------------------------------
def sql_str(s):
    if s is None:
        return "NULL"
    return "'" + str(s).replace("'", "''") + "'"

# 채번 카운터(전 상품 순차)
_grp_ctr = [OPT_GRP_START]
_opt_ctr = [OPT_START]
def next_grp():
    c = _grp_ctr[0]; _grp_ctr[0]+=1; return f"OPT_{c:06d}"
def next_opt():
    c = _opt_ctr[0]; _opt_ctr[0]+=1; return f"OPV_{c:06d}"

prov = []  # (sql_file, step, target_row_key, source)

# 누적 row 컨테이너
groups_rows = []   # (prd, grp_cd, grp_nm, sel_typ, mn, mx, mand, disp, note)
options_rows = []  # (prd, opt_cd, grp_nm, opt_nm, dflt, disp, note)
items_rows = []    # (prd, opt_nm, item_seq, ref_dim, ref_key1, ref_key2, qty, insertable, note)
items_blocked = [] # 동일 shape + block_reason
constraints_rows = []  # (prd, rule_cd, rule_nm, rule_typ, logic, err_msg, disp, note)

def build():
    for prd in PROD_ORDER:
        spec = PRODUCTS[prd]
        disp = 1
        # --- OG-DOSU (도수 .06) — disp_seq 1 (L1 '인쇄(옵션)') ---
        if spec["dosu"]:
            gc = next_grp()
            mand = "Y"
            groups_rows.append((prd, gc, "인쇄", "SEL_TYPE.01", 1, 1, mand, disp,
                "인쇄(도수) 택1 필수. L1 '인쇄(옵션)' 단/양면. ref .06 opt_id(NOT clr_cd). disp_seq=L1 컬럼순서 권위."))
            prov.append(("05_groups","05",f"{prd}/인쇄 → {gc}","L1 인쇄(옵션) + attr-map 패밀리① 도수"))
            for i,(opt_id,nm) in enumerate(spec["dosu"]):
                oc = next_opt()
                dflt = "Y" if i==0 else "N"
                options_rows.append((prd, oc, "인쇄", nm, dflt, opt_id, f"도수 opt_id={opt_id} {nm}(라이브 print_options 실측)."))
                items_rows.append((prd, nm, 1, ".06", str(opt_id), None, 1, True,
                    f"도수 .06 opt_id={opt_id} EXISTS(라이브 print_options)."))
                prov.append(("06_options","06",f"{prd}/{nm} opt_id{opt_id}","L1 인쇄 + live print_options"))
            disp += 1
        # --- OG-JONGI (종이=자재 .03) — disp_seq 2 (L1 '종이(필수)') ---
        if spec["papers"]:
            gc = next_grp()
            groups_rows.append((prd, gc, "종이", "SEL_TYPE.01", 1, 1, "Y", disp,
                f"종이(자재) 택1 필수. L1 '종이(필수)'. {len(spec['papers'])}종 라이브 materials(USAGE.07). ref .03 mat_cd+usage_cd."))
            prov.append(("05_groups","05",f"{prd}/종이 → {gc}","L1 종이(필수) + live materials"))
            pseq = 1
            for mat_cd, dflt in spec["papers"]:
                oc = next_opt()
                options_rows.append((prd, oc, "종이", mat_cd, dflt, pseq,
                    f"종이 자재 {mat_cd}(라이브 materials USAGE.07). opt_nm=mat_cd(이름키)."))
                items_rows.append((prd, mat_cd, 1, ".03", mat_cd, USAGE, 1, True,
                    f"자재 .03 mat_cd={mat_cd} usage_cd={USAGE} EXISTS(라이브 materials)."))
                prov.append(("06_options","06",f"{prd}/종이 {mat_cd}","live materials USAGE.07"))
                pseq += 1
            disp += 1
        # --- OG-COATING (코팅 .04 유광/무광) — disp_seq 3 (L1 '코팅(옵션)') ---
        if spec["coating"]:
            gc = next_grp()
            groups_rows.append((prd, gc, "코팅", "SEL_TYPE.01", 0, 1, "N", disp,
                "코팅 택1 선택(코팅없음 센티넬 min0). L1 '코팅(옵션)' 유광/무광. ref .04 공정. 단/양면 면구분=GAP-PARAM."))
            prov.append(("05_groups","05",f"{prd}/코팅 → {gc}","L1 코팅(옵션) + live processes 014/015"))
            # 센티넬 코팅없음
            oc = next_opt()
            options_rows.append((prd, oc, "코팅", "코팅없음", "Y", 1, "선택안함 센티넬(option_item 0행)."))
            prov.append(("06_options","06",f"{prd}/코팅없음","sentinel"))
            cseq = 2
            for label in spec["coating"]:
                pc = PROC_YUGWANG if label=="유광" else PROC_MUGWANG
                oc = next_opt()
                options_rows.append((prd, oc, "코팅", label, "N", cseq, f"코팅 {label} 공정 {pc}."))
                items_rows.append((prd, label, 1, ".04", pc, None, 1, True,
                    f"공정 .04 proc_cd={pc} EXISTS(라이브 processes). 면구분(단/양면)=GAP-PARAM."))
                prov.append(("06_options","06",f"{prd}/코팅 {label}","live processes "+pc))
                cseq += 1
            disp += 1
        # --- OG-MOSEORI (모서리 .04 직각/둥근) — disp_seq 4 (L1 '후가공_모서리') ---
        if spec["moseori"]:
            gc = next_grp()
            groups_rows.append((prd, gc, "모서리", "SEL_TYPE.01", 0, 1, "N", disp,
                "모서리 택1 선택. L1 '후가공_모서리' 직각/둥근. ref .04 공정 027/028."))
            prov.append(("05_groups","05",f"{prd}/모서리 → {gc}","L1 후가공_모서리 + live 027/028"))
            for label,pc,dflt in [("직각",PROC_MOSEORI_JIKGAK,"Y"),("둥근",PROC_MOSEORI_DUNGEUN,"N")]:
                oc = next_opt()
                seq = 1 if label=="직각" else 2
                options_rows.append((prd, oc, "모서리", label, dflt, seq, f"모서리 {label} 공정 {pc}."))
                items_rows.append((prd, label, 1, ".04", pc, None, 1, True,
                    f"공정 .04 proc_cd={pc} EXISTS(라이브 processes)."))
                prov.append(("06_options","06",f"{prd}/모서리 {label}","live processes "+pc))
            disp += 1
        # --- OG-HUGAGONG (후가공 다중 .04 SEL_TYPE.02) — disp_seq 5 (L1 후가공 오시/미싱/가변) ---
        if spec["hugagong"]:
            gc = next_grp()
            n = len(spec["hugagong"])
            groups_rows.append((prd, gc, "후가공", "SEL_TYPE.02", 0, n, "N", disp,
                f"후가공 택N 다중({n}종 동시선택 L1 실증). ref .04 공정. 줄수/개수=GAP-PARAM(보존불가)."))
            prov.append(("05_groups","05",f"{prd}/후가공 → {gc}","L1 후가공 다중 + live processes"))
            hseq = 1
            for pc,label in spec["hugagong"]:
                oc = next_opt()
                options_rows.append((prd, oc, "후가공", label, "N", hseq, f"후가공 {label} 공정 {pc}. 다중. 줄수/개수=GAP-PARAM."))
                items_rows.append((prd, label, 1, ".04", pc, None, 1, True,
                    f"공정 .04 proc_cd={pc} EXISTS(라이브 processes). 줄수/개수 param 보존불가(GAP-PARAM)."))
                prov.append(("06_options","06",f"{prd}/후가공 {label}","live processes "+pc))
                hseq += 1
            disp += 1
        # --- OG-JEOPJI (접지 .04 BLOCKED — 공정 미링크) — disp_seq 6 (L1 '접지(옵션)') ---
        if spec["jeopji"]:
            gc = next_grp()
            groups_rows.append((prd, gc, "접지", "SEL_TYPE.01", 1, 1, "Y", disp,
                "접지 택1 필수. L1 '접지(옵션)'. ref .04 공정 — BLOCKED(라이브 process 접지공정 065~068 미링크)."))
            prov.append(("05_groups","05",f"{prd}/접지 → {gc}","L1 접지(옵션) — BLOCKED 차원행 부재"))
            jseq = 1
            for label,pc in spec["jeopji"]:
                oc = next_opt()
                options_rows.append((prd, oc, "접지", label, "Y" if jseq==1 else "N", jseq,
                    f"접지 {label} 공정 {pc}. BLOCKED(차원행 부재 — 사이즈연동 동적 freeze는 GAP-B)."))
                items_blocked.append((prd, label, 1, ".04", pc, None, 1,
                    f"공정 .04 proc_cd={pc} 라이브 processes 미링크(접지공정) → 트리거 REJECT. L1 선적재 필요."))
                prov.append(("07_items_BLOCKED","07",f"{prd}/접지 {label}","L1 접지 — 차원행 부재 BLOCKED"))
                jseq += 1
            disp += 1
        # --- OG-BAK (박칼라 .04 8종 + 박없음 센티넬) — disp_seq 7 (L1 '박/형압_박칼라') ---
        if spec["bak"]:
            gc = next_grp()
            groups_rows.append((prd, gc, "박칼라", "SEL_TYPE.01", 0, 1, "N", disp,
                "박칼라 택1 선택(박없음 센티넬 min0). L1 '박/형압_박칼라' 8종. ref .04 공정. 박크기=GAP-PARAM."))
            prov.append(("05_groups","05",f"{prd}/박칼라 → {gc}","L1 박칼라 + live 박칼라 공정 037~044"))
            oc = next_opt()
            options_rows.append((prd, oc, "박칼라", "박없음", "Y", 1, "선택안함 센티넬(option_item 0행)."))
            prov.append(("06_options","06",f"{prd}/박없음","sentinel"))
            bseq = 2
            for pc,label in BAK_PROCS:
                oc = next_opt()
                options_rows.append((prd, oc, "박칼라", label, "N", bseq, f"박칼라 {label} 공정 {pc}. 박크기=GAP-PARAM."))
                items_rows.append((prd, label, 1, ".04", pc, None, 1, True,
                    f"공정 .04 proc_cd={pc} EXISTS(라이브 박칼라 공정). 박크기 param 보존불가(GAP-PARAM)."))
                prov.append(("06_options","06",f"{prd}/박칼라 {label}","live processes "+pc))
                bseq += 1
            disp += 1
        # --- 화이트별색(BLOCKED — 024/025) — disp_seq (L1 '별색인쇄_화이트') ---
        if spec["whiteprint"]:
            gc = next_grp()
            groups_rows.append((prd, gc, "화이트별색", "SEL_TYPE.01", 0, 1, "N", disp,
                "화이트별색 택1 선택. L1 '별색인쇄(옵션)_화이트' 화이트인쇄(단면). ref .04 공정 — BLOCKED(라이브 미링크)."))
            prov.append(("05_groups","05",f"{prd}/화이트별색 → {gc}","L1 별색 화이트 — BLOCKED 차원행 부재"))
            oc = next_opt()
            options_rows.append((prd, oc, "화이트별색", "화이트인쇄(단면)", "N", 1,
                "화이트별색 공정 — BLOCKED(차원행 부재, 화이트 별색공정 미링크)."))
            items_blocked.append((prd, "화이트인쇄(단면)", 1, ".04", "[CONFIRM 화이트별색공정]", None, 1,
                "화이트 별색 공정 라이브 processes 미링크 → 트리거 REJECT. 공정코드 [CONFIRM]·L1 선적재 필요."))
            prov.append(("07_items_BLOCKED","07",f"{prd}/화이트별색","L1 별색 화이트 — 차원행 부재 BLOCKED"))
            disp += 1

build()

# ---------------------------------------------------------------------
# SQL 생성기
PRD_NM_MAP = {prd: PRODUCTS[prd]["prd_nm"] for prd in PROD_ORDER}

def grp_expr(prd, grp_nm):
    return (f"(SELECT opt_grp_cd FROM t_prd_product_option_groups "
            f"WHERE prd_cd={sql_str(prd)} AND opt_grp_nm={sql_str(grp_nm)} AND del_yn='N' "
            f"ORDER BY opt_grp_cd LIMIT 1)")

def opt_expr(prd, grp_nm, opt_nm):
    # 멱등 resolve: (prd, grp, opt_nm) — 모서리 등 동명 옵션이 다른 그룹에 없도록 grp 포함
    return (f"(SELECT opt_cd FROM t_prd_product_options o "
            f"WHERE o.prd_cd={sql_str(prd)} AND o.opt_nm={sql_str(opt_nm)} "
            f"AND o.opt_grp_cd=(SELECT opt_grp_cd FROM t_prd_product_option_groups "
            f"WHERE prd_cd={sql_str(prd)} AND opt_grp_nm={sql_str(grp_nm)} AND del_yn='N' LIMIT 1) "
            f"AND o.del_yn='N' ORDER BY o.opt_cd LIMIT 1)")

def gen_00():
    lines = ["-- ====================================================================="]
    lines.append("-- step 00 — pre-load markers (NO INSERT) — 적용된 설계 결정 명시")
    lines.append("-- 디지털인쇄 Tier A 14상품 CPQ 옵션레이어 · `_exec_tierA_digitalprint`")
    lines.append("-- 권위: tierA/digitalprint-option-layer.md(STRUCTURE) · cpq-schema §2(트리거) · _exec_silsa_cpq(패턴)")
    lines.append("-- =====================================================================")
    lines.append("-- [적용 결정]")
    lines.append("--  D-A 종이: option_group(택1) + 종이마다 1 option + 1 option_item(.03 mat_cd+usage_cd). opt_nm=mat_cd(이름키).")
    lines.append("--  D-B 사이즈: option_group 미생성(UI 상단 1차축·postcard 파일럿 계승). 차원행은 존재(CONFIRM 노출).")
    lines.append("--  D-C 도수: OG-인쇄 SEL_TYPE.01 mand. ref .06 opt_id(NOT clr_cd·MISMATCH-1 정정).")
    lines.append("--  D-D 코팅: 유광(014)/무광(015) 2 공정 + 코팅없음 센티넬. 단/양면 면구분=GAP-PARAM.")
    lines.append("--  D-E 후가공: OG-후가공 SEL_TYPE.02 다중. 오시029/미싱030/가변텍스트031/가변이미지032. 줄수/개수=GAP-PARAM.")
    lines.append("--  D-F 모서리: 직각027/둥근028 택1.")
    lines.append("--  D-G 접지: BLOCKED(라이브 process 접지공정 065~068 미링크). _blocked/items.")
    lines.append("--  D-H 박칼라: 박없음 센티넬 + 8종(037~044) 택1. 박크기=GAP-PARAM.")
    lines.append("--  D-I 화이트별색: BLOCKED(024/025 화이트 별색공정 미링크·[CONFIRM] 코드).")
    lines.append("--  D-J 봉투(016): 라이브 기존 add-on(TMPL-000005/006/009/010/011) → 옵션 중복생성 안 함.")
    lines.append("--  채번: opt_grp 라이브 MAX(suffix)=5 → OPT_000005+ · opt MAX=16 → OPV_000017+ (리터럴·`_`통일·멱등은 이름키).")
    lines.append("-- [차원행 실측 2026-06-14 read-only]: 14상품 sizes/materials/print_options/processes 적재 확인.")
    lines.append("--   후가공 PROC_029~032·코팅 014/015·박칼라 037~044 = 라이브 적재(postcard BLOCKED 5행 STALE→INSERTABLE 승격).")
    lines.append("-- [더미 분리]: 016 OPT-000005 후가공/OPV-000007~010 · 025 RULE_001 = _cleanup_dummy.sql(인간 승인).")
    lines.append("-- [HARD] NEVER COMMIT — 로더 기본 ROLLBACK. CPQ 행 INSERT 만(DDL/mint 없음).")
    lines.append("SELECT '00: markers — Tier A 14상품 옵션레이어, decisions D-A~D-J' AS step_00;")
    return "\n".join(lines)+"\n"

def gen_05():
    lines = ["-- =====================================================================",
             "-- step 05 — t_prd_product_option_groups (14상품 옵션그룹)",
             "-- 멱등 가드 = (prd_cd, opt_grp_nm) NOT EXISTS. 코드=라이브 MAX+1 리터럴(OPT_000005+).",
             "-- disp_seq=L1 옵션성 컬럼 등장순서 권위. 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
             "-- ====================================================================="]
    for prd, cd, nm, sel, mn, mx, mand, disp, note in groups_rows:
        lines.append(
            f"INSERT INTO t_prd_product_option_groups\n"
            f"  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note)\n"
            f"SELECT {sql_str(prd)}, {sql_str(cd)}, {sql_str(nm)}, {sql_str(sel)}, {mn}, {mx}, {sql_str(mand)}, {disp}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups\n"
            f"  WHERE prd_cd = {sql_str(prd)} AND opt_grp_nm = {sql_str(nm)} AND del_yn = 'N');")
    return "\n".join(lines)+"\n"

def gen_06():
    lines = ["-- =====================================================================",
             "-- step 06 — t_prd_product_options (14상품 옵션)",
             "-- 멱등 가드 = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS. opt_grp_cd=그룹 이름 resolve(재실행 안전).",
             "-- 코드=라이브 MAX+1 리터럴(OPV_000017+). 트리거 없음. reg_dt 생략→DEFAULT now(). 손편집 금지.",
             "-- ====================================================================="]
    for prd, oc, grp_nm, opt_nm, dflt, disp, note in options_rows:
        ge = grp_expr(prd, grp_nm)
        lines.append(
            f"INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note)\n"
            f"SELECT {sql_str(prd)}, {sql_str(oc)}, {ge}, {sql_str(opt_nm)}, {sql_str(dflt)}, {disp}, 'Y', {sql_str(note)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options\n"
            f"  WHERE prd_cd = {sql_str(prd)} AND opt_grp_cd = {ge} AND opt_nm = {sql_str(opt_nm)} AND del_yn = 'N');")
    return "\n".join(lines)+"\n"

def refval(v):
    return sql_str(v)

def gen_07():
    lines = ["-- =====================================================================",
             "-- step 07 — t_prd_product_option_items (INSERTABLE · 차원행 포인터)",
             "-- 트리거 fn_chk_opt_item_ref: ref_dim_cd별 (prd_cd+키) 차원행 EXISTS 행단위 검사.",
             "--   .06 도수=opt_id::int / .03 자재=mat_cd+usage_cd / .04 공정=proc_cd.",
             "-- 멱등 가드 = (prd_cd, opt_cd, item_seq) NOT EXISTS. opt_cd=(prd,grp,opt_nm) resolve.",
             "-- ref_key1 NOT NULL. BLOCKED(접지/화이트별색)은 _blocked/07_*.sql(적재 대상 아님).",
             "-- reg_dt 생략→DEFAULT now(). 손편집 금지.",
             "-- ====================================================================="]
    # opt_nm→grp_nm 역참조 위해 options_rows 인덱스
    opt_grp = {}
    for prd, oc, grp_nm, opt_nm, dflt, disp, note in options_rows:
        opt_grp[(prd, opt_nm)] = grp_nm
    for prd, opt_nm, seq, dim, r1, r2, qty, insertable, note in items_rows:
        grp_nm = opt_grp.get((prd, opt_nm))
        oe = opt_expr(prd, grp_nm, opt_nm)
        lines.append(
            f"INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn)\n"
            f"SELECT {sql_str(prd)}, {oe}, {seq}, {sql_str('OPT_REF_DIM'+dim)}, {refval(r1)}, {refval(r2)}, {qty}, 'Y'\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items\n"
            f"  WHERE prd_cd = {sql_str(prd)} AND opt_cd = {oe} AND item_seq = {seq});")
    return "\n".join(lines)+"\n"

def gen_07_blocked():
    lines = ["-- =====================================================================",
             "-- _blocked/07_t_prd_product_option_items_BLOCKED.sql (적재 대상 아님)",
             "-- 차원행 부재(트리거 REJECT 예정) → 본 트랜잭션 미포함. L1 선적재(인간 승인) 후 별도 적재.",
             "--   접지(공정 065~068 미링크) · 화이트별색(공정 미링크·[CONFIRM] 코드).",
             "-- =====================================================================",
             "SELECT '_blocked/07: option_items BLOCKED — 접지/화이트별색 차원행 부재. 적재 안 함' AS blocked_07;"]
    return "\n".join(lines)+"\n"

def gen_08():
    lines = ["-- =====================================================================",
             "-- step 08 — t_prd_product_constraints (0행 — 본 파일럿 제약 없음)",
             "-- 후가공 다중·박칼라 택1은 option_groups(SEL_TYPE/min/max)로 충족 → 별도 JSONLogic 불요.",
             "--   R-QTY-PANSU(수량=판수 배수)는 GAP-PANSU(가격엔진 입력)이며 본 옵션레이어 제약 아님(attr-map §3.4).",
             "-- 025 더미 RULE_001(금지테스트)=정리 대상(_cleanup_dummy.sql). 본 적재 미관여.",
             "-- =====================================================================",
             "SELECT '08: constraints — 0 rows (옵션그룹 SEL_TYPE 로 다중/택일 충족·판수=가격엔진)' AS step_08;"]
    return "\n".join(lines)+"\n"

def gen_cleanup():
    lines = ["-- =====================================================================",
             "-- _cleanup_dummy.sql — 016/025 테스트 더미 정리 (인간 승인 전용 · 자동 실행 금지)",
             "--   우리 정식 옵션 레이어와 무관한 더미. 멱등 이름검사라 충돌은 없으나, 더미 잔존은 UI 혼란.",
             "--   [HARD] 본 파일은 apply.sql 에 포함되지 않음. 인간이 명시 승인 시에만 별도 실행.",
             "-- =====================================================================",
             "-- 016 더미: 그룹 OPT-000005(후가공) · 옵션 OPV-000007~010 · option_items 7행 (코드체계 OPT-/OPV- 하이픈)",
             "-- 025 더미: constraint RULE_001(금지테스트)",
             "BEGIN;",
             "  DELETE FROM t_prd_product_option_items WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010');",
             "  DELETE FROM t_prd_product_options       WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010');",
             "  DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_cd='OPT-000005';",
             "  DELETE FROM t_prd_product_constraints   WHERE prd_cd='PRD_000025' AND rule_cd='RULE_001';",
             "-- ROLLBACK;  -- 기본은 검토용. 실제 정리는 COMMIT(인간 승인) 으로 교체.",
             "ROLLBACK;"]
    return "\n".join(lines)+"\n"

def write(fn, content):
    with open(os.path.join(OUT, fn), "w") as f:
        f.write(content)

def main():
    write("00_preload_markers.sql", gen_00())
    write("05_t_prd_product_option_groups.sql", gen_05())
    write("06_t_prd_product_options.sql", gen_06())
    write("07_t_prd_product_option_items.sql", gen_07())
    write("08_t_prd_product_constraints.sql", gen_08())
    write("_blocked/07_t_prd_product_option_items_BLOCKED.sql", gen_07_blocked())
    write("_cleanup_dummy.sql", gen_cleanup())

    with open(os.path.join(OUT, "load.provenance.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sql_file","step","target_row_key","source_authority"])
        for row in prov:
            w.writerow(row)

    # 집계 출력(manifest 작성용)
    from collections import Counter
    g = len(groups_rows); o = len(options_rows); it = len(items_rows); bl = len(items_blocked)
    print(f"groups={g} options={o} items_INSERTABLE={it} items_BLOCKED={bl} provenance={len(prov)}")
    # 상품별 집계
    per = {}
    for prd in PROD_ORDER:
        per[prd] = dict(g=0,o=0,it=0,bl=0)
    for r in groups_rows: per[r[0]]['g']+=1
    for r in options_rows: per[r[0]]['o']+=1
    for r in items_rows: per[r[0]]['it']+=1
    for r in items_blocked: per[r[0]]['bl']+=1
    for prd in PROD_ORDER:
        p=per[prd]; print(f"  {prd} {PRD_NM_MAP[prd]:12s} grp={p['g']} opt={p['o']} item_INS={p['it']} item_BLK={p['bl']}")

if __name__ == "__main__":
    main()
