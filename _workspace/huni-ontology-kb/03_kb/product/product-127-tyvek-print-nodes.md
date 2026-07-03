<!-- product-local sub-nodes: E3 size·E4 material·E9 price_formula·gap for PRD_000127 타이벡프린트(실사 면적매트릭스 B10). -->
<!-- ★공유 axis(materials/sizes)·formula 파일에 실사 노드가 아직 없다 — 공유 축 파일 수정 금지 규칙 때문에 여기 임시 거처(125/126 선례). -->
<!--   축 소유자가 승격 시 canonical id 그대로 이관 — index_entries/needed_shared로 반환. -->
<!-- ★재사용(재정의 금지): category-CAT_000076=product-126-leather-artprint-nodes 선점·component-COMP_POSTER_CANVAS_FABRIC=product-125-canvas-fabric-poster-nodes 선점. 여기 mint 안 함(L-3 중복 id 회피). -->
<!-- ★수치(치수·격자·단가범위)는 [[product-127-tyvek-print]] 본문 전사표(transcribed-by)에만. 여기 노드는 코드·구조·출처만. -->

# product-127-tyvek-print 하위 노드 (타이벡프린트 PRD_000127 전용 축 원자)

타이벡프린트(PRD_000127)가 쓰는 사이즈 3·자재 2(타이벡·타이벡소프트)·가격공식 1·GAP 2를 정의한다.
카테고리(CAT_000076)·가격구성요소(COMP_POSTER_CANVAS_FABRIC 동형결합)는 형제 빌더(126·125)가 선점 소유해
**재사용만**(여기 재정의 금지). 규칙·SOT는 공유 rule 축·외부 메모리 재사용. 상품→축 연결(in_category·has_size·
uses_material·priced_by·references)은 [[product-127-tyvek-print]]가 건다. 수치 원본은 그 본문 전사표가 권위.

## 사이즈 노드 (정본 재사용 — 로컬 preset 은퇴)

> ★D-SILSA-INT-1 교정(fix-log-silsa-260703): 구 로컬 preset size-127-SIZ_000174/197/293은 정본
> `size-SIZ_000174`/`size-SIZ_000197`/`size-SIZ_000293`와 동일 마스터 앵커를 중복소유했다. 단일소유권 계약에
> 맞춰 로컬 은퇴, [[product-127-tyvek-print]] has_size를 정본으로 재지향(off-grid·마스터삭제 정직관찰은 has_size
> 엣지 note와 main 본문 전사표에 보존).

## 자재 노드 (타이벡 2소재·MAT_TYPE.05)

### [material-MAT_000187] 타이벡 (실사 소재·MAT_TYPE.05·마스터 활성) {verified}
- type: material
- anchor: t_mat_materials/MAT_000187
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000187(mat_nm=타이벡·mat_typ_cd=MAT_TYPE.05·upr_mat_cd 공백·use_yn=Y·del_yn=N·note '정정 2026-06-14 실사소재.08→원단.05 product-bom §146'·upd 2026-06-27)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000127,MAT_000187) usage_cd=USAGE.07 dflt_yn=Y del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1.1·§3.5 타이벡 187/188=.05(교정·구 .08)·목표 라벨 코드개편 STALE(T-2)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {mat_cd: "MAT_000187", mat_nm: "타이벡", mat_typ_cd: "MAT_TYPE.05", usage_cd: "USAGE.07", note: "★자재유형 현재값 MAT_TYPE.05(2026-06-14 정정 코멘트·구 .08 실사소재). round-13 목표 '.05 원단/.06 가죽'은 MAT_TYPE 코드 개편(현재 .05=특수소재·.06=도장부자재)으로 STALE(pack T-2) — 현재 .05가 정답·양면 아님(코드 값 일치·라벨 진화·false-defect 방지). 낱장 완제품 단일 슬롯(USAGE.07). 타이벡=방수·내구 부직포. IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]])"}
- 본문: 타이벡 소재(방수·내구·실사 대형 출력)·MAT_TYPE.05 교정·마스터 활성([[product-127-tyvek-print]] uses_material). 공유 axis/materials.md 미등재·승격 대기(needed_shared).

### [material-MAT_000188] 타이벡(소프트) (실사 소재·MAT_TYPE.05·★마스터 논리삭제) {verified}
- type: material
- anchor: t_mat_materials/MAT_000188
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000188(mat_nm=타이벡(소프트)·mat_typ_cd=MAT_TYPE.05·upr_mat_cd 공백·use_yn=Y·del_yn=Y 2026-06-27 논리삭제·note '정정 2026-06-14 실사소재.08→원단.05 product-bom §146')", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000127,MAT_000188) usage_cd=USAGE.07 dflt_yn=Y del_yn=N(상품링크 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_cd: "MAT_000188", mat_nm: "타이벡(소프트)", mat_typ_cd: "MAT_TYPE.05", usage_cd: "USAGE.07", note: "★마스터(t_mat_materials) del_yn=Y(2026-06-27 논리삭제)이나 상품링크(t_prd_product_materials)는 활성(del_yn=N·dflt_yn=Y) — 링크활성/마스터삭제 불일치(정직 관찰·SIZ_000293 A1·MAT del 동형). 손님 노출/187 통합 여부는 검증 레인 몫(단정 아님·양면 아님=코드값 자체는 불변). 낱장 단일 슬롯(USAGE.07). MAT_TYPE.05(구 .08 정정). IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]])"}
- 본문: 타이벡 소프트 변형 소재·마스터 논리삭제와 상품링크 활성 불일치를 정직 표기([[product-127-tyvek-print]] uses_material). 187과 함께 타이벡 2소재 슬롯.

## 가격공식 노드 (실사 면적매트릭스형)

### [formula-PRF_POSTER_TYVEK] 타이벡프린트 완제품가(면적/규격 단가) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_POSTER_TYVEK
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_POSTER_TYVEK(frm_nm=타이벡프린트 완제품가(면적/규격 단가)·use_yn=Y·note 포스터사인 타이벡프린트 소재/사이즈/수량별 완제품 통가격)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "키:(PRF_POSTER_TYVEK,COMP_POSTER_CANVAS_FABRIC) disp_seq=1·addtn_yn=Y 1행", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 면적매트릭스형 13상품 B10 타이벡127·[가로×세로] 셀단가·off-grid ceiling·실사 inline price 권위 아님", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
- props: {frm_cd: "PRF_POSTER_TYVEK", use_yn: "Y", archetype: "면적매트릭스형(포스터사인 [가로×세로] 셀단가·통가격)", note: "값 계산=evaluate_price 권위(D-18). 온톨로지는 배선·차원 선언까지"}
- rel: {rel: has_component, target: component-COMP_POSTER_CANVAS_FABRIC, qualifier: {disp_seq: 1, addtn: "Y"}, note: "★[동형결합] 4소재 통합 구성요소(구 per-tyvek COMP_POSTER_TYVEK_PRINT는 use_yn=N 은퇴·125가 canonical 소유)"}
- 본문: 타이벡프린트 면적매트릭스 완제품가 공식([[product-127-tyvek-print]] priced_by). has_component→[[component-COMP_POSTER_CANVAS_FABRIC]](125 재사용). 고아 공식 아님(O6 충족). 공유 formula 파일 미등재·승격 대기(needed_shared).

## 가격구성요소 노드 (★재사용 — 재정의 금지)

> ★[동형결합] 4소재 통합 구성요소 **component-COMP_POSTER_CANVAS_FABRIC**(캔버스패브릭·레더·메쉬·타이벡)는
> 이미 [[product-125-canvas-fabric-poster-nodes#component-COMP_POSTER_CANVAS_FABRIC]](캔버스=namesake·125가
> canonical 소유)가 정의 — **재정의 금지**(L-3 중복 id 회피·126/054/053 선례). [[formula-PRF_POSTER_TYVEK]]
> has_component→component-COMP_POSTER_CANVAS_FABRIC로 재사용. 구 per-tyvek COMP_POSTER_TYVEK_PRINT(use_yn=N·
> 52행 동일 격자·use_dims=[siz_width,siz_height] min_qty 없음)는 레거시 은퇴(배선 안 함). 단가행은 D-22 접기
> (노드 미전개·본문 전사표 면적매트릭스 셀 요약이 집계 권위·라이브 52셀=권위 포스터사인 B10 600/800/1000/1200mm·
> 19000~126000 일치).

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-127-roll-material-pricing] 롤 소재 가격 계산 로직 암묵지 (GAP-2·실사 전체 영향) {unknown}
- type: gap
- anchor: none  # 사유: 롤 소재 최종 단가가 면적매트릭스 셀로 산정되는 실무 규칙이 엑셀에 미기재(암묵지)·정답 원천 부재
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.10 GAP·§5 롤 소재 가격 계산 로직(source-registry §9 GAP-2·엑셀 미기재 암묵지·실사 전체 영향·실무진)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd:COMP_POSTER_CANVAS_FABRIC 52셀 단가는 라이브 실재하나 산정 규칙(소재원가→셀단가 유도)은 DB에 없음", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "타이벡 등 롤 소재의 최종 완제품가(면적매트릭스 셀단가)가 소재원가·출력·가공에서 어떤 규칙으로 산정됐는지가 엑셀에 미기재된 실무 암묵지. 셀단가 자체는 라이브 실재(52셀)이나 유도 로직 불명 — 신규 규격/소재 추가 시 셀단가 산정 기준 부재"
- gap_fill_from: "실무진 답변(롤 소재 단가 산정식·source-registry §9 GAP-2). 그 전까지 셀단가 유도 규칙 단정 금지(라이브 셀값은 권위로 사용 가능)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_POSTER_CANVAS_FABRIC, note: "산정 로직이 불명한 면적매트릭스 셀단가 구성요소(125 소유)"}
- 본문: 실사 면적매트릭스 셀단가는 라이브에 실재하나 그 값이 어떻게 산정됐는지(소재원가→셀단가)는 엑셀 미기재 암묵지. 지어내지 않고 GAP으로 등재(실사 전체 영향·실무진 확인 대기·126 gap-126-roll-material-pricing 동형).

### [gap-127-minqty-axis] min_qty 차원 선언 vs 단가행 공란 (수량축 역할 미확정) {unknown}
- type: gap
- anchor: none  # 사유: use_dims에 min_qty 선언되나 단가행 min_qty 공란·면적매트릭스=수량축 없음 원칙과 어긋남·정답 판정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_POSTER_CANVAS_FABRIC use_dims=[siz_width,siz_height,min_qty] vs t_prc_component_prices min_qty 컬럼 전 행 공란(단일 tier)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§3.4 면적매트릭스 13상품은 수량축 없음(매트릭스 셀=완제품 통가격·min_qty=NULL)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-silsa}
- gap_what: "COMP_POSTER_CANVAS_FABRIC use_dims가 min_qty를 차원으로 선언하나 라이브 단가행 min_qty는 전 행 공란(단일 tier). pack §3.4는 '면적매트릭스=수량축 없음'이 원칙 — 차원 선언과 격자가 어긋남. 127의 수량(min 1·incr 1)이 가격에 실제 영향 주는지 미확정"
- gap_fill_from: "검증 레인(§21 hcc-cpq-link/§26 무결성) evaluate_price 실측 + 개발팀(use_dims 정합). 그 전까지 min_qty 가격영향 단정 금지"
- gap_owner: dev
- rel: {rel: references, target: component-COMP_POSTER_CANVAS_FABRIC, note: "min_qty 차원 선언 주체(격자는 공란·125 소유)"}
- 본문: 면적매트릭스는 수량축 없음이 원칙인데 merged comp가 min_qty를 use_dims에 선언했다(격자는 공란). 지어내지 않고 GAP으로 등재(수량축 실재/역할=검증·개발 레인·126 gap-126-minqty-axis 동형).
