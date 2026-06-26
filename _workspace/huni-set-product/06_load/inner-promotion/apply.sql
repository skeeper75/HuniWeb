-- ============================================================================
-- [제안·미실행] 072 하드커버책자 내지 반제품 승격 — 구조변경 멱등 적재
-- 생성: dbm-load-builder · 2026-06-25 · DB 미적재(인간 승인 후 dbmap/hsp-load-executor)
-- ★보정 2026-06-25(검증 게이트 + codex 차단 3건 반영):
--   [차단1 CFM-INNER-A5-DEL] 내지 sizes = 정본 active SIZ_000007(A5)·SIZ_000050(A4)로 교체
--        (삭제 SIZ_000170 copy 금지·가격영향0·inner-size-authority.md §3·§4)
--   [차단2 CFM-CHAEBEON-RACE] advisory lock + 284 exact-match abort + MAX재assert + 의미가드
--   [차단3 CFM-INNER-DBLPANSU] PRF 트랙 선결(그릇 단계 무관) — design.md §3.5 핸드오프 가드 명문
--   [codex#7] disp_seq +1 → CASE 목표값 대입(부분실패 비멱등 해소)
-- CFM-INNER-TOTSHEET 해소 그릇: 내지=SEMI_ROLE.01 별 구성원(자기 dims)으로 승격
-- 멱등: 전 INSERT = WHERE NOT EXISTS(자연키) · ON CONFLICT 미사용(NULLS DISTINCT 함정 회피)
-- FK 위상순서: ① products(PRD_000284) → ② dims(284 참조) → ③ sets(072←284)
-- search-before-mint: 신규 자재/siz/단가행 0 · 전부 기존 마스터 코드의 새 연결
-- ★PRF 민팅(PRF_HC_INNER/BODY·S2 부활·표지펼침siz)은 본 파일 범위 밖(set-product 트랙)
--   ※[차단3] 내지 PRF 는 derive_inner_sheets 가 이미 ÷pansu 한 qty 를 받으므로 plt_siz_cd
--     기반 comp(S2/COMP_PAPER) plate_qty 재환산을 피해야 함(이중 ÷pansu). design.md §3.5 가드.
-- 실 실행 시: backup.sql 선행 → BEGIN → 본 파일 → 검증 → 인간 승인 COMMIT (기본 ROLLBACK)
-- ★단일 트랜잭션 필수(부분커밋 시 disp_seq 재배열 비멱등) — apply.sql 은 BEGIN..COMMIT 내부서만.
-- ============================================================================

-- ─── [차단2 CFM-CHAEBEON-RACE] 채번 직렬화 + 오염 abort 가드 ─────────────────
-- 트랜잭션 단위 advisory lock(채번 동시성 직렬화·COMMIT/ROLLBACK 시 자동 해제)
SELECT pg_advisory_xact_lock(hashtext('inner-promotion-prd-chaebeon'));

DO $chaebeon$
DECLARE
  v_max   text;
  v_max_n int;
  v_exist int;
  v_is_inner int;
BEGIN
  -- (1) MAX(prd_cd) 재assert
  SELECT MAX(prd_cd) INTO v_max FROM t_prd_products
   WHERE prd_cd LIKE 'PRD_%' AND prd_cd ~ '^PRD_[0-9]+$';
  v_max_n := CAST(SUBSTRING(v_max FROM 5) AS INT);

  -- (2) PRD_000284 이미 존재? → 그게 "우리 내지"인지 exact-match
  SELECT count(*) INTO v_exist FROM t_prd_products WHERE prd_cd='PRD_000284';
  IF v_exist > 0 THEN
    SELECT count(*) INTO v_is_inner FROM t_prd_products
      WHERE prd_cd='PRD_000284'
        AND prd_typ_cd='PRD_TYPE.02'
        AND semi_role_cd='SEMI_ROLE.01'
        AND prd_nm LIKE '하드커버책자-내지%';
    IF v_is_inner = 0 THEN
      RAISE EXCEPTION 'ABORT CFM-CHAEBEON-RACE: PRD_000284 가 우리 내지가 아닌 다른 상품으로 선점됨 (재채번 필요·MAX=%)', v_max;
    END IF;
    -- 우리 내지 기존재 = 멱등 재실행(아래 NOT EXISTS 전부 no-op) → 정상 진행
  ELSE
    -- 284 미존재 시: MAX 가 283 이 아니면 채번 가정 깨짐 → ABORT
    IF v_max_n <> 283 THEN
      RAISE EXCEPTION 'ABORT CFM-CHAEBEON-RACE: MAX(prd_cd)=% (기대 PRD_000283) — 284 하드코딩 채번 무효·재채번 필요', v_max;
    END IF;
  END IF;
END
$chaebeon$;

-- ─── 위상 ① t_prd_products : 신규 내지 반제품 PRD_000284 ───────────────────
INSERT INTO t_prd_products
  (prd_cd, "MES_ITEM_CD", prd_nm, prd_typ_cd, semi_role_cd,
   nonspec_yn, file_upload_yn, editor_yn,
   min_qty, max_qty, qty_incr, dflt_qty, qty_unit_typ_cd,
   use_yn, reg_dt, del_yn)
SELECT
  'PRD_000284', NULL, '하드커버책자-내지(별도설정)', 'PRD_TYPE.02', 'SEMI_ROLE.01',
  'N', 'N', 'N',
  NULL, NULL, NULL, NULL, NULL,
  'Y', now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_products WHERE prd_cd = 'PRD_000284');

-- ─── [차단2 추가 가드] 후속 dims/sets 부착 전 "284 = 우리 내지" 의미 재확인 ───
DO $inner_guard$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM t_prd_products
     WHERE prd_cd='PRD_000284'
       AND prd_typ_cd='PRD_TYPE.02'
       AND semi_role_cd='SEMI_ROLE.01'
       AND prd_nm LIKE '하드커버책자-내지%'
  ) THEN
    RAISE EXCEPTION 'ABORT: PRD_000284 가 우리 내지 반제품이 아님 — dims/sets 오부착 방지';
  END IF;
END
$inner_guard$;

-- ─── 위상 ② dims (PRD_000284 참조) ──────────────────────────────────────────

-- (B-1) sizes : ★[차단1] 정본 active SIZ_000007(A5)·SIZ_000050(A4)
--        삭제 SIZ_000170(A5) copy 금지 → del_yn=N 정본 twin 사용(가격영향0·국4절 절가 기준)
--        SIZ_000007=A5(148X210·del N·작업150x212≈마스터150x214)·SIZ_000050=A4(210X297·del N·note"책자내지")
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', v.siz_cd, v.dflt_yn, v.disp_seq, now(), 'N'
FROM (VALUES ('SIZ_000007','Y',1), ('SIZ_000050','N',2)) AS v(siz_cd, dflt_yn, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_sizes s
  WHERE s.prd_cd='PRD_000284' AND s.siz_cd=v.siz_cd);

-- (B-2) print_options : 단면(POPT_000001·dflt)·양면(POPT_000002)
--        ★[D1 정직성] 본체는 둘 다 dflt=Y/seq=1(중복디폴트 데이터이상). 본 등록은 정규화 copy
--        (값 보존·dflt 단일화 단면/seq 명확) — 무손실 정규화(라이브 중복디폴트 미전파)
INSERT INTO t_prd_product_print_options
  (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, print_opt_cd, reg_dt, del_yn)
SELECT 'PRD_000284', v.opt_id, v.print_side, v.front_cc, v.back_cc, v.dflt_yn, v.disp_seq, v.popt, now(), 'N'
FROM (VALUES
  (1,'단면','CLR_000005','CLR_000001','Y',1,'POPT_000001'),
  (2,'양면','CLR_000005','CLR_000005','N',2,'POPT_000002')
) AS v(opt_id, print_side, front_cc, back_cc, dflt_yn, disp_seq, popt)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_print_options p
  WHERE p.prd_cd='PRD_000284' AND p.opt_id=v.opt_id);

-- (B-3) page_rules : 24~300/+2  ← 본체 copy (PK=prd_cd → 1행)
INSERT INTO t_prd_product_page_rules (prd_cd, page_min, page_max, page_incr, note, reg_dt)
SELECT 'PRD_000284', 24, 300, 2, '내지 페이지룰(하드커버무선·072 동형)', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_page_rules WHERE prd_cd='PRD_000284');

-- (B-4) materials USAGE.01 내지종이 7종  ← 069 무선책자 set (CFM-INNER-PAPER 해소·자재 재사용)
--        ※069=provisional authority(072 직접 7종목록 미명시·codex#8) — 운영 UI 별도 승인 게이트
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', v.mat_cd, 'USAGE.01', v.dflt_yn, v.disp_seq, now(), 'N'
FROM (VALUES
  ('MAT_000073','Y',1),  -- 백색모조지 120g (dflt·069 dflt 동일)
  ('MAT_000077','N',2),  -- 아트지 120g
  ('MAT_000087','N',3),  -- 스노우지 120g
  ('MAT_000095','N',4),  -- 앙상블 100g
  ('MAT_000096','N',5),  -- 앙상블 130g
  ('MAT_000104','N',6),  -- 몽블랑 100g
  ('MAT_000105','N',7)   -- 몽블랑 130g
) AS v(mat_cd, dflt_yn, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials m
  WHERE m.prd_cd='PRD_000284' AND m.mat_cd=v.mat_cd AND m.usage_cd='USAGE.01');

-- (B-5) plate_sizes : 국4절 SIZ_000499 (CFM-INNER-PLATE 해소·S1/S2 단가행 매칭 판형)
--        ※[D3] 뷰 plate_options 는 셋트완제품(072) plate 에서 옴 — 내지 plate 추가만으론 뷰
--          드롭다운 미반영. 가격엔진은 selections.plt_siz_cd 로 동작(set-product 트랙 명시 주입).
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, reg_dt, del_yn)
SELECT 'PRD_000284', 'SIZ_000499', 'Y', NULL, now(), 'N'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_plate_sizes pp
  WHERE pp.prd_cd='PRD_000284' AND pp.siz_cd='SIZ_000499');

-- ─── 위상 ③ sets : 072 ← PRD_000284 (내지·inner-first) + 기존 disp_seq 재배열 ───

-- (C-pre) ★[codex#7] disp_seq = CASE 목표값 대입 (부분실패 비멱등 해소·+1 누적증가 방지)
--   현상태 정확 매칭({073:1,074:2,075:3,076:4}) + 내지 미존재 시에만 발동.
--   목표값 대입이라 N회 실행해도 동일 결과(멱등)·부분커밋 후 재실행도 안전.
UPDATE t_prd_product_sets s
   SET disp_seq = CASE s.sub_prd_cd
                    WHEN 'PRD_000073' THEN 2
                    WHEN 'PRD_000074' THEN 3
                    WHEN 'PRD_000075' THEN 4
                    WHEN 'PRD_000076' THEN 5
                  END,
       upd_dt = now()
 WHERE s.prd_cd = 'PRD_000072'
   AND s.sub_prd_cd IN ('PRD_000073','PRD_000074','PRD_000075','PRD_000076')
   AND s.disp_seq <> CASE s.sub_prd_cd       -- 멱등: 이미 목표값이면 미발동(no-op)
                       WHEN 'PRD_000073' THEN 2
                       WHEN 'PRD_000074' THEN 3
                       WHEN 'PRD_000075' THEN 4
                       WHEN 'PRD_000076' THEN 5
                     END;

-- (C) 내지 sets 행
INSERT INTO t_prd_product_sets
  (prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, note, min_cnt, max_cnt, cnt_incr, reg_dt, del_yn)
SELECT
  'PRD_000072', 'PRD_000284', 1, 1,
  '내지=별도설정·페이지24~300/+2·총내지매수 derived(부수×ceil(pages/pansu))',
  24, 300, 2, now(), 'N'
WHERE EXISTS (SELECT 1 FROM t_prd_products WHERE prd_cd='PRD_000284')   -- FK 선존 가드
  AND NOT EXISTS (
    SELECT 1 FROM t_prd_product_sets
    WHERE prd_cd='PRD_000072' AND sub_prd_cd='PRD_000284');
