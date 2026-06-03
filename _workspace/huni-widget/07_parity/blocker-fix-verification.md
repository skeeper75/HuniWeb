# blocker-fix-verification.md — 3 BLOCKER 수정 독립 재검증 (S3)

> 검증자: hw-qa. 일시: 2026-06-03. 입력: parity-gap-map.md(갭정의) + parity-matrix-D1-price.md(L-1/D-L3) + parity-matrix-D4-internal-cascade.md(L-2).
> **원칙: 빌더 자가보고 미신뢰.** 모든 증거는 내가 직접 재실행·재대조(코드 diff 정독 + 캡처 필드 추출 + 독립 vite-node round-trip + 게이트 재현). "필드 존재"가 아니라 "shape/분기 동등"이 기준.
> INV-3 의도적 RELAX(구조결함 수정 — core/contract 불가피). 본 검증에 **최소·additive 판정** 포함.

---

## 0. 한 줄 결론

**3 BLOCKER 전부 RESOLVED**(독립 증거 보유). tsc 0 / vitest **94/94** / build OK 내 눈으로 확인. core/contract 편집은 **최소·additive**(기존 필드 0 변경, optional 슬롯만 추가). 단 **L-1은 수량형(SUB_MTR/PDT_WRK/INN_DFT) subtype만 캡처로 입증, 속성칩형(BID_SIL/RIN_DFT)·사이즈연동(ROU_DFT) subtype은 slot-only(빌더가 정직히 미주장)** — 스펙 의도(L-3는 MAJOR 라운드) 부합. → **BLOCKER 라운드 GO (MAJOR 라운드 진행 가능)**.

---

## 1. BLOCKER별 독립 판정

### D-L3 (침묵 PRICE=0 차단) — **RESOLVED**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| 어댑터 ok 게이트 | `red-adapter.ts:543-547` 정독 | `ok = res.retCode===200 && finalPrice>0`. finalPrice는 워터폴(PRICE_MALL→PRICE→ORG_PRICE) 평면화값이라 PRICE/ORG_PRICE 둘 다 0이면 finalPrice=0→ok:false. Red mod_06:1167(`!result_sum.PRICE→주문불가`) 분기 재현 |
| store 2차 방어 불변 | `git diff HEAD -- widget-store.ts` | **빈 diff(rc=0) — selectCanOrder(widget-store.ts:343) 완전 UNCHANGED**. 빌더 주장(미변경) 사실. `!price.ok || finalPrice<=0` 2차 게이트 유지 |
| 신규 테스트 진정성 | `red-adapter-parity-blockers.test.ts:199-214` | PRICE=0(retCode200)→ok:false(202), PRICE>0→ok:true(207), retCode!==200→ok:false(213). **재현실측 단언(타우톨로지 아님)** |
| 어댑터→store→canOrder 추적 | 코드 경로 추적 | mapPriceResponse ok:false → store price.ok=false → selectCanOrder가 `!price.ok` 로 canOrder=false. **2중 차단(어댑터 신규 + store 기존)으로 0원 주문 불가** |

→ PRICE=0/누락 응답이 orderable 로 빠져나갈 경로 없음. **RESOLVED.**

### L-1 (ATTB 전손실) — **RESOLVED (수량형 입증) / slot-prepared (속성칩·반경형)**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| 계약 additive | `contract/price.ts` + `product.ts` diff 정독 | `SelectedFinish.attb/attb2/attb3?`(전부 optional), `OptionValue.attb?`(optional). **기존 필드 0 변경 — breaking 0** |
| 캡처 실측 ATTB | `b1_AIPPCUT.json` PCS_INFO 직접 추출 | SUB_MTR `ATTB=1, ATTB_2='', ATTB_3=''` / CUT_ZUN·BON_SHT `ATTB='', ATTB_2/3 키 부재` |
| 직렬화 정합(독립 실행) | vite-node 직접 실행(quantity=7) | SUB_MTR `ATTB="7", ATTB_2="", ATTB_3=""`(수량 echo) / CUT_ZUN `ATTB="", ATTB_2 부재`. **캡처 패턴과 동치**(수량형=수량 echo + 빈슬롯, 비수량형=빈 ATTB·슬롯 없음). 이전 결함(`ATTB:''` 하드코딩) 제거 확인 |
| 신규 테스트 진정성 | test:54-116 정독 | 캡처 `capturedSub.ATTB===1`(61) 먼저 단언 후 `String(sub.ATTB)===String(capturedSub.ATTB)`(76). **실 캡처 대조** |
| 수량형 PCS 집합 | `red-adapter.ts:112` | `QUANTITY_ECHO_PCS={SUB_MTR,PDT_WRK,INN_DFT}` — Red mod_07:2586/2467 출처 정합 |

**수량형(SUB_MTR/PDT_WRK/INN_DFT) subtype = RESOLVED**(캡처 입증). ATTB:'' 하드코딩 제거되어 속성 단가차 오산 위험 해소.

### L-2 (COT_DFT/SCO_DFT 복합 2축) — **RESOLVED**

| 검증 | 내가 한 것 | 결과 |
|------|-----------|------|
| 소스 데이터 | STTHCIC fixture 추출 | COT_DFT `[TCMAS,TCGLS]`, SCO_DFT `[DFXXS]` — coating(slice0,4)+side(slice-1) 합성코드 실재 |
| 어댑터 분해(독립 실행) | vite-node | PCS_COT_DFT → `__side`(option-button,[S]) + `__coating`(finish-button,[TCMA,TCGL]). 평면 PCS_COT_DFT **소멸**(flat exists=false) |
| 재합성 round-trip(독립) | vite-node 양축 선택 | COT→`TCMAS`(1 entry), SCO→`DFXXS`(1 entry). **half-code leak=false**(S/D/TCMA/TCGL/DFXX 단독 누출 0) |
| 한 축만 선택 | vite-node coating만 선택 | COT 엔트리 **미emit**(불완전 조합 누출 방지 확인) |
| store 재합성 위치 | `price.ts:73-105` 정독 | `__side/__coating` 그룹은 직접 emit 안 하고 base별 수집 → coating+side 둘 다 있을 때만 `${coating}${side}` emit. 반쪽 누출 구조적 불가 |

→ TCMAS→{TCMA,S}→TCMAS / DFXXS→{DFXX,S}→DFXXS round-trip 정합, 부분선택 무누출. **RESOLVED.**

---

## 2. L-1 속성칩 slot-only 정직성 점검 (회의적)

**빌더가 "속성칩(BID_SIL/RIN_DFT) attb를 runtime 검증했다"고 과장했는가? → 아니오(정직).**

- 어댑터 grep: `BID_SIL`/`attbOptions` 추출 로직 **0건**. `QUANTITY_ECHO_PCS`는 수량형 3종만. 속성칩형 attb를 **adapter가 채우는 코드 없음**.
- fixture grep: 속성칩(attbOptions) 보유 fixture **없음**(HLCL의 RIN_DFT는 평범한 finish-button, attb 데이터 무). 속성칩 attb path는 **실행으로 입증 불가능**(데이터 부재).
- 계약 plumbing(`OptionValue.attb→selectedAttb→SelectedFinish.attb→serializer echo`)은 **준비됨(slot)**, 그러나 속성칩 attb **runtime-population은 미구현·미검증**.
- **스펙 정합**: parity-gap-map L-1은 "5종 후가공"이되 D1-§2.3가 "ROU(반경)은 L-3 범위 밖, attb 슬롯만 준비"로 명시. 본 BLOCKER 수정은 **수량형만 fixture로 closing, 속성칩/반경형은 slot-prepared**가 스펙 의도. 빌더는 이를 주석(`price.ts` SelectedFinish: "사이즈연동 반경(ROU/L-3)은 본 BLOCKER 범위 밖") + 코드(QUANTITY_ECHO만)로 **정직히 표면화**. 과장 없음.

→ **CONCERN 아님 — 정직한 부분 해소.** 단 MAJOR 라운드에서 L-3(ROU/속성칩 attb runtime) + 해당 fixture 확보 필요(미해소 명시 추적).

---

## 3. INV-3 RELAX 최소·additive 판정 — **PASS**

`git diff --stat HEAD`(core/contract 한정):

| 파일 | 변경 | 판정 |
|------|------|------|
| `contract/price.ts` | +6 (`attb/attb2/attb3?` optional 3슬롯) | **additive** — 기존 `groupId/valueId` 불변 |
| `contract/product.ts` | +3 (`attb?` optional) | **additive** — 기존 OptionValue 필드 불변 |
| `widget/stores/price.ts` | +37 (finishesFromSelections에 L-2 재합성 + attb 수집) | **최소** — buildPriceRequest 시그니처 불변, 기존 비복합 후가공 경로 보존(복합 suffix 그룹만 분기). dimsFromSelection/colorCounts/materials 등 무변경 |
| `widget/stores/widget-store.ts` | **0** | UNCHANGED |
| `widget/components/**` | **0** | UNCHANGED(leaf 컨트롤 무변경 — 신규 컨트롤 0, 스펙의 "신규 leaf 불필요" 준수) |

- **scope-creep 없음**: 변경은 L-1(attb 슬롯·수집·echo) + L-2(복합분해·재합성) + D-L3(ok게이트)에 **정확히 한정**. MAJOR/컨버전 항목(itemGroup·VIEW_YN·의류·ACC·ROU 멀티·END_PAP hex) **미손댐**(BLOCKER 범위 준수).
- 컴포넌트(leaf) 0 변경 = 스펙 "신규 leaf 불필요, 어댑터 파생+직렬화 재합성으로 흡수" 원칙 충족. 단순성 가드 준수.
- INV-3 relax는 **불가피하고 최소**: L-2 복합축은 contract `OptionValue.attb`/`SelectedFinish` 식별이 필요(어댑터만으론 store 재합성 식별 불가). additive optional이라 기존 위젯 코드 무영향.

---

## 4. 게이트 재현 (내가 직접 실행)

```
cd 04_build
npx tsc --noEmit   → tsc_rc=0 (에러 0)
npx vitest run     → Test Files 13 passed, Tests 94 passed (84→94, +10 BLOCKER 회귀가드)
npx vite build     → build_rc=0, 165 modules, dist/widget.js 758KB / loader.js 1.27KB
```
신규 테스트 `red-adapter-parity-blockers.test.ts` 10케이스 정독: L-1 캡처대조 3 + L-2 round-trip 4 + D-L3 게이트 3. **전부 실 캡처/실 fixture 대조(타우톨로지 아님)** — 이전 라운드가 직렬화 shape를 실캡처와 안 비교한 갭을 정확히 봉인.

---

## 5. 최종 BLOCKER 라운드 판정

## **GO** (MAJOR 라운드 진행 가능)

- **D-L3 RESOLVED**: ok=retCode&&finalPrice>0, store 2차방어 불변(독립 확인). 0원 주문 불가.
- **L-1 RESOLVED(수량형) + slot-prepared(속성칩/반경)**: 수량형 ATTB echo 캡처 정합, ATTB:'' 하드코딩 제거. 속성칩/ROU는 slot-only(스펙 의도, 빌더 정직 표면화) — MAJOR 라운드 L-3에서 fixture 확보 후 closing.
- **L-2 RESOLVED**: TCMAS/DFXXS round-trip + 한축 무누출(독립 vite-node 입증).
- **INV-3 relax 최소·additive**: core/contract 3 optional 슬롯 + price store L-1/L-2 로직, leaf 0변경, scope-creep 0.

**CONCERN(비차단, 추적):** L-1 속성칩(BID/RIN)·반경(ROU) attb runtime-population은 미구현 slot-only — fixture 부재로 본 라운드 입증 불가가 정상. MAJOR 라운드(L-3 ROU 멀티 + 속성칩 attb)에서 해당 상품 fixture와 함께 마감 필요. 이는 BLOCKER 게이트를 막지 않음(현 fixture 무증상, 스펙이 MAJOR로 분류).
