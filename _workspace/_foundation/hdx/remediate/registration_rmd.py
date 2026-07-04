"""RegistrationRmd — 유료옵션 등록 도달성 결함 교정 라우팅. 전량 worklist(값 날조 금지).

분류:
  HIGH(가격경로 끊김·addon 삭제) → **needs_authority**: 권위 엑셀 유료옵션을 DB 옵션 단가행/addon
       템플릿에 연결(단가값=권위·webadmin 실화면 확인). AI 가 단가·연결을 날조하지 않음 → SQL 미생성.
  NEEDS_HUMAN(브리지 조인 불확실) → **review**: prd_nm→prd_cd 매핑 확정(자동 결론 금지) 후 재진단.
  REVIEW(옵션·addon 모두 없음)   → **review**: 진짜 미연결/이름차이 오탐/별도상품 수동 확정.

[HARD] 등록 도달성 교정은 단가·연결이 권위/실무진에서 와야 함 → auto_data SQL 없음(전건 worklist).
과거 키링류 저청구 교정도 라이브 sim 확인 후 인간 승인으로 적재(생성≠검증).
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class RegistrationRmd(Remediator):
    dimension = "registration"
    title = "유료옵션 등록 도달성 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        auth = [d for d in mine if d.severity == "high"]                       # 저청구 끊김/addon 삭제
        human = [d for d in mine if d.severity != "high" and d.evidence.get("needs_human")]
        review = [d for d in mine if d.severity != "high" and not d.evidence.get("needs_human")]

        out: list[Fix] = []
        if auth:
            prods = sorted({d.prd_cd for d in auth if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"유료옵션 가격연결 필요(저청구) — 상품 {len(prods)}개",
                defects=[d.key() for d in auth],
                worklist_note=("권위 엑셀 유료 추가옵션이 DB 옵션 단가행·addon 템플릿에 미연결(0원 청구). "
                               "권위값으로 opt_cd 단가행/addon 링크 연결 = 값 날조 금지·webadmin 실화면 확인 후 "
                               f"인간 승인 적재. 상품: {', '.join(prods[:12])}{' …' if len(prods) > 12 else ''}"),
                gates=["엑셀 권위값 확보", "webadmin 실화면 sim PRICE≠0", "인간 승인"],
            ))
        if human:
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"prd_nm→prd_cd 조인 확정 필요(자동 결론 금지) — {len(human)}건",
                defects=[d.key() for d in human],
                worklist_note=("브리지 AMBIGUOUS/UNMATCHED/needs_human — 엑셀 권위로 매핑 확정 후 재진단. "
                               "잘못된 매칭=엉뚱한 상품에 엉뚱한 가격=no-match 보다 나쁨(스텝1b 게이트)."),
            ))
        if review:
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"유료옵션 미등록 검토(저신뢰·이름차이 가능) — {len(review)}건",
                defects=[d.key() for d in review],
                worklist_note=("DB 옵션·addon 모두 없음 = ① 진짜 미연결(정가표엔 있으나 이 상품에 미연결) "
                               "② 이름차이 오탐 ③ 별도상품. 수동 확정(신규 템플릿 mint 는 권위값으로만)."),
            ))
        return out
