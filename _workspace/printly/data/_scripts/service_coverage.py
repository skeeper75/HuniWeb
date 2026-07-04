#!/usr/bin/env python
"""프린틀리 서비스 상품군 커버리지 맵 — 와우 24 상품군 전개(09 정책 실현).

지니 "24 상품군을 프린틀리 서비스로 전개해 상품군수 확보". 이미 등록된 와우 324상품·24카테고리
(_workspace/huni-multibrand-ontology/04_wow-registration/wow-products.json)를 프린틀리가 실제
제공하는 상품군 목록으로 펼친다. 각 상품군 = [상품수 · 와우 대표 · 후니 정렬(same_family) · 게이트
판정 · 배정 후보]. 후니 매칭 있으면 양벤더(후니 기본), 없으면 와우 단독(강제).

★값 지어내기 0: 상품군·상품수=등록 데이터. 정렬·판정=family-alignment/family-verdicts. 가격 없음(별도 배정표).
실행: python3 _workspace/printly/data/_scripts/service_coverage.py
"""
import os, json
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.abspath(os.path.join(HERE, ".."))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
MBO = os.path.join(REPO, "_workspace", "huni-multibrand-ontology")
WOW_PRODUCTS = os.path.join(MBO, "04_wow-registration", "wow-products.json")
VERDICTS = os.path.join(MBO, "02_crossbrand", "family-verdicts.json")
OUT = os.path.join(DATA, "sourcing", "wow-service-coverage-260705.md")

# 와우 카테고리(24) → 후니 정렬쌍(family-alignment A-1~A-16). None=후니 미정렬(정렬 확장 필요/와우 단독).
CAT2PAIR = {
    "명함": "A-1", "스티커": "A-2", "사인제품": "A-4", "책자": "A-5", "전단": "A-7",
    "홍보물": "A-6", "자석제품": "A-12", "어패럴": "A-16", "굿즈/다꾸": "A-14",
    "판촉물": "A-14", "행택/쿠폰/안내장": "A-3", "캘린더": "A-8", "봉투": "A-9",
    "부자재": "A-9", "홀더": "A-10", "폰 액세서리": "A-11",
    # 후니 미정렬 — 와우 단독 or 정렬 확장 필요
    "선거홍보물": None, "카페용품": None, "팬시제품": None, "서식류": None,
    "디지털인쇄": None, "포토/액자": None, "와우기획상품": None, "시스템상품": None,
}
# 정렬 미완 상품군의 성격(정직): 확정 와우단독 vs 정렬 확장 후보(후니 존재 가능)
UNALIGNED_NOTE = {
    "카페용품": "와우 단독(후니 미대응·POP 실증)", "선거홍보물": "와우 단독 경향(캠페인버튼만 A-15 부분)",
    "와우기획상품": "와우 단독(와우 기획전)", "시스템상품": "와우 단독(와우 플랫폼 상품)",
    "팬시제품": "정렬 확장 후보(후니 스티커/굿즈 인접)", "서식류": "정렬 확장 후보(후니 대응 확인 필요)",
    "디지털인쇄": "정렬 확장 후보(후니 디지털 인쇄 존재)", "포토/액자": "정렬 확장 후보(후니 포토북/액자 인접)",
}


def cat_of(rec):
    c = rec.get("category")
    return (c[0] if c else None) if isinstance(c, list) else c


def main():
    prods = json.load(open(WOW_PRODUCTS, encoding="utf-8"))
    verdicts = json.load(open(VERDICTS, encoding="utf-8")).get("verdicts", {})
    groups = defaultdict(list)
    for pid, rec in prods.items():
        groups[cat_of(rec)].append((pid, rec.get("name", "")))

    rows = []
    for cat, items in sorted(groups.items(), key=lambda kv: -len(kv[1])):
        pair = CAT2PAIR.get(cat, "?")
        rep = items[0][1] if items else ""
        if pair and pair in verdicts:
            v = verdicts[pair]
            vk = v["verdict"]
            hfam = v["family"]
            if vk == "GO":
                assign, badge = "후니 기본(양벤더)", "GO"
            elif vk == "DOWNGRADE":
                assign, badge = "후니 기본·사양주의(양벤더)", "DOWNGRADE"
            else:  # NO_GO
                assign, badge = "후니 기본·재앵커 필요", "NO_GO"
            match = f"{pair} {hfam} [{badge}]"
        else:
            assign = "와우 단독(강제)"
            match = UNALIGNED_NOTE.get(cat, "후니 미정렬")
        rows.append((cat, len(items), rep, match, assign))

    aligned = sum(1 for r in rows if not r[4].startswith("와우 단독"))
    wowonly = len(rows) - aligned
    total = sum(r[1] for r in rows)

    md = [f"# 프린틀리 서비스 상품군 커버리지 맵 — 와우 24 상품군 전개 (2026-07-05)",
          "",
          "> 09_vendor-sourcing-policy.md 실현. 지니 '24 상품군 서비스 전개'. 등록 데이터(와우 324·24군)를",
          "> 프린틀리 제공 상품군으로 펼침. 정렬=family-alignment 16쌍·판정=family-verdicts. **가격 별도**(배정표).",
          "",
          f"**★프린틀리 확보 상품군 = {len(rows)}개** (와우 {total}상품). 양벤더(후니 정렬) {aligned}군 · 와우 단독/미정렬 {wowonly}군.",
          "",
          "| 상품군(와우) | 상품수 | 와우 대표 | 후니 정렬·판정 | 배정 후보 |",
          "|---|---|---|---|---|"]
    for cat, n, rep, match, assign in rows:
        md.append(f"| {cat} | {n} | {rep} | {match} | **{assign}** |")
    md += ["",
           "## 요약",
           f"- **양벤더 가능(후니 정렬됨) {aligned}군**: 후니 기본 배정·와우 전환 가능. 배정표(sourcing_table)로 가격·능력 대조.",
           f"- **와우 단독/미정렬 {wowonly}군**: 후니 미대응(와우 강제) 또는 family-alignment 미확장.",
           "  - 확정 와우 단독: 카페용품·선거홍보물·와우기획상품·시스템상품.",
           "  - **정렬 확장 후보(후니 존재 가능)**: 팬시제품·서식류·디지털인쇄·포토/액자 → family-alignment 추가 정렬 시 양벤더 승격.",
           "- **다음**: ①정렬 확장 후보 4군 후니 매칭 조사(양벤더 승격) ②상품군별 와우 대표 가격 fetch(배정표 확장) ③쿠폰 A-13 재앵커.",
           "- 각 상품군의 구성요소·제약은 이미 온톨로지 등록됨(wow-products/components.json). 이 맵=서비스 제공 목록.",
           ""]
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8").write("\n".join(md))

    print("=" * 90)
    print(f"프린틀리 서비스 상품군 커버리지 — 와우 {len(rows)}군 · {total}상품")
    print(f"  양벤더(후니 정렬) {aligned}군 · 와우 단독/미정렬 {wowonly}군")
    print("=" * 90)
    for cat, n, rep, match, assign in rows:
        print(f"  {cat:<14} {n:>3}상품  {assign:<22} [{match}]")
    print(f"\n표 저장: {os.path.relpath(OUT, DATA)}")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
