-- ============================================================================
-- apply-ext.sql (래핑본) — 동형 전파 2차(남은 6셋트) 구조 보정 라이브 COMMIT
-- 생성: hsp-load-executor · 게이트 GO(CONDITIONAL, set-verdict-ext.md S1~S7) +
--       codex reconcile(D1~D5 CLOSED) + 인간 명시 승인
-- 단일 트랜잭션 BEGIN ... COMMIT · 32 DML 한정(6 UPDATE + 26 UPSERT) · 신규 INSERT 0
-- 백업: bak_t_prd_product_sets_setbuild_ext_<ts> · bak_t_prd_products_setbuild_ext_<ts>
-- D3 정정: SQL은 INSERT…ON CONFLICT(UPSERT)이며 라이브 26행이 실재해 실 INSERT 0건.
--          (기존 "신규 mint 0"은 결과적으로 참 — 신규행 발생 안 함을 DRY-RUN으로 실증)
-- BLOCKED 일절 제외: BLOCKED-PRICE-6 · RM-4(페이지축) · RM-2(면지자재) · GUARD-1 · CONFIRM-3
-- min/max/incr는 NULL 유지(권위 침묵·내지 member 부재·모호) — 가격/페이지 미접촉.
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

-- [1] 셋트 부모 유형 교정 04(디자인)->01(완제품) · 6 UPDATE · IS DISTINCT FROM 멱등
UPDATE t_prd_products
   SET prd_typ_cd='PRD_TYPE.01', upd_dt=now()
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100')
   AND prd_typ_cd IS DISTINCT FROM 'PRD_TYPE.01';

-- [2] 셋트 구성원 26 UPSERT (disp_seq 단조 + note 명확화) · min/max/incr NULL 유지
INSERT INTO t_prd_product_sets (prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq, note, del_yn, reg_dt) VALUES
 ('PRD_000072','PRD_000073',1,NULL,NULL,NULL,1,'표지=전용지','N',now()),
 ('PRD_000072','PRD_000074',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000072','PRD_000075',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000072','PRD_000076',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000077','PRD_000078',1,NULL,NULL,NULL,1,'표지=레더(화이트)','N',now()),
 ('PRD_000077','PRD_000079',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000077','PRD_000080',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000077','PRD_000081',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000082','PRD_000083',1,NULL,NULL,NULL,1,'표지=전용지','N',now()),
 ('PRD_000082','PRD_000084',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000082','PRD_000085',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000082','PRD_000086',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000082','PRD_000087',1,NULL,NULL,NULL,5,'면지=인쇄면지','N',now()),
 ('PRD_000088','PRD_000089',1,NULL,NULL,NULL,1,'표지=레더(화이트)','N',now()),
 ('PRD_000088','PRD_000090',1,NULL,NULL,NULL,2,'면지=화이트면지','N',now()),
 ('PRD_000088','PRD_000091',1,NULL,NULL,NULL,3,'면지=블랙면지','N',now()),
 ('PRD_000088','PRD_000092',1,NULL,NULL,NULL,4,'면지=그레이면지','N',now()),
 ('PRD_000088','PRD_000093',1,NULL,NULL,NULL,5,'면지=인쇄면지','N',now()),
 ('PRD_000097','PRD_000098',1,NULL,NULL,NULL,1,'내지=백모조120','N',now()),
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

COMMIT;
