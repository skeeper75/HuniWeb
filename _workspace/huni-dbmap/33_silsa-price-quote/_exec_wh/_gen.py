#!/usr/bin/env python3
# Deterministic generator for V1/V1b/V2/V3 from poster-sign-import.xlsx (verbatim matrix cells).
# Source authority: 20_price-import/poster-sign/poster-sign-import.xlsx sheet 4b_component_prices_GAP_BLOCKED
#                   + live 17 siz_cd matrix rows (converted in-place). NO price fabrication.
import json, collections

APPLY_YMD = '2026-06-01'

# ---- V1 source: 667 GAP matrix cells (comp, w, h, apply_ymd, price) ----
gap = json.load(open('/tmp/v1_gap_rows.json'))           # [(comp,g,s,ay,price), ...]
live17 = json.load(open('/tmp/v1_live18.json'))          # [(comp,w,h,price,comp_price_id), ...]

MATRIX_COMPS = sorted({c for c,_,_,_,_ in gap})
assert len(MATRIX_COMPS) == 13, len(MATRIX_COMPS)
assert len(gap) == 667, len(gap)
assert all(p is not None for *_,p in gap)

# ---------- V1: INSERT 667 GAP cells as siz_width/siz_height rows ----------
def sql_lit(v): return 'NULL' if v is None else str(v)
lines = []
lines.append("-- V1_area_unitprices.sql — 면적매트릭스 단가행 적재 (siz_width/siz_height 구간)")
lines.append("-- 출처(HARD·날조 금지): poster-sign-import.xlsx 시트 4b_component_prices_GAP_BLOCKED 667 셀(가격표 [가로×세로] verbatim).")
lines.append("-- 모델: comp_cd + siz_width(가로 상한) + siz_height(세로 상한) + unit_price. siz_cd/clr/mat/proc/opt/print_opt/plt/min_qty = NULL.")
lines.append("-- 엔진 TIER '이하 상한' 매칭(pricing.py TIER_UPPER): 주문 가로 ≤ 임계 중 최소 임계. off-grid=다음 큰 구간 ceiling 내장.")
lines.append("-- 멱등: 자연키(comp_cd,apply_ymd,siz_width,siz_height,…,COALESCE(dim_vals,'{}')) NOT EXISTS 가드. 2-pass delta 0. 좌표 siz 채번 0.")
lines.append("INSERT INTO t_prc_component_prices")
lines.append("  (comp_cd, apply_ymd, siz_width, siz_height, unit_price)")
lines.append("SELECT v.comp_cd, v.apply_ymd, v.siz_width, v.siz_height, v.unit_price")
lines.append("FROM (VALUES")
vals = []
for c, g, s, ay, p in gap:
    ay2 = APPLY_YMD  # normalize to live apply_ymd
    vals.append(f"  ('{c}','{ay2}',{g},{s},{int(p)})")
lines.append(",\n".join(vals))
lines.append(") AS v(comp_cd, apply_ymd, siz_width, siz_height, unit_price)")
lines.append("WHERE NOT EXISTS (")
lines.append("  SELECT 1 FROM t_prc_component_prices cp")
lines.append("   WHERE cp.comp_cd = v.comp_cd AND cp.apply_ymd = v.apply_ymd")
lines.append("     AND cp.siz_width = v.siz_width AND cp.siz_height = v.siz_height")
lines.append("     AND cp.siz_cd IS NULL AND cp.plt_siz_cd IS NULL AND cp.clr_cd IS NULL AND cp.mat_cd IS NULL")
lines.append("     AND cp.proc_cd IS NULL AND cp.opt_cd IS NULL AND cp.print_opt_cd IS NULL")
lines.append("     AND cp.coat_side_cnt IS NULL AND cp.bdl_qty IS NULL AND cp.min_qty IS NULL")
lines.append("     AND COALESCE(cp.dim_vals,'{}'::jsonb) = '{}'::jsonb")
lines.append(");")
open("V1_area_unitprices.sql","w").write("\n".join(lines)+"\n")
print("V1 rows:", len(vals))

# ---------- V1b: convert 17 live siz_cd matrix rows -> siz_width/siz_height (in-place, value-identical) ----------
lb = []
lb.append("-- V1b_convert_live_sizcd.sql — 기존 라이브 siz_cd 매트릭스 단가행 17건 → siz_width/siz_height 전환(in-place·값 불변)")
lb.append("-- 근거: 13 매트릭스 comp의 라이브 siz_cd 행 17건(600x1800·900x900·900x1200·1500x1000)은 GAP 667과 비충돌(검증).")
lb.append("--   V2가 use_dims를 siz_width/height로 전환하면 이 siz_cd 행은 미매칭됨 → 값 손실 방지 위해 좌표(work_width/height) 기준 전환.")
lb.append("-- 좌표 = t_siz_sizes.work_width/work_height(라이브 권위). siz_cd→NULL, siz_width/height 세팅. unit_price 불변.")
lb.append("-- 멱등: siz_cd IS NOT NULL 인 매트릭스 행만 대상 → 2-pass 시 0행.")
lb.append("UPDATE t_prc_component_prices cp")
lb.append("   SET siz_width = s.work_width, siz_height = s.work_height, siz_cd = NULL, upd_dt = now()")
lb.append("  FROM t_siz_sizes s")
lb.append(" WHERE cp.siz_cd = s.siz_cd")
lb.append("   AND cp.siz_cd IS NOT NULL AND cp.siz_width IS NULL")
lb.append("   AND cp.comp_cd IN (")
lb.append(",\n".join(f"     '{c}'" for c in MATRIX_COMPS))
lb.append("   );")
open("V1b_convert_live_sizcd.sql","w").write("\n".join(lb)+"\n")
print("V1b target comps:", len(MATRIX_COMPS))

# ---------- V2: use_dims switch siz_cd -> siz_width/siz_height for 13 matrix comps ----------
l2=[]
l2.append("-- V2_use_dims_switch.sql — 본체 면적 comp use_dims(siz_cd 포함) → [\"siz_width\",\"siz_height\"] (13 comp)")
l2.append("-- G-D2 W1~W6 공식분리·후가공 배선 무손상(후가공은 proc_cd/dim_vals 차원·사이즈 무관).")
l2.append('-- ★WATERPROOF_PET은 use_dims=["siz_cd","min_qty"](잉여 min_qty·실제 행에 min_qty 없음=structure.md B03 면적매트릭스).')
l2.append("--   → siz_cd 토큰 포함 행 전건 전환(@> 매칭)으로 13 comp 전부 통일.")
l2.append("-- 멱등: use_dims에 siz_cd 토큰 남은 행만 전환(이미 siz_width/height면 skip) → 2-pass 0행.")
l2.append("UPDATE t_prc_price_components")
l2.append('   SET use_dims = \'["siz_width", "siz_height"]\'::jsonb, upd_dt = now()')
l2.append(" WHERE comp_cd IN (")
l2.append(",\n".join(f"     '{c}'" for c in MATRIX_COMPS))
l2.append("   )")
l2.append("   AND use_dims @> '[\"siz_cd\"]'::jsonb;  -- siz_cd 토큰 포함 행(WATERPROOF_PET의 잉여 min_qty 포함분도) 전환")
open("V2_use_dims_switch.sql","w").write("\n".join(l2)+"\n")

# ---------- V3: nonspec incr backfill for 13 products ----------
# step per product from matrix finest step: posters=200, banners(138/139)=100. derived from matrix, not fabricated.
PROD_INCR = {
 'PRD_000118':200,'PRD_000119':200,'PRD_000120':200,'PRD_000121':200,'PRD_000122':200,
 'PRD_000123':200,'PRD_000124':200,'PRD_000125':200,'PRD_000126':200,'PRD_000127':200,'PRD_000128':200,
 'PRD_000138':100,'PRD_000139':100,
}
l3=[]
l3.append("-- V3_nonspec_incr.sql — off-grid 증가단위 백필 (nonspec_width_incr/height_incr)")
l3.append("-- 근거: 13 면적매트릭스 상품은 라이브 nonspec_yn='Y'·width/height min/max 보유, incr만 NULL(백필 대기).")
l3.append("-- incr = 매트릭스 그리드 최소 스텝(포스터 200·현수막 100, GAP 시트 임계 간격에서 도출·날조 아님).")
l3.append("-- 역할: 비규격 가로/세로 입력 step 정규화(앱). 가격은 siz_width/height '이하' 구간 매칭(엔진).")
l3.append("-- 멱등: incr IS NULL 인 행만 백필 → 2-pass 0행.")
for prd, st in PROD_INCR.items():
    l3.append(f"UPDATE t_prd_products SET nonspec_width_incr={st}, nonspec_height_incr={st}, upd_dt=now() WHERE prd_cd='{prd}' AND nonspec_width_incr IS NULL;")
open("V3_nonspec_incr.sql","w").write("\n".join(l3)+"\n")
print("V3 products:", len(PROD_INCR))
