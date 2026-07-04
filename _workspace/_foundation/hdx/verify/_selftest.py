#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify(P4) 셀프테스트 — 적대적 재실측 정합·실질성(라이브 읽기전용·in-memory).

★자기완결형: 라이브에 특정 결함이 존재하는지에 의존하지 않는다(교정 적재로 결함이 사라지면
파일럿 auto_data 가 0이 될 수 있으므로). 합성 Fix 로 verify_fix 로직을 직접 가드한다.

검증:
  [1] 재실측 실질성: measure_comp 이 실제 단가를 매칭(전부 None 아님 = 허수 아님)
  [2] use_dims 변경 = 가격중립(engine 이 use_dims 무관 하드코딩 매칭) → price_neutral=True
  [3] 음성 대조(NEGATIVE CONTROL): 단가행 unit_price 변경 → price_neutral=False·NO-GO
       → 검증기가 GO/NO-GO 를 실제 구별함 증명(항상-GO 버그 배제)
  [4] worklist Fix(mutation 없음)는 SKIP(verifiable=False)
재실행: python3 _workspace/_foundation/hdx/verify/_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))  # _foundation/
from hdx.foundation import Snapshot, Fix
from hdx.verify import golden, verify_fix

# 안정적 파일럿 comp(단가행 3행·dim_vals 없음·명확 매칭)
COMP = "COMP_POSTER_CANVAS_HANGING"


def main():
    snap = Snapshot()

    # [1] 재실측 실질성
    meas = golden.measure_comp(snap, COMP)
    priced = [p for p, e in meas.values() if p is not None]
    assert priced, f"{COMP} 재실측이 단가 0매칭 — 허수 검증(GO 무의미)"
    print(f"[1] 재실측 실질성 OK ({COMP}: {len(priced)}개 실단가 매칭 예 {priced[:3]})")

    # [2] use_dims 변경 = 가격중립 (합성 auto_data Fix)
    fix_ud = Fix(dimension="dim_conformance", remediation_class="auto_data",
                 title="[셀프테스트] use_dims 변경 가격중립",
                 defects=[],
                 mutation={"table": "t_prc_price_components", "key": {"comp_cd": COMP},
                           "set": {"use_dims": ["siz_width", "siz_height", "min_qty", "siz_cd"]}})
    v = verify_fix(fix_ud)
    assert v.verifiable and v.price_neutral, f"use_dims 변경이 가격중립 아님: {v.notes}"
    assert not v.new_defects, f"use_dims 변경이 새 결함 유발: {v.new_defects[:2]}"
    print(f"[2] use_dims 가격중립 OK (price_neutral·무회귀·{v.notes})")

    # [3] 음성 대조: unit_price 변경 → 가격중립 아님·NO-GO
    prow = [r for r in snap.table("t_prc_component_prices") if r["comp_cd"] == COMP][0]
    bad = Fix(dimension="_neg", remediation_class="auto_data", title="[음성대조] 단가 변조",
              defects=[], mutation={"table": "t_prc_component_prices",
                                    "key": {"comp_price_id": prow["comp_price_id"]},
                                    "set": {"unit_price": "99999.99"}})
    vneg = verify_fix(bad)
    assert vneg.verifiable and not vneg.price_neutral, "음성 대조 실패 — 단가변경을 가격중립으로 오판(항상-GO 버그)"
    assert not vneg.go, "음성 대조: 단가변경인데 GO(치명 버그)"
    print(f"[3] 음성 대조 OK (단가 변조 → 가격중립 아님·NO-GO·deltas={len(vneg.price_deltas)})")

    # [4] worklist(mutation 없음)는 SKIP
    wl = Fix(dimension="dim_conformance", remediation_class="needs_authority",
             title="[셀프테스트] 권위값 대기", defects=[], worklist_note="...")
    vw = verify_fix(wl)
    assert not vw.verifiable, "worklist 인데 verifiable(값 날조 대상 재실측 시도)"
    print("[4] worklist SKIP OK (mutation 없음)")

    print("SELFTEST OK — hdx.verify P4 정합")


if __name__ == "__main__":
    main()
