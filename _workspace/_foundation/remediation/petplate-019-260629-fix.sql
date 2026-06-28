-- ─────────────────────────────────────────────────────────────────────
-- 투명엽서019 출력판형 오적재 교정 — FIX (COMMIT·인간 승인 후)
-- 결함: 투명엽서019에만 소형 판형 4개(완제품/작업사이즈)가 plate_sizes에 오적재
--       → 엔진 best-plate가 단가행 없는 소형 판형 선택 → 인쇄비/용지비 미매칭 → 견적 0.
-- 권위: 형제 디지털엽서 전부(프리미엄·코팅·스탠다드…)는 SIZ_000499(316x467 전지) 단 1개만 보유.
--       디지털인쇄 출력판형 = 전지(SIZ_000499)뿐(단가행도 전부 거기). [[dbmap-platesize-is-output-paper]]
-- 교정: 소형 판형 4링크 논리삭제(del_yn=Y) → 전지만 남김 → best-plate=SIZ_000499.
-- 멱등·되돌리기: del_yn='N' 복원. 마스터(t_siz_sizes)·타 상품 미터치.
-- ─────────────────────────────────────────────────────────────────────
BEGIN;

UPDATE t_prd_product_plate_sizes
   SET del_yn = 'Y', upd_dt = now()
 WHERE prd_cd = 'PRD_000019' AND del_yn = 'N'
   AND siz_cd IN ('SIZ_000113', 'SIZ_000114', 'SIZ_000115', 'SIZ_000118');

-- 검증: 투명엽서 plate_sizes 활성행 = SIZ_000499 하나만 남아야 함
SELECT siz_cd, del_yn FROM t_prd_product_plate_sizes
 WHERE prd_cd = 'PRD_000019' ORDER BY del_yn, siz_cd;

COMMIT;

-- UNDO: UPDATE t_prd_product_plate_sizes SET del_yn='N'
--        WHERE prd_cd='PRD_000019' AND siz_cd IN ('SIZ_000113','SIZ_000114','SIZ_000115','SIZ_000118');
