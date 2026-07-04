"""OptionCpqRmd — 옵션 파라미터 연결 끊김(저청구) 교정.

분류(값 날조 금지):
  HIGH(옵션선택형 param 미공급) → **needs_authority**: 옵션 dtl_opt 에 채울 값(예 타공수)은
       그 옵션이 나타내는 실제 값 = 실무진 지식. AI 날조 금지 → worklist(형제 dtl_opt 패턴 제시).
  REVIEW(수치입력 가능성) → **review**: 고객 수치입력 경로(개수/줄수)일 수 있어 오탐 검토.
"""
from __future__ import annotations
from collections import defaultdict

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class OptionCpqRmd(Remediator):
    dimension = "option_cpq"
    title = "옵션 파라미터 연결 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        high = [d for d in mine if d.severity == "high"]
        review = [d for d in mine if d.severity != "high"]

        out: list[Fix] = []
        # HIGH: proc 별로 묶어 실무진 지시
        by_proc: dict[str, list[Defect]] = defaultdict(list)
        for d in high:
            by_proc[d.evidence.get("proc_nm", "?")].append(d)
        for pn, ds in sorted(by_proc.items()):
            prods = sorted({d.prd_cd for d in ds if d.prd_cd})
            opts = sorted({d.comp_cd for d in ds if d.comp_cd})
            params = sorted({d.evidence.get("missing_param") for d in ds})
            note = (f"'{pn}' 옵션 {len(opts)}개가 파라미터({', '.join(params)}) dtl_opt 미공급 → 저청구. "
                    f"각 옵션이 나타내는 실제 값을 **실무진 확인** 후 dtl_opt 채움(형제 옵션 dtl_opt 패턴 "
                    f"참조·값 날조 금지). 상품 {len(prods)}개: {', '.join(prods)} · 옵션: {', '.join(opts)}")
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"옵션 dtl_opt 파라미터 채움 필요(저청구·{pn}) — 실무진 확인",
                defects=[d.key() for d in ds], root_comps=opts, worklist_note=note,
            ))
        if review:
            params = sorted({d.evidence.get("missing_param") for d in review})
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"옵션 파라미터 미공급 검토(수치입력 가능성) — {len(review)}건",
                defects=[d.key() for d in review],
                worklist_note=(f"파라미터({', '.join(params)})가 옵션 dtl_opt 가 아닌 고객 수치입력 경로일 "
                               f"가능성(형제 옵션 미공급). 수치입력 확정이면 결함 아님 → 수동 판정."),
            ))
        return out
