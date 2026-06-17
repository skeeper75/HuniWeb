#!/usr/bin/env python3
# ============================================================================
# 스티커 BLOCKED 마무리 SQL 생성기 (gen_load_sql.py) — 재현·provenance-traced
#   입력(권위): sticker-blocked-resolution.md (arbiter SB1~SB3 판정)
#               + 20_price-import/sticker/sticker-import.xlsx (단가 verbatim)
#               + 라이브 실측(mat_167·siz_060/068 실존·max siz_cd=SIZ_000517)
#   출력: SB1_tattoo.sql · SB2_pack_fix.sql · SB3_codegen.sql · SB3_b01_prices.sql
#   apply_ymd='2026-06-01' 고정(단가행 적용일 분기 금지 = 이중계상·sibling 관행).
#   ★.02 합가형 단가행은 min_qty NOT NULL(엔진 pricing.py:188 base<=0 ValueError).
# ============================================================================
import openpyxl

ROOT = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
XLSX = f'{ROOT}/20_price-import/sticker/sticker-import.xlsx'
OUT  = f'{ROOT}/33_silsa-price-quote/_exec_sticker2'
APPLY = '2026-06-01'

def fmt(p):
    p = float(p)
    return str(int(p)) if p == int(p) else str(p)

# ============================ SB3: B01 100x148/90x110 단가행 (채번 + verbatim) ============================
wb = openpyxl.load_workbook(XLSX, data_only=True)
ws = wb['4b_component_prices_BLOCKED']; rows = list(ws.iter_rows(values_only=True))
hdr = rows[0]; idx = {h: i for i, h in enumerate(hdr)}
sizmap = {'100*148(8판)': 'SIZ_000518', '90*110(12판)': 'SIZ_000519'}
matmap = {'유포':'MAT_000153','비코팅':'MAT_000084','미색':'MAT_000242',
          '무광코팅':'MAT_000155','유광코팅':'MAT_000156','투명':'MAT_000162','홀로그램':'MAT_000163'}
sb3 = []
for r in rows[1:]:
    sl, ml = r[idx['siz_label']], r[idx['mat_label']]
    if sl in sizmap and ml in matmap:
        sb3.append((sizmap[sl], matmap[ml], int(r[idx['min_qty']]),
                    float(r[idx['unit_price']]), f"B01 {ml} {sl.split('(')[0]}"))
sb3.sort(key=lambda x: (x[0], x[1], x[2]))

with open(f'{OUT}/SB3_b01_prices.sql', 'w') as f:
    f.write("""-- SB3(단가) · B01 100x148(8판)·90x110(12판) 단가행 (채번 후 적재) — component_prices INSERT
-- 출처: 20_price-import/sticker/sticker-import.xlsx#4b_component_prices_BLOCKED (verbatim) + 가격표 B01 3D 매트릭스(A1:S44·6사이즈 전부 단가 실재 확인·structure.md)
-- 2siz(518/519) × 7mat × 36mq = 504행. 가격=그룹단가 verbatim(유포/비코팅/미색=6700·코팅/투명/홀로=7700 @mq1).
-- ★SB3_codegen.sql 이 SIZ_000518/519 채번 후 실행(FK siz_cd→t_siz_sizes 선행).
-- 멱등: 자연키(comp_cd,apply_ymd,siz_cd,mat_cd,min_qty) NOT EXISTS. search-before-mint: mat 7종 실존.
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_STK_PRINT', v.apply_ymd, v.siz_cd, v.mat_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
""")
    f.write(",\n".join(
        f"  ('{APPLY}','{s}','{m}',{mq},{fmt(p)}::numeric,'{nm}')" for (s, m, mq, p, nm) in sb3))
    f.write("""
) AS v(apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd='COMP_STK_PRINT' AND cp.apply_ymd=v.apply_ymd
     AND cp.siz_cd=v.siz_cd AND cp.mat_cd=v.mat_cd AND cp.min_qty=v.min_qty
);
""")

print(f"SB3 B01 단가행 = {len(sb3)} rows (expect 504) · (SB1/SB2/SB3_codegen = 정적 hand SQL)")
