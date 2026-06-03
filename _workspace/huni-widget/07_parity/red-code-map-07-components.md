# red-code-map-07-components.md — Red 컴포넌트 레이어 코드구조 전수맵 (STAGE S0)

> **목적**: RedPrinting 디옵스케이트 소스(`deob_07`/`mod_07`)를 권위로 삼아, 옵션렌더·컴포넌트 디스패치·캐스케이드 UI·제품분기의 **책임/로직/분기 구조**를 빠짐없이 추출한다. 판정(parity verdict) 아님 — S1이 우리 React를 이 축에 대응시킬 hook을 만든다.
> **범위**: deob_07 컴포넌트 레이어(가장 큰 모듈, 134KB). 디스패치 글루 일부는 deob_06(widget_sdk, 형제 에이전트 담당)에 있으나, 본 컴포넌트 카탈로그를 확정하려면 그 디스패치 맵을 인용해야 하므로 **인용만** 함(deob_06 전수 매핑은 형제 산출물).
> **근거 표기**: `deob_07:N`=deobfuscated 라인, `mod_07:N`=beautified source 라인, `mod_06:N`=widget_sdk source 라인, `stats`=deob_07_stats.json.
> **핵심 구조 발견(요약)**: Red는 `componentType` 문자열 디스패치를 **쓰지 않는다**. 두 가지 디스패치 메커니즘이 공존한다 — ⓐ **상품군별 조건부 렌더트리**(Apparel/Book/Acc 메인이 `data.xxx?` 존재여부 + 모드 플래그로 자식을 켜고 끔), ⓑ **PCS_CD → Vue 동적임포트 맵**(후가공 31종, `mod_06:1412~1442`). 우리의 14종 `componentType` switch는 Red 구조의 **재분류**이지 1:1 대응이 아니다.

---

## 0. 컴포넌트 인벤토리 (stats 기준, 코드로 검증)

`deob_07_stats.json`: **총 38 컴포넌트**. 분류:

| 분류 | 개수 | 컴포넌트 |
|------|------|----------|
| 메인(상품군) | 3 | Apparel(`mod_07:~830`), Book(`deob_07:1375`/메인 span), Acc(`deob_07:2006`) |
| 서브(공통) | 10 | ApparelSizeGbn, ApparelSingleSizeQty, ApparelMultiSizeQty, PantoneChipModal, ApparelPrintColor, PAK_POL_Simple, BookQty, DosuColor, Paper, CoverGuide |
| 후가공(PostProcess) | 26 | ADC_PVC, BID_SIL, BIND_DIRECTION, BON_PAP, BON_SHT, CLD_STD, COT_DFT, COT_SEG, CVR_INN, CVR_SWN, DIR_MTR, END_PAP, INN_DFT, INS_COT, LAB_FBR, PAK_ETC, PAK_POL, PDT_WRK, PRT_IPK, PRT_WHT, PRT_WHT_FACE, RIN_DFT, ROU_DFT, SCO_DFT, SUB_MTR_BC, WRK_MTR |
| 자재 | 1 | Basic |
| 수량 | 4 | CalendarQty, SetQty, SimpleQty, TotalQty |

> **주의**: deob_07 본문은 2608줄에서 끝나며, 후가공 26종 + 수량 4종(섹션 16~28)은 **개별 디옵스케이트 안 됨**(stats가 "동일 패턴 반복 ~2400줄을 헤더주석으로 대체"라 명시). 그 본문은 `mod_07`(beautified)에서 직접 읽음. 본 맵의 후가공 카탈로그는 mod_07 원본 라인 근거.
> **디스패치 맵에만 등장하는 추가 3종**(stats 미목록): `SUB_MTR`, `SUB_MTR_Multi`, `PAK_POL_Simple`(stats엔 sub로 있음). 동적임포트 맵(mod_06:1412~1442)은 **31 항목**이라 후가공 실집합은 26 + {SUB_MTR, SUB_MTR_Multi, PAK_POL_Simple} 변형 포함 ≈ 29~31. (정확한 맵은 §2.)

---

## 1. componentType 카탈로그 (CODE 권위 — 책임/렌더/입력/검증/제품조건)

> Red엔 "componentType enum"이 없으므로, **컴포넌트(=책임 단위)** 단위로 카탈로그한다. 각 행이 우리 14종 중 무엇에 대응되는지는 §4 재조정표.

### 1-A. 메인 상품군 컴포넌트 (디스패처 역할 겸함)

| 컴포넌트 | file:line | 렌더(자식) | inputs/props | 인터랙션/디스패치 로직 | 제품조건 |
|----------|-----------|-----------|--------------|----------------------|----------|
| **Apparel** | `deob_07:830`~`1148` | ApparelPrintType / ApparelColorSelector / ApparelSingleSizeQty / ApparelMultiSizeQty / ApparelPrintArea / ApparelPrintColor / SubjectGroup / PAK_POL_Simple / FileUpload | `type, data, widgetAttr, defaultData, senecaInfo` | **조건부 렌더트리**(switch 아님). 각 자식 = `instance.data.apparel_info?.X ? render : comment`(deob_07:1091~1146). `sizeSelectionMode`(deob_07:937): PRINT_GBN==='N'→single, COD==='PTP_SLK'→multi, else single. PTP_SLK일 때만 ApparelPrintColor(팬톤). | 의류류(AC*). `pdtCode.startsWith("AC")`로 PRT_WHT 자동(mod_06:1496) |
| **Book** | `deob_07:~1375`(메인 span 1900~1957) | SizeSelect, BookQty(×2: default/inner), DosuColor(×2), Paper(×2), CoverGuide, HiddenPostProcess, VisiblePostProcess, FileUpload, SubjectGroup | `type, data, widgetAttr, defaultData, senecaInfo` | **조건부 렌더트리**. 내지/표지 그룹별 view_yn 게이트: `skinInfo.value.sizeSelect.view_yn==="Y"`(deob_07:1837), `dosuSelect.view_yn==="Y" && instance.data.inner_pdt_dosu_bnc_info`(deob_07:1856). 단일자재면 Paper 숨김(`coverMaterials.length>1`, deob_07:1908). 후가공은 Hidden/Visible 위임. | 책자류(PRBK*). 토너책자=`pdtCode[4]==="O"` |
| **Acc** | `deob_07:2006`~`2291` | OptionRow×N (filter별 Selector) + add-btn + 요약리스트(counter/price) | `type, data` | **config-driven 디스패치**: `accFilterConfigMap[pdtCode][pttCode]`(deob_07:2027)가 `uiType`(CASCADE/MULTI/단일) 결정. `filters[].GRP_TYPE`(MTRL_MULTI_GRP/MTRL_GRP/MTRL_SUB_GRP/기본)이 Selector 4종 분기(deob_07:2201~2225). `handleAddOption`(deob_07:2118)이 uiType별 검증 후 addItem. | 부자재류(AC* 부자재). filterConfigMap에 등록된 상품만 캐스케이드 |

### 1-B. 서브 컴포넌트 (옵션값 처리·검증 보유)

| 컴포넌트 | file:line | 렌더 | inputs/props | 검증/변환 로직 | 우리축 |
|----------|-----------|------|--------------|----------------|--------|
| **ApparelSizeGbn** | `deob_07:197` | RadioList(adult/child) | options, default | 라디오 토글→update(gbn). 옵션 2개 하드코딩. | option-button(라디오) |
| **ApparelSingleSizeQty** | `deob_07:264`~`404` | OptionRow(ButtonRadio 사이즈)+OptionRow(수량 select/input 토글) | options, sizeInfo | 사이즈 GBN 그룹핑(deob_07:279)→ORD 정렬(deob_07:290)→HIDE_YN disabled. `defaultSizeCode`=활성 중간값(deob_07:302). 수량 1~10 select 또는 직접입력 토글(deob_07:297). QUICK_ORD_YN==='N'→퀵오더불가 경고(deob_07:338). 에디터 편집 후 onReset('size'). | option-button + counter/select |
| **ApparelMultiSizeQty** | `deob_07:268`(stats)/본문 411~ | 사이즈별 +/- 카운터 테이블 | options, sizeInfo | 사이즈별 수량 +/- 버튼 + 직접입력(disabled 처리). 실크(PTP_SLK) 모드 전용. | counter-input(멀티) |
| **PantoneChipModal** | `deob_07:434`~ | 모달(검색/팔레트/미리보기) | options | 팬톤 검색 필터(검색문구/실패문구). 색칩 그리드 렌더(deob_07:670). | color-chip(모달형) |
| **ApparelPrintColor** | `deob_07:552` | OptionRow + PantoneChipModal 트리거 | options | 팬톤 선택 위임. PTP_SLK일 때만 표시. | color-chip 래퍼 |
| **PAK_POL_Simple** | `deob_07:611` | 라디오(선택안함/선택함) | detail | 개별포장 단순 2값 라디오→postProcessState.PAK_POL. | finish-button(2값) |
| **BookQty** | `deob_07:1195`~`1317` | OptionRow(select/input 토글 + notes) | type('default'\|'inner'), options, relatedData | **클램프 검증 핵심**: `minQuantity`/`maxQuantity`(inner만)(deob_07:1219). `handleFocusOut`(deob_07:1237): min미만→min, max초과→max, default+짝수필수(FIR_CNT===2)→짝수보정, inner+step===2→짝수보정. `requiresEvenCount`(deob_07:1217). 토너책자(`pdtCode[4]==='O'`) 안내문구 분기(deob_07:1296). 양면(SID_D)→×2 페이지(deob_07:1233). select옵션 동적생성(deob_07:1250). | counter-input / page-counter-input |
| **DosuColor** | `deob_07:1336`~`1390` | OptionRow(도수 select + 색상 select 2단) | options{dosu,color,all} | 2단 셀렉트. `showColorSelect`=all.length>dosu.length일 때만 색상셀렉트(deob_07:1350). matchedDosuOption=`all.find(BNC_GB===color && COD===dosu)`(deob_07:1354). 에디터 편집후 onReset('dosu'). | option-button(도수) 또는 select |
| **Paper** | `deob_07:1411`~ | OptionRow(용지종류 select + 평량 select 2단) | options, showExtra, default | PTT(종류)+WGT(평량) 2단. paperTypeGroupMap으로 그룹핑(deob_07:1537). 평량은 선택종류의 weights(deob_07:1548). 주문불가자재 disabled(deob_07:1400 attrs). 영업주문 전용 필터. | select-box(2단) |
| **CoverGuide** | `deob_07:1267` | 미리보기 이미지 + 템플릿다운로드 버튼 | size-info, seneca-info | downloadTemplate API(deob_07:74). 비입력형(가이드). | (디스패처 외 — 가이드 UI) |

### 1-C. 후가공 컴포넌트 (PCS_CD별 — `mod_07` 본문 근거)

> 공통 계약(stats 6항): ① defineComponent ② props=data/options/relatedData ③ emits=["update"] ④ watch→`{PCS_CD, PCS_DTL_CD, PCS_DTL_NM, ATTB?}` 변환 ⑤ OptionRow(`fe`) 래퍼 ⑥ ImageButton(`je`)/select/radio 렌더. **모두 `emit('update', [{PCS_CD,...}])` 형태로 선택을 부모에 올림.**

| 컴포넌트(PCS_CD) | mod_07:line | 렌더 패턴 | 검증/변환 로직(코드 증거) | 우리축 |
|------------------|-------------|-----------|---------------------------|--------|
| **COT_DFT** (코팅) | `2186`~`2293` | RadioGroup(단면/양면) + IconCheckbox-grid(무광/유광/엠보/벨벳/홀로×4) | **값 분해/재조합**: `i(_)`=`{side:_.slice(-1), coating:_.slice(0,4)}`(2214). 라벨맵 하드코딩(2201~2212). `d=coating+side`(2249) watch→update(2257). PRBK*는 책자전용 imgPath맵(2250~2256). disabledOptions 변경시 활성코팅으로 폴백(2266). | (복합) option-button×2 또는 finish-button 조합 |
| **SCO_DFT** (스코딕스) | `3389`~(COT_DFT 동형) | 단면/양면 라디오 + 규격가이드 | COT_DFT 유사 복합(단면/양면). 규격가이드 첨부. | 복합 |
| **RIN_DFT** (링제본) | `3220`~`3261` | IconCheckbox-grid(attbOptions=색상) | `attbOptions[0]` 기본(3230). select→`{PCS_CD, PCS_DTL_CD:options[0].value, PCS_DTL_NM:name(attb), ATTB:value}`(3236). 색상 4종(검정/흰/금/은). imgPath=value. | mini-color-chip / finish-button(아이콘) |
| **ROU_DFT** (라운딩) | `3285`~`3382` | RadioGroup(4mm/6mm 또는 size-factor) + 체크박스 다중(4귀)+전체토글 | **체크박스 멀티+all토글**: `l`(all)↔`u`(선택목록) 양방향 watch(3327~3330): all체크→전체, all해제+4개→비움; 선택4개=all on. `i`(반경)=`roundingConfigMap[pdtCode]`가 factor==='size'면 사이즈별(3300), 아니면 4/6mm(3311). update=선택목록 map→`{PCS_CD, PCS_DTL_CD, PCS_DTL_NM, ATTB:반경}`(3334). | (복합) finish-button(멀티) + radio |
| **END_PAP** (면지) | `2501`~`2547` | ColorChipSelector(`sh`) | **하드코딩 HEX맵**: `s={CLYEL:"#fdeec5",...CLGRY:"#ededee"}` 10색(2511~2522). options→`{COD,COD_NME,HEX:s[value]}`(2523). 첫값 기본. update=`{PCS_CD, PCS_DTL_CD, PCS_DTL_NM:"면지(색명)"}`(2530). **색은 옵션데이터가 아니라 컴포넌트 내부 룩업**. | large-color-chip / color-chip |
| **ADC_PVC** (PVC커버) | `2312`(deob)/mod 본문 | IconCheckbox-grid(options) | 아이콘 선택→update. 기본 아이콘패턴. | finish-button(아이콘) |
| **BID_SIL** (실크인쇄) | `2364`(deob) | IconCheckbox-grid(attbOptions 속성값 포함) | 속성값(attbOptions) 보유. RIN_DFT 유사. | finish-button + attb |
| **BIND_DIRECTION** (제본방향) | `2447`(deob)/2472 | IconCheckbox(BPTOP/BPLFT) + 회전(rotationOptions) | **자동방향**: 가로(`horizontalBindSet` 포함)→상단(BPTOP), 세로→좌측(BPLFT). A/B 회전 선택(2481). | option-button + 자동결정 |
| **BON_PAP / BON_SHT** (본드) | `2037`/`2087`(deob) | IconCheckbox-grid | 아이콘 선택. | finish-button |
| **CLD_STD** (달력규격) | `2135`(deob) | BasicSelect | 셀렉트. PAK_ETC와 연동(달력규격). | select-box |
| **COT_SEG** (부분코팅) | `2303`(deob) | IconCheckbox-grid | 아이콘. | finish-button |
| **CVR_INN** (속표지) | `2352`(deob) | BasicSelect | 셀렉트. | select-box |
| **CVR_SWN** (재봉) | `2399`(deob) | IconCheckbox | 아이콘. | finish-button |
| **DIR_MTR** (직접자재) | `2447`(deob) | RadioGroup | 라디오. Apparel에서 자재맵 기반 자동구성(deob_07:992~1019). | finish-button(라디오) |
| **INN_DFT** (내지마감) | `2563`(deob)/mod | BasicSelect + 수량입력 | 셀렉트 + 수량. | select-box + counter |
| **INS_COT** (내부코팅) | `2656`(deob) | IconCheckbox | 아이콘. | finish-button |
| **LAB_FBR** (라벨원단) | `2707`(deob) | IconCheckbox | 아이콘. | finish-button / image-chip |
| **PAK_ETC** (포장기타) | `2758`(deob) | (달력규격 연동) | CLD_STD 값 연동. | (복합) |
| **PAK_POL** (폴리백) | `2882`(deob) | IconCheckbox | 아이콘. PAK_POL_Simple은 라디오 변형. | finish-button |
| **PDT_WRK** (작업방식) | `2932`(deob) | (주문수량 연동) | 주문수량 기반. Apparel 인쇄영역별 자동구성(deob_07:1024~1051). | (복합) |
| **PRT_IPK** (개별포장표시) | `3016`(deob) | 상시 active 표시 | 항상 활성(읽기전용 표시). | finish-button(고정) |
| **PRT_WHT** (화이트인쇄) | `3136`(deob)/mod | RadioGroup(자동/수동) | `pdtCode.startsWith("AC")` 자동결정(mod_06:1496). ACTHFCO 예외. useWhiteReset(deob_07:122). | option-button(라디오) |
| **PRT_WHT_FACE** (화이트면) | `3035`(deob) | 체크박스(전면/후면) | 면 선택. PRT_WHT와 연동. | finish-button(다중) |
| **SUB_MTR_BC** (보조자재) | `3490`(deob) | (사이즈 연동) IconCheckbox | 사이즈 기반. `_=Set(["PDT_WRK_PP","SUB_MTR_BC"])` imgPath 예외(mod_06:1386). | finish-button |
| **WRK_MTR** (작업자재) | `3546`(deob) | 아이콘/라디오 하이브리드 | 하이브리드. | finish-button/radio |
| **SUB_MTR / SUB_MTR_Multi** | mod_06 맵만 | (자재 셀렉트/멀티) | 디스패치 맵 전용. `y==="SUB_MTR"?me:y`로 WEB_PCS_DTL_GRP 라우팅(mod_06:1442). | select-box |

### 1-D. 수량 컴포넌트 (에디터 연동)

| 컴포넌트 | line(stats) | 로직 | 우리축 |
|----------|-------------|------|--------|
| **CalendarQty** | 3744 | 디자인수 + 수량 2단. z_(calendarPdfOnlySet) 분기. | counter×2 |
| **SetQty** | 3929 | 세트 수량. 에디터 연동, 오늘/내일출발 안내. | counter |
| **SimpleQty** | 4026 | 세트단위 계산 단순수량. | counter-input |
| **TotalQty** | 4189 | 총수량. 에디터 연동, 디자인건수. | counter-input |

---

## 2. 디스패치 로직 (정확한 메커니즘 — 케이스 전수)

### 2-A. PCS_CD → Vue 컴포넌트 동적임포트 맵 (`mod_06:1412~1442`) — **후가공 디스패치의 심장**

> 위치: widget_sdk(deob_06, 형제 담당). 그러나 **컴포넌트 카탈로그 확정에 필수**라 전수 인용. `p` computed가 `n.options`를 PCS_CD별로 묶고(`b.set(y, {...})`, mod_06:1404), 각 그룹에 `component: 동적임포트(`../postPcs/${y}.vue`)`를 부여(1412). 즉 **PCS_CD 문자열이 곧 파일명 = 디스패치 키**.

전체 31 케이스(`../postPcs/{KEY}.vue`):
```
ADC_PVC, BID_SIL, BIND_DIRECTION, BON_PAP, BON_SHT, CLD_STD, COT_DFT,
COT_SEG, CVR_INN, CVR_SWN, DIR_MTR, END_PAP, INN_DFT, INS_COT, LAB_FBR,
PAK_ETC, PAK_POL, PAK_POL_Simple, PDT_WRK, PRT_IPK, PRT_WHT, PRT_WHT_FACE,
RIN_DFT, ROU_DFT, SCO_DFT, SUB_MTR, SUB_MTR_BC, SUB_MTR_Multi, WRK_MTR
```
- 라우팅 특례: `${y==="SUB_MTR"?me:y}.vue`(mod_06:1442) — SUB_MTR은 `WEB_PCS_DTL_GRP`(me)로 실파일 라우팅 → SUB_MTR_BC/SUB_MTR_Multi 분기.
- 그룹 메타: `name`=Gl[y]?WEB_PCS_DTL_GRP_NM:PCS_GRP_NM(1405), `imgPath`=`{PCS_CD}_{pdtCode}`(예외 set `_`=1386), `disabled`=ESN_YN==='Y'(1411).
- attbOptions 병합: `f.value[y]`(속성값 보유 PCS, 예 RIN_DFT/BID_SIL)면 `attbOptions` prop 추가(1443).

### 2-B. 후가공 분류 디스패치 — Hidden vs Visible (`classifyPostProcessOptions`, mod_06:2618~2661 / deob_06:609 참조)

- Book 메인이 `parsedPostProcessOptions.value.postPcs.hidden`/`.visible`로 나눠(deob_07:1917/1928) **HiddenPostProcess**(자동적용, UI없음) / **VisiblePostProcess**(아이콘 UI)로 위임.
- VisiblePostProcess가 §2-A 동적임포트 맵으로 각 PCS 컴포넌트를 렌더.
- 특수 분류(mod_06:1180): `LAS_DFT`→레이저그룹(v), `THO_*`→타공그룹(E), `ROU_DFT`→라운딩그룹(k), 나머지→일반(N).

### 2-C. 부자재 Selector 분기 (`Acc`, deob_07:2201~2225) — **4 케이스**

```
filterDef.GRP_TYPE === "MTRL_MULTI_GRP" → Selector(멀티그룹, multiGroupSelections)
                   === "MTRL_GRP"       → Selector(1단, primarySelection)
                   === "MTRL_SUB_GRP" && options → Selector(2단, secondarySelection)
else (기본/3단)                          → Selector(자재, tertiarySelection)
filterConfig 없음                        → Selector 단일(material)  [deob_07:2227~2238]
```
- uiType별 추가검증(`handleAddOption`, deob_07:2118): CASCADE는 1단/(2단)/3단 순차검증, MULTI는 그룹별 전수.

### 2-D. 메인 자식 디스패치 — **조건부 렌더트리(switch 아님)**

- **Apparel**(deob_07:1091~1146): 8개 자식 각각 `data.apparel_info?.X ? V(child) : oe()`. 모드플래그(`sizeSelectionMode`)로 Single/Multi 사이즈 택1. PTP_SLK 게이트로 PrintColor.
- **Book**(deob_07:1837~1950): `skinInfo.value.{section}.view_yn==="Y"` + 데이터존재로 게이트. 단일자재→Paper 숨김.
- 이것이 "제품분기"의 1차층 — **데이터 존재여부가 곧 컴포넌트 존재여부**.

---

## 3. 캐스케이드 UI 동작 (코드 로직)

### 3-A. 필수/숨김 자동적용 (`rs()` = onMounted, mod_06:1470~1494)
- 상품 로드 시 옵션 순회: `ESN_YN === "N"` 이거나 비활성이면 skip, 아니면 `i[C]=[{PCS_CD,...,VIEW_YN,ESN_YN,selectedOptions:[기본]}]`로 **필수 후가공 자동 선택**. (cascade-rules #5 pcs essential/hidden.)

### 3-B. VIEW_YN 토글 add/remove (`v(b,C,y)`, mod_06:1452~1463)
- `C==="Y"`(강제표시) 또는 미선택이면 `i[I.value]=[{VIEW_YN:"Y",...}]`(추가), 아니면 `delete i[I.value]`(제거) → `c(b)`(가격재계산 트리거).
- 우리 cascade.ts엔 VIEW_YN 동적 add/remove가 **없음**(disable만 처리). → §4 GAP.

### 3-C. material → pcs disable (cascade-rules #1, 우리 cascade.ts:31~77로 구현됨)
- Red: COT_DFT가 `disabledOptions` 변경 watch→활성코팅 폴백(mod_07:2266). 즉 **disable은 후가공 컴포넌트 내부에서도 자기보정**.
- 우리: `applyCascade`가 disableRules로 그룹/값 disabled 재계산 + 선택해제 연쇄(cascade.ts:50~77). **적용순서(자재변경→disable→선택해제→재계산) 보존됨** ✓.

### 3-D. 컴포넌트 내부 캐스케이드 (Red 고유 — 우리 미흡)
- **ROU_DFT** 사이즈→반경(`Yr[pdtCode].value[DIV_SEQ]`, mod_07:3331). 사이즈 바뀌면 4/6mm 자동전환.
- **COT_DFT** disabledOptions→코팅폴백(mod_07:2266).
- **Apparel** 인쇄영역→PDT_WRK 자동구성(deob_07:1024), 자재→DIR_MTR 자동구성(deob_07:992).
- **DosuColor** dosu↔BNC 매핑(cascade-rules #3) — `all.find(BNC_GB && COD)`(deob_07:1354).
- 이들은 컴포넌트 setup 내 watch로 처리 — **우리 React에선 어댑터/스토어 레벨로 끌어올려야** (§4).

---

## 4. 제품분기 열거 (컴포넌트가 커버하는 product-path 전수맵)

> "all products" = 코드가 분기하는 모든 상품경로. 컴포넌트 레이어가 분기하는 지점:

### 4-A. 1차 분기 — 상품군별 메인 선택 (widget_sdk가 pdtCode로 Apparel/Book/Acc 택1; 컴포넌트 레이어는 셋만 정의)
| 상품군 | 메인 | 판정 |
|--------|------|------|
| 의류 | Apparel | `pdtCode.startsWith("AC")`(mod_06:1496) |
| 책자 | Book | PRBK* 등. 토너=`pdtCode[4]==='O'`(deob_07:1212) |
| 부자재 | Acc | accFilterConfigMap 등록 상품 |
| (일반 인쇄·실사·달력·굿즈) | — | **컴포넌트 레이어에 전용 메인 없음** → §2-A/2-D의 후가공+수량 컴포넌트 조합으로 표현. (우리 어댑터는 이를 OptionGroup 평면화로 흡수) |

### 4-B. 2차 분기 — 상품코드 기반 Set/Map (컴포넌트 동작 변경)
| 맵/Set | 변수 | 효과 | file |
|--------|------|------|------|
| accFilterConfigMap | `K_` | 부자재 uiType(CASCADE/MULTI) | deob_07:2027 |
| roundingConfigMap | `Yr` | ROU_DFT 반경(size factor 여부) | mod_07:3301 |
| bookPageMultiplierMap | `Ll` | 책자 페이지 배수 | stats |
| horizontalBindSet | `J_` | BIND_DIRECTION 가로제본→상단 | stats |
| materialFilterSet | `$l` | Basic 자재 필터 | stats |
| whiteExclusionMap | `Fl` | PRT_WHT 제외자재 | stats |
| whiteAlwaysAutoSet | `_1` | PRT_WHT 항상 자동 | stats |
| deviceModelSet | `f1` | 기종 표시 | stats |
| calendarPdfOnlySet | `z_` | 달력 PDF전용 | stats |
| productCodeImageMap | (Apparel) | 인쇄영역 svg 경로 | deob_07:116 |
| COT_DFT PRBK 맵 | `h`(2250) | 책자 코팅 imgPath | mod_07:2250 |

### 4-C. 3차 분기 — 인쇄유형/모드 (Apparel 내부)
- `PRINT_GBN==='N'`(인쇄불필요)→single+업로드무효화(deob_07:1088).
- `COD==='PTP_SLK'`(실크)→multi사이즈+팬톤(deob_07:937/1123).
- `COD==='PTP_DTF'`/`PTP_DIR`→인쇄영역 가이드문구 분기(deob_07:165~178).
- 인쇄영역 front↔leftchest 상호배타(deob_07:140).

### 4-D. 4차 분기 — 값 변환 분기 (후가공 내부)
- COT_DFT: value=`{coating}{side}` 합성(mod_07:2249).
- ROU_DFT: size factor 유무→반경옵션 분기(mod_07:3300).
- BookQty: default/inner + 토너/윤전 + 짝수필수 분기(deob_07:1217/1244/1296).

→ **제품분기 총 조건수**(컴포넌트 레이어): 1차 4(상품군) + 2차 11(Set/Map) + 3차 4(인쇄유형) + 4차 다수. **분기의 본질은 "componentType switch"가 아니라 "데이터·상품코드 기반 조건부 렌더 + 컴포넌트 내부 값변환"**.

---

## 5. 우리 14+NC-1 대비 재조정 (match / extra in Red / merged·missed)

### 5-A. 매핑 요약
| 우리 componentType | Red 대응(책임 단위) | 정합 |
|--------------------|---------------------|------|
| option-button | ApparelSizeGbn, ButtonRadio(사이즈), PRT_WHT(라디오), BIND_DIRECTION, COT_DFT 단/양면 | **다대일 병합**. Red는 라디오/버튼을 개별 컴포넌트로, 우리는 1개 option-button으로 흡수 |
| select-box | Paper(2단), DosuColor(가능), CLD_STD, CVR_INN, SUB_MTR, BookQty(select모드) | **병합**. Red 2단 셀렉트(Paper/DosuColor)를 우리는 OptionGroup 2개로 평면화 |
| finish-button | 후가공 아이콘 다수(ADC_PVC, COT_SEG, CVR_SWN, INS_COT, LAB_FBR, PAK_POL, RIN_DFT, BON_*, SUB_MTR_BC, WRK_MTR…) | **대다수 병합**. Red 26 후가공 컴포넌트 → 우리 finish-button 1종이 흡수(pcsComponentType) |
| finish-select-box | (Red 무대응 — 값 많아도 항상 아이콘버튼) | **Red에 없음**. 우리 case는 존재하나 어댑터 산출경로 0(D-5 구조결함) |
| counter-input | BookQty(input모드), ApparelMultiSizeQty, SimpleQty, SetQty, TotalQty, Acc 요약카운터 | **병합**. Red는 상품별 수량컴포넌트 5종, 우리는 counter-input + 스토어 quantity |
| page-counter-input | BookQty(type='inner') | **1:1**. inner 장수 클램프 |
| dimension-matrix-input | SizeSelect(자유입력 프리셋) | **NC-1**. real_price+0×0 sentinel |
| area-input | (Red 무대응 — dimension-matrix로만) | **Red에 없음**(경계중복) |
| color-chip | PantoneChipModal(팬톤) | **부분대응**. Red는 모달형 팬톤 |
| mini-color-chip | RIN_DFT(링컬러 아이콘) | **부분**. Red는 imgPath 아이콘(hex 아님) |
| large-color-chip | **END_PAP**(면지 10색 hex) | **대응 있음!**(아래 핵심발견) |
| image-chip | LAB_FBR/INS_COT 등 아이콘 후가공(imgPath svg) | **부분**. Red 후가공 아이콘=실질 이미지칩이나 우리는 finish-button로 흡수 |
| price-slider | (Red 무대응) | **Red에 없음** |
| summary / upload-cta | (패널 — CoverGuide·FileUpload·요약) | 디스패처 외 |

### 5-B. **구조적 서프라이즈 (캡처·우리스펙이 놓친 것)**

1. **[핵심] color-chip `false`의 진짜 이유 = 색이 옵션데이터에 없고 컴포넌트 내부 하드코딩**.
   우리 매트릭스 D-2는 "Red에 CLR_HEX_CD가 0이라 false가 정확"이라 봤다. **코드는 더 정확한 그림을 준다**: END_PAP(mod_07:2511~2522)은 `{CLYEL:"#fdeec5",...}` **10색 hex를 컴포넌트 안에 하드코딩**하고 옵션의 `value`(COD)를 키로 룩업한다. 즉 Red의 색상칩은 "데이터에 hex가 없다"가 아니라 **"hex는 컴포넌트별 상수맵에 산다"**. → **후니 컨버전 시사**: 후니가 색을 옵션데이터로 줄지(우리 어댑터 hasColor 동적판정), 아니면 Red처럼 코드상수맵으로 줄지 결정해야. large-color-chip은 END_PAP로 **실제 baseline이 존재**(우리 매트릭스는 "산출 0"이라 했으나, Red 코드엔 살아있는 색칩 컴포넌트가 있다 — 단 우리 어댑터가 이 hex맵을 안 옮겼을 뿐).

2. **componentType 디스패치가 없다 = 우리 14종 switch는 Red의 "재분류"**.
   Red는 ⓐ데이터 존재 조건부 렌더 + ⓑPCS_CD 파일명 동적임포트. 우리 switch(OptionControl.tsx:20)는 어댑터가 부여한 componentType에 의존 → **어댑터가 Red의 두 디스패치를 14종으로 정규화하는 책임을 100% 짊어진다**. 이 정규화 규칙이 parity의 진짜 검증대상.

3. **후가공 26종이 우리 finish-button 1종으로 병합됨 — 복합 후가공(COT_DFT/ROU_DFT)이 손실 위험**.
   COT_DFT는 단/양면 라디오 + 코팅 아이콘그리드의 **복합 UI**(2개 입력이 1 PCS_DTL_CD로 합성). ROU_DFT는 **체크박스 멀티+전체토글+사이즈연동 반경**. 우리 finish-button 단일선택으로는 이 둘의 동작분기를 재현 못 함. → **S1 검증 필수 항목**.

4. **VIEW_YN 동적 토글 부재**. Red `v()`(mod_06:1452)는 후가공을 런타임에 add/remove(가격재계산 동반). 우리 cascade.ts는 disable만. → cascade GAP.

5. **컴포넌트 내부 캐스케이드**(ROU_DFT 사이즈→반경, COT_DFT disable폴백, Apparel 영역→PDT_WRK)가 우리는 어댑터/스토어로 안 올라옴.

---

## 6. "우리 구현과 대응시킬 축" (S1 hook — 책임 단위별 React 재현 요구)

> `src/widget/components/controls/`(14 controls) + `OptionControl.tsx`(dispatcher) + `stores/cascade.ts`가 **무엇을 재현해야 하는지** 책임 단위로 명시. S1은 이 표를 acceptance로 사용.

| Red 책임 | 우리 재현 위치 | 재현해야 할 분기/로직 | S1 검증 포인트 |
|----------|---------------|----------------------|----------------|
| **메인 조건부 렌더트리**(Apparel/Book) | 어댑터(red-adapter) → OptionGroup 평면화 | 데이터존재·view_yn·모드플래그(single/multi/PTP_SLK)를 OptionGroup 포함/제외로 변환 | 8개 Apparel 자식 조건이 OptionGroup 생성규칙으로 보존되는가 |
| **PCS_CD 동적디스패치**(31맵) | red-adapter(`pcsComponentType`) + finish-button | 각 PCS_CD가 적절 componentType으로 매핑. 복합(COT_DFT/ROU_DFT)은 단일버튼으로 깨지지 않게 | COT_DFT 단/양면+코팅 합성값(`{coating}{side}`)을 우리가 산출하는가 |
| **부자재 config 디스패치** | red-adapter(accFilterConfigMap 이식) + select-box | uiType(CASCADE/MULTI)·GRP_TYPE 4분기 → 다단 OptionGroup | Acc 1/2/3단 캐스케이드가 disableRules 외 별도 그룹의존으로 재현되는가 |
| **BookQty 클램프** | CounterInput/PageCounterInput | min/max·짝수보정·토너분기·양면×2 | handleFocusOut 4규칙(min/max/default짝수/inner짝수)이 inputSpec로 표현되는가 |
| **COT_DFT 분해/재조합** | (현재 finish-button) — **신규 복합컨트롤 필요할 수 있음** | side=slice(-1), coating=slice(0,4), 합성=coating+side | 단일 PCS_DTL_CD를 2축으로 쪼개 렌더 후 재합성 |
| **ROU_DFT 멀티+all토글+사이즈반경** | (현재 finish-button) — **멀티선택+토글 미지원** | all↔선택목록 양방향, 사이즈→반경(roundingConfigMap) | 4귀 전체토글, 사이즈변경시 반경 자동전환 |
| **END_PAP/large-color-chip hex맵** | ColorChip/LargeColorChip + 어댑터 | 컴포넌트 hex상수맵(10색) → OptionValue.colorHex 주입 | 어댑터가 PCS값(COD)→hex맵을 OptionValue.colorHex로 옮기는가 |
| **RIN_DFT attb** | mini-color-chip / finish-button | attbOptions(색상) + ATTB 페이로드 | ATTB 필드가 selection에 보존되는가 |
| **DosuColor 2단·BNC매핑** | option-button(도수)+select(색) 또는 dosuBncMapping | showColorSelect(all>dosu), matchedDosuOption(BNC_GB&COD) | dosu↔색 2단이 2 OptionGroup으로, BNC 매핑이 캐스케이드로 |
| **Paper 2단(PTT+WGT)** | select-box ×2 | 종류→평량 그룹의존 | 평량옵션이 선택종류에 의존하는 캐스케이드 |
| **필수자동적용(ESN_YN)** | 스토어 초기화 | onMounted시 ESN_YN==='N' 외 자동선택 | 초기 selection에 필수 후가공이 들어가는가 |
| **VIEW_YN 동적토글** | **cascade.ts 확장 필요** | 런타임 후가공 add/remove + 가격재계산 | (현재 미구현 — GAP, S1 결정) |
| **컴포넌트내부 캐스케이드** | **어댑터/스토어로 승격 필요** | ROU_DFT 사이즈→반경, COT_DFT disable폴백, Apparel 영역→PDT_WRK, 자재→DIR_MTR | 컴포넌트 setup watch 로직이 cascade 룰로 표현되는가 |
| **update 페이로드 형태** | selection 직렬화 | `{PCS_CD, PCS_DTL_CD, PCS_DTL_NM, ATTB?}` | 우리 selection이 동등 정보를 담는가(가격API 계약) |

---

## 7. OPEN (S1/build-plan 이관)

- **O-7A**: COT_DFT/SCO_DFT 복합(단·양면 + 코팅) — 우리 finish-button 단일선택으로 재현 불가. **복합 컨트롤 신설 vs OptionGroup 2개 분리** 결정 필요.
- **O-7B**: ROU_DFT 멀티선택+전체토글+사이즈연동 반경 — finish-button 멀티/토글 미지원. 재현 전략 미정.
- **O-7C**: large-color-chip = END_PAP가 **Red에 실재 baseline 보유**(hex 10색 하드코딩). 우리 매트릭스 "산출 0"은 어댑터 미이식 때문 — 시각재현 후보로 재분류 가능. 단 후니 데이터가 hex를 줄지 미정.
- **O-7D**: VIEW_YN 동적 add/remove(가격재계산 동반) — cascade.ts 미구현. 후가공 런타임 토글 상품이 있으면 필요.
- **O-7E**: 컴포넌트 내부 캐스케이드(사이즈→반경 등)를 어댑터/스토어 룰로 승격하는 범위 — Red는 컴포넌트에 분산, 우리는 cascade.ts 집중. 매핑 규칙 미작성.
- **O-7F**: 수량 컴포넌트 4종(Calendar/Set/Simple/Total)의 에디터 연동(오늘/내일출발, 디자인건수) — 우리 counter-input + 스토어로 흡수했으나 에디터 의존 분기 검증 필요.
