# remediation-spec.md — 교정 명세 (V-PRICE 확정 결함 D1/D2/D3)

> 작성: hrev-verify-gate. **실 수정/COMMIT은 인간 승인 — 구현은 §6 huni-widget 트랙(red-adapter.ts)** 위임. 이 게이트는 검증+명세까지.
> 가격 데이터 결함은 0(VP-2 전셀 PASS) → dbmap 트랙 라우팅 불요. 전 결함이 §6 직렬화 코드 결함.
> 각 결함: 무엇이 틀렸나 → §6 파일:라인 → 왜 → 어떻게 → 회귀 가드.

---

## D1 — quantity-echo ATTB 타입 (string → number) · HIGH · 18셀

**무엇이 틀렸나:** quantity-echo PCS(SUB_MTR/INN_DFT/WRK_MTR/DIR_MTR)의 ATTB를 어댑터가 string으로 직렬화. 라이브 권위는 number(골든 python 검증: int).

**§6 위치:** `_workspace/huni-widget/04_build/src/adapters/red/red-adapter.ts:615`
```ts
ATTB: f.attb ?? (isQuantityEchoPcs ? String(req.quantity) : ''),
```

**왜:** `String(req.quantity)`가 number를 string화. 어댑터 주석 151이 "캡처 ATTB=1(quantity echo)"을 number로 인지하면서도 String()으로 자초. 입력 무관·어댑터 고정 결함.

**어떻게(codex가 정밀화한 타입 다형 반영):** quantity-echo 분기만 number로, `f.attb`(속성칩 string: RIN_BLK·"4") 경로는 **불변 보존**.
```ts
// quantity-echo 는 number, 속성칩(f.attb) 은 string 보존
ATTB: f.attb ?? (isQuantityEchoPcs ? req.quantity : ''),
```
★주의: `f.attb`가 제공되는 역구성 경로에서 `String(p.ATTB)` 운반이 별도로 있으면 그것도 검토 — 속성칩은 string("RIN_BLK"/"4"/"8"/"0") 유지가 라이브 정합(ROU_DFT의 "4"는 숫자형이나 string이 권위). 즉 ATTB 타입 시그니처는 `number | string` 양립(quantity형=number, 속성칩형=string, 미echo=''). `SelectedFinish.attb` 계약 타입(현 string)을 `number | string`로 넓히는 검토 필요.

**돈 영향:** 미확정 — ATTB는 가격 echo 전용(D-L1 라이브 입증: RIN_GLD 변경→6300 불변), 단가 미운반. Red 서버의 string `"2"` 관용도는 **read-only라 변형 POST 미수행 = 미확정**(byte 발산은 확정, 보수적 HIGH 유지).

**회귀 가드(함정 #1 차단):** ATTB **값+타입**을 대조하는 어서션 추가(현 `red-adapter-price-serialize-shape.test.ts`는 PCS_COD 집합만 대조·ATTB 값/타입 미검사). quantity-echo PCS는 `typeof ATTB === 'number'` && 값=quantity, 속성칩 PCS는 `typeof ATTB === 'string'` && 값보존을 동시 어서션.

---

## D2 — 책자 PRN_CLR_CNT 발명 · MED · 3셀

**무엇이 틀렸나:** book2025 reqBody ORD_INFO에 단일면 색수 PRN_CLR_CNT를 발명(라이브 책자는 CVR_CLR_CNT/INN_CLR_CNT만).

**§6 위치:** `red-adapter.ts:588` (`if (isBook)` 분기 591 **이전** 무조건 set)
```ts
PRN_CLR_CNT: req.colorCounts.default,   // ← 책자에도 누출
```

**왜:** 단일면 필드를 base ord 객체에 무조건 넣고 isBook일 때 split 필드를 추가만 함(588-589는 제거 안 됨). Red book 경로는 split-only(mod_05:1859-1870, codex+게이트 확인).

**어떻게:** 단일면 필드(PRN_CLR_CNT)를 `if (!isBook)` 가드 하에만 set. 책자는 CVR_/INN_만.

**돈 영향:** 미확정 — book2025_price 핸들러가 PRN_CLR_CNT를 무시하는가/표지색(CVR_CLR_CNT) 오염하는가는 서버 핸들러 거동 필요(미보유). **오염시 책자 표지색 돈크리티컬** → 교정 우선순위 표기.

---

## D3 — 책자 MTRL_CD 발명 · MED · 3셀

**무엇이 틀렸나:** book2025 reqBody ORD_INFO에 top-level MTRL_CD를 발명(라이브 책자는 CVR_MTRL_CD/INN_MTRL_CD만).

**§6 위치:** `red-adapter.ts:589` (591 isBook 분기 이전 무조건 set)
```ts
MTRL_CD: req.materials.default,   // ← 책자에도 누출
```

**왜·어떻게:** D2와 동일 패턴. line 580-590의 단일면 필드(MTRL_CD/PRN_CLR_CNT)를 `if (!isBook)` 가드로 묶고, 책자는 591-597의 split 필드만 set.

**돈 영향:** 미확정(상동, 오염시 책자 표지 자재 돈크리티컬 가능성).

**D2/D3 공통 회귀 가드:** §6 책자 serialize 테스트에 "단일면 필드 **부재**" 어서션 추가(현 테스트는 split 필드 **존재**만 검사). `expect(ord.PRN_CLR_CNT).toBeUndefined()`, `expect(ord.MTRL_CD).toBeUndefined()` (isBook일 때).

---

## 교정 트랙·승인 요약

| 결함 | 트랙 | §6 파일:라인 | 수정 방향 | 승인 |
|------|------|--------------|-----------|------|
| D1 | §6 huni-widget | red-adapter.ts:615 (+계약 attb 타입) | String(req.quantity)→req.quantity(quantity-echo 한정·속성칩 string 불변) | 인간 |
| D2 | §6 huni-widget | red-adapter.ts:588 | `if(!isBook)` 가드 | 인간 |
| D3 | §6 huni-widget | red-adapter.ts:589 | `if(!isBook)` 가드 | 인간 |

**가격 데이터(dbmap) 라우팅 없음** — result_sum 발산 0(VP-2 8/8 라이브 PASS). 전 결함이 reqBody 직렬화 코드 결함.
교정 후 §6 동등성게이트 + 본 게이트 VP-1 차등 재실행으로 GO 전환 확인(재실측만 GO 인정).
