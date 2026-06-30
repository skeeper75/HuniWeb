# -*- coding: utf-8 -*-
"""준비도 뷰어 — webadmin 드롭인(읽기전용).

product_viewer(catalog/views.py:616) 패턴을 본떠, 상품 준비도 평가 결과
(product-details-final.json)를 admin 인증 하에 읽기전용으로 서빙한다.

★raw/webadmin 직접 수정 없음 — 이 파일을 catalog 앱에 추가하고 URL 1줄만 등록한다(README-integration.md).
표시 전용(저장/삭제 없음). 데이터는 빌드 산출 JSON 을 그대로 임베드.

데이터 소스 우선순위:
  1) settings.READINESS_DATA_JSON (있으면 그 경로)
  2) BASE_DIR/../_data/readiness/product-details-final.json (앱과 함께 번들한 사본)
둘 다 없으면 안내 메시지를 렌더(404 아님 — 운영 중단 방지).
"""
import json
from pathlib import Path

from django.conf import settings
from django.contrib import admin
from django.shortcuts import render


def _payload_path():
    """준비도 데이터 JSON 경로 해석(설정 우선 → 번들 사본 폴백)."""
    cand = getattr(settings, "READINESS_DATA_JSON", None)
    if cand:
        return Path(cand)
    # 앱과 함께 배포한 사본(권장: collect 시 _data/readiness/ 로 복사)
    return Path(settings.BASE_DIR).parent / "_data" / "readiness" / "product-details-final.json"


def _build_payload(products):
    """standalone build_dashboard.py 와 동일한 요약/파생 플래그(단일 진실)."""
    import collections

    cat_order, seen = [], set()
    grades = collections.Counter()
    calc_ok = widget_y = l3plus = 0
    comp_sum = 0.0
    for p in products:
        cat = p.get("상품군", "기타")
        if cat not in seen:
            seen.add(cat)
            cat_order.append(cat)
        grades[p.get("등급", "?")] += 1
        comp_sum += float(p.get("완성률", 0) or 0)
        ev = p.get("근거", "") or ""
        p["_priced0"] = "PRICED-0" in ev
        base = p.get("등급", "")
        gs = p.get("golden_status") or ""
        p["_preverify"] = (
            base in ("L0", "L1", "L1(기성)", "L2", "L2(반제품)")
            and "골든 미대조" not in gs
            and "PRICE>0" not in gs
        )
        if ("calc=OK" in ev or "PRICED" in ev) and "PRICED-0" not in ev:
            calc_ok += 1
        if p.get("widget_eligible") == "Y":
            widget_y += 1
        if base.startswith("L3") or base.startswith("L4"):
            l3plus += 1
    total = len(products)
    summary = {
        "total": total,
        "avg_completion": round(comp_sum / total, 1) if total else 0,
        "grades": dict(grades),
        "calc_ok": calc_ok,
        "calc_pct": round(calc_ok / total * 100) if total else 0,
        "widget_y": widget_y,
        "l3plus": l3plus,
    }
    return {"products": products, "summary": summary, "cat_order": cat_order}


def readiness_viewer(request):
    """상품 준비도 대시보드(읽기전용). admin each_context 로 Unfold 테마 상속."""
    path = _payload_path()
    try:
        products = json.loads(path.read_text(encoding="utf-8"))
        data = _build_payload(products)
        err = None
    except FileNotFoundError:
        data = {"products": [], "summary": {"total": 0, "avg_completion": 0, "grades": {},
                                            "calc_ok": 0, "calc_pct": 0, "widget_y": 0, "l3plus": 0},
                "cat_order": []}
        err = (f"준비도 데이터 JSON 을 찾을 수 없습니다: {path}\n"
               "settings.READINESS_DATA_JSON 을 설정하거나 _data/readiness/ 에 사본을 두세요.")

    ctx = {
        **admin.site.each_context(request),
        "title": "상품 준비도 대시보드",
        "data": data,
        "load_error": err,
    }
    return render(request, "catalog/readiness_viewer.html", ctx)
