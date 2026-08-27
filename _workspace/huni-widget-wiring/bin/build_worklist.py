#!/usr/bin/env python3
"""build_worklist.py — 교정 라우팅 worklist 재산출기 (SPEC-PRICEWIRE-001 M0-3).

[배경] 기존 `out/worklist.csv`(1,431행)를 만든 생성기가 저장소에 없다(결함 L).
역공학으로 분류 규칙과 소스 매핑은 확보했으나 note 생성 규칙 34~59건과
내부 중복 338건의 유래는 생성기 없이 규명 불가로 확정됐다.

[HARD] 따라서 이 스크립트는 기존 파일의 바이트 재현을 목표하지 않는다.
아래 규칙을 **명시 선언**하고 그 규칙대로 새로 산출한다 — 이후부터 재현 가능하다.
기존 산출과의 delta 는 --compare 로 뽑아 원장에 기록한다.

[HARD] 값 날조 0 · LLM 판독 0 · 결정론. 단가값은 권위(엑셀/실무진)에서만 온다.
이 스크립트는 진단 라우팅만 만들며 DB 에 쓰지 않는다.

실행:
  python3 bin/build_worklist.py                      # 재산출 → out/worklist.csv
  python3 bin/build_worklist.py --compare <기존.csv>  # 기존본 대비 delta 리포트
"""
from __future__ import annotations

import argparse
import collections
import csv
import json
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve()
WS = HERE.parent.parent
DEFECTS = WS / "out" / "defects"

# ─────────────────────────────────────────────────────────────────────
# 선언 1 — 소스 매핑 (역공학 실측으로 확정. 8개 edge 가 기존본과 정확히 일치했다)
#   price-defects 의 dimension 은 worklist edge 로 변환된다.
# ─────────────────────────────────────────────────────────────────────
DIM_TO_EDGE = {
    "contribution": "E4",      # 공정 오배선/무료화
    "price_grid": "E4",        # 가격격자 결함(dim_missing/missing_cell)
    "calcability": "E4",       # 계산불가(PRICED-0-STRUCT)
    "wiring": "E4",            # 빈배선/고아 구성요소
    "dim_conformance": "E3",   # 차원 누락
    "qty_rule": "Q1",          # 수량 함정
    "option_cpq": "W5",        # 옵션 파라미터 연결 끊김
}

# ─────────────────────────────────────────────────────────────────────
# 선언 2 — 라우팅 분류 규칙
#   needs_authority : 권위(엑셀/실무진) 단가값이 있어야 닫힌다
#   needs_design    : 가격 설계 판단이 있어야 닫힌다
#   review          : 배선/정리 판단 — 권위값 불요
#   auto_data       : 결정론 교정 대상. 값 날조 없이 자동 생성 가능한 건만.
#                     현재 규칙에서 해당 없음(0건) — 전부 판단 작업이다.
# ─────────────────────────────────────────────────────────────────────
# [HARD] needs_authority 는 **권위 단가값만 있으면 닫히는 것**으로 좁게 유지한다.
#   `UNCOVERED_PROCESS`(상품이 공정을 제공하나 가격 comp 자체가 없음)는 여기 넣지
#   않는다 — comp 를 만들지 여부(그 공정을 유료화할 것인가)가 권위 단가 조회보다
#   앞서는 설계 판단이기 때문이다. 기존 산출본도 이를 review 로 두었고, 넓히면
#   needs_authority 가 143행/73상품 부풀어 잔량 계상이 왜곡된다(실측).
CODE_AUTHORITY = {"ZERO_FINAL", "PRICE_MISSING", "UNCOVERED"}
CODE_DESIGN = {"NO_SOURCE", "NO_FORMULA", "MISSING_DIM", "ANCHOR_MISSING"}
EDGE_DESIGN = {"E1", "S1"}

# 코드 토큰이 없는 문장형에서 needs_authority 를 가르는 표지.
#   기존본 실측: E4 문장형 381건이 이 계열, 379건이 PROC_MISMATCH(=review)였다.
AUTHORITY_PHRASES = (
    "단가가 등록되지 않아",     # PRICE_GAP — 해당 조합 단가 미등록
    "최종가 0원",               # ZERO_FINAL 서술형
    "단가행에 없음",            # 차원 값 미적재
    "단가/구성 확인필요",       # 빈배선 — 실무진 확인
)

CLASS_ORDER = ["auto_data", "needs_authority", "needs_design", "review"]


def leading_code(note: str) -> str | None:
    """note 선두의 대문자 코드 토큰. 없으면 None(문장형)."""
    m = re.match(r"([A-Z][A-Z_]{3,})", note.strip())
    return m.group(1) if m else None


def embedded_code(note: str) -> str | None:
    """괄호 안에 박힌 코드. 예: '공정 무료화(UNCOVERED_PROCESS): ...'"""
    m = re.search(r"\(([A-Z][A-Z_]{3,})[·)]", note)
    return m.group(1) if m else None


def classify(edge: str, note: str) -> str:
    """(edge, note) → remediation_class. 결정론."""
    codes = {c for c in (leading_code(note), embedded_code(note)) if c}
    if codes & CODE_AUTHORITY:
        return "needs_authority"
    if codes & CODE_DESIGN:
        return "needs_design"
    if codes:
        # 식별된 코드가 위 두 집합에 없으면 배선/정리 판단
        return "review"
    # 문장형
    if any(p in note for p in AUTHORITY_PHRASES):
        return "needs_authority"
    if edge in EDGE_DESIGN:
        return "needs_design"
    return "review"


def load_flat(path: pathlib.Path, edge_of) -> list[dict]:
    """1행=1결함 형식(widget/price/g1)."""
    out = []
    if not path.exists():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        r = json.loads(line)
        edge = edge_of(r)
        if edge is None:
            continue
        out.append({"prd_cd": r.get("prd_cd"), "edge": edge,
                    "note": (r.get("summary") or "").strip(),
                    "_src": path.name})
    return out


def lensb_note(d: dict) -> str:
    """lens-b defect → note.

    [HARD] 조합 정보(selection + qty)를 note 에 실어야 한다. 렌즈 B 결함은
    '어느 조합에서 0원인가'가 본체이며, detail 만 쓰면 서로 다른 조합이
    같은 문장으로 뭉개져 dedup 에 흡수된다(교정 대상을 잃는다).
    기존 산출본의 형식을 승계한다:
        ZERO_FINAL mat_cd=MAT_000082|print_opt_cd=POPT_000002|siz_cd=SIZ_000012|qty=1

    [차이 · 의도적] 기존본은 selection 키를 일부만 실었다(`plt_siz_cd` 누락).
    판형 사이즈는 가격을 가르는 축이므로(판형=종이류·판걸이수) 조합 식별자에서
    빼면 서로 다른 조합이 한 건으로 뭉개진다. 여기서는 selection 전체 키를
    정렬해 싣는다 — 그 결과 기존 대비 ZERO_FINAL 이 42행 늘어난다(실측).
    """
    code = (d.get("code") or "").strip()
    sel = d.get("selection") or {}
    parts = [f"{k}={sel[k]}" for k in sorted(sel)]
    if d.get("qty") is not None:
        parts.append(f"qty={d['qty']}")
    combo = "|".join(parts)
    if code and combo:
        return f"{code} {combo}"
    if code:
        return f"{code} {(d.get('detail') or '').strip()}".strip()
    return (d.get("detail") or "").strip()


def load_nested(path: pathlib.Path) -> list[dict]:
    """1행=1상품, defects[] 중첩 형식(lens-b)."""
    out = []
    if not path.exists():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        r = json.loads(line)
        for d in r.get("defects", []):
            out.append({"prd_cd": r.get("prd_cd"), "edge": d.get("edge"),
                        "note": lensb_note(d), "_src": path.name})
    return out


def collect(prd_names: dict) -> list[dict]:
    recs = []
    recs += load_flat(DEFECTS / "widget-defects.jsonl",
                      lambda r: str(r.get("dimension")) if r.get("dimension") else None)
    recs += load_flat(DEFECTS / "price-defects.jsonl",
                      lambda r: DIM_TO_EDGE.get(r.get("dimension")))
    recs += load_flat(DEFECTS / "g1-defects.jsonl", lambda r: "G1")
    recs += load_nested(DEFECTS / "lens-b-defects.jsonl")

    # [HARD] dedup: 같은 상품의 같은 (edge, note) 는 한 건이다.
    #   기존본은 중복 338건을 안고 있었으나, 같은 결함을 여러 번 세면
    #   잔량 계상이 부풀어 종료 판정이 왜곡된다.
    seen = set()
    out = []
    for r in recs:
        if not r["prd_cd"] or not r["edge"]:
            continue
        key = (r["prd_cd"], r["edge"], r["note"])
        if key in seen:
            continue
        seen.add(key)
        r["prd_nm"] = prd_names.get(r["prd_cd"], "")
        r["remediation_class"] = classify(r["edge"], r["note"])
        out.append(r)
    out.sort(key=lambda r: (r["prd_cd"], r["edge"], r["note"]))
    return out


def load_prd_names() -> dict:
    """상품명은 기존 산출물에서 승계한다(라이브 재조회 불요·결정론)."""
    names = {}
    old = WS / "out" / "worklist.csv"
    if old.exists():
        for r in csv.DictReader(old.open(encoding="utf-8")):
            if r.get("prd_cd") and r.get("prd_nm"):
                names.setdefault(r["prd_cd"], r["prd_nm"])
    for p in (DEFECTS / "lens-b-defects.jsonl",):
        if not p.exists():
            continue
        for line in p.read_text(encoding="utf-8").splitlines():
            if line.strip():
                r = json.loads(line)
                if r.get("prd_cd") and r.get("prd_nm"):
                    names.setdefault(r["prd_cd"], r["prd_nm"])
    return names


def write_csv(rows: list[dict], path: pathlib.Path) -> None:
    with path.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["prd_cd", "prd_nm", "edge", "remediation_class", "note"])
        for r in rows:
            w.writerow([r["prd_cd"], r["prd_nm"], r["edge"],
                        r["remediation_class"], r["note"]])


def summarize(rows: list[dict]) -> None:
    cc = collections.Counter(r["remediation_class"] for r in rows)
    ec = collections.Counter(r["edge"] for r in rows)
    sc = collections.Counter(r["_src"] for r in rows)
    print(f"총 {len(rows)}행 / {len(set(r['prd_cd'] for r in rows))}상품")
    print("\n라우팅 클래스:")
    for c in CLASS_ORDER:
        print(f"  {c:16s} {cc[c]:>5d}")
    print("\nedge:")
    for k, v in sorted(ec.items()):
        print(f"  {k:6s} {v:>5d}")
    print("\n소스 기여(dedup 후):")
    for k, v in sorted(sc.items(), key=lambda x: -x[1]):
        print(f"  {k:34s} {v:>5d}")
    na = [r for r in rows if r["remediation_class"] == "needs_authority"]
    if na:
        print(f"\nneeds_authority {len(na)}행 / {len(set(r['prd_cd'] for r in na))}상품")
        for k, v in collections.Counter(r["edge"] for r in na).most_common():
            print(f"  {k:6s} {v:>5d}")


def compare(rows: list[dict], old_path: pathlib.Path) -> None:
    old = list(csv.DictReader(old_path.open(encoding="utf-8")))
    print(f"\n=== 기존본 대비 delta ({old_path.name}) ===")
    print(f"기존 {len(old)}행 → 신규 {len(rows)}행 ({len(rows)-len(old):+d})")
    co = collections.Counter(r["remediation_class"] for r in old)
    cn = collections.Counter(r["remediation_class"] for r in rows)
    print(f"\n{'class':16s} {'기존':>7s} {'신규':>7s} {'증감':>7s}")
    for c in CLASS_ORDER:
        print(f"{c:16s} {co[c]:>7d} {cn[c]:>7d} {cn[c]-co[c]:>+7d}")
    ko = {(r["prd_cd"], r["edge"], r["note"]) for r in old}
    kn = {(r["prd_cd"], r["edge"], r["note"]) for r in rows}
    print(f"\n키 교집합 {len(ko & kn)} · 기존에만 {len(ko - kn)} · 신규에만 {len(kn - ko)}")
    po = {r["prd_cd"] for r in old if r["remediation_class"] == "needs_authority"}
    pn = {r["prd_cd"] for r in rows if r["remediation_class"] == "needs_authority"}
    print(f"needs_authority 상품: 기존 {len(po)} → 신규 {len(pn)} "
          f"(해소 {len(po - pn)} · 신규 {len(pn - po)})")
    if pn - po:
        print(f"  신규 편입: {sorted(pn - po)}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(WS / "out" / "worklist.csv"))
    ap.add_argument("--compare", help="기존 worklist.csv 경로(delta 리포트)")
    args = ap.parse_args()

    rows = collect(load_prd_names())
    summarize(rows)
    if args.compare:
        compare(rows, pathlib.Path(args.compare))
    out = pathlib.Path(args.out)
    write_csv(rows, out)
    print(f"\n-> {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
