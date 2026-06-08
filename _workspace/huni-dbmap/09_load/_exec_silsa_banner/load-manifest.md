# 적재 매니페스트 — 일반현수막(PRD_000138) round-5 적재 실행본

| 항목 | 값 |
|------|----|
| 트랙 | round-5 적재 실행본 (silsa banner, PRD_000138) |
| 생성 | dbm-load-builder (dbm-load-execution 스킬) |
| 일자 | 2026-06-08 |
| 산출 루트 | `09_load/_exec_silsa_banner/` |
| 입력 권위 | `02_mapping/silsa-price-engine/`(A 가격 GO·**변경 없음**) · **`10_configurator/silsa-option-layer-v2.md`(B 옵션 v2 — 자재+공정 BUNDLE)** + `load_silsa_v2/*.csv` · `10_configurator/silsa-price-table-gap.md`(B26 권위) · `02_mapping/silsa-poster-area-matrix/mapping.md`(면적 평면화) |
| 라이브 스키마 권위 | read-only psql 직접 조회(2026-06-08) — PK/UNIQUE/트리거/FK/IDENTITY/코드값. **[v2] t_mat_materials·t_prd_product_materials 자재 차원 추가 조회** |
| 적재 정책 | **DB COMMIT·DDL적용·자재 mint·코드행등록 = 인간 승인.** 본 산출 = 멱등 실행본 + 롤백전용 DRY-RUN 까지만 |
| v2 갱신 범위 | **옵션 부분만(06~09 + `_blocked/` 자재 BUNDLE 추가).** 가격(01~05)·siz BLOCKED(B01/B02)·열재단 PROC 제안 = **변경 없음** |

> 생성·검증 분리(R6): 본 매니페스트는 **빌더 산출**. R1~R6 게이트는 dbm-validator 가 독립 수행한다. 빌더는 자기승인하지 않는다.

---

## 0. 한 줄 요약

일반현수막 가격엔진(per-product 합산형 PRF_BANNER_NORMAL) + **[v2] CPQ 옵션 레이어(자재+공정 BUNDLE)**를 **멱등 INSERT(ON CONFLICT / 변형 C) + 단일 트랜잭션 + FK 위상정렬**로 실행본화. **주 트랜잭션 INSERTABLE 58행**(가격 36 + 옵션 22 = groups 2·options 11·**옵션아이템 공정 seq 9**, 라이브 DRY-RUN 2-pass 멱등·제약위반0 실증), **BLOCKED 186행**(siz 77·area-cell 77·**[v2] 자재 mint 4·자재링크 6·자재 seq item 8**·열재단 = 인간 승인 선행) 분리, DDL 제안 1건(열재단 PROC_000084) + 자재 mint 제안 4건. **[v2 변경: 옵션 부분만]** v1 공정-only/셋트(.07) → v2 자재(.03)+공정(.04) BUNDLE. 가격(01~05)·siz BLOCKED·열재단 = 불변.

---

## 1. 적재 순서 (FK 위상정렬) — 주 트랜잭션 (`apply.sql`)

부모→자식. 각 단계의 위치를 고정하는 FK 엣지와 행수·멱등 방식 명시.

| step | 대상 t_* 테이블 | 입력 CSV | 행수 | 멱등 방식 (충돌키) | 위치 고정 FK 엣지 | 판정 |
|:--:|---|---|:--:|---|---|:--:|
| 00 | (마커 only) | — | 0 | — | 열재단 DDL·siz·각목 = 인간 승인 마커 | — |
| 01 | `t_prc_price_formulas` | `t_prc_price_formulas.csv` | 1 | ON CONFLICT (frm_cd) DO NOTHING | frm_typ_cd→t_cod_base_codes(FRM_TYPE.01 선존재) | INSERTABLE |
| 02 | `t_prc_price_components` | `t_prc_price_components.csv` | 10 | ON CONFLICT (comp_cd) DO NOTHING | comp_typ_cd→t_cod_base_codes(.04/.06 선존재) | INSERTABLE |
| 03 | `t_prc_formula_components` | `t_prc_formula_components.csv` | 11 | ON CONFLICT (frm_cd,comp_cd) DO NOTHING | frm_cd→01, comp_cd→02 + COMP_POSTER_BANNER_NORMAL(선존재) | INSERTABLE |
| 04 | `t_prc_component_prices` | `..._INSERTABLE.csv` | 13 | **변형 C** WHERE NOT EXISTS (자연키 8, NULL-safe) + setval | comp_cd→02/선존재, siz_cd→t_siz_sizes(3 선존재) | INSERTABLE |
| 05 | `t_prd_product_price_formulas` | `t_prd_product_price_formulas.csv` | 1 | ON CONFLICT (prd_cd,frm_cd) DO NOTHING | prd_cd→t_prd_products(선존재), frm_cd→01 | INSERTABLE |
| 06 | `t_prd_product_option_groups` | `t_prd_product_option_groups.csv` | 2 | ON CONFLICT (prd_cd,opt_grp_cd) DO NOTHING | prd_cd→t_prd_products, sel_typ_cd→cod(SEL_TYPE.01) | INSERTABLE |
| 07 | `t_prd_product_options` | `t_prd_product_options.csv` | 11 | ON CONFLICT (prd_cd,opt_cd) DO NOTHING | opt_grp_cd→06 | INSERTABLE |
| 08 | `t_prd_product_option_items` | `t_prd_product_option_items.csv` | 9 | ON CONFLICT (prd_cd,opt_cd,item_seq) DO NOTHING | opt_cd→07 **+ 트리거** fn_chk_opt_item_ref(**[v2] 공정 seq .04**→t_prd_product_processes 079/080/081 선존재) | INSERTABLE |
| 09 | `t_prd_product_constraints` | (없음) | 0 | — | **[v2] R-GAKMOK var=mat_cd**=GAP-DEFER(차원 선행) | GAP |
| | **주 트랜잭션 합계** | | **58** | | | |

> **[v2 자재+공정 BUNDLE]** step 08 INSERTABLE 9 = **공정 seq(.04)** 만(타공079×3 item_seq=1 bare-hole·부착081×4·봉제080×1). 각 옵션의 **자재 seq(.03)**(끈·양면테입·큐방·각목·봉제사)는 PRD_000138 자재 링크 부재로 트리거 REJECT → `_blocked/`(자재 링크/mint 후 활성화). v1(공정-only/셋트.07) → v2(자재.03+공정.04 BUNDLE) 전환으로 옵션아이템 9 INSERTABLE 동수·자재 seq 8 BLOCKED 노출.

> **충돌키 = 라이브 제약에서 읽음(추측 금지).** step 04 `t_prc_component_prices` 는 surrogate IDENTITY PK(`comp_price_id`) + 자연키 UNIQUE 인덱스 `ux_t_prc_comp_prices_nat_key`(8컬럼, **NULLS DISTINCT** = `indnullsnotdistinct=f`). 옵션 flat 행(siz/clr/mat/coat/bdl/min 전부 NULL)은 NULL 끼리 distinct 취급 → `ON CONFLICT` 미발화 → 2회차 중복. **∴ 변형 C(WHERE NOT EXISTS + IS NOT DISTINCT FROM)** 로 NULL-safe 멱등. (이 사실은 R4/검증에 surface — 자연키 UNIQUE 가 NULLS NOT DISTINCT 였다면 `ON CONFLICT` 가능했을 GAP.)

---

## 2. 적재 순서 — BLOCKED 활성화 트랜잭션 (인간 승인 선행)

**기본 `apply.sql` 경로 밖.** 인간 승인 후 별도 실행. 두 활성화 경로:
- **가격/siz**(`_blocked/apply_blocked.sql`): siz 등록 → area-cell 활성화.
- **[v2] 자재 BUNDLE**(`_blocked/apply_blocked_options.sql`): 자재 mint → 자재 링크 → 자재 seq option_items 활성화.

### 2.1 가격/siz 활성화 (`apply_blocked.sql`)

| step | 대상 t_* 테이블 | 입력 CSV | 행수 | 멱등 방식 | 위치 고정 FK 엣지 | 선행 조건 |
|:--:|---|---|:--:|---|---|---|
| B01 | `t_siz_sizes` | `t_siz_sizes_BLOCKED.csv` | 77 | ON CONFLICT (siz_cd) DO NOTHING | (마스터 — 부모 없음) | 후니 siz 등록 인간 승인 |
| B02 | `t_prc_component_prices` | `t_prc_component_prices_BLOCKED.csv` | 77 | 변형 C(NULL-safe) | siz_cd→B01(등록 후) | B01 선행 |

> **실증:** B02 를 siz 등록 **없이** 실행하면 `fk_prc_comp_prices_siz_cd` FK 위반(SIZ_000554 부재). B01→B02 순서 통과(new_siz 77, banner area total 80), delta 0(멱등). 롤백 → 0 커밋.

### 2.2 [v2] 자재 seq BUNDLE 활성화 (`apply_blocked_options.sql`)

| step | 대상 t_* 테이블 | 입력 | 행수 | 멱등 방식 | 위치 고정 FK 엣지 | 선행 조건 |
|:--:|---|---|:--:|---|---|---|
| B03a | `t_mat_materials` | (mint 제안) | 4 (제안·주석) | ON CONFLICT (mat_cd) DO NOTHING | (마스터) | 큐방·각목LE·각목GT·봉제사 mint 인간 채번 |
| B03b | `t_prd_product_materials` | BLOCKED CSV distinct | 6 (live 2 + mint 4 주석) | ON CONFLICT (prd_cd,mat_cd,usage_cd) DO NOTHING | mat_cd→B03a/master, prd_cd→products, usage_cd→cod | 끈/양면테입=즉시·mint분=채번 후 |
| B04 | `t_prd_product_option_items` | `..._BLOCKED.csv` (.03) | 8 (live 4 + mint 4 주석) | ON CONFLICT (prd_cd,opt_cd,item_seq) DO NOTHING | **opt_cd→07(옵션헤더 선행)** + 트리거 .03→B03b(자재 링크 EXISTS) | B03b 선행 + 옵션헤더(06/07) |

> **실증(라이브 DRY-RUN):** ① 자재 seq 를 자재 링크 **없이** INSERT → 트리거 `자재 mat_cd=MAT_000070/usage_cd=USAGE.07 가 상품 PRD_000138에 없음` REJECT(BLOCKED 실재). ② B03b(끈 MAT_000070·양면테입 MAT_000069 링크)→B04(자재 seq) 통과·delta 0(멱등). ③ **FULL BUNDLE 실증**: 주 적재(08 공정 seq) + 자재 활성화(B04) 합치면 끈/양면테입/봉미싱 옵션이 **자재 seq(.03) + 공정 seq(.04) 둘 다 성립**(끈=MAT_000070 seq1 + PROC_000081 seq2). 롤백 → 0 커밋.
> **[의존]** B04 자재 seq item 은 FK `fk_prd_opt_items_opt` → 옵션헤더 필요 → 주 `apply.sql`(06/07) 커밋 선행. `apply_blocked_options.sql` 은 자체완결 DRY-RUN 위해 06/07 멱등 선포함(운영 시 no-op).
> **[mint 분 주석]** 큐방·각목(LE/GT)·봉제사 자재는 master 부재(라이브 재증명) → mat_cd 미채번이라 B03a/B03b/B04 에서 **주석 처리**(실행 SQL 아님). 후니 채번 후 placeholder 치환·활성화.

---

## 3. INSERTABLE / BLOCKED / GAP 집계

| 테이블 | INSERTABLE(주 트랜잭션) | BLOCKED(인간 승인 선행) | GAP |
|---|:--:|:--:|:--:|
| t_prc_price_formulas | 1 | 0 | 0 |
| t_prc_price_components | 10 | 0 | 0 |
| t_prc_formula_components | 11 | 0 | 0 |
| t_prc_component_prices | 13 (area 3 + opt 10) | 77 (area, siz 미등록) | 0 |
| t_prd_product_price_formulas | 1 | 0 | 0 |
| t_siz_sizes | 0 | 77 (신규 master-data) | 0 |
| t_mat_materials | 0 | **4** [v2] (큐방·각목LE·각목GT·봉제사 mint 제안) | 0 |
| t_prd_product_materials | 0 | **6** [v2] (자재링크 live 2 + mint 4) | 0 |
| t_prd_product_option_groups | 2 | 0 | 0 |
| t_prd_product_options | 11 | 0 | 0 |
| t_prd_product_option_items | 9 (**[v2] 공정 seq**) | **9** ([v2] 자재 seq .03 8 + 열재단 .04 1) | 0 |
| t_prd_product_constraints | 0 | 0 | 1 (R-GAKMOK GAP-DEFER, **var=mat_cd**) |
| **합계** | **58** | **186** | **1** |

> **[v2 변경]** 옵션아이템 BLOCKED 3→9(자재 seq 8 + 열재단 1) — v1이 자재 의미를 누락(공정-only/셋트)해 BLOCKED 과소계상한 것을 v2가 자재 seq(.03)를 드러내며 정직하게 노출(결함 아님). 신규 자재 BLOCKED: t_mat_materials mint 4 + t_prd_product_materials link 6. **BLOCKED 합계 157→186**(자재 seq 6 + mint 4 + link 6 + 열재단·각목 재분류). BLOCKED 사유·해소 조건은 `blocked-and-gaps.md`. 열재단 DDL 제안은 `11_ddl_proposals/heat-cut-process-proposal.sql`(재사용, 재발명 금지).
>
> **자재 BLOCKED 세분(v2):** **BLOCKED-LINK only** = 끈 MAT_000070·양면테입 MAT_000069 (master 실재·링크만 선적재, mint 불요) · **BLOCKED-MINT+LINK** = 큐방·각목(LE/GT)·봉제사(실) (master 부재·mint+링크, [CONFIRM-CHANNEL] mat_cd 인간 채번) · **BLOCKED-MINT** = 열재단 PROC_000084 (공정 신설).

---

## 4. 산출 파일 인덱스

| 파일 | 내용 |
|------|------|
| `gen_load_sql.py` | CSV→멱등 SQL 생성기(재현성 R3·G8, 손편집 금지) |
| `apply.sql` | 주 트랜잭션 래퍼(\i 00~09, BEGIN…; ROLLBACK/COMMIT 로더 주입) |
| `apply.sh` | psql 로더(기본 dryrun=ROLLBACK, `commit` 인간 승인 플래그). 비밀번호 echo 금지 |
| `00_preload_markers.sql` ~ `09_t_prd_product_constraints.sql` | per-step 멱등 SQL(INSERTABLE). 08=**[v2] 공정 seq** |
| `_blocked/B01_t_siz_sizes.sql`·`B02_t_prc_component_prices.sql`·`apply_blocked.sql` | BLOCKED 활성화(siz 등록 후, 인간 승인) |
| `_blocked/B03a_t_mat_materials_MINT.sql`·`B03b_t_prd_product_materials_LINK.sql`·`B04_t_prd_product_option_items_MAT.sql`·`apply_blocked_options.sql` | **[v2]** 자재 seq BUNDLE 활성화(자재 mint→링크→자재 seq item, 인간 승인) |
| `load/*.csv` | 입력 GO 적재본 CSV(가격엔진 + **[v2] load_silsa_v2 옵션 레이어**, 재현성용 사본) |
| `load.provenance.csv` | 각 INSERT VALUES → source CSV/ref 추적(검증 역대조용) |
| `dryrun-log.md` | 라이브 롤백전용 DRY-RUN 2-pass 결과(R1/R2/R3/R5 증거) |
| `load-manifest.md`(본 문서) · `blocked-and-gaps.md` · `README.md` | 매니페스트·차단/GAP·실행법 |

---

## 5. 검증 핸드오프 (dbm-validator)

- R1 멱등성: `dryrun-log.md` 2-pass delta=0(주 트랜잭션 8테이블 + **[v2] 자재 BUNDLE 활성화**) — 검증 재확인 요청.
- R2 원자성: 단일 BEGIN…ROLLBACK, 중간 COMMIT 0 — `apply.sql`·`apply_blocked_options.sql` 구조 확인.
- R3 실행성: 전 .sql 파싱·실행 0오류(exit 0) — 재실행 확인.
- R4 DDL 정합: 열재단 PROC_000084 제안(`11_ddl_proposals/heat-cut-process-proposal`) search-before-mint·충돌0 — R4 판정 요청. **+ [v2] 자재 mint 4건**(큐방·각목LE/GT·봉제사, master 부재 라이브 재증명·MAT_TYPE.07) search-before-mint 판정 요청. **+ t_prc_component_prices 자연키 UNIQUE 가 NULLS DISTINCT 인 점**(ON CONFLICT 불가 → 변형 C) surface.
- R5 라이브 DRY-RUN: 제약위반 0(FK/NOT NULL/CHECK/트리거) — **[v2] 자재 seq REJECT(링크 부재)·BUNDLE 성립(링크 후) 실증** 재확인.
- R6 독립 검증: 빌더(본)≠검증(validator). 본 매니페스트 자기승인 아님. **[v2] 빌더가 자체 발견한 실결함 1건**(B04 자재 seq 옵션헤더 FK 의존 → `apply_blocked_options.sql` 에 06/07 선포함으로 해소) 기록.
