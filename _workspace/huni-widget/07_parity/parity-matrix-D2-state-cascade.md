# Parity Matrix D2 — 상태관리 & 캐스케이드

> STAGE S1 검증. 기준 = **책임/로직/분기 재현 등가**(라인 카피 아님; Zustand vs Pinia 차이 허용, 동작·분기 일치 시 통과).
> 코드 변경 없음 — GAP만 보고.
> Red 권위: `07_parity/red-code-map-06-widget-sdk.md`(스토어 §2, 캐스케이드 §3, 가격 §1·8).
> 우리 구현: `04_build/src/widget/stores/{widget-store,cascade,price,context}.ts(x)` + `src/contract/{product,constraints,price}.ts`.
> 표기: `mod_06:L`/`mod_05:L` = Red 소스, `ws:L`=widget-store.ts, `cas:L`=cascade.ts, `pr:L`=price.ts.

---

## 0. 종합 판정

| 영역 | 판정 | 핵심 |
|------|------|------|
| 5 스토어 매핑 | **부분재현(구조변형)** | Red 5 Pinia 스토어 → 우리 **단일 Zustand store**(config/product/order/exterior 흡수). acc-order **미표현**(ACC 분기 없음). |
| 캐스케이드 disable 스코프 | **재현(등가)** | 우리 disable은 **자재-스코프**(activeMtrlIds 재룩업) — Red `disabledOpts[MTRL_CD]`와 동작 등가. |
| P4 VIEW_YN 동적 add/remove | **누락(GAP 확정)** | 우리 cascade는 **disable만**. 필수후가공 자동선택(rs)·런타임 그룹 add/remove·연동 가격재계산 없음. = P1 L-10. |
| P6 이중 debounce 200ms | **부분재현(타이밍 불일치)** | 우리 **단일 300ms**. Red는 150ms(useOrderState)+200ms(컨테이너) 2단. |

---

## MATRIX A-1 — 5 스토어 ↔ Zustand 슬라이스 매핑

우리 구조: 단일 `createWidgetStore(deps)` → 하나의 `WidgetState`(ws:36-76)에 전 도메인 평면화. Pinia 스토어 경계를 슬라이스 그룹(주석)으로만 표현.

| Red 스토어 (06맵 §2) | Red state/actions | 우리 대응 | 판정 | 비고 |
|----------------------|-------------------|-----------|------|------|
| **config** (`deob_06:717`) | locale, setLocale; translate() | `WidgetState.locale`(ws:38·127), `deviceType`, `member`. setLocale 액션 **없음**(deps.locale 생성시 1회 주입, 런타임 변경 불가). translate() **없음**(라벨은 어댑터가 정규화 label 로 공급). | **부분** | config 드롭 안 함(state는 보유). 단 **런타임 setLocale 미지원**(다국어 토글 시 GAP). translate는 어댑터 경계로 이전(설계상 OK). |
| **product** (`deob_06:754`) | baseInfo, getProductBaseInfo(clone), setProductBaseInfo | `WidgetState.product`(ws:42), `loadProduct()`(ws:144) = setProductBaseInfo+초기화. getProductBaseInfo(clone) 직접 대응 없음 — 셀렉터 `useProduct()` 로 노출(불변 참조, clone 안 함). | **재현** | clone-on-read 대신 불변 업데이트(immutable map, cas:50-58)로 등가. 동작 동일. |
| **exterior** (`deob_06:780`) | uploadType{side}, editorData{side}, payloadForEditorConfig{side}, setUploadType/setEditorData/setPayloadForEditorConfig, isAfterEdit(key) | `artifacts`(ws:50, side별 NormalizedArtifact), `editorConfig`/`editorSide`(ws:57·56), `uploadingSide`. setEditorData≈`applyEditorResult`(ws:225). isAfterEdit≈`selectCanOrder` 의 `a?.projectId` 검사(ws:356). | **부분** | uploadType(editor/pdf) 명시 상태가 **artifact.kind 로 암시**(별도 토글 상태 없음). payloadForEditorConfig 는 BFF.editorConfig() 가 흡수(위젯 미보관). **uploadType 전환 watch(파일리셋/화이트캐스케이드 mod_06:2539-2555) 미재현**. |
| **order** (`deob_06:822`) | orderData, getOrderData(clone), setOrderData(data, summary)→**onOptionChange({type:"COMMON",data,summary})** | `selections`/`quantity`/`pageCount`/`dimensionInputs`(ws:44-48), `selectOption`/`setQuantity`/`setPageCount`(ws:165·183·197). summary≈`cartHandoff`(ws:316). | **부분** | **onOptionChange 콜백 미발화**. 우리는 `onPriceChange`만(ws:84·294·304). 옵션변경 시 호스트 통지 채널 = 가격변경 시점에만(summary 동봉 안 됨). Red는 옵션변경마다 COMMON 통지. |
| **acc-order** (`deob_06:850`) | orderData, setOrderData(data)→**onOptionChange({type:"ACC"})** | **없음** | **누락** | ACC 제품(GSSBMTL/GSSBSTP/GSSBACM) 경로 0. M1.has(pdtCode) 분기·Acc 위젯·$1 인스턴스 미구현. = P1 L-12. 현 fixture 미포함이라 무증상이나 부자재 컨버전 시 신규. |

### 스토어 결론
- **config 드롭 안 함** — locale state는 보유. 단 **setLocale 런타임 액션 누락**(MINOR).
- **acc-order 미표현** — ACC 분기 전무(MAJOR, 부자재 상품 한정).
- 4개(config/product/order/exterior)는 단일 store로 흡수 — 도메인 책임은 보존(슬라이스 주석). Pinia 5분리 vs Zustand 1통합은 **구조 변형이나 책임 등가**(기준 충족). 단 **onOptionChange(COMMON/ACC) 호스트 통지 계약**은 미재현(아래 LOSS L-D2-3).

---

## MATRIX A-2 — 캐스케이드 엔진

| Red 책임 (06맵 §3) | Red 위치 | 우리 대응 | 판정 |
|--------------------|----------|-----------|------|
| disabledOpts MTRL_CD 키맵 환원 (`Ql`) | `mod_06:2618-2641` | `constraints.disableRules`(triggerValueId/disablesGroupId/disablesValueId, constraints.ts:4) — 어댑터가 평면화 | **재현** (데이터 형태만 다름; rule list ↔ 키맵, 룩업 등가) |
| 현재 MTRL_CD 로 disable 룩업 | `mod_06:1375`,`1562` | `activeMtrlIds`(cas:38) — **모든 활성 자재**의 rule 합집합 | **재현(등가+)** |
| 옵션 disable 판정 `!!h.value[v]` | `mod_06:1562` | `groupDisabled \|\| activeValueDisable.has(v.id)`(cas:51-54) | **재현** |
| 자재 변경 시 disable 셋 통째 교체 | `mod_06:1375`(computed) | `applyCascade` 가 **전 후가공 그룹 disabled 재계산**(cas:36-48 "이전 자재 disable 도 해제") | **재현** — 자재-스코프 확정. **전역 아님.** |
| disable 된 선택값 자동 해제 | (Vue reactivity) | 선택해제 연쇄(cas:60-77) | **재현(명시적)** — Red 보다 명확. |
| 적용 순서(자재→disable→해제→가격) | `mod_06` 흐름 | `selectOption`: applyCascade→set→schedulePriceQuote(ws:165-175) | **재현** |
| **필수후가공 초기 자동선택** (`rs`) | `mod_06:1470-1494` | `defaultSelections`(ws:109) 은 **visible 첫값만**; hidden essential(VIEW_YN=N) 자동적재 **부분**(주석상 "hidden essential 첫값 자동"이나 코드는 `g.values.length===0` continue + visible 첫값) | **부분(GAP)** → A-3 |
| **화이트인쇄 자동 캐스케이드** (AC*) | `mod_06:1495-1551` | **없음** | **누락** (AC* 제품 한정) |
| **방향 자동검출 disable** | `deob_06:338,371` | **없음** | **누락** (PageDirection 한정) |

### 캐스케이드 결론 (핵심 질문 답)
- **disable 은 자재-스코프인가? → 예.** `activeMtrlIds`(현재 모든 자재 그룹 선택값)로 rule 합집합을 매번 재계산(cas:36-48). Red `disabledOpts[현재MTRL_CD]`와 동작 등가. 전역 disable 아님. **PASS.**

---

## MATRIX A-3 — P4 VIEW_YN 동적 add/remove (가격재계산 연동)

| Red 동작 (`mod_06:1452-1494`) | 우리 cascade.ts |
|-------------------------------|------------------|
| `v(b,C,y)`: PCS 그룹을 런타임 **add**(기본엔트리 push) / **remove**(delete) | **없음** — applyCascade 는 `disabled` 플래그만 토글, 그룹 add/remove 안 함 |
| add/remove 후 `c(b)` 부모통지 → pcsInfo flat 병합 → **가격 재계산** | disable 변경은 selectOption 안에서 schedulePriceQuote 트리거되나, **그룹 구성 자체는 불변** |
| ESN_YN/VIEW_YN 으로 hidden essential 자동적재(`rs`) | `defaultSelections` 가 visible 첫값만 — hidden essential 자동선택 **미구현** |
| 화이트인쇄 등 옵션이 다른 옵션을 런타임 활성/비활성 | **없음** |

**P4 GAP 확정 (= P1 L-10, MAJOR).** 우리 캐스케이드는 **disable 전용**. Red의 "VIEW_YN 런타임 토글 + 후가공 그룹 동적 add/remove + 연동 가격재계산"을 재현하지 않음. 현 정규화 계약(disableRules + group.visible 정적 평면화)은 **로드 시점 고정 구성**만 표현하며, 옵션 선택이 다른 옵션의 *존재 여부*를 바꾸는 동적 캐스케이드 부재.

---

## MATRIX A-4 — P6 가격 트리거 타이밍

| Red (06맵 §0·8) | 우리 (ws:105·122·308-313) |
|------------------|----------------------------|
| useOrderState `watch(s.value, debounce 150ms)` → updateOrder (`mod_06:2742`) | (없음 — 옵션 집계 단계 별도 debounce 없음) |
| 컨테이너 `watch(p.value, debounce 200ms)` → mutate (`mod_05:1937`) | `schedulePriceQuote` 단일 `setTimeout(run, debounceMs)`, **기본 300ms**(`DEFAULT_DEBOUNCE`, ws:105) |
| 빈 파라미터 skip `cn(O)` | cache 히트 skip(ws:292) + product null guard(ws:288) — 빈값 명시 skip은 없음 |

**P6 결론: 부분재현(타이밍 불일치).** 우리는 **단일 300ms** debounce. Red는 **이중 150+200ms**(연쇄 누적 시 옵션→가격 ~350ms+). 단일 디바운스로 합쳐 **타이밍/연쇄 동작 상이**. 기능 결과(최종 가격 1회 요청)는 동일하나, 빠른 연속 옵션변경 시 중간요청 억제 패턴이 다름. 30s TTL 캐시(ws:106·292)는 Red 캐시 모델과 정합.

---

## LOSS REGISTER (D2)

| ID | 손실 | 심각도 | Red 근거 | 재현 명세 (코드 변경 X — 설계 지시) |
|----|------|--------|----------|-------------------------------------|
| **L-D2-1** | P4 VIEW_YN 동적 add/remove + 연동 가격재계산 | **MAJOR** | `mod_06:1452-1494` | cascade.ts 에 그룹 런타임 add/remove 도입: 정규화 계약에 "옵션값→타옵션 그룹 활성/비활성/자동선택" 룰(현 disableRules 확장 or addRules) 추가. add/remove 후 selectOption 처럼 schedulePriceQuote 호출. |
| **L-D2-2** | 필수후가공(hidden essential, ESN_YN=Y·VIEW_YN=N) 초기 자동선택 | **MAJOR** | `mod_06:1470-1494`(`rs`) | defaultSelections 에 `g.required && !g.visible` 그룹의 첫 값 강제 적재(현재 visible 첫값만). canOrder/가격에 hidden essential 반영. |
| **L-D2-3** | onOptionChange 호스트 통지(COMMON/ACC, summary 동봉) | MAJOR | `deob_06:831·859` | order setOrderData 시 호스트 콜백 onOptionChange({type,data,summary}) 발화. 현재 onPriceChange만 — 옵션변경 즉시 통지 채널 부재. ACC type 분기 포함. |
| **L-D2-4** | acc-order 스토어 / ACC 제품 분기 | MAJOR (부자재 한정) | `deob_06:850`,`mod_06:22` | M1.has(pdtCode) 분기로 Acc 위젯·$1 인스턴스·acc-order 슬라이스 신설. = P1 L-12. 부자재 컨버전 시 필수. |
| **L-D2-5** | 이중 debounce(150+200ms) → 단일 300ms | MINOR | `mod_06:2742`+`mod_05:1937` | 결과 등가하나 연쇄 타이밍 상이. 정합 필요 시 2단(옵션집계 debounce + 가격 debounce)로 분리. |
| **L-D2-6** | uploadType 전환 watch(파일리셋·AC*화이트) | MINOR | `mod_06:2539-2555` | editor↔pdf 전환 시 부수효과(artifact 리셋, AC* PRT_WHT 자동토글) 미재현. AC*/전환 UX 한정. |
| **L-D2-7** | 런타임 setLocale | MINOR | `deob_06:720` | locale 런타임 변경 액션 없음(생성시 고정). 다국어 토글 요구 시 추가. |
| **L-D2-8** | 화이트인쇄·방향자동검출 등 제품특수 캐스케이드 | MINOR (제품 한정) | `mod_06:1495-1551`,`deob_06:338` | AC*/PageDirection 제품 컨버전 시 신규 분기. = P1 L-9 인접. |

---

## 정합 확인 (재현 OK — 회귀 가드)
- 자재-스코프 disable + 이전 자재 해제(cas:36-48) — Red 등가. **유지.**
- 선택해제 연쇄(cas:60-77) — Red 보다 명시적. **유지.**
- 단일 store/슬라이스 주석 — Pinia 5분리의 책임 등가 표현. **허용(기준 충족).**
- 30s TTL 가격 캐시 + 결정적 해시(pr:104, ws:292) — Red 캐시 모델 정합. **유지.**
- 정규화 계약 의존(단가/공식 없음, pr:2) — 컨버전 전략(MEMORY) 정합. **유지.**
