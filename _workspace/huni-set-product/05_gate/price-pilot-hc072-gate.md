# 072 하드커버책자 PRF_HC_MUSEON_SUM 종단 설계 — 독립 게이트 판정 (S1~S7)

생성: hsp-set-gate (독립 검증·생성≠검증) · 2026-06-25 라이브 읽기전용 SELECT 직접 재실측 + evaluate_set_price/_evaluate_formula 손계산 + BEGIN…ROLLBACK DRY-RUN · **DB 미적재·COMMIT 금지** · 자격증명 `.env.local RAILWAY_DB_*` (비밀값 비노출)

> **검증 철학**: set-designer 주장 비신뢰. 본 게이트의 모든 PASS는 게이트가 라이브에서 **직접 재실측**한 증거에 근거(인용 PASS 0). 돈 크리티컬.

---

## ★0. 종합 판정 (한눈에)

| 항목 | 판정 |
|---|---|
| **종합** | 🟡 **CONDITIONAL GO** — PRF 정의 1행 + formula_components 4배선(READY 비목)은 적재 가능(S1~S3·S5~S7 PASS). **단 바인딩(t_prd_product_price_formulas)은 NO-GO 보류**(내지인쇄+내지용지비 BLOCKED·파국적 과소청구 가드). 즉 "그릇(PRF+fc) 적재는 GO·가격 활성화 바인딩은 BLOCKED". |
| **삭제 comp 2건 재확인** | 🟢 **둘 다 직접 적발 재확인**. COMP_BIND_HC_MUSEON `del_yn='Y'`·COMP_PRINT_DIGITAL_S2 `del_yn='Y'`(게이트 SELECT). 대체 SSABARI `del_yn='N'`·PROC_000023 6행 byte-동일. |
| **내지인쇄 BLOCKED 타당성** | 🟢 **진성 BLOCKED 입증**. 활성 디지털인쇄 comp = S1 단 1개 + formula_components PK=(frm_cd,comp_cd) 실측 + 전 공식 동일 comp 중복 0건 → S1 2회 불가 = 2번째 활성 인쇄 comp 부재. 신규 comp 신설 필요(dbmap). |
| **코팅 이중계상 판정** | 🟢 **이중계상 0 입증**(4원 재대조). 용지비 46.65 = 아트150 순수 절가(코팅 무관 차원)·코팅비 COMP_COAT_MATTE 별 comp·use_dims 상이 → 동시매칭 0·합산 1회. |
| **골든 PRICE** | 🟢 **PRICE ≠ 0**(제본 단독 450,000 입증). 부분 골든(READY 4비목·50권 A5 단면 무광) = pansu=1 시 **499,832.5** / pansu=4 시 **470,106.45**. 어느 쪽도 PRICE≠0·코팅1회·이중합산0. 내지인쇄 BLOCKED 누락 = **완제가 미달**(돈 크리티컬·바인딩 가드). |
| **바인딩 보류 타당성** | 🟢 **보류가 옳다**. 내지인쇄비=책자 최대 비목(총내지매수=부수×⌈페이지/판걸이⌉ 곱). 누락 상태 바인딩 = 파국적 과소청구. apply.sql 바인딩 INSERT 주석 처리 확인. |
| **DRY-RUN** | 🟢 PASS — 제약위반 0·멱등(2회 delta 0)·신규 단가행 0(component_prices 378행 불변)·ROLLBACK 후 0 복원·note 원본 보존. |
| **잔여 CFM** | CFM-HC-BIND-DELYN(코드선택·돈영향0)·CFM-COVER-MAT(자재코드·돈영향0)·CFM-COVER-A4PLT(A4 3절 절가·돈크리티컬)·CFM-COVER-COAT(형식·해소)·CFM-COVER-SONJI(손지·소액)·★골든 pansu 차원(siz_cd 주입값에 따라 표지 출력매수 상이). |

---

## 1. 게이트별 판정표 (S1~S7)

| 게이트 | 판정 | 재실측 증거(게이트 직접 SELECT 2026-06-25) |
|---|---|---|
| **S1 권위 충실성** | 🟢 PASS | PRF_HC% 라이브 0행(search-before-mint 통과·신규 mint 정당). 공식 구조=calc-formula seq64 6비목 권위와 정합. 단가 verbatim(제본 6행·인쇄·코팅·용지=라이브 byte동일·날조 0). |
| **S2 구성원 유형 정합** | 🟢 PASS | 072=PRD_TYPE.01(셋트 완제품)·구성원 073/074/075/076 **전부 PRD_TYPE.02**(반제품). 완제품/기성/디자인 혼입 0. admin.py:1082 인라인 필터 정합. |
| **S3 무결성** | 🟢 PASS | formula_components PK=(frm_cd,comp_cd)·FK 2개(frm_cd→price_formulas RESTRICT·comp_cd→price_components RESTRICT) 실재. 4 comp 전부 라이브 실재(고아 0). 동일 comp 중복 0건. PRF/fc 0행(충돌 0). |
| **S4 가격 e2e [HARD]** | 🟡 CONDITIONAL | READY 4비목 PRICE≠0(제본 450,000)·이중합산0·코팅1회 입증(§3). **단 내지인쇄+내지용지비 BLOCKED 누락 = 완제가 미달**(6비목 중 최대 비목 부재). 부분 골든만 산출 가능 → 완전 가격 불가 → 바인딩 BLOCKED. |
| **S5 경쟁사 흡수 타당** | 🟢 PASS | naming/codes 후니 유입 0(전 comp/단가행 라이브 재사용·경쟁사 코드 0). 권위 침묵분(공식 부재) 채택 0(권위 calc-formula 명시 공식). 권위 미덮어쓰기. |
| **S6 적재 가능성 DRY-RUN** | 🟢 PASS | BEGIN…ROLLBACK: 1st INSERT 0 1/0 4·2nd delta 0·component_prices 378 불변·note 원본 보존·ROLLBACK 후 0 복원(§6). |
| **S7 생성≠검증 독립성** | 🟢 PASS | 본 판정 전 게이트=게이트 직접 SELECT(del_yn·byte동일·PK·process·discount·DRY-RUN). 생성자 주장 인용 PASS 0. codex reconcile 항목=해당 없음(본 파일럿 codex 미동원). |

**단일 FAIL 없음. S4만 CONDITIONAL(내지 BLOCKED·정직한 사유 명시) → 종합 CONDITIONAL GO(PRF+fc 적재 GO·바인딩 BLOCKED).**

---

## 2. 삭제 comp 2건 — 게이트 직접 적발 재확인 (KEY1·KEY2)

게이트가 set-designer 주장을 믿지 않고 직접 `t_prc_price_components.del_yn`을 SELECT:

```
COMP_BIND_HC_MUSEON | 제본비 하드커버무선 | use_yn=Y | del_yn=Y  ← 논리삭제 적발
COMP_BIND_SSABARI   | 제본비 싸바리바인더 | use_yn=Y | del_yn=N  ← 활성(대체)
COMP_PRINT_DIGITAL_S1 | 디지털인쇄비     | use_yn=Y | del_yn=N  ← 활성(표지인쇄)
COMP_PRINT_DIGITAL_S2 | 디지털인쇄비     | use_yn=Y | del_yn=Y  ← 논리삭제 적발
```

**제본 단가 byte-동일 재확인** (COMP_BIND_SSABARI vs HC_MUSEON · proc_cd=PROC_000023):

| min_qty | HC_MUSEON | SSABARI | 동일 |
|---|---|---|---|
| 1 | 30000.00 | 30000.00 | ✓ |
| 4 | 20000.00 | 20000.00 | ✓ |
| 10 | 14000.00 | 14000.00 | ✓ |
| 50 | 9000.00 | 9000.00 | ✓ |
| 100 | 7000.00 | 7000.00 | ✓ |
| 1000 | 6000.00 | 6000.00 | ✓ |

→ **6행 완전 일치**. SSABARI(활성) 대체 = 단가 변동 0의 안전한 정명 선택. CFM-HC-BIND-DELYN(코드 선택·돈영향0)은 정직한 CONFIRM.

→ 활성 디지털인쇄 comp 전수 SELECT: `COMP_PRINT_DIGITAL_S1`만(나머지 활성 인쇄 comp=별색/명함/아크릴 전용·일반 디지털인쇄 아님). S2 삭제 확정.

---

## 3. 내지인쇄 BLOCKED + 코팅 이중계상 0 — 독립 재확인

### 3.1 내지인쇄 진성 BLOCKED (KEY2·돈 크리티컬)

- 활성 디지털인쇄 comp = **S1 단 1개**(S2 del_yn=Y 삭제).
- `t_prc_formula_components_pkey` = **PRIMARY KEY (frm_cd, comp_cd)** (게이트 pg_constraint SELECT 실재).
- 라이브 전 공식 동일 comp 중복 = **0건**(GROUP BY HAVING count>1 → 빈 결과).
- → 한 공식(PRF_HC_MUSEON_SUM)에 S1을 표지인쇄(seq2)·내지인쇄(seq5) 둘 다 넣을 수 없음(PK 위반).
- → **내지인쇄 = 진성 BLOCKED**(2번째 활성 인쇄 comp 부재 = 신규 comp `COMP_PRINT_BOOK_INNER` 신설 필요·S1 단가 verbatim 복제·dbmap 트랙).
- ★엔진 측면 보강: `_evaluate_formula`(pricing.py:551~596)는 `del_yn` 미필터(삭제 comp도 평가). 그러나 (a) PK가 같은 comp 2회를 원천 차단 (b) S2를 배선해도 논리삭제 comp 참조는 admin/BOM에서 소실 위험 → 설계가 S2 배선을 피하고 BLOCKED 처리한 것은 **정확**.

### 3.2 코팅 이중계상 0 (KEY3·4원 재대조)

| 증거 | 게이트 직접 실측 | 판정 |
|---|---|---|
| E1 용지비 단가 | COMP_PAPER MAT_000078(아트150)·SIZ_000499 = **46.65**·use_dims=[plt_siz_cd,mat_cd] | 순수 종이 절가(코팅 차원 부재) |
| E2 코팅비 별 comp | COMP_COAT_MATTE·use_dims=[proc_cd,plt_siz_cd,coat_side_cnt,min_qty,proc_grp] | comp_cd 상이·차원 상이 |
| E3 코팅 단가행 실재 | COMP_COAT_MATTE/PROC_000015/SIZ_000499/coat_side_cnt=1: 1=2000…50=700 | 코팅비 별 경로 실재 |
| E4 MAT_000246 단가행 | **0행**(전용지 미적재) | 표지용지=아트150(46.65) 복제 대상·CFM-COVER-MAT |

→ COMP_PAPER(46.65 순수 절가)와 COMP_COAT_MATTE(코팅비)는 **comp_cd 상이 + use_dims 상이** → `_match_entry` 동시매칭 불가 → **이중합산 0**. 코팅은 seq3에서 1회만 계상.

---

## 4. 권위·라이브 2중 확정 사항

- **072 process** 라이브 = {PROC_000014 유광·PROC_000015 무광·PROC_000023 하드커버무선·PROC_000076 수축포장} → **박(foil) 공정 미등록** → 후가공박(6) N/A 확정(권위 calc-formula + 라이브 2중).
- **072 discount_tables = 0행** → 할인 없음(CFM-HC-DSC 해소).
- **072 바인딩 = 0행** → 바인딩 충돌 0·멱등 가능(단 BLOCKED 가드로 미실행).

---

## 5. 골든 부분 재계산 (S4·READY 4비목·evaluate_set_price 손계산)

> 상세 종단 재현은 `price-e2e-trace-hc072.md` 참조. PRICE≠0·이중합산0·코팅1회·내지 누락 명시.

케이스: A5(SIZ_000170)·단면(POPT_000001)·100p·50권·무광 단면(PROC_000015·coat_side_cnt=1)·제본 PROC_000023.

| seq | 비목 | comp | comp_qty | 단가(verbatim) | subtotal |
|---|---|---|---|---|---|
| 1 | 제본비 | COMP_BIND_SSABARI | copies=50 (plt_siz 미사용) | 50권 tier=9,000 | **450,000** |
| 2 | 표지인쇄 | COMP_PRINT_DIGITAL_S1 | plate_qty(50,pansu) | tier 단가 | >0 |
| 3 | 표지코팅 | COMP_COAT_MATTE | plate_qty(50,pansu) | tier 단가 | >0 |
| 4 | 표지용지비 | COMP_PAPER(아트150) | plate_qty(50,pansu) | 절가 46.65 | >0 |
| (미배선) 5 | 내지인쇄 | 🔴 BLOCKED | — | — | **누락(완제가 미달)** |
| (미배선) 6 | 후가공박 | ⚪ N/A | — | — | — |

- pansu=1(표지펼침 1-up): 표지인쇄 250×50=12,500 · 코팅 700×50=35,000 · 용지 46.65×50=2,332.5 → **부분 골든 ≈ 499,832.5**
- pansu=4(fn_calc_pansu('SIZ_000499','SIZ_000170')=4·A5 완제 4-up): 표지인쇄 500×13=6,500 · 코팅 1000×13=13,000 · 용지 46.65×13=606.45 → **부분 골든 ≈ 470,106.45**

✅ **PRICE≠0**(제본 단독 450,000) · ✅ **이중합산0**(comp 4종 상이·코팅1회) · 🔴 **내지인쇄 BLOCKED 누락 = 완제가 미달**(돈 크리티컬·바인딩 가드).

★**게이트 적발(set-designer 보완 권고·NO-GO 사유 아님)**: 설계 골든은 표지 출력매수를 `pansu=1`(펼침 1-up·용지 50매)로 가정했으나, fn_calc_pansu가 selections.siz_cd로 받는 값에 따라(완제 A5=SIZ_000170 주입 시 4-up=plate_qty 13) 표지인쇄/코팅/용지 출력매수가 달라진다. **표지는 펼침면(390x268)을 출력**하므로 siz_cd 주입값(표지 펼침 사이즈코드 vs 완제 A5)을 CPQ가 정확히 환원해야 표지 비목이 옳게 청구됨 → CFM-HC-COVER-PANSU(차원 주입·돈영향 있음). PRICE≠0 결론은 불변.

---

## 6. S6 DRY-RUN 실증 (BEGIN…ROLLBACK·롤백전용)

```
before:  PRF=0  fc=0  component_prices(4 comp)=378
1st apply: INSERT 0 1 (PRF) · INSERT 0 4 (fc)  →  after1 PRF=1 fc=4
2nd apply: INSERT 0 0 (PRF) · INSERT 0 0 (fc)  →  after2 PRF=1 fc=4   (멱등·delta 0)
component_prices = 378 불변                        (신규 단가행 0·search-before-mint)
note = 원본 보존                                    (ON CONFLICT DO NOTHING)
ROLLBACK → PRF=0 fc=0                              (부작용 0·복원)
```

🟢 제약위반 0 · 멱등 delta 0 · 신규 INSERT 카운트 실증(PRF 1·fc 4) · 신규 단가행 0 · 부작용 0.

---

## 7. 종합 결론 + 적재 GO 큐

### 7.1 적재 GO 큐 (load-executor·인간 승인 후)

| 산출 | 테이블 | 행 | 상태 |
|---|---|---|---|
| PRF_HC_MUSEON_SUM | t_prc_price_formulas | 1 | 🟢 GO(DRY-RUN PASS·멱등) |
| formula_components 4배선(제본·표지인쇄·표지코팅·표지용지비) | t_prc_formula_components | 4 | 🟢 GO |
| 신규 price_components | — | 0 | (재사용) |
| 신규 component_prices | — | 0 | (재사용) |

→ **PRF+fc 그릇 적재는 GO**(가격 활성화 아님). 단독 적재 시 기존 가격 동작 무영향(072 미바인딩).

### 7.2 NO-GO/BLOCKED 라우팅 (→ dbmap·인간)

| ID | 결함 | 라우팅 |
|---|---|---|
| BLK-HC-INNERPRINT | 내지인쇄 2번째 활성 인쇄 comp 부재 | dbmap COMP_PRINT_BOOK_INNER mint(S1 단가 verbatim 복제) |
| BLK-HC-INNERPAPER | 내지 용지비 2번째 평가슬롯 | dbmap(내지인쇄와 묶음) |
| BLK-HC-BIND-PRF | 바인딩 보류(과소청구 가드) | 내지 해소 후 hsp-load-executor |

→ **바인딩(t_prd_product_price_formulas)은 내지인쇄+내지용지비 해소 후 실행**(apply.sql 주석 유지·과소청구 가드).

상세 교정 명세 = `price-pilot-hc072-remediation.md`.
