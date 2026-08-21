#!/usr/bin/env python3
"""harvest_sim_meta.py — 266 활성 상품의 sim-meta read-only 덤프 (SPEC-WIDGET-WIRING-001 M3).

위젯 임베드 config(widget_api._runtime_meta)와 관리자 시뮬레이터가 공유하는 빌더
`price_views._build_sim_meta(prd_cd, customer=True)` 를 그대로 호출해 상품별 JSON 으로 덤프한다.
[HARD] 읽기 전용 — 조회 전용 빌더만 호출, write 경로 호출 금지. 원본 수정 금지.

고객 가시성 태깅(R4): widget_api._runtime_meta 가 노출하는 상위 키 집합을 상수로 복사해
각 상품 JSON 의 visibility.customer_visible_top 에 기록한다(내부 가격모델 필드는 internal_top).
예외 상품은 {"error": ...} 로 기록하고 계속(전수 중단 금지 — R4).

사용: ../.venv/bin/python bin/harvest_sim_meta.py   (cwd=raw/webadmin · 268상품 수 분 소요)
"""
import json
import os
import pathlib
import sys
import time

HERE = pathlib.Path(__file__).resolve()                    # _workspace/huni-widget-wiring/bin/
WEBADMIN = HERE.parents[3] / "raw" / "webadmin"
OUT = HERE.parent.parent / "out" / "sim-meta"

sys.path.insert(0, str(WEBADMIN / "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
import django  # noqa: E402
django.setup()
from django.db import connection  # noqa: E402
from catalog import price_views as PV  # noqa: E402

# widget_api._runtime_meta 출력 상위 키(widget_api.py:446-465) — 고객 가시 화이트리스트 복사본.
# 원본이 바뀌면 이 상수도 따라가야 한다(spec §1.2: 하이라키 정본 = sim-meta 산출 그대로).
VISIBLE_TOP = {
    "prd_cd", "prd_nm", "prod_dims", "opt_groups", "file_upload_yn", "editor_yn",
    "apply_pos", "qty_rule", "constraints", "set_members",
}


def q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return [r[0] for r in c.fetchall()]


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    prd_cds = q("SELECT prd_cd FROM t_prd_products WHERE use_yn='Y' AND del_yn='N' ORDER BY prd_cd")
    print(f"분모(활성 상품): {len(prd_cds)}")
    t0 = time.time()
    n_err = 0
    for i, prd_cd in enumerate(prd_cds, 1):
        rec = {"prd_cd": prd_cd, "snapshot": None}
        try:
            meta = PV._build_sim_meta(prd_cd, customer=True)
            members = PV._set_members_meta(prd_cd, meta.get("page_rule"), customer=True)
            meta["set_members"] = members
            rec["meta"] = meta
            rec["visibility"] = {
                "customer_visible_top": sorted(VISIBLE_TOP & set(meta.keys())),
                "internal_top": sorted(set(meta.keys()) - VISIBLE_TOP),
            }
        except Exception as e:                                    # noqa: BLE001
            n_err += 1
            rec["error"] = f"{type(e).__name__}: {e}"
        p = OUT / f"{prd_cd}.json"
        p.write_text(json.dumps(rec, ensure_ascii=False, default=str), encoding="utf-8")
        if i % 40 == 0:
            print(f"  {i}/{len(prd_cds)} ({time.time()-t0:.0f}s) · error {n_err}")
    print(f"완료: {len(prd_cds)}상품 · 예외 {n_err} · {time.time()-t0:.0f}s -> {OUT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
