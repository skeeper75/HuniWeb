"""Remediator 공통 계약(L4) — 교정본 생성 통일(설계 §2 L4).

각 차원의 Remediator 가 Defect → Fix 로 교정을 생성한다. 자동은 여기까지(dryrun/fix/undo SQL),
적재 COMMIT·webadmin 실화면은 인간 게이트(L7·설계 [HARD]).

[HARD] AI 값 날조 금지: 단가값이 권위(엑셀·실무진)에서 와야 하는 결함은 SQL 을 만들지 않는다 —
`needs_authority`/`blocked_human` 으로 라우팅해 worklist 로만 낸다. `auto_data`(값 날조 없는
결정론 데이터/메타 교정)만 SQL 트리플을 낸다. auto_data 라도 자동 COMMIT 금지(dryrun·게이트·P4·인간).

SQL 패턴 승계: `_workspace/huni-price-master/30_component-merge/_commit/`(01-backup·04-undo·게이트
하드어서션)와 `_foundation/remediation/*-{dryrun,fix,undo}.sql` 규약. 물리 백업=CREATE TABLE AS(멱등).
"""
from __future__ import annotations
from ..foundation import Snapshot, Defect, Fix


class Remediator:
    """한 결함 차원의 교정 생성기. 하위 클래스는 dimension·generate 를 정의한다."""

    dimension: str = "?"
    title: str = ""

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        """이 차원 Defect → Fix 목록. 값 날조 불가 결함은 worklist(SQL 없음)로."""
        raise NotImplementedError

    def _mine(self, defects: list[Defect]) -> list[Defect]:
        return [d for d in defects if d.dimension == self.dimension]


# ── 공통 SQL 빌더(검증된 패턴) ─────────────────────────────────────────
def backup_sql(bak_table: str, src_table: str, where: str) -> str:
    """물리 백업 = DROP IF EXISTS + CREATE TABLE AS(재실행 멱등). undo 가 이를 참조."""
    return (f"DROP TABLE IF EXISTS {bak_table};\n"
            f"CREATE TABLE {bak_table} AS\n"
            f"SELECT * FROM {src_table}\nWHERE {where};")


def gate_assert(condition_sql: str, fail_msg: str) -> str:
    """사전/사후 게이트 하드어서션(위반 시 RAISE→abort). condition_sql=TRUE 여야 통과."""
    safe = fail_msg.replace("'", "''")
    return (f"DO $$ BEGIN\n"
            f"  IF NOT ({condition_sql}) THEN\n"
            f"    RAISE EXCEPTION '게이트 위반: {safe}';\n"
            f"  END IF;\nEND $$;")


def wrap_tx(body: str) -> str:
    """단일 트랜잭션 래핑(부분 적용 방지)."""
    return f"BEGIN;\n\n{body}\n\nCOMMIT;"


_HEADER = ("-- ============================================================\n"
           "-- {title}\n"
           "-- 분류: {klass}  |  차원: {dim}\n"
           "-- ★[HARD] 인간 승인 전 실행 금지. dryrun→P4 재실측→인간 승인 후에만 fix 실행.\n"
           "-- 닫는 결함: {ndef}건\n"
           "-- ============================================================\n")


def sql_header(fix: Fix) -> str:
    return _HEADER.format(title=fix.title, klass=fix.remediation_class,
                          dim=fix.dimension, ndef=len(fix.defects))
