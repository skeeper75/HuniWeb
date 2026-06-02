# s5-nc3-decision.md — NC-3 `image-option-selector` 신규 vs variant 판정

> 파이프라인 ③ 판정 노트. S4 NC-2 전례(`s4-acryl-spec.md` §1)와 동일한 디자인 시스템 근거 판정 방식.
> [HARD] 추측 금지 — 디자인 시스템 v5.0.0 카탈로그·캡처·계약 문서 실제 근거만.
> 근거 표기: [DS]=huni-design-system v5.0.0 / [DS11]=product-sections/11-goods.md / [FX]=product_GSTGMIC.json / [CAP]=05_qa/captures(s5_pouch_GSPUFBC·s3_rp_GSTGMIC) / [DC]=data-contract / [DA]=data-adapter / [ES]=expansion-strategy / [S4]=s4-acryl-spec.md.

---

## 0. 한 줄 결론

**NC-3는 신규 componentType이 아니다.** 디자인 시스템 v5.0.0의 정식 14 componentType 카탈로그에 `image-option-selector`(64×64)는 **존재하지 않으며**, 굿즈/파우치 색상·타입 셀렉터는 기존 `large-color-chip`(50×50 그리드, RULE-8-EXT)·`image-chip`(50×50, RULE-6-EXT)·`option-button`으로 전부 흡수된다. 따라서 **S5는 신규 dispatcher case 없이 위젯 코어 0 변경으로 굿즈/파우치를 렌더한다.** NC-1(S3)만 추가된 14+1 dispatcher 그대로 유지된다. [DS][DS11]

---

## 1. 판정 방식 (S4 전례 계승)

[S4 §1.1]은 "신규가 정당화되는 유일 조건 = **디자인 시스템에서 그 옵션이 기존 컴포넌트와 시각이 명확히 다른 전용 레이아웃을 요구할 때**"로 정했고, 근거를 못 찾으면 그 사실을 명시하고 variant 디폴트로 판정했다. NC-3에도 동일 게이트를 적용한다.

판정 질문: **"굿즈/파우치 색상·타입 셀렉터가, 디자인 시스템 v5.0.0이 정의한 기존 이미지/색상 칩 컴포넌트와 시각이 명확히 다른 64×64 전용 레이아웃을 요구하는가?"**

---

## 2. 디자인 시스템 v5.0.0 조회 결과 (결정 근거)

| 확인 대상 | 결과 | 출처 |
|----------|------|------|
| 정식 14 componentType 매핑표에 `image-option-selector`/64×64 존재? | **존재하지 않음.** 14타입 = ButtonType·SelectBoxType·CounterInputType·ColorChipType(50×50)·PriceSliderType·**ImageChipType(50×50)**·MiniColorChipType(32×32)·LargeColorChipType(50×50 그리드)·AreaInputType·PageCounterInputType·FinishButtonType·FinishSelectBoxType·SummaryType·UploadType | [DS] "componentType 매핑 (14 타입 전체)" 표 |
| 이미지로 옵션 고르는 정식 컴포넌트 | **ImageChipType 50×50 원형**(RULE-6-EXT). 라벨 11px 하단, 선택=ring-2 #553886, 이미지 없으면 placeholder. **64×64가 아니라 50×50** | [DS] RULE-6-EXT |
| 굿즈/파우치 섹션(11번)이 실제 사용하는 컴포넌트 | Zone1 사이즈=**ButtonType**, 색상=**LargeColorChipType**(50×50 그리드, RULE-8-EXT). Zone2 수량=CounterInputType. Zone3 추가옵션=FinishButtonType. **64×64 이미지셀렉터 미사용** | [DS11] 4구역 레이아웃 표 |
| v4.1.0 변경이력의 "ImageOptionSelector 추가" | v4.1.0 HISTORY에 SPEC-DS-003 신규로 언급되나, **v5.0.0 정식 14타입 매핑표에는 편입되지 않음** = 50×50 ImageChip로 통합/대체됨. v5.0.0이 현행 카탈로그(source of truth) | [DS] frontmatter v5.0.0 + 14타입표 |
| 색상칩 사이즈 variant 다양성 | 이미 **3종 분화**(MiniColorChip 32×32 / ColorChip 50×50 / LargeColorChip 50×50 그리드). 새 64×64 사이즈를 도입할 디자인 근거 없음 | [DS] RULE-4/7/8-EXT |

→ **디자인 시스템 v5.0.0에서 "굿즈/파우치 색상·타입이 64×64 전용 레이아웃을 요구한다"는 근거를 찾지 못했다.** 오히려 굿즈 섹션은 명시적으로 LargeColorChipType(색상)·ButtonType(사이즈)를 쓰도록 정의돼 있다. [S4 §1.1 단순성 게이트]에 따라 **NC-3 신규 componentType은 만들지 않는다.**

---

## 3. 어떤 기존 컴포넌트로 흡수하는가

굿즈/파우치의 옵션 유형별 기존 매핑(전부 [DA §3] 룩업 테이블 기존 분기):

| 굿즈/파우치 옵션 유형 | 기존 componentType | 어댑터 분기 | 근거 |
|----------------------|--------------------|-------------|------|
| 색상 다수(그리드) | **`large-color-chip`** (50×50 grid, RULE-8-EXT) | `pcsComponentType(true)`→color-chip 계열; 다수 색상은 large-color-chip 룩업 | [DS11] Zone1 색상 / [DS] RULE-8-EXT |
| 색상 소형 | `mini-color-chip` (32×32) | colorHex 有 + 소형 | [DS] RULE-7-EXT |
| 재질/타입 이미지 칩 | **`image-chip`** (50×50, RULE-6-EXT) | `imageUrl` 有 (OptionValue.imageUrl) | [DC OptionValue.imageUrl] / [DS] RULE-6-EXT |
| 사이즈/타입(텍스트) | `option-button` | `DATASET_COMPONENT_TYPE.size` | [DA §3] |
| 수량/디자인수 | `counter-input` | `DATASET_COMPONENT_TYPE.quantity` | [DA §3] |
| 후가공/부자재 | `finish-button` | `pcsComponentType(false)` | [S4 §2.1] |

> [핵심] 위젯 계약 [DC]은 이미 `OptionValue.colorHex`(색상칩)와 `OptionValue.imageUrl`(image-chip) 슬롯을 보유한다. 굿즈 색상/이미지 셀렉터는 어댑터가 이 슬롯을 채워 기존 칩으로 렌더 → **계약·dispatcher 0 변경**.

---

## 4. 실측 검증 — S5 범위 SKU에 64×64 셀렉터가 실재하는가

[과제 요구: "실제 image-option-selector가 필요한 SKU가 S5 범위에 있는지 검토"]

| SKU(캡처) | 색상/타입 셀렉터 실재? | 실제 옵션 구조 | 출처 |
|-----------|----------------------|----------------|------|
| GSTGMIC(굿즈 마이크네임택) | **없음** | 자재 1종(BV300g)·사이즈 4종(option-button)·도수 1종·수량/디자인수(counter)·PCS 전부 VIEW_YN=N(숨김) | [FX] |
| GSPUFBC(파우치) | **없음** | 자재 1종·도수 1종·규격 5종(폐쇄 enum)·수량·인쇄수량 | [CAP s5_pouch] |

→ **현 S5 캡처 2종 어디에도 색상칩/이미지칩 자체가 노출되지 않는다.** 라이브에서 굿즈/파우치 옵션은 극단적으로 단순(자재 단일·사이즈 프리셋·수량)했다. 즉 64×64는커녕 50×50 color/image chip조차 이 2 SKU에는 등장하지 않는다.

> [정직한 flag] 디자인 시스템 [DS11]은 "굿즈 색상=LargeColorChipType"을 명시하나, 캡처한 2 SKU(마이크네임택·파우치)에는 색상 옵션이 없다. **다색 굿즈(머그/텀블러/에코백 색상, 말랑/문구 색상)** SKU를 캡처하면 large-color-chip(또는 mini/image-chip) 사용처가 실증될 것이다. 어느 경우든 50×50 그리드 칩(RULE-8-EXT)이 정식 답이며 **64×64 신규는 디자인 시스템에 근거 없음** → §6 후속 보강. NC-3 신규 불요 판정은 이 미캡처 SKU에 의해 뒤집히지 않는다(디자인 시스템이 50×50을 정식으로 규정하므로).

---

## 5. expansion-strategy 갱신 필요 항목

[ES §3 표 NC-3 행]·[ES §9]·[ES 부록 OPEN]은 "S5=NC-3(image-option-selector, image-chip variant 우선·미확정)"으로 미결이었다. 본 노트로 **확정: NC-3 = 신규 없음. 굿즈/파우치 색상·타입은 기존 large-color-chip/image-chip/option-button 흡수. 위젯 코어 0 변경.** [ES] 차기 갱신 시 "S5=NC-3 신규 없음(기존 칩 흡수, 디자인 시스템 v5.0.0에 64×64 부재)"로 정정 — 본 노트가 판정 소스. S4(NC-2)에 이어 **두 번째 "신규 불요" 실증** = [ES §1.3] "신규 componentType은 NC-1 단 1종"이 확정.

---

## 6. 후속 보강 포인트

- **다색 굿즈 SKU 캡처**(§4 flag): 머그/텀블러/에코백/말랑/문구 중 색상 옵션 보유 SKU를 라이브 캡처하여 large-color-chip(50×50 그리드) 또는 image-chip(50×50) 실사용 실증. 디자인 시스템상 50×50이 정식이므로 NC-3 판정 불변, 단 칩 렌더 라이브 검증 가치.
- **image-chip vs large-color-chip 선택 규칙**: 어댑터가 `imageUrl` 有→image-chip, `colorHex` 多→large-color-chip, `colorHex` 소형→mini-color-chip로 분기([DA §3] 기존). 굿즈 데이터에 imageUrl/colorHex 둘 중 무엇이 오는지는 후니 데이터 확정 시 어댑터가 결정(위젯 무관).
</content>
</invoke>
