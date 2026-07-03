<!-- component page: E10 price_component — 스티커 완제품가 구성요소(격자 룩업). 1 파일 = N 블록(### [id]). -->
<!-- ★단가행 값은 노드로 펼치지 않음(D-22 접기·use_dims 차원 선언까지가 온톨로지 경계·값=evaluate_price). -->

# 축: 스티커 가격구성요소 (price_component)

스티커 완제품가 구성요소 = (사이즈·소재·수량) 격자 룩업(use_dims=[siz_cd,mat_cd,min_qty]류).
공식→구성요소(R9 `has_component`)는 formula/sticker-formulas.md 공식이 건다.


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [component-COMP_GANGPAN_PRINT] 합판도무송 완제품가(형상·소재별) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_GANGPAN_PRINT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_GANGPAN_PRINT (prc_typ_cd=PRICE_TYPE.02·use_dims=[siz_cd,mat_cd,min_qty])", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd:COMP_GANGPAN_PRINT 1,110행(066 6소재×185행 완전 충전=전사표·정사각10x10 유포 26,100 등)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims_ref: "전사표 [siz_cd, mat_cd, min_qty]", 단가행: "1,110행(D-22 접기·066 active 6소재×185행 완전 충전 실측)", note: "합판 완제품가(출력+도무송 포함) 격자·형상(=size)×소재×수량 3차원·단가 2그룹(유포/데드롱 고가·비코팅/코팅 저가)·연당가 원가는 미포함(§4-B)·058 COMP_STK_PRINT(.01)와 별 구성요소(.02)·공유 축 승격 후보"}

### [component-COMP_STK_PACK] 스티커 완제품가 팩 (54장1세트) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STK_PACK
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STK_PACK(comp_nm=스티커 완제품가 팩(54장1세트)·comp_typ_cd=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.02·use_dims=[siz_cd,min_qty]·note '.01→.02 합가형 교정·54장1세트'·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd=COMP_STK_PACK 단가행 1행(comp_price_id 28002·SIZ_000068·min_qty=54·unit_price=4000·mat_cd 무·note '54장1세트 4000 합가형·min_qty=54 필수')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {comp_cd: "COMP_STK_PACK", prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: "[siz_cd, min_qty]", grid_rows: 1, note: "★완제품가 합가형 룩업(출력+가공 포함). use_dims에 mat_cd 없음 = 소재 무관 가격(비코팅/미색 자재는 BOM일 뿐 단가 축 아님). 단가행 1행(SIZ_000068·54장·4,000)·값=전사표 권위·계산=evaluate_price(D-18). 단가행 접기(D-22)·COMP_PAPER(용지비)에 065 소재 0행=연당가 절가 미저장(완제품가 모델·§4-B)"}
- 본문: 스티커팩 완제품가 격자([[formula-PRF_STK_PACK]] has_component 대상). 형상×치수가 아니라 (사이즈·수량밴드) 격자 — 팩은 54장1세트 단일 밴드. 값 나열 아님(D-22)·값=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).

### [component-COMP_STK_PRINT] 스티커 완제품가(소재·규격) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STK_PRINT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_STK_PRINT prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[siz_cd,mat_cd,min_qty]", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices 필터:comp_cd=COMP_STK_PRINT — 052 활성 15조합(siz∈{057,170,520}×mat∈{584,585,586,609,611}) 각 36 수량구간행(전사표 행수요약)·전체 6,498행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "전사표 [siz_cd, mat_cd, min_qty]", rows_ref: "전사표 행수요약(단가행 접기·D-22·값 나열 아님)", note: "완제품가(출력+가공 포함) 격자 룩업·연당가(원가) 아님·needed_shared_node"}
- 본문: use_dims=[siz_cd, mat_cd, min_qty] 차원 선언까지가 온톨로지 경계(값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]). 단가행(스티커 전체 8,275행류)은 노드로 펼치지 않고 이 노드 속성/행수 집계로 접는다(D-22). 052 활성 15조합 전부 단가행 실재 → 가격 사슬 충전(견적 산출 가능).

### [component-COMP_STK_TATTOO] 타투스티커 완제품가(3장세트·합가형) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STK_TATTOO
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_STK_TATTOO comp_nm='타투스티커 완제품가(3장세트)'·prc_typ_cd=PRICE_TYPE.02·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[siz_cd,mat_cd,min_qty]·note '3장 1세트당 합산가(합가형)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices 필터:comp_cd=COMP_STK_TATTOO — 067 격자 SIZ_000060×{MAT_000167 레거시 333·MAT_000594 활성 333}=666행(전사표 행수요약)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "전사표 [siz_cd, mat_cd, min_qty]", rows_ref: "전사표 행수요약(단가행 접기·D-22·값 나열 아님)", note: "★합가형(.02·합판 COMP_GANGPAN_PRINT와 같은 prc_typ)·052 COMP_STK_PRINT(고정가 .01)과 구분·완제품가(출력 포함) 격자 룩업·연당가(원가) 아님·needed_shared_node"}
- 본문: use_dims=[siz_cd, mat_cd, min_qty] 차원 선언까지가 온톨로지 경계(값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]). 단가행(666행)은 노드로 펼치지 않고 이 노드 속성/행수 집계로 접는다(D-22). 067 활성 룩업 = SIZ_000060×MAT_000594(333행) 실재 → 가격 사슬 충전(견적 산출 가능). 구 자재 MAT_000167 격자(333행)는 옵션 미노출 레거시(코드 불일치 없음).
