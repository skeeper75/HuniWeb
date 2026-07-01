BEGIN;

-- ============================================================
-- 문구류 9종 반제품(표지/면지/내지) 분해 — 신규 16개 상품 생성
-- 가격 영향 없음(고정단가 유지) — 구조/생산정보 정합 목적
-- ============================================================

-- 1) 신규 반제품 상품 16개 생성
INSERT INTO t_prd_products
  (prd_cd, prd_nm, prd_typ_cd, semi_role_cd, nonspec_yn, file_upload_yn, editor_yn, use_yn, del_yn)
VALUES
  ('PRD_000293', '만년다이어리(소프트커버)-표지(아트250+무광코팅)', 'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000294', '만년다이어리(하드커버)-표지(아트250+무광코팅)',   'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000295', '만년다이어리(하드커버)-면지',                     'PRD_TYPE.02', 'SEMI_ROLE.03', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000296', '만년다이어리(레더하드커버)-표지(레더)',           'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000297', '만년다이어리(레더하드커버)-면지',                 'PRD_TYPE.02', 'SEMI_ROLE.03', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000298', '만년다이어리(레더소프트커버)-표지(레더)',         'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000299', '먼슬리플래너-표지(아트250+무광코팅)',             'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000300', '먼슬리플래너-내지(백모조100)',                    'PRD_TYPE.02', 'SEMI_ROLE.01', 'N', 'Y', 'N', 'Y', 'N'),
  ('PRD_000301', '스프링노트-표지(아트250+무광코팅)',               'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000302', '스프링노트-내지(무지)',                           'PRD_TYPE.02', 'SEMI_ROLE.01', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000303', '스프링수첩-표지(아트250+무광코팅)',               'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000304', '스프링수첩-내지(무지)',                           'PRD_TYPE.02', 'SEMI_ROLE.01', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000305', '메모패드-표지(아트250+무광코팅)',                 'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000306', '메모패드-내지(무지)',                             'PRD_TYPE.02', 'SEMI_ROLE.01', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000307', '중철노트-표지(아트250+무광코팅)',                 'PRD_TYPE.02', 'SEMI_ROLE.02', 'N', 'N', 'N', 'Y', 'N'),
  ('PRD_000308', '중철노트-내지(무지)',                             'PRD_TYPE.02', 'SEMI_ROLE.01', 'N', 'N', 'N', 'Y', 'N');

-- 2) 부모(완제품)-구성원 셋트 연결
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note, min_cnt, max_cnt, cnt_incr)
VALUES
  ('PRD_000172', 'PRD_000293', 1, 1, '표지만(면지·내지 없음)', 1, 1, NULL),
  ('PRD_000173', 'PRD_000294', 1, 1, '표지', 1, 1, NULL),
  ('PRD_000173', 'PRD_000295', 1, 2, '면지(기본 1종)', 1, 1, NULL),
  ('PRD_000174', 'PRD_000296', 1, 1, '표지(레더)', 1, 1, NULL),
  ('PRD_000174', 'PRD_000297', 1, 2, '면지(기본 1종)', 1, 1, NULL),
  ('PRD_000175', 'PRD_000298', 1, 1, '표지만(레더소프트커버, 면지 없음)', 1, 1, NULL),
  ('PRD_000176', 'PRD_000299', 1, 1, '표지', 1, 1, NULL),
  ('PRD_000176', 'PRD_000300', 1, 2, '내지=28p 고정(양면인쇄)', 28, 28, 0),
  ('PRD_000177', 'PRD_000301', 1, 1, '표지', 1, 1, NULL),
  ('PRD_000177', 'PRD_000302', 1, 2, '내지=무지(현재 인쇄없음·추후 커스텀인쇄 확장 예정)', NULL, NULL, NULL),
  ('PRD_000178', 'PRD_000303', 1, 1, '표지', 1, 1, NULL),
  ('PRD_000178', 'PRD_000304', 1, 2, '내지=무지(현재 인쇄없음·추후 커스텀인쇄 확장 예정)', NULL, NULL, NULL),
  ('PRD_000179', 'PRD_000305', 1, 1, '표지', 1, 1, NULL),
  ('PRD_000179', 'PRD_000306', 1, 2, '내지=무지(현재 인쇄없음·추후 커스텀인쇄 확장 예정)', NULL, NULL, NULL),
  ('PRD_000181', 'PRD_000307', 1, 1, '표지', 1, 1, NULL),
  ('PRD_000181', 'PRD_000308', 1, 2, '내지=무지(현재 인쇄없음·추후 커스텀인쇄 확장 예정)', NULL, NULL, NULL);

-- 3) 자재 배정을 부모→올바른 구성원으로 이관
--  3-1) 표지 자재(부모에서 삭제 후 표지 구성원으로 이동)
DELETE FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181') AND mat_cd IN ('MAT_000250','MAT_000186');

INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
VALUES
  ('PRD_000293', 'MAT_000250', 'USAGE.02', 'Y', 1),
  ('PRD_000294', 'MAT_000250', 'USAGE.02', 'Y', 1),
  ('PRD_000296', 'MAT_000186', 'USAGE.02', 'Y', 1),
  ('PRD_000298', 'MAT_000186', 'USAGE.02', 'Y', 1),
  ('PRD_000299', 'MAT_000250', 'USAGE.02', 'Y', 1),
  ('PRD_000301', 'MAT_000250', 'USAGE.02', 'Y', 1),
  ('PRD_000303', 'MAT_000250', 'USAGE.02', 'Y', 1),
  ('PRD_000305', 'MAT_000250', 'USAGE.02', 'Y', 1),
  ('PRD_000307', 'MAT_000250', 'USAGE.02', 'Y', 1);

--  3-2) 내지 자재(부모에서 삭제 후 내지 구성원으로 이동) — 먼슬리플래너는 별도 종이(MAT_000072)만, 나머지 4개는 무지내지+백모조100 둘 다
DELETE FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181') AND mat_cd IN ('MAT_000261','MAT_000072');

INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
VALUES
  ('PRD_000300', 'MAT_000072', 'USAGE.01', 'Y', 1),
  ('PRD_000302', 'MAT_000261', 'USAGE.01', 'Y', 1),
  ('PRD_000302', 'MAT_000072', 'USAGE.07', 'Y', 2),
  ('PRD_000304', 'MAT_000261', 'USAGE.01', 'Y', 1),
  ('PRD_000304', 'MAT_000072', 'USAGE.07', 'Y', 2),
  ('PRD_000306', 'MAT_000261', 'USAGE.01', 'Y', 1),
  ('PRD_000306', 'MAT_000072', 'USAGE.07', 'Y', 2),
  ('PRD_000308', 'MAT_000261', 'USAGE.01', 'Y', 1),
  ('PRD_000308', 'MAT_000072', 'USAGE.07', 'Y', 2);

-- 검증
\echo '=== VERIFY: 신규 상품 16개 ==='
SELECT prd_cd, prd_nm, prd_typ_cd, semi_role_cd FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000293' AND 'PRD_000308' ORDER BY prd_cd;
\echo '=== VERIFY: 셋트 연결 ==='
SELECT ps.prd_cd, p1.prd_nm AS parent, ps.sub_prd_cd, p2.prd_nm AS member
FROM t_prd_product_sets ps JOIN t_prd_products p1 ON p1.prd_cd=ps.prd_cd JOIN t_prd_products p2 ON p2.prd_cd=ps.sub_prd_cd
WHERE ps.prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181')
ORDER BY ps.prd_cd, ps.disp_seq;
\echo '=== VERIFY: 부모상품 잔여 자재(있으면 안 됨) ==='
SELECT prd_cd, mat_cd FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181');
\echo '=== VERIFY: 구성원 자재 ==='
SELECT prd_cd, mat_cd, usage_cd FROM t_prd_product_materials WHERE prd_cd BETWEEN 'PRD_000293' AND 'PRD_000308' ORDER BY prd_cd;
\echo '=== VERIFY: 부모 가격공식 그대로인지(가격 영향 없어야 함) ==='
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000172','PRD_000173','PRD_000174','PRD_000175','PRD_000176','PRD_000177','PRD_000178','PRD_000179','PRD_000181');

ROLLBACK;
