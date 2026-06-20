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
