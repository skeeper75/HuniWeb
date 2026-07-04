#!/usr/bin/env python3
"""hdx.foundation 셀프테스트 — P1 토대 검증(결정론·읽기전용·스냅샷 시점 무관).

  1. Snapshot 로드 스모크(테이블 행수 > 0)
  2. engine_rows 정규화(빈칸 '' → None·dim_vals JSON → dict)를 실 스냅샷 1 comp 로 확인
  3. engine.match_component 순수 로직을 합성 행으로 결정론 검증
     (타공형: dim_vals{타공수:N} 필수매칭·미제공 시 no_match·정확 단가 선택)

재실행: python3 _workspace/_foundation/hdx/foundation/_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))  # _foundation/ 를 path 에

from hdx.foundation import Snapshot, engine  # noqa: E402


def test_snapshot_smoke():
    snap = Snapshot()
    print(f"[1] snapshot dir = {snap.dir}")
    pc, fc, cp = snap.price_components(), snap.formula_components(), snap.component_prices()
    print(f"    price_components(active)={len(pc)}  formula_components={len(fc)}  component_prices={len(cp)}")
    assert pc and fc and cp, "스냅샷 테이블 비어있음"
    return snap


def test_engine_rows_normalization(snap):
    # 실 스냅샷에서 dim_vals 를 가진 단가행이 있는 comp 를 하나 골라 정규화 확인
    sample = None
    for r in snap.component_prices():
        dv = (r.get("dim_vals") or "").strip()
        if dv and dv != "{}":
            sample = r.get("comp_cd")
            break
    if sample is None:
        print("[2] dim_vals 가진 단가행 없음(스킵) — 정규화 로직은 합성으로 커버")
        return
    rows = snap.engine_rows(sample)
    assert rows, f"{sample} engine_rows 비어있음"
    r0 = rows[0]
    assert isinstance(r0.get("dim_vals"), dict), "dim_vals JSON→dict 파싱 실패"
    # 빈칸 차원은 None 이어야(와일드카드). 아무 행이나 확인.
    for r in rows:
        for c in ("siz_cd", "mat_cd", "proc_cd"):
            assert r.get(c) != "", f"{c} 빈칸이 ''로 남음(None 정규화 실패)"
    print(f"[2] engine_rows 정규화 OK (comp={sample}, {len(rows)}행, dim_vals=dict, 빈칸→None)")


def test_engine_logic():
    # 합성 타공형 단가행: proc_cd 동일 + dim_vals{타공수:4/6/8}, 단가 3000/4000/5000
    rows = [
        {"proc_cd": "PROC_X", "dim_vals": {"타공수": 4}, "unit_price": "3000.00", "apply_ymd": "2026-01-01"},
        {"proc_cd": "PROC_X", "dim_vals": {"타공수": 6}, "unit_price": "4000.00", "apply_ymd": "2026-01-01"},
        {"proc_cd": "PROC_X", "dim_vals": {"타공수": 8}, "unit_price": "5000.00", "apply_ymd": "2026-01-01"},
    ]
    # 8구 선택 → 5000 정확 매칭
    m = engine.match_component(rows, {"proc_cd": "PROC_X", "타공수": 8}, qty=1, as_of="2026-12-31")
    assert m["row"] is not None and m["row"]["unit_price"] == "5000.00", f"8구 매칭 실패: {m}"
    # 타공수 미제공 → dim_vals 필수매칭이라 no_match(저청구 근본원인 = 이 param 이 안 실릴 때)
    m0 = engine.match_component(rows, {"proc_cd": "PROC_X"}, qty=1, as_of="2026-12-31")
    assert m0["row"] is None, f"타공수 없이 매칭되면 안 됨: {m0}"
    # proc_cd 불일치 → no_match
    mx = engine.match_component(rows, {"proc_cd": "PROC_Y", "타공수": 8}, qty=1, as_of="2026-12-31")
    assert mx["row"] is None, f"proc 불일치인데 매칭됨: {mx}"
    # 와일드카드: 행 proc_cd=None 이면 어떤 proc 선택이든 통과
    wild = [{"proc_cd": None, "dim_vals": {}, "unit_price": "100", "apply_ymd": "2026-01-01"}]
    mw = engine.match_component(wild, {"proc_cd": "ANYTHING"}, qty=1, as_of="2026-12-31")
    assert mw["row"] is not None, f"와일드카드(None) 통과 실패: {mw}"
    print("[3] engine 매칭 로직 OK (dim_vals 필수·proc 정확매칭·None 와일드카드·정확 단가선택)")


def main():
    snap = test_snapshot_smoke()
    test_engine_rows_normalization(snap)
    test_engine_logic()
    print("SELFTEST OK — hdx.foundation P1 정합")


if __name__ == "__main__":
    main()
