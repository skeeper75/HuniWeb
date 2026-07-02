<!-- axis page: E9 price_formula — 디지털 파일럿 가격공식(마스터 t_prc_price_formulas). -->
<!-- ★생성=_meta/scripts/gen_formula_nodes.py. has_component 배선=t_prc_formula_components 전사(disp_seq·addtn 한정자). -->

# 축: 가격공식 (price_formula)

디지털 = 원자합산형(인쇄비+용지비+공정비) + 명함/포토카드 고정가. 공식→구성요소 배선(R9
`has_component`)은 아래 relations. addtn(가산 여부)·disp_seq는 배선 엣지 한정자(구성요소
속성 아님·F-4). **값 계산은 evaluate_price 권위**(D-18). 상품→공식(R8 `priced_by`)은 상품 노드(Phase 4).

<!-- transcribed-by: _meta/scripts/gen_formula_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components @ 2026-07-03 -->

### [formula-PRF_DGP_A] 원자합산형A 엽서·상품권·슬로건 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_A
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_A", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PRINT_SPOT_WHITE_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_CORNER_RIGHT, qualifier: {disp_seq: 3}}
- rel: {rel: has_component, target: component-COMP_PP_CREASE_1L, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_PERF_1L, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARTEXT_1EA, qualifier: {disp_seq: 6, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARIMG_1EA, qualifier: {disp_seq: 7, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_GLOSSY}
- rel: {rel: has_component, target: component-COMP_COAT_MATTE}
- props: {archetype: "원자합산형", note: "016 프리미엄엽서·041 스탠다드 쿠폰/상품권 바인딩"}

### [formula-PRF_DGP_B] 원자합산형B 모양엽서·라벨택 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_B
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_B", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_FULL_DIECUT, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "원자합산형", note: "046 라벨/택 바인딩·완칼 커팅"}

### [formula-PRF_DGP_C] 원자합산형C 인쇄배경지·헤더택 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_C
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_C", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_CARD_2H, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_PERF_1H6, qualifier: {disp_seq: 3, addtn: Y}}
- props: {archetype: "원자합산형", note: "043 인쇄배경지(OPP봉투타입) 바인딩·접지+타공"}

### [formula-PRF_DGP_D] 원자합산형D 소량전단지 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_D
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_D", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_GLOSSY, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_MATTE, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_PERF_1H6, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_CREASE_1L, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_PERF_1L, qualifier: {disp_seq: 6, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARTEXT_1EA, qualifier: {disp_seq: 7, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARIMG_1EA, qualifier: {disp_seq: 8, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_CORNER_RIGHT, qualifier: {disp_seq: 9, addtn: Y}}
- props: {archetype: "원자합산형", note: "047 소량전단지(디지털 인접) 바인딩"}

### [formula-PRF_DGP_E] 원자합산형E 접지카드·접지리플렛 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_E
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_E", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_GLOSSY, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_MATTE, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_HALF, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_3FOLD, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_4ACC, qualifier: {disp_seq: 6, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_LEAF_4GATE, qualifier: {disp_seq: 7, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_PERF_1H6, qualifier: {disp_seq: 8, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARTEXT_1EA, qualifier: {disp_seq: 9, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PP_VARIMG_1EA, qualifier: {disp_seq: 10, addtn: Y}}
- props: {archetype: "원자합산형", note: "027 2단접지카드 바인딩(국4절/3절)"}

### [formula-PRF_DGP_F] 원자합산형F 썬캡(미출시) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_F
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_F", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_FULL_DIECUT, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "원자합산형", note: "미출시·구조 참조용"}

### [formula-PRF_NAMECARD_COAT] 코팅명함 고정가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_COAT
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_COAT", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_COAT_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_COAT_S2, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가", note: "032 코팅명함 바인딩·배선교정 이력"}

### [formula-PRF_NAMECARD_FIXED] 스탠다드명함 고정가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_FIXED
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_FIXED", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_STD_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_STD_S2, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가", note: "033 스탠다드명함 바인딩"}

### [formula-PRF_PHOTOCARD_NORMAL] 포토카드 고정가(세트/대량) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_PHOTOCARD_NORMAL
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_PHOTOCARD_NORMAL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PHOTOCARD_SET, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PHOTOCARD_BULK, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가", note: "024 포토카드 바인딩"}

<!-- 공유축 통합 mint 260703(okb-knowledge-builder): 아래 5공식은 상품 빌더 needed_shared_nodes 중 -->
<!-- 브로큰링크(product priced_by 배선 실재·공식 부재) 해소 대상. 025/035/036/037/039 priced_by 타깃. -->
<!-- has_component 배선(disp_seq/addtn)=_meta/scripts/transcribe_shared_axis_260703.py 전사(t_prc_formula_components). -->

### [formula-PRF_PHOTOCARD_CLEAR] 투명포토카드 세트 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_PHOTOCARD_CLEAR
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_PHOTOCARD_CLEAR", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PHOTOCARD_CLEAR_SET, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가", note: "025 투명포토카드 바인딩·V3 공식분리(PRF_PHOTOCARD_FIXED silent 합산 교정·260623)"}

### [formula-PRF_NAMECARD_SHAPE] 모양명함 면/수량별 단가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_SHAPE
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_SHAPE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_SHAPE_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_SHAPE_S2, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가", note: "035 모양명함 바인딩·siz_cd 정확매칭(032/033과 동형 블록)"}

### [formula-PRF_NAMECARD_MINISHAPE] 미니모양명함 면/수량별 단가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_MINISHAPE
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_MINISHAPE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_MINISHAPE_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_MINISHAPE_S2, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "고정가", note: "036 미니모양명함 바인딩·가격표260527 B08"}

### [formula-PRF_NAMECARD_FOIL] 오리지널박명함 박종류/수량별 단가+동판셋업비 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_FOIL
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_FOIL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_FOIL_S1_STD, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_FOIL_SETUP_S1_STD, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_FOIL_S1_HOLO, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_FOIL_S2_STD, qualifier: {disp_seq: 4, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_FOIL_S2_HOLO, qualifier: {disp_seq: 5, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_NAMECARD_FOIL_SETUP_S2_STD, qualifier: {disp_seq: 6, addtn: Y}}
- props: {archetype: "고정가", note: "037 오리지널박명함 바인딩·박 본체+동판셋업·면 동일가·042 프리미엄쿠폰 박분기(PRF_DGP_A_FOIL)와 별 공식"}

### [formula-PRF_NAMECARD_CLEAR] 투명명함 수량별 단가(용지포함) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_NAMECARD_CLEAR
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_NAMECARD_CLEAR", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_NAMECARD_CLEAR_S1, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가", note: "039 투명명함 바인딩·자재무관·단면 단독(CLEAR_S1)"}

