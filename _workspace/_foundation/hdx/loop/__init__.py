"""hdx.loop — 반자동 라운드 러너(L6). scan→board→remediate→verify→[인간 게이트].

[HARD] 완전 무인 금지: 러너는 종합 보고까지·적재 COMMIT·webadmin 은 인간.
"""
from .runner import RoundResult, run_round

__all__ = ["RoundResult", "run_round"]
