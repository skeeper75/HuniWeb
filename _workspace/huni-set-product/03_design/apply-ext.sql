-- ============================================================================
-- apply-ext.sql — 남은 6셋트(책자류5+떡메모지) 셋트 구성 보정 적재본 (멱등)
-- 생성: hsp-set-designer · 동형 전파 2차 · DB 미적재(load-executor가 BEGIN/COMMIT 래핑)
-- 권위=상품마스터(260610) · 라이브 실측 기준(2026-06-24) · 신규 mint 0(전부 보정/UPDATE)
-- 라이브 스키마 실측: t_prd_product_sets PK=(prd_cd,sub_prd_cd) · semi_role_cd 컬럼 없음
-- 대상: PRD_000072·077·082·088·097·100 (엽서북094 제외=이미 COMMIT)
-- 가격공식·면지자재·페이지축은 적재 제외(BLOCKED-PRICE-6·RM-2·RM-4 — blocked-board-ext.csv)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [1] 셋트 부모 유형 교정 (directive1·RM-3 확정) — t_prd_products (6 UPDATE)
--     PRD_TYPE.04(디자인) -> PRD_TYPE.01(완제품). 멱등: 이미 01이면 0행.
-- ----------------------------------------------------------------------------
UPDATE t_prd_products
   SET prd_typ_cd = 'PRD_TYPE.01', upd_dt = now()
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01';

-- ----------------------------------------------------------------------------
-- [2] 셋트 구성원 보정 (directive2·directive3 택1 현황유지) — t_prd_product_sets (26 UPSERT)
--     기존 26행 존재(disp_seq=1). disp_seq 단조증가 + note 명확화.
--     min/max/incr는 §4 사유로 NULL 유지(권위 침묵/내지 member 부재/모호).
--     택1 면지/표지는 행 보존(평면 4행 합산 무해=member 공식·차원 0 · §3.2).
-- ----------------------------------------------------------------------------

-- PRD_000072 하드커버책자: 표지1 + 면지3(택1)
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000072','PRD_000073',1,NULL,NULL,NULL,1,'표지=전용지','N',now()),
 ('PRD_000072','PRD_000074',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000072','PRD_000075',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000072','PRD_000076',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- PRD_000077 레더 하드커버책자: 표지1 + 면지3(택1)
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000077','PRD_000078',1,NULL,NULL,NULL,1,'표지=레더(화이트)','N',now()),
 ('PRD_000077','PRD_000079',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000077','PRD_000080',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000077','PRD_000081',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- PRD_000082 하드커버 링책자: 표지1 + 면지4(택1·인쇄면지 포함)
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000082','PRD_000083',1,NULL,NULL,NULL,1,'표지=전용지','N',now()),
 ('PRD_000082','PRD_000084',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000082','PRD_000085',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000082','PRD_000086',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000082','PRD_000087',1,NULL,NULL,NULL,5,'면지=인쇄면지','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- PRD_000088 레더 링바인더: 표지1 + 면지4(택1·인쇄면지 포함)
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000088','PRD_000089',1,NULL,NULL,NULL,1,'표지=레더(화이트)','N',now()),
 ('PRD_000088','PRD_000090',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000088','PRD_000091',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000088','PRD_000092',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000088','PRD_000093',1,NULL,NULL,NULL,5,'면지=인쇄면지','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- PRD_000097 떡메모지: 내지1 (단일 구성원·페이지권위공란→min/max/incr NULL)
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000097','PRD_000098',1,NULL,NULL,NULL,1,'내지=백모조120','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- PRD_000100 포토북: 내지1 + 표지5(택1) + 면지1 (CONFIRM-3 권위모호·페이지미특정→NULL)
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000100','PRD_000101',1,NULL,NULL,NULL,1,'내지=몽블랑130','N',now()),
 ('PRD_000100','PRD_000102',1,NULL,NULL,NULL,2,'표지=하드커버','N',now()),
 ('PRD_000100','PRD_000103',1,NULL,NULL,NULL,3,'표지=아트250+무광코팅','N',now()),
 ('PRD_000100','PRD_000105',1,NULL,NULL,NULL,4,'표지=레더하드커버','N',now()),
 ('PRD_000100','PRD_000106',1,NULL,NULL,NULL,5,'표지=레더','N',now()),
 ('PRD_000100','PRD_000107',1,NULL,NULL,NULL,6,'표지=소프트커버','N',now()),
 ('PRD_000100','PRD_000104',1,NULL,NULL,NULL,7,'면지=그레이','N',now())
ON CONFLICT (prd_cd, sub_prd_cd) DO UPDATE SET
 sub_prd_qty=EXCLUDED.sub_prd_qty, min_cnt=EXCLUDED.min_cnt, max_cnt=EXCLUDED.max_cnt,
 cnt_incr=EXCLUDED.cnt_incr, disp_seq=EXCLUDED.disp_seq, note=EXCLUDED.note, del_yn='N', upd_dt=now();

-- ----------------------------------------------------------------------------
-- BLOCKED (적재본 제외 · blocked-board-ext.csv 참조):
--   - BLOCKED-PRICE-6: 6셋트 부모/구성원 가격공식 0 → PRICE=0 견적불가 → §18 셋트공식 신설(인간승인)
--   - RM-4: 페이지 가변(24~300/+2·8~100/+2)=부모 페이지옵션·내지 member 미등록(MES별도설정) → dbmap/CPQ
--   - RM-2: 면지 자재 4종(MAT_000001~004) 재배선 → dbmap/basecode(t_mat 공유마스터·인간승인)
--   - GUARD-1: 가격 신설 시 면지/표지 택1을 member 평면합산 금지 → 옵션축 모델링(호출단 택1 1개 전달)
--   - CONFIRM-3: 포토북 권위행 미특정 → 권위 시트 특정·실무진 확인
-- ----------------------------------------------------------------------------
