"""MutableSnapshot — 스냅샷에 교정(mutation)을 in-memory 적용한 오버레이(P4 재실측용).

교정 전/후를 비교하려면 라이브를 건드리지 않고 교정본을 스냅샷 사본에 적용해야 한다. 이 래퍼는
`Fix.mutation`({table,key,set})을 `table()` 반환 시점에 덧씌운다(원본 캐시 불변·읽기전용 유지).
Diagnoser·engine_rows 는 모두 `snap.table()` 을 거치므로 오버레이가 그대로 전파된다.

[HARD] 라이브 미변경. 이 오버레이는 순수 in-memory(적재 아님). 값 날조 없는 auto_data mutation 만.
"""
from __future__ import annotations
import json

from ..foundation import Snapshot


class MutableSnapshot(Snapshot):
    """base 스냅샷 + mutation 리스트. table(name) 이 해당 테이블에 mutation 을 적용해 반환."""

    def __init__(self, snap_dir=None, mutations=None):
        super().__init__(snap_dir)
        self._mutations = list(mutations or [])
        self._overlay_cache: dict[str, list[dict]] = {}

    def add(self, mutation: dict):
        self._mutations.append(mutation)
        self._overlay_cache.clear()
        return self

    def table(self, name: str) -> list[dict]:
        muts = [m for m in self._mutations if m.get("table") == name]
        if not muts:
            return super().table(name)
        if name in self._overlay_cache:
            return self._overlay_cache[name]
        base = super().table(name)          # 원본(캐시·불변)
        out = []
        for r in base:
            rr = dict(r)                    # 복사(원본 캐시 보호)
            for m in muts:
                if all(str(rr.get(k)) == str(v) for k, v in m.get("key", {}).items()):
                    for col, val in m.get("set", {}).items():
                        # CSV 원본은 문자열 — JSON 컬럼(use_dims 등)은 문자열로 직렬화해야
                        # 소비자(Diagnoser 의 json.loads)와 형식 일치.
                        rr[col] = (json.dumps(val, ensure_ascii=False)
                                   if isinstance(val, (list, dict)) else val)
            out.append(rr)
        self._overlay_cache[name] = out
        return out
