"""PlatesizeDx — 판형 정합 진단. 원본=`huni-dbmap/platesize-remediation/diagnose_all.py`
+ 상시게이트 `_foundation/batch/plate_wiring_integrity_check.sql`.

원본 diagnose_all 은 이미 스냅샷 기반 — 로직 verbatim 포팅(공용 Snapshot). 판정 2종:

  PLATE_MISMATCH  상품이 판형축 comp(use_dims 에 plt_siz_cd)를 공식으로 바인딩하는데, 상품 판형
                  (plate_sizes) ∩ 그 comp 단가 보유 판형 = 0 → 어떤 판형선택도 no-match → 부분 견적0(저청구·high).
  PLATE_MISWIRE   t_prd_product_plate_sizes.siz_cd 가 유효 판형(impos_yn=Y·판걸이수 시트 포함) 아님
                  = 완제품/item 사이즈를 판형으로 오배선 → 데이터 위생 결함(가격영향 무관하게 결함·medium).
                  ([[plate-size-authority-pangeori-sheet-260704]]: 완제품 as-plate=결함·묵살 금지)
stop = PLATE_MISMATCH(HIGH) + PLATE_MISWIRE = 0.
"""
from __future__ import annotations
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect

_NOTDEL = lambda r: (r.get("del_yn") or "N") != "Y"


class PlatesizeDx(Diagnoser):
    dimension = "platesize"
    title = "판형 정합(미스매치·오배선)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        prds = {r["prd_cd"]: r for r in snap.table("t_prd_products") if r.get("prd_cd")}
        siz = {r["siz_cd"]: r for r in snap.table("t_siz_sizes") if r.get("siz_cd")}

        # 판형축 comp = use_dims 에 plt_siz_cd 포함(원본 substring 판정 verbatim)
        plt_axis = {c["comp_cd"] for c in snap.table("t_prc_price_components")
                    if c.get("comp_cd") and (c.get("del_yn") or "N") == "N"
                    and "plt_siz_cd" in (c.get("use_dims") or "")}
        # comp → 단가 보유 판형집합
        comp_plts: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prc_component_prices"):
            c, pl = r.get("comp_cd"), r.get("plt_siz_cd")
            if c in plt_axis and pl:
                comp_plts[c].add(pl)
        # 공식 → comp, 상품 → 판형축 comp
        fc: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prc_formula_components"):
            if r.get("frm_cd") and r.get("comp_cd"):
                fc[r["frm_cd"]].add(r["comp_cd"])
        prd_comps: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prd_product_price_formulas"):
            for c in fc.get(r.get("frm_cd"), ()):
                if c in plt_axis:
                    prd_comps[r["prd_cd"]].add(c)
        # 상품 판형
        prd_plates: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prd_product_plate_sizes"):
            if _NOTDEL(r) and r.get("prd_cd") and r.get("siz_cd"):
                prd_plates[r["prd_cd"]].add(r["siz_cd"])

        out: list[Defect] = []
        # ── PLATE_MISMATCH (diagnose_all verbatim) ──
        for prd in sorted(prd_comps):
            plates = prd_plates.get(prd, set())
            for C in sorted(prd_comps[prd]):
                cp = comp_plts.get(C, set())
                if not cp:
                    continue                       # 그 comp 단가 자체 없음(판형 무관 결손)
                if not (plates & cp):
                    out.append(Defect(
                        dimension=self.dimension,
                        summary=(f"판형 미스매치(PLATE_MISMATCH): 판형축 comp 가 상품 판형과 "
                                 f"교집합 0 → 부분 견적0"),
                        severity="high", money_impact="undercharge",
                        prd_cd=prd, comp_cd=C,
                        evidence={"cur_plates": sorted(plates)[:8],
                                  "comp_priced_plates": sorted(cp)[:8]},
                        suggested_fix="상품 판형(plate_sizes) 또는 comp 단가 판형 정렬(권위=판걸이수 시트)",
                    ))
        # ── PLATE_MISWIRE (상시게이트 verbatim) ──
        valid = {c for c, r in siz.items()
                 if r.get("impos_yn") == "Y" and _NOTDEL(r)}
        for r in snap.table("t_prd_product_plate_sizes"):
            if not _NOTDEL(r):
                continue
            sc = r.get("siz_cd")
            if sc and sc not in valid:
                prd = r.get("prd_cd")
                is_item = any(_NOTDEL(ps) and ps.get("prd_cd") == prd and ps.get("siz_cd") == sc
                              for ps in snap.table("t_prd_product_sizes"))
                out.append(Defect(
                    dimension=self.dimension,
                    summary=(f"판형 오배선(PLATE_MISWIRE): siz_cd 가 유효 판형 아님"
                             + (" (완제품 사이즈를 판형으로 오배선)" if is_item else " (orphan 사이즈)")),
                    severity="medium", money_impact="none",
                    prd_cd=prd, comp_cd=sc,
                    evidence={"siz_nm": siz.get(sc, {}).get("siz_nm", ""), "impos_yn": siz.get(sc, {}).get("impos_yn", "")},
                    suggested_fix="유효 판형(impos_yn=Y)으로 재배선 또는 잘못 등록된 판형 제거",
                ))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # MISMATCH(high) + MISWIRE(medium) 둘 다 결함 → 이 차원 결함 0 이 종료.
        return not any(d.dimension == self.dimension for d in defects)
