# 상품마스터 적재 실행본 — `_exec/` (round-5)

round-4 GO 적재본(`09_load/_assembled/`)을 멱등 실행 SQL + 로더로 완성한 산출물.

- **실행 계획·충돌키·제외 항목:** `load-exec-manifest.md` (권위)
- **충돌키의 라이브 제약 근거:** `constraints-live.md`
- **생성기(재현):** `gen_load_sql.py` → `python3 gen_load_sql.py`
- **트랜잭션 래퍼:** `apply.sql`
- **로더(기본 DRY-RUN/롤백):** `./apply.sh` (commit은 인간 승인: `./apply.sh commit`)
- **per-row provenance:** `*.provenance.csv`

## 핵심

- 즉시 적재 384행 + 코드행 선적재 11행 + update-set 289행(실행가능분).
- 전 INSERT `ON CONFLICT (PK) DO NOTHING`, 전 UPDATE 멱등(IS DISTINCT FROM/PK 키변경). 재실행 안전.
- 단일 트랜잭션(`BEGIN`+`ON_ERROR_STOP`) — 전부 아니면 전무. 기본 모드 = 롤백.
- **실제 COMMIT·DDL은 인간 승인.** 본 트랙은 산출 + 롤백 DRY-RUN까지. 검증은 `dbm-validator`(R1~R6).

## 비밀값

`.env.local`(chmod 600·gitignore)의 `RAILWAY_DB_*`만 사용. `_workspace`·stdout에 비밀값 기록 0.
