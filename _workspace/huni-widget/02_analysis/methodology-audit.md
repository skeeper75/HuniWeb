# methodology-audit.md — huni-red-matching-methodology 적대적 감사 (간과/과신 탐지)

> 독립 적대적 감사. 대상: `03_spec/huni-red-matching-methodology.md`(7-Phase, M-1~M-13, 4 게이트) +
> 근거분석 `02_analysis/red-coverage-matrix.md`(RCM) / `huni-data-readiness.md`(HDR).
> 모든 수치 주장은 raw data(`red-coverage-scan.json`·`red-coverage-phaseB.json`·후니 xlsx 2종)를 감사자가 직접 재검증.
> 기본 입장: **방안에 맹점이 있다고 가정하고 반증을 찾았다.** 칭찬은 최소, 빈틈에 집중.
> (작성 컨텍스트/저자 추론은 M1 Context Isolation 원칙으로 무시. 문서·데이터만으로 판정.)

---

## 0. 한 줄 판정

**SOUND-but-incomplete, 단 헤드라인 1건이 Critical 등급 맹점.**
방법론의 7-Phase·체크리스트·게이트 골격은 견고하고, disable/배송/가격DB 결손을 정직하게 flag한 점은 우수하다.
그러나 **중심 불변식 "위젯 신규 componentType 0건 / 0줄"이 무조건 명제로 헤드라인·결론·요약표에 제시**되는데,
같은 하네스의 `expansion-strategy.md`가 **"NC-1 dimension-matrix-input은 불가피 — S3(포스터/배너/실사) 진입 시 반드시 추가"**라고 명시한다.
즉 후니 전체 범위에서 "0줄"은 **거짓**이며, 방법론은 이를 §내부에서 "조건부"로 hedge하면서도 톱라인·verdict에서는 단정한다 — **내부 모순 = 과신**.

---

## 1. 증거로 확인된 결함 (raw data 직접 반증)

### F-1 [CRITICAL] "신규 componentType 0건 / 위젯 0줄" 헤드라인이 자체 expansion-strategy와 모순 (과신)
- **간과/과신:** 방법론 L12-13·L301, HDR L18·L77·L248, RCM L211·L346이 **"componentType 신규 0건"·"위젯 코드 0줄"을 후니 매칭의 확정 결론**으로 제시.
- **반증(문서 교차):** `expansion-strategy.md`
  - L137: *"NC-1은 **불가피**(2D 사이즈 입력 = SizeMatrix2D의 전제). S3 진입 시 반드시 추가."*
  - L132: NC-1 `dimension-matrix-input` = **신규**, `ComponentType` union에 1줄 추가.
  - L68: NC-1은 store **가격요청 조립부**(`dimensions` 채우는 로직)에 분기 추가 필요.
- **반증(raw data):** `red-coverage-scan.json` — 후니 범위에 해당하는 **배너/현수막 22 SKU, 봉투 8 SKU**가 실재(Red 479 중). 이들은 현 46 sig엔 folded됐으나, 후니 04 포스터/05 사인(MAP 시트 실재) + 실사 시트 ~101행은 **SizeMatrix2D 가로×세로 입력**을 요구 → expansion-strategy 기준 NC-1 발동.
- **정밀 판정:** "0건/0줄"은 **Red가 캡처한 46구조 한정**으로만 참(대형포맷 자유치수 미캡처). 후니 전체 범위에선 최소 NC-1 1종 + store 조립 분기가 추가된다. 방법론은 L60·L279·L244에서 NC-1을 "조건부 flag"로 언급하나, **수렴사실(L12-13)·결론(L301)·요약표(§7)·검증게이트(L210 INV-3)는 무조건 0줄로 단정**.
- **escape hatch 노출:** INV-5(L34)가 "신규 componentType = 계약 union + dispatcher switch **동시 갱신**"을, INV-3(L32)이 신규 추가를 "어댑터+데이터(+조건부 componentType)이지 코어 재작성 아님"으로 **재정의** → INV-3는 사실상 **비반증(non-falsifiable)**. NC-1을 추가해도 "코어 0줄"이 정의상 통과. 이 정의적 방패 때문에 "0줄" 주장이 검증을 통과하는 것처럼 보인다.
- **권고:** 톱라인·결론·§7 요약을 *"현 S0/S1/S2 범위(Red 46구조 부분집합)에서 0줄. S3(NC-1)·S4·S5는 신규 leaf componentType + dispatcher union + store 조립 분기 필요 — INV-3은 '코어 재작성 없음'이지 '0 추가'가 아님"*으로 정정. INV-3 측정기준을 "dispatcher/store/cascade/shadow **파일 diff 0**"로 명시(union 1줄·leaf 추가는 허용)하여 비반증 loophole 제거.

### F-2 [HIGH] round-trip 게이트의 fixture 40%가 capture에서 PRICE=0 (M-1 자기반증)
- **간과:** §4.1 게이트1·M-1(L116-119)은 *"round-trip에서 PRICE>0 단언"*을 최우선 게이트로 둔다. 그러나 그 단언이 의존하는 Red fixture 자체가 PRICE>0을 못 낸 비율이 크다.
- **반증(raw data `red-coverage-phaseB.json`):** 46 rep 중 **9건이 `hadPriceCall=true && priceStatus=200`인데 price==0**. 여기에 **최대 패밀리 2개 포함**:
  - `BCSPDFT 일반명함` (count=**153**), `PRPOSTK 고투명점착포스터` (count=**36**) → 두 sig가 대표하는 **189상품 ≈ 전체 479의 40%**.
  - 그 외: BCSPSCO(3)·STDRCAD(5)·TPCAPTW(1)·GSNTBND(3)·GSNTLTR(2)·CLDFMHS(1)·ACPDSTD(1).
  - 정상가 생성은 가능(35/46 rep는 price>0, 예: 레디백 15000·구두주걱 4000) — 즉 캡처 방법은 작동하나 **명함·포스터 계열은 옵션 미선택/주문방식 때문에 0** 추정.
- **정밀 판정:** 방법론은 "M-1을 round-trip에서 반드시 assert"(L198)라고 하면서, **가장 큰 fixture들이 source 단계에서 이미 price=0**이라는 사실을 어디에도 flag하지 않는다. 명함 계열(후니 003 프리미엄명함 = §4.2 추적매트릭스 1행 예시!)이 PRICE>0 단언으로 게이트되려면, 옵션 선택 시퀀스가 보강된 별도 fixture가 필요. 현 fixture로는 40% 카탈로그의 M-1 게이트가 **공허 통과 또는 불가능**.
- **권고:** Phase 6 게이트에 *"fixture가 source에서 price=0인 패밀리(BCSPDFT/PRPOSTK 등 9건)는 옵션 완전선택 fixture를 라이브 재캡처(live-capture)한 뒤에만 M-1 assert 가능"*을 명시. §4.2 추적매트릭스의 명함 행에 "fixture price=0 → 보강 필요" 플래그.

### F-3 [HIGH] 단가 기준단위 VAT 정책이 상품별 혼재 — 일괄 10/110 분리 시 이중계상
- **간과:** M-2·HDR §2.3(L126)·D-PM-15는 VAT를 **"BFF가 포함가에서 10/110 분리"**로 단일 정책 처리. 13항목 체크리스트에 VAT-혼재 항목 없음(방법론 내 'VAT' 1회 언급).
- **반증(raw data 상품마스터 xlsx):** **실사 시트 헤더에 `price`와 `price(vat포함)` 컬럼이 인라인 공존** — 즉 일부 상품군은 **VAT-포함가가 원천 데이터에 직접 박혀 있다**. 타 시트는 VAT-별도. 가격표 19시트 전수 키워드 스캔 결과 '부가세/VAT' 매칭 0(가격은 대부분 별도 기재).
- **정밀 판정:** 어댑터/BFF가 전 상품에 일괄 10/110을 적용하면, **이미 vat포함인 실사 상품은 VAT가 이중 차감**되어 finalPrice가 틀어진다(위젯은 불투명이라 침묵 통과 → M-2류 N배/오차). 방법론은 단위 환산(판/장/세트)은 M-2로 집요하게 다루나 **VAT 기준의 상품별 혼재는 누락**.
- **권고:** M-2에 "단가 단위 + **VAT 기준(포함/별도) 상품별 플래그**"를 함께 명시. 실사 등 vat포함 시트는 분리 금지 규칙.

### F-4 [HIGH] 13항목 체크리스트의 카테고리 공백 — 봉투·대형포맷마감·합판도무송·쿠폰·재고·MOQ
- **간과:** M-1~M-13 + CHK-1~10 + CHK-H1~11은 **옵션구조/가격행shape/코드무결성**에 집중. 다음은 **0회 언급**(방법론 grep): `봉투`(0)·`배너`(0)·`현수막`(0)·`합판`(0)·`쿠폰`(0)·`부가세`(0)·`재고`(0)·`품절`(0)·`MOQ`(0)·`최소주문`(0).
- **반증(raw data 가격표 xlsx 시트 실재):**
  - `봉투제작` 시트 = **봉투타입(티켓/소/자켓/대) × 소재 × 제작수량** — 접지·봉투구조 상품. Red·14 componentType에 봉투-구조 모델 없음.
  - `합판도무송스티커` 시트 = **합판(gang) 임포지션 + 도무송(다이커팅) 모양/소재** — 임포지션 단가 모델.
  - 실사 마스터에 `가공(옵션)`·`추가(옵션)` **free-form add-on 컬럼**(배너 그로멧/끈/마감) — selectedFinishes echo로 흡수 주장 가능하나 체크리스트에 매핑 명시 없음.
  - 굿즈파우치 TieredDiscount는 **"파우치+에코백 전체"** 합산 할인 — 즉 **상품 경계를 넘는 할인 스코프**(단일상품 견적 계약과 충돌 가능, §3.1 G9 단일상품 가정과 긴장).
- **정밀 판정:** 봉투·합판은 4모델로 흡수 가능성은 있으나 **체크리스트가 명시적으로 다루지 않아 "누락 추적 키"(§6.1 적용 M-x)가 비어버린다** → 방법론 자신의 누락방지 메커니즘이 이 군에서 작동 안 함. 쿠폰/재고/MOQ/i18n은 source에 데이터 없음 → §2 데이터부재 리스크로 이동.
- **권고:** 체크리스트에 M-14(봉투/세트구조 가격모델), M-15(VAT기준 혼재=F-3), M-16(교차상품 할인 스코프 vs 단일견적 계약) 추가. 또는 §6.1 cross-mapping에 "봉투/합판/대형포맷 행 = 적용 M-x 미정 → 보강대상" 명시.

### F-5 [MEDIUM-HIGH] 46-시그니처가 disable/옵션값/finish 의미를 구조적으로 못 본다 (과신의 근원)
- **간과:** RCM "46구조 = 신위젯이 신규 0으로 흡수"가 완전성의 근거. 그러나 sig가 캡처하는 정보가 제한적.
- **반증(raw data scan.json):**
  - sig 토큰은 `r1/r2/r3`로 **radio 그룹 개수만** 인코딩, **내용 무시**. 동일 sig `PRN_CNT,dosu,paper,sizes,weight|n5|WH|r1`(count=36) 안에 `PRPOSTK`(radioGroup=`["white-mode"]`)와 버튼류 `BTPNXXX`(radioGroup=`["COT_DFT/S"]`)가 공존 — **의미가 다른 후가공이 한 sig로 붕괴**.
  - scan 레코드 12개 키 전수: `cat/code/name/mounted/orderable/nodes/numCount/freeWH/radioGroups/sig/selects/textHint` — **`disable`/`cascade`/`values`/`constraint`/`hidden`/`VIEW_YN` 키 자체가 없음**. 즉 시그니처는 캐스케이드·옵션값·hidden을 **구조적으로 관측 못 함**.
  - **46 sig 중 22개가 singleton(n=1)** — 그 sig는 단 1상품으로 대표, **동일sig 중복검증 불가**. 상위 2 sig가 303/479 흡수(롱테일은 거의 전부 n=1~3).
- **정밀 판정:** "신규 componentType 0"은 **componentType(=입력위젯 종류)에 한정해서만** 참이고, 정당하다(토큰→위젯 매핑은 실제로 닫혀 있음). 그러나 방법론이 같은 호흡에서 강조하는 **disable/hidden/옵션값 정합은 sig가 보증하지 못한다** — 이건 전적으로 후니 데이터+어댑터 몫인데, "46구조 흡수"라는 표현이 마치 캐스케이드까지 검증된 듯한 안도감을 준다. M-5/M-6(disable/hidden)이 별도로 있으나, **완전성 주장과 캐스케이드 미검증 사이의 경계가 톱라인에서 흐려진다**.
- **권고:** RCM/방법론에 *"46-sig 완전성 = **componentType 라우팅 한정**. disable/hidden/옵션값/finish 의미는 sig 무관측 → M-5/M-6/M-9로만 보증되며 후니 데이터 의존"*을 명시 분리.

### F-6 [MEDIUM] "위젯 개발 0% 차단" 블랭킷 주장이 후니 전체 범위에서 거짓
- **간과:** HDR L20·L160·L251, 방법론 L230 *"위젯 개발은 0% 차단 / 전부 무차단."*
- **반증:** F-1과 연동 — S3 진입 시 NC-1 = dispatcher union + **store 가격요청 조립 분기**(expansion-strategy L68) 추가 필요. 이건 어댑터/데이터가 아니라 **위젯 코드 변경**. 따라서 위젯은 S3/S4/S5에서 **차단된다**(코드 작업 필요).
- **정밀 판정:** 스테이지 로드맵이 S1 먼저(S3 후행)라 **당장의** 위젯 작업은 무차단인 게 사실. 그러나 "0% 차단"은 **현 stage 한정 참, 전체범위 거짓**. 방법론 L244는 "S3/S6는 Red fixture 미보유 → live-capture 임계경로"로 일부 인정하나 fixture만 거론, **componentType/store 코드작업 의존은 누락**.
- **권고:** "0% 차단" → "S0~S2 무차단; S3~S5는 신규 componentType·store 분기로 위젯 코드 작업 발생(stage별 임계경로)".

### F-7 [LOW] SizeMatrix2D 가로×세로 직접사용 = lossless 주장의 W/H 방향 맹점
- **간과:** HDR L123 *"SizeMatrix2D는 가로/세로 수치 직접 사용(✅)"*을 무비용 lossless로 처리.
- **반증(raw data 포스터사인 시트):** 행=세로/열=가로 매트릭스에서 600×800과 800×600이 동일 12000인 셀과 비대칭 셀(1200행 vs 1200열 차이) 공존 → **가로/세로 축 배정(orientation)을 어댑터가 틀리면 가격이 비대칭 셀에서 어긋남**. 비규격 외삽 셀(`1000x1000:20` 같은 인라인 메모)도 존재.
- **권고:** M-2(또는 신규)에 "SizeMatrix2D 가로↔세로 축 매핑 + 외삽셀 정책" 단언 추가.

### F-8 [LOW] "~240 상품" 카운트 미재현 + 옵션 granularity 과소표현
- **반증(raw data 상품마스터):** 11 SKU 시트의 비-빈 행 느슨한 카운트 ≈ **681행**(디지털134·실사101·굿즈파우치164·아크릴67·상품악세67·스티커76 등). 느슨한 heuristic이라 병합셀/소제목 과대계상 가능 → **240을 반증하진 못하나 재현도 못 함**. 적어도 **옵션 granularity(행 단위)는 240보다 훨씬 크다** — 매핑 작업량 추정에 영향.
- **권고:** "~240 상품"의 카운트 기준(상품 vs 옵션행) 명시. 매핑 공수는 행 단위(수백~)로 추정.

---

## 2. 검증 불가로 남는 리스크 (후니 데이터 부재 — 결함 아님, 미결)

| ID | 미검증 항목 | 왜 검증 불가 | 방법론이 정직히 flag했나 |
|----|-------------|--------------|:------------------------:|
| R-a | disable/excl 캐스케이드 규칙 | constraint_json 미작성(암묵지) | ✅ M-5·Phase4·L76·L145 명시 ("오늘은 Red fixture로 엔진만 검증") |
| R-b | hidden-essential visible 분류 | 후니 VIEW_YN 컬럼 부재 | ✅ M-6·CHK-H5 명시 |
| R-c | 실가격 수치 정확도 | 가격 DB placeholder, 엑셀이 실원천 | ✅ HDR §3·L140 명시 |
| R-d | 배송정책 | D-PM-16 미확정 | ✅ B3 임계경로로 명시 |
| R-e | **M-2 기대치 일치 단언** | 후니 실가격 부재 → "알려진 수량의 finalPrice 기대치"를 만들 데이터 없음 | △ **부분** — M-2를 round-trip assert(L198·L207)로 제시하나, 기대치 산출이 데이터-차단임을 명시 안 함. **게이트가 실행가능한 듯 표현됨** |
| R-f | 책자 세트 vs side분리 모델링 | t_prd_product_sets 미확인 | ✅ M-8·G2 명시 |
| R-g | 쿠폰/적립/재고/품절/MOQ/i18n | source 데이터 자체 부재 | ✗ **미flag** (F-4) — 범위밖이면 "범위밖" 명시 필요 |

> R-a~R-d·R-f는 **모범적 정직성** — 방법론의 가장 강한 부분. R-e·R-g는 보강 필요.

---

## 3. 최종 verdict + 사용자가 가장 후회할 top-3 간과

**판정: SOUND-but-incomplete + Critical 맹점 1건.**
골격(7-Phase 순서·M-1~M-4 침묵0원 우선순위·4단 게이트·cross-mapping 추적)은 타당하고, 데이터 결손의 정직한 flag(R-a~R-d)는 우수하다.
그러나 **중심 불변식의 톱라인 표현이 자기 문서와 모순**되며, 이는 단순 누락이 아니라 **과신**이다.

**Top-3 (가장 후회할 간과):**
1. **F-1 [Critical] "위젯 0줄/신규 componentType 0"의 무조건 단정.** 같은 하네스 expansion-strategy가 "NC-1 불가피"라 못박는데, 톱라인·결론·INV-3 게이트는 0줄로 단정. INV-3이 비반증 정의로 방패화되어 "통과"하는 착시. → 후니 전체 범위로 믿고 착수하면 S3에서 깨진다.
2. **F-2 [High] 게이트 fixture의 40%(명함+포스터, 189상품)가 source에서 price=0.** M-1(PRICE>0 단언)이 가장 큰 패밀리에서 공허/불가능한데 flag 없음. §4.2 추적매트릭스 첫 행(명함)부터 게이트 불성립.
3. **F-3+F-4 [High] VAT 기준 상품별 혼재(실사 vat포함 인라인) + 봉투/합판/대형포맷마감/교차상품할인 체크리스트 공백.** 단위환산은 집요하나 VAT기준·봉투구조·파우치+에코백 합산할인은 누락 → 침묵 N배오류·매핑 누락추적 실패.

**Critical 맹점 존재: 예 (F-1).** 단 hedge가 본문에 분산 존재하므로 "치명적 오류"가 아니라 **"치명적 표현/과신"** — 톱라인 정정 + INV-3 측정기준 구체화 + 체크리스트 3항 보강(M-14~16)으로 SOUND-and-complete 전환 가능.
