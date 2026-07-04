"""CalcabilityDx — 계산가능성(전 상품 PRICE≠0) 진단. 원본 사상=`score_batch.py`(PRICED-0/CALC).

★스코프 명시(no silent caps): 원본 score_batch 의 PRICED-0 은 라이브 simulate POST 로
케이스별 0원을 실측한다(네트워크·비결정). 여기서는 **결정론·토큰0 의 구조적 프록시**만 낸다 —
"공식은 바인딩됐는데 그 공식의 어느 wired 구성요소에도 단가행이 없어 엔진이 base 를 합산할
원천이 구조상 0" 인 상품(=PRICE 가 반드시 0). simulate 기반 정밀 PRICED-0(선택 조합별 0원)
확인은 **P4 적대적 재실측(engine verbatim/sim)** 으로 이관(HANDOFF '엔진 재실측 먼저' 결정).

WiringDx(comp 단위 DEAD_WIRE)와 렌즈가 다르다: 여기는 **상품 단위 롤업** = 파이프라인의
최종 종료술어(전 상품 PRICE≠0). 한 comp 만 죽어도 다른 comp 가 살아있으면 여기선 결함 아님.

판정:
  PRICED-0-STRUCT  상품이 공식 바인딩 보유·세트부모 아님인데, 그 공식(들)의 wired(비삭제)
                    구성요소 단가행 총합 0 → 엔진이 어떤 선택으로도 base 를 못 만듦(critical·저청구)
stop = PRICED-0-STRUCT 0.
"""
from __future__ import annotations
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect


class CalcabilityDx(Diagnoser):
    dimension = "calcability"
    title = "계산가능성(전 상품 PRICE≠0)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        # 상품 → 공식집합
        prod_frms = defaultdict(set)
        for r in snap.table("t_prd_product_price_formulas"):
            p, f = r.get("prd_cd"), r.get("frm_cd")
            if p and f:
                prod_frms[p].add(f)
        # 공식 → wired comp
        frm_comps = defaultdict(list)
        for r in snap.table("t_prc_formula_components"):
            f, c = r.get("frm_cd"), r.get("comp_cd")
            if f and c:
                frm_comps[f].append(c)
        # comp 논리삭제 집합
        deleted = {r["comp_cd"] for r in snap.table("t_prc_price_components")
                   if r.get("comp_cd") and (r.get("del_yn") or "N") == "Y"}
        # comp → 단가행 수
        price_rows = defaultdict(int)
        for r in snap.table("t_prc_component_prices"):
            c = r.get("comp_cd")
            if c:
                price_rows[c] += 1
        # 세트 부모(evaluate_set_price 경로 → 여기서 제외)
        set_parents = {r["prd_cd"] for r in snap.table("t_prd_product_sets")
                       if r.get("prd_cd") and (r.get("del_yn") or "N") != "Y"}
        # comp 이름(증거용)
        comp_nm = {r["comp_cd"]: r.get("comp_nm", "")
                   for r in snap.table("t_prc_price_components") if r.get("comp_cd")}

        out: list[Defect] = []
        for p, frms in sorted(prod_frms.items()):
            if p in set_parents:
                continue
            wired = []
            for f in frms:
                wired += [c for c in frm_comps.get(f, []) if c not in deleted]
            wired = sorted(set(wired))
            total_rows = sum(price_rows.get(c, 0) for c in wired)
            if total_rows == 0:
                reason = ("wired 구성요소 0" if not wired
                          else f"wired {len(wired)}개 전부 단가행 0")
                out.append(Defect(
                    dimension=self.dimension,
                    summary=f"계산불가(PRICED-0-STRUCT): 공식 바인딩 있으나 {reason} → PRICE 반드시 0",
                    severity="critical", money_impact="undercharge",
                    prd_cd=p, frm_cd=";".join(sorted(frms))[:60],
                    evidence={"wired": wired,
                              "wired_names": [comp_nm.get(c, "") for c in wired][:8]},
                    suggested_fix="공식에 base 단가행 보유 comp 배선/단가행 적재(§18 설계→§7 적재)",
                ))
        return out
