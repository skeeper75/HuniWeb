# gate-equivalence-report.md — 후니 위젯 ↔ RedPrinting 행위 동등성 게이트 (통합 교차검증)

> 목적: 후니 React-in-Shadow-DOM 위젯(`04_build`)이 라이브 RedPrinting 위젯과 **행위 동등**한지 4 가격모델 × 4 차원 매트릭스로 셀별 판정.
> 방법: 경계면 교차비교(huni 구현 코드 ↔ Red 캡처/레퍼런스 shape 대조). "필드 존재"가 아니라 "shape 일치"가 판정 기준.
> 실행: vitest 76/76 GREEN, Playwright 실렌더(8 상품) + Shadow DOM 구조 추출, 캡처 reqBody 필드셋 대조.
> 게이트 일시: 2026-06-03. 입력: 3 완전성 감사(reverse-structure/runtime-behavior/live-reinforcement) 전부 CLEARED + B3 정정 매핑.
> 회의적 검증가 원칙: 통과 합리화 금지 — DIVERGENCE를 찾는다.

---

## 0. 게이트 타깃 (B3 정정 매핑 반영)

| 4모델 | 대표 productCode | Red price_gbn | Red PRICE>0 베이스라인 | 04_build fixture 보유 |
|-------|------------------|---------------|------------------------|----------------------|
| PriceTable3D | PRBKYPR(책자) | book2025_price | 73,000 | **O** (product_PRBKYPR.json) |
| SizeMatrix2D | AIPPCUT(에코백) | real_price | 3,300 (off-grid=0) | **X** ← **결함 F-1** |
| FixedUnit | STPADPN(스티커) | vTmpl_price | 4,000 | **O** (product_STPADPN.json) |
| TieredDiscount | GSBGRDY(레디백) | tiered_price | 15,000 (discPct=0 평탄) | **X** (GSTGMIC=tiered 보조만 보유) |

---

## 1. 4×4 판정 매트릭스 (재검증 후 — 2026-06-03 2차)

| 모델 \ 차원 | ① 동작·데이터 | ② 가격 정확성 | ③ 시각(구조/배치/FORM) | ④ 인터랙션 흐름 |
|-------------|:---:|:---:|:---:|:---:|
| **PriceTable3D** (PRBKYPR) | **PASS** | **PASS** | **PASS-with-known-diff** | **PASS** |
| **SizeMatrix2D** (AIPPCUT) | **PASS** | **PASS** ✅(F-1·F-2 해소) | **PASS-with-known-diff** | **PASS** |
| **FixedUnit** (STPADPN) | **PASS** | **PASS** | **PASS-with-known-diff** | **PASS** |
| **TieredDiscount** (GSBGRDY/GSTGMIC) | **PASS** | **PASS-with-note** (F-3 비차단) | **PASS-with-known-diff** | **PASS** |

> PASS-with-known-diff = 구조/배치/FORM은 Red와 동등하나 8개 의도된 후니 스킨 편차(§3) 적용 — 실패 아님.
> PASS-with-note = 직렬화 shape·응답 소비 전부 PASS. 게이트 셀의 정대표(GSBGRDY) fixture만 미보유(F-3, 사용자 의도 deferred) — 비차단.
> **1차→2차 변경**: SizeMatrix2D ② CONDITIONAL→**PASS**(F-1/F-2 독립 재검증 해소). TieredDiscount ② CONDITIONAL→**PASS-with-note**(F-2 해소, F-3만 비차단 잔존).

### 1.1 F-1/F-2 재검증 증거 (독립 — 빌더 자가보고 미신뢰)

| 검증 | 방법(내 손으로 실행) | 결과 |
|------|---------------------|------|
| 재현 게이트 | `npx tsc --noEmit` / `npx vitest run` / `npx vite build` | tsc **0 에러** · vitest **84 passed (12 files)**(76→84, +8 신규 shape 테스트) · build **OK**(165 modules, dist/widget.js 756KB) |
| F-2 직렬화 shape | `npx vite-node`로 serializer 직접 실행(빌더 테스트 무관) → 캡처 b1_AIPPCUT(rel 2893)와 필드 대조 | TOP `["dataJson"]` ✓ / inner `[ORD_INFO,PCS_INFO,mb_cust_cod,price_gbn]` ✓ / mb_cust_cod `10000000` ✓ / price_gbn `real_price` ✓ / PCS_COD `[BON_SHT,CUT_ZUN,SUB_MTR]` ✓ / ORD값 CUT300x340·ORD_CNT1·PRN_CNT1·CLR0·MTRL PXPLP001 ✓. **유일 델타=DOSU_COD(의도 omit, OPEN-1 — PRN_CLR_CNT가 도수의미 운반)** |
| F-2 신규 테스트 진정성 | `red-adapter-price-serialize-shape.test.ts` 정독 | 런타임 `readFileSync('05_qa/captures/b1_AIPPCUT.json')`로 **실 캡처 로드**(line 26,35-45), `ourKeys===capturedKeys`(97)·mb_cust_cod(110)·ORD_INFO field-for-field vs `capturedOrd`(139-147)·price_gbn(163)·PCS reverse-map(181) 단언. 책자 분리필드(CVR_/INN_*/PAGE_CNT) 별도 cell(202-213) + 단일면 누출금지(215-231). **이전 76이 놓친 "직렬화 출력 ↔ 실 캡처" 대조를 정확히 봉인** |
| F-2 가드 불변 | s6/goods-pouch 기존 테스트 diff 정독 | ORD_CNT&&PRN_CNT 가드(isPriceRequestQuotable) 불변. 기존 2 테스트는 `body.X`→`body.dataJson.X` **경로만 기계적 갱신**(단언·기대값 byte-identical, 약화 0) |
| F-1 fixture 폴백 제거 | `fixture-source.ts:81-91` 정독 | `PRODUCTS[code] ?? productPRBKYPR` 폴백 삭제 → 미보유 시 `throw new Error('unknown product')`. widget-store.ts:160-161이 catch→`status:'error'` 표면화 |
| F-1 AIPPCUT 실렌더 | `npm run dev :5173` + Playwright `/?p=AIPPCUT` | 라벨 `규격/용지/인쇄도수/**에코백**/수량/기본작업`, isBook=**false**. SUB_MTR add-on(캔버스 내추럴/화이트/블랙/면14수) 렌더. summary **SUB_MTR 3,300원 → 합계 3,300원**(=Red real_price 베이스라인, PRICE>0 round-trip 렌더). 책자 가장 사라짐 |
| F-1 unknown 비폴백 | Playwright `/?p=ZZUNKNOWN9` | bodyLen=0(빈 렌더, 책자 가장 **없음**), 콘솔에러 0. 침묵 책자폴백 제거 확정 |
| INV-3 코어 불변 | `git diff --stat HEAD -- src/widget src/contract` | **0 변경 + 0 untracked**. 변경은 adapters/red(3) + 기존 테스트(2) + 신규 테스트(1) + 신규 fixture(2)에 국한 |

---

## 2. 차원별 셀 findings (증거 file:line)

### ① 동작·데이터 — 4모델 PASS

- **캐스케이드 알고리즘 정합**: huni `cascade.ts:16-80`(applyCascade) = Red `cascade-rules.md:46-54` 알고리즘 1:1. material 변경→`disableRules.filter(triggerValueId)`→group/value disable→선택 연쇄해제→(store 가격재계산). huni는 추가로 **전 자재그룹 disabled 재계산**(`cascade.ts:37-48`)으로 자재 복귀 시 re-enable까지 처리(Red 명세 우위 구현, 회귀 안전).
- **실렌더 캐스케이드 확인**: PRBKYPR baseline 5 disabled 버튼 관측(essential/hidden + 기본자재 disable). 비자재 그룹 변경은 disable 캐스케이드 스킵(`cascade.ts:25`) = Red(자재만 트리거) 정합.
- **에디터 라이프사이클 이벤트 계약**: huni `editor-bridge.ts:119-148` action 분기 = Red B2 6이벤트(`b2_editor_PRBKYPR/GSTGMIC.json`) + `editor-bridge-protocol.md:54-83`. `load-project-report/ready-to-listen/doc-changed/request-prod-info/project-id-created` 전부 핸들링. 책자도 굿즈와 동일 6이벤트(live-reinforcement §2.2 확정) → huni 면별(표지=editor/내지=pdf, `red-adapter.ts:62-63`) 분기와 정합.
- **상태전이**: dosu↔PRN_CLR_CNT 평면화(`price.ts:40-50`), material 분리(default/inner, `price.ts:52-61`) — Red 표지/내지 분리 구조 echo.

### ② 가격 정확성 — server-authority/opaque 전제 하 직렬화·소비 검증

판정 축 = (a) 직렬화 reqBody shape가 Red 캡처와 일치 (b) 응답 PRICE/ORG_PRICE 소비·표시 정합.

**(b) 응답 소비 — 4모델 PASS**:
- `mapPriceResponse`(`red-adapter.ts:429-459`) 3단 워터폴(PRICE_MALL≠PRICE→ORG_PRICE≠PRICE→ORG_PRICE) = `price-engine-reversed.md:81-87` 정합.
- 실렌더 표시 확인: STPADPN 합계 **4,000원**(=Red FixedUnit 베이스라인, gate_STPADPN.png), PRBKYPR/GSPUFBC/GSTGMIC 워터폴 라인 평면화 렌더.
- 침묵 PRICE=0 가드: `red-adapter.ts:415-425`(isPriceRequestQuotable: ORD_CNT≥1 && PRN_CNT≥1, 위반 시 ok:false 명시) = s5-pouch-live-note §② 결함 재현 금지. vitest `s6-calendar.test.ts:176`·`red-adapter-goods-pouch.test.ts:7` GREEN.

**(a) 직렬화 shape — 핵심 DIVERGENCE (F-1·F-2·F-3)**:

`serializeRedPriceRequest`(`red-adapter.ts:388-411`) 출력 ORD_INFO 필드셋:
```
{PDT_CD, CUT_WDT, CUT_HGH, WRK_WDT, WRK_HGH, ORD_CNT, PRN_CNT, PRN_CLR_CNT, MTRL_CD}
top-level: {ORD_INFO, PCS_INFO, price_gbn}
```
Red 캡처 실측 ORD_INFO 필드셋(b1_AIPPCUT / s3_rp_GSTGMIC):
```
{PDT_CD, CUT_WDT, CUT_HGH, WRK_WDT, WRK_HGH, ORD_CNT, PRN_CNT, PRN_CLR_CNT, MTRL_CD, DOSU_COD}
top-level: {ORD_INFO, PCS_INFO, price_gbn, mb_cust_cod} + {dataJson:{...}} 래핑
```

| 델타 | huni | Red 실측 | 분류 | 근거 |
|------|------|----------|------|------|
| `dataJson` 래퍼 | **없음** | 있음(전 캡처) | **F-2 잠재결함** | data-adapter.md:80 명세는 `{dataJson:{...}}`. serialize/stub/fixture 어디에도 미추가. fixture 경로는 HTTP body 미발신이라 미발현 |
| `mb_cust_cod` | **없음** | `"10000000"`(전 캡처) | **F-2 잠재결함** | data-adapter.md:86 명세는 `customerTier??'10000000'`. serialize에 미구현 |
| `DOSU_COD` | **없음(의도)** | `SID_X`/`SID_S` | **의도 omit(OPEN-1)** | s6-calendar.test.ts:122,151: PRN_CLR_CNT가 도수 가격의미 운반, fixture round-trip PRICE>0로 "추가 불요" 판정·테스트됨 |

> **회의적 판정**: F-2(dataJson 래퍼 + mb_cust_cod 누락)는 fixture 경로가 HTTP를 우회(`fixture-source.ts:82-116`은 reqBody 무시·productCode prefix로 canned 응답 반환)하므로 **현재 76 테스트가 잡지 못하는 latent 결함**이다. 실 HTTP BffClient 배선 시 Red 엔드포인트는 `dataJson` 미래핑·`mb_cust_cod` 누락 reqBody를 거부하거나 침묵 0을 낼 수 있다. data-adapter §0/§2.4가 "어댑터/BFF 책임"으로 경계 지정했으므로 **위젯 코어 결함은 아니나, Red 어댑터 직렬화의 미완성**이다.

**모델별 ② 판정**:
- PriceTable3D(PRBKYPR): PASS — 응답 소비·워터폴·q×p 매트릭스 정합(price-engine-reversed.md:91-147). 단 직렬화는 책자 분리필드(`PAGE_CNT/CVR_CLR_CNT/INN_CLR_CNT/CVR_MTRL_CD/INN_MTRL_CD`, data-adapter.md:81-84)를 **flat 단일 PRN_CLR_CNT/MTRL_CD로만** 출력 → 표지/내지 색·자재 분리가 reqBody에 미반영(F-2 연장). fixture round-trip은 통과하나 실 HTTP에선 책자 분리가격 미산정 위험.
- SizeMatrix2D(AIPPCUT): **CONDITIONAL** — Red 베이스라인 3,300(b1_AIPPCUT)은 확보됐으나 **04_build에 product_AIPPCUT.json fixture 부재(F-1)**. AIPPCUT 로드 시 `fixture-source.ts:78`이 **침묵 PRBKYPR 폴백** → 게이트가 AIPPCUT을 검증 못 함(렌더 결과가 책자로 나옴, gate_structure.json 확인). 실재 dimension-matrix 검증은 BNBNFBL(Red 미가격=0)로 대체 가능하나 PRICE>0 round-trip은 불가.
- FixedUnit(STPADPN): PASS — 실가 4,000 round-trip(s2_STPADPN + price_STPADPN_sample fixture) 렌더 확인. 직렬화 ORD_CNT/PRN_CNT 분리 정합.
- TieredDiscount(GSBGRDY): **CONDITIONAL** — GSBGRDY fixture 부재(F-3). GSTGMIC(tiered 보조)는 fixture 보유하나 **fixture-source 라우팅에서 prefix 미매치 → 책자 q30/q300 fixture로 폴백**(GSTGMIC 렌더 합계 56,000원은 tiered 베이스라인 6,000/unit이 아닌 책자 fixture 가격). tiered_price echo·discPct=0 평탄 성격은 sweep_GSTGMIC.json으로 입증됐으나 게이트 셀의 PRICE round-trip은 정대표(GSBGRDY) 부재로 미검증.

### ③ 시각 (구조/배치/옵션배치/컴포넌트 FORM) — 4모델 PASS-with-known-diff

8개 후니 스킨 편차(§3) 정신적 차감 후 구조/배치 대조:
- **PRBKYPR**(gate_PRBKYPR.png): 규격→표지용지(select)→인쇄도수→코팅/날개/면지(LargeColorChip grid)/부분UV/제본방향(finish)→수량(counter)→표지작업(editor)→[내지 섹션]내지용지→내지도수→내지장수(page-counter)→내지작업(PDF)→summary→CTA. 표지/내지 2-zone 분리 = Red 책자 면구조 정합.
- **BNBNFBL**(gate_BNBNFBL.png): dimension-matrix(5000X900 칩/사이즈직접입력/프리셋) + 재단/아일렛/각목/큐방/로프/봉제/고리 finish 캐스케이드. = Red SizeMatrix2D 배치 정합.
- **STPADPN**(gate_STPADPN.png): 규격(option-button)→용지(select)→도수→폴리백(finish)→수량→기본작업(editor)→summary→CTA. 단순 FixedUnit 배치 정합.
- **GSTGMIC**(gate_GSTGMIC.png): 규격(option-button 4종)→용지(select)→도수→수량→기본작업→summary→CTA.

**FORM 레벨 구조 편차(실패 아님, 인지 필요)**:
- **size/material componentType**: huni는 규격을 **option-button**(`red-adapter.ts:190`, componenttype-mapping-matrix L27 — 전 16 fixture size→option-button 의도규칙)으로 렌더. Red 라이브(e2e_02_product_selected.png)는 규격/용지/인쇄옵션을 **select-box 드롭다운**으로 렌더. → 같은 옵션을 다른 FORM(버튼 vs 드롭다운)으로 표현. 이는 **DESIGN.md 권위의 의도된 componentType 매핑**(값≤6 텍스트→option-button)이며 Red 픽셀 모방이 아닌 후니 디자인 적용 — 사용자 결정(시각재현 = 후니 스킨 적용, Red 구조 보존)에 부합. 배치 순서·옵션 그룹·캐스케이드는 동일.
- **finish-select-box 미산출(D-5 구조결함 후보)**: 어댑터가 PCS 값 개수 무관 항상 finish-button(`red-adapter.ts:126`). DESIGN §7.12는 값 多 후가공을 select형으로 규정. componenttype-mapping-matrix L106-109가 "Red 기준 동작·현 시점 수정 보류"로 트래킹. 값 19개 PCS그룹(BCSPDFT)도 버튼으로 펼침 → DESIGN 의도와 잠재 불일치(후니 후가공 데이터 확정 시 결정).

### ④ 인터랙션 흐름 — 4모델 PASS

- **에디터 origin 보안**: `editor-bridge.ts:113`(origin 검증 payload 파싱 전) — vitest `editor-bridge.test.ts:68`(EVIL origin goto-cart 무시) GREEN. Red `index.html` 핸들러 대비 targetOrigin 명시(`editor-bridge.ts:91-96`, Red "*" 대비 강화).
- **goto-cart 계약**: `info.case` pass-through(`editor-bridge.ts:28,141` — 해석 안 함), tnUrlList fallback(save-doc-report docInfo, `:130-139`). `case` 실값은 cross-origin 헤드리스 미관측(진짜 경계, live-reinforcement §2.3) — 정적 계약(index.html:350-374) 동등성으로 검증. test:73,92 GREEN.
- **업로드/presigned**: `upload-flow.test.ts:29` presigned→S3 PUT→file-meta→artifacts, `:54` non-PDF 거부. = s3-upload-flow.md:9-56 정합.
- **free-input clamp(MAX_CUT)**: leaf clampAxis InputSpec.max=5000(`nc1-live-proof.test.ts:79-92`), 실렌더 사이즈직접입력→가로/세로 numeric input 노출 확인. store는 전달만(INV-1).
- **goto-cart `case` 값**: 게이트 경계로 명시(미관측, 실패 아님).

---

## 3. Known-diff Register — 8 후니 스킨 편차 (의도된 deviation, 실패 아님)

skin-mapping.md + conflicts.md 근거. 시각 차원에서 **격리**(실패로 보고 안 함).

| # | 항목 | 위젯 | DESIGN 기준 | 상태 | 출처 |
|---|------|------|-------------|------|------|
| 1 | image-chip 라벨색 | #979797 | §7.6 #424242 | GAP-1 보류(상품군 미렌더) | conflicts §B GAP-1 |
| 2 | large-color-chip 라벨색 | #979797 | §7.8 미명시 | 회색지대 | skin-mapping #8 |
| 3 | finish-button 폰트 | 14px/600 공용 | §7.11 12px/600 | GAP-3 보류(구조분기 경계) | conflicts §B GAP-3 |
| 4 | ColorChip/ImageChip ring-offset-2 | offset-2 | §7.4 offset 미명시 | AMB-1 회색지대 | conflicts §C AMB-1 |
| 5 | summary 부가세/배송비 행 색 | #424242 | §7.13 item #616161 | AMB-2 회색지대(별도 고정행) | conflicts §C AMB-2 |
| 6 | letter-spacing em 비례 | -0.8px 균일(host -0.05em) | §3 fontSize×-0.05 비례 | AMB-3 회색지대(0.1~0.2px) | conflicts §C AMB-3 |
| 7 | 미선택 버튼 weight | 600 공용 | §7.1 미선택 400 | AMB-4 보류(구조분기 경계) | conflicts §C AMB-4 |
| 8 | select 드롭다운 radius/shadow | r4 + style 명시 shadow | §5 shadow-lg/rounded-b-4 | **CLOSED**(2차 정합, Shadow DOM 변수체인 함정 우회) | conflicts §B GAP-2 |

> 8번은 해소(closed). 1~7은 미선택톤/회색지대/구조분기 경계로 의도적 미적용. 전부 색·폰트·간격·외형 레벨이며 배치·캐스케이드·상태전이(Red 구조 권위)와 무관.

---

## 4. 진짜 경계 (Genuine Boundaries — 실패 아님)

| 경계 | 내용 | 사유 |
|------|------|------|
| goto-cart `case` 실값 | 미관측 | cross-origin Edicus iframe 내부 캔버스 저장 필요. 헤드리스 한계. 호스트 수신 계약(index.html:350-374)은 정적 확정, huni pass-through 검증 완료 |
| off-grid real_price=0 | AIPPCUT 자유치수=PRICE 0 | real_price=등록 그리드 룩업(연속공식 아님). off-grid=0은 Red 정상거동(live-reinforcement §1.2). 위젯은 수치 전달만 |
| 포스터 BNBNFBL/BNPTPET PRICE=0 | Red 미가격 상품 | Red가 단가 0 등록(live-reinforcement §1.3 진단). real_price 엔드포인트 정상(AIPPCUT 3300 대조) — 위젯 결함 아님 |

---

## 5. 발견 결함 목록 (심각도)

| ID | 심각도 | 차원/모델 | 내용 | 재현/기대/실제 | 파일:라인 |
|----|--------|-----------|------|----------------|-----------|
| **F-1** | ~~MAJOR~~ → **RESOLVED**(2차) | ②/SizeMatrix2D | product_AIPPCUT.json fixture 부재 → AIPPCUT 로드가 PRBKYPR로 침묵 폴백 | **해소 검증**: `fixture-source.ts:86-90` 폴백 삭제→unknown throw. 신규 `fixtures/product_AIPPCUT.json` + `price_AIPPCUT_sample.json`. 실렌더 `/?p=AIPPCUT`→에코백 구조 + 합계 3,300원, `/?p=ZZUNKNOWN9`→빈 렌더(책자 가장 없음) | `fixture-source.ts:81-103` |
| **F-2** | ~~MAJOR~~ → **RESOLVED**(2차) | ②/전모델 | serialize reqBody가 dataJson 래퍼 + mb_cust_cod 누락 + 책자 분리필드 미출력 | **해소 검증(독립 vite-node 실행)**: 출력 `{dataJson:{ORD_INFO,PCS_INFO,mb_cust_cod,price_gbn}}` = 캡처 b1_AIPPCUT field-for-field 일치(유일 델타=DOSU_COD 의도 omit). 책자만 CVR_/INN_*/PAGE_CNT 출력. 신규 shape 테스트가 실 캡처와 대조 | `red-adapter.ts:394-433`, `red-types.ts:RedPriceReqBody`, `test/red-adapter-price-serialize-shape.test.ts` |
| **F-3** | **MINOR(비차단, 사용자 deferred)** | ②/TieredDiscount | GSBGRDY(정대표) fixture 부재 + GSTGMIC fixture-source prefix 미매치로 책자가격 폴백 | tiered_price 성격(discPct=0 평탄)은 sweep_GSTGMIC.json으로 입증. 직렬화 shape·응답 소비 PASS. 정대표 PRICE round-trip만 공백 — 사용자가 비차단으로 deferred | `fixture-source.ts` (GSBGRDY 미보유) — 후속 GSBGRDY fixture 추가로 보강 |
| F-4 | INFO(트래킹) | ③/전모델 | finish-select-box 임계치 분기 부재(값 多 PCS도 finish-button) | DESIGN §7.12 값 多→select. 어댑터 항상 finish-button. Red 기준 동작 | `red-adapter.ts:126` (pcsComponentType(false) 고정) — D-5 트래킹 |

---

## 6. BOTTOM-LINE 게이트 판정 (2차 재검증 후 — FINAL)

## **GO** (F-3·F-4 비차단 note 동반)

**근거:**

위젯 **코어**(옵션 캐스케이드 룰엔진·상태전이·에디터 브릿지 origin보안/계약·업로드 presigned·free-input clamp·응답 워터폴 소비)는 4모델 전부 Red와 **행위 동등(PASS)**이며 vitest **84/84** + 실렌더로 입증. 시각은 8 known-diff 차감 후 구조/배치/캐스케이드가 Red 권위와 동등(PASS-with-known-diff). 인터랙션 4축 전부 PASS.

**1차 CONDITIONAL-GO를 막던 2 MAJOR 결함 = 독립 재검증으로 해소 확인(빌더 자가보고 미신뢰, 내 손으로 증거 수집):**

1. **F-2 RESOLVED** — `serializeRedPriceRequest`(red-adapter.ts:394-433)가 이제 `{dataJson:{ORD_INFO,PCS_INFO,mb_cust_cod,price_gbn}}` 출력. **내가 vite-node로 직접 실행**한 serializer 출력이 캡처 b1_AIPPCUT(rel 2893) reqBody와 TOP/inner/ORD_INFO/mb_cust_cod/price_gbn/PCS_COD **field-for-field 일치**(유일 델타=DOSU_COD, 의도 omit OPEN-1 — PRN_CLR_CNT가 도수의미 운반). 책자만 CVR_/INN_*/PAGE_CNT 출력(단일면 누출 0). 신규 `red-adapter-price-serialize-shape.test.ts`는 **실 캡처를 readFileSync로 로드해 대조**(이전 76이 놓친 정확한 갭 봉인). 가드(ORD_CNT&&PRN_CNT) 불변, 기존 2 테스트는 경로만 갱신·약화 0.
2. **F-1 RESOLVED** — `fixture-source.ts:86-90` 침묵 PRBKYPR 폴백 삭제→unknown product throw. `product_AIPPCUT.json`+`price_AIPPCUT_sample.json` 추가. **실렌더 확인**: `/?p=AIPPCUT`→에코백 SizeMatrix2D 구조(SUB_MTR add-on) + **합계 3,300원**(=Red real_price 베이스라인, PRICE>0 round-trip 렌더). `/?p=ZZUNKNOWN9`→빈 렌더(책자 가장 사라짐). SizeMatrix2D ② 셀이 공허→실증으로 전환.

**INV-3 코어 불변 재확인:** `git diff --stat HEAD -- src/widget src/contract` = **0 변경·0 untracked**. 모든 변경은 adapters/red + 테스트 + fixture에 국한(위젯 코어 무손상).

**비차단 잔존(GO 방해 안 함):**
- **F-3 (MINOR, deferred)** — TieredDiscount 정대표 GSBGRDY fixture 미보유. tiered 성격은 sweep로 입증, 직렬화·소비 PASS. 사용자가 비차단으로 deferred(정대표 round-trip만 공백). 후속 GSBGRDY fixture로 보강.
- **F-4 (INFO)** — finish-select-box 임계치 분기 부재. Red 기준 동작. 후니 후가공 데이터 확정 시 결정.

**핵심 통찰(회의적, 최종):** 1차에서 "fixture 스텁이 가린 latent 직렬화 갭"이 핵심 NO-GO 후보였고, 2차에서 **그 갭을 정확히 겨냥한 실-캡처-대조 테스트가 추가되고 직렬화가 캡처와 정합**됨을 독립 실행으로 확인했다. 위젯 코어는 동등하며, 이제 "Red API와 실제로 통신 가능한 reqBody"도 갖췄다. F-3/F-4는 비차단 note로 추적하되 게이트 통과를 막지 않는다. → **GO. 후니 전용 작업 착수 가능.**
