"""QtyRuleRmd — 수량규칙 함정 교정.

분류(값 날조 금지): TRAP_MIN/NO_RULES → **needs_authority**(올바른 min_qty 는 권위=가격표 구간
하한/실무진 확인·memory qty-system-audit min=max(권위,가격표구간)). INFO_MAX → **review**(초대량 검토).
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class QtyRuleRmd(Remediator):
    dimension = "qty_rule"
    title = "수량규칙 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        trap = [d for d in mine if d.severity == "high"]
        info = [d for d in mine if d.severity != "high"]

        out: list[Fix] = []
        if trap:
            prods = sorted({d.prd_cd for d in trap if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"수량 함정 교정 필요(min_qty 미달·저청구) — {len(prods)}개 상품",
                defects=[d.key() for d in trap], root_comps=[],
                worklist_note=(f"상품 최소수량이 가격구간 하한보다 작아 구간 아래 주문 시 무료(저청구). "
                               f"올바른 min_qty = max(권위 수량규칙, 가격표 구간 하한) — **실무진/권위 확인** "
                               f"(값 날조 금지). 상품 {len(prods)}개: {', '.join(prods[:12])}"
                               f"{' …' if len(prods) > 12 else ''}"),
            ))
        if info:
            prods = sorted({d.prd_cd for d in info if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"초대량 수량 검토(INFO_MAX) — {len(prods)}개 상품",
                defects=[d.key() for d in info],
                worklist_note=("max_qty 가 최대 가격구간의 10배 초과 — 초대량 구간 단가 별도 견적 필요 여부 검토."),
            ))
        return out
