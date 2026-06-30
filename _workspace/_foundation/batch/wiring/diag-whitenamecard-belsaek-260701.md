# 화이트인쇄명함 PRD_000040 견적0 근본원인 — 별색/디지털 가격사슬 실증 진단

생성 2026-07-01 · 라이브 읽기전용 SELECT + simulate(주문/결제/저장 0) · DB 미적재 · 진단까지(실 COMMIT 없음·생성≠검증)
권위: 골든 flat 완제품가(용지포함) 14,500/16,000/16,000/19,000(qty=100) · 상품마스터(별색 화이트·클리어·코팅 미사용) · pricing.py `evaluate_price`

---

## 0. 한 줄 결론

040은 **공식 부재가 아니다** — 라이브에서 **PRF_DGP_A(디지털인쇄 원자합산형A)에 정상 바인딩**돼 있다.
"견적0"의 실체 = **정상 손님 흐름에서 6,213원(용지비만) = 별색 인쇄비 전액 0원**. 근본 = **`print_opt_cd`(단/양면) 선택수단 부재**.
SPOT_WHITE/DIGITAL 단가행은 전부 print_opt_cd를 판별차원으로 요구하는데, 040에 **단/양면 선택수단(product_print_options)이 0건** → 손님 흐름에서 print_opt 미공급 → 별색·디지털 단가행 NO_MATCH → 인쇄비 0 → 용지(판형/자재만 매칭)만 청구.

부차결함: print_opt을 줘도 **원자합산형(PRF_DGP_A)이 골든을 구조적으로 재현 못함**(양면 25,213·양면+클리어 44,213 vs 골든 16,000·19,000). → 별색 원자모델 ≠ 완제품 flat 골든.

---

## 1. 라이브 simulate 실측 (HUNI_ADMIN 읽기전용 POST)

대표선택: siz=SIZ_000008(90x50)·mat=MAT_000362(큐리어스스킨 레드)·qty=100·화이트필수공정 PROC_000008.

| # | 선택 | final_price | 매칭 비목(subtotal) |
|---|---|---|---|
| C1 | 화이트만(print_opt 미공급) | **6,213** | COMP_PAPER 6,212.50 **(별색·디지털 미매칭=0)** |
| C2 | 화이트+클리어(print_opt 미공급) | **6,213** | COMP_PAPER만 (클리어 추가효과 0) |
| C3 | 화이트+PROC_000004(base 주입)·print_opt 미공급 | **6,213** | COMP_PAPER만 (디지털도 print_opt 없어 0) |
| C7 | 화이트만 · **strict mode** | **6,213** | COMP_PAPER만 (strict도 동일) |
| C4 | 화이트 + **print_opt 단면(POPT_000001)** | **15,713** | SPOT_WHITE 9,500 + PAPER 6,213 |
| C5 | 단면 + PROC_000004 base 주입 | 24,213 | DIGITAL 8,500 + SPOT_WHITE 9,500 + PAPER 6,213 |
| C6 | **양면 + 화이트 + 클리어** | **44,213** | SPOT_WHITE 19,000(white) + SPOT_WHITE 19,000(clear) + PAPER 6,213 |

핵심 관찰:
- **print_opt 없으면 별색·디지털 전부 0** (C1~C3·C7) → 정상 손님 흐름 = 6,213(용지만). 이게 "견적0"의 실체.
- print_opt를 주면 별색이 살아나지만(C4) **양면(19,000)·클리어(+19,000) = 골든의 2.3배 과대**(C6 44,213 vs 골든 19,000).
- **score_batch.py가 print_opt/base_proc를 코드주입**(거짓0 방지)해 C4/C6 값을 산출 → 260630 메모 "040 가격 정상 25,213/44,213"은 **주입된 값**(실 손님흐름 6,213을 은폐한 FALSE-PASS). [[digital-print-base-proc-missing-260701]] 동형(공정 대신 print_opt 차원 버전).

---

## 2. per-component 매칭 추적 (PRF_DGP_A 10비목 × 040 선택조합)

라이브 PRF_DGP_A formula_components(배선 실측) + 단가행 매칭:

| comp_cd | use_dims | 040 손님흐름 매칭? | 원인 |
|---|---|---|---|
| COMP_PRINT_DIGITAL_S1 | proc_cd·plt_siz·**print_opt_cd**·min_qty·proc_grp:PROC_000001 | **0** | ⓐ 040 공정에 PROC_000001그룹(=PROC_000004 디지털base) 없음 + print_opt 미공급. **도메인상 정상**(화이트명함=백색토너만·CMYK 없음). 주입 시 +8,500 과대(C5). |
| **COMP_PRINT_SPOT_WHITE_S1** | plt_siz·proc_cd·**print_opt_cd**·min_qty·proc_grp:PROC_000007 | **0 → 핵심결함** | 단가행 530행 전부 print_opt_cd 충전(POPT_000001 265 + POPT_000002 265). 040 print_opt 선택수단 0건 → 미공급 NULL → **판별 mismatch → 별색 인쇄비 0**. print_opt 주면 매칭(row 6946 등 plt=SIZ_000499로 정상 환원). |
| COMP_PAPER | plt_siz·mat_cd | **매칭(6,212.50)** | ⓑ 정상 — 큐리어스스킨 row 41138(1242.50) 매칭. 용지 사슬 무결. print_opt 비요구라 유일하게 항상 청구. |
| COMP_PP_CORNER_RIGHT/CREASE/PERF/VARTEXT/VARIMG | proc_grp별 | 0(선택안함) | 후가공·미선택시 0 정상. |
| COMP_COAT_MATTE/GLOSSY | proc_grp:PROC_000013(코팅) | 0 | 040 코팅공정 미보유=정상(코팅 미사용 권위 일치). 부활 금지. |

클리어 별색(ⓓ): **component 부재 아님 — 통합 SPOT_WHITE_S1이 proc_cd PROC_000009(클리어)로 커버**(C6 클리어 19,000 청구 실증). 040 product_processes에 PROC_000009 보유 → 손님이 클리어 선택가능·과금됨. **별도 클리어 component 배선 금지(이중과금)** — [[whiteprint-material-4color-unified-spot-component-260630]] 일치. ⓓ는 결함 아님.

DB 실측 보조:
- `t_prd_product_print_options(PRD_000040)` = **0건** → 단/양면 선택수단 부재(근본).
- `t_prd_product_processes(PRD_000040)` = PROC_000008(화이트 mand Y)·009(클리어)·027(직각)·028(둥근). **PROC_000004 없음**(디지털base 미바인딩=도메인상 정상).
- `t_prd_product_materials(PRD_000040)` = MAT_000362~365(4색 활성 del_yn=N)·MAT_000361(화이트색지 del_yn=Y)·MAT_000138~141(굿즈 del_yn=Y). **자재 사슬 청결**(4색 정상).

---

## 3. 근본원인 분류 (ⓐⓑⓒⓓ)

| 가설 | 판정 | 근거 |
|---|---|---|
| ⓐ base 디지털인쇄 미바인딩 | **결함 아님(도메인상 정상)** | 화이트명함=백색토너만·CMYK 없음. PROC_000004 부재가 옳음. 주입 시 +8,500 과대(C5). |
| ⓑ 용지 단가행 미적재/미매칭 | **결함 아님** | COMP_PAPER 정상 청구 6,212.50(row 41138). |
| **ⓒ 별색화이트 단가행 차원 미스매치** | **핵심결함(지배)** | SPOT_WHITE 530행 전부 print_opt_cd 충전인데 040 **단/양면 선택수단 0건** → NULL → mismatch → 별색 인쇄비 0 → 손님흐름 6,213(용지만). |
| ⓓ 클리어별색 component 부재 | **결함 아님** | 통합 SPOT_WHITE가 PROC_000009로 클리어 커버(C6 실증). 별도배선=이중과금. |

**지배원인 = ⓒ(print_opt_cd 선택수단 부재)**. 단일 데이터 결함이 별색 인쇄사슬 전체를 죽임.
**부차(값 정합) = 원자합산형 ≠ 골든**: print_opt 충전해도 양면 25,213/양면+클리어 44,213(골든 16,000/19,000의 1.6~2.3배). 공유 SPOT_WHITE는 양면=2×단면·클리어=+전액 구조 → 완제품 flat 골든(축당 +1,500)을 **구조적으로 재현 불가**.

돈 영향: 손님흐름 6,213 vs 골든 14,500(단면) = **−8,287 저청구/건(57%)**. print_opt만 추가하면 양면 +9,213 과대청구로 역전.

---

## 4. 교정 명세 — 별색 모델로 골든(14,500~19,000) 재현

### ★권위 충돌 표면화 (상충 신고)
- 라이브 = PRF_DGP_A **원자합산형**(별색+용지 분해) — print_opt 없어 0, 있어도 양면/클리어 과대.
- 골든 = **flat 완제품가**(용지포함·축당 +1,500) — 원자분해와 비양립.
- → 원자합산형 공유 SPOT_WHITE 값(530행)을 040 하나 위해 재값할 수 없음. **골든 재현 = flat 완제품 comp 채택이 유일.**

### ★결정적 자산: flat 골든 comp가 이미 DB에 적재됨(미배선)
| comp_cd | id | print_opt | unit_price | 골든 |
|---|---|---|---|---|
| COMP_NAMECARD_WHITE_S1W_NOCL | 3343 | POPT_000001 | 14,500 | 단면무클리어 ✓ |
| COMP_NAMECARD_WHITE_S1W_CL | 3344 | POPT_000001 | 16,000 | 단면+클리어 ✓ |
| COMP_NAMECARD_WHITE_S2W_NOCL | 3345 | POPT_000002 | 16,000 | 양면무클리어 ✓ |
| COMP_NAMECARD_WHITE_S2W_CL | 3346 | POPT_000002 | 19,000 | 양면+클리어 ✓ |

prc_typ=PRICE_TYPE.02(합가형 tier÷min_qty×qty)·min_qty=100·mat MAT_000137·**골든과 정확 일치**. use_dims=[mat_cd·min_qty·print_opt_cd]. 단 **공식에 미배선**·**opt_cd 차원 미충전**(NOCL/CL이 단면주문에 동시매칭=ambiguous 위험).

### 권고 = 전용 flat 공식 재바인딩 (design-namecard 260701 노선 — 단 2점 정정)
1. **[정정] "040 공식 부재"는 오진** — 040은 PRF_DGP_A에 바인딩됨. 교정 = **신설 아닌 재바인딩**(기존 PRF_DGP_A 바인딩 종료 + PRF_NAMECARD_WHITE 신규 바인딩).
2. **[정정] "코팅" 라벨 → "클리어 별색"** — 둘째 축은 클리어 별색 유무(별색=정답·코팅 모델 부활 금지). opt_grp/opt 명명 별색으로.

교정 단계:
- (a) **PRF_NAMECARD_WHITE 신설** + 4 flat comp(3343~3346) 배선(addtn_yn=Y).
- (b) **040 재바인딩**: t_prd_product_price_formulas에서 PRD_000040 PRF_DGP_A 종료 → PRF_NAMECARD_WHITE.
- (c) **print_opt 선택수단 추가**(근본): t_prd_product_print_options PRD_000040 ← POPT_000001(단면 dflt Y)·POPT_000002(양면 N). **현재 0건이 지배원인.**
- (d) **클리어 별색 opt_grp/opt 신설**(택1) + 4 단가행 opt_cd 충전 + **use_dims에 opt_cd 추가**(미추가 시 동시매칭). NOCL=dflt·CL=클리어선택.
- (e) **자재 선택수단**: product_materials는 4색 활성이나 MAT_000137(큐리어스스킨 통칭) 등록 확인 — flat comp는 mat_cd=MAT_000137 요구. (현재 040 자재는 MAT_000362~365 코드 — **flat comp mat_cd(MAT_000137)와 코드 불일치 가능 → 검증 필요. mat_cd 와일드 또는 단가행 mat 재정렬 컨펌.**)

대안 = Direction A(원자 유지 + print_opt만 추가): 인쇄비는 살아나나 양면/클리어 과대청구(골든 미달성). **interim "비0화"용·골든 권위 미충족 → 비권고.**

### C-track 여부
**C-track 아님(데이터/모델 교정).** 엔진은 print_opt 판별·per-proc 합산을 정상 수행 — 양면 2× 과대는 SPOT_WHITE **데이터**가 그렇게 적재됐기 때문(공유 별색 generic 값). 코드버그 없음. (단 score_batch의 print_opt/base_proc 코드주입은 테스트 하네스 마스킹 이슈 — 프로덕션 버그 아님·채점기 갭은닉 교훈.)

### 잔여 의존
- **[§26] tier 미적재**: flat comp 4행 모두 qty=100 단일 tier. PRICE_TYPE.02 프로레이팅이라 qty≠100 오산정(예 q200→14500/100×200=29000, 권위 200tier 보장 없음). **골든은 q100 한정 유효 — tier 충전 선행.**
- **[CONFIRM] mat_cd 정합**: flat comp=MAT_000137 vs 040 활성자재 MAT_000362~365. 코드 불일치면 견적0 잔존 → mat 와일드/재정렬 컨펌.
- **[CONFIRM] 클리어 기본값**: 무클리어(저가 14,500) 기본 가정. 실무진/goods.asp 확인.

---

## 5. dryrun 초안 (멱등·NOT EXISTS 가드 · COMMIT 아님 · 채널 테이블명·채번 인간검증 선결)

```sql
-- ⚠ DRAFT — 실행 금지. 인간 승인 후 §7 dbmap 트랙. 채널 테이블명/채번 라이브 재확인 필요.
BEGIN;
-- (a) 전용 flat 공식 신설
INSERT INTO t_prc_price_formulas(frm_cd, frm_nm, use_yn)
SELECT 'PRF_NAMECARD_WHITE','화이트인쇄명함 면/클리어별색/수량별 단가(용지포함)','Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_WHITE');
-- (a) 4 flat comp 배선 (addtn_yn=Y, seq 1..4)
--   COMP_NAMECARD_WHITE_S1W_NOCL/_S1W_CL/_S2W_NOCL/_S2W_CL → PRF_NAMECARD_WHITE
-- (b) 040 재바인딩: PRF_DGP_A 종료 + PRF_NAMECARD_WHITE 신규
--   UPDATE t_prd_product_price_formulas SET (종료) WHERE prd_cd='PRD_000040' AND frm_cd='PRF_DGP_A';
--   INSERT ... PRD_000040 ← PRF_NAMECARD_WHITE (apply_bgn_ymd 2026-06-01)
-- (c) ★근본: 단/양면 선택수단
INSERT INTO t_prd_product_print_options(prd_cd, print_opt_cd, dflt_yn, del_yn)
SELECT 'PRD_000040','POPT_000001','Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options WHERE prd_cd='PRD_000040' AND print_opt_cd='POPT_000001');
INSERT INTO t_prd_product_print_options(prd_cd, print_opt_cd, dflt_yn, del_yn)
SELECT 'PRD_000040','POPT_000002','N','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options WHERE prd_cd='PRD_000040' AND print_opt_cd='POPT_000002');
-- (d) 클리어 별색 opt_grp/opt 신설 + 4 단가행 opt_cd 충전 + use_dims += opt_cd
--   UPDATE t_prc_component_prices SET opt_cd=<무클리어OPV> WHERE comp_price_id IN (3343,3345);
--   UPDATE t_prc_component_prices SET opt_cd=<클리어OPV>   WHERE comp_price_id IN (3344,3346);
--   UPDATE t_prc_price_components SET use_dims=...+opt_cd WHERE comp_cd LIKE 'COMP_NAMECARD_WHITE%';
-- (e) mat_cd 정합 컨펌(MAT_000137 vs MAT_000362~365) 후 처리
ROLLBACK; -- DRAFT
```

골든 재현 검증(교정 후 기대): 단면무클리어 q100=14,500 · 단면+클리어=16,000 · 양면무클리어=16,000 · 양면+클리어=19,000.

---

## 6. 직전 메모 정정 (relitigate 방지)
- **260630 "040 가격 정상 25,213/44,213"** = score_batch print_opt 코드주입 값. 실 손님흐름 = **6,213(별색 0)**. 게다가 주입값마저 골든(16,000) 과대. → "가격 정상" 철회.
- **260701 design-namecard "040 공식 부재→견적0"** = 공식 부재는 **오진**(PRF_DGP_A 바인딩). 단 처방(전용 flat 공식 + print_opt + opt_cd 차원)은 **유효**. 견적0의 실제 원인 = print_opt 선택수단 부재(별색 단가행 차원 mismatch).
