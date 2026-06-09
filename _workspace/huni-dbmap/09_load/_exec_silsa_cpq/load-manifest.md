# 적재 매니페스트 — 일반현수막(PRD_000138) CPQ 옵션레이어 v2 + 마스터 mint

> 패키지 `09_load/_exec_silsa_cpq/` · round-6 CPQ 옵션레이어 → 적재 실행본(round-5 방법론).
> 권위: **옵션 STRUCTURE** = `10_configurator/silsa-option-layer-v2.md` · **코드 규약** = `00_schema/code-identifier-strategy.md`(2026-06-09 사용자 비준).
> 기준: 라이브 read-only 실측(2026-06-09). **NEVER COMMIT** — 로더 기본 ROLLBACK. mint=master-data INSERT(DDL 아님).
> 검증/GO는 `dbm-validator`(별도) 소관 — 본 문서는 빌드 산출이며 자가 GO 선언 아님.

## 1. 무엇이 바뀌었나 (prior `_exec_silsa_banner` 대비)

| 변경축 | prior(`_exec_silsa_banner`) | 본 패키지(`_exec_silsa_cpq`) | 사유 |
|---|---|---|---|
| 코드 규약 | 시맨틱(OG-GAGONG·OP-CHUGA-*) + 하이픈 CPQ | **`_` 순차 surrogate**(OPT_/OPV_) + 라이브 MAX+1 | code-identifier-strategy D1/D3/D4 비준 |
| 멱등 기제 | `ON CONFLICT (자연키) DO NOTHING` | **이름기반 `WHERE NOT EXISTS`** | surrogate 코드가 매 생성마다 달라 충돌키 불가 → 이름키(D2) |
| 마스터 mint | BLOCKED(자재/공정 미적재) | **자재 4 + 공정 1 mint + 링크 7** | 사용자 "GO분 + BLOCKED master-data 결정·적재" 승인 |
| option_items | INSERTABLE 9(공정만)·BLOCKED 9 | **INSERTABLE 18**(자재.03 8 + 공정.04 10) | mint+링크 선행으로 자재 seq·열재단이 같은 트랜잭션서 승격 |

## 2. 적재 순서 (FK 위상정렬) + 단계별 행수

단일 트랜잭션(`apply.sql`, `BEGIN … ON_ERROR_STOP on … ROLLBACK`). 부모→자식.

| # | 파일 | 대상 t_* 테이블 | INSERTABLE | FK/트리거 근거 (위치 고정 사유) |
|:--:|---|---|:--:|---|
| 00 | `00_preload_markers.sql` | (없음) | 0 | 적용 결정 마커 — INSERT 없음 |
| 01 | `01_t_mat_materials.sql` | t_mat_materials | **4** | 마스터(무부모). 자재 링크(03)·옵션아이템(07)의 부모 |
| 02 | `02_t_proc_processes.sql` | t_proc_processes | **1** | 마스터(무부모). 공정 링크(04)·옵션아이템(07)의 부모 |
| 03 | `03_t_prd_product_materials.sql` | t_prd_product_materials | **6** | FK→t_mat_materials. 트리거 `fn_chk_opt_item_ref(.03)`가 (prd_cd,mat_cd,usage_cd) 요구 → 07 선행조건 |
| 04 | `04_t_prd_product_processes.sql` | t_prd_product_processes | **1** | FK→t_proc_processes. 트리거 `.04`가 (prd_cd,proc_cd) 요구 → 07 선행조건. 열재단만(079/080/081 기 링크) |
| 05 | `05_t_prd_product_option_groups.sql` | t_prd_product_option_groups | **2** | FK→t_prd_products. 옵션(06)의 부모(opt_grp_cd) |
| 06 | `06_t_prd_product_options.sql` | t_prd_product_options | **11** | FK→option_groups(opt_grp_cd). 옵션아이템(07)의 부모(opt_cd) |
| 07 | `07_t_prd_product_option_items.sql` | t_prd_product_option_items | **18** | FK→options. 트리거 `fn_chk_opt_item_ref` 행단위 차원행 EXISTS(자재 03·공정 04 선행) |
| 08 | `08_t_prd_product_constraints.sql` | t_prd_product_constraints | **0** | R-GAKMOK = DEFER(siz 76규격 미등록·F-1) → `_blocked/08` |
| | | **합계** | **43** | (mint 5 + 링크 7 + 그룹 2 + 옵션 11 + 아이템 18) |

> 사이클·미해소 부모 없음. 라이브 DRY-RUN(아래 §5)에서 전 단계 무위반 실증.

## 3. mint 코드 부여표 (라이브 MAX(suffix)+1 · `_` 포맷)

라이브 실측 2026-06-09: `MAX(mat_cd)=MAT_000336` · `MAX(proc_cd)=PROC_000083` · `MAX(opt_grp_cd)=OPT-000002` · `MAX(opt_cd)=OPV-000005`.

### 마스터 mint (자재·공정)
| 코드 | 이름 | 타입 | use_yn | 멱등 가드(이름키) | search-before-mint |
|---|---|---|:--:|---|---|
| `MAT_000337` | 큐방 | MAT_TYPE.07(부속) | Y | (mat_nm='큐방', MAT_TYPE.07, del_yn=N) | live 0행 재확인(부재) → mint 정당 |
| `MAT_000338` | 각목(900이하) | MAT_TYPE.07 | Y | (mat_nm='각목(900이하)') | live 0행 |
| `MAT_000339` | 각목(900초과) | MAT_TYPE.07 | Y | (mat_nm='각목(900초과)') | live 0행 |
| `MAT_000340` | 봉제사 | MAT_TYPE.07 | Y | (mat_nm='봉제사') | live 0행 (실=자재 D②) |
| `PROC_000084` | 열재단 | (공정·flat) | Y | (proc_nm='열재단') | live 0행 → mint(M-1 ①·완칼 차용 폐기) |

### CPQ 코드 부여
| 코드 | 이름 | 비고 |
|---|---|---|
| `OPT_000003` | 가공 | opt_grp · sel_typ=SEL_TYPE.01 택1 필수 |
| `OPT_000004` | 추가 | opt_grp · sel_typ=SEL_TYPE.01 택1 선택(min0) |
| `OPV_000006`~`OPV_000016` | 열재단·타공4/6/8·양면테입·봉미싱 · 추가없음·큐방·끈·각목LE·각목GT | options 11행 |

> **링크(기존 자재) — mint 아님:** 끈 `MAT_000070`·양면테입 `MAT_000069` = 라이브 EXISTS(del_yn=N) 재확인 → LINK only. 공정 079 타공·080 봉제·081 부착 = 라이브 EXISTS + PRD_000138 링크 기존재(재적재 안 함).

## 4. 멱등 기제 요약 (테이블별 가드 — 이름기반 NOT EXISTS)

[HARD] surrogate 코드는 SQL 리터럴(라이브 MAX+1)로 부여하되, **존재검사는 코드가 아닌 이름/자연키**로 한다 → 2회차 delta 0, 코드 재발급 없음.

| 테이블 | 멱등 가드(business-name key) | 코드/FK resolve 방식 |
|---|---|---|
| t_mat_materials | `mat_nm + mat_typ_cd + del_yn='N'` | 코드=리터럴 MAX+1 |
| t_proc_processes | `proc_nm + del_yn='N'` | 코드=리터럴 |
| t_prd_product_materials | `(prd_cd, mat_cd, usage_cd)` 자연키 | mint 자재 mat_cd = **이름→코드 서브쿼리**(재실행 안전) |
| t_prd_product_processes | `(prd_cd, proc_cd)` 자연키 | 열재단 proc_cd = 이름→코드 서브쿼리 |
| t_prd_product_option_groups | `(prd_cd, opt_grp_nm, del_yn='N')` | 코드=리터럴 |
| t_prd_product_options | `(prd_cd, opt_grp_cd, opt_nm, del_yn='N')` | opt_grp_cd = **그룹 이름→코드 서브쿼리** |
| t_prd_product_option_items | `(prd_cd, opt_cd, item_seq)` 자연키 | opt_cd=opt_nm 서브쿼리 · mat_cd/proc_cd=이름 서브쿼리 |

> 재실행 시 부모(자재/공정/그룹)가 이미 적재돼 있어도 이름 서브쿼리가 그 코드를 *재해결*하므로 자식 FK가 끊기지 않는다. 코드를 새로 발급하지 않는다(P3 멱등 해소).

## 5. 라이브 DRY-RUN 자가검증 결과 (롤백전용·2026-06-09)

> 리드 승인 read 패턴(롤백전용 write 트랜잭션) 1회 자가 self-test. **COMMIT 0** (전부 ROLLBACK). GO 판정 아님 — validator 소관.

- **Pass 1 (executability·제약위반):** 00~08 단일 트랜잭션 실행 → 마스터 mint 5 + 링크 7 + 그룹 2 + 옵션 11 + 아이템 18 = **43행 전부 `INSERT 0 1`** (제약·트리거 위반 0). 트리거 `fn_chk_opt_item_ref`가 자재(.03 8)·공정(.04 10) 18행 전건 통과 → 같은 트랜잭션 내 03/04 선적재가 선행조건 충족 실증. ROLLBACK.
- **Pass 2 (멱등성 R1):** 동일 스크립트 재실행 → **전 INSERT `INSERT 0 0`**(delta 0). 누적 카운트 pass1=pass2 (mat 4·proc 1·matlink 6·proclink 1·grp 2·opt 11·items 18). 코드 재발급 없음. ROLLBACK.
- **원자성(R2):** `apply.sql` 단일 `BEGIN…`(중간 COMMIT 없음) + `ON_ERROR_STOP on` + 로더가 ROLLBACK/COMMIT 주입.

## 6. 적용된 설계 결정

- **D-2(각목 2규격):** 별 `mat_cd` 2개(MAT_000338 각목900이하 / MAT_000339 각목900초과). 사유 = `ref_param_json` 부재(GAP-PARAM·D4 no-DDL) → 단일 mat_cd+param 보존처 없음 → 2 mat_cd 모델 채택.
- **D①** 타공=bare-hole(process-only) · **D②** 봉미싱 실=자재(봉제사 mint) · **D③** 각목=신규 mint(우드봉 배제).
- **D1~D5(코드 규약):** 순차 surrogate PK·이름기반 멱등·`_` 통일·라이브 MAX+1 리터럴·rule_cd 상품별 RULE_001.

## 7. BLOCKED / GAP (상세 `blocked-and-gaps.md`)

- **R-GAKMOK constraint(RULE_001)** — DEFER. 각목 mat_cd는 본 mint로 충족되나 `logic` jsonb 의 세로변 `siz_cd` 멤버십 집합이 siz 76규격 미등록(가격트랙)으로 미완. + 폼빌더 배열-멤버십 입력방식(F-1) 미검증. → `_blocked/08`.
- **[CONFIRM] 부착 enum 큐방** — `PROC_000081 {대상}` enum에 `큐방` 부재(라이브). 큐방 자재(MAT_000337) mint·링크·옵션아이템은 적재되나, 공정 param `대상` 라벨 의미는 enum 확장 인간 결정 잔존(적재 차단 아님 — note 보존).
- **[CONFIRM] 양면테입→테입 enum** — 자재 MAT_000069 직결은 명확하나 공정 param `{대상:테입}` 해석(enum에 `양면테입` 추가 vs `테입` 환원) 잔존. 적재 차단 아님.
- **GAP-PARAM(D-1)** — 타공 구수(4/6/8)·각목 규격 라벨 보존처(`ref_param_json`) 부재. 본 적재는 별 옵션(타공4/6/8)·별 mat_cd(각목)로 우회 표현. 의미 라벨 보존은 ddl-proposer 트랙.
