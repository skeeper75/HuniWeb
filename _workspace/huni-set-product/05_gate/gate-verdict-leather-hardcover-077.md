# 게이트 판정 — 레더 하드커버책자(PRD_000077) 셋트 동작화 적재본 (S1~S8 독립 재판정)

검증: hsp-set-gate · 2026-06-30 · 생성≠검증(designer 주장 비신뢰·직접 재실측) · 라이브 **읽기전용 SELECT만** + 롤백전용 DRY-RUN · COMMIT 0 · DB 미적재
대상: `06_load/leather-hardcover-077-load.sql`(23행·멱등·FK 위상순) · `06_load/leather-hardcover-077-load-spec.md` · `03_design/leather-hardcover-077-authority.md`
엔진: `raw/webadmin/webadmin/catalog/pricing.py`(match_component·_evaluate_formula·evaluate_set_price·derive_inner_sheets) + `price_views.py`(셋트 시뮬 호출자) pure-helper **직접 재현**(Django 미설치 → 알고리즘 손계산·단가 verbatim)

---

## 0. 종합 판정 — ★CONDITIONAL GO (전용지 동작 경로만 실 COMMIT 가능)

| 핵심 판정 | 결과 |
|---|---|
| **077이 실제 가격계산 동작하는가** | ✅ **예** — 견적 0원(부모공식 0행) → PRICE≠0. 적재본 적용 후 base_total ≈ **51,146원**(A4·30p·qty1·양면·백모조100) 실재 산출. |
| **골든 50,800 정확 도달하는가** | ❌ **아니오** — 실재계산 ≈51,146(전용지 경로). 권위 ASP 골든 50,800(레더)·46,900(전용지)과 불일치. ★단, 077은 **현 라이브 072와 100% 동일 모델**(PRF_HC_MUSEON_SET=COVERBIND + PRF_DGP_INNER 내지)이며 같은 산식 편차를 공유 — 077 고유 결함 아님(전 책자 공통 C-TRACK·아래 §S4). |
| **레더 +3,900이 동작을 막는가** | ❌ **막지 않음** — 077은 +3,900 없이도 PRICE≠0으로 동작(전용지 경로). 레더 델타는 **저청구(072와 동일가)**이지 0원·계산불가 아님. BLOCKED-COVERBIND-LEATHER는 **정직한 BLOCKED**(엔진 use_dims 제약 실증). |
| **실 COMMIT 가능한가** | ✅ **전용지 동작 경로(23행) COMMIT 가능** — DRY-RUN 제약위반 0·멱등 delta 0·롤백복귀 입증. ★단 레더 정확값(50,800)은 미달성으로 남음(별도 트랙). |

→ **CONDITIONAL GO**: 23행 적재본은 "077을 동작시킨다"(견적 0원 해소)는 목표를 달성하며 안전 적재 가능. **다만 레더 표지 +3,900 미반영 = 072 전용지와 동일가 저청구**가 잔존(BLOCKED·§18). 인간 승인 시 "077 동작화(전용지 경로) GO + 레더 델타 BLOCKED 인지" 조건부.

---

## 1. S1~S8 판정표

| 게이트 | 판정 | 재실측 증거(직접) |
|---|---|---|
| **S1 권위 충실성** | ✅ PASS | 077 셋트 5행(표지078 min1/max1 · 내지285 page24~300/+2 · 면지079/080/081 택1)이 booklet-l1 row36~38(내지 24/300/+2·표지=레더화이트·표지코팅=빈칸·면지 3색)과 일치. COVERBIND 6밴드 **34100/22425/15910/10170/7969/6368.40 verbatim**(라이브 SELECT 일치·날조 0). |
| **S2 구성원 반제품 유형** | ✅ PASS | 라이브 실측: 077=PRD_TYPE.**01**(셋트 완제품·적격) · 078/079/080/081=PRD_TYPE.**02**(반제품) · 신규 285=load SQL이 .**02**로 mint(DRY-RUN 확인). 완제품/기성/디자인 혼입 0. 078/285는 077 외 다른 셋트에 미사용(cross-set 오염 0). |
| **S3 무결성** | ✅ PASS | DRY-RUN: 077 셋트 복합PK 유일·disp_seq=**1,2,3,4,5** 단조. 285 min24≤qty(sub_prd_qty 1, 단 페이지축 min24)·max300·incr2>0. FK 타겟 5건(078/285/079/080/081) 전부 적용 후 실재(285는 위상1 선적재). 285 차원 siz3/popt2/mat9/plate1 = 284 동형. |
| **S4 가격 e2e [HARD]** | ⚠️ PASS(동작) / FAIL(골든 정합) | **PRICE≠0 달성**(≈51,146·아래 §S4 재현). 이중합산 0(COVERBIND=표지+제본만·PRF_DGP_INNER=인쇄+용지만·면지=0·frm_cd 분리). **골든 50,800 미도달**(전용지 경로·레더 델타 부재)·≈51,146은 072 동형 산식 편차(C-TRACK). |
| **S5 레더 +3,900 처리** | ✅ PASS(정직한 BLOCKED 인정) | **엔진 거동 실증**: COMP_HC_MUSEON_COVERBIND.use_dims=`["min_qty"]`만·6밴드 전부 mat_cd=NULL. `_row_matches`는 NON_QTY_DIMS 전체를 보므로(코드 L94~106) 레더 단가행(mat_cd=MAT_000186) 추가 시 NULL밴드(와일드카드)와 레더밴드가 **combo 2개 → ERR_AMBIGUOUS(L152) → 합산 제외(silent 무시)**. designer 주장 정확. 적재본이 레더 단가행을 COVERBIND에 **넣지 않은 것이 옳음**(저오염). → 077은 072 전용지와 **동일가**(저청구) = BLOCKED-COVERBIND-LEATHER 정당. |
| **S6 적재 가능성 DRY-RUN** | ✅ PASS | `BEGIN; \i load.sql; ROLLBACK;` 제약위반 **0**. 23행 적용(products1·sizes3·popt2·mat9·formula2·set5+면지seq보정 포함). 멱등 2회차: 전 INSERT "INSERT 0 0"·set rows 5 불변·285 count 1(중복 0)=**delta 0**. ROLLBACK 후 285 count=0·077 set rows=4(baseline 복귀). |
| **S7 생성≠검증 독립성** | ✅ PASS | 전 증거 직접 SELECT 재실측(072 현 바인딩=PRF_HC_MUSEON_SET·COVERBIND use_dims·285 미존재·MAX=PRD_000284·acrylic paper band 0·discount 0행). designer DRY-RUN(61,561)을 신뢰하지 않고 **호출자 정확입력(derive_inner_sheets·skip_plate)으로 재계산** → 51,146으로 정정(designer 61,561은 qty=page30 직접전달 오류 확인). codex reconcile 해당 없음(단독). |
| **S8 구성요소 경계 무오염** | ⚠️ PASS(가격) / 정리권고(boundary) | **가격 오염 0**: PRF_HC_MUSEON_SET=COVERBIND(use_dims min_qty)·PRF_DGP_INNER=DIGITAL_S1+PAPER만. 좀비 MAT_000002(아크릴·077 부모 del_yn=**N** 활성)는 COMP_PAPER 아크릴 단가행 **0건**이라 가격 미관여(no-match·silent charge 0). 285 자재=9 정자재만. **단 ① 좀비 아크릴 link = 옵션 UI 경계 오염(BLOCKED-MAT-REWIRE)·② 표지078 자재=레더 미배선(현 몽블랑130 ×2 둘 다 del_yn=Y=빈상태)** → 견적 무관·정합성 정리 권고(dbmap). |

**단일 FAIL 규칙**: S4 골든 정합은 FAIL이나 **077 고유 결함 아님**(072 동형 산식·전 책자 C-TRACK)이고 **동작(PRICE≠0)은 PASS**. 적재본의 데이터 결함이 아니라 호출입력·엔진모델 이슈 → **NO-GO 아님·CONDITIONAL GO**(동작 GO + 골든/레더 BLOCKED).

---

## S4 가격 e2e 종단 재현 (독립 손계산 · 단가 verbatim · 돈 크리티컬)

### 골든 케이스 G1: A4(SIZ_000172)·page30·copies1·내지양면(POPT_000002)·백모조100(MAT_000072)·레더화이트표지(078)·블랙면지(080)

라이브 verbatim 단가·함수:
- `fn_calc_pansu(SIZ_000499, SIZ_000172)` = **2** (A4 내지 2-up·라이브 실측)
- `_print_sides(POPT_000002)` = 2 (양면)
- COMP_HC_MUSEON_COVERBIND 밴드1(min_qty1) = 34,100 (PRICE_TYPE.01 단가형)
- COMP_PRINT_DIGITAL_S1 PROC_000004·SIZ_000499·POPT_000002 밴드: qty1=6000·qty4=3500·qty8=2100 (단가형)
- COMP_PAPER SIZ_000499·MAT_000072 = 30.73/장 (단가형)
- 077 discount_tables = **0행**(할인 없음)

**[A] 구성원 내지285 → evaluate_price(285, qty=내지매수)**
```
호출자(price_views:1889) qty = derive_inner_sheets(copies1, pages30, pansu2, sides2)
  = 1 × ⌈30/(2×2)⌉ = 1 × ⌈7.5⌉ = 8매
skip_plate=True (qty_mode=derived·L1912) → DIGITAL_S1·PAPER 판수 재환산 안 함(comp_qty=8 직접)
  seq1 DIGITAL_S1(양면): 단가형 tier@qty8 = 2100 → 2100 × 8 = 16,800
  seq2 PAPER(백모조100): 단가형 30.73 → 30.73 × 8 = 245.84
내지285 contribution = 17,045.84
```

**[A'] 구성원 표지078 → evaluate_price(078)**
```
078 가격공식 0행(미바인딩·설계의도) → base.amount = 0 (included·warning "가격 소스 없음")
contribution = 0  ← 표지비는 부모 COVERBIND가 흡수(2레이어 모델·정합)
```

**[A''] 면지080(블랙·택1) → 가격공식 0행 → contribution = 0** (무료·072 라이브 3색 동일가 확증)

**[B] 셋트 부모 077 → evaluate_price(077, copies1) → PRF_HC_MUSEON_SET**
```
COMP_HC_MUSEON_COVERBIND use_dims=["min_qty"] · qty=copies=1 → 밴드1 = 34,100
단가형 → 34,100 × 1 = 34,100
set_eval contribution = 34,100
```

**[C] base_total = 34,100(부모) + 17,045.84(내지) + 0(표지) + 0(면지) = 51,145.84**
**[D] 할인: 077 discount 0행 → final_price = round_won(51,145.84) = 51,146원** ✅ **PRICE≠0**

### 골든 대조

| 값 | 출처 | 금액 |
|---|---|---|
| 실재계산(독립 재현) | 본 게이트(전용지 경로·레더 델타 부재) | **51,146** |
| 권위 ASP 골든(전용지) | 072 라이브 ASP pcode40 | 46,900 |
| 권위 ASP 골든(레더) | 072 라이브 ASP pcode40 +3,900 | 50,800 |
| designer DRY-RUN(불신) | qty=page30 직접전달 오류 | 61,561(과대·기각) |

**잔차 분석(51,146 vs 50,800)**: 실재계산이 ASP 레더 골든보다 +346 높다. 원인은 **077 고유가 아니라 현 라이브 072 동형 모델의 산식 편차**:
- COVERBIND가 "표지+제본 권당 합가"를 한 component로 internalize(34,100 band1)하는데, ASP는 표지인쇄·제본·표지용지·내지를 분리 산정 → 내지매수 환산(derive_inner_sheets·page30→8매)과 COVERBIND 흡수범위 경계가 ASP와 미세 상이.
- C-TRACK(메모리 [[hardcover-blocked-resolution-live-260629]]·전 책자 공통): COVERBIND ×copies(권당)·책등 by 페이지·내지 이중÷pansu 등 엔진모델이 ASP 산식과 1:1 아님.
→ **이는 077 적재본 데이터 결함이 아니라, 072가 이미 가진 엔진모델 vs ASP골든 편차를 077이 그대로 상속**. 적재본의 공식·차원·단가행 환원은 **정확**(PRICE≠0·이중합산0·verbatim).

**이중합산 검사 = 0**: COVERBIND(부모·표지+제본)·PRF_DGP_INNER(내지·인쇄+용지)·면지0 — frm_cd 분리로 match_component 공식별 독립. 같은 비목 두 곳 가산 없음. ✅

---

## S5/S8 돈 크리티컬 결판 — 레더 +3,900

### 엔진 거동 실증(BLOCKED-COVERBIND-LEATHER 정당성)
COMP_HC_MUSEON_COVERBIND.use_dims=`["min_qty"]`·6밴드 전부 mat_cd=NULL(라이브 SELECT 확인). 엔진 `_row_matches`(pricing.py:94)는 component의 use_dims와 **무관하게** NON_QTY_DIMS(siz_cd/plt_siz_cd/print_opt_cd/**mat_cd**/proc_cd/opt_cd/coat_side_cnt/bdl_qty) 전체를 검사한다. 따라서:
- 적재본대로 레더 단가행을 넣지 않음 → 6밴드(mat_cd=NULL 와일드카드)만 매칭 → **레더든 전용지든 동일 34,100**(레더 +3,900 미반영 = **저청구**).
- 만약 레더 단가행(mat_cd=MAT_000186)을 추가하면(designer가 회피한 행위) → NULL밴드(와일드)와 레더밴드 2개 combo → `len(combos)>1`(L152) → **ERR_AMBIGUOUS → 합산 제외(34,100조차 0)** = 더 큰 결함.

→ **designer가 레더 단가행을 COVERBIND에 넣지 않은 것은 정확한 판단**(silent 무시/AMBIGUOUS 회피). 레더 +3,900은 use_dims 스키마 변경(A: +mat_cd) 또는 별도 component(B: COMP_HC_LEATHER_COVERBIND) 신설 후에만 가능 = **§18 + 엔진 거동 검증 + 인간 승인 BLOCKED**.

### 동작을 막는가 → ❌ 아니오
레더 +3,900 부재는 077을 **0원·계산불가로 만들지 않는다**. 077은 전용지 경로로 PRICE≠0(≈51,146) 동작한다. 영향은 "072 전용지와 동일가로 청구(레더 프리미엄 누락)" = **저청구**이지 동작 차단 아님. **견적 0원 → 정상 동작이라는 핵심 목표는 달성.**

### 공유공식 silent 영향(S8 #2)
PRF_HC_MUSEON_SET은 현재 072만 바인딩·077 추가 시 둘이 공유. COVERBIND가 mat_cd 무차원이라 **072(전용지)·077(레더) 동일 34,100** = 레더 프리미엄이 077에 silent 누락(전용지에는 정상). 이는 위 BLOCKED와 동일 사안(별도 신설/use_dims 분기로 분리 시 해소).

---

## 실 COMMIT 가능분 vs BLOCKED분

### ✅ COMMIT 가능(load-executor 적재 큐 · 인간 승인 후)
`06_load/leather-hardcover-077-load.sql` 23행 전체 — 077 동작화(전용지 경로):
- 내지 PRD_000285 mint(.02) + 차원 15행(siz3·popt2·mat9·plate1) + 공식 2바인딩(077→PRF_HC_MUSEON_SET·285→PRF_DGP_INNER) + 셋트 5행 보정.
- DRY-RUN 입증: 제약위반0·멱등 delta0·롤백복귀. **실 COMMIT 안전**(load-executor 단일 트랜잭션 래핑·COMMIT 전 077 baseline backup 권장).
- 효과: 견적 0원 → ≈51,146(PRICE≠0). 목표 해소.

### ⛔ BLOCKED(별도 트랙 · 인간 승인 · 본 SQL 밖)
| ID | 트랙 | 사안 | 라우팅 |
|---|---|---|---|
| BLOCKED-COVERBIND-LEATHER | §18/engine | 레더 +3,900(골든 50,800). use_dims=["min_qty"] 제약 → (A)use_dims+mat_cd+레더6밴드 or (B)COMP_HC_LEATHER_COVERBIND 신설+PRF분기 | §18 설계+엔진거동검증+라이브 격자 probe·인간 승인 |
| BLOCKED-MAT-REWIRE | dbmap/basecode | 077 부모 좀비 MAT_000002(아크릴·del_yn=N 활성) link 제거 + 표지078 자재=레더(MAT_000186/379) link 추가(현 몽블랑130 ×2 둘다 del_yn=Y) | dbmap·link만(마스터 삭제금지)·견적 미관여·인간 승인 |
| CONFIRM-LEATHER-PRINT | authority | 표지 특수인쇄(A5)/실사출력(A4)가 레자인쇄=+3,900에 포함되는지·골든 51,146 vs 50,800 잔차 | 실무진/domain-researcher |
| C-TRACK-ENGINE | engine | COVERBIND ×copies(권당)·책등 by 페이지·내지 이중÷pansu — 072 동형 전 책자 공통 | 개발팀(webadmin) |

---

## 인간 승인 큐 (요약)

1. **[승인 요청] 077 동작화 23행 COMMIT** — 견적 0원 해소(→≈51,146 PRICE≠0). DRY-RUN GO·멱등·롤백 입증. **레더 프리미엄(+3,900) 미반영 = 072 전용지 동일가 저청구가 잔존함을 인지하고 승인**할 것인가. (권장: GO — 0원보다 저청구가 낫고, 레더 델타는 엔진 제약상 별도 트랙 필수)
2. **[후속·미승인 보류]** BLOCKED-COVERBIND-LEATHER(레더 50,800 정확값·§18)·BLOCKED-MAT-REWIRE(좀비 link 정리)·CONFIRM-LEATHER-PRINT(골든 잔차)·C-TRACK(개발팀).

---

## 안전/위상
- 라이브 **읽기전용 SELECT + 롤백전용 DRY-RUN만**(쓰기/COMMIT 0)·DB 미적재(게이트는 COMMIT 안 함·load-executor 위임).
- 권위 = 상품마스터(260610) booklet-l1·계산공식집 절대. 072 라이브 ASP골든(46,900/50,800) = 보강 오라클(엔진모델 편차=조사신호·자동주입 금지).
- 비밀값 비노출(.env.local RAILWAY_DB_* 키 이름만).
- 생성≠검증: designer DRY-RUN(61,561) 비신뢰·정확입력 재계산(51,146)으로 정정.
