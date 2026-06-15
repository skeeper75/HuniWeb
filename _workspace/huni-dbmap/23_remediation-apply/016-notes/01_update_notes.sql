-- 01_update_notes.sql — 016 프리미엄엽서 PRF_DGP_A 가격사슬 note 교정 (note 컬럼만)
-- 생성기: gen_remediation_sql.py (손편집 금지·재현성). 멱등=IS DISTINCT FROM + no-op regexp.
-- [HARD] unit_price·prc_typ_cd·기타 컬럼 절대 미변경. SET 절은 note·upd_dt 둘뿐.

-- A) 구성요소 정의행 t_prc_price_components.note (29행, comp_cd PK)
UPDATE t_prc_price_components SET note='유광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_COAT_GLOSSY' AND note IS DISTINCT FROM '유광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 장당 단가표.';
UPDATE t_prc_price_components SET note='무광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_COAT_MATTE' AND note IS DISTINCT FROM '무광 코팅비. 출력매수·사이즈·코팅면수(단면/양면)별 장당 단가표.';
UPDATE t_prc_price_components SET note='용지비. 선택한 종이·출력규격(국4절/3절)별 절가. 실제 청구는 출력매수만큼 시스템이 자동 계산.', upd_dt=now() WHERE comp_cd='COMP_PAPER' AND note IS DISTINCT FROM '용지비. 선택한 종이·출력규격(국4절/3절)별 절가. 실제 청구는 출력매수만큼 시스템이 자동 계산.';
UPDATE t_prc_price_components SET note='모서리 직각 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_CORNER_RIGHT' AND note IS DISTINCT FROM '모서리 직각 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='모서리 둥근 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_CORNER_ROUND' AND note IS DISTINCT FROM '모서리 둥근 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='오시(접는 줄) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_CREASE_1L' AND note IS DISTINCT FROM '오시(접는 줄) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='오시(접는 줄) 2줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_CREASE_2L' AND note IS DISTINCT FROM '오시(접는 줄) 2줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='오시(접는 줄) 3줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_CREASE_3L' AND note IS DISTINCT FROM '오시(접는 줄) 3줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='미싱(점선 절취) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_PERF_1L' AND note IS DISTINCT FROM '미싱(점선 절취) 1줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='미싱(점선 절취) 2줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_PERF_2L' AND note IS DISTINCT FROM '미싱(점선 절취) 2줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='미싱(점선 절취) 3줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_PERF_3L' AND note IS DISTINCT FROM '미싱(점선 절취) 3줄 가공비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='가변 이미지 1개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_VARIMG_1EA' AND note IS DISTINCT FROM '가변 이미지 1개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='가변 이미지 2개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_VARIMG_2EA' AND note IS DISTINCT FROM '가변 이미지 2개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='가변 이미지 3개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_VARIMG_3EA' AND note IS DISTINCT FROM '가변 이미지 3개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='가변 텍스트 1개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_VARTEXT_1EA' AND note IS DISTINCT FROM '가변 텍스트 1개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='가변 텍스트 2개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_VARTEXT_2EA' AND note IS DISTINCT FROM '가변 텍스트 2개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='가변 텍스트 3개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).', upd_dt=now() WHERE comp_cd='COMP_PP_VARTEXT_3EA' AND note IS DISTINCT FROM '가변 텍스트 3개 추가비. 주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).';
UPDATE t_prc_price_components SET note='디지털 인쇄비(단면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND note IS DISTINCT FROM '디지털 인쇄비(단면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.';
UPDATE t_prc_price_components SET note='디지털 인쇄비(양면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND note IS DISTINCT FROM '디지털 인쇄비(양면). 출력매수·사이즈·도수(흑백/칼라)별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(클리어) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_CLEAR_S1' AND note IS DISTINCT FROM '별색(클리어) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(클리어) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_CLEAR_S2' AND note IS DISTINCT FROM '별색(클리어) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(금색) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_GOLD_S1' AND note IS DISTINCT FROM '별색(금색) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(금색) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_GOLD_S2' AND note IS DISTINCT FROM '별색(금색) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(핑크) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_PINK_S1' AND note IS DISTINCT FROM '별색(핑크) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(핑크) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_PINK_S2' AND note IS DISTINCT FROM '별색(핑크) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(은색) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_SILVER_S1' AND note IS DISTINCT FROM '별색(은색) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(은색) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_SILVER_S2' AND note IS DISTINCT FROM '별색(은색) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(화이트) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_WHITE_S1' AND note IS DISTINCT FROM '별색(화이트) 인쇄비 단면. 출력매수·사이즈별 장당 단가표.';
UPDATE t_prc_price_components SET note='별색(화이트) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.', upd_dt=now() WHERE comp_cd='COMP_PRINT_SPOT_WHITE_S2' AND note IS DISTINCT FROM '별색(화이트) 인쇄비 양면. 출력매수·사이즈별 장당 단가표.';

-- B) 단가행 t_prc_component_prices.note (비-용지비) — 결정적 regexp 치환
--    siz-corrected 마커·(별색=공정,clr=NULL)·(합가,comp_typ=.04...) 제거 + 축 한국어화
--    note 컬럼만 읽어 note 컬럼만 씀. 가격행(unit_price 등) 불변. WHERE로 실변경분만 → 멱등.
UPDATE t_prc_component_prices cp SET note = btrim(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(note, '^\[siz-corrected:[^\]]*\]\s*', ''), '\s*\(별색=공정,clr=NULL\)\s*$', ''), '\s*\(합가,\s*comp_typ=\.04\s*후가공비,\s*옵션=comp흡수\)\s*$', ' / 작업 1건 고정 금액'), '출력매수≥([0-9]+)', '출력매수 \1장 이상'), '제작수량≥([0-9]+)', '주문수량 \1건 이상')), upd_dt=now()
WHERE cp.comp_cd IN (SELECT comp_cd FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_A')
  AND cp.comp_cd <> 'COMP_PAPER'
  AND cp.note IS NOT NULL
  AND cp.note IS DISTINCT FROM (btrim(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(note, '^\[siz-corrected:[^\]]*\]\s*', ''), '\s*\(별색=공정,clr=NULL\)\s*$', ''), '\s*\(합가,\s*comp_typ=\.04\s*후가공비,\s*옵션=comp흡수\)\s*$', ' / 작업 1건 고정 금액'), '출력매수≥([0-9]+)', '출력매수 \1장 이상'), '제작수량≥([0-9]+)', '주문수량 \1건 이상')));

-- C) 단가행 용지비(COMP_PAPER) — 친화 설명 suffix 추가(이미 있으면 건너뜀=멱등)
UPDATE t_prc_component_prices cp SET note = note || ' — 실제 청구는 출력매수만큼 자동 계산', upd_dt=now()
WHERE cp.comp_cd = 'COMP_PAPER'
  AND cp.note IS NOT NULL
  AND cp.note NOT LIKE '%실제 청구는 출력매수만큼 자동 계산%';

