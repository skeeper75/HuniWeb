# component-tree.md — 컴포넌트 트리 + 14 componentType↔shadcn 매핑

> 파이프라인 ③. React 컴포넌트 구조 + DESIGN.md 14 componentType ↔ shadcn 매핑 + prop 스키마.
> 근거: [DESIGN] 14 componentType·8 Critical Rules·4-Zone / [동작분석] 캐스케이드·상태 / 정규화 계약(data-contract).

---

## 1. 컴포넌트 트리

```
<WidgetRoot>                         # createRoot(shadowRoot). Provider + 에러바운더리
 ├─ <WidgetProvider>                 # Zustand store 주입 + 정규화 product 로드
 │   ├─ <OptionPanel>                # DESIGN 4-Zone 컨테이너
 │   │   ├─ <OptionGroupRenderer>    # optionGroups.filter(visible).map() — RULE-5 동적
 │   │   │    └─ <OptionControl>     # componentType → 14 컴포넌트 디스패치 (§2)
 │   │   ├─ <SideSection side=default> (표지)   # 책자: 표지/내지 분리 섹션
 │   │   └─ <SideSection side=inner>  (내지)
 │   ├─ <PriceSummary>               # NormalizedPriceBreakdown 표시 (계산 안 함)
 │   ├─ <UploadArea>                 # 면별 uploadType 분기 (editor|pdf)
 │   │   ├─ <PdfUploader side>       # presigned PUT
 │   │   └─ <EditorLauncher side>    # editor-config → EditorOverlay 열기
 │   ├─ <OrderCTA>                   # CtaCapability 기반 3종 버튼
 │   └─ <EditorOverlay>              # Edicus iframe (포털 — shadow root 내 최상단)
 └─ (loader 브리지: 콜백/CustomEvent)
```

> [DESIGN 4.1] Zone1(사이즈+종이)·Zone2(수량+후가공헤더)·Zone3(후가공)·Zone4(부자재+합계+업로드)는 `OptionPanel` 내부 시각 그룹이나, 데이터 구동(RULE-5)이므로 Zone 하드코딩 아님 — `optionGroups`의 순서·side로 배치. Zone은 CSS 레이아웃 힌트.

---

## 2. 14 componentType ↔ shadcn 매핑표 (완전 커버)

| # | componentType | 파일 | shadcn 기반 | DESIGN 규칙 | 핵심 스펙 |
|---|--------------|------|-------------|-------------|----------|
| 1 | `option-button` | `OptionButton.tsx` | `Button` + variant | RULE-2 | 155×50, 3-col 0gap, 선택=흰배경+`border-2 #553886`+텍스트#553886 |
| 2 | `select-box` | `HuniSelect.tsx` | `Popover`+`Command` (커스텀) | RULE-1 | native select 금지, ▼ 텍스트 캐럿 #979797, 348×50, open=border#553886, 목록 shadow-lg z-50 |
| 3 | `counter-input` | `CounterInput.tsx` | 커스텀 (Button×2 + 표시) | RULE-3 | 223×50 `[34 −][155 값][34 +]`, divider 1px, 원형/native-number 금지 |
| 4 | `color-chip` | `ColorChip.tsx` | 커스텀 (Toggle) | RULE-4 | 50×50 원형, 선택=흰채움+`ring-2 #553886` |
| 5 | `price-slider` | `PriceSlider.tsx` | `Slider` (Radix) | RULE-5-EXT | @radix-ui/react-slider 필수, track 4px, thumb 16×16 원형 border-2, 틱≤6, native range 금지 |
| 6 | `image-chip` | `ImageChip.tsx` | 커스텀 (Toggle) | RULE-6-EXT | 50×50 원형, 선택 ring-2, 실패시 placeholder #F5F5F5, 라벨 11px 하단 |
| 7 | `mini-color-chip` | `MiniColorChip.tsx` | 커스텀 | RULE-7-EXT | 정확히 32×32(w-8 h-8) 원형, ring-2 #553886 |
| 8 | `large-color-chip` | `LargeColorChip.tsx` | 커스텀 (grid) | RULE-8-EXT | grid-cols-5 50×50, 색상명 하단, 색상 동적 상한없음 |
| 9 | `area-input` | `AreaInput.tsx` | `Input`×2 (커스텀) | DESIGN 7.9 | 각 140×50, `X` 구분자#424242, placeholder#CACACA, help 11px |
| 10 | `page-counter-input` | `PageCounterInput.tsx` | 커스텀 | DESIGN 7.10 | 50 height, ring-2 선택, min/max/step 동적, hover bg-gray-100 |
| 11 | `finish-button` | `FinishButton.tsx` | `Button` variant (= #1 재사용) | RULE-2 | 116×50, 선택=흰배경+border-2#553886+텍스트#553886 600 |
| 12 | `finish-select-box` | `FinishSelect.tsx` | `Popover`+`Command` (= #2 재사용) | RULE-1 | 461×50, ▼ 텍스트 캐럿, native select 금지 |
| 13 | `summary` | `PriceSummary.tsx` | 커스텀 | DESIGN 7.13 | 항목 12px#616161 + 금액, 합계 24px/600 #553886 |
| 14 | `upload-cta` | `OrderCTA.tsx` | `Button` variant×3 | DESIGN 7.14 | 465×50 radius **5px**, outline/filled(#553886)/dark(#3B2573) |

> [HARD RULE-5] 모든 컴포넌트는 라벨/값을 props(정규화 계약)로 받아 `.map()` 렌더. JSX에 한국어 옵션 라벨 직접 작성 금지. 데이터 우선순위: 정규화 계약(API) → Zustand → props.
> [DESIGN 공통] 전역 Noto Sans, 자간 -5% (`letterSpacing = fontSize × -0.05`). Lucide로 캐럿 ▼ 대체 금지(텍스트 문자).

---

## 3. 디스패처 (componentType → 컴포넌트)

```tsx
// OptionControl.tsx — 단일 디스패치 지점
function OptionControl({ group }: { group: OptionGroup }) {
  const { value, set } = useOptionSelection(group.id);  // store 셀렉터
  switch (group.componentType) {
    case 'option-button':      return <OptionButtonGroup group={group} value={value} onChange={set} />;
    case 'select-box':         return <HuniSelect group={group} value={value} onChange={set} />;
    case 'finish-select-box':  return <FinishSelect group={group} value={value} onChange={set} />;
    case 'counter-input':      return <CounterInput spec={group.inputSpec!} value={value} onChange={set} />;
    case 'page-counter-input': return <PageCounterInput spec={group.inputSpec!} value={value} onChange={set} />;
    case 'area-input':         return <AreaInput spec={group.inputSpec!} value={value} onChange={set} />;
    case 'price-slider':       return <PriceSlider spec={group.inputSpec!} value={value} onChange={set} />;
    case 'color-chip':         return <ColorChipGroup group={group} value={value} onChange={set} />;
    case 'mini-color-chip':    return <MiniColorChipGroup group={group} value={value} onChange={set} />;
    case 'large-color-chip':   return <LargeColorChipGroup group={group} value={value} onChange={set} />;
    case 'image-chip':         return <ImageChipGroup group={group} value={value} onChange={set} />;
    case 'finish-button':      return <FinishButtonGroup group={group} value={value} onChange={set} />;
  }
}
```

> [결정] switch 단일 디스패처(팩토리/레지스트리 추상화 금지 — 14개 고정, 단순성). `summary`/`upload-cta`는 OptionGroup이 아니라 패널 고정 컴포넌트라 디스패처 제외.

---

## 4. 공통 prop 스키마

```ts
// 선택형 그룹 공통
interface OptionGroupProps {
  group: OptionGroup;            // 정규화 계약
  value: string | string[];      // 선택된 valueId(들)
  onChange: (valueId: string | string[]) => void;
}
// 입력형 공통
interface InputControlProps { spec: InputSpec; value: number | [number, number]; onChange: (v) => void; }
```

상태 표현(전 컴포넌트 공통, DESIGN 7.0 표):
- default: `bg-white border border-[#CACACA] text-[#979797]`
- selected: RULE-2 류 = `border-2 border-[#553886] text-[#553886]`; ring류 = `ring-2 ring-[#553886]`
- disabled(캐스케이드): `bg-[#F5F5F5] text-[#CACACA] border-[#CACACA]`, `aria-disabled`, 클릭 불가

---

## 5. 캐스케이드 연동 (컴포넌트 관점)

[동작분석 cascade §1] 자재 변경 시: `onChange` → store가 `applyCascade()` 실행 → disabled valueId 갱신 → 영향 컴포넌트 리렌더(disabled 반영) → 선택해제된 값 있으면 가격 재계산 트리거. 컴포넌트는 `value.disabled`만 읽어 표시, 룰 로직은 store(state-management.md §4).

---

## 6. 접근성 (RULE-1 키보드)

- `select-box`/`finish-select-box`: 커스텀 div지만 Radix `Command`로 Escape/Enter/Space/Arrow + 외부클릭 닫기. `role=listbox`/`option`.
- `option-button`/`finish-button`: `role=radio`(단일) 또는 `checkbox`(다중), `aria-checked`.
- color/image chip: `aria-label`=색상명/옵션명(시각 라벨 없을 때).

---

## 7. OPEN

- `ImageOptionSelector` 64×64 (DESIGN 7.6 별도 규격) — 현 14종에 미포함, 필요 시 image-chip variant. [DESIGN]
- 모바일 레이아웃(Zone 재배치) [DESIGN 부록B TBD].
