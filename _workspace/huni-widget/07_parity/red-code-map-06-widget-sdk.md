# Red 코드맵 — 모듈 06: Widget SDK 계층 (lifecycle / state / bridge)

> STAGE S0 — 구조 매핑 전용. parity 판정 없음.
> 권위 축: RedPrinting 실소스 (디옵스/뷰티파이). 우리 React 구현(Zustand·editor-bridge.ts·cascade.ts)이 이 책임/분기 구조에 1:1 대응되어야 한다.
> 근거 파일:
> - `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_06_app_widget_sdk.js` (디옵스 — 스토어/클래스 가독)
> - `docs/reversing/red_reverse_engineer/01_source/mod_06_app_widget_sdk.js` (뷰티파이 133KB — lifecycle·cascade·upload 실코드)
> - `docs/reversing/red_reverse_engineer/01_source/mod_05_app_api.js` (price 컨테이너·인스턴스 클래스·editor 프로세서)
> - `docs/reversing/red_reverse_engineer/01_source/beautified_editor_sdk.js` (RedEditorSDK — postMessage 브릿지 본체, **별도 모듈**)
>
> 파일 표기: `mod_06:LINE` = 01_source/mod_06, `mod_05:LINE` = 01_source/mod_05, `edsdk:LINE` = beautified_editor_sdk, `deob_06:LINE` = 디옵스본.

---

## 0. 핵심 구조 결론 (요약)

| 질문 | 코드 확정 답 |
|------|------|
| Pinia 스토어 개수 (4 vs 5) | **5개** — config / product / exterior / order / acc-order. (`deob_06:717,754,780,822,850`) 4로 세던 분석은 `config` 누락. |
| 브릿지 함수 위치 | 위젯 SDK(mod_06)에 **postMessage 없음**. 에디터 iframe 통신은 전부 **별도 RedEditorSDK 모듈(edsdk)**. 위젯↔에디터는 **호스트 콜백(`onOpenEditor`/`setEditorData`)으로 디커플**. |
| 캐스케이드 엔진 위치 | `Ql`=classifyPostProcessOptions(`mod_06:2618`) + VisiblePostPcs 컴포넌트의 disable 적용(`mod_06:1450-1564`) + useOrderState 집계(`qr` `mod_06:2697`). |
| 가격 트리거 debounce | **이중 debounce**: useOrderState 150ms(`mod_06:2742`) → COMMON 컨테이너 200ms(`mod_05:1937`). 기존 "300ms" 명세는 **불일치**. |
| 캡처가 놓친 구조 서프라이즈 | 아래 §7 — (a) 위젯이 RedEditorSDK를 직접 안 부름, (b) 200ms 이중 debounce, (c) `pdt_disable_pcs_info`는 MTRL_CD별 키맵으로만 적용(전역 disable 아님), (d) ACC 분기는 `init()`에서 `M1.has(pdtCode)`로 클래스 자체가 갈림. |

---

## 1. 책임 인벤토리 (Responsibility Inventory)

| Red 책임 | file:line | 로직 요약 | 제품/분기 조건 |
|----------|-----------|-----------|----------------|
| 위젯 부트 + Shadow DOM 마운트 | `mod_06:1-37` (`F1.init`) | clientKey 검증 → `attachShadow({mode:"open"})` → `#red-widget-root` div → `createApp(앱컴포넌트)` → `use(VueQuery)·use(router)·use(pinia)` → `setLocale` → `provide` 6키 → `widget.css link` 주입 → `mount` | `M1.has(pdtCode)` true→Acc 앱(`D1`)+`$1` 인스턴스, false→Common 앱(`T1`)+`L1` 인스턴스 |
| clientKey 가드 | `mod_06:4`, `deob_06:936` | `["red-mobile","red-pc"]`에 없으면 throw "존재하지 않는 사용자입니다" | 전제조건 |
| 제품 정보 로드 | `mod_05:741`(`G_`)→`mod_05:1798`(useQuery) | `GET /ko/product/get_digital_product_info` queryKey `["product/get", pdtCode(/pttCode)]`, `refetchOnWindowFocus:false`, `enabled=!!pdtCode` | pttCode 있으면 키에 합성 |
| 제품 데이터 → product 스토어 | `mod_05:1960` | `watch(o.value)` → `setProductBaseInfo(result)` | 전 제품 |
| 위젯 컴포넌트 선택(item_gbn 분기) | `mod_05:1821-1835` | `item_gbn`→ 동적 import 컴포넌트 매핑: vDigital_item/acrylic2025_item/clothes2025_item/book2025_item. 미정의는 Digital(`u`) fallback | item_gbn 기반 4+1 분기 |
| 옵션 상태 집계 (composable) | `mod_06:2697`(`qr`=useOrderState) | 각 옵션 행 `update(key,val)`→ `s.value[key]=val`; `watch(s.value, debounce 150ms)→emits.updateOrder`; pcsInfo는 별도 `a`(updatePcsOption)+postPcs `l`(updatePostPcs)에서 flat 병합 | acrylic/clothes는 select 데이터를 nested 키(acrylicSelectData/clothesSelectData)에 분기 적재 |
| 가격 파라미터 빌드 | `mod_05:1846`(`m`) | orderData→`{ORD_INFO:[{PDT_CD,MTRL_CD,CUT/WRK_WDT/HGH,PRN_CNT,ORD_CNT,DOSU_COD,PRN_CLR_CNT,…}], PCS_INFO:[{PCS_COD,PCS_DTL_COD,ATTB,ATTB_2,ATTB_3}], price_gbn, mb_cust_cod}` | book2025_item은 ORD_INFO 스키마 상이(CVR_/INN_ 분리, PAGE_CNT); clothes는 PRINT_TYPE 추가 |
| 가격 계산 mutation | `mod_05:767`(`Al`)→`mod_05:1807`(useMutation) | `POST /ko/product_price/get_ajax_price_vTmpl` type COMMON. `watch(p.value, debounce 200ms)→mutate` (빈값 skip `cn(O)`) | price_gbn = `option.price_gbn || "tmpl_price"` |
| 가격 결과 → order 스토어 커밋 | `mod_05:1941`(`watch(r.value)`) | 결과를 `orderData.priceCalc={params,result}` 병합 → `buildOrderSummary(g1)` → `setOrderData(A, summary)` → `onPriceChange(result_sum)` → `E(A)`(에디터 페이로드 빌드) | 전 제품 |
| 에디터 설정 페이로드 빌드 | `mod_05:1895`(`E`) | orderData+productData→ `payloadForEditorConfig`(`lang_cod,pdt_cod,PDT_NM,sizeInfo,pcsInfo,…,base{item_gbn,koi_template_resource_id,…},seneca_info`) → `exterior.setPayloadForEditorConfig` | clothes는 base에 pdt_mtrl_info/pdt_pcs_info 동봉 |
| 후가공 분류 (캐스케이드 엔진 1) | `mod_06:2618`(`Ql`) | pdt_pcs_info → {postPcs:{visible,hidden}, sub:{visible,essential}, disabled: MTRL_CD키맵}. 분류 기준 §3 | SUB_MTR 계열은 `Gl`(SUB_MTR_GROUP_MAP)로 sub로 라우팅 |
| 후가공 disable/default 적용 (엔진 2) | `mod_06:1450-1564`(VisiblePostPcs) | 현재 MTRL_CD의 disabledOpts(`h.value`)로 옵션 disable; `v()`로 PCS 엔트리 add/remove(default 토글); 화이트인쇄 자동 토글(`u`) | AC* 제품·PRT_WHT 분기 다수(§3) |
| 업로드 모드 상태(editor/pdf) | exterior 스토어 + Uploader(`mod_06:2470-`) | `uploadType[key]` 토글; editor면 `onOpenEditor` 호출, pdf면 S3Uploader | book2025는 inner/default 2키 운용 |
| S3 presigned 업로드 | `mod_06:2052-2124`(S3Uploader) | 검증→`POST /api/aws/presigned-url`→`PUT presignedURL`→`fetchS3FileInfo(FT)`로 ContentLength→emit upload | PDF 전용(allowedExt 기본 application/pdf), 1GB 제한(`lS`) |
| 에디터 결과 처리 | `mod_05:2148`(A1=KOI)/`mod_05:2175`(N1=RP) | KOI: projectID+size/white/calendar/clothes 추출, RP: _id→projectID+ordCnt | item_gbn·pdtCode(GSBGRDY 등 `w1`) 분기 |
| 인스턴스 API (Common) | `deob_06:958`(L1) | getProductBaseInfo/getOrderData/getSummary/setEditorData/canOrder/getKOIEditorTabData | — |
| 인스턴스 API (Acc) | `deob_06:1304`($1) | getProductBaseInfo/getOrderData/getSummary/canOrder (간소화) | ACC 제품 전용 |
| 주문 가능성 검증 | `mod_05:2514`/`deob_06:1155`(canOrder) | order_yn·size validation·priceCalc.retCode/PRICE·업로드(editor 편집완료/pdf 파일존재) 종합 | book/clothes/acrylic 분기(§5) |

---

## 2. 스토어 맵 (Pinia — 5개 확정)

모두 `deob_06` 섹션 22(`717-869`). 전부 setup-store(함수형). `callbacks`는 `inject("callbacks")`로 주입(호스트가 `init(opts, callbacks)`로 전달).

### 2.1 config 스토어 (`deob_06:717`)
- state: `locale: Ref<string>` (기본 "ko")
- actions: `setLocale(newLocale)`
- 참고: `translate(key, params)` 함수가 이 스토어 locale로 TRANSLATIONS_KO/EN 선택(`deob_06:737`).

### 2.2 product 스토어 (`deob_06:754`)
- state: `baseInfo: Ref<object>` (서버 product 응답 전체)
- getters/actions: `getProductBaseInfo()` → `structuredClone(baseInfo)`, `setProductBaseInfo(data)`
- 변이 주체: COMMON 컨테이너 `watch(useQuery.data)`(`mod_05:1960`).

### 2.3 exterior 스토어 (`deob_06:780`) — 업로드/에디터 상태
- state(전부 reactive, 키별: "default"/"inner"):
  - `uploadType: {default:"editor"}`
  - `editorData: {default:null}`
  - `payloadForEditorConfig: {default:null}`
- actions: `setUploadType(type,key)`, `setEditorData(data,key)`, `setPayloadForEditorConfig(data,key)`
- getter: `isAfterEdit(key)` = `uploadType[key]==="editor" && editorData[key]?.editingYn==="Y"`
- side-effect: `watch(editorData, deep)` → dev 로그.

### 2.4 order 스토어 (`deob_06:822`) — Common 주문 선택 상태
- state: `orderData: Ref<object>`
- getters/actions: `getOrderData()`→clone, `setOrderData(data, summary)` → orderData 갱신 **+ `callbacks.onOptionChange({type:"COMMON", data, summary})`** 발화
- ※ summary 인자가 두 번째 — 가격 커밋 시 `buildOrderSummary` 결과 동봉.

### 2.5 acc-order 스토어 (`deob_06:850`) — 부자재 전용
- state: `orderData: Ref<object>`
- actions: `getOrderData()`, `setOrderData(data)` → **`callbacks.onOptionChange({type:"ACC", data})`** (summary 없음)

> orderData 형태(중요 키): `sizeInfo{DIV_SEQ,DIV_NM,cutSize{w,h},workSize{w,h}}`, `meterialInfo{MTRL_CD,MTRL_NM,MTRL_TYPE,PTT_NM,WGT_CD}`, `dosuInfo{COD,COD_NME,PRN_CLR_CNT,BNC_GB}`, `quantityInfo{ordCnt,prnCnt}`, `pcsInfo:[{PCS_CD,PCS_GRP_NM,VIEW_YN,ESN_YN,selectedOptions:[{PCS_DTL_CD,PCS_DTL_NM,ATTB,ATTB_2,ATTB_3}]}]`, `fileUploadInfo`, `priceCalc{params,result}`, `validation`, `clothesSelectData`/`acrylicSelectData`/`calendarInfo`/`inner_*`(book).

---

## 3. 캐스케이드 엔진 심층 (disable/default 변이 로직)

### 3.1 엔진 1 — `Ql` (classifyPostProcessOptions, `mod_06:2618-2661`)
입력: `(pdt_pcs_info, pdt_disable_pcs_info)`. **`pdt_disable_pcs_info`(`t`)를 MTRL_CD 키 맵으로 환원**:
```
disabled = { [MTRL_CD]: { [PCS_CD]: [PCS_DTL_CD...] } }   // reduce, mod_06:2627-2641
```
그리고 pdt_pcs_info 각 항목을 분류(`mod_06:2646-2654`):
- `Gl[PCS_CD]`(SUB_MTR_GROUP_MAP) 존재 && `WEB_PCS_DTL_GRP` 미포함:
  - `ESN_YN==="Y" && VIEW_YN==="N"` → `sub.essential`
  - else → `sub.visible`
- 그 외:
  - `ESN_YN==="Y" && VIEW_YN==="N"` → `postPcs.hidden` (숨김 필수)
  - `ESN_YN==="Y"` → `r.essential`
  - else → `r.optional`
- 최종 `postPcs.visible = [...r.essential, ...r.optional]`
- 반환 `{postPcs:{visible,hidden}, sub:{visible,essential}, disabled}`

호출: Digital `mod_06:2845`, Acrylic `mod_06:3684` — `computed(()=>Ql(data.pdt_pcs_info, data.pdt_disable_pcs_info))`.

### 3.2 엔진 2 — VisiblePostPcs disable 적용 (`mod_06:1450-1586`)
- `disabledOpts` prop = `Ql`의 `disabled` 맵. `h = computed(()=> disabledOpts[현재 MTRL_CD] || {})` (`mod_06:1375` 동형, Visible은 1430대 setup).
- 옵션 버튼 disable 판정(`mod_06:1562`):
  ```
  disabled = u[value] || option.disabled || !!h.value[value]
  ```
  - `h.value[value]` → **현재 선택 자재에서 비활성화된 후가공** (자재→후가공 캐스케이드의 핵심).
  - `u[value]` → 화이트인쇄 자동 토글 reactive(아래).
- default 변이 — `v(b, C, y)`(`mod_06:1452`): PCS 그룹 토글. `C==="Y"`(또는 현재 미선택) → `i[value]=기본 PCS 엔트리 push`, 아니면 `delete i[value]`, 후 `c(b)`로 부모 통지.
- 초기 강제 선택 — `rs()`(`mod_06:1470`): 옵션 순회하며 `ESN_YN==="N"` 또는 disable/이미선택이면 skip, 아니면 `i[PCS_CD]=[기본엔트리]` (필수 후가공 자동 적재).

### 3.3 화이트인쇄 자동 캐스케이드 (AC* 제품, `mod_06:1495-1551`)
- `watch(uploadType.default)`: `pdtCode.startsWith("AC")` && editor && !=="ACTHFCO" → `v("PRT_WHT","Y"); u.PRT_WHT=true` (자동 활성+disable).
- `watch(editorData.default.PRT_WHT)`: 에디터가 반환한 front/back 화이트 정보로 PRT_WHT selectedOptions 재구성(`DFXXF`/`DFXXB`), `ACTHFCO`는 reset 경로(`Hl`=useWhiteReset).
- `O(b)` (`Fl`=WHITE_PRINT_AUTO_MATERIAL_MAP): 자재별 화이트 강제(`GSCATIN`의 `SXTNC010/014`).

### 3.4 방향 자동검출 캐스케이드 (`deob_06:338,371`)
- PageDirection: `autoDetectedDirection`이 있으면 다른 방향 옵션 `disabled` + `disabled-styling`; 에디터 편집 후이면 reset.

### 3.5 사이즈→방향, 자재→후가공 외 데이터 의존
- 사이즈 옵션 default: `option.DFT_YN==="Y" && HIDE_YN!=="Y"` 우선(`mod_06:800`).
- 스티커 STICKER_TYPE 매칭 default(`mod_06:954`).
- 사이즈 disable: `HIDE_YN==="Y"`(`mod_06:998`).

---

## 4. 브릿지 맵 (위젯 ↔ 호스트 ↔ 에디터)

> **구조 핵심**: 위젯 SDK(mod_06/05)에는 `postMessage`/`addEventListener("message")`가 **전혀 없음**. iframe·postMessage는 전부 RedEditorSDK(edsdk). 위젯과 에디터는 **호스트 셸(red-pc/red-mobile)을 경유한 콜백 계약**으로 연결.

### 4.1 위젯 → 호스트 콜백 (inject("callbacks"), 위젯이 호스트에 통지)
| 콜백 | 발화 위치 | 페이로드 | 라이프사이클 훅 |
|------|-----------|----------|------------------|
| `onOptionChange` | order/acc-order `setOrderData` (`deob_06:831,859`) | `{type:"COMMON"\|"ACC", data, summary?}` | 옵션/가격 변경마다 |
| `onPriceChange` | COMMON 컨테이너 `mod_05:1956` | `result_sum`(PRICE/PRICE_VAT/PRICE_MALL/ORG_PRICE…) | 가격 mutation 성공 후 |
| `onMounted` | `mod_05:1963` (`watch isFetchedAfterMount`) | `boolean` | product 최초 로드 완료 |
| `onError` | `mod_05:1963` | errorMessage | product 로드 에러 |
| `onOpenEditor` | Uploader `mod_06:2508-2510` | `{mode:"NEW"\|"EDIT", type:"KOI"\|"RP", config, option}` | "에디터" 버튼 클릭→에디터 열기 요청(호스트가 RedEditorSDK 구동) |
| `onCreatePot` | Uploader `mod_06:2529` | `{pdt_cod, customerOrderData, memberInfo{mb_id,mb_cust_cod}, editorData{editorConfig,editorOption}}` | 장바구니/주문 생성 요청 |
| `onReset` | Uploader 여러 watch(`mod_06:2545,2553,2555`) | `"fileUpload"` 등 | 업로드 모드 전환 시 상태 초기화 |
| `onCallMsg` | `mod_06:2506` | `("warn", message)` | 검증 경고(팬톤 미선택 등) |
| `onInformOptionTips`/`onInformMaterials`/`onInformGuide` | 컴포넌트 `mod_06:3076,3194,3885…` | 안내 텍스트 | 옵션 가이드 표시 |

### 4.2 인스턴스 메서드 (호스트 → 위젯, `init()` 반환 객체)
| 메서드 | 정의 | 역할 |
|--------|------|------|
| `getProductBaseInfo()` | `deob_06:968` | product baseInfo clone |
| `getOrderData()` | `deob_06:973` | 현재 주문 clone |
| `getSummary()` | `deob_06:984` | 사이드바 요약(자재/사이즈/후가공/수량/가격), book/clothes/acrylic 분기 |
| `setEditorData(data)` | `deob_06:1138` | 에디터 결과 수신 → KOI=A1/RP=N1 처리 → exterior.setEditorData |
| `canOrder()` | `deob_06:1155` | 주문 가능 검증 (§5) |
| `getKOIEditorTabData(tabData)` | `deob_06:1224` | KOI 커스텀탭 실시간 가격 재계산(자재변경시) — 자체 fetchPriceCalculation 호출, PRICE 반환 |

### 4.3 호스트 → 에디터 (RedEditorSDK, edsdk) — to-edicus
호스트가 `onOpenEditor` 수신 후 RedEditorSDK 인스턴스를 통해 iframe 구동. `iframe_el.contentWindow.postMessage(JSON.stringify(msg), "*")` (`edsdk:2655,2665,2676,11702`). 주요 메서드(45종, editor_sdk_method_catalog.md): `createProject`/`openProject`/`reformProject`/`cloneProject`, `save`/`saveThenClose`/`close`/`destroy`, `setToken`/`setUserId`/`setPrice`/`setEdicusStageUrl`, `checkOrderable`, `remoteEditor`/`remoteEditorBulk`, `on(event,cb)`, `getSceneInfo`/`getCustomTabSelectInfo` 등. (이 모듈은 형제 에이전트 deob_05/07 범위 밖, 본 맵 참고용.)

### 4.4 에디터 → 호스트 (from-edicus) — 메시지 수신
`edsdk:2562`: `addEventListener("message")` 핸들러가 `e.type` 분기:
- `from-edicus` / `from-edicus-root` / `from-edicus-tnview` → `target_callback(null, e)`
- `from-edicus-private` → 내부 처리
액션 디스패처(`edsdk:11171-11210`, `editorEventHandler`) — `n.action` 분기 (~25종):
| action | 처리 |
|--------|------|
| `save-doc-report` (status="end") | 저장 보고 → `{message,projectId,data}` 콜백(`docReport`) |
| `goto-cart` / `close` | `isReadyToOrder`(checkOrderable) 호출 → `can_order` 판정 → Editor Close 보고 |
| `request-user-token` | `issueUserToken` → `editorToken` 갱신 → `send-user-token` 재전송 |
| `command-completed`/`command-rejected` | remoteEditor Promise resolve/reject |
| `page-changed`/`page-count-changed`/`request-page-size-change` | 페이지 콜백 |
| `selection-changed`/`state-history`/`label-history` | 히스토리/선택 콜백 |
| `scene-info-report`/`imgpool-notify`/`preview-closed`/`font-list` | 씬/리소스 콜백 |
| `dpp-execute-report`/`promo-external-report`/`enter/exit-overlay-mode` | 기타 보고 |
- origin 보안: `postMessage(..., "*")` — **targetOrigin 와일드카드**, message 핸들러도 origin 미검증(`e.type`만 검사). 우리 구현 시 **origin allowlist 보강 필요**(보안 갭).
- 에디터 base URL: `https://edicusbase.firebaseapp.com`(운영)/`edicus-stage.firebaseapp.com`(개발).

### 4.5 NEW vs EDIT 분기 (Uploader `v()` `mod_06:2470-2502`)
- `isAfterEdit(key)` true → `{mode:"EDIT", config:{projectId}(KOI) | {initType:"open",project_id}(RP)}`
- false → `POST /api/editor/config/{KOI|RP}` (body `{token, payload: payloadForEditorConfig[key]}`) → `{mode:"NEW", type, ...config}`

---

## 5. canOrder 검증 분기 (주문 가능성 상태머신, `deob_06:1155-1215`)
순차 throw(첫 실패 = 주문불가):
1. `order_yn==="N"` → "주문불가상태"
2. `validation.length>0`(사이즈) → "주문불가-사이즈"
3. `priceCalc.result.retCode!==200 || !result_sum.PRICE` → "주문불가-가격"
4. **book2025_item**: inner/default 각 키별 editor면 `isAfterEdit(key)`, pdf면 fileUploadInfo[0]/[1] 존재 + 파일명 중복검사 → success
5. **pdf 모드**: fileUploadInfo[0] 필수; clothes+PTP_SLK는 pantoneInfo 필수
6. **clothes 인쇄없음**(`printType.COD` 없음) → success
7. **editor 모드**: `!isAfterEdit()` && `dosuInfo.COD!=="SID_X"` → "주문불가-에디터"
- Acc canOrder(`deob_06:1359`): order_yn / subMtrlInfo / result_sum.PRICE 3단만.

---

## 6. 제품-분기 열거 (Product-branch enumeration)
| 분기축 | 위치 | 제품 조건 |
|--------|------|-----------|
| Common vs Acc 클래스 | `mod_06:22,35` | `M1=ACC_PRODUCT_CODES{GSSBMTL,GSSBSTP,GSSBACM}` → Acc 앱/$1, 그 외 Common/L1 |
| item_gbn 컴포넌트 매핑 | `mod_05:1821-1835` | vDigital_item/acrylic2025_item/clothes2025_item/book2025_item (미정의=Digital) |
| 가격 ORD_INFO 스키마 | `mod_05:1859-1885` | book2025_item(CVR_/INN_ 분리, PAGE_CNT) vs 일반(MTRL_CD, ORD_CNT); clothes(PRINT_TYPE) |
| 수량 UI 타입 | `deob_06:883`(QUANTITY_UI_TYPE_MAP) | GSPNJLY→TotalQty, GSPNBAL/GSPNDFT→SetQty, STDRCAD/STTBDFT/TPCAPTW→SimpleQty, 기본 DesignQty |
| 단일수량(prnCnt만) | `deob_06:896` | GSPNJLY/GSPNBAL/GSPNDFT |
| 에디터후 자재 리셋 | `deob_06:893`(RESET_MATERIAL_AFTER_EDIT_CODES, 25종) | GSPN*/GSCA*/GSKY* 등 |
| 달력/윤전달력 | `deob_06:903,906` | CALENDAR_PRODUCT_CODES(8) / OFFSET_CALENDAR_CODES(3) |
| 직접자재(DIR_MTR) | `deob_06:909` | GSBKLAP/GSBKBCH/GSTTDTM/GSFBPHP/GSFBSTK |
| 자재연결 후가공 | `deob_06:915`(MATERIAL_PCS_CODE_MAP) | 제품별 SUB_MTR/DIR_MTR/WRK_MTR |
| 화이트인쇄 자동자재 | `deob_06:927`(WHITE_PRINT_AUTO_MATERIAL_MAP) | GSCATIN |
| AC* 화이트 캐스케이드 | `mod_06:1496,1506` | pdtCode.startsWith("AC"), ACTHFCO/ACTHDKY 예외 |
| 의류 타입 그룹 | `mod_06:2166`(CLOTHES_TYPE_GROUPS) | type1/2/3 셋 |
| 에디터 결과 처리 분기 | `mod_05:2154,2159` | book2025=size skip, GSBGRDY(`w1`)=projectID만 |

---

## 7. 캡처가 놓친 구조 서프라이즈 (S0 결론)
1. **위젯↔에디터 디커플**: 위젯은 RedEditorSDK를 직접 호출하지 않는다. `onOpenEditor(editorConfig)`를 호스트에 emit → 호스트가 iframe/postMessage 담당 → 결과를 `instance.setEditorData()`로 위젯에 역주입. (4-product 런타임 캡처는 이 콜백 경계를 못 봄.)
2. **이중 debounce 200ms**: 옵션→가격은 useOrderState 150ms + 컨테이너 200ms 2단. 단일 "300ms" 모델은 틀림.
3. **disable는 자재-스코프**: `pdt_disable_pcs_info`는 전역이 아니라 **현재 MTRL_CD 키로 룩업**되어 그 자재에서만 후가공 disable. 자재 바꾸면 disable 셋이 통째로 교체됨.
4. **ACC는 앱 자체가 분기**: `init()`에서 `M1.has(pdtCode)`로 Common/Acc 앱·인스턴스가 갈리고, order vs acc-order 스토어가 달라짐(`onOptionChange` type도 COMMON/ACC).
5. **origin 와일드카드**: 에디터 postMessage가 `"*"` + 수신측 origin 미검증 → 우리 구현 보안 보강 대상.
6. **summary는 가격 커밋 시에만 생성**: `setOrderData(data, summary)`의 summary는 `buildOrderSummary(g1)` 결과로, 가격 result watch에서만 채워짐(옵션만 바뀌고 가격 미응답이면 summary 없음).

---

## 8. "우리 구현과 대응시킬 축" (S1 훅)

| Red 책임 | 우리 React 구현이 재현해야 할 것 |
|----------|-------------------------------------|
| 5 Pinia 스토어 | **5 Zustand 슬라이스**: config(locale), product(baseInfo+clone getter), exterior(uploadType/editorData/payloadForEditorConfig + isAfterEdit), order(orderData + setOrderData가 onOptionChange COMMON 발화), accOrder(setOrderData가 onOptionChange ACC). 4개로 합치지 말 것 — config 별도 유지. |
| `init()` 라이프사이클 | Custom Element + `attachShadow({mode:"open"})` → React `createRoot(shadowRoot)`. clientKey 검증, M1(ACC)로 마운트 컴포넌트/인스턴스 클래스 분기. `provide` 6키 = React Context(deviceType/productCode/callbacks/member/editorData). |
| 이중 debounce | `cascade.ts`/state: 옵션 집계 150ms debounce → 가격 파라미터 watch 200ms debounce. 단일 debounce로 합치면 타이밍 불일치. |
| 가격 파라미터 빌드 `m()` | `buildPriceParams(orderData, item_gbn)` — book/clothes 분기 스키마 그대로(ORD_INFO/PCS_INFO/price_gbn/mb_cust_cod). |
| 가격 결과 커밋 | result watch → orderData.priceCalc 병합 → buildOrderSummary → setOrderData(data, summary) + onPriceChange + 에디터 페이로드 빌드. 순서 보존. |
| `Ql` 캐스케이드 엔진 | `cascade.ts`: `classifyPostProcess(pdtPcsInfo, disablePcsInfo)` → {postPcs{visible,hidden}, sub{visible,essential}, disabled(MTRL_CD키맵)}. SUB_MTR_GROUP_MAP 라우팅 포함. |
| disable 적용 | 옵션 disable = `autoToggle[v] || opt.disabled || !!disabledMap[현재MTRL_CD][v]`. 자재 변경 시 disabledMap 재룩업. 필수후가공 초기 자동선택(rs 로직). |
| 에디터 브릿지 | `editor-bridge.ts`: 위젯은 RedEditorSDK 미호출. `onOpenEditor` emit(NEW=`/api/editor/config/{KOI\|RP}`, EDIT=projectId) + `setEditorData`(A1 KOI/N1 RP 프로세서) 수신. **호스트 콜백 계약 유지** — postMessage는 별도 에디터 SDK 어댑터 책임. |
| from-edicus 수신 | 에디터 어댑터가 message 핸들러로 save-doc-report/goto-cart/request-user-token 등 ~25 action 분기. **origin allowlist 추가**(Red 와일드카드 보강). |
| S3 업로드 | `POST /api/aws/presigned-url`→`PUT`→`fetchS3FileInfo`→ `{gbn:"I",new_file_nm,new_file_size,org_file_nm,s3_file_size}`. 1GB·PDF 검증. |
| canOrder | book/clothes/acrylic/pdf/editor 분기 순서대로 검증, 첫 실패 메시지 반환. |
