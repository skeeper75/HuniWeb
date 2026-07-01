#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""공정 커버리지 스캐너 — silent-0(과소청구) 전수 진단. §27 배선 서브트랙 F층.

wiring_scan.py(정적 배선 존재)·dim_conformance.py(차원 선언/충전)가 GO여도,
"상품이 손님에게 고르게 하는 공정(product_processes)을 어느 가격구성요소도 가격
매기지 않는" silent-0(과소청구)는 못 잡았다 — 캘린더 트윈링제본(상품 proc=PROC_000021
인데 제본 단가행은 PROC_000099)·디지털 인쇄비(단가행 proc=PROC_000004를 상품 미바인딩)가
정확히 이 사각지대였다.

★신호 설계(오탐 회피): "배선+단가행 있는데 미매칭"으로 잡으면 코팅·별색 같은 *선택형
옵션 비목*을 오탐한다(선택 안 하면 0이 정상). 대신 **상품 자신이 바인딩한 공정**을
의도 신호로 쓴다 — 상품이 그 공정을 손님에게 제공한다면 가격이 매겨져야 한다.

판정(결정론·스냅샷만·토큰0·인증불요):
  UNCOVERED_PROCESS : 상품이 바인딩한 공정(proc_cd)을 그 상품 공식의 어느 wired 구성요소도
                      가격행(component_prices.proc_cd)에 안 가짐 → 손님 선택 가능한데 무료 🔴
  PROC_MISMATCH     : wired 구성요소가 proc_cd 가격행을 갖는데 그 proc 중 어느 것도 상품이
                      바인딩 안 함(comp_procs ∩ product_procs = ∅) → 죽은 단가행/오배선 🔴
  ORPHAN_PROC_VALUE : (전역) 단가행 proc_cd 값을 어떤 상품도 product_processes에 안 가짐
                      → 고아 단가행(예 PROC_000099 벽걸이캘린더제본)

신뢰도: 공정명이 가격성(제본·인쇄·용지·코팅·박·타공·커팅·접지·형압)=HIGH,
        비가격성(포장·수축·검수 등)=REVIEW(무료 공정일 수 있어 검토).

[HARD] 라이브 스냅샷 읽기만(DB·시뮬 호출 0). 교정은 인간 승인 후 §7 dbmap.
재실행: python3 contribution_scan.py [prd_cd] [--snap <dir>] [--round N --note ...]
"""
from __future__ import annotations
import csv
import json
import pathlib
import sys

HERE = pathlib.Path(__file__).resolve().parent
FND = HERE.parent
SNAP_ROOT = FND / "live-snapshot"
OUT_DIR = HERE / "wiring"

NOTDEL = lambda r: r.get("del_yn", "N") != "Y"
PRICED_KW = ("제본", "인쇄", "용지", "코팅", "박", "타공", "커팅", "접지", "형압",
             "오시", "미싱", "귀돌", "라미", "재단", "후가공")
FREE_KW = ("포장", "수축", "검수", "디자인", "파일", "교정쇄")


def _read_csv(path):
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def resolve_snap(arg):
    if arg:
        p = pathlib.Path(arg)
        if p.exists():
            return p
        return SNAP_ROOT / arg if (SNAP_ROOT / arg).exists() else None
    latest = SNAP_ROOT / "latest"
    if latest.exists():
        return latest.resolve()
    snaps = sorted(SNAP_ROOT.glob("snap_*"))
    return snaps[-1] if snaps else None


def conf_of(proc_nm):
    if any(k in proc_nm for k in PRICED_KW):
        return "HIGH"
    if any(k in proc_nm for k in FREE_KW):
        return "REVIEW"
    return "REVIEW"


def scan(prd_only=None, snap=None):
    pf = _read_csv(snap / "t_prd_product_price_formulas.csv")
    fc = _read_csv(snap / "t_prc_formula_components.csv")
    cp = _read_csv(snap / "t_prc_component_prices.csv")
    pcs = _read_csv(snap / "t_prc_price_components.csv")
    pp = _read_csv(snap / "t_prd_product_processes.csv")
    proc_tbl = _read_csv(snap / "t_proc_processes.csv")
    sets = _read_csv(snap / "t_prd_product_sets.csv")

    proc_nm = {r["proc_cd"]: r.get("proc_nm", "") for r in proc_tbl if r.get("proc_cd")}
    comp_meta = {r["comp_cd"]: r for r in pcs if r.get("comp_cd")}
    comp_del = {c for c, m in comp_meta.items() if m.get("del_yn") == "Y"}

    # 구성요소 → 가격행이 가진 proc_cd 값 집합
    comp_procs: dict[str, set] = {}
    for r in cp:
        c, pc = r.get("comp_cd"), r.get("proc_cd")
        if c and pc:
            comp_procs.setdefault(c, set()).add(pc)

    # 공식 → wired 구성요소
    frm_comps: dict[str, list] = {}
    for r in fc:
        f, c = r.get("frm_cd"), r.get("comp_cd")
        if f and c:
            frm_comps.setdefault(f, []).append(c)

    # 상품 → 공식(첫 바인딩)
    prod_frm: dict[str, str] = {}
    for r in pf:
        p, f = r.get("prd_cd"), r.get("frm_cd")
        if p and f:
            prod_frm.setdefault(p, f)

    # 상품 → 바인딩 공정(활성)
    prod_procs: dict[str, set] = {}
    for r in pp:
        p, pc = r.get("prd_cd"), r.get("proc_cd")
        if p and pc and NOTDEL(r):
            prod_procs.setdefault(p, set()).add(pc)

    set_parents = {r["prd_cd"] for r in sets if r.get("prd_cd") and NOTDEL(r)}

    # 전역: 어떤 상품이든 바인딩한 공정 전체(고아 판정용)
    all_bound_procs = set()
    for s in prod_procs.values():
        all_bound_procs |= s

    # ── ORPHAN_PROC_VALUE (전역) 선계산: 단가행 proc 값을 어떤 상품도 안 바인딩 ──
    # 죽은 proc-keyed 단가행 = "유령 가격코드". UNCOVERED 공정이 이것과 같은 작업(키워드)
    # 으로 짝지으면 = 코드 이원화 확정(상품은 실코드 바인딩·가격은 유령코드) → HIGH.
    orphan_proc = []
    seen = set()
    for c, procs in comp_procs.items():
        if c in comp_del:
            continue
        for pc in procs:
            if pc not in all_bound_procs and (c, pc) not in seen:
                seen.add((c, pc))
                orphan_proc.append([c, comp_meta.get(c, {}).get("comp_nm", ""),
                                    pc, proc_nm.get(pc, ""), "ORPHAN_PROC_VALUE"])
    # 고아 단가행이 표현하는 작업 키워드(이원화 확정 기준)
    orphan_ops = {k for _, _, _, onm, _ in orphan_proc for k in PRICED_KW if k in onm}

    targets = [prd_only] if prd_only else sorted(prod_frm)
    uncovered, mismatch, set_skipped = [], [], []

    for prd in targets:
        frm = prod_frm.get(prd)
        if not frm:
            continue
        if prd in set_parents:
            set_skipped.append(prd)
            continue
        wired = [c for c in frm_comps.get(frm, []) if c not in comp_del]
        # 이 상품 공식의 wired 구성요소들이 커버하는 proc 값 집합(가격행 보유분)
        covered = set()
        for c in wired:
            covered |= comp_procs.get(c, set())
        # ★완제품가 가드: 공식에 완제품가(PRC_COMPONENT_TYPE.06) 비목이 있으면 소재+출력+가공이
        #   통가격에 포함 → 개별 공정 proc-coverage 무관(가공은 baked). UNCOVERED 오탐 방지.
        allin = any(comp_meta.get(c, {}).get("comp_typ_cd") == "PRC_COMPONENT_TYPE.06"
                    for c in wired)

        pprocs = prod_procs.get(prd, set())
        # (1) UNCOVERED_PROCESS: 상품 공정인데 어느 wired comp 도 가격 안 매김
        for pc in sorted(pprocs):
            if pc not in covered:
                nm = proc_nm.get(pc, "")
                # HIGH = 같은 작업의 유령(고아) proc-단가행 존재 = 코드 이원화 확정
                #        (상품 실코드 바인딩 ↔ 가격 유령코드). 그 외(박/라미=면적·옵션 차원,
                #        완제품가 baked)는 proc-coverage 무관 → REVIEW(후보).
                dual = any(k in nm for k in PRICED_KW if k in orphan_ops)
                conf = "HIGH" if (dual and not allin) else "REVIEW"
                state = "UNCOVERED_BAKED" if allin else "UNCOVERED_PROCESS"
                uncovered.append([prd, frm, pc, nm, conf, state])
        # (2) PROC_MISMATCH: wired comp 의 proc 가격행이 상품 공정과 교집합 0
        for c in wired:
            cps = comp_procs.get(c, set())
            if not cps:
                continue
            if not (cps & pprocs):
                nm = comp_meta.get(c, {}).get("comp_nm", "")
                # 코어(디지털인쇄비·용지비·제본비)가 상품 proc 와 교집합 0 = 돈크리티컬.
                # 별색/형광 등 선택형 인쇄 add-on 은 product_processes 아닌 옵션 경로라 제외(REVIEW).
                core = ("디지털인쇄" in nm) or ("용지" in nm) or ("제본" in nm)
                optional = any(k in nm for k in ("별색", "형광", "금색", "은색", "화이트",
                                                 "클리어", "핑크", "에폭시"))
                conf = "HIGH" if (core and not optional) else "REVIEW"
                mismatch.append([prd, frm, c, nm, ";".join(sorted(cps))[:60], conf,
                                 "PROC_MISMATCH"])

    # ORPHAN_PROC_VALUE 는 위에서 선계산됨(orphan_proc).
    unc_hi = sum(1 for r in uncovered if r[4] == "HIGH")
    mis_hi = sum(1 for r in mismatch if r[5] == "HIGH")
    summary = {
        "snap": snap.name, "products_scanned": len({r[0] for r in uncovered} | {r[0] for r in mismatch}),
        "bound_products": len([p for p in prod_frm if p not in set_parents]),
        "set_skipped": len(set_skipped),
        "uncovered_process": len(uncovered), "uncovered_HIGH": unc_hi,
        "proc_mismatch": len(mismatch), "mismatch_HIGH": mis_hi,
        "orphan_proc_value": len(orphan_proc),
        "verdict": "GO(공정 커버리지 정합)" if (unc_hi + mis_hi) == 0
                   else f"NO-GO(UNCOVERED-HIGH {unc_hi}·MISMATCH-HIGH {mis_hi})",
    }
    return {"summary": summary, "uncovered": uncovered, "mismatch": mismatch,
            "orphan_proc": orphan_proc, "set_skipped": set_skipped}


def main():
    args = sys.argv[1:]
    prd_only, snap_arg, rnd, note = None, None, None, ""
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--snap" and i + 1 < len(args):
            snap_arg = args[i + 1]; i += 2
        elif a == "--round" and i + 1 < len(args):
            rnd = args[i + 1]; i += 2
        elif a == "--note" and i + 1 < len(args):
            note = args[i + 1]; i += 2
        elif not a.startswith("--"):
            prd_only = a; i += 1
        else:
            i += 1

    snap = resolve_snap(snap_arg)
    if not snap:
        sys.exit("스냅샷 없음")
    r = scan(prd_only, snap)
    s = r["summary"]

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with (OUT_DIR / "contribution-defects.csv").open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["kind", "prd_cd", "frm_cd", "code", "name", "extra", "conf"])
        for d in r["uncovered"]:
            w.writerow(["UNCOVERED_PROCESS", d[0], d[1], d[2], d[3], "", d[4]])
        for d in r["mismatch"]:
            w.writerow(["PROC_MISMATCH", d[0], d[1], d[2], d[3], d[4], d[5]])
        for d in r["orphan_proc"]:
            w.writerow(["ORPHAN_PROC_VALUE", "", "", d[0], d[1], d[2] + "/" + d[3], "GLOBAL"])
    (OUT_DIR / "contribution-summary.json").write_text(
        json.dumps(r, ensure_ascii=False, indent=1), encoding="utf-8")

    if rnd is not None:
        rounds = OUT_DIR / "contribution-rounds.csv"
        new = not rounds.exists()
        with rounds.open("a", encoding="utf-8", newline="") as f:
            w = csv.writer(f)
            if new:
                w.writerow(["round", "snap", "uncovered_HIGH", "mismatch_HIGH",
                            "orphan_proc", "verdict", "note"])
            w.writerow([rnd, s["snap"], s["uncovered_HIGH"], s["mismatch_HIGH"],
                        s["orphan_proc_value"], s["verdict"], note])

    print(f"[contribution_scan] snap={s['snap']} bound={s['bound_products']} "
          f"set_skip={s['set_skipped']} UNCOVERED={s['uncovered_process']}(HIGH {s['uncovered_HIGH']}) "
          f"MISMATCH={s['proc_mismatch']}(HIGH {s['mismatch_HIGH']}) "
          f"ORPHAN_PROC={s['orphan_proc_value']} => {s['verdict']}")
    print(f"  -> {OUT_DIR / 'contribution-defects.csv'}")


if __name__ == "__main__":
    main()
