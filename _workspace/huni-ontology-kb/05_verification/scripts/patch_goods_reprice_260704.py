#!/usr/bin/env python3
"""103 굿즈 재프라이싱 결정론 패처 (Phase 4 결함 교정·2026-07-04).

입력: reprice_goods_260704.csv (라이브 t_prd_product_prices/formulas 07-04 SELECT 결과).
동작(값 전부 CSV 전사·손전사 0):
  FIXED-LOOKUP: badge→verified · relations에서 gap-goods-neither/price-unloaded 제거 ·
                gap-goods-fixed-lookup-no-formula 참조 추가 · props에 fixed_price/가격상태 추가 ·
                sources에 라이브 가격 근거(07-04) 추가.
  색상 오염(197/198/227/241): uses_material→MAT_000255/MAT_000256 엣지 삭제.
  NEITHER/FORMULA: 이 스크립트 미대상(수동/별도).
frontmatter만 편집(라인 단위·YAML 유효 유지). 본문 블록노드(### [id]) 미터치.
"""
import csv, os, re, sys

BASE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
KBP = os.path.join(BASE, "03_kb", "product")
CSVF = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reprice_goods_260704.csv")
DRY = "--apply" not in sys.argv

# prd_cd -> filepath (primary product node, nodes.md 제외)
files = {}
for fn in os.listdir(KBP):
    if not fn.endswith(".md") or fn.endswith("-nodes.md"):
        continue
    p = os.path.join(KBP, fn)
    with open(p, encoding="utf-8") as f:
        head = f.read(600)
    m = re.search(r"^anchor:\s*t_prd_products/(PRD_\d+)", head, re.M)
    if m:
        files.setdefault(m.group(1), p)

rows = list(csv.DictReader(open(CSVF, encoding="utf-8")))
COLOR_MATS = ("material-MAT_000255", "material-MAT_000256")
COLOR_PRDS = {"PRD_000197", "PRD_000198", "PRD_000227", "PRD_000241"}

def split_fm(txt):
    m = re.match(r"^(---\n)(.*?\n)(---\n)(.*)$", txt, re.S)
    if not m:
        return None
    return m.group(1), m.group(2), m.group(3), m.group(4)

def block_range(fmlines, key):
    """frontmatter 블록 key(list/dict)의 라인 인덱스 [start(헤더), end(exclusive))."""
    start = None
    for i, ln in enumerate(fmlines):
        if re.match(rf"^{re.escape(key)}:\s*$", ln):
            start = i; break
    if start is None:
        return None
    end = len(fmlines)
    for j in range(start + 1, len(fmlines)):
        if re.match(r"^[A-Za-z_가-힣]", fmlines[j]):  # 다음 top-level key
            end = j; break
    return start, end

changed = 0
summary = {"fixed_reclass": [], "fixed_gapref_only": [], "fixed_prop_only": [],
           "color_del": [], "unchanged": []}

for r in rows:
    prd = r["prd_cd"]; cls = r["classify"]
    if prd not in files:
        continue
    do_color = prd in COLOR_PRDS
    if cls != "FIXED-LOOKUP" and not do_color:
        continue
    path = files[prd]
    txt = open(path, encoding="utf-8").read()
    parts = split_fm(txt)
    if not parts:
        print("NO-FM", prd); continue
    o, fm, c, body = parts
    fmlines = fm.splitlines()
    orig = list(fmlines)
    note = []

    # --- 색상 오염 삭제 (uses_material → MAT_000255/256) ---
    if do_color:
        before = len(fmlines)
        fmlines = [ln for ln in fmlines
                   if not (re.search(r"rel:\s*uses_material", ln)
                           and any(cm in ln for cm in COLOR_MATS))]
        if len(fmlines) != before:
            note.append("color-del")
            summary["color_del"].append(prd)

    if cls == "FIXED-LOOKUP":
        price = r["unit_price"]
        priceint = str(int(float(price)))
        reg = r["reg_dt"] or "?"
        # 1) badge candidate -> verified
        for i, ln in enumerate(fmlines):
            if re.match(r"^badge:\s*candidate\s*$", ln):
                fmlines[i] = "badge: verified"; note.append("badge")
        # 2) relations: neither/price-unloaded 제거
        rr = block_range(fmlines, "relations")
        if rr:
            s, e = rr
            kept = []
            for ln in fmlines[s+1:e]:
                if ("gap-goods-neither" in ln or "gap-goods-price-unloaded" in ln):
                    note.append("rm-neither"); continue
                kept.append(ln)
            has_fixed = any("gap-goods-fixed-lookup-no-formula" in ln for ln in kept)
            if not has_fixed:
                kept.append('  - {rel: references, target: gap-goods-fixed-lookup-no-formula, '
                            'note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}')
                note.append("+fixedgap")
            fmlines = fmlines[:s+1] + kept + fmlines[e:]
        # 3) props: fixed_price / 가격상태 추가·NEITHER 아키타입 정정
        pr = block_range(fmlines, "props")
        if pr:
            s, e = pr
            pblock = fmlines[s+1:e]
            # NEITHER 아키타입 라인 정정
            for i, ln in enumerate(pblock):
                if re.match(r"^\s*가격아키타입:", ln) and "NEITHER" in ln:
                    pblock[i] = f'  가격아키타입: "fixed-lookup(t_prd_product_prices 단일 unit_price·frm_cd 없음)"'
                    note.append("fix-archetype")
            has_fp = any(re.match(r"^\s*fixed_price:", ln) for ln in pblock)
            if not has_fp:
                pblock.append(f'  fixed_price: "{priceint}원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"')
                note.append("+fixed_price")
            has_state = any(re.match(r"^\s*가격상태:", ln) for ln in pblock)
            if not has_state:
                pblock.append(f'  가격상태: "고정가룩업·{priceint}원(unit_price·transcribed·07-04 live·reg_dt={reg})"')
                note.append("+state")
            fmlines = fmlines[:s+1] + pblock + fmlines[e:]
        # 4) sources: 라이브 가격 근거 추가(없으면)
        sr = block_range(fmlines, "sources")
        if sr:
            s, e = sr
            sblock = fmlines[s+1:e]
            has_pxsrc = any("t_prd_product_prices" in ln for ln in sblock)
            if not has_pxsrc:
                sblock.append(f'  - {{source_file: "live t_prd_product_prices (07-04 SELECT·reprice_goods_260704)", '
                              f'source_locator: "키:{prd} unit_price={price}·reg_dt={reg}·frm 0행(고정가룩업)", '
                              f'captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}}')
                note.append("+pxsrc")
            fmlines = fmlines[:s+1] + sblock + fmlines[e:]

        # 분류 집계
        if "+fixedgap" in note and "badge" in note:
            summary["fixed_reclass"].append(prd)
        elif "+fixedgap" in note:
            summary["fixed_gapref_only"].append(prd)
        else:
            summary["fixed_prop_only"].append(prd)

    if fmlines == orig:
        summary["unchanged"].append(prd); continue

    newtxt = o + "\n".join(fmlines) + "\n" + c + body
    changed += 1
    if not DRY:
        open(path, "w", encoding="utf-8").write(newtxt)

print(f"{'DRY-RUN' if DRY else 'APPLIED'} changed={changed}")
for k, v in summary.items():
    print(f"  {k}: {len(v)}  {v if len(v)<=40 else ''}")
