<!-- product-local sub-nodes: E2 category·E3 size·E9 price_formula·E10 price_component·gap for PRD_000132 레더아트액자(실사 고정가형 파일럿 첫 상품). -->
<!-- ★실사 고정가형 첫 상품이라 공유 axis(categories/sizes)·formula/component 파일에 이 노드가 아직 없다 — 공유 축 파일 수정 금지 규칙 때문에 여기 임시 거처(126/122 선례). -->
<!--   축 소유자가 승격 시 canonical id 그대로 이관 — index_entries/needed_shared로 반환. -->
<!-- ★수치(치수·격자·단가범위)는 [[product-132-leather-art-frame]] 본문 전사표(transcribed-by)에만. 여기 노드는 코드·구조·출처만. -->

# product-132-leather-art-frame 하위 노드 (레더아트액자 PRD_000132 전용 축 원자)

레더아트액자(PRD_000132)가 쓰는 사이즈 6(고정 규격 preset)·가격공식 1·가격구성요소 1(132 전용)·GAP 3.
(카테고리 CAT_000080·규칙·SOT·레더 자재·공유 롤소재 GAP은 형제 빌더·공유 rule 축·형제 126·외부 메모리 재사용.)
상품→축 연결(in_category·has_size·priced_by·references)은 [[product-132-leather-art-frame]]가 건다. 수치 원본은 그 본문 전사표가 권위.

## 카테고리 (재사용 — 재정의 금지·형제 빌더 소유)

> ★카테고리 **category-CAT_000080**(보드액자·부모 CAT_000004 포스터·lvl2)는 형제 실사 빌더 130 포맥스보드·
> 131 프레임리스우드액자가 이미 companion에 mint(보드액자군 공용 leaf). **재정의 금지**(L-3 중복 id 회피·
> 126이 COMP_POSTER_CANVAS_FABRIC를 125 재사용한 선례와 동일 원칙). [[product-132-leather-art-frame]]
> in_category→category-CAT_000080로 재사용. 라이브 실측: `(PRD_000132,CAT_000080) main_cat_yn=N·2026-06-19
> 재연결`(pack §1.1 카테고리 고아 CAT_000298 해소·T-1). 단일 canonical 승격은 needed_shared로 반환(축 소유자
> 이관·130/131/132 3중 mint를 단일 소유권으로 통합).

## 사이즈 노드 (고정 규격 preset 6종 — 축 승격 대기)

### [size-132-SIZ_000304] 5x5 127x127 (레더아트액자 규격 preset) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000304
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000132,SIZ_000304) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000304(5x5 127x127·work=cut·impos_yn=N·마스터 del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000304", note: "5x5(127×127) 액자 규격 preset·무여백(work=cut). nonspec_yn=N이라 이 규격이 곧 가격격자 siz_cd 축(룩업)"}
- 본문: 5x5 규격 preset 주문 사이즈([[product-132-leather-art-frame]] has_size). 고정 규격 룩업(자유입력 없음).

### [size-132-SIZ_000306] 5x7 127x178 (레더아트액자 규격 preset) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000306
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000132,SIZ_000306) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000306(5x7 127x178·work=cut·마스터 del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000306", note: "5x7(127×178) 액자 규격 preset·마스터 활성"}
- 본문: 5x7 규격 preset 주문 사이즈([[product-132-leather-art-frame]] has_size).

### [size-132-SIZ_000308] 8x8 203x203 (레더아트액자 규격 preset) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000308
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000132,SIZ_000308) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000308(8x8 203x203·work=cut·마스터 del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000308", note: "8x8(203×203) 액자 규격 preset·마스터 활성"}
- 본문: 8x8 규격 preset 주문 사이즈([[product-132-leather-art-frame]] has_size).

### [size-132-SIZ_000310] 8x10 203x254 (레더아트액자 규격 preset) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000310
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000132,SIZ_000310) 링크 del_yn=N dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000310(8x10 203x254·work=cut·마스터 del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000310", note: "8x10(203×254) 액자 규격 preset·마스터 활성"}
- 본문: 8x10 규격 preset 주문 사이즈([[product-132-leather-art-frame]] has_size).

> ★D-SILSA-INT-1 교정(fix-log-silsa-260703): A4(SIZ_000172)·A3(SIZ_000174)는 공용 마스터 코드라 정본
> `size-SIZ_000172`(product-047)·`size-SIZ_000174`(product-047)와 앵커 중복이었다. 단일소유권 계약대로 로컬
> preset size-132-SIZ_000172/174를 은퇴하고 [[product-132-leather-art-frame]] has_size를 정본으로 재지향(이미
> line 68이 "승격 시 canonical 병합"을 예고). 액자 전용 규격(SIZ_000304/306/308/310)은 정본 부재라 로컬 유지.

## 가격공식 노드 (실사 고정가형)

### [formula-PRF_POSTER_LEATHER_FRAME] 레더아트액자 완제품가(규격 단가 룩업) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_LEATHER_FRAME
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_LEATHER_FRAME(frm_nm=레더아트액자 완제품가(면적/규격 단가)·use_yn=Y·note 포스터사인 레더아트액자 소재/사이즈/수량별 완제품 통가격)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_LEATHER_FRAME → comp COMP_POSTER_LEATHER_FRAME(disp_seq=1·addtn_yn=Y) 1행·132 전용 바인딩 실측", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 고정가형 15상품 레더아트액자132·[수량×규격] 룩업·실사 inline price 권위 아님·면적매트릭스 아님(T-5 뭉뚱그림 주의)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {frm_cd: "PRF_POSTER_LEATHER_FRAME", use_yn: "Y", archetype: "고정가형(실사·규격(siz_cd)별 완제품 단가 룩업·통가격)", note: "★frm_nm에 '면적/규격 단가'라 적혔으나 실 격자는 규격(siz_cd) 룩업(면적 siz_width/height 아님) — 126 PRF_POSTER_LEATHER_AP(면적매트릭스)와 다른 아키타입. 값 계산=evaluate_price 권위(D-18). 온톨로지는 배선·차원 선언까지"}
- rel: {rel: has_component, target: component-COMP_POSTER_LEATHER_FRAME, qualifier: {disp_seq: 1, addtn: "Y"}, note: "132 전용 구성요소(다른 상품 미바인딩 실측·재사용 아님)"}
- 본문: 레더아트액자 고정가형 완제품가 공식([[product-132-leather-art-frame]] priced_by). has_component→[[component-COMP_POSTER_LEATHER_FRAME]]. 고아 공식 아님(O6 충족). 공유 formula 파일 미등재·승격 대기(needed_shared).

## 가격구성요소 노드 (132 전용·규격 룩업)

### [component-COMP_POSTER_LEATHER_FRAME] 레더아트액자 완제품가 (규격별 단가) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_POSTER_LEATHER_FRAME
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_LEATHER_FRAME(comp_nm=레더아트액자 완제품가·comp_typ_cd=PRC_COMPONENT_TYPE.06·prc_typ_cd=PRICE_TYPE.01·use_dims=[siz_cd,min_qty]·use_yn=Y·del_yn=N·note '포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_LEATHER_FRAME 6행(siz_cd별 1행·min_qty=1 단일 tier·단가 9000~21000·clr/mat/coat/bdl 공란)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10·§3.11 고정가형 comp·규격별 단가행·§3.4 고정가형 수량축(단 132 격자는 단일 tier)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {comp_cd: "COMP_POSTER_LEATHER_FRAME", prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: "[siz_cd, min_qty]", note: "★고정가형=규격(siz_cd) 룩업 단가(6행·규격당 1행). 면적매트릭스(126 siz_width/height 52셀) 아님. note '소재+출력+가공 포함 통가격'이라 레더 소재비가 이 단가에 흡수됐을 가능성(자재 0행 이유 후보·gap-132-material-unwired). min_qty use_dims 선언되나 격자는 min_qty=1 단일 tier(gap-132-qty-tier). 단가행 D-22 접기(본문 전사표 고정가 단가행 요약이 집계 권위·값=evaluate_price)"}
- 본문: 132 규격별 고정 단가 구성요소([[formula-PRF_POSTER_LEATHER_FRAME]] has_component). 6 규격(A4/A3/5x5/5x7/8x8/8x10) 격자 완전 충전(siz_cd 룩업). 132 전용(다른 공식 미바인딩). 공유 component 파일 미등재·승격 대기(needed_shared).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-132-material-unwired] 레더 소재 미배선 (자재 0행·통가격 흡수 vs 결함 AMBIGUOUS) {unknown}
- type: gap
- anchor: none  # 사유: 상품명 "레더"인데 product_materials 0행 — 통가격 소재비 흡수인지 BOM 미배선 결함인지 판정 원천 부재(AMBIGUOUS)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "PRD_000132 0행(레더 MAT_000186 미배선)·MAT_000186 crosscut=100/126/296/298(132 미포함)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.5 보드/우드 5상품 소재 L1 빈값(원본 미명시 정당·AMBIGUOUS)·§3.10 고정가 comp note '소재+출력+가공 포함 통가격'", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "132 레더아트액자는 상품명이 레더인데 product_materials 0행 — 레더 자재(MAT_000186)가 BOM에 배선되지 않았다. 고정가 통가격(comp note '소재+출력+가공 포함')에 소재비가 흡수된 정당한 구조인지, 아니면 자재 미배선 결함(형제 126은 MAT_000186 배선)인지 미확정"
- gap_fill_from: "실무진(레더아트액자 소재 BOM 필요 여부)·검증 레인(§21 hcc-basedata·§26 무결성). 그 전까지 '결함'/'정당' 어느 쪽도 단정 금지(현재값=0행 관찰만)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_LEATHER_FRAME, note: "소재비를 흡수한 것으로 보이는 통가격 구성요소(소재+출력+가공 포함)"}
- 본문: 상품명 "레더"인데 자재 0행. 통가격 흡수 vs BOM 미배선 결함이 미결 — 지어내지 않고 GAP으로 등재(형제 126은 MAT_000186 배선·132는 미배선). 레더 자재 노드 자체는 [[product-126-leather-artprint-nodes#material-MAT_000186]]에 실재(재정의 안 함).

### [gap-132-frame-attribution] 액자 귀속 미결 (공정 액자가공 vs 부속 프레임 별매) {unknown}
- type: gap
- anchor: none  # 사유: 131/132 액자가 공정(액자가공)인지 부속(프레임 별매 addon/set)인지 round-13이 AMBIGUOUS로 남김(C-14)·판정 원천 부재
- src: {source_file: "_workspace/huni-dbmap/17_correctness/silsa/correction-manifest.md", source_locator: "C-14 액자 귀속 AMBIGUOUS(131/132 공정 vs 부속) (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: unknown, src_id: SR-13-identity}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.12 부속붙는 8상품·131/132 액자 귀속 미결(공정 액자가공 vs 부속 프레임 별매)·GAP-SL-4·라이브 addon=0·set=0 잔존", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "레더아트액자(132)의 '액자' 부분이 후가공 공정(액자가공)으로 통가격에 포함되는지, 아니면 프레임 별매 부속(t_prd_product_addons/sets)으로 표현될지 미결. 라이브 addon=0·set=0·process=0이라 현재는 어느 쪽도 배선 안 됨(통가격에 잠재적으로 포함)"
- gap_fill_from: "인간 승인·실무진(액자 프레임이 별매인지 통가격 포함인지)·pack §3.12 GAP-SL-4 부속 재연결 트랙. 그 전까지 공정/부속 단정 금지"
- gap_owner: staff
- 본문: 131/132 액자의 프레임 귀속(공정 vs 부속)이 round-13 AMBIGUOUS로 잔존(addon/set/process 전부 0행). 지어내지 않고 GAP으로 등재.

### [gap-132-qty-tier] min_qty 차원 선언 vs 단가행 단일 tier (수량 tier 역할 미확정) {unknown}
- type: gap
- anchor: none  # 사유: use_dims에 min_qty 선언되나 단가행 min_qty=1 단일 tier·수량 계단 가격 실재 여부 판정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_LEATHER_FRAME use_dims=[siz_cd,min_qty] vs t_prc_component_prices min_qty 전 6행 =1(단일 tier)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 고정가형 15상품은 [수량×규격] 블록이라 수량축 보유(단 132 격자는 min_qty=1 단일 tier·구간할인 0행)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "COMP_POSTER_LEATHER_FRAME use_dims가 min_qty를 차원으로 선언하나 라이브 단가행 min_qty는 전 6행 =1(단일 tier). pack §3.4는 고정가형이 [수량×규격] 수량축을 갖는다는데 132는 수량 tier가 1개뿐(구간할인 t_dsc_* 0행). 132 가격이 수량에 계단식(tier) 영향을 받는지, 아니면 flat×qty인지 미확정"
- gap_fill_from: "검증 레인(§26 무결성/§21 hcc-price-engine) evaluate_price 실측 + 개발팀(use_dims 정합). 그 전까지 min_qty tier 가격영향 단정 금지"
- gap_owner: dev
- rel: {rel: references, target: component-COMP_POSTER_LEATHER_FRAME, note: "min_qty 차원 선언 주체(격자는 단일 tier)"}
- 본문: 고정가형은 수량축 보유가 원칙인데 132 격자는 min_qty=1 단일 tier(구간할인 0행). use_dims는 min_qty 선언 — 어긋남을 지어내지 않고 GAP으로 등재(수량 tier 실재/역할=검증·개발 레인).
