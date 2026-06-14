# `_exec_tierA_digitalprint` — 적재 매니페스트 (디지털인쇄 Tier A 14상품 CPQ 옵션레이어)

> 작성 2026-06-14 · `dbm-option-mapper` 산출 · round-6 Tier A 확장. DB 미적재(실 COMMIT/더미정리/DDL = 인간 승인).
> 권위: `10_configurator/tierA/digitalprint-option-layer.md`(STRUCTURE) · `00_schema/cpq-schema.md §2`(트리거) · `_exec_silsa_cpq`(멱등 패턴). 식별자/코드 = English.

## 1. 한 줄 현황

14상품 CPQ 옵션레이어를 멱등 적재 SQL로 산출. **차원행 mint 없음**(14상품 sizes/materials/print_options/processes 전부 라이브 적재 실측 2026-06-14) — 본 패키지는 순수 CPQ 행(option_groups/options/option_items) INSERT. **라이브 롤백전용 DRY-RUN 2-pass 멱등 delta 0·트리거 전건 통과 실증**.

## 2. FK 위상정렬 적재 순서

```
[선행 — L1 차원행, 라이브 적재 실측 완료]
  ✅ sizes(46행)·materials(USAGE.07)·print_options(opt_id 1/2)·processes(027/028/029~032/014/015/037~044)
[00] 마커 (NO INSERT) — 적용 결정 D-A~D-J
[05] t_prd_product_option_groups (58행)        — FK: prd_cd→products, sel_typ_cd→cod
[06] t_prd_product_options (267행)             — FK: opt_grp_cd→option_groups
[07] t_prd_product_option_items (252행 INSERTABLE) — 트리거 fn_chk_opt_item_ref 행단위 차원행 EXISTS
       BLOCKED 6행(접지 4·화이트별색 2)은 _blocked/ 격리(적재 대상 아님)
[08] t_prd_product_constraints (0행)           — 옵션그룹 SEL_TYPE 로 다중/택일 충족
```

> 트리거가 07 행단위로 차원행 EXISTS 검사 → 차원행 실재 INSERTABLE. 같은 트랜잭션 내 05→06→07 순서로 FK 충족.

## 3. 적재 행수 (INSERTABLE / BLOCKED)

| 테이블 | INSERTABLE | BLOCKED | 비고 |
|---|:--:|:--:|---|
| option_groups | 58 | 0 | 트리거 없음. disp_seq=L1 컬럼순서 |
| options | 267 | 0 | 트리거 없음(헤더). 센티넬(코팅없음/박없음) 포함 |
| **option_items** | **252** | **6** | 트리거 차원행 검사. BLOCKED=접지4+화이트별색2 |
| constraints | 0 | 0 | 옵션그룹 SEL_TYPE 로 충족·판수=가격엔진 |
| **합계** | **577** | **6** | INSERTABLE 577행(58+267+252) + BLOCKED 6행(_blocked) |

### 상품별 집계

| prd_cd | prd_nm | grp | opt | item_INS | item_BLK | 보유 옵션그룹 |
|---|---|:--:|:--:|:--:|:--:|---|
| PRD_000016 | 프리미엄엽서 | 4 | 29 | 29 | 0 | 인쇄·종이·모서리·후가공 |
| PRD_000017 | 코팅엽서 | 4 | 9 | 8 | 0 | 인쇄·종이·코팅·모서리 |
| PRD_000018 | 스탠다드엽서 | 4 | 15 | 15 | 0 | 인쇄·종이·모서리·후가공 |
| PRD_000024 | 포토카드 | 5 | 9 | 7 | 1 | 인쇄·종이·코팅·모서리·**화이트별색(BLK)** |
| PRD_000025 | 투명포토카드 | 4 | 5 | 4 | 1 | 인쇄·종이·모서리·**화이트별색(BLK)** |
| PRD_000026 | 종이슬로건 | 3 | 6 | 5 | 0 | 인쇄·종이·코팅 |
| PRD_000027 | 2단접지카드 | 5 | 28 | 25 | 2 | 인쇄·종이·후가공·**접지(BLK)**·박칼라 |
| PRD_000029 | 3단접지카드 | 5 | 28 | 25 | 2 | 인쇄·종이·후가공·**접지(BLK)**·박칼라 (G1-1 보정: 종이 13→14·MAT_000125 추가) |
| PRD_000031 | 프리미엄명함 | 5 | 31 | 30 | 0 | 인쇄·종이·모서리·후가공·박칼라 |
| PRD_000032 | 코팅명함 | 4 | 9 | 8 | 0 | 인쇄·종이·코팅·모서리 |
| PRD_000033 | 스탠다드명함 | 4 | 11 | 11 | 0 | 인쇄·종이·모서리·후가공 |
| PRD_000041 | 스탠다드 쿠폰/상품권 | 3 | 10 | 10 | 0 | 인쇄·종이·후가공 |
| PRD_000042 | 프리미엄 쿠폰/상품권 | 4 | 23 | 22 | 0 | 인쇄·종이·후가공·박칼라 |
| PRD_000047 | 소량전단지 | 4 | 54 | 53 | 0 | 인쇄·종이·코팅·후가공 |
| **합계** | | **58** | **267** | **252** | **6** | |

> opt > item_INS 차이 = 센티넬 옵션(코팅없음·박없음, option_item 0행). 016=29/29(센티넬 없음·후가공 모두 차원행), 024=9/7(코팅없음 센티넬 1 + 화이트별색 BLOCKED 1).

## 4. 채번 (라이브 MAX+1 리터럴 · 멱등은 이름키)

| 코드 | 라이브 MAX(suffix) | 신규 시작 | 비고 |
|---|:--:|:--:|---|
| opt_grp_cd | OPT_000004 / OPT-000005 (=5) | **OPT_000005+** | `_` 통일(D3). 하이픈 더미와 무관 |
| opt_cd | OPV_000016 / OPV-000010 (=16) | **OPV_000017+** | silsa OPV_000006~016 다음 |

> [HARD] surrogate 코드는 리터럴 부여이나 존재검사 = 이름키(prd_cd+opt_grp_nm / prd_cd+opt_grp_cd+opt_nm). 재실행 시 코드 재발급 없이 delta 0.

## 5. DRY-RUN 결과 (라이브 롤백전용 · 2026-06-14)

```
PASS-1 (트랜잭션 내 INSERT):
  groups  58 · options 267 · items 252  (전부 INSERT 0 1)
  트리거 fn_chk_opt_item_ref: 252 option_items 전건 차원행 EXISTS 통과 (REJECT 0)
  029_papers = 14 (G1-1 보정 확인 — MAT_000125 포함)
PASS-2 (동일 트랜잭션 멱등 재실행):
  전 INSERT = INSERT 0 0 (delta 0)
  행수 그대로: items 252
ROLLBACK 후: 영구 변경 0 (post_rollback = 0)
```

- **트리거 통과 실증**: option_item 252행 전부 `(ref_dim_cd, ref_key)` 차원행 EXISTS — 트리거가 트랜잭션 내에서 발화하므로 DRY-RUN이 ref resolve의 최강 증명.
- **멱등 실증**: 2-pass delta 0.
- **롤백전용**: COMMIT 0건. 영구 변경 없음.
- **결함 적발·정정(DRY-RUN 1차)**: PRD_000027/029 도수가 `opt_id=2(양면)` 고정이었으나 라이브 print_options 실측은 `opt_id=1(양면)`(단면 미존재) → 트리거 REJECT. 도수를 라이브 (opt_id, print_side) 실측으로 정정(`[(1,"양면")]`). **교훈: 라이브 print_options 의 opt_id↔print_side 매핑은 상품마다 다름(고정 가정 금지).**
- **보정 G1-1(dbm-validator MAJOR·과소적재)**: PRD_000029 종이가 13종으로 MAT_000125(한지170g·라이브 disp_seq14) 1행 silent drop(형제 027은 14종 전체). 생성기 PAPER_029 에 추가 → 029 종이 13→14·전체 items 251→252. 재 DRY-RUN 2-pass 트리거 통과·delta 0 재확인. **교훈: 형제 상품(동일 카테고리) 종이 목록 대조로 과소적재 검출.**

## 6. 멱등 기제 (핵심)

모든 INSERT = `INSERT … SELECT … WHERE NOT EXISTS (… 이름/자연키 …)`.
- groups: guard = (prd_cd, opt_grp_nm) NOT EXISTS
- options: guard = (prd_cd, opt_grp_cd, opt_nm) NOT EXISTS · opt_grp_cd=그룹이름 resolve
- option_items: guard = (prd_cd, opt_cd, item_seq) NOT EXISTS · opt_cd=(prd,grp,opt_nm) resolve · ref_key=차원행 코드 직접

## 7. 경계 (HARD)

- **NEVER COMMIT** (기본 ROLLBACK). 실제 COMMIT·더미 정리(_cleanup_dummy.sql)·BLOCKED 적재·[CONFIRM] 해소 = 인간 승인.
- CPQ 행 INSERT 만(CREATE/ALTER 없음·DDL 아님·mint 없음).
- GO 판정은 `dbm-validator`(별도 에이전트) 소관. 본 패키지는 빌드 산출 — 자가 승인 금지.
