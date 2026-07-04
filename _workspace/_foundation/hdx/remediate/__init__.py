"""hdx.remediate — 교정 생성 레이어(L4). Defect → Fix(dryrun/fix/undo 또는 worklist).

[HARD] 자동은 교정본 생성까지. 적재 COMMIT·webadmin 실화면은 인간 게이트. 값 날조 금지.
"""
from .base import Remediator
from .wiring_rmd import WiringRmd
from .calcability_rmd import CalcabilityRmd
from .dim_conformance_rmd import DimConformanceRmd
from .contribution_rmd import ContributionRmd
from .component_merge_rmd import ComponentMergeRmd
from .option_cpq_rmd import OptionCpqRmd
from .qty_rule_rmd import QtyRuleRmd
from .platesize_rmd import PlatesizeRmd
from .price_grid_rmd import PriceGridRmd
from .linkage_rmd import LinkageRmd
from .registration_rmd import RegistrationRmd
from . import plan

PRICE_REMEDIATORS = [
    WiringRmd(),
    CalcabilityRmd(),
    DimConformanceRmd(),
    ContributionRmd(),
    ComponentMergeRmd(),
    OptionCpqRmd(),
    QtyRuleRmd(),
    PlatesizeRmd(),
    PriceGridRmd(),
]

# 연결 무결성 스코프 교정기
LINKAGE_REMEDIATORS = [
    LinkageRmd(),
]

# 스텝2 통합 스코프 교정기(--scope all) — 4축 대응(진단 ALL_DIAGNOSERS 와 짝).
#   Linkage=auto(E3 use_dims)+worklist · PriceGrid/Registration/Contribution=worklist(값 날조 금지).
ALL_REMEDIATORS = [
    LinkageRmd(),
    PriceGridRmd(),
    RegistrationRmd(),
    ContributionRmd(),
]

__all__ = ["Remediator", "WiringRmd", "CalcabilityRmd", "DimConformanceRmd",
           "ContributionRmd", "ComponentMergeRmd", "OptionCpqRmd", "QtyRuleRmd",
           "PlatesizeRmd", "PriceGridRmd", "LinkageRmd", "RegistrationRmd",
           "PRICE_REMEDIATORS", "LINKAGE_REMEDIATORS", "ALL_REMEDIATORS", "plan"]
