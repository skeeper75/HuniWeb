"""ComponentMergeDx — 같은차원 분리 comp(병합 후보) 진단. 원본=`_foundation/batch/component_merge_scan.py`.

승계: 원본의 검증된 순수 헬퍼·상수(parse_use_dims·latest_rows·col_value_sets·
grid_signature·common_prefix_group·DIM_COLS·CHOICE_AXES·CANONICAL_CHOICE·KIND_AXES)를
그대로 import 하고, 원본 main() 의 클러스터 분류 루프를 Snapshot 입력으로 재바인딩(갭#2 통일 로더)
하여 유형 A/B 후보만 Defect 로 낸다. 분류 규칙(유형 A·B·LEGIT·ARTIFACT)은 verbatim.

[HARD] 병합/분리 기준(memory: price-component-unify-vs-split-criterion-260630):
  유형 A = 손님선택 축(print_opt/mat/siz/coat/plt_siz…) 분리 → 한 comp 로 병합 후보
  유형 B = 격자 verbatim 동일(동형결합 dedup)
  KIND 축(proc_cd/clr_cd) varying = 종류 분리 → LEGIT(병합 금지·결함 아님)

★스냅샷 시점 주의: 병합 9군은 이번 세션 라이브 COMMIT(2a2dddf) 완료됐으나 latest 스냅샷은
그 이전 사본(snap_20260702) → 후보가 남아 보일 수 있음. 게이트 단계는 라이브 재-SELECT(메모리 H-1).
"""
from __future__ import annotations
import sys
import pathlib
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "batch"))
import component_merge_scan as cms  # noqa: E402


class ComponentMergeDx(Diagnoser):
    dimension = "component_merge"
    title = "가격구성요소 병합 후보"

    def scan(self, snap: Snapshot) -> list[Defect]:
        pc = snap.table("t_prc_price_components")
        fc = snap.table("t_prc_formula_components")
        cp = snap.table("t_prc_component_prices")

        comp = {r["comp_cd"]: r for r in pc}
        comp2frm = defaultdict(set)
        for x in fc:
            comp2frm[x["comp_cd"]].add(x["frm_cd"])

        rows_by_comp = defaultdict(list)
        for r in cp:
            rows_by_comp[r["comp_cd"]].append(r)

        active = [c for c, r in comp.items() if r.get("use_yn") == "Y"]

        # 클러스터: (배선 공식집합, use_dims 시그니처) — 원본 verbatim
        clusters = defaultdict(list)
        for c in active:
            key = (frozenset(comp2frm.get(c, frozenset())),
                   cms.parse_use_dims(comp[c].get("use_dims", "")))
            clusters[key].append(c)

        out: list[Defect] = []
        for (frm, _udims), members in clusters.items():
            if len(members) < 2:
                continue
            members = sorted(members)

            lcp = cms.common_prefix_group(members)
            lcp_depth = len([t for t in lcp.split("_") if t])
            is_sibling_family = lcp_depth >= 2 and lcp not in ("COMP_PP",)

            latest = {c: cms.latest_rows(rows_by_comp.get(c, [])) for c in members}
            vsets = {c: cms.col_value_sets(latest[c]) for c in members}
            gsig = {c: cms.grid_signature(latest[c]) for c in members}

            all_cols = set()
            for c in members:
                all_cols |= set(vsets[c].keys())
            varying_cols = set()
            for col in all_cols:
                svals = [vsets[c].get(col, frozenset()) for c in members]
                nonempty = [s for s in svals if s]
                if not nonempty:
                    continue
                if not (len(nonempty) == len(members) and all(s == nonempty[0] for s in nonempty)):
                    varying_cols.add(col)

            base = lcp if lcp.startswith("COMP_") else "COMP_" + lcp

            # 유형 B: 전 comp 격자 verbatim 동일
            sigs = {gsig[c] for c in members}
            if len(sigs) == 1 and next(iter(sigs)):
                out.append(Defect(
                    dimension=self.dimension,
                    summary=f"병합 후보(유형 B·동형결합 dedup): {base} ({len(members)}→1)",
                    severity="low", money_impact="none",
                    evidence={"members": members, "reason": "격자 verbatim 동일"},
                    suggested_fix="동형 comp dedup(정본 1개로 통합·나머지 use_yn=N)",
                ))
                continue

            if not is_sibling_family:
                continue  # ARTIFACT(조대키) = 후보 아님

            # KIND 축 varying = 종류 분리 → LEGIT(병합 금지·결함 아님)
            if varying_cols & cms.KIND_AXES:
                continue

            # 격자충돌 + 엔진코드변경 판정
            merged, conflict = {}, False
            for c in members:
                for r in latest[c]:
                    key = tuple((r.get(k) or "").strip() for k in cms.DIM_COLS)
                    up = str(r.get("unit_price") or "").strip()
                    if key in merged and merged[key] != up:
                        conflict = True
                    merged[key] = up
            engine_change = not (varying_cols <= set(_udims))

            combo = {c: tuple(tuple(sorted(vsets[c].get(col, frozenset())))
                              for col in sorted(varying_cols)) for c in members}
            disjoint_tiling = len(set(combo.values())) == len(members)

            # 유형 A: 손님선택 축 분리 + 정본 상품축 포함 + 고유타일링 + 충돌X + 엔진변경X
            if (varying_cols and varying_cols <= cms.CHOICE_AXES
                    and (varying_cols & cms.CANONICAL_CHOICE)
                    and disjoint_tiling and not conflict and not engine_change):
                out.append(Defect(
                    dimension=self.dimension,
                    summary=f"병합 후보(유형 A·손님선택 축 분리): {base} ({len(members)}→1)",
                    severity="medium", money_impact="unknown",
                    evidence={"members": members, "split_cols": sorted(varying_cols),
                              "engine_change": engine_change, "merge_conflict": conflict},
                    suggested_fix="같은차원 분리 comp 를 정본 1개로 병합(단가 verbatim 불변·이중합산 방지)",
                ))
            # 그 외(REVIEW·LEGIT)는 결함 아님(수동 판정) → 제외(원본과 동일)
        return out
