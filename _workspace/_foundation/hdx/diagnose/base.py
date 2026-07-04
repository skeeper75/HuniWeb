"""Diagnoser 공통 계약 — 파편 스캐너를 한 인터페이스로 통일(설계 §2 L2).

각 스캐너(wiring_scan·dim_conformance·contribution_scan·component_merge_scan·
score_batch PRICED-0)가 제각각 출력·실행 규약을 갖던 것을 이 계약 하나로 묶어,
`diagnose_remediate.py` 가 `for dx in ALL: dx.scan(snap)` 로 입체(다차원) 진단하고
통합 결함보드·전역 verdict(Σ stop_predicate)를 성립시킨다.

[HARD] scan()은 라이브 스냅샷 읽기전용(결정론·토큰0). DB·시뮬 호출 없음(교정은 P3·재실측은 P4).
"""
from __future__ import annotations
from ..foundation import Snapshot, Defect


class Diagnoser:
    """한 결함 차원의 진단기. 하위 클래스는 dimension·scan·stop_predicate 를 정의한다."""

    dimension: str = "?"          # 'wiring'|'dim_conformance'|'contribution'|...
    title: str = ""               # 보드 표시용 한글 라벨

    def scan(self, snap: Snapshot) -> list[Defect]:
        """스냅샷을 진단해 이 차원의 Defect 목록을 반환(빈 리스트=결함 없음)."""
        raise NotImplementedError

    def stop_predicate(self, defects: list[Defect]) -> bool:
        """이 차원 종료(결함 해소) 여부. 기본=이 차원 Defect 0.

        차원마다 종료 기준이 다르면(예: HIGH만 blocking) override 한다.
        """
        mine = [d for d in defects if d.dimension == self.dimension]
        return len(mine) == 0

    # 편의: blocking(critical/high)만 종료판정에 쓰는 차원용 헬퍼
    @staticmethod
    def _no_blocking(defects: list[Defect], dimension: str) -> bool:
        return not any(d.dimension == dimension and d.severity in ("critical", "high")
                       for d in defects)
