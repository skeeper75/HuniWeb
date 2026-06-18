# Wave 1 교정 실행본 — R1~R6 독립 검증 게이트 (dbm-validator)

> **트랙** hbg Phase 5 Wave 1 → `dbm-load-execution` R1~R6 게이트. **검증** 2026-06-18.
> **검증자** dbm-validator (생성자 dbm-load-builder 산출 비신뢰·라이브 직접 재실측).
> **방법** Railway `railway` DB 읽기전용 SELECT + 검증자 자작 BEGIN..ROLLBACK 2-pass DRY-RUN.
> **[HARD] SELECT + BEGIN..ROLLBACK만 수행. 실 COMMIT 0. 자격증명 stdout 비노출.**

---

## 0. 한 줄 평결

**GO — R1~R6 전건 PASS. 영향 36행·멱등 2-pass 델타 0·제약위반 0·가격사슬 0참조·post-rollback 0 leaked. 생성자 SQL 베끼지 않고 라이브 직접 재측정·재실행으로 독립 입증. dodge 0.**

실 COMMIT 안전성: **안전** (백업·undo 보유·전건 가역·돈 크리티컬 0). 실 COMMIT은 인간 최종 승인 대기.

---

## 1. R1~R6 게이트 판정표

| 게이트 | 판정 | 핵심 근거(라이브 재실측) |
|--------|:----:|--------------------------|
| **R1 멱등성** | **PASS** | 검증자 자작 2-pass BEGIN..ROLLBACK: pass1=37행 / **pass2=0** (전건 no-op). 가드 `WHERE del_yn='N'`·`IS DISTINCT FROM` 작동 실증. |
| **R2 트랜잭션 원자성** | **PASS** | `apply_wave1.sql` 내 **executable BEGIN/COMMIT/ROLLBACK = 0** (전부 주석). 로더가 단일 `BEGIN…COMMIT` 래핑·`ON_ERROR_STOP` 활성. 중간/중첩 COMMIT 없음. |
| **R3 실행가능성** | **PASS** | SQL 구문 정상·FK 부모 CAT_000134/198 실재(`del_yn='N'`)·MAT_TYPE.07 base_code 실재. 영향 행수 R1 2·R2 11·R3 2·R4 1·R5 16·R6 5 **라이브 일치**. |
| **R4 가격사슬 무접촉** | **PASS** | 라이브 직접 재실측(생성자 주장 비신뢰): SIZ_104/105 cp 0·PROC_000025 cp 0+link 0·R5 16자재 cp 0·봉투 5 cp 0+BOM 0. |
| **R5 라이브 DRY-RUN** | **PASS** | BEGIN..ROLLBACK 실 COMMIT 0·제약위반 0(FK orphan 0·NOT NULL 0)·**post-rollback 전건 원상태**(0 leaked). |
| **R6 생성-검증 독립성** | **PASS** | 생성자 `apply_wave1.sh` 미실행·검증자 자작 SQL로 라이브 재측정. commit-path = DRY-RUN-path 동일 실증(dodge 0). del_yn 권위 정합. |

---

## 2. 라이브 재실측 증거 (검증자 직접·2026-06-18)

### 2.1 교정 대상 현재 상태 (전건 전제 충족)
```
R1  SIZ_000104 "화이트165x115mm(10장)" del_yn=N   SIZ_000105 "블랙165x115mm(10장)" del_yn=N   → 2 적격
R2  대상 11 전건 del_yn=N (CAT_000297 "레드프린팅 책자 가이드"=이미 Y → 정당 제외)
R3  CAT_000302/304 upr_cat_cd=NULL(고아)·use_yn=Y(활성)   부모 134/198 del_yn=N 실재  → 재연결 2
R4  PROC_000025 "레이플랫제본" del_yn=N use_yn=Y  → 소프트삭제 1
R5  16 부자재 전건 mat_typ=.10·del_yn=N  → 16 ("~17" 명세 정정·MAT_000211 헤더는 이미 Y라 R6 버킷)
R6  봉투 5 전건 .10·del_yn=N → 5    헤더 6(211/218/223/225/229/233) 전건 이미 del_yn=Y → 0 (멱등 skip)
```

### 2.2 검증자 자작 2-pass DRY-RUN (BEGIN..ROLLBACK)
```
item   pass1  pass2          item   pass1  pass2
R1a      1     0             R4       1     0
R1b      1     0             R5      16     0
R2      11     0             R6env    5     0
R3a      1     0             R6hdr    0     0
R3b      1     0
                       pass1_total=37  pass2_total=0   ← 멱등 PASS
```
> 검증자 총계 37 = README 36 + 1 (검증자는 R1을 R1a/R1b 2문으로 분리 측정. 실제 영향 size 행 = 2로 동일·불일치 아님).

### 2.3 제약위반 + leak 어서션 (txn 내 / rollback 후)
```
FK_orphan_R3            = 0   (302→134·304→198 재연결 후 부모 실재)
cat_NOTNULL_violation   = 0
POST-ROLLBACK leak_R1   = 화이트.../블랙... (원상태)      ← 0 leaked
POST-ROLLBACK leak_R4   = PROC_000025 del_yn=N (원상태)   ← 0 leaked
POST-ROLLBACK leak_R5   = still_10: 2/2 (원상태)           ← 0 leaked
```

### 2.4 가격사슬 0참조 (R4·라이브 직접·생성자 주장 비신뢰 재측정)
```
SIZ_000104/105  → t_prc_component_prices.siz_cd   = 0
PROC_000025     → t_prc_component_prices.proc_cd  = 0  · t_prd_product_processes = 0
R5 16 부자재    → t_prc_component_prices.mat_cd   = 0  (typ만 변경·mat_cd 불변이라 가격 무관 이중 안전)
봉투 5          → t_prc_component_prices.mat_cd   = 0  · t_prd_product_materials(BOM) = 0
R2 카테고리 11  → t_prd_product_categories        = 0
R3 302/304      → t_prd_product_categories        = 각 1 (∴ 삭제 아닌 재연결 = 정당)
```

---

## 3. dodge-hunt (생성-검증 독립성 R6)

- **commit-path ↔ DRY-RUN-path 동일성:** `apply_wave1.sh commit` = `\i apply_wave1.sql`(BEGIN..COMMIT 래핑). DRY-RUN/idempotent 모드의 inlined SQL과 R5 대상 mat_cd 16건 **byte-identical**·R2/R6 동일. → "DRY-RUN은 통과시키고 commit은 다른 걸 적재"하는 dodge **없음**. 검증자가 자작 SQL로 재실행해 동일 결과 확인.
- **del_yn 권위 정합:** 소프트삭제(R2/R4/R6) 전건 `del_yn='Y'+del_dt`·executable `use_yn` SET **0**(use_yn 4건은 전부 주석). [[dbmap-del-yn-soft-delete-authority]] 준수.
- **행수 정직성:** 생성자가 명세 "R5 ~17"→라이브 16, "R6 11"→봉투 5+헤더 6(기처리)로 자진 정정한 것 라이브 재측정으로 **정확** 확인. 과장/날조 0.

---

## 4. 미검증·잔여 (정직 표기)

- **경로 Y 휘발성**: del_yn='Y'·in-place UPDATE는 load_master TRUNCATE 재적재 시 휘발(README §4 명기). 본 게이트 범위 외(개발자 v03 재적재 백로그)·실 COMMIT 가역성에는 영향 없음.
- **R3 부모 매칭 의미 적정성**: 302→데스크소품·304→응원/시즌 재연결이 운영 분류상 옳은지는 데이터 무결성 아닌 도메인 판단 → README §6 권고대로 적용 시 운영자 1회 시각 확인(게이트 차단 사유 아님).
- **R5 13 BOM link 존재**: 16 부자재 중 13이 product_materials에 링크. mat_typ_cd만 변경·mat_cd 불변이므로 BOM 무접촉(가격·무결성 무영향). 정상.

---

## 5. 실 COMMIT 안전성 판정

**안전 (인간 승인 시 `apply_wave1.sh commit` 가능).**
- 전건 가역(undo_wave1.sql 보유·백업 6 CSV)·돈 크리티컬 0·제약위반 0·FK 고아 0.
- 단일 트랜잭션 원자 적용(부분 적용 불가)·멱등(재실행 안전).
- **★실 COMMIT은 인간 최종 승인 대기** — 본 게이트는 롤백전용 DRY-RUN까지만, COMMIT 0.

**FAIL 항목 없음 → dbm-load-builder 재산출 불요.**
