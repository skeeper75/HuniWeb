# remediation-spec.md — 교정 명세 (V-PRICE 신규 14필드 N1~N6)

> 검증+명세까지. **실 수정/COMMIT은 §6 huni-widget 트랙·인간 승인.** 이 게이트는 명세 한정.
> 3층 교정 경로: ① 계약 `src/contract/price.ts`(NormalizedPriceRequest 슬롯) → ② Red shape `src/adapters/red/red-types.ts`(RedPriceReqOrdInfo) → ③ 직렬화 `src/adapters/red/red-adapter.ts`(serializeRedPriceRequest).
> 우선순위: **N3(HIGH·견적불가) → N1(HIGH·돈크리티컬) → N6(저청구 잠복) → N2/N4/N5(byte 정합)**.
> 모든 파일:라인은 verify-gate 직접 Read 확인. 단가/공식 값은 위젯에 없음(서버 권위) — 슬롯·직렬화 추가만.
> 4월분 D1/D2/D3 명세는 `_prev/260623-april-baseline/07_gate/remediation-spec.md`.

---

## N3 — 수량모델 A 래더 미구현 (HIGH · 라이브 538k→3.01M 차등 비준 · 견적불가)

**무엇이 틀렸나:** 재구성 `buildQuantityRule`(red-adapter.ts:279-294)는 모델 B(`pdt_prn_cnt_info` 행기반 FIR_CNT/INC_CNT/INC_STEP/MIN_PRN_CNT)만 산출. 모델 A(`pdt_add_option_info`의 `PDT_VER_SIZE`별 `MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h`, h=0..9 산술 래더)는 슬롯·생성코드 전무(grep 0). 떡메(TPBLMEO/TPBLPST)·PDT_VER_SIZE형 굿즈는 이 래더가 수량옵션을 생성→PRN_CNT→가격. **라이브 비준: TPBLMEO 80×80 SID_S ladder qty 20/30/50 → 538,000/1,140,000/3,010,000.** 재구성은 이 상품군 수량옵션 자체를 못 만듦 = 견적불가.

**어디(§6 파일:라인):**
- 계약 `price.ts:24-41` — `NormalizedPriceRequest`에 모델A 수량옵션 운반 구조 부재(quantity/printCount만).
- red-types.ts:92-105 `RedPrnCntInfo` — `MIN_ORD_PRN_CNT`/`ADD_ORD_PRN_CNT`/`PDT_VER_SIZE`/`PACK_PRN_CNT` 필드 부재(모델B 행만). `RedProductData`(:107-122)에 `pdt_add_option_info` 없음.
- red-adapter.ts:279-294 `buildQuantityRule` + :299-305 `prnCntLadder` — 모델B 전용. deob 권위 = widget.deob.js:15432-15445(래더 생성)·L19664(렌더 게이트)·L19729(옵션 우선순위).

**어떻게 고칠지:**
1. red-types.ts: `RedAddOptionInfo` 신규 인터페이스(`PDT_VER_SIZE`/`MIN_ORD_PRN_CNT`/`ADD_ORD_PRN_CNT`/`PACK_PRN_CNT`) + `RedProductData.pdt_add_option_info?: RedAddOptionInfo[]`.
2. red-adapter.ts: `buildModelALadder(addOpt)` 추가 — `for h in 0..9: PRN_CNT = MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT*h`(deob L15438-15444 verbatim 산술), `DFT_YN = h===0?'Y':'N'`. `pdt_add_option_info?.length` 시 모델B 대신 이 래더로 수량 OptionGroup 생성(deob L19664·L19729 동형).
3. 계약: 수량 OptionGroup이 모델A enum을 운반하도록 그룹 생성 경로 보강(차원=printCount).

**회귀 가드:** TPBLMEO `pdt_add_option_info` fixture로 (a) 래더 PRN_CNT=[20,30,40,...] 생성 단위테스트 (b) 라이브 골든 538k/1.14M/3.01M 차등 재현 e2e (c) 모델B 상품(NCCDDFT) 회귀 0.

---

## N1 — ADD_CLR_YN 미전송 (HIGH · 소스 메커니즘 확정 · 라이브 발현 미확정)

**무엇이 틀렸나:** non-book2025 ORD_INFO 빌더는 `ADD_CLR_YN: T.dosuInfo?.ADD_CLR_YN`를 **항상** emit(deob L13982). 자재가 `pdt_mtrl_info`에서 ADD_CLR_YN="Y"이면(addClrMtrlList=E.value=pdt_mtrl_info, L19697) 사용자 추가색 토글 시 **PRN_CLR_CNT를 6(SID_S)/12(SID_D)로 재작성 + ADD_CLR_YN=Y emit**(deob L15764·L15771-15773). 추가색은 색수(가격축)를 끌어올려 가격 증가. 재구성은 ADD_CLR_YN 슬롯 부재(3층 전무) → 추가색 자재상품에서 색수 미상향 = **저청구**.

**어디(§6 파일:라인):**
- price.ts:24-41 `NormalizedPriceRequest` — 추가색 토글/색수 상향 슬롯 0.
- red-types.ts:166-184 `RedPriceReqOrdInfo` — `ADD_CLR_YN` 필드 0.
- red-adapter.ts:580-590 serialize ORD_INFO — `ADD_CLR_YN` set 0(PRN_CLR_CNT는 :588 set하나 추가색 상향 로직 없음).

**어떻게 고칠지:** 3층 슬롯 추가. 계약 `addColor?: boolean`(중립명) → 색수 산출 시 자재 ADD_CLR_YN="Y" + addColor → `colorCounts.default = SID_S?6:SID_D?12`(deob L15764 동형) → 직렬화 `ORD_INFO.ADD_CLR_YN = addColor?'Y':'N'`. 자재 메타(ADD_CLR_YN)는 product info 매핑에서 추출.

**회귀 가드:** ADD_CLR_YN=Y 자재 fixture로 (a) addColor=Y → PRN_CLR_CNT 6/12 상향 단위테스트 (b) ★발현 자재상품 식별 후 라이브 저청구 차등 e2e(★현재 미식별 — 교정 전 발현 상품 확보 선행) (c) 비추가색 자재(NCCDDFT/RXSNO250) ADD_CLR_YN="N" 정합·가격불변(라이브 12700 확인).

---

## N6 — GSELGLV/TPTKDFT ATTB·PRN_CNT ×10 미반영 (신규 codex · 저청구 잠복)

**무엇이 틀렸나:** GSELGLV는 PRN_CNT ×10(deob L13978) **하고** PCS_INFO.DIR_MTR.ATTB도 ×10 재작성(deob L13950·L14110-14124, quantityInfo.prnCnt×10 동반). TPTKDFT SUB_MTR EN001~4도 ATTB×10(L13950). 재구성은 GSELGLV/TPTKDFT 미처리(grep 0) — 다룰 시 PRN_CNT·ATTB ×10 미반영 = 후가공/수량 저청구.

**어디(§6 파일:라인):** red-adapter.ts:580-590(PRN_CNT)·:602-622(PCS_INFO ATTB). deob 권위 L13950/L13978/L14110-14124.

**어떻게 고칠지:** 어댑터에 GSELGLV/TPTKDFT 분기 — PRN_CNT 및 DIR_MTR(GSELGLV)/SUB_MTR(TPTKDFT EN001~4) ATTB를 ×10 스케일(deob 동형). Red 코드지식은 어댑터에만(INV-1).

**회귀 가드:** GSELGLV fixture로 PRN_CNT×10·DIR_MTR ATTB×10 단위테스트. 현 미바인딩이라 회귀 위험 0이나 확대 전 가드 선행.

---

## N2 — REAM_CNT 미전송 (MED · 돈영향 0)

**무엇이 틀렸나:** ORD_INFO에 REAM_CNT(deob 골든 0/1/2) 미전송. 단 REAM_CNT는 `REAM_YN="Y"` 게이트의 표시 파생값(연→매수 라벨, deob L22609-22616), 가격빌더는 PRN_CNT만 읽음(L13977-13978) = 가격무영향(골든 전부 12700 직접 확인).

**어디:** price.ts:24-41 / red-types.ts:166-184 / red-adapter.ts:580-590 — REAM_CNT 슬롯 0.

**어떻게:** 3층 슬롯 추가(직렬화 정합용). 계약 `reamCount?: number` → ORD_INFO.REAM_CNT. ★수량권위는 PRN_CNT 유지(계약 문구 "REAM_CNT=수량모델 B"는 "표시 파생·REAM_YN 게이트"로 정정 — codex 신규발굴 3).

**회귀 가드:** REAM_CNT 0/1/2 emit 단위테스트 + PRICE 불변(12700) 회귀.

---

## N4 — PACK_PRN_CNT / MAX_PRN_CNT 미전송 (LOW · PRT_SID 게이트 비고)

**무엇이 틀렸나:** PACK_PRN_CNT(addOptionInfo, deob L13984 조건부)·MAX_PRN_CNT(pdt_base_info, L19733) 미전송. PACK_PRN_CNT는 단순 echo 아님 — `===100→PRT_SID disable`(L19784)·`!==100 && SID_X→PRT_SID forced`(L19786). 즉 후가공 가용성(PRT_SID)을 좌우(간접 가격영향). 골든 PACK=100/MAX=10000 PRICE 보존.

**어디:** price.ts / red-types.ts / red-adapter.ts ORD_INFO 슬롯 0.

**어떻게:** 슬롯 추가(조건부 emit, deob L13983-13985 동형 `addOptionInfo ? {PACK_PRN_CNT}`). ★PRT_SID disable/forced 게이트는 후가공 가용성 룰로 별도 반영(disableRules 확장, red-adapter.ts:523-528) — N4 가격함수 sweep 미캡처라 비고.

**회귀 가드:** PACK_PRN_CNT=100→PRT_SID 비활성 룰 단위테스트.

---

## N5 — DOSU_COD 의도 omit (LOW · 잔존 4월기존 · omit안전성 미확정)

**무엇이 틀렸나:** red-adapter.ts:569 의도 omit(OPEN-1, PRN_CLR_CNT가 도수 가격의미 운반). GSTGMIC/NCCDDFT(offset2023)선 4월 입증상 가격무영향. 단 codex 지적: DOSU_COD=SID_X는 TPBLMEO/TPBLPST에서 PDT_CD 재작성(L13540-13546)·PRT_SID 게이트(L19784/19786)에 관여 = **그 상품군 처리 시 omit 위험**. 단 N5 omit 대상은 GSTGMIC/NCCDDFT이고 재구성은 PDT_CD 직접 산출(DOSU_COD 경유 안 함).

**어디:** red-adapter.ts:569(omit 주석)·580-590(미set).

**어떻게:** 현 파일럿(GSTGMIC/NCCDDFT)은 omit 유지(가격무영향). ★재구성이 TPBLMEO/TPBLPST(트래블택류)를 다룰 때는 DOSU_COD를 emit해야 PDT_CD 재작성 누락 방지 — 확대 시 조건부 emit으로 전환.

**회귀 가드:** omit 안전성 라이브 read-only 차등(GSTGMIC DOSU_COD 유/무 가격동일) 실측 후 LOW 확정.

---

## 부록 — 검사식 정정 (MR-5 · 재구성 결함 아님)

**무엇이:** `vprice-newfields.test.ts:137-140` MR-5 메타모픽이 "단조 비감소"(`seq[i] >= seq[i-1]`)로 검사 — HOL16800/ROU16200/MIS18200/OSI18200은 **서로 다른 후가공 종류**라 16800→16200 역전이 정상(단조 부적용). **어떻게:** 검사식을 "각 후가공 PRICE > baseline 12700"으로 정정(metamorphic-relations.json MR-5 shape "전부 baseline 초과"와 일치). 인스펙터 hrev-price-equivalence·테스트 하네스 정정.
