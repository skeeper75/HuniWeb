# 셋트 가격 t_prc_* 민팅 준비도 평가 — 적재 대상 5건

생성: hsp-set-designer · 권위=set-price-authority.md(계산공식집 시트) + §18 engine-design-booklet/photobook + 라이브 읽기전용 실측(2026-06-25) · 단가=가격표/추출 verbatim(날조 0) · **DB 미적재**(실 COMMIT/민팅 별도 인간 승인).

> 본 평가는 set-price-authority §3.1 "적재 대상 5건"(072·077·082·097·100)의 t_prc_* 민팅 준비도를 라이브+설계+권위 3원으로 점검한다. 088(권위 보류중)·094(적재됨·결함)는 적재 대상 밖이나 참조 비교.

---

## 0. 결론 요약 (READY / PARTIAL / BLOCKED)

| set_prd_cd | 셋트 | 유형 | PRF | comp | 단가행 | 선행의존 | 바인딩 | **종합** |
|---|---|---|---|---|---|---|---|---|
| **PRD_000097** | 떡메모지 | 고정가형 | ✅ READY | ✅ READY | ✅ READY | ✅ 없음 | 🟡 1행 누락 | **🟢 READY** (신규 mint 0·바인딩 1행만) |
| PRD_000072 | 하드커버책자 | 원자합산형 | ❌ 미존재 | ❌ 0행(표지/내지/면지) | 🟡 분산 | 🔴 W1·W2 | ❌ 미바인딩 | **🔴 BLOCKED** (comp 대량 신규 mint·§18 위임) |
| PRD_000077 | 레더 하드커버책자 | 원자합산형 | ❌ 미존재 | ❌ 0행 | 🟡 분산 | 🔴 W1·W2 | ❌ 미바인딩 | **🔴 BLOCKED** (072 동형) |
| PRD_000082 | 하드커버 링책자 | 원자합산형 | ❌ 미존재 | ❌ 0행(+면지 비목) | 🟡 분산 | 🔴 W1·W2 | ❌ 미바인딩 | **🔴 BLOCKED** (면지 인쇄/코팅 추가) |
| PRD_000100 | 포토북 | base24 통합형 | ❌ 미존재 | ❌ 0행(base24/per2p) | 🟡 미특정 | 🟡 표지5종 | ❌ 미바인딩 | **🟡 PARTIAL→BLOCKED** (base24/per2p comp 신규 mint·단가 원천 photobook-l1) |

- **민팅 READY = 1건(097)**. 신규 mint 0 — 라이브에 PRF·comp·단가행 전부 실재, **바인딩 1행 INSERT**만 하면 가격계산.
- **BLOCKED = 4건(072·077·082·100)**. 공통 차단사유 = **표지/내지/면지/base24 comp가 라이브 0행** → 부품 합산형 PRF가 가리킬 가격구성요소가 없음. comp 신규 mint + 단가행 적재 + PRF 정의 + 배선이 전부 필요(돈 크리티컬·설계가 범위 밖). search-before-mint 원칙상 §18 + dbm-ddl-proposer/dbm-load-execution 위임.
- **선정 파일럿 = 097 떡메모지** (유일 READY·최단순·선행의존 0·신규 mint 0).

---

## 1. 5건 × {PRF·comp·단가·선행의존·바인딩} 상세 매트릭스 (라이브 실측 근거)

### 1.1 PRD_000097 떡메모지 — 🟢 READY (파일럿 선정)

| 점검축 | 상태 | 라이브 실측 근거 (2026-06-25 SELECT) |
|---|---|---|
| **(1) PRF 공식 정의** | ✅ READY | `t_prc_price_formulas`: `PRF_TTEOKME_FIXED`(frm_nm="떡메모지 사이즈/권당장수/장수별 단가"·use_yn=Y) **실재**. set-price-authority "라이브 미존재" 판정은 부정확 — 라이브 실측이 권위. |
| **(2) formula_components** | ✅ READY | `t_prc_formula_components`: PRF_TTEOKME_FIXED → COMP_TTEOKME(disp_seq=1·addtn_yn=Y) **배선 완료**. |
| **(3) price_components** | ✅ READY | `t_prc_price_components`: COMP_TTEOKME(comp_typ=PRC_COMPONENT_TYPE.06 완제품가·prc_typ=PRICE_TYPE.01 단가형·use_dims=`["siz_cd","bdl_qty","min_qty"]`·use_yn=Y) **실재**. 신규 mint 불요. |
| **(4) component_prices 단가행** | ✅ READY | `t_prc_component_prices`: COMP_TTEOKME **112행** 실재(siz 2종·bdl 2종·min_qty 6..600·apply_ymd 전건 2026-06-01). verbatim 샘플: 90x90/50장 6권=3,000·30권=2,000·600권=850. proc_cd·opt_cd·clr_cd 전건 NULL. 가격표(260527) 권위와 round-16 무손실(580=580) 검산. |
| **(5) 선행의존** | ✅ 없음 | §18 W1(책자 제본비 stale 배선)·W2(중철 단가행)는 **책자류 전용**(068~071·072/077/082). 떡메는 단일 완제품 통합단가형이라 제본비 comp·면지·표지 비목 무관. 구성원 098 자재 백모조120=MAT_000073 배선 OK(set-member-wiring-board L28). |
| **(6) 바인딩** | 🟡 1행 누락 | `t_prd_product_price_formulas`: PRD_000097 바인딩 **0행**(실측). round-16 "단절2 = 떡메 바인딩 누락"과 동일. → **유일 작업 = 바인딩 1행 INSERT**(PRD_000097→PRF_TTEOKME_FIXED·apply_bgn_ymd=2026-06-01). 실 PK=(prd_cd,apply_bgn_ymd)·멱등 DRY-RUN delta 0 입증. |
| **(7) 구성원 가격공식** | ✅ 이중합산 0 | 구성원 PRD_000098(떡메모지-내지·PRD_TYPE.02 반제품) 가격공식 바인딩 **0행** → 구성원 비기여. COMP_TTEOKME가 내지/표지/제본 전부 내장하는 완제품 통합단가 → 이중합산 위험 0(고정가형 정합). |

→ **종합 READY**: 신규 PRF/comp/단가행 mint 0. 바인딩 1행만으로 evaluate_set_price 가격계산 가능.

### 1.2 PRD_000072 하드커버책자 — 🔴 BLOCKED

| 점검축 | 상태 | 라이브 실측 근거 |
|---|---|---|
| **(1) PRF** | ❌ 미존재 | `PRF_HC_MUSEON_SUM` `t_prc_price_formulas` 0행(실측). §18 설계 제안 단계. |
| **(2/3) comp** | ❌ 0행 | 표지/내지/면지 comp = **0행**(`comp_nm LIKE '%표지/내지/면지%' AND use_yn=Y` COUNT=0·실측). §18 G-BK-3 일치. PRF 6비목(내지인쇄·표지인쇄·표지코팅·제본·용지·후가공)이 가리킬 구성요소 부재. |
| **(3') 재사용 후보** | 🟡 부분 | COMP_PAPER(용지비·use_dims=[plt_siz_cd,mat_cd])·COMP_PRINT_DIGITAL_S1/S2(인쇄비)·COMP_BIND_TWINRING(제본비) 실재 — 재사용 후보이나 §18 §3.2대로 표지/내지 용지·인쇄 단가가 책자 절가를 담는지 **재대조 필요(Q-BK-COVER 미해소)**. |
| **(4) 단가행** | 🟡 분산 | 제본비=가격표 제본 시트 B02(실재)·표지/내지 용지·인쇄=디지털인쇄 종이비/인쇄비 시트(별 시트·분산). 단일 셋트 단가표 부재 → comp별 신규 단가행 조립 필요. |
| **(5) 선행의존** | 🔴 W1·W2 | §18 W1(PRF_BIND_SUM stale COMP_BIND_JUNGCHEOL→COMP_BIND_TWINRING 재배선)·W2(중철 단가행 verbatim 교정)가 책자 제본비 정합 전제. 미해소(07_prereq/remediation W1만 GO 조건부·W2 미적재). |
| **(6) 바인딩** | ❌ 미바인딩 | PRD_000072 바인딩 0행. |
| **(7) 구성원** | ✅ 반제품 | 구성원 073(표지)·074/075/076(면지) 전부 PRD_TYPE.02. 셋트 구성 실재. 구성원 가격공식 유무 미점검(comp 부재로 무의미). |

→ **BLOCKED**: 부품 합산형은 표지/내지/면지 comp 신규 mint + 단가행 적재 + PRF 정의 + 배선이 필수. 돈 크리티컬·설계가 범위 밖(가격공식 신설 금지). §18 engine-design-booklet §3 + dbm-ddl-proposer/dbm-load-execution 위임.

### 1.3 PRD_000077 레더 하드커버책자 — 🔴 BLOCKED (072 동형)

072와 동일 차단(PRF_HC_MUSEON_SUM 공유·표지=레더 078). comp 0행·선행의존 W1/W2·바인딩 미존재. 구성원 078(레더표지)·079/080/081(면지) PRD_TYPE.02.

### 1.4 PRD_000082 하드커버 링책자 — 🔴 BLOCKED

072 차단 + **면지인쇄비·면지코팅비 2비목 추가**(8비목 Σ·표지/면지 ×2). PRF_HC_TWINRING_SUM 미존재. comp 0행. 구성원 083(표지)·084/085/086(면지)·087(인쇄면지) PRD_TYPE.02. 선행의존 W1/W2 동일.

### 1.5 PRD_000100 포토북 — 🟡 PARTIAL → 🔴 BLOCKED

| 점검축 | 상태 | 근거 |
|---|---|---|
| **(1) PRF** | ❌ 미존재 | `PRF_PHOTOBOOK_SUM` 0행. §18 engine-design-photobook 설계 제안. |
| **(2/3) comp** | ❌ 0행 | base24(기본24p 통합단가)·per2p(2p 증분) comp = **0행**(`comp_cd LIKE '%PHOTOBOOK/PB_BASE/PER2P%' OR comp_nm LIKE '%포토북%'` COUNT=0·실측). |
| **(4) 단가행** | 🟡 미특정 | 권위 = photobook-l1(`포토북(가격포함)`·row15 "상품단가+페이지당단가"). base24[siz,표지타입]+per2p[siz] 평면화 미수행(round-16 postcard-book-memo와 달리 포토북 단가표 분해 산출 부재 — 추가 추출 필요). |
| **(5) 선행의존** | 🟡 표지5종 | 표지 5 variant(하드커버/아트250+무광/레더하드/레더/소프트) base24에 internalize 여부 §18 §14 정합 확인 필요. |
| **(6) 바인딩** | ❌ 미바인딩 | PRD_000100 바인딩 0행. |
| **(7) 구성원** | ✅ 반제품 | 구성원 101(내지)·102/103/105/106/107(표지5종)·104(면지) 전부 PRD_TYPE.02. |

→ **BLOCKED**: base24/per2p comp 신규 mint + 단가표 평면화(photobook-l1 추출) + PRF 정의 + 표지타입 차원 설계 필요. 설계가 범위 밖.

---

## 2. 신규 mint 항목 집계 (search-before-mint)

| 항목 | 097 떡메 | 072/077 HC | 082 HC링 | 100 포토북 |
|---|---|---|---|---|
| PRF 신규 정의 | **0** (실재) | 1 (PRF_HC_MUSEON_SUM·공유) | 1 (PRF_HC_TWINRING_SUM) | 1 (PRF_PHOTOBOOK_SUM) |
| price_components 신규 | **0** (COMP_TTEOKME 재사용) | 다수(표지/내지/면지 인쇄·용지·코팅) | 다수(+면지 인쇄/코팅) | 2 (base24·per2p) |
| component_prices 신규 | **0** (112행 실재) | 다수(분산 단가 조립) | 다수 | 다수(평면화 필요) |
| formula_components 배선 | **0** (실재) | 다수 | 다수 | 2+ |
| 바인딩(t_prd_product_price_formulas) | **1행** | 1행 | 1행 | 1행 |

→ **097만 신규 mint 0**(바인딩 1행=상품↔공식 연결, mint 아님). 나머지는 comp/단가/공식 전부 신규 → search-before-mint 위반 회피 위해 BLOCKED 분리.

---

## 3. 선행 의존 (책자류 전용)

- **§18 W1**: PRF_BIND_SUM이 삭제(del_yn='Y') COMP_BIND_JUNGCHEOL 참조(stale) → 활성 COMP_BIND_TWINRING 재배선. **072/077/082 제본비 정합 전제.** 07_prereq/remediation에서 W1 자재계층 부활분만 GO(조건부)·제본비 재배선 자체는 미적재.
- **§18 W2**: COMP_BIND_TWINRING/PROC_000018(중철) 8행이 트윈링값 오염 → 가격표 B01 중철 verbatim 교정(돈 크리티컬·과청구 50%). 미적재.
- **떡메(097)는 선행의존 0** — 제본비 comp·면지·표지 비목 무관(완제품 통합단가형).

---

## 4. CONFIRM / BLOCKED 라우팅

| ID | 항목 | 라우팅 | 사유 |
|---|---|---|---|
| BLK-072/077 | HC책자 부품 comp·PRF·단가 | §18 booklet §3 + dbm-ddl-proposer/dbm-load-execution | comp 0행·신규 mint 다수·선행 W1/W2 |
| BLK-082 | HC링 부품 comp(+면지) | 동상 | 동상 + 면지 비목 |
| BLK-100 | 포토북 base24/per2p comp·단가 평면화 | §18 photobook + dbmap(photobook-l1 추출) | comp 0행·단가표 미분해 |
| CFM-097 | 떡메 바인딩 apply_bgn_ymd=2026-06-01 적정성 | 인간 확인(round-16 Q-PCB-2 동일) | 엽서북 바인딩·단가행 적용일과 동일 가정(추정 회피) |
| CFM-BK-COVER | 책자 표지/내지 용지·인쇄 단가가 COMP_PAPER/디지털 인쇄비 재사용 가능한지 | §18 검증가(Q-BK-COVER) | 재사용 vs 신규 mint 결정 |
