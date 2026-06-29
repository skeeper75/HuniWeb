#!/usr/bin/env python3
"""
pr_retest — 조건(크기·수량) 동일 매칭 PR 재검사 (비교기 보강).

기존 pr_score 문제: 엔진 케이스(우리 첫 사이즈·qty100)를 예전사이트에 던지면,
예전에 그 크기/수량이 없을 때 golden_fetch 가 조용히 다른 값으로 폴백 → 가짜 차이.

보강 원리: **양쪽에 공통으로 존재하는 (크기, 수량)을 먼저 고른 뒤** 그 동일 조건으로
엔진·예전 둘 다 계산해 비교. 공통 크기 없으면 "비교불가"로 정직 분류(폴백 금지).

[HARD] 라이브 읽기전용·값 날조 0·차이=조사신호(자동교정 X). 브라우저 독점.
"""
import re
import sys
import csv
import os

import lib_huni as H
import golden_fetch as GF
import pr_score as PR
import score_batch as SB

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "pr-retest-result.csv")


def norm_dims(s):
    """'100x150' / '100mm x 150mm' / 'A5 (148X210)' → '100x150'(숫자 가로x세로)."""
    if not s:
        return None
    t = str(s).lower().replace("mm", "")
    m = re.search(r"(\d{2,4})\s*[x×]\s*(\d{2,4})", t)
    return f"{m.group(1)}x{m.group(2)}" if m else None


def engine_size_opts(meta):
    """[(label, siz_cd, normdims)] — 엔진 사이즈 옵션."""
    out = []
    for d in meta.get("prod_dims", []):
        if d.get("name") == "siz_cd":
            for o in d.get("options", []):
                nd = norm_dims(o["t"])
                if nd:
                    out.append((o["t"], o["v"], nd))
    return out


def engine_mat_opts(meta):
    """[(strip_label, mat_cd)] — 엔진 자재 옵션(코드 괄호 제거 라벨)."""
    out = []
    for d in meta.get("prod_dims", []):
        if d.get("name") == "mat_cd":
            for o in d.get("options", []):
                lbl = re.sub(r"\s*\([A-Z]+_\d+\)\s*$", "", o["t"]).strip()
                out.append((lbl, o["v"]))
    return out


def first_popt(meta):
    for d in meta.get("prod_dims", []):
        if d.get("name") == "print_opt_cd" and d.get("options"):
            return d["options"][0]["v"]
    return None


def legacy_size_opts():
    """예전사이트 tmp_p01 사이즈 옵션 [(label, normdims)] (현재 페이지)."""
    out = []
    for s in GF.list_selects(visible_only=False):
        if s["name"] == "tmp_p01":
            for o in s["options"]:
                nd = norm_dims(o)
                if nd:
                    out.append((o, nd))
    return out


def legacy_qty_ints():
    """현재 활성 수량 select 의 정수 목록 [(int, 라벨)]."""
    qname = GF.active_qty_select()
    if not qname:
        return [], None
    opts = []
    for s in GF.list_selects(visible_only=True):
        if s["name"] == qname:
            for o in s["options"]:
                m = re.search(r"(\d+)", o)
                if m:
                    opts.append((int(m.group(1)), o))
    return opts, qname


def legacy_paper_labels():
    """현재 활성 용지 select 옵션 라벨."""
    pname = GF.active_paper_select()
    if not pname:
        return [], None
    for s in GF.list_selects(visible_only=True):
        if s["name"] == pname:
            return [o for o in s["options"] if o and "선택" not in o and "---" not in o], pname
    return [], pname


def pick_common_qty(legacy_qtys, target=100):
    """공통 수량: 예전 목록 중 target 있으면 그것, 없으면 target 이하 최대(없으면 최대)."""
    ints = sorted(q for q, _ in legacy_qtys)
    if not ints:
        return None
    if target in ints:
        return target
    le = [q for q in ints if q <= target]
    return le[-1] if le else ints[-1]


def retest(prd_cd, sim):
    """한 상품 조건일치 재검사. dict 반환."""
    lp = SB.live_product(prd_cd)
    nm = lp[1] if lp else prd_cd
    pc, conf = PR.pcode_for(prd_cd)
    row = {"prd_cd": prd_cd, "prd_nm": nm, "pcode": pc or "", "verdict": "",
           "size": "", "qty": "", "paper": "",
           "engine": "", "eng_print": "", "eng_paper": "", "eng_pansu": "",
           "golden": "", "diff": "", "pct": "", "note": ""}
    if not pc:
        row["verdict"] = "no-pcode"
        row["note"] = conf
        return row

    meta = sim.sim_meta(prd_cd)
    e_sizes = engine_size_opts(meta)
    e_mats = engine_mat_opts(meta)
    e_popt = first_popt(meta)
    frm = (meta.get("frm") or {}).get("frm_cd")
    proc = SB.base_print_proc(frm)

    # 예전사이트 사이즈 읽기 → 공통 크기 선택
    GF.goto(pc)
    l_sizes = legacy_size_opts()
    l_norms = {nd for _, nd in l_sizes}
    common = next((e for e in e_sizes if e[2] in l_norms), None)
    if not common:
        row["verdict"] = "공통크기없음"
        row["note"] = (f"엔진{[e[2] for e in e_sizes]} vs 예전{sorted(l_norms)}")
        return row
    e_label, e_sizcd, nd = common
    l_label = next(lbl for lbl, n in l_sizes if n == nd)

    # 예전사이트: 그 크기 선택 → 용지·수량 활성
    GF.native_select("tmp_p01", l_label)
    import time
    time.sleep(GF.ACTIVATE_WAIT)
    l_papers, _ = legacy_paper_labels()
    l_qtys, _ = legacy_qty_ints()

    # 공통 용지: 엔진 자재 라벨이 예전 용지 목록에 있는 것(우선 첫 매칭)
    paper = None
    mat_cd = None
    def _sq(x):
        return re.sub(r"\s+", "", x)
    for lbl, mc in e_mats:
        hit = next((p for p in l_papers
                    if _sq(lbl) in _sq(p) or _sq(p) in _sq(lbl)), None)
        if hit:
            paper, mat_cd = hit, mc
            break
    if paper is None:
        # 공통 용지 못 찾으면 예전 첫 용지 + 엔진 첫 자재(불완전 매칭 신호)
        paper = l_papers[0] if l_papers else None
        mat_cd = e_mats[0][1] if e_mats else None

    # 공통 수량
    qty = pick_common_qty(l_qtys, target=100) if l_qtys else 100

    # 엔진 계산(공통 크기·자재·수량) — 전 필수 FK 차원(묶음수 bdl_qty 등) 주입(견적0 방지)
    sel = {}
    for d in meta.get("prod_dims", []):
        if d.get("kind") == "fk" and d.get("name") != "siz_cd" and d.get("options"):
            sel[d["name"]] = d["options"][0]["v"]
    sel["siz_cd"] = e_sizcd
    if mat_cd:
        sel["mat_cd"] = mat_cd
    if e_popt:
        sel["print_opt_cd"] = e_popt
    eng = None
    pansu = None
    eng_paper_sub = eng_print_sub = None
    try:
        r = sim.simulate(prd_cd, sel, qty, procs=[{"proc_cd": proc}] if proc else None)
        eng = H.price_of(r)
        for c in r.get("base", {}).get("components", []):
            if c.get("pansu") is not None:
                pansu = c["pansu"]
            cn = c.get("comp_nm") or ""
            if "인쇄" in cn:
                eng_print_sub = c.get("subtotal")
            elif "용지" in cn:
                eng_paper_sub = c.get("subtotal")
    except Exception as e:
        row["verdict"] = "엔진오류"
        row["note"] = str(e)[:120]
        return row

    # 예전사이트 골든(동일 크기·용지·수량)
    g = GF.fetch_golden(pc, size=l_label, paper=paper, print_side="단면", qty=qty)
    golden = g.get("supply")
    picked = g.get("picked", {})
    # 조건 일치 확인(폴백 감지)
    pg_size = norm_dims(picked.get("size"))
    pg_qty = None
    mq = re.search(r"(\d+)", str(picked.get("qty") or ""))
    if mq:
        pg_qty = int(mq.group(1))
    matched = (pg_size == nd) and (pg_qty == qty)

    row.update({
        "size": f"{nd}", "qty": qty, "paper": paper or "",
        "engine": eng, "eng_print": eng_print_sub, "eng_paper": eng_paper_sub,
        "eng_pansu": pansu, "golden": golden,
    })
    if golden is None:
        row["verdict"] = "정답없음"
        row["note"] = g.get("note", "")
    elif not matched:
        row["verdict"] = "조건불일치(비교불가)"
        row["note"] = (f"예전 실제선택 크기={picked.get('size')} 수량={picked.get('qty')} "
                       f"(요청 {nd}/{qty})")
    else:
        diff = (eng - golden) if (eng and golden) else None
        pct = round(100 * diff / golden, 1) if (diff and golden) else None
        row["diff"] = diff
        row["pct"] = pct
        tol = 0
        row["verdict"] = "맞음" if (diff is not None and abs(diff) <= tol) else "차이있음"
    return row


def main():
    H.load_env()
    sim = H.HuniSim()
    targets = sys.argv[1:] or ["PRD_000016", "PRD_000017", "PRD_000018", "PRD_000019"]
    print(f"{'='*70}\n조건일치 PR 재검사  대상={len(targets)}\n{'='*70}")
    rows = []
    for prd in targets:
        row = retest(prd, sim)
        rows.append(row)
        print(f"\n[{row['prd_cd']}] {row['prd_nm']}  판정={row['verdict']}")
        print(f"  조건: 크기={row['size']} 수량={row['qty']} 용지={row['paper']}")
        print(f"  엔진={row['engine']} (인쇄={row['eng_print']} 용지={row['eng_paper']} 판수={row['eng_pansu']})"
              f"  예전정답={row['golden']}  차이={row['diff']} ({row['pct']}%)")
        if row["note"]:
            print(f"  메모: {row['note']}")
    cols = ["prd_cd", "prd_nm", "pcode", "verdict", "size", "qty", "paper",
            "engine", "eng_print", "eng_paper", "eng_pansu", "golden", "diff", "pct", "note"]
    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction="ignore")
        w.writeheader()
        w.writerows(rows)
    print(f"\n결과 → {OUT} ({len(rows)}행)")


if __name__ == "__main__":
    main()
