# 큐레이션 팩 — 문구·굿즈/악세사리·파우치·봉투 (stationery-goods)

> **작성:** okb-source-curator · 2026-07-03 (첫 작성 — 이전 팩 없음)
> **대상 = 4 하위군**(상품마스터 260702 + live-snapshot snap_20260702_1119 전수 확정):
>   ① **문구 셋트류**(★셋트=has_member) — 172~181 + 구성원 293~308 (9 셋트 부모·16 구성원)
>   ② **굿즈/악세사리(단품·비종이·비아크릴)** — 183~241·263~280 등 (~70상품·고정가/미적재)
>   ③ **파우치·백(봉제 상품)** — 230~262 (~33상품)
>   ④ **봉투류** — 001·002·005·050·283 (+283 기성·281/282 del_yn=Y·043 이미 구축)
>   **★아크릴(146~171)은 본 팩 범위 밖 = 별도 `pack-acrylic` 권장**(판정 §0.1 — 면적매트릭스·전용 recipe).
> **목적:** 지식 구축가(okb-knowledge-builder)가 이 크고 이질적인 상품군을 KB에 넣을 때, **축(axis)마다 어느 파일의
>   어느 절이 정답 소스이고, 무엇이 함정(STALE)이며, 원천이 없어 못 닫는 GAP이 무엇인지**를 못박는다.
>   ★이 상품군의 최대 특징 = **적재 미완(empty-shell·sparse grid·NEITHER-gap)이 대량** → **양면·GAP 정직 표기**가 핵심 임무(§4).
> **선행 입력(정독 완료):** 같은 폴더 `source-registry.md`(등급·§8 STALE 금지목록·260702 접근규칙)·`pack-set-series.md`(셋트·양면·서브배치 형식 계승)·`pack-silsa.md`·`pack-sticker.md`(12축 구조) ·
>   `02_ontology/ontology-schema.md`(개체17·관계19·has_member R13·priced_by R8·derived_from R17·가격아키타입 3종) ·
>   `_workspace/print-kb/wiki/recipes/{stationery,goods-pouch,product-accessory,acrylic}.md`(REVERIFY 대조) · live-snapshot/latest 실측 · CLAUDE.md §23/§34(최신).

---

## 0. 이 팩을 읽는 법 (쉬운 말)

- **정답 소스** = "이 축의 사실은 여기서 가져와라"의 1순위 파일·절·캐시.
- **보조 소스** = 정답을 교차 확인하거나 값을 채우는 2순위.
- **STALE 함정** = "그럴듯하지만 인용하면 틀리는" 오래된 원천. **왜** 틀린지와 **대체 소스**를 함께 적었다.
- **GAP(원천 부재)** = 어느 문서에도 정답이 없어서 지금은 못 닫는 것. 실무진 답변·인간 승인 대기.
- 표기: `tier`(A 절대권위 / B 정본문서 / C 하네스산출·최신우선 / D 역공학·경쟁사 보조), `freshness`(FRESH / PARTIAL-STALE(어느 축이 낡음) / STALE=인용금지).
- **수치 손전사 금지:** 아래 표의 모든 숫자·상태값은 결정론 스크립트/awk 전사(transcribed-by)다. 라이브 = `live-snapshot/latest` awk 전사 · 260702 = `26_change-tracking-260702` diff 전사.
- **KB 답변 범위(사용자 확정·relitigate 금지):** 상품·구성요소·옵션·가격 차원·제약까지만. **주문·배송·회원·쿠폰은 범위 밖** — 이 팩도 그 축은 다루지 않는다(거절형 응답 경계).

### 0.1 ★Universe 판정 (과업 요구 — 크고 이질적이라 경계 확정 필수)

> 과업 추정 40~60상품보다 **실제 라이브 universe가 훨씬 큼**(146~283 범위에 use=Y·del=N 상품 ~120개). 원자재(아크릴)·구조(문구=책자동형)·가격아키타입이 이질적이라 경계를 못박는다.

- **★아크릴(146~171·26상품) = 본 팩 범위 밖 = 별도 `pack-acrylic` 권장.**
  - 근거: (a) **면적매트릭스 아키타입**(`PRF_CLR_ACRYL`·`PRF_ACRYL_*`·가로×세로·미러 투명×2) — 문구/굿즈 고정가형과 다른 계열(silsa와 동형). {transcribed-by `awk t_prd_product_price_formulas.csv`} (b) **전용 recipe 실재** = `recipes/acrylic.md`(PRD_000146~169·UV 평판인쇄·완칼 형상)·`_curation/pack-acrylic.md`(1차 권위). (c) *_TBD 5건(165/168/169/170 등 `PRF_ACRYL_*_TBD`) = 실무진 단가 BLOCKED(source-registry §9 GAP-5과 동류).
  - **과업이 subgroup②에 146/147/158을 명시했으나**, 이 3개는 아크릴 계열(면적격자·부속은 addon 템플릿)이므로 **아크릴 팩에서 다루는 것이 옳다**(캘린더를 셋트 팩에서 뺀 것과 동형 판정). 본 팩은 판정·경계만 명시하고 아크릴 노드는 만들지 않는다. builder가 아크릴을 넣으려면 `pack-acrylic`을 먼저 요청.
- **이미 구축됨(중복 금지·참조만):** **043 인쇄배경지**(=`product-043-bg-opp`·digital-print에서 구축·`PRF_DGP_C`)·**097/098 떡메모지**(=set-series에서 구축). 이 3개는 본 팩 대상 아님(참조만). {transcribed-by `ls 03_kb/product/`}
- **del_yn=Y → 노드 미생성(정상 은퇴):** 281 카드봉투(화이트)·282 카드봉투(블랙). 단 이 둘은 **엽서 추가상품 라벨**로 살아있고 260702에서 "50장→10장"으로 변경(§3.12·§4). → 상품 노드는 미생성, **엽서 addon 축**에서만 다룸.
- **use_yn=N(미출시) → 정직 표기(노드는 생성하되 badge/props에 미출시):** 202 키캡키링·203 LED투명키캡키링·199 투명부채·204 미니CD앨범·207 극세사타월·208 슬로건·222 말랑증사홀더 등. {transcribed-by `awk t_prd_products.csv` use_yn=N}
- **기성상품(PRD_TYPE.03·제조없음) → identity=기성·인쇄 BOM N/A:** 180 메모패드(내지커스텀)준비중·218 타이벡북커버·283 트레싱지봉투·011 자석고정용고무판. (product-accessory.md "인쇄 BOM N/A" 계승)

**★이 상품군의 5대 특성(다른 상품군과 다른 점):**
1. **적재 미완이 기본값(★최대 임무).** 굿즈/파우치 대부분이 **empty-shell**(자재·공정 0행)이거나 **NEITHER-gap**(공식·고정가 둘 다 없음=견적 원천 부재). 문구 셋트는 **sparse grid**(완제품가 공식은 있으나 단가행 1셀만). → 위키 "🔴 교정대기" 결함표를 그대로 옮기면 맞지만 **시점·해소분 재판정 필수**(§2).
2. **가격아키타입이 하위군마다 다름:** 문구 셋트=**evaluate_set_price + 고정가형(완제품가 by siz×qty·sparse)** / 굿즈·파우치=**고정가룩업(`t_prd_product_prices` 단일 unit_price)** 또는 **미적재(gap)** / 봉투=**기성(가격없음)** 또는 **`PRF_ENV_MAKING`/`PRF_DGP_C`**.
3. **비종이 다수 → 판형 불필요(도메인 [HARD]).** 굿즈(금속·원단·아크릴)·파우치(봉제 원단)·거울·백은 종이류 아님 → `plate_size` 없음(`platesize-paper-only-diagnosis`). 문구 셋트의 내지/표지/면지(종이류)만 판형 대상.
4. **★굿즈 자재 오염이 기지(정정본 교훈).** 거치대·키링고리·볼펜·면끈·핀버튼 등 굿즈 부속이 **용지성 상품 자재·단가행에 오적재**된 시스템 오염(`goods-material-contamination-260630` — 6상품 정리 COMMIT됨). 굿즈 노드는 부속=addon/부자재이지 substrate 자재 아님(§3.5).
5. **문구 셋트는 책자 동형(내지+표지+면지) but 만년다이어리는 내지 member 없음.** 172/175=표지만·173/174=표지+면지(내지 없음)·176~181=표지+내지. 완제품가가 내지 포함 all-in(부모 고정가·set-series 094/097/100 동형).

---

## 1. 상품 인벤토리 (하위군별·확정)

> **slug 정본 = product-NNN-kebab[HARD]** — builder 강제 채택. 구성원(반제품 .02)은 `product-NNN-<부모>-<역할>` 형.
> 가격상태 = live 실측(transcribed-by `awk t_prd_product_price_formulas.csv`·`t_prd_product_prices.csv`). ★PRICE≠0 실호출 확인 전 원자합산/고정가 여부는 🟡 candidate.

### 1.1 하위군 ① 문구 셋트류 (★셋트=has_member·9 부모+16 구성원)

| prd_cd | 상품명 | 확정 slug | prd_typ | 구성원(sub_prd·역할) | 가격아키타입 | 라이브 가격상태 |
|--------|--------|-----------|---------|----------------------|--------------|-----------------|
| **172** | 만년다이어리(소프트커버) | `product-172-perpetual-diary-soft` | .01 | 293 표지만(.02·면지/내지 없음) | evaluate_set_price·고정가형(완제품가) | `PRF_STN_DIARY_SOFT`·COMP_STN_DIARY_SOFT **단가행 1셀만**(sparse·🟡) |
| **173** | 만년다이어리(하드커버) | `product-173-perpetual-diary-hard` | .01 | 294 표지(.02)·295 면지(.03) | 고정가형 | `PRF_STN_DIARY_HARD`·단가행 1셀(130x190=12,000·sparse) |
| **174** | 만년다이어리(레더하드커버) | `product-174-perpetual-diary-leather-hard` | .01 | 296 표지 레더(.02)·297 면지(.03) | 고정가형 | `PRF_STN_DIARY_LHARD`·1셀 |
| **175** | 만년다이어리(레더소프트커버) | `product-175-perpetual-diary-leather-soft` | .01 | 298 표지만(.02) | 고정가형 | `PRF_STN_DIARY_LSOFT`·1셀 |
| **176** | 먼슬리플래너 | `product-176-monthly-planner` | .01 | 299 표지(.02)·300 내지(.01·28p고정) | 고정가형 | `PRF_STN_MONTHLY`·1셀 |
| **177** | 스프링노트 | `product-177-spring-note` | **.02(★conflict)** | 301 표지(.02)·302 내지(.01·무지) | 고정가형 | `PRF_STN_SPRINGNOTE`·1셀 |
| **178** | 스프링수첩 | `product-178-spring-notebook` | .01 | 303 표지(.02)·304 내지(.01·무지) | 고정가형 | `PRF_STN_SPRINGNOTEBK`·1셀 |
| **179** | 메모패드 | `product-179-memo-pad` | .01 | 305 표지(.02)·306 내지(.01·무지) | 고정가형 | `PRF_STN_MEMOPAD`·**2셀** |
| **181** | 중철노트 | `product-181-jungcheol-note` | .01 | 307 표지(.02)·308 내지(.01·무지) | 고정가형 | `PRF_STN_JUNGCHEOL`·1셀 |
| 180 | 메모패드(내지커스텀) 준비중 | `product-180-memo-pad-custom` | .03(기성) | — | (가격없음) | use_yn=N·미출시 |

> **구성원 slug:** 293=`product-293-perpetual-diary-soft-cover`·294=`...-hard-cover`·295=`...-hard-membrane`·296=`...-leather-hard-cover`·297=`...-leather-hard-membrane`·298=`...-leather-soft-cover`·299=`product-299-monthly-planner-cover`·300=`...-monthly-planner-inner`·301/302=`...-spring-note-{cover,inner}`·303/304=`...-spring-notebook-{cover,inner}`·305/306=`...-memo-pad-{cover,inner}`·307/308=`...-jungcheol-note-{cover,inner}`. {전부 transcribed-by `awk t_prd_product_sets.csv`·`t_prd_products.csv`}
> **★177 분류 conflict(양면):** 177 스프링노트는 `t_prd_product_sets` 부모(셋트 완제품)인데 `prd_typ_cd=PRD_TYPE.02`(반제품)로 라벨됨. SOT상 셋트 완제품(부모 등록)이 정답 → **`current_value: prd_typ .02(라이브)` / `authority_value: 셋트 완제품(sets 부모)` badge=defect**(§3.1).

### 1.2 하위군 ② 굿즈/악세사리 (비종이·비아크릴·~70상품·대표+families)

> 규모가 커서 **family 단위 그룹핑 + 과업 명시 상품 개별**. 전 상품 slug=`product-NNN-<kebab>`. 가격 = 고정가룩업(단일 unit_price·260610 verbatim) 또는 미적재(gap).

| family(대표 prd_cd) | 상품 수(범위) | 가격상태 | 소재/특성 | 대표 slug |
|--------------------|--------------|----------|-----------|-----------|
| 거울류(183~187) | 5 | 185 카드거울=**고정 2,500**·나머지 gap | 틴/콤팩트/카드/사각(금속·유리) | `product-185-card-mirror` |
| 코스터류(188~192) | 5 | 대부분 gap | 레더/코르크/우드/린넨/규조토 | `product-188-leather-coaster` |
| 패브릭·의류(205~209·193~198) | ~10 | 205 양말=**3,000**·나머지 gap | 양말/티셔츠/후드/타월/쿠션/매트 | `product-205-socks` |
| 패드류(210~212) | 3 | 210 **5,000**·211 **18,000**·212 **2,500**(전부 고정) | 마우스패드/장패드/극세사클리너 | `product-210-slim-mousepad` |
| 키링·톡·스트랩(201·214·219·220·221) | ~8 | 대부분 gap·219 밴드톡=**4,500** | 레더스트랩/자석북마크/밴드톡/폰스트랩/말랑 | `product-201-leather-strap-keyring` |
| 말랑류(221~225) | 5 | 223 **14,000**·224 **12,000**·225 **14,500**·221/222 gap | 실리콘 말랑 굿즈 | `product-221-mallang-keyring` |
| 스탬프·기타(217·200·213·215·216·204) | ~6 | 대부분 gap | 만년스탬프(+015 리필잉크)/핀버튼/틴케이스/클립보드 | `product-217-perpetual-stamp` |
| 미러/이미지피켓(226~229) | 4 | gap | 쉐이커코롯토/우치와/피켓 | `product-228-heart-picket` |

**과업 명시 개별(subgroup② 확정):**
- 221 말랑키링 `product-221-mallang-keyring`(gap)·201 레더스트랩키링 `product-201-leather-strap-keyring`(gap)·202 키캡키링 `product-202-keycap-keyring`(**use_yn=N**·gap)·203 LED투명키캡키링 `product-203-led-keycap-keyring`(**use_yn=N**·gap)·214 자석북마크 `product-214-magnet-bookmark`(gap)·199 투명부채 `product-199-clear-fan`(**use_yn=N**·gap)·217 만년스탬프 `product-217-perpetual-stamp`(gap)·015 리필잉크 `product-015-refill-ink`(addon성)·011 자석고정용고무판 `product-011-magnet-rubber-plate`(**기성.03**·min1~max100).

### 1.3 하위군 ③ 파우치·백 (봉제·~33상품)

| family(대표) | 상품 수(범위) | 가격상태 | 특성 |
|-------------|--------------|----------|------|
| 레더 파우치/미니파우치/필통(230~237·251~260) | ~18 | **부분 고정가**(251=6,500·253=7,200·256~260=7,500~10,500·236=18,000·237=20,000·235=16,500) / **252/254/255 등 gap** | 봉제·레더·플랫/슬림/삼각/볼륨/원형 |
| 타이벡(244~248·273~277) | ~10 | 248 클러치=**12,500**·275 보냉미니백=**25,000**·나머지 gap | 봉제·타이벡 원단 |
| 캔버스/린넨/메쉬(239~242·249·250·261~272·278·279) | ~15 | 263 레더토트=**31,000**·265 **16,500**·266 **24,000**·272 **58,000**·나머지 gap | 봉제·에코백/토트백/필통 |

> **과업 명시 파우치(subgroup③):** 242 광목스트링라벨파우치 `product-242-cotton-string-label-pouch`(**empty-shell**·자재/공정 0행·gap)·243 린넨스트링 `product-243-linen-string-pouch`(gap)·244~247 타이벡 `product-244-tyvek-flat-pouch`…·249/250 메쉬 `product-249-mesh-slim-pouch`/`product-250-mesh-volume-pouch`(gap)·251~255 레더미니 `product-251-leather-flat-mini-pouch`…(251/253 고정가·252/254/255 gap). {전부 transcribed-by awk}
> **★봉제 공정 MISSING(GP-ST-005):** 파우치 대부분 `t_prd_product_processes` 0행(봉제 공정 미적재). 242=자재·공정 둘 다 0행(순수 empty-shell). 251=자재 1행(USAGE.07)·공정 0행. {transcribed-by `awk t_prd_product_materials/processes.csv`}

### 1.4 하위군 ④ 봉투류

| prd_cd | 상품명 | 확정 slug | prd_typ | 가격상태 |
|--------|--------|-----------|---------|----------|
| **001** | OPP접착봉투 | `product-001-opp-adhesive-envelope` | .01 | **NEITHER-gap**(공식·고정가 둘 다 없음·⚪) |
| **002** | OPP비접착봉투 | `product-002-opp-non-adhesive-envelope` | .01 | NEITHER-gap(⚪) |
| **005** | 캘린더봉투 | `product-005-calendar-envelope` | .01 | NEITHER-gap(⚪) |
| **050** | 봉투제작 | `product-050-envelope-making` | .01 | **`PRF_ENV_MAKING`**(소재/수량별 공식·siz_cd 후니 등록 대기·note) |
| **283** | 트레싱지봉투 | `product-283-tracing-paper-envelope` | .03(기성) | 가격없음(기성·제조없음) |
| 043 | 인쇄배경지(OPP봉투타입) | (이미 구축) | .01 | `PRF_DGP_C`·**digital-print에서 구축·참조만** |
| 281 | 카드봉투(화이트) | (미생성·del_yn=Y) | .03 | 엽서 addon·**260702 50→10장**(§3.12) |
| 282 | 카드봉투(블랙) | (미생성·del_yn=Y) | .03 | 엽서 addon·260702 50→10장 |

---

## 2. STALE 함정 목록 (이 상품군 국한 — 인용 시 lint FAIL)

> 전역 금지목록은 `source-registry.md` §8. 아래는 **문구/굿즈/파우치/봉투 작업에서 특히 밟기 쉬운** 함정만.

| # | 함정 원천 | 왜 틀리는가 | 대체 소스 |
|---|-----------|-------------|-----------|
| T-1 | `recipes/goods-pouch.md` **ST-001~008 결함표를 "현재 결함"으로 인용**(자재 폭증·봉제→부착 오적재·CPQ 미적재 등) | round-13 시점 — 일부 교정 COMMIT됨·다수 잔존. 시점이 낡아 그대로 옮기면 T-오염 | 각 행을 §3 각 축 + live-snapshot으로 "해소/잔존" 재판정 |
| T-2 | `recipes/stationery.md` **ST-01~16 결함표·"미싱제본 MISSING"** 단정 | 문구 셋트 구성원 mint(2026-07-01)·공식 바인딩(2026-06-29) 이후 상태 변화 | live `t_prd_product_sets.csv`·`t_prd_product_price_formulas.csv` 재측정 |
| T-3 | 굿즈/파우치 **고정가(t_prd_product_prices) = 260610 verbatim 인용** | 값은 260610 기준 — 260702 diff(65행) 미대조. 단 goods 고정가는 diff에 없음=260702 동일 확증 필요 | `26_change-tracking-260702` diff 대조 후 인용 |
| T-4 | 굿즈 부속(키링고리·볼펜·거치대·면끈)을 **substrate 자재로** 모델 | 굿즈 부속=addon/부자재이지 자재 아님(`goods-material-contamination-260630` 오염 진단) | 정정본 교훈 인용·부속은 `has_addon`(R14)로 |
| T-5 | `price-engine-ddl.md`·`prcx01-pricing-model`(8차원·clr_cd·constraint_json) | 구설계·삭제 컬럼(§8-2/3/5). 문구 완제품가·굿즈 고정가는 live `t_prc_*`/`t_prd_product_prices` | live 실측 + pricing.py |
| T-6 | 문구 셋트를 **단일 `evaluate_price`로 계산** | 셋트(t_prd_product_sets 부모)는 `evaluate_set_price`(pricing.py:718)·완제품가 부모 all-in | pricing.py:718 + `set-price-full-diagnosis` 동형 |
| T-7 | 문구/굿즈/파우치에 **판형(plate_size) 이식** | 비종이류(원단·금속·아크릴)는 판형 불필요. 문구는 종이 구성원(내지/표지/면지)만 | `HARNESS-DOMAIN-RULES-260701.md`(종이류만 판형) |
| T-8 | **파우치 "봉제 공정 있음"·"자재 채워짐" 가정** | 대부분 empty-shell(자재·공정 0행·봉제 MISSING·GP-ST-005) | live `t_prd_product_processes/materials.csv` 실측(0행 확인) |
| T-9 | 문구 셋트 **완제품가 grid "채워짐" 가정** | COMP_STN_* 단가행 = **1~2셀만**(sparse) → 대부분 사이즈/수량 견적0 | `awk t_prc_component_prices.csv $2==COMP_STN_*`(1~2행) |
| T-10 | 281/282 카드봉투를 **판매 상품 노드로** | del_yn=Y(미생성). 실체 = 엽서 추가상품 라벨·260702 50→10장 | `awk t_prd_products.csv`(del_yn=Y) + master-diff AL6/AL7 |
| T-11 | `recipes/acrylic.md`·146~171을 **본 팩에서 다룸** | 아크릴=면적매트릭스·전용 pack-acrylic(§0.1) | `pack-acrylic`(별도 요청) |

---

## 3. 축별 큐레이션 (정답 → 보조 → STALE 함정 → GAP) — 12축

> 이 상품군은 특히 **§3.1 정체(기성/미출시/셋트 판정)·§3.10 가격공식(하위군별 아키타입 갈림)·§3.5 자재(오염·empty-shell)·§3.6 공정(봉제 MISSING)** 축이 중점.

### 3.1 정체(identity)

- **정답 소스:** live `t_prd_products.csv`(prd_typ_cd·use_yn·del_yn) + `t_prd_product_sets.csv`(문구 셋트 부모 판정) + `_foundation/product-type-classification-sot.md`(완.01/반.02/기성.03/추가.05). {tier A/B · FRESH}
- **보조:** `recipes/{stationery,goods-pouch,product-accessory}.md` 정체 블록(개념) · `17_correctness/{stationery,goods-pouch,product-accessory}/product-identity.md`(C13·의미).
- **핵심 사실:**
  - **문구 셋트(172~181)** = `t_prd_product_sets` 부모 = 셋트 완제품(evaluate_set_price). ★**177만 prd_typ=.02 conflict**(§1.1·양면). 180=기성.03·use_yn=N.
  - **굿즈/파우치** = 대부분 완제품 단품(.01). 기성(.03)=011·218·283. **use_yn=N 미출시 다수**(199·202·203·204·207·208·222 등) → 정직 표기(노드 생성·미출시 라벨).
  - **봉투** = 001/002/005/050=.01·283=.03 기성·281/282=del_yn=Y(미생성).
- **위키 REVERIFY 대조:** stationery `[정체]`·goods-pouch `[GP-ID-001]`(103상품·19군)·product-accessory `[PA-ID-001]`(15 부자재=포장재 012·인쇄 BOM N/A) → 개념 INHERIT·**prd_typ/use_yn은 live 재측정**(REVERIFY).
- **STALE 함정:** T-1·T-2·T-10·T-11.
- **GAP:** **[GAP-STN-1]** 177 분류 conflict 정정(양면). 상품 수 집계 기준 미통일(source-registry §9 GAP-6).

### 3.2 차원 — 사이즈(size)

- **정답 소스:** live `t_prd_product_sizes.csv`·`t_siz_sizes.csv`(구성원별·상품별) + `set-checklist` 동형(문구 내지 page). {tier A · FRESH}
- **핵심 사실:** 문구 셋트 사이즈=구성원 단위(표지≠내지·set-series 동형). 굿즈/파우치는 형상·규격 사이즈(대부분 고정규격·일부 자유치수 `nonspec_yn`). 봉투는 봉투종류(티켓/소/자켓/대) siz_cd 미등록(050 note "후니 등록 후 component_prices siz 채움").
- **위키 REVERIFY 대조:** stationery(고정규격)·goods-pouch `[GP-DIM-001/002]`(옵션형 사이즈·본체색×규격 직교)·`[GP-ST-002]`(본체색×규격 8행 폭증=과분할) → REVERIFY(live 재측정).
- **STALE 함정:** T-5(pricing_dims 구설계). 본체색×규격 직교 과분할을 정답으로.
- **GAP:** **[GAP-ENV-1]** 봉투(050) 봉투종류 siz_cd 미등록 → component_prices siz 미충전. **[GAP-GD-2]** 굿즈 옵션형 사이즈 size↔option 경계(goods-pouch Q-GP-1).

### 3.3 차원 — 도수(색상 수)

- **정답 소스:** live `t_prd_product_print_options.csv`·`t_prt_print_options`(코드값). {tier A · FRESH}
- **핵심 사실:** 문구 셋트 도수=구성원(표지·내지) 단위 인쇄옵션(칼라/흑백·단/양면). 굿즈/파우치는 인쇄방식(UV·전사·자수 등)이 도수를 대행하는 경우가 많음 → 인쇄옵션 축이 상품별 상이·대부분 얕음. 봉투(기성)는 인쇄 없음.
- **위키 REVERIFY 대조:** goods-pouch `[GP-ID-002]`(인쇄방식 7종=폴더 C12 생산라우팅) → 인쇄방식 root INHERIT·도수 live 재측정.
- **STALE 함정:** T-5(도수를 clr_cd로).
- **GAP:** **[GAP-GD-3]** 굿즈 도수·인쇄방식 링크 MISSING(goods-pouch `[GP-ST-007]`).

### 3.4 차원 — 수량규칙(묶음·min/max/incr)

- **정답 소스:** live `t_prd_products.csv`(min_qty/max_qty/qty_incr) + `t_prd_product_bundle_qtys.csv` + `t_prd_product_sets.csv`(문구 내지 member min/max=page). {tier A · FRESH}
- **핵심 사실:** 굿즈/파우치 수량=상품 min/max/incr(대부분 1~10000/+1·핀버튼 200=4/+4·185 카드거울 3/+3). 문구 셋트 내지 member min/max=**페이지 고정/가변**(176=28p고정·177/178/179/181=무지 미설정). set-series [HARD] 계승(db_comment "구성원 개수"이나 실 페이지수·load-bearing).
- **위키 REVERIFY 대조:** stationery(page_rule/장수/묶음수 3축)·goods-pouch `[GP-PRC-002]`(구간할인 카테고리단위) → REVERIFY.
- **STALE 함정:** 내지 min/max를 "구성원 개수"로 문자 해석.
- **GAP:** 문구 무지 내지(302/304/306/308) min/max 미설정(추후 커스텀인쇄 확장 예정·note).

### 3.5 자재(materials) — ★오염·empty-shell

- **정답 소스:** live `t_prd_product_materials.csv`(usage_cd) + `t_mat_materials.csv` + **정정본 교훈** `goods-material-contamination-260630`(메모리). {tier A/C · FRESH}
- **핵심 사실(★이 상품군 특유):**
  - **굿즈/파우치 자재 = 대부분 empty-shell**(0행) 또는 소량(USAGE.07 본체 소재 1행). 242=0행·251=1행(MAT_000008 USAGE.07)·217 스탬프=7행(USAGE.07). {transcribed-by awk}
  - **★굿즈 부속 오염(정정본):** 거치대·키링고리·볼펜·면끈·핀버튼·보드스탠딩 등이 **용지성 상품** 자재+단가행에 오적재된 시스템 오염(034/037/040/047/048/072/077/082) — **6상품 정리 COMMIT됨**(undo 보유). 굿즈 노드 자체는 부속=`has_addon`(R14)이지 substrate 자재 아님. `COMP_NAMECARD_PEARL` 단가행 오염까지 번진 이력(product_materials만 봐선 못 잡음).
  - 자재유형 = 소재별 정확 MAT_TYPE(원단.05·금속.04·파우치.09·악세.10 — goods-pouch `[GP-BOM-002]`). 본체색=재질행 합성(과분할 금지·`[GP-BOM-001]`).
- **위키 REVERIFY 대조:** goods-pouch `[GP-BOM-001/002]` INHERIT(개념)·`[GP-ST-003]`(자재유형 .09 무차별 오염·비-소재 값 자재화)=REVERIFY(live 재측정·잔존분만).
- **STALE 함정:** T-4(부속=자재). ★[HARD 사용자] 실무진 IMPORT 등록 자재는 "배선 안 됐다"고 삭제 금지(`formula-components-wiring-subtrack`).
- **GAP:** **[GAP-GD-4]** 굿즈 자재 유형 오염 잔존분·비-소재 값 자재화(goods-pouch `[GP-ST-003]`). **[GAP-PCH-1]** 파우치 empty-shell 자재 충전.

### 3.6 공정(processes) — ★봉제·후가공 MISSING

- **정답 소스:** live `t_prd_product_processes.csv`(mand_proc_yn) + `t_proc_processes.csv` + goods-pouch `[GP-BOM-003]`(봉제/에폭시/맥세이프). {tier A/C · FRESH}
- **핵심 사실:** 굿즈/파우치 정체 공정 = **봉제(파우치·백)·에폭시(돔)·맥세이프**. ★**대부분 0행(MISSING·GP-ST-005)** — 242/251/205/217 전부 공정 0행. 캔버스 6상품 "봉제→부착 공정 오적재"(`[GP-ST-004]`) 이력. 문구 셋트 공정=제본(미싱제본·스프링·중철)·구성원 단위.
- **위키 REVERIFY 대조:** goods-pouch `[GP-BOM-003]` INHERIT·`[GP-ST-004/005]`(봉제 오적재·MISSING)=REVERIFY(live 재측정). stationery "미싱제본 MISSING"=REVERIFY.
- **STALE 함정:** T-5(dep_proc_cd oracle 소멸)·T-8(봉제 있음 가정).
- **GAP:** **[GAP-PCH-2]** 봉제/에폭시/맥세이프 공정 MISSING 0행(전 파우치·굿즈). **[GAP-STN-2]** 문구 미싱제본 신규 공정(stationery booklet 동형 차이점).

### 3.7 인쇄옵션(print_options)

- **정답 소스:** live `t_prd_product_print_options.csv` + `t_prt_print_options`. {tier A · FRESH}
- **핵심 사실:** 인쇄방식 root(UV·전사·자수·디지털)가 인쇄옵션을 규정. 굿즈=상품별 단순·기성 봉투=인쇄 없음. 문구=구성원 인쇄(내지 디지털·표지 인쇄).
- **위키 REVERIFY 대조:** goods-pouch `[GP-ID-002]`(인쇄방식 7종) INHERIT.
- **STALE 함정:** T-5.
- **GAP:** [GAP-GD-3]과 동류(도수·인쇄방식 링크).

### 3.8 판형(plate size) — ★종이류만

- **정답 소스:** live `t_prd_product_plate_sizes.csv` + `HARNESS-DOMAIN-RULES-260701.md`(종이류만 판형). {tier A/B · FRESH}
- **핵심 사실(★도메인 [HARD]):** 굿즈(금속·원단·아크릴)·파우치(봉제)·백 = **비종이 → 판형 불필요**. 문구 셋트의 **종이 구성원(내지/표지/면지)만** 판형 대상(fn_best_plate·fn_calc_pansu). 봉투(OPP·트레싱지)=비종이/특수 → 판형 불필요.
- **위키 REVERIFY 대조:** 없음(비종이 다수).
- **STALE 함정:** T-7(비종이류에 판형 이식).
- **GAP:** 없음(비종이=판형 없음이 정답).

### 3.9 옵션그룹/제약(CPQ·constraints)

- **정답 소스:** live `t_prd_product_option_groups/options/option_items.csv`·`t_prd_product_constraints.csv` + `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 shape·§31). {tier A/C · FRESH}
- **핵심 사실:**
  - **CPQ 옵션 레이어 전면 미적재(BATCH-6·goods-pouch `[GP-ST-006]`)** — 굿즈 옵션축(폰기종·등급·방향·구수·본체색·가공·addon)이 4엔티티 미매핑. **제약 0행**(146~283 constraints 미실측=0). {transcribed-by `awk t_prd_product_constraints.csv`=대상 0}
  - 옵션참조(ref_dim_cd)는 같은 부모 prd_cd 실재 필수(`fn_chk_opt_item_ref`). 제약은 폼빌더 정형 shape로만(§31).
  - product-accessory 봉투세트=sets+CPQ(이중등록 OTC TEMPLATE·`[PA-CPQ]`).
- **위키 REVERIFY 대조:** goods-pouch `[GP-CPQ-001/002]`·product-accessory `[PA-CPQ-001~003]` → 개념 REVERIFY(live `option_items` 재측정·대부분 미적재 GAP).
- **STALE 함정:** T-5(constraint_json 삭제 컬럼).
- **GAP:** **[GAP-GD-5]** CPQ 옵션 레이어 일괄 적재(BATCH-6·전 굿즈)·굿즈 가공 택일그룹(Q-GP-3).

### 3.10 가격공식(price formula) — ★하위군별 아키타입 갈림

- **정답 소스:** `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price·evaluate_set_price:718=단일 권위) + live `t_prd_product_price_formulas.csv`·`t_prd_product_prices.csv`·`t_prc_component_prices.csv`. {tier A · FRESH}
- **핵심 사실(★가격아키타입 3분기):**
  - **문구 셋트(172~181)** = **evaluate_set_price + 고정가형(완제품가)**. 부모 바인딩 `PRF_STN_*`(완제품가) → `COMP_STN_*`(use_dims=`["siz_cd","min_qty"]`·PRICE_TYPE.01). ★**단가행 sparse(1~2셀만·T-9)** → 대부분 사이즈/수량 견적0. 179만 2셀. {transcribed-by `awk t_prc_component_prices.csv`}
  - **굿즈/파우치** = **고정가룩업**(`t_prd_product_prices` 단일 unit_price·"GP-1 base 단일고정가 260610 verbatim") 또는 **NEITHER-gap**(공식·고정가 둘 다 없음=견적 원천 부재). 고정가 실재 상품(예 185=2,500·210=5,000·211=18,000·251=6,500·263=31,000·272=58,000)만 견적 가능. {transcribed-by `awk t_prd_product_prices.csv`}
  - **봉투** = 050 `PRF_ENV_MAKING`(소재/수량 공식·siz 미충전)·043 `PRF_DGP_C`(이미 구축)·001/002/005=NEITHER-gap·283=기성 가격없음.
- **★가격 경계(방법론·D-18):** 온톨로지는 **priced_by(공식)·has_component(구성요소)·use_dims 차원 선언까지만**. 값 계산=엔진 권위(KB 밖). 문구 셋트 이중합산 방지=evaluate_set_price 소관.
- **위키 REVERIFY 대조:** stationery(C29 inline 고정가형)·goods-pouch `[GP-PRC-001]`(고정가형)·product-accessory `[PA-PRC-001]`(variant 고정가·라이브 0행) → 아키타입 INHERIT·수치 live 재측정.
- **STALE 함정:** T-3·T-5·T-6·T-9.
- **GAP:** **[GAP-STN-3]** 문구 완제품가 sparse grid 충전(1셀→전 사이즈/수량). **[GAP-GD-1]** 굿즈/파우치 NEITHER-gap 대량(공식·고정가 원천 부재). **[GAP-ENV-1]** 봉투 siz 미충전.

### 3.11 가격구성요소(price components) + 단가행 차원(component prices)

- **정답 소스:** live `t_prc_price_components.csv`·`t_prc_formula_components.csv`·`t_prc_component_prices.csv`. {tier A · FRESH}
- **핵심 사실:** 문구 셋트=단일 `COMP_STN_*`(완제품가·[siz_cd,min_qty]·단가행 1~2행 sparse). 굿즈/파우치 고정가=`t_prd_product_prices`(구성요소 아닌 단일 unit_price). NEITHER-gap 상품=구성요소 배선 없음.
- **★단가행 접기(방법론·D-22):** 단가행은 노드로 펼치지 않고 가격구성요소 노드의 속성/집계로 접음. sparse grid는 속성에 "단가행 N셀(견적 가능 범위 좁음)"로 기록.
- **위키 REVERIFY 대조:** 없음(live 실측).
- **STALE 함정:** T-5·T-4(부속이 단가행 오염).
- **GAP:** [GAP-STN-3](sparse)·[GAP-GD-1](미적재).

### 3.12 셋트/추가상품(has_member / addons)

- **정답 소스:** live `t_prd_product_sets.csv`(문구 셋트 부모↔구성원) + `t_prd_product_addons.csv`·`t_prd_templates.csv`(카드봉투 addon). {tier A · FRESH}
- **핵심 사실:**
  - **문구 셋트 has_member(R13):** 172~181 부모 ← 구성원 293~308(역할 SEMI_ROLE.01 내지/.02 표지/.03 면지). set-series 동형. search-before-mint[HARD](구성원 mint 완료·2026-07-01).
  - **카드봉투(281/282) = 엽서 추가상품(addon):** del_yn=Y 상품 노드 미생성이나 **엽서(디지털인쇄 016 등)에 addon 라벨로 실재**. ★**260702: "165x115mm 50장 → 10장" 전면 변경**(AL6/AL7/AL14…·14셀). → 엽서 addon 축에서 **현재값(10장·260702)** 반영. {transcribed-by `master-diff-260610-260702.csv`}
  - 굿즈 addon = 볼체인·리필잉크(015)·아크릴스탠드(goods-pouch `[GP-CPQ-002]`·BUNDLE·별 상품 재사용·`has_addon` R14). always-add 가드(use_dims에 opt_cd 미포함→silent 가산).
- **위키 REVERIFY 대조:** goods-pouch `[GP-CPQ-002]`·`[GP-ST-007]`(addon 링크 MISSING)·product-accessory `[PA-ID]`(봉투세트 sets+CPQ) → REVERIFY.
- **STALE 함정:** T-10(281/282 판매 상품으로).
- **GAP:** **[GAP-STN-4]** 문구 셋트 구성원 가격/옵션 UI 렌더(set-series D-1 동류). **[GAP-GD-6]** 굿즈 addon(볼체인·리필잉크) 링크 MISSING.

---

## 4. ★핵심 임무 — 적재 미완 양면·GAP 정직 표기표

> 이 상품군의 최대 임무 = **"적재됐는가"를 정직 표기**. 위키 🔴 결함표를 그대로 옮기지 말고 live-snapshot 실측으로 재판정. {전부 transcribed-by `awk live-snapshot/latest`}

| 하위군 | 위키/과거 서술 | **현재 상태(live 실측)** | 양면/판정·builder 지침 |
|--------|---------------|--------------------------|------------------------|
| 문구 셋트 172~181 | (미싱제본 MISSING·미적재) | 구성원 mint 완료(293~308)·공식 바인딩 완료(`PRF_STN_*`)·**단, 완제품가 단가행 1~2셀만(sparse)** | **동작화(공식/구성원) but 가격 sparse GAP.** priced_by=`PRF_STN_*` 정본·`props: 단가행 N셀(견적 범위 좁음)`·🟡 candidate(전 사이즈 PRICE≠0 아님) |
| 굿즈 고정가(185·210·211·251·263 등) | (고정가형·라이브 0행) | `t_prd_product_prices` 단일 unit_price 실재(260610 verbatim) | **가격 있음·고정가룩업.** 값 live 전사·260702 diff 미해당=권위 일치 |
| 굿즈/파우치 NEITHER-gap(199·201·214·217·242·001·002·005 등) | (미적재) | 공식·고정가 **둘 다 없음**·자재/공정 empty-shell | **⚪ GAP 노드 or 가격 없는 상품 노드.** "가격 있는 것처럼" 넣지 말 것·`gap_what: 가격 원천 부재` |
| 파우치 봉제 | (봉제 공정 있음 가정) | 공정 0행(MISSING·GP-ST-005)·자재 0~1행 | **⚪ empty-shell.** 봉제 공정=GAP·자재 충전 GAP·has_process 엣지 없음 정직 표기 |
| 굿즈 부속 오염 | (자재로 적재) | 6상품 용지성 오염 정리 COMMIT됨(undo 보유) | **정정본 교훈(T-4).** 부속=`has_addon`(R14)·substrate 자재 아님 |
| 카드봉투 281/282 | (판매 상품 or 50장) | del_yn=Y(미생성)·엽서 addon·**260702 10장** | **상품 노드 미생성·엽서 addon 현재값=10장(260702)** |
| 177 스프링노트 | (셋트 완제품) | prd_typ=**.02 반제품**(라이브 라벨) | **양면(defect):** current .02 / authority 셋트완제품(sets 부모) |

> **★양면 노드 지침(스키마 §1.3-b·badge=defect/gap):**
> - **문구 셋트 sparse:** `priced_by=PRF_STN_* (verified)` + `props: 단가행 1~2셀(sparse·전 사이즈 견적 불가)` → gap 연결(`gap_what: 완제품가 grid 미충전`). 공식 존재 ≠ 가격 완성.
> - **굿즈/파우치 미적재:** gap 노드(⚪) — `gap_what: 가격 원천 부재(공식·고정가 없음)` · `gap_owner: staff/dbmap`. 삭제·날조 금지.
> - **177:** `current_value: prd_typ .02` / `authority_value: 셋트 완제품(t_prd_product_sets 부모·SOT)` · badge=defect.
> - **굿즈 고정가:** 값은 260610 verbatim이나 **260702 diff에 없으면 260702와 동일 확증**(§8-6 대조) → verified.

> **원장 경로:** 문구 구성원 mint·공식 바인딩=2026-06-29~07-01(`t_prd_product_sets`/`t_prd_product_price_formulas` reg_dt). 굿즈 오염 정리=2026-06-30([[goods-material-contamination-260630]]). 카드봉투 50→10장=260702 diff(`26_change-tracking-260702`). 굿즈/파우치 가격 미적재·봉제 공정 MISSING=**live 실측 GAP**(dbmap/실무진 대기).

---

## 5. 서브배치 권고 (필수 — 크고 이질적)

> 이 상품군은 ~120상품·아키타입 3종·적재 성숙도 상이 → **4 서브배치로 분할 빌드 권고**(set-series 동형). 각 배치는 공유 스캐폴드(공식·공정·자재)를 Stage A에 먼저 넣고 상품 노드를 팬아웃.

| 서브배치 | 대상 | 상품 수(추정) | 가격아키타입 | Stage A 공유 스캐폴드 | 주의점 |
|----------|------|--------------|--------------|----------------------|--------|
| **SB-1 문구 셋트** | 172~181 부모 9 + 구성원 293~308 (16) | ~25 | evaluate_set_price·고정가형(완제품가) | `PRF_STN_*` 9공식·`COMP_STN_*`·SEMI_ROLE 역할·제본공정(미싱/스프링/중철) | sparse grid(T-9)·177 conflict·set-series has_member 규약 재사용 |
| **SB-2 굿즈/악세사리** | 183~229·263~280 등(비아크릴) | ~70 | 고정가룩업 / gap | 굿즈 인쇄방식 7종(폴더 C12)·MAT_TYPE(.04/.05/.09/.10)·굿즈 후가공(봉제/에폭시/맥세이프) | 대량 NEITHER-gap·부속 오염(T-4)·use_yn=N 다수 |
| **SB-3 파우치·백** | 230~262 | ~33 | 고정가룩업(부분)·gap | 봉제 공정·원단 자재·형상(플랫/슬림/삼각/볼륨/원형) | empty-shell 대량(T-8)·봉제 MISSING·부분 고정가만 |
| **SB-4 봉투류** | 001·002·005·050·283 | 5 | `PRF_ENV_MAKING`/gap/기성 | `PRF_ENV_MAKING`·봉투종류 siz·카드봉투 addon(엽서 연결) | 043/097/098 참조만·281/282 미생성·siz 미충전 |
| (별도) **pack-acrylic** | 146~171 | 26 | 면적매트릭스 | `PRF_CLR_ACRYL`·`PRF_ACRYL_*`·UV·완칼 | 본 팩 범위 밖(§0.1)·전용 recipe·*_TBD |

> **빌드 순서 권고:** SB-1(문구·구조 명확·set-series 자산 재사용) → SB-4(봉투·소량) → SB-2(굿즈·대량 gap) → SB-3(파우치·empty-shell). SB-2/SB-3는 **gap/empty-shell이 다수라 "정직 표기"가 주 산출**(가격 완성 아님).

---

## 6. 지식 구축가 인계 메모 (착수 시)

1. **하위군마다 가격아키타입이 다름(§3.10·§4):** 문구=evaluate_set_price 고정가형(sparse) / 굿즈·파우치=고정가룩업 or gap / 봉투=`PRF_ENV_MAKING`/기성. 단일 evaluate_price로 문구 오모델 금지(T-6).
2. **★적재 미완 정직 표기가 최대 임무(§4):** 문구 sparse grid(공식 있으나 1셀)·굿즈/파우치 NEITHER-gap·파우치 empty-shell(봉제 MISSING) — 전부 gap/양면 정직 표기. "가격 있는 것처럼" 넣지 말 것.
3. **비종이=판형 없음(§3.8·T-7):** 굿즈/파우치/백에 plate_size 이식 금지. 문구 종이 구성원만 판형.
4. **굿즈 부속=addon(§3.5·T-4):** 키링고리·볼펜·거치대·면끈=`has_addon`(R14)이지 substrate 자재 아님(정정본 교훈). 실무진 IMPORT 자재는 삭제 금지.
5. **★아크릴(146~171)은 본 팩 밖(§0.1·T-11):** 별도 `pack-acrylic` 요청 후 빌드. 과업 명시 146/147/158도 아크릴 팩 소관.
6. **이미 구축 참조만:** 043 인쇄배경지(digital-print)·097/098 떡메모지(set-series). 중복 노드 생성 금지.
7. **use_yn=N 미출시·del_yn=Y 은퇴(§0.1):** use_yn=N은 노드 생성+미출시 라벨·del_yn=Y(281/282)는 노드 미생성(엽서 addon만).
8. **slug 정본=product-NNN-kebab[HARD]** — §1 확정 slug 강제. 구성원=`product-NNN-<부모>-<역할>`.
9. **수치**는 live-snapshot awk·260702 diff에서만 전사(§0). **엑셀 원본 반복 Read 금지·손전사 금지.**
10. **범위 밖 거절:** 주문·배송·회원·쿠폰은 KB 범위 밖(사용자 확정).
11. **인용 전 §2 STALE 함정 + source-registry §8 통과 필수.**

### 미확정/사용자·실무진 확인 필요 큐 (GAP 원장)

- **[GAP-STN-1]** 177 스프링노트 분류 conflict(prd_typ .02 vs 셋트 완제품) 정정 — SOT 재분류(양면 유지).
- **[GAP-STN-3]** 문구 셋트 완제품가 sparse grid(1~2셀→전 사이즈/수량) 충전 — 원천=상품마스터 문구 시트·§26/dbmap.
- **[GAP-GD-1]** 굿즈/파우치 NEITHER-gap 대량(공식·고정가 원천 부재) — 실무진 가격표·dbmap 적재.
- **[GAP-GD-4/5]** 굿즈 자재유형 오염 잔존·CPQ 옵션 레이어 일괄 적재(BATCH-6) — §7/§31 위임.
- **[GAP-PCH-1/2]** 파우치 empty-shell 자재 충전·봉제/에폭시/맥세이프 공정 MISSING(0행) — 실무진·dbmap.
- **[GAP-ENV-1]** 봉투(050) 봉투종류 siz_cd 미등록 → component_prices siz 미충전(050 note).
- **[GAP-GD-6]** 굿즈 addon(볼체인·리필잉크 015·아크릴스탠드) 링크 MISSING — has_addon 배선.
- **카드봉투 260702 50→10장** — 엽서 addon 현재값 반영(상품 노드 아님).
