#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_batch_upsert.py — 동형 클래스 L1 CSV → 멱등 NOT EXISTS UPSERT SQL 배치 생성.
  손편집 금지·재현성·결정적. dbm-batch-load S3.

핵심 불변[HARD]:
  - 멱등 = NOT EXISTS NULL-safe 가드 (ON CONFLICT 금지:
    자연키 인덱스 ux_t_prc_comp_prices_nat_key 가 NULLS DISTINCT 라 NULL 차원서 미발화).
  - apply_ymd = '2026-06-01' 고정 (단가행 적용일 분기 = 가격 이중계상).
  - reg_dt 컬럼 생략(DEFAULT now()) · IDENTITY PK 비명시 · 권위 = 엑셀 명시값.

config(클래스별): 적용 시 채운다.
  TABLE      : 적재 대상 t_*
  NATKEY     : 자연키 컬럼 목록 (NULL 포함 가능 → NULL-safe 비교)
  COLS       : INSERT 컬럼 (자연키 + 값)
  SOURCE_CSV : 06_extract / 02_mapping 산출 재사용 (엑셀 L1=권위)
사용: python gen_batch_upsert.py <class> <source.csv> <out.sql>
"""
import csv, sys, os

APPLY_YMD = '2026-06-01'

# 클래스별 스키마 config (예시 — component_prices. 적용 시 클래스에 맞춰 확장)
TABLE = 't_prc_component_prices'
NATKEY = ['comp_cd', 'mat_cd', 'siz_cd', 'clr_cd', 'proc_cd', 'opt_cd',
          'coat_side_cnt', 'bdl_qty', 'min_qty', 'apply_ymd']
VALCOLS = ['unit_price']
COLS = NATKEY + VALCOLS


def sql_val(v):
    """NULL/숫자/문자 → SQL 리터럴."""
    if v is None or v == '' or str(v).upper() == 'NULL':
        return 'NULL'
    try:
        float(v); return str(v)
    except ValueError:
        return "'" + str(v).replace("'", "''") + "'"


def natkey_match(row):
    """NULL-safe 자연키 일치 조건 (IS NOT DISTINCT FROM)."""
    parts = []
    for k in NATKEY:
        v = APPLY_YMD if k == 'apply_ymd' else row.get(k)
        parts.append(f"{k} IS NOT DISTINCT FROM {sql_val(v)}")
    return ' AND '.join(parts)


def main():
    cls, src, out = sys.argv[1], sys.argv[2], sys.argv[3]
    with open(src, encoding='utf-8') as f:
        rows = list(csv.DictReader(f))
    lines = [f"-- batch {cls} → {TABLE} ({len(rows)}행) · 멱등 NOT EXISTS · apply_ymd={APPLY_YMD}",
             "-- 손편집 금지(gen_batch_upsert.py 재생성). 단가행 적용일 분기 금지.\n"]
    for r in rows:
        r['apply_ymd'] = APPLY_YMD
        cols = ', '.join(COLS)
        vals = ', '.join(sql_val(r.get(c)) for c in COLS)
        lines.append(
            f"INSERT INTO {TABLE} ({cols})\n"
            f"SELECT {vals}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM {TABLE} WHERE {natkey_match(r)});")
    with open(out, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')
    print(f"[gen] {cls}: {len(rows)}행 → {out} (멱등 NOT EXISTS)")


if __name__ == '__main__':
    main()
