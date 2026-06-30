# 화이트인쇄명함 PRD_000040 별색 flat 교정 라이브 COMMIT 리포트 — 260701

- 인간 승인: 사용자 2026-07-01 (화이트인쇄명함 PRD_000040 **별색 flat 교정만**·재바인딩 포함·클리어 기본값=없음 확정).
- 스코프[HARD]: PRD_000040 단독. 박명함 037·엽서북·폼보드·기타 상품·PRF_DGP_A 자체 **미실행**(040 바인딩만 제거).
- 게이트: `gate-whitenamecard-flat-260701.md` E1~E7 **GO**(골든 q100 허용오차0·disjoint PASS) + `codex-whitenamecard-flat-260701.md` Phase5.5 **합의(divergence 0)**.
- 결과: **COMMIT 성공 · 골든 4/4 verbatim 일치 · PRICE≠0 · silent-sum 0 · PRF_DGP_A 과대 소멸.**

## 1. 물리 백업 (pre-state)

경로: `_workspace/_foundation/batch/wiring/_backup/whitenamecard040-20260701-041452/`

| 파일 | 백업 행수 | 의미 |
|---|---|---|
| product_price_formulas.csv | 1 | ★PRD_000040×PRF_DGP_A 바인딩(재바인딩 원복용·핵심) |
| component_prices.csv | 4 | 단가행 3343~3346(mat=MAT_000137·opt_cd NULL·14500/16000/16000/19000) |
| price_components.csv | 4 | 4 white comp use_dims(구값 `["mat_cd","min_qty","print_opt_cd"]`) |
| formula_components.csv | 0 | PRF_NAMECARD_WHITE 사전 배선 없음 |
| price_formulas.csv | 0 | PRF_NAMECARD_WHITE 사전 부재(mint 대상) |
| print_options.csv | 0 | PRD_000040 사전 print_options 0건 |
| option_groups.csv / product_options.csv | 0 / 0 | OPT_000081·OPV_000489/490 사전 부재(mint 대상) |

## 2. 사전상태 abort assert (codex R4·fix.sql 내장 DO 블록)

COMMIT 전 RAISE EXCEPTION 가드 — 어긋나면 트랜잭션 abort. 실측 전부 통과:
- 040 바인딩 = PRF_DGP_A **단 1건**(전체 1·DGP 1·WHITE 0). search-before-mint: 채번 numeric MAX=OPT_000080·OPV_000488 → 081/489/490 충돌 0.
- flat comp 3343~3346 **미배선**(count 0)·PRF_NAMECARD_WHITE 공식 **미존재**(count 0).
- 단가행 현재값 verbatim assert: `3343=14500/3344=16000/3345=16000/3346=19000` 일치.
- 실행 로그: `NOTICE: PREFLIGHT PASS`.

## 3. DRY-RUN (BEGIN…ROLLBACK · ON_ERROR_STOP=1)

- 본문 dryrun: 에러 0. V1~V6 검증 SELECT 전부 기대치(바인딩 WHITE·배선 4·print_opt 2·단가행 disjoint·클리어 opt·use_dims).
- **멱등 증명**: 본문 2회 적용(PASS1/PASS2) → PASS2 전부 0(INSERT 0×7·DELETE 0·UPDATE 0×4). NOT EXISTS·IS NULL·구값 가드 작동.
- 전체 fix.sql(preflight 포함, COMMIT→ROLLBACK 치환) 무에러 실행 확인.

## 4. COMMIT (whitenamecard040-fix.sql · BEGIN…COMMIT · ON_ERROR_STOP=1)

- 단일 트랜잭션·FK 위상순(price_formula → formula_components → opt_grp → options → ★재바인딩(DELETE+INSERT) → print_options → 단가행 opt_cd/mat_cd UPDATE → use_dims UPDATE). 에러 0.
- **적용 행수**: INSERT 11 (공식1 + 배선4 + opt_grp1 + opv2 + 재바인딩WHITE1 + print_opt2) · DELETE 1 (PRF_DGP_A 바인딩) · UPDATE 12 (opt_cd 4 + mat_cd→NULL 4 + use_dims 4). **= 24 행 변경.**
- 단가 verbatim: unit_price 변경 **0건**(판별차원 컬럼·use_dims·mat_cd→NULL만).

### 적용 후 DB 상태 (V1~V7 재실측)
- V1 040 바인딩 = **PRF_NAMECARD_WHITE 단 1건** · V7 PRF_DGP_A 바인딩 = **0**(재바인딩 정합).
- V2 배선 4행 · V3 print_opt 2행(단면 dflt Y·양면 N).
- V4 단가행: 3343(P1,489)/3344(P1,490)/3345(P2,489)/3346(P2,490) · mat_cd **NULL**(와일드) · unit_price verbatim.
- V5 클리어 별색: OPV_000489 클리어 없음(dflt **Y**·사용자 확정)·OPV_000490 클리어 있음(N) — **코팅 라벨 0**.
- V6 use_dims = `["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000081"]` (4 comp).

## 5. 사후검증 — 골든 재계산 (시뮬레이터 simulate POST · evaluate_price · 명시 선택)

sim-meta frm = **PRF_NAMECARD_WHITE**(재바인딩 메타 반영). prod_dims = print_opt_cd × opt_cd(클리어).

| 케이스(q100) | 선택 | final_price | 기대(골든) | 일치 | 매칭 비목 |
|---|---|---|---|---|---|
| G1 단면·클리어없음 | P1+489 | **14,500** | 14,500 | ✅ | 1 (S1W_NOCL) |
| G2 단면·클리어있음 | P1+490 | **16,000** | 16,000 | ✅ | 1 (S1W_CL) |
| G3 양면·클리어없음 | P2+489 | **16,000** | 16,000 | ✅ | 1 (S2W_NOCL) |
| G4 양면·클리어있음 | P2+490 | **19,000** | 19,000 | ✅ | 1 (S2W_CL) |

- 전 케이스 **정확히 1비목** 매칭 → disjoint 작동·과대청구(silent-sum) **0**. PRICE≠0.
- **PRF_DGP_A 과대 소멸**: 040에서 PRF_DGP_A 미바인딩(V7=0)·양면가 = flat 16,000/19,000(구 원자합산 25,213/44,213 등 과대 구조적 제거).
- 회복: 견적0/저청구(용지만 6,213) → 정답 완제품가 14,500~19,000 도달.

## 6. undo 보유

- 역연산 SQL: `_workspace/_foundation/batch/wiring/whitenamecard040-undo.sql`(BEGIN…COMMIT·역 FK 순서).
- ★재바인딩 원복 포함: PRF_NAMECARD_WHITE 바인딩 DELETE + **PRF_DGP_A 재INSERT(백업 verbatim — apply_bgn_ymd 2026-06-01·note·reg_dt 2026-06-30 11:59:59 복원)**.
- 순서: use_dims/mat_cd 원복 → opt_cd NULL → print_options DELETE → 재바인딩 원복 → opv/opt_grp DELETE → 배선 DELETE → 공식 DELETE. unit_price 무변경이라 단가 복원 불필요.

## 7. 잔여 caveat (본 COMMIT 범위 밖 · 후속 트랙)

1. **[C1·위젯 §6] 필수선택 강제** — 위젯이 단/양면(print_side) + 클리어(OPT_000081)를 **필수선택 강제**해야 함. 미강제 시 미선택 주문은 0원(견적불가). dflt_yn=Y는 프로덕션 위젯 UI 프리선택으로 실효(시뮬 단독은 미주입). 037 라이브 작동으로 메커니즘 실재. **사후검증은 명시 선택으로 수행.**
2. **[C3·§26] qty≠100 tier** — flat comp는 q100 단일 tier만 적재. PRICE_TYPE.02 프로레이팅(q200=29,000)이라 권위 200tier 미보장. 골든 q100 한정 유효. §26 무결성/§7 적재 선행.
3. **[C6] comp_nm "코팅/무코팅" 라벨** — cosmetic 잔존(가격 무영향). opt 라벨은 별색("클리어 없음/있음"). 후속 정리 optional.
4. **[C5·§17] PROC_000009(클리어 공정) 잔존** — flat 모델 가격무해(proc_cd 미매칭). UX상 공정+옵션 이중 노출 가능 → §17/상품기획 별 트랙.
5. **[R2·codex] 후가공(PROC_000027 직각/028 둥근)** — PRF_DGP_A 제거로 동반 드롭. 직각 단가행 0.00 무료·매출영향 0 재측정 확인. 의도 1줄 CONFIRM 권고(비차단).

## 최종 판정

**화이트인쇄명함 PRD_000040 별색 flat 교정 COMMIT 성공.** 사후검증 골든 4/4 verbatim 일치(14,500·16,000·16,000·19,000), 각 1비목 disjoint, PRICE≠0, silent-sum 0, PRF_DGP_A 과대 소멸·재바인딩 정합(WHITE 단독·DGP 0). 영향 행: INSERT 11 + DELETE 1 + UPDATE 12 = 24. 백업·undo 보유. NO-GO/undo 불필요.
