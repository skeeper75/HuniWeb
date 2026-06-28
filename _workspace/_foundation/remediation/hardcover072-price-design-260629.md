# 하드커버책자(PRD_000072) 세트 가격 종단 설계 — 표지+세트공식 (2026-06-29)

생성: hsp-set-designer · 권위[HARD]=상품마스터(260610)·인쇄상품 가격표(260527) 절대 ·
라이브 ASP 역산=보강 오라클(값 부재분만·과신 금지) · **DB 미적재**(설계+멱등 DRY-RUN SQL까지·
실 COMMIT은 게이트 GO+인간 승인 후). 라이브 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만 수행.

> ★출처 검증(2026-06-29·사용자 질의 "표지+제본이 어떤 상품인가"): 역산 출처 라이브 **pcode=40
> = "하드커버무선"**(홈 > 책자,캘린더) = 하드커버책자072 본인 확정. ASP가 가격을 `price_01`(내지)
> /`price_02`(표지+제본) 분해 노출하며, **"표지+제본" = 전용지 표지(구성원 PRD_000073) + 무선제본
> (COMP_BIND_HC_MUSEON)** 묶음. 즉 본 설계의 "표지+제본"은 072의 표지 구성원+제본공정이다.
> ★내지(PRD_000284)는 별도 BLOCKED — 포토북 내지와 동일하게 페이지 기반 가격(디지털인쇄 §18) 필요.
>
> ★스코프: 이 문서는 **표지(전용지) 단가 comp + 세트 합산 공식 + 부모 바인딩**의 가격 종단 설계다.
> 셋트 구조(member·내지 PRD_000284 신설·개수규칙)는 선행 설계
> `huni-set-product/03_design/hardcover-book-design.md`에서 이미 종결(라이브 COMMIT됨). 본 작업은
> 그 설계가 BLOCKED로 남긴 **가격(표지 단가·세트공식)**을 라이브 표지 역산(probe csv)으로 해소한다.

---

## 0. 결론 — 무엇이 COMMIT 준비됐고 무엇이 아직 BLOCKED인가

| 빌딩블록 | 상태 | 처리 |
|---|---|---|
| **제본비** COMP_BIND_HC_MUSEON (6밴드) | ✅ 라이브 적재 verbatim | 재사용(세트공식에 배선만) |
| **표지 전용지 단가** COMP_COVER_HC_PAPER (6밴드) | 🟢 **설계 확정**(라이브 역산 verbatim) | **신규 mint → 이 문서가 DRY-RUN까지** |
| **세트 합산 공식** PRF_BIND_HC_MUSEON (제본+표지) | 🟢 **설계 확정** | **신규 mint → DRY-RUN까지** |
| **부모 072 바인딩** PRD_000072→PRF_BIND_HC_MUSEON | 🟢 **설계 확정** | **신규 mint → DRY-RUN까지** |
| **면지** (074/075/076) | ✅ 무료(라이브 결정론) | 비목 제외·이중합산 0 |
| **내지 종이/인쇄비** (PRD_000284) | 🔴 **여전히 BLOCKED** | §18 디지털인쇄 설계+차원 적재(dbmap)·이 문서 범위 밖 |

→ **이 설계가 COMMIT되면**: 표지+제본은 PRICED(세트공식 단독). 내지는 구성원 공식 부재라 0 기여
(전체가는 표지+제본만 산출되어 부분 PRICED). **내지까지 PRICED 되려면 별도 트랙**(아래 §6 BLOCKED).

---

## 1. 표지 전용지 단가 역산 요약 (probe csv 인용 · 보강 오라클)

출처: `_foundation/remediation/hc072-cover-probe-260629.csv` (부모 세션이 라이브 pcode=40
gstack browse로 확정). 라이브 ASP가 가격을 분해 노출: `price_01`=내지 · `price_02`=표지+제본 · `total_num`=공급가.

### 1.1 표지(전용지) = p02_unit − 제본_unit (DB COMP_BIND_HC_MUSEON)

| min_qty | p02 (표지+제본·per-book) | 제본 (DB verbatim) | **표지 전용지 (역산)** |
|---|---|---|---|
| 1 | 34,100 | 30,000 | **4,100** |
| 4 | 22,425 | 20,000 | **2,425** |
| 10 | 15,910 | 14,000 | **1,910** |
| 50 | 10,170 | 9,000 | **1,170** |
| 100 | 7,969 | 7,000 | **969** |
| 1000 | 6,368.4 | 6,000 | **368.4** |

### 1.2 신뢰도 — 고신뢰 (4 근거)
1. **사이즈 독립**: p02(표지+제본)가 A5=B5=A4 전부 동일·전 밴드(probe 검증). 내지(p01)만 사이즈×페이지 의존.
2. **밴드룩업 확정**(보간 아님): qty interior(3≈4·9≈10·49≈50·99≈100) per-book가 밴드floor와 일치.
3. **제본 분리값 = DB verbatim**: 빼는 항(제본)이 라이브 DB COMP_BIND_HC_MUSEON와 정확 일치(8324~8329).
4. **권위 엑셀이 명시 위임**: 가격표 "제본" 시트 메모 "표지비용 따로 계산"(E14) = 권위가 표지를 가격표에
   두지 않음을 명문화 → 라이브 역산이 정당한 보강 출처(날조 아님).

### 1.3 과신 가드 [HARD]
- 역산값은 **리뉴얼 단가 설계의 증거**일 뿐, 권위 엑셀에 표지 명시절가가 **없으므로** 실무진이 라이브 값
  유지/갱신을 최종 확정해야 한다(차이 발생 시 조사신호). → COMMIT 전 **CONFIRM-COVER-PRICE**(인간 큐).
- 표지 종류 분기: 맞춤표지(전용지·MAT_000246)=베이스 / 레자인쇄표지=+3,900/book(qty1). **072 표지=전용지 1종**
  → 이번 설계는 전용지만. 레자(077 등)는 별 단가행 확장(향후·이번 스코프 밖).
- 코팅 무광=유광(가산 0·probe 실측) → 코팅 비목 없음(전용지 표지가는 라미 포함가).

---

## 2. 세트 가격 모델 — 표지 배선 결정 (이중합산 0)

### 2.1 evaluate_set_price 계약 (pricing.py:844)
```
evaluate_set_price(072, members, set_selections, copies) =
    Σ 구성원 evaluate_price(sub_prd_cd, selections, qty)      ← 내지(284)·표지(073)·면지
  + 셋트공식 evaluate_price(072, set_selections, copies)      ← qty=copies(부수)
  + 할인(합산 후 1회)
```
- 셋트공식 평가의 qty = **copies(부수)**. comp가 .01(단가형)이면 `unit_price × copies`(pricing.py:196 `component_subtotal`).
- 표지·제본 둘 다 **per-book 밴드룩업**(min_qty 차원·copies로 밴드 선택) → `per-book단가 × copies`. 정합.

### 2.2 ★표지 배선 = 세트공식 comp (옵션 B 채택) — 트레이드오프 명시

| | 옵션 A: 표지=구성원(073) 공식 | **옵션 B: 표지=세트공식 comp (채택)** |
|---|---|---|
| 라이브 구조 정합 | △ 라이브가 묶은 p02(표지+제본)를 인위 분리 | ✅ **p02=표지+제본 묶임·동일 밴드와 1:1**(probe 실증) |
| member qty 계약 | 표지 구성원에 qty=copies 산출 계약 추가 필요 | 불요(세트공식 qty=copies 자동) |
| 신규 mint | 표지 PRF + min_qty 차원 + 073 바인딩 | 세트공식에 comp 1개 추가만 |
| 이중합산 위험 | 표지가 구성원에도·세트에도 들면 위험 | **0**(표지=세트공식에만·073 무공식 유지) |
| 단순성 | 낮음 | **높음** |

→ **채택 = 옵션 B**(사용자 directive "라이브 분해 근거로 가장 단순·이중합산0"). 라이브 ASP가 표지+제본을
p02로 **묶어** per-book 밴드룩업·사이즈 독립으로 노출 → 표지를 제본과 같은 세트공식에 2 comp로 배선하는 것이
라이브 구조와 정확히 일치. 표지 구성원(073)에는 **공식 미부여**(이중합산 원천 차단).

> 비교: 069 무선책자 선례 `PRF_BIND_MUSEON = COMP_BIND_MUSEON 1개`(제본만). 069는 **표지 비목이 없는
> 일반 무선책자**라 비교 대상 아님. 하드커버는 표지가 per-book 묶임이 특수 → 표지 comp 추가가 정당.

### 2.3 비목 분담 (권위 하드커버무선 = 6비목)

| 비목 | 어디서 | 이번 설계 |
|---|---|---|
| 제본비 | 세트공식 COMP_BIND_HC_MUSEON | ✅ |
| **표지(전용지) 인쇄+용지+코팅** | 세트공식 **COMP_COVER_HC_PAPER**(per-book 묶음가) | ✅ 신설 |
| 내지 인쇄비 | 구성원 PRD_000284 (PRF_DGP_A) | 🔴 BLOCKED(차원 부재) |
| 내지 용지비 | 구성원 PRD_000284 (COMP_PAPER) | 🔴 BLOCKED(하드커버 plt_siz 행 0) |
| 면지 | — | ✅ 무료(비목 제외) |
> 표지는 라이브가 "인쇄+용지+코팅"을 per-book 단일가로 묶었으므로 **분해하지 않고 묶음 단가**로 적재
> (probe가 그렇게 노출·날조 방지). 분해 단가는 권위/라이브 어디에도 없음.

---

## 3. 신규 생성물 설계 (search-before-mint)

### 3.1 search-before-mint 결과

| 항목 | 라이브 실재? | 처리 |
|---|---|---|
| COMP_BIND_HC_MUSEON (제본) | ✅ 6단가행(8324~8329)·.01·use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"] | 재사용 |
| **COMP_COVER_HC_PAPER** (표지 전용지) | ❌ **부재**(COMP_COVER%·COMP_%HC% 조회=BIND 2개만) | **신규 mint** |
| **PRF_BIND_HC_MUSEON** (세트 합산공식) | ❌ **부재**(PRF_BIND_* = MUSEON·PUR·SUM·TWINRING만) | **신규 mint** |
| 부모 072 바인딩 | ❌ 부재(072·전 구성원 바인딩 0건) | **신규 mint** |
| 표지 자재 MAT_000246 전용지 | ✅ 실재(MAT_TYPE.01) | 참조(매칭 불요·§3.2) |
| 채번: comp_price_id MAX | 40332 | 신규 표지 단가행 = 40333~40338 |

### 3.2 COMP_COVER_HC_PAPER (표지 전용지 단가)

| 컬럼 | 값 | 근거 |
|---|---|---|
| comp_cd | `COMP_COVER_HC_PAPER` | 컨벤션(COMP_BIND_HC_MUSEON 동형·표지=COVER) |
| comp_nm | `표지비 하드커버 전용지(per-book·인쇄+용지+코팅 묶음)` | 라이브 묶음가 명시 |
| prc_typ_cd | **PRICE_TYPE.01** (단가형) | per-book 단가 × copies(probe 실증·제본과 동형) |
| use_dims | **`["min_qty"]`** (판별차원 없음=항상매칭) | 072 표지=전용지 1종 → 판별축 불요. 선례 다수(COMP_FOLD_CARD_2H·.01형) |
| use_yn / del_yn | Y / N | |

**단가행 6개** (apply_ymd=2026-06-01·제본과 동일 기준일·verbatim):

| comp_price_id | min_qty | unit_price | note |
|---|---|---|---|
| 40333 | 1 | 4100.00 | 표지 전용지 per-book(라이브 역산 p02−제본)·수량 1 이상 |
| 40334 | 4 | 2425.00 | 수량 4 이상 |
| 40335 | 10 | 1910.00 | 수량 10 이상 |
| 40336 | 50 | 1170.00 | 수량 50 이상 |
| 40337 | 100 | 969.00 | 수량 100 이상 |
| 40338 | 1000 | 368.40 | 수량 1000 이상 (numeric(12,2)·소수 허용 확인) |

> ★use_dims=["min_qty"]만 = "판별차원 없음 — 선택과 무관 항상 매칭"(pricing.py:601). 전용지 1종이라
> set_selections 무관하게 항상 매칭+copies 밴드룩업. 표지종류 분기(레자)가 필요해지면 mat_cd 추가+레자 단가행
> 확장(향후·077). 이번 072=전용지 1종이라 가장 단순·정확.

### 3.3 PRF_BIND_HC_MUSEON (세트 합산공식)

| 컬럼 | 값 |
|---|---|
| frm_cd | `PRF_BIND_HC_MUSEON` |
| frm_nm | `하드커버무선 세트공식(제본+표지·per-book 밴드)` |
| use_yn | Y |

**formula_components 2행**:

| disp_seq | comp_cd | addtn_yn | 비목 |
|---|---|---|---|
| 1 | COMP_BIND_HC_MUSEON | Y | 제본비(재사용) |
| 2 | COMP_COVER_HC_PAPER | Y | 표지 전용지(신설) |

### 3.4 부모 바인딩

| prd_cd | frm_cd | apply_bgn_ymd | note |
|---|---|---|---|
| PRD_000072 | PRF_BIND_HC_MUSEON | 2026-06-01 | 하드커버책자 세트공식(제본+표지) |

> 제본 comp는 use_dims에 proc_cd 정확매칭 필요 → 세트공식 평가시 **set_procs=[{proc_cd:PROC_000023}]**
> 전달이 호출 계약(시뮬레이터/위젯). 표지 comp는 항상매칭이라 set_selections 무관.

---

## 4. 수기검산 (설계 단가행 ↔ 라이브 역산 종단 대조)

> 실제 simulate_set 검증은 COMMIT 후 가능(미바인딩 상태선 frm=null). 여기선 수기검산까지.

### 4.1 표지 6밴드 (설계 ↔ 역산 일치)

| min_qty | 설계 unit | 역산 unit | 일치 |
|---|---|---|---|
| 1 | 4,100 | 4,100 | ✅ |
| 4 | 2,425 | 2,425 | ✅ |
| 10 | 1,910 | 1,910 | ✅ |
| 50 | 1,170 | 1,170 | ✅ |
| 100 | 969 | 969 | ✅ |
| 1000 | 368.4 | 368.4 | ✅ |

### 4.2 세트공식 종단 (제본+표지 per-book × copies = 라이브 p02 총액)

| copies | 표지(설계) | 제본(DB) | 세트공식 per-book | ×copies | 라이브 p02 총액 | 일치 |
|---|---|---|---|---|---|---|
| 1 | 4,100 | 30,000 | 34,100 | 34,100 | 34,100 | ✅ |
| 4 | 2,425 | 20,000 | 22,425 | 89,700 | 89,700 (22,425×4) | ✅ |
| 10 | 1,910 | 14,000 | 15,910 | 159,100 | 159,100 | ✅ |
| 50 | 1,170 | 9,000 | 10,170 | 508,500 | 508,500 | ✅ |
| 100 | 969 | 7,000 | 7,969 | 796,900 | 796,900 | ✅ |
| 1000 | 368.4 | 6,000 | 6,368.4 | 6,368,400 | 6,368,400 | ✅ |

→ 세트공식(제본+표지)이 라이브 ASP의 p02(표지+제본)를 **전 밴드 정확 재현**. 이중합산 0.

### 4.3 종단 예 (진단서 §3.4 / probe 검증)

A4·page30·qty1·전용지표지·블랙면지 = 라이브 total 46,500
```
46,500 = 표지+제본(p02=34,100·세트공식)  +  내지(p01=12,400·구성원 BLOCKED)  +  면지(0·무료)
```
- 이번 설계 COMMIT 후 세트공식 산출 = **34,100**(표지+제본). 내지 12,400은 구성원 공식 부재라 미산출
  → 부분가(전체 46,500의 표지+제본 부분). **내지 트랙 완결 시 종단 46,500 일치**(§6).

---

## 5. DRY-RUN 결과

`hardcover072-price-260629-dryrun.sql` = BEGIN … (INSERT ON CONFLICT) … 행수 검증 SELECT … ROLLBACK.
psql -f 실제 실행으로 PK충돌 0·행수 정확 실증(롤백이므로 라이브 무변경). 결과는 §끝 "실행 로그" 참조.

**실행 결과 (psql -f · ON_ERROR_STOP=1 · RC=0)**:

| 검증 | 기대 | 결과 |
|---|---|---|
| comp INSERT (COMP_COVER_HC_PAPER) | 1 | ✅ INSERT 0 1·comp_after=1 |
| 단가행 INSERT (40333~40338) | 6 | ✅ INSERT 0 6·prices_after=6 |
| formula INSERT (PRF_BIND_HC_MUSEON) | 1 | ✅ INSERT 0 1 |
| formula_components INSERT | 2 | ✅ INSERT 0 2 |
| 바인딩 INSERT (072→PRF) | 1 | ✅ INSERT 0 1 |
| 표지 단가행 내용 verbatim | 4100/2425/1910/1170/969/368.40 | ✅ 전 밴드 역산 일치 |
| 멱등 재실행(2회째) 추가행 | 0 | ✅ **INSERT 0 0** ×4(단가행/comp/fc/bind 불변) |
| PK 충돌 / 에러 | 0 | ✅ RC=0·에러 0 (PK 확인: t_prd_product_price_formulas PK=(prd_cd,apply_bgn_ymd)로 ON CONFLICT 정정함) |
| 최종 ROLLBACK | 라이브 무변경 | ✅ ROLLBACK 완료·사전 0건 그대로 |

→ **DRY-RUN PASS**(PK충돌0·멱등·행수정확·롤백 안전). fix.sql은 동일 INSERT의 COMMIT 버전(undo 동봉·실행 금지).

---

## 6. 여전히 BLOCKED / 인간 큐

| ID | 트랙 | 사안 | 라우팅 |
|---|---|---|---|
| **CONFIRM-COVER-PRICE** | authority | 표지 전용지 6밴드 = 라이브 역산(권위 엑셀 명시절가 없음·"따로 계산") → 실무진 라이브 값 유지/갱신 확정 | 인간(실무진)·COMMIT 전 |
| **BLOCKED-INNER-PRICE** | price/dimension | 내지(PRD_000284) 종이/인쇄비 미구성: 자재0·공정0·공식0·COMP_PAPER 하드커버 plt_siz(SIZ_000250/252) 단가행 0. 내지=페이지×부수 파생 → PRF_DGP_A 바인딩+차원 충전+종이별 단가행 필요 | §18 디지털인쇄 설계 + dbmap 차원/단가 적재·인간 승인 |
| **BLOCKED-MAT-REWIRE** | material | 표지 자재(073에 0개)·부모 좀비자재 정리는 선행설계 §4.4 dbmap 위임분(이 가격설계와 별 트랙) | dbmap/basecode·인간 승인 |
| **C트랙(코드결함)** | engine | 제본 .01 ×copies가 시뮬레이터에서 실제 ×copies 곱해지는지·S1/S2 이중합산·책등 by 페이지 | 개발팀·COMMIT 후 골든 실측 |

### 이번에 해소된 직전 BLOCKED
- ✅ **표지 전용지 단가**(직전 🔴 "가격표 부재·역산만") → 6밴드 verbatim 설계 확정·DRY-RUN까지.
- ✅ **세트 합산공식 부재**(직전 frm=null) → PRF_BIND_HC_MUSEON(제본+표지) 설계 확정.
- ✅ **표지 배선 트레이드오프**(구성원 vs 세트공식) → 세트공식(옵션 B) 라이브 구조 정합으로 확정.

---

## 7. COMMIT 준비분 vs BLOCKED분 요약

**COMMIT 준비(인간 승인 + CONFIRM-COVER-PRICE 후)** — `hardcover072-price-260629-fix.sql`:
1. COMP_COVER_HC_PAPER comp 1행 + 단가행 6행(40333~40338).
2. PRF_BIND_HC_MUSEON 공식 1행 + formula_components 2행(제본+표지).
3. PRD_000072 → PRF_BIND_HC_MUSEON 바인딩 1행.
→ COMMIT 시 **표지+제본 세트공식 PRICED**(전 밴드 라이브 p02 정확 재현). simulate_set 골든 검증 필수.

**아직 BLOCKED(별 트랙·이 설계로 불가)**:
- 내지(284) 가격 = §18 디지털인쇄 + dbmap 차원/단가 적재(BLOCKED-INNER-PRICE).
- 표지/좀비 자재 정리 = dbmap(BLOCKED-MAT-REWIRE).

---

## 8. 안전 / 위상
- 라이브 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만. 실 COMMIT/DDL·webadmin 코드수정 0. git 커밋 0.
- 권위 엑셀 절대. 표지 단가=라이브 역산 보강 오라클(근거 probe csv 명시·과신 금지·CONFIRM-COVER-PRICE).
- 단가 날조 0(표지=역산 verbatim·제본=DB verbatim). 미상(내지)=BLOCKED 명시.
- fix.sql은 만들되 **실행 금지**(인간 검토용·undo 동봉).
