# live-reinforcement.md — 행동 동등성 게이트 라이브 보강 (B1·B2·B3)

> runtime-behavior-audit.md가 식별한 3 공백(GAP-1 SizeMatrix2D / GAP-3 에디터 / B3 대표상품 정정)을
> 신선 로그인 세션(`extract-cookies` 재추출, 토큰 valid, 쿠키 14개)으로 라이브 보강.
> 라이브 일시: 2026-06-03, fresh server restart(:3001, 쿠키 메모리 재로드 — HANDOFF §6 준수).
> 캡처 원본: `05_qa/captures/b1_{AIPPCUT,BNBNFBL,BNPTPET}.json`, `b2_editor_{GSTGMIC,PRBKYPR}.json` (전체출력 JWT redact 완료, 누출 0건 검증).
> [HARD] 주문·결제 미트리거(읽기/견적만). 비밀값 평문 기록 없음.

---

## 0. 한 줄 결과

- **B1 [BLOCKER 해소]:** real_price PRICE>0 베이스라인 **확보** — `AIPPCUT(에코백) 등록규격 300X340 → PRICE=3300(개당단가 3300원)`. 동시에 **포스터(BNBNFBL/BNPTPET)의 PRICE=0은 요청 결함이 아니라 "Red가 해당 상품을 미가격(단가 0 등록)으로 응답"임을 결정적으로 진단.**
- **B2 [GAP 해소]:** 에디터 풀플로우 6 from-edicus 이벤트 타임라인 확보. **책자(PRBKYPR)도 굿즈와 동일하게 6이벤트 발화 — 기존 "책자 0이벤트"는 실제가 아니라 캡처 공백**이었음을 확정. `save-doc-report`/`goto-cart`(및 `case`)는 iframe 내부 캔버스 저장이 필요해 헤드리스 미트리거(진짜 경계, 결함 아님).
- **B3 [정정 완료]:** 4 가격모델 대표상품 = **PriceTable3D→PRBKYPR(book2025_price) / SizeMatrix2D→AIPPCUT(real_price, 0×0 sentinel→dimension-matrix) / FixedUnit→STPADPN(vTmpl_price) / TieredDiscount→GSBGRDY(tiered_price)**. ACNTHAP은 vTmpl_price라 SizeMatrix2D 대표 부적격(정정).

---

## 1. B1 — SizeMatrix2D real_price PRICE>0 베이스라인 + PRICE=0 결정적 진단

### 1.1 결과: PRICE>0 확보 (AIPPCUT 에코백)

`b1_AIPPCUT.json` widgetPriceCalls — 위젯이 실제 발신한 완전 reqBody:
```
price_gbn=real_price, 등록규격 300X340
ORD_INFO[0]={PDT_CD:AIPPCUT, MTRL_CD:PXPLP001, CUT_WDT:300,CUT_HGH:340, WRK:300x340,
             ORD_CNT:1, PRN_CNT:1, DOSU_COD:SID_X, PRN_CLR_CNT:0}
PCS_INFO=[{SUB_MTR:EC001,ATTB:1}, {CUT_ZUN:ZDFRM}, {BON_SHT:SHECO}]   ← 에코백 자재 add-on
→ PRICE=3300  (PRICE_LOG "개당단가 : 3300.00원, 인쇄수량:1, 주문건수:1")
```
- 이로써 **2D 차원 상품(real_price = 0×0 sentinel → dimension-matrix-input, red-coverage-matrix.md:176)이 PRICE>0를 내는 실관측 Red 베이스라인 확보**. 게이트가 "0원 vs 0원" 공허 비교를 면함.
- AIPPCUT은 phaseB results에서도 `real_price, price=3300, status=200`로 일치(교차검증).

### 1.2 real_price의 동작 성격 (관측)

| 관측 | 증거 |
|------|------|
| 등록규격(300X340)만 단가 보유 | 자유치수 600×900/1000×2000 주입 시 **개당단가 → 0** (`b1_AIPPCUT.json` manualDiagnosis) |
| PRN_CNT 변경 무영향(이 SKU) | PRN_CNT 1→2 모두 PRICE=3300 (재료 기반 고정단가). FixedUnit/tmpl과 달리 선형배수 아님 |
| 자재 add-on(SUB_MTR/EC001)이 가격에 포함 | 에코백 자재가 PCS_INFO echo로 합산 (red-coverage-matrix.md F5 SUM_MTR 판정 라이브 확인) |

> **시사:** real_price도 FixedUnit·tmpl_price와 동일하게 **"등록된 (규격×자재) 조합의 단가 룩업"**이지 연속 2D 공식이 아니다. SizeMatrix2D = "등록 그리드 룩업, off-grid는 0" — 후니 어댑터는 등록규격 정확매칭 + DFT_YN 선두정렬(CHK-3)을 보장해야 함.

### 1.3 포스터(BNBNFBL/BNPTPET) PRICE=0 결정적 진단 — "Red가 0을 반환" (요청 결함 아님)

신선 로그인 + 완전 reqBody(ORD_CNT+PRN_CNT 확인) + 다중 customer code + 등록규격으로도 **전부 PRICE=0**:
```
b1_BNBNFBL.json:
  등록규격 5000X900, ORD_CNT=1,PRN_CNT=1 → PRICE=0, LOG "개당단가 : 0.00원, 인쇄수량:1, 주문건수:1"
  cust_cod 10000000 / '' (세션위임) 모두 0, 자유치수 600×900/1000×2000 모두 0
b1_BNPTPET.json: 동일 (widgetCalls 6건 maxPRICE=0)
```

**진단 (malformed vs Red-returns-0 구분):**
- 요청은 **정상**: PRICE_LOG가 `인쇄수량:1, 주문건수:1`로 ORD_CNT/PRN_CNT를 정확히 수신함을 확인(침묵-필드누락 벡터 아님). 등록규격(5000X900, productInfo의 sizes select에 실재) 사용. PCS도 위젯이 조립한 것.
- 그럼에도 `개당단가 : 0.00원` → **서버가 이 상품/자재(PXBFCXXX)에 단가를 0으로 보유**. 즉 **Red에서 BNBNFBL/BNPTPET가 미가격(전화주문/미운영) 상품**으로 등록된 것.
- **대조 증거:** 동일 real_price 모델인 AIPPCUT은 정확히 같은 요청 구조로 PRICE=3300 → "real_price 엔드포인트/파라미터 문제 아님"을 입증. 차이는 오직 상품 단가 등록 여부.
- phaseB 전수 스캔에서도 **real_price 대표는 AIPPCUT 1건만 PRICE>0**, 포스터/배너는 46구조 내 미가격군에 속함(red-coverage-matrix.md F8 무지/미가격, BCSPDFT/PRPOSTK 등 9건 price=0과 동류).

> **결론:** GAP-1은 **AIPPCUT로 PRICE>0 베이스라인 확보(해소)** + 포스터 0원은 **"Red 자체가 0 반환(상품 미가격)"으로 결정적 진단**. 게이트의 SizeMatrix2D 대표는 BNBNFBL이 아니라 **AIPPCUT**으로 잡아야 한다(B3 반영).

---

## 2. B2 — 에디터(Edicus) 풀플로우 타임라인 + goto-cart case

### 2.1 from-edicus 6이벤트 타임라인 (굿즈·책자 동일)

`b2_editor_GSTGMIC.json` / `b2_editor_PRBKYPR.json` — 양 상품 동일 시퀀스 실측:
```
편집하기 클릭 → editorNetwork: POST /widget-api/api/editor/config/KOI 200
              → POST /makers-api/token 200 → POST /makers-api/editor 200
              → PUT /makers-api/v1/template/{base64}/hit 200
              → GET /makers-api/v2/template/resource/{id} 500 (직접경로 의존, iframe내부 정상)
──── from-edicus (origin=edicusbase) ────
+0ms     load-project-report  {status:"start", edicus_user_id:null, project_id:null, ps_code}
+~105ms  ready-to-listen      null
+~1.2s   doc-changed          {ps_code, page_count, template_uri, div:"red_widget", vdp_catalog[]}
+~1.2s   request-prod-info    {}
+~1.8s   project-id-created   {project_id}
+~1.8s   load-project-report  {status:"end", edicus_user_id:"redp-redprinting", project_id, ps_code}
```

### 2.2 책자 0이벤트는 캡처 공백이었음 (확정)

| 상품 | from-edicus 이벤트 | ps_code | page_count |
|------|-------------------|---------|-----------|
| GSTGMIC(굿즈) | **6** | `Triangle_S@GSTGMIC` | 1 |
| PRBKYPR(책자) | **6** (동일) | `210x297-PER_DFT-CVR_SFT@PRBKYPR` | **2** (표지+내지) |

- 이전 분석의 "책자 0 editor events"는 **runtime_capture가 에디터를 안 열어서 생긴 캡처 공백**이었고, **책자도 굿즈와 동일하게 에디터 풀플로우를 발화**함을 라이브 확정(GAP-3 책자 측면 해소).
- 책자 psCode는 `{규격}x{규격}-{제본}-{표지가공}@{상품코드}` 형식으로 옵션을 인코딩 — 굿즈 `{템플릿}@{상품코드}`보다 풍부. page_count=2(표지/내지 분리)로 면구조 반영.

### 2.3 save-doc-report / goto-cart `case` — 미트리거 (진짜 경계)

- `gotoCartCaseValues = []` (양 상품). `save-doc-report`/`goto-cart`는 **iframe(edicusbase.firebaseapp.com 별 origin) 내부에서 사용자가 캔버스 편집→저장/주문을 눌러야** 발화. 헤드리스 하네스는 cross-origin Edicus UI를 조작할 수 없음 — **캡처 결함이 아니라 구조적 경계**.
- 단 **호스트 수신 계약은 정적 확정**: `index.html:350-374` 핸들러가 `d.info.case`, `d.info.docInfo.{projectID, tnUrlList, totalPageCount}`를 읽어 주문데이터 조립. `case` 값 종류(실런타임)는 실제 저장 액션 시에만 관측 가능 — 게이트에선 **계약(필드 존재·형태) 동등성으로 비교**하고 `case` 실값은 미관측으로 명시.

> **B2 verdict:** 에디터 라이프사이클 create→loadEnd는 **굿즈·책자 양쪽 라이브 확정**(동일 프로토콜, 면구조만 psCode/page_count에 반영). save→goto-cart는 정적 계약 + 헤드리스 미관측(경계). 게이트는 create→loadEnd를 실동등성으로, save→cart를 계약동등성으로 비교.

---

## 3. B3 — 정정된 4 가격모델 대표상품 매핑

> 주의: "SizeMatrix2D"·"TieredDiscount"는 print-quote 설계의 **4모델 추상**이며 Red price_gbn 이름이 아니다.
> Red 실측 price_gbn은 10종+null. 아래는 4 추상모델을 **PRICE>0 라이브 입증된 Red 상품**에 사상한 것.

| 4모델 (추상) | **정정 대표 productCode** | Red price_gbn | PRICE>0 증거 | 동작 성격 | 이전 오지정 |
|-------------|--------------------------|--------------|-------------|----------|------------|
| **PriceTable3D** | **PRBKYPR** [윤전]무선책자 | `book2025_price` | 73000 (price_matrix q×p + 공정별 unit_amts) | 표지/내지 분리 3D 단가테이블(수량별 단가체감) | (유지) |
| **SizeMatrix2D** | **AIPPCUT** 에코백(플록) | `real_price` (0×0 sentinel→dimension-matrix-input) | **3300** (b1_AIPPCUT 라이브) | 등록 (규격×자재) 그리드 룩업, off-grid=0 | ~~ACNTHAP~~ (실제 vTmpl_price — 부적격) |
| **FixedUnit** | **STPADPN** 스티커 | `vTmpl_price` | 4000 (s2_STPADPN, ORD/PRN 완전시) | 등록 템플릿규격 단가 룩업, 임의사이즈=0 | (유지, GSPUFBC=tmpl_price 보조) |
| **TieredDiscount** | **GSBGRDY** 레디백 | `tiered_price` | 15000 (phaseB) / GSTGMIC 6000(sweep) | **lookup**(수량할인 아님 — discPct=0 평탄, sweep 확인) | (GSTGMIC도 tiered지만 GSBGRDY가 정가 대표) |

### 정정 근거
- **ACNTHAP(아크릴 명찰)은 `vTmpl_price`**(phaseB price=3300) — SizeMatrix2D(real_price/dimension-matrix) 아님. 진짜 2D 차원모델은 `real_price` + 0×0 sentinel을 쓰는 **AIPPCUT**(red-coverage-matrix.md:176,206이 명시적으로 에코백 real_price를 dimension-matrix-input으로 사상).
- **TieredDiscount의 이름과 실동작 괴리:** `tiered_price`는 수량구간 할인이 아니라 **단가 lookup**(GSTGMIC sweep discPct=0 전행 평탄). 진짜 수량별 단가체감은 오히려 `tmpl_price/vTmpl_price`(GSMLSLC/GSPDLNG sweep에서 unit 변동)에 존재. 게이트는 이 정정을 반영해 비교.
- **FixedUnit:** STPADPN(vTmpl_price)·GSPUFBC(tmpl_price) 둘 다 "등록규격 정확매칭만 PRICE>0, 임의사이즈 0" 동일 성격. STPADPN을 정대표로(스티커=문서상 FixedUnit 대표), GSPUFBC를 보조(PRICE=0 실패벡터·sweep 풍부).

### 게이트 타깃 확정
4 모델 비교 기준 상품 = **{PRBKYPR, AIPPCUT, STPADPN, GSBGRDY}**. 전부 PRICE>0 라이브 베이스라인 보유 → 후니 위젯과 "동일 옵션→동일 PRICE" 동등성 비교 가능.

---

## 4. 잔존 미관측 (은폐 금지)

| 항목 | 상태 | 사유 |
|------|------|------|
| save-doc-report / goto-cart `case` 실값 | 미관측 | iframe 내부 캔버스 저장 필요(cross-origin 헤드리스 한계). 계약은 index.html:350-374 정적 확정 |
| 포스터 BNBNFBL/BNPTPET PRICE>0 | 불가(진단 완료) | Red가 단가 0 등록(미가격 상품). real_price 엔드포인트 정상(AIPPCUT 3300 대조) |
| material→pcs disable 캐스케이드 실발화(audit GAP-2) | 본 보강 범위 외 | B1/B2/B3 우선. PRBKYPR 자재변경 disable 캡처는 후속 권장(MINOR) |
| AIPPCUT 자유치수 2D 단가곡선 | 해당없음 | real_price는 연속공식 아님(등록그리드 룩업) — off-grid=0 확인으로 성격 규명 완료 |

---

## 5. 캡처 산출물 (전체출력 redact, JWT 누출 0건 검증)

| 파일 | 내용 |
|------|------|
| `05_qa/captures/b1_AIPPCUT.json` | real_price PRICE=3300 베이스라인 + 자유치수 off-grid=0 |
| `05_qa/captures/b1_BNBNFBL.json` | 포스터 real_price PRICE=0 진단(요청정상, 서버 개당단가 0) |
| `05_qa/captures/b1_BNPTPET.json` | 동상(real_price 미가격 확인) |
| `05_qa/captures/b2_editor_GSTGMIC.json` | 굿즈 에디터 6 from-edicus 타임라인 |
| `05_qa/captures/b2_editor_PRBKYPR.json` | 책자 에디터 6 from-edicus(0이벤트는 캡처공백이었음 확정) |
