-- S2 · 투명 오매핑 교정 (GAP-MAT-2) — 기존 행 UPDATE (신규 적재 아님·과교정 0)
-- 출처: 라이브 실측(COMP_STK_PRINT mat_cd=MAT_000170 90행) + sticker-3axis-design §4.1 + material-axis(170=투명데드롱·합판도무송 전용·정답=162 투명스티커)
-- 라이브 170 행 90개(SIZ_059/060 B01 72 + SIZ_172/174/197 B02/B03 낱장 18) → mat_cd 162 재배치.
-- 단가 동일(검증: 가격표 투명 verbatim == 라이브 170 가격 0 mismatch) → 순수 relabel.
-- 멱등: 이미 162인 행 제외(WHERE mat_cd=170) + 162 자연키 충돌 시 미수정(NOT EXISTS dup 가드).
-- 과교정 0: 합판도무송(PRD_000066) 본체 comp(별 comp_cd)는 건드리지 않음 — COMP_STK_PRINT 한정.
UPDATE t_prc_component_prices cp
   SET mat_cd='MAT_000162', upd_dt=now(),
       note = COALESCE(note,'') || ' [remap 170→162 투명스티커]'
 WHERE cp.comp_cd='COMP_STK_PRINT'
   AND cp.apply_ymd='2026-06-01'
   AND cp.mat_cd='MAT_000170'
   AND NOT EXISTS (
     SELECT 1 FROM t_prc_component_prices d
      WHERE d.comp_cd='COMP_STK_PRINT' AND d.apply_ymd=cp.apply_ymd
        AND d.siz_cd=cp.siz_cd AND d.mat_cd='MAT_000162' AND d.min_qty=cp.min_qty
   );
