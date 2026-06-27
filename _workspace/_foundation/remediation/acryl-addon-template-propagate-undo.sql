-- acryl-addon-template-propagate-undo.sql — 6상품 addon 템플릿 전파 역연산 (인간 승인 후만)
-- 되돌림: addon 템플릿/단가/링크 제거 + 바인딩 PRF_CLR_ACRYL→가산형 PRF 복원.
-- ★옵션그룹/옵션/아이템(삭제된 가산 옵션층)은 깨진 모델이라 복원 안 함(필요 시 원본 fix 파일=
--   acryl-146-step2·acryl-addon-147-152·acryl-154-hairband 재실행). 146 자재 MAT_202~209도 미복원(동일).
BEGIN;
DELETE FROM t_prd_product_addons   WHERE tmpl_cd BETWEEN 'TMPL-000015' AND 'TMPL-000026';
DELETE FROM t_prd_template_prices  WHERE tmpl_cd BETWEEN 'TMPL-000015' AND 'TMPL-000026';
DELETE FROM t_prd_templates        WHERE tmpl_cd BETWEEN 'TMPL-000015' AND 'TMPL-000026';
DELETE FROM t_prd_product_price_formulas
WHERE (prd_cd,frm_cd) IN (
  ('PRD_000146','PRF_CLR_ACRYL'),('PRD_000148','PRF_CLR_ACRYL'),('PRD_000149','PRF_CLR_ACRYL'),
  ('PRD_000150','PRF_CLR_ACRYL'),('PRD_000152','PRF_CLR_ACRYL'),('PRD_000154','PRF_CLR_ACRYL')
);
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES
 ('PRD_000146','PRF_ACRYL_KEYRING','2026-06-28','(undo) 가산형 복원'),
 ('PRD_000148','PRF_ACRYL_BADGE','2026-06-28','(undo)'),
 ('PRD_000149','PRF_ACRYL_CLIP','2026-06-28','(undo)'),
 ('PRD_000150','PRF_ACRYL_SMARTTOK','2026-06-28','(undo)'),
 ('PRD_000152','PRF_ACRYL_NAMETAG','2026-06-28','(undo)'),
 ('PRD_000154','PRF_ACRYL_HAIRBAND','2026-06-28','(undo)');
COMMIT;
