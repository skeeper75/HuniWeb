# RP 옵션 원자 추출 — NC([옵셋] 명함·카드·쿠폰·포토카드) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting NC 카테고리(9상품 — 전부 **[옵셋](offset)** 인쇄방식) 대표 3상품 라이브 역공학 + 디지털 명함(BC) 동형 대비를 **base-data 관리 렌즈**로 추출.
> ★Phase 2 / 11번째 카테고리 / **선별 모드 핵심 프로브 = "인쇄방식(옵셋 vs 디지털)이 distinct #18 관리축인가"**.
> NC = BC(디지털 명함)와 **동일 상품군(명함/카드/쿠폰/포토카드)이되 인쇄방식만 옵셋** → 디지털 vs 옵셋 변수를 깨끗하게 격리하는 자연 실험.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).

## 출처 표기 규칙
- `[live:API]` = **2026-06-19 라이브 읽기전용 캡처**. playwright(`raw/widget_monitor/local/node_modules`)로 `/ko/product/item/NC/{code}` 로드 → 페이지가 자동 호출하는 `get_digital_product_info` infoCall 응답(`product_option.option` + `product_data` 전체) 인터셉트. retCode=200 실측. **주문/POST/폼제출 0건**(read-only goto + response 수신만). 원본 = `_workspace/huni-rpmeta/categories/NC/captures/nc_cap_{code}.json`.
- `[reuse:BC-fixture]` = `_workspace/huni-widget/04_build/fixtures/product_BCSPDFT.json`(디지털 일반 명함 infoCall 풀 응답) — NC 옵셋의 디지털 카운터파트 동형 대비.
- `[reuse:PR-reverse]` = `_workspace/huni-rpmeta/categories/PR/reverse.md` §0.4(인쇄방식=상품 분기축), §0.3(FLD_DFT 접지축).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json`(상품명·URL, 2026-06-19 확인).
- `[live:SSR-negative]` = `/ko/product/item/NC/{code}` GET 200·249KB이나 신규 Vue client-render(인라인 옵션 JSON 미노출·`offset`/`옵셋` 텍스트만). 그래서 SSR이 아닌 **infoCall API 인터셉트**로 보강.
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

## NC 9상품 전수 (`[live:catalog]`)
| pdtCode | 이름 | 인쇄방식 | 상태 | 대표샘플? |
|---------|------|---------|------|----------|
| **NCDFDFT** | [옵셋] 일반 명함 | 옵셋 | 활성 | ✅ (NC 기본) |
| NCDFQLT | [옵셋] 고급지 명함 | 옵셋 | 활성 | (자재 superset 동형) |
| **NCDFFLD** | [옵셋] 2단/3단 명함 | 옵셋 | 활성 | ✅ (접지·오시) |
| NCDFCPN | [옵셋] 일반 쿠폰 | 옵셋 | 활성 | (명함 동형) |
| NCDFFOI | [Coming soon] 박/형압 명함 | 옵셋 | 미출시 | unobserved(order 불가) |
| **NCCDPHO** | [옵셋] 대량 포토카드 | 옵셋 | 활성 | ✅ (대량 단가구간) |
| NCCDDFT | [옵셋] 일반 카드 | 옵셋 | 활성 | (포토카드 동형) |
| NCCDQLT | [옵셋] 고급지 카드 | 옵셋 | 활성 | (자재 superset) |
| NCCDFOI | [Coming soon] 박/형압 카드 | 옵셋 | 미출시 | unobserved |

---

## 0. NC 카테고리 핵심 발견 — 옵셋은 **별도 가격엔진 + 대량 수량구간 + (자재 종속) 수량**이 디지털과 갈린다

NC 상품은 BC(디지털 명함)와 **동일한 서버 base-data 스키마**(`pdt_base_info`/`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_prn_cnt_info`/`pdt_pcs_info`)를 그대로 쓴다. 스키마 슬롯 이름·구조는 100% 동형. **인쇄방식의 차이는 ① `item_gbn`/`price_gbn` 토큰(상품 분기 신호) ② 수량 스키마의 의미(연속 increment vs 자재종속 이산 tier) ③ 별도 가격엔진(`offset2023_price`)으로만 나타난다.** 새 스키마 축(슬롯)은 추가되지 않는다.

### 0.1 ★`item_gbn`/`price_gbn` = 인쇄방식 인코딩 토큰 (가장 직접적 신호) `[live:API]` vs `[reuse:BC-fixture]`
| 신호 | NC 옵셋 (NCDFDFT/FLD/PHO 전부) | BC 디지털 (BCSPDFT) |
|------|------|------|
| `item_gbn` | **`offset2023_item`** | `digital_item` |
| `price_gbn` | **`offset2023_price`** | `digital_price` |
| `order_yn` | Y | Y |
| `price_table_yn` | N | N |

→ RedPrinting은 인쇄방식을 **`item_gbn`/`price_gbn` 토큰**으로 상품에 박는다. PR §0.4가 발견한 "인쇄방식 = pdtCode 분기축(윤전 `book2025`·토너·인디고)"이 **여기서 토큰 레벨로 재확인**: 옵셋=`offset2023_*`, 디지털=`digital_*`. 같은 명함(명함이라는 카테고리·자재·도수·후가공 축)이 인쇄방식 토큰만 다르게 분기. base_data_tag = **기초코드(인쇄방식 enum) + 가격엔진 선택자**.

### 0.2 ★수량(prn_cnt) 의미가 인쇄방식별로 갈린다 — 디지털=연속 increment, 옵셋=자재종속 이산 tier (NC의 진짜 옵셋 시그니처) `[live:API]` vs `[reuse:BC-fixture]`
이게 옵셋 가격모델의 본질. 같은 `pdt_prn_cnt_info`/`pdt_exp_prn_cnt_info` 슬롯이지만 채워지는 방식이 정반대.

| 슬롯/필드 | NC 옵셋 (NCDFDFT) | BC 디지털 (BCSPDFT) |
|------|------|------|
| `pdt_prn_cnt_info` | 1행: `PRN_CNT:500, DFT_PRN_CNT:500, REAM_CNT:0` (기본부수만·`FIR_CNT`/`INC_CNT`/`INC_STEP`/`MIN_PRN_CNT` 전부 **null**) | 1행: `FIR_CNT:100, INC_CNT:100, INC_STEP:10, MIN_PRN_CNT:1, DFT_PRN_CNT:100` (연속 증가 곡선) |
| `pdt_exp_prn_cnt_info` | **10행 populated** = (자재 × 이산 부수) 매트릭스: RXSNO250 → {100,200,300,400,500}, RXWMO220 → {100,200,300,400,500} | **`null`** (없음) |

→ **디지털 = 첫수량 100·100단위 증가·최소 1의 연속(가변) 수량.** **옵셋 = 자재별로 정해진 이산 부수 tier(100/200/300/400/500) — 자유 입력 불가, 정해진 수량만 선택.** `pdt_exp_prn_cnt_info`가 (MTRL_CD × PRN_CNT) 페어로 채워진 게 옵셋의 시그니처 = **"자재마다 허용 부수 tier가 다르다"** = 옵셋 판(plate)·대수(임포지션) 경제성이 수량을 이산화한 결과. base_data_tag = **옵션(수량) + 제약(자재×부수 허용 매트릭스) + 가격(구간 단가)**. ★대량 포토카드(NCCDPHO)도 동일 10행 tier — "대량"의 의미 = 이 이산 tier가 곧 대량 단가구간.

### 0.3 ★별도 가격엔진 = `offset2023_price` (디지털 `digital_price`와 다른 엔진) `[live:API]`
`price_gbn=offset2023_price`. 디지털 포스터/명함은 `digital_price`, 현수막은 면적매트릭스(`vTmpl`), 옵셋 명함은 **`offset2023_price`** — 세 번째 가격엔진 토큰. 가격 reqBody/result는 라이브 가격조회를 안 쳐서(주문플로 회피·옵션 미세팅) `unobserved`. 다만 0.2의 이산 tier + `price_gbn` 토큰으로 **"옵셋은 자재×부수 룩업 단가"** 가 강하게 시사됨(디지털의 볼륨디스카운트 연속곡선과 대비). 가격엔진 선택자 자체가 인쇄방식에 종속.

### 0.4 ★접지 명함(NCDFFLD)의 접지 = 사이즈 SKU에 흡수 + 오시(OSI_DFT) 공정 동반 `[live:API]`
NCDFFLD(2단/3단 명함)는 PR 리플렛처럼 **별도 "접지 방식(FLD_DFT)" 옵션 축을 두지 않는다.** 대신:
- **접지 변형이 사이즈 SKU(`pdt_size_info`)에 16종으로 베이크됨**: `2단 세로형 90X50`, `2단 가로형 86X52`, `3단 세로형 91X55`, `3단 가로형 85X49` … (2단/3단 × 세로/가로 × 규격치수). 펼친 크기(WRK/CUT)가 접지수에 따라 달라짐(2단 세로 = 높이 2배 100mm, 3단 세로 = 148mm).
- **오시(OSI_DFT "오시") 공정이 `pdt_pcs_info`에 등장** = 접는 선을 누르는 가공. 일반 명함(NCDFDFT)에는 없는 그룹.

→ **PR(리플렛/포스터) = 접지를 `FLD_DFT` 독립 옵션축으로 분리** vs **NC(명함) = 접지를 사이즈 SKU + 오시 공정으로 분해.** 같은 "접는다"는 개념을 RedPrinting이 상품군별로 다른 관리축에 매핑(명함=치수 프리셋이 강하니 SKU 흡수·리플렛=면 분할이 본질이니 옵션축). base_data_tag = 사이즈(접지치수 SKU) + 공정(오시).

---

## 1. NCDFDFT — [옵셋] 일반 명함 (★NC 기본·옵셋 baseline) `[live:API]`
source: `_workspace/huni-rpmeta/categories/NC/captures/nc_cap_NCDFDFT.json` (retCode 200·infoCall 1건·2026-06-19)

```
product: NCDFDFT [옵셋] 일반 명함 (NC)
  item_gbn: offset2023_item   price_gbn: offset2023_price   order_yn: Y   PDT_UNIT: 장
  base: WDT_HGH_GBN_YN=Y(가로세로직접가능)  NO_STD_ABL_YN=Y(비규격가능)  MIN_CUT 50×30  MAX_CUT 500×500
axes:
  - axis: 사이즈 (size)            # pdt_size_info (5종)
    choices: [사이즈직접입력, 90X50(기본), 86X52, 91X55, 85X55]
    cascade: 직접입력 선택 시 가로세로 입력(50×30~500×500). 규격은 WRK/CUT 프리셋.
    price_flag: 영향(재단치수→면적/판). 옵셋은 자재×부수 tier가 주 단가축.
    base_data_tag: 사이즈(규격 프리셋 + 자유범위)
    note: 디지털 BC와 동일 슬롯·동일 규격치수. 명함 규격은 인쇄방식 무관 공유.
  - axis: 용지(자재) (material)     # pdt_mtrl_info (3종)
    choices: [스노우250, 스노우300, 백색모조220]   # MTRL_CD RXSNO250/RXSNO300/RXWMO220
    cascade: 자재 → 허용 부수 tier 결정(0.2 exp_prn_cnt MTRL_CD×PRN_CNT). 일부 자재 후가공 비활성(disable_pcs).
    price_flag: 영향(자재 단가 + 부수 tier). base_data_tag: 자재(용지·평량)
    note: ★디지털 BC는 자재 5종(아트지/스노우/얼스팩), 옵셋 NCDFDFT는 3종 — 인쇄방식이 자재 풀을 가른다(옵셋 전용 모조지 RXWMO220).
  - axis: 도수 (color/sides)        # pdt_dosu_info
    choices: [단면(SID_S·PRN_CLR_CNT 4), 양면(SID_D·PRN_CLR_CNT 8)]
    price_flag: 영향(인쇄 면수). base_data_tag: 기초코드(도수 enum)
    note: 디지털 BC와 동일(SID_S/SID_D·4/8). 도수축은 인쇄방식 무관 공유. 별색은 미노출(unobserved).
  - axis: 수량/부수 (quantity)      # pdt_prn_cnt_info + ★pdt_exp_prn_cnt_info
    choices: [100, 200, 300, 400, 500] (자재별 이산 tier·기본 500)
    cascade: 자재(MTRL_CD)별로 허용 부수 tier가 정의됨(exp_prn_cnt 10행=2자재×5부수). 자유입력 불가.
    price_flag: 영향(★옵셋 핵심 단가축 — 부수 tier = 대량 단가구간).
    base_data_tag: 옵션(수량) + 제약(자재×부수 허용 매트릭스)
    note: ★★디지털과 갈리는 핵심. 디지털=연속 increment(첫100·증100·최소1), 옵셋=이산 tier.
  - axis: 후가공 (post-process)     # pdt_pcs_info (10행·그룹 5)
    choices(그룹): [재단(CUT_DFT), 코팅(COT_DFT), 타공(HOL_DFT), 귀돌이(ROU_DFT), 추가부자재(SUB_MTR)]
    cascade: pdt_disable_pcs_info로 자재별 비활성. 코팅 변형 다수(COT_DFT detail).
    price_flag: 영향(가산). base_data_tag: 공정(후가공) + 자재(SUB_MTR 추가부자재)
    note: 디지털 BC(재단/코팅/타공/폴리백…19행)와 그룹 유사. 귀돌이(ROU_DFT)=둥근모서리 공정.
```

## 2. NCDFFLD — [옵셋] 2단/3단 명함 (★접지·오시) `[live:API]`
source: `captures/nc_cap_NCDFFLD.json` (retCode 200·2026-06-19)

```
product: NCDFFLD [옵셋] 2단/3단 명함 (NC)
  item_gbn: offset2023_item   price_gbn: offset2023_price
  base: WDT_HGH_GBN_YN=N(직접입력 불가)  NO_STD_ABL_YN=N(비규격 불가)  MAX_CUT 297×420
  ★일반 명함과 달리 자유사이즈 차단 — 접지 SKU만 허용
axes:
  - axis: 사이즈/접지 (size+fold)   # pdt_size_info (16종 = 접지변형 베이크)
    choices: [2단 세로형 {90X50,86X52,91X55}, 2단 가로형 {90X50,86X52,91X55},
              3단 세로형 {90X50,91X55,86X52,85X49,89X51}, 3단 가로형 {90X50,91X55,89X51,85X49,86X52}]
    cascade: 접지수(2/3단)·방향(세로/가로)·규격이 한 SKU로 합성. WRK/CUT가 접지수에 비례(2단세로=높이2배).
    price_flag: 영향(펼친 면적·접지수). base_data_tag: 사이즈(접지치수 SKU)
    note: ★PR 리플렛은 FLD_DFT 독립 옵션축 / NC 명함은 접지를 사이즈 SKU로 흡수. 같은 개념 다른 관리축.
  - axis: 후가공·오시 (creasing)    # pdt_pcs_info
    choices(그룹): [재단(CUT_DFT), 오시(OSI_DFT)]
    cascade: 오시 = 접는 선 누름 가공(접지 명함 필수 동반).
    price_flag: 영향(가산). base_data_tag: 공정(오시=접지 동반 공정)
    note: ★일반 명함(NCDFDFT)엔 오시 그룹 없음 — 접지 SKU 선택 시 오시 공정이 따라옴(사이즈↔공정 캐스케이드).
  - axis: 용지/도수/수량            # NCDFDFT 동형(자재 pool·SID_S/D·이산 tier 부수 200기본)
    note: 동형. 부수 기본 200(일반명함 500과 다름) — 접지 명함 최소부수가 낮음.
```

## 3. NCCDPHO — [옵셋] 대량 포토카드 (★대량 단가구간) `[live:API]`
source: `captures/nc_cap_NCCDPHO.json` (retCode 200·2026-06-19)

```
product: NCCDPHO [옵셋] 대량 포토카드 (NC)
  item_gbn: offset2023_item   price_gbn: offset2023_price
  base: WDT_HGH_GBN_YN=N  NO_STD_ABL_YN=N  MIN_CUT 54×85  MAX_CUT 500×730
axes:
  - axis: 사이즈 (size)            # pdt_size_info (2종)
    choices: [55X85, 54X86]   # 포토카드 고정 규격 2종
    price_flag: 영향. base_data_tag: 사이즈(규격 프리셋)
    note: 자유입력 불가·포토카드 표준 치수만.
  - axis: 용지(자재)               # pdt_mtrl_info (1종)
    choices: [스노우300 RXSNO300]
    base_data_tag: 자재(용지)
    note: ★자재 1종으로 고정 — "대량" 상품은 자재 단순화.
  - axis: 도수                      # 단면/양면(SID_S/SID_D 4/8) — NCDFDFT 동형
    base_data_tag: 기초코드(도수)
  - axis: 수량/부수 (대량 단가구간) # pdt_exp_prn_cnt_info 10행
    choices: [100,200,300,400,500] (자재별 이산 tier·기본 500)
    cascade: exp_prn_cnt(RXSNO250×5 + RXWMO220×5) = 이산 tier. ★"대량 포토카드"의 "대량" = 이 부수 tier 자체.
    price_flag: 영향(★대량 단가구간 = 옵셋 부수 tier). base_data_tag: 옵션(수량) + 제약(부수 tier)
    note: ★일반 명함(NCDFDFT)과 exp_prn_cnt tier 동일(100~500). "대량 포토카드"가 별도 단가구간 스키마를 쓰는 게 아니라, 옵셋 공통 이산 tier 모델을 그대로 씀. 대량성 = 가격엔진(offset2023_price) 내부 단가표의 문제이지 스키마 축이 아님.
```

---

## ★디지털(BC) 대비 옵셋(NC) 차이표 (directive 핵심 산출)

| 관리 차원 | BC 디지털 명함 (`[reuse:BC-fixture]`) | NC 옵셋 명함 (`[live:API]`) | 스키마 축이 다른가? |
|----------|------|------|------|
| **인쇄방식 토큰** | `digital_item`/`digital_price` | `offset2023_item`/`offset2023_price` | ❌ 같은 슬롯, 값만 다름 |
| **수량 의미** | 연속 increment (FIR 100·INC 100·STEP 10·MIN 1) | **이산 tier (자재×부수 100~500, 자유입력 불가)** | ❌ 같은 슬롯(`prn_cnt`/`exp_prn_cnt`), 채움 방식 정반대 |
| `pdt_exp_prn_cnt_info` | `null` (미사용) | **populated** (MTRL_CD×PRN_CNT 매트릭스) | ❌ 같은 슬롯, 옵셋만 활성 |
| **가격엔진** | `digital_price` (볼륨디스카운트 곡선·추정) | `offset2023_price` (자재×부수 룩업·추정) | ❌ 같은 `price_gbn` 슬롯의 다른 값 |
| **자재 pool** | 5종(아트지/스노우/얼스팩) | 3종(스노우/모조·옵셋전용 RXWMO) | ❌ 같은 `mtrl_info`, 풀만 다름 |
| **사이즈/도수/후가공 축** | 동형 (규격치수·SID_S/D·재단/코팅/타공) | 동형 | ❌ 완전 공유 |
| **접지** | (BC 무접지) | NCDFFLD = 사이즈 SKU + 오시 공정 | ❌ 기존 사이즈/공정 축이 흡수 |

→ **옵셋 vs 디지털의 모든 차이가 "같은 스키마 슬롯의 다른 값/다른 채움"으로 흡수된다. 새 관리 슬롯(축)이 추가된 곳은 0이다.**

---

## ★인쇄방식 #18 1차 예측 (directive 핵심 질문 — 승격 판정은 metamodel/validator 몫)

**질문:** 인쇄방식(옵셋 vs 디지털)이 distinct #18 관리축인가, 아니면 기존 축에 무왜곡 흡수되는가?

**1차 예측: 흡수(ABSORBED) — distinct #18 후보로 부적격 (강한 부결 신호).** 근거:

1. **전용 슬롯 라이브 부재 (vessel-gap 없음).** 옵셋이 디지털과 갈리는 지점이 전부 *기존 슬롯의 다른 값*으로 나타난다:
   - `item_gbn`/`price_gbn` 토큰 = **기초코드(enum) 축 + 가격엔진 선택자** — 후니 KB의 `price_gbn`/가격공식 분기(#11 가격모델)가 무왜곡 흡수.
   - 수량 이산 tier = **제약(자재×부수) + 옵션(수량) + 가격(구간단가)** — 후니 CPQ 제약/옵션/가격 축이 흡수(왜곡 없음).
   - 자재 pool 차이 = **자재(#1) 축** 흡수. 접지 = **사이즈(#) + 공정(#2)** 흡수.
2. **메타모델 17축 어느 것도 "담지 못함" 결함이 없다.** ST 형상#17이 distinct로 승격된 기준(① 전용 슬롯 라이브 실재 `shape_info` ② 후니 KB "형상 어느 축에도 없음" 결함) — NC 인쇄방식은 **둘 다 불충족**: 전용 슬롯 없음(`item_gbn`은 enum 토큰), KB 결함 없음(가격모델 #11 + 기초코드가 흡수).
3. **PR §0.4와 일관·dbmap 교훈과 정합.** PR이 이미 "인쇄방식 = pdtCode/`item_gbn` 분기축(상품을 가르는 신호이지 옵션축이 아님)"으로 관측. NC가 토큰 레벨(`offset2023_*`)로 재확인. ★메모리 교훈 `dbmap-print-method-not-absolute-axis`("인쇄방식 절대축 아님·시트가 1차 단위")와도 정합 — rpmeta 메타모델에서도 인쇄방식은 **상품 분기 신호(기초코드/카테고리) + 가격엔진 선택자**이지 독립 관리축이 아님.

**단, 적대검증(metamodel/validator) 대상으로 남기는 nuance 2건:**
- **(N-1) `price_gbn`(가격엔진 선택자)이 후니 KB에 distinct 슬롯으로 있는가?** 옵셋=`offset2023_price`, 디지털=`digital_price`, 현수막=면적매트릭스 — RedPrinting은 **가격엔진을 상품에 박는 선택자**를 가진다. 후니 t_prc_*는 상품↔공식 바인딩(product_price_formulas)으로 이를 담는다고 가정되나, "인쇄방식이 가격엔진을 *결정*한다"는 종속관계가 후니에 명시 슬롯으로 있는지는 metamodel이 확인. → 흡수(#11 가격모델 분기)일 가능성 높으나 단정 보류.
- **(N-2) `pdt_exp_prn_cnt_info`(자재×부수 이산 tier 매트릭스)를 후니가 담는가?** 후니 수량 모델이 "연속 increment"만 가정하면 옵셋 이산 tier(자재종속 허용부수)를 못 담을 수 있음. 이건 **인쇄방식 축이 아니라 "수량 모델 = 연속 vs 이산 tier"의 분기** → 옵션/제약 축의 표현력 문제(data-gap 가능성)이지 새 인쇄방식 축은 아님. metamodel이 후니 옵션/제약 슬롯의 이산 tier 수용력을 확인 대상으로.

**결론(1차):** 인쇄방식 #18 = **부결(흡수)** 가 1차 예측. ST 형상#17 같은 "전용 슬롯+KB 결함" 둘 다 충족 없음. 단 N-1(가격엔진 선택자)·N-2(이산 수량 tier 수용력)는 metamodel이 흡수 경로를 명시 확인할 nuance.

---

## Ambiguous fragments (아키텍트가 버킷 확정)

1. **`item_gbn`/`price_gbn` 토큰(`offset2023_item`/`offset2023_price`)** — 버킷 모호: 기초코드(인쇄방식 enum)인가, 카테고리(상품 분기)인가, 가격엔진 선택자(별도 메타 개념)인가? PR §0.4는 카테고리/기초코드로 잠정 태깅. NC에서 **가격엔진을 결정**하는 종속성이 드러나(price_gbn 동반 변경) → "인쇄방식 = (기초코드 enum) + (가격엔진 선택자) bundle"일 수 있음. 아키텍트 확정 필요.
2. **`pdt_exp_prn_cnt_info` (MTRL_CD × PRN_CNT 이산 tier 매트릭스)** — 버킷 모호: 옵션(수량)인가, 제약(자재가 허용부수를 제약)인가, 가격(부수 tier=단가구간)인가? 세 의미가 한 슬롯에 합성됨(자재→허용부수→단가). 후니가 "옵션값 + 참조제약 + 가격행"으로 3분해해야 할 가능성. ★N-2와 연결.
3. **귀돌이(ROU_DFT)·오시(OSI_DFT)** — 공정으로 태깅했으나, 오시는 접지 사이즈 SKU와 캐스케이드(사이즈 선택→오시 동반)되어 "사이즈에 종속된 공정"이라는 결합관계가 모호. 순수 공정 add-on인가, 사이즈-SKU에 묶인 필수공정(template/제약)인가?
4. **자재 pool이 인쇄방식에 종속(옵셋 3종 vs 디지털 5종, 옵셋전용 RXWMO220)** — 자재(#1) 축으로 흡수되나, "어느 자재가 어느 인쇄방식에서 가능한가"는 제약(인쇄방식↔자재 호환)일 수도. 후니 자재 마스터가 인쇄방식 차원을 갖는지 아키텍트 확인.
5. **박/형압 명함·카드(NCDFFOI/NCCDFOI) = [Coming soon]** — `order_yn` 등 미관측(미출시). 박/형압이 NC에서 어떤 옵션축(공정?별도SKU?)으로 들어올지 unobserved — 라이브 출시 후 재캡처 대상(BC의 BCFOXXX 박/형압 명함과 대조 가능).
