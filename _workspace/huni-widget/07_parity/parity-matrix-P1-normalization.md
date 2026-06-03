# parity-matrix-P1-normalization.md — P1 정규화 정합 검증 (14 ↔ 38)

> **STAGE S1 / P1**. Red 38 컴포넌트(2 디스패치 메커니즘)를 우리 14-componentType switch로 정규화한 어댑터가 **무손실·정확**한지 검증한다.
> **판정 기준(user-confirmed)**: 책임/로직/분기 재현 동등성 — line-by-line 복사 아님. React vs Vue 차이 무관. **우리 정규화가 Red의 책임/분기를 손실·오분류하는가**만 본다.
> **권위**: `07_parity/red-code-map-07-components.md`(38 컴포넌트) + `deob_07`/`mod_07`. **우리 측**: `component-type-map.ts`(정규화 규칙), `red-adapter.ts`(options→componentType), 14 controls, `OptionControl.tsx`/`OptionPanel.tsx`, `widget-store.ts`/`price.ts`(selection·finish 직렬화).
> **검증임 — 코드 수정 안 함.** GAP은 보고만.
> 근거표기: `RA:N`=red-adapter.ts, `CTM:N`=component-type-map.ts, `PR:N`=price.ts, `WS:N`=widget-store.ts, `mod_07:N`/`deob_07:N`/`mod_06:N`=Red 소스.

---

## 0. 결론 요약 (38 컴포넌트 판정 분포)

| 판정 | 개수 | 컴포넌트 |
|------|------|----------|
| **완전재현** | 9 | size→option-button, mtrl→select-box, dosu(단순), quantity→counter, innerPage→page-counter, SizeSelect→dimension-matrix(NC-1), 그리고 finish-button로 무손실 흡수되는 단순 아이콘/라디오 후가공(ADC_PVC, BON_PAP, BON_SHT…아래 §5-A 12종) |
| **부분재현** | 다수 | finish-button 단순흡수군은 "선택값"은 재현하나 **ATTB·VIEW_YN토글·내부캐스케이드**를 손실(공통결함). 아래 분류 |
| **상이(오분류)/누락** | 핵심 6 | COT_DFT/SCO_DFT(복합), ROU_DFT(멀티+토글), RIN_DFT/BID_SIL(ATTB), END_PAP(hex맵), DosuColor 2단·Paper 2단(부분), 부자재 Acc 캐스케이드(누락 가능), 수량 4종 에디터연동(부분) |

**가장 정확한 한 줄**: 우리 14종 switch는 Red의 **선택값(어떤 옵션을 골랐나)은 거의 다 운반하지만, 선택의 부가의미(ATTB 속성·복합축 분해·멀티선택·런타임 표시토글·컴포넌트 내부 캐스케이드)를 구조적으로 버린다.** 이것이 P1이 확정한 손실의 본질이며, P2/P3는 그 손실의 가격·시각 영향을 따진다.

확정 P2/P3 판정(아래 §4 상세):
- **P2 COT_DFT/SCO_DFT 복합**: **상이(오분류)** — 단/양면축이 사라지고 코팅값만 남음. BLOCKER(가격·주문 PCS_DTL_CD 왜곡 가능).
- **P2 ROU_DFT 멀티+토글**: **부분재현→상이** — multiple:false 고정으로 단일선택만 가능. 4귀 다중·전체토글·사이즈연동반경 전손실. MAJOR.
- **P3 END_PAP hex**: **누락** — 컴포넌트 내부 10색 hex맵을 어댑터가 안 옮김. large-color-chip 데이터경로 0 = 이전 매트릭스 "산출 0" **맞음**(단 이유는 "데이터 없음"이 아니라 "컴포넌트상수맵 미이식"). MAJOR.
- **공통 ATTB 누락**: RIN_DFT/BID_SIL/ROU_DFT/COT_DFT의 ATTB가 `SelectedFinish`(groupId,valueId만)·`serializeRedPriceRequest`(ATTB:'' 하드코딩, RA:427)에서 전손실. BLOCKER(가격 정확성).

---

## 1. 정규화 규칙 명세 (어댑터가 실제로 적용하는 규칙 — 코드 추출)

`component-type-map.ts` + `red-adapter.ts`에서 추출한 **실제 정규화 규칙 전수**:

### RULE-1: 데이터셋 키 → componentType 룩업 (CTM:7~13)
```
size      → option-button   (pdt_size_info)
material  → select-box      (pdt_mtrl_info)
dosu      → option-button   (pdt_dosu_info)
quantity  → counter-input   (pdt_base/prn_cnt_info)
innerPage → page-counter-input
```
Red의 38 컴포넌트가 아니라 **5개 논리 데이터셋**으로 축약. Red의 "메인 조건부 렌더트리"(Apparel/Book/Acc)는 **컴포넌트로 매핑되지 않고** `mapOptionGroups`의 `if(data.X)` 게이트로 흡수(RA:166~344).

### RULE-2: PCS 그룹 → finish-button | color-chip (CTM:16~18, RA:126)
```
pcsComponentType(hasColor) = hasColor ? 'color-chip' : 'finish-button'
호출: pcsComponentType(false)  ← 인자 상수 false (RA:126)
```
→ **모든 후가공(26종)이 finish-button 단일 분기**. color-chip 분기는 도달 불가(상수 false).

### RULE-3: PCS 그룹화 (RA:107~134)
```
PCS_CD 별 묶음 → OptionGroup{ id:`PCS_${cd}`, componentType:finish-button,
  required:ESN_YN==='Y', visible:VIEW_YN==='Y', multiple:false(고정), values:[{id:PCS_DTL_CD,label:PCS_DTL_NM,disabled:false}] }
```
→ **multiple 항상 false**(RA:129). PCS_DTL_CD를 평면 값으로. **ATTB·DIV_SEQ·WEB_PCS_DTL_GRP·하위축 정보 폐기.**

### RULE-4: 규격 dimension-matrix 분기 (RA:176~211) — NC-1
```
priceScheme==='real_price' && size에 CUT_WDT==0&&CUT_HGH==0(자유입력 sentinel) → dimension-matrix-input
else → option-button
```
유일하게 38 컴포넌트 중 SizeSelect의 자유입력 변형을 재현하는 동적 분기.

### RULE-5: 수량 폐쇄래더 → select-box (RA:158~164, 304~321)
```
pdt_prn_cnt_info 가 FIR/INC null + PRN_CNT 고정값(폐쇄래더) → select-box enum (counter 아님)
else q 있으면 → counter-input
```

### RULE-6: colorHex 출처 (RA:97)
```
mtrlValue.colorHex = m.CLR_HEX_CD || undefined   ← mtrl 데이터의 CLR_HEX_CD 만
```
→ **후가공(PCS) 값에는 colorHex 주입 경로 자체가 없음**. END_PAP의 컴포넌트내부 hex맵은 어디서도 import 안 됨.

### 규칙 총평
정규화는 **6개 룩업/분기 규칙**으로 38 컴포넌트를 14종에 매핑. 핵심 설계선택 = "**후가공은 PCS_DTL_CD 평면 단일선택으로 통일**". 이 단일화가 P1 손실의 진원지.

---

## 2. 전수 대응 매트릭스 (38 Red 컴포넌트 + 2 디스패치)

> componentType 열 = 우리 14 중 매핑. verdict = 완전재현/부분재현/누락/상이.

### 2-A. 메인·서브 (옵션값 처리·검증 보유) — 14 컴포넌트

| Red 컴포넌트 (file:line) | 디스패치 트리거 | → componentType | our control | 판정 | 증거 |
|--------------------------|-----------------|-----------------|-------------|------|------|
| Apparel (deob_07:830) | 의류 메인(조건부 렌더트리) | (분해됨) | OptionPanel SideSection | **부분** | 우리 어댑터에 Apparel 전용 매핑 없음 — fixture는 디지털/책자류만. 의류 size_color_info·pantone·printArea 매핑 경로 0(RA 전체에 apparel_info 미참조). 의류 컨버전 시 신규 어댑터 분기 필요 |
| Book (deob_07:1900~) | 책자 메인(view_yn 게이트) | (분해됨) | OptionPanel SideSection(default/inner) | **완전(구조)** | `hasInner`(RA:56)→표지/내지 side 분리(RA:57~65). GRP_MTRL_COVER/INNER·GRP_DOSU·GRP_INNER_PAGE 생성(RA:217~296). view_yn=visible 매핑(RA:128). 단 CoverGuide·SubjectGroup 미매핑 |
| Acc (deob_07:2006) | 부자재 메인(config uiType) | (분해됨) | — | **누락(가능)** | accFilterConfigMap 기반 CASCADE/MULTI 다단 캐스케이드(deob_07:2027~2150)가 우리 어댑터에 **이식 안 됨**. 부자재 상품 컨버전 시 신규. 현 fixture 미포함이라 무증상 |
| ApparelSizeGbn (deob_07:197) | adult/child 라디오 | option-button | OptionButtonGroup | **부분** | 라디오 2값은 option-button로 재현가능하나 어댑터 매핑경로 0(의류 미지원) |
| ApparelSingleSizeQty (deob_07:264) | 단일사이즈+수량 | option-button+counter | OptionButton+CounterInput | **부분** | HIDE_YN disabled·QUICK_ORD_YN 경고·중간값 기본선택(deob_07:302) 미재현. 의류 미지원 |
| ApparelMultiSizeQty (deob_07:411) | 멀티사이즈 카운터테이블 | counter-input(멀티) | CounterInput | **누락** | 사이즈별 +/- 테이블 = **다축 수량**. 우리 counter는 단일 quantity 상태(WS:133). 멀티사이즈 수량배열 재현 불가 |
| PantoneChipModal (deob_07:434) | 팬톤 모달 | color-chip | ColorChipGroup | **누락** | 모달+검색 UI 없음. 팬톤 hex 데이터경로 0. 의류 실크 전용 |
| ApparelPrintColor (deob_07:552) | 팬톤 래퍼 | color-chip | — | **누락** | 위와 동일 |
| PAK_POL_Simple (deob_07:611) | 개별포장 2값 라디오 | finish-button | FinishButtonGroup | **부분** | 2값 선택은 재현. 단 PCS_INFO 직렬화 시 ATTB 없음(무영향, attb 미보유) |
| BookQty (deob_07:1195) | 책자수량/내지장수 | counter-input/page-counter-input | CounterInput/PageCounterInput | **완전(검증) 부분(UX)** | 클램프: 우리 `clampStep`(CounterInput:13)이 min/max/step 보정. **짝수보정(FIR===2)**(deob_07:1240)은 step=2로 흡수 가능. **토너/윤전 안내문구분기**(deob_07:1296)·**양면×2 표시**(deob_07:1233)·select/input 토글 미재현(UX 손실, 가격 무영향) |
| DosuColor (deob_07:1336) | 도수+색상 2단 | option-button(도수만) | OptionButtonGroup | **부분(상이)** | 우리는 도수만 option-button 1그룹(RA:229~244), `priceColorCount`로 평면화(RA:240). Red는 **도수 select + 색상(BNC) select 2단**(deob_07:1350 showColorSelect). `showColorSelect=all>dosu`일 때 별도 색상선택을 우리는 미분리 — 색상축 선택 UI 손실(가격은 priceColorCount echo로 부분보존) |
| Paper (deob_07:1411) | 용지종류+평량 2단 | select-box(1그룹) | HuniSelect | **부분(상이)** | Red는 **PTT(종류) select + WGT(평량) select 2단**, 평량이 종류에 의존(deob_07:1548). 우리는 mtrl 1그룹 select-box로 평탄화(RA:215~225) — 2단 종속선택 손실(자재값 자체는 보존) |
| CoverGuide (deob_07:1267) | 가이드(비입력) | (디스패처 외) | — | **누락(의도)** | 미리보기·템플릿다운로드. 우리 패널에 가이드 슬롯 없음. 비기능 — MINOR |
| SizeSelect/규격 (RA:186) | real_price+자유입력 | dimension-matrix-input | DimensionMatrixInput | **완전** | RULE-4(RA:176~211)로 NC-1 재현. BNBNFBL·BNPTPET 검증됨(matrix prior) |

### 2-B. 후가공 26 + 디스패치맵 변형 3 — finish-button 흡수군

> 공통: RULE-2/3로 전부 `finish-button` + `multiple:false`. 값(PCS_DTL_CD) 선택은 재현. **공통 손실 = ATTB 폐기(SelectedFinish에 필드 없음, RA:427 ATTB:''), VIEW_YN 런타임토글 없음, 컴포넌트 내부 캐스케이드 없음.**

| Red 후가공 (mod_07:line) | PCS_CD 디스패치 | → componentType | 판정 | 손실 specifics (file:line 양측) |
|--------------------------|-----------------|-----------------|------|--------------------------------|
| **COT_DFT** (mod_07:2186) | `../postPcs/COT_DFT.vue`(mod_06:1419) | finish-button | **상이(오분류)** | Red: 단/양면 라디오 + 코팅 아이콘그리드, `value={coating}{side}` 합성(mod_07:2249). 우리: PCS_DTL_CD를 평면 값으로(RA:117) → **단/양면축 소멸**. 사용자가 "양면 무광"을 못 만들고 코팅값만 단일선택. PCS_DTL_CD 합성규칙 부재 → 주문/가격 코드 왜곡 위험 |
| **SCO_DFT** (mod_07:3389) | SCO_DFT.vue(mod_06:1437) | finish-button | **상이** | COT_DFT 동형(단/양면+규격가이드). 동일 축 소멸 |
| **ROU_DFT** (mod_07:3285) | ROU_DFT.vue(mod_06:1436) | finish-button | **상이/부분** | Red: 체크박스 **멀티선택**(u.value 배열, mod_07:3334) + 4귀 전체토글(mod_07:3327) + 사이즈→반경 ATTB(mod_07:3340). 우리: `multiple:false`(RA:129) → **단일선택만**. 4귀 다중·전체토글·반경 ATTB 전손실 |
| **RIN_DFT** (mod_07:3220) | RIN_DFT.vue(mod_06:1435) | finish-button | **부분(ATTB 누락)** | Red: attbOptions(색상) 선택→`ATTB:색상값`(mod_07:3240). 우리: SelectedFinish에 ATTB 없음(price.ts:13~16), 직렬화 ATTB:''(RA:427) → **링 색상 선택 손실** |
| **BID_SIL** (deob_07:2364) | BID_SIL.vue(mod_06:1414) | finish-button | **부분(ATTB)** | 속성값(attbOptions) 보유. ATTB 손실 동일 |
| **END_PAP** (mod_07:2501) | END_PAP.vue(mod_06:1424) | finish-button (should be large/color-chip) | **누락(오분류)** | Red: 컴포넌트내부 10색 hex맵(mod_07:2511~2522) + ColorChipSelector. 우리: PCS는 finish-button 고정(RA:126), colorHex는 mtrl만(RA:97) → **hex맵 미이식 → 색칩 데이터경로 0**. 면지가 텍스트버튼으로 렌더 |
| ADC_PVC (deob_07:2312) | ADC_PVC.vue(mod_06:1413) | finish-button | **완전** | 단순 아이콘선택. 값 재현 OK. (아이콘이미지 손실은 시각재현 P5 영역) |
| BIND_DIRECTION (deob_07:2447) | mod_06:1415 | finish-button | **부분(상이)** | 가로/세로 자동방향결정(horizontalBindSet) + 회전선택(deob_07:2481). 우리는 자동결정 로직·회전축 없음 → 방향 자동화 손실 |
| BON_PAP (deob_07:2037) | mod_06:1416 | finish-button | **완전** | 단순 아이콘 |
| BON_SHT (deob_07:2087) | mod_06:1417 | finish-button | **완전** | 단순 아이콘 |
| CLD_STD (deob_07:2135) | mod_06:1418 | finish-button (should be select-box) | **부분(상이)** | Red: BasicSelect(달력규격). 우리: PCS는 무조건 finish-button(RA:126) → 셀렉트가 아닌 버튼. 값 보존되나 UX형식 상이. PAK_ETC 연동 손실 |
| COT_SEG (deob_07:2303) | mod_06:1420 | finish-button | **완전** | 아이콘 |
| CVR_INN (deob_07:2352) | mod_06:1421 | finish-button (should be select-box) | **부분(상이)** | BasicSelect → finish-button. CLD_STD와 동일 형식상이 |
| CVR_SWN (deob_07:2399) | mod_06:1422 | finish-button | **완전** | 아이콘 |
| DIR_MTR (deob_07:2447) | mod_06:1423 | finish-button | **부분** | Apparel에서 자재맵 기반 자동구성(deob_07:992~1019). 자동구성 로직 미재현(의류 미지원). 단독 라디오는 재현가능 |
| INN_DFT (deob_07:2563) | mod_06:1425 | finish-button (+counter) | **부분(상이)** | Red: BasicSelect + 수량입력. 우리: finish-button만 → 수량입력 축 손실 |
| INS_COT (deob_07:2656) | mod_06:1426 | finish-button | **완전** | 아이콘 |
| LAB_FBR (deob_07:2707) | mod_06:1427 | finish-button (image성) | **부분** | imgPath svg = 실질 image-chip. 우리 finish-button은 텍스트(이미지 손실, 시각 P5). 값 보존 |
| PAK_ETC (deob_07:2758) | mod_06:1428 | finish-button | **부분** | 달력규격(CLD_STD) 연동(deob_07:2758). 연동 손실. 값 보존 |
| PAK_POL (deob_07:2882) | mod_06:1429 | finish-button | **완전** | 아이콘 |
| PDT_WRK (deob_07:2932) | mod_06:1431 | finish-button | **부분** | 주문수량·인쇄영역 연동 자동구성(deob_07:1024~1051). 자동구성 손실. 값 보존 |
| PRT_IPK (deob_07:3016) | mod_06:1432 | finish-button | **부분** | 상시 active 표시(읽기전용). 우리는 선택형 버튼 — "항상 적용" 의미 손실. visible=VIEW_YN로 부분흡수 |
| PRT_WHT (deob_07:3136) | mod_06:1433 | finish-button | **부분(상이)** | Red: 자동/수동 라디오 + pdtCode기반 자동결정(mod_06:1496) + useWhiteReset. 우리: 선택형 버튼만. 자동결정·리셋 로직 손실 |
| PRT_WHT_FACE (deob_07:3035) | mod_06:1434 | finish-button | **부분** | 전면/후면 **다중 체크박스**. multiple:false 고정 → 다중면 선택 손실 |
| SCO_DFT | (위 복합 표 참조) | finish-button | 상이 | (중복) |
| SUB_MTR_BC (deob_07:3490) | mod_06:1439 | finish-button | **부분** | 사이즈 연동(deob_07:3490). 연동 손실. 값 보존 |
| WRK_MTR (deob_07:3546) | mod_06:1441 | finish-button | **완전(부분)** | 아이콘/라디오 하이브리드. 단순선택 재현 |
| SUB_MTR / SUB_MTR_Multi (mod_06:1438/1440) | WEB_PCS_DTL_GRP 라우팅(mod_06:1442) | finish-button (should be select-box/multi) | **부분(상이)** | 자재 셀렉트/멀티. 다중선택·셀렉트 형식 손실 |

### 2-C. 수량 컴포넌트 4종 — counter-input 흡수

| Red (deob_07:line) | 트리거 | → componentType | 판정 | 손실 |
|--------------------|--------|-----------------|------|------|
| CalendarQty (3744) | 달력(디자인수+수량 2단) | counter-input | **부분** | **2단 수량**(디자인수+수량). 우리 단일 quantity(WS:133). 디자인수 축 손실 |
| SetQty (3929) | 세트수량(에디터연동) | counter-input | **부분** | 오늘/내일출발 안내·세트단위 에디터연동 손실. 수치 재현 |
| SimpleQty (4026) | 단순수량(세트단위) | counter-input | **완전** | 세트단위 계산 = step으로 흡수 |
| TotalQty (4189) | 총수량(에디터·디자인건수) | counter-input | **부분** | 디자인건수 연동 손실. 수치 재현 |

### 2-D. 두 디스패치 메커니즘 자체

| Red 디스패치 | 우리 대응 | 판정 | 증거 |
|--------------|-----------|------|------|
| **PCS_CD→동적임포트맵(31)** (mod_06:1412~1442) | RULE-2/3 단일 finish-button (RA:126) | **부분(과축약)** | 31 파일이 1 componentType으로. 선택값은 PCS_INFO로 보존(RA:423~428) — PCS_COD/PCS_DTL_COD 복원(RA:425). 단 컴포넌트별 UI다양성(복합/멀티/select/색칩) 손실 |
| **메인 조건부 렌더트리** (Apparel/Book/Acc) | `if(data.X)` 게이트(RA:166~344) | **완전(Book) 부분(Apparel/Acc)** | Book은 hasInner·view_yn 게이트로 재현(RA:56,128). Apparel/Acc는 어댑터 미지원(fixture 부재) |

---

## 3. 완전재현 vs 풍부재현필요 — 후가공 26종 분류 (요청 항목)

### 3-A. **무손실 흡수 가능** (단순 단일선택 아이콘/라디오 — finish-button 충분) — 12종
ADC_PVC, BON_PAP, BON_SHT, COT_SEG, CVR_SWN, INS_COT, PAK_POL, PAK_POL_Simple, WRK_MTR, SUB_MTR_BC(단독), DIR_MTR(단독), PRT_IPK(visible로 부분)
→ 선택값=PCS_DTL_CD 단일, ATTB 무, 복합축 무, 멀티 무. **finish-button 1:1 재현 OK** (아이콘 이미지는 시각재현 P5 별도).

### 3-B. **풍부재현 필요** (finish-button로는 손실) — 14종
| 컴포넌트 | 필요한 풍부재현 |
|----------|-----------------|
| COT_DFT, SCO_DFT | **복합 2축**(단/양면 라디오 + 코팅 그리드) + 값 합성(`{coating}{side}`) |
| ROU_DFT | **멀티선택 + 전체토글 + 사이즈연동 반경 ATTB** |
| RIN_DFT, BID_SIL | **ATTB**(속성값) 운반 |
| END_PAP | **color-chip + 컴포넌트내부 hex맵 이식** |
| PRT_WHT, PRT_WHT_FACE | 자동/수동 결정 로직 + **다중 면선택** |
| BIND_DIRECTION | 자동 방향결정(가로/세로) + 회전축 |
| CLD_STD, CVR_INN | select-box 형식(값 多) |
| INN_DFT | select + 수량입력 |
| LAB_FBR | image-chip(원단 이미지) |
| PAK_ETC, PDT_WRK | 타옵션 연동 자동구성 |

---

## 4. P2/P3 명시 해소 (요청 — 여기서 확정)

### P2-① COT_DFT / SCO_DFT 복합 — **상이(오분류), BLOCKER**
- **Red(mod_07:2214~2293)**: 단일 PCS_DTL_CD를 `side=value.slice(-1)`, `coating=value.slice(0,4)`로 **분해**, RadioGroup(단/양면) + IconCheckbox그리드(코팅) 2축 렌더, 선택 후 `d=coating+side`로 **재합성**해 `{PCS_CD, PCS_DTL_CD:d}` emit. disabledOptions 변경 시 활성코팅 폴백(mod_07:2266).
- **우리(RA:117~121)**: `items.map(it=>({id:it.PCS_DTL_CD}))` — 합성된 풀코드를 **평면 단일선택값**으로 나열. 분해/재합성 로직 0.
- **손실**: 사용자가 단/양면을 독립선택 불가. 코팅 옵션이 단/양면 조합만큼 폭증한 평면버튼으로 깔림. **PCS_DTL_CD가 Red 합성규칙과 일치하면** 우연히 정합되나, 단/양면 축이 UI에서 사라져 **유효조합 보장 못 함**(예: "양면 무광"=`TCMAD`를 단일버튼으로 가지면 OK이나, Red는 단면×코팅·양면×코팅 매트릭스를 동적생성 — 평면화 시 조합 누락/중복 위험).
- **판정 근거 severity=BLOCKER**: 후가공 PCS_DTL_CD는 가격(PCS_INFO)·주문에 직결. 합성코드 불일치 시 가격오류/주문거부.
- **재현요구**: 복합 컨트롤(2축 분해/재합성) 또는 어댑터가 단/양면·코팅을 2 OptionGroup으로 쪼개고 가격직렬화 시 재합성.

### P2-② ROU_DFT 멀티+토글 — **상이/부분, MAJOR**
- **Red(mod_07:3325~3344)**: `u`=선택목록(배열), 체크박스 멀티, `l`=4귀전체토글(양방향 watch, mod_07:3327~3330), `i`=반경(사이즈연동 `roundingConfigMap[pdtCode].value[DIV_SEQ]`, mod_07:3331), 각 선택→`{PCS_DTL_CD, ATTB:반경}`.
- **우리(RA:129)**: `multiple:false` 고정. ATTB 없음.
- **손실**: 4귀 중 일부만 선택 불가(단일만), 전체토글 없음, 사이즈 바뀌어도 반경 ATTB 자동전환 없음.
- **재현요구**: `multiple:true` + 멀티선택 컨트롤 + ATTB 슬롯 + 사이즈→반경 캐스케이드 룰.

### P3 END_PAP hex — **누락, MAJOR (이전 매트릭스 "산출 0" 맞음 — 단 이유 정정)**
- **Red(mod_07:2511~2522)**: `s={CLYEL:"#fdeec5", CLMIN:"#d5edea", ... CLGRY:"#ededee"}` **10색 hex를 컴포넌트 안에 하드코딩**, options의 `value`(COD)를 키로 룩업해 ColorChipSelector(`sh`)에 `{COD,COD_NME,HEX}` 전달.
- **우리**: `pcsComponentType(false)`→finish-button(RA:126). colorHex는 `mtrlValue`(RA:97)에서 `m.CLR_HEX_CD`만 — **후가공(PCS)엔 colorHex 주입 경로 자체가 없음**. END_PAP의 컴포넌트상수 hex맵은 `component-type-map.ts`·`red-adapter.ts` 어디서도 import/참조 안 됨.
- **판정**: 이전 `componenttype-mapping-matrix.md`의 "color-chip/large-color-chip 산출 0"은 **결과적으로 맞다**(우리 산출 0). 그러나 그 근거였던 "Red에 색 데이터 0(CLR_HEX_CD 빈값)"은 **부정확**했다. 정확한 진실: **Red 색 데이터는 옵션필드가 아니라 컴포넌트 내부 상수맵에 있고, 우리 어댑터가 그 맵을 옮기지 않았다.** → large-color-chip은 "데이터 없음"이 아니라 "**미이식**". Red에는 살아있는 색칩 baseline(END_PAP)이 실재.
- **재현요구**: 어댑터에 PCS_CD=END_PAP(및 유사 색상후가공) 식별 시 `pcsComponentType(true)`→color-chip + COD→hex 룩업맵(컴포넌트상수 이식)으로 `OptionValue.colorHex` 주입. 후니 컨버전 시 후니가 hex를 옵션데이터로 줄지/상수맵으로 줄지 결정 필요.

### P-공통 ATTB 누락 — **BLOCKER**
- **Red**: RIN_DFT(ATTB=링색), ROU_DFT(ATTB=반경), COT_DFT(side 합성), BID_SIL(ATTB=속성) — 모두 emit에 ATTB/합성 운반.
- **우리**: `SelectedFinish={groupId,valueId}`(price.ts:13~16) — **ATTB 필드 없음**. `finishesFromSelections`(price.ts:63~72) groupId/valueId만. `serializeRedPriceRequest`(RA:423~428) `ATTB:''` **하드코딩**.
- **손실**: ATTB가 가격에 영향 주는 후가공(링색·반경별 단가차)에서 가격왜곡. 주문 시 속성 누락.
- **재현요구**: `SelectedFinish`에 `attb?:string` 추가 + 선택 컨트롤이 ATTB 수집 + 직렬화가 echo.

---

## 5. 손실/오분류 레지스터 (severity)

| ID | 항목 | severity | 무엇을 잃나 | 재현 요구 |
|----|------|----------|-------------|-----------|
| **L-1** | ATTB 전손실 (RIN/ROU/COT/BID_SIL) | **BLOCKER** | 후가공 속성값(링색·반경·속성) → 가격·주문 | SelectedFinish.attb 추가 + 직렬화 echo + 컨트롤 수집 |
| **L-2** | COT_DFT/SCO_DFT 복합축 소멸 | **BLOCKER** | 단/양면 독립선택, 유효조합 보장 | 2축 분해/재합성(복합컨트롤 or 2그룹) |
| **L-3** | ROU_DFT 멀티+토글+반경 | **MAJOR** | 4귀 다중선택·전체토글·사이즈연동반경 | multiple:true + ATTB + 사이즈캐스케이드 |
| **L-4** | END_PAP hex맵 미이식 (color-chip) | **MAJOR** | 면지 색칩 시각·선택의미 | PCS색상식별→color-chip + COD→hex 이식 |
| **L-5** | DosuColor 2단(도수+BNC색) 미분리 | **MAJOR** | 색상(BNC)축 독립선택 UI | 도수·색상 2그룹 분리 또는 복합. 가격은 priceColorCount로 부분보존 |
| **L-6** | Paper 2단(PTT+WGT 종속) 평탄화 | **MINOR~MAJOR** | 종류→평량 종속선택 UX | 2단 종속 select(값 자체는 mtrl 1그룹으로 보존) |
| **L-7** | multiple:false 고정 (PRT_WHT_FACE 다중면, SUB_MTR_Multi) | **MAJOR** | 다중선택 후가공 | PCS별 multiple 판정(WEB_PCS_DTL_GRP/면) |
| **L-8** | PCS select형(CLD_STD/CVR_INN/INN_DFT) → finish-button | **MINOR** | UX형식(값은 보존) | PCS 값개수/타입 기반 finish-select-box 분기(D-5와 연결) |
| **L-9** | 컴포넌트 내부 캐스케이드 미승격 (ROU 사이즈→반경, COT disable폴백, Apparel 영역→PDT_WRK/자재→DIR_MTR, PRT_WHT 자동결정) | **MAJOR** | 자동구성·자동전환 | 어댑터/cascade.ts 룰로 승격 |
| **L-10** | VIEW_YN 런타임 add/remove 토글 | **MAJOR** | 후가공 런타임 표시토글+가격재계산(mod_06:1452) | cascade.ts에 동적 그룹 add/remove |
| **L-11** | 멀티/다단 수량 (ApparelMultiSize, CalendarQty 디자인수+수량) | **MAJOR** | 다축 수량 | 다축 quantity 상태 |
| **L-12** | Acc 부자재 캐스케이드(CASCADE/MULTI uiType) 미이식 | **MAJOR(컨버전)** | 부자재 1/2/3단 캐스케이드 | accFilterConfigMap 이식 |
| **L-13** | 의류(Apparel) 전 경로 미지원 | **MAJOR(컨버전)** | size_color/pantone/printArea/printType분기 | 의류 전용 어댑터 분기 |
| **L-14** | 자동방향(BIND_DIRECTION), 안내문구분기(BookQty), CoverGuide/SubjectGroup | **MINOR** | 보조 UX | 필요 시 개별 재현 |

---

## 6. P2~P6로 넘길 항목 (handoff)

| 대상 | 항목 | 본 P1 확정사항 |
|------|------|----------------|
| **P2 (가격 정합)** | L-1 ATTB / L-2 COT_DFT 합성 / L-3 ROU_DFT 반경ATTB / L-5 DosuColor priceColorCount | P1이 손실 확정 → P2는 **이 손실이 PCS_INFO·ORD_INFO 가격결과를 왜곡하는지** 실값 검증. 특히 ATTB·합성PCS_DTL_CD가 단가에 영향주는지 |
| **P3 (시각/색)** | L-4 END_PAP hex / L-8 select형 후가공 / LAB_FBR image | P1이 large-color-chip baseline은 Red에 **실재**(END_PAP)임을 확정 → P3는 hex맵 이식 시 시각재현 가능 여부 |
| **P4 (캐스케이드)** | L-9 내부캐스케이드 / L-10 VIEW_YN토글 / L-12 Acc | P1이 cascade.ts가 disable만 처리함을 확정 → P4는 자동구성·동적토글 재현 설계 |
| **P5 (의류·다축)** | L-11 멀티수량 / L-13 의류 / L-7 다중후가공 | P1이 어댑터 의류·멀티 경로 0임을 확정 → P5는 컨버전 시 신규분기 |
| **P6 (잔여 UX)** | L-6 Paper2단 / L-14 보조UX | MINOR — 후니 컨버전 우선순위 낮음 |

---

## 7. 검증 메타 (회의적 점검)

- **거짓 완전재현 경계**: §3-A 12종 "무손실"은 *현 Red fixture 기준 단일선택·ATTB무·복합무*가 사실일 때만 유효. 후니 데이터가 같은 PCS_CD에 ATTB/멀티를 부여하면 부분재현으로 강등됨 → P2/P4 재검 대상.
- **PCS_INFO 보존의 한계**: RA:423~428이 groupId→PCS_COD·valueId→PCS_DTL_COD를 복원하므로 **단순 후가공 선택값은 가격API까지 무손실 전달**됨(이 부분은 진짜 완전). 손실은 오직 ATTB·복합축·멀티에 국한 — 과대보고 아님.
- **이전 매트릭스 정정**: `componenttype-mapping-matrix.md`의 D-2("색 데이터 0이라 false 정확")는 **코드 권위로 정정** — 색 데이터는 컴포넌트 상수맵에 존재(END_PAP). large-color-chip은 "데이터 부재"가 아니라 "어댑터 미이식". 이 정정이 P1의 가장 중요한 사실수정.
