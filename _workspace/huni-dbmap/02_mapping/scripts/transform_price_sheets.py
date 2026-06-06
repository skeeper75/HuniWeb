#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
가격표 L1 추출본 → t_prc_component_prices long-format 평면화 (round-2, 파일럿 5시트).

[입력] _workspace/huni-dbmap/06_extract/price-<slug>-l1.csv (무손실 셀단위 long, read-only)
[산출] _workspace/huni-dbmap/02_mapping/load_price/t_prc_component_prices.csv (append)
       + 시트별 역대조 샘플 출력(stdout)

설계 권위: dbm-price-formula SKILL 규칙 1~10 + price-engine-ddl.md(6차원·자연키8·C-1~9).
- 별색 = 공정(clr_cd 아님, 규칙①) → 디지털인쇄 별색 5열은 clr_cd=NULL, 별색인쇄비 comp_cd로 분리.
- 단/양면 ≠ 단면×2(규칙②). 코팅 단/양면=coat_side_cnt(1/2). 인쇄 단/양면=별도 comp_cd.
- 무손실 L1 value 변조 금지: 셀값 그대로 unit_price.
- apply_ymd='2026-06-01'(C-1). C-2 자연키8 사전 중복제거. C-9 공란→NULL(빈문자열 아님).

[HARD] read-only: L1 CSV만 읽고, load_price/ 산출만 write. DB 무접촉.

평면화 transform 유형(파일럿 5시트):
  1. coating          → 밴드매트릭스(코팅종×단/양면×수량×규격) : coat_side_cnt 차원
  2. digital-print    → 밴드매트릭스(도수/별색×단/양면×수량×규격) : comp_cd 분리(흑백/칼라/별색)
  3. acrylic          → 면적매트릭스(가로×세로) : siz_cd 차원(미등록=후니 대기 placeholder)
  4. post-process     → 합가(옵션×수량) : comp_typ_cd=.04 후가공비, 옵션=note
  5. envelope         → 소재판수(봉투종류×소재×수량) : mat_cd 차원

비면적 7시트 확대(이번 단계 — 계산공식집초안 권위):
  6. folding          → 접지비 합가(접지단수×접지옵션 comp흡수×제작수량). comp_typ=.04 후가공.
                        계산공식집초안 행24/30: 접지비=[제작수량행 단가] (참조=접지옵션).
  7. binding          → 제본비(제본종류 comp흡수×수량). comp_typ=.04 후가공. 캘린더 B03=합가.
                        행53/69/78/89/97: 제본비=[수량행][제본종류열] (참조=제본).
  8. cutting          → 완칼 B01(합가→product_prices) / 타공 B03(구수 comp흡수×수량, 단가=후가공·합가=상품단가).
                        행14/16/49: 커팅비=[출력매수]×2000, 타공비=[출력매수]×1000.
  9. sticker          → 반칼규격 B01(규격판수 siz×소재 mat×수량). 완칼 B02~B07(siz×수량).
                        행38/52: [고정가형] 판매가=[수량행][출력매수×소재열 단가]. T열 합가=상품단가.
 10. gangpan-sticker  → 합판도무송(모양×사이즈mm siz×소재 mat×제작수량).
                        행60/61: [고정가형] 판매가=[수량행][사이즈×소재열].
 11. namecard-photocard→ 명함(면 comp흡수×소재 mat×수량)+포토카드 세트. 행39 "용지 포함".
                        행32/33/43: [고정가형] 판매가=[수량행][소재×면열]+후가공. 박합가 B09=상품단가.
 12. postcard-book    → 엽서북(사이즈 siz×면 comp흡수×페이지 comp흡수×수량 4축).
                        행71/72: [고정가형] 판매가=[수량행][옵션열].

🔴 실무진 메모 해석(실코드 탐색 후 매핑, M-1 dodge 방지):
  - sticker 소재라벨 묶음(유포/비코팅/미색 = 3종 동일단가) → 대표 mat_cd + note에 묶음 명시.
  - namecard 행39 "용지 포함 가격" = 인쇄+용지 포함 단품가(분해 금지, 그대로 단가).
  - namecard B09 "종이+동판+박가공비" + 기본가(아연판)=동판셋업비 → 합가=상품단가(규칙④).
  - 포토카드 "20장1세트" = bdl_qty 차원. 스티커팩 "54장 1세트" = 세트단위 note.
  - cutting B01 완칼 "인쇄비+소재+커팅" 합가 → product_prices(규칙④, 이중원천 방지).
"""
import collections
import csv
import json
import os
import sys

EXTRACT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "06_extract")
LOAD_DIR = os.path.join(os.path.dirname(__file__), "..", "load_price")
APPLY_YMD = "2026-06-01"  # C-1 가격 효력일 (규칙⑦)

# ─── 라이브 권위 siz 정확매칭 상수(_live_siz_const.json, 라이브 t_siz_sizes 1회 read-only 추출) ───
# M-1 dodge 정정: 아크릴 196 좌표 중 47종 DIRECT 실재 → SIZ_PENDING 발명 금지, 실코드 교체.
# REVERSED(가로/세로 의미축 HxW)는 면적형 직접입력 특성상 동일성 불확실 → 에스컬레이션(교체 안 함).
_SIZ_CONST_PATH = os.path.join(os.path.dirname(__file__), "_live_siz_const.json")
with open(_SIZ_CONST_PATH, encoding="utf-8") as _f:
    LIVE_SIZ = json.load(_f)
ACRYL_DIRECT = LIVE_SIZ["ACRYL_DIRECT"]            # {'20x20':'SIZ_000336', ...} 47종
ACRYL_REVERSED = LIVE_SIZ["ACRYL_REVERSED"]        # 21종(에스컬레이션, 교체 안 함)
POSTER_SQ = LIVE_SIZ["POSTER_SQ"]                  # {'A4':'SIZ_000258', '300*600':'SIZ_000319', ...}
POSTER_AREA_DIRECT = LIVE_SIZ["POSTER_AREA_DIRECT"]   # 면적 좌표 DIRECT 실코드
POSTER_AREA_REVERSED = LIVE_SIZ["POSTER_AREA_REVERSED"]  # 면적 좌표 REVERSED(에스컬레이션)
LIVE_COORD_ALL = LIVE_SIZ["LIVE_COORD_ALL"]        # 라이브 전체 NNxNN 좌표 DIRECT(서브제품/규격형 사이즈 dodge 방지)

CP_HEADER = ["comp_price_id", "comp_cd", "apply_ymd", "siz_cd", "clr_cd",
             "mat_cd", "coat_side_cnt", "bdl_qty", "min_qty", "unit_price", "note"]


def read_l1(slug):
    """L1 CSV를 dict 행 리스트로 읽는다 (무손실 셀단위 long)."""
    path = os.path.join(EXTRACT_DIR, "price-%s-l1.csv" % slug)
    with open(path, encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


def is_num(v):
    return v not in (None, "") and v.replace(".", "", 1).isdigit()


def body_cells(rows, block_id):
    """한 블록의 body 셀(밴드경로 보유 + 수치값)을 (min_qty, band_path, unit_price)로 산출.
    A열 row_key가 숫자(수량행)이고, 셀이 band_header_path를 가진 데이터 셀만 추출."""
    out = []
    for r in rows:
        if r["block_id"] != block_id:
            continue
        if r["col"] == "A":
            continue  # 수량축 라벨 셀 제외
        bp = r["band_header_path"]
        rk = r["row_key"]
        val = r["value"]
        if not bp or not is_num(rk) or not is_num(val):
            continue
        out.append((int(rk), bp, val))
    return out


# ───────────────────────── 1. 코팅 (coat_side_cnt 차원) ─────────────────────────
def transform_coating(rows):
    """코팅: 무광/유광(comp 분리) × 단/양면(coat_side_cnt 1/2) × 수량(min_qty) × 규격(국4절/3절=siz_cd 미등록).
    band_path 예: '무광코팅 > 단면'. 규칙②: 단/양면=coat_side_cnt(양면≠단면×2, 시트값 그대로)."""
    side_map = {"단면": 1, "양면": 2}
    # 코팅종 → comp_cd (무광/유광 별도 단가 프로파일이므로 comp 분리; 규칙② 단/양면은 coat_side_cnt)
    comp_map = {"무광코팅": "COMP_COAT_MATTE", "유광코팅": "COMP_COAT_GLOSSY"}
    # 블록 → 출력규격(siz_cd). 국4절/3절 출력규격 siz_cd 미등록 → placeholder(후니 등록 대기)
    block_siz = {"코팅(국4절)": "SIZ_PENDING_GUK4", "코팅(3절)": "SIZ_PENDING_3JEOL"}
    out = []
    blocks = {}
    for r in rows:
        blocks.setdefault(r["block_id"], r["block_title"])
    for bid, title in blocks.items():
        siz = block_siz.get(title, "")
        for min_qty, bp, val in body_cells(rows, bid):
            coat_type, side = [p.strip() for p in bp.split(">")]
            comp_cd = comp_map[coat_type]
            coat_side = side_map[side]
            out.append({
                "comp_cd": comp_cd, "siz_cd": siz, "clr_cd": "", "mat_cd": "",
                "coat_side_cnt": coat_side, "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val,
                "note": "%s/%s/%s 출력매수≥%d" % (title, coat_type, side, min_qty),
            })
    return out


# ───────────────────────── 2. 디지털인쇄비 (도수/별색 comp 분리) ─────────────────────────
def transform_digital_print(rows):
    """디지털인쇄: 도수(흑백/칼라→clr_cd)·별색5종(=공정, clr_cd 금지→별색인쇄비 comp) × 단/양면(comp 분리) × 수량 × 규격.
    규칙①: 별색=공정(clr_cd 매핑 금지=FK위반). 규칙②: 단/양면=별도 comp(단면/양면 인쇄비)."""
    # 외밴드 → (comp_cd 베이스, clr_cd). 별색은 clr_cd='' (규칙① 절대 NULL).
    band_map = {
        "흑백(1도)":   ("COMP_PRINT_DIGITAL", "CLR_000002"),  # 흑백=1도
        "칼라(CMYK)":  ("COMP_PRINT_DIGITAL", "CLR_000005"),  # 칼라=CMYK 4도
        "별색(화이트)": ("COMP_PRINT_SPOT_WHITE", ""),         # 별색=공정, clr NULL
        "별색(클리어)": ("COMP_PRINT_SPOT_CLEAR", ""),
        "별색(핑크)":   ("COMP_PRINT_SPOT_PINK", ""),
        "별색(금색)":   ("COMP_PRINT_SPOT_GOLD", ""),
        "별색(은색)":   ("COMP_PRINT_SPOT_SILVER", ""),
    }
    # 단/양면 → comp 접미(규칙② 별도 comp). 도수 comp는 단/양면별로 분리.
    side_suffix = {"단면": "_S1", "양면": "_S2"}
    block_siz = {"디지털인쇄 출력비(국4절)": "SIZ_PENDING_GUK4",
                 "디지털인쇄 출력비(3절)": "SIZ_PENDING_3JEOL"}
    out = []
    blocks = {}
    for r in rows:
        blocks.setdefault(r["block_id"], r["block_title"])
    for bid, title in blocks.items():
        siz = block_siz.get(title, "")
        for min_qty, bp, val in body_cells(rows, bid):
            band, side = [p.strip() for p in bp.split(">")]
            comp_base, clr = band_map[band]
            comp_cd = comp_base + side_suffix[side]
            out.append({
                "comp_cd": comp_cd, "siz_cd": siz, "clr_cd": clr, "mat_cd": "",
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val,
                "note": "%s/%s/%s 출력매수≥%d (별색=공정,clr=NULL)" % (title, band, side, min_qty),
            })
    return out


# ───────────────────────── 3. 아크릴 (면적매트릭스 siz_cd) ─────────────────────────
def transform_acrylic(rows):
    """아크릴 면적매트릭스: 가로(row2 leaf)×세로(A열 row_key) → 단가. siz_cd=가로x세로 (미등록=placeholder).
    규칙(면적=siz). B01/B02/B03(미러=수식파생, data_only값 그대로)·B05·B06만 base단가.
    B04/B07(구간할인)=round-1 영역(규칙⑨ 재매핑 금지) → 스킵.
    아크릴종(투명3T/1.5T/미러)=comp 분리(또는 mat_cd). 수식81 data_only value 변조 금지."""
    # 면적매트릭스 블록만(구간할인 B04/B07 제외, 외주 코롯토/카라비너 B05/B06=고정가→product_prices)
    area_blocks = {
        "B01": ("COMP_ACRYL_CLEAR3T", "투명아크릴3T"),
        "B02": ("COMP_ACRYL_CLEAR15T", "투명아크릴1.5T"),
        "B03": ("COMP_ACRYL_MIRROR3T", "미러아크릴3T(투명3T×2 파생)"),
    }
    out = []
    # 각 블록의 가로축 헤더행은 row_key='가로 / 세로'인 행(B01=row2, B02/B03=다른 행번호).
    # [정정] row_seq 하드코딩 금지 — 블록마다 헤더 행번호 상이(B03=row36). 동적 탐지.
    for bid, (comp_cd, label) in area_blocks.items():
        col_to_w = {}
        for r in rows:
            if r["block_id"] == bid and r["row_key"] == "가로 / 세로" and r["col"] != "A" \
               and r["value"] and r["value"].endswith("mm"):
                col_to_w[r["col"]] = r["value"]  # 예: B→'20mm' (가로축 leaf)
        # body: A열 row_key=세로mm, col→가로mm, value=단가
        for r in rows:
            if r["block_id"] != bid or r["col"] == "A":
                continue
            rk = r["row_key"]      # 세로축 (예 '20mm')
            val = r["value"]
            w = col_to_w.get(r["col"])
            if not (rk and rk.endswith("mm") and w and is_num(val)):
                continue
            h = rk
            wn = w.replace("mm", ""); hn = h.replace("mm", "")
            coord = "%sx%s" % (wn, hn)
            # [M-1 정정] 라이브 정확매칭: DIRECT 47종=실코드 교체(발명 금지). REVERSED 21종=의미축 HxW
            # 불확실 → placeholder 유지 + note 에스컬레이션. NONE 128종=라이브 부재 정당 placeholder.
            if coord in ACRYL_DIRECT:
                siz = ACRYL_DIRECT[coord]
                note = "%s 가로%s×세로%s 면적단가 (라이브 siz %s 실코드, M-1정정 DIRECT매칭)" % (label, w, h, siz)
            elif coord in ACRYL_REVERSED:
                siz = "SIZ_PENDING_ACRYL_%s" % coord
                note = ("%s 가로%s×세로%s 면적단가 [에스컬레이션: 라이브 %s(=%sx%s 역방향)만 존재, "
                        "가로/세로 의미축 불일치로 교체 보류]" % (label, w, h, ACRYL_REVERSED[coord], hn, wn))
            else:
                siz = "SIZ_PENDING_ACRYL_%s" % coord
                note = "%s 가로%s×세로%s 면적단가 (라이브 부재 SIZ_PENDING 정당, 후니 등록대기)" % (label, w, h)
            out.append({
                "comp_cd": comp_cd, "siz_cd": siz, "clr_cd": "", "mat_cd": "",
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": "",
                "unit_price": val,
                "note": note,
            })
    return out


# ───────────────────────── 4. 인쇄후가공 (합가, 후가공비 .04) ─────────────────────────
def transform_post_process(rows):
    """인쇄후가공: 전 블록 '합가'(규칙④). 후가공종(모서리/오시/미싱/가변)×옵션×수량 → 합가 단가.
    합가이므로 comp_typ_cd=PRC_COMPONENT_TYPE.04 후가공비(규칙⑩ 경로②: 합산형 공식의 구성요소).

    [설계 결함 정정 — 검증으로 적발] 옵션(직각/둥근, 1줄/2줄/3줄, 1개/2개/3개)은 component_prices
    6차원에 슬롯이 없다(차원 부재). 옵션을 comp_cd에서 분리하지 않으면 (comp,min_qty) 자연키가 충돌
    (예: 직각0 vs 둥근2000이 같은 키 → 덮어쓰기·손실 151행). 따라서 옵션을 comp_cd에 흡수한다
    (옵션 1개당 별도 가격구성요소). 이는 규칙①(별색=공정 comp 분리)과 동형의 모델링 결정이다.
    공정 입력 메타(오시/미싱/가변 = 줄수/개수 input)는 t_proc_processes.prcs_dtl_opt에 이미 존재 →
    component_prices는 그 옵션별 단가만 보유."""
    # band_path = 옵션명(예 '직각모서리','1줄','1개'). 옵션을 comp_cd 접미로 흡수.
    opt_suffix = {
        "직각모서리": "RIGHT", "둥근모서리": "ROUND",
        "1줄": "1L", "2줄": "2L", "3줄": "3L",
        "1개": "1EA", "2개": "2EA", "3개": "3EA",
    }
    proc_base = {
        "모서리": "COMP_PP_CORNER", "오시": "COMP_PP_CREASE", "미싱": "COMP_PP_PERF",
        "가변(텍스트)": "COMP_PP_VARTEXT", "가변(이미지)": "COMP_PP_VARIMG",
    }
    out = []
    for r in rows:
        bid = r["block_id"]
        title = r["block_title"]
        if "올립니다" in title:  # 증분 규칙 note 블록(B02) — 데이터 아님
            continue
        if r["col"] == "A":
            continue
        bp = r["band_header_path"]
        rk = r["row_key"]
        val = r["value"]
        if not bp or not is_num(rk) or not is_num(val):
            continue
        option = bp.strip()
        # 가로동거: 오시 블록 안 미싱 컬럼은 col 위치로 proc 판별(오시 B~D | 미싱 F~I).
        proc = _pp_proc_of(title, r["col"])
        if proc is None:
            continue
        suf = opt_suffix.get(option)
        if suf is None:
            continue  # 미지 옵션 라벨 — 침묵 매핑 금지
        comp_cd = "%s_%s" % (proc_base[proc], suf)  # 옵션을 comp_cd에 흡수(차원 부재 해소)
        out.append({
            "comp_cd": comp_cd, "siz_cd": "", "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": int(rk),
            "unit_price": val,
            "note": "%s/%s 제작수량≥%s (합가, comp_typ=.04 후가공비, 옵션=comp흡수)" % (proc, option, rk),
        })
    return out


def _pp_proc_of(title, col):
    """인쇄후가공 가로동거 블록의 컬럼 위치로 공정 판별."""
    if title.startswith("모서리"):
        return "모서리"
    if title.startswith("오시"):
        # B03: 오시(B~D) | 미싱(F~I 가로동거)
        return "오시" if col in ("B", "C", "D") else "미싱"
    if title.startswith("가변(텍스트)"):
        return "가변(텍스트)"
    if title.startswith("가변(이미지)"):
        return "가변(이미지)"
    return None


# ───────────────────────── 5. 봉투제작 (소재판수 mat_cd) ─────────────────────────
def transform_envelope(rows):
    """봉투제작: 봉투종류(티켓/소/자켓/대)×소재(모조/레자크)×제작수량 → 완제품가.
    계산공식집초안: '판매가=[수량행][소재열]' → 단순형 공식 + component_prices.
    소재→mat_cd(MAT_000159 모조120g / MAT_000168 레자크체크 / MAT_000169 레자크줄무늬, 봉투제작 자재링크 기존).
    봉투종류=siz_cd 미등록(후니 대기 placeholder). 완제품가 → comp_typ_cd=.06 완제품비."""
    # 봉투종류 → siz placeholder (티켓/소/자켓/대 사이즈 미등록)
    env_siz = {"티켓봉투": "SIZ_PENDING_ENV_TICKET", "소봉투": "SIZ_PENDING_ENV_SMALL",
               "자켓봉투": "SIZ_PENDING_ENV_JACKET", "대봉투": "SIZ_PENDING_ENV_LARGE"}
    # 소재라벨(band leaf) → mat_cd. 레자크는 한 셀에 2종 OR (체크/줄무늬 동일단가) → 대표 1종 매핑+note.
    mat_map = {
        "모조 120g": "MAT_000159",
        "레자크체크백색 110g / 레자크줄무늬백색 110g": "MAT_000168",  # 동일단가, 대표=체크(줄무늬 동일)
    }
    out = []
    for min_qty, bp, val in body_cells(rows, "B01"):
        env_type, mat_label = [p.strip() for p in bp.split(">")]
        siz = env_siz.get(env_type, "")
        mat = mat_map.get(mat_label, "")
        note = "봉투제작/%s/%s 제작수량≥%d (완제품가 .06)" % (env_type, mat_label, min_qty)
        if mat_label.startswith("레자크"):
            note += " [레자크체크=줄무늬 동일단가, mat=MAT_000168 대표]"
        out.append({
            "comp_cd": "COMP_ENV_MAKING", "siz_cd": siz, "clr_cd": "", "mat_cd": mat,
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
            "unit_price": val, "note": note,
        })
    return out


# ═══════════════════════════════════════════════════════════════════════════════
#  비면적 7시트 확대 (계산공식집초안 권위 + 실코드 탐색 후 매핑)
# ═══════════════════════════════════════════════════════════════════════════════
#
# [실코드 탐색 결과 — ref-sizes/materials/products 라이브 권위, M-1 dodge 방지]
# siz 실코드(재사용): 124x186=SIZ_000059 · 90x190=SIZ_000060 · 75x110=SIZ_000068
#   · 완칼A4=SIZ_000172 · A3=SIZ_000174 · A2=SIZ_000197 · 명함90x50=SIZ_000008
#   · 미니50x50=SIZ_000011 · 엽서북100x150=SIZ_000003 · 135x135=SIZ_000004 · 150x100=SIZ_000124
# mat 실코드(재사용): 유포스티커=MAT_000153 · 비코팅스티커=MAT_000084 · 무광코팅스티커=MAT_000155
#   · 유광코팅스티커=MAT_000156 · 홀로그램스티커=MAT_000163 · 투명데드롱=MAT_000170 · 은데드롱=MAT_000171
#   · 백색모조지220g=MAT_000074 · 아트지250g=MAT_000081 · 스노우지250g=MAT_000091
#   · 아트지300g=MAT_000082 · 스노우지300g=MAT_000092 · 큐리어스스킨화이트=MAT_000137
# SIZ_PENDING 정당(실코드 부재 — 후니 등록 대기): 합판 원형/정사각/직사각 mm좌표,
#   봉투 티켓/소/자켓/대, 완칼 B4/B3, 스티커 100x148·90x110, 접지/제본 일부.


def _block_titles(rows):
    bt = collections.OrderedDict()
    for r in rows:
        bt.setdefault(r["block_id"], r["block_title"])
    return bt


def _band_body(rows, bid):
    """한 블록에서 (min_qty, band_path, value, col) body 셀 산출 (A열 라벨 제외, 수치 수량행+수치값)."""
    out = []
    for r in rows:
        if r["block_id"] != bid or r["col"] == "A":
            continue
        bp = r["band_header_path"]
        rk = r["row_key"]
        val = r["value"]
        if not bp or not is_num(rk) or not is_num(val):
            continue
        out.append((int(rk), bp.strip(), val, r["col"]))
    return out


# ───────────────────────── 6. 접지옵션 (folding, 합가 .04 후가공) ─────────────────────────
def transform_folding(rows):
    """접지비 합가(오시+접지). 접지단수/옵션을 comp_cd에 흡수(M-1, 차원 부재). comp_typ=.04 후가공비.
    계산공식집초안 행24/30: 접지비=[제작수량행 단가] (참조=접지옵션). 카드B01/리플렛B02 옵션집합 상이.
    band_path: B01='2단 > 2단가로접지 / 2단세로접지' (단수 > 옵션묶음) | B02='반접지'(옵션단독).
    실무진메모: '오시+접지' 합가 → 단일 후가공 comp 단가(분해 금지, 규칙④ 합가 그대로)."""
    # 접지옵션 라벨 → comp_cd 접미(옵션을 comp에 흡수). 카드/리플렛 공통 옵션 사전.
    opt_suffix = {
        "2단가로접지": "2H", "2단세로접지": "2V",
        "3단가로접지": "3H", "3단세로접지": "3V",
        "6단오시접지": "6CR", "6단미싱접지": "6PF",
        "반접지": "HALF", "3단접지": "3FOLD",
        "4단병풍접지": "4ACC", "4단대문접지": "4GATE",
    }
    out = []
    bt = _block_titles(rows)
    for bid, title in bt.items():
        prd_ctx = "카드접지" if "카드" in title else "리플렛접지"
        for min_qty, bp, val, col in _band_body(rows, bid):
            # [검증 확정] band leaf가 묶음('2단가로접지 / 2단세로접지')이나 실제 데이터 셀은 단수당 1개 =
            # 가로/세로(또는 오시/미싱)가 동일단가(엑셀이 한 셀로 통합). 침묵손실 아님 → 대표옵션 comp +
            # note에 묶음 전체 보존. 단수(2단/3단/6단) 또는 옵션단독(반접지)을 comp 식별자로.
            head = bp.split(">")[0].strip()        # '2단' / '반접지'
            leaf = bp.split(">")[-1].strip()       # '2단가로접지 / 2단세로접지' / '반접지'
            opts = [o.strip() for o in leaf.split("/")]
            rep_opt = opts[0]                       # 대표 옵션(가로/오시 등) — 묶음 동일단가
            suf = opt_suffix.get(rep_opt)
            if suf is None:
                continue  # 미지 옵션 — 침묵 매핑 금지
            comp_cd = "COMP_FOLD_%s_%s" % ("CARD" if prd_ctx == "카드접지" else "LEAF", suf)
            grp_note = (" [묶음 동일단가: %s]" % leaf) if len(opts) > 1 else ""
            out.append({
                "comp_cd": comp_cd, "siz_cd": "", "clr_cd": "", "mat_cd": "",
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val,
                "note": "%s/%s 제작수량≥%d (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수)%s"
                        % (prd_ctx, head, min_qty, grp_note),
            })
    return out


# ───────────────────────── 7. 제본 (binding, 제본종류 comp흡수 .04) ─────────────────────────
def transform_binding(rows):
    """제본비: 제본종류(중철/무선/트윈링/PUR/하드커버/캘린더)를 comp_cd에 흡수(M-1). comp_typ=.04 후가공.
    계산공식집초안 행53/69/78/89/97: 제본비=[수량행][제본종류열] (참조=제본).
    B01 일반제본 / B02 하드커버 / B03 캘린더제본. band_path=제본종류 단독.
    실무진메모: 캘린더 B03 '삼각대 포함'은 시트에 없으나(단순 제본비), 합가 캘린더는 binding 시트 밖."""
    bind_suffix = {
        "중철제본": "JUNGCHEOL", "무선제본": "MUSEON", "트윈링제본": "TWINRING", "PUR제본": "PUR",
        "하드커버무선": "HC_MUSEON", "하드커버트윈링": "HC_TWINRING", "싸바리바인더": "SSABARI",
        "벽걸이캘린더제본": "CAL_WALL", "탁상형캘린더제본(220)": "CAL_DESK220",
        "탁상형캘린더제본(130)": "CAL_DESK130", "탁상형캘린더제본(미니)": "CAL_DESKMINI",
    }
    out = []
    bt = _block_titles(rows)
    for bid, title in bt.items():
        grp = "BIND" if bid == "B01" else ("HCBIND" if bid == "B02" else "CALBIND")
        for min_qty, bp, val, col in _band_body(rows, bid):
            bind = bp.split(">")[-1].strip()
            suf = bind_suffix.get(bind)
            if suf is None:
                continue
            comp_cd = "COMP_BIND_%s" % suf
            out.append({
                "comp_cd": comp_cd, "siz_cd": "", "clr_cd": "", "mat_cd": "",
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val,
                "note": "%s/%s 수량≥%d (제본비, comp_typ=.04 후가공, 제본종류=comp흡수)"
                        % (title, bind, min_qty),
            })
    return out


# ───────────────────────── 8. 커팅타공 (cutting) ─────────────────────────
def transform_cutting(rows):
    """커팅타공. B01 완칼='인쇄비+소재+커팅' 합가 → product_prices(규칙④, 별도 산출 cutting_product_prices).
    B03 타공: 단가(B~C열, 1구/2구 comp흡수 .04 후가공) | 합가(F~H열, 가로동거 → 상품단가는 _product에서).
    계산공식집초안 행14/16/49: 커팅비=[출력매수]×2000, 타공비=[출력매수]×1000(참조=커팅/타공).
    [본 함수는 component_prices(타공 단가 .04만) 산출. 완칼/타공합가=product 경로는 build_cutting_products]."""
    perf_suffix = {"1구(6mm)": "1H6", "2구(6mm)": "2H6", "3구(6mm)": "3H6"}
    out = []
    for r in rows:
        if r["block_id"] != "B03" or r["col"] == "A":
            continue
        bp = r["band_header_path"]
        rk = r["row_key"]
        val = r["value"]
        if not bp or not is_num(rk) or not is_num(val):
            continue
        opt = bp.strip()
        # 단가 영역(B~D열)만 component_prices. 합가 영역(F~I열)은 product 경로(중복 방지, 규칙④).
        if r["col"] not in ("B", "C", "D"):
            continue
        suf = perf_suffix.get(opt)
        if suf is None:
            continue
        comp_cd = "COMP_CUT_PERF_%s" % suf
        out.append({
            "comp_cd": comp_cd, "siz_cd": "", "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": int(rk),
            "unit_price": val,
            "note": "타공(단가)/%s 출력매수≥%s (comp_typ=.04 후가공, 구수=comp흡수)" % (opt, rk),
        })
    return out


# ───────────────────────── 9. 스티커 (sticker-price) ─────────────────────────
# 스티커 규격(판수) siz 실코드 탐색결과: 실코드 재사용 + 미등록 placeholder
STICKER_SIZ = {
    "A5(4판) / 124 x186 mm (4판)": "SIZ_000059",   # 124x186 실코드
    "A4(2판)": "SIZ_PENDING_STK_A4_2P",            # 스티커 A4=2판(일반 A4와 판수맥락 상이) 미등록
    "A3(1판)": "SIZ_PENDING_STK_A3_1P",
    "90*190(6판)": "SIZ_000060",                   # 90x190 실코드
    "100*148(8판)": "SIZ_PENDING_STK_100x148",
    "90*110(12판)": "SIZ_PENDING_STK_90x110",
    # 완칼 규격(B02~B07) — 일반 규격 실코드
    "A4": "SIZ_000172", "A3": "SIZ_000174", "A2": "SIZ_000197",
    "B4": "SIZ_PENDING_STK_B4", "B3": "SIZ_PENDING_STK_B3",
    "400x600": "SIZ_000199", "75x110": "SIZ_000068",   # [wave-2 M-2] 400x600=라이브 SIZ_000199 실코드
}
# 소재묶음 라벨 → 대표 mat_cd (묶음=여러 소재 동일단가, note에 전체 보존)
STICKER_MAT = {
    "유포/비코팅/미색": "MAT_000153",       # 대표=유포스티커 (비코팅 MAT_000084·미색 동일단가)
    "무광코팅/유광코팅": "MAT_000155",      # 대표=무광코팅스티커 (유광 MAT_000156 동일단가)
    "투명/홀로그램": "MAT_000170",          # 대표=투명데드롱 (홀로그램 MAT_000163 동일단가)
}


def transform_sticker(rows):
    """스티커: 규격(판수)=siz × 소재묶음=mat × 수량=min_qty. T열 '종이+인쇄+커팅' 합가=상품단가(별도).
    계산공식집초안 행38/52: [고정가형] 판매가=[수량행][출력매수×소재열 단가] (참조=스티커).
    B01 반칼규격(siz×소재 매트릭스) / B02~B04 완칼(siz단독×수량) / B07 스티커팩(세트).
    실무진메모: 소재라벨이 묶음('유포/비코팅/미색')이면 대표 mat + note 전체보존. 판수=siz note 보존."""
    # 완칼 블록별 소재(상품 구분 축) — B02 일반/B03 투명/B04 대형이 같은 규격·comp_cd라
    # 소재 공란이면 자연키 충돌(검증 적발: A4 q1 4000 vs 7000). 블록별 mat_cd로 상품 분리.
    diecut_mat = {
        "B02": ("MAT_000153", "유포(일반 완칼)"),       # 낱장 자유형 스티커=유포 대표
        "B03": ("MAT_000170", "투명데드롱(투명 완칼)"),  # 낱장 투명스티커=투명데드롱
        "B04": ("MAT_000153", "유포(대형 완칼)"),        # 대형 완칼=유포(400x600 규격 단독이라 충돌무)
    }
    out = []
    bt = _block_titles(rows)
    for bid, title in bt.items():
        if bid in ("B05", "B06", "B07"):  # 타투/기본가/스티커팩 — build_sticker_setup 경로
            continue
        for min_qty, bp, val, col in _band_body(rows, bid):
            parts = [p.strip() for p in bp.split(">")]
            if len(parts) == 2:  # B01: '규격 > 소재묶음'
                size_label, mat_label = parts
                siz = STICKER_SIZ.get(size_label, "")
                mat = STICKER_MAT.get(mat_label, "")
                note = "%s/%s/%s 출력매수≥%d (소재묶음=대표mat+note)" % (title, size_label, mat_label, min_qty)
            else:  # B02~B04: 규격(또는 합가라벨) 단독 + 블록별 소재(상품 구분)
                size_label = parts[0]
                if size_label in ("종이+인쇄+커팅",):  # 합가 라벨 → product 경로(스킵)
                    continue
                siz = STICKER_SIZ.get(size_label, "SIZ_PENDING_STK_%s" % size_label.replace("*", "x"))
                mat, mat_desc = diecut_mat.get(bid, ("", ""))
                note = "%s/%s 제작수량≥%d (완칼 규격단독, 소재=%s 상품구분축)" % (title, size_label, min_qty, mat_desc)
            out.append({
                "comp_cd": "COMP_STK_PRINT", "siz_cd": siz, "clr_cd": "", "mat_cd": mat,
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val, "note": note,
            })
    return out


# ───────────────────────── 10. 합판도무송스티커 (gangpan-sticker) ─────────────────────────
GANGPAN_MAT = {
    "비코팅/무광코팅/유광코팅": "MAT_000084",   # 대표=비코팅스티커 (무광 MAT_000155·유광 MAT_000156)
    "유포/투명데드롱/은데드롱": "MAT_000153",   # 대표=유포스티커 (투명데드롱 MAT_000170·은데드롱 MAT_000171)
}
# [wave-2 M-1 보정] 정사각12+직사각14=26종 라이브 실코드(정규화 정확매칭). 원형11종=라이브 부재 정당 placeholder.
# L1 라벨('정사각 10 x 10mm')→라이브 siz_nm('정사각10x10mm(8EA)') 정규화(공백제거·괄호(NEA)제거) 일치.
# 라이브 siz_nm의 (NEA) 면당 EA표기는 합판 면당 제작수 맥락 — siz 동일성은 후니 확인 권장(note 표기).
GANGPAN_SIZ = {
    "정사각 10 x 10mm": "SIZ_000212", "정사각 15 x 15mm": "SIZ_000213",
    "정사각 20 x 20mm": "SIZ_000214", "정사각 25 x 25mm": "SIZ_000215",
    "정사각 30 x 30mm": "SIZ_000216", "정사각 35 x 35mm": "SIZ_000217",
    "정사각 40 x 40mm": "SIZ_000218", "정사각 45 x 45mm": "SIZ_000219",
    "정사각 50 x 50mm": "SIZ_000220", "정사각 55 x 55mm": "SIZ_000221",
    "정사각 60 x 60mm": "SIZ_000222", "정사각 90 x 90mm": "SIZ_000223",
    "직사각 35 x 25mm": "SIZ_000224", "직사각 40 x 30mm": "SIZ_000226",
    "직사각 42 x 20mm": "SIZ_000228", "직사각 50 x 20mm": "SIZ_000230",
    "직사각 50 x 30mm": "SIZ_000232", "직사각 55 x 15mm": "SIZ_000234",
    "직사각 55 x 20mm": "SIZ_000236", "직사각 55 x 24mm": "SIZ_000238",
    "직사각 55 x 33mm": "SIZ_000240", "직사각 90 x 40mm": "SIZ_000242",
    "직사각 90 x 50mm": "SIZ_000244", "직사각 90 x 60mm": "SIZ_000245",
    "직사각 90 x 70mm": "SIZ_000247", "직사각 90 x 80mm": "SIZ_000249",
}


def transform_gangpan(rows):
    """합판도무송: 모양×사이즈mm × 소재묶음=mat × 제작수량=min_qty.
    계산공식집초안 행60/61: [고정가형] 판매가=[수량행][사이즈×소재열] (참조=합판도무송스티커).
    band_path='원형 10mm > 비코팅/무광코팅/유광코팅' (모양+사이즈mm > 소재묶음).
    [wave-2 M-1] 정사각/직사각 26종=라이브 실코드(GANGPAN_SIZ). 원형11종=라이브 부재 정당 SIZ_PENDING."""
    out = []
    bt = _block_titles(rows)
    for bid, title in bt.items():
        for min_qty, bp, val, col in _band_body(rows, bid):
            parts = [p.strip() for p in bp.split(">")]
            shape_size = parts[0]              # '원형 10mm' / '정사각 10 x 10mm' / '직사각 35 x 25mm'
            mat_label = parts[1] if len(parts) > 1 else ""
            mat = GANGPAN_MAT.get(mat_label, "")
            real = GANGPAN_SIZ.get(shape_size)
            if real:
                siz = real
                note = "%s/%s 제작수량≥%d (라이브 siz %s 실코드, (NEA)면당EA 후니확인, 소재묶음=대표mat)" \
                       % (shape_size, mat_label, min_qty, real)
            else:
                siz = "SIZ_PENDING_GP_%s" % shape_size.replace(" ", "")
                note = "%s/%s 제작수량≥%d (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)" \
                       % (shape_size, mat_label, min_qty)
            out.append({
                "comp_cd": "COMP_GANGPAN_PRINT", "siz_cd": siz, "clr_cd": "", "mat_cd": mat,
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val,
                "note": note,
            })
    return out


# ───────────────────────── 11. 명함포토카드 (namecard-photocard) ─────────────────────────
# 명함종(상품) → comp_cd 접미 (검증 적발: 명함종이 다르면 같은 q·면도 단가 상이 → 명함종 흡수 M-1)
NAMECARD_PROD = {
    "B01": "STD", "B02": "PREMIUM", "B03": "COAT", "B04": "PEARL",
    "B05": "CLEAR", "B06": "WHITE", "B07": "SHAPE", "B08": "MINISHAPE",
}
# 소재군(블록 내 A/B군 또는 용지군) → 대표 mat_cd (군=여러 소재 동일단가, note 보존)
NAMECARD_MAT = {
    "백모조220 / 아트250 / 스노우250": "MAT_000074",   # 대표=백색모조지220g
    "아트300 / 스노우300": "MAT_000082",                # 대표=아트지300g
    "아트250": "MAT_000081",                            # 코팅명함 아트지250g
    "아트300": "MAT_000082",                            # 코팅명함 아트지300g
    "다이아 240 / 실버 240 / 골드 240": "MAT_000127",  # 대표=스타드림(다이아몬드)240g
    "로츠쿼츠 240": "MAT_000130",                       # 스타드림(로즈쿼츠)240g
    "투명PET 260 / 반투명PET 260": "",                  # PET 실코드 미확정 → mat NULL + note
    "몽블랑240": "",                                    # 몽블랑 실코드 미확정 → note
    # 프리미엄 A/B군은 단가차(가격축) → comp_cd 접미로 흡수(아래 mat_grp_suffix). NAMECARD_MAT엔 미포함.
}
# 명함 소재군 가격축 흡수: A/B군처럼 단가가 다른 소재군은 comp_cd 접미로 분리(M-1)
NAMECARD_MATGRP = {"A": "MGA", "B": "MGB"}
NAMECARD_SIZ = {"B07": "SIZ_000008", "B08": "SIZ_000011"}  # 모양90x50 / 미니50x50


def transform_namecard(rows):
    """명함포토카드: 명함종(상품, comp흡수 M-1) × 면(comp흡수) × 소재군=mat × 수량=min_qty. 행39 '용지 포함 가격'.
    계산공식집초안 행32/33/43: [고정가형] 판매가=[수량행][소재×면열]+후가공.
    B01~B08 일반명함(명함종별 면×소재) / B09 오리지널박(합가→build_namecard_extra) / B12 포토대량.
    [검증 적발] 명함종이 다르면 같은 (면,수량,소재공란) 자연키 충돌(STD q100 4500 vs PREMIUM 9000).
    명함종을 comp_cd에 흡수(M-1)하고 소재군은 대표 mat_cd로 분리(같은 명함종 내 A/B군 단가차 구분).
    실무진메모: 행39 명함가=용지포함 단품가(분해 금지). B06 화이트=별색('화이트(단면)+클리어')→note."""
    side_suffix = {"단면": "S1", "양면": "S2", "화이트(단면)": "S1W", "화이트(양면)": "S2W"}
    out = []
    bt = _block_titles(rows)
    for bid, title in bt.items():
        if bid in ("B09", "B10", "B11", "B12"):  # 박/포토세트/포토대량 — build_namecard_extra 경로
            continue
        prod = NAMECARD_PROD.get(bid)
        if prod is None:
            continue
        siz = NAMECARD_SIZ.get(bid, "")
        for min_qty, bp, val, col in _band_body(rows, bid):
            parts = [p.strip() for p in bp.split(">")]
            grp_suf = ""   # 소재군 가격축(A/B) comp 접미
            if len(parts) < 2:
                # B06 화이트인쇄: band='화이트(단면)+클리어(없음)' 등 별색조합 leaf(>없음).
                # 클리어 유무가 가격축 → 별색조합 전체를 comp 접미로 흡수(M-1, 별색=공정 규칙① 동형).
                combo = parts[0]
                side_key = "화이트(단면)" if "화이트(단면)" in combo else "화이트(양면)"
                # 클리어 유무를 접미로: '클리어(없음)'→NOCL, '클리어(단면)/클리어(양면)'→CL
                grp_suf = "NOCL" if "클리어(없음)" in combo else "CL"
                mat_label = combo
                mat = "MAT_000137"  # 큐리어스스킨 화이트 270g (소재군 대표)
            else:
                side_key, mat_label = parts[0], parts[1]
                if mat_label in NAMECARD_MATGRP:    # A/B 소재군 단가축 → comp 흡수
                    grp_suf = NAMECARD_MATGRP[mat_label]
                    mat = ""
                else:
                    mat = NAMECARD_MAT.get(mat_label, "")
            suf = side_suffix.get(side_key)
            if suf is None:
                continue
            comp_cd = "COMP_NAMECARD_%s_%s" % (prod, suf)  # 명함종+면 흡수(M-1)
            if grp_suf:
                comp_cd += "_" + grp_suf                   # 소재군/별색조합 가격축 흡수
            note = "%s/%s/%s 제작수량≥%d (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)" \
                   % (title, side_key, mat_label, min_qty)
            out.append({
                "comp_cd": comp_cd, "siz_cd": siz, "clr_cd": "", "mat_cd": mat,
                "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
                "unit_price": val, "note": note,
            })
    return out


# ───────────────────────── 12. 엽서북떡메 (postcard-book) ─────────────────────────
POSTCARD_SIZ = {"100*150": "SIZ_000003", "150*100": "SIZ_000124", "135*135": "SIZ_000004"}
# [wave-2 B-1] 떡메모지 사이즈 라이브 실코드: 90x90=SIZ_000119, 70x120=SIZ_000266
TTEOKME_SIZ = {"90x90mm": "SIZ_000119", "70x120mm": "SIZ_000266"}


def transform_postcard_book(rows):
    """엽서북: 사이즈=siz × 면(단/양면 comp흡수) × 페이지(20P/30P comp흡수) × 수량=min_qty. 4축.
    계산공식집초안 행71/72: [고정가형] 판매가=[수량행][옵션열] (참조=엽서북/떡메).
    band_path='100*150 > 단면 > 20P' (사이즈>면>페이지). 페이지=component_prices 차원 부재 → comp흡수(M-1).
    B01 엽서북(4축) / B02 떡메모지 사이즈헤더 / B03 떡메모지 장수×권당장수 매트릭스(build_tteokme)."""
    side_map = {"단면": "S1", "양면": "S2"}
    page_map = {"20P": "20P", "30P": "30P"}
    out = []
    for min_qty, bp, val, col in _band_body(rows, "B01"):
        parts = [p.strip() for p in bp.split(">")]
        if len(parts) != 3:
            continue
        size_label, side, page = parts
        siz = POSTCARD_SIZ.get(size_label, "SIZ_PENDING_PCB_%s" % size_label.replace("*", "x"))
        sd = side_map.get(side)
        pg = page_map.get(page)
        if not sd or not pg:
            continue
        comp_cd = "COMP_PCB_%s_%s" % (sd, pg)  # 면×페이지 comp흡수(M-1, 페이지 차원 부재 해소)
        out.append({
            "comp_cd": comp_cd, "siz_cd": siz, "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
            "unit_price": val,
            "note": "엽서북/%s/%s/%s 수량≥%d (페이지=comp흡수 차원부재, 면=comp흡수)"
                    % (size_label, side, page, min_qty),
        })
    # [wave-2 B-1] 떡메모지(B02 사이즈헤더 + B03 장수×권당장수 매트릭스) 추가 적재
    out.extend(_build_tteokme(rows))
    return out


def _build_tteokme(rows):
    """떡메모지(B03): 사이즈(90x90/70x120=siz) × 권당장수(50장1권/100장1권=bdl_qty) × 장수(min_qty).
    계산공식집초안 행91/92: [고정가형] 판매가=[수량행][옵션열] (참조=엽서북/떡메).
    B03 band 공란 → col 위치로 (사이즈,권당장수) 판별: B/C=90x90mm, D/E=70x120mm; B/D=50장1권, C/E=100장1권.
    권당장수='50장 1권'→bdl_qty=50, '100장 1권'→100. 장수(6/12/18…)=min_qty(권당 페이지수, 상향개방)."""
    # col → (siz_cd, bdl_qty) (B02 사이즈 헤더 + B03 권당장수 헤더 라이브 정합)
    col_map = {
        "B": ("SIZ_000119", 50),   # 90x90mm / 50장1권
        "C": ("SIZ_000119", 100),  # 90x90mm / 100장1권
        "D": ("SIZ_000266", 50),   # 70x120mm / 50장1권
        "E": ("SIZ_000266", 100),  # 70x120mm / 100장1권
    }
    label = {50: "50장1권", 100: "100장1권"}
    siz_label = {"SIZ_000119": "90x90mm", "SIZ_000266": "70x120mm"}
    out = []
    for r in rows:
        if r["block_id"] != "B03" or r["col"] not in col_map:
            continue
        rk = r["row_key"]; v = r["value"]
        if not (rk and v and rk.replace(".", "", 1).isdigit() and v.replace(".", "", 1).isdigit()):
            continue
        siz, bdl = col_map[r["col"]]
        out.append({
            "comp_cd": "COMP_TTEOKME", "siz_cd": siz, "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": bdl, "min_qty": int(rk),
            "unit_price": v,
            "note": "떡메모지/%s/%s 장수≥%s (권당장수=bdl_qty, 장수=min_qty, PRD_000097)"
                    % (siz_label[siz], label[bdl], rk),
        })
    return out


# ═══════════════════════════════════════════════════════════════════════════════
#  13. 포스터사인 (poster-sign) — 면적시트, 31블록
# ═══════════════════════════════════════════════════════════════════════════════
#  🔴 실무진 메모 권위(HARD): 메인셀에 "포함항목 명시"(출력+코팅+가공 포함가 등) → 메인=완제품비(.06)
#     통가격 1행, note에 포함항목 그대로. 추가옵션(천정형고리/우드행거/거치대/가공옵션)=별도 comp,
#     세트("*2개 1세트")=bdl_qty. 규칙④(합가=통가격 비분해)·규칙⑩(.06 완제품비).
#  레이아웃 2종: (A) AREA 가로×세로 면적매트릭스(아크릴 동형, transposed band) — B01~B11,B26,B27.
#                (B) LABEL(포함항목 메타)+SIZEQTY(가격) 쌍 — B12/B13 … B30/B31.
#  siz_cd: 라이브 정확매칭(POSTER_SQ/POSTER_AREA_DIRECT 실코드). REVERSED/부재=SIZ_PENDING+등록대기.
#  comp_cd: 소재(=상품 분기)별 분리. 메인=COMP_POSTER_<소재>(완제품비 .06).

# 블록 → 소재슬러그(comp_cd 접미) + 메인 포함항목 note. AREA·LABEL 공통.
POSTER_BLOCK = {
    # AREA 블록(가로×세로 면적매트릭스)
    "B01": ("ARTPRINT_PHOTO", "아트프린트포스터(인화지)", "코팅포함가"),
    "B02": ("ARTPAPER_MATTE", "아트페이퍼포스터(매트지)", "출력가"),
    "B03": ("WATERPROOF_PET", "방수포스터(PET)", "코팅포함가"),
    "B04": ("ADH_WATERPROOF_PVC", "접착방수포스터(PVC)", "코팅포함가"),
    "B05": ("ADH_CLEAR_PVC", "접착투명포스터(투명PVC)", "출력가"),
    "B06": ("ARTFABRIC_GRAPHIC", "아트패브릭포스터(그래픽천)", "출력가"),
    "B07": ("LINEN_FABRIC", "린넨패브릭포스터", "린넨후가공 포함"),
    "B08": ("CANVAS_FABRIC", "캔버스패브릭포스터", "출력가"),
    "B09": ("LEATHER_ARTPRINT", "레더아트프린트", "출력가"),
    "B10": ("TYVEK_PRINT", "타이벡프린트(하드/소프트)", "출력가"),
    "B11": ("MESH_PRINT", "메쉬프린트", "출력+코팅+가공 포함가"),
    "B26": ("BANNER_NORMAL", "일반현수막", "출력가"),
    "B27": ("BANNER_MESH", "메쉬현수막", "출력가"),
    # LABEL 블록(메타) → 직후 SIZEQTY 가격블록과 쌍. 메인 완제품 포함항목.
    "B12": ("FRAMELESS_WOOD", "프레임리스우드액자", "출력+코팅+가공 포함가"),
    "B14": ("LEATHER_FRAME", "레더아트액자", "출력+가공 포함가"),
    "B16": ("JOKJA", "족자포스터", "출력+코팅+가공(사각족자/원형족자) 포함가"),
    "B18": ("CANVAS_HANGING", "캔버스행잉포스터", "출력+가공(오버로크) 포함가"),
    "B20": ("LINEN_WOODBONG", "린넨우드봉족자", "출력+가공(봉미싱) 포함가"),
    "B22": ("PET_BANNER", "PET배너", "출력+코팅+가공(4구아일렛) 포함가"),
    "B24": ("MESH_BANNER", "메쉬배너", "출력+코팅+가공(4구아일렛) 포함가"),
    "B28": ("MINI_STANDBOARD", "미니스탠딩보드", "출력+코팅+가공(보드접착+거치대) 포함가"),
    "B30": ("MINI_BANNER", "미니배너", "출력+코팅+거치대 포함가"),
}
# SIZEQTY 가격블록 → 쌍이 되는 LABEL 블록(소재/포함항목 상속)
POSTER_SQ_PAIR = {"B13": "B12", "B15": "B14", "B17": "B16", "B19": "B18",
                  "B21": "B20", "B23": "B22", "B25": "B24", "B29": "B28", "B31": "B30"}
# 추가옵션명 → comp_cd 접미(영문 슬러그). 세트수량은 별도 파싱.
POSTER_OPT_SLUG = {
    "천정형고리 포함": "CEILHOOK", "우드행거+면끈": "WOODHANGER", "우드봉+면끈": "WOODBONG",
    "실내용배너거치대": "STAND_IN", "실외용배너거치대(단면용)": "STAND_OUT_S1",
    "실외용배너거치대(양면용)": "STAND_OUT_S2",
}
# 블록(소재) → 라이브 실 prd_cd (read-only SELECT 확증, 무발명). 21상품 전건 라이브 실재.
POSTER_BLOCK_PRD = {
    "B01": "PRD_000118", "B02": "PRD_000119", "B03": "PRD_000120", "B04": "PRD_000121",
    "B05": "PRD_000122", "B06": "PRD_000123", "B07": "PRD_000124", "B08": "PRD_000125",
    "B09": "PRD_000126", "B10": "PRD_000127", "B11": "PRD_000128", "B26": "PRD_000138",
    "B27": "PRD_000139",
    "B12": "PRD_000131", "B14": "PRD_000132", "B16": "PRD_000135", "B18": "PRD_000133",
    "B20": "PRD_000134", "B22": "PRD_000136", "B24": "PRD_000137", "B28": "PRD_000144",
    "B30": "PRD_000145",
}


def _poster_size_siz(label, is_area_main=False):
    """포스터 사이즈 라벨 → 라이브 실코드 또는 SIZE_PENDING. 반환:(siz_cd, kind).
    - 규격(A4/300*600)=POSTER_SQ 실코드.
    - is_area_main=True(가로×세로 면적매트릭스, 직접입력형): DIRECT만 실코드, REVERSED=의미축
      불일치 에스컬레이션(placeholder). 아크릴 M-1 정정과 동일 안전원칙.
    - is_area_main=False(고정 카탈로그: 규격명·서브제품 사이즈 290x90 등): LIVE_COORD_ALL DIRECT
      재사용(고정 카탈로그는 가로/세로 의미축 고정 → dodge 방지 위해 실코드 재사용)."""
    lab = label.strip()
    base = lab.replace(" mm", "").replace("mm", "").strip()
    if base in POSTER_SQ:
        return POSTER_SQ[base], "real"
    norm = base.replace("*", "x").replace(" ", "")
    if is_area_main:
        if norm in POSTER_AREA_DIRECT:
            return POSTER_AREA_DIRECT[norm], "real"
        if norm in POSTER_AREA_REVERSED:
            return "SIZ_PENDING_POSTER_%s" % norm, "reversed"
    else:
        # 고정 카탈로그(규격명/서브제품 사이즈): 라이브 전체 좌표 DIRECT 정확매칭 재사용
        if norm in LIVE_COORD_ALL:
            return LIVE_COORD_ALL[norm], "real"
    # 라이브 부재 → 등록대기
    slug = base.replace("*", "x").replace(" ", "").replace("/", "_")
    return "SIZ_PENDING_POSTER_%s" % slug, "none"


def transform_poster(rows):
    """포스터사인 31블록 → 메인 완제품가(.06) + 추가옵션(별도 comp). 실무진 포함항목 note 권위.
    AREA(13): 가로×세로 면적매트릭스 메인가. SIZEQTY(9): 사이즈×수량 메인가 + 추가옵션. LABEL(9): 메타뿐."""
    out = []
    bt = _block_titles(rows)

    def layout(bid):
        if any(r["block_id"] == bid and r["row_key"] == "가로 / 세로" for r in rows):
            return "AREA"
        if any(r["block_id"] == bid and (r["row_key"] or "").strip() == "사이즈 / 수량" for r in rows):
            return "SIZEQTY"
        return "LABEL"

    for bid in bt:
        lay = layout(bid)
        if lay == "AREA":
            out.extend(_poster_area_main(rows, bid))
            out.extend(_poster_area_options(rows, bid))   # 현수막 가공옵션·추가옵션
        elif lay == "SIZEQTY":
            out.extend(_poster_sizeqty_main(rows, bid))
            out.extend(_poster_sizeqty_options(rows, bid))
        # LABEL 블록은 메타(포함항목 텍스트)뿐 — 가격 없음. 포함항목은 쌍 SIZEQTY note로 상속.
    # [추출결함 보정 — 중첩 서브제품] L1이 한 block_title에 여러 논리블록을 묶음:
    #   B11(메쉬프린트) 안에 폼보드(PRD_000129)·포맥스보드(PRD_000130),
    #   B27(메쉬현수막) 안에 유광/미러 아크릴스티커(PRD_000142/143).
    # "사이즈 / 옵션명" 또는 "사이즈 / 소재" 헤더로 시작하는 별도 매트릭스 → 별 comp/상품으로 적재.
    out.extend(_poster_subproducts(rows))
    return out


# 중첩 서브제품(추출결함 보정): (block_id, 헤더_row_key, 시작제품라벨) → (comp슬러그, 상품명, prd_cd, 포함항목)
POSTER_SUBPRODUCTS = [
    # B11 폼보드: 사이즈(A3/A2/A1) × 보드종(화이트보드/블랙보드) 매트릭스
    ("B11", "폼보드", "FOAMBOARD", "폼보드", "PRD_000129", "출력+코팅+가공 포함가"),
    # B11 포맥스보드: 사이즈 × 포맥스종(화이트포맥스3mm/5mm)
    ("B11", "포맥스보드", "FOMEXBOARD", "포맥스보드", "PRD_000130", "출력+코팅+가공 포함가"),
    # B27 아크릴스티커: 사이즈(290x90~590x390) × 소재(유광/미러)
    ("B27", "아크릴스티커 (유광 / 미러)", "ACRYLSTK", "아크릴스티커(유광/미러)", "PRD_000142,PRD_000143", "유광/미러"),
    # B27 시트커팅: 사이즈(A4/A3/A2) × 소재(무광/홀로그램) — 무광시트커팅·홀로그램시트커팅
    ("B27", "시트커팅 (무광 / 홀로그램)", "SHEETCUT", "시트커팅(무광/홀로그램)", "PRD_000140,PRD_000141", "시트커팅"),
]


def _poster_subproducts(rows):
    """B11/B27 중첩 서브제품(폼보드·포맥스보드·아크릴스티커) → 별도 comp(.06 완제품가).
    구조: 제품라벨 행 → '사이즈 / 옵션명'(또는 '사이즈 / 소재') 헤더행(B~E열=사이즈) → 옵션/소재 행(B~E=가격).
    사이즈=라이브 실코드(POSTER_SQ/AREA 또는 _poster_size_siz), 옵션/소재=comp 접미 흡수."""
    out = []
    for bid, anchor_label, slug, name, prd, incl in POSTER_SUBPRODUCTS:
        brows = [r for r in rows if r["block_id"] == bid]
        # 앵커(제품라벨) row_seq 찾기
        anchor_seq = None
        for r in brows:
            if (r["row_key"] or "").strip() == anchor_label and r["col"] == "A":
                anchor_seq = int(r["row_seq"]); break
        if anchor_seq is None:
            continue
        # 앵커 이후 첫 헤더행('사이즈 / 옵션명' 또는 '사이즈 / 소재')에서 col→사이즈
        col_to_size = {}
        header_seq = None
        for r in sorted(brows, key=lambda x: int(x["row_seq"])):
            seq = int(r["row_seq"])
            if seq <= anchor_seq:
                continue
            rk = (r["row_key"] or "").strip()
            if rk in ("사이즈 / 옵션명", "사이즈 / 소재") and r["col"] in ("B", "C", "D", "E", "F"):
                if header_seq is None:
                    header_seq = seq
                if seq == header_seq and r["value"]:
                    col_to_size[r["col"]] = r["value"].strip()
            # 다음 제품 앵커(다른 anchor_label) 만나면 중단
            if rk in [s[1] for s in POSTER_SUBPRODUCTS if s[0] == bid and s[1] != anchor_label] and r["col"] == "A":
                stop_seq = seq
                break
        else:
            stop_seq = 10 ** 9
        if header_seq is None:
            continue
        # 옵션/소재 행: header_seq+1부터 stop_seq 직전까지, A열=옵션/소재라벨, B~F=가격
        opt_rows = collections.defaultdict(dict)  # row_seq -> {col: (value,row_key)}
        for r in brows:
            seq = int(r["row_seq"])
            if seq <= header_seq:
                continue
            # stop: 다음 서브제품 앵커 이전까지
            other_anchors = [s[1] for s in POSTER_SUBPRODUCTS if s[0] == bid and s[1] != anchor_label]
            opt_rows[seq][r["col"]] = (r["value"], (r["row_key"] or "").strip())
        next_anchor_seqs = []
        for r in brows:
            if (r["row_key"] or "").strip() in [s[1] for s in POSTER_SUBPRODUCTS
                                                 if s[0] == bid and s[1] != anchor_label] and r["col"] == "A":
                ns = int(r["row_seq"])
                if ns > header_seq:
                    next_anchor_seqs.append(ns)
        limit = min(next_anchor_seqs) if next_anchor_seqs else 10 ** 9
        for seq in sorted(opt_rows):
            if seq >= limit:
                break
            cells = opt_rows[seq]
            opt_label = ""
            for col in ("A",):
                if col in cells:
                    opt_label = (cells[col][1] or cells[col][0] or "").strip()
            if not opt_label or opt_label in ("사이즈 / 옵션명", "사이즈 / 소재", anchor_label):
                continue
            for col, size_label in col_to_size.items():
                cell = cells.get(col)
                if not cell or not is_num(cell[0]):
                    continue
                val = cell[0]
                siz, kind = _poster_size_siz(size_label)
                opt_slug = _opt_ko_slug2(opt_label)
                out.append({
                    "comp_cd": "COMP_POSTER_%s_%s" % (slug, opt_slug),
                    "siz_cd": siz, "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                    "bdl_qty": "", "min_qty": "", "unit_price": val,
                    "note": "%s/%s/%s 완제품가[%s] (중첩서브제품 추출결함보정, %s, 완제품비.06, %s)"
                            % (name, opt_label, size_label, incl, _poster_siz_note(kind, siz), prd),
                })
    return out


def _opt_ko_slug2(s):
    """서브제품 옵션/소재 라벨 → 안정 영문 슬러그(보드종/소재)."""
    table = [("화이트보드", "WHITE"), ("블랙보드", "BLACK"),
             ("화이트포맥스(3mm)", "WHITE3MM"), ("화이트포맥스(5mm)", "WHITE5MM"),
             ("유광 (화이트 / 블랙)", "GLOSS"), ("미러 (골드/실버)", "MIRROR"),
             ("무광(화이트/블랙)", "MATTE"), ("홀로그램", "HOLO")]
    for ko, en in table:
        if s.startswith(ko) or ko in s:
            return en
    import re as _re
    return "OPT_" + _re.sub(r"[^0-9]", "", s) if _re.search(r"\d", s) else "OPT"


def _poster_area_main(rows, bid):
    """AREA 메인 면적매트릭스(가로×세로 → 완제품가 .06). 아크릴 동형 transposed 디코드.
    가로=row_key='가로 / 세로' 행의 mm leaf(col), 세로=A열 row_key mm, body=단가."""
    slug, name, incl = POSTER_BLOCK.get(bid, (bid, bid, ""))
    col_to_w = {}
    for r in rows:
        if (r["block_id"] == bid and r["row_key"] == "가로 / 세로"
                and r["col"] not in ("A", "J", "K", "L", "M", "N")
                and r["value"] and r["value"].endswith("mm")):
            col_to_w[r["col"]] = r["value"]
    out = []
    for r in rows:
        if r["block_id"] != bid or r["col"] in ("A", "J", "K", "L", "M", "N"):
            continue
        rk = r["row_key"]; val = r["value"]; w = col_to_w.get(r["col"])
        if not (rk and rk.endswith("mm") and w and is_num(val)):
            continue
        wn = w.replace("mm", ""); hn = rk.replace("mm", "")
        siz, kind = _poster_size_siz("%sx%s" % (wn, hn), is_area_main=True)
        out.append({
            "comp_cd": "COMP_POSTER_%s" % slug, "siz_cd": siz, "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": "",
            "unit_price": val,
            "note": "%s 가로%s×세로%s 완제품가[%s] (%s, 완제품비.06)"
                    % (name, w, rk, incl, _poster_siz_note(kind, siz)),
        })
    return out


def _poster_siz_note(kind, siz):
    if kind == "real":
        return "라이브 siz %s 실코드" % siz
    if kind == "reversed":
        return "에스컬레이션: 라이브 역방향(HxW)만 존재, 의미축 불일치로 placeholder"
    return "라이브 부재 SIZ_PENDING 등록대기"


def _poster_sizeqty_main(rows, bid):
    """SIZEQTY 메인 가격: 헤더행(사이즈 / 수량)의 B~I열 사이즈 라벨 × A열 수량(min_qty) → 완제품가.
    포함항목은 쌍 LABEL 블록에서 상속(POSTER_SQ_PAIR)."""
    label_bid = POSTER_SQ_PAIR.get(bid, bid)
    slug, name, incl = POSTER_BLOCK.get(label_bid, (bid, bid, ""))
    # 헤더행: col → 사이즈 라벨 (메인 영역 B~I, 추가옵션 영역 J~N 제외)
    col_to_size = {}
    for r in rows:
        if (r["block_id"] == bid and (r["row_key"] or "").strip() == "사이즈 / 수량"
                and r["col"] in ("B", "C", "D", "E", "F", "G", "H", "I") and r["value"]):
            col_to_size[r["col"]] = r["value"].strip()
    out = []
    for r in rows:
        if r["block_id"] != bid or r["col"] not in col_to_size:
            continue
        rk = r["row_key"]; val = r["value"]
        if not (is_num(rk) or _is_qty_label(rk)) or not is_num(val):
            continue
        min_qty = int(float(rk)) if is_num(rk) else 1
        size_label = col_to_size[r["col"]]
        siz, kind = _poster_size_siz(size_label)
        out.append({
            "comp_cd": "COMP_POSTER_%s" % slug, "siz_cd": siz, "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty,
            "unit_price": val,
            "note": "%s %s 수량≥%d 완제품가[%s] (%s, 완제품비.06)"
                    % (name, size_label, min_qty, incl, _poster_siz_note(kind, siz)),
        })
    return out


def _is_qty_label(rk):
    return rk not in (None, "") and rk.replace(".", "", 1).isdigit()


def _poster_sizeqty_options(rows, bid):
    """SIZEQTY 추가옵션(J~N열): 추가옵션명 × (단순가 또는 사이즈별가). 별도 comp(추가가격).
    세트('*2개 1세트')=bdl_qty. 옵션값=0(추가없음/출력만)은 baseline → 적재 제외(메인에 포함)."""
    label_bid = POSTER_SQ_PAIR.get(bid, bid)
    slug, name, _ = POSTER_BLOCK.get(label_bid, (bid, bid, ""))
    out = []
    # 옵션 영역 헤더(J~N열, row_key='사이즈 / 수량'): 사이즈별 추가옵션이면 K~N에 사이즈 라벨
    opt_size_cols = {}
    for r in rows:
        if (r["block_id"] == bid and (r["row_key"] or "").strip() == "사이즈 / 수량"
                and r["col"] in ("K", "L", "M", "N") and r["value"]
                and r["value"] not in ("*모든사이즈",)):
            v = r["value"].strip()
            if v not in ("추가옵션명", "사이즈 / 추가옵션"):
                opt_size_cols[r["col"]] = v
    # 옵션 행: J열=옵션명, 값셀=K(단순) 또는 K~N(사이즈별)
    # 그룹: 같은 row_seq의 J(옵션명) + 값들 + L(세트표기)
    rowmap = collections.defaultdict(dict)
    for r in rows:
        if r["block_id"] == bid and r["col"] in ("J", "K", "L", "M", "N"):
            rowmap[r["row_seq"]][r["col"]] = r["value"]
    for rseq, cells in rowmap.items():
        opt_name = (cells.get("J") or "").strip()
        if not opt_name or opt_name in ("추가옵션명", "사이즈 / 추가옵션", "추가없음", "출력만",
                                        "거치대없음", "사이즈 / 수량"):
            continue
        slug_opt = POSTER_OPT_SLUG.get(opt_name)
        if slug_opt is None:
            # 미지 옵션 라벨 — 침묵 매핑 금지(에스컬레이션 note 남기되 적재 제외)
            continue
        if opt_size_cols:  # 사이즈별 추가옵션(우드행거/우드봉: K~N에 사이즈별 가격)
            for col, size_label in opt_size_cols.items():
                val = cells.get(col)
                if not is_num(val) or float(val) == 0:
                    continue
                siz, kind = _poster_size_siz(size_label)
                out.append({
                    "comp_cd": "COMP_POSTEROPT_%s_%s" % (slug, slug_opt),
                    "siz_cd": siz, "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                    "bdl_qty": "", "min_qty": "", "unit_price": val,
                    "note": "%s 추가옵션 %s/%s 추가가격 (별도 add-on, %s)"
                            % (name, opt_name, size_label, _poster_siz_note(kind, siz)),
                })
        else:  # 단순 추가옵션(천정형고리/거치대: K열 단일가)
            val = cells.get("K")
            if not is_num(val) or float(val) == 0:
                continue
            # 세트표기(L열): '*2개 1세트' → bdl_qty
            set_note = (cells.get("L") or "").strip()
            bdl = ""
            m = None
            import re as _re
            m = _re.search(r"(\d+)개\s*1세트", set_note)
            if m:
                bdl = int(m.group(1))
            out.append({
                "comp_cd": "COMP_POSTEROPT_%s_%s" % (slug, slug_opt),
                "siz_cd": "", "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                "bdl_qty": bdl, "min_qty": "", "unit_price": val,
                "note": "%s 추가옵션 %s 추가가격 (별도 add-on%s)"
                        % (name, opt_name, (", %s=bdl_qty %d" % (set_note, bdl)) if bdl else ""),
            })
    return out


def _poster_area_options(rows, bid):
    """AREA 블록 추가옵션(현수막 B26/B27): 가공옵션(J=명,K=가격) + 추가옵션(M=명,N=가격).
    가공옵션=열재단/타공/봉미싱(가격有), 추가옵션=큐방/끈/각목(가격有). 별도 comp(가공/추가 add-on)."""
    if bid not in ("B26", "B27"):
        return []
    slug, name, _ = POSTER_BLOCK.get(bid, (bid, bid, ""))
    out = []
    # 가공옵션: J=옵션명, K=가격 (세로축 row_key는 mm이나 가공옵션은 모든사이즈 공통 → siz 무관)
    seen_proc = set()
    for r in rows:
        if r["block_id"] != bid:
            continue
    # row_seq별 J/K/M/N 그룹
    rowmap = collections.defaultdict(dict)
    for r in rows:
        if r["block_id"] == bid and r["col"] in ("J", "K", "M", "N"):
            rowmap[r["row_seq"]][r["col"]] = (r["value"], r["row_key"])
    for rseq, cells in rowmap.items():
        # 가공옵션(J명/K가격). 0값(재단만/추가없음 baseline=메인포함)은 적재 제외.
        jn = (cells.get("J", ("", ""))[0] or "").strip()
        kp = cells.get("K", ("", ""))[0]
        if (jn and jn not in ("가공옵션명", "일반현수막 가공옵션 추가가격", "추가없음", "재단만")
                and is_num(kp) and float(kp) != 0):
            key = ("PROC", jn)
            if key not in seen_proc:
                seen_proc.add(key)
                out.append({
                    "comp_cd": "COMP_POSTEROPT_%s_PROC_%s" % (slug, _opt_ko_slug(jn)),
                    "siz_cd": "", "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                    "bdl_qty": "", "min_qty": "", "unit_price": kp,
                    "note": "%s 가공옵션 %s 추가가격 (별도 add-on, 모든사이즈 공통)" % (name, jn),
                })
        # 추가옵션(M명/N가격)
        mn = (cells.get("M", ("", ""))[0] or "").strip()
        npv = cells.get("N", ("", ""))[0]
        if mn and mn not in ("추가옵션명", "일반현수막 추가옵션 추가가격", "추가없음") and is_num(npv) and float(npv) != 0:
            key = ("ADD", mn)
            if key not in seen_proc:
                seen_proc.add(key)
                out.append({
                    "comp_cd": "COMP_POSTEROPT_%s_ADD_%s" % (slug, _opt_ko_slug(mn)),
                    "siz_cd": "", "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                    "bdl_qty": "", "min_qty": "", "unit_price": npv,
                    "note": "%s 추가옵션 %s 추가가격 (별도 add-on)" % (name, mn),
                })
    return out


def _opt_ko_slug(s):
    """한글 옵션명 → 안정 슬러그(영문 키워드+조건 구분 보존, 침묵충돌 금지).
    '각목(900mm이하)' vs '각목(900mm 초과)'처럼 조건이 다르면 단가가 다르므로 슬러그도 달라야 함."""
    import re as _re
    table = [("열재단", "CUTEDGE"), ("타공", "PUNCH"), ("양면테잎", "DTAPE"), ("봉미싱", "BONGSEW"),
             ("큐방", "QBANG"), ("각목", "GAKMOK"), ("끈", "STRING")]
    parts = []
    for ko, en in table:
        if ko in s:
            parts.append(en)
    nums = _re.findall(r"\d+", s)
    cond = ""
    if "이하" in s:
        cond = "_LE"
    elif "초과" in s:
        cond = "_GT"
    elif "이상" in s:
        cond = "_GE"
    elif "미만" in s:
        cond = "_LT"
    suffix = ("_" + "_".join(nums)) if nums else ""
    if parts:
        return "_".join(parts) + suffix + cond
    return "OPT" + suffix + cond


# ───────────────────────── 공통: 자연키8 중복제거 + CSV write ─────────────────────────
NATURAL_KEY = ("comp_cd", "apply_ymd", "siz_cd", "clr_cd", "mat_cd",
               "coat_side_cnt", "bdl_qty", "min_qty")


def dedup_natural_key(records):
    """C-2 자연키8 조합 중복 사전제거. 중복 시 첫 행 유지, 충돌(다른 단가) 경고."""
    seen = {}
    dups = []
    out = []
    for rec in records:
        rec["apply_ymd"] = APPLY_YMD
        key = tuple(str(rec.get(k, "")) for k in NATURAL_KEY)
        if key in seen:
            if seen[key]["unit_price"] != rec["unit_price"]:
                dups.append((key, seen[key]["unit_price"], rec["unit_price"]))
            continue
        seen[key] = rec
        out.append(rec)
    return out, dups


def write_component_prices(records):
    """t_prc_component_prices.csv write. comp_price_id surrogate 부여(1부터). 공란=NULL(빈문자열)."""
    os.makedirs(LOAD_DIR, exist_ok=True)
    path = os.path.join(LOAD_DIR, "t_prc_component_prices.csv")
    with open(path, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=CP_HEADER)
        w.writeheader()
        for i, rec in enumerate(records, start=1):
            row = {k: rec.get(k, "") for k in CP_HEADER}
            row["comp_price_id"] = i
            row["apply_ymd"] = APPLY_YMD
            w.writerow(row)
    return path


# ───────────────────────── 합가 → t_prd_product_prices (규칙④) ─────────────────────────
# 합가(단가+합가 공존 시 합가 그대로 상품단가, 분해 금지). 사이즈/수량별 변동분은 component_prices 차원에
# 종속하나(규칙④ 단서), 여기서는 "수량 단일축 합가"를 product_prices로(단가표 합가 라벨 영역).
PP_HEADER = ["prd_cd", "apply_ymd", "unit_price", "note"]


def build_cutting_products(rows):
    """커팅 B01 완칼('인쇄비+소재+커팅' 합가) + B03 타공합가(F~I열) → product_prices.
    완칼 합가는 출력매수별 변동 → prd_cd 단일이면 수량차원 표현 불가(product_prices PK=(prd,ymd)).
    [설계 결정] 합가가 수량별로 변하므로 product_prices 1행 불가 → component_prices 차원(min_qty)으로
    합가 comp(COMP_CUT_FULL)에 적재(규칙④ 단서: 합가가 수량별 변동 시 component_prices 차원 종속).
    완칼 prd=반칼아닌 완칼 자유형, 타공합가=헤더택/벽걸이캘린더. 여기선 component_prices 행으로 반환."""
    out = []
    # B01 완칼: '인쇄비+소재+커팅'은 합가의 의미설명 헤더(C1/C2 라벨 2셀뿐), 실단가는 '단면' band(B열) body.
    # 즉 완칼 단가 자체가 인쇄비+소재+커팅 합가 → '단면' band body를 합가로 적재(규칙④, 수량변동→차원).
    for r in rows:
        if r["block_id"] != "B01" or r["col"] == "A":
            continue
        bp = (r["band_header_path"] or "").strip()
        rk = r["row_key"]; val = r["value"]
        if bp != "단면" or not is_num(rk) or not is_num(val):
            continue
        out.append({
            "comp_cd": "COMP_CUT_FULL_DIECUT", "siz_cd": "SIZ_PENDING_GUK4", "clr_cd": "",
            "mat_cd": "", "coat_side_cnt": "", "bdl_qty": "", "min_qty": int(rk),
            "unit_price": val,
            "note": "완칼(국4절) 인쇄비+소재+커팅 합가 출력매수≥%s (단면 band=합가단가, 규칙④, 수량변동→차원)" % rk,
        })
    # B03 타공 합가(F~I열): 옵션×수량 합가
    perf_suffix = {"1구(6mm)": "1H6", "2구(6mm)": "2H6", "3구(6mm)": "3H6"}
    for r in rows:
        if r["block_id"] != "B03" or r["col"] not in ("G", "H", "I"):
            continue
        bp = (r["band_header_path"] or "").strip()
        rk = r["row_key"]; val = r["value"]
        if not is_num(rk) or not is_num(val):
            continue
        suf = perf_suffix.get(bp)
        if suf is None:
            continue
        out.append({
            "comp_cd": "COMP_CUT_FULL_PERF_%s" % suf, "siz_cd": "", "clr_cd": "",
            "mat_cd": "", "coat_side_cnt": "", "bdl_qty": "", "min_qty": int(rk),
            "unit_price": val,
            "note": "타공(합가) %s 출력매수≥%s (규칙④ 합가, 수량변동→차원, 헤더택/벽걸이캘린더)" % (bp, rk),
        })
    return out


def build_namecard_extra(rows):
    """명함 B09 오리지널박(합가+동판셋업) + B12 포토대량 → component_prices 행.
    B09: 면×박종묶음×수량 합가 '종이+동판+박가공비' + 기본가(아연판)=동판셋업비(별 row_key).
    B12: 총제작수량×가격 단순. 모두 수량차원 존재 → component_prices(product 단일행 불가)."""
    side_suffix = {"단면": "S1", "양면": "S2"}
    out = []
    # B09 오리지널박: band='단면 > 금유광,... > 5000.0'(박종묶음+동판비) | '단면 > 홀로그램/트윙클'
    for r in rows:
        if r["block_id"] != "B09" or r["col"] == "A":
            continue
        bp = (r["band_header_path"] or "").strip()
        rk = r["row_key"]; val = r["value"]
        if not bp or not is_num(val):
            continue
        parts = [p.strip() for p in bp.split(">")]
        side = parts[0]
        suf = side_suffix.get(side)
        if suf is None:
            continue
        foil_grp = parts[1] if len(parts) > 1 else ""
        is_holo = "홀로그램" in foil_grp
        foil_suf = "HOLO" if is_holo else "STD"
        if rk == "기본가(아연판)":   # 동판셋업비(수량 무관 고정 셋업) → min_qty 공란
            out.append({
                "comp_cd": "COMP_NAMECARD_FOIL_SETUP_%s_%s" % (suf, foil_suf),
                "siz_cd": "", "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                "bdl_qty": "", "min_qty": "", "unit_price": val,
                "note": "오리지널박명함 기본가(아연판=동판셋업비) %s/%s (수량무관 셋업, 규칙④ 합가구성)"
                        % (side, foil_grp),
            })
        elif is_num(rk):
            out.append({
                "comp_cd": "COMP_NAMECARD_FOIL_%s_%s" % (suf, foil_suf),
                "siz_cd": "", "clr_cd": "", "mat_cd": "", "coat_side_cnt": "",
                "bdl_qty": "", "min_qty": int(rk), "unit_price": val,
                "note": "오리지널박명함 종이+동판+박가공비 합가 %s/%s 제작수량≥%s (규칙④ 합가)"
                        % (side, foil_grp, rk),
            })
    # B12 포토대량: 총제작수량×가격
    for r in rows:
        if r["block_id"] != "B12" or r["col"] != "B":
            continue
        bp = (r["band_header_path"] or "").strip()
        rk = r["row_key"]; val = r["value"]
        if bp != "가격" or not is_num(rk) or not is_num(val):
            continue
        out.append({
            "comp_cd": "COMP_PHOTOCARD_BULK", "siz_cd": "", "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": int(rk), "unit_price": val,
            "note": "포토카드(대량제작) 총제작수량≥%s 단순가" % rk,
        })
    # [wave-2 B-2] 포토카드 세트 2종: B10 포토카드(PRD_000024, 6000), B11 투명포토카드(PRD_000025, 8500).
    # band 공란, '20장 1세트' 고정가. 세트제작수량 1행=세트단가(주문수량20 echo는 중복→제외).
    # 1세트=20장 → bdl_qty=20. 사이즈 55x86=SIZ_000012(카드규격, 라이브 실코드).
    photo_set = {
        "B10": ("COMP_PHOTOCARD_SET", "포토카드", "B"),         # col B 가격, 6000
        "B11": ("COMP_PHOTOCARD_CLEAR_SET", "투명포토카드", "E"),  # col E 가격, 8500
    }
    for bid, (comp_cd, label, price_col) in photo_set.items():
        for r in rows:
            if r["block_id"] != bid or r["col"] != price_col:
                continue
            rk = r["row_key"]; val = r["value"]
            # 세트제작수량 1행만(주문수량 20 echo 제외 — 동일가 중복). rk='1' 행의 가격 셀.
            if rk != "1" or not is_num(val):
                continue
            out.append({
                "comp_cd": comp_cd, "siz_cd": "SIZ_000012", "clr_cd": "", "mat_cd": "",
                "coat_side_cnt": "", "bdl_qty": 20, "min_qty": 1, "unit_price": val,
                "note": "%s(20장1세트) 세트단가 (1세트=20장→bdl_qty=20, 55x86=SIZ_000012, 세트단위)"
                        % label,
            })
    return out


def build_sticker_setup(rows):
    """스티커 B05 타투(기본가+3장당4000), B06 기본가, B07 스티커팩(54장1세트) — 세트/기본가 component.
    타투 행55: 판매가=[기본가]+[3장당 4000]. 스티커팩 행58: [1세트당 4000]. bdl_qty/세트 단위 note."""
    out = []
    # B07 스티커팩: 75x110 × 수량(세트)
    for min_qty, bp, val, col in _band_body(rows, "B07"):
        out.append({
            "comp_cd": "COMP_STK_PACK", "siz_cd": "SIZ_000068", "clr_cd": "", "mat_cd": "",
            "coat_side_cnt": "", "bdl_qty": "", "min_qty": min_qty, "unit_price": val,
            "note": "스티커팩(54장1세트)/75x110 수량≥%d (세트단위, 1세트=54장)" % min_qty,
        })
    return out


def build_formula_rows():
    """7시트 공식 헤더 + 구성요소배선 + 상품바인딩 (계산공식집초안 기반).
    합산형(.01): 접지/제본(합가 구성요소가 공식 구성요소) — 단 시트단위 단가는 component_prices.
    단순형(.02): 스티커/합판/명함/엽서북([고정가형] 판매가=[수량행][열]) — 단일 단가 룩업.
    반환: (formulas, formula_components, product_price_formulas) dict 리스트."""
    formulas = [
        ("PRF_STK_FIXED", "스티커 규격/소재/수량별 단가", "FRM_TYPE.02",
         "단순형: [수량행][출력매수×소재열] (계산공식집초안 행52). 규격(판수)·소재는 component_prices 차원"),
        ("PRF_GANGPAN_FIXED", "합판도무송 사이즈/소재/수량별 단가", "FRM_TYPE.02",
         "단순형: [수량행][사이즈×소재열] (행61). 사이즈mm·소재는 component_prices 차원"),
        ("PRF_NAMECARD_FIXED", "명함 면/소재/수량별 단가(용지포함)", "FRM_TYPE.02",
         "단순형: [수량행][소재×면열] (행33). 용지포함 단품가. 면=comp흡수, 소재=mat 차원"),
        ("PRF_PCB_FIXED", "엽서북 사이즈/면/페이지/수량별 단가", "FRM_TYPE.02",
         "단순형: [수량행][옵션열] (행92). 사이즈=siz, 면·페이지=comp흡수 차원"),
        ("PRF_TTEOKME_FIXED", "떡메모지 사이즈/권당장수/장수별 단가", "FRM_TYPE.02",
         "단순형: [수량행][옵션열] (행92, 엽서북/떡메). 사이즈=siz, 권당장수=bdl_qty, 장수=min_qty"),
        ("PRF_PHOTOCARD_FIXED", "포토카드 세트 고정가", "FRM_TYPE.02",
         "단순형: [세트당 고정단가] (행43). 20장1세트=bdl_qty 차원. 일반/투명 분리"),
        ("PRF_FOLD_SUM", "접지 합산형(오시+접지 후가공 구성요소)", "FRM_TYPE.01",
         "합산형: 접지비=[제작수량행] 구성요소 (행30). 카드/리플렛 상위 원자합산형 공식의 후가공 구성요소"),
        ("PRF_BIND_SUM", "제본 합산형(제본비 구성요소)", "FRM_TYPE.01",
         "합산형: 제본비=[수량행][제본종류열] 구성요소 (행69). 책자 원자합산형 공식의 제본 구성요소"),
        ("PRF_POSTER_FIXED", "포스터사인 소재/사이즈/수량별 완제품가(포함항목 통가격)", "FRM_TYPE.02",
         "단순형: [면적/사이즈×수량][소재별] 완제품가(출력+코팅+가공 포함). 메인=완제품비.06 통가격 + 추가옵션 별도 add-on. 면적시트 31블록"),
    ]
    # formula_components: 단순형 공식↔대표 comp 배선(차원은 component_prices가 보유)
    fcs = [
        ("PRF_STK_FIXED", "COMP_STK_PRINT", 1, "Y"),
        ("PRF_GANGPAN_FIXED", "COMP_GANGPAN_PRINT", 1, "Y"),
        ("PRF_NAMECARD_FIXED", "COMP_NAMECARD_STD_S1", 1, "Y"),
        ("PRF_NAMECARD_FIXED", "COMP_NAMECARD_STD_S2", 2, "Y"),
        ("PRF_PCB_FIXED", "COMP_PCB_S1_20P", 1, "Y"),
        ("PRF_PCB_FIXED", "COMP_PCB_S2_20P", 2, "Y"),
        ("PRF_TTEOKME_FIXED", "COMP_TTEOKME", 1, "Y"),
        ("PRF_PHOTOCARD_FIXED", "COMP_PHOTOCARD_SET", 1, "Y"),
        ("PRF_PHOTOCARD_FIXED", "COMP_PHOTOCARD_CLEAR_SET", 2, "Y"),
        # 접지/제본 합산형: 대표 comp 1개씩 배선(상위 원자합산형이 참조하는 후가공/제본 구성요소)
        # 카드접지엔 반접지(HALF) 없음(리플렛 옵션) → 카드 실재 옵션 COMP_FOLD_CARD_2H 사용
        ("PRF_FOLD_SUM", "COMP_FOLD_CARD_2H", 1, "Y"),
        ("PRF_BIND_SUM", "COMP_BIND_JUNGCHEOL", 1, "Y"),
        # 포스터 단순형: 대표 메인 comp 1개 배선(소재별 comp는 component_prices가 보유). 추가옵션은 add-on.
        ("PRF_POSTER_FIXED", "COMP_POSTER_ARTPRINT_PHOTO", 1, "Y"),
    ]
    # 상품바인딩: 계산공식집초안 + ref-products 실 prd_cd (대표 상품만, 무발명)
    ppfs = [
        ("PRD_000052", "PRF_STK_FIXED", "반칼 자유형 스티커→규격/소재/수량 단가"),
        ("PRD_000053", "PRF_STK_FIXED", "반칼 자유형 투명스티커→규격/소재/수량 단가"),
        ("PRD_000055", "PRF_STK_FIXED", "낱장 자유형 스티커(완칼)→규격/수량 단가"),
        ("PRD_000066", "PRF_GANGPAN_FIXED", "합판도무송스티커→사이즈/소재/수량 단가"),
        ("PRD_000033", "PRF_NAMECARD_FIXED", "스탠다드명함→면/소재/수량(용지포함)"),
        ("PRD_000031", "PRF_NAMECARD_FIXED", "프리미엄명함→면/소재/수량"),
        ("PRD_000032", "PRF_NAMECARD_FIXED", "코팅명함→면/소재/수량"),
        ("PRD_000094", "PRF_PCB_FIXED", "엽서북→사이즈/면/페이지/수량"),
        ("PRD_000097", "PRF_TTEOKME_FIXED", "떡메모지→사이즈/권당장수/장수 (wave-2 B-1)"),
        ("PRD_000024", "PRF_PHOTOCARD_FIXED", "포토카드(20장1세트)→세트고정가 (wave-2 B-2)"),
        ("PRD_000025", "PRF_PHOTOCARD_FIXED", "투명포토카드(20장1세트)→세트고정가 (wave-2 B-2)"),
        ("PRD_000048", "PRF_FOLD_SUM", "접지리플렛→접지(오시+접지) 후가공 구성요소"),
        ("PRD_000068", "PRF_BIND_SUM", "중철책자→제본 구성요소"),
        ("PRD_000069", "PRF_BIND_SUM", "무선책자→제본 구성요소"),
        ("PRD_000071", "PRF_BIND_SUM", "트윈링책자→제본 구성요소"),
        ("PRD_000070", "PRF_BIND_SUM", "PUR책자→제본 구성요소"),
    ]
    # 포스터사인 21상품 바인딩(블록↔라이브 실 prd_cd, read-only 확증, 무발명)
    for bid in sorted(POSTER_BLOCK_PRD):
        prd = POSTER_BLOCK_PRD[bid]
        slug, name, _incl = POSTER_BLOCK[bid]
        ppfs.append((prd, "PRF_POSTER_FIXED", "%s→소재/사이즈/수량 완제품가(포함항목 통가격)" % name))
    # 중첩 서브제품 4상품 바인딩(추출결함 보정 — 폼보드/포맥스보드/유광·미러 아크릴스티커, 라이브 실재)
    sub_prds = [("PRD_000129", "폼보드(B11 중첩)"), ("PRD_000130", "포맥스보드(B11 중첩)"),
                ("PRD_000142", "유광아크릴스티커(B27 중첩)"), ("PRD_000143", "미러아크릴스티커(B27 중첩)"),
                ("PRD_000140", "무광시트커팅(B27 중첩)"), ("PRD_000141", "홀로그램시트커팅(B27 중첩)")]
    for prd, desc in sub_prds:
        ppfs.append((prd, "PRF_POSTER_FIXED", "%s→사이즈/소재 완제품가(포함항목 통가격)" % desc))
    return formulas, fcs, ppfs


# comp_cd → comp_nm/comp_typ_cd 매핑(price_components 신규 산출용)
def derive_components(records):
    """component_prices 행들에서 등장한 comp_cd를 price_components 카탈로그로 역산(신규만)."""
    typ_by_prefix = [
        ("COMP_FOLD_", "PRC_COMPONENT_TYPE.04", "접지비(후가공)"),
        ("COMP_BIND_", "PRC_COMPONENT_TYPE.04", "제본비(후가공)"),
        ("COMP_CUT_PERF_", "PRC_COMPONENT_TYPE.04", "타공비(후가공)"),
        ("COMP_CUT_FULL_", "PRC_COMPONENT_TYPE.06", "커팅 합가(완제품가)"),
        ("COMP_STK_", "PRC_COMPONENT_TYPE.06", "스티커 단가(완제품가)"),
        ("COMP_GANGPAN_", "PRC_COMPONENT_TYPE.06", "합판도무송 단가(완제품가)"),
        ("COMP_NAMECARD_FOIL_SETUP_", "PRC_COMPONENT_TYPE.05", "박형압 동판셋업비"),
        ("COMP_NAMECARD_FOIL_", "PRC_COMPONENT_TYPE.06", "오리지널박 합가(완제품가)"),
        ("COMP_NAMECARD_", "PRC_COMPONENT_TYPE.06", "명함 단가(용지포함 완제품가)"),
        ("COMP_PHOTOCARD_", "PRC_COMPONENT_TYPE.06", "포토카드 단가(완제품가)"),
        ("COMP_TTEOKME", "PRC_COMPONENT_TYPE.06", "떡메모지 단가(완제품가)"),
        ("COMP_PCB_", "PRC_COMPONENT_TYPE.06", "엽서북 단가(완제품가)"),
        # 포스터사인: 메인=완제품비(.06, 출력+코팅+가공 포함가 통가격). 추가옵션도 통가격 add-on=.06.
        ("COMP_POSTEROPT_", "PRC_COMPONENT_TYPE.06", "포스터 추가옵션 추가가격(별도 add-on 통가격)"),
        ("COMP_POSTER_", "PRC_COMPONENT_TYPE.06", "포스터 완제품가(포함항목 통가격)"),
    ]
    seen = {}
    for rec in records:
        cc = rec["comp_cd"]
        if cc in seen:
            continue
        typ, base = "", cc
        for pre, t, nm in typ_by_prefix:
            if cc.startswith(pre):
                typ, base = t, nm
                break
        seen[cc] = (cc, "%s [%s]" % (base, cc), typ)
    return list(seen.values())


def append_csv(fname, header, rows_dicts, key_cols):
    """기존 CSV에 행 멱등 append(key_cols 기준 dedup, 재실행 안전).
    [멱등] 재실행 시 동일 key 행은 추가 안 함 — component_prices(전량 재생성)와 정합."""
    path = os.path.join(LOAD_DIR, fname)
    existing = []
    seen = set()
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            for r in csv.DictReader(f):
                existing.append(r)
                seen.add(tuple(r.get(c, "") for c in key_cols))
    new_rows = []
    for rd in rows_dicts:
        k = tuple(str(rd.get(c, "")) for c in key_cols)
        if k in seen:
            continue
        seen.add(k)
        new_rows.append(rd)
    with open(path, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=header)
        w.writeheader()
        for r in existing + new_rows:
            w.writerow({k: r.get(k, "") for k in header})
    return path


TRANSFORMS = {
    "coating": ("coating", transform_coating),
    "digital-print-price": ("digital-print-price", transform_digital_print),
    "acrylic-price": ("acrylic-price", transform_acrylic),
    "post-process": ("post-process", transform_post_process),
    "envelope": ("envelope", transform_envelope),
    "folding": ("folding", transform_folding),
    "binding": ("binding", transform_binding),
    "cutting": ("cutting", transform_cutting),
    "sticker-price": ("sticker-price", transform_sticker),
    "gangpan-sticker": ("gangpan-sticker", transform_gangpan),
    "namecard-photocard": ("namecard-photocard", transform_namecard),
    "postcard-book": ("postcard-book", transform_postcard_book),
    "poster-sign": ("poster-sign", transform_poster),
}

# 합가/특수 빌더(component_prices에 추가 — 수량차원 보유 합가)
EXTRA_BUILDERS = {
    "cutting": build_cutting_products,
    "namecard-photocard": build_namecard_extra,
    "sticker-price": build_sticker_setup,
}


def main():
    all_records = []
    per_sheet = {}
    for name, (slug, fn) in TRANSFORMS.items():
        rows = read_l1(slug)
        recs = fn(rows)
        if name in EXTRA_BUILDERS:
            extra = EXTRA_BUILDERS[name](rows)
            recs = recs + extra
            per_sheet[name + "(+extra)"] = (len(recs) - len(extra), len(extra))
        per_sheet.setdefault(name, len(recs))
        all_records.extend(recs)
        print("[%s] %d component_prices 행 산출" % (name, len(recs)))
    deduped, dups = dedup_natural_key(all_records)
    print("\n총 %d 행 → 자연키8 중복제거 후 %d 행 (제거 %d)"
          % (len(all_records), len(deduped), len(all_records) - len(deduped)))
    if dups:
        print("[경고] 자연키 동일 + 단가 상이(C-2, 사전제거됨):")
        for k, v1, v2 in dups[:10]:
            print("  ", k, v1, "vs", v2)
    path = write_component_prices(deduped)
    print("\n산출 component_prices: %s (%d행)" % (os.path.abspath(path), len(deduped)))

    # price_components 신규 카탈로그 append
    comps = derive_components(deduped)
    comp_rows = [{"comp_cd": c, "comp_nm": nm, "comp_typ_cd": t,
                  "note": "round-2 7시트 확대 자동생성", "use_yn": "Y"}
                 for (c, nm, t) in comps]
    append_csv("t_prc_price_components.csv",
               ["comp_cd", "comp_nm", "comp_typ_cd", "note", "use_yn"], comp_rows,
               key_cols=("comp_cd",))
    print("price_components 신규 %d종 append" % len(comp_rows))

    # formulas + formula_components + product binding
    formulas, fcs, ppfs = build_formula_rows()
    append_csv("t_prc_price_formulas.csv",
               ["frm_cd", "frm_nm", "frm_typ_cd", "note", "use_yn"],
               [{"frm_cd": f[0], "frm_nm": f[1], "frm_typ_cd": f[2], "note": f[3], "use_yn": "Y"}
                for f in formulas], key_cols=("frm_cd",))
    append_csv("t_prc_formula_components.csv",
               ["frm_cd", "comp_cd", "disp_seq", "addtn_yn"],
               [{"frm_cd": x[0], "comp_cd": x[1], "disp_seq": x[2], "addtn_yn": x[3]} for x in fcs],
               key_cols=("frm_cd", "comp_cd"))
    append_csv("t_prd_product_price_formulas.csv",
               ["prd_cd", "frm_cd", "apply_bgn_ymd", "note"],
               [{"prd_cd": p[0], "frm_cd": p[1], "apply_bgn_ymd": APPLY_YMD, "note": p[2]} for p in ppfs],
               key_cols=("prd_cd", "frm_cd"))
    print("formulas %d / formula_components %d / product binding %d append"
          % (len(formulas), len(fcs), len(ppfs)))
    print("\n시트별:", json.dumps(per_sheet, ensure_ascii=False))


if __name__ == "__main__":
    main()
