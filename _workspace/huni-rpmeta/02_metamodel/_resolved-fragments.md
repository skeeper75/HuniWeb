# 모호 fragment — 버킷팅 판정 (메타모델 아키텍트 해소)

> rpm-metamodel-architect가 `01_reverse/_ambiguous-fragments.md`의 7건을 메타모델 축으로 확정한 판정.
> 판정 원칙(SKILL §3 distinctness test): "고유 속성/lifecycle/관계가 있어 기존 축이 *왜곡 없이* 담을 수 없으면 distinct 축, 아니면 facet."
> 인쇄 도메인 정초 = `_workspace/huni-dbmap/07_domain/{entity-semantic-model,process-recipe-tree}.md`.
> RedPrinting은 검증된 참조 — 그 모델을 *있는 그대로* 포착한 뒤 축으로 승급/강등.

---

## A-1. CDL_DFT 거치대 — 부속물(Addon/SKU) 축 [distinct] + 부속물↔사이즈 캐스케이드 [facet of 제약]

- **판정:** **부속물 축(Addon)** = distinct. 거치대 폭↔사이즈 1:1 대응은 **제약 축의 캐스케이드 facet**(별도 축 아님).
- **근거:**
  - 거치대는 본체(인쇄물)에 *가하는 작업*이 아니다 → 공정 아님. PCS_COD 그룹으로 묶인 건 RedPrinting의 UI 편의(후가공 select 재사용)일 뿐, 의미는 별개 완제품.
  - 후니 도메인에 동형 축 실재: `t_prd_product_addons` = "완제 부속(거치대·우드봉·볼체인)", entity-semantic-model 9속성 #9 "addl_product — 부착공정(process)과 축 분리". → RedPrinting CDL_DFT = 후니 addons 축의 RP 표현.
  - 고유 속성 보유: 독립 SKU 코드(PT001~005·RLU01~03·PTODF…), 실내/실외 분류, 본체와 별개 재고/가격. 기존 7버킷(자재/공정/옵션/템플릿/제약/기초/카테고리) 어느 것도 "본체와 분리된 완제 부속물"을 왜곡 없이 못 담음(자재=본체 구성, 공정=본체 작업, 템플릿=완제 SKU 묶음이지 부속이 아님).
- **템플릿/SKU와의 구별:** 템플릿(SKU)은 "본체+부속의 *묶음 주문 단위*"(번들)이고, 부속물은 "묶음에 들어가는 *부속 부품*"이다. 거치대 자체 = 부속물 축. "본체+거치대 1세트" 주문 = 템플릿(번들) 축. 둘은 별개(아래 discovered-axes D-1 참조).
- **캐스케이드:** BNRLSLV에서 size(600/850/1000) ↔ 거치대(RLU01/02/03) 1:1 = **부속물↔사이즈 require/match 제약**. 이는 제약 축(Constraint)의 한 *논리유형*(아래 D-3)이지 새 축이 아니다.

## A-2. number4_sel "N배" — 이중 수량축 [distinct: 수량 축] (디자인 건수 vs 인쇄 수량)

- **판정:** **수량 축(Quantity)** = distinct, 단 **단일 스칼라가 아니라 두 개의 의미적 수량 슬롯**(주문 건수 ORD_CNT × 인쇄 수량 PRN_CNT).
- **근거:**
  - Vue BFF가 라벨을 확정: `quantityGroup = {orderCnt:"디자인 수(건수)", printCnt:"수량"}`. SSR "N배"는 같은 ORD_CNT의 레거시 표현(디자인 종류 수 = 세팅비/판비 곱수).
  - "건수"와 "수량"은 가격기여 메커니즘이 다르다 — 건수(디자인 종류) = 세팅/판 비용 곱수, 수량 = 면적단가 선형 곱. 단일 qty 스칼라로 평면화하면 가격 모델이 깨진다.
  - 후니 도메인: `t_prd_product_bundle_qtys`(묶음수 권/세트), entity-semantic-model #7 "bundle_qty ≠ page_rule". RedPrinting의 ORD_CNT는 후니 bundle_qty와 의미축이 다름(후니 bundle=완제 묶음 단위, RP ORD_CNT=디자인 건수) → 수량 축은 *복수 슬롯을 갖는 축*임이 RP에서 확증.
- **facet 아님 이유:** "옵션(수량)"으로 뭉뚱그리면 두 슬롯의 가격 의미가 소실. 수량 축은 독립 lifecycle(상품마다 어떤 수량 슬롯을 노출하는지 다름: 건수만/수량만/둘다) 보유 → distinct.

## A-3. 어깨띠 자재명 "부직포어깨띠" — 자재 축 [facet] + 소재/형상 분해는 자재 합성 규칙

- **판정:** **자재 축(Material)의 PTT facet**. 단 RedPrinting PTT = "소재 ≈ 상품정체" 혼재 → 후니 매핑 시 **소재(substrate) vs 형상(shape) 분리**가 권고(메타모델은 분리 표현력을 가져야 함).
- **근거:**
  - MTRL_CD=PXVGP001, PTT=VGP. 다른 BN도 PTT=소재(BFC현수막/MAS매쉬/TFC텐트천)인데 이들 역시 "소재 겸 상품군명". 즉 RP의 PTT 슬롯이 소재와 형상을 한 코드에 융합 = **자재 합성 규칙의 한 인스턴스**(아래 D-2 자재 합성/usage 축).
  - 후니 교훈(메모리 `dbmap-material-option-normalization`): 형상이 자재행에 오염되면 결함. entity-semantic-model #1 size = "재단치수", §2 "형상→size 또는 별도 shape". → 메타모델은 자재 축에 "소재"만 두고, 형상은 사이즈/카테고리 축으로 흘려보낼 표현력을 가져야 한다(RP는 융합, 후니 흡수 시 분리 — 갭분석가 영역).
- **새 축 아님:** "형상"이 별도 1급 축을 요구하지 않음 — 형상은 (a) 사이즈 프리셋(어깨띠=폭좁고 김), (b) 카테고리(상품군명), (c) 완칼/모양재단 공정 중 하나로 흡수됨(BN 샘플 전부). 단일 상품을 위한 shape 축 신설은 오버피팅(SKILL §5) → 거부.

## A-4. 인쇄방식(수성/라텍스) — 자재 합성코드의 한 축 [facet of 자재] + (잠재) 인쇄방식 축

- **판정:** RedPrinting 현 표현 = **자재 축의 합성 facet**(MTRL_CD가 인쇄방식별 분기). 단 인쇄방식은 후니 도메인에서 **1급 축(인쇄방식 레시피)**으로 별도 존재 → 두 모델의 위치 차이를 갭으로 기록.
- **근거:**
  - BNRLSLV: PXBOPXXX(수성) vs PXBOPTEX(라텍스), BNTNHVY: PXTFCXXX(수성) vs PXTFLXXX(라텍스). 동일 소재가 인쇄방식별 다른 MTRL_CD. → RP는 인쇄방식을 자재코드 끝자리로 인코딩.
  - 후니 process-recipe-tree §1: 인쇄방식 = 5종 최상위 축(PROC_000002~6), "1상품=1인쇄방식이 가능 공정 부분집합을 결정". 즉 후니는 인쇄방식을 *레시피 게이팅 축*으로 1급화.
  - 메모리 `dbmap-print-method-not-absolute-axis`: 인쇄방식 절대축 아님(강제 분리 금지). → RP의 자재 합성 표현도 정당, 후니의 1급 축도 정당. 메타모델은 "인쇄방식이 (a) 자재 분기로 인코딩되거나 (b) 별도 레시피 축으로 게이팅될 수 있다"는 *이중 표현*을 인정.
- **결론:** distinct 축으로 *승급하되 조건부* — discovered-axes D-7(인쇄방식/생산 레시피 축)에 distinct 등재. 단 BN 샘플에서는 자재 facet으로 관측됨을 명기(RP 표현 vs 후니 표현 갭).

## A-5. PKG_GB 포장 "말아서 포장 필수" — 제약 축 [facet: force 규칙] + (부) 공정-포장 이중성

- **판정:** **제약 축(Constraint)의 force(강제) 논리유형 facet**. 포장 자체는 공정의 한 leaf(포장공정)일 수 있으나, "소재→포장 *강제*"는 제약 논리(아래 D-3 force/require).
- **근거:**
  - PKG_GB=[PKG_RUP 말아서 포장 필수] = 단일 강제값(선택 불가). 두꺼운 소재(텐트천)가 강제. = disable(자재→공정 비활성)의 역방향 = **force/require**(자재→공정 필수화).
  - process-recipe-tree §2-1 "포장"은 전 Case 공통 마지막 공정 → 포장 = 공정 leaf. 하지만 "어떤 소재면 어떤 포장이 강제"는 제약 논리.
  - **이중성 처리:** 포장 *행*(PKG_RUP "말아서 포장") = 공정 축의 멤버. 포장 *강제 규칙*(텐트천 → PKG_RUP 필수) = 제약 축의 force. 한 fragment가 두 축에 동시 기여(공정 멤버 + 제약 규칙). 이는 자재공정bundle(D-2/D-3)과 같은 "한 선택이 복수 축 참여" 패턴.

## A-6. SUB_MTR "추가부자재"(QTY_INPUT_YN=Y) — 자재공정 bundle [facet: 공정의 자재소비] + 수량 슬롯 [facet of 수량]

- **판정:** **공정 축의 자재소비 facet**(SUB_MTRL_YN=Y) + **수량 축의 공정종속 슬롯 facet**(QTY_INPUT_YN=Y). 새 축 아님 — 두 기존 축의 교차.
- **근거:**
  - 세 플래그 동시: SUB_MTRL_YN=Y(부자재 소비) + QTY_INPUT_YN=Y(수량입력) + PCS_COD(후가공그룹).
  - 후니 [HARD] 메모리 `dbmap-option-material-process-bundle`: "한 옵션이 자재(아일렛=금속링)+공정(타공)". entity-semantic-model #4 process + #2 material usage_cd. → "공정이 부자재를 소비"는 공정 축의 자재 참조(FK) facet이지 별도 축 아님.
  - QTY_INPUT은 A-7과 동형(공정에 종속된 수량 파라미터) → 수량 축 facet.
- **핵심 메타모델 시사:** SUB_MTRL_YN 플래그 = "이 공정 멤버가 자재를 소비하는가"의 1급 표현. 메타모델 공정 엔티티에 `consumes_material` 불리언 + `material_ref` FK 필요. 이것이 RP의 가장 강한 발굴 — discovered-axes D-2에서 공정↔자재 결합으로 1급화.

## A-7. number_sel_ROP_DFT — 공정 파라미터(Process Parameter) 축 [distinct]

- **판정:** **공정 파라미터 축(Process Parameter)** = distinct (또는 강한 공정 축 sub-structure). 수량 facet으로만 보면 의미 소실.
- **근거:**
  - 로프(ROP_DFT)에 종속된 number_sel(USER/1~10) = 상품 수량(PRN_CNT)이 아니라 **특정 공정에 매개변수로 붙는 수량**.
  - 후니 동형: entity-semantic-model #4 "prcs_dtl_opt param", process-recipe-tree §2-3 "오시 줄수0~3·접지 16종 = 캐스케이드 입력값", 메모리 `dbmap-cpq-option-mapping`의 `ref_param_json`. 즉 후니도 공정에 파라미터 슬롯을 둠.
  - 고유 lifecycle: 파라미터는 공정 멤버가 선택됐을 때만 활성(조건부), 자체 도메인(수량/줄수/조각수/책등mm/링컬러)을 가짐, 가격에 공정과 함께 기여. → 기존 옵션/수량 축이 "공정에 매달린 매개변수"를 왜곡 없이 못 담음(옵션은 독립 선택, 파라미터는 부모 공정 종속).
- **distinct 판정:** UV 변형(풀빼다/배면양면), 오시 줄수, 접지 단수, 책등 mm, 링컬러, 로프 수량/길이, 조각수 — 전부 "공정에 종속된 매개변수"라는 공통 패턴. 단일 상품 아닌 횡단 패턴 → distinct (discovered-axes D-4).

---

## 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 발굴 등재 |
|---|---|---|---|---|
| A-1 거치대 | **부속물(Addon)** | 본체 분리 완제 부속 | **distinct** | D-1 |
| A-1 거치대↔사이즈 | 제약 | 캐스케이드 match | facet of 제약 | D-3 |
| A-2 이중 수량 | **수량(Quantity)** | 건수×수량 2슬롯 | **distinct(다중슬롯 축)** | D-5 |
| A-3 부직포어깨띠 | 자재(PTT) | 소재≈형상 융합 | facet of 자재 합성 | D-2 |
| A-4 수성/라텍스 | 자재 합성 facet → 인쇄방식 | RP=자재분기 / 후니=1급 | **distinct(조건부)** | D-7 |
| A-5 포장강제 | 제약(force) + 공정 leaf | 소재→포장 강제 | facet(이중) | D-3 |
| A-6 추가부자재 | 공정(자재소비)+수량 | 3플래그 교차 | facet(교차) | D-2·D-5 |
| A-7 로프 수량 | **공정 파라미터** | 공정종속 매개변수 | **distinct** | D-4 |

**강제 분류 회피(SKILL §3):** A-1/A-2/A-4/A-7은 7버킷으로 깔끔히 안 들어가 distinct 축으로 승급. A-3/A-5/A-6은 기존 축의 facet/교차로 흡수(새 축 신설은 오버피팅). 단일 상품 전용 축 신설 0건.

---

# GS(굿즈/잡화) fragment 판정 (v2.0 — 완제/입체 굿즈)

> `01_reverse/_ambiguous-fragments.md`의 GS G-1~G-8 판정. 2 상품군(BN 평면·GS 완제/입체) 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): GS 한 군만의 특이는 facet 강등. distinct 승급 = BN·GS 둘 다 견디는 governing/lifecycle 보유 시만.

## G-1. DIR_MTR / WRK_MTR 완제 본체 — 자재축 facet [distinct 거부] ★핵심 의사결정

- **판정:** **자재 축(#1)의 두 표현 facet** + 가격기여(#11)·템플릿(#4)·생산형태(#15) 결합. **distinct 신축 거부.**
- **양면 트레이드오프 펼침(침묵 선택 금지):** discovered-axes G-1 참조 — (가) 별도 "완제 본체 SKU" 축 신설 vs (나) 자재 facet + 기존 축 결합. **(나) 채택**: BN 본체(ORD_INFO.MTRL_CD 자재행)·GS 본체(DIR_MTR PCS 항목)는 DB 위치만 다른 *같은 자재참조*. 신축 시 자재축이 BN/GS로 분열(같은 개념 2축). PRICE 주체성=#11, SKU성=#4, 표현 governing=생산형태#15가 흡수.
- **근거:** entity-semantic §4 "C 완제품: 굿즈·낱장·대형, 내지/표지 개념 없음" + §2 "색상 variant→material". 후니 "굿즈 본체소재 컬럼 부재·소재 상품명에만"(메모리 round-22 GPM)과 정확히 동형 → RP도 완제 본체에서 라벨 융합 결함.
- **[HARD] 분해 요구:** PCS_DTL_NME("미르 와이드마우스 보틀 화이트 20oz")를 `{body_material, body_color, capacity, thickness, brand}`로 분해(평면 라벨=의미축 drop). 이것이 후니 결함의 RP판 정답.

## G-2. 코스터 6소재 = 6 pdtCode — 자재+카테고리 복합 facet [distinct 거부] ★핵심 의사결정

- **판정:** **자재 축(#1 소재 variant) + 카테고리(#7 코스터=공통 기능 노드) 복합 facet. distinct 신축 거부.**
- **양면 트레이드오프 펼침:** discovered-axes G-2 참조 — (가) 소재=상품 분리(pdtCode 6 유지·RP 답습) vs (나) 소재=옵션화(한 코스터 + 소재 variant·카탈로그 6→1). **메타모델 판정 아닌 후니 카탈로그 *정책 결정***(둘 다 메타모델로 표현 가능). 권고: **정형 소재(종이/펠트/코르크/규조토/레더)=옵션화, 형상 동반 소재(아크릴 코스터=형상 캐스케이드)=별 pdtCode** 하이브리드.
- **근거:** "본체 소재"=자재축(mat_cd 분기), "코스터 공통 기능"=카테고리 노드 → 둘 다 기존 축이 담음, 신축 불요. 아크릴 코스터만 도무송 형상 동반(소재가 후속 옵션 캐스케이드) = 소재→옵션 캐스케이드 제약(#5).

## G-3. 폰케이스 기종 enum — 사이즈 프리셋 facet [distinct 거부]

- **판정:** **사이즈 축(#13)의 대규모 프리셋 인스턴스 facet. distinct 거부.**
- **근거:** 기종(갤럭시/아이폰)=사이즈/칼틀 프리셋 대규모 enum일 뿐 고유 lifecycle 없음(소재처럼 본체정체 안 바꿈·기능 동일). 기종↔칼틀=제약(#5 match). "일반/터프"=자재 본체타입 variant(#1, 기종과 직교). enum 규모가 커도 데이터 구조는 사이즈 프리셋 동일(위젯 UX만 검색형). 오버피팅 거부.

## G-4. variant 3채널(DTL/ATTB/CUT) — 기존 축 분배 facet [distinct 거부]

- **판정:** **3채널을 기존 축으로 분배. 별 "variant 축" distinct 거부.** ① DTL→옵션(#3 polymorphic option_item), ② ATTB→공정 파라미터(#9 링색·반경), ③ CUT→사이즈(#13).
- **근거:** entity-semantic §2 "variant 분해 원칙(색상→material·사이즈→size·두께→material)"이 이미 채널 분배 규정. **★난점 명기:** GSTGMIC TG001/3처럼 한 DTL이 자재+사이즈+칼틀+가격 동시 결정(강결합)=polymorphic ref 다중 게이팅(후니 `dbmap-cpq-option-layer-mapping`). 정규화 난점이지 신축 사유 아님.

## G-5. INN_DFT/RIN_DFT/RIN_COL/STA_DFT — 자재 usage 다중슬롯 + 제본 그룹 facet/확장

- **판정:** 내지=**자재 축(#1) usage 다중슬롯**(GS 확인 ✅, BN substrate 단일 한계 해소). 제본=**공정(#2) + 자재(링/코일) bundle + 택1 그룹**.
- **근거:** GSNTSPR 표지+내지+링 동시 = entity-semantic §2 usage_cd 7종 동형. 제본방식이 PCS_COD 레벨로 분리(RIN_DFT/RIN_COL/STA_DFT, 그룹 메타 없음) → **메타모델이 "제본 그룹(택1)"을 명시 묶어야**(후니 옵션그룹 택1). 새 축 아님 — 자재·공정 확장.

## G-6. PDT_WRK/FLX_ZIP 형태 조립 — 본체 형태가공 축 [distinct → D-10] ★GS 신축

- **판정:** **본체 형태가공 축(Body Form-Assembly) = distinct (D-10).** 평면→입체 본체 *생성*. FLX_ZIP은 자재소비(지퍼) bundle.
- **근거:** GSPUFBC(파우치가공·지퍼)·GSTGMIC(마이크텍 조립) — 일반 후가공(기존 본체에 작업)과 lifecycle 구별(형태가공 없으면 본체 부재). BN 전무·GS 다수 → 단일상품 아님. 후니 굿즈 BOM "평면→입체 조립" 동형. distinct 정당(discovered-axes D-10).

## G-7. tmpl/vTmpl/tiered_price — 가격기여 역할(#11) 확장 [facet]

- **판정:** **가격기여 역할 축(#11)의 pricing_model enum 4종 확장**(면적/tmpl/vTmpl/tiered). 새 축 아님.
- **근거:** 같은 옵션 모델 위 다른 가격 SP. price_gbn=상품 속성(라우팅키), 완제본체 유무가 분기 단서(DIR_MTR=tmpl/vTmpl, 없음=tiered가 PRT_DFT 주체). 메모리 `dbmap-price-formula-types-authority`(면적/고정/구간) 정합. vTmpl↔tmpl 차이(variant 유무)는 옵션 구조 재영향 → 가격모델↔옵션 양방향(미확정 갭).

## G-8. PAK_ETC/PAK_POL 포장 다중 + 유료/무료 — 공정 facet + 가격기여 분기

- **판정:** **공정 축(#2 포장)의 방식별 PCS_COD facet + 가격기여(#11 유료/무료 분기).** 새 축 아님.
- **근거:** PAK_ETC/PAK_POL 방식별 코드, 같은 코드라도 상품별 유료(장패드 1000)/무료(텀블러 0) → 단가행=상품×포장 조합. BN PKG_GB(강제 제약·A-5)와 달리 GS=선택+개당과금 경향. 포장=공정 leaf + 제약(A-5 force)/가격기여(#11) 이중성을 상품군별로 다르게 표현.

---

## GS 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 발굴 등재 |
|---|---|---|---|---|
| G-1 완제 본체 DIR_MTR | 자재(#1)+가격(#11)+템플릿(#4)+생산형태(#15) | 자재축 두 표현 facet | **facet(거부)** ★ | G-1 |
| G-2 코스터 6소재 pdtCode | 자재(#1)+카테고리(#7) | 소재 variant + 기능 노드 복합 | **facet(거부)** ★ | G-2 |
| G-3 폰케이스 기종 enum | 사이즈(#13) | 프리셋 대규모 인스턴스 | facet(거부) | G-3 |
| G-4 variant 3채널 | 옵션(#3)·공정파라미터(#9)·사이즈(#13) | 채널 분배 | facet(거부) | G-4 |
| G-5 내지 usage + 제본 | 자재(#1 usage)·공정(#2 bundle) | usage 다중슬롯 확인 + 제본 그룹 | facet/확장 | #1·#2 |
| G-6 PDT_WRK/FLX_ZIP | **본체 형태가공** | 평면→입체 생성 | **distinct** ★ | D-10 |
| G-7 가격모델 3종 | 가격기여(#11) | pricing_model 4종 | 확장(facet) | #11 |
| G-8 포장 다중/유료무료 | 공정(#2)+가격기여(#11) | 방식 코드 + 유료분기 | facet | #2·#11 |
| (횡단) 생산형태 | **생산형태** | 본체 모델 governing ⊥카테고리 | **distinct** ★ | D-9 |

**GS 강제 분류 회피(SKILL §3·§5):** distinct 승급 = **D-9 생산형태·D-10 형태가공 2종**(BN·GS 둘 다 견디는 governing/lifecycle). G-1~G-4는 양면 트레이드오프 펼친 뒤 facet 강등(완제 본체·소재 분리·기종·variant — 전부 기존 축 결합으로 왜곡 없이 표현). 단일 상품군 전용 축 신설 0건. ★G-1·G-2는 침묵 선택 거부하고 트레이드오프 명시 후 판정.

---

# TP(디자인템플릿) fragment 판정 (v3.0 — 디자인 입력/에디터)

> `categories/TP/reverse.md` ## Ambiguous fragments T-1~T-7 판정. 3 상품군(BN 면적·GS 완제·TP 디자인입력) 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): TP 한 군만의 특이는 facet 강등. distinct 승급 = 비-TP 트윈 직접 대조 + 후니 동형(huni-widget RedEditorSDK 계약) 보유 시만.
> ★메타모델 단계 해소 가능분과 라이브/엑셀 검증 필요분(→gap/validation 라우팅)을 구분 표기.

## T-1. 에디터 채널의 관리 그릇 — 디자인 입력 채널 축 [distinct → D-11 / #16] ★directive 핵심

- **판정:** **디자인 입력 채널 축(Design-Input Channel) = distinct (D-11·#16).** `item_gbn`+`useKoiEditor`/`useRPEditor`/`usePDF`/`useEditorOrdCnt`/`useTemplateDownload` 플래그 묶음 = 본체 옵션 트리와 직교한 별 관리축.
- **근거:** reverse §0.1 비-TP 트윈 직접 대조(TPCLSTD vs HLCLSTD — 본체/가격 동일·입력채널만 차이) + 가격 0(reverse §3 TPCLWLB) + huni-widget RedEditorSDK 45메서드·Edicus 브릿지 계약(`seed-redprinting-sdk-analysis.md`·`editor-bridge-protocol.md`). 옵션#3(본체속성)·공정#2(본체작업)·템플릿#4(완제번들) 어느 것도 "디자인 입력 메커니즘"을 왜곡 없이 못 담음. 7버킷 어디에도 안 들어감(reverse T-1 vessel-gap 1순위 가설 확정).
- **메타모델 해소:** ✅ 축 정초 완료(dictionary #16). **그릇 후보(상품 속성 컬럼 vs 별 테이블 vs 입력채널 엔티티) 중 메타모델은 별 엔티티(DesignInputChannel + 종속 TemplateAsset)로 모델링** — 후니 t_* 실제 그릇 유무·매핑은 **→ gap/vessel 단계**(라이브 information_schema에 item_gbn/에디터 플래그 대응 컬럼 확인).

## T-2. 템플릿 자산의 정체 — 입력채널 리소스 facet + 템플릿#4 이중의미 분리 [facet → T-A] ★핵심

- **판정:** **D-11 입력채널의 리소스 facet (distinct 거부). 단 [HARD] 템플릿#4와 이중의미 분리.** TP 템플릿 자산(`useTemplateDownload`·`koi_template_resource_id`·SDK getTemplateList) = 에디터 디자인 시안(가격0·D-11 종속) ≠ 후니 `t_prd_templates`(완제SKU 번들·주문단위·#4).
- **양면 트레이드오프(침묵 선택 금지):** discovered-axes T-A 참조 — (가) 별 distinct 신설 vs (나) D-11 리소스 facet + #4 이중의미 명시. **(나) 채택**: 템플릿 자산은 독립 lifecycle 없음(에디터 채널 없으면 0) → D-11 하위. 단 #4가 두 의미 갖지 않게 별 엔티티(`Template` 완제SKU / `TemplateAsset` 디자인 시안) 분리.
- **근거:** reverse §0.3·T-2 "같은 단어 다른 의미" 정확히 일치. 가격 0(인쇄/자재가 가격 주체). 메타모델 #4·#16에 이중의미 명시 완료.
- **메타모델 해소:** ✅ 이중의미 분리 정초 완료. 상품별 실제 템플릿 자산 카탈로그·VDP 변수 스키마는 unobserved(`koiOption[]` 빈배열) → **검증 필요분: 로그인 에디터 캡처 → validation 단계**.

## T-3. 티켓 넘버링/미싱(순차·절취) 공정 — 공정#2 (+넘버링은 VDP 가능) [facet → T-E] / 일부 검증 필요

- **판정:** **공정 축(#2) facet (distinct 거부).** 미싱(절취선)=공정#2. 넘버링(일련번호)=공정#2 또는 (가변 증분이면) VDP(T-B·#16 입력채널 데이터바인딩). reverse T-3 "순차/절취 공정축" 신축 가설 → **신축 불요**(절취=기존 공정, 순차번호=VDP/공정 분배).
- **근거:** reverse §2 SSR "미싱" 텍스트 + GS/AC 박·완칼 공정 동형. 순차번호가 *디자인 데이터*(에디터 변수)인지 *생산 공정*(인쇄 후 넘버링기)인지가 귀속을 가름.
- **메타모델 해소:** 🟡 부분 — 절취선=공정#2 확정. **넘버링 규칙(가변 증분·일련번호 시작/증가)은 unobserved → 검증 필요분: VDP vs 공정 귀속 라이브 확인 → gap/validation 단계.**

## T-4. "디자인 X" 상품의 모델링 단위 — 상품 분리 vs 옵션화 [메타모델 판정 아님·후니 정책] / gap 라우팅

- **판정:** **메타모델 판정 아닌 후니 카탈로그 *정책 결정***(GS G-2 코스터 6 pdtCode와 동류 모호성). RedPrinting=별 pdtCode(TPBCDFT vs BC 일반명함) — 검증된 방식이나 답습 강제 아님. 메타모델은 둘 다 표현 가능: (가) 별 pdtCode면 디자인입력채널(#16)이 상품 속성, (나) 옵션화면 한 상품의 입력채널 variant.
- **근거:** reverse T-4. "디자인 X"=동종(BC/WT/PO) + 입력채널 레이어. 입력채널이 직교(#16)이므로 *기술적으로는 옵션화 가능*(한 명함 상품 + 에디터 사용여부 플래그). 단 RP는 가격모델(digital vs 일반)·템플릿 자산 차이로 별 상품 운영.
- **메타모델 해소:** ✅ 메타모델은 양쪽 표현 가능(입력채널 #16이 상품속성/variant 둘 다 수용). **분리 vs 옵션화 선택은 후니 정책 → gap/vessel 단계(갭분석가·실무 결정).** GS G-2 하이브리드 권고(정형=옵션화·캐스케이드 동반=별 상품) 동형 적용 가능.

## T-5. PRT_WHT/PRT_MAG 특수인쇄의 버킷 — 공정#2 (별색=공정 경계) [facet → T-E]

- **판정:** **공정 축(#2) facet (distinct 거부).** PRT_WHT(화이트언더베이스)=공정(별색 family·화이트 후공정). PRT_MAG(메탈릭/마그넷 인쇄)=공정(특수인쇄). 박(TPTKFOI FOI)=공정 확정.
- **근거:** round-22 경계규칙 "별색=공정·잉크색≠자재·UV=공정param"(메모리 `dbmap-axis-staged-load-round22`). PRT_WHT를 도수(별색)나 자재(백색잉크)로 오적재 금지 — entity-semantic #2 "별색=공정 PROC_000007 family". reverse T-5 대조 요청 = 경계규칙으로 해소.
- **메타모델 해소:** ✅ 공정#2 귀속 확정(도메인 경계규칙). 검증 불요(도메인 사실).

## T-6. STA_CLD 쫄대(달력 봉)의 자재/공정 이중성 — 공정#2 + 자재#1 bundle [facet]

- **판정:** **공정 축(#2 제본) + 자재 축(#1 봉/쫄대 consumes) bundle facet (distinct 거부).** 효도달력 STA_CLD "쫄대" = 중철 제본(공정) + 쫄대(금속/플라스틱 봉=자재 consumes). GS 제본(링=자재+꿰기=공정) bundle과 동형 — "옵션=자재+공정 BUNDLE" 케이스 추가.
- **근거:** reverse T-6·§3. 메모리 `dbmap-option-material-process-bundle`(아일렛=금속링 자재+타공 공정) 동형. 메타모델 #2 "공정의 자재소비(SUB_MTRL_YN/consumes FK)" + #1 usage가 이미 담음.
- **메타모델 해소:** ✅ 기존 자재공정 bundle(D-2·#1/#2)로 흡수. 신축 불요.

## T-7. 페이지 계층(INN_PAGE)이 옵션인가 차원인가 — 수량모델#10 슬롯 + 제약#5 [facet → T-C]

- **판정:** **수량모델(#10) 다중슬롯 + 제약(#5 min/max/step) facet (distinct 거부).** INN_PAGE(2~200·STEP1)=캘린더 월수·북 대수 "내지 페이지수" 수량성 슬롯(ORD_CNT/PRN_CNT/bundle_qty와 나란함). 값 범위=제약#5.
- **근거:** reverse T-7·§0.4. seed §3 책자 "내지장수(2~130)" + bridge `num_page/max_page/min_page/unit_page`(에디터 공통 파라미터) = 후니/RP 모두 페이지수=수량성 입력. 수량모델이 이미 다중슬롯 축(D-5)이므로 신축 불요.
- **메타모델 해소:** 🟡 부분 — 수량모델#10 슬롯 귀속 확정. **INN_PAGE↔가격 결합방식(TPCLECO tiered_price와 페이지수 관계)은 unobserved → 검증 필요분: gap/validation 단계(가격 트랙).**

---

## TP 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| T-1 에디터 채널 그릇 | **디자인 입력 채널** | 본체와 직교·가격0·비-TP 트윈 | **distinct** ★ | D-11/#16 | 후니 그릇 유무 → gap/vessel |
| T-2 템플릿 자산 정체 | D-11 facet + 템플릿#4 이중의미 | 에디터 종속 리소스·#4와 다른의미 | **facet(거부)** ★ | T-A | 자산 카탈로그 → validation |
| T-3 넘버링/미싱 공정 | 공정#2 (+VDP) | 절취=공정·순차=VDP/공정 | facet(거부) | T-E | 넘버링 규칙 → gap/validation |
| T-4 "디자인 X" 모델링 단위 | (메타모델 판정 아님) | 후니 카탈로그 정책 | 정책결정 | T-4 | 분리vs옵션화 → gap/실무 |
| T-5 PRT_WHT/PRT_MAG | 공정#2 | 별색=공정 경계 | facet(거부) | T-E | (도메인사실·검증불요) |
| T-6 STA_CLD 쫄대 | 공정#2+자재#1 bundle | 제본+봉 consumes | facet(거부) | #1·#2 | (해소·검증불요) |
| T-7 INN_PAGE 페이지계층 | 수량#10 + 제약#5 | 수량성 슬롯+범위 | facet(거부) | T-C | INN_PAGE↔가격 → gap/validation |

**TP 강제 분류 회피(SKILL §3·§5):** distinct 승급 = **D-11 디자인 입력 채널 1종**(비-TP 트윈 직접 대조 + huni-widget RedEditorSDK 계약 권위). T-2~T-7은 양면 트레이드오프(특히 T-2 템플릿 자산) 펼친 뒤 facet 강등/정책 라우팅. 단일 카테고리 전용 축 신설 0건. ★T-1=가장 강한 vessel-gap distinct, T-2=템플릿 이중의미 [HARD] 분리, T-4=메타모델 판정 거부하고 후니 정책으로 라우팅(침묵 선택 회피).
**검증 라우팅 요약:** 메타모델 해소 ✅ = T-1(축정초)·T-4(양쪽표현)·T-5·T-6 / 부분 🟡 = T-2·T-3·T-7(unobserved 잔존 → gap/validation). 라이브/엑셀 검증 필요분 = 후니 입력채널 그릇 유무(T-1)·템플릿 자산 카탈로그·VDP 스키마(T-2)·넘버링 규칙(T-3)·INN_PAGE 가격결합(T-7).

---

# PR(인쇄물·책자·리플렛·포스터) fragment 판정 (v4.0 — 다면·제본·접지·인쇄방식)

> `categories/PR/reverse.md` ## Ambiguous fragments P-1~P-9 판정. **4 상품군(BN 면적 단면·GS 완제/입체·TP 디자인입력·PR 다면/제본/접지)** 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): PR 한 군만의 특이는 facet 강등. distinct 승급 = BN·GS·TP·PR 네 군을 견디는 고유 lifecycle/governing + 후니 도메인 동형 보유 시만.
> 도메인 정초 = `_workspace/huni-dbmap/07_domain/entity-semantic-model.md`(자재 usage_cd 7종·page_rule 엔티티·생산방식 A/B/C) + `process-recipe-tree.md`(접지/제본/인쇄방식 레시피). **접지·제본·인쇄방식(윤전/토너/인디고/리소) 도메인 의미는 reverse 실측(FLD_DFT 7종·제본 5방식·pdtCode prefix) + 07_domain KB로 충분히 정초 — domain-researcher 신규 호출 불요(추정 0).**
> **★PR 핵심 판정: distinct 신규 축 0건.** 9 fragment 전부 기존 16축의 facet/확장/정책으로 흡수. 이것이 *오버피팅 회피의 정직한 결과* — 4번째 카테고리가 새 관리축을 도입하지 않음 = **16축 모델 포화(saturation) 입증**(neighbor=강한 검증 신호). PR이 더한 것은 새 축이 아니라 기존 축의 *새 facet/family/cascade*(접지 family·역할 전파·인쇄방식 자재풀 게이팅·page_rule 정밀화).

## P-1. 접지방식(FLD_DFT)의 면(page) 인코딩 — 공정#2 family + 공정파라미터#9(접지방식 enum) + 제약#5(오시 동반) [facet → 신축 거부]

- **판정:** **공정 축(#2) "접지(folding)" family + 공정 파라미터(#9 접지방식 enum) + 제약(#5 cascade 오시 동반) facet. distinct 신축 거부.** "면 분할" 자체는 *별 차원이 아니라 접지방식에서 파생되는 결과값*(2단=4면·3단=6면) — DB 저장 차원 아님(판걸이수=앱계산 동형, 메모리 `dbmap-compute-in-app-db-stores-lookup`).
- **근거:**
  - reverse §0.3·§3 FLD_DFT 7종(2단/3단/4단/대문/반대문/병풍/N모양) = `pdt_pcs_info` 공정 멤버. 접지 *방식*=공정 파라미터 enum(오시 줄수·접지 16종이 공정파라미터#9인 것과 동형, 메모리 round-22 "접지 16종=캐스케이드 입력값").
  - 면 수(2단=4면)는 접지방식에서 *계산되는 파생값*이지 독립 입력 차원 아님 → "면 분할 축" 신설은 오버피팅(파생값을 축으로 승격 금지). 펼친사이즈→접지방식→면수는 단방향 계산.
  - 오시(OSI_DFT 접는선 누름)는 접지 동반 공정(두꺼운 용지 접을 때 필수) = 제약#5 match/force(접지방식→오시 cascade). process-recipe-tree §2-3 "오시 줄수=캐스케이드 입력값" 정합.
- **신규성:** 접지는 BN/GS/TP 미발굴 *공정 family*(평면 종이 면 가공) — 새 *멤버 family*이지 새 *축* 아님. #2 공정 축에 "접지" family 등재 + 접지↔오시 cascade 패턴 기록.
- **메타모델 해소:** ✅ 공정#2 family + #9 파라미터 + #5 cascade 귀속 확정. **검증 필요분: 리플렛 접지 강제여부·면수↔접지 캐스케이드(reverse SSR-negative) → gap/validation.**

## P-2. 표지/내지 역할 자재 슬롯의 그릇 — 자재#1 usage_cd 슬롯 facet(★역할 전파 강화) [facet → 신축 거부] ★핵심 의사결정

- **판정:** **자재 축(#1)의 usage_cd 슬롯 facet (distinct 거부). 단 [중요] PR이 usage_cd를 "태그"에서 "역할 전파(role propagation)"로 격상 입증.** `inner_pdt_mtrl_info`(내지) vs `pdt_mtrl_info`(표지)는 *별 축이 아니라 같은 자재축의 usage 슬롯 두 인스턴스*(.02표지/.01내지) — 후니 도메인 권위가 이미 7 usage 슬롯으로 모델링(`entity-semantic-model.md:23` USAGE 7종).
- **양면 트레이드오프(침묵 선택 금지):**
  - **(가) 별도 distinct "역할(role) 차원" 축 신설:**
    - 찬성: PR에서 role(cover/inner)이 자재뿐 아니라 *도수·가격·평량제약 전부를 role-paired*로 전파(`pdt_dosu_info` vs `inner_pdt_dosu_info`, F_CVR_MTRL_AMT vs K_INN_MTRL_AMT, COV_MIN_WGT vs INN_MAX_WGT). 단순 usage 태그보다 강한 횡단 전파 — pricing-role(#11)처럼 횡단 메타 후보.
    - 반대: role은 *새 관리 대상이 아니라 기존 usage_cd 차원의 값*(.01/.02/.03). 신축 시 자재의 usage_cd와 1:1 중복 축 발생. 도수/가격이 role-paired인 것은 usage_cd가 그 축들에 *전파*된 것이지 별 축이 아님(usage_cd가 자재→도수→가격으로 흐르는 간선). GS도 usage 다중슬롯(표지+내지+링) 이미 확인(#1 GS확장).
  - **(나) 자재#1 usage_cd 슬롯 facet + role 전파 명시 [채택]:** role=usage_cd 값(표지.02/내지.01/면지.03). RedPrinting `inner_pdt_*` 평행 스키마 = usage 슬롯의 *물리 구현*. PR이 추가한 것 = usage_cd가 도수(#6/기초코드)·가격(#11)·평량제약(#5)으로 *전파*됨을 입증 → 메타모델 #1·#6·#11에 "usage_cd role 전파" 명시(신축 아님).
- **근거:** `entity-semantic-model.md:23` "material + **usage_cd 슬롯**(.01내지/.02표지/.03면지/.07공통)" USAGE 7종 = 도메인 1급 확정. `:118-124` A 통합=내지/표지 단일행·B 셋트=표지/면지 반제품, **자재 권위=parent+usage_cd**. → 표지/내지 분리는 후니가 이미 usage_cd로 담는 구조. RP `inner_pdt_*`=그 RP판 구현. distinct 거부 정당.
- **메타모델 해소:** ✅ usage_cd 슬롯 facet 확정 + role 전파(자재→도수→가격→평량) 명시 격상. #1·#6·#11·#13(평량제약)에 반영.

## P-3. 페이지수(INN_PAGE)가 옵션인가 차원인가 — 수량모델#10 슬롯 + 제약#5(=후니 page_rule 엔티티) [facet → 신축 거부]

- **판정:** **수량모델(#10) "내지 페이지수" 슬롯 + 제약(#5 min/max/step) facet (distinct 거부). = 후니 `page_rule` 엔티티(page_min/max/incr) 정확 매핑.** TP T-C(캘린더 월수)와 *같은 필드·다른 의미*가 합류 — 책자=대수 페이지·달력=월수, 둘 다 page_rule 수량성 입력.
- **근거:**
  - reverse §0.2 INN_PAGE(MIN 10~MAX 300·STEP 1·DFT 30) + 부수(PRN_CNT) 직교, 가격 선형가산(Δ1,120/page 실측). = ORD_CNT/PRN_CNT/bundle_qty와 나란한 *또 다른 수량성 슬롯*(평면화 금지).
  - **★후니 도메인 정확 매핑:** `entity-semantic-model.md:29` "**page_rule**(`_page_rules`) 페이지 규칙(내지 min/max/증가)·책자·노트 내지 전용·떡제본/낱장엔 무의미(잡음 주의)". → INN_PAGE = page_rule 엔티티(min/max/incr)의 RP 표현. 수량모델#10의 슬롯이자 후니 별 엔티티(page_rule)로 구현됨 = TP T-C 판정 재확인 + 후니 그릇 정밀화.
- **메타모델 해소:** 🟡 부분 — 수량모델#10 슬롯 + page_rule 엔티티 귀속 확정. **검증 필요분: INN_PAGE↔가격 결합(책자 book2025 페이지선형 실측 O, 토너/인디고 차이 unobserved) → gap/validation.** TP T-7과 합류 완료.

## P-4. 제본방식·인쇄방식·도수의 상품분기 vs 옵션화 — 인쇄방식=#12·제본방식=#2·도수=#6 + "공정방식=상품분기" 정책패턴 [facet/정책 → 신축 거부]

- **판정:** **세 축으로 분배 (distinct 거부): 인쇄방식=인쇄방식레시피(#12·D-7)·제본방식=공정(#2 제본 그룹)·도수=기초코드(#6).** "윤전/토너 × 무선/스프링/트윈링/스테플러/실제본 × 컬러/흑백 매트릭스를 개별 pdtCode로 펼침"은 **메타모델 판정 아닌 후니 카탈로그 정책 결정**(GS G-2 코스터 6 pdtCode·TP T-4 "디자인X"와 동류 — "공정방식이 상품을 가른다"는 반복 정책패턴).
- **양면 트레이드오프(침묵 선택 금지):**
  - **(가) RedPrinting 답습 — 상품(pdtCode) 분리(19상품 유지):** 찬성=RP 검증 모델·인쇄방식이 자재(YWM)·최소수량·가격모델 동반결정(P-7)→단순옵션화 위험. 반대=카탈로그 폭증(19 책자)·방식 추가 시 신상품.
  - **(나) 옵션화 — 한 "책자" + 인쇄방식/제본방식/도수 차원:** 찬성=카탈로그 축소·관리용이. 반대=인쇄방식이 자재풀·가격엔진 게이팅(P-7·#12)이라 옵션 캐스케이드 복잡·방식별 가격모델 분기.
  - **권고:** GS G-2 하이브리드 동형 — 도수(컬러/흑백)=옵션화(자재풀 동일), 인쇄방식(윤전/토너/인디고)=별 pdtCode(자재풀·가격엔진 다름·#12 게이팅), 제본방식=옵션화 또는 별 pdtCode(PCS·자재 캐스케이드 정도 따라).
- **근거:** 인쇄방식=#12(D-7 게이팅 lifecycle 이미 distinct). 제본방식=공정#2(GS 제본 그룹 확장 이미 등재·RIN/STA + PER_DFT 무선). 도수=기초코드#6(SID_S/SID_D·INN_CLR=1 흑백). 셋 다 기존 축. "상품분기 vs 옵션화"는 메타모델이 *양쪽 표현 가능*(GS G-2·TP T-4와 동일 정책결정).
- **메타모델 해소:** ✅ 세 축 분배 + 정책패턴(공정방식=상품분기) 기록. **분리vs옵션화 선택 → gap/실무 정책.**

## P-5. 면지(END_PAP)의 자재+공정 BUNDLE — 자재#1(컬러지)+공정#2(삽입) bundle facet [facet → 신축 거부]

- **판정:** **자재 축(#1 컬러지 + usage_cd .03면지) + 공정 축(#2 삽입) bundle facet (distinct 거부).** GS 제본 bundle(링=자재+꿰기=공정)·아일렛(금속링+타공)·TP T-6 STA_CLD(쫄대=봉+제본) 동형 — "한 옵션=자재+공정 BUNDLE" 케이스 추가.
- **근거:** reverse §2 END_PAP 10색 "선택 컬러로 양면인쇄된 면지 삽입"(NOTICE). 색=자재(컬러지·usage_cd .03면지·`entity-semantic-model.md:23` USAGE .03면지 정합)·삽입=공정(#2). 메모리 `dbmap-option-material-process-bundle`(아일렛 동형) + D-2 "공정의 자재소비(SUB_MTRL_YN/consumes FK)"가 이미 담음.
- **메타모델 해소:** ✅ 기존 자재공정 bundle(D-2·#1 usage.03/#2)로 흡수. 신축 불요.

## P-6. 규격 인쇄물 vs 면적 산정물 경계 — 가격기여역할#11(pricing_model 라우팅) + 사이즈#13(프리셋+자유) facet [facet → 신축 거부]

- **판정:** **가격기여 역할 축(#11)의 pricing_model 라우팅 facet + 사이즈#13(프리셋+nonspec) (distinct 거부).** 포스터(digital_price·좌표→자유사이즈)와 BN 현수막(면적매트릭스·좌표→룩업)이 *같은 좌표 입력(CUT_WDT/HGH)·다른 가격엔진* = pricing_model enum 확장(면적형 BN / digital_price 규격자유 PR / tmpl·vTmpl·tiered GS).
- **근거:** reverse §0.5·§3 포스터 `price_gbn=digital_price`·`NO_STD_ABL_YN=N`(비규격 가능)·A2/A3/A4/B3/B4 프리셋 + MIN/MAX_CUT 자유입력. BN=`real_price` 면적매트릭스. → 사이즈 차원(#13)은 같은 입력(좌표)이나 **price_gbn이 가격엔진을 라우팅**(#11). 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형) + `dbmap-digitalprint-atomic-formula-unbuilt`(digital 원자합산형) 정합. pricing_model 5종으로 확장(면적/digital/tmpl/vTmpl/tiered).
- **메타모델 해소:** ✅ #11 pricing_model에 digital_price(규격/자유 좌표→원자합산) 라우팅 추가 + 사이즈#13(프리셋+자유 동일·가격엔진만 분기) 명시. 신축 불요.

## P-7. 인쇄방식 종속 자재(윤전전용지)의 모델링 — 인쇄방식레시피#12 → 자재#1 "자재풀 게이팅" 관계 facet(★관계 강화) [facet → 신축 거부]

- **판정:** **인쇄방식 레시피 축(#12)의 Material 관계 강화 (distinct 거부).** 윤전전용 백색모조(PTT=YWM·RXYWM080)는 *인쇄방식(윤전)에서만 쓰는 자재* → #12가 자재코드에 *인코딩*될 뿐 아니라 **가능 자재풀을 게이팅**(윤전→YWM pool·토너/인디고→다른 pool)하는 새 관계 간선. 자재 자체는 #1, 종속관계는 #12 → 신축 아님.
- **근거:** reverse §2·§0.4 내지 윤전전용지(YWM)·P-7. #12 D-7이 이미 "PrintMethod → Material(자재 facet 인코딩)" 보유 — PR이 이를 *gates-material-pool*(인쇄방식이 가능 자재 부분집합 결정)로 강화. process-recipe-tree §1 "1상품=1인쇄방식이 가능 공정 부분집합 결정"의 *자재판*(가능 자재 부분집합). 토너/인디고 책자 내지 자재풀 차이는 unobserved.
- **메타모델 해소:** ✅ #12에 "PrintMethod gates Material pool" 관계 간선 추가. **검증 필요분: 토너/인디고/리소 책자 자재풀(unobserved) → gap/validation.**

## P-8. 용도별 책자의 분류 단위 — 카테고리#7 태그(또는 마케팅 라벨) [facet/정책 → 신축 거부]

- **판정:** **카테고리 축(#7) 태그 facet (distinct 거부) — 또는 마케팅 표시 라벨(메타모델 비귀속).** PRBKPSN(독립출판)·PRBKCTL(브로셔)·PRBKPRP(보고서)·PRBKTXB(교재)·PRBKZIN(잡지)·PRBKPOL(작품집)이 §2 책자 본체 동일·용도 라벨만 다름 → 용도=카테고리 노드/태그(기능 분류) 또는 마케팅 라벨. GS G-2·TP T-4·P-4와 동류 "상품 vs 분류" 정책결정.
- **근거:** reverse §4-D 6상품 §2 책자 본체(제본/표지내지/페이지) 동일·용도만 차이·옵션 트리 공유 추정. RP=별 pdtCode(마케팅 진입점). 용도는 본체 모델을 안 바꿈(생산형태·자재·공정·페이지 동일) → 카테고리 태그(#7 기능 트리) 또는 표시 라벨(note/tags 쉬운 한국어, 메모리 round-15 "실무진 표시 필드=쉬운 한국어 라벨"). distinct 아님.
- **메타모델 해소:** ✅ 카테고리#7 태그/마케팅 라벨 귀속. **상품분리vs태그 선택 → gap/실무 정책(P-4와 동일).**

## P-9. 스코딕스(Scodix)·레이저커팅 특수 후가공의 버킷 — 공정#2 멤버 (+레이저커팅 칼틀=사이즈#13) [facet → 신축 거부]

- **판정:** **공정 축(#2)의 새 *멤버*(family) facet (distinct 거부).** 스코딕스(입체 UV 엠보·PRCASCO)=공정#2(특수인쇄·UV family)·레이저커팅(PRCACUT)=공정#2(특수재단) + 칼틀 형상=사이즈#13(THO_CUT 형상↔칼틀 1:1·GS 동형). TP T-E(박·형압=공정#2)·박(FOI) 동형 — 새 *멤버*이지 새 *축* 아님.
- **근거:** reverse §4-B·P-9. 스코딕스=입체 UV(UV 변형=공정파라미터#9·PROC_000002 family·메모리 round-22 "UV=공정param" 정합)·레이저커팅=완칼/도무송 동계(공정#2 + 칼틀 사이즈#13·메모리 round-3 "도무송 형상=size 칼틀 1:1"). 합지(BON_PAP)=공정#2(접합)+자재 2종 bundle(P-5 동형). 전부 기존 공정 축 멤버.
- **메타모델 해소:** ✅ 공정#2 멤버(스코딕스 입체UV·레이저커팅·합지) 등재 + 레이저커팅 칼틀=#13. **검증 필요분: 스코딕스 패턴·박색(FOI)·레이저커팅 칼틀값(unobserved) → gap/validation.**

---

## PR 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| P-1 접지(FLD_DFT) | 공정#2 family + 파라미터#9 + 제약#5 | 면수=파생값(축 아님)·접지↔오시 cascade | facet(거부) | #2·#9·#5 | 리플렛 접지강제·면수cascade → gap |
| P-2 표지/내지 역할 자재 | **자재#1 usage_cd 슬롯** | role 전파(자재→도수→가격→평량) 격상 | **facet(거부)** ★ | #1·#6·#11·#13 | (해소·역할전파 명시) |
| P-3 페이지수 INN_PAGE | 수량#10 슬롯 + 제약#5 = page_rule | TP T-C 합류·후니 page_rule 엔티티 정밀 | facet(거부) | #10·#5 | INN_PAGE↔가격 → gap |
| P-4 제본/인쇄방식/도수 분기 | 인쇄방식#12·공정#2·기초코드#6 | 공정방식=상품분기 정책패턴 | facet/정책 ★ | #12·#2·#6 | 분리vs옵션화 → gap/실무 |
| P-5 면지 END_PAP bundle | 자재#1(usage.03)+공정#2 | 컬러지+삽입 bundle | facet(거부) | #1·#2 | (해소·검증불요) |
| P-6 규격 vs 면적 경계 | 가격#11 라우팅 + 사이즈#13 | 같은좌표·다른엔진(digital/면적) | facet(거부) | #11·#13 | (해소·pricing_model 5종) |
| P-7 인쇄방식 종속 자재 | 인쇄방식#12 → 자재#1 게이팅 | 자재풀 게이팅 관계 강화 | facet(거부) | #12 | 토너/인디고 자재풀 → gap |
| P-8 용도별 책자 분류 | 카테고리#7 태그/마케팅 라벨 | 본체 불변·용도 라벨만 | facet/정책 | #7 | 상품분리vs태그 → gap/실무 |
| P-9 스코딕스/레이저커팅 | 공정#2 멤버 (+칼틀 사이즈#13) | 새 멤버 family·축 아님 | facet(거부) | #2·#13 | 패턴/칼틀값 → gap |

**PR 강제 분류 회피(SKILL §3·§5):** **distinct 승급 0건.** 9 fragment 전부 기존 16축의 facet/family/cascade/정책으로 흡수 — *오버피팅 회피의 정직한 결과이자 16축 포화 입증*(4번째 카테고리가 새 관리축 0 도입). ★P-2는 침묵 선택 거부하고 "역할 차원 신축 vs usage_cd 전파 facet" 트레이드오프 펼친 뒤 facet(usage_cd 전파 격상). P-4/P-8은 메타모델 판정 거부하고 후니 카탈로그 정책으로 라우팅(GS G-2·TP T-4 동류).
**PR이 더한 것(축 신설 아닌 *강화*):** ① 공정#2 "접지(folding)" family + 접지↔오시 cascade(평면 종이 면가공·BN/GS/TP 미발굴 family) ② 자재#1 usage_cd "역할 전파"(태그→자재/도수/가격/평량 전파 격상) ③ page_rule 엔티티 정밀(INN_PAGE=수량#10 슬롯+후니 별 엔티티) ④ 인쇄방식#12 "자재풀 게이팅" 관계 간선 ⑤ 가격#11 digital_price 라우팅(pricing_model 5종) ⑥ 공정#2 멤버(스코딕스 입체UV·레이저커팅·합지).
**검증 라우팅 요약:** 메타모델 해소 ✅ = P-2·P-4·P-5·P-6·P-8 / 부분 🟡 = P-1·P-3·P-7·P-9(unobserved 잔존 → gap/validation). 라이브/엑셀 검증 필요분 = 리플렛 접지강제·면수cascade(P-1)·INN_PAGE↔가격(P-3)·토너/인디고 자재풀(P-7)·스코딕스 패턴/박색/칼틀값(P-9).

---

# ST(스티커) fragment 판정 (v5.0 — 형상·칼선·재단입자·점착소재·인쇄방식) ★16축 포화 붕괴

> `categories/ST/reverse.md` ## Ambiguous fragments S-1~S-10 판정. **5 상품군(BN 면적·GS 완제/입체·TP 디자인입력·PR 다면/제본/접지·ST 형상/칼선/점착)** 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): ST 한 군만의 특이는 facet 강등. distinct 승급 = 5 상품군을 견디는 고유 lifecycle/governing + 후니 도메인 동형 보유 시만.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(G-SK-2 형상 size축 drop·variant 분해·material 두께/usage),pdf-domain-knowledge.md(반칼 PROC_054·완칼 053·스티커완칼 055·도무송·Case2 스티커 레시피·UV평판),db-domain-structure-live.md(공정 멤버 트리·가변텍스트/이미지)}` 실측. **★domain-researcher 신규 호출 불요** — 칼선(반칼/완칼/도무송)·인쇄방식(UV/DTF)·점착 의미가 후니 KB에 확정 존재(추정 0).
> **★ST 핵심 판정: distinct 신규 축 1건(형상 #17) = 16축 포화 붕괴.** PR(v4.0)이 distinct 0으로 16축 포화를 입증했으나 ST가 그 포화를 *정직하게 깸* — 5번째 카테고리가 형상(shape) 1종 도입. 오버피팅이 아니라 *사이즈축이 형상을 1:1 칼틀로 흡수해온 전제가 ST 전용 슬롯·1:多로 깨진* 증거 강제 결과. 나머지 9 fragment(S-2~S-10)는 기존 17축의 facet/family/cascade/정책. **★4 distinct 후보(directive) 적대 판정: ① 형상=distinct(#17) · ② 칼선=공정#2 facet · ③ 재단입자=공정#2 facet · ④ 점착=자재#1 facet.**

## S-1. 형상(shape_info)의 인코딩 단위 — 형상 축 [distinct → D-12 / #17] ★directive #1·포화 최초 붕괴

- **판정:** **형상 축(Shape) = distinct (D-12·#17).** `option_info.shape_info`(SQ/CL/EL/RC/FR)가 사이즈와 *분리된 전용 enum 슬롯*으로, 사이즈축(#13)이 형상을 *왜곡 없이 못 담음* → 16축 포화 붕괴.
- **★적대 판정(distinct 핵심·사이즈축 흡수 반론 검토):** 기존 메타모델은 형상을 *사이즈에 흡수*해왔다 — 어깨띠(A-3 "폭좁고 김"=사이즈), GS THO_CUT(하트/여권=칼틀↔사이즈 1:1), TP 티켓 M/I/보딩(T-D), PR 카드형. **이 흡수의 전제 = "형상=사이즈 프리셋 1:1"**. ST가 이 전제를 깬다: ① 전용 `shape_info` 슬롯(reverse §0.1·§1·§2 실측) ② **형상↔사이즈 1:多** — CL 원형 1형상 ↔ THO_DFT/CL001~CL010(10X10~100X100) + CLFRE 칼틀 11종, RC 라운드 ↔ RC001~RC025 25종(reverse §0.2) ③ STDCFBR가 *5형상 superset*을 한 상품에 담음(형상=사이즈면 한 상품에 5사이즈군 공존 불가). 사이즈축으로 형상 표현 시 "원형이라는 사실"을 매 사이즈 프리셋에 중복 인코딩(정규화 붕괴) → 형상은 사이즈의 *상위 분류축*.
- **근거(후니 KB ★결정적):** `entity-semantic-model.md:39` **"size축에 형상 enum drop(sticker G-SK-2): 도형/치수 enum(원형 25~90mm)이 *어느 축에도 없음*"** — 후니 자신이 형상 enum 미수용을 결함으로 명시 = distinctness test §3(왜곡 없이 못 담음) 충족. `:22` size="재단치수(치수)"이지 형상(원/사각) 아님.
- **★이전 흡수 판정 번복 아님:** BN/GS/TP/PR은 진짜 형상=사이즈 1:1(형상이 사이즈 프리셋 1개와 동치)이라 사이즈 흡수가 정당했고, ST만 1:多 분리가 *명시 슬롯으로* 드러나 distinct 승격. **[HARD] 형상축은 1:1이면 사이즈 흡수·1:多면 별 분류 슬롯**(BN/GS/TP/PR 사이즈 프리셋 유지·형상축 강제 금지=오모델 회피).
- **메타모델 해소:** ✅ 축 정초 완료(dictionary #17·D-12). **그릇 후보(형상 컬럼 vs 별 테이블 vs 칼틀 게이팅 엔티티)·후니 t_* 형상 그릇 유무·형상↔칼틀(완칼 PROC_053 `모양`·반칼 PROC_054 `모양`) 연결 → gap/vessel 단계**(라이브 information_schema에서 shape 컬럼 확인·단 1:1 흡수 카테고리는 size 유지).

## S-2. 칼선의 두 메커니즘(THO_GRA vs THO_DFT) — 공정#2 family + 사이즈#13(프리셋칼틀) [facet → 신축 거부]

- **판정:** **공정 축(#2) "모양커팅" family의 두 모드 facet (distinct 거부).** THO_GRA(자유칼선=디자인 외곽 도무송)·THO_DFT(형상별 프리셋 칼틀 enum: 원형 CL001~010·라운드 RC001~025)는 *같은 모양커팅 공정의 두 메커니즘*이지 별 축 아님. 프리셋칼틀(THO_DFT)이 사이즈를 겸함 = 공정#2 + 사이즈#13(형상#17이 칼틀 enum 게이팅).
- **근거(후니 KB ★결정적):** `pdf-domain-knowledge.md:113-115` 완칼(PROC_000053 종이+후지)·반칼(PROC_000054 종이만 `모양`)·스티커완칼(PROC_000055 `조각수`)·**도무송("칼선 자유모형 컷팅·완칼/반칼 계열로 추정")** 이 *전부 공정 멤버*. → THO_GRA(자유=도무송)·THO_DFT(프리셋=정형 칼틀)는 모양커팅 공정의 두 모드. PR THO_GRA(1종)·GS THO_CUT·레이저커팅(P-9) 합류 — ST가 칼틀 enum(원형 11·라운드 25)으로 가장 깊으나 *깊이는 멤버 수이지 새 축 아님*.
- **메타모델 해소:** ✅ 공정#2 family(THO_GRA/THO_DFT 두 모드) + 프리셋칼틀=사이즈#13 + 형상#17 게이팅 확정. **검증 필요분: EL 타원 칼틀 enum(unobserved·CL/RC 실측 동형 추정) → gap/validation.**

## S-3. 재단 입자(반칼/완칼/낱장)의 버킷 — 공정#2 멤버 + 배치 facet [facet → 신축 거부] ★directive #2

- **판정:** **공정 축(#2)의 재단 멤버 facet (distinct 거부).** `CUT_DFT` DFXXX 묶음재단(반칼시트=배치 후 kiss-cut으로 떼어씀)·DFITM 개별재단(낱장 완칼 분리)은 *재단 공정의 분기 멤버*. "재단 입자"가 별 축이 아님 — 후니가 이미 PROC_053/054/055로 1급 공정 멤버화.
- **근거(후니 KB ★결정적):** `pdf-domain-knowledge.md:71` Case2 스티커 레시피 "디지털출력 → (코팅) → **반칼커팅/완칼커팅** → 재단 → 1차포장" = 반칼/완칼이 *재단 공정의 분기 멤버*. `:113-114` 반칼=PROC_000054(종이만·스티커)·완칼=PROC_000053(종이+후지). 상품명 "사각반칼"의 "반칼"=묶음재단(DFXXX) 기본값. → 재단입자=공정#2 멤버(반칼=PROC_054·완칼=PROC_053) + (시트 배치=임포지션 facet). **★별 "재단입자 축" 거부:** GS 완칼 THO_CUT과 같은 "재단/분리 입자" 공정 family로 통합·신축은 공정 멤버 중복.
- **메타모델 해소:** ✅ 공정#2 멤버(반칼/완칼/스티커완칼) + GS THO_CUT 합류 확정. 검증 불요(도메인 KB 결정적).

## S-4. 점착/내후성의 자재모델 차원 — 자재#1 합성 차원(adhesion/weatherability) [facet → 신축 거부] ★directive #3·핵심 의사결정

- **판정:** **자재 축(#1)의 합성 차원 facet (distinct 거부). 단 [중요] 자재 합성코드에 점착강도/내후등급 분해축 추가 명시.** 강접/리무버블/옥외/저온/자석/메탈/한지는 *자재 합성코드의 추가 분해 차원*이지 별 자재계열/축 아님.
- **★양면 트레이드오프(침묵 선택 금지):**
  - **(가) 별 "점착 자재계열" 축 또는 별 자재 enum 신설:** 찬성=점착특화 상품(STRMDFT 리무버블·STOTDFT 옥외·STMADFT 자석·STLTDFT 저온)이 *별 pdtCode로 분리*돼 있어 별 계열로 보임. 반대=점착성은 *소재의 접착면 속성*이지 별 소재가 아님(같은 유포지가 일반/리무버블 양쪽)·신축 시 자재축과 1:1 중복.
  - **(나) 자재#1 합성 차원(adhesion_grade·weather_grade) 추가 [채택]:** 점착/내후 = `{ptt, wgt, clr, adhesion_grade, weather_grade}` 합성 분해축. `entity-semantic-model.md:51-53` "색상 variant→material·두께 variant→material(별도 mat_cd)" 원칙과 동형 — 점착강도/내후등급도 material 합성축. 점착특화 상품 분리는 GS 코스터 6 pdtCode(G-2)·PR 인쇄방식(P-4)와 동류 *카탈로그 정책*(상품분기 vs variant·후니 정책 결정).
- **근거:** STTHUSR 26소재 enum에 일반/초강접/리무버블/유포옥외/메탈/한지 spectrum이 *한 상품 안에 공존*(self-contained variant) ↔ 동시에 점착특화 상품으로도 분리(reverse §0.4). 후니 자재모델(`entity-semantic-model.md:22` material = 종이/소재/부속 + usage_cd + 두께)에 *점착/내후 차원 부재* = ST가 드러낸 자재 합성 갭. GS 본체소재·PR 방수/점착포스터 합류.
- **★경계(HARD):** 점착=자재 속성(접착면), 자석/메탈 본체=자재 PTT 소재, **단 스크래치층(STSKDFT 은박)·박색(STFODFT FOI)·형압(STEMDFT EMB)=공정#2**(소재 위 후공정·자재 아님). 3자 구분(소재 PTT / 점착 합성 차원 / 표면 후공정).
- **메타모델 해소:** ✅ 자재#1 합성 차원(adhesion_grade/weather_grade) 추가 명시. **점착특화 상품분리 vs variant 선택 → gap/실무 정책(GS G-2 하이브리드 동형). 자석/오토바이PVC 자재코드 unobserved → gap/validation.**

## S-5. 인쇄방식(일반/UV/DTF/후지)의 분기 단위 — 인쇄방식레시피#12 (PR P-4/P-7 합류) [facet → 신축 거부]

- **판정:** **인쇄방식 레시피 축(#12·D-7) facet (distinct 거부) — PR 윤전/토너/인디고(P-4/P-7)와 횡단 합류.** ST pdtCode prefix(일반 STTH*/STCU*·UV STPAU*·DTF STPAD*·후지 STBP*)가 인쇄방식을 인코딩하며 자재(DTF=DTF전용필름)·도수노출(DTF=숨김)·화이트강제(DTF ESN=Y)·가격엔진(DTF=vTmpl)을 동반결정 = PR 윤전→YWM 자재풀 게이팅(P-7)의 ST판.
- **근거:** reverse §0.5·§3 STPADPN/STPADNM 실측(vDigital_item/vTmpl_price·PXPUF003 DTF필름·dosuView=N·PRT_WHT ESN=Y). "인쇄방식=상품분기 + 자재/도수/가격 게이팅"은 PR(P-4)·ST(S-5) 두 카테고리 횡단 패턴 — #12가 이미 담음. 후니 PROC_000002 UV(`db-domain-structure-live.md:159` `변형` enum)·DTF/후지는 도메인 인쇄방식 enum 확장(갭분석가). UV가 별 인쇄방식(STPAU*)이자 PROC_000002 변형 — 후니 인쇄방식 트리 매핑 검토.
- **메타모델 해소:** ✅ #12 인쇄방식레시피 귀속 + PR 합류 확정. **검증 필요분: UV(STPAU*) 가격엔진/자재·후지(STBP*) 상세 unobserved → gap/validation.**

## S-6. 판(板) vs die-cut vs 정가 가격엔진 경계 — 가격기여역할#11 라우팅 (PR P-6·GS G-7 합류) [facet → 신축 거부]

- **판정:** **가격기여 역할 축(#11)의 pricing_model 라우팅 facet (distinct 거부).** die-cut(자유사이즈·칼틀·`digital_price` 산정형)·판(고정 판규격·장단위·`vTmpl_price` 템플릿형)·정가(STPADIY `tmpl_price`) 3엔진이 같은 ST 안에서 분기 = pricing_model 기존 6종(면적/digital/tmpl/vTmpl/tiered/book2025)으로 *전부 흡수*. price_gbn=라우팅 키·형태가 분기.
- **근거:** reverse §0.6·§3 STPADPN vTmpl_price(판 140X200/A4·장단위) vs STCUXXX digital_price(좌표+칼틀). PR P-6(규격 digital vs 면적매트릭스)·GS G-7(tmpl/vTmpl/tiered) 합류. die-cut↔판 차이는 사이즈 모드(#13 자유/고정)와 연동.
- **메타모델 해소:** ✅ #11 pricing_model 6종이 ST 3엔진 흡수 확정. 신축 불요.

## S-7. 화이트인쇄(PRT_WHT)의 강제성 분기 — 공정#2 + 제약#5 cascade [facet → 신축 거부]

- **판정:** **공정 축(#2 별색 family) + 제약(#5 force cascade) facet (distinct 거부).** 화이트언더베이스가 일반 스티커=선택(ESN_YN=N)·DTF=강제(ESN_YN=Y·천/유색 위 전사라 흰바탕 필수). TP T-E·PR 동형.
- **근거:** reverse §1·§3. `entity-semantic-model.md:88` PROC_000008 화이트="투명/홀로그램/메탈 소재의 베이스 레이어" = 공정#2 별색 family. 자재(투명PET)/인쇄방식(DTF)→화이트 force cascade(#5). **★별색=공정 경계(HARD)** — 화이트를 도수(별색)나 자재(백색잉크)로 오적재 금지(round-22 경계규칙).
- **메타모델 해소:** ✅ 공정#2 + 제약#5 귀속 확정(도메인 경계규칙). 검증 불요(도메인 사실).

## S-8. disable_pcs 227건 룰엔진의 그릇 — 제약#5 disable 정점 케이스 [facet → 신축 거부·정점]

- **판정:** **제약 축(#5)의 disable 논리유형 정점 케이스 facet (distinct 거부).** ST `pdt_disable_pcs_info` 227건(26소재 × 후가공 — 특수소재[PET/금속/한지]→코팅/박/형압/미싱/부분UV/접지 비활성)이 BN 강제(0건)·책자(24건)의 *정점*. 룰엔진 일반화 검증 케이스(신축 아님).
- **근거:** reverse §1 실측(형식 {MTRL_CD, PCS_CD, PCS_DTL_CD(null=그룹전체), NOTE}). 자재→공정 disable(D-3·BN force의 역방향). 후니 ① JSONLogic constraint ② 자재-후가공 호환매트릭스 중 어느 그릇? — 227건 규모가 룰엔진 일반화 검증.
- **메타모델 해소:** ✅ 제약#5 disable 귀속 확정. **그릇(JSONLogic vs 호환매트릭스) 선택 → gap/vessel(룰엔진 스케일 검증).**

## S-9. 넘버링(NUM_DFT)의 VDP 분류 — 공정#2 (+가변=VDP#16) [facet → 신축 거부·TP T-3 합류]

- **판정:** **공정 축(#2) facet (distinct 거부) — TP T-3 동형.** 넘버링(일련번호 가변 인쇄)이 ① 단순 공정(인쇄 후 넘버링기) ② VDP(가변데이터·#16 입력채널 데이터바인딩). `db-domain-structure-live.md:133` "가변텍스트/가변이미지" 공정 멤버 실재.
- **근거:** reverse §1·§2. 순차번호가 *디자인 데이터*(에디터 변수=VDP#16)인지 *생산 공정*(넘버링기=공정#2)인지가 귀속을 가름. TP 티켓 넘버링(T-3)과 합류.
- **메타모델 해소:** 🟡 부분 — 공정#2(+가변=VDP#16) 귀속. **넘버링 규칙(가변 증분·일련번호 시작/증가)은 unobserved → VDP vs 공정 귀속 라이브 확인 → gap/validation.**

## S-10. 완제SKU형 스티커(테이프/밴드/카드)의 분류 — 템플릿#4 + 생산형태#15 [facet → 신축 거부·GS 합류]

- **판정:** **템플릿/SKU 축(#4 완제 번들) + 생산형태(#15) facet (distinct 거부) — GS tmpl 완제SKU 합류.** 마스킹테이프(STTPMSK 롤·폭×길이)·일회용밴드(STTPBND)·카드스티커(STDRCAD)가 die-cut도 판도 아닌 *완제SKU형*(규격 완제). GS 완제 굿즈(tmpl_price)·봉투 완제SKU 동류.
- **근거:** reverse §4-F. 마스킹테이프/밴드 = 폭×길이 규격 완제(GS DIR_MTR 완제 본체 동형). 띠부(STTBDFT)=반칼시트 캐릭터 특화(공정#2 반칼). → 완제SKU=템플릿#4 + 생산형태#15(C 완제품), 반칼시트=공정#2.
- **메타모델 해소:** ✅ 템플릿#4 + 생산형태#15 귀속. **테이프/밴드 완제SKU 규격(롤 폭×길이·밴드) unobserved → gap/validation. ST 카테고리 소속 vs 가격모델 경계(완제SKU=tmpl)는 정책.**

---

## ST 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| S-1 형상 shape_info | **형상 축(#17)** | 사이즈와 분리·1:多·전용 슬롯·KB G-SK-2 | **distinct(★#17·포화붕괴)** ★ | D-12/#17 | 후니 형상 그릇 → gap/vessel |
| S-2 칼선 2메커니즘 | 공정#2 family + 사이즈#13 | 모양커팅 두 모드·도무송=공정·KB 결정적 | facet(거부) | #2·#13 | EL 칼틀 enum → gap |
| S-3 재단입자 반칼/완칼 | 공정#2 멤버 | 반칼PROC054·완칼053·스티커완칼055·KB 결정적 | facet(거부) | #2 | (해소·KB 결정적) |
| S-4 점착/내후 소재 | **자재#1 합성 차원** | adhesion/weather·색상/두께→material 동형 | **facet(거부)** ★ | #1 | 점착 자재코드 → gap |
| S-5 인쇄방식 UV/DTF/후지 | 인쇄방식레시피#12 | PR P-4/P-7 합류·자재/도수/가격 게이팅 | facet(거부) | #12 | UV 가격엔진·후지 → gap |
| S-6 판/die-cut/정가 가격엔진 | 가격#11 라우팅 | pricing_model 6종 흡수(PR P-6·GS G-7) | facet(거부) | #11 | (해소) |
| S-7 화이트강제 PRT_WHT | 공정#2 + 제약#5 | 별색=공정·DTF→화이트 force cascade | facet(거부) | #2·#5 | (해소·도메인사실) |
| S-8 disable_pcs 227건 | 제약#5 disable | BN/PR의 정점·룰엔진 일반화 검증 | facet(거부·정점) | #5 | 그릇(JSONLogic) → gap/vessel |
| S-9 넘버링 NUM_DFT | 공정#2 (+VDP#16) | TP T-3 동형·절취=공정·순차=VDP/공정 | facet(거부) | #2·#16 | 넘버링 규칙 → gap/validation |
| S-10 완제SKU 테이프/밴드 | 템플릿#4 + 생산형태#15 | GS tmpl 완제SKU 합류·die-cut/판 아님 | facet(거부) | #4·#15 | 완제SKU 규격 → gap |

**ST 강제 분류 회피(SKILL §3·§5):** **distinct 승급 1건(형상 #17) = 16축 포화 붕괴.** 9 fragment(S-2~S-10)는 기존 17축 facet/family/cascade/정책. ★directive 4 후보 적대 판정: ① 형상=★distinct(전용 슬롯·1:多·후니 KB G-SK-2 size축 미수용 확증) · ② 칼선=공정#2 facet(THO_GRA/THO_DFT 두 모드·KB PROC_053/054/055·도무송 결정적) · ③ 재단입자=공정#2 멤버(반칼/완칼=KB 1급 공정·신축 거부) · ④ 점착=자재#1 합성 차원(★침묵선택 거부하고 "별 자재계열 vs 자재 합성 차원" 트레이드오프 펼친 뒤 facet). **★포화 붕괴 정당성:** PR(distinct 0)이 입증한 16축 포화를 ST가 깬 것은 *오버피팅이 아니라 사이즈축이 형상을 1:1로만 흡수해온 전제가 ST의 전용 shape_info 슬롯·1:多로 깨진 증거 강제* — 모델은 카테고리 증거에 정직(포화도 진화도 증거가 결정). 단 1:1 흡수 카테고리(BN/GS/TP/PR)는 사이즈 프리셋 유지(형상축 강제 금지·오모델 회피).
**ST가 더한 것:** ① **★형상축(#17) distinct 신설** — 사이즈와 분리된 상위 분류축(전용 슬롯·1:多 칼틀·5형상 superset). ② **자재#1 점착/내후 합성 차원**(adhesion_grade/weather_grade — 색상/두께 동형). ③ **공정#2 칼선 family 강화**(THO_GRA 자유/THO_DFT 프리셋칼틀·반칼/완칼 재단 멤버·KB PROC_053/054/055). ④ **인쇄방식#12 횡단 합류**(ST UV/DTF/후지 + PR 윤전/토너). ⑤ **제약#5 disable 정점**(227건 룰엔진 일반화 검증). 새 *축* 1(형상) + 기존 축 강화.
**검증 라우팅 요약:** 메타모델 해소 ✅ = S-1(축정초)·S-3·S-6·S-7 / 부분 🟡 = S-2·S-4·S-5·S-8·S-9·S-10(unobserved 잔존 → gap/validation). 라이브/엑셀 검증 필요분 = 후니 형상 그릇 유무(S-1)·EL 칼틀(S-2)·점착 자재코드(S-4)·UV 가격엔진/후지(S-5)·disable 그릇(S-8)·넘버링 규칙(S-9)·완제SKU 규격(S-10).

---

# CL(의류·티셔츠·앞치마·가방류) fragment 판정 (v6.0 — 의류 variant·인쇄위치·인쇄방식·size×color 매트릭스) ★의류 variant #18 부결·재포화

> `categories/CL/reverse.md` ## Ambiguous fragments C-1~C-9 판정. **6 상품군(BN 면적·GS 완제/입체·TP 디자인입력·PR 다면/제본/접지·ST 형상/칼선/점착·CL 의류 variant)** 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): CL 한 군만의 특이는 facet 강등. distinct 승급 = 6 상품군을 견디는 고유 lifecycle/governing + 후니 도메인 동형 보유 시만.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(본체색→자재 CLR·variant 분해·material usage·생산방식 C-9),pdf-domain-knowledge.md(별색=공정),db-domain-structure-live.md}` + GS reverse(variant 3채널 G-4·완제 본체 G-1) 직접 대조. **★domain-researcher 신규 호출 불요** — 의류 인쇄방식(전사/실크/나염/DTF=공정#2/인쇄방식#12)·size×color SKU(=사이즈#13×색상자재CLR Cartesian)·Pantone(=별색=공정#2·round-22 경계)이 후니 KB+기존 17축에 확정 존재(추정 0).
> **★CL 핵심 판정: distinct 신규 축 0건(★의류 variant #18 부결) = 17축 재포화(PR 패턴 반복).** CL reverse가 "의류 variant=distinct #18"를 강하게 제기(§0.1~0.3·§15)했으나 9 fragment 전부 기존 17축 facet/matrix/family/정책으로 무손실 흡수. ★directive 최대 질문 적대 판정: **의류 variant = GS variant 축(G-4)의 2D 일반화 facet 클러스터**(자재#1 SKU matrix + 사이즈#13 + 색상자재CLR + 제약#5).

## C-1. apparel_info 전체 구조의 버킷 — 구현 컨테이너 뷰 [facet → 신축 거부·D-8 동형]

- **판정:** **구현 컨테이너 뷰 (distinct 거부) — D-8(UI 런타임=facet) 동근.** `apparel_info` 6키는 *새 1급 관리 그릇이 아니라* skinInfo에서 paper/size/dosu를 view_yn=N으로 숨기고 의류 옵션을 재담은 *구현 컨테이너*. 6키가 깔끔히 기존 축으로 분해: print_type→인쇄방식#12·print_area→공정#2(+#16 KOI)·apparel_color→색상(자재 CLR #1)·size_info→사이즈#13·size_color_info→자재#1 SKU matrix + 제약#5·pantone_color→별색 공정#2.
- **근거:** reverse §0.2 "범용 옵션 트리와 직교하게 담는다"는 *렌더 구조*이지 관리 축 아님. D-8 "같은 base-data를 다르게 렌더할 뿐 고유 관리 데이터 없음=facet" 동일 논리 — apparel_info는 같은 base-data(여러 기존 축)를 의류 전용 구조로 묶은 뷰. 컨테이너는 축이 아님.
- **메타모델 해소:** ✅ 6키 전부 기존 축 귀속(컨테이너 분해). **후니 흡수 시: apparel_info를 한 의류 테이블로 적재 금지 — 각 키를 해당 축(자재/사이즈/색/공정/제약)에 분해 적재 → gap/vessel(분해 매핑).**

## C-2. 의류 variant = distinct #18인가 GS variant facet인가 — GS variant 2D 일반화 facet 클러스터 [distinct #18 부결] ★최대 directive 의사결정

- **판정:** **facet — distinct #18 거부.** 의류 variant = GS variant 축(G-4)의 **2D 일반화 facet 클러스터**(자재#1 size×color SKU matrix + 사이즈#13 + 색상[자재 CLR] + 제약#5 셀가용성)·주 귀속=자재#1(G-1 본체 SKU 동형).
- **★양면 트레이드오프 펼침(침묵 선택 금지) — discovered-axes C-2 참조:**
  - **(가) distinct "의류 variant 축 #18" 신설:** 찬성=item_gbn=clothes2025 별 분기·apparel_info 전용 그릇·size×color 2D 매트릭스(GS 단일 DTL 초과)·Pantone 1124/위치6/방식3 의류 전용 차원군. 반대=★네 근거 전부 기존 축의 *표현/구현*으로 무손실 분해(distinct 요구 "기존 축이 왜곡 없이 못 담는 고유 lifecycle"이 없음).
  - **(나) facet 클러스터 — GS variant 2D 일반화 [채택]:** ① item_gbn=clothes2025=구현 discriminator(어느 가격 SP·옵션 skin 분기 키)·PR P-4·ST S-5·GS G-1 정책패턴 동형(명제#19·축 아님) ② apparel_info=구현 컨테이너 뷰(C-1·D-8 동형) ③ size×color matrix=사이즈#13×색상(자재 CLR·D-2) Cartesian + 셀→MTRL_COD(G-1 본체 SKU 라벨 융합 의류판) + 셀가용성=제약#5(ST disable 227=S-8 정점의 2D판) ④ Pantone=별색 공정#2(C-7).
- **★GS variant와의 관계(directive 핵심):** GS는 variant를 *1D-per-channel*(G-4: DTL코드/ATTB/CUT 3채널)로 해소, CL은 *2D 매트릭스*(size×color→단일 MTRL_COD)로 해소. **둘 다 같은 기존 축으로 분해되는 facet**이며, CL이 더한 것은 *2D cardinality + 셀별 가용성 정점*(새 관리 관심사 아님). 즉 의류 variant ⊃ GS variant 패턴의 2D 확장 — GS facet(G-4)의 일반화이지 별 축 아님.
- **★역방향 오류 점검(distinct를 facet으로 숨김):** size×color 셀가용성 매트릭스(227셀)가 유일 잔여 distinct 후보. ST S-8(disable 227=#5 정점·1D)과 동일 규모·패턴, 단 2D subject(사이즈×색 axis-pair) → 제약#5 match/exclude의 2D subject로 무손실 흡수. 기존 축이 *왜곡 없이* 담음 → facet 정당(숨김 아님).
- **★[HARD] G-1 동형 분해 요구:** MTRL_COD(SXSRT326)·PCS_DTL_NME("6.2oz 프리미엄 화이트 L")를 `{body_fabric/PTT, body_color/CLR, size/WGT}`로 분해(평면 SKU 라벨=의미축 drop·후니 본체소재 부재 결함의 의류판 정답).
- **메타모델 해소:** ✅ facet 클러스터 귀속 확정(#1 CL 확장·#13·#5). **후니 그릇: 의류 본체를 자재(size×color SKU matrix)·셀가용성(제약)으로 분해 적재 → gap/vessel(2D matrix 흡수 그릇).**

## C-3. size×color 매트릭스 = 어느 그릇 — 자재#1 SKU matrix + 제약#5 셀가용성 [facet → 신축 거부]

- **판정:** **자재 축(#1 size×color SKU matrix facet·G-1 본체 SKU 동형) + 제약(#5 2D 셀가용성 정점) facet (distinct 거부).** 사이즈×색 → 단일 MTRL_COD = 두 기존 축(사이즈#13 × 색상[자재 CLR])의 Cartesian product, 셀=자재 SKU(G-1 라벨 융합), 셀별 HIDE_YN=제약#5.
- **근거:** reverse §0.3 size_color_info 227셀(자체)/54셀(단체)·각 셀→MTRL_COD(S×블랙03→SXSRT103)·셀별 HIDE_YN/QUICK_ORD_YN. `entity-semantic-model.md` "색상 variant→material·사이즈 variant→size" 분리 원칙 = CL이 그 분리를 2D 매트릭스로 합일해 둠. GS G-1(완제 본체 라벨 융합)·G-4(variant 1D 채널)의 2D 일반화. 후니 굿즈 본체소재 부재(round-22 GPM)와 동형이나 2D 차원.
- **메타모델 해소:** ✅ 자재#1 SKU matrix + 제약#5 귀속 확정. ★[HARD] MTRL_COD 분해(평면 매트릭스 코드 금지). **후니 자재모델에 "사이즈×색 SKU 해소" 그릇(2D matrix→코드) → gap/vessel.**

## C-4. 인쇄위치(print_area) = 기초코드 vs 공정 vs 차원 — 공정#2 멀티슬롯 + #11 + #16 [facet → 신축 거부]

- **판정:** **공정 축(#2)의 위치별 인쇄 멀티슬롯 facet (distinct 거부) + 가격기여#11(위치별 가산) + 입력채널#16(KOI_NME 에디터 매핑).** print_area 6위치(PDT_WRK 6행 1:1)·다중선택·위치마다 PDT_WRK 항목 가산. = 공정#2 위치별 멤버의 멀티슬롯(GS 귀돌이 ROU_DFT 4슬롯·ROP 동형 "한 공정이 위치별 N PCS 항목 분리").
- **근거:** reverse §0.4 PDT_WRK 6행(CL011 좌측가슴·CL001 앞면…)·가격캡처 PDT_WRK/CL011 PRICE=3700(위치별 인쇄비). KOI_NME(leftchest/front)→에디터 캔버스 영역(입력채널#16 TP 합류). PR 다면(면분할)·GS PDT_WRK(본체조립)와 의미 다르나 *공정#2 멤버 멀티슬롯*이라는 점은 동일 family.
- **메타모델 해소:** ✅ 공정#2 멀티슬롯 + #11 + #16 귀속 확정. **검증 필요분: 다중선택 가격 합산 규칙(앞면+뒷면+소매 동시·위치별 단가 차이) unobserved → gap/validation.**

## C-5. 카테고리 내부 2모델(clothes2025 vs tmpl) — 생산형태#15 + item_gbn 구현 discriminator [facet → 신축 거부]

- **판정:** **생산형태 축(#15) + item_gbn 구현 discriminator(정책) facet (distinct 거부).** 같은 CL 카테고리에서 티셔츠=clothes2025(전용 의류 모델)·앞치마/가방=tmpl(굿즈형)은 *본체 정체가 가격/옵션 패러다임을 결정* = 생산형태#15 governing(C 완제품/입체 vs 의류 SKU). item_gbn은 *구현 discriminator*(어느 모델/SP를 쓸지 분기 키)이지 관리 축 아님.
- **근거:** reverse §0.1·§5. item_gbn=카테고리가 아니라 본체 정체로 결정 → 생산형태#15(⊥카테고리#7·D-9)가 이미 담음(같은 카테고리에 다른 생산형태 공존·노트 A/C 동형). item_gbn=clothes2025/tmpl 분기는 PR 인쇄방식 pdtCode(P-4)·GS DIR_MTR vs ORD_INFO(G-1) 구현 discriminator 동형.
- **메타모델 해소:** ✅ 생산형태#15 + item_gbn=discriminator 귀속 확정. TP HL트윈(다른 카테고리 분기)과 다른 "동일 카테고리 내 생산형태 분기"이나 #15가 담음.

## C-6. Pantone 1124 별색 라이브러리 vs ST/PR 별색 — 공정#2 별색 family + #6 도메인 [facet → 신축 거부] (※번호 정정: reverse C-6=인쇄방식, C-7=Pantone — 아래 C-6은 인쇄방식)

- **판정(reverse C-6=인쇄방식):** **인쇄방식 레시피 축(#12) facet (distinct 거부) — 상품내 옵션 인코딩(삼면 표현)·PR P-4/ST S-5 합류.** CL은 인쇄방식(PTP_DTF/DIR/SLK)을 *한 상품 안 ORD_INFO.PRINT_TYPE 차원*으로 둠(ST/PR=상품분기 pdtCode·BN=자재 facet과 다른 인코딩). #12가 (a)자재 facet (b)상품분기 (c)상품내 옵션 삼면 표현을 가짐 확정.
- **근거:** reverse §0.5 가격캡처 ORD_INFO.PRINT_TYPE(PTP_DTF→PTP_DIR)·apparel_info.print_type 3종. 의류 인쇄방식(실크=별색 spot·DTF=화이트언더베이스 동반)은 공정#2 별색/특수인쇄 family와도 연결(S-7 화이트강제 동형). 인쇄방식이 가능 자재풀(DTF→DTF전용·실크→Pantone 활성)·가격(DTF=DIR 동일 19900) 게이팅 = #12 lifecycle 유지.
- **메타모델 해소:** ✅ #12 귀속 + 삼면 표현 확정. **검증 필요분: 실크(SLK)·인쇄방식×위치 조합 가격 unobserved → gap/validation.**

## C-7. Pantone 1124 별색 = 의류 전용인가 — 공정#2 별색 family [facet → 신축 거부]

- **판정:** **공정 축(#2 별색 family) facet (distinct 거부) + 기초코드#6 도메인 규모.** `apparel_info.pantone_color` 1124(PANTONE C 전체)=실크인쇄(PTP_SLK) spot color. **별색=공정(round-22 경계규칙·`entity-semantic-model.md` PROC_000007·HARD)** — ST/PR 별색·후니 별색과 같은 공정#2 그릇. 규모(1124)는 기초코드#6 별색 도메인 거버넌스 관점(enum 규모 정점)이나 *축은 공정#2*. 의류 전용 별색 도메인 아님(전체 Pantone C).
- **근거:** reverse §0.2·§1. 별색=공정 경계(HARD·round-22)로 해소. ST 별색·PR 별색·후니 PROC_000007 별색 family 동일 그릇.
- **메타모델 해소:** ✅ 공정#2 별색 귀속 확정(도메인 경계규칙). 검증 불요(도메인 사실). 단 1124 규모는 #6 별색 도메인 enum 거버넌스(갭분석가 enum 그릇 확인).

## C-8. GBN(adult/child) 축 — 사이즈#13/기초코드#6 하위 속성 [facet → 신축 거부]

- **판정:** **사이즈 축(#13)/기초코드(#6)의 연령 분류 하위 속성 facet (distinct 거부).** `apparel_info.size_info`의 GBN(성인/아동)이 사이즈 enum에 연령 분류 부착 — CLSTSHS(자체)=adult만·CLTMSHS(단체티)=adult+child 활성. GBN=사이즈 enum 하위 속성(별 분류축 아님). 상품별 child 가용=제약#5.
- **근거:** reverse §2 size_info 9종(S~2XL adult + 120~150 child·단체티). GBN이 사이즈 코드의 속성(연령군)이지 독립 lifecycle 없음. 단체티만 child 활성=제약#5(상품별 가용).
- **메타모델 해소:** ✅ 사이즈#13/#6 하위 속성 + 제약#5(child 가용) 귀속 확정.

## C-9. CLST 가방/모자/에이프런(CLSTSAP/TOB/LUB/CAP) 모델 — 생산형태#15 + 카테고리#7 경계 [facet → 신축 거부]

- **판정:** **생산형태 축(#15·tmpl 굿즈형) + 카테고리(#7 경계) facet (distinct 거부).** CL 카테고리 안 비의류(가방/모자/에이프런=캔버스 본체+인쇄=CLAPDFT 굿즈형 동류·apparel_info 부재 추정)는 의류(clothes2025)와 다른 생산형태(#15 C 완제품·tmpl). 카테고리=기능 트리(CL)이나 본체 정체가 생산형태/그릇 결정 → 카테고리⊥생산형태(#15·D-9) 재확인·카테고리 경계 명시.
- **근거:** reverse §5·§14·§0.1. 캔버스 가방/모자/에이프런=tmpl 굿즈형(GS 완제 굿즈 동형·G-1). CL 카테고리 내 비의류 포함=카테고리는 기능 분류이나 생산형태가 본체 그릇 결정(item_gbn). **단 CLST 가방/모자 모델은 unobserved(apparel_info 부재 추정·미관측).**
- **메타모델 해소:** ✅ 생산형태#15 + 카테고리#7 경계 귀속. **검증 필요분: CLST 가방/모자/에이프런 굿즈형 확정(item_gbn·apparel_info 부재) unobserved → gap/validation.**

---

## CL 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| C-1 apparel_info 그릇 | 구현 컨테이너 뷰(D-8 동형) | 6키→기존 축 분해 | facet(거부) | C-1 | 분해 적재 → gap/vessel |
| C-2 의류 variant #18 | **자재#1+사이즈#13+색상CLR+제약#5 클러스터** | GS variant(G-4) 2D 일반화·item_gbn=정책·apparel_info=컨테이너 | **facet(거부·#18 부결)** ★ | C-2 | 2D matrix 흡수 그릇 → gap/vessel |
| C-3 size×color 매트릭스 | 자재#1 SKU matrix + 제약#5 | 사이즈×색 Cartesian·G-1 본체 SKU 동형·셀가용성#5 정점 | **facet(거부·HARD 분해)** ★ | C-3 | 분해 그릇 → gap/vessel |
| C-4 인쇄위치 print_area | 공정#2 멀티슬롯 + #11 + #16 | 위치별 PDT_WRK 가산·GS 귀돌이 4슬롯 동형 | facet(거부) | C-4 | 다중선택 합산 규칙 → gap |
| C-5 카테고리 내 2모델 | 생산형태#15 + item_gbn discriminator | 본체정체=생산형태·item_gbn=구현 | facet(거부) | C-5 | (해소·#15 담음) |
| C-6 인쇄방식 실크/전사/DTF | 인쇄방식레시피#12 | 상품내 옵션 인코딩(삼면 표현)·PR/ST 합류 | facet(거부) | C-6 | 실크·조합 가격 → gap |
| C-7 Pantone 1124 별색 | 공정#2 별색 family + #6 도메인 | 별색=공정(round-22)·1124=#6 규모 | facet(거부) | C-7 | (해소·도메인사실) |
| C-8 GBN adult/child | 사이즈#13/기초코드#6 하위 + 제약#5 | 연령 분류 속성·단체티만 child 활성 | facet(거부) | C-8 | (해소) |
| C-9 CLST 가방/모자 모델 | 생산형태#15 + 카테고리#7 경계 | 비의류=tmpl 굿즈형·카테고리 경계 | facet(거부) | C-9 | 굿즈형 확정 → gap/validation |

**CL 강제 분류 회피(SKILL §3·§5):** **distinct 승급 0건(★의류 variant #18 부결) = 17축 재포화(PR 패턴 반복).** 9 fragment 전부 기존 17축 facet/matrix/family/정책. ★directive 최대 질문 적대 판정: 의류 variant가 가장 distinct로 *보이는* 이유(전용 clothes2025 모델·전용 apparel_info 그릇·size×color 2D 매트릭스·Pantone 1124)가 전부 *구현 표현*(discriminator/컨테이너/Cartesian+셀가용성)이지 *관리 축*이 아님. **★C-2/C-3/C-4는 침묵선택 거부하고 "distinct #18 vs GS variant 2D 일반화 facet" 트레이드오프 펼친 뒤 facet.** 역방향 오류(distinct를 facet으로 숨김) 점검: size×color 셀가용성(227셀)이 유일 잔여 후보였으나 ST S-8(disable 227=#5 정점)과 동일 패턴으로 제약#5 무손실 흡수(2D subject)·숨김 아님.
**CL이 더한 것(축 신설 아닌 *강화* + 재포화):** ① **17축 재포화** — 6번째 카테고리 distinct 0(PR 4번째 distinct 0 패턴 반복·모델 안정성 재확인). ② 자재#1 size×color 2D SKU 매트릭스 facet(GS variant G-4 1D의 2D 일반화·G-1 본체 SKU 동형). ③ 제약#5 2D 셀가용성 정점(ST disable 227=S-8의 2D판). ④ 인쇄방식#12 "상품내 옵션" 인코딩 추가(양면→삼면 표현). ⑤ 공정#2 인쇄위치 멀티슬롯 facet(GS 귀돌이 동형). ⑥ 카테고리⊥생산형태(#15) 경계 재확인(CL 내 비의류).
**검증 라우팅 요약:** 메타모델 해소 ✅ = C-1·C-2·C-3·C-5·C-7·C-8 / 부분 🟡 = C-4·C-6·C-9(unobserved 잔존 → gap/validation). 라이브/엑셀 검증 필요분 = 다중선택 가격 합산(C-4)·실크/조합 가격(C-6)·CLST 가방/모자 굿즈형 확정(C-9) + 의류 본체 분해 흡수 그릇(C-2/C-3 → gap/vessel).

---

# AC(아크릴·키링·코롯토·명찰·등신대) fragment 판정 (v7.0 — 두께·소재variant·입체/스탠드·가공방식 그룹핑·부착물) ★가공방식 그룹핑(A-8) 적대 판정·재포화

> `categories/AC/reverse.md` ## Ambiguous fragments A-1~A-9 판정. **7 상품군(BN 면적·GS 완제/입체·TP 디자인입력·PR 다면/제본/접지·ST 형상/칼선/점착·CL 의류 variant·AC 아크릴 두께/입체/가공방식)** 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): AC 한 군만의 특이는 facet 강등. distinct 승급 = 7 상품군을 견디는 고유 lifecycle/governing + 후니 도메인 동형 보유 시만.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(두께=자재 식별자·variant 분해·material usage·합지/별색=공정),pdf-domain-knowledge.md(완칼/도무송·UV평판),db-domain-structure-live.md}` + **[huni-ref] `31_acrylic-price-link/{acrylic-chain-design,confirms-and-gaps}.md`**(후니 아크릴 두께/소재/가격 모델 직접 대조). **★domain-researcher 신규 호출 불요** — 두께(아크릴 mm=자재 식별자)·라미네이션(합지=공정#2)·표면효과(글리터/거울=자재 surface-finish·ST S-4 동형)·코롯토 입체(자립 블록=자재 두께)가 후니 KB+[huni-ref]+기존 17축에 확정 존재(추정 0).
> **★AC 핵심 판정: distinct 신규 축 0건(★가공방식 그룹핑 A-8 부결) = 17축 재포화(PR·CL 패턴 반복).** AC reverse가 "가공방식 그룹핑 슬롯(A-8)=distinct #18 강후보"를 제기했으나 9 fragment 전부 기존 17축 facet/family/cascade/정책으로 무손실 흡수. ★directive 4 관전 적대 판정: **두께=자재#1 WGT facet · 소재variant=자재#1 surface-finish facet · 입체/스탠드=분산 facet(Addon#8+자재#1+옵션#3) · 가공방식 그룹핑=공정#2(라미)+자재#1 합성+옵션#3 cascade facet.**

## A-1. 두께(3T/5T/8T)의 버킷 — 자재#1 WGT 차원 facet [distinct 거부] ★directive 최대 관전 1

- **판정:** **자재 축(#1)의 WGT 차원 facet (distinct #18 거부).** 두께(3T=D01·5T=D02·라미 L01~04)가 `pdt_mtrl_info` MTRL_CD의 WGT_CD 슬롯에 인코딩되어 widget select `material`에 "아크릴_3T/5T 투명"으로 노출(reverse §0.1 실측 6 mtrl). 두께=자재 식별자(별 두께축 아님)·dictionary #1 "두께=자재 식별자(아크릴 mm)" 이미 명시.
- **★WGT 슬롯 다의성 검토(directive 질문):** WGT 슬롯이 ① 평량(종이 g·BN/PR/GS-paper) ② 두께(아크릴 mm·AC) ③ (GS 장패드 4T) 다의 사용 = *자재 합성코드 WGT 차원의 정당한 다형성*(같은 슬롯·소재 도메인별 의미). distinct를 강요하면 자재가 종이/아크릴로 분열(같은 WGT 차원 2축). GS 텀블러 용량 DTL·CL 사이즈 MTRL_CD 첫자리(1xx=S)와 동류 "자재 합성코드의 도메인별 의미 슬롯" — facet 정당.
- **근거([huni-ref] ★동형 결정적):** `acrylic-chain-design.md:14·63·149` — 후니가 **투명3T/1.5T를 한 comp(`COMP_ACRYL_CLEAR3T`)의 `mat_cd` 차원으로 통합**(1.5T=MAT_000042·3T=MAT_000043·단가 1.5T=3T×0.8 정합). 즉 후니도 두께를 *별 축이 아니라 자재 차원(mat_cd 분기)*으로 모델 = AC WGT 슬롯과 정확히 동형. `confirms-and-gaps.md:65` "자재(투명3T/1.5T/미러/8T)" RTM 행이 두께를 자재축으로 분류. entity-semantic-model "두께 variant→material(별도 mat_cd)" 원칙 정합.
- **메타모델 해소:** ✅ 자재#1 WGT 차원 facet 확정. **검증 불요(도메인 사실·[huni-ref] 동형). 단 WGT 슬롯 다의성(평량 vs 두께)=후니 자재모델 그릇 검토 → gap/vessel(WGT 슬롯에 measure_type 구분 필요여부).**

## A-2. 아크릴 소재 variant(투명/홀로그램/글리터/거울/자개/렌티큘러/유색/파스텔)의 인코딩 단위 — 자재#1 surface-finish 합성 차원 facet [distinct 거부] ★directive 관전 3

- **판정:** **자재 축(#1)의 surface-finish/광학효과 합성 차원 facet (distinct 거부) — ST S-4 점착/내후 합성 차원과 동형.** 표면효과(글리터/거울/자개/홀로그램/렌티큘러/파스텔/유색)가 ① 자재행 PTT/라미 인코딩(ACTHDKY 6소재 enum·홀로그램 깨진유리/격자) ② 소재특화 pdtCode(ACTH*KY 9상품) 양면. = 자재 합성코드의 추가 분해축(별 축/별 자재계열 아님).
- **★양면 트레이드오프(거울 별 공식 검토):** 거울(MIRROR3T)이 [huni-ref] `acrylic-chain-design.md:19·50` **별 가격공식 `PRF_MIRROR_ACRYL`**(전면5도·단가체계 다름)을 가짐 → "단순 variant 아니라 별 계열" 가설. **그러나 별 공식=가격기여역할#11 라우팅**(소재계열별 가격엔진 분기·A-6)이지 *자재축의 별 분류*가 아님. 거울 본체 자체는 자재#1(미러 PTT·surface=mirror). 가격공식이 다른 것은 #11이 담음(투명=PRF_CLR_ACRYL·미러=PRF_MIRROR_ACRYL·코롯토=PRF_COROTTO 형태/소재별 가격엔진). → 자재 variant는 자재#1 surface-finish, 가격 분기는 #11 — 둘 다 기존 축.
- **근거:** ST S-4 "점착/내후=자재 합성 차원(adhesion_grade/weather_grade)·색상/두께→material 동형" 판정과 동근 — surface-finish(glitter/mirror/holographic/lenticular)도 material 합성 차원(`{ptt, wgt, clr, surface_finish}`). reverse §0.2·§4-A "ST 점착소재 spectrum 동형". [huni-ref] COMP_ACRYL_MIRROR3T(37행)·CLEAR3T가 *별 comp*인 것은 가격(#11)이지 자재 분류 아님.
- **메타모델 해소:** ✅ 자재#1 surface-finish 합성 차원 facet 확정(ST S-4 합류·자재모델에 `surface_finish` 분해축 추가). **검증 필요분: 소재특화 키링(글리터/거울/자개/유색/렌티큘러/파스텔) 자재코드·WGT·가격 unobserved(ACTHDKY 동형 추정·거울=[huni-ref] MIRROR3T 실재) → gap/validation. 거울 가격공식 라우팅=#11(A-6).**

## A-3. 입체/스탠드(3D)의 버킷 — 분산 facet(Addon#8 받침 + 자재#1 두께 + 옵션#3 양면 + 공정#2 입체조형) [distinct 거부] ★directive 최대 관전 2

- **판정:** **분산 facet — distinct "3D 형태 축 #18" 거부.** 입체성이 4방식으로 분산: ① **받침(ACPDSTD 12 SKU)=부속물 축#8**(평면을 세우는 별 완제 부속·D-1) ② **코롯토 두께블록(ACTHDCO)=자재#1 두께**(자립 8T급 블록·A-1) ③ **양면(ACTHBCO)=옵션#3 인쇄면**(print_data·A-5) ④ **입체조형(ACTHFCO)=공정#2**(다층/곡면 가공). 4방식 전부 기존 축으로 분해 — 별 3D축 신축은 4축 중복.
- **★적대 판정(생산형태#15·형태가공#14 반론 검토):**
  - **vs 생산형태#15(평면 vs 입체):** round-15 생산형태가 본체 모델링을 governing하나, AC 등신대 본체는 *여전히 평면 아크릴(PXACR016 3T)* + 별 받침 부자재(SUB_MTR 12 SKU). 즉 본체 정체가 "입체"로 *바뀌지 않음* — 받침이 평면을 *세울 뿐*. 생산형태는 본체가 자재행/완제SKU인지를 결정(C/A/B)인데 등신대는 평면 자재행 본체 + 부속물(받침)이지 별 생산형태가 아님. → 생산형태#15가 입체/스탠드를 담는 게 아님(받침=부속물#8이 담음).
  - **vs 본체 형태가공#14(평면→입체 생성):** GS 형태가공#14는 봉제/지퍼가 *본체 형태 자체를 생성*(파우치=가공 없으면 평면지·본체 부재). AC 받침은 본체(평면 아크릴)를 *생성하지 않음* — 본체는 받침 없이도 완성된 평면 아크릴(받침=세우는 부속·필수 ESN=Y이나 본체 생성 아님). 코롯토 두께블록은 자재#1 두께(8T)·입체조형(FCO)은 공정#2(곡면가공). → 형태가공#14도 아님(받침=부속물·블록=자재·조형=공정).
- **근거:** reverse §0.3·§3·§4-B. 받침=`SUB_MTR` 별 자재코드(SXAPR005~016)·ESN_YN=Y·QTY_INPUT_YN=Y·형상(원/타원/사각/육각)×크기(S/M/L) 12 SKU = Addon#8(D-1 거치대·우드봉·이젤 동형·롤업 size variant 동형). 코롯토=[huni-ref] `acrylic-chain-design.md:34·50` B06 6×6 면적매트릭스(30~80mm·`PRF_COROTTO_ACRYL`)=자재 두께블록 + 별 가격엔진(#11). 양면(BCO)=A-5 인쇄면. 입체조형(FCO)=공정#2(reverse §4-B unobs).
- **메타모델 해소:** ✅ 분산 facet 귀속 확정(받침=#8·두께=#1·양면=#3/A-5·조형=#2). **★받침이 부속물#8임 = AC가 BN 거치대(D-1)·GS 부속물 횡단 확장(부속물 카탈로그에 받침 추가). 검증 필요분: 코롯토 입체조형(FCO) 공정·두께블록(DCO 8T)·자립방식 unobserved → gap/validation.**

## A-4. 부착물(고리/받침/자석/핀)의 SUB_MTR vs WRK_MTR 2그룹 — 부속물#8 + 공정#2 부착 bundle facet [distinct 거부]

- **판정:** **부속물 축(#8 Addon) + 공정#2(부착/조립) bundle facet (distinct 거부) — D-1/D-2 동형·AC 부자재 정점.** `SUB_MTR`(고리 KR/CN/CR 80+·받침 AB 12)·`WRK_MTR`(명찰 뒷면 SXANB 옷핀/마그넷)가 두 PCS 그룹이나 *같은 "부속 부품 + 부착공정 BUNDLE"의 2변종*(SUB_MTR=빈/동반 자재코드·WRK_MTR=자재코드 동반). 메모리 "옵션=자재+공정 BUNDLE" 정점.
- **근거:** reverse §0.4·§1·§2·§3. 고리(KR001~040·CN009~030·CR015~029)가 **ST SUB_MTR_KR/CN/CR과 동일 코드체계 공유** = 굿즈/스티커/아크릴 횡단 *단일 부자재 카탈로그* 시사(후니 부자재 마스터 단일화). 받침=부속물#8(A-3·필수 ESN=Y)·고리=선택(ESN=N) = 부속물 필수성 차원(제약#5). 자석/핀(ACPDMGN/PIN)·그립톡(ACPDJOY)·펜토퍼(ACTHPEN)=부속물#8 + 부착 공정#2. 명찰 뒷면(WRK_MTR·SXANB001 옷핀/SXANB002 마그넷)=자재코드 동반 부착 bundle(D-2 consumes FK). 통자석(ACPDAMG)=자성시트 합지(자재#1 PTT + 공정#2 합지·ST STMADFT 동형).
- **메타모델 해소:** ✅ 부속물#8 + 공정#2 부착 bundle 귀속 확정. **★고리 KR/CN/CR ST 공유 = 단일 부자재 마스터 시사(부속물#8 횡단 카탈로그·갭분석가 주목). 검증 필요분: 소재특화/마그넷/뱃지/그립톡/펜토퍼 부자재코드·부착공정 unobserved → gap/validation.**

## A-5. 인쇄면(print_data 앞뒤같음/다름) + 화이트의 투명소재 종속 — 옵션#3 + 공정#2 + 제약#5 facet [distinct 거부] ★ST S-7 동형

- **판정:** **인쇄면=옵션#3(앞뒤 택1) + 화이트=공정#2(별색 family) + 투명소재→가용=제약#5 cascade (distinct 거부) — ST S-7·TP T-E 동형.** `option_info.print_data`(O 앞뒤같음/X 다름)가 투명/유색 아크릴(키링/등신대)엔 있고 불투명 명찰(ACNTHAP)엔 없음(print_data null·화이트 없음). `PRT_WHT`(화이트언더베이스)=공정#2.
- **★"양면" 3곳 분산 통합 검토(reverse 제기):** "양면"이 ① 도수(SID_D 양면8도·인쇄도수) ② 인쇄면(print_data 앞뒤다름·투명 양면시야) ③ 코롯토(BCO 양면자립) 3곳 분산. **각자 다른 의미축:** 도수=인쇄 색수(기초코드#6)·인쇄면=앞뒤 데이터 동일/상이(옵션#3·투명소재 종속)·코롯토양면=자립 입체(A-3 자재). 통합 아님 — 같은 단어 다른 축(CL print 방식·PR 양면 SID_D와 경계). 인쇄면(앞뒤같음/다름)은 투명 아크릴 양면 시야 종속 옵션#3.
- **근거:** reverse §0.5·§2·§3. ST S-7 "화이트강제(PRT_WHT)=공정#2 별색 family + DTF→화이트 force cascade(#5)·`entity-semantic-model.md:88` PROC_000008 화이트=투명/홀로그램/메탈 베이스" 동형 — AC 투명/유색→화이트 가용 cascade(불투명 명찰=화이트 없음). 별색=공정 경계(HARD)·화이트를 도수/자재로 오적재 금지.
- **메타모델 해소:** ✅ 옵션#3(인쇄면) + 공정#2(화이트) + 제약#5(투명소재 종속) 귀속 확정(ST S-7 합류). **검증 불요(도메인 경계·ST 동형). 단 인쇄면(print_data)이 옵션#3인지 도수#6 차원인지 라이브 확인 → gap(앞뒤다름=별 디자인 데이터 2면).**

## A-6. 3 가격엔진(vTmpl/acrylic2025/tmpl)의 한 카테고리 공존 — 가격기여역할#11 pricing_model 라우팅 facet [distinct 거부] ★ST S-6·GS G-7·PR P-6 합류

- **판정:** **가격기여 역할 축(#11)의 pricing_model 라우팅 facet (distinct 거부) — ST 3엔진(S-6)·CL clothes2025·GS G-7·PR P-6 횡단 합류.** AC 한 카테고리에 명찰(vTmpl_price·프리셋 템플릿가)·키링(acrylic2025_price·아크릴 전용 면적·두께·소재 산정)·등신대(tmpl_price·완제 템플릿가) 3엔진 공존. price_gbn=라우팅 키·형태가 분기.
- **근거:** reverse §0.6·§1·§2·§3. `acrylic2025_price`=[huni-ref] `acrylic-chain-design.md:48·172` **`PRF_CLR_ACRYL` 투명아크릴 공식·면적매트릭스·두께 mat_cd 분기**와 정합(소재계열별 가격엔진 분기: 투명=PRF_CLR_ACRYL·미러=PRF_MIRROR·코롯토=PRF_COROTTO·카라비너=PRF_CARABINER 고정가). pricing_model enum이 기존 6종(면적/digital/tmpl/vTmpl/tiered/book2025)에 **acrylic2025(아크릴 전용 면적·두께·소재 산정)** 추가 = ST die-cut/판/정가(S-6)·GS tmpl/vTmpl/tiered(G-7)·PR digital(P-6)와 같은 "형태/소재별 전용 가격엔진(2025세대)" 패턴. 신축 불요(라우팅 키=price_gbn).
- **메타모델 해소:** ✅ #11 pricing_model에 acrylic2025 라우팅 추가 확정. **★거울 별 공식(PRF_MIRROR·A-2)·코롯토(PRF_COROTTO·A-3)·카라비너 고정가(PRF_CARABINER) = 소재/형태별 가격엔진 라우팅(#11). 검증 필요분: acrylic2025 산정식·prc_typ .02 정합([huni-ref] Q-ACR-7 미해소) → gap/validation(dbmap 가격 트랙).**

## A-7. 상품명 소재 ≠ 본체 자재(명찰=PET+아크릴합지) — 자재#1(본체=PET) + 공정#2(합지=아크릴화) facet [distinct 거부] ★G-1·CL C-2 동형

- **판정:** **자재 축(#1 본체=PET) + 공정 축(#2 아크릴합지) facet (distinct 거부) — G-1 라벨 융합·CL C-2 의류 SKU 라벨 동형.** "아크릴 명찰"의 본체 자재=고투명 PET 리무버블(RXIGC075)이고 아크릴감은 `BON_PAP`/ACXXS 아크릴합지(공정#2·PET에 아크릴 시트 합지=하드커버 효과)로 부여. 상품명의 "아크릴"=합지 공정 결과·마케팅 라벨이지 본체 자재 아님.
- **근거:** reverse §1·§4-D. G-1 "완제 본체 PCS_DTL_NME 라벨 융합(미르 화이트 20oz)→{body_material,body_color,capacity} 분해 [HARD]"·CL C-2 "MTRL_COD 의류 SKU→{fabric,color,size} 분해 [HARD]"와 동형 — AC도 "상품명 소재 ≠ 본체 자재 ≠ 합지소재" 분리 표현 필요. 합지(BON_PAP)=공정#2 멤버(T-6 STA_CLD·P-9 BON_PAP·PR 합지 동형)이지 별 자재슬롯 아님(단 합지 시트=자재 consumes FK·D-2 bundle). entity-semantic-model "상품명에만 소재·본체소재 컬럼 부재"(round-22 GPM) 결함의 AC판.
- **메타모델 해소:** ✅ 자재#1(본체 PET) + 공정#2(합지) 귀속 확정(G-1·CL C-2 [HARD] 분해 처방 동형). 합지=공정#2(자재 consumes bundle·D-2). **검증 불요(도메인·G-1/CL 동형). 후니 흡수: 명찰 본체=PET 자재행·아크릴감=합지 공정(상품명≠본체자재 분해) → gap/vessel.**

## A-8. ★가공방식(production_method 일반/라미)의 버킷 — 공정#2(라미네이션) + 자재#1 합성(두께/표면) + 옵션#3 cascade facet [distinct #18 거부] ★신규 강후보 적대 판정

- **판정:** **facet 클러스터 — distinct "가공방식 그룹핑 슬롯 #18" 거부.** `option_info.production_method`(MTG_DFT 일반/MTG_LAM 라미)가 GRP_OPTION_CD로 자재행을 가공그룹으로 묶으나, 세 기존 축으로 무손실 분해: ① **라미네이션 자체=공정#2**(라미=합지 후가공·BON_PAP/합지 family 동형) ② **라미 결과(3T→2T+1T 합성·홀로그램 부여)=자재#1 합성**(라미된 자재행 PXAATL01~04=합성 자재·D-2 자재 합성 규칙) ③ **가공방식→호환 자재 subset 게이팅=옵션#3 polymorphic cascade**(G-4 DTL 채널 동형·한 옵션이 자재 subset 결정).
- **★양면 트레이드오프 펼침(침묵 선택 금지):**
  - **(가) distinct "가공방식 그룹핑 슬롯 #18" 신설:** 찬성=GRP_OPTION_CD가 자재행을 *가공방식 그룹*으로 묶는 명시 슬롯(MTG_DFT/MTG_LAM)·`option_info.production_method` 전용 인코딩·라미가 두께 합성(3T→2T+1T)+홀로그램 부여라는 *능동 변환*(단순 옵션 아님)·ST 형상(#17)처럼 "전용 슬롯=distinct 신호". 반대=★세 근거 전부 기존 축의 표현/구현으로 무손실 분해(distinct 요구 "기존 축이 왜곡 없이 못 담는 고유 lifecycle"이 없음).
  - **(나) 공정#2 + 자재#1 합성 + 옵션#3 cascade facet 클러스터 [채택]:** ① 라미네이션=공정#2 멤버(라미=합지 후가공·deterministic 공정·`pdf-domain-knowledge` 합지/UV 후가공 멤버 동형). ② 라미 결과 자재행(PXAATL01 3T투명 라미 2T+1T·PXAATL03 홀로그램 라미)=자재#1 *합성*(D-2 "MTRL_CD 합성·두께/표면 분해축")·두께 합성=WGT 차원(A-1)·홀로그램=surface-finish(A-2). ③ GRP_OPTION_CD가 production_method(일반/라미)→호환 MTRL_CD subset을 게이팅=옵션#3 polymorphic cascade(G-4 "한 DTL/옵션코드가 자재 subset 결정" 동형·제약#5 match). **"자재를 가공방식으로 그룹핑하는 슬롯"=옵션#3 cascade가 자재#1 subset을 게이팅하는 관계 간선**이지 별 관리 축 아님.
- **★ST 형상(#17)과의 결정적 차이(왜 형상은 승격·가공방식은 부결):** 형상(#17)은 *사이즈축(#13)이 형상을 1:1 칼틀로 흡수해온 전제가 1:多로 깨져* 기존 축이 *왜곡 없이 못 담음*(후니 KB G-SK-2 "형상 어느 축에도 없음" 결함 확증)이 distinct 근거였다. 가공방식은 정반대 — 기존 축이 *왜곡 없이 담음*: 라미=공정#2(이미 합지 멤버 존재)·합성결과=자재#1(이미 합성 규칙 D-2)·그룹핑=옵션#3 cascade(이미 G-4 채널). 후니 KB에 "가공방식 어느 축에도 없음" 같은 결함 명시 *없음*(라미네이션은 공정 멤버로 이미 수용). → 형상=축 부재(distinct)·가공방식=축 충분(facet). **역방향 오류 점검(distinct를 facet으로 숨김):** GRP_OPTION_CD 그룹핑 슬롯이 유일 잔여 후보였으나, 그룹핑=옵션#3이 자재#1 subset을 polymorphic 참조로 게이팅하는 것(G-4 DTL 채널·CL size×color 매트릭스가 자재 SKU 게이팅과 동형)으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음).
- **근거:** reverse §0.6·§2·§4-A. 라미(MTG_LAM)=홀로그램/투명 위 라미네이션 합지(2T+1T 두께 합성)·widgetDump buttons "일반/라미" 실측. 자재행 GRP_OPTION_CD=MTG_DFT(PXAATD01/D02)·MTG_LAM(PXAATL01~04) — 즉 production_method가 *자재행 속성*(어느 가공으로 만든 자재인가)이며 옵션 선택(일반/라미)이 그 자재 subset을 게이팅. D-2 "자재 합성(MTRL_CD 다축·두께/표면 분해)"·G-4 "한 옵션코드가 자재 subset 결정"·#2 합지 family가 이미 담음. GS 제본(링=자재+꿰기 공정)·PR 면지(컬러지+삽입)·TP 쫄대(봉+제본) bundle과 동류(가공방식=공정+자재합성 bundle).
- **메타모델 해소:** ✅ 공정#2(라미) + 자재#1 합성(라미 결과·두께/표면) + 옵션#3 cascade(가공방식→자재 subset 게이팅) 귀속 확정. **★dictionary #2(공정 라미 family)·#1(자재 합성 라미 결과)·#3(옵션 가공방식 cascade) 반영. 검증 필요분: 라미 자재행 가격(acrylic2025 두께합성 산정)·소재특화 라미(글리터/자개) unobserved → gap/validation.**

## A-9. ACTPKEY 키링 템플릿의 AC 소속 vs TP — 디자인입력채널#16 TemplateAsset facet [distinct 거부] ★T-A 동형

- **판정:** **디자인 입력 채널 축(#16)의 TemplateAsset facet (distinct 거부) — T-A 템플릿 이중의미 분리 동형.** "아크릴 키링 템플릿"(ACTPKEY)이 AC 카테고리에 속하나 *에디터 디자인 자산형*(키링 디자인 프리셋·useTemplateDownload·koi_template_resource). 카테고리 소속(AC)=카테고리#7·자산 유형(디자인 시안)=#16 TemplateAsset — 직교(같은 단어 "템플릿" 다른 의미).
- **근거:** reverse §4-D·T-A. TP T-A "템플릿 자산(에디터 디자인 시안·가격0·#16 종속) ≠ 템플릿#4(완제SKU 번들)" [HARD] 이중의미 분리와 동형 — ACTPKEY=#16 TemplateAsset(디자인 시안·`koi_template_resource_id`)이지 #4 완제SKU 아님. AC 카테고리 소속은 카테고리#7(다중분류 가능). 후니 매핑 시 ACTPKEY를 `t_prd_templates`(완제SKU)에 적재 금지(가격0 디자인 리소스를 주문단위로 오모델·T-A 경계).
- **메타모델 해소:** ✅ #16 TemplateAsset + 카테고리#7 소속 귀속 확정(T-A 이중의미 분리 동형). **검증 필요분: ACTPKEY 템플릿 자산 카탈로그·VDP unobserved → gap/validation(로그인 에디터 캡처).**

---

## AC 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| A-1 두께(3T/5T/8T) | **자재#1 WGT 차원** | WGT 슬롯 다의성(평량/두께)·[huni-ref] mat_cd 통합 동형 | **facet(거부)** ★관전1 | #1 | WGT 슬롯 measure_type → gap/vessel |
| A-2 소재 variant(글리터/거울/자개…) | **자재#1 surface-finish 합성** | ST S-4 점착/내후 동형·거울 별공식=#11 라우팅 | **facet(거부)** ★관전3 | #1 | 소재특화 자재코드·거울가격 → gap |
| A-3 입체/스탠드(3D) | **분산: 부속물#8(받침)+자재#1(두께)+옵션#3(양면)+공정#2(조형)** | 받침=부속물(본체 생성 아님·#14 아님)·코롯토=자재 두께·생산형태#15 아님 | **facet(거부)** ★관전2 | #8·#1·#3·#2 | 코롯토 조형/8T 블록 → gap |
| A-4 부착물(고리/받침/자석/핀) | 부속물#8 + 공정#2 부착 bundle | KR/CN/CR ST 공유=단일 부자재 마스터·받침=#8 | facet(거부) | #8·#2 | 부착공정/부자재코드 → gap |
| A-5 인쇄면 + 화이트 | 옵션#3 + 공정#2(화이트) + 제약#5(투명종속) | ST S-7 동형·별색=공정·"양면" 3축 분산 | facet(거부) | #3·#2·#5 | 인쇄면=옵션/도수 → gap |
| A-6 3 가격엔진(vTmpl/acrylic2025/tmpl) | 가격#11 pricing_model 라우팅 | ST S-6·GS G-7·PR P-6 합류·acrylic2025 추가 | facet(거부) | #11 | acrylic2025 산정식·.02 → gap |
| A-7 상품명 소재≠본체 자재(명찰 PET+합지) | 자재#1(PET) + 공정#2(합지) | G-1·CL C-2 라벨 융합 동형·합지=공정 | facet(거부) | #1·#2 | (해소·분해 → gap/vessel) |
| A-8 ★가공방식 그룹핑(일반/라미) | **공정#2(라미)+자재#1 합성+옵션#3 cascade** | GRP_OPTION_CD=옵션 cascade·라미=공정·합성=자재·형상#17과 정반대(축 충분) | **facet(거부·#18 부결)** ★강후보 | #2·#1·#3 | 라미 가격·소재특화 → gap |
| A-9 ACTPKEY 키링 템플릿 | 디자인입력채널#16 TemplateAsset + 카테고리#7 | T-A 이중의미 분리 동형·#4 완제SKU 아님 | facet(거부) | #16·#7 | 자산 카탈로그·VDP → gap |

**AC 강제 분류 회피(SKILL §3·§5):** **distinct 승급 0건(★가공방식 그룹핑 A-8 부결) = 17축 재포화(PR 4번째·CL 6번째 distinct 0 패턴 반복).** 9 fragment 전부 기존 17축 facet/family/cascade/정책. ★directive 4 관전 적대 판정: ① 두께=자재#1 WGT facet([huni-ref] mat_cd 통합 동형) · ② 소재variant=자재#1 surface-finish facet(ST S-4 동형) · ③ 입체/스탠드=분산 facet(받침=부속물#8·두께=자재·양면=옵션·조형=공정·생산형태#15/형태가공#14 둘 다 아님) · ④ 가공방식 그룹핑=공정#2(라미)+자재#1 합성+옵션#3 cascade facet(★침묵선택 거부하고 "별 그룹핑 슬롯 #18 vs 세 축 분해" 트레이드오프 펼친 뒤 facet·형상#17과 정반대로 기존 축이 왜곡 없이 담음). **★재포화 정당성:** 형상(#17·ST)은 후니 KB G-SK-2 "어느 축에도 없음" 결함이 distinct를 강제했으나, AC 9 fragment(가공방식 포함)는 후니 KB+기존 축이 *왜곡 없이 담음* → distinct 0 정직. 7번째 카테고리(아크릴 두께/입체/가공방식)가 새 관리축 0 도입 = 모델 안정성 재확인(가장 강한 새 후보 A-8조차 무손실 흡수).
**AC가 더한 것(축 신설 아닌 *강화*):** ① **17축 재포화** — 7번째 카테고리 distinct 0(PR·CL 패턴 반복). ② 자재#1 surface-finish 합성 차원(글리터/거울/자개/홀로그램/렌티큘러·ST S-4 점착/내후와 합류한 자재 합성 분해축). ③ 자재#1 WGT 슬롯 다의성 명시(평량 vs 두께·[huni-ref] mat_cd 동형). ④ 부속물#8 횡단 확장(받침 AB 12 SKU·고리 KR/CN/CR ST 공유=단일 부자재 마스터). ⑤ 옵션#3 가공방식 cascade(production_method→자재 subset 게이팅·G-4 채널 합류). ⑥ 가격#11 pricing_model acrylic2025 라우팅(소재/형태별 가격엔진). ⑦ 공정#2 라미네이션/합지 멤버 + 자재 합성 결과 bundle(D-2).
**검증 라우팅 요약:** 메타모델 해소 ✅ = A-3·A-5·A-7·A-8(축 귀속 확정) / 부분 🟡 = A-1·A-2·A-4·A-6·A-9(unobserved 잔존 → gap/validation). 라이브/엑셀 검증 필요분 = WGT 슬롯 measure_type(A-1)·소재특화 자재코드/거울가격(A-2)·부착공정/부자재코드(A-4)·acrylic2025 산정식/prc_typ .02(A-6·[huni-ref] Q-ACR-7)·ACTPKEY 자산 카탈로그(A-9) + 후니 부자재 마스터 단일화(A-4 → gap/vessel).

---

# PD(스툴·슬리퍼·강아지계단 = 봉제 구조물/3D 조립 완제품) fragment 판정 (v8.0 — 조립·구조·3D폼·단수·완제 내재BOM) ★조립 distinct(#18) 적대 판정·재포화

> `categories/PD/reverse.md` ## Ambiguous fragments PD-1~PD-5 판정. **8 상품군(BN 면적·GS 완제/입체·TP 디자인입력·PR 다면/제본/접지·ST 형상/칼선/점착·CL 의류 variant·AC 아크릴 두께/입체/가공방식·PD 봉제 구조물 완제품)** 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): PD 한 군만의 특이는 facet 강등. distinct 승급 = 8 상품군을 견디는 고유 lifecycle/governing + 후니 도메인 동형 보유 시만.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(addl_product 부속물 #9·생산방식 A/B/C·자재 usage·두께=자재) + GS(본체 형태가공 D-10/#14·완제 본체 G-1)·AC(입체/스탠드 분산 facet §0.3)·ST(형상 #17) 직접 대조. **★domain-researcher 신규 호출 불요** — 봉제/제품가공(=형태가공#14/공정#2)·완제 구조물 BOM(=부속물#8+생산형태#15+가격#11)·단수(=사이즈#13 프리셋)가 후니 KB+기존 17축에 확정 존재(추정 0).
> **★PD 핵심 판정: distinct 신규 축 0건(★완제 구조물 내재BOM PD-4 #18 부결) = 17축 재포화(PR·CL·AC 패턴 반복).** PD reverse가 1차 예측한 "distinct 0(8번째 재포화)"를 적대 판정으로 비준 — 가장 이질적 *봉제 구조물 완제품*(스툴/슬리퍼/강아지계단)조차 17축 무손실 흡수. ★directive 최대 관전(조립·구조·3D폼·완제 내재BOM=distinct #18인가) 적대 판정: **PD-1 봉제=형태가공#14 family 멤버 · PD-2 직물원단=자재#1 · PD-3 단수/형상=사이즈#13 · PD-4 완제 내재BOM=부속물#8+생산형태#15+가격#11 분산 · PD-5 enum=공정/부속물 unobserved.**

## PD-1. 구조물 봉제/제품가공(SEW_LTR·PDT_WRK) — 본체 형태가공#14(GS D-10) 봉제 family 멤버 [facet → 신축 거부]

- **판정:** **본체 형태가공 축(#14·GS D-10)의 "봉제(SEW_LTR 레더재봉)" family 신규 멤버 + 공정#2 facet (distinct "조립 축 #18" 거부).** PDCHSTL/PDSRPPY `SEW_LTR_CHK`(레더재봉)·PDWRSLP `PDT_WRK_CHK`(제품가공)이 평면 원단/인쇄물을 *봉제·조립해 입체 완제 구조물 본체를 생성* — GS 형태가공#14(PDT_WRK 파우치가공·FLX_ZIP 지퍼)와 **동일 lifecycle**(본체 형태 자체를 생성·없으면 본체 부재).
- **★적대 판정(조립 distinct #18 반론 검토):** reverse 반론 — "레더재봉/제품가공"은 인쇄 후가공(코팅/박)과 질적으로 다른 *조립/봉제 생산공정*(섬유/구조물 제조)이라 후니 공정모델이 인쇄 후가공 위주면 담을 그릇 부재 가능. **그러나:** ① PDWRSLP `PDT_WRK`는 GS `PDT_WRK`와 *동일 코드*(조립 마감)·이미 #14가 담음(파우치/마이크텍 조립). ② PDCHSTL/PDSRPPY `SEW_LTR`(레더재봉)은 #14에 **"봉제(sewing)" family 멤버 신규 등재**(assembly_type=봉제)이지 별 축 아님 — #14 정체("평면→입체 본체 *생성*")가 봉제도 포함. ③ 기존 PCS 슬롯에 인코딩(새 슬롯 없음·`[live:SSR]` icon_txt 실측) — RP가 봉제 조립을 *별 슬롯/별 축으로 인코딩하지 않음*. ④ 후니 KB에 "봉제/조립 공정 어느 축에도 없음" 결함 명시 *없음*(형태가공#14가 이미 distinct 축으로 존재·굿즈 BOM "평면→입체 조립" 동형) → distinct #18 부결, #14 family 확장 정당.
- **근거:** GS D-10/#14 (본체 형태가공·PDT_WRK/FLX_ZIP)이 이미 distinct 축. THO_CUT(모양커팅)=공정#2(ST/GS 동형)·SUB_MTR=부속물#8(AC/ST 동형). 봉제 구조물 완제품(PD)이 굿즈(GS)에서 #14 횡단 확장 입증.
- **메타모델 해소:** ✅ #14 봉제 family 멤버(SEW_LTR) + PDWRSLP PDT_WRK=GS 동형 귀속 확정. **검증 필요분: 봉제 공정 상세 enum·솜 충전/지퍼 consumes 자재(unobserved·infoCall 후행) → gap/validation.**

## PD-2. PD 자재 = 직물/PU 원단(종이 아님) — 자재#1 PTT 차원 facet [distinct 거부]

- **판정:** **자재 축(#1)의 PTT(소재계열) 차원 값 확장 facet (distinct 거부).** 면10수화이트·슬리퍼원단·PU(폴리우레탄)-코끼리원단(`[live:SSR]` paper 슬롯)이 종이 substrate가 아닌 *직물/합성수지 원단* — AC 아크릴·CL 의류원단(fabric PTT)과 동형(비종이 자재는 이미 여러 카테고리에서 관측). 별 "직물 자재축" 신축 불요.
- **근거:** 자재#1 PTT 슬롯이 종이(BN/PR)·아크릴(AC mm)·의류원단(CL)·직물/PU(PD)를 *같은 합성코드 차원*으로 담음(D-2 자재 합성). 면10수="수(번수)"단위는 평량(종이 g·AC mm 두께)과 동류 WGT 차원 다형성(같은 슬롯·소재 도메인별 의미·A-1 WGT 다의성 동형).
- **모호 지점(reverse 제기):** 후니 자재모델(지종×평량)이 직물(면10수=면사 굵기)·PU 같은 비종이 원단의 *물성 차원*(원단 종류·신축성)을 담는가 = round-22 굿즈 본체소재 부재 결함과 연결. → **갭분석가**(자재 합성코드에 직물 물성 차원 그릇 검토·data-gap).
- **메타모델 해소:** ✅ 자재#1 PTT 차원 귀속 확정. **검증 필요분: 직물/PU 원단 물성 차원(원단종류/번수/신축성) 후니 자재모델 수용 여부 → gap/vessel.**

## PD-3. 계단 단수(2단/3단)·스툴 형상 — 사이즈#13 프리셋 흡수 facet [distinct 거부] ★구조/형상 distinct 부결 결정적 증거

- **판정:** **사이즈 축(#13)의 프리셋 흡수 facet (distinct "구조/형상 축 #18" 거부).** PDSRPPY size=2단(495×320)/3단(717×382)·PDCHSTL size=미니사각/미니원형/원형/긴사각(`[live:SSR]`)이 *단수/형상을 사이즈 프리셋에 1:1 인코딩* — ST 형상(#17)의 1:多가 아님.
- **★적대 판정(구조/형상 distinct 반론·ST #17 대조):** ① **단수(2단/3단)** = 계단 구조의 층수(구조적 의미·하중)이나 RP가 *사이즈 프리셋으로만 노출*(2단=495×320 1:1·옵션 아님) → 구조가 사이즈에 흡수됨 = **구조 distinct 부결의 결정적 증거**. ② **스툴 형상(미니사각/미니원형/원형)** = ST 형상(#17)처럼 보이나 **형상↔사이즈 1:1**(원형=305×305 치수 프리셋 1개와 동치) → ST 1:多(한 형상 CL이 CL001~CL100 칼틀 enum span)와 다름 → ST #17 distinct 전제(1:多 분리·전용 shape_info 슬롯·5형상 superset) 미충족. PD는 형상=사이즈 1:1이므로 BN 어깨띠·GS THO_CUT·TP M/I·PR 카드형과 동일하게 **사이즈축이 형상을 흡수**(형상축 #17 강제 적용 금지=오모델 회피·dictionary #21 [HARD] 경계).
- **근거:** ST #17 [HARD] 경계 "형상이 1:1이면 사이즈 흡수·1:多 분리가 명시 슬롯으로 드러나면 별 분류축". PD는 1:1(전용 shape_info 슬롯 없음·size 슬롯에 형상+치수 융합) → 사이즈#13 흡수 정당.
- **모호 지점(reverse 제기):** "단수"가 생산 BOM 관점(2단 vs 3단 자재량/공정량 차이)에서 사이즈가 생산정보를 게이팅하는지 unobserved(infoCall 가격 후행). → **갭/가격 단계**(사이즈→생산BOM 게이팅).
- **메타모델 해소:** ✅ 사이즈#13 프리셋 흡수 귀속 확정(구조/형상 distinct 부결). **검증 필요분: 단수→생산BOM(자재/공정량) 게이팅 unobserved → gap/validation.**

## PD-4. 완제 구조물의 "옵션 미노출 제조레시피"(다리/받침/솜/지퍼/논슬립) — 부속물#8 + 생산형태#15 + 가격#11 분산 facet [distinct #18 거부] ★directive 핵심 의사결정

- **판정:** **분산 facet — distinct "완제 구조물 내재BOM 축 #18" 거부.** 완제품 내재BOM(다리/받침/솜/지퍼/논슬립)이 옵션 미노출·고정 제조 사양(`[live:SSR-marketing]` 카피에만)이나 네 기존 축으로 무손실 분해.
- **★양면 트레이드오프 펼침(침묵 선택 금지) — discovered-axes PD-4 참조:**
  - **(가) distinct "완제 구조물 내재BOM 축 #18" 신설:** 찬성=봉제 구조물 고정 부품(다리/받침/솜/지퍼/논슬립)이 옵션 슬롯에 *없으면서도* 생산정보로 존재 — 옵션축(노출)·자재축(본체 substrate)이 "옵션 미노출 고정 제조 부품 명세"를 직접 담지 않음·RP 마케팅 카피로만 둠=관리 그릇 부재 신호(ST 형상 shape_info 전용 슬롯 가설). 반대=★세 갈래 무손실 분해·distinct 요구 "기존 축이 왜곡 없이 못 담는 고유 lifecycle"이 없음.
  - **(나) 부속물#8 + 자재#1/공정#2 + 생산형태#15 + 가격#11 분산 facet [채택]:** ① 완제 부속 부품(다리·받침·논슬립 패드)=부속물#8(addl_product·`entity-semantic-model.md:30` "완제 부속: 거치대·우드봉·볼체인"·다리/받침/논슬립도 본체 분리 완제 부속·BN 거치대·AC 등신대 받침 동형)·옵션 미노출=부속물의 *고정(ESN=Y·view_yn=N·고객 미선택) facet*(AC 받침 ESN=Y 동형). ② 솜 충전/지퍼/논슬립 원단=자재#1 sub_mtrl usage_cd + 공정#2(봉제 consumes·FLX_ZIP 패턴). ③ "옵션 미노출 고정 제조" 성격=생산형태#15(C 완제품 governing·내재 BOM은 완제품 정체에 묶인 고정 레시피)·④ 완제 단가=가격#11(tmpl_price 내재 BOM 포함 개당단가).
- **★ST 형상(#17)과의 결정적 차이(역방향 오류 점검):** 형상(#17)은 후니 KB G-SK-2 "형상 enum 어느 축에도 없음" 결함이 *기존 축이 왜곡 없이 못 담음*을 강제(distinct). 완제 내재BOM은 **정반대** — 후니 KB가 addl_product(#9·`:30`)·자재 usage(#2·`:23`)·생산방식 A/B/C(#15·`:113`)를 *이미 1급 모델링*(결함 명시 없음·부속물/usage/생산형태가 왜곡 없이 담음) → 형상=축 부재(distinct)·완제 내재BOM=축 충분(facet). **역방향 오류(distinct를 facet으로 숨김) 점검:** "옵션 미노출 고정 부품 명세"가 유일 잔여 후보였으나 부속물#8의 고정(ESN=Y·view_yn=N) 완제 부속 facet(AC 등신대 받침 ESN=Y 동형)으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음).
- **★data-gap vs vessel-gap [중요·갭분석가]:** RP가 내재BOM을 마케팅 카피로만 두는 것은 *부속물#8/생산BOM 그릇에 적재해야 할 데이터(다리/받침/논슬립·솜/지퍼)를 미적재*한 것 = **data-gap이지 vessel-gap(축 부재) 아님**. 후니가 완제 구조물 취급 시 부속물#8(다리/받침/논슬립=고정 ESN=Y·view_yn=N)·자재 usage(솜/지퍼 consumes)에 적재 = 기존 그릇 채우기(새 그릇 불요).
- **메타모델 해소:** ✅ 분산 facet 귀속 확정(부속물#8 고정 부속 + 자재#1 usage + 생산형태#15 + 가격#11). **검증 필요분: 완제 구조물 BOM 상세(다리 종류/솜 충전량/논슬립 원단·전부 [live:SSR-marketing] 카피) → gap/validation(부속물/생산BOM data-gap 적재).**

## PD-5. 모양커팅 상세 enum·추가부자재 enum·가격 결합 — 공정#2/부속물#8 [facet → unobserved]

- **판정:** **공정 축(#2 THO_CUT)/부속물 축(#8 SUB_MTR) facet (distinct 거부) — unobserved.** THO_CUT_SUB_SELECT 상세 enum·SUB_MTR 상세 enum·price_gbn=tmpl_price 단가가 infoCall AJAX 후행이라 SSR 미노출. 축 판정(distinct 0)은 SSR 슬롯만으로 확정되므로 보강은 갭/가격 단계 선택.
- **근거:** 모양커팅=공정#2(ST/GS THO_CUT 동형)·추가부자재=부속물#8(AC/ST SUB_MTR 동형)·가격=#11(tmpl 완제 단가·GS tmpl 동형). 전부 기존 축·날조 금지(unobserved).
- **메타모델 해소:** 🟡 부분 — 축 귀속(공정#2/부속물#8/가격#11) 확정·상세 enum unobserved. **검증 필요분: THO_CUT/SUB_MTR 상세 enum·tmpl 단가 결합(infoCall 캡처·날조 금지) → gap/validation.**

## PD-6. ★[정정·PD-M1 D-PD-1] 슬리퍼 밑창색(검정/흰색) — six_clr(별색) 오귀속 정정 → SUB_MTR 부자재 variant(부속물#8/자재 sub_mtrl) [facet → 신축 거부·distinct 0 불변]

- **★정정 배경(PD-M1 Medium 결함 D-PD-1):** PDWRSLP 슬리퍼 밑창색(검정/흰색)이 reverse 초판에서 `six_clr`(별색)로 **오귀속**됐으나, 실제는 `SUB_MTR`(추가부자재) sub-radio(`SLB*`/`SLW*` 밑창색×사이즈 12-variant)임이 PD-M1 검증에서 적발(reverse §0.5/§2/§4 SUB_MTR로 정정 중). 본 메타모델 산출은 밑창색을 *자재#1 본체색(CLR) family로 참조한 곳이 없음*(전수 grep 확인 — 밑창색은 dictionary/discovered-axes/erd 어디에도 자재 CLR로 등재되지 않음). 따라서 **facet 귀속만 명시 고정**(정정 사항 누락 방지·향후 reverse 정정본 정합).
- **판정:** **밑창색(SLB*/SLW*) = SUB_MTR 부자재 variant = 부속물#8(완제 부속·밑창 sole) 또는 자재 sub_mtrl(#1 본체 sub-component) facet (distinct 거부).** 밑창은 슬리퍼 본체와 결합되는 *별 완제 부속 부품(sole)*이고, 색×사이즈 12-variant는 그 부자재의 SKU variant — AC 받침(SUB_MTR·A-3/A-4)·ST SUB_MTR 부자재 variant와 동형. ★**별색(six_clr·공정#2)과 명확 구분** — 밑창색은 *부자재(밑창 소재)의 색 variant*(인쇄 잉크 별색 아님). round-22 경계규칙 "별색=공정·본체색=자재 CLR" 어느 쪽도 아닌 **부자재 variant**(고무/EVA 밑창의 제조 색).
- **★자재 sub_mtrl vs 부속물#8 경계(미세 판정):** 밑창은 ① 슬리퍼 본체에 *봉제·접착으로 결합되는 구성 부품*(자재 sub_mtrl·usage_cd 슬롯·솜/지퍼 PD-4 동류) 관점 ② 본체와 *분리된 완제 부자재 SKU*(부속물#8·AC 받침 동류) 관점 양면. PD-4 완제 구조물 내재BOM(솜/지퍼=자재 sub_mtrl·다리/받침=부속물#8)과 동일 *분산 facet* 패턴 — 단 밑창색은 *옵션 노출*(SUB_MTR sub-radio·고객 선택)이라 PD-4 고정(view_yn=N) 내재BOM과 달리 **노출 부자재 variant**(view_yn=Y·12-variant 선택). 어느 쪽이든 **기존 축 facet**(별색 아님)이라 distinct 0 결론 불변.
- **★distinct 0 불변:** 밑창색이 별색(six_clr·공정#2)이든 부자재 variant(부속물#8/자재 sub_mtrl)이든 **둘 다 기존 축 facet** — facet 귀속 정확성만 정정(별색→부자재 variant), 17축 결론·PD distinct 0 무영향. (PD-2 직물원단 자재#1·PD-4 솜/지퍼 자재 sub_mtrl과 합류한 봉제 구조물 부자재 모델.)
- **메타모델 해소:** ✅ 밑창색=SUB_MTR 부자재 variant(부속물#8/자재 sub_mtrl)·별색(six_clr·공정#2)과 구분 정정 확정. **검증 필요분: 밑창 sole 자재코드(SLB*/SLW* 12-variant)·부속물#8 vs 자재 sub_mtrl 최종 귀속(밑창=결합 부품인지 분리 SKU인지) → gap/validation(reverse SUB_MTR 정정본 정합).**

---

## PD 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| PD-1 봉제/제품가공(SEW_LTR/PDT_WRK) | **본체 형태가공#14(GS D-10) 봉제 family** + 공정#2 | SEW_LTR=새 멤버·PDWRSLP PDT_WRK=GS 동일코드·기존 PCS 슬롯 | **facet(거부)** ★ | #14·#2 | 봉제 enum/솜·지퍼 consumes → gap |
| PD-2 직물/PU 원단 | 자재#1 PTT 차원 | AC 아크릴·CL 의류원단 동형·비종이 이미 관측·면10수=번수 평량 | facet(거부) | #1 | 직물 물성 차원 그릇 → gap/vessel |
| PD-3 단수(2/3단)·스툴형상 | 사이즈#13 프리셋 흡수 | 단수=구조이나 사이즈 1:1·형상=원형↔305×305 1개=ST 1:多 미충족 | **facet(거부)** ★ | #13 | 단수→생산BOM 게이팅 → gap |
| PD-4 ★완제 구조물 내재BOM(다리/받침/솜/지퍼/논슬립) | **부속물#8(고정 ESN=Y)+자재#1 usage+생산형태#15+가격#11** | 옵션 미노출=고정 제조·후니 KB 결함 없음·형상#17과 정반대·data-gap not vessel-gap | **분산 facet(거부·#18 부결)** ★강후보 | #8·#1·#15·#11 | 완제 BOM 상세(다리/솜/논슬립) → gap(data-gap 적재) |
| PD-5 모양커팅/추가부자재 enum·가격 | 공정#2·부속물#8·가격#11 | infoCall unobserved·축 판정 무영향 | facet(거부·unobserved) | #2·#8·#11 | THO_CUT/SUB_MTR enum·tmpl 단가 → gap |
| PD-6 ★[정정 D-PD-1] 슬리퍼 밑창색(검정/흰색) | **SUB_MTR 부자재 variant=부속물#8/자재 sub_mtrl** | six_clr(별색) 오귀속 정정→SLB*/SLW* 밑창색×사이즈 12-variant·별색(공정#2)과 구분 | **facet(거부·distinct 0 불변)** ★정정 | #8/#1 | 밑창 sole 자재코드·부속물vs자재 최종귀속 → gap |

**PD 강제 분류 회피(SKILL §3·§5):** **distinct 승급 0건(★완제 구조물 내재BOM PD-4 #18 부결) = 17축 재포화(PR 4번째·CL 6번째·AC 7번째 distinct 0 패턴 반복).** 5 fragment 전부 기존 17축 facet/family/cascade. ★directive 최대 관전(조립·구조·3D폼·완제 내재BOM이 distinct #18인가) 적대 판정: ① 봉제/제품가공=본체 형태가공#14(GS D-10) 봉제 family 멤버(별 조립축 아님·PDWRSLP=GS 동일코드) · ② 직물/PU 원단=자재#1 PTT(AC/CL 동형) · ③ 단수/형상=사이즈#13 프리셋 흡수(2단=495×320 1:1·원형↔305×305 1개=ST 형상 1:多 미충족=구조 distinct 부결 결정적 증거) · ④ 완제 구조물 내재BOM=부속물#8(고정 ESN=Y)+생산형태#15+가격#11 분산 facet(★침묵선택 거부하고 "별 완제 BOM 축 #18 vs 네 기존 축 분산" 트레이드오프 펼친 뒤 facet). **★재포화 정당성:** 형상(#17·ST)은 후니 KB G-SK-2 "어느 축에도 없음" 결함이 distinct 강제했으나, PD 5 fragment(완제 내재BOM 포함)는 후니 KB(addl_product·자재 usage·생산방식 A/B/C)+기존 축이 *왜곡 없이 담음* → distinct 0 정직. 8번째 카테고리(봉제 구조물 완제품)가 새 관리축 0 도입 = 모델 안정성 재확인(가장 이질적 카테고리·directive 최대 관전 조립/구조/3D폼도 무손실 흡수).
**PD가 더한 것(축 신설 아닌 *강화*):** ① **17축 재포화** — 8번째 카테고리 distinct 0(PR·CL·AC 패턴 반복). ② 본체 형태가공#14 봉제(SEW_LTR) family 확장(굿즈→봉제 구조물 완제품 횡단). ③ 부속물#8 "고정(미노출·ESN=Y) 완제 부속" facet(완제 구조물 내재BOM·AC 받침 ESN=Y 합류). ④ 자재#1 비종이 원단 차원 확장(직물/PU·AC/CL 합류). ⑤ 사이즈#13 단수/구조 프리셋 흡수 입증(구조 distinct 부결 결정적). ⑥ 생산형태#15+가격#11(tmpl) 완제품 governing 재확인.
**검증 라우팅 요약:** 메타모델 해소 ✅ = PD-1·PD-3·PD-4(축 귀속 확정) / 부분 🟡 = PD-2·PD-5(unobserved 잔존 → gap/validation). 라이브/엑셀 검증 필요분 = 직물 물성 차원 그릇(PD-2 → gap/vessel)·단수→생산BOM 게이팅(PD-3)·완제 BOM 상세 적재(PD-4 → gap data-gap)·THO_CUT/SUB_MTR enum·tmpl 단가(PD-5). **★PD-4 = data-gap(부속물/생산BOM 그릇 미적재)이지 vessel-gap(축 부재) 아님 — 갭분석가 핵심 구분.**

---

# PH(포토보드·액자·사진인화·포토북·포토굿즈 = 사진을 어떤 물성으로 출력하느냐로 묶인 출력매체 카테고리) fragment 판정 (v9.0 — 완제 액자 그릇·마운팅/거치·전면 보호재·인화지×마감·set 단위·다중분류) ★완제 그릇/마운팅 distinct(#18) 적대 판정·재포화

> `categories/PH/reverse.md` ## Ambiguous fragments PH-1~PH-5 + §0.5 형태축 판정. **9 상품군(BN 면적·GS 완제/입체·TP 디자인입력·PR 다면/제본/접지·ST 형상/칼선/점착·CL 의류 variant·AC 아크릴 두께/입체/가공방식·PD 봉제 구조물 완제품·PH 완제 액자 그릇/출력매체)** 증거로 distinct/facet 결정.
> 과잉 일반화 경계(SKILL §5): PH 한 군만의 특이는 facet 강등. distinct 승급 = 9 상품군을 견디는 고유 lifecycle/governing + 후니 도메인 동형 보유 시만.
> 도메인 정초 = `07_domain/entity-semantic-model.md`(addl_product 부속물 #9·완제SKU 템플릿·생산방식 A/B/C·자재 usage·surface-finish 합성) + GS(완제 본체 SKU G-1·생산형태 D-9)·AC(소재 variant A-2·두께 WGT A-1·받침 부속물 A-3)·ST(형상 #17 [HARD] 경계·점착 surface-finish S-4)·PD(완제 내재BOM PD-4·단수 사이즈 1:1 흡수 PD-3) 직접 대조. **★domain-researcher 신규 호출 불요** — 완제 프레임(=완제SKU#4+자재#1 variant+생산형태#15)·거치(=옵션#3 캐스케이드 상위 차원)·인화지×마감(=자재#1 surface-finish)·형태 비율(=사이즈#13 프리셋)이 후니 KB+기존 17축에 확정 존재(추정 0).
> **★PH 핵심 판정: distinct 신규 축 0건(★완제 액자 그릇/마운팅 PH-1·PH-2 #18 부결) = 17축 재포화(PR·CL·AC·PD 패턴 반복).** PH reverse가 1차 예측한 "distinct 0(facet)·미확정(SSR-negative 블로커)"를 **§0.5 client-render 재캡처(gstack browse 2026-06-17)가 블로커 해소 후 적대 판정으로 비준** — 가장 distinct로 *보이던* 완제 액자(인쇄물 + 별도 프레임 2-파트 조립)조차 17축 무손실 흡수. ★directive 최대 관전(완제 프레임·마운팅/거치·전면 보호재=distinct #18인가) 적대 판정: **PH-1 완제 프레임=완제SKU#4(거치+마감+사이즈 인코딩)+자재#1 variant+생산형태#15 · PH-2 거치=옵션#3 캐스케이드 상위 차원(RESOLVED OBSERVED)·전면재=자재#1 내재·후면받침=부속물#8(미관측) · PH-3 인화지×마감=자재#1 surface-finish · PH-4 set 단위=수량#10+완제SKU#4 · PH-5 머그·화분=카테고리#7 다중분류 · 형태(일반/정사각/파노라마)=사이즈#13 비율 프리셋(형상#17 부결).**

## PH-1. 완제 액자 = "인쇄물을 끼우는 빈 프레임(2-파트 완제 그릇)" — 완제SKU#4 + 자재#1 프레임재질 variant + 생산형태#15 [distinct #18 거부] ★directive 핵심 의사결정

- **판정:** **분산 facet/variant — distinct "완제 그릇/마운팅 축 #18" 거부.** 액자(PHFR* 11종)는 AC(아크릴 본체 직접 인쇄)·GS(완제굿즈)와 달리 *인화물을 사후에 끼우는 빈 프레임*(2-파트 완제 구조)이나, **§0.5 client-render 재캡처**가 거치+마감+사이즈를 **완제 SKU combobox 1개에 인코딩**(PHFRDIA 탁상용유광 127X177 ~ 벽걸이유광 1000X1000)함을 OBSERVED — AC 두께/소재 variant·GS 완제 본체 SKU(G-1)와 동형 구조.
- **★양면 트레이드오프 펼침(침묵 선택 금지) — discovered-axes PH-1 참조:**
  - **(가) distinct "완제 그릇/마운팅 축 #18" 신설:** 찬성=완제 프레임은 인쇄 본체가 아니라 *인쇄물을 담는 그릇*(역할 역전)·"인쇄물 + 별도 프레임 조립" 2-파트 완제 구조가 단일 자재/단일 본체와 다름·거치(탁상/벽걸이)가 액자의 핵심 정체축. 반대=★세 기존 축 무손실 분담·거치는 옵션 캐스케이드로 구현(별 그릇 없음).
  - **(나) 완제SKU#4 + 자재#1 프레임재질 variant + 생산형태#15(C 완제품) 분산 facet [채택]:** ① 거치+마감+사이즈가 *완제 SKU 라벨 1개*(combobox 값)로 등장 = 템플릿/완제SKU#4(GS 완제 본체 SKU G-1 "미르 화이트 20oz" 라벨 융합 동형·AC 완제 받침 SKU 12 동형). ② 프레임재질(한나무/애쉬/원목/알루미늄/종이/아크릴/디아섹)=자재#1 variant(AC 소재 variant·ST 점착소재 spectrum 동형·pdtCode 분기 = GS 코스터 6 pdtCode·G-2 동류 카탈로그 정책). ③ "완제 프레임에 인쇄물 끼움" 성격=생산형태#15(C 완제품 governing·본체=완제 SKU vs 자재행 결정).
- **★ST 형상(#17)과의 결정적 차이(역방향 오류 점검·HARD 기준):** ① 전용 슬롯 라이브 실재? = **거치 버튼 토글 OBSERVED**(§0.5·미싱데이터 해소·✅ 충족). ② 후니 KB가 "기존 축이 못 담음" 결함 명시? = **없음**(❌ 불충족) — 완제SKU#4·옵션#3·자재#1 variant가 왜곡 없이 담음·형상#17의 G-SK-2("형상 어느 축에도 없음") 같은 KB 결함 부재. **둘 다 충족해야 승격 → ②가 불충족 → distinct #18 부결**(facet/variant). 형상은 둘 다 충족(승격), 완제 그릇은 ①만 충족(부결) = 결정적 분기. **역방향 오류(distinct를 facet으로 숨김) 점검:** "2-파트 완제 그릇"이 유일 잔여 후보였으나 완제SKU#4(거치+마감+사이즈 인코딩 = AC variant·GS 완제SKU 동형)의 facet으로 무손실 흡수 → facet 정당(숨김 아님·새 관리 관심사 없음).
- **메타모델 해소:** ✅ 완제SKU#4 + 자재#1 프레임재질 variant + 생산형태#15 분산 facet 귀속 확정(#18 부결). **검증 필요분: 거치방식 캐스케이드(옵션#3 polymorphic ref)·거치+마감+사이즈 완제 SKU variant 그릇 매핑 → gap(data-gap 적재·축 부재 아님).**

## PH-2. 마운팅/거치(탁상용/벽걸이)·전면 보호재(유리/아크릴)·후면 받침 — 거치=옵션#3 캐스케이드 상위 차원(RESOLVED) + 전면재=자재#1 내재 + 후면받침=부속물#8(미관측) [distinct #18 거부] ★블로커 해소

- **판정:** **거치=옵션#3 캐스케이드 상위 차원 facet (distinct "마운팅 축 #18" 거부·RESOLVED OBSERVED).** §0.5 PHFRDIA에서 **거치방식(탁상용/벽걸이)이 버튼 토글로 OBSERVED** — reverse 1차의 "unobserved(SSR-negative)" 블로커가 해소됨(Vue 지연 렌더가 SSR-negative 원인 확정). 단 거치는 *별 메타모델 축이 아니라 옵션 캐스케이드 상위 차원*: 거치방식(탁상용/벽걸이) → 마감(유광/무반사/자작나무) → 완제 SKU 사이즈(탁상용=소형 3종·벽걸이=대형 15종) → 수량. 거치방식 토글 시 마감 prefix·사이즈 풀이 통째로 교체 = 옵션#3 polymorphic cascade(AC GRP_OPTION_CD 가공방식→자재 subset 게이팅 A-8·G-4 채널 동형).
- **★전면 보호재(유리/아크릴) = 자재#1 내재/facet:** §0.5 — 마감 combobox는 표면처리(유광/무반사/자작나무)만 노출·**전면 보호재 별도 옵션 select 미관측**. 디아섹은 전면재가 *상품 내재*(아크릴 마운팅)이므로 전면 보호재는 별도 축 아님(자재#1 내재 또는 마감 facet). 유리/아크릴 전면이 별도 선택인 다른 액자(한나무/멀티)는 미캡처(`unobserved`·날조 금지) — 관측분(디아섹)은 자재 내재.
- **★후면 받침 = 부속물#8 후보(미관측):** §0.5 별도 옵션 미관측. 도메인상 후면 받침/이젤은 AC 등신대 받침·BN 거치대(D-1 부속물#8) 동형 후보이나 라이브 미노출 → `unobserved` 정직 표기(추정 승격 0).
- **★distinct #18 판정:** 거치가 OBSERVED(실재)되었으나 **옵션 캐스케이드 상위 차원(거치방식 → 완제 SKU variant)으로 구현** → 별 신규 메타모델 축 아님(PH-1 HARD 기준 ② 불충족 동일). 거치=옵션#3·완제 SKU=완제SKU#4가 왜곡 없이 담음.
- **메타모델 해소:** ✅ 거치=옵션#3 캐스케이드 상위 차원·전면재=자재#1 내재 귀속 확정(#18 부결). **검증 필요분: 거치 캐스케이드 polymorphic ref 매핑(옵션#3)·전면 보호재가 별도 옵션인 액자(한나무/멀티 미캡처)·후면 받침(부속물#8 후보)은 unobserved → gap/validation(라이브 재캡처 또는 후니 도메인 권위).**

## PH-3. 인화지(자재) vs 마감(공정) 경계 — 인화지×마감 합성 = 자재#1 surface-finish facet [distinct 거부] ★ST S-4·AC A-2 동형

- **판정:** **자재 축(#1)의 surface-finish 합성 차원 facet (별 "마감 공정 축" 거부).** §0.5 PHPTEDT 자재 combobox = "인화용지(반광-러스터) / 인화용지(유광)" — *인화지(자재) + 마감(반광/유광)을 한 combobox 값에 합성*(reverse §0.3 1차 예측 입증). PHPTPRM "유광(Glossy)_캐논전용지" 동형. 마감은 별 공정 멤버가 아니라 *인화지 매체에 종속된 표면 특성*(ST 점착/내후 S-4·AC 글리터/거울 A-2 surface-finish 합성 차원과 동근).
- **★자재 surface-finish vs 공정 경계(미세 판정):** 사진인화 "유광/반광/스노우"는 *인화지 자체의 표면 특성*(매체 종속·인화 시점에 매체로 결정)이므로 자재 surface-finish facet 우세(BN 코팅=후가공 공정과 다름 — 코팅은 인쇄 후 별 공정 적용·마감은 매체 선택). 단 합성 인코딩("유광_캐논전용지")은 후니 정규화 시 `{ptt(캐논전용지/스노우/홀로그램), surface_finish(유광/반광/무광)}` 분해 필요(ST 점착 `adhesion_grade`·AC `surface_finish` 합성축과 동근·평면 라벨 금지).
- **근거:** ST S-4 "점착/내후=자재#1 합성 차원(`adhesion_grade`/`weather_grade`)"·AC A-2 "surface-finish=자재#1 합성 차원"·`entity-semantic-model.md:51-53` "색상/두께 variant→material" 원칙 동형. 후니 자재모델에 surface-finish 합성 차원 부재=ST/AC가 드러낸 동일 갭(V-3 자재 합성 차원 그릇·갭분석가 합류).
- **메타모델 해소:** ✅ 자재#1 surface-finish facet 귀속 확정. **검증 필요분: 인화지×마감 합성 분해 그릇(`{ptt, surface_finish}`·ST/AC V-3 합류) → gap/vessel.**

## PH-4. set/sheets 단위 수량(600매·4sheets·5sheets) — 수량모델#10 set 배수 + 완제SKU#4/기초코드#6 base_quant facet [distinct 거부] ★GS 완제 base_quant 동형

- **판정:** **수량 모델 축(#10) set 배수 + 완제SKU#4/기초코드#6 base_quant facet (별 축 거부).** 증명사진600/포켓사진600(=600매 set)·판스티커-노브랜드(4sheets)·스퀘어(5sheets) = *매수/sheets 묶음이 상품명에 인코딩된 고정 set 단위*(1주문=1 set). GS 텀블러(it_g_base_quant=1·완제) 동형 — set 단위 = `it_g_base_quant` 인코딩.
- **★양면(set=수량 vs set=템플릿 SKU):** ① set을 수량모델#10 슬롯(set 배수·printCnt)으로 볼 수 있고 ② 고정 set(600매 묶음 1단위)을 완제SKU#4 base_quant(GS 완제 base_quant 동형)로 볼 수 있음 — 둘 다 기존 축 facet(별 축 아님). RP는 상품명 인코딩(고정 set)이므로 base_quant 우세·수량은 set 배수.
- **근거:** 수량모델#10(건수×매수 이중 수량·PHPTPRM 디자인수+수량)·`it_g_base_quant`(기초코드#6·GS 완제 동형). set 단위=base_quant 인코딩이지 새 관리 관심사 아님.
- **메타모델 해소:** ✅ 수량#10 set 배수 + base_quant facet 귀속 확정. **검증 필요분: set base_quant 그릇(`it_g_base_quant`·GS 동형) 적재 → gap(data-gap).**

## PH-5. PHMG/PHPO(머그·화분)의 PH vs GS 귀속 — 카테고리#7 다중분류 facet [distinct 거부] ★GS 코드접두≠본질 동형

- **판정:** **카테고리 축(#7) 다중분류 facet (distinct 거부).** PHMGDFT(머그)·PHPODFT(화분)은 category=PH(출력매체=사진굿즈)이나 cate=디지털인쇄>컵&홀더(물성·PHPODFT 실측)·본질=전사인쇄 완제굿즈(GS GSTTDTM 코스터·텀블러 동형). "코드접두≠카테고리 본질"(GS 코스터 동형). 출력매체(사진굿즈) ⊥ 물성(컵&홀더) **다중분류**(GS 횡단 다중분류 패턴 동형).
- **근거:** 카테고리#7 다중분류(GS G-2 코스터 소재 pdtCode 분리·물성 vs 기능 직교)·"출력매체로 묶느냐 물성으로 묶느냐"는 메타모델 판정이 아닌 **후니 카탈로그 정책 결정**(갭분석가/실무) — 메타모델은 둘 다 표현 가능(다중분류 노드).
- **메타모델 해소:** ✅ 카테고리#7 다중분류 facet 귀속 확정. **검증 필요분: 출력매체 vs 물성 다중분류 정책(GS G-2 동형·정책 결정) → gap/실무.**

## PH-6. ★형태(일반/정사각/파노라마) — 사이즈#13 비율 프리셋 흡수 facet [형상#17 부결] ★형상축 강제 금지·PD-3 동형

- **판정:** **사이즈 축(#13) 비율 프리셋 흡수 facet (distinct "형상 축 #17" 적용 거부).** §0.5 PHPTEDT에서 **형태(일반/정사각/파노라마)가 버튼 토글로 OBSERVED** — 이는 인화 *비율(aspect ratio)* 프리셋(일반=3:2·정사각=1:1·파노라마=와이드)이지 ST 형상(SQ/CL/EL/RC/FR)의 외곽 칼틀 형상 enum이 아님.
- **★ST 형상(#17) [HARD] 경계 적용:** 형상이 사이즈와 **1:1**이면 사이즈 프리셋에 흡수(형상축 강제 금지=오모델 회피)·**1:多** 분리가 명시 슬롯으로 드러나면 별 분류축(#17). PH 형태는 형태→사이즈 1:1(정사각=특정 정사각 치수 프리셋·파노라마=와이드 치수 프리셋·전용 shape_info 슬롯 없음·치수 combobox와 융합) → ST 1:多(한 형상 CL이 CL001~CL100 칼틀 enum span) 미충족 → 사이즈#13 흡수 정당(BN 어깨띠·GS THO_CUT·TP M/I·PR 카드형·PD 단수/형상 동형).
- **근거:** dictionary #13/#17 [HARD] 경계·PD-3 "스툴 원형↔305×305 1개=ST 1:多 미충족" 동형. PH 형태=비율 프리셋(1:1)이므로 형상축 #17 부결·사이즈#13 흡수.
- **메타모델 해소:** ✅ 사이즈#13 비율 프리셋 흡수 귀속 확정(형상#17 부결). **검증 필요분: 형태→사이즈 비율 프리셋 그릇(사이즈#13 enum) 적재 → gap.**

---

## PH 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| PH-1 ★완제 프레임(인쇄물 끼우는 빈 그릇) | **완제SKU#4(거치+마감+사이즈)+자재#1 프레임재질 variant+생산형태#15** | §0.5 거치/마감/사이즈=완제 SKU combobox 1개 인코딩·AC variant·GS G-1 동형·후니 KB 결함 없음·HARD ② 불충족 | **분산 facet/variant(거부·#18 부결)** ★강후보 | #4·#1·#15 | 거치 캐스케이드 polymorphic ref·완제 SKU variant → gap(data-gap) |
| PH-2 ★마운팅/거치·전면 보호재·후면 받침 | **거치=옵션#3 캐스케이드 상위 차원(RESOLVED)·전면재=자재#1 내재·후면받침=부속물#8(미관측)** | §0.5 거치(탁상용/벽걸이) OBSERVED·옵션 캐스케이드 구현·전면재 디아섹 내재·후면받침 unobserved | **facet(거부·#18 부결)** ★블로커 해소 | #3·#1·#8 | 거치 캐스케이드·전면재 별옵션 액자·후면받침 unobserved → gap/validation |
| PH-3 인화지(자재) vs 마감(공정) | 자재#1 surface-finish 합성 | §0.5 "인화용지(반광-러스터)/유광" 합성 입증·ST S-4/AC A-2 동형·마감=매체 종속 | facet(거부) | #1 | 인화지×마감 분해 그릇({ptt,surface_finish}·ST/AC V-3) → gap/vessel |
| PH-4 set/sheets 수량(600매·4/5sheets) | 수량#10 set 배수 + 완제SKU#4/기초코드#6 base_quant | 상품명 인코딩 고정 set·1주문=1 set·GS 텀블러 base_quant 동형 | facet(거부) | #10·#4·#6 | set base_quant 그릇(GS 동형) → gap(data-gap) |
| PH-5 PHMG/PHPO(머그·화분)=PH vs GS | 카테고리#7 다중분류 | 출력매체(PH)⊥물성(컵&홀더)·GS 코드접두≠본질·다중분류 | facet(거부) | #7 | 출력매체 vs 물성 다중분류 정책(GS G-2) → gap/실무 |
| PH-6 ★형태(일반/정사각/파노라마) | 사이즈#13 비율 프리셋 흡수 | §0.5 OBSERVED·비율(aspect ratio) 프리셋·형상↔사이즈 1:1·ST 1:多 미충족·PD-3 동형 | **facet(거부·형상#17 부결)** ★형상축 강제 금지 | #13 | 형태→사이즈 비율 프리셋 그릇 → gap |

**PH 강제 분류 회피(SKILL §3·§5):** **distinct 승급 0건(★완제 액자 그릇/마운팅 PH-1·PH-2 #18 부결) = 17축 재포화(PR 4번째·CL 6번째·AC 7번째·PD 8번째 distinct 0 패턴 반복).** 6 fragment(PH-1~PH-6) 전부 기존 17축 facet/family/cascade/정책. ★directive 최대 관전(완제 프레임·마운팅/거치·전면 보호재가 distinct #18인가) 적대 판정: ① 완제 프레임=완제SKU#4(거치+마감+사이즈 인코딩)+자재#1 프레임재질 variant+생산형태#15(AC variant·GS 완제SKU G-1 동형) · ② 거치(탁상용/벽걸이)=옵션#3 캐스케이드 상위 차원(★§0.5 RESOLVED OBSERVED·블로커 해소·옵션 구현이지 별 그릇 아님)·전면재=자재#1 내재(디아섹 상품내재) · ③ 인화지×마감=자재#1 surface-finish(ST S-4/AC A-2 동형) · ④ set 단위=수량#10+완제SKU#4 base_quant(GS 동형) · ⑤ 머그·화분=카테고리#7 다중분류(GS 동형) · ⑥ 형태(일반/정사각/파노라마)=사이즈#13 비율 프리셋 흡수(★형상#17 부결·1:1·형상축 강제 금지). **★재포화 정당성(HARD 기준 양방향 점검):** 형상(#17·ST)은 후니 KB G-SK-2 "어느 축에도 없음" 결함이 distinct 강제(① 전용 슬롯 + ② KB 결함 둘 다 충족·승격)했으나, PH 6 fragment(완제 프레임·마운팅 포함)는 **① 전용 슬롯 OBSERVED(거치 버튼 토글)되었으나 ② 후니 KB 결함 명시 없음**(완제SKU#4·옵션#3·자재#1·사이즈#13이 왜곡 없이 담음) → ②가 불충족 → distinct 0 정직. §0.5 재캡처가 블로커를 OBSERVED로 해소했음에도 거치가 옵션 캐스케이드 + 완제 SKU variant로 구현됨이 실측 → facet 결론이 미싱데이터 해소 후에도 강화. 9번째 카테고리(완제 액자/출력매체)가 새 관리축 0 도입 = 모델 안정성 재확인(가장 distinct로 보이던 2-파트 완제 그릇·directive 최대 관전 마운팅/거치도 무손실 흡수).
**PH가 더한 것(축 신설 아닌 *강화*):** ① **17축 재포화** — 9번째 카테고리 distinct 0(PR·CL·AC·PD 패턴 반복). ② 완제SKU#4 "거치+마감+사이즈 인코딩 완제 SKU combobox" 강화(AC 두께/소재 variant·GS 완제 본체 SKU G-1 합류·라벨 융합 분해 처방). ③ 자재#1 프레임재질 variant 확장(한나무/애쉬/원목/알루미늄/종이/아크릴/디아섹·AC 소재 variant 합류)·인화지×마감 surface-finish(ST S-4/AC A-2 합류·V-3). ④ 옵션#3 "거치방식 캐스케이드 상위 차원" 강화(거치→마감→완제SKU사이즈→수량·AC GRP_OPTION_CD cascade 동형). ⑤ 사이즈#13 비율(aspect ratio) 프리셋 흡수 입증(형상 1:1·형상#17 강제 금지 재확인·PD-3 합류). ⑥ 제약#5 [재고부족]disable(§0.5 PHPRDFT OBSERVED·ST disable·AC 명찰 cascade 합류). ⑦ 카테고리#7 출력매체 vs 물성 다중분류(GS G-2 합류). ⑧ 가격#11 tmpl/digital_price 라우팅·생산형태#15 완제품 governing 재확인.
**검증 라우팅 요약:** 메타모델 해소 ✅ = PH-1·PH-2·PH-3·PH-5·PH-6(축 귀속 확정·거치 블로커 §0.5 RESOLVED) / 부분 🟡 = PH-4(set base_quant unobserved 상세). 라이브/엑셀 검증 필요분 = 거치 캐스케이드 polymorphic ref 매핑(PH-1/PH-2 → gap data-gap)·전면 보호재 별옵션 액자(한나무/멀티 미캡처)·후면 받침 부속물#8(PH-2 → unobserved 재캡처)·인화지×마감 surface-finish 분해 그릇(PH-3 → V-3 ST/AC 합류)·포토북 면수/제본 client-render(PHBK* 미캡처). **★PH-1/PH-2 = data-gap(완제 SKU/거치 캐스케이드 그릇 미적재)이지 vessel-gap(축 부재) 아님 — 갭분석가 핵심 구분(PD-4 data-gap·AC A-3 PASS 동형).**

---

# FS(패브릭·봉제 완제 직물 굿즈) fragment 판정 (v10.0 — 면직물·타일링·마감봉제·완제 부자재)

> `categories/FS/reverse.md`의 FS-1~FS-8 판정. **10 상품군(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS) 증거.** ★directive 1순위 = 타일링(FS-1) distinct #18 적대 판정. 과잉 일반화 경계(SKILL §5): FS 한 군만의 특이는 facet 강등. distinct 승급 = 10 상품군 견디는 governing/lifecycle + 후니 KB 결함(무왜곡 흡수 불가) 둘 다 충족 시만.
> 도메인 정초 = `07_domain/{entity-semantic-model.md(plate_size 임포지션/판걸이 #6·자재 usage·두께=자재),pdf-domain-knowledge.md(조판/임포지션 §4-2·판걸이=원판당 작업물 개수)}` + PD/CL/AC/BN/GS 직접 대조. domain-researcher 신규 호출 불요(타일링=인쇄 배치/조판 파라미터·면직물=자재 PTT·면사 수=WGT 번수·마감봉제=공정 전부 후니 KB에 확정 존재).

## FS-1. ★타일링(TILL_WH_GBN 없음/세로/가로) — 공정#2 인쇄 배치 파라미터#9 [distinct #18 부결] ★directive 1순위 핵심 의사결정

- **판정:** **공정#2 인쇄 배치(조판/임포지션) 파라미터(#9 종속) facet. distinct #18 거부.**
- **양면 트레이드오프 펼침(침묵 선택 거부):** discovered-axes FS-1 참조 — (가) 별도 "타일링/반복 배치 축 #18" 신설 vs (나) 공정#2 인쇄 배치 파라미터 facet. **(나) 채택.**
- **★ST 형상(#17)·PH 거치와 같은 HARD 양방향 기준 적용:** ① 전용 슬롯 라이브 실재(TILL_WH_GBN 명시 라디오·5상품 전수 OBSERVED=**충족**) + ② 후니 KB가 기존 축으로 무왜곡 흡수 불가(결함)=**불충족** → distinct 0.
  - **① 충족:** TILL_WH_GBN(TIL_NON/TIL_HGH/TIL_WDT)이 BN/GS/TP/PR/ST/CL/AC/PD/PH 전 9 카테고리 어디에도 없던 *전용 라디오 슬롯*·5상품 전수(`[live:SSR]`). ST 형상 shape_info처럼 "전용 슬롯=distinct 신호" 형식 충족.
  - **② 불충족(결정적):** 후니 KB `plate_size`(#6·`entity-semantic-model.md:27` "작업/전지 판형·**임포지션·판걸이**·돔보")·`pdf-domain-knowledge.md:146` "조판(임포지션)=작업물을 원판에 판걸이 개수만큼 앉히는 행위"가 *인쇄 배치를 이미 1급 모델링*. 타일링(직물 풀프린팅 세로/가로 반복 배치)=그 배치 차원의 고객 선택값이 공정#2 인쇄 배치 파라미터(#9·접지 FLD_DFT 면분할·오시 줄수·UV 변형 동근)로 *왜곡 없이 담김*. 후니 KB에 "패턴 반복/배치 어느 축에도 없음" 같은 결함 명시 **없음**(ST 형상 G-SK-2 "형상 어느 축에도 없음" 결함과 정반대) → ②불충족.
- **★핵심 경계(HARD) — 타일링 ≠ 판걸이수:** 타일링은 *고객측 디자인 반복 배치 입력 파라미터*(없음/세로/가로 라디오·공정 파라미터#9 등재)이고, **판걸이수(imposition count)=앱 계산 파생값**(`pdf-domain-knowledge.md:149` "판걸이=원판당 앉히는 작업물 개수"·메모리 `dbmap-compute-in-app-db-stores-lookup` "판걸이수=앱계산 DB미저장·파라미터에 넣지 말 것"). 임포지션=N개 *다른* 작업물을 한 원판에(다도안 판걸이), 타일링=한 디자인 *반복* 배치(직물 면 채움)·둘 다 plate_size/조판 도메인의 facet이나 — 타일링=입력 파라미터(등재), 판걸이수=그 입력+사이즈로 앱이 계산하는 파생값(DB 미저장·등재 금지). **★타일링은 입력이므로 공정 파라미터#9로 등재(판걸이수처럼 앱계산 파생값과 혼동 금지).**
- **역방향 오류(distinct를 facet으로 숨김) 점검:** "전 9 카테고리 미관측 전용 슬롯"이 유일 잔여 후보였으나 plate_size(#6 임포지션)·공정 파라미터(#9 접지/오시)가 인쇄 배치를 왜곡 없이 담음 → facet 정당(숨김 아님·새 관리 관심사 없음). 가격 영향(반복=인쇄 면적/방식 변화)은 모든 공정 파라미터가 가짐(가격기여역할#11)이지 distinct 사유 아님·unobserved(infoCall 후행).
- **메타모델 해소:** ✅ 공정#2 인쇄 배치 파라미터#9 귀속 확정(distinct #18 부결). **★RP가 타일링을 공정 배치 라디오로 둠 = data-gap(후니가 직물 타일링 취급 시 공정#2 인쇄 배치 파라미터#9에 적재해야 할 반복 배치 선택을 미적재)이지 vessel-gap(축 부재) 아님** — 갭분석가 핵심 구분(PD-4 data-gap·PH-1/PH-2 동형). **검증 필요분: 타일링↔가격(반복 배치 가산) infoCall 캡처 → gap/validation.**

## FS-2. 방향(PAPER_WH W/H) — 사이즈#13 방향 facet [distinct 거부]

- **판정:** **사이즈 축(#13)의 방향 facet. distinct 거부.**
- **근거:** FSSQPST PAPER_WH=W(가로)/H(세로)(`[live:SSR]`)=본체 직물 방향(가로/세로 치수 매핑). 사이즈 직접입력 시 가로/세로 치수 입력(icon_txt "가로"·"세로"). entity-semantic #1 size=재단치수의 방향 facet. **★타일방향(TILL_WH_GBN)과 분리 슬롯 = 방향(본체)≠타일방향(패턴):** PAPER_WH=본체 직물의 가로/세로(사이즈#13), TILL_WH_GBN=디자인 패턴 반복 방향(공정#2 배치 param·FS-1) — 둘은 다른 의미축(본체 방향 vs 패턴 반복 방향)·분리 슬롯 정당.
- **메타모델 해소:** ✅ 사이즈#13 방향 facet 귀속 확정.

## FS-3. 면직물 자재(면사 수 PXFBW0NN) — 자재#1 PTT 직물 + WGT 다의(번수) [distinct 거부]

- **판정:** **자재 축(#1)의 PTT 직물 차원 + WGT 슬롯 다의(번수). distinct 거부.**
- **근거:** 면10수/20수/40수/60수 화이트(MTRL_CD=PXFBW0NN·FB=fabric·W=white·NN=수)=비종이 면직물(cotton)·면사 수=직물 굵기/질감 차원이 종이 평량(g/m²)·아크릴 두께(mm·AC A-1)·CL oz·PD 번수와 같은 WGT 슬롯 다의. entity-semantic #2 "두께=자재 식별자" 원칙의 직물판. AC/CL/PD 비종이 자재 합류(별 "면사 축" 거부).
- **모호 지점(갭분석가):** 후니 자재모델(지종×평량 g/m²)이 직물의 *물성 차원*(면사 수·신축성·짜임)을 담는가 = round-22 굿즈 본체소재 부재 결함과 연결. `measure_type`(평량/두께/oz/번수) 구분 vessel 검토(AC A-1 합류).
- **메타모델 해소:** ✅ 자재#1 PTT/WGT 다의 귀속 확정. **검증 필요분: 직물 물성 차원 그릇(measure_type) → gap/vessel.**

## FS-4. 별색(SID_FBR 6색×3농도) — 공정#2 별색 family + 기초코드#6 색 enum [distinct 거부]

- **판정:** **공정 축(#2)의 별색 family + 기초코드#6 색 도메인. distinct 거부.**
- **근거:** clr_info_SID_FBR 6색(BLK/WHT/RED/YEL/SKY/GRE)×DF001/002/003 농도(`[live:SSR]`)=패브릭 별색(spot color) 직물 날염. round-22 경계규칙 "별색=공정"(PROC_000007 family·HARD)·CL Pantone 1124와 같은 공정#2 별색 그릇. **★색 enum이 직물 날염 6 기본색 제한 도메인**(ST/PR/CL 전체 Pantone과 다른 모집단·6×3 농도)=기초코드#6 색 도메인 거버넌스 관점(별색 라이브러리가 매체별 다름)이나 *축은 공정#2*. **★별색을 도수/자재로 오적재 금지(HARD).**
- **메타모델 해소:** ✅ 공정#2 별색 family 귀속 확정(CL Pantone 축소 도메인).

## FS-5. 마감봉제(SEW_FBR)·제품가공(PDT_WRK 상품별 명칭)·FBR-접미 슬롯 — 공정#2/형태가공#14 family [distinct 거부]

- **판정:** **마감봉제=공정#2 봉제 family·제품가공=본체형태가공#14 family·라벨/끈/포켓/자석=자재+공정 BUNDLE(부속물#8). distinct 거부.**
- **근거:** SEW_FBR(오버로크 RNDFT/말아박기 RNRIN/작은마감 RNSML/벨크로 RNVEL·icon_txt "얇은오버로크2mm/두꺼운오버로크4mm/말아박기1cm")=직물 *가장자리 마감(edge finish)* 봉제 = PD SEW_LTR(레더재봉)·CL 봉제 동형 공정#2 봉제 family 멤버. PDT_WRK(쿠션/에코백/파우치/스크런치 가공)=본체형태가공#14(GS PDT_WRK·PD 동형).
- **모호 지점 해소(FS-5·PD-1 합류):** PDT_WRK가 상품마다 다른 icon_txt(쿠션가공≠에코백가공)인데 **DB상 동일 PCS_COD(PDT_WRK)·상품별 라벨/단가 인스턴스** — 후니 공정모델은 "동일 형태가공 슬롯(PDT_WRK)·상품별 가공 인스턴스(라벨/단가/공정 레시피)"로 관리(공정 유형 enum=PDT_WRK, 인스턴스=상품별 봉제 레시피). 별 "제품별 가공 축" 아님(동일 슬롯·GS/PD/FS 횡단).
- **메타모델 해소:** ✅ 공정#2 봉제 family + 형태가공#14 family 귀속 확정. LAB_FBR/LIN_PRT/POC_FBR/WRK_MTR=자재(라벨/끈/자석)+공정(부착)+부속물#8 BUNDLE(AC/ST/PD SUB_MTR 동형·FS-6).

## FS-6. 솜 충전(SUB_MTR TN001)·끈·자석·라벨·포켓(완제 부자재) — 자재#1 sub_mtrl + 부속물#8 선택형 [distinct 거부]

- **판정:** **자재 축(#1) sub_mtrl(솜) + 부속물 축(#8) 선택형(옵션 노출) facet. distinct 거부.**
- **근거:** 쿠션 솜(TN001 사각쿠션솜·선택안함 가능)=충전 자재 sub_mtrl(usage)·끈(LIN_PRT)/자석(WRK_MTR·AC 동형)=부속물#8·라벨/포켓=자재+공정#2(부착 봉제) BUNDLE. PD-4 완제 내재BOM(솜/지퍼=자재 sub_mtrl·다리/논슬립=부속물#8) 동형.
- **★directive 핵심(PD-4 합류) — 선택형 vs 고정 부자재:** FS 직물 굿즈 부자재(솜/끈/자석)는 PD-4 고정 부속(다리/논슬립=옵션 미노출·ESN=Y·view_yn=N)과 달리 **일부가 옵션 노출**(솜 선택안함·끈 커스텀·view_yn=Y) → "완제 부자재가 옵션이냐 고정BOM이냐"가 상품별 분기. = 부속물#8이 (a)고정 부속(PD-4·AC 받침 ESN=Y) (b)선택형 부자재(FS 끈/자석/솜 view_yn=Y) 두 *노출 모드*를 가짐(필수성×노출 차원 facet)이지 새 축 아님. 후니 `t_prd_product_addons`(완제 부속)·옵션 노출 경계(ESN_YN·view_yn)가 "선택형 vs 고정 부자재" 그릇으로 담음.
- **메타모델 해소:** ✅ 자재#1 sub_mtrl + 부속물#8 선택형 facet 귀속 확정. **검증 필요분: 부속물#8 노출 모드(ESN_YN·view_yn) 그릇 → gap(data-gap).**

## FS-7. 가격모델 분기(real_price 포스터 vs real_calc_price 봉제완제) — 가격#11 라우팅 [distinct 거부]

- **판정:** **가격기여역할 축(#11)의 가격모델 라우팅. distinct 거부.**
- **근거:** FSSQPST=real_price(패브릭 현수막·면적·BN/실사 동형)·나머지4=real_calc_price(완제 봉제 굿즈·실계산)(`[live:SSR]`). PD(tmpl_price 완제 SKU)와 다른 면적/실계산 — 가격모델 다양성=도메인 현실(매체/생산형태로 라우팅). 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형) 정합.
- **메타모델 해소:** ✅ 가격#11 라우팅 귀속 확정(완제 봉제 굿즈도 real_calc_price). **검증 필요분: real_price↔real_calc_price 차이(면적 함수·가산 규칙) infoCall 캡처 → 가격검증/갭.**

## FS-8. PCS 상세 enum·단가·infoCall 가격 결합 — unobserved [축 판정 무영향]

- **판정:** **unobserved — 축 판정 무영향(SSR 슬롯/라디오/체크박스로 distinct 0~1 확정).**
- **근거:** PDT_WRK/SUB_MTR/SEW_FBR/타일링 상세 enum·단가는 infoCall AJAX 후행이라 SSR 미노출. 메타모델 핵심 판정(타일링 distinct #18 부결·17축 재포화)은 SSR 슬롯만으로 확정. 라이브 infoCall 캡처(node monitor)로 보강 가능(이번 세션 미수행·날조 금지).
- **메타모델 해소:** 🟡 부분(축 귀속 확정·단가/enum 상세 unobserved). **검증 필요분: infoCall 캡처(타일링/마감봉제/솜 단가) → gap/validation.**

---

## FS-A1. ★패널 구성(cut-and-sew panel semantics) — codex 제기 distinct #18 강도전 [unobserved-pending → 부결] ★Phase 4.5 적대 재검증

> **출처:** `categories/FS/deepcheck.md` 핵심 도전 — codex(gpt-5.5): "TILING보다 더 위험한 누락 후보는 **cut-and-sew construction / panel semantics**(앞판/뒤판/옆판/안감/손잡이/심지/충전재를 따로 자르고 봉제하는 순간 종이 인쇄식 17축이 갈라진다)." front/back/side/gusset/handle/label 면별 독립 디자인·원단·공정 = 봉제완제 굿즈가 면(panel)별 독립 아트워크/소재/공정을 가진다는 주장. 우리 "봉제완제=카테고리#7·봉제=공정#2·풀프린팅 단일면" 부결에 대한 반론.

- **판정:** **부결 — distinct #18 아님. facet 클러스터(디자인입력채널#16 다중면 + 자재#1 usage 안감/심지 + 공정#2 봉제/포켓 + 부속물#8 끈/자석/라벨).** ★FS-1 타일링과 별개의 codex 신규 도전이나 동일 결론.

- **★① 전용 슬롯 라이브 OBSERVED 검증 (승격 1조건) — UNOBSERVED → pending:**
  - **FS reverse 실측(2026-06-19 `[live:SSR]` 5상품 전수·legacySelects 44~61)에 면별(panel) 독립 디자인 입력 슬롯 부재.** FS 정체 = **면직물에 *풀프린팅*(단일면 래핑) 후 재단·봉제·마감**(reverse §0·§7 명시). 디자인 입력은 *단일 풀프린팅 업로드* — front_design/back_design/side/gusset/handle/label 분리 디자인 슬롯이 SSR productOrder에 **관측되지 않음**(panel_info·면별 디자인 라디오/select 0건).
  - **쿠션 양면(`sodu`=SID_D)이 유일한 "두 면" 신호이나 면별 디자인 슬롯 아님** — `sodu`는 단일 **도수(기초코드#6) 토글**(단면/양면)이지 앞면-디자인 vs 뒷면-디자인 분리 업로드가 아니다(reverse §0.2 "쿠션 앞뒤 두 면을 봉제해 양면 인쇄"=도수 차원 1슬롯). 양면 인쇄여도 디자인 입력은 단일 풀프린팅.
  - **codex 인용=산업추론(미관측):** deepcheck 명시대로 codex 외부 출처(Contrado fabrics/tote/wall-hanging·FTC)는 **codex 자체 인용이며 본 하네스 미검증**. RP FS 라이브 슬롯이 권위 — Contrado류 "패널별 독립 디자인 업로드 UI"는 RP FS에 *실재하지 않음*(라이브 읽기전용 재확인: curl 직접 GET이 WAF로 0바이트 차단되나 reverse가 gstack 인증 GET으로 44~61 legacySelects 전수 실측한 것이 권위·panel 슬롯 부재 확정).
  - **→ ① UNOBSERVED.** PH H-1(content-container)·PD-4(완제 내재BOM) unobserved-pending 패턴과 동일 — 면별 독립 슬롯이 라이브에 없으므로 ①불충족.

- **★② 후니 KB 무왜곡 흡수 불가 검증 (승격 2조건·①충족 시에만 적용이나, 보강 판정) — 흡수 가능(결함 없음):**
  - codex가 든 "면별 독립 디자인·원단·공정"의 *각 부분*은 RP FS가 실제 쓰는 만큼은 전부 기존 축이 왜곡 없이 담음:
    - **면별 디자인(만약 노출된다면)** = 디자인입력채널#16의 *다중면 facet*(TP 에디터 채널이 면/페이지를 캔버스로 다루는 것의 직물판·T-A 템플릿자산·VDP T-B와 동근) — 새 "패널 축"이 아니라 입력채널의 다중-canvas facet. CL 인쇄위치(C-4 print_area 6위치 멀티슬롯·공정#2+#16 KOI 매핑)가 *이미* "한 본체의 여러 영역에 독립 디자인 배치"를 기존 축으로 담는 검증된 선례.
    - **안감(lining·A-4)/심지(interfacing·A-5)** = 자재#1 sub_mtrl(usage_cd 슬롯·겉감/안감 = 두 usage 인스턴스) — PR 표지/내지 usage_cd 역할 전파(P-2)·FS 솜 충전(FS-6)과 동형. 별 "패널 원단 축" 불요.
    - **포켓/거싯/손잡이 봉제** = 공정#2 봉제 family/형태가공#14(FS-5 SEW_FBR·PDT_WRK·POC_FBR·PD SEW_LTR 동형) + 부속물#8(끈 LIN_PRT·자석 WRK_MTR·라벨 LAB_FBR — FS reverse §0.8 실측·AC/ST/PD SUB_MTR BUNDLE 동형).
  - **후니 KB에 "면별 독립 구성(panel)이 어느 축에도 없음" 같은 결함 명시 없음** — ST 형상 G-SK-2("형상 enum 어느 축에도 없음")가 distinct를 *강제*한 것과 정반대. 디자인입력채널#16·자재 usage#1·공정#2·부속물#8이 cut-and-sew 구성을 *이미 1급 모델링*(결함 없음). → ② 흡수 가능(②불충족 = 부결 보강).

- **★ST 형상(#17)과의 결정적 차이 (승격/부결 일관 기준 HARD):** 형상은 **① 전용 shape_info 슬롯 OBSERVED + ② 후니 KB G-SK-2 결함 둘 다 충족** → 승격. 패널 구성은 **① 면별 디자인 슬롯 UNOBSERVED(라이브 부재) + ② KB 결함 없음** → *양쪽 다 불충족* → 부결. PH-2 거치(①OBSERVED·②결함없음→부결)보다 더 약함(패널은 ①조차 미관측). codex의 "panel semantics" 도전은 *산업적으로 그럴듯하나 RP FS 라이브 모집단(면직물 풀프린팅 굿즈)에는 실재하지 않는* 모집단 오추정(deepcheck (C) flammability 모집단 오추정과 동류).

- **★PD/PH 봉제·완제 부결과의 일관성 점검(directive 요구):** PD(스툴/슬리퍼 봉제 구조물·PD-4 완제 내재BOM)·PH(완제 액자·PH-1)에서 "봉제 완제=카테고리#7·봉제=공정#2/형태가공#14·완제 부속=부속물#8" 부결한 판정과 **정확히 일관**. cut-and-sew는 PD가 이미 적대 검증한 "봉제 구조물 완제품" 패턴의 직물판 — PD-1(SEW_LTR=형태가공#14 family 멤버)·FS-5(SEW_FBR 동형)로 흡수됨. 면별 독립 아트워크는 PD에도 없고(스툴=단일 본체 디자인) FS에도 없음(풀프린팅 단일면). → 부결 일관.

- **메타모델 해소:** ✅ 부결 확정(unobserved-pending → 라이브 미관측 기반 부결·추정 아님). **만약 후속 infoCall 캡처(FS-8)나 후니 직물 굿즈 취급 시 면별 디자인 입력이 *실재 관측*되면 = 디자인입력채널#16 다중면 facet으로 적재(data-gap)이지 신축 아님** — 갭분석가/validator 재확인 대상(라이브 panel 슬롯 실재성). codex 인용(Contrado/FTC) 신뢰 금지·RP FS 라이브가 권위.

---

## FS 판정 요약표

| Fragment | 1차 귀속 축 | 판정 | distinct/facet | 등재 | 검증 라우팅 |
|---|---|---|---|---|---|
| FS-1 ★타일링(TILL_WH_GBN) | **공정#2 인쇄 배치 파라미터#9** | 전 9 카테고리 미관측 전용 슬롯이나 plate_size(임포지션) 이미 1급·KB 결함 없음·타일링≠판걸이수 | **facet(거부·#18 부결)** ★유일 강후보 | #2·#9 | 타일링↔가격 infoCall → gap(data-gap) |
| FS-2 방향(PAPER_WH) | 사이즈#13 방향 facet | 본체 방향(가로/세로)·타일방향과 분리 슬롯(본체≠패턴) | facet(거부) | #13 | — |
| FS-3 면직물 자재(면사 수) | 자재#1 PTT 직물 + WGT 다의(번수) | CL oz·AC mm·PD 번수 동형·비종이 자재 | facet(거부) | #1 | 직물 물성 measure_type → gap/vessel |
| FS-4 별색(SID_FBR 6색×3농도) | 공정#2 별색 family + 기초코드#6 색 | CL Pantone 축소판·직물 날염 제한·round-22 별색=공정 | facet(거부) | #2·#6 | — |
| FS-5 마감봉제/제품가공/FBR슬롯 | 공정#2 봉제 family·형태가공#14·부속물#8 | PD SEW_LTR·GS PDT_WRK 동형·동일 PCS 슬롯·상품별 인스턴스 | facet(거부) | #2·#14·#8 | — |
| FS-6 솜/끈/자석(완제 부자재) | 자재#1 sub_mtrl + 부속물#8 선택형 | 옵션 노출(view_yn=Y)=PD-4 고정 ESN=Y와 노출 차원만 분기 | facet(거부) | #1·#8 | 부속물 노출 모드 그릇 → gap(data-gap) |
| FS-7 가격모델(real_price/calc) | 가격#11 라우팅 | 완제 봉제 굿즈도 면적/실계산·PD tmpl과 분기 | facet(거부) | #11 | 면적함수/가산 infoCall → gap |
| FS-8 PCS 상세/단가/infoCall | unobserved | infoCall 후행·축 판정 무영향 | facet(거부·unobserved) | — | infoCall 캡처 → gap/validation |
| FS-A1 ★패널 구성(codex panel semantics) | 디자인입력채널#16 다중면 + 자재#1 usage + 공정#2 + 부속물#8 | 면별 디자인 슬롯 라이브 UNOBSERVED(풀프린팅 단일면)·KB 결함 없음·①②둘 다 불충족 | **facet(거부·#18 부결)** ★codex 강도전 | #16·#1·#2·#8 | 면별 슬롯 실재성 infoCall → gap(data-gap) |

**FS 강제 분류 회피(SKILL §3·§5):** **distinct 승급 0건(★타일링 TILL_WH_GBN #18 부결 + ★codex 패널 구성 FS-A1 #18 부결) = 17축 재포화(PR 4번째·CL 6번째·AC 7번째·PD 8번째·PH 9번째 distinct 0 패턴 반복).** 8 fragment(FS-1~FS-8) 전부 기존 17축 facet/family/cascade. ★directive 1순위 관전(타일링이 distinct #18인가) 적대 판정: 타일링=공정#2 인쇄 배치(조판/임포지션) 파라미터#9(접지 면분할·오시 줄수 동근·후니 plate_size #6 이미 1급)이지 별 반복배치축 아님. **★재포화 정당성(HARD 기준 양방향 점검):** 형상(#17·ST)은 ① 전용 슬롯(shape_info) + ② 후니 KB G-SK-2 결함 둘 다 충족(승격), 타일링은 **① TILL_WH_GBN 전용 슬롯 OBSERVED(충족)이나 ② 후니 KB 결함 명시 없음**(plate_size/공정 파라미터가 인쇄 배치 담음) → ②불충족 → distinct 0 정직(PH-2 거치 부결과 동일 구조). **★핵심 경계(HARD): 타일링(고객 입력 파라미터·공정#9 등재) ≠ 판걸이수(앱계산 파생·DB미저장·등재 금지).** 10번째 카테고리(직물 풀프린팅+봉제 완제 굿즈)가 새 관리축 0 도입 = 모델 안정성 재확인(유일 신규 후보 타일링조차 무손실 흡수).
**FS가 더한 것(축 신설 아닌 *강화*):** ① **17축 재포화** — 10번째 카테고리 distinct 0(PR·CL·AC·PD·PH 패턴 반복). ② 공정#2 인쇄 배치 파라미터#9 "타일링(반복 배치)" 멤버 추가(접지/오시/UV 합류·plate_size 임포지션 도메인·타일링≠판걸이수 경계). ③ 자재#1 직물 물성 차원 입증(면직물 PTT·면사 수 WGT 번수 다의·CL oz·AC mm·PD 번수 합류). ④ 공정#2 마감봉제(edge finish) family 멤버(오버로크/말아박기/벨크로)·형태가공#14 직물 굿즈 봉제 완제 횡단(PDT_WRK·GS/PD 합류). ⑤ 부속물#8 선택형(옵션 노출 view_yn=Y) facet — PD-4 고정 부속(ESN=Y·view_yn=N)과 노출 차원만 분기. ⑥ 가격#11 라우팅(완제 봉제 굿즈도 real_calc_price·PD tmpl과 분기). ⑦ 공정#2 현수막 가공 BN family 상속(패브릭 포스터=천 현수막·행잉/봉/고리).
**검증 라우팅 요약:** 메타모델 해소 ✅ = FS-1~FS-7(축 귀속 확정·타일링 #18 부결) / 부분 🟡 = FS-8(infoCall enum/단가 unobserved). 라이브/엑셀 검증 필요분 = 타일링↔가격 가산 매핑(FS-1 → gap data-gap·후니 공정 배치 파라미터#9 적재)·직물 물성 measure_type 그릇(FS-3 → vessel)·부속물#8 노출 모드 ESN_YN/view_yn 그릇(FS-6 → gap data-gap)·real_price↔real_calc_price 면적함수(FS-7 → 가격검증)·infoCall enum/단가(FS-8 → validation). **★FS-1 타일링 = data-gap(공정#2 인쇄 배치 파라미터#9 그릇 미적재)이지 vessel-gap(축 부재) 아님 — 갭분석가 핵심 구분(PD-4·PH-1/PH-2 data-gap 동형).**
