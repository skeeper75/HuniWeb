"""ContributionRmd — 공정 저청구(silent-0) 교정 생성.

분류(값 날조 금지):
  UNCOVERED_PROCESS·PROC_MISMATCH(HIGH) → **needs_design**: 상품이 제공하는 공정을 가격 매기는
       구성요소·단가행 설계 필요(§18). 단가값 날조 금지 → worklist.
  ORPHAN_PROC_VALUE·저신뢰 → **review**: 죽은 단가행 정리/오탐 검토.
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class ContributionRmd(Remediator):
    dimension = "contribution"
    title = "공정 저청구 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        design = [d for d in mine if d.severity == "high"]
        review = [d for d in mine if d.severity != "high"]

        out: list[Fix] = []
        if design:
            prods = sorted({d.prd_cd for d in design if d.prd_cd})
            procs = sorted({d.evidence.get("proc_nm", "") for d in design if d.evidence.get("proc_nm")})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_design",
                title=f"공정 가격설계 필요(§18) — 저청구 상품 {len(prods)}개",
                defects=[d.key() for d in design],
                worklist_note=(f"상품이 손님에게 제공하는 공정이 무료화(저청구). 공정별 가격 구성요소·단가행을 "
                               f"§18 설계 후 §7 적재(단가 날조 금지). 공정 예: {', '.join(p for p in procs[:10] if p)}. "
                               f"상품 {len(prods)}개: {', '.join(prods[:12])}{' …' if len(prods) > 12 else ''}"),
            ))
        if review:
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"공정 커버리지 검토(저신뢰·유령코드) — {len(review)}건",
                defects=[d.key() for d in review],
                worklist_note=("REVIEW 신뢰도(선택형 옵션 오탐 가능)·ORPHAN_PROC_VALUE(죽은 단가행). "
                               "무료 공정 확정 또는 단가행 proc 재바인딩/정리 수동 판정."),
            ))
        return out
