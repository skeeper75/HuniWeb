"""WiringRmd — 배선 결함 교정 생성.

분류(값 날조 금지):
  placeholder(PENDING/TBD/확인필요) comp 의 빈배선 → **blocked_human**: 실무진이 단가·구성 입력해야
       엔진이 가격을 낸다. 배선 제거는 오답(상품 포기)·단가 날조는 금지 → worklist(SQL 없음).
  그 외 dead_wire(빈배선) → **needs_authority**: 단가행 값이 권위/실무진에서 와야 함 → worklist.
  orphan(고아) → **review**: 배선 누락 vs 정당 미사용 판정 필요(생성≠검증·게이트 판정).
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix

PLACEHOLDER_TOKENS = ("PENDING", "TBD", "확인필요")


def _is_placeholder(comp_cd: str | None, comp_nm: str = "") -> bool:
    hay = f"{comp_cd or ''} {comp_nm or ''}".upper()
    return any(t.upper() in hay for t in PLACEHOLDER_TOKENS)


class WiringRmd(Remediator):
    dimension = "wiring"
    title = "배선 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        comp_nm = {r["comp_cd"]: r.get("comp_nm", "")
                   for r in snap.table("t_prc_price_components") if r.get("comp_cd")}

        out: list[Fix] = []
        # placeholder 빈배선 → comp 단위 blocked_human 1건으로 묶음
        ph: dict[str, list[Defect]] = {}
        auth: list[Defect] = []
        review: list[Defect] = []
        for d in mine:
            if "빈배선" in d.summary or "오염" in d.summary:
                if _is_placeholder(d.comp_cd, comp_nm.get(d.comp_cd, "")):
                    ph.setdefault(d.comp_cd, []).append(d)
                else:
                    auth.append(d)
            else:  # 고아
                review.append(d)

        for comp_cd, ds in sorted(ph.items()):
            frms = sorted({d.frm_cd for d in ds if d.frm_cd})
            note = (f"placeholder 구성요소 '{comp_cd}'({comp_nm.get(comp_cd, '')}) 가 공식 {len(frms)}개에 "
                    f"배선됐으나 단가행 0 → 해당 상품 계산불가. **실무진이 실제 단가·구성 입력** 필요"
                    f"(§18 설계→§7 적재). 배선 제거·단가 날조 금지. 공식: {', '.join(frms)}")
            out.append(Fix(
                dimension=self.dimension, remediation_class="blocked_human",
                title=f"실무진 단가·구성 입력 대기: {comp_cd}",
                defects=[d.key() for d in ds], root_comps=[comp_cd], worklist_note=note,
            ))
        if auth:
            comps = sorted({d.comp_cd for d in auth if d.comp_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"빈배선 단가행 적재 필요(권위값 확보) — {len(comps)} comp",
                defects=[d.key() for d in auth], root_comps=comps,
                worklist_note=(f"배선됐으나 단가행 0인 comp {len(comps)}개. 단가값을 권위 엑셀/실무진에서 "
                               f"확보 후 적재(날조 금지) 또는 정당 미사용이면 배선 제거. comp: {', '.join(comps[:12])}"),
            ))
        if review:
            comps = sorted({d.comp_cd for d in review if d.comp_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"고아 구성요소 판정 필요(배선 누락 vs 정당 미사용) — {len(comps)} comp",
                defects=[d.key() for d in review], root_comps=comps,
                worklist_note=("단가행 있으나 미배선. 배선 누락(공식 편입)인지 정당 미사용(orphan-classification "
                               "등록)인지 게이트 판정 필요. comp: " + ', '.join(comps[:12])),
            ))
        return out
