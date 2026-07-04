"""PlatesizeRmd — 판형 정합 교정.

분류(값 날조 금지):
  PLATE_MISMATCH → **needs_authority**: 어느 판형이 옳은지(상품 판형 vs comp 단가 판형)는 권위
       (판걸이수 시트/실무진) 판단 → worklist.
  PLATE_MISWIRE → **review**: 완제품/orphan 사이즈를 판형으로 오배선 — 재배선/제거 수동 판정
       (§7 dbmap 상시게이트 트랙).
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class PlatesizeRmd(Remediator):
    dimension = "platesize"
    title = "판형 정합 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        mismatch = [d for d in mine if "MISMATCH" in d.summary]
        miswire = [d for d in mine if "MISWIRE" in d.summary]

        out: list[Fix] = []
        if mismatch:
            prods = sorted({d.prd_cd for d in mismatch if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"판형 미스매치 교정 필요(부분 견적0·저청구) — {len(prods)}개 상품",
                defects=[d.key() for d in mismatch], root_comps=[],
                worklist_note=(f"판형축 comp 가 상품 판형과 교집합 0 → 부분 견적0. 상품 판형(plate_sizes) 또는 "
                               f"comp 단가 판형을 정렬해야 함 — 어느 쪽이 옳은지 **권위(판걸이수 시트)/실무진 확인**. "
                               f"상품 {len(prods)}개: {', '.join(prods[:12])}{' …' if len(prods) > 12 else ''}"),
            ))
        if miswire:
            prods = sorted({d.prd_cd for d in miswire if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"판형 오배선 검토(완제품/orphan 사이즈) — {len(prods)}개 상품",
                defects=[d.key() for d in miswire],
                worklist_note=("plate_sizes.siz_cd 가 유효 판형(impos_yn=Y) 아님 → 유효 판형 재배선 또는 "
                               "제거. §7 dbmap 상시게이트(plate_wiring_integrity_check.sql) 트랙 수동 판정."),
            ))
        return out
