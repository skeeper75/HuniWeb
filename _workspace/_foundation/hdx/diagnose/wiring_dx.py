"""WiringDx — 배선(formula_components) 결함 진단. 원본=`_foundation/batch/wiring_scan.py`.

승계(search-before-mint): 원본의 검증된 순수 함수 `scan_from_snapshot(snap_dir)` 를 그대로
호출(드리프트 0)하고 산출 dict → 공통 Defect 로 변환만 한다. 알고리즘 재구현 없음.

결함 4종 중 스냅샷 기반 3종을 Defect 화:
  ORPHAN       단가행 있고 활성인데 어느 공식에도 미배선 → 엔진이 못 봄(저청구)
  DEAD_WIRE    배선됐는데 단가행 0 → 합산해도 0(저청구)
  DELETED_WIRE 배선된 comp 가 논리삭제 → 죽은 배선(저청구)
(NO_FORMULA 는 이전사이트 분모가 필요 → 원본 details 폴백 전용. 스냅샷 스캔 범위 밖·CalcabilityDx 가 보완.)
LEGIT_UNUSED(게이트 '미배선이 정답' 판정)는 결함 아님 → 제외(원본과 동일).
"""
from __future__ import annotations
import sys
import pathlib

from .base import Diagnoser
from ..foundation import Snapshot, Defect

# 원본 스캐너 import (search-before-mint: 검증된 로직 재사용)
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "batch"))
import wiring_scan  # noqa: E402


class WiringDx(Diagnoser):
    dimension = "wiring"
    title = "배선(formula_components)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        r = wiring_scan.scan_from_snapshot(snap.dir)
        out: list[Defect] = []

        for o in r.get("orphans", []):
            out.append(Defect(
                dimension=self.dimension,
                summary=f"고아 구성요소(단가행 {o['price_rows']}행 있으나 미배선): {o['comp_nm']}",
                severity="high", money_impact="undercharge",
                comp_cd=o["comp_cd"],
                evidence={"price_rows": o["price_rows"], "prc_typ": o.get("prc_typ", ""),
                          "use_dims": o.get("use_dims", "")},
                suggested_fix="공식(frm) formula_components 에 배선(정당 미사용이면 orphan-classification 등록)",
            ))
        for d in r.get("dead_wires", []):
            out.append(Defect(
                dimension=self.dimension,
                summary=f"빈배선(배선됐으나 단가행 0): {d['comp_nm']}",
                severity="high", money_impact="undercharge",
                comp_cd=d["comp_cd"], frm_cd=d["frm_cd"],
                suggested_fix="단가행(component_prices) 적재 또는 배선 제거",
            ))
        for d in r.get("deleted_wires", []):
            out.append(Defect(
                dimension=self.dimension,
                summary=f"오염 배선(배선된 comp 논리삭제됨): {d['comp_nm']}",
                severity="high", money_impact="undercharge",
                comp_cd=d["comp_cd"], frm_cd=d["frm_cd"],
                suggested_fix="죽은 배선 제거(formula_components 행 삭제)",
            ))
        return out
