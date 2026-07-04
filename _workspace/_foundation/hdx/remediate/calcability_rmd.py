"""CalcabilityRmd — 계산가능성(PRICED-0) 교정 생성.

분류(값 날조 금지):
  wired comp 가 placeholder(PENDING/TBD) → **blocked_human**: 실무진 단가·구성 입력 대기
       (WiringRmd 와 같은 근본원인 = root_comps 로 plan 이 dedup).
  그 외(wired 있으나 base 단가행 부재/공식 미완) → **needs_design**: §18 가격설계 필요.
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix
from .wiring_rmd import _is_placeholder


class CalcabilityRmd(Remediator):
    dimension = "calcability"
    title = "계산가능성 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        comp_nm = {r["comp_cd"]: r.get("comp_nm", "")
                   for r in snap.table("t_prc_price_components") if r.get("comp_cd")}

        out: list[Fix] = []
        blocked: list[Defect] = []
        design: list[Defect] = []
        blocked_comps: set[str] = set()
        for d in mine:
            wired = d.evidence.get("wired") or []
            ph_hit = [c for c in wired if _is_placeholder(c, comp_nm.get(c, ""))]
            if ph_hit:
                blocked.append(d)
                blocked_comps.update(ph_hit)
            else:
                design.append(d)

        if blocked:
            prods = sorted({d.prd_cd for d in blocked if d.prd_cd})
            note = (f"placeholder 구성요소({', '.join(sorted(blocked_comps))})만 배선된 상품 {len(prods)}개 "
                    f"= PRICE 반드시 0. **실무진 단가·구성 입력** 필요(배선/계산가능성 결함과 동일 근본원인). "
                    f"상품: {', '.join(prods)}")
            out.append(Fix(
                dimension=self.dimension, remediation_class="blocked_human",
                title=f"실무진 단가·구성 입력 대기(계산불가 상품 {len(prods)}개)",
                defects=[d.key() for d in blocked], root_comps=sorted(blocked_comps),
                worklist_note=note,
            ))
        if design:
            prods = sorted({d.prd_cd for d in design if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_design",
                title=f"가격설계 필요(§18) — 계산불가 상품 {len(prods)}개",
                defects=[d.key() for d in design], root_comps=[],
                worklist_note=("공식 바인딩 있으나 base 단가행 원천 부재 → §18 가격공식/구성요소 설계 후 "
                               "§7 적재. 상품: " + ', '.join(prods[:12])),
            ))
        return out
