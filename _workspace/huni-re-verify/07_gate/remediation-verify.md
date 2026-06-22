# remediation-verify.md — N3·N1 교정 독립 재검증 게이트 (생성≠검증)

> 판정자: hrev-verify-gate. **§6 hw-builder 교정 주장 비신뢰 — 직접 재실측으로 재판정.**
> 재실측 일시: 2026-06-23 (KST). 세션 신선(GSTGMIC tiered baseline PRICE>0 sanity 통과 — 6000/28400/56200 단조).
> 오라클 = 라이브 RedPrinting(via `raw/widget_monitor/local/server.js` :3001, 읽기전용 get_ajax_price_vTmpl / get_digital_product_info).
> 기존 `07_gate/verdict.md`(Phase 5 NO-GO) 보존 — 본 파일은 N3·N1 교정 닫힘 여부 신규 판정 전용.
> 재실측 스크립트: `07_gate/scripts/{n3-ladder-probe,n3-ladder-probe2,n3-reconcile,session-sanity}.cjs`(verify-gate 직접 작성·실행).

---

## 0. 최종 판정

| 항목 | 판정 | 핵심 근거(직접 재실측) |
|------|------|----------------------|
| **N3 (HIGH·견적불가)** | **CLOSED** | 라이브 TPBLMEO `pdt_add_option_info` 직접 fetch(MIN_ORD=20/ADD_ORD=10) → 교정 `buildModelALadder` 적용 → 래더 [20,30,40,50,...,110] → 각 PRN_CNT 라이브 가격조회 PRICE≠0·**단조 비감소**(26,900→38,000→49,100→60,200→123,700). 교정 전(모델B only)은 이 래더 생성 불가=견적불가. |
| **N1 (HIGH·저청구)** | **부분 (단위봉인 CLOSED · 라이브 발현 보류)** | 단위테스트 9/9 green 직접 재현(addColor=Y→PRN_CLR_CNT 6/12 상향·ADD_CLR_YN emit·ADD_CLR_YN=N 자재 게이트차단 가격불변). 라이브 발현 자재상품(ADD_CLR_YN="Y" mtrl) **미식별 재확인**(body-log 자재 전수 ADD_CLR_YN="N" 9건·"Y" 0건). 블라인드 probe 회피(spec directive). |
| **vitest 재실행** | **PASS** | 전 suite **159 passed / 18 files**(빌더 주장 159 green 비준). N3/N1 신규 테스트 9/9. tsc --noEmit **EXIT=0**(clean 비준). |
| **회귀 0** | **PASS** | 모델B(digital/poster) + 직렬화 shape + 4월 경로(parity-crossverify) **36/36 green**. HLCLWAL(pdt_add_option_info 부재) → 기존 폐쇄래더 [500] 불변(모델A 미트리거). |
| **INV-1 (누출 0)** | **PASS** | 실행 산술(6/12·`u+c*h`·`for h<10`)·Red 필드명 set = `red-adapter.ts` **단독**. widget core/contract hit = 전부 주석 + 중립명(addColor/addColorCapable/colorSide) 운반. 누출 0. |
| **VM-1 생성≠검증** | **PASS** | verify-gate가 라이브 read-only **직접 POST**(TPBLMEO 래더·ORD_CNT sweep·GSTGMIC sanity)·vitest **직접 재실행**·deob **직접 sed**·INV-1 **직접 grep**. 빌더(§6) 셀 복붙 0. |
| **VM-3 무날조** | **PASS (단, 기존 e2e-trace 측정라벨 정정 1건)** | 교정 코드 인용 라인 전수 직접 Read 실재. deob L15436-15444(래더)·L15762-15764(6/12)·L15771-15773(emit) 직접 sed 실재(환각 0). **다만 기존 `e2e-golden-trace.md:26-28`의 "ladder qty 20/30/50 → 538k/1.14M/3.01M" 라벨은 측정오류** — 그 값은 PRN_CNT 래더가 아니라 ORD_CNT sweep(§2.3)에서 발생. 결함 무효화 아님·라벨 정정 필요. |

**→ N3 = CLOSED (라이브 재현 성공). N1 = 부분(단위봉인 닫힘·라이브 저청구 비준 잔여).**
교정은 결함을 닫았다 — 단 N1 라이브 돈영향 실측은 발현상품 미식별로 여전히 미확정(메커니즘은 단위·소스 확정).

---

## 1. N3 라이브 e2e 재현 (핵심 — 직접 재실측)

### 1.1 라이브 pdt_add_option_info 직접 캡처
`GET /rp-api/ko/product/get_digital_product_info?pdt_cod=TPBLMEO` → retCode 200, `pdt_add_option_info` 실재(5행):

| PDT_VER_SIZE | MIN_ORD_PRN_CNT | ADD_ORD_PRN_CNT | PACK_PRN_CNT | SIZE_NM |
|:---:|:---:|:---:|:---:|:---:|
| 10.00 | 20 | 10 | 100 | XXS |
| 19.00 | 20 | 10 | 200 | XS |
| 38.00 | 10 | 5 | 400 | S |
| 56.00 | 7 | 4 | 600 | M |
| 74.00 | 5 | 3 | 800 | L |

→ 합성 fixture가 아닌 **라이브 실값**. 첫 PDT_VER_SIZE(10.00, MIN=20·ADD=10) = 어댑터 초기 미선택 기준(deob L15424 options[0] 동형).

### 1.2 교정 buildModelALadder 라이브 적용
`red-adapter.ts:315-321` `for(h=0;h<10;h++) out.push(u+c*h)`(u=MIN_ORD=20, c=ADD_ORD=10) → **래더 [20,30,40,50,60,70,80,90,100,110]**.
deob L15438-15444 `for(let h=0;h<10;h++) v.push({PRN_CNT:u+c*h, DFT_YN:h===0?"Y":"N"})` 와 **verbatim 일치**(직접 sed 대조).

### 1.3 라이브 가격조회 (각 래더 PRN_CNT, ORD_CNT=1, PCS=[PRT_SID/PT001])
```
PRN_CNT=20  (h=0) → PRICE = 26,900  [>0]
PRN_CNT=30  (h=1) → PRICE = 38,000  [>0]
PRN_CNT=40  (h=2) → PRICE = 49,100  [>0]
PRN_CNT=50  (h=3) → PRICE = 60,200  [>0]
PRN_CNT=110 (h=9) → PRICE = 123,700 [>0]
MONOTONE_NONDECREASING = true
```
→ 래더 PRN_CNT가 라이브 가격경로(get_ajax_price_vTmpl)에 도달하고 단조 비감소·PRICE≠0. **N3 CLOSED**: 교정된 어댑터는 라이브 add_option로 래더를 만들고, 그 값이 실 가격을 산출. 교정 전(모델B only)은 PRN_CNT 후보 자체를 못 만들어 견적불가였음.

### 1.4 가격엔진 핵심: PRT_SID PCS 필수
초기 probe(CUT_DFT/BID_BND/SUB_MTR만, PRT_SID 누락) → 전 라인 PRICE=0. body-log 학습 결과 **538k는 `PRT_SID/PT001` 라인에서 발생**. PRT_SID 인쇄면 PCS 추가 후 PRICE>0. (세션 문제 아님 — GSTGMIC sanity는 PRICE>0.)

---

## 2. N3 값 정합 reconcile — 538k/1.14M/3.01M의 진실 (VM-3 무날조)

### 2.1 기존 verdict/e2e-trace의 주장
`verdict.md:78` / `e2e-golden-trace.md:26-28`: "TPBLMEO 80×80 SID_S **ladder qty 20/30/50** → 538,000 / 1,140,000 / 3,010,000".

### 2.2 재실측이 드러낸 사실
| 변동 축 | 값 | PRICE |
|---------|----|-------|
| PRN_CNT 래더(ORD_CNT=1) | 20 / 30 / 50 | 26,900 / 38,000 / 60,200 |
| ORD_CNT sweep(PRN_CNT=20 고정) | 1 / 20 / 100 | 26,900 / **538,000** / 2,690,000 |

→ **538,000 = ORD_CNT=20 × per-unit(26,900) = 538,000** (선형 정확). 즉 기존 보고의 538k/1.14M/3.01M은 **PRN_CNT 래더값이 아니라 ORD_CNT(주문건수) sweep**의 산출. "qty 20/30/50"을 PRN_CNT 래더 h=0/1/3로 라벨한 것은 **측정 차원 혼동**.

### 2.3 판정 영향
- N3 결함 자체는 **유효·CLOSED**: 래더는 라이브 데이터에서 생성되고 PRN_CNT가 가격 차원임을 직접 비준(§1.3). 교정 전 견적불가도 유효.
- **단 기존 `e2e-golden-trace.md:26-28`·`verdict.md:78`의 538k/1.14M/3.01M ↔ ladder qty 매핑은 정정 필요**(ORD_CNT sweep으로 명시). VM-3 무날조 차원의 라벨 교정 — 결함 무효화 아님. → §6 라우팅.

---

## 3. N1 봉인 검증 (단위 CLOSED · 라이브 보류)

### 3.1 단위테스트 직접 재현 (9/9 green)
`test/red-adapter-newfields-n3-n1.test.ts`:
- ADD_CLR_YN="Y" 자재 → value.addColorCapable=true 주입 + 도수 value.colorSide echo ✓
- SID_S + addColor=Y + 가용자재 → **PRN_CLR_CNT 6** + ADD_CLR_YN="Y" emit ✓ (deob L15764 동형)
- SID_D + addColor=Y → **PRN_CLR_CNT 12** ✓
- addColor off → base 4 유지 + ADD_CLR_YN="N"(가격불변) ✓
- 비추가색 자재(ADD_CLR_YN="N") + addColor=Y → **게이트 차단**(색수 미상향 4·ADD_CLR_YN="N"·addColorCapable 미주입) ✓

`red-adapter.ts:621` `addColorActive = req.addColor===true && req.addColorCapable===true` + `:622-627` SID_S?6:SID_D?12 + `:640` `ADD_CLR_YN: addColorActive?'Y':'N'` — 직접 Read 확인. 소스·단위 닫힘.

### 3.2 라이브 발현 미확정 (정직 보류)
body-log 자재 전수 스캔: **ADD_CLR_YN="Y" 자재 보유 상품 0건**(분포 {"N":9}). 가용 fixture·캡처·합리적 probe(NCCDDFT/RXSNO250/TPBLMEO 등) 모두 발현 자재 미식별. 라이브 블라인드 probe로 별색상품 코드 탐색은 read-only 과다호출·비생산적(spec directive 회피) → 미수행.
→ **N1 = 부분**: 단위봉인 CLOSED(메커니즘·게이트·가격불변 회귀 확정)·라이브 저청구 차등 비준만 잔여(발현 자재상품 식별 선행 필요).

---

## 4. 회귀 0 + INV-1 (직접 재실측)

### 4.1 회귀 0
- 전 suite **159 passed / 18 files**(직접 재실행). tsc --noEmit EXIT=0.
- 모델B 상품 + 직렬화 shape + 4월 경로(parity-crossverify): **36/36 green**.
- HLCLWAL(offset2023, pdt_add_option_info 부재) → GRP_PRN_CNT 폐쇄래더 [500] 불변 = 모델A 미트리거(회귀 0).
- N1 off/비가용 자재 = ADD_CLR_YN="N"·PRN_CLR_CNT base 유지(가격불변 하위호환).

### 4.2 INV-1 누출 0 (Red 산술 어댑터 격리)
실행 산술 grep(`? 6`/`? 12`/`u + c * h`/`for (let h = 0; h < 10`/Red 필드명 set):
- **`red-adapter.ts` 단독** 매치(실행코드).
- widget core(`src/widget/`)·contract(`src/contract/`) 매치 = **전부 주석**(INV-1 설명) + **중립명 운반**(addColor:boolean / addColorCapable:echo / colorSide:불투명 COD).
- price store(`stores/price.ts`)는 selection→중립필드 pass-through만(6/12·래더 산술 0).
→ **Red 가격지식(6/12·MIN+ADD×h)은 어댑터에만. 위젯/계약 누출 0.**

---

## 5. 잔여 + 다음 단계

| 항목 | 상태 | 사유 |
|------|------|------|
| **N1 라이브 저청구 비준** | 미확정(잔여) | 발현 자재상품(ADD_CLR_YN="Y" mtrl) 미식별. 단위·소스는 확정. 발현상품 확보 후 라이브 차등 e2e 가능. |
| **N6 (GSELGLV/TPTKDFT ATTB·PRN_CNT ×10)** | 미교정(잠복) | 현 재구성 미바인딩(grep 0)·교정 범위 밖(N3·N1 우선). 확대 전 가드 선행 필요(remediation-spec §N6). |
| **N2/N4/N5 (byte 정합·LOW/MED)** | 미교정 | 돈영향 0(N2)·LOW(N4 PRT_SID 게이트 비고·N5 omit). N3·N1 후순위. |
| **기존 e2e-trace 측정라벨 정정** | 라우팅 | `e2e-golden-trace.md:26-28`·`verdict.md:78`: 538k/1.14M/3.01M ↔ "ladder qty"를 "ORD_CNT sweep"으로 정정(§2). 결함 무효화 아님. |

**다음 단계:**
1. **N3 CLOSED → §6 동등성게이트(05_qa) 재실행** 후 V-WIDGET/V-EDITOR 서브시스템 확대(파일럿 NO-GO 해소 진척).
2. **N1 발현 자재상품 식별** — 별색/형광 노출 상품 코드 확보(인스펙터 hrev-golden-recorder) → 라이브 저청구 차등 e2e → N1 CLOSED 전환.
3. **기존 e2e-trace/verdict 538k 라벨 정정** — 인스펙터 hrev-price-equivalence(측정 차원 ORD_CNT 명시).
4. **N6 → 확대 전 교정**(GSELGLV/TPTKDFT 바인딩 시).

> 실 수정/COMMIT은 **§6 huni-widget 트랙·인간 승인.** 본 게이트는 검증+명세 한정. 라이브 읽기전용(주문/폼submit 0).
