# DRY-RUN — rollback-only loadability proof (Gate G6)

Table of contents:
1. Safety rules (HARD)
2. When to DRY-RUN vs local checks
3. The rollback-only procedure
4. Assertion patterns
5. Reading the result

---

## 1. Safety rules (HARD)

- **NEVER COMMIT.** Every DRY-RUN runs inside a single transaction that ends in `ROLLBACK`. Nothing is
  ever written to the live DB by this harness.
- **No DDL, no destructive SQL** outside the rolled-back transaction. No `TRUNCATE`/`ALTER`/`DROP`.
- **Lead authorization required** to run a DRY-RUN (it opens a write transaction even though it rolls
  back). Default to §2 local checks, which need no transaction at all.
- **Credentials only from `.env.local`.** Never echo `$PGPASSWORD`/`RAILWAY_DB_*` to stdout or write
  them into `_workspace/` (git-tracked). Source them into the environment, reference by variable.

## 2. When to DRY-RUN vs local checks

Most gates (G1–G5, G7–G9) are provable with **local computation** against `columns.csv` + read-only
live lookups — no write transaction needed. Prefer these; they are zero-risk and reproducible.

Use the rollback-only DRY-RUN for **G6** specifically: it is the strongest single proof that the bundle
inserts cleanly *in order*, because the DB engine itself checks every type/length/NOT NULL/CHECK/FK/PK
constraint as the rows go in. Run it once the local checks are green, as the final confirmation.

## 3. The rollback-only procedure

```bash
set -a; source .env.local; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -v ON_ERROR_STOP=1"

$PSQL <<'SQL'
BEGIN;

-- Load in manifest order (parents first). \copy streams the CSV client-side.
\copy t_cod_base_codes (cod_grp_cd, cod_cd, cod_nm, ...) FROM '09_load/load/00_xxx.csv' WITH (FORMAT csv, HEADER true)
\copy t_prd_products   (prd_cd, prd_nm, ...)             FROM '09_load/load/01_products.csv' WITH (FORMAT csv, HEADER true)
-- ... each manifest step, in order ...

-- Assertions (see §4) run inside the same transaction, before rollback.

ROLLBACK;   -- nothing is committed, ever
SQL
```

`ON_ERROR_STOP=1` makes the first constraint violation abort the transaction — that abort *is* the G6
signal. Capture the error (table, row, constraint) and report it; the transaction rolls back regardless.

If the engine raises no error through every `\copy` and the explicit assertions, G6 passes: the bundle
is insertable in this order against live constraints. Confirm in the report that `ROLLBACK` ran and
`SELECT count(*)` outside the transaction is unchanged.

## 4. Assertion patterns

Inside the transaction, after the `\copy` steps, assert the things `\copy` alone doesn't surface:

```sql
-- PK / natural-key uniqueness within loaded data (would also fail on real PK, but assert explicitly)
SELECT 'dup prd_cd' AS check, count(*) FROM (
  SELECT prd_cd FROM t_prd_products GROUP BY prd_cd HAVING count(*) > 1
) d;   -- expect 0

-- FK satisfied: every child code resolves to a parent (belt-and-suspenders vs the engine's own FK)
SELECT 'orphan typ_cd' AS check, count(*) FROM t_prd_product_processes p
LEFT JOIN t_cod_base_codes c ON c.cod_cd = p.proc_typ_cd
WHERE p.proc_typ_cd IS NOT NULL AND c.cod_cd IS NULL;   -- expect 0

-- CHECK-style invariants the mapping must honor (example: XOR columns)
SELECT 'rate/amt both set' AS check, count(*) FROM t_dsc_discount_details
WHERE dsc_rate IS NOT NULL AND dsc_amt IS NOT NULL;   -- expect 0  (illustrative; t_dsc_ is round-1)
```

Tailor assertions to the tables actually in the bundle. Each assertion names what it checks and its
expected count (0). A non-zero count is a finding with table/row/constraint evidence.

## 5. Reading the result

- **Clean run + ROLLBACK** → G6 PASS. Record: rows attempted per step, 0 violations, rollback confirmed,
  live row counts unchanged.
- **Engine error mid-`\copy`** → G6 FAIL. The error message gives table + constraint; map it back to the
  source row (use provenance) and route to the builder (order/row) or designer (mapping). Re-gate after fix.
- **Assertion count > 0** → G6 FAIL on that invariant; same routing.

Never paper over a FAIL by removing the offending rows just to make the transaction pass — that violates
G7 (blocked rows must be surfaced, not deleted). A row that can't load is a blocked/GAP item, documented.
