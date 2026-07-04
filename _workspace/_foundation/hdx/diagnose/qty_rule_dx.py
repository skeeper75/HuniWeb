"""QtyRuleDx — 수량규칙↔가격구간 정합 진단. 원본=`_foundation/batch/qty_rule_audit_260702.py`.

원본은 라이브 psql. 여기서는 동일 알고리즘을 공용 Snapshot 으로 포팅(결정론·토큰0). 판정 verbatim.

엽서북형 함정: 상품 최소수량(미등록=UI 기본 1)으로 주문 가능한데, 가격구간 comp 의 최소구간이
그보다 크면 → 그 comp 가 매칭 안 됨(구간 밖) → 제외/무료 → 화면 0원/저청구.

판정:
  TRAP_MIN  상품 eff_min < 어떤 필수 구간 comp 의 band_min → 구간 아래 주문 시 그 comp 무료(저청구·high)
  NO_RULES  상품 min_qty 미등록 + 구간 존재(UI 기본 1) → 함정 위험(high)
  INFO_MAX  상품 max_qty > 최대구간 시작 ×10 → 초대량 저청구 검토(low)
stop = TRAP_MIN/NO_RULES(HIGH) 0. 교정값(올바른 min)은 권위(가격표 band/실무진) → needs_authority.
"""
from __future__ import annotations
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect

_ACTIVE_COMP = lambda r: (r.get("use_yn") or "Y") == "Y"
_ACTIVE_PRD = lambda r: (r.get("del_yn") or "N") == "N" and (r.get("use_yn") or "Y") == "Y"


def _int(v):
    try:
        return int(float(v)) if v not in (None, "") else None
    except Exception:
        return None


class QtyRuleDx(Diagnoser):
    dimension = "qty_rule"
    title = "수량규칙↔가격구간 정합"

    def scan(self, snap: Snapshot) -> list[Defect]:
        active_comp = {r["comp_cd"] for r in snap.table("t_prc_price_components")
                       if r.get("comp_cd") and _ACTIVE_COMP(r)}
        # comp → (band_min, band_max) : min_qty 구간(NULL=구간 없음)
        band_min: dict[str, int] = {}
        band_max: dict[str, int] = {}
        for r in snap.table("t_prc_component_prices"):
            c = r.get("comp_cd")
            mq = _int(r.get("min_qty"))
            if c is None or mq is None:
                continue
            band_min[c] = mq if c not in band_min else min(band_min[c], mq)
            band_max[c] = mq if c not in band_max else max(band_max[c], mq)
        # 공식 → 구간보유 활성 comp
        frm_comps: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prc_formula_components"):
            f, c = r.get("frm_cd"), r.get("comp_cd")
            if f and c and c in active_comp and c in band_min:
                frm_comps[f].add(c)
        # 상품 → 공식
        prod_frms: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prd_product_price_formulas"):
            p, f = r.get("prd_cd"), r.get("frm_cd")
            if p and f:
                prod_frms[p].add(f)
        prods = {r["prd_cd"]: r for r in snap.table("t_prd_products")
                 if r.get("prd_cd") and _ACTIVE_PRD(r)}

        out: list[Defect] = []
        for prd, prow in sorted(prods.items()):
            comps = set()
            for f in prod_frms.get(prd, ()):
                comps |= frm_comps.get(f, set())
            if not comps:
                continue  # 수량구간 comp 없음(면적형/장당형) — 함정 불가
            pmin_raw = prow.get("min_qty")
            eff_min = _int(pmin_raw) or 1                    # 미등록이면 UI 기본 1
            trap = sorted(c for c in comps if band_min[c] > eff_min)
            pmax = _int(prow.get("max_qty"))
            max_band = max((band_max[c] for c in comps), default=None)
            nm = prow.get("prd_nm", "")

            if (pmin_raw in (None, "")) and trap:
                out.append(Defect(
                    dimension=self.dimension,
                    summary=f"수량규칙 미등록+구간 존재(NO_RULES): '{nm}' UI 기본 min=1 < 구간 → 함정 위험",
                    severity="high", money_impact="undercharge", prd_cd=prd,
                    evidence={"eff_min": 1, "strictest_band": max(band_min[c] for c in trap),
                              "trap_comps": ";".join(trap)[:120]},
                    suggested_fix="상품 min_qty 등록(권위=가격표 구간 하한/실무진 확인·값 날조 금지)",
                ))
            elif trap:
                out.append(Defect(
                    dimension=self.dimension,
                    summary=f"수량 함정(TRAP_MIN): '{nm}' 최소수량 {eff_min} < 구간 comp 최소 → 구간 아래 주문 시 무료",
                    severity="high", money_impact="undercharge", prd_cd=prd,
                    evidence={"eff_min": eff_min, "strictest_band": max(band_min[c] for c in trap),
                              "trap_comps": ";".join(trap)[:120]},
                    suggested_fix="상품 min_qty 를 구간 하한 이상으로 교정(권위=가격표/실무진·값 날조 금지)",
                ))
            elif pmax and max_band and pmax > max_band * 10:
                out.append(Defect(
                    dimension=self.dimension,
                    summary=f"초대량 저청구 검토(INFO_MAX): '{nm}' max {pmax} > 최대구간 {max_band}×10",
                    severity="low", money_impact="unknown", prd_cd=prd,
                    evidence={"prd_max": pmax, "max_band_start": max_band},
                    suggested_fix="초대량 구간 단가 검토(가격표 최대구간 초과 시 별도 견적)",
                ))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        return not any(d.dimension == self.dimension and d.severity == "high"
                       for d in defects)
