<!-- companion nodes for product-124 린넨패브릭포스터 — 공유 축(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(052·125 방식). -->
<!-- ★실사 파일럿: 카테고리(CAT_000004/072)·봉제 공정(PROC_000080)은 형제 product-125-canvas가 이미 mint한 -->
<!--    공유 노드라 여기서 재정의 금지(reference만·L-3 중복 방지). 린넨 전용(면적공식 PRF_POSTER_LINEN· -->
<!--    구성요소 COMP_POSTER_LINEN_FABRIC/FINISH·린넨 자재 MAT_000607·봉제가공 PROC_000130·패브릭포스터 사이즈 -->
<!--    SIZ_000542~547·마감 옵션·nonspec 제약)만 신설→needed_shared_nodes로 승격 후보 반환. -->
<!-- ★수치(치수·nonspec 범위·면적 셀 행수·배선)는 transcribe_product_124.py 출력만(마커). 본 파일 수치=행수/코드뿐. -->

# product-124 전용 노드 (린넨패브릭포스터 — 실사 area-matrix + 봉제마감 전용 마스터 축)

[[product-124-linen-fabric-poster]]가 연결하는 축 중 **린넨 고유분**을 여기 신설한다. 공유 실사 축
(카테고리 CAT_000004 포스터·CAT_000072 패브릭포스터·봉제 PROC_000080)은 형제 [[product-125-canvas-fabric-poster]]가
선점 정의한 노드라 **reference만**(중복 mint 금지·향후 axis/formula 승격 시 canonical id 유지). 판형
(plate_size)은 실사 비종이류라 노드 없음(전 행 논리삭제·pack §3.8·T-7). 인쇄옵션(도수)도 없음(실사 대형
잉크젯 풀컬러·po=0). 전사 원표는 [[product-124-linen-fabric-poster]] 본문(transcribe_product_124.py)에 있다.

---

## 사이즈 (size) — 패브릭포스터 A계열 프리셋 6종 (07-01 신설·라벨 프리셋)

린넨124 활성 사이즈 = A3/A2/A1 세로·가로 프리셋 6종(SIZ_000542~547·tags=["패브릭포스터"]·07-01 신설).
`t_siz_sizes.work_width/height` 공백(=라벨 프리셋)이고, 유효 가격격자는 면적매트릭스 (siz_width×siz_height)
셀이다(프리셋≠가격격자·pack §3.2). 구 SIZ_000295~301(실치수 보유)은 07-01 del_yn=Y로 교체됨(양면 아님·정리 완료).

### [size-SIZ_000542] A3세로 (297x420) 패브릭포스터 프리셋 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000542
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000542 siz_nm='A3세로 (297x420mm)'·work/cut 공백·tags=[패브릭포스터]·del_yn=N(07-01 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000124,SIZ_000542) disp 2·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {label_ref: "본문 전사표(A3세로 297x420mm)", 유형: "이산 규격 프리셋(work 치수 공백=라벨전용)"}
- 본문: A3세로 라벨 프리셋. 실 가격은 면적매트릭스 (siz_width×siz_height) 셀([[component-COMP_POSTER_LINEN_FABRIC]])이 결정한다.

### [size-SIZ_000543] A3가로 (420x297) 패브릭포스터 프리셋 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000543
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000543 siz_nm='A3가로 (420x297mm)'·work/cut 공백·tags=[패브릭포스터]·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000124,SIZ_000543) disp 3·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {label_ref: "본문 전사표(A3가로 420x297mm)", 유형: "이산 규격 프리셋"}
- 본문: A3가로 라벨 프리셋. 면적매트릭스 비대칭(가로≠세로 순서쌍이 다른 셀).

### [size-SIZ_000544] A2세로 (420x594) 패브릭포스터 프리셋 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000544
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000544 siz_nm='A2세로 (420x594mm)'·work/cut 공백·tags=[패브릭포스터]·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000124,SIZ_000544) disp 4·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {label_ref: "본문 전사표(A2세로 420x594mm)", 유형: "이산 규격 프리셋"}
- 본문: A2세로 라벨 프리셋.

### [size-SIZ_000545] A2가로 (594x420) 패브릭포스터 프리셋 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000545
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000545 siz_nm='A2가로(594x420mm)'·work/cut 공백·tags=[패브릭포스터]·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000124,SIZ_000545) disp 5·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {label_ref: "본문 전사표(A2가로 594x420mm)", 유형: "이산 규격 프리셋"}
- 본문: A2가로 라벨 프리셋.

### [size-SIZ_000546] A1세로 (594x841) 패브릭포스터 프리셋 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000546
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000546 siz_nm='A1세로(594x841mm)'·work/cut 공백·tags=[패브릭포스터]·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000124,SIZ_000546) disp 6·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {label_ref: "본문 전사표(A1세로 594x841mm)", 유형: "이산 규격 프리셋"}
- 본문: A1세로 라벨 프리셋.

### [size-SIZ_000547] A1가로 (841x594) 패브릭포스터 프리셋 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000547
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000547 siz_nm='A1가로 (841x594mm)'·work/cut 공백·tags=[패브릭포스터]·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000124,SIZ_000547) disp 7·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {label_ref: "본문 전사표(A1가로 841x594mm)", 유형: "이산 규격 프리셋"}
- 본문: A1가로 라벨 프리셋.

---

## 자재 (material) — 린넨(내추럴) 1종 (MAT_TYPE.05 특수소재)

실사 자재 = 소재별 본체 자재 단일(낱장 완제품·parent+usage_cd·pack §3.5). 활성 자재 = MAT_000607
린넨(내추럴)·부모 MAT_000184 린넨은 07-01 del_yn=Y로 교체됨. round-13 목표 라벨 '원단'(.05)은 MAT_TYPE
코드 개편으로 STALE(현재 .05=특수소재·T-2) — 값 `.05`는 현재값이자 개편 후 정답이라 자재유형 양면 아님.

### [material-MAT_000607] 린넨(내추럴) (MAT_TYPE.05 특수소재·활성) {verified}
- type: material
- anchor: t_mat_materials/MAT_000607
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000607 mat_nm='린넨(내추럴)'·mat_typ_cd=MAT_TYPE.05·upr_mat_cd=MAT_000184·use_yn=Y·del_yn=N(06-30 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000124,MAT_000607) usage_cd=USAGE.07·dflt_yn=Y·del_yn=N(부모 MAT_000184 행은 del_yn=Y 07-01 교체)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 자재유형 교정(린넨184=.05)·T-2(목표 라벨 원단=.05 STALE·현재 .05=특수소재)·§1.1", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_typ_cd: "MAT_TYPE.05", usage_cd: "USAGE.07", upr_mat_cd: "MAT_000184", 교체: "MAT_000184(del_yn=Y)→MAT_000607(07-01)"}
- 본문: 린넨(내추럴) 패브릭 본체 자재. 부모 MAT_000184 린넨(구)은 07-01 del_yn=Y 교체·현재 활성=자식 MAT_000607. MAT_TYPE 코드 개편(현재 .05=특수소재)으로 round-13 '원단'(.05) 목표 라벨은 STALE(T-2). ★면적매트릭스 가격은 자재 무관(코팅포함 통가격·mat_cd=NULL 셀·pack §3.10) — 자재는 소재 정체용. ★IMPORT 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 공정 (process) — 봉제가공(활성·PROC_000130) 신설 (봉제 PROC_000080은 형제 125 소유·reference)

패브릭은 소재가 완성형태라 봉제가 후가공(pack §3.6). 124 활성 공정 = PROC_000130 봉제가공(07-01 교체분·
upr=PROC_000080·param 없음). 봉제 param(유형 enum)의 원천 PROC_000080은 형제 [[product-125-canvas-fabric-poster]]가
정의한 공유 노드라 여기서 재정의 안 함(reference). ★124는 활성공정(130)과 옵션참조공정(080)이 어긋남=gap-124-finish-process.

### [process-PROC_000130] 봉제가공 (활성·mand=N·upr=PROC_000080·07-01 교체) {verified}
- type: process
- anchor: t_proc_processes/PROC_000130
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000130 proc_nm=봉제가공·upr_proc_cd=PROC_000080·prcs_dtl_opt 공백(param 없음)·use_yn=Y·del_yn=N(06-29 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:(PRD_000124,PROC_000130) mand_proc_yn=N(opt)·disp 1·del_yn=N(구 PROC_000080 행은 del_yn=Y 07-01 교체)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.6 패브릭=봉제 후가공·GAP-SL-2(봉제 variant 적재 위치)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mand_for_124: "N(opt)", upr_proc_cd: "PROC_000080", param: "없음(param은 부모 PROC_000080)"}
- 본문: 봉제가공(활성 후가공). 07-01 이전엔 부모 PROC_000080 봉제가 붙었으나(현재 그 junction 행 del_yn=Y) PROC_000130으로 교체됨. ★param(유형 오버로크/말아박기/봉미싱)은 PROC_000130이 아니라 부모 PROC_000080.prcs_dtl_opt에 있고, 마감 옵션도 여전히 PROC_000080을 참조 → 활성공정/옵션참조 mismatch([[gap-124-finish-process]]). 값 계산=엔진.

---

## 가격공식·구성요소 (실사 면적매트릭스 + 마감옵션 — 상품-local mint·needed_shared_node)

실사 = 면적매트릭스형 완제품가(포스터사인 [가로×세로] 셀단가·pack §3.10). 린넨124는 캔버스125(단일
구성요소)와 달리 **면적 베이스 + 봉제 마감옵션 단가** 2구성요소다. 디지털 원자합산·스티커 고정룩업과
다른 아키타입이라 린넨 전용 공식/구성요소를 여기 신설(면적매트릭스 실사 13상품 향후 승격 후보).

### [formula-PRF_POSTER_LINEN] 린넨패브릭포스터 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_LINEN
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_POSTER_LINEN frm_nm='린넨패브릭포스터 완제품가(면적/규격 단가)'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components 키:(PRF_POSTER_LINEN,COMP_POSTER_LINEN_FABRIC) disp_seq 1·addtn_yn=Y + (PRF_POSTER_LINEN,COMP_POSTEROPT_LINEN_FINISH) disp_seq 2·addtn_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·off-grid ceiling) + 마감옵션 가산", use_yn: Y}
- rel: {rel: has_component, target: component-COMP_POSTER_LINEN_FABRIC, qualifier: {disp_seq: 1, addtn: Y}, note: "면적매트릭스 완제품가(52셀·siz_width×siz_height 통가격)"}
- rel: {rel: has_component, target: component-COMP_POSTEROPT_LINEN_FINISH, qualifier: {disp_seq: 2, addtn: Y}, note: "봉제 마감 옵션 단가(opt_cd 매칭·가산)"}
- standards: {schema_org: "(Offer 계산 — schema.org 표현 불가)", note: "값 계산=evaluate_price 권위(D-18)·off-grid ceiling=앱"}
- 본문: 면적매트릭스형 = [가로×세로] 면적 셀단가 룩업(출력+소재+코팅 포함 통가격) + 봉제 마감 옵션 단가 가산. 고아 공식 아님(has_component 2개·O6 충족). off-grid=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행). 온톨로지는 배선까지, 값은 엔진.

### [component-COMP_POSTER_LINEN_FABRIC] 실사 완제품가 (린넨패브릭포스터·면적 셀·[단독]) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_LINEN_FABRIC
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTER_LINEN_FABRIC prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06(완제품비)·use_dims=[siz_width,siz_height]·note '[단독] 동형 없음·가격축 가로×세로 구간(52셀)'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTER_LINEN_FABRIC 52셀(siz_width×siz_height·값=본문 전사표 행수요약·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "문서:§1.2 B07 린넨패브릭포스터 PRD_000124↔COMP_POSTER_LINEN_FABRIC 52셀 (승계·재검증 2026-07-03 — live 매트릭스 룩업 모델만 승계·좌표회귀 T-4/round-2 sparse T-5 DROP)", captured_at: "2026-07-03", badge: verified, src_id: SR-mapping-silsa}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "본문 전사표 [siz_width,siz_height]", 셀행수_ref: "본문 전사표(52셀)", 결합: "[단독] 동형 없음(캔버스 동형결합과 대조)"}
- 본문: 린넨패브릭포스터 완제품가(출력+소재+코팅 포함 통가격)를 (가로×세로) 면적 셀로 저장(52셀·매트릭스 비대칭). ★캔버스 COMP_POSTER_CANVAS_FABRIC이 [동형결합] 4소재 통합인 것과 달리 린넨은 [단독](동형 없음). round-2 "단일 comp·2~6%만 적재" D-WIRE 오모델(T-5)과 다른 전건 적재. 단가행 실값 나열 아님(D-22 접기)·값 계산=evaluate_price 권위(off-grid ceiling=앱·D-18).

### [component-COMP_POSTEROPT_LINEN_FINISH] 린넨 마감가공비 (봉제 옵션 단가·opt_cd 매칭) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTEROPT_LINEN_FINISH
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_POSTEROPT_LINEN_FINISH prc_typ_cd=PRICE_TYPE.01·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[opt_cd,min_qty]·note '마감가공(오버로크/말아박기/봉미싱·복합) 옵션 단가·opt_cd 매칭'·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_POSTEROPT_LINEN_FINISH 5행(opt_cd=OPV-000024/OPV_000025/026/027/424·오버로크=무료 기본·값=본문 전사표 행수요약·D-22 접기)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims_ref: "본문 전사표 [opt_cd,min_qty]", 행수_ref: "본문 전사표(5행)", 매칭: "opt_cd(OPV-000024/OPV_000025/026/027/424)"}
- 본문: 봉제 마감(오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱) 옵션 단가를 opt_cd로 매칭해 면적 베이스가에 가산. 오버로크=무료 기본·나머지=가산(값=엔진·D-22 접기). 마감 옵션그룹 [[optgroup-124-OPT_000009]]의 손님 선택이 이 단가행을 고른다.

---

## 옵션그룹 (CPQ) — 마감(봉제) 1그룹 택1 선택 (5 variant 노출)

옵션 = 공정 BUNDLE(pack §3.9). 옵션참조(ref_dim_cd=OPT_REF_DIM.04 공정)는 같은 부모 prd_cd 차원에 실재
필수(`fn_chk_opt_item_ref`·L-18). 마감 옵션이 부모 has_process(PROC_000080)를 가리킴=정합. ★124는 캔버스125
(오버로크 1값만)와 달리 5 variant 전부 노출(오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱7cm).

### [optgroup-124-OPT_000009] 마감(봉제) 택1 선택 (min0/max1·mand=N·5 variant) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000124
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000124,OPT_000009) opt_grp_nm=마감·note='봉제 가공 (유형 param=GAP-PARAM)'·sel_typ=SEL_TYPE.01·min/max=0/1·mand_yn=N·use_yn=Y·disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000124,OPV-000024/OPV_000025/026/027/424) ref_dim_cd=OPT_REF_DIM.04(공정)·ref_key1=PROC_000080·dtl_opt 유형(오버로크+리본끈/오버로크/말아박기/봉미싱7cm/말아박기+면끈)·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "N", items: "5 variant(오버로크 무료 기본·리본끈/말아박기/면끈/봉미싱 가산)→PROC_000080"}
- rel: {rel: option_refs, target: process-PROC_000080, ref_key1: PROC_000080, note: "마감 5 variant(OPV-000024/OPV_000025/026/027/424·OPT_REF_DIM.04 공정·ref_key1=PROC_000080)"}
- 본문: 마감 옵션값(5 variant)이 부모 has_process(봉제 PROC_000080)를 가리킨다(L-18 정합·형제 125 optgroup-125-gagong 동형). 옵션=공정 BUNDLE(pack §3.9). 단가는 [[component-COMP_POSTEROPT_LINEN_FINISH]](opt_cd 매칭)가 가산. ★옵션이 참조하는 PROC_000080은 현재 상품 활성공정 PROC_000130과 어긋남([[gap-124-finish-process]]).

---

## 제약 (constraint) — nonspec 치수범위 1행 (신규 발현·pack §3.9)

### [constraint-124-size-range] 사용자입력 치수 범위 (RULE_001·nonspec 검증) {verified}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000124
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "테이블:t_prd_product_constraints 키:(PRD_000124,RULE_001) rule_nm='사용자입력 치수 범위'·rule_typ_cd=RULE_TYPE.01·use_yn=Y·err_msg '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요'·logic or/and(size_mode=nonspec 시 width/height 범위)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1·§3.9 실사 constraints 신규 발현 7상품(118/120/121/122/124/125/139 각 1행)·T-3(위키 0행 STALE)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {rule_typ_cd: "RULE_TYPE.01", logic_ref: "본문 전사(JSONLogic or/and·size_mode=nonspec 시 width 200~1200·height 200~3000)", CN유형: "범위/입력검증(nonspec)"}
- rel: {rel: constrains, target: product-124-linen-fabric-poster, note: "nonspec 입력 시 가로/세로 범위 검증(폼빌더 shape)"}
- 본문: nonspec(사용자입력) 치수 상품의 입력 범위 검증. ★pack §1.1 실사 constraints 신규 발현 7상품 중 124 1행(위키 "constraints 0행"은 STALE·T-3). logic은 폼빌더 정형 shape(raw JSONLogic escape hatch 아님·§31). evaluate_price는 제약 미참조(위젯/주문이 validate 호출해야 강제).

---

## 수량 (bundle_qty) — 상품레벨 규칙 (bundle_qtys 0행)

### [qty-124] 린넨패브릭포스터 수량규칙 (min1/max10000/incr1) {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000124
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000124(min_qty 1·max_qty 10000·qty_incr 1·qty_unit_typ_cd QTY_UNIT.01)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "테이블:t_prd_product_bundle_qtys PRD_000124=0행(별도 묶음수 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min1·max10000·incr1)", bdl_unit_typ_cd: "QTY_UNIT.01", note: "면적매트릭스 완제품이라 수량축 얕음·상품레벨 규칙만(t_prd_product_bundle_qtys 0행·pack §3.4)"}
- 본문: 상품레벨 수량규칙(min1·max10000·incr1·QTY_UNIT.01)만·별도 묶음수 행 없음. 면적매트릭스 base(COMP_POSTER_LINEN_FABRIC)는 수량 무관(pack §3.4·§3.10)이고, 마감 옵션 단가(FINISH)만 use_dims에 min_qty를 둔다.

---

## 정직 GAP (원천 부재·미해소)

### [gap-124-finish-process] 마감 옵션이 참조하는 공정(PROC_000080) vs 활성공정(PROC_000130) mismatch (GAP-SL-2) {unknown}
- type: gap
- anchor: none  # 사유: 07-01 봉제 공정 교체(PROC_000080→PROC_000130) 후 마감 옵션은 여전히 구 PROC_000080을 참조 — 어느 공정으로 정합시켜야 정답인지 미결(pack GAP-SL-2·라이브 교정 인간 승인 대기)
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:(PRD_000124,PROC_000130) del_yn=N 활성 vs (PRD_000124,PROC_000080) del_yn=Y 교체됨", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 124 마감 옵션값 5개 전부 ref_key1=PROC_000080(교체된 구 공정 참조·param 원천)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.6·§5 [GAP-SL-2] 봉제/족자 variant 적재 위치(Q-SL-2)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "124 활성 공정은 PROC_000130(봉제가공·param 없음)인데 마감 옵션 5 variant는 모두 구 PROC_000080(봉제·param 유형 enum 원천·del_yn=Y로 junction 교체됨)을 참조한다. 옵션참조를 PROC_000130으로 재조준할지, PROC_000080을 다시 활성 공정으로 되돌릴지, param을 PROC_000130으로 이관할지 미결(적재 위치·정합 방향 불명)"
- gap_fill_from: "실무진 Q-SL-2(봉제 공정 교체 의도·variant/param 적재 위치) + §7 dbmap/§31 라이브 교정 인간 승인 후. L-18은 현재 PROC_000080 참조로 통과하나 활성공정 불일치는 잔존"
- gap_owner: staff
- rel: {rel: references, target: optgroup-124-OPT_000009, note: "마감 옵션(5 variant·PROC_000080 참조)"}
- rel: {rel: references, target: process-PROC_000130, note: "활성 공정(봉제가공·param 없음)"}
- 본문: 가격 경로 자체는 연결됨(priced_by→formula→FABRIC+FINISH·O5/O6 충족). 이 GAP은 봉제 공정 교체(07-01)와 옵션참조의 불일치를 정직 선언(단정 금지·라이브 소관). off-grid 롤 가격 계산 암묵지는 형제 [[gap-125-roll-price-logic]]와 동형(실사 전체 영향·source-registry §9 GAP-2)이라 별도 재mint 안 함(reference).
