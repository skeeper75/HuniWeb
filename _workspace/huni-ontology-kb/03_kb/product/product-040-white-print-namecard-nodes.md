<!-- product-scoped supplement: PRD_000040(화이트인쇄명함)이 도입하는 신규 노드 — flat 명함 공식 + 4구성요소 + 수량 + 옵션그룹 + GAP. -->
<!-- ★공유 axis/*·formula/*·index.md 수정 금지 제약 하에, 040이 새로 쓰는 공식/구성요소를 이 상품 전용 하위 노드로 -->
<!--    선언한다(공유 formula/*에 미등재 — 통합 단계 승격 대상=needed_shared_nodes 반환). -->
<!-- ★색지 4종(MAT_000362~365)·별색 공정(PROC_000008/009)은 product-020-white-print-postcard-nodes.md 정의를 -->
<!--    재사용(중복 생성 금지). 여기서 재정의하지 않는다(L-3 유일성). -->
<!-- ★수치·연결은 _meta/scripts/transcribe_product_040.py 전사(transcribed-by 마커)에서 옮긴 것·LLM 손전사 금지(D-9). 단가값 제외(D-18). -->

# product-040-white-print-namecard 노드 보강 (PRD_000040 전용 신규 공식·구성요소·CPQ·GAP)

040이 도입하는, 공유 노드에 아직 없는 항목만 여기 선언한다. 이미 있는 노드(사이즈 SIZ_000008·단면/양면 POPT·국전
판형·카테고리 CAT_000003/313·모서리 공정 PROC_000027/028)와 020 정의 노드(색지 MAT_000362~365·별색 공정
PROC_000008/009)는 재사용(중복 생성 금지)하고 상품 노드가 그리로 연결한다. 신규 = **flat 명함 공식
PRF_NAMECARD_WHITE·4구성요소·수량규칙·클리어별색 옵션그룹·GAP 2**(공식/구성요소는 공유 formula/* 승격 후보 →
needed_shared_nodes 반환).

## 신규 가격공식 (E9 price_formula) — flat 명함 고정가

> ★PRF_NAMECARD_WHITE는 공유 [[formula/digital-formulas]] 미등재(020은 PRF_DGP_A 공유·032는 PRF_NAMECARD_COAT
> 공유이나 040 공식은 신규). 공유 formula/* 수정 금지라 product-local 민팅 — 근본 해법=formula/digital-formulas.md
> 승격(needed_shared_nodes). archetype=고정가(flat 1행 매칭·원자합산 아님). O6(has_component ≥1) 충족.

### [formula-PRF_NAMECARD_WHITE] 화이트인쇄명함 flat 고정가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_WHITE
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_NAMECARD_WHITE frm_nm:'화이트인쇄명함 면·클리어별색·수량별 단가(용지포함)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_WHITE (4행 disp 1~4)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_WHITE_S1W_NOCL, qualifier: {disp_seq: 1, addtn: Y}, note: "단면·클리어없음"}
- rel: {rel: has_component, target: component-COMP_NAMECARD_WHITE_S1W_CL, qualifier: {disp_seq: 2, addtn: Y}, note: "단면·클리어있음"}
- rel: {rel: has_component, target: component-COMP_NAMECARD_WHITE_S2W_NOCL, qualifier: {disp_seq: 3, addtn: Y}, note: "양면·클리어없음"}
- rel: {rel: has_component, target: component-COMP_NAMECARD_WHITE_S2W_CL, qualifier: {disp_seq: 4, addtn: Y}, note: "양면·클리어있음"}
- props: {archetype: "고정가(flat 1행 매칭·용지포함)", use_yn: Y, note: "040 화이트인쇄명함 바인딩. 단/양면×클리어별색×수량 단가표. PRF_DGP_A 원자합산 대체(견적0 교정·search-before-mint 무손실 불가 입증). 값 계산=evaluate_price 권위(D-18)."}
- 본문: 손님의 (단/양면 × 클리어별색 유무) 조합이 4구성요소 중 1개를 지목하고, 그 구성요소 단가표가 수량별 완제품가(용지포함)를 연다. 별색 화이트/클리어 인쇄비는 이 완제품가에 흡수(별도 별색 배선 금지·이중과금 가드).

## 신규 가격구성요소 (E10 price_component) — flat 명함가 4변형 (용지포함)

> ★4구성요소 전부 공유 [[formula/digital-components]] 미등재 → product-local 민팅(승격 후보=needed_shared_nodes).
> prc_typ_cd=PRICE_TYPE.02(완제품가)·comp_typ_cd=PRC_COMPONENT_TYPE.06·use_dims=[print_opt_cd,opt_cd,min_qty,opt_grp:OPT_000081].
> 단가값(unit_price)은 노드에 기입하지 않는다(D-18·값=evaluate_price) — 차원 선언만.

### [component-COMP_NAMECARD_WHITE_S1W_NOCL] 화이트인쇄명함 완제품가 단면·무클리어(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_WHITE_S1W_NOCL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_WHITE_S1W_NOCL comp_nm:'화이트인쇄명함 완제품가 단면·무코팅(용지포함)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]', 판별키: "print_opt POPT_000001(단면) + opt OPV_000489(클리어없음)"}

### [component-COMP_NAMECARD_WHITE_S1W_CL] 화이트인쇄명함 완제품가 단면·클리어(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_WHITE_S1W_CL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_WHITE_S1W_CL comp_nm:'화이트인쇄명함 완제품가 단면·코팅(용지포함)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]', 판별키: "print_opt POPT_000001(단면) + opt OPV_000490(클리어있음)"}

### [component-COMP_NAMECARD_WHITE_S2W_NOCL] 화이트인쇄명함 완제품가 양면·무클리어(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_WHITE_S2W_NOCL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_WHITE_S2W_NOCL comp_nm:'화이트인쇄명함 완제품가 양면·무코팅(용지포함)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]', 판별키: "print_opt POPT_000002(양면) + opt OPV_000489(클리어없음)"}

### [component-COMP_NAMECARD_WHITE_S2W_CL] 화이트인쇄명함 완제품가 양면·클리어(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_WHITE_S2W_CL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_WHITE_S2W_CL comp_nm:'화이트인쇄명함 완제품가 양면·코팅(용지포함)'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000081"]', 판별키: "print_opt POPT_000002(양면) + opt OPV_000490(클리어있음)"}

> ★"코팅(용지포함)"은 라이브 comp_nm 원문(NOCL/CL의 CL이 comp_nm에 "코팅"으로 표기)이나, 040의 CL은 실제로는
> **클리어별색**(코팅 아님·옵션그룹명 "클리어(별색)"·라이브 opt_grp note "코팅 아님"). comp_nm의 "코팅" 라벨은
> 명함 flat 공식 재사용 시 남은 표기이며 040 의미축은 클리어별색이다(팩 §3.3 별색=공정·이중과금가드). 라벨 정정은
> 기초코드 거버넌스(§12) 소관 — KB는 라이브 comp_nm을 그대로 인용하고 의미를 주석으로 정정.

## 수량규칙 (E8 bundle_qty)

### [qty-040] 화이트인쇄명함 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000040
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000040 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 100/10000/100)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 100·max 10000·incr 100). t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈·[[rule/decisions#DEC_qty_audit_260702]]). min/incr 100은 명함 표준(032/033과 동일·엽서 020의 12와 다름).

## CPQ 옵션그룹 (E11 option_group)

> 앵커 규약(junction-키·016/032 방식 통일·V1-03): `t_prd_product_option_groups`는 junction(col0=prd_cd)이라 빌더
> L-17 닫힌세계 검사는 **부모 prd_cd(PRD_000040)** 실재까지 검증한다. 복합키 `opt_grp_cd`(OPT_000081)는 L-17
> 범위 밖이라 sources 전사로 확증(키:(PRD_000040,OPT_000081)).

### [optgroup-040-clear] 클리어(별색) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000040
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000040,OPT_000081) opt_grp_nm:'클리어(별색)' note:'코팅 아님. opt_cd 판별차원 선택수단'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:(PRD_000040,OPT_000081) opts=OPV_000489(클리어없음·dflt)·OPV_000490(클리어있음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000081", opt_grp_nm: "클리어(별색)", sel_typ_cd: "SEL_TYPE.01(택1)", mand_yn: Y, min_sel_cnt: 1, max_sel_cnt: 1, disp_seq: 3, items: "OPV_000489 클리어없음(dflt·NOCL body)·OPV_000490 클리어있음(CL body)", ref_note: "★option_items(ref_dim/ref_key) 행 부재 — 옵션은 가격 판별 차원(opt_cd)로만 작동·물리 process ref 미형식화·[[gap-040-clear-optitem-ref]]"}
- 본문: 클리어별색 택1 필수(없음/있음). 코팅 아님(별색 인쇄·[[_glossary#TERM_spot_color]]). 이 그룹의 opt_cd(OPV_000489/490)가 flat 명함가 4구성요소의 판별 차원(없음→*_NOCL·있음→*_CL). ★020 클리어 그룹은 OPT_REF_DIM.04→PROC_000009 option_items 행 보유였으나 040은 그 ref 레이어가 없다(가격 판별 opt_cd로만·[[gap-040-clear-optitem-ref]]). option_refs 엣지는 라이브 ref_dim 행 부재로 미배선(추정 배선 회피·정직 표기).

## GAP (원천 부재·미확정)

### [gap-040-clear-optitem-ref] 클리어별색 옵션 CPQ ref 레이어 부재 {unknown}
- type: gap
- anchor: none  # 사유: 클리어별색 옵션그룹에 option_items(ref_dim/ref_key) 행이 라이브에 없음 — 물리 공정 참조가 CPQ 계약으로 미형식화(가격 판별 opt_cd로만 작동)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "prd_cd:PRD_000040 OPT_000081(클리어별색) 소속 opt_cd(OPV_000489/490)에 대응 option_items 행 0건(020 클리어 그룹은 OPT_REF_DIM.04→PROC_000009 행 보유와 대조)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "040 클리어별색 옵션그룹(OPT_000081)의 값이 t_prd_product_option_items(ref_dim_cd=OPT_REF_DIM.04/ref_key=PROC_000009) 행으로 형식화되지 않음 — 옵션은 가격 판별 차원(opt_cd·flat 명함가 NOCL/CL 선택)으로만 작동하고 fn_chk_opt_item_ref 검증 대상 물리 공정 ref 레이어가 부재"
- gap_fill_from: "실무진/설계 — 클리어별색 옵션에 OPT_REF_DIM.04(proc_cd=PROC_000009) option_items 행 보강(020 클리어 패턴). 단 040은 가격이 opt_cd 판별(flat)로 이미 작동하므로 견적 무영향·ref 레이어는 CPQ 검증·위젯 표현용(open_question)"
- gap_owner: 설계
- rel: {rel: references, target: optgroup-040-clear, note: "이 옵션그룹의 CPQ ref 레이어 공백"}
- 본문: 클리어별색 옵션은 화면 선택·가격 판별(opt_cd→flat 구성요소)은 정상이나, 물리 공정(PROC_000009 클리어인쇄) ref_dim 레이어가 020만큼 형식화 안 됨(정직 선언). 가격 경로는 끊기지 않음(opt_cd 판별으로 연결).

### [gap-040-paper-optgroup] 색지 선택 옵션그룹(종이) 부재 {unknown}
- type: gap
- anchor: none  # 사유: uses_material 색지 4종은 실재하나 손님이 색지를 고르는 옵션그룹(종이)이 라이브에 없음
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000040 옵션그룹=클리어별색(OPT_000081) 1건뿐·종이(색지) 그룹 없음(020은 OPT-000026 종이 그룹 보유·032는 OPT_000045 종이 그룹 보유와 대조)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "040은 uses_material로 색지 4종(MAT_000362~365)이 실재하나, 손님이 색지 색상을 고르는 옵션그룹(종이/색지)이 라이브에 없음 — 020(종이 OPT-000026)·032(종이 OPT_000045)와 대조. flat 명함가는 용지포함(색지=가격 차원 아님)이라 견적 무영향이나, UI 색상 선택 노출 여부가 공백"
- gap_fill_from: "실무진/설계 — 색지 선택을 옵션그룹으로 노출할지 결정(020 종이 패턴). 가격 무영향(용지포함)이라 순수 UI/CPQ 표현 문제. 여러 화이트인쇄 상품(020 포함) 공통 확인 필요(open_question)"
- gap_owner: 설계
- rel: {rel: references, target: product-040-white-print-namecard, note: "색지 선택 옵션그룹 부재(uses_material은 실재·가격 무영향)"}
- 본문: 색지 4종은 BOM에 실재하고 가격은 용지포함(어느 색지든 동일가)이라 가격 경로는 정상이나, 손님이 색상을 고르는 CPQ 옵션그룹이 없다(정직 선언). 020은 종이 옵션그룹 보유·040은 미구성(가격 무영향·UI 표현 공백).
