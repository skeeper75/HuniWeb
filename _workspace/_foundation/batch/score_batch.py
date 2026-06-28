#!/usr/bin/env python3
"""
score_batch — 동형 상품군 결정론 채점 드라이버 (토큰 0).

§27 가격 종단 마스터의 계측 레이어. SCORING-FRAMEWORK-260628 의 종료 술어를
스크립트가 자동 산출한다(상품 하나씩 LLM 확인=끝없음 → 배치 결정론).

상품마다:
  S0 sim-meta 분류(frm_cd·is_set·축·qty_rule)
  S1 권위 대조(authority.py: 판수·주자재·요구축·공식)
  S2 케이스 enumerate(사이즈 × 대표수량 × 기본옵션) → simulate(엔진 직접호출)
  S3 채점:
     · CALC  계산가능성(PRICE≠0 전건)
     · PR    엔진 pansu vs 권위 판수(불일치=systemic 신호)·직접격자 모델은 값 일치
     · R1    부자재 오염(라이브 자재 ↔ 권위 주자재/자재타입)
     · R3    dflt_yn=Y 정확히 1개
     · OC    권위 요구 축이 손님 선택 가능(sim-meta)
  S4 스코어보드 행(case CSV) + 상품 요약

[HARD] 라이브 읽기전용·권위 절대·값 날조 0. 결함은 신호로 노출하되 자동 COMMIT 금지.

사용:  python3 score_batch.py <group> [prd_cd ...]
그룹:  digital-print · sticker · acrylic · stationery(단순상품, 갈래1)
       booklet-set(조립형 세트=표지+내지+면지, 갈래2)
예:    python3 score_batch.py sticker                  # 동형군 전체(PRF_STK_FIXED 13)
       python3 score_batch.py acrylic                  # 면적격자 12
       python3 score_batch.py booklet-set              # 세트 7부모 채점
       python3 score_batch.py digital-print PRD_000016 # 단일(자기검증)
"""
import sys
import os
import csv
import json

import lib_huni as H
import authority as A
import group_index as GI

OUT_DIR = os.path.dirname(os.path.abspath(__file__))
SCOREBOARD = os.path.join(OUT_DIR, "scoreboard-cases.csv")
SUMMARY = os.path.join(OUT_DIR, "scoreboard-summary.csv")
SET_SCOREBOARD = os.path.join(OUT_DIR, "scoreboard-sets.csv")
GENERAL_SCOREBOARD = os.path.join(OUT_DIR, "scoreboard-general.csv")
REMED_SQL = os.path.join(OUT_DIR, "remediation-r1.sql")

# ─────────────────────────────────────────────────────────────────────
# 그룹별 R1 부자재 오염 판정 설정 (전 12 권위 그룹 커버)
#   일반 sweep(general)이 어떤 상품을 만나도 R1 채점을 멈추지 않도록(비중단)
#   모든 그룹에 설정을 둔다. 미발견 그룹은 DEFAULT_R1(토큰대조만=보수적).
#   substrate_typ : 정상 주자재(substrate) MAT_TYPE 화이트리스트. 이 밖 = 부속물 오염 후보.
#   use_authority_tokens : 권위 주자재 토큰 대조(mat_typ 단독 판정 불가 그룹=아크릴/굿즈/실사).
# ─────────────────────────────────────────────────────────────────────
GROUP_R1 = {
    "digital-print":     {"substrate_typ": {"MAT_TYPE.01", "MAT_TYPE.08"}},
    "sticker":           {"substrate_typ": {"MAT_TYPE.11", "MAT_TYPE.13"}},
    "acrylic":           {"substrate_typ": {"MAT_TYPE.03", "MAT_TYPE.07"},
                          "use_authority_tokens": True},
    "booklet":           {"substrate_typ": {"MAT_TYPE.01"}, "use_authority_tokens": True},
    "photobook":         {"substrate_typ": {"MAT_TYPE.01"}, "use_authority_tokens": True},
    "stationery":        {"substrate_typ": {"MAT_TYPE.01"}, "use_authority_tokens": True},
    "calendar":          {"substrate_typ": {"MAT_TYPE.01"}, "use_authority_tokens": True},
    "design-calendar":   {"substrate_typ": {"MAT_TYPE.01"}, "use_authority_tokens": True},
    "map":               {"substrate_typ": {"MAT_TYPE.01"}, "use_authority_tokens": True},
    "silsa":             {"use_authority_tokens": True},   # 실사=포스터사인 소재 다양→토큰만
    "goods-pouch":       {"use_authority_tokens": True},   # 굿즈=소재 다양→토큰만
    "product-accessory": {"use_authority_tokens": True},
}
DEFAULT_R1 = {"use_authority_tokens": True}  # 권위 미발견: 토큰대조만(false-positive 최소)


def r1_ctx(extract_group):
    """그룹 → R1 채점 컨텍스트 {substrate_typ, use_authority_tokens}."""
    cfg = GROUP_R1.get(extract_group) or DEFAULT_R1
    return {
        "substrate_typ": cfg.get("substrate_typ", set()),
        "use_authority_tokens": cfg.get("use_authority_tokens", False),
    }


def _num(v):
    """문자/None/Decimal → float(채점 비교용·실패 시 0.0)."""
    try:
        return float(v)
    except (TypeError, ValueError):
        return 0.0

# 상품군 → {extract group, 케이스 프로파일}
#   targets: 동형군 대상 상품 선정 방법
#     {"frm": [...]}        → 그 가격공식에 바인딩된 상품(동형 클래스)
#     {"name_like": [...]}  → prd_nm LIKE 패턴(미바인딩군도 타깃·"가격설계 필요" 신호 노출용)
#     {"set_parents": True} → t_prd_product_sets 부모 상품 전체(세트 채점)
#   is_set: True 면 세트 채점 경로(simulate-set·구성원별 합산) 사용.
#   substrate_typ: R1 주자재 화이트리스트(이 타입 밖 자재 = 부속물 오염 후보).
#   use_authority_tokens: 권위 주자재 토큰 대조 사용(mat_typ 모호한 군=아크릴 .03 등).
GROUP = {
    "digital-print": {
        "extract": "digital-print",
        # 케이스 selections 빌더용: 인쇄옵션 첫째 + 인쇄공정(이름에 '인쇄') + 라이브 dflt 자재
        "print_proc_kw": "인쇄",
        "qty_cases": [100],          # 대표 수량 밴드
        # R1 주자재 타입(정상 substrate): 종이 .01 + 투명소재 .08(PET=투명엽서 주자재).
        # 이 집합 밖 = 부속물(.03 고리/볼펜/지비츠·.17 끈) = 오염.
        # ★PET false-positive 가드: .08 포함(BATCH-design R1 정제).
        "substrate_typ": {"MAT_TYPE.01", "MAT_TYPE.08"},
        "targets": {"frm": ["PRF_DGP_A"]},
    },
    # ── 갈래1: 단순상품 다수 자동 채점(스티커·문구·아크릴) ──────────────
    "sticker": {
        "extract": "sticker",
        "print_proc_kw": "인쇄",
        "qty_cases": [100],
        # 스티커 주자재 타입: .11(스티커 출력소재 다수)·.13(특수지). 둘 다 정상 택1.
        # 이 밖 = 부속물 오염. (PRF_STK_FIXED=고정가 by-siz_cd · 13상품 동형)
        "substrate_typ": {"MAT_TYPE.11", "MAT_TYPE.13"},
        "targets": {"frm": ["PRF_STK_FIXED"]},
    },
    "acrylic": {
        "extract": "acrylic",
        "print_proc_kw": "인쇄",
        "qty_cases": [100],
        # 아크릴 .03 은 본체소재/부속물(고리·볼펜·지비츠)이 섞여 mat_typ 단독 판정 불가
        # → 권위 주자재 토큰 대조로 오염 판정(BATCH-design R1 정제). (PRF_CLR_ACRYL=면적격자 12상품)
        "substrate_typ": {"MAT_TYPE.03", "MAT_TYPE.07"},
        "use_authority_tokens": True,
        "area_model": True,   # siz_cd 미노출·면적(siz_width×siz_height) 입력으로 가격
        "targets": {"frm": ["PRF_CLR_ACRYL"]},
    },
    "stationery": {
        # 문구(만년다이어리·먼슬리플래너·스프링노트/수첩·메모패드·중철노트).
        # ★현재 가격공식 미바인딩(formula=0) → CALC FAIL 신호 = "§18 가격설계 필요"(정직 노출).
        # 떡메모지(097)는 세트라 booklet-set 군에서 채점.
        "extract": "stationery",
        "print_proc_kw": "인쇄",
        "qty_cases": [100],
        "substrate_typ": set(),
        "targets": {"name_like": ["만년다이어리%", "먼슬리플래너%", "스프링노트%",
                                  "스프링수첩%", "메모패드%", "중철노트%"]},
    },
    # ── 갈래2: 조립형(세트) 상품 채점(책자=표지+내지+면지) ──────────────
    "booklet-set": {
        # t_prd_product_sets 부모 전체(하드커버책자·레더·링·엽서북·떡메·포토북).
        # 세트 가격모델 2종을 simulate-set 으로 자동 분류:
        #   ① 완제품가 세트공식(094 엽서북·097 떡메) = set_selections 로 PRICED
        #   ② 구성원 합산형(072 하드커버 등) = 구성원/세트 공식 미바인딩 → BLOCKED(실무진 대기)
        "extract": "booklet",
        "is_set": True,
        "copies_cases": [100],
        "targets": {"set_parents": True},
    },
}

# 대표 수량(권위 판수 검증은 사이즈별 1케이스로 충분)


def live_product(prd_cd):
    r = H.db(f"""SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products
                 WHERE prd_cd='{prd_cd}' AND del_yn='N'""")
    return r[0] if r else None


def live_materials(prd_cd):
    """[(mat_cd, mat_nm, mat_typ_cd, dflt_yn)]."""
    return H.db(f"""SELECT pm.mat_cd, m.mat_nm, m.mat_typ_cd, pm.dflt_yn
                    FROM t_prd_product_materials pm
                    JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
                    WHERE pm.prd_cd='{prd_cd}' AND pm.del_yn='N'
                    ORDER BY pm.dflt_yn DESC, pm.mat_cd""")


def dim_options(meta, name):
    for d in meta.get("prod_dims", []):
        if d.get("name") == name:
            return d.get("options", [])
    return []


def proc_options(meta):
    for d in meta.get("prod_dims", []):
        if d.get("kind") == "proc":
            return d.get("options", [])
    return []


def score_product(sim, prd_cd, extract_group, qty_cases=(100,),
                  print_proc_kw="인쇄", ambiguous=False, all_groups=None):
    """단품 1상품 채점. extract_group = 권위 추출 그룹(일반 sweep 은 상품별 해소).
       extract_group=None 이면 권위축(판수·주자재·요구축) 미적용(CALC 만 채점)."""
    grp = extract_group
    lp = live_product(prd_cd)
    if not lp:
        return {"prd_cd": prd_cd, "error": "live 미존재"}, []
    _, prd_nm, prd_typ = lp

    meta = sim.sim_meta(prd_cd)
    frm_obj = meta.get("frm") or {}
    frm = frm_obj.get("frm_cd")
    frm_nm = frm_obj.get("frm_nm") or ""
    is_set = meta.get("is_set")
    ctx = r1_ctx(grp)

    # ── S1 권위 (그룹 해소 실패 시 빈 권위) ──
    if grp:
        auth_pansu = A.authority_pansu(grp, prd_nm)
        auth_mat = A.main_materials(grp, prd_nm)
        req_axes = A.required_axes(grp, prd_nm)
        formula_note = A.price_formula_note(grp, prd_nm)
    else:
        auth_pansu, auth_mat, req_axes, formula_note = {}, {}, set(), ""

    # ── 케이스 빌더 입력 ──
    sizes = dim_options(meta, "siz_cd")
    nonspec = meta.get("nonspec") or {}
    # 사이즈축 = (label, sel_partial) 리스트. siz_cd 모델이면 사이즈 코드별,
    # 면적 모델(아크릴 등 siz_cd 미노출)이면 nonspec w×h 대표점으로 환산.
    size_specs = []
    for sz in sizes:
        st = A.norm_size(sz["t"].split("(")[0])
        size_specs.append((st, {"siz_cd": sz["v"]}))
    area_model = False
    if not size_specs and (nonspec.get("yn") == "Y" or nonspec.get("w_min")):
        # 면적 입력 대표점: (w_min,h_min) + (w_max,h_max) 있으면 추가. 없으면 60x60.
        # 격자 안(in-grid) 대표점만 — ★최대 코너(w_max,h_max)는 off-grid(above_max_size)
        # 위험이 커서 PRICED-0 거짓신호를 유발하므로 제외. min + 중간점(min과 max 사이)을 쓴다.
        w0 = nonspec.get("w_min") or 60
        h0 = nonspec.get("h_min") or 60
        pts = [(w0, h0)]
        wmax, hmax = nonspec.get("w_max"), nonspec.get("h_max")
        if wmax and hmax:
            # 중간점(min과 max의 중앙·incr 정렬). 최대 코너는 쓰지 않는다.
            wmid = w0 + (int((wmax - w0) / 2 / (nonspec.get("w_incr") or 1))
                         * (nonspec.get("w_incr") or 1))
            hmid = h0 + (int((hmax - h0) / 2 / (nonspec.get("h_incr") or 1))
                         * (nonspec.get("h_incr") or 1))
            if (wmid, hmid) != (w0, h0):
                pts.append((wmid, hmid))
        for w, h in pts:
            size_specs.append((f"{int(w)}x{int(h)}",
                               {"siz_width": w, "siz_height": h}))
        area_model = bool(size_specs)
    print_opts = dim_options(meta, "print_opt_cd")
    mats = live_materials(prd_cd)
    dflt_mats = [m for m in mats if m[3] == "Y"]
    dflt_mat = dflt_mats[0][0] if dflt_mats else (
        dim_options(meta, "mat_cd")[0]["v"] if dim_options(meta, "mat_cd") else None)
    print_opt = print_opts[0]["v"] if print_opts else None
    # 인쇄공정(이름에 키워드)
    procs = proc_options(meta)
    print_proc = next((p["v"] for p in procs
                       if (print_proc_kw or "") in (p.get("t") or "")), None)

    cases = []
    for st, size_sel in size_specs:
        for qty in qty_cases:
            sel = dict(size_sel)
            if print_opt:
                sel["print_opt_cd"] = print_opt
            if dflt_mat:
                sel["mat_cd"] = dflt_mat
            kw = [{"proc_cd": print_proc}] if print_proc else None
            sv = size_sel.get("siz_cd") or st
            try:
                res = sim.simulate(prd_cd, sel, qty, procs=kw)
            except Exception as e:
                cases.append({"siz_cd": sv, "size": st, "qty": qty,
                              "engine_price": None, "engine_pansu": None,
                              "auth_pansu": auth_pansu.get(st), "error": str(e)[:80]})
                continue
            price = H.price_of(res)
            comps = H.components_of(res)
            pansu = next((c[3] for c in comps if c[3] is not None), None)
            # off-grid 판정: 컴포넌트 error 가 사이즈 범위밖(above_max/below_min/size)이면
            # 결함(0)이 아니라 격자밖 신호 → 채점에서 제외(거짓 PRICED-0 방지).
            cerr = ""
            for c in (res.get("base", {}).get("components") or []):
                e = c.get("error")
                if e:
                    cerr = str(e)
                    break
            offgrid = any(k in cerr for k in
                          ("above_max", "below_min", "max_size", "min_size", "off_grid"))
            cases.append({
                "siz_cd": sv, "size": st, "qty": qty,
                "engine_price": price,
                "engine_pansu": pansu,
                "auth_pansu": auth_pansu.get(st),
                "n_comps": len([c for c in comps if c[4]]),
                "offgrid": offgrid,
                "error": cerr or None,
            })

    # ── S3 채점 ──
    # off-grid 케이스는 채점 모집단에서 제외(격자밖=결함 아님).
    scored = [c for c in cases if not c.get("offgrid")]
    priced = [c for c in scored if c.get("engine_price")]
    n_offgrid = len(cases) - len(scored)
    # CALC OK = 채점대상이 있고 전건 PRICE>0 (off-grid 만 있으면 OK 아님→UNSCORED)
    calc_ok = len(scored) > 0 and len(priced) == len(scored) and all(
        c["engine_price"] > 0 for c in priced)
    # PR 신호: pansu 불일치
    pansu_cmp = [(c["size"], c["engine_pansu"], c["auth_pansu"]) for c in cases
                 if c.get("auth_pansu") is not None and c.get("engine_pansu") is not None]
    pansu_match = sum(1 for s, e, a in pansu_cmp if e == a)
    pansu_total = len(pansu_cmp)
    # R1 부자재 오염 (BATCH-design: mat_typ 단독 불가 → 주자재 타입 화이트리스트):
    #   디지털인쇄군 = 모든 종이(.01)·투명소재(.08)는 정상 주자재(손님 택1).
    #   진짜 오염 = 부속물 타입(.03 고리/볼펜/지비츠·.17 끈) = substrate 밖.
    #   ★PET(.08) false-positive 가드 + 정상 종이(.01) false-positive 가드 동시.
    #   ★권위 토큰 대조는 use_authority_tokens=True 군에서만(아크릴 등 .03 모호).
    substrate_typ = ctx["substrate_typ"]
    use_tokens = ctx["use_authority_tokens"]
    auth_tokens = auth_mat.get("tokens", set())
    contamination = []
    for m in mats:
        mat_cd, mat_nm, mat_typ = m[0], m[1], m[2]
        if use_tokens and auth_tokens and not auth_mat.get("freeform"):
            hit = any(tok in mat_nm or mat_nm in tok for tok in auth_tokens)
            if not hit and (not substrate_typ or mat_typ not in substrate_typ):
                contamination.append((mat_cd, mat_nm, mat_typ))
        else:
            if substrate_typ and mat_typ not in substrate_typ:
                contamination.append((mat_cd, mat_nm, mat_typ))
    # R3 dflt 1개
    dflt_ok = len(dflt_mats) == 1
    # OC: 요구 축 selectable in sim-meta
    sim_axes = set()
    if sizes or area_model or nonspec.get("yn") in ("Y", "N"):
        sim_axes.add("size")  # 면적 모델(아크릴)은 nonspec w×h 가 사이즈축
    if dim_options(meta, "mat_cd"):
        sim_axes.add("material")
    if print_opts:
        sim_axes.add("print_opt")
    if procs:
        sim_axes.add("finish")  # 후가공/공정은 proc 차원으로 노출
    if meta.get("qty_rule"):
        sim_axes.add("qty")
    oc_covered = req_axes & sim_axes
    oc_missing = req_axes - sim_axes
    oc_score = round(100 * len(oc_covered) / len(req_axes)) if req_axes else None

    # CALC 상태 분류(거짓 FAIL 방지 + 비중단 actionable 버킷):
    #   OK                    = 전 케이스 PRICE>0 (정상)
    #   TBD-미설정             = 공식 바인딩됐으나 사이즈/단가 미설정(frm_nm 에 ★/미설정 또는 _TBD)
    #                            → §18 설계 필요(known placeholder·미스터리 아님)
    #   UNBOUND-PRICE-IN-SHEET = 공식 없음 + (가격포함) 시트 = 마스터 시트에 가격 내장
    #                            → §18 시트 추출 설계(포토북 모델 동형·사용자 directive)
    #   UNBOUND-NO-PRICE      = 공식 없음 + 가격포함 아님 = 가격 원천 없음(진짜 설계 필요)
    #   UNSCORED-축미탑재       = 사이즈축 enumerate 0(siz_cd·면적 둘 다 미노출)=빌더 한계·확인필요
    #   PRICED-0              = 공식 있는데 케이스 0원 = 진짜 결함 신호(돈크리티컬)
    is_tbd = ("★" in frm_nm) or ("미설정" in frm_nm) or bool(frm and frm.endswith("_TBD"))
    pricein = GI.is_pricein_sheet(grp) if grp else False
    if calc_ok:
        calc_status = "OK"
    elif is_tbd:
        calc_status = "TBD-미설정"
    elif not frm:
        calc_status = "UNBOUND-PRICE-IN-SHEET" if pricein else "UNBOUND-NO-PRICE"
    elif len(scored) == 0:
        # 채점대상 0 = 사이즈축 미탑재 또는 전 케이스 off-grid(격자밖)
        calc_status = "UNSCORED-축미탑재" if n_offgrid == 0 else "OFFGRID-격자밖"
    else:
        calc_status = "PRICED-0"

    summary = {
        "prd_cd": prd_cd, "prd_nm": prd_nm, "prd_typ": prd_typ,
        "frm": frm, "frm_nm": frm_nm, "is_set": is_set, "formula_note": formula_note,
        "extract_group": grp or "(미발견)", "ambiguous": ambiguous,
        "all_groups": ";".join(sorted(all_groups)) if all_groups else "",
        "pricein_sheet": pricein,
        "n_cases": len(cases), "n_offgrid": n_offgrid,
        "calc_ok": calc_ok, "calc_status": calc_status,
        "priced": len(priced),
        "pansu_match": f"{pansu_match}/{pansu_total}",
        "pansu_signal": [f"{s}:e{e}/a{a}" for s, e, a in pansu_cmp if e != a],
        "R1_contamination": contamination,
        "R3_dflt_ok": dflt_ok, "n_dflt": len(dflt_mats),
        "OC_score": oc_score, "OC_missing": sorted(oc_missing),
    }
    return summary, cases


# ─────────────────────────────────────────────────────────────────────
# 세트(조립형) 채점 — 갈래2: 책자=표지+내지+면지
# ─────────────────────────────────────────────────────────────────────
def _set_selections(meta):
    """세트 완제품가 공식 입력 = 부모 fk 차원의 첫 옵션값 전부(siz_cd·bdl_qty·print_opt_cd…).
    완제품가 세트공식(094·097)은 이 값들로 PRICED 된다."""
    ss = {}
    for d in meta.get("prod_dims", []):
        if d.get("kind") == "fk" and d.get("options"):
            ss[d["name"]] = d["options"][0]["v"]
    return ss


def _member_payload(meta, set_sel, copies):
    """구성원(반제품) 입력 조립 — 역할군당 1개(택1 대표). 내지=derived(페이지 파생)·그 외=manual."""
    by_role = {}
    for m in (meta.get("set_members") or []):
        # 같은 역할(표지/내지/면지)이 여러 옵션이면 첫째만(손님 택1 대표).
        by_role.setdefault(m.get("role") or m.get("sub_prd_cd"), m)
    payload = []
    for m in by_role.values():
        mats = m.get("materials") or []
        dflt_mat = next((x["v"] for x in mats if x.get("dflt")),
                        (mats[0]["v"] if mats else None))
        sizes = m.get("sizes") or []
        siz = sizes[0]["v"] if sizes else set_sel.get("siz_cd")
        pr = m.get("page_rule") or {}
        if m.get("is_inner"):
            payload.append({"sub_prd_cd": m["sub_prd_cd"], "role": m.get("role"),
                            "label": m.get("prd_nm"), "qty_mode": "derived",
                            "pages": pr.get("min") or 24, "siz_cd": siz, "mat_cd": dflt_mat})
        else:
            payload.append({"sub_prd_cd": m["sub_prd_cd"], "role": m.get("role"),
                            "label": m.get("prd_nm"), "qty_mode": "manual",
                            "qty": copies, "siz_cd": siz, "mat_cd": dflt_mat})
    return payload


def score_set_product(sim, group, prd_cd):
    """세트 1상품 채점: 대표 부수 케이스로 simulate-set → CALC/STATUS/이중합산 신호."""
    prof = GROUP[group]
    lp = live_product(prd_cd)
    if not lp:
        return {"prd_cd": prd_cd, "error": "live 미존재"}, []
    _, prd_nm, prd_typ = lp
    meta = sim.sim_meta(prd_cd)
    if not meta.get("is_set"):
        return {"prd_cd": prd_cd, "prd_nm": prd_nm, "error": "세트 아님(구성 없음)"}, []

    set_frm = (meta.get("frm") or {}).get("frm_cd")  # 완제품가 세트공식(있으면)
    set_sel = _set_selections(meta)
    members_in = _member_payload(meta, set_sel, prof["copies_cases"][0])
    n_members = len(meta.get("set_members") or [])

    cases = []
    for copies in prof["copies_cases"]:
        try:
            res = sim.simulate_set(prd_cd, copies, members_in, set_selections=set_sel)
        except Exception as e:
            cases.append({"prd_cd": prd_cd, "copies": copies, "final_price": None,
                          "set_contrib": None, "members_priced": None,
                          "members_included": None, "error": str(e)[:80]})
            continue
        fp = H.price_of(res)
        set_contrib = _num((res.get("set_eval") or {}).get("contribution"))
        mb = res.get("members") or []
        priced = sum(1 for m in mb if _num(m.get("contribution")) > 0)
        incl = sum(1 for m in mb if m.get("included"))
        cases.append({"prd_cd": prd_cd, "copies": copies,
                      "final_price": fp, "set_contrib": set_contrib,
                      "members_priced": priced, "members_included": incl, "error": None})

    # ── 채점 ──
    priced_cases = [c for c in cases if c.get("final_price") and c["final_price"] > 0]
    calc_ok = len(priced_cases) == len(cases) and len(cases) > 0
    last = cases[-1] if cases else {}
    # 세트 가격모델 분류 + 이중합산 신호:
    #   PRICED-완제품가     = 세트공식만 기여(구성원가 0) — 094 엽서북·097 떡메 패턴(정상)
    #   PRICED-구성원합산    = 구성원만 기여(세트공식 없음) — 구성원별 가격 합(정상)
    #   PRICED-2레이어      = 세트공식(기본/제본) + 구성원(증분) 동시 기여 = 의도된 2-레이어
    #                         (포토북=기본24P 부모 + 추가페이지 내지·072=표지제본 + 내지)
    #                         ★기본/증분 분리 모델이면 정상. 같은 항목 중복이면 진짜 이중합산.
    #   PRICED(★이중합산 의심)= 세트공식 frm_nm 이 "완제품가/완성가" 전체가인데 구성원도 가격
    #   BLOCKED-미바인딩      = 가격 0(구성원/세트 공식 미바인딩 → §18 단가설계)
    set_frm_nm = (meta.get("frm") or {}).get("frm_nm") or ""
    set_contrib_pos = _num(last.get("set_contrib")) > 0
    members_pos = (last.get("members_priced") or 0) > 0
    # 완제품가(전체가) 세트공식 표식: 이름에 '완제품'/'완성'/'FIXED' → 그 자체로 전체가
    full_price_set = ("완제품" in set_frm_nm or "완성" in set_frm_nm
                      or (set_frm and set_frm.endswith("_FIXED")))
    if calc_ok:
        if set_contrib_pos and members_pos:
            status = ("PRICED(★이중합산 의심)" if full_price_set else "PRICED-2레이어")
        elif set_contrib_pos:
            status = "PRICED-완제품가"
        elif members_pos:
            status = "PRICED-구성원합산"
        else:
            status = "PRICED"
    else:
        status = "BLOCKED-미바인딩"

    summary = {
        "prd_cd": prd_cd, "prd_nm": prd_nm, "prd_typ": prd_typ,
        "set_frm": set_frm or "(없음)", "n_members": n_members,
        "set_sel_dims": sorted(set_sel.keys()),
        "final_price": last.get("final_price"),
        "set_contrib": last.get("set_contrib"),
        "members_priced": last.get("members_priced"),
        "members_included": last.get("members_included"),
        "calc_ok": calc_ok, "status": status,
    }
    return summary, cases


def set_member_cds():
    """세트 구성원(.02 반제품) + 세트 부모 prd_cd 집합 — 일반 sweep 제외용."""
    mem = {r[0] for r in H.db(
        "SELECT DISTINCT sub_prd_cd FROM t_prd_product_sets WHERE del_yn='N'")}
    par = {r[0] for r in H.db(
        "SELECT DISTINCT prd_cd FROM t_prd_product_sets WHERE del_yn='N'")}
    return mem | par


def select_general():
    """일반상품 sweep 대상 = 전 .01/.03 비(非)세트 상품(구성원/부모 제외).
       세트 구성원(.02)은 세트 경로에서 채점되므로 제외."""
    skip = set_member_cds()
    rows = H.db("""SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products
                   WHERE del_yn='N' AND prd_typ_cd IN ('PRD_TYPE.01','PRD_TYPE.03')
                   ORDER BY prd_cd""")
    return [(r[0], r[1]) for r in rows if r[0] not in skip]


def select_targets(group):
    """프로파일 targets 규칙으로 대상 prd_cd 리스트 선정."""
    sel = GROUP[group].get("targets") or {}
    if sel.get("set_parents"):
        rows = H.db("""SELECT DISTINCT s.prd_cd FROM t_prd_product_sets s
                       JOIN t_prd_products p ON p.prd_cd=s.prd_cd
                       WHERE s.del_yn='N' AND p.del_yn='N' ORDER BY s.prd_cd""")
        return [r[0] for r in rows]
    if sel.get("frm"):
        frms = "','".join(sel["frm"])
        rows = H.db(f"""SELECT DISTINCT p.prd_cd FROM t_prd_products p
                        JOIN t_prd_product_price_formulas f ON f.prd_cd=p.prd_cd
                        WHERE f.frm_cd IN ('{frms}') AND p.del_yn='N' ORDER BY p.prd_cd""")
        return [r[0] for r in rows]
    if sel.get("name_like"):
        likes = " OR ".join(f"p.prd_nm LIKE '{pat}'" for pat in sel["name_like"])
        rows = H.db(f"""SELECT p.prd_cd FROM t_prd_products p
                        WHERE p.del_yn='N' AND ({likes}) ORDER BY p.prd_cd""")
        return [r[0] for r in rows]
    return []


def run_set_group(sim, group, targets):
    """세트 채점 실행 + 세트 스코어보드 기록."""
    print(f"\n{'='*70}\n세트 채점 그룹={group}  대상={len(targets)}상품\n{'='*70}")
    summaries, all_cases = [], []
    for prd_cd in targets:
        summary, cases = score_set_product(sim, group, prd_cd)
        all_cases.extend(cases)
        if summary.get("error"):
            print(f"\n[{prd_cd}] {summary.get('prd_nm','')}: {summary['error']}")
            continue
        summaries.append(summary)
        s = summary
        print(f"\n[{s['prd_cd']}] {s['prd_nm']} ({s['prd_typ']})  세트공식={s['set_frm']}  구성원={s['n_members']}")
        print(f"  CALC={'OK' if s['calc_ok'] else 'FAIL'}  final_price={s['final_price']}  "
              f"set기여={s['set_contrib']}  구성원가격={s['members_priced']}/{s['members_included']}")
        print(f"  STATUS={s['status']}  set_sel축={s['set_sel_dims'] or '없음'}")

    if summaries:
        scols = ["prd_cd", "prd_nm", "prd_typ", "set_frm", "n_members", "set_sel_dims",
                 "final_price", "set_contrib", "members_priced", "members_included",
                 "calc_ok", "status"]
        with open(SET_SCOREBOARD, "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=scols, extrasaction="ignore")
            w.writeheader()
            for s in summaries:
                row = dict(s)
                row["set_sel_dims"] = ";".join(s.get("set_sel_dims") or [])
                w.writerow(row)
        print(f"\n세트 스코어보드 → {SET_SCOREBOARD} ({len(summaries)}행)")
        n_priced = sum(1 for s in summaries if s["calc_ok"])
        print(f"  요약: PRICED {n_priced}/{len(summaries)} · "
              f"BLOCKED-미바인딩 {len(summaries)-n_priced}(실무진 대기·§18)")
    return summaries


GEN_COLS = ["prd_cd", "prd_nm", "prd_typ", "extract_group", "ambiguous",
            "all_groups", "pricein_sheet", "frm", "frm_nm", "n_cases",
            "calc_status", "priced", "pansu_match", "pansu_signal",
            "R1_contamination", "R3_dflt_ok", "n_dflt", "OC_score", "OC_missing"]


def _write_general(summaries):
    with open(GENERAL_SCOREBOARD, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=GEN_COLS, extrasaction="ignore")
        w.writeheader()
        for s in summaries:
            row = dict(s)
            row["pansu_signal"] = ";".join(s.get("pansu_signal") or [])
            row["R1_contamination"] = ";".join(
                f"{c[0]}({c[1]})" for c in (s.get("R1_contamination") or []))
            row["OC_missing"] = ";".join(s.get("OC_missing") or [])
            w.writerow(row)


def run_general(sim, targets):
    """일반상품 전수 sweep — 상품별 권위그룹 해소 + 채점 + 비중단 상태 분류.
       targets = [(prd_cd, prd_nm), ...]. 권위 미발견도 CALC 채점(멈추지 않음)."""
    print(f"\n{'='*70}\n일반상품 sweep  대상={len(targets)}상품 "
          f"(전 .01/.03 비세트·세트구성원 제외)\n{'='*70}")
    summaries = []
    from collections import Counter
    stat = Counter()
    for prd_cd, prd_nm in targets:
        g, ambig, gs = GI.resolve_group(prd_nm)
        try:
            summary, _ = score_product(sim, prd_cd, g, ambiguous=ambig, all_groups=gs)
        except Exception as e:
            summary = {"prd_cd": prd_cd, "prd_nm": prd_nm, "error": str(e)[:90]}
        if summary.get("error"):
            stat["ERROR"] += 1
            print(f"  [{prd_cd}] {prd_nm[:20]} ERROR: {summary['error']}")
            summaries.append({"prd_cd": prd_cd, "prd_nm": prd_nm,
                              "calc_status": "ERROR", "frm_nm": summary["error"]})
            continue
        summaries.append(summary)
        stat[summary["calc_status"]] += 1
    _write_general(summaries)
    print(f"\n일반 스코어보드 → {GENERAL_SCOREBOARD} ({len(summaries)}행)")
    print("=== CALC 상태 집계 (비중단·전수) ===")
    for k, n in stat.most_common():
        print(f"  {k:26s} {n}")
    # 돈크리티컬·확인 큐 요약
    crit = [s for s in summaries if s.get("calc_status") == "PRICED-0"]
    if crit:
        print(f"\n★PRICED-0 (진짜 결함·돈크리티컬) {len(crit)}건:")
        for s in crit:
            print(f"  {s['prd_cd']} {s['prd_nm'][:24]} frm={s.get('frm')}")
    return summaries


def main():
    H.load_env()
    if len(sys.argv) < 2:
        print(__doc__)
        print("그룹:", ", ".join(GROUP.keys()))
        sys.exit(1)
    group = sys.argv[1]
    SPECIAL = {"general", "all"}
    if group not in GROUP and group not in SPECIAL:
        print(f"미지원 그룹: {group}\n지원: {', '.join(GROUP.keys())} · general · all")
        sys.exit(1)
    sim = H.HuniSim()

    # ── 일반상품 전수 sweep (모든 .01/.03 비세트) ──
    if group == "general":
        run_general(sim, select_general())
        return
    # ── all = 일반 sweep + 세트 sweep (전 상품 비중단 종단) ──
    if group == "all":
        run_general(sim, select_general())
        run_set_group(sim, "booklet-set", select_targets("booklet-set"))
        return

    if len(sys.argv) > 2:
        targets = sys.argv[2:]
    else:
        targets = select_targets(group)
        if not targets:
            print(f"동형군 자동선정 0건 — targets 규칙 확인({GROUP[group].get('targets')})")
            sys.exit(1)

    # ── 세트(조립형) 경로 ──
    if GROUP[group].get("is_set"):
        run_set_group(sim, group, targets)
        return

    all_cases = []
    all_summaries = []
    print(f"\n{'='*70}\n채점 그룹={group}  대상={len(targets)}상품\n{'='*70}")
    prof = GROUP[group]
    eg = prof["extract"]
    qcs = prof.get("qty_cases", (100,))
    ppk = prof.get("print_proc_kw", "인쇄")
    for prd_cd in targets:
        summary, cases = score_product(sim, prd_cd, eg, qty_cases=qcs, print_proc_kw=ppk)
        all_cases.extend([{**c, "prd_cd": prd_cd} for c in cases])
        if summary.get("error"):
            print(f"\n[{prd_cd}] ERROR: {summary['error']}")
            continue
        all_summaries.append(summary)
        s = summary
        print(f"\n[{s['prd_cd']}] {s['prd_nm']} ({s['prd_typ']}) frm={s['frm']}")
        print(f"  CALC={s['calc_status']} ({s['priced']}/{s['n_cases']} 케이스 PRICE>0)")
        print(f"  PR pansu일치={s['pansu_match']}  신호={s['pansu_signal']}")
        print(f"  R1 부자재오염={s['R1_contamination'] or '0(청정)'}")
        print(f"  R3 dflt={s['n_dflt']}개 {'OK' if s['R3_dflt_ok'] else 'FAIL'}")
        print(f"  OC={s['OC_score']}점  미충족축={s['OC_missing'] or '없음'}")

    # case-level 스코어보드 기록
    if all_cases:
        cols = ["prd_cd", "siz_cd", "size", "qty", "engine_price",
                "engine_pansu", "auth_pansu", "n_comps", "error"]
        with open(SCOREBOARD, "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=cols, extrasaction="ignore")
            w.writeheader()
            w.writerows(all_cases)
        print(f"\n케이스 스코어보드 → {SCOREBOARD} ({len(all_cases)}행)")

    # 상품 요약 스코어보드 기록
    if all_summaries:
        scols = ["prd_cd", "prd_nm", "prd_typ", "frm", "n_cases", "calc_ok",
                 "calc_status", "priced", "pansu_match", "pansu_signal",
                 "R1_contamination", "R3_dflt_ok", "n_dflt", "OC_score", "OC_missing"]
        with open(SUMMARY, "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=scols, extrasaction="ignore")
            w.writeheader()
            for s in all_summaries:
                row = dict(s)
                row["pansu_signal"] = ";".join(s.get("pansu_signal") or [])
                row["R1_contamination"] = ";".join(
                    f"{c[0]}({c[1]})" for c in (s.get("R1_contamination") or []))
                row["OC_missing"] = ";".join(s.get("OC_missing") or [])
                w.writerow(row)
        print(f"상품 요약 스코어보드 → {SUMMARY} ({len(all_summaries)}행)")

    # 결정론 안전 교정 SQL 생성 (R1 부자재 오염 논리삭제 — 마스터 보존·link만)
    remed = []
    for s in all_summaries:
        for c in (s.get("R1_contamination") or []):
            remed.append((s["prd_cd"], c[0], c[1]))
    if remed:
        with open(REMED_SQL, "w", encoding="utf-8") as f:
            f.write("-- R1 부자재 오염 논리삭제(del_yn=Y) — 결정론 안전 교정\n")
            f.write("-- 마스터(t_mat_materials) 미터치·상품 링크(t_prd_product_materials)만\n")
            f.write("-- [HARD] 실 COMMIT은 인간 승인 후. DRY-RUN(BEGIN/ROLLBACK)으로 선검증.\n\n")
            for prd, mat, nm in remed:
                f.write(f"-- {prd} ← {mat} {nm} (부속물 오염)\n")
                f.write(f"UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()\n")
                f.write(f" WHERE prd_cd='{prd}' AND mat_cd='{mat}' AND del_yn='N';\n\n")
        print(f"R1 교정 SQL(인간 승인 대기) → {REMED_SQL} ({len(remed)}건)")


if __name__ == "__main__":
    main()
