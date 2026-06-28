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
예:    python3 score_batch.py digital-print            # 동형군 전체
       python3 score_batch.py digital-print PRD_000016 # 단일(자기검증)
"""
import sys
import os
import csv
import json

import lib_huni as H
import authority as A

OUT_DIR = os.path.dirname(os.path.abspath(__file__))
SCOREBOARD = os.path.join(OUT_DIR, "scoreboard-cases.csv")
SUMMARY = os.path.join(OUT_DIR, "scoreboard-summary.csv")
REMED_SQL = os.path.join(OUT_DIR, "remediation-r1.sql")

# 상품군 → {extract group, 케이스 프로파일}
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


def score_product(sim, group, prd_cd):
    prof = GROUP[group]
    grp = prof["extract"]
    lp = live_product(prd_cd)
    if not lp:
        return {"prd_cd": prd_cd, "error": "live 미존재"}, []
    _, prd_nm, prd_typ = lp

    meta = sim.sim_meta(prd_cd)
    frm = (meta.get("frm") or {}).get("frm_cd")
    is_set = meta.get("is_set")

    # ── S1 권위 ──
    auth_pansu = A.authority_pansu(grp, prd_nm)
    auth_mat = A.main_materials(grp, prd_nm)
    req_axes = A.required_axes(grp, prd_nm)
    formula_note = A.price_formula_note(grp, prd_nm)

    # ── 케이스 빌더 입력 ──
    sizes = dim_options(meta, "siz_cd")
    print_opts = dim_options(meta, "print_opt_cd")
    mats = live_materials(prd_cd)
    dflt_mats = [m for m in mats if m[3] == "Y"]
    dflt_mat = dflt_mats[0][0] if dflt_mats else (
        dim_options(meta, "mat_cd")[0]["v"] if dim_options(meta, "mat_cd") else None)
    print_opt = print_opts[0]["v"] if print_opts else None
    # 인쇄공정(이름에 키워드)
    procs = proc_options(meta)
    print_proc = next((p["v"] for p in procs
                       if prof.get("print_proc_kw", "") in (p.get("t") or "")), None)

    cases = []
    for sz in sizes:
        sv, st = sz["v"], A.norm_size(sz["t"].split("(")[0])
        for qty in prof["qty_cases"]:
            sel = {"siz_cd": sv}
            if print_opt:
                sel["print_opt_cd"] = print_opt
            if dflt_mat:
                sel["mat_cd"] = dflt_mat
            kw = [{"proc_cd": print_proc}] if print_proc else None
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
            cases.append({
                "siz_cd": sv, "size": st, "qty": qty,
                "engine_price": price,
                "engine_pansu": pansu,
                "auth_pansu": auth_pansu.get(st),
                "n_comps": len([c for c in comps if c[4]]),
                "error": None,
            })

    # ── S3 채점 ──
    priced = [c for c in cases if c.get("engine_price")]
    calc_ok = len(priced) == len(cases) and len(cases) > 0 and all(
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
    substrate_typ = prof.get("substrate_typ", set())
    use_tokens = prof.get("use_authority_tokens", False)
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
    if sizes:
        sim_axes.add("size")
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

    summary = {
        "prd_cd": prd_cd, "prd_nm": prd_nm, "prd_typ": prd_typ,
        "frm": frm, "is_set": is_set, "formula_note": formula_note,
        "n_cases": len(cases), "calc_ok": calc_ok,
        "priced": len(priced),
        "pansu_match": f"{pansu_match}/{pansu_total}",
        "pansu_signal": [f"{s}:e{e}/a{a}" for s, e, a in pansu_cmp if e != a],
        "R1_contamination": contamination,
        "R3_dflt_ok": dflt_ok, "n_dflt": len(dflt_mats),
        "OC_score": oc_score, "OC_missing": sorted(oc_missing),
    }
    return summary, cases


def main():
    H.load_env()
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    group = sys.argv[1]
    sim = H.HuniSim()

    if len(sys.argv) > 2:
        targets = sys.argv[2:]
    else:
        # 동형군 전체 = 그 frm 바인딩 상품 (digital-print=PRF_DGP_A)
        frm = "PRF_DGP_A" if group == "digital-print" else None
        if frm:
            rows = H.db(f"""SELECT p.prd_cd FROM t_prd_products p
                            JOIN t_prd_product_price_formulas f ON f.prd_cd=p.prd_cd
                            WHERE f.frm_cd='{frm}' AND p.del_yn='N' ORDER BY p.prd_cd""")
            targets = [r[0] for r in rows]
        else:
            print("동형군 자동선정 미지원 — prd_cd 명시 필요")
            sys.exit(1)

    all_cases = []
    all_summaries = []
    print(f"\n{'='*70}\n채점 그룹={group}  대상={len(targets)}상품\n{'='*70}")
    for prd_cd in targets:
        summary, cases = score_product(sim, group, prd_cd)
        all_cases.extend([{**c, "prd_cd": prd_cd} for c in cases])
        if summary.get("error"):
            print(f"\n[{prd_cd}] ERROR: {summary['error']}")
            continue
        all_summaries.append(summary)
        s = summary
        print(f"\n[{s['prd_cd']}] {s['prd_nm']} ({s['prd_typ']}) frm={s['frm']}")
        print(f"  CALC={'OK' if s['calc_ok'] else 'FAIL'} ({s['priced']}/{s['n_cases']} 케이스 PRICE>0)")
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
                 "priced", "pansu_match", "pansu_signal", "R1_contamination",
                 "R3_dflt_ok", "n_dflt", "OC_score", "OC_missing"]
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
