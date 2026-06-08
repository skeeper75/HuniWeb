# price211-direct — 라이브 DRY-RUN *계획* (미실행)

| 항목 | 값 |
|------|----|
| 성격 | **PLAN ONLY** — 실제 DRY-RUN은 **인간 승인 후** dbm-validator/load-builder가 실행. 본 문서는 실행 절차·기대결과·게이트만 기술. |
| 적재 모드 | 롤백 전용(ROLLBACK). COMMIT은 인간 승인 후에만. DDL 0. |
| 대상 | `t_prd_product_prices` 73 INSERTABLE 행(`load.sql`) |

> [HARD] 본 생성 트랙은 라이브 DRY-RUN을 **실행하지 않는다**. 아래는 승인 시 실행할 절차의 *계획*이다.

## 1. 사전조건 (이미 read-only 확인됨)
- 73 prd_cd 전건 `t_prd_products` 선존재 · `t_prd_product_prices` 미존재 · 공식 미바인딩 (`_live/_fkcheck.sql` 공집합).
- PK(prd_cd,apply_ymd) 73 distinct, dup 0. apply_ymd 전건 `2026-06-01`. unit_price 전건 numeric.

## 2. 접속 (비밀번호 미출력)
```
set -a; . ./.env.local; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -v ON_ERROR_STOP=1
```

## 3. DRY-RUN 절차 (승인 시)
1. `load.sql` 실행(끝이 ROLLBACK). 제약위반/FK오류 시 즉시 실패 → 표면화.
2. COMMIT 전 트랜잭션 내 검증:
   - `SELECT count(*) FROM t_prd_product_prices WHERE apply_ymd='2026-06-01';` → 기대 **73**(1패스).
   - FK 고아: `… LEFT JOIN t_prd_products … WHERE p.prd_cd IS NULL` → 기대 **0**.
   - reg_dt 채움: `… WHERE reg_dt IS NULL` → 기대 **0**(DEFAULT now() 발화).
3. ROLLBACK. 영구변경 0 확인.

## 4. 멱등성 2-pass (승인 시)
- pass-1: INSERT 73 (신규).
- pass-2: 동일 SQL 재실행 → ON CONFLICT DO UPDATE, **실변경 행 0**(unit_price/note 동일, upd_dt만 now()). reg_dt 보존.
- IDENTITY 시퀀스 없음(자연키 PK) → round-5 setval stale 트랩 **N/A**.

## 5. R1~R6 게이트 (승인 시 dbm-validator 판정)
| 게이트 | 기대 |
|--------|------|
| R1 제약위반 0 | PASS (PK/FK/NOT NULL/numeric 사전충족) |
| R2 FK 고아 0 | PASS (73/73 부모 선존재) |
| R3 멱등 2-pass | PASS (2패스 실변경 0) |
| R4 COMMIT 0 | PASS (ROLLBACK 종료) |
| R5 IDENTITY 정합 | N/A (자연키 PK, 시퀀스 없음) |
| R6 역대조(source diff 0) | PASS 기대 (73 단가 = 엑셀 셀값 verbatim) |

## 6. 본 트랙 비실행 사유
생성·검증 분리(R6 원칙). 라이브 DRY-RUN은 인간 승인 게이트이며, 생성자(designer)가 자가 DRY-RUN 시 over-claim 위험 → validator 독립 실행으로 분리.
