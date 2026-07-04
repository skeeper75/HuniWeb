#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify(P4) 셀프테스트 — 적대적 재실측 정합·실질성 검증(라이브 읽기전용·in-memory).

검증:
  [1] 재실측 실질성: measure_comp 이 실제 단가를 매칭(전부 None 아님 = 허수 GO 아님)
  [2] auto_data 파일럿 GO: use_dims 교정 = 가격중립·결함해소·무회귀
  [3] 음성 대조(NEGATIVE CONTROL): 단가행 unit_price 를 바꾸는 mutation 은 가격중립 아님
       → 검증기가 NO-GO 를 낼 수 있음 증명(항상-GO 버그 배제)
  [4] worklist Fix 는 SKIP(verifiable=False)
재실행: python3 _workspace/_foundation/hdx/verify/_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))  # _foundation/
from hdx.foundation import Snapshot, Fix
from hdx.diagnose import PRICE_DIAGNOSERS
from hdx.remediate import PRICE_REMEDIATORS, plan
from hdx.verify import golden, verify_fix
from hdx.verify.overlay import MutableSnapshot


def main():
    snap = Snapshot()
    defects = []
    for dx in PRICE_DIAGNOSERS:
        defects.extend(dx.scan(snap))
    pres = plan.run(PRICE_REMEDIATORS, defects, snap)
    autos = [f for f in pres.by_class.get("auto_data", []) if f.mutation]
    assert autos, "auto_data(mutation 보유) 교정본 없음 — 파일럿 검증 불가"
    fix = autos[0]
    comp = fix.mutation["key"]["comp_cd"]

    # [1] 재실측 실질성
    meas = golden.measure_comp(snap, comp)
    priced = [p for p, e in meas.values() if p is not None]
    assert priced, f"{comp} 재실측이 단가 0매칭 — 허수 검증(GO 무의미)"
    print(f"[1] 재실측 실질성 OK ({comp}: {len(priced)}개 실단가 매칭 예 {priced[:3]})")

    # [2] auto_data 파일럿 GO
    v = verify_fix(fix)
    assert v.verifiable and v.go, f"파일럿 GO 실패: {v.notes}"
    assert v.price_neutral and v.defects_closed == v.target_defects and not v.new_defects
    print(f"[2] auto_data 파일럿 GO OK ({v.fix_title[:50]} · {v.notes})")

    # [3] 음성 대조: unit_price 변경 mutation 은 가격중립 아님
    over = MutableSnapshot(None)
    prow = [r for r in snap.table("t_prc_component_prices") if r["comp_cd"] == comp][0]
    pid = prow["comp_price_id"]
    bad = Fix(dimension="_neg", remediation_class="auto_data", title="[음성대조] 단가 변조",
              defects=[], mutation={"table": "t_prc_component_prices",
                                    "key": {"comp_price_id": pid},
                                    "set": {"unit_price": "99999.99"}})
    vneg = verify_fix(bad)
    assert vneg.verifiable and not vneg.price_neutral, "음성 대조 실패 — 단가변경을 가격중립으로 오판(항상-GO 버그)"
    assert not vneg.go, "음성 대조: 단가변경인데 GO(치명 버그)"
    print(f"[3] 음성 대조 OK (단가 변조 → 가격중립 아님·NO-GO · deltas={len(vneg.price_deltas)})")

    # [4] worklist 는 SKIP
    wl = next((f for c in ("blocked_human", "needs_authority", "needs_design", "review")
               for f in pres.by_class.get(c, [])), None)
    if wl:
        vw = verify_fix(wl)
        assert not vw.verifiable, "worklist 인데 verifiable(값 날조 대상 재실측 시도)"
        print(f"[4] worklist SKIP OK ({wl.remediation_class})")

    print("SELFTEST OK — hdx.verify P4 정합")


if __name__ == "__main__":
    main()
