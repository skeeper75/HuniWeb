#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""CN-3 코팅×종이두께 제약규칙 자동 유도 (wave-3 · PRD_000047 소량전단지).

무엇을 하나:
  라이브에서 047의 코팅 옵션(OPT_000061)과 종이 옵션(OPT_000060)을 읽어,
  ① 코팅 "선택" 집합(유광/무광 = ref 있는 코팅 옵션 = 코팅없음 제외)의 sel_opts 실값(OPV_...)과
  ② 종이 옵션의 mat_cd__usage_cd 환원값(ref_dim_cd=OPT_REF_DIM.03 → MAT__USAGE)을 뽑고,
  종이 옵션명(opt_nm)에서 평량(g)을 파싱해 <180g(차단) / >=180g(허용) 으로 가른 뒤,
  "코팅 선택 AND 얇은 종이(<180g) = 금지" 를 폼빌더 역파싱 가능한 정형 shape(RULE_TYPE.02)로 생성한다.

왜 유도하나(수동 나열 금지):
  종이 자재가 새로 들어오거나 코팅 옵션이 바뀌면 규칙이 안 따라오는 drift 를 없앤다.
  옵션명 평량 + 옵션→자재 환원이 곧 "실재 조합"의 원천.

왜 .02(금지)인가(rule-spec.md §2 결정트리 참조):
  "코팅 선택 → 종이 ∈ [180g 이상 32종]" 을 단일 .03(필수동반)로 담으면 결과절이 32-리스트라
  폼빌더 역파서(단일 결과절만 지원)가 못 연다(RAW-ONLY). .03 대우명제("얇은종이 → 코팅없음")는
  기본값 코팅없음(OPV_000279)이 sel_opts 에 실리는지에 의존(위젯 계약 미검증)이라 오차단 위험.
  → 금지형(.02) "코팅(유광/무광) + 얇은 종이 = 금지" 가 유일하게 안전+역파싱 가능 (§2 표).

산출:
  - derive-snapshot.csv  : 유도 시점 스냅샷(재생성 재현용) — 종이별 평량/허용여부/자재키, 코팅선택집합
  - derived-rules.json   : 생성 규칙(rule_cd/logic/err_msg/validate 케이스) — apply SQL/parse_check 가 참조

읽기전용 SELECT 만 사용(psql). DB 쓰기 없음.
실행:  python3 derive_coating_paper.py     (환경변수 RAILWAY_DB_* 필요 — .env.local)
"""
import os
import re
import csv
import json
import subprocess
import datetime

PRD = "PRD_000047"
PAPER_GRP = "OPT_000060"      # 종이 옵션그룹
COATING_GRP = "OPT_000061"    # 코팅 옵션그룹
COATING_NONE_KEYWORD = "코팅없음"  # 이 옵션명은 "코팅 미선택"(ref 없음)
WEIGHT_THRESHOLD = 180        # g — 권위 노트: "★종이두께선택시 : 180g이상 코팅가능" (digital-print-l1.csv)
RULE_CD = "R_EXCL_COATING_THIN_PAPER"


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


def parse_gram(opt_nm):
    """옵션명에서 평량(g) 파싱. 예 '아트지 180g' → 180. 판별 불가면 None (→ AMBIG)."""
    m = re.findall(r"(\d+)\s*[gG]\b", opt_nm)
    if m:
        return int(m[-1])  # 이름에 숫자 여럿이면 g 접미 마지막(평량) 채택
    return None


def main():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    here = os.path.dirname(os.path.abspath(__file__))

    # 1) 코팅 옵션(선택 집합) — 코팅없음 제외, ref 있는(=실제 코팅) 옵션의 opt_cd(OPV_...)
    coating = db(f"""SELECT o.opt_cd, o.opt_nm,
                            COALESCE(MAX(oi.ref_dim_cd),'') AS ref_dim,
                            COALESCE(MAX(oi.ref_key1),'')   AS ref_key1
                       FROM t_prd_product_options o
                       LEFT JOIN t_prd_product_option_items oi
                         ON oi.prd_cd=o.prd_cd AND oi.opt_cd=o.opt_cd AND COALESCE(oi.del_yn,'N')<>'Y'
                       WHERE o.prd_cd='{PRD}' AND o.opt_grp_cd='{COATING_GRP}'
                         AND COALESCE(o.del_yn,'N')<>'Y'
                       GROUP BY o.opt_cd, o.opt_nm, o.disp_seq
                       ORDER BY o.disp_seq""")
    coating_selected = []   # [(opt_cd, opt_nm, ref)]
    coating_none = []
    for opt_cd, opt_nm, ref_dim, ref_key1 in coating:
        if COATING_NONE_KEYWORD in opt_nm or ref_dim == "":
            coating_none.append((opt_cd, opt_nm))
        else:
            coating_selected.append((opt_cd, opt_nm, f"{ref_dim}:{ref_key1}"))

    # 2) 종이 옵션 — opt_cd(OPV) + mat_cd__usage_cd 환원 + 옵션명(평량 파싱원)
    papers = db(f"""SELECT o.opt_cd, o.opt_nm, oi.ref_dim_cd, oi.ref_key1, oi.ref_key2, o.disp_seq
                     FROM t_prd_product_options o
                     JOIN t_prd_product_option_items oi
                       ON oi.prd_cd=o.prd_cd AND oi.opt_cd=o.opt_cd AND COALESCE(oi.del_yn,'N')<>'Y'
                     WHERE o.prd_cd='{PRD}' AND o.opt_grp_cd='{PAPER_GRP}'
                       AND COALESCE(o.del_yn,'N')<>'Y'
                     ORDER BY o.disp_seq""")

    snap = []
    thin_matkeys = []   # <180g (차단 대상)
    ambig = []          # 평량 판별 불가
    for opt_cd, opt_nm, ref_dim, ref_key1, ref_key2, seq in papers:
        gram = parse_gram(opt_nm)
        matkey = f"{ref_key1}__{ref_key2}" if ref_dim == "OPT_REF_DIM.03" else ""
        if gram is None:
            verdict = "AMBIG"
            ambig.append((opt_cd, opt_nm, matkey))
        elif gram < WEIGHT_THRESHOLD:
            verdict = "BLOCK(<180)"
            if matkey:
                thin_matkeys.append(matkey)
        else:
            verdict = "ALLOW(>=180)"
        snap.append({
            "opt_cd": opt_cd, "opt_nm": opt_nm, "gram": gram if gram is not None else "",
            "ref_dim": ref_dim, "mat_key": matkey, "verdict": verdict,
        })

    # ── 정형 shape (RULE_TYPE.02 금지 · 폼빌더 복수조건 v2 와 동형) ──────────────
    # {"!": {"and": [ {"or":[코팅선택 in sel_opts...]}, {"or":[얇은종이 ===mat_cd__usage_cd...]} ]}}
    coating_clauses = [{"in": [c[0], {"var": "sel_opts"}]} for c in coating_selected]
    paper_clauses = [{"===": [{"var": "mat_cd__usage_cd"}, mk]} for mk in thin_matkeys]
    logic = {"!": {"and": [
        {"or": coating_clauses} if len(coating_clauses) > 1 else coating_clauses[0],
        {"or": paper_clauses} if len(paper_clauses) > 1 else paper_clauses[0],
    ]}}

    err_msg = ("코팅은 두꺼운 종이(180g 이상)에서만 가능합니다. "
               "종이를 180g 이상으로 바꾸거나 코팅을 빼 주세요.")
    rule_nm = "[제약조건] 코팅은 두꺼운 종이(180g 이상)에서만 가능"

    # validate 케이스: 막힘1(코팅+얇은종이) · 통과2(코팅+두꺼운종이 · 코팅없음+얇은종이)
    a_thin = thin_matkeys[0]
    a_thick = next(s["mat_key"] for s in snap if s["verdict"].startswith("ALLOW") and s["mat_key"])
    a_coat = coating_selected[0][0]
    a_none = coating_none[0][0] if coating_none else "OPV_000279"
    rule = {
        "prd_cd": PRD, "rule_cd": RULE_CD, "rule_typ_cd": "RULE_TYPE.02",
        "rule_nm": rule_nm, "err_msg": err_msg, "disp_seq": 1,
        "logic": logic,
        "block_case": {"sel_opts": [a_coat], "mat_cd__usage_cd": a_thin},
        "pass_case":  {"sel_opts": [a_coat], "mat_cd__usage_cd": a_thick},
        "pass_case2": {"sel_opts": [a_none], "mat_cd__usage_cd": a_thin},
        "coating_selected": [{"opt_cd": c[0], "opt_nm": c[1], "ref": c[2]} for c in coating_selected],
        "coating_none": [{"opt_cd": c[0], "opt_nm": c[1]} for c in coating_none],
        "thin_matkeys": thin_matkeys,
    }

    # 스냅샷 CSV
    with open(os.path.join(here, "derive-snapshot.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow([f"# 유도 시점: {ts}  원천: 라이브 t_prd_product_options/option_items (읽기전용)  임계: {WEIGHT_THRESHOLD}g"])
        w.writerow([f"# 코팅선택집합(유광/무광): {', '.join(c[0]+'('+c[1]+')' for c in coating_selected)}"])
        w.writerow([f"# 코팅없음(미선택): {', '.join(c[0]+'('+c[1]+')' for c in coating_none)}"])
        w.writerow(["opt_cd", "opt_nm", "gram", "ref_dim", "mat_key", "verdict"])
        for s in snap:
            w.writerow([s["opt_cd"], s["opt_nm"], s["gram"], s["ref_dim"], s["mat_key"], s["verdict"]])

    with open(os.path.join(here, "derived-rules.json"), "w") as f:
        json.dump({"derived_at": ts, "source": "live t_prd_product_options/option_items (read-only)",
                   "threshold_g": WEIGHT_THRESHOLD, "rules": [rule], "ambig": ambig}, f,
                  ensure_ascii=False, indent=2)

    n_block = sum(1 for s in snap if s["verdict"].startswith("BLOCK"))
    n_allow = sum(1 for s in snap if s["verdict"].startswith("ALLOW"))
    print(f"유도 완료 @ {ts}")
    print(f"  종이 옵션: {len(snap)}  (차단<180g: {n_block}  허용>=180g: {n_allow}  AMBIG: {len(ambig)})")
    print(f"  코팅 선택집합: {[c[0] for c in coating_selected]}  코팅없음: {[c[0] for c in coating_none]}")
    print(f"  차단 자재키({len(thin_matkeys)}): {thin_matkeys}")
    if ambig:
        print(f"  [AMBIG] 평량 판별 불가(목록서 제외 안 함·컨펌 큐): {ambig}")
    print(f"  생성 규칙: {RULE_CD} (RULE_TYPE.02)")


if __name__ == "__main__":
    main()
