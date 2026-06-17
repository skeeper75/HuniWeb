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
