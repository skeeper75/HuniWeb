# codex-reconcile-goods-pouch.md — 굿즈/파우치 가격엔진 설계 codex 독립 2차 교차검증 reconcile (Phase 5.5)

> **hpe-codex-validator 산출.** codex(gpt-5.5·effort high)의 굿즈/파우치 설계 독립 판정 ↔ hpe-validator(Claude) E1~E7 GO를 항목별 reconcile.
> ★독립성[HARD] 입증: codex 프롬프트(`_codex-prompt-goods-pouch.md`)에 hpe-validator의 E1~E7 결론·GO/NO-GO·verdict **일절 비노출**(설계 산출물 5파일 + 엔진 계약 사실만). codex 원출력 보존 = `codex-output-goods-pouch.md`.
> codex 판정 = **가설**(라이브/권위 검증 전 사실 아님·환각 경계·자동 flip 금지·라이브 우선). 모든 codex 주장에 `미검증` 태그.
> codex 가용성: **AVAILABLE** — `codex-cli 0.140.0`·`gpt-5.5`·`--sandbox read-only`·`-c model_reasoning_effort=high`·EXIT 0·6,983 bytes 정상 산출. (preflight 백그라운드 행 우회: stdin foreground 직접 호출·`timeout` 미설치→제거.)

---

## 0. 종합 reconcile 결론: **고신뢰 GO 확정 (divergence 0 · 진짜 충돌 0)**

| 축 | hpe-validator (Claude) | codex (gpt-5.5·high·`미검증`) | reconcile |
|----|------------------------|-------------------------------|-----------|
| **종합 판정** | **GO** (E1~E7 전건 PASS·차단 0·보정 0·정정 1[LOW]) | **CONDITIONAL GO** (큰 방향 맞음·신규 가격축 불요·5 돈크리티컬 차단조건) | **합의** — codex "조건"은 전부 validator가 이미 컨펌큐(Q-GP-*)·돈크리티컬 가드로 노출한 항목. 라벨 차이뿐(설계 결론 충돌 0) |
| **핵심 결판 4** | GP-1 PRODUCT_PRICE·GP-2 (b)formula·평탄화 가드·4타입 구간할인 전부 designer 정확 | Q1 GP-1 GO·Q2 GP-2 (b) 채택·Q3 평탄화 위험 실재·Q5 4타입 정당 — **독립 동일 도출** | **합의·divergence 0** |
| **신규 가격축/그릇** | 0건(공식2+comp2 mint뿐·rpmeta GS distinct 부결 정합) | "기존 그릇으로 닫힘·신규 테이블/add_price 불필요·답습 불요" | **합의** (5종단 신규축 0 일관) |
| **골든** | GC-GP1~12 12/12 허용오차 0·평탄화 양면 5500↔5000/6000 | GC-GP1~12 **산술 독립 재계산 전건 일치**·평탄화 양면 동일 산출 | **합의·고신뢰**(codex 직접 산술) |

**∴ 두 모델이 같은 증거(우리 verdict 비노출)로 독립 판정해 핵심 결론(GP-1 PRODUCT_PRICE·GP-2 (b)formula·평탄화 가드·4타입·신규축 0·골든)이 전건 합치 = 고신뢰 확정.** codex의 "CONDITIONAL"은 NO-GO 신호가 아니라 **구현 시 가드 강조**(적재 단계 차단조건)이고, 그 5개 조건이 전부 validator 컨펌큐·돈크리티컬 가드와 동일 → 새 충돌 0. **검증가 GO 유지 정당.**

---

## 1. 항목별 reconcile 매트릭스 (codex Q1~Q8 ↔ validator E1~E7)

| # | 항목 | codex 판정(`미검증`) | validator 판정 | 합의/divergence | 신뢰도 |
|---|------|---------------------|----------------|-----------------|--------|
| **R1** | GP-1 단일고정가 = product_prices 직접(명함식 공식 부결) | Q1 **GO** — "차원 없으니 공식으로 보내도 표현력 없음·과설계" | E2/E4 PASS — PRODUCT_PRICE 차원없는 단일가·comp 침입 불가·명함식 부결 무손실 | **합의** | 고 |
| **R2** | GP-2 그릇 = (b)variant-매트릭스 formula | Q2/Q7 **CONDITIONAL GO** — "(b)가 맞음·option_items add_price 없음·별 prd_cd는 부풀림·1축 매트릭스 최소" | E4 PASS — LINEN_FINISH opt_cd 선례 라이브 실재·add_price 부재 information_schema 확인·(c)DDL 부결 | **합의** | 고 |
| **R3** | ★GP-2 평탄화 오청구 위험 | Q3 **GO(위험 실재·평탄화 NO-GO)** — S5000/M5500/L6000·M에 S=500 과소·qty100 A10%면 **45,000 과소** 산술 | E6 PASS — 평탄화 양면 5500↔5000/6000 독립 재현·variant 판별차원 충전 방지 | **합의·돈크리티컬** | 고 |
| **R4** | 고정가형 ×qty 폭발·silent 합산 | Q4 **CONDITIONAL GO** — "개당가라 ×qty 정상·.02/min_qty NULL·use_dims[]/NULL 섞이면 위험" | E4/E5 PASS — comp 1배선·addtn_yn=N·.01·min_qty=1→구조적 부재 | **합의** | 고 |
| **R5** | 구간할인 4타입 택1 체계 | Q5 **GO** — "타입별 rate 다름 정당(B 100=285k vs A 100=270k)·단일 평탄화는 오청구" | E1/E6 PASS — 4종 byte-verbatim·A/B 구간차 입증 | **합의** | 고 |
| **R6** | 자재오염 정리 = 가격엔진 밖 위임 | Q6 **GO** — "소재 단가에 baked-in·엔진이 다시 합산하면 이중계상·BOM/카탈로그 문제" | E3 PASS — 본체소재≠가격축·component_prices 0참조·dbmap 위임 스코프분리 | **합의** | 고 |
| **R7** | 세트 레이어 불요 | (Q4/Q6 맥락 — 부품 합산 아님·이중계상 위험 언급) | E5 PASS — sets 0행·완제 개당가·이중계상 구조적 부재 | **합의** | 고 |
| **R8** | 골든 GC-GP1~12 | Q8 **CONDITIONAL GO** — 12건 산술 직접 재계산 **전건 일치**(285k·1.35M·270k·237.5k·2.4M·5k·5.5k·540k·325k·712.5k·160k) | E6 PASS — 12/12 허용오차 0 | **합의·고신뢰**(독립 산술) | 고 |

**divergence 0건.** codex CONDITIONAL = 구현 차단조건 강조이지 설계 부결 아님 → validator GO와 결론 동일.

---

## 2. ★codex 독립 발견 (echo 불가·고신뢰 신호)

codex가 우리 verdict 비노출 상태에서 **스스로 도출**한 위험 — designer/validator 문서에 명시 안 됐거나 강조 덜 된 것:

| 발견 | codex 표현(`미검증`) | 우리 산출물 대조 | reconcile 처분 |
|------|---------------------|------------------|----------------|
| **★GP-2 PRODUCT_PRICE 선점 함정** | "GP-2 상품에 t_prd_product_prices를 넣으면 안 됨. 우선순위 PRODUCT_PRICE→FORMULA라 단일 unit_price가 있으면 **formula가 영구히 무시**됨" | engine-design은 GP-1=PRODUCT_PRICE·GP-2=FORMULA로 경로 분리만 명시·**"GP-2에 product_prices가 있으면 formula 무시"는 명시적 가드로 노출 안 됨** | **★고신뢰 독립 발견(echo 불가)** — 엔진 우선순위 계약의 직접 귀결. GP-2 적재 시 **PRODUCT_PRICE 행을 만들지 말 것**을 적재 가드로 추가 권고(평탄화 가드 G-GP-3와 동근·평탄화보다 더 silent: 행 존재만으로 formula 전체가 무력화). dbm-price-arbiter·dbm-load-execution에 라우팅. |
| **활성 할인링크 단일성** | "del_yn 자동필터 불명·할인 링크 중복/논리삭제 행 살아나면 어떤 할인표 적용인지 불안정" | validator Q-GP-DSC-TYPE(타입 바인딩 재대조·FABRIC 카테고리단위 누락)와 동근이나 codex는 **중복 링크·논리삭제 행 측면**을 별도 강조 | **합의 보강** — validator 컨펌큐와 동일 진원(할인 바인딩 정합)·codex가 del_yn 미필터 가설로 보강. dbmap round-1 점검에 "활성 단일 링크" 가드 추가. |
| **variant 선택 누락 시 0원/실패** | "CPQ 선택값 누락 시 non-NULL 단가행이 no_match → 가격계산 실패 또는 0원" | validator Q-GP-OPT1(option_items 미적재 시 디폴트 variant·0원 침묵 회피)와 **동일** | **합의** — codex가 엔진 no_match 메커니즘으로 독립 재도출(echo 아님). |
| **가공가산 과금단위** | "가공 +300/+6500이 개당×qty인지 주문1회인지 확정 전 적재 금지" | validator Q-GP-FIN1·designer Q-GP-FIN1과 **동일** | **합의** — dbm-price-arbiter 심의 유지. |

★ **GP-2 PRODUCT_PRICE 선점 함정**은 codex가 엔진 계약(소스 우선순위)만으로 독립 도출한 진짜 신규 위험이다. validator는 G-GP-3 평탄화 가드로 "variant를 단일 unit_price로 평탄 적재 금지"를 명시했으나, codex는 한 단계 더 나아가 **"GP-2 prd_cd에 product_prices 행이 단 1건이라도 있으면 FORMULA 경로가 통째로 우회되어 variant 단가가 영영 안 먹힌다"**는 더 silent한 실패 모드를 짚었다. 평탄화는 "틀린 값"이지만 이건 "엉뚱한 행(있으면 안 될 평탄가)이 formula를 죽임" — echo 불가·최고신뢰. **적재 가드로 박제**(GP-2 상품은 product_prices INSERT 금지·formula 바인딩만).

---

## 3. 충돌·자동 flip 점검 [HARD]

- **라이브 권위 우선**: codex는 라이브 SELECT를 직접 수행하지 않음(설계 산출물 인용만). codex의 라이브 인용(LINEN_FINISH·option_items 컬럼·4종 구간)은 전부 우리 설계 산출물이 라이브에서 추출한 사실의 재인용이라 환각 위험 낮음. validator가 이미 라이브 직접 재실측(E4·E6)으로 확정 → codex 합치는 보강일 뿐 권위 역전 없음.
- **자동 flip 0**: codex CONDITIONAL이 validator GO를 뒤집지 않음(조건이 컨펌큐와 동일·NO-GO 신호 아님). codex 단독 주장(GP-2 PRODUCT_PRICE 선점)은 `미검증 가설`로 적재 가드 추가 권고만·verdict flip 아님.
- **가짜 합의 금지**: codex 산출 actionable·구체적(산술·차단조건)·빈 응답 아님. 합의는 실질(핵심 4결판·골든 12건·신규축 0 전건 일치).

---

## 4. 최종 신뢰도 + 라우팅

**굿즈/파우치 가격엔진 설계 = 고신뢰 GO 확정 (Phase 5.5 divergence 0).**

- ✅ **고신뢰 확정**: GP-1 PRODUCT_PRICE·GP-2 (b)formula·평탄화 가드·4타입 구간할인·신규 가격축 0·골든 12건 — 두 독립 모델 합치(우리 verdict 비노출 상태에서 codex 독립 도출).
- ★ **codex 독립 발견 박제(고신뢰 신호)**: **GP-2 PRODUCT_PRICE 선점 함정** — GP-2 상품에 product_prices 행 INSERT 금지(formula 영구 무시)·평탄화 가드 G-GP-3와 함께 적재 가드. dbm-price-arbiter·dbm-load-execution 라우팅.
- 컨펌큐 carry-forward(validator ↔ codex 합의): Q-GP-FIN1(가공 과금단위)·Q-GP-OPT1(option_items 주입·0원 침묵)·Q-GP-DSC-TYPE(할인 타입 바인딩 + 활성 단일링크)·Q-GP-CFLAT(C열 단가 추출)·Q-GP-7(폰케이스 등록)·정정-1(LOW·78→76상품).
- **DB 미적재[HARD]**: 모든 적재(product_prices INSERT·GP-2 공식2/comp2/단가행·바인딩·할인 링크·GP-2 product_prices 금지 가드)는 인간 승인 후 dbmap 위임(dbm-load-execution·dbm-axis-staged-load·dbm-price-arbiter). 평탄화·PRODUCT_PRICE 선점 돈크리티컬 가드·멱등·백업·undo. webadmin 코드 직접수정 금지.

---

## 부록 — codex 가용성 노트

| 항목 | 값 |
|------|----|
| 모델 | `gpt-5.5` (codex-cli 0.140.0) |
| sandbox | `read-only` (repo/DB 쓰기 0) |
| reasoning effort | `high` (`-c model_reasoning_effort=high`) |
| 호출 | stdin foreground 직접(`--skip-git-repo-check`·`--output-last-message`) — `timeout` 미설치(EXIT 127)→제거·preflight 백그라운드 행 우회 |
| 결과 | EXIT 0·6,983 bytes·actionable 독립 verdict(Q1~Q8 + 종합) |
| 독립성 | 우리 E1~E7·GO/NO-GO·verdict 프롬프트 비노출(echo 방지)·설계 5파일 + 엔진 계약 사실만 |
| 비밀값 노출 | 0(자격증명·.env.local 프롬프트 미포함) |
