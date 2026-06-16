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
