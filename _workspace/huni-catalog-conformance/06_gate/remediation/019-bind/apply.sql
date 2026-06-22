-- apply.sql — 019(투명엽서) 가격 차단 해소 묶음 교정 (A5-plate + A2-bind · 단일 트랜잭션·DRY-RUN 기본)
-- 교정 묶음 (remediation-spec §S 클래스 A · 사용자 판형 정답 확정 2026-06-22):
--   STEP 1 A5-plate : PRD_000019 출력판형 SIZ_000522(315x467 오적재) → SIZ_000499(316x467 권위).
--   STEP 2 A2-bind  : PRD_000019 ↔ PRF_DGP_A 상품별 바인딩 행 1건.
-- 두 STEP 묶여야 019 가 0원 차단 해소 + 단가 환원(정상 견적)까지 도달.
--
-- [HARD] 공유 마스터 무수정: t_siz_sizes(SIZ_000499/522)·t_prc_price_formulas·formula_components·
--        price_components·component_prices 미접근. 상품별 t_prd_product_* 만 수정.
-- [HARD] NEVER COMMIT. apply.sh 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 사용자 최종 승인(--commit) 후.
--
-- ── search-before-mint 근거(라이브 read-only 실측 2026-06-22) ──────────────────────────
--  STEP1(plate):
--   · SIZ_000499 마스터 실재(316x467·use_yn=Y·del_yn=N) → FK 타깃 충족·신규 mint 0.
--   · 019 현재 출력판형 행 = SIZ_000522(otyp=OUTPUT_PAPER_TYPE.01·dflt_plt_yn=Y) 1건 실재.
--   · 019 에 SIZ_000499 행 부재(has_499=0) → siz_cd UPDATE 시 PK(prd_cd,siz_cd) 충돌 없음.
--   · t_prd_product_plate_sizes 를 참조하는 자식 FK 0건 → 행 키 변경 안전(cascade 없음).
--   · 연산 = 멱등 UPDATE(DELETE+INSERT 불요): 행 속성(dflt_plt_yn 등) 보존·자식 FK 0이라 위험 0.
--     WHERE siz_cd='SIZ_000522' 가드 → 이미 정정 시 0행(멱등). SIZ_000522 마스터 자체 무수정.
--  STEP2(bind):
--   · PRD_000019 실재(del_yn=N·use_yn=Y)·PRF_DGP_A 실재(use_yn=Y·formula_components 10행).
--   · 019 바인딩 행 0건 → INSERT 대상. 충돌키 PK(prd_cd,apply_bgn_ymd). 신규 mint 0.
--   · 정정된 plate SIZ_000499 에 PRF_DGP_A 단가행 실재(COMP_PRINT 106 tier·COMP_PAPER 56행) → 환원 성립.
-- ─────────────────────────────────────────────────────────────────────────────────────
-- 출처(provenance): remediation-spec §S(A2-bind·A5-plate) / DEF-PE-01 / e2e 추적1·추적3 /
--   사용자 판형 확정(316x467=권위·315x467=완성품혼입 오적재) / 형제 016~018 바인딩·plate 컨벤션.

-- STEP 1 — A5-plate: 출력판형 정정 (SIZ_000522 → SIZ_000499). 멱등 UPDATE.
UPDATE t_prd_product_plate_sizes
   SET siz_cd     = 'SIZ_000499',
       output_paper_typ_cd = 'OUTPUT_PAPER_TYPE.01',   -- 형제 018 정합(국전계열·기존값 유지)
       upd_dt     = now()
 WHERE prd_cd = 'PRD_000019'
   AND siz_cd = 'SIZ_000522'
   AND NOT EXISTS (   -- 멱등 가드: 이미 SIZ_000499 행이 있으면 UPDATE 안 함(PK 충돌 방지)
       SELECT 1 FROM t_prd_product_plate_sizes x
        WHERE x.prd_cd='PRD_000019' AND x.siz_cd='SIZ_000499');

-- STEP 2 — A2-bind: 가격공식 바인딩 (멱등 UPSERT). 충돌키 PK(prd_cd, apply_bgn_ymd).
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000019', 'PRF_DGP_A', '2026-06-01', '투명엽서 → PRF_DGP_A')
ON CONFLICT (prd_cd, apply_bgn_ymd) DO NOTHING;
