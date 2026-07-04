"""OptionCpqDx — 옵션 파라미터 연결 끊김(저청구) 진단. ★신규(설계 §3 갭#5).

근거(이번 세션 실증): 메쉬현수막 타공 옵션 `dtl_opt` 누락 → 타공수 param 미공급 → 단가행 매칭 실패
→ 무료 = 저청구([[component-merge-pipeline-260704]]). 실무진이 webadmin 에서 옵션을 수정하다
파라미터 연결(dtl_opt)을 빠뜨리면 이 저청구가 생긴다 — 정확히 "데이터 배선 끊김" 결함.

연결 구조:
  옵션(t_prd_product_option_items).dtl_opt = 옵션이 공급하는 param({"타공수":4} 등)
  단가행(component_prices).dim_vals        = 단가행이 매칭에 요구하는 param({"타공수":6})
  엔진 match_component: 선택이 dim_vals 키·값을 공급해야 그 단가행 매칭 → 아니면 무료.

판정(OPT_PARAM_MISSING):
  옵션이 공정(ref_dim=OPT_REF_DIM.04·ref_key1=proc)을 참조하는데, 그 proc 단가행이 요구하는
  dim_vals 키 K 를 옵션 dtl_opt 가 미공급.
신뢰도(오탐 가드):
  HIGH   = 같은 (proc,K)를 dtl_opt 로 실제 채운 형제 옵션이 존재 → K 는 옵션선택형 param 확정
           → 이 빈 옵션은 끊긴 연결 = 저청구(메쉬 타공 부류). blocking.
  REVIEW = 아무 옵션도 K 를 dtl_opt 로 안 채움 → K 는 고객 수치입력(개수/줄수 등) 가능성 → 검토.
"""
from __future__ import annotations
import json
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect

_OPT_REF_PROC = "OPT_REF_DIM.04"   # 옵션 ref_dim = 공정 참조
_NOTDEL = lambda r: (r.get("del_yn") or "N") != "Y"


def _parse(js: str) -> dict:
    js = (js or "").strip()
    if not js or js in ("{}", "null"):
        return {}
    try:
        v = json.loads(js)
        return v if isinstance(v, dict) else {}
    except Exception:
        return {}


class OptionCpqDx(Diagnoser):
    dimension = "option_cpq"
    title = "옵션 파라미터 연결 끊김(저청구)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        oi = [r for r in snap.table("t_prd_product_option_items") if _NOTDEL(r)]
        proc_nm = {r["proc_cd"]: r.get("proc_nm", "")
                   for r in snap.table("t_proc_processes") if r.get("proc_cd")}

        # proc → 그 proc 단가행이 요구하는 dim_vals 키집합
        proc_req: dict[str, set] = defaultdict(set)
        for r in snap.table("t_prc_component_prices"):
            pc = r.get("proc_cd")
            dv = _parse(r.get("dim_vals"))
            if pc and dv:
                proc_req[pc].update(dv.keys())

        # (proc, key) → dtl_opt 로 실제 공급하는 옵션 수(=옵션선택형 param 입증)
        supplied: dict[tuple, int] = defaultdict(int)
        for r in oi:
            if r.get("ref_dim_cd") != _OPT_REF_PROC:
                continue
            proc = r.get("ref_key1")
            for k in _parse(r.get("dtl_opt")):
                supplied[(proc, k)] += 1

        out: list[Defect] = []
        for r in oi:
            if r.get("ref_dim_cd") != _OPT_REF_PROC:
                continue
            proc = r.get("ref_key1")
            req = proc_req.get(proc)
            if not req:
                continue
            have = set(_parse(r.get("dtl_opt")).keys())
            for k in sorted(req - have):
                sib = supplied.get((proc, k), 0)
                high = sib > 0                      # 형제가 채움 = 옵션선택형 param 확정
                pn = proc_nm.get(proc, proc)
                out.append(Defect(
                    dimension=self.dimension,
                    summary=(f"옵션 파라미터 연결 끊김(OPT_PARAM_MISSING): '{pn}' 옵션이 "
                             f"'{k}' 미공급 → 단가행 매칭 실패로 무료"
                             + ("" if high else " (수치입력 가능성·검토)")),
                    severity="high" if high else "low",
                    money_impact="undercharge" if high else "unknown",
                    prd_cd=r.get("prd_cd"), comp_cd=r.get("opt_cd"),
                    evidence={"proc_cd": proc, "proc_nm": pn, "missing_param": k,
                              "sibling_filled": sib, "dtl_opt": r.get("dtl_opt") or ""},
                    suggested_fix=(f"옵션 dtl_opt 에 '{k}' 값 채움(실무진 확인 — 이 옵션이 나타내는 "
                                   f"{k} 값). 형제 옵션 dtl_opt 패턴 참조. 값 날조 금지."),
                ))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # HIGH(저청구 확정)만 blocking. REVIEW(수치입력 가능성)는 advisory.
        return not any(d.dimension == self.dimension and d.severity == "high"
                       for d in defects)
