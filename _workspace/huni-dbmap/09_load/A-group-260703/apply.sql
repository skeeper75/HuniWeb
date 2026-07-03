-- A그룹 돈영향 갭 3건 COMMIT (2026-07-03) — 사용자 승인분
--  ① 캘린더 5상품 종이 드롭다운 부속 6행 논리삭제(삼각대2+링블랙4·교차오염)
--  ② 아크릴 146 키링 자재 오적재 교정(MAT_000043 재활성 → 기본선택 격자유효·silent-0 해소, MAT_000386 은퇴)
--  ③ 아크릴 151 맥세이프 본체 공식 바인딩(견적불가 해소·부속 바디가격 업체 미정→본체만)
-- 백업: 09_load/A-group-260703/backup/*.csv · undo: undo.sql
-- 자체 DRY-RUN 확인: 캘린더 6·146 자재 2·151 1·캘린더 nonpaper=0.
BEGIN;

-- ① 캘린더 부속 6행 논리삭제
UPDATE t_prd_product_materials pm SET del_yn='Y'
FROM t_mat_materials m
WHERE pm.mat_cd=m.mat_cd
  AND pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
  AND m.mat_typ_cd <> 'MAT_TYPE.01'
  AND pm.del_yn='N';

-- ② 146 키링 자재 교정
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000043' AND usage_cd='USAGE.07';
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd='MAT_000386' AND usage_cd='USAGE.07';

-- ③ 151 맥세이프 본체 바인딩
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
VALUES ('PRD_000151','PRF_CLR_ACRYL','2026-06-28','GB-1 견적불가 해소(맥세이프 바디=업체 가격 미정·본체만)',now())
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;

COMMIT;
