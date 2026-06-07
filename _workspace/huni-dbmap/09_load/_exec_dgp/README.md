# _exec_dgp — 디지털인쇄 가격엔진 적재 실행본 (round-5)

검증 GO 적재본 → 라이브 `t_*` 멱등 적재 SQL/로더. **DB COMMIT·DDL·siz채번 없음**(인간 승인 대기).

## 파일

| 파일 | 역할 |
|------|------|
| `gen_load_sql.py` | CSV → 멱등 SQL 생성기(재현성·손편집 금지). `python3 gen_load_sql.py` 로 01~05 + provenance 재생성 |
| `apply.sql` | 단일 트랜잭션 래퍼(BEGIN…COMMIT, 01~05 `\i` FK순) |
| `apply.sh` | psql 로더 — 기본 DRY-RUN(롤백), `--commit` 인간 승인 |
| `01_t_prc_price_formulas.sql` | 공식 헤더 6 (ON CONFLICT frm_cd) |
| `02_t_prc_price_components.sql` | COMP_PAPER 1 (ON CONFLICT comp_cd) |
| `03_t_prc_formula_components.sql` | 배선 72 (ON CONFLICT frm_cd,comp_cd) |
| `04_t_prc_component_prices.sql` | 용지비 49 (WHERE NOT EXISTS IS NOT DISTINCT FROM) |
| `05_t_prd_product_price_formulas.sql` | 바인딩 19 (ON CONFLICT prd_cd,frm_cd) |
| `backup.sh` / `backup.sql` | 적재 전 before-state 캡처(read-only) |
| `undo.sh` / `undo.sql` | 역연산 — 신규키 한정 DELETE(FK 역순) |
| `migrate.provenance.csv` | per-row 출처(sql_file→source_csv:row→natural_key) |
| `MIGRATION.md` | 적재 내용·행수·순서·멱등 가드·롤백·DRY-RUN 상세 |

## 빠른 실행

```bash
./backup.sh          # before-state (권장 선행)
./apply.sh           # DRY-RUN (롤백, DB 무변경)
./apply.sh           # 2회차 — 멱등성 확인(2회차 0행)
./apply.sh --commit  # 실제 적재 (인간 승인)
```

## 요약

- 총 **147행**: formulas 6 + components 1 + formula_components 72 + component_prices 49 + bindings 19.
- 신규 mint: **PRF_DGP_A~F(6) + COMP_PAPER(1)** 코드행뿐. 신규 siz/mat/DDL 0.
- 멱등: 4테이블 ON CONFLICT(PK) + 용지비 WHERE NOT EXISTS(NULLS DISTINCT 회피).
- 검증은 dbm-validator 가 R1~R6 + 라이브 DRY-RUN 으로 수행(자기승인 금지).
