# 게이트 판정 — 하드커버 링책자(PRD_000082) 셋트 동작화 적재본 (S1~S8 독립 재판정)

검증: hsp-set-gate · 2026-07-01 · 생성≠검증(designer 주장 비신뢰·직접 재실측) · 라이브 **읽기전용 SELECT만** + 롤백전용 DRY-RUN · COMMIT 0 · DB 미적재
대상: `06_load/hardcover-ring-082-load.sql`(27행·멱등·FK 위상순) · `06_load/hardcover-ring-082-load-spec.md` · `06_load/hardcover-ring-082-blocked-board.csv` · `03_design/hardcover-ring-082-authority.md`
엔진: `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_set_price:844 · derive_inner_sheets:820 · _evaluate_formula:643 · match_component:134 · _row_matches:94) — Django 미설치 → 순수 헬퍼 알고리즘 **직접 재현**(단가 verbatim 손계산)
전파 기준: 077 레더 하드커버 게이트(`gate-verdict-leather-hardcover-077.md`·CONDITIONAL GO)의 전파분 + 링 분기

---

## 0. 종합 판정 — ★CONDITIONAL GO (제본+내지 동작 경로 실 COMMIT 가능)

| 핵심 판정 | 결과 |
|---|---|
| **082가 견적 0원 → 정상 동작하는가** | ✅ **예** — 견적 0원(부모공식 0행) → PRICE≠0. 적재본 적용 후 base_total = **44,123원**(A5·page30·qty1·양면·백모조100·실재 손계산). |
| **PRICE≠0 도달(실재 계산값)** | ✅ **44,123원**(A5·pansu4) / **47,046원**(A4·pansu2). 제본 30,000 + 내지(인쇄+용지) 14,123/17,046. designer "≈39,100" 주장보다 실제 **더 높음**(designer 내지 ≈9,100은 양면 인쇄비 과소추정·저청구 방향 아님). |
| **S8 제본 오염(링/무선/일반트윈링 혼선)** | ✅ **오염 0** — 라이브 실측: COMP_BIND_HC_TWINRING 단가행은 **proc_cd=PROC_000024 단독**·다른 제본 comp(무선 PROC_000019·일반트윈링 PROC_000018/19/20/21·PUR PROC_000020·중철 PROC_000018)와 proc_cd **전혀 겹치지 않음**. 부모공식 PRF_HC_TWINRING_SET 비목 = COMP_BIND_HC_TWINRING **단 1개**(무선 COVERBIND·일반 TWINRING 미배선·DRY-RUN 확인). 링≠무선≠일반트윈링 격리 보장. |
| **실 COMMIT 가능한가** | ✅ **27행 적재본 COMMIT 가능** — DRY-RUN 제약위반 0·멱등 2회 delta 0·ROLLBACK 후 286 미존재·082 baseline 복귀 입증. |
| **BLOCKED(면지유료·×2)가 동작을 막는가** | ❌ **막지 않음** — 077 +3,900 패턴 동형. 표지/면지 ×2 인쇄·코팅 미반영 = 저청구 잔존하나 0원 아님(제본+내지로 PRICE≠0 즉시). 정직한 BLOCKED. |

→ **CONDITIONAL GO**: 27행 적재본은 "082를 동작시킨다"(견적 0원 해소)는 목표를 달성하며 안전 적재 가능. **다만 표지/면지 인쇄·코팅 ×2 비목 미반영 = 저청구가 잔존**(BLOCKED-COVER-MYUNJI-PRINT·BLOCKED-COVERMULT-X2·CONFIRM-MYUNJI-PAID·§18). 인간 승인 시 "082 제본+내지 동작화 GO + 표지/면지 ×2 저청구 인지" 조건부.

---

## 1. S1~S8 판정표 (직접 재실측 증거)

| 게이트 | 판정 | 재실측 증거(직접·라이브 SELECT/DRY-RUN/손계산) |
|---|---|---|
| **S1 권위 충실성** | ✅ PASS | 082 셋트 6행(표지083 min1/max1·내지286 page8~100/+2·면지084~087 택1·4종)이 booklet-l1 row37~41(내지 8/100/+2·표지=전용지·표지코팅 무광/유광·면지 4색·제본 하드커버트윈링)과 일치. COMP_BIND_HC_TWINRING 6밴드 **30000/20000/15000/10000/8000/7000 verbatim**(라이브 SELECT 일치·권위 §5.1·spec §5.1 정확 일치·날조 0). 페이지룰 8/100/+2 = 072/077(24/300)과 다름·082 권위 정합. |
| **S2 구성원 유형 정합** | ✅ PASS | 라이브 실측: 082=PRD_TYPE.**01**(셋트 완제품·적격) · 083/084/085/086/087=PRD_TYPE.**02**(반제품)·use_yn=Y·del_yn=N · 신규 286=load SQL이 PRD_TYPE.**02**로 mint(DRY-RUN 확인). 완제품/기성/디자인 혼입 0. admin.py:1082 인라인 필터 정합. |
| **S3 무결성** | ✅ PASS | DRY-RUN: 082 셋트 복합PK 유일·disp_seq=**1,2,3,4,5,6** 단조. 내지286 min8≤max100·incr2>0. FK 타겟 6건(083/286/084/085/086/087) 전부 적용 후 실재(286은 위상1 선적재). 286 차원 siz3/popt2/mat9/plate1 = 285 동형. MAX prd_cd=**PRD_000285** → 286 mint 충돌 0. FK: SIZ_000170/380/172/499·POPT_000001/002 전부 실재(고아 0). |
| **S4 가격 e2e [HARD]** | ⚠️ PASS(동작) / 저청구 BLOCKED | **PRICE≠0 달성**(A5=44,123·A4=47,046·아래 §S4 재현). 이중합산 0(set_eval=제본 COMP_BIND_HC_TWINRING만·내지=DIGITAL_S1+PAPER만·면지=0·frm_cd 분리). **표지/면지 ×2 인쇄·코팅 미반영 = 정직한 BLOCKED**(링 표지/면지 단가행 라이브 부재·저청구 잔존하나 0원 아님). |
| **S5 경쟁사 흡수 타당** | ✅ PASS | 단가·구성 전부 상품마스터(260610)·계산공식집·라이브 verbatim. naming/codes 외부유입 0. COMP_BIND_HC_TWINRING 밴드는 라이브 실재값(경쟁사 주입 아님). 면지 유료 BLOCKED는 권위 침묵이 아니라 권위(면지인쇄·코팅 ×2 명시) vs 라이브 동형(072 무료) 충돌을 CONFIRM으로 정직 보류(§아래 S5 보강). |
| **S6 적재 가능성 DRY-RUN** | ✅ PASS | `BEGIN; \i load.sql ×2; ROLLBACK;` 제약위반 **0**. 27행 적용(공식1·비목1·286마스터1·siz3·popt2·mat9·286공식1·082공식1·셋트6). 멱등 2회차: 전 INSERT **"INSERT 0 0"**(delta 0). ROLLBACK 후 286 count=0·082 셋트 5행(baseline)·082 공식 0행·PRF_HC_TWINRING_SET 미존재 = 라이브 쓰기 0. |
| **S7 생성≠검증 독립성** | ✅ PASS | 전 증거 직접 SELECT/DRY-RUN/손계산 재실측(082 부모공식 0행·286 미존재·MAX=285·COMP_BIND_HC_TWINRING use_dims·proc_cd 분기·내지 단가행 plt_siz_cd 환원·밴드 카운트 인쇄212/용지81). designer "≈9,100/39,100" 주장 비신뢰·정확입력 재계산(14,123/44,123)으로 정정. codex reconcile CN-4(페이지축 member vs 부모옵션)=본 게이트가 권위로 판정(내지286 member min8/max100/incr2로 해소·권위 정합). 미해결 0. |
| **S8 구성요소 경계 무오염 [HARD]** | ✅ PASS(가격) / 정리권고(boundary csv) | **★제본 오염 0 — 라이브 실측 결판**: COMP_BIND_HC_TWINRING 6밴드 전부 proc_cd=**PROC_000024 단독**. 무선 COMP_BIND_MUSEON=PROC_000019·일반트윈링 COMP_BIND_TWINRING=PROC_000018/19/20/21·PUR=PROC_000020·중철=PROC_000018 — **PROC_000024와 단 하나도 겹치지 않음**. use_dims에 proc_cd 포함 → match_component가 proc_cd로 분기 → 무선/일반트윈링 단가행 silent 매칭 불가. 부모공식 비목=COMP_BIND_HC_TWINRING 1개(DRY-RUN). 내지=DIGITAL_S1+PAPER만·표지/면지=0. **단 component-boundary.csv에 082 경계 미등록(068~071만)** → 큐레이터 갱신 권고(가격 무관·정합 정리). |

**단일 FAIL 규칙**: S4 표지/면지 ×2 저청구는 **082 적재본 데이터 결함 아님**(링 표지/면지 단가행이 라이브에 부재·단가행 미적재가 원인). 077 레더 +3,900 BLOCKED와 동형이며 동작(PRICE≠0)은 PASS → **NO-GO 아님·CONDITIONAL GO**(제본+내지 동작 GO + 표지/면지 ×2 BLOCKED).

---

## S4 가격 e2e 종단 재현 (독립 손계산 · 단가 verbatim · 돈 크리티컬)

### 골든 케이스 G1: A5(SIZ_000170)·page30·copies1·내지양면(POPT_000002)·백모조100(MAT_000072)·전용지표지무광·블랙면지·블랙링

라이브 verbatim 단가·함수(직접 SELECT):
- `fn_calc_pansu(SIZ_000499, SIZ_000170)` = **4** (A5 내지·라이브 실측) / `fn_calc_pansu(SIZ_000499, SIZ_000172)` = **2** (A4)
- COMP_BIND_HC_TWINRING [proc_cd=PROC_000024·min_qty1] = **30,000** (PRICE_TYPE 단가형)
- COMP_PRINT_DIGITAL_S1 [PROC_000004·plt SIZ_000499·POPT_000002 양면]: qty1=6000·qty4=3500·qty8=2100 (단가형·212밴드)
- COMP_PAPER [plt SIZ_000499·MAT_000072 백모조100] = 30.73/장 (단가형·81밴드)
- 082 discount_tables = 미관여(할인 0)

**[A] 구성원 내지286 → evaluate_price(286, qty=내지매수)**
```
호출자 qty = derive_inner_sheets(copies1, pages30, pansu4, sides2)
  = 1 × ⌈30/(4×2)⌉ = 1 × ⌈3.75⌉ = 4매
  seq1 COMP_PRINT_DIGITAL_S1(양면): 단가형 band@qty4 = 3,500 → 3,500 × 4 = 14,000
  seq2 COMP_PAPER(백모조100):       단가형 30.73       → 30.73 × 4 = 122.92
내지286 contribution = 14,122.92
```

**[A'] 구성원 표지083 → evaluate_price(083)** → 가격공식 0행(미바인딩·설계의도) → contribution = **0** (표지비는 부모/×2 BLOCKED가 흡수 예정)

**[A''] 면지084~087(택1) → 가격공식 0행 → contribution = 0** (현 무료·BLOCKED-CONFIRM·072 동형)

**[B] 셋트 부모 082 → evaluate_price(082, copies1) → PRF_HC_TWINRING_SET**
```
set_procs=[{proc_cd: PROC_000024}] → COMP_BIND_HC_TWINRING is_proc 분기(pricing.py:694)
use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"] · proc_cd=PROC_000024 매칭 · qty=copies1
단가형 band@min_qty1 = 30,000 → 30,000 × 1 = 30,000
set_eval contribution = 30,000
```

**[C] base_total = 30,000(부모 제본) + 14,122.92(내지) + 0(표지) + 0(면지) = 44,122.92**
**[D] 할인 0 → final_price = round_won(44,122.92) = 44,123원** ✅ **PRICE≠0**

### 골든 대조

| 값 | 출처 | 금액 |
|---|---|---|
| 실재계산(A5·page30·qty1·양면) | 본 게이트 독립 재현 | **44,123** |
| 실재계산(A4·page30·qty1·양면) | 본 게이트 독립 재현 | **47,046** |
| designer 주장(제본30,000+내지≈9,100) | spec §5(내지 매수·인쇄비 과소추정) | ≈39,100(부정확·기각) |

**designer 주장 정정**: spec은 내지 ≈9,100(8매 기준 일부)으로 추정했으나, 실제 양면 인쇄비는 내지매수×band(A5 4매×3,500=14,000)로 더 높다. designer 추정보다 **실제값이 높으므로**(저청구 방향 아님·과대청구 방향도 아님) PRICE≠0 핵심 목표는 안전 달성. 적재본의 공식·차원·단가행 환원은 정확(verbatim·이중합산0).

**이중합산 검사 = 0**: PRF_HC_TWINRING_SET(부모·제본 COMP_BIND_HC_TWINRING) · PRF_DGP_INNER(내지·인쇄+용지) · 면지0 — frm_cd 분리로 공식별 독립 매칭. 같은 비목 두 곳 가산 없음. ✅

---

## S8 돈 크리티컬 결판 — 링/무선/일반트윈링 제본 혼선 (라이브 실측)

### 제본 component proc_cd 격리 매트릭스 (라이브 SELECT·verbatim)

| 제본 comp | proc_cd | 밴드수 | 단가범위 | 용도 |
|---|---|---|---|---|
| **COMP_BIND_HC_TWINRING** | **PROC_000024** | 6 | 7,000~30,000 | ★082 하드커버 링(본건) |
| COMP_BIND_MUSEON | PROC_000019 | 8 | 500~3,000 | 069 무선책자 |
| COMP_BIND_TWINRING | PROC_000018/19/20/21 | 8 | 500~5,000 | 071 일반트윈링책자 |
| COMP_BIND_PUR | PROC_000020 | 8 | 1,500~5,000 | 070 PUR책자 |
| COMP_BIND_JUNGCHEOL | PROC_000018 | 8 | 500~3,000 | 068 중철책자 |
| COMP_HC_MUSEON_COVERBIND | (use_dims=["min_qty"]만) | 6 | — | 072/077 하드커버무선 |

★**결판**: COMP_BIND_HC_TWINRING의 단가행 proc_cd(**PROC_000024**)는 다른 5개 제본 comp의 어떤 proc_cd와도 겹치지 않는다(무선=19·일반트윈링=18/19/20/21·PUR=20·중철=18). 이들 제본 comp는 전부 use_dims에 `proc_cd`를 포함(`["proc_cd","min_qty","proc_grp:PROC_000017"]`)하므로, 엔진 `match_component`/`_row_matches`(pricing.py:94)가 selections의 proc_cd로 분기한다. 부모공식 PRF_HC_TWINRING_SET이 set_procs=[{proc_cd:PROC_000024}]를 받으면 **COMP_BIND_HC_TWINRING(PROC_000024 단가행)만 매칭**되고, 무선·일반트윈링 단가행은 proc_cd 불일치로 매칭 자체가 불가.

→ **077 COVERBIND(use_dims=["min_qty"]만·무차원 와일드카드)와 결정적 차이**: 082 링 제본은 proc_cd 차원이 명시되어 격리가 데이터 레벨에서 보장된다. 077처럼 silent 매칭/AMBIGUOUS 위험 없음. **S8 제본 오염 = 0(견고)**.

### 부모공식 비목 격리 (DRY-RUN 사후검증)
PRF_HC_TWINRING_SET formula_components = **COMP_BIND_HC_TWINRING 1행만**(addtn_yn=Y). 무선 COMP_HC_MUSEON_COVERBIND·일반 COMP_BIND_TWINRING(071) **미배선**(오염 카운트 0). designer S8 가드 주장 정확.

### silent skip 위험 (호출자 책임·데이터 무결)
단, set_procs에 PROC_000024를 넘기지 않으면(호출자 미전달) COMP_BIND_HC_TWINRING은 proc_cd 불일치로 no_match → 제본비 0(silent skip). 이는 **데이터 결함 아니라 시뮬레이터/price_views 호출자가 제본 proc를 전달해야 하는 계약**(C-TRACK·전 책자 공통). 데이터(부모공식+비목+단가행)는 정확.

---

## S5 보강 — 면지 유료 BLOCKED 정당성

권위 하드커버링 공식(calc-formula L81~89)은 면지인쇄비(5)+면지코팅비(6)를 ×2로 명시(072/077 무선엔 없던 비목). 그러나 라이브 072 면지는 무료(동형). 적재본은 면지084~087을 **현 무료(가격공식 0행)로 보존**하고 유료 비목을 **CONFIRM-MYUNJI-PAID로 BLOCKED**. 이는:
- 면지를 무료로 둔 게 **저청구**(권위 면지 비목 ×2 미반영)이지만 **0원 아님**(제본30,000+내지14,123로 PRICE≠0).
- 077 레더가 +3,900을 BLOCKED 별도 트랙으로 두고 전용지 골든으로 PRICE≠0 먼저 달성한 패턴과 **동형**.
- 권위 vs 라이브 충돌(유료 명시 vs 무료 동형)을 자동 주입하지 않고 실무진/082 라이브 ASP 역산으로 정직 보류 → **정직한 BLOCKED 정당**.

---

## 실 COMMIT 가능분 vs BLOCKED분

### ✅ COMMIT 가능(load-executor 적재 큐 · 인간 승인 후)
`06_load/hardcover-ring-082-load.sql` 27행 전체 — 082 동작화(제본+내지 경로):
- 링 부모공식 PRF_HC_TWINRING_SET mint + 비목 COMP_BIND_HC_TWINRING 배선 + 내지 PRD_000286 mint(.02) + 차원 15행(siz3·popt2·mat9·plate1) + 공식 2바인딩(082→PRF_HC_TWINRING_SET·286→PRF_DGP_INNER) + 셋트 6행 보정.
- DRY-RUN 입증: 제약위반0·멱등 delta0·롤백복귀. **실 COMMIT 안전**(load-executor 단일 트랜잭션 래핑·COMMIT 전 082 baseline backup 권장).
- 효과: 견적 0원 → 44,123원(A5·PRICE≠0). 목표 해소.

### ⛔ BLOCKED(별도 트랙 · 인간 승인 · 본 SQL 밖)
| ID | 트랙 | 사안 | 라우팅 | blocks_activation |
|---|---|---|---|---|
| BLOCKED-COVER-MYUNJI-PRINT | §18/price | 표지인쇄·표지코팅·면지인쇄·면지코팅 비목(권위 (3)~(6)·전부 ×2). 링 표지/면지 단가행 라이브 부재 | §18 설계+082 라이브 ASP 골든 역산+인간 승인 | N(저청구·0원 아님) |
| BLOCKED-COVERMULT-X2 | §18/engine | 표지·면지 ×2(앞뒤 물리 2장·링=책등無). 엔진 ×2 곱셈 미지원. 권고=단가행 2매분 내재 | §18 설계(단가행 ×2) 또는 개발팀(엔진 C트랙) | N(077 +3,900 동형) |
| CONFIRM-MYUNJI-PAID | authority | 082 면지=유료(권위 명시) vs 072 무료(라이브 동형) 충돌·인쇄면지087 추가단가 | domain-researcher/실무진·082 라이브 ASP 역산 | N(현 무료 보존·동작 진행) |
| BLOCKED-MAT-REWIRE | dbmap/basecode | 082 부모 좀비 자재 link 점검(072/077 동형 오염 가능)·표지083 자재=전용지 배선·면지 정자재 | dbmap·link만(마스터 삭제금지)·견적 미관여·인간 승인 | N(견적 미관여) |
| C-TRACK-ENGINE | engine | COMP_BIND_HC_TWINRING ×copies(권당)·책등 by 페이지·DBLPANSU 내지 이중÷pansu·cover_mult ×2·★set_procs proc_cd 호출자 전달 계약(silent skip 가드) | 개발팀(webadmin·072 동형) | N(입력값 우회) |
| BOUNDARY-CSV-082 | curation | component-boundary.csv에 082(하드커버 링책자) 경계 미등록(068~071만). 가격 무관·정합 정리 | hsp-authority-curator 큐레이터 갱신 | N(가격 무관) |

---

## 인간 승인 큐 (요약)

1. **[승인 요청] 082 동작화 27행 COMMIT** — 견적 0원 해소(→44,123원 PRICE≠0). DRY-RUN GO·멱등·롤백 입증·제본 오염 0(proc_cd 격리 견고). **표지/면지 ×2 인쇄·코팅 미반영 = 저청구가 잔존함을 인지하고 승인**할 것인가. (권장: GO — 0원보다 저청구가 낫고, 표지/면지 ×2·면지유료는 단가행 부재·엔진 제약상 별도 §18 트랙 필수)
2. **[후속·미승인 보류]** BLOCKED-COVER-MYUNJI-PRINT(표지/면지 ×2 정확값·§18)·CONFIRM-MYUNJI-PAID(면지 유료 결판)·BLOCKED-MAT-REWIRE(좀비 link)·C-TRACK(엔진·set_procs 계약)·BOUNDARY-CSV-082(큐레이터 갱신).
3. **[동형 전파 대기]** 088 레더 링바인더 = 082와 동일 구조의 미동작 셋트(표지=레더·면지 인쇄면지 포함) → 082 패턴 동형 전파 가능(077:082 = 072:088 매트릭스).

---

## 안전/위상
- 라이브 **읽기전용 SELECT + 롤백전용 DRY-RUN만**(쓰기/COMMIT 0)·DB 미적재(게이트는 COMMIT 안 함·load-executor 위임).
- 권위 = 상품마스터(260610) booklet-l1 row37~41·계산공식집 하드커버링(L81~89) 절대. COMP_BIND_HC_TWINRING DB 밴드·082/071 라이브 ASP = 보강 오라클(차이=조사신호·자동주입 금지).
- 비밀값 비노출(.env.local RAILWAY_DB_* 키 이름만).
- 생성≠검증: designer "≈9,100/39,100" 비신뢰·정확입력 재계산(14,123/44,123)으로 정정. codex CN-4 본 게이트가 권위 판정(미해결 0).
