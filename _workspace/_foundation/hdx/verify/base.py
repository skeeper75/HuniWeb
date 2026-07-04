"""적대적 독립 재실측(L5) — 교정본을 적재 전 배치가 스스로 검증(생성≠검증·설계 §2 L5·§6).

각 auto_data Fix 에 대해 mutation 을 스냅샷 사본에 in-memory 적용하고:
  ① 가격중립  — engine(pricing.py verbatim) 재계산이 교정 전/후 단가 동일(허용오차 0)
  ② 결함해소  — 교정이 겨냥한 결함(fix.defects)이 재진단에서 사라짐
  ③ 무회귀    — 어떤 차원에도 새 결함 0 (적대적: 교정이 다른 곳을 깨지 않는가)
전부 통과 → GO. 하나라도 실패 → NO-GO(예상과 다름 = 재조사·적재 금지).

[HARD] 라이브 미변경(in-memory 오버레이). auto_data 게이트의 "★P4 재실측" 술어를 실제로 채운다.
worklist 계열(needs_*/blocked_human)은 값 날조 대상이라 재실측 불가 → SKIP(verifiable=False).
codex 2차는 P5(선택). 미가용 시 "Claude 단독" 폴백.
"""
from __future__ import annotations
from dataclasses import dataclass, field

from ..foundation import Snapshot, Fix
from ..diagnose import PRICE_DIAGNOSERS
from .overlay import MutableSnapshot
from . import golden


@dataclass
class Verdict:
    fix_title: str
    verifiable: bool
    price_neutral: bool = False
    price_deltas: list = field(default_factory=list)   # 비면 가격중립
    defects_closed: int = 0                             # 겨냥 결함 중 해소된 수
    target_defects: int = 0
    new_defects: list = field(default_factory=list)     # 새로 생긴 결함(무회귀 위반)
    go: bool = False
    notes: str = ""

    @property
    def mark(self) -> str:
        if not self.verifiable:
            return "SKIP"
        return "GO" if self.go else "NO-GO"


def _all_defect_keys(snap: Snapshot) -> set:
    keys = set()
    for dx in PRICE_DIAGNOSERS:
        for d in dx.scan(snap):
            keys.add(d.key())
    return keys


def _affected_comp(mutation: dict, snap: Snapshot) -> str | None:
    """교정이 영향 주는 comp_cd 를 mutation 에서 해석(가격 재실측 대상 식별).

    · price_components 교정 → key.comp_cd 직접
    · component_prices 교정 → key.comp_price_id 로 단가행 조회해 comp_cd 역추적
    """
    key = mutation.get("key", {})
    if "comp_cd" in key:
        return key["comp_cd"]
    tbl = mutation.get("table")
    if tbl == "t_prc_component_prices" and "comp_price_id" in key:
        for r in snap.table(tbl):
            if str(r.get("comp_price_id")) == str(key["comp_price_id"]):
                return r.get("comp_cd")
    return None


def verify_fix(fix: Fix, snap_dir=None) -> Verdict:
    """한 auto_data Fix 를 재실측. mutation 없으면(가이드형·worklist) SKIP."""
    if not fix.is_auto or not fix.mutation:
        return Verdict(fix_title=fix.title, verifiable=False,
                       notes="mutation 없음(worklist 또는 가이드형 SQL) → 재실측 불가")

    base = Snapshot(snap_dir)
    over = MutableSnapshot(snap_dir, [fix.mutation])
    comp = _affected_comp(fix.mutation, base)

    # ① 가격중립: comp 단가 재실측(교정 전/후)
    price_deltas = []
    price_neutral = True
    if comp:
        before = golden.measure_comp(base, comp)
        after = golden.measure_comp(over, comp)
        price_deltas = golden.diff_prices(before, after)
        price_neutral = (len(price_deltas) == 0)

    # ②③ 결함해소·무회귀: 전 차원 재진단(교정 전/후 결함키 diff)
    before_keys = _all_defect_keys(base)
    after_keys = _all_defect_keys(over)
    target = set(tuple(k) if isinstance(k, list) else k for k in fix.defects)
    closed = len([k for k in target if k not in after_keys])
    new_defects = [list(k) for k in (after_keys - before_keys)]

    go = price_neutral and closed == len(target) and not new_defects
    notes = []
    if not price_neutral:
        notes.append(f"가격변동 {len(price_deltas)}건(예상=중립·재조사)")
    if closed != len(target):
        notes.append(f"겨냥 결함 미해소 {len(target)-closed}/{len(target)}")
    if new_defects:
        notes.append(f"새 결함 {len(new_defects)}건(무회귀 위반)")
    if go:
        notes.append("가격중립·결함해소·무회귀 — 순수 정합 개선")
    return Verdict(
        fix_title=fix.title, verifiable=True, price_neutral=price_neutral,
        price_deltas=price_deltas, defects_closed=closed, target_defects=len(target),
        new_defects=new_defects, go=go, notes=" · ".join(notes),
    )
