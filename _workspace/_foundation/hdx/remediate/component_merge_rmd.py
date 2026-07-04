"""ComponentMergeRmd — 가격구성요소 병합 교정 생성.

분류: 유형 A/B 병합 후보 → **auto_data**(단가 verbatim 불변·값 날조 없음).
실 SQL 재료화는 **검증된 생성기 승계** = `_workspace/huni-price-master/30_component-merge/_commit/
gen_commit_sql.py`(라이브 사전실측 natkey·격자 + 게이트 4종 하드어서션 + FK 위상: 정본 INSERT→
단가행 UPDATE→fc 재배선→멤버 논리삭제). 그 생성기는 라이브 사전실측(격자 verbatim)을 요구하므로,
여기서는 병합 대상·정본명을 확정한 **가이드 Fix**를 내고 실 SQL 은 그 생성기로 재료화한다.

※이번 세션 9군 병합은 라이브 COMMIT 완료 → 현재 스냅샷 후보 0(정상). 후보 재등장 시 이 경로 사용.
"""
from __future__ import annotations

from .base import Remediator
from ..foundation import Snapshot, Defect, Fix


class ComponentMergeRmd(Remediator):
    dimension = "component_merge"
    title = "가격구성요소 병합 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        out: list[Fix] = []
        for d in mine:
            members = d.evidence.get("members") or []
            note = (f"병합 대상 {len(members)}개 → 정본 1개. 단가 verbatim 불변·이중합산 방지. "
                    f"실 SQL = 검증된 생성기 승계(30_component-merge/_commit/gen_commit_sql.py: "
                    f"백업 z_bak_* + 게이트 하드어서션 + FK 위상 + undo). 멤버: {', '.join(members)}")
            out.append(Fix(
                dimension=self.dimension, remediation_class="auto_data",
                title=d.summary, defects=[d.key()], root_comps=members,
                worklist_note=note,
                gates=["단가 verbatim 불변(병합 전후 골든 0오차)", "silent 이중합산 0(NON_QTY_DIMS 정확매칭)",
                       "★P4 재실측 + 인간 승인 후 COMMIT"],
            ))
        return out
