# NC-1 `dimension-matrix-input` 구현 노트

> 명세: `01_reverse/s3-poster-capture.md` §3·§4. 결함: §2.1 (자유입력 SIZE_0 → `{cutW:0,cutH:0}` 폴백 → 가격요청 빈값 → retCode 999).
> 목적: 자유입력 가로×세로 수치를 store 에 직접 공급해 결함 해소. 첫 위젯 가시 변경 + 첫 코어(store) 터치.

---

## 1. numeric slot 설계 결정 · 근거

**결정: `WidgetState.dimensionInputs: Record<string, DimensionInput>` — selection(opaque id) 과 병렬인 별도 numeric map.**

- `selections[GRP_SIZE]` = 선택된 프리셋/sentinel 의 **opaque id**(예: `SIZE_0` = 사이즈직접입력) 그대로 유지.
- `dimensionInputs[GRP_SIZE]` = `{ w, h }` 자유입력 수치를 **별도 슬롯**에 보관.
- 갱신은 신규 액션 `setDimensionInput(groupId, d)` — 저장 후 `schedulePriceQuote()` 재호출(가격 재계산).
- `loadProduct` 에서 `dimensionInputs: {}` 로 초기화(상품 전환 시 리셋).

**근거 (최소 침습 · 타입 안전):**
1. **selection 직렬화 회피** — area-input/price-slider 는 `"5000x900"` 문자열을 selection 에 직렬화하지만(파싱 필요), 규격 그룹은 프리셋 선택(opaque id)과 자유입력 수치를 **동시에** 가져야 한다. 한 슬롯에 둘을 직렬화하면 캐스케이드·canOrder·기존 selection 로직이 size 값을 opaque id 로 보는 가정이 깨진다. **병렬 슬롯이 가정 보존.**
2. **groupId 키** — 향후 면별/다규격 확장 시 슬롯 충돌 없음. 현재는 `GRP_SIZE` 1개.
3. **기존 store 구조 불변** — `selections`/`quantity`/`pageCount` 와 동급의 상태 필드 1개 + 액션 1개 추가. 캐스케이드·shadow·editor-bridge·price-seam 무변경.
4. **selection 우선순위 명확** — 프리셋 선택 시 sizeRule 룩업이 권위(자유입력 슬롯 무시), sentinel(0×0 룰) 선택 시에만 numeric slot 소비. dimsFromSelection 분기가 이 우선순위를 강제.

---

## 2. 변경 파일별 diff 요약 (구현 6곳: 명세 4 + 라우팅 도달 2)

| # | 파일 | 변경 | 줄수(+/−) |
|---|------|------|-----------|
| 1 | `src/contract/product.ts` | `ComponentType` union `+ 'dimension-matrix-input'` 1줄. 신규 필드 0(InputSpec.axis2·PriceDimension.cutW/cutH 기존). | +1 / 0 |
| 2 | `src/widget/components/controls/OptionControl.tsx` | dispatcher `case 'dimension-matrix-input'` +1 + `DimensionMatrixBridge`(selection + dimensionInputs 동시 구독, freeInputId 는 sizeRules 0×0 룰로 식별). | +25 / 0 |
| 3 | `src/widget/components/controls/DimensionMatrixInput.tsx` | **신규 leaf** — 프리셋 칩(RULE-2 흰배경+border-2 #553886) + sentinel 선택 시 가로/세로 number input(AreaInput 토큰 동일) + clampAxis(MAX_CUT 상한). | 신규(+128) |
| 4 | `src/widget/stores/price.ts` | `dimsFromSelection` 자유입력 분기 +1: 선택 rule 이 0×0 sentinel 이고 numeric slot 에 수치 있으면 `cutW/cutH` 직접전달 + `workW/H=cut+cutMargin`. **재작성 아님 — if 분기 1개.** | +10 / 0 |
| 5 | `src/widget/stores/widget-store.ts` | `DimensionInput` 타입 + `dimensionInputs` 상태 + `setDimensionInput` 액션 + load 시 초기화 + `defaultSelections` 가 dimension-matrix(values 보유 입력형)에 기본 프리셋 선택. | +21 / −1 |
| 6 | `src/adapters/red/red-adapter.ts` | **라우팅 도달(reachability)** — size 그룹을 `real_price` + 자유입력 sentinel 보유 시 `dimension-matrix-input` + inputSpec(MIN/MAX_CUT, axis2=세로)로 매핑. DFT_YN=Y 프리셋 우선 정렬. 그 외(digital S1/S2)는 `option-button` 유지. | +34 / −5 |

테스트: `test/red-adapter-poster.test.ts`(+77/−7, NC-1 라우팅·결함해소 단위), `test/nc1-live-proof.test.ts`(신규, 실 런타임 store 경로 캡처).

---

## 3. INV-3 경계 준수 증명 (store 분기만 · 재작성 0)

- **price.ts `dimsFromSelection`**: 기존 sizeRule 룩업 경로 **불변**. 그 앞에 `if (sentinel 0×0 && numeric slot 존재)` 분기 1개만 삽입. early-return 후 기존 코드 그대로 도달. → **재작성 아님.**
- **widget-store.ts**: 상태 필드 1개 + 액션 1개 + 초기화 1줄 + defaultSelections 조건 보정 1개. `selectOption`/`schedulePriceQuote`/`cascade`/`uploadPdf`/`openEditor` 등 **기존 액션 본문 무변경.**
- **cascade.ts / shadow / editor-bridge / price-seam(buildPriceRequest 본체) 무변경.** `buildPriceRequest` 는 `dimensions: sides.map(dimsFromSelection)` 호출부 불변(분기는 dimsFromSelection 내부).
- **계약 신규 필드 0** — union 멤버 1줄만. `InputSpec.axis2`·`PriceDimension.cutW/cutH`·`BaseRule.cutMargin/maxCutW` 모두 기존 슬롯 재사용.
- **INV-1**: 위젯 가격 산술 0. store 는 `cutW/cutH/workW/workH` 수치 전달만. 보간·단가·최종가는 BFF.
- **INV-2**: union 멤버명 `dimension-matrix-input` 중립. 계약 타입에 Red/후니 고유명 0. (sentinel 식별은 sizeRules 의 `cutW===0&&cutH===0` 값 비교 — Red 필드명 직접 참조 아님.)
- **INV-5**: union ↔ dispatcher 동시 갱신. tsc exhaustive 통과(EXIT 0) — default 뭉갬 없이 명시 case.

### 라우팅 스코프 판단(adapter 변경 정당화)
명세 §4 의 4곳에 adapter 는 미포함이나, leaf 가 **도달 불가능**(GRP_SIZE 가 여전히 option-button)하면 NC-1 이 무의미. 따라서 size 그룹을 dimension-matrix 로 보내는 라우팅이 필수. **스코프 최소화**: `real_price`(실사·배너, SizeMatrix2D — §1.2/§5 의 S3 구분축) + 자유입력 sentinel 동시 충족 시에만 전환. → BNBNFBL/BNPTPET 만 영향, **S1(디지털)·S2(스티커) GRP_SIZE 는 option-button 유지**(§5 "S1·S2 위젯 코어 0변경" 보존, 회귀 0 — 스티커/디지털/메인 테스트 무변경 통과 확인).

---

## 4. 결함 해소 라이브 증거

### (a) 실 런타임 store 캡처 (`test/nc1-live-proof.test.ts`)
dev 하네스와 **동일 경로**(`createWidgetStore` + `StubBffClient[FixtureRedDataSource]`)로 `bff.price()` 에 실리는 요청 캡처:
```
[LIVE] BNBNFBL 자유입력 → price() req.dimensions[default]={"side":"default","cutW":5000,"cutH":900,"workW":5004,"workH":904}
[LIVE] 이전 폴백 {cutW:0,cutH:0} 해소 확인 (retCode 999 원인 제거)
```

### (b) 라이브 dev 서버 DOM 프로브 (localhost:5173, HMR)
실 Shadow DOM 위젯 마운트(BNBNFBL) 후:
- `sizeComponentType: "dimension-matrix-input"`, `inputSpecMax: 5000`
- "사이즈직접입력" 칩 클릭 → 가로/세로 number input 렌더(`aria-label: 가로/세로`)
- 5000×900 입력 → `freeInputDim: {cutW:5000, cutH:900, workW:5004, workH:904}` (console error 0)
- 스크린샷: 규격 칩(5000X900 우선 정렬 + 사이즈직접입력 selected=흰배경+보라 2px) + `5000 X 900 mm` + helpText "가로 0~5000mm · 세로 0~5000mm"

### (c) 회귀 무
- 규격프리셋(5000X900) 선택 → 기존 sizeRule 경로 유지: `{cutW:5000, cutH:900, workW:5004(sizeRule 권위)}`.
- 자유입력 미입력(W/H=0) → `cutW:0` 유지(canOrder/검증이 차단 — 가격은 BFF 권위).
- MAX_CUT 초과 거부: `InputSpec.max=5000` → leaf `clampAxis` 가 입력단 상한.

※ 비로그인 PRICE=0 (INV-1, BFF 권위). 증명 대상은 **PRICE 수치가 아니라 cutW/cutH 가 요청에 실리는지**(결함 해소) — 충족.

---

## 5. 게이트 결과
- `npx tsc --noEmit` → **EXIT 0** (exhaustive 포함)
- `npx vitest run` → **39 passed** (기존 33 무회귀 + NC-1 6: 단위 3 + 라이브 런타임 3)
- `npx vite build` → **성공** (dist/widget.js 707kB)

---

## 6. hw-qa 비교검증 핸드오프 포인트
1. **자유입력↔규격 경로 분기**: dimsFromSelection 의 sentinel(0×0) 식별이 후니 어댑터 교체 후에도 성립하는지(후니 size 데이터에 0×0 sentinel 표현이 동일한지) — 어댑터 계약 경계 검증.
2. **작업사이즈 공식**: `work = cut + cutMargin(4mm)` 가 모든 real_price 상품 공통인지(BNBNFBL/BNPTPET 만 캡처 — 타 배너 미검증).
3. **PRICE>0 실가 비교**: 비로그인 PRICE=0 라 SizeMatrix2D 결과 수치 미확보(§6 리스크). 로그인 캡처로 cutW/cutH 변동→PRICE 변동 직접 증거 보강 필요(INV-1상 위젯 무관하나 후니 비교 시 필요).
4. **MAX_CUT 검증 위치**: leaf clampAxis(입력단) vs canOrder(주문단) — 범위 위반 UX 가 후니 요구와 일치하는지.
5. **defaultSelections 기본규격**: DFT_YN=Y 프리셋 우선 정렬로 첫 진입=5000X900(자유입력 빈모드 아님). 후니 기본규격 정책과 정합 확인.
