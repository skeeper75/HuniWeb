#!/usr/bin/env python3
# gen_load_sql.py — 아크릴 가로/세로 구간 동형 전환 실행본 결정적 생성기 (round-23·A1~A4+배선보정)
# 권위(HARD·날조 금지):
#   - A1 source: live121.json  = 라이브 t_prc_component_prices CLEAR3T(84)+MIRROR3T(37) siz_cd 단가행 (siz_nm WxH 파싱)
#   - A2 source: gap96.json    = 20_price-import/acrylic/acrylic-import.xlsx 시트 4b_component_prices_GAP verbatim
# ★돈-크리티컬: 아크릴 면적축 권위 = siz_nm WxH 문자열(가격표 매트릭스 헤더). work_width/height(작업사이즈·블리드 가산) 절대 미사용.
#   siz_nm "WxH" → siz_width=W(앞·가로우선)·siz_height=H(뒤). 두께(3T/1.5T)=mat_cd 유지(면적축과 직교).
# 좌표 siz 신규 채번 0(siz_nm in-place 파싱 + GAP verbatim 수치).
import json

APPLY_YMD = '2026-06-01'
MATRIX_COMPS = ['COMP_ACRYL_CLEAR3T', 'COMP_ACRYL_MIRROR3T']

live = json.load(open('live121.json'))
gap = json.load(open('gap96.json'))

assert len(live) == 121, len(live)
assert len(gap) == 96, len(gap)
# 모든 라이브 행 siz_nm clean WxH (정수)
for r in live:
    assert isinstance(r['w'], int) and isinstance(r['h'], int), r
    assert '0' <= r['siz_nm'][0] <= '9', r  # clean WxH guard
# GAP 가격 NULL 0
assert all(o['unit_price'] is not None for o in gap)


def slit(v):
    return 'NULL' if v is None else f"'{v}'"


# ============================================================
# A1 — 라이브 121 siz_cd 매트릭스 단가행 → siz_width/siz_height 전환 (in-place·값 불변)
#   source = siz_nm WxH 파싱 (★work_width/height 미사용 — 작업사이즈는 가격축 아님)
#   siz_cd→NULL, siz_width=W, siz_height=H. mat_cd 불변(두께 직교). unit_price 불변.
# ============================================================
a1 = []
a1.append("-- A1_convert_sizcd_to_wh.sql — 라이브 아크릴 매트릭스 단가행 121건 siz_cd → siz_width/siz_height 전환(in-place·값 불변)")
a1.append("-- ★돈-크리티컬: 면적축 source = siz_nm WxH 문자열(가격표 매트릭스 헤더). work_width/height(블리드 가산 작업사이즈) 절대 미사용.")
a1.append("--   siz_nm 'WxH' → siz_width=W(앞·가로우선)·siz_height=H. 라이브 121행 siz_nm 전건 clean ^[0-9]+x[0-9]+$ (dirty 0·실측).")
a1.append("--   포스터 V1b(work_width/height) 패턴 답습 금지 — 아크릴 work_*는 작업사이즈(예 siz_nm 140x80=work 144x84)이지 가격축 아님.")
a1.append("-- 두께(3T MAT_000043 / 1.5T MAT_000042)=mat_cd 유지(면적축과 직교). unit_price 불변. siz_cd→NULL.")
a1.append("-- 멱등: siz_cd IS NOT NULL & siz_width IS NULL & comp IN(CLEAR3T,MIRROR3T) 인 행만 → 2-pass 시 0행.")
a1.append("UPDATE t_prc_component_prices cp")
a1.append("   SET siz_width = v.siz_width, siz_height = v.siz_height, siz_cd = NULL, upd_dt = now()")
a1.append("  FROM (VALUES")
# provenance: comp_price_id 로 정확 타겟 (siz_cd/comp_cd로도 유일하나 id가 결정적). 행별 출처는 live121.json.
# ★inline comment 금지(VALUES 구분 콤마 무효화 방지) — provenance = live121.json + 헤더 주석.
vals = []
for r in live:
    vals.append(f"  ({r['comp_price_id']},{r['w']},{r['h']})")
a1.append(",\n".join(vals))
a1.append("  ) AS v(comp_price_id, siz_width, siz_height)")
a1.append(" WHERE cp.comp_price_id = v.comp_price_id")
a1.append("   AND cp.siz_cd IS NOT NULL AND cp.siz_width IS NULL")
a1.append("   AND cp.comp_cd IN (" + ",".join(f"'{c}'" for c in MATRIX_COMPS) + ");")
open("A1_convert_sizcd_to_wh.sql", "w").write("\n".join(a1) + "\n")
print("A1 rows:", len(vals))

# ============================================================
# A2 — GAP 96 좌표 verbatim INSERT (siz_width=G·siz_height=S·mat_cd 분기) — 채번 0
#   CLEAR3T(3T) 66 + CLEAR15T→CLEAR3T(mat=1.5T) 15 + MIRROR3T(mat NULL) 15
# ============================================================
a2 = []
a2.append("-- A2_gap_unitprices.sql — GAP 미적재 좌표 96 verbatim INSERT (siz_width/siz_height 구간·채번 0)")
a2.append("-- 출처(HARD·날조 금지): acrylic-import.xlsx 시트 4b_component_prices_GAP 96셀 '(미채번:GxS)' (G=가로=siz_width·S=세로=siz_height).")
a2.append("-- Q-ACR-AC1(라이브 통합 모델): CLEAR15T 별 comp 15행 → comp_cd=COMP_ACRYL_CLEAR3T·mat_cd=MAT_000042(1.5T) 매핑(라이브가 1.5T를 CLEAR3T mat 차원으로 흡수).")
a2.append("--   CLEAR3T(mat미지정) 66 → mat_cd=MAT_000043(3T). MIRROR3T 15 → mat_cd NULL(단가행 mat 무사용).")
a2.append("-- 엔진 TIER '이하 상한' 매칭(pricing.py): 주문 가로 ≤ 임계 중 최소. off-grid=다음 큰 구간 ceiling 내장. GAP↔live121 자연키 충돌 0(실측).")
a2.append("-- 멱등: 자연키(comp_cd,apply_ymd,siz_width,siz_height,mat_cd, 그외 차원 NULL) NOT EXISTS 가드 → 2-pass delta 0.")
a2.append("INSERT INTO t_prc_component_prices")
a2.append("  (comp_cd, apply_ymd, siz_width, siz_height, mat_cd, unit_price)")
a2.append("SELECT v.comp_cd, v.apply_ymd, v.siz_width, v.siz_height, v.mat_cd, v.unit_price")
a2.append("FROM (VALUES")
# ★inline comment 금지(VALUES 구분 콤마 무효화 방지) — provenance = gap96.json(src_comp 포함).
gvals = []
for o in gap:
    gvals.append(f"  ('{o['comp_cd']}','{APPLY_YMD}',{o['siz_width']},{o['siz_height']},{slit(o['mat_cd'])},{o['unit_price']})")
a2.append(",\n".join(gvals))
a2.append(") AS v(comp_cd, apply_ymd, siz_width, siz_height, mat_cd, unit_price)")
a2.append("WHERE NOT EXISTS (")
a2.append("  SELECT 1 FROM t_prc_component_prices cp")
a2.append("   WHERE cp.comp_cd = v.comp_cd AND cp.apply_ymd = v.apply_ymd")
a2.append("     AND cp.siz_width = v.siz_width AND cp.siz_height = v.siz_height")
a2.append("     AND cp.mat_cd IS NOT DISTINCT FROM v.mat_cd")
a2.append("     AND cp.siz_cd IS NULL AND cp.plt_siz_cd IS NULL AND cp.clr_cd IS NULL")
a2.append("     AND cp.proc_cd IS NULL AND cp.opt_cd IS NULL AND cp.print_opt_cd IS NULL")
a2.append("     AND cp.coat_side_cnt IS NULL AND cp.bdl_qty IS NULL AND cp.min_qty IS NULL")
a2.append("     AND COALESCE(cp.dim_vals,'{}'::jsonb) = '{}'::jsonb")
a2.append(");")
open("A2_gap_unitprices.sql", "w").write("\n".join(a2) + "\n")
print("A2 rows:", len(gvals))

# ============================================================
# A3 — use_dims 전환 (siz_cd 토큰 → siz_width/siz_height) — 두께 mat_cd 직교
#   CLEAR3T: ["siz_cd","mat_cd","min_qty"] → ["siz_width","siz_height","mat_cd"]  (min_qty 제거·전건 1)
#   MIRROR3T: ["siz_cd","mat_cd"]          → ["siz_width","siz_height"]            (단가행 mat NULL=mat 토큰 무사용)
# ============================================================
a3 = []
a3.append("-- A3_use_dims_switch.sql — 본체 면적 comp use_dims(siz_cd 포함) → siz_width/siz_height (2 comp·두께 mat_cd 직교)")
a3.append("-- CLEAR3T: [siz_cd,mat_cd,min_qty] → [siz_width,siz_height,mat_cd] (★mat_cd 유지=3T/1.5T 두께분기·min_qty 제거: 전건 1·면적매트릭스 수량축 없음).")
a3.append("-- MIRROR3T: [siz_cd,mat_cd] → [siz_width,siz_height] (단가행 mat_cd 전건 NULL → mat 토큰 무사용·제거).")
a3.append("-- A1/A2가 데이터를 siz_width/height로 먼저 채운 뒤 전환 → 가격 공백 0.")
a3.append("-- 멱등: use_dims @> [siz_cd] 인 행만(이미 전환됐으면 skip) → 2-pass 0행.")
a3.append("UPDATE t_prc_price_components")
a3.append("   SET use_dims = '[\"siz_width\", \"siz_height\", \"mat_cd\"]'::jsonb, upd_dt = now()")
a3.append(" WHERE comp_cd = 'COMP_ACRYL_CLEAR3T' AND use_dims @> '[\"siz_cd\"]'::jsonb;")
a3.append("UPDATE t_prc_price_components")
a3.append("   SET use_dims = '[\"siz_width\", \"siz_height\"]'::jsonb, upd_dt = now()")
a3.append(" WHERE comp_cd = 'COMP_ACRYL_MIRROR3T' AND use_dims @> '[\"siz_cd\"]'::jsonb;")
open("A3_use_dims_switch.sql", "w").write("\n".join(a3) + "\n")
print("A3 comps: 2")

# ============================================================
# 배선보정 — PRF_CLR_ACRYL → COMP_ACRYL_CLEAR3T disp_seq=1·addtn_yn=N (라이브 NULL→값)
#   (G-D2 W2 본체 배선 패턴). 미러/코롯토/카라비너 신설 = BLOCKED(별 파일).
# ============================================================
aw = []
aw.append("-- AW_wiring_fix.sql — 라이브 PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T 배선 메타 보정(disp_seq/addtn_yn NULL→값)")
aw.append("-- G-D2 W2 본체 배선 패턴: 본체 comp disp_seq=1·addtn_yn='N'(합산 시작·엔진무관 메타). 라이브 배선행 실재(NULL 메타만 보정).")
aw.append("-- 미러/코롯토/카라비너 공식·배선 신설 = BLOCKED(별 파일 acrylic-blocked.BLOCKED.sql).")
aw.append("-- 멱등: disp_seq IS NULL OR addtn_yn IS NULL 인 행만 → 2-pass 0행.")
aw.append("UPDATE t_prc_formula_components")
aw.append("   SET disp_seq = 1, addtn_yn = 'N'")
aw.append(" WHERE frm_cd = 'PRF_CLR_ACRYL' AND comp_cd = 'COMP_ACRYL_CLEAR3T'")
aw.append("   AND (disp_seq IS NULL OR addtn_yn IS NULL);")
open("AW_wiring_fix.sql", "w").write("\n".join(aw) + "\n")
print("AW wiring rows: 1")

print("DONE — A1(121 UPDATE) A2(96 INSERT) A3(2 use_dims) AW(1 wiring). A4(nonspec incr)=BLOCKED Q-ACR-AC2.")
