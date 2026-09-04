"""t41 — 세 조각을 한 트랜잭션 적용본으로 묶는다.

①  t_prd_product_plate_sizes  반칼 10상품 활성행 siz_cd SIZ_000521 → SIZ_000498  (10행 UPDATE)
②  t_prc_price_components     STK_KISSCUT_PRINT use_dims 에 plt_siz_cd 추가       (1행 UPDATE)
③  t_prc_component_prices     누락 단가행                                          (648행 INSERT)

②③ 본문은 t36/t40 apply.sql 에서 그대로 떼어 온다(다시 만들지 않는다).
"""
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
T36 = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t36/.moai/reports/t36/apply.sql'
T40 = f'{HERE}/_t40_apply.sql'

PRDS = ['PRD_000052', 'PRD_000053', 'PRD_000054', 'PRD_000058', 'PRD_000059',
        'PRD_000060', 'PRD_000061', 'PRD_000062', 'PRD_000063', 'PRD_000064']
PRD_LIST = ",\n                       ".join(f"'{p}'" for p in PRDS)

m36 = re.search(r'^(UPDATE t_prc_price_components\b.*?;)\s*$',
                open(T36).read(), re.S | re.M)
if not m36:
    raise SystemExit('t36 apply.sql 에서 UPDATE 문을 못 찾았다 — 원본 확인 필요')
t36_body = m36.group(1).strip()
t40_body = open(T40).read().split('\nBEGIN;\n', 1)[1].split('\n-- 검산:', 1)[0].strip()

STEP1 = f"""UPDATE t_prd_product_plate_sizes
   SET siz_cd = 'SIZ_000498',
       upd_dt = now()
 WHERE prd_cd IN ({PRD_LIST})
   AND siz_cd = 'SIZ_000521'
   AND COALESCE(del_yn, 'N') = 'N';"""

CHECKS = """-- 검산 A: 판형 — 10상품이 SIZ_000498, 스티커팩 065 는 SIZ_000521 그대로
SELECT ps.siz_cd, count(*) AS rows
  FROM t_prd_product_plate_sizes ps
 WHERE COALESCE(ps.del_yn,'N')='N'
   AND ps.prd_cd IN ('PRD_000052','PRD_000053','PRD_000054','PRD_000058','PRD_000059',
                     'PRD_000060','PRD_000061','PRD_000062','PRD_000063','PRD_000064',
                     'PRD_000065')
 GROUP BY 1 ORDER BY 1;

-- 검산 B: use_dims
SELECT comp_cd, use_dims FROM t_prc_price_components WHERE comp_cd='STK_KISSCUT_PRINT';

-- 검산 C: 단가행 — 9사이즈 각 288
SELECT siz_cd, count(*) AS rows FROM t_prc_component_prices
 WHERE comp_cd='STK_KISSCUT_PRINT' GROUP BY 1 ORDER BY 1;"""

HEADER = """-- t41 — 스티커 판형환산 일괄 적용본 (t39 대체)
-- 작성 2026-09-04 · run 레인 · Class B · COMMIT = 인간 승인
--
-- 세 조각을 한 트랜잭션으로 묶는다. 순서가 중요하다 —
-- 판형(①)이 먼저 서야 use_dims(②)가 판수 환산을 켤 수 있고, 단가행(③)이 그 판수로 조회된다.
-- ② 만 먼저 들어가면 「판수 환산 불가」로 가격이 막힌다(t36 verdict 참조).
--
-- 범위: 아래 3개 테이블 · 3개 문장뿐. 그 외 쓰기 금지.
--   ① t_prd_product_plate_sizes   10행 UPDATE (SIZ_000521 → SIZ_000498)
--   ② t_prc_price_components       1행 UPDATE (use_dims + plt_siz_cd)
--   ③ t_prc_component_prices     648행 INSERT (삭제 0)
--
-- ① 근거: 시트 「판걸이수」 r77~r82 반칼스티커 판형 = 317x440 = SIZ_000498.
--         fn_calc_pansu 대조 6/6 일치(pansu_check.md). 스티커팩 065 는 r94 가 330x470 이라 제외.
-- ②③ 본문: t36/t40 apply.sql 에서 그대로 가져왔다(재작성 없음).
--
-- ★ 이 파일은 아직 실행되지 않았다. dryrun.log 가 ROLLBACK 까지의 실증이다.
"""


def main():
    with open(f'{HERE}/apply.sql', 'w') as f:
        f.write(HEADER + '\nBEGIN;\n\n')
        f.write('-- ① 판형 교체 -------------------------------------------------------\n')
        f.write(STEP1 + '\n\n')
        f.write('-- ② use_dims -------------------------------------------------------\n')
        f.write(t36_body + '\n\n')
        f.write('-- ③ 누락 단가행 ----------------------------------------------------\n')
        f.write(t40_body + '\n\n')
        f.write(CHECKS + '\n\nCOMMIT;\n')

    with open(f'{HERE}/rollback.sql', 'w') as f:
        f.write("""-- t41 rollback — apply.sql 을 ③②① 역순으로 되돌린다.
-- ★ apply.sql 이 COMMIT 되지 않았다면 실행할 필요가 없다.

BEGIN;

-- ③ 단가행 648행 제거 (이 카드가 넣은 것만)
DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND apply_ymd = '2026-09-02'
   AND note LIKE '권위 스티커 r% c1%'
   AND ( (siz_cd = 'SIZ_000057' AND mat_cd IN ('MAT_000609','MAT_000611'))
      OR  siz_cd IN ('SIZ_000058','SIZ_000067') );

-- ② use_dims 원복
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb;

-- ① 판형 원복
UPDATE t_prd_product_plate_sizes
   SET siz_cd = 'SIZ_000521',
       upd_dt = now()
 WHERE prd_cd IN ('PRD_000052','PRD_000053','PRD_000054','PRD_000058','PRD_000059',
                  'PRD_000060','PRD_000061','PRD_000062','PRD_000063','PRD_000064')
   AND siz_cd = 'SIZ_000498'
   AND COALESCE(del_yn,'N') = 'N';

COMMIT;
""")
    print('apply.sql · rollback.sql 생성')


if __name__ == '__main__':
    main()
