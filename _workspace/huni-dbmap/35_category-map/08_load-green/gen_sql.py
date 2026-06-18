#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
product-cat-green.csv → 멱등 적재본 3종 생성(apply / backup / dryrun).
DB 미적재 — SQL 텍스트 생성만. 실 COMMIT은 다음 단계(검증 GO 후).
"""
import csv, os

BASE = os.path.dirname(os.path.abspath(__file__))
rows = []
with open(os.path.join(BASE, "product-cat-green.csv"), encoding="utf-8-sig") as f:
    rows = list(csv.DictReader(f))

# 적재 행: prd_cd 비공백만 (GREEN 36 전부 비공백)
rows = [r for r in rows if r["prd_cd"]]
# disp_seq: 카테고리별 등장 순서(노출 순서) — 안정 정렬
from collections import defaultdict
seq = defaultdict(int)
for r in sorted(rows, key=lambda x: (x["cat_cd"], x["prd_cd"])):
    seq[r["cat_cd"]] += 1
    r["disp_seq"] = seq[r["cat_cd"]]

prd_list = sorted({r["prd_cd"] for r in rows})
cat_list = sorted({r["cat_cd"] for r in rows})


def sql_str(s):
    return "'" + (s or "").replace("'", "''") + "'"


# 본 적재의 (prd_cd -> 대표 cat_cd) 맵. GREEN은 전부 main='Y' 1행.
prd_target = {r["prd_cd"]: r["cat_cd"] for r in rows if r["main_cat_yn"] == "Y"}
prd_pairs = sorted(prd_target.items())


def rebalance_lines():
    """재배선: 본 적재로 대표(main='Y')가 바뀌는 상품의 기존 junction 정합화.
    (A) del='Y'(비활성) 노드를 가리키는 기존 행 DELETE — del_yn 권위 정리(orphan).
    (B) 본 적재 대표 cat_cd가 아닌 다른 활성 노드 기존 행은 main='N'으로 강등(다중분류 노출 유지).
    → 결과적으로 prd_cd당 main='Y' 정확히 1행(본 적재 deeper 노드)."""
    lines = [
        "-- [재배선 A] 본 적재 36 prd_cd 중, 비활성(del='Y') 노드를 가리키는 기존 junction 행 정리",
        "--           (del_yn 권위: 논리삭제 노드 귀속은 조회 차단·orphan → 제거)",
        "DELETE FROM t_prd_product_categories pc",
        "USING t_cat_categories c",
        "WHERE pc.cat_cd = c.cat_cd AND c.del_yn <> 'N'",
        "  AND pc.prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ");",
        "",
        "-- [재배선 B] 본 적재 대표 cat_cd가 아닌 활성 노드 기존 행은 main='N'으로 강등",
        "--           (대표는 가변깊이 적재 노드 1행만 main='Y' — 단일성 보장)",
        "UPDATE t_prd_product_categories pc SET main_cat_yn='N', upd_dt=now()",
        "FROM (VALUES",
    ]
    lines += ["  (" + sql_str(p) + ", " + sql_str(c) + ")" + ("," if i < len(prd_pairs) - 1 else "")
              for i, (p, c) in enumerate(prd_pairs)]
    lines += [
        ") AS t(prd_cd, tgt_cat) ",
        "WHERE pc.prd_cd = t.prd_cd AND pc.cat_cd <> t.tgt_cat AND pc.main_cat_yn='Y';",
        "",
    ]
    return lines


# ============ apply-green.sql ============
apply_lines = [
    "-- round-24 2단계 · ✅GREEN 36 멱등 적재본 (apply-green.sql)",
    "-- 생성: dbm-category-mapper · 검증: dbm-validator(별도) · 실 COMMIT은 검증 GO 후 dbm-load-execution",
    "-- 대상: t_prd_product_categories (junction) · GREEN 36 본체(main='Y')",
    "-- ★HARD 가드: 타깃 cat_cd 전부 del_yn='N' 활성 검증 후에만 INSERT. 비활성이면 전체 ABORT.",
    "-- 멱등: ON CONFLICT (prd_cd,cat_cd) DO UPDATE (main_cat_yn·disp_seq·upd_dt 갱신).",
    "",
    "BEGIN;",
    "",
    "-- [가드 1] 타깃 카테고리 노드 전부 활성(del_yn='N') 검증 — 하나라도 비활성이면 예외로 ROLLBACK",
    "DO $$",
    "DECLARE bad int;",
    "BEGIN",
    "  SELECT count(*) INTO bad FROM (VALUES",
]
apply_lines += ["    (" + sql_str(c) + ")" + ("," if i < len(cat_list) - 1 else "")
                for i, c in enumerate(cat_list)]
apply_lines += [
    "  ) AS t(cat_cd)",
    "  LEFT JOIN t_cat_categories c ON c.cat_cd = t.cat_cd",
    "  WHERE c.cat_cd IS NULL OR c.del_yn <> 'N';",
    "  IF bad > 0 THEN",
    "    RAISE EXCEPTION '[GUARD] % 개 타깃 cat_cd가 부재/비활성(del_yn<>N) — 적재 중단', bad;",
    "  END IF;",
    "END $$;",
    "",
    "-- [가드 2] 적재 prd_cd 전부 실재(t_prd_products, del_yn='N') 검증",
    "DO $$",
    "DECLARE bad int;",
    "BEGIN",
    "  SELECT count(*) INTO bad FROM (VALUES",
]
apply_lines += ["    (" + sql_str(p) + ")" + ("," if i < len(prd_list) - 1 else "")
                for i, p in enumerate(prd_list)]
apply_lines += [
    "  ) AS t(prd_cd)",
    "  LEFT JOIN t_prd_products p ON p.prd_cd = t.prd_cd AND p.del_yn = 'N'",
    "  WHERE p.prd_cd IS NULL;",
    "  IF bad > 0 THEN",
    "    RAISE EXCEPTION '[GUARD] % 개 prd_cd가 부재/비활성 — 적재 중단', bad;",
    "  END IF;",
    "END $$;",
    "",
] + rebalance_lines() + [
    "-- [INSERT] 멱등 UPSERT (PK = prd_cd, cat_cd)",
    "INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, reg_dt)",
    "VALUES",
]
val_lines = []
for i, r in enumerate(sorted(rows, key=lambda x: (x["cat_cd"], x["prd_cd"]))):
    comma = "," if i < len(rows) - 1 else ""
    val_lines.append("  (%s, %s, %s, %d, now())%s  -- %s → %s" % (
        sql_str(r["prd_cd"]), sql_str(r["cat_cd"]), sql_str(r["main_cat_yn"]),
        r["disp_seq"], comma, r["prd_nm"], r["cat_nm"]))
apply_lines += val_lines
apply_lines += [
    "ON CONFLICT (prd_cd, cat_cd) DO UPDATE SET",
    "  main_cat_yn = EXCLUDED.main_cat_yn,",
    "  disp_seq    = EXCLUDED.disp_seq,",
    "  upd_dt      = now();",
    "",
    "-- [main 단일성 사후 가드] 적재 36 prd_cd 각각 main='Y' 정확히 1행인지 검증",
    "DO $$",
    "DECLARE viol int;",
    "BEGIN",
    "  SELECT count(*) INTO viol FROM (",
    "    SELECT prd_cd FROM t_prd_product_categories",
    "    WHERE prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ")",
    "      AND main_cat_yn='Y'",
    "    GROUP BY prd_cd HAVING count(*) <> 1",
    "  ) v;",
    "  IF viol > 0 THEN",
    "    RAISE EXCEPTION '[GUARD] % 개 prd_cd가 main=Y 단일성 위반 — ROLLBACK 권고', viol;",
    "  END IF;",
    "END $$;",
    "",
    "COMMIT;",
    "-- 멱등: 2회 실행 시 INSERT 0·UPDATE 36(upd_dt만 갱신)·신규 0 — DRY-RUN으로 실증.",
]
with open(os.path.join(BASE, "apply-green.sql"), "w", encoding="utf-8") as f:
    f.write("\n".join(apply_lines) + "\n")

# ============ backup-green.sql ============
backup_lines = [
    "-- round-24 2단계 · 적재 전 백업 (backup-green.sql) — undo 근거",
    "-- 영향 prd_cd(36)의 기존 junction 행 전부 캡처. 실행 결과를 파일/테이블로 보존 후 적재.",
    "-- 권장: psql \\copy 또는 CREATE TABLE bak_pc_green_<ts> AS SELECT ... 로 스냅샷.",
    "",
    "-- (A) 영향 prd_cd의 현재 junction 전수 SELECT (적재 전 상태)",
    "SELECT prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt",
    "FROM t_prd_product_categories",
    "WHERE prd_cd IN (",
    "  " + ", ".join(sql_str(p) for p in prd_list),
    ")",
    "ORDER BY prd_cd, cat_cd;",
    "",
    "-- (B) 백업 테이블 스냅샷 예시(실행자 선택):",
    "-- CREATE TABLE bak_pc_green_20260618 AS",
    "--   SELECT * FROM t_prd_product_categories",
    "--   WHERE prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list[:3]) + ", ... );",
    "",
    "-- undo: 적재 후 문제 시 → bak 스냅샷으로 해당 prd_cd 행 복원(DELETE 영향행 + INSERT 백업행).",
]
with open(os.path.join(BASE, "backup-green.sql"), "w", encoding="utf-8") as f:
    f.write("\n".join(backup_lines) + "\n")

# ============ dryrun-green.sql ============
dry_lines = [
    "-- round-24 2단계 · 롤백전용 DRY-RUN (dryrun-green.sql)",
    "-- BEGIN … ROLLBACK — 실 변경 없이 INSERT/UPDATE 건수·제약위반 0·FK 고아 0 실측.",
    "-- 사용: psql -f dryrun-green.sql (NOTICE로 집계 출력 후 전부 ROLLBACK).",
    "",
    "BEGIN;",
    "",
    "-- 적재 전 영향행 수",
    "CREATE TEMP TABLE _before AS",
    "  SELECT prd_cd, cat_cd, main_cat_yn FROM t_prd_product_categories",
    "  WHERE prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ");",
    "",
] + rebalance_lines() + [
    "-- 본 적재(apply-green.sql 본문과 동일한 UPSERT)",
    "INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, disp_seq, reg_dt)",
    "VALUES",
]
dry_lines += val_lines
dry_lines += [
    "ON CONFLICT (prd_cd, cat_cd) DO UPDATE SET",
    "  main_cat_yn = EXCLUDED.main_cat_yn,",
    "  disp_seq    = EXCLUDED.disp_seq,",
    "  upd_dt      = now();",
    "",
    "-- 집계: 신규 INSERT vs 기존 UPDATE 추정",
    "DO $$",
    "DECLARE total int; pre int; ins int; upd int; orphan_cat int; orphan_prd int; mainviol int;",
    "BEGIN",
    "  SELECT count(*) INTO total FROM t_prd_product_categories",
    "    WHERE prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ")",
    "      AND cat_cd IN (" + ", ".join(sql_str(c) for c in cat_list) + ");",
    "  SELECT count(*) INTO pre FROM _before b",
    "    WHERE (b.prd_cd, b.cat_cd) IN (",
] + [
    "      (" + sql_str(r["prd_cd"]) + ", " + sql_str(r["cat_cd"]) + ")"
    + ("," if i < len(rows) - 1 else "")
    for i, r in enumerate(sorted(rows, key=lambda x: (x["cat_cd"], x["prd_cd"])))
] + [
    "    );",
    "  ins := " + str(len(rows)) + " - pre;",
    "  upd := pre;",
    "  total := total;  -- noqa (참조용)",
    "  -- FK 고아: 적재된 (prd,cat) 중 노드/상품 미존재",
    "  SELECT count(*) INTO orphan_cat FROM t_prd_product_categories pc",
    "    LEFT JOIN t_cat_categories c ON c.cat_cd=pc.cat_cd",
    "    WHERE pc.cat_cd IN (" + ", ".join(sql_str(c) for c in cat_list) + ") AND c.cat_cd IS NULL;",
    "  SELECT count(*) INTO orphan_prd FROM t_prd_product_categories pc",
    "    LEFT JOIN t_prd_products p ON p.prd_cd=pc.prd_cd",
    "    WHERE pc.prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ") AND p.prd_cd IS NULL;",
    "  -- del='Y' 노드 귀속 0",
    "  SELECT count(*) INTO orphan_cat FROM t_prd_product_categories pc",
    "    JOIN t_cat_categories c ON c.cat_cd=pc.cat_cd",
    "    WHERE pc.prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ")",
    "      AND pc.cat_cd IN (" + ", ".join(sql_str(c) for c in cat_list) + ")",
    "      AND c.del_yn <> 'N';",
    "  SELECT count(*) INTO mainviol FROM (",
    "    SELECT prd_cd FROM t_prd_product_categories",
    "      WHERE prd_cd IN (" + ", ".join(sql_str(p) for p in prd_list) + ") AND main_cat_yn='Y'",
    "      GROUP BY prd_cd HAVING count(*)<>1) v;",
    "  RAISE NOTICE 'DRY-RUN GREEN: 적재대상행 " + str(len(rows)) + ", 기존존재 %, 추정 INSERT %, 추정 UPDATE %', pre, ins, upd;",
    "  RAISE NOTICE '  FK고아(cat비활성/부재) %, FK고아(prd부재) %, main단일성위반 %', orphan_cat, orphan_prd, mainviol;",
    "END $$;",
    "",
    "ROLLBACK;",
    "-- 전부 롤백 — 실 변경 없음. 위 NOTICE 집계로 적재가능성 판정.",
]
with open(os.path.join(BASE, "dryrun-green.sql"), "w", encoding="utf-8") as f:
    f.write("\n".join(dry_lines) + "\n")

print("생성 완료:")
print("  apply-green.sql  · UPSERT 36행 + 3 가드(노드활성·prd실재·main단일성)")
print("  backup-green.sql · 영향 36 prd_cd 기존 junction SELECT 백업")
print("  dryrun-green.sql · BEGIN…ROLLBACK 집계(INSERT/UPDATE/FK고아/main위반)")
print("적재 행:", len(rows), "| distinct prd_cd:", len(prd_list), "| distinct cat_cd:", len(cat_list))
