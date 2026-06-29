-- 포스터사인 면적격자 가로↔세로 transpose 오적재 교정 — DRY-RUN (ROLLBACK)
-- 권위=인쇄상품가격표 "포스터사인" [가로(열)×세로(행)]·라이브 읽기전용 원칙(이 스크립트 ROLLBACK·실 COMMIT 아님)
-- 실 COMMIT은 integrity-gate 독립 재실측 + 인간 승인 후. webadmin 엔진 미변경.
-- ★안전 확인: 13 comp 전부 siz_cd행 0·wh격자행만(혼재 없음·일괄 swap 안전·codex 가드 충족).
-- 단가값(unit_price) verbatim 불변 — siz_width ↔ siz_height 값만 교환.
-- 검증: 교정 후 시뮬레이터 아트프린트 600×1400=20,000(현재 21,600 과청구) 재실증 필수.

BEGIN;

-- ── 사전 상태(교정 전 transpose 증거: width>1200 행수) ──
SELECT 'BEFORE width>1200(권위위배=transpose)' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd LIKE 'COMP_POSTER%' AND siz_width > 1200
  AND comp_cd IN (
    'COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
    'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
    'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
    'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_BANNER_NORMAL','COMP_POSTER_BANNER_MESH');

-- ── transpose 교정: siz_width ↔ siz_height 값 교환 (13 comp 전 격자행) ──
-- ★주의: 임시 컬럼/CASE swap. 대칭셀(w=h)은 교환해도 동일(무해).
UPDATE t_prc_component_prices
SET siz_width = siz_height,
    siz_height = siz_width,
    upd_dt = now()
WHERE comp_cd IN (
    'COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
    'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
    'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
    'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT','COMP_POSTER_BANNER_NORMAL','COMP_POSTER_BANNER_MESH')
  AND siz_width IS NOT NULL AND siz_height IS NOT NULL
  AND siz_cd IS NULL;  -- ★격자행만(siz_cd 정본행 보호·현재 0이지만 방어)
-- 기대: 559+ 행 UPDATE (PostgreSQL SET은 우변을 동시평가 → swap 안전)

-- ── 사후 검증: 교정 후 권위 축(width≤1200, height≤3000)으로 정렬됐나 ──
SELECT 'AFTER width>1200(0이어야 정상)' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd LIKE 'COMP_POSTER%' AND siz_width > 1200
  AND comp_cd IN ('COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
    'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
    'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
    'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT');

-- ── 검증 샘플: 아트프린트 600×1400 셀 = 20000인가(현재 transpose면 1400×600에 있음) ──
SELECT 'CHECK 600x1400=20000' AS chk, siz_width::int, siz_height::int, unit_price::int
FROM t_prc_component_prices
WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND siz_width=600 AND siz_height=1400;

ROLLBACK;  -- ★DRY-RUN. 실 적용 시 인간 승인 후 COMMIT으로 교체.
           -- ★단, swap의 권위 정확 복원은 별도 권위 verbatim 대조(swap후 97%)로 검증됨.
           --   잔차 ~3% 셀은 verbatim 재적재 또는 게이트 정밀 확정 후 처리.
