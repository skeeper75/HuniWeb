"""DimConformanceDx — 차원 정합(돈 새는 차원 누락) 진단.
원본=`_workspace/huni-price-table-integrity/_batch/scripts/dim_conformance.py`.

원본은 라이브 psql 직접 조회. 여기서는 **동일 알고리즘을 공용 Snapshot 입력으로 포팅**
(갭#2 통일 로더·결정론·토큰0). 판정 로직(3자 조인·mat_typ 분리·HIGH/REVIEW·UNION 흡수)은 verbatim.

3자 조인(상품×component×차원):
  Face A use_dims  — component 가 선언한 차원(t_prc_price_components.use_dims)
  Face B 충전      — component_prices 에 실제 채워진 차원값(DISTINCT)
  Face C 선택수단  — 상품이 손님에게 그 차원을 고르게 하는 수단(sizes/materials/… + 옵션 환원)
판정:
  MISSING     Face C 에 있는데 union(Face B) 에 없음 = 손님선택 가능한데 단가행 0 → 돈샘(HIGH_DIMS=HIGH)
  UNDECLARED  Face B 채워졌는데 Face A(use_dims) 미선언 + 상품이 선택수단 보유 → silent 가산/무시(HIGH)
stop = HIGH 결함(MISSING-HIGH + UNDECLARED) 0. (MISSING-REVIEW·SURPLUS 는 advisory)
"""
from __future__ import annotations
import json
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect

# polymorphic 옵션참조차원 → component_prices 차원 컬럼 (원본 verbatim·.06 도수는 clr축이라 제외)
REFDIM = {'OPT_REF_DIM.01': 'siz_cd', 'OPT_REF_DIM.02': 'plt_siz_cd',
          'OPT_REF_DIM.03': 'mat_cd', 'OPT_REF_DIM.04': 'proc_cd',
          'OPT_REF_DIM.05': 'bdl_qty'}
CHECK_DIMS = ['siz_cd', 'plt_siz_cd', 'mat_cd', 'proc_cd', 'print_opt_cd', 'bdl_qty', 'opt_cd']
SKIP_DIMS = {'min_qty', 'siz_width', 'siz_height', 'coat_side_cnt', 'clr_cd'}
HIGH_DIMS = {'mat_cd', 'siz_cd', 'plt_siz_cd', 'bdl_qty'}
# Face C 선택수단 소스: (차원, 테이블, 컬럼)
SRC = [('siz_cd', 't_prd_product_sizes', 'siz_cd'),
       ('plt_siz_cd', 't_prd_product_plate_sizes', 'siz_cd'),   # 판형을 siz_cd 컬럼에 저장
       ('mat_cd', 't_prd_product_materials', 'mat_cd'),
       ('proc_cd', 't_prd_product_processes', 'proc_cd'),
       ('print_opt_cd', 't_prd_product_print_options', 'print_opt_cd'),
       ('bdl_qty', 't_prd_product_bundle_qtys', 'bdl_qty')]

_NOTDEL = lambda r: (r.get("del_yn") or "N") != "Y"


class DimConformanceDx(Diagnoser):
    dimension = "dim_conformance"
    title = "차원 정합(돈 새는 차원 누락)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        # 1. 상품→공식
        prod_frm = [(r["prd_cd"], r["frm_cd"])
                    for r in snap.table("t_prd_product_price_formulas")
                    if r.get("prd_cd") and r.get("frm_cd")]
        # 2. 공식→component
        frm_comp = defaultdict(list)
        for r in snap.table("t_prc_formula_components"):
            if r.get("frm_cd") and r.get("comp_cd"):
                frm_comp[r["frm_cd"]].append(r["comp_cd"])
        # mat_cd → mat_typ_cd (원판/부속 분리용)
        mat_typ = {r["mat_cd"]: (r.get("mat_typ_cd") or "")
                   for r in snap.table("t_mat_materials") if r.get("mat_cd")}
        # 3. component use_dims (proc_grp:* 등 그룹토큰은 차원 아님 → 제외)
        comp_dims = {}
        for r in snap.table("t_prc_price_components"):
            if (r.get("use_yn") or "Y") != "Y":
                continue
            c = r.get("comp_cd")
            if not c:
                continue
            try:
                arr = json.loads(r.get("use_dims") or "[]")
                comp_dims[c] = [d for d in arr if isinstance(d, str) and ':' not in d]
            except Exception:
                comp_dims[c] = []
        # 4. Face B — component_prices 충전 차원집합
        filled = defaultdict(lambda: defaultdict(set))
        for r in snap.table("t_prc_component_prices"):
            c = r.get("comp_cd")
            if not c:
                continue
            for dim in CHECK_DIMS:
                v = r.get(dim)
                if v and v.strip():
                    filled[c][dim].add(v)
        # 5. Face C — 상품 선택수단
        avail = defaultdict(lambda: defaultdict(set))
        for dim, tbl, col in SRC:
            for r in snap.table(tbl):
                if not _NOTDEL(r):
                    continue
                p, v = r.get("prd_cd"), r.get(col)
                if p and v and str(v).strip():
                    avail[p][dim].add(str(v))
        # 옵션 환원(polymorphic) + opt_cd 자체
        for r in snap.table("t_prd_product_option_items"):
            if not _NOTDEL(r):
                continue
            p, rd, rk, oc = r.get("prd_cd"), r.get("ref_dim_cd"), r.get("ref_key1"), r.get("opt_cd")
            if not p:
                continue
            dim = REFDIM.get(rd)
            if dim and rk:
                avail[p][dim].add(rk)
            if oc:
                avail[p]['opt_cd'].add(oc)

        # 6. 3자 조인 verdict → Defect
        out: list[Defect] = []
        for p, f in prod_frm:
            comps = frm_comp.get(f, [])
            dim_union = defaultdict(set)
            dim_comps = defaultdict(list)
            for c in comps:
                for d in comp_dims.get(c, []):
                    if d in CHECK_DIMS and d not in SKIP_DIMS:
                        dim_union[d] |= filled[c].get(d, set())
                        dim_comps[d].append(c)
            # (b) MISSING: avail - union
            for d, un in dim_union.items():
                av = avail[p].get(d, set())
                if not av:
                    continue
                if d == 'mat_cd' and un:
                    comp_typs = {mat_typ.get(m) for m in un if mat_typ.get(m)}
                    if comp_typs:
                        av = {m for m in av if mat_typ.get(m) in comp_typs}
                miss = av - un
                if miss:
                    high = d in HIGH_DIMS
                    cs = ','.join(sorted(set(dim_comps[d])))[:60]
                    out.append(Defect(
                        dimension=self.dimension,
                        summary=f"차원 누락(MISSING·{d}): 손님선택 {len(miss)}값이 단가행에 없음",
                        severity="high" if high else "medium",
                        money_impact="undercharge" if high else "unknown",
                        prd_cd=p, frm_cd=f, comp_cd=cs,
                        evidence={"dim": d, "missing_count": len(miss),
                                  "missing": ';'.join(sorted(miss))[:160]},
                        suggested_fix=f"누락 {d} 값에 단가행(component_prices) 적재",
                    ))
            # (c) UNDECLARED
            for c in comps:
                uds = comp_dims.get(c, [])
                for d in filled[c]:
                    if d in SKIP_DIMS or d in uds or d not in CHECK_DIMS:
                        continue
                    if filled[c][d] and avail[p].get(d):
                        out.append(Defect(
                            dimension=self.dimension,
                            summary=f"차원 미선언(UNDECLARED·{d}): 단가행 구분하나 use_dims 미선언(silent 가산/무시)",
                            severity="high", money_impact="unknown",
                            prd_cd=p, frm_cd=f, comp_cd=c,
                            evidence={"dim": d, "filled_count": len(filled[c][d])},
                            suggested_fix=f"comp use_dims 에 '{d}' 선언(엔진이 차원 인식하도록)",
                        ))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # 원본 돈크리티컬 = MISSING-HIGH + UNDECLARED(HIGH). REVIEW 는 advisory.
        return not any(d.dimension == self.dimension and d.severity == "high"
                       for d in defects)
