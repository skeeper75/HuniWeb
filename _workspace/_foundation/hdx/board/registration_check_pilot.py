# -*- coding: utf-8 -*-
"""상품 등록 매핑 점검표 — 엑셀 의도 대조 파일럿(아크릴 그룹).

★목적(지니 260704): 실무진이 webadmin 에서 상품을 등록하며 익히는 중 — 상품↔구성요소가
제대로 매핑됐는지 확인. 권위 엑셀(실무진 본인이 만든 상품마스터)을 '의도'로, 라이브 DB 를 '실제
등록'으로 보고 상품별 대조. 내부 정합만으론 못 잡는 갭(예: 아크릴키링 고리 저청구)을 엑셀 대조로 포착.

[HARD] 라이브 읽기전용 스냅샷. 엑셀=권위(날조 0). 파일럿=아크릴 → 검증 후 전 시트 확장.
재실행: python3 _workspace/_foundation/hdx/board/registration_check_pilot.py
"""
from __future__ import annotations
import csv, sys, pathlib
import openpyxl

ROOT = pathlib.Path("/Users/innojini/Dev/HuniWeb")
SNAP = ROOT / "_workspace/_foundation/live-snapshot/latest"
XLSX = ROOT / "docs/huni/후니프린팅_상품마스터_260703.xlsx"


def load(t):
    p = SNAP / f"{t}.csv"
    return list(csv.DictReader(open(p, encoding="utf-8"))) if p.exists() else []


# ── 엑셀 의도 파서(아크릴 시트) ─────────────────────────────────────────
def parse_acryl_intent():
    """아크릴 시트 → {상품명: {sizes, material, ring_opts:{옵션명:가격}, chain_opts:{...}}}."""
    wb = openpyxl.load_workbook(XLSX, read_only=True, data_only=True)
    ws = wb["아크릴"]
    rows = list(ws.iter_rows(values_only=True))
    wb.close()
    products = {}
    cur = None
    for r in rows[2:]:  # 0-1 = 헤더
        g = lambda i: (str(r[i]).strip() if i < len(r) and r[i] is not None and str(r[i]).strip() else "")
        pid, nm = g(1), g(3)
        if pid and nm:  # 새 상품 블록 시작
            cur = nm
            products[cur] = {"sizes": set(), "material": g(17),
                             "ring_opts": {}, "chain_opts": {}}
        if cur is None:
            continue
        p = products[cur]
        if g(4):  # 사이즈
            p["sizes"].add(g(4))
        if g(20):  # 고리 옵션(col20) + 가격(col21)
            p["ring_opts"][g(20)] = g(21)
        if g(22):  # 추가상품 볼체인(col22) + 가격(col23)
            p["chain_opts"][g(22)] = g(23)
    return products


# ── DB 등록 상태 ────────────────────────────────────────────────────────
def db_state():
    prods = load("t_prd_products")
    nm2cd = {r["prd_nm"]: r["prd_cd"] for r in prods if r.get("prd_nm")}
    popts = [r for r in load("t_prd_product_options") if r.get("del_yn", "N") != "Y"]
    psizes = [r for r in load("t_prd_product_sizes") if r.get("del_yn", "N") != "Y"]
    cp = load("t_prc_component_prices")
    price_optcds = set(r["opt_cd"] for r in cp if r.get("opt_cd"))
    return nm2cd, popts, psizes, price_optcds


# ── 상품별 대조 ─────────────────────────────────────────────────────────
def check():
    intent = parse_acryl_intent()
    nm2cd, popts, psizes, price_optcds = db_state()
    results = []
    for nm, exp in sorted(intent.items()):
        prd = nm2cd.get(nm)
        gaps = []
        if not prd:
            results.append((nm, "미등록", ["엑셀엔 있으나 DB 미등록 상품"]))
            continue
        myopts = [r for r in popts if r["prd_cd"] == prd]
        # 유료 옵션(엑셀에 0 아닌 가격) → DB 옵션에 있고 가격경로 있나
        paid = {}
        for src in ("ring_opts", "chain_opts"):
            for onm, price in exp[src].items():
                pv = price.replace(",", "")
                # 유료 판정: 숫자>0 또는 '*가격표참고'(=유료)
                is_paid = ("가격표참고" in price) or (pv.replace(".", "").isdigit() and float(pv or 0) > 0)
                if is_paid and "선택안함" not in onm and "없음" not in onm:
                    paid[onm] = price
        # DB 옵션명 매칭 + 가격경로(opt_cd 가 단가행에 있나)
        db_opt_names = {r.get("opt_nm", ""): r for r in myopts}
        for onm, price in paid.items():
            # 이름 부분매칭(볼체인(오렌지)→'구슬줄' 등 완전일치 어려움 → 키워드)
            matched = [r for k, r in db_opt_names.items()
                       if any(w in k for w in [onm[:2]]) or onm[:2] in k]
            if not matched:
                gaps.append(f"[유료옵션 미등록] '{onm}'({price}) — 엑셀 유료인데 DB 옵션 없음")
            else:
                # 가격경로: 매칭 옵션 opt_cd 가 단가행에 있나
                connected = any(r["opt_cd"] in price_optcds for r in matched)
                if not connected:
                    gaps.append(f"[가격경로 끊김] '{onm}'({price}) — DB 옵션 있으나 단가행 연결 없음 → 0원 청구")
        status = "✅ 완료" if not gaps else ("🔴 저청구/누락" if any("가격" in g or "미등록" in g for g in gaps) else "🟡 확인")
        results.append((nm, status, gaps))
    return results


def main():
    print("=" * 70)
    print("상품 등록 매핑 점검표 — 아크릴 (엑셀 의도 260703 ↔ DB 등록 대조)")
    print("=" * 70)
    res = check()
    ok = sum(1 for _, s, _ in res if s.startswith("✅"))
    for nm, status, gaps in res:
        print(f"\n■ {nm}  {status}")
        for g in gaps:
            print(f"    {g}")
    print("\n" + "=" * 70)
    print(f"아크릴 {len(res)}상품 中 매핑 완료 {ok} · 갭 {len(res) - ok}")


if __name__ == "__main__":
    main()
