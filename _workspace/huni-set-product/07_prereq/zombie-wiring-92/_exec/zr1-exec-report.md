# 좀비 배선 정리 W1-2 — ZR-1 REVIVE 9건 라이브 COMMIT 실행 리포트

생성: §23 huni-set-product `07_prereq/zombie-wiring-92/_exec` · 라이브 Railway DB(`db railway`, 비표준 포트) · 인간 승인 완료(사용자 AskUserQuestion "지금 실행" 직접 선택)
권위: del_yn 논리삭제 권위([[dbmap-del-yn-soft-delete-authority]]) + disposition-rev2.csv(REVIVE 9 재처분) + audit-rev2.md + codex-reconcile.md(81/83 합의·신규 0·환각 0)
원칙[HARD]: search-before-mint(신규 mint 0) · 비파괴(물리 DELETE 0·DDL 0) · 멱등 · 단일 트랜잭션

> **결론 한 줄**: rev2 REVIVE 9건(MAT_000069·070·337·338·340·244·245·154·262 del_yn 'Y'→'N' 부활) **COMMIT 성공**. 좀비 배선 **83→74**(wires 140→128). 깨진 옵션 참조 무결성 **11→0** 복구. 직접 단가행 0 → **청구 불변(0원)**. OPTIONIZE 67·BLOCKED 7·돈변동 2(192·154 REWIRE) 미접근.

---

## 1. 실행 대상 9건 (REVIVE only)

| # | mat_cd | mat_nm | mat_typ | 부활 사유 | 배선 |
|---|---|---|---|---|---|
| 1 | MAT_000069 | 양면테입 | .07 | 활성 opt_item ref_key1(OPV_000010) 참조 중 | — |
| 2 | MAT_000070 | 끈 | .07 | 활성 opt_item ref(OPV_000014/015/016) | — |
| 3 | MAT_000337 | 큐방 | .07 | 활성 opt_item ref(OPV_000013)·RC-2 자재축 누락 | — |
| 4 | MAT_000338 | 각목 | .07 | 활성 opt_item ref(OPV_000015/016)·RC-2 자재축 누락 | — |
| 5 | MAT_000340 | 봉제사 | .07 | 활성 opt_item ref(OPV_000011) | — |
| 6 | MAT_000244 | 유광투명커버 | .02 | 마감 옵션화 완료·자재만 삭제 | — |
| 7 | MAT_000245 | 무광투명커버 | .02 | 마감 옵션화 완료·자재만 삭제 | — |
| 8 | MAT_000154 | 유포지 | .11 | 옵션 ref가 154 직접 참조 | — |
| 9 | MAT_000262 | 무광 75mm | .12 | 틴거울·컴팩트거울 본체 dflt 사입자재·정본부재·본질소재 | — |

★전 9건 component_prices 단가행 0 → 돈영향 0(청구 불변). 1~8 = 깨진 옵션 참조 무결성 복구(총 11참조), 9 = 정본부재 본질소재.

---

## 2. 백업 (undo 가역)

| 백업 테이블 | 행수 | 내용 |
|---|---|---|
| `bak_t_mat_materials_zr1revive_20260625_055716` | 9 | 9건 자재 교정 전 상태(전부 del_yn='Y') 스냅샷 |

복원 = `zr1-undo.sql`(백업에서 del_yn/del_dt 원값 복귀).

---

## 3. DRY-RUN (BEGIN…ROLLBACK · 라이브 무변경 실증)

| 검증 키 | 기대 | 실측 | 판정 |
|---|---|---|---|
| PRE_dead_9 | 9 | 9 | PASS |
| PRE_zombie_mats / wires | 83 / 140 | 83 / 140 | PASS |
| PRE_broken_opt_ref | 11 | 11 | PASS |
| APPLY1_revived | 9 | 9 | PASS |
| APPLY2_idempotent_delta | 0 | 0 | PASS (멱등) |
| POST_active_9 | 9 | 9 | PASS |
| **POST_zombie_mats** | **74** | **74** | **PASS (83→74)** |
| POST_zombie_wires | 128 | 128 | PASS |
| POST_broken_opt_ref | 0 | 0 | PASS (무결성 복구) |
| money_priced_rows | 0 | 0 | PASS (돈 불변) |
| AFTER_ROLLBACK dead_9 / zombie_mats | 9 / 83 | 9 / 83 | PASS (무변경 복귀) |

ROLLBACK 후 좀비 83 원상복귀 → 라이브 무손상·멱등 실증.

---

## 4. 실 COMMIT

zr1-backup.sql → zr1-apply.sql 순. psql 출력:
```
=== BACKUP ===
DROP TABLE / SELECT 9 (bak_zr1revive rows=9)
=== APPLY (COMMIT) ===
BEGIN
UPDATE 9
COMMIT
```
→ **COMMIT 성공.**

---

## 5. 사후 재실측 (라이브 실측)

| 검증 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 좀비 배선 mats / wires | 74 / 128 | 74 / 128 | PASS (83→74) |
| 9건 부활(del_yn=N) | 9 | 9 | PASS |
| 깨진 옵션 참조(삭제자재 ref) | 0 | 0 | PASS (11→0) |
| 백업 행(undo 가역) | 9 | 9 | PASS |
| 직접 단가행 | 0 | 0 | PASS (돈 불변) |

---

## 6. 경계·롤백 경로

- **REVIVE 9건만 처분.** OPTIONIZE 67(.09 라벨 62·.08 색 5)·BLOCKED 7·돈변동 2(투명아크릴192 두께미특정·유포지154→153 REWIRE) **미접근** — W2 옵션화/실무진 확인큐 의존.
- **멱등**: 재실행 시 `del_yn IS DISTINCT FROM 'N'` 가드로 0행.
- **undo 경로**: `zr1-undo.sql`(백업 테이블 `bak_t_mat_materials_zr1revive_20260625_055716` 선행 보존됨).
- codex 보강 메모: 홀로그램/골드/실버/글리터류(OPTIONIZE 67 일부)는 단순 색 라벨이 아니라 특수 원단·필름일 수 있어 W2 옵션화 시 소재/효과축 분리 검토(역방향 false-positive 가드).

---

## 7. 산출물

| 파일 | 역할 |
|---|---|
| `zr1-backup.sql` | 물리 백업(자재 9행) |
| `zr1-apply.sql` | 단일 트랜잭션 COMMIT(REVIVE 9 멱등) |
| `zr1-dryrun.sql` | BEGIN…ROLLBACK 2-pass 멱등 + 검증 SELECT |
| `zr1-undo.sql` | 백업 복원 역연산 |
| `zr1-exec-report.md` | 본 리포트 |
