<!-- axis page: E9 price_formula — 셋트 계열 가격공식(마스터 t_prc_price_formulas). Stage A 공유축(okb-knowledge-builder 260703). -->
<!-- ★셋트 가격 = evaluate_set_price(pricing.py:718) = 구성원별 evaluate_price 합산 + 셋트 부모공식 + 할인. 시뮬=price_simulate_set(price_views.py:1888). -->
<!-- ★공식→구성요소 배선(has_component·R9)=t_prc_formula_components 전사(disp_seq·addtn 한정자). 값 계산=evaluate_set_price 권위(D-18). -->
<!-- ★상품→공식(priced_by·R8)은 상품/구성원 노드(Stage B). 여기는 공식+배선+아키타입까지. -->

# 축: 셋트 가격공식 (price_formula — 셋트 계열)

셋트 = 부품 조립. 가격은 단일 `evaluate_price`가 아니라 **`evaluate_set_price`**(구성원별
evaluate_price 합산 + 셋트 부모공식 + 할인·pricing.py:718). 아키타입 2종: **원자합산형**(셋트
조합 — 표지·내지·면지 구성원 + 제본/COVERBIND 부모공식) / **고정가형**(부모 all-in — 부모공식이
옵션차원 요구·구성원 기여 0). 골든값은 아래 전사표(pack §1 = post-verify simulate_set 실호출).
값 계산은 KB 밖(D-18) — 온톨로지는 priced_by·has_member·has_component·아키타입 선언까지.

## 셋트 골든 전사표 (권위 = simulate_set 실호출)

<!-- transcribed-by: pack-set-series.md §1 인벤토리표 <- {06_load/…{072,082,088}-post-verify.md §2 실호출·set-price-full-diagnosis-260702.md §0/§3·CLAUDE.md §23}. simulate_set 산출(CSV 아님·§23 실호출 전사). -->
| 셋트 부모 | 부모공식 | 아키타입 | 골든 [1/10/100부] | 소스 |
|---|---|---|---|---|
| 072 하드커버책자 | PRF_HC_MUSEON_SET | 원자합산(COVERBIND) | 34,100 / 159,100 / 796,900 | 072-post-verify §2 |
| 077 레더하드커버책자 | PRF_HC_MUSEON_SET | 원자합산(COVERBIND) | 34,100 / 159,100 / 796,900 | CLAUDE.md §23 |
| 082 하드커버링책자 | PRF_HC_TWINRING_SET | 원자합산(COVERBIND·트윈링) | 30,184 / 151,844 / 818,438 | CLAUDE.md §23 |
| 088 레더링바인더(현재값) | PRF_LEATHER_RINGBINDER_SET | 원자합산(COVERBIND) | 34,100 / 159,100 / 796,900 | 088-post-verify §2 |
| 068 중철책자 | PRF_BIND_SUM | 원자합산(제본+표지+내지) | 100부 158,688 | set-price-full-diagnosis §0 |
| 069 무선책자 | PRF_BIND_MUSEON | 원자합산(박분기 양면) | 100부 138,688 | set-price-full-diagnosis §0 |
| 070 PUR책자 | PRF_BIND_PUR | 원자합산(박분기 양면) | 100부 288,688 | set-price-full-diagnosis §0 |
| 094 엽서북 | PRF_PCB_FIXED | 고정가(부모 all-in) | 100부 450,000 | set-price-full-diagnosis §3 |
| 097 떡메모지 | PRF_TTEOKME_FIXED | 고정가(부모 all-in) | 100부 135,000 | set-price-full-diagnosis §3 |
| 100 포토북 | PRF_PHOTOBOOK_FIXED | 고정가(부모 all-in·base24+per2p) | 100부 1,500,000 | set-price-full-diagnosis §3 |

> **양면(088):** 위 현재값(796,900·COVERBIND·live COMMIT)과 별개로 **088-redesign pending(100부 1,800,000·표지 9,000·싸바리)=인간 승인 대기**. `[[../rule/gaps.md#gap-set-088-redesign-pending]]` 별도 GAP 노드. 두 값 다 보존(직교 워크스트림).
> **양면(069/070):** 아래 base 정본(active)과 `_FOIL` candidate(박분기·인간승인 후) 이중 바인딩 행 실재. `[[../rule/gaps.md#gap-set-069-070-foil]]`.
> **양면(094/097/100):** 위 엔진 골든(PRICE≠0)과 별개로 화면 0원=코드 C트랙(가격사실 아님). `[[../rule/gaps.md#gap-set-simulate-sizcd]]`.

<!-- transcribed-by: _meta/scripts/transcribe_set_axis_260703.py(수동 확장 awk t_prc_formula_components) from live-snapshot/latest (snap_20260702_1119) @ 2026-07-03 -->

## 하드커버/레더 계열 (원자합산·COVERBIND)

### [formula-PRF_HC_MUSEON_SET] 하드커버무선 셋트 부모(표지+제본 합산) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_HC_MUSEON_SET
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000072,PRF_HC_MUSEON_SET)·(PRD_000077,PRF_HC_MUSEON_SET)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_HC_MUSEON_SET", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_HC_MUSEON_COVERBIND, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(COVERBIND)", note: "072/077 부모공식. 표지+제본 통가(COVERBIND·use_dims=[min_qty]·자재 미종속). 내지=284/285 member·면지=074/079 member(기여0). evaluate_set_price=구성원 evaluate_price 합산+이 부모공식+할인(pricing.py:718)."}

### [formula-PRF_HC_TWINRING_SET] 하드커버 링책자 셋트 부모(링 제본 합산) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_HC_TWINRING_SET
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000082,PRF_HC_TWINRING_SET)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_HC_TWINRING_SET", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_HC_TWINRING, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(트윈링)", note: "082 부모공식. 내지=286 member·면지=084 member(4색 382~385 인쇄포함·기여0). evaluate_set_price 합산."}

### [formula-PRF_LEATHER_RINGBINDER_SET] 레더 링바인더 셋트 부모(현재값·COVERBIND) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_LEATHER_RINGBINDER_SET
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000088,PRF_LEATHER_RINGBINDER_SET)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_LEATHER_RINGBINDER_SET", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_HC_MUSEON_COVERBIND, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(COVERBIND)", note: "088 현재 라이브 부모공식(796,900). COVERBIND 통가 재사용. 표지=089 member·면지=090 member(4색·기여0)·내지없음(빈 바인더). ★현재값 vs 088-redesign pending(1,800,000·싸바리)=양면·gaps.md#gap-set-088-redesign-pending."}

## 책자 분해형 (원자합산·제본비+표지+내지)

### [formula-PRF_BIND_SUM] 중철책자 셋트 부모(제본비 중철) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BIND_SUM
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000068,PRF_BIND_SUM)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BIND_SUM", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_JUNGCHEOL, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(제본비+표지+내지)", note: "068 부모공식=제본비 중철(JUNGCHEOL). ★라이브 실측 frm_cd=PRF_BIND_SUM(태스크 라벨 PRF_BIND_JUNGCHEOL_SET는 오류·팩 §3.10 정합). 표지=288 member(PRF_BOOK_COVER 3비목)·내지=287 member(PRF_DGP_INNER). 표지 코팅드롭=C트랙(gaps.md#gap-set-s1s2-double 인접)."}

### [formula-PRF_BIND_MUSEON] 무선책자 셋트 부모(제본비 무선·base 정본) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BIND_MUSEON
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000069,PRF_BIND_MUSEON)·apply_bgn 2026-06-01 active", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BIND_MUSEON", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_MUSEON, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(제본비+표지+내지)", note: "069 부모공식 base 정본(active). 표지=290 member·내지=289 member(PRF_DGP_INNER). ★박분기=PRF_BIND_MUSEON_FOIL candidate(양면·gaps.md#gap-set-069-070-foil)."}

### [formula-PRF_BIND_MUSEON_FOIL] 무선책자 박분기 공식(candidate) {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BIND_MUSEON_FOIL
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000069,PRF_BIND_MUSEON_FOIL)·note '박 분기 공식으로 재바인딩(인간승인 후 COMMIT)'", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BIND_MUSEON_FOIL", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_MUSEON, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_SETUP_LARGE, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_LARGE_STD, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_LARGE_SPECIAL, qualifier: {disp_seq: 4, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(박분기)", note: "069 박선택 분기 candidate(🟡·인간승인 후 COMMIT). base 정본=PRF_BIND_MUSEON. 박분기 정본화 미결=gaps.md#gap-set-069-070-foil."}

### [formula-PRF_BIND_PUR] PUR책자 셋트 부모(제본비 PUR·base 정본) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BIND_PUR
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000070,PRF_BIND_PUR)·apply_bgn 2026-06-01 active", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BIND_PUR", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_PUR, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(제본비+표지+내지)", note: "070 부모공식 base 정본(active). 표지=292 member·내지=291 member(PRF_DGP_INNER). ★박분기=PRF_BIND_PUR_FOIL candidate."}

### [formula-PRF_BIND_PUR_FOIL] PUR책자 박분기 공식(candidate) {candidate}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BIND_PUR_FOIL
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000070,PRF_BIND_PUR_FOIL)·note '박 분기 공식(인간승인 후 COMMIT)'", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BIND_PUR_FOIL", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_PUR, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_SETUP_LARGE, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_LARGE_STD, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOIL_PROC_LARGE_SPECIAL, qualifier: {disp_seq: 4, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "셋트조합(박분기)", note: "070 박선택 분기 candidate(🟡). base 정본=PRF_BIND_PUR. gaps.md#gap-set-069-070-foil."}

### [formula-PRF_BIND_TWINRING] 트윈링책자 제본비(부모·셋트 미성립) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BIND_TWINRING
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000071,PRF_BIND_TWINRING)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BIND_TWINRING", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_BIND_TWINRING, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "제본비만(셋트 미성립)", note: "071 부모공식(제본비만). ★셋트 미성립=t_prd_product_sets 0행(구성원 미mint)·cover_mult ×2 엔진 BLOCKED. gaps.md#gap-071-set-notmembered."}

## 고정가형 (부모 all-in)

### [formula-PRF_PCB_FIXED] 엽서북 셋트 부모 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_PCB_FIXED
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000094,PRF_PCB_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_PCB_FIXED", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PCB_S1_20P, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PCB_S2_20P, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PCB_S1_30P, qualifier: {disp_seq: 3, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PCB_S2_30P, qualifier: {disp_seq: 4, addtn: Y}}
- props: {archetype: "고정가", prc_typ: "부모 all-in", note: "094 부모공식이 사이즈/면/페이지/수량 옵션차원 요구. 구성원(095 내지·096 표지) 기여 0(부모 verbatim 468셀). ★엔진골든 450,000 vs 화면0원=코드 C트랙(gaps.md#gap-set-simulate-sizcd)."}

### [formula-PRF_TTEOKME_FIXED] 떡메모지 셋트 부모 고정가 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_TTEOKME_FIXED
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000097,PRF_TTEOKME_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_TTEOKME_FIXED", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_TTEOKME, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가", prc_typ: "부모 all-in", note: "097 부모공식이 사이즈/권당장수(bdl_qty 50/100)/수량 요구. 구성원=098 내지. 엔진골든 135,000(bdl_qty=50)·화면0원=C트랙."}

### [formula-PRF_PHOTOBOOK_FIXED] 포토북 셋트 부모 고정가(base24P) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_PHOTOBOOK_FIXED
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000100,PRF_PHOTOBOOK_FIXED)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_PHOTOBOOK_FIXED", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PHOTOBOOK_BASE, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "고정가", prc_typ: "부모 all-in(base24+per2p)", note: "100 부모공식=기본24P(사이즈·표지타입별). 추가2P=내지 member PRF_PHOTOBOOK_INNER. 구성원=101 내지·102/103/105/106/107 표지5종 택1·104 면지. 엔진골든 1,500,000·화면0원=C트랙."}

## 구성원 공식 (셋트 맥락)

### [formula-PRF_DGP_INNER] 내지 공식(page 파생·디지털 계열) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_INNER
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000289,PRF_DGP_INNER)·(PRD_000291,PRF_DGP_INNER)·(PRD_000110,PRF_DGP_INNER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_INNER", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "구성원(내지)", note: "책자 셋트 내지 member 공식(289/291 등)·엽서캘린더 110 재사용(단면·재단만). 내지 페이지 가변=수량규칙 축(page_rule). ★내지 페이지 단가 후속=gaps.md#gap-set-inner-page-price. S1/S2 이중합산=C트랙(gaps.md#gap-set-s1s2-double)."}

### [formula-PRF_BOOK_COVER] 책자 표지 공식(3비목) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_BOOK_COVER
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000288,PRF_BOOK_COVER)·(PRD_000290,PRF_BOOK_COVER)·(PRD_000292,PRF_BOOK_COVER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_BOOK_COVER", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_COAT_MATTE, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 3, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "구성원(표지·3비목)", note: "분해형 책자 표지 member 공식(288/290/292)=인쇄+코팅+용지. 표지 코팅드롭=C트랙(price_views.py:1930 coat_side_cnt 미전달·PRICE≠0 무해)."}

### [formula-PRF_PHOTOBOOK_INNER] 포토북 내지 추가2P당 공식 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_PHOTOBOOK_INNER
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_PHOTOBOOK_INNER", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PHOTOBOOK_PAGE, qualifier: {disp_seq: 1, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "구성원(내지·페이지증분)", note: "100 포토북 내지 member(101)·base24P 초과 추가2P당 단가(사이즈별)."}

## 캘린더 (단품·참고·셋트 아님·pack §0.1)

> ★캘린더는 셋트 아님(has_member 없음). 단품 완제품 5개(PRD_TYPE.01·PRF_DGP_CAL_*·2026-07-01 바인딩). 여기는 공식만 참고 등재(상품 노드는 별도 캘린더 팩 권장). design-calendar 고정가=미적재 GAP(gaps.md#gap-design-calendar-fixedprice).

### [formula-PRF_DGP_CAL_DESK] 탁상형캘린더 공식(인쇄+용지+캘린더제본) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_CAL_DESK
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000108,PRF_DGP_CAL_DESK)·(PRD_000109,PRF_DGP_CAL_DESK)·note '260701 배선'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_CAL_DESK", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_BIND_CAL_WALL, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "단품(참고·셋트아님)", note: "108 탁상형(220)/109 미니탁상 단품 공식. ★위키 '캘린더 가격공식 0행 🔴 미적재'는 STALE(pack §0.1·T-6). 업로드 캘린더는 바인딩됨."}

### [formula-PRF_DGP_CAL_WIDE] 벽걸이/와이드캘린더 공식(트윈링제본) {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_CAL_WIDE
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000111,PRF_DGP_CAL_WIDE)·(PRD_000112,PRF_DGP_CAL_WIDE)·note '트윈링제본 260701'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_CAL_WIDE", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_BIND_CAL_WALL, qualifier: {disp_seq: 2, addtn: Y}}
- props: {archetype: "원자합산형", prc_typ: "단품(참고·셋트아님)", note: "111 벽걸이/112 와이드벽걸이 단품 공식(111·112 공용). 110 엽서캘린더는 PRF_DGP_INNER 재사용."}
