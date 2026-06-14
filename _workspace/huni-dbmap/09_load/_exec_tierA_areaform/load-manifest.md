# 적재 매니페스트 — Tier A 면적형 13상품 CPQ 옵션레이어

> 생성 2026-06-14 · `dbm-option-mapper` (round-6 L2). 권위 `10_configurator/tierA/areaform-option-layer.md`.
> **DB 미적재** — 실 COMMIT/코드행/DDL = 인간 승인. DRY-RUN(롤백전용) 멱등성·적재가능성만 실증.

## 1. 대상 13상품 (전부 prn=0 면적형)

PRD_000118 아트프린트포스터 · 120 방수포스터 · 121 접착방수포스터 · 122 접착투명포스터 · 124 린넨패브릭포스터 · 125 캔버스패브릭포스터 · 133 캔버스행잉포스터 · 134 린넨우드봉족자 · 135 족자포스터 · 136 PET배너 · 137 메쉬배너 · 139 메쉬현수막 · 145 미니배너.

## 2. FK 위상 적재 순서 (apply.sql = L2 순수 · L1 LINK 분리)

> **[FINDING-1 보정]** L1 차원 LINK(product-materials/processes INSERT)는 `apply.sql`에서 **분리**됨 → 별도 `_l1_link_preload.sql`(인간 승인 선행). `apply.sql`은 L1 차원행을 생성하지 않는 **순수 L2 옵션레이어** 적재.

| step | 파일 | 테이블 | 행수 | 트리거 |
|:--:|---|---|:--:|---|
| 00 | 00_preload_markers.sql | (markers, NO INSERT) | 0 | — |
| 02 | 02_t_prd_product_option_groups.sql | t_prd_product_option_groups | 20 | 없음 |
| 03 | 03_t_prd_product_options.sql | t_prd_product_options | 31 | 없음 |
| 04 | 04_t_prd_product_option_items.sql | t_prd_product_option_items | 24 | **fn_chk_opt_item_ref** |
| 05 | 05_t_prd_product_constraints.sql | t_prd_product_constraints | 7 | 없음 |
| | | **apply.sql L2 INSERT 합계** | **82** | |

**별도 (apply.sql 비포함 · 인간 승인 선행):**
| 파일 | 테이블 | 행수 | 라벨 |
|---|---|:--:|---|
| `_l1_link_preload.sql` | t_prd_product_materials/processes (139 LINK) | 3 | **L1 차원 선적재·인간 승인 필요** |

> L1 LINK 3행 = 139 열재단(PROC_000084)·끈(MAT_000070)·부착(PROC_000081). 라이브 차원 **존재**(mint 불요·LINK only)이나 product-link INSERT = **L1 차원행 생성** → L2 경계 밖. 이 패키지 적재(인간 승인) 후 139 재단만/끈추가 option_items가 INSERTABLE 승격(현재 BLOCKED, §5). `01_product_links.sql`은 DEPRECATED 스텁.

## 3. 코드 채번 (라이브 MAX+1 · 멱등=이름키)

| 엔티티 | 라이브 MAX (2026-06-14) | 본 적재 범위 |
|---|---|---|
| opt_grp_cd | OPT_000004 (138 점유) | OPT_000005 ~ OPT_000024 (20) |
| opt_cd | OPV_000016 (138 점유) | OPV_000017 ~ OPV_000047 (31) |

> 멱등 = 이름기반 NOT EXISTS (opt_grp=(prd_cd,opt_grp_nm)·opt=(prd_cd,opt_grp_cd,opt_nm)·item=(prd_cd,opt_cd,item_seq)·constraint=(prd_cd,rule_cd)·link=자연키). 재실행 시 코드 재발급 없이 delta 0.

## 4. DRY-RUN 멱등성 + L2-순수 실증 (2026-06-14 보정 후, 롤백전용)

- **PASS 1**: 82 INSERT(L2 순수) 전건 성공 — 트리거 fn_chk_opt_item_ref 24 item 전건 통과(LINK 의존 139 재단만/끈추가는 BLOCKED 격리되어 위반 없음) → groups 20 · options 31 · items 24 · constraints 7.
- **PASS 2** (동일 트랜잭션 재실행): 전부 `INSERT 0 0` (delta 0) → **멱등 PASS**.
- **L2-순수 재확인**: 139 product-materials/processes = L2 apply BEFORE 1/1 == AFTER 1/1 → **L2 트랜잭션이 L1 차원행을 생성하지 않음** 실증.
- 트랜잭션 **ROLLBACK** — DB 영구 변경 0. COMMIT 0. ERROR 0.
- (보정 전 이력) 초기 1건 실패(139 재단만→PROC_000084 미링크)를 트리거가 적발 → FINDING-1 보정으로 L1 LINK 분리 + 139 LINK 의존 옵션 BLOCKED 격리. **트리거가 차원행 부재를 정확히 거부함을 실증.**

## 5. INSERTABLE / BLOCKED / GAP 집계 (보정 후)

| 구분 | 수 |
|---|:--:|
| option_groups INSERTABLE | 20 |
| options INSERTABLE | 31 |
| option_items INSERTABLE | 24 |
| constraints INSERTABLE (R-SIZE-NONSPEC) | 7 |
| L1 LINK 선적재 (별도·인간 승인) | 3 |
| **BLOCKED options** (차원행 미링크/미존재 + L1 LINK 의존) | **11** → `blocked-and-gaps.md` |
| GAP (ddl-proposer) | 4 (GAP-PARAM·GAP-ADDON-STAND·GAP-BUNDLE-LINK·GAP-RIBBON) |

> BLOCKED 9→11: 139 재단만(PROC_000084 LINK 의존)·끈추가(MAT_000070+PROC_000081 LINK 의존) 추가. 124/133/134/135 복합끈과 **동일 처리(L1 차원 LINK 선적재=인간 승인)** 로 일관성 확보.

## 6. 검증 핸드오프 (dbm-validator)

- `attribute-entity-map.md §2 패밀리③` ↔ 13상품 옵션 매핑 verdict 누락0
- option_items 24행(L2 순수) ↔ 라이브 차원행 (ref_dim_cd, ref_key1[, ref_key2]) resolve (트리거 정확 일치)
- apply.sql(L2 순수)이 L1 차원행(product-materials/processes) 미생성 — `_l1_link_preload.sql` 분리 정합
- 멱등 2회차 byte-identical 재실행 (gen_load_sql.py 결정적)
- BLOCKED 9 정직성 (라이브 실부재 기반·발명0)

> [HARD] NEVER COMMIT. 본 산출은 DRY-RUN 실증 전용. 실 적재·BLOCKED 해소(거치대 상품/BUNDLE 링크 선적재)·constraint_json compile = 인간 승인.
