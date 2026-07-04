#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""linkage 스코프 셀프테스트 — 양방향 연결 무결성 진단·교정 회귀 가드(라이브 읽기전용).

검증:
  [1] LinkageDx 스모크 — linkage 차원·에지 메타(edge/dir) 유효·dir 이 에지 접미사와 일치
  [2] 양방향 실증 — 역방향(E1R/E2R) 검출이 독립 재계산과 일치(정방향만으론 못 잡는 단절)
  [3] E3/E4 재사용 정합 — DimConformanceDx UNDECLARED→E3·MISSING→E4 로 무손실 변환
  [4] LinkageRmd 전건 라우팅 — Σ Fix.defects == 진단 결함 총수(누락 0)
  [5] 값 날조 금지 — auto_data 만 fix_sql 보유·worklist(needs_authority/blocked_human)는 SQL 없음
  [6] 안전 재연결만 auto — auto_data 는 전부 E3(use_dims·가격중립)만
재실행: python3 _workspace/_foundation/hdx/linkage_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))  # _foundation/
from hdx.foundation import Snapshot, Defect
from hdx.diagnose import LinkageDx
from hdx.diagnose.dim_conformance_dx import DimConformanceDx
from hdx.diagnose.linkage_dx import EDGE_LABEL
from hdx.remediate import LinkageRmd


def main():
    snap = Snapshot()
    dx = LinkageDx()
    ds = dx.scan(snap)
    print(f"[0] LinkageDx: 총 연결단절 {len(ds)}건")

    # [1] 스모크 — 차원·에지 메타 유효
    assert all(isinstance(d, Defect) and d.dimension == "linkage" for d in ds), "비-linkage Defect"
    for d in ds:
        e = d.evidence.get("edge")
        assert e in EDGE_LABEL, f"미상 에지: {e}"
        exp = "reverse" if e.endswith("R") else "forward"
        assert d.evidence.get("dir") == exp, f"dir 불일치: {e}→{d.evidence.get('dir')}"
    from collections import Counter
    per_edge = dict(Counter(d.evidence["edge"] for d in ds))
    print(f"[1] 에지 메타 OK — {per_edge}")

    # [2] 양방향 실증 — E1R(공식→상품 역방향 단절) 독립 재계산 일치
    ppf = [r for r in snap.table("t_prd_product_price_formulas") if r.get("prd_cd") and r.get("frm_cd")]
    fc = [r for r in snap.table("t_prc_formula_components") if r.get("frm_cd") and r.get("comp_cd")]
    frm_in_ppf = {r["frm_cd"] for r in ppf}
    frm_has_comp = {r["frm_cd"] for r in fc}
    frm_active = {r["frm_cd"] for r in snap.table("t_prc_price_formulas")
                  if r.get("frm_cd") and (r.get("use_yn", "Y") != "N")}
    expect_e1r = {f for f in frm_active if f not in frm_in_ppf and f in frm_has_comp}
    got_e1r = {d.frm_cd for d in ds if d.evidence["edge"] == "E1R"}
    assert got_e1r == expect_e1r, f"E1R 역방향 불일치: got {got_e1r} vs expect {expect_e1r}"
    print(f"[2] 양방향 실증 OK — E1R 역방향 단절 {len(got_e1r)}건(정방향만으론 못 잡음)·독립 재계산 일치")

    # [3] E3/E4 재사용 정합 — DimConformanceDx 카운트와 일치
    dc = DimConformanceDx().scan(snap)
    dc_undeclared = sum(1 for d in dc if "UNDECLARED" in d.summary)
    dc_missing = sum(1 for d in dc if "MISSING" in d.summary)
    e3 = sum(1 for d in ds if d.evidence["edge"] == "E3")
    e4 = sum(1 for d in ds if d.evidence["edge"] == "E4")
    assert e3 == dc_undeclared, f"E3 재사용 드리프트: {e3} vs {dc_undeclared}"
    assert e4 == dc_missing, f"E4 재사용 드리프트: {e4} vs {dc_missing}"
    print(f"[3] E3/E4 재사용 정합 OK — E3={e3}(=UNDECLARED) · E4={e4}(=MISSING) 드리프트 0")

    # [4] 전건 라우팅 — Σ Fix.defects == 진단 총수
    fixes = LinkageRmd().generate(ds, snap)
    routed = sum(len(f.defects) for f in fixes)
    assert routed == len(ds), f"라우팅 누락: {routed} vs {len(ds)}"
    print(f"[4] 전건 라우팅 OK — {len(fixes)} Fix / {routed} 결함(=진단 {len(ds)}·누락 0)")

    # [5] 값 날조 금지 — worklist 는 SQL 없음, auto_data 만 fix_sql
    for f in fixes:
        if f.remediation_class == "auto_data":
            assert f.fix_sql and f.dryrun_sql and f.undo_sql, f"auto_data SQL 누락: {f.title}"
        elif f.remediation_class in ("needs_authority", "blocked_human"):
            assert not f.fix_sql, f"worklist 인데 fix_sql 존재(값 날조 위험): {f.title}"
    print("[5] 값 날조 금지 OK — worklist(권위/실무진)는 SQL 미생성·auto_data 만 SQL")

    # [6] 안전 재연결만 auto — auto_data 는 전부 E3(use_dims·가격중립)
    autos = [f for f in fixes if f.remediation_class == "auto_data"]
    for f in autos:
        assert f.mutation.get("set", {}).get("use_dims") is not None, \
            f"auto_data 인데 use_dims 재연결 아님(가격중립 위반 위험): {f.title}"
    print(f"[6] 안전 재연결만 auto OK — auto_data {len(autos)}건 전부 use_dims 정합(가격중립·P4 검증대상)")

    print("SELFTEST OK — hdx linkage(양방향 검출·재사용 정합·전건 라우팅·값 날조 금지·안전 재연결)")


if __name__ == "__main__":
    main()
