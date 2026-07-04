"""ContributionDx — 공정 저청구(silent-0) 진단. 원본=`_foundation/batch/contribution_scan.py`.

승계: 원본의 순수 함수 `scan(prd_only=None, snap=snap_dir)` 를 그대로 호출(드리프트 0),
산출 리스트 → 공통 Defect 로 변환만. HIGH 신뢰만 blocking(원본 verdict 와 동일).

Defect 3종:
  UNCOVERED_PROCESS 상품이 손님에게 제공하는 공정을 어느 wired comp 도 가격 안 매김 → 무료(저청구)
  PROC_MISMATCH     코어 comp(인쇄/용지/제본)의 proc 단가행이 상품 공정과 교집합 0 → 오배선(저청구)
  ORPHAN_PROC_VALUE (전역) 단가행 proc 값을 어떤 상품도 안 바인딩 → 유령 가격코드
신뢰도 HIGH=blocking(돈크리티컬), REVIEW=advisory(선택형 옵션 오탐 가드). stop=HIGH 0.
"""
from __future__ import annotations
import sys
import pathlib

from .base import Diagnoser
from ..foundation import Snapshot, Defect

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "batch"))
import contribution_scan  # noqa: E402


class ContributionDx(Diagnoser):
    dimension = "contribution"
    title = "공정 저청구(silent-0)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        r = contribution_scan.scan(None, snap.dir)
        out: list[Defect] = []

        # uncovered: [prd, frm, proc_cd, proc_nm, conf, state]
        for prd, frm, pc, nm, conf, state in r.get("uncovered", []):
            high = conf == "HIGH"
            out.append(Defect(
                dimension=self.dimension,
                summary=f"공정 무료화({state}): 상품이 '{nm}' 공정 제공하나 가격 comp 없음",
                severity="high" if high else "low",
                money_impact="undercharge" if high else "unknown",
                prd_cd=prd, frm_cd=frm,
                evidence={"proc_cd": pc, "proc_nm": nm, "conf": conf, "state": state},
                suggested_fix="해당 공정을 가격 매기는 comp 배선/단가행 적재(또는 무료 공정이면 REVIEW 확정)",
            ))
        # mismatch: [prd, frm, comp_cd, comp_nm, procs, conf, kind]
        for prd, frm, c, nm, procs, conf, _kind in r.get("mismatch", []):
            high = conf == "HIGH"
            out.append(Defect(
                dimension=self.dimension,
                summary=f"공정 오배선(PROC_MISMATCH): 코어 comp '{nm}' proc 가 상품 공정과 교집합 0",
                severity="high" if high else "low",
                money_impact="undercharge" if high else "unknown",
                prd_cd=prd, frm_cd=frm, comp_cd=c,
                evidence={"comp_procs": procs, "conf": conf},
                suggested_fix="comp 단가행 proc_cd 를 상품 공정코드에 정렬(코드 이원화 해소)",
            ))
        # orphan_proc: [comp_cd, comp_nm, proc_cd, proc_nm, 'ORPHAN_PROC_VALUE']
        for c, nm, pc, pnm, _ in r.get("orphan_proc", []):
            out.append(Defect(
                dimension=self.dimension,
                summary=f"유령 가격코드(ORPHAN_PROC_VALUE): '{nm}' 단가행 proc '{pnm}' 를 어떤 상품도 안 바인딩",
                severity="medium", money_impact="unknown",
                comp_cd=c,
                evidence={"proc_cd": pc, "proc_nm": pnm},
                suggested_fix="상품 실코드로 단가행 proc 재바인딩 또는 죽은 단가행 정리",
            ))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # 원본 verdict: uncovered_HIGH + mismatch_HIGH == 0 (REVIEW·ORPHAN_PROC 는 advisory)
        return not any(d.dimension == self.dimension and d.severity == "high"
                       for d in defects)
