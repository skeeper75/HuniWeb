<!-- product-local sub-nodes: E2 category·E3 size·E4 material·E9 price_formula·E10 price_component·gap for PRD_000126 레더아트프린트(실사 면적매트릭스 파일럿 첫 상품). -->
<!-- ★실사 파일럿 첫 상품이라 공유 axis(materials/categories/sizes)·formula 파일에 실사 노드가 아직 없다 — 공유 축 파일 수정 금지 규칙 때문에 여기 임시 거처(051/054 선례). -->
<!--   축 소유자가 승격 시 canonical id 그대로 이관 — index_entries/needed_shared로 반환. -->
<!-- ★수치(치수·격자·단가범위)는 [[product-126-leather-artprint]] 본문 전사표(transcribed-by)에만. 여기 노드는 코드·구조·출처만. -->

# product-126-leather-artprint 하위 노드 (레더아트프린트 PRD_000126 전용 축 원자)

레더아트프린트(PRD_000126)가 쓰는 카테고리 1·사이즈 3·자재 1(레더)·가격공식 1·가격구성요소 1(동형결합)·
GAP 2. (규칙·SOT는 공유 rule 축·외부 메모리 재사용.) 상품→축 연결(in_category·has_size·uses_material·
priced_by·references)은 [[product-126-leather-artprint]]가 건다. 수치 원본은 그 본문 전사표가 권위.

## 카테고리 노드 (실사 포스터 계열 — 축 승격 대기)

### [category-CAT_000076] 아트프린트 (포스터 하위 leaf) {verified}
- type: category
- anchor: t_cat_categories/CAT_000076
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000076(cat_nm=아트프린트·upr_cat_cd=CAT_000004 포스터·cat_lvl=2·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000126,CAT_000076) main_cat_yn=N·2026-06-19 재연결", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1 카테고리 고아 해소(CAT_000298 del_yn=Y·실사 정상노드 재연결·T-1)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {cat_cd: "CAT_000076", cat_nm: "아트프린트", upr_cat_cd: "CAT_000004", cat_lvl: "2", note: "실사(카테고리 004 포스터) 하위 leaf. round-13 'CAT_000298 고아'는 STALE — 2026-06-18 CAT_000298 논리삭제·실사 28상품 정상 재연결(pack §1.1·T-1). 부모 CAT_000004(포스터)는 별도 노드 미생성(트리 부모는 props로 기록·in_category는 leaf만)"}
- 본문: 레더아트프린트가 속한 정상 카테고리 leaf(아트프린트·포스터 하위). [[product-126-leather-artprint]] in_category. 공유 axis/categories.md 미등재·승격 대기(needed_shared).

## 사이즈 노드 (정본 재사용 — 로컬 preset 은퇴)

> ★D-SILSA-INT-1 교정(fix-log-silsa-260703): 구 로컬 preset size-126-SIZ_000174/197/293은 정본
> `size-SIZ_000174`(product-047)·`size-SIZ_000197`(axis/sizes)·`size-SIZ_000293`(product-119)와 동일 마스터
> 앵커(t_siz_sizes/SIZ_xxx)를 중복소유했다. 단일소유권 계약(공유 축=단일 owner)에 맞춰 로컬 노드를 은퇴하고
> [[product-126-leather-artprint]] has_size를 정본으로 재지향. 상품별 preset/off-grid/마스터삭제 정직관찰은
> has_size 엣지 note와 main 본문 전사표(사이즈 절)에 보존.

## 자재 노드 (레더·MAT_TYPE.05 교정됨)

### [material-MAT_000186] 레더 (실사 소재·MAT_TYPE.05) {verified}
- type: material
- anchor: t_mat_materials/MAT_000186
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000186(mat_nm=레더·mat_typ_cd=MAT_TYPE.05·upr_mat_cd 공백·use_yn=Y·del_yn=N·upd 2026-06-27)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000126,MAT_000186) usage_cd=USAGE.07 dflt_yn=Y del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1·§3.5 레더 MAT_000186=.05(06-27 교정·구 .08)·목표 라벨 .06 가죽은 코드개편 STALE(T-2)·라이브 4상품(100/126/296/298) 횡단", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_cd: "MAT_000186", mat_nm: "레더", mat_typ_cd: "MAT_TYPE.05", usage_cd: "USAGE.07", note: "★자재유형 현재값 MAT_TYPE.05(2026-06-27 교정·구 .08 실사소재에서 이동). round-13 목표 '.06 가죽'은 MAT_TYPE 코드 개편(현재 .06=도장부자재)으로 STALE(pack T-2) — 현재 .05가 정답·양면 아님(false-defect 방지). 낱장 완제품 단일 슬롯(USAGE.07·내지/표지 없음). 레더 crosscut=라이브 4상품(100/126/296/298·MAT_TYPE 오염축·[[rule/rules#RULE_import_material_no_delete]])"}
- 본문: 레더 소재(가죽 질감·실사 대형 출력)·MAT_TYPE.05 교정 상태([[product-126-leather-artprint]] uses_material). 공유 axis/materials.md 미등재·승격 대기(needed_shared).

## 가격공식 노드 (실사 면적매트릭스형)

### [formula-PRF_POSTER_LEATHER_AP] 레더아트프린트 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_LEATHER_AP
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_LEATHER_AP(frm_nm=레더아트프린트 완제품가(면적/규격 단가)·use_yn=Y·note 포스터사인 소재/사이즈/수량별 완제품 통가격)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_POSTER_LEATHER_AP → comp COMP_POSTER_CANVAS_FABRIC(disp_seq=1·addtn_yn=Y) 1행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 면적매트릭스형 13상품 B09 레더126·[가로×세로] 셀단가·off-grid ceiling·실사 inline price 권위 아님", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {frm_cd: "PRF_POSTER_LEATHER_AP", use_yn: "Y", archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·통가격)", note: "값 계산=evaluate_price 권위(D-18). 온톨로지는 배선·차원 선언까지"}
- rel: {rel: has_component, target: component-COMP_POSTER_CANVAS_FABRIC, qualifier: {disp_seq: 1, addtn: "Y"}, note: "★[동형결합] 4소재 통합 구성요소(구 per-leather COMP_POSTER_LEATHER_ARTPRINT는 use_yn=N 은퇴)"}
- 본문: 레더아트프린트 면적매트릭스 완제품가 공식([[product-126-leather-artprint]] priced_by). has_component→[[component-COMP_POSTER_CANVAS_FABRIC]]. 고아 공식 아님(O6 충족). 공유 formula 파일 미등재·승격 대기(needed_shared).

## 가격구성요소 노드 (★재사용 — 재정의 금지)

> ★[동형결합] 4소재 통합 구성요소 **component-COMP_POSTER_CANVAS_FABRIC**(캔버스패브릭·레더·메쉬·타이벡)는
> 이미 [[product-125-canvas-fabric-poster-nodes#component-COMP_POSTER_CANVAS_FABRIC]](캔버스=namesake·병렬 실사
> 빌더 125가 canonical 소유)가 정의 — **재정의 금지**(L-3 중복 id 회피·054/053 선례). [[formula-PRF_POSTER_LEATHER_AP]]
> has_component→component-COMP_POSTER_CANVAS_FABRIC로 재사용. 구 per-leather COMP_POSTER_LEATHER_ARTPRINT(use_yn=N·
> 52행 동일 격자)는 레거시 은퇴(배선 안 함). 단가행은 D-22 접기(노드 미전개·본문 전사표 면적매트릭스 셀 요약이 집계 권위·
> 라이브 52셀=권위 포스터사인 B09 600/800/1000/1200mm·19000~126000 일치).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-126-roll-material-pricing] 롤 소재 가격 계산 로직 암묵지 (GAP-2·실사 전체 영향) {unknown}
- type: gap
- anchor: none  # 사유: 롤 소재 최종 단가가 면적매트릭스 셀로 산정되는 실무 규칙이 엑셀에 미기재(암묵지)·정답 원천 부재
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 GAP·§5 롤 소재 가격 계산 로직(source-registry §9 GAP-2·엑셀 미기재 암묵지·실사 전체 영향·실무진)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_CANVAS_FABRIC 52셀 단가는 라이브 실재하나 산정 규칙(소재원가→셀단가 유도)은 DB에 없음", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "레더 등 롤 소재의 최종 완제품가(면적매트릭스 셀단가)가 소재원가·출력·가공에서 어떤 규칙으로 산정됐는지가 엑셀에 미기재된 실무 암묵지. 셀단가 자체는 라이브 실재(52셀)이나 유도 로직 불명 — 신규 규격/소재 추가 시 셀단가 산정 기준 부재"
- gap_fill_from: "실무진 답변(롤 소재 단가 산정식·source-registry §9 GAP-2). 그 전까지 셀단가 유도 규칙 단정 금지(라이브 셀값은 권위로 사용 가능)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_CANVAS_FABRIC, note: "산정 로직이 불명한 면적매트릭스 셀단가 구성요소"}
- 본문: 실사 면적매트릭스 셀단가는 라이브에 실재하나 그 값이 어떻게 산정됐는지(소재원가→셀단가)는 엑셀 미기재 암묵지. 지어내지 않고 GAP으로 등재(실사 전체 영향·실무진 확인 대기).

### [gap-126-minqty-axis] min_qty 차원 선언 vs 단가행 공란 (수량축 역할 미확정) {unknown}
- type: gap
- anchor: none  # 사유: use_dims에 min_qty 선언되나 단가행 min_qty 공란·면적매트릭스=수량축 없음 원칙과 어긋남·정답 판정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_CANVAS_FABRIC use_dims=[siz_width,siz_height,min_qty] vs t_prc_component_prices min_qty 컬럼 전 행 공란(단일 tier)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 면적매트릭스 13상품은 수량축 없음(매트릭스 셀=완제품 통가격·min_qty=NULL)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "COMP_POSTER_CANVAS_FABRIC use_dims가 min_qty를 차원으로 선언하나 라이브 단가행 min_qty는 전 행 공란(단일 tier). pack §3.4는 '면적매트릭스=수량축 없음'이 원칙 — 차원 선언과 격자가 어긋남. 126의 수량(min 1·incr 1)이 가격에 실제 영향 주는지 미확정"
- gap_fill_from: "검증 레인(§21 hcc-cpq-link/§26 무결성) evaluate_price 실측 + 개발팀(use_dims 정합). 그 전까지 min_qty 가격영향 단정 금지"
- gap_owner: dev
- rel: {rel: references, target: component-COMP_POSTER_CANVAS_FABRIC, note: "min_qty 차원 선언 주체(격자는 공란)"}
- 본문: 면적매트릭스는 수량축 없음이 원칙인데 merged comp가 min_qty를 use_dims에 선언했다(격자는 공란). 지어내지 않고 GAP으로 등재(수량축 실재/역할=검증·개발 레인).
