# 적재 실행 게이트 — GP 합판도무송 원형(GANGPAN circle) 마이그레이션

- **대상 번들:** `09_load/_migrate_gp_circle/` (빌더: `dbm-load-builder` — 본 게이트와 독립, R6)
- **게이트:** `dbm-validator` (round-5 적재 실행 게이트, G1~G9 carry-forward + R1~R6)
- **권위:** `docs/goal-2026-06-06-02.md` · 라이브 스키마(`_meta/_live_extract/`) · 엑셀/CSV 원천(`02_mapping/load_price/`, `09_load/sticker/_blocked/`)
- **검증 방식:** 로컬 정합 검사(전건) + 읽기전용 라이브 SELECT(스키마/존재/컨벤션 확인). **라이브 쓰기·DRY-RUN 미실행(리드 미승인).** COMMIT 0.
- **종합 판정: GO-PENDING-LIVE-DRYRUN** — 모든 로컬·읽기전용 게이트 PASS. 유일 잔여 단계 = 리드 승인 후 롤백전용 라이브 DRY-RUN 1회(R5).

---

## 1. 마이그레이션이 주장하는 동작 (검증 대상)

단일 트랜잭션 3단계:
1. `01_siz_register.sql` — 신규 원형 직경 siz **10건** `SIZ_000501~510`(10/15/20/25/30/40/45/50/55/60mm). 35mm는 `SIZ_000422` 재사용(미포함).
2. `02_component_prices.sql` — GP 단가 **100행**(`COMP_GANGPAN_PRINT`), placeholder `SIZ_PENDING_GP_원형NNmm` → 실 `SIZ_0005NN` 치환.
3. `03_product_sizes.sql` — sticker-066(PRD_000066) 원형 size 링크 **11행**(신규 10 + SIZ_000422).

`migrate.sql`(BEGIN…COMMIT) 래핑, `apply.sh`(기본 DRY-RUN, `--commit`=인간 승인).

---

## 2. G1~G9 Carry-forward

| 게이트 | 판정 | 근거 |
|---|---|---|
| **G1 t_* 화이트리스트** | PASS | INSERT 대상 3종 전부 `t_*`: `t_siz_sizes`·`t_prc_component_prices`·`t_prd_product_sizes`. 비-t_* 0. |
| **G2 타입/길이** | PASS | siz_cd(≤50)·comp_price_id(bigint)·numeric(8,2) 치수·numeric(12,2) 단가·varchar(500) note 전건 적합(라이브 `02_columns.tsv` 대조). |
| **G3 NOT NULL** | PASS | siz: 필수 컬럼(siz_cd,siz_nm,impos_yn,use_yn,del_yn,reg_dt) 명시. price: reg_dt 컬럼 **생략→DEFAULT now() 발화**(NOT NULL DEFAULT 충족). product_sizes: reg_dt 실값 명시. **공란→NULL on NOT NULL 케이스 0**(round-5 reg_dt 함정 회피). |
| **G4 CHECK** | PASS | use_yn/impos_yn/del_yn ∈ {'Y','N'} 전건 충족. dsc XOR 류 비해당. |
| **G5 FK** | PASS(로컬+라이브 확인) | comp_cd→COMP_GANGPAN_PRINT(라이브 1)·siz_cd→t_siz_sizes(STEP1+422)·mat_cd→MAT_000084/153(라이브 2)·prd_cd→PRD_000066(라이브 1). 고아 0. |
| **G6 PK 유일성(CSV 내)** | PASS | siz_cd 10 distinct·comp_price_id 100 distinct(2956~3065에서 35mm 10건 제외)·(prd_cd,siz_cd) 11 distinct. 중복 0. |
| **G7 무손실(no silent drop)** | PASS | 원천 100 price + 11 size + 10 siz 전건 적재. 누락/추가 0(§4 field-for-field 100/100). |
| **G8 적재 순서↔FK 그래프** | PASS | `\i` 01(siz)→02(price)→03(size). siz가 의존 테이블보다 선행 = FK 위상순 충족. |
| **G9 독립 검증** | PASS | 빌더와 분리된 본 게이트가 라이브 직접 대조로 ≥1 실관찰 도출(§6 F-1 reg_dt 컨벤션·F-2 R4d 동치수 square siz). |

---

## 3. R1~R6 (적재 실행 게이트)

### R1 멱등성 — **PASS (로컬)**
모든 INSERT가 라이브 PK와 일치하는 `ON CONFLICT (...) DO NOTHING` 보유:
- siz → `ON CONFLICT (siz_cd)` = `t_siz_sizes_pkey`(siz_cd) ✓ (`03_pks.tsv:70`)
- price → `ON CONFLICT (comp_price_id)` = `t_prc_component_prices_pkey`(comp_price_id, **단일컬럼**) ✓ (`03_pks.tsv:24`)
- product_sizes → `ON CONFLICT (prd_cd, siz_cd)` = `t_prd_product_sizes_pkey`(prd_cd, siz_cd) ✓ (`03_pks.tsv:63-64`)

ON CONFLICT 누락 0/0/0(siz/price/psizes 전건). 본 3 테이블에 UNIQUE 제약 없음(`06_uniques.tsv` — t_* 0건) → PK가 유일한 정당 충돌키이며 빌더 선택 정확. **2-pass 멱등 실증은 R5(라이브)에서 확정.**

### R2 트랜잭션 원자성 — **PASS**
- `migrate.sql` 단일 `BEGIN;`(L10)…단일 `COMMIT;`(L71). 그 외 BEGIN(L16/33/46/57)은 `DO $$ … $$` PL/pgSQL 블록(트랜잭션 제어 아님).
- 스텝 파일(01/02/03) 내 `BEGIN;/COMMIT;/ROLLBACK;` **0건**(중간/중첩 COMMIT 없음).
- `\set ON_ERROR_STOP on`(L8) 존재 → 어느 INSERT/어서션 실패 시 전체 롤백.
- 적재 후 어서션 3종(siz FK 고아·comp_cd 존재·066 link FK 고아) `RAISE EXCEPTION`으로 부분커밋 차단.

### R3 실행 가능성 — **PASS (로컬 파스)**
- 통계: siz 10·price 100·psizes 11 INSERT, 전건 `;` 종결·`ON CONFLICT…DO NOTHING` 종결.
- `\i` 상대경로 3건 → 로더가 `cd "$HERE"` 후 실행하므로 CWD 기준 해소 정상.
- 로더 `apply.sh`: `.env.local` source, `PGPASSWORD` 미출력, 기본 DRY-RUN, `--commit`만 실제 반영. DRY-RUN sed 타깃 `^COMMIT;$` 라이브 매치 **정확히 1행**(주석 L4의 단어 "COMMIT/ROLLBACK"은 미매치).
- **라이브 `psql -f` 실행 미수행**(리드 미승인) — 로컬 구조/파스 검사만.

### R4 DDL 제안 정합 — **PASS (해당 없음·search-before-mint 재확인)**
- 본 트랙 **DDL 0** — siz 등록은 기존 `t_siz_sizes`에 대한 순수 코드/데이터 INSERT(CREATE/ALTER 아님). NOT-DDL 정당.
- search-before-mint 라이브 재확인(읽기전용):
  - `SIZ_000501~510` 라이브 부재 = **0건** ✓
  - 라이브 max `SIZ_[0-9]+` = `SIZ_000500` → 501~510 = 정확히 다음 블록, 충돌 0 ✓
  - 형제 컨벤션 `SIZ_000419~422` = `원형13x13/19x19/24x24/35x35` → 신규 `원형{d}x{d}` 명명 추종 정확 ✓

### R5 라이브 DRY-RUN — **PENDING (리드 승인 대기)**
**라이브 쓰기 미승인 → 미실행.** 로컬 사전검사(제약 구조·FK 타깃·타입/길이·읽기전용 존재확인)는 전건 통과. 리드 승인 시 1회 롤백전용(`BEGIN … ROLLBACK`)으로 실행할 어서션:
1. **search-before-mint 가드:** 적재 전 `SIZ_000501~510` 라이브 0(현재 읽기전용 확인 0 ✓).
2. **siz FK 고아 0:** GP 100행 siz_cd 전건 `t_siz_sizes` 존재(STEP1 등록분 포함).
3. **comp_cd FK:** `COMP_GANGPAN_PRINT` 존재(읽기전용 확인 1 ✓).
4. **066 link FK 고아 0 + PRD_000066 존재**(읽기전용 확인 1 ✓).
5. **멱등 2-pass:** 같은 트랜잭션 내 재실행 시 2회차 델타 0(ON CONFLICT DO NOTHING).
6. **제약위반 0 · COMMIT 0 · 영구변경 0**(강제 ROLLBACK).
> migrate.sql에 위 1~4 어서션이 이미 내장되어 있어 DRY-RUN 1회로 동시 검증 가능. **이 1회 실행이 유일 잔여 단계.**

### R6 독립성 — **PASS**
본 게이트는 빌더와 분리됨. 라이브 직접 대조로 실관찰 ≥1 도출(§6). reg_dt NOT-NULL-DEFAULT 함정 특별 점검: siz=`now()`(유효, NULL 미주입), price=컬럼 생략(DEFAULT 발화), product_sizes=실값 명시 → **함정 회피 확인**. 단, siz의 `now()`는 형제 배치 컨벤션과 불일치(F-1, MINOR).

---

## 4. 가격 field-for-field 교차검증 (100행)

원천 `02_mapping/load_price/t_prc_component_prices.csv`의 `siz_cd LIKE 'SIZ_PENDING_GP_원형%' AND NOT '%35mm%'` = **정확히 100행**(직경당 10행 × 10직경, comp_price_id 2956~3065에서 35mm 10건 제외).

빌더 SQL 100 INSERT 전건 파싱 후 원천과 대조:

| 항목 | 결과 |
|---|---|
| comp_price_id 집합 | 원천 100 = SQL 100, 누락 0·추가 0, **verbatim** |
| 35mm ID 누출(2966/2967/2988/2989/3010/3011/3032/3033/3054/3055) | **0건**(정상 제외) |
| siz_cd 치환(원형NNmm→SIZ_0005NN) | 100/100 정확(직경↔SIZ 매핑 일치) |
| comp_cd / apply_ymd / mat_cd / min_qty / unit_price / clr_cd | **필드 불일치 0건** |
| siz_cd·note 외 변경 | 없음(note는 `[siz-corrected: …→…]` prefix만 추가, 원문 verbatim 보존 — 과업 허용 범위) |
| reg_dt | 컬럼 생략 → DEFAULT now() 발화 |

→ **가격 100행: 오직 siz_cd 치환 + note prefix. 행 추가/삭제/변조 0. PASS.**

---

## 5. product_sizes ON CONFLICT 키 + 치수/disp_seq 검증

- **충돌키 `(prd_cd, siz_cd)` = 라이브 PK `t_prd_product_sizes_pkey`**(`03_pks.tsv:63-64`) ✓ — 빌더 선택 정확(추측 아님, 실제 라이브 제약).
- 원천 `t_prd_product_sizes_066_circle.BLOCKED.csv` 11행 대조: `(MINT_NEEDED)`→실 siz_cd, **dflt_yn·disp_seq·reg_dt verbatim**.

| siz_cd | 직경 | disp_seq(원천) | reg_dt(원천) |
|---|---|---|---|
| SIZ_000501~505 | 10~30 | 27~31 ✓ | 2026-06-05 00:00:00 ✓ |
| **SIZ_000422** | **35(재사용)** | **32 ✓** | 2026-06-05 00:00:00 ✓ |
| SIZ_000506~510 | 40~60 | 33~37 ✓ | 2026-06-05 00:00:00 ✓ |

- siz 치수 10건: cut=work=직경, margin=0, `원형{d}x{d}` 명명, BLOCKED CSV `_cut_*_mm`와 전건 일치(발명 0). PASS.

---

## 6. 빌더로 라우팅하는 발견 (모두 MINOR — 차단 아님)

| ID | 심각도 | 발견 | 근거 | 라우팅 |
|---|---|---|---|---|
| **F-1** | MINOR | siz 등록 `reg_dt=now()` 사용. 형제 원형 siz `SIZ_000419~422`는 고정 배치 타임스탬프 `2026-06-03 12:46:02.974607` 사용 → 같은 마스터 배치 컨벤션과 불일치. **유효(NOT NULL 충족·트랩 아님)이나 컨벤션 비정합.** | 라이브 SELECT(SIZ_000419~422 reg_dt) | `dbm-load-builder` — 일관성 위해 명시 타임스탬프 권장(선택). |
| **F-2** | MINOR(관찰) | R4d 라이브에 동일 치수 siz 다수 존재하나 **전부 square(`정사각`/`사각`/`NxN`)**, 원형 부재. 신규 `원형{d}x{d}` mint는 정당(도무송 원형≠square). search-before-mint는 **형상 한정 명명** 기준으로 통과 — 단순 치수 일치로 재사용했다면 오결합 위험이었음. | 라이브 SELECT(cut_width=cut_height IN diameters) | 라우팅 불요(빌더 선택 정확). 명명 규칙 정합성 확인 기록. |
| **F-3** | MINOR(관찰) | `undo.sql`이 product_sizes에서 SIZ_000422(35mm) 링크는 미삭제(501~510만). 현재 35mm 066-링크는 라이브 부재 → 마이그레이션이 생성하나 undo는 미제거(비대칭). 보수적 undo로 정당하나 완전 원복 아님. | undo.sql L15 + 라이브(35mm 066-link 0건) | `dbm-load-builder` — 의도 확인(보수적 undo면 주석 명기). |

> **35mm 정합 확인:** 35mm GP **가격** 10행은 라이브 적재됨(읽기 확인 10건) → 마이그레이션이 정확히 제외. 35mm **066-size 링크**는 라이브 부재 → `03`에 포함 정당. ON CONFLICT로 양쪽 안전.

---

## 7. 종합 판정

### **GO-PENDING-LIVE-DRYRUN**

- **G1~G9 carry-forward: 전건 PASS**
- **R1 PASS · R2 PASS · R3 PASS · R4 PASS · R5 PENDING(리드 승인) · R6 PASS**
- 가격 100행 field-for-field: **불일치 0**, product_sizes 11행 + siz 10건: **원천 verbatim, 발명 0**
- 차단(BLOCKER/MAJOR) 발견: **0건**. MINOR/관찰: 3건(F-1~F-3, 모두 적재 가능성 무영향).
- 유일 잔여 단계: **리드 승인 후 롤백전용 라이브 DRY-RUN 1회**(migrate.sql 내장 어서션으로 멱등 2-pass·제약위반0·COMMIT0 동시 실증). 그 후 인간 승인 시 `apply.sh --commit`(10 신규 siz = 후니 master-data 등록 결정 포함).

**HARD 준수:** 라이브 쓰기 0 · DRY-RUN 미실행(미승인) · COMMIT 0 · 비밀번호 미출력 · 빌더 파일 무편집(발견은 라우팅).
