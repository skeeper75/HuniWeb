"""hdx.foundation — 공용 토대(L1).

승계(search-before-mint):
  env, db      ← _foundation/batch/lib_huni.py (load_env·db 그대로 승격)
  engine       ← _foundation/remediation/_gate_harness.py 1-88줄 (pricing.py verbatim 이식·아크릴 하드코딩 제거)
  snapshot     ← wiring_scan.py/contribution_scan.py 의 CSV 로더 공통 추출(복붙 제거)
  sim          ← lib_huni.HuniSim·price_of·components_of
  models       ← 설계 청사진 §4 Defect/Fix 스키마(신규)
"""
from .env import load_env
from .db import db
from .snapshot import Snapshot
from .models import Defect, Fix
from . import engine

__all__ = ["load_env", "db", "Snapshot", "Defect", "Fix", "engine"]
