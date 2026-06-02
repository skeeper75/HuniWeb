# expansion-strategy.md — 위젯 확장 전략 (단일 상품군 → 240 상품 / 12 카테고리)

> 파이프라인 ③ 전략 산출물. PRBKYPR(책자) 단일 구현·QA-pass 상태에서 출발하여, ~240 상품 12 카테고리 전체로
> **상품군 단위 점진 롤아웃**하기 위한 단계 분류·델타 분석·QA 게이트·Figma 통합·리스크 청사진.
> [HARD] 본 문서는 **전략/분석만**. 코드·타 스펙 무수정. 구현 순서는 stage 우선순위로 표기(시간 추정 금지).
> [HARD] 단순성 강제 — 확장은 대부분 **어댑터 + 데이터 + (최소) 신규 componentType**. 위젯 코어 재작성 아님. 코어 작업이 진짜 필요한 군만 정직하게 flag.
> 근거 표기: [PM]=product-master.md / [PRC]=pricing-rules.md / [CT]=component-tree.md / [DC]=data-contract.md / [DA]=data-adapter.md / [DBMAP]=huni-db-mapping.md / [SRC]=04_build/src.

---

## 0. 전제·불변식 (먼저 고정)

확장 전 과정에서 깨지면 안 되는 5대 불변식. 모든 stage 설계는 이 위에서만 움직인다.

| # | 불변식 | 근거 |
|---|--------|------|
| INV-1 | **서버 권위 가격** — 위젯은 4 가격모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount)을 모른다. 8축 입력만 보내고 불투명 `finalPrice`/`lines[]`만 받는다. 새 가격모델 추가 = BFF 일, 위젯 0. | [DC §3][DBMAP §2][PRC §16] |
| INV-2 | **정규화 계약 중립** — 계약 타입에 Red/후니/카테고리 고유 필드명 등장 금지. 새 상품군은 어댑터에서 정규화로 흡수. | [DC §8] |
| INV-3 | **위젯 코어 불변** — Red fixture로 통과한 위젯이 후니 어댑터 출력으로도 동일 동작. 확장은 어댑터+데이터+componentType 추가이지 코어 재작성 아님. | [DA §0][DBMAP §5] |
| INV-4 | **Shadow DOM 격리 + Portal** — 호스트 스타일 누수 0. EditorOverlay 포털은 shadow root 최상단. stage 무관 유지. | [CT §1][SRC mount.ts] |
| INV-5 | **componentType은 14종 고정 dispatch** — 새 componentType 추가 시 계약(`ComponentType` union) + 14 매핑표 + dispatcher switch를 **동시** 갱신(DESIGN과 동기). 임의 추상화(팩토리/레지스트리) 금지. | [CT §3][DC §8] |

> 확장의 본질: **"어떤 상품군이 어떤 componentType·캐스케이드·입력수단·가격모델 조합을 요구하는가"를 군별로 묶어, 어댑터 매핑 테이블과 데이터만 늘려간다.** 위젯 가시 변경은 신규 componentType 3종(§3)에 한정.

---

## 1. 상품군 분류 (Stage Taxonomy)

### 1.1 분류 기준 (4축)

사용자 결정에 따라 **카테고리 순서·매출순이 아니라** 다음 4축의 유사성으로 군집한다:

- **PM = 가격모델** (PriceTable3D / SizeMatrix2D / FixedUnit / TieredDiscount) [PRC §16]
- **OPT = 옵션구조** (사이즈종류, 용지/도수 유무, 후가공, 제본, 옵션 add-on)
- **IN = 입력수단** (Edicus editor / PDF upload / no-design) [DC ProductSide.uploadType]
- **CAS = 캐스케이드 패턴** (단순 disable / 면별 분리 / 수량-clamp / 사이즈 2D / 옵션 add-on)

### 1.2 단계 분류표 + 순서 (확정안)

순서 원칙: **기존 코어 재사용도가 높은 군(어댑터+데이터만) → 신규 componentType이 필요한 군** 순. 검증된 코어 위에 한 번에 하나의 새 능력만 얹는다.

| Stage | 상품군 (카테고리) | 대표 SKU | 가격모델(PM) | 입력수단(IN) | 핵심 신규 needs | 비용등급 |
|------|------------------|---------|-------------|-------------|----------------|---------|
| **S0 ✅DONE** | 책자·포토북 (06) | 중철/무선/PUR/하드커버, 포토북 | PriceTable3D + binding | editor(표지)+pdf(내지) | — (구현·QA 완료) | — |
| **S1** | 디지털인쇄: 엽서·명함·접지·쿠폰·전단·리플렛 (01·03) | 프리미엄엽서, 프리미엄명함, 2단접지카드, 스탠다드쿠폰, 소량전단지 | **PriceTable3D** (수량밴드×ink×단/양면) | editor / pdf | **없음** — size·material·dosu·finish·quantity 전부 기존 5 componentType. 별색(화이트/클리어/핑크/금/은)=dosu 값 확장만 | **순수 어댑터+데이터** |
| **S2** | 스티커 (02) | 반칼자유형, 규격스티커, 합판도무송, 타투, 스티커팩 | **PriceTable3D**(반칼 판수×소재×수량) + **FixedUnit**(타투 3장/스티커팩 54장 세트) | editor / pdf | FixedUnit은 BFF만. 위젯=기존 componentType. 판수=size류 option-button | **순수 어댑터+데이터** (FixedUnit BFF) |
| **S3** | 포스터·실사·사인·배너 (04·05) | 아트프린트포스터, PET배너, 일반현수막, 시트커팅 | **SizeMatrix2D** (가로×세로 bilinear) | pdf 위주 (일부 editor) | **신규 NC-1 `dimension-matrix-input`** (규격 프리셋 + 비규격 가로×세로 동시 입력 → 2D 단가). 배너 가공옵션=finish-button | **신규 componentType 1종** |
| **S4** | 아크릴 (09) | 아크릴키링/명찰/스탠드/코롯토/카라비너 | **SizeMatrix2D**(가로×세로) + 옵션add-on + **TieredDiscount**(수량50%) | editor 위주 | **신규 NC-2 `option-addon-picker`** (고리/자석/바디칼라 등 가격기여 옵션, 라벨+추가단가 표시). 사이즈=NC-1 재사용 | **신규 componentType 1종** |
| **S5** | 굿즈·라이프·에코백·파우치·문구·포장 (10·11·08·12 일부) | 머그컵, 레더파우치, 만년다이어리, OPP봉투 | **TieredDiscount** (수량구간 %할인) + **FixedUnit**(일부 포장) | editor / pdf / no-design | 색상/타입 다수 → **신규 NC-3 후보 `image-option-selector` 64×64** (DESIGN 7.6, 현 14종 외). 그 외 기존 | **신규 componentType 1종 (조건부)** |
| **S6** | 캘린더 (07) | 탁상형/벽걸이/디자인캘린더 | PriceTable3D + 캘린더제본(§11.3) | editor 위주 | **없음** — 책자형 제본 변형. S0 코어 재사용. 단가표만 | **순수 어댑터+데이터** |

> **분류 근거:**
> - S1(디지털인쇄)을 1번에 둔 이유: 책자와 **동일 PriceTable3D 골격**(수량밴드×ink×단/양면)이며 옵션구조가 S0의 부분집합(제본·내지 없음). 신규 componentType 0, 캐스케이드 패턴 동일(material→pcs disable, dosu↔color). 가장 안전한 첫 확장. [PRC §3][PM §5.1·5.3]
> - S2(스티커)는 PriceTable3D 변형(판수 차원) + FixedUnit(타투/스티커팩). FixedUnit은 BFF 계산만 바뀌고 위젯 입력은 기존 그대로(수량 counter). [PRC §6]
> - S3(포스터/실사)에서 **처음으로 SizeMatrix2D + 가로×세로 입력**이 등장 → 첫 신규 componentType. [PRC §7]
> - S4(아크릴)는 SizeMatrix2D(S3 재사용) + 옵션 add-on(신규) + TieredDiscount(S5 선취). [PRC §8]
> - S5(굿즈/파우치/문구)는 TieredDiscount 본진. 색상/타입 셀렉터가 많아 image-option-selector 필요 가능성. [PRC §9][PM §4.1 cat10·11]
> - S6(캘린더)는 책자형이라 사실상 S0 변형 — 단가표만 추가. 마지막에 저비용으로 흡수.

### 1.3 비용 요약 (사용자 질문 ②에 대한 답)

| 구분 | Stage | 근거 |
|------|-------|------|
| **순수 어댑터+데이터 (cheap, 위젯 코어 0)** | **S1, S2, S6** | 기존 5 componentType + finish로 100% 커버. 가격모델 차이(FixedUnit)는 BFF만. |
| **신규 componentType 필요 (위젯 가시 — flag)** | **S3 (NC-1), S4 (NC-2), S5 (NC-3 조건부)** | 가로×세로 입력·옵션 add-on·64×64 이미지셀렉터는 현 14종이 못 담음. 단 **각 1종, 신규 컴포넌트 파일 추가**이지 코어(dispatcher/store/cascade/shadow) 재작성 아님. |
| **위젯 코어 재작성 (진짜 필요?)** | **없음** | 4축 분석 결과 dispatcher switch에 case 추가 + 컴포넌트 파일 추가로 전부 흡수. store·cascade·shadow·price-seam·editor-bridge 불변. INV-3 유지. |

> **정직한 flag:** S3·S4·S5의 신규 componentType은 "코어 재작성"이 아니라 **dispatcher 확장 + 신규 leaf 컴포넌트**다. 단 하나 주의 — NC-1(dimension-matrix-input)은 캐스케이드에 **사이즈→2D 단가 트리거** 흐름이 추가되므로 store의 가격요청 조립부(`dimensions` 채우는 로직)가 "수치 직접 전달" 경로를 타야 한다. 이는 계약 `PriceDimension.cutW/cutH`가 이미 수치 슬롯을 제공하므로 **계약 변경 0, store 조립 로직만 분기 확인** 수준. [DC PriceDimension]

---

## 2. Per-Stage 델타 분석

각 stage가 재사용 코어 대비 무엇을 바꾸는가. 형식: (a) 어댑터 확장 (b) componentType 커버 (c) 가격모델 (d) 캐스케이드 (e) 입력수단.

### S1 — 디지털인쇄 (엽서·명함·접지·쿠폰·전단) [순수 어댑터+데이터]

- **(a) 어댑터:** Red fixture(엽서/명함류는 `vTmpl_price` 계열) → 기존 `red-adapter` 그대로. `DATASET_COMPONENT_TYPE`에 변경 0. 후니 측은 `t_prd_product_sizes/materials/print_options/processes`로 동일 매핑 [DBMAP §1.2]. **별색 5종(화이트/클리어/핑크/금/은)** 은 dosu/inkType OptionValue 추가 + `priceColorCount` 평면화 [DA §2.2] — 값 데이터만, 코드 0.
- **(b) componentType:** size=option-button, material=select-box, dosu=option-button, finish=finish-button/color-chip(별색 색상), quantity=counter-input. **전부 기존 14 중 5종.** 신규 0.
- **(c) 가격모델:** PriceTable3D (수량밴드×ink×단/양면) [PRC §3]. BFF가 productCode prefix(001/003)로 분기. 명함=100장 set 단위, 박명함=동판비+가공비 [PRC §5.2]는 BFF 라인아이템.
- **(d) 캐스케이드:** S0과 동일 패턴 — material→pcs disable, dosu↔colorCount, size→cut/work. 면 분리 없음(단일면 또는 양면=한 상품). [DC §2]
- **(e) 입력수단:** editor 또는 pdf 단일면. ProductSide=[default]. 책자형 표지/내지 분리 없음 → 더 단순.

### S2 — 스티커 [순수 어댑터+데이터, FixedUnit은 BFF]

- **(a) 어댑터:** 반칼/규격 스티커는 PriceTable3D 변형(판수 차원). 판수(A5=4판 등 [PRC §6.1])는 **size류 option-button**으로 노출하고 가격 차원은 BFF 내부. 타투스티커(3장 step)·스티커팩(54장 세트)은 `priceSchemeKey`만 FixedUnit 키로 echo.
- **(b) componentType:** 기존. 소재 3종(유포/코팅/투명)=select-box 또는 option-button. 신규 0.
- **(c) 가격모델:** PriceTable3D(반칼) + **FixedUnit**(타투/스티커팩, `unitPrice × ceil(qty/step)` [PRC §6.3]). FixedUnit은 위젯 무관 — quantity counter 입력 그대로, step만 InputSpec.step으로.
- **(d) 캐스케이드:** 소재→완칼/반칼 disable 정도. 단순.
- **(e) 입력수단:** editor/pdf.

### S3 — 포스터·실사·사인·배너 [신규 componentType NC-1]

- **(a) 어댑터:** 실사 fixture(아직 미캡처 — §6 리스크). 규격 프리셋(A3/A2/A1) + **비규격 가로×세로 자유입력**([PM §1.4 nonspec], `MIN/MAX_CUT_WDT/HGH`). 어댑터가 nonspec 상품일 때 `dimension-matrix-input` OptionGroup 1개 생성 [DBMAP §1.4 G4].
- **(b) componentType:** **신규 NC-1 `dimension-matrix-input`** — 규격 선택(option-button) + 비규격 가로×세로 동시 입력(area-input 변형, 2D 단가표 트리거). 기존 `area-input`(박크기용)과 구분: area-input은 후가공 치수 입력(가격 보조), NC-1은 **본 사이즈 = 2D 단가 결정 차원**. 배너 가공옵션(열재단/타공/봉미싱 [PRC §7.4])=finish-button.
- **(c) 가격모델:** **SizeMatrix2D** (가로×세로 bilinear 보간 [PRC §7.1·16.4]). 9개 소재별 단가/m². 보드·액자는 단일사이즈 단가(option-button로 충분). 현수막=가로×세로 매트릭스.
- **(d) 캐스케이드:** size(규격/비규격) → cutW/cutH 산출 → 가격요청 `dimensions[].cutW/cutH` 수치 직접. 소재→가공옵션 disable.
- **(e) 입력수단:** pdf 위주(실사는 대형 출력). 배너 무료배송 제외 [PRC §15.2]는 BFF.

### S4 — 아크릴 [NC-2 = finish-button 흡수 확정, 신규 componentType 없음 — QA GO. 판정 소스: s4-acryl-spec.md]

- **(a) 어댑터:** ACNTHAP fixture 보유([SRC fixtures], `vTmpl_price`, custom W/H). 아크릴 부자재 옵션(WRK_MTR: 옷핀집게/마그넷)을 기존 `finish-button`(selectedFinishes echo)으로 흡수 — 어댑터/위젯 0줄 변경. **사이즈는 NC-1 재사용 아님**: ACNTHAP는 `vTmpl_price` + 0×0 sentinel 부재 → `option-button`(소/중 프리셋). 자유입력 가진 타 아크릴 SKU만 NC-1 자동 발동.
- **(b) componentType:** **NC-2 신규 없음 — `finish-button` variant 흡수 확정**(디자인 시스템 v5.0.0에 가격델타 전용 컴포넌트 부재). 부자재는 텍스트 라벨뿐(색상/이미지 없음)이라 finish-button(116×50, RULE-2)이 정확. 추가단가 라벨 병기는 fixture에 델타 숫자 부재 → 현 단계 표시값 없음. 후니 가격표 연동 시 어댑터가 `OptionValue.label`에 텍스트 병기(계약 가격필드 추가 금지, INV-1).
- **(c) 가격모델:** **SizeMatrix2D**(투명3T/1.5T/미러3T 매트릭스 [PRC §8.1-8.3]) + 옵션단가 합산 + **TieredDiscount**(아크릴 50% 최대 [PRC §8.4]). 3중 모델 합성 — 전부 BFF.
- **(d) 캐스케이드:** 형태(키링/명찰/스탠드)→가능 옵션 disable. 사이즈→매트릭스 셀.
- **(e) 입력수단:** editor 위주(아크릴은 디자인 편집).

### S5 — 굿즈·라이프·에코백·파우치·문구·포장 [신규 NC-3 조건부]

- **(a) 어댑터:** GSTGMIC fixture 보유([SRC], `tiered_price`). 카테고리 010/011은 **MES ITEM_CD 미부여**([PM §3 D-PM-01], 무결성 PM-MISS-01) → 어댑터 키를 ID 또는 신규 코드로(§6 리스크). 색상/타입 다수.
- **(b) componentType:** 색상칩(기존 color-chip/mini/large 커버). **조건부 신규 NC-3 `image-option-selector` 64×64**(DESIGN 7.6, [CT §7 OPEN]) — 굿즈 재질/형태를 이미지로 고르는 경우. image-chip(50×50)으로 충분하면 NC-3 불필요 → **DESIGN/Figma 확인 후 결정**(현재 image-chip variant로 흡수 가능성 높음, 단순성).
- **(c) 가격모델:** **TieredDiscount** (파우치/문구/굿즈A·B/말랑 5종 할인테이블 [PRC §9.1]). 말랑 2개부터 즉시할인·최대50%. 일부 포장재=FixedUnit(완칼 2000원/장 [PRC §12]). 전부 BFF.
- **(d) 캐스케이드:** 단순(타입→색상 disable 정도). 다수 SKU지만 옵션구조는 얕다.
- **(e) 입력수단:** editor / pdf / **no-design**(부자재·포장재는 디자인 없이 수량만). no-design = ProductSide 없이 quantity만 — 위젯이 이미 수용(uploadType 없으면 업로드영역 미렌더).

### S6 — 캘린더 [순수 어댑터+데이터]

- **(a) 어댑터:** 캘린더 시트 + 디자인캘린더(가격포함). PM-CROSS-01(탁상형이 캘린더+디자인캘린더 양쪽 [PM §6]) → 어댑터가 source of truth 1개 선택.
- **(b) componentType:** 기존. 캘린더는 책자형(표지+월별내지). 신규 0.
- **(c) 가격모델:** PriceTable3D + 캘린더제본(삼각대 포함 [PRC §11.3]). S0 binding 변형.
- **(d) 캐스케이드:** S0 책자 패턴 재사용(표지/내지 면 분리).
- **(e) 입력수단:** editor 위주.

---

## 3. 신규 componentType 식별 (사용자 질문 ③에 대한 답)

현 14 componentType이 못 담는 것은 **최대 3종**. 전부 dispatcher case + leaf 컴포넌트 추가이며 코어 불변(INV-3/INV-5).

| ID | 신규 componentType | 어느 stage | 무엇 | 신규 vs variant | 계약 영향 |
|----|---------------------|-----------|------|-----------------|-----------|
| **NC-1** | `dimension-matrix-input` | S3 (포스터/실사) | 규격 프리셋 선택 + 비규격 가로×세로 동시입력 → **2D 단가 결정 차원** | **신규** (기존 area-input은 후가공 치수 보조용 — 의미·가격역할 다름) | `ComponentType` union에 1개 추가. `InputSpec.axis2`(가로/세로) 이미 존재 → InputSpec 재사용. `PriceDimension.cutW/cutH` 수치 슬롯 이미 존재. **계약 신규 필드 0, union 1줄** |
| **NC-2** | ~~`option-addon-picker`~~ → **finish-button 흡수** | S4 (아크릴) | 부자재(옷핀/마그넷) 라벨 선택형 | **확정: 신규 없음**(QA GO) — 디자인 시스템에 가격델타 전용 컴포넌트 부재, finish-button으로 충분 | union 추가 0. 추가단가는 후니 연동 시 어댑터가 **라벨 텍스트 병기**(계약 가격필드 추가 금지) |
| **NC-3** | `image-option-selector` 64×64 | S5 (굿즈) — **조건부** | 굿즈 재질/형태 이미지 선택 (DESIGN 7.6) | **image-chip(50×50) variant로 흡수 우선 검토** → 흡수 안 되면 신규 | image-chip에 `size` variant prop 추가로 해결 시 union 변경 0 |

> **단순성 판정:**
> - NC-1은 **불가피**(2D 사이즈 입력 = SizeMatrix2D의 전제). S3 진입 시 반드시 추가.
> - NC-2는 **변형 우선**. DESIGN/Figma에서 아크릴 옵션이 option-button과 시각 동일하면 신규 불요 — OptionValue.label에 "(+1,200원)" 병기로 흡수. **Figma 확인 후 확정**(§4).
> - NC-3은 **흡수 우선**. image-chip 64×64 variant로 해결 가능성 높음. 신규 컴포넌트는 최후.
> - **결론: 확정 신규 1종(NC-1), 조건부 2종(NC-2/NC-3은 variant 우선).** [CT §7 OPEN의 ImageOptionSelector 64×64 항목과 정합]

---

## 4. Figma 시각 재현 통합 (사용자 질문 ⑤에 대한 답)

Q2에서 선택된 Figma 시각 재현을 **stage 단위로 매핑**하여 재작업 0으로 만든다.

### 4.1 매핑 원칙

- DESIGN.md 14 componentType은 **이미 시각 스펙 보유**([CT §2] 픽셀·색·상태). S0~S6 공통 컴포넌트는 **이 스펙으로 1회 구현 = 전 stage 재사용**. Figma 재현은 컴포넌트 단위로 1번.
- Stage별 Figma 작업 = **그 stage가 처음 도입하는 컴포넌트/섹션의 시각 스펙 확정**뿐. 즉:
  - S0~S2: 기존 14 컴포넌트 시각 = **이미 DESIGN.md에 있음**. Figma 추가작업 거의 0 (상품별 옵션 배치만 데이터구동 RULE-5로 자동).
  - **S3: NC-1(dimension-matrix-input) 시각 스펙을 Figma에서 신규 확정** (규격칩+가로×세로 입력 레이아웃).
  - **S4: NC-2(option-addon-picker) 시각 — 가격델타 병기 레이아웃** Figma 확정 (또는 option-button 재사용 판정).
  - **S5: NC-3(image-option-selector 64×64) 시각** — image-chip variant 판정 + 굿즈 섹션 배치(`huni_product_option.fig`의 굿즈 섹션).
  - S6: 캘린더 섹션 배치 = 책자 섹션 재사용.
- **per-group visual specs**: DESIGN.md / `huni_product_option.fig`는 11개 상품 섹션 시각을 보유([huni-design-system 스킬 v4.1.0 — option_New 12섹션]). stage 진입 시 해당 섹션 .pen/Figma 스펙만 참조하여 **레이아웃 힌트(Zone 배치)** 확정. 컴포넌트 자체는 재사용.

### 4.2 Figma 작업 순서 = stage 순서

| Stage | Figma 신규 확정 대상 | 재사용 |
|-------|---------------------|--------|
| S0~S2 | (없음 — 14종 기존 스펙) | 책자/엽서/명함/스티커 섹션 배치 |
| S3 | **NC-1 레이아웃** + 포스터/실사 섹션 Zone | 14종 |
| S4 | **NC-2 레이아웃**(또는 button 재사용 판정) + 아크릴 섹션 | 14종 + NC-1 |
| S5 | **NC-3 판정**(image-chip variant) + 굿즈/파우치 섹션 | 전체 |
| S6 | 캘린더 섹션 배치 | 책자 섹션 |

> **재작업 방지 핵심:** 시각 작업은 **컴포넌트 단위로 1회**. 상품군이 늘어도 같은 컴포넌트면 Figma 재작업 0(데이터구동 RULE-5). 신규 시각 작업은 신규 componentType 3종 + 섹션 Zone 배치에 국한.

---

## 5. Per-Stage QA 게이트 (사용자 질문 ④에 대한 답)

각 stage의 "done" 정의 + 비교 하네스(4173) 검증 방법. 공통 게이트 + stage 특화 게이트.

### 5.1 공통 게이트 (전 stage)

1. **빌드/타입/테스트 green** (tsc noEmit, vitest) — INV-5 dispatcher exhaustive 포함.
2. **Shadow DOM 격리 + Portal** 유지(INV-4) — 호스트 스타일 누수 0, EditorOverlay 최상단.
3. **계약 중립 테스트**(INV-2) — 계약 타입에 Red/후니 고유명 0(grep 게이트).
4. **위젯 회귀**(INV-3) — 이전 stage fixture가 여전히 통과(코어 불변 증명).

### 5.2 비교 하네스(4173) stage별 검증

비교 하네스는 우리 위젯 vs Red 레퍼런스를 대조한다. Stage별로:

| Stage | 검증 fixture | "done" 기준 (vs Red) |
|-------|-------------|---------------------|
| S1 | 엽서/명함 Red 캡처(신규 캡처 필요 — §6) | 옵션 트리·캐스케이드 disable·가격요청 페이로드가 Red와 일치. 별색 5종 정상 렌더 |
| S2 | 스티커 Red 캡처 + 타투/스티커팩 | PriceTable3D(반칼) + FixedUnit(타투 step) 가격요청 일치. 판수 option-button 정상 |
| S3 | 포스터/실사/배너 Red 캡처(**미보유 — 캡처 필요**) | NC-1 가로×세로 → `dimensions.cutW/cutH` 수치가 Red 2D 요청과 일치. SizeMatrix2D 결과 일치 |
| S4 | ACNTHAP(✅보유) + 아크릴 다형 | NC-2 옵션 add-on 선택 → `selectedFinishes`/옵션 echo 일치. 50% tier 할인 BFF 결과 일치 |
| S5 | GSTGMIC(✅보유) + 파우치/문구 | TieredDiscount 5종 할인구간 BFF 결과 일치. no-design 상품 업로드영역 미렌더 |
| S6 | 캘린더 Red 캡처 | 책자형 면분리 + 캘린더제본 가격 일치 |

> **게이트 통과 정의:** (a) 위젯이 정규화 요청을 Red와 **동등한 의미**로 조립(불투명 id round-trip 일치 [DC §8]) (b) 비교 하네스에서 동일 옵션 선택 시 동일 `finalPrice`(Red BFF 기준) (c) 캐스케이드 disable 집합 일치 (d) 14(+신규) componentType DESIGN 8 Critical Rules 준수(선택=흰배경+보라테두리, native select 금지 등 [CT §2]).
> **Red 비교의 한계:** 후니 가격은 Red와 **별개 공식**([DA §4.2])이므로, 가격 *수치* 일치는 Red 어댑터 단계에서만 검증. 후니 어댑터 단계에서는 "정규화 스키마 일치 + BFF 4모델 결과 합리성"으로 게이트 전환([DBMAP §8.4]).

---

## 6. 리스크 & 불변식 (사용자 질문 ⑥에 대한 답)

### 6.1 깨지면 안 되는 것 (불변식 재확인)

INV-1~5(§0). 특히 확장 중 빈발 위험:
- **INV-3 위반 유혹:** 새 상품군 특이 로직을 store/cascade에 하드코딩하려는 충동 → **금지**. 전부 어댑터 매핑 또는 신규 leaf 컴포넌트로. dispatcher switch만 늘린다.
- **INV-2 위반 유혹:** SizeMatrix2D 좌표·tier 할인율을 계약에 넣으려는 충동 → **금지**. 전부 BFF. 계약은 8축 입력 + 불투명 결과만.
- **INV-1 위반 유혹:** 옵션 add-on 가격델타(§S4 NC-2)를 위젯이 계산하려는 충동 → **금지**. 델타는 라벨 텍스트(표시)일 뿐, 합산은 BFF.

### 6.2 무결성 결함 → 어댑터 키 영향 (PM §6 / PRC §17)

| 결함 | 영향 stage | 어댑터 대응 |
|------|-----------|------------|
| **PM-DUP-01~04** (코드 중복: 001-0014, ID 22852/14567/14592) | S1·S2·S6 | 어댑터 키를 (code) 단독이 아니라 **(code + side/variant)** 복합키로 또는 신규 안정키 발급. 위젯은 불투명 id만 보므로 어댑터가 round-trip만 보장하면 위젯 무관 [DC §8] |
| **PM-MISS-01** (cat 010/011 MES ITEM_CD 부재 100+종) | **S5** | 어댑터가 ID 또는 신규 코드를 `NormalizedProduct.code`로. D-PM-01 신규 코드정책 대기 — **위젯 무관**(불투명) |
| **PM-MISS-02** (별색엽서/형압명함 등 코드 미부여) | S1·S4 | 동일 — 어댑터 키 발급 |
| **PM-CROSS-01** (캘린더 중복정의) | S6 | source of truth 1개 선택(어댑터) |

> **핵심:** 모든 무결성 결함은 **어댑터 경계에서 흡수**된다(INV-2/3). 위젯은 `id`를 비교·echo만 하므로 코드체계가 지저분해도 위젯 코드 0 영향. 단 어댑터 키 안정성(round-trip)은 **어댑터 계약 테스트**로 게이트.

### 6.3 데이터/캡처 리스크

| 리스크 | 영향 | 대응 |
|--------|------|------|
| **실사/포스터(S3)·캘린더(S6) Red fixture 미보유** | S3·S6 비교검증 지연 | live-capture 스킬로 해당 상품 라이브 캡처 선행. S3 진입 전 캡처가 임계경로 |
| **후니 가격·제약 미작성**([DBMAP §0.1]) | 후니 *최종통합* 시점 | **위젯 개발 무차단** — Red fixture + mock BFF로 전 stage 구현·검증. 후니 어댑터 가격/제약 arm만 후니 작성 후 교체. INV-1/3 |
| **NC-2/NC-3 variant vs 신규 미확정** | S4·S5 컴포넌트 결정 | Figma 확인(§4)으로 stage 진입 시 확정. 기본=variant 흡수(단순성) |
| **배송정책 미확정**(D-PM-16) | shipping 값 | BFF/어댑터, 위젯 불투명. 무관 |

---

## 7. 권장 Stage 1 착수 범위 (사용자 질문 ⑦에 대한 답)

본 전략 확정 후 **S1(디지털인쇄: 엽서·명함·접지·쿠폰·전단·리플렛)** 으로 착수 권장.

### 7.1 이유

1. **위젯 코어 0 변경** — 기존 5 componentType + finish로 100% 커버. 첫 확장에서 신규 componentType·코어 리스크 없이 "어댑터+데이터만으로 상품군이 는다"는 컨버전 가설을 실증.
2. **검증된 PriceTable3D 재사용** — 책자(S0)와 동일 가격골격. BFF 가격 arm 재사용도 최대.
3. **물량·대표성** — 엽서(18~22)+명함류(18)+접지/쿠폰 = 12 카테고리 중 가장 보편적 옵션조합(size·material·dosu·finish·quantity). 이 군이 서면 S2·S6는 거의 자동.
4. **별색 5종**만 새 데이터(dosu OptionValue + priceColorCount 평면화) — 코드 아닌 데이터 작업.

### 7.2 S1 착수 체크리스트 (구현 핸드오프용 — hw-builder)

- [ ] 엽서·명함 Red fixture 캡처(live-capture) — `vTmpl_price`/명함 set 단위 확인
- [ ] red-adapter: 별색 5종 dosu OptionValue + `priceColorCount` 평면화([DA §2.2]) — **매핑 데이터만**
- [ ] `DATASET_COMPONENT_TYPE` 변경 **불요** 확인(기존 size/material/dosu/quantity 그대로)
- [ ] ProductSide=[default] 단일면 경로 검증(책자 표지/내지 분리 없음)
- [ ] BFF stub: PriceTable3D 엽서/명함 단가([PRC §3·§5]) mock 응답
- [ ] 비교 하네스(4173): 엽서/명함 옵션트리·캐스케이드·가격요청 Red 일치
- [ ] DESIGN 8 Critical Rules 회귀(전 컴포넌트)
- [ ] **위젯 코어 회귀**: PRBKYPR(S0) fixture 여전히 통과(INV-3)

### 7.3 S1 이후 순서

S1 → S2(스티커, FixedUnit BFF) → **S3(포스터/실사, NC-1 신규 — 첫 시각·컴포넌트 작업)** → S4(아크릴, NC-2) → S5(굿즈/파우치, NC-3 조건부) → S6(캘린더, 책자 변형). 각 stage는 §5 게이트 통과 후 다음 진입(implement → verify → refine).

---

## 8. Improve/Refine 루프 (사용자 질문 ⑤ — 이전 stage 보정)

후속 stage가 이전 stage의 갭을 드러낼 때의 보정 메커니즘.

- **원칙:** 계약 추가는 **어댑터-내부 / Red-중립**이면 자유. **위젯 가시 계약 변경**(`ComponentType` union, OptionGroup/OptionValue 필드, Price 계약)은 **명시적 flag + DESIGN 동기 + 전 stage 회귀** 필수(INV-5).
- **루프:**
  1. 후속 stage에서 "현 계약이 못 담는 것" 발견 → **어댑터로 흡수 가능한가?** 먼저 판정.
  2. 어댑터 흡수 가능(대부분) → 어댑터만 수정, 위젯·계약·이전 stage 무영향. refine 완료.
  3. 어댑터 흡수 불가(신규 componentType/계약필드 필요) → **위젯 가시 변경 flag** → 계약 union/필드 추가 → 14(+) 매핑·dispatcher 동기 → **전 stage fixture 회귀**(INV-3) → DESIGN/Figma 시각 동기(§4).
- **예시:** S4에서 NC-2가 필요하다고 판명되면, NC-1만 있던 S3은 영향 없음(dispatcher case 추가는 기존 case 불변). S5에서 image-chip에 `size` variant를 추가하면 S0~S4의 image-chip 사용처가 default size로 회귀 통과해야 함 → 비교 하네스가 게이트.
- **계약 추가 안전 규칙:** OptionValue/InputSpec에 **optional 필드 추가**는 하위호환(이전 stage 무영향). **union 멤버 추가**는 dispatcher exhaustive 체크가 강제(누락 시 tsc 실패) — 안전. **필드 의미 변경/삭제**만 위험 → 금지(새 optional 필드로 대체).

---

## 9. 요약 (오케스트레이터 반환용)

| 항목 | 결론 |
|------|------|
| **Stage 수/순서** | S0(✅책자) → S1 디지털인쇄 → S2 스티커 → S3 포스터/실사 → S4 아크릴 → S5 굿즈/파우치/문구 → S6 캘린더 (7단계) |
| **분류 기준** | 가격모델 × 옵션구조 × 입력수단 × 캐스케이드 (4축 유사성), 카테고리순·매출순 아님 |
| **순수 어댑터+데이터 (cheap)** | **S1, S2, S6** — 위젯 코어 0, 기존 5 componentType + finish |
| **신규 componentType (flag)** | **S3=NC-1(dimension-matrix-input, 확정·구현), S4=NC-2 신규 없음(finish-button 흡수 확정·QA GO), S5=NC-3(image-option-selector, image-chip variant 우선·미확정)** |
| **위젯 코어 재작성** | **없음** — 전부 dispatcher case + leaf 컴포넌트. store/cascade/shadow/price-seam/editor-bridge 불변 |
| **착수 권장** | **S1(디지털인쇄)** — 코어 0변경으로 컨버전 가설 실증, PriceTable3D 재사용, 별색 5종 데이터만 추가 |
| **최상위 리스크** | 실사/캘린더 Red fixture 미보유(캡처 선행) · 무결성 코드중복(어댑터 키 흡수) · 후니 가격·제약 미작성(위젯 무차단, 어댑터 교체) |

---

## 부록 — OPEN 항목 (build-plan 반영 대상)

- ~~NC-2~~ **확정**: S4 = finish-button 흡수, 신규 없음(s4-acryl-spec.md, QA GO). NC-3(image-option-selector) **신규 vs variant 최종 판정** — 디자인 시스템 확인 필요(S5 진입 시).
- S3·S6 Red fixture **캡처 선행** 필요(live-capture).
- 카테고리 010/011 신규 코드정책(D-PM-01) — 어댑터 키 발급 규칙(S5 진입 전 확인, 위젯 무관).
- 후니 어댑터 가격/제약 arm 연결 시점 = 후니 측 작성(B1/B2 [DBMAP §6.1]) — 위젯 최종통합 임계경로(개발 무차단).
