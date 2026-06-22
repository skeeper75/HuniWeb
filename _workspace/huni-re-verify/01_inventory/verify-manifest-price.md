# verify-manifest-price.md — 가격 시나리오 × V-PRICE 게이트 검증대상 매니페스트

> (가격 시나리오 × VP-1~VP-6) 매트릭스. 오라클 = 라이브 RedPrinting. 단일 FAIL=NO-GO.
> 시나리오 = price_gbn 4모델 + 함정 회귀. 출처(파일:라인/캡처/리포트)·검증방법(골든재생/라이브차등/메타모픽/mock) 명시.
> ★오라클 sanity(전 셀 적용): `result_sum.PRICE`만 읽음(VP-4)·PRICE=0=결함신호(VP-3)·per-line 0 합법.

---

## A. 가격 시나리오 (대표 상품/옵션 튜플)

| ID | price_gbn 모델 | 대표 productCode | 옵션 튜플 요지 | 골든 베이스라인(라이브) | 골든 출처 |
|----|----------------|------------------|----------------|--------------------------|-----------|
| **S-RP** | SizeMatrix2D / real_price | **AIPPCUT**(에코백) | MTRL=PXPLP001, CUT 300×340, DOSU SID_X(CLR0), PCS[SUB_MTR/CUT_ZUN/BON_SHT], ORD_CNT1·PRN_CNT1 | **PRICE=3,300** | b1_AIPPCUT.json:189(rel 2893) |
| **S-BK** | PriceTable3D / book2025_price | **PRBKYPR**(무선책자) | 표지/내지 분리(CVR_/INN_CLR_CNT·MTRL_CD)+PAGE_CNT, PCS[CUT/PER/CVR_SFT/COT/BIND] | PRICE>0 (SDK Report §6.1 예시) | SDK Report §6.1 / product_PRBKYPR.json |
| **S-FU** | FixedUnit / vTmpl_price | **STPADPN**(스티커) | 규격·용지·도수·폴리백·수량 | **PRICE=4,000** | s2_STPADPN.json / price_STPADPN_sample.json / gate-report §0 |
| **S-TD** | TieredDiscount / tiered_price | **GSTGMIC**(네임택) [정대표 GSBGRDY 부재=F-3] | 삼각네임택L, PRN_CNT 스윕 | PRN_CNT2→13,600 / 10→66,200; ORD_CNT 1~300 unit 6000 평탄 | qtysweep_GSTGMIC.json / sweep_GSTGMIC.json |
| **S-TM** | tmpl_price | **GSPUFBC**(파우치) | MTRL PXFBW010, CUT 230×288, complete=ORD_CNT100·PRN_CNT1 | complete PRICE=2,850,000 / incomplete=0 | s5_pouch_GSPUFBC.json |

---

## B. 검증 매트릭스 (시나리오 × VP-1~VP-6)

판정범례: ● 핵심 / ○ 적용 / — N/A(시나리오 부적합). 방법: GR=골든재생(strict POST), LD=라이브차등, MM=메타모픽/fuzz, MK=mock.

| 시나리오 | VP-1 골든재생(strict reqBody) | VP-2 라이브차등(result_sum) | VP-3 PRICE≠0 sanity | VP-4 result_sum 권위(per-line 금지) | VP-5 조합 fuzz/메타모픽 | VP-6 필드사전 정합 |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|
| **S-RP** AIPPCUT | ● GR (b1 rel2893 byte정합) | ● LD (=3,300) | ● (off-grid=0=Red정상거동·필수필드충족시 0금지) | ○ | ○ MM(off-grid 경계) | ● ORD_INFO 9필드+책자분리 미출력 |
| **S-BK** PRBKYPR | ● GR (CVR_/INN_*/PAGE_CNT 출력) | ● LD | ● | ○ | ○ | ● 책자 분리필드(D1-6) |
| **S-FU** STPADPN | ● GR | ● LD (=4,000) | ● | ○ | — | ● vTmpl_price echo |
| **S-TD** GSTGMIC | ● GR | ● LD | ● | ● (PRT_DFT 외 line=0, sum=13,600) | ● MM(PRN_CNT↑⇒PRICE 단조↑·discPct=0 평탄) | ● tiered_price echo |
| **S-TM** GSPUFBC | ● GR (ORD_CNT+PRN_CNT 둘다) | ● LD (=2,850,000) | ● (incomplete reqBody→0=결함 재현 가드) | ○ | ○ MM(수량 스윕) | ● tmpl_price |

---

## C. VP 게이트별 검증 항목·출처 (가격 도메인 정밀)

| 게이트 | 검증 항목 | 방법 | 출처(파일:라인/리포트) | 우선 |
|--------|-----------|------|------------------------|------|
| **VP-1** | serializeRedPriceRequest emit reqBody가 골든 캡처와 `dataJson`(ORD_INFO+PCS_INFO+price_gbn+mb_cust_cod) byte 정합 | GR (Playwright routeFromHAR strict POST) | red-adapter.ts:570-631 / red-adapter-price-serialize-shape.test.ts(현재 fixture 한정) / b1_AIPPCUT.json:189 | High |
| **VP-2** | 동일 옵션선택 → 라이브엔진(server.js 프록시) ↔ 재구성 어댑터 result_sum.PRICE/PRICE_VAT 동일 | LD (server.js :3001) | server.js / mapPriceResponse red-adapter.ts:649-690 | High |
| **VP-3** | 어떤 정상 경로도 result_sum.PRICE==0 아님; 0이면 결함(FAIL). incomplete reqBody는 ok:false 명시 | LD+가드 | red-adapter.ts:635-637,676-680 / s5_pouch incompleteReqBody / 불변식§3.1 | High |
| **VP-4** | 가격은 `result_sum.PRICE`만 읽음 — per-line `result[].PRICE` 읽기 금지 | 코드정합+LD | red-types.ts:144 / qtysweep_GSTGMIC(line 0/sum 13,600) / 불변식§3.2 | High |
| **VP-5** | 옵션튜플 차등 fuzz(fast-check) PRICE 발산 0; 메타모픽(수량↑⇒비감소·+공정⇒증가) hold | MM+LD | sweep/qtysweep_GSTGMIC(단조성) / coverage-scan.cjs(클래스) | Med |
| **VP-6** | 송수신 모든 필드가 필드사전(re-contract-price.md) AND 실 캡처에 존재 — 날조 필드 0 | 코드정합 | re-contract-price.md §1-2 / SDK Report §6.2 / VM-3 | High |

---

## D. ★재검증 대상 (D1-price 미해소 갭 — 라이브 차등으로 입증)

게이트는 GO인데 코드정합(D1-price)이 미해소로 분류한 항목 = 이 하네스의 핵심 추가가치:

| 갭 | severity | 검증 항목 | 방법 | 출처 |
|----|----------|-----------|------|------|
| **D-L1 ATTB** | BLOCKER | 단가영향 후가공(RIN_DFT 링색·ROU_DFT 반경)에서 ATTB 변경 시 라이브 PRICE 변화하는가; 어댑터 echo가 맞는가 | LD (ATTB 다른 2값 차등) | parity-D1-price §2.3 / crossverify-round2 §2(ATTB 다형·날조경계) / major_attbchip_BCFOXXX·major_radius_ACTHDKY |
| **D-L2 itemGroup** | MAJOR | 어댑터의 inner-형상 휴리스틱(red-adapter.ts:574-579) vs 명시 item_gbn — 오분기 케이스 라이브 존재? | LD | parity-D1-price D1-9 / red-adapter.ts:574 |
| **D-L3 PRICE=0 ok** | MAJOR | mapPriceResponse가 retCode200+PRICE=0을 ok:false로 차단하는가(어댑터 한정) | 코드정합+LD | red-adapter.ts:674 / parity-D1-price D1-13 |

> ★[HARD 무날조] ATTB 검증은 **qty=1 캡처가 ORD_CNT/상수/material-qty 구분 불가** — 임의 보정=날조(crossverify-round2 D-1). qty>1 + ATTB 변동 재캡처 선행(Phase 2 golden-recorder).

---

## E. 메타게이트 (전 시나리오)
- **VM-1** 생성≠검증: 재구성을 만든 패스가 자가승인 금지; 독립 검사자가 라이브/캡처로 재실측.
- **VM-2** codex high reconcile: 동일 work-spec 독립 2차(`hqv-codex-cross-verify .. high`); 불일치=조사. 미가용→"Claude 단독" 명시(pending 금지).
- **VM-3** 무날조: 모든 코드주장이 deob file:line / 캡처 / 라이브 인용. ★crossverify-round2 G-1(deob 2954/3572 부존재 인용) 선례 — 인용 라인 실재성을 게이트에서 직접 확인.
