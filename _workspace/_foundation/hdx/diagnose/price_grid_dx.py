"""PriceGridDx — 가격격자(19시트) 무결성 진단. §26 배치 **어댑터**(재구현 0).

설계 §3: 가격격자 차원은 §26 huni-price-table-integrity 하네스의 배치(run_all.py+grid_diff.py)가
권위 엑셀 L1 CSV ↔ 라이브 스냅샷을 시트별 매트릭스로 diff 한다. 규모가 커서 hdx 가 재구현하지 않고
**그 배치를 호출**해 산출을 공통 Defect 로 변환만 한다(얇은 브릿지·[HARD] §26 로직 재사용).

보드 적정 입도: 셀 단위(수백 행)가 아니라 **시트×결함유형 요약** 1건씩(상세는 §26 ALL-SHEETS-defects.csv).
  DIFFED 시트   → 결함유형별(missing_cell·mismatch·transpose·dim_missing·sparse·prc_typ_typo·unmapped) 요약
  UNMAPPED 시트 → 매핑 미상(사람 확인) review 1건
  OUT_OF_SCOPE  → 제외(판걸이수·굿즈파우치 구간할인=t_dsc_* 타깃)

주의: §26 배치는 자체 SNAP=live-snapshot/latest 사용(--snap 미반영). §26 배치 미가용 시 graceful(빈 결과+note).
"""
from __future__ import annotations
import sys
import pathlib
from collections import defaultdict

from .base import Diagnoser
from ..foundation import Snapshot, Defect

_S26 = pathlib.Path(__file__).resolve().parents[3] / "huni-price-table-integrity" / "_batch" / "scripts"

# 결함유형 → (심각도, 돈영향)
_SEV = {"missing_cell": ("high", "undercharge"), "dim_missing": ("high", "undercharge"),
        "mismatch": ("high", "unknown"), "transpose": ("high", "unknown"),
        "missing_axis_cells": ("medium", "unknown"), "prc_typ_typo": ("medium", "unknown"),
        "unmapped": ("low", "unknown")}
_PENDING = {"UNMAPPED", "L2_PENDING", "AREA_PENDING"}


class PriceGridDx(Diagnoser):
    dimension = "price_grid"
    title = "가격격자 무결성(19시트·§26 어댑터)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        try:
            if str(_S26) not in sys.path:
                sys.path.insert(0, str(_S26))
            import run_all  # §26 배치(권위↔라이브 시트 diff)
            records = run_all.main()          # 전 19시트 배치(결정론·토큰0)·파일 산출은 §26 dir
        except Exception as e:                # 권위 CSV 부재·매퍼 오류 등 → graceful
            return [Defect(dimension=self.dimension, severity="low", money_impact="unknown",
                           summary=f"§26 가격격자 배치 미가용(graceful): {type(e).__name__}",
                           evidence={"error": str(e)[:160]},
                           suggested_fix="§26 huni-price-table-integrity 배치 환경 확인(권위 L1 CSV·매퍼)")]

        out: list[Defect] = []
        for rec in records:
            sheet = rec.get("sheet", "?")
            status = rec.get("status")
            if status == "OUT_OF_SCOPE":
                continue
            if status in _PENDING:
                out.append(Defect(
                    dimension=self.dimension, severity="low", money_impact="unknown",
                    summary=f"가격격자 매핑 미상({status}): '{sheet}' 시트 comp 매핑 미확정 → 사람 확인",
                    comp_cd=rec.get("comp_hint") or None,
                    evidence={"sheet": sheet, "route": rec.get("route", "")},
                    suggested_fix="§26 시트 comp 매핑 확정(매퍼 추가·날조 금지) 후 재diff",
                ))
                continue
            if status != "DIFFED":
                continue
            # DIFFED: 결함행을 유형별로 요약(셀 상세는 §26 CSV)
            by_type: dict[str, list] = defaultdict(list)
            for d in rec.get("defect_rows", []):
                by_type[d.get("defect", "?")].append(d)
            for dtype, drows in sorted(by_type.items()):
                sev, money = _SEV.get(dtype, ("medium", "unknown"))
                sample = "; ".join(str(d.get("key", "")) for d in drows[:4])
                out.append(Defect(
                    dimension=self.dimension, severity=sev, money_impact=money,
                    summary=(f"가격격자 결함({dtype}): '{sheet}' {len(drows)}셀 "
                             f"(권위 {rec.get('auth_cells')}·일치 {rec.get('direct_hit')} {rec.get('match_pct')}%)"),
                    comp_cd=rec.get("comp_hint") or None,
                    evidence={"sheet": sheet, "defect": dtype, "cells": len(drows),
                              "sample": sample[:160], "route": rec.get("route", ""),
                              "detail_csv": "huni-price-table-integrity/_batch/ALL-SHEETS-defects.csv"},
                    suggested_fix=("권위(가격표 260527)↔라이브 격자 정합: 미적재 셀 적재/transpose 교정/"
                                   "값 불일치 조사(§26 트랙·상세 CSV 참조·값 날조 금지)"),
                ))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # HIGH(돈크리티컬 격자 결함)만 blocking. 매핑 미상(low)은 advisory.
        return not any(d.dimension == self.dimension and d.severity == "high"
                       for d in defects)
