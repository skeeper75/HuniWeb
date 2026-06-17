#!/usr/bin/env python3
# gen_load_sql.py — 아크릴 마무리 실행본 결정적 생성기 (round-23·A5 긴급보정 + 코롯토 B2~B4)
# 권위(HARD·날조 금지):
#   - A5 source: 라이브 실측 — COMP_ACRYL_CLEAR3T(.02) GAP 적재분 81행 min_qty NULL (엔진 ÷min_qty ValueError·견적 불가).
#   - 코롯토 source: 20_price-import/acrylic/acrylic-import.xlsx 시트 5_korotto_NEW B06 21조합 verbatim.
# ★돈-크리티컬:
#   - A5: .02(합가형) + siz_width NOT NULL + min_qty NULL → min_qty=1 (÷1=×1 골든 불변). .01 단가형 제외.
#   - 코롯토: prc_typ .01 단가형(min_qty 무관·CLEAR3T .02 함정 회피)·use_dims [siz_width,siz_height]·siz_nm WxH(W앞)·채번 0.
import json

APPLY_YMD = '2026-06-01'
kor = json.load(open('korotto21.json'))
assert len(kor) == 21, len(kor)
assert all(o['unit_price'] is not None for o in kor)


def slit(v):
    return 'NULL' if v is None else f"'{v}'"


# ============================================================
# A5 — 긴급 보정: .02 comp 단가행 중 siz_width NOT NULL + min_qty NULL → min_qty=1 (전수)
#   엔진 component_subtotal(.02): per_item = unit_price ÷ tier_min_qty. min_qty NULL/0이면 ValueError(견적 불가).
#   min_qty=1 보정: ÷1=무연산 → 골든 불변(×수량 동일). .01 단가형은 ÷min_qty 안 하므로 제외.
#   라이브 실측: CLEAR3T(.02) 81행 결함. 전수 보정(comp 하드코딩 아닌 prc_typ_cd 조인 조건).
# ============================================================
a5 = []
a5.append("-- A5_fix_min_qty.sql — .02 합가형 단가행 min_qty NULL → 1 보정 (엔진 ÷min_qty ValueError·견적 불가 해소)")
a5.append("-- 근거(라이브 실측): COMP_ACRYL_CLEAR3T(PRICE_TYPE.02) GAP 적재분 81행 siz_width NOT NULL·min_qty NULL.")
a5.append("--   엔진 pricing.py:177-192 component_subtotal: .02 = unit_price ÷ tier_min_qty × qty. min_qty≤0(NULL)이면 ValueError raise→합산 제외(견적 실패).")
a5.append("-- ★골든 불변: min_qty=1 → unit_price ÷ 1 × qty = unit_price × qty (.01 단가형과 수학적 동일). 30x30 3T 100개 = 3,100÷1×100=310,000.")
a5.append("-- 전수: prc_typ_cd='PRICE_TYPE.02' & siz_width NOT NULL & min_qty NULL 인 단가행 전건(comp 하드코딩 아님). .01 단가형은 ÷min_qty 안 하므로 제외.")
a5.append("-- 멱등: min_qty IS NULL 인 행만 → 2-pass 0행.")
a5.append("UPDATE t_prc_component_prices cp")
a5.append("   SET min_qty = 1, upd_dt = now()")
a5.append("  FROM t_prc_price_components pc")
a5.append(" WHERE pc.comp_cd = cp.comp_cd")
a5.append("   AND pc.prc_typ_cd = 'PRICE_TYPE.02'")
a5.append("   AND cp.siz_width IS NOT NULL")
a5.append("   AND cp.min_qty IS NULL;")
open("A5_fix_min_qty.sql", "w").write("\n".join(a5) + "\n")
print("A5 — .02 min_qty NULL fix (전수)")

# ============================================================
# B2 — 코롯토 comp 신설 (search-before-mint: 라이브 부재 확인)
#   COMP_ACRYL_COROTTO · comp_typ .01 인쇄비 · prc_typ .01 단가형 · use_dims [siz_width,siz_height]
# ============================================================
b2 = []
b2.append("-- B2_korotto_comp.sql — 코롯토 구성요소 신설 (search-before-mint: 라이브 COMP_ACRYL_COROTTO 부재 확인)")
b2.append("-- prc_typ .01 단가형(개당 면적단가·min_qty 무관·CLEAR3T .02 min_qty 함정 회피)·use_dims [siz_width,siz_height] WH 동형.")
b2.append("-- 멱등: comp_cd PK NOT EXISTS 가드.")
b2.append("INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims, use_yn, del_yn, reg_dt)")
b2.append("SELECT 'COMP_ACRYL_COROTTO', '아크릴코롯토 인쇄가공비', 'PRC_COMPONENT_TYPE.01', 'PRICE_TYPE.01',")
b2.append("       '[\"siz_width\", \"siz_height\"]'::jsonb, 'Y', 'N', now()")
b2.append("WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components WHERE comp_cd='COMP_ACRYL_COROTTO');")
open("B2_korotto_comp.sql", "w").write("\n".join(b2) + "\n")
print("B2 — korotto comp INSERT 1")

# ============================================================
# B3 — 코롯토 단가행 21 verbatim INSERT (siz_width/height·min_qty=1·채번 0)
# ============================================================
b3 = []
b3.append("-- B3_korotto_unitprices.sql — 코롯토 단가행 21 verbatim INSERT (siz_width/siz_height·채번 0)")
b3.append("-- 출처(HARD·날조 금지): acrylic-import.xlsx 시트 5_korotto_NEW B06 21조합 (siz_cd 17 siz_nm 파싱 + GAP 4 GxS). W앞·H뒤.")
b3.append("-- prc_typ .01 단가형이나 min_qty=1 명시(일관성·.01은 ÷안 하나 NULL 회피). 좌표 siz 채번 0(siz_cd 미사용·WH 직접).")
b3.append("-- 멱등: 자연키(comp,apply_ymd,siz_width,siz_height, 그외 차원 NULL) NOT EXISTS 가드 → 2-pass delta 0.")
b3.append("INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_width, siz_height, min_qty, unit_price)")
b3.append("SELECT v.comp_cd, v.apply_ymd, v.siz_width, v.siz_height, 1, v.unit_price")
b3.append("FROM (VALUES")
kvals = []
for o in kor:
    kvals.append(f"  ('{o['comp_cd']}','{APPLY_YMD}',{o['siz_width']},{o['siz_height']},{o['unit_price']})")
b3.append(",\n".join(kvals))
b3.append(") AS v(comp_cd, apply_ymd, siz_width, siz_height, unit_price)")
b3.append("WHERE NOT EXISTS (")
b3.append("  SELECT 1 FROM t_prc_component_prices cp")
b3.append("   WHERE cp.comp_cd = v.comp_cd AND cp.apply_ymd = v.apply_ymd")
b3.append("     AND cp.siz_width = v.siz_width AND cp.siz_height = v.siz_height")
b3.append("     AND cp.siz_cd IS NULL AND cp.plt_siz_cd IS NULL AND cp.clr_cd IS NULL AND cp.mat_cd IS NULL")
b3.append("     AND cp.proc_cd IS NULL AND cp.opt_cd IS NULL AND cp.print_opt_cd IS NULL")
b3.append("     AND cp.coat_side_cnt IS NULL AND cp.bdl_qty IS NULL")
b3.append("     AND COALESCE(cp.dim_vals,'{}'::jsonb) = '{}'::jsonb")
b3.append(");")
open("B3_korotto_unitprices.sql", "w").write("\n".join(b3) + "\n")
print("B3 — korotto unitprice INSERT", len(kvals))

# ============================================================
# B4 — 코롯토 공식 + 배선 (PRF_COROTTO_ACRYL · disp_seq=1 · addtn_yn=N)
# ============================================================
b4 = []
b4.append("-- B4_korotto_formula.sql — 코롯토 공식 신설 + 본체 배선 (PRF_COROTTO_ACRYL)")
b4.append("-- 공식 = 면적매트릭스 본체(단일 comp). 배선 disp_seq=1·addtn_yn=N(본체·합산 시작·G-D2 W2 패턴).")
b4.append("-- 멱등: frm_cd PK NOT EXISTS / (frm_cd,comp_cd) NOT EXISTS 가드.")
b4.append("INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, reg_dt)")
b4.append("SELECT 'PRF_COROTTO_ACRYL', '아크릴코롯토 공식', 'Y', now()")
b4.append("WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_COROTTO_ACRYL');")
b4.append("INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)")
b4.append("SELECT 'PRF_COROTTO_ACRYL', 'COMP_ACRYL_COROTTO', 1, 'N', now()")
b4.append("WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_COROTTO_ACRYL' AND comp_cd='COMP_ACRYL_COROTTO');")
open("B4_korotto_formula.sql", "w").write("\n".join(b4) + "\n")
print("B4 — korotto formula + wiring INSERT 2")

print("DONE — A5(.02 min_qty fix) + B2(comp) + B3(21 unitprice) + B4(formula+wiring). B5 바인딩/미러/카라비너=BLOCKED.")
