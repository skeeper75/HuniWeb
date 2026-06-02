# Pass-1 SMOKE Report — Huni-Widget (PRBKYPR 무선 책자)

- 검증 도구: Playwright 1.54.2 + 설치된 Chrome 148 채널 (headless, 실 브라우저 렌더 — 조작·날조 없음)
- 대상: `http://localhost:5173/` (vite dev, `04_build/index.html` → `init(#host, {productCode:'PRBKYPR'})`)
- 호스트 공격 CSS: `body{font-size:12px;font-family:Times;background:#eee}`, `button{background:red;border-radius:9999px}`
- 스크립트: `05_qa/captures/{smoke.mjs, portal.mjs, interact.mjs}` (재현 가능)
- 캡처: `05_qa/captures/{pass1_smoke_full.png, pass1_select_open.png, pass1_shadow_innerHTML.html}`
- 분류: SMOKE (렌더·격리 확인 목적, 가격 정확성은 BFF stub 이라 범위 외)

---

## 1. Shadow DOM 격리 — PASS

`#host`에 `shadowRoot` (mode open) 존재, `#huni-widget-root` 마운트 확인. 위젯 내부 측정 computed style:

| 항목 | 호스트 강제값 | 위젯 실측값 | 누수? |
|------|--------------|------------|-------|
| button background | `red` (rgb 255,0,0) | `rgb(255,255,255)` 흰색 | NO |
| button border-radius | `9999px` (pill) | `0px` (직각) | NO |
| font-family | `Times` | `"Noto Sans KR","Noto Sans",sans-serif` | NO |
| font-size | `12px` | 버튼 14px / 라벨 16px | NO |
| body(호스트) 참조 | — | `Times` / `12px` (호스트는 정상 오염) | — |

8개 옵션 버튼 전수 검사 — red/pill/Times/12px 누수 0건. 스크린샷에서도 H1 타이틀(호스트 영역)은 Times serif로 렌더되지만 위젯 카드 내부는 모두 Noto Sans·직각 버튼·보라(#553886) 선택 하이라이트. **격리는 핵심 Pass-1 증명 통과.**

## 2. 14 componentType 렌더 커버리지 — PRBKYPR 노출 항목 전부 렌더

PRBKYPR fixture가 노출(view_yn=Y)하는 옵션 그룹 기준 (전 14종 중 이 상품에 해당하는 것만 렌더되는 게 정상):

| 그룹(라벨) | componentType | 렌더 |
|-----------|---------------|------|
| 규격 | option-button | OK (5종 버튼) |
| 표지 용지 | select-box (Radix Popover) | OK |
| 인쇄 도수 | option-button | OK (단면/양면) |
| 코팅 | finish-button | OK (무광/유광/엠보) |
| 날개 커버 | finish-button | OK |
| 면지 | color-chip / finish-button | OK (노랑~회색 14종, 텍스트칩) |
| 부분UV | finish-button | OK |
| 제본방향 | option-button | OK (좌철/상철) |
| 내지 용지 | select-box (Radix Popover) | OK |
| 내지 인쇄 도수 | option-button | OK (양면) |

- counter-input / page-counter-input(수량·내지장수)은 이 화면에서 **미노출**. skinInfo에 `quantityGroup.view_yn=Y`로 명세되어 있으나 렌더 패널에 수량/내지장수 카운터가 보이지 않음 → 결함 후보(아래 D1).
- area-input / price-slider / image-chip은 PRBKYPR에 해당 데이터셋 없음(정상 미렌더).
- summary / upload-cta는 디스패처 비대상(패널 고정) — PriceSummary·CTA로 렌더됨.

## 3. shadcn Portal-in-Shadow — PASS (최대 함정 통과)

`button[aria-haspopup="listbox"]` 2개("표지 용지","내지 용지"). 트리거 클릭 후:

- `role="listbox"` Popover content → **shadow root 내부에 렌더** (radixInShadow=1)
- `document.body`로 escape 안 함 (radixInBody=0, listInBody=false)
- 스타일 적용 정상: bg `rgb(255,255,255)`, border `1px solid`, font `Noto Sans KR`, max-height `280px`, box-shadow 존재 → unstyled 아님
- 옵션 폰트 14px Noto Sans (Tailwind adopted sheet 정상 적용)

스크린샷(`pass1_select_open.png`)에서 드롭다운이 트리거 바로 아래 흰 박스+그림자로 정상 렌더 확인. **portalContainer = shadow 내부 mountPoint 주입이 동작.**

## 4. Price summary 렌더 — PASS

PriceSummary 렌더 확인. 라인아이템(COT_DFT 11,600원 / CUT_DFT 0원 / PRT_DFT 44,400원) + 부가세 5,600원 + 배송비 3,500원 + 합계 **56,000원**(24px 보라 #553886). 값은 fixture mock(`price_q30_p10.json`)이며 기대대로임.

## 5. 콘솔 에러 — 경미 1건 + 경고 1건

- ERROR: `Failed to load resource: 404 (Not Found)` — 1회 관찰(재현 시 network 리스너엔 미포착, 간헐적). 정황상 favicon.ico 누락(dev 하네스 index.html에 favicon link 없음). **위젯 기능 무관, 비차단.**
- WARNING: `[DEPRECATED] Use createWithEqualityFn instead of create ... zustand/traditional` — Zustand v5 deprecation 경고. 동작엔 영향 없으나 Pass-2에서 정리 권장.
- 위젯 마운트 관련 JS 에러·React 경고 0건.

## 6. 라이트 인터랙션 — 부분 확인

- select(표지 용지) 열기/닫기 동작.
- '양면'(인쇄 도수) 클릭 시 재렌더 트리거(smoke run에서 changed=true). 단 합계는 56,000원 그대로 — **fixture price source가 `quantity>=120?priceQ300:priceQ30` 즉 수량만으로 2종 fixture를 근사 선택**(`fixture-source.ts:37-40`)하기 때문. dosu 변경은 quantity를 안 바꾸므로 같은 mock 반환. **재계산 배선 자체는 동작(가격 호출 발생), stub 한계로 값 불변** — SMOKE 범위에서 허용.

---

## 결함 목록 (심각도)

### D1 [HIGH — 근본원인 확정] 수량/내지장수 카운터 그룹 미생성
- 증상: 렌더 shadow HTML 전수 grep 결과 `수량`·`내지장수`·counter·number input 마커 **0건**. 14 componentType 중 입력형 2종(counter-input/page-counter-input)이 화면에서 완전 누락. skinInfo는 `quantityGroup.view_yn=Y`로 노출 명세.
- 근본원인(확정): `red-adapter.ts` `mapOptionGroups()` (131~214행)가 size·cover·dosu·PCS·inner material·inner dosu OptionGroup만 push하고 **quantity(`counter-input`)·innerPage(`page-counter-input`) OptionGroup을 생성하지 않음**. 수량 스펙(`FIR_CNT`/`INC`/`pageMin` 등)은 `mapConstraints()`의 `quantity` 객체(237행)로만 들어가고 `optionGroups`엔 포함 안 됨.
- 결과: `OptionPanel`(`OptionPanel.tsx:14` `optionGroups.filter(visible).map`)에 카운터 그룹이 없어 렌더 불가. `OptionControl.tsx:36-39`의 CounterInputBridge/PageCounterBridge는 도달 불가(dead path).
- 기대: 수량(FIR=1, INC=10, DFT=30) `counter-input`, 내지장수(MIN_INN_PAGE=10/실 MIN_PRN_CNT=30, STEP=1, MAX=300) `page-counter-input` 그룹이 렌더되어 quantity 변동→fixture 분기(`fixture-source.ts:39` `quantity>=120`)로 가격 재계산이 검증돼야 함.
- Pass-2 조치: `mapOptionGroups()`에 quantity/innerPage OptionGroup(각 `inputSpec` 포함) push 추가. inputSpec 매핑은 237행 객체 재사용 가능.

### D2 [LOW] 가격 재계산 실데이터 미검증 (stub 한계)
- fixture price가 quantity 2-bucket 근사라 dosu/size 등 옵션 변경이 가격에 반영 안 됨. 정합성은 실 BFF 또는 더 풍부한 fixture로 Pass-2에서 검증.

### D3 [TRIVIAL] Zustand deprecation 경고 / favicon 404
- 동작 무관. 콘솔 청결도 차원에서 Pass-2 정리.

---

## SMOKE 판정: GO (D1 단서 동반)

격리(핵심 증명)·Portal-in-Shadow(최대 함정)·옵션 렌더·가격 요약·CTA 모두 동작. 치명적 JS 에러 없음. 단 **D1(수량/내지장수 카운터 미렌더)** 은 Pass-2 진입 전 우선 확인 필요 — 입력형 컴포넌트 누락은 가격 인터랙션 전체 검증을 막는다.
