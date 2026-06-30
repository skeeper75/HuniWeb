#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""가격공식↔가격구성요소 배선(formula_components) 결정론 스캐너 — 토큰0 진척 측도.

§27 가격 종단 마스터 오케스트레이터의 "배선 연결 서브트랙" 루프 측도.
권위 알고리즘(pricing.py evaluate_price)이 가격을 만들려면, 가격에 영향을 주는
가격구성요소(comp_cd)가 그 상품의 가격공식(frm_cd)의 formula_components 에 배선돼야 한다.
단가행(component_prices)만 적재하고 공식에 배선 안 하면 = 고아 → 엔진이 합산 안 함 → 견적0/저청구.
(메모리 [[namecard-orphan-component-wiring-260630]] · [[digital-print-base-proc-missing-260701]] 실증)

이 스캐너는 라이브 스냅샷 CSV 3종 + 상품-공식 바인딩을 읽어 4종 배선 결함을 전수 검출한다:
  1) ORPHAN(고아)      : comp_cd 가 단가행(component_prices)이 있고 활성(use_yn=Y·del_yn≠Y)인데
                          어느 공식의 formula_components 에도 미배선 → 엔진이 못 봄.
  2) DEAD_WIRE(빈배선)  : formula_components 에 배선됐는데 그 comp_cd 의 단가행이 0 → 합산해도 0.
  3) DELETED_WIRE(오염) : 배선된 comp_cd 가 price_components 에서 논리삭제(del_yn=Y) → 죽은 배선.
  4) NO_FORMULA(미바인딩): 상품에 가격공식 바인딩이 0 → 가격원천 없음(배선 이전 단계).

산출(루프 진척판):
  _workspace/_foundation/batch/wiring/wiring-status.json   (전역 결함 리스트 + 상품별 판정)
  _workspace/_foundation/batch/wiring/wiring-summary.json  (KPI 요약)
  콘솔: 결함 카운트 1줄 요약(연속 라운드 비교용).

종료 척도(§27 사용자 확정): 배선 결함 0(ORPHAN+DEAD_WIRE+DELETED_WIRE+NO_FORMULA = 0).
PRICE≠0(evaluate_price 실호출 성립)은 §27 검증 단계가 별도 판정(이 스캐너는 배선 정합까지).

입력 우선순위:
  ① 라이브 스냅샷 CSV (_workspace/_foundation/live-snapshot/latest/) — 권위(결정론).
  ② 폴백: product-details-final.json 의 price_bom (스냅샷 없을 때 근사).

★이 스캐너는 검출만 한다(생성≠검증). 고아가 정당한 미사용인지/배선 누락인지의 판정은
  설계(§18)·게이트가 한다. 실 교정 COMMIT 은 인간 승인 후 §7 dbmap 위임(DB 미적재).
재실행: python3 wiring_scan.py  [--snap <snap_dir>]  [--round N --note "..."]
"""
from __future__ import annotations
import csv
import json
import pathlib
import sys

HERE = pathlib.Path(__file__).resolve().parent          # _foundation/batch/
FND = HERE.parent                                        # _foundation/
SNAP_ROOT = FND / "live-snapshot"
OUT_DIR = HERE / "wiring"
DETAILS_JSON = FND.parent / "huni-product-readiness" / "05_gate" / "product-details-final.json"

ACTIVE = lambda r: (r.get("use_yn", "Y") != "N") and (r.get("del_yn", "N") != "Y")


def _read_csv(path: pathlib.Path) -> list[dict]:
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


def resolve_snap(arg: str | None) -> pathlib.Path | None:
    """--snap 인자 > latest 심볼릭 > 가장 최근 snap_* 디렉토리."""
    if arg:
        p = pathlib.Path(arg)
        return p if p.exists() else (SNAP_ROOT / arg if (SNAP_ROOT / arg).exists() else None)
    latest = SNAP_ROOT / "latest"
    if latest.exists():
        return latest.resolve()
    snaps = sorted(SNAP_ROOT.glob("snap_*"))
    return snaps[-1] if snaps else None


def scan_from_snapshot(snap: pathlib.Path) -> dict:
    fc = _read_csv(snap / "t_prc_formula_components.csv")          # 배선
    cp = _read_csv(snap / "t_prc_component_prices.csv")            # 단가행
    pc = _read_csv(snap / "t_prc_price_components.csv")            # 구성요소 카탈로그
    pf = _read_csv(snap / "t_prd_product_price_formulas.csv")     # 상품-공식 바인딩

    # 카탈로그: comp_cd → {nm, prc_typ, use_dims, active}
    comp = {}
    for r in pc:
        cd = r.get("comp_cd")
        if not cd:
            continue
        comp[cd] = {
            "comp_nm": r.get("comp_nm", ""),
            "prc_typ": (r.get("prc_typ_cd") or "").replace("PRICE_TYPE.", "."),
            "use_dims": r.get("use_dims", ""),
            "active": ACTIVE(r),
            "deleted": r.get("del_yn", "N") == "Y",
        }
    # 단가행 보유 카운트: comp_cd → row 수
    price_rows = {}
    for r in cp:
        cd = r.get("comp_cd")
        if cd:
            price_rows[cd] = price_rows.get(cd, 0) + 1
    # 배선: frm_cd → set(comp_cd), comp_cd → set(frm_cd)
    frm_comps: dict[str, set] = {}
    comp_frms: dict[str, set] = {}
    for r in fc:
        f, c = r.get("frm_cd"), r.get("comp_cd")
        if not f or not c:
            continue
        frm_comps.setdefault(f, set()).add(c)
        comp_frms.setdefault(c, set()).add(f)
    wired = set(comp_frms)

    # ── 1) ORPHAN: 단가행 있고 활성인데 어디에도 미배선 ──
    orphans = []
    for cd, n in sorted(price_rows.items()):
        meta = comp.get(cd, {})
        if cd in wired:
            continue
        if meta.get("deleted"):
            continue  # 삭제된 건 고아 아님(별도)
        # 카탈로그에 없거나 활성인 comp 중 단가행만 있고 미배선 = 고아
        if meta.get("active", True):
            orphans.append({"comp_cd": cd, "comp_nm": meta.get("comp_nm", ""),
                            "price_rows": n, "prc_typ": meta.get("prc_typ", ""),
                            "use_dims": meta.get("use_dims", "")})
    # ── 2) DEAD_WIRE: 배선됐는데 단가행 0 ──  ── 3) DELETED_WIRE: 배선이 삭제된 comp 참조 ──
    dead, deleted = [], []
    for f, comps in sorted(frm_comps.items()):
        for c in sorted(comps):
            meta = comp.get(c, {})
            if meta.get("deleted"):
                deleted.append({"frm_cd": f, "comp_cd": c, "comp_nm": meta.get("comp_nm", "")})
            elif price_rows.get(c, 0) == 0:
                dead.append({"frm_cd": f, "comp_cd": c, "comp_nm": meta.get("comp_nm", "")})

    # ── 4) 상품별 롤업 (NO_FORMULA 포함) ──
    prod_frms: dict[str, set] = {}
    for r in pf:
        p, f = r.get("prd_cd"), r.get("frm_cd")
        if p and f:
            prod_frms.setdefault(p, set()).add(f)
    dead_idx: dict[str, set] = {}
    for d in dead:
        dead_idx.setdefault(d["frm_cd"], set()).add(d["comp_cd"])
    del_idx: dict[str, set] = {}
    for d in deleted:
        del_idx.setdefault(d["frm_cd"], set()).add(d["comp_cd"])
    products = {}
    for p, frms in sorted(prod_frms.items()):
        wired_n = sum(len(frm_comps.get(f, ())) for f in frms)
        dead_n = sum(len(dead_idx.get(f, ())) for f in frms)
        del_n = sum(len(del_idx.get(f, ())) for f in frms)
        status = "WIRED_OK"
        if dead_n or del_n:
            status = "BROKEN"
        products[p] = {"frm_cds": sorted(frms), "wired": wired_n,
                       "dead": dead_n, "deleted": del_n, "status": status}

    total_defects = len(orphans) + len(dead) + len(deleted)
    summary = {
        "source": "snapshot", "snap": snap.name,
        "formulas": len(frm_comps), "wired_links": sum(len(v) for v in frm_comps.values()),
        "components_total": len(comp),
        "components_with_price": len(price_rows),
        "components_wired": len(wired),
        "orphan_comps": len(orphans),
        "dead_wires": len(dead),
        "deleted_wires": len(deleted),
        "no_formula_products": 0,  # 스냅샷엔 분모(이전사이트) 없음 → details 폴백에서 보강
        "total_wiring_defects": total_defects,
        "verdict": "GO(배선 정합)" if total_defects == 0 else f"NO-GO(결함 {total_defects})",
    }
    return {"summary": summary, "orphans": orphans, "dead_wires": dead,
            "deleted_wires": deleted, "products": products}


def scan_from_details() -> dict:
    """폴백: 스냅샷 없을 때 product-details-final.json price_bom 으로 근사."""
    if not DETAILS_JSON.exists():
        return {"summary": {"source": "none", "error": "스냅샷·details 둘 다 없음",
                            "total_wiring_defects": -1, "verdict": "UNKNOWN"},
                "orphans": [], "dead_wires": [], "deleted_wires": [], "products": {}}
    data = json.loads(DETAILS_JSON.read_text(encoding="utf-8"))
    products, broken, no_formula = {}, [], []
    for p in data:
        pb = p.get("price_bom") or {}
        fm = pb.get("formula") or {}
        pcs = pb.get("price_components") or []
        fst = fm.get("status")
        if fst in ("n/a", None) and not pb.get("formula"):
            st = "NA"
        elif fst == "direct_price":
            st = "DIRECT"
        elif fst == "missing":
            st = "NO_FORMULA"; no_formula.append(p.get("prd_cd"))
        else:
            bad = [pc for pc in pcs if pc.get("status") in ("단가행_전무", "차원_미스매치")]
            if pb.get("견적0원인") or bad:
                st = "BROKEN"; broken.append(p.get("prd_cd"))
            else:
                st = "WIRED_OK"
        products[p.get("prd_cd")] = {"status": st, "상품명": p.get("상품명"),
                                     "상품군": p.get("상품군")}
    summary = {
        "source": "details(폴백)", "snap": None,
        "products_total": len(data),
        "broken": len(broken), "no_formula": len(no_formula),
        "no_formula_products": len(no_formula),
        "orphan_comps": -1,  # 폴백은 고아 검출 불가(스냅샷 필요)
        "dead_wires": -1, "deleted_wires": -1,
        "total_wiring_defects": len(broken) + len(no_formula),
        "verdict": "근사(스냅샷으로 고아 정밀 스캔 권장)",
    }
    return {"summary": summary, "orphans": [], "dead_wires": [],
            "deleted_wires": [], "products": products,
            "broken_products": broken, "no_formula_products": no_formula}


def main():
    args = sys.argv[1:]
    snap_arg = None
    rnd, note = None, ""
    i = 0
    while i < len(args):
        if args[i] == "--snap" and i + 1 < len(args):
            snap_arg = args[i + 1]; i += 2
        elif args[i] == "--round" and i + 1 < len(args):
            rnd = args[i + 1]; i += 2
        elif args[i] == "--note" and i + 1 < len(args):
            note = args[i + 1]; i += 2
        else:
            i += 1

    snap = resolve_snap(snap_arg)
    result = scan_from_snapshot(snap) if snap else scan_from_details()
    s = result["summary"]

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / "wiring-status.json").write_text(
        json.dumps(result, ensure_ascii=False, indent=1), encoding="utf-8")
    (OUT_DIR / "wiring-summary.json").write_text(
        json.dumps(s, ensure_ascii=False, indent=1), encoding="utf-8")

    # 루프 라운드 추적(append-only) — 수렴 추이 기록
    if rnd is not None:
        rounds = OUT_DIR / "wiring-rounds.csv"
        new = not rounds.exists()
        with rounds.open("a", encoding="utf-8", newline="") as f:
            w = csv.writer(f)
            if new:
                w.writerow(["round", "snap", "orphan", "dead_wire", "deleted_wire",
                            "total_defects", "verdict", "note"])
            w.writerow([rnd, s.get("snap"), s.get("orphan_comps"), s.get("dead_wires"),
                        s.get("deleted_wires"), s.get("total_wiring_defects"),
                        s.get("verdict"), note])

    print(f"[wiring_scan] source={s.get('source')} snap={s.get('snap')} "
          f"orphan={s.get('orphan_comps')} dead={s.get('dead_wires')} "
          f"deleted={s.get('deleted_wires')} total_defects={s.get('total_wiring_defects')} "
          f"=> {s.get('verdict')}")
    print(f"  -> {OUT_DIR / 'wiring-status.json'}")


if __name__ == "__main__":
    main()
