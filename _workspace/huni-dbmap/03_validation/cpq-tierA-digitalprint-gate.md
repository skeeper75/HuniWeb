# CPQ Tier A 디지털인쇄 14상품 옵션레이어 — 적대적 교차검증 게이트

> 검증 2026-06-14 · `dbm-validator` (생성자 `dbm-option-mapper`와 독립) · round-6 Tier A.
> 대상: `10_configurator/tierA/digitalprint-option-layer.md` + `09_load/_exec_tierA_digitalprint/`.
> 방법: 라이브 Railway DB 읽기전용 독립 실측(`.env.local` RAILWAY_DB_*) + 롤백전용 DRY-RUN 재현. NEVER COMMIT.
> 권위순: 라이브 스키마+트리거 `fn_chk_opt_item_ref` > 설계문서 · Excel 명시값 > 추출 스냅샷.

---

## 0. 최종 판정: **CONDITIONAL-GO**

INSERTABLE 251행 중 **250행은 적재 가능·멱등·트리거 통과 실증 완료**. 단 **1행 과소적재(MAJOR)** 적발 — PRD_000029 종이 MAT_000125 누락. 이 1행 보정 후 무조건 GO. 6 BLOCKED·3 [CONFIRM]은 정직(과소/과대적재 아님).

**뒤집힌 분류: 강등 1건**(INSERTABLE 251 → 실제 적재가능 250 + 누락발견 1). 승격 0건.

---

## 1. 게이트별 결과

| 게이트 | 항목 | 판정 | 증거 |
|---|---|:--:|---|
| **G1** | 트리거 reference resolution (L2 load-bearing) | **PASS** (1 MAJOR finding) | 라이브 실측 set-compare |
| **G2** | BLOCKED 정직성 / 승격 정당성 | **PASS** | 라이브 부재 확인 |
| **G3** | disp_seq 정합 | **PASS** (1 MINOR) | 05 SQL 파싱 |
| **G4** | 멱등성 (2-pass DRY-RUN) | **PASS** | 라이브 롤백전용 실행 |
| **G5** | 더미 분리 | **PASS** | 라이브 + cleanup 정적분석 |
| **G6** | 마스터지도 정합 + FK 위상 | **PASS** | SQL 구조 + 라이브 FK |

---

## 2. G1 — 트리거 reference resolution (L2 핵심 검사)

option_items 251행을 `(ref_dim_cd, ref_key1[, ref_key2])`별로 라이브 차원행과 set-compare 독립 실측.

**디스패치 슬롯 정확성:**
- 도수 `.06`: ref_key1 전건 **opt_id 정수**(1/2), clr_cd 아님 ✅. 라이브 print_options (opt_id, print_side)와 25행 전건 매칭. **PRD_000027/029 = opt_id 1(양면) 단일** — 라이브 실측과 정확히 일치(매니페스트 §5 정정 반영 확인: 고정 opt_id=2 가정 폐기·라이브 실측 반영).
- 자재(종이) `.03`: ref_key1=mat_cd, ref_key2=USAGE.07 전건 정확 ✅.
- 공정 `.04`: ref_key1=proc_cd, ref_key2 미사용 ✅.

**set-comparison 결과:**
```
PROC: SQL∖live (over-load, 트리거 REJECT 후보) = 0건
PROC: live∖SQL (under-load 후보)             = 0건  (라이브 공정 전건 옵션화)
MAT : SQL∖live (over-load)                    = 0건
MAT : live∖SQL (under-load 후보)              = 1건  ← FINDING
```

### FINDING G1-1 (MAJOR · 과소적재) → route: dbm-option-mapper
- **누락**: `PRD_000029` 종이 옵션에서 `MAT_000125` 1행이 SQL에서 빠짐.
- **증거**: 라이브 `t_prd_product_materials` WHERE prd_cd='PRD_000029' AND usage_cd='USAGE.07' AND del_yn='N' = **14행**(MAT_000074/081/082/091/092/101/108/109/113/114/115/116/123/**125**). SQL 07의 종이 .03 INSERT(PRD_000029) = **13행**(MAT_000125 누락). 형제 상품 PRD_000027은 동일 14종 전체 적재(MAT_000125 포함) — 029만 1행 drop.
- **영향**: 매니페스트 표(029 종이 13·item_INS 24)·집계(INSERTABLE 251)에 누락 반영됨 → 생성자가 인지 못한 silent drop. 차원행 실재(라이브 EXISTS)인데 옵션화 제외 = 과소적재.
- **수정**: 07 SQL에 PRD_000029 MAT_000125 종이 option + option_item 1행 추가. 보정 후 INSERTABLE 251→252(또는 매니페스트 029=14 정정). 멱등 가드라 재실행 안전.

> G1 판정 PASS — 디스패치 슬롯·도수·과대적재(트리거 REJECT) 전부 무결. 단 1행 과소적재는 MAJOR로 라우팅(트리거를 통과하므로 적재 차단 아니나, 상품 종이 1종이 고객에게 누락 노출됨).

---

## 3. G2 — BLOCKED 정직성 / 승격 정당성

### BLOCKED 6행 = 진짜 차원행 부재 (정직) ✅
- **접지 4행** (027 PROC_000065/066 · 029 PROC_000067/068): 라이브 `t_prd_product_processes` WHERE prd_cd IN(027,029) AND proc_cd IN(065~068) = **0행**. BLOCKED 정당.
- **화이트별색 2행** (024/025): 024 공정=014/015/027/028만·025 공정=027/028만. 화이트 별색공정 라이브 부재 + 코드 [CONFIRM] 미상. BLOCKED 정당.

### 승격(K2/K3 STALE 반증) 정당성 — 진짜 라이브 실재 ✅
- **종이=INSERTABLE 승격**: 라이브 materials USAGE.07 = 143행 실재(016=21·047=47 등). postcard 파일럿이 0행 BLOCKED로 본 것은 stale — 라이브 권위로 INSERTABLE 정당(단 029 1행은 G1-1 누락).
- **후가공 029~032=INSERTABLE 승격**: 라이브 processes에 029~032 실재(016/018/041/042 등). 승격 정당.

> G2 PASS — 차원 실재인데 BLOCKED(과소) 0건, 차원 부재인데 INSERTABLE(과대) 0건. 승격은 라이브 실측 근거.

---

## 4. G3 — disp_seq 정합

전상품 **인쇄=1, 종이=2** 일관(14/14) ✅. 상품별 보유 옵션만 인스턴스화하되 1부터 압축 재부여, 상대순서 보존:

| 상품 | disp_seq |
|---|---|
| 016/018/033 | 인쇄1·종이2·모서리3·후가공4 |
| 017/032 | 인쇄1·종이2·코팅3·모서리4 |
| 024 | 인쇄1·종이2·코팅3·모서리4·화이트별색5 |
| 027/029 | 인쇄1·종이2·후가공3·접지4·박칼라5 |
| 031 | 인쇄1·종이2·모서리3·후가공4·박칼라5 |
| 047 | 인쇄1·종이2·코팅3·후가공4 |

### FINDING G3-1 (MINOR · 일관성) → route: dbm-option-mapper (보류 가능)
- 옵션레이어 §2 선언 권위순서는 코팅→모서리→후가공→접지→박칼라이나, 일부 상품에서 모서리(3)가 후가공(4)보다 앞. §2 자체가 "보유 옵션만 인스턴스화·상대순서 보존"을 명시했고 모든 상품에서 모서리<후가공·후가공<접지<박칼라 상대순서가 보존되므로 **결함 아님**(MINOR 기록만). disp_seq=L1 컬럼순서 권위(적재 3원칙 ⒜) 충족.

> G3 PASS — 적재 3원칙 ⒜(disp_seq=표시순서 권위) 충족. 상대순서 위반 0.

---

## 5. G4 — 멱등성 (라이브 롤백전용 2-pass DRY-RUN, lead 승인 검증절차)

`apply.sh dryrun` + 통제 트랜잭션 직접 실행으로 독립 재현:

```
PASS-1 (BEGIN → 05/06/07 INSERT):
  groups  58 신규 (OPT_ 언더스코어)
  options 266 신규 (OPV_ 언더스코어)
  items   258 총 = 251 신규 INSERTABLE + 7 기존 더미(OPV-)
  트리거 fn_chk_opt_item_ref: 251 option_items 전건 통과 (ERROR/REJECT 0)
PASS-2 (동일 트랜잭션 멱등 재실행):
  05/06/07 전 INSERT = INSERT 0 0 (delta 0)
  items 그대로 258
ROLLBACK 후:
  POST_ROLLBACK_groups(OPT_) = 0  (영구변경 0)
  post_rollback_items = 7 (더미만 잔존 — 우리 적재 아님)
```

- **트리거 통과 실증**: 251 option_items 전건 차원행 EXISTS — 트리거가 트랜잭션 내 발화하므로 ref resolve 최강 증명. (단 G1-1 누락 1행은 적재 자체엔 영향 없음·트리거 통과행만 검증).
- **멱등 가드 완전성**: 05(58/58)·06(266/266)·07(251/251) 전 INSERT가 `WHERE NOT EXISTS(자연키)` 보유 — 100%.
- **NEVER COMMIT 준수**: 기본 ROLLBACK·POST_ROLLBACK=0.

> G4 PASS — 2-pass delta 0·트리거 전건 통과·영구변경 0 독립 재현.

---

## 6. G5 — 더미 분리

- **라이브 기존 더미**(14상품): groups 1·options 4·items 7 = **016 더미만**(OPT-000005/OPV-000007~010, **하이픈 코드·del_yn=Y**). 025 RULE_001 constraint(별도).
- **우리 신규**: OPT_/OPV_ **언더스코어** — 코드체계 분리. 멱등 가드는 (prd_cd, opt_grp_nm)/(prd_cd,opt_cd,opt_nm) 이름키 → 더미(opt_grp_nm 동일 "후가공"이라도 opt_cd 다름)와 공존, DRY-RUN에서 충돌 0 실증(PASS-1 items 258 = 251+7).
- **`_cleanup_dummy.sql` 안전**: DELETE 대상 = `OPV-000007~010`·`OPT-000005`·`RULE_001`(전부 하이픈/더미 코드)만. 언더스코어(OPT_/OPV_) 코드 0건 — 우리 신규행 미접촉. apply.sql 미포함(인간 승인 별도).

> G5 PASS — 코드체계 분리·cleanup이 우리 행 미접촉.

---

## 7. G6 — 마스터지도 정합 + FK 위상

- **별색=공정(clr_cd=NULL)**: 박칼라 .04 공정(PROC_000037~044)·clr_cd 미사용 ✅. 화이트별색도 공정 의도(BLOCKED).
- **단/양면=도수 `.06` opt_id**: ✅(clr_cd 아님 — MISMATCH-1 회피).
- **추가상품=template**: 016 봉투 add-on은 라이브 기존 TMPL-000005/006/009/010/011 재사용·옵션그룹 중복생성 0(K4) ✅. 017/018 봉투는 GAP(별도 add-on 트랙)로 정직 표기.
- **FK 코드 실재**: SEL_TYPE.01/.02 라이브 cod 실재 ✅.
- **FK 위상**: apply.sql = 00→05(groups)→06(options)→07(items)→08(constraints) 단일 트랜잭션·ON_ERROR_STOP on. 트리거가 07 행단위 차원행 검사 → 05/06 선행 충족. ✅

> G6 PASS — 마스터지도 verdict와 SQL 일치·FK 위상 정확·중복생성 0.

---

## 8. INSERTABLE / BLOCKED / GAP 독립 재집계

| 테이블 | 생성자 보고 | 검증 재집계 | 차이 |
|---|:--:|:--:|---|
| option_groups | 58 | **58** | 일치 |
| options | 266 | **266** | 일치 |
| option_items INSERTABLE | 251 | **250 적재가능 + 1 누락발견** | **G1-1: 029 MAT_000125** |
| option_items BLOCKED | 6 | **6** (접지4+화이트별색2) | 일치·정직 |
| constraints | 0 | 0 | 일치 |

**잔존 BLOCKED 6**: 접지(027/029 × 가로/세로 = 4) + 화이트별색(024/025 = 2). → **dbm-ddl-proposer / 차원 L1 선적재**(GAP-JEOPJI-DIM·GAP-WHITE).

**잔존 [CONFIRM] 3**: C-1 화이트별색 공정코드(미상) · C-2 사이즈 option_group 노출(UI 정책) · C-3 종이 opt_nm=mat_cd vs mat_nm 조인(표시명 정책). → 리드 에스컬레이션.

**GAP 5** (생성자 정직 표기, → dbm-ddl-proposer): GAP-PARAM(코팅면·후가공줄수·가변개수·박크기) · GAP-JEOPJI-DIM · GAP-WHITE · GAP-COATING-SIDE · GAP-BAK-COMPOSITE.

---

## 9. Finding 라우팅 요약

| ID | 심각도 | 내용 | 라우팅 |
|---|:--:|---|---|
| **G1-1** | **MAJOR** | PRD_000029 종이 MAT_000125 1행 과소적재(라이브 실재·옵션화 누락) | **dbm-option-mapper** (07 SQL 보정) |
| G3-1 | MINOR | disp_seq 모서리/후가공 상품별 압축순서(상대순서는 보존·결함 아님) | dbm-option-mapper (기록만·보류 가능) |
| BLOCKED×6 | — | 접지4+화이트별색2 차원행 부재(정직) | dbm-ddl-proposer / L1 선적재 |
| CONFIRM×3 | — | C-1~C-3 (화이트별색 코드·사이즈 노출·표시명) | 리드 |

---

## 10. 최종 verdict

**CONDITIONAL-GO** — G1-1(029 MAT_000125 1행) 보정 후 GO.

- 적재본은 멱등·트리거 전건 통과·영구변경 0·더미 미충돌 실증 완료(G2~G6 전건 PASS·결함 0).
- G1은 디스패치/도수/과대적재 무결이나 **1행 과소적재(MAJOR)** 적발 — 트리거 차단은 아니나 고객에 종이 1종 누락 노출. 생성자 보정 후 재게이트(07 SQL 변경분만).
- 6 BLOCKED·3 [CONFIRM]은 발명 없이 정직 격리됨.
- 실 COMMIT·더미 정리·BLOCKED 차원 L1 선적재·[CONFIRM] 해소 = **인간 승인** 대기. NEVER COMMIT.
