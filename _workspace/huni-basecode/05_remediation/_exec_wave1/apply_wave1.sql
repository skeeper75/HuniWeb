-- ============================================================================
-- apply_wave1.sql — 후니 기초코드 거버넌스 Wave 1 교정 (멱등 적재 SQL)
-- ----------------------------------------------------------------------------
-- 권위 입력: 05_remediation/{remediation-roadmap.md(R1~R6 Wave 1)·_approval-queue.md}
--           03_registration/regspec-{size,category,process,material}.md
--           price-chain-impact.md (가격사슬 0참조 실측 근거)
-- 측정일/대상: 2026-06-18 · Railway `railway` DB · t_* 화이트리스트 내
--
-- [HARD] 본 파일은 INSERT 없음 — 전부 기존 행 in-place 교정(UPDATE).
--        멱등성 = ON CONFLICT 아니라 WHERE 가드(이미 교정값이면 0행 = no-op).
--        del_yn='Y' 소프트삭제는 WHERE del_yn='N' 가드(이미 'Y'면 skip).
--        모든 변경은 t_* 도메인 내(G1). 가격사슬(t_prc_*) 무접촉.
-- [HARD] 본 파일 자체에 BEGIN/COMMIT/ROLLBACK 없음 — 로더(apply_wave1.sh)가
--        BEGIN…ROLLBACK(기본 DRY-RUN)을 주입. 중간 COMMIT 금지(R2 원자성).
-- [HARD] 실 COMMIT 0 — DRY-RUN BEGIN..ROLLBACK까지만. 라이브 쓰기는 ROLLBACK으로
--        되돌리는 dry-run만. 실 COMMIT은 인간 최종 승인 대기.
-- ----------------------------------------------------------------------------
-- 경로 혼합 [HARD]: del_yn='Y' 소프트삭제(R2/R4 + R6 봉투)는 라이브 직접=임시책.
--   load_master TRUNCATE CASCADE 재적재 시 del_yn 미명시→DEFAULT 'N'으로 휘발.
--   근본 = 경로 Y(개발자 v03 오염행 제거·재적재). _backlog 병기(README 참조).
--   in-place UPDATE(R1 siz_nm·R3 upr_cat_cd·R5 mat_typ)도 동일 휘발 위험 → 경로 Y 병기.
-- ============================================================================

\set ON_ERROR_STOP on

-- ===========================================================================
-- R1 — SZ-1 사이즈 색오염 2행 siz_nm 정규화 (UPDATE·cp 0참조·무비용)
--   src: regspec-size.md §1 · SIZ_000104/105 화이트/블랙 165x115mm
--   멱등 가드: siz_nm <> 정규화값 (이미 정규화면 0행)
-- ===========================================================================
-- src: regspec-size.md §1.1 — "화이트165x115mm(10장)" → "165x115mm(10장)"
UPDATE t_siz_sizes
   SET siz_nm = '165x115mm(10장)', upd_dt = now()
 WHERE siz_cd = 'SIZ_000104'
   AND del_yn = 'N'
   AND siz_nm IS DISTINCT FROM '165x115mm(10장)';

-- src: regspec-size.md §1.1 — "블랙165x115mm(10장)" → "165x115mm(10장)"
UPDATE t_siz_sizes
   SET siz_nm = '165x115mm(10장)', upd_dt = now()
 WHERE siz_cd = 'SIZ_000105'
   AND del_yn = 'N'
   AND siz_nm IS DISTINCT FROM '165x115mm(10장)';

-- ===========================================================================
-- R2 — 카테고리 빈 고아 11노드 소프트삭제 (del_yn='Y' + del_dt)
--   src: regspec-category.md §1.1(CAT_000294 명함) + §1.2(round-22 미완 보정 10)
--   [HARD] del_yn='Y'(조회/BOM/가격 선택지 차단 권위)·use_yn 아님
--   멱등 가드: WHERE del_yn='N' (이미 'Y'면 skip)
--   제외: CAT_000297(이미 del_yn='Y')·CAT_000302/304(활성 상품 재연결=R3)
--   전건 상품 링크 0 실측(price-chain-impact §2)
-- ===========================================================================
UPDATE t_cat_categories
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE cat_cd IN (
         'CAT_000294',  -- 명함 (빈 중복 고아·use_yn='Y')
         'CAT_000293',  -- 상품악세사리
         'CAT_000295',  -- 상품권
         'CAT_000296',  -- 배경지
         'CAT_000298',  -- 실사
         'CAT_000299',  -- 단품형
         'CAT_000300',  -- 플래너
         'CAT_000301',  -- 소품
         'CAT_000303',  -- 디지털악세서리
         'CAT_000305',  -- 레더파우치
         'CAT_000306'   -- 에코백부자재
       )
   AND del_yn = 'N';

-- ===========================================================================
-- R3 — 카테고리 재연결 2노드 (upr_cat_cd UPDATE·소프트삭제 절대 금지)
--   src: regspec-category.md §2.2 · 활성 상품(use_yn='Y') 유일 main 보존
--   FK 위상: 부모 CAT_000134/198 선존재 실측(del_yn='N'·lvl2)
--   멱등 가드: upr_cat_cd IS DISTINCT FROM 목표 (이미 연결이면 0행)
-- ===========================================================================
-- src: regspec-category.md §2.1 — CAT_000302 데스크/사무용품 → CAT_000134 데스크소품
UPDATE t_cat_categories
   SET upr_cat_cd = 'CAT_000134', upd_dt = now()
 WHERE cat_cd = 'CAT_000302'
   AND del_yn = 'N'
   AND upr_cat_cd IS DISTINCT FROM 'CAT_000134';

-- src: regspec-category.md §2.1 — CAT_000304 말랑(PVC고주파) → CAT_000198 응원/시즌
UPDATE t_cat_categories
   SET upr_cat_cd = 'CAT_000198', upd_dt = now()
 WHERE cat_cd = 'CAT_000304'
   AND del_yn = 'N'
   AND upr_cat_cd IS DISTINCT FROM 'CAT_000198';

-- ===========================================================================
-- R4 — 레이플랫제본 PROC_000025 소프트삭제 (del_yn='Y' + del_dt)
--   src: regspec-process.md §3 · 연결 상품 0·cp 0참조 실측(price-chain §3.4)
--   [HARD] del_yn='Y'·use_yn 아님 · 멱등 가드 WHERE del_yn='N'
-- ===========================================================================
UPDATE t_proc_processes
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE proc_cd = 'PROC_000025'
   AND del_yn = 'N';

-- ===========================================================================
-- R5 — .10→.07 부자재 mat_typ 교정 (자재 유지·mat_cd 불변·삭제 아님)
--   src: regspec-material.md §4.1 · 진짜 부속자재 16행(와이어링/고리/끈/우드)
--   cp 참조 0(typ 무관·mat_cd로 매칭) · MAT_TYPE.07 부자재 FK 선존재 실측
--   멱등 가드: mat_typ_cd <> 'MAT_TYPE.07' (이미 .07이면 0행)
--   [주의] 볼체인색(202~209)·잉크색(232~239)=Wave 3 옵션 축이동 → 본 wave 제외
--          봉투(197~201)=R6 정리 · 헤더(211/218/223/225/229/233·del_yn=Y)=R6 skip
-- ===========================================================================
UPDATE t_mat_materials
   SET mat_typ_cd = 'MAT_TYPE.07', upd_dt = now()
 WHERE mat_cd IN (
         'MAT_000210',  -- 와이어링 실버
         'MAT_000212',  -- 와이어링 화이트
         'MAT_000213',  -- 와이어링 블랙
         'MAT_000215',  -- 천정고리
         'MAT_000216',  -- 투명케이스
         'MAT_000217',  -- 행택끈 사각검정 (100개)
         'MAT_000219',  -- 행택끈 사각백색 (100개)
         'MAT_000220',  -- 행택끈 사각마사 (100개)
         'MAT_000221',  -- 자석고정용고무판 20 x 20 (20개입)
         'MAT_000222',  -- 우드거치대 120mm (4mm홈) 내추럴
         'MAT_000224',  -- 우드봉 270mm + 면끈
         'MAT_000226',  -- 우드봉 360mm + 면끈
         'MAT_000227',  -- 우드봉 480mm + 면끈
         'MAT_000228',  -- 우드행거 230mm + 면끈
         'MAT_000230',  -- 우드행거 320mm + 면끈
         'MAT_000231'   -- 우드행거 440mm + 면끈
       )
   AND mat_typ_cd = 'MAT_TYPE.10'
   AND del_yn = 'N';

-- ===========================================================================
-- R6 — 봉투 placeholder 정리 소프트삭제 (del_yn='Y' + del_dt)
--   src: regspec-material.md §4.3(봉투 placeholder 5·BOM 0 실측)
--   봉투는 자재행 아닌 상품(addon)으로 기운영 → 자재행 placeholder 정리
--   멱등 가드: WHERE del_yn='N' (이미 'Y'면 skip)
--   헤더 6행(211/218/223/225/229/233)은 §4.5 — 라이브 전건 이미 del_yn='Y'
--     → 본 UPDATE 가드(WHERE del_yn='N')로 자동 skip(멱등). 추가 문 불요.
-- ===========================================================================
UPDATE t_mat_materials
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE mat_cd IN (
         'MAT_000197',  -- OPP접착봉투
         'MAT_000198',  -- OPP비접착봉투
         'MAT_000199',  -- 트래싱지 카드봉투
         'MAT_000200',  -- 카드봉투
         'MAT_000201'   -- 캘린더봉투
       )
   AND mat_typ_cd = 'MAT_TYPE.10'
   AND del_yn = 'N';

-- ===========================================================================
-- 멱등 헤더 정리 보정 (R6 §4.5) — 잔여 del_yn='N' 헤더만 소프트삭제
--   라이브 실측: 211/218/223/225/229/233 전건 이미 del_yn='Y' → 0행(skip).
--   방어적 가드: 향후 v03 재적재로 'N' 휘발 시 본 문이 재정리(멱등).
-- ===========================================================================
UPDATE t_mat_materials
   SET del_yn = 'Y', del_dt = now(), upd_dt = now()
 WHERE mat_cd IN (
         'MAT_000211',  -- 와이어링 (헤더)
         'MAT_000218',  -- 행택끈 (헤더)
         'MAT_000223',  -- 우드거치대 (헤더)
         'MAT_000225',  -- 우드봉 (헤더)
         'MAT_000229',  -- 우드행거 (헤더)
         'MAT_000233'   -- 만년스탬프 리필잉크 (헤더)
       )
   AND mat_typ_cd = 'MAT_TYPE.10'
   AND del_yn = 'N';

-- ============================================================================
-- 끝. BEGIN/COMMIT/ROLLBACK 없음 — 로더가 트랜잭션 래핑(기본 ROLLBACK).
-- ============================================================================
