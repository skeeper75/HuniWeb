<!-- axis page: E10 price_component — 아크릴 굿즈 계열 가격구성요소(마스터 t_prc_price_components). SA-3 Stage A 공유축(okb-knowledge-builder 260704·pack-acrylic §5.2). -->
<!-- ★use_dims=차원 선언(D-18 경계)·값 계산=evaluate_price 권위. 단가행(t_prc_component_prices)은 노드 미펼침·속성 접기(D-22·셀수/범위만·단가값 미전사 L-12). -->
<!-- ★면적매트릭스 본체 COMP_ACRYL_CLEAR3T = silsa 포스터사인 [가로×세로] off-grid ceiling 동형(pack §5.2 SA-3). 13상품 공유(M1/M2). -->
<!-- ★공식→구성요소 배선(has_component·R9)은 acrylic-formulas.md(각 PRF_* → COMP_*). 상품→공식(priced_by·R8)은 부모 상품 노드(Stage B). -->
<!-- ★substrate(두께)는 material 축(axis/materials.md MAT_000042/043/044)·부속(자석/집게/헤어끈)은 부자재. 여기 comp는 가격구성요소만. -->

# 축: 아크릴 굿즈 가격구성요소 (price_component — 아크릴 계열)

아크릴 굿즈(146~166·226)의 가격구성요소. **★t_prd_product_prices(직접단가룩업)=0행 — 아크릴은
전량 공식기반**(gap-goods-fixed-lookup 아키타입 아님·pack T-7). 구성요소 3형:
- **면적매트릭스 본체** `COMP_ACRYL_CLEAR3T`(PRICE_TYPE.02·use_dims `[mat_cd,siz_width,siz_height,min_qty]`·
  277 단가행·2,000~32,700·13상품 공유). silsa 포스터사인 면적매트릭스와 동형(off-grid=한 단계 큰
  규격 ceiling·앱 계산·[[../product/product-118-artprint-poster]] 참조).
- **고정가형 by-siz** `COMP_ACRYL_{NAMETAG_GS,BALLPEN,FREESTAND,CARABINER,MINIPART_TBD}`
  (use_dims `[siz_cd,min_qty]`·단가행 1~5셀). ★직접단가룩업 아님 — component_prices 기반 공식.
- **부속 단일가** `COMP_ACRYL_{MAGNET,CLIP,BLACK_HAIR_BAND,ZIBITZ}`(PRICE_TYPE.01·use_dims
  `[opt_cd,min_qty,opt_grp:*]`·1~2셀)·**코롯토 면적** `COMP_ACRYL_COROTTO`(PRICE_TYPE.01·`[siz_width,siz_height]`·36셀).
- **TBD placeholder** `COMP_ACRYL_PENDING_TBD`(use_dims `[min_qty]`·**0 단가행**=견적 원천 부재·
  165/168/169/170 공유)·`COMP_ACRYL_MINIPART_TBD`(163·1셀 placeholder 10,000).

★use_dims는 **차원 선언까지만** — 값 계산은 `evaluate_price` 단일 권위(온톨로지 밖·D-18). 단가행
셀수·가격범위만 결정론 전사(단가값 미전사 L-12·D-22). 값 인용 금지·엔진 권위.

<!-- transcribed-by: 01_curation/_cache/acryl-price-chain-260704.csv (07-04 라이브 신규 SELECT·H-1 회피·snapshot 가격 정본 금지 T-2) @ 2026-07-04 (셀수·범위만·단가값 미전사) -->
<!-- 구조 존재/anchor: live-snapshot/latest t_prc_price_components.csv (snap_20260702_1119·12 comp 전수 실재) -->

## 면적매트릭스 본체 (13상품 공유·silsa 동형)

### [component-COMP_ACRYL_CLEAR3T] 컬러아크릴 본체 면적단가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_CLEAR3T
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_CLEAR3T·prc_typ PRICE_TYPE.02·use_dims [mat_cd,siz_width,siz_height,min_qty]·price_rows 277·범위 2000~32700", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_CLEAR3T(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "siz_width", "siz_height", "min_qty"]', 단가행: "277셀(2,000~32,700·D-22 접기·값 미전사)", archetype: "면적매트릭스(silsa 동형)", role: "컬러아크릴 본체(두께 mat_cd×면적 W×H×수량 티어). 13상품 공유(148·150·151·152·157·158·159·161·162 + 146/147/149/154 본체). off-grid=ceiling(엔진). 판형 미참조(T-9)."}

## 고정가형 by-siz 완제품가

### [component-COMP_ACRYL_NAMETAG_GS] 골드/실버 명찰 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_NAMETAG_GS
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_NAMETAG_GS·prc_typ PRICE_TYPE.02·use_dims [siz_cd,min_qty]·price_rows 3·범위 3400~4700", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_NAMETAG_GS(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "min_qty"]', 단가행: "3셀(3,400~4,700)", archetype: "고정가형 by-siz(직접룩업 아님·T-7)", role: "153 명찰(골드/실버) 완제품가. PRF_ACRYL_NAMETAG_GS 배선."}

### [component-COMP_ACRYL_BALLPEN] 아크릴볼펜 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_BALLPEN
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_BALLPEN·prc_typ PRICE_TYPE.02·use_dims [siz_cd,min_qty]·price_rows 3·범위 1800~2700", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_BALLPEN(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "min_qty"]', 단가행: "3셀(1,800~2,700)", archetype: "고정가형 by-siz", role: "155 아크릴볼펜 완제품가. PRF_ACRYL_BALLPEN 배선."}

### [component-COMP_ACRYL_FREESTAND] 자유형스탠드 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_FREESTAND
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_FREESTAND·prc_typ PRICE_TYPE.02·use_dims [siz_cd,min_qty]·price_rows 5·범위 8800~22600", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_FREESTAND(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "min_qty"]', 단가행: "5셀(8,800~22,600)", archetype: "고정가형 by-siz", role: "160 아크릴자유형스탠드 완제품가. PRF_ACRYL_FREESTAND 배선."}

### [component-COMP_ACRYL_CARABINER] 카라비너 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_CARABINER
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_CARABINER·prc_typ PRICE_TYPE.02·use_dims [siz_cd,min_qty]·price_rows 4·범위 5800~6900", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_CARABINER(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "min_qty"]', 단가행: "4셀(5,800~6,900)", archetype: "고정가형 by-siz", role: "166 아크릴카라비너 완제품가(완전 미적재 해소 R1). PRF_ACRYL_CARABINER 배선."}

### [component-COMP_ACRYL_MINIPART_TBD] 미니파츠 완제품가(placeholder) {candidate}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_MINIPART_TBD
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_MINIPART_TBD·prc_typ PRICE_TYPE.02·use_dims [siz_cd,min_qty]·price_rows 1·값 10000(placeholder)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_MINIPART_TBD(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "163 단가행 1셀=placeholder 10,000(note '단가 미정')·실단가 실무진 대기. 양면: current_value 10,000 / authority 미정"}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(placeholder 10,000·TBD)", archetype: "고정가형 by-siz(placeholder)", role: "163 아크릴미니파츠 완제품가. 단가 placeholder(실무진 확정 후 교체). PRF_ACRYL_MINIPART 배선."}

## 부속 단일가 (M2 면적+부속선택)

### [component-COMP_ACRYL_MAGNET] 자석 부속단가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_MAGNET
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_MAGNET·prc_typ PRICE_TYPE.01·use_dims [opt_cd,min_qty,opt_grp:OPT_000074]·price_rows 1·값 800", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_MAGNET(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "min_qty", "opt_grp:OPT_000074"]', 단가행: "1셀(800)", archetype: "부속 단일가(옵션선택)", role: "147 아크릴마그넷 자석 부속. 본체(CLEAR3T) + 이 부속 별도합산. PRF_ACRYL_MAGNET 배선. 부속 이중표현 양면(옵션구성요소 vs addon TMPL-000014·GAP-AC-6)."}

### [component-COMP_ACRYL_CLIP] 집게 부속단가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_CLIP
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_CLIP·prc_typ PRICE_TYPE.01·use_dims [opt_cd,min_qty,opt_grp:OPT_000076]·price_rows 1·값 700", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_CLIP(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "min_qty", "opt_grp:OPT_000076"]', 단가행: "1셀(700)", archetype: "부속 단일가(옵션선택)", role: "149 아크릴집게 부속. 본체 + 부속 별도합산. PRF_ACRYL_CLIP 배선. addon TMPL-000021 이중표현(GAP-AC-6)."}

### [component-COMP_ACRYL_BLACK_HAIR_BAND] 블랙헤어끈 부속단가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_BLACK_HAIR_BAND
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_BLACK_HAIR_BAND·prc_typ PRICE_TYPE.01·use_dims [opt_cd,min_qty,opt_grp:OPT-000014]·price_rows 1·값 500", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_BLACK_HAIR_BAND(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "min_qty", "opt_grp:OPT-000014"]', 단가행: "1셀(500)", archetype: "부속 단일가(옵션선택)", role: "154 아크릴머리끈 블랙헤어끈 부속. 본체 + 부속 별도합산. PRF_ACRYL_HAIRBAND 배선. addon TMPL-000026 이중표현(GAP-AC-6). ★opt_grp=OPT-000014(하이픈·verbatim)."}

### [component-COMP_ACRYL_ZIBITZ] 지비츠 가공 부속단가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_ZIBITZ
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_ZIBITZ·prc_typ PRICE_TYPE.01·use_dims [opt_cd,min_qty,opt_grp:OPT_000083]·price_rows 2·범위 200~600", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_ZIBITZ(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["opt_cd", "min_qty", "opt_grp:OPT_000083"]', 단가행: "2셀(200~600)", archetype: "부속선택 공식(가공 택1)", role: "156 아크릴지비츠 가공 부속(OPT_000083 택1). PRF_ZIBITZ_ACRYL 배선. 171(del_yn=Y)도 동일 공식 참조했으나 상품 노드 미생성(T-10)."}

## 코롯토 면적공식

### [component-COMP_ACRYL_COROTTO] 코롯토 면적단가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_COROTTO
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_COROTTO·prc_typ PRICE_TYPE.01·use_dims [siz_width,siz_height]·price_rows 36·범위 3600~8400", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_COROTTO(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["siz_width", "siz_height"]', 단가행: "36셀(3,600~8,400)", archetype: "면적공식(W×H·수량 티어 없음)", role: "164 아크릴코롯토 완제품가(고아 formula 해소). 미출시(use_yn=N). PRF_COROTTO_ACRYL 배선."}

## TBD placeholder (0 단가행·견적 원천 부재)

### [component-COMP_ACRYL_PENDING_TBD] 아크릴 TBD 미설정 구성요소 {candidate}
- type: price_component
- anchor: t_prc_price_components/COMP_ACRYL_PENDING_TBD
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "comp:COMP_ACRYL_PENDING_TBD·prc_typ PRICE_TYPE.02·use_dims [min_qty]·price_rows 0(견적 원천 부재)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_ACRYL_PENDING_TBD(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "0 단가행=견적 불가. 165/168/169/170 공유(4 TBD 공식이 이 comp 배선). 전부 미출시(use_yn=N)·실무진 단가 BLOCKED"}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["min_qty"]', 단가행: "0셀(★견적 원천 부재)", archetype: "TBD placeholder", role: "165/168/169/170 공유 미설정 구성요소. PRF_ACRYL_{PHCOROTTO,3DCOROTTO,3DBLOCK,SHAKER}_TBD가 has_component. 단가행 0=견적 불가(gap-acryl-tbd)."}
