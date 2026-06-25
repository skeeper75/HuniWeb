# post-verify — 엽서북(PRD_000094) 셋트 보정 COMMIT 사후 재실측

생성: hsp-load-executor · 시점 2026-06-24 06:00 · 라이브 읽기전용 재실측 · 백업=`_setbuild_20260624_0600`.
**COMMIT 후 라이브 직접 실측 증거.** 비밀값 비노출(`.env.local RAILWAY_DB_*`).

---

## 사후검증 6항목 — 전부 PASS

| # | 항목 | 기대 | 라이브 실측 | 판정 |
|---|---|---|---|---|
| ① | 94 유형 = 01 | PRD_TYPE.01 | `PRD_000094 = PRD_TYPE.01` | **PASS** |
| ② | (94,95) min/max/incr·disp_seq | 20/30/10·1 | `min=20 max=30 incr=10 disp_seq=1 del_yn=N` | **PASS** |
| ③ | (94,96) disp_seq 보정 | 2 (NULL 가변 유지) | `min/max/incr=NULL disp_seq=2 del_yn=N` | **PASS** |
| ④ | FK 고아 0 · 복합PK 중복 0 | 0·0 | `fk_orphan=0 · pk_dup=0` | **PASS** |
| ⑤ | 멱등(재-dryrun delta 0) | 1차 UPDATE=0·fingerprint 불변 | COMMIT 후 재-dryrun: 1차 UPDATE=**0**·fingerprint `3a601691…`=COMMIT전 동일 | **PASS** |
| ⑥ | evaluate_set_price 무손상 | 450,000원·PRICE≠0 | 골든 재계산 = **450,000** (S1_20P 4,500×100·S2 단면매칭0·구성원0·할인0) | **PASS** |

---

## 멱등 fingerprint (셋트행 데이터값)

- DRY-RUN 1·2회차(COMMIT 전) = `3a601691f6559e30fc4c50e86565feec`
- COMMIT 후 재-dryrun 1차·2차 = `3a601691f6559e30fc4c50e86565feec` (동일)
- COMMIT 후 1차 UPDATE t_prd_products = **0행**(이미 01) → 진짜 멱등(재실행 delta 0)

## 가격 무손상 근거 (구조적 보장 + 재계산 일치)

이번 3 DML은 가격사슬 테이블(`t_prc_*`·`t_prd_product_price_formulas`·`t_prd_product_discount_tables`)을
일절 건드리지 않음. 가격 입력값 baseline(COMMIT 전) = 사후(COMMIT 후) 동일:

| 가격 입력 | COMMIT 전 | COMMIT 후 |
|---|---|---|
| 골든 단가행 unit_price (COMP_PCB_S1_20P/SIZ_000003/단면/100) | 4,500 | 4,500 |
| 94 공식 바인딩 | PRF_PCB_FIXED | PRF_PCB_FIXED |
| PRF_PCB_FIXED formula_components | 2 (S1·S2_20P) | 2 |
| 구성원 95/96 가격공식 | 0 | 0 |
| 할인테이블(94) | 0 | 0 |

→ evaluate_set_price 종단 재계산 = **450,000원** (게이트 골든값과 정확 일치·PRICE≠0).

## 30P 결함 (RM-1) — 사후에도 미변경 확인

RM-1(30P 미바인딩→20P로 오청구)은 적재본 범위 밖. 이번 COMMIT은 30P comp/단가/공식을
변경하지 않았으므로 RM-1 상태 불변(§18/dbmap 별도 트랙 대기).

## undo 검증

`undo.sql` DRY-RUN(ROLLBACK 내장) 결과: 복원 시 94=PRD_TYPE.04·95/96 NULL·disp_seq=1
(보정 전 상태 정확 복원). 기본 ROLLBACK이라 라이브 무변경 — 복원 필요 시 ROLLBACK→COMMIT 전환 재실행.

**불일치 0 → undo 불요. COMMIT 유효.**
