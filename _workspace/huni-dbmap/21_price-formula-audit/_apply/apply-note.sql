-- round-17 개선안 A: 가격공식 비고(note) 쉬운 한국어 반영
-- 비파괴·멱등(값만 변경, 재실행 동일). 트랜잭션 래핑.
-- 권위: 21_price-formula-audit/improvement-proposal.md §A (인간 승인 2026-06-13).
BEGIN;

UPDATE t_prc_price_formulas SET note='엽서·상품권·종이슬로건 가격. 인쇄비+코팅비+용지비+후가공비+추가상품을 더해 판매가 계산. 별색인쇄비·대형박은 별도 항목.', upd_dt=now() WHERE frm_cd='PRF_DGP_A';
UPDATE t_prc_price_formulas SET note='모양엽서·라벨택 가격. 인쇄비+용지비+커팅비(완칼)를 더함.', upd_dt=now() WHERE frm_cd='PRF_DGP_B';
UPDATE t_prc_price_formulas SET note='인쇄배경지·헤더택 가격. 인쇄비+용지비+접지비+타공비+추가상품을 더함.', upd_dt=now() WHERE frm_cd='PRF_DGP_C';
UPDATE t_prc_price_formulas SET note='소량전단지 가격. 인쇄비+코팅비+용지비+후가공비를 더함.', upd_dt=now() WHERE frm_cd='PRF_DGP_D';
UPDATE t_prc_price_formulas SET note='접지카드·접지리플렛 가격(국4절/3절 기준). 인쇄비+코팅비+용지비+접지비+후가공비+대형박+추가상품을 더함.', upd_dt=now() WHERE frm_cd='PRF_DGP_E';
UPDATE t_prc_price_formulas SET note='썬캡 가격(현재 미출시). 용지비+인쇄비+커팅비를 더함.', upd_dt=now() WHERE frm_cd='PRF_DGP_F';
UPDATE t_prc_price_formulas SET note='책자 제본비. 수량×제본종류 표에서 제본비를 찾아 상위 공식에 더함.', upd_dt=now() WHERE frm_cd='PRF_BIND_SUM';
UPDATE t_prc_price_formulas SET note='카드·리플렛 접지비. 제작수량 표에서 접지비를 찾아 상위 공식에 더함.', upd_dt=now() WHERE frm_cd='PRF_FOLD_SUM';
UPDATE t_prc_price_formulas SET note='포스터·사인 완제품가. 소재·사이즈·수량 표에서 완제품가를 바로 조회(출력+코팅+가공 모두 포함). 추가옵션은 별도.', upd_dt=now() WHERE frm_cd='PRF_POSTER_FIXED';
UPDATE t_prc_price_formulas SET note='스티커 단가. 수량×(출력매수·소재) 표에서 단가 조회.', upd_dt=now() WHERE frm_cd='PRF_STK_FIXED';
UPDATE t_prc_price_formulas SET note='명함 단가(용지 포함). 수량×(소재·면) 표에서 단품가 조회.', upd_dt=now() WHERE frm_cd='PRF_NAMECARD_FIXED';
UPDATE t_prc_price_formulas SET note='엽서북 단가. 수량×(사이즈·면·페이지) 표에서 단가 조회.', upd_dt=now() WHERE frm_cd='PRF_PCB_FIXED';
UPDATE t_prc_price_formulas SET note='포토카드 세트 고정가. 20장 1세트당 고정단가(일반/투명 분리).', upd_dt=now() WHERE frm_cd='PRF_PHOTOCARD_FIXED';
UPDATE t_prc_price_formulas SET note='봉투제작 완제품가. 수량×소재 표에서 가격 조회(봉투종류·소재별).', upd_dt=now() WHERE frm_cd='PRF_ENV_MAKING';
UPDATE t_prc_price_formulas SET note='합판도무송 단가. 수량×(사이즈·소재) 표에서 단가 조회.', upd_dt=now() WHERE frm_cd='PRF_GANGPAN_FIXED';
UPDATE t_prc_price_formulas SET note='떡메모지 단가. 수량×(사이즈·권당장수·장수) 표에서 단가 조회.', upd_dt=now() WHERE frm_cd='PRF_TTEOKME_FIXED';

COMMIT;
