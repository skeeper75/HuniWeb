# RC-5 라이브 DRY-RUN 실행 결과

> dbm-load-builder · 2026-06-23 · `BEGIN … ROLLBACK` 트랜잭션 DRY-RUN (라이브 불변 입증)
> 자격: `.env.local RAILWAY_DB_*` (읽기전용 SELECT + 롤백 트랜잭션). **COMMIT 없음.**
> 대상: `t_prc_component_prices` UPDATE 9 + INSERT 1.

---

## 1. R3 구문 파싱 (apply.sql / undo.sql)

`psql -v ON_ERROR_STOP=1 -f apply.sql` → 구문 오류 0, ROLLBACK 클린 종료.
- apply.sql: `UPDATE 1 ×9`, `INSERT 0 1`, `ROLLBACK`
- undo.sql: `UPDATE …`, `DELETE 0`(현 라이브 A1행 부재라 정상), `ROLLBACK`

## 2. 영향행수 (PASS1 적용)

| 작업군 | 기대 | 실측 |
|---|---|---|
| UPDATE (GLOSS 4 + MIRROR 4 + FOAM A3 1) | 9 | **9** (UPDATE 1 ×9) |
| INSERT (A1 NOT EXISTS) | 1 | **1** (INSERT 0 1) |

### 교정 후 종단 11행 값 (PASS1)
| comp_price_id | comp_cd | siz_cd | apply_ymd | unit_price |
|---|---|---|---|---|
| 4792 | GLOSS | SIZ_000324 | 2026-06-01 | 12000 |
| 4793 | GLOSS | SIZ_000325 | 2026-06-01 | 18000 |
| 4794 | GLOSS | SIZ_000326 | 2026-06-01 | 28000 |
| 4795 | GLOSS | SIZ_000327 | 2026-06-01 | 47000 |
| 4796 | MIRROR | SIZ_000324 | 2026-06-01 | 15000 |
| 4797 | MIRROR | SIZ_000325 | 2026-06-01 | 22000 |
| 4798 | MIRROR | SIZ_000326 | 2026-06-01 | 36000 |
| 4799 | MIRROR | SIZ_000327 | 2026-06-01 | 62000 |
| 4780 | FOAM | SIZ_000315 (A3) | 2026-06-01 | 6000 |
| 4781 | FOAM | SIZ_000317 (A2) | 2026-06-01 | 12000 (불변·권위 일치) |
| **38233** | FOAM | SIZ_000294 (A1) | 2026-06-01 | **20000** (신규 INSERT) |

→ 11행 전부 권위 verbatim 일치. A2(4781) 손대지 않음 확인. 신규 A1행 IDENTITY 채번(DRY-RUN 트랜잭션 내 38233, 실 적용 시 당시 seq next).

## 3. 멱등성 (R1) — 2-pass 결과

| Pass | UPDATE | INSERT |
|---|---|---|
| PASS1 (적용) | **UPDATE 1 ×9** | **INSERT 0 1** |
| PASS2 (재실행) | **UPDATE 0 ×9** | **INSERT 0 0** |

→ 2회차 영향행 0. `IS DISTINCT FROM` UPDATE 가드 + `NOT EXISTS` INSERT 가드로 **완전 멱등**. A1행 count=1(중복 0·이중계상 0).

## 4. 제약위반 (R5) — 0건

| 제약 | 결과 |
|---|---|
| FK siz_cd → t_siz_sizes (SIZ_000294 등) | 위반 0 (전건 기존재) |
| FK comp_cd → t_prc_price_components | 위반 0 |
| NOT NULL (comp_cd·apply_ymd·reg_dt) | 위반 0 (apply_ymd 채움·reg_dt DEFAULT now()) |
| PK (comp_price_id IDENTITY) | 위반 0 (채번 정상·seq 동기) |
| CHECK | 해당 없음(제약 0건) |

INSERT `0 1` 성공 = 모든 제약 통과. 트랜잭션 전체 ROLLBACK으로 라이브 불변.

## 5. apply_ymd 이중계상 함정 점검

A1 INSERT의 apply_ymd=`2026-06-01` = 기존 폼보드 행(4780/4781)과 동일 적용일 → **적용일 분기 없음**. evaluate_price가 동일 apply_ymd 단가행으로 일관 매칭하므로 이중계상 위험 0.

## 6. 종합

| 게이트 | 결과 |
|---|---|
| R3 구문/실행 | PASS (구문오류 0·클린 ROLLBACK) |
| R1 멱등 | PASS (PASS2 영향행 0) |
| R5 제약위반 | PASS (FK·NOT NULL·PK 위반 0) |
| 단가 verbatim | PASS (11행 권위 1:1·날조 0) |
| 라이브 불변 | PASS (전체 ROLLBACK) |

**빌더 종합: DRY-RUN 클린 통과. dbm-validator R1~R6 독립 게이트로 이관(빌더 self-approve 금지).** GO 시 인간 승인 후 hbd-load-executor가 COMMIT 적용.
