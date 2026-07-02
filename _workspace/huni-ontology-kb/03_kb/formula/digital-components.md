<!-- axis page: E10 price_component — 디지털 파일럿 공식이 배선하는 가격구성요소(마스터 t_prc_price_components). -->
<!-- ★생성=_meta/scripts/gen_formula_nodes.py(캐시 전사). use_dims=가격 차원 선언(D-18 경계)·값 계산은 evaluate_price 권위. -->

# 축: 가격구성요소 (price_component)

공식의 부품. use_dims = 이 구성요소 가격이 어떤 축으로 달라지는가(차원 선언)까지만 —
**가격 값 계산은 evaluate_price 단일 권위**(온톨로지 밖). 단가행(t_prc_component_prices)은
노드로 펼치지 않고 여기 속성으로 접는다(D-22). 공식→구성요소 배선은 R9 `has_component`.

<!-- transcribed-by: _meta/scripts/gen_formula_nodes.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components @ 2026-07-03 -->

### [component-COMP_COAT_GLOSSY] 유광코팅비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_COAT_GLOSSY
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_COAT_GLOSSY", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "plt_siz_cd", "coat_side_cnt", "min_qty", "proc_grp:PROC_000013"]'}

### [component-COMP_COAT_MATTE] 무광코팅비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_COAT_MATTE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_COAT_MATTE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "plt_siz_cd", "coat_side_cnt", "min_qty", "proc_grp:PROC_000013"]'}

### [component-COMP_CUT_FULL_DIECUT] 커팅 완제품가 완칼(모양엽서·라벨택) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_CUT_FULL_DIECUT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_CUT_FULL_DIECUT", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["plt_siz_cd", "min_qty"]', role: "완칼 커팅(die-cut)·.03 고정 교정(이중적용 과대청구 해소)"}

### [component-COMP_CUT_PERF_1H6] 타공비 (6mm) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_CUT_PERF_1H6
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_CUT_PERF_1H6", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'}

### [component-COMP_FOLD_CARD_2H] 접지비 카드 2단 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOLD_CARD_2H
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOLD_CARD_2H", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["min_qty"]'}

### [component-COMP_FOLD_LEAF_3FOLD] 접지비 리플렛 3단 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOLD_LEAF_3FOLD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOLD_LEAF_3FOLD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000056"]'}

### [component-COMP_FOLD_LEAF_4ACC] 접지비 리플렛 4단아코디언 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOLD_LEAF_4ACC
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOLD_LEAF_4ACC", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000056"]'}

### [component-COMP_FOLD_LEAF_4GATE] 접지비 리플렛 4단게이트 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOLD_LEAF_4GATE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOLD_LEAF_4GATE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000056"]'}

### [component-COMP_FOLD_LEAF_HALF] 접지비 리플렛 반접지 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOLD_LEAF_HALF
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_FOLD_LEAF_HALF", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000056"]'}

### [component-COMP_NAMECARD_COAT_S1] 코팅명함 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_COAT_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_COAT_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "min_qty", "print_opt_cd"]'}

### [component-COMP_NAMECARD_COAT_S2] 코팅명함 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_COAT_S2
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_COAT_S2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "min_qty", "print_opt_cd"]'}

### [component-COMP_NAMECARD_STD_S1] 스탠다드명함 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_STD_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_STD_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "min_qty", "print_opt_cd"]'}

### [component-COMP_NAMECARD_STD_S2] 스탠다드명함 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_STD_S2
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_STD_S2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["mat_cd", "min_qty", "print_opt_cd"]'}

### [component-COMP_PAPER] 용지비(종이별 절가) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PAPER
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PAPER", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["plt_siz_cd", "mat_cd"]', role: "용지비(종이별 절가·plt_siz_cd×mat_cd)"}

### [component-COMP_PHOTOCARD_BULK] 포토카드 완제품가 대량 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PHOTOCARD_BULK
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PHOTOCARD_BULK", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["min_qty", "opt_cd", "opt_grp:OPT_000084"]'}

### [component-COMP_PHOTOCARD_SET] 포토카드 완제품가 일반세트 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PHOTOCARD_SET
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PHOTOCARD_SET", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", use_dims: '["siz_cd", "bdl_qty", "min_qty", "opt_cd", "opt_grp:OPT_000084"]'}

### [component-COMP_PP_CORNER_RIGHT] 귀돌이비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PP_CORNER_RIGHT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PP_CORNER_RIGHT", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000026"]', role: "귀돌이(모서리 라운딩)·.03 고정 교정(×수량 과대청구 해소)"}

### [component-COMP_PP_CREASE_1L] 오시비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PP_CREASE_1L
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PP_CREASE_1L", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000029"]'}

### [component-COMP_PP_PERF_1L] 미싱비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PP_PERF_1L
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PP_PERF_1L", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000030"]'}

### [component-COMP_PP_VARIMG_1EA] 가변이미지 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PP_VARIMG_1EA
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PP_VARIMG_1EA", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000085"]'}

### [component-COMP_PP_VARTEXT_1EA] 가변텍스트 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PP_VARTEXT_1EA
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PP_VARTEXT_1EA", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000085"]'}

### [component-COMP_PRINT_DIGITAL_S1] 디지털인쇄비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PRINT_DIGITAL_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PRINT_DIGITAL_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["proc_cd", "plt_siz_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000001"]', role: "디지털 base 인쇄비(PROC_000004 매칭·미바인딩=인쇄비0)"}

### [component-COMP_PRINT_SPOT_WHITE_S1] 별색인쇄비 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PRINT_SPOT_WHITE_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PRINT_SPOT_WHITE_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["plt_siz_cd", "proc_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000007"]', role: "통합별색인쇄비(5별색×단면양면 통합·개별 CLEAR/GOLD use=N)"}

## 투명포토카드·모양명함·박명함 완제품가 구성요소 (공유축 통합 mint 260703)

<!-- 2026-07-03 공유축 통합(okb-knowledge-builder): 아래 12구성요소는 상품 빌더 needed_shared_nodes 중 -->
<!-- 브로큰링크 해소 공식(PRF_PHOTOCARD_CLEAR·PRF_NAMECARD_SHAPE/MINISHAPE/FOIL/CLEAR)의 has_component 타깃. -->
<!-- use_dims=차원 선언(값 계산=evaluate_price 권위·D-18). 단가행 실값은 t_prc_component_prices 접기(D-22). -->

### [component-COMP_PHOTOCARD_CLEAR_SET] 포토카드 완제품가 투명세트 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PHOTOCARD_CLEAR_SET
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PHOTOCARD_CLEAR_SET", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "bdl_qty", "min_qty"]', role: "025 투명포토카드 완제품가(용지포함 세트)"}

### [component-COMP_NAMECARD_SHAPE_S1] 모양명함 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_SHAPE_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_SHAPE_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd"]', role: "035 모양명함 단면·siz_cd 키(COAT/STD의 mat_cd 키와 상이)"}

### [component-COMP_NAMECARD_SHAPE_S2] 모양명함 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_SHAPE_S2
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_SHAPE_S2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd"]', role: "035 모양명함 양면"}

### [component-COMP_NAMECARD_MINISHAPE_S1] 미니모양명함 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_MINISHAPE_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_MINISHAPE_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd"]', role: "036 미니모양명함 단면"}

### [component-COMP_NAMECARD_MINISHAPE_S2] 미니모양명함 완제품가 양면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_MINISHAPE_S2
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_MINISHAPE_S2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd"]', role: "036 미니모양명함 양면"}

### [component-COMP_NAMECARD_FOIL_S1_STD] 오리지널박명함 완제품가 단면·일반박 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_FOIL_S1_STD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_FOIL_S1_STD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000080"]', role: "037 단면 일반박(종이+동판+박)"}

### [component-COMP_NAMECARD_FOIL_S2_STD] 오리지널박명함 완제품가 양면·일반박 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_FOIL_S2_STD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_FOIL_S2_STD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000080"]', role: "037 양면 일반박"}

### [component-COMP_NAMECARD_FOIL_S1_HOLO] 오리지널박명함 완제품가 단면·홀로/트윙클 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_FOIL_S1_HOLO
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_FOIL_S1_HOLO", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000080"]', role: "037 단면 홀로그램/트윙클"}

### [component-COMP_NAMECARD_FOIL_S2_HOLO] 오리지널박명함 완제품가 양면·홀로/트윙클 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_FOIL_S2_HOLO
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_FOIL_S2_HOLO", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["print_opt_cd", "opt_cd", "min_qty", "opt_grp:OPT_000080"]', role: "037 양면 홀로그램/트윙클"}

### [component-COMP_NAMECARD_FOIL_SETUP_S1_STD] 박·형압 동판셋업비 단면 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_FOIL_SETUP_S1_STD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_FOIL_SETUP_S1_STD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", comp_typ_cd: "PRC_COMPONENT_TYPE.05", use_dims: '["print_opt_cd", "min_qty"]', role: "037 동판셋업비 단면·주문 1건당 1회"}

### [component-COMP_NAMECARD_FOIL_SETUP_S2_STD] 박·형압 동판셋업비 양면 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_FOIL_SETUP_S2_STD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_FOIL_SETUP_S2_STD", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.03", comp_typ_cd: "PRC_COMPONENT_TYPE.05", use_dims: '["print_opt_cd"]', role: "037 동판셋업비 양면"}

### [component-COMP_NAMECARD_CLEAR_S1] 투명명함 완제품가 단면(용지포함) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_NAMECARD_CLEAR_S1
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_CLEAR_S1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.02", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["min_qty"]', role: "039 투명명함 단면·자재무관 수량단가"}

