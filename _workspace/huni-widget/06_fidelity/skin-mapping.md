# skin-mapping.md — 위젯 componentType ↔ 후니 디자인 컴포넌트 매핑

> 진실 소스: `_workspace/print-quote/04_design/DESIGN.md`(토큰 + §7 14컴포넌트 + §8 8 Critical Rules) + huni-design-system 스킬.
> 구현 소스: `04_build/src/widget/components/controls/` + `components/`.
> 매핑 단위 = {위젯 componentType, 구현 파일, 후니 컴포넌트(DESIGN §7), 핵심 외형 토큰}.

## 토큰 기준선 (단일 출처: index.css `:host` + tailwind.config.js)

| 토큰 | 값 | 위젯 반영 |
|------|-----|-----------|
| primary | #553886 | O (`:host --primary`, hex 직기재 일치) |
| primary-dark | #3B2573 | O |
| text-label | #424242 | O |
| text-body | #616161 | O |
| text-muted | #979797 | O |
| text-dark | #1E1E1E | △ (PriceSummary 합계 라벨에만 필요 — 본 패스 정합) |
| border-default | #CACACA | O |
| bg-section | #F5F5F5 | O |
| font-family | Noto Sans KR/Noto Sans | O (`:host` 상속, 컨트롤 미지정=정상) |
| letter-spacing | -0.05em | O (`:host` 전역 상속) |
| font-size 기준 | 16px 고정 | O (rem 상속 함정 대응) |

## 컴포넌트 매핑

| # | 위젯 componentType | 구현 파일 | 후니 컴포넌트(DESIGN §7) | 핵심 외형 토큰 | 정합 |
|---|--------------------|-----------|--------------------------|----------------|------|
| 1 | option-button | OptionButton.tsx | §7.1 ButtonType (RULE-2) | 155×50, r4, 기본 `border #CACACA / text #979797`, 선택 `border-2 #553886 / text #553886`, disabled `bg #F5F5F5 / text #CACACA` | O |
| 11 | finish-button | OptionButton.tsx(width=116) | §7.11 FinishButtonType (RULE-2) | 116×50, 동일 RULE-2 | O (caption-semibold 폰트 weight는 §7.11 "12px/600" — 위젯은 14px/600 공용, 회색지대 → conflicts) |
| 2 | select-box | HuniSelect.tsx | §7.2 SelectBoxType (RULE-1) | 348×50, r4, px16, closed `border #CACACA`, open `border #553886`, 캐럿 `▼ #979797 12px`, 옵션 hover `bg #F5F5F5` | O |
| 12 | finish-select-box | HuniSelect.tsx(width=461) | §7.12 FinishSelectBoxType (RULE-1) | 461×50, 동일 | O |
| 3 | counter-input | CounterInput.tsx | §7.3 CounterInputType (RULE-3) | 223×50 `[34−][155값][34+]`, divider 1px #CACACA, −/+ 18px #424242, 값 14px/500 **#979797** | O (본 패스 값 색 정합) |
| 10 | page-counter-input | CounterInput.tsx(variant=page) | §7.10 PageCounterInputType | 50h, r4, 선택 `border-2 #553886` ring 강조 | O |
| 4 | color-chip | ColorChip.tsx(size=50) | §7.4 ColorChipType (RULE-4) | 50×50 원형, 칩색 채움, 선택 `ring-2 #553886` | O (ring-offset-2 회색지대 → conflicts) |
| 7 | mini-color-chip | ColorChip.tsx(size=32) | §7.7 MiniColorChipType | 32×32 원형, 선택 ring-2 | O |
| 8 | large-color-chip | ColorChip.tsx(grid) | §7.8 LargeColorChipType | grid-cols-5, 50×50, 라벨 하단 11px | O (라벨색 #979797 vs §7.8 image-chip-label #424242 — large는 미명시, 회색지대) |
| 6 | image-chip | ImageChip.tsx | §7.6 ImageChipType (RULE-6-EXT) | 50×50 원형, 선택 ring-2, placeholder `bg #F5F5F5`, 라벨 11px | O (라벨 #979797 vs §7.6 #424242 — 편차 후보, conflicts) |
| 5 | price-slider | PriceSlider.tsx | §7.5 PriceSliderType (RULE-5-EXT) | Radix, track 4px #CACACA, range #553886, thumb 16×16 원형 `border-2 #553886` 흰채움, 틱 ≤6 11px #979797 | O |
| 9 | area-input | AreaInput.tsx | §7.9 AreaInputType | 각 140×50, r? (테두리 #CACACA), placeholder #CACACA, X 구분자 #424242, help 11px #979797 | O |
| NC | dimension-matrix-input | DimensionMatrixInput.tsx | (NC-1 합성: §7.1 칩 + §7.9 입력) | 프리셋 칩 RULE-2 + 자유입력 AreaInput 토큰 동일 | O |
| 13 | summary | PriceSummary.tsx | §7.13 SummaryType | 항목 12px #616161 + 금액 #424242, 합계 라벨 **16px/600 #1E1E1E** + 금액 24px/600 #553886 | O (본 패스 합계 라벨 정합) |
| 14 | upload-cta | OrderCTA.tsx | §7.14 UploadType | 465×50 **r5**, outline `border #553886 / text #553886`, dark(cart) `bg #3B2573 / text white` | O (견적=outline, 장바구니=dark. PDF/디자인 filled는 SideInput/PdfUploader로 분리됨) |

## 패널·라벨 토큰

| 요소 | 위젯 | DESIGN 기준 | 정합 |
|------|------|-------------|------|
| 옵션 그룹 라벨 | `16px/500 #424242` | section-label(16/500 #424242) | O |
| side 헤더(h2) | `16px/600 #424242` | body-semibold | O |
| SideInput 편집버튼 | 50h, 완료=`border-2 #553886`, 기본=`border #CACACA` | RULE-2 준용 | O |
| 로딩/캔낫오더 안내 | 11px/12px #979797 | help-text/caption | O |

> radius 주의: DESIGN §6은 컴포넌트 r4(sm) / CTA r5. 위젯 컨트롤 다수가 명시 radius 없이 Tailwind preflight(`rounded-none`) 상태일 수 있음 — 시각 미검증(claude-in-chrome 미노출). 다음 라운드 브라우저 확보 시 r4 적용 여부 실측 필요(conflicts.md GAP-RADIUS).
