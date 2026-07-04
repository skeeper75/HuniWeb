"""hdx.verify — 적대적 독립 재실측(L5). engine verbatim 재계산으로 교정본 자체검증.

[HARD] 라이브 미변경(in-memory). auto_data 게이트의 P4 재실측 술어 충전. codex 2차는 P5.
"""
from .base import Verdict, verify_fix, _all_defect_keys
from . import golden
from .overlay import MutableSnapshot

__all__ = ["Verdict", "verify_fix", "golden", "MutableSnapshot"]
