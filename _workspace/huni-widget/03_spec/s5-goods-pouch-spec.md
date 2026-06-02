# s5-goods-pouch-spec.md — S5 굿즈/파우치/문구/말랑 명세 (NC-3 판정 + 가격모델 어댑터)

> 파이프라인 ③. S5(굿즈·파우치·문구·말랑/포장, 카테고리 10·11·08·12 일부) 구현 명세. S0~S4 비교 QA GO 위에서 출발.
> [HARD] 핵심 판정 = **NC-3 `image-option-selector`(64×64) 신규 vs variant**. 결론 = 신규 불요 (상세 `s5-nc3-decision.md`, 요지 §1).
> [HARD] 추측 금지 — fixture·캡처·디자인 시스템 v5.0.0·계약 문서 실제 근거만. 미캡처는 "후속 라이브 확인 필요"로 명시.
> 근거 표기: [FXG]=product_GSTGMIC.json / [CAPP]=s5_pouch_GSPUFBC.json / [CAPG]=s3_rp_GSTGMIC.json(라이브 가격) / [NOTE]=s5-pouch-live-note.md / [NC3]=s5-nc3-decision.md / [DS]=huni-design-system v5.0.0 / [DC]=data-contract / [DA]=data-adapter / [PE]=price-engine / [ES]=expansion-strategy / [S4]=s4-acryl-spec.md / [SRC]=04_build/src.
> [S4] 명세의 절제된 톤 유지 — 과설계 금지.

---

## 0. 한 줄 결론

**NC-3는 신규 componentType이 아니다(S4 NC-2에 이은 두 번째 "신규 불요" 실증). S5 굿즈/파우치는 위젯 코어·dispatcher·계약 0 변경으로 렌더된다.** 가격은 SKU별 상이한 두 평탄단가 모델(`tmpl_price` 룩업형 / `tiered_price`)이며, **둘 다 위젯엔 불투명**(서버 권위, INV-1). 어댑터는 ① 정규화 `quantity`→ORD_CNT·신규 `printCount`→PRN_CNT 직렬화 ② 가격호출 전 `ORD_CNT≥1 && PRN_CNT≥1` 가드(Red 침묵 PRICE=0 결함 재현 금지) ③ 규격 폐쇄형 enum + 치수 자동주입을 담당한다. **TieredDiscount(구간 %할인) 본진은 실측 SKU로 아직 미확인** — 후속 라이브 캡처 임계경로(§5).

---

## 1. NC-3 판정 결론 (요지 — 상세 `s5-nc3-decision.md`)

### 1.1 판정 = **신규 없음 (기존 칩/버튼 흡수)**

| 게이트 | 결과 | 근거 |
|--------|------|------|
| 디자인 시스템 v5.0.0 정식 14 componentType에 `image-option-selector`/64×64 존재? | **없음.** ImageChipType은 **50×50**(RULE-6-EXT), 64×64 아님 | [DS] 14타입 매핑표 / [NC3 §2] |
| 굿즈/파우치 섹션(11번)이 쓰는 컴포넌트 | 사이즈=ButtonType, 색상=**LargeColorChipType(50×50 그리드)**, 수량=CounterInput, 추가=FinishButton. 64×64 미사용 | [DS] 11-goods.md / [NC3 §2] |
| S5 캡처 SKU(GSTGMIC·GSPUFBC)에 색상/이미지 셀렉터 실재? | **없음** — 자재 단일·사이즈 프리셋·수량뿐 | [FXG][CAPP] / [NC3 §4] |

→ [S4 §1.1 단순성 게이트] 동일: "디자인 시스템에 64×64 전용 레이아웃 근거 없음 → variant 디폴트". 굿즈 색상·타입·재질은 기존 `large-color-chip`/`mini-color-chip`/`image-chip`/`option-button`으로 흡수. **계약 `OptionValue.colorHex`/`imageUrl` 슬롯이 이미 존재**하므로 dispatcher·계약 0 변경. [DC OptionValue]

### 1.2 expansion-strategy 정정

[ES §3/§9]의 "S5=NC-3(image-option-selector, 미확정)"은 **"S5=NC-3 신규 없음(기존 칩 흡수)"로 확정**. NC-2(S4)에 이어 두 번째 실증 → [ES §1.3] "확정 신규 = NC-1 단 1종"이 최종 성립. [NC3 §5]

---

## 2. S5 가격모델 어댑터 명세

### 2.1 두 평탄단가 모델 (라이브 확정 사실)

핸드오프의 "굿즈/파우치=TieredDiscount 본진" 가정은 **부분 오류**로 라이브 정정됨 [NOTE §④]. 실측 두 모델:

| 모델 | SKU(실측) | 단가 결정 | 수량 거동 | 할인구간 |
|------|----------|-----------|-----------|---------|
| **`tmpl_price`** (template-lookup) | 파우치 GSPUFBC | (규격 × PRN_CNT) 등록 템플릿 룩업 평탄단가 | ORD_CNT 선형, PRN_CNT 개당단가 정수배 | **없음**(전 구간 28,500원 평탄) [CAPP quantitySweep] |
| **`tiered_price`** | 굿즈 GSTGMIC | 개당 6,000원 평탄 | ORD_CNT/PRN_CNT 선형 | **실측 SKU에선 없음**(개당 6000 평탄) [CAPG] |

> [실측 핵심] 두 모델 모두 캡처한 SKU에선 **평탄단가**(할인곡선 0). 차이는 `tmpl_price`가 (규격+PRN_CNT) 2차원 룩업으로 단가를 정하는 점뿐. **TieredDiscount(구간 %할인)는 실측 SKU에 나타나지 않음** → §5 후속 보강.

### 2.2 후니 4가지 가격모델 대응 정리

[ES INV-1] 후니 가격엔진은 4모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount)을 자체 보유. S5 두 Red 모델의 후니 모델 대응:

| Red 모델(참고) | 후니 모델 대응 | 근거 |
|---------------|----------------|------|
| `tmpl_price` (규격×PRN_CNT 룩업 평탄단가) | **PriceTable3D**(룩업 테이블 형태가 가장 근접 — 차원=규격·인쇄수량) 또는 후니 자체 룩업 | [PE §2 — 위젯 무관, 후니 자체 스킴] |
| `tiered_price` (수량구간 할인, 실측은 평탄) | **TieredDiscount**(구간 %할인) | [ES §S5 (c)] |

> [HARD INV-1] 이 대응은 **BFF/어댑터 내부 참고**일 뿐. 위젯은 두 모델 모두 불투명 `priceSchemeKey` echo만 하고 `finalPrice`만 받는다. 위젯이 룩업·tier·평탄 여부를 아는 일은 절대 없다. Red 가격값과 후니 가격값을 정합하지 않는다(별개 공식 [PE §0]).

### 2.3 어댑터 직렬화 — `quantity`→ORD_CNT, `printCount`→PRN_CNT

[CAPP][CAPG] 실측: `ORD_INFO[0]`에 **ORD_CNT(주문/디자인 건수) + PRN_CNT(인쇄수량) 둘 다** 필요. 현 계약 [DC NormalizedPriceRequest]은 `quantity: number` 단일 슬롯만 보유 → **PRN_CNT를 담을 슬롯이 없다.**

**계약 영향 (§3에서 확정): `NormalizedPriceRequest`에 optional `printCount?: number` 추가.**

| 정규화 필드 | Red 직렬화(어댑터) | 의미 | 근거 |
|------------|---------------------|------|------|
| `quantity` | `ORD_INFO[0].ORD_CNT` | 주문건수(굿즈=디자인 수) | [CAPP][CAPG][FXG skinInfo.quantityGroup.orderCnt="디자인 수 (건수)"] |
| `printCount`(신규 optional) | `ORD_INFO[0].PRN_CNT` | 인쇄수량(개당단가 정수배 인자) | [CAPP prnCntSweep][FXG skinInfo.quantityGroup.printCnt="수량"] |

> [PRN_CNT 의미 규명 — NOTE §④-5 해소] fixture [FXG] `skinInfo.quantityGroup.title = {orderCnt:"디자인 수 (건수)", printCnt:"수량"}` 가 라벨을 제공한다. **ORD_CNT="디자인 수(건수)", PRN_CNT="수량"**. 즉 사용자가 보는 "수량"이 PRN_CNT, "디자인 수"가 ORD_CNT. 라벨은 데이터 구동(RULE-5)이므로 어댑터가 `OptionGroup.label`/`InputSpec.helpText`에 그대로 노출(하드코딩 금지).

#### 어댑터 직렬화 위치 (계약 §2.4 보강)

[DA §2.4] Red 직렬화에 `PRN_CNT:quantity`만 있었다. **정정: 두 필드 분리.**
```
ORD_INFO[0] = { ..., ORD_CNT: req.quantity, PRN_CNT: req.printCount ?? 1, ... }
```
> 책자/디지털(S0/S1)은 `printCount` 미전달 → 어댑터가 기존 단일 수량 매핑 유지(하위호환). PRN_CNT 의미가 없는 상품군은 `printCount` undefined → 어댑터가 상품군 분기로 흡수([DA §5] "비책자 가격 ORD_INFO 정확 필드 = 어댑터 분기").

### 2.4 가격호출 전 가드 — `ORD_CNT≥1 && PRN_CNT≥1` (침묵 PRICE=0 재현 금지)

[NOTE §②][CAPP incompleteReqBody] Red 위젯 결함: ORD_CNT/PRN_CNT를 reqBody에 누락 → 서버 침묵 PRICE=0. **이 결함을 후니 구현에서 반복하지 말 것.**

가드 위치 = **어댑터 `PriceAdapter.quote()` 직전** (BFF 레이어, [DA §1]):
```
// adapters/*/price-adapter: quote() 진입 가드
if ((req.quantity ?? 0) < 1 || (req.printCount ?? 1) < 1) {
  return { ok: false, finalPrice: 0, vat: 0, shipping: 0, lines: [] }; // 명시적 미견적, 침묵 0 아님
}
```
> [결정] 가드는 **어댑터(서버)** 책임 — 위젯은 가격 의미를 모르므로(INV-1). 단 위젯 UX 보호 차원에서 `printCount`/`quantity` 입력 컨트롤의 `InputSpec.min≥1`(어댑터가 `pdt_prn_cnt_info.MIN_PRN_CNT`/`pdt_base_info.FIR_CNT`에서 채움)으로 0 입력 자체를 차단([FXG] MIN_PRN_CNT=1, FIR_CNT=1). 즉 **이중 방어**: leaf 컨트롤 min + 어댑터 quote 가드. 위젯 코어 변경 아님(InputSpec 기존 슬롯).

### 2.5 규격 폐쇄형 enum + 치수 자동주입 (읽기전용)

[NOTE §①③][CAPP sizePriceTable] 파우치 규격 = 등록 템플릿 정확매칭만 유효(임의 치수 PRICE=0). UI에 "직접 입력하기" 버튼이 있으나 `tmpl_price`에선 견적불가.

| 처리 | 명세 | 근거 |
|------|------|------|
| 규격 그룹 | `option-button`(값 ≤ 6, 텍스트) — **자유입력 NC-1 아님** | [DA §3][CAPP 규격 5종] |
| 치수 주입 | 규격 선택 → 해당 SizeRule의 cutW/cutH/workW/workH 자동주입(사용자 미입력) | [DC SizeRule][CAPP 작업=재단+20mm] |
| 자유입력 분기 | `tmpl_price` 상품은 `base.nonStandardAllowed=false` → 자유입력 칩 미생성(NC-1 미발동). "직접 입력하기"는 비활성/경고 | [DC BaseRule][NOTE §③] |

> [S3 NC-1과의 경계] NC-1(dimension-matrix-input)은 `real_price` + 자유입력 sentinel(0×0) 조건에서만 발동([SRC red-adapter L159-162]). 파우치는 `tmpl_price` + 등록 템플릿 폐쇄 enum → **NC-1 미발동, option-button 유지.** ACNTHAP(S4)와 동일 경계 논리.

### 2.6 무영향 옵션 정리 (가격재계산 트리거 제외)

[CAPP dimensionImpact] DOSU(단/양면)·PRN_CLR_CNT(색수)는 파우치 가격 영향 **0**(템플릿가 흡수). 굿즈도 동일 추정([CAPG] PCS 전부 PRICE=0, 인쇄단면만 단가). → 이 옵션들은 선택돼도 가격 재호출 불필요. 단 **현 위젯은 모든 selection 변경 시 schedulePriceQuote**([PE §3]). 무영향 옵션 제외 최적화는 **하지 않는다**(과설계 금지 — 디바운스+캐시가 이미 흡수, [PE §3] hashRequest 동일키→캐시 hit). 위젯 코어 불변.

---

## 3. 정규화 계약 영향

### 3.1 단 하나의 계약 변경 — `printCount?` optional 필드

| 파일 | 변경 | 안전성 |
|------|------|--------|
| `src/contract/price.ts` `NormalizedPriceRequest` | `printCount?: number` **optional 필드 1개 추가** | [ES §8] "OptionValue/InputSpec/Price 계약에 **optional 필드 추가는 하위호환**(이전 stage 무영향)". S0~S4 미전달 시 undefined → 어댑터 기존 동작 유지 |

> [INV-2 경계] `printCount`는 Red/후니 중립 도메인명(인쇄수량). `PRN_CNT` 같은 Red 고유명 아님. [DC §8] 계약 안정성 규칙 준수. **이것이 S5의 유일한 계약 변경**이며, optional이므로 dispatcher·이전 stage 회귀 0.

> [대안 검토 — 기각] `quantity`에 PRN_CNT를 곱해 단일 전달? → **기각**: 위젯이 곱하면 INV-1(서버 권위) 위반 소지 + ORD_CNT/PRN_CNT 분리 의미(디자인수 vs 수량) 손실. 두 값을 **각자 그대로** 어댑터에 넘기고 직렬화는 어댑터가([2.3]). 위젯은 두 수치를 echo만.

### 3.2 계약 변경 없는 항목 (확인)

- `ComponentType` union: **변경 0**(NC-3 신규 없음, §1). NC-1만 추가된 14+1 그대로.
- `OptionValue`: colorHex/imageUrl 슬롯 **기존 보유** — 굿즈 색상/이미지 칩 추가 변경 0.
- `NormalizedConstraints`/`SizeRule`/`BaseRule`: 규격 enum·치수주입 기존 슬롯으로 충분(§2.5).

---

## 4. 위젯 코어 0변경 증명 계획 (hw-builder 검증 항목)

[INV-3] store/cascade/shadow/dispatcher/price-seam/editor-bridge **변경 0줄** 목표. NC-1(S3)이 store에 분기 1개 추가한 것과 달리, S5는 **계약 optional 필드 1개 + 어댑터 직렬화 분기**뿐.

### 4.1 변경 영향 범위 표 (s4-acryl-spec §4 형식)

| # | 파일 | 변경 | 줄수(+/−) | 근거 |
|---|------|------|-----------|------|
| 1 | `src/contract/price.ts` | `printCount?: number` optional 추가 | +1 / 0 | §3.1 (유일한 계약 변경) |
| 2 | `src/widget/stores/price.ts` `buildPriceRequest` | `printCount: <printCount selection>` 1줄 추가(존재 시) | +1 / 0 | 수량과 동일 패턴, 새 store 분기 아님 |
| 3 | `src/widget/components/controls/OptionControl.tsx` (dispatcher) | **변경 0** — NC-3 신규 case 없음 | 0 / 0 | §1 판정 |
| 4 | `src/widget/stores/widget-store.ts` (cascade/selectOption) | **변경 0** — printCount는 counter-input 기존 경로 | 0 / 0 | counter-input 재사용 |
| 5 | `src/adapters/red/red-adapter.ts` | ORD_CNT/PRN_CNT 직렬화 분리(§2.3) + tmpl/tiered price_gbn echo | 어댑터 수정(위젯 아님) | [DA §2.4] 보강 |
| 6 | `src/adapters/red/component-type-map.ts` | **변경 0** — 굿즈/파우치 전부 기존 매핑 | 0 / 0 | §1 |
| 7 | `src/adapters/*/price-adapter` quote 가드 | `ORD_CNT≥1 && PRN_CNT≥1` 가드 추가(어댑터) | 어댑터 추가 | §2.4 |
| 8 | `fixtures/product_GSTGMIC.json` | **이미 보유** | — | [FXG] |
| 9 | `fixtures/product_GSPUFBC.json` | **신규 권장**(파우치 어댑터 테스트용) — [CAPP] 구조로 작성 | 신규 fixture | §5 |
| 10 | `test/red-adapter-goods-pouch.test.ts` | **신규** — GSTGMIC/GSPUFBC 어댑터 출력 검증 | 신규(+~80) | §4.2 |

> **위젯 코어 0변경 증명:** dispatcher case 0, store 분기 0(buildPriceRequest의 printCount 추가는 quantity와 동일한 "수치 echo" 슬롯이지 새 분기 아님 — NC-1의 dimsFromSelection if-분기보다 약함). cascade/shadow/editor-bridge/price-seam 0. **S5는 S4(완전 0)와 NC-1(분기 1개) 사이** — 계약 optional 1필드 + 그 값을 echo하는 1줄. INV-3/5 유지.

### 4.2 hw-builder 검증 체크리스트

1. **굿즈 GSTGMIC 어댑터 출력**: 사이즈 4종=option-button(삼각S 기본 DFT_YN=Y), 자재 1종=select-box, 수량/디자인수=counter-input, PCS 전부 VIEW_YN=N→`visible:false`(미렌더, hidden essential), `price_gbn="tiered_price"` echo. [FXG]
2. **파우치 GSPUFBC 어댑터 출력**: 규격 5종=option-button(폐쇄 enum), 치수 자동주입(SizeRule), 자재/도수 단일, `printCount` 슬롯→PRN_CNT 직렬화, `price_gbn="tmpl_price"` echo. nonStandardAllowed=false → NC-1 미발동. [CAPP]
3. **ORD_CNT+PRN_CNT 직렬화**: buildPriceRequest가 quantity·printCount 둘 다 채우고 어댑터가 ORD_INFO[0]에 두 필드 직렬화(누락 시 가드 발동). [CAPP completeReqBody]
4. **가드 동작**: printCount=0 또는 quantity=0 → quote()가 `{ok:false, finalPrice:0}` 명시 반환(침묵 0 아님). [NOTE §②]
5. **계약 중립**: `printCount`만 추가됐고 PRN_CNT/ORD_CNT/price_gbn 등 Red 고유명 위젯·계약 0건(grep 게이트). [INV-2]
6. **회귀(INV-3)**: PRBKYPR(S0)·디지털(S1)·스티커(S2)·BNBNFBL/BNPTPET(S3 NC-1)·ACNTHAP(S4) fixture 여전히 동일 출력. printCount optional이므로 이전 stage 무영향. tsc/vitest green.
7. **NC-1 미오염**: 파우치(tmpl_price)·굿즈(tiered_price)가 NC-1 dimension-matrix-input 미생성(real_price+0×0 sentinel 아님). [SRC L159-162]

---

## 5. 후속 보강 포인트 (build-plan / live-capture 임계경로)

| # | 항목 | 영향 | 대응 |
|---|------|------|------|
| S5-M1 | **TieredDiscount 본진 미확인** | S5 가격모델 대표성 | 핸드오프 "굿즈/파우치=TieredDiscount" 가정이 실측 2 SKU에선 평탄단가로 나타남. **말랑(2개부터 즉시할인·최대50% [ES §S5])·문구 SKU 라이브 캡처**로 실제 구간할인 곡선 확보 — TieredDiscount 모델 검증 임계경로. 위젯 무관(BFF), 단 후니 비교검증에 필요 |
| S5-M2 | **다색 굿즈 SKU 미캡처** | large-color-chip/image-chip 실사용 | 머그/텀블러/에코백/말랑(색상) SKU 캡처로 색상칩 렌더 실증([NC3 §6]). NC-3 판정 불변(50×50 정식) |
| S5-M3 | **파우치 fixture 미적재** | 어댑터 단위테스트 | [CAPP] 구조로 `product_GSPUFBC.json` 작성(§4.1-9). tmpl_price·규격 enum·치수주입 검증 |
| S5-M4 | **로그인 실가 비교** | tmpl/tiered finalPrice 정합 | 규격변경→단가변동([CAPP sizePriceTable] 28,500~36,500) Red BFF 일치 비교(로그인 캡처 완료 — GSPUFBC). 후니 어댑터 단계는 정규화 스키마 일치로 게이트 전환([ES §5.2]) |
| S5-M5 | **카테고리 010/011 코드정책**(D-PM-01) | 어댑터 키 | MES ITEM_CD 미부여 100+종 → 어댑터가 ID/신규코드를 `code`로([ES §6.2 PM-MISS-01]). 위젯 무관(불투명 id) |
| S5-M6 | **no-design 상품**(포장재/부자재) | 업로드영역 미렌더 | uploadType 없으면 위젯이 업로드영역 미렌더(기존 수용 [ES §S5 (e)]). FixedUnit 포장재는 priceSchemeKey echo만 |

---

## 6. 불변식 경계 증명 요약 (s4-acryl-spec §6 수준)

| INV | 본 S5에서의 준수 | 증명 |
|-----|------------------|------|
| INV-1 서버권위 | 위젯 가격 산술 0. tmpl_price 룩업·tiered 평탄·향후 TieredDiscount 전부 BFF. 위젯은 quantity/printCount/dimensions echo만 | §2.2 표, price.ts 산술 0 |
| INV-2 계약 중립 | 신규 `printCount`는 중립 도메인명. PRN_CNT/ORD_CNT/price_gbn/tmpl_price 위젯·계약 0건 | §3.1, grep 게이트 §4.2-5 |
| INV-3 코어 불변 | dispatcher/cascade/shadow/editor-bridge/price-seam 0줄. store는 printCount echo 1줄(새 분기 아님) | §4.1 표 |
| INV-4 Shadow 격리 | 변경 없음 — 영향 없음 | — |
| INV-5 dispatcher 고정 | `ComponentType` union·14+NC-1 매핑·switch **변경 0**(NC-3 신규 없음) | §1 판정 [NC3] |

---

## 7. OPEN (build-plan 반영)

- **TieredDiscount 실측 미확인**(S5-M1) — 말랑/문구 라이브 캡처 임계경로. 현 2 SKU는 평탄단가. 위젯 무관.
- **파우치 fixture 미적재**(S5-M3) — `product_GSPUFBC.json` 작성 권장(어댑터 테스트).
- **다색 굿즈 SKU 미캡처**(S5-M2) — 색상칩 렌더 실증. NC-3 판정 불변.
- **expansion-strategy §3/§9 NC-3 정정**(§1.2) — "S5=NC-3 신규" → "S5=NC-3 신규 없음(기존 칩 흡수)". 전략문서 차기 갱신 시 반영(본 명세+s5-nc3-decision.md가 판정 소스).
- **카테고리 010/011 어댑터 키 정책**(S5-M5) — 후니 D-PM-01 대기. 위젯 무관(불투명).
</content>
