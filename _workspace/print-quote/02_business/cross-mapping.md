# 삼각 매핑 — huni xlsx ↔ buysangsang ↔ Shopby

**작성:** 2026-05-27 (pq-business-analyst)
**Linked:** D-001(자체사이트), D-002(자체빌더), D-004(옵션C 자체빌더 100%), O-005(정합성)

본 문서는 후니프린팅 4개 데이터소스를 교차 매핑하여 Big-Bang 컷오버 시 정합성·보정 우선순위를 산출한다.

| 소스 | 종류 | 식별자 | 표본 수 |
|------|------|--------|--------|
| **A. huni 상품마스터 xlsx** | MES 내부 마스터 | `MES ITEM_CD` (`NNN-NNNN`) + `ID` (5자리) | 약 240종 |
| **B. buysangsang.com WP** | 자체 운영 라이브 | `product_cat` 숫자 코드 (`1000~2100`) + WC product slug | 65 카테고리 / 225 상품 |
| **C. huniprinting48.shopby.co.kr** | 자체 운영 Shopby Aurora | `categoryNo` / `productNo` | 미확인 (API 응답 4건 / `_baseline` 확인 필요) |
| **D. huni 가격표 xlsx** | MES 내부 가격 | 시트 19개 (상품군별) | 약 1,200 가격행 |

---

## 1. 카테고리 매핑 (huni MAP 12 대분류 ↔ buysangsang 11 prefix ↔ Shopby)

### 1.1 huni MES 카테고리 prefix → buysangsang `product_cat` 코드

huni MAP 시트의 12개 대분류 코드(`001`~`012`)는 3자리 prefix. buysangsang의 4자리 prefix(`1000`~`2100`)와는 다른 체계이지만 **자릿수가 다른 같은 산업 분류 관행**(천 단위 그룹)으로 추정.

| huni 코드 | huni 대분류 | buysangsang 추정 코드 (자릿수+1로 정렬) | buysangsang 하위 (#) | 일치 신뢰도 |
|:--:|------|:----:|:----:|:----:|
| 001 | 01 엽서 | **1000** (1001~1004, 4개) | 4 | 🟢 HIGH (대분류 순서 동일) |
| 002 | 02 스티커 | **1100** (1101~1104, 4개) | 4 | 🟢 HIGH |
| 003 | 03 인쇄홍보물 | **1200** (1201~1203, 3개) | 3 | 🟢 HIGH (명함/리플렛/쿠폰 3중분류) |
| 004 | 04 포스터 | **1300** (1301~1304, 4개) | 4 | 🟢 HIGH (포스터/패브릭/액자/사인 4중분류) |
| 005 | 05 사인 | **1400** (1401~1403, 3개) | 3 | 🟡 MED (배너/시트커팅/POP) |
| 006 | 06 책자 | **1500** (1501·1503·150301, 3개 + 4-depth 1개) | 3 | 🟢 HIGH (책자/하드커버/포토북 — 150301이 포토북 추정) |
| 007 | 07 캘린더 | **1600** (1601~1603, 3개) | 3 | 🟢 HIGH (탁상/벽걸이/디자인) |
| 008 | 08 문구 | **1700** (1701~1704, 4개) | 4 | 🟢 HIGH (플래너/노트/홀더/데스크) |
| 009 | 09 아크릴 | **1800** (1801~1803, 3개) | 3 | 🟢 HIGH |
| 010 | 10 라이프 | **1900** (1901~1906 + 1999, 7개) | 7 | 🟡 MED (라이프가 가장 다양 — 7중분류와 일치) |
| 011 | 11 에코백 | **2000** (2001~2011, **11개 최대**) | 11 | 🟢 HIGH (파우치·필통·에코백 다양 — 최대 분류와 일치) |
| 012 | 12 포장 | **2100** (2101~2105, 5개) | 5 | 🟢 HIGH (포장재/봉투/라벨/부자재/액세서리) |
| — | (없음) | **accessories** (단일) | 1 | 🟠 부속 — A xlsx와 매핑 불명 |

**관찰:**
- buysangsang 카테고리 수(65)와 huni MAP 중분류·소분류 합산(약 60~65)이 근접 → **사실상 동일한 분류 체계의 두 표현형**.
- 매핑 신뢰도 합산: HIGH 9건, MED 2건, 부속 1건. ⭐ 12개 대분류 중 11개가 1:1 매핑 가능.

🟡 **DECISION D-PM-04:** huni 3자리 코드 체계와 buysangsang 4자리 코드 체계 중 **신규 SKU 코드 체계**로 무엇을 채택할 것인가? (권장: huni MES `NNN-NNNN`를 정식 — buysangsang `1000~2100`는 URL slug용 표시 코드로만 활용)

### 1.2 buysangsang의 `accessories` 카테고리

A2_findings에 `accessories (단일)`로 표기. 표본 상품 매칭이 없어 **분류 외 잡종 grouping** 추정. huni의 어디에 해당하는지 미확정.

🟡 **DECISION D-PM-05:** buysangsang `accessories` 카테고리 보존 여부 결정. (권장: 폐기하고 상품을 `12 포장` 또는 해당 라이프 sub로 재배치)

---

## 2. 상품 인벤토리 일치도 (huni 240종 ↔ buysangsang 225종)

### 2.1 수량 비교

| 카테고리 | huni xlsx (MES CD 부여분 + 미부여 추정) | buysangsang sitemap.xml (라이브) | 일치 추정 |
|----------|--:|--:|--:|
| 01 엽서·접지·포토카드 | 18~22 | ~15 | 80% |
| 02 스티커 | 14~16 | ~12 | 85% |
| 03 인쇄홍보물 (명함/리플렛/쿠폰/봉투) | 18 | ~14 | 78% |
| 04 포스터 | 17 | ~10 | 60% (xlsx에 신규 미공개 17종 다수) |
| 05 사인 (배너/시트/POP) | 10 | ~8 | 80% |
| 06 책자 | 9 | 2 (중철/무선 2026-01-28 신규만) | 22% ⚠ |
| 07 캘린더 | 5~7 | ~3 (시즌상품) | 50% |
| 08 문구 | 11 | ~6 | 55% |
| 09 아크릴 | 22 | ~14 | 64% |
| 10 라이프 | 50+ (가장 큼, MES CD 미부여) | 40+ (말랑·머그·우치와 등) | 80% |
| 11 에코백 | 40+ (MES CD 미부여) | 30+ (캔버스/레더/메쉬) | 75% |
| 12 포장 | 18 | ~10 | 55% |
| **합계** | **약 240** | **225** | **~75%** |

### 2.2 라이브에 노출되지 않은 huni xlsx 상품 (마이그레이션 시 결정 필요)

xlsx에 정의되어 있지만 buysangsang sitemap에는 없는 상품군:
- 책자 7종 중 5종 (PUR, 트윈링, 하드커버, 레더하드커버, 하드커버링 — 라이브 미노출)
- 캘린더 디자인캘린더 (시즌 한정 추정)
- 아크릴 신규 9종 (코롯토, 쉐이커, 입체블럭, 카라비너, 지비츠 등 ★ 검토중 표기)
- 포스터 5~7종 (린넨우드봉, 캔버스행잉 등)

🟡 **DECISION D-PM-06:** 라이브 미노출 xlsx 상품(약 60건)을 V1 런칭 카탈로그에 포함할지, 단계 출시(Phase 2)로 미룰지 결정. (권장: 라이브 노출된 225건 + xlsx에서 검증된 15~20건만 V1 → Phase 2에서 잔여)

### 2.3 buysangsang 운영 데이터 클린업 필요

buysangsang sitemap에 발견된 비정상 데이터:
- `결제테스트` 상품 — A2_findings에 명시
- 일부 `~/copy/` URL 추정 (Yoast Duplicate Post 플러그인 활성)
- 미노출/임시저장 상품의 sitemap 포함 여부 미확인

🟡 **DECISION D-PM-07:** buysangsang 라이브 225건에서 운영 잔재 정리(최소 1~3건). **마이그레이션 전 보정 필수**.

---

## 3. 옵션 모델 매핑 (huni xlsx 8축 ↔ TM EPO ↔ Shopby `/products/options`)

### 3.1 옵션 도메인 8축 (product-master.md §7에서 도출)

| # | 축 | huni xlsx 컬럼 | buysangsang TM EPO 필드 | Shopby `/products/options` |
|:-:|----|--------|--------|--------|
| 1 | 사이즈 | `사이즈(필수)` + 비규격 `가로`/`세로` | builder field type=select/text | option name="사이즈" |
| 2 | 종이/소재 | `종이(필수)` + `출력소재` (IMPORT) | select with priceMode | option name="용지" |
| 3 | 인쇄 도수 | `인쇄(옵션)` (단/양면) + 화이트/클리어/별색 | radio + checkbox | option name="인쇄" |
| 4 | 후가공 | `후가공` (코팅/박/형압/접지/오시/타공/귀돌이) | checkbox multi-select with price add | option name="후가공" |
| 5 | 제본 | (책자 시트) `제본/수량` 컬럼 = 중철/무선/PUR/트윈링/하드커버 | radio | option name="제본" |
| 6 | 수량 | `제작수량(필수)` (최소/최대/증가) | number input + tiered pricing | option name="수량" |
| 7 | 가공 옵션 | (아크릴 시트) 후가공 옵션 — 고리·자석·핀 | builder | option name="옵션" |
| 8 | 주문 방법 | `업로드` Y/N + `편집기` Y/N | 모드 토글 (편집기 진입) | 별도 메타 |

### 3.2 옵션 형태 매핑 일치도

- **huni xlsx vs TM EPO** — 컬럼 8축이 **TM EPO Builder mode 필드 8그룹과 완전 일치** (C_findings: `tm_meta_cpf = {mode: builder}`). ⭐ huni가 buysangsang에 옵션을 등록한 방식의 source of truth가 xlsx이며, TM EPO가 그 실행 표면. 자체 빌더 옵션 모델은 xlsx 8축을 그대로 채택.
- **huni xlsx vs Shopby `/products/options`** — Shopby는 옵션을 **별도 엔티티 API**로 가짐. xlsx 8축을 Shopby option 엔티티로 모델링하면 수용 가능하나, **수량 구간 할인 매트릭스(축 6)는 Shopby의 `/additional-discounts/by-product-no`로 위임 또는 자체 가격 엔진으로 처리** — D-004 결정에 따라 후자.
- **gap:** Shopby는 SKU-variation 강제(D-004 deal-breaker). xlsx의 사이즈×용지×후가공×수량 조합 폭발(10⁴+)을 Shopby variation으로 풀면 마스터 SKU 수가 폭증. → **자체 빌더에서 옵션은 동적 계산, Shopby는 결제 시점 상품 1개만 인지** (옵션C 채택 근거).

### 3.3 수량 구간 할인 모델

| 소스 | 표현 | 매트릭스 차원 |
|------|------|------|
| huni 디지털인쇄비 시트 | 수량 1~1,000,000장 × 도수 7종 × 단/양면 2개 → **단가표** | 3D (선형 보간) |
| huni 굿즈파우치(구간할인) 시트 | 수량구간 → 할인율 (B타입: 1~99 0%, 100~499 5%, 500+ 10%) | 1D (계단 함수) |
| huni 아크릴 시트 | 수량구간 → 할인율 (1~49 0%, 50~99 10%, 100~299 20%, 300~499 30%, 500~999 40%, 1000+ 50%) | 1D |
| buysangsang Tiered Price | `_fixed_price_rules` / `_percentage_price_rules` 메타 | 1D |
| Shopby `/additional-discounts` | API 엔티티 | 1D 추정 |

**관찰:** huni는 **상품군에 따라 다른 가격 모델**을 운영 — 디지털인쇄는 단가표(3D), 아크릴/파우치/문구는 할인율 매트릭스(1D). buysangsang Tiered 플러그인은 1D만 표현 가능 → **디지털인쇄는 buysangsang에서도 SKU 변종 또는 동적 견적 필요**. 본 점이 옵션C 결정의 추가 근거.

🟡 **DECISION D-PM-08:** 가격 모델 표현 통일안. (권장: 자체 빌더에 **2종 모델 공존** — `PriceTable3D`(디지털인쇄·코팅·명함·포스터·아크릴 사이즈매트릭스) + `BasePrice + TierDiscount`(굿즈·파우치·문구·아크릴 수량구간).)

---

## 4. 마이그레이션 영향도 (Big-Bang 컷오버 우선순위)

### 4.1 영향도 평가 매트릭스

| 카테고리 | xlsx SKU | buysangsang 라이브 | 옵션 복잡도 | 가격 모델 | 마이그레이션 영향도 |
|----------|--:|--:|--:|--:|:--:|
| 01 엽서 | 22 | ~15 | 중 (사이즈×용지×도수×수량) | 3D 단가표 | 🔴 HIGH (런칭 필수) |
| 02 스티커 | 16 | ~12 | 중 (모양×사이즈×수량×코팅) | 3D + 1D 할인 | 🔴 HIGH |
| 03 인쇄홍보물 | 18 | ~14 | **고** (명함 10종 + 박명함 별도 단가표) | 3D + 박 동판비 | 🔴 HIGH |
| 04 포스터 | 17 | ~10 | 중 (가로×세로 매트릭스) | 2D 매트릭스 | 🟡 MED |
| 05 사인 | 10 | ~8 | 중 (가공·추가옵션) | 매트릭스 + 옵션 가산 | 🟡 MED |
| 06 책자 | 9 | 2 | **고** (페이지수×제본×사이즈) | 단가표 + 제본별 | 🔴 HIGH (라이브 격차 大) |
| 07 캘린더 | 7 | 3 | 중 (사이즈×제본×수량) | 단가표 | 🟡 MED |
| 08 문구 | 11 | 6 | 저 | 1D 할인 | 🟢 LOW |
| 09 아크릴 | 22 | 14 | **고** (사이즈 직접입력 + 옵션 다종) | 3D 사이즈매트릭스 + 1D + 옵션단가 | 🔴 HIGH |
| 10 라이프 | 50+ | 40+ | 저~중 (말랑 등 일부 복잡) | 1D | 🟡 MED (수량 大) |
| 11 에코백 | 40+ | 30+ | 저 | 1D | 🟡 MED (수량 大) |
| 12 포장 | 18 | 10 | 저 | 단가표 | 🟢 LOW |

### 4.2 컷오버 1차 우선 처리 5개군

1. **명함·박명함** (003): xlsx에 8종 마스터 + 박 동판비 별도. TM EPO 옵션 폼 가장 복잡.
2. **아크릴** (009): 사이즈 직접입력형 매트릭스. 수량구간 50%까지 할인. 옵션 단가 다종.
3. **디지털인쇄 일반** (001/003): 56-row 단가표 (1~10,000장 × 7도수 × 단/양면). 가격 엔진 기반 사례.
4. **책자** (006): 라이브 미공개 7종 — V1에서 PUR/하드커버 포함 여부 결정 필요.
5. **포스터** (004): 가로×세로 2D 매트릭스 + 소재별 시트 8종.

---

## 5. Shopby huniprinting48 정합성 (Sa_categories / Sa_products)

**관찰:** `Sa_categories.json` 응답이 error 상태(400, IP 화이트리스트 미등록). 카테고리/상품 raw 데이터는 IP 등록 후 재수집 필요.

**현 상태로 추정 가능한 매핑:**
- huniprinting48 Shopby mall은 D-004에서 폐기 결정(자체 빌더 100%).
- 따라서 Shopby의 categoryNo/productNo는 **참고용 매핑**으로만 사용 — 마이그레이션 source는 buysangsang WP + huni xlsx로 한정.
- Shopby Server API는 BFF로 회원·주문·결제 일부만 활용 (D-004).

🟡 **DECISION D-PM-09:** huniprinting48 Shopby mall의 회원·주문 데이터를 자체 빌더로 마이그레이션할 것인가? (의존: O-001 Shopby Server API 활용 범위 + O-003 컷오버 시점)

---

## 6. 식별된 매핑 갭 (마이그레이션 전 보정 필수)

| 갭 ID | 내용 | 해결안 | 우선 |
|--|--|--|:-:|
| **GAP-001** | huni xlsx MES CD 4건 중복 (PM-DUP-01~04 in product-master.md) | 신규 코드 부여 후 마이그레이션 매핑표 작성 | 🔴 |
| **GAP-002** | 라이프(010)·에코백(011) 카테고리 전체 SKU의 MES CD 미부여 (100+ 상품) | xlsx 보정 또는 신규 시스템 첫 등록 시 부여 | 🔴 |
| **GAP-003** | 책자(006) 라이브 격차 — xlsx 7종 vs 라이브 2종 | V1 카탈로그에 어떤 책자를 포함할지 D-PM-06과 연계 | 🟡 |
| **GAP-004** | buysangsang `결제테스트` 등 운영 잔재 | 마이그레이션 전 cleanup | 🔴 |
| **GAP-005** | huni xlsx 가격표 19시트 ↔ TM EPO `tm_meta_cpf` 정합성 미검증 | C_findings의 표본 1건(프리미엄엽서)은 _fixed_price_rules 빈 배열 → 가격이 어디에 정의되어 있는지 추가 추적 필요 | 🟡 |
| **GAP-006** | huniprinting48 Shopby 카테고리·상품 raw 수집 실패 (IP 화이트리스트) | Shopby IP 등록 후 1회 정찰 | 🟢 |
| **GAP-007** | xlsx에 코드 미부여 신규 검토중(★) 9종 (아크릴 신규) | V1 포함 여부 결정 + 코드 부여 | 🟡 |

---

## 7. 결정 요약

본 문서에서 신규 등록한 결정 항목:

| ID | 내용 | 권장안 |
|----|------|---|
| D-PM-04 | 정식 SKU 코드 체계 (huni 3자리 vs buysangsang 4자리) | huni MES `NNN-NNNN` 유지 |
| D-PM-05 | buysangsang `accessories` 카테고리 보존 | 폐기, 재배치 |
| D-PM-06 | 라이브 미노출 xlsx 상품 60건 V1 포함 여부 | V1=225+15~20, Phase 2=잔여 |
| D-PM-07 | buysangsang 운영 잔재 cleanup | 마이그레이션 전 1~3건 정리 |
| D-PM-08 | 가격 모델 표현 통일안 | PriceTable3D + BasePrice+TierDiscount 공존 |
| D-PM-09 | Shopby 회원·주문 마이그레이션 | O-001/O-003 의존, 별도 결정 |

상기 결정은 pq-pm `decisions.md`에 D-PM-04 ~ D-PM-09로 추가 등록 필요.

---

## 출처
- `_workspace/print-quote/02_business/product-master.md` (xlsx A — 상품마스터)
- `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` (xlsx D — 가격표, 19시트)
- `_workspace/print-quote/01_research/crawl-evidence/2026-05-27_buysangsang/A2_findings.md` (buysangsang sitemap·카테고리·페이지)
- `_workspace/print-quote/01_research/crawl-evidence/2026-05-27_buysangsang/C_findings.md` (buysangsang 플러그인 풀·상품 메타 108개)
- `_workspace/print-quote/01_research/shopby/SHOPBY_FINDINGS.md` (Shopby Shop API + huniprinting48 mall)
- `_workspace/print-quote/00_pm/decisions.md` (D-001 ~ D-004 컨텍스트)
