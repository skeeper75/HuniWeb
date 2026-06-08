#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
price-211 slice C1 (STICKER F4 + NAMECARD F5) 적재물 생성기.
설계 권위 = mapping.md. 신규 component_prices 0행(기존 재사용·재적재 금지).
적재물 = price_formulas 1 mint + formula_components 배선 + product_price_formulas 바인딩.
출력: ../load/*.csv (INSERTABLE) + ../load/*_BLOCKED.csv + ../load.sql.
"""
import csv, os

HERE = os.path.dirname(os.path.abspath(__file__))
LOAD = os.path.abspath(os.path.join(HERE, "..", "load"))
os.makedirs(LOAD, exist_ok=True)
APPLY_YMD = "2026-06-01"   # C-1 표준(round-1·2 통일)

def w(path, header, rows):
    with open(path, "w", newline="", encoding="utf-8") as f:
        wr = csv.writer(f)
        wr.writerow(header)
        wr.writerows(rows)
    return len(rows)

# ---------------------------------------------------------------------------
# (1) t_prc_price_formulas — 신규 mint 1행 (스티커팩 세트가 전용 공식)
#     기존 PRF_STK_FIXED / PRF_NAMECARD_FIXED 는 재사용(적재 안 함).
# ---------------------------------------------------------------------------
formulas = [
    # frm_cd, frm_nm, frm_typ_cd, note, use_yn   (reg_dt/upd_dt OMIT → DEFAULT now())
    ("PRF_STK_PACK_FIXED", "스티커팩 세트 고정가", "FRM_TYPE.02",
     "단순형: 스티커팩(54장 1세트) 세트 단가. COMP_STK_PACK 재사용(75x110·4000). price-sticker-l1 B07.", "Y"),
]
n_f = w(os.path.join(LOAD, "t_prc_price_formulas.csv"),
        ["frm_cd","frm_nm","frm_typ_cd","note","use_yn"], formulas)

# ---------------------------------------------------------------------------
# (2) t_prc_formula_components — 배선 (기존 wired 제외)
#   NAMECARD: PRF_NAMECARD_FIXED 에 7무가격 상품 components wire (STD 기존, disp_seq 3~).
#     단일 완제품 단가 components = addtn_yn 'Y'(round-5 STD 컨벤션 따름; FRM_TYPE.02 lookup).
#     박명함 FOIL(.06 base)+FOIL_SETUP(.05 동판) = 합산 의미 'Y'.
#   STICKER: 반칼변형은 COMP_STK_PRINT 이미 wired→배선 불요. 스티커팩만 신규 공식에 wire.
#   disp_seq: NAMECARD 기존 max=2 → 3부터. 신규공식 STK_PACK = 1.
# ---------------------------------------------------------------------------
nc_comps = [
    # (comp_cd) — 7무가격 명함 components (단/양면 S1/S2). 라이브 선존재 확인됨.
    "COMP_NAMECARD_PEARL_S1","COMP_NAMECARD_PEARL_S2",          # 펄명함 PRD_000034
    "COMP_NAMECARD_SHAPE_S1","COMP_NAMECARD_SHAPE_S2",          # 모양명함 PRD_000035
    "COMP_NAMECARD_MINISHAPE_S1","COMP_NAMECARD_MINISHAPE_S2",  # 미니모양 PRD_000036
    "COMP_NAMECARD_CLEAR_S1",                                   # 투명명함 PRD_000039 (단면만)
    "COMP_NAMECARD_WHITE_S1W_NOCL","COMP_NAMECARD_WHITE_S1W_CL",
    "COMP_NAMECARD_WHITE_S2W_NOCL","COMP_NAMECARD_WHITE_S2W_CL",# 화이트인쇄 PRD_000040
    "COMP_NAMECARD_FOIL_S1_STD","COMP_NAMECARD_FOIL_S1_HOLO",
    "COMP_NAMECARD_FOIL_S2_STD","COMP_NAMECARD_FOIL_S2_HOLO",   # 오리지널박 base(.06)
    "COMP_NAMECARD_FOIL_SETUP_S1_STD","COMP_NAMECARD_FOIL_SETUP_S2_STD",  # 박 동판셋업(.05) 합산
]
fc_rows = []
seq = 3  # 기존 STD가 1,2 → 이어서
for c in nc_comps:
    fc_rows.append(("PRF_NAMECARD_FIXED", c, seq, "Y"))
    seq += 1
# 스티커팩 신규 공식 wire
fc_rows.append(("PRF_STK_PACK_FIXED", "COMP_STK_PACK", 1, "Y"))
n_fc = w(os.path.join(LOAD, "t_prc_formula_components.csv"),
         ["frm_cd","comp_cd","disp_seq","addtn_yn"], fc_rows)

# ---------------------------------------------------------------------------
# (3) t_prd_product_price_formulas — 바인딩 (INSERTABLE)
# ---------------------------------------------------------------------------
bindings = [
    # STICKER → PRF_STK_FIXED (반칼변형·대형·낱장투명: COMP_STK_PRINT 매트릭스 재사용)
    ("PRD_000058","PRF_STK_FIXED","반칼원형스티커 — 반칼규격 매트릭스(B01) 공유"),
    ("PRD_000059","PRF_STK_FIXED","반칼정사각스티커 — B01"),
    ("PRD_000060","PRF_STK_FIXED","반칼직사각스티커 — B01"),
    ("PRD_000061","PRF_STK_FIXED","반칼띠지스티커 — B01"),
    ("PRD_000062","PRF_STK_FIXED","반칼팬시스티커 — B01"),
    ("PRD_000063","PRF_STK_FIXED","반칼팬시투명스티커 — B01 투명/홀로그램 그룹가"),
    ("PRD_000054","PRF_STK_FIXED","반칼 자유형 홀로그램스티커 — B01 투명/홀로그램 그룹가"),
    ("PRD_000057","PRF_STK_FIXED","대형 자유형 스티커 — B04 대형완칼(400x600) 재사용"),
    ("PRD_000056","PRF_STK_FIXED","낱장 자유형 투명스티커 — B03 낱장완칼 투명 재사용"),
    # STICKER → PRF_STK_PACK_FIXED
    ("PRD_000065","PRF_STK_PACK_FIXED","스티커팩 — B07 세트가(COMP_STK_PACK)"),
    # NAMECARD → PRF_NAMECARD_FIXED
    ("PRD_000034","PRF_NAMECARD_FIXED","펄명함 — PEARL S1/S2(B04)"),
    ("PRD_000035","PRF_NAMECARD_FIXED","모양명함 — SHAPE S1/S2(B07·90x50)"),
    ("PRD_000036","PRF_NAMECARD_FIXED","미니모양명함 — MINISHAPE S1/S2(B08·50x50)"),
    ("PRD_000039","PRF_NAMECARD_FIXED","투명명함 — CLEAR S1(B05·단면)"),
    ("PRD_000040","PRF_NAMECARD_FIXED","화이트인쇄명함 — WHITE 4종(B06·큐리어스스킨)"),
    ("PRD_000037","PRF_NAMECARD_FIXED","오리지널박명함 — FOIL base(.06)+SETUP(.05) 합산(B09)"),
]
# apply_bgn_ymd 는 nullable 메모 — 표준 일자 채움(일관)
n_b = w(os.path.join(LOAD, "t_prd_product_price_formulas.csv"),
        ["prd_cd","frm_cd","apply_bgn_ymd","note"],
        [(p,f,APPLY_YMD,note) for (p,f,note) in bindings])

# ---------------------------------------------------------------------------
# (4) BLOCKED — 발명 금지 분리
# ---------------------------------------------------------------------------
blocked = [
    ("PRD_000038","형압명함","NAMECARD","DATA-GAP","가격표 L1 형압명함 블록 부재·라이브 component_prices 부재. 가격원천 없음. 후니 input 필요."),
    ("PRD_000064","소량자유형스티커","STICKER","STRUCTURE","B06 기본가=base 2000+3매당 4000(비매트릭스 base+증분). component_prices 부재. base 모델 결정 대기(D-1)."),
    ("PRD_000067","타투스티커","STICKER","STRUCTURE","B05 타투(3장단위)=세트단가 3장마다 4000. component_prices 부재·bdl_qty 차원 필요. 번들모델 결정 대기(D-2)."),
]
n_bl = w(os.path.join(LOAD, "product_price_formulas_BLOCKED.csv"),
         ["prd_cd","prd_nm","family","block_class","reason"], blocked)

# component_prices 신규 0행 — 빈 헤더 CSV로 명시(재적재 금지 증거)
n_cp = w(os.path.join(LOAD, "t_prc_component_prices.csv"),
         ["comp_cd","apply_ymd","siz_cd","clr_cd","mat_cd","coat_side_cnt","bdl_qty","min_qty","unit_price","note"], [])

print(f"formulas={n_f} formula_components={n_fc} bindings={n_b} component_prices_new={n_cp} blocked={n_bl}")
print(f"INSERTABLE total rows = {n_f + n_fc + n_b}")
