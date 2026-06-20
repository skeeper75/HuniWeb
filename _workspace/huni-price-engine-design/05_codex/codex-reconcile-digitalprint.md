# codex-reconcile-digitalprint.md — Phase 5.5 codex 독립 2차 교차검증 reconcile

> **hpe-codex-validator.** engine-designer 디지털인쇄 설계(03_design)에 대해 codex(gpt-5.5)가
> hpe-validator 판정을 **비노출**한 채 받은 독립 2nd opinion ↔ hpe-validator NO-GO 판정(04_validation) 대조.
> ★[HARD] codex 판정 = **가설**(라이브/권위 검증 전 사실 아님·환각 경계·자동 flip 금지·라이브 우선).
> codex 원시 출력: `codex-output-digitalprint.md`. 입력 프롬프트: `_codex-prompt-digitalprint.md`(validator verdict 미포함).

---

## codex 가용성

| 항목 | 값 |
|------|-----|
| 가용 | **AVAILABLE** (preflight: `AVAILABLE model=gpt-5.5`) |
| 모델 | gpt-5.5 (ChatGPT OAuth·종량과금 없음) |
| 샌드박스 | read-only (`--sandbox read-only --skip-git-repo-check`·DB/repo 쓰기 0) |
| 호출법 | preflight 백그라운드 행 없음 → `codex exec` foreground 직접 호출(timeout 미설치 우회·stdin 대신 인자 전달) |
| 독립성 | validator E1~E7·NO-GO·R-1~R-6 **프롬프트 미전송** — codex는 설계 산출물 6파일만 읽음(echo 방지 충족) |

codex는 라이브 DB를 직접 호출하지 않고 "사용자 제시 엔진 계약 + 설계 6파일"만으로 추론(스스로 명시: "라이브 DB는 호출하지 않았다"). 따라서 codex의 수치 계산은 **계약 기반 산술 추론**이며, 라이브 단가행 실측은 validator(Claude)가 보유 — 이 비대칭이 reconcile에서 누가 라이브 권위를 쥐는지를 규정.

---

## codex 독립 판정 요약 (Q1~Q6)

| Q | codex 자기판정 | 핵심 근거 |
|---|---------------|----------|
| Q1 설계 건전성 | **FAIL** | 구조 방향(variant별 PRF·orphan 재배선·신규 comp 최소)은 건전하나, 형압명함/봉투/유광코팅 결손 + S1/S2·20P/30P 판별차원 부재 + prc_typ 불일치 → "가격계산 가능하나 정확한 계산 실패" |
| Q2 단가형 ×qty | **FAIL** | GC-1 3500×100=350,000 / GC-6 9500×100=950,000 / GC-7 11000×2=22,000 / GC-8 5200×20=104,000 / GC-4 FOIL 24800×300=7,440,000(+SETUP 1,500,000=8,940,000). **명함 전 variant·포토카드BULK·엽서북·박 FOIL/SETUP까지 확산. D-10이 명함만 명시해 범위 과소평가** |
| Q3 인쇄면 S1/S2 합산 | **FAIL** | ERR_AMBIGUOUS 아님. **silent overcharge가 더 타당한 독립 판단**(GC-1 S1 350,000+S2 450,000=800,000). print_opt_cd가 푸는 건 모호성 표시가 아니라 판별차원 부재. 단 "use_dims에 실제 포함돼야" 효과 |
| Q4 엽서북 이중계상 | **FAIL / 부분만 맞음** | "내지+표지 별도합산 안 함"은 맞으나, **PCB S1_20P/S2_20P + 20P/30P 동시매칭 + ×qty**가 남음 → "이중계상 0" 불완전. 골든 11,000/5,200 그대로 재현 안 됨 |
| Q5 경쟁사 흡수 | **GO** | C-2/C-4 답습 아님. 신규 가격축/테이블 0·기존 constraints JSONLogic로 닫힘·과적합 낮음. 단 권위 엑셀에 없는 RP 제약 그대로 넣으면 답습(전제 준수 시 GO) |
| Q6 골든 재현 | **FAIL** | 고정가형 전반 불일치(×qty). 진원 = "골든값 verbatim이 틀림"이 아니라 **라이브 prc_typ/판별차원 부재가 골든 의미와 안 맞음**. GC-5(qty=1)·GC-10(결손)은 모른다 정직 표기 |
| **종합** | **FAIL — "그대로 적용하면 안 된다"** | 위험 3: ① 단가형 ×qty(10~300배) ② S1/S2·페이지수 판별차원 부재(silent) ③ 골든이 엔진 계약으로 재현 안 됨 |

---

## reconcile 매트릭스 (codex ↔ hpe-validator)

### ★ 핵심 3결함 (작업지시 명시 — 합의 여부가 reconcile의 심장)

| # | 결함 | hpe-validator (라이브 실측) | codex (계약 추론·미검증 가설) | 판정 |
|---|------|------------------------------|-------------------------------|------|
| **①** | **D-10 ×qty 과대청구 범위** | E6 FAIL·R-1: D-10을 "명함 8종"으로 한정한 게 과소 → **엽서북·포토카드BULK·박 SETUP 전 고정가형 횡단**. recompute로 350,000/45,000/8,940,000/950,000 실증 | Q2 FAIL: "명함만이 아니라 명함 전 variant·포토카드BULK·엽서북·오리지널박명함 FOIL/SETUP까지 퍼진다. **D-10은 명함만 명시해 범위를 과소평가**" + 동일 수치(350,000·950,000·22,000·8,940,000) | **합의 [고신뢰]** — 두 모델이 독립으로 **범위 과소** 동일 결론 + 수치 일치. 진단 강건 |
| **②** | **인쇄면 S1/S2 silent 이중합산** | E2 결함 V-DGP-1·R-2: 설계 "ERR_AMBIGUOUS"는 오진 → 실제는 **차원 부재로 S1+S2 silent 이중합산**(경고 없이 과청구). print_opt_cd=NULL이라 둘 다 통과 | Q3 FAIL: "ERR_AMBIGUOUS가 아니라 **조용히 둘 다 합산될 가능성이 높다**. silent overcharge가 더 타당한 독립 판단"(GC-1 800,000) | **합의 [고신뢰]** — ★독립성의 백미. validator verdict 비노출 상태에서 codex가 "ERR_AMBIGUOUS 오진 → silent 이중합산"을 **스스로** 동일 도출. echo 불가능한 합의 = 메커니즘 진단 매우 강건 |
| **③** | **엽서북 이중계상** | E5 FAIL·R-3: 설계 "이중계상 0" 거짓 → 엽서북도 ① 인쇄면 이중합산 ② prc_typ ×qty 두 결함. 명함과 동일 결함군 | Q4 FAIL/부분: "내지+표지 이중계상은 피했으나 **인쇄면/페이지 comp 동시합산 + ×qty 과청구 남음**. 골든 11,000/5,200 그대로 재현 안 됨" | **합의 [고신뢰·뉘앙스 일치]** — 둘 다 "BOM 의미의 이중계상은 0이나 **가격엔진 축(인쇄면·페이지·qty)에서 이중계상/과청구 발생**"으로 동일하게 분해. codex가 "부분만 맞음"으로 validator의 "거짓 판정 철회"보다 약간 관대하나 결론(FAIL) 동일 |

### 게이트 레벨 대조

| 게이트 | hpe-validator | codex 대응 Q | 정합 |
|--------|---------------|--------------|------|
| E1 공식 추출 충실성 | PASS | (Q1 일부) 인용·orphan 재배선 건전 인정 | **합의** — 추출/구조 골격은 양측 건전 인정 |
| E2 구성요소 분해 정합 | CONDITIONAL (V-DGP-1) | Q3 FAIL | **합의(결함)** — codex가 더 강하게 FAIL. 결함 본질 동일 |
| E3 흡수 타당성 | PASS | Q5 GO | **합의 [고신뢰]** — C-2/C-4 data-gap·신규축0·답습아님 동일 |
| E4 엔진 설계 건전성 | CONDITIONAL | Q1 FAIL | **부분 불일치(등급)** — 아래 D-1 참조 |
| E5 세트 조합 | **FAIL** | Q4 FAIL | **합의** |
| E6 골든 재현 | **FAIL** | Q6 FAIL | **합의** — 진원도 "라이브 결함이지 설계 골든값 오류 아님" 동일 |
| E7 독립성 | PASS | (해당없음·codex 자체 독립) | — |
| **종합** | **NO-GO** | **FAIL** | **★합의 [최고신뢰]** |

---

## 불일치 / 조사 라우팅

| ID | 항목 | 차이 | 라우팅 |
|----|------|------|--------|
| **D-1** | 설계 골격 등급(E4) | validator=CONDITIONAL("골격 건전, D-3 사유만 오기"), codex=Q1 FAIL("그대로 적용 불가"). **결론은 동일(보정 필요)이나 등급 표현이 다름** — codex는 결함 1개라도 있으면 전체 FAIL로 묶는 경향(게이트 분리 안 함). 실질 충돌 아님 | 조사 불요 — 표현 차이. validator의 게이트 분해(골격 PASS / D-3 사유 정정)가 더 정밀. codex FAIL이 "전체 적용 불가"라는 결론은 validator NO-GO와 동일 |
| **D-2** | D-3 print_opt_cd 충전의 정확한 효과 | 양측 모두 "충전이 이중합산을 막는다"로 합의하나, codex가 **추가 가드 제기**: "단순 컬럼값 충전으로 부족할 수 있다 — 매칭은 use_dims 기준이므로 print_opt_cd가 **실제 use_dims에 포함**돼야". validator R-5는 충전 타당성만 언급 | **조사 신호(보강)** — codex 가설이 맞다면 보정 명세에 "print_opt_cd를 단가행 컬럼 충전 + 해당 comp의 use_dims 배열에 print_opt_cd 추가" 둘 다 명시해야. → engine-designer 폐루프에서 use_dims 포함 여부 라이브 재확인. **미검증 가설**(라이브 use_dims 정의 실측 필요) |
| **D-3** | 박 SETUP 처리 | validator R-4가 별도 명시(use_dims=[]·min_qty=NULL·동판 1.5M·합가형min_qty=1 또는 정액comp). codex는 SETUP을 ×qty 합산(5000×300=1,500,000)으로만 계산·정액 처리 해법은 미제시 | 충돌 아님 — codex가 결함(SETUP ×qty)은 동일 적발, 해법은 validator R-4가 더 구체. 라우팅 = validator R-4 유지 |

**자동 flip 0** — codex가 라이브 실측과 모순되는 주장 없음. codex가 "모른다"고 정직 표기한 부분(GC-5 SET 동시합산 추가확인·GC-7 S2/30P 단가 미제공·GC-10 유광 결손 총액)은 validator 라이브 실측(recompute-log)이 이미 커버하거나 컨펌큐(CV-4·G-7) 처리 — 정보 비대칭일 뿐 충돌 아님.

---

## 종합: NO-GO가 codex로도 지지되는가?

**예 — 강하게 지지된다 (고신뢰 확정).**

1. **종합 판정 합의**: validator NO-GO ↔ codex "그대로 적용하면 안 된다·FAIL" — 두 독립 모델이 동일 결론. validator verdict 비노출(독립성 충족) 상태의 합의라 echo 아님.

2. **핵심 3결함 전건 합의 [고신뢰]**:
   - ① ×qty 범위 과소(D-10 명함한정) → 전 고정가형 횡단: **합의 + 수치 일치**(350,000·950,000·22,000·8,940,000).
   - ② 인쇄면 silent 이중합산(ERR_AMBIGUOUS 오진): **합의** — ★codex가 validator 결론을 모른 채 "silent overcharge가 더 타당"을 독립 도출. 가장 강한 교차검증 신호(echo 구조적 불가능).
   - ③ 엽서북 이중계상(BOM 0이나 가격축 이중합산/과청구): **합의(뉘앙스 일치)**.

3. **FAIL의 진원 공통 인식**: 양측 모두 "설계 골든값(가격표 verbatim)은 옳고, 라이브 prc_typ 단가형 오적재 + 판별차원(print_opt_cd·page) 부재가 진원"으로 동일 분해. 설계 자체보다 라이브 데이터/구조 결함 + 설계가 그 범위를 D-10 한 칸으로 과소처리한 것이 NO-GO 사유.

4. **흡수 PASS도 합의**: C-2/C-4 data-gap·답습 아님·신규축 0 — validator E3 PASS ↔ codex Q5 GO.

**불일치는 등급 표현(D-1)·해법 구체성(D-3)·보강 가드(D-2)뿐 — 결론 충돌 0.** D-2(use_dims 포함 여부)만 engine-designer 폐루프에서 라이브 재확인 권장(미검증 가설).

### 라우팅 (validator 라우팅과 정합)
- 돈크리티컬(① ×qty 범위·박 SETUP·prc_typ 교정방향) → `dbm-price-arbiter` + 사용자 컨펌(CV-1·CV-2·CV-4). 실 prc_typ 교정은 인간 승인 후 dbmap 트랙.
- 설계 보정(② 인쇄면 차원 통합·③ 엽서북 판정 철회·D-3 사유 + **D-2 use_dims 포함 보강**) → engine-designer 폐루프.
- divergence 해소 전까지 verdict = **NO-GO(고신뢰)**. codex 합의로 신뢰도 상승, 새 충돌로 인한 보류 없음.

## DB 미적재 [HARD]
codex read-only 샌드박스·라이브 읽기전용 SELECT(가용성 판정만)·DB 쓰기 0. 산출은 `05_codex/`에만. 실 교정은 인간 승인 후 dbmap 위임.
