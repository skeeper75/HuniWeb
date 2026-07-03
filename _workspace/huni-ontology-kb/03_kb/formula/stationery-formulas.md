<!-- axis page: E9 price_formula — 문구 셋트 계열 가격공식(마스터 t_prc_price_formulas). SB-1 Stage A 공유축(okb-knowledge-builder 260703). -->
<!-- ★문구 셋트 가격 = evaluate_set_price(pricing.py:718) = 구성원별 evaluate_price 합산 + 셋트 부모공식 + 할인. 부모공식 = 고정가형(완제품가 by siz×qty). -->
<!-- ★공식→구성요소 배선(has_component·R9) = t_prc_formula_components 전사(각 PRF_STN_* → COMP_STN_* 1:1·disp_seq 1·addtn Y). 값 계산 = evaluate_set_price 권위(D-18). -->
<!-- ★상품→공식(priced_by·R8) = 부모 상품 노드(Stage B). 여기는 공식+배선+아키타입+sparse GAP 참조까지. -->
<!-- ★단가행 sparse(T-9·등록 사이즈 1~2셀만) → 등록=선택가능 사이즈는 PRICE≠0·미등록(off-grid) 사이즈만 견적0·수량은 min_qty=1 단일밴드로 전량 커버. gap-stn-sparse-grid 참조. -->

# 축: 문구 셋트 가격공식 (price_formula — 문구 셋트 계열)

문구 셋트(172~181) = 부품 조립(셋트=has_member). 가격은 단일 `evaluate_price`가 아니라
**`evaluate_set_price`**(구성원별 evaluate_price 합산 + 셋트 부모공식 + 할인·pricing.py:718).
부모공식 아키타입 = **고정가형(완제품가·부모 all-in)** — 부모공식이 `[siz_cd,min_qty]` 옵션차원을
요구하고 완제품가를 반환(구성원 기여는 evaluate_set_price가 합산). set-series 094/097/100 고정가형과
동형. 값 계산은 KB 밖(D-18) — 온톨로지는 priced_by·has_member·has_component·아키타입 선언까지.

★**단가행 sparse(T-9):** 9 공식 전부 완제품가 구성요소(`COMP_STN_*`)의 단가행이 **등록 사이즈 1~2셀만**
채워진 sparse grid다(179 메모패드만 2셀·나머지 1셀). **등록=선택가능 사이즈는 전부 PRICE≠0**(라이브
`simulate-set` 실호출 실증)이고 **미등록(off-grid) 사이즈만 견적0**이며, 수량은 단가행 min_qty=1 단일밴드로
전량 선형 커버된다(손님이 등록 사이즈를 고르면 0을 만나지 않음). grid가 sparse(등록 사이즈 수가 적음)일
뿐이므로 "공식 존재 ≠ 가격 완성"은 **등록 외 사이즈 확장 시 grid 충전 필요**로 한정된다 → 각 공식 note에
sparse 표기 + `[[../rule/gaps.md#gap-stn-sparse-grid]]` 라우팅.

<!-- transcribed-by: _meta/scripts/transcribe_stationery_axis_260703.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices @ 2026-07-03 (셀수만·단가값 미전사 L-12) -->

## 만년다이어리 계열 (고정가형·완제품가)

### [formula-PRF_STN_DIARY_SOFT] 만년다이어리(소프트커버) 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_DIARY_SOFT
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_DIARY_SOFT·frm_nm '만년다이어리(소프트커버) 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000172,PRF_STN_DIARY_SOFT)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_DIARY_SOFT(comp COMP_STN_DIARY_SOFT·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_DIARY_SOFT, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "172 만년다이어리(소프트커버) 부모공식. 구성원=293 표지만(면지/내지 없음). 표지만 셋트(pack §1.1). evaluate_set_price=구성원 evaluate_price 합산+이 부모공식+할인(pricing.py:718)."}

### [formula-PRF_STN_DIARY_HARD] 만년다이어리(하드커버) 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_DIARY_HARD
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_DIARY_HARD·frm_nm '만년다이어리(하드커버) 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000173,PRF_STN_DIARY_HARD)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_DIARY_HARD(comp COMP_STN_DIARY_HARD·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_DIARY_HARD, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈 130x190=12,000만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "173 만년다이어리(하드커버) 부모공식. 구성원=294 표지·295 면지. 하드커버무선제본(PROC_000023 mand·부모 결합). evaluate_set_price 합산."}

### [formula-PRF_STN_DIARY_LHARD] 만년다이어리(레더하드커버) 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_DIARY_LHARD
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_DIARY_LHARD·frm_nm '만년다이어리(레더하드커버) 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000174,PRF_STN_DIARY_LHARD)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_DIARY_LHARD(comp COMP_STN_DIARY_LHARD·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_DIARY_LHARD, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "174 만년다이어리(레더하드커버) 부모공식. 구성원=296 표지 레더(MAT_000186)·297 면지. 하드커버무선제본(PROC_000023). evaluate_set_price 합산."}

### [formula-PRF_STN_DIARY_LSOFT] 만년다이어리(레더소프트커버) 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_DIARY_LSOFT
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_DIARY_LSOFT·frm_nm '만년다이어리(레더소프트커버) 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000175,PRF_STN_DIARY_LSOFT)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_DIARY_LSOFT(comp COMP_STN_DIARY_LSOFT·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_DIARY_LSOFT, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "175 만년다이어리(레더소프트커버) 부모공식. 구성원=298 표지만(레더 MAT_000186·면지/내지 없음). evaluate_set_price 합산."}

## 플래너·노트 계열 (고정가형·완제품가)

### [formula-PRF_STN_MONTHLY] 먼슬리플래너 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_MONTHLY
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_MONTHLY·frm_nm '먼슬리플래너 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000176,PRF_STN_MONTHLY)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_MONTHLY(comp COMP_STN_MONTHLY·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_MONTHLY, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "176 먼슬리플래너 부모공식. 구성원=299 표지·300 내지(28p 고정·SEMI_ROLE.01). evaluate_set_price 합산."}

### [formula-PRF_STN_SPRINGNOTE] 스프링노트 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_SPRINGNOTE
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_SPRINGNOTE·frm_nm '스프링노트 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000177,PRF_STN_SPRINGNOTE)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_SPRINGNOTE(comp COMP_STN_SPRINGNOTE·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_SPRINGNOTE, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- rel: {rel: references, target: gap-stn-177-classification, note: "177 prd_typ .02(라이브) vs 셋트 완제품(sets 부모) conflict"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "177 스프링노트 부모공식. 구성원=301 표지·302 내지(무지). 트윈링제본(PROC_000021=스프링 mand). ★177 분류 conflict(prd_typ .02 vs 셋트 완제품)=gap-stn-177-classification(양면). evaluate_set_price 합산."}

### [formula-PRF_STN_SPRINGNOTEBK] 스프링수첩 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_SPRINGNOTEBK
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_SPRINGNOTEBK·frm_nm '스프링수첩 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000178,PRF_STN_SPRINGNOTEBK)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_SPRINGNOTEBK(comp COMP_STN_SPRINGNOTEBK·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_SPRINGNOTEBK, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "178 스프링수첩 부모공식. 구성원=303 표지·304 내지(무지). 트윈링제본(PROC_000021 mand). evaluate_set_price 합산."}

### [formula-PRF_STN_MEMOPAD] 메모패드 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_MEMOPAD
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_MEMOPAD·frm_nm '메모패드 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000179,PRF_STN_MEMOPAD)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_MEMOPAD(comp COMP_STN_MEMOPAD·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_MEMOPAD, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 2셀(sparse·등록 사이즈 144x206=5,000·B5=6,000)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "2셀(sparse·9공식 중 유일 2셀)", note: "179 메모패드 부모공식. 구성원=305 표지·306 내지(무지). 떡제본(PROC_000022 mand). ★단가행 2셀(144x206·B5 182x257)로 문구 셋트 중 유일하게 2셀. evaluate_set_price 합산."}

### [formula-PRF_STN_JUNGCHEOL] 중철노트 완제품가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_STN_JUNGCHEOL
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "키:PRF_STN_JUNGCHEOL·frm_nm '중철노트 완제품가'·use_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000181,PRF_STN_JUNGCHEOL)·apply_bgn 2026-06-06", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_STN_JUNGCHEOL(comp COMP_STN_JUNGCHEOL·disp_seq 1·addtn Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_STN_JUNGCHEOL, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "완제품가 단가행 1셀(sparse·등록 사이즈만)·등록=선택가능 사이즈는 PRICE≠0·off-grid만 견적0·수량 min_qty=1 단일밴드 전량 커버"}
- props: {archetype: "고정가", prc_typ: "부모 all-in(완제품가·evaluate_set_price)", 단가행: "1셀(sparse)", note: "181 중철노트 부모공식. 구성원=307 표지·308 내지(무지). 중철제본(PROC_000018 mand·PROC_000017 하위). evaluate_set_price 합산."}
