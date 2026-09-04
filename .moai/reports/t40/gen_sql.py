"""fill_rows.csv → apply.sql / rollback.sql / dryrun.sql 생성.

멱등 방식 주의(카드 전제 정정):
  카드는 `ux_t_prc_comp_prices_nat_key` 기준 ON CONFLICT 로 멱등을 걸라고 했으나,
  실측 결과 그 유니크 인덱스는 `indnullsnotdistinct = f`(NULL 을 서로 다른 값으로 취급)다.
  우리가 넣는 행은 plt_siz_cd·clr_cd·proc_cd·opt_cd·print_opt_cd·coat_side_cnt·
  spot_side_cnt·bdl_qty·page_cnt·siz_width·siz_height·dim_vals 가 전부 NULL 이라
  ON CONFLICT 가 발화하지 않고 중복 적재된다.
  → NULL 안전한 `WHERE NOT EXISTS` 로 멱등을 건다. DRY-RUN 에서 2회 실행으로 실증한다.
"""
import csv
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROWS = list(csv.DictReader(open(f'{HERE}/fill_rows.csv')))
COMP = 'STK_KISSCUT_PRINT'
SIZES = sorted({r['siz_cd'] for r in ROWS})

NULL_COLS = ['plt_siz_cd', 'clr_cd', 'proc_cd', 'opt_cd', 'print_opt_cd',
             'coat_side_cnt', 'spot_side_cnt', 'bdl_qty', 'page_cnt',
             'siz_width', 'siz_height', 'dim_vals']


def esc(s):
    return s.replace("'", "''")


def values_block():
    out = []
    for r in ROWS:
        out.append(f"    ('{r['comp_cd']}','{r['apply_ymd']}','{r['siz_cd']}',"
                   f"'{r['mat_cd']}',{r['min_qty']},{r['unit_price']},'{esc(r['note'])}')")
    return ',\n'.join(out)


INSERT = f"""INSERT INTO t_prc_component_prices
       (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt, upd_dt)
SELECT v.comp_cd, v.apply_ymd, v.siz_cd, v.mat_cd, v.min_qty, v.unit_price, v.note,
       now(), now()
  FROM (VALUES
{values_block()}
       ) AS v(comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
 WHERE NOT EXISTS (
       SELECT 1 FROM t_prc_component_prices p
        WHERE p.comp_cd   = v.comp_cd
          AND p.apply_ymd = v.apply_ymd
          AND p.siz_cd    = v.siz_cd
          AND p.mat_cd    = v.mat_cd
          AND p.min_qty   = v.min_qty
          AND {chr(10) + '          AND '.join(f'p.{c} IS NULL' for c in NULL_COLS)});"""

HEADER = """-- t40 — STK_KISSCUT_PRINT 누락 단가행 보충 (Class B · 단가행 INSERT 만)
-- 작성 2026-09-04 · run 레인 · 입력 = 가격표 260903 「스티커」 시트 + FINDINGS ★정정
--
-- 범위: t_prc_component_prices INSERT 만. 삭제 0 · UPDATE 0.
--       사이즈/자재/공식/코드 마스터는 건드리지 않는다.
--
-- 값 출처: 시트 r4 c14 「A6(8판)/100*148(8판)」 열 묶음 (c14 유포/비코팅/미색 ·
--          c15 무광코팅/유광코팅 · c16 투명/홀로그램), 데이터 행 r7~r42 = 36 수량구간.
--          이 열이 맞다는 것은 이미 라이브에 있는 A6 6자재 216칸과 대조해 실증했다
--          (verify_src.py · 불일치 0).
--
-- 채우는 곳 3군데 (합계 648행):
--   ① SIZ_000057 A6      × MAT_000609·MAT_000611            = 72   (나머지 6자재는 기존)
--   ② SIZ_000058 100x140 × 8자재                             = 288  (시트 '100*148' 은 오타)
--   ③ SIZ_000067 140x100 × 8자재                             = 288  (판걸이 8 동일 열 적용)
--
-- ⚠ 멱등 방식: ON CONFLICT 가 아니라 WHERE NOT EXISTS 다.
--   ux_t_prc_comp_prices_nat_key 는 indnullsnotdistinct=f 라 NULL 컬럼이 있는 우리 행에는
--   ON CONFLICT 가 발화하지 않는다(PostgreSQL 18.6 실측). dryrun.log 2회 실행으로 실증.
--
-- ★ COMMIT = 인간 승인. 이 파일 자체는 아직 실행되지 않았다.
"""


def main():
    with open(f'{HERE}/apply.sql', 'w') as f:
        f.write(HEADER + '\nBEGIN;\n\n' + INSERT + '\n\n')
        f.write("-- 검산: 3사이즈 행수 = 72 / 288 / 288 이어야 한다.\n")
        f.write("SELECT siz_cd, count(*) FROM t_prc_component_prices\n"
                f" WHERE comp_cd = '{COMP}' AND siz_cd IN "
                f"({', '.join(chr(39) + s + chr(39) for s in SIZES)})\n"
                " GROUP BY 1 ORDER BY 1;\n\nCOMMIT;\n")

    with open(f'{HERE}/rollback.sql', 'w') as f:
        f.write("""-- t40 rollback — apply.sql 이 넣은 648행만 지운다.
-- 식별 조건: 이 카드가 넣은 3사이즈 + 이번에 붙인 비고 접두어.
-- 기존 1,944행은 siz_cd 가 다르거나(058·067 은 통째로 신규), A6 는 자재 2종만 대상이라
-- 아래 조건에 걸리지 않는다.
--
-- ★ apply.sql 이 COMMIT 되지 않았다면 실행할 필요가 없다.

BEGIN;

DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND apply_ymd = '2026-09-02'
   AND note LIKE '권위 스티커 r% c1%'
   AND ( (siz_cd = 'SIZ_000057' AND mat_cd IN ('MAT_000609','MAT_000611'))
      OR  siz_cd IN ('SIZ_000058','SIZ_000067') );

SELECT siz_cd, count(*) FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND siz_cd IN ('SIZ_000057','SIZ_000058','SIZ_000067')
 GROUP BY 1 ORDER BY 1;

COMMIT;
""")
    print(f'apply.sql · rollback.sql 생성 · VALUES {len(ROWS)}행')


if __name__ == '__main__':
    main()
