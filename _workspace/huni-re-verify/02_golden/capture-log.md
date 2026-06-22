# capture-log.md — Phase 2 가격 골든 마스터 캡처 로그

> 기록자: hrev-golden-recorder. 오라클 = 라이브 RedPrinting via server.js :3001(읽기전용 get_ajax_price_vTmpl).
> 캡처일: 2026-06-23 (KST). 산출 = `02_golden/captures/golden_*.json` (시나리오당 1 파일, 누적 금지).

---

## 0. 세션 상태 — 신선(재로그인 불필요)

| 항목 | 값 |
|------|-----|
| cookies.json mtime | 2026-06-23 00:26 (당일) |
| server.js 기동 | **프레시 재시작**(stale 3001 kill → `node server.js`). 14개 쿠키 로드. |
| 에디터 JWT | 만료(가격 무관 — 에디터 브릿지 전용 토큰, 가격은 세션쿠키 권위) |
| 세션 sanity | AIPPCUT 골든 재생 → **PRICE=3300** (b1 베이스라인 정확 일치) → **세션 유효 입증** |
| 판정 | **신선** — extract-cookies.cjs 재실행 불요. 골든 캡처 진행. |

방법론 함정 #3(세션/토큰 드리프트) 회피: in-process refresh 의존 금지, 프레시 프로세스 기동 후 sanity 선검증.

---

## 1. 캡처 성공 시나리오 (전 6종 — 정상경로 PRICE≠0)

| 시나리오 | 상품 | price_gbn | 옵션 요지 | result_sum.PRICE (라이브) | 파일 |
|----------|------|-----------|-----------|---------------------------|------|
| **G-RP** | AIPPCUT (에코백) | real_price | MTRL PXPLP001, 300×340, SUB_MTR EC001, ORD1·PRN1 | **3,300** (EC002 차등=4,400) | golden_AIPPCUT_real.json |
| **G-FU** | STPADPN (스티커) | vTmpl_price | A4 140×200 / A3급 210×297 | **4,000** / 8,000 (incomplete=0 가드) | golden_STPADPN_fixed.json |
| **G-TD** | GSTGMIC (네임택L) | tiered_price | 삼각마이크 355×295, PRN_CNT 스윕 | 1→7,000 · 2→13,600 · 5→33,400 · 10→66,200 · 30→194,200 · 100→631,800 (**단조증가**) | golden_GSTGMIC_tiered.json |
| **G-TM** | GSPUFBC (파우치) | tmpl_price | 11in세로 230×288, ORD100·PRN1 | **2,850,000** (ORD1=28,500 단가·ORD10=285,000 선형·incomplete=0 가드) | golden_GSPUFBC_tmpl.json |
| **G-BK** | PRBKYPR (무선책자) | book2025_price | A5 148×210, PAGE_CNT 스윕(표지/내지 분리) | PAGE24→6,100 · 48→6,800 · 100→8,300 (**PAGE↑⇒PRICE↑**) | golden_PRBKYPR_book.json |
| **G-ATTB** | GSNTSPR (스프링노트) | tmpl_price | RIN_DFT 링색·ROU_DFT 반경 ATTB + qty 스윕 | 아래 §2 | golden_GSNTSPR_attb.json |

각 골든: `reqBody`(full dataJson) + `result_sum`(권위) + `perLine`(PCS_CD/PRICE) + `priceLog`(+책자는 `book_info`).
오라클 sanity 기록: `oracleSanity.readsResultSum=true`, `normalPathZeroCount=0`(정상경로 0 없음).

---

## 2. ★G-ATTB 갭검증 (D-L1 ATTB 단가영향) — qty>1 + ATTB 다값 차등 캡처 성공

GSNTSPR(스프링노트)는 RIN_DFT(링색)·ROU_DFT(반경) ATTB를 모두 보유 — 이상적 ATTB 검증 상품.

### (a) qty 스윕 (ATTB 고정 RIN_BLK/rou4)
| ORD_CNT | PRN_CNT | PRICE |
|---------|---------|-------|
| 1 | 1 | 6,300 |
| 1 | 5 | 31,300 |
| 5 | 1 | 31,500 (=5×6,300 정확) |
| 10 | 1 | 63,000 (=10×6,300 정확) |

### (b) ATTB 차등 (qty 고정 ORD1/PRN1)
| ATTB 변경 | PRICE |
|-----------|-------|
| 링색 RIN_BLK (base) | 6,300 |
| 링색 RIN_WHT | 6,300 |
| 링색 RIN_GLD | 6,300 |
| 링색 RIN_SIL | 6,300 |
| 반경 rou8 | 6,300 |
| 반경 rou0 | 6,300 |

### 결론 (라이브 오라클 입증)
- **ATTB(링색·반경)는 가격에 불변** — RIN_DFT/ROU_DFT per-line PRICE=0, result_sum 불변.
- **가격은 ORD_CNT/PRN_CNT가 운반**(둘 다 정확 선형).
- 이 차등이 D-L1의 "qty=1 단일캡처 = ORD_CNT/상수/material-qty 구분 불가"(crossverify-round2 D-1) 모호성을 **해소**: ATTB는 echo 전용, qty는 ORD_INFO 필드 운반. ATTB가 단가에 실영향 주는 후가공은 본 상품(GSNTSPR)에선 미관측.

---

## 3. 미캡처 / 강등 (무날조 — 사유 명시)

| 항목 | 상태 | 사유 |
|------|------|------|
| **G-ITEM** (itemGroup 오분기, manifest §D-L2) | **미캡처** | inner-보유 비책자/inner-부재 책자 경계 케이스를 라이브에서 특정하려면 widget 옵션 인터랙션 캡처가 필요. POST 가격조회만으로는 item_gbn 분기를 검증 불가(reqBody 재구성=날조 위험). 본 파일럿(가격 API) 범위 밖으로 보류 — widget 동작 게이트(V-WIDGET)에서 처리 권장. |
| **BCSPDFT** (radius ATTB 대체후보) | **미캡처(대체 충족)** | major_radius_BCSPDFT.json은 info/옵션 덤프(가격 reqBody 부재). 명함 유효 reqBody(PRT_DFT 인쇄공정·SUB_MTR 케이스 등)를 info 덤프에서 재구성 시도 시 4종 price_gbn 모두 PRICE=0 — 옵션 튜플 불완전. 유효 reqBody는 라이브 widget 인터랙션 캡처 필요(추측 reqBody=날조). **G-ATTB는 GSNTSPR로 충족**(ATTB 단가영향 입증 목적 달성)하여 BCSPDFT 추가 불요. |

> 임의 보정값 날조 0. PRICE=0 캡처는 전부 의도된 결함재현가드(incomplete reqBody)로만 라벨링, 정상 골든에 미혼입.

---

## 4. 비밀 위생 [HARD] — 확인 완료

- 골든 JSON 내 쿠키·에디터 JWT·presigned URL·세션ID·set-cookie **0건**(grep 검증 — 매치는 `secretsRedaction` 주석 텍스트뿐).
- server.js가 세션쿠키를 **서버측 헤더 주입** — reqBody/응답 본문에 비밀 미기록(구조적 비노출).
- `mb_cust_cod`: 전 27건 `10000000`(익명 공개 기본값, 비밀 아님). 세션파생 8자리 고객코드는 캡처 reqBody에 미발생(익명 기본만 사용). 마스킹 로직(`maskCustCode`)은 세션파생값 검출 시 `[REDACTED-session-cust]` 치환 — 본 캡처에선 발동 불요.
- 원본 비밀은 `raw/widget_monitor/local/.env`에만(git ignore 대상).

---

## 5. 캡처 메커니즘 (재현용)

- 기동: `cd raw/widget_monitor/local && lsof -ti:3001|xargs kill -9; node server.js`
- 캡처: `cd _workspace/huni-re-verify/02_golden/captures && node _capture.cjs [시나리오]`
- POST → `http://localhost:3001/rp-api/ko/product_price/get_ajax_price_vTmpl` (proxy가 라이브 redprinting.co.kr로 쿠키 주입 후 중계)
- 읽기전용 불변식 준수: get_ajax_price_vTmpl(가격조회=공개 가격정보, SDK Report §8.2①) **only**. 주문/결제/장바구니/폼submit/에디터저장 **0**.

---

## 6. ★보강 캡처 (260623 Phase 2 추가) — 신규 14 가격필드 전용 골든

> 배경: 직전 §22 가격검증 = 4월 필드사전. 6월 라이브 진화로 신규 14필드 추가(R2에서 라이브 수용 확인).
> R2는 메타모픽 4변형만 캡처 — **신규 14필드 전체 sweep 골든 미수행**. 그 보강.
> 산출 = `02_golden/captures/new-fields-260623/` (시나리오당 1 JSON).

### 6.0 세션 상태 (보강 캡처 시점)
| 항목 | 값 |
|------|-----|
| cookies.json mtime | 2026-06-23 02:29 (당일·23분 전) |
| server.js | **프레시 재시작**(:3001 점유 없음 → `node server.js`). 14쿠키 로드. |
| 세션쿠키 | PHPSESSID/kisession=session-only(유효)·AWSALB=168h 잔존(유효) |
| 에디터 JWT | 03:29 만료(가격 무관) |
| 세션 sanity | NCCDDFT 라이브 → PRICE=12,700 (≠0) → **세션 유효** |
| 판정 | **신선** — extract-cookies 재실행 불요 |

### 6.1 ★라이브 드리프트 적발 (R7 freshness 신호)
- R2 metamorphic JSON: NCCDDFT baseline PRN500 = **6,350,000** / PRN1000 = **23,900,000**.
- 본 보강 라이브 실측: PRN500 = **12,700** / PRN1000 = **23,900**.
- 분석: **R2의 PRN1000(23,900,000) = 본 실측(23,900)의 정확히 1000배**. 그러나 R2 PRN500(6,350,000) ≠ 12,700×1000=12,700,000 — R2 내부에서도 PRN500/PRN1000 비율 불일치(6.35M→23.9M=3.76×)가 본 실측 비율(12,700→23,900=1.88×)과 상이.
- 결론: **R2 메타모픽 수치는 스케일 아티팩트 의심**(1000× 단위 오기록 또는 상이 config). 본 라이브 record가 단일 권위 오라클. R2 메타모픽 JSON 수치는 **앵커로 채택 금지**(관계 방향만 일치 — qty↑⇒price↑, +접지⇒↑). Phase 3은 본 보강 골든을 기준으로 차등.

### 6.2 캡처 성공 시나리오 (전 8종 — 정상경로 PRICE≠0)
| 시나리오 | 신규필드 | 상품/price_gbn | result_sum.PRICE (라이브) | 파일 |
|----------|----------|----------------|---------------------------|------|
| **NF-ORDCNT** | ORD_CNT | NCCDDFT/offset2023 | 1→12,700·2→25,400·5→63,500 (선형) | NF-ORDCNT_NCCDDFT.json |
| **NF-PRNCNT-modelB** | PRN_CNT(모델B) | NCCDDFT/offset2023 | 500→12,700·1000→23,900·2000→43,100 (단조·규모할인) | NF-PRNCNT-modelB_NCCDDFT.json |
| **NF-REAMCNT** | REAM_CNT | NCCDDFT/offset2023 | 0/1/2→12,700 (엔진수용·PRN권위) | NF-REAMCNT_NCCDDFT.json |
| **NF-ADDCLR** | ADD_CLR_YN | NCCDDFT/offset2023 | SID_S N/Y=12,700·SID_D N/Y=15,900 (자재조건부 무변·negative) | NF-ADDCLR_NCCDDFT.json |
| **NF-FLD-DFT** | FLD_DFT(접지) | NCCDDFT/offset2023 | none 12,700→FO006/007/008=29,700·FO002=30,700 (+후가공⇒↑) | NF-FLD-DFT_NCCDDFT.json |
| **NF-POSTPCS** | HOL/ROU/MIS/OSI_DFT | NCCDDFT/offset2023 | HOL 16,800·ROU 16,200·MIS/OSI 18,200 (전부 baseline초과) | NF-POSTPCS_NCCDDFT.json |
| **NF-TIERED-modelB** | PRN_CNT(tiered) | GSTGMIC/tiered | 1→7,000·2→13,600·5→33,400·10→66,200·30→194,200 (단조) | NF-TIERED-modelB_GSTGMIC.json |
| **NF-ACCEPTANCE** | PACK_PRN_CNT·MAX_PRN_CNT·모델A래더 | NCCDDFT/offset2023 | 전부 12,700 (엔진수용·PRICE보존) | NF-ACCEPTANCE_NCCDDFT.json |

전 8종 `oracleSanity.normalPathZeroCount=0`. 메타모픽 관계 종합 → `metamorphic-relations.json`(MR-1~MR-8).

### 6.3 메타모픽 성립 종합
- **수량↑⇒price 비감소**: MR-1(ORD_CNT 선형)·MR-2(PRN_CNT 모델B 단조)·MR-3(tiered 단조) **성립 ✓**.
- **+후가공⇒price↑**: MR-4(FLD_DFT 접지)·MR-5(HOL/ROU/MIS/OSI) **성립 ✓**.
- **각 PRICE≠0**: 전 8시나리오 정상경로 0건 **성립 ✓**.
- **negative/acceptance(결함아님)**: MR-6(ADD_CLR_YN 자재조건부 무변)·MR-7(REAM_CNT 엔진수용)·MR-8(PACK/MAX/모델A 수용).

### 6.4 미캡처 / 강등 (무날조 — 사유 명시)
| 항목 | 상태 | 사유 |
|------|------|------|
| **PACK_PRN_CNT 가격함수** | **미캡처(엔진수용만 record)** | 가용 가격조회 상품 전수(STPADPN/GSTGMIC/GSELGLV/GSTRTAG/GSPUFBC/GSNTSPR) `hasPackPrnCnt=false` — 개별포장 노출 상품 미가용. 엔진 수용(retCode200·PRICE보존)만 NF-ACCEPTANCE에 기록. 가격함수 sweep은 노출상품 확보 후로 보류(추측 reqBody=날조). |
| **수량모델 A (래더 MIN_ORD_PRN_CNT+ADD_ORD_PRN_CNT×h)** | **미캡처(엔진수용만 record)** | deob L15432 모델A는 PDT_VER_SIZE형 굿즈 전용. 가용 상품 전수 `hasMinOrdPrn=false`·`PDT_VER_SIZE` 부재. 추가 굿즈코드(STSTDPN/GSACDFT 등) info 호출 retCode 999(미가용). 엔진 수용만 NF-ACCEPTANCE에 기록. |
| **R2 메타모픽 수치 앵커** | **강등(채택금지)** | §6.1 드리프트 — R2 수치(6.35M/23.9M)는 스케일 아티팩트 의심. 관계 방향만 유효. 본 라이브 record가 권위. |

### 6.5 비밀 위생 [HARD] — 확인 완료
- 신규 8 JSON + metamorphic-relations.json 내 JWT(`eyJ`)·세션쿠키명(PHPSESSID/kisession/AWSALB)·presigned·40+자 토큰 **0건**(grep 정밀검증).
- server.js 서버측 쿠키 주입 — reqBody/응답에 비밀 미기록.
- mb_cust_cod 전건 `10000000`(공개 익명 기본). 세션파생값 미발생(maskCustCode 미발동).
- ※주의: R2 입력 `huni-widget/01_reverse/redo-260623/captures/product_NCCDDFT.json`에 라이브 koiAccessToken JWT 평문 노출 — 본 작업 산출은 아니나 git추적 워크스페이스 비밀위생 위반(오케스트레이터 보고 권장).

### 6.6 캡처 메커니즘 (재현용)
- 기동: `cd raw/widget_monitor/local && (lsof -ti:3001 | while read p; do kill -9 $p; done); node server.js`
- 캡처: `cd _workspace/huni-re-verify/02_golden/captures/new-fields-260623 && node _capture-new-fields.cjs [시나리오]` + `node _capture-acceptance.cjs`
- 임시 probe 스크립트(/tmp)는 작업 후 정리 — widget_monitor/local(git추적)에 잔존 없음.
