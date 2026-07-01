-- =====================================================================
-- added-schema-260701.sql — 위젯 컨버전 선행(③') 추가 스키마 제안 (PostgreSQL)
-- 권위 스키마: docs/huni/table-spec_260619.html (36테이블/374컬럼·2026-06-17)
-- 생성: 2026-07-01 · 위젯 정규화 계약(04_build/src/contract/*) 충족용
-- =====================================================================
-- [HARD] 제안 DDL — 실 적용은 §7 dbmap 인간 승인 후. 여기서는 CREATE/ALTER 정의까지.
-- search-before-mint: 기존 36테이블/374컬럼으로 표현 가능하면 신규 금지. 아래는 전수 확인 후 진짜 갭만.
-- 컨벤션: snake_case·varchar(50) 코드키·char(1) YN·timestamp _dt·reg_dt/upd_dt 감사·del_yn 논리삭제.
-- 추가 컬럼은 전부 NULLABLE(백필 무중단)·기본 동작 불변(미설정=기존 행동).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. 자재 표시 메타 (colorHex / imageUrl / badge)  → OptionValue.{colorHex,imageUrl,badge}
--    사유: t_mat_materials에 색상hex·이미지url·배지 컬럼 없음(전수 확인). color-chip/image-chip
--          componentType 렌더에 필요. options.tags(jsonb)는 표준 enum 부재라 badge 신뢰 불가.
--    search-before-mint: t_mat_materials(17컬럼)·t_prd_product_materials(8컬럼)에 표시 메타 부재 확인.
--    대안 검토: tags jsonb에 욱여넣기 → enum 미강제·위젯 신뢰 불가 → 전용 컬럼 채택.
-- ---------------------------------------------------------------------
ALTER TABLE t_mat_materials
  ADD COLUMN IF NOT EXISTS color_hex   varchar(7)   NULL,  -- 색상칩 hex (#RRGGBB). color-chip 렌더용. 색지·특수자재만.
  ADD COLUMN IF NOT EXISTS image_url   varchar(500) NULL,  -- 미리보기 이미지 URL. image-chip 렌더용.
  ADD COLUMN IF NOT EXISTS add_clr_yn  char(1)      NULL;  -- 추가색(별색/형광) 가용여부 Y/N. OptionValue.addColorCapable.
COMMENT ON COLUMN t_mat_materials.color_hex  IS '2026-07-01 위젯 추가 — color-chip 색상hex(#RRGGBB)';
COMMENT ON COLUMN t_mat_materials.image_url  IS '2026-07-01 위젯 추가 — image-chip 미리보기 URL';
COMMENT ON COLUMN t_mat_materials.add_clr_yn IS '2026-07-01 위젯 추가 — 추가색 가용여부(addColorCapable)';

-- ---------------------------------------------------------------------
-- 2. 옵션 배지 (recommend/best/new/up)  → OptionValue.badge
--    사유: t_prd_product_options.tags(jsonb)에 비표준 태그만. 위젯 badge는 4값 enum 필요.
--    search-before-mint: 옵션/자재 어디에도 표준 배지 컬럼 부재 확인. 상품별 옵션 단위라 product_options에.
-- ---------------------------------------------------------------------
ALTER TABLE t_prd_product_options
  ADD COLUMN IF NOT EXISTS badge_cd varchar(50) NULL  -- FK → t_cod_base_codes(BADGE_TYPE). recommend/best/new/up.
    REFERENCES t_cod_base_codes(cod_cd);
COMMENT ON COLUMN t_prd_product_options.badge_cd IS '2026-07-01 위젯 추가 — OptionValue.badge(BADGE_TYPE)';

-- 배지 기초코드(BADGE_TYPE) 등록 — t_cod_base_codes 관례(계층 루트 + 자식)
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt, note)
VALUES
  ('BADGE_TYPE',     '옵션배지유형', NULL,         900, 'Y', 'N', now(), '2026-07-01 위젯 추가'),
  ('BADGE_TYPE.01',  'recommend',    'BADGE_TYPE',   1, 'Y', 'N', now(), '2026-07-01 위젯 추가 — 추천'),
  ('BADGE_TYPE.02',  'best',         'BADGE_TYPE',   2, 'Y', 'N', now(), '2026-07-01 위젯 추가 — 베스트'),
  ('BADGE_TYPE.03',  'new',          'BADGE_TYPE',   3, 'Y', 'N', now(), '2026-07-01 위젯 추가 — 신규'),
  ('BADGE_TYPE.04',  'up',           'BADGE_TYPE',   4, 'Y', 'N', now(), '2026-07-01 위젯 추가 — 인기상승')
ON CONFLICT (cod_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- 3. 에디터 파트너 분기 (editor_partner_cd)  → NormalizedEditorConfig 발급 라우팅
--    사유: t_prd_products.editor_yn(char1 boolean)만 있고 어느 에디터(Edicus 등)인지·psCode 라우팅 불가.
--    search-before-mint: products 24컬럼에 partner/psCode 없음 확인. psCode/templateUrl/token은 BFF 런타임
--          발급이라 DB 비보관(보안) — partner 분기만 DB에 둔다.
-- ---------------------------------------------------------------------
ALTER TABLE t_prd_products
  ADD COLUMN IF NOT EXISTS editor_partner_cd varchar(50) NULL  -- FK → t_cod_base_codes(EDITOR_PARTNER). edicus/none.
    REFERENCES t_cod_base_codes(cod_cd);
COMMENT ON COLUMN t_prd_products.editor_partner_cd IS '2026-07-01 위젯 추가 — 에디터 파트너 분기(EDITOR_PARTNER)';

INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt, note)
VALUES
  ('EDITOR_PARTNER',     '에디터파트너', NULL,           910, 'Y', 'N', now(), '2026-07-01 위젯 추가'),
  ('EDITOR_PARTNER.01',  'edicus',       'EDITOR_PARTNER', 1, 'Y', 'N', now(), '2026-07-01 위젯 추가 — Edicus(KOI)'),
  ('EDITOR_PARTNER.99',  'none',         'EDITOR_PARTNER', 9, 'Y', 'N', now(), '2026-07-01 위젯 추가 — 에디터 없음')
ON CONFLICT (cod_cd) DO NOTHING;

-- ---------------------------------------------------------------------
-- 4. 공정 표시여부 (view_yn)  → OptionGroup.visible / hidden-essential 분류
--    사유: t_prd_product_processes에 mand_proc_yn(required)만 있고 visible 없음. 현재 disp_seq 음수(-1)
--          관례로 hidden-essential(예 PROC_000004 인쇄 base)을 우회 도출 — 명시 컬럼이 안전.
--    search-before-mint: processes 8컬럼에 view/visible 컬럼 부재 확인.
--    대안: disp_seq<0 관례 유지(어댑터 흡수) — 가능하나 명시성 위해 컬럼 권고(NULL=disp_seq 관례 fallback).
-- ---------------------------------------------------------------------
ALTER TABLE t_prd_product_processes
  ADD COLUMN IF NOT EXISTS view_yn char(1) NULL;  -- 위젯 표시여부 Y/N. NULL=disp_seq<0 관례 fallback. N=hidden-essential.
COMMENT ON COLUMN t_prd_product_processes.view_yn IS '2026-07-01 위젯 추가 — OptionGroup.visible(hidden-essential 명시)';

-- =====================================================================
-- 적용 순서(FK 위상): ① BADGE_TYPE/EDITOR_PARTNER 기초코드 INSERT(2·3의 INSERT 블록)
--   → ② ALTER ADD COLUMN(1·2·3·4) → ③ 백필(전부 NULL 허용·미백필=기존 동작) → ④ §7 검증.
-- 멱등: ADD COLUMN IF NOT EXISTS · INSERT ON CONFLICT DO NOTHING.
-- 비파괴: 신규 컬럼 전부 NULLABLE·기존 행 영향 0·기존 evaluate_price/위젯 동작 불변.
-- =====================================================================
