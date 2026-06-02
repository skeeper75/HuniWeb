# s4-acryl-spec.md — S4 아크릴 명세 (NC-2 판정 + 라우팅 + 가격흐름)

> 파이프라인 ③. S4(아크릴, 카테고리 09) 구현 명세. S0~S3(NC-1) 비교 QA GO 완료 위에서 출발.
> [HARD] 본 명세의 핵심 판정 = **NC-2 `option-addon-picker` 신규 vs variant 흡수**. 결론은 §1.
> [HARD] 추측 금지 — fixture(`product_ACNTHAP.json`)·정규화 계약·디자인 시스템(v5.0.0) 실제 근거만 사용.
> 근거 표기: [FX]=product_ACNTHAP.json / [DS]=huni-design-system v5.0.0(08-acrylic.md 포함) / [DC]=data-contract / [DA]=data-adapter / [CT]=component-tree / [PE]=price-engine / [ES]=expansion-strategy / [NC1]=NC1-impl-note / [SRC]=04_build/src.
> NC-1 노트(§3 경계증명)의 절제된 톤 유지 — 과설계 금지.

---

## 0. 한 줄 결론

**NC-2는 신규 componentType이 아니다. ACNTHAP 부자재 옵션은 기존 `finish-button`(RULE-2)으로 흡수되며, 현 어댑터·위젯 코어 코드는 0 변경으로 ACNTHAP를 렌더·가격요청한다.** 가격델타 라벨 병기는 fixture에 델타 데이터가 없어 현 단계(Red)에서 표시할 숫자가 없다(§1.3 flag). 후니 가격표 연동 시점에 어댑터가 라벨에 병기한다 — 위젯은 절대 계산하지 않는다(INV-1).

---

## 1. NC-2 판정 결론 (신규 vs variant)

### 1.1 판정 = **variant 흡수 (finish-button)**

[ES §3 표]가 정한 디폴트는 **variant 흡수(단순성)**이며, 신규가 정당화되는 유일 조건은 "디자인 시스템에서 아크릴 옵션이 가격델타 표시 등으로 option-button과 **시각이 명확히 다른** 전용 레이아웃을 요구할 때"다. 이 조건은 충족되지 않는다.

**디자인 시스템 근거 (결정 근거):**

| 확인 대상 | 결과 | 출처 |
|----------|------|------|
| 아크릴 섹션 가공옵션 매핑 | 홀가공=**FinishButtonType**, 인쇄=FinishSelectBoxType. 부자재 전용 컴포넌트 **없음** | [DS] 08-acrylic.md Zone3 표 |
| "옵션 값별 추가단가/가격델타 표시" 전용 컴포넌트 | **존재하지 않음** — v5.0.0 14 componentType 카탈로그 전수 확인. FinishButton/Select/ColorChip 모두 가격델타 슬롯 없음 | [DS] componentType 매핑(14타입 전체) |
| v4.1.0 신규 컴포넌트(BadgeLabel/CalloutPopover/ImageOptionSelector/PageCounterInput/ColorChip 3-mode/QtySlider priceDisplay) | 어느 것도 "옵션 버튼 안에 추가단가를 병기하는 전용 레이아웃"이 아님. QtySlider priceDisplay는 슬라이더(수량) 전용 | [DS] SKILL frontmatter v4.1.0 |
| RULE-2 외 별도 시각 토큰(델타 강조색 등) | content text 허용색은 `#424242/#553886/#979797`뿐. 가격델타 전용 강조색 없음 | [DS] Typography CRITICAL |

→ **디자인 시스템에서 "아크릴 부자재가 finish-button과 시각이 명확히 다른 전용 레이아웃"을 요구하는 근거를 찾지 못했다.** [ES §3 단순성 판정]의 지침("시각 근거를 못 찾으면 그 사실을 명시하고 variant 디폴트로 판정")에 따라 **NC-2 신규 componentType은 만들지 않는다.**

### 1.2 어떤 기존 컴포넌트로 흡수하는가 — `finish-button`

[FX] `pdt_pcs_info`의 가시 부자재 그룹은 **WRK_MTR(부자재작업)** 1개:

| PCS_DTL_CD | PCS_DTL_NM | VIEW_YN | ESN_YN | SUB_MTRL_YN | colorHex |
|-----------|-----------|---------|--------|-------------|----------|
| NBPIN | 옷핀 집게 | Y | Y | Y | 없음 |
| NBMGN | 마그넷 | Y | Y | Y | 없음 |

- 그룹화: [SRC red-adapter.ts `mapPcsGroups`]가 `PCS_CD`별로 묶음 → `PCS_WRK_MTR` 1개 그룹, 값 2개(NBPIN/NBMGN).
- componentType: [SRC component-type-map.ts `pcsComponentType(false)`] — colorHex 부재 → **`finish-button`**(RULE-2: 흰배경+border-2 #553886). 색상칩이 아니다.
- 단일선택: `multiple` 미설정 → 단일(현 `mapPcsGroups`는 multiple 미부여 = 단일). ACNTHAP 부자재는 옷핀/마그넷 택1로 정합.

**finish-button이 시각적으로 충분한 이유:** 부자재 값은 텍스트 라벨(옷핀 집게/마그넷)뿐이고 색상·이미지가 없다. finish-button(116×50, 텍스트, RULE-2 선택표시)이 정확히 이 형태다. 별도 레이아웃 불요.

### 1.3 추가단가(가격델타) 라벨 병기 — 정직한 flag

[ES §3 NC-2 행]은 "라벨+추가단가 함께 표시"를 NC-2의 차별점으로 적었으나, **fixture에는 델타 숫자가 없다**:

- [FX] WRK_MTR 값은 `PCS_DTL_NM`(라벨)만 보유. 추가단가/단가델타 숫자 필드 **부재**. `WRK_WDT/WRK_HGH/CUT_WDT/CUT_HGH`는 전부 `0.00`(부자재는 치수 없음). 단가는 BFF가 PCS 조합으로 산출.
- 따라서 **현 단계(Red 어댑터)에서 라벨에 병기할 숫자가 존재하지 않는다.** 위젯/어댑터가 "+1,200원" 같은 텍스트를 만들어내면 그것은 추측이며 INV-1 위반 소지.
- **결정:** 현 단계 = 라벨 그대로(옷핀 집게/마그넷). 병기 없음. **후니 가격표 연동 시점**에 후니 데이터가 옵션별 단가를 제공하면 **어댑터가** `OptionValue.label`에 텍스트로 병기(`"마그넷 (+1,200원)"`). 계약에 가격 숫자 필드를 추가하지 않는다(라벨 텍스트로만). 위젯은 label을 그대로 렌더(RULE-5) — 계산 0.

> [INV-1 경계] 위젯이 델타를 계산·합산하는 것은 **절대 금지**. 델타는 (있다면) 어댑터가 만든 표시 텍스트일 뿐, 최종가 합산은 BFF 권위. [PE §0][ES §6.1]

### 1.4 expansion-strategy 갱신 필요 항목

[ES 부록 OPEN]·[ES §3 NC-2 행]은 "NC-2 변형 우선, Figma 확인 후 확정"으로 미결이었다. 본 명세로 **확정: NC-2 = finish-button variant 흡수, 신규 componentType 없음.** [ES §9 요약표]의 "S4=NC-2(option-addon-picker, 변형우선)"은 "S4=finish-button 흡수(신규 없음)"로 정정 대상(전략 문서 차기 갱신 시 반영, 본 명세가 판정 소스).

---

## 2. 어댑터 라우팅 명세

ACNTHAP는 **기존 red-adapter 경로로 코드 0 변경 흡수**된다. 아래는 각 그룹이 현 어댑터의 어느 분기를 타는지 명시(신규 분기 불요 증명).

### 2.1 WRK_MTR 부자재 그룹 → `finish-button` (selectedFinishes echo 경로)

| 단계 | 처리 | 출처 |
|------|------|------|
| 그룹화 | `mapPcsGroups(data.pdt_pcs_info, 'default')` → PCS_CD별 묶음 → `PCS_WRK_MTR` 그룹 | [SRC red-adapter.ts L104-131] |
| id | `PCS_WRK_MTR`(그룹), 값 id = `PCS_DTL_CD`(NBPIN/NBMGN, 불투명) | [SRC L113-118] |
| label | 그룹=`PCS_GRP_NM`("부자재작업"), 값=`PCS_DTL_NM`("옷핀 집게"/"마그넷") | [SRC L114-127] |
| componentType | `pcsComponentType(false)` → `finish-button`(colorHex 부재) | [SRC L123] |
| required | `ESN_YN==='Y'` → true | [SRC L125] |
| visible | `VIEW_YN==='Y'` → true(렌더됨) | [SRC L126] |
| 가격 echo | store `finishesFromSelections`가 `PCS_` prefix 그룹 선택값을 `selectedFinishes:[{groupId:'PCS_WRK_MTR', valueId:'NBPIN'}]`로 BFF 전송 | [SRC price.ts L63-73] |

→ **부자재 선택 = `selectedFinishes` 배열의 한 원소로 BFF에 echo.** 위젯은 단가 모름. BFF가 PCS_DTL_CD 조합으로 단가 산출. 이는 S3까지 검증된 finish 경로 그대로다.

### 2.2 사이즈 그룹 → NC-1 재사용 여부 = **재사용 안 함, option-button 유지**

[ES §S4 (a)]는 "사이즈=NC-1 재사용"으로 기대했으나, **fixture 사실로 검증하면 ACNTHAP는 NC-1 라우팅을 발동하지 않는다**:

| NC-1 발동 조건 [SRC red-adapter.ts L159-162] | ACNTHAP 실제 | 충족? |
|----|----|----|
| `priceScheme === 'real_price'` | `price_gbn = "vTmpl_price"` | **불충족** |
| 자유입력 sentinel(`CUT_WDT===0 && CUT_HGH===0`) 존재 | 소 70X25(cut 70/25), 중 75X25(cut 75/25) — **0×0 없음** | **불충족** |

→ `isDimensionMatrix=false` → 사이즈 그룹은 **`DATASET_COMPONENT_TYPE.size = 'option-button'`** 으로 라우팅. 값 2개(소/중), `DFT_YN=Y`인 "소 70X25"가 기본. sizeRules는 [SRC L317-323]로 정상 생성(cutW/cutH/workW/workH 수치 echo).

> **판정:** ACNTHAP는 **규격 프리셋 2개의 단순 선택**이며 가로×세로 자유입력이 없다. NC-1(dimension-matrix-input)은 자유입력 sentinel + real_price 조건의 S3 실사/배너 전용이다. ACNTHAP에 NC-1을 끌어오는 것은 불필요한 분기다. **사이즈 = option-button(기존)으로 충분.** [ES §S4]의 "NC-1 재사용" 기대는 fixture 미일치 — 본 명세가 정정(아크릴 명찰은 자유입력 아님).
>
> ⚠ 단, [ES §S4]가 명시한 다른 아크릴 SKU(아크릴 스탠드/코롯토 등)가 **자유입력 사이즈를 가지면** 그 SKU는 자동으로 NC-1 라우팅을 탄다(어댑터 조건이 데이터 구동). ACNTHAP(명찰)는 아님. → §5 라이브 보강 항목.

### 2.3 BON_PAP / LAS_DFT 숨김 필수옵션 처리 → 그룹은 생성되되 미렌더

[FX] BON_PAP(아크릴합지)·LAS_DFT(레이저)는 `VIEW_YN=N` + `ESN_YN=Y`(필수·숨김):

| 처리 | 결과 | 출처 |
|------|------|------|
| 그룹 생성 | `mapPcsGroups`가 `PCS_BON_PAP`, `PCS_LAS_DFT` 그룹도 생성(값 1개씩) | [SRC L104-131] |
| visible | `VIEW_YN==='N'` → `visible:false` | [SRC L126] |
| 렌더 | `<OptionGroupRenderer>`가 `optionGroups.filter(visible)` → **미렌더**(hidden essential = 자동적용) | [CT §1 OptionGroupRenderer] |
| 가격 echo | `defaultSelections`(widget-store.ts L109-118)가 visible 필터 없이 values 보유 그룹 첫 값을 기본선택 → hidden 필수도 `selections` 포함 → `finishesFromSelections`가 `PCS_` prefix 전부 echo. 필수 가공이 가격요청에 포함돼 BFF 단가 정합에 안전(QA S4-O1 실측) | [SRC price.ts L63-73] |

> **확인됨(QA S4-O1):** hidden essential(VIEW_YN=N + ESN_YN=Y)은 화면에 안 보이나 `defaultSelections`가 visible 무관하게 기본선택하므로 **`selectedFinishes`에 echo된다** — 필수 가공이 가격요청에 포함돼 BFF 단가 정합에 안전(당초 "미echo" 서술을 실동작으로 정정). 위젯/어댑터 변경 불요. [INV-1]

### 2.4 그 외 그룹 (코드 0 변경 흡수)

| Red 데이터셋 | 그룹 | componentType | 비고 |
|----|----|----|----|
| pdt_size_info (소/중) | GRP_SIZE | option-button | §2.2 |
| pdt_mtrl_info (고투명 PET 리무버블 1종) | GRP_MTRL_COVER | select-box | 값 1개여도 기존 경로 |
| pdt_dosu_info (단면 SID_S, CLR_CNT 4) | GRP_DOSU_COVER | option-button | priceColorCount=4 평면화. 단 skinInfo.dosuSelect.view_yn=N → §2.5 |
| pdt_prn_cnt_info | GRP_QUANTITY | counter-input | FIR=1/INC=1/STEP=10. 단위 pcs |
| WRK_MTR | PCS_WRK_MTR | finish-button | §2.1 (가시) |
| BON_PAP/LAS_DFT | PCS_* | finish-button | §2.3 (숨김 필수) |
| pdt_disable_pcs_info (RXIGC075→COT/MIS/SCO_DFT) | constraints.disableRules | — | 자재 선택 시 해당 PCS 비활성 [SRC L310-315] |

### 2.5 skinInfo view_yn=N 그룹 — OPEN (현 어댑터 미반영, 회귀 무해)

[FX] `skinInfo`는 `dosuSelect.view_yn="N"`, `paperSelect.view_yn="N"`(화면에서 도수·용지 섹션 숨김)을 명시한다. 현 어댑터는 `pdt_mtrl_info`/`pdt_dosu_info` 존재 시 무조건 visible 그룹을 만든다([SRC L198-227], skinInfo 미참조). ACNTHAP는 도수/용지를 화면에 노출하지 않는 것이 Red 동작이다.

→ **현 단계 영향:** 그룹이 렌더되지만 값 1개(자재)/단면 1개(도수)라 사용자 선택이 자명, 가격엔 무해(기본값 echo). **시각 정합은 후니 단계 또는 skinInfo 반영 시 보정.** 본 S4 범위에서는 위젯 코어 불변 원칙상 **어댑터에 skinInfo→visible 매핑을 추가하지 않는다(스코프 밖, 회귀 위험 회피)**. §5 라이브 보강 + build-plan OPEN에 기록.

---

## 3. 가격 흐름 (3중 모델 합성 = 전부 BFF)

[ES §S4 (c)]: 아크릴 최종가 = **SizeMatrix2D(투명3T/1.5T/미러3T 매트릭스) + 옵션단가(부자재) + TieredDiscount(50% 최대)** 3중 합성. **이 3개 모델은 전부 BFF 내부**이며, `buildPriceRequest`(위젯) 관점에서는 다음 입력만 보낸다:

```
buildPriceRequest(ACNTHAP 선택 상태) →
{
  productCode: "ACNTHAP",
  priceSchemeKey: "vTmpl_price",              // 불투명 echo (Red price_gbn)
  customerTier,                                // 어댑터가 채움 (TieredDiscount 입력 — BFF가 해석)
  dimensions: [{ side:'default', cutW:70, cutH:25, workW:72, workH:27 }],  // 선택 규격의 sizeRule (SizeMatrix2D 입력)
  colorCounts: { default: 4 },                 // 단면 CLR_CNT=4 평면화
  materials: { default: "RXIGC075" },          // 불투명 자재 id
  quantity,                                    // TieredDiscount 입력 (구간 판정은 BFF)
  pageCount: undefined,                        // 아크릴 비책자
  selectedFinishes: [{ groupId:'PCS_WRK_MTR', valueId:'NBPIN' }],  // 옵션단가 입력
}
```

| 가격모델 | 위젯이 보내는 입력 | 누가 계산 |
|----------|------------------|----------|
| SizeMatrix2D | `dimensions[].cutW/cutH/workW/workH` (선택 규격의 sizeRule 수치, NC-1과 동일 슬롯) | **BFF** (매트릭스 bilinear) |
| 옵션단가(부자재) | `selectedFinishes[{groupId,valueId}]` | **BFF** (PCS 조합 단가) |
| TieredDiscount | `quantity` + `customerTier` | **BFF** (구간 % 할인) |

→ **위젯 변경 = 0.** `buildPriceRequest`·`dimsFromSelection`·`finishesFromSelections`는 S0~S3에서 검증된 그대로 ACNTHAP 입력을 조립한다. 3중 합성은 BFF가 `priceSchemeKey="vTmpl_price"` 분기로 처리([PE §2 위젯 무관]). 응답은 불투명 `NormalizedPriceBreakdown`(finalPrice + lines[])만 [PE §4].

> [INV-1 경계] 위젯은 SizeMatrix2D 좌표·tier 할인율·부자재 단가를 모른다. 8축 입력만 보내고 불투명 `finalPrice`만 받는다. 새 가격모델(아크릴 3중 합성) 추가 = BFF 일, 위젯 0. [PE §0][ES §0 INV-1]

---

## 4. 변경 영향 범위 표 (NC1-impl-note §2 형식)

**ACNTHAP를 렌더·가격요청하기 위한 위젯/어댑터 변경 = 0줄.** 아래는 검증 자산(fixture/테스트)만 추가.

| # | 파일 | 변경 | 줄수(+/−) | 근거 |
|---|------|------|-----------|------|
| 1 | `src/contract/product.ts` | **변경 0** — `ComponentType` union 그대로(finish-button 기존) | 0 / 0 | NC-2 신규 없음(§1) |
| 2 | `src/widget/components/controls/OptionControl.tsx` | **변경 0** — finish-button case 기존 | 0 / 0 | 디스패처 case 추가 없음 |
| 3 | `src/widget/stores/widget-store.ts` | **변경 0** — selectOption/finishes/cascade 기존 경로 | 0 / 0 | 부자재 = 기존 selection |
| 4 | `src/widget/stores/price.ts` | **변경 0** — finishesFromSelections/dimsFromSelection 기존 | 0 / 0 | selectedFinishes echo 기존 |
| 5 | `src/adapters/red/red-adapter.ts` | **변경 0** — mapPcsGroups/mapOptionGroups가 ACNTHAP 자동 흡수 | 0 / 0 | §2 라우팅 전부 기존 분기 |
| 6 | `src/adapters/red/component-type-map.ts` | **변경 0** — pcsComponentType(false)=finish-button 기존 | 0 / 0 | colorHex 부재 |
| 7 | `04_build/fixtures/product_ACNTHAP.json` | **이미 존재**(보유) | — | [FX] |
| 8 | `test/red-adapter-acryl.test.ts` | **신규** — ACNTHAP fixture로 어댑터 출력 검증(부자재 그룹·숨김필수·사이즈 option-button·selectedFinishes echo) | 신규(+~70) | §5 핸드오프 |

> **위젯 코어 0 변경 증명 계획(INV-3):** 본 S4는 NC-1과 달리 store 분기조차 불필요하다. ACNTHAP는 책자(S0)·디지털(S1)·스티커(S2)와 동일한 "프리셋 사이즈 + finish 선택 + 수량" 골격이며, 차이(SizeMatrix2D·TieredDiscount·옵션단가)는 전부 BFF 가격 arm에 있다. 위젯 입장에서 ACNTHAP는 "이미 만든 컴포넌트로 렌더되는 또 하나의 상품"이다. → **변경 영향 = 검증 테스트 1개 추가뿐.** 이것이 [ES §1.3] "순수 어댑터+데이터" 등급에 ACNTHAP가 실질 부합함을 보인다(전략표는 S4를 "신규 NC-2"로 분류했으나, fixture 검증 결과 신규 불요 → S4는 사실상 어댑터+데이터로 흡수).

---

## 5. QA 핸드오프 포인트 (hw-qa)

### 5.1 ACNTHAP echo 검증 (어댑터 단위 + 라이브)

1. **부자재 그룹 echo**: ACNTHAP fixture → 어댑터 → `PCS_WRK_MTR` 그룹(finish-button, 값 NBPIN/NBMGN, visible, required) 생성 확인. 옷핀/마그넷 택1 → `selectedFinishes:[{groupId:'PCS_WRK_MTR', valueId}]`가 price req에 실리는지(NC-1 라이브 프로브 방식 = store→bff.price() 캡처).
2. **사이즈 option-button 확인**: GRP_SIZE componentType=`option-button`(NC-1 아님), 값 2개(소 70X25 기본/중 75X25), sizeRule cutW/cutH가 dimensions에 echo. **자유입력 칩 없음** 확인(NC-1 미발동).
3. **숨김 필수옵션**: BON_PAP/LAS_DFT 그룹 `visible:false`(미렌더). hidden이지만 BFF가 단가에 자동 포함하는지(Red `get_ajax_price_vTmpl` 응답에 ESN_YN=Y 가공 라인 존재 여부) — 라이브 보강.
4. **3중 가격 합성**: 규격 변경(소→중) / 부자재 변경(옷핀→마그넷) / 수량 변경(50% tier 경계) 시 finalPrice 변동이 Red BFF와 일치(로그인 캡처 필요 — 비로그인 PRICE=0). [NC1 §6 포인트3과 동일 한계].

### 5.2 회귀 (S0~S3 — INV-3)

5. **이전 stage fixture 무회귀**: PRBKYPR(S0)·디지털(S1)·스티커(S2)·BNBNFBL/BNPTPET(S3 NC-1) fixture가 여전히 동일 출력. **본 S4는 코드 0 변경이므로 회귀 위험이 구조적으로 0** — tsc/vitest green 확인만으로 충분.
6. **NC-1 미오염**: ACNTHAP(vTmpl_price, 0×0 sentinel 없음)가 NC-1 라우팅을 발동하지 않음 확인(dimension-matrix-input 미생성). 어댑터 조건 `real_price && hasFreeInput` 경계가 아크릴을 배제하는지.

### 5.3 라이브 보강 (live-capture 스킬)

7. **타 아크릴 SKU 자유입력 여부**: 아크릴 스탠드/코롯토/키링 등 [ES §S4 대표 SKU]가 가로×세로 **자유입력**을 가지면 그 SKU는 NC-1 라우팅을 타야 함 → 해당 SKU fixture 라이브 캡처로 `price_gbn`·자유입력 sentinel 존재 확인. (ACNTHAP=명찰은 프리셋만이므로 NC-1 무관.)
8. **skinInfo view_yn 시각 정합**: ACNTHAP는 도수/용지 섹션 숨김(skinInfo)이나 현 어댑터는 노출. Red 라이브 화면과 대조하여 시각 차이 기록(§2.5 OPEN). 위젯 코어 불변 원칙상 본 stage 미수정 — 후니 단계 보정.
9. **hidden essential 단가 포함**: 로그인 상태로 Red 가격 캡처하여 BON_PAP/LAS_DFT(숨김필수)가 finalPrice에 반영되는지 직접 증거. INV-1상 위젯 무관하나 후니 BFF 계약 검증에 필요.

---

## 6. 불변식 경계 증명 요약 (NC1 §3 수준)

| INV | 본 S4에서의 준수 | 증명 |
|-----|------------------|------|
| INV-1 서버권위 | 위젯 가격 산술 0. SizeMatrix2D·TieredDiscount·부자재단가 전부 BFF. 위젯은 dimensions/selectedFinishes/quantity 수치 echo만 | §3 표. price.ts 변경 0 |
| INV-2 계약 중립 | `selectedFinishes`/`OptionGroup`에 Red 고유명 0. PCS_CD/MTRL_CD/price_gbn/Shopby 미등장(불투명 id/echo) | 계약 타입 변경 0 |
| INV-3 코어 불변 | store/cascade/shadow/dispatcher/price-seam/editor-bridge **변경 0줄**(NC-1은 store 분기 1개였으나 S4는 그조차 불요) | §4 표 전 행 0/0 |
| INV-4 Shadow 격리 | 변경 없음 — 영향 없음 | — |
| INV-5 dispatcher 고정 | `ComponentType` union·14+NC-1 매핑·dispatcher switch **변경 0**(신규 case 없음) | §1 판정 |

---

## 7. OPEN (build-plan 반영)

- **skinInfo view_yn=N 그룹 미반영**(§2.5) — 아크릴 도수/용지 화면 숨김이 현 어댑터에 미반영. 후니 단계 또는 별도 보정 stage. 위젯 무관.
- **hidden essential(BON_PAP/LAS_DFT) BFF 단가 포함 검증**(§5.3-9) — 로그인 Red 캡처 필요. 위젯 무관(BFF 계약).
- **타 아크릴 SKU 자유입력 라우팅**(§5.3-7) — 명찰 외 아크릴(스탠드/코롯토)이 자유입력이면 NC-1 자동 발동. SKU별 fixture 캡처로 확인.
- **추가단가 라벨 병기 데이터**(§1.3) — 후니 가격표 연동 시 어댑터가 `OptionValue.label`에 병기. Red 단계 데이터 없음(병기 없음). 계약 가격필드 추가 금지.
- **expansion-strategy §3/§9 NC-2 정정**(§1.4) — "S4=NC-2 신규" → "S4=finish-button 흡수, 신규 없음". 전략문서 차기 갱신 시 반영(본 명세가 판정 소스).
