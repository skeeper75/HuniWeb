# asset-inventory.md — 가격계산 API 동등성 검증 자산 인벤토리 (파일럿 범위)

> Phase 1 / hrev-asset-curator. **파일럿 = 가격계산 API** `get_ajax_price_vTmpl` 단일 종단.
> 원칙: 역공학·테스트베드 재구축 금지 — 기존 자산 위에 동등성 검증 레이어만. 모든 자산은 grep/Read로 실재 확인.
> 권위순서: 디옵 코드/라이브 런타임 > 캡처 샘플 > 리포트 서술 > 추론.

---

## A. §6 재구성 가격경로 (`_workspace/huni-widget/04_build`)

검증 대상 = "역공학한 가격요청 조립·전송 코드가 라이브와 동작 동등한가". 실 grep 확인:

| 자산 | 경로 | 역할 | 가격 검증 관련성 |
|------|------|------|------------------|
| **serializeRedPriceRequest** | `src/adapters/red/red-adapter.ts:570-631` | NormalizedPriceRequest → Red reqBody `{dataJson:{ORD_INFO,PCS_INFO,price_gbn,mb_cust_cod}}` 직렬화 | **VP-1 핵심** — 이게 emit하는 reqBody가 골든 캡처와 byte 정합인지 |
| **isPriceRequestQuotable** | `src/adapters/red/red-adapter.ts:635-637` | ORD_CNT≥1 && PRN_CNT≥1 가드(침묵 PRICE=0 재현 금지) | VP-3 오라클 sanity 가드 |
| **mapPriceResponse** | `src/adapters/red/red-adapter.ts:649-690` | 응답 3단 워터폴(PRICE_MALL→PRICE→ORG_PRICE)+`result_sum` 평면화·`ok=retCode===200 && finalPrice>0` | VP-4 권위 읽기(`result_sum` only) |
| **RedPriceReqOrdInfo / RedPriceReqInner / RedPriceReqBody** | `src/adapters/red/red-types.ts:166-200` | 요청 reqBody shape 타입(PDT_CD/CUT/WRK/ORD_CNT/PRN_CNT/PRN_CLR_CNT/MTRL_CD + 책자 CVR_/INN_*/PAGE_CNT) | VP-6 필드사전 정합의 우리측 권위 |
| **RedPriceResponse / RedPriceLine** | `src/adapters/red/red-types.ts:128-154` | 응답 구조(result[].PCS_CD/PRICE/PRICE_VAT/PRICE_MALL + result_sum{PRICE,PRICE_VAT,PRICE_MALL,...}) | VP-2 차등 비교 대상 |
| **NormalizedPriceRequest 계약** | `src/contract/price.ts` (price.ts:27 ORD_INFO 분기 주석, SelectedFinish) | 위젯↔어댑터 정규화 계약(quantity/printCount/dimensions/colorCounts/materials/selectedFinishes/customerTier/priceSchemeKey/itemGroup) | 입력 차원 사전 |
| **buildPriceRequest** | `src/widget/stores/price.ts` (store → NormalizedPriceRequest) | 위젯 상태 → 정규화 가격요청 | VP-1 입력 조립 경로 |
| **fixture-source.ts** | `src/adapters/red/fixture-source.ts:76-132` | productCode→canned 응답 라우팅(**HTTP 우회** — F-2 함정의 근원) | [함정] reqBody shape 검증 침묵 회피 가능성 — HTTP 경로로만 닫힘 |

### 가격 관련 fixtures (`04_build/fixtures/`)
- 가격응답 샘플: `price_AIPPCUT_sample.json`, `price_BCSPDFT_sample.json`, `price_BNBNFBL_sample.json`, `price_GSPUFBC_sample.json`, `price_HLCLSTD_sample.json`, `price_HLCLWAL_sample.json`, `price_STPADPN_sample.json`, `price_STTHCIC_sample.json`, `price_q300_p10.json`, `price_q30_p10.json`
- 상품정보 fixtures(~25): `product_*.json` — 대표: `product_PRBKYPR.json`(책자 PriceTable3D), `product_AIPPCUT.json`(SizeMatrix2D), `product_STPADPN.json`(FixedUnit), `product_GSPUFBC.json`(tmpl_price 파우치), `product_GSTGMIC.json`(tiered 보조), `product_BCSPDFT.json`(radius ATTB)
- **`presigned_response_sample.json`** — 업로드 경로(editor 게이트용, 가격 파일럿 외)

### 가격 직렬화 회귀 가드 테스트 (재사용·확장 대상)
- **`test/red-adapter-price-serialize-shape.test.ts`** — F-2 봉인 테스트. 런타임 `readFileSync('05_qa/captures/b1_AIPPCUT.json')`로 실 캡처 로드(line 26,35-45) → `ourKeys===capturedKeys`(97), `mb_cust_cod`(110), ORD_INFO field-for-field(139-157), price_gbn(163), PCS 역매핑(181), 책자 분리필드(208-237). **단 fixture 경로(HTTP 우회) 한정** — 실 HTTP 경로 차등은 미커버(이 하네스가 닫을 갭).
- 기타: `test/red-adapter.test.ts`, `red-adapter-digital.test.ts`, `red-adapter-poster.test.ts`, `red-adapter-sticker.test.ts`, `red-adapter-goods-pouch.test.ts`, `red-adapter-acryl.test.ts`, `s6-calendar.test.ts`, `red-adapter-parity-blockers.test.ts`, `price-cache.test.ts`, `nc1-live-proof.test.ts` (vitest 150 baseline)

---

## B. §6 동등성 게이트 산출 (`_workspace/huni-widget/05_qa`)

| 자산 | 경로 | 내용 |
|------|------|------|
| **gate-equivalence-report.md** | `05_qa/gate-equivalence-report.md` | **이미 GO**(2026-06-03). 4모델(PriceTable3D/SizeMatrix2D/FixedUnit/TieredDiscount) × 4차원(동작·가격·시각·인터랙션). 가격 차원 = "직렬화 shape 캡처 정합 + 응답 소비 워터폴" PASS. **단 fixture round-trip 기준**(실 HTTP 차등 아님). F-3(GSBGRDY fixture 부재)·F-4(finish-select) 비차단 잔존 |
| **qtysweep-attb-analysis.md** | `05_qa/qtysweep-attb-analysis.md` | ATTB 수량 echo 분석 |
| **s5-pouch-live-note.md** | `05_qa/s5-pouch-live-note.md` | 침묵 PRICE=0 진단(ORD_CNT/PRN_CNT 둘 다 필수) |
| **w2a-independent-reverify.md** | `05_qa/w2a-independent-reverify.md` | SUB_MTR 이중의미 독립 재검증 |

### 골든 시드 캡처 (`05_qa/captures/` — 라이브 reqBody+respBody 보유, 재사용 핵심)
가격 검증에 **즉시 재생 가능한 실 캡처**(reqBody+result_sum 포함). capturedAt 2026-06-02~03:

| 캡처 | 상품 | price_gbn | 입증 데이터 | 검증 용도 |
|------|------|-----------|-------------|-----------|
| **b1_AIPPCUT.json** | AIPPCUT(에코백) | real_price | 완전호출(rel 2893) PRICE=3,300 + off-grid PRICE=0 + 빈 mb_cust_cod PRICE=0 진단 | VP-1 golden, VP-3 sanity(0=결함 진단) |
| **qtysweep_GSTGMIC.json** | GSTGMIC(네임택) | tiered_price | PRN_CNT 2→13,600 / 10→66,200(단조증가) · PRT_DFT 외 전 PCS line PRICE=0 | VP-4(per-line 0 트랩) + VP-5 메타모픽(수량↑⇒가격↑) |
| **sweep_GSTGMIC.json** | GSTGMIC | tiered_price | ORD_CNT 1~300, unit=6000 평탄, discPct=0(flatUnit:true) | VP-5 메타모픽 베이스라인 |
| **s5_pouch_GSPUFBC.json** | GSPUFBC(파우치) | tmpl_price | incompleteReqBody(ORD_CNT/PRN_CNT 부재)→PRICE=0 ↔ complete→PRICE=2,850,000 | VP-3 침묵0 결함 재현(필수필드 누락 메커니즘) |
| qtysweep_GSNTSPR.json | GSNTSPR(스프링노트) | tmpl_price | init/qty 호출 PRICE=0(불완전 reqBody, 캡처공백) | [주의] 0=캡처 미완성, 신규 재캡처 후보 |
| major_attbchip_BCFOXXX.json / major_radius_ACTHDKY.json | BCFOXXX / ACTHDKY | - | ATTB 속성칩·사이즈연동 반경 구조 | VP-6 ATTB 다형 검증(D-L1 갭) |
| s2_STPADPN.json | STPADPN(스티커) | vTmpl_price | FixedUnit 4,000 | VP-2 FixedUnit 차등 |
| b2_editor_PRBKYPR.json | PRBKYPR | book2025_price | editor from-edicus 타임라인(editor 게이트용) | 파일럿 외(editor 단계) |

---

## C. §6 가격 parity (`_workspace/huni-widget/07_parity`)

| 자산 | 경로 | 가격 검증 관련성 |
|------|------|------------------|
| **parity-matrix-D1-price.md** | `07_parity/parity-matrix-D1-price.md` | 가격 도메인 코드정합(reqBody 빌더 ↔ deob mod_05/06/07). **이번 하네스의 차등 검증 대상 목록의 원천** — D1-1~D1-15 + LOSS 레지스터 D-L1~D-L8. ★게이트는 GO인데 D1-price는 **ATTB 전손실(D-L1 BLOCKER)·itemGroup 휴리스틱(D-L2 MAJOR)·PRICE=0 ok:true(D-L3 MAJOR)** 미해소로 분류 → 라이브 차등으로 입증 필요 |
| **parity-matrix-P1-normalization.md** | `07_parity/parity-matrix-P1-normalization.md` | L-1 ATTB 정규화 컨텍스트(D1 선행) |
| **red-code-map-05-api.md** | `07_parity/red-code-map-05-api.md` | 트랜스포트(get_ajax_price 호출·dataJson 래핑 mod_05:1138) |
| **red-code-map-06-widget-sdk.md** | `07_parity/red-code-map-06-widget-sdk.md` | reqBody 빌더 위치(mb_cust_cod mod_06:2522·워터폴 mod_06:1284·canOrder mod_06:1167) |
| **red-code-map-07-components.md** | `07_parity/red-code-map-07-components.md` | 후가공별 ATTB 조립 규칙(컴포넌트 emit) |
| **crossverify-round2-findings.md** | `07_parity/crossverify-round2-findings.md` | ★**G-1 ATTB 권위 날조 적발**(삼중) — deob 라인 2954/3572 부존재 인용. ATTB는 PCS_COD 단일축 아닌 엔트리별 다형(속성값/''/장수/prnCnt, ORD_CNT는 0건). **이 하네스 무날조 게이트(VM-3)의 직접 선례** |
| red-code-map-08-editor-sdk.md / parity-matrix-D3-editor.md / D4 | 07_parity/ | editor·cascade(파일럿 외) |

---

## D. 라이브 테스트베드 (`raw/widget_monitor/local`) — 오라클 생산 substrate

| 자산 | 경로 | 역할 |
|------|------|------|
| **server.js** | `raw/widget_monitor/local/server.js` (Express :3001) | 읽기전용 프록시 — `/rp-api`→`www.redprinting.co.kr`에 세션쿠키 주입. **오라클 생산자**(캡처 reqBody를 라이브 가격엔진에 재생→실값). 토큰/쿠키 갱신(`/refresh-token`, `loadSessionCookies()`) |
| **extract-cookies.cjs** | `raw/widget_monitor/local/extract-cookies.cjs` | Playwright 헤드리스 로그인 → `cookies.json`(가격 세션 권위) |
| **qtysweep.cjs** | `raw/widget_monitor/local/qtysweep.cjs` | 수량 스윕 가격 캡처(메타모픽 골든 생산) |
| **s2/s3/s5/s6-*-capture.cjs** | 동 디렉토리 | 카테고리별 캡처(s3-realprice/s5-pouch/s6-calendar 등) |
| **major-capture.cjs / coverage-scan.cjs / coverage-phaseB.cjs** | 동 디렉토리 | 옵션구조 클래스 분류(VP-5 커버리지 denominator) |
| **hw-runtime-capture.cjs** | 동 디렉토리 | editor from-edicus 타임라인(editor 게이트) |
| **catalog.json** | 동 디렉토리 | 174상품 (catName: 굿즈 136·아크릴 20·책자/리플렛 18). ★key=`pdtCode`. AIPPCUT/STPADPN/BCSPDFT는 이 스냅샷 밖(다른 카테고리) — 골든은 05_qa/captures에 이미 존재하므로 무관 |
| **api-log.json / body-log.json** | 동 디렉토리 | 최근(2026-06-22) 호출 로그 — info→price 시퀀스·responseShape byteLength만(reqBody 미보유, shape seed only) |
| **cookies.json** | 동 디렉토리 | 세션쿠키. **mtime 2026-06-23 00:26** — 가격임계 쿠키(PHPSESSID session-only·AWSALB/AWSALBCORS 167h 유효·kisession session-only) 모두 유효. 만료된 건 분석쿠키(_gat_gtag)뿐 → **세션 신선**(B 참조) |
| widget.js(587KB)·RedEditorSDK.min.js·widget.css | symlink | 라이브 위젯 에셋(deob 권위는 `docs/reversing/red_reverse_engineer/03_deobfuscated/`) |

---

## E. 역공학 계약 1차 출처 (`docs/reversing`)

| 자산 | 경로 | 가격 검증 관련성 |
|------|------|------------------|
| **RedPrinting_SDK_Deep_Analysis_Report.html** | `docs/reversing/RedPrinting_SDK_Deep_Analysis_Report.html` | §6.1 가격 API 실 캡처 요청/응답 + **§6.2 요청/응답 필드 사전**(PDT_CD/CUT/WRK/PRN_CNT/CVR_MTRL_CD/INN_MTRL_CD/PCS_COD/PCS_DTL_COD/PRICE/price_gbn/mb_cust_cod). **re-contract-price.md의 1차 권위** |
| RedPrinting_Widget_Analysis_Report.html | `docs/reversing/RedPrinting_Widget_Analysis_Report.html` | 위젯 UI·Pinia 스토어(파일럿 외 widget 단계) |
| red_reverse_engineer/03_deobfuscated/ | `docs/reversing/red_reverse_engineer/03_deobfuscated/` | deob 4모듈(코드정합 권위). ★crossverify가 실증: `deob_07`=2607줄, `deob_06`=1392줄 — 범위 밖 인용=날조 |

---

## F. 미확인 / 리스크
- **api-log/body-log.json은 reqBody 본문 미보유**(responseShape byteLength만) — 실 reqBody 골든은 `05_qa/captures/*`에만. 신규 골든은 capture 스크립트로 재생산 필요(Phase 2).
- **price_gbn 4종 중 tiered 정대표(GSBGRDY) fixture 부재**(F-3) — GSTGMIC(보조)로 대체 캡처 보유. 신규 캡처에서 GSBGRDY 또는 동형 tiered 1건 확보 권장.
- **deob 03_deobfuscated 모듈 라인수 미직접확인**(crossverify-round2가 2607/1392로 기록 — 인용만). VM-3 게이트에서 재검증 필요.
