-- apply.sql — 아크릴 마무리 실행본 (A5 긴급보정 + 코롯토 B2~B4). 단일 트랜잭션·FK 위상순·롤백전용 DRY-RUN.
-- [HARD] 기본 ROLLBACK(아래). 실 COMMIT은 인간 승인 후 apply.sh --commit 으로만.
-- 순서: A5(이미 COMMIT된 .02 min_qty NULL 보정) → B2(코롯토 comp) → B3(코롯토 단가행) → B4(코롯토 공식+배선).
--   B2(comp 부모)가 B3/B4 전·B4 formula가 formula_components 전(FK). A5는 독립(기존 데이터 보정).
-- 단가행 = 가격표 verbatim(B3·날조 0)·골든 불변(A5 ÷1=×1). 좌표 siz 채번 0. min_qty 가드(.02 NULL 금지).
-- ★BLOCKED(acrylic2-blocked.BLOCKED.sql)은 \i 하지 않음 — 미러 바인딩·카라비너 opt_cd 채번·코롯토 바인딩·.02 시맨틱.
\set ON_ERROR_STOP on
BEGIN;

\echo '=== A5: .02 합가형 단가행 min_qty NULL → 1 보정 (엔진 ÷min_qty ValueError 해소·골든 불변) ==='
\i A5_fix_min_qty.sql

\echo '=== B2: 코롯토 구성요소 COMP_ACRYL_COROTTO 신설 (.01 단가형·use_dims WH) ==='
\i B2_korotto_comp.sql

\echo '=== B3: 코롯토 단가행 21 verbatim INSERT (siz_width/siz_height·채번 0) ==='
\i B3_korotto_unitprices.sql

\echo '=== B4: 코롯토 공식 PRF_COROTTO_ACRYL + 본체 배선 (disp_seq=1·addtn_yn=N) ==='
\i B4_korotto_formula.sql

-- 기본 = 롤백전용 DRY-RUN. (실 COMMIT 은 apply.sh --commit 이 ROLLBACK→COMMIT 치환)
ROLLBACK;
