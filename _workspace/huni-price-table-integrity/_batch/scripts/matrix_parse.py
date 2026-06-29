#!/usr/bin/env python3
"""
matrix_parse — 권위 가격테이블 L1 CSV → 정규 격자(normalized grid).

[HARD] 결정론: 같은 입력 CSV → 같은 격자. 시각/랜덤/외부상태 없음.
공용 코어(parse_l1) + 시트별 ADAPTERS(차원 축·단가·도수 추출 규칙).
새 시트 = ADAPTERS 에 항목 1개 추가.

정규 격자 행 스키마(NormCell):
  sheet, block_id, plt_grade(국4절/3절), clr(흑백/칼라/별색-…), side(단면/양면),
  min_qty(int), unit_price(int), prc_typ(권위가 기대하는 prc_typ='unit'),
  src_ref(엑셀 cell_ref·재현용)

단가는 verbatim(엑셀 그대로). 계산/배수 없음.
"""
import csv
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))


# ─────────────────────────────────────────────────────────────────────
# 공용 CSV 로더 (스냅샷·권위 공용) — 결정론, BOM 안전
# ─────────────────────────────────────────────────────────────────────
def read_csv(path):
    with open(path, encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


# ─────────────────────────────────────────────────────────────────────
# 시트 어댑터: 차원 축·단가·도수 추출 규칙
# band_header_path 형식 = "<색상> > <면>" (예: "칼라(CMYK) > 단면")
# block_title 에서 판형등급(국4절/3절) 추출.
# ─────────────────────────────────────────────────────────────────────
def _digital_print_clr(color_band):
    """색상 밴드 라벨 → 정규 도수 키(흑백/칼라/별색-<색>)."""
    if "흑백" in color_band:
        return "흑백"
    if "칼라" in color_band:
        return "칼라"
    if "별색" in color_band:
        m = re.search(r"별색\(([^)]+)\)", color_band)
        return "별색-" + (m.group(1) if m else color_band)
    return color_band


def _digital_print_grade(block_title):
    """블록 타이틀 → 판형등급."""
    if "국4절" in block_title:
        return "국4절"
    if "3절" in block_title:
        return "3절"
    return block_title


ADAPTERS = {
    "digital-print": {
        # 권위 격자의 차원 축 (정규 키)
        "dims": ["plt_grade", "clr", "side", "min_qty"],
        # band_header_path 를 (색상, 면) 으로 split
        "band_split": lambda p: [x.strip() for x in p.split(">")],
        "clr_fn": _digital_print_clr,
        "grade_fn": _digital_print_grade,
        # 권위가 기대하는 prc_typ (장당 단가형)
        "expected_prc_typ": "PRICE_TYPE.01",  # 단가형 ×qty (디지털=per-unit 정상)
    },
    "coating": {  # 디지털 동형(무광/유광 × 단면/양면 × 수량)
        "dims": ["plt_grade", "clr", "side", "min_qty"],
        "band_split": lambda p: [x.strip() for x in p.split(">")],
        "clr_fn": lambda b: "무광" if "무광" in b else "유광" if "유광" in b else b,
        "grade_fn": lambda t: "국4절" if "국4절" in t else "3절" if "3절" in t else t,
        "expected_prc_typ": "PRICE_TYPE.01",
    },
    # 새 시트 = 여기에 어댑터 1개 추가. 면적격자/합가표 시트는 grid_diff 의
    # 면적 매퍼/합가 매퍼를 쓰고 driver(run_all.py) 의 SHEET_REGISTRY 로 라우팅.
}


def parse_l1(l1_csv, sheet_key):
    """권위 L1 long-format CSV → 정규 격자 행 리스트(결정론·정렬됨).

    데이터 셀 식별: band_header_path 에 '>' 포함 + value 가 정수단가 + row_key 가 수량.
    """
    ad = ADAPTERS[sheet_key]
    rows = read_csv(l1_csv)
    out = []
    for r in rows:
        band = r.get("band_header_path", "")
        if ">" not in band:
            continue  # 헤더/타이틀/축라벨 셀 제외
        rk = (r.get("row_key") or "").strip()
        if not rk.isdigit():
            continue  # 수량 데이터 행만
        val = (r.get("value") or "").strip().replace(",", "")
        if not val or not val.lstrip("-").isdigit():
            continue  # 단가 빈칸 = 격자에 없음(권위가 비워둔 셀은 미적재 후보 아님)
        color_band, side = ad["band_split"](band)
        out.append({
            "sheet": r["sheet"],
            "block_id": r["block_id"],
            "plt_grade": ad["grade_fn"](r["block_title"]),
            "clr": ad["clr_fn"](color_band),
            "side": side,
            "min_qty": int(rk),
            "unit_price": int(val),
            "prc_typ": ad["expected_prc_typ"],
            "src_ref": r["cell_ref"],
        })
    # 결정론 정렬
    out.sort(key=lambda c: (c["block_id"], c["clr"], c["side"], c["min_qty"]))
    return out


def parse_l1_area(l1_csv, exclude_block_titles=("구간할인", "사이즈 / 수량", "동판", "아연판")):
    """면적격자 L1 CSV → 정규 격자(가로×세로→단가). 결정론.

    레이아웃(추출 규약): 데이터 셀 = row_key 가 '<n>mm' (세로) AND band_header_path 가
    '<m>mm > ...' (가로 + 가격열) AND value 가 단가. (가로,세로)=정규 키.
    block 단위(=상품/소재)로 분리. 구간할인/사이즈수량/동판비 블록은 제외(면적격자 아님).
    """
    rows = read_csv(l1_csv)
    out = []
    for r in rows:
        title = r.get("block_title", "")
        if any(x in title for x in exclude_block_titles):
            continue
        band = r.get("band_header_path", "")
        rk = (r.get("row_key") or "").strip()
        # 세로: row_key 가 '<숫자>mm'
        if not (rk.endswith("mm") and rk[:-2].replace(".", "").isdigit()):
            continue
        # 가로: band 첫 토큰이 '<숫자>mm'
        if ">" not in band:
            continue
        w_tok = band.split(">")[0].strip()
        if not (w_tok.endswith("mm") and w_tok[:-2].replace(".", "").isdigit()):
            continue
        val = (r.get("value") or "").strip().replace(",", "")
        if not val or not val.replace(".", "").lstrip("-").isdigit():
            continue
        width = int(float(w_tok[:-2]))
        height = int(float(rk[:-2]))
        out.append({
            "sheet": r["sheet"], "block_id": r["block_id"],
            "block_title": title,
            "width": width, "height": height,
            "unit_price": int(float(val)),
            "src_ref": r["cell_ref"],
        })
    out.sort(key=lambda c: (c["block_id"], c["width"], c["height"]))
    return out


def parse_l1_l2(l1_csv, band_parts=2):
    """L2 선조립 합가표 L1 CSV → 정규 합가 셀(종류·소재·수량→합가). 결정론.

    레이아웃: band_header_path = '<종류/사이즈> > <소재>' (band_parts=2) ·
              또는 '<size> > <면> > <page>' (band_parts=3·엽서북) · row_key = 수량 · value = 합가.
    종류/소재는 텍스트 라벨(라이브 note 와 대조). 코드 환원 안 함(날조 방지).
    """
    rows = read_csv(l1_csv)
    out = []
    for r in rows:
        band = r.get("band_header_path", "")
        if ">" not in band:
            continue
        rk = (r.get("row_key") or "").strip().replace(",", "")
        if not rk.isdigit():
            continue
        val = (r.get("value") or "").strip().replace(",", "")
        if not val or not val.replace(".", "").lstrip("-").isdigit():
            continue
        parts = [x.strip() for x in band.split(">")]
        kind = parts[0]
        if band_parts >= 3:
            # size > 면 > page → material = '면/page' 합성(라이브 note 와 동형)
            material = "/".join(parts[1:3]) if len(parts) >= 3 else (parts[1] if len(parts) > 1 else "")
        else:
            material = parts[1] if len(parts) > 1 else ""
        out.append({
            "sheet": r["sheet"], "block_id": r["block_id"],
            "block_title": r.get("block_title", ""),
            "kind": kind, "material": material, "qty": int(rk),
            "amount": int(float(val)), "src_ref": r["cell_ref"],
        })
    out.sort(key=lambda c: (c["block_id"], c["kind"], c["material"], c["qty"]))
    return out


def parse_l1_bandkey(l1_csv, exclude_titles=("올립니다", "100장당", "1장당")):
    """L1 단가·밴드형(1-part band) → 정규 셀(종류·수량→단가). 결정론.

    레이아웃: band_header_path = '<종류>' (1-part·'>'없거나 첫 토큰) · row_key = 수량 · value = 단가.
    제본·인쇄후가공·커팅타공 동형. 종류=텍스트 라벨(라이브 note 와 대조). 코드 환원 안 함.
    '단가올림' 안내 블록(올립니다 등)은 제외.
    """
    rows = read_csv(l1_csv)
    out = []
    for r in rows:
        title = r.get("block_title", "")
        if any(x in title for x in exclude_titles):
            continue
        band = (r.get("band_header_path") or "").strip()
        if not band:
            continue
        # 1-part: '>' 있으면 첫 토큰을 종류로(folding 의 단>접지옵션 대비)
        kind = band.split(">")[0].strip() if ">" in band else band
        rk = (r.get("row_key") or "").strip().replace(",", "")
        if not rk.isdigit():
            continue
        val = (r.get("value") or "").strip().replace(",", "")
        if not val or not val.replace(".", "").lstrip("-").isdigit():
            continue
        # 공정 = block_title 의 선행 개념(괄호/합가 표기 제거) — 동일 kind 충돌 분리(가변텍스트/이미지).
        proc = title.split("(")[0].strip().split(" ")[0].strip()
        if "가변" in title:
            proc = "가변(텍스트)" if "텍스트" in title else "가변(이미지)" if "이미지" in title else "가변"
        out.append({
            "sheet": r["sheet"], "block_id": r["block_id"],
            "block_title": title, "proc": proc, "kind": kind, "qty": int(rk),
            "amount": int(float(val)), "src_ref": r["cell_ref"],
        })
    out.sort(key=lambda c: (c["block_id"], c["proc"], c["kind"], c["qty"]))
    return out


def parse_l1_paper(l1_csv):
    """출력소재IMPORT(용지비) wide-format → 정규 셀(종이명·판형→연당 절가). 결정론.

    레이아웃: 행=종이명, 칼럼 '가격\\n(국4절)'·'가격(3절)' = 절가. (종이명, 판형)→price.
    """
    rows = read_csv(l1_csv)
    out = []
    # 칼럼명(개행 포함) 안전 탐색
    cols = list(rows[0].keys()) if rows else []
    col_g4 = next((c for c in cols if c.replace("\n", "").strip().startswith("가격") and "국4절" in c), None)
    col_3 = next((c for c in cols if c.replace("\n", "").strip() == "가격(3절)"), None)
    for r in rows:
        name = (r.get("paper_name") or r.get("종이명") or "").strip()
        if not name or name == "종이명":
            continue
        for grade, col in [("국4절", col_g4), ("3절", col_3)]:
            if not col:
                continue
            val = (r.get(col) or "").strip().replace(",", "")
            if not val:
                continue
            try:
                price = float(val)
            except ValueError:
                continue
            out.append({
                "sheet": r.get("sheet", "출력소재IMPORT"), "block_id": "B01",
                "paper_name": name, "grade": grade, "unit_price": price,
                "src_ref": f"row{r.get('row_seq','')}",
            })
    out.sort(key=lambda c: (c["paper_name"], c["grade"]))
    return out


if __name__ == "__main__":
    import sys
    import json
    l1 = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        HERE, "..", "..", "..", "huni-dbmap", "06_extract",
        "price-digital-print-price-l1.csv")
    grid = parse_l1(os.path.abspath(l1), "digital-print")
    print(f"정규 격자 셀 수: {len(grid)}")
    # 분포 요약
    from collections import Counter
    print("block:", dict(Counter(c["block_id"] for c in grid)))
    print("clr:", dict(Counter(c["clr"] for c in grid)))
    print("side:", dict(Counter(c["side"] for c in grid)))
    print("샘플:", json.dumps(grid[0], ensure_ascii=False))
