# 적재 매니페스트 — 책자 Tier A 4상품 CPQ 옵션레이어

> **패키지:** `09_load/_exec_tierA_booklet/` · **빌드** 2026-06-14 `dbm-option-mapper`.
> **대상:** PRD_000068 중철 · PRD_000069 무선 · PRD_000071 트윈링 · PRD_000094 엽서북.
> **GO/NO-GO = dbm-validator** (본 문서는 빌드 산출·자가 승인 아님). **NEVER COMMIT**(인간 승인).

## 1. 적재 순서 (FK 위상정렬 — apply.sql)

| step | 파일 | 테이블 | 행수 | 비고 |
|:---:|------|--------|:---:|------|
| 05 | `05_t_prd_product_option_groups.sql` | t_prd_product_option_groups | **32** | (prd,opt_grp_nm) NOT EXISTS 가드. opt_grp_cd=리터럴 OPT_000006~037 (라이브 MAX5+1) |
| 06 | `06_t_prd_product_options.sql` | t_prd_product_options | **140** | enum 24 DO + mat_usage 8 DO. opt_cd 동적채번(리터럴 0·충돌 0) |
| 07 | `07_t_prd_product_option_items.sql` | t_prd_product_option_items | **140** | enum 63 INSERT + mat_usage 8 DO. opt_nm resolve. 트리거 통과 |
| 08 | `08_t_prd_product_constraints.sql` | t_prd_product_constraints | **0** | page_rule 비옵션·제약 DEFER (silsa 동형) |

> 차원행(siz/mat/proc/print_options/sets) **전부 라이브 실재 → 차원 mint 단계 없음**(BLOCKED 0). 트리거 `fn_chk_opt_item_ref`가 07에서 .01/.03/.04/.06/.07 EXISTS 검사 → DRY-RUN 통과 실증.

## 2. 상품별 INSERTABLE 집계 (DRY-RUN 트랜잭션 실측)

| 상품 | option_groups | options | option_items | BLOCKED | constraints |
|------|:---:|:---:|:---:|:---:|:---:|
| PRD_000068 중철 | 7 | 35 | 35 | 0 | 0 |
| PRD_000069 무선 | 8 | 32 | 32 | 0 | 0 |
| PRD_000071 트윈링 | 9 | 60 | 60 | 0 | 0 |
| PRD_000094 엽서북 | 8 | 13 | 13 | 0 | 0 |
| **합계** | **32** | **140** | **140** | **0** | **0** |

> options=option_items (책자류는 1옵션=1포인터). 071 60옵션 = 사이즈4+내지18+내지인쇄2+표지21+표지인쇄2+코팅2+투명커버2+제본1+링컬러3+... mat_usage 자재행 전개분 포함.

## 3. ref_dim_cd 분포 (option_items 140행)

| ref_dim_cd | 의미 | 행수 | 키 | 예 |
|------------|------|:---:|----|----|
| `OPT_REF_DIM.01` | 사이즈 | 11 | siz_cd | SIZ_000170 |
| `OPT_REF_DIM.03` | 자재 | 90 | mat_cd+usage_cd | MAT_000013+USAGE.07 (enum 5 투명커버2/링컬러3 + mat_usage 85 종이) |
| `OPT_REF_DIM.04` | 공정 | 21 | proc_cd | PROC_000018 중철제본 |
| `OPT_REF_DIM.06` | 도수 | 16 | opt_id::int | 1 양면 / 2 단면 |
| `OPT_REF_DIM.07` | 셋트 | 2 | sub_prd_cd | PRD_000095 |

## 4. DRY-RUN 결과 (롤백전용 — 2026-06-14)

| 검사 | 결과 |
|------|------|
| **PASS 1 (트리거 통과·insertability)** | **PASS** — 32 groups / 140 options / 140 items, ERROR 0, 트리거 위반 0 |
| **PASS 2 (멱등성·delta)** | **PASS** — 재실행 후 32/140/140 (delta **0**) |
| **라이브 영속성** | **0** (롤백 후 live option_groups/items = 0, COMMIT 없음 실증) |

> 명령: `./apply.sh dryrun` (BEGIN…apply…ROLLBACK). 멱등은 단일 트랜잭션 내 SQL 2회 실행으로 실측(이름 가드 + opt_cd 동적채번 → 2회차 0).

## 5. 채번 (라이브 MAX+1, `_` separator)

- opt_grp_cd: 라이브 MAX=OPT_000005 → **OPT_000006~OPT_000037** (32개 리터럴).
- opt_cd: 라이브 MAX=OPV_000016 → 동적 채번(삽입 시점 MAX+1). 리터럴 미사용 → enum/mat_usage 충돌 0·재발급 0.

## 6. 미해결 / 다음 (→ dbm-validator·ddl-proposer)

- GAP-DOSU-USAGE·GAP-PARAM·GAP-HIDDEN = `blocked-and-gaps.md`.
- 094 셋트구성 = BOM vs 사용자옵션 **[CONFIRM]**(설계 §5.4) — 본 빌드는 셋트 option_group 1개로 적재(후보 A).
- 실 COMMIT·코드행·DDL = 인간 승인. GO = dbm-validator (`03_validation/cpq-option-validation.md`).
