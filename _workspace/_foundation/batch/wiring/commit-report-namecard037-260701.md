# 박명함 PRD_000037 배선 라이브 COMMIT 리포트 — 260701

- 인간 승인: 사용자 2026-07-01 (박명함 PRD_000037 **배선만** COMMIT).
- 스코프[HARD]: 박명함 PRD_000037 (블록 A) 단독. ★화이트명함 040·엽서북·폼보드 **미실행**(설계 dryrun B 블록 제외).
- 게이트: `gate-design-260701.md` 박명함 037 = **GO**(골든 verbatim 일치·disjoint PASS·채번 충돌 0).
- 결과: **COMMIT 성공 · 사후검증 골든 3/3 일치 · PRICE≠0 · silent-sum 0.**

## 1. 물리 백업 (pre-state)

경로: `_workspace/_foundation/batch/wiring/_backup/namecard037-20260701-025840/`

| 파일 | 백업 행수 | 의미 |
|---|---|---|
| formula_components.csv | 2 | PRF_NAMECARD_FOIL 사전 배선(S1_STD·SETUP_S1) |
| component_prices.csv | 38 | 6 comp(4 body×9 + 2 setup×1) 단가행 전체 |
| price_components.csv | 6 | 6 comp use_dims |
| print_options.csv | 0 | PRD_000037 사전 print_options 없음(신규 INSERT 대상) |
| option_groups.csv | 0 | OPT_000080 사전 부재(mint 대상) |
| product_options.csv | 0 | OPV_000487/488 사전 부재(mint 대상) |

## 2. search-before-mint 검증 (pre-state 실측)

- MAX opt_grp = `OPT_000079` → `OPT_000080` mint 유효(충돌 0). MAX opv = `OPV_000486` → `OPV_000487/488` mint 유효.
- OPT_000080·OPV_000487/488 사전 존재 0행 확인.
- 공식 `PRF_NAMECARD_FOIL` **재사용**(신규 공식 0)·print_opt `POPT_000001/002` **재사용**.
- 단가행 unit_price **변경 0**(판별차원 컬럼·use_dims만 충전).

## 3. DRY-RUN (BEGIN…ROLLBACK · ON_ERROR_STOP=1)

- 1회차: 에러 0. INSERT 5(print_opt 2·opt_grp 1·opv 2)·UPDATE 38 단가행 + 6 use_dims·INSERT 4 배선 → ROLLBACK.
- 멱등 증명: 한 트랜잭션 내 fix 본문 2회 적용 → **PASS-2 전부 INSERT 0 0 / UPDATE 0**(NOT EXISTS·IS NULL 가드 작동).

## 4. COMMIT (namecard037-fix.sql · BEGIN…COMMIT · ON_ERROR_STOP=1)

- 단일 트랜잭션·FK 위상순(print_options → opt_grp → opv → 단가행 충전 → use_dims → formula_components). 에러 0.
- 적용 행수: print_options +2 · opt_grp +1 · opv +2 · 단가행 판별차원 UPDATE 38(36 body + 2 setup) · use_dims UPDATE 6 · formula_components +4.

### 적용 후 DB 상태
- 배선 PRF_NAMECARD_FOIL = **6행**(S1_STD, SETUP_S1, S1_HOLO, S2_STD, S2_HOLO, SETUP_S2).
- body 4 comp: print_opt_cd·opt_cd NULL **0**(완전 충전). setup 2 comp: opt_cd NULL 1씩(의도된 박종류 무관 와일드카드).
- print_options 2행(단면 dflt Y·양면 N). opt_grp OPT_000080(박종류)·OPV_000487 일반박(dflt Y)·OPV_000488 홀로(N).

## 5. 사후검증 — 골든 재계산 (시뮬레이터 simulate POST · evaluate_price)

| 케이스 | 선택 | final_price | 기대(권위) | 일치 | 매칭 비목(silent-sum 0) |
|---|---|---|---|---|---|
| G-A2 | 양면·홀로·qty300 | **38,200** | 38,200 | ✅ | S2_HOLO 33,200 + setup 5,000 |
| G-A3 | 단면·홀로·qty500 | **55,000** | 55,000 | ✅ | S1_HOLO 50,000 + setup 5,000 |
| G-A1 | 단면·일반박·qty200(불변) | **24,200** | 24,200 | ✅ | S1_STD 19,200 + setup 5,000 |

- 전 케이스 **정확히 2비목(body 1 + setup 1)** 매칭 → 판별차원 disjoint 작동·과대청구(silent-sum) 0. PRICE≠0.
- 회복: 양면·홀로 저청구(29,800→38,200, +8,400)·단면·홀로(41,000→55,000) 정답가 도달. 기존 단면·일반박 불변.

## 6. undo 보유

- 역연산 SQL: `_workspace/_foundation/batch/wiring/namecard037-undo.sql`(BEGIN…COMMIT·역 FK 순서).
- 골든 불일치 재발 시: 배선 4 DELETE → use_dims 원복 → 단가행 NULL 환원 → opv/opt_grp DELETE → print_options DELETE.
- 백업 CSV(pre-state) = §1 경로. unit_price 무변경이라 단가 복원 불필요.

## 7. 잔여 caveat (본 COMMIT 범위 밖 · 후속 트랙)

1. **[§26] 합가형 tier 의미 충돌(비차단)** — body prc_typ=PRICE_TYPE.02(÷min×qty)인데 행 note는 "고정금액 수량무관". 골든은 전부 qty=tier라 무영향. tier 사이 수량(예 250) 의미는 실무진/§26 확인 큐.
2. **[§17] product_materials 굿즈 오염** — PRD_000037에 MAT_000138~141 오적재(명함 무관). 견적엔 default 무해. 자재 정리 트랙 위임(본 COMMIT 미포함).
3. **화이트명함 040·엽서북·폼보드** — 본 작업 스코프 밖. 화이트명함은 게이트 GO(qty=100 한정·§26 tier 선행), 엽서북은 NO-GO(선택수단 보정 필요). 별도 승인 시 후속.

## 최종 판정

**박명함 PRD_000037 배선 COMMIT 성공.** 사후검증 골든 3/3 verbatim 일치(38,200·55,000·24,200), PRICE≠0, silent-sum 0. 영향 행: INSERT 9 + UPDATE 44. 백업·undo 보유. NO-GO/undo 불필요.
