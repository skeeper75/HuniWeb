"""공통 데이터 모델 — 파편 출력 통일(설계 청사진 §4·갭#1 핵심).

각 스캐너가 제각각 출력하던 것(wiring-status.json / ALL-SHEETS-defects.csv /
platesize-defects-all.json …)을 이 Defect 하나로 통일 → 통합 결함보드·돈영향 우선순위·
교정 라우팅이 성립.
"""
from __future__ import annotations
from dataclasses import dataclass, field, asdict

SEVERITY = ("critical", "high", "medium", "low")
MONEY_IMPACT = ("overcharge", "undercharge", "none", "unknown")


@dataclass
class Defect:
    """한 결함(차원 무관 공통형)."""
    dimension: str                      # 'wiring'|'dim_conformance'|'option_cpq'|'component_merge'|...
    summary: str                        # 한 줄 결함
    severity: str = "medium"            # SEVERITY 중
    money_impact: str = "unknown"       # MONEY_IMPACT 중
    prd_cd: str | None = None
    comp_cd: str | None = None
    frm_cd: str | None = None
    evidence: dict = field(default_factory=dict)   # 라이브 실측값·권위값·경로
    suggested_fix: str = ""             # 교정 방향(Remediator 입력)
    authority_ref: str = ""             # 권위 근거(엑셀 시트·셀)

    def __post_init__(self):
        if self.severity not in SEVERITY:
            raise ValueError(f"severity 부정: {self.severity} (허용 {SEVERITY})")
        if self.money_impact not in MONEY_IMPACT:
            raise ValueError(f"money_impact 부정: {self.money_impact} (허용 {MONEY_IMPACT})")

    def key(self) -> tuple:
        """중복 제거·정렬용 자연키."""
        return (self.dimension, self.prd_cd, self.comp_cd, self.frm_cd, self.summary)

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass
class Fix:
    """한 교정본(Remediator 산출) — dryrun/fix/undo SQL 3종 + 게이트."""
    dimension: str
    title: str
    defects: list = field(default_factory=list)   # 이 교정이 닫는 Defect.key() 목록
    dryrun_sql: str = ""                 # 롤백전용 멱등 실증
    fix_sql: str = ""                    # 인간 승인 후 실행(백업·게이트 하드어서션 내장)
    undo_sql: str = ""                   # 원복
    backup_table: str = ""               # z_bak_* 백업 테이블명
    gates: list = field(default_factory=list)      # 사전/사후 게이트 술어 설명
    needs_engine_change: bool = False    # 엔진 코드 변경 필요(=C트랙·데이터만으로 못 닫음)

    def to_dict(self) -> dict:
        return asdict(self)
