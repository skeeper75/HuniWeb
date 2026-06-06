#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_verification_full.py — 상품별 9속성 완전성 검증 문서 생성기 (round-5, read-only)

목적: round-5 가 ADD 하는 델타(자재/공정/묶음/가격)만 보여주는 load-preview.md 의 한계
(라이브 기존 카테고리·사이즈·도수·판형·추가상품이 "누락"처럼 보임)를 닫는다. 라이브 실존 +
round-5 델타를 9속성 전반에 걸쳐 MERGE 하여, 적재 전 상품별 완전·정확 정의를 사용자가 확인할 수
있는 완전판 검증 문서(load-verification-full.md)를 산출한다.

검증 문서일 뿐 적재본이 아니다 — read-only SELECT 만. INSERT/UPDATE/COMMIT/DDL 없음.
비밀값은 .env.local 에서만(절대 stdout/로그 노출 금지).

행 출처 태그(provenance) — 본 문서의 핵심:
  [라이브]      라이브에 현재 실존
  [+R5]         round-5 델타에 있으나 라이브 미존재(적재 대기)
  [라이브=R5✓]  라이브와 델타 양쪽(이미 적재됨/일치)
  [차단]        round-5 차단(후니 등록 대기)
  [GAP]         무손실 표현 불가(에스컬레이션)

재현성(G8): 같은 라이브 상태 + 같은 델타 CSV → 같은 문서. 손편집 금지.
실행: python3 gen_verification_full.py   (.env.local 자동 source, 비밀값 비노출)

권위: docs/goal-2026-06-06-02.md(round-5) · -01.md(round-4) · 09_load/_assembled/blocked-and-gaps.md.
"""
import csv
import os
import subprocess
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))  # repo root
ASSEMBLED = os.path.join(HERE, "..", "_assembled")
ASSEMBLED_PRICE = os.path.join(HERE, "..", "_assembled_price")
LOAD = os.path.join(ASSEMBLED, "load")
UPD = os.path.join(ASSEMBLED, "update-set")
PRICE_LOAD = os.path.join(ASSEMBLED_PRICE, "load")
OUT_DOC = os.path.join(HERE, "load-verification-full.md")
ENV_LOCAL = os.path.join(ROOT, ".env.local")

# 출처 태그
T_LIVE = "[라이브]"
T_R5 = "[+R5]"
T_BOTH = "[라이브=R5✓]"
T_BLOCKED = "[차단]"
T_GAP = "[GAP]"


# ---------------------------------------------------------------------------
# 라이브 read-only 조회 (psql) — 비밀값 비노출
# ---------------------------------------------------------------------------
def _load_env():
    """`.env.local` 에서 RAILWAY_DB_* 만 읽어 dict 로 반환(stdout 노출 0)."""
    env = {}
    if not os.path.exists(ENV_LOCAL):
        sys.exit(f"FATAL: {ENV_LOCAL} 부재 — 라이브 조회 불가")
    with open(ENV_LOCAL, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("RAILWAY_DB_") and "=" in line:
                k, v = line.split("=", 1)
                env[k.strip()] = v.strip().strip('"').strip("'")
    need = ["RAILWAY_DB_HOST", "RAILWAY_DB_PORT", "RAILWAY_DB_USER",
            "RAILWAY_DB_NAME", "RAILWAY_DB_PASSWORD"]
    miss = [k for k in need if not env.get(k)]
    if miss:
        sys.exit(f"FATAL: .env.local 누락 키 {miss}")
    return env


_ENV = _load_env()


def runsql(sql):
    """read-only SELECT 실행. -At(튜플전용·정렬없음·구분자 |). 비밀번호는 PGPASSWORD 환경변수로만."""
    cmd = ["psql", "-h", _ENV["RAILWAY_DB_HOST"], "-p", _ENV["RAILWAY_DB_PORT"],
           "-U", _ENV["RAILWAY_DB_USER"], "-d", _ENV["RAILWAY_DB_NAME"],
           "-v", "ON_ERROR_STOP=1", "-At", "-F", "\t", "-c", sql]
    proc_env = dict(os.environ, PGPASSWORD=_ENV["RAILWAY_DB_PASSWORD"])
    r = subprocess.run(cmd, capture_output=True, text=True, env=proc_env)
    if r.returncode != 0:
        # stderr 에 비밀번호 없음(psql 은 출력 안 함). 안전하게 보고.
        sys.exit(f"FATAL psql({r.returncode}): {r.stderr.strip()}")
    rows = []
    for line in r.stdout.splitlines():
        if line == "":
            continue
        rows.append(line.split("\t"))
    return rows


def in_list(prds):
    return "(" + ",".join("'" + p + "'" for p in sorted(prds)) + ")"


# ---------------------------------------------------------------------------
# CSV 입력 (round-5 GO 델타)
# ---------------------------------------------------------------------------
def read_csv(path):
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def main():
    # --- 1. 제품 집합 ---
    mat_rows = read_csv(os.path.join(LOAD, "05_t_prd_product_materials.csv"))
    proc_rows = read_csv(os.path.join(LOAD, "06_t_prd_product_processes.csv"))
    bdl_rows = read_csv(os.path.join(LOAD, "09_t_prd_product_bundle_qtys.csv"))
    price_rows = read_csv(os.path.join(PRICE_LOAD, "05_prd_product_price_formulas.csv"))

    master_prds = set()
    for r in mat_rows + proc_rows + bdl_rows:
        master_prds.add(r["prd_cd"])
    price_prds = set(r["prd_cd"] for r in price_rows)
    products = sorted(master_prds)  # 9속성 검증 대상 = 상품마스터 델타(≈47)
    union_prds = sorted(master_prds | price_prds)

    # --- 2. 델타 인덱싱 (자연키별) ---
    # 자재: (prd, mat, usage) → row
    d_mat = {(r["prd_cd"], r["mat_cd"], r["usage_cd"]): r for r in mat_rows}
    # 공정: (prd, proc) → row
    d_proc = {(r["prd_cd"], r["proc_cd"]): r for r in proc_rows}
    # 묶음: (prd, bdl_qty) → row
    d_bdl = {(r["prd_cd"], r["bdl_qty"]): r for r in bdl_rows}
    # 가격공식: prd → [rows]
    d_price = defaultdict(list)
    for r in price_rows:
        d_price[r["prd_cd"]].append(r)

    # update-set: UV(print_options) BLOCKED-25 대상 prd
    uv_prds = set()
    uv_path = os.path.join(UPD, "t_prd_product_print_options_uv_update.csv")
    if os.path.exists(uv_path):
        uv_prds = set(r["prd_cd"] for r in read_csv(uv_path))

    # --- 3. 차단/GAP 매핑 (blocked-and-gaps.md 권위, 코드로 인코딩) ---
    # §1 레이저커팅 의존 완칼 14행 (proc 차단) — proc_cd=레이저커팅(PROC_000084)
    laser_blocked_prds = {"PRD_000146", "PRD_000147", "PRD_000148", "PRD_000149",
                          "PRD_000150", "PRD_000151", "PRD_000152", "PRD_000154",
                          "PRD_000155", "PRD_000157", "PRD_000158", "PRD_000160",
                          "PRD_000162", "PRD_000163"}
    # §2 addon template 부재 4행 (addon 차단). 본 검증 대상(47) 내 = 016·018.
    addon_blocked = {
        "PRD_000016": ("TMPL-PRD_000003", "트레싱지봉투(PRD_000003)"),
        "PRD_000018": ("TMPL-PRD_000003", "트레싱지봉투(PRD_000003)"),
        "PRD_000135": ("TMPL-PRD_000008", "천정고리(PRD_000008)"),
        "PRD_000217": ("TMPL-PRD_000015", "만년스탬프잉크(PRD_000015)"),
    }
    # 코드행 선적재: 레이저커팅 PROC_000084 신설 (00_proc_laser.csv)
    laser_proc = read_csv(os.path.join(LOAD, "00_proc_laser.csv"))
    laser_proc_cd = laser_proc[0]["proc_cd"] if laser_proc else "PROC_000084"
    laser_proc_nm = laser_proc[0]["proc_nm"] if laser_proc else "레이저커팅"

    # --- 4. 라이브 9속성 일괄 조회 (read-only) ---
    plist = in_list(products)
    live = {p: {"category": [], "size": [], "print_option": [], "plate": [],
                "material": [], "process": [], "bundle": [], "page_rule": [],
                "addon": [], "price_formula": []} for p in products}

    # 상품명
    prd_nm = {}
    for r in runsql(f"SELECT prd_cd, prd_nm FROM t_prd_products WHERE prd_cd IN {plist};"):
        prd_nm[r[0]] = r[1]
    # union 의 가격 전용 상품명도(가격 섹션용)
    for r in runsql(f"SELECT prd_cd, prd_nm FROM t_prd_products WHERE prd_cd IN {in_list(union_prds)};"):
        prd_nm.setdefault(r[0], r[1])

    # 1 카테고리 (cat_cd→cat_nm)
    for r in runsql(
        "SELECT pc.prd_cd, pc.cat_cd, c.cat_nm, pc.main_cat_yn, pc.disp_seq "
        "FROM t_prd_product_categories pc LEFT JOIN t_cat_categories c ON c.cat_cd=pc.cat_cd "
        f"WHERE pc.prd_cd IN {plist} ORDER BY pc.prd_cd, pc.disp_seq;"):
        live[r[0]]["category"].append({"cat_cd": r[1], "cat_nm": r[2], "main": r[3], "seq": r[4]})

    # 2 사이즈 (siz_cd→siz_nm)
    for r in runsql(
        "SELECT ps.prd_cd, ps.siz_cd, s.siz_nm, ps.dflt_yn "
        "FROM t_prd_product_sizes ps LEFT JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd "
        f"WHERE ps.prd_cd IN {plist} ORDER BY ps.prd_cd, ps.siz_cd;"):
        live[r[0]]["size"].append({"siz_cd": r[1], "siz_nm": r[2], "dflt": r[3]})

    # 3 도수/인쇄옵션 (front/back colrcnt→clr_nm)
    for r in runsql(
        "SELECT po.prd_cd, po.opt_id, po.print_side, "
        "po.front_colrcnt_cd, fc.clr_nm, po.back_colrcnt_cd, bc.clr_nm, po.dflt_yn "
        "FROM t_prd_product_print_options po "
        "LEFT JOIN t_clr_color_counts fc ON fc.clr_cd=po.front_colrcnt_cd "
        "LEFT JOIN t_clr_color_counts bc ON bc.clr_cd=po.back_colrcnt_cd "
        f"WHERE po.prd_cd IN {plist} AND COALESCE(po.del_yn,'N')<>'Y' "
        "ORDER BY po.prd_cd, po.disp_seq, po.opt_id;"):
        live[r[0]]["print_option"].append({
            "opt_id": r[1], "side": r[2], "front_cd": r[3], "front_nm": r[4],
            "back_cd": r[5], "back_nm": r[6], "dflt": r[7]})

    # 4 판형 (siz_cd→siz_nm, output_paper_typ_cd→cod_nm)
    for r in runsql(
        "SELECT pl.prd_cd, pl.siz_cd, s.siz_nm, pl.dflt_plt_yn, "
        "pl.output_paper_typ_cd, cd.cod_nm, pl.output_file_typ "
        "FROM t_prd_product_plate_sizes pl LEFT JOIN t_siz_sizes s ON s.siz_cd=pl.siz_cd "
        "LEFT JOIN t_cod_base_codes cd ON cd.cod_cd=pl.output_paper_typ_cd "
        f"WHERE pl.prd_cd IN {plist} AND COALESCE(pl.del_yn,'N')<>'Y' "
        "ORDER BY pl.prd_cd, pl.siz_cd;"):
        live[r[0]]["plate"].append({
            "siz_cd": r[1], "siz_nm": r[2], "dflt": r[3],
            "paper_cd": r[4], "paper_nm": r[5], "file_typ": r[6]})

    # 5 자재 (mat_cd→mat_nm, usage_cd→cod_nm)
    for r in runsql(
        "SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, pm.usage_cd, u.cod_nm, "
        "pm.dflt_yn, pm.disp_seq, pm.reg_dt "
        "FROM t_prd_product_materials pm LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd "
        "LEFT JOIN t_cod_base_codes u ON u.cod_cd=pm.usage_cd "
        f"WHERE pm.prd_cd IN {plist} ORDER BY pm.prd_cd, pm.disp_seq, pm.mat_cd;"):
        live[r[0]]["material"].append({
            "mat_cd": r[1], "mat_nm": r[2], "usage_cd": r[3], "usage_nm": r[4],
            "dflt": r[5], "seq": r[6], "reg_dt": r[7]})

    # 6 공정 (proc_cd→proc_nm)
    for r in runsql(
        "SELECT pp.prd_cd, pp.proc_cd, pr.proc_nm, pp.mand_proc_yn, pp.disp_seq "
        "FROM t_prd_product_processes pp LEFT JOIN t_proc_processes pr ON pr.proc_cd=pp.proc_cd "
        f"WHERE pp.prd_cd IN {plist} AND COALESCE(pp.del_yn,'N')<>'Y' "
        "ORDER BY pp.prd_cd, pp.disp_seq, pp.proc_cd;"):
        live[r[0]]["process"].append({
            "proc_cd": r[1], "proc_nm": r[2], "mand": r[3], "seq": r[4]})

    # 7 묶음수 (bdl_unit_typ_cd→cod_nm)
    for r in runsql(
        "SELECT pb.prd_cd, pb.bdl_qty, pb.bdl_unit_typ_cd, u.cod_nm, pb.dflt_yn, pb.disp_seq "
        "FROM t_prd_product_bundle_qtys pb "
        "LEFT JOIN t_cod_base_codes u ON u.cod_cd=pb.bdl_unit_typ_cd "
        f"WHERE pb.prd_cd IN {plist} ORDER BY pb.prd_cd, pb.bdl_qty;"):
        live[r[0]]["bundle"].append({
            "bdl_qty": r[1], "unit_cd": r[2], "unit_nm": r[3], "dflt": r[4], "seq": r[5]})

    # 8 페이지룰
    for r in runsql(
        "SELECT prd_cd, page_min, page_max, page_incr "
        "FROM t_prd_product_page_rules "
        f"WHERE prd_cd IN {plist} ORDER BY prd_cd;"):
        live[r[0]]["page_rule"].append({"min": r[1], "max": r[2], "incr": r[3]})

    # 9 추가상품 (tmpl_cd→base_prd→prd_nm)
    for r in runsql(
        "SELECT a.prd_cd, a.tmpl_cd, a.disp_seq, t.base_prd_cd, p.prd_nm "
        "FROM t_prd_product_addons a LEFT JOIN t_prd_templates t ON t.tmpl_cd=a.tmpl_cd "
        "LEFT JOIN t_prd_products p ON p.prd_cd=t.base_prd_cd "
        f"WHERE a.prd_cd IN {plist} ORDER BY a.prd_cd, a.disp_seq;"):
        live[r[0]]["addon"].append({
            "tmpl_cd": r[1], "seq": r[2], "base_prd": r[3], "addon_nm": r[4]})

    # 가격공식 (라이브 t_prd_product_price_formulas)
    live_price = defaultdict(list)
    for r in runsql(
        "SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas "
        f"WHERE prd_cd IN {in_list(union_prds)} ORDER BY prd_cd, frm_cd;"):
        live_price[r[0]].append(r[1])

    # 마스터 이름 룩업: 델타가 참조하는 mat_cd/proc_cd/usage_cd 의 라이브 마스터명.
    # (상품-자재/공정 LINK 은 적재 대기이나 자재/공정 MASTER 는 라이브 실존 → [+R5] 행에 실명 표기)
    mat_name = {}
    delta_mats = sorted(set(r["mat_cd"] for r in mat_rows if r["mat_cd"]))
    if delta_mats:
        for r in runsql(
            f"SELECT mat_cd, mat_nm FROM t_mat_materials WHERE mat_cd IN {in_list(delta_mats)};"):
            mat_name[r[0]] = r[1]
    proc_name = {}
    delta_procs = sorted(set(r["proc_cd"] for r in proc_rows if r["proc_cd"]))
    if delta_procs:
        for r in runsql(
            f"SELECT proc_cd, proc_nm FROM t_proc_processes WHERE proc_cd IN {in_list(delta_procs)};"):
            proc_name[r[0]] = r[1]
    cod_name = {}
    delta_cods = sorted(set([r["usage_cd"] for r in mat_rows if r.get("usage_cd")]
                            + [r["bdl_unit_typ_cd"] for r in bdl_rows if r.get("bdl_unit_typ_cd")]))
    if delta_cods:
        for r in runsql(
            f"SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd IN {in_list(delta_cods)};"):
            cod_name[r[0]] = r[1]

    # --- 5. 출처 태깅 + 카운트 집계 ---
    # 각 속성의 라이브/델타/차단/GAP 카운트를 상품별로 산출.
    matrix = {}
    sections = {}
    empty_flags = {}  # 진짜 공백(0/0) 속성 목록

    ATTRS = ["category", "size", "print_option", "plate", "material",
             "process", "bundle", "page_rule", "addon"]
    ATTR_KO = {"category": "카테고리", "size": "사이즈", "print_option": "도수",
               "plate": "판형", "material": "자재", "process": "공정",
               "bundle": "묶음", "page_rule": "페이지룰", "addon": "추가상품"}

    for p in products:
        L = live[p]
        cnt = {a: {"live": 0, "r5": 0, "both": 0, "blocked": 0, "gap": 0} for a in ATTRS}
        sec = {}

        # 1 카테고리 — 라이브 only
        rows = []
        for c in L["category"]:
            cnt["category"]["live"] += 1
            rows.append((T_LIVE, f"{c['cat_cd']} ({c['cat_nm'] or '?'}) main={c['main']} seq={c['seq']}"))
        sec["category"] = rows

        # 2 사이즈 — 라이브 only (sticker 066 원형은 코드선적재+차단, 본 47엔 미포함)
        rows = []
        for s in L["size"]:
            cnt["size"]["live"] += 1
            rows.append((T_LIVE, f"{s['siz_cd']} ({s['siz_nm'] or '?'}) dflt={s['dflt']}"))
        sec["size"] = rows

        # 3 도수/인쇄옵션 — 라이브 + (UV update-set 차단 주석)
        rows = []
        for po in L["print_option"]:
            cnt["print_option"]["live"] += 1
            fr = f"{po['front_cd']}({po['front_nm'] or '?'})" if po['front_cd'] else "-"
            bk = f"{po['back_cd']}({po['back_nm'] or '?'})" if po['back_cd'] else "-"
            rows.append((T_LIVE, f"opt={po['opt_id']} side={po['side']} 앞={fr} 뒤={bk} dflt={po['dflt']}"))
        if p in uv_prds:
            cnt["print_option"]["blocked"] += 1
            rows.append((T_BLOCKED, "UV변형 정정(BLOCKED-25, update-set uv) — "
                         "라이브 print_side 정정/PROC 이동 미실행(비실행 차단)"))
        sec["print_option"] = rows

        # 4 판형 — 라이브 only
        rows = []
        for pl in L["plate"]:
            cnt["plate"]["live"] += 1
            paper = f"{pl['paper_cd']}({pl['paper_nm'] or '?'})" if pl['paper_cd'] else "-"
            rows.append((T_LIVE, f"{pl['siz_cd']} ({pl['siz_nm'] or '?'}) dflt_plt={pl['dflt']} "
                         f"출력지={paper} 파일={pl['file_typ'] or '-'}"))
        sec["plate"] = rows

        # 5 자재 — 델타(05) MERGE 라이브
        rows = []
        live_keys = set((m["mat_cd"], m["usage_cd"]) for m in L["material"])
        live_by_key = {(m["mat_cd"], m["usage_cd"]): m for m in L["material"]}
        delta_keys = set()
        for (dp, dm, du), dr in d_mat.items():
            if dp != p:
                continue
            delta_keys.add((dm, du))
            if (dm, du) in live_keys:
                cnt["material"]["both"] += 1
                rm = live_by_key[(dm, du)]
                rows.append((T_BOTH, f"{dm} ({rm['mat_nm'] or '?'}) / usage={du}({rm['usage_nm'] or '?'}) "
                             f"dflt={rm['dflt']} (라이브 reg_dt={rm['reg_dt']})"))
            else:
                cnt["material"]["r5"] += 1
                # 자재 MASTER 명은 라이브 실존(LINK 만 대기) → 실명 표기
                rows.append((T_R5, f"{dm} ({mat_name.get(dm, '?')}) / usage={du}({cod_name.get(du, '?')}) "
                             f"dflt={dr['dflt_yn']} seq={dr['disp_seq']} — 상품-자재 링크 라이브 미존재(적재 대기)"))
        # 라이브에만 있고 델타엔 없는 자재(있다면)
        for m in L["material"]:
            if (m["mat_cd"], m["usage_cd"]) not in delta_keys:
                cnt["material"]["live"] += 1
                rows.append((T_LIVE, f"{m['mat_cd']} ({m['mat_nm'] or '?'}) / "
                             f"usage={m['usage_cd']}({m['usage_nm'] or '?'}) dflt={m['dflt']} "
                             f"(델타 외 라이브 기존)"))
        sec["material"] = rows

        # 6 공정 — 델타(06) MERGE 라이브 + 레이저커팅 차단
        rows = []
        live_proc_set = set(pr["proc_cd"] for pr in L["process"])
        live_proc_by = {pr["proc_cd"]: pr for pr in L["process"]}
        delta_proc_set = set()
        for (dp, dpc), dr in d_proc.items():
            if dp != p:
                continue
            delta_proc_set.add(dpc)
            if dpc in live_proc_set:
                cnt["process"]["both"] += 1
                pr = live_proc_by[dpc]
                rows.append((T_BOTH, f"{dpc} ({pr['proc_nm'] or '?'}) mand={pr['mand']} seq={pr['seq']} "
                             "(라이브=델타 일치)"))
            else:
                cnt["process"]["r5"] += 1
                rows.append((T_R5, f"{dpc} ({proc_name.get(dpc, '?')}) mand={dr['mand_proc_yn']} "
                             f"seq={dr['disp_seq']} — 상품-공정 링크 라이브 미존재(적재 대기)"))
        for pr in L["process"]:
            if pr["proc_cd"] not in delta_proc_set:
                cnt["process"]["live"] += 1
                rows.append((T_LIVE, f"{pr['proc_cd']} ({pr['proc_nm'] or '?'}) mand={pr['mand']} seq={pr['seq']}"))
        if p in laser_blocked_prds:
            cnt["process"]["blocked"] += 1
            rows.append((T_BLOCKED, f"{laser_proc_cd} ({laser_proc_nm}) 완칼 — 코드행 선적재 의존 "
                         "(레이저커팅 proc_cd 라이브 부재, 후니 등록 대기)"))
        sec["process"] = rows

        # 7 묶음수 — 델타(09) MERGE 라이브
        rows = []
        live_bdl_set = set(b["bdl_qty"] for b in L["bundle"])
        live_bdl_by = {b["bdl_qty"]: b for b in L["bundle"]}
        delta_bdl_set = set()
        for (dp, dq), dr in d_bdl.items():
            if dp != p:
                continue
            delta_bdl_set.add(dq)
            if dq in live_bdl_set:
                cnt["bundle"]["both"] += 1
                b = live_bdl_by[dq]
                rows.append((T_BOTH, f"bdl={dq} unit={b['unit_cd']}({b['unit_nm'] or '?'}) dflt={b['dflt']} (라이브=델타 일치)"))
            else:
                cnt["bundle"]["r5"] += 1
                rows.append((T_R5, f"bdl={dq} unit={dr['bdl_unit_typ_cd']}({cod_name.get(dr['bdl_unit_typ_cd'], '?')}) "
                             f"dflt={dr['dflt_yn']} seq={dr['disp_seq']} — 라이브 미존재(적재 대기)"))
        for b in L["bundle"]:
            if b["bdl_qty"] not in delta_bdl_set:
                cnt["bundle"]["live"] += 1
                rows.append((T_LIVE, f"bdl={b['bdl_qty']} unit={b['unit_cd']}({b['unit_nm'] or '?'}) dflt={b['dflt']}"))
        sec["bundle"] = rows

        # 8 페이지룰 — 라이브 only
        rows = []
        for pgr in L["page_rule"]:
            cnt["page_rule"]["live"] += 1
            rows.append((T_LIVE, f"min={pgr['min']} max={pgr['max']} incr={pgr['incr']}"))
        sec["page_rule"] = rows

        # 9 추가상품 — 라이브 + addon template 부재 차단
        rows = []
        for a in L["addon"]:
            cnt["addon"]["live"] += 1
            rows.append((T_LIVE, f"{a['tmpl_cd']} → {a['base_prd'] or '?'} ({a['addon_nm'] or '?'}) seq={a['seq']}"))
        if p in addon_blocked:
            tmpl, nm = addon_blocked[p]
            cnt["addon"]["blocked"] += 1
            rows.append((T_BLOCKED, f"{tmpl} → {nm} — template 라이브 부재(후니 등록 대기, blocked §2)"))
        sec["addon"] = rows

        # 가격공식 섹션
        prow = []
        lp = set(live_price.get(p, []))
        dp_formulas = [(r["frm_cd"], r.get("note", "")) for r in d_price.get(p, [])]
        for frm, note in dp_formulas:
            if frm in lp:
                prow.append((T_BOTH, f"{frm} (라이브=델타 일치) {note}"))
            else:
                prow.append((T_R5, f"{frm} — 라이브 미존재(적재 대기). {note}"))
        for frm in sorted(lp):
            if frm not in set(f for f, _ in dp_formulas):
                prow.append((T_LIVE, f"{frm} (델타 외 라이브 기존)"))
        sec["price_formula"] = prow

        matrix[p] = cnt
        sections[p] = sec
        # 진짜 공백(라이브0·델타0·차단0·GAP0) 속성. 코어/선택 분리.
        empties = [a for a in ATTRS
                   if cnt[a]["live"] == 0 and cnt[a]["r5"] == 0
                   and cnt[a]["both"] == 0 and cnt[a]["blocked"] == 0 and cnt[a]["gap"] == 0]
        empty_flags[p] = empties

    # --- 6. 문서 작성 ---
    write_doc(products, union_prds, prd_nm, matrix, sections, empty_flags,
              ATTRS, ATTR_KO, d_price, live_price)


def cell(c):
    """매트릭스 셀 = 라이브N (+R5 M / 차단 K / GAP G). 0 은 생략, 전부 0 이면 0/0 표시."""
    base = c["live"] + c["both"]
    extra = []
    if c["r5"]:
        extra.append(f"+R5 {c['r5']}")
    if c["both"]:
        extra.append(f"✓{c['both']}")
    if c["blocked"]:
        extra.append(f"차단 {c['blocked']}")
    if c["gap"]:
        extra.append(f"GAP {c['gap']}")
    if base == 0 and not extra:
        return "**0/0**"
    s = str(base)
    if extra:
        s += " (" + " / ".join(extra) + ")"
    return s


def fmt_section(title, rows):
    out = [f"#### {title}"]
    if not rows:
        out.append("- (없음 — 라이브·델타·차단 모두 0)")
    else:
        for tag, txt in rows:
            out.append(f"- {tag} {txt}")
    return "\n".join(out)


def write_doc(products, union_prds, prd_nm, matrix, sections, empty_flags,
              ATTRS, ATTR_KO, d_price, live_price):
    lines = []
    lines.append("# 상품별 9속성 완전성 검증 — round-5 적재 전 확인 (load-verification-full)\n")
    lines.append("> **목적:** round-5 가 ADD 하는 델타만 보여주는 `load-preview.md` 와 달리, "
                 "**라이브 실존 + round-5 델타를 9속성 전반에 MERGE** 하여 상품별 완전·정확 정의를 "
                 "적재 전 한눈에 확인한다. 예: 프리미엄엽서(PRD_000016)의 카테고리·사이즈·도수·판형·추가상품은 "
                 "**이미 라이브에 존재**하며 \"누락\"이 아니다 — 본 문서가 그것을 명시한다.\n")
    lines.append("> **read-only:** 본 문서는 검증용이며 적재가 아니다. 생성기 `gen_verification_full.py` 는 "
                 "라이브 read-only SELECT 만 수행한다(INSERT/UPDATE/COMMIT/DDL 0). "
                 "비밀값은 `.env.local` 에서만(노출 0).\n")
    lines.append("> **권위:** `docs/goal-2026-06-06-02.md`(round-5) · `-01.md`(round-4) · "
                 "`09_load/_assembled/blocked-and-gaps.md`. round-4 매핑이 권위이며 재매핑·발명 없음.\n")
    lines.append("> **재현:** `python3 09_load/_exec/gen_verification_full.py` — 같은 라이브 상태 + 같은 델타 → 같은 문서.\n")

    # 출처 태그 범례
    lines.append("\n## 출처 태그 (행별)\n")
    lines.append("| 태그 | 의미 |")
    lines.append("|------|------|")
    lines.append(f"| {T_LIVE} | 라이브에 현재 실존(기존 정의) |")
    lines.append(f"| {T_R5} | round-5 델타에 있으나 라이브 미존재 — **적재 대기** |")
    lines.append(f"| {T_BOTH} | 라이브·델타 양쪽 — **이미 적재됨/일치**(멱등 재적재 시 변화 0) |")
    lines.append(f"| {T_BLOCKED} | round-5 차단 — 후니 등록/모델 확정 대기(즉시적재 대상 아님) |")
    lines.append(f"| {T_GAP} | 무손실 표현 불가 — 에스컬레이션(모델링 결정 필요) |")
    lines.append("")
    lines.append("매트릭스 셀 표기: `라이브+적재됨 합계 (+R5 신규 / ✓겹침 / 차단 / GAP)`. "
                 "**0/0** = 라이브·델타 모두 비어있음(주목 대상일 수 있음).\n")

    # --- 완전성 매트릭스 ---
    lines.append("## 완전성 매트릭스 (한눈 표 — 상품 × 9속성)\n")
    hdr = "| 상품(prd_cd) | 상품명 | " + " | ".join(ATTR_KO[a] for a in ATTRS) + " |"
    sep = "|" + "---|" * (len(ATTRS) + 2)
    lines.append(hdr)
    lines.append(sep)
    for p in products:
        cells = [cell(matrix[p][a]) for a in ATTRS]
        nm = prd_nm.get(p, "?")
        lines.append(f"| {p} | {nm} | " + " | ".join(cells) + " |")
    lines.append("")
    lines.append("> 셀 안 `+R5 N` = round-5 가 새로 적재할 행수. `✓N` = 라이브와 델타가 겹치는(이미 적재) 행수. "
                 "`차단 N`/`GAP N` = 등록·모델 대기. 숫자만 = 라이브 실존 행수.\n")

    # --- 진짜 공백 요약 (코어 vs 선택 분리) ---
    # 코어 = 거의 모든 상품이 가져야 할 속성(공백이면 주목). 선택 = 상품 성격상 정당히 빌 수 있음.
    CORE = {"category", "size", "print_option", "plate", "material", "process"}
    OPTIONAL = {"bundle", "page_rule", "addon"}
    core_flagged = {p: [a for a in empty_flags[p] if a in CORE] for p in products}
    core_flagged = {p: a for p, a in core_flagged.items() if a}
    lines.append("## 진짜 공백(0/0) 속성 요약 — 주목 대상\n")
    lines.append("> **코어 속성**(카테고리·사이즈·도수·판형·자재·공정)은 거의 모든 상품이 가져야 한다 — "
                 "공백이면 **적재 전 확인 권장**. **선택 속성**(묶음·페이지룰·추가상품)은 상품 성격상 "
                 "정당히 비어있을 수 있다(예: 비책자의 페이지룰, 단품의 묶음수). 0/0 이 곧 결함은 아니며, "
                 "round-5 델타가 그 속성을 채우지 않는다는 사실의 표기다.\n")
    lines.append("### 코어 속성 공백 (확인 권장)\n")
    if not core_flagged:
        lines.append("- 없음 — 47상품 전건 코어 6속성이 모두 라이브/델타/차단으로 정의됨.\n")
    else:
        lines.append(f"> {len(core_flagged)}개 상품에서 코어 속성 공백 발견(전수 47 중). 라이브 SELECT 기준.\n")
        lines.append("| 상품 | 상품명 | 코어 공백(0/0) |")
        lines.append("|------|------|--------------|")
        for p in products:
            if p in core_flagged:
                ko = ", ".join(ATTR_KO[a] for a in core_flagged[p])
                lines.append(f"| {p} | {prd_nm.get(p,'?')} | {ko} |")
        lines.append("")
    # 선택 속성 공백 분포(개수만 — 정상 범주라 표는 생략)
    lines.append("### 선택 속성 공백 분포 (대부분 정상)\n")
    for a in ["bundle", "page_rule", "addon"]:
        n = sum(1 for p in products if a in empty_flags[p])
        lines.append(f"- {ATTR_KO[a]}: {n}/47 상품이 0/0 (대부분 상품 성격상 정당한 공백)")
    lines.append("")

    # --- 상품별 9속성 상세 ---
    lines.append("## 상품별 9속성 상세 (라이브 + round-5 델타 MERGE)\n")
    for p in products:
        nm = prd_nm.get(p, "?")
        lines.append(f"### {p} — {nm}\n")
        # 한 줄 요약
        summ = " · ".join(
            f"{ATTR_KO[a]} {cell(matrix[p][a])}" for a in ATTRS)
        lines.append(f"**요약:** {summ}\n")
        lines.append(fmt_section("1. 카테고리 (t_prd_product_categories)", sections[p]["category"]))
        lines.append(fmt_section("2. 사이즈 (t_prd_product_sizes)", sections[p]["size"]))
        lines.append(fmt_section("3. 도수/인쇄옵션 (t_prd_product_print_options)", sections[p]["print_option"]))
        lines.append(fmt_section("4. 판형 (t_prd_product_plate_sizes)", sections[p]["plate"]))
        lines.append(fmt_section("5. 자재 (t_prd_product_materials) — round-5 델타 MERGE", sections[p]["material"]))
        lines.append(fmt_section("6. 공정 (t_prd_product_processes) — round-5 델타 MERGE", sections[p]["process"]))
        lines.append(fmt_section("7. 묶음수 (t_prd_product_bundle_qtys) — round-5 델타 MERGE", sections[p]["bundle"]))
        lines.append(fmt_section("8. 페이지룰 (t_prd_product_page_rules)", sections[p]["page_rule"]))
        lines.append(fmt_section("9. 추가상품 (t_prd_product_addons)", sections[p]["addon"]))
        if sections[p]["price_formula"]:
            lines.append(fmt_section("+ 가격공식 (t_prd_product_price_formulas)", sections[p]["price_formula"]))
        lines.append("")

    # --- 가격 섹션 (price-only 상품) ---
    price_only = [p for p in union_prds if p not in set(products)]
    lines.append("## 가격공식 전용 상품 (상품마스터 델타 외, 가격트랙만)\n")
    lines.append("> 아래는 9속성 상품마스터 델타에는 없고 round-5 **가격공식 델타**에만 등장하는 상품이다. "
                 "9속성 검증 대상은 아니나, 가격공식 적재 대상으로 추적한다.\n")
    if not price_only:
        lines.append("- 없음.\n")
    else:
        lines.append("| 상품 | 상품명 | 가격공식(라이브/델타) |")
        lines.append("|------|------|--------------------|")
        for p in price_only:
            lp = set(live_price.get(p, []))
            dp_f = [r["frm_cd"] for r in d_price.get(p, [])]
            tags = []
            for f in dp_f:
                tags.append((T_BOTH if f in lp else T_R5) + f)
            for f in sorted(lp):
                if f not in set(dp_f):
                    tags.append(T_LIVE + f)
            lines.append(f"| {p} | {prd_nm.get(p,'?')} | {' '.join(tags) or '-'} |")
        lines.append("")

    with open(OUT_DOC, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    # stdout 요약(비밀값 없음)
    print(f"문서 생성: {OUT_DOC}")
    print(f"9속성 검증 대상 상품: {len(products)}")
    print(f"가격 전용 추가 상품: {len(price_only)} (union {len(union_prds)})")
    CORE = {"category", "size", "print_option", "plate", "material", "process"}
    n_core_empty = sum(1 for p in products if any(a in CORE for a in empty_flags[p]))
    print(f"코어 속성(0/0) 공백 보유 상품(확인 권장): {n_core_empty}/47")
    # PRD_000016 수용 검증 라인
    if "PRD_000016" in matrix:
        m = matrix["PRD_000016"]
        print("PRD_000016 프리미엄엽서 9속성:")
        print("  " + " · ".join(f"{ATTR_KO[a]} {cell(m[a])}" for a in ATTRS))


if __name__ == "__main__":
    main()
