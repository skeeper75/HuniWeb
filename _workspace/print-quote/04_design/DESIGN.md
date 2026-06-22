---
name: Huni Printing
description: >
  후니프린팅(Huni Printing) 자동견적 사이트의 상품 옵션 UI 디자인 시스템.
  Figma REST API 검증 토큰 + 14 componentType + Critical Rules 기반 단일 디자인 소스.
  실무진 검토용 + AI Agentic Coding 일관 적용용.
source:
  figma-file: "gEJhQRtmKI66BPhOpqoW3j"
  skill: "innojini-huni-design-system v5.0.0"
  verified: "2026-03-10"
  gap-analysis: "2026-03-05 (primary #5538B6 -> #553886, dark #351D87 -> #3B2573)"
colors:
  # Purple Family (Primary Brand)
  primary: "#553886"
  primary-dark: "#3B2573"
  primary-secondary: "#9580D9"
  primary-light-1: "#C9C2DF"
  primary-light-2: "#DED7F4"
  primary-light-3: "#EEEBF9"
  # Neutral / Gray Family
  text-dark: "#1E1E1E"
  text-label: "#424242"
  text-body: "#616161"
  text-medium: "#565656"
  text-muted: "#979797"
  border-default: "#CACACA"
  divider: "#E8E8E8"
  bg-light: "#E9E9E9"
  bg-section: "#F5F5F5"
  bg-white: "#FFFFFF"
  # Accent Colors
  accent-gold: "#E6B93F"
  accent-teal: "#7AC8C4"
  badge-recommend: "#FF66CC"
  badge-best: "#3B2573"
  badge-new: "#FF1493"
  badge-up: "#00BCD4"
typography:
  # Font Family: Noto Sans ONLY. Letter-spacing = fontSize x -0.05 (-5% universal).
  h1: { fontFamily: Noto Sans, fontSize: 36px, fontWeight: 600, letterSpacing: -1.8px, color: "{colors.text-label}" }
  h2: { fontFamily: Noto Sans, fontSize: 24px, fontWeight: 600, letterSpacing: -1.2px, color: "{colors.text-label}" }
  body-semibold: { fontFamily: Noto Sans, fontSize: 16px, fontWeight: 600, letterSpacing: -0.8px, color: "{colors.text-label}" }
  body-medium: { fontFamily: Noto Sans, fontSize: 14px, fontWeight: 500, letterSpacing: -0.7px, color: "{colors.text-label}" }
  body-regular: { fontFamily: Noto Sans, fontSize: 14px, fontWeight: 400, letterSpacing: -0.7px, color: "{colors.text-label}" }
  section-label: { fontFamily: Noto Sans, fontSize: 16px, fontWeight: 500, letterSpacing: -0.8px, color: "{colors.text-label}" }
  caption: { fontFamily: Noto Sans, fontSize: 12px, fontWeight: 400, letterSpacing: -0.6px, color: "{colors.text-body}" }
  help-text: { fontFamily: Noto Sans, fontSize: 11px, fontWeight: 400, letterSpacing: -0.55px, color: "{colors.text-muted}" }
  total-amount: { fontFamily: Noto Sans, fontSize: 24px, fontWeight: 600, letterSpacing: -1.2px, color: "{colors.primary}" }
  button-ui: { fontFamily: Noto Sans, fontSize: 14px, fontWeight: 600, letterSpacing: -0.7px, color: "{colors.bg-white}" }
  caption-semibold: { fontFamily: Noto Sans, fontSize: 12px, fontWeight: 600, letterSpacing: -0.6px, color: "{colors.primary}" }
  counter-sign: { fontFamily: Noto Sans, fontSize: 18px, fontWeight: 400, letterSpacing: -0.9px, color: "{colors.text-label}" }
  caret: { fontFamily: Noto Sans, fontSize: 12px, fontWeight: 400, letterSpacing: -0.6px, color: "{colors.text-muted}" }
rounded:
  sm: 4px
  cta: 5px
  checkbox: 3px
  slider-track: 2px
  full: 9999px
spacing:
  section-x: 20px
  grid-gap: 0px
  divider-height: 1px
  section-label-height: 40px
  field-padding-x: 16px
  field-padding-x-text: 12px
components:
  # NOTE: design.md 컴포넌트 valid sub-token = backgroundColor/textColor/typography/rounded/padding/size/height/width 만 허용.
  # border(테두리 색·굵기), ring(선택상태 ring), placeholder, caret, indicator, gridCols 등은
  # 본문 §5 Elevation, §6 Shapes, §7 Components 표, §8 Do's & Don'ts에 prose/표로 서술됨(손실 없음).
  # 1. ButtonType (RULE-2) — OptionButton.tsx  [border: 1px #CACACA / 선택: 2px #553886 / 본문 §7.1, RULE-2]
  option-button:
    width: 155px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
    typography: "{typography.body-regular}"
    textColor: "{colors.text-muted}"
  option-button-selected:
    backgroundColor: "{colors.bg-white}"
    textColor: "{colors.primary}"
  # disabled: 텍스트 #CACACA(§7.0 표) — WCAG 비활성 컨트롤 예외, textColor 미지정으로 대비 검사 비대상
  option-button-disabled:
    backgroundColor: "{colors.bg-section}"
  # 2. SelectBoxType (RULE-1) — HuniCustomSelect (PaperDropdown.tsx)  [border: 1px #CACACA / open: 1px #553886 / 본문 §7.2, RULE-1]
  select-box:
    width: 348px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
    padding: "{spacing.field-padding-x}"
    typography: "{typography.body-regular}"
    textColor: "{colors.text-label}"
  select-box-open:
    backgroundColor: "{colors.bg-white}"
  select-box-caret:
    typography: "{typography.caret}"
    textColor: "{colors.text-muted}"
  select-box-option-hover:
    backgroundColor: "{colors.bg-section}"
  # 3. CounterInputType (RULE-3) — CounterInput.tsx  [border: 1px #CACACA / divider 1px #CACACA / 본문 §7.3, RULE-3]
  counter-input:
    width: 223px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
  counter-input-side:
    width: 34px
    height: 50px
    typography: "{typography.counter-sign}"
    textColor: "{colors.text-label}"
  counter-input-center:
    width: 155px
    height: 50px
    typography: "{typography.body-medium}"
    textColor: "{colors.text-muted}"
  counter-input-divider:
    width: 1px
    height: 50px
    backgroundColor: "{colors.border-default}"
  # 4. ColorChipType (RULE-4) — ColorChip.tsx  [선택: 흰채움 + #553886 ring 2px / 본문 §6, §7.4, RULE-4]
  color-chip:
    width: 50px
    height: 50px
    rounded: "{rounded.full}"
  color-chip-selected:
    backgroundColor: "{colors.bg-white}"
  # 5. PriceSliderType (RULE-5-EXT) — PriceSlider.tsx (Radix)  [thumb 테두리 #553886 2px / track radius 2px / 본문 §7.5]
  price-slider-track:
    height: 4px
    rounded: "{rounded.slider-track}"
    backgroundColor: "{colors.border-default}"
  price-slider-range:
    backgroundColor: "{colors.primary}"
  price-slider-thumb:
    width: 16px
    height: 16px
    rounded: "{rounded.full}"
    backgroundColor: "{colors.bg-white}"
  price-slider-label:
    typography: "{typography.help-text}"
    textColor: "{colors.text-muted}"
  # 6. ImageChipType (RULE-6-EXT) — ImageChipType.tsx  [선택: #553886 ring 2px / placeholder bg #F5F5F5 / 본문 §7.6]
  image-chip:
    width: 50px
    height: 50px
    rounded: "{rounded.full}"
    backgroundColor: "{colors.bg-section}"
  image-chip-selected:
    backgroundColor: "{colors.bg-white}"
  image-chip-label:
    typography: "{typography.help-text}"
    textColor: "{colors.text-label}"
  # 7. MiniColorChipType (RULE-7-EXT) — MiniColorChip.tsx  [선택: #553886 ring 2px / 본문 §7.7]
  mini-color-chip:
    width: 32px
    height: 32px
    rounded: "{rounded.full}"
  mini-color-chip-selected:
    backgroundColor: "{colors.bg-white}"
  # 8. LargeColorChipType (RULE-8-EXT) — LargeColorChip.tsx  [선택: #553886 ring 2px / grid-cols-5 / 본문 §7.8]
  large-color-chip:
    width: 50px
    height: 50px
    rounded: "{rounded.full}"
  large-color-chip-selected:
    backgroundColor: "{colors.bg-white}"
  large-color-chip-label:
    typography: "{typography.help-text}"
    textColor: "{colors.text-label}"
  # 9. AreaInputType (FinishInput) — FinishInput.tsx / HuniAreaOptions.tsx  [border 1px #CACACA / placeholder #CACACA / 본문 §7.9]
  area-input:
    width: 140px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
    typography: "{typography.body-regular}"
    textColor: "{colors.text-label}"
  area-input-separator:
    typography: "{typography.body-regular}"
    textColor: "{colors.text-label}"
  area-input-help:
    typography: "{typography.help-text}"
    textColor: "{colors.text-muted}"
  # 10. PageCounterInputType — PageCounterInput.tsx  [border 1px #CACACA / 선택: #553886 ring 2px / 본문 §7.10]
  page-counter-input:
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
  page-counter-input-selected:
    backgroundColor: "{colors.bg-white}"
  # 11. FinishButtonType (RULE-2) — FinishButton.tsx  [border 1px #CACACA / 선택: 2px #553886 / 본문 §7.11, RULE-2]
  finish-button:
    width: 116px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
    typography: "{typography.caption}"
    textColor: "{colors.text-muted}"
  finish-button-selected:
    backgroundColor: "{colors.bg-white}"
    typography: "{typography.caption-semibold}"
    textColor: "{colors.primary}"
  # 12. FinishSelectBoxType (RULE-1) — FinishSelect.tsx  [border 1px #CACACA / open: #553886 / 본문 §7.12, RULE-1]
  finish-select-box:
    width: 461px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.sm}"
    typography: "{typography.body-regular}"
    textColor: "{colors.text-label}"
  finish-select-box-caret:
    typography: "{typography.caret}"
    textColor: "{colors.text-muted}"
  # 13. SummaryType — PriceResult.tsx  [본문 §7.13]
  summary:
    backgroundColor: "{colors.bg-white}"
  summary-label:
    typography: "{typography.body-semibold}"
    textColor: "{colors.text-dark}"
  summary-item:
    typography: "{typography.caption}"
    textColor: "{colors.text-body}"
  summary-total:
    typography: "{typography.total-amount}"
    textColor: "{colors.primary}"
  # 14. UploadType — OrderCTA.tsx  [outline: 테두리 1px #553886 / filled·dark: 본문 §7.14]
  upload-button:
    width: 465px
    height: 50px
    backgroundColor: "{colors.bg-white}"
    rounded: "{rounded.cta}"
    typography: "{typography.body-semibold}"
    textColor: "{colors.text-label}"
  upload-button-design:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.bg-white}"
  upload-button-cart:
    backgroundColor: "{colors.primary-dark}"
    textColor: "{colors.bg-white}"
  # Supporting components
  finish-title-bar:
    width: 466px
    height: 50px
    backgroundColor: "{colors.bg-section}"
  finish-title-bar-title:
    typography: "{typography.section-label}"
    textColor: "{colors.text-label}"
  finish-title-bar-action:
    typography: "{typography.caption}"
    textColor: "{colors.primary}"
  # Badges — backgroundColor 로 badge 색 참조 (orphan 해소)
  badge-recommend:
    width: 32px
    height: 14px
    backgroundColor: "{colors.badge-recommend}"
    textColor: "{colors.bg-white}"
  badge-best:
    width: 32px
    height: 14px
    backgroundColor: "{colors.badge-best}"
    textColor: "{colors.bg-white}"
  badge-new:
    width: 32px
    height: 14px
    backgroundColor: "{colors.badge-new}"
    textColor: "{colors.bg-white}"
  badge-up:
    width: 32px
    height: 14px
    backgroundColor: "{colors.badge-up}"
    textColor: "{colors.bg-white}"
  badge-gold:
    width: 32px
    height: 14px
    backgroundColor: "{colors.accent-gold}"
    textColor: "{colors.bg-white}"
  badge-teal:
    width: 32px
    height: 14px
    backgroundColor: "{colors.accent-teal}"
    textColor: "{colors.bg-white}"
  # Hover/tint surfaces — primary-secondary/light 참조 (orphan 해소)
  # NOTE: surface-* 는 배경 표면 토큰이므로 textColor 미지정(텍스트 콘텐츠 없음 → 대비 검사 비대상)
  surface-hover:
    backgroundColor: "{colors.primary-light-3}"
  surface-accent:
    backgroundColor: "{colors.primary-secondary}"
  surface-tint-1:
    backgroundColor: "{colors.primary-light-1}"
  surface-tint-2:
    backgroundColor: "{colors.primary-light-2}"
  # Divider — divider 색 참조 (orphan 해소)
  divider:
    height: 1px
    backgroundColor: "{colors.divider}"
  # checkbox  [border 2px #CACACA / checked: #553886 / 본문 §6, §7 보조]
  checkbox:
    width: 20px
    height: 20px
    rounded: "{rounded.checkbox}"
    backgroundColor: "{colors.bg-white}"
  checkbox-checked:
    backgroundColor: "{colors.primary}"
  # radio  [border 2px #CACACA / selected: #553886 / 본문 §6, §7 보조]
  radio-button:
    width: 20px
    height: 20px
    rounded: "{rounded.full}"
    backgroundColor: "{colors.bg-white}"
  radio-button-selected:
    backgroundColor: "{colors.primary}"
  # tab  [active: 하단 인디케이터 라인 2px #553886 / 본문 §5, §7 보조]
  tab:
    typography: "{typography.body-regular}"
    textColor: "{colors.text-muted}"
  tab-active:
    typography: "{typography.body-semibold}"
    textColor: "{colors.primary}"
  tab-active-indicator:
    height: 2px
    backgroundColor: "{colors.primary}"
  # text-field  [border 1px #CACACA / active 2px #553886 / disabled 1px #E9E9E9 / placeholder #CACACA / 본문 §7 보조]
  text-field:
    height: 44px
    backgroundColor: "{colors.bg-white}"
    padding: "{spacing.field-padding-x-text}"
    typography: "{typography.body-regular}"
    textColor: "{colors.text-medium}"
  text-field-active:
    backgroundColor: "{colors.bg-white}"
    textColor: "{colors.text-label}"
  # disabled: 텍스트 #CACACA, 테두리 1px #E9E9E9(§7.0 표) — WCAG 비활성 예외, textColor 미지정
  text-field-disabled:
    backgroundColor: "{colors.bg-light}"
---

# Huni Printing 디자인 시스템 (DESIGN.md)

> 본 문서는 후니프린팅 자동견적 사이트의 **단일 디자인 소스(Single Source of Truth)** 입니다.
> 토큰 값은 Figma REST API(`gEJhQRtmKI66BPhOpqoW3j`)로 검증된 픽셀 단위 실측치이며,
> 2026-03-05 Gap Analysis에서 보정된 최종값(`primary #553886`, `primary-dark #3B2573`)을 사용합니다.
> 상품 섹션(11종) 디테일은 본 문서 범위에서 제외하고, 토큰·컴포넌트·규칙에 집중합니다.

---

## 1. Overview — 후니 디자인 컨셉

후니프린팅의 디자인은 **보라(Purple) 브랜드 컬러를 중심으로 한 절제된 인쇄 주문 UI**입니다. 핵심은 "선택의 명확성"입니다. 사용자는 사이즈·종이·수량·후가공 등 수십 개의 옵션을 빠르게 탐색·선택해야 하므로, 모든 선택 컴포넌트는 **흰 배경 + 보라 테두리**로 선택 상태를 표현하여(채워진 배경 금지) 시각적 소음을 최소화하고 어떤 항목이 선택되었는지 한눈에 구분되게 합니다. 타이포는 Noto Sans 단일 패밀리에 `-5%` 자간을 일관 적용하여 한글 가독성과 단정함을 동시에 확보하며, 모든 조작 컴포넌트는 50px 고정 높이와 4px(컴포넌트)/5px(CTA) 라운드로 통일된 리듬을 만듭니다. 옵션 라벨·값은 절대 하드코딩하지 않고 DB/API에서 동적으로 주입되어, 11개 상품군의 서로 다른 옵션 구조를 동일한 컴포넌트 세트로 렌더링합니다.

---

## 2. Colors — 팔레트

### 2.1 Purple Family (Primary Brand)

| Token | Hex | 용도 |
|-------|-----|------|
| `primary` | `#553886` | 선택 상태 테두리, CTA 버튼, 가격 금액, 활성 탭, 활성 입력 테두리 |
| `primary-dark` | `#3B2573` | 다크 CTA, 장바구니 버튼 배경 |
| `primary-secondary` | `#9580D9` | Hover 상태, 보조 액센트 |
| `primary-light-1` | `#C9C2DF` | 옅은 보라 배경 |
| `primary-light-2` | `#DED7F4` | 매우 옅은 보라, 틴트 |
| `primary-light-3` | `#EEEBF9` | Hover 배경 오버레이 |

### 2.2 Neutral / Gray Family

| Token | Hex | 용도 |
|-------|-----|------|
| `text-dark` | `#1E1E1E` | 합계금액 라벨 등 강조 텍스트 |
| `text-label` | `#424242` | 섹션 라벨, 기본 본문 텍스트 |
| `text-body` | `#616161` | Summary 항목 설명 |
| `text-medium` | `#565656` | 본문 텍스트(보조) |
| `text-muted` | `#979797` | 미선택 버튼 텍스트, placeholder, 캐럿 |
| `border-default` | `#CACACA` | 기본 테두리, 미체크 상태 |
| `divider` | `#E8E8E8` | 구분선 |
| `bg-light` | `#E9E9E9` | 옅은 배경, disabled 입력 테두리 |
| `bg-section` | `#F5F5F5` | FinishTitleBar 배경, 섹션 배경, hover |
| `bg-white` | `#FFFFFF` | 카드 배경, 버튼 채움 |

### 2.3 Accent Colors

| Token | Hex | 용도 |
|-------|-----|------|
| `accent-gold` | `#E6B93F` | 골드 배지(`badge-gold`), 하이라이트 액센트 |
| `accent-teal` | `#7AC8C4` | 틸 액센트(`badge-teal`, 보조 CTA) |
| `badge-recommend` | `#FF66CC` | "추천" 배지 배경(`badge-recommend`) |
| `badge-best` | `#3B2573` | "BEST" 배지 배경(`badge-best`) |
| `badge-new` | `#FF1493` | "NEW" 배지 배경(`badge-new`) |
| `badge-up` | `#00BCD4` | "UP" 배지 배경(`badge-up`) |

> **Orphan 토큰 해소**: `primary-secondary`/`primary-light-1~3`는 hover·tint 표면 컴포넌트(`surface-hover`/`surface-tint-1`/`surface-tint-2`)에서, `divider`는 `divider` 컴포넌트에서, `accent-gold`/`accent-teal`/`badge-best`/`badge-new`/`badge-up`은 각 배지 컴포넌트(`badge-gold`/`badge-teal`/`badge-best`/`badge-new`/`badge-up`)에서, `text-medium`은 `text-field` 기본 텍스트 색으로 참조하여 팔레트 토큰이 컴포넌트에 매핑됩니다.

### 2.4 [중요] 텍스트 색상 대비 규칙 (WCAG)

design.md 린트는 contrast-ratio를 검사하므로 텍스트/배경 조합을 명확히 고정합니다.

- **본문/콘텐츠 텍스트 허용 색상**: `#424242`(text-label), `#553886`(primary), `#979797`(text-muted), `#000000`
- **`#FFFFFF`(흰색) 텍스트는 반드시 컬러 배경 위에서만** 사용 (예: CTA 버튼, 배지)
- **`#F5F5F5` 텍스트는 컬러 배경 필수** (단독 사용 금지)
- **콘텐츠 텍스트에 컬러 폰트(`#FF00FF` 등) 사용 금지** — 색상은 배지·아이콘 등 비콘텐츠 요소에 한함
- `badge-highlight #EE00CE`/`#FF66CC` 등 형광 핑크는 **디자인 주석/배지 마커 전용**이며 본문 텍스트로 쓰지 않음

대비 비교 권장 조합:
- `#424242` on `#FFFFFF` → 본문 (충분)
- `#553886` on `#FFFFFF` → 선택 텍스트·가격 (충분)
- `#979797` on `#FFFFFF` → 미선택/보조 (placeholder 수준 — 핵심 정보에는 `#424242` 사용)
- `#FFFFFF` on `#553886` / `#3B2573` → CTA (충분)

#### 알려진 WCAG 대비 예외 (의도된 디자인, 토큰 값 변경 불가)

design.md 린트가 아래 7건을 WCAG AA(4.5:1) 미만으로 보고하나, 모두 **Figma 검증 브랜드 고정값**이며 변경하지 않습니다(중요 콘텐츠 텍스트 아님).

| 컴포넌트 | 조합 | 비율 | 사유 |
|---------|------|------|------|
| `option-button` / `finish-button` | `#979797` on `#FFFFFF` | 2.92:1 | **미선택(placeholder 수준) 상태** 전용. 선택 시 `#553886`(충분)로 전환 — 핵심 정보는 미선택 텍스트에 의존하지 않음 |
| `badge-recommend` | 흰색 on `#FF66CC` | 2.62:1 | 추천 배지(장식성 마커, 32×14px). 브랜드 형광 핑크 고정 |
| `badge-new` | 흰색 on `#FF1493` | 3.64:1 | NEW 배지(장식성 마커). 브랜드 고정 |
| `badge-up` | 흰색 on `#00BCD4` | 2.30:1 | UP 배지(장식성 마커). 브랜드 고정 |
| `badge-gold` | 흰색 on `#E6B93F` | 1.85:1 | 골드 배지(장식성 마커). 브랜드 고정 |
| `badge-teal` | 흰색 on `#7AC8C4` | 1.93:1 | 틸 배지(장식성 마커). 브랜드 고정 |

> 배지는 **아이콘성 장식 마커**(콘텐츠 텍스트 아님)이므로 WCAG 1.4.3 본문 대비 규정의 직접 대상이 아닙니다. 미선택 버튼 텍스트는 **상태 표시용 보조 텍스트**이며, 실제 정보 전달은 선택 시 `#553886`(대비 충분)로 이루어집니다. 실무진이 AA 엄격 적용을 원할 경우 배지 텍스트를 진한 색(`#1E1E1E`)으로 전환하는 옵션이 있으나, 현 브랜드 합의값은 흰색입니다.

---

## 3. Typography — 타이포그래피

**Font Family:** Noto Sans **ONLY** — Regular(400) / Medium(500) / SemiBold(600)
**Letter Spacing:** `-5%` 범용 적용 (`letterSpacing = fontSize × -0.05`)

| 역할 | Size | Weight | Letter Spacing | 기본 색상 |
|------|------|--------|----------------|-----------|
| Heading H1 | 36px | 600 | -1.8px | `#424242` 또는 `#553886` |
| Heading H2 | 24px | 600 | -1.2px | `#424242` 또는 `#553886` |
| Body SemiBold | 16px | 600 | -0.8px | `#424242` 또는 `#553886` |
| Section Label | 16px | 500 | -0.8px | `#424242` |
| Body Medium | 14px | 500 | -0.7px | `#424242` 또는 `#553886` |
| Body Regular | 14px | 400 | -0.7px | `#424242` 또는 `#979797` |
| Caption | 12px | 400 | -0.6px | `#616161` |
| Help Text | 11px | 400 | -0.55px | `#979797` |
| Total Amount | 24px | 600 | -1.2px | `#553886` |
| Button / UI | 14px | 600 | -0.7px | `#FFFFFF` (컬러 배경 위) |

> **[CRITICAL]** 폰트는 반드시 Noto Sans (`font-[Noto_Sans]` 또는 CSS variable `--font-noto-sans`). Lucide 등 외부 아이콘 폰트로 캐럿(▼) 대체 금지 — 캐럿은 텍스트 문자.

---

## 4. Layout — 레이아웃

### 4.1 4-Zone 옵션 패널 구조

상품 옵션 페이지(option_New)는 4개 기능 존으로 구성됩니다.

| Zone | 명칭 | 주요 컴포넌트 |
|------|------|--------------|
| Zone 1 | 옵션 선택 (사이즈 + 종이) | OptionButton(155×50, 3-column), SelectBox(348×50), 추천 배지(32×14) |
| Zone 2 | 수량 + 후가공 헤더 (제작수량 + 후가공) | CounterInput(223×50), FinishTitleBar(466×50, 열기/닫기 토글) |
| Zone 3 | 후가공 옵션 (귀돌이 + 박크기 + 박칼라) | FinishButton(116×50), AreaInput(140×50, X 구분자), ColorChip(50×50) |
| Zone 4 | 부자재 선택 + 합계 + 업로드 | FinishSelect(461×50), Summary(가격 요약), Upload 3종(465×50) |

### 4.2 섹션 패딩 & 그리드

| 속성 | 값 |
|------|-----|
| 섹션 좌우 패딩 (section-x) | 20px |
| 버튼 그리드 컬럼 | 3 columns |
| 버튼 그리드 gap | 0px (테두리 인접 — border-adjacency) |
| 컴포넌트 기본 높이 | 50px (조작 컴포넌트 공통) |
| 섹션 라벨 높이 | 40px |
| 구분선 높이 | 1px |
| 입력 필드 좌패딩 | 16px (SelectBox) / 12px (TextField) |

### 4.3 상품 페이지 공통 구조

```
Header: HuniPrinting 로고 + 네비게이션
─────────────────────────────────────────
상품 이미지 (좌)         │  옵션 패널 (우)
  + 썸네일 row           │  ├── 사이즈 (OptionButton 3-col, 선택=흰배경+보라테두리)
                         │  ├── 종이/지질 (HuniCustomSelect 드롭다운)
                         │  ├── 인쇄방식/도수 (OptionButton / RadioGroup)
                         │  ├── 코팅/귀돌이/커팅 (FinishButton)
                         │  ├── 제작수량 (CounterInput 3-part)
                         │  ├── [접기] 후가공 (FinishTitleBar collapse)
                         │  │    ├── 추가옵션 (OptionButton / ColorChip)
                         │  │    └── 박/색상 (ColorChip 50×50 원형)
                         │  ├── 부자재 (FinishSelect 461×50)
                         │  ├── 가격 요약 (Summary)
                         │  ├── 합계금액 (24px/600 #553886)
                         │  └── CTA 3종 (PDF업로드 / 디자인주문 / 장바구니, 465×50)
```

---

## 5. Elevation & Depth — 그림자 / 레이어

후니 디자인은 **플랫(flat) 지향**으로, 표면 그림자를 최소화하고 테두리·면 분할로 깊이를 표현합니다.

| 요소 | 깊이 표현 | 비고 |
|------|----------|------|
| 카드/버튼 표면 | 그림자 없음 (테두리만) | `border 1px #CACACA` |
| 드롭다운 펼침 목록 | `shadow-lg` (overlay) | `z-50`, `border 1px #CACACA`, `bg-white`, `rounded-b-[4px]` |
| 선택 상태 강조 | 테두리 굵기 1px→2px + 색 변경 | 그림자가 아닌 테두리로 강조 |
| 활성 탭 | 하단 인디케이터 라인 2px | 그림자 없음 |

> Figma 스펙에 명시된 elevation은 **드롭다운 오버레이의 `shadow-lg`** 1종뿐입니다. 그 외 명시값은 TBD-실무진확인.

---

## 6. Shapes — 형태 / 라운드

| 요소 | 값 | 적용 |
|------|-----|------|
| 컴포넌트 radius (sm) | `4px` | OptionButton, CounterInput, SelectBox, FinishButton, FinishSelect, AreaInput, ColorChip(사각형 모드) |
| CTA radius (cta) | `5px` | OrderCTA 버튼 3종 (Upload/Design/Cart) |
| Checkbox radius | `3px` | Check box (20×20px) |
| 원형 (full) | `9999px` | ColorChip(50×50), MiniColorChip(32×32), ImageChip(50×50), Radio(20×20), Slider thumb(16×16) |

특수 형태:
- **ColorChip**: 50×50px **원형(ellipse)**. 선택 시 흰 채움 + `#553886` ring 2px
- **MiniColorChip**: 32×32px 원형 (48px와 혼동 금지)
- **ImageChip**: 50×50px 원형 (ImageOptionSelector는 64×64px 별도)
- **Slider Thumb**: 16×16px 원형, `#553886` 테두리 2px, 흰 채움
- **Slider Track**: 높이 4px, radius 2px

---

## 7. Components — 14 componentType

각 컴포넌트의 용도·치수·상태. (RULE 표기는 8장 Do's & Don'ts 참조)

### 7.0 [중요] 테두리·선택상태(ring)·placeholder 사양 표

> design.md YAML 컴포넌트 sub-token은 `backgroundColor`/`textColor`/`typography`/`rounded`/`padding`/`size`/`height`/`width` 만 허용하므로, **테두리(border) 색·굵기, 선택상태 ring, placeholder 색, 캐럿/인디케이터/그리드**는 YAML에서 표현 불가합니다. 아래 표가 그 사양의 **단일 출처**이며 구현 시 반드시 따릅니다. (Huni 핵심: **선택상태 = 흰 배경 + 보라(`#553886`) 테두리 2px**)

| 컴포넌트 | 기본 테두리 | 선택/활성 상태 | placeholder / 기타 |
|---------|-----------|---------------|-------------------|
| option-button | `1px #CACACA` | **흰 배경 + `2px #553886` 테두리** + 텍스트 `#553886` | disabled: 배경 `#F5F5F5`, 텍스트 `#CACACA`, 테두리 `1px #CACACA` |
| select-box | `1px #CACACA` | open: **테두리 `1px #553886`** | 캐럿 `▼` `#979797` 12px (텍스트 문자) / 옵션 hover 배경 `#F5F5F5` |
| counter-input | `1px #CACACA` | — | 내부 divider `1px #CACACA` (x=34, x=189) |
| color-chip | 없음(칩색 채움) | **흰 채움 + `#553886` ring 2px** | — |
| price-slider-thumb | **`2px #553886` 테두리** + 흰 채움 | active track `#553886` / inactive `#CACACA` | track radius 2px / 틱 최대 6개 |
| image-chip | 없음 | **`#553886` ring 2px** | placeholder 배경 `#F5F5F5`, 라벨 11px `#424242` |
| mini-color-chip | 없음(칩색 채움) | **`#553886` ring 2px** | 정확히 32×32px |
| large-color-chip | 없음(칩색 채움) | **`#553886` ring 2px** | `grid-cols-5` 레이아웃, 색상명 라벨 하단 |
| area-input | `1px #CACACA` | — | placeholder `#CACACA` 14px / `X` 구분자 `#424242` / help 11px `#979797` |
| page-counter-input | `1px #CACACA` | **`#553886` ring 2px** | hover `bg-gray-100` |
| finish-button | `1px #CACACA` | **흰 배경 + `2px #553886` 테두리** + 텍스트 `#553886` 600 | — |
| finish-select-box | `1px #CACACA` | open: **테두리 `#553886`** | 캐럿 `▼` `#979797` 12px |
| upload-button (outline) | **`1px #553886` 테두리** | — | 텍스트 `#424242` |
| upload-button-design (filled) | 테두리 = 배경색 `#553886` | — | 텍스트 흰색 |
| upload-button-cart (dark) | 테두리 = 배경색 `#3B2573` | — | 텍스트 흰색 |
| checkbox | **`2px #CACACA`** | checked: 배경·테두리 `#553886` 2px | radius 3px |
| radio-button | **`2px #CACACA`** | selected: 배경·테두리 `#553886` 2px | 원형 |
| tab | 없음 | active: 텍스트 `#553886` 600 + **하단 인디케이터 라인 `2px #553886`** | — |
| text-field | `1px #CACACA` | active: **테두리 `2px #553886`** | disabled 테두리 `1px #E9E9E9` / placeholder `#CACACA` |

> YAML의 `*-caret`(select-box-caret, finish-select-box-caret)는 캐럿 문자 `▼`를 의미하며 `content` sub-token 대신 본 표에 명시했습니다. `*-separator`(area-input-separator)의 `X` 문자, `surface-*`/`badge-*`/`divider`/`tab-active-indicator` 컴포넌트는 orphan 토큰(primary-secondary, primary-light-1~3, accent-gold/teal, badge-best/new/up, divider) 참조용으로 추가된 표면 정의입니다.

### 7.1 ButtonType — `OptionButton.tsx` (RULE-2)
- **용도**: 선택형 옵션 버튼 그리드 (예: 사이즈)
- **치수**: 155×50px, radius 4px, 3-column 그리드 0px gap
- **상태**:
  - Default: 흰 배경, 테두리 `#CACACA` 1px, 텍스트 `#979797` 14px/400
  - Selected: 흰 배경, 테두리 `#553886` **2px**, 텍스트 `#553886`
  - Disabled: 배경 `#F5F5F5`, 텍스트 `#CACACA`

### 7.2 SelectBoxType — `HuniCustomSelect`/`PaperDropdown.tsx` (RULE-1)
- **용도**: 종이/지질 선택 드롭다운
- **치수**: 348×50px, radius 4px, 좌패딩 16px
- **상태**:
  - Closed: 흰 배경, 테두리 `#CACACA` 1px
  - Open: 테두리 `#553886`, 하단 목록 오버레이(`shadow-lg`, `z-50`)
  - Option hover: 배경 `#F5F5F5`
- **캐럿**: `▼` 텍스트 문자, `#979797`, 우측 정렬 (Lucide 아이콘 금지)
- **부가**: 추천 배지 32×14px (`#FF66CC`, 흰 텍스트)

### 7.3 CounterInputType — `CounterInput.tsx` (RULE-3)
- **용도**: 제작수량 스테퍼
- **치수**: 전체 223×50px = `[34px −] [155px 값] [34px +]`, divider 1px `#CACACA` (x=34, x=189)
- **상태**: −/+ 버튼 18px/400 `#424242`, 값 14px/500 `#979797`, hover 시 버튼 배경 `#F5F5F5`
- **금지**: 원형 버튼·native number input 금지 (직사각형 3-part만)

### 7.4 ColorChipType — `ColorChip.tsx` (RULE-4)
- **용도**: 박/포일 색상 칩 선택
- **치수**: 50×50px **원형**
- **상태**:
  - Default: 칩 색상 채움, 테두리 없음
  - Selected: 흰 채움 + `#553886` ring 2px
- **색상 매핑(박 종류)**: 금유광 `#D4AF37`, 은유광 `#C0C0C0`, 적박 `#CC1523`, 청박 `#0099CC`, 먹유광 `#1A1A1A`, 홀로그램박 `#E8E8E8`, 트윙클박 `#CC66BB`, 동박 `#B87333`
- **확장 모드**: `color-swatch`(기본) / `image-thumbnail` / `color-with-label`, 그룹·다중선택 지원

### 7.5 PriceSliderType — `PriceSlider.tsx` (RULE-5-EXT)
- **용도**: 수량 구간 가격 슬라이더
- **치수**: Track 높이 4px(radius 2px), Thumb 16×16px 원형(테두리 `#553886` 2px), 라벨 11px `#979797`
- **상태**: Active track `#553886`, Inactive track `#CACACA`, 틱 최대 6개 (1/10/50/100/500/1000)
- **필수**: `@radix-ui/react-slider` 사용, `native input[type=range]` 금지

### 7.6 ImageChipType — `ImageChipType.tsx` (RULE-6-EXT)
- **용도**: 원형 이미지 옵션 칩 (예: 링/재질 이미지)
- **치수**: 50×50px 원형
- **상태**: Selected `ring-2 ring-[#553886]`, 이미지 없으면 placeholder `#F5F5F5`, 라벨 11px `#424242` 하단

### 7.7 MiniColorChipType — `MiniColorChip.tsx` (RULE-7-EXT)
- **용도**: ColorChip보다 작은 32×32px 색상 칩
- **치수**: 32×32px 원형 (48px/`w-12 h-12` 혼동 금지)
- **상태**: Selected `ring-2 ring-[#553886]`, 배경 = colorHex

### 7.8 LargeColorChipType — `LargeColorChip.tsx` (RULE-8-EXT)
- **용도**: 다수 색상을 그리드로 표시
- **치수**: 50×50px 원형(또는 radius 4px), `grid-cols-5`
- **상태**: Selected `ring-2 ring-[#553886]`, 색상명 라벨 하단
- **데이터**: 색상 상한 없음 — DB에서 동적 로드

### 7.9 AreaInputType — `FinishInput.tsx`/`HuniAreaOptions.tsx`
- **용도**: 가로×세로 mm 직접 입력 (예: 박 크기)
- **치수**: 입력 필드 각 140×50px, radius 4px, `X` 구분자(`#424242`)
- **상태**: Placeholder `#CACACA` 14px, Help text 11px `#979797` (예: "가로 30~125mm / 세로 30~170mm")

### 7.10 PageCounterInputType — `PageCounterInput.tsx`
- **용도**: 책자류 내지 페이지 수 선택 (`< 1 2 3 >` 페이지네이션 또는 stepper)
- **치수**: 높이 50px, radius 4px
- **상태**: Selected `ring-2 ring-[#553886]`, hover `bg-gray-100`
- **데이터**: min/max/step 동적 (예: min 8, max 500, step 4)

### 7.11 FinishButtonType — `FinishButton.tsx` (RULE-2)
- **용도**: 후가공 선택 버튼 (예: 귀돌이 → 둥근모서리/직각모서리)
- **치수**: 116×50px, radius 4px
- **상태**:
  - Default: 흰 배경, 테두리 `#CACACA` 1px, 텍스트 `#979797` 12px/400
  - Selected: 흰 배경, 테두리 `#553886` **2px**, 텍스트 `#553886` 12px/**600**

### 7.12 FinishSelectBoxType — `FinishSelect.tsx` (RULE-1)
- **용도**: 부자재/봉투 선택 드롭다운 (예: 엽서봉투)
- **치수**: 461×50px, radius 4px
- **상태**: SelectBoxType과 동일 규칙 (custom div 드롭다운, `▼` 텍스트 캐럿)
- **필수**: native `<select>` 금지

### 7.13 SummaryType — `PriceResult.tsx`
- **용도**: 가격 분해 및 합계 표시
- **구조**: 항목 설명(좌, 12px `#616161`) + 금액(우, 12px `#424242`), 합계 전 divider
- **합계금액**: 라벨 16px/600 `#1E1E1E` + 금액 24px/600 `#553886`
- **부가 노트**: "상품가 / 부가세" 12px `#424242`

### 7.14 UploadType — `OrderCTA.tsx`
- **용도**: PDF 업로드 / 디자인 에디터 / 장바구니 CTA
- **치수**: 각 465×50px, radius **5px**, 세로 스택
- **상태/변형**:
  - PDF 업로드(outline): 흰 배경, 테두리 `#553886` 1px, 텍스트 `#424242`
  - 디자인 에디터(filled): 배경 `#553886`, 텍스트 흰색
  - 장바구니(dark): 배경 `#3B2573`, 텍스트 흰색
- 텍스트 공통: Noto Sans 14px/600 중앙 정렬

> **보조 컴포넌트** (Component 페이지): Text Button(252×48/160×36), Check box(20×20, radius 3px), Radio(20×20 원형), Tab(활성 `#553886` Bold + 하단 라인 2px), Text field(높이 44px, active 테두리 2px `#553886`), FinishTitleBar(466×50 `#F5F5F5` 배경 + 열기/닫기 토글), BadgeLabel(추천/BEST/NEW/UP), CalloutPopover(정보 아이콘 + 팝업).

---

## 8. Do's and Don'ts — Critical Rules

후니 디자인의 8개 핵심 규칙을 준수/위반 형태로 정리합니다.

### RULE-1 — SelectBox: native `<select>` 금지
- **DO** ✅: custom div 기반 드롭다운(`HuniCustomSelect`) 사용, 캐럿은 `▼` 텍스트 문자 오버레이, 외부 클릭 감지 + 키보드 접근성(Escape/Enter/Space)
- **DON'T** ❌: `<select><option>...</option></select>` 사용 — 크로스브라우저 스타일 불가, Figma 스펙 위반
- 적용: SelectBoxType, FinishSelectBoxType

### RULE-2 — 선택 상태 = 흰 배경 + 보라 테두리
- **DO** ✅: 선택 시 `bg-white border-2 border-[#553886] text-[#553886]`
- **DON'T** ❌: 선택 시 컬러 배경 채움 `bg-[#553886] text-white` 또는 `#EEE8FF` 채움
- 기본: `bg-white border border-[#CACACA] text-[#979797]`
- 적용: OptionButton, FinishButton

### RULE-3 — CounterInput: 직사각형 3-part
- **DO** ✅: `[34px −] [155px 값] [34px +]` = 223×50px, divider 1px `#CACACA`
- **DON'T** ❌: 원형 버튼(`rounded-full`)·native number input·증감 화살표 스피너
- 적용: CounterInputType

### RULE-4 — Color Chip: 50×50 원형
- **DO** ✅: 50×50px ellipse, 선택 시 흰 채움 + `#553886` ring 2px
- **DON'T** ❌: 32×32 등 다른 크기로 ColorChip 렌더 (32px는 MiniColorChip 별도)
- 적용: ColorChipType

### RULE-5 — 옵션 라벨 하드코딩 금지 (동적 데이터)
- **DO** ✅: 모든 옵션 라벨/값/구조를 DB/API에서 동적 로드 후 `.map()` 렌더
  - 데이터 우선순위: Option Schema API → Zustand store → props → (JSX 하드코딩 절대 금지)
- **DON'T** ❌: `<OptionButton>무광코팅(단면)</OptionButton>` 같이 한국어 옵션 라벨을 JSX에 직접 작성
- 적용: 모든 옵션 렌더 컴포넌트

### RULE-5-EXT — PriceSlider: Radix 필수
- **DO** ✅: `@radix-ui/react-slider`(Root/Track/Range/Thumb) 사용
- **DON'T** ❌: `native input[type=range]` 사용
- 스펙: Track 4px, Thumb 16×16 원형 테두리 2px `#553886`, 틱 최대 6개

### RULE-6-EXT — ImageChip: 50×50 원형
- **DO** ✅: 50×50px 원형, 선택 `ring-2 ring-[#553886]`, 로드 실패 시 placeholder
- **DON'T** ❌: 사각 큰 썸네일로 렌더 (단 ImageOptionSelector 64×64는 별도 규격)

### RULE-7-EXT — MiniColorChip: 32×32 원형
- **DO** ✅: 정확히 `w-8 h-8`(32px) 원형, 선택 `ring-2 ring-[#553886]`
- **DON'T** ❌: `w-12 h-12`(48px)와 혼동

### RULE-8-EXT — LargeColorChip: grid 레이아웃
- **DO** ✅: `grid-cols-5` 50×50px 칩, 색상명 라벨 하단, DB에서 색상 동적 로드(상한 없음)
- **DON'T** ❌: 색상 개수를 코드에 하드코딩하거나 1행 고정

### 공통 — 타이포 / 색상
- **DO** ✅: Noto Sans only, 자간 `-5%`, 본문 텍스트 색상은 `#424242`/`#553886`/`#979797`/`#000000`
- **DON'T** ❌: 다른 폰트 패밀리, 컬러 폰트(`#FF00FF` 등) 콘텐츠 텍스트 사용, 흰 텍스트를 컬러 배경 없이 사용

---

## 부록 A — CTA Matrix (11 섹션 × 4 버튼)

| 섹션 | PDF업로드 | 디자인주문 | 장바구니 | 견적문의 |
|------|---------|---------|--------|--------|
| 디지털인쇄 | O | O | O | X |
| 책자 | O | O | O | X |
| 스티커 | O | O | O | X |
| 포토북 | O | O | O | X |
| 캘린더 | O | O | O | X |
| 디자인캘린더 | X | O | O | X |
| 악세사리 | O | O | O | X |
| 아크릴 | O | O | O | 일부O |
| 실사/사인 | O | O | O | X |
| 문구 | O | O | O | X |
| 굿즈/파우치 | X | X | X | O |

---

## 부록 B — TBD / 실무진 확인 필요 항목

| 항목 | 현황 | 필요 조치 |
|------|------|----------|
| Elevation 토큰 | 드롭다운 `shadow-lg`만 명시, 그 외 그림자 정의 없음 | 카드/모달 elevation 스케일 정의 여부 결정 |
| Concept 페이지 | 미추출 (지시에 따라 미반영) | 필요 시 Figma Concept 페이지 추출 후 별도 반영 |
| `accent-gold`/`accent-teal` 구체 적용처 | SKILL.md에 "골드 배지/틸 보조 CTA"로만 기재, 실제 컴포넌트 미매핑 | 실제 사용 컴포넌트 확정 |
| 반응형(모바일) 브레이크포인트 | SKILL.md에 명시 없음 (옵션 패널 데스크톱 기준 px 고정) | 모바일 레이아웃 규격 별도 정의 필요 |
| Hover 상태 색상 체계 | `primary-secondary #9580D9`/`primary-light-3 #EEEBF9`로 언급되나 컴포넌트별 hover 토큰 미정 | 컴포넌트별 hover 토큰 표준화 |
| `text-medium #565656` | SKILL.md 토큰 표에 존재하나 tailwind-tokens에는 `#616161`(text-body) 사용 | 본문 보조 텍스트 단일화 확인 |
