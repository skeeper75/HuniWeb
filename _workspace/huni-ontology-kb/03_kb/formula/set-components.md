<!-- axis page: E10 price_component — 셋트 계열 가격구성요소(마스터 t_prc_price_components). Stage A 공유축(okb-knowledge-builder 260703). -->
<!-- ★use_dims=차원 선언(D-18 경계)·값 계산=evaluate_set_price 권위. 단가행(t_prc_component_prices)은 노드 미펼침·속성 접기(D-22). -->
<!-- ★면지 구성원=무가격(제본비 포함·기여0·component_prices 0행). 은퇴 구성원도 가격 미배선(면지 재설계 무손상 근거). -->

# 축: 셋트 가격구성요소 (price_component — 셋트 계열)

셋트 공식의 부품. **제본 comp**(COVERBIND/싸바리/트윈링/PUR/무선/중철=셋트 form을 만드는 정체
공정) + **고정가 comp**(엽서북/떡메/포토북 완제품가) + **박분기 comp**(069/070 _FOIL candidate).
use_dims는 차원 선언까지만 — 값 계산은 `evaluate_set_price` 단일 권위(온톨로지 밖). 공식→구성요소
배선은 R9 `has_component`(set-formulas.md). **면지 = 무가격**(제본비 포함·기여0·`component_prices`
0행). 단가행은 D-22로 접는다(COVERBIND 6티어 등은 post-verify 실호출 참조·아래 note).

<!-- transcribed-by: _meta/scripts/transcribe_set_axis_260703.py(수동 확장 awk t_prc_price_components) from live-snapshot/latest (snap_20260702_1119) @ 2026-07-03 -->

## 하드커버/링 제본 통가 (COVERBIND·트윈링)

### [component-COMP_HC_MUSEON_COVERBIND] 하드커버무선 표지+제본 합산(권당) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_HC_MUSEON_COVERBIND
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_HC_MUSEON_COVERBIND", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["min_qty"]', role: "072/077/088 COVERBIND 통가(표지+제본·자재 미종속). ★단가행: live-snapshot 20260702_1119=component_prices 0행. 6티어 골든(1→34,100…100→7,969·1000→6,368.4)=088-post-verify §2a 실호출 참조(재설계 시점차·손전사 안 함·D-22 접기). ★레더 델타 미반영(use_dims=[min_qty] 한계·엔진 C트랙)."}

### [component-COMP_BIND_HC_TWINRING] 제본비 하드커버트윈링 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_HC_TWINRING
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_HC_TWINRING", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "082 하드커버 링책자 제본비(제본 종류·수량별 단가표)."}

## 책자 분해형 제본비 (중철·무선·PUR·트윈링)

### [component-COMP_BIND_JUNGCHEOL] 제본비 중철 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_JUNGCHEOL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_JUNGCHEOL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "068 중철책자 제본비(PRF_BIND_SUM 배선)."}

### [component-COMP_BIND_MUSEON] 제본비 무선 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_MUSEON
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_MUSEON", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "069 무선책자 제본비(base PRF_BIND_MUSEON + 박분기 PRF_BIND_MUSEON_FOIL 공용)."}

### [component-COMP_BIND_PUR] 제본비 PUR {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_PUR
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_PUR", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "070 PUR책자 제본비(base PRF_BIND_PUR + 박분기 PRF_BIND_PUR_FOIL 공용)."}

### [component-COMP_BIND_TWINRING] 제본비(트윈링·071) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_TWINRING
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_TWINRING", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "071 트윈링책자 제본비(PRF_BIND_TWINRING 배선·셋트 미성립 부모)."}

### [component-COMP_BIND_SSABARI] 제본비 싸바리바인더(088 redesign·현행 미배선) {candidate}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_SSABARI
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_SSABARI·use_yn=Y", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "하드커버 제본비(싸바리/하드커버무선/하드커버트윈링). ★live 실재(use_yn=Y)이나 088 현행 부모공식(PRF_LEATHER_RINGBINDER_SET)은 COVERBIND 배선 — 싸바리는 088-redesign pending(COMP_BIND_SSABARI@PROC_000098·인간승인 후)에서 배선 예정. gaps.md#gap-set-088-redesign-pending."}

### [component-COMP_BIND_CAL_WALL] 제본비 벽걸이/탁상 캘린더(참고) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_BIND_CAL_WALL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_BIND_CAL_WALL", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.04", use_dims: '["proc_cd", "min_qty", "proc_grp:PROC_000017"]', role: "캘린더 제본비(벽걸이/탁상220/미니). 캘린더=단품·참고(셋트 아님·PRF_DGP_CAL_* 배선)."}

## 고정가 완제품가 (엽서북·떡메·포토북)

### [component-COMP_PCB_S1_20P] 엽서북 완제품가 단면·20p {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PCB_S1_20P
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PCB_S1_20P", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd", "opt_cd", "opt_grp:OPT_000082"]', role: "094 엽서북 완제품가(인쇄면·페이지수·수량별 1권당). 단면 20p."}

### [component-COMP_PCB_S2_20P] 엽서북 완제품가 양면·20p {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PCB_S2_20P
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PCB_S2_20P", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd", "opt_cd", "opt_grp:OPT_000082"]', role: "094 엽서북 완제품가. 양면 20p."}

### [component-COMP_PCB_S1_30P] 엽서북 완제품가 단면·30p {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PCB_S1_30P
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PCB_S1_30P", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd", "opt_cd", "opt_grp:OPT_000082"]', role: "094 엽서북 완제품가. 단면 30p."}

### [component-COMP_PCB_S2_30P] 엽서북 완제품가 양면·30p {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PCB_S2_30P
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PCB_S2_30P", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty", "print_opt_cd", "opt_cd", "opt_grp:OPT_000082"]', role: "094 엽서북 완제품가. 양면 30p."}

### [component-COMP_TTEOKME] 떡메모지 완제품가(권당장수) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_TTEOKME
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_TTEOKME", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "bdl_qty", "min_qty"]', role: "097 떡메모지 완제품가(사이즈·권당 장수 50/100·수량별)."}

### [component-COMP_PHOTOBOOK_BASE] 포토북 완제품가 기본24P(사이즈·표지타입별) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PHOTOBOOK_BASE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PHOTOBOOK_BASE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "opt_cd", "min_qty"]', role: "100 포토북 기본24P 완제품가(사이즈·표지타입 opt_cd별)."}

### [component-COMP_PHOTOBOOK_PAGE] 포토북 추가2P당(사이즈별) {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_PHOTOBOOK_PAGE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_PHOTOBOOK_PAGE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', role: "100 포토북 내지 member(101) 추가2P당(base24P 초과·사이즈별)."}

## 박분기 (069/070 _FOIL candidate) — 기존 노드 재사용(중복 mint 금지)

<!-- ★대형 박 구성요소 3종(COMP_FOIL_SETUP_LARGE·COMP_FOIL_PROC_LARGE_STD·COMP_FOIL_PROC_LARGE_SPECIAL)은 -->
<!-- 이미 product/product-027-nodes.md에 정의됨(042 프리미엄쿠폰 박분기·동일 앵커 t_prc_price_components/COMP_FOIL_*). -->
<!-- set-formulas.md의 PRF_BIND_MUSEON_FOIL·PRF_BIND_PUR_FOIL has_component 배선은 그 기존 노드로 해소(id 전역 유일·재사용). -->
<!-- 승격 후보: 069/070 셋트 + 042 쿠폰이 공유하는 대형 박 축 → 향후 axis/공유 승격 시 canonical 재지향(architect 소관). -->
<!-- Stage A는 product 노드 미터치(재사용만·L-3 중복 금지). -->
