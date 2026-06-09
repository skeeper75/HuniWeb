# 적재 매니페스트 — 프리미엄엽서(PRD_000016) CPQ 옵션레이어 + 봉투 template/addon + constraints

> 패키지 `09_load/_exec_postcard_cpq/` · round-6 CPQ 옵션레이어 → 적재 실행본(round-5 방법론).
> **권위(STRUCTURE)** = `10_configurator/postcard-option-layer.md` + `load/*.csv`(옵션 STRUCTURE만 권위).
> **권위(코드 규약)** = `00_schema/code-identifier-strategy.md`(2026-06-09 사용자 비준 D1~D5).
> 기준: 라이브 read-only 실측(2026-06-09). **NEVER COMMIT** — 로더 기본 ROLLBACK. mint=master-data INSERT(DDL 아님).
> 검증/GO는 `dbm-validator`(별도) 소관 — 본 문서는 빌드 산출이며 자가 GO 선언 아님.
> **본 패키지 = 가족 최초 TEMPLATE + 최초 CONSTRAINT 적재** (silsa CPQ 는 옵션/마스터만, 템플릿/제약 미적재였음).

## 0. 설계(STRUCTURE) 대비 정련 — 코드 RE-CODE + search-before-mint

본 적재가 설계 초안(`postcard-option-layer.md`·`load/*.csv`)에 가한 **적재 임계 정련 2건**(STRUCTURE 불변·코드/멱등/실재성만 변경):

| # | 설계 초안 | 본 패키지(라이브 정합) | 근거 |
|---|---|---|---|
| **C1** | 시맨틱 코드 `OG-DOSU`·`OP-DOSU-SINGLE`·`TMPL-ENV-*`·`R-HUGA-*` | **`_` 순차 surrogate** 전부 재코드(라이브 MAX+1) | code-identifier-strategy D1/D3/D4(시맨틱 코드 DEPRECATED) |
| **C2** | 봉투 3 신규 템플릿 `TMPL-ENV-*` 생성 | **2종 라이브 실재 reuse**(TMPL-000005 접착·TMPL-000006 비접착) + **1종만 신규 mint**(TMPL_000010 카드화이트) | search-before-mint(라이브 실측 — 접착/비접착 템플릿·selection 기실재, PRD_000016 addon→TMPL-000005 기실재) |

> 멱등 기제 = **이름/자연키 기반 `WHERE NOT EXISTS` / `IS DISTINCT FROM`**(surrogate 코드가 매 생성마다 달라 충돌키 불가 → D2 이름키). 코드는 라이브 MAX+1 리터럴, 존재검사는 이름·자연키.

## 1. 코드 부여표 (라이브 MAX(suffix)+1 · `_` 통일)

라이브 실측 2026-06-09: `MAX(opt_grp_cd)=OPT_000004` · `MAX(opt_cd)=OPV_000016` · `MAX(tmpl_cd)=TMPL-000009`(하이픈·삭제·테스트분 다수).

### option_groups (OPT_000005~OPT_000009)
| 코드 | 이름 | 설계 코드(DEPRECATED) | sel_typ | min/max | mand |
|---|---|---|---|:--:|:--:|
| `OPT_000005` | 인쇄(도수) | OG-DOSU | SEL_TYPE.01 | 1/1 | Y |
| `OPT_000006` | 종이 | OG-JONGI | SEL_TYPE.01 | 1/1 | Y (하위 item BLOCKED) |
| `OPT_000007` | 모서리 | OG-MOSEORI | SEL_TYPE.01 | 0/1 | N |
| `OPT_000008` | 후가공 | OG-HUGAGONG | **SEL_TYPE.02** | **0/4** | N (하위 item BLOCKED) |
| `OPT_000009` | 추가상품(봉투) | OG-CHUGA | SEL_TYPE.01 | 0/1 | N |

### options (OPV_000017~OPV_000029 · 13행)
| 코드범위 | 그룹 | 옵션 |
|---|---|---|
| `OPV_000017`~`OPV_000018` | 인쇄(도수) | 단면(dflt)·양면 |
| `OPV_000019` | 종이 | 별도설정(dflt·하위 item BLOCKED) |
| `OPV_000020`~`OPV_000021` | 모서리 | 직각(dflt)·둥근 |
| `OPV_000022`~`OPV_000025` | 후가공 | 오시·미싱·가변텍스트·가변이미지(전부 하위 item BLOCKED) |
| `OPV_000026`~`OPV_000029` | 추가상품(봉투) | 봉투없음(dflt 센티넬)·OPP접착·OPP비접착·카드화이트 |

### templates / constraints
| 엔티티 | 코드 | 설계 코드 | 비고 |
|---|---|---|---|
| template(카드화이트) | `TMPL_000010` | TMPL-ENV-CARD-WHITE | **신규 mint**(base PRD_000004·`_` 통일). 접착/비접착은 라이브 reuse(코드 신규 아님) |
| constraints | `RULE_001`~`RULE_003` | R-HUGA-MAXN/R-HUGA-PARAM/R-QTY-PANSU | 상품별 카운터(D5·복합 PK 충돌 없음) |

## 2. 적재 순서 (FK 위상정렬) + 단계별 INSERTABLE 행수

단일 트랜잭션(`apply.sql`, `BEGIN … ON_ERROR_STOP on … ROLLBACK`). 부모→자식.

| # | 파일 | 대상 t_* 테이블 | INSERTABLE | FK/트리거 근거 (위치 고정 사유) |
|:--:|---|---|:--:|---|
| 00 | `00_preload_markers.sql` | (없음) | 0 | 적용 결정 마커 — INSERT 없음 |
| 05 | `05_t_prd_product_option_groups.sql` | t_prd_product_option_groups | **5** | FK→t_prd_products. 옵션(06)의 부모(opt_grp_cd). 트리거 없음 |
| 06 | `06_t_prd_product_options.sql` | t_prd_product_options | **13** | FK→option_groups(opt_grp_cd). 옵션아이템(07)의 부모(opt_cd). 트리거 없음 |
| 07 | `07_t_prd_product_option_items.sql` | t_prd_product_option_items | **4** | FK→options. 트리거 `fn_chk_opt_item_ref` 행단위: .06→print_options(opt_id 1/2 실재)·.04→processes(027/028 실재) |
| 08 | `08_t_prd_templates.sql` | t_prd_templates | **1** | 무부모(base_prd_cd→products). selections(09)·addons(10)의 부모(tmpl_cd). 카드화이트만 mint(접착/비접착 reuse) |
| 09 | `09_t_prd_template_selections.sql` | t_prd_template_selections | **1** | FK→templates(tmpl_cd). 카드화이트 freeze SIZ_000104(base PRD_000004 실재) |
| 10 | `10_t_prd_product_addons.sql` | t_prd_product_addons | **2** | FK→products·templates. PRD_000016→TMPL-000005 1행 기실재(멱등 흡수)→ delta 2(TMPL-000006·TMPL_000010) |
| 11 | `11_t_prd_product_constraints.sql` | t_prd_product_constraints | **3** | FK→products·rule_typ_cd→cod. logic jsonb NOT NULL(JSONLogic) |
| 12 | `12_t_prd_products_constraint_json.sql` | t_prd_products (UPDATE) | **1** | compile 캐시(AND of 3 rule). 멱등 IS DISTINCT FROM |
| | | **INSERT 합계** | **29** | + UPDATE 1 (groups 5 + options 13 + items 4 + tmpl 1 + sel 1 + addons 2 + constraints 3) |

> 사이클·미해소 부모 없음. addons step 의 INSERTABLE=2 는 라이브 기실재 1행을 멱등 가드가 흡수한 결과(DRY-RUN §5에서 `INSERT 0 0` 실증). 누적 addons=3.
> 라이브 DRY-RUN(§5)에서 전 단계 무위반 실증.

## 3. 멱등 기제 요약 (테이블별 가드 — 이름/자연키 기반)

[HARD] surrogate 코드는 SQL 리터럴(라이브 MAX+1)로 부여하되, **존재검사는 코드가 아닌 이름/자연키**로 한다 → 2회차 delta 0, 코드 재발급 없음. 부모 코드는 이름 서브쿼리로 resolve(재실행 시 그 코드 재해결).

| 테이블 | 멱등 가드(business-name/natural key) | 부모 코드 resolve |
|---|---|---|
| t_prd_product_option_groups | `(prd_cd, opt_grp_nm, del_yn='N')` | 코드=리터럴 |
| t_prd_product_options | `(prd_cd, opt_grp_cd, opt_nm, del_yn='N')` | opt_grp_cd = **그룹 이름→코드 서브쿼리** |
| t_prd_product_option_items | `(prd_cd, opt_cd, item_seq)` 자연키 | opt_cd = **opt_nm→코드 서브쿼리** |
| t_prd_templates | `(base_prd_cd, tmpl_nm, del_yn='N')` | 코드=리터럴(신규 카드화이트). 접착/비접착은 가드가 라이브 실재 흡수→미적재 |
| t_prd_template_selections | `(tmpl_cd, sel_seq)` 자연키 | tmpl_cd = **base+tmpl_nm→코드 서브쿼리**(mint 코드 재해결) |
| t_prd_product_addons | `(prd_cd, tmpl_cd)` 자연키 | tmpl_cd = base+tmpl_nm→코드 서브쿼리(접착/비접착=라이브 코드·카드=mint 코드 동일 경로) |
| t_prd_product_constraints | `(prd_cd, rule_nm, del_yn='N')` | 코드=리터럴 |
| t_prd_products.constraint_json | `constraint_json IS DISTINCT FROM 새 값` | UPDATE(동일하면 0행) |

## 4. 라이브 DRY-RUN 자가검증 결과 (롤백전용·2026-06-09)

> 리드 승인 read 패턴(롤백전용 write 트랜잭션) 자가 self-test. **COMMIT 0**(전부 ROLLBACK). GO 판정 아님 — validator 소관.

- **Pass 1 (executability·제약/트리거 위반):** `apply.sh dryrun` 00~12 단일 트랜잭션 → groups 5·options 13·items 4·tmpl 1·sel 1·addons(0+1+1)·constraints 3·constraint_json `UPDATE 1` = **INSERT 29 + UPDATE 1, 위반 0**. 트리거 `fn_chk_opt_item_ref` 가 도수(.06 print_option)·모서리(.04 processes) 4행 전건 통과. addons 첫 행 `INSERT 0 0`(TMPL-000005 기실재 멱등 흡수). ROLLBACK.
- **Pass 2 (멱등성 R1·단일 트랜잭션 내 2회 적용):** PASS1 직후 동일 8 스크립트 재적용 → **전 INSERT `INSERT 0 0` / UPDATE `UPDATE 0`**(delta 0). 누적 카운트(PRD_000016): opt_grps 5·options 13·opt_items 4·TMPL_000010 1·sel 1·addons 3·constraints 3 — 1회차와 동일(중복 0·코드 재발급 0). ROLLBACK.
- **원자성(R2):** `apply.sql` 단일 `BEGIN…`(중간 COMMIT 없음) + `ON_ERROR_STOP on` + 로더가 ROLLBACK/COMMIT 주입.

## 5. 적용된 설계 결정 (OTC / C 결정)

- **OTC §15 봉투=TEMPLATE:** 봉투는 option_item 아닌 `t_prd_templates`+`t_prd_template_selections`+`t_prd_product_addons` 바인딩으로 처리. ✓ 설계대로 + 라이브 실재 reuse 정련(C2).
- **OTC 별색=미인스턴스화:** 별색 그룹은 데이터 0행(L1 전 7행 공백) → 그룹 자체 미생성(발명 금지).
- **C1 코드 RE-CODE:** 설계 시맨틱 코드(OG-*/OP-*/TMPL-ENV-*/R-*) DEPRECATED → `_` 순차 surrogate(라이브 MAX+1).
- **C2 search-before-mint(템플릿):** OPP접착=TMPL-000005·OPP비접착=TMPL-000006 라이브 실재(del_yn=N) reuse. 카드화이트만 TMPL_000010 신규 mint(base PRD_000004·활성 템플릿 부재 — TMPL-000007 del_yn=Y).
- **R2 도수 ref_key1=opt_id::int(1/2):** clr_cd 아님(MISMATCH-1 정정·트리거 .06 dispatch).
- **R3 ref_param_json 부재:** 후가공 줄수/개수 미보존 → BLOCKED 행 + GAP-PARAM(qty smear 금지).
- **R4 templates price 부재·R5 rule_typ_cd 코드 FK:** 라이브 컬럼 정합 확인.

## 6. BLOCKED / GAP (상세 `blocked-and-gaps.md`)

- **option_items BLOCKED 5행**(`_blocked/07_*.sql`): 후가공 PROC_000029~032(차원 0행)·종이=*별도설정(material 0행) → 트리거 REJECT 예정 → 격리(적재 대상 아님).
- **[CONFIRM] 카드봉투 base_prd_cd**: 설계=PRD_000004(카드봉투)·SIZ_000104 / 라이브 소프트삭제 템플릿=PRD_000281(카드봉투 화이트). 본 적재는 설계 권위 PRD_000004 채택(SIZ_000104 base 실재 확인). PRD_000281(전용 화이트 상품)으로 정정할지는 인간 결정.
- **[CONFIRM] SIZ_000104 장수**: siz 명칭 "(10장)" vs selection qty=50 충돌(addon note 권위). 적재 차단 아님 — note 보존.
- **GAP-PARAM**: 후가공 줄수/개수·가변 개수 보존처(ref_param_json) 부재 → ddl-proposer 트랙.
- **GAP-B/GAP-C**: ★사이즈선택 동적 addon(본체연동 freeze)·note→siz_cd 마이그 규칙 = 설계 한계(MINOR).
