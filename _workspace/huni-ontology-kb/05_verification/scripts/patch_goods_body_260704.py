#!/usr/bin/env python3
"""33 드리프트 노드 본문 정정 (Phase 4·2026-07-04).

frontmatter에서 gap-goods-neither 참조를 제거했으나 본문 [[gap-goods-neither]] 링크가
references 엣지를 재생성(build_graph.py L381 add_edge doc)하므로 본문도 반드시 정정한다.
동작(본문=2nd '---' 이후만·값 CSV 전사):
  - [[gap-goods-neither]] / [[gap-goods-price-unloaded]] → [[gap-goods-fixed-lookup-no-formula]]
  - 프로즈 'NEITHER-gap' → '고정가룩업(07-04 재프라이싱 정정)'
  - # 제목 직후에 재프라이싱 정정 배너(고정가 값 전사) 삽입
대상: FIXED-LOOKUP 분류 & 본문에 gap-goods-neither/price-unloaded 링크 잔존 노드.
### [id] 블록노드 헤더는 미터치(정규식 [[ ]]·단어 치환뿐).
"""
import csv, os, re, sys

BASE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
KBP = os.path.join(BASE, "03_kb", "product")
CSVF = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reprice_goods_260704.csv")
DRY = "--apply" not in sys.argv

files = {}
for fn in os.listdir(KBP):
    if not fn.endswith(".md") or fn.endswith("-nodes.md"):
        continue
    p = os.path.join(KBP, fn)
    head = open(p, encoding="utf-8").read(600)
    m = re.search(r"^anchor:\s*t_prd_products/(PRD_\d+)", head, re.M)
    if m:
        files.setdefault(m.group(1), p)

rows = {r["prd_cd"]: r for r in csv.DictReader(open(CSVF, encoding="utf-8"))}
changed = []

for prd, r in rows.items():
    if r["classify"] != "FIXED-LOOKUP" or prd not in files:
        continue
    path = files[prd]
    txt = open(path, encoding="utf-8").read()
    m = re.match(r"^(---\n.*?\n---\n)(.*)$", txt, re.S)
    if not m:
        continue
    fm, body = m.group(1), m.group(2)
    if "[[gap-goods-neither]]" not in body and "[[gap-goods-price-unloaded]]" not in body:
        continue  # 이미 정정됐거나 링크 없음
    price = str(int(float(r["unit_price"])))
    reg = r["reg_dt"] or "?"
    nb = body
    nb = nb.replace("[[gap-goods-neither]]", "[[gap-goods-fixed-lookup-no-formula]]")
    nb = nb.replace("[[gap-goods-price-unloaded]]", "[[gap-goods-fixed-lookup-no-formula]]")
    nb = nb.replace("NEITHER-gap", "고정가룩업(07-04 재프라이싱 정정)")
    # 배너: 첫 '# 제목' 라인 직후 삽입
    banner = (f"\n> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 "
              f"`t_prd_product_prices`에 **고정가 {price}원**(reg_dt={reg}·07-04 SELECT 실측)이 실재한다. "
              f"스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — "
              f"[[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. "
              f"아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.\n")
    mt = re.search(r"^#\s+.+$", nb, re.M)
    if mt and "재프라이싱 정정(07-04 live·H-1" not in nb:
        i = mt.end()
        nb = nb[:i] + "\n" + banner + nb[i:]
    if nb != body:
        changed.append(prd)
        if not DRY:
            open(path, "w", encoding="utf-8").write(fm + nb)

print(f"{'DRY-RUN' if DRY else 'APPLIED'} body-fixed={len(changed)}")
print(" ", changed)
