# `_exec_tierA_areaform` — Tier A 면적형 13상품 CPQ 옵션레이어 적재본

round-6 L2 적재 실행본. 면적형 포스터·배너 13상품(전부 prn=0)의 CPQ 옵션레이어 멱등 적재.
`_exec_silsa_cpq`(일반현수막 138) 구조 모방. **DB 미적재 — 실 COMMIT = 인간 승인.**

## 파일

| 파일 | 내용 |
|---|---|
| `gen_load_sql.py` | 멱등 적재 SQL 생성기(손편집 금지·권위 `tierA/areaform-option-layer.md`) |
| `00_preload_markers.sql` | 적용 결정 markers (NO INSERT) |
| `_l1_link_preload.sql` | **[L1·apply.sql 비포함]** 139 LINK 선적재(열재단·끈·부착 3행)·인간 승인 선행 [FINDING-1] |
| `01_product_links.sql` | **DEPRECATED 스텁** → `_l1_link_preload.sql`로 분리됨 |
| `02_t_prd_product_option_groups.sql` | OG 20행 (OPT_000005~) |
| `03_t_prd_product_options.sql` | option 31행 (OPV_000017~) |
| `04_t_prd_product_option_items.sql` | item 24행 (.03 자재 / .04 공정 polymorphic) |
| `05_t_prd_product_constraints.sql` | R-SIZE-NONSPEC 7행 |
| `apply.sql` | **L2 순수** FK 위상순 단일 트랜잭션 (L1 LINK 비포함) |
| `apply.sh` | psql 로더 (기본 DRY-RUN·`commit` 인자만 실적재) |
| `_idempotency_test.sql` | 멱등 2회차 + L2-순수(L1 미생성) 검증(BEGIN→L2 apply×2→ROLLBACK) |
| `load-manifest.md` | 적재 매니페스트·DRY-RUN 결과 |
| `blocked-and-gaps.md` | BLOCKED 11 · GAP 4 · [CONFIRM] 5 (§0 FINDING-1 보정) |
| `load.provenance.csv` | 행별 출처 권위 |

## 실행

```bash
./apply.sh            # L2 순수 DRY-RUN (BEGIN…ROLLBACK) — 기본, COMMIT 안 함·L1 미생성
./apply.sh commit     # [인간 승인] 실제 COMMIT (L2 옵션레이어만)
# L1 차원 LINK는 별도: psql -f _l1_link_preload.sql (인간 승인 선행)
```

재생성: `python3 gen_load_sql.py`

## DRY-RUN 실증 (2026-06-14, FINDING-1 보정 후)

- PASS 1: 82 INSERT(L2 순수) 성공(트리거 24 item 전건 통과). PASS 2: 전부 `INSERT 0 0` (멱등). ROLLBACK·COMMIT 0.
- L2-순수 재확인: 139 product-link BEFORE 1/1 == AFTER 1/1 (L2 트랜잭션이 L1 차원행 미생성).

## [HARD] 규칙

- NEVER COMMIT by default. DDL(CREATE/ALTER) 없음.
- **[FINDING-1]** L1 차원 LINK(product-materials/processes INSERT)는 `apply.sql`에서 분리 → `_l1_link_preload.sql`(인간 승인 선행). `apply.sql`=순수 L2.
- BLOCKED(거치대 template·BUNDLE 자재 미링크·리본끈 0행·139 LINK 의존) = 본 L2 적재 미관여(차원/LINK 재적재 안 함).
- GO 판정 = `dbm-validator`(자가 승인 금지).
