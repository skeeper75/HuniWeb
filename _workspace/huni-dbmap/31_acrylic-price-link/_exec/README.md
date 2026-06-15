# 아크릴 가격사슬 연결 — 적재 실행본 (`_exec/`)

round-5 load-execution 모드. arbiter 확정 설계(`../acrylic-chain-design.md`)를 멱등 SQL + 롤백전용 라이브 DRY-RUN으로 실행본화. **재설계 0 · NEVER COMMIT**(사용자 범위 확정·DRY-RUN까지만).

## 파일

| 파일 | 역할 |
|------|------|
| `gen_load_sql.py` | 생성기 — `data_*.csv` → 멱등 SQL(손편집 금지·재현성 R3) |
| `data_formulas/components/wiring/bindings.csv` | 데이터 명세(provenance 포함) |
| `01_prc_price_formulas.sql` | 공식 4(신규 3·CLR 재현) ON CONFLICT(frm_cd) DO NOTHING |
| `02_prc_price_components.sql` | comp 2(COROTTO·CARABINER) ON CONFLICT(comp_cd) DO NOTHING |
| `03_prc_formula_components.sql` | 배선 3 INSERT(CLR 메타보정 BLOCKED 주석) ON CONFLICT(frm_cd,comp_cd) |
| `04_prd_product_price_formulas.sql` | 바인딩 19(투명15·코롯토3·카라비너1) ON CONFLICT(prd_cd,apply_bgn_ymd) |
| `*.provenance.csv` | 각 INSERT → 설계 출처 추적 |
| `apply.sql` | 트랜잭션 래퍼(BEGIN·FK순·COMMIT/ROLLBACK은 로더 주입) |
| `apply.sh` | psql 로더(기본 DRY-RUN·commit 차단) |
| `manifest.md` | 충돌키·FK순·테이블별 행수·바인딩 상세 |
| `dry-run.md` | 라이브 DRY-RUN 결과(R1 멱등·R5 FK·진화교차·골든) |
| `blocked.md` | BLOCKED 분리(Q-ACR-7/8/9·코롯토/카라비너 단가행) |

## 실행

```bash
./apply.sh           # DRY-RUN (BEGIN…ROLLBACK·기본·아무것도 커밋 안 됨)
./apply.sh dryrun2   # 멱등성 R1 — 2회 적용 후 ROLLBACK
./apply.sh commit    # 차단됨 — 이 트랙은 COMMIT 금지(인간 별도 승인)
```

재생성: `python3 gen_load_sql.py` (같은 CSV → byte-identical SQL).

## 범위 경계

- **적재**: 공식 정의·comp 정의·배선·상품 바인딩까지(가격 골격).
- **미적재(blocked.md)**: 단가행(코롯토/카라비너·라이브 골든 재적재 0)·CLR 메타보정(Q-ACR-7)·미러 바인딩(Q-ACR-9)·후가공 comp·CPQ.
- **다음**: `dbm-validator` R1~R6 게이트 → `03_validation/load-execution-gate.md` GO/NO-GO. 자기승인 아님.
