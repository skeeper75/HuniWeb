#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
스티커 공유 축 통합(consolidation) — 병렬 스티커 빌더가 각자 product-local로 중복 mint한
공유 원자(category/material/process/size/plate/formula/component)를 shared axis/formula로
단일 소유권 이관하고, 전 product-local 사본을 제거한다(중복 id 0·hard L-3 해소).

- 결정론: 같은 입력 → 같은 출력(블록 verbatim 이동·값 손전사 없음).
- 블록 경계: '### [id] ...' 헤더 ~ 다음 '### '/'## '/'---' 마커 직전(마커·섹션헤더 보존).
- OWNER 파일의 블록을 canonical로 추출→target shared 파일에 append(1회). 전 파일에서 해당 id 블록 삭제.
"""
import os, re, sys

KB = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "03_kb"))
PROD = os.path.join(KB, "product")
AXIS = os.path.join(KB, "axis")
FORM = os.path.join(KB, "formula")

# id -> (owner_file_basename, target_shared_relpath)
CATS = "axis/categories.md"; SIZES = "axis/sizes.md"; MATS = "axis/materials.md"
PROCS = "axis/processes.md"; PLATES = "axis/plate-sizes.md"
FORMULAS = "formula/sticker-formulas.md"; COMPS = "formula/sticker-components.md"

MOVE = {
    # categories
    "category-CAT_000002": ("product-052-sticker-halfcut-freeform-nodes.md", CATS),
    "category-CAT_000309": ("product-052-sticker-halfcut-freeform-nodes.md", CATS),
    "category-CAT_000037": ("sticker-spec-rectangle-nodes.md", CATS),
    "category-CAT_000311": ("sticker-tattoo-nodes.md", CATS),
    "category-CAT_000312": ("sticker-pack-nodes.md", CATS),
    # sizes
    "size-SIZ_000057": ("product-052-sticker-halfcut-freeform-nodes.md", SIZES),
    "size-SIZ_000520": ("product-052-sticker-halfcut-freeform-nodes.md", SIZES),
    "size-SIZ_000170": ("product-052-sticker-halfcut-freeform-nodes.md", SIZES),  # defect dual
    "size-SIZ_000197": ("product-055-sticker-sheet-freeform-nodes.md", SIZES),
    "size-SIZ_000199": ("product-057-sticker-large-freeform-nodes.md", SIZES),
    "size-SIZ_000515": ("sticker-sheet-clear-white-nodes.md", SIZES),
    "size-SIZ_000514": ("sticker-sheet-clear-white-nodes.md", SIZES),
    "size-SIZ_000068": ("sticker-pack-nodes.md", SIZES),
    "size-SIZ_000212": ("sticker-gangpan-diecut-nodes.md", SIZES),
    "size-SIZ_000224": ("sticker-gangpan-diecut-nodes.md", SIZES),
    "size-SIZ_000501": ("sticker-gangpan-diecut-nodes.md", SIZES),
    "size-SIZ_000058": ("sticker-spec-fancy-nodes.md", SIZES),
    "size-SIZ_000059": ("sticker-spec-fancy-nodes.md", SIZES),
    "size-SIZ_000060": ("sticker-spec-fancy-nodes.md", SIZES),  # dup w/ tattoo
    "size-SIZ_000061": ("sticker-smallqty-freeform-nodes.md", SIZES),
    "size-SIZ_000062": ("sticker-smallqty-freeform-nodes.md", SIZES),
    "size-SIZ_000063": ("sticker-smallqty-freeform-nodes.md", SIZES),
    "size-SIZ_000064": ("sticker-smallqty-freeform-nodes.md", SIZES),
    "size-SIZ_000065": ("sticker-smallqty-freeform-nodes.md", SIZES),
    # materials
    "material-MAT_000584": ("product-052-sticker-halfcut-freeform-nodes.md", MATS),
    "material-MAT_000611": ("product-052-sticker-halfcut-freeform-nodes.md", MATS),
    "material-MAT_000585": ("product-052-sticker-halfcut-freeform-nodes.md", MATS),
    "material-MAT_000586": ("product-052-sticker-halfcut-freeform-nodes.md", MATS),
    "material-MAT_000609": ("product-052-sticker-halfcut-freeform-nodes.md", MATS),
    "material-MAT_000153": ("sticker-spec-rectangle-nodes.md", MATS),
    "material-MAT_000084": ("sticker-spec-rectangle-nodes.md", MATS),
    "material-MAT_000242": ("sticker-spec-rectangle-nodes.md", MATS),
    "material-MAT_000155": ("sticker-spec-rectangle-nodes.md", MATS),
    "material-MAT_000156": ("sticker-spec-rectangle-nodes.md", MATS),
    "material-MAT_000170": ("sticker-gangpan-diecut-nodes.md", MATS),
    "material-MAT_000171": ("sticker-gangpan-diecut-nodes.md", MATS),
    "material-MAT_000163": ("sticker-halfcut-hologram-nodes.md", MATS),
    "material-MAT_000371": ("sticker-halfcut-clear-nodes.md", MATS),
    "material-MAT_000162": ("sticker-sheet-clear-white-nodes.md", MATS),  # defect dual
    "material-MAT_000372": ("sticker-sheet-clear-white-nodes.md", MATS),  # defect dual
    "material-MAT_000593": ("product-055-sticker-sheet-freeform-nodes.md", MATS),
    "material-MAT_000594": ("sticker-tattoo-nodes.md", MATS),
    # processes
    "process-PROC_000122": ("product-052-sticker-halfcut-freeform-nodes.md", PROCS),
    "process-PROC_000055": ("sticker-spec-rectangle-nodes.md", PROCS),
    "process-PROC_000054": ("sticker-halfcut-hologram-nodes.md", PROCS),
    "process-PROC_000114": ("product-055-sticker-sheet-freeform-nodes.md", PROCS),
    # plate
    "plate-OUTPUT_PAPER_TYPE_02": ("product-052-sticker-halfcut-freeform-nodes.md", PLATES),
    # formulas
    "formula-PRF_STK_FIXED": ("product-052-sticker-halfcut-freeform-nodes.md", FORMULAS),
    "formula-PRF_GANGPAN_FIXED": ("sticker-gangpan-diecut-nodes.md", FORMULAS),
    "formula-PRF_STK_PACK": ("sticker-pack-nodes.md", FORMULAS),
    "formula-PRF_STK_TATTOO": ("sticker-tattoo-nodes.md", FORMULAS),
    # components
    "component-COMP_STK_PRINT": ("product-052-sticker-halfcut-freeform-nodes.md", COMPS),
    "component-COMP_GANGPAN_PRINT": ("sticker-gangpan-diecut-nodes.md", COMPS),
    "component-COMP_STK_PACK": ("sticker-pack-nodes.md", COMPS),
    "component-COMP_STK_TATTOO": ("sticker-tattoo-nodes.md", COMPS),
}

MOVE_IDS = set(MOVE.keys())
HDR = re.compile(r"^### \[([^\]]+)\]")
MARK = re.compile(r"^(### |## |---\s*$)")

def parse_blocks(lines):
    """return list of (id, start, end_exclusive) for each ### [id] block."""
    out = []
    i, n = 0, len(lines)
    while i < n:
        m = HDR.match(lines[i])
        if m:
            bid = m.group(1)
            j = i + 1
            while j < n and not MARK.match(lines[j]):
                j += 1
            out.append((bid, i, j))
            i = j
        else:
            i += 1
    return out

def scan_files():
    files = {}
    for fn in sorted(os.listdir(PROD)):
        if not fn.endswith(".md"): continue
        if "sticker" in fn and fn.endswith("-nodes.md") or fn == "product-047-small-flyer.md":
            p = os.path.join(PROD, fn)
            with open(p, encoding="utf-8") as f:
                files[fn] = f.read().splitlines(keepends=False)
    return files

def block_text(lines, s, e):
    seg = lines[s:e]
    # strip trailing blank lines
    while seg and seg[-1].strip() == "":
        seg.pop()
    return "\n".join(seg)

def main():
    files = scan_files()
    # 1) extract canonical from owner
    extracted = {}  # target_rel -> list of block_text
    for bid, (owner, target) in MOVE.items():
        if owner not in files:
            print(f"!! owner missing for {bid}: {owner}"); sys.exit(2)
        blocks = {b[0]: b for b in parse_blocks(files[owner])}
        if bid not in blocks:
            print(f"!! block {bid} not in owner {owner}"); sys.exit(2)
        _, s, e = blocks[bid]
        extracted.setdefault(target, []).append((bid, block_text(files[owner], s, e)))

    # 2) remove MOVE_IDS blocks from every file
    for fn, lines in files.items():
        blocks = parse_blocks(lines)
        drop = [(s, e) for (bid, s, e) in blocks if bid in MOVE_IDS]
        if not drop: continue
        keep = [True] * len(lines)
        for s, e in drop:
            for k in range(s, e):
                keep[k] = False
        newlines = [ln for k, ln in enumerate(lines) if keep[k]]
        # collapse 3+ consecutive blanks -> 1
        cleaned = []
        blanks = 0
        for ln in newlines:
            if ln.strip() == "":
                blanks += 1
                if blanks <= 1:
                    cleaned.append(ln)
            else:
                blanks = 0
                cleaned.append(ln)
        with open(os.path.join(PROD, fn), "w", encoding="utf-8") as f:
            f.write("\n".join(cleaned).rstrip() + "\n")
        print(f"removed {len(drop)} block(s) from {fn}")

    # 3) append canonical blocks to shared targets (create if new)
    for target in sorted(extracted):
        path = os.path.join(KB, target)
        blocks_here = sorted(extracted[target], key=lambda x: x[0])
        new_file = not os.path.exists(path)
        if new_file:
            header = build_new_header(target)
            body = header + "\n\n"
        else:
            with open(path, encoding="utf-8") as f:
                body = f.read().rstrip() + "\n\n"
        section_note = ("\n<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 "
                        "단일 소유권으로 이관·consolidate_sticker_axes.py) -->\n")
        body += section_note
        for bid, txt in blocks_here:
            body += "\n" + txt + "\n"
        with open(path, "w", encoding="utf-8") as f:
            f.write(body.rstrip() + "\n")
        print(f"appended {len(blocks_here)} block(s) -> {target}"
              + (" (NEW)" if new_file else ""))

def build_new_header(target):
    if target == FORMULAS:
        return ("<!-- formula page: E9 price_formula — 스티커 완제품가 공식(고정가/합가 룩업). "
                "1 파일 = N 블록(### [id]). -->\n"
                "<!-- 파싱: file-format-spec §1.2·graph-build §3.1. 값 없음(단가행=D-22 접기·구성요소 노드에). -->\n\n"
                "# 축: 스티커 가격공식 (price_formula)\n\n"
                "스티커 = 완제품가 룩업(원자합산형 아님·팩 §3.10). 디지털 공유공식(PRF_DGP_*)과 별개.\n"
                "상품→공식(R8 `priced_by`)은 상품 노드가 건다. 여기서는 공식 노드만 단일 선언(16 스티커 공용).\n"
                "각 공식 has_component(R9)→formula/sticker-components.md 구성요소.")
    if target == COMPS:
        return ("<!-- component page: E10 price_component — 스티커 완제품가 구성요소(격자 룩업). "
                "1 파일 = N 블록(### [id]). -->\n"
                "<!-- ★단가행 값은 노드로 펼치지 않음(D-22 접기·use_dims 차원 선언까지가 온톨로지 경계·값=evaluate_price). -->\n\n"
                "# 축: 스티커 가격구성요소 (price_component)\n\n"
                "스티커 완제품가 구성요소 = (사이즈·소재·수량) 격자 룩업(use_dims=[siz_cd,mat_cd,min_qty]류).\n"
                "공식→구성요소(R9 `has_component`)는 formula/sticker-formulas.md 공식이 건다.")
    return "# (shared axis)"

if __name__ == "__main__":
    main()
