<!-- companion nodes for product-134 린넨 우드봉 족자 — 공유 축(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(126·124·122 방식). -->
<!-- ★실사 첫 "고정가 룩업형"(fixed): 가격 use_dims=[siz_cd,min_qty](이산 규격×수량)·면적매트릭스(122/126)와 다른 아키타입. -->
<!-- ★재사용(중복 mint 금지·L-3): size-SIZ_000315(A3)=118 canonical·process-PROC_000080(봉제)=125 canonical → 여기서 재정의 안 함. -->
<!-- ★수치(치수·단가 행수/범위·배선)는 transcribe_product_134.py 출력만(마커). 본 파일 수치=행수/코드/골든뿐. -->

# product-134 전용 노드 (린넨 우드봉 족자 — 실사 고정가 룩업 + 봉제/우드봉 옵션 전용 마스터 축)

[[product-134-linen-woodrod-scroll]]가 연결하는 축 중 **린넨 우드봉 족자 고유분**을 여기 신설한다. 공유
실사 축(A3 사이즈 SIZ_000315·봉제 공정 PROC_000080)은 형제 118/125가 선점 정의한 노드라 **reference만**
(중복 mint 금지·향후 axis/formula 승격 시 canonical id 유지). 판형(plate_size)은 실사 비종이류라 노드 없음
(전 행 논리삭제·pack §3.8·T-7). 인쇄옵션(도수)도 없음(실사 대형 잉크젯 풀컬러·po=0). 전사 원표는
[[product-134-linen-woodrod-scroll]] 본문(transcribe_product_134.py)에 있다.

---

## 카테고리 (category) — 보드액자 재사용 (131 canonical·중복 mint 금지)

★[[category-CAT_000080]](보드액자·부모 CAT_000004 포스터·lvl2)은 형제 [[product-131-frameless-wood-frame-nodes]]가
canonical mint한 공유 실사 leaf(고정가 실사 129~134 공유·131 등록 분류)라 **여기서 재정의 안 함**(reference·L-3
중복 방지). `in_category`→category-CAT_000080 엣지는 프론트매터가 유지(target 실재). 134의 junction
(PRD_000134,CAT_000080) main_cat_yn=N은 라이브 현재값 그대로(단일 카테고리인데 주 미표기·정직 관찰·양면 아님).
round-13 "실사 전부 CAT_000298 고아"는 STALE(CAT_000298 del_yn=Y·정상 재연결·pack §1.1·T-1). ★consolidate 시
canonical id 유지(needed_shared).

---

## 사이즈 (size) — A4·A2 이산 규격 (A3=118 canonical 재사용)

가격키 siz_cd(고정가 룩업). 활성 3규격 중 A3(SIZ_000315)는 118이 canonical mint한 노드라 여기 재정의
안 함(reference). A4(SIZ_000258)·A2(SIZ_000317)만 134가 신설(승격 후보). ★nonspec_yn=N이라 면적매트릭스
프리셋(work 공백)과 달리 실 작업치수를 보유하나, 고정가는 siz_cd 자체가 가격키다(치수→가격 아님).

### [size-SIZ_000258] A4 규격 (210x297) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000258
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000258 siz_nm='A4 (210x297mm)'·work 210x297·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000134,SIZ_000258) dflt_yn=Y·disp 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표(A4 210x297mm)", 유형: "이산 규격(가격키 siz_cd)"}
- 본문: A4 이산 규격. 고정가 룩업의 가격키 siz_cd([[component-COMP_POSTER_LINEN_WOODBONG]] 최소 규격 행). 우드봉 hem 작업사이즈(210x347)는 판형 3행(del·생산메타)에 있고 가격축 아님.

### [size-SIZ_000317] A2 규격 (420x594) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000317
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000317 siz_nm='A2'·work 420x594·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000134,SIZ_000317) dflt_yn=Y·disp 3·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표(A2 420x594mm)", 유형: "이산 규격(가격키 siz_cd)·최대규격(골든)"}
- 본문: A2 이산 규격(최대규격·골든 base 16000·우드봉 추가 12000·master 실측). 118은 A2로 SIZ_000198을 쓰나 134는 SIZ_000317(별도 코드·siz_nm 'A2')이라 재사용 아님·134 mint. 우드봉 hem 작업사이즈(420x644)는 판형 3행(del·생산메타).

---

## 자재 (material) — 린넨 1종 (MAT_TYPE.05 특수소재)

### [material-MAT_000184] 린넨 (MAT_TYPE.05 특수소재·교정됨) {verified}
- type: material
- anchor: t_mat_materials/MAT_000184
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000184 mat_nm=린넨·mat_typ_cd=MAT_TYPE.05·use_yn=Y·del_yn=N·note '정정 2026-06-14: 실사소재(.08)→원단(.05)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000134,MAT_000184) usage_cd=USAGE.07·dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 자재유형 교정(린넨184=.05)·T-2(목표 라벨 원단=.05 STALE·현재 .05=특수소재)·§1.1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_typ_cd: "MAT_TYPE.05", usage_cd: "USAGE.07", crosscut: "라이브 7상품(124/134/191/243/265/266/267)"}
- 본문: 린넨 패브릭 본체 자재(낱장 완제품·parent+usage_cd). mat_typ_cd=MAT_TYPE.05는 현재값이자 개편 후 정답 — round-13 목표 라벨 '원단'(.05)은 MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재)으로 라벨 의미만 바뀐 것이라 **자재유형 양면 아님**(T-2·pack §1.1). ★형제 124는 자식 MAT_000607(린넨 내추럴)로 교체했으나 134는 부모 MAT_000184 직결(활성·del_yn=N). ★고정가 룩업은 자재 무관(siz_cd 통가격·자재는 소재 정체용). ★IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 가격공식·구성요소 (실사 고정가 룩업 — 상품-local mint·needed_shared_node)

실사 = 2모델 공존(면적매트릭스 13 + 고정가 15·pack §3.10). 린넨 우드봉 족자134는 **고정가 룩업형**의 대표
(면적매트릭스 122/126과 다른 아키타입). base 규격×수량 단가 + 우드봉 옵션 가산 2구성요소. 디지털 원자합산·
스티커 고정룩업·실사 면적매트릭스와 별개라 린넨우드봉 전용 공식/구성요소를 여기 신설(고정가 실사 15상품
향후 승격 후보·formula/silsa-formulas).

### [formula-PRF_POSTER_LINEN_WOODBONG] 린넨 우드봉 족자 완제품가(규격/수량 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_LINEN_WOODBONG
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_LINEN_WOODBONG frm_nm='린넨 우드봉 족자 완제품가(면적/규격 단가)'·note '포스터사인 린넨 우드봉 족자 소재/사이즈/수량별 완제품 통가격'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_LINEN_WOODBONG,COMP_POSTER_LINEN_WOODBONG) disp_seq 1·addtn_yn=Y + (…,COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG) disp_seq 2·addtn_yn=Y (2026-06-23 우드봉 comp 추가)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 고정가형 15상품(린넨우드봉족자134)·실사 inline price(R/S/V) 권위 아님[HARD]·권위=포스터사인 시트", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {archetype: "고정가 룩업형(규격[siz_cd]×수량[min_qty] 단가·이산 A4/A3/A2·off-grid 없음) + 우드봉 옵션 가산", use_yn: Y}
- rel: {rel: has_component, target: component-COMP_POSTER_LINEN_WOODBONG, qualifier: {disp_seq: 1, addtn: Y}, note: "base 완제품가(규격×수량 룩업·3행 A4/A3/A2)"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG, qualifier: {disp_seq: 2, addtn: Y}, note: "우드봉+면끈 추가가(opt_cd×siz_cd 매칭·가산)"}
- standards: {schema_org: "(Offer 계산 — schema.org 표현 불가)", note: "값 계산=evaluate_price 권위(D-18)·고정가 이산 룩업(off-grid 없음)"}
- 본문: 고정가 룩업형 = [규격(siz_cd)×수량(min_qty)] 단가 룩업(출력+소재+가공 포함 통가격) + 우드봉+면끈 추가가 가산. 고아 공식 아님(has_component 2개·O6 충족). ★면적매트릭스(siz_width×siz_height·off-grid ceiling)와 달리 이산 siz_cd 직접 조회라 off-grid 없음. 온톨로지는 배선까지, 값은 엔진(D-18). 실사 시트 inline price 권위 아님·권위=포스터사인 시트[HARD].

### [component-COMP_POSTER_LINEN_WOODBONG] 린넨 우드봉 족자 완제품가 (규격×수량·base) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_LINEN_WOODBONG
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_LINEN_WOODBONG prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[siz_cd,min_qty]·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_LINEN_WOODBONG 3행(siz_cd=SIZ_000258/315/317·min_qty=1·값=본문 전사표 행수/범위/골든 요약·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "본문 전사표 [siz_cd,min_qty]", 행수_ref: "본문 전사표(3행·규격당 min_qty=1 단일밴드)", 골든_ref: "본문 전사표(A2 SIZ_000317)"}
- 본문: base 완제품가(출력+소재+가공 포함 통가격)를 **[규격 siz_cd × 수량 min_qty]** 로 저장(3행·A4/A3/A2·규격당 단일 수량밴드 min_qty=1). ★면적매트릭스(siz_width×siz_height·687셀류)와 달리 이산 siz_cd 룩업이라 격자 아님·off-grid 없음. 단가행 실값 나열 아님(D-22 접기)·값 계산=evaluate_price 권위(D-18).

### [component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG] 린넨우드봉족자 우드봉+면끈 추가가 (옵션 단가·opt_cd 매칭) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[opt_cd,siz_cd,opt_grp:OPT_000014]·note '포스터·사인 추가옵션 가격(거치대·끈·타공 등 별도 추가). 옵션·수량별 단가표'·use_yn=Y·del_yn=N(2026-06-23 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG 3행(opt_cd=OPV_000430·siz_cd=SIZ_000258/315/317·값=본문 전사표 행수/범위/골든 요약·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "본문 전사표 [opt_cd,siz_cd,opt_grp:OPT_000014]", 행수_ref: "본문 전사표(3행)", 매칭: "opt_cd=OPV_000430(우드봉+면끈 추가)×siz_cd(A4/A3/A2)"}
- 본문: 우드봉+면끈 추가가를 [opt_cd(OPV_000430)×siz_cd(규격)] 로 매칭해 base가에 가산(3행·규격별 7000~12000). ★추가 옵션그룹 [[optgroup-134-OPT_000014]]의 손님 선택(우드봉+면끈 추가)이 이 단가행을 고른다. 물리 부속(우드봉 PRD_000013)과의 addon/set 관계는 미연결([[gap-134-woodbong-addon]])이나 가격 경로는 이 comp로 완결. 값=엔진(D-22 접기).

---

## 옵션그룹 (CPQ) — 가공(봉제·mand Y) + 추가(우드봉·mand N)

옵션 = 공정 BUNDLE(pack §3.9). 옵션참조(ref_dim_cd=OPT_REF_DIM.04 공정)는 같은 부모 prd_cd 차원에 실재
필수(`fn_chk_opt_item_ref`·L-18). 가공 옵션이 부모 has_process(PROC_000080)를 가리킴=정합.

### [optgroup-134-OPT_000013] 가공(봉제) 필수 택1 (mand=Y·min/max=1/1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000134
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000134,OPT_000013) opt_grp_nm=가공·note='오버로크+봉미싱 봉제 필수 (복합유형=2 item)'·sel_typ=SEL_TYPE.01·min/max=1/1·mand_yn=Y·use_yn=Y·disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000134,OPV_000031) ref_dim_cd=OPT_REF_DIM.04(공정)·ref_key1=PROC_000080·qty=1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "Y", items: "OPV_000031 오버로크+봉미싱(4cm·dflt)→PROC_000080"}
- rel: {rel: option_refs, target: process-PROC_000080, ref_key1: PROC_000080, note: "가공 옵션값 OPV_000031(OPT_REF_DIM.04 공정·ref_key1=PROC_000080)"}
- 본문: 가공(봉제) 필수 옵션(mand Y·택1). 옵션값 OPV_000031(오버로크+봉미싱 4cm)이 부모 has_process(봉제 PROC_000080)를 가리킨다(L-18 정합·형제 124/125 봉제 옵션과 동형). 옵션=공정 BUNDLE(pack §3.9). PROC_000080은 125 canonical 노드 재사용. 값 계산=엔진.

### [optgroup-134-OPT_000014] 추가(우드봉) 택1 (mand=N·min/max=0/1) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000134
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000134,OPT_000014) opt_grp_nm=추가·note='우드봉 추가 선택'·sel_typ=SEL_TYPE.01·min/max=0/1·mand_yn=N·use_yn=Y·disp 2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "테이블:t_prd_product_options 키:(PRD_000134,OPV_000032 출력만 dflt / OPV_000430 우드봉+면끈 추가)·둘 다 option_items ref_dim 없음(bare 값)·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "N", items: "OPV_000032 출력만(dflt·기본) / OPV_000430 우드봉+면끈 추가(가격=COMP_POSTEROPT opt_cd 매칭)"}
- rel: {rel: references, target: component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG, note: "우드봉+면끈 추가(OPV_000430)의 가격 단가행을 opt_cd로 고름"}
- rel: {rel: references, target: gap-134-woodbong-addon, note: "우드봉 옵션값=bare(option_item ref_dim 없음·물리 부속 PRD_000013 미연결)"}
- 본문: 추가(우드봉) 옵션(mand N·택1). OPV_000032(출력만)=기본·OPV_000430(우드봉+면끈 추가)=가산. ★두 옵션값 모두 option_item ref_dim이 없는 **bare 값** — 우드봉 가격은 [[component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG]](opt_cd 키)로만 결정되고, 물리 부속(우드봉 PRD_000013)과의 addon/set은 미연결([[gap-134-woodbong-addon]]). `option_refs`→실물 차원 엣지 없음(bare 값이라 L-18 대상 아님). 값=엔진.

---

## 수량 (bundle_qty) — 상품레벨 규칙 (bundle_qtys 0행)

### [qty-134] 린넨 우드봉 족자 수량규칙 (min1/max10000/incr1) {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000134
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000134(min_qty 1·max_qty 10000·qty_incr 1·qty_unit_typ_cd QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "테이블:t_prd_product_bundle_qtys PRD_000134=0행(별도 묶음수 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min1·max10000·incr1)", bdl_unit_typ_cd: "QTY_UNIT.01", note: "고정가 base comp use_dims에 min_qty 밴드(현재 규격당 1밴드 min_qty=1)·t_prd_product_bundle_qtys 0행"}
- 본문: 상품레벨 수량규칙(min1·max10000·incr1·QTY_UNIT.01)만·별도 묶음수 행 없음(pack §3.4 고정가형=수량축 보유이나 현재 규격당 단일 밴드). base comp COMP_POSTER_LINEN_WOODBONG use_dims에 min_qty가 선언돼 향후 수량 구간 확장 가능(현재 min_qty=1 단일). 값 계산=엔진.

---

## 정직 GAP (원천 부재·미해소)

### [gap-134-woodbong-addon] 우드봉 부속(PRD_000013) addon/set 미연결 — 가격은 배선·물리 부속은 미결 (pack §3.12·GAP-SL-4) {unknown}
- type: gap
- anchor: none  # 사유: 우드봉+면끈 추가의 가격은 comp(COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG·opt_cd 키)로 배선됐으나, 물리 부속(우드봉 반제품 PRD_000013)과의 addon/set 관계 적재 위치·방향이 미결(라이브 addons=0·sets=0·인간 승인 대기)
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "테이블:t_prd_product_addons PRD_000134=0행(우드봉 부속 addon 미연결)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items (PRD_000134,OPV_000430)=행 없음(우드봉 옵션값 bare·ref_dim 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.12 부속붙는 8상품(134→우드봉013·부속 PRD_000013 실재·search-before-mint 충족·라이브 addon/set 0행 잔존)·[GAP-SL-4]·§4 SL-DEF-005", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "린넨 우드봉 족자134의 우드봉+면끈 추가는 가격 comp(COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG·opt_cd OPV_000430)로 견적 가능하나, 물리 부속(우드봉 반제품 PRD_000013·실재)과의 addon(t_prd_product_addons) 또는 set(t_prd_product_sets) 관계가 미연결(0행). 우드봉 옵션값(OPV_000430)도 option_item ref_dim 없는 bare 값이다. 부속을 addon으로 연결할지·옵션값을 부속 PRD로 참조시킬지 미결"
- gap_fill_from: "실무진 Q-SL-4(부속·우드봉 귀속) + §7 dbmap/§23 셋트·§21 addon 정합 라이브 교정 인간 승인 후. 가격 경로 자체는 comp로 연결됨(견적 무영향)이나 부속 물리 연결은 잔존"
- gap_owner: staff
- rel: {rel: references, target: optgroup-134-OPT_000014, note: "우드봉+면끈 추가 옵션값(OPV_000430·bare)"}
- rel: {rel: references, target: component-COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG, note: "우드봉 추가가 단가행(opt_cd 키·가격 경로 완결)"}
- 본문: 가격 경로는 연결됨(priced_by→formula→base+우드봉 comp·O5/O6 충족). 이 GAP은 우드봉을 물리 부속(우드봉 반제품 PRD_000013)으로 잇는 addon/set 관계가 라이브에 미적재임을 정직 선언(단정 금지·라이브 소관). pack §4 SL-DEF-005(부속 addon/set 0행) 잔존과 동형(실사 부속붙는 8상품 공통 미교정). `has_addon`→product-우드봉 엣지는 부속 PRD 노드 부재로 만들지 않음(끊긴 링크 회피).
