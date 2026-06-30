#!/usr/bin/env python3
"""
grid_diff — 권위 정규 격자 ↔ 라이브 스냅샷 component_prices 셀 diff.

[HARD] 결정론: (권위 CSV + 스냅샷 CSV) → 같은 결함보드. 라이브 읽기전용(스냅샷 사용)·DB 미적재.

검출 규칙(함수화):
  ① missing_cell   미적재 셀 — 권위 격자에 있는데 라이브에 없음(sparse grid)
  ② transpose      차원 뒤바뀜 — (a,b)↔(b,a) 매치율 비교(여기선 side/grade swap 탐지)
  ③ mismatch       정합 불일치 — 적재값 ≠ 권위 단가
  ④ prc_typ_typo   prc_typ 오타이핑 — note 패턴 + min_qty 로 밴드총액/세트단가인데 .01
  ⑤ dim_missing    차원 누락 — 권위 가격축(도수/판형)이 라이브 use_dims·차원행에 없음

각 결함 = 재현 키 + 권위값 + 스냅샷값 + 돈영향(저/과/견적불가).
"""
import csv
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
from matrix_parse import parse_l1, read_csv, ADAPTERS  # noqa: E402


# ─────────────────────────────────────────────────────────────────────
# 라이브 스냅샷 → 정규 키 매핑(시트별)
# digital-print: COMP_PRINT_DIGITAL_* (흑백/칼라) + COMP_PRINT_SPOT_*_S1 (별색)
#   live 차원 코드 → 정규 키:
#     plt_siz_cd SIZ_000499=국4절, SIZ_000077=3절
#     print_opt_cd POPT_000001=단면, POPT_000002=양면
#     도수: DIGITAL 은 proc_cd 단일(PROC_000004) → 흑백/칼라는 note 로만 구분
#           별색은 proc_cd PROC_000008~012 = 화이트/클리어/핑크/금색/은색
#     min_qty = 수량밴드
# ─────────────────────────────────────────────────────────────────────
LIVE_MAP_DIGITAL = {
    "plt_grade": {"SIZ_000499": "국4절", "SIZ_000077": "3절"},
    # side: 면(단면/양면)은 note 가 1차 권위(POPT 코드는 도수까지 인코딩해 불완전).
    #   POPT_000001=단면/POPT_000002=양면(칼라) · POPT_000008=단면1도/POPT_000009=양면1도(흑백).
    #   흑백 1도는 별도 print_opt(색수 CLR_000002)로 적재됨 → 코드맵만으론 흑백 누락(가짜신호).
    #   그래서 _side_from_note 를 1차로, 코드맵을 폴백으로 쓴다.
    "side": {"POPT_000001": "단면", "POPT_000002": "양면",
             "POPT_000008": "단면", "POPT_000009": "양면"},
    "spot_proc": {
        "PROC_000008": "별색-화이트", "PROC_000009": "별색-클리어",
        "PROC_000010": "별색-핑크", "PROC_000011": "별색-금색",
        "PROC_000012": "별색-은색",
    },
}


def _side_from_note(note):
    """디지털 인쇄비 note 에서 면(단면/양면) 추출 — print_opt 코드맵보다 1차 권위."""
    if "양면" in note:
        return "양면"
    if "단면" in note:
        return "단면"
    return None


def _clr_from_note(note):
    """디지털 인쇄비 note 에서 도수 추출(흑백/칼라)."""
    if "흑백" in note:
        return "흑백"
    if "칼라" in note:
        return "칼라"
    return None


def live_grid_digital(comp_prices, components):
    """라이브 component_prices → 정규 격자 dict. 활성(del_yn=N)만.

    반환: {(plt_grade, clr, side, min_qty): {price, comp_cd, comp_price_id, prc_typ, del_yn}}
    + dim_present: 라이브에 실제 존재하는 도수/판형 집합(차원 누락 판정용).
    """
    # 활성 comp 집합(del_yn=N)
    active = {c["comp_cd"] for c in components
              if c["comp_cd"].startswith("COMP_PRINT") and c["del_yn"] == "N"}
    comp_prc_typ = {c["comp_cd"]: c["prc_typ_cd"] for c in components}

    live = {}
    # 디지털: 흑백 도수는 활성 comp 자체가 없음(collapse) → clr_comp_zero_rows 비움
    dim_present = {"clr": set(), "plt_grade": set(), "clr_comp_zero_rows": set()}
    for r in comp_prices:
        comp = r["comp_cd"]
        if not comp.startswith("COMP_PRINT"):
            continue
        if comp not in active:
            continue  # 논리삭제 comp 제외(엔진 미사용)
        m = LIVE_MAP_DIGITAL
        grade = m["plt_grade"].get(r["plt_siz_cd"])
        # 면: note 1차(흑백 신규 print_opt POPT_000008/009 누락 방지) → 코드맵 폴백
        side = _side_from_note(r["note"]) or m["side"].get(r["print_opt_cd"])
        # 도수: 별색 comp 는 proc_cd, 디지털 comp 는 note
        if comp.startswith("COMP_PRINT_SPOT"):
            clr = m["spot_proc"].get(r["proc_cd"])
        else:
            clr = _clr_from_note(r["note"])
        if grade is None or side is None or clr is None:
            continue
        try:
            qty = int(r["min_qty"])
        except (ValueError, TypeError):
            continue
        try:
            price = int(float(r["unit_price"]))
        except (ValueError, TypeError):
            continue
        dim_present["clr"].add(clr)
        dim_present["plt_grade"].add(grade)
        key = (grade, clr, side, qty)
        # 같은 키 중복 시 결정론을 위해 comp_price_id 작은 것 유지
        if key not in live or int(r["comp_price_id"]) < int(live[key]["comp_price_id"]):
            live[key] = {
                "price": price, "comp_cd": comp,
                "comp_price_id": r["comp_price_id"],
                "prc_typ": comp_prc_typ.get(comp, ""),
                "note": r["note"],
            }
    return live, dim_present


# 코팅: COMP_COAT_MATTE(무광)/COMP_COAT_GLOSSY(유광). side 는 coat_side_cnt(1=단면/2=양면).
LIVE_MAP_COATING = {
    "plt_grade": {"SIZ_000499": "국4절", "SIZ_000077": "3절"},
    "side": {"1": "단면", "2": "양면"},
    "comp_clr": {"COMP_COAT_MATTE": "무광", "COMP_COAT_GLOSSY": "유광"},
}


def live_grid_coating(comp_prices, components):
    """라이브 코팅 component_prices → 정규 격자. 활성(del_yn=N)만."""
    active = {c["comp_cd"] for c in components
              if c["comp_cd"].startswith("COMP_COAT") and c["del_yn"] == "N"}
    comp_prc_typ = {c["comp_cd"]: c["prc_typ_cd"] for c in components}
    m = LIVE_MAP_COATING
    live = {}
    # 유광 comp(COMP_COAT_GLOSSY) 가 활성이면(존재) 단가행 0 일 때 sparse 로 분류
    comp_zero_clr = set()
    rows_per_comp = {}
    for r in comp_prices:
        if r["comp_cd"] in active:
            rows_per_comp[r["comp_cd"]] = rows_per_comp.get(r["comp_cd"], 0) + 1
    for comp, clr in m["comp_clr"].items():
        if comp in active and rows_per_comp.get(comp, 0) == 0:
            comp_zero_clr.add(clr)
    dim_present = {"clr": set(), "plt_grade": set(), "clr_comp_zero_rows": comp_zero_clr}
    for r in comp_prices:
        comp = r["comp_cd"]
        if comp not in active:
            continue
        grade = m["plt_grade"].get(r["plt_siz_cd"])
        side = m["side"].get((r["coat_side_cnt"] or "").strip())
        clr = m["comp_clr"].get(comp)
        if grade is None or side is None or clr is None:
            continue
        try:
            qty = int(r["min_qty"]); price = int(float(r["unit_price"]))
        except (ValueError, TypeError):
            continue
        dim_present["clr"].add(clr)
        dim_present["plt_grade"].add(grade)
        key = (grade, clr, side, qty)
        if key not in live or int(r["comp_price_id"]) < int(live[key]["comp_price_id"]):
            live[key] = {"price": price, "comp_cd": comp,
                         "comp_price_id": r["comp_price_id"],
                         "prc_typ": comp_prc_typ.get(comp, ""), "note": r["note"]}
    return live, dim_present


# ─────────────────────────────────────────────────────────────────────
# 면적격자 family — 권위 block ↔ 라이브 comp 매핑(결정론·스냅샷 셀수로 1:1 확인됨).
# 값 = block_id → comp_cd. 매핑미상 block 은 None(정직 분류·날조 금지).
# ─────────────────────────────────────────────────────────────────────
AREA_BLOCK_COMP = {
    "acrylic": {
        "B01": "COMP_ACRYL_CLEAR3T",    # 투명아크릴3T (196셀 일치)
        "B02": None,                     # 투명아크릴1.5T — 라이브 별도 comp 부재(매핑미상)
        "B03": "COMP_ACRYL_MIRROR3T",   # 미러아크릴3T (81셀 일치)
        "B05": "COMP_ACRYL_COROTTO",    # 아크릴코롯토 (36셀 일치)
        "B06": None,                     # 아크릴카라비너 — 면적 아님(siz_cd 본체·매핑미상)
    },
    "poster-sign": {
        "B01": "COMP_POSTER_ARTPRINT_PHOTO",   # 아트프린트포스터(인화지) 52
        "B02": "COMP_POSTER_ARTPAPER_MATTE",   # 아트페이퍼포스터(매트지) 39
        "B03": "COMP_POSTER_WATERPROOF_PET",   # 방수포스터(PET) 52
        "B04": "COMP_POSTER_ADH_WATERPROOF_PVC",  # 접착방수포스터(PVC) 52
        "B05": "COMP_POSTER_ADH_CLEAR_PVC",    # 접착투명포스터(투명PVC) 52
        "B06": "COMP_POSTER_ARTFABRIC_GRAPHIC",  # 아트패브릭포스터(그래픽천) 52
        "B07": "COMP_POSTER_LINEN_FABRIC",     # 린넨패브릭포스터 52
        "B08": "COMP_POSTER_CANVAS_FABRIC",    # 캔버스패브릭포스터 52
        "B09": "COMP_POSTER_LEATHER_ARTPRINT",  # 레더아트프린트 52
        "B10": "COMP_POSTER_TYVEK_PRINT",      # 타이벡프린트 52
        "B11": "COMP_POSTER_MESH_PRINT",       # 메쉬프린트 52
        "B26": "COMP_POSTER_BANNER_NORMAL",    # 일반현수막 80
        "B27": "COMP_POSTER_BANNER_MESH",      # 메쉬현수막 48
        # B12~B25,B28~B31 = siz_cd 고정가형/사이즈수량(면적격자 아님) → area diff 대상 아님
    },
    # 박대형/박소형: 라이브에 면적 단가형 comp 부재 → 전 block None(매핑미상)
    "foil-large": {},
    "foil-small": {},
}


def live_grid_area(comp_prices, components, sheet_key, block_comp):
    """라이브 area comp → {(comp_cd, width, height): {...}}. 활성(del_yn=N)만.

    block_comp = {block_id: comp_cd} (이 시트). 타깃 comp 집합으로 필터.
    반환 live 는 comp_cd 별 (width,height)→price. detect 는 comp 단위로 권위와 대조.
    """
    targets = {c for c in block_comp.values() if c}
    active = {c["comp_cd"] for c in components if c["del_yn"] == "N"}
    comp_prc_typ = {c["comp_cd"]: c["prc_typ_cd"] for c in components}
    live = {}
    for r in comp_prices:
        comp = r["comp_cd"]
        if comp not in targets or comp not in active:
            continue
        if not (r["siz_width"] and r["siz_height"]):
            continue
        try:
            w = int(float(r["siz_width"])); h = int(float(r["siz_height"]))
            price = int(float(r["unit_price"]))
        except (ValueError, TypeError):
            continue
        key = (comp, w, h)
        if key not in live or int(r["comp_price_id"]) < int(live[key]["comp_price_id"]):
            live[key] = {"price": price, "comp_price_id": r["comp_price_id"],
                         "prc_typ": comp_prc_typ.get(comp, ""), "note": r["note"]}
    return live


def detect_area(auth_grid, live, block_comp):
    """면적격자 결함 검출: missing_cell·mismatch·transpose(가로세로 swap)·매핑미상.

    auth_grid = parse_l1_area 산출(block_id·width·height·unit_price).
    """
    defects = []
    # block → comp 결정. 매핑미상 block 은 별도 보고.
    unmapped_blocks = {}
    for c in auth_grid:
        b = c["block_id"]
        if b not in block_comp:
            unmapped_blocks.setdefault(b, c["block_title"])  # area 대상 아님(고정가/사이즈수량)
        elif block_comp[b] is None:
            unmapped_blocks.setdefault(b, c["block_title"])

    for b, title in sorted(unmapped_blocks.items()):
        n = sum(1 for c in auth_grid if c["block_id"] == b)
        defects.append({
            "defect": "unmapped", "key": f"block={b}({title[:24]})",
            "auth_value": f"{n}셀", "live_value": "매핑미상",
            "money_impact": "확인 필요(권위 block↔라이브 comp 미확정·면적격자 아님 가능)",
            "repro": f"block {b} '{title[:30]}' → 라이브 comp 미확정(사람 확인)",
        })

    # 매핑된 block 만 cell diff
    direct = 0
    swap_hit = 0
    for c in auth_grid:
        b = c["block_id"]
        comp = block_comp.get(b)
        if not comp:
            continue
        k = (comp, c["width"], c["height"])
        ks = (comp, c["height"], c["width"])  # 가로세로 swap
        if k in live:
            if live[k]["price"] == c["unit_price"]:
                direct += 1
            else:
                defects.append({
                    "defect": "mismatch",
                    "key": f"{comp}/{c['width']}x{c['height']}",
                    "auth_value": str(c["unit_price"]), "live_value": str(live[k]["price"]),
                    "money_impact": ("저청구" if live[k]["price"] < c["unit_price"] else "과청구") +
                                    f"(권위 {c['unit_price']} vs 라이브 {live[k]['price']})",
                    "repro": f"comp_price_id={live[k]['comp_price_id']} {live[k]['price']}→{c['unit_price']}",
                })
        elif ks in live and live[ks]["price"] == c["unit_price"] and c["width"] != c["height"]:
            swap_hit += 1
            defects.append({
                "defect": "transpose",
                "key": f"{comp}/{c['width']}x{c['height']}",
                "auth_value": str(c["unit_price"]),
                "live_value": f"라이브는 {c['height']}x{c['width']}에 적재",
                "money_impact": "오청구(가로세로 뒤바뀜→손님 입력과 단가 어긋남)",
                "repro": f"권위 ({c['width']},{c['height']})={c['unit_price']} → 라이브 ({c['height']},{c['width']})",
            })
        else:
            defects.append({
                "defect": "missing_cell",
                "key": f"{comp}/{c['width']}x{c['height']}",
                "auth_value": str(c["unit_price"]), "live_value": "없음",
                "money_impact": "견적 시 off-grid ceiling 대체(인접 큰 사이즈)·정확값 아님",
                "repro": f"comp_price WHERE comp={comp} w={c['width']} h={c['height']} → 0행",
            })
    order = {"unmapped": 0, "transpose": 1, "missing_cell": 2, "mismatch": 3}
    defects.sort(key=lambda d: (order[d["defect"]], d["key"]))
    return defects, {"direct_hit": direct, "swap_hit": swap_hit}


# ─────────────────────────────────────────────────────────────────────
# L2 합가 family — 권위 합가셀 ↔ 라이브 통가격 comp. note 시그니처로 매칭(코드 환원 안 함).
# 시트별: 타깃 comp + note 에서 (kind, material, qty) 복원 규칙.
# 매칭이 불확실하면 매핑미상 — 코드 날조 금지.
# ─────────────────────────────────────────────────────────────────────
L2_SHEETS = {
    "envelope": {
        "comps": ["COMP_ENV_MAKING"],
        # note: '봉투제작/{kind}/{material} 제작수량 {qty} 이상'
        "note_re": r"봉투제작/([^/]+)/(.+?) 제작수량 (\d+)",
    },
    "gangpan-sticker": {
        "comps": ["COMP_GANGPAN_PRINT"],
        # note: '{형상 사이즈}/{소재그룹} 제작수량 {qty} 이상 [...]'
        # kind = 형상+사이즈(첫 '/' 앞), material = 나머지(소재그룹·코팅 or 데드롱).
        # 라이브는 소재그룹 2종(비코팅/무광/유광 · 유포/투명데드롱/은데드롱) → 권위 소재열과 대조.
        "note_re": r"^([^/]+(?: x [^/]+)?)/(.+?) 제작수량 (\d+)",
    },
    "postcard-book": {
        # 엽서북(COMP_PCB_*) — 떡메(COMP_TTEOKME)는 차원 다름(별도). 엽서북만 4축.
        "comps": ["COMP_PCB_S1_20P", "COMP_PCB_S2_20P", "COMP_PCB_S1_30P", "COMP_PCB_S2_30P"],
        # note: '엽서북/{size}/{면}/{page} 수량 {qty} 이상' → kind=size, material=면+page
        "note_re": r"엽서북/([^/]+)/([^/]+)/([^/ ]+) 수량 (\d+)",
        "note_groups": "size_side_page_qty",  # 4-그룹 → (kind=size, material=면/page, qty)
        "band_parts": 3,  # 권위 band = size > 면 > page
    },
}


def live_grid_l2(comp_prices, components, sheet_key):
    """라이브 L2 통가격 comp → {(kind, material, qty): {...}} (note 시그니처 매칭)."""
    import re
    cfg = L2_SHEETS[sheet_key]
    targets = set(cfg["comps"])
    active = {c["comp_cd"] for c in components if c["del_yn"] == "N"}
    comp_prc_typ = {c["comp_cd"]: c["prc_typ_cd"] for c in components}
    pat = re.compile(cfg["note_re"])
    live = {}
    unparsed = 0
    for r in comp_prices:
        comp = r["comp_cd"]
        if comp not in targets or comp not in active:
            continue
        m = pat.search(r["note"] or "")
        if not m:
            unparsed += 1
            continue
        if cfg.get("note_groups") == "size_side_page_qty":
            # (size, 면, page, qty) → kind=size, material=면/page
            kind = m.group(1).strip()
            material = (m.group(2).strip() + "/" + m.group(3).strip())
            qty = int(m.group(4))
        else:
            kind, material, qty = m.group(1).strip(), m.group(2).strip(), int(m.group(3))
        try:
            price = int(float(r["unit_price"]))
        except (ValueError, TypeError):
            continue
        key = (kind, material, qty)
        if key not in live or int(r["comp_price_id"]) < int(live[key]["comp_price_id"]):
            live[key] = {"price": price, "comp_cd": comp,
                         "comp_price_id": r["comp_price_id"],
                         "prc_typ": comp_prc_typ.get(comp, ""), "note": r["note"]}
    return live, {"unparsed_live_rows": unparsed}


def detect_l2(auth_grid, live):
    """L2 합가 결함: missing_cell(권위에 있는데 라이브 0)·mismatch(합가 불일치)."""
    defects = []
    direct = 0
    auth_keys = {(c["kind"], c["material"], c["qty"]): c for c in auth_grid}
    for key, c in sorted(auth_keys.items()):
        if key in live:
            if live[key]["price"] == c["amount"]:
                direct += 1
            else:
                defects.append({
                    "defect": "mismatch",
                    "key": f"{c['kind']}/{c['material'][:18]}/{c['qty']}",
                    "auth_value": str(c["amount"]), "live_value": str(live[key]["price"]),
                    "money_impact": ("저청구" if live[key]["price"] < c["amount"] else "과청구") +
                                    f"(권위 {c['amount']} vs 라이브 {live[key]['price']})",
                    "repro": f"comp_price_id={live[key]['comp_price_id']} {live[key]['price']}→{c['amount']}",
                })
        else:
            defects.append({
                "defect": "missing_cell",
                "key": f"{c['kind']}/{c['material'][:18]}/{c['qty']}",
                "auth_value": str(c["amount"]), "live_value": "없음(note 시그니처 미매칭)",
                "money_impact": "견적불가/매핑미상(권위 합가셀이 라이브 note 와 안 맞음·확인 필요)",
                "repro": f"권위 ({c['kind']},{c['material'][:14]},{c['qty']})={c['amount']} → 라이브 미매칭",
            })
    order = {"missing_cell": 0, "mismatch": 1}
    defects.sort(key=lambda d: (order[d["defect"]], d["key"]))
    return defects, {"direct_hit": direct}


# ─────────────────────────────────────────────────────────────────────
# L1 밴드키 family (1-part band·제본/인쇄후가공/커팅타공/접지) — note 종류 시그니처.
# 종류(밴드키)로 권위↔라이브 대조. comp-set 전체 note 에서 (종류, 수량) 복원.
# 권위 종류가 라이브 note 에 없으면 → 차원/셀 누락(dim_missing 후보).
# ─────────────────────────────────────────────────────────────────────
BANDKEY_SHEETS = {
    "binding": {
        "comps_prefix": "COMP_BIND",
        # note: '제본비/{종류} 수량 {qty} 이상'
        "note_re": r"제본비/(.+?) 수량 (\d+)",
        # 권위 헤더노이즈 종류 제외
        "auth_exclude_kinds": {"제본/수량", "제본비"},
    },
    "post-process": {
        "comps_prefix": "COMP_PP",
        # note: '{공정}/{종류} 주문수량 {qty}건 이상 ...'  (공정=모서리/오시/미싱/가변)
        "note_re": r"^[^/]+/(.+?) (?:주문수량|제작수량|출력매수) (\d+)",
        "auth_exclude_kinds": {"제작수량"},
        # ★ 가변(텍스트)/가변(이미지) 가 동일 kind(1개·2개·3개) → 공정 키 필요.
        "use_proc_key": True,
    },
    "cutting": {
        "comps_prefix": "COMP_CUT",
        # note: '완칼(국4절) ... 출력매수 {qty}' (단면=완칼) · '타공(단가)/{종류} 출력매수 {qty}'
        "note_re": r"(?:완칼\(국4절\)|타공\(단가\)/(.+?)) .*?출력매수 (\d+)",
        "auth_exclude_kinds": {"옵션/ 제작수량", "수량(국4절)"},
        # 권위 '단면'(완칼) ↔ 라이브 완칼·'1구(6mm)/2구(6mm)' ↔ 타공
        "auth_kind_alias": {"단면": "단면"},  # 별도 정규화는 detect 에서
    },
    "folding": {
        "comps_prefix": "COMP_FOLD",
        # note: '{카드접지|리플렛접지}/{종류} 제작수량 {qty} ...'
        "note_re": r"^(?:카드접지|리플렛접지)/(.+?) 제작수량 (\d+)",
        "auth_exclude_kinds": {"접지옵션명/ 제작수량", "접지옵션명/제작수량"},
    },
}


def live_grid_bandkey(comp_prices, components, sheet_key):
    """라이브 밴드키 comp-set → {(kind, qty): {...}} (note 종류 시그니처)."""
    import re
    cfg = BANDKEY_SHEETS[sheet_key]
    prefix = cfg["comps_prefix"]
    active = {c["comp_cd"] for c in components
              if c["comp_cd"].startswith(prefix) and c["del_yn"] == "N"}
    comp_prc_typ = {c["comp_cd"]: c["prc_typ_cd"] for c in components}
    pat = re.compile(cfg["note_re"])
    live = {}
    unparsed = 0
    kinds_present = set()
    for r in comp_prices:
        comp = r["comp_cd"]
        if comp not in active:
            continue
        note = r["note"] or ""
        m = pat.search(note)
        if not m:
            unparsed += 1
            continue
        # note_re 그룹: 마지막 그룹=qty, 그 앞 비어있지 않은 그룹=kind(완칼은 kind None→'단면')
        groups = [g for g in m.groups()]
        qty = int(groups[-1])
        kind = next((g for g in groups[:-1] if g), None)
        if kind is None:
            kind = "단면"  # 완칼(국4절)=커팅 단면
        kind = kind.strip()
        # 공정 = note 의 첫 '/' 앞(가변텍스트/가변이미지 등 구분). 없으면 comp 접두.
        proc = note.split("/")[0].strip() if "/" in note else comp
        try:
            price = int(float(r["unit_price"]))
        except (ValueError, TypeError):
            continue
        kinds_present.add(kind)
        key = (proc, kind, qty)
        if key not in live or int(r["comp_price_id"]) < int(live[key]["comp_price_id"]):
            live[key] = {"price": price, "comp_cd": comp,
                         "comp_price_id": r["comp_price_id"],
                         "prc_typ": comp_prc_typ.get(comp, ""), "note": r["note"]}
    return live, {"unparsed_live_rows": unparsed, "kinds_present": kinds_present}


def _norm_proc(p):
    """공정 라벨 정규화(괄호·합가표기 제거)·권위↔라이브 정렬."""
    p = p.split("(")[0].strip() if "가변" not in p else p
    return {"제본비": "제본", "타공": "타공", "타공(단가)": "타공"}.get(p, p)


def detect_bandkey(auth_grid, live, kinds_present, cfg):
    """밴드키 결함: dim_missing(권위 종류 통째 라이브 부재)·missing_cell·mismatch.

    키=(공정정규화, kind, qty). 공정은 동일 kind 충돌 분리용(가변텍스트/이미지). live 키=(proc,kind,qty).
    """
    defects = []
    direct = 0
    exclude = cfg.get("auth_exclude_kinds", set())
    use_proc = cfg.get("use_proc_key", False)
    auth = [c for c in auth_grid if c["kind"] not in exclude]
    auth_kinds = {c["kind"] for c in auth}

    # live 재색인: use_proc 면 (kind,qty)→가격 다종 보존 위해 (kind,qty)별 가격집합도 구성.
    # 비-use_proc 면 (kind,qty) 단일키.
    if use_proc:
        # post-process: 라이브 (kind,qty)→{price} (공정 무시·동일 kind 동일 가격 가정 검증)
        live_kq = {}
        for (proc, kind, qty), v in live.items():
            live_kq.setdefault((kind, qty), set()).add(v["price"])
        live_kq_first = {}
        for (proc, kind, qty), v in live.items():
            live_kq_first.setdefault((kind, qty), v)
    else:
        live_kq_first = {(k, q): v for (p, k, q), v in live.items()}

    # ⑤ dim_missing — 권위 종류가 라이브 note 에 통째로 없음
    for kind in sorted(auth_kinds - kinds_present):
        n = sum(1 for c in auth if c["kind"] == kind)
        defects.append({
            "defect": "dim_missing", "key": f"kind={kind}",
            "auth_value": f"{n}셀(전 수량)", "live_value": "종류 부재",
            "money_impact": "견적불가/매핑미상(권위 종류가 라이브 component_prices note 에 0행·확인 필요)",
            "repro": f"권위 종류 '{kind}' 가 라이브 note 시그니처에 0행",
        })

    # ①③ cell diff. auth 키=(kind,qty)·공정은 표시. 중복 (kind,qty)는 1회만(가격동일 검증).
    # 다른 가격의 중복이면 첫 행과 비교(다종 가격 충돌은 mismatch 로 노출).
    seen = set()
    for c in sorted(auth, key=lambda x: (x["kind"], x["qty"], x["proc"])):
        if c["kind"] not in kinds_present:
            continue
        kq = (c["kind"], c["qty"])
        if kq in seen:
            continue  # 중복 (kind,qty) 1회만 카운트(auth_cells 정합)
        seen.add(kq)
        kdisp = f"{c['proc']}/{c['kind']}/{c['qty']}"
        if kq in live_kq_first:
            lp = live_kq_first[kq]["price"]
            if lp == c["amount"]:
                direct += 1
            else:
                defects.append({
                    "defect": "mismatch", "key": kdisp,
                    "auth_value": str(c["amount"]), "live_value": str(lp),
                    "money_impact": ("저청구" if lp < c["amount"] else "과청구") +
                                    f"(권위 {c['amount']} vs 라이브 {lp})",
                    "repro": f"comp_price_id={live_kq_first[kq]['comp_price_id']} {lp}→{c['amount']}",
                })
        else:
            defects.append({
                "defect": "missing_cell", "key": kdisp,
                "auth_value": str(c["amount"]), "live_value": "없음",
                "money_impact": "견적불가/최소가(해당 수량밴드 단가 미적재→best-band 미스)",
                "repro": f"권위 ({c['kind']},{c['qty']})={c['amount']} → 라이브 미매칭",
            })
    order = {"dim_missing": 0, "missing_cell": 1, "mismatch": 2}
    defects.sort(key=lambda d: (order[d["defect"]], d["key"]))
    return defects, {"direct_hit": direct}


# ─────────────────────────────────────────────────────────────────────
# 출력소재IMPORT(용지비) — COMP_PAPER. note='용지비 {종이명} {판형}(316x467) 절가 …'.
# (종이명, 판형)→연당 절가(float). 권위 wide-format ↔ 라이브 note 매칭.
# ─────────────────────────────────────────────────────────────────────
def live_grid_paper(comp_prices, components):
    import re
    active = {c["comp_cd"] for c in components if c["comp_cd"] == "COMP_PAPER" and c["del_yn"] == "N"}
    comp_prc_typ = {c["comp_cd"]: c["prc_typ_cd"] for c in components}
    pat = re.compile(r"용지비 (.+?) (국4절|3절)")
    live = {}
    unparsed = 0
    for r in comp_prices:
        if r["comp_cd"] not in active:
            continue
        m = pat.search(r["note"] or "")
        if not m:
            unparsed += 1
            continue
        name, grade = m.group(1).strip(), m.group(2).strip()
        try:
            price = float(r["unit_price"])
        except (ValueError, TypeError):
            continue
        key = (name, grade)
        if key not in live or int(r["comp_price_id"]) < int(live[key]["comp_price_id"]):
            live[key] = {"price": price, "comp_cd": "COMP_PAPER",
                         "comp_price_id": r["comp_price_id"],
                         "prc_typ": comp_prc_typ.get("COMP_PAPER", ""), "note": r["note"]}
    return live, {"unparsed_live_rows": unparsed}


def detect_paper(auth_grid, live):
    """용지비 결함: missing_cell(권위 종이명·판형 라이브 부재)·mismatch(절가 불일치)."""
    defects = []
    direct = 0
    auth_keys = {(c["paper_name"], c["grade"]): c for c in auth_grid}
    for key, c in sorted(auth_keys.items()):
        if key in live:
            # float 비교: 권위 3자리 ↔ 라이브 2자리 반올림 허용(≤0.01 = 적재 정상)
            if abs(live[key]["price"] - c["unit_price"]) <= 0.01:
                direct += 1
            else:
                defects.append({
                    "defect": "mismatch", "key": f"{c['paper_name']}/{c['grade']}",
                    "auth_value": f"{c['unit_price']}", "live_value": f"{live[key]['price']}",
                    "money_impact": ("저청구" if live[key]["price"] < c["unit_price"] else "과청구") +
                                    f"(권위 {c['unit_price']} vs 라이브 {live[key]['price']})",
                    "repro": f"comp_price_id={live[key]['comp_price_id']} {live[key]['price']}→{c['unit_price']}",
                })
        else:
            defects.append({
                "defect": "missing_cell", "key": f"{c['paper_name']}/{c['grade']}",
                "auth_value": f"{c['unit_price']}", "live_value": "없음",
                "money_impact": "견적불가/매핑미상(권위 종이 절가가 라이브 COMP_PAPER 에 0행·확인 필요)",
                "repro": f"권위 ({c['paper_name']},{c['grade']})={c['unit_price']} → 라이브 미매칭",
            })
    order = {"missing_cell": 0, "mismatch": 1}
    defects.sort(key=lambda d: (order[d["defect"]], d["key"]))
    return defects, {"direct_hit": direct}


# ─────────────────────────────────────────────────────────────────────
# 검출 규칙
# ─────────────────────────────────────────────────────────────────────
def detect(auth_grid, live, dim_present):
    """5종 결함 검출 → 결함보드 행 리스트(결정론 정렬)."""
    defects = []
    auth_keys = {(c["plt_grade"], c["clr"], c["side"], c["min_qty"]): c for c in auth_grid}

    # ⑤ dim_missing — 권위 도수축이 라이브에 통째로 없음(축 단위)
    auth_clrs = {c["clr"] for c in auth_grid}
    live_clrs = dim_present["clr"]
    for clr in sorted(auth_clrs - live_clrs):
        n = sum(1 for c in auth_grid if c["clr"] == clr)
        # 두 갈래: (a) 해당 도수 comp 가 존재하나 단가행 0 = sparse(verbatim 적재 가능)
        #         (b) 도수축 자체가 use_dims 에 없음 = collapse(차원 설계 BLOCKED)
        comp_exists = clr in dim_present.get("clr_comp_zero_rows", set())
        if comp_exists:
            defects.append({
                "defect": "missing_axis_cells", "key": f"clr={clr}",
                "auth_value": f"{n}셀(전 판형·면·수량)", "live_value": "comp 존재·단가행 0",
                "money_impact": "견적불가(해당 도수 comp 에 단가 미적재→단가 0) · verbatim 셀 적재로 교정 가능",
                "repro": f"권위 도수 '{clr}' comp 존재하나 component_prices 0행 → sparse fill",
            })
        else:
            defects.append({
                "defect": "dim_missing", "key": f"clr={clr}",
                "auth_value": f"{n}셀(전 판형·면·수량)", "live_value": "축 부재(use_dims collapse)",
                "money_impact": ("도수축 collapse: use_dims 에 도수축 없음 → 도수 구분 불가 "
                                 "(잘못된 단가 과/저청구 또는 견적불가) · 차원 설계 결정 필요(BLOCKED)"),
                "repro": f"권위 도수 '{clr}' 축이 라이브 use_dims·활성 단가행에 없음(collapse)",
            })

    # ① missing_cell — 권위에 있는데 라이브에 없음(도수축이 살아있는데 셀만 빠진 경우)
    for key, c in sorted(auth_keys.items()):
        if c["clr"] not in live_clrs:
            continue  # 축 통째 부재는 ⑤에서 보고(중복 방지)
        if key not in live:
            defects.append({
                "defect": "missing_cell",
                "key": "/".join(map(str, key)),
                "auth_value": str(c["unit_price"]), "live_value": "없음",
                "money_impact": "견적불가/최소가(해당 수량밴드 단가 미적재→best-band 미스)",
                "repro": (f"comp_price WHERE plt={key[0]} clr={key[1]} side={key[2]} "
                          f"min_qty={key[3]} → 0행"),
            })

    # ③ mismatch — 양쪽 다 있는데 값 다름
    for key, c in sorted(auth_keys.items()):
        if key in live and live[key]["price"] != c["unit_price"]:
            lp = live[key]["price"]
            direction = "저청구" if lp < c["unit_price"] else "과청구"
            defects.append({
                "defect": "mismatch",
                "key": "/".join(map(str, key)),
                "auth_value": str(c["unit_price"]), "live_value": str(lp),
                "money_impact": f"{direction}(권위 {c['unit_price']} vs 라이브 {lp})",
                "repro": (f"comp_price_id={live[key]['comp_price_id']} "
                          f"unit_price {lp}→{c['unit_price']}"),
            })

    # ④ prc_typ_typo — 밴드총액/세트단가인데 .01(×qty). 디지털은 per-unit 단가형이라
    #    .01 이 정상(false-positive 가드). note 에 '출력비/장당' 이면 정상.
    #    밴드총액 신호(min_qty>1 & note 에 '세트/밴드/총액') 일 때만 적발.
    for key, lv in sorted(live.items()):
        note = lv.get("note", "")
        if lv["prc_typ"] == "PRICE_TYPE.01" and any(
                w in note for w in ["세트단가", "밴드총액", "세트 단가", "묶음총액"]):
            defects.append({
                "defect": "prc_typ_typo",
                "key": "/".join(map(str, key)) + f"|{lv['comp_cd']}",
                "auth_value": "합가/세트형(×qty 아님)", "live_value": "PRICE_TYPE.01(×qty)",
                "money_impact": "과청구(엔진이 총액×수량)",
                "repro": f"comp_price_id={lv['comp_price_id']} prc_typ .01→.02",
            })

    # ② transpose — side(단면/양면) 또는 grade(국4절/3절) swap 매치율 비교.
    #    직접 매치 셀 중 값 불일치인데 (side swap) 또는 (grade swap) 으로 매치되면 transpose.
    direct_hit = sum(1 for k in auth_keys if k in live and live[k]["price"] == auth_keys[k]["unit_price"])
    swap_side_hit = 0
    swap_grade_hit = 0
    for key, c in auth_keys.items():
        g, clr, side, q = key
        sside = "양면" if side == "단면" else "단면"
        sgrade = "3절" if g == "국4절" else "국4절"
        ks = (g, clr, sside, q)
        kg = (sgrade, clr, side, q)
        if ks in live and live[ks]["price"] == c["unit_price"] and (key not in live or live[key]["price"] != c["unit_price"]):
            swap_side_hit += 1
        if kg in live and live[kg]["price"] == c["unit_price"] and (key not in live or live[key]["price"] != c["unit_price"]):
            swap_grade_hit += 1
    # transpose 판정: swap 매치율이 직접 매치율보다 월등(>2배 & 의미있는 절대량)
    for label, hit in [("side(단면↔양면)", swap_side_hit), ("plt_grade(국4절↔3절)", swap_grade_hit)]:
        if hit > 5 and hit > 2 * max(direct_hit, 1):
            defects.append({
                "defect": "transpose", "key": f"axis={label}",
                "auth_value": f"직접매치 {direct_hit}", "live_value": f"swap매치 {hit}",
                "money_impact": "오청구(차원 뒤바뀜→손님 선택과 단가 어긋남)",
                "repro": f"{label} swap 매치율 {hit} > 직접 {direct_hit}",
            })

    # 결정론 정렬
    order = {"dim_missing": 0, "missing_axis_cells": 1, "missing_cell": 2,
             "transpose": 3, "mismatch": 4, "prc_typ_typo": 5}
    defects.sort(key=lambda d: (order[d["defect"]], d["key"]))
    return defects, {"direct_hit": direct_hit, "swap_side_hit": swap_side_hit,
                     "swap_grade_hit": swap_grade_hit}


AREA_SHEETS = {"acrylic", "poster-sign", "foil-large", "foil-small"}


def run(l1_csv, snap_dir, sheet_key, out_csv):
    from matrix_parse import parse_l1_area, parse_l1_l2
    comp_prices = read_csv(os.path.join(snap_dir, "t_prc_component_prices.csv"))
    components = read_csv(os.path.join(snap_dir, "t_prc_price_components.csv"))
    fields = ["defect", "key", "auth_value", "live_value", "money_impact", "repro"]

    def _write(defects):
        with open(out_csv, "w", encoding="utf-8", newline="") as f:
            w = csv.DictWriter(f, fieldnames=fields)
            w.writeheader()
            for d in defects:
                w.writerow(d)

    if sheet_key in AREA_SHEETS:
        auth = parse_l1_area(l1_csv)
        block_comp = AREA_BLOCK_COMP.get(sheet_key, {})
        live = live_grid_area(comp_prices, components, sheet_key, block_comp)
        defects, stats = detect_area(auth, live, block_comp)
        _write(defects)
        from collections import Counter
        return {"auth_cells": len(auth), "live_cells": len(live),
                "live_clrs": [], "live_grades": [],
                "defect_counts": dict(Counter(d["defect"] for d in defects)),
                "match_stats": stats, "total_defects": len(defects)}

    if sheet_key in L2_SHEETS:
        auth = parse_l1_l2(l1_csv, band_parts=L2_SHEETS[sheet_key].get("band_parts", 2))
        live, lstats = live_grid_l2(comp_prices, components, sheet_key)
        defects, stats = detect_l2(auth, live)
        _write(defects)
        from collections import Counter
        stats.update(lstats)
        return {"auth_cells": len(auth), "live_cells": len(live),
                "live_clrs": [], "live_grades": [],
                "defect_counts": dict(Counter(d["defect"] for d in defects)),
                "match_stats": stats, "total_defects": len(defects)}

    if sheet_key == "import-paper":
        from matrix_parse import parse_l1_paper
        auth = parse_l1_paper(l1_csv)
        live, lstats = live_grid_paper(comp_prices, components)
        defects, stats = detect_paper(auth, live)
        _write(defects)
        from collections import Counter
        stats.update({"unparsed_live_rows": lstats["unparsed_live_rows"]})
        return {"auth_cells": len(auth), "live_cells": len(live),
                "live_clrs": [], "live_grades": [],
                "defect_counts": dict(Counter(d["defect"] for d in defects)),
                "match_stats": stats, "total_defects": len(defects)}

    if sheet_key in BANDKEY_SHEETS:
        from matrix_parse import parse_l1_bandkey
        cfg = BANDKEY_SHEETS[sheet_key]
        auth = parse_l1_bandkey(l1_csv)
        live, lstats = live_grid_bandkey(comp_prices, components, sheet_key)
        defects, stats = detect_bandkey(auth, live, lstats["kinds_present"], cfg)
        _write(defects)
        from collections import Counter
        stats.update({"unparsed_live_rows": lstats["unparsed_live_rows"]})
        # auth_cells = 제외 종류 뺀 distinct (kind,qty)
        excl = cfg.get("auth_exclude_kinds", set())
        auth_eff = {(c["kind"], c["qty"]) for c in auth if c["kind"] not in excl}
        return {"auth_cells": len(auth_eff), "live_cells": len(live),
                "live_clrs": [], "live_grades": [],
                "defect_counts": dict(Counter(d["defect"] for d in defects)),
                "match_stats": stats, "total_defects": len(defects)}

    auth = parse_l1(l1_csv, sheet_key)
    if sheet_key == "digital-print":
        live, dim_present = live_grid_digital(comp_prices, components)
    elif sheet_key == "coating":
        live, dim_present = live_grid_coating(comp_prices, components)
    else:
        raise NotImplementedError(f"라이브 매퍼 미구현: {sheet_key}")
    defects, stats = detect(auth, live, dim_present)
    with open(out_csv, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for d in defects:
            w.writerow(d)
    from collections import Counter
    return {
        "auth_cells": len(auth), "live_cells": len(live),
        "live_clrs": sorted(dim_present["clr"]),
        "live_grades": sorted(dim_present["plt_grade"]),
        "defect_counts": dict(Counter(d["defect"] for d in defects)),
        "match_stats": stats, "total_defects": len(defects),
    }


if __name__ == "__main__":
    # usage: grid_diff.py [sheet_key] [l1_csv] [snap_dir] [out_csv]
    sheet_key = sys.argv[1] if len(sys.argv) > 1 else "digital-print"
    l1 = os.path.abspath(sys.argv[2]) if len(sys.argv) > 2 else os.path.abspath(
        os.path.join(HERE, "..", "..", "..", "huni-dbmap", "06_extract",
                     "price-digital-print-price-l1.csv"))
    snap = os.path.abspath(sys.argv[3]) if len(sys.argv) > 3 else os.path.abspath(
        os.path.join(HERE, "..", "..", "..", "_foundation", "live-snapshot", "latest"))
    out = os.path.abspath(sys.argv[4]) if len(sys.argv) > 4 else os.path.abspath(
        os.path.join(HERE, "..", f"{sheet_key}-defects.csv"))
    summary = run(l1, snap, sheet_key, out)
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    print(f"\n결함보드 → {out}")
