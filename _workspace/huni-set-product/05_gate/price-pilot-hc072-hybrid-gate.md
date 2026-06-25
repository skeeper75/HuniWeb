# 072 하드커버책자 셋트 하이브리드 — 독립 검증 게이트 (S1~S7)

검증: hsp-set-gate · 2026-06-25 · **생성≠검증**(set-designer 주장 비신뢰·라이브 읽기전용 SELECT 직접 재실측 + evaluate_set_price 엔진코드 손계산 + BEGIN…ROLLBACK DRY-RUN) · **COMMIT 0·DB 미적재·단가 verbatim**

> 입력: `06_load/hc072-set-hybrid-design.md` + `06_load/price-pilot-hc072-hybrid/`(price_formulas·formula_components·product_price_formulas·apply.sql·s2_revive.sql·blocked-board)
> 엔진: `pricing.py` evaluate_set_price(:718)·_evaluate_formula(:537)·plate_qty(:199)·match_component(:122)·derive_inner_sheets(:702) / admin.py:1082

---

## ★0. 종합 판정 — **CONDITIONAL (072 본체 바인딩 적재 제외)**

| 결론 | 값 |
|---|---|
| **종합** | **CONDITIONAL** — 표지(073→PRF_HC_COVER) 구조·골든 정합 GO이나 단 1개 항목(내지용지 자재 미등록) 잔존으로 COVER도 즉시-적재 아님. **072 본체(072→PRF_HC_BODY) 바인딩은 NO-GO**(CFM-INNER-TOTSHEET 약 20배 과소청구·돈 크리티컬). |
| **구성원 구조 재확인** | ✅ 직접 실측 일치 — 072 sets = 표지073 + 면지074/075/076(4종)·전부 PRD_TYPE.02·sub_prd_qty=1·min/max/incr 전부 NULL. **내지는 sets 구성원이 아니라 본체 072에 통합 등록**(sizes A5/A4·print_opt POPT_000001/2·page_rule 24-300/2). 확인됨. |
| **CFM-INNER-TOTSHEET 타당성** | ✅ **타당·돈 크리티컬 (설계가 과소 평가)** — 내지가 본체 통합 상태에서 PRF_HC_BODY 내지인쇄(S2)는 본체 copies로만 평가→plate_qty(50,4)=13판×1,600=20,800. **정석(총내지매수=부수×⌈페이지/판걸이⌉)=1,250매×326=407,500**. **약 19.6배·386,700원 과소청구**. 하이브리드 정석=내지 별도 구성원 승격(derive_inner_sheets)이 옳음 — 코드로 확정. **072→PRF_HC_BODY 바인딩 보류 타당**(필수). |
| **표지 PRF_HC_COVER 판정** | 🟡 구조·골든 GO·이중계상0이나 자재코드 결함 1건(아래) + CFM-COVER-SPREAD-SIZ 선결 → **CONDITIONAL** |
| **본체 PRF_HC_BODY 판정** | 🔴 **NO-GO(바인딩)** — CFM-INNER-TOTSHEET(20배 과소) + 내지용지 자재 미등록(no-match 0원) + CFM-INNER-PLATE |
| **골든값(독립 재계산)** | base_total = 표지 64,832.5 + 면지 0 + 본체 470,800 = **535,632.5원**(PRICE≠0·할인 0). 단 본체 470,800 중 내지인쇄 20,800은 정석 407,500의 1/20(과소). 내지용지 0(자재 미등록). |
| **바인딩 보류 타당성** | ✅ apply.sql이 바인딩 INSERT를 주석 처리(가드)한 것은 타당·필수. COVER 바인딩도 CFM-COVER-SPREAD-SIZ·자재 해소 전 보류 권고. |
| **잔여 CFM** | CFM-INNER-TOTSHEET🔴 · CFM-INNER-PAPER🔴(신규 적발) · CFM-INNER-PLATE🟡 · CFM-COVER-SPREAD-SIZ🟡 · CFM-COVER-MAT🔴(설계 "단가동일" 오류 정정) · CFM-COVER-A4PLT🔴 · CFM-S2-REVIVE🟢(부작용0 입증) |

**단일 게이트 FAIL(S4 본체) → 본체 바인딩 NO-GO. 정직한 BLOCKED(내지 구조갭·자재 미등록) → 셋트 본체분만 적재 제외 CONDITIONAL.** 신규 mint 비바인딩분(PRF 2정의·formula_components 6·S2 부활)은 DRY-RUN 무결·멱등이므로 적재 가능하나, **바인딩 없이는 가격 미작동** → 실효 가치는 바인딩 해소에 종속.

---

## S1 권위 충실성 — **PASS**

| 검사 | 재실측 | 판정 |
|---|---|---|
| 072 sets 구성원 | 표지073·면지074/075/076·sub_prd_qty=1·disp_seq 1~4·del_yn=N(직접 SELECT) | ✅ 설계와 일치 |
| min/max/incr(min_cnt/max_cnt/cnt_incr) | 전 구성원 NULL | ✅ 일치(단 codex CN-4 견해차=S7) |
| 내지 위치 | sets 미존재·본체 072 통합(sizes/print_opt/page_rule 실측) | ✅ 설계 주장 재확인 |
| 날조 | 단가·구조 전부 라이브 재실측으로 확인 | ✅ 날조 0 |

## S2 구성원 유형 정합 — **PASS**

| 검사 | 재실측 | 판정 |
|---|---|---|
| sub_prd_cd 유형 | 073/074/075/076 전부 `PRD_TYPE.02`(반제품) | ✅ |
| prd_cd 유형 | 072 = `PRD_TYPE.01`(완제품·셋트) | ✅ |
| admin.py:1082 규칙 | sub_prd autocomplete = `prd_typ_cd="PRD_TYPE.02"` 필터(소스 실측 :1090)·4구성원 전부 부합 | ✅ |
| 혼입 | 완제품/기성/디자인 혼입 0 | ✅ |

## S3 무결성 — **PASS**

| 검사 | 재실측 | 판정 |
|---|---|---|
| 복합PK(prd_cd,sub_prd_cd) 중복 | 0건(GROUP BY HAVING) | ✅ |
| FK 고아(sub_prd_cd∈t_prd_products) | 0건(LEFT JOIN NULL) | ✅ |
| 신규 PRF/fc FK | apply.sql DRY-RUN에서 frm_cd·comp_cd 전부 해소(INSERT 성공·제약위반0) | ✅ |
| 개수규칙 | sets min/max/incr NULL(고정 1) — 위반 아님 | ✅ |
| ⚠️ 바인딩 PK | 라이브 PK=(prd_cd,frm_cd,apply_bgn_ymd)이나 apply.sql 주석에 `ON CONFLICT (prd_cd,apply_bgn_ymd)` 표기 — 잘못된 충돌키(바인딩 주석처리라 비적재·해제 전 교정 필요) | 🟡 비차단(주석) |

## S4 가격 e2e [HARD·돈 크리티컬] — **FAIL (본체)**

독립 손계산(엔진 pure-helper 재현·verbatim 단가) → `price-pilot-hc072-hybrid-e2e.md`.

| 항목 | 독립 재계산 | 판정 |
|---|---|---|
| 표지 contribution | S1@50=550×50=27,500 + 코팅@50=700×50=35,000 + 용지46.65×50=2,332.5 = **64,832.5** | ✅ 설계 일치·이중계상0 |
| 표지 출력매수 | pansu=fn_calc_pansu(국4절,SIZ_000326)=**1**(라이브 실측)·plate_qty(50,1)=50 | ✅ 펼침 1-up 정합 |
| 면지 | 074~076 PAPER 단가행 0행(MAT_000001/2/3 미적재 실측) → 무료 0 | ✅ |
| 본체 내지인쇄 | plate_qty(50,4)=13판 × S2@10=1,600 = **20,800** | 🔴 **정석 407,500의 1/20** |
| **★CFM-INNER-TOTSHEET** | 정석=derive_inner_sheets(50,100,4)=50×⌈100/4⌉=**1,250매** × S2@1200=326 = **407,500**. 본체 copies모델은 페이지 곱(×25) 미반영 → **386,700원 과소청구(19.6배)** | 🔴 **FAIL(돈)** |
| 본체 내지용지 | 072 materials = {면지색001/2/3·전용지246} — **내지 종이 미등록**·MAT_000246 PAPER 단가행 0행 → no-match **0원** | 🔴 **FAIL(미산출·CFM-INNER-PAPER)** |
| 본체 제본 | SSABARI use_dims=[proc_cd,min_qty,proc_grp:PROC_000017]·plt_siz 없음 → comp_qty=copies=50 × PROC_000023@50=9,000 = **450,000** | ✅ 단가형 정합 |
| base_total | 표지 64,832.5 + 본체 470,800 = **535,632.5**·PRICE≠0 | ✅ ≠0 |
| 이중합산 | 표지(PRF_HC_COVER)·본체(PRF_HC_BODY) frm_cd 분리·comp 상이·코팅1회(표지)·제본1회(본체) | ✅ 0 |
| 할인 | 072 discount_tables 0행(실측) | ✅ 없음 |

**S4 FAIL 사유: ① 내지인쇄 19.6배 과소청구(CFM-INNER-TOTSHEET) ② 내지용지 자재 미등록 no-match(CFM-INNER-PAPER).** PRICE≠0·이중합산0·표지 출력매수는 정합이나, 돈 크리티컬 항목 2건이 본체 공식에 잔존 → **본체 바인딩 NO-GO**.

## S5 경쟁사 흡수 타당 — **PASS**

| 검사 | 재실측 | 판정 |
|---|---|---|
| 권위 미덮어쓰기 | 전 comp/단가행 재사용(신규 component_prices 0·신규 price_components 0)·verbatim | ✅ |
| naming/codes 유입 | PRF_HC_COVER/BODY=후니 컨벤션·comp/proc/siz 전부 라이브 기존 코드 | ✅ 후니 유입 0 |
| 권위 침묵분만 채택 | 면지 무료·S2 부활(212행 verbatim 복원)=권위 데이터 환원 | ✅ |

## S6 적재 가능성 DRY-RUN — **PASS**

`BEGIN; apply.sql(비바인딩분); ROLLBACK;` 라이브 실행:

| 검사 | 결과 |
|---|---|
| S2 부활 UPDATE | `UPDATE 1`(del_yn Y→N) |
| PRF INSERT | `INSERT 0 2`(PRF_HC_COVER·BODY) |
| formula_components INSERT | `INSERT 0 6`(COVER3+BODY3) |
| 제약위반 | 0(FK·PK 전부 통과) |
| 멱등(2회) | 2nd PRF INSERT = `INSERT 0 0`(ON CONFLICT DO NOTHING) → delta 0 |
| 부작용 | S2 component_prices=212 불변·신규 단가행 0 |
| ROLLBACK 후 | formulas 0행·S2 del_yn=Y 복원 → 라이브 무변경 |

✅ 비바인딩 적재본은 제약위반0·멱등·부작용0. **단 바인딩 미포함이라 적재해도 가격 미작동**(실효는 바인딩에 종속).

## S7 생성≠검증 독립성 — **CONDITIONAL**

| 검사 | 판정 |
|---|---|
| 직접 재실측 증거 | ✅ 전 수치 라이브 SELECT + 엔진 pure-helper 손계산(인용 아님). CFM-INNER-TOTSHEET 20배 과소를 **게이트가 독립 정량화**(설계는 "잔존"으로만 표기) — 생성≠검증 입증 |
| codex reconcile 미해결 | 🟡 **CN-4/D4 미해결**(`reconcile-ext.md:37,47`) — "하드/링 페이지가변=셋트 member vs 부모옵션"이 게이트/RM-4 위임 상태. **이 미해결이 곧 CFM-INNER-TOTSHEET의 뿌리**(내지 member 승격 여부). hc072-하이브리드 전용 codex reconcile 없음 | CONDITIONAL |

---

## 적재 GO 큐 / 라우팅

- **즉시 적재 GO**: 없음(COVER도 자재/siz 선결).
- **CONDITIONAL 적재(비바인딩 PRF 정의 + S2 부활)**: load-executor 큐 가능하나 **가격 미작동**(바인딩 없이는 실효 0) → 바인딩 해소 동반 권고. 인간 승인 필요.
- **NO-GO(본체 072 바인딩)** → dbmap/§18 라우팅: 내지 반제품 등록 + sets 행 추가(derive_inner_sheets 경로) 또는 본체 공식 페이지곱 모델 신설.
- 상세 교정 명세 → `price-pilot-hc072-hybrid-remediation.md`.
