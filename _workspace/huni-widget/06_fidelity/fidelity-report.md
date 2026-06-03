# fidelity-report.md — 후니 시각재현 정합 (1차 정적 + 2차 시각검증)

> 에이전트: hw-design-fidelity · 렌더 대상: `04_build` React-in-Shadow-DOM 위젯(productCode PRBKYPR, 책자 표지+내지 2 side)
> 권위 분리: 배치·캐스케이드·상태전이=Red 구조(보존) / 색·폰트·간격·radius·외형=후니 스킨(정합)

## 0. 측정 방법 — 시각 검증 해소됨 (2차 패스, CONF-VIS-1 CLOSED)

- **1차(정적)**: claude-in-chrome 미노출로 소스 className·토큰 vs DESIGN.md 정적 대조로 7종 정합.
- **2차(시각 — 해소)**: gstack `browse` 헤드리스 브라우저(bun 1.3.14) 확보. dev 서버 http://localhost:5174/ 의 위젯을 실제 렌더하여 **Shadow root 관통 computed style 실측**(`document.getElementById('host').shadowRoot` → `getComputedStyle`) + BEFORE/AFTER 스크린샷 수집 완료.
- **검증 결과**: 1차 정적 판정 7종 전부 실측 computed style로 **확인됨(보정 0건)**. 추가로 2차에서 GAP-2(드롭다운 radius·그림자) 시각 발견·정합(8번째 항목).
- **BEFORE/AFTER 대조 방법**: `git stash push -- src/`로 정합분 되돌려 BEFORE 캡처·실측 → `git stash pop` 복원. BEFORE는 사각 컨트롤 radius **0**·합계 라벨 **14px/500 #424242**·counter 값 **#424242/400**, AFTER는 radius **4px**·**16px/600 #1E1E1E**·**#979797/500** 으로 명확 구분.
- captures/before·after 에 실제 스크린샷 저장(widget-full.png; after/dropdown-open.png).

### 2차 실측 computed style ↔ 후니 스펙 대조 (Shadow root 관통, 렌더 결정값)

| 컴포넌트(상태) | 속성 | 실측(렌더 computed) | 후니 스펙 | 판정 |
|----------------|------|---------------------|-----------|------|
| option-button(선택) | radius/border/typo | r **4px** / **2px #553886** / 14px/600 **#553886** | §7.1 RULE-2 선택 | 일치 ✓ |
| option-button(미선택) | color/border | **#979797** / 1px **#CACACA** | §7.1 기본 | 일치 ✓ (weight 600 → AMB-4) |
| select-box | radius/border/pad | r **4px** / 1px #CACACA / pad **16px** | §7.2 r4·#CACACA·px16 | 일치 ✓ |
| counter 값 | color/weight | **#979797** / **500** | §7.3 값 14px/500 #979797 | 일치 ✓ |
| counter 컨테이너 | radius | r **4px** | §6 sm 4px | 일치 ✓ |
| finish-button(선택,116) | radius/border/size | r4 / 2px #553886 / 116px | §7.11 RULE-2 | 일치(크기) ✓ |
| summary 합계 라벨 | typo/color | **16px / 600 / #1E1E1E** | §7.13 16px/600 text-dark | 일치 ✓ |
| summary 합계 금액 | typo/color | 24px/600 **#553886** | §7.13 total-amount | 일치 ✓ |
| summary lines 라벨(CUT_DFT) | color | **#616161** | §7.13 summary-item #616161 | 일치 ✓ |
| summary 부가세 고정행 | color/size | #424242 / 12px | (lines 아님, 별도 고정행) | AMB-2 → 유지 |
| CTA 견적담기 | radius/border/size | r **5px** / 1px #553886 outline / **465×50** | §7.14 outline | 일치 ✓ |
| 드롭다운(Popover) | radius/shadow | **r 4px(하단)** / box-shadow 적용 | §5 rounded-b-[4px] shadow-lg | 일치 ✓ (2차 정합) |
| 옵션 그룹 라벨 | typo/color | 16px/500 #424242 | section-label | 일치 ✓ |

> **letter-spacing 관찰(AMB-3)**: 전 요소 실측 letter-spacing이 `-0.8px`로 균일. `:host`의 `letter-spacing:-0.05em`이 em 기준이라 host 16px 기준 고정되어 DESIGN의 "fontSize×-0.05"(14px면 -0.7px) 비례와 미세 차이. 토큰(`-0.05em`)은 정합이나 비례 규칙과 차이 — conflicts.md AMB-3.

## 1. 베이스라인 요약

- 진입 상태: 컨트롤 14종 + 패널 고정(WidgetRoot/OptionPanel/PriceSummary/OrderCTA/PdfUploader)이 이미 DESIGN.md 토큰을 **대부분 정확히** 반영(hex 직기재가 토큰값과 일치, font/letter-spacing은 `:host` 상속).
- 토큰 단일 출처: `index.css :host` CSS 변수 + `tailwind.config.js` theme.extend — DESIGN §2와 일치.
- 베이스라인 typecheck 0 에러 / test 76 passed.

## 2. 컴포넌트별 BEFORE / AFTER (정적 토큰 대조)

| 컴포넌트 | 속성 | BEFORE(위젯 실측 className) | 후니 기준(DESIGN) | 판정 | AFTER |
|---------|------|------------------------------|--------------------|------|-------|
| PriceSummary 합계 라벨 | typography/색 | `14px / font-medium(500) / #424242` | §7.13 summary-label = body-semibold **16px/600** + text-dark **#1E1E1E** | 편차 → 정합 | `16px / font-semibold / #1E1E1E` |
| CounterInput 값 | 색/weight | `14px / (weight 미지정) / #424242` | §7.3 값 = body-medium **14px/500 #979797** | 편차 → 정합 | `14px / font-medium / #979797` |
| option-button | radius | rounded 유틸 없음(=r0) | §6 sm **4px** (RULE 컨트롤) | 편차 → 정합 | `rounded-[4px]` |
| finish-button | radius | r0 | §6 sm 4px | 편차 → 정합 | `rounded-[4px]`(width=116 공용) |
| select-box trigger | radius | r0 | §6 sm 4px | 편차 → 정합 | `rounded-[4px]` |
| finish-select trigger | radius | r0 | §6 sm 4px | 편차 → 정합 | `rounded-[4px]`(width=461 공용) |
| counter-input 컨테이너 | radius | r0 | §6 sm 4px | 편차 → 정합 | `rounded-[4px] overflow-hidden` |
| area-input(×2) | radius | r0 | §6 sm 4px | 편차 → 정합 | `rounded-[4px]` |
| dimension-matrix 프리셋칩·자유입력 | radius | r0 | §6 sm 4px | 편차 → 정합 | `rounded-[4px]` |
| SideInput 편집버튼 | radius | r0 | §6 sm 4px(50h 사각) | 편차 → 정합 | `rounded-[4px]` |
| PdfUploader 버튼 | radius | r0 | §6 sm 4px(면입력 버튼) | 편차 → 정합 | `rounded-[4px]` |
| OrderCTA 3종 | radius | `borderRadius:5`(인라인) | §7.14 CTA **5px** | 일치 | (무변경) |
| color/mini/large-chip | 외형 | 원형 + 선택 ring-2 #553886 | §7.4/7/8 RULE-4/7/8 | 일치 | (무변경, ring-offset 회색지대→conflicts) |
| image-chip | 외형/라벨 | 50×50 원형 ring-2, 라벨 11px #979797 | §7.6 placeholder #F5F5F5, 라벨 11px **#424242** | 라벨색 편차(보류) | conflicts GAP |
| price-slider | 외형 | track4px #CACACA, range #553886, thumb 16×16 border-2, 틱 #979797 | §7.5 동일 | 일치 | (무변경) |
| select-box 캐럿 | 문자/색 | `▼` 텍스트 #979797 12px | §7.2 ▼ 텍스트 #979797(아이콘폰트 금지) | 일치 | (무변경) |
| upload-cta 색 | bg/text | 견적=outline #553886, 장바구니=dark #3B2573/white | §7.14 | 일치 | (무변경) |

## 3. 정합 적용 항목(총 8종, 9파일)

**1차(정적, 7종):**
1. PriceSummary 합계 라벨 타이포·색 → `16px/600 #1E1E1E` — 2차 실측 확인 ✓
2. CounterInput 값 텍스트 → `font-medium #979797` — 2차 실측 확인 ✓
3~7. 사각 조작 컨트롤 radius `rounded-[4px]` 일괄(§6 sm 4px) — 2차 실측 r4 확인 ✓:
   - OptionButton(option/finish), HuniSelect trigger(select/finish-select), CounterInput 컨테이너(+overflow-hidden), AreaInput×2, DimensionMatrixInput(칩+자유입력×2), OptionPanel SideInput, PdfUploader

**2차(시각 발견, 1종):**
8. HuniSelect 드롭다운(Popover.Content) → `rounded-b-[4px]` + 명시 `boxShadow`(인라인). Tailwind `shadow-lg`가 Shadow DOM에서 `--tw-shadow` 변수 체인 단절로 무력화(실측 box-shadow 0)되던 것을 Tailwind shadow-lg 표준값으로 명시 주입. radius도 0→4px(하단). 2차 실측 재확인 ✓.

> 모두 className 토큰 + style.boxShadow(외형) 만. variant prop·store·핸들러·DOM·배치 무변경.

## 4. 회귀 가드 결과 (구조 0변경 증명 — 2차 누적)

| 항목 | 결과 |
|------|------|
| `git diff --stat` | **9 files** 변경 — 전부 className 토큰/style.boxShadow 라인 교체 |
| diff 내용 검증 | 변경 라인 전수가 외형(rounded/text-/font-/border/#hex/overflow-hidden/boxShadow). 핸들러·import·store·이벤트·배치 변경 **0줄** |
| typecheck | PASS (0 에러, 2차 후에도 동일) |
| test (vitest) | **76/76 PASS** (2차 후에도 동일 — Red 캐스케이드/상태/어댑터 무손상) |
| BEFORE/AFTER 시각 | git stash로 정합분 되돌린 BEFORE(radius 0·합계 14px)와 AFTER(radius 4px·16px/600) 스크린샷 대조 — 배치·옵션 순서·CTA 위치 변동 0, 외형만 변함 |
| CounterInput overflow-hidden | 외형 클리핑(둥근 모서리 밖 −/+ 버튼 노출 방지). 레이아웃 구조 아님 |

## 5. 잔존 편차 / GAP·AMB 처리 결과 (→ conflicts.md 상세)

| 항목 | 2차 시각 처리 | 결과 |
|------|---------------|------|
| GAP-2 드롭다운 radius·shadow | **정합 완료**(외형 토큰만) | CLOSED ✓ |
| GAP-1 image-chip 라벨색 #979797 vs §7.6 #424242 | PRBKYPR에 image-chip 미렌더 → 시각 미검증 | 보류(다른 상품군 필요) |
| GAP-3 finish-button weight(공용 14px/600 vs §7.11 12px) | 실측 14px/600 확인. 12px화는 공용 컴포넌트 variant 분기 필요(외형/구조 경계) | 보류(아키텍트 협의) |
| AMB-1 ColorChip/ImageChip ring-offset | PRBKYPR에 color-chip 미렌더 → 시각 미검증 | 보류 |
| AMB-2 summary 부가세·배송비 행 색 | 실측 #424242 확인. lines(#616161)는 정합, 고정행은 별도 | 회색지대 유지 |
| AMB-3 letter-spacing -0.8px 균일(em 비례 차이) | 토큰 `-0.05em` 정합이나 fontSize 비례 미적용 | 회색지대(1px 강박 금지) |
| AMB-4 미선택 버튼 weight 600 vs §7.1 400 | 공용 OptionButtonBase `font-semibold` | 보류(구조 분기 경계) |
