"""라이브 스냅샷 CSV 로더 — 파편 스캐너들의 복붙 로더를 공통 추출.

승계: wiring_scan.py/contribution_scan.py 의 CSV 로더·ACTIVE 람다·경로계산.
설계 청사진 갭#2(4개 미니 생태계가 CSV 로더를 제각각 재구현) 해소.

경로: _foundation/live-snapshot/latest/ (없으면 최신 snap_* 디렉토리).
[HARD] 결정론·토큰0·읽기전용. 스냅샷은 라이브의 시점 사본(드리프트 주의: 병행 세션 적재 시
게이트/교정 단계는 라이브 재-SELECT 로 재확인 — 메모리 H-1 드리프트 교훈).
"""
from __future__ import annotations
import csv
import json
import pathlib

_HERE = pathlib.Path(__file__).resolve().parent          # hdx/foundation/
_FND = _HERE.parent.parent                               # _foundation/
SNAP_ROOT = _FND / "live-snapshot"

# use_yn=N 또는 del_yn=Y = 비활성(논리삭제). 스캐너 공통 필터.
ACTIVE = lambda r: (r.get("use_yn", "Y") != "N") and (r.get("del_yn", "N") != "Y")

# 엔진 매칭에 쓰이는 차원 컬럼 — CSV 빈칸('')을 None(와일드카드)으로 정규화해야 한다.
_ENGINE_DIM_COLS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                    "clr_cd", "coat_side_cnt", "bdl_qty", "siz_width", "siz_height",
                    "min_qty", "apply_ymd")


def _resolve_snap_dir(snap_dir=None) -> pathlib.Path:
    if snap_dir is not None:
        return pathlib.Path(snap_dir)
    latest = SNAP_ROOT / "latest"
    if latest.exists():
        return latest
    snaps = sorted([p for p in SNAP_ROOT.glob("snap_*") if p.is_dir()])
    if not snaps:
        raise FileNotFoundError(f"스냅샷 없음: {SNAP_ROOT}/latest 또는 snap_* 부재")
    return snaps[-1]


class Snapshot:
    """라이브 t_* 스냅샷 CSV 접근자(테이블별 lazy 캐시)."""

    def __init__(self, snap_dir=None):
        self.dir = _resolve_snap_dir(snap_dir)
        self._cache: dict[str, list[dict]] = {}

    # ── 원시 테이블(CSV verbatim) ────────────────────────────────────
    def table(self, name: str) -> list[dict]:
        """t_<name>.csv 를 dict 리스트로(빈칸=''·JSON 미파싱). name 예: 't_prc_price_components'."""
        if name in self._cache:
            return self._cache[name]
        path = self.dir / f"{name}.csv"
        rows = []
        if path.exists():
            with path.open(encoding="utf-8", newline="") as f:
                rows = list(csv.DictReader(f))
        self._cache[name] = rows
        return rows

    def active(self, name: str) -> list[dict]:
        """use_yn=Y·del_yn≠Y 만."""
        return [r for r in self.table(name) if ACTIVE(r)]

    # ── 가격 도메인 편의 접근자 ──────────────────────────────────────
    def price_components(self, active_only=True) -> list[dict]:
        n = "t_prc_price_components"
        return self.active(n) if active_only else self.table(n)

    def formula_components(self) -> list[dict]:
        return self.table("t_prc_formula_components")

    def component_prices(self) -> list[dict]:
        return self.table("t_prc_component_prices")

    def price_formulas(self) -> list[dict]:
        return self.table("t_prc_price_formulas")

    def product_price_formulas(self) -> list[dict]:
        return self.table("t_prd_product_price_formulas")

    # ── 엔진 매칭용 정규화 단가행 ────────────────────────────────────
    def engine_rows(self, comp_cd: str | None = None) -> list[dict]:
        """component_prices 를 engine.match_component 이 먹는 형태로 정규화.
          · 차원 컬럼 빈칸('') → None(와일드카드)
          · dim_vals(JSON 문자열) → dict
        comp_cd 지정 시 그 comp 의 단가행만.
        """
        out = []
        for r in self.component_prices():
            if comp_cd is not None and r.get("comp_cd") != comp_cd:
                continue
            row = dict(r)
            for c in _ENGINE_DIM_COLS:
                if row.get(c) == "":
                    row[c] = None
            dv = row.get("dim_vals")
            if isinstance(dv, str) and dv.strip():
                try:
                    row["dim_vals"] = json.loads(dv)
                except Exception:
                    row["dim_vals"] = {}
            elif not isinstance(dv, dict):
                row["dim_vals"] = {}
            out.append(row)
        return out
