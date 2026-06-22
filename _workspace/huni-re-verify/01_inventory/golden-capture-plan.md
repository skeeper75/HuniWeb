# golden-capture-plan.md — Phase 2(hrev-golden-recorder) 실행 캡처 계획

> 원칙: **시나리오당 1 HAR/JSON**(누적 금지)·라이브 읽기전용(주문/결제/폼submit 0)·비밀 [REDACTED].
> 오라클 = 라이브 RedPrinting. 캡처 = record-and-replay의 record 절반. denominator = price_gbn 4모델 + coverage-scan 옵션구조 클래스.

---

## 0. 세션 신선도 판정 — ★Phase 2 즉시 실행 가능

- `raw/widget_monitor/local/cookies.json` mtime = **2026-06-23 00:26** (오늘).
- 가격임계 쿠키 상태(값 비노출, 만료만 검사):
  - `PHPSESSID` (www.redprinting.co.kr) = session-only (유효)
  - `AWSALB` / `AWSALBCORS` = 약 167h 잔존 (유효)
  - `kisession` (.redprinting.co.kr) = session-only (유효)
  - 만료된 쿠키 = `_gat_gtag_UA_*` (분석용, 가격 무관) 1건뿐.
- **판정: 세션 신선 → 재로그인 불필요(extract-cookies.cjs 선행 불요)**. server.js 프레시 재시작 후 즉시 가격 캡처 가능.
- ★단 가격 세션은 server.js 프레시 재시작 필요(방법론 함정 #3: in-process refresh가 쿠키 미reload). 캡처 직전 `loadSessionCookies()` 재시작 권장.

---

## 1. 캡처 시나리오 (시나리오당 1 산출)

| 시나리오 | productCode | 캡처 스크립트(재사용) | 옵션 튜플 | 기대 PRICE | 산출 파일 |
|----------|-------------|------------------------|-----------|------------|-----------|
| **G-RP** SizeMatrix2D | AIPPCUT | `s3-realprice-capture.cjs` 패턴 | MTRL PXPLP001, 300×340, SID_X, ORD/PRN=1, PCS[SUB_MTR EC001/CUT_ZUN ZDFRM/BON_SHT SHECO] | 3,300 (검증 베이스라인) | `02_golden/golden_AIPPCUT_real.json`(+HAR) |
| **G-BK** PriceTable3D 책자 | PRBKYPR | `qtysweep.cjs`/info-then-price | 표지/내지 분리(CVR/INN_CLR_CNT·MTRL_CD)+PAGE_CNT, q×p 매트릭스 일부 | >0 | `02_golden/golden_PRBKYPR_book.json` |
| **G-FU** FixedUnit | STPADPN | `s2-sticker-capture.cjs` | 규격·용지·도수·폴리백 | 4,000 | `02_golden/golden_STPADPN_fixed.json` |
| **G-TD** TieredDiscount | GSTGMIC (가능시 GSBGRDY 추가) | `qtysweep.cjs` | PRN_CNT 1·2·5·10·30·100·300 스윕 | 단조증가(2→13,600/10→66,200) | `02_golden/golden_GSTGMIC_tiered.json` |
| **G-TM** tmpl_price | GSPUFBC | `s5-pouch-dump.cjs` | complete(ORD_CNT100·PRN_CNT1) + incomplete(부재) 대조쌍 | 2,850,000 / 0 | `02_golden/golden_GSPUFBC_tmpl.json` |

---

## 2. ★갭 검증 전용 캡처 (D1-price 미해소 — VP-6/manifest §D)

| 시나리오 | productCode | 목적 | 캡처 요건 |
|----------|-------------|------|-----------|
| **G-ATTB** | BCSPDFT(radius) 또는 GSNTSPR(RIN_DFT 링색) | D-L1 ATTB 단가영향 입증 | **qty>1 + ATTB 2개 다른값** 차등쌍(예 RIN_BLK vs RIN_GLD). qty=1 단일캡처 금지(ORD_CNT/상수/material-qty 구분 불가, crossverify-round2 D-1) |
| **G-ITEM** | (책자/의류 경계) | D-L2 itemGroup 오분기 | inner 부재 책자 또는 inner 보유 비책자 존재 여부 라이브 확인 |

---

## 3. 캡처 규약 [HARD]
1. **시나리오당 1 파일** — 누적 금지(방법론 함정 #7). HAR은 `recordHar`/`--save-har`로 versionable.
2. **reqBody + result_sum 둘 다 보존** — reqBody만/respBody만은 차등 불가(N-1/N-2 둘 다 필요).
3. **PRICE=0 캡처는 "진단" 라벨** — 정상값 아님. incomplete reqBody는 결함 재현 의도로만(가드 검증), 정상 골든에 섞지 말 것.
4. **비밀 [REDACTED]** — 쿠키/JWT/presigned는 골든/HAR/스크린샷에 비노출. server.js가 쿠키 주입(요청 헤더에 미기록).
5. **읽기전용** — get_digital_product_info(GET) + get_ajax_price_vTmpl(POST 가격조회=공개 가격정보, SDK Report §8.2①)만. 주문/결제/장바구니/폼submit/에디터저장 0.
6. **오라클 = 라이브** — Red 산식 재유도에 맞추지 않음. 라이브 응답이 진실, 재구성이 그에 정합.

---

## 4. 커버리지 denominator (VP-5)
- `coverage-scan.cjs` / `coverage-phaseB.cjs`가 분류한 옵션구조 클래스를 분모로. price_gbn 5종(real/book2025/vTmpl/tmpl/tiered)은 §1에서 1건씩 커버. 미커버 클래스(의류 clothes2025·ACC 다종자재)는 **dormant 명시**(침묵 통과 금지).
- catalog.json(174상품·굿즈136/아크릴20/책자18)은 굿즈·아크릴·책자 한정 — AIPPCUT/STPADPN/BCSPDFT는 이 스냅샷 밖이나 골든은 05_qa/captures에 기존 보유. 신규 캡처 시 catalog 밖 상품은 직접 pdt_cod로 info 호출.
