# 좀비 배선 정리 W1-2 — 확정 4건 라이브 COMMIT 실행 리포트

생성: §23 huni-set-product `07_prereq/zombie-wiring-92/_exec` · 라이브 Railway DB(`db railway`, 비표준 포트) · 인간 승인 완료("지금 실행")
권위: del_yn 논리삭제 권위([[dbmap-del-yn-soft-delete-authority]]) + disposition.csv(REWIRE 2 / REVIVE 2 확정) + audit.md(돈영향 0원 게이트)
원칙[HARD]: search-before-mint(신규 mint 0) · 비파괴(물리 DELETE 0·DDL 0) · 멱등 · FK 선행 무결성 · 복합PK 충돌 가드

> **결론 한 줄**: 확정 4건(REWIRE 260→250·270→343 / REVIVE 008·261) **COMMIT 성공**. 좀비 배선 **87→83**(wires 175→140). 충돌 0건(8행 전부 정상 REWIRE). 직접 단가행 0 → **청구 불변(0원)**. 83 BLOCKED 미접근.

---

## 1. 실행 대상 4건 (이것만)

| # | 처분 | mat_cd | mat_nm | 동작 | 배선 |
|---|---|---|---|---|---|
| 1 | REWIRE | MAT_000260 (del_yn=Y) | 아트250 + 무광코팅 | t_prd_product_materials.mat_cd → MAT_000250(정본) | 7 |
| 2 | REWIRE | MAT_000270 (del_yn=Y) | 워터북보틀 500ml | t_prd_product_materials.mat_cd → MAT_000343(정본) | 1 |
| 3 | REVIVE | MAT_000008 (23배선) | 레더 | t_mat_materials.del_yn 'Y'→'N' | 23 |
| 4 | REVIVE | MAT_000261 (4배선) | 무지내지 | t_mat_materials.del_yn 'Y'→'N' | 4 |

★전 87 좀비 component_prices 단가행 0건 확정 → 4건 처분 전부 돈영향 0원(청구 불변).

---

## 2. 복합 PK 충돌 가드 (실측·내장)

- PK = `(prd_cd, mat_cd, usage_cd)` (3컬럼 복합). REWIRE로 mat_cd가 정본으로 바뀌면 동일 (prd_cd, 정본, usage_cd) 행이 이미 있을 경우 PK 충돌.
- **사전 실측**: 260→250 7행 / 270→343 1행 모두 `canonical_exists=f` → **충돌 0건**.
- apply.sql에 방어적 분기 내장: (a) 충돌 행 = 좀비 링크 `del_yn='Y'`(중복 회피) / (b) 비충돌 행 = 정본 재지정. 실측 충돌 0이라 (a)는 0행 실행, (b)가 8행 전부 처리.

---

## 3. 백업 (undo 가역)

backup.sql 실행 결과:

| 백업 테이블 | 행수 | 내용 |
|---|---|---|
| `bak_t_mat_materials_zombiewire_20260625_053924` | 4 | 008/261/260/270 자재 상태 스냅샷 |
| `bak_t_prd_product_materials_zombiewire_20260625_053924` | 35 | 260=7·270=1·008=23·261=4 배선 행 |

복원 절차 = `undo.sql`(자재 del_yn 원복 + REWIRE 신규행 삭제 + 좀비 배선 재삽입).

---

## 4. DRY-RUN (BEGIN…ROLLBACK · 라이브 무변경 실증)

dryrun.sql 결과 — **전 항목 기대치 정합 PASS**:

| 검증 키 | 기대 | 실측 | 판정 |
|---|---|---|---|
| PRE_dead_4 | 4 | 4 | PASS |
| PRE_zombie_mats / wires | 87 / 175 | 87 / 175 | PASS |
| APPLY1_260 conflict/rewired | 0 / 7 | 0 / 7 | PASS |
| APPLY1_270 conflict/rewired | 0 / 1 | 0 / 1 | PASS |
| APPLY1_revive_008 / 261 | 1 / 1 | 1 / 1 | PASS |
| APPLY2_idempotent_delta | 0 | 0 | PASS (멱등) |
| POST_dead_4_revived | 2 | 2 | PASS |
| **POST_zombie_mats** | **83** | **83** | **PASS (87→83)** |
| POST_wire_260/270_left | 0 / 0 | 0 / 0 | PASS |
| POST_wire_250 / 343 | 8 / 1 | 8 / 1 | PASS |
| POST_pk_dup_250 / 343 | 0 / 0 | 0 / 0 | PASS (중복 0) |
| POST_fk_orphan_wire | 0 | 0 | PASS |
| money_priced_rows | 0 | 0 | PASS (돈 불변) |
| AFTER_ROLLBACK dead_4 / zombie_mats | 4 / 87 | 4 / 87 | PASS (무변경 복귀) |

ROLLBACK 후 좀비 87 원상복귀 → 라이브 무손상·멱등 실증.

---

## 5. 실 COMMIT

backup.sql → apply.sql 순 실행. apply.sql psql 출력:
```
BEGIN
UPDATE 0   -- REWIRE 260 충돌 softdel (0행)
UPDATE 7   -- REWIRE 260 정본 재지정
UPDATE 0   -- REWIRE 270 충돌 softdel (0행)
UPDATE 1   -- REWIRE 270 정본 재지정
UPDATE 1   -- REVIVE 008
UPDATE 1   -- REVIVE 261
COMMIT
```
→ **COMMIT 성공.**

---

## 6. 사후 재실측 (라이브 실측)

| 검증 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 좀비 배선 mats / wires | 83 / 140 | 83 / 140 | PASS (87→83) |
| MAT_000008 / 261 del_yn | N / N | N / N | PASS (부활) |
| MAT_000260 / 270 del_yn | Y / Y | Y / Y | PASS (좀비 자재 미접근·배선만 이동) |
| 260 / 270 잔여 활성 배선 | 0 / 0 | 0 / 0 | PASS |
| 정본 250 / 343 활성 배선 | 8 / 1 | 8 / 1 | PASS |
| PK 중복 250 / 343 | 0 / 0 | 0 / 0 | PASS |
| FK 고아(전체 활성 배선) | 0 | 0 | PASS |
| 4건+정본 직접 단가행 | 0 | 0 | PASS (돈 불변) |
| REVIVE 008 / 261 배선 보존 | 23 / 4 | 23 / 4 | PASS |

견적 골든: REWIRE 영향 mat(260/270/250/343)을 mat_cd 차원/직접 참조하는 component_prices 단가행 0건 → evaluate_price 청구 불변(자명). 단가행 0이므로 가격사슬 미도달.

---

## 7. 경계·롤백 경로

- **4건만 처분.** 83 BLOCKED-CONFIRM(봉제 색/사이즈 라벨 .09 62건·실사 색 .08 5건·표지타입/면지/마감 .01/.02/.06 5건·현수막 추가물 등 .07/.10/.11/.03/.12 11건) **미접근** — W2 옵션화/RC-2/CONFIRM 트랙 의존.
- **멱등**: 재실행 시 REVIVE는 `IS DISTINCT FROM 'N'` 가드로 0행, REWIRE는 좀비 mat_cd 잔존 행만 처리하므로 0행(2차 delta 0 실증).
- **undo 경로**: `_workspace/huni-set-product/07_prereq/zombie-wiring-92/_exec/undo.sql` (백업 테이블 2종 선행 보존됨).

---

## 8. 산출물

| 파일 | 역할 |
|---|---|
| `backup.sql` | 물리 백업 2종(자재 4 + 배선 35) |
| `apply.sql` | 단일 트랜잭션 COMMIT(REWIRE 2 충돌가드 + REVIVE 2 멱등) |
| `dryrun.sql` | BEGIN…ROLLBACK 2-pass 멱등 + 검증 SELECT |
| `undo.sql` | 백업 복원 역연산 |
| `exec-report.md` | 본 리포트 |
