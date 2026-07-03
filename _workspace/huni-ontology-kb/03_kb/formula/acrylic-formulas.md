<!-- axis page: E9 price_formula — 아크릴 굿즈 계열 가격공식(마스터 t_prc_price_formulas). SA-3 Stage A 공유축(okb-knowledge-builder 260704·pack-acrylic §5.2). -->
<!-- ★아크릴 = 전량 공식기반(t_prd_product_prices 0행·gap-goods-fixed-lookup 아키타입 아님·pack T-7). 값 계산=evaluate_price 단일 권위(D-18). -->
<!-- ★공식→구성요소 배선(has_component·R9)=t_prc_formula_components 전사(acryl-price-chain-260704.csv). 상품→공식(priced_by·R8)=부모 상품 노드(Stage B). -->
<!-- ★면적매트릭스 본체 PRF_CLR_ACRYL(COMP_ACRYL_CLEAR3T)=silsa 포스터사인 동형. M2(자석/집게/헤어끈)=본체+부속 별도합산(2 has_component). -->
<!-- ★TBD 4공식(PRF_ACRYL_*_TBD)=COMP_ACRYL_PENDING_TBD 0단가행=견적불가→gap-acryl-tbd-formula-no-priced-rows references(O5 충족·slug에 'tbd' 포함). -->

# 축: 아크릴 굿즈 가격공식 (price_formula — 아크릴 계열)

아크릴 굿즈(146~166·226)의 가격공식. **★t_prd_product_prices(직접단가룩업)=0행 — 전량 공식기반**
(pack T-7). 가격모델 4+gap:
- **M1 면적매트릭스 본체** `PRF_CLR_ACRYL`→`COMP_ACRYL_CLEAR3T`(277셀·silsa 동형·off-grid ceiling).
- **M2 면적+부속선택** `PRF_ACRYL_{MAGNET,CLIP,HAIRBAND}`→본체 `COMP_ACRYL_CLEAR3T` + 부속
  `COMP_ACRYL_{MAGNET,CLIP,BLACK_HAIR_BAND}`(2 has_component·본체 면적가 + 부속 별도합산).
- **M3 고정가형 by-siz** `PRF_ACRYL_{NAMETAG_GS,BALLPEN,FREESTAND,CARABINER}`→`COMP_*`(`[siz_cd,min_qty]`).
  ★직접단가룩업 아님(T-7). 226=`PRF_GOODS_FIXED_SIZ`(굿즈 공유·이미 존재·[[formula-PRF_GOODS_FIXED_SIZ]] 재사용).
- **M4 부속선택 공식** `PRF_ZIBITZ_ACRYL`(가공 택1)·`PRF_ACRYL_MINIPART`(163 placeholder).
- **M5 코롯토 면적공식** `PRF_COROTTO_ACRYL`→`COMP_ACRYL_COROTTO`(36셀·W×H).
- **★GAP TBD** `PRF_ACRYL_{PHCOROTTO,3DCOROTTO,3DBLOCK,SHAKER}_TBD`→`COMP_ACRYL_PENDING_TBD`(0셀·견적불가).

★온톨로지는 priced_by(공식)·has_component·use_dims 차원 선언까지만 — 값 계산은 `evaluate_price`
권위(KB 밖·D-18·단가값 미전사 L-12). off-grid=ceiling(엔진 소관).

<!-- transcribed-by: 01_curation/_cache/acryl-price-chain-260704.csv + acryl-prod-formulas-260704.csv (07-04 라이브 신규 SELECT·H-1 회피 T-2) @ 2026-07-04 -->
<!-- 구조 존재/anchor: live-snapshot/latest t_prc_price_formulas.csv (snap_20260702_1119·15 공식 전수 실재) -->

## M1 면적매트릭스 본체 (silsa 동형)

### [formula-PRF_CLR_ACRYL] 컬러아크릴 면적매트릭스 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_CLR_ACRYL
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적 277셀)·상품 146/148/150/151/152/157/158/159/161/162", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_CLR_ACRYL(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_CLEAR3T}
- props: {archetype: "면적매트릭스(silsa 동형·off-grid ceiling)", prc_typ: "면적 W×H×두께×수량", note: "컬러아크릴 본체 면적공식. 146/148/150/151/152/157/158/159(미출시)/161/162 공유(priced_by는 각 상품 Stage B). silsa 포스터사인 [가로×세로] 동형. 판형 미참조(T-9)."}

## M2 면적+부속선택 (본체 + 부속 별도합산)

### [formula-PRF_ACRYL_MAGNET] 아크릴마그넷(본체+자석) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_MAGNET
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_MAGNET→COMP_ACRYL_CLEAR3T(277) + COMP_ACRYL_MAGNET(800)·상품 147", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_MAGNET(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_CLEAR3T}
- rel: {rel: has_component, target: component-COMP_ACRYL_MAGNET}
- props: {archetype: "면적+부속선택", prc_typ: "본체 면적가 + 자석 별도합산", note: "147 아크릴마그넷. 본체(CLEAR3T 면적) + 자석(COMP_ACRYL_MAGNET 800·OPT_000074 택1). 부속 이중표현 양면(addon TMPL-000014·GAP-AC-6)."}

### [formula-PRF_ACRYL_CLIP] 아크릴집게(본체+집게) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_CLIP
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_CLIP→COMP_ACRYL_CLEAR3T(277) + COMP_ACRYL_CLIP(700)·상품 149", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_CLIP(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_CLEAR3T}
- rel: {rel: has_component, target: component-COMP_ACRYL_CLIP}
- props: {archetype: "면적+부속선택", prc_typ: "본체 면적가 + 집게 별도합산", note: "149 아크릴집게. 본체 + 집게(COMP_ACRYL_CLIP 700·OPT_000076 택1). addon TMPL-000021 이중표현(GAP-AC-6)."}

### [formula-PRF_ACRYL_HAIRBAND] 아크릴머리끈(본체+헤어끈) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_HAIRBAND
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_HAIRBAND→COMP_ACRYL_CLEAR3T(277) + COMP_ACRYL_BLACK_HAIR_BAND(500)·상품 154", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_HAIRBAND(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_CLEAR3T}
- rel: {rel: has_component, target: component-COMP_ACRYL_BLACK_HAIR_BAND}
- props: {archetype: "면적+부속선택", prc_typ: "본체 면적가 + 헤어끈 별도합산", note: "154 아크릴머리끈. 본체 + 블랙헤어끈(COMP_ACRYL_BLACK_HAIR_BAND 500·OPT-000014 택1). addon TMPL-000026 이중표현(GAP-AC-6)."}

## M3 고정가형 by-siz (직접룩업 아님·T-7)

### [formula-PRF_ACRYL_NAMETAG_GS] 골드/실버 명찰 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_NAMETAG_GS
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_NAMETAG_GS→COMP_ACRYL_NAMETAG_GS(3셀 3400~4700)·상품 153", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_NAMETAG_GS(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_NAMETAG_GS}
- props: {archetype: "고정가형 by-siz(견적불가 해소)", prc_typ: "siz_cd 룩업", note: "153 명찰(골드/실버). 직접단가룩업 아님(component_prices 기반·T-7)."}

### [formula-PRF_ACRYL_BALLPEN] 아크릴볼펜 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_BALLPEN
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_BALLPEN→COMP_ACRYL_BALLPEN(3셀 1800~2700)·상품 155", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_BALLPEN(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_BALLPEN}
- props: {archetype: "고정가형 by-siz(견적불가 해소)", prc_typ: "siz_cd 룩업", note: "155 아크릴볼펜. component_prices 기반(T-7)."}

### [formula-PRF_ACRYL_FREESTAND] 자유형스탠드 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_FREESTAND
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_FREESTAND→COMP_ACRYL_FREESTAND(5셀 8800~22600)·상품 160", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_FREESTAND(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_FREESTAND}
- props: {archetype: "고정가형 by-siz(견적불가 해소)", prc_typ: "siz_cd 룩업", note: "160 아크릴자유형스탠드. component_prices 기반(T-7)."}

### [formula-PRF_ACRYL_CARABINER] 카라비너 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_CARABINER
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_CARABINER→COMP_ACRYL_CARABINER(4셀 5800~6900)·상품 166", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_CARABINER(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_CARABINER}
- props: {archetype: "고정가형 by-siz(완전 미적재 해소·R1)", prc_typ: "siz_cd 룩업", note: "166 아크릴카라비너. component_prices 기반(T-7)."}

## M4 부속선택 공식

### [formula-PRF_ZIBITZ_ACRYL] 아크릴지비츠 가공선택 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ZIBITZ_ACRYL
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ZIBITZ_ACRYL→COMP_ACRYL_ZIBITZ(2셀 200~600·OPT_000083)·상품 156(171 del)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ZIBITZ_ACRYL(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_ZIBITZ}
- props: {archetype: "부속선택 공식(가공 택1)", prc_typ: "opt_cd 룩업(OPT_000083)", note: "156 아크릴지비츠. 171(del_yn=Y)도 동일 공식 참조했으나 상품 노드 미생성(T-10)."}

### [formula-PRF_ACRYL_MINIPART] 아크릴미니파츠 고정가(placeholder) {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_MINIPART
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_MINIPART→COMP_ACRYL_MINIPART_TBD(1셀 placeholder 10000)·상품 163", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_MINIPART(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_MINIPART_TBD}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "163 단가행 1셀=placeholder 10,000(단가 미정)·실무진 확정 후 실단가 교체"}
- props: {archetype: "고정가형 by-siz(placeholder)", prc_typ: "siz_cd 룩업(placeholder)", note: "163 아크릴미니파츠. 단가 placeholder(TBD·양면)."}

## M5 코롯토 면적공식

### [formula-PRF_COROTTO_ACRYL] 아크릴코롯토 면적공식 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_COROTTO_ACRYL
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_COROTTO_ACRYL→COMP_ACRYL_COROTTO(36셀 3600~8400·W×H)·상품 164(미출시)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_COROTTO_ACRYL(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_COROTTO}
- props: {archetype: "면적공식(W×H)", prc_typ: "siz_width×siz_height", note: "164 아크릴코롯토(고아 formula 해소). 미출시(use_yn=N·priced_by는 Stage B)."}

## GAP TBD (0 단가행·견적 원천 부재·전부 미출시)

### [formula-PRF_ACRYL_PHCOROTTO_TBD] 포카코롯토 TBD {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_PHCOROTTO_TBD
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_PHCOROTTO_TBD→COMP_ACRYL_PENDING_TBD(0셀)·상품 165(미출시)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_PHCOROTTO_TBD(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_PENDING_TBD}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "공식 바인딩됨·COMP_ACRYL_PENDING_TBD 0단가행=견적불가. 165 미출시·실무진 단가 BLOCKED"}
- props: {archetype: "TBD(단가행 0)", note: "165 아크릴포카코롯토. 공식 바인딩됐으나 단가 원천 부재(gap-acryl-tbd)."}

### [formula-PRF_ACRYL_3DCOROTTO_TBD] 입체코롯토 TBD {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_3DCOROTTO_TBD
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_3DCOROTTO_TBD→COMP_ACRYL_PENDING_TBD(0셀)·상품 168(미출시)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_3DCOROTTO_TBD(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_PENDING_TBD}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "0단가행=견적불가. 168 미출시·실무진 단가 BLOCKED"}
- props: {archetype: "TBD(단가행 0)", note: "168 아크릴입체코롯토. 단가 원천 부재(gap-acryl-tbd)."}

### [formula-PRF_ACRYL_3DBLOCK_TBD] 입체블럭 TBD {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_3DBLOCK_TBD
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_3DBLOCK_TBD→COMP_ACRYL_PENDING_TBD(0셀)·상품 169(미출시)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_3DBLOCK_TBD(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_PENDING_TBD}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "0단가행=견적불가. 169 미출시·실무진 단가 BLOCKED(가공공정 PROC_000083 1행만 실재)"}
- props: {archetype: "TBD(단가행 0)", note: "169 아크릴입체블럭. 단가 원천 부재(gap-acryl-tbd)."}

### [formula-PRF_ACRYL_SHAKER_TBD] 쉐이커 TBD {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_ACRYL_SHAKER_TBD
- src: {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "frm:PRF_ACRYL_SHAKER_TBD→COMP_ACRYL_PENDING_TBD(0셀)·상품 170(미출시)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_ACRYL_SHAKER_TBD(구조 존재·anchor)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_ACRYL_PENDING_TBD}
- rel: {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "0단가행=견적불가. 170 미출시·실무진 단가 BLOCKED. ★226 아크릴쉐이커코롯토는 07-04 라이브 PRF_GOODS_FIXED_SIZ로 재바인딩(별개·이 공식 아님)"}
- props: {archetype: "TBD(단가행 0)", note: "170 아크릴쉐이커. 단가 원천 부재(gap-acryl-tbd)."}

---

## SA-5 부속 addon 템플릿 카탈로그 (참조 전용·노드 미신설·schema §1.1 R14 doc-fold)

<!-- ★schema §1.1·R14: t_prd_templates·t_prd_product_addons는 별도 노드 유형 미신설(product→product has_addon으로 표현·template는 문서 접기). -->
<!-- 아크릴 부속(볼체인/자석/집게/바디/핀/헤어끈)은 판매 universe 상품이 아니라 t_prd_templates 부자재라 has_addon 대상 product 노드가 없다. -->
<!-- → Stage B 상품 노드가 props(addon_templates)로 이 카탈로그를 인용(노드 미신설·값 verbatim=cache). 부속 이중표현(옵션구성요소 vs addon)=GAP-AC-6. -->

> {transcribed-by `01_curation/_cache/acryl-addon-templates-260704.csv`·`acryl-addons-detail-260704.csv` @ 2026-07-04}

| tmpl_cd | 부속명 | 단가(원) | 소비 상품(prd_cd) |
|---|---|---|---|
| TMPL-000056 | 칼라볼체인(오렌지) 3개1팩 | 1,000 | 146 |
| TMPL-000057 | 칼라볼체인(핑크) 3개1팩 | 1,000 | 146 |
| TMPL-000058 | 칼라볼체인(민트그린) 3개1팩 | 1,000 | 146 |
| TMPL-000059 | 칼라볼체인(바이올렛) 3개1팩 | 1,000 | 146 |
| TMPL-000060 | 칼라볼체인(블루) 3개1팩 | 1,000 | 146 |
| TMPL-000061 | 칼라볼체인(핫핑크) 3개1팩 | 1,000 | 146 |
| TMPL-000062 | 칼라볼체인(화이트) 3개1팩 | 1,000 | 146 |
| TMPL-000063 | 칼라볼체인(블랙) 3개1팩 | 1,000 | 146 |
| TMPL-000014 | 자석부착(네오디움12mm) | 800 | 147 (옵션구성요소 COMP_ACRYL_MAGNET 이중표현) |
| TMPL-000019 | 원형핀 | 600 | 148 |
| TMPL-000020 | 1구자석 | 1,000 | 148 |
| TMPL-000021 | 투명집게 | 700 | 149 (옵션구성요소 COMP_ACRYL_CLIP 이중표현) |
| TMPL-000022 | 화이트바디 | 2,600 | 150 |
| TMPL-000023 | 투명바디 | 3,000 | 150 |
| TMPL-000024 | 일자핀 | 700 | 152 |
| TMPL-000025 | 2구자석 | 1,700 | 152 |
| TMPL-000026 | 블랙머리끈 | 500 | 154 (옵션구성요소 COMP_ACRYL_BLACK_HAIR_BAND 이중표현) |

> **Stage B 지침:** 146 볼체인 8종은 손님 선택 부속(택1·always-add 아님)·본체 면적가와 별도. 147/149/154는
> addon 템플릿과 옵션구성요소가 **이중 표현**(GAP-AC-6) — priced_by 공식(has_component)이 우선 배선이고
> addon은 props로 병기. always-add 부속(use_dims에 opt_cd 미포함) silent 가산 가드 주의(pack §3.12).
