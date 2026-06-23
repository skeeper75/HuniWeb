# RC-5 실사 아크릴/폼보드 단가 교정 — 실 COMMIT 실행 결과

> hbd-load-executor · 2026-06-23 · §21 catalog-conformance RC-5
> 대상: `t_prc_component_prices` (t_prd 상품 구성요소 단가행) — **기초코드 마스터(t_siz/t_mat) 불변**
> 인간 승인 완료 · dbm-validator R1~R6 GO · 라이브 `db railway`(PostgreSQL 18.4) 단일 트랜잭션 COMMIT
> **상태: COMMIT 완료 · 사후검증 11행 전건 권위 verbatim 일치 · A1 신규행 정착 · A2 불변 · 마스터 불변**

---

## 1. 물리 백업 (undo ground-truth)

- 위치: `_workspace/huni-dbmap/09_load/_rc5_acrylic_foamboard_260623/backup-before-260623.csv`
- 행수: **10행** (142 4행·143 4행·129 2행[A3+A2] — A1은 INSERT 전이라 미존재)
- 떠낸 컬럼: comp_price_id·comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·opt_cd·proc_cd·print_opt_cd·plt_siz_cd·dim_vals·unit_price·reg_dt·upd_dt
- 교정 전 실측값(백업) — undo.sql 원복값과 1:1 정합 확인:

| comp_price_id | comp_cd | 교정 전(백업) | undo 원복값 | 정합 |
|---|---|---|---|---|
| 4792 | GLOSS | 9000 | 9000 | ✅ |
| 4793 | GLOSS | 14000 | 14000 | ✅ |
| 4794 | GLOSS | 32000 | 32000 | ✅ |
| 4795 | GLOSS | 37000 | 37000 | ✅ |
| 4796 | MIRROR | 11000 | 11000 | ✅ |
| 4797 | MIRROR | 18000 | 18000 | ✅ |
| 4798 | MIRROR | 29000 | 29000 | ✅ |
| 4799 | MIRROR | 50000 | 50000 | ✅ |
| 4780 | FOAMBOARD A3 | 7000 | 7000 | ✅ |
| 4781 | FOAMBOARD A2 | 12000 | (불변·undo 미관여) | ✅ |

---

## 2. DRY-RUN 재실행 (진단 비신뢰·직접 실측)

### PASS1 — apply.sql as-is (BEGIN…ROLLBACK)
- UPDATE 1×9 + `INSERT 0 1` = **영향 10행** · ERROR 0 · ROLLBACK 정상.

### PASS2 멱등 — 한 트랜잭션 내 2회 연속 적용 (apply.sql 동일 가드 재현)
- `RAISE NOTICE PASS1 affected=10`
- `RAISE NOTICE PASS2 affected=0`  → **완전 멱등**(재실행 delta 0). 제약위반 0.
- 가드: UPDATE = comp_price_id 핀포인트 + `unit_price IS DISTINCT FROM <권위값>` / INSERT = `NOT EXISTS(comp_cd+siz_cd)`.

### IDENTITY 채번 동작 (MINOR-1 검증)
- COMMIT 직전 실측: **seq last_value=38238 · is_called=t · MAX(comp_price_id)=38231**.
- manifest 기재(38231 동기)는 dry-run nextval 전진 전 시점값이었음(MINOR-1). **현재 seq(38238) > MAX(38231) → 다음 nextval 충돌 0** → 채번 안전(적재 안전성 무영향, 지시대로 진행).
- 실제 INSERT 채번 결과: **comp_price_id = 38239** (정상 단조 증가·충돌 없음).

---

## 3. 실 COMMIT (단일 트랜잭션)

- 방법: apply.sql 원본 불변 보존 · 임시본에서 `ROLLBACK;`→`COMMIT;` 1줄만 전환(`sed`, /tmp, 실행 후 삭제) · `\set ON_ERROR_STOP on` 단일 BEGIN…COMMIT.
- 결과: **UPDATE 1×9 + INSERT 0 1 = 10행 영향 · COMMIT 완료 · ERROR 0 · 부분실패 0**.

---

## 4. 사후검증 — 11행 대조표 (현재값 = 권위값)

| comp_price_id | comp_cd | siz_cd | siz_nm | 현재 unit_price | 권위 verbatim | 일치 |
|---|---|---|---|---|---|---|
| 4792 | GLOSS | SIZ_000324 | 290x90 | **12000** | 12000 | ✅ |
| 4793 | GLOSS | SIZ_000325 | 290x190 | **18000** | 18000 | ✅ |
| 4794 | GLOSS | SIZ_000326 | 390x290 | **28000** | 28000 | ✅ |
| 4795 | GLOSS | SIZ_000327 | 590x390 | **47000** | 47000 | ✅ |
| 4796 | MIRROR | SIZ_000324 | 290x90 | **15000** | 15000 | ✅ |
| 4797 | MIRROR | SIZ_000325 | 290x190 | **22000** | 22000 | ✅ |
| 4798 | MIRROR | SIZ_000326 | 390x290 | **36000** | 36000 | ✅ |
| 4799 | MIRROR | SIZ_000327 | 590x390 | **62000** | 62000 | ✅ |
| 4780 | FOAMBOARD | SIZ_000315 | A3 | **6000** | 6000 (7000→6000) | ✅ |
| 4781 | FOAMBOARD | SIZ_000317 | A2 | **12000** | 12000 (불변) | ✅ A2 불변 (upd_dt=06-15 그대로) |
| 38239 | FOAMBOARD | SIZ_000294 | A1 (594X841) | **20000** | 20000 (신규 INSERT) | ✅ A1 정착 |

- **11행 전건 권위 일치** · 교정 9행 upd_dt=2026-06-23 갱신 · A2(4781) upd_dt 06-15 그대로(미관여 입증).
- A1 신규행: comp_price_id=38239 · apply_ymd=2026-06-01(동형 승계) · note 패턴 승계 · reg_dt=2026-06-23 · 차원 컬럼 NULL(단가형 use_dims=["siz_cd"] 정합).

### 기초코드 마스터 불변
- `t_siz_sizes` SIZ_000294 = A1 (594X841)·cut 594×841·del_yn=N — **불변**(신규/수정 0).
- 폼보드 comp 단가행 총수 = **3행**(A3·A2·A1, 정상). t_mat 미관여.

---

## 5. undo 보유 확인 (실행 안 함)

- `undo.sql` 보유 · 백업 CSV와 정합 검증 완료:
  - UPDATE 원복값 9건 = 백업 교정 전 값과 1:1 일치(§1 표).
  - A1 DELETE = `comp_cd='COMP_POSTER_FOAMBOARD_WHITE' AND siz_cd='SIZ_000294' AND unit_price=20000` 핀포인트 — **comp_price_id 하드코딩 의존 없음**이므로 채번값 38239와 무관하게 정확 삭제. 다른 단가행 불간섭.
- undo 발동 시 라이브를 교정 전 상태로 완전 복원 가능(ground-truth = backup-before-260623.csv).

---

## 6. 게이트 결과 요약

| 게이트 | 결과 |
|---|---|
| 물리 백업 선행 | ✅ 10행 보존 |
| DRY-RUN 멱등 (PASS1=10·PASS2=0) | ✅ |
| 제약위반 | ✅ 0 |
| IDENTITY 채번 정상 동작 | ✅ 38239 충돌 0 |
| 실 COMMIT 단일 트랜잭션 | ✅ 10행 영향 |
| 사후검증 11행 verbatim 일치 | ✅ 11/11 |
| A1 신규행 정착 / A2 불변 | ✅ / ✅ |
| 기초코드 마스터(t_siz/t_mat) 불변 | ✅ |
| undo 보유·정합 | ✅ |
| 부분실패/롤백 | 없음 |

**결론: RC-5 실사 아크릴/폼보드 단가 교정 라이브 COMMIT 완료 · 무손상 입증 · 되돌리지 말 것.**
