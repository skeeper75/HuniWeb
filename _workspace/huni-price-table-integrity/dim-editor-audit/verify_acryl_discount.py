#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
아크릴 7상품 수량할인 배선 교정 검증 (webadmin 시뮬레이터 실화면).
qty 100(20% 구간)에서 discounts[] 가 채워지면 배선 성공. 교정 전=전부 빈배열(baseline).
라이브 읽기전용(시뮬레이터 POST=가격계산 읽기 전용).
"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "_foundation", "batch"))
import lib_huni as L
L.load_env()

TARGETS = [("PRD_000152","아크릴명찰"),("PRD_000148","아크릴뱃지"),("PRD_000157","아크릴네임택"),
           ("PRD_000150","아크릴스마트톡"),("PRD_000151","맥세이프 스마트톡"),
           ("PRD_000159","아크릴 코스터"),("PRD_000158","아크릴 포카키링")]

sim = L.HuniSim()
print(f"{'prd_cd':13} {'상품명':16} {'qty100 total':>13} {'할인적용':>8} {'라벨'}")
for pcd, nm in TARGETS:
    m = sim.sim_meta(pcd)
    mat = None
    for d in m.get("prod_dims", []):
        if d["name"] == "mat_cd" and d.get("options"):
            mat = d["options"][0]["v"]
    sel = {"mat_cd": mat, "siz_width": "50", "siz_height": "50"}
    r = sim.simulate(pcd, sel, 100)
    dsc = r.get("discounts", [])
    total = r.get("final_price")
    label = dsc[0]["label"] if dsc else "(없음)"
    mark = f"{dsc[0]['value']}%" if dsc else "❌ 없음"
    print(f"{pcd:13} {nm[:14]:16} {str(total):>13} {mark:>8} {label}")
