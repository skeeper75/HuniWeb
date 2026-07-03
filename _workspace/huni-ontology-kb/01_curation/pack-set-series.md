# 큐레이션 팩 — 셋트 계열 (책자·포토북·캘린더)

> **작성:** okb-source-curator · 2026-07-03 (첫 작성 — 이전 팩 없음)
> **대상:** 셋트 계열 = 상품마스터 260702 기준 **t_prd_product_sets 부모(셋트 완제품)** + 그 반제품 구성원.
>   라이브 실측(snap_20260702_1119 + §23 최신 COMMIT 반영) = **셋트 부모 10개 활성**(068·069·070·072·077·082·088·094·097·100)
>   + **071 트윈링책자 = 셋트 미구성(GAP)**. 문구 셋트(172~181)는 본 팩 범위 밖(과업=책자/포토북/캘린더).
>   **★캘린더(108~112) = 셋트 아님 = 단품 완제품**(판정 §0.1 — 셋트로 모델링 금지).
> **목적:** 지식 구축가(okb-knowledge-builder)가 셋트 계열을 온톨로지에 넣을 때, **축(axis)마다 어느 파일의 어느 절이
>   정답 소스이고, 무엇이 함정(STALE)이며, 원천이 없어 못 닫는 GAP이 무엇인지**를 못박는다.
>   특히 셋트는 라이브 상태가 **최근 급변**(면지 통합 재설계 2026-07-03·068~070 구성원 mint 2026-06-30·캘린더 공식 바인딩 2026-07-01)
>   했으므로 **latest-wins·양면 정직 표기**가 이 팩의 최대 임무다.
> **선행 입력(정독 완료):** 같은 폴더 `source-registry.md`(등급·§8 STALE 금지목록·260702 접근규칙)·`pack-silsa.md`·`pack-sticker.md`(형식) ·
>   `02_ontology/ontology-schema.md`(개체17·관계19·**member_of/has_member/priced_by** 셋트 관계·E9 price_formula·R13 has_member) ·
>   `_workspace/huni-set-product/`(HANDOFF·01_authority/set-checklist.csv·05_gate/set-price-full-diagnosis-260702.md·06_load/*membrane*post-verify·set-product-readiness-master.md[STALE]) ·
>   `_workspace/huni-dbmap/00_schema/ref-product-sets.csv`(설계행) · `_workspace/print-kb/wiki/recipes/calendar.md`·`_curation/pack-calendar.md`(REVERIFY 대조) ·
>   live-snapshot/latest(=snap_20260702_1119 실측) · CLAUDE.md §23(2026-07-03 최신 골든).

---

## 0. 이 팩을 읽는 법 (쉬운 말)

- **정답 소스** = "이 축의 사실은 여기서 가져와라"의 1순위 파일·절·캐시.
- **보조 소스** = 정답을 교차 확인하거나 값을 채우는 2순위.
- **STALE 함정** = "그럴듯하지만 인용하면 틀리는" 오래된 원천. **왜** 틀린지와 **대체 소스**를 함께 적었다.
- **GAP(원천 부재)** = 어느 문서에도 정답이 없어서 지금은 못 닫는 것. 실무진 답변·인간 승인 대기.
- 표기: `tier`(A 절대권위 / B 정본문서 / C 하네스산출·최신우선 / D 역공학·경쟁사 보조),
  `freshness`(FRESH / PARTIAL-STALE(어느 축이 낡음) / STALE=인용금지).
- **수치 손전사 금지:** 아래 표의 모든 숫자·상태값은 결정론 스크립트/실호출 전사(transcribed-by)다.
  라이브 = `live-snapshot/latest` awk 전사 · 셋트 골든 = §23 산출 파일(post-verify·set-price-full-diagnosis) 실호출 전사.
- **KB 답변 범위(사용자 확정·relitigate 금지):** 상품·구성요소·옵션·가격 차원·제약까지만.
  **주문·배송·회원·쿠폰은 범위 밖** — 이 팩도 그 축은 다루지 않는다(거절형 응답 경계).

### 0.1 ★캘린더 universe 판정 (과업 요구 — 확정)

> 과업이 "책자/포토북/캘린더"를 지정했으나, **캘린더는 셋트가 아니다.** 상품마스터 260702 + 라이브 실측으로 확정.

- **판정 = (b) 단품 완제품.** 캘린더 5 form factor `PRD_000108`(탁상)·`109`(미니탁상)·`110`(엽서)·`111`(벽걸이)·`112`(와이드벽걸이)는
  **`t_prd_product_sets` 부모가 아니다**(sets 0행 — 셋트 완제품 아님). 전부 `prd_typ_cd=PRD_TYPE.01`(완제품)·`del_yn=N`·`use_yn=Y`. {transcribed-by `awk t_prd_products.csv`·`awk t_prd_product_sets.csv`}
- **★[교정됨·위키 STALE] 캘린더 정체·가격 둘 다 위키(round-13)와 다름:**
  1. **prd_typ:** 위키 `[CAL-ID-001]`은 "전부 `PRD_TYPE.04 디자인상품`"이라 했으나 **라이브 = `PRD_TYPE.01`**(SOT대로 재분류·upd 2026-06-26). → 위키 .04 서술 **STALE**.
  2. **가격:** 위키 `[CAL-PRC-001]`은 "캘린더 5상품 가격공식 0행·🔴 미적재"라 했으나 **라이브 = 가격공식 바인딩됨(2026-07-01)**: 108/109→`PRF_DGP_CAL_DESK`·111/112→`PRF_DGP_CAL_WIDE`·110→`PRF_DGP_INNER`. {transcribed-by `awk t_prd_product_price_formulas.csv`} → **§26/위키 "캘린더=견적불가" 기록은 STALE**(업로드 캘린더는 원자합산형 공식 바인딩 완료).
- **결론(builder 지침):**
  - **캘린더는 셋트로 모델링 금지**(has_member 엣지 없음) — 단품 완제품 5개로 넣거나, **본 셋트 팩 범위 밖으로 두고 별도 캘린더 팩에서 다룬다**(권장). 본 팩은 판정·정직 표기만 한다.
  - **미적재로 정직 표기할 것 = design-calendar 고정가 surface만.** `t_prd_product_prices` 캘린더 = **0행**(고정가 직접단가 미적재) {transcribed-by `awk t_prd_product_prices.csv`=header만}. `110` 엽서캘린더 `editor_yn=N`(디자인 surface 미구성). → **[GAP-CAL] design-calendar 고정가 미적재 = 유효 GAP 노드**(원천 부재·위키 `[CAL-DC-001]` 🔴 여전). 업로드 캘린더 가격공식은 있으므로 "가격 있는 것처럼" 넣어도 되나, **PRICE≠0 실호출 확인 전엔 candidate(🟡)**로.
  - 캘린더 잔존 결함(삼각대/링 자재 오적재·삼각대거치 공정 mint·봉투 addon)은 위키 `calendar.md` §7 = **REVERIFY**(live 재측정 후 승계).

**★셋트 계열의 5대 특성(다른 상품군과 다른 점):**
1. **셋트 = 부품 조립.** 셋트 완제품(부모 `prd_cd`) ← 반제품 구성원(`sub_prd_cd`·`t_prd_product_sets`). 구성원 역할 `SEMI_ROLE.01 내지`·`.02 표지`·`.03 면지`. 셋트 정체 = 이 조립 구조(`member_of`/`has_member`·R13).
2. **가격 = `evaluate_set_price`**(pricing.py:718 — 구성원별 `evaluate_price` 합산 + 셋트 완제품 공식 + 할인). 단일 상품 `evaluate_price`가 아니다. 가격값 권위 = **라이브 `simulate-set` 실호출 골든**(§3.10).
3. **★라이브가 최근 급변 = latest-wins 강제.** 면지 통합 재설계(072/077/082/088·2026-07-03 COMMIT)·068~070 구성원 mint(2026-06-30)·캘린더 공식 바인딩(2026-07-01)이 **live-snapshot(20260702_1119)보다 뒤 or 그 안에 섞임**. 06-26 readiness-master·06-23 이전 스냅샷 상태값은 **STALE**(§2·§4).
4. **면지 = 무가격 + 내부 택1 목표 모델.** 면지 구성원 기여 = 0(제본비에 포함). 2026-07-03 재설계로 **면지 여러 빈멤버 → 면지 1멤버 + 색 내부 택1(용지 드롭다운)**으로 통합(072=3색·088=4색). 면지 자재(MAT_382~385)는 면지 멤버로 이관(`fn_chk_opt_item_ref` 정합).
5. **양면·GAP 얽힘 다수.** 088(현재값 796,900 vs 088-redesign pending 1,800,000)·069/070(base 공식 vs _FOIL 박분기 이중바인딩)·071(셋트 미구성·cover_mult ×2 BLOCKED)·094/097/100(엔진 골든 PRICE≠0 vs 화면 0원 코드결함) — 전부 **양면/GAP 정직 표기 대상**.

---

## 1. 셋트 계열 상품 인벤토리 (한 눈에·확정)

> prd_cd·확정 slug·구성원(sub_prd_cd·역할)·가격아키타입·라이브 가격상태(골든 or GAP)·소스. **slug 정본 = product-NNN-kebab[HARD]** — builder 강제 채택.
> 구성원 역할·설계값 = `01_authority/set-checklist.csv` + `00_schema/ref-product-sets.csv`, **현재 구성원 = live-snapshot + 면지재설계 post-verify**(재설계 후 면지 통합분 우선).

| prd_cd | 셋트명 | 확정 slug | 현재 구성원(sub_prd·역할) | 가격아키타입 | 라이브 가격상태(1/10/100부·transcribed-by) | 소스 |
|--------|--------|-----------|---------------------------|--------------|---------------------------------------------|------|
| **072** | 하드커버책자 | `product-072-hardcover-booklet` | 073 표지(.02)·284 내지(.01)·**074 면지 1멤버**(.03·색 3택1 382/383/384)·075/076 은퇴(del_yn=Y) | 원자합산형(셋트조합·COVERBIND) | **34,100 / 159,100 / 796,900** {`06_load/…072-post-verify.md §2` 실호출} | ✅ GO |
| **077** | 레더 하드커버책자 | `product-077-leather-hardcover-booklet` | 078 표지(.02)·285 내지(.01)·079 면지 1멤버(.03·색3택1)·080/081 은퇴 | 원자합산형(COVERBIND·072 동형) | **34,100 / 159,100 / 796,900** {CLAUDE.md §23·CHANGELOG 2026-07-03} | ✅ GO |
| **082** | 하드커버 링책자 | `product-082-hardcover-ring-booklet` | 083 표지(.02)·286 내지(.01)·084 면지 1멤버(.03·색4택1 382~385 인쇄포함)·085/086/087 은퇴 | 원자합산형(COVERBIND·트윈링) | **30,184 / 151,844 / 818,438** {CLAUDE.md §23·CHANGELOG} | ✅ GO |
| **088** | 레더 링바인더 | `product-088-leather-ring-binder` | **089 표지(.02)·090 면지 1멤버**(.03·색4택1 382~385)·091/092/093 은퇴·내지 없음(빈 바인더) | 원자합산형(COVERBIND) | **현재값: 34,100 / 159,100 / 796,900** {`…088-post-verify.md §2` 실호출} · **GAP: 088-redesign pending→1,800,000** | ✅ GO(양면·§4) |
| **068** | 중철책자 | `product-068-saddle-stitch-booklet` | 288 표지(.02·PRF_BOOK_COVER)·287 내지(.01·PRF_DGP_INNER·구성원 mint 2026-06-30)·면지없음 | 원자합산형(제본비+표지+내지) | 골든 100부 **158,688**(표지88,688+제본70,000) {`set-price-full-diagnosis §0`} · 화면 final 127,126(코팅드롭 C트랙) | ✅ GO(C트랙 주의·§4) |
| **069** | 무선책자 | `product-069-perfect-bound-booklet` | 290 표지(.02)·289 내지(.01)·면지없음 | 원자합산형 | 골든 100부 **138,688** {`set-price-full-diagnosis §0`} · final 131,072(코팅드롭) | ✅ GO(양면 박분기·§4) |
| **070** | PUR책자 | `product-070-pur-booklet` | 292 표지(.02)·291 내지(.01)·면지없음 | 원자합산형 | 골든 100부 **288,688** {`set-price-full-diagnosis §0`} · final 281,072(코팅드롭) | ✅ GO(양면 박분기·§4) |
| **071** | 트윈링책자 | `product-071-twin-ring-booklet` | **없음(셋트 미구성·sets 0행)** {`awk t_prd_product_sets.csv`=0} | (셋트 미성립) | **GAP — 구성원 미mint·cover_mult ×2 엔진 BLOCKED** | ⚪ GAP(§4) |
| **094** | 엽서북 | `product-094-postcard-book` | 095 내지(.01·페이지 20~30/+10)·096 표지(.02) | 고정가형(부모 all-in) | 엔진골든 100부 **450,000**(opt OPV_000491+siz003) {`set-price-full-diagnosis §3`} · **화면 0원=코드C트랙** | ✅ GO(양면·§4) |
| **097** | 떡메모지 | `product-097-tteok-memo` | 098 내지(.01·묶음 50/100장) | 고정가형(부모 all-in) | 엔진골든 100부 **135,000**(bdl_qty=50) {`set-price-full-diagnosis §3`} · 화면 0원=C트랙 | ✅ GO(양면·§4) |
| **100** | 포토북 | `product-100-photobook` | 101 내지(.01)·102/103/105/106/107 표지 5종(.02·택1)·104 면지(.03) | 고정가형(부모 all-in·base24+per2p) | 엔진골든 100부 **1,500,000**(opt OPV_000484+siz269) {`set-price-full-diagnosis §3`} · 화면 0원=C트랙 | ✅ GO(양면·§4) |

> **캘린더(참고·셋트 아님·§0.1):** `product-108-desk-calendar`·`product-109-mini-desk-calendar`·`product-110-postcard-calendar`·`product-111-wall-calendar`·`product-112-wide-wall-calendar` = 단품 완제품(PRD_TYPE.01)·업로드 가격공식 바인딩(PRF_DGP_CAL_*·2026-07-01·🟡 PRICE≠0 실호출 확인 전). design-calendar 고정가=미적재 GAP.
> **구성원 slug 규약:** 반제품 구성원(PRD_TYPE.02)은 `product-NNN-<부모>-<역할>` 형(예 `product-073-hardcover-booklet-cover`·`product-284-hardcover-booklet-inner`·`product-074-hardcover-booklet-membrane`). 은퇴 구성원(075/076/085/086/087/091/092/093)은 **`del_yn=Y`이므로 노드 미생성**(GAP도 아님·정상 은퇴).

### 1.1 ★라이브 급변 신사실 (readiness-master 06-26 → 현재) — 최대 임무

> 이 절이 셋트 팩의 최대 임무다. 06-26 readiness-master가 "BLOCKED/미바인딩"으로 적은 셋트 다수가 **6월 말~7월 초 라이브 COMMIT으로 이미 동작화**됐다. {전부 transcribed-by `awk live-snapshot/latest` + §23 post-verify 실호출}

- **[동작화됨] 072/077/082 = 미바인딩 → 바인딩 완료.** readiness-master(06-26)는 072/077/082/100을 "❌ 미바인딩·🔴 BLOCKED"로 적었으나, **라이브 = 부모공식 바인딩됨**: 072/077→`PRF_HC_MUSEON_SET`·082→`PRF_HC_TWINRING_SET`·100→`PRF_PHOTOBOOK_FIXED`. {transcribed-by `awk t_prd_product_price_formulas.csv`} → **readiness-master 06-26 상태값 STALE**(§2 T-1).
- **[신설됨] 068/069/070 = 셋트 구성원 mint 완료.** 06-26엔 068~071이 "구성원 미구성(mint 필요·BLOCKED)"였으나, **068/069/070은 표지·내지 구성원이 mint되어 셋트 성립**(068=288 표지+287 내지·069=290+289·070=292+291·전부 reg 2026-06-30). {transcribed-by `awk t_prd_product_sets.csv`} → set-checklist.csv의 "PRD_(mint:…예약)·BLOCKED" 행은 068/069/070에 대해 **STALE**(§2 T-2).
- **[잔존 GAP] 071 트윈링책자 = 여전히 셋트 미구성.** 071은 `t_prd_product_sets` **0행**(구성원 미mint). 부모 071 자체는 `PRF_BIND_TWINRING` 바인딩(제본비만)이나 셋트로 성립 안 함. **cover_mult ×2 엔진 C트랙 BLOCKED**([[../../_foundation/remediation/CODEBUG-cover-mult-x2-undercharge.md]]). {transcribed-by `awk t_prd_product_sets.csv`=0} → **GAP 노드**(§4·§5).
- **[면지 통합 재설계됨] 072/077/082/088 = 면지 여러 빈멤버 → 면지 1멤버 통합.** 2026-07-03 COMMIT으로 각 셋트 면지 = **단일 면지 멤버 + 색 내부 택1(용지 드롭다운)**: 072=074(3색 382/383/384)·088=090(4색 382~385 인쇄면지 포함). 은퇴 면지 멤버(075/076·085/086/087·091/092/093) = **`del_yn=Y`**. {transcribed-by `06_load/…072-post-verify.md §1`·`…088-post-verify.md §1`} → **live-snapshot 20260702_1119(면지 재설계 前 상태·088=구멤버 5개)는 이 4셋트 구성원 구조에 STALE**(§2 T-3). 골든은 무손상(면지 기여 0).
- **[양면·미COMMIT] 088-redesign-260702 = 적재 승인 대기.** 현재 라이브 088 = COVERBIND 모델(100부 796,900). 별개 워크스트림 `03_design/088-redesign-260702/`(표지 9,000/부·싸바리 제본) = **S1~S8 GO·codex 13/13 합의·인간 승인 대기(COMMIT 미실행)** → 승인 시 100부 **1,800,000**로 변경. 두 워크스트림 **완전 직교**(088-post-verify §5 실증). → **088 노드 = 현재값 796,900 + GAP(pending)** 양면(§4).
- **[불변·양면] 069/070 = base 공식 + _FOIL 박분기 이중 바인딩 행 실재.** 라이브에 069→`PRF_BIND_MUSEON`(active) + `PRF_BIND_MUSEON_FOIL`(note "인간승인 후 COMMIT")·070 동형. {transcribed-by `awk t_prd_product_price_formulas.csv`} → 박 선택 분기 공식이 **행으로 존재하나 활성 정본은 base**(_FOIL은 박분기 조건부·candidate). builder는 base 공식을 priced_by 정본으로, _FOIL은 🟡 candidate로.

---

## 2. STALE 함정 목록 (셋트 계열 국한 — 인용 시 lint FAIL)

> 전역 금지목록은 `source-registry.md` §8. 아래는 **셋트 작업에서 특히 밟기 쉬운** 함정만.

| # | 함정 원천 | 왜 틀리는가 | 대체 소스 |
|---|-----------|-------------|-----------|
| T-1 | `06_load/set-product-readiness-master.md`(2026-06-26) **"072/077/082/088/100 = ❌ 미바인딩·🔴 BLOCKED"** | 06-26 이후 부모공식 바인딩·동작화 COMMIT 완료(§1.1). 072/077/082/100 전부 PRICE≠0 | live `t_prd_product_price_formulas.csv` + `05_gate/set-price-full-diagnosis-260702.md` |
| T-2 | `set-checklist.csv`/`ref-product-sets.csv` **068~071 "PRD_(mint:…예약)·mint필요·BLOCKED"** | 068/069/070은 구성원 mint 완료(2026-06-30·셋트 성립). 071만 잔존 GAP | live `t_prd_product_sets.csv`(068/069/070 실재·071 0행) |
| T-3 | **live-snapshot 20260702_1119의 072/077/082/088 구성원 구조**(088=면지 4멤버 090~093 등) | 2026-07-03 면지 통합 재설계 COMMIT이 스냅샷보다 뒤 — 면지=1멤버 통합·나머지 del_yn=Y | `06_load/leather-hardcover-membrane-{072,077,082,088}-post-verify.md` §1 |
| T-4 | 260702 diagnosis **072 final=968,119·077=815,338**(면지 재설계 前 copies=100) | 면지 재설계 후 골든 = 072/077=796,900(내지 기여도 재구성). 최신=post-verify 실호출 | `…072-post-verify.md §2`(34,100/159,100/796,900) + CLAUDE.md §23 |
| T-5 | **094/097/100 "화면 0원 = 견적 결함"으로 단정** | 엔진 골든 PRICE≠0(450k/135k/1.5M). 화면 0원 = 셋트 UI siz_cd 미전파 **코드 C트랙**(가격사실 아님) | `set-price-full-diagnosis §3` + `DEV-REQUEST-set-sim-sizcd-260702.md` |
| T-6 | 위키 `recipes/calendar.md` **"캘린더 prd_typ=.04 디자인상품·가격공식 0행 🔴 미적재"** | 라이브 재분류(.01)·가격공식 바인딩(2026-07-01·PRF_DGP_CAL_*)으로 낡음(§0.1) | live `t_prd_products.csv`·`t_prd_product_price_formulas.csv` |
| T-7 | `price-engine-ddl.md`·`prcx01-pricing-model`(8차원·frm_typ·좌표) | 구설계 — 셋트 가격 권위 = `evaluate_set_price`(pricing.py:718) + live `t_prc_*`(§8-2/3) | pricing.py 직접 + live `t_prc_price_formulas`/`formula_components` |
| T-8 | 위키 `recipes/calendar.md` **7절 결함표(C-CAL-01~14)를 "현재 결함"으로 인용** | 캘린더 정체·가격이 6~7월 COMMIT으로 변화 — 시점 낡음(삼각대/링·plate 등만 잔존) | 각 행을 §0.1 + live-snapshot으로 "해소/잔존" 재판정 |
| T-9 | 셋트 골든을 **단일 `evaluate_price`로 계산** | 셋트는 `evaluate_set_price`(구성원 합산+부모공식+할인)·시뮬 엔드포인트=`price_simulate_set`(price_views.py:1888) | pricing.py:718 + `set_full_scan.py`(HuniSim.simulate_set) |
| T-10 | `load_master.py` 입력 v03 xlsx / STALE 컬럼(`addon_prd_cd`·excl_groups·constraint_json) | 구 마이그레이션·Phase7/11 삭제 컬럼(§8-1/5). 셋트 구조는 live `t_prd_product_sets` 실측 | 260702 엑셀 + live-snapshot 컬럼 실측 |

---

## 3. 축별 큐레이션 (정답 → 보조 → STALE 함정 → GAP) — 12축

> 셋트는 특히 **§3.12 셋트구성(member_of/has_member)·§3.10 가격공식(evaluate_set_price)·§3.5 구성원 자재·§3.6 구성원 공정** 축이 중점.

### 3.1 정체(identity) — 무엇인가

- **정답 소스:** live `t_prd_product_sets.csv`(부모↔구성원 실재 = 셋트 성립 판정) + `01_authority/set-checklist.csv`(설계 역할·min/max/incr·권위행) + `_foundation/product-type-classification-sot.md`(셋트 완제품=t_prd_product_sets 부모 등록). {tier A/C/B · FRESH}
- **보조:** live `t_prd_products.csv`(prd_typ·use_yn·del_yn) · `05_gate/set-price-full-diagnosis-260702.md`(19셋트 전수).
- **핵심 사실(승계):** 셋트 완제품(부모) = **`t_prd_product_sets`에 부모로 등록된 상품**(단일 완제품과 구분되는 유일 기준·CLAUDE.md §1 [HARD]). 라이브 활성 셋트 부모 = **068·069·070·072·077·082·088·094·097·100**(본 팩 범위) + 문구 172~181(범위 밖). **071은 셋트 미성립(GAP)**·**캘린더 108~112는 셋트 아님(단품·§0.1)**. 부모 prd_typ_cd = 셋트 완제품이나 라이브 라벨은 상품별 상이(094/097/100/072 등=`.04`로 남은 예도 있음 — set-checklist는 `PRD_TYPE.04` 표기, but SOT상 셋트완제품; 라이브 실값은 prd_cd별 재측정). **구성원 = 반제품 `PRD_TYPE.02`**. {transcribed-by `awk t_prd_products.csv`·`awk t_prd_product_sets.csv`}
- **위키 REVERIFY 대조:** 위키엔 셋트 전용 레시피 없음(booklet/photobook 레시피가 부분 대응) → live `t_prd_product_sets` 실측이 정체 정답. 캘린더 `[CAL-ID-001]`은 §0.1로 재조준(셋트 아님·.01).
- **STALE 함정:** T-1·T-2·T-6.
- **GAP:** **[GAP-SET-1]** 071 트윈링 셋트 미구성(구성원 미mint·cover_mult BLOCKED). 부모 prd_typ_cd 라벨 정합(셋트완제품 코드 통일 여부)은 확인 대상.

### 3.2 차원 — 사이즈(size)

- **정답 소스:** live `t_prd_product_sizes.csv`(구성원별 사이즈) + `set-checklist.csv`(내지 페이지 min/max/incr) + `HANDOFF.md`(★백필 원천=내지[HARD]·표지=책등 포함 펼침 사이즈라 가격표 좌표 밖). {tier A/C · FRESH}
- **핵심 사실(★셋트 특유):** 셋트 사이즈는 **구성원 단위**로 존재(표지 사이즈≠내지 사이즈·표지는 책등 포함 펼침 사이즈). **가격 좌표의 기준 사이즈 = 내지(SEMI_ROLE.01)** — 셋트 UI가 가격 낼 때 내지 siz_cd를 써야 함(표지 펼침 siz는 가격표 좌표에 없음). ★**셋트 화면 0원 코드결함(094/097/100)의 근원 = 셋트 UI가 set_selections에 siz_cd 미전파** → 백필 원천은 반드시 내지(`DEV-REQUEST-set-sim-sizcd-260702`·HANDOFF 명기). 내지 페이지 가변(엽서북 20~30/+10·중철 4~28/+4·무선/PUR 24~300/+2)은 `bundle_qty`/`page_rule` 축(§3.4).
- **위키 REVERIFY 대조:** 없음(셋트 사이즈=구성원 실측).
- **STALE 함정:** 표지 펼침 siz를 가격 좌표로(390×268 미등록 이력·HANDOFF CFM-COVER-SPREAD-SIZ).
- **GAP:** **[GAP-SET-2]** 셋트 UI siz_cd 미전파 = **코드 C트랙**(가격사실 아님·§3.10·T-5). 하드커버 표지 펼침 siz 등록 여부는 COVERBIND 통가로 무영향(072 골든 정합).

### 3.3 차원 — 도수(색상 수) + 화이트 별색

- **정답 소스:** live `t_prd_product_print_options.csv`(구성원별) + `t_prt_print_options`(POPT 코드값). {tier A · FRESH}
- **핵심 사실:** 셋트 도수 = **구성원(표지·내지) 단위 인쇄옵션**. 표지 인쇄(POPT 단/양면·칼라/흑백)는 표지 member·COVERBIND 통가에 포함. 내지 인쇄(S1 단면/S2 양면)는 내지 member 공식(`PRF_DGP_INNER`)에서 계산. ★**S1/S2 내지인쇄 이중합산 = 가격엔진 구조결함**(양면 주문 시 S1+S2 둘 다 매칭·배타선택 부재·전 책자 공통·094도 보유·HANDOFF PRF 트랙 NO-GO) = **코드 C트랙**(온톨로지 사실 아님).
- **위키 REVERIFY 대조:** 없음(구성원 실측).
- **STALE 함정:** T-7(도수를 clr_cd로). 도수를 셋트 부모 속성으로 오모델(구성원 축임).
- **GAP:** **[GAP-SET-3]** S1/S2 이중합산 = 코드 C트랙(전 책자·엔진 use_dims·개발팀).

### 3.4 차원 — 수량규칙(내지 페이지·묶음수·bundle/qty)

- **정답 소스:** live `t_prd_product_sets.csv`(내지 member 행의 min/max/incr = 페이지 가변) + `t_prd_product_bundle_qtys.csv`(묶음) + `set-checklist.csv`. {tier A/C · FRESH}
- **핵심 사실(★셋트 특유·[HARD]):** 셋트 내지 member의 `min/max/incr`(셋트행 컬럼) = **페이지 가변**(엽서북 20~30/+10·중철 4~28/+4·무선/PUR 24~300/+2·트윈링 8~100/+2). ★**db_comment상 "구성원 개수"이나 실제 = 페이지수 오등록·but load-bearing**(memberMulti 수량입력=페이지 선택·[[../../../_workspace/huni-set-product]] set-membrane target model) → **페이지 단가 무손상[HARD]**·미변경(§23-inner). 떡메모지 097 = 묶음수(50/100장 `bundle_qtys` PRD_000097). 포토북 100 = base24P + per2p(내지 member `PRF_PHOTOBOOK_INNER`).
- **위키 REVERIFY 대조:** booklet 레시피 "기본24P+추가2P당"(엔진 표현 가능·[[book-set-page-pricing-inner-member]]) INHERIT.
- **STALE 함정:** 내지 min/max를 "구성원 개수"로 문자 해석(db_comment 오등록·실은 페이지수).
- **GAP:** **[GAP-SET-4]** 내지 페이지 단가(D-2·후속)·인쇄면지 인쇄비(D-3·후속·hlg O-1 잔여). 내지 min/max 라벨 정정(페이지수) = 표시만·가격 무손상.

### 3.5 자재(materials) — ★면지 통합·D링 불가침

- **정답 소스:** `06_load/leather-hardcover-membrane-{072,088}-post-verify.md` §1(면지 자재 통합·D링 불가침 실측) + live `t_prd_product_materials.csv`(구성원별·usage_cd) + `set-membrane-1member-taku1-target-model-260703`(메모리). {tier C/A · FRESH}
- **핵심 사실(★셋트 특유·2026-07-03 최신):**
  - **면지 자재 = 면지 멤버로 이관됨.** 재설계로 면지 색(화이트 MAT_382·블랙 383·그레이 384·인쇄면지 385)이 **부모 → 면지 멤버(USAGE.03)**로 이관·색 내부 택1(용지 드롭다운·기본 화이트 dflt=Y). 072=3색(382/383/384)·082/088=4색(+385 인쇄면지). {transcribed-by post-verify §1·§3} 부모(072/088)의 면지 자재·옵션그룹은 **은퇴**(활성 0).
  - **★[HARD] USAGE.07 D링자재 불가침**(088). MAT_247/248/249(D링) = 088에 오직 USAGE.07로만 존재·전부 활성 3 불변. 면지 재설계(USAGE.03 대상)가 **D링(USAGE.07) 미터치**·격리(088-post-verify §4). → D링 자재는 셋트 자재 노드로 보존(은퇴 아님).
  - **★[HARD 사용자] 면지 자재는 기여 0이어도 삭제 금지**(제본비 포함 무가격·선택지). 인쇄면지 385도 기여 0이나 선택지로 보존.
- **위키 REVERIFY 대조:** booklet 레시피 표지/면지 자재 서술 = REVERIFY(면지 통합 후 live 재측정). 캘린더 자재(삼각대/링 오적재)는 캘린더 팩 소관.
- **STALE 함정:** T-3(스냅샷 088=면지 4멤버 자재 부모 귀속·재설계 前). 면지 자재를 부모 귀속으로(재설계로 멤버 이관됨).
- **GAP:** **[GAP-SET-5]** 인쇄면지(385) 인쇄비 배선(D-3·기여 0·후속). 표지 자재(레더 등) 정확 단가 = COVERBIND use_dims=[min_qty]만이라 자재 델타 미반영(§3.10·엔진 C트랙).

### 3.6 공정(processes) — ★제본(COVERBIND·싸바리·트윈링·PUR·무선·중철)

- **정답 소스:** live `t_prd_product_processes.csv`(셋트 본체 set_procs·제본그룹 PROC_000017) + `set-price-full-diagnosis-260702.md` §0·§2(제본 공식 골든) + `HANDOFF.md`(088 싸바리 COMP_BIND_SSABARI@PROC_000098). {tier A/C · FRESH}
- **핵심 사실(★셋트 정체 공정):** 셋트 완성 = **제본 공정**이 form을 만든다.
  - **하드커버/레더(072/077/082/088)** = **COVERBIND 통합**(`COMP_HC_MUSEON_COVERBIND`·표지+제본 통가·use_dims=[min_qty]·자재 미종속). 088=싸바리(`COMP_BIND_SSABARI`) or COVERBIND(현행) — 088-redesign pending 시 싸바리 전환.
  - **분해형(068/069/070)** = 제본비 부모공식(중철 `PRF_BIND_SUM`·무선 `PRF_BIND_MUSEON`·PUR `PRF_BIND_PUR`) + 표지 member(`PRF_BOOK_COVER` 3비목) + 내지 member(`PRF_DGP_INNER`).
  - **트윈링(082/071)** = 트윈링제본(082=COVERBIND·071=`PRF_BIND_TWINRING` 제본비만·미성립).
  - ★**표지 코팅 드롭 C트랙**(068/069/070): 셋트경로 시뮬(`price_views.py:1930`)이 member selections에 coat_side_cnt 미전달 → 표지 코팅비(100부 50,000) 저평가. **PRICE≠0 무해·골든만 저평가**·개발팀(§4).
- **위키 REVERIFY 대조:** booklet 제본 서술·캘린더 `[CAL-BOM-002]`(트윈링 PROC_000021·삼각대거치 mint) = REVERIFY(캘린더는 셋트 아님·캘린더 팩).
- **STALE 함정:** T-10(dep_proc_cd·excl_groups oracle 소멸). `PRF_BIND_SUM`에 중철만 배선(무선/PUR 3.3배 과소)은 **이미 교정 COMMIT됨**(readiness-master B-4는 STALE·A2 교정 3건).
- **GAP:** **[GAP-SET-6]** 088 싸바리 제본비 정본화(redesign pending) · 코팅 드롭 C트랙 · 물리 바인더 공정(3구타공 등·가격무관 생산정보).

### 3.7 인쇄옵션(print_options) — 인쇄 방식

- **정답 소스:** live `t_prd_product_print_options.csv`(구성원별) + `t_prt_print_options`. {tier A · FRESH}
- **핵심 사실:** 셋트 인쇄옵션 = 구성원(표지·내지·면지) 단위. 대부분 디지털인쇄 라우팅(내지 `PRF_DGP_INNER`=디지털 계열). 면지는 인쇄면지(385)만 인쇄 대상(기여 0). 셋트 부모엔 인쇄옵션 축 없음(구성원 축).
- **위키 REVERIFY 대조:** 없음.
- **STALE 함정:** T-7.
- **GAP:** 없음(구성원 인쇄옵션 축 단순).

### 3.8 판형(plate size)

- **정답 소스:** live `t_prd_product_plate_sizes.csv`(구성원별·dflt) + `HARNESS-DOMAIN-RULES-260701.md`(종이류만 판형·fn_best_plate·fn_calc_pansu). {tier A/B · FRESH}
- **핵심 사실(★도메인 [HARD]):** 셋트 구성원 중 **종이류(내지·표지·면지)만 판형** 대상 — 내지 국4절 plate·fn_calc_pansu 판걸이수(t_siz_pansu lookup→기하 폴백). 셋트 부모 자체엔 판형 없음(구성원 축). D링·링·바인더 부속은 비종이류(판형 없음). 094 부모 판형 SIZE_000499(구성원 빈껍데기 해소 시 COMMIT됨·HANDOFF).
- **위키 REVERIFY 대조:** 캘린더 `[CAL-DIM-003]` 출력판형(.01/.03) = 캘린더 팩 소관.
- **STALE 함정:** 비종이류 부속(D링·링)에 판형 이식.
- **GAP:** 없음(셋트 판형=구성원 종이류 실측).

### 3.9 옵션그룹/제약(CPQ·constraints) — ★면지 색 옵션

- **정답 소스:** `06_load/…{072,088}-post-verify.md` §1(면지 옵션그룹 이관·OPT_064/067) + live `t_prd_product_option_groups/options/option_items.csv` + `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 shape·§31). {tier C/A · FRESH}
- **핵심 사실(★셋트 특유·재설계 최신):**
  - **면지 색 = 면지 멤버 옵션그룹**(재설계로 부모→멤버 이관). 072 면지멤버 074=`OPT_064`(화/블/그 3택1·자재 ref `OPT_REF_DIM.03`)·088 면지멤버 090=`OPT_067`(화/블/그/인쇄 4택1·OPV_447→MAT_385). 부모(072/088)의 면지 옵션그룹은 **은퇴**(활성 0). {transcribed-by post-verify §1}
  - **★[HARD] 옵션참조(ref_dim_cd=자재)는 같은 부모 prd_cd에 실재 필수**(`fn_chk_opt_item_ref` 트리거) — 재설계가 면지 자재를 멤버로 이관한 이유(옵션참조 정합). 100 포토북 표지 5종 택1(102/103/105/106/107)·094 권종 옵션(OPV_000491)·100 표지 옵션(OPV_000484)도 CPQ 옵션.
  - 제약은 **폼빌더 정형 shape로만**(raw JSONLogic 금지·§31). 셋트 제약(예 인쇄면지 선택 시 인쇄비)은 후속.
- **위키 REVERIFY 대조:** 캘린더 `[CAL-CPQ-001]`(택일그룹·excl 흡수) = 캘린더 팩.
- **STALE 함정:** T-10(constraint_json 컬럼 삭제·excl_groups Phase11 삭제). 면지 옵션을 부모 귀속으로(재설계로 멤버 이관).
- **GAP:** **[GAP-SET-7]** 구성원 옵션그룹 UI 렌더(D-1·후속·hlg O-1). 셋트 제약(인쇄면지→인쇄비·면지 조합) 명시화.

### 3.10 가격공식(price formula) — ★evaluate_set_price

- **정답 소스:** `raw/webadmin/webadmin/catalog/pricing.py`(`evaluate_set_price`:718 = 단일 권위) + live `t_prd_product_price_formulas.csv`(셋트 부모 바인딩) + `05_gate/set-price-full-diagnosis-260702.md`(19셋트 골든 실호출) + `06_load/…post-verify.md`(면지 재설계 골든). {tier A/C · FRESH}
- **핵심 사실(★셋트 가격 = 조합):**
  - **가격 = `evaluate_set_price`** = 구성원별 `evaluate_price` 합산 + 셋트 완제품(부모) 공식 + 할인. 시뮬 = `price_simulate_set`(price_views.py:1888). **단일 `evaluate_price` 아님**(T-9).
  - **부모공식 바인딩(라이브 실측):** 068→`PRF_BIND_SUM`·069→`PRF_BIND_MUSEON`(+_FOIL candidate)·070→`PRF_BIND_PUR`(+_FOIL)·072/077→`PRF_HC_MUSEON_SET`·082→`PRF_HC_TWINRING_SET`·088→`PRF_LEATHER_RINGBINDER_SET`·094→`PRF_PCB_FIXED`·097→`PRF_TTEOKME_FIXED`·100→`PRF_PHOTOBOOK_FIXED`. {transcribed-by `awk t_prd_product_price_formulas.csv`}
  - **가격아키타입 2종(prc_typ 기록):** ① **원자합산형(셋트 조합)** = 072/077/082/088(COVERBIND 통가·내지 member·면지 0)·068/069/070(제본비+표지+내지). ② **고정가형(부모 all-in)** = 094/097/100(부모공식이 옵션차원 요구·구성원 기여 0·verbatim 468셀·[[postcard-book-sim-convergence-260702]]).
  - **★가격 경계(방법론·D-18):** 온톨로지는 **priced_by(부모공식)·has_member(구성원)·use_dims 차원 선언까지만**. 값 계산=`evaluate_set_price` 권위(KB 밖). 셋트 이중합산 방지도 엔진 소관(스키마 §4.4).
- **★가격값(latest·transcribed-by):**
  - 072/077/088 = 34,100 / 159,100 / 796,900 [1/10/100부] {072/088=post-verify 실호출·077=CLAUDE.md §23}
  - 082 = 30,184 / 151,844 / 818,438 {CLAUDE.md §23}
  - 068 골든 100부 158,688 / 069 138,688 / 070 288,688 {set-price-full-diagnosis §0} (화면 final은 코팅드롭 C트랙만큼 낮음)
  - 094=450,000 / 097=135,000 / 100=1,500,000 [100부·정확선택] {set-price-full-diagnosis §3}
- **위키 REVERIFY 대조:** booklet/photobook 레시피 가격 서술 = REVERIFY(면지 재설계·바인딩 최신 반영). 캘린더 가격 = §0.1.
- **STALE 함정:** T-1(미바인딩)·T-4(재설계 前 골든)·T-7(price-engine-ddl)·T-9(단일 evaluate_price).
- **GAP:** **[GAP-SET-8]** 088-redesign pending(796,900→1,800,000)·071 미성립·069/070 _FOIL 정본화·레더 프리미엄/cover_mult ×2(엔진 C트랙).

### 3.11 가격구성요소(price components) + 단가행 차원(component prices)

- **정답 소스:** live `t_prc_price_components.csv`·`t_prc_formula_components.csv`(배선)·`t_prc_component_prices.csv`(COMP_HC_MUSEON_COVERBIND 등 실측). {tier A · FRESH}
- **핵심 사실:**
  - **COVERBIND 6티어**(088 실측): 1→34,100·4→22,425·10→15,910·50→10,170·100→7,969·1000→6,368.4. use_dims=`["min_qty"]`·**자재 미종속**(레더 델타 미반영). {transcribed-by `…088-post-verify.md §2a`}
  - 분해형(068~070) = 표지 comp(`PRF_BOOK_COVER` 3비목: 인쇄+코팅+용지)·내지 comp(`PRF_DGP_INNER`)·제본 comp(제본비). 고정형(094/097/100) = 부모 comp(`COMP_PCB_*`·`COMP_TTEOKME`·`COMP_PHOTOBOOK_BASE`·use_dims에 opt_cd·bdl_qty·siz_cd).
  - **면지/은퇴 구성원 = 가격 미배선**(`component_prices` 0행·면지 재설계 무손상 근거·post-verify §2).
- **★단가행 접기(방법론·D-22):** 단가행은 노드로 펼치지 않고 **가격구성요소 노드의 속성/집계로 접는 것이 기본값**(COVERBIND 6티어=comp 속성).
- **위키 REVERIFY 대조:** 없음(live 실측).
- **STALE 함정:** T-7. `PRF_BIND_SUM` 중철만 배선(이미 교정·readiness-master B-4 STALE).
- **GAP:** 레더 델타(COVERBIND use_dims=[min_qty] 한계·엔진 C트랙)·cover_mult ×2(071·C트랙).

### 3.12 ★셋트 구성(member_of / has_member) — 셋트 정체 축

- **정답 소스:** live `t_prd_product_sets.csv`(부모 prd_cd·sub_prd_cd·disp_seq·min/max/incr·note) + `06_load/…post-verify.md`(면지 통합 후 활성 구성원) + `01_authority/set-checklist.csv`(역할 SEMI_ROLE·권위행). {tier A/C · FRESH}
- **핵심 사실(★셋트 특유·R13 has_member):**
  - **member_of 관계** = 셋트 완제품(부모 prd_cd) ← 반제품 구성원(sub_prd_cd). 스키마 R13 `has_member`(product→product·1:N). 구성원 역할 = `SEMI_ROLE.01 내지`·`.02 표지`·`.03 면지`.
  - **현재 활성 구성원(면지 재설계 후·transcribed-by post-verify §1):** 072=073 표지+284 내지+074 면지(1)·088=089 표지+090 면지(1·내지 없음 빈 바인더). 은퇴 구성원(075/076·091/092/093 등)=`del_yn=Y` → **노드 미생성**.
  - **068~070(신설·mint 2026-06-30):** 068=288 표지+287 내지·069=290+289·070=292+291(면지 없음).
  - **094/097/100:** 094=095 내지+096 표지·097=098 내지·100=101 내지+102/103/105/106/107 표지 5종+104 면지.
  - **★search-before-mint[HARD]:** 반제품 구성원 신규 mint 금지(미등록은 BLOCKED→dbmap 위임). 071 구성원 미mint = GAP.
- **위키 REVERIFY 대조:** 없음(셋트 구조=live 실측·위키 셋트 레시피 부재).
- **STALE 함정:** T-2(068~071 "mint 예약·BLOCKED")·T-3(스냅샷 면지 구멤버). 은퇴 구성원을 활성으로.
- **GAP:** **[GAP-SET-1]** 071 구성원 미mint(cover_mult ×2 BLOCKED). 추가상품(addon) = 셋트 계열엔 얕음(캘린더 봉투 addon은 캘린더 팩).

---

## 4. ★핵심 임무 — latest-wins·양면 정직 표기표

> readiness-master(06-26)·스냅샷(20260702_1119) 상태값을 그대로 옮기면 T-1/T-2/T-3 오염. 아래는 **각 셋트의 현재 상태**를 §23 최신 COMMIT·post-verify 실호출로 재판정한 것. {전부 transcribed-by post-verify 실호출·set-price-full-diagnosis·awk live-snapshot}

| 셋트 | readiness-master 06-26 / 스냅샷 상태 | **현재 상태(최신 COMMIT)** | 양면/판정 |
|------|-------------------------------------|----------------------------|-----------|
| 072 | ❌ 미바인딩·🔴 BLOCKED·면지 4멤버 | PRF_HC_MUSEON_SET·면지 1멤버(074·3색)·**골든 34,100/159,100/796,900** | **동작화**(T-1/T-3·INHERIT 최신값) |
| 077 | ❌ 미바인딩(072 후) | PRF_HC_MUSEON_SET·면지 1멤버·**796,900** | **동작화** |
| 082 | ❌ 미바인딩·인쇄면지 미연결 | PRF_HC_TWINRING_SET·면지 1멤버(4색·385 포함)·**818,438** | **동작화** |
| 088 | ⚠️ HOLD·제본 "보류중" | COVERBIND·면지 1멤버(4색)·**현재값 796,900** + **GAP: 088-redesign pending→1,800,000**(직교·미COMMIT) | **동작화·양면**(현재값+pending) |
| 068 | 🔴 BLOCKED·구성원 미구성 | 구성원 mint(288/287)·PRF_BIND_SUM·**골든 158,688**·화면 127,126(코팅드롭 C트랙) | **동작화·C트랙 주의** |
| 069 | 🔴 BLOCKED | 구성원 mint(290/289)·PRF_BIND_MUSEON(+_FOIL candidate)·**138,688** | **동작화·양면(박분기)** |
| 070 | 🔴 BLOCKED | 구성원 mint(292/291)·PRF_BIND_PUR(+_FOIL)·**288,688** | **동작화·양면(박분기)** |
| 071 | 🔴 BLOCKED | **셋트 미구성(sets 0행)·cover_mult ×2 엔진 BLOCKED** | **GAP(미성립)** |
| 094 | 🟡 PARTIAL(30P만) | PRF_PCB_FIXED·구성원 빈껍데기 해소 COMMIT·**엔진골든 450,000** / **화면 0원=코드C트랙** | **동작화·양면(엔진≠화면)** |
| 097 | 🟢 READY | PRF_TTEOKME_FIXED·min_qty 6·**135,000** / 화면 0원=C트랙 | **동작화·양면** |
| 100 | 🔴 BLOCKED | PRF_PHOTOBOOK_FIXED·**1,500,000** / 화면 0원=C트랙 | **동작화·양면** |
| 캘린더 108~112 | (위키) .04·가격 0행 🔴 | .01 완제품·PRF_DGP_CAL_* 바인딩(2026-07-01)·**셋트 아님** / design-calendar 고정가=GAP | **정체·가격 STALE 교정·§0.1** |

> **★양면 노드 지침(스키마 §1.3-b·badge=defect/gap):**
> - **088:** `current_value: 100부 796,900 (COVERBIND·live COMMIT)` / `authority_value: 100부 1,800,000 (088-redesign-260702·표지 9,000·싸바리·pending 인간승인)`. 두 값 다 보존(직교 워크스트림).
> - **094/097/100:** `가격사실 = 엔진 골든 450k/135k/1.5M (PRICE≠0)` · `화면 0원 = 코드 C트랙(DEV-REQUEST-set-sim-sizcd·가격 무관)`. → 화면 0원을 "가격 결함"으로 넣지 말 것(T-5).
> - **069/070:** `priced_by 정본 = PRF_BIND_MUSEON/PUR(base·active)` · `PRF_*_FOIL = 박분기 candidate(🟡·인간승인 후)`.
> - **071:** GAP 노드(⚪) — `gap_what: 트윈링책자 셋트 구성원 미mint·cover_mult ×2 엔진 BLOCKED` · `gap_fill_from: 개발팀 엔진 수정(CODEBUG-cover-mult-x2) 후 082 동형` · `gap_owner: dev`.
> - **068/069/070 코팅 드롭:** `가격 = PRICE≠0(정상)` · `골든 저평가 = C트랙(price_views.py:1930 coat_side_cnt 미전달·개발팀)`. PRICE≠0 무해.

> **원장 경로:** 면지 통합 재설계 = §23 CHANGELOG 2026-07-03(072/077/082/088 COMMIT·post-verify PASS). 068~070 구성원 mint·동작화 = 2026-06-30~07-01([[leather-hardcover-077-live-commit-260701]]). 캘린더 공식 바인딩 = 2026-07-01(t_prd_product_price_formulas note). 088-redesign·071·코팅드롭·siz_cd 미전파 = **미적재/코드 C트랙**(DB 미적재 유지·인간/개발 승인 대기).

---

## 5. 지식 구축가 인계 메모 (셋트 계열 착수 시)

1. **셋트 정체·구조는 live `t_prd_product_sets` 실측이 정답**(FRESH). **readiness-master 06-26·스냅샷 20260702_1119 상태값은 §1.1·§4로 전부 재조준** — 072/077/082/088 동작화·068~070 mint·면지 1멤버 통합이 이미 반영됨(T-1/T-2/T-3).
2. **가격 = evaluate_set_price(구성원 합산+부모공식+할인)** — 단일 evaluate_price로 오모델 금지(T-9). 골든값은 §3.10 표(transcribed-by post-verify 실호출).
3. **★양면 표기 대상(§4):** 088(796,900 현재값 vs 1,800,000 pending)·094/097/100(엔진골든 vs 화면0원 코드)·069/070(base vs _FOIL). 라이브 현재값과 권위/pending 둘 다 보존.
4. **★GAP 정직 표기:** 071(셋트 미성립·cover_mult BLOCKED·⚪)·design-calendar 고정가(prices 0행·⚪). "가격 있는 것처럼" 넣지 말 것.
5. **★캘린더는 셋트 아님(§0.1)** — has_member 엣지 금지. 단품 완제품 5개(PRD_TYPE.01·PRF_DGP_CAL_*)로 다루거나 별도 캘린더 팩. 위키 .04·"가격 0행"은 STALE(T-6).
6. **면지 = 무가격·색 내부 택1(멤버 옵션)·자재는 면지멤버로 이관됨**(§3.5·§3.9·재설계 최신). D링자재(USAGE.07)는 불가침 보존.
7. **수치**는 §3.10 표·post-verify·set-price-full-diagnosis·live-snapshot에서만 전사. **엑셀 원본 반복 Read 금지**·**손전사 금지**.
8. **범위 밖 거절:** 주문·배송·회원·쿠폰 질의는 KB 범위 밖(사용자 확정). 셋트 노드에도 그 축은 만들지 않는다.
9. **인용 전 §2 STALE 함정 + source-registry §8 통과 필수.**

### 미확정/사용자·실무진 확인 필요 큐 (셋트 계열)

- **[GAP-SET-1] 071 트윈링책자 셋트 구성** — 구성원 미mint·cover_mult ×2 엔진 C트랙(개발팀·`CODEBUG-cover-mult-x2-undercharge.md`) 해소 후 082 동형.
- **[GAP-SET-8] 088-redesign 적재 승인** — 표지 9,000·싸바리(1부 39,000/100부 1,800,000)·S1~S8 GO·codex 13/13·**인간 승인 대기**(COMMIT 미실행). 승인 시 현재값 796,900→1,800,000.
- **[GAP-SET-2] 셋트 UI siz_cd 미전파(094/097/100 화면 0원)** — 코드 C트랙(`DEV-REQUEST-set-sim-sizcd-260702`·백필 원천=내지[HARD]).
- **[GAP-SET-3] S1/S2 내지인쇄 이중합산 + 068~070 코팅 드롭** — 가격엔진 코드 C트랙(전 책자 공통·개발팀).
- **[GAP-SET-4] 내지 페이지 단가(D-2)·[GAP-SET-5] 인쇄면지 인쇄비(D-3)·[GAP-SET-7] 구성원 옵션그룹 UI 렌더(D-1)** — hlg O-1 후속(§34).
- **[GAP-SET-6] 069/070 _FOIL 박분기 공식 정본화** — base vs _FOIL 활성 정본 확정(인간 승인).
- **[GAP-CAL] design-calendar 고정가 미적재** — `t_prd_product_prices` 캘린더 0행·110 editor_yn=N. 원천 부재(실무진·§26).
- **레더 프리미엄 정확값 / cover_mult ×2** — COVERBIND use_dims=[min_qty] 한계·엔진 use_dims 확장 C트랙(저청구 잔존·동작은 됨).
