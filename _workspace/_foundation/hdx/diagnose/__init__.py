"""hdx.diagnose — 진단 레이어(L2). 파편 스캐너를 Diagnoser 계약으로 통일(설계 §2).

가격 도메인 파일럿 5 Diagnoser:
  WiringDx          ← wiring_scan.py           배선 고아/빈배선/오염
  DimConformanceDx  ← dim_conformance.py       use_dims↔단가행↔선택수단(포팅)
  ContributionDx    ← contribution_scan.py     공정 저청구(silent-0)
  ComponentMergeDx  ← component_merge_scan.py   같은차원 분리 comp
  CalcabilityDx     ← score_batch.py(구조 프록시) 전 상품 PRICE≠0
  OptionCpqDx       ★신규(갭#5)                 옵션 dtl_opt 파라미터 연결 끊김(저청구)

전파 예정(설계 §3): PlatesizeDx·PriceGridDx·QtyRuleDx.
"""
from .base import Diagnoser
from .wiring_dx import WiringDx
from .dim_conformance_dx import DimConformanceDx
from .contribution_dx import ContributionDx
from .component_merge_dx import ComponentMergeDx
from .calcability_dx import CalcabilityDx
from .option_cpq_dx import OptionCpqDx
from .qty_rule_dx import QtyRuleDx
from .platesize_dx import PlatesizeDx
from .price_grid_dx import PriceGridDx
from .linkage_dx import LinkageDx

# 가격 도메인 파일럿 진단기 집합(diagnose_remediate --scope price)
PRICE_DIAGNOSERS = [
    WiringDx(),
    DimConformanceDx(),
    ContributionDx(),
    ComponentMergeDx(),
    CalcabilityDx(),
    OptionCpqDx(),
    QtyRuleDx(),
    PlatesizeDx(),
    PriceGridDx(),
]

# 연결 무결성 스코프(diagnose_remediate --scope linkage) — 배선 단절 전용 렌즈(양방향)
LINKAGE_DIAGNOSERS = [
    LinkageDx(),
]

__all__ = ["Diagnoser", "WiringDx", "DimConformanceDx", "ContributionDx",
           "ComponentMergeDx", "CalcabilityDx", "OptionCpqDx", "QtyRuleDx",
           "PlatesizeDx", "PriceGridDx", "LinkageDx",
           "PRICE_DIAGNOSERS", "LINKAGE_DIAGNOSERS"]
