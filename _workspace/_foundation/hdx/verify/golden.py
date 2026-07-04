"""엔진 골든 재실측 — 한 구성요소(comp)의 단가를 pricing.py verbatim 로직으로 재계산(P4 코어).

승계: `foundation/engine.py`(pricing.py match_component verbatim). 생성기(Remediator)와 다른 코드경로로
독립 재계산 → 교정 전/후 단가 동일성(허용오차 0)을 배치가 스스로 검증(생성≠검증).

대표 선택 도출: comp 의 각 단가행 자신의 차원값을 그 행을 겨냥한 선택으로 사용(자기 정합).
한 comp 의 기여만 재실측 — use_dims 같은 comp-국소 변경의 가격중립성은 그 comp 매칭 불변으로 충분.
"""
from __future__ import annotations

from ..foundation import Snapshot, engine

# 먼 미래 as_of — apply_ymd 필터 통과(최신 단가행 채택)
AS_OF = "2999-12-31"


def _selkey(sel: dict, qty) -> str:
    return "|".join(f"{k}={sel[k]}" for k in sorted(sel)) + f"|qty={qty}"


def representative_selections(rows: list[dict]):
    """각 단가행 → 그 행을 겨냥하는 (selection, qty)."""
    out = []
    for r in rows:
        sel = {d: r.get(d) for d in engine.NON_QTY_DIMS if r.get(d) is not None}
        for k, v in (r.get("dim_vals") or {}).items():
            sel[k] = v
        # 수량: 이 행의 min_qty 이상(구간 하한 충족). width/height 는 선택에 이미 포함되면 tier 매칭됨.
        try:
            qty = int(float(r.get("min_qty"))) if r.get("min_qty") not in (None, "") else 1
        except Exception:
            qty = 1
        if qty < 1:
            qty = 1
        # 비규격(siz_width/height) tier 상한 매칭용 — 행 자신값을 선택에 실어 정확 매칭
        for d in ("siz_width", "siz_height"):
            if r.get(d) not in (None, ""):
                sel[d] = r.get(d)
        out.append((sel, qty))
    return out


def measure_comp(snap: Snapshot, comp_cd: str) -> dict:
    """comp 의 대표 선택별 매칭 단가(재실측). 반환 {selkey: (unit_price, error)}."""
    rows = snap.engine_rows(comp_cd)
    out = {}
    for sel, qty in representative_selections(rows):
        m = engine.match_component(rows, sel, qty, AS_OF)
        row = m.get("row")
        price = row.get("unit_price") if row else None
        out[_selkey(sel, qty)] = (price, m.get("error"))
    return out


def diff_prices(before: dict, after: dict) -> list[dict]:
    """교정 전/후 단가 차이 목록(빈=가격중립)."""
    deltas = []
    for k in sorted(set(before) | set(after)):
        b = before.get(k)
        a = after.get(k)
        if b != a:
            deltas.append({"selection": k, "before": b, "after": a})
    return deltas
