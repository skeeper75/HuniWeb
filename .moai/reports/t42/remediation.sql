-- t42 사이즈 마스터 교정 명세 — 롤백 전용 DRY-RUN
-- ============================================================================
-- [HARD] 이 파일은 스스로 ROLLBACK 한다. COMMIT 문구는 어디에도 없다.
--        실 적용은 지니 승인 후 별건 카드(적재 트랙)에서 COMMIT 판으로 다시 만든다.
-- [HARD] 코드 물리삭제(DELETE FROM t_siz_sizes) 없음 — 논리삭제(use_yn='N')만 쓴다.
-- 근거: size_master_audit.md §3 A~F · §5 우선순위표
-- 실행: python3 -c "import sys; sys.path.insert(0,'.moai/reports/t42'); \
--        import dbq; print(dbq.run_file('.moai/reports/t42/remediation.sql')[1])"
-- ============================================================================

BEGIN;

\echo '=== [BEFORE] 대상 코드 마스터 ==='
SELECT siz_cd, siz_nm, work_width, work_height, cut_width, cut_height,
       margin_lft, impos_yn, use_yn
  FROM t_siz_sizes
 WHERE siz_cd IN ('SIZ_000064','SIZ_000172','SIZ_000514','SIZ_000515',
                  'SIZ_000518','SIZ_000538','SIZ_000539','SIZ_000541')
 ORDER BY siz_cd;

\echo '=== [BEFORE] PRD_000286 판수 (A4 가 B5 보다 적으면 결함) ==='
SELECT ps.siz_cd, s.siz_nm, s.work_width, s.work_height,
       fn_calc_pansu('SIZ_000499', ps.siz_cd) AS pansu
  FROM t_prd_product_sizes ps
  JOIN t_siz_sizes s ON s.siz_cd = ps.siz_cd
 WHERE ps.prd_cd = 'PRD_000286' AND ps.del_yn = 'N'
 ORDER BY ps.disp_seq;

\echo '=== [BEFORE] PRD_000055/056 살아있는 사이즈 (권위 5 중 몇 개인가) ==='
SELECT prd_cd, count(*) AS live_sizes
  FROM t_prd_product_sizes
 WHERE prd_cd IN ('PRD_000055','PRD_000056') AND del_yn = 'N'
 GROUP BY prd_cd ORDER BY prd_cd;


-- ─────────────────────────────────────────────────────────────────────────
-- 1. §A PRD_000286 하드커버 링책자-내지 A4 재배선  🔴 라이브 과다청구 2배
--    SIZ_000172(290x377 · 1판) → SIZ_000258(210x297 · 2판)
--    PK 가 (prd_cd, siz_cd) 라 siz_cd 를 UPDATE 하지 않고 논리삭제 + 신규행으로 간다.
--    (기존 행을 살려두면 나중에 되돌리기 쉽다)
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_prd_product_sizes
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE prd_cd = 'PRD_000286' AND siz_cd = 'SIZ_000172' AND del_yn = 'N';

INSERT INTO t_prd_product_sizes
       (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
VALUES ('PRD_000286', 'SIZ_000258', 'N', 3, now(), 'N')
    ON CONFLICT (prd_cd, siz_cd)
    DO UPDATE SET del_yn = 'N', del_dt = NULL, disp_seq = EXCLUDED.disp_seq,
                  upd_dt = now();


-- ─────────────────────────────────────────────────────────────────────────
-- 2. §D SIZ_000518(100x148) 치수 채움  🟠 매출 누락 해소의 선행 단계
--    권위: 스티커 시트 r4 「A6(8판)/100*148(8판)」 · note 「판걸이=8.0 / 적용=반칼스티커」
--    검증: 317x440 여백10 → 297x410 영역에서 회전배치 2×4 = 8판
--    ⚠ SIZ_000519(90x110) 는 판걸이 12 가 어떤 등록 판형으로도 재현되지 않아
--      여기서 채우지 않는다(audit §6 Gap 1). 추측 금지.
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_siz_sizes
   SET work_width = 100, work_height = 148,
       cut_width  = 100, cut_height  = 148,
       margin_top = 0, margin_bot = 0, margin_lft = 0, margin_rgt = 0,
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000518';


-- ─────────────────────────────────────────────────────────────────────────
-- 3. §E B3·B4 치수 채움 + 낱장완칼 2상품 사이즈 복구  🟠 미노출 매출
--    권위: 스티커 시트 r50/r63 사이즈축 = A4·B4·A3·B3·A2 (5)
--    완칼은 「국4절에 인쇄하는 것이 아니기 때문에 판걸이수 상관없음」(r47·r60)이라
--    판수는 안 쓰지만, NULL 을 남기면 나중에 판형이 붙는 순간 fail-closed 로 막힌다.
--    ⚠ 되살릴지는 영업 판단 — 단종 여부 실무진 확인 후 적용할 것.
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_siz_sizes
   SET work_width = 364, work_height = 515,
       margin_top = 0, margin_bot = 0, margin_lft = 0, margin_rgt = 0,
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000514';

UPDATE t_siz_sizes
   SET work_width = 257, work_height = 364,
       margin_top = 0, margin_bot = 0, margin_lft = 0, margin_rgt = 0,
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000515';

UPDATE t_prd_product_sizes
   SET del_yn = 'N', del_dt = NULL, upd_dt = now()
 WHERE prd_cd IN ('PRD_000055','PRD_000056')
   AND siz_cd IN ('SIZ_000514','SIZ_000515')
   AND del_yn = 'Y';


-- ─────────────────────────────────────────────────────────────────────────
-- 4. §C 330x470 중복 정리 — 정본 SIZ_000521 만 남긴다  🟡 blast radius 0
--    SIZ_000539 · SIZ_000541 은 16개 참조 표면 전부 0건(refs.csv 확인)
--    물리삭제 금지 원칙대로 use_yn='N' 만 내린다(del_yn 은 손대지 않는다).
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_siz_sizes
   SET use_yn = 'N', upd_dt = now()
 WHERE siz_cd IN ('SIZ_000539','SIZ_000541') AND use_yn = 'Y';


-- ─────────────────────────────────────────────────────────────────────────
-- 5·6. §B·§A 이름 교정  🟢 값은 안 건드린다 · 오인 방지
--    SIZ_000036/SIZ_000064 는 중복이 아니라 인쇄배경지 기본형/커팅형이다(권위 r41/r42).
--    SIZ_000172 는 A4 가 아니라 레더아트액자 작업치수 290x377 이다.
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_siz_sizes SET siz_nm = '94x94mm-기본형', upd_dt = now()
 WHERE siz_cd = 'SIZ_000036';

UPDATE t_siz_sizes SET siz_nm = '94x94mm-커팅형', upd_dt = now()
 WHERE siz_cd = 'SIZ_000064';

UPDATE t_siz_sizes SET siz_nm = '레더아트액자 A4 (작업 290x377)', upd_dt = now()
 WHERE siz_cd = 'SIZ_000172';


-- ─────────────────────────────────────────────────────────────────────────
-- 7. §F SIZ_000538 치수 채움 — 소형반칼 판형 307x430  🟢 mint 불필요
--    권위: 판걸이수 r84~r93 「307x430 · 사방 10mm 제외」 — 여백 10 은 이미 등록돼 있다.
--    참조 전 표면 0건이라 채워도 아무것도 안 깨진다.
--    PRD_000064 게시의 선행 인프라. 상품 재배선은 별건(audit §4.4 · 미결 입력 있음).
-- ─────────────────────────────────────────────────────────────────────────
UPDATE t_siz_sizes
   SET work_width = 307, work_height = 430,
       cut_width  = 287, cut_height  = 410,
       impos_yn = 'Y',
       note = '소형반칼스티커 판형 / 출처: 가격표260903 판걸이수 r84~r93 (사방 10mm 제외)',
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000538';


-- ============================================================================
-- 사후 검증 — 이 값들이 기대와 다르면 COMMIT 판을 만들지 않는다
-- ============================================================================

\echo '=== [AFTER] 대상 코드 마스터 ==='
SELECT siz_cd, siz_nm, work_width, work_height, cut_width, cut_height,
       margin_lft, impos_yn, use_yn
  FROM t_siz_sizes
 WHERE siz_cd IN ('SIZ_000036','SIZ_000064','SIZ_000172','SIZ_000514','SIZ_000515',
                  'SIZ_000518','SIZ_000538','SIZ_000539','SIZ_000541')
 ORDER BY siz_cd;

\echo '=== [AFTER] PRD_000286 판수 — A4 가 2판이어야 한다 ==='
SELECT ps.siz_cd, s.siz_nm, s.work_width, s.work_height,
       fn_calc_pansu('SIZ_000499', ps.siz_cd) AS pansu
  FROM t_prd_product_sizes ps
  JOIN t_siz_sizes s ON s.siz_cd = ps.siz_cd
 WHERE ps.prd_cd = 'PRD_000286' AND ps.del_yn = 'N'
 ORDER BY ps.disp_seq;

\echo '=== [AFTER] SIZ_000518 판수 — 반칼 판형 317x440 에서 8판이어야 한다 ==='
SELECT fn_calc_pansu('SIZ_000498','SIZ_000518') AS pansu_100x148_expect_8;

\echo '=== [AFTER] SIZ_000538(307x430) 판수 — 권위 10사이즈 전건 대조 ==='
SELECT v.nm, v.expect, fn_calc_pansu('SIZ_000538', v.siz_cd) AS actual,
       CASE WHEN v.expect = fn_calc_pansu('SIZ_000538', v.siz_cd)
            THEN 'OK' ELSE 'MISMATCH' END AS verdict
  FROM (VALUES
        ('80x80 (SIZ_000508 여분0)', 15, 'SIZ_000508'),
        ('94x94 여분2 (SIZ_000036)', 12, 'SIZ_000036'),
        ('94x94 여분5 (SIZ_000064)',  8, 'SIZ_000064')
       ) AS v(nm, expect, siz_cd);
-- ⚠ 위 3행 중 SIZ_000036·SIZ_000064 는 MISMATCH 가 정상이다 —
--   여분이 붙은 인쇄배경지 계열 코드라 소형반칼 권위 판수가 나오지 않는다(audit §4.3).
--   권위 7사이즈용 여분0 코드는 아직 없다(§4.4 2단계 · 6건 신규 등록 필요).

\echo '=== [AFTER] PRD_000055/056 살아있는 사이즈 — 각 5 가 되어야 한다 ==='
SELECT prd_cd, count(*) AS live_sizes
  FROM t_prd_product_sizes
 WHERE prd_cd IN ('PRD_000055','PRD_000056') AND del_yn = 'N'
 GROUP BY prd_cd ORDER BY prd_cd;

\echo '=== [AFTER] 고아 단가 잔량 — 518 이 0 이 되었나 (519 는 Gap 이라 남는다) ==='
SELECT p.siz_cd, count(*) AS orphan_price_rows
  FROM t_prc_component_prices p
 WHERE p.siz_cd IN ('SIZ_000514','SIZ_000515','SIZ_000518','SIZ_000519')
   AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes ps
                    WHERE ps.siz_cd = p.siz_cd AND ps.del_yn = 'N')
 GROUP BY p.siz_cd ORDER BY p.siz_cd;
-- ⚠ SIZ_000518 은 이 DRY-RUN 에서 상품 연결을 하지 않았으므로 여전히 648 로 남는다.
--   「어느 반칼 상품에 붙이나」가 미결(audit §6 Gap 2)이라 추측으로 연결하지 않았다.

ROLLBACK;

\echo '=== ROLLBACK 완료 — 라이브는 그대로다 ==='
