# runtime-behavior-audit.md — 런타임/동작 분석 완전성 감사 (행동 동등성 게이트 레퍼런스 적격 판정)

> 감사 목적: 후니 위젯(04_build)이 라이브 RedPrinting 위젯과 **행동 동등(behavioral equivalence)**임을 증명하는 게이트의
> **레퍼런스로 02_analysis 런타임 분석이 충분·권위적인가**를 판정한다. "비교하기 전에 Red 동작이 철저히 선분석됐는가"를 감사.
> 범위: 4 가격모델 대표상품 × 5 행동 차원. **라이브 미구동(기존 산출물만 감사)**.
> 근거 표기: `[OBS]`=캡처에서 직접 관찰된 런타임 사실 / `[INF]`=정적/구조에서 추론 / `[STATIC-DATA]`=정적 데이터셋 정규화(런타임 미관찰).
> 동시 진행: STATIC 구조 감사(reverse-structure-audit.md)는 별도 에이전트 소유 — 본 문서는 런타임만.

---

## 0. 한 줄 판정

**YES-with-minor-gaps.** 런타임 분석은 가격 트리거·디바운스·PRICE=0 실패벡터·tiered_price 오해 정정에서 **라이브 캡처 근거로 권위적**이다.
다만 행동 동등성 게이트의 레퍼런스로 쓰기 전 **2개 실관측 공백(BLOCKER 1, 그 외 MINOR)**을 라이브 보강해야 한다:
① **2D 차원→가격(SizeMatrix2D) 관계가 단 한 번도 PRICE>0로 관측되지 않음**(real_price 전부 0), ② **material→pcs disable 캐스케이드의 실시간 발화가 미관측**(정적 데이터로만 명세).
이 둘을 제외한 초기화·가격재계산·에디터(굿즈)·상태머신은 게이트 레퍼런스로 충분하다.

---

## 1. 판정 요약 매트릭스 (4 모델 × 5 차원)

표기: **V**=VERIFIED(런타임 관측) / **P**=PARTIAL(일부 관측+일부 추론) / **M**=MISSING(런타임 미관측). 괄호=관측여부.

| 가격모델 (대표) | ① 옵션 캐스케이드 런타임 | ② 가격 API 시퀀스 | ③ 상태 전이 | ④ Edicus 에디터 LC | ⑤ 인터랙션 흐름 |
|----------------|:---:|:---:|:---:|:---:|:---:|
| **PriceTable3D** (책자 PRBKYPR / 캘린더 HLCLSTD) | **P** (select 변경만 관측, disable 캐스케이드 [STATIC-DATA]) | **V** (q×p 매트릭스 + 라인별 unit_amts 풀 캡처, PRICE>0) | **P** (init→pricing 관측, canOrder [INF]) | **M** (PRBKYPR 에디터 0이벤트 — 굿즈로 대용) | **P** (select 주입 관측, 입력검증 [INF]) |
| **SizeMatrix2D** (아크릴 ACNTHAP / 포스터 BNBNFBL) | **P** (size select 관측, 2D-grid 캐스케이드 [INF]) | **M** (real_price 전 호출 PRICE=0 — 차원→가격 관계 미관측) | **P** ([INF]) | **M** (미관측) | **P** (차원 select 관측, 가격무응답) |
| **FixedUnit** (스티커 STPADPN / 파우치 GSPUFBC) | **V** (옵션 dump + 단일고정 자재/도수 관측) | **V** (PRICE=0→완전reqBody→PRICE>0 + 수량/PRN_CNT/사이즈 sweep 풀 캡처) | **P** ([INF]) | **M** (미관측) | **V** (등록템플릿外 사이즈 PRICE=0 관측) |
| **TieredDiscount** (굿즈 GSTGMIC / GSPUFBC) | **V** (옵션 mutation 관측) | **V** (수량 sweep 9행 + tiered_price discPct=0 평탄 관측) | **P** ([INF]) | **V** (GSTGMIC 6 from-edicus 이벤트 실측) | **V** (sweep 관측) |

> 핵심: 게이트의 중심 명제 **"server-authority price (opaque) — 언제/어떻게 가격 재계산이 트리거되는가"**는 ②/⑤에서
> **FixedUnit·TieredDiscount·PriceTable3D 모두 PRICE>0 실관측으로 입증**됨. 단 **SizeMatrix2D(real_price) ②만 전부 PRICE=0**이라 미입증.

---

## 2. 가격모델별 런타임 상세 (file:line 근거)

### 2.1 PriceTable3D (책자 PRBKYPR / 캘린더 HLCLSTD / 포스터 PRPOXXX)

**② 가격 API 시퀀스 — VERIFIED [OBS].** 가장 강한 런타임 근거.
- `01_reverse/captures/price_matrix_summary.json` — PRBKYPR book2025_price를 **q30/q60/q120/q300 × p10/p20/p40** 매트릭스로 sweep, 각 조합에 `PRICE/ORG_PRICE/PRICE_MALL` + 공정별 `unit_amts{CVR_MTRL,CVR_PRINT,INN_MTRL,INN_PRINT,COT,BIND}` 분해 캡처. 수량 증가 시 CVR_PRINT 단가 체감(819→596→…) 관측 = **3D 단가 테이블 룩업 입증**.
- `05_qa/captures/s6_cal_HLCLSTD.json` priceCalls — offset2023_price가 `PRN_CNT=500,ORD_CNT=1, 210×150 → PRICE=1192700` / `90×180 → 778500` **PRICE>0 실관측** (규격별 가격차).
- `runtime-behavior.md:55-64` 라이브 priceCalc.params(표지 CVR_*/내지 INN_* 분리) = `02_analysis/captures/runtime_capture_PRBKYPR.json` network 4 price call(rel 3414/3633/6982/7179, status 200)로 뒷받침.

**① 캐스케이드 런타임 — PARTIAL.** `runtime_capture_PRBKYPR.json` optionMutation은 `{kind:select, from:0,to:1, optCount:5}` — **일반 select 변경만** 관측. `cascade-rules.md:33-41`의 자재→pcs disable 24건(RXOMO080→COT_DFT 등)은 `pdt_disable_pcs_info` 정적 데이터 + cascade_captures 정규화 = `[STATIC-DATA]`. **disable 발화·자동 선택해제가 런타임에서 관측된 적 없음.**

**④ 에디터 LC — MISSING.** `runtime_capture_PRBKYPR.json` editor.eventTimeline = **0 이벤트**(검증). runtime-behavior.md:158이 정직히 "[부분] — PRBKYPR 에디터 미열림, GSTGMIC로 프로토콜 확정"으로 명기. 표지=editor/내지=pdf 면별 분기(state-machine.md:101-104)는 `exterior.uploadType` 스토어 구조 [OBS]이나 **면별 에디터 동시 라이프사이클은 미관측**.

**⑤ HLCLSTD CLD_STD 폐쇄래더** — 캡처는 PRN_CNT=500 working point 2건만, **enum 래더 sweep(다른 PRN_CNT 단계)은 미관측**. red-coverage-matrix.md:134-139의 prnLadder 판정은 select-box enum [STATIC-DATA].

### 2.2 SizeMatrix2D (아크릴 ACNTHAP / 포스터 BNBNFBL / BNPTPET)

**판정 주의:** 명명된 대표 **ACNTHAP은 실제 price_gbn=`vTmpl_price`**(product_ACNTHAP.json 확인), SizeMatrix2D 전용 모델 아님. 실제 2D-차원 모델은 포스터/배너 `real_price`(BNBNFBL/BNPTPET).

**② 가격 API 시퀀스 — MISSING [OBS로 0 입증].** 결정적 공백.
- `s3_BNBNFBL.json` priceCalls 3건 전부 **PRICE=0**: `W5000×H900(ORD/PRN 없음)→0`, `W5000×H900(ORD_CNT=1,PRN_CNT=1)→0`, `W900×H900(1,1)→0`.
- `s3_BNPTPET.json` real_price 3건 maxPRICE=0. `s3_rp_BNBNFBL.json` 동일 maxPRICE=0.
- **즉 2D 가로×세로 차원이 가격에 어떻게 반영되는지가 단 한 번도 PRICE>0로 관측되지 않았다.** real_price 상품의 "완전 reqBody"(어떤 추가 필드가 PRICE>0를 내는지)가 FixedUnit(s5_pouch)처럼 규명되지 않음.
- methodology-audit.md F-7(L74-77)이 SizeMatrix2D 가로↔세로 축 배정·비대칭셀 위험을 정적 데이터로 flag했으나, **런타임 검증 부재**.

**① 캐스케이드 — PARTIAL.** `s3_BNBNFBL.json` optionMutation `{select,to:2,label:"900X900"}` = size select 관측. 그러나 차원변경→가격(②가 0이므로) 미입증. ACNTHAP은 SUM_MTR/뒷면자재(finish-button 흡수, red-coverage-matrix.md:111) 구조만 정적 보유.

### 2.3 FixedUnit (스티커 STPADPN / 파우치 GSPUFBC)

**② 가격 API 시퀀스 — VERIFIED [OBS]. 가장 모범적 캡처.**
- `s5_pouch_GSPUFBC.json` — **PRICE=0 실패벡터를 결정적으로 규명**:
  - `summary.rootCauseOfZeroPrice`: "ORD_INFO[0]에 ORD_CNT+PRN_CNT 둘 다 있어야 PRICE>0. 둘 중 하나라도 누락/0이면 0 반환."
  - `incompleteReqBody_PRICE0` (위젯 실제 발신, ORD_CNT/PRN_CNT 부재 → PRICE=0) vs `completeReqBody_PRICEgt0` (두 필드 추가 → PRICE=2850000) **대조 캡처**.
  - `s3_rp_GSPUFBC.json` priceCalls: 실제 위젯이 `ORD_CNT:None, PRN_CNT:None → result_sum.PRICE=0` 발신을 **런타임 그대로 관측**(침묵 0원 재현).
- sweep 3종 풀 캡처: `quantitySweep_ORD_CNT`(개당 28500 평탄, discountPct=0), `prnCntSweep`(PRN_CNT 선형 배수), `sizePriceTable`("임의 사이즈는 PRICE=0 — 등록 템플릿 정확매칭만 유효").

**⑤ 인터랙션 — VERIFIED.** sizePriceTable이 "등록템플릿外 사이즈 → PRICE=0" 입력검증 동작을 실관측.

**참고:** STPADPN은 `s2_STPADPN.json/.png`로 옵션구조 캡처. cascade-rules.md:8 굿즈 disable 0건 [미관찰] 명기 — FixedUnit군은 캐스케이드 자체가 없는 군.

### 2.4 TieredDiscount (굿즈 GSTGMIC / 파우치 GSPUFBC)

**② 가격 API — VERIFIED [OBS] + 중요 정정 입증.**
- `sweep_GSTGMIC.json` (tiered_price) — ORD_CNT 1→2→5→…→300 **9행 sweep, unit=6000 완전 평탄, discPct=0 전행**. → **"tiered_price"는 수량할인이 아니라 lookup**임을 런타임 입증.
- 대조: `sweep_GSMLSLC.json`(tmpl_price)·`sweep_GSPDLNG.json`(vTmpl_price)·`sweep_GSTBMWM.json`은 unit이 수량에 따라 **변동**(예 GSTBMWM 45→…→45000) — 즉 수량-구간 단가체감은 **tmpl/vTmpl에 존재, tiered_price엔 부재**. 이름과 실제 동작의 괴리를 sweep로 확정.
- `s3_rp_GSTGMIC.json` priceCalls: `ORD_CNT:1,PRN_CNT:1` reqBody → result PRICE 라인 일부 0(부자재 단가 미연동), PRICE_LOG "인쇄수량:1, 주문건수:1" — 필드 존재 시 동작 관측.

**④ 에디터 LC — VERIFIED [OBS]. 유일한 완전 관측.**
- `runtime_capture_GSTGMIC.json` editor.eventTimeline 6 이벤트 실측: `load-project-report(start)→ready-to-listen→doc-changed→request-prod-info→project-id-created→load-project-report(end)`. project_id="-Ou6PlD74V7Treg6c86o", psCode="Triangle_L@GSTGMIC" 실값(runtime-behavior.md:107-136).
- 단 **save-doc-report/goto-cart/close는 미관측**(편집·저장·장바구니 미수행) — runtime-behavior.md:155, sequence-diagrams.md:121 정직히 [정적/부분] 표기.

---

## 3. 과신(overclaim) 감사 — "covered"인데 실은 추론

| 위치 | 주장 | 실제 근거 | 판정 |
|------|------|----------|------|
| cascade-rules.md:1-4, §1-§5 | 캐스케이드 6종 "[정적+라이브]" / "라이브 cascade_captures 정규화로 6종 전체 확정" | optionMutation은 일반 select만. material→pcs **disable 발화·자동해제는 런타임 미관측**. cascade_captures는 product_info 동봉 정적 데이터의 정규화 추출이지 **사용자 변경에 의한 disable 발생의 관측 아님** | **과신** — "[정적+라이브]"가 disable 캐스케이드까지 라이브 입증된 듯한 착시. 실제는 `[STATIC-DATA]`. methodology-audit F-5(L59-66)와 동일 결의 |
| runtime-behavior.md:93, sequence-diagrams.md:62 | "에디터 라이프사이클 잔존#1 **해소**" | GSTGMIC(굿즈 단면 KOI)만 6이벤트. **책자(PRBKYPR) 0이벤트, save/goto-cart/close 전무** | **부분 과신** — "해소"는 create→loadEnd 한정. 본문엔 [부분] 분산 명기되나 헤드라인은 "해소" 단정 |
| runtime-behavior.md:51, cascade-rules.md:93 | "INN_CLR_CNT 4→8 캐스케이드됨(양면 효과) [라이브 관찰]" | priceCalc.params에 INN_CLR_CNT:8 존재는 [OBS]이나 **4→8 전이(before/after)는 단일 스냅샷**이라 전이 자체 미관측 | **경미 과신** — 결과값 관측 ≠ 전이 관측 |
| red-coverage-matrix.md:211,346 | "46/46 구조 신규 componentType 0 / 키스톤 100%" | componentType 라우팅 한정 참. disable/hidden/옵션값/2D가격은 sig 무관측 | methodology-audit F-1/F-5가 이미 Critical/MEDIUM-HIGH로 정정 권고 — **런타임 게이트엔 직접 영향 적음**(componentType은 정적축) |

> 종합: 02_analysis 문서들은 **[부분]/[정적]/[추정] 표기를 비교적 정직하게** 분산 배치했다(은폐 아님). 과신은 주로 **헤드라인/요약줄의 단정 표현**(disable "라이브", 에디터 "해소")에 국한. 본 게이트엔 표기를 `[STATIC-DATA]`로 강등하면 해소된다.

---

## 4. GAP 리스트 (실제 게이트 블로커만)

### GAP-1 [BLOCKER] SizeMatrix2D(real_price) 차원→가격 관계가 PRICE>0로 단 한 번도 미관측
- **근거:** `s3_BNBNFBL.json`/`s3_BNPTPET.json`/`s3_rp_BNBNFBL.json` real_price 전 priceCall **maxPRICE=0** (ORD_CNT=1,PRN_CNT=1 포함). FixedUnit처럼 "어떤 reqBody가 PRICE>0를 내는지"가 규명 안 됨.
- **게이트 영향:** 후니 위젯의 2D-차원 상품 가격 행동을 **비교할 Red 기준선이 존재하지 않음**. 위젯이 PRICE=0를 내도 "Red도 0이었으니 동등"이라는 공허 통과 위험.
- **해소 라이브 캡처:** **BNBNFBL(또는 BNPTPET) real_price를 로그인 세션·완전 옵션(ORD_CNT+PRN_CNT+차원 등록규격)으로 재캡처**, 최소 3개 가로×세로 조합에서 PRICE>0 + 가로/세로 비대칭 셀 1쌍(methodology-audit F-7) 확보. fresh 서버 재기동(쿠키 reload — CLAUDE.md F6)으로 침묵 0 방지.

### GAP-2 [MINOR→게이트 차원에선 BLOCKER 근접] material→pcs disable 캐스케이드 실발화 미관측
- **근거:** cascade-rules.md §1 disable 알고리즘은 `pdt_disable_pcs_info` 정적 + cascade_captures 정규화. **사용자 자재변경 시 PCS 그룹 disable + 선택 자동해제 + 그로 인한 가격재계산**의 런타임 시퀀스 캡처 없음. 관측된 optionMutation은 전부 일반 select(from:0→to:1).
- **게이트 영향:** 캐스케이드는 행동 동등성의 핵심 축. 후니 위젯의 disable 동작을 Red 관측 기준 없이 정적 규칙으로만 대조 → 적용순서(disable→해제→재계산) 동등성 입증 약함.
- **해소 라이브 캡처:** **PRBKYPR에서 표지 자재를 RXOMO080(disable 트리거 보유)으로 변경**, COT_DFT 등 7개 PCS가 disable되고 선택돼있던 후가공이 해제되며 가격이 재계산되는 before/after 스토어+network 시퀀스 1회 캡처.

### GAP-3 [MINOR] 책자 면별 에디터 + save/goto-cart/close 라이프사이클 미관측
- **근거:** PRBKYPR editor 0이벤트, save-doc-report/goto-cart/close 전 상품 미관측(runtime-behavior.md:155).
- **게이트 영향:** 굿즈 단면 KOI로 create→loadEnd는 확보됨. 책자 표지(editor)+내지(pdf) 동시·저장완료→장바구니→canOrder=true 전이는 미입증. 단 프로토콜(to/from-edicus 액션 집합)은 정적 확정이라 동등성 비교 자체는 가능.
- **해소 라이브 캡처(선택):** GSTGMIC에서 실제 캔버스 1회 편집→저장→goto-cart 트리거하여 save-doc-report/goto-cart info 스키마(특히 `case` 값·tnUrlList) 실측.

### GAP-4 [MINOR] HLCLSTD CLD_STD 폐쇄래더 enum sweep 미관측
- **근거:** offset2023_price PRICE>0는 PRN_CNT=500 1점만. 래더 다단계(다른 PRN_CNT enum 값) 가격 미확인.
- **게이트 영향:** 캘린더 enum 수량의 다단계 가격을 Red 기준 없이 비교. 낮음(PriceTable3D 책자 매트릭스가 단가체감 일반패턴 입증).

> **비-블로커(이론적 공백, 게이트 불필요):** acc-order 부자재 스토어, 아크릴 option_info(제작방식/형태, 실값 null), to-edicus 호스트→iframe 실송신(SDK 자체처리). 전부 runtime-behavior/cascade-rules 잔존절에 정직 명기됨.

---

## 5. Bottom-line

**런타임/동작 분석은 행동 동등성 게이트의 레퍼런스로 권위적인가? → YES-with-minor-gaps.**

근거:
- **충분(게이트 즉시 사용 가능):** ① 가격 트리거/디바운스(~360ms 실측, optionSettleMs) ② PRICE=0 실패벡터(ORD_CNT+PRN_CNT 필수, s5_pouch incomplete/complete 대조 + s3_rp 침묵0 재현) ③ tiered_price=lookup 정정(sweep discPct=0 평탄 vs tmpl 변동 대조) ④ 굿즈 에디터 create→loadEnd 6이벤트 실측 ⑤ FixedUnit 등록템플릿外 PRICE=0 입력검증 ⑥ PriceTable3D 책자 q×p 매트릭스+라인별 단가분해. 이들은 "server-authority opaque price를 언제/어떻게 재계산하는가"를 **라이브로 확립**했다 — 게이트 중심 명제 충족.
- **보강 필요(게이트 가동 전 닫아야):** **GAP-1(SizeMatrix2D real_price PRICE>0 0회 관측 — BLOCKER)** 1건 + GAP-2(disable 캐스케이드 실발화) 1건. 이 둘은 정적/추론으로만 명세돼 있어, 해당 차원에서 후니 위젯과 비교할 **관측된 Red 기준선이 비어 있다**(공허 통과 위험).
- **표현 정정(즉시):** cascade-rules.md disable 절의 "[정적+라이브]"를 `[STATIC-DATA]`로, runtime-behavior 에디터 "해소"를 "굿즈 한정 해소(책자 미관측)"로 강등.

**판정 사유:** 4 모델 중 3 모델(PriceTable3D·FixedUnit·TieredDiscount)의 가격행동이 PRICE>0 실관측으로 게이트 레퍼런스 적격. SizeMatrix2D(real_price) 1 모델만 가격행동 미입증 + 캐스케이드 발화 1축 미관측. 따라서 **전면 NO 아님**(대부분 권위적), **전면 YES 아님**(GAP-1 블로커 실재) → **YES-with-minor-gaps**. GAP-1·GAP-2 라이브 보강 캡처 2회로 게이트 가동 가능.

---

## 부록 — 감사 시 직접 재검증한 캡처(증거 추적)

| 캡처 파일 | 검증한 사실 |
|----------|------------|
| `01_reverse/captures/price_matrix_summary.json` | PRBKYPR book2025 q×p 매트릭스 PRICE>0 + unit_amts 공정분해 |
| `01_reverse/captures/product_ACNTHAP.json` | ACNTHAP 실제 price_gbn=vTmpl_price (SizeMatrix2D 전용 아님) |
| `05_qa/captures/s5_pouch_GSPUFBC.json` | PRICE=0 root cause, incomplete/complete reqBody, 3 sweep |
| `05_qa/captures/s3_rp_GSPUFBC.json` | 위젯 실발신 ORD_CNT/PRN_CNT None → PRICE=0 침묵 재현 |
| `05_qa/captures/sweep_GSTGMIC.json` + sweep_GS{MLSLC,PDLNG,TBMWM} | tiered_price discPct=0 평탄 vs tmpl/vTmpl 변동 단가 |
| `05_qa/captures/s3_BNBNFBL.json`·`s3_BNPTPET.json`·`s3_rp_BNBNFBL.json` | real_price 전 priceCall maxPRICE=0 (GAP-1) |
| `05_qa/captures/s6_cal_HLCLSTD.json` | offset2023 PRN_CNT=500 PRICE>0 2 size point (GAP-4) |
| `02_analysis/captures/runtime_capture_{GSTGMIC,PRBKYPR}.json` | 에디터 6 vs 0 이벤트, optionMutation 일반 select, price network 4call |
