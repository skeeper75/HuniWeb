# CPQ Tier A 면적형 포스터·배너 13상품 옵션레이어(L2) — 적대적 교차검증 게이트

> 검증 2026-06-14 · `dbm-validator` (round-6 CPQ L2 게이트) · 생성자 = `dbm-option-mapper`(독립).
> 대상 설계 = `10_configurator/tierA/areaform-option-layer.md` · 실행본 = `09_load/_exec_tierA_areaform/`.
> 게이트 = 라이브 read-only 실측(`RAILWAY_DB_*`) + 롤백전용 DRY-RUN(apply.sh dryrun·_idempotency_test.sql) 직접 실행. **NEVER COMMIT — 영구변경 0 실증.**
> 권위 순서: Excel 명시값 > 추출 스냅샷 · 라이브 스키마+트리거 `fn_chk_opt_item_ref` > 설계문서 · `cpq-schema.md §4` (design↔live).

---

## 0. 최종 판정: **CONDITIONAL-GO**

옵션레이어 90건 INSERT는 트리거 통과·멱등·롤백 영구변경0으로 **적재 가능성 실증 완료**. 단 게이트 5의 **step 01 product LINK 선적재(139 끈 BUNDLE 부속 차원행 3건)는 L1 영역**이므로, L2 트랜잭션 안에 포함된 채로는 인간 승인 분리가 필요하다(아래 §G5 판정). 옵션레이어 87건(LINK 3건 제외)은 무조건 GO. LINK 3건 분리 후 90건 전량 GO.

| 게이트 | 결과 | 핵심 증거 |
|---|---|---|
| G1 트리거 reference resolution | **PASS** | 24/27 공정행 라이브 EXISTS · 139 부속 3건 ABSENT는 LINK 선행으로 충족(DRY-RUN REJECT 0) · 디스패치 슬롯 트리거 정의와 정확 일치 |
| G2 도수 OG 0 정합 | **PASS** | 13상품 print_option 0행 라이브 실측 · 122 화이트=PROC_000008 별색공정(.04) — 도수(.06) 아님 |
| G3 비규격 사이즈 처리 | **PASS** | 7상품 nonspec 범위 라이브와 정확 일치 · R-SIZE-NONSPEC JSONLogic well-formed · option_item 미열거 |
| G4 가공 택일 + GAP-PARAM 정직성 | **PASS** | 타공 4/6/8·봉제·족자 = 공정 1행 재사용 · GAP-PARAM 정직 격리 · qty smear 없음(qty=1/4는 개수 의미 정당) |
| G5 멱등성 + 139 LINK 보정 | **PASS(멱등) / FINDING(L1 경계)** | 2-pass delta 0(PASS1=90×INSERT 0 1·PASS2=90×INSERT 0 0) · ROLLBACK 영구변경0 · **단 step 01 LINK=L1 차원행 INSERT** |
| G6 BLOCKED/GAP 정직성 + FK 위상 | **PASS** | BLOCKED 9·GAP 4·[CONFIRM] 5 발명 없이 정직 격리 · FK 위상순(00→01→02→03→04→05) 정확 |

**뒤집힌 분류: 0건.** 생성자 보고의 INSERTABLE/BLOCKED/GAP 분류는 독립 재집계와 전건 일치.

---

## G1. 트리거 reference resolution — **PASS**

option_items 27 INSERTABLE의 `(ref_dim_cd, ref_key1[, ref_key2])`를 트리거 `fn_chk_opt_item_ref` 디스패치와 동일하게 라이브 독립 실측.

**G1a 공정행(.04) 라이브 EXISTS (21 쌍 실측):**
- 118/120/121/136/145 코팅 PROC_000014·000015 → 전건 EXISTS
- 122 PROC_000008 · 124/125/133/134 PROC_000080 · 135 PROC_000082 · 136/137/139 PROC_000079 → 전건 EXISTS
- **139 PROC_000084(열재단)·PROC_000081(부착) → ABSENT** / 139 끈 MAT_000070+USAGE.07(.03) → ABSENT

**판정:** 24개 공정 참조는 차원행 라이브 존재 → 즉시 트리거 통과. 139 부속 3건(PROC_000084·PROC_000081·MAT_000070)은 현재 ABSENT이나 step 01 LINK 선행 후 충족 → DRY-RUN에서 트리거 REJECT 0 실증(§G5). **디스패치 슬롯 정확:** 끈=`.03` (mat_cd=ref_key1, usage_cd=ref_key2) · 부착=`.04` (proc_cd=ref_key1) — 트리거 정의(`OPT_REF_DIM.03`은 mat+usage, `.04`는 proc 단일)와 정확 일치. 슬롯 오용 0.

**BLOCKED 9건이 진짜 차원 부재인지 독립 확인:** 거치대(136/137 실내/실외)=라이브 거치대 상품 0행(template 경로·base 미정), 복합끈(124 리본끈=마스터 0행, +면끈/우드행거/우드봉/천정고리=해당 상품 product_material 미링크) — 전건 정당한 차원 부재. (라이브 실측: 138 silsa에서 MAT_000070·PROC_000081은 LINKED이나 124/133/134/135엔 미링크 = 상품별 링크 필요 = BLOCKED 정당.)

---

## G2. 도수 OG 0 정합 — **PASS**

라이브 실측: `t_prd_product_print_options`에서 13상품(118~145) **전부 0행** = prn=0 확인. → 도수 옵션그룹 미생성 정당.

**122 "화이트" 환원 검증:** 라이브 `t_proc_processes.PROC_000008 = '화이트'` 공정 마스터 존재. 실행본은 `OPT_REF_DIM.04`(공정)·ref_key1=PROC_000008·ref_key2=NULL로 적재 — 도수(`.06`) 아님, clr_cd 미사용. attribute-entity-map "별색=공정(clr_cd=NULL)" verdict 및 cpq-schema MISMATCH-1 정정과 정합. 화이트별색 OG(OPT_000008)=SEL_TYPE.01·mand=N도 "옵션 선택" 의미로 정당.

---

## G3. 비규격 사이즈 처리 — **PASS**

라이브 `t_prd_products` nonspec 컬럼 독립 실측 vs 설계 §1.4:

| prd_cd | 라이브 nonspec_yn | 라이브 W/H 범위 | 설계 일치 |
|---|:--:|---|:--:|
| 118/120/121/122/124/125 | Y | 200~1200 / 200~3000 | ✅ |
| 139 | Y | 500~900 / 500~3000 | ✅ |
| 133/134/135/136/137/145 | N | (NULL) | ✅ |

7상품(118/120/121/122/124/125/139) R-SIZE-NONSPEC constraint 생성 = 라이브 nonspec_yn=Y와 정확 일치. 비규격은 option_item 미열거(연속수치) → constraint만 — 원칙 정확 준수. JSONLogic top-level `or` well-formed(규격선택이면 `!=nonspec` 참 통과 / 비규격이면 4변 범위 AND). 145는 nonspec_yn=N → constraint 미생성도 정확.

---

## G4. 가공 택일 + GAP-PARAM 정직성 — **PASS**

타공 4/6/8(139)·봉제 3종(124)·족자 사각/원형(135)이 **공정 1행 재사용**으로 적재 — 라이브 실측 04_t...items.sql: 타공 4/6/8 전부 `PROC_000079` 동일행, 봉제 3종 전부 `PROC_000080` 동일행, 족자 2종 전부 `PROC_000082` 동일행. 공정 N행 복제(마스터 오염) 없음.

**GAP-PARAM 정직성:** ref_param_json 미구현(cpq-schema §4 🔴8 라이브 확인 — option_items에 qty만)으로 구수/유형/모양 보존불가를 `blocked-and-gaps.md` GAP-PARAM으로 정직 격리. **qty smear 검사:** qty 값은 코팅/타공=1(1회 적용), 끈추가=4(끈 4개 개수)로 개수의 물리적 의미만 담음 — 구수(4/6/8)를 qty에 인코딩하지 않음(타공 4/6/8 모두 qty=1). qty 남용 0.

138 silsa 실증 패턴과 동형(라이브 OPV_000007/008/009 타공 3종이 전부 PROC_000079 동일행).

---

## G5. 멱등성 + 139 LINK 보정 — **PASS(멱등·트리거·롤백) / FINDING-1(L1 경계)**

### 멱등성·트리거·롤백 — 실증 PASS

`apply.sh dryrun`(BEGIN…apply…ROLLBACK) + `_idempotency_test.sql`(apply×2→ROLLBACK) 직접 실행:

- **1-pass DRY-RUN:** step 00~05 전건 실행 · 트리거 REJECT 0 · 최종 행수 groups 20·options 33·items 27·constraints 7 (설계 보고와 정확 일치) · ROLLBACK 종료.
- **2-pass 멱등:** PASS 1 = 90건 전부 `INSERT 0 1` / PASS 2 = 90건 전부 `INSERT 0 0` → **delta 0**. 모든 INSERT `WHERE NOT EXISTS`(자연키 가드) 작동.
- **139 끈추가 재현:** step 01 LINK 선행 후 끈추가(OPV_000047 item_seq1 .03 MAT_000070+USAGE.07 qty4 + item_seq2 .04 PROC_000081 qty4)가 트리거 통과 — 138 silsa OPV_000014와 byte 동형 BUNDLE 패턴 확인.
- **ROLLBACK 후 영구변경 0:** Tier A 13상품 groups/options/items/constraints 전부 0행 유지 · 139 MAT_000070/PROC_000084 링크도 0(미생성). **NEVER COMMIT 준수.**
- disp_seq = L1 옵션성 컬럼 등장순(별색·코팅→가공→추가) 확인.

### 139 LINK 선적재 = L1 영역 판정 — **FINDING-1 (MAJOR)**

**판정: step 01 `01_product_links.sql`은 L1(차원행) INSERT이며, L2 옵션레이어 트랜잭션에 묶인 채로는 범위 경계 위반이다. 단 차원 코드 신규 발명(mint)은 아니다.**

근거(라이브 실측 + 스킬 권위):
1. step 01은 `t_prd_product_processes`(PROC_000084·PROC_000081)·`t_prd_product_materials`(MAT_000070+USAGE.07)에 **(prd_cd↔master) 연결행을 신규 INSERT**한다. 이 테이블들은 스킬이 정의한 **L1 차원 테이블**(sizes/materials/processes/...)이다 — option_item이 가리키는 대상.
2. 스킬 §"Load order: dimension rows first" = "1. dimension rows — L1, mostly already live. **If a referenced dimension row is missing, the option_item is BLOCKED (needs L1 pre-load) — list it, don't invent the dimension code.**" → 차원행 부재 시 **BLOCKED 격리가 원칙**. 139 끈은 차원행 부재(G1b ABSENT)임에도 BLOCKED으로 격리하지 않고 L2 트랜잭션 안에서 차원 LINK를 신규 생성했다 — 124/133/134/135의 +끈/우드행거를 BLOCKED으로 격리한 것과 **불일치한 처리**.
3. **완화 요인(mint 아님):** PROC_000084(열재단)·PROC_000081(부착)·MAT_000070(끈) 마스터 코드는 라이브 `t_proc_processes`/`t_mat_materials`에 **이미 존재**(G5a 실증). 따라서 새 코드 발명은 0 — 기존 마스터를 139에 product-link만 추가. "발명 금지"는 위반하지 않는다.
4. **일관성 결함:** 같은 BUNDLE-LINK 성격인데 139 끈은 step 01 자동 LINK, 124/133/134/135 끈/우드는 GAP-BUNDLE-LINK(BLOCKED·인간 승인). 동일 기준이라면 139 끈도 BLOCKED이거나, 그 4상품도 동일 LINK 선적재여야 한다.

**제안 수정(→ `dbm-option-mapper` / `dbm-load-builder`):**
- (a) step 01 `01_product_links.sql`을 옵션레이어 apply.sql에서 **분리** → `_preload_l1_links/` 별도 패키지로 이동하고 "차원 LINK = 인간 승인" 라벨. 옵션레이어(02~05)는 그 LINK 적재 후 실행. 또는
- (b) 139 끈추가를 124/133/134/135처럼 **BLOCKED(GAP-BUNDLE-LINK)으로 격리**하여 처리 일관성 확보(끈 BUNDLE 전건을 한 L1 LINK 승인으로 묶음).
- 권장 = (a). 139는 138 형제로 끈 BUNDLE이 명백한 정규 옵션이므로 폐기보다 L1 LINK를 명시 승인 단위로 끌어올리는 것이 합리적. 단 자동 결합이 아니라 **승인 분리**가 필수.

> 이 FINDING은 적재 가능성·정확성 결함이 아니라 **범위 경계(L1/L2 분리) 위반**이다. 데이터는 옳다(138 형제로 정합). COMMIT 시 의도치 않게 L1 차원행이 함께 영구 적재되는 것을 막기 위해 분리가 필요하다.

---

## G6. BLOCKED/GAP 정직성 + FK 위상 — **PASS**

- **BLOCKED 9 정직성:** 거치대 4(136/137 실내·실외 = 라이브 거치대 상품 0행, template base 미정·GAP-ADDON-STAND)·복합끈 5(124 리본끈 마스터 0행/면끈 미링크·133 우드행거·134 우드봉·135 천정고리) — 전건 라이브 실부재 기반, 발명 0. 센티넬(코팅없음/추가없음/출력만/거치대없음) item 0행=INSERTABLE 정당.
- **GAP 4 (→ ddl-proposer):** GAP-PARAM(ref_param_json·cpq-schema §4 라이브 확인)·GAP-ADDON-STAND·GAP-BUNDLE-LINK·GAP-RIBBON — 전건 라이브 권위 인용·smear 0.
- **[CONFIRM] 5:** 천정고리 자재 vs 셋트·거치대 base·면끈 귀속·리본끈·134 복합유형 — 침묵 선택 없이 정직 표기.
- **FK 위상순:** apply.sql 00 markers → 01 LINK → 02 groups → 03 options → 04 items → 05 constraints. groups→options(opt_grp_cd FK)→items(opt FK + 트리거 차원행)→constraints. 위상 정확. (단 01 LINK의 L1 성격은 G5 FINDING-1 참조.)

---

## 독립 재집계 (생성자 보고 대조)

| 항목 | 생성자 보고 | 독립 재집계(DRY-RUN 실측) | 일치 |
|---|:--:|:--:|:--:|
| option_groups | 20 | 20 | ✅ |
| options(INSERTABLE) | 33 | 33 | ✅ |
| option_items INSERTABLE | 27 | 27 | ✅ |
| BLOCKED option | 9 | 9 | ✅ |
| constraints | 7 | 7 | ✅ |
| product LINK 선적재 | 3 | 3 (단 L1 경계·FINDING-1) | ✅(분류 일치) |
| 총 INSERT | 90 | 90 | ✅ |

**뒤집힌 분류 0건.** 단 LINK 3건의 L1/L2 귀속에 대한 FINDING-1(범위 분리)을 부가.

---

## 잔존 BLOCKED / [CONFIRM] / GAP 요약

- **BLOCKED 9:** 거치대 4(136/137)·복합끈 5(124×2·133·134·135) — 차원행 선적재 후 별도 패키지(인간 승인).
- **[CONFIRM] 5:** ① 천정고리(135) 자재 MAT_000215 vs 셋트 PRD_000008 ② 배너거치대 base 상품 ③ +면끈 귀속(단일 vs 2자재) ④ 리본끈(124) mint vs 통합 ⑤ 134 오버로크+봉미싱 복합유형.
- **GAP 4:** GAP-PARAM · GAP-ADDON-STAND · GAP-BUNDLE-LINK · GAP-RIBBON → `dbm-ddl-proposer`.

---

## 139 LINK 판정 (작업 지시 명시 요구)

**139 끈 BUNDLE LINK 선적재는 L2 범위 위반(L1 차원행 INSERT)이다 — 단 차원 코드 신규 발명(mint)은 아니다.**

- step 01은 PROC_000084·PROC_000081·MAT_000070을 139에 product-link 신규 INSERT → **L1 차원행 생성**. 라이브 실측상 이 3건은 현재 139에 ABSENT(G1b)이고, 이 LINK 없이는 끈추가 option_item이 트리거 REJECT됨(끈 BUNDLE이 트리거 통과한 것은 LINK가 차원행을 만들었기 때문 = L1 효과 실증).
- 그러나 PROC_000084/081·MAT_000070 **마스터 코드는 라이브에 이미 존재**(G5a) → 발명 0. 138 형제 패턴(138엔 동일 3건 LINKED·OPV_000014 끈 BUNDLE byte 동형)으로 데이터 정합성도 옳다.
- **결론:** 데이터는 옳으나 L1 LINK를 L2 옵션레이어 트랜잭션에 묶은 것은 범위 경계 위반 → **인간 승인 분리 필요**(FINDING-1 (a) 권장). 분리 전까지 옵션레이어는 LINK 3건을 제외한 87건만 무조건 GO, 90건 전량 GO는 L1 LINK 승인 후.

---

## Finding 라우팅

| # | 심각도 | 내용 | 라우팅 |
|---|:--:|---|---|
| FINDING-1 | MAJOR | step 01 product LINK(139 끈 부속 3건)=L1 차원행 INSERT를 L2 트랜잭션에 결합 — 인간 승인 분리 필요(124/133/134/135 BLOCKED과 처리 불일치). 마스터 코드는 기존(발명 아님) | `dbm-load-builder`(apply.sql LINK 분리) + `dbm-option-mapper`(139 끈 처리 일관성: 분리 LINK vs BLOCKED) |
| (참고) | — | BLOCKED/GAP/[CONFIRM] 정직 격리 — 결함 아님, 인간 승인 대기 | `dbm-ddl-proposer`(GAP 4) + 사용자 escalate([CONFIRM] 5) |

뒤집힌 분류·뒤집힌 INSERTABLE·트리거 위반·날조 = **0건**. 생성자 산출의 사실 인용·라이브 정합은 정확.
