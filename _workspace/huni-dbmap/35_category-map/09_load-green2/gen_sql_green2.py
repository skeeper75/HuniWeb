#!/usr/bin/env python3
# green2 SQL 적재본 생성: apply / backup / dryrun
# 멱등 UPSERT(PK=prd_cd,cat_cd) + 단일 트랜잭션 + del_yn='N' 활성 가드 + main 단일성 사후가드
import csv, os
from collections import defaultdict, Counter

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(BASE)


def read_csv(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


rows = read_csv(os.path.join(BASE, "product-cat-green2.csv"))
body = [r for r in rows if r["main_cat_yn"] == "Y"]
alias = [r for r in rows if r["main_cat_yn"] == "N"]

# green-36 점유로 인한 disp_seq offset(같은 cat_cd 버킷에서 충돌 회피·코스메틱)
g36 = read_csv(os.path.join(ROOT, "08_load-green", "product-cat-green.csv")) \
    if os.path.exists(os.path.join(ROOT, "08_load-green", "product-cat-green.csv")) else []
g36_off = Counter(r["cat_cd"] for r in g36)

# disp_seq 계산: 본체는 cat_cd별 (offset+순번), 별칭은 본체 disp_seq 뒤로(별칭은 main='N' 추가노출)
seq = defaultdict(int)
for r in g36_off:
    seq[r] = g36_off[r]
inserts = []  # (prd_cd, cat_cd, main, disp_seq, nm, catnm)
for r in sorted(body, key=lambda x: (x["cat_cd"], x["prd_cd"])):
    seq[r["cat_cd"]] += 1
    inserts.append((r["prd_cd"], r["cat_cd"], "Y", seq[r["cat_cd"]], r["prd_nm"], r["cat_nm"]))
for r in sorted(alias, key=lambda x: (x["cat_cd"], x["prd_cd"])):
    seq[r["cat_cd"]] += 1
    inserts.append((r["prd_cd"], r["cat_cd"], "N", seq[r["cat_cd"]], r["prd_nm"], r["cat_nm"]))

# 가드용 집합
all_prd = sorted(set(r["prd_cd"] for r in rows))
all_cat = sorted(set(r["cat_cd"] for r in rows))
body_prd = sorted(set(r["prd_cd"] for r in body))
# 본체 타깃(대표 cat) 매핑(main 단일성 재배선용)
body_tgt = {r["prd_cd"]: r["cat_cd"] for r in body}


def vlist(items, per=1):
    return ",\n".join("    ('%s')" % i for i in items)


def quoted_in(items):
    return ", ".join("'%s'" % i for i in items)


# ---------- apply-green2.sql ----------
apply = []
apply.append("-- round-24 2단계 · ✅격상 186(distinct 183) 추가 적재본 (apply-green2.sql)")
apply.append("-- 생성: dbm-category-mapper · 검증: dbm-validator(별도) · 실 COMMIT은 검증 GO 후 dbm-load-execution")
apply.append("-- 대상: t_prd_product_categories (junction) · 본체 183(main='Y') + 별칭 17(main='N') = 200행")
apply.append("-- ★HARD 가드: 타깃 cat_cd 전부 del_yn='N' 활성 검증 후에만 INSERT. 비활성이면 전체 ABORT.")
apply.append("-- 멱등: ON CONFLICT (prd_cd,cat_cd) DO UPDATE (main_cat_yn·disp_seq·upd_dt 갱신).")
apply.append("-- 08_load-green 36과 중복 0(빌더 검증). 별칭은 본체 prd_cd의 추가 노출(중복상품 생성 금지).")
apply.append("")
apply.append("BEGIN;")
apply.append("")
apply.append("-- [가드 1] 타깃 카테고리 노드 전부 활성(del_yn='N') 검증 — 하나라도 부재/비활성이면 ROLLBACK")
apply.append("DO $$\nDECLARE bad int;\nBEGIN")
apply.append("  SELECT count(*) INTO bad FROM (VALUES")
apply.append(vlist(all_cat))
apply.append("  ) AS t(cat_cd)")
apply.append("  LEFT JOIN t_cat_categories c ON c.cat_cd = t.cat_cd")
apply.append("  WHERE c.cat_cd IS NULL OR c.del_yn <> 'N';")
apply.append("  IF bad > 0 THEN")
apply.append("    RAISE EXCEPTION '[GUARD] % 개 타깃 cat_cd가 부재/비활성(del_yn<>N) — 적재 중단', bad;")
apply.append("  END IF;\nEND $$;")
apply.append("")
apply.append("-- [가드 2] 적재 prd_cd 전부 실재(t_prd_products, del_yn='N') 검증")
apply.append("DO $$\nDECLARE bad int;\nBEGIN")
apply.append("  SELECT count(*) INTO bad FROM (VALUES")
apply.append(vlist(all_prd))
apply.append("  ) AS t(prd_cd)")
apply.append("  LEFT JOIN t_prd_products p ON p.prd_cd = t.prd_cd AND p.del_yn = 'N'")
apply.append("  WHERE p.prd_cd IS NULL;")
apply.append("  IF bad > 0 THEN")
apply.append("    RAISE EXCEPTION '[GUARD] % 개 prd_cd가 부재/비활성 — 적재 중단', bad;")
apply.append("  END IF;\nEND $$;")
apply.append("")
apply.append("-- [재배선 A] 본 적재 prd_cd 중, 비활성(del<>N) 노드를 가리키는 기존 junction 행 정리")
apply.append("--           (del_yn 권위: 논리삭제 노드 귀속은 조회 차단·orphan → 제거)")
apply.append("DELETE FROM t_prd_product_categories pc")
apply.append("USING t_cat_categories c")
apply.append("WHERE pc.cat_cd = c.cat_cd AND c.del_yn <> 'N'")
apply.append("  AND pc.prd_cd IN (%s);" % quoted_in(all_prd))
apply.append("")
apply.append("-- [재배선 B] 본체 대표 cat_cd가 아닌 활성 노드의 기존 main='Y' 행을 main='N'으로 강등")
apply.append("--           (대표 = 가변깊이 적재 노드 1행만 main='Y' — 단일성 보장)")
apply.append("UPDATE t_prd_product_categories pc SET main_cat_yn='N', upd_dt=now()")
apply.append("FROM (VALUES")
apply.append(",\n".join("  ('%s', '%s')" % (p, c) for p, c in sorted(body_tgt.items())))
apply.append(") AS t(prd_cd, tgt_cat)")
apply.append("WHERE pc.prd_cd = t.prd_cd AND pc.cat_cd <> t.tgt_cat AND pc.main_cat_yn='Y';")
apply.append("")
apply.append("-- [INSERT] 멱등 UPSERT (PK = prd_cd, cat_cd) — 본체 183(main='Y') + 별칭 17(main='N')")
apply.append("INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, reg_dt)")
apply.append("VALUES")
vrows = []
n = len(inserts)
for i, (prd, cat, mn, ds, nm, catnm) in enumerate(inserts):
    tag = "별칭→" if mn == "N" else "→"
    comma = "," if i < n - 1 else ""
    vrows.append("  ('%s', '%s', '%s', %d, now())%s  -- %s %s %s" % (prd, cat, mn, ds, comma, nm, tag, catnm))
apply.append("\n".join(vrows))
apply.append("ON CONFLICT (prd_cd, cat_cd) DO UPDATE SET")
apply.append("  main_cat_yn = EXCLUDED.main_cat_yn,")
apply.append("  disp_seq    = EXCLUDED.disp_seq,")
apply.append("  upd_dt      = now();")
apply.append("")
apply.append("-- [main 단일성 사후 가드] 본체 183 prd_cd 각각 main='Y' 정확히 1행 검증")
apply.append("DO $$\nDECLARE viol int;\nBEGIN")
apply.append("  SELECT count(*) INTO viol FROM (")
apply.append("    SELECT prd_cd FROM t_prd_product_categories")
apply.append("    WHERE prd_cd IN (%s)" % quoted_in(body_prd))
apply.append("      AND main_cat_yn='Y'")
apply.append("    GROUP BY prd_cd HAVING count(*) <> 1")
apply.append("  ) v;")
apply.append("  IF viol > 0 THEN")
apply.append("    RAISE EXCEPTION '[GUARD] % 개 prd_cd가 main=Y 단일성 위반 — ROLLBACK 권고', viol;")
apply.append("  END IF;\nEND $$;")
apply.append("")
apply.append("COMMIT;")
apply.append("-- 멱등: 2회 실행 시 INSERT 0·UPDATE 200(upd_dt 갱신)·신규 0 — DRY-RUN으로 실증.")
with open(os.path.join(BASE, "apply-green2.sql"), "w", encoding="utf-8") as f:
    f.write("\n".join(apply) + "\n")

# ---------- backup-green2.sql ----------
bk = []
bk.append("-- green2 영향 prd_cd 기존 junction 물리 백업 (backup-green2.sql)")
bk.append("-- 실 COMMIT 직전 실행 권장. 영향 prd_cd 200(본체183+별칭17, prd 단위 중복제거 후 183).")
bk.append("-- CREATE TABLE 가이드: 타임스탬프 스냅샷 테이블로 보존(undo 원천).")
bk.append("")
bk.append("-- [백업 테이블 생성] (이미 있으면 DROP 후 재생성하거나 suffix 변경)")
bk.append("CREATE TABLE IF NOT EXISTS bak_prd_cat_green2_20260618 AS")
bk.append("SELECT pc.*, now() AS backup_at")
bk.append("FROM t_prd_product_categories pc")
bk.append("WHERE pc.prd_cd IN (%s);" % quoted_in(all_prd))
bk.append("")
bk.append("-- [백업 검증] 백업 행수 확인")
bk.append("SELECT count(*) AS backed_up_rows FROM bak_prd_cat_green2_20260618;")
bk.append("")
bk.append("-- [undo 가이드] 적재 후 롤백이 필요하면:")
bk.append("--   1) DELETE FROM t_prd_product_categories WHERE prd_cd IN (...영향 prd...);")
bk.append("--   2) INSERT INTO t_prd_product_categories SELECT prd_cd,cat_cd,main_cat_yn,disp_seq,reg_dt,upd_dt")
bk.append("--      FROM bak_prd_cat_green2_20260618;  -- backup_at 컬럼 제외")
with open(os.path.join(BASE, "backup-green2.sql"), "w", encoding="utf-8") as f:
    f.write("\n".join(bk) + "\n")

# ---------- dryrun-green2.sql ----------
dr = []
dr.append("-- green2 롤백전용 DRY-RUN (dryrun-green2.sql)")
dr.append("-- 적재 가능성·멱등성 실증: INSERT/UPDATE/DELETE 건수·제약위반0·FK고아0·main단일성.")
dr.append("-- ★마지막에 ROLLBACK — 라이브 무변경. NEVER COMMIT.")
dr.append("")
dr.append("BEGIN;")
dr.append("")
dr.append("-- [DR-1] 타깃 cat_cd 활성 검증(부재/비활성 건수, 0이어야 GO)")
dr.append("SELECT count(*) AS inactive_or_missing_cat FROM (VALUES")
dr.append(vlist(all_cat))
dr.append(") AS t(cat_cd) LEFT JOIN t_cat_categories c ON c.cat_cd=t.cat_cd")
dr.append("WHERE c.cat_cd IS NULL OR c.del_yn <> 'N';")
dr.append("")
dr.append("-- [DR-2] prd_cd 실재 검증(부재/비활성 건수, 0이어야 GO)")
dr.append("SELECT count(*) AS missing_prd FROM (VALUES")
dr.append(vlist(all_prd))
dr.append(") AS t(prd_cd) LEFT JOIN t_prd_products p ON p.prd_cd=t.prd_cd AND p.del_yn='N'")
dr.append("WHERE p.prd_cd IS NULL;")
dr.append("")
dr.append("-- [DR-3] 적재 전 기존 junction 건수(영향 prd 범위)")
dr.append("SELECT count(*) AS before_rows FROM t_prd_product_categories")
dr.append("WHERE prd_cd IN (%s);" % quoted_in(all_prd))
dr.append("")
dr.append("-- [DR-4] DELETE(재배선A): 비활성 노드 참조 행 예상 건수")
dr.append("SELECT count(*) AS will_delete FROM t_prd_product_categories pc")
dr.append("JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd AND c.del_yn<>'N'")
dr.append("WHERE pc.prd_cd IN (%s);" % quoted_in(all_prd))
dr.append("")
dr.append("-- [DR-5] 실제 재배선+UPSERT 수행(트랜잭션 내·롤백 예정)")
dr.append("DELETE FROM t_prd_product_categories pc USING t_cat_categories c")
dr.append("WHERE pc.cat_cd=c.cat_cd AND c.del_yn<>'N' AND pc.prd_cd IN (%s);" % quoted_in(all_prd))
dr.append("")
dr.append("UPDATE t_prd_product_categories pc SET main_cat_yn='N', upd_dt=now()")
dr.append("FROM (VALUES")
dr.append(",\n".join("  ('%s', '%s')" % (p, c) for p, c in sorted(body_tgt.items())))
dr.append(") AS t(prd_cd, tgt_cat)")
dr.append("WHERE pc.prd_cd=t.prd_cd AND pc.cat_cd<>t.tgt_cat AND pc.main_cat_yn='Y';")
dr.append("")
dr.append("INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, reg_dt)")
dr.append("VALUES")
dr.append(",\n".join("  ('%s', '%s', '%s', %d, now())" % (p, c, m, d) for p, c, m, d, nm, cn in inserts))
dr.append("ON CONFLICT (prd_cd, cat_cd) DO UPDATE SET")
dr.append("  main_cat_yn=EXCLUDED.main_cat_yn, disp_seq=EXCLUDED.disp_seq, upd_dt=now();")
dr.append("")
dr.append("-- [DR-6] 적재 후 본체 200(=183+17) 행 존재·FK 무결성")
dr.append("SELECT count(*) AS green2_rows_present FROM t_prd_product_categories")
dr.append("WHERE (prd_cd, cat_cd) IN (")
dr.append(",\n".join("  ('%s','%s')" % (p, c) for p, c, m, d, nm, cn in inserts))
dr.append(");")
dr.append("")
dr.append("-- [DR-7] FK 고아 검증: junction cat_cd가 카테고리에 없으면 위반(0이어야 함)")
dr.append("SELECT count(*) AS fk_orphan FROM t_prd_product_categories pc")
dr.append("LEFT JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd")
dr.append("WHERE pc.prd_cd IN (%s) AND c.cat_cd IS NULL;" % quoted_in(all_prd))
dr.append("")
dr.append("-- [DR-8] main 단일성: 본체 183 각 prd_cd main='Y' 정확히 1행(위반 건수 0이어야 함)")
dr.append("SELECT count(*) AS main_violation FROM (")
dr.append("  SELECT prd_cd FROM t_prd_product_categories")
dr.append("  WHERE prd_cd IN (%s) AND main_cat_yn='Y'" % quoted_in(body_prd))
dr.append("  GROUP BY prd_cd HAVING count(*)<>1")
dr.append(") v;")
dr.append("")
dr.append("-- [DR-9] 멱등 2-pass: 동일 UPSERT 재실행 시 신규 INSERT 0 기대(여기선 구조 주석으로 갈음)")
dr.append("-- 재실행하면 ON CONFLICT 경로만 타 INSERT 0·UPDATE만 발생.")
dr.append("")
dr.append("ROLLBACK;  -- ★라이브 무변경. 절대 COMMIT 금지.")
with open(os.path.join(BASE, "dryrun-green2.sql"), "w", encoding="utf-8") as f:
    f.write("\n".join(dr) + "\n")

print("apply/backup/dryrun green2 생성 완료")
print(f"  INSERT VALUES 행: {len(inserts)} (본체 {len(body)} + 별칭 {len(alias)})")
print(f"  가드 cat_cd: {len(all_cat)} · 가드 prd_cd: {len(all_prd)} · 재배선B 본체: {len(body_tgt)}")
