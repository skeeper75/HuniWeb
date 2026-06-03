# 코드정합 2차 팀 교차검증 — 발견 종합 (Round 2)

**일자:** 2026-06-03 | **모드:** 에이전트 팀(authority/integration/assumption 3렌즈, read-only) + 리더 직접 adjudication
**기준선:** vitest 148/148, tsc 0, build OK (불변, read-only 검증)
**목적:** 1차 교차검증·서브 순차검증이 GO한 코드정합 S0~S3 보정을 3렌즈로 재검증해 잔존 갭·잠복부채 발굴.

핵심 결과: **G-1 "RESOLVED" 권위 날조 적발**(삼중 확정) + 신규 MAJOR 2건(의류 DIR_MTR 드롭, mb_cust_cod 침묵 PRICE=0) + dead 1건 + 구조 인식 1건. 1차가 놓친 것을 2차가 잡음 — 팀 교차검증 가치 재입증.

---

## 1. 검증 방법 (메타원칙)

1. **분기 도달 증명** — RESOLVED 선언은 그 분기를 실제 traverse하는 fixture/probe 필요(주석+타입+테스트통과 ≠ 정합).
2. **field-for-field 직렬화 대조** — 어댑터 reqBody를 라이브 캡처와 값·타입 단위 단언.
3. **왕복 양방향** — disable→re-enable 복원까지.
4. **상품별 분기 vs 전역 평면화** — product-keyed 규칙을 어댑터가 전역으로 뭉갰는지.
5. **[HARD] 새 미검증 권위 생성 금지** — 보정이 또 다른 날조가 되지 않게, 캡처·deob 권위 밖 값 주입 금지.

---

## 2. G-1 ATTB 권위 날조 — 삼중 확정 (BLOCKER급 정직성 결함, day-1 비차단)

### 2.1 발견
이전 라운드 G-1 "정정(RESOLVED)"은 "Red 4종 자재연결 PCS 전부 ATTB=orderQty: SUB_MTR(mod_07:2597)/PDT_WRK(2954)/DIR_MTR(2470)/WRK_MTR(3572)"라며 WRK_MTR/DIR_MTR을 `QUANTITY_ECHO_PCS` 전역 set에 추가 + ACPDSTD SUB_MTR ATTB=quantity "유지"(retract)했음.

### 2.2 권위 실측 (deob 직접 — 리더 + authority + assumption 합치)
- `deob_07_app_components.js` = **2607줄**, `deob_06_app_widget_sdk.js` = **1392줄**에서 종료. 인용 라인 2954/3572는 **파일 범위 밖(부존재)**, 2597/2470은 범위 내이나 **ATTB 대입 아님**(Vue 렌더/주석 블록).
- deob 전체 ATTB 대입 전수(4곳, **어느 것도 ORD_CNT 아님**):
  - `deob_07:1008` DIR_MTR = `materialMap[mtrlCode].quantity` (선택자재 size-combo **장수**)
  - `deob_07:2162` SUB_MTR material-multi = `""` (빈문자열)
  - `deob_07:2387` BID_SIL = `newValue` (사용자 **속성값**)
  - `deob_06:1250` material PCS(에디터 재계산) = `orderData.quantityInfo.prnCnt` (**PRN_CNT**, ORD_CNT 아님)
- → "ATTB=ORD_CNT(주문수량)" 권위 = **0건**.

### 2.3 캡처 실측 (integration 전수 + 리더 ORD_CNT 분리)
| capture | PCS | ATTB | type | ORD_CNT | PRN_CNT | PCS_DTL |
|---|---|---|---|---|---|---|
| b1_AIPPCUT | SUB_MTR | 1 | int | 1 | **2** | EC001 |
| s3_GSPDLNG/GSTBMWM/GSMLSLC | DIR_MTR | 1 | int | 1/- | 1/- | LD001/TM039/MLS01 |
| s3_GSTGMIC | WRK_MTR | 1 | int | 1 | 1 | TG001 |
| s3_GSNTSPR/GSNTSTA | INN_DFT | 1 | int | 1 | 1 | INNON |
| s3_GSDRSKS | INN_DFT | **''** | str | - | - | SKSTU |
| s3_GSPUFBC/GSTGMIC | PDT_WRK | **''** | str | 1/- | 1/- | PUBOK/PKT01 |

- 전 quantity-echo PCS 캡처에서 **ORD_CNT는 항상 1 또는 부재**. qty>1 표본(ORD_CNT=13, 캘린더)은 quantity-echo PCS 미동반 → **ATTB가 ORD_CNT를 추종한다는 증거 0**(반증도 못 하나 지지도 0).
- AIPPCUT SUB_MTR: PRN_CNT=2인데 ATTB=1 → **prnCnt 후보(deob_06:1250) 배제**.
- 어댑터 `red-adapter.ts:576` `String(req.quantity)`(=ORD_CNT, `:549`)는 **deob·캡처 양쪽 미지지 = 새로 날조된 미검증 권위**.
- 회귀가드(`parity-blockers.test.ts:75-76`)는 양변 `String()` 강제로 타입·값 발산을 마스킹 = 타우톨로지.

### 2.4 판정
- **G-1 "RESOLVED" → PARTIAL/권위오류 재분류.** 메타원칙1(도달)·권위 둘 다 미충족.
- ATTB는 **PCS_DTL_COD/속성보유별 다형**: 속성값(2387) / `""`(2162) / size장수(1008) / prnCnt(1250). ORD_CNT는 어디에도 없음.

### 2.5 A-2 격상 — SUB_MTR 이중의미 평면화 (잠복→발현 확정, integration 어댑터 트레이스)
- **결정타 트레이스**: ACPDSTD(아크릴) SUB_MTR 12종 자재선택 리스트(다종 MTRL_CD·ATTB_CD None·VIEW_YN=Y) + quantity=50 → 어댑터 emit `{PCS_COD:SUB_MTR, PCS_DTL_COD:AB005, ATTB:"50"}`. Red 권위(deob_07:2162 material-multi)는 **ATTB=""** → **ATTB="50" 날조 확정·발현**(dormant 아님).
- **근본원인**: `QUANTITY_ECHO_PCS`(red-adapter.ts:137)가 **PCS_COD 단일 Set**이라 (a)단일 add-on(AIPPCUT SUB_MTR EC001, 캡처 ATTB=1)과 (b)다종 자재선택(ACPDSTD, Red ATTB="")을 동일 처리. ATTB 의미는 PCS_COD 단일축이 아니라 **엔트리별 다형**(ATTB_CD 보유 / 단일 vs 다종 MTRL_CD / VIEW_YN) → Set 멤버십 접근 자체가 구조적으로 부적합.
- 이전 라운드가 retract했던 integration ① 플래그("ACPDSTD SUB_MTR ATTB 날조")는 **retract이 과오 → 복원**. (a)/(b) 혼동이 원인.
- 신뢰등급: ACPDSTD add-on 가격경로 캡처 0건 → "올바른 값"은 deob 권위("")에만 의존. 단 어댑터가 캡처·권위 무관히 "50" 주입하는 것 자체는 트레이스로 발현 확정.

---

## 3. 보정 대상 분류

### Wave 1 — 결정적·증거완결 (보정 즉시, 새 권위 생성 0)
| ID | 항목 | 파일:라인 | 근거 | 처방 |
|----|------|----------|------|------|
| W1-a | **mb_cust_cod 빈문자열 침묵 PRICE=0** (G-INT-2) | red-adapter.ts:586 | 캡처 call#6 mb_cust_cod:""→PRICE=0 실증. `??`가 '' 통과. HARD 도메인 정합 | `?? '10000000'` → `|| '10000000'` (빈문자열 falsy 처리) + field 테스트(tier:''→'10000000') |
| W1-b | **PDT_WRK quantity-echo 오분류** | red-adapter.ts:137 | 캡처 4/4 ATTB='' (ORD_CNT=1에도 '') | `QUANTITY_ECHO_PCS`에서 PDT_WRK 제외 → 출력 '' (캡처 정합) + 테스트 |
| W1-c | **날조 권위 주석** | red-adapter.ts:131-134,569,578 | 인용 라인 부존재 | 실재 deob 라인(1008/2162/2387/06:1250) + 캡처 근거 + "ORD_CNT scaling 미검증, ATTB 다형, 컨버전 게이트"로 교체 |

### Wave 2 — 구조: ATTB 엔트리-shape 규칙 (hw-builder 신중 구현, A-2 발현)
| ID | 항목 | 파일:라인 | 처방 |
|----|------|----------|------|
| W2-a | **SUB_MTR 이중의미 평면화** (A-2 발현) | red-adapter.ts:137,576 | 수량echo 판정을 PCS_COD Set → **엔트리 shape**로: 다종 MTRL_CD + ATTB_CD None(=자재선택형)은 ATTB="". 단일 add-on(AIPPCUT)은 캡처 ATTB=1 유지. 권위=deob_07:2162. **discriminator가 2케이스 추론 기반이라 hw-builder가 코드 정독 후 신중 구현 — 잘못된 규칙도 날조** |
| W2-b | **INN_DFT 조건부** | red-adapter.ts:137,576 | INNON→1, SKSTU→'' (PCS_DTL_COD 의존). 평면 set 부적합. W2-a와 동일 패턴(엔트리 다형) |

> Wave 2는 "QUANTITY_ECHO_PCS Set 접근이 구조적으로 부적합"이라는 공통 근본원인을 다룬다. Wave 1(PDT_WRK 단순 제외)로 시작하되, SUB_MTR/INN_DFT는 엔트리-shape 분기가 필요해 분리. 신뢰등급: 실 캡처+fixture 보유(WRK_MTR/PDT_WRK/INN_DFT/AIPPCUT SUB_MTR)만 보정 근거 신뢰가능, ACPDSTD-SUB_MTR·DIR_MTR은 deob 권위 only(날조 위험 최고).

### Wave 3 — 정직 재분류 (문서, 코드 무변경)
- G-1 RESOLVED → PARTIAL (`crossverify-fix-verification.md` 보정).
- DIR_MTR/INN_DFT → PARTIAL-stub/조건부 명시.
- B-1 dead: `component-type-map.ts:64-68` size 분기는 `red-adapter.ts:211` divSeq 미전달로 **영구 도달불능**. "dormant" → "unreachable dead, 컨버전 게이트(GSCDPOP)" 정정.

### Deferred — 컨버전 게이트 / qty>1 재캡처 (보정 보류, 정직 표기 — 새 권위 생성 방지)
| ID | 항목 | 사유 |
|----|------|------|
| D-1 | WRK_MTR/DIR_MTR/SUB_MTR/INN_DFT(INNON) ATTB **값** rework | qty=1 캡처가 ORD_CNT/상수/material-qty 구분 불가. 가시 vs hidden SUB_MTR 분리(ACPDSTD '' vs AIPPCUT 1) 필요. 임의 보정=날조. **qty>1 재캡처 선행** |
| D-2 | **G-5/A-1 의류 DIR_MTR 배타 드롭** | red-adapter.ts:83-85 `apparel ? : ` 삼항이 pdt_pcs_info(DIR_MTR hidden-essential 가격축) 통째 드롭. size_color와 0 overlap(비보상). 구조결함이나 CLSTSHS PRICE=0로 **미발현**. 처방=additive 삼항(중복가드). **의류 PRICE>0 캡처 선행** |
| D-3 | **G-INT-0 런타임 미직렬화(구조)** | serializeRedPriceRequest 비-test 호출자 0. fixture 정적룩업이 reqBody 미직렬화 → shape 결함 침묵(F-2 구조 잔존). 실 HTTP BFF 배선(컨버전)까지 회귀가드 부재. 인식·문서화 |
| D-4 | G-INT-1 ATTB 타입 int vs str | 캡처 int(1), 어댑터 str('1'). ATTB rework와 결합. wire 수용성 미확정(캡처 1건) |

### 안전영역 (over-claim 회피, 결함 아님)
- **DOSU_COD omit** (red-adapter.ts:532): 캡처 DOSU_COD↔PRN_CLR_CNT 전단사(SID_S↔4/SID_D↔8/SID_X↔0) → PRN_CLR_CNT만으로 도수 price 완전복원. 현 상품군 방어가능. 비차단 문서화 가정.
- 진짜 RESOLVED 재확인: L-2(복합2축 STTHCIC) / L-4(color-chip PRBKYPR) / G-2(에디터 3콜백 EditorOverlay 실배선) / 왕복 메타3(C-B·C-2·L-2 round-trip).
- product-keyed 맵 평면화 **없음** 확인: accFilterConfigMap(2단키 보존) / roundingConfigMap(맵 정의 보존, 소비경로만 dead=B-1) / calendar(데이터구동 동등) / bookPageMultiplier(itemGroup echo).

---

## 4. 1차→2차 교훈 (하네스 정직성)
- 1차 hw-qa "crossverify-fix-verification GO(신규부채 0)"의 G-1 부분은 **권위 미대조**(소스 라인 인용 자체를 검증 안 함) + 양변 String() 타우톨로지 테스트. → **검증 메타원칙1(도달+권위 인용 실재성)을 게이트에 명문화** 필요.
- 보정 시 [HARD] 새 미검증 권위 생성 금지가 결정적 — "ATTB=orderQty 폐기"를 "ATTB=''"로 단순치환하면 캡처상 ATTB=1인 PCS가 깨짐. 캡처·deob 권위 밖은 보류가 옳음.
