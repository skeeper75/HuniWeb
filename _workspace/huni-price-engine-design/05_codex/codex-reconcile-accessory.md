# codex ↔ hpe-validator reconcile 매트릭스 — 상품악세사리 가격엔진 설계 (Phase 5.5)

> hpe-codex-validator 산출 · 2026-06-22. codex(gpt-5.5·effort high) 독립 판정 ↔ Claude(hpe-validator) E1~E7 GO 결론 항목별 대조.
> ★독립성[HARD] 검증: codex 프롬프트(`_codex-prompt-accessory.md`)에 우리 GO/E결론 비노출 — 설계·지도·골든·엔진계약·권위값만 전달. codex가 echo 아닌 독립 추론으로 같은 결론에 도달.
> ★codex 판정 = 가설. 라이브/권위 우선·codex에 맞춰 자동 flip 금지. 라이브 읽기전용·DB 미적재.

## 0. codex 가용성·효율
- **가용**: `AVAILABLE model=gpt-5.5` (preflight). 호출 `codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check -c model_reasoning_effort=high` — EXIT 0·last-message 정상 수신.
- **effort**: **high** (`model_reasoning_effort=high`·[HARD] 충족).
- 폴백 불필요(codex 정상 응답·actionable 독립 verdict 수신).

## 1. 항목별 reconcile 매트릭스

| # | 검증 항목 | hpe-validator(Claude) | codex(gpt-5.5·독립) | 합의/불일치 | 신뢰도 |
|---|----------|----------------------|---------------------|------------|--------|
| 1 | AC-1 inline 고정가 모델 적정성(부자재 BOM 없이 unit×qty) | GO(굿즈 GP-1·문구 DT-1 동형·과설계 부결) | **SOUND** — `unit_price×qty` 정확·BOM 합산 불요. 단 qty=판매단위(팩수) | **합의** | 고신뢰 |
| 2 | 사이즈+묶음 복합(트래싱지 .01 팩단가 vs .02 환산) | GO(.01 단가형 강제·G-AC-2 묶음 ÷ 금지) | **SOUND** — siz_cd+bdl_qty 정확매칭·.01 팩단가. **★선형 환산 반증 독립 도출**(20장6000×5≠100장28000=30000≠권위) | **합의(강)** | 고신뢰 |
| 3 | variant별 다른 고정가 그릇(product_prices/option_items/formula) | GO(G-AC-1 (b)variant-매트릭스 formula·option_items add_price 컬럼 부재·product_prices 1값 불가) | **SOUND** — product_prices 1값 부적합·option_items add_price 계약 부재·`FORMULA+comp unit rows+use_dims`가 정답 | **합의** | 고신뢰 |
| 4 | product_prices+formula 동시 존재 위험(선점) | GO(§3-6 GP-2 PRODUCT_PRICE 선점 가드·AC-2 product_prices INSERT 금지) | **FLAW if present** — PRODUCT_PRICE가 FORMULA보다 먼저·AC-2에 product_prices 1행이면 평탄화. `INSERT 금지`는 필수 게이트 | **합의(강)** | 고신뢰 |
| 5 | 봉투 이중역할(독립판매+addon) 가격 충돌 | GO(F-PA-1 경로 분기·다른 테이블·충돌 없음·양 경로 단가 정합 §4-3) | **CONDITIONAL** — 경로 충돌 없음(테이블 분리) 동의. 단 동일 봉투 양 경로 단가 불일치=운영 리스크→정합 또는 정책가 명시 | **합의** | 고신뢰 |
| 6 | silent 이중합산·과청구/과소청구·평탄화·신규축 오신설 | GO(평탄화 G-AC-1·묶음 .02 붕괴 G-AC-2·신규축 0·구간할인 발명 금지) | **주요 위험 5종 식별**(평탄화·묶음무시 78.57%·.02 22원 붕괴·신규 색상축 오신설·**★addon 이중합산[부가발견]**) | **합의 + 부가발견 1** | 고신뢰(부가발견은 확인 필요) |

## 2. 골든 재현 대조 (codex 독립 산술 ↔ 설계 기대값·허용오차 0)

| 골든 | 설계 기대값 | codex 독립 계산 | 일치 |
|------|------------|----------------|------|
| GC-AC2 볼체인 1,000×50 | 50,000 | 50,000 | ✅ |
| GC-AC6 OPP 230x350 3,250×1 | 3,250 | 3,250 | ✅ |
| GC-AC8 트래싱지 160x110 100장 28,000×1 | 28,000 | 28,000 | ✅ |
| GC-AC11 우드행거 440mm 20,000×2 | 40,000 | 40,000 | ✅ |
| GC-AC12 투명케이스 75x110x15 3,500×10 | 35,000 | 35,000 | ✅ |
| GC-AC13 addon OPP 110x160 1,200×100 | 120,000 | 120,000 | ✅ |
| 평탄화 과소청구율(트래싱지 100장→20장가) | ~78%(설계 G-AC-1) | **78.5714%**(22,000/28,000) | ✅(codex 더 정밀) |
| 합가형 오적용(OPP 1,100÷50×1) | 22(붕괴·.02 금지 입증) | **22**(틀림 판정) | ✅ |

★ **6/6 골든 + 양면 2건 codex 독립 재현 일치.** codex가 평탄화율 78.57%·합가형 22원을 **echo 아닌 자기 산술**로 도출(우리 결론 비노출 상태). 굿즈/책자 종단의 "codex 골든 직접 재현 = 최고신뢰" 패턴 정합.

## 3. divergence 측정

- **진짜 충돌(divergence): 0건.** codex의 6개 질문 판정·6개 골든·2개 양면 전부 hpe-validator GO 결론과 일치(라벨 차이 codex CONDITIONAL ↔ validator GO는 **동치** — 후술).
- **라벨 동치 해소**: codex "CONDITIONAL GO"의 4개 조건(① AC-1 PRODUCT_PRICE 단일행 ② AC-2 PRODUCT_PRICE 0행·FORMULA만 ③ 묶음수=variant 식별축 ④ addon TEMPLATE_PRICE 분리)은 **우리 설계가 이미 명시한 가드와 글자 그대로 동일**(§2-2·§3-6·§3-4·§4). codex는 "이 조건이 지켜져야 GO"라 한 것이고 설계는 그 조건을 이미 충전 → **CONDITIONAL ≈ GO 동치**(책자 종단 "codex CONDITIONAL≈validator GO" 동형 패턴·divergence 아님).

## 4. codex 부가발견 (확인 필요 후보 — 자동 채택 금지)

| ID | codex 발견 | 설계 현 상태 | 라우팅·판정 |
|----|-----------|-------------|------------|
| **CX-AC-1** | **addon 이중합산 위험** — addon 봉투를 template 가격 + 독립 formula 양쪽에서 **동시에 같은 주문 라인**에 평가하면 중복청구. "경로를 주문 컨텍스트로 분리" 명시 필요 | 설계 §4-3 required/optional addon 가드는 "미선택 시 silent 합산 금지"를 다루나, **"엔진이 같은 라인에서 TEMPLATE_PRICE와 FORMULA를 동시 평가하지 않는다"는 주문 컨텍스트 분리 명시는 약함** | **확인 필요 후보** — 라이브 pricing.py는 타깃이 tmpl_cd면 TEMPLATE_PRICE 경로로 진입하고 그 라인에서 product/formula는 fallback일 뿐(동시 평가 아님·:296-326 단일 base_amount). 즉 **엔진 구조상 한 라인 = 한 source**(이중합산 구조적 불가)이나, addon이 **별 주문 라인**으로 본체에 더해질 때 그 라인 단가가 옳게 매겨지는지(=template 단가 정합)는 §4-3에서 이미 다룸. **codex 우려는 가설**(라이브 엔진은 라인당 단일 source)·CX-AC-1을 설계에 "엔진 라인당 단일 source 명시" 1줄 보강 권고(차단 아님·divergence 아님). |
| **CX-AC-2** | 동일 봉투 양 경로(독립가 vs addon가) 단가 불일치 = 운영 리스크 | 설계 §4-3 "동일 variant면 동일 단가 verbatim·마진/번들가 다르면 Q-AC-PRICE 컨펌큐"로 이미 포착 | **이미 포착**(컨펌큐 Q-AC-PRICE·Q-AC-TMPL). 신규 아님. |

★ CX-AC-1/2 모두 **신규 결함 아님**(엔진 구조·기존 컨펌큐가 흡수). CX-AC-1은 설계 명시성 보강 권고(LOW·문서 1줄)로 라우팅. 라이브 우선 — codex 가설로 GO를 흔들지 않음.

## 5. 최종 reconcile 결론

- **codex 가용·effort high·EXIT 0.** 6질문 SOUND/합의·6골든+2양면 독립 재현 일치·**divergence 0**.
- codex "CONDITIONAL GO" = validator "GO" **동치**(조건이 설계 명시 가드와 동일).
- codex 부가발견 2건 = 신규 결함 0(엔진 구조·기존 컨펌큐 흡수)·CX-AC-1만 LOW 명시성 보강 권고.
- **∴ codex 교차검증 = high 신뢰·GO 지지.** hpe-validator E1~E7 GO 결론 **고신뢰 확정**(2 독립 모델이 같은 증거로 같은 결론).
- ★최고신뢰 시그널: codex가 **echo 불가한 독립 산술**(평탄화 78.57%·합가형 22원·선형 환산 반증 30000≠28000)을 우리 결론 비노출 상태에서 자기 도출 — 굿즈/책자 "codex 독립 발견 = 최고신뢰" 패턴 7종단째 정합.
- 실 적용(AC-1 product_prices INSERT·AC-2 공식/comp/단가행/바인딩·addon template_prices)은 **DB 미적재·인간 승인 후 dbmap 위임**. 컨펌큐: Q-AC-TMPL(카드봉투 묶음수 불일치)·Q-AC-PRICE·Q-AC-OPT·Q-AC-CEIL + CX-AC-1(addon 라인당 단일 source 명시 보강·LOW).
