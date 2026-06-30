# 배선 설계 12건 독립 검증 게이트 (E1~E7) — 260701

- 검증가: hpe-validator(Claude). 생성≠검증·라이브 읽기전용 SELECT만·DB 쓰기 0·생성자 주장 비신뢰(직접 재실측).
- 대상: `design-namecard-260701.md`(명함 8) + `design-bind-fold-board-260701.md`(엽서북·보드 4 + BLOCKED 강등 캘린더1·접지2).
- 권위: `live-snapshot/latest/t_prc_*`(가격표260527 적재 verbatim)·엔진 `pricing.py`(_row_matches L94·match_component L134·component_subtotal L193).
- 판정 요약: **GO 11건(명함8+보드2+회귀1) · NO-GO 1건(엽서북30p·선택수단 무효)·BLOCKED 정당 3건.**

---

## 핵심 엔진 사실(독립 재확인)

- **매칭은 행 컬럼 기반**: `_row_matches`는 `NON_QTY_DIMS`=(siz_cd,plt_siz_cd,print_opt_cd,mat_cd,proc_cd,opt_cd,coat_side_cnt,bdl_qty)를 행 컬럼에서 읽는다. **use_dims는 엔진 매칭에 미사용**(price_views가 UI 그리드·opt_grp 스코프에만 사용·L60 split_scopes). → 배선 정확성의 자 = 행의 판별 컬럼 충전 여부.
- 행 판별차원 NULL = 와일드카드(항상 매칭). 형제 comp가 같은 (print_opt,opt) 신호를 가지면 동시합산 과대청구.
- **opt_cd 선택값 환원 경로 2종**: ① `t_prd_product_options`(OPV in opt_grp) → `_opt_cd_options`(L726) → `selections['opt_cd']=OPV`. **라이브 실증=COMP_ACRYL_BADGE opt_cd=OPV_000466/467**(작동). ② `t_prd_product_option_items` ref_dim_cd → 차원 환원. ref_dim 도메인 = **OPT_REF_DIM.01~.07 (사이즈/판형/자재/공정/묶음수/도수/셋트) — opt_cd 대응 코드 없음.**

---

## A. 오리지널박명함 PRD_000037 (4 body + 2 setup) — **GO**

| 게이트 | 판정 | 증거 |
|---|---|---|
| E1 공식 추출 | PASS | body 단가 3353~3388 verbatim 일치(200=19200/24800 … 1000=64000/92000). setup 3351/3352=5000. |
| E2 분해 정합 | PASS | PRF_NAMECARD_FOIL 현 배선=S1_STD(1)+SETUP_S1(2)뿐. 추가 4건 외 형제 없음→hidden sibling 없음. |
| E3 흡수 | N/A | 경쟁사 흡수 아님(후니 권위). |
| E4 엔진 건전성 | PASS(조건) | 선택수단=t_prd_product_options(opt_cd) — **ACRYL_BADGE 라이브 패턴 실증**. ★채번 충돌(아래). |
| E5 세트 | N/A | |
| E6 골든 | PASS | 재계산 일치(아래). |
| E7 독립성 | PASS | 라이브 직접 재실측. |

### disjoint 진리표 재검증 (설계 충전 후 행 신호)
| comp | (print_opt, opt_cd) | 단면·일반박 | 양면·홀로 |
|---|---|---|---|
| S1_STD | (POPT1, OPV487) | **매칭** | — |
| S1_HOLO | (POPT1, OPV488) | — | — |
| S2_STD | (POPT2, OPV487) | — | — |
| S2_HOLO | (POPT2, OPV488) | — | **매칭** |
| SETUP_S1 | (POPT1, NULL=*) | **매칭** | — |
| SETUP_S2 | (POPT2, NULL=*) | — | **매칭** |
→ 각 주문 = body 1 + setup 1. 4 body (print_opt×opt) 완전 disjoint. **silent-sum 0. PASS.** (현 상태=전 body opt/print NULL=와일드카드 → 현 저청구 실재 확인.)

### 골든 재계산 (합가형 .02 확인·setup .03 확인)
| 케이스 | 재계산 | 권위 | 일치 |
|---|---|---|---|
| 단면·일반박·200 | 19200/200×200 + 5000 = **24,200** | 24,200 | ✅ |
| 양면·홀로·300 | 33200/300×300 + 5000 = **38,200** | 38,200 | ✅ |
| 단면·홀로·500 | 50000 + 5000 = **55,000** | 55,000 | ✅ |

★주의(비차단): body prc_typ=PRICE_TYPE.02(합가형 ÷min×qty)로 등록됨. 행 note는 "고정금액 수량무관"(=.03 의미)이라 **tier 사이 수량(예 250→24,000) 의미 충돌** 잔존. 골든은 전부 qty=tier라 무영향. 설계가 행값 무변경(verbatim)이므로 본 설계 책임 밖이나 §26/실무진 확인 큐.

---

## B. 화이트인쇄명함 PRD_000040 (4 body·공식 신설) — **GO (qty=100 한정)**

| 게이트 | 판정 | 증거 |
|---|---|---|
| E1 | PASS | 3343~3346 verbatim(14500/16000/16000/19000)·print_opt·mat_cd 기충전 확인. |
| E4 search-before-mint | PASS | **PRF_NAMECARD_WHITE 라이브 0건 확인** → 신설 정당. 형제 PRF_NAMECARD_COAT/PEARL 네이밍 정합. |
| E6 골든 | PASS | 무코팅단면 14,500 / 코팅양면 19,000 / 코팅단면 16,000(합가형 ÷100×100). |

### disjoint 진리표
| comp | (print_opt, opt_cd, mat) | 단면·무코팅 | 양면·코팅 |
|---|---|---|---|
| S1W_NOCL | (POPT1, OPV490, MAT137) | **매칭** | — |
| S1W_CL | (POPT1, OPV489, MAT137) | — | — |
| S2W_NOCL | (POPT2, OPV490, MAT137) | — | — |
| S2W_CL | (POPT2, OPV489, MAT137) | — | **매칭** |
→ (print_opt×opt) 완전 disjoint. mat 동일상수. **PASS.**

**조건/CONFIRM**: ① 단가 tier=qty 100 단일(4행)만 적재 — qty≠100은 합가형 외삽(29,000 등) 권위 미보증. GO는 qty=100 한정·§26 tier충전 선행. ② 코팅 기본=무코팅[CONFIRM]. ③ 굿즈자재 138~141 오염은 §17(default 137 무해).

---

## A(엽서북30p) PRD_000094 — COMP_PCB_S1_30P·S2_30P — **NO-GO (선택수단 무효·20p 회귀위험)**

| 게이트 | 판정 | 증거 |
|---|---|---|
| E1 단가 | PASS | 30P 행 3442/3444/3450/3454 등 verbatim(11500/12500/9900 …)·현 print_opt/opt NULL 확인. |
| E2 disjoint(데이터) | PASS | 20P opt=20P / 30P opt=30P + print_opt 충전 시 4조합 disjoint(아래). |
| E6 골든(데이터) | PASS | 단가형×qty 일치(아래). |
| **E4 엔진 건전성** | **FAIL** | **선택수단 메커니즘 무효 — NO-GO 사유.** |
| E5 발현조건 | FAIL | 페이지 선택값이 selections['opt_cd']로 환원 불가. |

### NO-GO 사유 (돈크리티컬·실측)
설계 dryrun A.2 = `t_prd_product_option_items(ref_dim_cd='opt_cd', ref_key1='OPV_PCB_PAGE_20P')`.
- **`ref_dim_cd='opt_cd'`는 스키마 무효** — 라이브 ref_dim 도메인 = OPT_REF_DIM.01~.07뿐(사이즈/판형/자재/공정/묶음수/도수/셋트). **opt_cd 환원 코드 부재.** option_items 경로로는 opt_cd 선택값 생성 불가 → 페이지 선택이 엔진에 안 실림.
- **20p 회귀위험**: 동 dryrun A.3이 20P 234행 opt_cd='OPV_PCB_PAGE_20P' 충전. 선택수단이 opt_cd를 못 주면 selections['opt_cd']=None ↔ 행 opt_cd=non-NULL → **20P/30P 둘 다 no_match → 현재 작동하는 20P 견적이 PRICE=0으로 회귀**. (충전을 무작동 선택수단과 한 묶음으로 COMMIT = 결함.)

### 보정 요구 (→ designer 폐루프)
페이지축은 **명함 패턴(`t_prd_product_options` opt_grp+OPV, dflt=20P)** 으로 교체 → `_opt_cd_options`가 selections['opt_cd']=OPV 공급(ACRYL_BADGE 실증 경로). 교체 후 20P opt_cd 충전이 비로소 안전. **데이터 배선·disjoint·골든은 정확하므로 보정 후 GO 가능(조건부).**

### disjoint 진리표(보정 전제) / 골든
| comp | (print_opt, opt_cd) | 30p·단면 |
|---|---|---|
| S1_20P | (POPT1, 20P) | — |
| S1_30P | (POPT1, 30P) | **매칭** |
| S2_30P | (POPT2, 30P) | — |

| 케이스 | 재계산 | 권위 | 일치 |
|---|---|---|---|
| 30p단면100×150 qty2 | 11500×2 = **23,000** | 23,000 | ✅ |
| 30p단면100×150 qty4 | 9900×4 = **39,600** | 39,600 | ✅ |
| 30p양면100×150 qty2 | 12500×2 = **25,000** | 25,000 | ✅ |
| 30p단면135×135 qty2 | 12500×2 = **25,000** | 25,000 | ✅ |
| 20p단면100×150 qty2(회귀) | 11000×2 = **22,000** | 22,000 | ✅ |

---

## D. 폼보드/포맥스 PRD_000129/130 — BLACK·WHITE5MM — **GO (배선 안전·§7 사이즈 선행)**

| 게이트 | 판정 | 증거 |
|---|---|---|
| E1 | PASS | 4783/4784=8500/14000·4789/4790=10000/16000 verbatim. |
| E2 disjoint | PASS | siz_cd 교집합 ∅(아래). |
| E6 골든 | PASS | 단가형×1 일치. |
| E5 발현조건 | PASS(조건) | product_sizes 129/130={174,197}만 실측 확인 — 315/317 미등록=배선 inert. §7 등록이 발현. |

### siz_cd disjoint(실측)
- PRF_POSTER_FOAMBOARD: WHITE={174,197,293} ↔ BLACK={315,317} → ∅ ✅
- PRF_POSTER_FOMEXBOARD: WHITE3MM={174,197} ↔ WHITE5MM={315,317} → ∅ ✅
→ 같은 공식 배선해도 한 siz_cd 주문에 1 comp만. **silent-sum 0.**

| 케이스 | 재계산 | 권위 | 일치 |
|---|---|---|---|
| 폼보드 블랙 A3(315) | **8,500** | 8,500 | ✅ |
| 폼보드 블랙 A2(317) | **14,000** | 14,000 | ✅ |
| 포맥스5mm A3(315) | **10,000** | 10,000 | ✅ |
| 포맥스5mm A2(317) | **16,000** | 16,000 | ✅ |
| 폼보드 화이트 A3(174)(회귀) | **6,000** | 6,000 | ✅ |

**GO 조건**: 배선 dryrun은 즉시 안전(무해). 발현은 §7/§21 product_sizes 315/317 등록 후. 실무진 노출 승인 큐.

---

## BLOCKED 강등 타당성 (E7 — 과소설계 아님 검증)

### B. 캘린더 제본 PRD_000108~112 — **BLOCKED 정당**
- product_price_formulas(108~112) = **0행 실측**(견적 불가). ✓
- COMP_BIND_CAL_WALL 행 proc_cd = **99/100/101/102**, 상품 process 실측 = 108/109→**076**·110→**079**·111→**021+079**·112→**021**. **교집합 없음 → 배선해도 영구 no_match(제본비 0).** ✓
- 캘린더 본문(장수×) 가격 모델 부재. → 3중 선행 미충족. **억지 배선 거부 정당.**

### C. 접지카드 COMP_FOLD_CARD_3H·6CR — **BLOCKED 정당**
- PRF_DGP_E(활성 접지경로)에 **COMP_FOLD_LEAF_3FOLD(seq5) 이미 배선** 확인 → 3단접지비 이미 과금. FOLD_CARD_3H 추가 배선 시 **이중과금 실재.** ✓
- (설계 경미 오류) FOLD_CARD_2H는 PRF_FOLD_SUM뿐 아니라 **PRF_DGP_C에도 배선**됨(설계는 FOLD_SUM 단독이라 기술). 결론(권위 충돌·superseded 후보·이중과금 가드)은 불변. **BLOCKED 정당.**

---

## 종합 / 채번 충돌 (E4 — 인간 승인 게이트 전 보정 필수)

★**opt_grp 채번 교차충돌**: 명함설계 OPT_000080(박종류/037)·OPT_000081(코팅/040) ↔ 엽서북설계 OPT_000080(페이지수/094). opt_grp_cd는 **전역 공유 코드**(라이브 OPT_000006~014 등 다상품 공유 실측) → OPT_000080 한 코드 두 의미 = 충돌. 현 MAX=OPT_000079. **보정**: 명함 037/040 = OPT_000080/081 유지 GO. 엽서북 페이지 opt_grp = 보정 시 **OPT_000082+** 로 재채번 + t_prd_product_options 테이블로 이전.

| 건 | 판정 | 인간승인 큐 |
|---|---|---|
| 박명함 037 (4body+2setup) | **GO** | 채번 OPT_000080·OPV_000487/488·print_options 2 승인 |
| 화이트명함 040 (4body) | **GO**(qty=100) | 공식신설·OPT_000081·OPV_000489/490·MAT137·tier충전(§26) 선행 |
| 엽서북30p 094 (2comp) | **NO-GO→보정** | 선택수단 t_prd_product_options 교체 후 재게이트 |
| 폼보드/포맥스 129/130 (2comp) | **GO**(배선) | product_sizes 315/317 등록(§7)이 발현조건 |
| 캘린더 108~112 | BLOCKED(정당) | §7 proc 재할당+§18 본문모델+실무진 |
| 접지카드 3H/6CR | BLOCKED(정당) | 실무진 권위(FOLD_CARD vs FOLD_LEAF) |

- 골든 재현: **검증 대상 16 케이스 전건 verbatim 일치(허용오차 0).**
- 단가행 무변경: 전 dryrun UPDATE는 판별 컬럼(opt_cd/print_opt_cd)·use_dims만, unit_price 변경 0 확인. ✅
</content>
</invoke>
