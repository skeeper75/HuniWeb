"""PriceGridRmd — 가격격자(19시트) 결함 교정 라우팅. §26 트랙 위임.

분류(값 날조 금지): 가격격자 교정값은 권위 엑셀(가격표 260527)에서 오고 실 적재는 §26/§7 dbmap 이 한다.
  missing_cell/dim_missing/mismatch/transpose(HIGH) → **needs_authority**(권위값 적재/조사·§26 트랙)
  매핑 미상·prc_typ_typo·sparse(그 외) → **review**(사람 확인·매퍼 추가)
"""
from __future__ import annotations
from collections import defaultdict

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class PriceGridRmd(Remediator):
    dimension = "price_grid"
    title = "가격격자 정합 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        auth = [d for d in mine if d.severity == "high"]
        review = [d for d in mine if d.severity != "high"]

        out: list[Fix] = []
        if auth:
            by_sheet: dict[str, list[Defect]] = defaultdict(list)
            for d in auth:
                by_sheet[d.evidence.get("sheet", "?")].append(d)
            sheets = sorted(by_sheet)
            cells = sum(d.evidence.get("cells", 0) for d in auth)
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"가격격자 정합 교정 필요(미적재/불일치 셀) — {len(sheets)}시트",
                defects=[d.key() for d in auth], root_comps=[],
                worklist_note=(f"권위 가격표(260527) ↔ 라이브 격자 불일치 {cells}셀({len(sheets)}시트: "
                               f"{', '.join(sheets)}). 미적재 셀 적재/transpose 교정/값 조사 = **권위값 확보 후 "
                               f"§26·§7 dbmap 적재**(값 날조 금지). 상세=§26 ALL-SHEETS-defects.csv. "
                               f"※시점종속 드리프트(병합/적재 후) 가능 — 재스냅 후 재확인 권장."),
            ))
        if review:
            sheets = sorted({d.evidence.get("sheet", "?") for d in review})
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"가격격자 매핑 미상·검토 — {len(sheets)}시트",
                defects=[d.key() for d in review],
                worklist_note=(f"시트 comp 매핑 미확정 또는 저신뢰 결함({', '.join(sheets)}). §26 매퍼 추가/"
                               f"사람 확인 후 재diff. 날조 금지."),
            ))
        return out
