-- round-13 BATCH-4 레더 자재유형 교정 (Wave-1 첫 착수)
-- 레더(화이트)·레더하드커버 = 가죽(.06). 현재 .08 실사소재·.01 종이 오적재 교정.
-- 멱등(현재값 조건 → 재실행 시 0행)·비파괴(mat_typ_cd만)·트랜잭션.
-- 권위: 17_correctness/photobook/correction-manifest.md F-PB-2 / Wave-0 D-package BATCH-4 (a)채택.
BEGIN;

-- 레더(화이트) MAT_000186: 6상품 표지 자재유형 → 가죽
UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.06', upd_dt=now()
 WHERE mat_cd='MAT_000186' AND mat_typ_cd='MAT_TYPE.08';

-- 레더하드커버 MAT_000006: 포토북 표지 자재유형 → 가죽
UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.06', upd_dt=now()
 WHERE mat_cd='MAT_000006' AND mat_typ_cd='MAT_TYPE.01';

COMMIT;
