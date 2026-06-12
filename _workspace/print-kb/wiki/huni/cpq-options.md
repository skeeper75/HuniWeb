# CPQ 옵션 레이어 (CPQ Options) — 횡단 축

> huni 레이어(분석대상). 옵션·옵션그룹·제약을 원자 항목으로 분리해 레시피가 `uses`/`requires`/`excludes`로 조립한다.
> 앵커: 라이브 7테이블 `t_prd_product_option_groups`/`options`/`option_items` · `templates`/`template_selections` · `constraints`.
> 핵심: L1(차원/가격 적재) ≠ **L2(CPQ 옵션 레이어)**. L2는 이미 적재된 차원행을 polymorphic `ref_dim_cd`로 참조해 재구성한다. **제약은 `constraints.logic` 단일경로**(constraint_json 삭제 — [CPQ-STALE]).
> 큐레이션 팩: `_curation/axis-cpq-options.md`.

---

## 1. 옵션 레이어 구조

### [CPQ-001] CPQ 7테이블 구조 (L2)  {🟡}
- 내용: 옵션은 **`option_groups`(택1/택N) → `options` → `option_items`** 3계층, SKU는 **`templates` → `template_selections`** 2계층, 제약은 **`constraints`** 로 구성된다. L2는 L1 차원행을 참조만 한다(중복 적재 아님).
- 앵커: `t_prd_product_option_groups`·`options`·`option_items`·`templates`·`template_selections`·`constraints`
- 출처: `00_schema/cpq-schema.md` + 라이브 psql {tier A/C, PARTIAL-STALE: I-5·I-8·I-11}
- 연결: [[#CPQ-002]] · [[price-engine#PE-001]] (uses — L1 차원)
- 사용처: [[recipes/digital-print#DGP-CPQ-001]] (uses — 엽서 파일럿 L2) · [[recipes/calendar#CAL-CPQ-001]] (uses — 캘린더가공 택일그룹 GRP-CAL-가공·excl_groups 흡수) · [[recipes/product-accessory#PA-CPQ-001]] (OTC TEMPLATE = 봉투가 다른 상품 addon base (이중역할))
- answers_cq: CQ-PROD-05 (선택 옵션 축·캐스케이드 구조)
- tags: #CPQ #구조 #L2 #7테이블

### [CPQ-002] polymorphic ref_dim_cd (OPT_REF_DIM 7종)  {🟡}
- 내용: `option_items`는 **polymorphic `ref_dim_cd`(OPT_REF_DIM 7종)** 로 L1 차원행(사이즈·도수·자재 등)을 가리킨다. 도수=`opt_id`·자재=`mat_cd+usage_cd`로 참조. 무결성은 검증 트리거 `fn_chk_opt_item_ref`가 강제([CPQ-003]).
- 앵커: `t_prd_product_option_items.ref_dim_cd` (OPT_REF_DIM 7종)
- 출처: `00_schema/cpq-schema.md` + `10_configurator/cpq-design.md` {tier A/C, FRESH(트리거)·설계 PARTIAL}
- 연결: [[#CPQ-003]] (requires — 무결성 트리거) · [[materials#MAT-001]] (uses — mat_cd+usage_cd) · [[processes#PRC-003]] (uses — 도수=opt_id)
- 사용처: [[recipes/digital-print#DGP-CPQ-001]] (requires — 엽서 옵션 ref_dim_cd) · [[recipes/sticker#STK-CPQ-001]] (uses — 스티커 옵션축 ref_dim_cd) · [[recipes/acrylic#AC-CPQ-001]] (uses — polymorphic ref_dim_cd) · [[recipes/calendar#CAL-CPQ-001]] (uses — 장수·가공 ref_dim_cd) · [[recipes/product-accessory#PA-CPQ-002]] (uses — 색상 variant → option_items ref_dim_cd) · [[recipes/goods-pouch#GP-CPQ-001]] (requires — 옵션형 사이즈=polymorphic ref_dim_cd) · [[recipes/silsa#SL-CPQ-002]] (uses — 일반현수막 끈/각목 polymorphic 다중 item_seq) · [[recipes/stationery#ST-CPQ-002]] (표지/부속 옵션 = 자재+공정 BUNDLE 후보 (면지·실버링·PVC))
- answers_cq: CQ-PROD-05 (옵션 축 참조 구조)
- tags: #CPQ #polymorphic #ref_dim_cd #OPT_REF_DIM

### [CPQ-003] 검증 트리거 fn_chk_opt_item_ref  {✅}
- 내용: `option_items.ref_dim_cd` + 참조 키가 실제 적재된 L1 차원행을 가리키는지 **DB 트리거가 강제**(reference resolution 무결성). 차원행 미적재 상태에서 option_item 적재 시 트리거 위반 → 차원행 선적재 필수([[load-path#LP-003]]).
- 앵커: `fn_chk_opt_item_ref` (라이브 트리거)
- 출처: `00_schema/cpq-schema.md` + 메모리 `dbmap-cpq-option-layer-mapping` {tier A, FRESH}
- 연결: [[#CPQ-002]] · [[load-path#LP-003]]
- 사용처: [[recipes/acrylic#AC-CPQ-001]] (requires — 무결성 트리거) · [[recipes/product-accessory#PA-CPQ-002]] (requires — 색상 옵션 차원행 선적재) · [[recipes/goods-pouch#GP-CPQ-001]] (requires — fn_chk_opt_item_ref 무결성·차원행 선적재) · [[recipes/silsa#SL-CPQ-001]] (requires — 무결성 트리거·차원행 선적재) · [[recipes/sticker#STK-CPQ-001]] (옵션축(코팅·화이트·조각수·형상) → 4엔티티 매핑)
- tags: #CPQ #트리거 #무결성 #선적재

---

## 2. 매핑 원칙

### [CPQ-004] 속성→4엔티티 마스터 지도 (차원/CPQ옵션/가격/제약)  {🟡}
- 내용: 상품 속성은 **차원(L1)·CPQ옵션(L2)·가격(t_prc)·제약(constraints)** 4엔티티 중 어디로 가는지 결정 규칙으로 매핑한다. 기계적 매핑 금지 — 같은 값을 잘못된 t_*에 넣는 위험(예: 카드봉투 색을 siz에 적재). 삼중바인딩(UI componentType·생산 BOM·가격엔진) 파악 후 매핑.
- 앵커: 매핑 결정 규칙(attribute-entity-map)
- 출처: `10_configurator/attribute-entity-map.md` + 메모리 `dbmap-schema-design-intent-first` {tier C(round-6), PARTIAL-STALE: I-5·I-9}
- 연결: [[#CPQ-005]] · [[widget-contract#WID-003]] (componentType)
- 사용처: [[recipes/sticker#STK-CPQ-001]] (uses — 스티커 코팅/화이트/조각수/형상 → 4엔티티) · [[recipes/acrylic#AC-CPQ-001]] (uses — 속성→4엔티티) · [[recipes/goods-pouch#GP-CPQ-001]] (uses — 폰기종/등급/본체색/가공/addon → 4엔티티) · [[recipes/silsa#SL-CPQ-001]] (uses — 코팅/봉제/타공/족자/부속 → 4엔티티) · [[recipes/product-accessory#PA-CPQ-002]] (색상 variant → option_items (정답·ref_dim_cd·전면 미적재)) · [[recipes/stationery#ST-ID-003]] (만년다이어리 4종 = 별상품 적재 (variant 아님·ST2-2))
- tags: #CPQ #속성매핑 #4엔티티 #삼중바인딩

### [CPQ-005] BUNDLE 원칙 (옵션 = 자재 + 공정)  {🟡}
- 내용: **한 옵션이 두 의미를 동시에 가진다** — 예: 아일렛 = 금속링(자재) + 박는 타공(공정). DB는 자재/공정 구분 등록하고 `option_items` 다중 seq + template이 묶음(주문 + 생산 BOM)으로 묶는다. 옵션을 공정만/자재만으로 반쪽 매핑 금지(silsa v1 반쪽 → v2 BUNDLE 교정).
- 앵커: `option_items`(다중 seq) + `templates`(묶음)
- 출처: 메모리 `dbmap-option-material-process-bundle` + `10_configurator/silsa-option-layer-v2.md` {tier C, FRESH}
- 연결: [[materials#MAT-004]] (uses — 자재 축) · [[processes#PRC-004]] (uses — 순수공정=자재없음)
- 사용처: [[recipes/booklet#BK-CPQ-002]] (책자 투명커버/링/인쇄면지 BUNDLE) · [[recipes/photobook#PB-CPQ-002]] (포토북 표지타입=표지자재+무광코팅 BUNDLE 후보) · [[recipes/acrylic#AC-BOM-004]] (uses — 부착=자재+공정 BUNDLE) · [[recipes/stationery#ST-CPQ-002]] (문구 면지/실버링/PVC BUNDLE 후보) · [[recipes/goods-pouch#GP-CPQ-002]] (uses — 볼체인/리필잉크/아크릴스탠드 addon BUNDLE) · [[recipes/silsa#SL-CPQ-002]] (uses — 끈=자재+부착공정·각목 BUNDLE 다중 seq)
- answers_cq: CQ-FIN-10 (굿즈 전용 후가공 — 아일렛·봉제 등 옵션=자재+공정)
- tags: #CPQ #BUNDLE #자재공정 #아일렛

### [CPQ-006] OTC TEMPLATE 이중등록 = 의도 (상품악세사리)  {🟡}
- 내용: 상품악세사리의 옵션-템플릿 이중등록은 **결함이 아니라 의도**(OTC TEMPLATE). 옵션 선택과 SKU 템플릿이 둘 다 등록돼 주문 조합과 생산 BOM을 각각 표현한다(sql/09 삭제제외로 입증).
- 앵커: `t_prd_templates`·`template_selections`(OTC)
- 출처: `10_configurator/all-sheets-otc-extract.md`·`option-vs-template-guide.md` + round-13 product-accessory {tier C, FRESH}
- 연결: [[price-engine#PE-004]] (priced-by — template_prices) · [[#CPQ-001]]
- 사용처: [[recipes/digital-print#DGP-CPQ-002]] (uses — 봉투 addon template) · [[recipes/digital-print#DGP-CPQ-003]] (uses — 봉투세트 OTC 후보) · [[recipes/acrylic#AC-CPQ-002]] (uses — 볼체인 template 경로) · [[recipes/calendar#CAL-CPQ-002]] (uses — 캘린더봉투 addon template) · [[recipes/product-accessory#PA-ID-003]] (uses — 카드봉투 281/282/283 이중등록=의도·09_delete_dup 입증) · [[recipes/product-accessory#PA-CPQ-001]] (uses — 봉투=다른 상품 addon base 이중역할) · [[recipes/silsa#SL-BOM-005]] (uses — 부속 OTC 구조·우드행거/우드봉/거치대) · [[recipes/booklet#BK-ID-002]] (생산구조 3종 (A통합·B셋트·떡제본)) · [[recipes/photobook#PB-ID-002]] (생산구조 = B 셋트 (소프트커버만 A통합 근접))
- answers_cq: CQ-PROD-11 (묶음/세트 판매 단위) · CQ-PROD-03 (아키타입 완제품 귀속)
- tags: #CPQ #OTC #템플릿 #이중등록의도

### [CPQ-007] 캐스케이드 제약 = constraints.logic (즉석병합)  {🟡}
- 내용: 옵션 간 캐스케이드(excludes/requires)는 RedPrinting 캐스케이드 6종을 흡수해 **`t_prd_product_constraints.logic`(JSONLogic, 즉석병합)** 단일경로로 표현한다. RULE_TYPE는 **금지+필수동반 2종만**(.01 호환은 비활성 — [CPQ-STALE]). `constraints.logic`은 NOT NULL.
- 앵커: `t_prd_product_constraints.logic` (JSONLogic, RULE_TYPE 2종)
- 출처: `10_configurator/cpq-design.md` + 메모리 `dbmap-live-admin-product-viewer`(제약 var 7키·logic NOT NULL) {tier A/C, FRESH(트리거)·설계 PARTIAL}
- 연결: [[#CPQ-STALE]] · [[widget-contract#WID-004]] (mapped-to — 옵션 캐스케이드 위젯 계약)
- 사용처: [[recipes/digital-print#DGP-DM-002]] (excludes — 봉투 사이즈매칭 캐스케이드 후보) · [[recipes/acrylic#AC-CPQ-002]] (uses — constraints.logic) · [[recipes/calendar#CAL-BOM-003]] (requires — 링칼라 조건부 캐스케이드) · [[recipes/calendar#CAL-CPQ-002]] (requires — 봉투 ★사이즈선택 캐스케이드) · [[recipes/product-accessory#PA-CPQ-003]] (requires — 봉투세트 사이즈매칭 배경지 siz↔봉투 siz) · [[recipes/silsa#SL-CPQ-003]] (uses — 비치수 수치 범위 제약 GAP·constraints 0행) · [[recipes/booklet#BK-CPQ-002]] (표지 옵션 = 자재+공정 BUNDLE 후보 (투명커버·링·면지)) · [[recipes/photobook#PB-CPQ-002]] (표지타입 옵션 = 자재+공정 BUNDLE 후보 (CPQ 적재 시)) · [[recipes/sticker#STK-CPQ-002]] (제약 = constraints.logic 단일경로 (constraint_json STALE))
- answers_cq: CQ-PROC-05 (공정 선행 종속성 강제) · CQ-PROD-05 (캐스케이드 구조)
- tags: #CPQ #제약 #constraints.logic #JSONLogic #캐스케이드

---

## 3. 현황·STALE

### [CPQ-008] CPQ 옵션 레이어 전면 미적재 (silsa 파일럿만)  {🔴 미적재}
- 내용: round-13 결함축 H. **라이브 현재값: option_items 18행(silsa 파일럿만 적재) → 정답: 전 family 옵션 레이어 적재 필요**(BATCH-6 일괄 적재 미결, 6+ family). **[CONF-1 라이브 실측 확정] `SELECT count(*) FROM t_prd_product_option_items` → 18행.** 과거 자료는 둘 다 stale: ref-csv/schema-relationship "0행"·메모리 "silsa 43행 COMMIT(06-09)" 모두 라이브와 불일치(43행 중 일부 미적재/롤백 추정). 위키 권위 = **라이브 18행**.
- 앵커: `t_prd_product_option_items`(라이브 18행 — silsa 파일럿)
- 출처: 라이브 psql(`count(*)`=18 실측, CONF-1) + `10_configurator/silsa-option-layer-v2.md`·`silsa-live-reconciliation.md` + `_crosscut/` 추가-H {tier A, FRESH}
- 연결: [[#CPQ-001]] · [[#CPQ-GAP-1]]
- 사용처: [[recipes/digital-print#DGP-CPQ-001]] (디지털인쇄 옵션 레이어 미적재) · [[recipes/sticker#STK-ST-006]] (스티커 옵션 레이어 미적재) · [[recipes/booklet#BK-CPQ-001]] (책자 option_groups 0행·제본 1:1) · [[recipes/photobook#PB-CPQ-001]] (포토북 option_groups 0행) · [[recipes/acrylic#AC-DEF-008]] (전면 미적재) · [[recipes/calendar#CAL-CPQ-001]] (캘린더 option_groups 0행·장수/가공 미적재) · [[recipes/product-accessory#PA-ST-011]] (상품악세사리 옵션 0·색상 옵션 미적재·테스트 잔재 2행) · [[recipes/stationery#ST-CPQ-001]] (문구 option_groups 0행·제본 1:1) · [[recipes/goods-pouch#GP-ST-006]] (굿즈 option_groups 0행·전면 미적재) · [[recipes/silsa#SL-DEF-006]] (실사 일반현수막138 og=3/oi=18만·나머지 0행·라이브 최초 옵션 레이어 사례)
- tags: #결함 #CPQ미적재 #silsa파일럿 #BATCH-6 #CONF-1 #18행

### [CPQ-STALE] constraint_json 적재 타깃 = STALE (인용 금지)  {🔴 STALE}
- 내용: impact-diagnosis I-5(진단 Top 1). **`constraint_json` 컬럼 삭제됨** → `cpq-schema.md`(✅5)·`cpq-design.md`·`16_*/digital-print/mapping-final.md`(180g→constraint_json)의 constraint_json 적재 타깃 명시는 **무효·인용 금지**. 제약은 `constraints.logic` 단일경로([CPQ-007]). 추가: RULE_TYPE.01(호환) 활성 가정 STALE(I-8, 2종만)·7스칼라 === 가정 PARTIAL(I-9, OPT_GRP/OPT 배열 in 비교 미반영).
- 출처: `18_schema-change/impact-diagnosis.md` I-5·I-8·I-9 {tier A, FRESH}
- 연결: [[#CPQ-007]] · [[load-path#LP-STALE]]
- 사용처: [[recipes/acrylic#AC-CPQ-002]] (볼체인 addon = template 경로 (Phase7 tmpl_cd 구조)) · [[recipes/booklet#BK-CPQ-002]] (표지 옵션 = 자재+공정 BUNDLE 후보 (투명커버·링·면지)) · [[recipes/calendar#CAL-BOM-003]] (링칼라·삼각대컬러 = 공정 param (조건부 캐스케이드)) · [[recipes/photobook#PB-CPQ-002]] (표지타입 옵션 = 자재+공정 BUNDLE 후보 (CPQ 적재 시)) · [[recipes/silsa#SL-CPQ-003]] (캐스케이드 제약 = 비치수 수치 범위 GAP (constraints 0행)) · [[recipes/sticker#STK-CPQ-002]] (제약 = constraints.logic 단일경로 (constraint_json STALE)) · [[recipes/goods-pouch#sources]] (STALE 인용 0 확인 — constraint_json 본 페이지 미인용) · [[recipes/product-accessory#sources]] (STALE 인용 0 확인 — constraint_json 본 페이지 미인용)
- tags: #STALE #constraint_json #인용금지 #I-5 #I-8 #I-9

---

## 4. GAP (미모델링·미결)

### [CPQ-GAP-1] CPQ 옵션 레이어 전면 적재 미결 (BATCH-6)  {🔴}
- 내용: silsa 외 6+ family 일괄 적재 미결.
- 출처: `_curation/axis-cpq-options.md` GAP-CPQ-1 · `_crosscut/` 추가-H {tier C}
- 연결: [[#CPQ-008]]
- 사용처: [[recipes/acrylic#GAP-AC-3]] (아크릴 CPQ 일괄 적재 미결) · [[recipes/calendar#CAL-ST-DEF-013]] (캘린더 CPQ/가격 일괄 적재 BATCH-6) · [[recipes/product-accessory#PA-ST-011]] (상품악세사리 색상 옵션·봉투세트 캐스케이드 일괄 적재 미결) · [[recipes/stationery#ST-DEF-006]] (문구 CPQ 일괄 적재 미결 BATCH-6) · [[recipes/goods-pouch#GP-ST-006]] (굿즈 CPQ 일괄 적재 미결·BATCH-6·Q-GP-1) · [[recipes/silsa#SL-DEF-006]] (실사 CPQ 옵션 레이어 일괄 적재 미결·BATCH-6) · [[recipes/booklet#BK-CPQ-001]] (책자 option_groups 0행 (제본 택일그룹 불요·CPQ 전면 미적재)) · [[recipes/digital-print#DGP-ST-005]] (미결 컨펌·GAP (BATCH·Q-ID)) · [[recipes/photobook#PB-CPQ-001]] (포토북 option_groups 0행 (CPQ 전면 미적재)) · [[recipes/sticker#STK-ST-006]] (CPQ 옵션 레이어 전면 미적재 (BATCH-6))
- tags: #GAP #CPQ미적재 #BATCH-6

### [CPQ-GAP-2] ref_param_json / hidden-essential GAP  {🔴}
- 내용: `cpq-option-gaps.md` — ref_param_json·hidden-essential 옵션 미표현.
- 출처: `_curation/axis-cpq-options.md` GAP-CPQ-2 {tier C}
- 연결: [[#CPQ-002]]
- 사용처: [[recipes/acrylic#AC-DIM-003]] (조각수 param 저장처 GAP) · [[recipes/silsa#SL-DEF-003]] (봉제/족자 param 손실·ref_param_json GAP) · [[recipes/sticker#STK-DIM-002]] (묶음수·조각수 = 부분 GAP (066만 적재)) · [[recipes/sticker#STK-ST-005]] (조각수 bundle_qtys 부분 적재 (066만·OM-7 선결))
- tags: #GAP #ref_param_json

### [CPQ-GAP-3] 즉석병합 전환 후 JSONLogic 변환 정합 미검증 (I-5·I-9)  {🔴}
- 내용: constraint_json → constraints.logic 즉석병합 전환 후 우리 JSONLogic 변환 정합 미검증.
- 출처: `_curation/axis-cpq-options.md` GAP-CPQ-3 · impact-diagnosis I-5·I-9 {tier A}
- 연결: [[#CPQ-007]] · [[#CPQ-STALE]]
- tags: #GAP #JSONLogic #I-5

---

## Sources
- 큐레이션 팩: `_curation/axis-cpq-options.md`
- 정답: `00_schema/cpq-schema.md`; `10_configurator/attribute-entity-map.md`·`cpq-design.md`·`silsa-option-layer-v2.md`·`silsa-live-reconciliation.md`·`postcard-option-layer.md`·`postcard-walkthrough-validation.md`·`all-sheets-otc-extract.md`·`option-vs-template-guide.md`·`live-admin-groundtruth.md`·`wowpress-option-model.md`·`huni-goods-option-mapping.md`.
- 보조: `huni-admin-manual/manual/04_options.md`·`05_sku-templates.md`·`06_constraints.md`.
- freshness: `18_schema-change/impact-diagnosis.md` I-5·I-8·I-9·I-11.
- 메모리: `dbmap-cpq-option-layer-mapping`·`dbmap-l2-requires-l1-price-table`·`dbmap-option-material-process-bundle`·`dbmap-live-admin-product-viewer`·`dbmap-schema-design-intent-first`.
- **STALE(인용 금지):** `constraint_json` 적재 타깃(I-5 — cpq-schema/cpq-design/mapping-final 명시분); RULE_TYPE.01 호환 활성 가정(I-8); option_items 행수 ref-csv "0행"·메모리 "43행" 둘 다 stale(라이브 권위 = 18행, CONF-1).
