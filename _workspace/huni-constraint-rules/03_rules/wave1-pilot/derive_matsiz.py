#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""CN-2 자재↔사이즈 제약규칙 자동 유도 (wave-1 파일럿 · 129 폼보드 / 130 포맥스보드).

무엇을 하나:
  라이브 t_prc_component_prices 의 "실존 (mat_cd, siz_cd) 조합"에서 팔 수 있는(단가행 있는)
  조합만 뽑아, 자재별 필수동반 사이즈 규칙(RULE_TYPE.03)을 폼빌더 역파싱 가능한 정형 shape 로 생성한다.

왜 유도하나(수동 나열 금지):
  자재/사이즈가 새로 들어오면 규칙이 안 따라오는 drift 를 없앤다. 단가행이 곧 "실재 조합"의 원천.

산출:
  - derive-snapshot.csv  : 유도 시점 스냅샷(재생성 재현용) — 상품·자재키·허용사이즈·전체그리드·차단셀
  - derived-rules.json   : 생성된 규칙(rule_cd/logic/err_msg) — apply SQL 이 참조

읽기전용 SELECT 만 사용(psql). DB 쓰기 없음.
실행:  python3 derive_matsiz.py         (환경변수 RAILWAY_DB_* 필요 — .env.local)
"""
import os
import csv
import json
import subprocess
import datetime

# 파일럿 대상: 상품 → (보드 컴포넌트, 폼보드/포맥스 라벨, 접두)
TARGETS = {
    "PRD_000129": ("COMP_POSTER_FOAMBOARD_BOARD", "폼보드", "R_MATSIZ_FB"),
    "PRD_000130": ("COMP_POSTER_FOMEXBOARD_BOARD", "포맥스보드", "R_MATSIZ_FX"),
}
USAGE = "USAGE.07"  # 파일럿 자재는 전부 USAGE.07 (실측 확인)


def db(sql):
    """라이브 DB 읽기전용 SELECT → [[col, ...], ...] (탭 구분)."""
    env = dict(os.environ)
    env["PGPASSWORD"] = os.environ["RAILWAY_DB_PASSWORD"]
    env["PGHOST"] = os.environ["RAILWAY_DB_HOST"]
    env["PGPORT"] = os.environ["RAILWAY_DB_PORT"]
    env["PGUSER"] = os.environ["RAILWAY_DB_USER"]
    env["PGDATABASE"] = os.environ["RAILWAY_DB_NAME"]
    out = subprocess.run(["psql", "-At", "-F", "\t", "-c", sql],
                         env=env, capture_output=True, text=True, timeout=120)
    if out.returncode != 0:
        raise RuntimeError(f"psql 실패: {out.stderr.strip()}")
    return [ln.split("\t") for ln in out.stdout.splitlines() if ln != ""]


def matkey(mat_cd):
    return f"{mat_cd}__{USAGE}"


def build_rule_logic(mat_key, siz_cd):
    """폼빌더 RULE_TYPE.03 정형 shape (views.py _build_logic_from_conditions 와 동형).

    {"or": [{"!": {"===": [{"var":"mat_cd__usage_cd"}, MAT]}}, {"===": [{"var":"siz_cd"}, SIZ]}]}
    → 뜻: 이 자재를 고르면(mat===MAT) 사이즈는 반드시 SIZ 여야 한다.
    ★ 반드시 {"!": {"===": ...}} 형태 (건물빌더 생성형). {"!==":...} 는 .03 역파서가 못 연다.
    """
    return {
        "or": [
            {"!": {"===": [{"var": "mat_cd__usage_cd"}, mat_key]}},
            {"===": [{"var": "siz_cd"}, siz_cd]},
        ]
    }


def main():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    here = os.path.dirname(os.path.abspath(__file__))
    snap_rows = []
    all_rules = []

    for prd, (comp, label, prefix) in TARGETS.items():
        # 1) 상품 제공 자재(mat_cd + usage) — 자재명
        mats = db(f"""SELECT pm.mat_cd, pm.usage_cd, COALESCE(m.mat_nm,'')
                       FROM t_prd_product_materials pm
                       LEFT JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
                       WHERE pm.prd_cd='{prd}' AND COALESCE(pm.del_yn,'N')<>'Y'
                       ORDER BY pm.disp_seq""")
        # 2) 상품 제공 사이즈
        sizs = db(f"""SELECT ps.siz_cd, COALESCE(s.siz_nm,'')
                       FROM t_prd_product_sizes ps
                       LEFT JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
                       WHERE ps.prd_cd='{prd}' AND COALESCE(ps.del_yn,'N')<>'Y'
                       ORDER BY ps.disp_seq""")
        siz_nm = {r[0]: r[1] for r in sizs}
        # 3) 단가행 실존 (mat_cd, siz_cd) — 허용 조합 (유도 원천)
        allowed = db(f"""SELECT DISTINCT mat_cd, siz_cd
                          FROM t_prc_component_prices
                          WHERE comp_cd='{comp}' AND mat_cd IS NOT NULL AND siz_cd IS NOT NULL""")
        allowed_by_mat = {}
        for mat_cd, siz_cd in allowed:
            allowed_by_mat.setdefault(mat_cd, set()).add(siz_cd)

        provided_sizes = [r[0] for r in sizs]
        # 규칙 생성: 자재별 허용 사이즈
        idx = 0
        for mat_cd, usage_cd, mat_nm in mats:
            allow = sorted(allowed_by_mat.get(mat_cd, set()))
            blocked = [s for s in provided_sizes if s not in allow]
            # 스냅샷 기록 (전 자재 — 허용/차단 모두)
            snap_rows.append({
                "prd_cd": prd, "label": label, "comp_cd": comp,
                "mat_cd": mat_cd, "usage_cd": usage_cd, "mat_nm": mat_nm,
                "mat_key": matkey(mat_cd),
                "allowed_siz": "|".join(f"{s}({siz_nm.get(s,'')})" for s in allow),
                "blocked_siz": "|".join(f"{s}({siz_nm.get(s,'')})" for s in blocked),
                "n_allowed": len(allow), "n_blocked": len(blocked),
            })
            if len(allow) != 1:
                # 파일럿 상품은 자재당 사이즈 1:1 (실측). 아니면 단일 .03 result 로 표현 불가 → 경고.
                print(f"[WARN] {prd} {mat_cd}: 허용 사이즈 {len(allow)}개 — 단일 .03 규칙 부적합, 검토 필요")
                continue
            idx += 1
            siz_cd = allow[0]
            # rule_cd 접미: A3/A2 + 자재 식별 토큰
            sn = (siz_nm.get(siz_cd, "") or "").upper()
            size_tag = "A3" if "A3" in sn else ("A2" if "A2" in sn else f"S{idx}")
            # 자재 식별 토큰: 색상+두께 모두 포함(자재 구분축이 상품마다 달라 둘 다 실어 모호성 제거)
            mn = mat_nm
            parts = []
            if "블랙" in mn:
                parts.append("BLACK")
            elif "화이트" in mn:
                parts.append("WHITE")
            if "3mm" in mn:
                parts.append("3MM")
            elif "5mm" in mn:
                parts.append("5MM")
            mtok = "_".join(parts) if parts else f"M{idx}"
            rule_cd = f"{prefix}_{size_tag}_{mtok}"
            size_ko = "A3" if size_tag == "A3" else ("A2" if size_tag == "A2" else size_tag)
            rule_nm = f"[제약조건데모] {mat_nm} 는 {size_ko} 크기 전용"
            err_msg = f"이 자재({mat_nm})는 {size_ko} 크기 전용입니다. 크기를 {size_ko}로 선택해 주세요."
            all_rules.append({
                "prd_cd": prd, "rule_cd": rule_cd, "rule_typ_cd": "RULE_TYPE.03",
                "rule_nm": rule_nm, "err_msg": err_msg, "disp_seq": idx,
                "mat_key": matkey(mat_cd), "siz_cd": siz_cd,
                "logic": build_rule_logic(matkey(mat_cd), siz_cd),
                "pass_case": {"mat_cd__usage_cd": matkey(mat_cd), "siz_cd": siz_cd},
                "block_case": {"mat_cd__usage_cd": matkey(mat_cd),
                               "siz_cd": next((s for s in provided_sizes if s != siz_cd), "")},
            })

    # 스냅샷 CSV
    with open(os.path.join(here, "derive-snapshot.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow([f"# 유도 시점: {ts}  원천: 라이브 t_prc_component_prices (읽기전용)"])
        w.writerow(["prd_cd", "label", "comp_cd", "mat_cd", "usage_cd", "mat_nm",
                    "mat_key", "allowed_siz", "blocked_siz", "n_allowed", "n_blocked"])
        for r in snap_rows:
            w.writerow([r["prd_cd"], r["label"], r["comp_cd"], r["mat_cd"], r["usage_cd"],
                        r["mat_nm"], r["mat_key"], r["allowed_siz"], r["blocked_siz"],
                        r["n_allowed"], r["n_blocked"]])

    # 규칙 JSON
    with open(os.path.join(here, "derived-rules.json"), "w") as f:
        json.dump({"derived_at": ts, "source": "live t_prc_component_prices (read-only)",
                   "rules": all_rules}, f, ensure_ascii=False, indent=2)

    print(f"유도 완료 @ {ts}")
    print(f"  스냅샷 자재행: {len(snap_rows)}  생성 규칙: {len(all_rules)}")
    for r in all_rules:
        print(f"  {r['prd_cd']} {r['rule_cd']}: {r['mat_key']} -> {r['siz_cd']}")


if __name__ == "__main__":
    main()
