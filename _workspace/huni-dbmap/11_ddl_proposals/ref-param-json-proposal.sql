-- ============================================================================
-- DDL 제안: t_prd_product_option_items.ref_param_json (GAP-PARAM 해소)
-- ----------------------------------------------------------------------------
-- 상태   : PROPOSAL ONLY — propose != apply. 라이브 적용은 인간 승인.
-- 권위   : cpq-schema.md §4 🔴8 · cpq-option-gaps.md GAP-PARAM/GAP-COUNT
--          · 라이브 read-only 실측(2026-06-07): option_items=0행, ref_param_json 부재,
--            prcs_dtl_opt(jsonb) 파라미터 스키마 실재(PROC_000029 줄수 등).
-- 사다리 : 3단계(JSONB 컬럼). 1(코드행)·2(qty/정수컬럼) 무손실 실패 입증 → .md §2.
-- 영향   : option_items 0행 → ADD COLUMN(NULL) 무잠금·백필 0. 트리거 미참조. 인덱스 불요.
-- ============================================================================

-- ▼▼▼ FORWARD (인간 승인 후 단일 ALTER) ▼▼▼

ALTER TABLE t_prd_product_option_items
  ADD COLUMN IF NOT EXISTS ref_param_json jsonb NULL;

COMMENT ON COLUMN t_prd_product_option_items.ref_param_json IS
  '공정 파라미터 선택값(t_proc_processes.prcs_dtl_opt 스키마의 인스턴스). '
  '키 = prcs_dtl_opt.inputs[].key. NULL = 파라미터 없는 옵션(사이즈/자재/도수 등 단순 참조). '
  'qty(수량)와 의미 분리 — 구수/줄수/개수를 qty에 smear 금지.';

-- 값 shape 예시(참고 — 적재는 round-6 option-layer 트랙):
--   타공 구수      : {"구수": 6}
--   오시/미싱 줄수 : {"줄수": 2}          (PROC_000029/030, min0 max3)
--   가변 개수      : {"개수": 3}          (PROC_000031/032)
--   코팅 면        : {"면": "양면"}        (PROC_000014/015/016 enum)
--   박 크기        : {"크기": 25}          (mm — 박등급은 앱 계산)
--   조각수         : {"조각수": 4}
--   구수(굿즈)     : {"구수": 2}          (GAP-COUNT 통합)
--   제본 다축      : {"방향":"좌철","책등":12,"고리형":true}  (qty 1칸 불가)

-- ▲▲▲ FORWARD END ▲▲▲


-- ▼▼▼ ROLLBACK (되돌림 — option_items 0행이라 데이터 손실 0) ▼▼▼
--
--   ALTER TABLE t_prd_product_option_items DROP COLUMN IF EXISTS ref_param_json;
--
-- ▲▲▲ ROLLBACK END ▲▲▲


-- ----------------------------------------------------------------------------
-- 검증 쿼리(적용 후, read-only):
--   SELECT column_name, data_type, is_nullable
--   FROM information_schema.columns
--   WHERE table_name='t_prd_product_option_items' AND column_name='ref_param_json';
--   -- 기대: ref_param_json | jsonb | YES
-- ----------------------------------------------------------------------------
