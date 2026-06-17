#!/usr/bin/env python3
# ============================================================================
# 반칼 058~061 A5/A4 단가행 SQL 생성기 (gen_load_sql.py) — 재현·provenance
#   입력(권위): bankal-058-064-deepcheck.md (arbiter BK6) + 사용자 컨펌
#               (A5=124x186 동일가 GO · A4 반칼 전용 siz 분리 GO)
#               + 20_price-import/sticker/sticker-import.xlsx (B01 col1=A5(4판)·col2=A4(2판) verbatim)
#               + 라이브 실측(058~061 등록 소재 5종=153/084/242/155/156·SIZ_170 A5·max siz=SIZ_000519)
#   출력: BK6b_price_a5.sql (SIZ_170) · BK6c_price_a4.sql (SIZ_000520 신규 반칼 A4)
#   ★058~061 등록 소재 5종만(투명162/홀로163 미등록) → A5/A4 단가행 5mat×36mq=180행 each.
#   apply_ymd='2026-06-01' 고정(이중계상 금지). PK=시퀀스→NOT EXISTS 자연키 가드.
#   ★A4 = SIZ_000520(신규·B01 반칼 전용)·col2 단가(5000/6000) → SIZ_172(B02 낱장 4000)와 분리=오청구 0.
# ============================================================================
import openpyxl

ROOT = '/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap'
XLSX = f'{ROOT}/20_price-import/sticker/sticker-import.xlsx'
OUT  = f'{ROOT}/33_silsa-price-quote/_exec_bankal2'
APPLY = '2026-06-01'
MAT5 = {'MAT_000153','MAT_000084','MAT_000242','MAT_000155','MAT_000156'}  # 058~061 등록 소재(라이브 실측)

def fmt(p):
    p = float(p)
    return str(int(p)) if p == int(p) else str(p)

wb = openpyxl.load_workbook(XLSX, data_only=True)
ws = wb['4_component_prices']; rows = list(ws.iter_rows(values_only=True))
hdr = rows[0]; idx = {h: i for i, h in enumerate(hdr)}

def extract(siz_label):
    out = []
    for r in rows[1:]:
        if r[idx['siz_label']] == siz_label and r[idx['mat_cd']] in MAT5:
            out.append((r[idx['mat_cd']], int(r[idx['min_qty']]), float(r[idx['unit_price']]), r[idx['mat_label']]))
    out.sort(key=lambda x: (x[0], x[1]))
    return out

def write_sql(path, siz_cd, label_src, col, rows_data, note_tag):
    with open(path, 'w') as f:
        f.write(f"""-- {note_tag} — component_prices INSERT (B01 {label_src} verbatim·058~061 등록 소재 5종)
-- 출처: 20_price-import/sticker/sticker-import.xlsx#4_component_prices ({label_src}) verbatim
-- 소재 5종(유포153·비코084·미색242·무광155·유광156) — 058~061 라이브 등록분만(투명/홀로 미등록).
-- comp_cd=COMP_STK_PRINT(B01 기존 패턴)·prc_typ_cd 동일·min_qty 36밴드·proc/clr/bdl=NULL.
-- 멱등: 자연키(comp_cd,apply_ymd,siz_cd,mat_cd,min_qty) NOT EXISTS (PK=시퀀스라 ON CONFLICT 불가).
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_STK_PRINT', v.apply_ymd, v.siz_cd, v.mat_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
""")
        f.write(",\n".join(
            f"  ('{APPLY}','{siz_cd}','{m}',{mq},{fmt(p)}::numeric,'B01 {col} {ml}')" for (m, mq, p, ml) in rows_data))
        f.write("""
) AS v(apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd='COMP_STK_PRINT' AND cp.apply_ymd=v.apply_ymd
     AND cp.siz_cd=v.siz_cd AND cp.mat_cd=v.mat_cd AND cp.min_qty=v.min_qty
);
""")

a5 = extract('A5(4판)')   # B01 col1 = 124x186 동일가
a4 = extract('A4(2판)')   # B01 col2 = 반칼 A4 (5000/6000)
write_sql(f'{OUT}/BK6b_price_a5.sql', 'SIZ_000170', 'A5(4판)', 'col1(A5)', a5,
          'BK6b · 058~061 A5 단가행 (SIZ_000170 재사용·A5=124x186 동일가 사용자 컨펌)')
write_sql(f'{OUT}/BK6c_price_a4.sql', 'SIZ_000520', 'A4(2판)', 'col2(A4반칼)', a4,
          'BK6c · 058~061 A4 반칼 단가행 (SIZ_000520 신규·B02 낱장 SIZ_172와 분리=오청구 0)')

print(f"A5(SIZ_170)={len(a5)} rows · A4반칼(SIZ_520)={len(a4)} rows (각 5mat×36mq=180 기대)")
