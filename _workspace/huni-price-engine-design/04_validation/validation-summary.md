# validation-summary.md — 디지털인쇄 설계 종합 검증 판정

> **hpe-validator 종합.** engine-designer 디지털인쇄 설계(03_design) E1~E7 독립 검증 종합.
> 라이브 읽기전용 재실측 2026-06-20 · pricing.py 순수 헬퍼 직접 실행 · 생성자 주장 비신뢰.
> 상세: `gate-verdict-digitalprint.md`·`recompute-log.md`.

---

## 종합 판정: **NO-GO (조건부 — 보정 후 재게이트)**

| 게이트 | 판정 |
|--------|------|
| E1 공식 추출 충실성 | PASS |
| E2 구성요소 분해 정합 | CONDITIONAL |
| E3 경쟁사 흡수 타당성 | PASS |
| E4 엔진 설계 건전성 | CONDITIONAL |
| **E5 세트 조합 정합** | **FAIL** |
| **E6 골든 재현** | **FAIL** |
| E7 생성-검증 독립성 | PASS |

E5·E6 FAIL → 전건 통과 미충족 → **NO-GO**.

---

## 핵심 한 줄

설계는 **상품군/구조 레벨에서 대체로 옳다**(공식 추출·orphan 바인딩·search-before-mint·흡수 판정 견고).
그러나 **라이브 결함의 범위와 메커니즘 두 가지를 오판**해 NO-GO:

1. **범위 과소**: D-10(prc_typ 단가형 ×qty 과대청구)을 "명함 8종"으로 한정했으나, 라이브 재계산이
   **엽서북·포토카드BULK·박 SETUP까지 전 고정가형 횡단 결함**임을 입증. 설계 골든(엽서북 11,000·박 29,800)이
   라이브 산출(45,000·8,940,000)과 ×qty 배수로 전면 불일치.
2. **메커니즘 오진**: D-2b를 "ERR_AMBIGUOUS(견적 깨짐)"라 진단했으나 실제는 **인쇄면 차원 부재로 인한
   S1+S2 silent 이중합산(경고 없이 과청구·더 위험)**. ERR_AMBIGUOUS는 한 comp 내부에서만 발생하고
   S1/S2는 별 comp라 절대 발생 안 함.

★ **중요**: 이 FAIL의 진원은 전부 **라이브 데이터/구조 결함**이지 설계가 만든 값의 오류가 아니다.
설계 골든값(3500·11000·9500·29800)은 가격표 verbatim으로 **옳다**. 다만 설계가 그 골든을 "정합 기대값"으로
제시하면서 라이브의 ×qty 폭발을 D-10 컨펌큐 한 칸으로만 처리해, **골든 테이블이 라이브 현실을 미반영**한 게 결함.

---

## 보정 요구 (재게이트 조건)

| # | 보정 | 근거 | 우선순위 |
|---|------|------|----------|
| **R-1** | D-10 범위를 **전 고정가형**으로 확장 — 명함 8종 + 엽서북(PCB) + 포토카드 BULK + 박 SETUP. 전부 prc_typ=단가형인데 단가가 묶음/구간 총액 → ×qty 과대청구 | recompute-log §1·4·5·6 | 🔴 돈크리티컬 |
| **R-2** | D-2b 재서술 — "ERR_AMBIGUOUS"→"인쇄면 차원 부재로 S1+S2 silent 이중합산"(V-DGP-1). ERR_AMBIGUOUS는 발생 안 함(별 comp). 명함·엽서북 동형 | gate E2·recompute §3 | 🔴 High |
| **R-3** | 엽서북 §set-product "이중계상 0" 판정 철회 — 엽서북도 ① 인쇄면 이중합산 ② prc_typ ×qty 두 결함 보유. 명함과 동일 결함군으로 재분류 | gate E5·recompute §4 | 🔴 High |
| **R-4** | 박 SETUP(동판비) 처리 명시 — `use_dims=[]`·min_qty=NULL·단가형이라 ×qty 폭발(300매 시 동판 1.5M). "정액 1회"가 의도면 **합가형 min_qty=1** 또는 별도 정액 comp 처리 명세 | recompute §6 | 🔴 High |
| **R-5** | D-3 사유 정정 — print_opt_cd 충전이 푸는 것은 이중합산(R-2)이지 ambiguous 아님. 충전 자체는 타당(POPT_000001/002 실재). 단 option_items 매핑 0행이라 옵션→차원 자동주입 미연결(G-7 유효) | gate E4 | 🟡 Med |
| **R-6** | prc_typ 교정 방향 결정 — 고정가형 단가가 "묶음총액"이면 **합가형(PRICE_TYPE.02) ÷min_qty** 전환이 정답(÷100=장당가). 단 명함은 "100매 1세트 고정주문"일 수 있어 그 경우 주문UX qty=100 고정+합가형이 안전. 도메인 확정 필요 | recompute §1·design D-10 | 🔴 돈크리티컬 |

---

## 컨펌큐 (사용자/도메인 — designer 컨펌큐 + 검증 추가분)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| **CV-1** | 고정가형 가격 의미 = "묶음총액"인가 "장당가"인가 — 묶음총액이면 prc_typ 단가형(.01)이 전건 오적재, 합가형(.02)로 교정 필요 | dbm-price-arbiter + 사용자 | 명함/엽서북/포토카드BULK/박 전 고정가형 견적 정합 |
| **CV-2** | 명함 주문 UX = "100매 고정세트"인가 "장당 누적 주문"인가 — 고정세트면 qty=100 고정+합가형, 누적이면 합가형 ÷min_qty | 사용자 | prc_typ 교정 방향 |
| **CV-3** | 인쇄면(단면/양면) = 같은 공식 내 print_opt_cd 차원으로 통합인가, comp 분리 유지+차원 충전인가 — 통합(comp 1개)이 이중합산 원천 차단 | dbm-price-arbiter | V-DGP-1 해소법 |
| **CV-4** | 박 동판비 = 수량 무관 1회 정액 확정인가 | 사용자·가격표 | R-4 처리 |
| (designer 큐 유지) | G-6b 봉투류 경계·G-7 option_items 매핑·S-1 엽서북 BOM·형압명함 comp | designer/사용자 | 바인딩 확정 |

---

## 라우팅

- **돈크리티컬 결함(R-1·R-4·R-6·CV-1·CV-2)** → `dbm-price-arbiter` 심의 + 사용자 컨펌. 실 prc_typ 교정은
  인간 승인 후 dbmap 적재 트랙(dbm-axis-staged-load·dbm-load-execution) 위임.
- **설계 보정(R-2·R-3·R-5)** → engine-designer 폐루프(재설계) — 골든 테이블·set-product 판정·D-2b/D-3 사유 정정.
- **확정 결함(D-2a misfire·G-4 미바인딩 7 variant)** → 라이브 결함 확정·designer 신설 PRF 바인딩 명세 유효.

## DB 미적재 [HARD]

본 검증은 라이브 읽기전용 SELECT만 수행·DB 쓰기 0. 모든 결함 교정(prc_typ 전환·인쇄면 차원 통합·PRF 신설·
바인딩)은 **인간 승인 후 dbmap 위임**. 검증 산출은 분석·판정 전용.

---

# 아크릴 면적매트릭스형 설계 종합 검증 판정 (2026-06-20·carry-forward)

> 상세: `gate-verdict-acrylic.md`·`recompute-log-acrylic.md`. 라이브 읽기전용 재실측·engine 충실 재구현 재계산.

## 종합 판정: **GO (조건부 컨펌큐 동반)**

| 게이트 | 판정 |
|--------|------|
| E1 공식 추출 충실성 | PASS (LOW F-A-1: B-label 원천 불일치·값 verbatim 동일) |
| E2 구성요소 분해 정합 | PASS |
| E3 경쟁사 흡수 타당성 | PASS (신규 vessel 0) |
| E4 엔진 건전성 + min_qty 계약 | PASS (LOW F-A-2: comp_typ 시맨틱) |
| E5 세트/바인딩 + G-A1 | PASS |
| E6 골든 재현(허용오차 0) | PASS (8/8 일치) |
| E7 생성-검증 독립성 | PASS |

**E1~E7 전건 PASS → GO.** 디지털인쇄 NO-GO와 대조적 — 아크릴은 ×qty 폭발·silent 이중합산이 **구조적으로 없음**(단가=개당가·공식당 comp 1개)을 라이브·코드·재계산으로 입증.

## 핵심 한 줄

본체(투명/코롯토) 가격사슬은 라이브에 무결 적재(단가행 238·골든 8건 허용오차 0 재현). 설계의 핵심 작업은 **신규 mint가 아니라 바인딩**(G-A1: 활성 17상품 중 16 미바인딩=가격계산 불가, PRF_CLR_ACRYL/COROTTO 재사용 INSERT로 해소·신규 0). 신규 mint(미러 공식·카라비너 comp/공식·후가공 comp)는 전부 컨펌 대기로 정직 분리되어 GO를 막지 않음.

## min_qty 계약 라이브 confirm (designer 주장 → 반증 실패=옳음)

- CLEAR3T: 165행 전건 min_qty=1(NULL 0)·.02 → ÷1=개당가 ✅
- COROTTO: 21행 전건 min_qty=1·.01 ✅
- MIRROR3T: 52행 전건 min_qty=**NULL**·.01 → ÷ 미발생·ValueError 0 ✅
- ×qty 위험 0: 단가=개당 완제품가(디지털 묶음총액과 정반대)·`component_subtotal`(pricing.py:177-192) 코드+재계산 증명.

## 보정 요구

**차단 결함(NO-GO) 0건.** 보정 요구 없음. LOW 2건은 컨펌큐(가격 무영향).

## 컨펌큐 (designer 큐 유지 + 검증 추가)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| CA-1 | 미러 = 별 공식(PRF_MIRROR_ACRYL) vs 본체 소재옵션(투명/미러 택1) 합류 — 합류 시 MIRROR3T에 mat_cd 판별차원 충전 선결(silent 이중합산 가드)·미러 본체 상품 0개 | dbm-price-arbiter·사용자 | 미러 바인딩 방식(Q-ACR-MIR1) |
| CA-2 | 코롯토 정체 — 입체(168)/포카(165)/쉐이커(226)가 모두 B06 단일 면적매트릭스인가(별 단가체계면 별 comp) | 사용자·실무 | 코롯토 바인딩 동형 가정(Q-ACR-CO1) |
| CA-3 | 카라비너 형상 opt_cd 채번 + comp/공식 신설(PRD_000166 비활성·LOW)·comp_typ .06 시맨틱(F-A-2) | 채번 트랙·개발자 | 활성화 시 일괄 |
| CA-4 | 후가공(고리/자석) 가산 = 개당 1회 vs ×수량(B05) — COMP_ACRYL_FINISH prc_typ 설계(추측 적재 금지·디지털 동형 위험) | dbm-price-arbiter·사용자 | Q-ACR-FIN1 |
| CA-5 | 두께 선택 UI → mat_cd 주입(option_items→mat_cd) — 미선택 시 no_match 0원 침묵 가드 | round-6 CPQ | Q-ACR-MAT1 |
| CA-6 | B-label 인용 통일(추출본 vs 체인설계 doc) | designer | F-A-1·가격 무영향 |

## 라우팅

- **본체 17상품 바인딩(G-A1)** → 신규 mint 0·인간 승인 후 dbmap(dbm-load-execution) 위임. 1순위(가격계산 불가 직결).
- **미러·후가공 가산 의미(CA-1·CA-4)** → dbm-price-arbiter 심의 + 사용자 컨펌(돈크리티컬·추측 적재 금지).
- **카라비너 신설·채번(CA-3)** → PRD 활성화 시·채번 트랙.
- **codex 2차(Phase 5.5)** → 오케스트레이터 reconcile(본 판정은 독립·codex 비참조).

---

# 실사·현수막 면적매트릭스형 설계 종합 검증 판정 (2026-06-20·carry-forward)

> 상세: `gate-verdict-silsa-banner.md`·`recompute-log-silsa-banner.md`. 라이브 읽기전용 재실측·engine 충실 재구현 재계산.

## 종합 판정: **GO (조건부 컨펌큐 동반)**

| 게이트 | 판정 |
|--------|------|
| E1 공식 추출 충실성 | PASS |
| E2 구성요소 분해 정합 | PASS |
| E3 경쟁사 흡수 타당성 | PASS (신규 vessel 0·naming 유입 0) |
| E4 엔진 건전성 + min_qty 계약 | PASS (LOW F-S-1: 배너 후가공 use_dims 라이브 이질성 under-statement) |
| E5 세트/바인딩 + G-S1 | PASS |
| E6 골든 재현(허용오차 0) | PASS (13건+에러 2건 일치) |
| E7 생성-검증 독립성 | PASS |

**E1~E7 전건 PASS → GO.** 아크릴 동형(GO)·디지털 NO-GO와 대조 — 실사·현수막은 본체 가격사슬이 라이브에 **완성**(28공식·28상품 1:1 바인딩·동형결합 13→7 COMMIT)되어 있고, ×qty 폭발·silent 이중합산이 본체에 **구조적으로 없음**(전건 .01 단가형·1장당가·공식당 comp 1개)을 라이브·코드·재계산으로 입증.

## 핵심 한 줄

본체(면적 13·고정가 13·수량구간 2)는 라이브 무결(골든 13건 허용오차 0 재현). 설계의 핵심 작업은 **신규 mint가 아니라 후가공 배선**(G-S1: 전 PRF가 comp 1개뿐·후가공 disp_seq 2~ 0건=견적 시 후가공 가격 반영 0). 단 **배너 후가공(PUNCH/QBANG/STRING/거치 use_dims=[])은 판별차원 충전이 배선의 절대 선결**(미충전 배선 시 타공 4+6+8 silent 합산 20,000 과청구 재계산 실증). designer가 이를 정확히 식별하고 선결로 명시 → 돈크리티컬 결함을 설계 단계에서 차단.

## min_qty / prc_typ 계약 라이브 confirm (designer 주장 → 반증 실패=옳음)

- 면적/고정가/수량구간 본체 28 comp 전건 `PRICE_TYPE.01`·면적 본체 min_qty NULL/1·직접단가 override 0행 → ÷min_qty 구조적 미발생·×qty가 곧 정답(1장당가).
- 디지털 ×qty 결함·아크릴 .02 미확정 위험 둘 다 **부재**(단가 의미가 1장당 완제품가·.01)·재계산 입증.

## 보정 요구

**차단 결함(NO-GO) 0건.** 보정 요구 없음. LOW 2건은 컨펌큐(가격 무영향).
- F-S-1(LOW): 배너 후가공 use_dims 라이브 부분 백필 3건(MESH_PUNCH_6·NORMAL_QBANG_4·MESH_PROC_OPT)을 "일괄 []"로 평탄화 기술·단 단가행 컬럼 NULL이라 여전히 silent 위험·designer 처방이 닫음. Q-SB-PUNCH-DIM에 명시 추가 권고.

## 컨펌큐 (designer 큐 9건 유지 + 검증 보강)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-SB-PROC-QTY | ★거치/배너 후가공(우드행거 20,000·PET거치 25,000) 가산=1주문건당 통액 vs ×수량(.01 ×qty 과청구 위험) | dbm-price-arbiter·실무 | 돈크리티컬·배선 전 확정 |
| Q-SB-PUNCH-DIM(+보강) | 배너 후가공 판별차원 충전(택1 타공 4/6/8 통합+opt_cd·택N 각 opt_cd) + **부분 백필 3건 단가행 컬럼 충전**(use_dims만 채운 잔류=거짓 안전감·F-S-1) | 실무·채번 | G-S1 배선 선결·돈크리티컬 |
| Q-SB-MINI-DSC | 미니류 수량밴드(본체 내장 볼륨할인)+t_dsc 이중할인 금지 | dbmap round-1 | 이중할인 방지 |
| Q-SB-CH1 | 캔버스행잉 use_dims=[siz_w,h,min_qty] vs 실 3행 NULL 고정3규격 정합 | 실무 | 가격축 정확성 |
| Q-SB-FIXED-LEGACY | 레거시 PRF_POSTER_FIXED(고아·바인딩 0) 정리 | 개발자 | 정리·가격 무관 |
| (designer 큐 유지) | Q-SB-MINI-MIN·DIM1·NSPEC1·DSC1 | 실무/개발자 | 경계 확정 |

## 라우팅

- **G-S1 후가공 배선 + 배너 후가공 판별차원 충전(돈크리티컬·Q-SB-PUNCH-DIM·PROC-QTY)** → dbm-price-arbiter 심의(1건당 vs ×수량 확정) + 인간 승인 후 dbmap(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer opt_cd 채번). 미충전 배선 절대 금지.
- **본체 = confirmed-good** — 28공식·바인딩·동형결합·신안 WH 전환 라이브 COMMIT. 건드리지 말 것.
- **codex 2차(Phase 5.5)** → 오케스트레이터 reconcile(본 판정은 독립·codex 비참조).

---

# 문구 고정가형+수량구간할인 / 매트릭스형 설계 종합 검증 판정 (2026-06-20·carry-forward)

> 상세: `gate-verdict-stationery.md`·`recompute-log-stationery.md`. 라이브 읽기전용 재실측·pricing.py 충실 재구현 재계산.

## 종합 판정: **GO (조건부 컨펌큐 동반)**

| 게이트 | 판정 |
|--------|------|
| E1 공식 추출 충실성 | PASS |
| E2 구성요소 분해 정합 | PASS |
| E3 경쟁사 흡수 타당성 | PASS |
| E4 엔진 설계 건전성 | PASS (LOW 정정 1) |
| E5 세트 조합 정합 | PASS |
| E6 골든 재현 | PASS (15/15·허용오차 0) |
| E7 생성-검증 독립성 | PASS |

전건 PASS → **GO**. 첫 게이트부터 GO(디지털 NO-GO·보정 폐루프와 대조, 아크릴 GO 동류). 4번째 종단.

## 핵심 한 줄

문구는 **두 가격 클래스**(본체 9=고정가 product_prices·떡메모 1=매트릭스 FORMULA), 둘 다 DSC_STAT_QTY 곱. 라이브 실측이 cartographer↔designer 충돌 2종을 designer 손으로 결판: **① 떡메모 ×qty 폭발 없음**(unit=권당가·단가 사다리 단조 하락 실증·.01 단가형 ÷min_qty 미발생) **② DSC 링크 누락 4건**(173/174/175/097=과청구·계산불가). 신규 mint 0. 골든 15/15 허용오차 0.

## 충돌 결판 라이브 confirm (cartographer 가설 → 반증·designer 옳음)

- **DT-2 떡메모 ×qty**: cartographer "unit=묶음총액·교정안 A(÷min_qty) 필요" → **반증**. 라이브 COMP_TTEOKME 사다리(90x90 100장1권: 6권 3200→600권 1050 단조 하락)가 unit=권당가 증명(묶음총액이면 권수↑에 단가↓ 불가). pricing.py :192 단가형 ÷min_qty 미발생 코드 확정. ÷min_qty 적용 시 GC-ST10이 3,200≠19,200(골든 모순).
- **DT-4 DSC 링크**: 라이브 6/9 실재·누락 4건(173/174/175/097) 전수 SELECT 확인. designer 정확. 과청구(GC-ST4 +150,000)·바인딩 0 계산불가(GC-ST12) 실증.

## 보정 요구

**없음(차단 결함 0).** LOW 정정 2건(가격 무영향·문서만):
- E4 LOW: 설계 §6 "option_items 전역 0행" → 라이브 전역 477행(stale)·**문구 상품 0행**으로 표현 정정(문구 결론은 유효).
- E1 LOW: 본체 사이즈 표기 정밀화(먼슬리 A5·중철노트 A6·스프링수첩 90x145·권위 엑셀).

## 컨펌큐 (designer 큐 + 검증 보강)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-ST-DSC-LINK | ★링크 누락 4(173/174/175/097)=과청구. 상품마스터 "구간할인적용테이블" 재대조 후 INSERT | dbmap round-1 | 돈크리티컬·검증 실증 |
| Q-ST-DSC-DOUBLE | 떡메모 unit 사다리(내장 볼륨할인) 위 DSC_STAT_QTY 곱=이중할인 의도 여부 | dbm-price-arbiter | 이중할인 방지 |
| Q-ST-MEMO1 | 메모패드 2사이즈 2가격=사이즈 차원 공식 vs 별 prd_cd(라이브=단일 prd) | 실무 | 메모패드 그릇 |
| Q-ST-OPT1 | 떡메모 사이즈/권당장수 옵션→차원 주입(문구 상품 option_items 0행) | round-6 | 0원 침묵 회피 |
| DT-BIND | 책자(부품 합산형)·D-BIND-SCOPE | dbm-price-arbiter·사용자 | 스코프 밖·다음 종단 |

## 라우팅

- **본체 9 product_prices INSERT(verbatim) + DSC 링크 3 보완(173/174/175)** → 인간 승인 후 dbmap. 돈크리티컬.
- **떡메모 바인딩(097→PRF_TTEOKME_FIXED) + DSC 링크 1(097)** → 인간 승인 후 dbmap. Q-ST-DSC-DOUBLE arbiter 선결.
- **설계 LOW 정정 2** → designer 폐루프(문서만).
- **codex 2차(Phase 5.5·문구)** → 오케스트레이터 reconcile(본 판정 독립·codex 비참조).

---

# 책자(반제품 세트·다부품 합산형) 설계 종합 검증 판정 (2026-06-20·5번째 종단·§18 directive "반제품 세트" 첫 본격)

> 상세: `gate-verdict-booklet.md`·`recompute-log-booklet.md`. 라이브 읽기전용 재실측·pricing.py+models.py 코드 검증·engine 충실 재구현 재계산.

## 종합 판정: **GO (조건부 컨펌큐 동반)**

| 게이트 | 판정 |
|--------|------|
| E1 공식 추출 충실성 | PASS (LOW: freshness reg_dt/upd_dt 표기·값 verbatim 동일) |
| E2 구성요소 분해 정합 | PASS |
| E3 경쟁사 흡수 타당성 | PASS (신규 가격축 0·naming 유입 0·jobqty 2단 부결) |
| E4 엔진 설계 건전성 | PASS (★del_yn 필터 부재 코드 확정·proc_cd 분기·combo_key 가드) |
| E5 세트 조합 정합 | PASS (sub_prd 가격 비기여·면지 합산 금지·088 BLOCKED 정직) |
| E6 골든 재현(허용오차 0) | PASS (GC-BK1~6 6/6 일치·corrupt/corrected 양면·GC-BK7/8 구조) |
| E7 생성-검증 독립성 | PASS |

**E1~E7 전건 PASS → GO.** 아크릴·실사·문구 GO 동류(첫 게이트부터)·디지털 NO-GO와 대조. 책자=§18 directive "반제품 세트" 첫 본격 종단인데 결함이 **데이터(오염·stale 배선)이지 설계 골든값 오류 아님**을 라이브·코드·재계산으로 입증(디지털 NO-GO와 결정적 차이).

## 핵심 한 줄

책자 제본비 가격사슬은 **두 데이터 결함**(G-BK-1 중철 단가행 오염=트윈링값 byte-복사·G-BK-2 PRF_BIND_SUM이 삭제 JUNGCHEOL 참조)을 보유하나 designer가 둘 다 정확히 적발·교정 명세. **돈크리티컬 `.01` 부당단가 해소도 PUR 사다리 단조 하락(5000→1500) 실측으로 비준**(디지털 묶음총액 무비판 전이 금지 정확). 설계의 핵심 작업=신규 mint 아닌 **재배선(W1) + 단가행 교정(W2·B01 verbatim 8행) + 세트 부모 바인딩(W4)**. 골든 GC-BK1~6 허용오차 0(corrupt 12,000 vs corrected 8,000 양면 실증·과청구 50%). 표지/내지 합산(W3·DT-BIND-SCOPE=부품 합산)은 단가 소스 미확정(Q-BK-COVER)이라 `확신도: 중`으로 정직 보류·GO 막지 않음.

## ★검증가 발굴 — del_yn 필터 부재 코드 결판 (설계 "검증 인계" 질문 답)

- pricing.py에 `del_yn` 참조 0건·모델 기본 매니저(del 필터 없음). `_evaluate_formula`/`_component_rows`가 del_yn 미필터 → **삭제 comp(JUNGCHEOL del='Y')도 평가됨**. 설계의 "필터 적용 시 0원" 가설은 코드상 발생 안 함(misfire/0원[proc 미주입] 분기만)이나 **결론(4상품 정상 가격 불가→W1 재배선 필수) 불변**. 정정 권고 LOW(표현 정밀화·designer 폐루프).

## min_qty / prc_typ 계약 라이브 confirm (designer 주장 → 반증 실패=옳음)

- COMP_BIND 11종 전건 `.01 단가형`·min_qty NULL 0건 → ÷min_qty 구조적 미발생·ValueError 0.
- PUR 단가 사다리 단조 하락(직접 SELECT) = 부당단가 + 볼륨할인 입증 → `.01 × qty` 정합·교정 불요. 디지털 명함 묶음총액 ×qty 폭발과 단가 의미 정반대.

## 보정 요구

**차단 결함(NO-GO) 0건. 보정 요구 없음.** 정정 권고 1(LOW·가격 무영향·designer 폐루프):
- §2.1·DB-4 "del 필터 적용 시 0원" 가설 → 코드상 미발생(필터 부재) 표현 정밀화 + freshness "upd_dt 2026-06-17"→"reg_dt 2026-06-17·upd_dt NULL".

## 컨펌큐 (designer 큐 6건 유지 + 검증 보강 2)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-BK-COVER | ★표지/내지 단가 소스(디지털 종이비 vs 책자 전용)·COMP_PAPER 2회 배선 combo_key 충돌→전용 comp 분리 | 가격표·dbm-price-arbiter | DB-6·돈크리티컬 |
| Q-BK-COVER(+검증) | ★COMP_PRINT_DIGITAL_S1 use_dims `proc_grp:PROC_000001`(디지털인쇄 공정)이 책자 표지/내지 인쇄에 정합한지(불일치=0원 침묵 또는 전용 인쇄 comp) | dbm-price-arbiter | 재사용 무손실성 |
| Q-BK-PROC | ★제본방식→proc_cd 주입(미주입 시 0원 침묵·행 proc non-NULL이라 silent 합산 아님) | round-6 dbm-option-mapper | W1 재배선 선결·돈크리티컬 |
| Q-BK-PHOTO | 포토북 제본방식·표지 6 variant 단가·면지 104 가격기여 | 실무·가격표 | 포토북 바인딩 |
| Q-BK-BINDER | 레더 링바인더(088) "(보류중)"·제본방식 | 실무·상품마스터 | 088 BLOCKED |
| Q-BK-MYUNJI | 면지 색별 단가차 여부 | 실무·가격표 | 이중계상 가드 |
| Q-BK-DSC | 책자 수량구간할인 링크 유효성(미점검) | dbmap round-1 | 할인 적용 |
| CV-BK-FRESH(검증) | freshness reg_dt 2026-06-17·upd_dt NULL | designer | LOW·문서만 |

## 라우팅

- **W1 재배선 + W2 중철 단가행 교정(B01 verbatim 8행)** → dbm-price-arbiter + 인간 승인 후 dbmap. 돈크리티컬·과청구 50%·멱등·백업·undo.
- **W3 표지/내지 합산(Q-BK-COVER 확정 후) + W4 세트 부모 바인딩(072/077/082/100)** → dbm-price-arbiter(단가 소스·combo_key·proc_grp 정합) + 인간 승인 후 dbmap. 088 BLOCKED.
- **Q-BK-PROC proc_cd 주입** → round-6 dbm-option-mapper(W1 선결).
- **설계 정정-1(LOW)** → designer 폐루프(문서만).
- **codex 2차(Phase 5.5·책자)** → 오케스트레이터 reconcile(본 판정 독립·codex 비참조).

---

# 굿즈/파우치 (goods-pouch) — 종합 판정: **GO** (6번째 종단·E1~E7 전건 PASS)

> hpe-validator 독립 검증 2026-06-20(라이브 읽기전용 SELECT·pricing.py 코드 직접·골든 15건 충실 재구현). 상세 = `gate-verdict-goods-pouch.md`·`recompute-log-goods-pouch.md`.

굿즈/파우치는 **첫 게이트부터 GO**(디지털 NO-GO·보정 폐루프와 대조·아크릴/실사/문구/책자 GO 동류). 5종단 중 **계산방식 가장 단순(전건 고정가형)·라이브 가장 미완성(product_prices 0행)**. 핵심 4결판(GP-1 PRODUCT_PRICE 동형·GP-2 (b)formula 그릇·G-GP-3 평탄화 가드·4타입 구간할인) 전부 라이브로 designer 정확 확인. 신규 가격축/테이블 0.

| 게이트 | 판정 | 핵심 근거 |
|--------|------|-----------|
| E1 공식 추출 | PASS | calc-draft 고정가형 단일유형·4종 구간 byte-verbatim·완성도 수치(0/88/0/82) 전건 일치·날조0 |
| E2 구성요소 분해 | PASS | GP-1 PRODUCT_PRICE(차원없는 단일가·comp 침입 불가)·GP-2 comp 1배선(opt_cd/siz_cd)·본체소재 BOM≠가격축 |
| E3 흡수 타당 | PASS | 신규 가격축0·naming 유입0·자재오염 dbmap 위임 스코프분리 적절·rpmeta GS distinct 부결 정합 |
| E4 엔진 건전성 | PASS | PRODUCT_PRICE/FORMULA 경로 코드 확정·opt_cd·siz_cd 둘다 NON_QTY_DIMS(:38)·LINEN_FINISH 선례 실재·option_items add_price 부재 확인·`.01` min_qty·평탄화 가드 |
| E5 세트 조합 | PASS | t_prd_product_sets 굿즈 0행·세트 레이어 불요 확정·완제 개당단가·이중계상 구조적 부재 |
| E6 골든 재현 | PASS | GC-GP1~12 **12/12 일치(허용오차 0)**·GC-GP13~15 rate 재현·평탄화 양면 5500↔5000/6000 독립 재현 |
| E7 독립성 | PASS | 핵심 4결판 라이브 독립 재실측·평탄화 양면 자체 재계산·골든 충실 재구현·dodge/self-approve 없음 |

## 라이브 confirm 핵심 (designer 주장 → 직접 반증 실패=옳음)

- **GP-2 (b)formula 선례 라이브 실재**: `COMP_POSTEROPT_LINEN_FINISH` use_dims=`["opt_cd","min_qty"]`·comp_typ .06·prc_typ .01·use_yn=Y·del_yn=N. search-before-mint 강하게 충족·신규 mint=공식2+comp2뿐.
- **option_items add_price 부재**: information_schema 직접 — add_price/amt 컬럼 없음 → (c)DDL안 부결 정확.
- **4종 구간할인 byte-verbatim**: GOODSA/GOODSB/FABRIC/SQUISHY 디테일 전건 일치·DSC_TYPE.01 정률·바인딩 82.
- **세트/CPQ/formula/product_prices 굿즈 전무**: 현 source=NONE·0원·진원=고정가 본체 미적재(단가값 결함 아님·C열 verbatim 옳음).

## 보정 요구

**차단 결함(NO-GO) 0건. 보정 요구 없음.** 정정 권고 1(LOW·가격 무영향): engine-design §0 자재 BOM "78상품"→라이브 실측 "76상품" 정밀화.

## 컨펌큐

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-GP-FIN1 | 가공 가산(라벨 +300·맥세이프 +6500) 개당 1회 vs ×수량 | dbm-price-arbiter·실무 | 돈크리티컬 |
| Q-GP-OPT1 | GP-2 variant option_items 적재 선결(현 0행·0원 침묵 회피) | round-6 dbm-option-mapper | GP-2 가격계산 직결 |
| Q-GP-DSC-TYPE | 할인타입 바인딩 권위=상품마스터 "구간할인적용테이블"·FABRIC 카테고리단위 누락 점검 | dbmap round-1 | 4타입 곱·과청구 |
| Q-GP-CFLAT | GP-1 ~48상품·FABRIC C열 단가 dbmap 전수 추출 | dbmap C열 추출 | 골든 수치 |
| Q-GP-7 | 폰케이스 기종(Sheet-only·미등록) 등록 선행 후 바인딩 | round-24·실무 | GP-2 확장 |
| CV-GP-MAT(검증) | 자재 BOM 78→76 정밀화 | designer | LOW·문서만 |

## 라우팅

- **GP-1 product_prices INSERT·GP-2 공식2+comp2+단가행·바인딩·할인 링크** → dbm-price-arbiter + 인간 승인 후 dbmap. 평탄화 가드·min_qty=1·멱등·백업·undo. 돈크리티컬.
- **Q-GP-FIN1** → dbm-price-arbiter. **Q-GP-OPT1** → round-6 dbm-option-mapper(선결). **자재오염 정리** → dbm-axis-staged-load ④자재·ddl-proposer(스코프 밖).
- **설계 정정-1(LOW)** → designer 폐루프. **codex 2차(Phase 5.5·굿즈/파우치)** → 오케스트레이터 reconcile(본 판정 독립·codex 비참조).

---

# 스티커 (sticker) — 종합 판정: **조건부 GO** (7번째 종단·E1 CONDITIONAL·E2~E7 PASS·보정 1[돈크리티컬 정합])

> hpe-validator 독립 검증 2026-06-20(라이브 읽기전용 SELECT·pricing.py 코드 직접·골든 GC-STK1~8 충실 재구현·허용오차 0). 상세 = `gate-verdict-sticker.md`·`recompute-log-sticker.md`.

스티커는 **6종단 중 라이브 완성도 최고**(공식 4·comp 4·단가행 3,066·바인딩 16/16 전건 실재·dbmap round-23 적재 완주). designer 핵심 명제(이산 siz_cd 단가형·B06 팩 .02 결판·동형결함 3종 부재·G-STK-1~4 바인딩 교정·세트조합 불요·신규 mint 0)를 라이브로 독립 재실측해 **stated 전건 정확**. **단, 독립 교차바인딩 실측이 design 결함 카탈로그 누락 1건(053/054 siz↔mat 교차 no_match·돈크리티컬)을 적발** → 조건부 GO(보정 폐루프). 날조·산식 오류 0.

| 게이트 | 판정 | 핵심 근거 |
|--------|------|-----------|
| E1 공식 추출 | **CONDITIONAL** | 가격표 7블록·prc_typ·use_dims·단가행·바인딩 전건 verbatim·v03 미인용·날조0. **단 053/054 siz↔mat 교차바인딩 no_match 결함 카탈로그 누락** |
| E2 구성요소 분해 | PASS | 가격축 3축뿐(siz/mat/수량)·형상/칼선/재단=가격직교(option-axis≠price-axis)·공식당 comp 1개·시트경계 SOT 1 |
| E3 흡수 타당 | PASS | 신규 가격축0·naming(shape_info/THO/CUT/digital_price…) 유입0·형상 #17 옵션 distinct≠가격축 분리·후니 표현력 동형 |
| E4 엔진 건전성 | PASS | NON_QTY_DIMS 정확매칭·.01 unit×qty·.02 ÷min_qty(코드 검증)·.02 NULL min_qty 0행(ValueError 안전)·재바인딩 교정 search-before-mint(신규 mint0) |
| E5 세트 조합 | PASS | sets 0행·타투/팩=단일본체 묶음단위(부품 합산 아님)·이중계상 구조적 부재·세트레이어 불요 확정 |
| E6 골든 재현 | PASS | GC-STK1~8 라이브 verbatim 일치(허용오차0)·타투12,000/팩4,000 .02 재계산·B06 54배 왜곡 부재 입증 |
| E7 독립성 | PASS | B06 prc_typ·del_yn·교차바인딩 라이브 독립 재실측·골든 충실 재구현·053/054 누락 dodge-hunt 적발·self-approve 없음 |

## 라이브 confirm 핵심 (designer 주장 → 직접 재실측)

- **B06 팩 prc_typ 결판**: `COMP_STK_PACK` = **PRICE_TYPE.02**(직접 SELECT) → cartographer/designer 정확·benchmark "54배 왜곡" round-23 이전 stale. 팩 qty54 = 4000÷54×54 = 4,000(폭발 부재).
- **계산방식**: COMP_STK_PRINT siz_width 0행·siz_cd 2,694행 → 이산 siz_cd 단가형 확정(면적매트릭스 직교·off-grid ceiling 불요).
- **소재 7종 전개**: mat {153·084·155·156·242·162·163}(3-collapse stale 해소 확인).
- **G-STK-1**: MAT_000154(유포지) **del_yn=Y**·154/243/167 STK_PRINT 단가행 0행·055/057→154·056→243 바인딩 → no_match. 재바인딩(154→153·243→162) 정답(형제 058~061/052 정본 153·신규 mint0).
- **G-STK-2 돈크리티컬**: SIZ_172(A4)=4000(낱장)·SIZ_520(A4 반칼)=5000·052~054 SIZ_172 잔존·058~061 SIZ_520 적용 → 장당 1,000 과소청구. 재바인딩(이미 실재 siz).
- **G-STK-3**: SIZ_196(A6)·SIZ_058(100x140) 전 comp 0행(062 active 보강)·가격표 B01 부재 → binding-validity(추측 INSERT 금지).
- **16/16 바인딩·공식당 comp 1개·sets 0·t_dsc 0**: 동형결함 3종(×qty/silent/min_qty NULL) 구조적 부재·세트 레이어 불요 확정.

## ★검증 추가 발굴 (design 미카탈로그·E1 누락·보정 요구)

- **053/054 siz↔mat 교차바인딩 no_match**: 053(반칼투명·active)·054(홀로그램·active)의 mat162/163 단가행은 **반칼정사각 사이즈(059/060)에 적재**돼 있으나 상품은 **A5/A4/A6(170/172/196)에 바인딩**.
  - 053: SIZ_172만 매칭(낱장6행)·170/196 no_match.
  - 054: **170/172/196 전건 no_match**(mat163 단가행이 059/060/518/519에만) → 054 어느 바인딩 사이즈로도 가격 불가.
  - **G-STK-2 교정안(052/053/054 SIZ_172→SIZ_520)을 053/054에 그대로 적용 시 SIZ_520×mat162/163 단가행 부재로 여전히 no_match** → **052와 다른 교정 경로**(siz 170/172/196→059/060 재바인딩 or mat162/163 단가행 520/170 적재). 권위 가격표(B01 투명/홀로 사이즈)로 정답 판정. 054 active라 긴급.

## 보정 요구 (재게이트 조건)

**차단 결함(NO-GO) 0건. 보정 요구 1건(🔴 돈크리티컬·E1):**
- **보정-1**: 053/054 siz↔mat 교차바인딩 no_match를 design 결함 카탈로그(G-STK)에 명시 추가 + 052와 분리된 교정 경로 산출(권위 가격표 대조). 054 active 가격불가 → 긴급. designer 폐루프 + dbm-price-arbiter.

정정 권고 1(LOW·가격 무영향):
- **정정-1(LOW)**: GC-STK1 골든표 "기대 골든 5,900/6,000"을 "단가행 unit_price(가격표 셀)"로 명시(.01 최종가=×qty와 구분·GC-STK2/3 .02 최종가와 의미 다름·산식은 정확).

## 컨펌큐

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| CV-STK-053/054(검증·보정) | 053/054 교차바인딩 no_match·052와 다른 교정경로 | dbm-price-arbiter·designer | 🔴 돈크리티컬(054 active) |
| Q-STK-MAT1 | 055/057 mat153 재바인딩 시 SIZ_172×153=4000(B02 낱장) — 라이브 검증 완료(정합) | dbm-price-arbiter | 확인됨 |
| Q-STK-SIZ1 | A6/100x140 실판매 사이즈(바인딩 제거 vs 단가 출처)·062 active no_match | dbm-price-arbiter | 추측 금지 |
| Q-STK-064 | 064 소형반칼 실측 단가·굿즈 siz(036/043) 재사용 해소·활성화 전 | 실무·채번 | use_yn=N·긴급도 낮음 |
| Q-STK-DSC1 | 단가행 min_qty 36단 + t_dsc 이중할인 점검(현 t_dsc 0행) | dbmap round-1 | 할인 순서 |
| Q-STK-TAT1/PACK1 | 타투 base 2000(1~2장)·팩 수량 장/세트 UX | 실무 | 정상 경로 GO |
| CV-STK-G1(검증·LOW) | GC-STK1 골든=단가행값(최종가 ×qty 아님)·표기 정밀화 | designer | LOW·산식 정확 |

## 라우팅

- **보정-1(053/054 교차바인딩)** → designer 폐루프(카탈로그 보강·교정경로 분리) + dbm-price-arbiter(권위 가격표 대조·추측 금지). 🔴 돈크리티컬.
- **G-STK-1/2 재바인딩(154→153·243→162·SIZ_172→SIZ_520)** → 인간 승인 후 dbmap(dbm-axis-staged-load ②사이즈·④자재·dbm-load-execution). 멱등·백업·undo·신규 mint0.
- **G-STK-3/064(Q-STK-SIZ1·Q-STK-064)** → dbm-price-arbiter·실무(추측 적용 금지).
- **정정-1(LOW)·CV-STK-G1** → designer 폐루프(문서만·가격 무영향).
- **codex 2차(Phase 5.5·스티커)** → 오케스트레이터 reconcile(본 판정 독립·codex 비참조).
