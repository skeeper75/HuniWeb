# parity-matrix-D4-internal-cascade.md — P5 컴포넌트 내부 캐스케이드 + 후가공 14손실 재현 SPEC

> **STAGE S1 / P5 + 재현SPEC**. Red가 **컴포넌트 setup() 안에 들고 있는** 파생/변환/연동 로직(우리가 어댑터·스토어로 승격하지 않았을 수 있는 것)을 검증하고, P1의 L-2/L-3/L-4(BLOCKER/MAJOR)를 **S3가 구현할 구체 SPEC**으로 심화한다.
> **판정 기준(user-confirmed)**: 책임/로직/분기 재현 동등성 — line-by-line 복사 아님. **검증 + 재현SPEC만. 코드 수정 없음.**
> **권위**: `07_parity/red-code-map-07-components.md` + `parity-matrix-P1-normalization.md`(자작) + `deob_07`/`mod_07`. **우리 측**: `controls/`(14), `stores/cascade.ts`, `stores/widget-store.ts`, `adapters/red/component-type-map.ts`, `red-adapter.ts`, `contract/*.ts`.
> 근거표기: `mod_07:N`/`deob_07:N`=Red 소스, `RA:N`=red-adapter.ts, `CTM:N`=component-type-map.ts, `WS:N`=widget-store.ts, `casc:N`=cascade.ts, `DM:N`=DimensionMatrixInput.tsx, `prod:N`=contract/product.ts, `price:N`=contract/price.ts.

---

## 0. 결론 요약

**P5 (컴포넌트 내부 캐스케이드) 갭: 6건 전부 미재현(전손실).**
우리 `cascade.ts`는 **material→pcs disable 단 1종**만 처리(casc:16~80). Red가 컴포넌트 setup의 `watch()`로 들고 있는 **파생/자동구성/자동전환** 로직은 우리 코드 어디에도 없다. 평면 leaf 컨트롤(OptionButton/FinishButton/CounterInput)은 `value`만 받고 파생을 안 한다.

| P5 항목 | 우리 재현? | 살아야 할 위치 |
|---------|-----------|----------------|
| ROU_DFT 사이즈→반경 ATTB | **없음** | adapter(반경맵) + cascade.ts(size watch) + ATTB 슬롯 |
| COT_DFT disable 폴백 | **없음(부분)** | cascade.ts(disable는 있으나 "활성값 자동선택 폴백"은 없음) |
| Apparel 인쇄영역→PDT_WRK 자동구성 | **없음** | adapter(의류 분기) + 파생 룰 |
| Apparel 자재→DIR_MTR 자동구성 | **없음** | 동일 |
| PRT_WHT 자동/수동 결정 + reset | **없음** | adapter(pdtCode 판정) + 자동선택 |
| DosuColor dosu↔BNC 매핑(색상축) | **부분(priceColorCount echo만)** | cascade.ts(dosu→색상옵션 필터) |

**후가공 재현 SPEC 한 줄(L-2/L-3/L-4):**
- **L-2 COT_DFT/SCO_DFT**: PCS_DTL_CD를 `side=slice(-1)`/`coating=slice(0,4)` 2축으로 **어댑터가 분해해 2 OptionGroup 생성**(단/양면 option-button + 코팅 finish-button), 가격 직렬화 시 `coating+side` **재합성**해 단일 PCS_DTL_COD 복원.
- **L-3 ROU_DFT**: `multiple:true` 멀티선택 컨트롤(체크박스 그리드 + "전체" 토글) + `OptionValue.attb`(반경) 슬롯 + **size→반경** 캐스케이드 룰(roundingConfigMap 어댑터 이식).
- **L-4 END_PAP**: 어댑터가 PCS_CD별 **색상 hex 상수맵**(END_PAP 10색, mod_07:2511)을 보유→`pcsComponentType(true)`로 color-chip 라우팅 + `OptionValue.colorHex` 주입(현 ColorChip은 이미 `colorHex` 렌더 가능, 데이터만 없음).

---

## 1. P5 — 컴포넌트 내부 캐스케이드 검증표

> Red는 캐스케이드를 **두 곳**에 둔다: (a) widget_sdk의 `v()`/disable(전역), (b) **개별 후가공·옵션 컴포넌트 setup의 watch**(국소). P1은 (a)를 다뤘고, P5는 (b)를 검증한다.

| # | Red 내부 로직 (file:line) | 무엇을 파생/연동하나 | 우리 재현 여부 (증거) | 판정 | 살아야 할 위치 |
|---|---------------------------|----------------------|----------------------|------|----------------|
| **C-1** | **ROU_DFT 사이즈→반경** (mod_07:3299~3333) | `r=sizeInfo.DIV_SEQ`(3299). `Yr[pdtCode].factor==='size'`면 반경옵션=`Yr.value[DIV_SEQ]`(3302). 사이즈 변경 watch→`i.value=Yr[pdtCode].value[h]`(3331). 반경이 ATTB로 들어감(3340). | **없음**. `roundingConfigMap`(Yr) 우리 어댑터/스토어에 0건(grep: red-adapter·cascade·widget-store 전체 미참조). cascade.ts는 material→pcs disable만(casc:24~25 `isMaterialGroup` 외 early return). | **누락(전손실)** | adapter: 반경맵 이식+ATTB 산출. cascade.ts: size 그룹 변경 시 ROU 그룹 ATTB/옵션 재계산 |
| **C-2** | **COT_DFT disable 폴백** (mod_07:2266~2269) | `disabledOptions` 변경 watch→현재 코팅(u.value)이 disable되면 `find(!disabled)` 활성코팅으로 자동전환(2268). | **부분**. cascade.ts가 disable 셋은 계산(casc:50~57)하나 **선택해제만**(casc:60~77 delete) — "비활성되면 활성값으로 자동 재선택"하는 폴백은 없음. 우리는 비활성 시 selection을 지움(빈 선택). Red는 다른 유효값을 채움. | **부분(상이)** | cascade.ts: disable 후 required 그룹은 빈 선택 대신 첫 활성값 자동선택 |
| **C-3** | **Apparel 인쇄영역→PDT_WRK 자동구성** (deob_07:1024~1051) | 인쇄영역 선택 watch→영역별 `pdtWrkMap[area.COD]`로 PDT_WRK 후가공 객체 배열 자동생성, KOI_NME 연동(1041), `postProcessState.PDT_WRK`에 주입(1051). | **없음**. 의류(Apparel) 전 경로가 어댑터 미지원(P1 L-13). PDT_WRK 자동구성 로직 0. | **누락(컨버전)** | adapter(의류 분기): printArea selection → PDT_WRK 파생 룰 |
| **C-4** | **Apparel 자재→DIR_MTR 자동구성** (deob_07:992~1019) | 사이즈조합→자재맵 watch→`pdt_pcs_info.filter(PCS_CD==='DIR_MTR' && materialMap[MTRL_CD])`로 DIR_MTR 객체 생성, ATTB=수량(1008), `postProcessState.DIR_MTR`(1019). | **없음**. 동일(의류 미지원). | **누락(컨버전)** | adapter(의류 분기): material selection → DIR_MTR 파생 + ATTB 운반 |
| **C-5** | **PRT_WHT 자동/수동 + reset** (mod_06:1496~1545) | `pdtCode.startsWith("AC")`+업로드타입(editor)면 PRT_WHT 자동='Y'(1496), ACTHFCO 예외. editorData watch로 화이트 리셋(useWhiteReset, deob_07:122). | **없음**. PRT_WHT를 일반 finish-button로 흡수(P1) — 자동결정·리셋 로직 0. | **누락** | adapter: pdtCode 기반 PRT_WHT 자동선택+visible 결정. (실제 표시 안 함=hidden essential) |
| **C-6** | **DosuColor dosu↔BNC 색상축** (deob_07:1350~1354) | `showColorSelect=all.length>dosu.length`(1350)면 색상(BNC) 별도 select. `matchedDosuOption=all.find(BNC_GB===color && COD===dosu)`(1354). | **부분**. 우리는 도수만 option-button(RA:229~244), `priceColorCount` echo(RA:240)로 **가격의미는 부분보존**하나 **색상(BNC) 선택 UI축이 없음**. all>dosu인 상품은 색상선택 불가. | **부분(상이)** | adapter: all>dosu면 색상 OptionGroup 추가 + cascade(dosu→색상옵션 필터) |

**그 외 leaf가 버리는 파생/변환 (보강):**
- **C-7 BookQty 양면×2 표시** (deob_07:1233): `dosu==='SID_D'?2:1` 곱해 실페이지 표시. 우리 CounterInput은 단순 수치(미파생) — 표시손실(가격무영향). **MINOR**.
- **C-8 BookQty 안내문구 분기** (deob_07:1296): 토너(`pdtCode[4]==='O'`)/윤전·짝수 안내문 분기. 우리 미재현 — **MINOR**.
- **C-9 BIND_DIRECTION 자동방향** (deob_07:2472~2481): `horizontalBindSet` 포함=가로→상단(BPTOP), 세로→좌측(BPLFT) 자동결정 + 회전. 우리 finish-button 단순선택 — 자동결정 **누락 MAJOR**.
- **C-10 ApparelSingleSizeQty 기본사이즈=활성 중간값** (deob_07:302~306): `activeSizes[Math.trunc(len/2)]`. 우리 defaultSelections는 **첫 활성값**(WS:115). 기본선택 지점 상이 — **MINOR**(의류 미지원이라 무증상).
- **C-11 PAK_ETC↔CLD_STD 연동** (deob_07:2758): 달력규격 값 연동. 우리 독립 finish-button — **MINOR**.

→ **P5 핵심 갭 6 + 보강 5 = 11건**. 전부 "Red 컴포넌트 setup watch의 파생/연동을 우리 평면 컨트롤이 안 들고 있음". 공통 처방: **파생은 leaf가 아니라 adapter(정적 파생) 또는 cascade.ts(동적 연동)로 승격**.

---

## 2. 후가공 14손실 재현 SPEC (S3가 만들 것 — 구현 아님)

> P1 L-1~L-14를 S3 빌드 단위로 구체화. 각 항목: **현 손실 → 재현 데이터모델 → 재현 컨트롤/룰 → 검증기준**. 코드 미작성.

### SPEC-L2 — COT_DFT / SCO_DFT 복합 2축 (BLOCKER)

**현 손실**: 어댑터가 PCS_DTL_CD(예 `TCMAS`=무광단면)를 평면 단일선택 값으로 나열(RA:117~121). Red는 단/양면 라디오 + 코팅 그리드 2축, `value={coating}{side}` 합성(mod_07:2247~2249, `c=slice(-1)`, `u=slice(0,4)`, `d=u+c`).

**재현 데이터모델 (어댑터)**:
- COT_DFT(및 SCO_DFT) PCS_CD 감지 시, 평면 values를 **2 파생그룹**으로 분리:
  - `GRP_PCS_COT_DFT__side`: option-button. values = distinct `slice(-1)` (S=단면, D=양면). 라벨맵(단면/양면)은 PCS_DTL_NM 또는 어댑터 상수.
  - `GRP_PCS_COT_DFT__coating`: finish-button. values = distinct `slice(0,4)` (TCMA/TCGL/TCEB/TCSL/TCHL/TCSD/TCSS/TCST). 라벨=PCS_DTL_NM.
- 각 값의 `disabled`는 disabledOptions가 그 조합을 막는지로 계산(C-2 폴백 연동).
- **합성 메타**: 두 그룹에 공통 `composite: { pcsCd:'COT_DFT', recombine:'coating+side' }` 표식(계약 확장 필요) 또는 그룹 id 규칙(`__side`/`__coating` suffix)으로 직렬화가 식별.

**재현 컨트롤**: 신규 컨트롤 불필요 — 기존 option-button(side) + finish-button(coating)을 2 OptionGroup으로 렌더하면 충분. **단 가격 직렬화가 재합성해야 함**.

**재현 직렬화 (어댑터 가격, RA:423~428 확장)**: `finishesFromSelections`/`serializeRedPriceRequest`가 `__side`+`__coating` 짝을 만나면 `PCS_DTL_COD = coating + side`로 **재합성**해 단일 PCS_INFO 엔트리 생성. (현재는 각각 별도 엔트리로 가버려 PCS_DTL_COD가 반쪽코드가 됨 → 침묵 가격오류.)

**검증기준**: BCSPDFT 등 코팅보유 fixture에서 (a)단/양면×코팅 전 조합이 유효하게 선택가능, (b)선택 결과 PCS_INFO의 PCS_DTL_COD가 Red 합성코드(예 `TCMAD`)와 일치, (c)존재하지 않는 조합은 disabled.

---

### SPEC-L3 — ROU_DFT 멀티선택 + 4귀 전체토글 + 사이즈연동 반경 (MAJOR)

**현 손실**: `multiple:false` 고정(RA:129), ATTB 없음(price:13~16), 반경맵 미이식. Red(mod_07:3325~3344): `u`=선택목록 배열(멀티), `l`=전체토글(양방향 watch 3327~3330: all체크→전 4개, all해제+4개→비움; 선택4=all on), 각 값→`{PCS_DTL_CD, PCS_DTL_NM, ATTB:반경}`(3334~3341). 반경 `i`=`roundingConfigMap[pdtCode]` factor==='size'면 `value[DIV_SEQ]`, 아니면 4mm/6mm 라디오(3300~3321).

**재현 데이터모델 (어댑터)**:
- ROU_DFT PCS_CD 감지 → `multiple:true`(prod:59 이미 존재) + 4귀 values.
- 반경: `roundingConfigMap` 이식. `factor==='size'`면 반경은 **사이즈 의존 단일값**(라디오 불필요, 자동), 아니면 별도 그룹 `GRP_PCS_ROU_DFT__radius`(option-button: 4mm/6mm).
- ATTB 슬롯: 선택된 4귀 각각에 `attb=반경`을 실어야 함 → `OptionValue.attb?` 또는 selection 직렬화 시 그룹 단위 ATTB.

**재현 컨트롤**: 멀티선택 컨트롤 필요. 기존 finish-button은 단일(value=string). **신규 또는 finish-button 멀티변형**: 체크박스 그리드 + "4귀 전체" 토글 버튼. 선택 = `string[]`(prod:59 multiple로 store가 배열 보관, WS:27 `SelectionValue=string|string[]`이미 지원).

**재현 룰 (cascade.ts)**: size 그룹(GRP_SIZE) 변경 시 `factor==='size'`인 ROU 그룹의 ATTB(반경) 재계산 → C-1.

**재현 직렬화**: 선택 배열의 각 PCS_DTL_COD에 동일 ATTB(반경) 부여. → SPEC-L1(ATTB) 의존.

**검증기준**: 라운딩 상품에서 (a)4귀 중 임의 부분집합 선택가능, (b)전체토글 동작, (c)사이즈 변경 시 반경 ATTB 자동전환, (d)PCS_INFO에 각 귀+ATTB 운반.

---

### SPEC-L4 — END_PAP 색상 hex 상수맵 → color-chip (MAJOR, "산출 0" 오판 정정)

**현 손실/정정**: 이전 `componenttype-mapping-matrix.md`는 "color-chip 산출 0 = Red 색 데이터 없음(CLR_HEX_CD 빈값)"이라 했으나 **부정확**. 정확: Red는 색 hex를 **옵션데이터가 아니라 END_PAP 컴포넌트 내부 상수맵**에 둔다(mod_07:2511~2522):
```
CLYEL #fdeec5 / CLMIN #d5edea / CLWHT #ffffff / CLPPL #e0def0 / CLPIN #f6e6f1
CLAPR #fde7dc / CLGRN #e4f2e8 / CLBLU #adccec / CLSKY #bae5fb / CLGRY #ededee
```
options의 `value`(COD)를 키로 룩업→`{COD,COD_NME,HEX}`→ColorChipSelector(mod_07:2523~2543). 우리 어댑터는 PCS를 무조건 finish-button(RA:126), colorHex는 mtrl만(RA:97) → **hex맵 미이식 = 데이터경로 0**. (우리 ColorChip은 `v.colorHex` 렌더 가능 — 데이터만 없음.)

**재현 데이터모델 (어댑터)**:
- 어댑터에 **색상후가공 hex 상수맵** 보유: `PCS_COLOR_HEX: Record<PCS_CD, Record<COD, hex>>`. END_PAP의 10색이 첫 엔트리. (후니 컨버전 시 후니가 hex를 옵션필드로 주면 그 경로로 대체.)
- `mapPcsGroups`에서 `PCS_COLOR_HEX[pcsCd]` 존재 시 → `pcsComponentType(true)`(=color-chip, 또는 large-color-chip) + 각 OptionValue에 `colorHex = PCS_COLOR_HEX[pcsCd][PCS_DTL_CD]` 주입.

**재현 컨트롤**: 변경 불필요. `ColorChipGroup`/`LargeColorChipGroup`이 `v.colorHex`로 이미 렌더(ColorChip:35,55). 어댑터가 hex만 채우면 즉시 동작.

**검증기준**: END_PAP 보유 상품(책자 면지)에서 (a)10색 원형칩 렌더, (b)선택 색이 PCS_DTL_NM "면지(색명)" 형태로 운반(mod_07:2533), (c)hex가 mod_07:2511 맵과 일치.

**컨버전 게이트**: 후니 옵션마스터 수령 시 "어떤 PCS에 색명/hex가 있나" 최우선 확인 — Red 상수맵 방식 vs 후니 데이터필드 방식 결정.

---

### SPEC-L1 — ATTB 전손실 (BLOCKER, L-3·복합 전제)

**현 손실**: `SelectedFinish={groupId,valueId}`(price:13~16) ATTB 필드 없음. `serializeRedPriceRequest` `ATTB:''` 하드코딩(RA:427). red-types PCS_INFO는 `ATTB?` 허용(red-types:178)하나 항상 ''.
**재현**: `SelectedFinish`에 `attb?:string` 추가 → `finishesFromSelections`가 그룹/값의 attb 수집 → 직렬화 echo. 컨트롤(RIN/ROU/COT)이 attb를 selection에 실어야 함(OptionValue.attb 또는 그룹 메타).
**대상 PCS**: RIN_DFT(링색), ROU_DFT(반경), BID_SIL(속성), COT_DFT(side는 합성으로 대체), DIR_MTR(Apparel 수량).
**검증기준**: ATTB가 가격에 영향주는 후가공의 PCS_INFO.ATTB가 비어있지 않고 Red 값과 일치.

---

### SPEC-나머지 손실 — 간결 재현노트

| L-ID | 후가공/항목 | 재현 노트 (S3 빌드 단위) |
|------|-------------|--------------------------|
| L-5 | DosuColor 색상축(BNC) | C-6: all>dosu면 색상 OptionGroup 추가, dosu→색상옵션 필터 cascade. priceColorCount는 유지(가격). |
| L-6 | Paper 2단(PTT+WGT) | 자재를 PTT(종류) select + WGT(평량) select 2단으로 분리, WGT는 선택 PTT의 weights에 의존(cascade). 값=mtrl 1그룹 보존 유지하되 UI만 2단. |
| L-7 | PRT_WHT_FACE 다중면, SUB_MTR_Multi | `multiple:true` 판정을 PCS별로(WEB_PCS_DTL_GRP/면 기준). 멀티 컨트롤(L-3 공용). |
| L-8 | CLD_STD/CVR_INN/INN_DFT select형 | 어댑터에 "PCS 값타입=select" 분기 추가 → finish-select-box(prod componentType 이미 존재). INN_DFT는 +수량입력. (D-5 임계치 결함과 연결.) |
| L-9 | (P5 C-1~C-6) | §1 표 처방 — adapter 정적파생 + cascade.ts 동적연동. |
| L-10 | VIEW_YN 런타임 add/remove | Red `v()`(mod_06:1452)는 후가공 그룹을 런타임에 추가/삭제+가격재계산. 우리는 정적 optionGroups. cascade.ts에 그룹 visible 동적토글 + 가격 invalidate. |
| L-11 | 멀티/다단 수량 (ApparelMultiSize, CalendarQty 디자인수) | store에 다축 수량 슬롯(현 단일 `quantity` WS:133). 사이즈별/디자인수별 배열. counter 멀티인스턴스. |
| L-12 | Acc 부자재 캐스케이드 | accFilterConfigMap(uiType CASCADE/MULTI, GRP_TYPE 4분기) 어댑터 이식 → 1/2/3단 종속 OptionGroup + 요약리스트(추가버튼·삭제·카운터). 신규 큰 단위. |
| L-13 | 의류(Apparel) 전 경로 | 의류 전용 어댑터 분기(apparel_info: print_type/color/size_color/pantone/print_area). C-3/C-4 자동구성 포함. 신규 큰 단위. |
| L-14 | BIND_DIRECTION 자동방향(C-9), BookQty 표시(C-7/C-8), CoverGuide/SubjectGroup | 개별 MINOR. 자동방향만 MAJOR(잘못된 방향=오주문 위험) → adapter 파생. |

---

## 3. 처방 위치 원칙 (어디에 살아야 하나 — 단순성 가드)

> Red는 파생을 컴포넌트에 분산했으나, 우리 아키텍처는 **위젯=정규화 계약만 소비, 파생은 어댑터/스토어**(INV-1). 따라서:

| 파생 성격 | 살 곳 | 이유 |
|-----------|-------|------|
| **정적 파생**(상품로드 시 결정: COT 2축분리, END_PAP hex주입, PRT_WHT 자동, select형 분기, 의류 그룹생성) | **adapter** (red-adapter.ts) | 상품 데이터→그룹구조는 어댑터 책임. 위젯은 결과 OptionGroup만 렌더. |
| **동적 연동**(선택 변경 시 재계산: size→반경, dosu→색상, disable폴백, VIEW_YN토글, Acc 다단) | **cascade.ts** (룰엔진 확장) | 이미 material→disable이 사는 곳. 룰 타입 확장(현 1종→다종). |
| **순수 입력검증**(클램프·짝수·합성) | leaf control 또는 adapter inputSpec | BookQty 클램프는 이미 CounterInput. 합성은 직렬화(어댑터). |
| **selection 직렬화**(ATTB 재합성, COT recombine) | adapter 가격 직렬화 (serializeRedPriceRequest) | PCS_DTL_COD 복원은 가격계약 책임. |

**과설계 금지**: 신규 leaf 컨트롤은 **2개만** 정당화됨 — (a)ROU/멀티후가공용 멀티선택 체크박스+전체토글(L-3/L-7 공용), (b)Acc 부자재 캐스케이드 패널(L-12, 부자재 컨버전 시). 나머지는 **기존 14 컨트롤 재사용 + 어댑터/cascade 파생**으로 충분. COT_DFT조차 신규 컨트롤 불필요(option-button+finish-button 2그룹 + 직렬화 재합성).

---

## 4. 검증 메타 (회의적 점검)

- **계약은 이미 일부 준비됨**: `OptionGroup.multiple`(prod:59), `SelectionValue=string|string[]`(WS:27), `ColorChip v.colorHex`(ColorChip:35), `red-types PCS_INFO.ATTB?`(red-types:178) — **구조는 있으나 어댑터가 안 채움**. L-3·L-4는 신규 타입보다 **어댑터 파생 추가**가 본질. 단 `SelectedFinish.attb`와 COT 2축 식별 표식은 계약 확장 필요(L-1·L-2).
- **무증상 손실 주의**: C-3~C-5, L-12/L-13은 의류·부자재 미지원이라 **현 fixture로 증상 안 보임**. 후니 컨버전에서 해당 상품군 들어오면 즉시 발현 → S3 우선순위는 가격직결(L-1/L-2 BLOCKER) > 현 상품군 발현(L-3/L-4) > 컨버전 발현(L-12/L-13).
- **C-2 폴백의 가격함의**: disable 후 빈 선택(우리) vs 활성값 자동채움(Red) — required 후가공이 빈 채로 가격요청되면 PCS_INFO 누락 → 가격차. MINOR로 봤으나 required PCS면 MAJOR 가능. P2(가격) 재확인 권고.
- **"산출 0" 정정의 파급**: L-4가 large-color-chip은 Red에 baseline 실재(END_PAP)임을 확정 → 시각재현(P3) 백로그에서 "데이터부재 제외"였던 것을 "어댑터 이식 후 재현가능"으로 재분류. 이전 매트릭스 §2(②5종)의 color/large-color-chip 항목 정정 필요.
