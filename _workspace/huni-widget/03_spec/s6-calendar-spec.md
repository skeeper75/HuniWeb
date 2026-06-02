# s6-calendar-spec.md — S6 캘린더 명세 (PriceTable3D 변형 판정 + 어댑터 명세)

> 파이프라인 ③. S6(캘린더, 카테고리 09) 구현 명세. S0~S5 비교 QA GO 위에서 출발.
> [HARD] 핵심 판정 = **옵셋 캘린더(HLCLSTD·HLCLWAL) = 책자 PriceTable3D 변형, 신규 componentType 0, 위젯 코어 0변경**. S4(NC-2)·S5(NC-3)에 이은 세 번째 "신규 불요" 실증.
> [HARD] 추측 금지 — fixture·라이브 캡처·계약 문서 실제 근거만. 미캡처는 "후속 라이브 확인 필요"로 명시.
> 근거 표기: [HL]=s6_cal_HLCLSTD.json / [TW]=s6_cal_TPCLWLB.json / [NOTE]=s6-calendar-live-note.md / [DC]=src/contract / [DA]=data-adapter.md / [S5]=s5-goods-pouch-spec.md / [SRC]=04_build/src.
> [S4/S5] 명세의 절제된 톤 유지 — 과설계 금지.

---

## 0. 한 줄 결론

**옵셋 캘린더(HLCLSTD·HLCLWAL)는 책자 PriceTable3D 변형이 라이브로 확정됐다.** `ORD_INFO[0]` 필드가 책자/포스터와 **완전 동일**(추가 필드 0). 캘린더 전용 옵션(달력규격 CLD_STD / 시작연월 STA_CLD / 포장 PAK_POL)은 전부 **기존 PCS_INFO 경로**로 흡수돼 기존 `finish-button`/hidden-essential 처리로 렌더되므로 **신규 componentType 불요, dispatcher·계약 0 변경**. `price_gbn=offset2023_price`는 어댑터 불투명 echo(INV-1)이므로 신규 문자열이어도 위젯 코어 무관. **본 S6의 코어 변경은 0줄** — 어댑터에 fixture 2종 적재 + price fixture 라우팅 분기 1개만 추가한다. TPCLWLB(효도달력)는 `vTmpl_price`로 S5 파우치 tmpl 계열과 동형(별도 신규 없음). GSCLMGN(자석=goods tiered)·TPCLECO(Red 상품 미설정)는 S6 PriceTable3D 임계경로 아님 — §6 미해결로 명시.

---

## 1. 가격모델 판정 — 옵셋 캘린더 = PriceTable3D 변형

### 1.1 ORD_INFO 필드 정합 (책자/포스터 계약 대조)

라이브 가격호출 중 **PRICE>0가 나온 완전 호출**([HL] priceCalls rel 2217: PRICE 1,192,700 / rel 7440: PRICE **778,500**)의 `ORD_INFO[0]`:

```
{ PDT_CD:"HLCLSTD", MTRL_CD:"RXRAU240", CUT_WDT:90, CUT_HGH:180,
  WRK_WDT:94, WRK_HGH:184, PRN_CNT:500, ORD_CNT:1,
  DOSU_COD:"SID_D", PRN_CLR_CNT:8 }
```

필드별 대조 — 어댑터 직렬화 타입 [SRC red-types.ts:149 `RedPriceReqOrdInfo`]과 1:1:

| ORD_INFO 필드 | 계약/직렬화 슬롯 | 책자/포스터와 동일? | 근거 |
|---------------|------------------|---------------------|------|
| PDT_CD | `RedPriceReqOrdInfo.PDT_CD` ← `req.productCode` | 동일 | [SRC red-adapter.ts:353] |
| MTRL_CD | `.MTRL_CD` ← `req.materials.default` | 동일 | [SRC :361] |
| CUT_WDT/CUT_HGH | `.CUT_WDT/.CUT_HGH` ← `dimensions[0].cutW/cutH` | 동일 | [SRC :354-355] |
| WRK_WDT/WRK_HGH | `.WRK_WDT/.WRK_HGH` ← `dimensions[0].workW/workH` | 동일 | [SRC :356-357] |
| ORD_CNT | `.ORD_CNT` ← `req.quantity` | 동일(S5에서 확립) | [SRC :358] |
| PRN_CNT | `.PRN_CNT` ← `req.printCount ?? 1` | 동일(S5에서 확립) | [SRC :359] |
| PRN_CLR_CNT | `.PRN_CLR_CNT` ← `req.colorCounts.default` | 동일 | [SRC :360] |
| DOSU_COD | `.DOSU_COD?` (optional, **현재 직렬화 미출력**) | §1.3 검증 | [SRC red-types.ts:159] |

→ **신규 ORD_INFO 필드 0개.** 옵셋 캘린더의 가격 요청 shape는 책자/포스터와 구조적으로 동일하며, 결과 응답(`result[]`+`result_sum.PRICE`)도 책자와 동일 envelope([HL] respBody)이므로 `mapPriceResponse`([SRC :391])가 그대로 평면화한다.

### 1.2 계약(`src/contract/`) 변경 = **0건**

| 계약 파일 | 변경 | 근거 |
|-----------|------|------|
| `contract/price.ts` `NormalizedPriceRequest` | **변경 0** — S5에서 추가된 `printCount?`만으로 충분. 캘린더는 ORD_CNT+PRN_CNT 둘 다 사용하나 슬롯 기존 보유 | [DC price.ts:25-29] |
| `contract/price.ts` `PriceDimension`/`PriceLine`/`NormalizedPriceBreakdown` | **변경 0** — cutW/H·workW/H·finalPrice·lines 기존 슬롯으로 충분 | [DC price.ts:5-47] |
| `contract/constraints.ts` `SizeRule` | **변경 0** — 규격별 치수 자동주입 기존 슬롯 | [HL pdt_size_info 4종] |

> [판정] **옵셋 캘린더 PriceTable3D 변형 = 계약 무변경.** S5가 `printCount?` 한 필드를 추가한 것과 달리, S6은 계약 0변경. PRN_CNT/ORD_CNT 분리 인프라가 S5에서 이미 깔려 있어 캘린더가 무비용으로 올라탄다.

### 1.3 DOSU_COD 직렬화 — 검증된 비차단(non-gap)

라이브 ORD_INFO는 `DOSU_COD:"SID_D"`를 포함하나, 현 `serializeRedPriceRequest`는 **DOSU_COD를 출력하지 않는다**([SRC red-adapter.ts:351-362 — ord 객체에 DOSU_COD 키 없음). 그럼에도:

- **PRN_CLR_CNT가 도수의 가격 의미를 이미 운반한다.** [HL] `pdt_dosu_info`의 `PRN_CLR_CNT:8`(양면)이 dosu→bnc 평면화 경로([SRC red-adapter.ts:225 `priceColorCount: d.PRN_CLR_CNT`])로 `colorCounts.default`에 들어가 `ORD_INFO.PRN_CLR_CNT`로 직렬화된다. 옵셋 가격엔진은 PRN_CLR_CNT(=8)로 도수 단가를 산정한다([HL] PRT_DFT 라인 PRICE 578,900 — 색수 기반).
- **기존 책자/포스터/디지털 fixture가 동일 serializer로 PRICE>0를 재현**한다(DOSU_COD 없이도 [SRC red-adapter.test/poster.test green]). 즉 DOSU_COD는 이 가격엔진 계열에서 **필수 아님** — PRN_CLR_CNT로 충분.

> [결정] **DOSU_COD 추가 직렬화 불요(과설계 금지).** 단 §6-OPEN-1에 "옵셋 실가 round-trip 시 DOSU_COD 부재로 단가 차이가 나면 어댑터에 1줄(`DOSU_COD: req.dosuCode`)만 추가" 안전판을 둔다 — 이 역시 어댑터 변경이며 위젯 코어 무관. 현 근거(PRN_CLR_CNT 운반 + 기존 fixture green)로는 **추가 불필요**가 확정.

---

## 2. 신규 componentType 판정 — NC 패턴 연속(신규 0)

### 2.1 캘린더 전용 옵션은 전부 PCS_INFO 행

| 옵션 | Red 출처 | 위젯 렌더 경로 | componentType | 근거 |
|------|----------|----------------|---------------|------|
| **CLD_STD**(달력규격, 삼각대 색×사이즈 12종) | `pdt_pcs_info` PCS_CD=CLD_STD, VIEW_YN=Y | `mapPcsGroups`([SRC :106]) → 그룹 `PCS_CLD_STD` | **finish-button**(colorHex 부재 → RULE-2) | [HL pdt_pcs_info BK001~IV004] |
| **STA_CLD**(시작연월/효도달력 쫄대) | `pdt_pcs_info` PCS_CD=STA_CLD, VIEW_YN=N | `mapPcsGroups` → `visible:false`(hidden essential, 자동적용) | finish-button(미렌더) | [TW pdt_pcs_info STA_CLD] |
| **PAK_POL**(폴리백 개별포장) | `pdt_pcs_info` PCS_CD=PAK_POL, VIEW_YN=N | `mapPcsGroups` → `visible:false`(자동적용) | finish-button(미렌더) | [TW pdt_pcs_info PAK_POL] |
| **CUT_DFT/RIN_DFT**(재단/링제본) | `pdt_pcs_info` 기존 후가공 | 기존 PCS 경로 | finish-button | [HL pdt_pcs_info] |

→ **캘린더 전용 옵션 100%가 `pdt_pcs_info` 행**이다. `mapPcsGroups`가 `PCS_CD`별로 묶고 `VIEW_YN`으로 `visible`을 결정하는 기존 로직([SRC red-adapter.ts:106-133])이 추가 코드 없이 흡수한다. **신규 leaf 컴포넌트·dispatcher case 0.**

### 2.2 "시작 년도/월" 셀렉트의 정확한 해석 (은폐 금지)

[TW] Red Shadow DOM에는 `starting-year`(2026~2028)·`starting-month`(1~12월) **select 2개**가 노출된다. 그러나 이는 **Red 위젯의 표현 UI일 뿐**이고, 가격 요청([TW] priceCalls reqBody)에는 연/월 값이 **들어가지 않는다** — PCS_INFO에 `STA_CLD/DFXXX`(쫄대) 행만 echo된다. 즉:

- 연/월 선택은 **에디터/주문메타(달력 시작월)**용 입력이지 **가격 차원 아님**([TW] PRICE_LOG "개당단가:11900, 인쇄수량:1, 주문건수:1" — 연월 무관).
- 우리 위젯에서 연/월은 **주문 메타 입력**으로, 기존 `select-box` componentType(폐쇄 enum)으로 렌더 가능. **이 역시 신규 타입 아님** — 14타입 중 `select-box` 재사용. 단 현 어댑터는 PCS_INFO만 OptionGroup화하므로, 연/월을 그룹으로 노출하려면 어댑터가 STA_CLD PCS 행으로부터/또는 별도 메타 그룹을 만들어야 한다 → **§6-OPEN-2(주문메타 연월 노출)**로 분리. **PriceTable3D 임계경로 아님**(가격 무관). 본 S6 가격검증 GO에는 불필요.

> [판정] **신규 componentType 불요(NC 패턴 S4·S5·S6 3연속).** 14타입 switch dispatcher 무변경, `ComponentType` union 무변경. 진짜 갭은 없다 — 캘린더 전용은 PCS(finish-button) + 메타(select-box) 기존 타입으로 전부 흡수.

---

## 3. 어댑터 명세 (정확히 무엇을 추가하는가)

### 3.1 fixture 적재 (HLCLSTD/HLCLWAL product + offset price)

`fixture-source.ts`에 다음을 추가([SRC fixture-source.ts:18-41 import 블록, :43-60 PRODUCTS 맵 패턴 그대로]):

| 추가물 | 내용 | 출처 |
|--------|------|------|
| `fixtures/product_HLCLSTD.json` | [HL] `infoCalls[0].respBody` 통째(product_option+product_data) | [HL] |
| `fixtures/product_HLCLWAL.json` | 벽걸이 캘린더 product 응답(라이브 캡처 RAW 미러에서 추출). 미보유 시 §6-OPEN-3 | [NOTE §2] |
| `fixtures/price_HLCLSTD_sample.json` | [HL] priceCalls **rel 7440**(PRICE 778,500, 완전 호출) respBody | [HL] |
| PRODUCTS 맵 | `HLCLSTD: productHLCLSTD, HLCLWAL: productHLCLWAL` | [SRC :43-60] |

### 3.2 price fixture 라우팅 (fetchPrice 분기 1개)

`FixtureRedDataSource.fetchPrice`([SRC fixture-source.ts:73-102])에 옵셋 캘린더 분기 추가 — S5 GSPU 분기([SRC :91-93])와 동형:

```
// S6 옵셋 캘린더(HLCL) — offset2023_price PriceTable3D 변형. 책자와 동일 envelope.
// 위젯은 price_gbn 무관·불투명 finalPrice 만(INV-1). 로그인 실가 PRICE>0 캡처.
if (req.productCode.startsWith('HLCL')) {
  return priceCalendarOffset as RedPriceResponse;
}
```

> [HARD] 위치는 GSPU 분기 인접. `startsWith('HLCL')`로 탁상/벽걸이 공통 라우팅. TPCLWLB(효도달력)는 `vTmpl_price`이므로 **기존 디지털/tmpl 경로로 흡수**되거나 별도 fixture 불필요 — S6 PriceTable3D 임계경로가 아니므로 fixture 미적재 허용(§6-OPEN-4).

### 3.3 product 매핑 — `mapProduct`/`mapOptionGroups` 무변경 검증

[HL] product_data가 기존 `mapProduct`([SRC :51])를 그대로 통과하는지 필드 확인:

- `inner_pdt_mtrl_info` **부재** → `hasInner=false` → 단일 면(`{key:'default', uploadType: usePDF==='Y'?'pdf':'editor'}`). [HL] `usePDF:"Y"` → pdf 업로드. ✔ 기존 분기([SRC :64]).
- `pdt_size_info` 4종(small/세로형/wide/large, DFT_YN small=Y) → `GRP_SIZE` option-button. `real_price`+0×0 sentinel 아님 → **NC-1 dimension-matrix 미발동**([SRC :164]) ✔.
- `pdt_mtrl_info` 2종(랑데뷰/스노우) → `GRP_MTRL_COVER` select-box ✔.
- `pdt_dosu_info` 1종(양면, PRN_CLR_CNT 8) → `GRP_DOSU_COVER` option-button + priceColorCount 평면화 ✔.
- `pdt_pcs_info`(CUT_DFT/RIN_DFT/CLD_STD×12) → `mapPcsGroups` → `PCS_CLD_STD` 등 finish-button. CLD_STD VIEW_YN=Y → visible, CUT_DFT VIEW_YN=N → hidden ✔.
- `pdt_prn_cnt_info` DFT_PRN_CNT=500, FIR/INC/MIN_PRN_CNT **모두 null** → `buildQuantityRule`([SRC :137])이 `min:null, first:null` 반환.

> [주의 — O1] [HL] `pdt_prn_cnt_info`는 FIR_CNT/INC_CNT/MIN_PRN_CNT가 전부 null이고 `PRN_CNT`가 고정 래더(100~1000)다(책자 FIR/INC 모델과 다름). 현 `buildQuantityRule`은 이 래더를 `counter-input` min/step으로 매핑하지 못한다(값이 null). 즉 옵셋 캘린더의 **PRN_CNT(인쇄수량)는 폐쇄 래더 select**([HL] selects "PRN_CNT" 100~1000)이지 자유 counter가 아니다. **이것이 S6의 유일한 실(實) 어댑터 분기 후보**다. 처리:
> - **선택지 A(권장, 코어 0):** 래더를 `pdt_prn_cnt_info[].PRN_CNT` 값들로 `option-button`/`select-box` enum 그룹화. 어댑터 `mapOptionGroups`에 "prn_cnt 래더가 있고 FIR/INC가 null이면 PRN_CNT enum 그룹 생성" 분기 추가(어댑터 한정, 위젯 코어 무관). componentType는 기존 select-box → **신규 타입 0**.
> - **선택지 B(기각):** counter-input 유지 + min/max 추정 → 폐쇄 래더(100단위)를 자유입력으로 왜곡, 임의값 PRICE=0 위험. 기각.
> → **결정: A.** 단 이는 **어댑터 변경**이며 dispatcher/store 무관. 상세는 §4 표 #5.

### 3.4 가드 — ORD_CNT≥1 && PRN_CNT≥1 (이미 캘린더 커버)

[HL] priceCalls **rel 2027**(첫 호출)은 ORD_INFO에서 **PRN_CNT/ORD_CNT 둘 다 누락** → `result_sum.PRICE:0`(침묵 0). rel 2217/7440은 둘 다 포함 → PRICE>0. **S5에서 발견한 침묵 PRICE=0 결함이 옵셋 캘린더에서도 동일 재현**된다.

→ 기존 `isPriceRequestQuotable`([SRC red-adapter.ts:377-379]) 가드(`quantity≥1 && (printCount??1)≥1`)가 **캘린더를 추가 변경 없이 커버**한다. 캘린더는 ORD_CNT(=req.quantity)·PRN_CNT(=req.printCount) 둘 다 전달하므로 가드 통과 시 PRICE>0, 누락 시 `{ok:false}` 명시 반환(침묵 0 아님). **가드 코드 0줄 추가.**

> [확인] `serializeRedPriceRequest`의 ORD_CNT/PRN_CNT 직렬화([SRC :358-359])는 S5에서 이미 분리 완료 — 캘린더가 그대로 재사용. 단 §3.3-O1대로 PRN_CNT가 enum select이면 위젯이 선택값을 `printCount`로 echo해야 PRICE>0(미echo 시 default 1 → 가드는 통과하나 단가가 PRN_CNT=1 기준이 됨). **이것이 캘린더에서 printCount UI 노출이 필요한 첫 사례** → §4 표 #3 store echo 검토.

### 3.5 S5 tmpl/tiered 직렬화 재사용

TPCLWLB(vTmpl_price)는 [TW] reqBody가 `ORD_CNT:13, PRN_CNT:1`(둘 다 포함, S5 tmpl과 동일 요구)이고 응답이 `WSP_ACPT_ORDER_TMPL_PCS_PRICE`(S5 파우치와 동일 SP 계열). → **S5 tmpl 직렬화 경로 그대로 적용**, 신규 0. 효도달력은 가격모델상 S5의 사본이다.

---

## 4. 위젯 코어 0변경 증명 계획 (hw-builder 검증 항목)

[INV-3] store/cascade/shadow/dispatcher/price-seam/editor-bridge **변경 0줄** 목표. `git diff src/widget/**` = **0 lines**가 GO 조건(S4/S5와 동일).

### 4.1 변경 영향 범위 표 (s5 §4.1 형식)

| # | 파일 | 변경 | 줄수(+/−) | 근거 |
|---|------|------|-----------|------|
| 1 | `src/contract/**` | **변경 0** — printCount? 기존 보유, 신규 필드 없음 | 0 / 0 | §1.2 |
| 2 | `src/widget/components/controls/OptionControl.tsx` (dispatcher) | **변경 0** — 신규 case 없음 | 0 / 0 | §2 판정 |
| 3 | `src/widget/stores/**` (cascade/selectOption/buildPriceRequest) | **변경 0 목표.** PRN_CNT enum select는 기존 select-box 선택 경로 + printCount echo가 필요할 수 있음 → §3.4-O1. echo 필요 시 buildPriceRequest +1줄(새 분기 아님, quantity와 동형). 코어 0 우선 검증 | 0 (또는 +1) | §3.3-O1, §3.4 |
| 4 | `src/widget/**` (shadow/editor-bridge/price-seam) | **변경 0** | 0 / 0 | INV-3 |
| 5 | `src/adapters/red/red-adapter.ts` `mapOptionGroups` | PRN_CNT 폐쇄 래더 → enum 그룹화 분기(FIR/INC null && pdt_prn_cnt_info 래더 조건). **어댑터 한정** | 어댑터 +~8 | §3.3-A |
| 6 | `src/adapters/red/component-type-map.ts` | **변경 0** — PRN_CNT enum = 기존 select-box/option-button | 0 / 0 | §2 |
| 7 | `src/adapters/red/fixture-source.ts` | HLCLSTD/HLCLWAL product + offset price import·라우팅 분기 1개 | 어댑터 +~5 | §3.1-3.2 |
| 8 | `fixtures/product_HLCLSTD.json` / `product_HLCLWAL.json` / `price_HLCLSTD_sample.json` | **신규** — [HL] 캡처에서 추출 | 신규 fixture | §3.1 |
| 9 | `test/red-adapter-calendar.test.ts` | **신규** — HLCLSTD 어댑터 출력 + 가격 round-trip 검증 | 신규(+~70) | §4.2 |

> **위젯 코어 0변경 증명:** dispatcher case 0, cascade 0, shadow 0, editor-bridge 0, price-seam 0. 모든 추가는 **어댑터(BFF) + fixture + test**에 격리. PRN_CNT enum select가 printCount echo를 요구하면 buildPriceRequest 1줄(quantity echo와 동형 — 새 store 분기 아님)이 유일한 코어 접점 후보이며, 이마저도 **코어 0 우선 구현 시도** 후 PRICE>0 미달 시에만 추가. **목표 = S5와 동급(코어 완전 0줄).**

### 4.2 hw-builder 검증 체크리스트

1. **HLCLSTD 어댑터 출력**: 사이즈 4종=option-button(small DFT_YN=Y 기본), 자재 2종=select-box, 도수 1종(양면, priceColorCount 8), `PCS_CLD_STD` 12종=finish-button(visible:true, VIEW_YN=Y), CUT_DFT/RIN_DFT 후가공, PRN_CNT 래더=select-box enum(§3.3-A), `price_gbn="offset2023_price"` echo. [HL]
2. **가격 round-trip**: `price_HLCLSTD_sample.json`(rel 7440) → `mapPriceResponse` → `finalPrice:778500, vat:77850, lines[CLD_STD/CUT_DFT/PRT_DFT/RIN_DFT]`. [HL result_sum]
3. **PRN_CNT echo**: printCount=500(또는 선택값) 전달 시 ORD_INFO.PRN_CNT=500. 미전달 시 가드 통과하나 단가 기준 PRN_CNT=1 → 캘린더는 printCount echo 필요 확인(§3.4-O1).
4. **가드 동작**: quantity=0 또는 printCount=0 → `{ok:false, finalPrice:0}` 명시 반환(침묵 0 아님, [HL rel 2027] 결함 재현 금지). 기존 가드로 커버.
5. **계약 중립**: 신규 계약 필드 0. CLD_STD/STA_CLD/offset2023_price 등 Red 고유명이 `src/widget/**`·`src/contract/**`에 0건(grep 게이트). [INV-2]
6. **회귀(INV-3)**: PRBKYPR(S0)·디지털(S1)·스티커(S2)·BNBNFBL/BNPTPET(S3 NC-1)·ACNTHAP(S4)·GSTGMIC/GSPUFBC(S5) fixture 여전히 동일 출력. tsc/vitest green. **`git diff src/widget/**` 0줄.**
7. **NC-1 미오염**: 옵셋 캘린더(offset2023_price)가 NC-1 dimension-matrix-input 미생성(real_price+0×0 sentinel 아님). [SRC :164]

---

## 5. 빌드 게이트 영향

| 항목 | 영향 | 근거 |
|------|------|------|
| **신규 fixture import** | `product_HLCLSTD.json`/`product_HLCLWAL.json`/`price_HLCLSTD_sample.json` 3종 import(resolveJsonModule). HLCLWAL product 미보유 시 2종 | §3.1 |
| **vitest delta** | `red-adapter-calendar.test.ts` 신규(+~70줄, 책자/poster 테스트 형식). 기대 = 기존 테스트 전부 green 유지 + 신규 캘린더 테스트 green. 회귀 0 | §4.2-6 |
| **bundle impact** | 위젯 런타임 번들 영향 **0** — 추가물은 전부 BFF/어댑터·fixture(테스트·서버측). [DA §1] 어댑터는 BFF 레이어이며 위젯 청크에 미포함. tree-shake 경계 불변 | §3 |
| **tsc** | 신규 타입 0(RedPriceReqOrdInfo·NormalizedPriceRequest 기존). PRN_CNT enum 그룹화는 기존 OptionGroup 타입 사용 | §1.2 |

---

## 6. hw-builder 인계 체크리스트 + 미해결(OPEN)

### 6.1 hw-builder 인계 체크리스트

- [ ] `fixtures/product_HLCLSTD.json` 작성([HL infoCalls[0].respBody] 통째)
- [ ] `fixtures/product_HLCLWAL.json` 작성(RAW 미러에서 추출, 미보유 시 OPEN-3 처리)
- [ ] `fixtures/price_HLCLSTD_sample.json` 작성([HL priceCalls rel 7440] PRICE 778,500)
- [ ] `fixture-source.ts`에 import + PRODUCTS 맵 + `startsWith('HLCL')` price 분기 추가
- [ ] `red-adapter.ts mapOptionGroups`에 PRN_CNT 폐쇄 래더 enum 그룹화(FIR/INC null 조건, §3.3-A) — **어댑터 한정**
- [ ] `test/red-adapter-calendar.test.ts` 작성(어댑터 출력 + 가격 round-trip)
- [ ] **`git diff src/widget/**` = 0줄 실증**(INV-3, GO 게이트). printCount echo 1줄 발생 시 그 1줄만 정당화
- [ ] grep 게이트: CLD_STD/STA_CLD/offset2023_price 가 widget/contract에 0건(INV-2)
- [ ] tsc/vitest green + 기존 S0~S5 fixture 회귀 0

### 6.2 미해결(OPEN)

| # | 항목 | 영향 | 대응 |
|---|------|------|------|
| **OPEN-1** | **DOSU_COD 직렬화 부재** | 옵셋 실가 정합 | 현 근거(PRN_CLR_CNT 운반+기존 fixture green)로 **추가 불요 확정**(§1.3). 단 후니/옵셋 실가 round-trip에서 단가 차이 시 어댑터 `DOSU_COD` 1줄 추가 안전판(위젯 무관) |
| **OPEN-2** | **시작연월(STA_CLD) 주문메타 노출** | 효도달력 주문 완전성 | 연/월 select는 가격 무관(§2.2) → 주문메타 입력으로 select-box 노출 필요 시 어댑터가 STA_CLD/메타 그룹 생성. PriceTable3D 가격검증 임계경로 **아님**. 별도 후속 |
| **OPEN-3** | **HLCLWAL product fixture 미추출** | 벽걸이 어댑터 테스트 | [NOTE §2] HLCLWAL PRICE 2,368,500 라이브 확인됨. product 응답을 RAW 미러에서 추출. 미보유 시 HLCLSTD 단독으로 PriceTable3D 변형 실증 충분(동일 price_gbn) |
| **OPEN-4** | **TPCLWLB(효도달력) fixture 미적재** | tmpl 캘린더 검증 | vTmpl_price = S5 파우치 사본(§3.5). S6 PriceTable3D 임계경로 아님. 필요 시 [TW] 기반 product+price fixture 추가(S5 tmpl 경로 재사용, 어댑터 신규 0) |
| **OPEN-5** | **GSCLMGN(자석=goods tiered)** | 굿즈 tiered 대표성 | [NOTE §5] 고정규격+디자인수 수량래더 tiered. S5에서 모델 확립. PRICE=0(스윕 미선택). 필요 시 수량래더 선택 재캡처. S6 임계경로 아님 |
| **OPEN-6** | **TPCLECO(에코 캘린더) Red 미설정** | — | [NOTE §5] Red 상품 마스터 "달력 사이즈 설정" 공백 → 주문위젯 생성 실패. **우리 측 결함 아님.** 미검증으로 명시, S6 무관 |
| **OPEN-7** | **로그인 실가 후니 비교** | finalPrice 정합 | 본 캡처는 Red baseline(쿠키 세션 실가). 후니 어댑터 단계에서 후니 PriceTable3D 실가와 대조(정규화 스키마 일치로 게이트 전환). 위젯 무관(INV-1) |

---

## 7. 불변식 경계 증명 요약 (s5 §6 수준)

| INV | 본 S6에서의 준수 | 증명 |
|-----|------------------|------|
| INV-1 서버권위 | 위젯 가격 산술 0. offset2023_price PriceTable3D 단가 전부 BFF. 위젯은 quantity/printCount/dimensions/PRN_CLR_CNT echo만 | §1, [HL] PRICE_LOG=BFF 산정 |
| INV-2 계약 중립 | 신규 계약 필드 0. CLD_STD/STA_CLD/offset2023_price 위젯·계약 0건(grep 게이트) | §1.2, §6.1 grep |
| INV-3 코어 불변 | dispatcher/cascade/shadow/editor-bridge/price-seam 0줄. 추가는 전부 어댑터+fixture+test | §4.1 표 |
| INV-4 Shadow 격리 | 변경 없음 — 영향 없음 | — |
| INV-5 dispatcher 고정 | `ComponentType` union·14+NC-1 매핑·switch **변경 0**(신규 componentType 없음) | §2 판정 |

---

## 8. 최종 판정 요약

- **가격모델:** 옵셋 캘린더(HLCLSTD·HLCLWAL) = **책자 PriceTable3D 변형 확정**. ORD_INFO 필드 책자와 완전 동일, 계약 변경 **0건**.
- **신규 componentType:** **불요**(NC 패턴 S4·S5·S6 3연속). 캘린더 전용 옵션 전부 PCS_INFO(finish-button)+메타(select-box) 기존 타입 흡수. dispatcher 0변경.
- **위젯 코어 변경 기대:** **0줄**(목표). 실 변경은 어댑터 PRN_CNT 래더 enum 분기 + fixture 3종 + test 1종에 격리. printCount echo 1줄은 코어 0 우선 시도 후 필요 시에만.
